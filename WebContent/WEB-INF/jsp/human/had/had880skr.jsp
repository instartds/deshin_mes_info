<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had880skr"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H005"/>	<!-- 직위 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	Ext.create('Ext.data.Store',{
		storeId: "retrTypeStore",
		data:[
			{text: '중도퇴사', value: 'Y'},
			{text: '연말정산', value: 'N'}
		]
	});
	/**
	 *Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Had880skrModel', {
		fields: [
			{name: 'DIV_CODE'				,					text: '사업장',				type: 'string'},
			{name: 'DEPT_CODE'				,					text: '부서',					type: 'string'},
			{name: 'POST_CODE'				,					text: '직위',					type: 'string'},
			{name: 'NAME'					,					text: '성명',					type: 'string'},
			{name: 'PERSON_NUMB'			,					text: '사번',					type: 'string'},
			{name: 'JOIN_DATE'				,					text: '입사일',				type: 'uniDate'},
			{name: 'RETR_DATE'				,					text: '퇴사일',				type: 'uniDate'},
			
			{name: 'NOW_PAY_TOTAL_I'		,					text: '급여총액(현)',			type: 'uniPrice'},
			{name: 'NOW_BONUS_TOTAL_I'		,					text: '상여총액(현)',			type: 'uniPrice'},
			{name: 'NOW_ADD_BONUS_I'		,					text: '인정상여(현)',			type: 'uniPrice'},
			{name: 'NOW_STOCK_PROFIT_I'		,					text: '주식매수선택행사이익(현)',		type: 'uniPrice'},
			{name: 'NOW_OWNER_STOCK_DRAW_I'	,					text: '우리사주조합인출금(현)',		type: 'uniPrice'},
			{name: 'NOW_OF_RETR_OVER_I'		,					text: '임원퇴직한도초과액(현)',		type: 'uniPrice'},
			{name: 'NOW_TAX_INVENTION_I'	,					text: '직무발명보상금과세분(현)',		type: 'uniPrice'},
			{name: 'PREV_PAY_TOTAL_I'		,					text: '급여총액(전)',			type: 'uniPrice'},
			{name: 'PREV_BONUS_TOTAL_I'		,					text: '상여총액(전)',			type: 'uniPrice'},
			{name: 'PREV_ADD_BONUS_I'		,					text: '인정상여(전)',			type: 'uniPrice'},
			{name: 'OLD_PAY_TOTAL_I'		,					text: '급여총액(전)',			type: 'uniPrice'},
			{name: 'OLD_BONUS_TOTAL_I'		,					text: '상여총액(전)',			type: 'uniPrice'},
			{name: 'OLD_ADD_BONUS_I'		,					text: '인정상여(전)',			type: 'uniPrice'},
			{name: 'OLD_STOCK_PROFIT_I'		,					text: '주식매수선택행사이익(전)',		type: 'uniPrice'},
			{name: 'OLD_OWNER_STOCK_DRAW_I'	,					text: '우리사주조합인출금(전)',		type: 'uniPrice'},
			{name: 'OLD_OF_RETR_OVER_I'		,					text: '임원퇴직한도초과액(전)',		type: 'uniPrice'},
			{name: 'OLD_TAX_INVENTION_I'	,					text: '직무발명보상금과세분(전)',		type: 'uniPrice'},
			
			//	2019년까지 사용한 컬럼
			{name: 'TAX_EXEMPTION'			,					text: '비과세(현)',				type: 'uniPrice'},
			{name: 'P_TAX_EXEMPTION'		,					text: '비과세(전)',				type: 'uniPrice'},
			{name: 'YOUTH_DED_I_SUM'		,					text: '감면소득(현)',			type: 'uniPrice'},
			{name: 'PREV_YOUTH_DED_I_SUM'	,					text: '감면소득(전)',			type: 'uniPrice'},
			
			//	2020년부터 사용하는 컬럼
			{name: 'NOW_TAX_EXEMPTION'			,				text: '비과세(현)',				type: 'uniPrice'},
			{name: 'NOW_YOUTH_DED_I_SUM'		,				text: '감면소득(현)',			type: 'uniPrice'},
			{name: 'OLD_TAX_EXEMPTION'		,					text: '비과세(전)',				type: 'uniPrice'},
			{name: 'OLD_YOUTH_DED_I_SUM'	,					text: '감면소득(전)',			type: 'uniPrice'},
			
			{name: 'DEF_IN_TAX_I'			,					text: '소득세',				type: 'uniPrice'},
			{name: 'DEF_LOCAL_TAX_I'		,					text: '주민세',				type: 'uniPrice'},
			{name: 'NOW_IN_TAX_I'			,					text: '소득세',				type: 'uniPrice'},
			{name: 'NOW_LOCAL_TAX_I'		,					text: '주민세',				type: 'uniPrice'},
			{name: 'PREV_IN_TAX_I'			,					text: '소득세',				type: 'uniPrice'},
			{name: 'PREV_LOCAL_TAX_I'		,					text: '주민세',				type: 'uniPrice'},
			{name: 'IN_TAX_I'				,					text: '소득세',				type: 'uniPrice'},
			{name: 'LOCAL_TAX_I'			,					text: '주민세',				type: 'uniPrice'},
			
			{name: 'ACTUAL_TAX_RATE'		,					text: '실효세율',				type: 'float'	, decimalPrecision: 1},
			
			{name: 'INCOME_SUPP_TOTAL_I'	,					text: '총급여액',				type: 'uniPrice'},
			{name: 'INCOME_DED_I'			,					text: '근로소득공제',				type: 'uniPrice'},
			{name: 'EARN_INCOME_I'			,					text: '근로소득금액',				type: 'uniPrice'},
			
			{name: 'PER_DED_I'				,					text: '본인',					type: 'uniPrice'},
			{name: 'SPOUSE_DED_I'			,					text: '배우자',				type: 'uniPrice'},
			{name: 'SUPP_SUB_I'				,					text: '부양자',				type: 'uniPrice'},
			
			{name: 'AGED_DED_I'				,					text: '경로',					type: 'uniPrice'},
			{name: 'DEFORM_DED_I'			,					text: '장애인',				type: 'uniPrice'},
			{name: 'WOMAN_DED_I'			,					text: '부녀자',				type: 'uniPrice'},
			{name: 'ONE_PARENT_DED_I'		,					text: '한부모공제',				type: 'uniPrice'},
			
			{name: 'ANU_DED_I'				,					text: '국민연금',				type: 'uniPrice'},
			{name: 'PUBLIC_PENS_I'			,					text: '공무원연금',				type: 'uniPrice'},
			{name: 'SOLDIER_PENS_I'			,					text: '군인연금',				type: 'uniPrice'},
			{name: 'SCH_PENS_I'				,					text: '사립학교교직원',			type: 'uniPrice'},
			{name: 'POST_PENS_I'			,					text: '별정우체국연금',			type: 'uniPrice'},
			
			{name: 'MED_PREMINM_I'			,					text: '건강보험료',				type: 'uniPrice'},
			{name: 'HIRE_INSUR_I'			,					text: '고용보험료',				type: 'uniPrice'},
			
			{name: 'HOUS_AMOUNT_I'			,					text: '원리금(대출기관)',			type: 'uniPrice'},
			{name: 'HOUS_AMOUNT_I_2'		,					text: '원리금(거주자)',			type: 'uniPrice'},
			{name: 'MORTGAGE_RETURN_I_2'	,					text: '이자(15년미만)',			type: 'uniPrice'},
			{name: 'MORTGAGE_RETURN_I'		,					text: '이자(15년~29년)',		type: 'uniPrice'},
			{name: 'MORTGAGE_RETURN_I_3'	,					text: '이자(30년이상)',			type: 'uniPrice'},
			{name: 'MORTGAGE_RETURN_I_5'	,					text: '고정금리비거치',			type: 'uniPrice'},
			{name: 'MORTGAGE_RETURN_I_4'	,					text: '기타대출',				type: 'uniPrice'},
			{name: 'MORTGAGE_RETURN_I_6'	,					text: '15년고정·비거치',			type: 'uniPrice'},
			{name: 'MORTGAGE_RETURN_I_7'	,					text: '15년고정OR비거치',			type: 'uniPrice'},
			{name: 'MORTGAGE_RETURN_I_8'	,					text: '15년(그밖의대출)',			type: 'uniPrice'},
			{name: 'MORTGAGE_RETURN_I_9'	,					text: '10년고정OR비거치',			type: 'uniPrice'},
			
			{name: 'GIFT_DED_I'				,					text: '기부금',				type: 'uniPrice'},
			
			{name: 'SP_INCOME_DED_I'		,					text: '특별소득공제 계',			type: 'uniPrice'},
			
			{name: 'PRIV_PENS_I'			,					text: '개인연금저축',				type: 'uniPrice'},
			{name: 'HOUS_BU_AMT'			,					text: '청약저축',				type: 'uniPrice'},
			{name: 'HOUS_WORK_AMT'			,					text: '근로자주택마련',			type: 'uniPrice'},
			{name: 'HOUS_BU_AMOUNT_I'		,					text: '주택청약종합저축',			type: 'uniPrice'},
			{name: 'CARD_DED_I'				,					text: '신용카드',				type: 'uniPrice'},
			{name: 'COMP_PREMINUM_DED_I'	,					text: '소기업·소상공인',			type: 'uniPrice'},
			{name: 'INVESTMENT_DED_I'		,					text: '투자조합출자',				type: 'uniPrice'},
			{name: 'STAFF_STOCK_DED_I'		,					text: '우리사주조합출연',			type: 'uniPrice'},
			{name: 'STAFF_GIFT_DED_I'		,					text: '우리사주기부금',			type: 'uniPrice'},
			{name: 'EMPLOY_WORKER_DED_I'	,					text: '고용유지근로자',			type: 'uniPrice'},
			{name: 'NOT_AMOUNT_LOAN_DED_I'	,					text: '목돈안드는전세',			type: 'uniPrice'},
			{name: 'LONG_INVEST_STOCK_DED_I',					text: '장기집합투자증권',			type: 'uniPrice'},
			
			{name: 'ETC_INCOME_DED_I'		,					text: '그밖의소득공제 계',			type: 'uniPrice'},
			
			{name: 'OVER_INCOME_DED_LMT'	,					text: '소득공제한도초과',			type: 'uniPrice'},
			{name: 'TAX_STD_I'				,					text: '소득과세표준',				type: 'uniPrice'},
			{name: 'COMP_TAX_I'				,					text: '산출세액',				type: 'uniPrice'},
			
			{name: 'INCOME_REDU_I'			,					text: '소득세법',				type: 'uniPrice'},
			{name: 'YOUTH_EXEMP_RATE'		,					text: '중소기업감면율',			type: 'uniPrice'},
			{name: 'YOUTH_DED_I'			,					text: '중소기업(100%)',			type: 'uniPrice'},
			{name: 'YOUTH_DED_I2'			,					text: '중소기업(50%)',			type: 'uniPrice'},
			{name: 'YOUTH_DED_I3'			,					text: '중소기업(70%)',			type: 'uniPrice'},
			{name: 'YOUTH_DED_I4'			,					text: '중소기업(90%)',			type: 'uniPrice'},
			{name: 'SKILL_DED_RATE'			,					text: '외국인기술자감면율',			type: 'uniPrice'},
			{name: 'SKILL_DED_I'			,					text: '외국인기술자',				type: 'uniPrice'},
			{name: 'MANAGE_RESULT_REDU_RATE',					text: '성과공유중소기업경영성과급감면율',	type: 'uniPrice'},
			{name: 'MANAGE_RESULT_REDU_I'	,					text: '성과공유중소기업경영성과급감면',	type: 'uniPrice'},
			{name: 'CORE_COMPEN_FUND_REDU_RATE',				text: '중소기업핵심인력성과보상기금감면율',type: 'uniPrice'},
			{name: 'CORE_COMPEN_FUND_REDU_I',					text: '중소기업핵심인력성과보상기금감면',	type: 'uniPrice'},
			{name: 'RETURN_WORKER_REDU_RATE',					text: '내국인우수인력국내복귀소득세감면율',type: 'uniPrice'},
			{name: 'RETURN_WORKER_REDU_I'	,					text: '내국인우수인력국내복귀소득세감면',	type: 'uniPrice'},
			{name: 'TAXES_REDU_I'			,					text: '조세조약',				type: 'uniPrice'},
			
			{name: 'COMP_TAX_REDU_I'		,					text: '세액감면 계',				type: 'uniPrice'},
			
			{name: 'IN_TAX_DED_I'			,					text: '근로소득세액공제',			type: 'uniPrice'},
			{name: 'CHILD_TAX_DED_I'		,					text: '자녀세액공제',				type: 'uniPrice'},
			
			{name: 'SCI_TAX_DED_I'			,					text: '과학기술인',				type: 'uniPrice'},
			{name: 'RETIRE_TAX_DED_I'		,					text: '근로자퇴직급여',			type: 'uniPrice'},
			{name: 'PENS_TAX_DED_I'			,					text: '연금저축',				type: 'uniPrice'},
			
			{name: 'ETC_INSUR_TAX_DED_I'	,					text: '보장성보험',				type: 'uniPrice'},
			{name: 'DEFORM_INSUR_TAX_DED_I'	,					text: '장애인전용보험',			type: 'uniPrice'},
			{name: 'MED_TAX_DED_I'			,					text: '의료비',				type: 'uniPrice'},
			{name: 'EDUC_TAX_DED_I'			,					text: '교육비',				type: 'uniPrice'},
			{name: 'GIFT_TAX_DED_I'			,					text: '기부금',				type: 'uniPrice'},
			{name: 'POLICY_INDED_TAX_DED_I'	,					text: '정치자금기부금(10만원미만)',	type: 'uniPrice'},
			{name: 'POLICY_GIFT_TAX_DED_I'	,					text: '정치자금기부금(10만원초과)',	type: 'uniPrice'},
			{name: 'LEGAL_GIFT_TAX_DED_I'	,					text: '법정기부금',				type: 'uniPrice'},
			{name: 'STAFF_GIFT_TAX_DED_I'	,					text: '우리사주기부금',			type: 'uniPrice'},
			{name: 'APPOINT_GIFT_TAX_DED_I'	,					text: '지정기부금',				type: 'uniPrice'},
			{name: 'ASS_GIFT_TAX_DED_I'		,					text: '종교단체기부금',			type: 'uniPrice'},
			{name: 'SP_TAX_DED_I'			,					text: '특별세액공제 계',			type: 'uniPrice'},
			{name: 'STD_TAX_DED_I'			,					text: '표준세액공제',				type: 'uniPrice'},
			
			{name: 'NAP_TAX_DED_I'			,					text: '납세조합세액공제',			type: 'uniPrice'},
			{name: 'HOUS_INTER_I'			,					text: '주택자금상환액',			type: 'uniPrice'},
			{name: 'OUTSIDE_INCOME_I'		,					text: '외국납부세액',				type: 'uniPrice'},
			{name: 'MON_RENT_I'				,					text: '월세액',				type: 'uniPrice'},
			
			{name: 'TAX_DED_SUM_I'			,					text: '세액공제 계',				type: 'uniPrice'}
		]
	});		// end of Unilite.defineModel('Had880skrModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('had880skrMasterStore1',{
		model: 'Had880skrModel',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
				//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'had880skrService.selectList'					
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
			
		}			
	});		// end of var directMasterStore1 = Unilite.createStore('had880skrMasterStore1',{
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
		
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '검색조건',		
		defaultType: 'uniSearchSubPanel',
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
			id: 'search_panel1',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '정산구분',
				name:'HALFWAY_TYPE',
				allowBlank: false,
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('retrTypeStore'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('HALFWAY_TYPE', newValue);
					}
				}
			},{
				fieldLabel : '정산년도',
				name : 'YEAR_YYYY',
				xtype : 'uniYearField',
				allowBlank: false,
				value:UniHuman.getTaxReturnYear(),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('YEAR_YYYY', newValue);
					}
				}
			},{
				fieldLabel: '신고사업장',
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
					'onValueFieldChange': function(field, newValue, oldValue  ){
							panelResult.setValue('DEPT',newValue);
					},
					'onTextFieldChange':  function( field, newValue, oldValue  ){
							panelResult.setValue('DEPT_NAME',newValue);
					},
					'onValuesChange':  function( field, records){
							var tagfield = panelResult.getField('DEPTS');
							tagfield.setStoreData(records)
					}
				}
			}),
			Unilite.popup('Employee',{
				validateBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);
					}
				}
			}),{
				fieldLabel: '퇴사일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'RETIRE_DATE_FR',
				endFieldName: 'RETIRE_DATE_TO',
				width: 325,
				//startDate: UniDate.get('startOfMonth'),
				//endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('RETIRE_DATE_FR', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('RETIRE_DATE_TO', newValue);
					}
				}
			}]
		}]
	});
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns :	3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '정산구분'	,
			name:'HALFWAY_TYPE',
			xtype: 'uniCombobox',
			allowBlank: false,
			store: Ext.data.StoreManager.lookup('retrTypeStore'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('HALFWAY_TYPE', newValue);
				}
			}
		},{
			fieldLabel : '정산년도',
			name : 'YEAR_YYYY',
			xtype : 'uniYearField',
			allowBlank: false,
			value:UniHuman.getTaxReturnYear(),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('YEAR_YYYY', newValue);
				}
			}
		},{
			fieldLabel: '신고사업장',
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType: 'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true,
			listeners: {
				'onValueFieldChange': function(field, newValue, oldValue  ){
						panelSearch.setValue('DEPT',newValue);
				},
				'onTextFieldChange':  function( field, newValue, oldValue  ){
						panelSearch.setValue('DEPT_NAME',newValue);
				},
				'onValuesChange':  function( field, records){
						var tagfield = panelSearch.getField('DEPTS');
						tagfield.setStoreData(records)
				}
			}
		}),
		Unilite.popup('Employee',{
			validateBlank: false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
					panelResult.setValue('PERSON_NUMB', '');
					panelResult.setValue('NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);
				}
			}
		}),{ 
			fieldLabel: '퇴사일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'RETIRE_DATE_FR',
			endFieldName: 'RETIRE_DATE_TO',
			width: 325,
			//startDate: UniDate.get('startOfMonth'),
			//endDate: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('RETIRE_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('RETIRE_DATE_TO', newValue);
				}
			}
		}]
	});
	
	
	<%@include file="./had880skr_2018.jsp" %>
	<%@include file="./had880skr_2019.jsp" %>
	<%@include file="./had880skr_2020.jsp" %>
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	
	var grid2017 = Unilite.createGrid('had880skrGrid2017', {
		// for tab		
		title: '2017년기준',
		layout : 'fit',
		region:'center',
		uniOpt:{	
			expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			},
			state: {					//그리드 설정 사용 여부
				useState: false,
				useStateList: false
			}
		},
		features: [{id : 'grid2017SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
				{id : 'grid2017Total', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		store: directMasterStore1,
		columns: [
			{ dataIndex: 'DIV_CODE'					,				width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{ dataIndex: 'DEPT_CODE'				,				width: 120 },
			{ dataIndex: 'POST_CODE'				,				width: 70 },
			{ dataIndex: 'NAME'						,				width: 70 },
			{ dataIndex: 'PERSON_NUMB'				,				width: 80 },
			{ dataIndex: 'JOIN_DATE'				,				width: 90, hidden: true },
			{ dataIndex: 'RETR_DATE'				,				width: 90, hidden: true },
			{ dataIndex: 'NOW_PAY_TOTAL_I'			,				width: 120, summaryType: 'sum' },
			{ dataIndex: 'NOW_BONUS_TOTAL_I'		,				width: 120, summaryType: 'sum' },
			{ dataIndex: 'NOW_ADD_BONUS_I'			,				width: 120, summaryType: 'sum' },
			{ dataIndex: 'PREV_PAY_TOTAL_I'			,				width: 120, summaryType: 'sum' },
			{ dataIndex: 'PREV_BONUS_TOTAL_I'		,				width: 120, summaryType: 'sum' },
			{ dataIndex: 'TAX_EXEMPTION'			,				width: 120, summaryType: 'sum' },
			{ text: '결정세액',
				columns: [
					{ dataIndex: 'DEF_IN_TAX_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'DEF_LOCAL_TAX_I'			,				width: 120, summaryType: 'sum' }
				]
			},
			{ text: '기납부세액(주,현)',
				columns: [
					{ dataIndex: 'NOW_IN_TAX_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'NOW_LOCAL_TAX_I'			,				width: 120, summaryType: 'sum' }
				]
			},
			{ text: '기납부세액(종,전)',
				columns: [
					{ dataIndex: 'PREV_IN_TAX_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'PREV_LOCAL_TAX_I'			,				width: 120, summaryType: 'sum' }
				]
			},
			{ text: '차감징수(환급)세액',
				columns: [
					{ dataIndex: 'IN_TAX_I'					,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'LOCAL_TAX_I'				,				width: 120, summaryType: 'sum' }
				]
			},
			{ dataIndex: 'INCOME_SUPP_TOTAL_I'		,				width: 120, summaryType: 'sum' },
			{ dataIndex: 'INCOME_DED_I'				,				width: 120, summaryType: 'sum' },
			{ dataIndex: 'EARN_INCOME_I'			,				width: 120, summaryType: 'sum' },
			{ text: '기본공제',
				columns: [
					{ dataIndex: 'PER_DED_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'SPOUSE_DED_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'SUPP_SUB_I'				,				width: 120, summaryType: 'sum' }
				]
			},
			{ text: '추가공제',
				columns: [
					{ dataIndex: 'AGED_DED_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'DEFORM_DED_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'WOMAN_DED_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'ONE_PARENT_DED_I'			,				width: 120, summaryType: 'sum' }
				]
			},
			{ text: '연금보험료공제',
				columns: [
					{ dataIndex: 'ANU_DED_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'PUBLIC_PENS_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'SOLDIER_PENS_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'SCH_PENS_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'POST_PENS_I'				,				width: 120, summaryType: 'sum' }
				]
			},
			{ text: '특별소득공제',
				columns: [
					{ dataIndex: 'MED_PREMINM_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'HIRE_INSUR_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'HOUS_AMOUNT_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'HOUS_AMOUNT_I_2'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'MORTGAGE_RETURN_I_2'		,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'MORTGAGE_RETURN_I'		,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'MORTGAGE_RETURN_I_3'		,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'MORTGAGE_RETURN_I_5'		,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'MORTGAGE_RETURN_I_4'		,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'MORTGAGE_RETURN_I_6'		,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'MORTGAGE_RETURN_I_7'		,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'MORTGAGE_RETURN_I_8'		,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'MORTGAGE_RETURN_I_9'		,				width: 135, summaryType: 'sum' },
					{ dataIndex: 'GIFT_DED_I'				,				width: 120, summaryType: 'sum' }
				]
			},
			{ text: '그밖의소득공제',
				columns: [
					{ dataIndex: 'PRIV_PENS_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'HOUS_BU_AMT'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'HOUS_WORK_AMT'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'HOUS_BU_AMOUNT_I'			,				width: 125, summaryType: 'sum' },
					{ dataIndex: 'CARD_DED_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'COMP_PREMINUM_DED_I'		,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'INVESTMENT_DED_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'STAFF_STOCK_DED_I'		,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'STAFF_GIFT_DED_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'EMPLOY_WORKER_DED_I'		,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'NOT_AMOUNT_LOAN_DED_I'	,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'LONG_INVEST_STOCK_DED_I'	,				width: 120, summaryType: 'sum' }
				]
			},
			{ dataIndex: 'OVER_INCOME_DED_LMT'		,				width: 120, summaryType: 'sum' },
			{ dataIndex: 'TAX_STD_I'				,				width: 120, summaryType: 'sum' },
			{ dataIndex: 'COMP_TAX_I'				,				width: 120, summaryType: 'sum' },
			{ text: '세액감면',
				columns: [
					{ dataIndex: 'INCOME_REDU_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'YOUTH_DED_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'YOUTH_DED_I3'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'YOUTH_DED_I2'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'SKILL_DED_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'TAXES_REDU_I'				,				width: 120, summaryType: 'sum' }
				]
			},
			{ text: '세액공제',
				columns: [
					{ dataIndex: 'IN_TAX_DED_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'CHILD_TAX_DED_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'SCI_TAX_DED_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'RETIRE_TAX_DED_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'PENS_TAX_DED_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'ETC_INSUR_TAX_DED_I'		,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'DEFORM_INSUR_TAX_DED_I'	,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'MED_TAX_DED_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'EDUC_TAX_DED_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'GIFT_TAX_DED_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'STD_TAX_DED_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'NAP_TAX_DED_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'HOUS_INTER_I'				,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'OUTSIDE_INCOME_I'			,				width: 120, summaryType: 'sum' },
					{ dataIndex: 'MON_RENT_I'				,				width: 120, summaryType: 'sum' }
				]
			}
		]
	});
	
	
	var tab = Ext.create('Ext.tab.Panel',{
			region:'center',
//			activeTab: 0,
//			tabPosition : 'bottom',
//			dockedItems : [tbar],
			//layout:  {	type: 'vbox',  align: 'stretch' },
//			layout:  'border',
//			flex : 1,
			items: [
				grid2020,
				grid2019,
				grid2018,
				grid2017
			],
			listeners:{
				tabchange: function ( tabPanel, newCard, oldCard, eOpts ) {
					
				}
			}
		});
	
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
			panelSearch
		],
		id  : 'had880skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('HALFWAY_TYPE', 'N');
			panelResult.setValue('HALFWAY_TYPE', 'N');
			UniAppManager.setToolbarButtons('reset',false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('HALFWAY_TYPE');
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			if(tab.getActiveTab().getId() == 'had880skrGrid2017')	{
				grid2017.getStore().loadStoreRecords();
				var viewLocked = grid2017.getView();
				var viewNormal = grid2017.getView();
				viewLocked.getFeature('grid2017SubTotal').toggleSummaryRow(true);
				viewLocked.getFeature('grid2017Total').toggleSummaryRow(true);
				viewNormal.getFeature('grid2017SubTotal').toggleSummaryRow(true);
				viewNormal.getFeature('grid2017Total').toggleSummaryRow(true);
			}else if(tab.getActiveTab().getId() == 'had880skrGrid2018') {
				grid2018.getStore().loadStoreRecords();
				var viewLocked = grid2018.getView();
				var viewNormal = grid2018.getView();
				viewLocked.getFeature('grid2018SubTotal').toggleSummaryRow(true);
				viewLocked.getFeature('grid2018Total').toggleSummaryRow(true);
				viewNormal.getFeature('grid2018SubTotal').toggleSummaryRow(true);
				viewNormal.getFeature('grid2018Total').toggleSummaryRow(true);
			}else if(tab.getActiveTab().getId() == 'had880skrGrid2019') {
				grid2019.getStore().loadStoreRecords();
				var viewLocked = grid2019.getView();
				var viewNormal = grid2019.getView();
				viewLocked.getFeature('grid2019SubTotal').toggleSummaryRow(true);
				viewLocked.getFeature('grid2019Total').toggleSummaryRow(true);
				viewNormal.getFeature('grid2019SubTotal').toggleSummaryRow(true);
				viewNormal.getFeature('grid2019Total').toggleSummaryRow(true);
			}else if(tab.getActiveTab().getId() == 'had880skrGrid2020') {
				grid2020.getStore().loadStoreRecords();
				var viewLocked = grid2020.getView();
				var viewNormal = grid2020.getView();
				viewLocked.getFeature('grid2020SubTotal').toggleSummaryRow(true);
				viewLocked.getFeature('grid2020Total').toggleSummaryRow(true);
				viewNormal.getFeature('grid2020SubTotal').toggleSummaryRow(true);
				viewNormal.getFeature('grid2020Total').toggleSummaryRow(true);
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};

</script>
