<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="s_map200ukrv_wm"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_map200ukrv_wm"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A022"/>				<!-- 계산서유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>				<!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>				<!-- 세액계산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B038"/>				<!-- 결제방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B051"/>				<!-- 세액계산법 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>				<!-- 세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="M001"/>				<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M302"/>				<!-- 매입유형 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">
	//우편번호 다음 API 연동
	var protocol = ("https:" == document.location.protocol) ? "https" : "http";
	if(protocol == "https") {
		document.write(unescape("%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	} else {
		document.write(unescape("%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	}
</script><!-- Unilite.popup('ZIP',..) -->

<script type="text/javascript" >

function appMain() {
	var BsaCodeInfo = {
		gsDefaultMoney	: '${gsDefaultMoney}',	//기준화폐
		gsAutoType1		: '${gsAutoType1}',		//자동채번여부(M101.4)
		gsAutoType2		: '${gsAutoType2}'		//자동채번여부(M101.5)
	};
	var activeGridId	= 's_map200ukrv_wmGrid';
	var gsKeyValue;
	var gsInitFlag;								//초기화, reset 시, 등록여부 변경에 따른 조회로직 수행되지 않게 하기 위해 추가
	var gsInitFlag2;							//20210617 추가: 초기화, reset 시, 집계구분 변경에 따른 조회로직 수행되지 않게 하기 위해 추가
	var gsCheckFlag		= true;					//20210603 추가: 체크박스 로직 구현하기 위해 추가

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4
//			,tableAttrs	: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//			,tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding		: '1 1 1 1',
		border		: true,
		autoScroll	: true,
		items		: [{
			fieldLabel	: '<t:message code="system.label.purchase.purchasedivision" default="매입사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var param = {"DIV_CODE": newValue};
					s_map200ukrv_wmService.billDivCode(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							panelResult.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
						}
					});
					panelResult.setValue('DEPT_CODE','');
					panelResult.setValue('DEPT_NAME','');
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INOUT_DATE_FR',
			endFieldName	: 'INOUT_DATE_TO',
			holdable		: 'hold',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			allowBlank		: false
		},{
			fieldLabel	: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
			name		: 'BILL_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			allowBlank	: false,
			holdable	: 'hold',
//			colspan		: 2,		//20210617 주석: 집계구분 필드 추가하면서 주석
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('CHANGE_BASIS_DATE', newValue);
					if(Ext.isDate(newValue)) {
						fnSetIssueExpectedDate(newValue);
					}
				}
			}
		},{	//20210617 추가: 데이터 저장 시, 기준이 될 구분 필드 추가
			xtype		: 'radiogroup',
			fieldLabel	: '집계구분',
			name		: 'DATA_GUBUN',
			itemId		: 'DATA_GUBUN',
//			holdable	: 'hold',
			items		: [{
				boxLabel	: '입고별',
				name		: 'DATA_GUBUN',
				inputValue	: '1',
				width		: 70
			},{
				boxLabel	: '거래처별',
				name		: 'DATA_GUBUN',
				inputValue	: '2',
				width		: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!gsInitFlag2) {
						UniAppManager.app.onQueryButtonDown(null, newValue.DATA_GUBUN);
					}
					gsInitFlag2 = false;
				}
			}
		},
		Unilite.popup('DEPT', {
			fieldLabel		: '<t:message code="system.label.purchase.department" default="부서"/>',
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME',
			allowBlank		: false,
			holdable		: 'hold',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					var authoInfo	= pgmInfo.authoUser;					//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode	= UserInfo.deptCode;					//부서정보
					var divCode		= '';									//사업장

					if(authoInfo == 'A'){									//자기사업장
						popup.setExtParam({'DEPT_CODE'	: ''});
						popup.setExtParam({'DIV_CODE'	: UserInfo.divCode});
					} else if(authoInfo == 'N' || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE'	: ''});
						popup.setExtParam({'DIV_CODE'	: panelResult.getValue('DIV_CODE')});
					} else if(authoInfo == '5'){							//부서권한
						popup.setExtParam({'DEPT_CODE'	: UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE'	: UserInfo.divCode});
					}
				}
			}
		}),
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			holdable		: 'hold',
			tdAttrs			: {width: 330},
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
			name		: 'CHANGE_BASIS_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.base.entryyn" default="등록여부"/>',
			name		: 'ENTRY_YN',
			itemId		: 'ENTRY_YN',
//			holdable	: 'hold',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.nonentry" default="미등록"/>',
				name		: 'ENTRY_YN',
				inputValue	: 'N',
				width		: 70
			},{
				boxLabel	: '<t:message code="system.label.sales.entry" default="등록"/>',
				name		: 'ENTRY_YN',
				inputValue	: 'Y',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue.ENTRY_YN == 'N') {
						directMasterStore.uniOpt.deletable	= false;
					} else {
						directMasterStore.uniOpt.deletable	= true;
					}
					if(!gsInitFlag) {
						UniAppManager.app.onQueryButtonDown(newValue.ENTRY_YN);
					}
					gsInitFlag = false;
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
						var labelText = invalid.items[0]['fieldLabel']+':';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
					}
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
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
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
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



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_map200ukrv_wmService.selectList',
			update	: 's_map200ukrv_wmService.updateDetail',
			create	: 's_map200ukrv_wmService.insertDetail',
			destroy	: 's_map200ukrv_wmService.deleteDetail',
			syncAll	: 's_map200ukrv_wmService.saveAll'
		}
	});

	Unilite.defineModel('s_map200ukrv_wmModel', {
		fields: [
			{name: 'SAVE_FLAG'				, text: 'SAVE_FLAG'		, type: 'string'},
			{name: 'GROUP_KEY'				, text: 'GROUP_KEY'		, type: 'string'},
			{name: 'COMP_CODE'				, text: 'COMP_CODE'		, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'				, text: 'DIV_CODE'		, type: 'string'	, allowBlank: false},
			{name: 'BILL_DIV_CODE'			, text: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>'			, type: 'string'	, comboType:'BOR120'	, allowBlank: false},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'CHANGE_BASIS_NUM'		, text: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>'				, type: 'string'},
			{name: 'CHANGE_BASIS_DATE'		, text: '<t:message code="system.label.purchase.exdate" default="결의일"/>'					, type: 'uniDate'},
			{name: 'DEPT_CODE'				, text: '<t:message code="system.label.purchase.department" default="부서"/>'					, type: 'string'},
			{name: 'DEPT_NAME'				, text: '<t:message code="system.label.purchase.department" default="부서"/>'					, type: 'string'},
			{name: 'BILL_TYPE'				, text: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'A022'	, allowBlank: false},
			{name: 'BILL_NUM'				, text: '<t:message code="system.label.purchase.billno" default="계산서번호"/>'					, type: 'string'},
			{name: 'BILL_DATE'				, text: '<t:message code="system.label.purchase.billdate" default="계산서일"/>'					, type: 'uniDate'},
			{name: 'RECEIPT_TYPE'			, text: '<t:message code="system.label.purchase.payingmethod" default="결제방법"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'B038'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string'	, comboType: 'AU', comboCode: 'M001'},
			{name: 'AMOUNT_I'				, text: '<t:message code="system.label.purchase.amount" default="금액"/>'						, type: 'uniPrice'},
			{name: 'VAT_RATE'				, text: '<t:message code="system.label.purchase.vatrate" default="부가세율"/>'					, type: 'uniPercent'},
			{name: 'VAT_AMOUNT_O'			, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'				, type: 'uniPrice'},
			{name: 'AMOUNT_TOT'				, text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'				, type: 'uniPrice'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					, type: 'string'	, allowBlank: false},
			{name: 'EX_DATE'				, text: '<t:message code="system.label.purchase.purchasepostdate" default="매입기표일"/>'		, type: 'uniDate'},
			{name: 'EX_NUM'					, text: '<t:message code="system.label.purchase.slipno" default="전표번호"/>'					, type: 'int'},
			{name: 'AGREE_YN'				, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'				, type: 'string'},
			{name: 'AC_DATE'				, text: '<t:message code="system.label.human.acdate" default="회계전표일"/>'						, type: 'uniDate'},
			{name: 'AC_NUM'					, text: '<t:message code="system.label.purchase.acslipno" default="회계전표번호"/>'				, type: 'int'},
			{name: 'DRAFT_YN'				, text: '<t:message code="system.label.purchase.drafting" default="기안여부"/>'					, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'ISSUE_EXPECTED_DATE'	, text: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>'			, type: 'uniDate'},
			{name: 'ACCOUNT_TYPE'			, text: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'M302'	, allowBlank: false},
			{name: 'PJT_CODE'				, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'CREDIT_NUM'				, text: '<t:message code="system.label.purchase.compcardcashno" default="법인카드/현금영수증번호"/>'	, type: 'string'},
			{name: 'EB_NUM'					, text: '전자세금계산서 번호'		, type: 'string'},
			{name: 'BILL_SEND_YN'			, text: '전송여부'				, type: 'string'},
			{name: 'TAX_INOUT'				, text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'			, type: 'string'	, comboType: 'AU', comboCode: 'B030'},
			{name: 'TAX_CALC_TYPE'			, text: '세액 계산법(개별/통합)'		, type: 'string'},
			{name: 'TAX_TYPE'				, text: '세구분(과세, 면세)'		, type: 'string'},
			{name: 'UPDATE_DB_USER'			, text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'				, type: 'string'},
			{name: 'USER_NAME'				, text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'				, type: 'string'},
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
			{name: 'INOUT_SEQ'				, text: '<t:message code="system.label.purchase.receiptseq2" default="입고순번"/>'				, type: 'int'}
		]
	});//End of Unilite.defineModel('s_map200ukrv_wmModel', {

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_map200ukrv_wmMasterStore',{
		model	: 's_map200ukrv_wmModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(ENTRY_YN, DATA_GUBUN) {
			var param = panelResult.getValues();
			if(!Ext.isEmpty(ENTRY_YN)) {
				param.ENTRY_YN = ENTRY_YN;
			}
			if(!Ext.isEmpty(DATA_GUBUN)) {
				param.DATA_GUBUN = DATA_GUBUN;
			}
			this.load({
				params: param
			});
		},
		saveStore: function() {
			var inValidRecs			= this.getInvalidRecords();
//			var toCreate			= this.getNewRecords();
//			var toUpdate			= this.getUpdatedRecords();
//			var toDelete			= this.getRemovedRecords();
			var paramMaster			= panelResult.getValues();	//syncAll 수정
			paramMaster.KEY_VALUE	= gsKeyValue;

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_map200ukrv_wmGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				if(records.length == 0) {
//					UniAppManager.app.onResetButtonDown();
//				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				//20210603 추가: 체크박스 로직 구현하기 위해 추가
				if(!gsCheckFlag) {
					var sm		= masterGrid.getSelectionModel();
					var data	= sm.getSelection();
					data.push(record);
					if(!masterGrid.getSelectionModel().isSelected(record)) {
						sm.select(data);
					}
					gsCheckFlag	= true;
				}
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_map200ukrv_wmGrid', {
		store		: directMasterStore,
		layout		: 'fit',
		region		: 'center',
		excelTitle	: '<t:message code="system.label.purchase.eachpurchaseslipentry" default="매입지급결의 일괄등록"/>',
		uniOpt		: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: true,
			onLoadSelectFirst	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: false
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
				},
				select: function(grid, record, index, eOpts){
				},
				deselect: function(grid, record, index, eOpts){
				}
			}
		}),
		columns: [
//			{dataIndex: 'SAVE_FLAG'				, width: 100	, hidden: false},
//			{dataIndex: 'COMP_CODE'				, width: 100	, hidden: true},
//			{dataIndex: 'DIV_CODE'				, width: 100	, hidden: true},
//			{dataIndex: 'BILL_DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'CHANGE_BASIS_NUM'		, width: 120},
//			{dataIndex: 'CHANGE_BASIS_DATE'		, width: 80	},
//			{dataIndex: 'CUSTOM_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'			, width: 150},
//			{dataIndex: 'DEPT_CODE'				, width: 100},
//			{dataIndex: 'DEPT_NAME'				, width: 100},
			{dataIndex: 'BILL_TYPE'				, width: 130},
//			{dataIndex: 'BILL_NUM'				, width: 120},
//			{dataIndex: 'BILL_DATE'				, width: 80	},
//			{dataIndex: 'RECEIPT_TYPE'			, width: 100},
			{dataIndex: 'VAT_RATE'				, width: 80	},
			{dataIndex: 'TAX_INOUT'				, width: 100	, align: 'center'},
			{dataIndex: 'ORDER_TYPE'			, width: 100	, align: 'center'},
			{dataIndex: 'AMOUNT_I'				, width: 100},
			{dataIndex: 'VAT_AMOUNT_O'			, width: 100},
			{dataIndex: 'AMOUNT_TOT'			, width: 100},
//			{dataIndex: 'MONEY_UNIT'			, width: 100	, hidden: true},
			{dataIndex: 'ISSUE_EXPECTED_DATE'	, width: 80	},
			{dataIndex: 'EX_DATE'				, width: 80	},
			{dataIndex: 'EX_NUM'				, width: 100},
//			{dataIndex: 'AGREE_YN'				, width: 100	, hidden: true},
//			{dataIndex: 'AC_DATE'				, width: 80	},
//			{dataIndex: 'AC_NUM'				, width: 100},
//			{dataIndex: 'DRAFT_YN'				, width: 100	, hidden: true},
//			{dataIndex: 'PROJECT_NO'			, width: 100	, hidden: true},
//			{dataIndex: 'ACCOUNT_TYPE'			, width: 100	, align: 'center'},
//			{dataIndex: 'PJT_CODE'				, width: 100	, hidden: true},
//			{dataIndex: 'CREDIT_NUM'			, width: 100	, hidden: true},
//			{dataIndex: 'EB_NUM'				, width: 100	, hidden: true},
//			{dataIndex: 'BILL_SEND_YN'			, width: 100	, hidden: true},
//			{dataIndex: 'UPDATE_DB_USER'		, width: 100	, hidden: true},
			{dataIndex: 'USER_NAME'				, width: 100	}
		],
		listeners: {
			//20210603 추가: 그리드 동작로직 추가 - 그리드 cell 클릭 시, 체크박스 선택되도록 && 수정가능한 컬럼일 경우 제외
			cellclick: function( view, td, cellIndex, selRecord, tr, rowIndex, e, eOpts ) {
				var queryFlag = panelResult.getValues().ENTRY_YN;
				if( cellIndex != 0
				&& !(queryFlag == 'N' && (cellIndex == masterGrid.getColumnIndex('BILL_TYPE')
										|| cellIndex == masterGrid.getColumnIndex('MONEY_UNIT')
										|| cellIndex == masterGrid.getColumnIndex('ACCOUNT_TYPE')
										|| cellIndex == masterGrid.getColumnIndex('ISSUE_EXPECTED_DATE')
										|| cellIndex == masterGrid.getColumnIndex('RECEIPT_TYPE')
										|| cellIndex == masterGrid.getColumnIndex('VAT_RATE')
										|| cellIndex == masterGrid.getColumnIndex('TAX_INOUT')))
				&& !(queryFlag == 'Y' && (cellIndex == masterGrid.getColumnIndex('BILL_TYPE')
										|| cellIndex == masterGrid.getColumnIndex('TAX_INOUT')))
				) {
					var sm		= masterGrid.getSelectionModel();
					var data	= sm.getSelection();
					var data2	= new Array;
					data.push(selRecord);
					data2.push(selRecord);
					if(!masterGrid.getSelectionModel().isSelected(selRecord)) {
						sm.select(data);
					} else {
						sm.deselect(data2);
					}
				}
			},
			beforeedit: function( editor, e, eOpts ) {
				var queryFlag = panelResult.getValues().ENTRY_YN;
				if(queryFlag == 'N') {							//미등록일 경우
					if(UniUtils.indexOf(e.field, ['BILL_TYPE', 'MONEY_UNIT', 'ACCOUNT_TYPE', 'ISSUE_EXPECTED_DATE', 'RECEIPT_TYPE', 'VAT_RATE', 'TAX_INOUT'])){
						return true;
					} else {
						return false;
					}
				} else {										//등록일 경우
					if(UniUtils.indexOf(e.field, ['BILL_TYPE', 'TAX_INOUT'])){
						return true;
					} else {
						return false;
					}
				}
			},
			select: function(grid, selected, index, rowIndex, eOpts ){
				directMasterStore2.clearFilter();
				var detailRecords	= directMasterStore2.data.items;
				var queryFlag		= panelResult.getValues().ENTRY_YN;

				if(queryFlag == 'N') {							//미등록일 경우
					selected.set('SAVE_FLAG', 'Y');
				}

				if(UniAppManager.app._needSave()) {
					gsSaveFlag = true;
				} else {
					gsSaveFlag = false;
				}
				//선택된 행의 저장된 데이터만 detailGrid에 보여주도록 filter
				if(!Ext.isEmpty(selected)) {
					if(queryFlag == 'N') {							//미등록일 경우
						directMasterStore2.filterBy(function(record){
							return record.get('GROUP_KEY') == selected.get('GROUP_KEY');
						});
					} else {
						directMasterStore2.filterBy(function(record){
							return record.get('COMP_CODE')			== selected.get('COMP_CODE')
								&& record.get('DIV_CODE')			== selected.get('DIV_CODE')
								&& record.get('CHANGE_BASIS_NUM')	== selected.get('CHANGE_BASIS_NUM')
						});
					}
				}
				if(queryFlag == 'N') {							//미등록일 경우
					Ext.each(detailRecords, function(detailRecord, index) {
						if(detailRecord.get('GROUP_KEY') == selected.get('GROUP_KEY')) {
							detailRecord.set('SAVE_FLAG', 'Y');
						}
					});
				}
			},
			deselect: function(grid, record, index, eOpts ){
				directMasterStore2.clearFilter();
				var detailRecords	= directMasterStore2.data.items;
				var queryFlag		= panelResult.getValues().ENTRY_YN;

				if(queryFlag == 'N') {							//미등록일 경우
					record.set('SAVE_FLAG', '');
				}
				if(masterGrid.getSelectionModel().getSelection().length == 0) {
					directMasterStore2.filterBy(function(record){
						return record.get('COMP_CODE') == 'ZZZZZ';
					})
				} else {
					var selected = masterGrid.getSelectionModel().getSelection()[masterGrid.getSelectionModel().getSelection().length - 1];
					if(queryFlag == 'N') {							//미등록일 경우
						directMasterStore2.filterBy(function(record){
							return record.get('GROUP_KEY') == selected.get('GROUP_KEY');
						});
					} else {
						directMasterStore2.filterBy(function(record){
							return record.get('COMP_CODE')			== selected.get('COMP_CODE')
								&& record.get('DIV_CODE')			== selected.get('DIV_CODE')
								&& record.get('CHANGE_BASIS_NUM')	== selected.get('CHANGE_BASIS_NUM')
						});
					}
				}
				if(queryFlag == 'N') {							//미등록일 경우
					Ext.each(detailRecords, function(detailRecord, index) {
						if(detailRecord.get('GROUP_KEY') == record.get('GROUP_KEY')) {
							detailRecord.set('SAVE_FLAG', '');
						}
					});
				}
			},
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
				});
			}
		}
	});



	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_map200ukrv_wmService.selectList2',
			update	: 's_map200ukrv_wmService.updateDetail2',
			create	: 's_map200ukrv_wmService.insertDetail2',
			destroy	: 's_map200ukrv_wmService.deleteDetail2',
			syncAll	: 's_map200ukrv_wmService.saveAll2'
		}
	});

	Unilite.defineModel('s_map200ukrv_wmModel2', {
		fields: [
			{name: 'SAVE_FLAG'			, text: 'SAVE_FLAG'		, type: 'string'},
			{name: 'GROUP_KEY'			, text: 'GROUP_KEY'		, type: 'string'},
			{name: 'CHANGE_BASIS_NUM'	, text: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>'				, type: 'string'},
			{name: 'CHANGE_BASIS_SEQ'	, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'int'	},
			{name: 'INSTOCK_DATE'		, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'	, allowBlank: false},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string'	, allowBlank: false},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.unit" default="단위"/>'						, type: 'string'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.qty" default="수량"/>'						, type: 'uniQty'	, allowBlank: true},
			{name: 'REMAIN_Q'			, text: '<t:message code="system.label.purchase.purchasebalanceqty" default="매입잔량"/>'		, type: 'uniQty'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.purchaseprice" default="구매단가"/>'			, type: 'uniUnitPrice'},
			{name: 'AMOUNT_P'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'						, type: 'uniUnitPrice'},
			{name: 'AMOUNT_I'			, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
			{name: 'TAX_I'				, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'				, type: 'uniPrice'},
			{name: 'TOTAL_I'			, text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'				, type: 'uniPrice'},
			{name: 'ORDER_UNIT_FOR_P'	, text: '<t:message code="system.label.purchase.purchaseunitforeigncurrencyunit" default="구매단위외화단가"/>'	, type: 'uniUnitPrice'},
			{name: 'FOREIGN_P'			, text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'		, type: 'uniUnitPrice'},
			{name: 'FOR_AMOUNT_O'		, text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'	, type: 'uniFC'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'				, type: 'uniQty'},
			{name: 'BUY_Q'				, text: '<t:message code="system.label.purchase.inventoryunitqty" default="재고단위량"/>'		, type: 'uniQty'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string'	, comboType:'AU', comboCode:'M001'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'			, type: 'string'},
			{name: 'LC_NUM'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'					, type: 'string'},
			{name: 'BL_NUM'				, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'					, type: 'int'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.purchase.receiptseq2" default="입고순번"/>'				, type: 'int'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string'	, comboType:'BOR120', allowBlank: false},
			{name: 'BILL_DIV_CODE'		, text: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>'			, type: 'string'	, allowBlank: false},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.clientcode" default="고객코드"/>'				, type: 'string'	, allowBlank: false},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'ADVAN_YN'			, text: 'ADVAN_YN'			, type: 'string'},
			{name: 'ADVAN_AMOUNT'		, text: 'ADVAN_AMOUNT'		, type: 'string'},
			{name: 'PURCHASE_TYPE'		, text: 'PURCHASE_TYPE'		, type: 'string'},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.purchase.taxtype" default="세구분"/>'					, type: 'string' ,comboType:'AU', comboCode:'B059'},
			{name: 'CUSTOM_PRSN'		, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'PHONE'				, text: '연락처'				, type: 'string'},
			{name: 'BANK_NAME'			, text: '은행명'				, type: 'string'},
			{name: 'BANK_ACCOUNT'		, text: '계좌번호'				, type: 'string'},
			{name: 'BIRTHDAY'			, text: '생년월일'				, type: 'string'},	//20210317 수정: uniDate -> string
			{name: 'ZIP_CODE'			, text: '우편번호'				, type: 'string'},
			{name: 'ADDR1'				, text: '주소'				, type: 'string'},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>'				, type: 'string'},
			{name: 'VAT_RATE'			, text: '<t:message code="system.label.purchase.vatrate" default="부가세율"/>'					, type: 'uniPercent'},
			{name: 'EX_DATE'			, text: '<t:message code="system.label.purchase.purchasepostdate" default="매입기표일"/>'		, type: 'uniDate'},
			//filtering 위해 필요
			{name: 'CUSTOM_CODE'		, text: 'CUSTOM_CODE'	, type: 'string'},
			{name: 'TAX_INOUT'			, text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'			, type: 'string'	, comboType: 'AU', comboCode: 'B030'},
			{name: 'WON_CALC_BAS'		, text: 'WON_CALC_BAS'	, type: 'string'}
		]
	});//End of Unilite.defineModel('s_map200ukrv_wmModel2', {

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore2 = Unilite.createStore('s_map200ukrv_wmMasterStore2',{
		model	: 's_map200ukrv_wmModel2',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true		// 삭제 가능 여부
		},
		autoLoad: false,
		loadStoreRecords: function(ENTRY_YN, DATA_GUBUN) {
			var param = panelResult.getValues();
			if(!Ext.isEmpty(ENTRY_YN)) {
				param.ENTRY_YN = ENTRY_YN;
			}
			if(!Ext.isEmpty(DATA_GUBUN)) {
				param.DATA_GUBUN = DATA_GUBUN;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function() {
			var inValidRecs	= this.getInvalidRecords();
//			var toCreate	= this.getNewRecords();
//			var toUpdate	= this.getUpdatedRecords();
//			var toDelete	= this.getRemovedRecords();
			var paramMaster	= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						gsKeyValue = master.KEY_VALUE;
						directMasterStore.saveStore();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_map200ukrv_wmGrid2');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				directMasterStore2.filterBy(function(record){
					return record.get('COMP_CODE') == 'ZZZZZ';
				})
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(!Ext.isEmpty(record.get('PHONE') && modifiedFieldNames == 'PHONE')) {
					record.set('PHONE', record.get('PHONE').replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3"));
				}
//				this.fnSumAmountI(record);
			},
			remove: function(store, record, index, isMove, eOpts) {
//				this.fnSumAmountI(record);
			}
		},
		fnSumAmountI:function(records, taxInout, grdRecord) {
			var dSumTax			= 0;
			var dSumAmountI		= 0;
			var dSumAmountTot	= 0;
			var dOrderUnitQ		= 0;
			var dOrderUnitP		= 0;
			var dCalAmoutI		= 0;
			var dAmountI		= 0;
			var dTax			= 0;
			var dVatRate		= records[0].get('VAT_RATE');
			var dTaxInout		= Ext.isEmpty(taxInout) ? records[0].get('TAX_INOUT'): taxInout;
			var masterRecord	= grdRecord;

			Ext.each(records, function(record, index, recs){
				dOrderUnitQ	= record.get('ORDER_UNIT_Q');
				dOrderUnitP	= record.get('ORDER_UNIT_P');
				dAmountI	= Unilite.multiply(dOrderUnitQ, dOrderUnitP);

				if(dAmountI == '0'){
					dAmountI = Unilite.multiply(record.get('FOR_AMOUNT_O'), record.get('EXCHG_RATE_O'));
				}

				if(dTaxInout == '1'){
					Math.round(dAmountI, 0);
					dTax		= Unilite.multiply(dAmountI, (dVatRate / 100));
					dSumAmountI	= dSumAmountI + dAmountI;
					Math.round(dTax, 0);
					record.set('AMOUNT_I'	, Math.round(dAmountI, 0));
					record.set('TAX_I'		, fnWonCalcBas(dTax, record.get('WON_CALC_BAS')));
				} else {
					dTemp	= Math.round(dAmountI / ( dVatRate + 100 ) * 100,0);
					dTax	= dAmountI - dTemp;
					Math.round(dTax, 0);
					dTemp	= dAmountI - dTax;
					Math.round(dTemp, 0);
					dSumAmountTot = dSumAmountTot + dAmountI;

					record.set('AMOUNT_I'	, dTemp);
					record.set('TAX_I'		, fnWonCalcBas(dTax, record.get('WON_CALC_BAS')));
				}
				record.set('TOTAL_I', record.get('AMOUNT_I') + record.get('TAX_I'));
			});
			directMasterStore2.fnSumTax(records, grdRecord);
		},
		fnSumTax: function(records, grdRecord) {
			var masterRecord	= grdRecord;
			var dTaxInout		= grdRecord.get('TAX_INOUT');
			var dSumTax			= 0 ;
			var dSumAmountI		= 0;
			var dSumAmountTot	= 0;
			var dTax;
			var dTaxI			= 0;
			Ext.each(records, function(record, index, recs){
				var dVatRate	= record.get('VAT_RATE');
				var dAmountI	= record.get('AMOUNT_I');;

				if(dTaxInout == '1'){
					dTax = record.get('TAX_I');
					dSumAmountI = dSumAmountI + dAmountI;
				} else {
					dTax = record.get('TAX_I');
					dSumAmountTot = dSumAmountTot + dAmountI + dTax;
				}

				dSumTax = dSumTax + dTax;
				Math.round(dSumAmountI	, 0);
				Math.round(dSumAmountTot, 0);
				Math.round(dSumTax		, 0);

				if(dTaxInout == '1'){
					masterRecord.set('AMOUNT_I'		, dSumAmountI);
					masterRecord.set('AMOUNT_TOT'	, dSumAmountI);
				} else {
					masterRecord.set('AMOUNT_TOT'	, dSumAmountTot);
				}

				if(record.get('TAX_I') != ''){
					dTaxI = dTaxI + record.get('TAX_I');
				}
				masterRecord.set('VAT_AMOUNT_O', dTaxI);
	
				if(dTaxInout != '1'){
					masterRecord.set('AMOUNT_I', masterRecord.get('AMOUNT_TOT') - dSumTax);
				}
				masterRecord.set('AMOUNT_TOT', masterRecord.get('VAT_AMOUNT_O') + masterRecord.get('AMOUNT_I'));
			})
		}
	});

	/** Master Grid2 정의(Grid Panel)
	 * @type
	 */
	var masterGrid2 = Unilite.createGrid('s_map200ukrv_wmGrid2', {
		store		: directMasterStore2,
		layout		: 'fit',
		region		: 'south',
		excelTitle	: '<t:message code="system.label.purchase.eachpurchaseslipentry" default="매입지급결의 일괄등록"/>',
		uniOpt		: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [{
			id				: 'masterGrid2SubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id				: 'masterGrid2Total',
			ftype			: 'uniSummary',
			showSummaryRow	: false
		}],
		columns: [
//			{dataIndex: 'SAVE_FLAG'			, width: 100, hidden: false},
//			{dataIndex: 'COMP_CODE'			, width: 100, hidden: false},
//			{dataIndex: 'DIV_CODE'			, width: 100, hidden: false},
//			{dataIndex: 'CUSTOM_CODE'		, width: 100, hidden: false},
//			{dataIndex: 'ORDER_TYPE'		, width: 100, hidden: false},
//			{dataIndex: 'TAX_INOUT'			, width: 100, hidden: false},
//			{dataIndex: 'WON_CALC_BAS'		, width: 100, hidden: false},
//			{dataIndex: 'TAX_TYPE'			, width: 100, hidden: false},
//			{dataIndex: 'EX_DATE'			, width: 100, hidden: false},
//			{dataIndex: 'CHANGE_BASIS_NUM'	, width: 93	, hidden: true},
//			{dataIndex: 'CHANGE_BASIS_SEQ'	, width: 66	, hidden: true},
			{dataIndex: 'INSTOCK_DATE'		, width: 80},
//			{dataIndex: 'ITEM_ACCOUNT'		, width: 66	, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 130},
			{dataIndex: 'TAX_TYPE'			, width: 53	, align: 'center'},
			{dataIndex: 'ORDER_UNIT'		, width: 88	, align: 'center'},
			{dataIndex: 'ORDER_UNIT_Q'		, width: 100},
//			{dataIndex: 'REMAIN_Q'			, width: 80	, hidden: true},
			{dataIndex: 'ORDER_UNIT_P'		, width: 86 },
//			{dataIndex: 'AMOUNT_P'			, width: 100, hidden: true},
			{dataIndex: 'AMOUNT_I'			, width: 100},
			{dataIndex: 'TAX_I'				, width: 80},
			{dataIndex: 'TOTAL_I'			, width: 120},
			{dataIndex: 'CUSTOM_PRSN'		, width: 120},
			{dataIndex: 'PHONE'				, width: 110, hidden: false},
			{dataIndex: 'BANK_NAME'			, width: 100, hidden: false},
			{dataIndex: 'BANK_ACCOUNT'		, width: 130, hidden: false},
			{dataIndex: 'BIRTHDAY'			, width: 100, hidden: false},
			{dataIndex: 'ZIP_CODE'			, width: 100, hidden: false	,
				editor: Unilite.popup('ZIP_G',{
					textFieldName	: 'ZIP_CODE',
					DBtextFieldName	: 'ZIP_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type){
								var grdRecord = masterGrid2.uniOpt.currentRecord;
								grdRecord.set('ADDR1'	, records[0]['ZIP_NAME'] + (Ext.isEmpty(records[0]['ADDR2']) ? '':' ' + records[0]['ADDR2']));
								grdRecord.set('ZIP_CODE', records[0]['ZIP_CODE']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('ADDR1'	, '');
							grdRecord.set('ZIP_CODE', '');
						},
						applyextparam: function(popup){
							var grdRecord	= masterGrid2.uniOpt.currentRecord;
							var paramAddr	= grdRecord.get('ADDR1'); //우편주소 파라미터로 넘기기
							if(Ext.isEmpty(paramAddr)){
								popup.setExtParam({'GBN': 'post'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
							} else {
								popup.setExtParam({'GBN': 'addr'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
							}
							popup.setExtParam({'ADDR': paramAddr});
						}
					}
				})
			},
			{dataIndex: 'ADDR1'				, width: 300, hidden: false},
			{dataIndex: 'ORDER_UNIT_FOR_P'	, width: 133},
			{dataIndex: 'FOREIGN_P'			, width: 100, hidden: true},
			{dataIndex: 'FOR_AMOUNT_O'		, width: 100},
			{dataIndex: 'MONEY_UNIT'		, width: 53	, align: 'center'},
			{dataIndex: 'EXCHG_RATE_O'		, width: 80},
			{dataIndex: 'STOCK_UNIT'		, width: 80	, align: 'center'},
			{dataIndex: 'TRNS_RATE'			, width: 80},
			{dataIndex: 'BUY_Q'				, width: 100},
			{dataIndex: 'ORDER_TYPE'		, width: 66	, align: 'center'},
//			{dataIndex: 'ORDER_PRSN'		, width: 66	, align: 'center', hidden: true},
//			{dataIndex: 'LC_NUM'			, width: 86	, hidden: true},
//			{dataIndex: 'BL_NUM'			, width: 86	, hidden: true},
//			{dataIndex: 'ORDER_NUM'			, width: 93	, hidden: true},
//			{dataIndex: 'ORDER_SEQ'			, width: 33	, hidden: true},
			{dataIndex: 'INOUT_NUM'			, width: 130},
			{dataIndex: 'INOUT_SEQ'			, width: 66	, align: 'center'},
			{dataIndex: 'DIV_CODE'			, width: 33	, hidden: true},
			{dataIndex: 'BILL_DIV_CODE'		, width: 33	, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 33	, hidden: true},
			{dataIndex: 'REMARK'			, width: 133},
			{dataIndex: 'PROJECT_NO'		, width: 133},
			{dataIndex: 'UPDATE_DB_USER'	, width: 33	, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 33	, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 33	, hidden: true},
			{dataIndex: 'ADVAN_YN'			, width: 53	, hidden: true},
			{dataIndex: 'ADVAN_AMOUNT'		, width: 53	, hidden: true},
			{dataIndex: 'PURCHASE_TYPE'		, width: 53	, align: 'center', hidden: true},
			{dataIndex: 'INOUT_TYPE'		, width: 53	, align: 'center', hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['CUSTOM_PRSN', 'PHONE', 'BANK_NAME', 'BANK_ACCOUNT', 'BIRTHDAY', 'ZIP_CODE', 'ADDR1'])){
					return true;
				}
				if(panelResult.getValues().ENTRY_YN == 'N'){
					if(UniUtils.indexOf(e.field, ['TAX_I'])){
							return true;
						} else {
							return false;
						}
				} else {
					return false;
				}
			},
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
				});
			}
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, '');
				grdRecord.set('ITEM_NAME'		, '');
				grdRecord.set('SPEC'			, '');
				grdRecord.set('ORDER_UNIT'		, '');
				grdRecord.set('STOCK_UNIT'		, '');
				grdRecord.set('ORDER_Q'			, 0);
				grdRecord.set('ORDER_P'			, 0);
				grdRecord.set('ORDER_WGT_Q'		, 0);
				grdRecord.set('ORDER_WGT_P'		, 0);
				grdRecord.set('ORDER_VOL_Q'		, 0);
				grdRecord.set('ORDER_VOL_P'		, 0);
				grdRecord.set('ORDER_O'			, 0);
				grdRecord.set('PROD_SALE_Q'		, 0);
				grdRecord.set('PROD_Q'			, 0);
				grdRecord.set('STOCK_Q'			, 0);
				grdRecord.set('DISCOUNT_RATE'	, 0);
				grdRecord.set('WGT_UNIT'		, '');
				grdRecord.set('UNIT_WGT'		, 0);
				grdRecord.set('VOL_UNIT'		, '');
				grdRecord.set('UNIT_VOL'		, 0);
			} else {
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
				grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
				grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
				grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
				grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
				grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
				grdRecord.set('ORDER_NUM'			, panelResult.getValue('ORDER_NUM'));

				UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
			}
		}
	});



	Unilite.Main({
		id			: 's_map200ukrv_wmApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, masterGrid2, panelResult
			]
		}],
		fnInitBinding: function(params){
			UniAppManager.setToolbarButtons(['reset'], true);
			var param = {'DIV_CODE': UserInfo.divCode};
			s_map200ukrv_wmService.billDivCode(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					panelResult.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
				}
			});
			this.setDefault();
		},
		setDefault: function() {
			gsKeyValue	= '';
			gsInitFlag	= true;
			gsInitFlag2	= true;		//20210617 추가: 초기화, reset 시, 집계구분 변경에 따른 조회로직 수행되지 않게 하기 위해 추가
			panelResult.setValue('DIV_CODE'				, UserInfo.divCode);
			panelResult.setValue('INOUT_DATE_FR'		, UniDate.get('startOfMonth'));
			panelResult.setValue('INOUT_DATE_TO'		, UniDate.get('today'));
			panelResult.setValue('BILL_DATE'			, UniDate.get('today'));
			panelResult.setValue('DEPT_CODE'			, UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME'			, UserInfo.deptName);
			panelResult.setValue('CHANGE_BASIS_DATE'	, UniDate.get('today'));
			panelResult.getField('ENTRY_YN').setValue('N');
			//20210617 추가: 데이터 저장 시, 기준이 될 구분 필드 추가
			panelResult.getField('DATA_GUBUN').setValue('1');
//			panelResult.setValue('ISSUE_EXPECTED_DATE'	, UniDate.get('endOfNextMonth'));
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function(ENTRY_YN, DATA_GUBUN){
			if(!panelResult.setAllFieldsReadOnly(true)) {
				return false;
			}
			directMasterStore.loadStoreRecords(ENTRY_YN	, DATA_GUBUN);
			directMasterStore2.loadStoreRecords(ENTRY_YN, DATA_GUBUN);
		},
		onResetButtonDown: function() {
			gsInitFlag	= true;
			gsInitFlag2	= true;		//20210617 추가: 초기화, reset 시, 집계구분 변경에 따른 조회로직 수행되지 않게 하기 위해 추가
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore.loadData({});
			directMasterStore2.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore2.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var queryFlag		= panelResult.getValues().ENTRY_YN;

			if(queryFlag == 'N') {							//미등록일 경우
				var selRow = masterGrid2.getSelectedRecord();
				var grdGrid;
				if(selRow.phantom === true) {
					masterGrid2.deleteSelectedRow();
				} else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					if(directMasterStore2.data.items.length == 1) {
						var masterRecords = masterGrid.getSelectedRecords();
						Ext.each(masterRecords, function(masterRecord, i) {
							if(masterRecord && masterRecord.get('CHANGE_BASIS_NUM') == selRow.get('CHANGE_BASIS_NUM')) {
								directMasterStore.remove(masterRecord);
							}
						});
					} else {
						//detail행 삭제에 따른 master 금액 재계산
						var mGrids	= masterGrid.getStore().data.items;
						Ext.each(mGrids, function(mGrid, i) {
							if(mGrid.get('GROUP_KEY') == selRow.get('GROUP_KEY')) {
								grdGrid = mGrid;
							}
						});
					}
					masterGrid2.deleteSelectedRow();
					var dRecords= masterGrid2.getStore().data.items;
					if(!Ext.isEmpty(grdGrid)) {
						directMasterStore2.fnSumAmountI(dRecords, null, grdGrid);
					}
				}
			} else {
				if(activeGridId == 's_map200ukrv_wmGrid') {
					var selRows = masterGrid.getSelectedRecords();
					if(selRows.phantom === true) {
						masterGrid.deleteSelectedRow();
					} else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						var deleteRecords = new Array();
						var errFlag;
						directMasterStore2.clearFilter();
						var detailRecords = directMasterStore2.data.items;
						Ext.each(selRows, function(selRow, i) {
							if(!Ext.isEmpty(selRow.get('EX_DATE'))) {
								directMasterStore2.filterBy(function(record){
									return record.get('COMP_CODE')			== selRow.get('COMP_CODE')
										&& record.get('DIV_CODE')			== selRow.get('DIV_CODE')
										&& record.get('CHANGE_BASIS_NUM')	== selRow.get('CHANGE_BASIS_NUM')
								});
								errFlag = true;
								return false;
							}
							Ext.each(detailRecords, function(detailRecord, j) {
								if(detailRecord.get('CHANGE_BASIS_NUM') == selRow.get('CHANGE_BASIS_NUM')) {
									deleteRecords.push(detailRecord);
								}
							});
						});
						if(errFlag) {
							Unilite.messageBox('<t:message code="system.message.sales.datacheck014" default="기표 처리된 건에 대해서 수정/삭제할 수 없습니다."/>');
							return false;
						}
						directMasterStore2.remove(deleteRecords);
						masterGrid.deleteSelectedRow();
					}
				} else {
					var selRow = masterGrid2.getSelectedRecord();
					var grdGrid;
					if(!Ext.isEmpty(selRow.get('EX_DATE'))) {
						Unilite.messageBox('<t:message code="system.message.sales.datacheck014" default="기표 처리된 건에 대해서 수정/삭제할 수 없습니다."/>');
						return false;
					}
					if(selRow.phantom === true) {
						masterGrid2.deleteSelectedRow();
					} else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						if(directMasterStore2.data.items.length == 1) {
							var masterRecords = masterGrid.getSelectedRecords();
							Ext.each(masterRecords, function(masterRecord, i) {
								if(masterRecord && masterRecord.get('CHANGE_BASIS_NUM') == selRow.get('CHANGE_BASIS_NUM')) {
									directMasterStore.remove(masterRecord);
								}
							});
						} else {
							//detail행 삭제에 따른 master 금액 재계산
							var mGrids	= masterGrid.getStore().data.items;
							Ext.each(mGrids, function(mGrid, i) {
								if(mGrid.get('CHANGE_BASIS_NUM') == selRow.get('CHANGE_BASIS_NUM')) {
									grdGrid = mGrid;
								}
							});
						}
						masterGrid2.deleteSelectedRow();
						var dRecords= masterGrid2.getStore().data.items;
						if(!Ext.isEmpty(grdGrid)) {
							directMasterStore2.fnSumAmountI(dRecords, null, grdGrid);
						}
					}
				}
			}
		}
/*		onDeleteAllButtonDown: function() {
			var records = directMasterStore2.data.items;
			var isNewData = false;
			gOrderType = directMasterStore2.data.items[0].data.ORDER_TYPE;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						if(deletable){
							masterGrid2.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
						isNewData = false;
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid2.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},*/
	});

	//거래처별 원미만 계산방식에 따라 금액 계산
	function fnWonCalcBas(amount, wonCalcBas){
		var calAmount;
		calAmount = amount;
		if(wonCalcBas == '1'){					//절상
			calAmount = Math.ceil(calAmount);
		} else if(wonCalcBas == '2'){			//절사
			calAmount = Math.floor(calAmount);
		} else {//반올림
			calAmount = Math.round(calAmount);
		}
		return calAmount;
	}

	//계산서일 변경 시, 지급예정일 익월 말일로 set하는 함수 생성
	function fnSetIssueExpectedDate(newValue){
		var tempdate = UniDate.extParseDate(UniDate.getDateStr(UniDate.add(newValue, {months:2})).substring(0, 6) + '01');
		var issueExpectedDate = UniDate.add(tempdate, {days: -1});
		panelResult.setValue('ISSUE_EXPECTED_DATE'	, issueExpectedDate);
	}

	//전화번호 체크로직 추가(안심번호 체크로직  포함)
	function tel_check(str) {
		str = str.replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
		var regTel = /^(050[2-8]{1}|01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
		if(!regTel.test(str)) {
			return false;
		}
		return true;
	}





	Unilite.createValidator('validator00', {
		store	: directMasterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case 'BILL_TYPE':	//계산서 유형
					var param = {
						BILL_TYPE: newValue
					}
					s_map200ukrv_wmService.selectRefCode2(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							record.set('VAT_RATE', provider[0].VAT_RATE);
						}
						directMasterStore2.clearFilter();
						directMasterStore2.filterBy(function(item){
							return record.get('GROUP_KEY') == item.get('GROUP_KEY');
						});
						var dRecords = directMasterStore2.data.items;
						Ext.each(dRecords, function(dRecord, idx) {
							dRecord.set('BILL_TYPE'	, newValue);
							dRecord.set('VAT_RATE'	, provider[0].VAT_RATE);
						});
						directMasterStore2.fnSumAmountI(dRecords, null, record);
					});
					gsCheckFlag = false;				//20210603 추가: 체크박스 로직 구현하기 위해 추가
					break;

				case 'TAX_INOUT':	//세액포함여부
					directMasterStore2.clearFilter();
					directMasterStore2.filterBy(function(item){
						return record.get('GROUP_KEY') == item.get('GROUP_KEY');
					});
					var dRecords = directMasterStore2.data.items;
					Ext.each(dRecords, function(dRecord, idx) {
						dRecord.set('TAX_INOUT', newValue);
					});
					directMasterStore2.fnSumAmountI(dRecords, newValue, record);
					gsCheckFlag = false;				//20210603 추가: 체크박스 로직 구현하기 위해 추가
					break;

				case 'VAT_RATE':	//부가세율
					directMasterStore2.clearFilter();
					directMasterStore2.filterBy(function(item){
						return record.get('GROUP_KEY') == item.get('GROUP_KEY');
					});
					var dRecords = directMasterStore2.data.items;
					Ext.each(dRecords, function(dRecord, idx) {
						dRecord.set('VAT_RATE', newValue);
					});
					directMasterStore2.fnSumAmountI(dRecords, null, record);
					gsCheckFlag = false;				//20210603 추가: 체크박스 로직 구현하기 위해 추가
					break;

				case 'ISSUE_EXPECTED_DATE':	//지급예정일
					gsCheckFlag = false;				//20210603 추가: 체크박스 로직 구현하기 위해 추가
					break;
			}
			return rv;
		}
	});

	Unilite.createValidator('validator01', {
		store	: directMasterStore2,
		grid	: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
/*				case "ORDER_UNIT_Q" :	//매입수량
					if(newValue <= '0'){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/> ';
						break;
					} else if(newValue > record.get('REMAIN_Q')){
						var a = record.get('REMAIN_Q');
						rv= '<t:message code="system.message.purchase.message082" default="매입가능수량을 초과하였습니다."/>' + '<t:message code="system.message.purchase.message083" default="매입잔량을 확인하십시오."/>' +
							'<t:message code="system.label.purchase.purchaseavailableqty" default="매입가능수량"/>' + ':' + a;
						break;
					}

					record.set('AMOUNT_I', newValue * record.get('ORDER_UNIT_P'));
					record.set('BUY_Q', newValue * record.get('TRNS_RATE'));

					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('FOREIGN_P',record.get('AMOUNT_P') / record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_FOR_P',record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
						record.set('FOR_AMOUNT_O',newValue * record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
					} else {
						record.set('FOR_AMOUNT_O','0');
						record.set('FOREIGN_P','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}
					directMasterStore2.fnSumAmountI(e.store.data.items, null, grdGrid);
					break;

				case "ORDER_UNIT_P":
					if(newValue <= '0'){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					record.set('AMOUNT_I',record.get('ORDER_UNIT_Q')* newValue);

					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('FOREIGN_P',record.get('AMOUNT_P') / record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_FOR_P',record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
						record.set('FOR_AMOUNT_O',record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
					} else {
						record.set('FOR_AMOUNT_O','0');
						record.set('FOREIGN_P','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}
					directMasterStore2.fnSumAmountI(e.store.data.items, null, grdGrid);
					break;

				case "AMOUNT_I" :
					if(record.get('ORDER_UNIT_Q') > ''){
						if(record.get('ORDER_UNIT_Q') > '0' && newValue <= '0'){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						} else if(record.get('ORDER_UNIT_Q') < '0' && newValue >= '0'){
							rv='<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
							break;
						}
					}
					if(newValue > record.get('REMAIN_Q') * record.get('AMOUNT_P')){

						var a = record.get('REMAIN_Q');
						rv='<t:message code="system.message.purchase.message082" default="매입가능수량을 초과하였습니다."/>' + '<t:message code="system.message.purchase.message083" default="매입잔량을 확인하십시오."/>' +
						 '<t:message code="system.label.purchase.purchaseavailableqty" default="매입가능수량"/>' + ':' + a;
						break;
					}

					if(record.get('ADVAN_YN') == 'Y' || record.get('ADVAN_YN') > record.get('ADVAN_AMOUNT')){
						record.set('ORDER_UNIT_Q', record.get('AMOUNT_I') / record.get('ORDER_UNIT_P'));
						record.set('BUY_Q',record.get('ORDER_UNIT_Q'));
					}
					record.set('AMOUNT_I',newValue);

					if(record.get('ADVAN_YN') != 'Y' && record.get('ADVAN_AMOUNT') == '0'){
						if(record.get('BUY_Q') != '0'){
							record.set('AMOUNT_P', record.get('AMOUNT_I') / record.get('BUY_Q'));

							record.set('ORDER_UNIT_P', record.get('AMOUNT_I') / record.get('ORDER_UNIT_Q'));
						} else {
							record.set('AMOUNT_P','0');
							record.set('ORDER_UNIT_P','0');
						}
					}

					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('FOREIGN_P',record.get('AMOUNT_P') / record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_FOR_P', record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
						record.set('FOR_AMOUNT_O', record.get('AMOUNT_I') / record.get('EXCHG_RATE_O'));
					} else {
						record.set('FOR_AMOUNT_O','0');
						record.set('FOREIGN_P','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}
					directMasterStore2.fnSumAmountI(e.store.data.items);
					break;

				case "ORDER_UNIT_FOR_P" :
					if(newValue <= '0'){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}

					record.set('FOREIGN_P',newValue / record.get('TRNS_RATE'));
					record.set('FOR_AMOUNT_O',record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P'));

					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('AMOUNT_P',record.get('FOREIGN_P') * record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_P',record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O'));
						record.set('AMOUNT_I',record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P'));
					} else {
						record.set('INOUT_O','0');
						record.set('AMOUNT_P','0');
						record.set('ORDER_UNIT_P','0');
					}
					directMasterStore2.fnSumAmountI(e.store.data.items);
					break;

				case "FOR_AMOUNT_O" :
					if(record.get('ORDER_UNIT_Q') != ''){
						if(newValue <= '0' && record.get('ORDER_UNIT_Q') > '0'){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						} else if(newValue >= '0' && record.get('ORDER_UNIT_Q') < '0'){
							rv='<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
							break;
						}
					}
					if(record.get('BUY_Q') != '0'){
						record.set('FOREIGN_P', record.get('FOR_AMOUNT_O') / record.get('BUY_Q'));
						record.set('ORDER_UNIT_FOR_P',record.get('FOR_AMOUNT_O') / record.get('ORDER_UNIT_Q'))
					} else {
						record.set('FOREIGN_P','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}

					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('AMOUNT_P', record.get('FOREIGN_P') * record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_P', record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O'));
						record.set('AMOUNT_I', record.get('FOR_AMOUNT_O') * record.get('EXCHG_RATE_O'));
					} else {
						record.set('INOUT_O','0');
						record.set('AMOUNT_P','0');
						record.set('ORDER_UNIT_P','0');
					}
					directMasterStore2.fnSumAmountI(e.store.data.items);
					break;*/

				case "TAX_I" :
					if(record.get('ORDER_UNIT_Q') > ''){
						if(record.get('ORDER_UNIT_Q') > '0' && newValue <= '0'){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}
					} else if(record.get('ORDER_UNIT_Q') < '0' && newValue >= '0'){
						rv='<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
						break;
					}
					var	dAmountI;

					if(record.get('AMOUNT_I') == ''){
						dAmountI = 0;
					} else {
						dAmountI = record.get('AMOUNT_I');
					}
					var dTaxI = newValue;

					if(dAmountI > 0){
						if(dAmountI < dTaxI){
							rv='<t:message code="system.message.purchase.message084" default="세액은 공급가액보다 작아야 합니다."/>';
							break;
						}
					} else {
						if(dAmountI > dTaxI){
							rv='<t:message code="system.message.purchase.message085" default="세액은 공급가액보다 커야 합니다."/>';
							break;
						}
					}
					dTaxI = Math.round(dTaxI, record.get('WON_CALC_BAS'));
					record.set('TOTAL_I', newValue + record.get('AMOUNT_I'));

					var grdGrid;
					var mGrids = masterGrid.getStore().data.items;
					Ext.each(mGrids, function(mGrid, i) {
						if(mGrid.get('GROUP_KEY') == record.get('GROUP_KEY')) {
							grdGrid = mGrid;
						}
					});
					grdGrid.set('VAT_AMOUNT_O'	, grdGrid.get('VAT_AMOUNT_O') + newValue - oldValue);
					grdGrid.set('AMOUNT_TOT'	, grdGrid.get('AMOUNT_TOT') + newValue - oldValue);
					break;

				//20210222 추가: 전화번호 입력 시, 전화번호 유효성 체크로직 추가
				case "PHONE" :
					if(!Ext.isEmpty(newValue)) {
						if(!tel_check(newValue)) {
							rv = '올바른 전화번호를 입력하세요.'
							record.set('PHONE', oldValue);
							break;
						}
					}
					break;
			}
			return rv;
		}
	});
};
</script>