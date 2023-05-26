<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_bpr560ukrv_tw"  >

	<t:ExtComboStore comboType="BOR120"  pgmId="s_bpr560ukrv_tw"/>					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B083"  />						<!-- BOM PATH 정보 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"  />						<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="B097"  />						<!-- 구성여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B140"  />						<!-- 공정그룹 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.x-change-cell {
background-color: #FFFFB4;
}
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	//20210818: 품목팝업 정규화 하면서 panelSearch 삭제
	var masterSelectedGrid = 's_bpr560ukrv_twGrid1';  // Grid1 createRow Default
	var excelWindow; 				//BOM정보 업로드 윈도우 생성
	var BsaCodeInfo={
		'gsBomPathYN'	: '${gsBomPathYN}',		//BOM PATH 관리여부(B082)
		'gsExchgRegYN'	: '${gsExchgRegYN}',	//대체품목 등록여부(B081)
		'gsItemCheck'	: 'PROD',				//품목구분(PROD:모품목, CHILD:자품목)
		'gsSampleCodeYn': '${gsSampleCodeYn}',	//20190607 SAMPLE코드 사용여부(B912) - B912.REF_CODE1, BsaCodeInfo.gsSampleCodeYn
		'gsItemAccount'	: '${gsItemAccount}',	//20190627 SAMPLE코드 사용여부(B912).품목계정 - B912.REF_CODE2, BsaCodeInfo.gsItemAccount
		'gsSeqIncUit'	: '${gsSeqIncUit}'		//21090617 자품목 순번증가 단위 설정(B913)
	}
	var gsSetField	= '${gsSetField}'	//공통코드 (B256) 값 체크


	var gsBomPathYN = false;
	if(BsaCodeInfo.gsBomPathYN =='N') {
		gsBomPathYN = true;
	}

	var bprYnStore = Unilite.createStore('s_bpr560ukrv_twBPRYnStore', {
		fields	: ['text', 'value'],
		data	: [
			{'text':'<t:message code="system.label.base.yes" default="예"/>'		, 'value':'1'},
			{'text':'<t:message code="system.label.base.no" default="아니오"/>'	, 'value':'2'}
		]
	});

	var basisQtyStore = Unilite.createStore('s_bpr560ukrv_twBasisQtyStore', {
		fields	: ['text', 'value'],
		data	: [
			{'text':'1'		, 'value':'1'},
			{'text':'100'	, 'value':'100'}
		]
	});

	/** Model 정의
	 * @type
	 */
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_bpr560ukrv_twService.selectList',
			update	: 's_bpr560ukrv_twService.updateDetail',
			create	: 's_bpr560ukrv_twService.insertDetail',
			destroy	: 's_bpr560ukrv_twService.deleteDetail',
			syncAll	: 's_bpr560ukrv_twService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_bpr560ukrv_twService.selectList2',
			update	: 's_bpr560ukrv_twService.updateDetail2',
			create	: 's_bpr560ukrv_twService.insertDetail2',
			destroy	: 's_bpr560ukrv_twService.deleteDetailGRID2',
			syncAll	: 's_bpr560ukrv_twService.saveAll'
		}
	});

	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_bpr560ukrv_twService.selectList3',
			update	: 's_bpr560ukrv_twService.updateDetailGRID3',
			create	: 's_bpr560ukrv_twService.insertDetail3',
			destroy	: 's_bpr560ukrv_twService.deleteDetailGRID3',
			syncAll	: 's_bpr560ukrv_twService.saveAll'
		}
	});



	Unilite.defineModel('Bpr560ukrvModel1', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'		,type: 'string', defaultValue: UserInfo.compCode},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.base.division" default="사업장"/>'			,type: 'string', defaultValue: UserInfo.divCode},
			{name: 'PROD_ITEM_CODE'		,text: '<t:message code="system.label.base.parentitemcode" default="모품목코드"/>'	,type: 'string' ,allowBlank:false},
			{name: 'CHILD_ITEM_CODE'	,text: '<t:message code="system.label.base.childitemcode" default="자품목코드"/>'	,type: 'string', defaultValue: '$'},
			{name: 'ITEM_LEVEL1'		,text: '<t:message code="system.label.base.majorgroup" default="대분류"/>'			,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
			{name: 'ITEM_LEVEL2'		,text: '<t:message code="system.label.base.middlegroup" default="중분류"/>'		,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
			{name: 'ITEM_LEVEL3'		,text: '<t:message code="system.label.base.minorgroup" default="소분류"/>'			,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.base.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.base.spec" default="규격"/>'				,type: 'string'},
			{name: 'START_DATE'			,text: '<t:message code="system.label.base.startdate" default="시작일"/>'			,type: 'uniDate', defaultValue: UniDate.get('today')},
			{name: 'STOP_DATE'			,text: '<t:message code="system.label.base.enddate" default="종료일"/>'			,type: 'uniDate', defaultValue: '2999.12.31'},
			//20190627 LAB_NO 관련 로직 자품목에서 모품목으로 이동
			{name: 'LAB_NO'				,text: 'LAB_NO'		,type: 'string'},
			{name: 'REQST_ID'			,text: '샘플ID'		,type: 'string'},
			{name: 'SAMPLE_KEY'			,text: 'SAMPLE_KEY'	,type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>'		,type : 'string', comboType:'AU', comboCode:'B020'},
			//20190627 삭제로직 오류로 추가
			{name: 'PATH_CODE'			,text: '<t:message code="system.label.base.pathinfo" default="PATH정보"/>'		,type: 'string', defaultValue:'0', comboType: 'AU', comboCode:'B083'}
		]
	});

	Unilite.defineModel('Bpr560ukrvModel2', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'			,type: 'string' , defaultValue: UserInfo.compCode},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.base.division" default="사업장"/>'				,type: 'string', defaultValue: UserInfo.divCode},
			{name: 'SEQ'				,text: '<t:message code="system.label.base.seq" default="순번"/>'						,type: 'int'},
			{name: 'PROD_ITEM_CODE'		,text: '<t:message code="system.label.base.parentitemcode" default="모품목코드"/>'		,type: 'string'},
			{name: 'PROD_ITEM_NAME'		,text: '<t:message code="system.label.base.parentitemname" default="모품목명"/>'		,type: 'string'},
			{name: 'PROD_SPEC'		    ,text: 'SPEC'																		,type: 'string'},
			{name: 'CHILD_ITEM_CODE'	,text: '<t:message code="system.label.base.childitemcode" default="자품목코드"/>'		,type: 'string' ,allowBlank:false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.base.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.base.itemname" default="품목명"/>1'				,type: 'string'},
			{name: 'ITEM_NAME2'			,text: '<t:message code="system.label.base.itemname" default="품목명"/>2'				,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.base.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.base.unit" default="단위"/>'					,type: 'string'},
			{name: 'OLD_PATH_CODE'		,text: '<t:message code="system.label.base.pathinfo" default="PATH정보"/>'			,type: 'string', defaultValue:'0', comboType: 'AU', comboCode:'B083'},
			{name: 'PATH_CODE'			,text: '<t:message code="system.label.base.pathinfo" default="PATH정보"/>'			,type: 'string', defaultValue:'0', comboType: 'AU', comboCode:'B083'},
			{name: 'UNIT_Q'				,text: '<t:message code="system.label.base.originunitqty" default="원단위량"/>'			,type: 'number', defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000' },
			{name: 'PROD_UNIT_Q'		,text: '<t:message code="system.label.base.parentitembaseqty" default="모품목기준수"/>'	,type: 'number', defaultValue:1},
			{name: 'LOSS_RATE'			,text: '<t:message code="system.label.base.lossrate" default="LOSS율"/>'				,type: 'number', defaultValue:0},
			{name: 'UNIT_P1'			,text: '<t:message code="system.label.base.materialcost" default="재료비"/>'			,type: 'uniPrice', defaultValue:0},
			{name: 'UNIT_P2'			,text: '<t:message code="system.label.base.laborexpenses" default="노무비"/>'			,type: 'uniPrice', defaultValue:0},
			{name: 'UNIT_P3'			,text: '<t:message code="system.label.base.expense" default="경비"/>'					,type: 'uniPrice', defaultValue:0},
			{name: 'MAN_HOUR'			,text: '<t:message code="system.label.base.standardtacttime" default="표준공수"/>'		,type: 'uniQty', defaultValue:0},
			{name: 'USE_YN'				,text: '<t:message code="system.label.base.use" default="사용"/>'						,type: 'string'  , defaultValue:'1' ,store: Ext.data.StoreManager.lookup('s_bpr560ukrv_twBPRYnStore')},
			{name: 'BOM_YN'				,text: '<t:message code="system.label.base.compyn" default="구성여부"/>'				,type: 'string'  , defaultValue:'1' , comboType: 'AU', comboCode:'B097'},
			{name: 'START_DATE'			,text: '<t:message code="system.label.base.compstartdate" default="구성시작일"/>'		,type: 'uniDate' ,allowBlank:false, defaultValue: UniDate.get('today')},
			{name: 'STOP_DATE'			,text: '<t:message code="system.label.base.compenddate" default="구성종료일"/>'			,type: 'uniDate', defaultValue: '2999.12.31'},
			{name: 'REMARK'				,text: '<t:message code="system.label.base.remarks" default="비고"/>'					,type: 'string'},
			//20180516 추가
			{name: 'MATERIAL_CNT'		,text: '<t:message code="system.label.base.qty" default="수량"/>'						,type: 'int'},
			{name: 'SET_QTY'			,text: '<t:message code="system.label.base.stockcountingusagerate" default="실사용률(%)"/>'		,type: 'number', defaultValue:0},
			{name: 'GROUP_CODE'			,text: '<t:message code="system.label.base.routinggroup" default="공정그룹"/>'			,type: 'string'  , comboType: 'AU', comboCode:'B140'},
			{name: 'GRANT_TYPE'			,text: '사급'			,type: 'string', comboType: 'AU', comboCode:'M105'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.base.writer" default="작성자"/>'					,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.base.writtentiem" default="작성시간"/>'			,type: 'string'},
			//20190605 거래처, 구매단가 추가
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.base.maincustomcode" default="주거래처코드"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME' 		,text: '<t:message code="system.label.base.customname" default="거래처명"/>'			,type: 'string'},
			{name: 'PURCHASE_BASE_P'	,text: '<t:message code="system.label.base.purchaseprice" default="구매단가"/>'			,type: 'uniPrice'},
			//20200324 추가: 가중치
			{name: 'WEIGHT_RATE'		,text: '가중치'	,type: 'uniPercent'}
			//20190627 주석 - 모품목에 로직 추가
//			{name: 'LAB_NO'				,text: 'LAB_NO'		,type: 'string'},
//			{name: 'REQST_ID'			,text: '샘플ID'		,type: 'string'},
//			//20190607 SAMPLE_KEY 추가
//			{name: 'SAMPLE_KEY'			,text: 'SAMPLE_KEY'	,type: 'string'}
		]
	});

	Unilite.defineModel('Bpr560ukrvModel3', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'			,type: 'string', defaultValue: UserInfo.compCode},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.base.division" default="사업장"/>'				,type: 'string', defaultValue: UserInfo.divCode},
			{name: 'SEQ'				,text: '<t:message code="system.label.base.seq" default="순번"/>'						,type: 'int'},
			{name: 'PROD_ITEM_CODE'		,text: '<t:message code="system.label.base.parentitemcode" default="모품목코드"/>'		,type: 'string'},
			{name: 'CHILD_ITEM_CODE'	,text: '<t:message code="system.label.base.childitemcode" default="자품목코드"/>'		,type: 'string'},
			{name: 'EXCHG_ITEM_CODE'	,text: '<t:message code="system.label.base.subitemcode" default="대체품목코드"/>'			,type: 'string' ,allowBlank:false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.base.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.base.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.base.unit" default="단위"/>'					,type: 'string'},
			{name: 'UNIT_Q'				,text: '<t:message code="system.label.base.originunitqty" default="원단위량"/>'			,type: 'number', defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000' },
			{name: 'PROD_UNIT_Q'		,text: '<t:message code="system.label.base.parentitembaseqty" default="모품목기준수"/>'	,type: 'number', defaultValue:1},
			{name: 'LOSS_RATE'			,text: '<t:message code="system.label.base.lossrate" default="LOSS율"/>'				,type: 'number', defaultValue:0},
			{name: 'UNIT_P1'			,text: '<t:message code="system.label.base.materialcost" default="재료비"/>'			,type: 'uniPrice', defaultValue:0},
			{name: 'UNIT_P2'			,text: '<t:message code="system.label.base.laborexpenses" default="노무비"/>'			,type: 'uniPrice', defaultValue:0},
			{name: 'UNIT_P3'			,text: '<t:message code="system.label.base.expense" default="경비"/>'					,type: 'uniPrice', defaultValue:0},
			{name: 'MAN_HOUR'			,text: '<t:message code="system.label.base.standardtacttime" default="표준공수"/>'		,type: 'uniQty', defaultValue:0},
			{name: 'USE_YN'				,text: '<t:message code="system.label.base.use" default="사용"/>'						,type: 'string' , defaultValue:'1',store: Ext.data.StoreManager.lookup('s_bpr560ukrv_twBPRYnStore')},
			{name: 'BOM_YN'				,text: '<t:message code="system.label.base.compyn" default="구성여부"/>'				,type: 'string' , defaultValue:'1',store: Ext.data.StoreManager.lookup('s_bpr560ukrv_twBPRYnStore')},
			{name: 'PRIOR_SEQ'			,text: '<t:message code="system.label.base.priority" default="우선순위"/>'				,type: 'string'},
			{name: 'START_DATE'			,text: '<t:message code="system.label.base.compstartdate" default="구성시작일"/>'		,type: 'uniDate',allowBlank:false, defaultValue: UniDate.get('today')},
			{name: 'STOP_DATE'			,text: '<t:message code="system.label.base.compenddate" default="구성종료일"/>'			,type: 'uniDate', defaultValue: '2999.12.31'},
			{name: 'REMARK'				,text: '<t:message code="system.label.base.remarks" default="비고"/>'					,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.base.writer" default="작성자"/>'					,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.base.writtentiem" default="작성시간"/>'			,type: 'string'},
			//20180528 추가
			{name: 'MATERIAL_CNT'		,text: '<t:message code="system.label.base.qty" default="수량"/>'						,type: 'int'},
			{name: 'SET_QTY'			,text: '<t:message code="system.label.base.stockcountingusagerate" default="실사용률(%)"/>'		,type: 'number', defaultValue:0},
			//20200324 추가: 가중치
			{name: 'WEIGHT_RATE'		,text: '가중치'	,type: 'uniPercent'}
		]
	});

	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.s_bpr560ukrv_tw.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'					, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.base.division" default="사업장"/>'						, type: 'string', comboType: 'BOR120' },
			{name: 'SPEC'				, text: '<t:message code="system.label.base.spec" default="규격"/>'							, type: 'string'},
			{name: 'SEQ'				, text: '<t:message code="system.label.base.seq" default="순번"/>'							, type: 'int'},
			{name: 'CHILD_ITEM_CODE'	, text: '<t:message code="system.label.base.childitemcode" default="자품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.base.itemname" default="품목명"/>'						, type: 'string'},					//거래처품목코드
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.base.unit" default="단위"/>'							, type: 'string'	},
			{name: 'UNIT_Q'				, text: '<t:message code="system.label.base.originunitqty" default="원단위량"/>'				, type: 'number', defaultValue:1},	//거래처품명
			{name: 'LOSS_RATE'			, text: '<t:message code="system.label.base.lossrate" default="LOSS율"/>'					, type: 'number', defaultValue:0},
			{name: 'SET_QTY'			, text: '<t:message code="system.label.base.stockcountingusagerate" default="실사용률(%)"/>'	, type: 'number', defaultValue:0},
			{name: 'GRANT_TYPE'			, text: '사급'			,type: 'string', comboType: 'AU', comboCode:'M105'},
			{name: 'REMARK'				, text: '<t:message code="system.label.base.remarks" default="비고"/>'						, type: 'string'},
			{name: 'GROUP_CODE'			, text: '<t:message code="system.label.base.routinggroup" default="공정그룹"/>'					, type: 'string'  , comboType: 'AU', comboCode:'B140'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_bpr560ukrv_twMasterStore1',{
		model	: 'Bpr560ukrvModel1',
		proxy	: directProxy1,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param= panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function(config) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			//20190627 LAB_NO 관련 로직 자품목에서 모품목으로 이동
			var rv = true;
			if(BsaCodeInfo.gsSampleCodeYn == 'Y' ) {
				Ext.each(list, function(record,i) {
					if(Ext.isEmpty(record.get('SAMPLE_KEY')) && record.get('ITEM_ACCOUNT') == BsaCodeInfo.gsItemAccount) {
						Unilite.messageBox('LAB_NO(은)는 필수 입력입니다.');
						rv = false;
						return false;
					}
				});
			}
			if(!rv) return false;

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();   //syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						if(directMasterStore1.getCount() > 0){
							console.log("yes");
//							Ext.getCmp('excelUploadButton').setDisabled(false);
//							Ext.getCmp('COPY_BTN').setDisabled(false);
							Ext.getCmp('BASIS_QTY_COMBO').setDisabled(false);
							//20190627 주석
//							Ext.getCmp('LAB_NO_POPUP').setDisabled(false);
						}else{
							console.log("no");
//							Ext.getCmp('excelUploadButton').setDisabled(true);
//							Ext.getCmp('COPY_BTN').setDisabled(true);
							Ext.getCmp('BASIS_QTY_COMBO').setDisabled(true);
							//20190627 주석
//							Ext.getCmp('LAB_NO_POPUP').setDisabled(true);
						}
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

					}
				};
				this.syncAllDirect(config);

			} else {
				var grid = Ext.getCmp('s_bpr560ukrv_twGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// Unilite.messageBox(Msg.sMB083);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records != null && records.length > 0 ){
					UniAppManager.setToolbarButtons('delete', true);
					panelResult.getField("DIV_CODE").setReadOnly(true);
					masterGrid1.getSelectionModel().select( 0 )
					if(!directMasterStore2.isDirty() && !directMasterStore3.isDirty()) {
						UniAppManager.setToolbarButtons('save', false);
					}else {
						UniAppManager.setToolbarButtons('save', true);
					}
				}else {
					panelResult.getField("DIV_CODE").setReadOnly(false);
				}

				if(directMasterStore1.count() == 0) {
//					Ext.getCmp('COPY_BTN').setDisabled(true);
//					Ext.getCmp('excelUploadButton').setDisabled(true);
					Ext.getCmp('BASIS_QTY_COMBO').setDisabled(true);
					//20190627 주석
//					Ext.getCmp('LAB_NO_POPUP').setDisabled(true);
				} else {
//					Ext.getCmp('COPY_BTN').setDisabled(false);
//					Ext.getCmp('excelUploadButton').setDisabled(false);
					Ext.getCmp('BASIS_QTY_COMBO').setDisabled(false);
					//20190627 주석
//					Ext.getCmp('LAB_NO_POPUP').setDisabled(false);
				}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
					UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
				if( directMasterStore2.isDirty() || directMasterStore3.isDirty() || store.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
				if(store.getCount() > 0 || store.isDirty() ){
					panelResult.getField("DIV_CODE").setReadOnly(true);
				}else {
					panelResult.getField("DIV_CODE").setReadOnly(false);
				}
			}
		}
	});

	var directMasterStore2 = Unilite.createStore('s_bpr560ukrv_twMasterStore2',{
		model	: 'Bpr560ukrvModel2',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(record)	{
			var searchParam= panelResult.getValues();
			var param= {
				'DIV_CODE'		: record.get('DIV_CODE'),
				'PROD_ITEM_CODE': record.get('PROD_ITEM_CODE')};
			if(BsaCodeInfo.gsBomPathYN =='Y' ) {
				param.StPathY = searchParam.StPathY;
			}
			var params = Ext.merge(searchParam, param);
			console.log( param );
			this.load({
				params : params
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				//if(successful)	{
				if(records[0] != null){
					UniAppManager.setToolbarButtons('delete', true);
					masterGrid2.getSelectionModel().select( 0 );
					if(!directMasterStore1.isDirty() && !directMasterStore3.isDirty()) {
						UniAppManager.setToolbarButtons('save', false);
					}
				}
				if(directMasterStore2.getCount() > 0){
					Ext.getCmp('itemExchangeButton').setDisabled(false);
				}else{
					Ext.getCmp('itemExchangeButton').setDisabled(true);
				}
				//}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
					UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function( store, eOpts ) {
				if( directMasterStore1.isDirty() || directMasterStore3.isDirty() || store.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		},
		saveStore: function(config) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("toUpdate",toUpdate);
			var basisQtyChk = Ext.getCmp('BASIS_QTY_COMBO').getValue();

//			//20190627 주석 - 모품목에 로직 추가
//			var rv = true;
//			//20190607 SAMPLE코드 사용일 경우 SAMPLE_KEY가 비어있으면 return false;
//			if(BsaCodeInfo.gsSampleCodeYn == 'Y' ) {
//				Ext.each(list, function(record,i) {
//					if(Ext.isEmpty(record.get('SAMPLE_KEY'))) {
//						Unilite.messageBox('LAB_NO(은)는 필수 입력입니다.');
//						rv = false;
//						return false;
//					}
//				});
//			}
//			if(!rv) return false;

			if(directMasterStore2.isDirty()){
				if(basisQtyChk == '100'){
					if(directMasterStore2.sum('UNIT_Q').toFixed(7) != 100){
						Unilite.messageBox("기준수를 100으로 세팅한 경우에는\n원단위량의 합계가 100이어야 합니다.");
						return false;
					}
				}
			}

			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						if(directMasterStore2.getCount() > 0){
							Ext.getCmp('itemExchangeButton').setDisabled(false);
						}else{
							Ext.getCmp('itemExchangeButton').setDisabled(true);
						}
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var directMasterStore3 = Unilite.createStore('s_bpr560ukrv_twMasterStore3',{
		model	: 'Bpr560ukrvModel3',
		proxy	: directProxy3,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(record)	{
			var searchParam= panelResult.getValues();
			var param= {
				'DIV_CODE'			: record.get('DIV_CODE'),
				'PROD_ITEM_CODE'	: record.get('PROD_ITEM_CODE'),
				'CHILD_ITEM_CODE'	: record.get('CHILD_ITEM_CODE')};
			console.log( param );
			var params = Ext.merge(searchParam, param);
			this.load({
				params : params
			});
		},
		saveStore: function(config) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("toUpdate",toUpdate);
			var rv = true;

			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						if(directMasterStore3.getCount() > 0){
							Ext.getCmp('itemExchangeButton').setDisabled(false);
						}else{
							Ext.getCmp('itemExchangeButton').setDisabled(true);
						}
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);

			} else {
				masterGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load:function(store, records, successful, eOpts) {
				//if(successful)	{
				if(!directMasterStore1.isDirty() && !directMasterStore2.isDirty()) {
					UniAppManager.setToolbarButtons('save', false);
					if(records.length>0)	{
						UniAppManager.setToolbarButtons('delete', true);
					}
				}
				if(directMasterStore3.getCount() > 0){
					Ext.getCmp('itemExchangeButton').setDisabled(false);
				}else{
					Ext.getCmp('itemExchangeButton').setDisabled(true);
				}
				//}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function( store, eOpts ) {
				if( directMasterStore1.isDirty() || directMasterStore2.isDirty() || store.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var pummokGogogo = Ext.create('Ext.Button',{
		text	: '<t:message code="system.label.base.itementry" default="품목등록"/>',
		handler : function() {
			var rec = {data : {prgID : 's_bpr100ukrv_kd', 'text':''}};	// 품목정보(상세) 등록으로 이동
			parent.openTab(rec, '/z_kd/s_bpr100ukrv_kd.do', '');
		}
	})

	var makeProdItemBtn = Ext.create('Ext.Button',{
		text	: '<t:message code="system.label.base.createparentitem" default="모품목생성"/>',
		handler	: function()  {
			if (confirm('<t:message code="system.message.base.message008" default="모품목에 등록되지 않은 제품/반제품을 일괄등록하시겠습니까?"/>')) {
				s_bpr560ukrv_twService.makeProdItems({'DIV_CODE': panelResult.getValue('DIV_CODE')}, function(provider, response) {
					console.log("provider:",provider);
					console.log("response:",response);
					Unilite.messageBox('<t:message code="system.message.base.message009" default="모품목코드가 생성되었습니다."/>');
					UniAppManager.app.onQueryButtonDown();
				});
			}
		}
	})


	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
		region: 'north',
		layout : {type : 'uniTable', columns : 5, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value : UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}, {
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.base.itemsearch" default="품목검색"/>',
				items: [{
					boxLabel: '<t:message code="system.label.base.Currentlyapplieditems" default="현재 적용품목"/>' , width: 120, name: 'APTITEM', inputValue: 'C', checked: true
				}, {
					boxLabel: '<t:message code="system.label.base.whole" default="전체"/>' , width: 70, name: 'APTITEM', inputValue: 'A'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				//컬럼 맞춤용
				xtype: 'component',
				width:600,
				tdAttrs: {width: 600}
			},{
				//컬럼 맞춤용
				xtype: 'component',
				width:600,
				tdAttrs: {width: 600}
			},{
				//컬럼 맞춤용
				xtype: 'component',
				width:600,
				tdAttrs: {width: 600}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.base.parentitemcode" default="모품목코드"/>',
				valueFieldName: 'PROD_ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				validateBlank: false,
				extraFieldsConfig:[{extraFieldName:'SPEC', extraFieldWidth:153}],
				textFieldWidth:   370,
				listeners: {
					//20210818 수정: 조회조건 팝업설정에 맞게 변경
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('PROD_ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
						//popup.setExtParam({'DEFAULT_ITEM_ACCOUNT': '10'});
					}
				}
			 }),{
				xtype: 'uniRadiogroup',
				fieldLabel: '<t:message code="system.label.base.standardpathyn" default="표준Path 여부"/>',
				name: 'StPathY',
				comboType:'AU',
				comboCode:'A020',
				width:240,
				hidden: BsaCodeInfo.gsBomPathYN =='Y' ? false:true,
				allowBlank:false,
				value:'Y',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				//컬럼 맞춤용
				xtype: 'component',
				width:600,
				tdAttrs: {width: 600}
			}/*,{
				xtype: 'container',
				layout : {type : 'uniTable'},
				tableAttrs: {align:'right'},
//				padding: '0 20 0 0',
				items:[{
						//margin:'0 0 3 50',
						xtype: 'button',
						width: 90,
						text: '품목등록',
						//tdAttrs:{'align':'right'},
						handler : function() {
							var rec = {data : {prgID : 'bpr100ukrv', 'text':''}};	품목정보(상세) 등록으로 이동
							parent.openTab(rec, '/base/bpr100ukrv.do', '');
						}
					}
				]
			}*/
			/*,{
				name: 'ITEM_LEVEL1',
				fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				name: 'ITEM_LEVEL2',
				fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				name: 'ITEM_LEVEL3',
				fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
				levelType:'ITEM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}*/]
	});



	var masterGrid1 = Unilite.createGrid('s_bpr560ukrv_twGrid1', {
		// for tab
		layout : 'fit',
		region:'west',
		flex: .3,
		split: true,
		store: directMasterStore1,
		itemId:'s_bpr560ukrv_twGrid1',
		excelTitle:'<t:message code="system.label.base.manufacturebomentryprodtcode" default="제조BOM등록(모품목코드)"/>',
		uniOpt:{
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: true,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		tbar:[pummokGogogo, makeProdItemBtn],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	  showSummaryRow: false} ],
		columns:  [{ dataIndex: 'COMP_CODE'				,width: 66, hidden: true},
				   { dataIndex: 'DIV_CODE'				,width: 66, hidden: true},
				   { dataIndex: 'ITEM_ACCOUNT'			,width: 66, hidden: true},
				   { dataIndex: 'PROD_ITEM_CODE'		,width: 90,  tdCls:'x-change-cell',
					  editor: Unilite.popup('DIV_PUMOK_G', {
							textFieldName: 'PROD_ITEM_CODE',
							DBtextFieldName: 'ITEM_CODE',
							autoPopup: true,
							listeners: {'onSelected': {
								fn: function(records, type) {
									console.log('records : ', records);
									Ext.each(records, function(record,i) {
										if(i==0) {
											masterGrid1.setItemData(record,false, masterGrid1.uniOpt.currentRecord);
										} else {
											UniAppManager.app.onNewDataButtonDown();
											masterGrid1.setItemData(record,false, masterGrid1.getSelectedRecord());
										}
									});
								},
								scope: this
								},
								'onClear': function(type) {
									masterGrid1.setItemData(null,true, masterGrid1.uniOpt.currentRecord);
								},
								applyextparam: function(popup){
									popup.setExtParam({'SELMODEL'				: 'MULTI'});
									popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
									//popup.setExtParam({'DEFAULT_ITEM_ACCOUNT': '10'});
									//20190904 모품목에는 B020의 REF_CODE3이 '10', '20', '30'인 품목만 들어가도록 수정
//									popup.setExtParam({'ITEM_ACCOUNT_ARRAY': ['10','20']});
									popup.setExtParam({'ADD_QUERY3': "AND A.ITEM_ACCOUNT IN (SELECT SUB_CODE FROM BSA100T A WITH(NOLOCK) WHERE MAIN_CODE = 'B020' AND REF_CODE3 IN ('10', '20', '30'))"});

								}
							}
						})
					},
				   { dataIndex: 'CHILD_ITEM_CODE'		,width: 66,  hidden: true},
				   { dataIndex: 'ITEM_NAME'				,width: 200 ,
					  editor: Unilite.popup('DIV_PUMOK_G', {
//							  extParam: {DIV_CODE: UserInfo.divCode, ITEM_ACCOUNT_FILTER:['10','20'], ITEM_EXCLUDE:'DIV_CODE' ,DEFAULT_ITEM_ACCOUNT:'10'},
								autoPopup: true,
								listeners: {'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											if(i==0) {
												masterGrid1.setItemData(record,false, masterGrid1.uniOpt.currentRecord);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid1.setItemData(record,false, masterGrid1.getSelectedRecord());
											}
										});
									},
									scope: this
									},
									'onClear': function(type) {
										masterGrid1.setItemData(null, true, masterGrid1.uniOpt.currentRecord);
									},
									applyextparam: function(popup){
										popup.setExtParam({'SELMODEL'				: 'MULTI'});
										popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
										popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
										//popup.setExtParam({'DEFAULT_ITEM_ACCOUNT': '10'});
									}
								}
						})
					},
				   { dataIndex: 'SPEC'					,width: 150  },
				   { dataIndex: 'START_DATE'			,width: 100, hidden: true},
				   { dataIndex: 'STOP_DATE'				,width: 100, hidden: true},
					//20190627 LAB_NO 관련 로직 자품목에서 모품목으로 이동
					//20190701 그리드 설정 시, 오류로 주석 / 그리드 정의에서 직접 show, hidden 처리
				   { dataIndex: 'LAB_NO'	,width: 100 , hidden: BsaCodeInfo.gsSampleCodeYn == 'Y' ? false : true,
						editor: Unilite.popup('LAB_NO_G',{
							validateBlank:false,
							autoPopup: false,
							listeners:{
								scope:this,
								onSelected:function(records, type ) {
									var grdRecord = masterGrid1.uniOpt.currentRecord;
									grdRecord.set('LAB_NO'		,records[0]['LAB_NO']);
									grdRecord.set('REQST_ID'	,records[0]['REQST_ID']);
									//20190607 SAMPLE_KEY 추가
									grdRecord.set('SAMPLE_KEY'	,records[0]['SAMPLE_KEY']);
								},
								onClear:function(type) {
									var grdRecord = masterGrid1.uniOpt.currentRecord;
									grdRecord.set('LAB_NO'		,'');
									grdRecord.set('REQST_ID'	,'');
									//20190607 SAMPLE_KEY 추가
									grdRecord.set('SAMPLE_KEY'	,'');
								}
							}
						})
				   },
					//20190701 그리드 설정 시, 오류로 주석 / 그리드 정의에서 직접 show, hidden 처리
				   { dataIndex: 'REQST_ID'	,width: 100 , hidden: BsaCodeInfo.gsSampleCodeYn == 'Y' ? false : true,
						editor: Unilite.popup('LAB_NO_G',{
							validateBlank:false,
							autoPopup: false,
							listeners:{
								scope:this,
								onSelected:function(records, type ) {
									var grdRecord = masterGrid1.uniOpt.currentRecord;
									grdRecord.set('LAB_NO'		,records[0]['LAB_NO']);
									grdRecord.set('REQST_ID'	,records[0]['REQST_ID']);
									//20190607 SAMPLE_KEY 추가
									grdRecord.set('SAMPLE_KEY'	,records[0]['SAMPLE_KEY']);
								},
								onClear:function(type) {
									var grdRecord = masterGrid1.uniOpt.currentRecord;
									grdRecord.set('LAB_NO'		,'');
									grdRecord.set('REQST_ID'	,'');
									//20190607 SAMPLE_KEY 추가
									grdRecord.set('SAMPLE_KEY'	,'');
								}
							}
						})
				   },
				   { dataIndex: 'SAMPLE_KEY'		,width: 100, hidden: true}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore2.isDirty() ||  directMasterStore3.isDirty()){
						Unilite.messageBox(Msg.sMB154);
						return false;
					}else {
						masterSelectedGrid = girdNm;
						if(grid.getStore().getCount() > 0)  {
							UniAppManager.setToolbarButtons('delete', true);
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
					}
				});
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field, ['LAB_NO','REQST_ID'])){
						return true;
					}else{
				   		return false;
					}
				}
				if (UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE','CHILD_ITEM_CODE','SPEC']))
					return false;
				else
					return true;
			},
			//2018-05-14 수정: directMasterStore3.loadStoreRecords 추가
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0) {
					var record = selected[0];
					directMasterStore2.loadData({})
					directMasterStore3.loadData({})
					directMasterStore2.loadStoreRecords(record);
					directMasterStore3.loadStoreRecords(record);
				}
			},
			returnData: function(record)   {
				if(Ext.isEmpty(record)) {
					record = this.getSelectedRecord();
				}
			}
		},
		setItemData: function(record, dataClear,grdRecord) {
			if(dataClear) {
				grdRecord.set('PROD_ITEM_CODE'	,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('ITEM_ACCOUNT'	,"");
			}
			else {
				grdRecord.set('PROD_ITEM_CODE'	, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('s_bpr560ukrv_twGrid2', {
		layout : 'fit',
		region:'north',
		split: true,
		flex: .7,
		store: directMasterStore2,
		itemId:'s_bpr560ukrv_twGrid2',
		excelTitle:'<t:message code="system.label.base.manufacturebomentrychildcode" default="제조BOM등록(자품목코드)"/>',
		uniOpt:{
			onLoadSelectFirst: true,
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		tbar:[
			//20190627 주석
//			Unilite.popup('LAB_NO',{
//				id:'LAB_NO_POPUP',
//				labelWidth  : 53,
//				fieldLabel: 'LAB NO',
//				valueFieldName: 'LAB_NO',
//				textFieldName: 'REQST_ID',
//				valueFieldWidth: 150,
//				textFieldWidth: 80,
//				validateBlank:false,
//				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//						},
//						scope: this
//					},
//					onClear: function(type) {
//					},
//					applyextparam: function(popup){
////						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
////						popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
//					}
//				}
//			}),
//			'-',
			{	name: 'BASIS_QTY' ,
					fieldLabel:'<t:message code="system.label.base.basisqty" default="기준수"/>' ,
					xtype:'uniCombobox',
					store: Ext.data.StoreManager.lookup('s_bpr560ukrv_twBasisQtyStore'),
					id:'BASIS_QTY_COMBO',
					labelWidth  : 53,
					width	   : 180,
					fieldStyle: 'text-align: center;',
					value : '1',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},'-'],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	  showSummaryRow: true} ],
		columns:  [{ dataIndex: 'COMP_CODE'			,width: 66 , hidden: true },
				   { dataIndex: 'DIV_CODE'			,width: 66 , hidden: true },
				   { dataIndex: 'PROD_ITEM_CODE'	,width: 66 , hidden: true },
				   { dataIndex: 'PROD_ITEM_NAME'	,width: 200, hidden: true },
				   { dataIndex: 'PROD_SPEC'			,width: 100, hidden: true },
				   { dataIndex: 'SEQ'				,width: 50 },
				   { dataIndex: 'CHILD_ITEM_CODE'	,width: 120  , tdCls:'x-change-cell' ,
						editor: Unilite.popup('DIV_PUMOK_G', {
							textFieldName	: 'CHILD_ITEM_CODE',
							DBtextFieldName	: 'ITEM_CODE',
							uniOpt:{
								recordFields: ['COMP_CODE','DIV_CODE','PROD_ITEM_CODE'],
								grid		: 's_bpr560ukrv_twGrid1'
							},
							autoPopup: true,
							listeners: {
								'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											var selectedRecord = masterGrid2.getSelectedRecord();
											if(record.ITEM_CODE == selectedRecord.get('PROD_ITEM_CODE')) {
												Unilite.messageBox('<t:message code="system.message.base.message011" default="모품목과 동일한 품목을 등록할 수 없습니다."/>' + '\n' + '<t:message code="system.label.base.parentitemcode" default="모품목코드"/>:' + selectedRecord.get('PROD_ITEM_CODE'));
												masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
												return false;
											}
											if(i==0) {
												masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid2.setItemData(record,false, masterGrid2.getSelectedRecord());
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
								},
								applyextparam: function(popup){
									popup.setExtParam({'SELMODEL'				: 'MULTI'});
									popup.setExtParam({'DIV_CODE'				: panelResult.getValue('DIV_CODE')});
									popup.setExtParam({'ITEM_ACCOUNT_FILTER'	: ['20','40','50','60']});
									//popup.setExtParam({'ADD_QUERY3'	: "and ITEM_ACCOUNT in ('20','40','50','60')"});
									//popup.setExtParam({'DEFAULT_ITEM_ACCOUNT'	: gsSetField == 'WM' ? '' : '20'});		//20201207 수정
								}
							}
						})
					},
				   { dataIndex: 'ITEM_NAME'			 ,width: 200 ,
						editor: Unilite.popup('DIV_PUMOK_G', {
							uniOpt:{
								recordFields: ['COMP_CODE','DIV_CODE','PROD_ITEM_CODE'],
								grid		: 's_bpr560ukrv_twGrid1'
							},
							autoPopup: true,
							listeners: {
								'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											var selectedRecord = masterGrid2.getSelectedRecord();
											if(record.ITEM_CODE == selectedRecord.get('PROD_ITEM_CODE')) {
												Unilite.messageBox('<t:message code="system.message.base.message011" default="모품목과 동일한 품목을 등록할 수 없습니다."/>' + '\n' + '<t:message code="system.label.base.parentitemcode" default="모품목코드"/>:' + selectedRecord.get('PROD_ITEM_CODE'));
												masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
												return false;
											}
											if(i==0) {
												masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid2.setItemData(record,false, masterGrid2.getSelectedRecord());
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
								},
								applyextparam: function(popup){
									popup.setExtParam({'SELMODEL'				: 'MULTI'});
									popup.setExtParam({'DIV_CODE'				: panelResult.getValue('DIV_CODE')});
									popup.setExtParam({'ITEM_ACCOUNT_FILTER'	: ['20','40','50','60']});
									//popup.setExtParam({'DEFAULT_ITEM_ACCOUNT'	: gsSetField == 'WM' ? '' : '20'});		//20201207 수정
								}
							}
						})
					},
				   { dataIndex: 'ITEM_NAME1'			 ,width: 200,hidden:true },
				   { dataIndex: 'ITEM_NAME2'			 ,width: 200,hidden:true },
				   { dataIndex: 'SPEC'				,width: 100,
						   summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
								return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.base.totalamount" default="합계"/>');
					}},
				   { dataIndex: 'STOCK_UNIT'		,width: 40},
				   { dataIndex: 'OLD_PATH_CODE'		,width: 90, hidden: true },
				   { dataIndex: 'PATH_CODE'			,width: 90, hidden: gsBomPathYN },
				   { dataIndex: 'UNIT_Q'			,width: 90  , xtype: 'uniNnumberColumn', summaryType: 'sum' },
				   { dataIndex: 'PROD_UNIT_Q'		,width: 100 ,format:'0,000.000',editor:{format:'0,000.000'}},
				   { dataIndex: 'LOSS_RATE'			,width: 80  ,format:'0,000.000',editor:{format:'0,000.000'}},
				   { dataIndex: 'SET_QTY'			,width: 100 ,format:'0,000.000',editor:{format:'0,000.000'}},
				   { dataIndex: 'GROUP_CODE'		,width: 80, align: 'center'},
				   { dataIndex: 'UNIT_P1'			,width: 80 },
				   { dataIndex: 'UNIT_P2'			,width: 80 },
				   { dataIndex: 'UNIT_P3'			,width: 80 },
				   { dataIndex: 'MAN_HOUR'			,width: 80 },
				   //20180516 MATERIAL_CNT, SET_QTY 추가
				   { dataIndex: 'MATERIAL_CNT'		,width: 80 },
				   //20200324추가: 가중치
				   { dataIndex: 'WEIGHT_RATE'		,width: 100},
				   { dataIndex: 'USE_YN'			,width: 80 },
				   { dataIndex: 'BOM_YN'			,width: 80 },
				   //20190605 거래처, 구매단가 추가
				   { dataIndex: 'CUSTOM_CODE'		,width: 100, hidden: true },
				   { dataIndex: 'CUSTOM_NAME'		,width: 200 },
				   { dataIndex: 'PURCHASE_BASE_P'	,width: 100 },
				   { dataIndex: 'START_DATE'		,width: 100 , tdCls:'x-change-cell'},
				   { dataIndex: 'STOP_DATE'			,width: 100 },
				   { dataIndex: 'GRANT_TYPE'		,width: 100, align:'center', hidden: true },
				   { dataIndex: 'REMARK'			,width: 226, hidden: true },
				   { dataIndex: 'UPDATE_DB_USER'	,width: 66, hidden: true },
				   { dataIndex: 'UPDATE_DB_TIME'	,width: 66, hidden: true }

					//20190627 주석
//				   { dataIndex: 'LAB_NO'	,width: 100 ,
//						editor: Unilite.popup('LAB_NO_G',{
//							validateBlank:false,
//							autoPopup: false,
//							listeners:{
//								scope:this,
//								onSelected:function(records, type ) {
//									var grdRecord = masterGrid2.uniOpt.currentRecord;
//									grdRecord.set('LAB_NO'		,records[0]['LAB_NO']);
//									grdRecord.set('REQST_ID'	,records[0]['REQST_ID']);
//									//20190607 SAMPLE_KEY 추가
//									grdRecord.set('SAMPLE_KEY'	,records[0]['SAMPLE_KEY']);
//								},
//								onClear:function(type) {
//									var grdRecord = masterGrid2.uniOpt.currentRecord;
//									grdRecord.set('LAB_NO'		,'');
//									grdRecord.set('REQST_ID'	,'');
//									//20190607 SAMPLE_KEY 추가
//									grdRecord.set('SAMPLE_KEY'	,'');
//								}
//							}
//						})
//				   },
//				   { dataIndex: 'REQST_ID'	,width: 100 , hidden: true,
//						editor: Unilite.popup('LAB_NO_G',{
//							validateBlank:false,
//							autoPopup: false,
//							listeners:{
//								scope:this,
//								onSelected:function(records, type ) {
//									var grdRecord = masterGrid2.uniOpt.currentRecord;
//									grdRecord.set('LAB_NO'		,records[0]['LAB_NO']);
//									grdRecord.set('REQST_ID'	,records[0]['REQST_ID']);
//									//20190607 SAMPLE_KEY 추가
//									grdRecord.set('SAMPLE_KEY'	,records[0]['SAMPLE_KEY']);
//								},
//								onClear:function(type) {
//									var grdRecord = masterGrid2.uniOpt.currentRecord;
//									grdRecord.set('LAB_NO'		,'');
//									grdRecord.set('REQST_ID'	,'');
//									//20190607 SAMPLE_KEY 추가
//									grdRecord.set('SAMPLE_KEY'	,'');
//								}
//							}
//						})
//				   },
//				   //20190607 SAMPLE_KEY 추가
//				   { dataIndex: 'SAMPLE_KEY'		,width: 100, hidden: true}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore1.isDirty() || directMasterStore3.isDirty()){
						//grid.suspendEvents();
						Unilite.messageBox(Msg.sMB154);
						return false;
					}else {
						masterSelectedGrid = girdNm;
						if(grid.getStore().getCount() > 0)  {
							UniAppManager.setToolbarButtons('delete', true);
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
					}
				});

			},
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,
										['COMP_CODE','DIV_CODE','PROD_ITEM_CODE', 'SPEC', 'STOCK_UNIT'
										//20190605 거래처, 구매단가 추가
										, 'CUSTOM_CODE', 'CUSTOM_NAME', 'PURCHASE_BASE_P'
										//20190627 주석
//										//20190607 SAMPLE_KEY 추가
//										, 'SAMPLE_KEY'
										, 'PROD_ITEM_NAME', 'ITEM_NAME1', 'ITEM_NAME2'
										]))   {
						return false;
				}
//			  if(e.field == 'PATH_CODE')  {
//				  if(BsaCodeInfo.gsItemCheck == "PROD" ){
//					  return false;
//				  }
//			  }
				if(!e.record.phantom){
					if(UniUtils.indexOf(e.field,
										['CHILD_ITEM_CODE','ITEM_NAME','START_DATE','PATH_CODE', 'ITEM_NAME1', 'ITEM_NAME2']))  {
						   return false;
					}
				}

			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0) {
					var record = selected[0];
					directMasterStore3.loadData({})
					directMasterStore3.loadStoreRecords(record);
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
//			var grdRecord = this.uniOpt.currentRecord;
//			if(!grdRecord || !Ext.isDefined(grdRecord)) grdRecord = this.getSelectedRecord();
			var basisQtyChk = Ext.getCmp('BASIS_QTY_COMBO').getValue();
			var prodUnitQ = 1;
			var unitQ = 1;
			if(basisQtyChk == '100'){
				prodUnitQ = 100;
				unitQ = 1;
			}
			var masterRecord = masterGrid1.getSelectedRecord();
			var startDate = masterRecord.get('START_DATE');
			if( Ext.isEmpty(startDate)){
				startDate = UniDate.get('today');
			}
			if(dataClear) {
				grdRecord.set('CHILD_ITEM_CODE' ,"");
				grdRecord.set('ITEM_NAME'	   ,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('STOCK_UNIT'	  ,"");
				grdRecord.set('OLD_PATH_CODE'   , "0");
				grdRecord.set('PATH_CODE'	   , "0");
				grdRecord.set('UNIT_Q'		  , unitQ);
				grdRecord.set('PROD_UNIT_Q'	 , prodUnitQ);
				grdRecord.set('LOSS_RATE'	   , 0);
				grdRecord.set('UNIT_P1'		 , 0);
				grdRecord.set('UNIT_P2'		 , 0);
				grdRecord.set('UNIT_P3'		 , 0);
				grdRecord.set('MAN_HOUR'		, 0);
				grdRecord.set('USE_YN'		  , 1);
				grdRecord.set('BOM_YN'		  , 1);
				grdRecord.set('START_DATE'	  , startDate);
				grdRecord.set('STOP_DATE'	   , '2999.12.31');
				grdRecord.set('REMARK'		  , '');
			}
			else {
				grdRecord.set('CHILD_ITEM_CODE' , record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'	   , record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('STOCK_UNIT'	  , record['STOCK_UNIT']);
				grdRecord.set('OLD_PATH_CODE'   , "0");
				grdRecord.set('PATH_CODE'	   , "0");
				grdRecord.set('UNIT_Q'		  , unitQ);
				grdRecord.set('PROD_UNIT_Q'	 , prodUnitQ);
				grdRecord.set('LOSS_RATE'	   , 0);
				grdRecord.set('UNIT_P1'		 , record['BASIS_P']);
				grdRecord.set('UNIT_P2'		 , 0);
				grdRecord.set('UNIT_P3'		 , 0);
				grdRecord.set('MAN_HOUR'		, 0);
				grdRecord.set('USE_YN'		  , 1);
				grdRecord.set('BOM_YN'		  , 1);
				grdRecord.set('START_DATE'	  , startDate);
				grdRecord.set('STOP_DATE'	   , '2999.12.31');
				grdRecord.set('REMARK'		  , record['REMARK']);
				grdRecord.set('UPDATE_DB_USER'  , record['UPDATE_DB_USER']);
				grdRecord.set('UPDATE_DB_TIME'  , record['UPDATE_DB_TIME']);
			}
		},
		setExcelData: function(record, grdRecord) {
			  var grdRecord = this.getSelectedRecord();
			grdRecord.set('CHILD_ITEM_CODE' , record['CHILD_ITEM_CODE']);
			grdRecord.set('ITEM_NAME'	   , record['ITEM_NAME']);
			grdRecord.set('STOCK_UNIT'	  , record['STOCK_UNIT']);
			grdRecord.set('SEQ'	  , record['SEQ']);
			grdRecord.set('SET_QTY'	   , record['SET_QTY']);
			grdRecord.set('UNIT_Q'		  , record['UNIT_Q']);
			grdRecord.set('SPEC'	  , record['SPEC']);
			grdRecord.set('LOSS_RATE'	   ,record['LOSS_RATE']);
			grdRecord.set('OLD_PATH_CODE'   , "0");
			grdRecord.set('PATH_CODE'	   , "0");
			grdRecord.set('USE_YN'		  , 1);
			grdRecord.set('BOM_YN'		  , 1);
			grdRecord.set('REMARK'	   ,record['REMARK']);
			grdRecord.set('START_DATE'	  , UniDate.get('today'));
			grdRecord.set('GROUP_CODE'	  , record['GROUP_CODE']);
			grdRecord.set('GRANT_TYPE'	  , record['GRANT_TYPE']);

		}
	});

	var masterGrid3 = Unilite.createGrid('s_bpr560ukrv_twGrid3', {
		// for tab
		layout : 'fit',
		region:'center',
		split: true,
		flex: .3,
		store: directMasterStore3,
		itemId:'s_bpr560ukrv_twGrid3',
		excelTitle:'<t:message code="system.label.base.manufacturebomentryhowcode" default="제조BOM등록(대체품목코드)"/>',
		tbar:[{
			xtype	: 'button',
			text	: '대체교환',
			id		: 'itemExchangeButton',
			width	: 100,
			handler	: function() {
				var records1 = masterGrid1.getSelectedRecord();
				var records2 = masterGrid2.getSelectedRecord();
				var records3 = masterGrid3.getSelectedRecord();
				if(Ext.isEmpty(records2)){
					Unilite.messageBox("교환품목을 선택해주세요.")
					return false;
				}else{
					 if(confirm("자품목코드와 대체품목코드를 교환하시겠습니까?")) {
						 var param= {
								 	'DIV_CODE'						: panelResult.getValue('DIV_CODE'),
									'PROD_ITEM_CODE'			: records1.data.PROD_ITEM_CODE,
									'CHILD_ITEM_CODE'			: records2.data.CHILD_ITEM_CODE,
									'EXCHG_ITEM_CODE'		: records3.data.EXCHG_ITEM_CODE
									};
						 Ext.getBody().mask();
						 	s_bpr560ukrv_twService.changeItemData(param,function(provider, response){
		    				if(response.type == 'rpc'){
		    	    				directMasterStore1.loadStoreRecords();
		    					}
		    					Ext.getBody().unmask();
		    				});
					 }
				}
			}
		}],
		uniOpt:{
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	  showSummaryRow: false} ],
		columns:  [{ dataIndex: 'COMP_CODE'			,width: 66, hidden: true   },
				   { dataIndex: 'DIV_CODE'			,width: 66, hidden: true   },
//				 { dataIndex: 'SEQ'					,width: 45, locked: true   },
				   { dataIndex: 'PROD_ITEM_CODE'	,width: 66, hidden: true   },
				   { dataIndex: 'CHILD_ITEM_CODE'	,width: 66, hidden: true   },
				   { dataIndex: 'EXCHG_ITEM_CODE'	,width: 120  , tdCls:'x-change-cell' ,
						editor: Unilite.popup('DIV_PUMOK_G', {
							textFieldName	: 'EXCHG_ITEM_CODE',
							DBtextFieldName	: 'ITEM_CODE',
							extParam		: {DIV_CODE: UserInfo.divCode, ITEM_ACCOUNT_FILTER:['20','40','50','60'], ITEM_EXCLUDE:'PROD_ITEM_CODE'/*  ,DEFAULT_ITEM_ACCOUNT:'20' */},
							uniOpt:{
								recordFields: ['DIV_CODE','PROD_ITEM_CODE','CHILD_ITEM_CODE'],
								grid		: 's_bpr560ukrv_twGrid3'
							},
							autoPopup: true,
							listeners: {
								'onSelected': {
									fn: function(records, type) {
											var selectedRecord = masterGrid3.getSelectedRecord();
											if(records[0].ITEM_CODE == selectedRecord.get('PROD_ITEM_CODE')) {
												Unilite.messageBox('<t:message code="system.message.base.message011" default="모품목과 동일한 품목을 등록할 수 없습니다."/>' + '\n' + '모품목코드:' + selectedRecord.get('PROD_ITEM_CODE'));
												masterGrid3.setItemData(null,true);
												return false;
											}
											masterGrid3.setItemData(records[0],false);
										},
									scope: this
									},
								'onClear': function(type) {
									masterGrid3.setItemData(null,true);
								},
								applyextparam: function(popup){
									popup.setExtParam({'SELMODEL'				: 'MULTI'});
									popup.setExtParam({'DIV_CODE'				: panelResult.getValue('DIV_CODE')});
									popup.setExtParam({'ITEM_EXCLUDE'			: 'PROD_ITEM_CODE'});
									popup.setExtParam({'ITEM_ACCOUNT_FILTER'	: ['20','40','50','60']});
									//popup.setExtParam({'DEFAULT_ITEM_ACCOUNT'	: '20'});
								}
							}
						})
					},
				   { dataIndex: 'ITEM_NAME'		,width: 200  ,
						editor: Unilite.popup('DIV_PUMOK_G', {
							extParam: {DIV_CODE: UserInfo.divCode, ITEM_ACCOUNT_FILTER:['20','40','50','60'], ITEM_EXCLUDE:'PROD_ITEM_CODE'/*  ,DEFAULT_ITEM_ACCOUNT:'20' */},
							uniOpt:{
								recordFields: ['DIV_CODE','PROD_ITEM_CODE','CHILD_ITEM_CODE'],
								grid		: 's_bpr560ukrv_twGrid3'
							},
							autoPopup: true,
							listeners: {'onSelected': {
									fn: function(records, type) {
											var selectedRecord = masterGrid3.getSelectedRecord();
											if(records[0].ITEM_CODE == selectedRecord.get('PROD_ITEM_CODE')) {
												Unilite.messageBox('<t:message code="system.message.base.message011" default="모품목과 동일한 품목을 등록할 수 없습니다."/>' + '\n' + '모품목코드:' + selectedRecord.get('PROD_ITEM_CODE'));
												masterGrid3.setItemData(null,true);
												return false;
											}
											masterGrid3.setItemData(records[0],false);
										},
									scope: this
									},
								'onClear': function(type) {
									masterGrid3.setItemData(null,true);
								},
								applyextparam: function(popup){
									popup.setExtParam({'SELMODEL'				: 'MULTI'});
									popup.setExtParam({'DIV_CODE'				: panelResult.getValue('DIV_CODE')});
									popup.setExtParam({'ITEM_EXCLUDE'			: 'PROD_ITEM_CODE'});
									popup.setExtParam({'ITEM_ACCOUNT_FILTER'	: ['20','40','50','60']});
									//popup.setExtParam({'DEFAULT_ITEM_ACCOUNT'	: '20'});
								}
							}
						})
					},
				   { dataIndex: 'SPEC'			,width: 100   },
				   { dataIndex: 'STOCK_UNIT'	,width: 40   },
				   { dataIndex: 'UNIT_Q'		,width: 80},
				   { dataIndex: 'PROD_UNIT_Q'	,width: 100 ,format:'0,000.000',editor:{format:'0,000.000'} },
				   { dataIndex: 'LOSS_RATE'		,width: 80  ,format:'0,000.000',editor:{format:'0,000.000'} },
				   { dataIndex: 'SET_QTY'			,width: 100 ,format:'0,000.000',editor:{format:'0,000.000'}},
				   { dataIndex: 'UNIT_P1'		,width: 80   },
				   { dataIndex: 'UNIT_P2'		,width: 80   },
				   { dataIndex: 'UNIT_P3'		,width: 80   },
				   { dataIndex: 'MAN_HOUR'		,width: 80   },
				   //20200324추가: 가중치
				   { dataIndex: 'WEIGHT_RATE'	,width: 100},
				   //20180528 MATERIAL_CNT, SET_QTY 추가
				   { dataIndex: 'MATERIAL_CNT'	,width: 80 },
				   { dataIndex: 'USE_YN'		,width: 80   },
				   { dataIndex: 'BOM_YN'		,width: 80   },
				   { dataIndex: 'PRIOR_SEQ'		,width: 80   },
				   { dataIndex: 'START_DATE'	,width: 100  , tdCls:'x-change-cell' },
				   { dataIndex: 'STOP_DATE'		,width: 100   },
				   { dataIndex: 'REMARK'		,width: 226  },
				   { dataIndex: 'UPDATE_DB_USER',width: 66, hidden: true   },
				   { dataIndex: 'UPDATE_DB_TIME',width: 66, hidden: true   }

		],
		listeners: {
			render: function(grid, eOpts){
								var girdNm = grid.getItemId()
								grid.getEl().on('click', function(e, t, eOpt) {
									if(directMasterStore1.isDirty() || directMasterStore2.isDirty()){
										Unilite.messageBox(Msg.sMB154);
										return false;
									}else {
										masterSelectedGrid = girdNm;
										if(grid.getStore().getCount() > 0)  {
											UniAppManager.setToolbarButtons('delete', true);
										}else {
											UniAppManager.setToolbarButtons('delete', false);
										}
									}
								});

							},

			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,
											['COMP_CODE','DIV_CODE','PROD_ITEM_CODE','CHILD_ITEM_CODE',
											 'SPEC','STOCK_UNIT','OLD_PATH_CODE','STOCK_UNIT',
											 'UPDATE_DB_USER','UPDATE_DB_TIME']))
							return false;
				if(!e.record.phantom){
					if(UniUtils.indexOf(e.field,
										['EXCHG_ITEM_CODE','ITEM_NAME','START_DATE']))
						   return false;
				}

			}
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('EXCHG_ITEM_CODE' ,"");
				grdRecord.set('ITEM_NAME'	   ,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('STOCK_UNIT'	  ,"");
				grdRecord.set('OLD_PATH_CODE'   ,"");
				grdRecord.set('PATH_CODE'	   ,"");
				grdRecord.set('UNIT_Q'		  , 1);
				grdRecord.set('PROD_UNIT_Q'	 , 1);
				grdRecord.set('LOSS_RATE'	   , 0);
				grdRecord.set('UNIT_P1'		 , 0);
				grdRecord.set('UNIT_P2'		 , 0);
				grdRecord.set('UNIT_P3'		 , 0);
				grdRecord.set('MAN_HOUR'		, 0);
				grdRecord.set('USE_YN'		  , 1);
				grdRecord.set('BOM_YN'		  , 1);
				grdRecord.set('START_DATE'	  , UniDate.get('today'));
				grdRecord.set('STOP_DATE'	   , '2999.12.31');
			}
			else {
				grdRecord.set('EXCHG_ITEM_CODE' , record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'	   , record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('STOCK_UNIT'	  , record['STOCK_UNIT']);
				grdRecord.set('OLD_PATH_CODE'   , record['OLD_PATH_CODE']);
				grdRecord.set('PATH_CODE'	   , record['PATH_CODE']);
				grdRecord.set('UNIT_Q'		  , 1);
				grdRecord.set('PROD_UNIT_Q'	 , 1);
				grdRecord.set('LOSS_RATE'	   , 0);
				grdRecord.set('UNIT_P1'		 , record['BASIS_P']);
				grdRecord.set('UNIT_P2'		 , 0);
				grdRecord.set('UNIT_P3'		 , 0);
				grdRecord.set('MAN_HOUR'		, 0);
				grdRecord.set('USE_YN'		  , 1);
				grdRecord.set('BOM_YN'		  , 1);
				//grdRecord.set('PRIOR_SEQ'	 , record['SEQ']);
				grdRecord.set('START_DATE'	  , UniDate.get('today'));
				grdRecord.set('STOP_DATE'	   , '2999.12.31');
			}
		}
	});



	Unilite.Main({
		id  : 's_bpr560ukrv_twApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[{
				region: 'center',
				layout: {type: 'vbox', align: 'stretch'},
				border: false,
				flex: .7,
				items: [masterGrid2]

			},masterGrid1]
		}
		,panelResult
		],
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			//20190701 그리드 설정 시, 오류로 주석 / 그리드 정의에서 직접 show, hidden 처리
			//20190627 LAB_NO 관련그리드 공통코드 체크해서 SHOW, HIDDEN 처리
//			if(BsaCodeInfo.gsSampleCodeYn == 'Y') {
//				masterGrid1.getColumn('LAB_NO').show();
//				masterGrid1.getColumn('REQST_ID').show();
//			} else {
//				masterGrid1.getColumn('LAB_NO').hide();
//				masterGrid1.getColumn('REQST_ID').hide();
//			}
//			Ext.getCmp('COPY_BTN').setDisabled(true);
//			Ext.getCmp('excelUploadButton').setDisabled(true);
			Ext.getCmp('itemExchangeButton').setDisabled(true);
			Ext.getCmp('BASIS_QTY_COMBO').setDisabled(true);
			//20190627 주석
//			Ext.getCmp('LAB_NO_POPUP').setDisabled(true);

			masterSelectedGrid = 's_bpr560ukrv_twGrid1';
			if(params && !Ext.isEmpty(params.ITEM_CODE)){
				this.processParams(params);
			}
			if(BsaCodeInfo.gsExchgRegYN == 'Y'){
				masterGrid3.show();
			}else{
				masterGrid3.hide();
			}
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'bpr100ukrv') {
				panelResult.setValue('DIV_CODE',UserInfo.divCode);
				panelResult.setValue('PROD_ITEM_CODE',params.ITEM_CODE);
				panelResult.setValue('ITEM_NAME',params.ITEM_NAME);
				this.onQueryButtonDown();
			}else if(params.PGM_ID == 'bpr250ukrv') {
				panelResult.setValue('DIV_CODE',params.DIV_CODE);
				panelResult.setValue('PROD_ITEM_CODE',params.ITEM_CODE);
				panelResult.setValue('ITEM_NAME',params.ITEM_NAME);
				this.onQueryButtonDown();
			}
		},
		onQueryButtonDown : function()  {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			masterGrid1.getStore().loadStoreRecords();
			//  beforeRowIndex = -1;
		},
		onNewDataButtonDown: function() {
			if(masterSelectedGrid == 's_bpr560ukrv_twGrid1'){
				//var prodItemCode = panelResult.getValue('PROD_ITEM_CODE');
				//var prodItemName = panelResult.getValue('ITEM_NAME');

				var r = {
						'DIV_CODE'			: panelResult.getValue('DIV_CODE'),
						//'PROD_ITEM_CODE'	: prodItemCode,
						//'ITEM_NAME'			: prodItemName,
						'START_DATE'		: UniDate.get('today')
				}
				masterGrid1.createRow(r);
				UniAppManager.setToolbarButtons('save', true);
			}
			else if(masterSelectedGrid == 's_bpr560ukrv_twGrid2'){
				var seq = directMasterStore2.max('SEQ');
				if(BsaCodeInfo.gsSeqIncUit == '1') {
					if(!seq) seq = 1;
					else  seq += 1;
				} else if(BsaCodeInfo.gsSeqIncUit == '10') {
					if(!seq) seq = 10;
					else  seq = Math.floor((seq += 10) / 10) * 10;
				} else {
					Unilite.messageBox('<t:message code="system.message.base.message033" default="공통코드 설정이 잘못되었습니다."/> (B913)');
					return false;
				}
				var basisQtyChk = Ext.getCmp('BASIS_QTY_COMBO').getValue();
				var prodUnitQ = 1;
				var unitQ = 1;
				if(basisQtyChk == '100'){
					prodUnitQ = 100;
					unitQ = 1;
				}

				//20190627 주석
//				var labNo = Ext.getCmp('LAB_NO_POPUP-valueField').getValue();
//				var reqstId = Ext.getCmp('LAB_NO_POPUP-textField').getValue();
//				//20190607 SAMPLE_KEY 추가
//				var sampleKey = panelResult.getValue('SAMPLE_KEY');

				var masterRecord = masterGrid1.getSelectedRecord();
				var startDate = masterRecord.get('START_DATE');
				if( Ext.isEmpty(startDate)){
					startDate = UniDate.get('today');
				}
				if(masterRecord)	{
					var r = {
						SEQ				: seq,
						DIV_CODE		: panelResult.getValue('DIV_CODE'),
						PROD_ITEM_CODE	: masterRecord.get('PROD_ITEM_CODE'),
						PROD_UNIT_Q		: prodUnitQ,
						UNIT_Q			: unitQ,
						MATERIAL_CNT	: 1,
						SET_QTY			: 100,
						//20200324 추가
						WEIGHT_RATE		: 1,
						START_DATE		: startDate
						//20190627 주석
//						LAB_NO			: labNo,
//						REQST_ID		: reqstId,
//						SAMPLE_KEY		: sampleKey
					};
					masterGrid2.createRow(r);
					UniAppManager.setToolbarButtons('save', true);
				}
			}

			else if(masterSelectedGrid == 's_bpr560ukrv_twGrid3'){
				var seq = directMasterStore3.max('SEQ');
				if(!seq) seq = 1;
				else  seq += 1;
				var masterRecord = masterGrid2.getSelectedRecord();

				if(masterRecord)	{
					 var r = {
						SEQ				:seq,
						DIV_CODE		: panelResult.getValue('DIV_CODE'),
						PROD_ITEM_CODE	: masterRecord.get('PROD_ITEM_CODE'),
						CHILD_ITEM_CODE	: masterRecord.get('CHILD_ITEM_CODE'),
						PRIOR_SEQ		: seq,
						START_DATE		: UniDate.get('today'),
						STOP_DATE		: '2999.12.31',
						MATERIAL_CNT	: 1,
						SET_QTY 		: 100,
						//20200324 추가
						WEIGHT_RATE		: 1
					};
					masterGrid3.createRow(r);
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		},
		onResetButtonDown: function() {
//		  if(!UniAppManager.app._needSave())  {
				panelResult.reset();
				panelResult.clearForm()
				panelResult.getField('DIV_CODE').setReadOnly(false);
				panelResult.setValue('DIV_CODE',UserInfo.divCode);
				panelResult.getField('APTITEM').setReadOnly(false);
				panelResult.getField('PROD_ITEM_CODE').setReadOnly(false);
				panelResult.getField('ITEM_NAME').setReadOnly(false);
				masterGrid1.getStore().loadData({});
				directMasterStore1.clearData();
				masterGrid2.getStore().loadData({});
				directMasterStore2.clearData();
				masterGrid3.getStore().loadData({});
				directMasterStore3.clearData();
//		  }else {
//		  }
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
				directMasterStore1.saveStore();
				directMasterStore2.saveStore();
				directMasterStore3.saveStore();
		},
		onDeleteDataButtonDown: function() {
			if(masterSelectedGrid == 's_bpr560ukrv_twGrid1'){
				var Grid1 = UniAppManager.app.down('#s_bpr560ukrv_twGrid1');
				var selRow = masterGrid1.getSelectedRecord();
				var selIndex = masterGrid1.getSelectedRowIndex();

				if(selRow.phantom !== true && directMasterStore2.getCount() > 0 )
				{
					Unilite.messageBox('<t:message code="system.message.base.message012" default="자품목코드가 존재합니다.먼저 자품목코드를 삭제후 모품목코드를 삭제하십시오."/>');

				}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid1.deleteSelectedRow(selIndex);
					masterGrid1.getStore().onStoreActionEnable();
				}
				UniAppManager.setToolbarButtons('save', true);
			}

			else if(masterSelectedGrid == 's_bpr560ukrv_twGrid2'){
				var Grid1 = UniAppManager.app.down('#s_bpr560ukrv_twGrid2');
				var selRow = masterGrid2.getSelectedRecord();
				var selIndex = masterGrid2.getSelectedRowIndex();

				if(selRow.phantom !== true && directMasterStore3.getCount() > 0 )
				{
					Unilite.messageBox('<t:message code="system.message.base.message013" default="대체품목코드가 존재합니다.먼저 대체목코드를 삭제후 자품목코드를 삭제하십시오."/>');

				}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid2.deleteSelectedRow(selIndex);
					masterGrid2.getStore().onStoreActionEnable();
				}
				UniAppManager.setToolbarButtons('save', true);
			}

			else if(masterSelectedGrid == 's_bpr560ukrv_twGrid3'){
				var Grid1 = UniAppManager.app.down('#s_bpr560ukrv_twGrid3');
				var selRow = masterGrid3.getSelectedRecord();
				var selIndex = masterGrid3.getSelectedRowIndex();

				if(selRow.phantom === true)
					masterGrid3.deleteSelectedRow();
				else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid3.deleteSelectedRow();
					masterGrid3.getStore().onStoreActionEnable();
				}
				UniAppManager.setToolbarButtons('save', true);
			}
		},
		rejectSave: function() {	// 저장
			if(masterSelectedGrid == 's_bpr560ukrv_twGrid2'){
				var rowIndex = masterGrid2.getSelectedRowIndex();
				masterGrid2.select(rowIndex);
				directMasterStore2.rejectChanges();

				if(rowIndex >= 0){
					masterGrid2.getSelectionModel().select(rowIndex);
					var selected = masterGrid2.getSelectedRecord();

				}
				directMasterStore2.onStoreActionEnable();
			}

			else if(masterSelectedGrid == 's_bpr560ukrv_twGrid3'){
				var rowIndex2 = masterGrid3.getSelectedRowIndex();
				masterGrid3.select(rowIndex);
				directMasterStore3.rejectChanges();

				if(rowIndex2 >= 0){
					masterGrid3.getSelectionModel().select(rowIndex);
					var selected = masterGrid3.getSelectedRecord();

				}
				directMasterStore3.onStoreActionEnable();
			}
		},
		confirmSaveData: function(config)   {
			var fp = Ext.getCmp('s_bpr560ukrv_twFileUploadPanel');
			if(directMasterStore1.isDirty())	{
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())   {
				as.show();
			}else {
				as.hide()
			}
		}
	});





	Unilite.createValidator('validator02', {
		store : directMasterStore3,
		grid: masterGrid3,
		/*forms: {'formA:':detailForm},*/
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {

				case "LOSS_RATE" :
					var lossRate = record.get('LOSS_RATE');
					if(newValue < 0 || newValue > 50){
						rv = Msg.sMB089;
						/* 50이하의 정수만 입력가능합니다. */
						record.set('LOSS_RATE',oldValue);
						break;
					}
					break;

				case "UNIT_Q" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('UNIT_Q',oldValue);
						break;
					}
					break;

				case "PROD_UNIT_Q" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('PROD_UNIT_Q',oldValue);
						break;
					}
					break;

				case "SEQ" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('SEQ',oldValue);
						break;
					}
					break;

				case "UNIT_P1" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('UNIT_P1',oldValue);
						break;
					}
					break;

				case "UNIT_P2" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('UNIT_P2',oldValue);
						break;
					}
					break;

				case "UNIT_P3" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('UNIT_P3',oldValue);
						break;
					}
					break;

				case "MAN_HOUR" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('MAN_HOUR',oldValue);
						break;
					}
					break;
				case "START_DATE" :
					var startDate = record.get('START_DATE')
					var stopDate  = record.get('STOP_DATE')

					if(stopDate < startDate){
						rv=Msg.sMB084;
						record.set('START_DATE',oldValue);
						break;
					}
					break;
				case "STOP_DATE" :
					var startDate = record.get('START_DATE')
					var stopDate  = record.get('STOP_DATE')

					if(stopDate < startDate){
						rv=Msg.sMB084;
						record.set('STOP_DATE',oldValue);
						break;
					}
					break;
			}
			return rv;
		}
	}); // validator 01

	Unilite.createValidator('validator01', {
		store : directMasterStore2,
		grid: masterGrid2,
		/*forms: {'formA:':detailForm},*/
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {

				case "LOSS_RATE" :
				var lossRate = record.get('LOSS_RATE');
					if(newValue < 0 || newValue > 50){
						rv = Msg.sMB089;
						/* 50이하의 정수만 입력가능합니다. */
						record.set('LOSS_RATE',oldValue);
						break;
					}
					break;

				case "UNIT_Q" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('UNIT_Q',oldValue);
						break;
					}
					break;

				case "PROD_UNIT_Q" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('PROD_UNIT_Q',oldValue);
						break;
					}
					break;

				case "SEQ" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('SEQ',oldValue);
						break;
					}
					break;

				case "UNIT_P1" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('UNIT_P1',oldValue);
						break;
					}
					break;

				case "UNIT_P2" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('UNIT_P2',oldValue);
						break;
					}
					break;

				case "UNIT_P3" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('UNIT_P3',oldValue);
						break;
					}
					break;

				case "MAN_HOUR" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('MAN_HOUR',oldValue);
						break;
					}
					break;

				case "PRIOR_SEQ" :
					if(newValue <= 0)   {
						rv=Msg.sMB076;
						record.set('MAN_HOUR',oldValue);
						break;
					}
					break;

				case "START_DATE" :
					var startDate = record.get('START_DATE')
					var stopDate  = record.get('STOP_DATE')

					if(stopDate < startDate){
						rv=Msg.sMB084;
						record.set('START_DATE',oldValue);
						break;
					}
					break;

				case "STOP_DATE" :
					var startDate = record.get('START_DATE')
					var stopDate  = record.get('STOP_DATE')

					if(stopDate < startDate){
						rv=Msg.sMB084;
						record.set('STOP_DATE',oldValue);
						break;
					}
					break;
			}
			return rv;
		}
	}); // validator 02
};


</script>
