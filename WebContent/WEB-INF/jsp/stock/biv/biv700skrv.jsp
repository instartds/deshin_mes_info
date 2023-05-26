<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv700skrv">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B018"/>	<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>	<!-- 품목계정 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

function appMain() {
	var BsaCodeInfo={
		'gsBomPathYN'	:'${gsBomPathYN}',		//BOM PATH 관리여부(B082)
		'gsExchgRegYN'	:'${gsExchgRegYN}',		//대체품목 등록여부(B081)
		'gsItemCheck'	:'PROD'					//품목구분(PROD:모품목, CHILD:자품목)
	}

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('biv700skrvModel', {
		fields: [
			{name: 'INOUT_DATE',		text:'일자'			,type:'string'},
			{name: 'ITEM_CODE',			text:'품목코드'			,type:'string'},
			{name: 'ITEM_STATUS',		text:'품목상태',type:'string'},
			{name: 'ITEM_STATUS_NAME',	text:'품목상태',type:'string'},
			{name: 'INOUT_TYPE'	,		text:'구분',type:'string'},
			{name: 'INOUT_TYPE_NAME',	text:'구분',type:'string'},
			{name: 'IN_Q'	,			text:'입고량',type:'uniQty'},
			{name: 'OUT_Q'	,			text:'출고량',type:'uniQty'},
			{name: 'INOUT_NUM'	,		text:'수불번호',type:'string'},
			{name: 'INOUT_SEQ'	,		text:'수불순번',type:'string'},
			{name: 'MOVE_TYPE'	,		text:'MOVE_TYPE',type:'string'},
			{name: 'MOVE_TYPE_NAME'	,	text:'수불유형',type:'string'},
			{name: 'WH_CODE'	,		text:'창고',type:'string'},
			{name: 'WH_NAME'	,		text:'창고',type:'string'},
			{name: 'CREATE_LOC'	,		text:'생성경로',type:'string'},
			{name: 'CREATE_LOC_NAME',	text:'생성경로',type:'string'},
			{name: 'INOUT_CODE'		,	text:'수불처',type:'string'},
			{name: 'INOUT_CODE_NAME',	text:'수불처명',type:'string'},
			{name: 'BASIS_NUM'		,	text:'근거번호',type:'string'},
			{name: 'BASIS_SEQ'		,	text:'근거순번',type:'string'},
			{name: 'ORDER_NUM'		,	text:'수/발주번호',type:'string'},
			{name: 'ORDER_SEQ'		,	text:'수/발주순번',type:'string'},
			{name: 'INSPEC_NUM'		,	text:'검사번호',type:'string'},
			{name: 'INSPEC_SEQ'		,	text:'검사순번',type:'string'},
			{name: 'UPDATE_DB_TIME'	,	text:'저장일시',type:'string'},
			{name: 'INOUT_PRSN'		,	text:'담당자',type:'string'},
			{name: 'INOUT_PRSN_NAME',	text:'담당자명',type:'string'},
		    {name: 'REMARK'			,	text:'비고',type:'string'},
		    {name: 'STOCK_Q'		,	text:'재고량',type:'uniQty'}

		]
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('biv700skrvDetailModel', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'			,type: 'string', defaultValue: UserInfo.compCode},
			{name: 'DIV_CODE'		,text:'<t:message code="system.label.base.division" default="사업장"/>'				,type:'string'},
			{name: 'PROD_ITEM_CODE'	,text:'<t:message code="system.label.base.parentitemcode" default="모품목코드"/>'		,type:'string'},
			{name: 'CHILD_ITEM_CODE',text: '<t:message code="system.label.base.childitemcode" default="자품목코드"/>'		,type: 'string', defaultValue: '$'},
			{name: 'ITEM_CODE'		,text:'<t:message code="system.label.base.itemcode" default="품목코드"/>'				,type:'string'},
			{name: 'ITEM_NAME'		,text:'<t:message code="system.label.base.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'			,text:'<t:message code="system.label.base.spec" default="규격"/>'						,type:'string'},
			{name: 'START_DATE'		,text: '<t:message code="system.label.base.startdate" default="시작일"/>'				,type: 'uniDate', defaultValue: UniDate.get('today')},
			{name: 'STOP_DATE'		,text: '<t:message code="system.label.base.enddate" default="종료일"/>'				,type: 'uniDate', defaultValue: '2999.12.31'},
			{name: 'STOCK_UNIT'		,text:'<t:message code="system.label.base.inventoryunit" default="재고단위"/>'			,type:'string'},
			{name: 'UNIT_Q'			,text:'<t:message code="system.label.base.originunitqty" default="원단위량"/>'			,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'PROD_UNIT_Q'	,text:'<t:message code="system.label.base.parentitembaseqty" default="모품목기준수"/>'	,type:'uniQty'},
			{name: 'LOSS_RATE'		,text:'<t:message code="system.label.base.lossrate" default="LOSS율"/>'				,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'SEQ'			,text:'<t:message code="system.label.base.seq" default="순번"/>'						,type:'string'},
			{name: 'ITEM_ACCOUNT'	,text:'<t:message code="system.label.base.itemaccount" default="품목계정"/>'			,type:'string', comboType:'AU', comboCode:'B020'}
		]
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('biv700skrvDetailModel_1', {
		fields: [
						{name: 'PRODT_DATE'		,text: '작업일자'	,type: 'uniDate'},
						{name: 'WORK_SHOP_CODE'	,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	,type: 'string'},
						{name: 'TREE_NAME'		,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	,type: 'string'},
						{name: 'PROG_WORK_CODE'	,text: '공정코드'	,type: 'string'},
						{name: 'PROG_WORK_NAME'	,text: '공정명'	,type: 'string'},
						{name: 'FR_TIME'		,text: '시작'	,type: 'string'},
						{name: 'TO_TIME'		,text: '종료'	,type: 'string'},
						{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	,type: 'string'},
						{name: 'ITEM_CODE'		,text: '<t:message code="system.label.product.item" default="품목"/>'				,type: 'string'},
						{name: 'ITEM_NAME'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'		,type: 'string'},
						{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type: 'string'},
						{name: 'CODE_NAME'		,text: '상태'	,type: 'string'},
						{name: 'WKORD_Q'		,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	,type: 'uniQty'},
						{name: 'WORK_Q'			,text: '<t:message code="system.label.product.workqty" default="생산량"/>'			,type: 'uniQty'},
						{name: 'PRODT_Q'		,text: '<t:message code="system.label.product.productionqty" default="양품량"/>'	,type: 'uniQty'},
						{name: 'LOT_NO'			,text: 'LOT NO'	,type: 'string'},
						{name: 'MAN_HOUR'		,text: '<t:message code="system.label.product.inputtimesum" default="투입공수합계"/>'	,type: 'uniQty'},
						{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'			,type: 'string'},
						//20190621 설비코드, 명 추가
						{name: 'EQUIP_CODE'		,text:'<t:message code="system.label.product.facilities" default="설비코드"/>'		,type: 'string'},
						{name: 'EQUIP_NAME'		,text:'<t:message code="system.label.product.facilitiesname" default="설비명"/>'	,type: 'string'},
						{name: 'ORDER_NUM'		,text:'수주번호',type:'string'}
		]
	});
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('biv700skrvDetailModel_2', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type:'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'					, type:'string'},
			{name: 'WKORD_STATUS'		, text:'<t:message code="system.label.product.status" default="상태"/>'						, type:'string'},
			{name: 'WKORD_STATUS_NAME'	, text: '<t:message code="system.label.product.status" default="상태"/>'						, type:'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'			, type:'string'},
			{name: 'WORK_SHOP_NAME'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'					, type:'string'},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				, type:'string'},
			{name: 'PITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'						, type:'string'},
			{name: 'PITEM_NAME'			, text: '<t:message code="system.label.product.itemnamespec" default="품명 / 규격"/>'			, type:'string'},
			{name: 'OPITEM_NAME'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'					, type:'string'},
			{name: 'OPITEM_NAME1'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>1'					, type:'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'						, type:'string'},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'				, type:'uniQty'},
			{name: 'GOOD_PRODT_Q'		, text: '<t:message code="system.label.product.productiongoodqty" default="생산양품량"/>'		, type:'uniQty'},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'			, type:'uniDate'},
			{name: 'PRODT_END_DATE'		, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'			, type:'uniDate'},
			{name: 'CITEM_CODE'			, text: '<t:message code="system.label.product.materialitemcode" default="자재품목코드"/>'		, type:'string'},
			{name: 'CITEM_NAME'			, text: '<t:message code="system.label.product.materialitemanamespec" default="자재품명/규격"/>'	, type:'string'},
			{name: 'OCITEM_NAME'		, text: '<t:message code="system.label.product.materialitemname" default="자재품명"/>'			, type:'string'},
			{name: 'OCITEM_NAME1'		, text: '<t:message code="system.label.product.materialitemname" default="자재품명"/>1'			, type:'string'},
			{name: 'CITEM_LOT_NO'		, text: '<t:message code="system.label.product.materiallot" default="자재LOT"/>'				, type:'string'},
			{name: 'CSTOCK_UNIT'		, text: '<t:message code="system.label.product.unit" default="단위"/>'						, type:'string'},
			{name: 'UNIT_Q'				, text: '<t:message code="system.label.product.originunitqty" default="원단위량"/>'				, type:'uniQty'},
			{name: 'ALLOCK_Q'			, text: '<t:message code="system.label.product.allocationqty" default="예약량"/>'				, type:'uniQty'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.productioninputqty" default="생산투입량"/>'		, type:'uniQty'},
			{name: 'UN_PRODT_Q'			, text: '<t:message code="system.label.product.productionnotinputqty" default="생산미투입량"/>'	, type:'uniQty'},
			{name: 'OUTSTOCK_REQ_DATE'	, text: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>'			, type:'uniDate'},
			{name: 'WH_CODE'			, text: 'WH_CODE'	, type:'string'},
			{name: 'WH_CODE_NAME'		, text: '<t:message code="system.label.product.requestwarehouse" default="요청창고"/>'			, type:'string'},
			{name: 'OUT_METH'			, text: 'OUT_METH'	, type:'string'},
			{name: 'OUT_METH_NAME'		, text: '<t:message code="system.label.product.issuemethod" default="출고방법"/>'				, type:'string'},
			{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.product.requestwarehousestock" default="요청창고재고"/>'	, type:'uniQty'},
			{name: 'OUTSTOCK_REQ_Q' 	, text: '<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'			, type:'uniQty'},
			{name: 'OUTSTOCK_Q'			, text: '<t:message code="system.label.product.issueqty" default="출고량"/>'					, type:'uniQty'},
			{name: 'LOT_NO'			, text: 'LOT NO'	, type:'string'},
			{name: 'UN_OUTSTOCK_Q'		, text: '<t:message code="system.label.product.unissuedqty" default="미출고량"/>'				, type:'uniQty'},
			{name: 'MINI_PACK_Q'		, text: '<t:message code="system.label.product.minimumpackagingunit" default="최소포장단위"/>'	, type:'string'}

		]
	});
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('biv700skrvDetailModel_3', {
		fields: [
		{name: 'INOUT_DATE',		text:'일자'			,type:'string'},
			{name: 'ITEM_CODE',			text:'품목코드'			,type:'string'},
			{name: 'ITEM_STATUS',		text:'품목상태',type:'string'},
			{name: 'ITEM_STATUS_NAME',	text:'품목상태',type:'string'},
			{name: 'INOUT_TYPE'	,		text:'구분',type:'string'},
			{name: 'INOUT_TYPE_NAME',	text:'구분',type:'string'},
			{name: 'IN_Q'	,			text:'입고량',type:'uniQty'},
			{name: 'OUT_Q'	,			text:'출고량',type:'uniQty'},
			{name: 'INOUT_NUM'	,		text:'수불번호',type:'string'},
			{name: 'INOUT_SEQ'	,		text:'수불순번',type:'string'},
			{name: 'MOVE_TYPE'	,		text:'MOVE_TYPE',type:'string'},
			{name: 'MOVE_TYPE_NAME'	,	text:'수불유형',type:'string'},
			{name: 'WH_CODE'	,		text:'창고',type:'string'},
			{name: 'WH_NAME'	,		text:'창고',type:'string'},
			{name: 'CREATE_LOC'	,		text:'생성경로',type:'string'},
			{name: 'CREATE_LOC_NAME',	text:'생성경로',type:'string'},
			{name: 'INOUT_CODE'		,	text:'수불처',type:'string'},
			{name: 'INOUT_CODE_NAME',	text:'수불처명',type:'string'},
			{name: 'BASIS_NUM'		,	text:'근거번호',type:'string'},
			{name: 'BASIS_SEQ'		,	text:'근거순번',type:'string'},
			{name: 'ORDER_NUM'		,	text:'수/발주번호',type:'string'},
			{name: 'ORDER_SEQ'		,	text:'수/발주순번',type:'string'},
			{name: 'INSPEC_NUM'		,	text:'검사번호',type:'string'},
			{name: 'INSPEC_SEQ'		,	text:'검사순번',type:'string'},
			{name: 'UPDATE_DB_TIME'	,	text:'저장일시',type:'string'},
			{name: 'INOUT_PRSN'		,	text:'담당자',type:'string'},
			{name: 'INOUT_PRSN_NAME',	text:'담당자명',type:'string'},
		    {name: 'REMARK'			,	text:'비고',type:'string'},
		    {name: 'LOT_NO'			, 	text:'LOT NO'	, type:'string'}
		]
	});
	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('biv700skrvMasterStore', {
		model	: 'biv700skrvModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'biv700skrvService.selectMasterList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: ''
		,
		listeners: {
			load: function(store, records, successful, eOpts) {
					if(successful)  {
						panelResult.setValue('IN_Q',store.sum('IN_Q'));
						panelResult.setValue('OUT_Q',store.sum('OUT_Q'));
						if(!Ext.isEmpty(records[0])){
							panelResult.setValue('STOCK_Q',records[0].get('STOCK_Q'));
						}
					}
			}
		}
	});

	var directDetailStore = Unilite.createStore('biv700skrvDetailStore', {
		model	: 'biv700skrvDetailModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'biv700skrvService.selectDetailList'
			}
		},
		loadStoreRecords: function(record) {
			var param= Ext.getCmp('searchForm').getValues();
			if(record) {
				param.ITEM_CODE = record.get('ITEM_CODE');
			}
			param.ITEM_SEARCH = 'C';
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: ''
	});

	var directChildStore1 = Unilite.createStore('biv700skrvChildStore_1', {
		model	: 'biv700skrvDetailModel_1',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'biv700skrvService.selectDetailChildList1'
			}
		},
		loadStoreRecords: function(record) {
			var param= Ext.getCmp('searchForm').getValues();
			if(record) {
					param.CHILD_ITEM_CODE = record.get('ITEM_CODE');
			}
			param.ITEM_SEARCH = 'C';
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: ''
	});
	var directChildStore2 = Unilite.createStore('biv700skrvChildStore_2', {
		model	: 'biv700skrvDetailModel_2',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'biv700skrvService.selectDetailChildList2'
			}
		},
		loadStoreRecords: function(record) {
			var param= Ext.getCmp('searchForm').getValues();
			if(record) {
				param.CHILD_ITEM_CODE = record.get('ITEM_CODE');
				param.WKORD_NUM = record.get('WKORD_NUM');
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: ''
	});
	var directChildStore3 = Unilite.createStore('biv700skrvChildStore_3', {
		model	: 'biv700skrvDetailModel_3',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'biv700skrvService.selectDetailChildList3'
			}
		},
		loadStoreRecords: function(record) {
			var param= Ext.getCmp('searchForm').getValues();
			if(record) {
				param.CHILD_ITEM_CODE = record.get('CITEM_CODE');
				param.LOT_NO = record.get('CITEM_LOT_NO');
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: ''
	});
	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
			title		: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
				name		: 'DIV_CODE',
				value		: UserInfo.divCode,
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.base.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				allowBlank	: false,
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('ITEM_NAME', '');

							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('ITEM_CODE', '');

							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({
							'DIV_CODE'		: panelSearch.getValue('DIV_CODE'),
							'ITEM_ACCOUNT'	: panelSearch.getValue('ITEM_ACCOUNT')
						});
						if(panelSearch.down('#optsel').getChecked()[0].inputValue == "0"){
							popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20','40']});
						}
					}
				}
			}),/*,{
				fieldLabel	: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
				name		: 'ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			}*/
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
				holdable: 'hold',
				//20200206 주석
	//			allowBlank: false,
	//			colspan: 2,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);

						},
						scope: this
					},
					onClear: function(type) {

					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
					}
				}
			}),{
				xtype: 'uniTextfield',
				fieldLabel:'수주번호',
				name: 'ORDER_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM', newValue);
					}
				}
			}
			/*,{
				xtype		: 'uniCombobox',
				fieldLabel	: '<t:message code="system.label.base.useyn" default="사용여부"/>',
				name		: 'USE_YN',
				comboType	: 'AU',
				comboCode	: 'B018',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('USE_YN', newValue);
					}
				}
			}*/,{
				fieldLabel	: '<t:message code="system.label.base.deploymentgubun" default="전개구분"/>',
				xtype		: 'radiogroup',
				itemId		: 'optsel',
				items		: [{
					boxLabel	: '역방향',
					name		: 'OPTSEL',
					inputValue	: '1',
					width		: 120,
					checked		: true
				}, {
					boxLabel	: '정방향',
					name		: 'OPTSEL',
					inputValue	: '0',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('OPTSEL').setValue(newValue.OPTSEL);

					}
				}
			}/*,{
				xtype: 'uniTextfield',
				fieldLabel:'LOT_NO',
				name: 'LOT_NO',
				allowBlank	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('LOT_NO', newValue);
					}
				}
			}*/
			,Unilite.popup('LOTNO',{
	        	fieldLabel: 'LOT NO',
	        	holdable: 'hold',
	        //	allowBlank:false,
	        	textFieldName: 'LOT_NO',
				DBtextFieldName: 'LOT_NO',
	        	listeners: {
	        		onSelected: {
	        			fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('LOT_NO',records[0].LOT_NO);
							panelResult.setValue('ITEM_CODE', records[0].ITEM_CODE);
							panelResult.setValue('ITEM_NAME', records[0].ITEM_NAME);

                    	},
						scope: this
					},applyextparam: function(popup){
							popup.setExtParam({'ITEM_CODE': panelSearch.getValue('ITEM_CODE')});
							popup.setExtParam({'ITEM_NAME': panelSearch.getValue('ITEM_NAME')});
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							popup.setExtParam({'STOCK_YN': ''});

					}
				}
			})
				,{
        		fieldLabel: '기간',
        		xtype: 'uniDateRangefield',
        		startFieldName: 'ORDER_DATE_FR',
        		endFieldName: 'ORDER_DATE_TO',
        		startDate: UniDate.get('startOfMonth'),
        		endDate: UniDate.get('today'),
        		allowBlank:true,
        		width:315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);

                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},{
					xtype: 'uniTextfield',
					fieldLabel:'작업지시번호',
					name: 'WKORD_NUM',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WKORD_NUM', newValue);
						}
					}
			}/*,{//코디에서 사용하는 프로그램: 집약정전개 조회(bpr530skrv), 제조BOM 등록(bpr560ukrv), 연구소처방등록(bpr580ukrv), 제조BOM 조회(bpr581skrv), 기본정보등록(mba030ukrv - 외주P/L 조회) - 20190718일 PATH_CODE 관련 조회조건 주석 (윤전무님)으로 신규 프로그램에서도 주석
				xtype		: 'uniRadiogroup',
				fieldLabel	: '<t:message code="system.label.base.standardpathyn" default="표준Path 여부"/>',
				name		: 'StPathY',
				comboType	: 'AU',
				comboCode	: 'A020',
				width		: 284,
				hidden		: BsaCodeInfo.gsBomPathYN =='Y' ? false:true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('StPathY').setValue(newValue.StPathY);
					}
				}
			}*/]
		}]
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.base.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			allowBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('ITEM_NAME', '');

						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('ITEM_CODE', '');

						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({
						'DIV_CODE'		: panelSearch.getValue('DIV_CODE'),
						'ITEM_ACCOUNT'	: panelSearch.getValue('ITEM_ACCOUNT')
					});
					if(panelResult.down('#optsel').getChecked()[0].inputValue == "0"){
						popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20','40']});
					}
				}
			}
		})/*,{
			fieldLabel	: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		}*/,
		Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
			holdable: 'hold',
			//20200206 주석
//			allowBlank: false,
//			colspan: 2,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);

					},
					scope: this
				},
				onClear: function(type) {

				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),{
			xtype: 'uniTextfield',
			fieldLabel:'수주번호',
			name: 'ORDER_NUM',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_NUM', newValue);
				}
			}
		}/*,{
			xtype		: 'uniCombobox',
			fieldLabel	: '<t:message code="system.label.base.useyn" default="사용여부"/>',
			name		: 'USE_YN',
			comboType	: 'AU',
			comboCode	: 'B018',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('USE_YN', newValue);
				}
			}
		}*/,{
				fieldLabel	: '<t:message code="system.label.base.deploymentgubun" default="전개구분"/>',
				xtype		: 'radiogroup',
				itemId		: 'optsel',
				items		: [{
					boxLabel	: '역방향',
					name		: 'OPTSEL',
					inputValue	: '1',
					width		: 120,
					checked		: true
				}, {
					boxLabel	: '정방향',
					name		: 'OPTSEL',
					inputValue	: '0',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('OPTSEL').setValue(newValue.OPTSEL);
						directMasterStore.loadData({});
						directDetailStore.loadData({});
						directChildStore1.loadData({});
						directChildStore2.loadData({});
						directChildStore3.loadData({});
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}/*,{		xtype: 'uniTextfield',
					fieldLabel:'LOT_NO',
					name: 'LOT_NO',
					allowBlank	: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('LOT_NO', newValue);
						}
					}
				}*/
			,Unilite.popup('LOTNO',{
	        	fieldLabel: 'LOT NO',
	        	holdable: 'hold',
	        	//allowBlank:false,
	        	textFieldName: 'LOT_NO',
				DBtextFieldName: 'LOT_NO',
	        	listeners: {
	        		onSelected: {
	        			fn: function(records, type) {
							console.log('records : ', records);
							panelSearch.setValue('LOT_NO',records[0].LOT_NO);
							panelSearch.setValue('ITEM_CODE', records[0].ITEM_CODE);
							panelSearch.setValue('ITEM_NAME', records[0].ITEM_NAME);
                    	},
						scope: this
					},applyextparam: function(popup){
							popup.setExtParam({'ITEM_CODE': panelResult.getValue('ITEM_CODE')});
							popup.setExtParam({'ITEM_NAME': panelResult.getValue('ITEM_NAME')});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});

					}
				}
			})
				,{  	fieldLabel: '기간',
	            		xtype: 'uniDateRangefield',
	            		startFieldName: 'ORDER_DATE_FR',
	            		endFieldName: 'ORDER_DATE_TO',
	            		startDate: UniDate.get('startOfMonth'),
	            		endDate: UniDate.get('today'),
	            		allowBlank:true,
	            		width:315,
						onStartDateChange: function(field, newValue, oldValue, eOpts) {
		                	if(panelResult) {
								panelSearch.setValue('ORDER_DATE_FR',newValue);

		                	}
					    },
					    onEndDateChange: function(field, newValue, oldValue, eOpts) {
					    	if(panelResult) {
					    		panelSearch.setValue('ORDER_DATE_TO',newValue);
					    	}
					    }
				},{
					xtype: 'uniTextfield',
					fieldLabel:'작업지시번호',
					name: 'WKORD_NUM',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('WKORD_NUM', newValue);
						}
					}
				},{
		    			xtype: 'component',
		    			colspan: 4,
		    			autoEl: {
		        			html: '<hr width="1150px">'
		    			}
				},{
					xtype: 'uniNumberfield',
					fieldLabel:'입고량',
					name: 'IN_Q',
					type:'uniQty',
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {

						}
					}
				},{
					xtype: 'uniNumberfield',
					fieldLabel:'출고량',
					name: 'OUT_Q',
					type:'uniQty',
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {

						}
					}
				},{
					xtype: 'uniNumberfield',
					fieldLabel:'재고량',
					name: 'STOCK_Q',
					type:'uniQty',
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {

						}
					}
				}/*,{//코디에서 사용하는 프로그램: 집약정전개 조회(bpr530skrv), 제조BOM 등록(bpr560ukrv), 연구소처방등록(bpr580ukrv), 제조BOM 조회(bpr581skrv), 기본정보등록(mba030ukrv - 외주P/L 조회) - 20190718일 PATH_CODE 관련 조회조건 주석 (윤전무님)으로 신규 프로그램에서도 주석
					xtype		: 'uniRadiogroup',
					fieldLabel	: '<t:message code="system.label.base.standardpathyn" default="표준Path 여부"/>',
					name		: 'StPathY',
					comboType	: 'AU',
					comboCode	: 'A020',
					width		: 280,
					hidden		: BsaCodeInfo.gsBomPathYN =='Y' ? false:true,
					value		: 'Y',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.getField('StPathY').setValue(newValue.StPathY);
						}
					}
				}*/]
	});



	/** Master Grid1 정의(Grid Panel),
	 * @type
	 */
	var masterGrid = Unilite.createGrid('biv700skrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		flex	: 1.5,
		region	: 'center',
		selModel: 'rowmodel',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{dataIndex: 'INOUT_DATE'		, width: 80	, hidden: false},
			{dataIndex: 'ITEM_CODE'			, width: 80	, hidden: true},
			{dataIndex: 'ITEM_STATUS'		, width: 80	, hidden: true},
			{dataIndex: 'ITEM_STATUS_NAME'	, width: 90	, hidden: false},
			{dataIndex: 'INOUT_TYPE'		, width: 80	, hidden: true},
			{dataIndex: 'INOUT_TYPE_NAME'	, width: 80, hidden: false},
			{dataIndex: 'IN_Q'				, width: 80},
			{dataIndex: 'OUT_Q'				, width: 80},
			{dataIndex: 'INOUT_NUM'			, width: 80	, align: 'center'},
			{dataIndex: 'INOUT_SEQ'			, width: 80	, align: 'center'},
			{dataIndex: 'MOVE_TYPE'			, width: 100, hidden: true},
			{dataIndex: 'MOVE_TYPE_NAME'	, width: 100, hidden: false},
			{dataIndex: 'WH_CODE'			, width: 100, hidden: false},
			{dataIndex: 'WH_NAME'			, width: 80	, hidden: false},
			{dataIndex: 'CREATE_LOC'		, width: 80	, hidden: true},
			{dataIndex: 'CREATE_LOC_NAME'	, width: 90	, hidden: false},
			{dataIndex: 'INOUT_CODE'	 	, width: 80	, hidden: false},
			{dataIndex: 'INOUT_CODE_NAME'	, width: 120},
			{dataIndex: 'BASIS_NUM'			, width: 250},
			{dataIndex: 'BASIS_SEQ'			, width: 250},
			{dataIndex: 'ORDER_NUM'			, width: 80	, align: 'center'},
			{dataIndex: 'ORDER_SEQ'			, width: 80	, align: 'center'},
			{dataIndex: 'INSPEC_NUM'		, width: 100},
			{dataIndex: 'INSPEC_SEQ'		, width: 100, hidden: false},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 100, hidden: false},
			{dataIndex: 'INOUT_PRSN'		, width: 100, hidden: true},
			{dataIndex: 'INOUT_PRSN_NAME'	, width: 100, hidden: false},
			{dataIndex: 'REMARK'		 	, width: 150, hidden: false},
			{dataIndex: 'STOCK_Q'		 	, width: 150, hidden: true}
		],
		listeners:{
			selectionChange: function( gird, selected, eOpts ) {
				directDetailStore.loadStoreRecords(selected[0]);
				directChildStore1.loadStoreRecords(selected[0]);
			}
		}
	});

	var detailGrid = Unilite.createGrid('biv700skrvDetailGrid1', {
		store	: directDetailStore,
		layout	: 'fit',
		region	: 'east',
		flex	: .8,
		title   : 'BOM(정전개&역전개)',
		selModel: 'rowmodel',
		split	: true,
        tbar:     [
					{
						xtype:'label',
						html:'<div style="color:#0033CC;font-weight: bold">자품목의 공정현황을 조회하려면 행 선택 후 더블클릭 해주세요.</div>'

					}
			  ],
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 66	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66	, hidden: true},
			{dataIndex: 'PROD_ITEM_CODE'	, width: 90	, hidden: true},
			{dataIndex: 'CHILD_ITEM_CODE'	, width: 66	, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 250},
			{dataIndex: 'SPEC'				, width: 250},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 80	, align: 'center'},
			{dataIndex: 'STOCK_UNIT'		, width: 80	, align: 'center'},
			{dataIndex: 'UNIT_Q'			, width: 100}
		],
		listeners:{
			selectionChange: function( gird, selected, eOpts ) {

			},onGridDblClick:function(grid, record, cellIndex, colName, eOpts) {
				directChildStore1.loadStoreRecords(record);

			}
		}
	});

	var detailChildGrid1 = Unilite.createGrid('biv700skrvChildGrid1', {
		store	: directChildStore1,
		layout	: 'fit',
		region	: 'east',
		selModel: 'rowmodel',
		//flex	: 2,
		split	: true,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
			{dataIndex: 'PRODT_DATE'	, width: 80	, hidden: false},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 66	, hidden: false},
			{dataIndex: 'TREE_NAME'	, width: 90	, hidden: false},
			{dataIndex: 'PROG_WORK_CODE'	, width: 66	, hidden: false},
			{dataIndex: 'PROG_WORK_NAME'	, width: 120},
			{dataIndex: 'ITEM_CODE'  , width: 100},
			{dataIndex: 'ITEM_NAME'  , width: 100},
			{dataIndex: 'EQUIP_CODE'	, width: 200},
			{dataIndex: 'EQUIP_NAME'      	, width: 200},
			{dataIndex: 'FR_TIME'	, width: 80	, align: 'center'},
			{dataIndex: 'TO_TIME'	, width: 80	, align: 'center'},
			{dataIndex: 'WKORD_NUM'	, width: 100},
			{dataIndex: 'ORDER_NUM'  , width: 110},
			{dataIndex: 'STOCK_UNIT' , width: 100},
			{dataIndex: 'CODE_NAME'  , width: 100},
			{dataIndex: 'WKORD_Q'    , width: 100},
			{dataIndex: 'WORK_Q'     , width: 100},
			{dataIndex: 'PRODT_Q'	 , width: 100},
			{dataIndex: 'LOT_NO'	 , width: 100},
			{dataIndex: 'MAN_HOUR'   , width: 100}


		],
		listeners:{
			selectionChange: function( gird, selected, eOpts ) {
				directChildStore2.loadStoreRecords(selected[0]);
			}
		}
	});
	var detailChildGrid2 = Unilite.createGrid('biv700skrvChildGrid2', {
		store	: directChildStore2,
		layout	: 'fit',
		region	: 'east',
		selModel: 'rowmodel',
		//flex	: 2,
		split	: true,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
			{dataIndex: 'WKORD_NUM'			, width: 66	, hidden: true},
			{dataIndex: 'CITEM_CODE'		, width: 66	, hidden: false},
			{dataIndex: 'CITEM_NAME'		, width: 90	, hidden: false},
			{dataIndex: 'CITEM_LOT_NO'		, width: 66	, hidden: false},
			{dataIndex: 'CSTOCK_UNIT'		, width: 100},
			{dataIndex: 'ALLOCK_Q'			, width: 80},
			{dataIndex: 'PRODT_Q'			, width: 80},
			{dataIndex: 'UN_PRODT_Q'		, width: 80	, align: 'center'},
			{dataIndex: 'OUTSTOCK_REQ_DATE'	, width: 80	, align: 'center'},
			{dataIndex: 'WH_CODE'			, width: 80, hidden: true},
			{dataIndex: 'WH_CODE_NAME'		, width: 80	, align: 'center'},
			{dataIndex: 'OUT_METH'			, width: 100, hidden: true},
			{dataIndex: 'OUT_METH_NAME'		, width: 80	, align: 'center'},
			{dataIndex: 'GOOD_STOCK_Q'		, width: 100},
			{dataIndex: 'OUTSTOCK_REQ_Q'	, width: 100},
			{dataIndex: 'OUTSTOCK_Q'		, width: 100},
			{dataIndex: 'UN_OUTSTOCK_Q'		, width: 100}
		],
		listeners:{
			selectionChange: function( gird, selected, eOpts ) {
				directChildStore3.loadStoreRecords(selected[0]);
			}
		}
	});
	var detailChildGrid3 = Unilite.createGrid('biv700skrvChildGrid3', {
		store	: directChildStore3,
		layout	: 'fit',
		region	: 'east',
		selModel: 'rowmodel',
		//flex	: 2,
		split	: true,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
			{dataIndex: 'INOUT_DATE'		, width: 80	, hidden: false},
			{dataIndex: 'ITEM_CODE'			, width: 80	, hidden: false},
			{dataIndex: 'LOT_NO'			, width: 80	, hidden: false},
			{dataIndex: 'ITEM_STATUS'		, width: 80	, hidden: true},
			{dataIndex: 'ITEM_STATUS_NAME'	, width: 90	, hidden: false},
			{dataIndex: 'INOUT_TYPE'		, width: 80	, hidden: true},
			{dataIndex: 'INOUT_TYPE_NAME'	, width: 80, hidden: false},
			{dataIndex: 'IN_Q'				, width: 80},
			{dataIndex: 'OUT_Q'				, width: 80},
			{dataIndex: 'INOUT_NUM'			, width: 80	, align: 'center'},
			{dataIndex: 'INOUT_SEQ'			, width: 80	, align: 'center'},
			{dataIndex: 'MOVE_TYPE'			, width: 100, hidden: true},
			{dataIndex: 'MOVE_TYPE_NAME'	, width: 100, hidden: false},
			{dataIndex: 'WH_CODE'			, width: 100, hidden: false},
			{dataIndex: 'WH_NAME'			, width: 80	, hidden: false},
			{dataIndex: 'CREATE_LOC'		, width: 80	, hidden: true},
			{dataIndex: 'CREATE_LOC_NAME'	, width: 90	, hidden: false},
			{dataIndex: 'INOUT_CODE'	 	, width: 80	, hidden: false},
			{dataIndex: 'INOUT_CODE_NAME'	, width: 120},
			{dataIndex: 'BASIS_NUM'			, width: 250},
			{dataIndex: 'BASIS_SEQ'			, width: 250},
			{dataIndex: 'ORDER_NUM'			, width: 80	, align: 'center'},
			{dataIndex: 'ORDER_SEQ'			, width: 80	, align: 'center'},
			{dataIndex: 'INSPEC_NUM'		, width: 100},
			{dataIndex: 'INSPEC_SEQ'		, width: 100, hidden: false},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 100, hidden: false},
			{dataIndex: 'INOUT_PRSN'		, width: 100, hidden: true},
			{dataIndex: 'INOUT_PRSN_NAME'	, width: 100, hidden: false},
			{dataIndex: 'REMARK'		 	, width: 150, hidden: false}
		]
	});


	var tab = Unilite.createTabPanel('tabPanel',{
		split: true,
		border : true,
		region:'east',
		items: [
			{	layout: {type: 'vbox', align: 'stretch'},
				title : '공정별생산현황' ,
				id: 'tabBiv700skrv1',
				items: [
					detailChildGrid1
				]
			},
			{	layout: {type: 'vbox', align: 'stretch'},
				title : '예약&출고LOT현황' ,
				id: 'tabBiv700skrv2',
				items: [
					detailChildGrid2
				]
			},
			{	layout: {type: 'vbox', align: 'stretch'},
				title : '품목LOT이력' ,
				id: 'tabBiv700skrv3',
				items: [
					detailChildGrid3
				]
			}

		],
		listeners:  {
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )   {
				if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}
				var newTabId	= newCard.getId();
				var record ;
				if(newTabId == 'tabBiv700skrv1'){
					record = masterGrid.getSelectedRecord();
					directChildStore1.loadStoreRecords(record);

				} else if(newTabId == 'tabBiv700skrv2'){
					record = detailChildGrid1.getSelectedRecord();
					directChildStore2.loadStoreRecords(record);

				} else if(newTabId == 'tabBiv700skrv3'){
					record = detailChildGrid2.getSelectedRecord();
					directChildStore3.loadStoreRecords(record);

				}
			/*	if(UniAppManager.app._needSave()) {
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}
				}*/
			},
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts ) {
//				UniAppManager.setToolbarButtons(['newData', 'delete'], false);
				/*var newTabId	= newCard.getId();
				var record		= detailGrid.getSelectedRecord();
				if(!Ext.isEmpty(record)) {
					if(newTabId == 'pmr100ukrvGrid2'){
						directMasterStore2.loadStoreRecords(record);
						UniAppManager.setToolbarButtons(['newData'], true);
					} else if(newTabId == 'pmr100ukrvGrid3_1'){
						directMasterStore3.loadStoreRecords(record);
						UniAppManager.setToolbarButtons(['newData'], false);
					} else if(newTabId == 'pmr100ukrvGrid5'){
						directMasterStore5.loadStoreRecords(record);
						UniAppManager.setToolbarButtons(['newData'], true);
					} else if(newTabId == 'pmr100ukrvGrid6'){
						directMasterStore6.loadStoreRecords(record);
						UniAppManager.setToolbarButtons(['newData'], true);
					} else if(newTabId == 'pmr100ukrvGrid7_1'){
						directMasterStore8.loadStoreRecords(record);
						UniAppManager.setToolbarButtons(['newData'], false);
					}
				}*/
			}
		}
	});
	Unilite.Main({
		id			: 'biv700skrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [{
							region	: 'center',
							layout	: {type: 'vbox', align: 'stretch'},
							border	: false,
							flex	: 1,
							items	: [masterGrid]
						},{
							region	: 'east',
							layout	: {type: 'vbox', align: 'stretch'},
							border	: false,
							split	: true,
							flex	: 2,
							items	: [detailGrid,
									   tab
									  ]
						},

						panelResult
			]
		},
		panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
			panelSearch.getField('OPTSEL').setValue('C');
			panelSearch.setValue('StPathY'	, 'Y');

			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.getField('OPTSEL').setValue('C');
			panelResult.setValue('StPathY'	, 'Y');

			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
			UniAppManager.setToolbarButtons('reset', true);
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadData({});
			detailGrid.getStore().loadData({});
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			detailGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>