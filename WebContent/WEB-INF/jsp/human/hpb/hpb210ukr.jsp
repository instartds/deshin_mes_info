<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpb210ukr">	
	<t:ExtComboStore comboType="AU" comboCode="HS11" includeMainCode="true"/>		<!-- 기타소득세율(거주자) -->
	<t:ExtComboStore comboType="AU" comboCode="HS10"/>								<!-- 필요경비세율 -->
	<t:ExtComboStore comboType="AU" comboCode="HS13" includeMainCode="true"/>		<!-- 비거주소득세율 -->
	<t:ExtComboStore comboType="AU" comboCode="HS15"/>								<!-- 계정구분 -->
	<t:ExtComboStore comboType="BOR120"  pgmId="hpb210ukr"/>						<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode"/>	<!-- 신고사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {
	var gsDED_TYPE ='2'
	var autoHidden = false;
	if(gsDED_TYPE != '2') {
		autoHidden = true;
	}

	var ApprovalYnStore = Ext.create('Ext.data.Store', {
		id		: 'comboStore',
		fields	: ['name', 'value'],
		data	: [
			{text : '승인', value: '1'},
			{text : '미승인', value: '2'}
		]
	});

	var CbsStore = Ext.create('Ext.data.Store', {
		id		: 'comboStoreCBS',
		fields	: ['name', 'value'],
		data	: [].concat(Ext.data.StoreManager.lookup('CBS_MAIN_AU_HS11').getData().items).concat(Ext.data.StoreManager.lookup('CBS_MAIN_AU_HS13').getData().items)
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpb210ukrService.selectList',
			update	: 'hpb210ukrService.updateDetail',
			create	: 'hpb210ukrService.insertDetail',
			destroy	: 'hpb210ukrService.deleteDetail',
			syncAll	: 'hpb210ukrService.saveAll'
		}
	});

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpb210ukrModel', {
		fields: [
			{name: 'DED_TYPE'				, text: 'DED_TYPE'			, type: 'string'},
			{name: 'PERSON_NUMB'			, text: '소득자코드'				, type: 'string', allowBlank: false , maxLength: 10},
			{name: 'NAME'					, text: '성명'				, type: 'string', allowBlank: false , maxLength: 16},
			{name: 'BUSINESS_TYPE'			, text: '법인/개인'				, type: 'string'},
			{name: 'DWELLING_YN'			, text: '거주구분'				, type: 'string'},
			{name: 'DEPT_CODE'				, text: '부서코드'				, type: 'string'},
			{name: 'DEPT_NAME'				, text: '부서명'				, type: 'string'},
			{name: 'EXEDEPT_CODE'			, text: '비용집행부서'			, type: 'string'},
			{name: 'EXEDEPT_NAME'			, text: '비용집행부서명'			, type: 'string'},
			{name: 'DIV_CODE'				, text: '소속사업장'				, type: 'string' , allowBlank: false , comboType: "BOR120"},
			{name: 'SECT_CODE'				, text: '신고사업장'				, type: 'string'},
			{name: 'DED_CODE'				, text: '소득코드'				, type: 'string', allowBlank: false},
			{name: 'DED_NAME'				, text: '소득코드명'				, type: 'string'},
			{name: 'PAY_YYYYMM'				, text: '귀속년월'				, type: 'string',  allowBlank: false},
			{name: 'WORK_TIME'				, text: '기준시간'				, type: 'string' , maxLength: 6},
			{name: 'SUPP_DATE'				, text: '지급일자'				, type: 'uniDate', allowBlank: false},
			{name: 'REAL_SUPP_DATE'			, text: '실지급일'				, type: 'uniDate'},
			{name: 'RECE_DATE'				, text: '영수일자'				, type: 'uniDate', allowBlank: true},
			/* 이자배당관련 숨김 */
			{name: 'INCOME_KIND'			, text: '소득종류'				, type: 'string' , comboType: 'AU', comboCode: 'HC05'},
			{name: 'TAX_EXCEPTION'			, text: '조세특례'				, type: 'string' , comboType: 'AU', comboCode: 'HC06'},
			{name: 'PRIZE_CODE'				, text: '상품코드'				, type: 'string'},
			{name: 'TAX_GUBN'				, text: '과세구분'				, type: 'string' , comboType: 'AU', comboCode: 'HC02'},
			{name: 'CLAIM_INTER_GUBN'		, text: '채권이자구분'			, type: 'string' , comboType: 'AU', comboCode: 'HC03'},
			{name: 'WERT_PAPER_CODE'		, text: '유가증권표준코드'			, type: 'string'},
			{name: 'BU_CODE'				, text: '원천징수이행상황 신고서부표코드'	, type: 'string'},
			{name: 'CHANGE_GUBN'			, text: '변동구분'				, type: 'string'},
			{name: 'DATE_FROM_YYMM'			, text: '이자지급대상기간FROM'		, type: 'string'},
			{name: 'DATE_TO_YYMM'			, text: '이자지급대상기간TO'		, type: 'string'},
			{name: 'INTER_RATE'				, text: '이자율'				, type: 'uniER'},
			{name: 'PAY_AMOUNT_I'			, text: '지급액'				, type: 'uniPrice', allowBlank: true , maxLength: 18},
			{name: 'EXPS_PERCENT_I'			, text: '경비세율'				, type: 'string',   allowBlank: true , comboType:'AU', comboCode:'HS10'},
			{name: 'EXPS_AMOUNT_I'			, text: '필요경비'				, type: 'uniPrice', allowBlank: true , maxLength: 18},
			{name: 'SUPP_TOTAL_I'			, text: '소득금액'				, type: 'uniPrice', maxLength: 18},
			{name: 'PERCENT_I'				, text: '세율(%)'				, type: 'string',   allowBlank: true , maxLength: 2 ,store: Ext.data.StoreManager.lookup('comboStoreCBS')},
			{name: 'IN_TAX_I'				, text: '소득세'				, type: 'uniPrice', allowBlank: true , maxLength: 14},
			{name: 'CP_TAX_I'				, text: '법인세'				, type: 'uniPrice', allowBlank: true , maxLength: 14},
			{name: 'SP_TAX_I'				, text: '농특세'				, type: 'uniPrice', maxLength: 14},
			{name: 'LOCAL_TAX_I'			, text: '주민세'				, type: 'uniPrice', allowBlank: true , maxLength: 14},
			{name: 'TAX_CUT_REASON'			, text: '세액감면및 제한세율 근거'		, type: 'string'},
			{name: 'DED_AMOUNT_I'			, text: '공제액'				, type: 'uniPrice'},
			{name: 'REAL_SUPP_TOTAL_I'		, text: '차인지급액'				, type: 'uniPrice'}, 
			{name: 'REMARK'					, text: '비고'				, type: 'string'}, 
			{name: 'ACC_GU'					, text: '계정구분'				, type: 'string',  allowBlank: false, comboType: 'AU', comboCode: 'HS15'},
			{name: 'ITEM_CODE'				, text: '품목코드'				, type: 'string'  },
			{name: 'ITEM_NAME'				, text: '품목명'				, type: 'string'  },
			/* 20161022 추가 */
			{name: 'PJT_CODE'				, text: '사업코드' 				, type: 'string'  },
			{name: 'PJT_NAME'				, text: '사업명' 				, type: 'string'  },
			/* 20161221 추가 */
			{name: 'ORG_ACCNT'				, text: '본계정' 				, type: 'string'  },
			{name: 'ORG_ACCNT_NAME'			, text: '본계정명'				, type: 'string'  },
			{name: 'REMARK'					, text: '적요' 				, type: 'string'  },
			{name: 'EX_DATE'				, text: '결의전표일'				, type: 'uniDate'}, 
			{name: 'EX_NUM'					, text: '결의전표번호'			, type: 'string'}, 
			{name: 'AC_DATE'				, text: '회계전표일'				, type: 'uniDate'}, 
			{name: 'SLIP_NUM'				, text: '회계전표번호'			, type: 'string'}, 
			{name: 'AGREE_YN'				, text: '승인여부'				, type: 'string' , store: Ext.data.StoreManager.lookup('comboStore')}, 
			{name: 'COMP_CODE'				, text: '법인코드'				, type: 'string'}, 
			{name: 'INPUT_PGMID'			, text: '입력경로'				, type: 'string'},
			{name: 'SUPP_TYPE'				, text: '참조정보'				, type: 'string'},
			{name: 'PERCENT_I2'				, text: '이자율 로직용'			, type: 'string'},
			{name: 'SEQ'					, text: 'SEQ'				, type: 'int'},
			{name: 'CLOSE_YN'				, text: '<t:message code="system.label.human.deadlineyn" default="마감여부"/>'	, type: 'string', comboType: 'AU', comboCode: 'H153', editable: false},		//20210609 추가: 마감기능 추가, 마감인 데이터는 수정 불가
			{name: 'CLOSE_DATE'				, text: '<t:message code="system.label.sales.closingdate" default="마감일"/>'	, type: 'uniDate', editable: false}											//20210609 추가: 마감기능 추가, 마감인 데이터는 수정 불가
		]
	});		

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('hpb210MasterStore',{
		model: 'Hpb210ukrModel',
		uniOpt: {
			isMaster: true,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,		// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 ) {
				this.syncAll({
					success: function(response) {
						UniAppManager.setToolbarButtons('save', false);
						directMasterStore.loadStoreRecords();
					},
					failure: function(response) {
						UniAppManager.setToolbarButtons('save', true); 
					}
				});
			}else {
				alert(Msg.sMB083);
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
				fieldLabel: '소득자코드',
				name: 'DED_TYPE', 
				xtype: 'hiddenfield',
				allowBlank: false,
				value:'2'
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
						panelResult.setValue('ACCNT_NAME', '');
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
				listeners		: {
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
			}),{
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
			fieldLabel: '신고사업장',
			name: 'SECT_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode: 'BILL',
			allowBlank: false,
//			tdAttrs: {width: 380},		//20210609 주석
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
//			readOnly: true,
			allowBlank: false,
//			tdAttrs: {width: 380}		//20210609 주석
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
//			tdAttrs: {width: 380},		//20210609 주석
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
//			tdAttrs: {width: 380},		//20210609 주석
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
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
						popup.setExtParam({'SECT_CODE': panelSearch.getValue('SECT_CODE')});	//신고사업장
					}
				}
		}),{
			fieldLabel: '소득자코드',
			name: 'DED_TYPE', 
			xtype: 'hiddenfield',
			allowBlank: false,
			value:'2'
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
			xtype: 'component'
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: '적요',
			name		: 'REMARK',
			width		: 650,			//20210609 수정: '60%' -> 650
			colspan		: 3,			//20210609 수정: 4 -> 3
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('REMARK', newValue);
				}
			}
		},{	//20210609 추가: 마감 / 마감취소 기능 추가
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
	var masterGrid = Unilite.createGrid('hpb210Grid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			copiedRow			: true,
			onLoadSelectFirst	: false,	//20210609 추가
			useGroupSummary		: true
//			useContextMenu		: true,
		},
		//20210609 추가
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
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: true, dock: 'top', align:'right'} 
		],
		columns: [{
				//20210609 추가
				xtype	: 'rownumberer',
				sortable: false,
				align	: 'center !important',
				resizable: true,
				width	: 35
			},
			{dataIndex: 'DED_TYPE'					, width: 20, hidden: true},
			{dataIndex: 'PERSON_NUMB'				, width: 100
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) 
				{
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계')
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
								grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
								grdRecord.set('SECT_CODE', records[0].SECT_CODE);
								grdRecord.set('BUSINESS_TYPE', records[0].BUSINESS_TYPE);
								grdRecord.set('DWELLING_YN', records[0].DWELLING_YN);
								grdRecord.set('EXEDEPT_CODE', records[0].EXEDEPT_CODE);
								grdRecord.set('EXEDEPT_NAME', records[0].EXEDEPT_NAME);
								
								if(records[0].EXPS_PERCENT == '')
								{
									grdRecord.set('EXPS_PERCENT_I', '0');
								}
								else
								{
									grdRecord.set('EXPS_PERCENT_I', records[0].EXPS_PERCENT);
								}
								//grdRecord.set('EXPS_PERCENT_I', records[0].EXPS_PERCENT);
							},
						scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;			//20210610 수정: masterGrid.getSelectionModel().getSelection()[0]; -> masterGrid.uniOpt.currentRecord;
							grdRecord.set('DED_TYPE', '');
							grdRecord.set('PERSON_NUMB', '');
							grdRecord.set('NAME', '');
							grdRecord.set('DED_CODE', '');
							grdRecord.set('DED_NAME', '');
							grdRecord.set('DEPT_CODE', '');
							grdRecord.set('DIV_CODE', '');
							grdRecord.set('DEPT_CODE', '');
							grdRecord.set('DEPT_NAME', '');
							grdRecord.set('SECT_CODE', '');
							grdRecord.set('BUSINESS_TYPE', '');
							grdRecord.set('DWELLING_YN', '');
							grdRecord.set('EXEDEPT_CODE', '');
							grdRecord.set('EXEDEPT_NAME', '');
							grdRecord.set('EXPS_PERCENT_I','0');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
						}
					}
				})
			},
			{dataIndex: 'NAME'							, width: 100, summaryType: 'count'
			,summaryRenderer:function(value, summaryData, dataIndex, metaData)
			{
				return '<div align="right">'+value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")+' 명</div>';
			}
			,editor: Unilite.popup('EARNER_G', {
					textFieldName: 'NAME',
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
								grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
								grdRecord.set('SECT_CODE', records[0].SECT_CODE);
								grdRecord.set('BUSINESS_TYPE', records[0].BUSINESS_TYPE);
								grdRecord.set('DWELLING_YN', records[0].DWELLING_YN);
								grdRecord.set('EXEDEPT_CODE', records[0].EXEDEPT_CODE);
								grdRecord.set('EXEDEPT_NAME', records[0].EXEDEPT_NAME);
								
								if(records[0].EXPS_PERCENT == '')
								{
									grdRecord.set('EXPS_PERCENT_I', '0');
								}
								else
								{
									grdRecord.set('EXPS_PERCENT_I', records[0].EXPS_PERCENT);
								}
								
								//grdRecord.set('EXPS_PERCENT_I', records[0].EXPS_PERCENT);
								// e.grid.columns[e.colIdx].getEditor(e.record);
								console.log(masterGrid.columns);
								var combo = masterGrid.columns[32].getEditor(grdRecord);
								console.log(combo);
								combo.setValue('5');
								
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
						grdRecord.set('DEPT_CODE', '');
						grdRecord.set('DIV_CODE', '');
						grdRecord.set('DEPT_CODE', '');
						grdRecord.set('DEPT_NAME', '');
						grdRecord.set('SECT_CODE', '');
						grdRecord.set('BUSINESS_TYPE', '');
						grdRecord.set('DWELLING_YN', '');
						grdRecord.set('EXEDEPT_CODE', '');
						grdRecord.set('EXEDEPT_NAME', '');
						
						grdRecord.set('EXPS_PERCENT_I','');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
					}
				}
			})
			},
			{dataIndex: 'BUSINESS_TYPE'					, width: 73, 	hidden: true},
			{dataIndex: 'DWELLING_YN'					, width: 53, 	hidden: true},
			{dataIndex: 'DEPT_CODE'						, width: 88 ,
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
						'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE','');
							grdRecord.set('DEPT_NAME','');
						},
						applyextparam: function(popup){
						}
					}
				})
			},
			{dataIndex: 'DEPT_NAME'						, width: 150,
				editor: Unilite.popup('DEPT_G', {
	//				textFieldName: 'DEPT_NAME',
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
			{dataIndex: 'EXEDEPT_CODE'				, width: 80, 	hidden: true},
			{dataIndex: 'EXEDEPT_NAME'				, width: 100,   hidden: true},
			{dataIndex: 'DIV_CODE'					, width: 140},
			{dataIndex: 'SECT_CODE'					, width: 6, 	hidden: true},
			{dataIndex: 'DED_CODE'					, width: 60,	hidden: true},
			{dataIndex: 'DED_NAME'					, width: 200},
			{dataIndex: 'PAY_YYYYMM'				, width: 120},
			{dataIndex: 'WORK_TIME'					, width: 100,	hidden: true 
//				,renderer: function(value) {
//				return value + '.00';
//			}
			},
			{dataIndex: 'SUPP_DATE'					, width: 100}, 	
			{dataIndex: 'REAL_SUPP_DATE'			, width: 100},
			{dataIndex: 'RECE_DATE'					, width: 100},
			{dataIndex: 'INCOME_KIND'				, width: 100, hidden: true},
			{dataIndex: 'TAX_EXCEPTION'				, width: 100, hidden: true},
			{dataIndex: 'PRIZE_CODE'				, width: 100, hidden: true},
			{dataIndex: 'TAX_GUBN'					, width: 100, hidden: true},
			{dataIndex: 'CLAIM_INTER_GUBN'			, width: 100, hidden: true},
			{dataIndex: 'WERT_PAPER_CODE'			, width: 100, hidden: true},
			{dataIndex: 'BU_CODE'					, width: 100, hidden: true},
			{dataIndex: 'CHANGE_GUBN'				, width: 100, hidden: true},
			{dataIndex: 'DATE_FROM_YYMM'			, width: 100, hidden: true},
			{dataIndex: 'DATE_TO_YYMM'				, width: 100, hidden: true},
			{dataIndex: 'INTER_RATE'				, width: 100, hidden: true},
			{dataIndex: 'PAY_AMOUNT_I'				, width: 100, summaryType: 'sum'},
			{dataIndex: 'EXPS_PERCENT_I'			, width: 100 ,align : 'right' , hidden: autoHidden},
			{dataIndex: 'EXPS_AMOUNT_I'				, width: 86 , summaryType: 'sum', hidden: autoHidden}, 
			{dataIndex: 'SUPP_TOTAL_I'				, width: 86 , summaryType: 'sum', hidden: autoHidden},
			{dataIndex: 'PERCENT_I'					, width: 100 ,align : 'right'
				,editor:{
					xtype:'uniCombobox',
					store: Ext.data.StoreManager.lookup('comboStoreCBS'),
					includeMainCode:true,
					listeners:{
						beforequery:function(queryPlan, value) {
							var me = this;
							var gridRecord = masterGrid.uniOpt.currentRecord;				//20210610 수정: masterGrid.getSelectedRecord(); -> masterGrid.uniOpt.currentRecord;
							var store = queryPlan.combo.getStore();
							this.store.clearFilter();
							
							store.filterBy(function(record, id){
								if(gridRecord.get('DWELLING_YN') == '1'){
									if(record.get('value').indexOf('HS11_') > -1 ){	
										return record 			
									}
								}else if(gridRecord.get('DWELLING_YN') == '2'){
									if(record.get('value').indexOf('HS13_') > -1 ){	
										return record  
									}
								}
							});
						}
					}
				}
			},
//			{dataIndex: 'PERCENT_I2'				, width: 100, hidden: false},
			{dataIndex: 'IN_TAX_I'					, width: 100, summaryType: 'sum'},
			{dataIndex: 'CP_TAX_I'					, width: 100, summaryType: 'sum', hidden: autoHidden},
			{dataIndex: 'SP_TAX_I'					, width: 100, summaryType: 'sum', hidden: true},
			{dataIndex: 'LOCAL_TAX_I'				, width: 100, summaryType: 'sum'},
			{dataIndex: 'TAX_CUT_REASON'			, width: 100, hidden: true},
			{dataIndex: 'DED_AMOUNT_I'				, width: 100, summaryType: 'sum'},
			{dataIndex: 'REAL_SUPP_TOTAL_I'			, width: 100, summaryType: 'sum'},
			{dataIndex: 'REMARK'					, width: 100, hidden: true},
			{dataIndex: 'ACC_GU'					, width: 100},
			{dataIndex: 'ITEM_CODE'			, width: 100,
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
			{dataIndex: 'ITEM_NAME'			, width: 150,
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
			/* 20161022 추가 */
			{ dataIndex: 'PJT_CODE'						, width:80 ,
				editor: Unilite.popup('PJT_TREE_G',{
					textFieldName	: 'PJT_CODE',
					DBtextFieldName	: 'PJT_CODE',
					autoPopup: true,
					listeners:{ 'onSelected': {
						fn: function(records, type  ){
//							var grdRecord;															//20210610 주석
//							var selectedRecords = masterGrid.getSelectionModel().getSelection();
//							if(selectedRecords && selectedRecords.length > 0 ) {
//								grdRecord= selectedRecords[0];
//							}
							var grdRecord = masterGrid.uniOpt.currentRecord;						//20210610 추가: 위 로직 대신 추가
							grdRecord.set('PJT_CODE',records[0]['PJT_CODE']);
							grdRecord.set('PJT_NAME',records[0]['PJT_NAME']);
						},
						scope: this
						},
						'onClear' : function(type) {
//							var grdRecord;															//20210610 주석
//							var selectedRecords = masterGrid.getSelectionModel().getSelection();
//							if(selectedRecords && selectedRecords.length > 0 ) {
//								grdRecord= selectedRecords[0];
//							}
							var grdRecord = masterGrid.uniOpt.currentRecord;						//20210610 추가: 위 로직 대신 추가
							grdRecord.set('PJT_CODE','');
							grdRecord.set('PJT_NAME','');
						}
					}
				})
			},
			{ dataIndex: 'PJT_NAME'						, width:110,
				editor: Unilite.popup('PJT_TREE_G',{
					autoPopup: true,
					listeners:{ 'onSelected': {
						fn: function(records, type  ){
//							var grdRecord;															//20210610 주석
//							var selectedRecords = masterGrid.getSelectionModel().getSelection();
//							if(selectedRecords && selectedRecords.length > 0 ) {
//								grdRecord= selectedRecords[0];
//							}
							var grdRecord = masterGrid.uniOpt.currentRecord;						//20210610 추가: 위 로직 대신 추가
							grdRecord.set('PJT_CODE',records[0]['PJT_CODE']);
							grdRecord.set('PJT_NAME',records[0]['PJT_NAME']);
						},
						scope: this
					},
					  'onClear' : function(type) {
//							var grdRecord;															//20210610 주석
//							var selectedRecords = masterGrid.getSelectionModel().getSelection();
//							if(selectedRecords && selectedRecords.length > 0 ) {
//								grdRecord= selectedRecords[0];
//							}
							var grdRecord = masterGrid.uniOpt.currentRecord;						//20210610 추가: 위 로직 대신 추가
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
			{dataIndex: 'CLOSE_YN'					, width: 80	, align:'center'},	//20210609 추가
			{dataIndex: 'CLOSE_DATE'				, width: 80}					//20210609 추가
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				//20210609 추가: 마감된 데이터는 수정 불가
				if(e.record.data.CLOSE_YN == 'Y') {
					return false;
				}
				if(UniUtils.indexOf(e.field, ['DEPT_CODE' ,'DEPT_NAME' ,'DED_NAME' ,'EXPS_AMOUNT_I' ,'PERSON_NUMB' ,'NAME' 
											  ,'PAY_YYYYMM' ,'SUPP_DATE' ,'DED_AMOUNT_I' ,'REAL_SUPP_TOTAL_I' /*,'ACC_GU'*/ ,'EX_DATE' 
											  ,'EX_NUM' ,'AC_DATE' ,'SLIP_NUM' ,'AGREE_YN'/*,'REAL_SUPP_DATE'*/])){
					if(e.record.phantom == true) {	
							return true;
					}
					else{
						return false;
					}
				}
				if(e.record.data.INPUT_PGMID != ''){
					if(e.record.phantom == true){
						return true
					} else {
						return false;
					}
				} else {
					return true;
				}
			},
			edit: function(editor, e) {
				var fieldName = e.field;
				var num_check = /[0-9]/;
				var date_check01 = /^(19|20)\d{2}.(0[1-9]|1[012])$/;
				var date_check02 = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
				switch (fieldName) {
				/*	case 'PERSON_NUMB':
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
					case 'PAY_AMOUNT_I':
					case 'EXPS_AMOUNT_I':
					case 'SP_TAX_I':
						if(e.originalValue == e.value) {				//20210610 추가: 변경 없이 지나가도 PERCENT_I2에 값을 set하여 저장버튼 활성화 됨
							return false;
						}
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMB075);
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						var percentI = e.record.data.PERCENT_I;
						if (percentI != null && percentI != '' ) {	
							if(Ext.isEmpty(e.record.data.DWELLING_YN) || (e.record.data.DWELLING_YN == '1')){
								fanalPercnetI = percentI.replace('HS11_','');
							} else {
								fanalPercnetI = percentI.replace('HS13_','');
							}
							e.record.set('PERCENT_I2' ,fanalPercnetI);
						}
						fnTaxCalc(e.record);
						break;
					case 'PERCENT_I':
						if(e.originalValue == e.value) {				//20210610 추가: 변경 없이 지나가도 PERCENT_I2에 값을 set하여 저장버튼 활성화 됨
							return false;
						}
						var percentI = e.record.data.PERCENT_I;
						var fanalPercnetI ='';
						if (percentI != null && percentI != '' ) {	
							if(e.record.data.DWELLING_YN == '1'){
								fanalPercnetI = percentI.replace('HS11_','');
							} else {
								fanalPercnetI = percentI.replace('HS13_','');
							}
							e.record.set('PERCENT_I2' ,fanalPercnetI);
							fnTaxCalc(e.record);
						} else {
							alert('정확한 코드를 입력하여 주세요.');
						}
						break;
					case 'EXPS_PERCENT_I':
						if(e.originalValue == e.value) {				//20210610 추가: 변경 없이 지나가도 계산로직 수행 후 저장버튼 활성화 됨
							return false;
						}
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
					case 'WORK_TIME':
						if (!num_check.test(e.value)) {
							Ext.Msg.alert(Msg.sMB099, Msg.sMB075);
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
		id			: 'hpb210App',
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
//			var viewLocked = masterGrid.getView();
//			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onNewDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			var date = new Date(panelSearch.getForm().findField('DVRY_DATE_FR').getValue());
			var year = date.getFullYear();
			var mon = date.getMonth() + 1;
			var dvry_date_fr = year + '.' + (mon > 9 ? mon : '0' + mon);
			var supp_date = panelSearch.getForm().findField('SUPP_DATE').getValue();

			var record = {
					DED_TYPE: panelSearch.getForm().findField('DED_TYPE').getValue(),
					PAY_YYYYMM: dvry_date_fr,
					SUPP_DATE: supp_date,
					RECE_DATE: supp_date,
					WORK_TIME: 0,
					PAY_AMOUNT_I: 0,
					PERCENT_I: 'HS11_20',
					INTER_RATE: 0,
					IN_TAX_I: 0,
					LOCAL_TAX_I: 0,
					DED_AMOUNT_I: 0,
					REAL_SUPP_TOTAL_I: 0,
					SUPP_TOTAL_I: 0,
					EXPS_AMOUNT_I: 0,
					EXPS_PERCENT_I: 0,
					CP_TAX_I: 0,
					SP_TAX_I: 0,
					ACC_GU : '01',
					SECT_CODE : panelResult.getValue('SECT_CODE')
			};
			masterGrid.createRow(record , 'NAME');
			UniAppManager.setToolbarButtons('delete', true);
			UniAppManager.setToolbarButtons('save', true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onDeleteDataButtonDown: function() {		//20210610 수정: 삭제로직 수정 - 여러개 선택하여 삭제할 수 있으므로 해당 로직에 맞게 수정
			if (masterGrid.getStore().getCount == 0) return;
			//20210609 추가: 마감일 때는 삭제 불가능
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
			localTax = Math.floor(((defInTax * 10) / 100) / 10) * 10;
		}

		e.record.set('LOCAL_TAX_I', localTax);
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
		var expsRate = 0; 

		if(e.data.EXPS_PERCENT_I != ''){
			expsRate = e.data.EXPS_PERCENT_I;
		} else {
			expsRate = 0;
		}
		var expsAmount = Math.floor(e.data.PAY_AMOUNT_I * (expsRate / 100));
		//expsAmount = Math.floor(expsAmount) * 10;
		e.set('EXPS_AMOUNT_I', expsAmount);

		// 지급액 * 세율 = 소득세,주민세
		var defInTax = 0;
		var localTax = 0;
		var pay = e.data.PAY_AMOUNT_I - e.data.EXPS_AMOUNT_I;
		var rate = e.data.PERCENT_I2;
		defInTax = Math.floor(pay * (rate / 100));

		//과세최저한도에의한 소액부징수 기타소득금액이 매건당 5만원이하일경우 과세하지아니한다 2005년
		if (defInTax < 1000) defInTax = 0;

		if (defInTax  < 1000 || pay <= 50000){
			defInTax  = 0;
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
		/*	e.set('LOCAL_TAX_I', Math.floor((defInTax - Math.round(defInTax / 1.1)) / 10) * 10);
			e.set('CP_TAX_I', defInTax - e.data.LOCAL_TAX_I); */
			e.set('LOCAL_TAX_I', localTax);
			e.set('CP_TAX_I', defInTax);
		}

		// 공제액
		e.set('DED_AMOUNT_I', defInTax + localTax + e.data.SP_TAX_I);
		// 실지급액
		e.set('REAL_SUPP_TOTAL_I', e.data.PAY_AMOUNT_I - e.data.DED_AMOUNT_I);
	}



	/* 마감/미마감 저장로직: 20210609 추가
	 */
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'hpb210ukrService.runClose',
			syncAll	: 'hpb210ukrService.runAll'
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