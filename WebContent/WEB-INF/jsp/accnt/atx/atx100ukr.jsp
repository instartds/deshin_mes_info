<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx100ukr">
	<t:ExtComboStore comboType="BOR120"/>				 <!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120" comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A003"/>								<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022"/>								<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A081"/>								<!-- 부가세조정 입력구분 -->
	<t:ExtComboStore items="${reasonGbList}" storeId="reasonGbList"/>				<!-- 매입세액불공제사유 A070, ref_code3 != N -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>								<!-- 주영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="A149"/>								<!-- 전자발행여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"/>								<!-- YES/NO (매수제외필드) -->
	<t:ExtComboStore comboType="AU" comboCode="A156"/>								<!-- 부가세생성경로 -->
	<t:ExtComboStore comboType="AU" comboCode="A011"/>								<!-- 입력경로 -->
	<t:ExtComboStore comboType="AU" comboCode="A235"/>								<!-- 부가세체크유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A084"/>
	<t:ExtComboStore comboType="AU" comboCode="A110"/>								<!-- 휴폐업여부 -->

<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>

<script type="text/javascript" >
var useColList		= ${useColList};
var linkId			= ${linkId};
var beforeSlipAlert	= '';

var BsaCodeInfo = {
	useLinkYn	: '${useLinkYn}',
	sortNumber	: '${sortNumber}',
	moneyUnit	: '${moneyUnit}'
};
var linkPgmId	= '';
var taxControl	= true;


function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'atx100ukrService.selectList',
			update	: 'atx100ukrService.updateDetail',
			create	: 'atx100ukrService.insertDetail',
			destroy	: 'atx100ukrService.deleteDetail',
			syncAll	: 'atx100ukrService.saveAll'
		}
	});

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx100ukrModel', {
		fields: [
			{name: 'sReflectinSlipAlert'	, text: 'sReflectinSlipAlert'	,type: 'string'},
			{name: 'sReflectinSlip'			, text: 'sReflectinSlip'		,type: 'string'},
			{name: 'REF_CODE3'				, text: 'REF_CODE3'				,type: 'string'},
			{name: 'REF_CODE1'				, text: 'REF_CODE1'				,type: 'string'},
			{name: 'COMP_CODE'				, text: '법인코드'					,type: 'string',allowBlank:false},
			{name: 'PUB_DATE'				, text: '계산서일'					,type: 'uniDate',allowBlank:false},
			{name: 'TX_NUM'					, text: '순번'					,type: 'string'/*,allowBlank:false*/},
			{name: 'CUSTOM_CODE'			, text: '거래처'					,type: 'string',maxLength:8,allowBlank:false},
			{name: 'CUSTOM_NAME'			, text: '거래처명'					,type: 'string',maxLength:30},
			{name: 'COMPANY_NUM'			, text: '사업자번호'					,type: 'string',maxLength:10,allowBlank:true},		//수동으로 필수 체크
			{name: 'R_CUSTOM_GUBUN'			, text: '휴폐업여부'					,type: 'string',comboType:'AU', comboCode:'A110'},
			{name: 'INOUT_DIVI'				, text: '구분'					,type: 'string',comboType:'AU', comboCode:'A003',allowBlank:false},
			{name: 'PROOF_KIND'				, text: '증빙유형'					,type: 'string',maxLength:2,comboType:'AU', comboCode:'A022'/*store: Ext.data.StoreManager.lookup('atx100ukrProofKindStore')*/,allowBlank:false},
			{name: 'PROOF_KIND_NM'			, text: '증빙유형NM'				,type: 'string'},
			{name: 'SUPPLY_AMT_I'			, text: '공급가액'					,type: 'uniPrice',maxLength:30},
			{name: 'TAX_AMT_I'				, text: '세액'					,type: 'uniPrice',maxLength:30},
			{name: 'TOT_AMT_I'				, text: '합계'					,type: 'uniPrice'},
			{name: 'BILL_DIVI_CODE'			, text: '신고사업장'					,type: 'string',maxLength:40, comboType:'BOR120', comboCode: 'BILL',allowBlank:false},
			{name: 'DIV_CODE'				, text: '귀속사업장'					,type: 'string',maxLength:40,comboType:'BOR120',allowBlank:false},
			{name: 'ORG_ACCNT'				, text: '본계정코드'					,type: 'string'},
			{name: 'ORG_ACCNT_NAME'			, text: '본계정명'					,type: 'string'},
			{name: 'BIZ_GUBUN'				, text: '수입구분'					,type: 'string'},
			{name: 'BIZ_GUBUN_NAME'			, text: '수입구분명'					,type: 'string'},
			{name: 'AC_DATE'				, text: '전표일'					,type: 'uniDate',allowBlank:false},
			{name: 'SLIP_NUM'				, text: '전표번호'					,type: 'string',maxLength:7,allowBlank:false},
			{name: 'SLIP_SEQ'				, text: '전표순번'					,type: 'string',maxLength:5,allowBlank:false},
			{name: 'DEPT_CODE'				, text: '귀속부서코드'				,type: 'string'},
			{name: 'DEPT_NAME'				, text: '귀속부서명'					,type: 'string'},
			{name: 'REMARK'					, text: '적요'					,type: 'string',maxLength:80},
			{name: 'PORT_YN'				, text: '신고여부'					,type: 'string'},
			{name: 'INPUT_PATH'				, text: '입력경로'					,type: 'string',comboType:'AU', comboCode:'A011',allowBlank:false},
			{name: 'INPUT_DIVI'				, text: '입력구분'					,type: 'string',maxLength:1,comboType:'AU', comboCode:'A081',allowBlank:false},
			{name: 'PUB_PATH'				, text: '생성경로'					,type: 'string',comboType:'AU', comboCode:'A156'},
			{name: 'CREDIT_CODE'			, text: 'CREDIT_CODE'			,type: 'string'},
			{name: 'REASON_CODE'			, text: '매입불공제사유'				,type: 'string',	store:Ext.data.StoreManager.lookup("reasonGbList")},
			{name: 'CREDIT_NUM'				, text: '신용카드/현금영수증번호(DB)'		,type: 'string'},
			{name: 'CREDIT_NUM_EXPOS'		, text: '신용카드/현금영수증번호'			,type: 'string',maxLength:20, defaultValue:'***************'},
			{name: 'EB_YN'					, text: '전자발행여부'				,type: 'string',comboType:'AU', comboCode:'A149',allowBlank:false},
			{name: 'MONEY_UNIT'				, text: 'MONEY_UNIT'			,type: 'string'},
			{name: 'EXCHG_RATE_O'			, text: 'EXCHG_RATE_O'			,type: 'uniER'},
			{name: 'TAXNO_YN'				, text: '매수포함여부'				,type: 'string',comboType:'AU', comboCode:'A020',allowBlank:false},
			{name: 'AUTO_SLIP_NUM'			, text: '지출/수입번호'				,type: 'string'},
			{name: 'EX_DATE'				, text: '결의일자'					,type: 'uniDate'},
			{name: 'EX_NUM'					, text: '결의번호'					,type: 'string'},
			{name: 'INSERT_DB_TIME'			, text: 'INSERT_DB_ITME'		,type: 'string'},
			{name: 'INSERT_DB_USER'			, text: 'INSERT_DB_USER'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '수정일'					,type: 'string'},
			{name: 'UPDATE_DB_USER'			, text: 'UPDATE_DB_USER'		,type: 'string'},
//			{name: 'BIGO'					, text: '비고'					,type: 'string'},
			{name: 'NEW_PUB_DATE'			, text: '계산서일 변경관련'				,type: 'string'},
			{name: 'PUB_DATE_DUMMY'			, text: '계산서일 DUMMY'				,type: 'string'},
			{name: 'ASST_SUPPLY_AMT_I'		, text:'고정자산과표'					,type: 'uniPrice', defaultValue:0},
			{name: 'ASST_TAX_AMT_I'			, text:'고정자산세액'					,type: 'uniPrice', defaultValue:0},
			{name: 'ASST_DIVI'				, text:'자산구분'					,type: 'string',comboType:'AU', comboCode:'A084'},
			{name: 'CHK_GUBUN'				, text: '부가세CHECK'				,type: 'string',comboType:'AU', comboCode:'A235'}
		]
	});

/*	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}*/

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('atx100ukrdirectMasterStore',{
		model	: 'Atx100ukrModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		 // 상위 버튼 연결 
			editable	: true,		 // 수정 모드 사용 
			deletable	: true,		 // 삭제 가능 여부 
			useNavi		: false		 // prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function() {
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
			var rv = true;
			if(inValidRecs.length == 0 ) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						directMasterStore.loadStoreRecords();
						beforeSlipAlert = '';
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var viewNormal = masterGrid.normalGrid.getView();
				var viewLocked = masterGrid.lockedGrid.getView();
				if(store.getCount() > 0){
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
				} else{
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(record.get('INPUT_DIVI') == '1'){
					record.set('sReflectinSlip', 'Y');
				}
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '검색조건',
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
		items		: [{
			title		: '기본정보',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel		: '계산서일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'txtFrDate',
				endFieldName	: 'txtToDate',
				allowBlank		: false,
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('txtFrDate',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('txtToDate',newValue);
					}
				}
			},{
				fieldLabel	: '매입/매출구분',
				name		: 'txtDivi',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A003',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('txtDivi', newValue);
						//ProofKindStore.loadStoreRecords(field.store);
						panelResult.setValue('txtProofKind', '');
						panelSearch.setValue('txtProofKind', '');
					}
				}
			},{
				fieldLabel	: '신고사업장',
				name		: 'txtOrgCd',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120' ,
				comboCode	: 'BILL',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('txtOrgCd', newValue);
					}
				}
			},{
				fieldLabel	: '증빙유형',
				name		: 'txtProofKind',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A022',
				width		: 315,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('txtProofKind', newValue);
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						if(panelSearch.getValue('txtDivi') != null){
							store.filterBy(function(record){
								return record.get('refCode3') == panelSearch.getValue('txtDivi');
							})
						}
					}
				}  
			},
			Unilite.popup('CUST',{
				fieldLabel		: '거래처',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,
				valueFieldName	: 'txtCustom',
				textFieldName	: 'txtCustomName',
				listeners		: {
								onValueFieldChange:function( elm, newValue, oldValue) {						
									panelResult.setValue('txtCustom', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('txtCustomName', '');
										panelSearch.setValue('txtCustomName', '');
									}
								},
								onTextFieldChange:function( elm, newValue, oldValue) {
									panelResult.setValue('txtCustomName', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('txtCustom', '');
										panelSearch.setValue('txtCustom', '');
									}
								}
				}
			}),{
				fieldLabel	: '사업자번호',
				name		:'txtCompanyNum',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('txtCompanyNum', newValue);
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '전자발행여부',
				id			: 'rdoSelect1',
				items		: [{
					boxLabel	: '전체', 
					width		: 70, 
					name		: 'EbNm',
					inputValue	: '',
					checked		: true
				},{
					boxLabel	: '발행', 
					width		: 70,
					name		: 'EbNm',
					inputValue	: 'Y'
				},{
					boxLabel	: '미발행', 
					width		: 70, 
					name		: 'EbNm',
					inputValue	: 'N' 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						/*if(!UniAppManager.app.checkForNewDetail()){
							return false;
						} else{
							directMasterStore.loadStoreRecords();
						}*/
						panelResult.getField('EbNm').setValue(newValue.EbNm);
					}
				}
			},{
				fieldLabel	: '귀속사업장',
				name		: 'txtDivCode',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('txtDivCode', newValue);
					}
				}
			}]
		},{
			title		: '추가정보',  
			itemId		: 'search_panel2',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel		: '전표일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'txtAcFrDate',
				endFieldName	: 'txtAcToDate',
				width			: 315
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 3},
				width	: 600,
				items	: [{
					fieldLabel	: '전표번호',
					xtype		: 'uniNumberfield',
					name		: 'txtFrSlipNum', 
					width		: 195
				},{
					xtype	: 'component', 
					html	: '~',
					style	: {
						marginTop	: '3px !important',
						font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel	: '', 
					xtype		: 'uniNumberfield',
					name		: 'txtToSlipNum', 
					width		: 110
				}]
			},{
				fieldLabel	: '주영업담당',
				name		: 'txtBusyPrsn',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010'
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 3},
				width	: 600,
				items	: [{
					fieldLabel	: '금액', 
					xtype		: 'uniNumberfield',
					name		: 'txtFrAmt', 
					width		: 195
			   },{
					xtype	: 'component', 
					html	: '~',
					style	: {
						marginTop	: '3px !important',
						font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel	: '', 
					xtype		: 'uniNumberfield',
					name		: 'txtToAmt', 
					width		: 110
				}]
			},{
				fieldLabel	: '생성경로',
				name		: 'txtPubPath',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A156'  
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '금액구분',
				id			: 'rdoSelect',
				items		: [{
					boxLabel	: '공급가액', 
					width		: 70, 
					name		: 'SorGbn',
					inputValue	: '1',
					checked		: true  
				},{
					boxLabel	: '세액', 
					width		: 70,
					name		: 'SorGbn',
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!UniAppManager.app.checkForNewDetail()){
							return false;
						} else{
							directMasterStore.loadStoreRecords();
						}
					}
				}
			},{
				fieldLabel	: '입력경로',
				name		: 'txtInputPath',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A011'
			},{
				fieldLabel	: '입력구분',
				name		: 'txtInputDivi',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A081'
			},{
				fieldLabel	: '적요',
				name		: 'txtRemark',
				xtype		: 'uniTextfield'
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '증빙그룹',
				id			: 'rdoSelect2',
				columns		: 2,
				items		: [{
					boxLabel	: '전체', 
					width		: 55, 
					name		: 'BillGbn',
					inputValue	: '',
					checked		: true  
				},{
					boxLabel	: '세금계산서', 
					width		: 90,
					name		: 'BillGbn',
					inputValue	: '1'
				},{
					boxLabel	: '계산서', 
					width		: 70, 
					name		: 'BillGbn',
					inputValue	: '2' 
				},{
					boxLabel	: '매입자발행세금계산서', 
					width		: 300, 
					name		: 'BillGbn',
					inputValue	: '3'
				},{
					boxLabel	: '신용카드', 
					width		: 80, 
					name		: 'BillGbn',
					inputValue	: '4'
				},{
					boxLabel	: '현금영수증', 
					width		: 80,
					name		: 'BillGbn',
					inputValue	: '5'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!UniAppManager.app.checkForNewDetail()){
							return false;
						} else{
							directMasterStore.loadStoreRecords();
						}
					}
				}
			},{
				xtype		: 'uniCheckboxgroup',
				padding		: '0 0 0 0',
				fieldLabel	: '선택',
				id			: 'chkBox',
				items		: [{
					boxLabel		: '증빙유형이 불공제만 조회',
					width			: 170,
					name			: 'ChkDed',
					inputValue		: 'Y',
					uncheckedValue	: 'N'
				}]
			},{
				fieldLabel	: '불공제사유',
				name		: 'cboReasonCode',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup("reasonGbList") 
			},{
				xtype		: 'radiogroup',
				fieldLabel	: 'SORT순서',
				id			: 'rdoSelect5',
				columns		: 1,
				items		: [{
					boxLabel	: '계산서일,사업자번호,거래처명순', 
					width		: 325, 
					name		: 'SortGbn',
					inputValue	: '1',
					checked		: true  
				},{
					boxLabel	: '계산서일,전표일,번호,순번순', 
					width		: 325,
					name		: 'SortGbn',
					inputValue	: '2'
				},{
					boxLabel	: '사업자번호,계산서일순', 
					width		: 325, 
					name		: 'SortGbn',
					inputValue	: '3',
					listeners	: {
						specialkey: function(field, event){
							if(event.getKey() == event.ENTER){
								UniAppManager.app.onQueryButtonDown();
							}
						}
					}
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!UniAppManager.app.checkForNewDetail()){
							return false;
						} else{
							directMasterStore.loadStoreRecords();
						}
					}
				}
			}]
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )   {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)   {
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
					if(Ext.isDefined(item.holdable) )   {
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
	}); //end panelSearch

	var panelResult = Unilite.createSearchForm('panelResultForm', {	 
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4
//		tdAttrs	: {style: 'border : 1px solid #ced9e7;',width: '100%'/*,align : 'left'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
			fieldLabel		: '계산서일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'txtFrDate',
			endFieldName	: 'txtToDate',
			allowBlank		: false,
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('txtFrDate',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('txtToDate',newValue);
				}
			}
		},{
			fieldLabel	: '매입/매출구분',
			name		: 'txtDivi', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A003',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('txtDivi', newValue);
					//proofKindStore.loadStoreRecords(field.store);
					panelResult.setValue('txtProofKind', '');
					panelSearch.setValue('txtProofKind', '');
				}
			}
		},{
			fieldLabel	: '신고사업장',
			name		:'txtOrgCd',
			xtype		: 'uniCombobox',
			comboType	:'BOR120',
			comboCode	: 'BILL',
			colspan		:2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('txtOrgCd', newValue);
				}
			}
		},{
			fieldLabel	: '증빙유형',
			name		: 'txtProofKind',
			xtype		: 'uniCombobox',
			//store		: proofKindStore,
			comboType	: 'AU',
			comboCode	: 'A022',
			width		: 315,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('txtProofKind', newValue);
				},
				beforequery:function(queryPlan, eOpt)   {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(panelSearch.getValue('txtDivi') != null){
						store.filterBy(function(record){
							return record.get('refCode3') == panelSearch.getValue('txtDivi');
						})
					}
				}
			}	
		},
		Unilite.popup('CUST',{
			fieldLabel		: '거래처',
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,
			valueFieldName	: 'txtCustom',
			textFieldName	: 'txtCustomName',
			listeners		: {
								onValueFieldChange:function( elm, newValue, oldValue) {						
									panelSearch.setValue('txtCustom', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('txtCustomName', '');
										panelSearch.setValue('txtCustomName', '');
									}
								},
								onTextFieldChange:function( elm, newValue, oldValue) {
									panelSearch.setValue('txtCustomName', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('txtCustom', '');
										panelSearch.setValue('txtCustom', '');
									}
								}
			}
		}),{
			fieldLabel	: '사업자번호',
			name		: 'txtCompanyNum',
			xtype		: 'uniTextfield',
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('txtCompanyNum', newValue);
				},
				specialkey: function(field, event){
					if(event.getKey() == event.ENTER){
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '전자발행여부',
			id			: 'rdoSelect3',
			items		: [{
				boxLabel	: '전체', 
				width		: 70, 
				name		: 'EbNm',
				inputValue	: '',
				checked		: true  
			},{
				boxLabel	: '발행', 
				width		: 70,
				name		: 'EbNm',
				inputValue	: 'Y'
			},{
				boxLabel	: '미발행', 
				width		: 70, 
				name		: 'EbNm',
				inputValue	: 'N' 
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					/*if(!UniAppManager.app.checkForNewDetail()){
						return false;
					} else{
						directMasterStore.loadStoreRecords();
					}*/
					panelSearch.getField('EbNm').setValue(newValue.EbNm);
				}
			}
		},{
			fieldLabel	: '귀속사업장',
			name		: 'txtDivCode',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('txtDivCode', newValue);
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 1},
			tdAttrs	: {align : 'right', width: '100%'},
//			layout	: {type : 'uniTable', columns : 1,align : 'right'},
			width	: 120,
//			defaults: {enforceMaxLength: true},
//			tdAttrs	: {align : 'right',tableAttrs: {style: 'border : 1px solid #ced9e7;',width: '100%'/*,align : 'left'*/}},
			items	: [{
				xtype		: 'component',
				html		: '휴폐업조회',
				hidden		: true,
				width		: 110, 
				tdAttrs		: {align : 'center'},
				componentCls: 'component-text_first',
				listeners	: {
					render: function(component) {
						component.getEl().on('click', function( event, el ) {
							UniAppManager.app.fnOpenSlip();
						});
					}
				}
			}]
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )   {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)   {
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

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('atx100ukrGrid', {
		store	: directMasterStore,
		region	: 'center',
//		enableColumnHide : false, //그리드 hidden 컬럼들 선택 못하도록 하이드 옵션
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
			copiedRow			: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		tbar	: [{
			xtype	: 'button',
			text	: '신고사업장 일괄변경',
			handler	: function() {
				if(confirm('신고사업장을 귀속사업장과 동일하게 일괄 변경하시겠습니까?')) {
					var records = directMasterStore.data.items;
					Ext.each(records, function(record, index){
						record.set('BILL_DIVI_CODE', record.get('DIV_CODE'));
					});
				}
			}
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbseparator'
		},{
			xtype: 'tbspacer'
		},{
			xtype	: 'button',
			text	: '발행',
			width	: 80,
			handler	: function() {
				var records = directMasterStore.data.items;
				Ext.each(records,  function(record, index){
					if(record.get('INPUT_PATH') != '34'){
//						record.set('EB_YN','');
						record.set('EB_YN','Y');
					}
				});
			}
		},{
			xtype	: 'button',
			text	: '미발행',
			width	: 80,
			handler	: function() {
				var records = directMasterStore.data.items;
				Ext.each(records,  function(record, index){
					if(record.get('INPUT_PATH') != '34'){
//						record.set('EB_YN','');
						record.set('EB_YN','N');
					}
				});
			}
		},{ 
			itemId	: 'linkPayInDtlBtn',
			id		: 'linkPayInDtlBtn',
			text	: '지출/수입결의조회',
			handler	: function() {
				var params = {
//						: record.get(''),
//					추후 링크 사용시 추가 필요
				}
				var rec = {data : {prgID : linkPgmId}};
				parent.openTab(rec, '/accnt/'+linkPgmId+'.do', params); 
			}
		}],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns	: [
//			{dataIndex: 'sReflectinSlipAlert'	, width: 100 ,hidden:false},
//			{dataIndex: 'sReflectinSlip'		, width: 100 ,hidden:false},
			{dataIndex: 'COMP_CODE'				, width: 100 ,hidden:true},
//			{dataIndex: 'NEW_PUB_DATE'			, width: 100 },
//			{dataIndex: 'PUB_DATE_DUMMY'		, width: 100 },
			{dataIndex: 'PUB_DATE'				, width: 100, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
				}
			},
			{dataIndex: 'TX_NUM'				, width: 100 , align:'center',hidden:true},
			{dataIndex: 'CUSTOM_CODE'			, width: 70, locked: true,
				editor: Unilite.popup('CUST_G',{
					textFieldName	: 'CUSTOM_CODE',
					DBtextFieldName	: 'CUSTOM_CODE',
					autoPopup		: true,
					extParam		: {'CUSTOM_TYPE': ['1','2','3']},
					listeners		: { 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('COMPANY_NUM',records[0]['COMPANY_NUM'].split("-").join(''));
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						},
						//20200618 추가
						applyextparam: function(popup){
							popup.setExtParam({'CUSTOM_TYPE': ['1','2','3']});
						}
					}
				})
			},		
			{dataIndex: 'CUSTOM_NAME'			, width: 250, locked: true,
				editor: Unilite.popup('CUST_G',{
//					textFieldName: 'CUSTOM_CODE',
//					DBtextFieldName: 'CUSTOM_CODE',
					extParam	: {'CUSTOM_TYPE': ['1','2','3']},
					autoPopup	: true,
					listeners	: { 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('COMPANY_NUM',records[0]['COMPANY_NUM'].split("-").join(''));
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						},
						//20200618 추가
						applyextparam: function(popup){
							popup.setExtParam({'CUSTOM_TYPE': ['1','2','3']});
						}
					}
				})
			},
			{dataIndex: 'COMPANY_NUM'			, width: 100, align:'center'/*,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					return (val.substring(0,3) + '-' + val.substring(3,5) + '-' + val.substring(5,10));
				}*/
			},		
			{dataIndex: 'R_CUSTOM_GUBUN'		, width: 100, align:'center', hidden:true},
			{dataIndex: 'INOUT_DIVI'			, width: 66, align:'center'},
			{dataIndex: 'PROOF_KIND'			, width: 180,
				listeners:{
					render:function(elm) {
						var tGrid = elm.getView().ownerGrid;
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var grid = tGrid;
							var record = grid.uniOpt.currentRecord;
							var store = queryPlan.combo.store;
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('refCode3') == record.get('INOUT_DIVI');
							})
							/*var store = queryPlan.combo.getStore();
							console.log('propKind',store);
							store.gridRoadStoreRecords({
								"txtDivi" : record.get('INOUT_DIVI')
							}, store);*/
						});
						elm.editor.on('collapse',function(combo,  eOpts ) {
							var store = combo.store;
							store.clearFilter();
						});
					}
				}
			},		
//			{dataIndex: 'PROOF_KIND_NM'			, width: 150 },		
			{dataIndex: 'SUPPLY_AMT_I'			, width: 120 ,summaryType: 'sum'},
			{dataIndex: 'TAX_AMT_I'				, width: 120 ,summaryType: 'sum'},
			{dataIndex: 'TOT_AMT_I'				, width: 150 ,summaryType: 'sum'},
			{dataIndex: 'ASST_SUPPLY_AMT_I'		, width: 120 ,summaryType: 'sum'},
			{dataIndex: 'ASST_TAX_AMT_I'		, width: 120 ,summaryType: 'sum'},
			{dataIndex: 'ASST_DIVI'				, width: 100 },
			{dataIndex: 'BILL_DIVI_CODE'		, width: 120 },
			{dataIndex: 'DIV_CODE'				, width: 120 },
			//{dataIndex: 'ORG_ACCNT'			, width: 100 }, 
			//{dataIndex: 'ORG_ACCNT_NAME'		, width: 100 }, 
			//{dataIndex: 'BIZ_GUBUN'			, width: 100 }, 
			//{dataIndex: 'BIZ_GUBUN_NAME'		, width: 100 }, 
			{dataIndex: 'AC_DATE'				, width: 100 },
			{dataIndex: 'SLIP_NUM'				, width: 80 , align:'center'},
			{dataIndex: 'SLIP_SEQ'				, width: 80 , align:'center'},
			{dataIndex: 'DEPT_CODE'				, width: 100 }, 
			{dataIndex: 'DEPT_NAME'				, width: 100 },
			{dataIndex: 'REMARK'				, width: 250 },
			{dataIndex: 'PORT_YN'				, width: 100 , align:'center',hidden:true},
			{dataIndex: 'INPUT_PATH'			, width: 100 , align:'center'},
			{dataIndex: 'INPUT_DIVI'			, width: 80  , align:'center'},
			{dataIndex: 'PUB_PATH'				, width: 80  , align:'center'},
			{dataIndex: 'CREDIT_CODE'			, width: 100 , hidden:true},
			{dataIndex: 'REASON_CODE'			, width: 250 },
			{dataIndex: 'CREDIT_NUM'			, width: 180 , hidden:true
//				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
//					if(record.get('REF_CODE3') == '1' && record.get('REF_CODE1') == 'F'){
//						return val; 
//					} else{
//						if(!Ext.isEmpty(val)){
//							return (val.substring(0,4) + '-' + val.substring(4,8) + '-' + val.substring(8,12) + '-' + val.substring(12));
//						}
//					}
//				}
			},
//			SET @DecData = SUBSTRING(@DecData, 1, 4) + '-'+ SUBSTRING(@DecData, 5, 4) +'-'+SUBSTRING(@DecData, 9, 4)+'-'+ SUBSTRING(@DecData, 13, 4)
			{dataIndex: 'CREDIT_NUM_EXPOS'		, width: 200 , align:'center'},
			{dataIndex: 'EB_YN'					, width: 100 , align:'center'},
			{dataIndex: 'MONEY_UNIT'			, width: 100 , hidden:true},
			{dataIndex: 'EXCHG_RATE_O'			, width: 100 , hidden:true},
			{dataIndex: 'TAXNO_YN'				, width: 100 , align:'center'},
			{dataIndex: 'AUTO_SLIP_NUM'			, width: 100 },
			{dataIndex: 'EX_DATE'				, width: 100 , align:'center' },
			{dataIndex: 'EX_NUM'				, width: 100 , align:'center' },
			{dataIndex: 'INSERT_DB_TIME'		, width: 100 , hidden:true},
			{dataIndex: 'INSERT_DB_USER'		, width: 100 , hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 130 , hidden:false},
			{dataIndex: 'UPDATE_DB_USER'		, width: 100 , hidden:true}
//			{dataIndex: 'CHK_GUBUN'				, width: 100 , align:'center' }
//			{dataIndex: 'BIGO'					, width: 100 }
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['INPUT_DIVI','TOT_AMT_I','PUB_PATH','AUTO_SLIP_NUM','EX_DATE','EX_NUM',
												'COMP_CODE','TX_NUM','PORT_YN','INPUT_PATH','CREDIT_CODE',
												'MONEY_UNIT','EXCHG_RATE_O','INSERT_DB_USER','INSERT_DB_TIME','UPDATE_DB_USER','UPDATE_DB_TIME',
												'DEPT_CODE','DEPT_NAME','ORG_ACCNT', 'ORG_ACCNT_NAME', 'BIZ_GUBUN', 'BIZ_GUBUN_NAME','R_CUSTOM_GUBUN','CHK_GUBUN'
				])){ 
					return false;
				}
				if(UniUtils.indexOf(e.field, ['CUSTOM_CODE','CUSTOM_NAME',/*'AC_DATE','SLIP_NUM','SLIP_SEQ',*/'DIV_CODE'])){
					if(e.record.data.INPUT_DIVI == '2'){
						return true;
					} else{
						return false;
					}
				}
				if(UniUtils.indexOf(e.field, ['REASON_CODE'])){
					if(e.record.data.PROOF_KIND == '54' || e.record.data.PROOF_KIND == '61' 
					|| e.record.data.PROOF_KIND == '70' || e.record.data.PROOF_KIND == '71'){
						return true;
					} else{
						return false;
					}
				}
				if(UniUtils.indexOf(e.field, ['CREDIT_NUM_EXPOS'])){
					return false;
				}
				if(UniUtils.indexOf(e.field, ['AC_DATE','SLIP_NUM','SLIP_SEQ'])){
					if(e.record.data.INPUT_DIVI == '2'){
						return true;
					} else{
						return false;
					}
				}
				if(UniUtils.indexOf(e.field, ['SUPPLY_AMT_I'])){
					taxControl = false;
				}
				if(UniUtils.indexOf(e.field, ['TAX_AMT_I'])){
					return taxControl;
				}
				if(UniUtils.indexOf(e.field, ['ASST_SUPPLY_AMT_I','ASST_TAX_AMT_I','ASST_DIVI'])) {
					if(UniUtils.indexOf(e.record.data.PROOF_KIND, ['55','61','68','69'])){	
						return true;
					} else{
						return false;
					}
				}
			},
			afterrender:function() {
				UniAppManager.app.setHiddenColumn();
			},
			selectionchangerecord:function(selected) {
				if(selected.data.INPUT_PATH == '79'){
					Ext.getCmp("linkPayInDtlBtn").enable(true);
					linkPgmId = linkId[0].IN_ID
				} else if(selected.data.INPUT_PATH == '80'){
					Ext.getCmp("linkPayInDtlBtn").enable(true);
					linkPgmId = linkId[0].PAY_ID
				} else{
					Ext.getCmp("linkPayInDtlBtn").disable(true);
				}
				
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td) {
				if(colName =="CREDIT_NUM_EXPOS") {
					if(record.data.PROOF_KIND == '53' || record.data.PROOF_KIND == '68' 
					|| record.data.PROOF_KIND == '62' || record.data.PROOF_KIND == '69' 
					|| record.data.PROOF_KIND == '70' || record.data.PROOF_KIND == '71'){
						grid.ownerGrid.openCryptCardNoPopup(record);
					}
				}
			}
			/*cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(record.get('INPUT_PATH') == '79'){
					Ext.getCmp("linkPayInDtlBtn").enable(true);
					linkPgmId = linkId[0].IN_ID
				} else if(record.get('INPUT_PATH') == '80'){
					Ext.getCmp("linkPayInDtlBtn").enable(true);
					linkPgmId = linkId[0].PAY_ID
				} else{
					Ext.getCmp("linkPayInDtlBtn").disable(true);
				}
			}*/
		},
		openCryptCardNoPopup:function( record ) {
			if(record) {
				var params = {'CRDT_FULL_NUM': record.get('CREDIT_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'CREDIT_NUM_EXPOS', 'CREDIT_NUM', params);
			}
		}
	});



	 Unilite.Main( {
		id			: 'atx100ukrApp',
		borderItems	: [{
			border	: false,
			region	: 'center',
			layout	: 'border',
			id		: 'pageAll',
			items	: [
				masterGrid, panelResult
			]
		}
		, panelSearch
		],
		fnInitBinding : function() {
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('txtFrDate');

			var viewNormal = masterGrid.normalGrid.getView();
			var viewLocked = masterGrid.lockedGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);

			this.setDefault();
		},
		onQueryButtonDown : function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			} else{
				UniAppManager.setToolbarButtons(['newData'/*,'reset'*/],true);
				//proofKindStore.gridRoadStoreRecords();
				directMasterStore.loadStoreRecords();   

				beforeSlipAlert = '';

//				var activeTabId = tab.getActiveTab().getId();
//				if(activeTabId == 'atx100ukrGrid'){
//					directMasterStore.loadStoreRecords();
//				}
//				var viewLocked = tab.getActiveTab().lockedGrid.getView();
//				var viewNormal = tab.getActiveTab().normalGrid.getView();
//				console.log("viewLocked : ",viewLocked);
//				console.log("viewNormal : ",viewNormal);
//				viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//				viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			}
		},
		onNewDataButtonDown: function() {
			var compCode	= UserInfo.compCode;
			var pubDate		= UniDate.get('today');
			var billDiviCode= panelSearch.getValue('txtOrgCd');
			var acDate		= UniDate.get('today');
			var slipNum		= '990001';
			var slipSeq		= '1';
			var portYn		= 'N';
			var inputPath	= 'T0';
			var inputDivi	= '2';
			var ebYn		= 'N';
			var moneyUnit	= BsaCodeInfo.moneyUnit;
			var taxnoYn		= 'Y';
			var crdtNoExpos	= '';
			var param		= {
				"COMP_CODE"	: UserInfo.compCode,
				"INPUT_PATH": inputPath
			};
			atx100ukrService.getPubPath(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					var pubPath = provider['PUB_PATH'];
					var r = {
						COMP_CODE		: compCode,
						PUB_DATE		: pubDate,
						BILL_DIVI_CODE	: billDiviCode,
						AC_DATE			: acDate,
						SLIP_NUM		: slipNum,
						SLIP_SEQ		: slipSeq,
						PORT_YN			: portYn,
						INPUT_PATH		: inputPath,
						INPUT_DIVI		: inputDivi,
						PUB_PATH		: pubPath,
						EB_YN			: ebYn,
						MONEY_UNIT		: moneyUnit,
						TAXNO_YN		: taxnoYn,
						CREDIT_NUM_EXPOS: crdtNoExpos
					};
					masterGrid.createRow(r/*,'PUB_DATE'*/);
				}
			});
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			var saveFlag = true;
			var records = directMasterStore.data.items;  
			Ext.each(records,  function(record, index){
				if(record.get('sReflectinSlip') == 'Y'){
					beforeSlipAlert = 'Y';
				}
			});
			if(beforeSlipAlert == 'Y'){
				if(confirm('수정된 내용을 전표에 반영하시겠습니까?')){
					var records = directMasterStore.data.items;
					Ext.each(records,  function(record, index){
						if(record.get('sReflectinSlip') == 'Y'){
							record.set('sReflectinSlipAlert','Y');
						}
					});
				}
			}
			
			//증빙유형이 (19, 35 아니면, 사업자번호 수동으로 필수체크) 
			//2018.07.19 김현민대리 요청으로 필수체크로직 삭제
			/*Ext.each(records,  function(record, index){
				if(record.get('PROOF_KIND') != '19' && record.get('PROOF_KIND') != '35'){
					if(Ext.isEmpty(record.get('COMPANY_NUM'))) {
						Unilite.messageBox((index+1) +'행의 사업자번호는 필수 입력사항 입니다.')
						saveFlag = false;
						return false;
					} else {
						saveFlag = true;
					}
				}
			});*/
			
			if (saveFlag) {
				directMasterStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();

			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		setDefault: function() {
			beforeSlipAlert = '';

			if(BsaCodeInfo.useLinkYn ==('Y')){
				Ext.getCmp('linkPayInDtlBtn').setHidden(false);
			} else{
				Ext.getCmp('linkPayInDtlBtn').setHidden(true);
			}
			Ext.getCmp('linkPayInDtlBtn').disable(true);

			panelSearch.setValue('SortGbn'	, BsaCodeInfo.sortNumber);
			panelSearch.setValue('txtFrDate', UniDate.get('startOfMonth'));
			panelSearch.setValue('txtToDate', UniDate.get('today'));
			panelResult.setValue('txtFrDate', UniDate.get('startOfMonth'));
			panelResult.setValue('txtToDate', UniDate.get('today'));

			UniAppManager.setToolbarButtons(['detail','reset','newData'],false);

			//proofKindStore.loadStoreRecords();
			/*Ext.each(getRefSubCode, function(record, idx) {
				if(record.REF_CODE1 == 'Y'){
					masterGrid.getColumn('PREFIX').setVisible(true);
					masterGrid.getColumn('SEQ_NUM').setVisible(true);
				} else{
					masterGrid.getColumn('PREFIX').setVisible(false);
					masterGrid.getColumn('SEQ_NUM').setVisible(false);
				}
				if(record.SUB_CODE == '1'){
					masterGrid.getColumn('IFRS_DRB_YEAR').setVisible(false);
				} else{
					masterGrid.getColumn('GAAP_DRB_YEAR').setVisible(true);
					masterGrid.getColumn('IFRS_DRB_YEAR').setVisible(true);
				}
			});*/
		},
		setHiddenColumn: function() {
			Ext.each(useColList, function(record, idx) {
				if(record.REF_CODE4 == 'True'){
					masterGrid.getColumn(record.REF_CODE3).setVisible(false);
				}
			});
			if(BsaCodeInfo.useLinkYn ==('Y')){
				masterGrid.getColumn("AUTO_SLIP_NUM").setVisible(true);
			} else{
				masterGrid.getColumn("AUTO_SLIP_NUM").setVisible(false);
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		},
		fnClearInfo: function(newValue, record){
			if(newValue == '19' || newValue == '22' || newValue =='23'){
				record.set('COMPANY_NUM','');   
			} else if(newValue != '54' && newValue != '61' 
				&& newValue != '70' && newValue != '71'){
				record.set('REASON_CODE','');
			} else if(newValue != '53' && newValue != '68'
				&& newValue != '62' && newValue != '69'
				&& newValue != '70' && newValue != '71'){
				record.set('CREDIT_NUM','');
				record.set('CREDIT_NUM_EXPOS','');
			}

			if(newValue != '55' && newValue != '61' && newValue !='68' && newValue !='69'){
				record.set("ASST_SUPPLY_AMT_I", 0);
				record.set("ASST_TAX_AMT_I", 0);
				record.set("ASST_DIVI", '');
			}
		},
		fnCalTaxAmt: function(newValue, record){
			if(Ext.isEmpty(record.get('TAX_AMT_I')) || record.get('TAX_AMT_I') == 0){
//			  var param = {"COMP_CODE": UserInfo.compCode,
//						  "PROOF_KIND": record.get('PROOF_KIND')
//				  };
//			  accntCommonService.fnGetTaxRate(param, function(provider, response) {
//				  if(!Ext.isEmpty(provider)){
//				  
//				  record.set('TAX_AMT_I',newValue * (provider['TAX_RATE'] * 0.01));
//				  
//				  record.set('TOT_AMT_I', newValue + record.get('TAX_AMT_I'));
//				  }
//			  })
				var taxRate	= 0;
				var param	= {
					"MAIN_CODE"	: 'A022',
					"SUB_CODE"	: record.get('PROOF_KIND'),
					"field"		: 'refCode2'
				};

				if(!Ext.isEmpty(UniAccnt.fnGetRefCode(param))){
					taxRate = parseInt(UniAccnt.fnGetRefCode(param));
				}

				record.set('TAX_AMT_I', newValue * taxRate * 0.01);
				record.set('TOT_AMT_I', newValue + record.get('TAX_AMT_I'));
			} else{
				record.set('TOT_AMT_I', newValue + record.get('TAX_AMT_I'));
			}
		},
		/** 휴폐업조회 링크 관련
		 */
		fnOpenSlip: function(){
			if(Ext.isEmpty(panelResult.getValue('txtFrDate')) ||  Ext.isEmpty(panelResult.getValue('txtToDate'))){
				Unilite.messageBox('계산서일을 입력해주십시오.');
				return; 
			}
			var params = {
				'PGM_ID'		: 'atx100ukr',
				'PUB_DATE_FR'	: UniDate.getDbDateStr(panelResult.getValue('txtFrDate')),
				'PUB_DATE_TO'	: UniDate.getDbDateStr(panelResult.getValue('txtToDate'))
			}
			var rec1 = {data : {prgID : 'atx101ukr', 'text':''}};
			parent.openTab(rec1, '/accnt/atx101ukr.do', params);
		}
	});



	Unilite.createValidator('validator01', {
		store	: directMasterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(newValue != oldValue) {
				switch(fieldName) {
					case "PUB_DATE" :
						if(record.obj.phantom == true){
							record.set('AC_DATE',newValue);
						} else{
							//record.set('AC_DATE',newValue);
							if(record.get('PUB_DATE_DUMMY') != UniDate.getDbDateStr(newValue)){
								record.set('NEW_PUB_DATE','Y');
							} else{
								record.set('NEW_PUB_DATE','');
							}
						}
						break;

//					case "AC_DATE" :
//						if(newValue != "") {
//							if(record.obj.phantom == true){
//								record.set('PUB_DATE',newValue);
//							} else{
//								record.set('PUB_DATE',newValue);
//								if(record.get('PUB_DATE_DUMMY') != UniDate.getDbDateStr(newValue)){
//									record.set('NEW_PUB_DATE','Y');
//								} else{
//									record.set('NEW_PUB_DATE','');
//								}
//								
//							}
 //			   		}
  //					break;

					case "COMPANY_NUM" :
						if(Unilite.validate('bizno', newValue) != true) {
							if(confirm(Msg.sMB173+"\n"+Msg.sMB175)) {
								record.set("COMPANY_NUM",newValue);
								break;
							} else{
								return false;
							}
						}
						break;

					case "INOUT_DIVI" :
						record.set('PROOF_KIND','');
						break;

					case "PROOF_KIND" :
						UniAppManager.app.fnClearInfo(newValue, record);
						break;

					case "SLIP_NUM" :
						if(newValue != ''){
							if(newValue <= 0){
								rv='<t:message code="unilite.msg.sMB076"/>';
								break;
							}
						}
						if(!Ext.isNumeric(newValue) || Ext.isEmpty(newValue)) {
							rv='<t:message code = "unilite.msg.sMB074"/>';
//							Ext.Msg.alert("확인","숫자만 입력가능합니다.");
							break;
						}
						break;

					case "SLIP_SEQ" :
						if(newValue != ''){
							if(newValue <= 0){
								rv='<t:message code="unilite.msg.sMB076"/>';
								break;
							}
						}   
						if(!Ext.isNumeric(newValue) || Ext.isEmpty(newValue)) {
							rv='<t:message code = "unilite.msg.sMB074"/>';  
//							Ext.Msg.alert("확인","숫자만 입력가능합니다.");
							break;
						}
						break;

					case "SUPPLY_AMT_I" : 
						UniAppManager.app.fnCalTaxAmt(newValue, record);
						/*if(newValue == null){
							Unilite.messageBox('ddd');
						}*/
						taxControl = true;
						break;

					case "TAX_AMT_I" :
						record.set('TOT_AMT_I', newValue + record.get('SUPPLY_AMT_I'));
						break;
				}
			}
			return rv;
		}
	});
};
</script>