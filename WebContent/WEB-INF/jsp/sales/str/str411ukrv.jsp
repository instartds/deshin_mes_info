<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str411ukrv">
	<t:ExtComboStore comboType="BOR120"  pgmId="str411ukrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="A"  comboCode="B066"/>			<!-- 계산서종류(11: 세금계산서, 20: 계산서) -->
	<t:ExtComboStore comboType="A"  comboCode="B086"/>			<!-- 전자문서구분 -->
	<t:ExtComboStore comboType="A"  comboCode="S050"/>			<!-- 전자세금계산서상태 -->
	<t:ExtComboStore comboType="A"  comboCode="S080"/>			<!-- 응답상태코드(웹캐시)-->
	<t:ExtComboStore comboType="A"  comboCode="S093"/>			<!-- 국세청 신고제외여부(N: 신고대상, Y: 신고제외대상)-->
	<t:ExtComboStore comboType="A"  comboCode="S094"/>			<!-- 국세청 신고상태 -->
	<t:ExtComboStore comboType="A"  comboCode="S095"/>			<!-- 국세청 수정사유 -->
	<t:ExtComboStore comboType="A"  comboCode="S096"/>			<!-- 세금계산서구분(1: 정상발행, 2: 수정발행) -->
	<t:ExtComboStore comboType="A"  comboCode="S099"/>			<!-- 전자세금계산서입력경로(1: 영업, 3: 회계, 5: 무역) -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsStr411UkrLink: '${gsStr411UkrLink}',
	gsOptQ	: '${gsOptQ}',		//수량단위구분(1:판매단위, 2:재고단위)
	gsBillYN: ${gsBillYN}		//SUB_CODE: '02' taxbill, REF_CODE4: 품목표시컬럼설정(CODE/NAME), REF_CODE5: 품목정보수정여부(Y/N), REF_CODE6: 출력여부(Y/N), REF_CODE7: 출력파일명, REF_CODE8: 페이지내 최대건수, REF_CODE9: 합계표시여부(거래명세서 출력) 
};
var isOptQ = false;				//수량단위구분, 단가금액출력여부
if(BsaCodeInfo.gsOptQ == '2'){
	isOptQ = true;
}
var beforeRowIndex;				//마스터그리드 같은row중복 클릭시 다시 load되지 않게
var billTypeIsHidden = true;	//전자문서구분 hidden 여부
//20200421 전자문서구분 센드빌만 사용 - 주석: hidden: true
//BsaCodeInfo.gsBillYN[0].SUB_CODE == "01"? billTypeIsHidden = false : billTypeIsHidden = true;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'str411ukrvService.selectDetail',
			create	: 'str411ukrvService.insertDetail',
			update	: 'str411ukrvService.updateDetail',
			destroy	: 'str411ukrvService.deleteDetail',
			syncAll	: 'str411ukrvService.saveAll'
		}
	});

	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('str411ukrvWebCashModel', {	//"02" 웹캐시용 모델
		fields: [
			{name: 'TRANSYN_NAME'		,text: '전송'					,type: 'string'},
			{name: 'STAT_CODE'			,text: '상태'					,type: 'string', allowBlank: false},
			{name: 'STS'				,text: '상태'					,type: 'string'},
			{name: 'REGS_DATE'			,text: '<t:message code="system.label.sales.publishdate" default="발행일"/>'		,type: 'uniDate', allowBlank: false},
			{name: 'SELR_CORP_NO'		,text: '공급자 사업자번호'			,type: 'string', allowBlank: false},
			{name: 'SELR_CORP_NM'		,text: '공급자 업체명'			,type: 'string', allowBlank: false},
			{name: 'SELR_CEO'			,text: '공급자 대표자명'			,type: 'string', allowBlank: false},
			{name: 'SELR_CORP_ADDS'		,text: '공급자 주소'				,type: 'string'},
			{name: 'SELR_BUSS_CONS'		,text: '공급자 업태'				,type: 'string'},
			{name: 'SELR_BUSS_TYPE'		,text: '공급자 업종'				,type: 'string'},
			{name: 'SELR_TEL'			,text: '공급자 전화번호'			,type: 'string'},
			{name: 'BUYR_CORP_NO'		,text: '사업자번호'				,type: 'string', allowBlank: false},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.client" default="고객"/>'				,type: 'string'},
			{name: 'BUYR_CORP_NM'		,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'		,type: 'string', allowBlank: false},
			{name: 'BUYR_CEO'			,text: '공급받는자 대표자명'			,type: 'string'},
			{name: 'BUYR_CORP_ADDS'		,text: '공급받는자 주소'			,type: 'string'},
			{name: 'BUYR_TEL'			,text: '공급받는자 전화번호'			,type: 'string'},
			{name: 'CHRG_AMT'			,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'		,type: 'uniPrice', allowBlank: false},
			{name: 'TAX_AMT'			,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'			,type: 'uniPrice'},
			{name: 'TOTL_AMT'			,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'		,type: 'uniPrice'},
			{name: 'SUM_AMT'			,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'		,type: 'uniPrice'},
			{name: 'BUYR_CHRG_NM1'		,text: '<t:message code="system.label.sales.charger" default="담당자"/>'			,type: 'string'},
			{name: 'BUYR_CHRG_MOBL1'	,text: '핸드폰'				,type: 'string'},
			{name: 'BUYR_CHRG_EMAIL1'	,text: 'E-MAIL'				,type: 'string'},
			{name: 'SND_MAL_YN'			,text: 'Email발행요청유무'		,type: 'string'},
			{name: 'SND_SMS_YN'			,text: 'SMS발행요청유무'			,type: 'string'},
			{name: 'SND_FAX_YN'			,text: 'FAX발행요청유무'			,type: 'string'},
			{name: 'BILLSEQ'			,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'			,type: 'string'},
			{name: 'ERP_SEQ'			,text: '전자문서번호'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'	,type: 'string'},
			{name: 'DEL_YN'				,text: '삭제가능여부'				,type: 'string'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'			,type: 'string'},
			{name: 'ERR_GUBUN'			,text: '에러구분'				,type: 'string'},
			{name: 'SEND_DATE'			,text: '전송일시'				,type: 'uniDate'}
		]
	});

	Unilite.defineModel('str411ukrvDetailModel', {	//디테일 모델 샌드빌, 웹캐시 공통 사용
		fields: [
			{name: 'DT'				,text: '<t:message code="system.label.sales.businessdate" default="거래일"/>'	,type: 'uniDate'},
			{name: 'CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
			{name: 'NAME'			,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
			{name: 'UNIT'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},
			{name: 'VLM'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'DANGA'			,text: '<t:message code="system.label.sales.price" default="단가"/>'			,type: 'uniUnitPrice'},
			{name: 'SUP'			,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'	,type: 'uniPrice'},
			{name: 'TAX'			,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'		,type: 'uniPrice'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		,type: 'string'},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'},
			{name: 'PUB_NUM'		,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'		,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'},
			{name: 'SALE_UNIT'		,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'	,type: 'string'},
			{name: 'TRANS_RATE'		,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'	,type: 'string'}
		]
	});

	var webCashStore = Unilite.createStore('str411ukrvWebCashStore',{	//웹캐시 store
		model	: 'str411ukrvWebCashModel',
		uniOpt	: {
			isMaster	: true,		//상위 버튼 연결 
			editable	: true,		//수정 모드 사용 
			deletable	: false,	//삭제 가능 여부 
			useNavi		: false		//prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'str411ukrvService.WebCashMaster'
			}
		},
		loadStoreRecords: function(BILL_SEND_YN) {
			var param = panelResult.getValues();
			if(!Ext.isEmpty(BILL_SEND_YN)) {
				param.BILL_SEND_YN = BILL_SEND_YN;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					detailStore.loadStoreRecords(records[0]);
					var viewNormal = detailGrid.getView();
					viewNormal.getFeature('detailGridTotal').toggleSummaryRow(true);
					UniAppManager.app.fnWebCashColSet(records);	//전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기
				} else {
					detailStore.loadData({});
				}
			}
		}
	});

	var detailStore = Unilite.createStore('str411ukrvDetailStore',{
		model	: 'str411ukrvDetailModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		//상위 버튼 연결 
			editable	: true,		//수정 모드 사용 
			deletable	: false,	//삭제 가능 여부 
			useNavi		: false		//prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(record){
			var gridParam = record.data; 
			var formParam = {};
			formParam.UNIT_TYPE = panelResult.getValues().UNIT_TYPE;
			var params = Ext.merge(gridParam, formParam);
			this.load({
				params : params
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//3.기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					} 
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('str411ukrvDetailGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});

	/** Panel
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		padding		: '1 1 1 1',
		border		: true,
		autoScroll	: true,
		layout		: {type : 'uniTable', columns : 3},
		items		: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.publishdate" default="발행일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'BILL_DATE_FR',
			endFieldName	: 'BILL_DATE_TO',
			allowBlank		: false,
			colspan			: 2,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},
		Unilite.popup('AGENT_CUST',{ 
			fieldLabel		: '<t:message code="system.label.sales.client" default="고객"/>',
			valueFieldName	: 'CUSTOM_CODE', 
			textFieldName	: 'CUSTOM_NAME', 
			validateBlank	: false, 
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){

					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '상태',
			name		: 'BILL_STAT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S080',
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '전송여부',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '미전송',
				name		: 'BILL_SEND_YN',
				inputValue	: 'N',
				width		: 80,
				checked		: true
			},{
				boxLabel	: '전송',
				name		: 'BILL_SEND_YN',
				inputValue	: 'Y',
				width		: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue.BILL_SEND_YN == 'N') {
						webCashGrid.down('#btnSend').enable();
						webCashGrid.down('#btnReSend').disable();
						webCashGrid.down('#btnDelete').disable();
					} else {
						webCashGrid.down('#btnSend').disable();
						webCashGrid.down('#btnReSend').enable();
						webCashGrid.down('#btnDelete').enable();
					}
					UniAppManager.app.onQueryButtonDown(newValue.BILL_SEND_YN);
				}
			} 
		},{	//20200421 전자문서구분 센드빌만 사용: hidden: true
			fieldLabel	: '전자문서구분',
			name		: 'BILL_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B086',
			hidden		: true, 				//billTypeIsHidden,
			colspan		: 2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20200421 전자문서구분 센드빌만 사용: hidden: false
			xtype		: 'component',
			hidden		: false,				//!billTypeIsHidden,
			colspan		: 2,
			width		: 100,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '에러내용',
			name		: 'TXT_ERR_MSG',
			xtype		: 'uniTextfield',
			width		: 640,
			readOnly	: true,
			colspan		: 3,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'container',
			colspan	: 3,
			html	: '<hr></hr>'
		},{
			fieldLabel	: '수량단위구분',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.salesunit" default="판매단위"/>',
				name		: 'UNIT_TYPE',
				inputValue	: '1',
				width		: 80,
				checked		: !isOptQ
			},{
				boxLabel	: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>',
				name		: 'UNIT_TYPE',
				inputValue	: '2',
				width		: 80,
				checked		: isOptQ
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			} 
		},{
			xtype	: 'container',
			margin	: '0 0 0 16',
			layout	: {type: 'uniTable', columns: 2},
			style	: {
				color: 'blue'
			},
			items:[{
				xtype	: 'container',
				html	: '공급자는 사업장정보, 공급받는자는 거래처정보에서 회사명, 대표자, 업태, 업종, 주소, 전화번호, EMAIL 등을 참조합니다.'
			}]
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r				= false;
					var labelText	= ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					invalid.items[0].focus();
				} else {
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )   {
						if (item.holdable == 'hold') {
							item.setReadOnly(false); 
						}
					}
					if(item.isPopupField)   {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	/** Grid1 정의(Grid Panel)
	 * @type
	 */
	var webCashGrid= Unilite.createGrid('str411ukrvWebCashGrid', {
		store	: webCashStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			onLoadSelectFirst	: false,
			useRowNumberer		: false
		},
		features: [{
			id				: 'gridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: false
		}],		
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly		: true,
			toggleOnClick	: false,
			listeners		: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					if(record.get('TRANSYN_NAME') == 'Error') return false;
				},
				select: function(grid, record, index, eOpts ){
					//report 출력여부(Y/N)가 'Y'이면 프린트 버튼 활성화
					if(BsaCodeInfo.gsBillYN[0].REF_CODE6 == 'Y') {
						UniAppManager.setToolbarButtons(['print'], true);
					}
				},
				deselect: function(grid, record, index, eOpts ){
					if(this.getCount() == 0){
						UniAppManager.setToolbarButtons(['print'], false);
					}
				}
			}
		}),
		tbar: [{	////전송버튼들 로직 만들어야함.
			itemId	: 'btnSend', iconCls : 'icon-referance',
			text	:'전송',
			width	: 80,
			handler	: function() {
				//저장버튼 활성화 체크,
				if(UniAppManager.app._needSave()) {
					Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
					return false;
				}
				var selRecords = webCashGrid.getSelectionModel().getSelection();
				if(Ext.isEmpty(selRecords)) {
					Unilite.messageBox(Msg.fsbMsgS0037);		//전송할 데이터가 존재하지 않습니다.
					return false;
				}
				if(confirm('<t:message code="system.message.sales.message150" default="전송하시겠습니까?"/>')) {
					panelResult.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
	
					Ext.each(selRecords, function(selRecord, index) {
						selRecord.set('OPR_FLAG', 'N');
						selRecord.phantom = true;
						buttonStore.insert(index, selRecord);
	
						if (selRecords.length == index +1) {
							buttonStore.saveStore();
						}
					})
				}
			}
		},{
			itemId	: 'btnReSend', iconCls : 'icon-referance',
			text	: '재전송',
			hidden	: true,					//센드빌에서만 사용
			handler	: function() {
			}
		},{
			itemId	: 'btnDelete', iconCls : 'icon-referance',
			text	: '전송취소',
			width	: 80,
			handler	: function() {
				//저장버튼 활성화 체크,
				if(UniAppManager.app._needSave()) {
					Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
					return false;
				}
				var selRecords = webCashGrid.getSelectionModel().getSelection();
				if(Ext.isEmpty(selRecords)) {
					Unilite.messageBox(Msg.fsbMsgS0037);		//전송할 데이터가 존재하지 않습니다.
					return false;
				}
				if(confirm('<t:message code="system.message.sales.message150" default="전송하시겠습니까?"/>')) {
					panelResult.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
	
					Ext.each(selRecords, function(selRecord, index) {
						selRecord.set('OPR_FLAG', 'D');
						selRecord.phantom = true;
						buttonStore.insert(index, selRecord);
	
						if (selRecords.length == index +1) {
							buttonStore.saveStore();
						}
					})
				}
			}
		}],
		columns	: [
			{dataIndex:'TRANSYN_NAME'		, width:66	, locked: true	, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '총합계', '총합계');
				}
			},
			{dataIndex:'STAT_CODE'			, width:60	, hidden: true},
			{dataIndex:'STS'				, width:100	, locked: true},
			{dataIndex:'REGS_DATE'			, width:80	, locked: true},
			{dataIndex:'SELR_CORP_NO'		, width:100	, hidden: true},
			{dataIndex:'SELR_CORP_NM'		, width:100	, hidden: true},
			{dataIndex:'SELR_CEO'			, width:100	, hidden: true},
			{dataIndex:'SELR_CORP_ADDS'		, width:100	, hidden: true},
			{dataIndex:'SELR_BUSS_CONS'		, width:100	, hidden: true},
			{dataIndex:'SELR_BUSS_TYPE'		, width:100	, hidden: true},
			{dataIndex:'SELR_TEL'			, width:100	, hidden: true},
			{dataIndex:'BUYR_CORP_NO'		, width:100	, locked: true},
			{dataIndex:'CUSTOM_CODE'		, width:86	, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var count = webCashStore.getCount();
					if(Ext.isEmpty(count)) count = 0;
					return Unilite.renderSummaryRow(summaryData, metaData, '건수 : ' + count + '건', '건수 : ' + count + '건');
				}
			},
			{dataIndex:'BUYR_CORP_NM'		, width:160	, locked: true},
			{dataIndex:'BUYR_CEO'			, width:100	, hidden: true},
			{dataIndex:'BUYR_CORP_ADDS'		, width:100	, hidden: true},
			{dataIndex:'BUYR_TEL'			, width:100	, hidden: true},
			{dataIndex:'CHRG_AMT'			, width:133	, summaryType: 'sum'},
			{dataIndex:'TAX_AMT'			, width:100	, summaryType: 'sum'},
			{dataIndex:'TOTL_AMT'			, width:133	, summaryType: 'sum'},
			{dataIndex:'SUM_AMT'			, width:133	, hidden: true},
			{dataIndex:'BUYR_CHRG_NM1'		, width:100,
				editor: Unilite.popup("CUST_BILL_PRSN_G",{
					textFieldName:'BILLPRSN',
					listeners:{
						onSelected: {
							fn:function(records, type)	{
								var grdRecord = webCashGrid.uniOpt.currentRecord;
								grdRecord.set('BUYR_CHRG_NM1'	, records[0]['PRSN_NAME']);
								grdRecord.set('BUYR_CHRG_MOBL1'	, records[0]['HAND_PHON']);
								grdRecord.set('BUYR_CHRG_EMAIL1', records[0]['MAIL_ID']);
								webCashStore.commitChanges();
							},
							scope: this
						},
						onClear: {
							fn: function(records, type)	{
								var grdRecord = webCashGrid.uniOpt.currentRecord;
								grdRecord.set('BUYR_CHRG_NM1'	, '');
								grdRecord.set('BUYR_CHRG_MOBL1'	, '');
								grdRecord.set('BUYR_CHRG_EMAIL1', '');
								webCashStore.commitChanges();
							}
						},
						applyextparam: function(popup){
							var grdRecord = webCashGrid.uniOpt.currentRecord;
							popup.setExtParam({'SEARCH_TYPE' : 'BILLPRSN'});
							popup.setExtParam({'CUSTOM_CODE' : grdRecord.get('CUSTOM_CODE')});
						}
					}
				})
			},
			{dataIndex:'BUYR_CHRG_MOBL1'	, width:100},
			{dataIndex:'BUYR_CHRG_EMAIL1'	, width:186,
				editor: Unilite.popup("CUST_BILL_PRSN_G",{
					textFieldName:'BUYR_CHRG_EMAIL1',
					listeners:{
						onSelected: {
							fn:function(records, type)	{
								var grdRecord = webCashGrid.uniOpt.currentRecord;
								grdRecord.set('BUYR_CHRG_NM1'	, records[0]['PRSN_NAME']);
								grdRecord.set('BUYR_CHRG_MOBL1'	, records[0]['HAND_PHON']);
								grdRecord.set('BUYR_CHRG_EMAIL1', records[0]['MAIL_ID']);
								webCashStore.commitChanges();
							},
							scope: this
						},
						onClear: {
							fn: function(records, type)	{
								var grdRecord = webCashGrid.uniOpt.currentRecord;
								grdRecord.set('BUYR_CHRG_NM1'	, '');
								grdRecord.set('BUYR_CHRG_MOBL1'	, '');
								grdRecord.set('BUYR_CHRG_EMAIL1', '');
								webCashStore.commitChanges();
							}
						},
						applyextparam: function(popup){	
							var grdRecord = webCashGrid.uniOpt.currentRecord;
							popup.setExtParam({'SEARCH_TYPE' : 'REMAIL'});
							popup.setExtParam({'CUSTOM_CODE' : grdRecord.get('CUSTOM_CODE')});
						}
					}
				})
			},
			{dataIndex:'SND_MAL_YN'			, width:100	, hidden: true},
			{dataIndex:'SND_SMS_YN'			, width:100	, hidden: true},
			{dataIndex:'SND_FAX_YN'			, width:100	, hidden: true},
			{dataIndex:'BILLSEQ'			, width:120},
			{dataIndex:'ERP_SEQ'			, width:133},
			{dataIndex:'DIV_CODE'			, width:100	, hidden: true},
			{dataIndex:'DEL_YN'				, width:100	, hidden: true},
			{dataIndex:'COMP_CODE'			, width:100	, hidden: true},
			{dataIndex:'ERR_GUBUN'			, width:100	, hidden: true},
			{dataIndex:'SEND_DATE'			, width:133}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				//미전송 == 'Y'의 경우 수정 가능
				if(panelResult.getValues().BILL_SEND_YN == 'N') {
					if(UniUtils.indexOf(e.field, ['BUYR_CHRG_NM1', 'BUYR_CHRG_EMAIL1'])) {
						return true;
					} else {
						return false;
					}
				} else {
					return false;
				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(record.get('TRANSYN_NAME') == "Error"){
					UniAppManager.app.fnSetErrMsg(record);	// 에러폼에 에러메시지 삽입
				} else {
					panelResult.setValue('TXT_ERR_MSG', '')
				}
				if(rowIndex != beforeRowIndex){
					detailStore.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
				////ROW더블클릭시 개별세금계산서 등록으로 데이터 전송및 조회되게 하는 부분 해야함.
				////row클릭시 선택된 row색깔 표시 되야함.
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('TRANSYN_NAME') == 'Error'){
					cls = 'x-change-celltext_red';		//cell_pink(행 분홍색), celltext_red(글자 빨간색)
				}
				return cls;
			}
		}
	});

	/** detailGrid 정의(Grid Panel)
	 * @type
	 */
	var detailGrid= Unilite.createGrid('str411ukrvDetailGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {
			expandLastColumn: true
		},
		features: [{
			id				: 'detailGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: false
		}],
		columns	: [
			{dataIndex:'DT'			, width:100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '총합계', '총합계');
				}
			},
			{dataIndex:'CODE'		, width:233,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var count = detailStore.getCount();
					if(Ext.isEmpty(count)) count = 0;
					return Unilite.renderSummaryRow(summaryData, metaData, '건수 : ' + count + '건', '건수 : ' + count + '건');
				}
			},
			{dataIndex:'NAME'		, width:233,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var count = detailStore.getCount();
					if(Ext.isEmpty(count)) count = 0;
					return Unilite.renderSummaryRow(summaryData, metaData, '건수 : ' + count + '건', '건수 : ' + count + '건');
				}
			},
			{dataIndex:'UNIT'		, width:200},
			{dataIndex:'VLM'		, width:120, summaryType: 'sum'},
			{dataIndex:'DANGA'		, width:120},
			{dataIndex:'SUP'		, width:133, summaryType: 'sum'},
			{dataIndex:'TAX'		, width:120},
			{dataIndex:'COMP_CODE'	, width:66,hidden:true},
			{dataIndex:'DIV_CODE'	, width:66,hidden:true},
			{dataIndex:'PUB_NUM'	, width:66,hidden:true},
			{dataIndex:'ITEM_CODE'	, width:66,hidden:true},
			{dataIndex:'CUSTOM_CODE', width:66,hidden:true},
			{dataIndex:'SALE_UNIT'	, width:66,hidden:true},
			{dataIndex:'TRANS_RATE'	, width:66,hidden:true}
		], 
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				//미전송 && gsItemEditYN == 'Y'의 경우 수정 가능
				if(panelResult.getValues().BILL_SEND_YN == 'N' && BsaCodeInfo.gsBillYN[0].REF_CODE5 == 'Y') {
					if(UniUtils.indexOf(e.field, ['CODE', 'NAME', 'UNIT'])) {
						return true;
					} else {
						return false;
					}
				} else {
					return false;
				}
			}
		}
	});



	Unilite.Main({
		id			: 'str411ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				webCashGrid, detailGrid
			]
		},
		panelResult
		],
		fnInitBinding: function() {
			//20200701 주석: 사업장 권한 관련로직 공통에서 처리하므로 주석 처리
//			if(pgmInfo.authoUser != 'N') {
//				panelResult.getField('DIV_CODE').setReadOnly(true);
//				panelResult.onLoadSelectText('BILL_DATE_FR');
//			} else {
//				panelResult.getField('DIV_CODE').setReadOnly(false);
				panelResult.onLoadSelectText('DIV_CODE');
//			}
			//설정에 따른 detailGrid 설정 변경
			if(BsaCodeInfo.gsBillYN[0].REF_CODE4 == 'CODE') {
				detailGrid.getColumn('CODE').setHidden(false);
				detailGrid.getColumn('NAME').setHidden(true);
			} else {
				detailGrid.getColumn('CODE').setHidden(true);
				detailGrid.getColumn('NAME').setHidden(false);
			}
			panelResult.getField('TXT_ERR_MSG').setFieldStyle('color:red');
			webCashGrid.down('#btnReSend').disable();
			webCashGrid.down('#btnDelete').disable();

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('BILL_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('BILL_DATE_TO'	, UniDate.get('today'));
			UniAppManager.setToolbarButtons(['detail', 'reset', 'print'], false);
		},
		onQueryButtonDown: function(BILL_SEND_YN) {
			if (!panelResult.getInvalidMessage()) {
				return false;
			}
			webCashGrid.getStore().loadStoreRecords(BILL_SEND_YN);
			beforeRowIndex = -1;
			var viewLocked = webCashGrid.lockedGrid.getView();
			var viewNormal = webCashGrid.normalGrid.getView();
			
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			
			viewLocked.getFeature('gridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('gridTotal').toggleSummaryRow(true);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			webCashGrid.getStore().loadData({});
			detailGrid.getStore().loadData({});

			panelResult.setAllFieldsReadOnly(false);
			this.fnInitBinding();

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
		},
		onSaveDataButtonDown: function(config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			if(detailStore.isDirty()){
				detailStore.saveStore();
			} else {
				Unilite.messageBox('<t:message code="system.message.common.savecheck2" default="저장할 데이터가 없습니다."/>');
				return false;
			}
		},
		onPrintButtonDown: function() {	//추후 만들 때 srq300rkrv참조 && 상단 변수 확인(BsaCodeInfo.gsBillYN[0])
			//저장버튼 활성화 체크,
			if(UniAppManager.app._needSave()) {
				Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
				return false;
			}
			var selRecords = webCashGrid.getSelectionModel().getSelection();
			if(Ext.isEmpty(selRecords)) {
				Unilite.messageBox(Msg.fSbMsgZ0028);		//선택된 출력데이터가 없습니다.
				return false;
			}
			if(confirm(Msg.fSbMsgZ0027)) {
				panelResult.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
				Ext.each(selRecords, function(selRecord, index) {
					selRecord.phantom = true;
					printStore.insert(index, selRecord);

					if (selRecords.length == index +1) {
						printStore.saveStore();
					}
				})
			}
		},
		fnSetErrMsg: function(record) {	// 에러폼에 에러메시지 삽입
			if(record.get('ERR_GUBUN') == '1'){
				panelResult.setValue('TXT_ERR_MSG', Msg.fStMsgS0092);
			}
			if(record.get('ERR_GUBUN') == '2'){
				panelResult.setValue('TXT_ERR_MSG', Msg.fStMsgS0093);
			}
			if(record.get('ERR_GUBUN') == '3'){
				panelResult.setValue('TXT_ERR_MSG', Msg.fStMsgS0094);
			}
			if(record.get('ERR_GUBUN') == '4'){
				panelResult.setValue('TXT_ERR_MSG', Msg.fStMsgS0095);
			}
		},
		fnWebCashColSet: function(records) {	//웹캐시 전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기
			Ext.each(records, function(record) {
				//공급자 업체명, 대표자명, 업태, 업종, 주소
				if(Ext.isEmpty(record.get('SELR_CORP_NM')) || Ext.isEmpty(record.get('SELR_CEO')) || Ext.isEmpty(record.get('SELR_CORP_ADDS'))){
					record.set('TRANSYN_NAME'	, 'Error');
					record.set('ERR_GUBUN'		, '1');
				}
				//공급 받는자 업체명, 대표자명, 주소
				else if(Ext.isEmpty(record.get('BUYR_CORP_NM')) || Ext.isEmpty(record.get('BUYR_CEO')) || Ext.isEmpty(record.get('BUYR_CORP_ADDS'))){
					record.set('TRANSYN_NAME'	, 'Error');
					record.set('ERR_GUBUN'		, '3');
				}
				//공급 받는자 담당자명, 전화번호, 이메일주소 -- 필수 아니므로 제외
//				else if(Ext.isEmpty(record.get('BUYR_CHRG_NM1')) || Ext.isEmpty(record.get('BUYR_CHRG_MOBL1')) || Ext.isEmpty(record.get('BUYR_CHRG_EMAIL1'))){
//					record.set('TRANSYN_NAME'	, 'Error');
//					record.set('ERR_GUBUN'		, '4');
//				}
				record.commit();
			});
		}
	});




	//전송 시, 작업할 내용 처리용
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'str411ukrvService.fnProgWebCash',
			syncAll	: 'str411ukrvService.fnWebCash'
		}
	});

	var buttonStore = Unilite.createStore('webcashButtonStore',{
		uniOpt: {
			isMaster	: false,	//상위 버튼 연결
			editable	: false,	//수정 모드 사용
			deletable	: false,	//삭제 가능 여부
			useNavi		: false		//prev | next 버튼 사용
		},
		proxy		: directButtonProxy,
		saveStore	: function() {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();

			var paramMaster = panelResult.getValues();

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success : function(batch, option) {
						panelResult.getEl().unmask();
						buttonStore.clearData();
						UniAppManager.app.onQueryButtonDown();
					},
					failure: function(batch, option) {
						panelResult.getEl().unmask();
						buttonStore.clearData();
						UniAppManager.app.onQueryButtonDown();
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




	//출력관련 로직
	var directButtonProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'str411ukrvService.fnMakePrintData',
			syncAll	: 'str411ukrvService.fnPrintTransStat'
		}
	});

	var printStore = Unilite.createStore('printButtonStore',{
		uniOpt: {
			isMaster	: false,	//상위 버튼 연결
			editable	: false,	//수정 모드 사용
			deletable	: false,	//삭제 가능 여부
			useNavi		: false		//prev | next 버튼 사용
		},
		proxy		: directButtonProxy2,
		saveStore	: function() {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var paramMaster	= panelResult.getValues();

			if(inValidRecs.length == 0) {
				config = {
					params			: [paramMaster],
					useSavedMessage	: false,										//20200423 추가: 저장되었습니다. 메세지 안 보이게
					success			: function(batch, option) {
						var master			= batch.operations[0].getResultSet();
						var keyValue		= master.KEY_VALUE;
						var param			= panelResult.getValues();
						param['PGM_ID']		= PGM_ID;
//						param['MAIN_CODE']	= 'S036';	//영업용 공통 코드: 전자거래명세서는 해당 공통코드 ref_code7에 정의되어 있음
						param['KEY_VALUE']	= keyValue;
						param['RPT_FILE']	= Ext.isEmpty(BsaCodeInfo.gsBillYN[0].REF_CODE7) ? 'str411clukrv.crf' : BsaCodeInfo.gsBillYN[0].REF_CODE7;
						var win	= Ext.create('widget.ClipReport', {
							url		: CPATH+'/sales/str411clukrv.do',
							prgID	: 'str411ukrv',
							extParam: param
						});
						win.center();
						win.show();
						panelResult.getEl().unmask();
						printStore.clearData();
					},
					failure: function(batch, option) {
						panelResult.getEl().unmask();
						printStore.clearData();
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
};
</script>