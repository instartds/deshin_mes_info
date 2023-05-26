<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbo300ukr">
	<t:ExtComboStore comboType="AU" comboCode="H005"/>						<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H011"/>						<!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H028"/>						<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031"/>						<!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" opts= '${gsList1}'/>	<!-- 상여구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="H037"/>						<!-- 상여구분자 -->
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">

var outDivCode = UserInfo.divCode;

function appMain() {
	var excelWindow;
	var gsList1 = '${gsList1}';					//지급구분 '1'이 아닌것만 콤보에서 보이도록 설정

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hbo300ukrService.selectList',
			update	: 'hbo300ukrService.update',
			create	: 'hbo300ukrService.insert',
			destroy	: 'hbo300ukrService.delete',
			syncAll	: 'hbo300ukrService.saveAll'
		}
	});

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hbo300ukrModel', {
		fields: [
			{name: 'DIV_CODE'				, text: '사업장'			, type: 'string'	, xtype: 'uniCombobox', comboType: 'BOR120', editable: false},
			{name: 'SUPP_TYPE'				, text: '상여구분'			, type: 'string'	, editable: false, comboType: 'AU' ,comboCode: 'H032' },
			{name: 'PAY_YYYYMM'				, text: '상여년월'			, type: 'string'	, editable: false},
			{name: 'DEPT_NAME'				, text: '부서'			, type: 'string'	, editable: false},
			{name: 'POST_NAME'				, text: '직위'			, type: 'string'	, editable: false/*, xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H005',*/},
			{name: 'NAME'					, text: '성명'			, type: 'string'	, allowBlank: false},
			{name: 'PERSON_NUMB'			, text: '사번'			, type: 'string'	, allowBlank: false},
			{name: 'JOIN_DATE'				, text: '입사일'			, type: 'uniDate'	, editable: false},
			{name: 'RETR_DATE'				, text: '퇴사일'			, type: 'uniDate'	, editable: false},
			{name: 'PAY_CODE'				, text: '급여지급방식'		, type: 'string'}	,
			{name: 'BONUS_KIND'				, text: '상여구분자'			, type: 'string'	, editable: false/*, comboType: 'AU', comboCode: 'H037'*/},		//20210824 부분주석: 조회할 때 명을 가져옴
			{name: 'LONG_MONTH'				, text: '근속개월'			, type: 'int'		, editable: false},
			{name: 'BONUS_RATE'				, text: '상여율'			, type: 'string'},
			{name: 'SUPP_RATE'				, text: '지급율'			, type: 'float'		, decimalPrecision: 2, format:'0,000.00'},
			{name: 'BONUS_STD_I'			, text: '상여기준금'			, type: 'uniPrice'	, editable: false},
			{name: 'BONUS_I'				, text: '상여과세금액'		, type: 'uniPrice'},
			{name: 'BONUS_TOTAL_I'			, text: '상여금'			, type: 'uniPrice'},
			{name: 'BONUS_TAX_I'			, text: '상여총액'			, type: 'uniPrice'},
			{name: 'SUPP_TOTAL_I'			, text: '지급액'			, type: 'uniPrice'},
			{name: 'COMP_TAX_I'				, text: '세액계산여부'		, type: 'string'},
			{name: 'TAX_CODE'				, text: '세액구분'			, type: 'string'},
			{name: 'BANK_CODE'				, text: '급여은행'			, type: 'string'},
			{name: 'BANK_ACCOUNT1'			, text: '계좌번호'			, type: 'string'},
			{name: 'SPOUSE'					, text: '배우자'			, type: 'string'},
			{name: 'SUPP_AGED_NUM'			, text: '부양가족수'			, type: 'string'},
			{name: 'PAY_GUBUN'				, text: '고용형태'			, type: 'string'},
			{name: 'PAY_GUBUN2' 			, text: '일용직/일반직'		, type: 'string'},
			{name: 'CHILD_20_NUM'			, text: '20세이하자녀수'		, type: 'string'}
		]
	});		// End of Ext.define('Hbo300ukrModel', {

	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.hbo300ukr.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'	, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.human.companycode"	default="법인코드"/>'	, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.human.division"		default="사업장"/>'	, type: 'string'},
			{name: 'PAY_YYYYMM'		, text: '<t:message code=""  								default="상여년월"/>'	, type: 'string', allowBlank: false},
			{name: 'DEPT_NAME'		, text: '<t:message code="system.label.human.deptname"		default="부서"/>'		, type: 'string', allowBlank: false},
			{name: 'POST_NAME'		, text: '<t:message code="system.label.human.postcode"		default="직위"/>'		, type: 'string'},
			{name: 'NAME'			, text: '<t:message code="system.label.human.name"			default="성명"/>'		, type: 'string'},
			{name: 'PERSON_NUMB'	, text: '<t:message code="system.label.human.personnumb"	default="사번"/>' 	, type: 'string', allowBlank: false},
			{name: 'JOIN_DATE'		, text: '<t:message code=""									default="입사일"/>'	, type: 'uniDate'},
			{name: 'RETR_DATE'		, text: '<t:message code=""									default="퇴사일"/>'	, type: 'uniDate', allowBlank: false},
			{name: 'SUPP_TYPE'		, text: '<t:message code=""									default="상여구분"/>'	, type: 'string', comboType:'AU', comboCode:'H032'},
			{name: 'LONG_MONTH'		, text: '<t:message code=""									default="근속개월"/>'	, type: 'int'},
			{name: 'BONUS_RATE'		, text: '<t:message code=""									default="지급율"/>'	, type: 'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'BONUS_STD_I'	, text: '<t:message code=""									default="상여기준금"/>'	, type: 'uniPrice'} ,
			{name: 'SUPP_TOTAL_I'	, text: '<t:message code=""									default="지급액"/>'	, type: 'uniPrice'}
		]
	});


	/* Store 정의(Service 정의)
	 * @type 
	 */
	var masterStore = Unilite.createStore('hbo300MasterStore',{
		model: 'Hbo300ukrModel',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad		: false,
		proxy			:directProxy,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();

			console.log("toUpdate",toUpdate);
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.get('SUPP_RATE') == 0 && record.get('SUPP_TOTAL_I') == 0){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '지급율: 필수 입력값 입니다.\n' + '지급액: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;

			if(inValidRecs.length == 0 )	{
				config = {
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
					} 
				};
				this.syncAllDirect(config);
				UniAppManager.setToolbarButtons('save', false);
//				UniAppManager.app.onQueryButtonDown();
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
				var viewNormal = masterGrid.getView();
				if(store.getCount() > 0){
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				}else{
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
				}
			}
		}
	});



	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed:true,
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
				fieldLabel	: '상여년월',
				xtype		: 'uniMonthfield',
				name		: 'PAY_YYYYMM',
				id			: 'PAY_YYYYMM',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
			},{
				fieldLabel	: '상여구분',
				xtype		: 'uniCombobox',
				name		: 'SUPP_TYPE',
				id			: 'SUPP_TYPE',
				comboType	: 'AU',
				comboCode	: 'H032',
				allowBlank	: false	,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SUPP_TYPE', newValue);
					}
				}			
			},{
				fieldLabel	: '사업장',
				xtype		: 'uniCombobox',
				name		: 'DIV_CODE',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel		: '부서',
				valueFieldName	: 'DEPT',
				textFieldName	: 'DEPT_NAME',
				valuesName		: 'DEPTS',
				DBvalueFieldName: 'TREE_CODE',
				DBtextFieldName	: 'TREE_NAME',
				selectChildren	: true,
				validateBlank	: false,
				autoPopup		: false,
				useLike			: true,
				listeners		: {
					'onValueFieldChange'	: function(field, newValue, oldValue  ){
							panelResult.setValue('DEPT',newValue);
					},
					'onTextFieldChange'		:  function( field, newValue, oldValue  ){
							panelResult.setValue('DEPT_NAME',newValue);
					},
					'onValuesChange'		:  function( field, records){
							var tagfield = panelResult.getField('DEPTS') ;
							tagfield.setStoreData(records)
					}
				}
			}),{
				fieldLabel	: '지급기준일',
				xtype		: 'uniDatefield',
				name		: 'BASE_DATE',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BASE_DATE', newValue);
					},
					focusleave: function( panelResult, event, eOpts ) {
						var baseDate = UniDate.getDbDateStr(panelSearch.getValue('BASE_DATE'));
						
						if (!Ext.isEmpty(baseDate) && baseDate.length == 8) {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			},{
				fieldLabel	: '급여지급방식',
				xtype		: 'uniCombobox',
				name		:'PAY_CODE',
				comboType	:'AU',
				comboCode	:'H028',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '지급차수',
				xtype		: 'uniCombobox',
				name		: 'PAY_DAY_FLAG',
				comboType	: 'AU',
				comboCode	: 'H031',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_DAY_FLAG', newValue);
					}
				}
			},{
				fieldLabel	: '고용형태',
				xtype		: 'uniCombobox', 
				name		: 'PAY_GUBUN',
				comboType	: 'AU',
				comboCode	: 'H011',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_GUBUN', newValue);
					}
				}
			},{
				fieldLabel	: '직위',
				xtype		: 'uniCombobox',
				name		: 'POST_CODE', 
				comboType	: 'AU',
				comboCode	: 'H005',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('POST_CODE', newValue);
					}
				}
			},{
				text		: '대상자일괄생성',
				xtype		: 'button',
				margin		: '10 100 0 100',
				width		: 100,
				listeners	: {
					click: {
						fn: function(){
							if(!panelSearch.getInvalidMessage()){
								return false;
							} else {
								if (Ext.isEmpty(panelSearch.getValue('BASE_DATE'))) {
									alert(Msg.sMB211);
									return false;
								} else {
									//기존 데이터가 있는지 체크
									var param = Ext.getCmp('searchForm').getValues();
									hbo300ukrService.checkData(param, function(provider, response)	{
										if (provider > 0) {
											if (confirm(Msg.sMB212)) {
												popupWindow.center();
												popupWindow.show();
											}
										} else {
											popupWindow.center();
											popupWindow.show();
											alert('해당 사원이 존재하지 않습니다.');
										}
									});
								}
							}
						}
					}
				}
			}]
		}]
	});	//end panelSearch  

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4,
		tableAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'}//,
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '상여년월',
			xtype		: 'uniMonthfield',
			name		: 'PAY_YYYYMM',
 			value		: UniDate.get('today'),
			allowBlank	: false,
			tdAttrs: {width: 380},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PAY_YYYYMM', newValue);
				}
			}
		},{
			fieldLabel	: '상여구분',
			xtype		: 'uniCombobox',
			name		: 'SUPP_TYPE',
			id			: 'SUPP_TYPE2',
			comboType	: 'AU',
			comboCode	: 'H032',
			allowBlank	: false	,
			tdAttrs: {width: 380},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SUPP_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: '지급기준일',
			xtype		: 'uniDatefield',
			name		: 'BASE_DATE',
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASE_DATE', newValue);
				},
				focusleave: function( panelResult, event, eOpts ) {
					var baseDate = UniDate.getDbDateStr(panelResult.getValue('BASE_DATE'));
					
					if (!Ext.isEmpty(baseDate) && baseDate.length == 8) {
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}
		},{
			fieldLabel	: '사업장',
			xtype		: 'uniCombobox',
			name		: 'DIV_CODE',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel		: '부서',
			valueFieldName	: 'DEPT',
			textFieldName	: 'DEPT_NAME' ,
			valuesName		: 'DEPTS' ,
			DBvalueFieldName: 'TREE_CODE',
			DBtextFieldName	: 'TREE_NAME',
			selectChildren	: true,
			validateBlank	: false,
			autoPopup		: false,
			useLike			: true,
			listeners		: {
				'onValueFieldChange'	: function(field, newValue, oldValue  ){
						panelSearch.setValue('DEPT',newValue);
				},
				'onTextFieldChange'		:  function( field, newValue, oldValue  ){
						panelSearch.setValue('DEPT_NAME',newValue);
				},
				'onValuesChange'		:  function( field, records){
						var tagfield = panelSearch.getField('DEPTS') ;
						tagfield.setStoreData(records)
				}
			}
		}),{
			fieldLabel	: '직위',
			xtype		: 'uniCombobox',
			name		: 'POST_CODE', 
			comboType	: 'AU',
			comboCode	: 'H005',
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('POST_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '급여지급방식',
			xtype		: 'uniCombobox',
			name		:'PAY_CODE', 	
			comboType	:'AU',
			comboCode	:'H028',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PAY_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '지급차수',
			xtype		: 'uniCombobox',
			name		: 'PAY_DAY_FLAG', 	
			comboType	: 'AU',
			comboCode	: 'H031',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PAY_DAY_FLAG', newValue);
				}
			}
		},{
			fieldLabel	: '고용형태',
			xtype		: 'uniCombobox', 
			name		: 'PAY_GUBUN', 	
			comboType	: 'AU',
			comboCode	: 'H011',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PAY_GUBUN', newValue);
				}
			}
		},{
			text		: '대상자일괄생성',
			xtype		: 'button',
			tdAttrs: {flex: 1, align: 'right'},
			width		: 100,
			listeners	: {
				click: {
					fn: function(){
						if(!panelSearch.getInvalidMessage()){
							return false;
						} else {
							if (Ext.isEmpty(panelSearch.getValue('BASE_DATE'))) {
								alert(Msg.sMB211);
								return false;
							} else {
								//기존 데이터가 있는지 체크
								var param = Ext.getCmp('searchForm').getValues();
								hbo300ukrService.checkData(param, function(provider, response)	{
									if (provider > 0) {
										if (confirm(Msg.sMB212)) { 
											popupWindow.center();
											popupWindow.show();
										}
									} else {
										popupWindow.center();
										popupWindow.show();
									}
								});
							}
						}
					}
				}
			}
		}]
	});
	var subForm = Unilite.createForm('sub3Form',{	//그밖의공제매입세액
		padding:'0 0 0 0',
		disabled: false,
		bodyPadding: 10,
		region: 'center',
		layout: {
			type: 'uniTable',
			columns:1
//			tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		items: [{
			fieldLabel: '지급율  ',
			id: 'FIX_RATE',
			width: 200,
			xtype: 'uniNumberfield',
			name: 'FIX_RATE',
			value: '0'
		},{
			fieldLabel: '지급액  ',
			id: 'FIX_AMT',
			width: 200,
			xtype: 'uniNumberfield',
			name: 'FIX_AMT',
			value: '0'
		}]
	});

//	'widget.uniDetailWindow
	var popupWindow = Ext.create('widget.uniDetailWindow', {
			title : '대상자일괄생성',			
			width : 300,
			height : 135,			
			layout : {
				type : 'vbox',
				align: 'center'
			},			
			items : [subForm],
			bbar : ['->',{
				itemId : 'run',
				text : '실행',					
				handler : function() {
					runProc();
				},					
				disabled : false
				
			 },{
				itemId : 'closeBtn',
 				text : '닫기',					
 				handler : function() {
 					popupWindow.hide();
 				},					
 				disabled : false				 
			 }
			 
			],
 			listeners : {
 				beforehide : function(me, eOpt) {
 					subForm.clearForm();
 					subForm.setValue('FIX_RATE', 0);
 					subForm.setValue('FIX_AMT', 0);
// 					estimateGrid.reset();
 					
// 					alert('하이드');
 				}/*,
 				beforeclose : function(panel, eOpts) {
 					//estimateSearch.clearForm();
 					//estimateGrid,reset();
 					alert('크로즈');
 				},
 				beforeshow : function(me, eOpts) {
 					estimateStore.loadStoreRecords();
 				}*/
 			}
		})		
	
	//대상자일괄생성 (SP 붙이는 작업 남음)
	function runProc() {
/*
	If IsArray(gaPopRet)  THEN

		bParam(0) = ""									:			bParam(1) = fnDefaultDate(txtPayYyyyMm.value)
		bParam(2) = fnDisCombo(ComRs, 1, txtSuppType)	:			bParam(3) = ""
		bParam(4) = ""									:			bParam(5) = "0000-00-00" '지급일
		bParam(6) = ""									:			bParam(7) = "000000"
		bParam(8) = "000000"							:			bParam(9) = "N"
		bParam(10) = fnDefaultDate(txtBaseDate.value)			  '기준일
		bParam(11) = gaPopRet(1)					   '지급액
		bParam(12) = gaPopRet(0)					   '지급율
		bParam(13) = goCnn.getUi("USER_ID")					   '지급율
		bParam(14) = fnDisCombo(ComRs, 4, txtDivCode)					   '사업장
		bParam(15) = Trim(txtBuserFr.Value)					   '부서fr
		bParam(16) = Trim(txtBuserTo.Value)					   '부서to
		
		bParam(17) =  fnDisCombo(ComRs, 2, txtPayCode) 
		bParam(18) =  fnDisCombo(ComRs, 3, txtPayDayFlag) 
		bParam(19) =  fnDisCombo(ComRs, 5, txtPayGubun) 		
		bParam(20) =  gsAuParam(8)
		bParam(21) =  fnDisCombo(ComRs, 6, cboPosition)

		retVal	= goInterface.CallFunction(gsCert, "UHbo02Krv.CHbo310UKr", "fnHbo210B", bParam, "N")

		If retVal <> ""  Then
			Call	fnMsgBox(goCnn, sMB214, retVal) '대상자일괄생성중 오류가 발생했습니다.
			Exit	Sub
		End If
			Call	goCnn.MsgBox(sMH1145 , vbExclamation, sMB099)

		Call	goCnn_OnQueryButtonDown()

	 End	If

END SUB*/
		var param= Ext.getCmp('searchForm').getValues();
		param.FIX_RATE = Ext.getCmp('FIX_RATE').getValue();
		param.FIX_AMT = Ext.getCmp('FIX_AMT').getValue();
		
		var rate = Ext.getCmp('FIX_RATE').getValue();
		var amt = Ext.getCmp('FIX_AMT').getValue();
		
		console.log(param);
		
//		alert(rate+" : "+amt+" : "+((rate!='')&&(rate != '0')) + " : " +((amt!='')&&(amt != '0')));

		if( (rate != null && rate != '0') && (amt != null && amt != '0') ){
			Ext.Msg.alert('확인','지급율, 지급액 중 한가지만 입력하십시오.');
		}else{
			hbo300ukrService.procHbo300(param, function(provider, response)	{
				if (provider) {
					alert(Msg.sMB021); 
					popupWindow.hide();
					UniAppManager.app.onQueryButtonDown();
					
				} else {
					popupWindow.hide();
				}
			});
		}
	}

	/* Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('hbo300Grid1', {
		layout : 'fit',
		region : 'center',
		store : masterStore,
		uniOpt : {	
			useMultipleSorting	: true,		
			useLiveSearch		: false,	
			onLoadSelectFirst	: true,		//체크박스모델은 false로 변경
			dblClickToEdit		: true,	
			useGroupSummary		: false,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	// rink 항목이 있을경우만 true
			filter: {			
				useFilter	: false,	
				autoCreate	: true	
			}			
		},
		
		tbar  : [{
			text	: '상여정보 업로드',
			id  : 'excelBtn',
			width   : 150,
			handler : function() {
				if(!panelResult.getInvalidMessage()) return;   //필수체크
				openExcelWindow();
			}
		}],
		
		features : [ 
		{
			id : 'masterGridSubTotal',
			ftype : 'uniGroupingsummary',
			showSummaryRow : false				
		},{
			id : 'masterGridTotal',
			ftype : 'uniSummary',
			showSummaryRow : false
		} ],
		columns : [
			{dataIndex : 'DIV_CODE',	width : 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					   return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
				}
			},
			{dataIndex : 'SUPP_TYPE',	width : 100,	hidden : false},
			{dataIndex : 'PAY_YYYYMM',	width : 80,		hidden : false,	align: 'center',
				renderer:function(value, metaData, record)	{
					var r = value;
					if(r.length == 6) {
						var year	= r.substring(0, 4);
						var mon		= r.substring(5, 6);
						var r		= year + '.' + (mon > 9 ? mon : '0' + mon);
					}
					return r;
				}
			},
			{dataIndex : 'DEPT_NAME',	width : 180},					
			{dataIndex : 'POST_NAME',	width : 100},
			{dataIndex : 'NAME',		width : 100,
				editor : Unilite.popup('Employee_G', {					
					textFieldName: 'NAME',
					autoPopup: true,
					listeners : {
						'onSelected' : {
							fn : function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
								console.log('grdRecord',grdRecord);
								grdRecord.set('DIV_CODE', records[0].DIV_CODE);
								grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
								grdRecord.set('POST_NAME', records[0].POST_CODE_NAME);
// 									grdRecord.set('POST_NAME', records[0].POST_NAME);
								grdRecord.set('NAME', records[0].NAME);
								grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
								grdRecord.set('JOIN_DATE', records[0].JOIN_DATE);
								grdRecord.set('RETR_DATE', records[0].RETR_DATE);
								grdRecord.set('BONUS_KIND', records[0].BONUS_KIND);
								grdRecord.set('LONG_MONTH', records[0].LONG_MONTH);
								grdRecord.set('BONUS_STD_I', records[0].BONUS_STD_I);
								grdRecord.set('BONUS_I', records[0].BONUS_I);
							},
							scope : this
						}
// 								'onClear' : function(type) {
// 									masterGrid.setItemData(null, true);
// 								}
					}
				})
			}, 
			{dataIndex : 'PERSON_NUMB',		width : 100,
				editor : Unilite.popup('Employee_G', {					
					textFieldName: 'NAME',
					autoPopup: true,
					listeners : {
						'onSelected' : {
							fn : function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
								console.log('grdRecord',grdRecord);
								grdRecord.set('DIV_CODE', records[0].DIV_CODE);
								grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
								grdRecord.set('POST_NAME', records[0].POST_CODE);										
								grdRecord.set('NAME', records[0].NAME);
								grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
								grdRecord.set('JOIN_DATE', records[0].JOIN_DATE);
								grdRecord.set('RETR_DATE', records[0].RETR_DATE);
								grdRecord.set('BONUS_KIND', records[0].BONUS_KIND);
								grdRecord.set('LONG_MONTH', records[0].LONG_MONTH);
								grdRecord.set('BONUS_STD_I', records[0].BONUS_STD_I);
								grdRecord.set('BONUS_I', records[0].BONUS_I);
							},
							scope : this
						},
						'onClear' : function(type) {
							masterGrid.setItemData(null, true);
						}
					}
				}) 
			},
			{dataIndex : 'JOIN_DATE',		width : 93},
			{dataIndex : 'RETR_DATE',		width : 93},
			{dataIndex : 'PAY_CODE',		width : 80,		hidden : true},
			{dataIndex : 'BONUS_KIND',		width : 93,		summaryType: 'totaltext'}, 
			{dataIndex : 'LONG_MONTH',		width : 80}, 
			{dataIndex : 'BONUS_RATE',		width : 53,		hidden : true}, 
			{dataIndex : 'SUPP_RATE',		width : 80,
				editor: {
					listeners: {
						'change': {
							fn : function(records){
								//지급율 * 상여기준금 / 100 = 지급액										
								var grdRecord = masterGrid.getSelectionModel().getSelection();										
								var rate = this.value;
								var bonus = grdRecord[0].data.BONUS_STD_I;
								var amt = rate * bonus / 100;
								console.log(masterGrid.getSelectionModel());
								grdRecord[0].set("SUPP_TOTAL_I",amt);
							}
						}
					}
				}
			},
			{dataIndex : 'BONUS_STD_I',		width : 86,		summaryType: 'sum'},
			{dataIndex : 'BONUS_I',			width : 86,		hidden : true},
			{dataIndex : 'BONUS_TOTAL_I',	width : 86,		hidden : true}, 
			{dataIndex : 'BONUS_TAX_I',		width : 86,		hidden : true},					 
			{dataIndex : 'SUPP_TOTAL_I',	width : 150,	summaryType: 'sum',
				editor: {
					listeners: {
						'change': {
							fn : function(records){										
									var grdRecord = masterGrid.getSelectionModel().getSelection();
//										grdRecord[0].set("SUPP_RATE","0");									
													
// 										console.log("this ::", this);
// 										console.log("records ::", records);
							}
						}
					}
				}
			},
			{dataIndex : 'COMP_TAX_I',		width : 86,		hidden : true},
			{dataIndex : 'TAX_CODE',		width : 70,		hidden : true}, 
			{dataIndex : 'BANK_CODE',		width : 100,	hidden : true}, 
			{dataIndex : 'BANK_ACCOUNT1',	width : 100,	hidden : true}, 
			{dataIndex : 'SPOUSE',			width : 66,		hidden : true}, 
			{dataIndex : 'SUPP_AGED_NUM',	width : 66,		hidden : true},
			{dataIndex : 'PAY_GUBUN',		width : 66,		hidden : true}, 
			{dataIndex : 'PAY_GUBUN2',		width : 66,		hidden : true}, 
			{dataIndex : 'CHILD_20_NUM',	width : 66,		hidden : true} 
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
  					if(UniUtils.indexOf(e.field, ['SUPP_RATE', 'SUPP_TOTAL_I'])) 
					{ 
						return true;
					} else {
						return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB', 'SUPP_RATE', 'SUPP_TOTAL_I'])) 
					{
						return true;
					} else {
						return false;
					}
				}
			}
		}
	});

	Unilite.Main({
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]	
		}		
		,panelSearch
		], 
		id: 'hp350ukrApp',
		
		fnInitBinding : function(params) {
			//공통코드(H032) 값 콤보에 세팅
			var store = Ext.getStore('CBS_AU_H032');						
			var selectedModel = store.getRange();
				Ext.each(selectedModel, function(record,i){	   
					if (record.data.value == 'F'||record.data.value == 'G'||record.data.value == 'L'||record.data.value == 'M') {									
						store.remove(record);																		  
					}				   
				});
			var combo = Ext.getCmp('SUPP_TYPE');
			var combo2 = Ext.getCmp('SUPP_TYPE2');
			
			console.log("combo",combo);
			combo.bindStore('CBS_AU_H032');
			combo2.bindStore('CBS_AU_H032');
			
			//공통코드(H032)에서 부가세 유형(수출유형)콤보 첫번째 값 가져오기
			var suppTypeSelect = Ext.data.StoreManager.lookup('CBS_AU_H032').getAt(0).get('value');
			panelSearch.setValue('SUPP_TYPE', suppTypeSelect);
			panelResult.setValue('SUPP_TYPE', suppTypeSelect);
			
			//panelSearch.setValue('SUPP_TYPE', '1');
			//panelResult.setValue('SUPP_TYPE', '1');
	
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('PAY_YYYYMM', UniDate.get('today'));
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('PAY_YYYYMM', UniDate.get('today'));

			
			//상여조회 및 조정(hbs220ukr)에서 링크 받기
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
			//버튼 세팅
			UniAppManager.setToolbarButtons('reset'		, false);
			UniAppManager.setToolbarButtons('newData'	, false);			
			UniAppManager.setToolbarButtons('save'		, false);

			//화면 초기화 시 첫번째 필드에 포커스 가도록 설정
			var activeSForm ;	
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {	
				activeSForm = panelResult;
			}	
			activeSForm.onLoadSelectText('PAY_YYYYMM');
		},
		
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			
			masterGrid.reset();
			panelSearch.clearForm();
			panelResult.clearForm();
			masterStore.clearData();

			//상여년월, 정기상여 필드 데이터 변경 할 수 있게 설정
			panelSearch.getField('PAY_YYYYMM').setReadOnly(false);
			panelSearch.getField('SUPP_TYPE').setReadOnly(false);
			panelResult.getField('PAY_YYYYMM').setReadOnly(false);
			panelResult.getField('SUPP_TYPE').setReadOnly(false);

			this.fnInitBinding();
		},
		
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			} else {		

				var viewNormal = masterGrid.getView();
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
	
				masterStore.loadStoreRecords();
				
				//상여년월, 정기상여 필드 데이터 변경 안되도록 설정
				panelSearch.getField('PAY_YYYYMM').setReadOnly(true);
				panelSearch.getField('SUPP_TYPE').setReadOnly(true);
				panelResult.getField('PAY_YYYYMM').setReadOnly(true);
				panelResult.getField('SUPP_TYPE').setReadOnly(true);
				
				//성명, 사번 수정 되지 않도록 설정
				masterGrid.getColumn("NAME").setConfig('editable',false);  
				masterGrid.getColumn("PERSON_NUMB").setConfig('editable',false);  
				
				// 추가, 리셋 버튼 활성화
				UniAppManager.setToolbarButtons('reset'		, true);
				UniAppManager.setToolbarButtons('newData'	, true);
				UniAppManager.setToolbarButtons('deleteAll'	, true);
			}
		},
		
		onNewDataButtonDown : function() {
			var v = Ext.getCmp('PAY_YYYYMM').rawValue;
			var yyyymm = v.replace(".","");
			
			//var yyyymm = UniDate.getDbDateStr(v)
			
			masterGrid.createRow({SUPP_TYPE : Ext.getCmp('SUPP_TYPE').getValue(), PAY_YYYYMM : v, SUPP_RATE: 0 });						
			
			//성명, 사번 수정 되도록 설정
			masterGrid.getColumn("NAME").setConfig('editable',true);  
			masterGrid.getColumn("PERSON_NUMB").setConfig('editable',true);  
		},
		
		onDeleteDataButtonDown : function() {
			var selRow = masterGrid.getSelectedRecord();						
			console.log("selRow",selRow);
			if (selRow.phantom == true) {
				masterGrid.deleteSelectedRow();
			} else if (confirm('선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
				UniAppManager.setToolbarButtons('save'	, true);
			}
		},
		
		onDeleteAllButtonDown : function(){
			Ext.Msg.confirm('삭제', '전체행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					masterStore.removeAll();
					masterGrid.getStore().sync({						
							success: function(response) {
 								masterGrid.getView().refresh();
							},
							failure: function(response) {
 								masterGrid.getView().refresh();
							}
					});
				}
				UniAppManager.app.onQueryButtonDown();
			});
		},
		
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore();
		},
		//링크로 넘어오는 params 받는 부분 
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'hbo220ukr') {
				panelSearch.setValue('PAY_YYYYMM',params.PAY_YYYYMM);
				panelSearch.setValue('SUPP_TYPE',params.SUPP_TYPE);
				
				panelResult.setValue('PAY_YYYYMM',params.PAY_YYYYMM);
				panelResult.setValue('SUPP_TYPE',params.SUPP_TYPE);
			}	
		}
	});
	
	function openExcelWindow() {
		var me = this;
		var vParam = {};

		var appName = 'Unilite.com.excel.ExcelUpload';
		
		var record = masterGrid.getSelectedRecord();
		
		if(!masterStore.isDirty())  {								   //화면에 저장할 내용이 있을 경우 저장여부 확인
			//masterStore.loadData({});
		} else {
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
				masterStore.loadData({});
			}
		}
		
		if(!excelWindow) { 
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				modal: false,
				excelConfigName: 'hbo300ukr',
				extParam: { 
					'PGM_ID'	: 'hbo300ukr'
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '상여자료 업로드',								
						useCheckbox	: false,
						model		: 'excel.hbo300ukr.sheet01',
						readApi		: 'hbo300ukrService.selectExcelUploadSheet',
						columns		: [	
							{dataIndex: '_EXCEL_JOBID'		, width: 80,	hidden: true},
							{dataIndex: 'COMP_CODE'  		, width: 120,   hidden: true},
							{dataIndex: 'DIV_CODE'			, width: 100},
							{dataIndex: 'PAY_YYYYMM'		, width: 100,	align: 'center'},
							{dataIndex: 'SUPP_TYPE'			, width: 100},
							{dataIndex: 'DEPT_NAME'			, width: 130},
							{dataIndex: 'POST_NAME'			, width: 100},
							{dataIndex: 'NAME'				, width: 100},
							{dataIndex: 'PERSON_NUMB'		, width: 100},
							{dataIndex: 'JOIN_DATE'			, width: 100},
							{dataIndex: 'RETR_DATE'			, width: 100},
							{dataIndex: 'LONG_MONTH'		, width: 80, align: 'right'},
							{dataIndex: 'BONUS_RATE'		, width: 80},
							{dataIndex: 'BONUS_STD_I'		, width: 100},
							{dataIndex: 'SUPP_TOTAL_I'		, width: 100}
						
						]
					}
				],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function()	{
					excelWindow.getEl().mask('로딩중...','loading-indicator');
					var me		= this;
					var grid	= this.down('#grid01');
					var records	= grid.getStore().getAt(0);	
					if (!Ext.isEmpty(records)) {
						var param	= {
							"_EXCEL_JOBID" : records.get('_EXCEL_JOBID')
						};
						excelUploadFlag = "Y"
						
						masterGrid.reset();
						masterStore.clearData();
						
						hbo300ukrService.selectExcelUploadSheet(param, function(provider, response){
							var store	= masterGrid.getStore();
							var records	= response.result;
							
							store.insert(0, records);
							console.log("response",response)
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
						});
						excelUploadFlag = "N"
					} else {
						alert (Msg.fSbMsgH0284);
						this.unmask();  
					}
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};
};
</script>