<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb165skr">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A077"/>	<!-- 미결구분 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-grid-cell-inner {padding: 4px;}
</style>

<script type="text/javascript" >

var gsChargeCode = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};	//ChargeCode 관련 전역변수

///////////////////////////////// 페이지 개발 전 확인사항 /////////////////////////////////
// 계정과목 팝업 선택시 미결항목 팝업이 유동적으로 변함(구현이 안되있어서 거래처 팝업으로 대체함.)
// 마스터그리드에서 조건에 따라서 페이지 링크가 달라짐(486Line ~ 532Line 확인해서 링크로 넘어간 페이지 파라미터 받을것.)

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb165skrModel', {
		fields: [
			{name: 'GUBUN'				,text: 'GUBUN'			,type: 'string'},
			{name: 'ORG_AC_DATE'		,text: '발생일'			,type: 'string'},
			{name: 'ORG_SLIP_NUM'		,text: '번호'				,type: 'string'},
			{name: 'ORG_SLIP_SEQ'		,text: '순번'				,type: 'string'},
			{name: 'ACCNT'				,text: '계정코드'			,type: 'string'},
			{name: 'ACCNT_NAME'			,text: '계정과목명'			,type: 'string'},
			{name: 'AC_NAME'			,text: '미결항목'			,type: 'string'},
			{name: 'PEND_DATA_CODE'		,text: '미결코드'			,type: 'string'},
			{name: 'PEND_DATA_NAME'		,text: '미결코드명'			,type: 'string'},
			{name: 'PEND_SLIP_NO'		,text: '반제전표번호'			,type: 'string'},
			{name: 'ORG_AMT_I'			,text: '발생금액'			,type: 'uniPrice'},
			{name: 'J_AMT_I'			,text: '반제금액'			,type: 'uniPrice'},
			{name: 'BLN_I'				,text: '잔액'				,type: 'uniPrice'},
			{name: 'REMARK'				,text: '적요'				,type: 'string'},
			{name: 'MONEY_UNIT'			,text: '화폐'				,type: 'string'},
			{name: 'EXCHG_RATE_O'		,text: '환율'				,type: 'uniER'},
			{name: 'FOR_ORG_AMT_I'		,text: '발생외화금액'			,type: 'uniFC'},
			{name: 'FOR_J_AMT_I'		,text: '반제외화금액'			,type: 'uniFC'},
			{name: 'FOR_BLN_I'			,text: '외화잔액'			,type: 'uniFC'},
			{name: 'EXPECT_DATE'		,text: '예정일'			,type: 'string'},
			{name: 'DEPT_CODE'			,text: '귀속부서'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '귀속부서명'			,type: 'string'},
			{name: 'AC_DATA1'			,text: '관리항목1'			,type: 'string'},
			{name: 'AC_DATA_NAME1'		,text: '관리항목명1'			,type: 'string'},
			{name: 'AC_DATA2'			,text: '관리항목2'			,type: 'string'},
			{name: 'AC_DATA_NAME2'		,text: '관리항목명2'			,type: 'string'},
			{name: 'AC_DATA3'			,text: '관리항목3'			,type: 'string'},
			{name: 'AC_DATA_NAME3'		,text: '관리항목명3'			,type: 'string'},
			{name: 'AC_DATA4'			,text: '관리항목4'			,type: 'string'},
			{name: 'AC_DATA_NAME4'		,text: '관리항목명4'			,type: 'string'},
			{name: 'AC_DATA5'			,text: '관리항목5'			,type: 'string'},
			{name: 'AC_DATA_NAME5'		,text: '관리항목명5'			,type: 'string'},
			{name: 'AC_DATA6'			,text: '관리항목6'			,type: 'string'},
			{name: 'AC_DATA_NAME6'		,text: '관리항목명6'			,type: 'string'},
			{name: 'GUBUN'				,text: 'GUBUN'			,type: 'string'},
			{name: 'INPUT_PATH'			,text: 'INPUT_PATH'		,type: 'string'},
			{name: 'AP_STS'				,text: 'AP_STS'			,type: 'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'		,type: 'string'},
			{name: 'INPUT_DIVI'			,text: 'INPUT_DIVI'		,type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('agb165skrMasterStore1',{
		model	: 'Agb165skrModel',		// 위에 선언했던 Agb165skrModel 모델 연결
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,				// 동적 로딩 여부
		proxy	: {
			type: 'direct',
			api	: {
				read: 'agb165skrService.selectList'			// 프로시저를 이용해서 direct 타입으로 서비스 연결
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();	// searchForm 의 값들을  변수 param 에 삽입
			console.log( param );								// 콘솔로 변수 param 값 확인 
			this.load({
				params : param									// 변수 param key/value 를 params 에 삽입
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();			// 그리드의 행 개수를 count 변수에 넣기
				if(count > 0){
					//20200804 추가: 출력버튼 추가로 인쇄버튼 사용 안 함
					masterGrid.down('#printBtn').enable();
//					UniAppManager.setToolbarButtons(['print'], true);	// 그리드 행 개수가 1개 이상일 때 인쇄 버튼 활성화
				}else{
					//20200804 추가: 출력버튼 추가로 인쇄버튼 사용 안 함
					masterGrid.down('#printBtn').disable();
//					UniAppManager.setToolbarButtons(['print'], false);	// 그리드 행 개수가 1개 미만일 때 인쇄 버튼 비활성화
				}
			}
		}
	});


	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		// 검색조건 패널 추가
		title		: '검색조건',										// 패널 타이틀 설정
		defaultType	: 'uniSearchSubPanel',							// 패널 기본형식 지정
		collapsed	: UserInfo.appOption.collapseLeftSearch,		// collapsed 클래스 사용 경로 지정
		listeners	: {
			collapse: function () {
				panelResult.show();		// 검색조건 패널 클릭했을 시 나오게 설정
			},
			expand: function() {
				panelResult.hide();		// 기본값으로 검색조건 패널  안 보이게 설정
			}
		},
		items		: [{
			title		: '기본정보', 							// 검색 조건 패널 안에 기본정보 패널 추가
			itemId		: 'search_panel1',					// 기본정보 패널 아이디 지정
			layout		: {type: 'uniTable', columns: 1},	// 기본정보 패널 레이아웃 설정
			defaultType	: 'uniTextfield',					// 기본정보 패널 타입 형식 지정
			items		: [{
				xtype	: 'container',
				layout	: {type : 'uniTable'},
				items	: [{ 
					fieldLabel	: '발생일',						// 기본정보 패널에 날짜 추가
					xtype		: 'uniDatefield',
					value		: UniDate.get('startOfMonth'),	// 날짜 값을 이번 달의 첫 1일로 값 지정
					width		: 197,
					name		: 'FR_DATE',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('FR_DATE', newValue);			// 날짜 바꿀 때 바꾼 날짜로 값 들어가게 핸들러 추가
						}
					}
				},{
					fieldLabel	: '~',
					allowBlank	: false,				// 공백상태 비활성화
					xtype		: 'uniDatefield',
					width		: 127,
					labelWidth	: 18,
					name		: 'TO_DATE',
					value		: UniDate.get('today'),	// 날짜 값을 오늘  날짜로 값 지정
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TO_DATE', newValue);			// 날짜 바꿀 때 바꾼 날짜로 값 들어가게 핸들러 추가
						}
					}
				}]
			},{
				fieldLabel	: '사업장',			// 사업장 이라는 콤보박스 추가 
				name		: 'ACCNT_DIV_CODE',	// 사업장 콤보박스 네임 지정
				xtype		: 'uniCombobox',		
				multiSelect	: true, 			// 여러 개의 사업장 선택 가능하게 설정
				typeAhead	: false,
				value		: UserInfo.divCode,	// 기본값 지정
				comboType	: 'BOR120',			// 콤보박스 공통코드 지정
				width		: 325,
				colspan		: 2,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ACCNT_DIV_CODE', newValue);	// 콤보박스 선택 시 선택한 값 들어가게 핸들러 추가
					}
				}
			},
			Unilite.popup('ACCNT',{				// 계정과목 팝업창 추가
				fieldLabel		: '계정과목',		// 팝업창 이름 설정
	//			validateBlank	: false,	 
				valueFieldName	: 'ACCNT_CODE',	// 팝업창 값 네임 지정
				textFieldName	: 'ACCNT_NAME',
				child			: 'ITEM',
				autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));		// 계정과목 팝업창에서 계정과목코드 나오게 지정
							panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));		// 계정과목 팝업창에서 계정과목이름 나오게 지정
							
							var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};		// 변수 param 에 선택한 값 저장
							accntCommonService.fnGetAccntInfo(param, function(provider, response) {
								var dataMap = provider;
								var opt = '1'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
								UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);
								UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);

								panelSearch.down('#formFieldArea1').show();		// 팝업창 닫고 선택한 값을 화면의 모든 조회폼에 선택한 값 지정
								panelResult.down('#formFieldArea1').show();		// 팝업창 닫고 선택한 값을 화면의 모든 조회폼에 선택한 값 지정
							});
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('ACCNT_CODE', '');		// 텍스트박스 안에 있는 게정과목코드를 지우면 지워지게 설정
						panelResult.setValue('ACCNT_NAME', '');		// 텍스트박스 안에 있는 게정과목이름를 지우면 지워지게 설정

						panelSearch.down('#formFieldArea1').hide();	// 팝업창 value 값 지워주고 닫기
						panelResult.down('#formFieldArea1').hide();	// 팝업창 value 값 지워주고 닫기
						/**
						 * onClear시 removeField..
						 */
						UniAccnt.removeField(panelSearch, panelResult);
					},
					applyExtParam:{			// 팝업창 설정
						scope	 :this,
						fn		: function(popup){
							var param = {
								'ADD_QUERY'		: "SLIP_SW = 'Y' AND GROUP_YN = 'N' AND PEND_YN = 'Y'",
								'CHARGE_CODE'	: (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
							}
							popup.setExtParam(param);
						}
					}
				}
			}),{
				xtype	: 'container',
				itemId	: 'conArea1',
				items	: [{
					xtype	: 'container',
					colspan	: 1,
					itemId	: 'formFieldArea1', 
					layout	: {
						type	: 'table', 
						columns	: 1,
						itemCls	: 'table_td_in_uniTable',
						tdAttrs	: {
							width: 350
						}
					}
				}]
			}]
		},{
			title		: '추가정보', 				// 추가정보 패널 추가
			itemId		: 'search_panel2',		// 추가정보 패널 아이디
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{					// 추가정보 패널에 텍스트박스나 콤보박스 추가
				fieldLabel	: '미결구분'	,
				name		: 'PEND_YN', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'A077'
			},{
				fieldLabel		: '반제일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'J_DATE_FR',
				endFieldName	: 'J_DATE_TO',
				width			: 470
			},
			Unilite.popup('DEPT',{
				fieldLabel		: '부서',
				valueFieldName	: 'DEPT_CODE',
				textFieldName	: 'DEPT_NAME'
			}),
			Unilite.popup('DEPT',{
				fieldLabel		: '~',
				valueFieldName	: 'PEND_DEPT_CODE',
				textFieldName	: 'PEND_DEPT_NAME'
			}),{
				fieldLabel	: '잔액기준',
				xtype		: 'uniCheckboxgroup', 
				width		: 400, 
				items		: [{
					boxLabel	: '발생일기준',
					name		: 'CHK_JAN',
					inputValue	: 'Y'
				}]
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
	});

	var panelResult = Unilite.createSearchForm('resultForm',{	// 서치폼 패널 추가
		region	: 'north',	// 패널 위치 지정
		layout	: {type : 'uniTable', columns : 3},		// 패널 타입, 레이아웃 지정
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,	
		items	: [{									// 서치폼 패널 안에 텍스트박스, 콤보박스 추가
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			items	: [{ 
				fieldLabel	: '발생일',
				xtype		: 'uniDatefield',
				value		: UniDate.get('startOfMonth'),		// 날짜 기본 값을 이번 달 첫1일로 지정
				width		: 197,
				name		: 'FR_DATE',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('FR_DATE', newValue);			// 날짜를 바꿨을 떄 바꾼 날을 값으로 들어가게 지정
					}
				}
			},{
				fieldLabel	: '~',
				allowBlank	: false,
				xtype		: 'uniDatefield',
				width		: 127,
				name		: 'TO_DATE',
				labelWidth	: 18,
				value		: UniDate.get('today'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TO_DATE', newValue);			// 날짜를 바꿨을 떄 바꾼 날을 값으로 들어가게 지정
					}
				}
			}]
		},{
			fieldLabel	: '사업장',
			name		: 'ACCNT_DIV_CODE', 
			xtype		: 'uniCombobox',		// 사업장 콤보박스 추가
			multiSelect	: true, 
			typeAhead	: false,
			value		: UserInfo.divCode,		
			comboType	: 'BOR120',				// 콤보박스 공통코드 지정
			width		: 325,
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ACCNT_DIV_CODE', newValue);	// 콤보박스에서 선택한 값 value 로 들어가게 지정
				}
			}
		},
		Unilite.popup('ACCNT',{				// 계정과목 팝업창
			fieldLabel		: '계정과목',
//			validateBlank	: false,	 
			valueFieldName	: 'ACCNT_CODE',
			textFieldName	: 'ACCNT_NAME',
			child			: 'ITEM',
			autoPopup		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));		// 계정과목코드 value
						panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));		// 계정과목이름 value
						/**
						 * 계정과목 동적 팝업
						 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
						 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
						 *  valueFieldName	textFieldName 		valueFieldName	 textFieldName			valueFieldName	textFieldName
						 *	PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	   BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
						 * -------------------------------------------------------------------------------------------------------------------------
						 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
						 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
						 *	PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
						 * */
						var param = {ACCNT_CD : panelResult.getValue('ACCNT_CODE')};				// 변수 param 에 계정과목코드 value로 삽입
						accntCommonService.fnGetAccntInfo(param, function(provider, response) {
							var dataMap = provider;
							var opt = '1'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
							UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);	
							UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);

							panelSearch.down('#formFieldArea1').show();		// 팝업창에서 고른 value 서치폼에 나오게 설정
							panelResult.down('#formFieldArea1').show();
						});
					},
					scope: this
				},
				onClear: function(type) {						// 계정과목 팝업창에서 아무 것도 선택 안 했을 떄 이벤트
					panelSearch.setValue('ACCNT_CODE', '');		// 계정과목코드
					panelSearch.setValue('ACCNT_NAME', '');		// 계정과목이름

					panelSearch.down('#formFieldArea1').hide();		// 계정과목 팝업창 닫기
					panelResult.down('#formFieldArea1').hide();
					/**
					 * onClear시 removeField..
					 */
					UniAccnt.removeField(panelSearch, panelResult);		// 계정과목 팝업창에서 value 없애기
				},
				applyExtParam:{			// 계정과목 팝업창 설정
					scope	: this,
					fn		: function(popup){
						var param = {
							'ADD_QUERY'		: "SLIP_SW = 'Y' AND GROUP_YN = 'N' AND PEND_YN = 'Y'",
							'CHARGE_CODE'	: (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
						}
						popup.setExtParam(param);
					}
				}
			}
		}),{
			xtype	: 'container',
			itemId	: 'conArea1',
			items	: [{
				xtype	: 'container',
				colspan	: 1,
				itemId	: 'formFieldArea1', 
				layout	: {
					type	: 'table', 
					columns	: 1,
					itemCls	: 'table_td_in_uniTable',
					tdAttrs	: {
						width: 350
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
	});


	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agb165skrGrid1', {
		store	: directMasterStore1,	// 그리드에 쓰일 스토어 지정
		layout	: 'fit',
		region	: 'center',			// 그리드 위치 지정
		selModel: 'rowmodel',		// 행 선택했을 시 한 줄로 선택되게 설정
		uniOpt	: {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: false,
			dblClickToEdit		: false,	// 더블클릭 시 수정불가
			useGroupSummary		: true,		// 합계 활성화
			useContextMenu		: false,
			useRowNumberer		: true,		// 추가할 때나 조회 시 자동으로 숫자 증가 설정
			expandLastColumn	: false,
			useRowContext		: true,
			filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		//20200804 추가: 출력링크로직 추가
		tbar		: [{
			text	: '출력',
			itemId	: 'printBtn',
			width	: 100,
			handler	: function() {
				var params		= panelSearch.getValues();
				params.PGM_ID	= 'agb165skr';
				var rec1 = {data : {prgID : 'agb165rkr', 'text':''}};
				parent.openTab(rec1, '/accnt/agb165rkr.do', params);
			}
		}],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },	// 소계 설정
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],	// 총계 설정
		columns	:  [
			{ dataIndex: 'GUBUN'			, width: 33		, hidden: true},
			{ dataIndex: 'ORG_AC_DATE'		, width: 70		, align:'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
			}},
			{ dataIndex: 'ORG_SLIP_NUM'	, width: 40,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					return '<div align="center">' + val;
				}
			},
			{ dataIndex: 'ORG_SLIP_SEQ'	, width: 40	,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					return '<div align="center">' + val;
				}
			},
			{ dataIndex: 'ACCNT'			, width: 66	},
			{ dataIndex: 'ACCNT_NAME'		, width: 140},
			{ dataIndex: 'AC_NAME'			, width: 75	},
			{ dataIndex: 'PEND_DATA_CODE'	, width: 80	},
			{ dataIndex: 'PEND_DATA_NAME'	, width: 133},
			{ dataIndex: 'PEND_SLIP_NO'		, width: 100},
			{ dataIndex: 'ORG_AMT_I'		, width: 113, summaryType: 'sum'},
			{ dataIndex: 'J_AMT_I'			, width: 113, summaryType: 'sum'},
			{ dataIndex: 'BLN_I'			, width: 116, summaryType: 'sum'},
			{ dataIndex: 'REMARK'			, width: 233},
			{ dataIndex: 'MONEY_UNIT'		, width: 40	},
			{ dataIndex: 'EXCHG_RATE_O'		, width: 66	, summaryType: 'sum'},
			{ dataIndex: 'FOR_ORG_AMT_I'	, width: 106, summaryType: 'sum'},
			{ dataIndex: 'FOR_J_AMT_I'		, width: 106, summaryType: 'sum'},
			{ dataIndex: 'FOR_BLN_I'		, width: 106, summaryType: 'sum'},
			{ dataIndex: 'EXPECT_DATE'		, width: 80	},
			{ dataIndex: 'DEPT_CODE'		, width: 66	},
			{ dataIndex: 'DEPT_NAME'		, width: 133},
			{ dataIndex: 'AC_DATA1'			, width: 80	},
			{ dataIndex: 'AC_DATA_NAME1'	, width: 166},
			{ dataIndex: 'AC_DATA2'			, width: 80	},
			{ dataIndex: 'AC_DATA_NAME2'	, width: 166},
			{ dataIndex: 'AC_DATA3'			, width: 80	},
			{ dataIndex: 'AC_DATA_NAME3'	, width: 166},
			{ dataIndex: 'AC_DATA4'			, width: 80	},
			{ dataIndex: 'AC_DATA_NAME4'	, width: 166},
			{ dataIndex: 'AC_DATA5'			, width: 80	},
			{ dataIndex: 'AC_DATA_NAME5'	, width: 166},
			{ dataIndex: 'AC_DATA6'			, width: 80	},
			{ dataIndex: 'AC_DATA_NAME6'	, width: 166},
			{ dataIndex: 'GUBUN'			, width: 80, hidden: true},
			{ dataIndex: 'INPUT_PATH'		, width: 80, hidden: true},
			{ dataIndex: 'AP_STS'			, width: 80, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 80, hidden: true},
			{ dataIndex: 'INPUT_DIVI'		, width: 80, hidden: true} 
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {		// 조회 했을 때 행이 1개 이상 나올 시 자동으로 맨 윗줄 선택되게 설정
				view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {			// 행 더블클릭 시 Agj100ukr 로 이동하게 설정
				if(grid.grid.contextMenu) {
					var menuItem = grid.grid.contextMenu.down('#linkAgj100ukr');
					if(menuItem) {
						menuItem.handler();
					}
				}
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				masterGrid.gotoAgj(record);
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) {
			if(record.get('INPUT_PATH') == '2') {
				menu.down('#linkAgj200ukr').hide();
				menu.down('#linkAgj100ukr').hide();
				menu.down('#linkAgj205ukr').show();
			} else if(record.get('INPUT_PATH') == 'Z3') {
				menu.down('#linkAgj200ukr').hide();
				menu.down('#linkAgj205ukr').hide();
				menu.down('#linkAgj100ukr').show();
			} else {
				menu.down('#linkAgj205ukr').hide();
				menu.down('#linkAgj100ukr').hide();
				menu.down('#linkAgj200ukr').show();
			}
			return true;
		},
		uniRowContextMenu:{			// 행에서 이동할 화면들 지정
			items: [{
				text	: '결의전표입력 이동',  
				itemId	: 'linkAgj100ukr',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgj(param.record);
				}
			},{
				text	: '회계전표입력 이동',   
				itemId	: 'linkAgj200ukr',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgj(param.record);
				},
				renderer: function() {
					return Ext.util.Format.substr(1,8);
				}
			},{
				text	: '회계전표입력(전표번호별) 이동',  
				itemId	: 'linkAgj205ukr', 
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgj(param.record);
				}
			}]
		},
		gotoAgj:function(record) {
			if(record) {
				if(record.data['INPUT_PATH'] == 'A0' || record.data['INPUT_PATH'] == 'A1') {
					alert("기초잔액에서 등록된 자료이므로 전표가 존재하지 않습니다.");
				} else {
					if(record.data['PEND_SLIP_NO'] == '') {
						var params = {
							action:'select',
							'PGM_ID'		: 'agb165skr',
							'ORG_AC_DATE' : record.data['ORG_AC_DATE'],
							'INPUT_PATH' : record.data['INPUT_PATH'],
							'ORG_SLIP_NUM' : record.data['ORG_SLIP_NUM'],
							'ORG_SLIP_SEQ' : record.data['ORG_SLIP_SEQ'],
							'DIV_CODE' : record.data['DIV_CODE']
						}
						if(record.data['INPUT_DIVI'] == '2') {
							var rec_1 = {data : {prgID : 'agj205ukr', 'text':''}};
							parent.openTab(rec_1, '/accnt/agj205ukr.do', params);
						} else if(record.data['INPUT_PATH'] == 'Z3') {
							var rec_2 = {data : {prgID : 'dgj100ukr', 'text':''}};
							parent.openTab(rec_2, '/accnt/dgj100ukr.do', params);
						} else {
							var rec_3 = {data : {prgID : 'agj200ukr', 'text':''}};
							parent.openTab(rec_3, '/accnt/agj200ukr.do', params);
						}
					} else if(record.data['PEND_SLIP_NO'] != ''){
						var OLD_SLIP_NUM = record.data['PEND_SLIP_NO']
						OLD_SLIP_NUM = Ext.util.Format.substr(OLD_SLIP_NUM, 9, 2);
						OLD_SLIP_NUM = Number(OLD_SLIP_NUM);

						var Param = OLD_SLIP_NUM;
						var ORG_AC_DATE	= record.data['PEND_SLIP_NO']
						ORG_AC_DATE = Ext.util.Format.substr(ORG_AC_DATE, 0, 8);
						ORG_AC_DATE = Ext.Date.parse(ORG_AC_DATE, 'Ymd');
						ORG_AC_DATE = Ext.Date.format(ORG_AC_DATE, 'Y.m.d');

						var param = ORG_AC_DATE;
						var	OLD_SLIP_SEQ = record.data['PEND_SLIP_NO']
						OLD_SLIP_SEQ = Ext.util.Format.substr(OLD_SLIP_SEQ, 12, 2);
						OLD_SLIP_SEQ = parseInt(OLD_SLIP_SEQ);
						
						var PARAMS = OLD_SLIP_SEQ;
						var params = {
							action:'select',
							'PGM_ID'		: 'agb165skr',
							'ORG_AC_DATE' : param,
							'INPUT_PATH' : record.data['INPUT_PATH'],
							'ORG_SLIP_NUM' : Param,
							'ORG_SLIP_SEQ' : PARAMS,
							'DIV_CODE' : record.data['DIV_CODE']
						}
						if(record.data['INPUT_DIVI'] == '2') {
							var rec_1 = {data : {prgID : 'agj205ukr', 'text':''}};
							parent.openTab(rec_1, '/accnt/agj205ukr.do', params);
						} else if(record.data['INPUT_PATH'] == 'Z3') {
							var rec_2 = {data : {prgID : 'dgj100ukr', 'text':''}};
							parent.openTab(rec_2, '/accnt/dgj100ukr.do', params);
						} else {
							var rec_3 = {data : {prgID : 'agj200ukr', 'text':''}};
							parent.openTab(rec_3, '/accnt/agj200ukr.do', params);
						}
					} else {
						var params = {
							action:'select',
							'PGM_ID'		: 'agb165skr',
							'FR_AC_DATE' : panelSearch.getValue('FR_DATE'),
							'TO_AC_DATE' : panelSearch.getValue('TO_DATE'),
							'INPUT_PATH' : record.data['INPUT_PATH'],
							'ORG_SLIP_NUM' : record.data['ORG_SLIP_NUM'],
							'ORG_SLIP_SEQ' : record.data['ORG_SLIP_NUM'],
							'DIV_CODE' : record.data['DIV_CODE']
						}
						if(record.data['INPUT_DIVI'] == '2') {
							var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};
							parent.openTab(rec1, '/accnt/agj205ukr.do', params);
						} else if(record.data['INPUT_PATH'] == 'Z3') {
							var rec2 = {data : {prgID : 'dgj100ukr', 'text':''}};
							parent.openTab(rec2, '/accnt/dgj100ukr.do', params);
						} else {
							var rec3 = {data : {prgID : 'agj200ukr', 'text':''}};
							parent.openTab(rec3, '/accnt/agj200ukr.do', params);
						}
					}
				}
			}
		}
	});



	Unilite.Main({
		id			: 'agb165skrApp',
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
		fnInitBinding : function() {var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
			this.setDefault();
		},
		setDefault: function() {		// 기본값
			panelSearch.setValue('CHK_JAN'			, 'Y');
			panelSearch.setValue('ACCNT_DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('ACCNT_DIV_CODE'	, UserInfo.divCode);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			UniAppManager.setToolbarButtons('save'	, false);
		},
		onQueryButtonDown : function() {	
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		}/*,//20200804 수정: 주석 (출력 버튼 사용)
		onPrintButtonDown: function() {		// 인쇄 버튼 눌렀을 시 이벤트
			//var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
			var params = Ext.getCmp('searchForm').getValues();
			var divName	 = '';

			if(panelSearch.getValue('ACCNT_DIV_CODE') == '' || panelSearch.getValue('ACCNT_DIV_CODE') == null ){
				divName = Msg.sMAW002;  // 전체
			}else{
				divName = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			}
			var win = Ext.create('widget.PDFPrintWindow', {	// 인쇄 버튼 눌렀을 때 주소 경로 지정
				url		: CPATH+'/agb/agb165rkr.do',		// 버튼 눌렀을 때 주소 지정
				prgID	: 'agb165rkr',
				extParam: {
					COMP_CODE		: UserInfo.compCode,
					FR_DATE			: params.FR_DATE,			 전표일 FR 
					TO_DATE			: params.TO_DATE,			 전표일 TO 
					ACCNT_DIV_CODE	: params.ACCNT_DIV_CODE,	 사업장 CODE
					ACCNT_DIV_NAME	: divName,					 사업장 NAME 
					ACCNT_CODE		: params.ACCNT_CODE,		 계정과목  
					ACCNT_NAME		: params.ACCNT_NAME,
					CHK_JAN			: params.CHK_JAN,			 잔액기준 
					DEPT_CODE		: params.DEPT_CODE,
					DEPT_NAME		: params.DEPT_NAME,			 부서 FR 
					PEND_DEPT_CODE	: params.PEND_DEPT_CODE,
					PEND_DEPT_NAME	: params.PEND_DEPT_NAME,	 부서  TO 
					PEND_YN			: params.PEND_YN,			 미결구분 
					J_DATE_FR		: params.J_DATE_FR,			 반제일 FR 
					J_DATE_TO		: params.J_DATE_TO,			 반제일 TO 
					CHK_PRINT		: params.CHK_PRINT			 출력조건 
//					SANCTION_NO		: fnAgb165Init.PT_SANCTION_NO,
//					PGM_ID			: 'agb165rkr'
				}
			});
			win.center();
			win.show();
		}*/
	});
};
</script>