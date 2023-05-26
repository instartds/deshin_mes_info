<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb110skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> 			<!--화폐단위-->
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>	
</t:appConfig>
<script type="text/javascript" >

var getStDt = Ext.isEmpty(${getStDt}) ? ['']: ${getStDt} ;//당기시작월 관련 전역변수
var gsChargeCode = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode} ;				//ChargeCode 관련 전역변수
/*	drAmtI				= 0;					//차변 누계 초기화
	crAmtI				= 0;					//대변 누계 초기화
	janAmtI				= 0;					//잔액 초기화
	drForAmtI			= 0;					//외화 차변 누계 초기화
	crForAmtI			= 0;					//외화 대변 누계 초기화
	janForAmtI			= 0;					//외화 잔액 초기화
	drAmtI1				= 0;					//차변 누계 초기화
	crAmtI1				= 0;					//대변 누계 초기화
	janAmtI1			= 0;					//잔액 초기화
	drForAmtI1			= 0;					//외화 차변 누계 초기화
	crForAmtI1			= 0;					//외화 대변 누계 초기화
	janForAmtI1			= 0;					//외화 잔액 초기화	
	gsDrSumDeleted		= 0;					//수정삭제이력표시 된 차변합계
	gsCrSumDeleted		= 0;					//수정삭제이력표시 된 대변합계
	gsDrForSumDeleted	= 0;					//수정삭제이력표시 된 외화 차변합계
	gsCrForSumDeleted	= 0;					//수정삭제이력표시 된 외화 대변합계
*/
var postitWindow;		// 각주팝업
var dataMap ={};

var agb111rkrLinkFlag = '';

function appMain() {
	var drAmtI1		= 0;
	var crAmtI1		= 0;
	var janAmtI1	= 0;
	var drForAmtI1	= 0;
	var crForAmtI1	= 0;
	var janForAmtI1	= 0;	
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb110skrModel', {
		fields: [
			{name: 'AC_DATE'		,text: '전표일'			,type: 'uniDate'},
			{name: 'SLIP_NUM'		,text: '번호'				,type: 'string'},
			{name: 'SLIP_SEQ'		,text: '순번'				,type: 'string'},
			{name: 'REMARK'			,text: '적요'				,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '거래처코드'			,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '거래처명'			,type: 'string'},
			{name: 'P_ACCNT_NAME'	,text: '상대계정'			,type: 'string'},
			{name: 'DR_AMT_I'		,text: '차변금액'			,type: 'uniPrice'},
			{name: 'CR_AMT_I'		,text: '대변금액'			,type: 'uniPrice'},
			{name: 'JAN_AMT_I'		,text: '잔액'				,type: 'uniPrice'},
			{name: 'MONEY_UNIT'		,text: '화폐'				,type: 'string'},
			{name: 'EXCHG_RATE'		,text: '환율'				,type: 'uniER'},
			{name: 'DR_FOR_AMT_I'	,text: '외화차변금액'			,type: 'uniFC'},
			{name: 'CR_FOR_AMT_I'	,text: '외화대변금액'			,type: 'uniFC'},
			{name: 'JAN_FOR_AMT_I'	,text: '외화잔액'			,type: 'uniFC'},
			{name: 'DEPT_CODE'		,text: '귀속부서'			,type: 'string'},
			{name: 'DEPT_NAME'		,text: '귀속부서명'			,type: 'string'},
			{name: 'DIV_CODE'		,text: '귀속사업장'			,type: 'string'},
			{name: 'DIV_NAME'		,text: '사업장'			,type: 'string'},
			{name: 'AC_DATA1'		,text: '관리항목1'			,type: 'string'},
			{name: 'AC_DATA_NAME1'	,text: '관리항목1'			,type: 'string'},
			{name: 'AC_DATA2'		,text: '관리항목2'			,type: 'string'},
			{name: 'AC_DATA_NAME2'	,text: '관리항목2'			,type: 'string'},
			{name: 'AC_DATA3'		,text: '관리항목3'			,type: 'string'},
			{name: 'AC_DATA_NAME3'	,text: '관리항목3'			,type: 'string'},
			{name: 'AC_DATA4'		,text: '관리항목4'			,type: 'string'},
			{name: 'AC_DATA_NAME4'	,text: '관리항목4'			,type: 'string'},
			{name: 'AC_DATA5'		,text: '관리항목5'			,type: 'string'},
			{name: 'AC_DATA_NAME5'	,text: '관리항목5'			,type: 'string'},
			{name: 'AC_DATA6'		,text: '관리항목6'			,type: 'string'},
			{name: 'AC_DATA_NAME6'	,text: '관리항목6'			,type: 'string'},
			{name: 'GUBUN'			,text: '구분'				,type: 'string'},
			{name: 'POSTIT_YN'		,text: 'POSTIT_YN'		,type: 'string'},
			{name: 'POSTIT'			,text: 'POSTIT'			,type: 'string'},
			{name: 'POSTIT_USER_ID'	,text: 'POSTIT_USER_ID'	,type: 'string'},
			{name: 'INPUT_PATH'		,text: 'INPUT_PATH'		,type: 'string'},
			{name: 'INPUT_USER_ID'	,text: 'INPUT_USER_ID'	,type: 'string'},
			{name: 'INPUT_USER_NAME',text: '입력자'			,type: 'string'},
			{name: 'MOD_DIVI'		,text: 'MOD_DIVI'		,type: 'string'},
			{name: 'INPUT_DIVI'		,text: 'INPUT_DIVI'		,type: 'string'},
			{name: 'DIV_CODE'		,text: '사업장'			,type: 'string'}
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('agb110skrMasterStore',{
		model: 'Agb110skrModel',
		uniOpt : {
			isMaster:	true,				// 상위 버튼 연결 
			editable:	false,				// 수정 모드 사용 
			deletable:	false,				// 삭제 가능 여부 
			useNavi:	false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'agb110skrService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
				var viewNormal = masterGrid.getView();
//					if(store.getCount() > 0){
					//viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridTotal').showSummaryRow = true;
//					}else{
//						viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);	
//					}
				
				//summaryRow에 쿼리에서 조회한 데이터 입력 후, 대체한 첫 번째 이월금액 그리드 삭제
				Ext.each(records, function(record, rowIndex){ 
					if(record.get('REMARK')== '이월금액'){
						drAmtI1		= record.get('DR_AMT_I');
						crAmtI1		= record.get('CR_AMT_I');
						janAmtI1	= record.get('JAN_AMT_I');
						//화폐단위가 선택되었을 때만 외화금액 관련 일월금액 구함
						if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))){
							drForAmtI1	= record.get('DR_FOR_AMT_I');
							crForAmtI1	= record.get('CR_FOR_AMT_I');
							janForAmtI1	= record.get('JAN_FOR_AMT_I');
						}
						//masterStore.remove(record);
//							record.set('REMARK', '누계');
//							record.set('GUBUN', '4');
						//masterStore.commitChanges();
						
					}
				});

//					//필요없는 데이터 숨기기 (소계의 전표일, 번호)
//					if(record.get('GUBUN') == '3' || record.get('GUBUN') == '4') {
//						record.set('AC_DATE', null);
//						record.set('SLIP_NUM', null);
//					}

/*					Ext.each(records, function(record, rowIndex){ 
						if(Ext.isEmpty(record.get('GUBUN'))){
							//이월금액 차변 구하기
							drAmtI		= record.get('DR_AMT_I');
							drAmtI1		= record.get('DR_AMT_I');
							//대변 구하기
							crAmtI		= record.get('CR_AMT_I');
							crAmtI1		= record.get('CR_AMT_I');
							//잔액 구하기
							janAmtI		= record.get('JAN_AMT_I');
							janAmtI1	= record.get('JAN_AMT_I');
							//화폐단위가 선택되었을 때만 외화금액 관련 합계 구함
							if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))){
								drForAmtI	= record.get('DR_FOR_AMT_I');
								drForAmtI1	= record.get('DR_FOR_AMT_I');
								crForAmtI	= record.get('CR_FOR_AMT_I');
								crForAmtI1	= record.get('CR_FOR_AMT_I');
								janForAmtI	= record.get('JAN_FOR_AMT_I');
								janForAmtI1	= record.get('JAN_FOR_AMT_I');
							}
						} else if(record.get('GUBUN') == '1') {
							if(record.get('MOD_DIVI') == 'D'){
								gsDrSumDeleted	= gsDrSumDeleted + record.get('DR_AMT_I')
								gsCrSumDeleted	= gsCrSumDeleted + record.get('CR_AMT_I')
								
								//화폐단위가 선택되었을 때만 외화금액 관련 합계 구함
								if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))){
									gsDrForSumDeleted	= gsDrForSumDeleted + record.get('DR_FOR_AMT_I')
									gsCrForSumDeleted	= gsCrForSumDeleted + record.get('CR_FOR_AMT_I')
								}
							} else {
								//차변 구하기
								drAmtI		= drAmtI + record.get('DR_AMT_I')
								//대변 구하기
								crAmtI		= crAmtI + record.get('CR_AMT_I')
								//잔액 구하기
								janAmtI		= janAmtI + record.get('JAN_AMT_I')
								//화폐단위가 선택되었을 때만 외화금액 관련 합계 구함
								if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))){
									drForAmtI	= drForAmtI + record.get('DR_FOR_AMT_I')
									crForAmtI	= crForAmtI + record.get('CR_FOR_AMT_I')
									janForAmtI	= janForAmtI + record.get('JAN_FOR_AMT_I')	
								}
								record.set('JAN_AMT_I', janAmtI);
								record.set('JAN_FOR_AMT_I', janForAmtI);									
							}
							
						//소계
						} else if(record.get('GUBUN') == '3') {
							record.set('DR_AMT_I', record.get('DR_AMT_I') - gsDrSumDeleted);
							record.set('CR_AMT_I', record.get('CR_AMT_I') - gsCrSumDeleted);
							record.set('JAN_AMT_I', null);
							//화폐단위가 선택되었을 때만 외화금액 관련 합계 구함
							if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))){
								record.set('DR_FOR_AMT_I', record.get('DR_FOR_AMT_I') - gsDrForSumDeleted);
								record.set('CR_FOR_AMT_I', record.get('CR_FOR_AMT_I') - gsCrForSumDeleted);
								record.set('JAN_FOR_AMT_I', null);	
							}
						
						//누계
						} else if(record.get('GUBUN') == '4') {
							//차변 구하기
							record.set('DR_AMT_I', drAmtI);
							record.set('DR_FOR_AMT_I', drForAmtI);	
							//대변 구하기
							record.set('CR_AMT_I', crAmtI);
							record.set('CR_FOR_AMT_I', crForAmtI);
							//잔액 구하기
							record.set('JAN_AMT_I', janAmtI);
							record.set('JAN_FOR_AMT_I', janForAmtI);
							//화폐단위가 선택되었을 때, 환율  -> 누계 잔액합계/외화잔액합계
							if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))){
								record.set('EXCHG_RATE', record.get('JAN_AMT_I') / record.get('JAN_FOR_AMT_I'));
							}

							gsDrSumDeleted		= 0;					//수정삭제이력표시 된 차변합계
							gsCrSumDeleted		= 0;					//수정삭제이력표시 된 대변합계
							gsDrForSumDeleted	= 0;					//수정삭제이력표시 된 외화 차변합계
							gsCrForSumDeleted	= 0;					//수정삭제이력표시 된 외화 대변합계
						}
					})
					masterStore.commitChanges();*/
				UniAppManager.setToolbarButtons('save', false);
			}
		}
	});

	/* Model2 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb110skrModel2', {
		fields: [
			{name: 'ACCNT'			,text: 'ACCNT'			,type: 'string'},
			{name: 'ACCNT_NAME'		,text: 'ACCNT_NAME'		,type: 'string'},
			{name: 'AC_FULL_NAME'	,text: 'AC_FULL_NAME'	,type: 'string'},
			{name: 'ACCNT_NAME2'	,text: 'ACCNT_NAME2'	,type: 'string'},
			{name: 'ACCNT_NAME3'	,text: 'ACCNT_NAME3'	,type: 'string'},
			{name: 'AC_CODE1'		,text: 'AC_CODE1'		,type: 'string'},
			{name: 'AC_CODE2'		,text: 'AC_CODE2'		,type: 'string'},
			{name: 'AC_CODE3'		,text: 'AC_CODE3'		,type: 'string'},
			{name: 'AC_CODE4'		,text: 'AC_CODE4'		,type: 'string'},
			{name: 'AC_CODE5'		,text: 'AC_CODE5'		,type: 'string'},
			{name: 'AC_CODE6'		,text: 'AC_CODE6'		,type: 'string'},
			{name: 'AC_NAME1'		,text: 'AC_NAME1'		,type: 'string'},
			{name: 'AC_NAME2'		,text: 'AC_NAME2'		,type: 'string'},
			{name: 'AC_NAME3'		,text: 'AC_NAME3'		,type: 'string'},
			{name: 'AC_NAME4'		,text: 'AC_NAME4'		,type: 'string'},
			{name: 'AC_NAME5'		,text: 'AC_NAME5'		,type: 'string'},
			{name: 'AC_NAME6'		,text: 'AC_NAME6'		,type: 'string'},
			{name: 'DR_CTL1'		,text: 'DR_CTL1'		,type: 'string'},
			{name: 'DR_CTL2'		,text: 'DR_CTL2'		,type: 'string'},
			{name: 'DR_CTL3'		,text: 'DR_CTL3'		,type: 'string'},
			{name: 'DR_CTL4'		,text: 'DR_CTL4'		,type: 'string'},
			{name: 'DR_CTL5'		,text: 'DR_CTL5'		,type: 'string'},
			{name: 'DR_CTL6'		,text: 'DR_CTL6'		,type: 'string'},
			{name: 'CR_CTL1'		,text: 'CR_CTL1'		,type: 'string'},
			{name: 'CR_CTL2'		,text: 'CR_CTL2'		,type: 'string'},
			{name: 'CR_CTL3'		,text: 'CR_CTL3'		,type: 'string'},
			{name: 'CR_CTL4'		,text: 'CR_CTL4'		,type: 'string'},
			{name: 'CR_CTL5'		,text: 'CR_CTL5'		,type: 'string'},
			{name: 'CR_CTL6'		,text: 'CR_CTL6'		,type: 'string'},
			{name: 'BOOK_CODE1'		,text: 'BOOK_CODE1'		,type: 'string'},
			{name: 'BOOK_CODE2'		,text: 'BOOK_CODE2'		,type: 'string'},
			{name: 'BOOK_NAME1'		,text: 'BOOK_NAME1'		,type: 'string'},
			{name: 'BOOK_NAME2'		,text: 'BOOK_NAME2'		,type: 'string'},
			{name: 'ACCNT_SPEC'		,text: 'ACCNT_SPEC'		,type: 'string'},
			{name: 'SPEC_DIVI'		,text: 'SPEC_DIVI'		,type: 'string'},
			{name: 'PROFIT_DIVI'	,text: 'PROFIT_DIVI'	,type: 'string'},
			{name: 'PEND_YN'		,text: 'PEND_YN'		,type: 'string'},
			{name: 'PEND_CODE'		,text: 'PEND_CODE'		,type: 'string'},
			{name: 'BUDG_YN'		,text: 'BUDG_YN'		,type: 'string'},
			{name: 'BUDGCTL_YN'		,text: 'BUDGCTL_YN'		,type: 'string'},
			{name: 'DR_FUND'		,text: 'DR_FUND'		,type: 'string'},
			{name: 'CR_FUND'		,text: 'CR_FUND'		,type: 'string'},
			{name: 'COST_DIVI'		,text: 'COST_DIVI'		,type: 'string'},
			{name: 'FOR_YN'			,text: 'FOR_YN'			,type: 'string'},
			{name: 'ACCNT_DIVI'		,text: 'ACCNT_DIVI'		,type: 'string'},
			{name: 'JAN_DIVI'		,text: 'JAN_DIVI'		,type: 'string'},
			{name: 'GROUP_YN'		,text: 'GROUP_YN'		,type: 'string'},
			{name: 'SLIP_SW'		,text: 'SLIP_SW'		,type: 'string'},
			{name: 'SYSTEM_YN'		,text: 'SYSTEM_YN'		,type: 'string'},
			{name: 'AC_TYPE1'		,text: 'AC_TYPE1'		,type: 'string'},
			{name: 'AC_TYPE2'		,text: 'AC_TYPE2'		,type: 'string'},
			{name: 'AC_TYPE3'		,text: 'AC_TYPE3'		,type: 'string'},
			{name: 'AC_TYPE4'		,text: 'AC_TYPE4'		,type: 'string'},
			{name: 'AC_TYPE5'		,text: 'AC_TYPE5'		,type: 'string'},
			{name: 'AC_TYPE6'		,text: 'AC_TYPE6'		,type: 'string'},
			{name: 'AC_LEN1'		,text: 'AC_LEN1'		,type: 'string'},
			{name: 'AC_LEN2'		,text: 'AC_LEN2'		,type: 'string'},
			{name: 'AC_LEN3'		,text: 'AC_LEN3'		,type: 'string'},
			{name: 'AC_LEN4'		,text: 'AC_LEN4'		,type: 'string'},
			{name: 'AC_LEN5'		,text: 'AC_LEN5'		,type: 'string'},
			{name: 'AC_LEN6'		,text: 'AC_LEN6'		,type: 'string'},
			{name: 'AC_POPUP1'		,text: 'AC_POPUP1'		,type: 'string'},
			{name: 'AC_POPUP2'		,text: 'AC_POPUP2'		,type: 'string'},
			{name: 'AC_POPUP3'		,text: 'AC_POPUP3'		,type: 'string'},
			{name: 'AC_POPUP4'		,text: 'AC_POPUP4'		,type: 'string'},
			{name: 'AC_POPUP5'		,text: 'AC_POPUP5'		,type: 'string'},
			{name: 'AC_POPUP6'		,text: 'AC_POPUP6'		,type: 'string'},
			{name: 'PEND_NAME'		,text: 'PEND_NAME'		,type: 'string'},
			{name: 'PEND_TYPE'		,text: 'PEND_TYPE'		,type: 'string'},
			{name: 'PEND_LEN'		,text: 'PEND_LEN'		,type: 'string'},
			{name: 'PEND_POPUP'		,text: 'PEND_POPUP'		,type: 'string'},
			{name: 'COMP_CODE'		,text: 'COMP_CODE'		,type: 'string'},
			{name: 'AC_FORMAT1'		,text: 'AC_FORMAT1'		,type: 'string'},
			{name: 'AC_FORMAT2'		,text: 'AC_FORMAT2'		,type: 'string'},
			{name: 'AC_FORMAT3'		,text: 'AC_FORMAT3'		,type: 'string'},
			{name: 'AC_FORMAT4'		,text: 'AC_FORMAT4'		,type: 'string'},
			{name: 'AC_FORMAT5'		,text: 'AC_FORMAT5'		,type: 'string'},
			{name: 'AC_FORMAT6'		,text: 'AC_FORMAT6'		,type: 'string'}
		]
	});
	
	/* Store2 정의(Service 정의)
	 * @type 
	 */					
	var masterStore2 = Unilite.createStore('agb110skrMasterStore2',{
		model: 'Agb110skrModel2',
		uniOpt : {
			isMaster:	false,				// 상위 버튼 연결 
			editable:	false,				// 수정 모드 사용 
			deletable:	false,				// 삭제 가능 여부 
			useNavi:	false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'agb110skrService.getGridName'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/* 검색조건 (Search Panel)
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
			items : [{ 
				fieldLabel: '전표일',
				xtype: 'uniDateRangefield',
				startFieldName: 'AC_DATE_FR',
				endFieldName: 'AC_DATE_TO',
//				width: 470,
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('AC_DATE_FR', newValue);
						UniAppManager.app.fnSetStDate(newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('AC_DATE_TO', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
		 		}
			},
				Unilite.popup('ACCNT',{
				fieldLabel: '계정과목',
				allowBlank: false, 
				valueFieldName: 'ACCNT_CODE',
				textFieldName: 'ACCNT_NAME',
				extParam: {'CHARGE_CODE': gsChargeCode[0].SUB_CODE},
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_NAME', newValue);
					},
					onSelected: {
						fn: function(records, type) {
							var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
							accntCommonService.fnGetAccntInfo(param, function(provider, response) {
								agb111rkrLinkFlag = '';
								if(!Ext.isEmpty(provider.BOOK_CODE1) || !Ext.isEmpty(provider.BOOK_CODE2)){
									agb111rkrLinkFlag = 'Y';
								}
								dataMap = provider;
								var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
								UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);
								UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);

								panelSearch.down('#conArea1').show();
								panelSearch.down('#conArea2').show();
								panelResult.down('#conArea1').show();
								panelResult.down('#conArea2').show();
								panelSearch.down('#formFieldArea1').show();
								panelSearch.down('#formFieldArea2').show();
								panelResult.down('#formFieldArea1').show();
								panelResult.down('#formFieldArea2').show();
								
								panelResult.down('#result_ViewPopup1').hide();
								panelSearch.down('#serach_ViewPopup1').hide();
								panelResult.down('#result_ViewPopup2').hide();
								panelSearch.down('#serach_ViewPopup2').hide();
								
								//계정과목에 따른 그리드 컬럼명 동적 변환
								if(!Ext.isEmpty(provider.AC_CODE1) && !Ext.isEmpty(provider.AC_NAME1)){
									masterGrid.getColumn('AC_DATA1').setText(provider.AC_NAME1);
									masterGrid.getColumn('AC_DATA_NAME1').setText(provider.AC_NAME1);
								}
								if(!Ext.isEmpty(provider.AC_CODE2) && !Ext.isEmpty(provider.AC_NAME2)){
									masterGrid.getColumn('AC_DATA2').setText(provider.AC_NAME2);
									masterGrid.getColumn('AC_DATA_NAME2').setText(provider.AC_NAME2);
								}
								if(!Ext.isEmpty(provider.AC_CODE3) && !Ext.isEmpty(provider.AC_NAME3)){
									masterGrid.getColumn('AC_DATA3').setText(provider.AC_NAME3);
									masterGrid.getColumn('AC_DATA_NAME3').setText(provider.AC_NAME3);
								}
								if(!Ext.isEmpty(provider.AC_CODE4) && !Ext.isEmpty(provider.AC_NAME4)){
									masterGrid.getColumn('AC_DATA4').setText(provider.AC_NAME4);
									masterGrid.getColumn('AC_DATA_NAME4').setText(provider.AC_NAME4);
								}
								if(!Ext.isEmpty(provider.AC_CODE5) && !Ext.isEmpty(provider.AC_NAME5)){
									masterGrid.getColumn('AC_DATA5').setText(provider.AC_NAME5);
									masterGrid.getColumn('AC_DATA_NAME5').setText(provider.AC_NAME5);
								}
								if(!Ext.isEmpty(provider.AC_CODE6) && !Ext.isEmpty(provider.AC_NAME6)){
									masterGrid.getColumn('AC_DATA6').setText(provider.AC_NAME6);
									masterGrid.getColumn('AC_DATA_NAME6').setText(provider.AC_NAME6);
								}
							});
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.down('#serach_ViewPopup1').show();
						panelResult.down('#result_ViewPopup1').show();
						panelSearch.down('#serach_ViewPopup2').show();
						panelResult.down('#result_ViewPopup2').show();
						// onClear시 removeField..
						UniAccnt.removeField(panelSearch, panelResult);
						panelSearch.down('#conArea1').hide();
						panelSearch.down('#conArea2').hide();
						panelResult.down('#conArea1').hide();
						panelResult.down('#conArea2').hide();
					}
				}
			}),
				Unilite.popup('ACCNT',{
				fieldLabel: '상대계정',
	//			validateBlank:false,	 
				valueFieldName: 'P_ACCNT_CD',
				textFieldName: 'P_ACCNT_NM',
				extParam: {'CHARGE_CODE': gsChargeCode[0].SUB_CODE},
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('P_ACCNT_CD', panelSearch.getValue('P_ACCNT_CD'));
							panelResult.setValue('P_ACCNT_NM', panelSearch.getValue('P_ACCNT_NM'));	
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('P_ACCNT_CD', '');
						panelResult.setValue('P_ACCNT_NM', '');
						UniAccnt.removeField(panelSearch, panelResult);
					}
				}
			}),{
				xtype: 'container',
				colspan: 1,
				itemId: 'serach_ViewPopup1',
				layout: {
					type: 'table', 
					columns:1,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
					}
				},
				items:[
					Unilite.popup('ACCNT_PRSN',{
						readOnly:true,
						fieldLabel: '계정잔액1',
						validateBlank:false,
						autoPopup:true
					})
				]
			 },{
				xtype: 'container',
				colspan: 1,
				itemId: 'serach_ViewPopup2', 
				layout: {
					type: 'table', 
					columns:1,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
					}
				},
				items:[
					Unilite.popup('ACCNT_PRSN',{
						readOnly:true,
						fieldLabel: '계정잔액2',
						validateBlank:false,
						autoPopup:true
					})
				]
			},{
				xtype: 'container',
				itemId: 'conArea1',
				items:[{
					xtype: 'container',
					colspan: 1,
					itemId: 'formFieldArea1', 
					layout: {
						type: 'table', 
						columns:1,
						itemCls:'table_td_in_uniTable',
						tdAttrs: {
							width: 350
						}
					}
				}]
			},{
				xtype: 'container',
				itemId: 'conArea2',
				items:[{
					xtype: 'container',
					colspan: 1,
					itemId: 'formFieldArea2', 
					layout: {
						type: 'table', 
						columns:1,
						itemCls:'table_td_in_uniTable',
						tdAttrs: {
							width: 350
						}
					}
				}]
			}]
		}, {
			title: '추가정보', 	
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items : [{
				fieldLabel: '조건',
				name: '',
				xtype: 'checkboxgroup', 
				width: 400, 
				items: [{
					boxLabel: '수정삭제이력표시',
					name: 'CHECK_DELETE',
					width: 150,
					uncheckedValue: 'N',
					inputValue: 'Y'
				}, {
					boxLabel: '각주',
					name: 'CHECK_POST_IT',
					width: 100,
					uncheckedValue: '',						//unilite에 체크 안 되어 있을 때 'N'으로 조회되나 데이터 조회 값은 ''이 들어간 것이 동일한 값을 가짐 일단 ''처리
					inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(panelSearch.getValue('CHECK_POST_IT')) {
								panelSearch.getField('POST_IT').setReadOnly(false);
							} else {
								panelSearch.getField('POST_IT').setReadOnly(true);
							}
						}
					}
				}]
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '각주',
				width: 325,
				name:'POST_IT',
				readOnly: true
			},{
				fieldLabel: '당기시작년월',
				name: 'START_DATE',
				xtype: 'uniMonthfield',
				allowBlank: false
			},
				Unilite.popup('ACCNT_PRSN',{
				fieldLabel: '입력자',
				valueFieldName:'CHARGE_CODE',
				textFieldName:'CHARGE_NAME',
				validateBlank:false, 
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('CHARGE_CODE', '');
						panelSearch.setValue('CHARGE_NAME', '');
						UniAccnt.removeField(panelSearch, panelResult);
					}
				}
			}),{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:600,
				items :[{
					fieldLabel:'금액', 
					xtype: 'uniNumberfield',
					name: 'AMT_FR', 
					width: 203
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniNumberfield',
					name: 'AMT_TO', 
					width: 113
				}]
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:600,
				items :[{
					fieldLabel:'외화금액', 
					xtype: 'uniNumberfield',
					name: 'FOR_AMT_FR', 
					width: 203
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniNumberfield',
					name: 'FOR_AMT_TO', 
					width: 113
				}]
			},{
				xtype: 'uniTextfield',
				name: 'REMARK',
				fieldLabel: '적요',
				width: 325
			},  
				Unilite.popup('DEPT',{
				fieldLabel: '부서',
				valueFieldName:'DEPT_CODE_FR',
				textFieldName:'DEPT_NAME_FR',
				validateBlank:false, 
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('DEPT_CODE_FR', '');
						panelSearch.setValue('DEPT_NAME_FR', '');
						UniAccnt.removeField(panelSearch, panelResult);
					}
				}
			}),
				Unilite.popup('DEPT',{
				fieldLabel: '~',
				valueFieldName:'DEPT_CODE_TO',
				textFieldName:'DEPT_NAME_TO',
				validateBlank:false, 
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('DEPT_CODE_TO', '');
						panelSearch.setValue('DEPT_NAME_TO', '');
						UniAccnt.removeField(panelSearch, panelResult);
					}
				}
			}),  
//				Unilite.popup('AGENT_CUST',{
//				fieldLabel: '거래처',
//				validateBlank:false, 
//				autoPopup:true,
//				valueFieldName:'CUSTOM_CODE',
//				textFieldName:'CUSTOM_NAME',
//				extParam:{'CUSTOM_TYPE':'3'},
//				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelSearch.setValue('CUSTOM_CODE', '');
//						panelSearch.setValue('CUSTOM_NAME', '');
//						UniAccnt.removeField(panelSearch, panelResult);
//					}
//				}
//			})
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '거래처',
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			listeners: {
				onValueFieldChange:function( elm, newValue, oldValue) {
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange:function( elm, newValue, oldValue) {					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
					}
				}
			}
			}),{
				fieldLabel: '화폐단위'	,
				name:'MONEY_UNIT', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B004',
				displayField: 'value'
			}]
		}]
	});	

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '전표일',
			xtype: 'uniDateRangefield',
			startFieldName: 'AC_DATE_FR',
			endFieldName: 'AC_DATE_TO',
			allowBlank: false,
			tdAttrs: {width: 380},  
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('AC_DATE_FR', newValue);
					UniAppManager.app.fnSetStDate(newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('AC_DATE_TO', newValue);
				}
			}
		},{
			fieldLabel: '사업장',
			name:'ACCNT_DIV_CODE', 
			xtype: 'uniCombobox',
			multiSelect: true, 
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
//			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
	 		}
		},
			Unilite.popup('ACCNT',{
			fieldLabel: '계정과목',
			allowBlank: false, 
			valueFieldName: 'ACCNT_CODE',
			textFieldName: 'ACCNT_NAME',
			extParam: {'CHARGE_CODE': gsChargeCode[0].SUB_CODE},  
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME', newValue);
				},
				onSelected: {
					fn: function(records, type) {
						/**
						 * 계정과목 동적 팝업
						 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
						 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
						 *  valueFieldName	textFieldName 		valueFieldName	 textFieldName			valueFieldName	textFieldName
						 *	PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
						 * -------------------------------------------------------------------------------------------------------------------------
						 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
						 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
						 *	PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)
						 * */
						var param = {ACCNT_CD : panelResult.getValue('ACCNT_CODE')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response) {
							agb111rkrLinkFlag = '';
							if(!Ext.isEmpty(provider.BOOK_CODE1) || !Ext.isEmpty(provider.BOOK_CODE2)){
								agb111rkrLinkFlag = 'Y';
							}
							dataMap = provider;
							var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용						
							UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
							UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);
							panelSearch.down('#conArea1').show();
							panelSearch.down('#conArea2').show();
							panelResult.down('#conArea1').show();
							panelResult.down('#conArea2').show();
							panelSearch.down('#formFieldArea1').show();
							panelSearch.down('#formFieldArea2').show();
							panelResult.down('#formFieldArea1').show();
							panelResult.down('#formFieldArea2').show();
							
							panelResult.down('#result_ViewPopup1').hide();
							panelSearch.down('#serach_ViewPopup1').hide();
							panelResult.down('#result_ViewPopup2').hide();
							panelSearch.down('#serach_ViewPopup2').hide();
							
							//계정과목에 따른 그리드 컬럼명 동적 변환
							if(!Ext.isEmpty(provider.AC_CODE1) && !Ext.isEmpty(provider.AC_NAME1)){
								masterGrid.getColumn('AC_DATA1').setText(provider.AC_NAME1);
								masterGrid.getColumn('AC_DATA_NAME1').setText(provider.AC_NAME1);
							}
							if(!Ext.isEmpty(provider.AC_CODE2) && !Ext.isEmpty(provider.AC_NAME2)){
								masterGrid.getColumn('AC_DATA2').setText(provider.AC_NAME2);
								masterGrid.getColumn('AC_DATA_NAME2').setText(provider.AC_NAME2);
							}
							if(!Ext.isEmpty(provider.AC_CODE3) && !Ext.isEmpty(provider.AC_NAME3)){
								masterGrid.getColumn('AC_DATA3').setText(provider.AC_NAME3);
								masterGrid.getColumn('AC_DATA_NAME3').setText(provider.AC_NAME3);
							}
							if(!Ext.isEmpty(provider.AC_CODE4) && !Ext.isEmpty(provider.AC_NAME4)){
								masterGrid.getColumn('AC_DATA4').setText(provider.AC_NAME4);
								masterGrid.getColumn('AC_DATA_NAME4').setText(provider.AC_NAME4);
							}
							if(!Ext.isEmpty(provider.AC_CODE5) && !Ext.isEmpty(provider.AC_NAME5)){
								masterGrid.getColumn('AC_DATA5').setText(provider.AC_NAME5);
								masterGrid.getColumn('AC_DATA_NAME5').setText(provider.AC_NAME5);
							}
							if(!Ext.isEmpty(provider.AC_CODE6) && !Ext.isEmpty(provider.AC_NAME6)){
								masterGrid.getColumn('AC_DATA6').setText(provider.AC_NAME6);
								masterGrid.getColumn('AC_DATA_NAME6').setText(provider.AC_NAME6);
							}
						});
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.down('#serach_ViewPopup1').show();
					panelResult.down('#result_ViewPopup1').show();
					panelSearch.down('#serach_ViewPopup2').show();
					panelResult.down('#result_ViewPopup2').show();
					// onClear시 removeField..
					UniAccnt.removeField(panelSearch, panelResult);
					panelSearch.down('#conArea1').hide();
					panelSearch.down('#conArea2').hide();
					panelResult.down('#conArea1').hide();
					panelResult.down('#conArea2').hide();
				}
			}
 		}),{
			xtype: 'container',
			colspan: 1,
			itemId: 'result_ViewPopup1', 
			layout: {
				type: 'table', 
				columns:1,
				itemCls:'table_td_in_uniTable',
				tdAttrs: {
					width: 350
				}
			},
			items:[
				Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
					fieldLabel: '계정잔액1',
					validateBlank:false,
					autoPopup: true
				})
			]
		},{
			xtype: 'container',
			itemId: 'conArea1',
			colspan: 2,
			items:[{
				xtype: 'container',
				itemId: 'formFieldArea1', 
				layout: {
					type: 'table', 
					columns:1,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
					}
				}
			}]
		},
			Unilite.popup('ACCNT',{
			fieldLabel: '상대계정',
//			validateBlank:false,	 
			valueFieldName: 'P_ACCNT_CD',
			textFieldName: 'P_ACCNT_NM',
			extParam: {'CHARGE_CODE': gsChargeCode[0].SUB_CODE},
			autoPopup:true,
			listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('P_ACCNT_CD', panelResult.getValue('P_ACCNT_CD'));
							panelSearch.setValue('P_ACCNT_NM', panelResult.getValue('P_ACCNT_NM')); 
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('P_ACCNT_CD', '');
						panelSearch.setValue('P_ACCNT_NM', '');
						UniAccnt.removeField(panelSearch, panelResult);
					}
				}
 		}),{
			xtype: 'container',
			colspan: 1,
			itemId: 'result_ViewPopup2', 
			layout: {
				type: 'table', 
				columns:1,
				itemCls:'table_td_in_uniTable',
				tdAttrs: {
					width: 350
				}
			},
			items:[
				Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
					fieldLabel: '계정잔액2',
					validateBlank:false,
					autoPopup: true
				})
		]},{
			xtype: 'container',
			itemId: 'conArea2',
			colspan: 2,
			items:[{
				xtype: 'container',
				itemId: 'formFieldArea2', 
				layout: {
					type: 'table', 
					columns:1,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
					}
				}
			}]
		}]	
	});

	/* Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agb110skrGrid1', {
		// for tab		
		layout		: 'fit',
		region		: 'center',
		store		: masterStore,
		selModel	: 'rowmodel',
		//sorting 되지 않도록 설정
		sortableColumns: false,
		uniOpt:{
			useMultipleSorting	: false,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			dblClickToEdit		: false,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
			filter: {
				useFilter		: false,
				autoCreate		: false
			},
			excel: {
				useExcel: true,			//엑셀 다운로드 사용 여부
				exportGroup : false, 		//group 상태로 export 여부
				onlyData:false,
				summaryExport:false
			}
		},
		tbar: [{
			text:'보조장출력',
			handler: function() {
				var params = {
//					action:'select',
					'AC_DATE_FR'	: panelSearch.getValue('AC_DATE_FR'),
					'AC_DATE_TO'	: panelSearch.getValue('AC_DATE_TO'),
					'DIV_CODE'		: panelSearch.getValue('ACCNT_DIV_CODE'),
					'ACCNT_CODE'	: panelSearch.getValue('ACCNT_CODE'),
					'ACCNT_NAME'	: panelSearch.getValue('ACCNT_NAME'),
					'P_ACCNT_CD'	: panelSearch.getValue('P_ACCNT_CD'),
					'P_ACCNT_NM'	: panelSearch.getValue('P_ACCNT_NM'),
					'CHECK_DELETE'	: panelSearch.getValue('CHECK_DELETE'),
					//'CHECK_DELETE'  : Ext.getCmp('checkboxgroup').getChecked()[0].inputValue,
					'CHECK_POST_IT'	: panelSearch.getValue('CHECK_POST_IT'),
					//'CHECK_POST_IT' : Ext.getCmp('checkboxgroup').getChecked()[0].inputValue,
					'POST_IT'		: panelSearch.getValue('POST_IT'),
					'START_DATE'	: panelSearch.getValue('START_DATE'),
					'CHARGE_CODE'	: panelSearch.getValue('CHARGE_CODE'),
					'CHARGE_NAME'	: panelSearch.getValue('CHARGE_NAME'),
					'AMT_FR'		: panelSearch.getValue('AMT_FR'),
					'AMT_TO'		: panelSearch.getValue('AMT_TO'),
					'REMARK_CODE'	: panelSearch.getValue('REMARK_CODE'),
					'REMARK_NAME'   : panelSearch.getValue('REMARK_NAME'),
					'FOR_AMT_FR'	: panelSearch.getValue('FOR_AMT_FR'),
					'FOR_AMT_TO'	: panelSearch.getValue('FOR_AMT_TO'),
					'REMARK'		: panelSearch.getValue('REMARK'),
					'DEPT_CODE_FR'	: panelSearch.getValue('DEPT_CODE_FR'),
					'DEPT_NAME_FR'	: panelSearch.getValue('DEPT_NAME_FR'),
					'DEPT_CODE_TO'	: panelSearch.getValue('DEPT_CODE_TO'),
					'DEPT_NAME_TO'	: panelSearch.getValue('DEPT_NAME_TO'),
					'CUSTOM_CODE'	: panelSearch.getValue('CUSTOM_CODE'),
					'CUSTOM_NAME'	: panelSearch.getValue('CUSTOM_NAME'),
					'MONEY_UNIT'	: panelSearch.getValue('MONEY_UNIT')
				}
				//전송
				var rec1 = {data : {prgID : 'agb110rkr', 'text':''}};
				parent.openTab(rec1, '/accnt/agb110rkr.do', params);	
			}
		},{
			text:'보조원장출력',
			handler: function() {
				//if(agb111rkrLinkFlag == 'Y'){
					var params = {
	//					action:'select',
						'AC_DATE_FR'   : panelSearch.getValue('AC_DATE_FR'),
						'AC_DATE_TO'	: panelSearch.getValue('AC_DATE_TO'),
						'DIV_CODE'	  : panelSearch.getValue('ACCNT_DIV_CODE'),
						'ACCNT_CODE'	: panelSearch.getValue('ACCNT_CODE'),
						'ACCNT_NAME'	: panelSearch.getValue('ACCNT_NAME'),
						'P_ACCNT_CD'	: panelSearch.getValue('P_ACCNT_CD'),
						'P_ACCNT_NM'	: panelSearch.getValue('P_ACCNT_NM'),
						'CHECK_DELETE'  : panelSearch.getValue('CHECK_DELETE'),
						//'CHECK_DELETE'  : Ext.getCmp('checkboxgroup').getChecked()[0].inputValue,
						'CHECK_POST_IT' : panelSearch.getValue('CHECK_POST_IT'),
						//'CHECK_POST_IT' : Ext.getCmp('checkboxgroup').getChecked()[0].inputValue,
						'POST_IT'	: panelSearch.getValue('POST_IT'),
						'START_DATE'	: panelSearch.getValue('START_DATE'),
						'CHARGE_CODE'   : panelSearch.getValue('CHARGE_CODE'),
						'CHARGE_NAME'   : panelSearch.getValue('CHARGE_NAME'),
						'AMT_FR'		: panelSearch.getValue('AMT_FR'),
						'AMT_TO'		: panelSearch.getValue('AMT_TO'),
						'REMARK_CODE'   : panelSearch.getValue('REMARK_CODE'),
						'REMARK_NAME'   : panelSearch.getValue('REMARK_NAME'),
						'FOR_AMT_FR'	: panelSearch.getValue('FOR_AMT_FR'),
						'FOR_AMT_TO'	: panelSearch.getValue('FOR_AMT_TO'),
						'REMARK'		: panelSearch.getValue('REMARK'),
						'DEPT_CODE_FR'  : panelSearch.getValue('DEPT_CODE_FR'),
						'DEPT_NAME_FR'  : panelSearch.getValue('DEPT_NAME_FR'),
						'DEPT_CODE_TO'  : panelSearch.getValue('DEPT_CODE_TO'),
						'DEPT_NAME_TO'  : panelSearch.getValue('DEPT_NAME_TO'),
						'CUSTOM_CODE'   : panelSearch.getValue('CUSTOM_CODE'),
						'CUSTOM_NAME'   : panelSearch.getValue('CUSTOM_NAME'),
						'MONEY_UNIT'	: panelSearch.getValue('MONEY_UNIT'),
						'AC_DATA1'		: panelSearch.getValue('BOOK_CODE1'),
						'AC_NAME1'		: panelSearch.getValue('BOOK_NAME1'),
						'AC_DATA2'		: panelSearch.getValue('BOOK_CODE2'),
						'AC_NAME2'		: panelSearch.getValue('BOOK_NAME2')
					}
					//전송
					var rec1 = {data : {prgID : 'agb111rkr', 'text':''}};
					parent.openTab(rec1, '/accnt/agb111rkr.do', params);
				//}
			}
		}],
		features: [ {
			id : 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false 
			//컬럼헤더에서 그룹핑 사용 안 함
//			enableGroupingMenu:false
		},{
			id : 'masterGridTotal',
			ftype: 'uniSummary',
			dock : 'top',
			showSummaryRow: false
//			enableGroupingMenu:true
		}],
		columns:  [ 				 
					{ dataIndex: 'GUBUN'			,width:80		,hidden: true	},
					/*{ dataIndex: 'POSTIT_YN'		,width:80		,hidden: true	},
					{ dataIndex: 'POSTIT'			,width:80		,hidden: true	},
					{ dataIndex: 'POSTIT_USER_ID'	,width:80		,hidden: true	},
					{ dataIndex: 'INPUT_PATH'		,width:80		,hidden: true	},
					{ dataIndex: 'MOD_DIVI'		,width:80		,hidden: true	},
					{ dataIndex: 'INPUT_DIVI'		,width:80		,hidden: true	},
					{ dataIndex: 'DIV_CODE'		,width:80		,hidden: true	}, */
					{ dataIndex: 'DIV_NAME'			,width:100		,hidden: true	},
					{ dataIndex: 'AC_DATE'			,width:80	},
					{ dataIndex: 'SLIP_NUM'			,width:60		, align: 'center'	},
					{ dataIndex: 'SLIP_SEQ'			,width:60		, align: 'center'	},
					{ dataIndex: 'REMARK'			,width:300,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '소계', '이월금액');
						},
						renderer:function(value, metaData, record) {
							var r = value;
							if(record.get('POSTIT_YN') == 'Y') r ='<img src="'+CPATH+'/resources/images/PostIt.gif"/>'+value
							return r;
						}
					},
					{ dataIndex: 'CUSTOM_NAME'		,width:160	},
					{ dataIndex: 'P_ACCNT_NAME'		,width:120	},
					{ dataIndex: 'DR_AMT_I'			,width:120		,align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(drAmtI1,'0,000')+'</div>');
						}
					},
					{ dataIndex: 'CR_AMT_I'			,width:120		,align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(crAmtI1,'0,000')+'</div>');
						}
					},
					{ dataIndex: 'JAN_AMT_I'		,width:120		,align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(janAmtI1,'0,000')+'</div>');
						}
					},
					{ dataIndex: 'MONEY_UNIT'		,width:60		,align: 'center'},
					{ dataIndex: 'EXCHG_RATE'		,width:66,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							var selectRecord =  masterGrid.getSelectedRecord();
							if (!Ext.isEmpty(selectRecord)) {
								return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(selectRecord.get('EXCHG_RATE'),'0,000')+'</div>');
							} else {
								return 0.00;
							}
						}
					},
					{ dataIndex: 'DR_FOR_AMT_I'		,width:120		,align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							if (!Ext.isEmpty(drForAmtI1)) {
								return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(drForAmtI1,'0,000')+'</div>');
							} else {
								return 0;
							}
						}
					},
					{ dataIndex: 'CR_FOR_AMT_I'		,width:120		,align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							if (!Ext.isEmpty(crForAmtI1)) {
								return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(crForAmtI1,'0,000')+'</div>');
							} else {
								return 0;
							}
						}
					},
					{ dataIndex: 'JAN_FOR_AMT_I'	,width:120		,align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							if (!Ext.isEmpty(janForAmtI1)) {
								return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">'+ Ext.util.Format.number(janForAmtI1,'0,000')+'</div>');
							} else {
								return 0;
							}
						}
					},
					{ dataIndex: 'DEPT_CODE'		,width:66	},
					{ dataIndex: 'DEPT_NAME'		,width:130	},
					{ dataIndex: 'INPUT_USER_NAME'	,width:100		,hidden: true	},
					{ dataIndex: 'AC_DATA1'		,width:100,
						renderer:function(value, metaData, record) {
//							dataMap;
							var r = value;
							if(dataMap.AC_FORMAT1 == 'I'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT1 == 'O'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
							} else if(dataMap.AC_FORMAT1 == 'R'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
							} else if(dataMap.AC_FORMAT1 == 'P'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT1 == 'Q'){ 
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
							}
							return r;
						}
					},
					{ dataIndex: 'AC_DATA_NAME1'	,width:160	},
					{ dataIndex: 'AC_DATA2'		,width:100,
						renderer:function(value, metaData, record) {
							var r = value;
							if(dataMap.AC_FORMAT2 == 'I'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT2 == 'O'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
							} else if(dataMap.AC_FORMAT2 == 'R'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
							} else if(dataMap.AC_FORMAT2 == 'P'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT2 == 'Q'){ 
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
							}
							return r;
						}
					},
					{ dataIndex: 'AC_DATA_NAME2'	,width:160	},
					{ dataIndex: 'AC_DATA3'		,width:100,
						renderer:function(value, metaData, record) {
							var r = value;
							if(dataMap.AC_FORMAT3 == 'I'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT3 == 'O'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
							} else if(dataMap.AC_FORMAT3 == 'R'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
							} else if(dataMap.AC_FORMAT3 == 'P'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT3 == 'Q'){ 
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
							}
							return r;
						}
					},
					{ dataIndex: 'AC_DATA_NAME3'	,width:160	},
					{ dataIndex: 'AC_DATA4'		,width:100,
						renderer:function(value, metaData, record) {
							var r = value;
							if(dataMap.AC_FORMAT4 == 'I'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT4 == 'O'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
							} else if(dataMap.AC_FORMAT4 == 'R'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
							} else if(dataMap.AC_FORMAT4 == 'P'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT4 == 'Q'){ 
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
							}
							return r;
						}
					},
					{ dataIndex: 'AC_DATA_NAME4'	,width:160	},
					{ dataIndex: 'AC_DATA5'		,width:100,
						renderer:function(value, metaData, record) {
							var r = value;
							if(dataMap.AC_FORMAT5 == 'I'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT5 == 'O'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
							} else if(dataMap.AC_FORMAT5 == 'R'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
							} else if(dataMap.AC_FORMAT5 == 'P'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT5 == 'Q'){ 
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
							}
							return r;
						}
					},
					{ dataIndex: 'AC_DATA_NAME5'	,width:160	},
					{ dataIndex: 'AC_DATA6'		,width:100,
						renderer:function(value, metaData, record) {
							var r = value;
							if(dataMap.AC_FORMAT6 == 'I'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT6 == 'O'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
							} else if(dataMap.AC_FORMAT6 == 'R'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
							} else if(dataMap.AC_FORMAT6 == 'P'){
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
							} else if(dataMap.AC_FORMAT6 == 'Q'){ 
								r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
							}
							return r;
						}
					},
					{ dataIndex: 'AC_DATA_NAME6'	,width:160	}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				if (record.get('GUBUN') != '4' && record.get('GUBUN') != '0' && record.get('GUBUN') != '3') {
					view.ownerGrid.setCellPointer(view, item);
				}/*  else if (record.get('GUBUN') != '3') {
					view.ownerGrid.setCellPointer(view, item);
				} */				
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				if(grid.grid.contextMenu) {
					var inputDivi   = record.data['INPUT_DIVI'];
					if(record.get('GUBUN') != 3 && record.get('GUBUN') != 4 && record.get('GUBUN') != 0){
						if (inputDivi == '2'){
							var menuItem = grid.grid.contextMenu.down('#linkAgj205ukr');
							
						} else if (inputDivi == 'Z3'){
							var menuItem = grid.grid.contextMenu.down('#linkDgj100ukr');
							
						} else {
							var menuItem = grid.grid.contextMenu.down('#linkAgj200ukr');
						}		  
						
						if(menuItem) {
							menuItem.handler();
						}
					}
				}
			},
			render:function(grid, eOpt) {
				grid.getEl().on('click', function(e, t, eOpt) {
					activeGrid = grid.getItemId();
				});
//				var b = isTbar;
				var i=0;
//				if(b) {
//					i=0;
//				}
				var tbar = grid._getToolBar();
				tbar[0].insert(i++,{
					xtype: 'uniBaseButton',
					iconCls: 'icon-postit',
					width: 26, height: 26,
					tooltip:'각주',
					handler:function() {
						openPostIt(grid);
					}
				});
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) {
//			var inputDivi	= record.data['INPUT_DIVI'];
//
//			if (inputDivi == '2'){
				menu.down('#linkAgj200ukr').hide();
//				menu.down('#linkDgj100ukr').hide();
//				
//				menu.down('#linkAgj205ukr').show();
//			
//			} else if (inputDivi == 'Z3'){
//				menu.down('#linkAgj200ukr').hide();
//				menu.down('#linkAgj205ukr').hide();
//				
//				menu.down('#linkDgj100ukr').show();
//				
//			} else {
//				menu.down('#linkAgj205ukr').hide();
//				menu.down('#linkDgj100ukr').hide();
//				
//				menu.down('#linkAgj200ukr').show();
//			}
  		//menu.showAt(event.getXY());
  		return true;
  		},
		uniRowContextMenu:{
			items: [{
					text: '회계전표입력 보기',   
					itemId	: 'linkAgj200ukr',
					handler: function(menuItem, event) {
						var record = masterGrid.getSelectedRecord();
						var param = {
							'PGM_ID'		: 'agb110skr',
							'AC_DATE'		: record.data['AC_DATE'],
							'INPUT_PATH'	: record.data['INPUT_PATH'],
							'SLIP_NUM'		: record.data['SLIP_NUM'],
							'SLIP_SEQ'		: record.data['SLIP_SEQ'],
							'DIV_CODE'		: panelSearch.getValue('ACCNT_DIV_CODE')
						};
						masterGrid.gotoAgj200ukr(param);
					}
				},{
					text: '회계전표입력(전표번호별) 보기',   
					itemId	: 'linkAgj205ukr',
					handler: function(menuItem, event) {
						var record = masterGrid.getSelectedRecord();
						var param = {
							'PGM_ID'		: 'agb110skr',
							'AC_DATE'		: record.data['AC_DATE'],
							'INPUT_PATH'	: record.data['INPUT_PATH'],
							'SLIP_NUM'		: record.data['SLIP_NUM'],
							'SLIP_SEQ'		: record.data['SLIP_SEQ'],
							'DIV_CODE'		: panelSearch.getValue('ACCNT_DIV_CODE')
						};
						masterGrid.gotoAgj205ukr(param);
					}
				},{
					text: 'dgj100ukr 보기',   
					itemId	: 'linkDgj100ukr',
					handler: function(menuItem, event) {
						var record = masterGrid.getSelectedRecord();
						var param = {
							'PGM_ID'		: 'agb110skr',
							'AC_DATE'		: record.data['AC_DATE'],
							'INPUT_PATH'	: record.data['INPUT_PATH'],
							'SLIP_NUM'		: record.data['SLIP_NUM'],
							'SLIP_SEQ'		: record.data['SLIP_SEQ'],
							'DIV_CODE'		: panelSearch.getValue('ACCNT_DIV_CODE')
						};
						masterGrid.gotoDgj100ukr(param);
					}
				}
			]
		},
		gotoAgj200ukr:function(record) {
			if(record) {
				var params = record
			}
			var rec1 = {data : {prgID : 'agj200ukr', 'text':''}};
			parent.openTab(rec1, '/accnt/agj200ukr.do', params);
		},
		gotoAgj205ukr:function(record) {
			if(record) {
				var params = record
			}
			var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};
			parent.openTab(rec1, '/accnt/agj205ukr.do', params);
		},
		gotoDgj100ukr:function(record) {
			if(record) {
				var params = record
			}
			var rec1 = {data : {prgID : 'dgj100ukr', 'text':''}};
			parent.openTab(rec1, '/accnt/dgj100ukr.do', params);
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				
//				if(Ext.isEmpty(record.get('GUBUN'))){
//					cls = 'x-change-cell_dark';
//				}
				if(record.get('GUBUN') == '3'){
					cls = 'x-change-cell_normal';
				}
				else if(record.get('GUBUN') == '4') {
					cls = 'x-change-cell_dark';
				}
				if(record.get('MOD_DIVI') == 'D'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
			}
		}
	});   

	function openPostIt(grid) {
		var record = grid.getSelectedRecord();
		if(record && record.get('GUBUN') == '1'){
			if(!postitWindow) {
				postitWindow = Ext.create('widget.uniDetailWindow', {
					title: '각주',
					width: 350,
					height:100,
					layout: {type:'vbox', align:'stretch'},
					items: [{
						itemId:'remarkSearch',
						xtype:'uniSearchForm',
						items:[{	
							fieldLabel:'각주',
							labelWidth:60,
							name : 'POSTIT',
							width:300
						}]
					}],
					tbar:  [
						 '->',{
							itemId : 'submitBtn',
							text: '확인',
							handler: function() {
								var postIt = postitWindow.down('#remarkSearch').getValue('POSTIT');
								var aGrid =grid;
								var record = aGrid.getSelectedRecord();
								var param = {
									SLIP_DIVI	: panelSearch.getValue('SLIP_DIVI'),
									AUTO_NUM	: record.get('AUTO_NUM'),
									EX_NUM		: record.get('SLIP_NUM'),
									EX_SEQ		: record.get('SLIP_SEQ'),
									SLIP_NUM	: record.get('SLIP_NUM'),
									SLIP_SEQ	: record.get('SLIP_SEQ'),
									EX_DATE	: UniDate.getDbDateStr(record.get('AC_DATE')),
									POSTIT		: postIt
								};
								agb110skrService.updatePostIt(param, function(provider, response){});
								postitWindow.hide();
								UniAppManager.app.onQueryButtonDown();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								postitWindow.hide();
							},
							disabled: false
						},{
							itemId : 'deleteBtn',
							text: '삭제',
							handler: function() {
								var aGrid =grid;
								var record = aGrid.getSelectedRecord();
								var param = {
									SLIP_DIVI	: '1',						//회계
									AUTO_NUM	: record.get('AUTO_NUM'),
									EX_NUM		: record.get('SLIP_NUM'),
									EX_SEQ		: record.get('SLIP_SEQ'),
									SLIP_NUM	: record.get('SLIP_NUM'),
									SLIP_SEQ	: record.get('SLIP_SEQ'),
									EX_DATE	: UniDate.getDbDateStr(record.get('AC_DATE'))
								};
								agb110skrService.deletePostIt(param, function(provider, response){});
								postitWindow.hide();
								UniAppManager.app.onQueryButtonDown();
							},
							disabled: false
						}
					],
					listeners : {
						beforehide: function(me, eOpt) {
							postitWindow.down('#remarkSearch').clearForm();
						},
						beforeclose: function( panel, eOpts ) {
							postitWindow.down('#remarkSearch').clearForm();
						},
						show: function( panel, eOpts ) {
							var aGrid = grid
							var record = aGrid.getSelectedRecord();
							var param = {
								SLIP_DIVI	: '1',						//회계
								AUTO_NUM	: record.get('AUTO_NUM'),
								EX_NUM		: record.get('SLIP_NUM'),
								EX_SEQ		: record.get('SLIP_SEQ'),
								SLIP_NUM	: record.get('SLIP_NUM'),
								SLIP_SEQ	: record.get('SLIP_SEQ'),
								EX_DATE	: UniDate.getDbDateStr(record.get('AC_DATE'))
							};
							agb110skrService.getPostIt(param, function(provider, response){
						
								var form = postitWindow.down('#remarkSearch');
								form.setValue('POSTIT', provider['POSTIT']);
//								form.setValue('POSTIT_YN', provider['POSTIT_YN']);
//								form.setValue('POSTIT_USER_ID', provider['POSTIT_USER_ID']);
							});
						}
					}		
				});
			}	
			postitWindow.center();
			postitWindow.show();
		}
	}

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		id  : 'agb110skrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('AC_DATE_TO',UniDate.get('today'));

			panelSearch.down('#formFieldArea1').hide();
			panelSearch.down('#formFieldArea2').hide();
			panelResult.down('#formFieldArea1').hide();
			panelResult.down('#formFieldArea2').hide();
			
			panelSearch.down('#conArea1').hide();
			panelSearch.down('#conArea2').hide();
			panelResult.down('#conArea1').hide();
			panelResult.down('#conArea2').hide();
			
			//당기시작년월 세팅
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			//상단 툴바버튼 세팅
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);

			//초기화 시 이월금액 행 안 보이게 설정
//			var viewNormal = masterGrid.getView();
//			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);

			//초기화 시 전표일로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE_FR');

			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
				var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
				accntCommonService.fnGetAccntInfo(param, function(provider, response) {
					var dataMap = provider;
					var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
					UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);
					UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
					if(!Ext.isEmpty(params.BOOK_DATA1)){
						panelSearch.setValue('BOOK_CODE1',params.BOOK_DATA1);
						panelSearch.setValue('BOOK_CODE2',params.BOOK_DATA2);
						panelSearch.setValue('BOOK_NAME1',params.BOOK_NAME1);
						panelSearch.setValue('BOOK_NAME2',params.BOOK_NAME2);
						panelResult.setValue('BOOK_CODE1',params.BOOK_DATA1);
						panelResult.setValue('BOOK_CODE2',params.BOOK_DATA2);
						panelResult.setValue('BOOK_NAME1',params.BOOK_NAME1);
						panelResult.setValue('BOOK_NAME2',params.BOOK_NAME2);
						
						panelSearch.down('#conArea1').show();
						panelSearch.down('#conArea2').show();
						panelResult.down('#conArea1').show();
						panelResult.down('#conArea2').show();
						panelSearch.down('#formFieldArea1').show();
						panelSearch.down('#formFieldArea2').show();
						panelResult.down('#formFieldArea1').show();
						panelResult.down('#formFieldArea2').show();
						
						panelResult.down('#result_ViewPopup1').hide();
						panelSearch.down('#serach_ViewPopup1').hide();
						panelResult.down('#result_ViewPopup2').hide();
						panelSearch.down('#serach_ViewPopup2').hide();
					}
					
					//var viewNormal = masterGrid.getView();
					//viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
					//viewNormal.getFeature('masterGridTotal').showSummaryRow = true;
					UniAppManager.app.onQueryButtonDown();
				})
			}
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			//summaryrow에 set할 변수 초기화
			 drAmtI1	= 0;
			 crAmtI1	= 0;
			 janAmtI1	= 0;
			 drForAmtI1	= 0;
			 crForAmtI1	= 0;
			 janForAmtI1= 0;	
			
//			var viewNormal = masterGrid.getView();
//			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);

			masterGrid.reset();
			UniAppManager.setToolbarButtons('save',false);
			masterStore.clearData();
			
			//viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

			masterStore.loadStoreRecords();
		},
		
		//링크로 넘어오는 params 받는 부분 
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'agb100skr') {
				panelSearch.setValue('AC_DATE_FR',params.AC_DATE);
				panelSearch.setValue('AC_DATE_TO',params.AC_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE',params.DIV_CODE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelSearch.setValue('START_DATE',params.START_DATE);
				
				panelResult.setValue('AC_DATE_FR',params.AC_DATE);
				panelResult.setValue('AC_DATE_TO',params.AC_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
			}
			else if(params.PGM_ID == 'agb101skr' || params.PGM_ID == 'agb120skr' || params.PGM_ID == 'agb125skr') {
				panelSearch.setValue('AC_DATE_FR',params.AC_DATE_FR);
				panelSearch.setValue('AC_DATE_TO',params.AC_DATE_TO);
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelSearch.setValue('START_DATE',params.START_DATE);
				
				panelResult.setValue('AC_DATE_FR',params.AC_DATE_FR);
				panelResult.setValue('AC_DATE_TO',params.AC_DATE_TO);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
			}
			else if(params.PGM_ID == 'agc130skr') {		// 재무제표
				panelSearch.setValue('START_DATE',params.ST_DATE);
				panelSearch.setValue('AC_DATE_FR',params.FR_DATE);
				panelSearch.setValue('AC_DATE_TO',params.TO_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE',params.DIV_CODE);	
				panelSearch.setValue('ACCNT_CODE',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);

				panelResult.setValue('START_DATE',params.ST_DATE);
				panelResult.setValue('AC_DATE_FR',params.FR_DATE);
				panelResult.setValue('AC_DATE_TO',params.TO_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);

			}
			else if(params.PGM_ID == 'agc170skr') {		// 월별 재무제표
				panelSearch.setValue('START_DATE',params.ST_DATE);
				panelSearch.setValue('AC_DATE_FR',params.FR_DATE);
				panelSearch.setValue('AC_DATE_TO',params.TO_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE',params.DIV_CODE);	
				panelSearch.setValue('ACCNT_CODE',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);

				panelResult.setValue('START_DATE',params.ST_DATE);
				panelResult.setValue('AC_DATE_FR',params.FR_DATE);
				panelResult.setValue('AC_DATE_TO',params.TO_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);

			}
			else if(params.PGM_ID == 'agb140skr') {
				panelSearch.setValue('AC_DATE_FR',params.FR_DATE);
				panelSearch.setValue('AC_DATE_TO',params.TO_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE',params.DIV_CODE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelSearch.setValue('START_DATE',params.START_DATE);
				
				panelSearch.setValue('BOOK_CODE1',params.BOOK_DATA1);
				panelSearch.setValue('BOOK_CODE2',params.BOOK_NAME1);
				panelSearch.setValue('BOOK_NAME1',params.BOOK_DATA2);
				panelSearch.setValue('BOOK_NAME2',params.BOOK_NAME2);
				
				panelResult.setValue('AC_DATE_FR',params.FR_DATE);
				panelResult.setValue('AC_DATE_TO',params.TO_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
				
				panelResult.setValue('BOOK_CODE1',params.BOOK_DATA1);
				panelResult.setValue('BOOK_CODE2',params.BOOK_NAME1);
				panelResult.setValue('BOOK_NAME1',params.BOOK_DATA2);
				panelResult.setValue('BOOK_NAME2',params.BOOK_NAME2);
			}
			else if(params.PGM_ID == 'agc100skr') {
				panelSearch.setValue('AC_DATE_FR',params.FR_DATE);
				panelSearch.setValue('AC_DATE_TO',params.TO_DATE);
				panelSearch.setValue('START_DATE',params.ST_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				
				panelResult.setValue('AC_DATE_FR',params.FR_DATE);
				panelResult.setValue('AC_DATE_TO',params.TO_DATE);
				panelResult.setValue('START_DATE',params.ST_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
			}
			else if(params.PGM_ID == 'agc110skr') {
				panelSearch.setValue('AC_DATE_FR',params.FR_DATE);
				panelSearch.setValue('AC_DATE_TO',params.TO_DATE);
				panelSearch.setValue('START_DATE',params.ST_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelSearch.setValue('START_DATE',params.START_DATE);
				
				panelResult.setValue('AC_DATE_FR',params.FR_DATE);
				panelResult.setValue('AC_DATE_TO',params.TO_DATE);
				panelResult.setValue('START_DATE',params.ST_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
			}else if(params.PGM_ID == 'agb150skr'){	//계정명세조회(화폐단위별)
				panelSearch.setValue('START_DATE',params.START_DATE);
				panelSearch.setValue('AC_DATE_FR',params.FR_DATE);
				panelSearch.setValue('AC_DATE_TO',params.TO_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE',params.DIV_CODE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				
				panelResult.setValue('AC_DATE_FR',params.FR_DATE);
				panelResult.setValue('AC_DATE_TO',params.TO_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
			}else if(params.PGM_ID == 'agb270skr'){	//거래처별채권채무현황
				panelSearch.setValue('START_DATE',params.START_DATE);
				panelSearch.setValue('AC_DATE_FR',params.FR_DATE);
				panelSearch.setValue('AC_DATE_TO',params.TO_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelSearch.setValue('MONEY_UNIT',params.MONEY_UNIT);
				
				panelResult.setValue('START_DATE',params.START_DATE);
				panelResult.setValue('AC_DATE_FR',params.FR_DATE);
				panelResult.setValue('AC_DATE_TO',params.TO_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelResult.setValue('MONEY_UNIT',params.MONEY_UNIT);
			}else if(params.PGM_ID == 'afb240skr'){	//부서별예산실적조회
				panelSearch.setValue('START_DATE',params.START_DATE);
				panelSearch.setValue('AC_DATE_FR',params.FR_DATE);
				panelSearch.setValue('AC_DATE_TO',params.TO_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelSearch.setValue('DIV_CODE',params.DIV_CODE);
				panelSearch.setValue('DEPT_CODE_FR',params.DEPT_CODE);
				panelSearch.setValue('DEPT_CODE_TO',params.DEPT_CODE);
				panelSearch.setValue('DEPT_NAME_FR',params.DEPT_NAME);
				panelSearch.setValue('DEPT_NAME_TO',params.DEPT_NAME);
				
				panelResult.setValue('START_DATE',params.START_DATE);
				panelResult.setValue('AC_DATE_FR',params.FR_DATE);
				panelResult.setValue('AC_DATE_TO',params.TO_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelResult.setValue('DIV_CODE',params.DIV_CODE);
				panelResult.setValue('DEPT_CODE_FR',params.DEPT_CODE);
				panelResult.setValue('DEPT_CODE_TO',params.DEPT_CODE);
				panelResult.setValue('DEPT_NAME_FR',params.DEPT_NAME);
				panelResult.setValue('DEPT_NAME_TO',params.DEPT_NAME);
				
			}else if(params.PGM_ID == 'afb260skr'){  //부서별경비내역서
				panelSearch.setValue('START_DATE',params.START_DATE);
				panelSearch.setValue('AC_DATE_FR',params.FR_DATE);
				panelSearch.setValue('AC_DATE_TO',params.TO_DATE);
				//panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelSearch.setValue('DIV_CODE',params.DIV_CODE);
				panelSearch.setValue('DEPT_CODE_FR',params.DEPT_CODE);
				panelSearch.setValue('DEPT_CODE_TO',params.DEPT_CODE);
				panelSearch.setValue('DEPT_NAME_FR',params.DEPT_NAME);
				panelSearch.setValue('DEPT_NAME_TO',params.DEPT_NAME);
				
				panelResult.setValue('START_DATE',params.START_DATE);
				panelResult.setValue('AC_DATE_FR',params.FR_DATE);
				panelResult.setValue('AC_DATE_TO',params.TO_DATE);
				//panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelResult.setValue('DIV_CODE',params.DIV_CODE);
				panelResult.setValue('DEPT_CODE_FR',params.DEPT_CODE);
				panelResult.setValue('DEPT_CODE_TO',params.DEPT_CODE);
				panelResult.setValue('DEPT_NAME_FR',params.DEPT_NAME);
				panelResult.setValue('DEPT_NAME_TO',params.DEPT_NAME);
				
			} else if(params.PGM_ID == 'atx150skr'){ //부가세 집계 대조표
				panelSearch.setValue('AC_DATE_FR',params.FR_DATE);
				panelSearch.setValue('AC_DATE_TO',params.TO_DATE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				
				panelResult.setValue('AC_DATE_FR',params.FR_DATE);
				panelResult.setValue('AC_DATE_TO',params.TO_DATE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
				
				//신고사업장에 포함된 사업장 코드 SET
				var setDivCode = new Array();
				for (var i = 0; i < params.DIV_CODE.length; i++) {
					setDivCode.push(params.DIV_CODE[i].DIV_CODE);
				};
				panelSearch.setValue('ACCNT_DIV_CODE',setDivCode);
				panelResult.setValue('ACCNT_DIV_CODE',setDivCode);
				
				//당기시작월 세팅
				var newValue = params.FR_DATE.substring(0,4) + '-' + params.FR_DATE.substring(4,6) + '-' + params.FR_DATE.substring(6,8);
				newValue = new Date(newValue);
				UniAppManager.app.fnSetStDate(newValue);
			}
			else if(params.PGM_ID == 'agb310skr') {
				panelSearch.setValue('AC_DATE_FR',params.FR_DATE);
				panelSearch.setValue('AC_DATE_TO',params.TO_DATE);
				panelSearch.setValue('START_DATE',params.ST_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				//20200330 추가: 거래처 정보 받아서 set하는 로직 추가
				panelSearch.setValue('CUSTOM_CODE',params.CUSTOM_CODE);
				panelSearch.setValue('CUSTOM_NAME',params.CUSTOM_NAME);
				
				panelResult.setValue('AC_DATE_FR',params.FR_DATE);
				panelResult.setValue('AC_DATE_TO',params.TO_DATE);
				panelResult.setValue('START_DATE',params.ST_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
			}
			else if(params.PGM_ID == 'afb200skr') {	//부서별예산실적조회
				panelSearch.setValue('START_DATE',params.ST_DATE);
				panelSearch.setValue('AC_DATE_FR',params.FR_DATE);
				panelSearch.setValue('AC_DATE_TO',params.TO_DATE);
				panelSearch.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelSearch.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelSearch.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelSearch.setValue('DEPT_CODE_FR',params.DEPT_CODE);
				panelSearch.setValue('DEPT_CODE_TO',params.DEPT_CODE);
				panelSearch.setValue('DEPT_NAME_FR',params.DEPT_NAME);
				panelSearch.setValue('DEPT_NAME_TO',params.DEPT_NAME);
				
				panelResult.setValue('START_DATE',params.ST_DATE);
				panelResult.setValue('AC_DATE_FR',params.FR_DATE);
				panelResult.setValue('AC_DATE_TO',params.TO_DATE);
				panelResult.setValue('ACCNT_DIV_CODE',params.ACCNT_DIV_CODE);
				panelResult.setValue('ACCNT_CODE',params.ACCNT_CODE);
				panelResult.setValue('ACCNT_NAME',params.ACCNT_NAME);
				panelResult.setValue('DEPT_CODE_FR',params.DEPT_CODE);
				panelResult.setValue('DEPT_CODE_TO',params.DEPT_CODE);
				panelResult.setValue('DEPT_NAME_FR',params.DEPT_NAME);
				panelResult.setValue('DEPT_NAME_TO',params.DEPT_NAME);
				
			}
		},
		//당기시작월 세팅
		fnSetStDate: function(newValue) {
			if(newValue == null){
				return false;
			}else{
				if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
		}
	});
};
</script>