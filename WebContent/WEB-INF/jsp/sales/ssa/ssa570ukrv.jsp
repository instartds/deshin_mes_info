<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa570ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa570ukrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />			<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />			<!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />			<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />			<!-- 세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B066" />			<!-- 계산서종류 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />			<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" />			<!-- 출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />			<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S095" />			<!-- 국세청 수정사유 -->
	<t:ExtComboStore comboType="AU" comboCode="S096" />			<!-- 세금계산서구분 -->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>

<script type="text/javascript">

var searchInfoWindow;	//searchInfoWindow : 검색창
var referSaleWindow;	//매출참조
var sangsaeInfoWindow;	//발행상세내역
var gsStatus;			//조회방식 설정을 위한 전역변수
var gsSelectionFlag;	//selection change 로직을 위한 flag

var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCrYn		: '',
	gsUnderCalBase	: '',
	gsRefTaxInout	: ''
};

var BsaCodeInfo = {
	gsAutoType		: '${gsAutoType}',
	gsPjtCodeYN		: '${gsPjtCodeYN}',
	gsSalePrsnEssYN	: '${gsSalePrsnEssYN}',
	gsOwnNum		: '${gsOwnNum}'
};



function appMain() {
	//자동채번 여부
	var isAutoOrderNum = false;
	BsaCodeInfo.gsAutoType=='Y'? isAutoOrderNum = true : isAutoOrderNum = false;

	//영업담당 필수여부
	var salePrsnEssYN = true;
	BsaCodeInfo.gsAutoType=='Y' ? salePrsnEssYN = true : salePrsnEssYN = false;

	//프로젝트코드 사용유무
	var gsPjtCodeYN = false;
	BsaCodeInfo.gsPjtCodeYN=='Y'? gsPjtCodeYN = true : gsPjtCodeYN = false;



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ssa570ukrvService.selectMaster',
			update	: 'ssa570ukrvService.updateDetail',
			create	: 'ssa570ukrvService.insertDetail',
			destroy	: 'ssa570ukrvService.deleteDetail',
			syncAll	: 'ssa570ukrvService.saveAll'
		}
	});

	Unilite.defineModel('ssa570ukrvDetailModel', {
		fields: [
			{name: 'PUB_NUM'				,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'					, type: 'string', allowBlank: isAutoOrderNum},
			{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.client" default="고객"/>'						, type: 'string'},
			{name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'SALE_TAX_I'				,text: '<t:message code="system.label.sales.taxedamounttotal" default="과세액계"/>'			, type: 'uniPrice'},
			{name: 'TAX_AMT_I'				,text: '<t:message code="system.label.sales.taxamounttotal" default="세액계"/>'			, type: 'uniPrice'},
			{name: 'SALE_NOTAX_I'			,text: '<t:message code="system.label.sales.taxexemptiontotal" default="면세액계"/>'		, type: 'uniPrice'},
			{name: 'EX_DATE'				,text: '<t:message code="system.label.sales.acslipdate" default="회계전표일"/>'				, type: 'uniDate'},
			{name: 'EX_NUM'					,text: '<t:message code="system.label.sales.acslipno" default="회계전표번호"/>'				, type: 'string'},
			{name: 'SALE_DIV_CODE'			,text: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'			, type: 'string', type: 'string', comboType: 'BOR120'},
			{name: 'BILL_FLAG'				,text: '<t:message code="system.label.sales.invoiceclass" default="계산서구분"/>'			, type: 'string', type: 'string', comboType: 'AU', comboCode: 'S096'},
			{name: 'EB_NUM'					,text: '<t:message code="system.label.sales.electronicdocumentnum" default="전자문서번호"/>'	, type: 'string'},
			{name: 'BILL_TYPE'				,text: '<t:message code="system.label.sales.billtype" default="계산서종류"/>'				, type: 'string', type: 'string', comboType: 'AU', comboCode: 'B066'},
			{name: 'RECEIPT_PLAN_DATE'		,text: '<t:message code="system.label.sales.collectionschdate" default="수금예정일"/>'		, type: 'uniDate', allowBlank: false},
			{name: 'BILL_DATE'				,text: '<t:message code="system.label.sales.billissuedate" default="계산서발행일"/>'			, type: 'uniDate'},
			{name: 'PROJECT_NO'				,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string', hidden: gsPjtCodeYN},
			{name: 'PJT_CODE'				,text: '<t:message code="system.label.sales.projectcode" default="프로젝트코드"/>'			, type: 'string', hidden: true},
			{name: 'PJT_NAME'				,text: '<t:message code="system.label.sales.project" default="프로젝트"/>'					, type: 'string', hidden: !gsPjtCodeYN},
			{name: 'TRANS_CLOSE_DAY'		,text: '<t:message code="system.label.sales.closingtype" default="마감종류"/>'				, type: 'string'},
			//HIDDEN FIELD
			{name: 'BILL_DIV_CODE'			,text: 'BILL_DIV_CODE'	, type: 'string'},
			{name: 'PUB_FR_DATE'			,text: 'PUB_FR_DATE'	, type: 'uniDate'},
			{name: 'PUB_TO_DATE'			,text: 'PUB_TO_DATE'	, type: 'uniDate'},
			{name: 'COLET_AMT'				,text: 'COLET_AMT'		, type: 'uniPrice'},
			{name: 'COLET_CUST_CD'			,text: 'COLET_CUST_CD'	, type: 'string'},
			{name: 'TAX_CALC_TYPE'			,text: 'TAX_CALC_TYPE'	, type: 'string'},
			{name: 'COLLECT_CARE'			,text: 'COLLECT_CARE'	, type: 'string'},
			{name: 'AC_DATE'				,text: 'AC_DATE'		, type: 'uniDate'},
			{name: 'BILL_SEND_YN'			,text: '전자세금계산서발행여부'	, type: 'string'},
			{name: 'COMP_CODE'				,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'					, type: 'string'},
			{name: 'SERVANT_COMPANY_NUM'	,text: '<t:message code="system.label.common.bureaubusinessnumber" default="종사업장번호"/>'	, type: 'string'},
			{name: 'UPDATE_DB_USER'			,text: 'UPDATE_DB_USER'	, type: 'string'}
		]
	});

	//마스터 스토어 정의
	var detailStore = Unilite.createStore('ssa570ukrvDetailStore', {
		model	: 'ssa570ukrvDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var orderNum = panelResult.getValue('COMPANY_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['COMPANY_NUM'] != orderNum) {
					record.set('COMPANY_NUM', orderNum);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
//						panelResult.setValue("PUB_NUM", master.PUB_NUM);
						
						//3.기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						gsStatus = 'U'
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('ssa570ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(store.getCount() == 0) {
					UniAppManager.app.onResetButtonDown();	// 삭제후 RESET..
				} else {
					Ext.getCmp('sangsaeInfo').setDisabled(false);
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			items: [{
				fieldLabel	: '<t:message code="system.label.sales.declaredivisioncode" default="신고사업장"/>',
				name		: 'BILL_DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						var param = {
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: newValue
						}
						salesCommonService.fnGetOrgInfo(param, function(provider, response) {
							if(!Ext.isEmpty(provider)) {
								var ownNum = provider.COMPANY_NUM;
								if(ownNum && ownNum.length == 10) {
									ownNum = ownNum.substring(0, 3) + '-' + ownNum.substring(3, 5) + '-' + ownNum.substring(5);
								}
								panelResult.setValue('COMPANY_NUM', ownNum);
							}
						});
						//그리드 SALE_DIV_CODE store 값 SETTING하는 로직 추가: 필요없음 수정 안 되는 컬럼
					}
				}
			},{
				hideLabel	: true,
				name		: 'COMPANY_NUM',
				xtype		: 'uniTextfield',
				readOnly	: true,
				width		: 108,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'DATE_FR',
			endFieldName	: 'DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			allowBlank		: false,
			holdable		: 'hold',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},{
			xtype	: 'container' ,
			layout	: {type:'hbox', align:'stretched'},
			width	: 200,
			style	: {'margin-left':'95px'},
			items	: [{
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.salesslip" default="매출기표"/>',
				width	: 80,
				itemId	: 'btnProc',
//				hidden	: true,
				handler	: function() {
					if(UniAppManager.app._needSave()) {
						Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
						return false;
					}
					var billType = Ext.getCmp('optTaxGb').getChecked()[0].inputValue;
					if(billType == '11' || billType == '20') {
						billType = '10';
					} else if(billType == '12') {
						billType = '50';
					}
					var param = {
						S_COMP_CODE		: UserInfo.compCode,
						ACCNT_DIV_CODE	: panelResult.getValue('BILL_DIV_CODE'),	//사업장
						PUB_DATE_FR		: UniDate.getDbDateStr(panelResult.getValue('BILL_DATE')),		//계산서일(from)
						PUB_DATE_TO		: UniDate.getDbDateStr(panelResult.getValue('BILL_DATE')),		//계산서일(to)
						CUSTOM_CODE_FR	: '',
						CUSTOM_CODE_TO	: '',
						BILL_TYPE		: billType,									//부가세유형
						PUB_DATE		: '1',										//전표일생성조건(1.계산서일/2.실행일)
						WORK_DATE		: UniDate.getDbDateStr(panelResult.getValue('BILL_DATE')),		//전표일
						S_USER_ID		: UserInfo.userID,
						SYS_DATE		: UniDate.getDbDateStr(UniDate.get('today')),
						BILL_PUB_NUM	: '',
						KEY_VALUE		: '',
						LANG_TYPE		: UserInfo.userLang,						//언어구분
						CALL_PATH		: 'Batch'									//호출경로(Batch, List)
					}
					if(panelResult.down('#btnProc').getText() == '<t:message code="system.label.sales.salesslip" default="매출기표"/>'){
//						Unilite.messageBox('<t:message code="system.label.sales.salesslip" default="매출기표"/>');
						panelResult.getEl().mask('로딩중...','loading-indicator');
						agd110ukrService.procButton(param, 
							function(provider, response) {
								if(provider) {
									UniAppManager.updateStatus("자동기표가 완료 되었습니다.");
									UniAppManager.app.onQueryButtonDown();
								}
								console.log("response",response)
								panelResult.getEl().unmask();
							}
						)
					} else {
//						Unilite.messageBox('<t:message code="system.label.sales.slipcancel" default="기표취소"/>');
						panelResult.getEl().mask('로딩중...','loading-indicator');
						agd110ukrService.cancButton(param, 
							function(provider, response) {
								if(provider) {
									UniAppManager.updateStatus("취소 되었습니다.");
									UniAppManager.app.onQueryButtonDown();
								}
								console.log("response",response)
								panelResult.getEl().unmask();
							}
						)
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.publishdate" default="발행일"/>',
			name		: 'BILL_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>',
			xtype		: 'radiogroup',
			id			: 'optTaxGb',
			holdable	: 'hold',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.taxation" default="과세"/>',
				name		: 'BILL_TYPE',
				inputValue	: '11',
				width		: 60,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.sales.taxexemption" default="면세"/>',
				name		: 'BILL_TYPE',
				inputValue	: '20',
				width		: 60
			},{
				boxLabel	: '영세율',
				name		: 'BILL_TYPE',
				inputValue	: '12',
				width		: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			allowBlank	: salePrsnEssYN,
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
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
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable)) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	var inputTable = Unilite.createSearchForm('inputTable', { //createForm
		layout	: {type : 'uniTable', columns : 4, tableAttrs: {width: '100%'}},
		disabled: false,
		border	: true,
		padding	: '1 1 1 1',
		region	: 'center',
		items	: [{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			items	: [{
				fieldLabel	: '<t:message code="system.label.sales.exslipdate" default="결의전표일"/>',
				xtype		: 'uniDatefield',
				name		: 'EX_DATE',
				readOnly	: true
			},{
				xtype: 'component',
				width: 110
			},{
				fieldLabel	: '<t:message code="system.label.sales.exslipno" default="결의전표번호"/>',
				xtype		: 'uniNumberfield',
				name		: 'EX_NUM',
				readOnly	: true
			}]
		},{
			xtype	: 'button',
			tdAttrs	: {align: 'right'},
			text	: '<t:message code="system.label.sales.issuedetails2" default="발행상세내역"/>',
			id		: 'sangsaeInfo',
			handler	: function() {
				openSangsaeInfoWindow();
			}
		}]
	});



	//마스터 그리드 정의
	var masterGrid = Unilite.createGrid('ssa570ukrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useMultipleSorting	: true,
			useLiveSearch		: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		tbar	: [{
			itemId	: 'estimateBtn',
			text	: '<div style="color: blue"><t:message code="system.label.sales.salesreference" default="매출참조"/></div>',
			handler	: function() {
				openSaleReferWindow();
			}
		}],
		columns	: [
			{ dataIndex: 'PUB_NUM'				, width: 106},
			{ dataIndex: 'CUSTOM_CODE'			, width: 86},
			{ dataIndex: 'CUSTOM_NAME'			, width: 166},
			{ dataIndex: 'SALE_TAX_I'			, width: 100},
			{ dataIndex: 'TAX_AMT_I'			, width: 86},
			{ dataIndex: 'SALE_NOTAX_I'			, width: 100},
			{ dataIndex: 'EX_DATE'				, width: 80},
			{ dataIndex: 'EX_NUM'				, width: 100},
			{ dataIndex: 'SALE_DIV_CODE'		, width: 86},
			{ dataIndex: 'BILL_FLAG'			, width: 100},
			{ dataIndex: 'EB_NUM'				, width: 100},
			{ dataIndex: 'BILL_TYPE'			, width: 100},
			{ dataIndex: 'RECEIPT_PLAN_DATE'	, width: 80},
			{ dataIndex: 'BILL_DATE'			, width: 100},
			{ dataIndex: 'PROJECT_NO'			, width: 100, hidden: true},
			{ dataIndex: 'PJT_CODE'				, width: 100, hidden: true},
			{ dataIndex: 'PJT_NAME'				, width: 166},
			{ dataIndex: 'BILL_DIV_CODE'		, width: 66, hidden: true},
			{ dataIndex: 'PUB_FR_DATE'			, width: 66, hidden: true},
			{ dataIndex: 'PUB_TO_DATE'			, width: 66, hidden: true},
			{ dataIndex: 'COLET_AMT'			, width: 66, hidden: true},
			{ dataIndex: 'COLET_CUST_CD'		, width: 66, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'		, width: 66, hidden: true},
			{ dataIndex: 'TAX_CALC_TYPE'		, width: 66, hidden: true},
			{ dataIndex: 'COLLECT_CARE'			, width: 66, hidden: true},
			{ dataIndex: 'AC_DATE'				, width: 66, hidden: true},
			{ dataIndex: 'BILL_SEND_YN'			, width: 66, hidden: true},
			{ dataIndex: 'COMP_CODE'			, width: 66, hidden: true},
			{ dataIndex: 'SERVANT_COMPANY_NUM'	, width: 66, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
					if(e.record.get('BILL_SEND_YN') == 'Y') {
						return false;
					}
					if(UniUtils.indexOf(e.field, ['EX_DATE'])) {
						if(Ext.isEmpty(e.record.get('EX_DATE'))) {
							return true;
						} else {
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['COLET_AMT'])) {
						if(e.record.get('COLET_AMT') > 0) {
							return false;
						} else {
							return true;
						}
					}
					if(UniUtils.indexOf(e.field, ['RECEIPT_PLAN_DATE'])) {
						if(Ext.isEmpty(e.record.get('EX_DATE')) && e.record.get('COLET_AMT') == 0) {
							return true;
						} else {
							return false;
						}
					} else {
						return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['PUB_NUM'])) {
						if(BsaCodeInfo.gsAutoType == 'Y') {
							return false;
						} else {
							return true;
						}
					}
					if(UniUtils.indexOf(e.field, ['RECEIPT_PLAN_DATE'])) {
						return true;
					} else {
						return false;
					}
				}
			},
			selectionchange:function( model1, selected, eOpts ){
				var createBtn = panelResult.down("#btnProc");
//				if(gsSelectionFlag && UniAppManager.app._needSave()) {
//					Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
//					return false;
//				} else {
					createBtn.setDisabled(false);
//				}
				var record = masterGrid.getSelectedRecord();
				if(!Ext.isEmpty(record)){
					inputTable.setValue('EX_DATE'	, record.data.EX_DATE);
					inputTable.setValue('EX_NUM'	, record.data.EX_NUM);
					//자동기표 버튼이 활성화 되어 있을 때,
					if(!createBtn.disabled) {
						if(!Ext.isEmpty(record.get('AC_DATE'))) {
							createBtn.setText('<t:message code="system.label.sales.salesslip" default="매출기표"/>');
							createBtn.setDisabled(true);
						} else {
							if(Ext.isEmpty(record.get('EX_DATE'))) {
								createBtn.setText('<t:message code="system.label.sales.salesslip" default="매출기표"/>');
								createBtn.setDisabled(false);
							} else {
								createBtn.setText('<t:message code="system.label.sales.slipcancel" default="기표취소"/>');
								createBtn.setDisabled(false);
							}
						}
					}
				}
			}
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,""); 
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('ORDER_Q'			,0);
				grdRecord.set('ORDER_P'			,0);
				grdRecord.set('ORDER_WGT_Q'		,0);
				grdRecord.set('ORDER_WGT_P'		,0);
				grdRecord.set('ORDER_VOL_Q'		,0);
				grdRecord.set('ORDER_VOL_P'		,0); 
				grdRecord.set('ORDER_O'			,0);
				grdRecord.set('PROD_SALE_Q'		,0);
				grdRecord.set('PROD_Q'			,0);
				grdRecord.set('STOCK_Q'			,0);
				grdRecord.set('DISCOUNT_RATE'	,0);
				grdRecord.set('WGT_UNIT'		,"");
				grdRecord.set('UNIT_WGT'		,0);
				grdRecord.set('VOL_UNIT'		,"");
				grdRecord.set('UNIT_VOL'		,0);
			} else {
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				, record['SPEC']); 
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
				grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
				// grdRecord.set('OUT_DIV_CODE' ,record['DIV_CODE']);
				grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
				grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
				grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
				grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
				grdRecord.set('COMPANY_NUM'			, panelResult.getValue('COMPANY_NUM'));
				UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
			}
		},
		setRefData: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('SALE_TAX_I'			, record['SALE_TAX_I']);
			grdRecord.set('TAX_AMT_I'			, record['TAX_AMT_I']);
			grdRecord.set('SALE_NOTAX_I'		, record['SALE_NOTAX_I']);
			grdRecord.set('SALE_DIV_CODE'		, record['DIV_CODE']);
			grdRecord.set('BILL_FLAG'			, '1');
			grdRecord.set('BILL_TYPE'			, record['BILL_TYPE']);
			grdRecord.set('RECEIPT_PLAN_DATE'	, fnRcptDateCal(panelResult.getValue('BILL_DATE'), record['COLLECT_DAY']));
			grdRecord.set('BILL_DATE'			, panelResult.getValue('BILL_DATE'));
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('BILL_DIV_CODE'		, panelResult.getValue('BILL_DIV_CODE'));
			grdRecord.set('PUB_FR_DATE'			, panelResult.getValue('DATE_FR'));
			grdRecord.set('PUB_TO_DATE'			, panelResult.getValue('DATE_TO'));
			grdRecord.set('COLET_AMT'			, 0);
			grdRecord.set('COLET_CUST_CD'		, record['COLLECTOR_CP']);
			grdRecord.set('TAX_CALC_TYPE'		, record['TAX_CALC_TYPE']);
			grdRecord.set('COLLECT_CARE'		, record['COLLECT_CARE']);
			grdRecord.set('TRANS_CLOSE_DAY'		, record['TRANS_CLOSE_DAY']);
			grdRecord.set('PJT_CODE'			, record['PJT_CODE']);
			grdRecord.set('PJT_NAME'			, record['PJT_NAME']);
			grdRecord.set('SERVANT_COMPANY_NUM'	, record['SERVANT_COMPANY_NUM']);
			grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			grdRecord.set('UPDATE_DB_USER'		, UserInfo.userID);
		}
	});



	//검색창 폼 정의
	var billNoSearch = Unilite.createSearchForm('billNoSearchForm', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
			fieldLabel		: '계산서일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		},{
			fieldLabel	: '계산서종류'	,
			xtype		: 'uniRadiogroup',
			allowBlank	: false,
			width		: 235,
			items		: [{
				boxLabel	: '세금계산서',
				name		: 'BILL_TYPE',
				inputValue	: '11',
				checked		: true,
				width		: 100
			},{
				boxLabel	: '<t:message code="system.label.sales.bill" default="계산서"/>',
				name		: 'BILL_TYPE',
				inputValue	: '20',
				width		: 100
			}]
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		:'<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						billNoSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						billNoSearch.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			valueFieldName	: 'PROJECT_NO',
			textFieldName	: 'PROJECT_NO',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					if(!Ext.isEmpty(billNoSearch.getValue('CUSTOM_CODE')) && !Ext.isEmpty(billNoSearch.getValue('CUSTOM_NAME'))) {
						popup.setExtParam({'CUSTOM_CODE': billNoSearch.getValue('CUSTOM_CODE')});
					} else {
						popup.setExtParam({'CUSTOM_CODE': ''});
					}
				}
			}
		}),{
			xtype	: 'hiddenfield',
			name	: 'BILL_DIV_CODE'
		},{
			xtype	: 'hiddenfield',
			name	: 'SALE_PRSN'
		}]
	}); 
	//검색창 모델 정의
	Unilite.defineModel('billNoMasterModel', {
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.declaredivisioncode" default="신고사업장"/>'	, type: 'string'	, comboType: 'BOR120'},
			{name: 'CUSTOM_NAME'	, text: '계산서발행 거래처'	, type: 'string'}, 
			{name: 'PUB_NUM'		, text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'					, type: 'string'},
			{name: 'BILL_DATE'		, text: '<t:message code="system.label.sales.billdate" default="계산서일"/>'				, type: 'uniDate'},
			{name: 'PUB_FR_DATE'	, text: '<t:message code="system.label.sales.salesdatefrom" default="매출일(FROM)"/>'		, type: 'uniDate'},
			{name: 'PUB_TO_DATE'	, text: '<t:message code="system.label.sales.salesdateto" default="매출일(TO)"/>'			, type: 'uniDate'},
			{name: 'BILL_FLAG'		, text: '<t:message code="system.label.sales.invoiceclass" default="계산서구분"/>'			, type: 'string'	, comboType:'AU', comboCode:'S096'}, 
			{name: 'BILL_TYPE'		, text: '<t:message code="system.label.sales.billcode" default="계산서코드"/>'				, type: 'string'	, comboType:'AU', comboCode:'B066'},
			{name: 'CUSTOM_CODE'	, text: 'CUSTOM_CODE'	, type: 'string'}, 
			{name: 'MODI_REASON'	, text: '<t:message code="system.label.sales.updatereason" default="수정사유"/>'			, type: 'string'},
			{name: 'SALE_PRSN'		, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string'},
			{name: 'COMPANY_NUM'	, text: 'COMPANY_NUM'	, type: 'string'}
		]
	});
	//검색창 스토어 정의
	var billNoMasterStore = Unilite.createStore('billNoMasterStore', {
		model	: 'billNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'ssa570ukrvService.selectBillNoMasterList'
			}
		},
		loadStoreRecords : function() {
			var param= billNoSearch.getValues();
			param
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		}
	});
	//검색창 그리드 정의
	var billNoMasterGrid = Unilite.createGrid('ssa570ukrvBillNoMasterGrid', {
		store	: billNoMasterStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		columns	: [
			{ dataIndex: 'DIV_CODE'		, width: 133, locked: true },
			{ dataIndex: 'CUSTOM_NAME'	, width: 120, locked: true },
			{ dataIndex: 'PUB_NUM'		, width: 100},
			{ dataIndex: 'BILL_DATE'	, width: 100},
			{ dataIndex: 'PUB_FR_DATE'	, width: 100},
			{ dataIndex: 'PUB_TO_DATE'	, width: 100},
			{ dataIndex: 'BILL_FLAG'	, width: 100},
			{ dataIndex: 'BILL_TYPE'	, width: 100},
			{ dataIndex: 'CUSTOM_CODE'	, width: 73	, hidden:true},
			{ dataIndex: 'MODI_REASON'	, width: 100},
			{ dataIndex: 'SALE_PRSN'	, width: 100,hidden:true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				billNoMasterGrid.returnData(record);
				searchInfoWindow.hide();
			}
		},	// listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			gsStatus = 'U';
			panelResult.setValue('BILL_DIV_CODE', record.get('DIV_CODE')),
			panelResult.setValue('DATE_FR'		, record.get('PUB_FR_DATE')),
			panelResult.setValue('DATE_TO'		, record.get('PUB_TO_DATE')),
			panelResult.setValue('BILL_DATE'	, record.get('BILL_DATE')),
			panelResult.setValue('BILL_TYPE'	, record.get('BILL_TYPE')),
			panelResult.setValue('SALE_PRSN'	, record.get('SALE_PRSN'))
//			ownNum = record.get('COMPANY_NUM').substring(0, 3) + '-' + record.get('COMPANY_NUM').substring(3, 5) + '-' + record.get('COMPANY_NUM').substring(5);
//			panelResult.setValue('COMPANY_NUM'	, ownNum)
			UniAppManager.app.onQueryButtonDown();
		}
	});
	//검색창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.billnosearch" default="계산서번호검색"/>',
				width	: 830,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [billNoSearch, billNoMasterGrid],
				tbar	: ['->',{
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						billNoMasterStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						searchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						billNoSearch.clearForm();
						billNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						billNoSearch.clearForm();
						billNoMasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						billNoSearch.setValue('BILL_DIV_CODE'	, panelResult.getValue('BILL_DIV_CODE'));
						billNoSearch.setValue('SALE_PRSN'		, panelResult.getValue('SALE_PRSN'));
						billNoSearch.setValue('FR_DATE'			, UniDate.getDbDateStr(panelResult.getValue('BILL_DATE')).substring(0, 6) + '01');
						billNoSearch.setValue('TO_DATE'			, panelResult.getValue('BILL_DATE'));
						if(panelResult.getField('BILL_TYPE').getGroupValue() == '20'){
							billNoSearch.setValue('BILL_TYPE', '20');
						} else {
							billNoSearch.setValue('BILL_TYPE', '11');
						}
					}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}



	//발행상세내역
	var billNoSearch2 = Unilite.createSearchForm('billNoSearchForm2', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.declaredivisioncode" default="신고사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			readOnly	: true
		},{
			fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PUB_FR_DATE',
			endFieldName	: 'PUB_TO_DATE',
			readOnly		: true
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			readOnly		: true,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.publishdate" default="발행일"/>',
			name		: 'BILL_DATE',
			xtype		: 'uniDatefield',
			readOnly	: true
		},{
			xtype	: 'hiddenfield',
			name	: 'SALE_DIV_CODE'
		},{
			xtype	: 'hiddenfield',
			name	: 'PUB_NUM'
		},{
			xtype	: 'hiddenfield',
			name	: 'PUB_NUM'
		}]
	}); 
	//발행상세내역창 모델 정의
	Unilite.defineModel('billNoMasterModel2', {
		fields: [
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'		, type: 'uniDate'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'	, type: 'string'	, comboType: 'BOR120'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'		, type: 'string'	, comboType:'AU'	, comboCode:'S007'},
			{name: 'BILL_NUM'			, text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'			, type: 'string'},
			{name: 'BILL_SEQ'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'				, type: 'int'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'				, type: 'string'},
			{name: 'SALE_UNIT'			, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'		, type: 'string'	, comboType:'AU'	, comboCode:'B013'},
			{name: 'TRANS_RATE'			, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'		, type: 'float'		, decimalPrecision: 6	, format:'0,000.000000'},
			{name: 'SALE_Q'				, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'			, type: 'uniQty'},
			{name: 'SALE_P'				, text: '<t:message code="system.label.sales.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'SALE_AMT_O'			, text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'		, type: 'uniPrice'},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'	, type: 'string'	, comboType:'AU'	, comboCode:'B059'},
			{name: 'TAX_AMT_O'			, text: '<t:message code="system.label.sales.taxamount" default="세액"/>'			, type: 'uniPrice'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'		, type: 'string'	, comboType:'AU'	, comboCode:'S002'},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.sales.billcode" default="계산서코드"/>'		, type: 'string'	, comboType:'AU'	, comboCode:'B066'},
			{name: 'EX_DATE'			, text: '<t:message code="system.label.sales.acslipdate" default="회계전표일"/>'		, type: 'uniDate'},
			{name: 'EX_NUM'				, text: '회계전표번호'	, type: 'string'}
		]
	});	 
	//발행상세내역창 스토어 정의
	var billNoMasterStore2 = Unilite.createStore('billNoMasterStore2', {
		model	: 'billNoMasterModel2',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read  : 'ssa570ukrvService.selectBillNoMasterList2'
			}
		},
		loadStoreRecords : function()  {
			var record				= masterGrid.getSelectedRecord();
			var param				= billNoSearch2.getValues(); 
			param.SALE_DIV_CODE		= record.get('SALE_DIV_CODE');
			param.PUB_NUM			= record.get('PUB_NUM');
			param.SALE_CUSTOM_CODE	= record.get('COLET_CUST_CD');
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		}
	});
	//발행상세내역창 그리드 정의
	var billNoMasterGrid2 = Unilite.createGrid('ssa570ukrvBillNoMasterGrid2', {
		store	: billNoMasterStore2,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		columns	: [
			{ dataIndex: 'SALE_DATE'			, width: 86},
			{ dataIndex: 'DIV_CODE'				, width: 86},
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 93},
			{ dataIndex: 'BILL_NUM'				, width: 110},
			{ dataIndex: 'BILL_SEQ'				, width: 40},
			{ dataIndex: 'ITEM_CODE'			, width: 100},
			{ dataIndex: 'ITEM_NAME'			, width: 153},
			{ dataIndex: 'SPEC'					, width: 153},
			{ dataIndex: 'SALE_UNIT'			, width: 86	, align: 'center'},
			{ dataIndex: 'TRANS_RATE'			, width: 66},
			{ dataIndex: 'SALE_Q'				, width: 86},
			{ dataIndex: 'SALE_P'				, width: 80},
			{ dataIndex: 'SALE_AMT_O'			, width: 93},
			{ dataIndex: 'TAX_TYPE'				, width: 66	, align: 'center'},
			{ dataIndex: 'TAX_AMT_O'			, width: 86},
			{ dataIndex: 'ORDER_TYPE'			, width: 93},
			{ dataIndex: 'BILL_TYPE'			, width: 86},
			{ dataIndex: 'EX_DATE'				, width: 73},
			{ dataIndex: 'EX_NUM'				, width: 110}
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				searchInfoWindow.hide();
			}
		}
	});
	//발행상세내역창 메인
	function openSangsaeInfoWindow() {
		if(!sangsaeInfoWindow) {
			sangsaeInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '계산서번호검색',
				width	: 830,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [billNoSearch2, billNoMasterGrid2],
				tbar	: [{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						sangsaeInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						billNoSearch2.clearForm();
						billNoMasterGrid2.reset();
					},
					beforeclose: function( panel, eOpts ) {
						billNoSearch2.clearForm();
						billNoMasterGrid2.reset();
					},
					show: function( panel, eOpts ) {
						var record = masterGrid.getSelectedRecord();
						billNoSearch2.setValue('DIV_CODE'		, record.get('BILL_DIV_CODE'));
						billNoSearch2.setValue('PUB_FR_DATE'	, record.get('PUB_FR_DATE'));
						billNoSearch2.setValue('PUB_TO_DATE'	, record.get('PUB_TO_DATE'));
						billNoSearch2.setValue('CUSTOM_CODE'	, record.get('CUSTOM_CODE'));
						billNoSearch2.setValue('CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
						billNoSearch2.setValue('BILL_DATE'		, record.get('BILL_DATE'));
						//hidden 필드
						billNoSearch2.setValue('SALE_DIV_CODE'	, record.get('SALE_DIV_CODE'));
						billNoSearch2.setValue('PUB_NUM'		, record.get('PUB_NUM'));
						billNoMasterStore2.loadStoreRecords();
					}
				}
			})
		}
		sangsaeInfoWindow.show();
		sangsaeInfoWindow.center();
	}



	//매출참조 폼 정의
	var billReferSearch = Unilite.createSearchForm('billReferForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	:[{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'SALE_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false
		},{
			fieldLabel	: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
			name		: 'AGENT_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B055'
		},{
			fieldLabel	: ' ',
			xtype		: 'uniCheckboxgroup',
			id			: 'ZERO_YN',
			items		: [{
				boxLabel		: '0원 포함',
				name			: 'ZERO_YN',
				inputValue		: 'Y',
				uncheckedValue	: 'N',
				width			: 150
			}]
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						billReferSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						billReferSearch.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.area" default="지역"/>',
			name		: 'AREA_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B056'
		},
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			valueFieldName	: 'PROJECT_NO',
			textFieldName	: 'PROJECT_NO',
			validateBlank	: false,
			hidden			: gsPjtCodeYN,
			listeners		: {
				applyextparam: function(popup){
					if(!Ext.isEmpty(billReferSearch.getValue('CUSTOM_CODE')) && !Ext.isEmpty(billReferSearch.getValue('CUSTOM_NAME'))) {
						popup.setExtParam({'CUSTOM_CODE': billReferSearch.getValue('CUSTOM_CODE')});
					} else {
						popup.setExtParam({'CUSTOM_CODE': ''});
					}
				}
			}
		}),
		Unilite.popup('PJT',{
			fieldLabel		: '<t:message code="system.label.sales.project" default="프로젝트"/>',
			validateBlank	: false,
			hidden			: !gsPjtCodeYN
		}),{
			fieldLabel	: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>',
			xtype		: 'radiogroup',
			hidden		: true,
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.taxation" default="과세"/>',
				name		: 'BILL_TYPE',
				inputValue	: '1',
				width		: 60,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.sales.taxexemption" default="면세"/>',
				name		: 'BILL_TYPE',
				inputValue	: '2',
				width		: 60
			},{
				boxLabel	: '<t:message code="system.label.sales.zerotaxrate" default="영세율"/>',
				name		: 'BILL_TYPE',
				inputValue	: '3',
				width		: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.getField('BILL_TYPE').setValue(newValue.BILL_TYPE);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010'
		}]
	});
	//매출참조 모델 정의
	Unilite.defineModel('ssa570ukrvBillReferModel', {
		fields: [
//			{name: 'CHOICE'					,text: '<t:message code="system.label.sales.selection" default="선택"/>'				, type: 'string'},
			{name: 'DIV_CODE'				,text: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'		, type: 'string', type: 'string', comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.client" default="고객"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'			, type: 'string'},
			{name: 'SALE_TAX_I'				,text: '<t:message code="system.label.sales.taxedamounttotal" default="과세액계"/>'		, type: 'uniPrice'},
			{name: 'TAX_AMT_I'				,text: '<t:message code="system.label.sales.taxamounttotal" default="세액계"/>'		, type: 'uniPrice'},
			{name: 'SALE_NOTAX_I'			,text: '<t:message code="system.label.sales.taxexemptiontotal" default="면세액계"/>'	, type: 'uniPrice'},
			{name: 'BILL_TYPE'				,text: '<t:message code="system.label.sales.billcode" default="계산서코드"/>'			, type: 'string'},
			{name: 'BILL_TYPE_NM'			,text: '<t:message code="system.label.sales.billtype" default="계산서종류"/>'			, type: 'string'},
			{name: 'PROJECT_NO'				,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'PJT_CODE'				,text: '<t:message code="system.label.sales.projectcode" default="프로젝트코드"/>'		, type: 'string'},
			{name: 'PJT_NAME'				,text: '<t:message code="system.label.sales.project" default="프로젝트"/>'				, type: 'string'},
			{name: 'AGENT_TYPE'				,text: '<t:message code="system.label.sales.clienttype" default="고객분류"/>'			, type: 'string', type: 'string', comboType: 'AU', comboCode: 'B055'},
			{name: 'AREA_TYPE'				,text: '<t:message code="system.label.sales.area" default="지역"/>'					, type: 'string', type: 'string', comboType: 'AU', comboCode: 'B056'},
			{name: 'TRANS_CLOSE_DAY'		,text: '<t:message code="system.label.sales.closingtype" default="마감종류"/>'			, type: 'string'},
			{name: 'COLLECT_DAY'			,text: 'COLLECT_DAY'	, type: 'int'},
			{name: 'COLLECTOR_CP'			,text: 'COLLECTOR_CP'	, type: 'string'},
			{name: 'COLLECT_CARE'			,text: 'COLLECT_CARE'	, type: 'string'},
			{name: 'TAX_CALC_TYPE'			,text: 'TAX_CALC_TYPE'	, type: 'string'},
			{name: 'SERVANT_COMPANY_NUM'	,text: '<t:message code="system.label.common.bureaubusinessnumber" default="종사업장번호"/>'	, type: 'string'}
		]
	});
	//매출참조 스토어 정의
	var billReferStore = Unilite.createStore('ssa570ukrvBillReferStore', {
		model	: 'ssa570ukrvBillReferModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'ssa570ukrvService.selectBillReferList'
			}
		},
		loadStoreRecords : function() {
			var param			= billReferSearch.getValues();
			param.BILL_DIV_CODE	= panelResult.getValue('BILL_DIV_CODE');
			param.DATE_FR		= UniDate.getDbDateStr(panelResult.getValue('DATE_FR'));
			param.DATE_TO		= UniDate.getDbDateStr(panelResult.getValue('DATE_TO'));
			if(Ext.getCmp('optTaxGb').getChecked()[0].inputValue == '11'){
				param.BILL_TYPE = '1';
			} else if(Ext.getCmp('optTaxGb').getChecked()[0].inputValue == '20'){
				param.BILL_TYPE = '2';
			} else{
				param.BILL_TYPE = '3';
			}
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords	= detailStore.data.filterBy(detailStore.filterNewOnly);
					var refRecords		= new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if((record.data['CUSTOM_CODE'] == item.data['CUSTOM_CODE']) && (record.data['BILL_TYPE'] == item.data['BILL_TYPE'])) {
									refRecords.push(item);
								}
							});
						});
						store.remove(refRecords);
					}
				}
			}
		}
	});
	//매출참조 그리드 정의
	var billReferGrid = Unilite.createGrid('ssa570ukrvbillReferGrid', {
		store	: billReferStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false }),
		uniOpt	: {
			onLoadSelectFirst: false
		},
		columns	: [
//			{ dataIndex: 'CHOICE'				, width: 66	},
			{ dataIndex: 'DIV_CODE'				, width: 86	},
			{ dataIndex: 'CUSTOM_CODE'			, width: 86	},
			{ dataIndex: 'CUSTOM_NAME'			, width: 133},
			{ dataIndex: 'SALE_TAX_I'			, width: 100},
			{ dataIndex: 'TAX_AMT_I'			, width: 93	},
			{ dataIndex: 'SALE_NOTAX_I'			, width: 86	},
			{ dataIndex: 'BILL_TYPE'			, width: 66	, hidden: true},
			{ dataIndex: 'BILL_TYPE_NM'			, width: 86	},
			{ dataIndex: 'TRANS_CLOSE_DAY'		, width: 106},
			{ dataIndex: 'PROJECT_NO'			, width: 100, hidden: gsPjtCodeYN},
			{ dataIndex: 'PJT_CODE'				, width: 100, hidden: true},
			{ dataIndex: 'PJT_NAME'				, width: 100, hidden: !gsPjtCodeYN},
			{ dataIndex: 'AGENT_TYPE'			, width: 93	, align: 'center'},
			{ dataIndex: 'AREA_TYPE'			, width: 93	, align: 'center'},
			{ dataIndex: 'COLLECT_DAY'			, width: 66	, hidden: true},
			{ dataIndex: 'COLLECTOR_CP'			, width: 66	, hidden: true},
			{ dataIndex: 'COLLECT_CARE'			, width: 66	, hidden: true},
			{ dataIndex: 'TAX_CALC_TYPE'		, width: 66	, hidden: true},
			{ dataIndex: 'SERVANT_COMPANY_NUM'	, width: 106, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i) {
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setRefData(record.data);
			}); 
			//this.deleteSelectedRow();
		}
	});
	//매출참조 메인
	function openSaleReferWindow() {
		if(!panelResult.getInvalidMessage()) return false;
		panelResult.setAllFieldsReadOnly(true);
		billReferSearch.setValue('SALE_DIV_CODE', panelResult.getValue('BILL_DIV_CODE'));
		if(!referSaleWindow) {
			referSaleWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.salesreference" default="매출참조"/>',
				width	: 950,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [billReferSearch, billReferGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						billReferStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '내역적용',
					handler	: function() {
						billReferGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '참조적용 후 닫기',
					handler	: function() {
						billReferGrid.returnData();
						referSaleWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						referSaleWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						billReferSearch.clearForm();
						billReferGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						billReferSearch.clearForm();
						billReferGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						billReferStore.loadStoreRecords();
					}
				}
			})
		}
		referSaleWindow.show();
		referSaleWindow.center();
	}



	Unilite.Main({
		id			: 'ssa570ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [{
				region	: 'center',
				xtype	: 'container',
				layout	: 'fit',
				items	: [ masterGrid ]
			},
			panelResult,
			{
				region : 'north',
				xtype : 'container',
				highth: 20,
				layout : 'fit',
				items : [ inputTable ]
			}]
		}],
		fnInitBinding: function() {
			this.setDefault();
		},
		setDefault: function() {
			gsSelectionFlag	= true;
			gsStatus		= 'N';
			panelResult.setValue('BILL_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DATE_FR'		, UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_TO'		, UniDate.get('today'));
			panelResult.setValue('BILL_DATE'	, UniDate.get('today'));
			panelResult.setValue('BILL_TYPE'	, '11');
			if(!Ext.isEmpty(BsaCodeInfo.gsOwnNum)) {
				var ownNum = BsaCodeInfo.gsOwnNum.COMPANY_NUM;
				if(ownNum && ownNum.length == 10) {
					ownNum = ownNum.substring(0, 3) + '-' + ownNum.substring(3, 5) + '-' + ownNum.substring(5);
				}
				panelResult.setValue('COMPANY_NUM', ownNum);
			}
			panelResult.getForm().findField('COMPANY_NUM').setReadOnly(true);
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('reset'	, true);
			UniAppManager.setToolbarButtons('save'	, false);
			Ext.getCmp('sangsaeInfo').setDisabled(true);

			var createBtn = panelResult.down("#btnProc");
			createBtn.setText('<t:message code="system.label.sales.salesslip" default="매출기표"/>');
			createBtn.setDisabled(true);

			//20200701 주석: 사업장 권한 관련로직 공통에서 처리하므로 주석 처리
//			if(pgmInfo.authoUser != 'N') {
//				panelResult.getField('BILL_DIV_CODE').setReadOnly(true);
//				panelResult.onLoadSelectText('DATE_FR');
//			} else {
//				panelResult.getField('BILL_DIV_CODE').setReadOnly(false);
				panelResult.onLoadSelectText('BILL_DIV_CODE');
//			}
			panelResult.getForm().wasDirty = false;
		},
		onQueryButtonDown: function() {
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(gsStatus == 'N') {
				openSearchInfoWindow()
			} else {
				detailStore.loadStoreRecords();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(Ext.isEmpty(selRow)) {
					Unilite.messageBox('<t:message code="unilite.msg.sMC018"/>');
				} else if(!Ext.isEmpty(selRow.get('EX_DATE'))) {
					Unilite.messageBox('<t:message code="unilite.msg.sMS322"/>');
				} else if(selRow.get('COLET_AMT') != 0) {
					Unilite.messageBox('<t:message code="unilite.msg.sMS323"/>');
				} else if(selRow.get('BILL_SEND_YN') == 'Y') {
					Unilite.messageBox('<t:message code="unilite.msg.fsbMsgS0217"/>');
				} else {
					gsSelectionFlag = false;
					masterGrid.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			var deletable = true;
			if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
				Ext.each(records, function(record,i) {
					if(record.phantom){					// 신규 레코드일시 isNewData에 true를 반환
						isNewData = true;
					} else {							// 신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
						isNewData = false;
							/*---------삭제전 로직 구현 시작----------*/
							if(!Ext.isEmpty(record.get('EX_DATE'))) {
								Unilite.messageBox('<t:message code="unilite.msg.sMS322"/>');
								deletable = false;
								return false;
							} else if(record.get('COLET_AMT') != 0) {
								Unilite.messageBox('<t:message code="unilite.msg.sMS323"/>');
								deletable = false;
								return false;
							} else if(record.get('BILL_SEND_YN') == 'Y') {
								Unilite.messageBox('<t:message code="unilite.msg.fsbMsgS0217"/>');
								deletable = false;
								return false;
							}
							/*---------삭제전 로직 구현 끝----------*/
					}
				});
			} else {
				deletable = false;
				return false;
			}
			if(isNewData){								// 신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	// 삭제후 RESET..
			}
			if(deletable){
				masterGrid.reset();
				UniAppManager.app.onSaveDataButtonDown();
			}
		},
		onSaveDataButtonDown: function(config) {
			var BillNo = panelResult.getValue('COMPANY_NUM');
			if(Ext.isEmpty(BillNo)) {
				if(detailStore.data.length == 0) {
					Unilite.messageBox('수주상세정보를 입력하세요.');
					return;
				}
			}
			detailStore.saveStore();
		},
		onNewDataButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			panelResult.setAllFieldsReadOnly(true);
			gsSelectionFlag = false;
			var orderNum = panelResult.getValue('COMPANY_NUM')
			
			var seq = detailStore.max('SER_NO');
			if(!seq) seq = 1;
			else  seq += 1;
			
			var taxType ='1';
			if(Ext.getCmp('optTaxGb').getChecked()[0].inputValue=='50') {
			taxType ='2';
			}
			
			var dvryDate = '';
			if(!Ext.isEmpty(panelResult.getValue('DVRY_DATE'))) {
			dvryDate=panelResult.getValue('DVRY_DATE');
			} else {
			dvryDate= new Date();
			}
			
			var saleCustCd = '';
			if(!Ext.isEmpty(panelResult.getValue('SALE_CUST_CD'))) {
			saleCustCd=panelResult.getValue('SALE_CUST_CD');
			}
			
			var custName = '';
			if(!Ext.isEmpty(panelResult.getValue('SALE_CUST_NM'))) {
			custName=panelResult.getValue('SALE_CUST_NM');
			}
		
			var refOrderDate = '';
			if(!Ext.isEmpty(panelResult.getValue('ORDER_DATE'))) {
			refOrderDate=panelResult.getValue('ORDER_DATE');
			}
			 
			var refOrdCust = '';
			if(!Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
			refOrdCust=panelResult.getValue('CUSTOM_CODE');
			}

			var refOrderType = '';
			if(!Ext.isEmpty(panelResult.getValue('ORDER_TYPE'))) {
			refOrderType=panelResult.getValue('ORDER_TYPE');
			}

			var projectNo = '';
			if(!Ext.isEmpty(panelResult.getValue('PLAN_NUM'))) {
			projectNo=panelResult.getValue('PLAN_NUM');
			}

			var refBillType = '';
			if(!Ext.isEmpty(Ext.getCmp('optTaxGb').getChecked()[0].inputValue)) {
			refBillType=Ext.getCmp('optTaxGb').getChecked()[0].inputValue;
			}

			var refReceiptSetMeth = '';
			if(!Ext.isEmpty(panelResult.getValue('RECEIPT_METH'))) {
			refReceiptSetMeth=panelResult.getValue('RECEIPT_METH');
			}

			var r = {
				COMPANY_NUM: orderNum,
				SER_NO: seq,
				//TAX_TYPE: taxType,
				DVRY_DATE: dvryDate,
				SALE_CUST_CD: saleCustCd,
				CUSTOM_NAME: custName,
				REF_ORDER_DATE: refOrderDate,
				REF_ORD_CUST: refOrdCust,
				REF_ORDER_TYPE: refOrderType,
				PROJECT_NO: projectNo,
				REF_BILL_TYPE: refBillType,
				REF_RECEIPT_SET_METH: refReceiptSetMeth
			};
			
			masterGrid.createRow(r, 'ITEM_CODE', -1);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			inputTable.clearForm();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});



	//Validation
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "EX_DATE" :
					if(Ext.isEmpty(newValue)) {
						rv= Msg.sMS322; 
						break;
					}
					
				break;

				case "COLET_AMT" :
					if(newValue != 0) {
						rv= Msg.sMS323;
						break;
					}
				break;

				case "BILL_SEND_YN" :
					if(newValue == 'Y') {
						rv= Msg.fsbMsgS0217; 
						break;
					}
				break;

				case "RECEIPT_PLAN_DATE" :
					if(newValue < panelResult.getValue('BILL_DATE')) {
						rv= Msg.sMS326; 
						break;
					}
				break;
			}
			return rv;
		}
	}); // validator



	//수금일 계산 함수
	function fnRcptDateCal(sValue, sDay){				//sValue: 계산서 발행일, sDay: 거래처별 수금일
		//수금일이 있을 경우,
		if(!Ext.isEmpty(sDay) && sDay != 0){
			sDay = sDay < 10 ? '0' + sDay : sDay;
			var sBDAY		= UniDate.getDbDateStr(sValue).substring(6, 8);
			var sYearMonth	= UniDate.getDbDateStr(sValue).substring(0, 6);
			var sYearMonth2	= sYearMonth.substring(0, 4) + '-' + sYearMonth.substring(4, 6);
			if(sBDAY >= sDay){
				//계산서 발행일이 수금일보다 늦을 경우, 다음달 수금일
				return UniDate.add(new Date(sYearMonth2 + '-' + sDay), {months: +1});
			} else {
				//계산서 발행일이 수금일보다 빠를 경우, 이번달 수금일
				return sYearMonth + sDay;
			}
		} else {
			//수금일이 없을 경우, 이달 말일?
			var nextMonth = UniDate.getDbDateStr(UniDate.add(sValue, {months: +1})).substring(0, 4) + '-' +
							UniDate.getDbDateStr(UniDate.add(sValue, {months: +1})).substring(4, 6) + '-' + '01';
			return UniDate.add(new Date(nextMonth), {days:-1});
		}
	}
}
</script>