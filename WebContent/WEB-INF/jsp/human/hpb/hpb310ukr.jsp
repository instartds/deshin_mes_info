<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpb310ukr">
	<t:ExtComboStore comboType="AU" comboCode="HS14"/>								<!-- 이자배당소득세율 -->
	<t:ExtComboStore comboType="AU" comboCode="HS10"/>								<!-- 필요경비세율 -->
	<t:ExtComboStore comboType="AU" comboCode="HS12"/>								<!-- 이자배당구분 -->
	<t:ExtComboStore comboType="AU" comboCode="HS15"/>								<!-- 계정구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H232"/>								<!-- 변동구분 -->
	<t:ExtComboStore comboType="BOR120"/>											<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120" comboCode="BILL" storeId="billDivCode"/>	<!-- 신고사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript">

var prov_Tax_Yyyymm = '';

function appMain() {	
	var gsDED_TYPE	= '10'
	var autoHidden	= false;
	if(gsDED_TYPE != '2') {
		autoHidden = true;
	}
	var gsRefCode		= '';
	var gsInComeKind	= '';	// 소득 종류 팝업에서 가져온 Value 값
	var gsAPopUp4		= '';	// HCO2 REF_CODE4
	var gsAPopUp5		= '';	// HC02 REF_CODE5


	var ApprovalYnStore = Ext.create('Ext.data.Store', {
		id		: 'comboStore',
		fields	: ['name', 'value'],
		data	: [
			{text : '승인'	, value: '1'},
			{text : '미승인'	, value: '2'}
		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpb310ukrService.selectList',
			update	: 'hpb310ukrService.updateDetail',
			create	: 'hpb310ukrService.insertDetail',
			destroy	: 'hpb310ukrService.deleteDetail',
			syncAll	: 'hpb310ukrService.saveAll'
		}
	});

	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('Hpb310ukrModel', {
		fields: [
			{name: 'DED_TYPE'			, text: 'DED_TYPE'			, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '소득자코드'				, type: 'string'	, allowBlank: false , maxLength: 10},
			{name: 'NAME'				, text: '성명'				, type: 'string'	, allowBlank: false , maxLength: 16},
			{name: 'BUSINESS_TYPE'		, text: '법인/개인'				, type: 'string'},
			{name: 'DWELLING_YN'		, text: '거주구분'				, type: 'string'},	
			{name: 'DEPT_CODE'			, text: '부서코드'				, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서명'				, type: 'string'},
			{name: 'EXEDEPT_CODE'		, text: '비용집행부서'			, type: 'string'},
			{name: 'EXEDEPT_NAME'		, text: '비용집행부서명'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '소속사업장'				, type: 'string'},
			{name: 'SECT_CODE'			, text: '신고사업장'				, type: 'string'},
			{name: 'DED_CODE'			, text: '소득코드'				, type: 'string'	, allowBlank: false},
			{name: 'DED_NAME'			, text: '소득코드명'				, type: 'string'},
			{name: 'PAY_YYYYMM'			, text: '귀속년월'				, type: 'string'	, allowBlank: false},
			{name: 'WORK_TIME'			, text: '기준시간'				, type: 'string'	, maxLength: 6},
			{name: 'SUPP_DATE'			, text: '지급일자'				, type: 'uniDate'	, allowBlank: false},
			{name: 'REAL_SUPP_DATE'		, text: '실지급일'				, type: 'uniDate'},
			{name: 'RECE_DATE'			, text: '영수일자'				, type: 'uniDate'},
			{name: 'INCOME_KIND'		, text: '소득종류'				, type: 'string'	, allowBlank: false},
			{name: 'TAX_EXCEPTION'		, text: '조세특례'				, type: 'string'	, allowBlank: false},
			{name: 'PRIZE_CODE'			, text: '상품코드'				, type: 'string'	},
			{name: 'TAX_GUBN'			, text: '과세구분'				, type: 'string'	, allowBlank: false}, 
			{name: 'CLAIM_INTER_GUBN'	, text: '채권이자구분'			, type: 'string'},
			{name: 'WERT_PAPER_CODE'	, text: '유가증권표준코드'			, type: 'string'},
			{name: 'BU_CODE'			, text: '원천부표코드'			, type: 'string'	, allowBlank: false},
			{name: 'CHANGE_GUBN'		, text: '변동구분'				, type: 'string'	, maxLength:3 , comboType: 'AU', comboCode: 'H232', defaultValue:'0'},
			{name: 'DATE_FROM_YYMM'		, text: '이자지급대상기간FM'		, type: 'uniDate'},
			{name: 'DATE_TO_YYMM'		, text: '이자지급대상기간TO'		, type: 'uniDate'},
			{name: 'INTER_RATE'			, text: '이자율'				, type: 'string'	, format:'0,0000'},
			{name: 'PAY_AMOUNT_I'		, text: '지급액'				, type: 'uniPrice'	, allowBlank: true , maxLength: 18},
			{name: 'EXPS_PERCENT_I'		, text: '필요경비세율'			, type: 'string'	, allowBlank: true , maxLength: 2},
			{name: 'EXPS_AMOUNT_I'		, text: '필요경비'				, type: 'uniPrice'	, allowBlank: true , maxLength: 18},
			{name: 'SUPP_TOTAL_I'		, text: '소득금액'				, type: 'uniPrice'	, maxLength: 18},
			{name: 'PERCENT_I'			, text: '세율(%)'				, type: 'string'	, allowBlank: true , maxLength: 2},
			{name: 'IN_TAX_I'			, text: '소득세'				, type: 'uniPrice'	, allowBlank: true , maxLength: 14},
			{name: 'CP_TAX_I'			, text: '법인세'				, type: 'uniPrice'	, allowBlank: true , maxLength: 14},
			{name: 'SP_TAX_I'			, text: '농특세'				, type: 'uniPrice'},
			{name: 'LOCAL_TAX_I'		, text: '주민세'				, type: 'uniPrice'	, allowBlank: true , maxLength: 14},
			{name: 'TAX_CUT_REASON'		, text: '세액감면및 제한세율 근거'		, type: 'string'},
			{name: 'DED_AMOUNT_I'		, text: '공제액'				, type: 'uniPrice'},
			{name: 'REAL_SUPP_TOTAL_I'	, text: '차인지급액'				, type: 'uniPrice'},
			{name: 'REMARK'				, text: '비고'				, type: 'string'},
			{name: 'ACC_GU'				, text: '계정구분'				, type: 'string'	, allowBlank: false, comboType: 'AU', comboCode: 'HS15'},
			{name: 'ITEM_CODE'			, text: '품목코드'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '품목명'				, type: 'string'},
			/* 20161024 추가 */
			{name: 'PJT_CODE'			, text: '사업코드' 				, type: 'string'},
			{name: 'PJT_NAME'			, text: '사업명' 				, type: 'string'},
			/* 20161221 추가 */
			{name: 'ORG_ACCNT'			, text: '본계정' 				, type: 'string'},
			{name: 'ORG_ACCNT_NAME'		, text: '본계정명'				, type: 'string'},
			{name: 'REMARK'				, text: '적요' 				, type: 'string'},
			{name: 'EX_DATE'			, text: '결의전표일'				, type: 'uniDate'}, 
			{name: 'EX_NUM'				, text: '결의전표번호'			, type: 'string'}, 
			{name: 'AC_DATE'			, text: '회계전표일'				, type: 'uniDate'}, 
			{name: 'SLIP_NUM'			, text: '회계전표번호'			, type: 'string'}, 
			{name: 'AGREE_YN'			, text: '승인여부'				, type: 'string'	, store: Ext.data.StoreManager.lookup('comboStore')},
			{name: 'COMP_CODE'			, text: '법인코드'				, type: 'string'}, 
			{name: 'INPUT_PGMID'		, text: '입력경로'				, type: 'string'},
			{name: 'SUPP_TYPE'			, text: '참조정보'				, type: 'string'},
			{name: 'TAX_YYYYMM'			, text: 'TAX_YYYYMM'		, type: 'string'},
			{name: 'SEQ'				, text: 'SEQ'				, type: 'int'},
			{name: 'CLOSE_YN'			, text: '<t:message code="system.label.human.deadlineyn" default="마감여부"/>'	, type: 'string', comboType: 'AU', comboCode: 'H153', editable: false},		//20210610 추가: 마감기능 추가, 마감인 데이터는 수정 불가
			{name: 'CLOSE_DATE'			, text: '<t:message code="system.label.sales.closingdate" default="마감일"/>'	, type: 'uniDate', editable: false}											//20210610 추가: 마감기능 추가, 마감인 데이터는 수정 불가
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('hpb310MasterStore',{
		model	: 'Hpb310ukrModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			console.log("toUpdate",toUpdate);

			if(inValidRecs.length == 0) {
				config = {
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						directMasterStore.loadStoreRecords();
					},
					failure: function(response) {
					}
				};
				this.syncAllDirect(config);
				
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count == 0){
					Unilite.messageBox(Msg.sMB015);	//해당 자료가 없습니다.
				}
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '기본정보',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '소득자타입',
				name: 'DED_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'HS12',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DED_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '신고사업장',
				name: 'SECT_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode: 'BILL',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SECT_CODE', newValue);
					}
				}
			},{
				fieldLabel: '지급일',
				xtype: 'uniDatefield',
				name: 'SUPP_DATE', 
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SUPP_DATE', newValue);
					}
				}
			},{
				fieldLabel: '귀속년월',
				xtype: 'uniMonthRangefield',
				startFieldName: 'DVRY_DATE_FR',
				endFieldName: 'DVRY_DATE_TO',
				width: 315,
//				readOnly: true,
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DVRY_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DVRY_DATE_TO',newValue);
					}
				}
			},
			Unilite.popup('DEPT',{
				fieldLabel: '부서', 
				validateBlank:false,
				autoPopup: false,
				//readOnly:true,
				valueFieldName:'DEPT_CODE',
				textFieldName:'DEPT_NAME', 
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME', newValue);
					},
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('DEPT_NAME', '');
						panelResult.setValue('DEPT_NAME', '');
						panelSearch.setValue('DEPT_NAME', '');
						panelSearch.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){
					}
				}
			}),
			Unilite.popup('EARNER',{
				fieldLabel: '소득자', 
				validateBlank:false,
				autoPopup: false,
				valueFieldName:'PERSON_NUMB',
				textFieldName:'NAME', 
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);
					},
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
						popup.setExtParam({'SECT_CODE': panelSearch.getValue('SECT_CODE')});	//신고사업장
					}
				}
			}),
			Unilite.treePopup('PJT_TREE',{ 
				fieldLabel		: '사업코드',
				valueFieldName	: 'PJT_CODE',
				textFieldName	: 'PJT_NAME',
				valuesName		: 'DEPTS' ,
				selectChildren	: true,
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName	: 'PJT_NAME',
				autoPopup		: true,
				useLike			: false,
				listeners: {
					'onValueFieldChange': function(field, newValue, oldValue  ){
						panelResult.setValue('PJT_CODE',newValue);
					},
					'onTextFieldChange':  function( field, newValue, oldValue  ){
						panelResult.setValue('PJT_NAME',newValue);
					},
					'onValuesChange':  function( field, records){
						var tagfield = panelResult.getField('DEPTS') ;
						tagfield.setStoreData(records)
					}
				}
			}), {
				xtype		: 'uniTextfield',
				fieldLabel	: '적요',
				name		: 'REMARK',
				width		: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REMARK', newValue);
					}
				}
			}]
		},{	
			title: '추가정보',	
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '사용여부',
				name: 'USER_YN', 
				xtype: 'combobox', 
				store: Ext.create('Ext.data.Store', {
								   id : 'comboStore',
								   fields : ['name', 'value'],
								   data   : [
									   {name : '사용함', value: '0'},
									   {name : '사용안함', value: '1'}
								   ]
							   }),
				queryMode: 'local',
				displayField: 'name',
				valueField: 'value',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('USER_YN', newValue);
					}
				}
			}]
		}]
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '소득자타입',
			name: 'DED_TYPE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'HS12',
			allowBlank: false,
//			tdAttrs			: {width: 380},		//20210610 주석
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DED_TYPE', newValue);
				}
			}
		},{
			fieldLabel: '신고사업장',
			name: 'SECT_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode: 'BILL',
			allowBlank: false,
//			tdAttrs			: {width: 380},		//20210610 주석 
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SECT_CODE', newValue);
				}
			}
		},{
			fieldLabel: '귀속년월',
			xtype: 'uniMonthRangefield',
			startFieldName: 'DVRY_DATE_FR',
			endFieldName: 'DVRY_DATE_TO',
//			tdAttrs			: {width: 380},		//20210610 주석
//			readOnly: true,
			allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DVRY_DATE_FR',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
					
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DVRY_DATE_TO',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		},{
			fieldLabel: '지급일',
			xtype: 'uniDatefield',
			name: 'SUPP_DATE',  
//			tdAttrs			: {width: 380},		//20210610 주석
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SUPP_DATE', newValue);
				}
			}
		},{
			fieldLabel: '사용여부',
			name: 'USER_YN', 
			xtype: 'combobox', 
			store: Ext.create('Ext.data.Store', {
							   id : 'comboStore',
							   fields : ['name', 'value'],
							   data   : [
								   {name : '사용함', value: '1'},
								   {name : '사용안함', value: '0'}
							   ]
						   }),
			queryMode: 'local',
			displayField: 'name',
			valueField: 'value',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('USER_YN', newValue);
				}
			}
		},
		Unilite.popup('EARNER',{
			fieldLabel: '소득자', 
			validateBlank:false,
			autoPopup: false,
			valueFieldName:'PERSON_NUMB',
			textFieldName:'NAME', 
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);
				},
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
					panelResult.setValue('PERSON_NUMB', '');
					panelResult.setValue('NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
					popup.setExtParam({'SECT_CODE': panelSearch.getValue('SECT_CODE')});	//신고사업장
				}
			}
		}),
		Unilite.popup('DEPT',{
			fieldLabel: '부서', 
			validateBlank:false,
			autoPopup: false,
			//readOnly:true,
			valueFieldName:'DEPT_CODE',
			textFieldName:'DEPT_NAME', 
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);
				},
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('DEPT_CODE', '');
					panelSearch.setValue('DEPT_NAME', '');
					panelResult.setValue('DEPT_CODE', '');
					panelResult.setValue('DEPT_NAME', '');
				},
				applyextparam: function(popup){
				}
			}
		}),
		Unilite.treePopup('PJT_TREE',{ 
			fieldLabel		: '사업코드',
			valueFieldName	: 'PJT_CODE',
			textFieldName	: 'PJT_NAME',
			valuesName		: 'DEPTS' ,
			selectChildren	: true,
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName	: 'PJT_NAME',
			autoPopup		: true,
			useLike			: false,
			listeners: {
				'onValueFieldChange': function(field, newValue, oldValue  ){
						panelSearch.setValue('PJT_CODE',newValue);
				},
				'onTextFieldChange':  function( field, newValue, oldValue  ){
						panelSearch.setValue('PJT_NAME',newValue);
				},
				'onValuesChange':  function( field, records){
						var tagfield = panelSearch.getField('DEPTS') ;
						tagfield.setStoreData(records)
				}
			}
		}),{
			xtype		: 'uniTextfield',
			fieldLabel	: '적요',
			name		: 'REMARK',
			width		: 570,			//20210610 수정: '60%' -> 570
			colspan		: 3,			//20210610 수정: 4 -> 3
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('REMARK', newValue);
				}
			}
		},{	//20210610 추가: 마감 / 마감취소 기능 추가
			xtype	: 'container',
			layout	: {
				type		: 'uniTable',
				columns		: 2,
				tableAttrs	: {align: 'right'}
			},
			items	: [{
				text	: '<t:message code="system.label.human.deadline" default="마감"/>',
				xtype	: 'button',
				itemId	: 'buttonClose',
				margin	: '0 0 3 0',
				width	: 80,
				handler	: function() {
					if(UniAppManager.app._needSave()) {
						Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
						return false;
					}
					var records = masterGrid.getSelectionModel().getSelection();
					if(Ext.isEmpty(records)) {
						Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
						return false;
					}
					buttonStore.saveStore('N');
				}
			},{ 
				text	: '<t:message code="system.label.human.cancelclosing" default="마감취소"/>',
				xtype	: 'button',
				itemId	: 'buttonCancel',
				margin	: '0 0 3 0',
				width	: 80,
				handler	: function() {
					if(UniAppManager.app._needSave()) {
						Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
						return false;
					}
					var records = masterGrid.getSelectionModel().getSelection();
					if(Ext.isEmpty(records)) {
						Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
						return false;
					}
					buttonStore.saveStore('Y');
				}
			}]
		}]
	});



	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('hpb310Grid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			copiedRow			: true,
			onLoadSelectFirst	: false	//20210610 추가
//			useContextMenu		: true,
		},
		//20210610 추가
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				},
				deselect: function(grid, selectRecord, index, eOpts ){
				}
			}
		}),
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true, dock: 'top', align: 'right'} 
		],
		columns: [{
				//20210610 추가
				xtype	: 'rownumberer',
				sortable: false,
				align	: 'center !important',
				resizable: true,
				width	: 35
			},
			{dataIndex: 'DED_TYPE'						, width: 20, hidden: true},
			{dataIndex: 'PERSON_NUMB'					, width: 100
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
				,editor: Unilite.popup('EARNER_G', {
					textFieldName: 'PERSON_NUMB',
					autoPopup: true,
					listeners: {'onSelected': {
									fn: function(records, type) {
											console.log('records : ', records);
											var grdRecord = masterGrid.uniOpt.currentRecord;		//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
											grdRecord.set('DED_TYPE', records[0].DED_TYPE);
											grdRecord.set('PERSON_NUMB', records[0].EARNER_CODE);
											grdRecord.set('NAME', records[0].EARNER_NAME);
											grdRecord.set('DED_CODE', records[0].DED_CODE);
											grdRecord.set('DED_NAME', records[0].DED_NAME);
											grdRecord.set('DEPT_CODE', records[0].DEPT_CODE);
											grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
											grdRecord.set('DIV_CODE', records[0].DIV_CODE);
											grdRecord.set('SECT_CODE', records[0].SECT_CODE);
											grdRecord.set('BUSINESS_TYPE', records[0].BUSINESS_TYPE);
											grdRecord.set('DWELLING_YN', records[0].DWELLING_YN);
											grdRecord.set('EXEDEPT_CODE', records[0].EXEDEPT_CODE);
											grdRecord.set('EXEDEPT_NAME', records[0].EXEDEPT_NAME);
										},
									scope: this
									},
								'onClear': function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;				//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
									grdRecord.set('DED_TYPE', '');
									grdRecord.set('PERSON_NUMB', '');
									grdRecord.set('NAME', '');
									grdRecord.set('DED_CODE', '');
									grdRecord.set('DED_NAME', '');
									grdRecord.set('DIV_CODE', '');
									grdRecord.set('DEPT_CODE', '');
									grdRecord.set('DEPT_NAME', '');
									grdRecord.set('SECT_CODE', '');
									grdRecord.set('BUSINESS_TYPE', '');
									grdRecord.set('DWELLING_YN', '');
									grdRecord.set('EXEDEPT_CODE', '');
									grdRecord.set('EXEDEPT_NAME', '');
								},
								applyextparam: function(popup){
									popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
								}
							}
						})
			},
			{dataIndex: 'NAME'							, width: 100, summaryType: 'count'
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) 
				{
					return '<div align="right">'+value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")+' 명</div>';
				}
				,editor: Unilite.popup('EARNER_G', {
						textFieldName: 'PERSON_NUMB',
						autoPopup: true,
						listeners: {'onSelected': {
										fn: function(records, type) {
												console.log('records : ', records);
												var grdRecord = masterGrid.uniOpt.currentRecord;		//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
												grdRecord.set('DED_TYPE', records[0].DED_TYPE);
												grdRecord.set('PERSON_NUMB', records[0].EARNER_CODE);
												grdRecord.set('NAME', records[0].EARNER_NAME);
												grdRecord.set('DED_CODE', records[0].DED_CODE);
												grdRecord.set('DED_NAME', records[0].DED_NAME);
												grdRecord.set('DEPT_CODE', records[0].DEPT_CODE);
												grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
												grdRecord.set('DIV_CODE', records[0].DIV_CODE);
												grdRecord.set('SECT_CODE', records[0].SECT_CODE);
												grdRecord.set('BUSINESS_TYPE', records[0].BUSINESS_TYPE);
												grdRecord.set('DWELLING_YN', records[0].DWELLING_YN);
												grdRecord.set('EXEDEPT_CODE', records[0].EXEDEPT_CODE);
												grdRecord.set('EXEDEPT_NAME', records[0].EXEDEPT_NAME);
											},
										scope: this
										},
									'onClear': function(type) {
										var grdRecord = masterGrid.uniOpt.currentRecord;				//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
										grdRecord.set('DED_TYPE', '');
										grdRecord.set('PERSON_NUMB', '');
										grdRecord.set('NAME', '');
										grdRecord.set('DED_CODE', '');
										grdRecord.set('DED_NAME', '');
										grdRecord.set('DIV_CODE', '');
										grdRecord.set('DEPT_CODE', '');
										grdRecord.set('DEPT_NAME', '');
										grdRecord.set('SECT_CODE', '');
										grdRecord.set('BUSINESS_TYPE', '');
										grdRecord.set('DWELLING_YN', '');
										grdRecord.set('EXEDEPT_CODE', '');
										grdRecord.set('EXEDEPT_NAME', '');
									},
									applyextparam: function(popup){
										popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
									}
								}
							})
			},
			{dataIndex: 'DEPT_CODE'					  , width: 88 ,
			  'editor': Unilite.popup('DEPT_G',{
					textFieldName : 'DEPT_NAME',
					autoPopup: true,
					listeners: { 'onSelected': {
						fn: function(records, type  ){
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
							grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
							
						},
						scope: this
					  },
					  'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE','');
							grdRecord.set('DEPT_NAME','');
					  },
						applyextparam: function(popup){
							
						}
					}
				})
			},			  
			{dataIndex: 'DEPT_NAME'					 , width: 150,
			  editor: Unilite.popup('DEPT_G', {
//			  textFieldName: 'DEPT_NAME',
					DBtextFieldName: 'DEPT_NAME',
					autoPopup: true,
					listeners: {'onSelected': {
						fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
								grdRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
							},
						scope: this 
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('DEPT_CODE', '');
								grdRecord.set('DEPT_NAME', '');
						},
						applyextparam: function(popup){
						}
					}
				})
			}, 
			{dataIndex: 'EXEDEPT_NAME'					, width: 100,   hidden: true},
			{dataIndex: 'BUSINESS_TYPE'					, width: 80,	hidden: true},
			{dataIndex: 'DWELLING_YN'					, width: 80,	hidden: true},
			{dataIndex: 'EXEDEPT_CODE'					, width: 80,	hidden: true},
			{dataIndex: 'DIV_CODE'						, width: 80,	hidden: true},
			{dataIndex: 'SECT_CODE'						, width: 80,	hidden: true},
			{dataIndex: 'DED_CODE'						, width: 80,	hidden: true},
			{dataIndex: 'DED_NAME'						, width: 160},
			{dataIndex: 'PAY_YYYYMM'					, width: 100},
			{dataIndex: 'WORK_TIME'						, width: 73 ,	hidden: true
//				,renderer: function(value) {
//					return value + '.00';
//				}
			},
			{dataIndex: 'SUPP_DATE'						, width: 100},
			{dataIndex: 'REAL_SUPP_DATE'				, width: 100},
			{dataIndex: 'RECE_DATE'						, width: 100},
			{dataIndex: 'INCOME_KIND'					, width: 80
				,editor: Unilite.popup('SAUP_POPUP_G', {
					textFieldName: 'INCOME_KIND',
 					DBtextFieldName: 'INCOME_KIND',
 					pageTitle: '소득종류',
 					autoPopup: true,
					listeners: {'onSelected': {
									fn: function(records, type) {
											console.log('records : ', records);
											var grdRecord = masterGrid.uniOpt.currentRecord;		//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
											grdRecord.set('INCOME_KIND', records[0].SUB_CODE);
											
											gsInComeKind = records[0].SUB_CODE;
											
											if(gsInComeKind == '13' || gsInComeKind == '14' || gsInComeKind == '17'){
												gsInComeKind = 'A';
											}else if(gsInComeKind == '11' || gsInComeKind == '12' || gsInComeKind == '15' || gsInComeKind == '16'){
												gsInComeKind = 'B';
											}else if(gsInComeKind == '19' || gsInComeKind == '20' ){
												gsInComeKind = 'C';
											}else if(gsInComeKind == '25'){
												gsInComeKind = 'D';
											}else if(gsInComeKind == '51' || gsInComeKind == '56' ){
												gsInComeKind = 'E';
											}else if(gsInComeKind == '53'){
												gsInComeKind = 'F';
											}else if(gsInComeKind == '55'){
												gsInComeKind = 'G';
											}else if(gsInComeKind == '61'){
												gsInComeKind = 'H';
											}else{
												gsInComeKind = '';
											}	
											
											if(gsInComeKind == ''){
												grdRecord.set('PRIZE_CODE' ,'');
											}
										},
									scope: this
									},
								'onClear': function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;				//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
									grdRecord.set('INCOME_KIND', '');
									
									if(grdRecord.get('INCOME_KIND') == ''){
										grdRecord.set('PRIZE_CODE' ,'');
									}	
								},
								applyextparam: function(popup){
									popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
									popup.setExtParam({'PARAM_MAIN_CODE': 'HC05'});							//사업소득자 공통코드
								}
							}
						})
			},
			
			{dataIndex: 'TAX_EXCEPTION'					, width: 80
				,editor: Unilite.popup('SAUP_POPUP_G', {								// 조세특례(HC06)
					textFieldName: 'TAX_EXCEPTION',
 					DBtextFieldName: 'TAX_EXCEPTION',
 					pageTitle: '조세특례',
					autoPopup: true,
					listeners: {'onSelected': {
									fn: function(records, type) {
											console.log('records : ', records);
											var grdRecord = masterGrid.uniOpt.currentRecord;				//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
											grdRecord.set('TAX_EXCEPTION', records[0].SUB_CODE);
										},
									scope: this
									},
								'onClear': function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;						//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
									grdRecord.set('TAX_EXCEPTION', '');
								},
								applyextparam: function(popup){
									popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
									popup.setExtParam({'PARAM_MAIN_CODE': 'HC06'});							//사업소득자 공통코드
								}
							}
						})
			},
			{dataIndex: 'PRIZE_CODE'					, width: 80,	hidden: false
				,editor: Unilite.popup('PRIZE_POPUP_G', {				//
					textFieldName: 'PRIZE_CODE',
					autoPopup: true,
					listeners: {'onSelected': {
									fn: function(records, type) {
											console.log('records : ', records);
											var grdRecord = masterGrid.uniOpt.currentRecord;				//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
											grdRecord.set('PRIZE_CODE', records);
										
										},
									scope: this
									},
								'onClear': function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;						//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
									grdRecord.set('PRIZE_CODE', '');
								},
								applyextparam: function(popup){
									popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
									
									var grdRecord = masterGrid.uniOpt.currentRecord;
									var payYYYY 	 = grdRecord.get('PAY_YYYYMM');
									var strPayYYYY   = payYYYY.substring(0,4);
									gsInComeKind	 = grdRecord.get('INCOME_KIND');
									
									if(strPayYYYY < '2012'){			//2012년 기준
										popup.setExtParam({'PARAM_MAIN_CODE': 'HC04'});							//사업소득자 공통코드
									}
									else{		
										if(gsInComeKind == '13' || gsInComeKind == '14' || gsInComeKind == '17'){
											gsInComeKind = 'A';
										}else if(gsInComeKind == '11' || gsInComeKind == '12' || gsInComeKind == '15' || gsInComeKind == '16'){
											gsInComeKind = 'B';
										}else if(gsInComeKind == '19' || gsInComeKind == '20' ){
											gsInComeKind = 'C';
										}else if(gsInComeKind == '25'){
											gsInComeKind = 'D';
										}else if(gsInComeKind == '51' || gsInComeKind == '56' ){
											gsInComeKind = 'E';
										}else if(gsInComeKind == '53'){
											gsInComeKind = 'F';
										}else if(gsInComeKind == '55'){
											gsInComeKind = 'G';
										}else if(gsInComeKind == '61'){
											gsInComeKind = 'H';
										}else{
											gsInComeKind = '';
										}
										popup.setExtParam({'PARAM_MAIN_CODE': 'HC08'});			//사업소득자 공통코드
										popup.setExtParam({'IN_COME_KIND' : gsInComeKind})	//소득종류
									}
								}
							}
						})
			},
			{dataIndex: 'TAX_GUBN'						, width: 80,	hidden: false
				,editor: Unilite.popup('SAUP_POPUP_G', {								// 과세구분 (HC02)
					textFieldName: 'TAX_GUBN',
 					DBtextFieldName: 'TAX_GUBN',
 					pageTitle: '과세구분',
 					autoPopup: true,
					listeners: {
								'onSelected': {
									fn: function(records, type) {
											console.log('records : ', records);
											var grdRecord = masterGrid.uniOpt.currentRecord;				//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
											grdRecord.set('TAX_GUBN', records[0].SUB_CODE);
											var payYYYY 	 = grdRecord.get('PAY_YYYYMM');
											var strPayYYYY   = payYYYY.substring(0,4);
											
											if(strPayYYYY < '2012'){
												//grdRecord.set('TAX_GUBN', records[0].SUB_CODE);
												var sPrizeCode = '';
												var sRefCode   = '';  var sBusinessType = '';
												
												sPrizeCode	= grdRecord.get('PRIZE_CODE');
												sPrizeCode	= sPrizeCode.substring(sPrizeCode.length, sPrizeCode.length-2);
												sBusinessType = grdRecord.get('BUSINESS_TYPE');
												
												if(grdRecord.get('DED_TYPE') == '10'){ // 소득자타입(10:이자)
													
													sRefCode = records[0].REF_CODE3;  // sRefCode = gaPopUp(4)
													
													if(sRefCode == ''){
														alert(Msg.sMH1468); 	//이자 소득코드를 확인하세요. 
														grdRecord.set('TAX_GUBN', '');
														return false;
													}
													
													if(sBusinessType == '1'){
														if(sRefCode == '110' || sRefCode == '120' || sRefCode == '121' || 
														   sRefCode == '131' || sRefCode == '134' || sRefCode == '142' ){
															
															alert(Msg.sMH1469);	// 법인 과세구분코드를 확인하세요.
															grdRecord.set('TAX_GUBN', '');
															return false;
														}
													}else if(sBusinessType == '2'){
														if(sRefCode == '150' || sRefCode == '160' || sRefCode == '170' || sRefCode == '180'){
															
															alert(Msg.sMH1470);	// 개인 과세구분코드를 확인하세요.
															grdRecord.set('TAX_GUBN', '');
															return false;
														}
													}
													
													if(sPrizeCode == 'MA'){
														if(sRefCode == '131'){
															grdRecord.set('TAX_GUBN', '' /*+ sRefCode */);
														}else{
															alert(Msg.sMH1471);  // 131 과세구분코드를 확인하세요.
															grdRecord.set('TAX_GUBN', '');
															return false;
														}
													}else{
														grdRecord.set('TAX_GUBN', ''/* + sRefCode */);
													}
													if(sRefCode != ''){		
														if(sRefCode == '120'){
															grdRecord.set('TAX_GUBN', '30');
														}else if(sRefCode == '131'){
															grdRecord.set('TAX_GUBN', '25');
														}
													}
													/////
												}
												else if(grdRecord.get('DED_TYPE') == '20'){ //소득자타입(20:배당)
													sRefCode = records[0].REF_CODE4;  // sRefCode = gaPopUp(5)
													
													if(sRefCode == ''){
														alert(Msg.sMH1459); 	//소득 구분을 확인하세요
														grdRecord.set('TAX_GUBN', '');
														return false;
													}
													if(sBusinessType == '1'){
														if(sRefCode == '210' || sRefCode == '211' || sRefCode == '220' || 
														   sRefCode == '221' || sRefCode == '232' || sRefCode == '233' || sRefCode == '234' || sRefCode == '235' || sRefCode == '236' ||  
														   sRefCode == '237' || sRefCode == '238' || sRefCode == '239' || sRefCode == '241' || sRefCode == '242' || sRefCode == '243' ||
														   sRefCode == '244' || sRefCode == '245' || sRefCode == '247'){
																alert(Msg.sMH1469);	// 법인 과세구분코드를 확인하세요.
																grdRecord.set('TAX_GUBN', '');
																return false;
														}
													}else if(sBusinessType == '2'){
														if(sRefCode == '250' || sRefCode == '260' || sRefCode == '270' || sRefCode == '280'){
															alert(Msg.sMH1470);	// 개인 과세구분코드를 확인하세요.
															grdRecord.set('TAX_GUBN', '');
															return false;
														}
													}
													if(sPrizeCode != ''){
														if(sPrizeCode == 'MA' || sPrizeCode == 'LB'){
															if(sRefCode == '232' || sRefCode == '238' || sRefCode == '235' || sRefCode == '244'){
																grdRecord.set('TAX_GUBN', ''/*+ sRefCode*/ );
															}else{
																alert(Msg.sMH1472);  // 과세구분코드를 확인하세요.
																grdRecord.set('TAX_GUBN', '');
																return false;
															}
														}
														if(sPrizeCode == 'LC'){
															if(sRefCode == '233' || sRefCode == '239' || sRefCode == '236' || sRefCode == '245'){
																grdRecord.set('TAX_GUBN', sRefCode );
															}else{
																alert(Msg.sMH1472);  // 과세구분코드를 확인하세요.
																grdRecord.set('TAX_GUBN', '');
																return false;
															}
														}else{
															grdRecord.set('TAX_GUBN', sRefCode );
														}
													}	
												}
												// 2012 년 부터
											}else{
												var sDedCode = '';
												var sTaxGubn = '';
												var sBusinessType = '';
												
												sDedCode = grdRecord.get('DED_CODE');
												sDedCode = sDedCode.substring(0,1);
												sTaxGubn = grdRecord.get('TAX_GUBN');
												sBusinessType = grdRecord.get('BUSINESS_TYPE');
												
												
												if(sBusinessType = '1'){
													if(sTaxGubn == "C" || sTaxGubn == "X" || sTaxGubn == "F" || sTaxGubn == "I" || sTaxGubn == "W"){
														if(sDedCode != '2' && sDedCode != '4'){
															alert(Msg.fsbMsgH0376); // 과세구분을 잘못 선택하셨습니다. 소득구분을 확인하여 주세요.
															grdRecord.set('TAX_GUBN', '');
															return false;
														}
													}
												}else{
													if(sTaxGubn == "E" || sTaxGubn == "L" || sTaxGubn == "H" || sTaxGubn == "O" || sTaxGubn == "B" || sTaxGubn == "I"){
														if(sDedCode != '1' && sDedCode != '3' && sDedCode != '4'){
															alert(Msg.fsbMsgH0376); // 과세구분을 잘못 선택하셨습니다. 소득구분을 확인하여 주세요.
															grdRecord.set('TAX_GUBN', '');
															return false;
														}
													}
												}
											}
										},
									scope: this
									},
								'onClear': function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;						//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
									grdRecord.set('TAX_GUBN', '');
								},
								applyextparam: function(popup){
									popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
									var grdRecord	= masterGrid.uniOpt.currentRecord;						//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
									var payYYYY 	= grdRecord.get('PAY_YYYYMM');
									var strPayYYYY	= payYYYY.substring(0,4);

									if(strPayYYYY < '2012'){			//2012년 기준
										popup.setExtParam({'PARAM_MAIN_CODE': 'HC02'});						//사업소득자 공통코드
									}
									else{
										popup.setExtParam({'PARAM_MAIN_CODE': 'HC07'});						//사업소득자 공통코드
									}
								}
							}
						})
			},
			{dataIndex: 'CLAIM_INTER_GUBN'				, width: 106,	hidden: false
				,editor: Unilite.popup('SAUP_POPUP_G', {								// 채권이자구분(HC03)
					textFieldName: 'CLAIM_INTER_GUBN',
 					DBtextFieldName: 'CLAIM_INTER_GUBN',
 					autoPopup: true,
 					pageTitle: '채권이자구분',
					listeners: {'onSelected': {
									fn: function(records, type) {
											console.log('records : ', records);
											var grdRecord = masterGrid.uniOpt.currentRecord;				//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
											grdRecord.set('CLAIM_INTER_GUBN', records[0].SUB_CODE);
										},
									scope: this
									},
								'onClear': function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;						//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
									grdRecord.set('CLAIM_INTER_GUBN', '');
								},
								applyextparam: function(popup){							
									popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
									popup.setExtParam({'PARAM_MAIN_CODE': 'HC03'});							//사업소득자 공통코드
								}
							}
						})
			},
			{dataIndex: 'WERT_PAPER_CODE'				, width: 130,	hidden: false},
			{dataIndex: 'BU_CODE'						, width: 100,	hidden: false,
			editor: Unilite.popup('BU_CODE_POPUP_G', {														// 채권이자구분(HC03)
					textFieldName: 'BU_NAME',
 					DBtextFieldName: 'BU_NAME',
 					autoPopup: true,
 					pageTitle: '원천징수이행상황신고서 부표 코드',
					listeners: {'onSelected': {
									fn: function(records, type) {
											console.log('records : ', records);
											var grdRecord = masterGrid.uniOpt.currentRecord;				//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
											grdRecord.set('BU_CODE', records[0].TAX_CODE);
										},
									scope: this
									},
								'onClear': function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;						//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
									grdRecord.set('BU_CODE', '');
								},
								applyextparam: function(popup){
									var grdRecord	= masterGrid.uniOpt.currentRecord;						//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
									var buCode		= grdRecord.get('BU_CODE');
									var businessType= grdRecord.get('BUSINESS_TYPE');
									var dwellingYn	= grdRecord.get('DWELLING_YN');
									var buCode		= grdRecord.get('BU_CODE');
									var dedType		= grdRecord.get('DED_TYPE');
									var gaPopup1	= buCode;
									var gaPopup2	= '';
									var gaPopup3	= prov_Tax_Yyyymm;
//									var gaPopup3	= '201602';
									var gaPopup4	= '';
									var gaPopup5	= '';

									if(gaPopup3 >= '201801'){
										// 개인이면서 거주자, 이자소득
										if((businessType == '2' || businessType == '3') && dwellingYn == '1' && dedType =='10'){
											gaPopup2 = '1';
											gaPopup4 = 'A';
										}
											// 개인이면서 거주자, 배당소득
										if((businessType == '2' || businessType == '3') && dwellingYn == '1' && dedType =='20'){
											gaPopup2 = '2';
											gaPopup4 = 'A';
										}
											// 개인이면서 비거주자, 이자소득
										if((businessType == '2' || businessType == '3') && dwellingYn == '2' && dedType =='10'){
											gaPopup2 = '3';
											gaPopup4 = '*';
										}
											// 개인이면서 비거주자, 배당소득
										if((businessType == '2' || businessType == '3') && dwellingYn == '2' && dedType =='20'){
											gaPopup2 = '4';
											gaPopup4 = '*';
										}
											// 국내법인, 이자소득
										if(businessType == '1' && dwellingYn == '1' && dedType =='10'){
											gaPopup2 = '5';
											gaPopup4 = '*';
										}
											// 국내법인, 배당소득
										if(businessType == '1' && dwellingYn == '1' && dedType =='20'){
											gaPopup2 = '6';
											gaPopup4 = '*';
										}
											// 국외법인, 이자소득
										if(businessType == '1' && dwellingYn == '2' && dedType =='10'){
											gaPopup2 = '7';
											gaPopup4 = '*';
										}
											// 국외법인, 배당소득
										if(businessType == '1' && dwellingYn == '2' && dedType =='20'){
											gaPopup2 = '8';
											gaPopup4 = '*';
										}
									}else{
											// 개인이면서 거주자 이자소득
										if((businessType == '2' || businessType == '3') && dwellingYn == '1' && dedType =='10'){
											gaPopup2 = '1';
											gaPopup4 = 'C01';
											gaPopup5 = 'C53';
										}
											// 개인이면서 거주자 배당소득
										if((businessType == '2' || businessType == '3') && dwellingYn == '1' && dedType =='20'){
											gaPopup2 = '1';
											gaPopup4 = 'C01';
											gaPopup5 = 'C53';
										}
											// 개인이면서 비거주자 이자소득
										if((businessType == '2' || businessType == '3') && dwellingYn == '2' && dedType =='10'){
											gaPopup2 = '10';
											gaPopup4 = 'C61';
											gaPopup5 = 'C61';
										}
											// 개인이면서 비거주 배당소득
										if((businessType == '2' || businessType == '3') && dwellingYn == '2' && dedType =='20'){
											gaPopup2 = '20';
											gaPopup4 = 'C62';
											gaPopup5 = 'C62';
										}
											// 법인이면서 거주자 이자소득
										if(businessType == '1' && dwellingYn == '1' && dedType =='10'){
											gaPopup2 = '1';
											gaPopup4 = 'C01';
											gaPopup5 = 'C99';
										}
											// 법인이면서 비거주자 이자소득
										if(businessType == '1' && dwellingYn == '2' && dedType =='10'){
											gaPopup2 = '2';
											gaPopup4 = 'C81';
											gaPopup5 = 'C81';
										}
											// 법인이면서 비거주자 이자소득
										if(businessType == '1' && dwellingYn == '1' && dedType =='20'){
											gaPopup2 = '1';
											gaPopup4 = 'C72';
											gaPopup5 = 'C75';
										}
											// 법인이면서 거주자 배당소득
										if(businessType == '1' && dwellingYn == '2' && dedType =='20'){
											gaPopup2 = '2';
											gaPopup4 = 'C82';
											gaPopup5 = 'C82';
										}
									}
									popup.setExtParam({'gaPopUp1': gaPopup1});
									popup.setExtParam({'gaPopUp2': gaPopup2});
									popup.setExtParam({'gaPopUp3': gaPopup3});
									popup.setExtParam({'gaPopUp4': gaPopup4});
									popup.setExtParam({'gaPopUp5': gaPopup5});
								}
						}
					})	
			}, 
			{dataIndex: 'CHANGE_GUBN'					, width: 100,	hidden: false},
			{dataIndex: 'DATE_FROM_YYMM'				, width: 130,	hidden: false},
			{dataIndex: 'DATE_TO_YYMM'					, width: 130,	hidden: false},
			{dataIndex: 'INTER_RATE'					, width: 100},
			{dataIndex: 'PAY_AMOUNT_I'					, width: 100, summaryType: 'sum'},
			{dataIndex: 'EXPS_PERCENT_I'				, width: 100,  	hidden: true,
				editor: {
					xtype: 'combobox', 
					id:'EXPS_PERCENT_I_G',
					store: Ext.create('Ext.data.Store', {
									   id : 'comboStore',
									   fields : ['name', 'value'],
									   data   : [
										   {name : '0.', value: '0'},
										   {name : '75.', value: '75'},
										   {name : '80.', value: '80'}
										 
									   ]
								   }),
					queryMode: 'local',
					displayField: 'name',
					valueField: 'value'/*,
					renderer: function (value) { // TODO : fix it!
						var record = Ext.getStore('comboStore').findRecord('value', value); console.log(record);
							if (record == null || record == undefined ) {
								return '';
							} else {
								return record.data.name;
							}
				   }*/, listeners: {
					   select: function(combo) {
//						   alert(this.getValue()); // 세율
//						  fnTaxCalc(masterGrid.getSelectionModel().getSelection()[0]);
						  fnTaxCalc(masterGrid.uniOpt.currentRecord);						//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
					   }
				   }
				}
			},
			{dataIndex: 'EXPS_AMOUNT_I'					, width: 100,	hidden: true , summaryType: 'sum'}, 
			{dataIndex: 'SUPP_TOTAL_I'					, width: 100,	hidden: true , summaryType: 'sum'},
			{dataIndex: 'PERCENT_I'						, width: 100,
				editor: {
					xtype: 'combobox', 
					store: Ext.create('Ext.data.Store', {
									   id : 'comboStore',
									   fields : ['name', 'value'],
									   data   : [
										   {name : '10.', value: '10'},
										   {name : '15.', value: '15'},
										   {name : '20.', value: '20'},
										   {name : '25.', value: '25'},
										   {name : '30.', value: '30'}
									   ]
								   }),
					queryMode: 'local',
					displayField: 'name',
					valueField: 'value',
					renderer: function (value) { // TODO : fix it!
						var record = Ext.getStore('comboStore').findRecord('value', value); console.log(record);
							if (record == null || record == undefined ) {
								return '';
							} else {
								return record.data.name;
							}
				   }, listeners: {
					   select: function(combo) {
//						   alert(this.getValue()); // 세율
//						   fnTaxCalc(masterGrid.getSelectionModel().getSelection()[0]);
						  fnTaxCalc(masterGrid.uniOpt.currentRecord);						//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
					   }
				   }
				}
			},
			{dataIndex: 'IN_TAX_I'						, width: 100 , summaryType: 'sum'},
			{dataIndex: 'CP_TAX_I'						, width: 100 , summaryType: 'sum'},
			{dataIndex: 'SP_TAX_I'						, width: 100 , hidden: true , summaryType: 'sum'},
			{dataIndex: 'LOCAL_TAX_I'					, width: 100 , summaryType: 'sum'},
			{dataIndex: 'TAX_CUT_REASON'				, width: 200},
			{dataIndex: 'DED_AMOUNT_I'					, width: 100 , summaryType: 'sum'},
			{dataIndex: 'REAL_SUPP_TOTAL_I'				, width: 100 , summaryType: 'sum'},
			{dataIndex: 'REMARK'						, width: 100, hidden: true},
			{dataIndex: 'ACC_GU'						, width: 100},
			{dataIndex: 'ITEM_CODE'		, width: 100,
				editor: Unilite.popup('ITEM_G',{
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					autoPopup: true,
					listeners:{ 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)  {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE','');
							grdRecord.set('ITEM_NAME','');
						}
					}
				})
			},		
			{dataIndex: 'ITEM_NAME'		, width: 150,
				editor: Unilite.popup('ITEM_G',{
					autoPopup: true,
					listeners:{ 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)  {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE','');
							grdRecord.set('ITEM_NAME','');
						}
					}
				})
			},		
			/* 20161024 추가 */
			{ dataIndex: 'PJT_CODE'						, width:80 ,
				editor: Unilite.popup('PROJECT_G',{
					textFieldName	: 'PJT_CODE',
					DBtextFieldName	: 'PJT_CODE',
					autoPopup: true,
					listeners:{ 'onSelected': {
						fn: function(records, type  ){
							var grdRecord;
							var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('PJT_CODE',records[0]['PJT_CODE']);
							grdRecord.set('PJT_NAME',records[0]['PJT_NAME']);
						},
						scope: this
					},
					  'onClear' : function(type) {
							var grdRecord;
							var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('PJT_CODE','');
							grdRecord.set('PJT_NAME','');
						}
					}
				})
			},
			{ dataIndex: 'PJT_NAME'						, width:110,
				editor: Unilite.popup('PROJECT_G',{
					autoPopup: true,
					listeners:{ 'onSelected': {
						fn: function(records, type  ){
							var grdRecord;
							var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('PJT_CODE',records[0]['PJT_CODE']);
							grdRecord.set('PJT_NAME',records[0]['PJT_NAME']);
						},
						scope: this
					},
					  'onClear' : function(type) {
							var grdRecord;
							var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('PJT_CODE','');
							grdRecord.set('PJT_NAME','');
						}
					}
				})
			},
			/* 20161221 추가 */
			{ dataIndex: 'ORG_ACCNT'				, width:100		, align:'center',
				editor:Unilite.popup('ACCNT_G', {
					textFieldName	: 'ACCNT_NAME',
					DBtextFieldName	: 'ACCNT_NAME',
					autoPopup		: true,
					listeners:{
						scope:this,
						onSelected:function(records, type ) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ORG_ACCNT'		, records[0].ACCNT_CODE);
							grdRecord.set('ORG_ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear:function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ORG_ACCNT'		, '');
							grdRecord.set('ORG_ACCNT_NAME'	, '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N'"
//									'CHARGE_CODE': getChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
			{ dataIndex: 'ORG_ACCNT_NAME'			, width:150,
				editor	: Unilite.popup('ACCNT_G', {
					textFieldName	: 'ACCNT_NAME',
					DBtextFieldName	: 'ACCNT_NAME',
					autoPopup		: true,
					listeners:{
						scope:this,
						onSelected:function(records, type ) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ORG_ACCNT'		, records[0].ACCNT_CODE);
							grdRecord.set('ORG_ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear:function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ORG_ACCNT'		, '');
							grdRecord.set('ORG_ACCNT_NAME'	, '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N'"
//									'CHARGE_CODE': getChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
			{ dataIndex: 'REMARK'					, width:110},
			{dataIndex: 'EX_DATE'					, width: 100},
			{dataIndex: 'EX_NUM'					, width: 100},
			{dataIndex: 'AC_DATE'					, width: 100},
			{dataIndex: 'SLIP_NUM'					, width: 100},
			{dataIndex: 'AGREE_YN'					, width: 100},
			{dataIndex: 'COMP_CODE'					, width: 100, hidden: true},
			{dataIndex: 'INPUT_PGMID'				, width: 100, hidden: true},
			{dataIndex: 'SUPP_TYPE'					, width: 100, hidden: true},
			{dataIndex: 'SEQ'						, width: 80, hidden: true},
			{dataIndex: 'CLOSE_YN'					, width: 80	, align:'center'},	//20210610 추가
			{dataIndex: 'CLOSE_DATE'				, width: 80}					//20210610 추가
		],
		listeners: {
			rowclick: function( grid, record, tr, rowIndex, e, eOpts ) {
				var count = masterGrid.getStore().getCount();
				if(count > 0) {
					var grdRecord		= masterGrid.uniOpt.currentRecord;			//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
					var payYYYY			= grdRecord.get('PAY_YYYYMM'); 
					var selectPayYYYYMM = payYYYY.replace('.','');

					var param = { "S_COMP_CODE": UserInfo.compCode, "PAY_YYYYMM" : selectPayYYYYMM };
					hpb310ukrService.fnHpb310nChkQ(param, function(provider, response){
						if(!Ext.isEmpty(provider)){
							prov_Tax_Yyyymm = provider.TAX_YYYYMM;
						}
						else{
							prov_Tax_Yyyymm = '';
						}
					});
				}
			},
			beforeedit: function( editor, e, eOpts ) {
				//20210610 추가: 마감된 데이터는 수정 불가
				if(e.record.data.CLOSE_YN == 'Y') {
					return false;
				}
				var payYYYY		= e.record.data.PAY_YYYYMM;
				var strPayYYYY	= payYYYY.substring(0,4);

				if(UniUtils.indexOf(e.field, ['PRIZE_CODE'])){ // 상품코드
					if(strPayYYYY < '2012'){
						if(e.record.data.DED_TYPE == ''){
							alert(Msg.sMH1466);			// 소득코드를 먼저 입력하세요.
							return false;
						}
					}else{
						if(e.record.data.DED_TYPE == ''){
							alert(Msg.sMH1466);			// 소득코드를 먼저 입력하세요.
							return false;
						}
						if(e.record.data.INCOME_KIND == ''){
							alert(Msg.fsbMsgH0374);		// 소득종류를 먼저 입력하세요.
							return false;
						}
						if(gsInComeKind == ''){
										gsInComeKind = e.record.data.INCOME_KIND;
										
										if(gsInComeKind == ''){
											return false;
										}
										
										if(gsInComeKind == '13' || gsInComeKind == '14' || gsInComeKind == '17'){
											gsInComeKind = 'A';
										}else if(gsInComeKind == '11' || gsInComeKind == '12' || gsInComeKind == '15' || gsInComeKind == '16'){
											gsInComeKind = 'B';
										}else if(gsInComeKind == '19' || gsInComeKind == '20' ){
											gsInComeKind = 'C';
										}else if(gsInComeKind == '25'){
											gsInComeKind = 'D';
										}else if(gsInComeKind == '51' || gsInComeKind == '56' ){
											gsInComeKind = 'E';
										}else if(gsInComeKind == '53'){
											gsInComeKind = 'F';
										}else if(gsInComeKind == '55'){
											gsInComeKind = 'G';
										}else if(gsInComeKind == '61'){
											gsInComeKind = 'H';
										}else{
											gsInComeKind = '';
										}	
										if(gsInComeKind == ''){
											return false;
										}
							return true;
						}
					}
					return true;
				}

				if(UniUtils.indexOf(e.field, ['TAX_GUBN'])){	// 과세구분
					if(strPayYYYY < '2012'){
						if(e.record.data.DED_TYPE == ''){
							alert(Msg.sMH1466);			// 소득코드를 먼저 입력하세요.
							return false;
						}
						if(e.record.data.PRIZE_CODE == ''){
							alert(Msg.sMH1467);			// 상품코드를 먼저 입력하세요.  
							return false;
						}
					}else{
						if(e.record.data.DED_TYPE == ''){
							alert(Msg.sMH1466);			// 소득코드를 먼저 입력하세요.
							return false;
						}
						if(e.record.data.DED_CODE == ''){
							alert(Msg.fsbMsgH0375);		// 소득자코드를 먼저 입력하여 주십시오.
							return false;
						}
					}
				}
				
				if(UniUtils.indexOf(e.field, ['BU_CODE'])){	// 과세구분
					if(e.record.data.NAME == '' || e.record.data.PERSON_NUMB == '' || e.record.data.BUSINESS_TYPE == '' || e.record.data.DWELLING_YN == ''){
						alert(Msg.sMH1473);			// 소득자를 먼저 입력하세요.
						return false;
					}
					if(e.record.data.DED_TYPE == ''){
						alert(Msg.sMH1466);			// 소득코드를 먼저 입력하세요.
						return false;
					}
					if(e.record.data.PAY_YYYYMM == ''){
						alert(Msg.sMB404);			// 귀속년월을 입력하십시오
						return false;
					}
				}
				
				if(UniUtils.indexOf(e.field, ['DED_TYPE','PERSON_NUMB','NAME','DEPT_CODE', 'DEPT_NAME','EXEDEPT_CODE','EXEDEPT_NAME'
											 ,'DIV_CODE','SECT_CODE','DED_NAME','PAY_YYYYMM','SUPP_DATE', 'CHANGE_GUBN'
											 ,'ACC_GU','ITEM_CODE','ITEM_NAME'
											 ,'PJT_CODE','PJT_NAME','ORG_ACCNT','ORG_ACCNT_NAME','REMARK'
											 ,'EX_DATE','EX_NUM','AC_DATE','SLIP_NUM','AGREE_YN','COMP_CODE'
											 ,'INPUT_PGMID','SUPP_TYPE','TAX_YYYYMM','SEQ'])){
					if(e.record.phantom == true) {	
						return true;
					}
					else{
						return false;
					}
				}else{
					return true;
				}
//				if(e.record.data.INPUT_PGMID != ''){
//					if(e.record.phantom == true){
//						return true
//					}
//					else{
//						return false;
//					}
//				}else{
//					return true;
//				}
			}, 
			edit: function(editor, e) {
				var fieldName = e.field;
				var num_check = /[0-9]/;
				var date_check01 = /^(19|20)\d{2}.(0[1-9]|1[012])$/;
				var date_check02 = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
				switch (fieldName) {
				  /*  case 'PERSON_NUMB':
				   case 'NAME':
					  //if(e.record.data.DED_CODE == '61' && e.record.data.DWELLING_YN  = '1' ){
						  if(e.record.data.PERSON_NUMB  == '033' ){
							  //Ext.getCmp('EXPS_PERCENT_I_G').setValue("80");
							  var combo = e.grid.columns[e.colIdx].getEditor(e.record);
							  combo.setValue("80");
							  //e.record.set('EXPS_PERCENT_I', EXPS_PERCENT_I);
						  }
					  
					   break;  */
					case 'PAY_YYYYMM':
						if (e.record.data.PAY_YYYYMM != null && e.record.data.PAY_YYYYMM != '' ) {
							if (!date_check01.test(e.value)) {
								Ext.Msg.alert('확인', '날짜형식이 잘못되었습니다.');
								e.record.set(fieldName, e.originalValue);
								return false;
							} else {
								e.record.set('SUPP_DATE', e.record.data.PAY_YYYYMM + '.01');
								e.record.set('RECE_DATE', e.record.data.PAY_YYYYMM + '.01');
							}
						}
						break;
					case 'SUPP_DATE':
						if (e.record.data.SUPP_DATE != null && e.record.data.SUPP_DATE != '' ) {
							e.record.set('RECE_DATE', e.record.data.SUPP_DATE);
						}
						break;
					case 'RECE_DATE': // Do nothing!!
						break;
					case 'DATE_TO_YYMM':
						break;
						
					case 'PAY_AMOUNT_I':
					case 'EXPS_AMOUNT_I':
					case 'SP_TAX_I':
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMB075);
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						fnTaxCalc(e.record);
						break;
					case 'IN_TAX_I':
					case 'CP_TAX_I':
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMB075);
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						fnTotCalc(e);
						break;	
					case 'LOCAL_TAX_I':
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMB075);
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						fnTotCalcLoc(e);
						break;		
					case 'INTER_RATE':
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMB075);
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						break;		
					case 'PERCENT_I':
					case 'EXPS_PERCENT_I':
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMB075);
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						fnTaxCalc(e.record);
						break;
					case 'CHANGE_GUBN':
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMH1465);
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						break;
					default:
						break;
				}
			}
		}
	});  
	
	Unilite.Main({
		id			: 'hpb310App',
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
		fnInitBinding : function() {
			if (!Ext.isEmpty(Ext.data.StoreManager.lookup('CBS_AU_HS12').getAt(0))) {
				panelSearch.setValue('DED_TYPE',Ext.data.StoreManager.lookup('CBS_AU_HS12').getAt(0).get('value'));
				panelResult.setValue('DED_TYPE',Ext.data.StoreManager.lookup('CBS_AU_HS12').getAt(0).get('value'));
			}
			
			if (!Ext.isEmpty(Ext.data.StoreManager.lookup('billDivCode').getAt(0))) {
				panelSearch.setValue('SECT_CODE',Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
				panelResult.setValue('SECT_CODE',Ext.data.StoreManager.lookup('billDivCode').getAt(0).get('value'));
			}
			
			panelSearch.setValue('DVRY_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('DVRY_DATE_TO', UniDate.get('today'));
			panelResult.setValue('DVRY_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('DVRY_DATE_TO', UniDate.get('today'));
			
			//panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			//panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			
			//panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			//panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('newData', true);
		},
		onQueryButtonDown : function() {
			directMasterStore.loadStoreRecords();
			
			var viewLocked = masterGrid.getView();

			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onNewDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			var date		= new Date(panelSearch.getForm().findField('DVRY_DATE_FR').getValue());
			var year		= date.getFullYear();
			var mon			= date.getMonth() + 1;
			var dvry_date_fr= year + '.' + (mon > 9 ? mon : '0' + mon);
			var supp_date	= panelSearch.getForm().findField('SUPP_DATE').getValue();

			var record = {
					DED_TYPE			: panelSearch.getForm().findField('DED_TYPE').getValue(),
					PAY_YYYYMM			: dvry_date_fr,
					SUPP_DATE			: supp_date,
					RECE_DATE			: supp_date,
					WORK_TIME			: 0,
					PAY_AMOUNT_I		: 0,
					PERCENT_I			: 14,
					INTER_RATE			: 0,
					IN_TAX_I			: 0,
					LOCAL_TAX_I			: 0,
					DED_AMOUNT_I		: 0,
					REAL_SUPP_TOTAL_I	: 0,
					SUPP_TOTAL_I		: 0,
					EXPS_AMOUNT_I		: 0,
					EXPS_PERCENT_I		: 0,
					CP_TAX_I			: 0,
					SP_TAX_I			: 0,
					ACC_GU				: '01'
			};
			masterGrid.createRow(record ,'NAME');
			UniAppManager.setToolbarButtons('delete', true);

//			var grdRecord		= masterGrid.getSelectionModel().getSelection()[0];	//20210610 주석
//			var payYYYY			= grdRecord.get('PAY_YYYYMM'); 						//20210610 주석
			var payYYYY			= dvry_date_fr;										//20210610 추가
			var selectPayYYYYMM = payYYYY.replace('.','');	

			var param = { "S_COMP_CODE": UserInfo.compCode, "PAY_YYYYMM": selectPayYYYYMM };
			hpb310ukrService.fnHpb310nChkQ(param, function(provider, response){	
				if(!Ext.isEmpty(provider)){
					prov_Tax_Yyyymm = provider.TAX_YYYYMM;
				}
				else{
					prov_Tax_Yyyymm = '';
				}
			});
			//UniAppManager.setToolbarButtons('save', true);
		},
		onDeleteDataButtonDown: function() {		//20210610 수정: 삭제로직 수정 - 여러개 선택하여 삭제할 수 있으므로 해당 로직에 맞게 수정
			if (masterGrid.getStore().getCount == 0) return;
			//20210610 추가: 마감일 때는 삭제 불가능
			var records = masterGrid.getSelectedRecords();
			var errFlag = false;
			Ext.each(records, function(record, index) {
				if(record.get('CLOSE_YN') == 'Y') {
					Unilite.messageBox('마감된 데이터는 삭제할 수 없습니다.');
					errFlag = true;
					return false;
				}
				if(!Ext.isEmpty(record.get('EX_DATE'))){
					Unilite.messageBox(Msg.sMA0408); //자동기표가 완료된 건입니다.
					errFlag = true;
					return false;
				}
				//자료가 입력되어있는 행이면 삭제메세지를 보낸 후
				//저장버튼을 눌러 DB 삭제한다.
				if(!Ext.isEmpty(record.get('INPUT_PGMID'))){
					Unilite.messageBox(Msg.fsbMsgH0377);
					errFlag = true;
					return false;
				}
				if(!Ext.isEmpty(record.get('AC_DATE'))){
					Unilite.messageBox("결재 된 데이터는 삭제할 수 없습니다.");
					errFlag = true;
					return false;
				}
			});
			if(errFlag) {
				return false;
			}
			Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					masterGrid.deleteSelectedRow();
					UniAppManager.setToolbarButtons('save', true);
				}
			});
			if (masterGrid.getStore().getCount() == 0) {
				UniAppManager.setToolbarButtons('delete', false);
			}
		},
		onSaveDataButtonDown : function() {
			if (masterGrid.getStore().isDirty()) {
				masterGrid.getStore().saveStore();
			}
		}
	});
	// 합계액 계산
	function fnTotCalc(e) {
		 // 지급액 * 세율 = 소득세,주민세
		 var defInTax = 0;
		 var localTax = 0;
		 
		 // 소득세, 주민세
		 // 법인세는 법인활동에 의해서 생기는 소득에대해서 내는것
		 if (e.record.data.BUSINESS_TYPE != '1') {
			 defInTax = e.record.data.IN_TAX_I;
			 if (defInTax > 0) {
				 defInTax = Math.floor(defInTax / 10) * 10;
				 localTax = Math.floor(((defInTax * 10) / 100) / 10) * 10;
			 }
		 } else {
			 defInTax = e.record.data.CP_TAX_I;
			 localTax = e.record.data.LOCAL_TAX_I;
			 localTax =0;
		 }
		 // 공제액
		 e.record.set('DED_AMOUNT_I', defInTax + localTax + e.record.data.SP_TAX_I);
		 // 실지급액
		 e.record.set('REAL_SUPP_TOTAL_I', e.record.data.PAY_AMOUNT_I - e.record.data.DED_AMOUNT_I);
	 }
	
	// 주민세 수정시 합계 계산
	function fnTotCalcLoc(e) {
		 // 지급액 * 세율 = 소득세,주민세
		 var defInTax = 0;
		 var localTax = 0;
		 
		 // 소득세, 주민세
		 // 법인세는 법인활동에 의해서 생기는 소득에대해서 내는것
		 if (e.record.data.BUSINESS_TYPE != '1') {
			 defInTax = e.record.data.IN_TAX_I;
			 if (defInTax != 0) {
				 localTax = e.record.data.LOCAL_TAX_I;
			 } else {
				 localTax = 0;
			 }
		 } else {
			 defInTax = e.record.data.CP_TAX_I;
			 if (defInTax != 0) {
				 localTax = e.record.data.LOCAL_TAX_I;
			 } else {
				 localTax = 0;
			 }
		 }
		 
		 // 공제액
		 e.record.set('DED_AMOUNT_I', defInTax + localTax + e.record.data.SP_TAX_I);
		 // 실지급액
		 e.record.set('REAL_SUPP_TOTAL_I', e.record.data.PAY_AMOUNT_I - e.record.data.DED_AMOUNT_I);
	 }
	
	 // 세금 계산
	 function fnTaxCalc(e) {
		 // 필요경비
		 var expsRate = e.data.EXPS_PERCENT_I;
		 var expsAmount = Math.floor(e.data.PAY_AMOUNT_I * (expsRate / 100));
		 expsAmount = Math.floor(expsAmount/10) * 10;
		 e.set('EXPS_AMOUNT_I', expsAmount);
		 
		 // 지급액 * 세율 = 소득세,주민세
		 var defInTax = 0;
		 var localTax = 0;
		 var pay = e.data.PAY_AMOUNT_I - e.data.EXPS_AMOUNT_I;
		 var rate = e.data.PERCENT_I;
		 defInTax = Math.floor(pay * (rate / 100));
		 
		 if (defInTax < 1000) {
			 defInTax = 0;
		 }
		 
		 if (defInTax > 0) {
			 defInTax = Math.floor(defInTax /10) * 10;
			 localTax = Math.floor(((defInTax * 10) / 100) / 10) * 10;
		 }
		 
		 // 소득금액
		 e.set('SUPP_TOTAL_I', pay);
		 
		 // 소득세, 주민세
		 // 법인세는 법인활동에 의해서 생기는 소득에대해서 내는것
		 if (e.data.BUSINESS_TYPE != '1') {
			 e.set('IN_TAX_I', defInTax);
			 e.set('CP_TAX_I', 0);
			 e.set('LOCAL_TAX_I', localTax);
		 } else {
			 e.set('IN_TAX_I', 0);
			 e.set('CP_TAX_I', defInTax);
			 e.set('LOCAL_TAX_I', localTax);
//			 e.set('IN_TAX_I', 0);
//			 e.set('LOCAL_TAX_I', Math.floor((defInTax - Math.round(defInTax / 1.1)) / 10) * 10);
////			 e.set('LOCAL_TAX_I', 0);
//			 e.set('CP_TAX_I', defInTax - e.data.LOCAL_TAX_I);
//			 
//			 localTax = 0;
		 } 
		 
		 // 공제액
		 e.set('DED_AMOUNT_I', defInTax + localTax + e.data.SP_TAX_I);
		 
		 // 실지급액
		 e.set('REAL_SUPP_TOTAL_I', e.data.PAY_AMOUNT_I - e.data.DED_AMOUNT_I);
	 }
	 
	 /*Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
	
			var rv = true;
			var gsInComeKind  = record.get('INCOME_KIND');
			var payYYYY 	 = record.get('PAY_YYYYMM');
			var strPayYYYY   = payYYYY.substring(0,4);
			
			var name 		 = record.get('NAME');
			var personNumb   = record.get('PERSON_NUMB');
			var businessType = record.get('BUSINESS_TYPE');
			var dwellingYn   = record.get('DWELLING_YN');
			var buCode		 = record.get('BU_CODE');
			var dedType	  = record.get('DED_TYPE');
			var prizeCode	= record.get('PRIZE_CODE');
			
			var sPrizeCode   = prizeCode.substring(1,3);
			
			var selectPayYYYYMM = payYYYY.replace('.','');
			switch(fieldName) {

				case "INCOME_KIND" : // 소득종류			
					if(gsInComeKind == '13' || gsInComeKind == '14' || gsInComeKind == '17'){
						gsInComeKind = 'A';
					}else if(gsInComeKind == '11' || gsInComeKind == '12' || gsInComeKind == '15' || gsInComeKind == '16'){
						gsInComeKind = 'B';
					}else if(gsInComeKind == '19' || gsInComeKind == '20' ){
						gsInComeKind = 'C';
					}else if(gsInComeKind == '25'){
						gsInComeKind = 'D';
					}else if(gsInComeKind == '51' || gsInComeKind == '56' ){
						gsInComeKind = 'E';
					}else if(gsInComeKind == '53'){
						gsInComeKind = 'F';
					}else if(gsInComeKind == '55'){
						gsInComeKind = 'G';
					}else if(gsInComeKind == '61'){
						gsInComeKind = 'H';
					}else{
						gsInComeKind = '';
					}
					
					if(record.get('INCOME_KIND') == ''){
						record.set('PRIZE_CODE' ,'');
					}
					break;
				
				case "TAX_GUBN" : // 과세구분
					if(newValue){
						var dedType = record.get('DED_TYPE');
						var dedCode = record.get('DED_CODE');
						var sRefCode = '';
						if(strPayYYYY < "2012"){
							switch(dedType){
								case "10" :
									sRefCode = test123  // 과세구분(HC02) REF_CODE3
									if(sRefCode == ''){
										alert(Msg.sMH1468); 	//이자 소득코드를 확인하세요. 
										return false;
									}
									break;
								
									switch(businessType){
										case "1" : 
										
											if(sRefCode == '110' || sRefCode == '120' || sRefCode == '121' || 
											   sRefCode == '131' || sRefCode == '134' || sRefCode == '142' ){
													alert(Msg.sMH1469);	// 법인 과세구분코드를 확인하세요.
													return false;
											   }break;
											 
										case "2" : 
										
											if(sRefCode == '150' || sRefCode == '160' || sRefCode == '170' || sRefCode == '180'){
													alert(Msg.sMH1470);	// 개인 과세구분코드를 확인하세요.
													return false;
											   }break;
										
									}break;	
									if(sPrizeCode != ''){
										if(sPrizeCode == 'MA'){
											if(sRefCode == '131'){
												record.set('TAX_GUBN', ''+ sRefCode );
											}else{
												alert(Msg.sMH1471);  // 131 과세구분코드를 확인하세요.
											}
										}else{
											record.set('TAX_GUBN', '' + sRefCode );
										}
									}
									if(sRefCode != ''){
										if(sRefCode == '120'){
											record.set('TAX_GUBN', '30');	
										}else if(sRefCode == '131'){
											record.set('TAX_GUBN', '25');	
										}
									}
								break;
								
								case "20" :	
									//sRefCode = gaPopUp(5);
								
								
									if(sRefCode == ''){
										alert(Msg.sMH1459); 	//소득 구분을 확인하세요
										return false;
									}
									break;
									switch(businessType){
										case "1" :
											if(sRefCode == '210' || sRefCode == '211' || sRefCode == '220' || 
											   sRefCode == '221' || sRefCode == '232' || sRefCode == '233' || sRefCode == '234' || sRefCode == '235' || sRefCode == '236' ||  
											   sRefCode == '237' || sRefCode == '238' || sRefCode == '239' || sRefCode == '241' || sRefCode == '242' || sRefCode == '243' ||
											   sRefCode == '244' || sRefCode == '245' || sRefCode == '247'){
													alert(Msg.sMH1469);	// 법인 과세구분코드를 확인하세요.
													return false;
											}break;
										case "2" :
											if(sRefCode == '250' || sRefCode == '260' || sRefCode == '270' || sRefCode == '280'){
													alert(Msg.sMH1470);	// 개인 과세구분코드를 확인하세요.
													return false;
											}break;
											
										if(sPrizeCode != ''){
											if(sPrizeCode == 'MA' || sPrizeCode == 'LB'){
												if(sRefCode == '232' || sRefCode == '238' || sRefCode == '235' || sRefCode == '244'){
													record.set('TAX_GUBN', ''+ sRefCode );
												}else{
													alert(Msg.sMH1472);  // 과세구분코드를 확인하세요.
												}
											}else if(sPrizeCode == 'LC'){
												if(sRefCode == '233' || sRefCode == '239' || sRefCode == '236' || sRefCode == '245'){
													record.set('TAX_GUBN', ''+ sRefCode );
												}else{
													alert(Msg.sMH1472);  // 과세구분코드를 확인하세요.
												}
											}else{
												record.set('TAX_GUBN', '' + sRefCode );
											}
										}break;
									}
							}
						}else{
							if(dedType == ''){
								alert(Msg.sMH1466);	// 소득코드를 먼저 입력하세요.
								return false;
							}
							if(dedCode == ''){
								alert(Msg.fsbMsgH0375);	// 소득자코드를 먼저 입력하여 주십시오.
								return false;
							}
							
							var sDedCode = record.get('DED_CODE');
							sDedCode	 = sDedCode.substring(0, 1);
							
							var sTaxGubn = record.get('TAX_GUBN');
							var sBusinessType = record.get('BUSINESS_TYPE');
							
							
							if(sBusinessType == '1'){
								if(sTaxGubn == "C" || sTaxGubn == "X" || sTaxGubn == "F" || sTaxGubn == "I" || sTaxGubn == "W"){
									if(sDedCode != '2' && sDedCode != '4'){
										alert(Msg.fsbMsgH0376); // 과세구분을 잘못 선택하셨습니다. 소득구분을 확인하여 주세요.
										return false;
									}
								}
								else if(sTaxGubn == "E" || sTaxGubn == "L" || sTaxGubn == "H" || sTaxGubn == "O" || sTaxGubn == "B" || sTaxGubn == "I"){
									if(sDedCode != '1' && sDedCode != '3' && sDedCode != '4'){
										alert(Msg.fsbMsgH0376); // 과세구분을 잘못 선택하셨습니다. 소득구분을 확인하여 주세요.
										return false;
									}
								
								}
							}
						}	
					}
				
				break;
			}
			return rv;
		}
	}); // validator
*/

	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
	
			var rv = true;
//			var grdRecord		= masterGrid.getSelectionModel().getSelection()[0];	//20210610 주석
			var payYYYY 		= record.get('PAY_YYYYMM');							//20210610 수정 
			var selectPayYYYYMM	= payYYYY.replace('.','');
			
			switch(fieldName) {
				case "PAY_YYYYMM" : // 소득종류
					var param = { "S_COMP_CODE": UserInfo.compCode, "PAY_YYYYMM" : selectPayYYYYMM };
					hpb310ukrService.fnHpb310nChkQ(param, function(provider, response){
						if(!Ext.isEmpty(provider)){
							prov_Tax_Yyyymm = provider.TAX_YYYYMM;
						}else{
							prov_Tax_Yyyymm = '';
						}
					});
				break;
			}
			return rv;
		}
	}); // validator



	/* 마감/미마감 저장로직: 20210610 추가
	 */
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'hpb310ukrService.runClose',
			syncAll	: 'hpb310ukrService.runAll'
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
			var confirmMsg	= '';

			if(saveFlag == 'Y') {
				confirmMsg = '마감된 데이터를 취소 하시겠습니까?';
			} else {
				confirmMsg = '해당 데이터를 마감하시겠습니까?';
			}
			//작업진행 여부 확인
			if(!confirm(confirmMsg)) {
				return false;
			}
			var paramMaster		= panelSearch.getValues();
			paramMaster.CLOSE_YN= saveFlag;

			var selRecords = masterGrid.getSelectionModel().getSelection();
			Ext.each(selRecords, function(selRecord, index) {
				selRecord.phantom = true;
				buttonStore.insert(index, selRecord);
			})

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						buttonStore.clearData();
						UniAppManager.app.onQueryButtonDown();
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
};
</script>