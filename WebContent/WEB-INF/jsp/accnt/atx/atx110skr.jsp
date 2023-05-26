<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx110skr">
	<t:ExtComboStore comboType="BOR120"/>											<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120" comboCode="BILL" storeId="billDivCode"/>	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A003"/>								<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022"/>								<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A081"/>								<!-- 부가세조정 입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A070"/>								<!-- 매입세액불공제사유 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>								<!-- 주영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="A149"/>								<!-- 전자발행여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"/>								<!-- YES/NO (매수제외필드) -->
	<t:ExtComboStore comboType="AU" comboCode="A156"/>								<!-- 부가세생성경로 -->
	<t:ExtComboStore comboType="AU" comboCode="A011"/>								<!-- 입력경로 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >
var useColList	= ${useColList};
var linkId		= ${linkId};
var linkPgmId	= '';
var BsaCodeInfo	= {	
	useLinkYn	: '${useLinkYn}',
	sortNumber	: '${sortNumber}',
	moneyUnit	: '${moneyUnit}'
};

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx110skrModel', {
		fields: [
			{name: 'SEQ'				, text: '순번'			, type: 'string'},
			{name: 'GUBUN'				, text: '구분'			, type: 'string'},
			{name: 'PUB_DATE'			, text: '계산서일자'			, type: 'uniDate'},
			{name: 'CUSTOM_CODE'		, text: '거래처'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명'			, type: 'string'},
			{name: 'COMPANY_NUM'		, text: '사업자번호'			, type: 'string'},
			{name: 'I_SUPPLY_AMT'		, text: '매입공급가액'		, type: 'uniPrice'},
			{name: 'I_TAX_AMT'			, text: '매입세액'			, type: 'uniPrice'},
			{name: 'I_SUPPLY_SUM'		, text: '매입합계'			, type: 'uniPrice'},
			{name: 'O_SUPPLY_AMT'		, text: '매출공급가액'		, type: 'uniPrice'},
			{name: 'O_TAX_AMT'			, text: '매출세액'			, type: 'uniPrice'},
			{name: 'O_SUPPLY_SUM'		, text: '매출합계'			, type: 'uniPrice'},
			{name: 'PROOF_KIND'			, text: '증빙유형'			, type: 'string'},
			{name: 'DEPT_CODE'			, text: '귀속부서코드'		, type: 'string'}, 
			{name: 'DEPT_NAME'			, text: '귀속부서명'			, type: 'string'}, 
			{name: 'REMARK'				, text: '적요'			, type: 'string'},
			{name: 'BILL_DIVI_CODE'		, text: '신고사업장코드'		, type: 'string'},
			{name: 'BILL_DIVI_NAME'		, text: '신고사업장'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '귀속사업장코드'		, type: 'string'},
			{name: 'DIV_NAME'			, text: '귀속사업장'			, type: 'string'},
			{name: 'AC_DATE'			, text: '전표일자'			, type: 'uniDate'},
			{name: 'SLIP_NUM'			, text: '전표번호'			, type: 'string'},
			{name: 'SLIP_SEQ'			, text: '순번'			, type: 'string'},
			{name: 'INPUT_PATH'			, text: '입력경로코드'		, type: 'string'},
			{name: 'INPUT_PATH_NAME'	, text: '입력경로'			, type: 'string'},
			{name: 'INPUT_DIVI'			, text: 'INPUT_DIVI'	, type: 'string'},
			{name: 'PROOF_KIND2'		, text: 'PROOF_KIND2'	, type: 'string'},
			{name: 'INOUT_DIVI'			, text: 'INOUT_DIVI'	, type: 'string'},
			{name: 'EB_YN'				, text: 'EB_YN'			, type: 'string'},
			{name: 'EB_YN_NAME'			, text: '전자발행여부'		, type: 'string'},
			{name: 'TAX_INPUT_DIVI'		, text: '입력구분'			, type: 'string',comboType:'AU', comboCode:'A081'},
			{name: 'TAX_PUB_PATH'		, text: '생성경로'			, type: 'string',comboType:'AU', comboCode:'A156'},
			{name: 'REASON_CODE'		, text: '매입불공제사유'		, type: 'string'},
			{name: 'CREDIT_NUM'			, text: '신용카드/현금영수증번호'	, type: 'string'},
			{name: 'CREDIT_NUM_EXPOS'   , text: '신용카드/현금영수증번호'	, type: 'string'	, maxLength:20	, defaultValue:'***************'},
			{name: 'AUTO_SLIP_NUM'		, text: '지출/수입번호'		, type: 'string'},
			{name: 'EX_DATE'			, text: '결의일자'			, type: 'string'},
			{name: 'EX_NUM'				, text: '결의번호'			, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일' 			, type: 'string'},
			{name: 'BIGO'				, text: '비고'			, type: 'string'}
		]
	});		// End of Ext.define('Atx110skrModel', {

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('atx110skrMasterStore1',{
		model	: 'Atx110skrModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'atx110skrService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param		= Ext.getCmp('searchForm').getValues();
			var compN		= panelSearch.getValue('txtCompanyNum');
			var repCompN	= compN.replace(/-/g, "");
			param.txtCompanyNum = repCompN;
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var viewNormal = masterGrid.normalGrid.getView();
				var viewLocked = masterGrid.lockedGrid.getView();
				if(store.getCount() > 0){
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
					//20200724 추가: 출력기능 추가
					masterGrid.down('#printBtn').enable();
				}else{
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
					//20200724 추가: 출력기능 추가
					masterGrid.down('#printBtn').disable();
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

	/** 증빙유형 콤보 Store 정의
	 * @type 
	 */
	var ProofKindStore = Unilite.createStore('atx110skrProofKindStore',{
		proxy: {
			type: 'direct',
			api	: {
				read: 'atx110skrService.getProofKind'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '검색조건',
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
// 				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('txtDivi', newValue);
						ProofKindStore.loadStoreRecords();
					}
				}
			},{
				fieldLabel	: '신고사업장',
				name		: 'txtOrgCd',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
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
				store		: ProofKindStore,
				width		: 315,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('txtProofKind', newValue);
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
				xtype		: 'uniTextfield',
				name		: 'txtCompanyNum',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('txtCompanyNum', newValue);
					}
				}
			}]
		},{
			title		: '추가정보', 	
			itemId		: 'search_panel2',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [
			Unilite.popup('DEPT',{
				fieldLabel		: '귀속부서',
				valueFieldName	: 'DEPT_CODE',
				textFieldName	: 'DEPT_NAME'
			}),{ 
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
				fieldLabel	: '전자발행여부',
				xtype		: 'radiogroup',
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
						directMasterStore.loadStoreRecords();
					}
				}
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
				xtype		: 'radiogroup',
				fieldLabel	: '금액구분',
				id			: 'rdoSelect',
				columns		: 2,
				items		: [{
					boxLabel	: '매입공급가액', 
					width		: 100, 
					name		: 'SorGbn',
					inputValue	: '1',
					checked		: true  
				},{
					boxLabel	: '매입세액', 
					width		: 80,
					name		: 'SorGbn',
					inputValue	: '2'
				},{
					boxLabel	: '매출공급가액', 
					width		: 100, 
					name		: 'SorGbn',
					inputValue	: '3' 
				},{
					boxLabel	: '매출세액', 
					width		: 80,
					name		: 'SorGbn',
					inputValue	: '4'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						directMasterStore.loadStoreRecords();
					}
				}
			},{
				fieldLabel		: '입력일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'txtInputFrDate',
				endFieldName	: 'txtInputToDate',
				width			: 315
			},{
				fieldLabel		: '적요',
				name			: 'txtRemark',
				xtype			: 'uniTextfield'
			},{
				fieldLabel		: '입력구분',
				name			: 'txtInputDivi',
				xtype			: 'uniCombobox',
				comboType		: 'AU',
				comboCode		: 'A081'  
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
					checked	: true  
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
						directMasterStore.loadStoreRecords();
					}
				}
			},{
				fieldLabel	: '생성경로',
				name		: 'txtPubPath',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A156'  
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
				comboType	: 'AU',
				comboCode	: 'A070'
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
					inputValue	: '3' 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						directMasterStore.loadStoreRecords();
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
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
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
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});	//end panelSearch 

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
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
// 			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('txtDivi', newValue);
					ProofKindStore.loadStoreRecords();
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
					panelSearch.setValue('txtOrgCd', newValue);
				}
			}
		},{
			fieldLabel	: '증빙유형',
			name		: 'txtProofKind',
			xtype		: 'uniCombobox',
			store		: ProofKindStore,
			width		: 315,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('txtProofKind', newValue);
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
			xtype		: 'uniTextfield',
			name		: 'txtCompanyNum',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('txtCompanyNum', newValue);
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
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
	var masterGrid = Unilite.createGrid('atx110skrGrid1', {
		store		: directMasterStore,
		region		: 'center',
		excelTitle	: '매입매출장',
		uniOpt		: {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			dblClickToEdit		: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
			filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		uniRowContextMenu:{
			items: [{
				text	: '회계전표입력',
				id		: 'linkAgj200ukr',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgj200ukr(param.record);
				}
			},{	
				text	: '회계전표입력(전표번호별)',
				id		: 'linkAgj205ukr',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgj205ukr(param.record);
				}
			}]
		},
		tbar: [{
			itemId	: 'linkPayInDtlBtn',
			id		: 'linkPayInDtlBtn',
			text	: '지출/수입결의조회',
			handler	: function() {
				var params = {
//							 : record.get(''),
					//추후 링크 사용시 추가 필요
				}
				var rec = {data : {prgID : linkPgmId}};
				parent.openTab(rec, '/accnt/'+linkPgmId+'.do', params);
			}
		},{	//20200724 추가: 출력기능 추가
			text	: '출력',
			itemId	: 'printBtn',
			width	: 100,
			handler	: function() {
				UniAppManager.app.onPrintButtonDown();
			}
		}],
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: true 
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: true
		}],
		columns	: [
			{dataIndex: 'SEQ'					, width: 80, hidden:true},
			{dataIndex: 'GUBUN'					, width: 80, hidden:true},
			{dataIndex: 'PUB_DATE'				, width: 88, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
				}
			},
			{dataIndex: 'CUSTOM_CODE'			, width: 70, locked: true},
			{dataIndex: 'CUSTOM_NAME'			, width: 200, locked: true},
			{dataIndex: 'COMPANY_NUM'			, width: 100, align:'center'},
			{dataIndex: 'I_SUPPLY_AMT'			, width: 120,summaryType: 'sum'},
			{dataIndex: 'I_TAX_AMT'				, width: 120,summaryType: 'sum'},
			{dataIndex: 'I_SUPPLY_SUM'			, width: 120,summaryType: 'sum'},
			{dataIndex: 'O_SUPPLY_AMT'			, width: 120,summaryType: 'sum'},
			{dataIndex: 'O_TAX_AMT'				, width: 120,summaryType: 'sum'},
			{dataIndex: 'O_SUPPLY_SUM'			, width: 120,summaryType: 'sum'},
			{dataIndex: 'PROOF_KIND'			, width: 180},
			{dataIndex: 'DEPT_CODE'				, width: 100 },
			{dataIndex: 'DEPT_NAME'				, width: 100 },
			{dataIndex: 'REMARK'				, width: 250},
			{dataIndex: 'BILL_DIVI_CODE'		, width: 80, hidden:true},
			{dataIndex: 'BILL_DIVI_NAME'		, width: 120},
			{dataIndex: 'DIV_CODE'				, width: 80, hidden:true},
			{dataIndex: 'DIV_NAME'				, width: 120},
			{dataIndex: 'AC_DATE'				, width: 88},
			{dataIndex: 'SLIP_NUM'				, width: 66, align:'center'},
			{dataIndex: 'SLIP_SEQ'				, width: 60, align:'center'},
			{dataIndex: 'INPUT_PATH'			, width: 80, hidden:true},
			{dataIndex: 'INPUT_PATH_NAME'		, width: 100},
			{dataIndex: 'INPUT_DIVI'			, width: 80, hidden:true},
			{dataIndex: 'PROOF_KIND2'			, width: 80, hidden:true},
			{dataIndex: 'INOUT_DIVI'			, width: 80, hidden:true},
			{dataIndex: 'EB_YN'					, width: 80, hidden:true},
			{dataIndex: 'EB_YN_NAME'			, width: 100, align:'center'},
			{dataIndex: 'TAX_INPUT_DIVI'		, width: 80, align:'center'},
			{dataIndex: 'TAX_PUB_PATH'			, width: 80, align:'center'},
			{dataIndex: 'REASON_CODE'			, width: 250},
			{dataIndex: 'CREDIT_NUM'			, width: 180, hidden:true},
			{dataIndex: 'CREDIT_NUM_EXPOS'		, width: 180, align:'center'},
			{dataIndex: 'AUTO_SLIP_NUM'			, width: 120},
			{dataIndex: 'EX_DATE'				, width: 88},
			{dataIndex: 'EX_NUM'				, width: 80, align:'center'},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 130 ,hidden:false},
			{dataIndex: 'BIGO'					, width: 80}
		],
		listeners:{
			afterrender:function() {
				UniAppManager.app.setHiddenColumn();
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(record.data.INPUT_PATH == '79'){
					Ext.getCmp("linkPayInDtlBtn").enable(true);
					linkPgmId = linkId[0].IN_ID
				}else if(record.data.INPUT_PATH == '80'){
					Ext.getCmp("linkPayInDtlBtn").enable(true);
					linkPgmId = linkId[0].PAY_ID
				}else{
					Ext.getCmp("linkPayInDtlBtn").disable(true);
				}
			},
			/*selectionchange:function( model, selected, eOpts ){
				if(selected.startCell.record.data.INPUT_PATH == '79'){
					Ext.getCmp("linkPayInDtlBtn").enable(true);
					linkPgmId = linkId[0].IN_ID
				}else if(selected.startCell.record.data.INPUT_PATH == '80'){
					Ext.getCmp("linkPayInDtlBtn").enable(true);
					linkPgmId = linkId[0].PAY_ID
				}else{
					Ext.getCmp("linkPayInDtlBtn").disable(true);
				}
			},*/
			onGridDblClick:function(grid, record, cellIndex, colName) {
				if(colName =="CREDIT_NUM_EXPOS") {
					grid.ownerGrid.openCryptCardNoPopup(record);
				} else {
					if(record.get('INPUT_DIVI') == '2'|| (!Ext.isEmpty(record.get('INPUT_DIVI')) && record.get('INPUT_DIVI') != '2')){
						if(record.get('INPUT_DIVI') == '2'){
							masterGrid.gotoAgj205ukr(record);
						}else if(!Ext.isEmpty(record.get('INPUT_DIVI')) && record.get('INPUT_DIVI') != '2'){
							masterGrid.gotoAgj200ukr(record);
						}
					}
				}
				/*var params = {
					action:'select',
					'PGM_ID' : 'atx110skr',
					'AC_DATE' : UniDate.getDbDateStr(record.data['AC_DATE']),
					'INPUT_PATH' : record.data['INPUT_PATH'],
					'SLIP_NUM' : record.data['SLIP_NUM'],
					'SLIP_SEQ' : record.data['SLIP_SEQ'],
					'DIV_CODE' : record.data['DIV_CODE']
				}
				if (record.data['INPUT_DIVI'] == '2'){
					var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};
					parent.openTab(rec1, '/accnt/agj205ukr.do', params);
				}else if(record.data['INPUT_PATH'] == 'Z3'){
					var rec1 = {data : {prgID : 'dgj100ukr', 'text':''}};
					parent.openTab(rec1, '/accnt/dgj100ukr.do', params);
				}else if(!Ext.isEmpty(record.data['INPUT_DIVI']) && record.data['INPUT_DIVI'] != '2'){
					var rec1 = {data : {prgID : 'agj200ukr', 'text':''}};
					parent.openTab(rec1, '/accnt/agj200ukr.do', params);
				}*/
			},
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				if(record.get('INPUT_DIVI') == '2'|| (!Ext.isEmpty(record.get('INPUT_DIVI')) && record.get('INPUT_DIVI') != '2')){
					view.ownerGrid.setCellPointer(view, item);
				}
			}
		},
		openCryptCardNoPopup:function( record ) {
			if(record) {
				var params = {'CRDT_FULL_NUM': record.get('CREDIT_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'CREDIT_NUM_EXPOS', 'CREDIT_NUM', params);
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) { 
			if(record.get('INPUT_DIVI') == '2'|| (!Ext.isEmpty(record.get('INPUT_DIVI')) && record.get('INPUT_DIVI') != '2')){
				if(record.get('INPUT_DIVI') == '2'){
					menu.down('#linkAgj200ukr').hide();
					menu.down('#linkAgj205ukr').show();
				}else if(!Ext.isEmpty(record.get('INPUT_DIVI')) && record.get('INPUT_DIVI') != '2'){
					menu.down('#linkAgj205ukr').hide();
					menu.down('#linkAgj200ukr').show();
				}
				return true;
			}
		},
		gotoAgj200ukr:function(record) {
			if(record) {
				var params = {
					action		: 'select', 
					'PGM_ID'	: 'atx110skr',
					'AC_DATE'	: record.data['AC_DATE'],
					'INPUT_PATH': record.data['INPUT_PATH'],
					'SLIP_NUM'	: record.data['SLIP_NUM'],
					'SLIP_SEQ'	: record.data['SLIP_SEQ'],
					'DIV_CODE'	: record.data['DIV_CODE']
				}
				var rec1 = {data : {prgID : 'agj200ukr', 'text':''}};
				parent.openTab(rec1, '/accnt/agj200ukr.do', params);
			}
		},
		gotoAgj205ukr:function(record) {
			if(record) {
				var params = {
					action		:'select', 
					'PGM_ID'	: 'atx110skr',
					'AC_DATE'	: record.data['AC_DATE'],
					'INPUT_PATH': record.data['INPUT_PATH'],
					'SLIP_NUM'	: record.data['SLIP_NUM'],
					'SLIP_SEQ'	: record.data['SLIP_SEQ'],
					'DIV_CODE'	: record.data['DIV_CODE']
				}
				var rec2 = {data : {prgID : 'agj205ukr', 'text':''}};
				parent.openTab(rec2, '/accnt/agj205ukr.do', params);
			}
		}
	});	



	Unilite.Main({
		id			: 'atx110skrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons('reset',false);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('txtFrDate');

			var viewNormal = masterGrid.normalGrid.getView();
			var viewLocked = masterGrid.lockedGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);

			this.setDefault();
			this.processParams(params);
		},
		processParams: function(params) {
//			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'atx130skr') {
				panelSearch.setValue('txtFrDate'	, params.txtFrDate);
				panelSearch.setValue('txtToDate'	, params.txtToDate);
				panelSearch.setValue('txtDivi'		, params.txtDivi);
				panelSearch.setValue('txtCompanyNum', params.txtCompanyNum);
				panelSearch.setValue('txtOrgCd'		, params.txtOrgCd);
				panelResult.setValue('txtFrDate'	, params.txtFrDate);
				panelResult.setValue('txtToDate'	, params.txtToDate);
				panelResult.setValue('txtDivi'		, params.txtDivi);
				panelResult.setValue('txtCompanyNum', params.txtCompanyNum);
				panelResult.setValue('txtOrgCd'		, params.txtOrgCd);
				directMasterStore.loadStoreRecords();
			}else if(params.PGM_ID == 'atx140skr') {
				panelSearch.setValue('txtFrDate'	, params.txtFrDate);
				panelSearch.setValue('txtToDate'	, params.txtToDate);
				panelSearch.setValue('txtDivi'		, params.txtDivi);
				panelSearch.setValue('txtCompanyNum', params.txtCompanyNum);
				panelSearch.setValue('txtOrgCd'		, params.txtOrgCd);
				panelResult.setValue('txtFrDate'	, params.txtFrDate);
				panelResult.setValue('txtToDate'	, params.txtToDate);
				panelResult.setValue('txtDivi'		, params.txtDivi);
				panelResult.setValue('txtCompanyNum', params.txtCompanyNum);
				panelResult.setValue('txtOrgCd'		, params.txtOrgCd);
				directMasterStore.loadStoreRecords();
			}else if(params.PGM_ID == 'atx150skr') {
				panelSearch.setValue('txtFrDate', params.txtFrDate);
				panelSearch.setValue('txtToDate', params.txtToDate);
				panelSearch.setValue('txtDivi'	, params.txtDivi);
				panelSearch.setValue('txtOrgCd'	, params.txtOrgCd);
				panelResult.setValue('txtFrDate', params.txtFrDate);
				panelResult.setValue('txtToDate', params.txtToDate);
				panelResult.setValue('txtDivi'	, params.txtDivi);
				panelResult.setValue('txtOrgCd'	, params.txtOrgCd);
				directMasterStore.loadStoreRecords();
			}
		},
		onQueryButtonDown : function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore.loadStoreRecords();
//				UniAppManager.setToolbarButtons('reset',true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		setDefault: function() {
			ProofKindStore.loadStoreRecords();

			if(BsaCodeInfo.useLinkYn ==('Y')){
				Ext.getCmp('linkPayInDtlBtn').setHidden(false);
			}else{
				Ext.getCmp('linkPayInDtlBtn').setHidden(true);
			}
			Ext.getCmp('linkPayInDtlBtn').disable(true);
			panelSearch.setValue('SortGbn'	, BsaCodeInfo.sortNumber);
			panelSearch.setValue('txtFrDate', UniDate.get('startOfMonth'));
			panelSearch.setValue('txtToDate', UniDate.get('today'));
			panelResult.setValue('txtFrDate', UniDate.get('startOfMonth'));
			panelResult.setValue('txtToDate', UniDate.get('today'));
			//20200724 추가: 출력기능 추가
			masterGrid.down('#printBtn').disable();
		},
		setHiddenColumn: function() {
			Ext.each(useColList, function(record, idx) {
				if(record.REF_CODE4 == 'True'){
					masterGrid.getColumn(record.REF_CODE3).setVisible(false);
				}
			});
			if(BsaCodeInfo.useLinkYn ==('Y')){
				masterGrid.getColumn("AUTO_SLIP_NUM").setVisible(true);
				masterGrid.getColumn("EX_DATE").setVisible(true);
				masterGrid.getColumn("EX_NUM").setVisible(true);
			}else{
				masterGrid.getColumn("AUTO_SLIP_NUM").setVisible(false);
				masterGrid.getColumn("EX_DATE").setVisible(false);
				masterGrid.getColumn("EX_NUM").setVisible(false);
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		},
		//20200724 추가: 출력기능 추가
		onPrintButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			var param			= panelSearch.getValues();
			param.PGM_ID		= 'atx110skr';
			param.MAIN_CODE		= 'A126';

			var win = Ext.create('widget.ClipReport', {
				url		: CPATH+'/accnt/atx110clrkrPrint.do',
				prgID	: 'atx110skr',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>