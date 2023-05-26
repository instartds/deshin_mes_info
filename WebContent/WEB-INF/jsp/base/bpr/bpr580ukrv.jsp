<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr580ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="bpr580ukrv"/>					<!-- 사업장 -->
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
	var masterSelectedGrid = 'bpr580ukrvGrid1';	//Grid1 createRow Default
	var excelWindow;							//처방정보 업로드 윈도우 생성
	var BsaCodeInfo={
		'gsBomPathYN'	: '${gsBomPathYN}',		//BOM PATH 관리여부(B082)
//		'gsExchgRegYN'	: '${gsExchgRegYN}',	//대체품목 등록여부(B081)
		'gsItemCheck'	: 'PROD'				//품목구분(PROD:모품목, CHILD:자품목)
	}

	var gsBomPathYN = false;
	if(BsaCodeInfo.gsBomPathYN =='N') {
		gsBomPathYN = true;
	}

	var bprYnStore = Unilite.createStore('bpr580ukrvBPRYnStore', {
		fields	: ['text', 'value'],
		data	: [
			{'text': '<t:message code="system.label.base.yes" default="예"/>'		, 'value': '1'},
			{'text': '<t:message code="system.label.base.no" default="아니오"/>'	, 'value': '2'}
		]
	});

	var basisQtyStore = Unilite.createStore('bpr580ukrvBasisQtyStore', {
		fields	: ['text', 'value'],
		data	: [
			{'text': '1'	, 'value': '1'},
			{'text': '100'	, 'value': '100'}
		]
	});



	/** Model 정의
	 * @type
	 */
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'bpr580ukrvService.selectList',
			//update: 'bpr580ukrvService.updateDetail',
			create	: 'bpr580ukrvService.insertDetail',
			destroy	: 'bpr580ukrvService.deleteDetail',
			syncAll	: 'bpr580ukrvService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'bpr580ukrvService.selectList2',
			update	: 'bpr580ukrvService.updateDetail2',
			create	: 'bpr580ukrvService.insertDetail2',
			destroy	: 'bpr580ukrvService.deleteDetailGRID2',
			syncAll	: 'bpr580ukrvService.saveAll'
		}
	});



	Unilite.defineModel('bpr580ukrvModel1', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'		,type: 'string', defaultValue: UserInfo.compCode},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.base.division" default="사업장"/>'			,type: 'string', defaultValue: UserInfo.divCode},
			{name: 'PROD_ITEM_CODE'	,text: '<t:message code="system.label.base.parentitemcode" default="모품목코드"/>'	,type: 'string' ,allowBlank:false},
			{name: 'CHILD_ITEM_CODE',text: '<t:message code="system.label.base.childitemcode" default="자품목코드"/>'	,type: 'string', defaultValue: '$'},
			{name: 'ITEM_LEVEL1'	,text: '<t:message code="system.label.base.majorgroup" default="대분류"/>'			,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
			{name: 'ITEM_LEVEL2'	,text: '<t:message code="system.label.base.middlegroup" default="중분류"/>'		,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
			{name: 'ITEM_LEVEL3'	,text: '<t:message code="system.label.base.minorgroup" default="소분류"/>'			,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.base.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.base.spec" default="규격"/>'				,type: 'string'},
			{name: 'START_DATE'		,text: '<t:message code="system.label.base.startdate" default="시작일"/>'			,type: 'uniDate', defaultValue: UniDate.get('today'),allowBlank:false},
			{name: 'STOP_DATE'		,text: '<t:message code="system.label.base.enddate" default="종료일"/>'			,type: 'uniDate', defaultValue: '2999.12.31'},
			{name: 'LAB_NO'			,text: 'LAB_NO'			,type: 'string',allowBlank:false},
			{name: 'REQST_ID'		,text: '샘플ID'			,type: 'string',allowBlank:false}
		]
	});

	Unilite.defineModel('bpr580ukrvModel2', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				,type: 'string' , defaultValue: UserInfo.compCode},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.base.division" default="사업장"/>'					,type: 'string', defaultValue: UserInfo.divCode},
			{name: 'SEQ'			,text: '<t:message code="system.label.base.seq" default="순번"/>'							,type: 'int'},
			{name: 'PROD_ITEM_CODE'	,text: '<t:message code="system.label.base.parentitemcode" default="모품목코드"/>'			,type: 'string'},
			{name: 'CHILD_ITEM_CODE',text: '<t:message code="system.label.base.childitemcode" default="자품목코드"/>'			,type: 'string' ,allowBlank:false},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.base.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.base.spec" default="규격"/>'						,type: 'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.base.unit" default="단위"/>'						,type: 'string'},
			{name: 'OLD_PATH_CODE'	,text: '<t:message code="system.label.base.pathinfo" default="PATH정보"/>'				,type: 'string', defaultValue:'0', comboType: 'AU', comboCode:'B083'},
			{name: 'PATH_CODE'		,text: '<t:message code="system.label.base.pathinfo" default="PATH정보"/>'				,type: 'string', defaultValue:'0', comboType: 'AU', comboCode:'B083'},
			{name: 'UNIT_Q'			,text: '<t:message code="system.label.base.originunitqty" default="원단위량"/>'				,type: 'number', defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000' },
			{name: 'PROD_UNIT_Q'	,text: '<t:message code="system.label.base.parentitembaseqty" default="모품목기준수"/>'		,type: 'number', defaultValue:1},
			{name: 'LOSS_RATE'		,text: '<t:message code="system.label.base.lossrate" default="LOSS율"/>'					,type: 'number', defaultValue:0},
			{name: 'UNIT_P1'		,text: '<t:message code="system.label.base.materialcost" default="재료비"/>'				,type: 'uniPrice', defaultValue:0},
			{name: 'UNIT_P2'		,text: '<t:message code="system.label.base.laborexpenses" default="노무비"/>'				,type: 'uniPrice', defaultValue:0},
			{name: 'UNIT_P3'		,text: '<t:message code="system.label.base.expense" default="경비"/>'						,type: 'uniPrice', defaultValue:0},
			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.base.standardtacttime" default="표준공수"/>'			,type: 'uniQty', defaultValue:0},
			{name: 'USE_YN'			,text: '<t:message code="system.label.base.use" default="사용"/>'							,type: 'string'  , defaultValue:'1' ,store: Ext.data.StoreManager.lookup('bpr580ukrvBPRYnStore')},
			{name: 'BOM_YN'			,text: '<t:message code="system.label.base.compyn" default="구성여부"/>'					,type: 'string'  , defaultValue:'1' , comboType: 'AU', comboCode:'B097'},
			{name: 'START_DATE'		,text: '<t:message code="system.label.base.compstartdate" default="구성시작일"/>'			,type: 'uniDate' ,allowBlank:false, defaultValue: UniDate.get('today')},
			{name: 'STOP_DATE'		,text: '<t:message code="system.label.base.compenddate" default="구성종료일"/>'				,type: 'uniDate', defaultValue: '2999.12.31'},
			{name: 'REMARK'			,text: '<t:message code="system.label.base.remarks" default="비고"/>'						,type: 'string'},
			//20180516 추가
			{name: 'MATERIAL_CNT'	,text: '<t:message code="system.label.base.qty" default="수량"/>'							,type: 'int'},
			{name: 'SET_QTY'		,text: '<t:message code="system.label.base.stockcountingusagerate" default="실사용률(%)"/>'	,type: 'number', defaultValue:0},
			{name: 'GROUP_CODE'		,text: '<t:message code="system.label.base.routinggroup" default="공정그룹"/>'				,type: 'string'  , comboType: 'AU', comboCode:'B140'},
			{name: 'GRANT_TYPE'		,text: '사급'			,type: 'string', comboType: 'AU', comboCode:'M105'},
			{name: 'UPDATE_DB_USER'	,text: '<t:message code="system.label.base.writer" default="작성자"/>'						,type: 'string'},
			{name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.base.writtentiem" default="작성시간"/>'				,type: 'string'},
			{name: 'LAB_NO'			,text: 'LAB_NO'			,type: 'string'},
			{name: 'REQST_ID'		,text: '샘플ID'			,type: 'string'}
		]
	});

	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.bpr580ukrv.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'	, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'		, text:  '<t:message code="system.label.base.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.base.division" default="사업장"/>'					, type: 'string', comboType: 'BOR120' },
			{name: 'SPEC'			, text: '<t:message code="system.label.base.spec" default="규격"/>'						, type: 'string'},
			{name: 'SEQ'			, text:'<t:message code="system.label.base.seq" default="순번"/>'							, type: 'int'},
			{name: 'CHILD_ITEM_CODE', text: '<t:message code="system.label.base.childitemcode" default="자품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.base.itemname" default="품목명"/>'					, type: 'string'},				//거래처품목코드
			{name: 'STOCK_UNIT'		, text:'<t:message code="system.label.base.unit" default="단위"/>'						, type: 'string'	},
			{name: 'UNIT_Q'			, text:  '<t:message code="system.label.base.originunitqty" default="원단위량"/>'			, type: 'number', defaultValue:1},				//거래처품명
			{name: 'LOSS_RATE'		, text: '<t:message code="system.label.base.lossrate" default="LOSS율"/>'				, type: 'number', defaultValue:0},
			{name: 'SET_QTY'		, text:'<t:message code="system.label.base.stockcountingusagerate" default="실사용률(%)"/>'	, type: 'number', defaultValue:0},
			{name: 'GRANT_TYPE'		, text: '사급'			, type: 'string', comboType: 'AU', comboCode:'M105'},
			{name: 'REMARK'			, text: '<t:message code="system.label.base.remarks" default="비고"/>'					, type: 'string'},
			{name: 'GROUP_CODE'		, text: '<t:message code="system.label.base.routinggroup" default="공정그룹"/>'				, type: 'string'  , comboType: 'AU', comboCode:'B140'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('bpr580ukrvMasterStore1',{
		model	: 'bpr580ukrvModel1',
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
							Ext.getCmp('excelUploadButton').setDisabled(false);
							Ext.getCmp('COPY_BTN').setDisabled(false);
							Ext.getCmp('BASIS_QTY_COMBO').setDisabled(false);
						}else{
							console.log("no");
							Ext.getCmp('excelUploadButton').setDisabled(true);
							Ext.getCmp('COPY_BTN').setDisabled(true);
							Ext.getCmp('BASIS_QTY_COMBO').setDisabled(true);
						}
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

					}
				};
				this.syncAllDirect(config);

			} else {
				var grid = Ext.getCmp('bpr580ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				//if(successful) {
				if(records != null && records.length > 0 ){
					UniAppManager.setToolbarButtons('delete', true);
					panelResult.getField("DIV_CODE").setReadOnly(true);
					panelResult.getField("DIV_CODE").setReadOnly(true);
					masterGrid1.getSelectionModel().select( 0 )
					if(!directMasterStore2.isDirty()) {
						UniAppManager.setToolbarButtons('save', false);
					}else {
						UniAppManager.setToolbarButtons('save', true);
					}
				}else {
					panelResult.getField("DIV_CODE").setReadOnly(false);
				}

				if(directMasterStore1.count() == 0) {
					Ext.getCmp('COPY_BTN').setDisabled(true);
					Ext.getCmp('excelUploadButton').setDisabled(true);
					Ext.getCmp('BASIS_QTY_COMBO').setDisabled(true);
				} else {
					Ext.getCmp('COPY_BTN').setDisabled(false);
					Ext.getCmp('excelUploadButton').setDisabled(false);
					Ext.getCmp('BASIS_QTY_COMBO').setDisabled(false);
				}
				//}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
				if( directMasterStore2.isDirty() || store.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				} else {
					UniAppManager.setToolbarButtons('save', false);
				}
				if(store.getCount() > 0 || store.isDirty() ){
					panelResult.getField('DIV_CODE').setReadOnly(true);
					panelResult.getField('LAB_NO').setReadOnly(true);
					panelResult.getField('REQST_ID').setReadOnly(true);
					panelResult.getField('INPUT_DATE').setReadOnly(true);
					panelResult.getField('PROD_ITEM_CODE').setReadOnly(true);
					panelResult.getField('ITEM_NAME').setReadOnly(true);
				}else {
					panelResult.getField('DIV_CODE').setReadOnly(false);
					panelResult.getField('LAB_NO').setReadOnly(false);
					panelResult.getField('REQST_ID').setReadOnly(false);
					panelResult.getField('INPUT_DATE').setReadOnly(false);
					panelResult.getField('PROD_ITEM_CODE').setReadOnly(false);
					panelResult.getField('ITEM_NAME').setReadOnly(false);
					
					UniAppManager.setToolbarButtons('delete', true);
				}
			}
		}
	});

	var directMasterStore2 = Unilite.createStore('bpr580ukrvMasterStore2',{
		model	: 'bpr580ukrvModel2',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(record) {
			var searchParam= panelResult.getValues();
			var param= {
				'DIV_CODE'		: record.get('DIV_CODE'),
				'PROD_ITEM_CODE': record.get('PROD_ITEM_CODE'),
				'INPUT_DATE'	: record.get('INPUT_DATE'),
				'LAB_NO'		: record.get('LAB_NO'),
				'REQST_ID'		: record.get('REQST_ID')
			};
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
				if(records[0] != null){
					UniAppManager.setToolbarButtons('delete', true);
					masterGrid2.getSelectionModel().select( 0 );
					if(!directMasterStore1.isDirty()) {
						UniAppManager.setToolbarButtons('save', false);
					}
				} else {
					UniAppManager.setToolbarButtons('delete', true);
				}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function( store, eOpts ) {
				if( directMasterStore1.isDirty() || store.isDirty()) {
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
			var rv = true;
			var basisQtyChk = Ext.getCmp('BASIS_QTY_COMBO').getValue();

			if(directMasterStore2.isDirty()){
				if(basisQtyChk == '100'){
					if(directMasterStore2.sum('UNIT_Q') != 100){
						Unilite.messageBox("기준수를 100으로 세팅한 경우에는\n원단위량의 합계가 100이어야 합니다.");
						return false;
					}
				}
			}
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});



	var copyBomBtn = Ext.create('Ext.Button',{
		text	: '<t:message code="system.label.base.itemcopy" default="품목복사"/>',
		id		: 'COPY_BTN',
		app		: 'Unilite.app.popup.BomCopyPopup',
		handler	: function()  {
			if(!directMasterStore1.isDirty())  {
				if (masterGrid1.getSelectedRecord()  ){
					this.openPopup();
				}else {
					Unilite.messageBox('<t:message code="system.message.base.message010" default="모품목코드를 선택하세요."/>')
				}
			}
		},
		listeners:{
			onSelected: {
				fn: function(records, type) {
					var grd1Record = masterGrid1.getSelectedRecord();
					Ext.each(records, function(record,i) {
						//LAB_NO, REQST_ID는 masterGrid1의 데이터 그대로 사용, PROD_UNIT_Q는 그리드 상단의 "기준수" 사용
						var prodRecord	= masterGrid1.getSelectedRecord();
						var labNo		= prodRecord.get('LAB_NO');
						var reqstId		= prodRecord.get('REQST_ID');
						var basisQtyChk	= Ext.getCmp('BASIS_QTY_COMBO').getValue();
						var prodUnitQ	= 1;
						var unitQ		= 1;
						if(basisQtyChk == '100'){
							prodUnitQ	= 100;
							unitQ		= 1;
						}
						var r={
							'DIV_CODE'			: record.DIV_CODE,
							'SEQ'				: Unilite.nvl(directMasterStore2.max('SEQ'),0)+10,
							'PROD_ITEM_CODE'	: grd1Record.get('PROD_ITEM_CODE'),
							'CHILD_ITEM_CODE'	: record.CHILD_ITEM_CODE,
							'ITEM_NAME'			: record.ITEM_NAME,
							'SPEC'				: record.SPEC,
							'STOCK_UNIT'		: record.STOCK_UNIT,
							'ITEM_ACCOUNT'		: record.ITEM_ACCOUNT,
							'PATH_CODE'			: record.PATH_CODE,
							'UNIT_Q'			: record.UNIT_Q,
							'PROD_UNIT_Q'		: prodUnitQ,				//record.PROD_UNIT_Q,
							'LOSS_RATE'			: record.LOSS_RATE,
							'USE_YN'			: record.USE_YN,
							'BOM_YN'			: record.BOM_YN,
							'START_DATE'		: record.START_DATE,
							'STOP_DATE'			: record.STOP_DATE,
							'UNIT_P1'			: record.UNIT_P1,
							'UNIT_P2'			: record.UNIT_P2,
							'UNIT_P3'			: record.UNIT_P3,
							'MAN_HOUR'			: record.MAN_HOUR,
							'REMARK'			: record.REMARK,
							'LAB_NO'			: labNo,
							'REQST_ID'			: reqstId
						}
						masterGrid2.createRow(r, 'SEQ', Unilite.nvl(directMasterStore2.max('SEQ'),0)+10);
					});
				},
			scope: this
			}
		},
		openPopup: function() {
			var me = this;
			var prodRecord = masterGrid1.getSelectedRecord();
			var param = {
				'TYPE'		: 'TEXT',
				'pageTitle'	: '<t:message code="system.label.base.refprescription" default="처방참조"/>',
				'DIV_CODE'	: prodRecord.get('DIV_CODE'),
				'SEL_MODEL'	: 'MULTI'//,
				//처방등록의 경우 제조BOM팝업 호출하면서 조회 테이블 보여주도록 수정 - 20190916: 최초 데이터가 없어 bpr500t에서 조회하도록 수정(주석)
//				'TABLE_NAME': 'BPR580T'
			};
			if(me.app) {
				 var fn = function() {
					var oWin =  Ext.WindowMgr.get(me.app);
					if(!oWin) {
						oWin = Ext.create( me.app, {
							title			: '<t:message code="system.label.base.refprescription" default="처방참조"/>',
							id				: me.app,
							callBackFn		: me.processResult,
							callBackScope	: me,
							popupType		: 'TEXT',
							width			: 700,
							height			: 600,
							param			: param
						});
					}
					oWin.fnInitBinding(param);
					oWin.center();
					oWin.show();
				}
				Unilite.require(me.app, fn, this, true);
			}
		},
		processResult: function(result, type) {
			var me = this, rv;
			console.log("Result: ", result);
			if(result && Ext.isDefined(result) && result.status == 'OK') {
				me.fireEvent('onSelected',  result.data, type);
			}
		}
	})



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight	:-100,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5, tableAttrs: {width: '100%'}},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				value		: UserInfo.divCode,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},
			Unilite.popup('LAB_NO',{
				id				: 'LAB_NO_POPUP',
				fieldLabel		: 'LAB NO',
				valueFieldName	: 'LAB_NO',
				textFieldName	: 'REQST_ID',
				valueFieldWidth	: 150,
				textFieldWidth	: 150,
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					},
//					onClear: function(type) {
//						panelResult.setValue('LAB_NO'	, '');
//						panelResult.setValue('REQST_ID'	, '');
//					},
					applyextparam: function(popup){
//						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>',
				xtype		: 'uniDatefield',
				name		: 'INPUT_DATE',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				//컬럼 맞춤용
				xtype	: 'component',
				width	: 600,
				tdAttrs	: {width: 600}
			},{
				//컬럼 맞춤용
				xtype	: 'component',
				width	: 600,
				tdAttrs	: {width: 600}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.base.parentitemcode" default="모품목코드"/>',
				valueFieldName	: 'PROD_ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
//				autoPopup		: true,
				validateBlank	: false,
				colspan			: 2,
				extraFieldsConfig:[{extraFieldName:'SPEC', extraFieldWidth:153}],
				textFieldWidth	: 300,
				listeners		: {
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE'				: panelResult.getValue('DIV_CODE')});
						popup.setExtParam({'ITEM_ACCOUNT_FILTER'	: ['30','40']});
						popup.setExtParam({'DEFAULT_ITEM_ACCOUNT'	: '30'});
					}
				}
		 }),{
			fieldLabel	: '<t:message code="system.label.base.standardpathyn" default="표준Path 여부"/>',
			xtype		: 'uniRadiogroup',
			name		: 'StPathY',
			comboType	: 'AU',
			comboCode	: 'A020',
			width		: 240,
			hidden		: gsBomPathYN,
			allowBlank	: false,
			value		: 'Y',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			//컬럼 맞춤용
			xtype	: 'component',
			width	: 600,
			tdAttrs	: {width: 600}
		}]
	});



	var masterGrid1 = Unilite.createGrid('bpr580ukrvGrid1', {
		itemId	: 'bpr580ukrvGrid1',
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'west',
		flex	: .3,
		split	: true,
		excelTitle:'<t:message code="system.label.base.manufacturebomentryprodtcode" default="제조BOM등록(모품목코드)"/>',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns	: [
			{ dataIndex: 'COMP_CODE'		,width: 66	, hidden: true   },
			{ dataIndex: 'DIV_CODE'			,width: 66	, hidden: true   },
			{ dataIndex: 'PROD_ITEM_CODE'	,width: 90	, tdCls:'x-change-cell',
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'PROD_ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
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
							popup.setExtParam({'DIV_CODE'				: panelResult.getValue('DIV_CODE')});
							popup.setExtParam({'ITEM_ACCOUNT_FILTER'	: ['30','40']});
							popup.setExtParam({'DEFAULT_ITEM_ACCOUNT'	: '30'});
						}
					}
				})
			},
			{ dataIndex: 'CHILD_ITEM_CODE'	,width: 66	, hidden: true},
			{ dataIndex: 'ITEM_NAME'		,width: 166 ,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
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
							popup.setExtParam({'DIV_CODE'				: panelResult.getValue('DIV_CODE')});
							popup.setExtParam({'ITEM_ACCOUNT_FILTER'	: ['10','20']});
							popup.setExtParam({'DEFAULT_ITEM_ACCOUNT'	: '10'});
						}
					}
				})
			},
			{ dataIndex: 'SPEC'				,width: 100},
			{ dataIndex: 'START_DATE'		,width: 80	, hidden: false},
			{ dataIndex: 'STOP_DATE'		,width: 80	, hidden: true},
			{ dataIndex: 'LAB_NO'			,width: 130	,
				editor: Unilite.popup('LAB_NO_G',{
					allowBlank		: false,
					listeners		: {
						scope:this,
						onSelected:function(records, type ) {
							var grdRecord = masterGrid1.uniOpt.currentRecord;
							grdRecord.set('LAB_NO'	,records[0]['LAB_NO']);
							grdRecord.set('REQST_ID',records[0]['REQST_ID']);

						},
						onClear:function(type) {
							var grdRecord = masterGrid1.uniOpt.currentRecord;
							grdRecord.set('LAB_NO'	,'');
							grdRecord.set('REQST_ID','');
						}
					}
				})
			},
			{ dataIndex: 'REQST_ID'			,width: 100	,
				editor: Unilite.popup('LAB_NO_G',{
					allowBlank		: false,
					listeners		: {
						scope:this,
						onSelected:function(records, type ) {
							var grdRecord = masterGrid1.uniOpt.currentRecord;
							grdRecord.set('LAB_NO'	, records[0]['LAB_NO']);
							grdRecord.set('REQST_ID', records[0]['REQST_ID']);

						},
						onClear:function(type) {
							var grdRecord = masterGrid1.uniOpt.currentRecord;
							grdRecord.set('LAB_NO'	,'');
							grdRecord.set('REQST_ID','');
						}
					}
				})
			}

		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore2.isDirty()){
						Unilite.messageBox(Msg.sMB154);
						return false;
					} else {
						masterSelectedGrid = girdNm;
						if(grid.getStore().getCount() > 0) {
							UniAppManager.setToolbarButtons('delete', true);
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
					}
				});
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					return false;
				}
				if (UniUtils.indexOf(e.field,['COMP_CODE', 'DIV_CODE', 'CHILD_ITEM_CODE', 'SPEC']))
					return false;
				else
					return true;
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0) {
					var record = selected[0];
					directMasterStore2.loadData({})
					directMasterStore2.loadStoreRecords(record);
				}
			},
			returnData: function(record) {
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
			}
			else {
				grdRecord.set('PROD_ITEM_CODE'	, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('bpr580ukrvGrid2', {
		itemId	: 'bpr580ukrvGrid2',
		store	: directMasterStore2,
		layout	: 'fit',
		region	:'north',
		split	: true,
		flex	: .7,
		excelTitle:'<t:message code="system.label.base.manufacturebomentrychildcode" default="제조BOM등록(자품목코드)"/>',
		uniOpt	: {
			onLoadSelectFirst	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		tbar:[{
				name		: 'BASIS_QTY' ,
				fieldLabel	: '<t:message code="system.label.base.basisqty" default="기준수"/>' ,
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('bpr580ukrvBasisQtyStore'),
				id			: 'BASIS_QTY_COMBO',
				labelWidth	: 53,
				width		: 180,
				fieldStyle	: 'text-align: center;',
				value		: '100',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},'-',{
				xtype	: 'button',
				text	: '엑셀업로드',
				id		: 'excelUploadButton',
				width	: 100,
				handler	: function() {
					var records = masterGrid1.getSelectedRecord();
					if(Ext.isEmpty(records)){
						Unilite.messageBox("모품목을 선택해주세요.")
						return false;
					}else{
						openExcelWindow();
					}
				}
			},copyBomBtn,'-'
		],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	  showSummaryRow: true} ],
		columns	: [
			{ dataIndex: 'COMP_CODE'		,width: 66	, hidden: true },
			{ dataIndex: 'DIV_CODE'			,width: 66	, hidden: true },
			{ dataIndex: 'PROD_ITEM_CODE'	,width: 66	, hidden: true },
			{ dataIndex: 'SEQ'				,width: 50 },
			{ dataIndex: 'CHILD_ITEM_CODE'	,width: 120	, tdCls:'x-change-cell' ,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'CHILD_ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					uniOpt:{
						recordFields: ['COMP_CODE','DIV_CODE','PROD_ITEM_CODE'],
						grid		: 'bpr580ukrvGrid1'
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
							popup.setExtParam({'DEFAULT_ITEM_ACCOUNT'	: '60'});
						}
					}
				})
			},
			{ dataIndex: 'ITEM_NAME'		,width: 200	,
				editor: Unilite.popup('DIV_PUMOK_G', {
					uniOpt:{
						recordFields: ['COMP_CODE','DIV_CODE','PROD_ITEM_CODE'],
						grid		: 'bpr580ukrvGrid1'
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
							popup.setExtParam({'DEFAULT_ITEM_ACCOUNT'	: '60'});
						}
					}
				})
			},
			{ dataIndex: 'SPEC'				,width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.base.totalamount" default="합계"/>');
				}
			},
			{ dataIndex: 'STOCK_UNIT'		,width: 40},
			{ dataIndex: 'OLD_PATH_CODE'	,width: 90	, hidden: true },
			{ dataIndex: 'PATH_CODE'		,width: 90	, hidden: gsBomPathYN },
			{ dataIndex: 'UNIT_Q'			,width: 90	, xtype: 'uniNnumberColumn'	, summaryType: 'sum' },
			{ dataIndex: 'PROD_UNIT_Q'		,width: 100	, format:'0,000.000'		, editor:{format:'0,000.000'}},
			{ dataIndex: 'LOSS_RATE'		,width: 80	, format:'0,000.000'		, editor:{format:'0,000.000'}},
			{ dataIndex: 'SET_QTY'			,width: 100	, format:'0,000.000'		, editor:{format:'0,000.000'}},
			{ dataIndex: 'GROUP_CODE'		,width: 80	, align: 'center'},
//			{ dataIndex: 'UNIT_P1'			,width: 80 },
//			{ dataIndex: 'UNIT_P2'			,width: 80 },
//			{ dataIndex: 'UNIT_P3'			,width: 80 },
//			{ dataIndex: 'MAN_HOUR'			,width: 80 },
//			//20180516 MATERIAL_CNT, SET_QTY 추가
//			{ dataIndex: 'MATERIAL_CNT'		,width: 80 },
			{ dataIndex: 'USE_YN'			,width: 80 },
			{ dataIndex: 'BOM_YN'			,width: 80 },
			{ dataIndex: 'START_DATE'		,width: 100	, tdCls:'x-change-cell'},
			{ dataIndex: 'STOP_DATE'		,width: 100 },
			{ dataIndex: 'GRANT_TYPE'		,width: 100	, align:'center'	, hidden: true },
			{ dataIndex: 'REMARK'			,width: 226	, hidden: true },
			{ dataIndex: 'UPDATE_DB_USER'	,width: 66	, hidden: true },
			{ dataIndex: 'UPDATE_DB_TIME'	,width: 66	, hidden: true },
			{ dataIndex: 'LAB_NO'			,width: 130	,
				editor: Unilite.popup('LAB_NO_G',{
					validateBlank	: false,
					autoPopup		: false,
					listeners		: {
						scope:this,
						onSelected:function(records, type ) {
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('LAB_NO',records[0]['LAB_NO']);
							grdRecord.set('REQST_ID',records[0]['REQST_ID']);

						},
						onClear:function(type) {
							var grdRecord = masterGrid2.uniOpt.currentRecord;
//							grdRecord.set('LAB_NO','');
//							grdRecord.set('REQST_ID','');
						}
					}
				})
			},
			{ dataIndex: 'REQST_ID'			,width: 100	,
				editor: Unilite.popup('LAB_NO_G',{
					validateBlank	: false,
					autoPopup		: false,
					listeners		: {
						scope:this,
						onSelected:function(records, type ) {
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('LAB_NO'	, records[0]['LAB_NO']);
							grdRecord.set('REQST_ID', records[0]['REQST_ID']);

						},
						onClear:function(type) {
							var grdRecord = masterGrid2.uniOpt.currentRecord;
//							grdRecord.set('LAB_NO','');
//							grdRecord.set('REQST_ID','');
						}
					}
				})
			}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore1.isDirty()){
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
				if (UniUtils.indexOf(e.field, ['DIV_CODE','PROD_ITEM_CODE', 'SPEC', 'STOCK_UNIT', 'LAB_NO', 'REQST_ID'])) {
					return false;
				}
				if(!e.record.phantom){
					if(UniUtils.indexOf(e.field, ['CHILD_ITEM_CODE','ITEM_NAME','START_DATE'])) {
						return false;
					}
				}
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0) {
					var record = selected[0];
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			var basisQtyChk = Ext.getCmp('BASIS_QTY_COMBO').getValue();
			var prodUnitQ = 1;
			var unitQ = 1;
			if(basisQtyChk == '100'){
				prodUnitQ = 100;
				unitQ = 1;
			}
			if(dataClear) {
				grdRecord.set('CHILD_ITEM_CODE'	,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('OLD_PATH_CODE'	, "0");
				grdRecord.set('PATH_CODE'		, "0");
				grdRecord.set('UNIT_Q'			, unitQ);
				grdRecord.set('PROD_UNIT_Q'		, prodUnitQ);
				grdRecord.set('LOSS_RATE'		, 0);
				grdRecord.set('UNIT_P1'			, 0);
				grdRecord.set('UNIT_P2'			, 0);
				grdRecord.set('UNIT_P3'			, 0);
				grdRecord.set('MAN_HOUR'		, 0);
				grdRecord.set('USE_YN'			, 1);
				grdRecord.set('BOM_YN'			, 1);
				grdRecord.set('START_DATE'		, UniDate.get('today'));
				grdRecord.set('STOP_DATE'		, '2999.12.31');
				grdRecord.set('REMARK'			, '');
			} else {
				grdRecord.set('CHILD_ITEM_CODE'	, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('OLD_PATH_CODE'	, "0");
				grdRecord.set('PATH_CODE'		, "0");
				grdRecord.set('UNIT_Q'			, unitQ);
				grdRecord.set('PROD_UNIT_Q'		, prodUnitQ);
				grdRecord.set('LOSS_RATE'		, 0);
				grdRecord.set('UNIT_P1'			, record['BASIS_P']);
				grdRecord.set('UNIT_P2'			, 0);
				grdRecord.set('UNIT_P3'			, 0);
				grdRecord.set('MAN_HOUR'		, 0);
				grdRecord.set('USE_YN'			, 1);
				grdRecord.set('BOM_YN'			, 1);
				grdRecord.set('START_DATE'		, UniDate.get('today'));
				grdRecord.set('STOP_DATE'		, '2999.12.31');
				grdRecord.set('REMARK'			, record['REMARK']);
				grdRecord.set('UPDATE_DB_USER'	, record['UPDATE_DB_USER']);
				grdRecord.set('UPDATE_DB_TIME'	, record['UPDATE_DB_TIME']);
			}
		},
		setExcelData: function(record, grdRecord) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('CHILD_ITEM_CODE'	, record['CHILD_ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('SEQ'				, record['SEQ']);
			grdRecord.set('SET_QTY'			, record['SET_QTY']);
			grdRecord.set('UNIT_Q'			, record['UNIT_Q']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('LOSS_RATE'		, record['LOSS_RATE']);
			grdRecord.set('OLD_PATH_CODE'	, "0");
			grdRecord.set('PATH_CODE'		, "0");
			grdRecord.set('USE_YN'			, 1);
			grdRecord.set('BOM_YN'			, 1);
			grdRecord.set('REMARK'			, record['REMARK']);
			grdRecord.set('START_DATE'		, UniDate.get('today'));
			grdRecord.set('GROUP_CODE'		, record['GROUP_CODE']);
			grdRecord.set('GRANT_TYPE'		, record['GRANT_TYPE']);
			
			var masterRecord = masterGrid1.getSelectedRecord();
			grdRecord.set('LAB_NO'			, masterRecord.get('LAB_NO'));
			grdRecord.set('REQST_ID'		, masterRecord.get('REQST_ID'));
		}
	});



	//처방정보 엑셀업로드 윈도우 생성 함수
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		//필수 입력정보 체크
		if (!panelResult.getInvalidMessage()) {
			return false;
		}
		if(directMasterStore1.isDirty() || directMasterStore2.isDirty()) {	//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
			//	masterGrid2.reset();
			//	directMasterStore2.clearData();
			}
		}
		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DIV_CODE = panelResult.getValue('DIV_CODE');
		}
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 'bpr580ukrv',
				width	: 600,
				height	: 400,
				modal	: false,
				extParam: {
					'PGM_ID'		: 'bpr580ukrv',
					'DIV_CODE'		: panelResult.getValue('DIV_CODE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '처방정보 엑셀업로드',
						useCheckbox	: false,
						model		: 'excel.bpr580ukrv.sheet01',
						readApi		: 'bpr580ukrvService.selectExcelUploadSheet1',
						columns		: [
							{dataIndex: '_EXCEL_JOBID'		, width: 80		, hidden: true},
							{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
							{dataIndex: 'DIV_CODE'			, width: 66},
							{dataIndex: 'SEQ'				, width: 50		, hidden: false},
							{dataIndex: 'CHILD_ITEM_CODE'	, width: 100},
							{dataIndex: 'ITEM_NAME'			, width: 200},
							{dataIndex: 'STOCK_UNIT'		, width: 40},
							{dataIndex: 'UNIT_Q'			, width: 80},
							{dataIndex: 'LOSS_RATE'			, width: 80},
							{dataIndex: 'SET_QTY'			, width: 100},
							{dataIndex: 'GROUP_CODE'		, width: 100	, align:'center'},
							{dataIndex: 'GRANT_TYPE'		, width: 100	, hidden: false},
							{dataIndex: 'REMARK'			, width: 200	, hidden: false}
						]
					}
				],
				listeners: {
					beforeshow: function( panel, eOpts ) {
						//행추가 후에는 master 입력값 변경 불가
						panelResult.getField('PROD_ITEM_CODE').setReadOnly(true);
						panelResult.getField('ITEM_NAME').setReadOnly(true);

					},
					close: function() {
						var me		= this;
						var grid	= this.down('#grid01');
						excelWindow.getEl().unmask();
						grid.getStore().removeAll();
						this.hide();
					}
				},
				onApply:function()  {
					var flag = true
					var grid = this.down('#grid01');
					var records =  grid.getStore().data.items;
					Ext.each(records, function(record,i){
						if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
							console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
							flag = true;
							return false;
						}
						UniAppManager.app.onNewDataButtonDown();
						masterGrid2.setExcelData(record.data);
					});
					if(!flag){
						Unilite.messageBox("에러가 있는 행은 적용이 불가능합니다.");
					} else {
						// grid.getStore().remove(records);
						var beforeRM = grid.getStore().count();
						grid.getStore().remove(records);
						var afterRM = grid.getStore().count();
						if (beforeRM > 0 && afterRM == 0){
						   excelWindow.close();
						}
					}
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};



	Unilite.Main( {
		id			: 'bpr580ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid1,{
				region	: 'center',
				layout	: {type: 'vbox', align: 'stretch'},
				border	: false,
				flex	: .6,
				items	: [masterGrid2]
			}]
		},
		panelResult
		],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			Ext.getCmp('COPY_BTN').setDisabled(true);
			Ext.getCmp('excelUploadButton').setDisabled(true);
			Ext.getCmp('BASIS_QTY_COMBO').setDisabled(true);

			masterSelectedGrid = 'bpr580ukrvGrid1';
			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown : function()  {
			if(!panelResult.getInvalidMessage()){
				return false;
			}
			masterGrid1.getStore().loadStoreRecords();
			//  beforeRowIndex = -1;
		},
		onNewDataButtonDown: function() {
			//panelResult의 LAP_NO 팝업을 입력 조건으로 사용할 경우 필요한 로직
//			var param = panelResult.getValues();
//			bpr580ukrvService.checkLabNo(param,function(provider, response){
//				if(provider && provider.data == 1) {
					if(masterSelectedGrid == 'bpr580ukrvGrid1'){
//						var labNo	= panelResult.getValue('LAB_NO');
//						var reqstId	= panelResult.getValue('REQST_ID');
						var r = {
							'DIV_CODE'	: panelResult.getValue('DIV_CODE'),
							'START_DATE': Ext.isEmpty(panelResult.getValue('INPUT_DATE')) ? UniDate.get('today') : panelResult.getValue('INPUT_DATE')//,
//							'LAB_NO'	: labNo,
//							'REQST_ID'	: reqstId
						}
						masterGrid1.createRow(r);

						if( directMasterStore1.isDirty() || directMasterStore2.isDirty()) {
							UniAppManager.setToolbarButtons(['save'], true);
						}else {
							UniAppManager.setToolbarButtons(['save'], false);
						}
		
					} else if(masterSelectedGrid == 'bpr580ukrvGrid2'){
						var masterRecord = masterGrid1.getSelectedRecord();
						var labNo	= masterRecord.get('LAB_NO');
						var reqstId	= masterRecord.get('REQST_ID');
						var seq = directMasterStore2.max('SEQ');
						if(!seq) seq = 1;
						else  seq += 1;
						var basisQtyChk = Ext.getCmp('BASIS_QTY_COMBO').getValue();
						var prodUnitQ = 1;
						var unitQ = 1;
						if(basisQtyChk == '100'){
							prodUnitQ = 100;
							unitQ = 1;
						}
						if(masterRecord) {
							var r = {
								SEQ				: seq,
								DIV_CODE		: panelResult.getValue('DIV_CODE'),
								PROD_ITEM_CODE	: masterRecord.get('PROD_ITEM_CODE'),
								PROD_UNIT_Q		: prodUnitQ,
								UNIT_Q			: unitQ,
								MATERIAL_CNT	: 1,
								SET_QTY			: 100,
								LAB_NO			: labNo,
								REQST_ID		: reqstId
							};
							masterGrid2.createRow(r);

							if( directMasterStore1.isDirty() || directMasterStore2.isDirty()) {
								UniAppManager.setToolbarButtons(['save'], true);
							}else {
								UniAppManager.setToolbarButtons(['save'], false);
							}
						}
					} else {
						Unilite.messageBox('행 추가할 그리드를 선택해 주십시오.');
						return false;
					}
					panelResult.getField('DIV_CODE').setReadOnly(true);
					panelResult.getField('LAB_NO').setReadOnly(true);
					panelResult.getField('REQST_ID').setReadOnly(true);
					panelResult.getField('INPUT_DATE').setReadOnly(true);
					panelResult.getField('PROD_ITEM_CODE').setReadOnly(true);
					panelResult.getField('ITEM_NAME').setReadOnly(true);

//				} else {
//					Unilite.messageBox('잘못된 LAB NO정보가 입력 되었습니다.');
//					return false;
//				}
//			});
		},
		onResetButtonDown: function() {
			panelResult.reset();
			panelResult.clearForm()
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.getField('DIV_CODE').setReadOnly(false);
			panelResult.getField('LAB_NO').setReadOnly(false);
			panelResult.getField('REQST_ID').setReadOnly(false);
			panelResult.getField('INPUT_DATE').setReadOnly(false);
			panelResult.getField('PROD_ITEM_CODE').setReadOnly(false);
			panelResult.getField('ITEM_NAME').setReadOnly(false);
			masterGrid1.getStore().loadData({});
			masterGrid2.getStore().loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
			directMasterStore2.saveStore();
		},
		onDeleteDataButtonDown: function() {
			if(masterSelectedGrid == 'bpr580ukrvGrid1'){
				var Grid1 = UniAppManager.app.down('#bpr580ukrvGrid1');
				var selRow = masterGrid1.getSelectedRecord();
				var selIndex = masterGrid1.getSelectedRowIndex();

				if(Ext.isEmpty(selRow)) {
					Unilite.messageBox('삭제할 행이 없습니다.');
					return false;
				}
				if(selRow.phantom === true) {
					masterGrid1.deleteSelectedRow();
				} else if(selRow.phantom !== true && directMasterStore2.getCount() > 0 ) {
					Unilite.messageBox('<t:message code="system.message.base.message012" default="자품목코드가 존재합니다.먼저 자품목코드를 삭제후 모품목코드를 삭제하십시오."/>');
				} else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid1.deleteSelectedRow(selIndex);
					masterGrid1.getStore().onStoreActionEnable();
				}

			} else if(masterSelectedGrid == 'bpr580ukrvGrid2'){
				var Grid1 = UniAppManager.app.down('#bpr580ukrvGrid2');
				var selRow = masterGrid2.getSelectedRecord();
				var selIndex = masterGrid2.getSelectedRowIndex();

				if(Ext.isEmpty(selRow)) {
					Unilite.messageBox('삭제할 행이 없습니다.');
					return false;
				}
				if(selRow.phantom === true) {
					masterGrid2.deleteSelectedRow();
				} else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid2.deleteSelectedRow(selIndex);
					masterGrid2.getStore().onStoreActionEnable();
				}
			}
		},
		rejectSave: function() {	// 저장
			if(masterSelectedGrid == 'bpr580ukrvGrid2'){
				var rowIndex = masterGrid2.getSelectedRowIndex();
				masterGrid2.select(rowIndex);
				directMasterStore2.rejectChanges();

				if(rowIndex >= 0){
					masterGrid2.getSelectionModel().select(rowIndex);
					var selected = masterGrid2.getSelectedRecord();
				}
				directMasterStore2.onStoreActionEnable();
			}
		},
		confirmSaveData: function(config) {
			var fp = Ext.getCmp('bpr580ukrvFileUploadPanel');
			if(directMasterStore1.isDirty()) {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		}
	});




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
					if(newValue <= 0) {
						rv=Msg.sMB076;
						record.set('UNIT_Q',oldValue);
						break;
					}
					break;

				case "PROD_UNIT_Q" :
					if(newValue <= 0) {
						rv=Msg.sMB076;
						record.set('PROD_UNIT_Q',oldValue);
						break;
					}
					break;

				case "SEQ" :
					if(newValue <= 0) {
						rv=Msg.sMB076;
						record.set('SEQ',oldValue);
						break;
					}
					break;

				case "UNIT_P1" :
					if(newValue <= 0) {
						rv=Msg.sMB076;
						record.set('UNIT_P1',oldValue);
						break;
					}
					break;

				case "UNIT_P2" :
					if(newValue <= 0) {
						rv=Msg.sMB076;
						record.set('UNIT_P2',oldValue);
						break;
					}
					break;

				case "UNIT_P3" :
					if(newValue <= 0) {
						rv=Msg.sMB076;
						record.set('UNIT_P3',oldValue);
						break;
					}
					break;

				case "MAN_HOUR" :
					if(newValue <= 0) {
						rv=Msg.sMB076;
						record.set('MAN_HOUR',oldValue);
						break;
					}
					break;

				case "PRIOR_SEQ" :
					if(newValue <= 0) {
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
