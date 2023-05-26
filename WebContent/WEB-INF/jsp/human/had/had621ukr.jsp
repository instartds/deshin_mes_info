<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had620ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H053" /> <!--정산구분-->
	<t:ExtComboStore comboType="AU" comboCode="H168" /> <!--퇴직사유-->
	<t:ExtComboStore comboType="AU" comboCode="H039" /> <!--소득내역-->
	<t:ExtComboStore comboType="AU" comboCode="H119" /> <!--기부금코드-->
	<t:ExtComboStore comboType="AU" comboCode="H179" /> <!--중소기업취업감면-->
	<t:ExtComboStore comboType="AU" comboCode="H117"  />
	<t:ExtComboStore comboType="AU" comboCode="H206" /> <!--출산입양 자녀코드-->

	<t:ExtComboStore items="${relCode}" storeId="relCodeStore" />

	<t:ExtComboStore comboType="AU" comboCode="H118" />
	<t:ExtComboStore comboType="AU" comboCode="H120" />
	<t:ExtComboStore comboType="AU" comboCode="H141" />
	<t:ExtComboStore comboType="AU" comboCode="H142" />
	<t:ExtComboStore comboType="AU" comboCode="H169" />
	<t:ExtComboStore comboType="AU" comboCode="H150" />
	<t:ExtComboStore comboType="AU" comboCode="H151" />
	<t:ExtComboStore comboType="AU" comboCode="H152" />
	<t:ExtComboStore comboType="AU" comboCode="H153" />	<!-- 마감구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H139" />
	<t:ExtComboStore comboType="AU" comboCode="H115" />
	<t:ExtComboStore comboType="AU" comboCode="H116" />
	<t:ExtComboStore comboType="AU" comboCode="H121" />
	<t:ExtComboStore comboType="AU" comboCode="H140" />
	<t:ExtComboStore comboType="AU" comboCode="H180" />
	<t:ExtComboStore comboType="AU" comboCode="H233" />	<!-- 투자년도 -->
	<t:ExtComboStore comboType="AU" comboCode="H229" />	<!-- 투자구분 -->  
</t:appConfig>
<style type="text/css">
.x-grid-item-focused  .x-grid-cell-inner:before {
	/*border: 0px;*/
}

.cash_disabled {
	background-color:#dddddd;
}
</style>
<script type="text/javascript" >
var yearIncomeWin;
var prevCompanyWin;
var taxCommunityWin;
var familyWin;
var personalPensionWin;
var medDocWin;
var pdfWin;
var rentWin;
var donationWin;
var houseLoanWin;
var nationCode = "";	//	외국인 단일세율적용코드
var gbCloseYn = true;	//	개인별 연말정산 마감 여부

function appMain() {

	var YEAR_YYYY = '${YEAR_YYYY}';
	var USE_AUTH = '${USE_AUTH}';
	var AUTH_YN = '${AUTH_YN}';
	var PERSON_NUMB = '${PERSON_NUMB}';
	var PERSON_NAME = '${PERSON_NAME}';
	
	var gbCloseYn = false;
	
	Ext.create('Ext.data.Store',{
		storeId	: 'CBS_HALFWAY_TYPE',
		fields	: [
			'value', 'text', 'option', 'search'
		],
		data	: [
			{value: 'Y'	, text: '중도정산'	, option: ''	, search: 'Y중도정산'},
			{value: 'N'	, text: '연말정산'	, option: ''	, search: 'N연말정산'}
		]
	});
	
	Ext.create('Ext.data.Store',{
		storeId	: 'CBS_ADJUST_YN',
		fields	: [
			'value', 'text', 'option', 'search'
		],
		data	: [
			{value: 'Y'	, text: '정산'	, option: ''	, search: 'Y정산'},
			{value: 'N'	, text: '미정산'	, option: ''	, search: 'N미정산'}
		]
	});
	
	Unilite.defineModel('had620ukrEmpModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '법인코드'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장코드'			, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string'},
			{name: 'NAME'				, text: '성명'			, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서명'			, type: 'string'},
			{name: 'JOIN_DATE'			, text: '입사일'			, type: 'string'},
			{name: 'RETR_DATE'			, text: '퇴사일'			, type: 'string'},
			{name: 'YOUTH_EXEMP_DATE'	, text: '청년세액감면기간'		, type: 'string'},
			{name: 'YOUTH_EXEMP_RATE'	, text: '청년세액감면율'		, type: 'string'},
			{name: 'HALFWAY_TYPE'		, text: '구분'			, type: 'string',	store: Ext.data.StoreManager.lookup('CBS_HALFWAY_TYPE')},
			{name: 'ADJUST_YN'			, text: '정산'			, type: 'string',	store: Ext.data.StoreManager.lookup('CBS_ADJUST_YN')},
			{name: 'CLOSE_YN'			, text: '마감'			, type: 'string',	comboType: 'AU'	, comboCode: 'H153'}
		]
	});

	var directEmpStore = Unilite.createStore('had620ukrEmpStore', {
		model: 'had620ukrEmpModel',
		uniOpt: {
			isMaster : false,		// 상위 버튼 연결
			editable : false,		// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi  : false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'uniDirect',
			api: {
				read : 'had620ukrService.selectEmpList'
			}
		},
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load: function(store) {
				if (store.getCount() > 0) {
					if (store.getCount() > 1) {
						UniAppManager.setToolbarButtons(['prev', 'next'], true);
					}
					else {
						UniAppManager.setToolbarButtons(['prev', 'next'], false);
					}
				}
				else {
					UniAppManager.setToolbarButtons(['prev', 'next'], false);
					Ext.getCmp('resultForm').getComponent('btnBar').getComponent('btnClose').setText('마감');
					UniAppManager.app.fnBtnEnable(false);
				}
			}
		}
	});

	var empGrid = Unilite.createGrid('had620ukrEmpGrid', {
		layout	: 'fit',
		region	: 'center',
		flex	: 1,
		border	: 1,
		margin	: 0,
		store	: directEmpStore,
		selModel:'rowmodel',
		uniOpt: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			useMultipleSorting	: false,
			userToolbar			: false,
			state: {
				useState	: false,
				useStateList: false
			}
		},
		columns: [
			{dataIndex: 'COMP_CODE'				, width: 100	, hidden: true	},
			{dataIndex: 'DIV_CODE'				, width: 100	, hidden: true	},
			{dataIndex: 'PERSON_NUMB'			, width:  90	, align: 'center'},
			{dataIndex: 'NAME'					, width:  70	},
			{dataIndex: 'DEPT_CODE'				, width: 100	, hidden: true	},
			{dataIndex: 'DEPT_NAME'				, width: 100	, hidden: true	},
			{dataIndex: 'JOIN_DATE'				, width: 100	, hidden: true	},
			{dataIndex: 'RETR_DATE'				, width: 100	, hidden: true	},
			{dataIndex: 'YOUTH_EXEMP_DATE'		, width: 100	, hidden: true	},
			{dataIndex: 'YOUTH_EXEMP_RATE'		, width: 100	, hidden: true	},
			{dataIndex: 'HALFWAY_TYPE'			, width:  80	},
			{dataIndex: 'ADJUST_YN'				, width:  60	},
			{dataIndex: 'CLOSE_YN'				, width:  60	}
		],
		listeners: {
			selectionchangerecord : function( record ) {
				nationCode = "" ;
				if(!Ext.isEmpty(record)) {
					var empNo = record.get('PERSON_NUMB');
					var empNm = record.get('NAME');
					
					panelResult.setValue('PERSON_NUMB'	, empNo);
					panelResult.setValue('NAME'			, empNm);
					
					direct600Store.loadStoreRecords(empNo);
					direct400Store.loadStoreRecords(empNo);
					
					var closeYn = record.get('CLOSE_YN');
					if(closeYn == 'Y') {
						Ext.getCmp('resultForm').getComponent('btnBar').getComponent('btnClose').setText('마감취소');
					}
					else {
						Ext.getCmp('resultForm').getComponent('btnBar').getComponent('btnClose').setText('마감');
					}
					
					gbCloseYn = (closeYn == 'N' ? false : true);
					empGrid.fnCheckClose();
				}
			},
			deselect:function()	{
				UniAppManager.app.fnBtnEnable(false);
			},
			select:function(grid,selected){
				if(!Ext.isEmpty(selected) )	{
					UniAppManager.app.fnBtnEnable(true);
				} else {
					UniAppManager.app.fnBtnEnable(false);
				}
			}
		},
		fnSetClose : function() {
			var mRow  = empGrid.getSelectedRecord();
			var closeYn = (mRow.get('CLOSE_YN') == 'N' ? 'Y' : 'N');
			var param = {
				COMP_CODE	: mRow.get('COMP_CODE'),
				DIV_CODE	: mRow.get('DIV_CODE'),
				PERSON_NUMB	: mRow.get('PERSON_NUMB'),
				YEAR_YYYY	: panelSearch.getValue('YEAR_YYYY'),
				CLOSE_YN	: closeYn
			};
			
			if(direct400Store.isDirty() || direct600Store.isDirty()) {
				if(confirm('저장되지 않은 데이터가 있습니다. 그대로 진행하시겠습니까?')) {
					direct400Store.rejectChanges();
					direct600Store.rejectChanges();
				}
				else
					return false;
			}
			had620ukrService.checkInstallmentPay(param, function(provider1, response1) {
				if((provider1 && provider1.CNT == 0) || closeYn == "Y" )	{
					had620ukrService.fnSetClose(param, function(provider, response) {
						console.log("provider : ", provider);
						if(provider){
							if(closeYn == 'Y')
								Unilite.messageBox("마감 작업이 완료되었습니다.");
							else
								Unilite.messageBox("마감취소 작업이 완료되었습니다.");
							
							mRow.set('CLOSE_YN', closeYn);
							gbCloseYn = (closeYn == 'Y' ? true : false);
							Ext.getCmp('resultForm').getComponent('btnBar').getComponent('btnClose').setText((closeYn == 'Y' ? '마감취소' : '마감'));
							
							directEmpStore.commitChanges();
							
							empGrid.fnCheckClose(closeYn);
						}
					});
				} else if(provider1 && provider1.CNT > 0 )	{
					Unilite.messageBox('연말정산분납 급여반영 내역이 있습니다.');
				}
			});
		},
		fnCheckClose : function() {
			Ext.getCmp('infoForm400').setCloseForm();
			Ext.getCmp('tab3Form400').setCloseForm();
			Ext.getCmp('tab4Form400').setCloseForm();
			Ext.getCmp('tab5Form400').setCloseForm();
			Ext.getCmp('tab9Form400').setCloseForm();
			Ext.getCmp('tab10Form400').setCloseForm();
			Ext.getCmp('tab17Form400').setCloseForm();
			
			Ext.getCmp('resultForm').setCloseForm();
		}
	});
	
	Unilite.defineModel('had620ukr600Model', {
		fields: [
			  {name:'PERSON_NUMB'				, text:'사번'  								, type:'string'}
			, {name:'JOIN_DATE'					, text:'입사일'								, type:'uniDate'}
			, {name:'RETR_DATE'					, text:'퇴사일'								, type:'uniDate'}
			, {name:'DEPT_CODE'					, text:'부서코드'								, type:'string'}
			, {name:'DEPT_NAME'					, text:'부서명'								, type:'string'}
			, {name:'YEAR_YYYY'					, text:'정산년도'								, type:'string'}
			, {name:'HALFWAY_TYPE'				, text:'중도퇴사자정산여부'							, type:'bool'}
			, {name:'FORE_SINGLE_YN'			, text:'외국인단일세율적용여부'						, type:'bool'}
			, {name:'FOREIGN_DISPATCH_YN'		, text:'외국법인소속 파견근로자 여부'					, type:'bool'}
			, {name:'HOUSEHOLDER_YN'			, text:'세대주여부'								, type:'bool'}
			, {name:'INCOME_SUPP_TOTAL_I'		, text:'총급여액'								, type:'string'}
			, {name:'PAY_TOTAL_I'				, text:'급여총액(숨김)'							, type:'uniNumber'	,defaultValue:0}
			, {name:'BONUS_TOTAL_I'				, text:'상여총액(숨김)'							, type:'uniNumber'	,defaultValue:0}
			, {name:'ADD_BONUS_I'				, text:'인정상여금액(숨김)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'STOCK_PROFIT_I'			, text:'주식매수선택행사이익(숨김)'					, type:'uniNumber'	,defaultValue:0}
			, {name:'OWNER_STOCK_DRAW_I'		, text:'우리사주조합인출금(숨김)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'OF_RETR_OVER_I'			, text:'임원퇴직한도초과액(숨김)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'TAX_INVENTION_I'			, text:'직무발명보상금과세(숨김)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'NOW_PAY_TOT_I'				, text:'주(현)급여총액(숨김)'						, type:'uniNumber'}
			, {name:'NOW_BONUS_TOTAL_I'			, text:'주(현)상여총액(숨김)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'NOW_ADD_BONUS_I'			, text:'주(현)인정상여금액(숨김)'					, type:'uniNumber'	,defaultValue:0}
			, {name:'NOW_STOCK_PROFIT_I'		, text:'주(현)주식매수선택행사이익(숨김)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'NOW_OWNER_STOCK_DRAW_I'	, text:'주(현)우리사주조합인출금(숨김)'					, type:'uniNumber'	,defaultValue:0}
			, {name:'NOW_OF_RETR_OVER_I'		, text:'주(현)임원퇴직한도초과액(숨김)'					, type:'uniNumber'	,defaultValue:0}
			, {name:'NOW_TAX_INVENTION_I'		, text:'주(현)직무발명보상금과세분(숨김)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'OLD_PAY_TOT_I'				, text:'종(전)급여총액(숨김)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'OLD_BONUS_TOTAL_I'			, text:'종(전)상여총액(숨김)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'OLD_ADD_BONUS_I'			, text:'종(전)인정상여금액(숨김)'					, type:'uniNumber'	,defaultValue:0}
			, {name:'OLD_STOCK_PROFIT_I'		, text:'종(전)주식매수선택행사이익(숨김)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'OLD_OWNER_STOCK_DRAW_I'	, text:'종(전)우리사주조합인출금(숨김)'					, type:'uniNumber'	,defaultValue:0}
			, {name:'OLD_OF_RETR_OVER_I'		, text:'종(전)임원퇴직한도초과액(숨김)'					, type:'uniNumber'	,defaultValue:0}
			, {name:'OLD_TAX_INVENTION_I'		, text:'종(전)직무발명보상금과세(숨김)'					, type:'uniNumber'	,defaultValue:0}
			, {name:'NAP_PAY_TOT_I'				, text:'(납)급여총액'							, type:'uniNumber'	,defaultValue:0}
			, {name:'NAP_BONUS_TOTAL_I'			, text:'(납)상여총액'							, type:'uniNumber'	,defaultValue:0}
			, {name:'INCOME_DED_I'				, text:'근로소득공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'EARN_INCOME_I'				, text:'근로소득금액'								, type:'uniNumber'	,defaultValue:0}
			, {name:'PER_DED_I'					, text:'본인공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'SPOUSE'					, text:'배우자유무'								, type:'string'}
			, {name:'SPOUSE_DED_I'				, text:'배우자공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'SUPP_NUM'					, text:'부양자'								, type:'uniNumber'	,defaultValue:0}
			, {name:'SUPP_SUB_I'				, text:'부양자공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'AGED_NUM'					, text:'경로자'								, type:'uniNumber'	,defaultValue:0}
			, {name:'DEFORM_NUM'				, text:'장애자'								, type:'uniNumber'	,defaultValue:0}
			, {name:'MANY_CHILD_NUM'			, text:'자녀'									, type:'uniNumber'	,defaultValue:0}
			, {name:'BRING_CHILD_NUM'			, text:'자녀양육'								, type:'uniNumber'	,defaultValue:0}
			, {name:'BIRTH_ADOPT_NUM'			, text:'출산입양'								, type:'uniNumber'	,defaultValue:0}
			, {name:'WOMAN'						, text:'부녀자유무'								, type:'string'}
			, {name:'ONE_PARENT'				, text:'한부모여부'								, type:'string'}
			, {name:'BIRTH_ADOPT_NUM1'			, text:'출산입양첫째'								, type:'uniNumber'}
			, {name:'BIRTH_ADOPT_NUM2'			, text:'출산입양둘째'								, type:'uniNumber'}
			, {name:'BIRTH_ADOPT_NUM3'			, text:'출산입양셋째'								, type:'uniNumber'}
			, {name:'AGED_DED_I'				, text:'경로공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'DEFORM_DED_I'				, text:'장애인공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'WOMAN_DED_I'				, text:'부녀자공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'ONE_PARENT_DED_I'			, text:'한부모공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'ANU_I'						, text:'국민연금'								, type:'uniNumber'	,defaultValue:0}
			, {name:'ANU_ADD_I'					, text:'국민연금(개별입력)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'ANU_DED_I'					, text:'국민연금공제금액'							, type:'uniNumber'	,defaultValue:0}
			, {name:'PUBLIC_PENS_I'				, text:'공무원연금'								, type:'uniNumber'	,defaultValue:0}
			, {name:'SOLDIER_PENS_I'			, text:'군인연금'								, type:'uniNumber'	,defaultValue:0}
			, {name:'SCH_PENS_I'				, text:'사립학교교직원연금'							, type:'uniNumber'	,defaultValue:0}
			, {name:'POST_PENS_I'				, text:'별정우체국연금'							, type:'uniNumber'	,defaultValue:0}
			, {name:'MED_PREMINM_I'				, text:'건강보험료'								, type:'uniNumber'	,defaultValue:0}
			, {name:'HIRE_INSUR_I'				, text:'고용보험료'								, type:'uniNumber'	,defaultValue:0}
			, {name:'HOUS_AMOUNT_I'				, text:'주택자금불입액(대출기관)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'HOUS_AMOUNT_I_2'			, text:'주택자금불입액(거주자)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'MORTGAGE_RETURN_I_2'		, text:'장기주택저당차입금이자상환액(15년미만)'			, type:'uniNumber'	,defaultValue:0}
			, {name:'MORTGAGE_RETURN_I'			, text:'장기주택저당차입금이자상환액(15년~29년)'			, type:'uniNumber'	,defaultValue:0}
			, {name:'MORTGAGE_RETURN_I_3'		, text:'장기주택저당차입금이자상환액(30년이상)'			, type:'uniNumber'	,defaultValue:0}
			, {name:'MORTGAGE_RETURN_I_5'		, text:'고정금리비거치상환대출(1500만원한도)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'MORTGAGE_RETURN_I_4'		, text:'기타대출(500만원한도)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'MORTGAGE_RETURN_I_6'		, text:'15년이상(고정금리이면서 비거치상환)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'MORTGAGE_RETURN_I_7'		, text:'15년이상(고정금리이거나 비거치상환)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'MORTGAGE_RETURN_I_8'		, text:'15년이상(그밖의대출)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'MORTGAGE_RETURN_I_9'		, text:'10년이상(고정금리이거나 비거치상환)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'PRIV_PENS_I'				, text:'개인연금저축소득공제'						, type:'uniNumber'	,defaultValue:0}
			, {name:'HOUS_BU_AMT'				, text:'청약저축(240만원한도)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'HOUS_BU_ADD_AMT'			, text:'청약저축(120만원한도)'						, type:'uniNumber'	,defaultValue:0}
			, {name:'HOUS_WORK_AMT'				, text:'근로자주택마련저축'							, type:'uniNumber'	,defaultValue:0}
			, {name:'HOUS_BU_AMOUNT_I'			, text:'주택청약종합저축(240만원한도)'					, type:'uniNumber'	,defaultValue:0}
			, {name:'HOUS_BU_AMOUNT_ADD_I'		, text:'주택청약종합저축(120만원한도)'					, type:'uniNumber'	,defaultValue:0}
			, {name:'CARD_DED_I'				, text:'신용카드공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'CARD_USE_I'				, text:'신용카드사용액'							, type:'uniNumber'	,defaultValue:0}
			, {name:'CASH_USE_I'				, text:'현금영수증사용액'							, type:'uniNumber'	,defaultValue:0}
			, {name:'DEBIT_CARD_USE_I'			, text:'직불카드사용액'							, type:'uniNumber'	,defaultValue:0}
			, {name:'TRA_MARKET_USE_I'			, text:'전통시장사용액'							, type:'uniNumber'	,defaultValue:0}
			, {name:'TRAFFIC_USE_I'				, text:'대중교통이용액'							, type:'uniNumber'	,defaultValue:0}
			, {name:'BOOK_CONCERT_USE_I'		, text:'도서공연사용액'							, type:'uniNumber'	,defaultValue:0}
			, {name:'COMP_PREMINUM'				, text:'소기업,소상공인공제부금소득공제 2016년 가입한 대표자 여부' 	, type:'bool'}
			, {name:'COMP_PREMINUM_DED_I'		, text:'소기업,소상공인공제부금소득공제'					, type:'uniNumber'	,defaultValue:0}
			, {name:'INVESTMENT_DED_I'			, text:'투자조합출자공제'							, type:'uniNumber'	,defaultValue:0}
			, {name:'INVESTMENT_DED_I2'			, text:'투자조합출자공제(2013년도분)'					, type:'uniNumber'	,defaultValue:0}
			, {name:'INVESTMENT_DED_I3'			, text:'투자조합출자공제(2014년도분)'					, type:'uniNumber'	,defaultValue:0}
			, {name:'INVESTMENT_DED_I4'			, text:'투자조합출자공제(2015년이후분)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'STAFF_STOCK_DED_I'			, text:'우리사주조합출연금액'						, type:'uniNumber'	,defaultValue:0}
			, {name:'EMPLOY_WORKER_DED_I'		, text:'고용유지중소기업근로자소득공제'					, type:'uniNumber'	,defaultValue:0}
			, {name:'NOT_AMOUNT_LOAN_DED_I'		, text:'목돈안드는전세이자상환액'						, type:'uniNumber'	,defaultValue:0}
			, {name:'LONG_INVEST_STOCK_DED_I'	, text:'장기집합투자증권저축'						, type:'uniNumber'	,defaultValue:0}
			, {name:'INCOME_REDU_I'				, text:'소득세법'								, type:'uniNumber'	,defaultValue:0}
			, {name:'YOUTH_EXEMP_RATE'			, text:'중소기업청년소득세감면율'						, type:'uniNumber'	,defaultValue:0}
			, {name:'YOUTH_DED_I'				, text:'중소기업청년소득세감면금액(100%)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'YOUTH_DED_I3'				, text:'중소기업청년소득세감면금액(70%)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'YOUTH_DED_I2'				, text:'중소기업청년소득세감면금액(50%)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'YOUTH_DED_I_SUM'			, text:'중소기업청년 감면기간내 총소득금액(감면소득)'			, type:'uniNumber'	,defaultValue:0}
			, {name:'SKILL_DED_I'				, text:'외국인기술공제'							, type:'uniNumber'	,defaultValue:0}
			, {name:'MANAGE_RESULT_REDU_I'		, text:'성과공유중소기업경영성과급'						, type:'uniNumber'	,defaultValue:0}
			, {name:'CORE_COMPEN_FUND_REDU_I'	, text:'중소기업핵심인력성과보상기금'					, type:'uniNumber'	,defaultValue:0}
			, {name:'RETURN_WORKER_REDU_I'		, text:'내국인우수인력국내복귀'						, type:'uniNumber'	,defaultValue:0}
			, {name:'TAXES_REDU_I'				, text:'조감법'								, type:'uniNumber'	,defaultValue:0}
			, {name:'IN_TAX_DED_I'				, text:'근로소득세액공제'							, type:'uniNumber'	,defaultValue:0}
			, {name:'CHILD_TAX_DED_I'			, text:'자녀세액공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'BRING_CHILD_DED_I'			, text:'자녀세액공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'BIRTH_ADOPT_I'				, text:'출산입양공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'SCI_DEDUC_I'				, text:'(공제대상)과학기술인공제'						, type:'uniNumber'	,defaultValue:0}
			, {name:'RETIRE_PENS_I'				, text:'(공제대상)근로자퇴직급여보장법'					, type:'uniNumber'	,defaultValue:0}
			, {name:'PENS_I'					, text:'(공제대상)연금저축소득공제'					, type:'uniNumber'	,defaultValue:0}
			, {name:'SCI_TAX_DED_I'				, text:'과학기술인공제	  (급여5,500만원이상 12% 적용)'		, type:'uniNumber'	,defaultValue:0}
			, {name:'SCI_TAX_DED_I1'			, text:'과학기술인공제	  (급여5,500만원이하 15% 적용)'		, type:'uniNumber'	,defaultValue:0}
			, {name:'RETIRE_TAX_DED_I'			, text:'근로자퇴직급여보장법(급여5,500만원이상 12% 적용)'	, type:'uniNumber'	,defaultValue:0}
			, {name:'RETIRE_TAX_DED_I1'			, text:'근로자퇴직급여보장법(급여5,500만원이하 15% 적용)'	, type:'uniNumber'	,defaultValue:0}
			, {name:'PENS_TAX_DED_I'			, text:'연금저축소득공제	(급여5,500만원이상 12% 적용)'	, type:'uniNumber'	,defaultValue:0}
			, {name:'PENS_TAX_DED_I1'			, text:'연금저축소득공제	(급여5,500만원이하 15% 적용)'	, type:'uniNumber'	,defaultValue:0}
			, {name:'ETC_INSUR_I'				, text:'(공제대상)보장성보험'						, type:'uniNumber'	,defaultValue:0}
			, {name:'DEFORM_INSUR_I'			, text:'(공제대상)장애인전용보장성보험'					, type:'uniNumber'	,defaultValue:0}
			, {name:'ETC_INSUR_TAX_DED_I'		, text:'보장성보험'								, type:'uniNumber'	,defaultValue:0}
			, {name:'DEFORM_INSUR_TAX_DED_I'	, text:'장애인전용보장성보험'						, type:'uniNumber'	,defaultValue:0}
			, {name:'MED_DED_I'					, text:'(공제대상)의료비공제금액'						, type:'uniNumber'	,defaultValue:0}
			, {name:'MY_MED_DED_I'				, text:'(공제대상)본인의료비'						, type:'uniNumber'	,defaultValue:0}
			, {name:'SENIOR_MED_I'				, text:'(공제대상)경로의료비'						, type:'uniNumber'	,defaultValue:0}
			, {name:'DEFORM_MED_I'				, text:'(공제대상)장애의료비'						, type:'uniNumber'	,defaultValue:0}
			, {name:'SURGERY_MED_I'				, text:'(공제대상)난임시술비'						, type:'uniNumber'	,defaultValue:0}
			, {name:'SERIOUS_SICK_MED_I'		, text:'(공제대상)건강보험산정특례자의료비'				, type:'uniNumber'	,defaultValue:0}
			, {name:'SERIOUS_MED_TAX_DED_I'		, text:'건강보험산정특례자의료비'						, type:'uniNumber'	,defaultValue:0}
			, {name:'MED_TOTAL_I'				, text:'(공제대상)그밖의 공제대상자 의료비'				, type:'uniNumber'	,defaultValue:0}
			, {name:'MED_TAX_DED_I'				, text:'의료비공제금액'							, type:'uniNumber'	,defaultValue:0}
			, {name:'MY_MED_TAX_DED_I'			, text:'본인의료비'								, type:'uniNumber'	,defaultValue:0}
			, {name:'SENIOR_MED_TAX_DED_I'		, text:'경로의료비'								, type:'uniNumber'	,defaultValue:0}
			, {name:'DEFORM_MED_TAX_DED_I'		, text:'장애의료비'								, type:'uniNumber'	,defaultValue:0}
			, {name:'SURGERY_MED_TAX_DED_I'		, text:'난임시술비'								, type:'uniNumber'	,defaultValue:0}
			, {name:'MED_TOTAL_TAX_DED_I'		, text:'그밖의 공제대상자 의료비'						, type:'uniNumber'	,defaultValue:0}
			, {name:'EDUC_DED_I'				, text:'(공제대상)교육비공제'						, type:'uniNumber'	,defaultValue:0}
			, {name:'UNIV_EDUC_NUM'				, text:'대학교자녀수'								, type:'uniNumber'	,defaultValue:0}
			, {name:'STUD_EDUC_NUM'				, text:'초중고자녀수'								, type:'uniNumber'	,defaultValue:0}
			, {name:'KIND_EDU_NUM'				, text:'유치원자녀수'								, type:'uniNumber'	,defaultValue:0}
			, {name:'PER_EDUC_DED_I'			, text:'(공제대상)본인교육비공제'						, type:'uniNumber'	,defaultValue:0}
			, {name:'UNIV_EDUC_DED_I'			, text:'(공제대상)대학교교육비공제'					, type:'uniNumber'	,defaultValue:0}
			, {name:'STUD_EDUC_DED_I'			, text:'(공제대상)초중고교육비공제'					, type:'uniNumber'	,defaultValue:0}
			, {name:'KIND_EDUC_DED_I'			, text:'(공제대상)유치원교육비공제'					, type:'uniNumber'	,defaultValue:0}
			, {name:'DEFORM_EDUC_DED_I'			, text:'(공제대상)장애인특수교육비공제'					, type:'uniNumber'	,defaultValue:0}
			, {name:'FIELD_EDUC_DED_I'			, text:'(공제대상)체험학습비공제'						, type:'uniNumber'	,defaultValue:0}
			, {name:'EDUC_TAX_DED_I'			, text:'교육비공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'PER_EDUC_TAX_DED_I'		, text:'본인교육비공제'							, type:'uniNumber'	,defaultValue:0}
			, {name:'UNIV_EDUC_TAX_DED_I'		, text:'대학교교육비공제'							, type:'uniNumber'	,defaultValue:0}
			, {name:'STUD_EDUC_TAX_DED_I'		, text:'초중고교육비공제'							, type:'uniNumber'	,defaultValue:0}
			, {name:'KIND_EDUC_TAX_DED_I'		, text:'유치원교육비공제'							, type:'uniNumber'	,defaultValue:0}
			, {name:'DEFORM_EDUC_TAX_DED_I'		, text:'장애인특수교육비공제'						, type:'uniNumber'	,defaultValue:0}
			, {name:'FIELD_EDUC_TAX_DED_I'		, text:'체험학습비공제'							, type:'uniNumber'	,defaultValue:0}
			, {name:'POLICY_INDED'				, text:'(입력금액)정치자금기부금(10만원미만)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'POLICY_GIFT_I'				, text:'(입력금액)정치자금기부금(10만원초과)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'LEGAL_GIFT_I_PREV'			, text:'(입력금액)법정기부금이월-2013'				, type:'uniNumber'	,defaultValue:0}
			, {name:'LEGAL_GIFT_I_PREV_14'		, text:'(입력금액)법정기부금이월-2014'				, type:'uniNumber'	,defaultValue:0}
			, {name:'LEGAL_GIFT_I'				, text:'(입력금액)법정기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'PRIV_GIFT_I_PREV'			, text:'(입력금액)특례기부금이월액'					, type:'uniNumber'	,defaultValue:0}
			, {name:'PRIV_GIFT_I'				, text:'(입력금액)특례기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'PUBLIC_GIFT_I_PREV'		, text:'(입력금액)공익법인신탁기부금이월액'				, type:'uniNumber'	,defaultValue:0}
			, {name:'PUBLIC_GIFT_I'				, text:'(입력금액)공익법인신탁기부금'					, type:'uniNumber'	,defaultValue:0}
			, {name:'STAFF_GIFT_I'				, text:'(입력금액)우리사주기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'APPOINT_GIFT_I_PREV'		, text:'(입력금액)지정기부금이월액-2013'				, type:'uniNumber'	,defaultValue:0}
			, {name:'APPOINT_GIFT_I_PREV_14'	, text:'(입력금액)지정기부금이월액-2014'				, type:'uniNumber'	,defaultValue:0}
			, {name:'APPOINT_GIFT_I'			, text:'(입력금액)지정기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'ASS_GIFT_I_PREV'			, text:'(입력금액)종교단체기부금이월액-2013'				, type:'uniNumber'	,defaultValue:0}
			, {name:'ASS_GIFT_I_PREV_14'		, text:'(입력금액)종교단체기부금이월액-2014'				, type:'uniNumber'	,defaultValue:0}
			, {name:'ASS_GIFT_I'				, text:'(입력금액)종교단체기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'POLICY_INDED_DED_AMT'		, text:'(공제대상)정치자금기부금(10만원미만)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'POLICY_GIFT_DED_AMT'		, text:'(공제대상)정치자금기부금(10만원초과)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'LEGAL_DED_AMT'				, text:'(공제대상)법정기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'STAFF_DED_AMT'				, text:'(공제대상)우리사주기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'APPOINT_ASS_TAX_DED_AMT'	, text:'(공제대상)지정기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'GIFT_DED_I'				, text:'(소득공제)기부금소득공제합계'					, type:'uniNumber'	,defaultValue:0}
			, {name:'LEGAL_GIFT_DED_I'			, text:'(소득공제)법정기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'PRIV_GIFT_DED_I'			, text:'(소득공제)특례기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'PUBLIC_GIFT_DED_I'			, text:'(소득공제)공익법인신탁기부금'					, type:'uniNumber'	,defaultValue:0}
			, {name:'STAFF_GIFT_DED_I'			, text:'(소득공제)우리사주기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'APPOINT_GIFT_DED_I'		, text:'(소득공제)지정기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'ASS_GIFT_DED_I'			, text:'(소득공제)종교단체기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'GIFT_TAX_DED_I'			, text:'(세액공제)기부금세액공제합계'					, type:'uniNumber'	,defaultValue:0}
			, {name:'POLICY_INDED_TAX_DED_I'	, text:'(세액공제)정치자금기부금(10만원미만)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'POLICY_GIFT_TAX_DED_I'		, text:'(세액공제)정치자금기부금(10만원초과)'				, type:'uniNumber'	,defaultValue:0}
			, {name:'LEGAL_GIFT_TAX_DED_I'		, text:'(세액공제)법정기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'STAFF_GIFT_TAX_DED_I'		, text:'(세액공제)우리사주기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'APPOINT_GIFT_TAX_DED_I'	, text:'(세액공제)지정기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'ASS_GIFT_TAX_DED_I'		, text:'(세액공제)종교단체기부금'						, type:'uniNumber'	,defaultValue:0}
			, {name:'NAP_TAX_DED_I'				, text:'납세조합세액공제'							, type:'uniNumber'	,defaultValue:0}
			, {name:'HOUS_INTER_I'				, text:'주택자금상환액'							, type:'uniNumber'	,defaultValue:0}
			, {name:'OUTSIDE_INCOME_I'			, text:'외국납부세액'								, type:'uniNumber'	,defaultValue:0}
			, {name:'MON_RENT_I'				, text:'월세액'								, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB1_DED_AMT'				, text:'(세액산출요약)기본공제'						, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB2_DED_AMT'				, text:'(세액산출요약)추가공제'						, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB3_DED_AMT'				, text:'(세액산출요약)연금보험료공제'					, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB4_DED_AMT'				, text:'(세액산출요약)특별소득공제-보험료'				, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB5_DED_AMT'				, text:'(세액산출요약)특별소득공제-주택자금'				, type:'uniNumber'	,defaultValue:0}
			, {name:'DED_INCOME_I'				, text:'차감근로소득'								, type:'uniNumber'	,defaultValue:0}
			, {name:'DED_INCOME_I1'				, text:'차감근로소득(표준세액공제계산용):특별소득공제포함'		, type:'uniNumber'	,defaultValue:0}
			, {name:'DED_INCOME_I2'				, text:'차감근로소득(표준세액공제계산용):특별소득공제제외'		, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB6_DED_AMT'				, text:'(세액산출요약)그밖소득공제-연금저축'				, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB7_DED_AMT'				, text:'(세액산출요약)그밖소득공제-주택마련'				, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB8_DED_AMT'				, text:'(세액산출요약)그밖소득공제-신용카드'				, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB9_DED_AMT'				, text:'세액산출요약)그밖소득공제-기타'					, type:'uniNumber'	,defaultValue:0}
			, {name:'OVER_INCOME_DED_LMT'		, text:'특별공제 종합한도 초과액'						, type:'uniNumber'	,defaultValue:0}
			, {name:'TAX_STD_I'					, text:'소득과세표준'								, type:'uniNumber'	,defaultValue:0}
			, {name:'TAX_STD_I1'				, text:'소득과세표준(표준세액공제계산용):특별소득공제포함'		, type:'uniNumber'	,defaultValue:0}
			, {name:'TAX_STD_I2'				, text:'소득과세표준(표준세액공제계산용):특별소득공제제외'		, type:'uniNumber'	,defaultValue:0}
			, {name:'COMP_TAX_I'				, text:'산출세액'								, type:'uniNumber'	,defaultValue:0}
			, {name:'COMP_TAX_I1'				, text:'산출세액(표준세액공제계산용):특별소득공제포함'			, type:'uniNumber'	,defaultValue:0}
			, {name:'COMP_TAX_I2'				, text:'산출세액(표준세액공제계산용):특별소득공제제외'			, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB10_DED_AMT'				, text:'(세액산출요약)세액감면'						, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB11_DED_AMT'				, text:'(세액산출요약)세액공제-근로소득/자녀'				, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB12_DED_AMT'				, text:'(세액산출요약)세액공제-연금계좌'					, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB13_DED_AMT'				, text:'(세액산출요약)특별세액공제-보험료'				, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB14_DED_AMT'				, text:'(세액산출요약)특별세액공제-의료비'				, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB15_DED_AMT'				, text:'(세액산출요약)특별세액공제-교육비'				, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB16_DED_AMT'				, text:'(세액산출요약)특별세액공제-기부금'				, type:'uniNumber'	,defaultValue:0}
			, {name:'STD_TAX_DED_I'				, text:'표준세액공제'								, type:'uniNumber'	,defaultValue:0}
			, {name:'TAB17_DED_AMT'				, text:'(세액산출요약)세액공제-기타'					, type:'uniNumber'	,defaultValue:0}
			, {name:'DEF_IN_TAX_I'				, text:'결정소득세'								, type:'uniNumber'	,defaultValue:0}
			, {name:'DEF_LOCAL_TAX_I'			, text:'결정주민세'								, type:'uniNumber'	,defaultValue:0}
			, {name:'DEF_SP_TAX_I'				, text:'결정농특세'								, type:'uniNumber'	,defaultValue:0}
			, {name:'DEF_TAX_SUM'				, text:'(세액산출요약)결정세액합계'					, type:'uniNumber'	,defaultValue:0}
			, {name:'NOW_IN_TAX_I'				, text:'주(현)소득세'							, type:'uniNumber'	,defaultValue:0}
			, {name:'NOW_LOCAL_TAX_I'			, text:'주(현)주민세'							, type:'uniNumber'	,defaultValue:0}
			, {name:'NOW_SP_TAX_I'				, text:'주(현)농특세'							, type:'uniNumber'	,defaultValue:0}
			, {name:'NOW_TAX_SUM'				, text:'(세액산출요약)현근무지기납부세액'					, type:'uniNumber'	,defaultValue:0}
			, {name:'PRE_IN_TAX_I'				, text:'종(전)소득세'							, type:'uniNumber'	,defaultValue:0}
			, {name:'PRE_LOCAL_TAX_I'			, text:'종(전)주민세'							, type:'uniNumber'	,defaultValue:0}
			, {name:'PRE_SP_TAX_I'				, text:'종(전)농특세'							, type:'uniNumber'	,defaultValue:0}
			, {name:'PRE_TAX_SUM'				, text:'(세액산출요약)종전근무지결정세액'					, type:'uniNumber'	,defaultValue:0}
			, {name:'NAP_IN_TAX_I'				, text:'(납)소득세'								, type:'uniNumber'	,defaultValue:0}
			, {name:'NAP_LOCAL_TAX_I'			, text:'(납)주민세'								, type:'uniNumber'	,defaultValue:0}
			, {name:'NAP_SP_TAX_I'				, text:'(납)농특세'								, type:'uniNumber'	,defaultValue:0}
			, {name:'NAP_TAX_SUM'				, text:'(세액산출요약)납세조합기납부세액'					, type:'uniNumber'	,defaultValue:0}
			, {name:'PAID_IN_TAX_SUM'			, text:'(조회용)기납부소득세합계'						, type:'uniNumber'	,defaultValue:0}
			, {name:'PAID_LOCAL_TAX_SUM'		, text:'(조회용)기납부주민세합계'						, type:'uniNumber'	,defaultValue:0}
			, {name:'PAID_SP_TAX_SUM'			, text:'(조회용)기납부농특세합계'						, type:'uniNumber'	,defaultValue:0}
			, {name:'PAID_TAX_SUM'				, text:'(조회용)기납부세액합계'						, type:'uniNumber'	,defaultValue:0}
			, {name:'IN_TAX_I'					, text:'정산소득세'								, type:'uniNumber'	,defaultValue:0}
			, {name:'LOCAL_TAX_I'				, text:'정산주민세'								, type:'uniNumber'	,defaultValue:0}
			, {name:'SP_TAX_I'					, text:'정산농특세'								, type:'uniNumber'	,defaultValue:0}
			, {name:'TAX_SUM'					, text:'(조회용)정산세액합계'						, type:'uniNumber'	,defaultValue:0}
			, {name:'IN_TAX_DED_I'				, text:''									, type:'uniNumber'	,defaultValue:0}
			, {name:'CHILD_TAX_DED_I'			, text:''									, type:'uniNumber'	,defaultValue:0}
			, {name:'BRING_CHILD_DED_I'			, text:''									, type:'uniNumber'	,defaultValue:0}
			, {name:'BIRTH_ADOPT_I'				, text:''									, type:'uniNumber'	,defaultValue:0}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var direct600Store = Unilite.createStore('had620ukr600Store',{
			model: 'had620ukr600Model',
			autoLoad: false,
			folderSort: true,
			uniOpt : {
				isMaster: true,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},

			proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
				api: {
					  read : 'had620ukrService.selectFormHad600'
					, update : 'had620ukrService.update600'
					, create : 'had620ukrService.insert600'
					, destroy: 'had620ukrService.deleteAll'
					, syncAll: 'had620ukrService.save600All'
				}
			}),
			listeners:{
				load: function ( store, records, successful, operation, eOpts )	{
					Ext.getBody().unmask();
					if(records && records.length > 0)	{
						var form600_base = Ext.getCmp('baseForm600');
						var form600_tab01 = Ext.getCmp('tab1Form600');
						var form600_tab02 = Ext.getCmp('tab2Form600');
						var form600_tab03 = Ext.getCmp('tab3Form600');
						var form600_tab04 = Ext.getCmp('tab4Form600');
						var form600_tab05 = Ext.getCmp('tab5Form600');
						var form600_tab06 = Ext.getCmp('tab6Form600');
						var form600_tab07 = Ext.getCmp('tab7Form600');
						var form600_tab08 = Ext.getCmp('tab8Form600');
						var form600_tab09 = Ext.getCmp('tab9Form600');
						var form600_tab10 = Ext.getCmp('tab10Form600');
						var form600_tab11 = Ext.getCmp('tab11Form600');
						var form600_tab12 = Ext.getCmp('tab12Form600');
						var form600_tab13 = Ext.getCmp('tab13Form600');
						var form600_tab14 = Ext.getCmp('tab14Form600');
						var form600_tab15 = Ext.getCmp('tab15Form600');
						var form600_tab16 = Ext.getCmp('tab16Form600');
						var form600_tab17 = Ext.getCmp('tab17Form600');
						var form600_tab18 = Ext.getCmp('tab18Form600');
						var form600_south = Ext.getCmp('southForm600');

						form600_base.setActiveRecord(records[0]);
						form600_tab01.setActiveRecord(records[0]);
						form600_tab01.setReadOnly(true);
						form600_tab02.setActiveRecord(records[0]);
						form600_tab02.setReadOnly(true);
						form600_tab03.setActiveRecord(records[0]);
						form600_tab04.setActiveRecord(records[0]);
						form600_tab05.setActiveRecord(records[0]);
						form600_tab06.setActiveRecord(records[0]);
						form600_tab07.setActiveRecord(records[0]);
						form600_tab08.setActiveRecord(records[0]);
						form600_tab09.setActiveRecord(records[0]);
						form600_tab10.setActiveRecord(records[0]);
						form600_tab11.setActiveRecord(records[0]);
						form600_tab12.setActiveRecord(records[0]);
						form600_tab13.setActiveRecord(records[0]);
						form600_tab14.setActiveRecord(records[0]);
						form600_tab15.setActiveRecord(records[0]);
						form600_tab16.setActiveRecord(records[0]);
						form600_tab17.setActiveRecord(records[0]);
						form600_tab18.setActiveRecord(records[0]);
						form600_south.setActiveRecord(records[0]);

						UniAppManager.setToolbarButtons([ 'delete'], true);
					}
					Ext.getBody().unmask();
				},
				update:function( store, record, operation, modifiedFieldNames, details, eOpts )	{
					var form600_base = Ext.getCmp('baseForm600');
					var form600_tab01 = Ext.getCmp('tab1Form600');
					var form600_tab02 = Ext.getCmp('tab2Form600');
					var form600_tab03 = Ext.getCmp('tab3Form600');
					var form600_tab04 = Ext.getCmp('tab4Form600');
					var form600_tab05 = Ext.getCmp('tab5Form600');
					var form600_tab06 = Ext.getCmp('tab6Form600');
					var form600_tab07 = Ext.getCmp('tab7Form600');
					var form600_tab08 = Ext.getCmp('tab8Form600');
					var form600_tab09 = Ext.getCmp('tab9Form600');
					var form600_tab10 = Ext.getCmp('tab10Form600');
					var form600_tab11 = Ext.getCmp('tab11Form600');
					var form600_tab12 = Ext.getCmp('tab12Form600');
					var form600_tab13 = Ext.getCmp('tab13Form600');
					var form600_tab14 = Ext.getCmp('tab14Form600');
					var form600_tab15 = Ext.getCmp('tab15Form600');
					var form600_tab16 = Ext.getCmp('tab16Form600');
					var form600_tab17 = Ext.getCmp('tab17Form600');
					var form600_tab18 = Ext.getCmp('tab18Form600');
					var form600_south = Ext.getCmp('southForm600');

					form600_base.setActiveRecord(record);
					form600_tab01.setActiveRecord(record);
					form600_tab02.setActiveRecord(record);
					form600_tab03.setActiveRecord(record);
					form600_tab04.setActiveRecord(record);
					form600_tab05.setActiveRecord(record);
					form600_tab06.setActiveRecord(record);
					form600_tab07.setActiveRecord(record);
					form600_tab08.setActiveRecord(record);
					form600_tab09.setActiveRecord(record);
					form600_tab10.setActiveRecord(record);
					form600_tab11.setActiveRecord(record);
					form600_tab12.setActiveRecord(record);
					form600_tab13.setActiveRecord(record);
					form600_tab14.setActiveRecord(record);
					form600_tab15.setActiveRecord(record);
					form600_tab16.setActiveRecord(record);
					form600_tab17.setActiveRecord(record);
					form600_tab18.setActiveRecord(record);
					form600_south.setActiveRecord(record);
				}
			}
			// Store 관련 BL 로직
			// 검색 조건을 통해 DB에서 데이타 읽어 오기
			,loadStoreRecords : function(empNo)	{
				var param = Ext.getCmp('searchForm').getValues();
				param.PERSON_NUMB = empNo;
				
				console.log( param );
				Ext.getBody().mask();
				this.load({
					params : param
				});
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기
			,saveStore : function()	{
				var me = this;
				var toCreate = me.getNewRecords();
				var toUpdate = me.getUpdatedRecords();
				var toDelete = me.getRemovedRecords();
				var list = [].concat(toUpdate, toCreate);
				
				if(list.length > 0)	{
					var inValidRecs = this.getInvalidRecords();
					console.log("inValidRecords : ", inValidRecs);
					
					if(inValidRecs.length == 0 )	{
						var config = {
							success : function()	{
								var mRow  = empGrid.getSelectedRecord();
								if(!Ext.isEmpty(mRow)) {
									var empNo = mRow.get('PERSON_NUMB');
									direct600Store.loadStoreRecords(empNo);
								}
								direct400Store.saveStore();
							}
						}
						this.syncAllDirect(config);
					}else {
						masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				} else {
					if(me.getData() && me.getData().items)	{
						var param = me.getData().items[0].data
						console.log("save600_3 : ", param);
						Ext.getBody().mask();
						had620ukrService.update600_3(param, function(responseText, response){
							Ext.getBody().unmask();
							direct400Store.saveStore();
						})
					} else {
						direct400Store.saveStore();
					}
				}
			}
		});

		Unilite.defineModel('had620ukr400Model', {
			fields: [
				  {name:'PERSON_NUMB'				, text:'사번'								, type:'string'}
				, {name:'NAME'						, text:'성명'								, type:'string'}
				, {name:'DEPT_CODE'					, text:'부서코드'							, type:'string'}
				, {name:'DEPT_NAME'					, text:'부서명'							, type:'string'}
				, {name:'POST_CODE'					, text:'직위코드'							, type:'string'}
				, {name:'POST_NAME'					, text:'직위'								, type:'string'}
				, {name:'REPRE_NUM'					, text:'주민번호'							, type:'string'}
				, {name:'FOREIGN_NUM'				, text:'외국인번호'							, type:'string'}
				, {name:'NATION_CODE'				, text:'국적'								, type:'string'}
				, {name:'LIVE_GUBUN'				, text:'거주구분'							, type:'string'}
				, {name:'YEAR_YYYY'					, text:'정산년도'							, type:'string'}
				, {name:'HALFWAY_TYPE'				, text:'중도퇴사자정산여부'						, type:'bool'}
				, {name:'FORE_SINGLE_YN'			, text:'외국인단일세율적용여부'					, type:'bool'}
				, {name:'FOREIGN_DISPATCH_YN'		, text:'외국법인소속 파견근로자여부'				, type:'bool'}
				, {name:'HOUSEHOLDER_YN'			, text:'세대주여부'							, type:'bool'}
				, {name:'NONTAX_FR'					, text:'세액감면기간(Fr)'						, type:'uniDate'}
				, {name:'NONTAX_TO'					, text:'세액감면기간(To)'						, type:'uniDate'}
				, {name:'INCOME_SUPP_TOTAL_I'		, text:'총급여액'							, type:'string'}
				, {name:'NOW_PAY_AMT'				, text:'주(현)총급여액'						, type:'uniNumber'}
				, {name:'NOW_PAY_TOT_I'				, text:'주(현)급여총액(숨김)'					, type:'uniNumber'}
				, {name:'NOW_BONUS_TOTAL_I'			, text:'주(현)상여총액(숨김)'					, type:'uniNumber'}
				, {name:'NOW_ADD_BONUS_I'			, text:'주(현)인정상여금액(숨김)'				, type:'uniNumber'}
				, {name:'NOW_STOCK_PROFIT_I'		, text:'주(현)주식매수선택행사이익(숨김)'			, type:'uniNumber'}
				, {name:'NOW_OWNER_STOCK_DRAW_I'	, text:'주(현)우리사주조합인출금(숨김)'				, type:'uniNumber'}
				, {name:'NOW_OF_RETR_OVER_I'		, text:'주(현)임원퇴직한도초과액(숨김)'				, type:'uniNumber'}
				, {name:'NOW_TAX_INVENTION_I'		, text:'주(현)직무발명보상금과세분(숨김)'			, type:'uniNumber'}
				, {name:'OLD_PAY_AMT'				, text:'종(전)총급여액'						, type:'uniNumber'}
				, {name:'OLD_PAY_TOT_I'				, text:'종(전)급여총액'						, type:'uniNumber'}
				, {name:'OLD_BONUS_TOTAL_I'			, text:'종(전)상여총액'						, type:'uniNumber'}
				, {name:'OLD_ADD_BONUS_I'			, text:'종(전)인정상여금액'					, type:'uniNumber'}
				, {name:'OLD_STOCK_PROFIT_I'		, text:'종(전)주식매수선택행사이익'				, type:'uniNumber'}
				, {name:'OLD_OWNER_STOCK_DRAW_I'	, text:'종(전)우리사주조합인출금'					, type:'uniNumber'}
				, {name:'OLD_OF_RETR_OVER_I'		, text:'종(전)임원퇴직한도초과액'					, type:'uniNumber'}
				, {name:'OLD_TAX_INVENTION_I'		, text:'종(전)직무발명보상금과세'					, type:'uniNumber'}
				, {name:'NAP_PAY_AMT'				, text:'(납)총급여액'						, type:'uniNumber'}
				, {name:'NAP_PAY_TOT_I'				, text:'(납)급여총액'						, type:'uniNumber'}
				, {name:'NAP_BONUS_TOTAL_I'			, text:'(납)상여총액'						, type:'uniNumber'}
				, {name:'INCOME_DED_I'				, text:'근로소득공제'							, type:'uniNumber'}
				, {name:'EARN_INCOME_I'				, text:'근로소득금액'							, type:'uniNumber'}
				, {name:'PER_DED_I'					, text:'본인공제'							, type:'uniNumber'}
				, {name:'SPOUSE'					, text:'배우자유무'							, type:'string'}
				, {name:'SUPP_NUM'					, text:'부양자'							, type:'uniNumber'}
				, {name:'SUPP_NUM_1'				, text:'부양자:직계존속'						, type:'uniNumber'}
				, {name:'SUPP_NUM_4'				, text:'부양자:직계비속-자녀입양자'				, type:'uniNumber'}
				, {name:'SUPP_NUM_5'				, text:'부양자:직계비속-그외직계비속'				, type:'uniNumber'}
				, {name:'SUPP_NUM_6'				, text:'부양자:형제자매'						, type:'uniNumber'}
				, {name:'SUPP_NUM_7'				, text:'부양자:수급자'						, type:'uniNumber'}
				, {name:'SUPP_NUM_8'				, text:'부양자:위탁아동'						, type:'uniNumber'}
				, {name:'AGED_NUM'					, text:'경로자'							, type:'uniNumber'}
				, {name:'DEFORM_NUM'				, text:'장애자'							, type:'uniNumber'}
				, {name:'MANY_CHILD_NUM'			, text:'자녀'								, type:'uniNumber'}
				, {name:'BRING_CHILD_NUM'			, text:'자녀양육'							, type:'uniNumber'}
				, {name:'BIRTH_ADOPT_NUM'			, text:'출산입양'							, type:'uniNumber'}
				, {name:'WOMAN'						, text:'부녀자유무'							, type:'string'}
				, {name:'ONE_PARENT'				, text:'한부모유무'							, type:'string'}
				, {name:'BIRTH_ADOPT_NUM1'			, text:'출산입양첫째'							, type:'uniNumber'}
				, {name:'BIRTH_ADOPT_NUM2'			, text:'출산입양둘째'							, type:'uniNumber'}
				, {name:'BIRTH_ADOPT_NUM3'			, text:'출산입양셋째'							, type:'uniNumber'}
				, {name:'ANU_I'						, text:'국민연금보험료'						, type:'uniNumber'}
				, {name:'ANU_ADD_I'					, text:'국민연금보험료(개별입력)'					, type:'uniNumber'}
				, {name:'PUBLIC_PENS_I'				, text:'공무원연금'							, type:'uniNumber'}
				, {name:'SOLDIER_PENS_I'			, text:'군인연금'							, type:'uniNumber'}
				, {name:'SCH_PENS_I'				, text:'사립학교교직원연금'						, type:'uniNumber'}
				, {name:'POST_PENS_I'				, text:'별정우체국연금'						, type:'uniNumber'}
				, {name:'MED_PREMINM_I'				, text:'건강보험료'							, type:'uniNumber'}
				, {name:'MED_PREMINM_ADD_I'			, text:'건강보험료(개별입력)'					, type:'uniNumber'}
				, {name:'HIRE_INSUR_I'				, text:'고용보험료'							, type:'uniNumber'}
				, {name:'HIRE_INSUR_ADD_I'			, text:'고용보험료(개별입력)'					, type:'uniNumber'}
				, {name:'HOUS_AMOUNT_TOT_I'			, text:'원리금상환액(대출기관)'					, type:'uniNumber'}
				, {name:'HOUS_AMOUNT_TOT_I_2'		, text:'원리금상환액(거주자)'					, type:'uniNumber'}
				, {name:'HOUS_AMOUNT_INTER_I_2'		, text:'주택자금이자상환액(15년미만)'				, type:'uniNumber'}
				, {name:'HOUS_AMOUNT_INTER_I'		, text:'주택자금이자상환액(15년~29년)'			, type:'uniNumber'}
				, {name:'HOUS_AMOUNT_INTER_I_3'		, text:'주택자금이자상환액(30년이상)'				, type:'uniNumber'}
				, {name:'FIXED_RATE_LOAN'			, text:'고정금리비거치상환대출'					, type:'uniNumber'}
				, {name:'ETC_LOAN'					, text:'기타대출'							, type:'uniNumber'}
				, {name:'HOUS_AMOUNT_INTER_I_6'		, text:'15년이상(고정금리이면서 비거치상환)'			, type:'uniNumber'}
				, {name:'HOUS_AMOUNT_INTER_I_7'		, text:'15년이상(고정금리이거나 비거치상환)'			, type:'uniNumber'}
				, {name:'HOUS_AMOUNT_INTER_I_8'		, text:'15년이상(그밖의대출)'					, type:'uniNumber'}
				, {name:'HOUS_AMOUNT_INTER_I_9'		, text:'10년이상(고정금리이거나 비거치상환)'			, type:'uniNumber'}
				, {name:'PRIV_PENS_I'				, text:'개인연금저축소득공제'					, type:'uniNumber'}
				, {name:'HOUS_BU_AMT'				, text:'청약저축'							, type:'uniNumber'}
				, {name:'HOUS_BU_ADD_AMT'			, text:'청약저축(120만원한도)'					, type:'uniNumber'}
				, {name:'HOUS_WORK_AMT'				, text:'근로자주택마련저축'						, type:'uniNumber'}
				, {name:'HOUS_AMOUNT_I'				, text:'주택청약종합저축'						, type:'uniNumber'}
				, {name:'HOUS_AMOUNT_ADD_I'			, text:'주택청약종합저축(120만원한도)'				, type:'uniNumber'}
				, {name:'CARD_USE_I'				, text:'신용카드사용액'						, type:'uniNumber'}
				, {name:'CASH_USE_I'				, text:'현금영수증사용액'						, type:'uniNumber'}
				, {name:'DEBIT_CARD_USE_I'			, text:'직불카드사용액'						, type:'uniNumber'}
				, {name:'TRA_MARKET_USE_I'			, text:'전통시장사용액'						, type:'uniNumber'}
				, {name:'TRAFFIC_USE_I'				, text:'대중교통이용액'						, type:'uniNumber'}
				, {name:'BOOK_CONCERT_USE_I'		, text:'도서공연사용액'						, type:'uniNumber'}
				, {name:'COMP_PREMINUM'				, text:'소기업소상공인공제부금 2016년 가입한 법인대표자 여부'	, type:'bool'}
				, {name:'COMP_PREMINUM_I'			, text:'소기업소상공인공제부금2'					, type:'uniNumber'}
				, {name:'INVESTMENT_I'				, text:'투자조합출자(2012년이전 10%해당분)'			, type:'uniNumber'}
				, {name:'INVESTMENT_I3'				, text:'투자조합출자(2012년 20%해당분)'			, type:'uniNumber'}
				, {name:'INVESTMENT_I4'				, text:'투자조합출자(2013년 10%해당분)'			, type:'uniNumber'}
				, {name:'INVESTMENT_I2'				, text:'투자조합출자(2013년 30%해당분)'			, type:'uniNumber'}
				, {name:'INVESTMENT_I5'				, text:'투자조합출자(2014년 10%해당분)'			, type:'uniNumber'}
				, {name:'INVESTMENT_I6'				, text:'투자조합출자(2014년 50%해당분)'			, type:'uniNumber'}
				, {name:'INVESTMENT_I7'				, text:'투자조합출자(2014년 30%해당분)'			, type:'uniNumber'}
				, {name:'INVESTMENT_I8'				, text:'투자조합출자(2015년 10%해당분)'			, type:'uniNumber'}
				, {name:'INVESTMENT_I9'				, text:'투자조합출자(2015년100%해당분)'			, type:'uniNumber'}
				, {name:'INVESTMENT_I10'			, text:'투자조합출자(2015년 50%해당분)'			, type:'uniNumber'}
				, {name:'INVESTMENT_I11'			, text:'투자조합출자(2015년 30%해당분)'			, type:'uniNumber'}
				, {name:'STAFF_STOCK_I'				, text:'우리사주조합출연'						, type:'uniNumber'}
				, {name:'VENTURE_STOCK_I'			, text:'우리사주조합출연(벤처기업)'				, type:'uniNumber'}
				, {name:'EMPLOY_WORKER_I'			, text:'고용유지중소기업근로자소득공제'				, type:'uniNumber'}
				, {name:'NOT_AMOUNT_LOAN_I'			, text:'목돈안드는전세이자상환액(2016년 삭제)'		, type:'uniNumber'}
				, {name:'LONG_INVEST_STOCK_I'		, text:'장기집합투자증권저축'					, type:'uniNumber'}
				, {name:'INCOME_REDU_I'				, text:'소득세법'							, type:'uniNumber'}
				, {name:'TAXES_REDU_I'				, text:'조세조약'							, type:'uniNumber'}
				, {name:'SCI_DEDUC_I'				, text:'과학기술인공제'						, type:'uniNumber'}
				, {name:'RETIRE_PENS_I'				, text:'근로자퇴직급여보장법'					, type:'uniNumber'}
				, {name:'PENS_I'					, text:'연금저축소득공제'						, type:'uniNumber'}
				, {name:'PENS_OVER_50_YN'			, text:'50세여부'							, type:'bool'}
				, {name:'ETC_INSUR_I'				, text:'보장성보험'							, type:'uniNumber'}
				, {name:'DEFORM_INSUR_I'			, text:'장애인전용보장성보험'					, type:'uniNumber'}
				, {name:'MY_MED_DED_I'				, text:'본인의료비'							, type:'uniNumber'}
				, {name:'SENIOR_MED_I'				, text:'경로의료비'							, type:'uniNumber'}
				, {name:'DEFORM_MED_I'				, text:'장애의료비'							, type:'uniNumber'}
				, {name:'SURGERY_MED_I'				, text:'난임시술비'							, type:'uniNumber'}
				, {name:'SERIOUS_SICK_MED_I'		, text:'건강보험산정특례자의료비'					, type:'uniNumber'}
				, {name:'BASE_MED_I'				, text:'의료비기본공제'						, type:'uniNumber'}
				, {name:'MED_TOTAL_I'				, text:'그밖의 공제대상자 의료비'					, type:'uniNumber'}
				, {name:'PER_EDUC_I'				, text:'본인교육비'							, type:'uniNumber'}
				, {name:'UNIV_EDUC_NUM'				, text:'대학교자녀수'							, type:'uniNumber'}
				, {name:'UNIV_EDUC_I'				, text:'대학교교육비'							, type:'uniNumber'}
				, {name:'STUD_EDUC_NUM'				, text:'초중고자녀수'							, type:'uniNumber'}
				, {name:'STUD_EDUC_I'				, text:'초중고교육비'							, type:'uniNumber'}
				, {name:'KIND_EDU_NUM'				, text:'유치원자녀수'							, type:'uniNumber'}
				, {name:'KIND_EDUC_I'				, text:'유치원교육비'							, type:'uniNumber'}
				, {name:'DEFORM_EDUC_NUM'			, text:'장애인수'							, type:'uniNumber'}
				, {name:'DEFORM_EDUC_I'				, text:'장애인특수교육비'						, type:'uniNumber'}
				, {name:'FIELD_EDUC_I'				, text:'체험학습비'							, type:'uniNumber'}
				, {name:'PER_EDUC_DED_I'			, text:'본인교육비공제'						, type:'uniNumber'}
				, {name:'UNIV_EDUC_DED_I'			, text:'대학교교육비공제'						, type:'uniNumber'}
				, {name:'STUD_EDUC_DED_I'			, text:'초중고교육비공제'						, type:'uniNumber'}
				, {name:'KIND_EDUC_DED_I'			, text:'유치원교육비공제'						, type:'uniNumber'}
				, {name:'DEFORM_EDUC_DED_I'			, text:'장애인특수교육비공제'					, type:'uniNumber'}
				, {name:'FIELD_EDUC_DED_I'			, text:'체헙학습비공제'						, type:'uniNumber'}
				, {name:'POLICY_INDED'				, text:'정치자금기부금공제'						, type:'uniNumber'}
				, {name:'POLICY_GIFT_I'				, text:'정치자금기부금'						, type:'uniNumber'}
				, {name:'LEGAL_GIFT_I_PREV'			, text:'법정기부금(전년도이월액)-2013'			, type:'uniNumber'}
				, {name:'LEGAL_GIFT_I_PREV_14'		, text:'법정기부금(전년도이월액)-2014'			, type:'uniNumber'}
				, {name:'LEGAL_GIFT_I'				, text:'법정기부금'							, type:'uniNumber'}
				, {name:'PRIV_GIFT_I_PREV'			, text:'특례기부금(전년도이월액)'					, type:'uniNumber'}
				, {name:'PRIV_GIFT_I'				, text:'특례기부금'							, type:'uniNumber'}
				, {name:'PUBLIC_GIFT_I_PREV'		, text:'공익법인신탁기부금(전년도이월액)'				, type:'uniNumber'}
				, {name:'PUBLIC_GIFT_I'				, text:'공익법인신탁기부금'						, type:'uniNumber'}
				, {name:'STAFF_GIFT_I'				, text:'우리사주기부금'						, type:'uniNumber'}
				, {name:'APPOINT_GIFT_I_PREV'		, text:'지정기부금(전년도이월액)-2013'			, type:'uniNumber'}
				, {name:'APPOINT_GIFT_I_PREV_14'	, text:'지정기부금(전년도이월액)-2014'			, type:'uniNumber'}
				, {name:'APPOINT_GIFT_I'			, text:'지정기부금'							, type:'uniNumber'}
				, {name:'ASS_GIFT_I_PREV'			, text:'종교단체기부금(전년도이월액)-2013'			, type:'uniNumber'}
				, {name:'ASS_GIFT_I_PREV_14'		, text:'종교단체기부금(전년도이월액)-2014'			, type:'uniNumber'}
				, {name:'ASS_GIFT_I'				, text:'종교단체기부금'						, type:'uniNumber'}
				, {name:'P3_TAX_DED_I'				, text:'납세조합세액'							, type:'uniNumber'}
				, {name:'HOUS_INTER_I'				, text:'주택자금상환액'						, type:'uniNumber'}
				, {name:'FORE_INCOME_I'				, text:'외국납부소득금액'						, type:'uniNumber'}
				, {name:'FORE_TAX_I'				, text:'외국납부세액'							, type:'uniNumber'}
				, {name:'MON_RENT_I'				, text:'월세액'							, type:'uniNumber'}
				, {name:'NEW_DATA_YN'	 			, text:'개인연말정산기초자료 존재여부'				, type:'uniNumber'}
				, {name:'YOUTH_DED_I'  				, text:'중소기업취업청년'						, type:'uniNumber'	, defaultValue:0}
				, {name:'SKILL_DED_I'				, text:'외국인기술자'							, type:'uniNumber'	, defaultValue:0}
				, {name:'MANAGE_RESULT_REDU_I'		, text:'성과공유중소기업경영성과급'					, type:'uniNumber'	, defaultValue:0}
				, {name:'CORE_COMPEN_FUND_REDU_I'	, text:'중소기업핵심인력성과보상기금'				, type:'uniNumber'	, defaultValue:0}
				, {name:'RETURN_WORKER_REDU_I'		, text:'내국인우수인력국내복귀'					, type:'uniNumber'	, defaultValue:0}
				, {name:'IN_TAX_DED_I'				, text:'근로소득세액공제'						, type:'uniNumber'	, defaultValue:0}
				, {name:'CHILD_TAX_DED_I'			, text:'자녀세액공제'							, type:'uniNumber'	, defaultValue:0}
				, {name:'BIRTH_ADOPT_I'				, text:'출산입양공제'							, type:'uniNumber'	, defaultValue:0}
			]
		});
		var direct400Store = Unilite.createStore('had620ukr400Store',{
			model: 'had620ukr400Model',
			autoLoad: false,
			folderSort: true,
			uniOpt : {
				isMaster: true,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},
			proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
				api: {
					  read : 'had620ukrService.selectFormHad400'
					, update : 'had620ukrService.update400'
					, create : 'had620ukrService.insert400'
					, syncAll: 'had620ukrService.save400All'
				}
			}),
			listeners:{
				load: function ( store, records, successful, operation, eOpts )	{
					Ext.getBody().unmask();
					if(records && records.length > 0)	{
						// 자동계산되므로 표시 되는 값이 없어 default 0으로 표시
						records[0].YOUTH_DED_I = 0;
						records[0].SKILL_DED_I = 0;
						records[0].MANAGE_RESULT_REDU_I = 0;
						records[0].CORE_COMPEN_FUND_REDU_I = 0;
						records[0].IN_TAX_DED_I = 0;
						records[0].CHILD_TAX_DED_I = 0;
						records[0].BIRTH_ADOPT_I = 0;
						
						var form400_info = Ext.getCmp('infoForm400');
						var form400_base = Ext.getCmp('baseForm400');
						var form400_tab01 = Ext.getCmp('tab1Form400');
						var form400_tab02 = Ext.getCmp('tab2Form400');
						var form400_tab03 = Ext.getCmp('tab3Form400');
						var form400_tab04 = Ext.getCmp('tab4Form400');
						var form400_tab05 = Ext.getCmp('tab5Form400');
						var form400_tab06 = Ext.getCmp('tab6Form400');
						var form400_tab07 = Ext.getCmp('tab7Form400');
						var form400_tab08 = Ext.getCmp('tab8Form400');
						var form400_tab09 = Ext.getCmp('tab9Form400');
						var form400_tab10 = Ext.getCmp('tab10Form400');
						var form400_tab11 = Ext.getCmp('tab11Form400');
						var form400_tab12 = Ext.getCmp('tab12Form400');
						var form400_tab13 = Ext.getCmp('tab13Form400');
						var form400_tab14 = Ext.getCmp('tab14Form400');
						var form400_tab15 = Ext.getCmp('tab15Form400');
						var form400_tab16 = Ext.getCmp('tab16Form400');
						var form400_tab17 = Ext.getCmp('tab17Form400');
						
						panelResult.setActiveRecord(records[0]);
						
						form400_info.setActiveRecord(records[0]);
						form400_base.setActiveRecord(records[0]);
						form400_tab01.setActiveRecord(records[0]);
						form400_tab01.setReadOnly(true);
						form400_tab02.setActiveRecord(records[0]);
						form400_tab02.setReadOnly(true);
						form400_tab03.setActiveRecord(records[0]);
						form400_tab04.setActiveRecord(records[0]);
						form400_tab05.setActiveRecord(records[0]);
						form400_tab06.setActiveRecord(records[0]);
						form400_tab07.setActiveRecord(records[0]);
						form400_tab08.setActiveRecord(records[0]);
						form400_tab09.setActiveRecord(records[0]);
						form400_tab10.setActiveRecord(records[0]);
						form400_tab11.setActiveRecord(records[0]);
						form400_tab12.setActiveRecord(records[0]);
						form400_tab13.setActiveRecord(records[0]);
						form400_tab14.setActiveRecord(records[0]);
						form400_tab15.setActiveRecord(records[0]);
						form400_tab16.setActiveRecord(records[0]);
						form400_tab17.setActiveRecord(records[0]);
					}
					Ext.getBody().unmask();
				},
				update:function( store, record, operation, modifiedFieldNames, details, eOpts )	{
					console.log("[[update]]")
					var form400_info = Ext.getCmp('infoForm400');
					var form400_base = Ext.getCmp('baseForm400');
					var form400_tab01 = Ext.getCmp('tab1Form400');
					var form400_tab02 = Ext.getCmp('tab2Form400');
					var form400_tab03 = Ext.getCmp('tab3Form400');
					var form400_tab04 = Ext.getCmp('tab4Form400');
					var form400_tab05 = Ext.getCmp('tab5Form400');
					var form400_tab06 = Ext.getCmp('tab6Form400');
					var form400_tab07 = Ext.getCmp('tab7Form400');
					var form400_tab08 = Ext.getCmp('tab8Form400');
					var form400_tab09 = Ext.getCmp('tab9Form400');
					var form400_tab10 = Ext.getCmp('tab10Form400');
					var form400_tab11 = Ext.getCmp('tab11Form400');
					var form400_tab12 = Ext.getCmp('tab12Form400');
					var form400_tab13 = Ext.getCmp('tab13Form400');
					var form400_tab14 = Ext.getCmp('tab14Form400');
					var form400_tab15 = Ext.getCmp('tab15Form400');
					var form400_tab16 = Ext.getCmp('tab16Form400');
					var form400_tab17 = Ext.getCmp('tab17Form400');
					
					form400_base.setActiveRecord(record);
					form400_tab01.setActiveRecord(record);
					form400_tab02.setActiveRecord(record);
					form400_tab03.setActiveRecord(record);
					form400_tab04.setActiveRecord(record);
					form400_tab05.setActiveRecord(record);
					form400_tab06.setActiveRecord(record);
					form400_tab07.setActiveRecord(record);
					form400_tab08.setActiveRecord(record);
					form400_tab09.setActiveRecord(record);
					form400_tab10.setActiveRecord(record);
					form400_tab11.setActiveRecord(record);
					form400_tab12.setActiveRecord(record);
					form400_tab13.setActiveRecord(record);
					form400_tab14.setActiveRecord(record);
					form400_tab15.setActiveRecord(record);
					form400_tab16.setActiveRecord(record);
					form400_tab17.setActiveRecord(record);
				}
			},
			// Store 관련 BL 로직
			// 검색 조건을 통해 DB에서 데이타 읽어 오기
			loadStoreRecords : function(empNo)	{
				var param= Ext.getCmp('searchForm').getValues();
				param.PERSON_NUMB = empNo;
				
				Ext.getBody().mask();
				console.log( param );
				this.load({
					params : param
				});
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기
			,saveStore : function()	{
				var me = this;
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					var config = {
						success : function()	{
							var mRow  = empGrid.getSelectedRecord();
							if(!Ext.isEmpty(mRow)) {
								var empNo = mRow.get('PERSON_NUMB');
								direct400Store.loadStoreRecords(empNo);
							}
						}
					}
					this.syncAllDirect(config);
				} else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		});
	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		defaults: {
			autoScroll:true
		},
		collapsed:false,
		width: 380,
		items: [{
			title: '기본정보',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '정산년도',
				fieldStyle: "text-align:center;",
				name:'YEAR_YYYY',
				xtype: 'uniYearField',
				allowBlank:false,
				value:YEAR_YYYY,
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelSearch.setValue('YEAR_YYYY', newValue);
					}
				}
			},
			Unilite.popup('Employee',{
				textFieldOnly:true,
				validateBlank:false,
				textFieldName:'PERSON_NUMB',
				valueFieldName:'NAME1',
				DBtextFieldName: 'PERSON_NUMB',
				DBvalueFieldName: 'NAME',
				fieldLabel:'사번',
				textFieldWidth:150,
				listeners: {
					onTextSpecialKey : function(field, e) {
						if(e.getKey() == 13) {
							panelSearch.setValue("NAME","");
							setTimeout(function() {UniAppManager.app.onQueryButtonDown();}, 1000);
						}
					},
					onTextFieldChange : function(field, newValue, oldValue)	{
						if(newValue == '') {
							panelSearch.setValue("NAME", "");
						}
					},
					onSelected:function(records, type)	{
						if(records)	{
							var record = records[0];
							panelSearch.setValue("PERSON_NUMB",record['PERSON_NUMB']);
							panelSearch.setValue("NAME", record['NAME']);
							
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			}),
			Unilite.popup('Employee',{
				textFieldOnly:true,
				textFieldName:'NAME',
				valueFieldName:'PERSON_NUMB1',
				DBtextFieldName: 'NAME',
				DBvalueFieldName: 'PERSON_NUMB',
				fieldLabel:'이름',
				textFieldWidth:150,
				validateBlank:false,
				listeners: {
					onTextSpecialKey : function(field, e) {
						if(e.getKey() == 13) {
							panelSearch.setValue("PERSON_NUMB","");
							setTimeout(function() {UniAppManager.app.onQueryButtonDown();}, 1000);
						}
					},
					onTextFieldChange : function(field, newValue, oldValue) {
						if(newValue == '') {
							panelSearch.setValue("PERSON_NUMB", "");
						}
					},
					onSelected:function(records, type) {
						if(records) {
							var record = records[0];
							panelSearch.setValue("PERSON_NUMB",record['PERSON_NUMB']);
							panelSearch.setValue("NAME",record['NAME']);
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			}),{
				fieldLabel: '정산구분',
				xtype: 'radiogroup',
				columns: [80,80,80],
				items: [{
					boxLabel: '전체',
					name: 'HALFWAY_TYPE',
					inputValue: 'A',
					checked: true
				},{
					boxLabel: '연말',
					name: 'HALFWAY_TYPE',
					inputValue: 'N'
				},{
					boxLabel: '중도',
					name: 'HALFWAY_TYPE',
					inputValue: 'Y'
				}],
				listeners: {
					change : function(rb, newValue, oldValue, options) {
					}
				}
			},{
				fieldLabel: '정산여부',
				xtype: 'radiogroup',
				columns: [80,80,80],
				items: [{
					boxLabel: '전체',
					name: 'ADJUST_YN',
					inputValue: 'A',
					checked: true
				},{
					boxLabel: '미정산',
					name: 'ADJUST_YN',
					inputValue: 'N'
				},{
					boxLabel: '정산',
					name: 'ADJUST_YN',
					inputValue: 'Y'
				}],
				listeners: {
					change : function(rb, newValue, oldValue, options) {
					}
				}
			}]
		},{
			title: '사원 리스트',
			itemId: 'pnlEmpGrid',
			border: 0,
			flex: 1,
			layout: {type: 'hbox', align: 'stretch'},
			items: [empGrid]
		}]
	});

	 var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,
		hidden: false,
		items: [
		{
			fieldLabel: '정산년도',
			fieldStyle: "text-align:center;",
			name:'YEAR_YYYY',
			xtype: 'uniYearField',
			allowBlank:true,
			value:YEAR_YYYY,
			readOnly:true,
			hidden:true,
			tdAttrs: {width: 300},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('Employee',{
			tdAttrs: {width: 300},
			validateBlank: false,
			allowBlank:true,
			readOnly: true
		}),
		{fieldLabel: 'DEPT_NAME', name:'DEPT_NAME', hidden:true},
		{fieldLabel: 'POST_CODE_NAME', name:'POST_NAME', hidden:true},
		{fieldLabel: 'REPRE_NUM', name:'REPRE_NUM', hidden:true},
		{fieldLabel: 'FOREIGN_NUM', name:'FOREIGN_NUM', hidden:true},
		{fieldLabel: 'NATION_CODE', name:'NATION_CODE', hidden:true},
		{fieldLabel: 'LIVE_GUBUN', name:'LIVE_GUBUN', hidden:true},
		{
			xtype: 'container',
			itemId:'btnBar',
			tdAttrs: {align: 'right'},
			height: 30,
			layout: {type: 'uniTable', columns: 4},
			items:[{
				width: 110,
				xtype: 'button',
				text: 'PDF업로드',
				itemId :'btnPdf',
				tdAttrs: {align: 'left', width: 115},
				handler : function() {
					UniAppManager.app.openPDF();
				}
			},{
				width: 110,
				xtype: 'button',
				text: '집계자료가져오기',
				itemId: 'btnCollectData',
				tdAttrs: {align: 'left', width: 115},
				handler : function() {
					if(gbCloseYn) {
						return false;
					}
					UniAppManager.app.confirmSaveData();
					if(confirm(Msg.fsbMsgH0358))	{
						UniAppManager.app.fnCollectData('REFER');
					}
				}
			},{
				width: 110,
				xtype: 'button',
				text: '정산세액계산하기',
				itemId: 'btnCalculateTax',
				tdAttrs: {align: 'left', width: 115},
				handler : function() {
					if(gbCloseYn) {
						return false;
					}
					UniAppManager.app.confirmSaveData();
					if(confirm(Msg.fsbMsgH0342))	{
						UniAppManager.app.fnCalculateTax();
					}
				}
			},{
				width: 110,
				xtype: 'button',
				itemId: 'btnClose',
				text: '마감',
				tdAttrs: {align: 'left', width: 120},
				handler : function() {
					UniAppManager.app.confirmSaveData();
					if(confirm(this.text + '하시겠습니까?')) {
						empGrid.fnSetClose();
					}
				}
			}]
		}],
		setCloseForm : function() {
			this.down('#btnCollectData').setDisabled(gbCloseYn);
			this.down('#btnCalculateTax').setDisabled(gbCloseYn);
		}
	});

	//기본공제 탭
	var tab1 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab1',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex :1,
		style : {'min-width':'1300px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [{
					xtype:'uniDetailForm',
					disabled:false,
					id:'tab1Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:2,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'button', text:'부양가족 기본공제 입력', style: 'text-align:center', tdAttrs: {height: 29}, width: '90%', itemId: 'btnFamily1', 
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openFamily('P',panelResult);
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						},
						{ xtype: 'component', html:''},

						{ xtype: 'component', html:'&nbsp;본인기본공제<font color= "blue">(자동계산)</font>', style: 'text-align:left', tdAttrs: {height: 29}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PER_DED_I'},

						{ xtype: 'component', html:'&nbsp;배우자공제', style: 'text-align:left', tdAttrs: {height: 29}},
						{
							xtype: 'uniRadiogroup',
							tdAttrs: {align : 'left'},
							items: [
								{boxLabel: '예'		, width: 60, name: 'SPOUSE', inputValue: 'Y', checked: true},
								{boxLabel: '아니오'	, width: 60, name: 'SPOUSE', inputValue: 'N'}
							]
						},

						{ xtype: 'component', html:'&nbsp;부양가족공제', style: 'text-align:left', tdAttrs: {height: 29}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'SUPP_NUM', width: 40, tdAttrs: {align : 'right'}, margin: '0 3 0 0'},

						{ xtype: 'component', html:'&nbsp;직계존속', style: 'text-align:left', tdAttrs: {height: 29}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'SUPP_NUM_1', width: 40, tdAttrs: {align : 'right'}, margin: '0 3 0 0'},

						{ xtype: 'component', html:'&nbsp;직계비속', style: 'text-align:left', rowspan: 2},
						{
							xtype: 'container',
							tdAttrs: {align : 'right'},
							layout: {type: 'uniTable', columns:2},
							margin: '0 3 0 0',
							items: [{
								xtype: 'component',
								html:'자녀입양자&nbsp;',
								padding: '0 0 2 0'
							},{
								xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'SUPP_NUM_4', width: 40, tdAttrs: {align : 'right'}, padding: '0 0 0 0'
							}]
						},

						{
							xtype: 'container',
							tdAttrs: {align : 'right'},
							layout: {type: 'uniTable', columns:2},
							margin: '0 3 0 0',
							items: [{
								xtype: 'component',
								html:'그외직계비속&nbsp;',
								padding: '0 0 2 0'
							},{
								xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'SUPP_NUM_5', width: 40, tdAttrs: {align : 'right'}, padding: '0 0 0 0'
							}]
						},

						{ xtype: 'component', html:'&nbsp;형제자매', style: 'text-align:left', tdAttrs: {height: 29}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'SUPP_NUM_6', width: 40, tdAttrs: {align : 'right'}, margin: '0 3 0 0'},

						{ xtype: 'component', html:'&nbsp;수급자', style: 'text-align:left', tdAttrs: {height: 29}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'SUPP_NUM_7', width: 40, tdAttrs: {align : 'right'}, margin: '0 3 0 0'},

						{ xtype: 'component', html:'&nbsp;위탁아동', style: 'text-align:left', tdAttrs: {height: 29}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'SUPP_NUM_8', width: 40, tdAttrs: {align : 'right'}, margin: '0 3 0 0'}

					]
				},
				{
					xtype:'uniDetailForm',
					disabled:false,
					scrollable:false,
					id:'tab1Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:5,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{ margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', colspan: 3, width:200},
						{ xtype: 'component', html:'정 산 금 액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: { style: 'min-width:350px;width:100%;'}, style: 'min-width:350px;width:100%;'},

						{ xtype: 'component', html:'', colspan: 3 },
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:''},

						{ xtype: 'component', html:'기</br>본</br>공</br>제', rowspan: 3, tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 30px;'},style:'width:30px;'},
						{ xtype: 'component', html:'본인', style:'text-align:left;', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 80px;text-align:left;'},style:'width:80px;'},
						{ xtype: 'component', html:'', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  width:80px;'},style:'width:80px;'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PER_DED_I'},
						{ xtype: 'component', html:'근로소득자 본인에 대한 기본공제(연150만원)', style: 'text-align:left;'},

						{ xtype: 'component', html:'배우자', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  '}},
						{ xtype: 'component', html:'', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  '}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SPOUSE_DED_I'},
						{ xtype: 'component', html:'연간소득금액 합계액 100만원 이하인 배우자', style: 'text-align:left;'},

						{ xtype: 'uniTextfield',  name: 'SPOUSE', hidden:true, fieldLabel:'배우자유무'},

						{ xtype: 'component', html:'부양가족', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'SUPP_NUM', width:75, tdAttrs: {style: 'border : 1px solid #ced9e7;  ', align : 'right'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SUPP_SUB_I'},
						{ xtype: 'component', html:'연간소득금액 합계액 100만원 이하인 부양가족', style: 'text-align:left;'},

						{ xtype: 'component', html:'', colspan: 3},
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:'만60세 이상 직계존속', style: 'text-align:left'},

						{ xtype: 'component', html:'', colspan: 3},
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:'만20세 이하의 거주자 직계비속</br>민법 또는 입양촉진 및 절차에 관한 특례법에 따라 입양한 양자 ', style: 'text-align:left;width:100%;', rowspan: 2},

						{ xtype: 'component', html:'', colspan: 3},
						{ xtype: 'component', html:''},

						{ xtype: 'component', html:'', colspan: 3},
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:'20세 이하 또는 60세 이상의 거주자(배우자포함) 형제자매', style: 'text-align:left;width:100%;'},

						{ xtype: 'component', html:'', colspan: 3},
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:'국민기초생활 보장법 제2조 제2호의 수급자', style: 'text-align:left;width:100%;'},

						{ xtype: 'component', html:'', colspan: 3},
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:'아동복지법에 따른 가정위탁을 받아 양육하는 아동', style: 'text-align:left;width:100%;'}
					]
				}
			]
		}]
	});

	//추가공제 탭
	var tab2 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab2',
		autoScroll: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		style : {'min-width':'1300px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [
				{
					xtype:'uniDetailForm',
					disabled:false,
					id:'tab2Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:2,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'uniNumberfield', name: 'MANY_CHILD_NUM', fieldLabel:'자녀',  hidden:true},
						{ xtype: 'uniNumberfield', name: 'BRING_CHILD_NUM', fieldLabel:'자녀양육',  hidden:true},
						{ xtype: 'uniNumberfield', name: 'BIRTH_ADOPT_NUM', fieldLabel:'출산입양',  hidden:true},

						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'button', text:'부양가족 추가공제 입력', style: 'text-align:center', itemId:'btnFamily1',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openFamily('P', panelResult);
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						},
						{ xtype: 'component', html:''},

						{ xtype: 'component', html:'&nbsp;경로우대공제(70세이상)', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'AGED_NUM', width: 40, tdAttrs: {align : 'right'}, margin: '0 3 0 0'},

						{ xtype: 'component', html:'&nbsp;장애인공제', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'DEFORM_NUM', width: 40, tdAttrs: {align : 'right'}, margin: '0 3 0 0'},

						{ xtype: 'component', html:'&nbsp;부녀자공제', style: 'text-align:left'},
						{
							xtype: 'radiogroup',
							tdAttrs: {align : 'left'},
							items: [
								{boxLabel: '예', width: 60, name: 'WOMAN', inputValue: 'Y'},
								{boxLabel: '아니오', width: 60, name: 'WOMAN', inputValue: 'N', checked: true}
							]
						},

						{ xtype: 'component', html:'&nbsp;한부모공제', style: 'text-align:left', tdAttrs:{height:40}},
						{
							xtype: 'radiogroup',
							tdAttrs: {align : 'left'},
							items: [
								{boxLabel: '예', width: 60, name: 'ONE_PARENT', inputValue: 'Y'},
								{boxLabel: '아니오', width: 60, name: 'ONE_PARENT', inputValue: 'N', checked: true}
							]
						}
					]
				},{
					xtype:'uniDetailForm',
					disabled:false,
					id:'tab2Form600',
					scrollable:false,
					padding:0,
					tdAttrs:{style:'min-width:700px;width:100%;padding-right:20px;'},
					layout: {
						type: 'table',
						columns:5,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{ margin: '2 2 2 2'},
					items:[
						{ xtype: 'uniNumberfield', name: 'MANY_CHILD_NUM', fieldLabel:'자녀',  hidden:true},
						{ xtype: 'uniNumberfield', name: 'BRING_CHILD_NUM', fieldLabel:'자녀양육',  hidden:true},
						{ xtype: 'uniNumberfield', name: 'BIRTH_ADOPT_NUM', fieldLabel:'출산입양',  hidden:true},

						{ xtype: 'component', html:'정 산 항 목', colspan: 3, width:200},
						{ xtype: 'component', html:'정 산 금 액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'min-width : 350px;  width: 100%'}, style:'min-width : 350px;width:100%;'},

						{ xtype: 'component', html:'', colspan: 3},
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:''},

						{ xtype: 'component', html:'추</br>가</br>공</br>제', rowspan: 4, tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 2%'}},
						{ xtype: 'component', html:'경로우대', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 4%'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'AGED_NUM', width: 40,margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 4%', align : 'right'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'AGED_DED_I'},
						{ xtype: 'component', html:'기본공제대상자가 만70세 이상(1945.12.31 이전 출생)인 경우', style: 'text-align:left'},

						{ xtype: 'component', html:'장애인', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 4%'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'DEFORM_NUM', width: 40,margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 4%', align : 'right'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_DED_I'},
						{ xtype: 'component', html:'기본공제대상자 중 소득세법에 따른 장애인에 해당하는 경우', style: 'text-align:left'},

						{ xtype: 'component', html:'부녀자', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 4%'}},
						{ xtype: 'component', html:'', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 4%'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'WOMAN_DED_I'},
						{ xtype: 'component', html:'근로자 본인이 여성인 경우로서 공제요건에 해당하는 경우', style: 'text-align:left'},

						{ xtype: 'component', html:'한부모', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;', height:40}},
						{ xtype: 'component', html:'', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 4%'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ONE_PARENT_DED_I'},
						{ xtype: 'component', html:'배우자가 없는 자로서 기본공제대상인 직계비속 또는 입양자가 있는 경우', style: 'text-align:left'}


					]
				}
			]
		}]
	});

	//연금보험료 공제 탭
	var tab3 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab3',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		trackResetOnLoad: true,
		style : {'min-width':'1300px;width:100%;'},
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {
				type: 'table',
				columns:2, 
				tdAttrs:{style:'vertical-align:top;height:100%;'}
			},
			scrollable: true,
			tdAttrs:{style:'vertical-align:top;'},
			items: [
				{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab3Form400',
					padding:0,
					tdAttrs: {width: 550},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{ margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}, colspan: 2},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'component', html:'&nbsp;국민연금보험료<font color= "blue">(자동집계)</font>', style: 'text-align:left', colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ANU_I'},

						{ xtype: 'component', html:'&nbsp;국민연금보험료<font color= "blue">(개별입력)</font>', style: 'text-align:left', colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'ANU_ADD_I', holdable:'hold'},

						{ xtype: 'component', html:'기타 연금 보험료', rowspan: 4, tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 150px;'}},
						{ xtype: 'component', html:'&nbsp;공무원연금', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  width:200px;'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'PUBLIC_PENS_I', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;군인연금', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 75px;'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'SOLDIER_PENS_I', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;사립학교교직원연금', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; '}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'SCH_PENS_I', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;별정우체국연금', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; '}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'POST_PENS_I', holdable:'hold'}

					],
					setCloseForm : function() {
						var fields = this.getForm().getFields();
						
						Ext.each(fields.items, function(item){
							if(item.isPopupField) {
								var fc = item.up('uniPopupField');
								if(fc.holdable == 'hold') {
									fc.setReadOnly(gbCloseYn);
								}
							}
							else {
								if(item.holdable == 'hold') {
									item.setReadOnly(gbCloseYn);
								}
							}
						});
					}
				},{
					xtype:'uniDetailForm',
					disabled:false,
					id:'tab3Form600',
					scrollable:false,
					padding:0,
					tdAttrs:{style:'min-width:700px;width:100%;padding-right:20px;'},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{ margin: '2 2 2 2'},
					items:[
						{ xtype: 'uniNumberfield', value:'0', fieldLabel:'국민연금',  hidden:true, name: 'ANU_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel:'국민연금(개별입력)',  hidden:true, name: 'ANU_ADD_I'},


						{ xtype: 'component', html:'정 산 항 목', tdAttrs:{width:200}, style:'width:200px;'},
						{ xtype: 'component', html:'정 산 금 액', tdAttrs:{width:150}, style:'width:150px;'},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs:{style:'width:100%;'}, style:'min-width:350px;width:100%;'},

						{ xtype: 'component', html:'&nbsp;국민연금', style: 'text-align:left;', tdAttrs: {height: 58}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ANU_DED_I'},
						{ xtype: 'component', html:'국민연금법에 따라 부담하는 연금보험료(사용자부담금은 제외)', style: 'text-align:left;width:100%;'},

						{ xtype: 'component', html:'&nbsp;공무원연금', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PUBLIC_PENS_I'},
						{ xtype: 'component', html:'공무원연금법에 따라 근로자가 부담하는 기여금(또는 부담금)', style: 'text-align:left;width:100%;'},

						{ xtype: 'component', html:'&nbsp;군인연금', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SOLDIER_PENS_I'},
						{ xtype: 'component', html:'군인연금법에 따라 근로자가 부담하는 기여금(또는 부담금)', style: 'text-align:left;width:100%;'},

						{ xtype: 'component', html:'&nbsp;사립학교교직원연금', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SCH_PENS_I'},
						{ xtype: 'component', html:'사립학교교직원연금법에 따라 부담하는 기여금(또는 부담금)', style: 'text-align:left;width:100%;'},

						{ xtype: 'component', html:'&nbsp;별정우체국연금', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'POST_PENS_I'},
						{ xtype: 'component', html:'별정우체국법에 따라 근로자가 부담하는 기여금(또는 부담금)', style: 'text-align:left;width:100%;'}

					]
				}
			]
		}]

	});

	//특별소득공제-보험료  탭
	var tab4 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab4',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		style : 'min-width:1300px;',
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			scrollable: false,
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [
				{
					xtype:'uniDetailForm',
					disabled:false,
					id:'tab4Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:2,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'component', html:'&nbsp;건강보험료 등<font color= "blue">(자동집계)</font>', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MED_PREMINM_I'},

						{ xtype: 'component', html:'&nbsp;건강보험료 등<font color= "blue">(개별입력)</font>', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'MED_PREMINM_ADD_I', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;고용보험료<font color= "blue">(자동집계)</font>', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HIRE_INSUR_I'},

						{ xtype: 'component', html:'&nbsp;고용보험료<font color= "blue">(개별입력)</font>', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HIRE_INSUR_ADD_I', holdable:'hold'}
					],
					setCloseForm : function() {
						var fields = this.getForm().getFields();
						
						Ext.each(fields.items, function(item){
							if(item.isPopupField) {
								var fc = item.up('uniPopupField');
								if(fc.holdable == 'hold') {
									fc.setReadOnly(gbCloseYn);
								}
							}
							else {
								if(item.holdable == 'hold') {
									item.setReadOnly(gbCloseYn);
								}
							}
						});
					}
				},{
					xtype:'uniDetailForm',
					disabled:false,
					scrollable: false,
					id:'tab4Form600',
					padding:0,
					tdAttrs:{style:'width:100%;min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', width:200, tdAttrs:{style:'width:200px;'}},
						{ xtype: 'component', html:'정 산 금 액', width:150, tdAttrs:{style:'width:150px;'}},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', style: 'width:100%;', tdAttrs: {style: 'border : 1px solid #ced9e7;99%;'}},

						{ xtype: 'component', html:'&nbsp;건강보험료 등', style: 'text-align:left', tdAttrs:{height:58}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MED_PREMINM_I'},
						{ xtype: 'component', html:'국민건강보험법 또는 노인장기요양보험법에 따라 근로자가 부담하는 보험료', style: 'text-align:left;'},

						{ xtype: 'component', html:'&nbsp;고용보험료', style: 'text-align:left', tdAttrs:{height:58}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HIRE_INSUR_I'},
						{ xtype: 'component', html:'고용보험법에 따라 근로자가 부담하는 보험료', style: 'text-align:left;'}

					]
				}
			]
		}]
	});

	//특별소득공제-주택자금  탭
	var tab5 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab5',
		scrollable:true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		style : {'min-width':'1300px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [
				{
					xtype:'uniDetailForm',
					 disabled:false,
					 scrollable:false,
					id:'tab5Form400',
					padding:0,
					tdAttrs:{width:700},
					layout: {
						type: 'table',
						columns:5,
						tableAttrs: { width: 700, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:500}, colspan: 4},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'component', html:'&nbsp;주택임차<br/>&nbsp;차입금', style: 'text-align:left', rowspan: 2, tdAttrs: {width:80}},
						{ xtype: 'component', html:'&nbsp;원리금상환액(대출기관)', style: 'text-align:left', colspan: 3},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_TOT_I', holdable:'hold'},

						{ xtype: 'button', text:'원리금상환액(거주자) 입력', style: 'text-align:center', colspan: 3, width: '50%', itemId:'btnHouseLoan', tdAttrs: {style:'text-align:left; padding-left:10px;'},
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openHouseLoan();
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_AMOUNT_TOT_I_2'},

						{ xtype: 'component', html:'&nbsp;장기주택<br/>&nbsp;저당차입금<br/>&nbsp;이자상환액', style: 'text-align:left;', rowspan: 9},
						{ xtype: 'component', html:'&nbsp;2011년 이전', style: 'text-align:left;', rowspan: 3, tdAttrs: {width:80}},
						{ xtype: 'component', html:'&nbsp;15년미만(600만원)', style: 'text-align:left;', colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I_2', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;15년~29년(1,000만원)', style: 'text-align:left;', colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;30년이상(1,500만원)', style: 'text-align:left;', colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I_3', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;2012년 이후', style: 'text-align:left;', rowspan: 2},
						{ xtype: 'component', html:'&nbsp;고정금리 OR 비거치상환(1,500만원)', style: 'text-align:left;', colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'FIXED_RATE_LOAN', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;기타대출(500만원)', style: 'text-align:left;', colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'ETC_LOAN', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;2015년 이후', style: 'text-align:left;', rowspan: 4},
						{ xtype: 'component', html:'&nbsp;15년 이상', style: 'text-align:left;', rowspan: 3, tdAttrs: {width:80}},
						{ xtype: 'component', html:'&nbsp;고정금리 And 비거치상환(1,800만원)', style: 'text-align:left;', tdAttrs: {width:240}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I_6', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;고정금리 OR 비거치상환(1,500만원)', style: 'text-align:left;'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I_7', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;그밖의대출(500만원)', style: 'text-align:left;'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I_8', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;10년~15년', style: 'text-align:left;', tdAttrs: {width:80}},
						{ xtype: 'component', html:'&nbsp;고정금리 OR 비거치상환(300만원)', style: 'text-align:left;'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I_9', holdable:'hold'}

					],
					setCloseForm : function() {
						var fields = this.getForm().getFields();
						
						Ext.each(fields.items, function(item){
							if(item.isPopupField) {
								var fc = item.up('uniPopupField');
								if(fc.holdable == 'hold') {
									fc.setReadOnly(gbCloseYn);
								}
							}
							else {
								if(item.holdable == 'hold') {
									item.setReadOnly(gbCloseYn);
								}
							}
						});
					}
				},{
					xtype:'uniDetailForm',
					disabled:false,
					id:'tab5Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:2,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{margin: '2 2 2 2'},
					items:[
						//{ xtype: 'component', html:'정 산 항 목', colspan: 3, width:250},
						{ xtype: 'component', html:'정 산 금 액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; width: 100%'}, style:'width:100%;'},

						//{ xtype: 'component', html:'주</br>택</br>자</br>금</br>공</br>제', rowspan: 11, tdAttrs: { width:25, style: 'border : 1px solid #ced9e7; '}},
						//{ xtype: 'component', html:'&nbsp;주택임차원리금</br>&nbsp;상환액', style: 'text-align:left', tdAttrs: { width:135, style: 'border : 1px solid #ced9e7; '}, rowspan: 2},
						//{ xtype: 'component', html:'&nbsp;대출기관', style: 'text-align:left', tdAttrs: { width:90, style: 'border : 1px solid #ced9e7;  '}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_AMOUNT_I'},
						{ xtype: 'component', html:'국민주택규모의 주택을 임차하기 위해 지출한 주택임차차입금', style: 'text-align:left', rowspan: 2},

						//{ xtype: 'component', html:'&nbsp;거주자', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  '}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_AMOUNT_I_2'},

						//{ xtype: 'component', html:'&nbsp;15년미만(600만원한도)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  '}, colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_2'},
						{ xtype: 'component', html:'주택에 저당권을 설정하고 금융회사 등으로부터 차입한 장기주택저당차입금의 이자', rowspan: 9, tdAttrs: {style: 'border : 1px solid #ced9e7; width: 100%'}, style:'text-align:left;width:100%;'},

						//{ xtype: 'component', html:'&nbsp;15년~29년(1,000만원한도)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; '}, colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I'},

						//{ xtype: 'component', html:'&nbsp;30년이상(1,500만원한도)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; '}, colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_3'},

						//{ xtype: 'component', html:'&nbsp;고정금리비거치상환대출', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; '}, colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_5'},

						//{ xtype: 'component', html:'&nbsp;기타대출(500만원한도)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  '}, colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_4'},

						//{ xtype: 'component', html:'&nbsp;15년이상(고정금리이면서 비거치상환)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; '}, colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_6'},

						//{ xtype: 'component', html:'&nbsp;15년이상(고정금리이거나 비거치상환)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  '}, colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_7'},

						//{ xtype: 'component', html:'&nbsp;15년이상(그밖의대출)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  '}, colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_8'},

						//{ xtype: 'component', html:'&nbsp;10년이상(고정금리이거나 비거치상환)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  '}, colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_9'}

					]
				}

			]
		}]
	});


	//그밖소득공제-연금저축 탭
	var tab6 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab6',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		xtype: 'container',
		flex: 1,
		style : {'min-width':'1300px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [
				{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab6Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:2,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'button', text:'개인연금저축 입력', style: 'text-align:center', width: '90%', itemId:'btnPension',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openPersonalPension("21");
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PRIV_PENS_I'}

					]
				},{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab6Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{ margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', width:200},
						{ xtype: 'component', html:'정 산 금 액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7;width: 100%'}, style:'width:100%;'},

						{ xtype: 'component', html:'&nbsp;개인연금저축', style: 'text-align:left;'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PRIV_PENS_I'},
						{ xtype: 'component', html:'근로자 본인 명의로 2000.12.31 이전에 가입하여 불입한 금액 ', style: 'text-align:left'}

					]
				}
			]
		}]
	});

	//그밖소득공제-주택마련 탭
	var tab7 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab7',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		style : {'min-width':'1300px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [
				{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab7Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:2,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'button', text:'청약저축(240만원한도) 입력', style: 'text-align:center', width: '90%', itemId:'btnPension1',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openPersonalPension("31");
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_BU_AMT'},

						{ xtype: 'button', text:'근로자주택마련저축 입력', style: 'text-align:center', width: '90%', itemId:'btnPension2',
						  tdAttrs:{height:40},
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openPersonalPension("34");
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_WORK_AMT'},

						{ xtype: 'button', text:'주택청약종합저축(240만원한도)', style: 'text-align:center', width: '90%', itemId:'btnPension3',
						  tdAttrs:{height:40},
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openPersonalPension("32");
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_AMOUNT_I'}
					]
				},{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab7Form600',
					scrollable:false,
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', width:200},
						{ xtype: 'component', html:'정 산 금 액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 100%'}, style:'width:100%;'},

						{ xtype: 'component', html:'&nbsp;청약저축', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_BU_AMT'},
						{ xtype: 'component', html:'주택법에 따른 청약저축에 납입한 금액', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;근로자주택마련저축', style: 'text-align:left', tdAttrs:{height:40}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_WORK_AMT'},
						{ xtype: 'component', html:'근로자의 주거안정과 목돈마련지원에 관한 법률에 따른 근로자 주택마련저축', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;주택청약종합저축', style: 'text-align:left', tdAttrs:{height:40}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_BU_AMOUNT_I'},
						{ xtype: 'component', html:'금융회사 등에 무주택확인서를 제출한 과세연도 이후에 납입한 금액 ', style: 'text-align:left'}
					]
				}
			]
		}]
	});

	//그밖소득공제-신용카드  탭
	var tab8 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab8',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		style : {'min-width':'1320px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'}},
			items: [
				{
					xtype:'uniDetailForm',
					disabled:false,
					id:'tab8Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', colspan: 2, tdAttrs: {height: 29, width:350}},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'button', text:'신용카드등 사용금액 입력', style: 'text-align:center', width: '90%', colspan: 2, itemId:'btnFamily1',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openFamily('C', panelResult);
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						},
						{ xtype: 'component', html:''},

						{ xtype: 'component', html:'&nbsp;신용카드(전통시장ㆍ대중교통 제외)', style: 'text-align:left'},
						{ xtype: 'component', html:'&nbsp;사용금액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'CARD_USE_I'},

						{ xtype: 'component', html:'&nbsp;직불카드등(전통시장ㆍ대중교통 제외)', style: 'text-align:left'},
						{ xtype: 'component', html:'&nbsp;사용금액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'DEBIT_CARD_USE_I'},

						{ xtype: 'component', html:'&nbsp;현금영수증(전통시장ㆍ대중교통 제외)', style: 'text-align:left'},
						{ xtype: 'component', html:'&nbsp;사용금액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'CASH_USE_I'},
						
						{ xtype: 'component', html:'&nbsp;도서ㆍ공연ㆍ박물관ㆍ미술관 사용액', style: 'text-align:left'},
						{ xtype: 'component', html:'&nbsp;사용금액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'BOOK_CONCERT_USE_I'},

						{ xtype: 'component', html:'&nbsp;전통시장사용분', style: 'text-align:left'},
						{ xtype: 'component', html:'&nbsp;사용금액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'TRA_MARKET_USE_I'},

						{ xtype: 'component', html:'&nbsp;대중교통이용분', style: 'text-align:left'},
						{ xtype: 'component', html:'&nbsp;사용금액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'TRAFFIC_USE_I'}
					]
				},{
					xtype:'uniDetailForm',
					disabled:false,
					id:'tab8Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:770px;padding-right:20px;'},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{ margin: '2 2 2 2'},
					items:[
						{ xtype: 'uniNumberfield', value:'0', fieldLabel:'신용카드사용액', hidden: true, name: 'CARD_USE_I', rowspan: 12},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel:'현금영수증사용액', hidden: true, name: 'CASH_USE_I', rowspan: 12},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel:'직불카드사용액', hidden: true, name: 'DEBIT_CARD_USE_I', rowspan: 12},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel:'전통시장사용액', hidden: true, name: 'TRA_MARKET_USE_I', rowspan: 12},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel:'대중교통이용액', hidden: true, name: 'TRAFFIC_USE_I', rowspan: 12},

						{ xtype: 'component', html:'정 산 항 목', width:200},
						{ xtype: 'component', html:'정 산 금 액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'width: 100%'}, style:'width:100%;'},

						{ xtype: 'component', html:'', hidden:true},

						{ xtype: 'component', html:'신용카드등 사용금액', style: 'text-align:left', rowspan: 7},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'CARD_DED_I', rowspan: 7},
						{ xtype: 'component', html:'', tdAttrs: {style: 'border : 1px solid #ced9e7;width: 100%'}, style:'width:100%;'},

						{ xtype: 'component', html:'신용카드를 사용하여 그 대가를 지급하는 금액', style: 'text-align:left;'},

						{ xtype: 'component', html:'현금영수증(현금거래사실을 확인받는 것을 포함)', style: 'text-align:left;'},

						{ xtype: 'component', html:'직불카드,선불카드 등등을 사용하여 대가로 지급한 금액', style: 'text-align:left;'},

						{ xtype: 'component', html:'간행물 구입 또는 공연 관람의 대가로 지급한 금액', style: 'text-align:left;'},

						{ xtype: 'component', html:'전통시장에서 사용한 신용카드,직불·선불카드,현금영수증 사용금액', style: 'text-align:left;'},

						{ xtype: 'component', html:'대중교통을 신용카드, 직불ㆍ선불카드, 현금영수증으로 사용한 금액', style: 'text-align:left;'}
					]
				}

			]
		}]
	});

	//그밖소득공제-기타  탭
	var tab9 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab9',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		 flex: 1,
		trackResetOnLoad: true,
		style : {'min-width':'1300px'},
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [
				{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab9Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:4,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', colspan: 3, tdAttrs: {height: 29, width:350}},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'component', html:'&nbsp;소기업·소상공인<br/>&nbsp;공제부금&nbsp;소득공제', style: 'text-align:left', tdAttrs: {width:160, height:40 }},
						 {  
							xtype: 'fieldcontainer',	//'fieldcontainer',
							defaultType: 'checkboxfield',
							colspan:2,
							width:175,
							tdAttrs:{width:185},
							items: [
								{boxLabel: '2016년 가입', name: 'COMP_PREMINUM', inputValue: true, tooltip:'2016년가입한 법인의 대표자인경우 체크', holdable:'hold'}
							],
							listeners: {
								blur: function( field, The, eOpts )	{
								}
							}
						},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'COMP_PREMINUM_I', holdable:'hold'},

						//{ xtype: 'component', html:'&nbsp;투자조합 출자공제', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; '}, rowspan: 6},
						{ xtype: 'button', text:'투자조합 출자공제 입력', style: 'text-align:center', width: '95%', rowspan: 6, tdAttrs: {width:160 }, itemId:'btnPension',
							handler:function()	{
							if(panelResult.isValid())	{
								UniAppManager.app.openPersonalPension("61");
							} else {
								Unilite.messageBox("사원을 입력하세요.");
							}
							}},
						{ xtype: 'component', html:'2018년', tdAttrs: { width:50}, rowspan: 2},
						{ xtype: 'component', html:'조합등투자금액(10%)', tdAttrs: { width:135}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I', readOnly:true},

						{ xtype: 'component', html:'벤처(100%,50%,30%)'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I2', readOnly:true},

						{ xtype: 'component', html:'2019년',  rowspan: 2},
						{ xtype: 'component', html:'조합등투자금액(10%)'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I3', readOnly:true},

						{ xtype: 'component', html:'벤처(100%,70%,30%)'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I4', readOnly:true},

						{ xtype: 'component', html:'2020년',  rowspan: 2},
						{ xtype: 'component', html:'조합등투자금액(10%)'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I5', readOnly:true},

						{ xtype: 'component', html:'벤처(100%,70%,30%)'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I6', readOnly:true},

						{ xtype: 'component', html:'&nbsp우리사주출연금<br/>&nbsp;소득공제', style: 'text-align:left', rowspan:2},
						{ xtype: 'component', html:'&nbsp;출연금', style: 'text-align:left;', colspan:2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'STAFF_STOCK_I', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;출연금(벤처기업)', style: 'text-align:left;', colspan:2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'VENTURE_STOCK_I', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;우리사주조합기부금<br/>&nbsp;소득공제', style: 'text-align:left', hidden:true},
						{ xtype: 'component', html:'&nbsp;기부금액', colspan: 2, hidden:true},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'STAFF_GIFT_I',  hidden:true},

						{ xtype: 'component', html:'&nbsp;고용유지중소기업<br/>&nbsp;근로자 소득공제', style: 'text-align:left', tdAttrs: {height:40}},
						{ xtype: 'component', html:'&nbsp;임금감소액', style: 'text-align:left;', colspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'EMPLOY_WORKER_I', holdable:'hold'},

						{ xtype: 'button', text:'장기집합투자증권저축 입력', style: 'text-align:center', width: '90%', colspan: 3, itemId:'btnPension1',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openPersonalPension("51");
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'LONG_INVEST_STOCK_I', readOnly: true}

					],
					setCloseForm : function() {
						var fields = this.getForm().getFields();
						
						Ext.each(fields.items, function(item){
							if(item.isPopupField) {
								var fc = item.up('uniPopupField');
								if(fc.holdable == 'hold') {
									fc.setReadOnly(gbCloseYn);
								}
							}
							else {
								if(item.holdable == 'hold') {
									item.setReadOnly(gbCloseYn);
								}
							}
						});
					}
				},{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab9Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', width:200},
						{ xtype: 'component', html:'정 산 금 액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 100%'}, style:'width:100%;'},


						{ xtype: 'component', html:'&nbsp;소기업·소상공인 공제부금<br/>&nbsp;소득공제', style: 'text-align:left;', tdAttrs:{height:40}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'COMP_PREMINUM_DED_I', readOnly: true},
						{ xtype: 'component', html:'소기업·소상공인 공제에 가입하여 해당 과세기간에 납부하는 공제부금', style: 'text-align:left;'},

						{ xtype: 'component', html:'&nbsp;투자조합 출자공제', style: 'text-align:left', tdAttrs:{height:174}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_DED_I', readOnly: true, tdAttrs:{height:174}},
						{ xtype: 'component', html:'중소기업창업투자조합 등에 출자 또는 투자한 금액 공제', style: 'text-align:left;', tdAttrs:{height:174}},

						{ xtype: 'uniNumberfield', value:'0', fieldLabel:'투자조합출자공제(2013년도분)' , name: 'INVESTMENT_DED_I2', hidden: true},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel:'투자조합출자공제(2014년도분)' , name: 'INVESTMENT_DED_I3', hidden: true},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel:'투자조합출자공제(2015년이후분)' , name: 'INVESTMENT_DED_I4', hidden: true},

						{ xtype: 'component', html:'&nbsp우리사주출연금소득공제', style: 'text-align:left;', tdAttrs:{height:58}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'STAFF_STOCK_DED_I', readOnly: true, tdAttrs:{height:58}},
						{ xtype: 'component', html:'우리사주조합원이 자사주를 취득하기 위하여 우리사주조합에 출자한 경우 ', style: 'text-align:left;', tdAttrs:{height:58}},

						{ xtype: 'component', html:'&nbsp;우리사주조합기부금소득공제', style: 'text-align:left;', hidden:true},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'STAFF_GIFT_DED_I', readOnly: true, hidden:true},
						{ xtype: 'component', html:'우리사주조합원이 아닌 근로자가 우리사주조합에 기부하는 기부금을 공제', style: 'text-align:left;', hidden:true},

						{ xtype: 'component', html:'&nbsp;고용유지중소기업근로자 소득공제', style: 'text-align:left;', tdAttrs:{height:40}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'EMPLOY_WORKER_DED_I', readOnly: true},
						{ xtype: 'component', html:'고용유지중소기업에 근로를 제공하는 상시근로자에 대한 공제', style: 'text-align:left;'},

						{ xtype: 'component', html:'&nbsp;장기집합투자증권저축 공제', style: 'text-align:left;'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'LONG_INVEST_STOCK_DED_I', readOnly: true},
						{ xtype: 'component', html:'자산총액 40%이상을 국내주식에 투자하는 장기 적립식 펀드', style: 'text-align:left'}
					]
				}

			]
		}]
	});

	//세액감면 공제 탭
	var tab10 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab10',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		style : {'min-width':'1300px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},

			items: [
				{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab10Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:5,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', colspan: 4, tdAttrs: {height: 29, width:350}},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'component', html:'세액</br>감면', rowspan: 7, tdAttrs: {style: 'border : 1px solid #ced9e7;', width:50}},
						{ xtype: 'component', html:'&nbsp;소득세법', style: 'text-align:left', colspan: 2, tdAttrs: {style: 'border : 2px solid #ced9e7;', width:200}},
						{ xtype: 'component', html:'감면세액', tdAttrs: {style: 'border : 1px solid #ced9e7;', width:95}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INCOME_REDU_I', holdable:'hold'},

						{ xtype: 'component', html:'&nbsp;외국인기술자', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7; '}, colspan: 2},
						{ xtype: 'component', html:'<font color= "blue">(자동계산)</font>', tdAttrs: {style: 'border : 2px solid #ced9e7; '}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SKILL_DED_I'},

						{ xtype: 'component', html:'&nbsp;중소기업취업청년', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7;', width:120}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '%', readOnly:true, name: 'YOUTH_EXEMP_RATE',tdAttrs: { width:80}},
						{ xtype: 'component', html:'<font color= "blue">(자동계산)</font>', tdAttrs: {style: 'border : 2px solid #ced9e7; ', width:95}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'YOUTH_DED_I'},
						
						{ xtype: 'component', html:'&nbsp;성과공유중소기업경영성과급', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7;', width:120, height:38}, colspan: 2},
						{ xtype: 'component', html:'<font color= "blue">(자동계산)</font>', tdAttrs: {style: 'border : 2px solid #ced9e7; ', width:95}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MANAGE_RESULT_REDU_I'},
						
						{ xtype: 'component', html:'&nbsp;중소기업핵심인력성과보상기금 ', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7;', width:120, height:38}, colspan: 2},
						{ xtype: 'component', html:'<font color= "blue">(자동계산)</font>', tdAttrs: {style: 'border : 2px solid #ced9e7; ', width:95}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'CORE_COMPEN_FUND_REDU_I'},
						
						{ xtype: 'component', html:'&nbsp;내국인우수인력국내복귀 ', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7;', width:120, height:48}, colspan: 2},
						{ xtype: 'component', html:'<font color= "blue">(자동계산)</font>', tdAttrs: {style: 'border : 2px solid #ced9e7; ', width:95}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETURN_WORKER_REDU_I'},
						
						{ xtype: 'component', html:'&nbsp;조세조약', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7;'}, colspan: 2},
						{ xtype: 'component', html:'감면세액', tdAttrs: {style: 'border : 2px solid #ced9e7;'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'TAXES_REDU_I', holdable:'hold'}

					],
					setCloseForm : function() {
						var fields = this.getForm().getFields();
						
						Ext.each(fields.items, function(item){
							if(item.isPopupField) {
								var fc = item.up('uniPopupField');
								if(fc.holdable == 'hold') {
									fc.setReadOnly(gbCloseYn);
								}
							}
							else {
								if(item.holdable == 'hold') {
									item.setReadOnly(gbCloseYn);
								}
							}
						});
					}
				},{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab10Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:4,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', colspan: 2, width:200},
						{ xtype: 'component', html:'정 산 금 액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 2px solid #ced9e7;  width: 100%'}, style:'width:100%;'},


						{ xtype: 'component', html:'세액<br/>감면', rowspan: 7, tdAttrs: {style: 'border : 2px solid #ced9e7;', width:50}},
						{ xtype: 'component', html:'&nbsp;소득세법', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7;', width:150}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'INCOME_REDU_I'},
						{ xtype: 'component', html:'우리나라에 파견된 외국인이 당사국의 정부로부터 받는 급여', style: 'text-align:left'},
					
						{ xtype: 'component', html:'&nbsp;외국인기술자', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7;'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SKILL_DED_I'},
						{ xtype: 'component', html:'외국인 기술자에 대한 소득세 면제', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;중소기업취업청년', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7;'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'YOUTH_DED_I'},
						{ xtype: 'component', html:'중소기업 취업 청년에 대한 소득세 감면 ', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;성과공유중소기업<br/>&nbsp;경영성과급', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7;', height:38}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MANAGE_RESULT_REDU_I'},
						{ xtype: 'component', html:'성과공유 중소기업에 종사하는 근로자가 수령하는 경영성과급 ', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;중소기업핵심인력<br/>&nbsp;성과보상기금 ', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7;', height:38}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'CORE_COMPEN_FUND_REDU_I'},
						{ xtype: 'component', html:'중소기업 핵심인력 성과보상기금에 가입한 중소기업의 근로자가 수령하는 공제금 중 기업이 부담한 기여금', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;내국인우수인력국내복귀 ', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7;', height:38}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETURN_WORKER_REDU_I'},
						{ xtype: 'component', html:'국내에 거주하면서 연구기관 등에 취업한 내국인 우수인력(이공계 박사학위 소지자로 국외 5년이상 거주하며 연구/기술개발)에 대한 소득세 감면', style: 'text-align:left'},

						{ xtype: 'uniNumberfield', value:'0', fieldLabel:'중소기업청년 감면기간내 총소득금액(감면소득)', hidden:true, name: 'YOUTH_DED_I_SUM'},

						
						{ xtype: 'component', html:'&nbsp;조세조약', style: 'text-align:left', tdAttrs: {style: 'border : 2px solid #ced9e7;'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'TAXES_REDU_I'},
						{ xtype: 'component', html:'조세조약의 교직자 조항으로 소득세 면제', style: 'text-align:left'}

					]
				}
			]
		}]
	});

	//세액공제-근로소득/자녀 탭
	var tab11 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab11',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		style : {'min-width':'1300px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [
				{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab11Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:2,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'component', html:'&nbsp;근로소득세액공제<font color= "blue">(자동계산)</font>', style: 'text-align:left', tdAttrs: {height: 40}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'IN_TAX_DED_I'},

						{ xtype: 'component', html:'&nbsp;자녀세액공제<font color= "blue">(자동계산)</font>', style: 'text-align:left;', tdAttrs: {height: 60}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'CHILD_TAX_DED_I'},

						{ xtype: 'component', html:'&nbsp;출산입양공제<font color= "blue">(자동계산)</font>', style: 'text-align:left', tdAttrs: {height: 40}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'BIRTH_ADOPT_I'}

					]
				},{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab11Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', tdAttrs: {height: 29}, width:200},
						{ xtype: 'component', html:'정 산 금 액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 100%'}},

						{ xtype: 'component', html:'&nbsp;근로소득세액공제', style: 'text-align:left', tdAttrs: {height: 40}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'IN_TAX_DED_I'},
						{ xtype: 'component', html:'근로소득자에 대해 그 근로소득에 대한 종합소득산출세액에서 해당하는 금액을 공제', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;자녀세액공제', style: 'text-align:left', tdAttrs: {height: 60}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'CHILD_TAX_DED_I'},
						{ xtype: 'component', html:'근로자의 기본공제대상자에 해당하는 자녀(입양자 및 위탁아동 포함)에 대해서 해당하는 금액을 근로소득에 대한 종합소득산출세액에서 공제', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;출산입양공제', style: 'text-align:left', tdAttrs: {height: 40}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'BIRTH_ADOPT_I'},
						{ xtype: 'component', html:'해당 과세기간에 출생입양신고한 경우 1명당 연30만원을 종합소득산출세액에서 공제', style: 'text-align:left'}
					]
				}

			]
		}]
	});

	//세액공제-연금계좌
	var tab12 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab12',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		xtype: 'container',
		flex: 1,
		style : {'min-width':'1300px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [
				{
					xtype:'uniDetailForm',
					disabled:false,
					id:'tab12Form400',
					padding:0,
					//tdAttrs:{width:650},
					tdAttrs:{width:590, style:'min-width:590px;', height:255},
					layout: {
						type: 'table',
						columns:4,
						tableAttrs: { style: 'width:590px; border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse; overflow: hidden;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%' /*, margin: '2 2 2 2'*/},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}, colspan: 2},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:150}},
						{ xtype: 'component', html:'50세이상', tdAttrs: {height: 29, width:70}},

						{ xtype: 'component', html:'연금</br>계좌', rowspan: 3, tdAttrs: {style: 'border : 1px solid #ced9e7;'}},
						{ xtype: 'button', text:'과학기술인공제세법에 따른 퇴직연금 입력', style: 'text-align:center', tdAttrs: {height:68}, width: '90%', itemId:'btnPension',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openPersonalPension("12");
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SCI_DEDUC_I', tdAttrs: {height:68}},
						{ xtype: 'fieldcontainer', defaultType: 'checkboxfield', readOnly:true, rowspan: 3,
							items: [
								{boxLabel: '', name: 'PENS_OVER_50_YN', readOnly:true, holdable:'hold'}
							]
						},

						{ xtype: 'button', text:'퇴직연금 입력', style: 'text-align:center',tdAttrs: {height:68}, width: '90%', itemId:'btnPension1',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openPersonalPension("11");
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETIRE_PENS_I', tdAttrs: {height:68}},

						{ xtype: 'button', text:'연금저축계좌 입력', style: 'text-align:center', tdAttrs: {height:68}, width: '90%', itemId:'btnPension2',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openPersonalPension("22");
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PENS_I', tdAttrs: {height:68}}

					]
				},{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab12Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:710px;padding-right:2px;', height:255},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						//{ xtype: 'component', html:'정 산 항 목', width:95},
						{ xtype: 'component', html:'공제대상금액', width:150},
						{ xtype: 'component', html:'세액공제액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 100%'}},

						//{ xtype: 'component', html:'&nbsp;과학기술인공제', style: 'text-align:left', rowspan: 2, tdAttrs: {height:76}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SCI_DEDUC_I', rowspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SCI_TAX_DED_I1',tdAttrs: {height:34}},
						{ xtype: 'component', html:'과학기술인공제회법에 따라 근로자가 부담하는 부담금(세액공제율15%)', style: 'text-align:left'},

						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SCI_TAX_DED_I',tdAttrs: {height:34}},
						{ xtype: 'component', html:'과학기술인공제회법에 따라 근로자가 부담하는 부담금(세액공제율12%)', style: 'text-align:left'},

						//{ xtype: 'component', html:'&nbsp;근로자퇴직급여<br/>&nbsp;보장법', style: 'text-align:left', rowspan: 2, tdAttrs: {height:76}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETIRE_PENS_I', rowspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETIRE_TAX_DED_I1',tdAttrs: {height:34}},
						{ xtype: 'component', html:'근로자퇴직급여보장법에 따라 근로자가 부담하는 부담금(세액공제율15%)', style: 'text-align:left'},

						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETIRE_TAX_DED_I',tdAttrs: {height:34}},
						{ xtype: 'component', html:'근로자퇴직급여보장법에 따라 근로자가 부담하는 부담금(세액공제율12%)', style: 'text-align:left'},

						//{ xtype: 'component', html:'&nbsp;연금저축계좌', style: 'text-align:left', rowspan: 2, tdAttrs: {height:76}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PENS_I', rowspan: 2},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PENS_TAX_DED_I1',tdAttrs: {height:34}},
						{ xtype: 'component', html:'근로자 본인 명의로 2001.1.1 이후에 가입하여 해당 과세기간에 납입한 금액(세액공제율15%)', style: 'text-align:left'},

						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PENS_TAX_DED_I',tdAttrs: {height:34}},
						{ xtype: 'component', html:'근로자 본인 명의로 2001.1.1 이후에 가입하여 해당 과세기간에 납입한 금액(세액공제율12%)', style: 'text-align:left'}
					]
				}
			]
		}]
	});

	//특별세액공제-보장성보험
	var tab13 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab13',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		style : {'min-width':'1300px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [
				{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab13Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:2,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'button', text:'보장성보험 입력', style: 'text-align:center', width: '90%', itemId:'btnFamily2',
							handler:function(){
							 if(panelResult.isValid())	{
								 UniAppManager.app.openFamily('I', panelResult);
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ETC_INSUR_I'},

						{ xtype: 'button', text:'장애인전용보장성보험 입력', style: 'text-align:center', width: '90%', tdAttrs:{height:40}, itemId:'btnFamily1',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openFamily('I', panelResult);
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						 },
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_INSUR_I'}

					]
				},{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab13Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:4,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{ margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', width:95},
						{ xtype: 'component', html:'공제대상금액', width:100},
						{ xtype: 'component', html:'세액공제액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 100%'}},

						{ xtype: 'component', html:'&nbsp;보장성보험', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ETC_INSUR_I', width:100},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ETC_INSUR_TAX_DED_I', width:150},
						{ xtype: 'component', html:'근로자가 지급한 기본공제대상자를 피보험자로 하는 보장성보험', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;장애인전용보험', style: 'text-align:left', tdAttrs:{height:40}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_INSUR_I', width:100},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_INSUR_TAX_DED_I', width:150},
						{ xtype: 'component', html:'기본공제대상자 중 장애인을 피보험자 또는 수익자로 하는 장애인전용보험', style: 'text-align:left'}
					]
				}
			]
		}]
	});

	//특별세액공제-의료비
	var tab14 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab14',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		style : {'min-width':'1300px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [
				{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab14Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}, colspan: 2},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{
							xtype: 'container',
							colspan: 3,
							tdAttrs : {align: 'left'},
							layout: {type: 'table', columns: 2},
							items:[
									{ xtype: 'button', text:'의료비제출대상 입력',width:250,  tdAttrs:{'align':'center',width:300}, itemId:'btnMed',
									  handler:function()	{
											 if(panelResult.isValid())	{
											  	UniAppManager.app.openMedDoc();
											 } else {
												 Unilite.messageBox("사원을 입력하세요.");
											 }
									  }
									},{
									  xtype: 'button', text:'의료비내역 입력',  width:250,  tdAttrs:{'align':'center',width:300}, margin: '0 2 0 0', itemId:'btnFamily1',
									  handler:function()	{
											 if(panelResult.isValid())	{
												 UniAppManager.app.openFamily('M', panelResult);
											 } else {
												 Unilite.messageBox("사원을 입력하세요.");
											 }
									 }
								}
								 ]
						},

						{ xtype: 'component', html:'&nbsp;①난임 시술비', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; ', width:280}},
						{ xtype: 'component', html:'지출액', tdAttrs: {style: 'border : 1px solid #ced9e7;', width:70}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SURGERY_MED_I'},

						{ xtype: 'component', html:'&nbsp;②본인,65세이상자,장애인,건강보험산정 특례자', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;', height:40}},
						{ xtype: 'component', html:'지출액', tdAttrs: {style: 'border : 1px solid #ced9e7;'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'BASE_MED_I'},

						{ xtype: 'component', html:'&nbsp;③그밖의 공제대상자 의료비', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;'}},
						{ xtype: 'component', html:'지출액', tdAttrs: {style: 'border : 1px solid #ced9e7;'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MED_TOTAL_I'}
					]
				},{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab14Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:4,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', width:95},
						{ xtype: 'component', html:'공제대상금액', width:100},
						{ xtype: 'component', html:'세액공제액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 100%'}},

						{ xtype: 'button', text:'의료비산출내역보기', style: 'text-align:center', width: 250, colspan: 3, tdAttrs : {align: 'center'}, hidden:true},
						{ xtype: 'component', html:'', hidden:true},

						{ xtype: 'component', html:'&nbsp;의료비공제금액', style: 'text-align:left', rowspan:4},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MED_DED_I', rowspan:4},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MED_TAX_DED_I', rowspan:4},
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:'난임 시술을 위하여 지급한 의료비', style: 'text-align:left'},

						{ xtype: 'component', html:'본인·65세이상인 자·장애인·건강보험산정특례자를 위하여 지출한 의료비', style: 'text-align:left', tdAttrs:{ height:40}},

						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(공제대상)본인의료비', hidden:true, name: 'MY_MED_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(공제대상)경로의료비', hidden:true, name: 'SENIOR_MED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(공제대상)장애의료비', hidden:true, name: 'DEFORM_MED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(공제대상)난임시술비', hidden:true, name: 'SURGERY_MED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(공제대상)그밖의 공제대상자 의료비', hidden:true, name: 'MED_TOTAL_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '본인의료비', hidden:true, name: 'MY_MED_TAX_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '경로의료비', hidden:true, name: 'SENIOR_MED_TAX_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '장애의료비', hidden:true, name: 'DEFORM_MED_TAX_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '난임시술비', hidden:true, name: 'SURGERY_MED_TAX_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '그밖의 공제대상자 의료비', hidden:true, name: 'MED_TOTAL_TAX_DED_I'},

						{ xtype: 'component', html:'위 이외의 기본공제대상자를 위하여 지급한 의료비', style: 'text-align:left'}
					]
				}
			]
		}]
	});

	//특별세액공제-교육비
	var tab15 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab15',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		trackResetOnLoad: true,
		style : {'min-width':'1300px'},
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [
				{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab15Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:4,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}, colspan: 3},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'button', text:'교육비내역 입력', style: 'text-align:center', width: '90%', colspan: 3, itemId:'btnFamily1',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openFamily('E', panelResult);

							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						},
						{ xtype: 'component', html:''},

						{ xtype: 'component', html:'&nbsp;근로소득자 본인 교육비 지출액', style: 'text-align:left', colspan: 3},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PER_EDUC_I'},

						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '본인교육비공제', hidden:true, name: 'PER_EDUC_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '대학교교육비공제', hidden:true, name: 'UNIV_EDUC_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '초중고교육비공제', hidden:true, name: 'STUD_EDUC_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '유치원교육비공제', hidden:true, name: 'KIND_EDUC_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '장애인특수교육비공제', hidden:true, name: 'DEFORM_EDUC_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '체험학습비공제', hidden:true, name: 'FIELD_EDUC_DED_I'},


						{ xtype: 'component', html:'부양가족교육비', rowspan: 3, tdAttrs: {style: 'border : 1px solid #ced9e7; ', width:150}},
						{ xtype: 'component', html:'&nbsp;대학생', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; ', width:100}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'UNIV_EDUC_NUM', margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7; ', align: 'right', width:100}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'UNIV_EDUC_I'},

						{ xtype: 'component', html:'&nbsp;초·중·고', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; '}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'STUD_EDUC_NUM', margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7;', align: 'right'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'STUD_EDUC_I'},

						{ xtype: 'component', html:'&nbsp;취학전아동', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; '}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'KIND_EDU_NUM', margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7;', align: 'right'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'KIND_EDUC_I'},

						{ xtype: 'component', html:'&nbsp;장애인 특수교육비 지출액', colspan: 3, tdAttrs:{height:40}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_EDUC_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '원', hidden:true, name: 'DEFORM_EDUC_NUM'},

						{ xtype: 'component', html:'&nbsp;체험학습비', colspan: 3, hidden:true},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'FIELD_EDUC_I', hidden:true}
					]
				},{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab15Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:6,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', colspan: 3, width:145},
						{ xtype: 'component', html:'공제대상금액', width:100},
						{ xtype: 'component', html:'세액공제액', width:100},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 100%'}},


						{ xtype: 'component', html:'', colspan: 3},
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:''},


						{ xtype: 'component', html:'교<br/>육<br/>비', rowspan: 6, tdAttrs: {style: 'border : 1px solid #ced9e7;', width:25}},
						{ xtype: 'component', html:'&nbsp;본인', style: 'text-align:left', colspan: 2, tdAttrs:{width:120}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PER_EDUC_DED_I', tdAttrs:{width:100},width:94},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PER_EDUC_TAX_DED_I', tdAttrs:{width:100},width:94},
						{ xtype: 'component', html:'공제한도:본인(전액)', style: 'text-align:left'},

						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(공제대상)교육비공제', hidden:true, name: 'EDUC_DED_I'},

						{ xtype: 'component', html:'&nbsp;대학생', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;', width:80}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'UNIV_EDUC_NUM', width: 40, margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7;', align: 'right'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'UNIV_EDUC_DED_I',width:94},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'UNIV_EDUC_TAX_DED_I',width:94},
						{ xtype: 'component', html:'공제한도:대학생(연900만원)', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;초·중·고', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; '}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'STUD_EDUC_NUM', width: 40, margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7; ', align: 'right'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'STUD_EDUC_DED_I',width:94},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'STUD_EDUC_TAX_DED_I',width:94},
						{ xtype: 'component', html:'공제한도:초·중·고(연300만원)', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;취학전아동', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'KIND_EDU_NUM', width: 40, margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7;', align: 'right'}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'KIND_EDUC_DED_I',width:94},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'KIND_EDUC_TAX_DED_I',width:94},
						{ xtype: 'component', html:'공제한도:취학전아동(연300만원)', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;장애인', style: 'text-align:left', colspan: 2, tdAttrs:{height:40}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_EDUC_DED_I',width:94},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_EDUC_TAX_DED_I',width:94},
						{ xtype: 'component', html:'장애인(소득의 제한을 받지 아니함)의 재활교육을 위하여 지급하는 교육비', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;체험학습비', style: 'text-align:left', colspan: 2, hidden:true},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'FIELD_EDUC_DED_I', hidden:true},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'FIELD_EDUC_TAX_DED_I', hidden:true},
						{ xtype: 'component', html:'공제한도:취학전아동+초중고(연30만원)', style: 'text-align:left', hidden:true}
					]
				}
			]
		}]
	});

	//특별세액공제-기부금
	var tab16 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab16',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		style : {'min-width':'1300px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'}},
			items: [
				{
					xtype:'uniDetailForm',
					disabled:false,
					id:'tab16Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}, colspan: 2},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'button', text:'기부금내역 입력', style: 'text-align:center', width: '90%', colspan: 2, tdAttrs : {align: 'center'}, itemId:'btnDonation',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openDonation();
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						},
						{ xtype: 'component', html:''},

						{ xtype: 'component', html:'&nbsp;정치자금기부금', rowspan: 2, style: 'text-align:left', tdAttrs: {width:200}},
						{ xtype: 'component', html:'10만원이하', tdAttrs: {width:150}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'POLICY_INDED'},

						{ xtype: 'component', html:'10만원초과'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'POLICY_GIFT_I'},

						{ xtype: 'component', html:'&nbsp;법정기부금', rowspan: 3, style: 'text-align:left'},
						{ xtype: 'component', html:'이월액(소득공제)'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'LEGAL_GIFT_I_PREV'},
						
						{ xtype: 'component', html:'이월액(세액공제)'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'LEGAL_GIFT_I_PREV_14'},

						{ xtype: 'component', html:'기부금액'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'LEGAL_GIFT_I'},

						{ xtype: 'component', html:'&nbsp;우리사주조합기부금', style: 'text-align:left'},
						{ xtype: 'component', html:'기부금액'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'STAFF_GIFT_I'},

						{ xtype: 'component', html:'&nbsp;지정기부금(종교단체외)', rowspan: 3, style: 'text-align:left'},
						{ xtype: 'component', html:'이월액(소득공제)'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'APPOINT_GIFT_I_PREV'},

						{ xtype: 'component', html:'이월액(세액공제)'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'APPOINT_GIFT_I_PREV_14'},

						{ xtype: 'component', html:'기부금액'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'APPOINT_GIFT_I'},

						{ xtype: 'component', html:'&nbsp;  종교단체기부금', rowspan: 3, style: 'text-align:left'},
						{ xtype: 'component', html:'이월액(소득공제)'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ASS_GIFT_I_PREV'},

						{ xtype: 'component', html:'이월액(세액공제)'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ASS_GIFT_I_PREV_14'},

						{ xtype: 'component', html:'기부금액'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ASS_GIFT_I'}
					]
				},{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab16Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', width:200},
						{ xtype: 'component', html:'세액공제액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 100%'}},

						{ xtype: 'button', text:'기부금산출내역보기', style: 'text-align:center', width: '60%', colspan: 2, tdAttrs : {align: 'left'}, hidden:true},
						{ xtype: 'component', html:'', hidden:true},

						{ xtype: 'component', html:'&nbsp;기부금공제금액', style: 'text-align:left', rowspan: 5, tdAttrs: { height: 348}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'GIFT_TAX_DED_I', rowspan: 5, tdAttrs: { height: 348}},
						{ xtype: 'component', html:''},

						{ xtype: 'component', html:'근로소득자가 정치자금법에 따라 정당에 기부한 정치자금', style: 'text-align:left', tdAttrs: { height: 58}},

						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)정치자금기부금(10만원미만)', hidden:true, name: 'POLICY_INDED'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)정치자금기부금(10만원초과)', hidden:true, name: 'POLICY_GIFT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)법정기부금이월-2013', hidden:true, name: 'LEGAL_GIFT_I_PREV'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '입력금액)법정기부금이월-2014', hidden:true, name: 'LEGAL_GIFT_I_PREV_14'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)법정기부금', hidden:true, name: 'LEGAL_GIFT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)특례기부금이월액', hidden:true, name: 'PRIV_GIFT_I_PREV'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)특례기부금', hidden:true, name: 'PRIV_GIFT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)공익법인신탁기부금이월액', hidden:true, name: 'PUBLIC_GIFT_I_PREV'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)공익법인신탁기부금', hidden:true, name: 'PUBLIC_GIFT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)우리사주기부금', hidden:true, name: 'STAFF_GIFT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)지정기부금이월액-2013', hidden:true, name: 'APPOINT_GIFT_I_PREV'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)지정기부금이월액-2014', hidden:true, name: 'APPOINT_GIFT_I_PREV_14'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)지정기부금', hidden:true, name: 'APPOINT_GIFT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)종교단체기부금이월액-2013', hidden:true, name: 'ASS_GIFT_I_PREV'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)종교단체기부금이월액-2014', hidden:true, name: 'ASS_GIFT_I_PREV_14'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)종교단체기부금', hidden:true, name: 'ASS_GIFT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(공제대상)정치자금기부금(10만원미만)', hidden:true, name: 'POLICY_INDED_DED_AMT'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(공제대상)정치자금기부금(10만원초과)', hidden:true, name: 'POLICY_GIFT_DED_AMT'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(공제대상)법정기부금', hidden:true, name: 'LEGAL_DED_AMT'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(공제대상)우리사주기부금', hidden:true, name: 'STAFF_DED_AMT'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(공제대상)지정기부금', hidden:true, name: 'APPOINT_ASS_TAX_DED_AMT'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(소득공제)기부금소득공제합계', hidden:true, name: 'GIFT_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(소득공제)법정기부금', hidden:true, name: 'LEGAL_GIFT_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(소득공제)특례기부금', hidden:true, name: 'PRIV_GIFT_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(소득공제)공익법인신탁기부금', hidden:true, name: 'PUBLIC_GIFT_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(소득공제)우리사주기부금', hidden:true, name: 'STAFF_GIFT_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(소득공제)지정기부금 ', hidden:true, name: 'APPOINT_GIFT_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(소득공제)종교단체기부금', hidden:true, name: 'ASS_GIFT_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(세액공제)정치자금기부금(10만원미만)', hidden:true, name: 'POLICY_INDED_TAX_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(세액공제)정치자금기부금(10만원초과)', hidden:true, name: 'POLICY_GIFT_TAX_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(세액공제)법정기부금 ', hidden:true, name: 'LEGAL_GIFT_TAX_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(세액공제)우리사주기부금', hidden:true, name: 'STAFF_GIFT_TAX_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(세액공제)지정기부금', hidden:true, name: 'APPOINT_GIFT_TAX_DED_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(세액공제)종교단체기부금', hidden:true, name: 'ASS_GIFT_TAX_DED_I'},

						{ xtype: 'component', html:'소득세법 제34조 제2항에서 규정하는 기부금', style: 'text-align:left', tdAttrs: { height: 87}},

						{ xtype: 'component', html:'우리사주조합원이 아닌 사람이 우리사주조합에 지출하는 기부금', style: 'text-align:left'},

						{ xtype: 'component', html:'소득세법 시행령 제80조에서 규정하는 기부금', style: 'text-align:left', tdAttrs: { height: 174}}
					]
				}
			]
		}]
	});

	//세액공제-기타
	var tab17 = Ext.create('Ext.container.Container',{
		id:'had620ukrTab17',
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		style : {'min-width':'1300px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			layout: {type: 'table', columns:2, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:255}},
			items: [
				{
					xtype:'uniDetailForm',
					disabled:false,
					id:'tab17Form400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29, width:350}, colspan: 2},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'component', html:'&nbsp;납세조합공제', style: 'text-align:left'},
						{ xtype: 'component', html:'공제세액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'P3_TAX_DED_I', holdable: 'hold'},

						{ xtype: 'component', html:'&nbsp;주택차입금', style: 'text-align:left'},
						{ xtype: 'component', html:'이자상환액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_INTER_I', holdable: 'hold'},

						{ xtype: 'component', html:'&nbsp;외국납부', rowspan: 2, style: 'text-align:left'},
						{ xtype: 'component', html:'소득금액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'FORE_INCOME_I', holdable: 'hold'},

						{ xtype: 'component', html:'납부세액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'FORE_TAX_I', holdable: 'hold'},

						{ xtype: 'button', text:'월세납부내역 입력', width: '90%', colspan: 2, tdAttrs : {align: 'center'}, itemId:'btnRent',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openRent();
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MON_RENT_I'}
					],
					setCloseForm : function() {
						var fields = this.getForm().getFields();
						
						Ext.each(fields.items, function(item){
							if(item.isPopupField) {
								var fc = item.up('uniPopupField');
								if(fc.holdable == 'hold') {
									fc.setReadOnly(gbCloseYn);
								}
							}
							else {
								if(item.holdable == 'hold') {
									item.setReadOnly(gbCloseYn);
								}
							}
						});
					}
				},{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'tab17Form600',
					padding:0,
					tdAttrs:{width:'100%', style:'min-width:750px;padding-right:20px;', height:255},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', width:200},
						{ xtype: 'component', html:'정 산 금 액', width:150},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 100%'}},

						{ xtype: 'component', html:'&nbsp;납세조합공제', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'NAP_TAX_DED_I'},
						{ xtype: 'component', html:'납세조합에 의하여 원천징수된 근로소득에 대한 공제', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;주택차입금', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_INTER_I'},
						{ xtype: 'component', html:'국민주택기금으로부터 차입한 대출금의 이자상환액', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;외국납부', style: 'text-align:left', tdAttrs:{height:58}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'OUTSIDE_INCOME_I'},
						{ xtype: 'component', html:'외국소득세액을 해당 과세기간의 종합소득산출세액에서 공제', style: 'text-align:left'},

						{ xtype: 'component', html:'&nbsp;월세액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MON_RENT_I'},
						{ xtype: 'component', html:'국민주택규모의 주택을 임차하기 위해 지출한 월세액', style: 'text-align:left'}
					]
				}
			]
		}]
	});
	//세액산출요약
	var tab18 = Unilite.createSearchForm('tab18Form600',{
		scrollable: true,
		border: false,
		padding: '5 7 0 7',
		flex: 1,
		style : {'min-width':'1630px'},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			autoScroll: true,
			xtype: 'container',
			layout: {type: 'table', columns:1, tdAttrs:{style:'vertical-align:top;height:100%;'},tableAttrs:{height:260}},
			items: [{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 11, tableAttrs:{border:0}},
				defaults: {labelWidth: 110},
				items: [{
					xtype: 'uniNumberfield',
					fieldLabel: '총급여액',
					name: 'INCOME_SUPP_TOTAL_I',
					value: 0,
					labelWidth: 80,
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'component',
					html: '→',
					tdAttrs: {align:'center', width:40, style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '근로소득금액',
					name: 'EARN_INCOME_I',
					value: 0,
					labelWidth: 80,
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'component',
					html: '→',
					tdAttrs: {align:'center', width:40,style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '소득과세표준',
					name: 'TAX_STD_I',
					value: 0,
					labelWidth: 80,
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '소득과세표준(표준세액공제계산용):특별소득공제포함',
					name: 'TAX_STD_I1',
					value: 0,
					hidden: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '소득과세표준(표준세액공제계산용):특별소득공제제외',
					name: 'TAX_STD_I2',
					value: 0,
					hidden: true
				},{
					xtype: 'component',
					html: '→',
					tdAttrs: {align:'center', width:40,style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '산출세액',
					name: 'COMP_TAX_I',
					value: 0,
					labelWidth: 80,
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '산출세액(표준세액공제계산용):특별소득공제포함',
					name: 'COMP_TAX_I1',
					value: 0,
					hidden: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '산출세액(표준세액공제계산용):특별소득공제제외',
					name: 'COMP_TAX_I2',
					value: 0,
					hidden: true
				},{
					xtype: 'component',
					html: '→',
					tdAttrs: {align:'center', width:40,style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '결정세액',
					name: 'DEF_TAX_SUM',
					value: 0,
					labelWidth: 80,
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'component',
					html: '→',
					tdAttrs: {align:'center', width:40,style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '차감징수세액',
					name: 'TAX_SUM',
					value: 0,
					labelWidth: 80,
					suffixTpl: '원', readOnly: true
				}]
			},{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 5, tableAttrs:{border:0, width:1610}, tdAttrs:{align:'right'}},

				items: [{
					xtype: 'component',
					html: '<div style="margin-left:250px;">↑</div>',
					tdAttrs: {align:'left', width:420, style: 'margin:200px;border : 0px solid #ced9e7; '}
				},{
					xtype: 'component',
					html: '<div style="margin-left:125px;">↑</div>',
					tdAttrs: {align:'left', width:250,style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'component',
					html: '<div style="margin-left:152px;">↑</div>',
					tdAttrs: {align:'left',width:300 ,style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'component',
					html: '<div style="margin-left:136px;">↑</div>',
					tdAttrs: {align:'left',style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'component',
					html: '<div style="margin-left:176px;">↑</div>',
					tdAttrs: {align:'left', width:450,style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>근로소득공제',
					name: 'INCOME_DED_I',
					value: 0,
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>기본공제&nbsp;',
					name: 'TAB1_DED_AMT',
					value: 0,
					labelWidth:80,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'component',
					html: '<font color= "red">(*)</font>세율',
					tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>세액감면&nbsp;',
					name: 'TAB10_DED_AMT',
					value: 0,
					labelWidth:80,
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>현근무지기납부세액&nbsp;',
					labelWidth: 150,
					name: 'NOW_TAX_SUM',
					value: 0,
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>추가공제&nbsp;',
					name: 'TAB2_DED_AMT',
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>세액공제-근로소득/자녀&nbsp;',
					name: 'TAB11_DED_AMT',
					value: 0,
					colspan:2,
					labelWidth: 180,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>종전근무지결정세액&nbsp;',
					name: 'PRE_TAX_SUM',
					labelWidth: 150,
					value: 0,
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>특별소득공제-보험료&nbsp;',
					name: 'TAB4_DED_AMT',
					labelWidth: 150,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>특별세액공제-보장성보험&nbsp;',
					name: 'TAB13_DED_AMT',
					value: 0,
					labelWidth: 180,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>납세조합결정세액&nbsp;',
					name: 'NAP_TAX_SUM',
					labelWidth: 150,
					value: 0,
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>특별소득공제-주택자금&nbsp;',
					name: 'TAB5_DED_AMT',
					labelWidth: 150,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>특별세액공제-의료비&nbsp;',
					name: 'TAB14_DED_AMT',
					labelWidth: 150,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '기납부세액합계&nbsp;',
					name: 'PAID_TAX_SUM',
					labelWidth: 150,
					value: 0,
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>특별소득공제-기부금&nbsp;',
					name: 'GIFT_DED_I',
					labelWidth: 150,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>특별세액공제-교육비&nbsp;',
					name: 'TAB15_DED_AMT',
					labelWidth: 150,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'component',
					html: '&nbsp;',
					tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>차감소득금액&nbsp;',
					name: 'DED_INCOME_I',
					labelWidth: 150,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '차감근로소득(표준세액공제계산용):특별소득공제포함 ',
					name: 'DED_INCOME_I1',
					value: 0,
					hidden: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '차감근로소득(표준세액공제계산용):특별소득공제제외 ',
					name: 'DED_INCOME_I2',
					value: 0,
					hidden: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>특별세액공제-기부금&nbsp;',
					name: 'TAB16_DED_AMT',
					labelWidth: 150,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'component',
					html: '&nbsp;',
					tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>그밖의소득공제-연금저축&nbsp;',
					name: 'TAB6_DED_AMT',
					labelWidth: 180,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>표준세액공제&nbsp;',
					name: 'STD_TAX_DED_I',
					labelWidth: 150,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'component',
					html: '&nbsp;',
					tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>그밖의소득공제-주택마련&nbsp;',
					name: 'TAB7_DED_AMT',
					labelWidth: 180,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>세액공제-기타&nbsp;',
					name: 'TAB17_DED_AMT',
					labelWidth: 150,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'component',
					html: '&nbsp;',
					tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>그밖의소득공제-신용카드&nbsp;',
					name: 'TAB8_DED_AMT',
					labelWidth: 180,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>세액공제-연금계좌&nbsp;',
					name: 'TAB12_DED_AMT',
					labelWidth: 150,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'component',
					html: '&nbsp;',
					tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>그밖의소득공제-기타&nbsp;',
					name: 'TAB9_DED_AMT',
					labelWidth: 150,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'component',
					html: '&nbsp;',
					tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; '},
					colspan:2
				},{
					xtype: 'component',
					html: '&nbsp;',
					tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(-)</font>연금보험료공제&nbsp;',
					name: 'TAB3_DED_AMT',
					labelWidth: 150,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'component',
					html: '&nbsp;',
					tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; '},
					colspan:2
				},{
					xtype: 'component',
					html: '&nbsp;',
					tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; '}
				},{
					xtype: 'uniNumberfield',
					fieldLabel: '<font color= "red">(+)</font>특별공제 종합한도 초과액&nbsp;',
					name: 'OVER_INCOME_DED_LMT',
					labelWidth: 180,
					value: 0,
					colspan:2,
					tdAttrs:{align:'right'},
					suffixTpl: '원', readOnly: true
				},{
					xtype: 'component',
					html: '&nbsp;',
					tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; '},
					colspan:2
				},{
					xtype: 'component',
					html: '&nbsp;',
					tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; '}
				}]
			}]
		}],
		listeners: {
			actioncomplete: function(form, action) {
				// dirty change 이벤트 , load 후
				tab1.getForm().on({
					dirtychange: function(form, dirty, eOpts) {
						if (dirty) {
							UniAppManager.app.setToolbarButtons('save', true);
						} else {
							UniAppManager.app.setToolbarButtons('save', false);
						}
					}
				});
			}
		}
	});

	var search2 = Unilite.createSearchForm('search2',{
		autoScroll: true,
		border: false,
		padding: '5 7 0 7',
		xtype: 'container',
		 flex: 1,
		api: {
			load: 'had620ukrService.selectFormData02'
		},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{
			xtype: 'container',
			margin: '10 0 0 0',
			layout: {
				type: 'table',
				columns:6,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7; ', align : 'center'}
			},
			defaults:{width: '98.5%', margin: '2 2 2 2'},
			items: [
				{ xtype: 'component',  html:'2015.12.31 이전 계산 내역', colspan: 6, tdAttrs: {height: 29}},

				{ xtype: 'component',  html:'과세내역', colspan: 2, tdAttrs: {height: 29}},
				{ xtype: 'component',  html:'법정퇴직'},
				{ xtype: 'component',  html:'산출산식', colspan: 3 },

				{ xtype: 'component',  html:'퇴직급여액', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'A'},
				{ xtype: 'component',  html:'퇴직급여액 과세소득', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'퇴직소득공제', rowspan: 6, tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 15%', align : 'center'}},
				{ xtype: 'component',  html:'소득공제(ⓐ)', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 15%', align : 'center'}},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'B', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 15%', align : 'center'}},
				{ xtype: 'component',  html:'2011년 귀속부터 퇴직급여액의 40%', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'근속연수별공제(ⓑ)', rowspan: 4},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'C'},
				{ xtype: 'component',  html:'&nbsp;5년이하', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 10%', align : 'center'}},
				{ xtype: 'component',  html:'&nbsp;30만 * 근속연수', colspan: 2, style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 30%', align : 'center'}},

				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'D'},
				{ xtype: 'component',  html:'&nbsp;10년이하', style: 'text-align:left'},
				{ xtype: 'component',  html:'&nbsp;150만 + {50만 * (근속연수 - 5)}', colspan: 2, style: 'text-align:left'},

				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'E'},
				{ xtype: 'component',  html:'&nbsp;20년이하', style: 'text-align:left'},
				{ xtype: 'component',  html:'&nbsp;400만 + {80만 * (근속연수 - 10)}', colspan: 2, style: 'text-align:left'},

				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'F'},
				{ xtype: 'component',  html:'&nbsp;20년초과', style: 'text-align:left'},
				{ xtype: 'component',  html:'&nbsp;1,200만 + {120만 * (근속연수 - 20)}', colspan: 2, style: 'text-align:left'},

				{ xtype: 'component',  html:'계 ((ⓐ) + (ⓑ))'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'G'},
				{ xtype: 'component',  html:'소득공제(ⓐ) + 근속연수별공제(ⓑ)', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'과세표준', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'H'},
				{ xtype: 'component',  html:'퇴직급여액 - 퇴직소득공제', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'연평균과세표준', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'I'},
				{ xtype: 'component',  html:'과세표준 / 세법상근속연수', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'연평균산출세액', rowspan: 5},
				{ xtype: 'component',  html:'1천 2백만원 이하'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'J'},
				{ xtype: 'component',  html:'6%', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'4천 6백만원 이하'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'K'},
				{ xtype: 'component',  html:'72만 + {(연평균과세표준 - 1,200만) * 15%}', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'8천 6백만원 이하'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'L'},
				{ xtype: 'component',  html:'582만 + {(연평균과세표준 - 4,600만) * 24%}', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'3억 이하'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'M'},
				{ xtype: 'component',  html:'1,590만 + {(연평균과세표준 - 8,800만) * 35%}', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'3억 초과'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'N'},
				{ xtype: 'component',  html:'9,010만 + {(연평균과세표준 - 3억) * 38%}', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'산출세액', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'O'},
				{ xtype: 'component',  html:'연평균산출세액 * 세법상근속연수', colspan: 3, style: 'text-align:left'},


				{ xtype: 'component',  html:'2016.01.01 이후 계산 내역 == 퇴직급여액, 근속연수별공제 금액은 2015.12.31 이전 계산내역 참조', colspan: 6, tdAttrs: {height: 29}},

				{ xtype: 'component',  html:'환산급여', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'P'},
				{ xtype: 'component',  html:'((정산퇴직소득 - 근속연수공제) / 정산근속연수) * 12배', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'환산급여별공제', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'Q'},
				{ xtype: 'component',  html:'환산급여별공제 프로그램에서 내용 확인 : 기준금액 + ((환산급여 - 기준금액) * 세율)', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'퇴직소득과세표준', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'R'},
				{ xtype: 'component',  html:'환산급여 - 환산급여별공제', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'환산산출세액', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'S'},
				{ xtype: 'component',  html:'퇴직소득과세표준 * 종합소득세율', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'산출세액', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'T'},
				{ xtype: 'component',  html:'(환산산출세액 / 12배) * 정산근속연수', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'특례적용산출세액', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'V'},
				{ xtype: 'component',  html:'(2015.12.31 이전의 산출세액 * 80%) + (2016.01.01 이후 산출세액 * 20%)', colspan: 3, style: 'text-align:left'},

				{ xtype: 'component',  html:'신고대상액', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'W'},
				{ xtype: 'component',  html:'특례적용산출세액 - 기납부(또는 기과세이연) 세액 == 소득세', colspan: 3, style: 'text-align:left'}
			]
		}]
	});

	var southForm = Unilite.createForm('southForm600', {
		region: 'south',
		disabled:false,
		layout: {type: 'uniTable', columns:5},
		items:[{
			 xtype: 'container',
			 html:'<b>■ 결정세액 및 차감징수세액</b>',
			 tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 13px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'left'},
			 colspan: 5,
			 margin: '13 0 0 6'
		}, {
			xtype: 'container',
			margin: '5 0 0 0',
			padding: '5 7 20 7',
			layout: {
				type: 'table',
				columns:5,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7;  width: 10%;', align : 'center'}
			},
			defaults:{width: '98.5%', margin: '2 2 2 2'},
			items: [
				{ xtype: 'component', html:'구 분', tdAttrs: {height: 29}},
				{ xtype: 'component', html:'소득세'},
				{ xtype: 'component', html:'지방소득세'},
				{ xtype: 'component', html:'농어촌특별세'},
				{ xtype: 'component', html:'합 계'},

				{ xtype: 'component',  html:'&nbsp;결정세액', style: 'text-align:left'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEF_IN_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEF_LOCAL_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEF_SP_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEF_TAX_SUM'},

				{ xtype: 'component',  html:'&nbsp;기납부세액', style: 'text-align:left'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PAID_IN_TAX_SUM'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PAID_LOCAL_TAX_SUM'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PAID_SP_TAX_SUM'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PAID_TAX_SUM'},

				{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)소득세', hidden:true, name: 'NOW_IN_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)주민세', hidden:true, name: 'NOW_LOCAL_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)농특세', hidden:true, name: 'NOW_SP_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)소득세 ', hidden:true, name: 'PRE_IN_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)주민세 ', hidden:true, name: 'PRE_LOCAL_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)농특세', hidden:true, name: 'PRE_SP_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(납)소득세', hidden:true, name: 'NAP_IN_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(납)주민세', hidden:true, name: 'NAP_LOCAL_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(납)농특세 ', hidden:true, name: 'NAP_SP_TAX_I'},


				{ xtype: 'component',  html:'&nbsp;차감징수세액', style: 'text-align:left'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'IN_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'LOCAL_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SP_TAX_I'},
				{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'TAX_SUM'}
			]
		}]
	});


	var northForm = Ext.create('Ext.panel.Panel', {
		region: 'north',
		id : 'northForm',
		scrollable:true,
		layout: {type: 'uniTable', columns:1, tableAttrs:{border :0, style:'width:100%'}},
		items:[{
			xtype: 'uniDetailForm',
			id:'infoForm400',
			disabled:false,
			tdAttrs:{style:'width:100%;'},
			layout: {type: 'uniTable', columns: 5, tableAttrs:{width:1250}},
			items:[{
				 xtype: 'container',
				 html:'<b>■ 기본사항</b>',
				 tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 13px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'left'},
				 width: 150,
				 margin: '0 0 0 6'
			},{
				fieldLabel: '세대주여부',
				xtype: 'checkbox',
				boxLabel: '',
				name: 'HOUSEHOLDER_YN',
				width: 150,
				readOnly:true,
				inputValue: true
			},{
				fieldLabel: '세액감면기간',
				xtype: 'uniDateRangefield',
				startFieldName: 'NONTAX_FR',
				endFieldName: 'NONTAX_TO',
				width:315,
				holdable: 'hold'
			},{
				fieldLabel: '외국법인소속 파견근로자',
				xtype: 'checkbox',
				labelWidth: 200,
				boxLabel: '',
				name: 'FOREIGN_DISPATCH_YN',
				width: 250,
 				readOnly:true,
				inputValue: true,
				hidden:true
			},{
				fieldLabel: '외국인단일세율',
				xtype: 'checkbox',
				boxLabel: '',
				name: 'FORE_SINGLE_YN',
				labelWidth: 150,
 				readOnly:false,
				inputValue: true,
				holdable: 'hold',
				listeners:{
					change:function(field, newValue, oldValue)	{
						var record = direct400Store.getAt(0);
						
						if(record)	{
							if(nationCode == "")	{
								var param ={ 'PERSON_NUMB' : record.get("PERSON_NUMB")};
								Ext.getBody().mask();
								hum100ukrService.select(param, function(responseText) {
									Ext.getBody().unmask();
									if(responseText)	{
										nationCode = responseText.data.NATION_CODE;
										if( nationCode == 'KR')	{
											if(newValue)	{
												Unilite.messageBox("대한민국 국적인 경우는 외국인단일세율을 적용할 수 없습니다.");
												Ext.getCmp("infoForm400").getField("FORE_SINGLE_YN").setValue(oldValue);
											} else {
												record.set("FORE_SINGLE_YN", newValue);
											}
										}else {
											record.set("FORE_SINGLE_YN", newValue);
										}
									}
								});
								return false;
							} else {
								if(nationCode == "KR"  && newValue) {
									setTimeout(function(){Ext.getCmp("infoForm400").getField("FORE_SINGLE_YN").setValue(oldValue)}, 100);
									Unilite.messageBox("대한민국 국적인 경우는 외국인단일세율을 적용할 수 없습니다.");
									return false;
								} else {
									record.set("FORE_SINGLE_YN", newValue);
									return true;
								}
								return false;
							} 
							
						}
					}
				}
			},{
				fieldLabel: '중도퇴사자정산',
				xtype: 'checkbox',
				name: 'HALFWAY_TYPE',
				labelWidth: 150,
				readOnly:true,
				inputValue: true
			}],
			setCloseForm : function() {
				var fields = this.getForm().getFields();
				
				Ext.each(fields.items, function(item){
					if(item.isPopupField) {
						var fc = item.up('uniPopupField');
						if(fc.holdable == 'hold') {
							fc.setReadOnly(gbCloseYn);
						}
					}
					else {
						if(item.holdable == 'hold') {
							item.setReadOnly(gbCloseYn);
						}
					}
				});
			}
		}, {
			xtype: 'container',
			margin: '5 0 0 0',
			padding: '5 7 20 7',
			layout: {
				type: 'table',
				columns:2
			},
			tdAttrs:{style : {'min-width':'1300px;width:100%;'}},
			style : {'min-width':'1300px;width:100%;'},
			items: [
				{
					xtype:'uniDetailForm',
					 disabled:false,
					id:'baseForm400',
					padding:0,
					tdAttrs:{width:550},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { width: 550, style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 0px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{width: '97.5%', margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'입력할 항목', colspan: 2, tdAttrs: {height: 29, width:350}},
						{ xtype: 'component', html:'선택 또는 입력', tdAttrs: {height: 29, width:200}},

						{ xtype: 'component', html:'&nbsp;총급여액', style: 'text-align:left;width:150px;', tdAttrs: { width:150}},
						{ xtype: 'component', html:'<font color= "blue">&nbsp;(자동집계)</font>', style: 'text-align:left;width:200px;', tdAttrs: { width:200}},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'INCOME_SUPP_TOTAL_I'},

						{ xtype: 'button', text:'년간근로소득/기타소득입력', style: 'text-align:center', colspan: 2, width: '70%', itemId: 'btnYearIncome',
						 handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openYearIncome();
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						 }
						},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'NOW_PAY_AMT'},

						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)급여총액', hidden:true, name: 'NOW_PAY_TOT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)상여총액', hidden:true, name: 'NOW_BONUS_TOTAL_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)인정상여금액', hidden:true, name: 'NOW_ADD_BONUS_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)주식매수선택행사이익', hidden:true, name: 'NOW_STOCK_PROFIT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)우리사주조합인출금', hidden:true, name: 'NOW_OWNER_STOCK_DRAW_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)임원퇴직한도초과액', hidden:true, name: 'NOW_OF_RETR_OVER_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)직무발명보상금과세분', hidden:true, name: 'NOW_TAX_INVENTION_I'},

						{ xtype: 'button', text:'종(전)근무지내역 입력', style: 'text-align:center', colspan: 2, width: '70%', itemId: 'btnPrevCompany',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openPrevCompany();
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }
						},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'OLD_PAY_AMT'},

						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)급여총액', hidden:true, name: 'OLD_PAY_TOT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)상여총액', hidden:true, name: 'OLD_BONUS_TOTAL_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)인정상여금액', hidden:true, name: 'OLD_ADD_BONUS_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)주식매수선택행사이익', hidden:true, name: 'OLD_STOCK_PROFIT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)우리사주조합인출금', hidden:true, name: 'OLD_OWNER_STOCK_DRAW_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)임원퇴직한도초과액', hidden:true, name: 'OLD_OF_RETR_OVER_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)직무발명보상금과세', hidden:true, name: 'OLD_TAX_INVENTION_I'},

						{ xtype: 'button', text:'납세조합내역 입력', style: 'text-align:center', colspan: 2, width: '70%', itemId: 'btnTaxCommunity',
						  handler:function()	{
							 if(panelResult.isValid())	{
								 UniAppManager.app.openTaxCommunity();
							 } else {
								 Unilite.messageBox("사원을 입력하세요.");
							 }
						  }

						},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'NAP_PAY_AMT'},

						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(납)급여총액', hidden:true, name: 'NAP_PAY_TOT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(납)상여총액', hidden:true, name: 'NAP_BONUS_TOTAL_I'},

						{ xtype: 'component', html:'&nbsp;근로소득공제', style: 'text-align:left'},
						{ xtype: 'component', html:'<font color= "blue">&nbsp;(자동계산)</font>', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'INCOME_DED_I'},

						{ xtype: 'component', html:'&nbsp;근로소득금액', style: 'text-align:left'},
						{ xtype: 'component', html:'<font color= "blue">&nbsp;(자동계산)</font>', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'EARN_INCOME_I'}
					]
				},{
					xtype:'uniDetailForm',
					 disabled:false,
					scrollable:false,
					id:'baseForm600',
					padding:0,
					tdAttrs:{style:'width:100%;min-width:700px;padding-right:20px;'},
					layout: {
						type: 'table',
						columns:3,
						tableAttrs: { style: 'width:100%;border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px;border-collapse: collapse;'},
						tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 2px 2px 2px 2px; ', height: 29, align : 'center'}
					},
					defaults:{ margin: '2 2 2 2'},
					items:[
						{ xtype: 'component', html:'정 산 항 목', tdAttrs:{width:200}, style:'width:200px;'},
						{ xtype: 'component', html:'정 산 금 액', tdAttrs:{width:150}, style:'width:150px;'},
						{ xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs:{style:'min-width:350px;width:100%;'}, style:'min-width:350px;width:100%;'},

						{ xtype: 'component', html:'&nbsp;과세대상금액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'INCOME_SUPP_TOTAL_I', width:150},
						{ xtype: 'component', html:'&nbsp;연간근로소득에서 비과세소득을 뺀 금액', style: 'text-align:left;min-width:350px;'},

						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '급여총액', hidden:true, name: 'PAY_TOTAL_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '상여총액', hidden:true, name: 'BONUS_TOTAL_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '인정상여금액(', hidden:true, name: 'ADD_BONUS_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주식매수선택행사이익', hidden:true, name: 'STOCK_PROFIT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '우리사주조합인출금', hidden:true, name: 'OWNER_STOCK_DRAW_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '임원퇴직한도초과액', hidden:true, name: 'OF_RETR_OVER_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '직무발명보상금과세', hidden:true, name: 'TAX_INVENTION_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)급여총액', hidden:true, name: 'NOW_PAY_TOT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)상여총액', hidden:true, name: 'NOW_BONUS_TOTAL_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)인정상여금액', hidden:true, name: 'NOW_ADD_BONUS_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)주식매수선택행사이익', hidden:true, name: 'NOW_STOCK_PROFIT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)우리사주조합인출금', hidden:true, name: 'NOW_OWNER_STOCK_DRAW_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)임원퇴직한도초과액', hidden:true, name: 'NOW_OF_RETR_OVER_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)직무발명보상금과세분', hidden:true, name: 'NOW_TAX_INVENTION_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)급여총액', hidden:true, name: 'OLD_PAY_TOT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)상여총액', hidden:true, name: 'OLD_BONUS_TOTAL_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)인정상여금액', hidden:true, name: 'OLD_ADD_BONUS_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)주식매수선택행사이익', hidden:true, name: 'OLD_STOCK_PROFIT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)우리사주조합인출금', hidden:true, name: 'OLD_OWNER_STOCK_DRAW_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)임원퇴직한도초과액', hidden:true, name: 'OLD_OF_RETR_OVER_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)직무발명보상금과세', hidden:true, name: 'OLD_TAX_INVENTION_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(납)급여총액', hidden:true, name: 'NAP_PAY_TOT_I'},
						{ xtype: 'uniNumberfield', value:'0', fieldLabel: '(납)상여총액', hidden:true, name: 'NAP_BONUS_TOTAL_I'},


						{ xtype: 'component', html:''},
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:'&nbsp;주(현)근무지의 년간근로소득내역 조회/기타소득내역 입력', style: 'text-align:left;min-width:350px;'},

						{ xtype: 'component', html:''},
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:'&nbsp;종(전)근무지의 소득내역 및 납부세액내역 입력', style: 'text-align:left;min-width:350px;'},

						{ xtype: 'component', html:''},
						{ xtype: 'component', html:''},
						{ xtype: 'component', html:'&nbsp;납세조합의 소득내역 및 납부세액내역 입력', style: 'text-align:left;min-width:350px;'},

						{ xtype: 'component', html:'&nbsp;근로소득공제', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'INCOME_DED_I'},
						{ xtype: 'component', html:'&nbsp;총급여액에서 일정금액을 공제한 금액', style: 'text-align:left;min-width:350px;'},

						{ xtype: 'component', html:'&nbsp;근로소득금액', style: 'text-align:left'},
						{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'EARN_INCOME_I'},
						{ xtype: 'component', html:'&nbsp;총급여액에서 근로소득공제를 뺀 금액', style: 'text-align:left;min-width:350px;'}

					]
				}
			]
		}]
	});

	var tab = Unilite.createTabPanel('tabPanel',{
		region: 'center',
		activeTab: 0,
		id: 'tab',
		plugins:[{
			ptype: 'uniTabscrollermenu',
			maxText  : 20,
			pageSize : 20
		}],
		items: [{
			 title: '기본'	//	기본공제
			 ,id: 'had620ukrTab01'
			 ,scrollable: true
			 ,items:[tab1]
		},{
			 title: '추가'	//	추가공제
			 ,id: 'had620ukrTab02'
			 ,autoScroll: true
			 ,items:[tab2]
		},{
			 title: '연금보험'	//	연금보험료공제
			 ,id: 'had620ukrTab03'
			 ,autoScroll: true
			 ,items:[tab3]
		},{
			 title: '건강고용보험'	//	특별소득공제-보험료
			 ,id: 'had620ukrTab04'
			 ,autoScroll: true
			 ,items:[tab4]
		},{
			 title: '주택자금'	//	특별소득공제-주택자금
			 ,id: 'had620ukrTab05'
			 ,autoScroll: true
			 ,items:[tab5]
		},{
			 title: '연금저축'	//	그밖소득공제-연금저축
			 ,id: 'had620ukrTab06'
			 ,autoScroll: true
			 ,items:[tab6]
		},{
			 title: '주택마련'	//	그밖소득공제-주택마련
			 ,id: 'had620ukrTab07'
			 ,autoScroll: true
			 ,items:[tab7]
		},{
			 title: '신용카드'	//	그밖소득공제-신용카드
			 ,id: 'had620ukrTab08'
			 ,autoScroll: true
			 ,items:[tab8]
		},{
			 title: '기타소득'	//	그밖소득공제-기타
			 ,id: 'had620ukrTab09'
			 ,autoScroll: true
			 ,items:[tab9]
		},{
			 title: '세액감면'	//	세액감면
			 ,autoScroll: true
			 ,items:[tab10]
		},{
			 title: '근로자녀세액'		//	세액공제-근로소득/자녀
			 ,autoScroll: true
			 ,items:[tab11]
		},{
			 title: '연금계좌'	//	세액공제-연금계좌
			 ,autoScroll: true
			 ,items:[tab12]
		},{
			 title: '보장성보험'		//	특별세액공제-보장성보험
			 ,autoScroll: true
			 ,items:[tab13]
		},{
			 title: '의료비'	//	특별세액공제-의료비
			 ,autoScroll: true
			 ,items:[tab14]
		},{
			 title: '교육비'	//	특별세액공제-교육비
			 ,autoScroll: true
			 ,items:[tab15]
		},{
			 title: '기부금'	//	특별세액공제-기부금
			 ,autoScroll: true
			 ,items:[tab16]
		},{
			 title: '월세(기타)'	//	세액공제-기타
			 ,autoScroll: true
			 ,items:[tab17]
		},{
			 title: '요약'	//	세액산출요약
			 ,autoScroll: true
			 ,items:[tab18]
		}],
		listeners:{
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts ){

			}
		}
	});

	var grid = Unilite.createGrid('test', {
		layout : 'fit',
		region:'north',
		store: direct600Store,
		columns:[
			  {dataIndex	:'PERSON_NUMB'				  }
			, {dataIndex	:'JOIN_DATE'					}
			, {dataIndex	:'RETR_DATE'					}
			, {dataIndex	:'DEPT_CODE'					}
			, {dataIndex	:'DEPT_NAME'					}
			, {dataIndex	:'YEAR_YYYY'					}
			, {dataIndex	:'HALFWAY_TYPE'				 }
			, {dataIndex	:'FORE_SINGLE_YN'			}
			, {dataIndex	:'FOREIGN_DISPATCH_YN'		  }
			, {dataIndex	:'HOUSEHOLDER_YN'			}
			, {dataIndex	:'INCOME_SUPP_TOTAL_I'		  }
			, {dataIndex	:'PAY_TOTAL_I'				  }
			, {dataIndex	:'BONUS_TOTAL_I'				}
			, {dataIndex	:'ADD_BONUS_I'					}
			, {dataIndex	:'STOCK_PROFIT_I'			}
			, {dataIndex	:'OWNER_STOCK_DRAW_I'		}
			, {dataIndex	:'OF_RETR_OVER_I'				}
			, {dataIndex	:'TAX_INVENTION_I'				}
			, {dataIndex	:'NOW_PAY_TOT_I'				}
			, {dataIndex	:'NOW_BONUS_TOTAL_I'			}
			, {dataIndex	:'NOW_ADD_BONUS_I'			  }
			, {dataIndex	:'NOW_STOCK_PROFIT_I'		}
			, {dataIndex	:'NOW_OWNER_STOCK_DRAW_I'	}
			, {dataIndex	:'NOW_OF_RETR_OVER_I'		}
			, {dataIndex	:"NOW_TAX_INVENTION_I"			}
			 
			, {dataIndex	:'OLD_PAY_TOT_I'				}
			, {dataIndex	:'OLD_BONUS_TOTAL_I'			}
			, {dataIndex	:'OLD_ADD_BONUS_I'			  }
			, {dataIndex	:'OLD_STOCK_PROFIT_I'		}
			, {dataIndex	:'OLD_OWNER_STOCK_DRAW_I'	}
			, {dataIndex	:'OLD_OF_RETR_OVER_I'		}
			, {dataIndex	:'OLD_TAX_INVENTION_I'		  }
			, {dataIndex	:'NAP_PAY_TOT_I'				}
			, {dataIndex	:'NAP_BONUS_TOTAL_I'			}
			, {dataIndex	:'INCOME_DED_I'				 }
			, {dataIndex	:'EARN_INCOME_I'				}
			, {dataIndex	:'PER_DED_I'					}
			, {dataIndex	:'SPOUSE'						}
			, {dataIndex	:'SPOUSE_DED_I'				 }
			, {dataIndex	:'SUPP_NUM'						}
			, {dataIndex	:'SUPP_SUB_I'				}
			, {dataIndex	:'AGED_NUM'						}
			, {dataIndex	:'DEFORM_NUM'				}
			, {dataIndex	:'MANY_CHILD_NUM'			}
			, {dataIndex	:'BRING_CHILD_NUM'			  }
			, {dataIndex	:'BIRTH_ADOPT_NUM'			  }
			, {dataIndex	:'WOMAN'						}

			, {dataIndex	:'BIRTH_ADOPT_NUM1'			 }
			, {dataIndex	:'BIRTH_ADOPT_NUM2'			 }
			, {dataIndex	:'BIRTH_ADOPT_NUM3'			 }
			, {dataIndex	:'AGED_DED_I'				}
			, {dataIndex	:'DEFORM_DED_I'				 }
			, {dataIndex	:'WOMAN_DED_I'				  }
			, {dataIndex	:'ONE_PARENT_DED_I'			 }

			, {dataIndex	:'ANU_I'						}
			, {dataIndex	:'ANU_ADD_I'					}
			, {dataIndex	:'PUBLIC_PENS_I'				}
			, {dataIndex	:'SOLDIER_PENS_I'			}
			, {dataIndex	:'SCH_PENS_I'				}
			, {dataIndex	:'POST_PENS_I'				  }
			, {dataIndex	:'MED_PREMINM_I'				}
			, {dataIndex	:'HIRE_INSUR_I'					}
			, {dataIndex	:'HOUS_AMOUNT_I'				}
			, {dataIndex	:'HOUS_AMOUNT_I_2'			  }
			, {dataIndex	:'MORTGAGE_RETURN_I_2'		  }
			, {dataIndex	:'MORTGAGE_RETURN_I'			}
			, {dataIndex	:'MORTGAGE_RETURN_I_3'		  }
			, {dataIndex	:'MORTGAGE_RETURN_I_5'		  }
			, {dataIndex	:'MORTGAGE_RETURN_I_4'		  }
			, {dataIndex	:'MORTGAGE_RETURN_I_6'		  }
			, {dataIndex	:'MORTGAGE_RETURN_I_7'		  }
			, {dataIndex	:'MORTGAGE_RETURN_I_8'		  }
			, {dataIndex	:'MORTGAGE_RETURN_I_9'		  }
			, {dataIndex	:'PRIV_PENS_I'				  }
			, {dataIndex	:'HOUS_BU_AMT'				  }
			, {dataIndex	:'HOUS_BU_ADD_AMT'			  }
			, {dataIndex	:'HOUS_WORK_AMT'				}
			, {dataIndex	:'HOUS_AMOUNT_I'				}
			, {dataIndex	:'HOUS_AMOUNT_ADD_I'			}
			, {dataIndex	:'CARD_DED_I'				}
			, {dataIndex	:'CARD_USE_I'				}
			, {dataIndex	:'CASH_USE_I'				}
			, {dataIndex	:'DEBIT_CARD_USE_I'			 }
			, {dataIndex	:'TRA_MARKET_USE_I'			 }
			, {dataIndex	:'TRAFFIC_USE_I'				}

			, {dataIndex	:'COMP_PREMINUM'				}
			, {dataIndex	:'COMP_PREMINUM_DED_I'		  }
			, {dataIndex	:'INVESTMENT_DED_I'			 }
			, {dataIndex	:'INVESTMENT_DED_I2'			}
			, {dataIndex	:'INVESTMENT_DED_I3'			}
			, {dataIndex	:'INVESTMENT_DED_I4'			}
			, {dataIndex	:'STAFF_STOCK_DED_I'			}
			, {dataIndex	:'EMPLOY_WORKER_DED_I'		  }
			, {dataIndex	:'NOT_AMOUNT_LOAN_DED_I'		}
			, {dataIndex	:'LONG_INVEST_STOCK_DED_I'	  }
			, {dataIndex	:'INCOME_REDU_I'				}
			, {dataIndex	:'YOUTH_EXEMP_RATE'			 }
			, {dataIndex	:'YOUTH_DED_I'					}
			, {dataIndex	:'YOUTH_DED_I_SUM'			  }
			, {dataIndex	:'SKILL_DED_I'					}
			, {dataIndex	:'MANAGE_RESULT_REDU_I'		 }
			, {dataIndex	:'CORE_COMPEN_FUND_REDU_I'	  }
			, {dataIndex	:'TAXES_REDU_I'					}
			, {dataIndex	:'TAXES_REDU_I'					}
			, {dataIndex	:'CHILD_TAX_DED_I'			  }
			, {dataIndex	:'BRING_CHILD_DED_I'			}
			, {dataIndex	:'BIRTH_ADOPT_I'				}

			, {dataIndex	:'SCI_DEDUC_I'				  }
			, {dataIndex	:'RETIRE_PENS_I'				}
			, {dataIndex	:'PENS_I'					}
			, {dataIndex	:'ETC_INSUR_I'				  }
			, {dataIndex	:'SCI_TAX_DED_I'				}
			, {dataIndex	:'SCI_TAX_DED_I1'			}
			, {dataIndex	:'RETIRE_TAX_DED_I'			 }
			, {dataIndex	:'RETIRE_TAX_DED_I1'			}
			, {dataIndex	:'PENS_TAX_DED_I'			}
			, {dataIndex	:'PENS_TAX_DED_I1'			  }
			, {dataIndex	:'ETC_INSUR_I'				  }
			, {dataIndex	:'DEFORM_INSUR_I'			}
			, {dataIndex	:'ETC_INSUR_TAX_DED_I'		  }
			, {dataIndex	:'DEFORM_INSUR_TAX_DED_I'	}
			, {dataIndex	:'MED_DED_I'					}
			, {dataIndex	:'MY_MED_DED_I'				 }
			, {dataIndex	:'SENIOR_MED_I'				 }
			, {dataIndex	:'DEFORM_MED_I'					}
			, {dataIndex	:'SURGERY_MED_I'				}
			, {dataIndex	:'MED_TOTAL_I'				  }
			, {dataIndex	:'MED_TAX_DED_I'				}
			, {dataIndex	:'MY_MED_TAX_DED_I'			 }
			, {dataIndex	:'SENIOR_MED_TAX_DED_I'		 }
			, {dataIndex	:'DEFORM_MED_TAX_DED_I'		 }

			, {dataIndex	:'SURGERY_MED_TAX_DED_I'		}
			, {dataIndex	:'MED_TOTAL_TAX_DED_I'		  }
			, {dataIndex	:'EDUC_DED_I'				  	}
			, {dataIndex	:'UNIV_EDUC_NUM'				}
			, {dataIndex	:'STUD_EDUC_NUM'				}
			, {dataIndex	:'KIND_EDU_NUM'					}
			, {dataIndex	:'PER_EDUC_DED_I'			  	}
			, {dataIndex	:'UNIV_EDUC_DED_I'			 	}
			, {dataIndex	:'STUD_EDUC_DED_I'			 	}
			, {dataIndex	:'KIND_EDUC_DED_I'			 	}
			, {dataIndex	:'DEFORM_EDUC_DED_I'			}

			, {dataIndex	:'FIELD_EDUC_DED_I'				}
			, {dataIndex	:'EDUC_TAX_DED_I'			  	}
			, {dataIndex	:'PER_EDUC_TAX_DED_I'		  	}
			, {dataIndex	:'UNIV_EDUC_TAX_DED_I'		 	}
			, {dataIndex	:'STUD_EDUC_TAX_DED_I'		 	}
			, {dataIndex	:'KIND_EDUC_TAX_DED_I'		 	}
			, {dataIndex	:'DEFORM_EDUC_TAX_DED_I'		}

			, {dataIndex	:'POLICY_INDED'					}
			, {dataIndex	:'POLICY_GIFT_I'				}
			, {dataIndex	:'LEGAL_GIFT_I_PREV'			}
			, {dataIndex	:'LEGAL_GIFT_I_PREV_14'			}
			, {dataIndex	:'LEGAL_GIFT_I'					}
			, {dataIndex	:'PRIV_GIFT_I_PREV'				}
			, {dataIndex	:'PRIV_GIFT_I'				 	}
			, {dataIndex	:'PUBLIC_GIFT_I_PREV'		  	}
			, {dataIndex	:'PUBLIC_GIFT_I'				}
			, {dataIndex	:'STAFF_GIFT_I'					}
			, {dataIndex	:'APPOINT_GIFT_I_PREV'		 	}
			, {dataIndex	:'APPOINT_GIFT_I_PREV_14'	  	}
			, {dataIndex	:'APPOINT_GIFT_I'			  	}
			, {dataIndex	:'ASS_GIFT_I_PREV'			 	}
			, {dataIndex	:'ASS_GIFT_I_PREV_14'		  	}
			, {dataIndex	:'ASS_GIFT_I'				  	}

			, {dataIndex	:'POLICY_INDED_DED_AMT'		 }
			, {dataIndex	:'POLICY_GIFT_DED_AMT'		  }
			, {dataIndex	:'LEGAL_DED_AMT'				}
			, {dataIndex	:'STAFF_DED_AMT'				}
			, {dataIndex	:'APPOINT_ASS_TAX_DED_AMT'	  }
			, {dataIndex	:'GIFT_DED_I'				}
			, {dataIndex	:'LEGAL_GIFT_DED_I'			 }
			, {dataIndex	:'PRIV_GIFT_DED_I'			  }
			, {dataIndex	:'PUBLIC_GIFT_DED_I'			}
			, {dataIndex	:'STAFF_GIFT_DED_I'			 }
			, {dataIndex	:'APPOINT_GIFT_DED_I'		}
			, {dataIndex	:'ASS_GIFT_DED_I'			}
			, {dataIndex	:'GIFT_TAX_DED_I'			}
			, {dataIndex	:'POLICY_INDED_TAX_DED_I'	}
			, {dataIndex	:'POLICY_GIFT_TAX_DED_I'		}
			, {dataIndex	:'LEGAL_GIFT_TAX_DED_I'		 }
			, {dataIndex	:'STAFF_GIFT_TAX_DED_I'		 }
			, {dataIndex	:'APPOINT_GIFT_TAX_DED_I'	}
			, {dataIndex	:'ASS_GIFT_TAX_DED_I'		}

			, {dataIndex	:'NAP_TAX_DED_I'				}
			, {dataIndex	:'HOUS_INTER_I'				 }
			, {dataIndex	:'OUTSIDE_INCOME_I'			 }
			, {dataIndex	:'MON_RENT_I'				}
			, {dataIndex	:'TAB1_DED_AMT'				 }
			, {dataIndex	:'TAB2_DED_AMT'				 }
			, {dataIndex	:'TAB3_DED_AMT'				 }
			, {dataIndex	:'TAB4_DED_AMT'				 }
			, {dataIndex	:'TAB5_DED_AMT'				 }
			, {dataIndex	:'DED_INCOME_I'				 }
			, {dataIndex	:'DED_INCOME_I1'				}
			, {dataIndex	:'DED_INCOME_I2'				}
			, {dataIndex	:'TAB6_DED_AMT'				 }
			, {dataIndex	:'TAB7_DED_AMT'				 }
			, {dataIndex	:'TAB8_DED_AMT'				 }
			, {dataIndex	:'TAB9_DED_AMT'				 }
			, {dataIndex	:'OVER_INCOME_DED_LMT'		  }
			, {dataIndex	:'TAX_STD_I'					}
			, {dataIndex	:'TAX_STD_I1'				}
			, {dataIndex	:'TAX_STD_I2'				}
			, {dataIndex	:'COMP_TAX_I'				}
			, {dataIndex	:'COMP_TAX_I1'				  }
			, {dataIndex	:'COMP_TAX_I1'				  }

			, {dataIndex	:'TAB10_DED_AMT'				}
			, {dataIndex	:'TAB11_DED_AMT'				}
			, {dataIndex	:'TAB12_DED_AMT'				}
			, {dataIndex	:'TAB13_DED_AMT'				}
			, {dataIndex	:'TAB14_DED_AMT'				}
			, {dataIndex	:'TAB15_DED_AMT'				}
			, {dataIndex	:'TAB16_DED_AMT'				}
			, {dataIndex	:'STD_TAX_DED_I'				}
			, {dataIndex	:'TAB17_DED_AMT'				}
			, {dataIndex	:'DEF_IN_TAX_I'				 }
			, {dataIndex	:'DEF_LOCAL_TAX_I'			  }
			, {dataIndex	:'DEF_SP_TAX_I'				 }
			, {dataIndex	:'DEF_TAX_SUM'				  }
			, {dataIndex	:'NOW_IN_TAX_I'				 }
			, {dataIndex	:'NOW_LOCAL_TAX_I'			  }
			, {dataIndex	:'NOW_SP_TAX_I'				 }
			, {dataIndex	:'NOW_TAX_SUM'				  }
			, {dataIndex	:'PRE_IN_TAX_I'				 }
			, {dataIndex	:'PRE_LOCAL_TAX_I'			  }
			, {dataIndex	:'PRE_SP_TAX_I'				 }
			, {dataIndex	:'PRE_TAX_SUM'				  }

			, {dataIndex	:'NAP_IN_TAX_I'				 }
			, {dataIndex	:'NAP_LOCAL_TAX_I'			  }
			, {dataIndex	:'NAP_SP_TAX_I'				 }
			, {dataIndex	:'NAP_TAX_SUM'				  }
			, {dataIndex	:'PAID_IN_TAX_SUM'			  }
			, {dataIndex	:'PAID_LOCAL_TAX_SUM'		}
			, {dataIndex	:'PAID_SP_TAX_SUM'			  }
			, {dataIndex	:'PAID_TAX_SUM'				 }
			, {dataIndex	:'IN_TAX_I'					 }
			, {dataIndex	:'LOCAL_TAX_I'				  }
			, {dataIndex	:'SP_TAX_I'					 }
			, {dataIndex	:'SP_TAX_I'					 }

		]

	});
	
	Unilite.Main( {
		borderItems: [{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, tab, northForm, southForm
			]
		},
			panelSearch
		],
		id  : 'had620ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('YEAR_YYYY', YEAR_YYYY);
			panelSearch.setValue('PERSON_NUMB', PERSON_NUMB);
			panelSearch.setValue('NAME', PERSON_NAME);

			UniAppManager.setToolbarButtons([ 'newData', 'save', 'detail', 'delete'], false);
			UniAppManager.setToolbarButtons([ 'prev', 'next'], false);
			if(USE_AUTH == 'Y')	{
				if(AUTH_YN == 'N')	{
					panelSearch.setReadOnly(true);
					UniAppManager.setToolbarButtons([ 'reset', 'newData', 'save', 'detail', 'delete', 'prev', 'next'], false);
					if(PERSON_NUMB == '')	{
						Unilite.messageBox(Msg.fsbMsgH0362);
						UniAppManager.setToolbarButtons([ 'query'], false);
					}else {
						this.onQueryButtonDown();
					}
				}
			}
			this.fnBtnEnable(false);
			
			panelSearch.collapsed = false;
		},
		onQueryButtonDown : function()	{
			directEmpStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			if(AUTH_YN != 'N')	{

				var form400_info = Ext.getCmp('infoForm400').clearForm();
				var form400_base = Ext.getCmp('baseForm400').clearForm();
				var form400_tab01 = Ext.getCmp('tab1Form400').clearForm();
				var form400_tab02 = Ext.getCmp('tab2Form400').clearForm();
				var form400_tab03 = Ext.getCmp('tab3Form400').clearForm();
				var form400_tab04 = Ext.getCmp('tab4Form400').clearForm();
				var form400_tab05 = Ext.getCmp('tab5Form400').clearForm();
				var form400_tab06 = Ext.getCmp('tab6Form400').clearForm();
				var form400_tab07 = Ext.getCmp('tab7Form400').clearForm();
				var form400_tab08 = Ext.getCmp('tab8Form400').clearForm();
				var form400_tab09 = Ext.getCmp('tab9Form400').clearForm();
				var form400_tab10 = Ext.getCmp('tab10Form400').clearForm();
				var form400_tab11 = Ext.getCmp('tab11Form400').clearForm();
				var form400_tab12 = Ext.getCmp('tab12Form400').clearForm();
				var form400_tab13 = Ext.getCmp('tab13Form400').clearForm();
				var form400_tab14 = Ext.getCmp('tab14Form400').clearForm();
				var form400_tab15 = Ext.getCmp('tab15Form400').clearForm();
				var form400_tab16 = Ext.getCmp('tab16Form400').clearForm();
				var form400_tab17 = Ext.getCmp('tab17Form400').clearForm();

				var form600_base = Ext.getCmp('baseForm600').clearForm();
				var form600_tab01 = Ext.getCmp('tab1Form600').clearForm();
				var form600_tab02 = Ext.getCmp('tab2Form600').clearForm();
				var form600_tab03 = Ext.getCmp('tab3Form600').clearForm();
				var form600_tab04 = Ext.getCmp('tab4Form600').clearForm();
				var form600_tab05 = Ext.getCmp('tab5Form600').clearForm();
				var form600_tab06 = Ext.getCmp('tab6Form600').clearForm();
				var form600_tab07 = Ext.getCmp('tab7Form600').clearForm();
				var form600_tab08 = Ext.getCmp('tab8Form600').clearForm();
				var form600_tab09 = Ext.getCmp('tab9Form600').clearForm();
				var form600_tab10 = Ext.getCmp('tab10Form600').clearForm();
				var form600_tab11 = Ext.getCmp('tab11Form600').clearForm();
				var form600_tab12 = Ext.getCmp('tab12Form600').clearForm();
				var form600_tab13 = Ext.getCmp('tab13Form600').clearForm();
				var form600_tab14 = Ext.getCmp('tab14Form600').clearForm();
				var form600_tab15 = Ext.getCmp('tab15Form600').clearForm();
				var form600_tab16 = Ext.getCmp('tab16Form600').clearForm();
				var form600_tab17 = Ext.getCmp('tab17Form600').clearForm();
				var form600_tab18 = Ext.getCmp('tab18Form600').clearForm();
				var form600_south = Ext.getCmp('southForm600').clearForm();

				direct600Store.loadData({});
				direct600Store.commitChanges();
				direct400Store.loadData({});
				direct400Store.commitChanges();

				southForm.clearForm();

				panelSearch.setValue('PERSON_NUMB', '');
				panelSearch.setValue('NAME', '');

				panelResult.setValue('PERSON_NUMB', '');
				panelResult.setValue('NAME', '');
				
				empGrid.getStore().loadData({});
				UniAppManager.app.fnBtnEnable(false);
				gbCloseYn = true;
			}
		},
		onNewDataButtonDown: function() {
		},
		onDeleteDataButtonDown: function() {
			if(!confirm('<t:message code="system.message.human.message009" default="자료를 삭제 합니다. 삭제 하시겠습니까?"/>'))
				return;
			
			if(gbCloseYn) {
				Unilite.messageBox('마감된 자료는 삭제하실 수 없습니다.');
				return;
			}
				
			var mRow  = empGrid.getSelectedRecord();
			if(!Ext.isEmpty(mRow)) {
				var param = {
					COMP_CODE	: mRow.get('COMP_CODE'),
					DIV_CODE	: mRow.get('DIV_CODE'),
					PERSON_NUMB	: mRow.get('PERSON_NUMB'),
					YEAR_YYYY	: panelSearch.getValue('YEAR_YYYY')
				};
				
				had620ukrService.deleteAll(param, function(responseText, response) {
					if(responseText){
						UniAppManager.updateStatus('삭제되었습니다.');
						var empNo = mRow.get('PERSON_NUMB');
						direct600Store.loadStoreRecords(empNo);
						direct400Store.loadStoreRecords(empNo);
						
						mRow = empGrid.getSelectedRecord();
						mRow.set('ADJUST_YN', 'N');
						directEmpStore.commitChanges();
					}
				});
			}
		},
		onSaveDataButtonDown: function() {
			direct600Store.saveStore();
		},
		onPrevDataButtonDown:  function()	{
			UniAppManager.app.confirmSaveData();
			empGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			UniAppManager.app.confirmSaveData();
			empGrid.selectNextRow();
		},
		rejectSave: function()	{
			direct400Store.rejectChanges();
			direct600Store.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		},
		confirmSaveData: function()	{
				if(direct400Store.isDirty() || direct600Store.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						//this.rejectSave();
					}
				}

		},
		fnBtnEnable: function(enable)	{
			tab1.down('#btnFamily1').setDisabled(!enable);
			northForm.down('#btnYearIncome').setDisabled(!enable);
			northForm.down('#btnPrevCompany').setDisabled(!enable);
			northForm.down('#btnTaxCommunity').setDisabled(!enable);
			tab1.down('#btnFamily1').setDisabled(!enable);
			tab2.down('#btnFamily1').setDisabled(!enable);
			tab8.down('#btnFamily1').setDisabled(!enable);
			tab13.down('#btnFamily2').setDisabled(!enable);	
			tab13.down('#btnFamily1').setDisabled(!enable);	
			tab14.down('#btnFamily1').setDisabled(!enable);	
			tab15.down('#btnFamily1').setDisabled(!enable);
			tab6.down('#btnPension').setDisabled(!enable);
			tab9.down('#btnPension').setDisabled(!enable);
			tab12.down('#btnPension').setDisabled(!enable);
			tab7.down('#btnPension1').setDisabled(!enable);
			tab7.down('#btnPension1').setDisabled(!enable);
			tab9.down('#btnPension1').setDisabled(!enable);
			tab12.down('#btnPension1').setDisabled(!enable);
			tab7.down('#btnPension2').setDisabled(!enable);
			tab12.down('#btnPension2').setDisabled(!enable);
			tab7.down('#btnPension3').setDisabled(!enable);
			tab14.down('#btnMed').setDisabled(!enable);
			panelResult.down('#btnPdf').setDisabled(!enable);
			tab17.down('#btnRent').setDisabled(!enable);
			tab16.down('#btnDonation').setDisabled(!enable);
			tab5.down('#btnHouseLoan').setDisabled(!enable);
			panelResult.down('#btnCollectData').setDisabled(!enable);
			panelResult.down('#btnCalculateTax').setDisabled(!enable);
			panelResult.down('#btnClose').setDisabled(!enable);
			
			var form400_info = Ext.getCmp('infoForm400');
			var form400_base = Ext.getCmp('baseForm400');
			var form400_tab01 = Ext.getCmp('tab1Form400');
			var form400_tab02 = Ext.getCmp('tab2Form400');
			var form400_tab03 = Ext.getCmp('tab3Form400');
			var form400_tab04 = Ext.getCmp('tab4Form400');
			var form400_tab05 = Ext.getCmp('tab5Form400');
			var form400_tab06 = Ext.getCmp('tab6Form400');
			var form400_tab07 = Ext.getCmp('tab7Form400');
			var form400_tab08 = Ext.getCmp('tab8Form400');
			var form400_tab09 = Ext.getCmp('tab9Form400');
			var form400_tab10 = Ext.getCmp('tab10Form400');
			var form400_tab11 = Ext.getCmp('tab11Form400');
			var form400_tab12 = Ext.getCmp('tab12Form400');
			var form400_tab13 = Ext.getCmp('tab13Form400');
			var form400_tab14 = Ext.getCmp('tab14Form400');
			var form400_tab15 = Ext.getCmp('tab15Form400');
			var form400_tab16 = Ext.getCmp('tab16Form400');
			var form400_tab17 = Ext.getCmp('tab17Form400');
			
			
			form400_info.setReadOnly(!enable);
			form400_base.setReadOnly(!enable);
			form400_tab01.setReadOnly(!enable);
			form400_tab02.setReadOnly(!enable);
			form400_tab03.setReadOnly(!enable);
			form400_tab04.setReadOnly(!enable);
			form400_tab05.setReadOnly(!enable);
			form400_tab06.setReadOnly(!enable);
			form400_tab07.setReadOnly(!enable);
			form400_tab08.setReadOnly(!enable);
			form400_tab09.setReadOnly(!enable);
			form400_tab10.setReadOnly(!enable);
			form400_tab11.setReadOnly(!enable);
			form400_tab12.setReadOnly(!enable);
			form400_tab13.setReadOnly(!enable);
			form400_tab14.setReadOnly(!enable);
			form400_tab15.setReadOnly(!enable);
			form400_tab16.setReadOnly(!enable);
			form400_tab17.setReadOnly(!enable);
			
			var form600_base = Ext.getCmp('baseForm600');
			var form600_tab01 = Ext.getCmp('tab1Form600');
			var form600_tab02 = Ext.getCmp('tab2Form600');
			var form600_tab03 = Ext.getCmp('tab3Form600');
			var form600_tab04 = Ext.getCmp('tab4Form600');
			var form600_tab05 = Ext.getCmp('tab5Form600');
			var form600_tab06 = Ext.getCmp('tab6Form600');
			var form600_tab07 = Ext.getCmp('tab7Form600');
			var form600_tab08 = Ext.getCmp('tab8Form600');
			var form600_tab09 = Ext.getCmp('tab9Form600');
			var form600_tab10 = Ext.getCmp('tab10Form600');
			var form600_tab11 = Ext.getCmp('tab11Form600');
			var form600_tab12 = Ext.getCmp('tab12Form600');
			var form600_tab13 = Ext.getCmp('tab13Form600');
			var form600_tab14 = Ext.getCmp('tab14Form600');
			var form600_tab15 = Ext.getCmp('tab15Form600');
			var form600_tab16 = Ext.getCmp('tab16Form600');
			var form600_tab17 = Ext.getCmp('tab17Form600');
			var form600_tab18 = Ext.getCmp('tab18Form600');
			var form600_south = Ext.getCmp('southForm600');
			
			form600_base.setReadOnly(!enable);
			form600_tab01.setReadOnly(!enable);
			form600_tab02.setReadOnly(!enable);
			form600_tab03.setReadOnly(!enable);
			form600_tab04.setReadOnly(!enable);
			form600_tab05.setReadOnly(!enable);
			form600_tab06.setReadOnly(!enable);
			form600_tab07.setReadOnly(!enable);
			form600_tab08.setReadOnly(!enable);
			form600_tab09.setReadOnly(!enable);
			form600_tab10.setReadOnly(!enable);
			form600_tab11.setReadOnly(!enable);
			form600_tab12.setReadOnly(!enable);
			form600_tab13.setReadOnly(!enable);
			form600_tab14.setReadOnly(!enable);
			form600_tab15.setReadOnly(!enable);
			form600_tab16.setReadOnly(!enable);
			form600_tab17.setReadOnly(!enable);
			form600_tab18.setReadOnly(!enable);
		},
		fnCollectData:function(cType){
			var record = direct400Store.getAt(0);
			var infoForm400 = Ext.getCmp('infoForm400');
			var paramData = {
				'YEAR_YYYY'			: panelResult.getValue('YEAR_YYYY'),
				'PERSON_NUMB'		: panelResult.getValue('PERSON_NUMB'),
				'FOREIGN_NUM'		: panelResult.getValue('FOREIGN_NUM'),

				'FORE_SINGLE_YN' : record.data["FORE_SINGLE_YN"],
				'FOREIGN_DISPATCH_YN' : record.data["FOREIGN_DISPATCH_YN"],
				'HALFWAY_TYPE' : record.data["HALFWAY_TYPE"]
			};
			
			Ext.getBody().mask('Loading');
			had620ukrService.selectSummaryData(paramData, function(responseText, response){
				console.log("responseText", responseText);
				//if(responseText && responseText.length > 0) UniAppManager.app.fnDisplayData1(responseText[0], "REFER");
				direct400Store.loadStoreRecords(responseText[0]["PERSON_NUMB"]);
				Ext.getBody().unmask();
			})
		},
		fnCalculateTax:function() {
			var record = direct400Store.getAt(0);
			var infoForm400 = Ext.getCmp('infoForm400');
			var paramData = {
				'YEAR_YYYY'			: panelResult.getValue('YEAR_YYYY'),
				'PERSON_NUMB'		: panelResult.getValue('PERSON_NUMB')
			};
			
			Ext.getBody().mask('Loading');
			had620ukrService.selectCalculateTax(paramData, function(responseText, response){
				console.log("responseText", responseText);
				//if(responseText && responseText.length > 0) UniAppManager.app.fnDisplayData2(responseText[0]);
				direct600Store.loadStoreRecords(responseText[0]["PERSON_NUMB"]);
				Ext.getBody().unmask();
				
				//	사원 리스트 정산 여부 업데이트
				mRow  = empGrid.getSelectedRecord();
				mRow.set('ADJUST_YN', 'Y');
				directEmpStore.commitChanges();
			});
		},
		//년간근로소득/기타소득입력
		openYearIncome:function()	{
			if(!panelResult.isValid())	{
				return;
			}
			var paramData = {
				'YEAR_YYYY'			: panelResult.getValue('YEAR_YYYY'),
				'PERSON_NUMB'		: panelResult.getValue('PERSON_NUMB'),
				'NAME'				: panelResult.getValue('NAME'),
				'DEPT_NAME'			: panelResult.getValue('DEPT_NAME'),
				'POST_CODE_NAME'	: panelResult.getValue('POST_NAME')
			};
			if(!yearIncomeWin)	{
				Unilite.defineModel('had800Model', {
					fields: [
						{name: 'PAY_YYYYMM'		, text: '지급년월'		, type: 'string'},
						{name: 'PAYGUBN'		, text: '지급구분'		, type: 'string'},
						{name: 'SUPPDATE'		, text: '지급일자'		, type: 'uniDate'},
						{name: 'SUPPTOTAL'		, text: '지급총액'		, type: 'uniPrice'},
						{name: 'TAXAMOUNT'		, text: '과세분'		, type: 'uniPrice'},
						{name: 'NONTAXAMOUNT'	, text: '제출비과세'		, type: 'uniPrice'},
						{name: 'NONTAXAMOUNT2'	, text: '미제출비과세'		, type: 'uniPrice'}, 
						{name: 'ANU'			, text: '국민연금'		, type: 'uniPrice'},
						{name: 'MED'			, text: '건강보험'		, type: 'uniPrice'},
						{name: 'HIR'			, text: '고용보험'		, type: 'uniPrice'},
						{name: 'BUSISHAREI'		, text: '사회보험부담금'	, type: 'uniPrice'},
						{name: 'SUDK'			, text: '소득세'	  , type: 'uniPrice'},
						{name: 'JUMIN'			, text: '주민세'	  , type: 'uniPrice'},
						{name: 'PAYCODE'		, text: '급여지급방식'  , type: 'string'},
						{name: 'TAXCODE'		, text: '세액구분'		, type: 'string'}
					]
				});
				var had800Store = Unilite.createStore('had800Store',{

					model: 'had800Model',
					uniOpt : {
						isMaster: false,		// 상위 버튼 연결
						editable: false,		// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'direct',
						api: {
							read: 'had800skrService.selectListByEmployee'
						}
					},
					loadStoreRecords: function(){
						var param = yearIncomeWin.paramData;
						param.PAY_YYYYMM_FR = param.YEAR_YYYY + '01';
						param.PAY_YYYYMM_TO = param.YEAR_YYYY + '12';

						console.log( param );
						this.load({
							params: param
						});
					}
				});

				Unilite.defineModel('had700ukrModel', {
					fields: [
						{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string', allowBlank:false},
						{name: 'NAME'				, text: '성명'			, type: 'string'},
						{name: 'PAY_YYYYMM'			, text: '귀속월'		, type: 'uniDate', allowBlank:false},
						{name: 'SUPP_DATE'			, text: '지급일'		, type: 'uniDate', allowBlank:false},
						{name: 'WAGES_CODE'			, text: '소득내역'		, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H039'},
						{name: 'SUPP_TOTAL_I'		, text: '지급금액'		, type: 'uniPrice'},
						{name: 'IN_TAX_I'			, text: '소득세'		, type: 'uniPrice'},
						{name: 'LOCAL_TAX_I'		, text: '주민세'		, type: 'uniPrice'},
						{name: 'HIRE_INSUR_I'		, text: '고용보험'		, type: 'uniPrice'},
						{name: 'TAX_AMOUNT_I'		, text: '과세분'		, type: 'uniPrice'},
						{name: 'NON_TAX_AMOUNT_I'	, text: '비과세분'		, type: 'uniPrice'},
						{name: 'NON_TAX_CODE'		, text: '비과세코드'	, type: 'string'},
						{name: 'NONTAX_CODE_NAME'	, text: '비과세코드'	, type: 'string'},
						{name: 'REMARK'				, text: '비고'		  , type: 'string'}
					]
				});

				var had700ukrStore = Unilite.createStore('had700ukrStore',{
					model: 'had700ukrModel',
					uniOpt : {
						isMaster: false,		// 상위 버튼 연결
						editable: true,			// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 'had700ukrService.selectList'
							,update : 'had700ukrService.update'
							,create : 'had700ukrService.insert'
							,destroy : 'had700ukrService.delete'
							,syncAll: 'had700ukrService.saveAll'
						}
					},
					loadStoreRecords: function(){
						var param= yearIncomeWin.paramData;
						param.SUPP_DATE_FR = param.YEAR_YYYY + '01';
						param.SUPP_DATE_TO = param.YEAR_YYYY + '12';

						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function()	{
						var toCreate = this.getNewRecords();
						var toUpdate = this.getUpdatedRecords();
						var toDelete = this.getRemovedRecords();
						var list = [].concat(toUpdate, toCreate);

						var checkValid = true;
						Ext.each(list, function(record, index) {
							// 비과세분 입력시 비과세 코드 입력 체크
							if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
								Unilite.messageBox(Msg.sMH1065 +'\n'+ Msg.fstMsgH0098);
								checkValid = false;
								return;
							}
						})
						
						if(!checkValid)	{
							return;
						}
						
						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);
						if(inValidRecs.length == 0) {
							config = {
								success: function(batch, option) {
									yearIncomeWin.changes = true;
								}
							};
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('had700ukrGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}
				});

				yearIncomeWin = Ext.create('widget.uniDetailWindow', {
					title: '년간근로소득조회/기타소득내역등록',
					width: 1000,
					height:630,
					layout: {type:'vbox', align:'stretch'},
					items: [{
						itemId:'search',
						xtype:'uniSearchForm',
						style:{
							'background':'#fff'
						},
						height:40,
						layout:{type:'uniTable', columns:5},
						margine:'3 3 3 3',
						items:[{
							fieldLabel: '정산년도',
							name:'YEAR_YYYY',
							xtype: 'uniYearField',
							readOnly:true,
							width:150,
							labelWidth:80
						},{
							fieldLabel: '성명',
							name:'NAME',
							readOnly:true,
							width:150,
							labelWidth:50
						},{
							fieldLabel: '사번',
							name:'PERSON_NUMB',
							readOnly:true,
							width:200,
							labelWidth:50
						},{
							fieldLabel: '부서',
							name:'DEPT_NAME',
							readOnly:true,
							width:200,
							labelWidth:50
						},{
							fieldLabel: '직위',
							name:'POST_CODE_NAME',
							readOnly:true,
							width:150,
							labelWidth:50
						}
					]},{
						xtype:'container',
						height:330,
						layout: {type:'vbox', align:'stretch'},
						items:[
							//년간근로소득내역(기타소득포함)
							Unilite.createGrid('had800Grid', {
								layout : 'fit',
								store : had800Store,
								sortableColumns: false,
								uniOpt:{
									expandLastColumn: false,	//마지막 컬럼 * 사용 여부
									useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
									useLiveSearch: false,		//찾기 버튼 사용 여부
									filter: {					//필터 사용 여부
										useFilter: false,
										autoCreate: false
									},
									userToolbar :false
								},
								features: [
									{ ftype: 'uniSummary',		  showSummaryRow: true, dock :'bottom'}
								],
								columns:  [
									{dataIndex: 'PAY_YYYYMM'		, width: 73,
										summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
											  return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
										}
									 },
									{dataIndex: 'PAYGUBN'		, width: 80},
									{dataIndex: 'SUPPDATE'		, width: 73},
									{dataIndex: 'SUPPTOTAL'	, width: 90	, summaryType:'sum'},
									{dataIndex: 'TAXAMOUNT'  	, width: 90	, summaryType:'sum'},
									{dataIndex: 'NONTAXAMOUNT'	, width: 90	, summaryType:'sum'},
									{dataIndex: 'NONTAXAMOUNT2'	, width: 90	, summaryType:'sum'},
									{dataIndex: 'ANU'		, width: 90	, summaryType:'sum'},
									{dataIndex: 'MED'			, width: 90	, summaryType:'sum'},
									{dataIndex: 'HIR'		, width: 90	, summaryType:'sum'},
									{dataIndex: 'BUSISHAREI'	, width: 110, summaryType:'sum'},
									{dataIndex: 'SUDK'			, width: 90	, summaryType:'sum'},
									{dataIndex: 'JUMIN'	  	, width: 90	, summaryType:'sum'},
									{dataIndex: 'PAYCODE'	 	, width: 86	},
									{dataIndex: 'TAXCODE'	 	, minWidth: 70, flex: 1}
								]
							})
						]},{
							xtype:'container',
							height:200,
							layout: {type:'vbox', align:'stretch'},
							items:[
								//기타소득내역
								Unilite.createGrid('had700ukrGrid', {
									layout : 'fit',
									store : had700ukrStore,
									sortableColumns: false,
									uniOpt:{
										expandLastColumn: false,	//마지막 컬럼 * 사용 여부
										useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
										useLiveSearch: false,		//찾기 버튼 사용 여부
										filter: {					//필터 사용 여부
											useFilter: false,
											autoCreate: false
										},
										state: {
											useState: false,		//그리드 설정 버튼 사용 여부
											useStateList: false		//그리드 설정 목록 사용 여부
										}
									},
									features: [
										{ ftype: 'uniSummary',		showSummaryRow: true, dock :'bottom'}
									],
									tbar:[
										'->',
										{
											xtype:'button',
											text:'추가',
											itemId: 'btnYearIncomePopAdd',
											handler:function()	{
												var form = yearIncomeWin.down('#search');
												var grid = Ext.getCmp('had700ukrGrid');
												var record = Ext.create(had700ukrStore.model);
												rIndex = had700ukrStore.count();
												record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
												had700ukrStore.insert(rIndex, record);
												grid.getSelectionModel().select(rIndex);
												var columns = grid.getVisibleColumns();
												var	sCell = grid.getView().getCell(record, columns[0], true);
												
												if(sCell)	{
													Ext.fly(sCell).focus();
												}
											}
										},{
											xtype:'button',
											text:'삭제',
											itemId: 'btnYearIncomePopDel',
											handler:function()	{
												var grid = Ext.getCmp('had700ukrGrid');
												had700ukrStore.remove(grid.getSelectionModel().getSelection());
											}
										}
									],
									columns: [
										{dataIndex: 'PAY_YYYYMM'		, width: 73,
											xtype:'uniMonthColumn',
											editor:{xtype:'uniMonthfield',format: 'Y.m'},
											summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
												  return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
											}
										},
										{dataIndex: 'SUPP_DATE'		 , width: 90, readonly:true},
										{dataIndex: 'WAGES_CODE'		, width: 90},
										{dataIndex: 'SUPP_TOTAL_I'	  , width: 90, summaryType:'sum'},
										{dataIndex: 'IN_TAX_I'		  , width: 90, summaryType:'sum'},
										{dataIndex: 'LOCAL_TAX_I'	, width: 90, summaryType:'sum'},
										{dataIndex: 'HIRE_INSUR_I'	  , width: 90, summaryType:'sum'},
										{dataIndex: 'TAX_AMOUNT_I'	  , width: 110, summaryType:'sum'},
										{dataIndex: 'NON_TAX_AMOUNT_I'  , width: 90, summaryType:'sum'},
										{dataIndex: 'NON_TAX_CODE'	  , width: 90,
											editor:Unilite.popup('NONTAX_CODE_G', {
												textFieldName:'NONTAX_CODE_NAME',
			  									autoPopup: true,
												listeners:{
													onSelected:function(records, type)	{
														if(records)	{
															var grid = Ext.getCmp('had700ukrGrid');
															var record = grid.uniOpt.currentRecord;
															record.set('NON_TAX_CODE', records[0].NONTAX_CODE);
															record.set('NONTAX_CODE_NAME', records[0].NONTAX_CODE_NAME);
														}
													},
													onClear:function()	{
														var grid = Ext.getCmp('had700ukrGrid');
														var record = grid.uniOpt.currentRecord;
														record.set('NON_TAX_CODE', '');
														record.set('NONTAX_CODE_NAME', '');
													},
													applyextparam:function(popup)	{
														popup.extParam.PAY_YM_FR = yearIncomeWin.paramData.YEAR_YYYY;
													}
												}
											})
										},
										{dataIndex: 'REMARK'			, minWidth: 70, flex: 1}
									],
									listeners:{
										beforeedit : function( editor, e, eOpts ) {
											if(gbCloseYn) {
												return false;
											}
											if(!e.record.phantom && UniUtils.indexOf(e.field, ['PAY_YYYYMM','SUPP_DATE','WAGES_CODE'])) {
												return false;
											}
											return true;
										}
									}
								})
							]
						}
					],
					bbar:{
						layout: {
							pack: 'center',
							type: 'hbox'
						},
						dock:'bottom',
						items :  [
							 {
								itemId : 'submitBtn',
								text: '저장',
								width:100,
								itemId: 'btnYearIncomeSaveAll',
								handler: function() {
									var store = Ext.data.StoreManager.lookup('had700ukrStore') ;
									if(store.isDirty())	{
										store.saveStore();
									}
								}
							},{
								itemId : 'closeBtn',
								text: '닫기',
								width:100,
								handler: function() {
									var store = Ext.data.StoreManager.lookup('had700ukrStore') ;
									if(store.isDirty())	{
										if(confirm("저장할 데이터가 있습니다. 저장하시겠습니까?")){
											store.saveStore();
											return;
										}
									}
									yearIncomeWin.hide();

								},
								disabled: false
							}
						]
					},
					listeners : {
						beforehide: function(me, eOpt)	{
							yearIncomeWin.down('#search').clearForm();
							if(yearIncomeWin.changes)	{
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
						},
						beforeclose: function( panel, eOpts )	{
							yearIncomeWin.down('#search').clearForm();
							if(yearIncomeWin.changes) {
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
						},
						show: function( panel, eOpts )	{
							var searchForm =  yearIncomeWin.down('#search');
							searchForm.setValue("YEAR_YYYY"		,yearIncomeWin.paramData.YEAR_YYYY);
							searchForm.setValue("NAME"			,yearIncomeWin.paramData.NAME);
							searchForm.setValue("PERSON_NUMB"	,yearIncomeWin.paramData.PERSON_NUMB);
							searchForm.setValue("DEPT_NAME"		,yearIncomeWin.paramData.DEPT_NAME);
							searchForm.setValue("POST_CODE_NAME",yearIncomeWin.paramData.POST_CODE_NAME);
							had800Store.loadStoreRecords();
							had700ukrStore.loadStoreRecords();
							
							yearIncomeWin.setCloseForm();
						}
					},
					setCloseForm : function() {
						this.down('#btnYearIncomePopAdd').setDisabled(gbCloseYn);
						this.down('#btnYearIncomePopDel').setDisabled(gbCloseYn);
						
						yearIncomeWin.down('#btnYearIncomeSaveAll').setDisabled(gbCloseYn);
					}
				});
				
				var validateYearIncome =  Unilite.createValidator('validateYearIncome', {
					store: Ext.getCmp('had700ukrGrid').getStore(),
					grid: Ext.getCmp('had700ukrGrid'),
					validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
						if(newValue == oldValue){
							return false;
						}
						console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
						var rv = true;
						var sAfterValue = newValue;

						switch(fieldName)	{
							case "SUPP_TOTAL_I":
								record.set("TAX_AMOUNT_I", sAfterValue);
								break;
								
							case "TAX_AMOUNT_I":
								var suppTotalI = record.get("SUPP_TOTAL_I");
								var nonTaxAmountI = suppTotalI - newValue;

								if(nonTaxAmountI < 0)
									nonTaxAmountI = 0;

								record.set("NON_TAX_AMOUNT_I", nonTaxAmountI);
								break;
						}
						return rv;
					}
				});
			}
			yearIncomeWin.paramData = paramData;
			yearIncomeWin.changes = false;
			yearIncomeWin.center();
			yearIncomeWin.show();
		},
		//종(전)근무지내역 입력
		openPrevCompany:function()	{
			if(!panelResult.isValid())	{
				return;
			}
			var paramData = {
				'YEAR_YYYY'			: panelResult.getValue('YEAR_YYYY'),
				'PERSON_NUMB'		: panelResult.getValue('PERSON_NUMB'),
				'NAME'				: panelResult.getValue('NAME'),
				'DEPT_NAME'			: panelResult.getValue('DEPT_NAME'),
				'POST_CODE_NAME'	: panelResult.getValue('POST_NAME')
			};

			if(!prevCompanyWin)	{
				Unilite.defineModel('had510ukrModel', {
					fields: [
						{name: 'YEAR_YYYY'			, text: '정산년도'		, type: 'string', allowBlank:false},
						{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string', allowBlank:false},
						{name: 'NONTAX_CODE'		, text: '비과세코드'		, type: 'string', allowBlank:false},
						{name: 'NONTAX_CODE_NAME'	, text: '비과세코드'	, type: 'string', allowBlank:false},
						{name: 'TAX_EXEMPTION_I'	, text: '비과세소득'		, type: 'uniPrice'},
						{name: 'PRINT_LOCATION'		, text: '기재란'	, type: 'string'}
					]
				});
				var had510ukrStore = Unilite.createStore('had510ukrStore',{
					model: 'had510ukrModel',
					uniOpt : {
						isMaster: false,		// 상위 버튼 연결
						editable: true,			// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 'had500ukrService.selectList510'
							,update : 'had500ukrService.update510'
							,create : 'had500ukrService.insert510'
							,destroy: 'had500ukrService.delete510'
							,syncAll: 'had500ukrService.saveAll510'
						}
					},
					loadStoreRecords: function(){
						var param= prevCompanyWin.paramData;
						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function()	{
						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);
						if(inValidRecs.length == 0) {
							config = {
								success: function(batch, option) {
									prevCompanyWin.changes = true;
									prevCompanyWin.unmask();
									if(had520ukrStore.isDirty())	{
										had520ukrStore.saveStore();
									} else if(had530_1ukrStore.isDirty())	{
										had530_1ukrStore.saveStore();
									}else if(had530_2ukrStore.isDirty())	{
										had530_2ukrStore.saveStore();
									}
								}
							};
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('had510ukrGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}
				});

				var had520ukrStore = Unilite.createStore('had520ukrStore',{
					model: 'had510ukrModel',
					uniOpt : {
						isMaster: false,		// 상위 버튼 연결
						editable: true,			// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 'had500ukrService.selectList520'
							,update : 'had500ukrService.update520'
							,create : 'had500ukrService.insert520'
							,destroy: 'had500ukrService.delete520'
							,syncAll: 'had500ukrService.saveAll520'
						}
					},
					loadStoreRecords: function(){
						var param= prevCompanyWin.paramData;
						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function() {
						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);
						if(inValidRecs.length == 0) {
							config = {
								success: function(batch, option) {
									prevCompanyWin.changes = true;
									prevCompanyWin.unmask();
									if(had530_1ukrStore.isDirty())	{
										had530_1ukrStore.saveStore();
									} else if(had530_2ukrStore.isDirty())	{
										had530_2ukrStore.saveStore();
									}
								}
							};
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('had520ukrGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}
				});
				
				Unilite.defineModel('had530ukrModel', {
					fields: [
						{name: 'YEAR_YYYY'			, text: '정산년도'				, type: 'string', allowBlank:false},
						{name: 'PERSON_NUMB'		, text: '사번'					, type: 'string', allowBlank:false},
						{name: 'GIFT_CODE'			, text: '기부금코드'			, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H119'},
						{name: 'GIFT_YYYY'			, text: '기부년도'				, type: 'string', allowBlank:false},
						{name: 'DDUC_PSBL_PRD'		, text: '공제가능기간'		  , type: 'int', defaultValue:0},
						{name: 'GIFT_AMOUNT_I'		, text: '기부금액'				, type: 'uniPrice'},
						{name: 'BF_DDUC_I'			, text: '전년까지 공제된 금액'  , type: 'uniPrice'},
						{name: 'DDUC_OBJ_I'			, text: '공제대상금액'			, type: 'uniPrice'}
					]
				});

				var had530_1ukrStore = Unilite.createStore('had530_1ukrStore',{
					model: 'had530ukrModel',
					uniOpt : {
						isMaster: false,			// 상위 버튼 연결
						editable: true,		// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 'had500ukrService.selectList530_1'
							,update : 'had500ukrService.update530_1'
							,create : 'had500ukrService.insert530_1'
							,destroy: 'had500ukrService.delete530_1'
							,syncAll: 'had500ukrService.saveAll530_1'
						}
					},
					loadStoreRecords: function(){
						var param= prevCompanyWin.paramData;
						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function() {
						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);
						if(inValidRecs.length == 0) {
							config = {
								success: function(batch, option) {
									prevCompanyWin.changes = true;
									prevCompanyWin.unmask();
									if(had530_2ukrStore.isDirty())	{
										had530_2ukrStore.saveStore();
									}
								}
							};
							prevCompanyWin.mask();
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('had530_1ukrGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}
				});
				var had530_2ukrStore = Unilite.createStore('had530_2ukrStore',{
					model: 'had530ukrModel',
					uniOpt : {
						isMaster: false,			// 상위 버튼 연결
						editable: true,		// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 'had500ukrService.selectList530_2'
							,update : 'had500ukrService.update530_2'
							,create : 'had500ukrService.insert530_2'
							,destroy: 'had500ukrService.delete530_2'
							,syncAll: 'had500ukrService.saveAll530_2'
						}
					},
					loadStoreRecords: function(){
						var param= prevCompanyWin.paramData;
						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function() {
						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);

						if(inValidRecs.length == 0) {
							config = {
								success: function(batch, option) {
									prevCompanyWin.changes = true;
									prevCompanyWin.unmask();
								}
							};
							prevCompanyWin.mask();
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('had530_2ukrGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}
				});
				
				prevCompanyWin = Ext.create('widget.uniDetailWindow', {
					title: '종(전)근무지내역등록',
					width: 1000,
					height:830,
					layout: {type:'vbox', align:'stretch'},
					items: [{
						itemId:'search',
						xtype:'uniSearchForm',
						 style:{
							'background':'#fff'
						},
						height:40,
						layout:{type:'uniTable', columns:5},
						margine:'3 3 3 3',
						items:[{
							fieldLabel: '정산년도',
							name:'YEAR_YYYY',
							xtype: 'uniYearField',
							readOnly:true,
							width:150,
							labelWidth:80
						},{
							fieldLabel: '성명',
							name:'NAME',
							readOnly:true,
							width:150,
							labelWidth:50
						},{
							fieldLabel: '사번',
							name:'PERSON_NUMB',
							readOnly:true,
							width:200,
							labelWidth:50
						},{
							fieldLabel: '부서',
							name:'DEPT_NAME',
							readOnly:true,
							width:200,
							labelWidth:50
						},{
							fieldLabel: '직위',
							name:'POST_CODE_NAME',
							readOnly:true,
							width:150,
							labelWidth:50
						}]
					},{
								xtype:'uniDetailForm',
								itemId:'had500Form',
								disabled:false,
								height:800,
								api:{
									load:had500ukrService.select,
									submit:had500ukrService.syncMaster
								},
								layout: {type:'uniTable', columns:2,  tdAttrs:{'width':'500'}},
								items:[{
										xtype:'container',
										layout: {type:'uniTable', columns:2},
										defaults:{
											xtype:'uniTextfield',
											width:270,
											labelWidth:140
										},
										margin:5 ,

										items:[
											{
												xtype:'component',
												colspan:2,
												html:'<div style="color:#0000FF">[종전근무지1]</div>'
											},
											{
												fieldLabel:'회사명',
												name:'P1_COMPANY_NAME',
												holdable: 'hold',
												colspan:2,
												width:365
											},{
												fieldLabel:'사업자번호',
												name:'P1_COMPANY_NUM',
												holdable: 'hold',
												colspan:2,
												width:365,
												listeners : {
													blur: function( field, The, eOpts )	{
														  var newValue = field.getValue().replace(/-/g,'');
														  if(!Ext.isEmpty(newValue) && !Ext.isNumeric(newValue))	{
															  alert(Msg.sMB074);
															 field.setValue(field.originalValue);
															 return;
														 }
														  if(!Ext.isEmpty(newValue) && !(field.originalValue == field.getValue()) )	{
															  if(Ext.isNumeric(newValue)) {
																var a = newValue;
																var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
																if(a.length == 10){
																	field.setValue(i);
																}else{
																	field.setValue(a);
																}

															 }

															  if(Unilite.validate('bizno', newValue) != true)	{
																 if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
																	 field.setValue(field.originalValue);
																 }
															 }
														  }

													  }
												}
											},{
												fieldLabel:'근무기간',
												xtype:'uniDateRangefield',
												startFieldName:'P1_WORKDATE_FR',
												endFieldName:'P1_WORKDATE_TO',
												holdable: 'hold',
												colspan:2,
												width:365
											},{
												fieldLabel:'세액감면기간',
												xtype:'uniDateRangefield',
												startFieldName:'P1_NONTAX_FR',
												endFieldName:'P1_NONTAX_TO',
												holdable: 'hold',
												colspan:2,
												width:365
											},{
												fieldLabel:'중소기업취업감면',
												name:'P1_EXEMP_RATE',
												xtype:'uniCombobox',
												comboType:'AU',
												comboCode:'H179',
												holdable: 'hold',
												colspan:2,
												width:365
											},{
												fieldLabel:'급여총액',
												name:'P1_PAY_TOTAL_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0
											},{
												fieldLabel:'건강보험',
												name:'P1_MEDICAL_INSUR_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												width:200,
												labelWidth:70
											},{
												fieldLabel:'상여총액',
												name:'P1_BONUS_I_TOTAL_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0
											},{
												fieldLabel:'고용보험',
												name:'P1_HIRE_INSUR_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												width:200,
												labelWidth:70
											},{
												fieldLabel:'인정상여',
												name:'P1_ADD_BONUS_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0
											},{
												fieldLabel:'국민연금',
												name:'P1_ANU_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												width:200,
												labelWidth:70
											},{
												fieldLabel:'주식매수선택권행사이익',
												name:'P1_STOCK_BUY_PROFIT_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0
											},{
												fieldLabel:'결정소득세',
												name:'P1_IN_TAX_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												width:200,
												labelWidth:70
											},{
												fieldLabel:'우리사주조합인출금',
												name:'P1_OWNER_STOCK_DRAW_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0
											},{
												fieldLabel:'결정주민세',
												name:'P1_LOCAL_TAX_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												width:200,
												labelWidth:70
											},{
												fieldLabel:'임원퇴직한도초과액',
												name:'P1_OF_RETR_OVER_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0
											},{
												fieldLabel:'농특세',
												name:'P1_SP_TAX_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												width:200,
												labelWidth:70
											},{
												fieldLabel:'직무발명보상금과세분',
												name:'P1_TAX_INVENTION_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												colspan:2
											},{
												xtype:'component',
												colspan:2,
												html:'<div style="color:#0000FF">[비과세소득1]</div>'
											},
											{
												colspan:2,
												width:480,
												height:150,
												xtype:'container',
												layout: {type:'vbox', align:'stretch'},
												items:[
												//비과세소득1
													Unilite.createGrid('had510ukrGrid', {
														layout : 'fit',
														store : had510ukrStore,
														sortableColumns: false,
														uniOpt:{
															expandLastColumn: false,	//마지막 컬럼 * 사용 여부
															useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
															useLiveSearch: false,		//찾기 버튼 사용 여부
															filter: {					//필터 사용 여부
																useFilter: false,
																autoCreate: false
															},
															state: {
																useState: false,			//그리드 설정 버튼 사용 여부
																useStateList: false		//그리드 설정 목록 사용 여부
															},
															userToolbar :false
														},
														rbar: [
															{
																xtype:'button',
																width:60,
																text:'추가',
																itemId: 'btnPrevPopGrid1Add',
																handler:function()	{
																	var form = prevCompanyWin.down('#search');
																	var grid = Ext.getCmp('had510ukrGrid');
																	var record = Ext.create(had510ukrStore.model);
																	rIndex = had510ukrStore.count();
																	record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
																	record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
																	had510ukrStore.insert(rIndex, record);
																	grid.getSelectionModel().select(rIndex);
																	var columns = grid.getVisibleColumns();
																	var	sCell = grid.getView().getCell(record, columns[0], true);
																	
																	if(sCell)	{
																		Ext.fly(sCell).focus();
																	}
																}
															},{
																xtype:'button',
																text:'삭제',
																itemId: 'btnPrevPopGrid1Del',
																handler:function()	{
																	var grid = Ext.getCmp('had510ukrGrid');
																	had510ukrStore.remove(grid.getSelectionModel().getSelection());
																}
															}
														],
														columns:  [
															{dataIndex: 'NONTAX_CODE'		, width: 150,
																editor:Unilite.popup('NONTAX_CODE_G', {
																	textFieldName:'NONTAX_CODE',
			  														autoPopup: true,
																	listeners:{
																		onSelected:function(records, type)	{
																			if(records)	{
																				var grid = Ext.getCmp('had510ukrGrid');
																				var record = grid.uniOpt.currentRecord;
																				record.set('NONTAX_CODE', records[0].NONTAX_CODE);
																				record.set('NONTAX_CODE_NAME', records[0].NONTAX_CODE_NAME);
																			}
																		},
																		onClear:function()	{
																			var grid = Ext.getCmp('had510ukrGrid');
																			var record = grid.uniOpt.currentRecord;
																			record.set('NONTAX_CODE', '');
																			record.set('NONTAX_CODE_NAME', '');
																		},
																		applyextparam:function(popup)	{
																			popup.extParam.PAY_YM_FR = prevCompanyWin.paramData.YEAR_YYYY;
																		}
																	}
																})
															},
															{dataIndex: 'TAX_EXEMPTION_I'	, flex: 1}
														],
														listeners:{
															beforeedit : function( editor, e, eOpts ) {
																if(gbCloseYn) {
																	return false;	
																}
																if(!e.record.phantom && UniUtils.indexOf(e.field, ['NONTAX_CODE','NONTAX_CODE_NAME'])) {
																	return false;
																}
																return true;
															}
														}
													})
												]
											},{
												xtype:'component',
												colspan:2,
												html:'<div style="color:#0000FF">[기부금이월내역1]</div>'
											},{
												colspan:2,
												width:480,
												height:150,
												xtype:'container',
												layout: {type:'vbox', align:'stretch'},
												items:[
												//기부금이월내역1
													Unilite.createGrid('had530_1ukrGrid', {
														layout : 'fit',
														store : had530_1ukrStore,
														sortableColumns: false,
														uniOpt:{
															expandLastColumn: false,	//마지막 컬럼 * 사용 여부
															useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
															useLiveSearch: false,		//찾기 버튼 사용 여부
															filter: {					//필터 사용 여부
																useFilter: false,
																autoCreate: false
															},
															state: {
																useState: false,			//그리드 설정 버튼 사용 여부
																useStateList: false		//그리드 설정 목록 사용 여부
															},
															userToolbar :false
														},
														rbar: [
															{
																xtype:'button',
																width:60,
																text:'추가',
																itemId: 'btnPrevPopGrid2Add',
																handler:function()	{
																	var form = prevCompanyWin.down('#search');
																	var grid = Ext.getCmp('had530_1ukrGrid');
																	var record = Ext.create(had530_1ukrStore.model);
																	rIndex = had530_1ukrStore.count();
																	record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
																	record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
																	had530_1ukrStore.insert(rIndex, record);
																	grid.getSelectionModel().select(rIndex);
																	var columns = grid.getVisibleColumns();
																	var	sCell = grid.getView().getCell(record, columns[0], true);
																	
																	if(sCell)	{
																		Ext.fly(sCell).focus();
																	}
																}
															},{
																xtype:'button',
																text:'삭제',
																itemId: 'btnPrevPopGrid2Del',
																handler:function()	{
																	var grid = Ext.getCmp('had530_1ukrGrid');
																	had530_1ukrStore.remove(grid.getSelectionModel().getSelection());
																}
															}
														],
														columns:  [
															{dataIndex: 'GIFT_CODE'		, width: 90},
															{dataIndex: 'GIFT_YYYY', width:80},
															{dataIndex: 'GIFT_AMOUNT_I', width:100},
															{dataIndex: 'DDUC_OBJ_I'	, flex: 1}
														],
														listeners:{
															beforeedit : function( editor, e, eOpts ) {
																if(gbCloseYn) {
																	return false;	
																}
																if(!e.record.phantom && UniUtils.indexOf(e.field, ['GIFT_CODE','GIFT_YYYY'])) {
																	return false;
																}
																return true;
															}
														}
													})
												]
											}
										]
									},{
										xtype:'container',
										layout: {type:'uniTable', columns:2},
										defaults:{
											xtype:'uniTextfield',
											width:270,
											labelWidth:140
										},
										margin:5 ,
										items:[
											{
												xtype:'component',
												colspan:2,
												html:'<div style="color:#0000FF">[종전근무지2]</div>'
											},
											{
												fieldLabel:'회사명',
												name:'P2_COMPANY_NAME',
												holdable: 'hold',
												colspan:2,
												width:365
											},{
												fieldLabel:'사업자번호',
												name:'P2_COMPANY_NUM',
												holdable: 'hold',
												colspan:2,
												width:365,
												listeners : {
													blur: function( field, The, eOpts )	{
														var newValue = field.getValue().replace(/-/g,'');
														if(!Ext.isEmpty(newValue) && !Ext.isNumeric(newValue))	{
															alert(Msg.sMB074);
															field.setValue(field.originalValue);
															return;
														}
														if(!Ext.isEmpty(newValue) && !(field.originalValue == field.getValue()) )	{
															if(Ext.isNumeric(newValue)) {
																var a = newValue;
																var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
																if(a.length == 10){
																	field.setValue(i);
																}else{
																	field.setValue(a);
																}
															}
															if(Unilite.validate('bizno', newValue) != true)	{
																if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
																	field.setValue(field.originalValue);
																}
															}
														}
													}
												}
											},{
												fieldLabel:'근무기간',
												xtype:'uniDateRangefield',
												startFieldName:'P2_WORKDATE_FR',
												endFieldName:'P2_WORKDATE_TO',
												holdable: 'hold',
												colspan:2,
												width:365
											},{
												fieldLabel:'세액감면기간',
												xtype:'uniDateRangefield',
												startFieldName:'P2_NONTAX_FR',
												endFieldName:'P2_NONTAX_TO',
												holdable: 'hold',
												colspan:2,
												width:365
											},{
												fieldLabel:'중소기업취엽감면',
												name:'P2_EXEMP_RATE',
												xtype:'uniCombobox',
												comboType:'AU',
												comboCode:'H179',
												holdable: 'hold',
												colspan:2,
												width:365
											},{
												fieldLabel:'급여총액',
												name:'P2_PAY_TOTAL_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0
											},{
												fieldLabel:'건강보험',
												name:'P2_MEDICAL_INSUR_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												width:200,
												labelWidth:70
											},{
												fieldLabel:'상여총액',
												name:'P2_BONUS_I_TOTAL_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0
											},{
												fieldLabel:'고용보험',
												name:'P2_HIRE_INSUR_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												width:200,
												labelWidth:70
											},{
												fieldLabel:'인정상여',
												name:'P2_ADD_BONUS_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0
											},{
												fieldLabel:'국민연금',
												name:'P2_ANU_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												width:200,
												labelWidth:70
											},{
												fieldLabel:'주식매수선택권행사이익',
												name:'P2_STOCK_BUY_PROFIT_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0
											},{
												fieldLabel:'결정소득세',
												name:'P2_IN_TAX_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												width:200,
												labelWidth:70
											},{
												fieldLabel:'우리사주조합인출금',
												name:'P2_OWNER_STOCK_DRAW_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0
											},{
												fieldLabel:'결정주민세',
												name:'P2_LOCAL_TAX_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												width:200,
												labelWidth:70
											},{
												fieldLabel:'임원퇴직한도초과액',
												name:'P2_OF_RETR_OVER_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0
											},{
												fieldLabel:'농특세',
												name:'P2_SP_TAX_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												width:200,
												labelWidth:70
											},{
												fieldLabel:'직무발명보상금과세분',
												name:'P2_TAX_INVENTION_I',
												holdable: 'hold',
												xtype:'uniNumberfield',
												value:0,
												colspan:2
											},
											{
												xtype:'component',
												colspan:2,
												html:'<div style="color:#0000FF">[비과세소득2]</div>'
											},
											{
												colspan:2,
												width:480,
												xtype:'container',
												height:150,
												layout: {type:'hbox', align:'stretch'},
												items:[
												//비과세소득2
													Unilite.createGrid('had520ukrGrid', {
														layout : 'fit',
														store : had520ukrStore,
														sortableColumns: false,
														uniOpt:{
															expandLastColumn: false,	//마지막 컬럼 * 사용 여부
															useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
															useLiveSearch: false,		//찾기 버튼 사용 여부
															filter: {					//필터 사용 여부
																useFilter: false,
																autoCreate: false
															},
															state: {
																useState: false,			//그리드 설정 버튼 사용 여부
																useStateList: false		//그리드 설정 목록 사용 여부
															},
															userToolbar :false
														},
														rbar:[
															{
																xtype:'button',
																text:'추가',
																width:60,
																itemId: 'btnPrevPopGrid3Add',
																handler:function()	{
																	var form = prevCompanyWin.down('#search');
																	var grid = Ext.getCmp('had520ukrGrid');
																	var record = Ext.create(had520ukrStore.model);
																	rIndex = had520ukrStore.count();
																	record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
																	record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
																	had520ukrStore.insert(rIndex, record);
																	grid.getSelectionModel().select(rIndex);
																	var columns = grid.getVisibleColumns();
																	var	sCell = grid.getView().getCell(record, columns[0], true);
																	
																	if(sCell)	{
																		Ext.fly(sCell).focus();
																	}
																}
															},{
																xtype:'button',
																text:'삭제',
																width:60,
																itemId: 'btnPrevPopGrid3Del',
																handler:function()	{
																	var grid = Ext.getCmp('had520ukrGrid');
																	had520ukrStore.remove(grid.getSelectionModel().getSelection());
																}
															}
														],
													columns:  [
															{dataIndex: 'NONTAX_CODE'		, width: 150,
																editor:Unilite.popup('NONTAX_CODE_G', {
																	textFieldName:'NONTAX_CODE_NAME',
			  														autoPopup: true,
																	listeners:{
																		onSelected:function(records, type)	{
																			if(records)	{
																				var grid = Ext.getCmp('had520ukrGrid');
																				var record = grid.uniOpt.currentRecord;
																				record.set('NONTAX_CODE', records[0].NONTAX_CODE);
																				record.set('NONTAX_CODE_NAME', records[0].NONTAX_CODE_NAME);
																			}
																		},
																		onClear:function()	{
																			var grid = Ext.getCmp('had520ukrGrid');
																			var record = grid.uniOpt.currentRecord;
																			record.set('NONTAX_CODE', '');
																			record.set('NONTAX_CODE_NAME', '');
																		},
																		applyextparam:function(popup)	{
																			popup.extParam.PAY_YM_FR = prevCompanyWin.paramData.YEAR_YYYY;
																		}
																	}
																})
															},
															{dataIndex: 'TAX_EXEMPTION_I'	, flex: 1}
														],
														listeners:{
															beforeedit : function( editor, e, eOpts ) {
																if(gbCloseYn) {
																	return false;	
																}
																if(!e.record.phantom && UniUtils.indexOf(e.field, ['NONTAX_CODE','NONTAX_CODE_NAME'])) {
																	return false;
																}
																return true;
															}
														}
													})
												]
											},{
												xtype:'component',
												colspan:2,
												html:'<div style="color:#0000FF">[기부금이월내역2]</div>'
											},{
												colspan:2,
												width:480,
												height:150,
												xtype:'container',
												layout: {type:'vbox', align:'stretch'},
												items:[
												//기부금이월내역1
													Unilite.createGrid('had530_2ukrGrid', {
														layout : 'fit',
														store : had530_2ukrStore,
														sortableColumns: false,
														uniOpt:{
															expandLastColumn: false,	//마지막 컬럼 * 사용 여부
															useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
															useLiveSearch: false,		//찾기 버튼 사용 여부
															filter: {					//필터 사용 여부
																useFilter: false,
																autoCreate: false
															},
															state: {
																useState: false,			//그리드 설정 버튼 사용 여부
																useStateList: false		//그리드 설정 목록 사용 여부
															},
															userToolbar :false
														},
														rbar: [
															{
																xtype:'button',
																width:60,
																text:'추가',
																itemId: 'btnPrevPopGrid4Add',
																handler:function()	{
																	var form = prevCompanyWin.down('#search');
																	var grid = Ext.getCmp('had530_2ukrGrid');
																	var record = Ext.create(had530_2ukrStore.model);
																	rIndex = had530_2ukrStore.count();
																	record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
																	record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
																	had530_2ukrStore.insert(rIndex, record);
																	grid.getSelectionModel().select(rIndex);
																	var columns = grid.getVisibleColumns();
																	var	sCell = grid.getView().getCell(record, columns[0], true);
																	
																	if(sCell)	{
																		Ext.fly(sCell).focus();
																	}
																}
															},{
																xtype:'button',
																text:'삭제',
																itemId: 'btnPrevPopGrid4Del',
																handler:function()	{
																	var grid = Ext.getCmp('had530_2ukrGrid');
																	had530_2ukrStore.remove(grid.getSelectionModel().getSelection());
																}
															}
														],
														columns:  [
															{dataIndex: 'GIFT_CODE'		, width: 90},
															{dataIndex: 'GIFT_YYYY', width:80},
															{dataIndex: 'GIFT_AMOUNT_I', width:100},
															{dataIndex: 'DDUC_OBJ_I'	, flex: 1}
														],
														listeners:{
															beforeedit : function( editor, e, eOpts ) {
																if(gbCloseYn) {
																	return false;	
																}
																if(!e.record.phantom && UniUtils.indexOf(e.field, ['GIFT_CODE','GIFT_YYYY'])) {
																	return false;
																}
																return true;
															}
														}
													})
												]
											}
										]
									}
								]
							}
					],
					bbar:{
						layout: {
							pack: 'center',
							type: 'hbox'
						},
						dock:'bottom',
						items :  [
							{
								itemId : 'deleteBtn',
								text: '전체삭제',
								width:100,
								itemId: 'btnPrevPopDelAll',
								handler: function() {
									var searchForm =  prevCompanyWin.down('#search');
									prevCompanyWin.mask();
									had500ukrService.deleteAll(searchForm.getValues(), function(){
										prevCompanyWin.unmask();
										prevCompanyWin.hide();
									})
								}
							},
							{
								itemId : 'submitBtn',
								text: '저장',
								width:100,
								itemId: 'btnPrevPopSaveAll',
								handler: function() {
									var had500Form =  prevCompanyWin.down('#had500Form');
									if( had500Form.isDirty())		  {
										var searchForm =  prevCompanyWin.down('#search');
										prevCompanyWin.mask();
										had500Form.submit({
											params: searchForm.getValues(),
											success:function()	{
												Unilite.messageBox('저장되었습니다.');
												prevCompanyWin.unmask();
												had500Form.resetDirtyStatus();
												prevCompanyWin.changes = true;
											},
											failure:function()	{
												prevCompanyWin.unmask();
											}
										});
									}
									if( had510ukrStore.isDirty())	 had510ukrStore.saveStore();
									else if( had520ukrStore.isDirty())	 had520ukrStore.saveStore();
									else if( had530_1ukrStore.isDirty()) had530_1ukrStore.saveStore();
									else if( had530_2ukrStore.isDirty()) had530_2ukrStore.saveStore();
								}
							},{
								itemId : 'closeBtn',
								text: '닫기',
								width:100,
								handler: function() {
									var had500Form =  prevCompanyWin.down('#had500Form');
									if(had500Form.isDirty() || had510ukrStore.isDirty() ||
										had520ukrStore.isDirty() || had530_1ukrStore.isDirty() ||
										had530_2ukrStore.isDirty()
									) {
										if(confirm("변경된 내용이 있습니다. 저장하시겠습니까?"))	{
											if( had500Form.isDirty())		  {
												var searchForm =  prevCompanyWin.down('#search');
												prevCompanyWin.mask();
												had500Form.submit({
													params: searchForm.getValues(),
													success:function()	{
														prevCompanyWin.unmask();
														prevCompanyWin.changes = true;
													},
													failure:function()	{
														prevCompanyWin.unmask();
													}
												});
											}
											if( had510ukrStore.isDirty())	 {
												had510ukrStore.saveStore();
											} else if( had520ukrStore.isDirty())	 {
												had520ukrStore.saveStore();
											} else if( had530_1ukrStore.isDirty()) {
												had530_1ukrStore.saveStore();
											} else if( had530_2ukrStore.isDirty()) {
												had530_2ukrStore.saveStore();
											}
										} else {
											prevCompanyWin.hide();
										}
									}
									prevCompanyWin.hide();
								},
								disabled: false
							}
						]
					},
					listeners : {
						beforehide: function(me, eOpt)	{
							prevCompanyWin.down('#search').clearForm();
							if(prevCompanyWin.changes) {
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
							prevCompanyWin.down('#had500Form').setValue('P1_EXEMP_RATE', '');
							prevCompanyWin.down('#had500Form').setValue('P2_EXEMP_RATE', '');
						},
						beforeclose: function( panel, eOpts )	{
							prevCompanyWin.down('#search').clearForm();
							if(prevCompanyWin.changes) {
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
							prevCompanyWin.down('#had500Form').setValue('P1_EXEMP_RATE', '');
							prevCompanyWin.down('#had500Form').setValue('P2_EXEMP_RATE', '');
						},
						show: function( panel, eOpts )	{
							var searchForm =  prevCompanyWin.down('#search');
							searchForm.setValue("YEAR_YYYY"		,prevCompanyWin.paramData.YEAR_YYYY);
							searchForm.setValue("NAME"			,prevCompanyWin.paramData.NAME);
							searchForm.setValue("PERSON_NUMB"	,prevCompanyWin.paramData.PERSON_NUMB);
							searchForm.setValue("DEPT_NAME"		,prevCompanyWin.paramData.DEPT_NAME);
							searchForm.setValue("POST_CODE_NAME",prevCompanyWin.paramData.POST_CODE_NAME);
							
							var form =  prevCompanyWin.down('#had500Form');
							form.uniOpt.inLoading = true;
							form.load({
								params:searchForm.getValues(),
								success: function()	{
									form.uniOpt.inLoading = false;
								},
								failure: function() {
									form.uniOpt.inLoading = false;
								}
							});
							had510ukrStore.loadStoreRecords();
							had520ukrStore.loadStoreRecords();
							had530_1ukrStore.loadStoreRecords();
							had530_2ukrStore.loadStoreRecords();
							
							prevCompanyWin.setCloseForm();
						}
					},
					setCloseForm : function() {
						var form  =  prevCompanyWin.down('#had500Form');
							if(form)	{
							var fields = form.getForm().getFields();
							
							Ext.each(fields.items, function(item){
								if(item.isPopupField) {
									var fc = item.up('uniPopupField');
									if(fc.holdable == 'hold') {
										fc.setReadOnly(gbCloseYn);
									}
								}
								else {
									if(item.holdable == 'hold') {
										item.setReadOnly(gbCloseYn);
									}
								}
							});
							
							this.down('#btnPrevPopGrid1Add').setDisabled(gbCloseYn);
							this.down('#btnPrevPopGrid1Del').setDisabled(gbCloseYn);
							this.down('#btnPrevPopGrid2Add').setDisabled(gbCloseYn);
							this.down('#btnPrevPopGrid2Del').setDisabled(gbCloseYn);
							this.down('#btnPrevPopGrid3Add').setDisabled(gbCloseYn);
							this.down('#btnPrevPopGrid3Del').setDisabled(gbCloseYn);
							this.down('#btnPrevPopGrid4Add').setDisabled(gbCloseYn);
							this.down('#btnPrevPopGrid4Del').setDisabled(gbCloseYn);
							
							prevCompanyWin.down('#btnPrevPopDelAll').setDisabled(gbCloseYn);
							prevCompanyWin.down('#btnPrevPopSaveAll').setDisabled(gbCloseYn);
						}
					}
				});
			}
			prevCompanyWin.paramData = paramData;
			prevCompanyWin.center();
			prevCompanyWin.show();
		},
		//납세조합내역 입력
		openTaxCommunity:function() {
			if(!panelResult.isValid()) {
				return;
			}
			var paramData = {
				'YEAR_YYYY'			: panelResult.getValue('YEAR_YYYY'),
				'PERSON_NUMB'		: panelResult.getValue('PERSON_NUMB'),
				'NAME'				: panelResult.getValue('NAME'),
				'DEPT_NAME'			: panelResult.getValue('DEPT_NAME'),
				'POST_CODE_NAME'	: panelResult.getValue('POST_NAME')
			};

			if(!taxCommunityWin) {
				taxCommunityWin= Ext.create('widget.uniDetailWindow', {
					title: '납세조합내역등록',
					width: 400,
					height:450,
					layout: {type:'vbox', align:'stretch'},
					items: [{
						itemId:'search',
						xtype:'uniSearchForm',
						style:{
							'background':'#fff'
						},
						height:100,
						layout:{type:'uniTable', columns:2},
						defaults:{
							width:185,
							labelWidth:60
						},
						margine:'3 3 3 3',
						items:[{
							fieldLabel: '정산년도',
							name:'YEAR_YYYY',
							xtype: 'uniYearField',
							readOnly:true
						},{
							fieldLabel: '성명',
							name:'NAME',
							readOnly:true,
							labelWidth:40
						},{
							fieldLabel: '사번',
							name:'PERSON_NUMB',
							readOnly:true
						},{
							fieldLabel: '부서',
							name:'DEPT_NAME',
							readOnly:true,
							labelWidth:40
						},{
							fieldLabel: '직위',
							name:'POST_CODE_NAME',
							readOnly:true
						}]
					},{
						xtype:'uniDetailForm',
						itemId:'had620NapForm',
						disabled:false,
						height:340,
						api:{
							load:had620ukrService.selectNap,
							submit:had620ukrService.napSyncMaster
						},
						layout: {type:'uniTable', columns:1,  tdAttrs:{'width':'400'}},
						items:[{
							xtype:'component',
							html:'<div style="color:#0000FF">[납세조합]</div>'
						},{
							fieldLabel:'회사명',
							name:'P3_COMPANY_NAME',
							holdable: 'hold',
							width:315
						},{
							fieldLabel:'사업자번호',
							name:'P3_COMPANY_NUM',
							holdable: 'hold',
							width:315,
							listeners : {
								blur: function( field, The, eOpts )	{
									var newValue = field.getValue().replace(/-/g,'');
									if(!Ext.isEmpty(newValue) && !Ext.isNumeric(newValue))	{
										Unilite.messageBox(Msg.sMB074);
										field.setValue(field.originalValue);
										return;
									}
									if(!Ext.isEmpty(newValue) && !(field.originalValue == field.getValue()) )	{
										if(Ext.isNumeric(newValue)) {
											var a = newValue;
											var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
											if(a.length == 10){
												field.setValue(i);
											} else {
												field.setValue(a);
											}
										}
										if(Unilite.validate('bizno', newValue) != true)	{
											if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
												field.setValue(field.originalValue);
											}
										}
									}
								}
							}
						},{
							fieldLabel:'근무기간',
							xtype:'uniDateRangefield',
							startFieldName:'P3_WORKDATE_FR',
							endFieldName:'P3_WORKDATE_TO',
							holdable: 'hold',
							width:365
						},{
							fieldLabel:'세액감면기간',
							xtype:'uniDateRangefield',
							startFieldName:'P3_NONTAX_FR',
							endFieldName:'P3_NONTAX_TO',
							holdable: 'hold',
							width:365
						},{
							fieldLabel:'급여총액',
							name:'P3_PAY_TOTAL_I',
							holdable: 'hold',
							xtype:'uniNumberfield',
							value:0
						},{
							fieldLabel:'상여총액',
							name:'P3_BONUS_I_TOTAL_I',
							holdable: 'hold',
							xtype:'uniNumberfield',
							value:0
						},{
							fieldLabel:'소득세',
							name:'P3_IN_TAX_I',
							holdable: 'hold',
							xtype:'uniNumberfield',
							value:0
						},{
							fieldLabel:'주민세',
							name:'P3_LOCAL_TAX_I',
							holdable: 'hold',
							xtype:'uniNumberfield',
							value:0
						},{
							fieldLabel:'농특세',
							name:'P3_SP_TAX_I',
							holdable: 'hold',
							xtype:'uniNumberfield',
							value:0
						}]
					}],
					bbar:{
						layout: {
							pack: 'center',
							type: 'hbox'
						},
						dock:'bottom',
						items : [{
							itemId : 'deleteBtn',
							text: '전체삭제',
							width:80,
							itemId: 'btnTaxComPopDelAll',
							handler: function() {
								var searchForm =  taxCommunityWin.down('#search');
								taxCommunityWin.mask();
								had620ukrService.napDeleteAll(searchForm.getValues(), function(){
									taxCommunityWin.unmask();
									taxCommunityWin.hide();
								})
							}
						},{
							itemId : 'submitBtn',
							text: '저장',
							width:80,
							itemId: 'btnTaxComPopSaveAll',
							handler: function() {
								var had620NapForm =  taxCommunityWin.down('#had620NapForm');
								if( had620NapForm.isDirty())		  {
									var searchForm =  taxCommunityWin.down('#search');
									taxCommunityWin.mask();
									had620NapForm.submit({
										params: searchForm.getValues(),
										success:function()	{
											//Unilite.messageBox('저장되었습니다.');
											taxCommunityWin.changes = true;
											taxCommunityWin.unmask();
											had620NapForm.resetDirtyStatus();
										},
										failure:function()	{
											taxCommunityWin.unmask();
										}
									});
								}
							}
						},{
							itemId : 'closeBtn',
							text: '닫기',
							width:80,
							handler: function() {
								var had620NapForm =  taxCommunityWin.down('#had620NapForm');
								if(had620NapForm.isDirty() )	{
									if(confirm('변경된 내용이 있습니다.'+'\n'+ '저장하시겠습니까?'))	{
										var searchForm =  taxCommunityWin.down('#search');
										taxCommunityWin.mask();
										had620NapForm.submit({
											params: searchForm.getValues(),
											success:function()	{
												taxCommunityWin.changes=true;
												taxCommunityWin.unmask();
											},
											failure:function()	{
												taxCommunityWin.unmask();
											}
										});
									} else {
										taxCommunityWin.hide();
									}
								}
								taxCommunityWin.hide();
							},
							disabled: false
						}]
					},
					listeners : {
						beforehide: function(me, eOpt)	{
							taxCommunityWin.down('#search').clearForm();
							if(taxCommunityWin.changes) {
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
						},
						beforeclose: function( panel, eOpts )	{
							taxCommunityWin.down('#search').clearForm();
							if(taxCommunityWin.changes) {
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
						},
						show: function( panel, eOpts )	{
							var searchForm = taxCommunityWin.down('#search');
							searchForm.setValue("YEAR_YYYY"		,taxCommunityWin.paramData.YEAR_YYYY);
							searchForm.setValue("NAME"			,taxCommunityWin.paramData.NAME);
							searchForm.setValue("PERSON_NUMB"	,taxCommunityWin.paramData.PERSON_NUMB);
							searchForm.setValue("DEPT_NAME"		,taxCommunityWin.paramData.DEPT_NAME);
							searchForm.setValue("POST_CODE_NAME",taxCommunityWin.paramData.POST_CODE_NAME);
							var form =  taxCommunityWin.down('#had620NapForm');
							
							form.uniOpt.inLoading = true;
							form.load({
								params:searchForm.getValues(),
								success: function()	{
									form.uniOpt.inLoading = false;
								},
								failure: function(form, action) {
									form.uniOpt.inLoading = false;
								}
							});
							taxCommunityWin.setCloseForm();
						}
					},
					setCloseForm : function() {
						var form = taxCommunityWin.down('#had620NapForm');
						if(form)	{
							var fields = form.getForm().getFields();
							
							Ext.each(fields.items, function(item){
								if(item.isPopupField) {
									var fc = item.up('uniPopupField');
									if(fc.holdable == 'hold') {
										fc.setReadOnly(gbCloseYn);
									}
								}
								else {
									if(item.holdable == 'hold') {
										item.setReadOnly(gbCloseYn);
									}
								}
							});
						
							taxCommunityWin.down('#btnTaxComPopDelAll').setDisabled(gbCloseYn);
							taxCommunityWin.down('#btnTaxComPopSaveAll').setDisabled(gbCloseYn);
						}
					}
				});
			}
			taxCommunityWin.paramData = paramData;
			taxCommunityWin.center();
			taxCommunityWin.show();
		},
		//부양가족 공제
		openFamily:function(openType, searchForm)	{

			if(!searchForm.isValid())	{
				return;
			}
			var paramData = {
				'YEAR_YYYY'			: searchForm.getValue('YEAR_YYYY'),
				'PERSON_NUMB'		: searchForm.getValue('PERSON_NUMB'),
				'NAME'				: searchForm.getValue('NAME'),
				'DEPT_NAME'			: searchForm.getValue('DEPT_NAME'),
				'POST_CODE_NAME'	: searchForm.getValue('POST_NAME')
			};
			
			if(!familyWin)	{
				Unilite.defineModel('had960ukrModel', {
					fields: [
						{name: 'PERSON_NUMB'			, text: '사번'				, type: 'string', allowBlank:false},
						{name: 'NAME'					, text: '성명'				, type: 'string'},
						{name: 'YEAR_YYYY'				, text: '정산년도'				, type: 'string', allowBlank:false},
						{name: 'FAMILY_NAME'			, text: '성명'				, type: 'string', allowBlank:false},
						{name: 'REPRE_NUM'				, text: '주민등록번호'			, type: 'string', allowBlank:false},
						{name: 'REL_CODE'				, text: '관계코드'				, type: 'string', allowBlank:false, store:Ext.data.StoreManager.lookup("relCodeStore")},

						{name: 'REL_CODE_ORIGIN'		, text: '관계코드_ORIGIN'		, type: 'string'},

						{name: 'IN_FORE'				, text: '내·외국인'				, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H118'},
						{name: 'SEQ_NUM'				, text: '구분'				, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H120'},

						{name: 'DEFAULT_DED_YN'			, text: '기본'				, type: 'bool'},
						{name: 'HOUSEHOLDER_YN'			, text: '세대주'				, type: 'bool'},
						{name: 'DEFORM_DED_YN'			, text: '장애인'				, type: 'bool'},
						{name: 'DEFORM_KIND_CODE'		, text: '장애인구분'				, type: 'string', comboType:'AU', comboCode:'H169'},

						{name: 'BRING_CHILD_DED_YN'		, text: '자녀'				, type: 'bool'},
						{name: 'WOMAN_DED_YN'			, text: '부녀자'				, type: 'bool'},
						{name: 'ONE_PARENT_DED_YN'		, text: '한부모'				, type: 'bool'},
						{name: 'OLD_DED_YN'				, text: '경로우대'				, type: 'bool'},
						{name: 'MANY_CHILD_DED_YN'		, text: '다자녀'				, type: 'bool'},
						{name: 'BIRTH_ADOPT_DED_YN'		, text: '출산입양'				, type: 'bool'},
						{name: 'BIRTH_ADOPT_CODE'		, text: '출산코드'				, type: 'string', comboType:'AU', comboCode:'H206'},

						{name: 'INSUR_CODE'				, text: '보험료구분'				, type: 'string', comboType:'AU', comboCode:'H141'},
						{name: 'INSUR_USE_I'			, text: '보험료'				, type: 'uniPrice', defaultValue:0},
						{name: 'MED_AMOUNT_I'			, text: '건강보험료'				, type: 'uniPrice', defaultValue:0},
						{name: 'HIR_AMOUNT_I'			, text: '고용보험료'				, type: 'uniPrice', defaultValue:0},

						{name: 'MED_USE_I'				, text: '의료비'				, type: 'uniPrice', defaultValue:0},
						{name: 'SURGERY_MED_I'			, text: '난임시술비'				, type: 'uniPrice', defaultValue:0},
						{name: 'SERIOUS_SICK_MED_I'		, text: '장애인·<br/>건보산정특례'	, type: 'uniPrice', defaultValue:0},
						{name: 'EDU_USE_I'				, text: '교육비'				, type: 'uniPrice', defaultValue:0},
						{name: 'DEFORM_EDU_USE_I'		, text: '장애인교육비'			, type: 'uniPrice', defaultValue:0},//20190117 장애인 교육비 추가
						{name: 'FIELD_EDUC_I'			, text: '체험학습비'				, type: 'uniPrice', defaultValue:0},
						{name: 'REAL_LOSS_MED_INSUR_I'	, text: '실손의료보험금'			, type: 'uniPrice', defaultValue:0},
						
						{name: 'EDU_PRINCIPAL_RTN_I'	, text: '학자금원리금상환액'		, type: 'uniPrice', defaultValue:0},
						{name: 'EDU_CODE'				, text: '교육비구분'				, type: 'string', comboType:'AU', comboCode:'H142'},
						{name: 'UNIFORM_USE_I'			, text: '교복구입비'				, type: 'uniPrice', defaultValue:0},

						{name: 'CARD_USE_I'				, text: '계'					, type: 'uniPrice', defaultValue:0	, editable: false},
						{name: 'CARD_USE_I_A'			, text: '3월'				, type: 'uniPrice', defaultValue:0},
						{name: 'CARD_USE_I_B'			, text: '4~7월'				, type: 'uniPrice', defaultValue:0},
						{name: 'CARD_USE_I_C'			, text: '그 외'				, type: 'uniPrice', defaultValue:0},
						{name: 'DEBIT_CARD_USE_I'		, text: '계'					, type: 'uniPrice', defaultValue:0	, editable: false},
						{name: 'DEBIT_CARD_USE_I_A'		, text: '3월'				, type: 'uniPrice', defaultValue:0},
						{name: 'DEBIT_CARD_USE_I_B'		, text: '4~7월'				, type: 'uniPrice', defaultValue:0},
						{name: 'DEBIT_CARD_USE_I_C'		, text: '그 외'				, type: 'uniPrice', defaultValue:0},
						{name: 'INSTITUTE_BILL_I'		, text: '지로납부'				, type: 'uniPrice', defaultValue:0},
						{name: 'CASH_USE_I'				, text: '계'					, type: 'uniPrice', defaultValue:0	, editable: false},
						{name: 'CASH_USE_I_A'			, text: '3월'				, type: 'uniPrice', defaultValue:0},
						{name: 'CASH_USE_I_B'			, text: '4~7월'				, type: 'uniPrice', defaultValue:0},
						{name: 'CASH_USE_I_C'			, text: '그 외'				, type: 'uniPrice', defaultValue:0},
						{name: 'TRA_MARKET_USE_I'		, text: '계'					, type: 'uniPrice', defaultValue:0	, editable: false},
						{name: 'TRA_MARKET_USE_I_A'		, text: '3월'				, type: 'uniPrice', defaultValue:0},
						{name: 'TRA_MARKET_USE_I_B'		, text: '4~7월'				, type: 'uniPrice', defaultValue:0},
						{name: 'TRA_MARKET_USE_I_C'		, text: '그 외'				, type: 'uniPrice', defaultValue:0},
						{name: 'TRAFFIC_USE_I'			, text: '계'					, type: 'uniPrice', defaultValue:0	, editable: false},
						{name: 'TRAFFIC_USE_I_A'		, text: '3월'				, type: 'uniPrice', defaultValue:0},
						{name: 'TRAFFIC_USE_I_B'		, text: '4~7월'				, type: 'uniPrice', defaultValue:0},
						{name: 'TRAFFIC_USE_I_C'		, text: '그 외'				, type: 'uniPrice', defaultValue:0},
						{name: 'GIFT_USE_I'				, text: '기부금'				, type: 'uniPrice', defaultValue:0},

						{name: 'DIVI'					, text: 'DIVI'				, type: 'string'},
						{name: 'LIVE_GUBUN'				, text: '거주구분'				, type: 'string'},

						{name:'BOOK_CONCERT_CARD_I'		, text:'계'					, type:'uniPrice'	,defaultValue:0	, editable: false},
						{name:'BOOK_CONCERT_CARD_I_A'	, text:'3월'					, type:'uniPrice'	,defaultValue:0},
						{name:'BOOK_CONCERT_CARD_I_B'	, text:'4~7월'				, type:'uniPrice'	,defaultValue:0},
						{name:'BOOK_CONCERT_CARD_I_C'	, text:'그 외'					, type:'uniPrice'	,defaultValue:0},
						{name:'BOOK_CONCERT_CASH_I'		, text:'계'					, type:'uniPrice'	,defaultValue:0	, editable: false},
						{name:'BOOK_CONCERT_CASH_I_A'	, text:'3월'					, type:'uniPrice'	,defaultValue:0},
						{name:'BOOK_CONCERT_CASH_I_B'	, text:'4~7월'				, type:'uniPrice'	,defaultValue:0},
						{name:'BOOK_CONCERT_CASH_I_C'	, text:'그 외'					, type:'uniPrice'	,defaultValue:0},
						{name:'BOOK_CONCERT_DEBIT_I'	, text:'계'					, type:'uniPrice'	,defaultValue:0	, editable: false},
						{name:'BOOK_CONCERT_DEBIT_I_A'	, text:'3월'					, type:'uniPrice'	,defaultValue:0},
						{name:'BOOK_CONCERT_DEBIT_I_B'	, text:'4~7월'				, type:'uniPrice'	,defaultValue:0},
						{name:'BOOK_CONCERT_DEBIT_I_C'	, text:'그 외'					, type:'uniPrice'	,defaultValue:0}
					]
				});
				
				var had960ukrStore = Unilite.createStore('had960ukrStore',{
					model: 'had960ukrModel',
					uniOpt : {
						isMaster: false,			// 상위 버튼 연결
						editable: true,		// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 'had960ukrService.selectList'
							,update : 'had960ukrService.update'
							,create : 'had960ukrService.insert'
							,destroy : 'had960ukrService.delete'
							,syncAll: 'had960ukrService.saveAll'
						}
					},
					loadStoreRecords: function(){
						var param= familyWin.paramData;
						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function()	{
						var toCreate = this.getNewRecords();
						var toUpdate = this.getUpdatedRecords();
						var toDelete = this.getRemovedRecords();
						var list = [].concat(toUpdate, toCreate);

						var checkValid = true;
						Ext.each(list, function(record, index) {
							// 비과세분 입력시 비과세 코드 입력 체크
							if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
								Unilite.messageBox(Msg.sMH1065 +'\n'+ Msg.fstMsgH0098);
								checkValid = false;
								return;
							}
							if(record.get('EDU_CODE') =='' && (record.get('EDU_USE_I')+record.get('FIELD_EDUC_I') != 0) ) {
								Unilite.messageBox("교육비 구분을 입력하세요.");
								checkValid = false;
								return;
							}
							if((record.get('BIRTH_ADOPT_DED_YN') =='Y' || record.get('BIRTH_ADOPT_DED_YN') ==true) && (record.get('BIRTH_ADOPT_CODE')== '') ) {
								Unilite.messageBox("출산코드를 입력하세요.");
								checkValid = false;
								return;
							}
						});
						
						if(!checkValid)	{
							return;
						}
						
						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);
						if(inValidRecs.length == 0) {
							config = {
								success: function(batch, option) {
									familyWin.changes = true;
									familyWin.unmask();
									had960ukrStore.loadStoreRecords();
								}
							};
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('had960ukrGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}
				});
				
				familyWin = Ext.create('widget.uniDetailWindow', {
					title : '인적공제항목',
					width : 1280,
					height: 500,
					layout: {type:'vbox', align:'stretch'},
					items : [{
						itemId:'search',
						xtype:'uniSearchForm',
						style:{
							'background':'#fff'
						},
						height:40,
						layout:{type:'uniTable', columns:5},
						margine:'3 3 3 3',
						items:[{
							fieldLabel: '정산년도',
							name:'YEAR_YYYY',
							xtype: 'uniYearField',
							readOnly:true,
							width:150,
							labelWidth:80
						},{
							fieldLabel: '성명',
							name:'NAME',
							readOnly:true,
							width:150,
							labelWidth:50
						},{
							fieldLabel: '사번',
							name:'PERSON_NUMB',
							readOnly:true,
							width:200,
							labelWidth:50
						},{
							fieldLabel: '부서',
							name:'DEPT_NAME',
							readOnly:true,
							width:200,
							labelWidth:50
						},{
							fieldLabel: '직위',
							name:'POST_CODE_NAME',
							readOnly:true,
							width:150,
							labelWidth:50
						}]
					},{
						xtype:'container',
						flex:1,
						layout: {type:'vbox', align:'stretch'},
						items:[
							//기타소득내역
							Unilite.createGrid('had960ukrGrid', {
								layout : 'fit',
								store : had960ukrStore,
								sortableColumns: false,
								itemId:'had960ukrGrid',
								uniOpt:{
									expandLastColumn: false,	//마지막 컬럼 * 사용 여부
									useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
									useLiveSearch: false,		//찾기 버튼 사용 여부
									filter: {					//필터 사용 여부
										useFilter: false,
										autoCreate: false
									},
									state: {
										useState: false,			//그리드 설정 버튼 사용 여부
										useStateList: false		//그리드 설정 목록 사용 여부
									}
								},
								features: [{id : 'gridFamilySubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false},
										   {id : 'gridFamilyTotal',		ftype: 'uniSummary',			showSummaryRow: true }],
								tbar:[
									'->',
									{
										xtype:'button',
										itemId:'familyWin-add',
										text:'추가',
										handler:function()	{
											var form = familyWin.down('#search');
											var grid = Ext.getCmp('had960ukrGrid');
											var record1 = Ext.create(had960ukrStore.model);
											var rIndex = had960ukrStore.count();
											
											record1.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
											record1.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
											record1.set("SEQ_NUM", "1");
											record1.set("DIVI","N");
											
											had960ukrStore.insert(rIndex, record1);
											grid.getSelectionModel().select(rIndex);
											
											var record2 = Ext.create(had960ukrStore.model);
											
											rIndex = rIndex+1;
											record2.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
											record2.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
											record2.set("SEQ_NUM", "2");
											record2.set("DIVI","N");
											
											had960ukrStore.insert(rIndex, record2);
											
											var columns = grid.getVisibleColumns();
											var	sCell = grid.getView().getCell(record1, columns[0], true);
											
											if(sCell)	{
												Ext.fly(sCell).focus();
											}
										}
									},{
										xtype:'button',
										text:'삭제',
										itemId:'familyWin-delete',
										handler:function()	{
											var grid = Ext.getCmp('had960ukrGrid');
											var rowIdx = grid.getSelectedRowIndex();
											var selRecord = grid.getSelection();
											if(selRecord.length > 0) {
												var data = Ext.Array.push(had960ukrStore.data.filterBy(function(record) {return (record.get('REPRE_NUM')== selRecord[0].get('REPRE_NUM') ) } ).items);
												
												had960ukrStore.remove(data);
												if(had960ukrStore.getData().items.length > rowIdx)
													grid.select(rowIdx);
												else
													grid.select(had960ukrStore.getData().items.length - 1);
											}
										}
									},{
										xtype:'button',
										text:'전년도내역 가져오기',
										itemId:'familyWin-lastYear',
										handler:function()	{
											var form = familyWin.down('#search');
											
											had960ukrService.selectChkData(form.getValues(), function(responseText, response){
												if(!Ext.isEmpty(responseText))	{
													if(confirm(Msg.fsbMsgH0360 + "\n단, 전년도내역에서 만20세 이하의 거주자 직계비속은 당해년도 기준으로 조정됩니다."))	{
														had960ukrStore.removeAll();
														had960ukrService.selectLast(form.getValues(), function(responseText, response){
															if(Ext.isEmpty(responseText)) {
																alert(Msg.fsbMsgH0361);
															} else {
																had960ukrStore.add(responseText)
															}
														});
													}
												} else {
													had960ukrStore.removeAll();
													had960ukrService.selectLast(form.getValues(), function(responseText, response){
														if(Ext.isEmpty(responseText)) {
															alert(Msg.fsbMsgH0361);
														} else {
															had960ukrStore.add(responseText)
														}
													});
												}
											});
										}
									}
								],
								columns: [
									{dataIndex: 'FAMILY_NAME'		, width: 60,
										summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
											return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
										}
									},
									{dataIndex: 'REPRE_NUM'			, width: 120},
									{dataIndex: 'REL_CODE'			, width: 120},
									{dataIndex: 'REL_CODE_ORIGIN'	, width: 120,hidden:true},
									{dataIndex: 'IN_FORE'			, width: 70},
									{dataIndex: 'SEQ_NUM'			, width: 90},
									{text:'인적공제항목', id:'info_gr'	, columns:[
										{xtype:'checkcolumn'		, dataIndex: 'DEFAULT_DED_YN'		, width: 50,
											listeners:{
												beforecheckchange:function()	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
												},
												checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
													
													var familyGrid = familyWin.down("#had960ukrGrid");
													familyGrid.fnCheckChange(column.dataIndex, record, checked);
												}
											}
										},
										{xtype:'checkcolumn'		, dataIndex: 'HOUSEHOLDER_YN'		, width: 50,
											listeners:{
												beforecheckchange:function()	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
												},
												checkchange :function(column, rowIndex, checked, record, e, eOpts) {
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
													
													var familyGrid = familyWin.down("#had960ukrGrid");
													familyGrid.fnCheckChange(column.dataIndex, record, checked);
												}
											}
										},
										{xtype:'checkcolumn'	, dataIndex: 'DEFORM_DED_YN'		, width: 50,
											listeners:{
												beforecheckchange:function()	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
												},
												checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
													
													var familyGrid = familyWin.down("#had960ukrGrid");
													familyGrid.fnCheckChange(column.dataIndex, record, checked);
												}
											}
										},
										{dataIndex: 'DEFORM_KIND_CODE'								, width: 90},
										{xtype:'checkcolumn'	, dataIndex: 'BRING_CHILD_DED_YN'	, width: 50,
											listeners:{
												beforecheckchange:function()	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
												},
												checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
													
													var familyGrid = familyWin.down("#had960ukrGrid");
													familyGrid.fnCheckChange(column.dataIndex, record, checked);
												}
											}
										},
										{xtype:'checkcolumn'	, dataIndex: 'WOMAN_DED_YN'			, width: 50,
											listeners:{
												beforecheckchange:function()	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
												},
												checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
													
													var familyGrid = familyWin.down("#had960ukrGrid");
													familyGrid.fnCheckChange(column.dataIndex, record, checked);
												}
											}
										},
										{xtype:'checkcolumn'	, dataIndex: 'ONE_PARENT_DED_YN'	, width: 50,
											listeners:{
												beforecheckchange:function()	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
												},
												checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
													
													var familyGrid = familyWin.down("#had960ukrGrid");
													familyGrid.fnCheckChange(column.dataIndex, record, checked);
												}
											}
										},
										{xtype:'checkcolumn'	, dataIndex: 'OLD_DED_YN'			, width: 70,
											listeners:{
												beforecheckchange:function()	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
												},
												checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
													
													var familyGrid = familyWin.down("#had960ukrGrid");
													familyGrid.fnCheckChange(column.dataIndex, record, checked);
												}
											}
										},
										{xtype:'checkcolumn'	, dataIndex: 'BIRTH_ADOPT_DED_YN'	, width: 70,
											listeners:{
												beforecheckchange:function()	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
												},
												checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
													if(gbCloseYn) return false;
													if(familyWin.openType != 'P')	return false;
													
													var familyGrid = familyWin.down("#had960ukrGrid");
													familyGrid.fnCheckChange(column.dataIndex, record, checked);
												}
											}
										},
										{dataIndex: 'BIRTH_ADOPT_CODE'								, width: 90, flex: 1}
									]},
									{text:'보험료공제', id:'insur_gr', columns:[
										{dataIndex: 'INSUR_CODE'	, width: 90},
										{dataIndex: 'INSUR_USE_I'	, flex:1	, summaryType: 'sum'}
									]},
									{dataIndex: 'MED_USE_I'				, id:'med_gr'	, width:80	, summaryType: 'sum'},
									{dataIndex: 'SURGERY_MED_I'			, id:'med_gr2'	, width:90	, summaryType: 'sum'},
									{dataIndex: 'SERIOUS_SICK_MED_I'	, id:'med_gr3'	, width:100	, summaryType: 'sum'},
									{dataIndex: 'REAL_LOSS_MED_INSUR_I'	, id:'med_gr4'	, flex:1	, summaryType: 'sum'},
									{text:'교육비공제', id:'edu_gr', columns:[
										{dataIndex: 'EDU_CODE'				, width: 90},
										{dataIndex: 'EDU_USE_I'				, width:100	, summaryType: 'sum'},
										{dataIndex: 'DEFORM_EDU_USE_I'		, width:100	, summaryType: 'sum'}, //20190117 장애인 교육비 추가
										{dataIndex: 'FIELD_EDUC_I'			, width:100	, summaryType: 'sum'},
										{dataIndex: 'UNIFORM_USE_I'			, width:100	, summaryType: 'sum'},
										{dataIndex: 'EDU_PRINCIPAL_RTN_I'	, flex:1	, summaryType: 'sum'}
									]},
									{text:'신용카드 등 사용액공제', id:'credit_gr', columns:[
										{text:'신용카드', id:'card_gr_2020', columns:[
											{dataIndex: 'CARD_USE_I'		, width: 90	, summaryType: 'sum'	, tdCls: 'cash_disabled'},
											{dataIndex: 'CARD_USE_I_A'		, width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											},
											{dataIndex: 'CARD_USE_I_B'		, width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											},
											{dataIndex: 'CARD_USE_I_C'		, width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											}
										]},
										{text:'직불카드 등', id:'debit_card_gr_2020', columns:[
											{dataIndex: 'DEBIT_CARD_USE_I'	, width: 90	, summaryType: 'sum'	, tdCls: 'cash_disabled'},
											{dataIndex: 'DEBIT_CARD_USE_I_A', width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											},
											{dataIndex: 'DEBIT_CARD_USE_I_B', width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											},
											{dataIndex: 'DEBIT_CARD_USE_I_C', width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											}
										]},
										{text:'현금영수증', id:'cash_gr_2020', columns:[
											{dataIndex: 'CASH_USE_I'		, width: 90	, summaryType: 'sum'	, tdCls: 'cash_disabled'},
											{dataIndex: 'CASH_USE_I_A'		, width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(record.get('SEQ_NUM') == '2') {
														meta.tdCls = 'cash_disabled';
													}
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											},
											{dataIndex: 'CASH_USE_I_B'		, width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(record.get('SEQ_NUM') == '2') {
														meta.tdCls = 'cash_disabled';
													}
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											},
											{dataIndex: 'CASH_USE_I_C'		, width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(record.get('SEQ_NUM') == '2') {
														meta.tdCls = 'cash_disabled';
													}
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											}
										]},
										{text:'도서 공연비 등', id:'book_concert_gr', columns:[
											{text:'신용카드', id:'book_concert_card_gr_2020', columns:[
												{dataIndex: 'BOOK_CONCERT_CARD_I'	, width: 90	, summaryType: 'sum'	, tdCls: 'cash_disabled'},
												{dataIndex: 'BOOK_CONCERT_CARD_I_A'	, width: 90	, summaryType: 'sum',
													renderer: function(value, meta, record) {
														if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
															meta.tdCls = 'cash_disabled';
														}
														return Ext.util.Format.number(value, UniFormat.Price);
													}
												},
												{dataIndex: 'BOOK_CONCERT_CARD_I_B'	, width: 90	, summaryType: 'sum',
													renderer: function(value, meta, record) {
														if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
															meta.tdCls = 'cash_disabled';
														}
														return Ext.util.Format.number(value, UniFormat.Price);
													}
												},
												{dataIndex: 'BOOK_CONCERT_CARD_I_C'	, width: 90	, summaryType: 'sum',
													renderer: function(value, meta, record) {
														if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
															meta.tdCls = 'cash_disabled';
														}
														return Ext.util.Format.number(value, UniFormat.Price);
													}
												}
											]},
											{text:'직불카드 등', id:'book_concert_debit_gr_2020', columns:[
												{dataIndex: 'BOOK_CONCERT_DEBIT_I'	, width: 90	, summaryType: 'sum'	, tdCls: 'cash_disabled'},
												{dataIndex: 'BOOK_CONCERT_DEBIT_I_A', width: 90	, summaryType: 'sum',
													renderer: function(value, meta, record) {
														if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
															meta.tdCls = 'cash_disabled';
														}
														return Ext.util.Format.number(value, UniFormat.Price);
													}
												},
												{dataIndex: 'BOOK_CONCERT_DEBIT_I_B', width: 90	, summaryType: 'sum',
													renderer: function(value, meta, record) {
														if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
															meta.tdCls = 'cash_disabled';
														}
														return Ext.util.Format.number(value, UniFormat.Price);
													}
												},
												{dataIndex: 'BOOK_CONCERT_DEBIT_I_C', width: 90	, summaryType: 'sum',
													renderer: function(value, meta, record) {
														if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
															meta.tdCls = 'cash_disabled';
														}
														return Ext.util.Format.number(value, UniFormat.Price);
													}
											}
											]},
											{text:'현금영수증', id:'book_concert_cash_gr_2020', columns:[
												{dataIndex: 'BOOK_CONCERT_CASH_I'	, width: 90	, summaryType: 'sum'	, tdCls: 'cash_disabled'},
												{dataIndex: 'BOOK_CONCERT_CASH_I_A'	, width: 90	, summaryType: 'sum',
													renderer: function(value, meta, record) {
														if(record.get('SEQ_NUM') == '2') {
															meta.tdCls = 'cash_disabled';
														}
														if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
															meta.tdCls = 'cash_disabled';
														}
														return Ext.util.Format.number(value, UniFormat.Price);
													}
												},
												{dataIndex: 'BOOK_CONCERT_CASH_I_B'	, width: 90	, summaryType: 'sum',
													renderer: function(value, meta, record) {
														if(record.get('SEQ_NUM') == '2') {
															meta.tdCls = 'cash_disabled';
														}
														if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
															meta.tdCls = 'cash_disabled';
														}
														return Ext.util.Format.number(value, UniFormat.Price);
													}
												},
												{dataIndex: 'BOOK_CONCERT_CASH_I_C'	, width: 90	, summaryType: 'sum',
													renderer: function(value, meta, record) {
														if(record.get('SEQ_NUM') == '2') {
															meta.tdCls = 'cash_disabled';
														}
														if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
															meta.tdCls = 'cash_disabled';
														}
														return Ext.util.Format.number(value, UniFormat.Price);
													}
												}
											]}
										]},
										{text:'전통시장사용분', id:'tra_market_gr_2020', columns:[
											{dataIndex: 'TRA_MARKET_USE_I'	, width: 90	, summaryType: 'sum'	, tdCls: 'cash_disabled'},
											{dataIndex: 'TRA_MARKET_USE_I_A', width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											},
											{dataIndex: 'TRA_MARKET_USE_I_B', width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											},
											{dataIndex: 'TRA_MARKET_USE_I_C', width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											}
										]},
										{text:'대중교통이용분', id:'traffic_gr_2020', columns:[
											{dataIndex: 'TRAFFIC_USE_I'		, width: 90	, summaryType: 'sum'	, tdCls: 'cash_disabled'},
											{dataIndex: 'TRAFFIC_USE_I_A'	, width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											},
											{dataIndex: 'TRAFFIC_USE_I_B'	, width: 90	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											},
											{dataIndex: 'TRAFFIC_USE_I_C'	, flex:1	, summaryType: 'sum',
												renderer: function(value, meta, record) {
													if(UniUtils.indexOf(record.get("REL_CODE"), ['', '6', '7', '8'])) {
														meta.tdCls = 'cash_disabled';
													}
													return Ext.util.Format.number(value, UniFormat.Price);
												}
											}
										]}
									]}
								],
								fnAutoSetSamePerson:function(record, column, newValue) {
									var idx = had960ukrStore.indexOf(record);
									var dRecord = idx%2 == 0 ? had960ukrStore.getAt(idx+1) : had960ukrStore.getAt(idx-1)
									
									if(dRecord)	{
										if(Ext.isDefined(newValue) && dRecord.get(column) != newValue) {
											dRecord.set(column, newValue);
										} else if(dRecord.get(column) != record.get(column)) {
											dRecord.set(column, record.get(column));
										}
									}
								},
								fnClearDedItem:function(record) {
									record.set("DEFAULT_DED_YN", false);
									this.fnAutoSetSamePerson(record, "DEFAULT_DED_YN");
									
									record.set("HOUSEHOLDER_YN", false);
									this.fnAutoSetSamePerson(record, "HOUSEHOLDER_YN");
									
									record.set("DEFORM_DED_YN", false);
									this.fnAutoSetSamePerson(record, "DEFORM_DED_YN");
									
									record.set("DEFORM_KIND_CODE", "");
									this.fnAutoSetSamePerson(record, "DEFORM_KIND_CODE");
									
									record.set("BRING_CHILD_DED_YN", false);
									this.fnAutoSetSamePerson(record, "BRING_CHILD_DED_YN");
									
									record.set("WOMAN_DED_YN", false);
									this.fnAutoSetSamePerson(record, "WOMAN_DED_YN");
									
									record.set("ONE_PARENT_DED_YN", false);
									this.fnAutoSetSamePerson(record, "ONE_PARENT_DED_YN");
									
									record.set("OLD_DED_YN", false);
									this.fnAutoSetSamePerson(record, "OLD_DED_YN");
									
									record.set("MANY_CHILD_DED_YN", false);
									this.fnAutoSetSamePerson(record, "MANY_CHILD_DED_YN");
									
									record.set("BIRTH_ADOPT_DED_YN", false);
									this.fnAutoSetSamePerson(record, "BIRTH_ADOPT_DED_YN");
									
									record.set("BIRTH_ADOPT_CODE", "");
									this.fnAutoSetSamePerson(record, "BIRTH_ADOPT_CODE");
								},
								fnClearDedItem2:function(record) {
									record.set("HOUSEHOLDER_YN", false);
									this.fnAutoSetSamePerson(record, "HOUSEHOLDER_YN");
									
									record.set("DEFORM_DED_YN", false);
									this.fnAutoSetSamePerson(record, "DEFORM_DED_YN");
									
									record.set("DEFORM_KIND_CODE", "");
									this.fnAutoSetSamePerson(record, "DEFORM_KIND_CODE");
									
									record.set("BRING_CHILD_DED_YN", false);
									this.fnAutoSetSamePerson(record, "BRING_CHILD_DED_YN");
									
									record.set("WOMAN_DED_YN", false);
									this.fnAutoSetSamePerson(record, "WOMAN_DED_YN");
									
									record.set("ONE_PARENT_DED_YN", false);
									this.fnAutoSetSamePerson(record, "ONE_PARENT_DED_YN");
									
									record.set("OLD_DED_YN", false);
									this.fnAutoSetSamePerson(record, "OLD_DED_YN");
									
									record.set("MANY_CHILD_DED_YN", false);
									this.fnAutoSetSamePerson(record, "MANY_CHILD_DED_YN");
									
									record.set("BIRTH_ADOPT_DED_YN", false);
									this.fnAutoSetSamePerson(record, "BIRTH_ADOPT_DED_YN");
									
									record.set("BIRTH_ADOPT_CODE", "");
									this.fnAutoSetSamePerson(record, "BIRTH_ADOPT_CODE");
								},
								fnCheckChange:function(field, record, sAfterValue)	{
									var relationCode = record.get("REL_CODE");
									//'성별(주민등록번호에 의해 계산됨)
									var gender	= record.get("REPRE_NUM").replace("-","").substring(6, 7);
									//'나이(주민등록번호에 의해 계산됨)
									var dAge = 0;
									
									if(gender == "3" || gender == "4" || gender == "7" || gender == "8" ) {
										dAge	= parseInt(record.get("YEAR_YYYY")) - parseInt("20" +  record.get("REPRE_NUM").substring(0,2));
									} else {
										dAge	= parseInt(record.get("YEAR_YYYY")) - parseInt("19" +  record.get("REPRE_NUM").substring(0,2));
									}
									
									//'관계코드 필수 체크
									if (relationCode == "" ) {
										if(sAfterValue) {
											Unilite.messageBox(Msg.sMB308);
										} else {
											Unilite.messageBox(sAfterValue);
										}
										
										record.set(field, false);
										this.fnAutoSetSamePerson(record, field)	//같은 소득자의 자료 자동 세팅
										this.getView().refresh();
										
										return;
									}
									
									switch(field)	{
										case "DEFAULT_DED_YN":
											if( relationCode != "0" ){
												this.fnClearDedItem2(record);
											} 
											
											//'case 1) 관계코드 =  본인 → 본인은 항상 "기본공제"
											if( relationCode == "0" ) {
												if( sAfterValue ) {
													record.set(field,true);
													this.fnAutoSetSamePerson(record, field, true);
													this.getView().refresh();
													
													return false;
												}
											}
											
											//case 2) 관계코드 <> 본인 → 공제적용연령 체크 필요
											//						 단, 장애인공제대상이면 공제적용연령 체크 안 함.
											if( record.get("DEFORM_DED_YN") == true && sAfterValue != true ) {
												record.set(field,true);
												this.fnAutoSetSamePerson(record, field, true);
												this.getView().refresh();
												
												return false;
											}
											
											//2-1) 직계존속
											if( relationCode ==  "1" || relationCode == "2" ) {
												
												if( dAge < 60 ){
													Unilite.messageBox("직계존속은 60세 이상만 기본공제 대상자입니다.");
													
													record.set(field, false);
													this.fnAutoSetSamePerson(record, field, false);
													this.getView().refresh();
													
													return;
												}
												
												if( dAge >= 70){
													if(sAfterValue){
													
														record.set('OLD_DED_YN',true);
														this.fnAutoSetSamePerson(record, 'OLD_DED_YN', true);
													}
													else{
														record.set('OLD_DED_YN',false);
														this.fnAutoSetSamePerson(record, 'OLD_DED_YN', false);
													}
												}
											}
											//'2-2) 직계비속, 위탁아동
											else if (relationCode == "4" || relationCode == "5" || relationCode == "8" ) {
												
												if( dAge > 20 ) {
													Unilite.messageBox("직계비속,위탁아동은 20세 이하만 기본공제 대상자입니다.");
													
													record.set(field, false);
													this.fnAutoSetSamePerson(record, field, false);
													this.getView().refresh();
													
													return;
												}
												if(sAfterValue){
													//자녀세액공제
													if(dAge >= 7){
														record.set('BRING_CHILD_DED_YN', true);
														this.fnAutoSetSamePerson(record, 'BRING_CHILD_DED_YN', true);														
													}													
													//출산입양공제
													if( relationCode == "4" || relationCode == "5" ){														
															if(dAge==0){
																record.set('BIRTH_ADOPT_DED_YN', true);
																record.set('BIRTH_ADOPT_CODE','01');
																this.fnAutoSetSamePerson(record, 'BIRTH_ADOPT_DED_YN', true);
																this.fnAutoSetSamePerson(record, 'BIRTH_ADOPT_CODE', '01');
															}														
														}
												}
												else{
														record.set('BRING_CHILD_DED_YN', false);
														record.set('BIRTH_ADOPT_DED_YN', false);
														record.set('BIRTH_ADOPT_CODE','');
														
														this.fnAutoSetSamePerson(record, 'BRING_CHILD_DED_YN', false);
														this.fnAutoSetSamePerson(record, 'BIRTH_ADOPT_DED_YN', false);
														this.fnAutoSetSamePerson(record, 'BIRTH_ADOPT_CODE', '');
													}
												
											//'2-3) 형제자매
											}
											else if( relationCode == "6" ){
												if( dAge > 20 || dAge < 60 ) {
													Unilite.messageBox("형제자매는 20세 이하, 60세 이상만 기본공제 대상자입니다.");
													
													record.set(field, false);
													this.fnAutoSetSamePerson(record, field, false);
													this.getView().refresh();
													
													return;
												}
											}
											
											this.fnAutoSetSamePerson(record, field);
											
											//한부모소득공제 여부체크
											if(sAfterValue && record.get("REL_CODE") == "3"){
												var data = had960ukrStore.getData();
												var message = "";
												
												Ext.each(data.items, function(item, idx){
													if( item.get("ONE_PARENT_DED_YN") == true) {
														message = "배우자공제와 한부모공제는 중복적용 할 수 없습니다.";
													}
												});
												
												if(message != "")	{
													Unilite.messageBox(message);
													
													record.set(field, false);
													this.fnAutoSetSamePerson(record, field, false);
													this.getView().refresh();
													
													return;
												}
											}
										break;
										
										case "HOUSEHOLDER_YN":
											if( relationCode != "0" ) {
												if( sAfterValue  ) {
													Unilite.messageBox("세대주여부는 본인만 체크할 수 있습니다.");
													
													record.set(field,false);
													this.fnAutoSetSamePerson(record, field, false);
													this.getView().refresh();
													
													return;
												}
											}
											else {
												if( sAfterValue ) {
													record.set(field,true);
													this.getView().refresh();
												}
											}
											this.fnAutoSetSamePerson(record, field);
										break;
										
										case "DEFORM_DED_YN":
											//'장애인공제일 경우, 기본공제자 자동 세팅
											if(sAfterValue ) {
												record.set("DEFAULT_DED_YN", true);
											}
											
											if(!sAfterValue) {
												record.set("DEFORM_KIND_CODE", "");
												this.fnAutoSetSamePerson(record, "DEFORM_KIND_CODE", "");
											}
											
											this.fnAutoSetSamePerson(record, field);
											this.fnAutoSetSamePerson(record, "DEFAULT_DED_YN");
										break;
										
										//'자녀세액공제
										case "BRING_CHILD_DED_YN": 
											//'공제적용연령 체크
											var dAgeLimit = 20;		//	7세이상 20세 이하 (7세미만의 취학아동은 포함해야함.)
											var defaultDedYn = record.get('DEFAULT_DED_YN');
											var deformDedYn  = record.get('DEFORM_DED_YN');
											
											if (relationCode != "4" && relationCode != "8" ) {	//	직계비속  입약자, 위탁아동
												if(sAfterValue) {
													Unilite.messageBox('자녀세액공제는 직계비속자녀, 입양자 및 위탁아동만 가능합니다.');
													
													record.set(field, false);
													this.fnAutoSetSamePerson(record, field, false);
													this.getView().refresh();
													
													return;
												}
											}
											
											if(!defaultDedYn) {
												if(sAfterValue) {
													Unilite.messageBox(Msg.fsbMsgH0109);
													
													record.set(field, false);
													this.fnAutoSetSamePerson(record, field, false);
													this.getView().refresh();
													
													return;
												}
											}
											
											if(!deformDedYn) {
												if( dAge < 7 &&  sAfterValue ) {
													Unilite.messageBox('자녀세액공제는 7세이상 자녀만 가능합니다.');
													
													record.set(field, false);
													this.fnAutoSetSamePerson(record, field, false);
													this.getView().refresh();
													
													return;
												}
												if( dAge > 20 &&  sAfterValue ) {
													Unilite.messageBox('자녀세액공제는 20세이하만 가능합니다.');
													
													record.set(field, false);
													this.fnAutoSetSamePerson(record, field, false);
													this.getView().refresh();
													
													return;
												}
											}
											this.fnAutoSetSamePerson(record, field);
										break;
										
										//'부녀자공제
										case "WOMAN_DED_YN"	:
											//본인체크 성별  체크
											if((relationCode != "0" && sAfterValue) || (gender != "2" && gender != "4" && gender != "6" && gender != "8")){
												Unilite.messageBox("부녀자 공제는 본인이면서 여성만 가능합니다.");
												
												record.set(field, false);
												this.fnAutoSetSamePerson(record, field, false);
												this.getView().refresh();
												
												return;
											}	
											//'한부모소득공제 여부체크
											if(record.get("ONE_PARENT_DED_YN") && sAfterValue ) {
												Unilite.messageBox("한부모 소득공제를 받을 경우 부녀자 소득공제를 받을 수 없습니다.");
												
												record.set(field, false);
												this.fnAutoSetSamePerson(record, field, false);
												this.getView().refresh();
												
												return;
											}
											//'소득여건 체크 (2019년도 귀속 연말정산 세법 개정)
											var baseForm400 = Ext.getCmp("baseForm400");
											if(baseForm400.getValue("EARN_INCOME_I") > 30000000) {
												if( sAfterValue  ) {
													Unilite.messageBox("근로소득금액이 3천만원 이하인 경우만 체크할 수 있습니다.");
													
													record.set(field, false);
													this.fnAutoSetSamePerson(record, field, false);
													this.getView().refresh();
													
													return;
												}
											}
											this.fnAutoSetSamePerson(record, field);
										break;
										
										//'한부모소득공제
										case "ONE_PARENT_DED_YN":
											//'관계코드(본인) 체크
											if( relationCode != "0" && sAfterValue) {
												Unilite.messageBox(Msg.fsbMsgH0384);
												
												record.set(field, false);
												this.fnAutoSetSamePerson(record, field, false);
												this.getView().refresh();
												
												return;
											}
											
											if(sAfterValue)		{
												var data = had960ukrStore.getData();
												var message = "";
												
												Ext.each(data.items, function(item, idx){
													if(item.get("REL_CODE") == "3" && item.get("DEFAULT_DED_YN") == true)	{
														message = "배우자공제와 한부모공제는 중복적용 할 수 없습니다.";
													}
												});
												
												if(message != "") {
													Unilite.messageBox(message);
													
													record.set(field, false);
													this.fnAutoSetSamePerson(record, field, false);
													this.getView().refresh();
													
													return;
												}
											}
											
											//'부녀자공제 여부체크
											if( record.get("WOMAN_DED_YN") && sAfterValue) {
												Unilite.messageBox("한부모공제와 부녀자공제는 중복적용이 안되므로 </br> 우선순위인 한부모 공제로 적용됩니다.");
												
												record.set(field, true);
												record.set("WOMAN_DED_YN", false);
												
												this.fnAutoSetSamePerson(record, field, true);
												this.fnAutoSetSamePerson(record, "WOMAN_DED_YN", false);
												this.getView().refresh();
												
												return;
											}
											
											this.fnAutoSetSamePerson(record, field);
										break;
										
										case "OLD_DED_YN"://'경로우대공제
											//'기본공제자 여부 체크
											if( !record.get("DEFAULT_DED_YN") ) {
												Unilite.messageBox(Msg.fsbMsgH0109);
												
												record.set(field, false);
												this.fnAutoSetSamePerson(record, field, false);
												this.getView().refresh();
												
												return;
											}
											//'공제적용연령 체크
											var dAgeLimit = 70;
											if( dAge < dAgeLimit ) {
												Unilite.messageBox(Msg.fsbMsgH0274);
												
												record.set(field, false);
												this.fnAutoSetSamePerson(record, field);
												this.getView().refresh();
												
												return;
											}
											this.fnAutoSetSamePerson(record, field, false);
										break;
										
										//'출산입양자공제
										case "BIRTH_ADOPT_DED_YN":
											//'관계코드체크
											if( relationCode != "4" && relationCode != "8" && sAfterValue) {
												Unilite.messageBox("출산 입양자 공제는 직계비속, 입양자 및 위탁아동만 가능합니다.");
												
												record.set(field, false);
												this.fnAutoSetSamePerson(record, field, false);
												this.getView().refresh();
												
												return;
											}
											//'기본공제자 여부 체크
											if( !record.get("DEFAULT_DED_YN") && sAfterValue ) {
												Unilite.messageBox(Msg.fsbMsgH0109);
												
												record.set(field, false);
												this.fnAutoSetSamePerson(record, field, false);
												this.getView().refresh();
												
												return;
											}
											//'연령체크
											if( dAge != 0  && sAfterValue) {
												Unilite.messageBox(Msg.fsbMsgH0105);
												
												record.set(field, false);
												this.fnAutoSetSamePerson(record, field, false);
												this.getView().refresh();
												
												return;
											}
											if (sAfterValue){
												record.set("BIRTH_ADOPT_CODE", "01");
												this.fnAutoSetSamePerson(record, "BIRTH_ADOPT_CODE", "01");
											}
											else {
												record.set("BIRTH_ADOPT_CODE", "");
												this.fnAutoSetSamePerson(record, "BIRTH_ADOPT_CODE", "");
											}
											this.fnAutoSetSamePerson(record, field);
										break;
										
										default:
										break;
									}
									this.getView().refresh();
								},
								listeners:{
									beforeedit:function(editor, context, eOpts)	{
										if(gbCloseYn) {
											return false;
										}
										
										if(familyWin.openType != 'P' && UniUtils.indexOf(context.field, ['BIRTH_ADOPT_CODE','DEFORM_KIND_CODE','REL_CODE']))	{
											return false;
										}
										if(context.record.get("DIVI") == '' && UniUtils.indexOf(context.field, ['FAMILY_NAME','REPRE_NUM','REL_CODE_ORIGIN','IN_FORE','REL_CODE','SEQ_NUM'])){
											return false;
										}
										if(context.record.get("SEQ_NUM") == '2'  && UniUtils.indexOf(context.field, ['CASH_USE_I_A', 'CASH_USE_I_B', 'CASH_USE_I_C', 'BOOK_CONCERT_CASH_I_A', 'BOOK_CONCERT_CASH_I_B', 'BOOK_CONCERT_CASH_I_C'])){
											return false;
										}
										if(UniUtils.indexOf(context.record.get("REL_CODE"), ['', '6', '7', '8']) && UniUtils.indexOf(context.field, [ 'CARD_USE_I'		, 'DEBIT_CARD_USE_I'	, 'CASH_USE_I'		, 'BOOK_CONCERT_CARD_I'		, 'BOOK_CONCERT_CASH_I'		, 'BOOK_CONCERT_DEBIT_I'	, 'TRA_MARKET_USE_I'	, 'TRAFFIC_USE_I'
																																					, 'CARD_USE_I_A'	, 'DEBIT_CARD_USE_I_A'	, 'CASH_USE_I_A'	, 'BOOK_CONCERT_CARD_I_A'	, 'BOOK_CONCERT_CASH_I_A'	, 'BOOK_CONCERT_DEBIT_I_A'	, 'TRA_MARKET_USE_I_A'	, 'TRAFFIC_USE_I_A'
																																					, 'CARD_USE_I_B'	, 'DEBIT_CARD_USE_I_B'	, 'CASH_USE_I_B'	, 'BOOK_CONCERT_CARD_I_B'	, 'BOOK_CONCERT_CASH_I_B'	, 'BOOK_CONCERT_DEBIT_I_B'	, 'TRA_MARKET_USE_I_B'	, 'TRAFFIC_USE_I_B'
																																					, 'CARD_USE_I_C'	, 'DEBIT_CARD_USE_I_C'	, 'CASH_USE_I_C'	, 'BOOK_CONCERT_CARD_I_C'	, 'BOOK_CONCERT_CASH_I_C'	, 'BOOK_CONCERT_DEBIT_I_C'	, 'TRA_MARKET_USE_I_C'	, 'TRAFFIC_USE_I_C']))	{
											return false;
										}
										if((context.record.get("REL_CODE") == '1' || context.record.get("REL_CODE") == '2') && UniUtils.indexOf(context.field, ['EDU_USE_I', 'EDU_CODE']))	{
											return false;
										}
									}
								}
							})
						]}
					],
					bbar:{
						layout: {
							pack: 'center',
							type: 'hbox'
						},
						dock:'bottom',
						items : [{
							itemId : 'submitBtn',
							text: '저장',
							width:100,
							handler: function() {
								var store = Ext.data.StoreManager.lookup('had960ukrStore') ;
								if(store.isDirty())	{
									store.saveStore();
								}
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							width:100,
							handler: function() {
								
								var store = Ext.data.StoreManager.lookup('had960ukrStore') ;
								if(store.isDirty())	{
									if(confirm("저징할 내용이 있습니다. 저장하시겠습니까?"))	{
										store.saveStore();
										return;
									}
								}
								familyWin.hide();
							},
							disabled: false
						}]
					},
					listeners : {
						beforehide: function(me, eOpt) {
							if(familyWin.changes) {
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
							familyWin.down('#search').clearForm();
						},
						beforeclose: function( panel, eOpts ) {
							if(familyWin.changes) {
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
							familyWin.down('#search').clearForm();
						},
						beforeshow: function( panel, eOpts )	{
							var searchForm =  familyWin.down('#search');
							searchForm.setValue("YEAR_YYYY"		,familyWin.paramData.YEAR_YYYY);
							searchForm.setValue("NAME"			,familyWin.paramData.NAME);
							searchForm.setValue("PERSON_NUMB"	,familyWin.paramData.PERSON_NUMB);
							searchForm.setValue("DEPT_NAME"		,familyWin.paramData.DEPT_NAME);
							searchForm.setValue("POST_CODE_NAME",familyWin.paramData.POST_CODE_NAME);
							had960ukrStore.loadStoreRecords();
							
							var grid = Ext.getCmp('had960ukrGrid');
							console.log("grid.getColumns()", grid.getColumns());
							
							var info = Ext.getCmp("info_gr");
							var ins = Ext.getCmp("insur_gr");
							var med = Ext.getCmp("med_gr");
							var med2 = Ext.getCmp("med_gr2");
							var med3 = Ext.getCmp("med_gr3");
							var med4 = Ext.getCmp("med_gr4");
							var edu = Ext.getCmp("edu_gr");
							var cred = Ext.getCmp("credit_gr");
							
							switch(familyWin.openType)	{
								case 'P': // 인적공제
									info.show();
									ins.hide();
									med.hide();
									med2.hide();
									med3.hide();
									med4.hide();
									edu.hide();
									cred.hide();
									grid.getColumn("DEFAULT_DED_YN").show();
									grid.getColumn("HOUSEHOLDER_YN").show();
									grid.getColumn("DEFORM_DED_YN").hide();
									grid.getColumn("DEFORM_KIND_CODE").show();
									grid.getColumn("BRING_CHILD_DED_YN").show();
									grid.getColumn("WOMAN_DED_YN").show();
									grid.getColumn("ONE_PARENT_DED_YN").show();
									grid.getColumn("OLD_DED_YN").show();
									
									grid.getColumn("BIRTH_ADOPT_DED_YN").show();
									grid.getColumn("BIRTH_ADOPT_CODE").show();
									
									grid.getColumn("DEFAULT_DED_YN").setDisabled(false);
									grid.getColumn("DEFORM_DED_YN").setDisabled(false);
									grid.getColumn("OLD_DED_YN").setDisabled(false);
									grid.getColumn("BRING_CHILD_DED_YN").setDisabled(false);
								break;
								
								case 'I': //기타보장성보험
									info.show();
									ins.show();
									med.hide();
									med2.hide();
									med3.hide();
									med4.hide();
									edu.hide();
									cred.hide();
									grid.getColumn("DEFAULT_DED_YN").show();
									grid.getColumn("HOUSEHOLDER_YN").hide();
									grid.getColumn("DEFORM_KIND_CODE").hide();
									grid.getColumn("DEFORM_DED_YN").show();
									grid.getColumn("BRING_CHILD_DED_YN").hide();
									grid.getColumn("WOMAN_DED_YN").hide();
									grid.getColumn("ONE_PARENT_DED_YN").hide();
									grid.getColumn("OLD_DED_YN").hide();
									
									grid.getColumn("BIRTH_ADOPT_DED_YN").hide();
									grid.getColumn("BIRTH_ADOPT_CODE").hide();
									grid.getColumn("INSUR_USE_I").setWidth(270);
									
									grid.getColumn("DEFAULT_DED_YN").setDisabled(true);
									grid.getColumn("DEFORM_DED_YN").setDisabled(true);
									grid.getColumn("OLD_DED_YN").setDisabled(true);
									grid.getColumn("BRING_CHILD_DED_YN").setDisabled(true);
								break;
								
								case 'M': //의료비
									info.show();
									ins.hide();
									med.show();
									med2.show();
									med3.show();
									med4.show();
									edu.hide();
									cred.hide();
									grid.getColumn("DEFAULT_DED_YN").show();
									grid.getColumn("HOUSEHOLDER_YN").hide();
									grid.getColumn("DEFORM_DED_YN").show();
									grid.getColumn("DEFORM_KIND_CODE").hide();
									grid.getColumn("BRING_CHILD_DED_YN").hide();
									grid.getColumn("WOMAN_DED_YN").hide();
									grid.getColumn("ONE_PARENT_DED_YN").hide();
									grid.getColumn("OLD_DED_YN").show();
									
									grid.getColumn("BIRTH_ADOPT_DED_YN").hide();
									grid.getColumn("BIRTH_ADOPT_CODE").hide();
									grid.getColumn("BIRTH_ADOPT_CODE").setWidth(200);
									
									grid.getColumn("DEFAULT_DED_YN").setDisabled(true);
									grid.getColumn("DEFORM_DED_YN").setDisabled(true);
									grid.getColumn("OLD_DED_YN").setDisabled(true);
									grid.getColumn("BRING_CHILD_DED_YN").setDisabled(true);
								break;
								
								case 'E': //교육비
									info.show();
									ins.hide();
									med.hide();
									med2.hide();
									med3.hide();
									med4.hide();
									edu.show();
									cred.hide();
									grid.getColumn("DEFAULT_DED_YN").hide();
									grid.getColumn("HOUSEHOLDER_YN").hide();
									grid.getColumn("DEFORM_DED_YN").show();
									grid.getColumn("DEFORM_KIND_CODE").hide();
									grid.getColumn("BRING_CHILD_DED_YN").hide();
									grid.getColumn("WOMAN_DED_YN").hide();
									grid.getColumn("ONE_PARENT_DED_YN").hide();
									grid.getColumn("OLD_DED_YN").hide();
									
									grid.getColumn("BIRTH_ADOPT_DED_YN").hide();
									grid.getColumn("BIRTH_ADOPT_CODE").hide();
									
									grid.getColumn("EDU_PRINCIPAL_RTN_I").setWidth(200);
								break;
								
								case 'C': //신용카드
									info.hide();
									ins.hide();
									med.hide();
									med2.hide();
									med3.hide();
									med4.hide();
									edu.hide();
									cred.show();
									grid.getColumn("TRAFFIC_USE_I").setWidth(90);
								break;
								
								default:
								break;
							}
							//20190117 교육비 내역 입력 팝업 그리드 validator 선언
						/* var validationEdu = Unilite.createValidator('validatorEdu', {
								store: Ext.getCmp('had960ukrGrid').getStore(),
								grid: Ext.getCmp('had960ukrGrid'),
								validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
									if(newValue == oldValue){
										return false;
									}
									console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
									var rv = true;
									switch(fieldName) {
										
										default :
											break;
											
									}
											
									return rv;
								}
							}); // validator */
							
							if(gbCloseYn) {
								familyWin.down('#familyWin-add').setDisabled(gbCloseYn);
								familyWin.down('#familyWin-delete').setDisabled(gbCloseYn);
								familyWin.down('#familyWin-lastYear').setDisabled(gbCloseYn);
								
								grid.getColumn("DEFAULT_DED_YN").setDisabled(gbCloseYn);
								grid.getColumn("HOUSEHOLDER_YN").setDisabled(gbCloseYn);
								grid.getColumn("DEFORM_DED_YN").setDisabled(gbCloseYn);
								grid.getColumn("WOMAN_DED_YN").setDisabled(gbCloseYn);
								grid.getColumn("ONE_PARENT_DED_YN").setDisabled(gbCloseYn);
								grid.getColumn("OLD_DED_YN").setDisabled(gbCloseYn);
								grid.getColumn("BIRTH_ADOPT_DED_YN").setDisabled(gbCloseYn);
							}
							else {
								grid.getColumn("HOUSEHOLDER_YN").setDisabled(gbCloseYn);
								grid.getColumn("WOMAN_DED_YN").setDisabled(gbCloseYn);
								grid.getColumn("ONE_PARENT_DED_YN").setDisabled(gbCloseYn);
								grid.getColumn("BIRTH_ADOPT_DED_YN").setDisabled(gbCloseYn);
							}
						}
					}
				});
				
				var validatorFamily = Unilite.createValidator('validatorFamily', {
					store :had960ukrStore,
					grid: Ext.getCmp('had960ukrGrid'),
					forms: {},
					validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {
						console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
						var grid = this.grid;
						var rv = true;
						var sAfterValue = newValue;
						//'관계코드
						var relationCode = record.get("REL_CODE");
						//'성별(주민등록번호에 의해 계산됨)
						var gender	= record.get("REPRE_NUM").replace("-","").substring(6, 7);
						//'나이(주민등록번호에 의해 계산됨)
						var dAge = 0;
						
						if(gender == "3" || gender == "4" || gender == "7" || gender == "8" ) {
							dAge	= parseInt(record.get("YEAR_YYYY")) - parseInt("20" +  record.get("REPRE_NUM").substring(0,2));
						}
						else {
							dAge	= parseInt(record.get("YEAR_YYYY")) - parseInt("19" +  record.get("REPRE_NUM").substring(0,2));
						}
						
						//'관계코드 필수 체크
						if (relationCode == "" &&
							UniUtils.indexOf(fieldName, [ "DEFAULT_DED_YN", "HOUSEHOLDER_YN", "DEFORM_DED_YN", "BRING_CHILD_DED_YN", "WOMAN_DED_YN", "ONE_PARENT_DED_YN", "OLD_DED_YN", "MANY_CHILD_DED_YN", "BIRTH_ADOPT_DED_YN" ,"BIRTH_ADOPT_CODE" ]))	{
							Unilite.messageBox(Msg.sMB308);
							
							record.set(fieldName, false);
							grid.fnAutoSetSamePerson(record.obj, fieldName, false);	//같은 소득자의 자료 자동 세팅
							
							rv = false;
						}
						
						switch(fieldName)	{
							case "FAMILY_NAME":
								//같은 소득자의 자료 자동 세팅
								grid.fnAutoSetSamePerson(record.obj, fieldName, newValue);
							break;
							
							case "REPRE_NUM":
								//인적공제항목 초기화
								grid.fnClearDedItem(record.obj);
								
								if(relationCode != ""){
									record.set("REL_CODE", "");
								}
								if( sAfterValue == "-" ){
									record.set(fieldName, '');
									sAfterValue = '';
								}
								if( sAfterValue != "" ){
									if(UniUtils.indexOf(sAfterValue.replace("-", "").substring(6, 7), ["1", "2", "3", "4"])) {
										record.set("IN_FORE", "1");
									} else {
										record.set("IN_FORE", "9");
									}
								}
								//같은 소득자의 자료 자동 세팅
								grid.fnAutoSetSamePerson(record.obj, fieldName, newValue);
								grid.fnAutoSetSamePerson(record.obj, "IN_FORE");
								grid.fnAutoSetSamePerson(record.obj, "REL_CODE");
							break;
							
							case "REL_CODE":
								//인적공제항목 초기화
								grid.fnClearDedItem(record.obj);
								
								switch(sAfterValue){
									//1)직계존속
									case "1" :
									case "2" :
										if (dAge <= 20){
											rv = "잘못된 관계코드를 입력하였습니다.<br> 연령요건을 확인하시기 바랍니다.";
											return rv;
										}
										else if(dAge >= 60){
											record.set("DEFAULT_DED_YN", true);
											if(dAge >= 70){
												record.set("OLD_DED_YN", true);
											}
										}
									break;
									
									//2)직계비속, 위탁아동
									case "4":
									case "5":
									case "8":
										if(dAge <= 20){
											record.set("DEFAULT_DED_YN", true);
											
											//7세이상 자녀세액공제	
											if(dAge >= 7){
												record.set("BRING_CHILD_DED_YN", true);
											}
											
											//출산입양자 공제
											if (sAfterValue == "4" || sAfterValue == "5"){
												if(dAge == 0){
													record.set("BIRTH_ADOPT_DED_YN", true);
													record.set("BIRTH_ADOPT_CODE", "01");
												}
											}
										}
									break;
									
									//3)형제자매
									case "6":
										if(dAge <= 20 || dAge >= 60){
											record.set("DEFAULT_DED_YN", true);
										}
									break;
								}
								
								//같은 소득자의 자료 자동 세팅
								grid.fnAutoSetSamePerson(record.obj, fieldName, newValue);
								grid.fnAutoSetSamePerson(record.obj, "DEFAULT_DED_YN");
								grid.fnAutoSetSamePerson(record.obj, "OLD_DED_YN");
								grid.fnAutoSetSamePerson(record.obj, "BRING_CHILD_DED_YN");
								grid.fnAutoSetSamePerson(record.obj, "BIRTH_ADOPT_DED_YN");
								grid.fnAutoSetSamePerson(record.obj, "BIRTH_ADOPT_CODE");
							break;
							
							case "IN_FORE":
								//같은 소득자의 자료 자동 세팅
								grid.fnAutoSetSamePerson(record.obj, fieldName, newValue);
							break;
							
							case "DEFORM_KIND_CODE" :	//장애인 구분에 따라서 장애인 YN, 기본 공제 YN 자동 셋팅
								if(!sAfterValue|| sAfterValue == ''){
									record.set("DEFORM_DED_YN", false);
									grid.fnAutoSetSamePerson(record.obj, "DEFORM_DED_YN", false);
									
									if (relationCode == "4" || relationCode == "5" || relationCode == "6" || relationCode == "8" )	{ //2-1) 직계비속, 형제자매
										var dAgeLimit = 20;
										
										if( dAge > dAgeLimit ) {
											record.set("DEFAULT_DED_YN", false);
											grid.fnAutoSetSamePerson(record.obj, "DEFAULT_DED_YN", false);
											
											if(record.get("BRING_CHILD_DED_YN")) {
												record.set("BRING_CHILD_DED_YN", false);
												grid.fnAutoSetSamePerson(record.obj, "BRING_CHILD_DED_YN", false);
											}
										}
									} else if (relationCode ==  "1"|| relationCode == "2" ) {	//'2-2) 직계존속
										var dAgeLimit = 60;
										
										if( dAge < dAgeLimit ) {
											record.set("DEFAULT_DED_YN", false);
											grid.fnAutoSetSamePerson(record.obj, "DEFAULT_DED_YN", false);
											
											if(record.get("OLD_DED_YN")) {
												record.set("OLD_DED_YN", false);
												grid.fnAutoSetSamePerson(record.obj, "OLD_DED_YN", false);
											}
										}
									}
								} else {
									record.set("DEFORM_DED_YN", true);
									record.set("DEFAULT_DED_YN", true);
									
									grid.fnAutoSetSamePerson(record.obj,"DEFORM_DED_YN", true);
									grid.fnAutoSetSamePerson(record.obj,"DEFAULT_DED_YN", true);
								}
								grid.fnAutoSetSamePerson(record.obj, fieldName, newValue);
							break;
							
							case "BIRTH_ADOPT_CODE"://'출산입양자공제
								//'기본공제자 여부 체크
								if(!record.get("BIRTH_ADOPT_DED_YN")){
									rv = "출산 입양자 체크를 먼저 해 주시기 바랍니다.";
									break;
								}
								if( !record.get("DEFAULT_DED_YN")  && sAfterValue ) {
									Unilite.messageBox(Msg.fsbMsgH0109);
									
									record.set(fieldName, '');
									grid.fnAutoSetSamePerson(record.obj, fieldName, newValue);
									
									return;
								}
								grid.fnAutoSetSamePerson(record.obj, fieldName, newValue);
							break;
							
							case "INSUR_CODE":
								if( sAfterValue == "" ){
									record.set("INSUR_USE_I", 0);
								} else {
									if(!record.get("DEFAULT_DED_YN")){
										rv = Msg.fsbMsgH0109;
										sAfterValue = "";
									}
									
									if( !record.get("DEFORM_DED_YN") && newValue == "2" ){
										rv = Msg.fsbMsgH0133;
									}
								}
							break;
							
							case "INSUR_USE_I":
								if(sAfterValue == "" ){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								
								//보험료에 값이 없으면 보험료 구분도 공백으로 만들기
								if( sAfterValue == 0 ){
									record.set("INSUR_CODE" ,"");
								}
								
								if(!record.get("DEFAULT_DED_YN") ){
									rv = Msg.fsbMsgH0109;
									sAfterValue = 0;
								}
								
								if(sAfterValue != "0" && record.get("INSUR_CODE") == ""  ){
									rv = Msg.fsbMsgH0134;
									sAfterValue = 0;
								}
							break;
							
							case "MED_USE_I":
							case "SURGERY_MED_I":
							case "SERIOUS_SICK_MED_I":
							case "REAL_LOSS_MED_INSUR_I":
								if(sAfterValue ==  "" ){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
							break;
							
							case "EDU_CODE":
								if( sAfterValue == "" ){
									record.set("EDU_USE_I", 0);
									record.set("DEFORM_EDU_USE_I", 0);
									record.set("FIELD_EDUC_I", 0);
									record.set("UNIFORM_USE_I", 0);
									record.set("EDU_PRINCIPAL_RTN_I", 0);
								} else {
									if(record.get('REL_CODE') == '0' && sAfterValue != '1')	{
										rv = Msg.fsbMsgH0140;
										sAfterValue = '';
									}
									if(record.get('REL_CODE') != '0' && sAfterValue == '1')	{
										rv =  Msg.fsbMsgH0141;
										sAfterValue = '';
									}
									
									var idx = this.store.indexOf(record.obj);
									var dRecord = idx%2 == 0 ? this.store.getAt(idx+1) : this.store.getAt(idx-1);
									
									if(dRecord)	{
										if(!Ext.isEmpty(sAfterValue) && record.get("REPRE_NUM") == dRecord.get("REPRE_NUM") && dRecord.get(fieldName) == ""){
											dRecord.set(fieldName, sAfterValue);
										}
									}
								}
								//grid.fnAutoSetSamePerson(record,fieldName);
							break;
							
							case "EDU_USE_I":
								if(sAfterValue ==  "" ){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								if( sAfterValue != 0 &&  record.get("EDU_CODE")== "" ){
									rv = Msg.fsbMsgH0136;
									record.set(fieldName, 0);
								}
							break;
							
							case "DEFORM_EDU_USE_I":
								if(sAfterValue ==  "" ){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								if(!record.get("DEFORM_DED_YN") && newValue != 0){
									rv = '장애인 교육비는 장애인 공제여부가 공제(Y)인 경우에만 수정 가능합니다.';
									record.set(fieldName, 0);
								}
								if( sAfterValue != 0 &&  record.get("EDU_CODE")== ""  ){
									rv = Msg.fsbMsgH0136;
									sAfterValue = 0;
									record.set(fieldName, 0);
								}
							break;
							
							case "FIELD_EDUC_I":
								if(sAfterValue ==  "" ){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								if( sAfterValue != 0 &&  record.get("EDU_CODE")== "" ){
									rv = Msg.fsbMsgH0136;
									record.set(fieldName, 0);
									grid.fnAutoSetSamePerson(record.obj,fieldName, 0);
								}
								
								if(sAfterValue != 0 &&  record.get("EDU_CODE")!= "3") {
									rv = "체험학습비는 초중고 교육비인 경우만 입력할 수 있습니다.";
									record.set(fieldName, 0);
									sAfterValue = 0;
									grid.fnAutoSetSamePerson(record.obj,fieldName, 0);
								}
							break;
							
							case "UNIFORM_USE_I":
								if(sAfterValue ==  "" ){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								if( sAfterValue != 0 &&  record.get("EDU_CODE")== "" ){
									rv = Msg.fsbMsgH0136;
									sAfterValue = 0;
									record.set(fieldName, 0);
								}
								
								if(sAfterValue != 0 &&  record.get("EDU_CODE")!= "3") {
									rv = "교복구입비는 초중고 교육비인 경우만 입력할 수 있습니다.";
									sAfterValue = 0;
									record.set(fieldName, 0);
									grid.fnAutoSetSamePerson(record.obj,fieldName, 0);
								}
							break;
							
							case "EDU_PRINCIPAL_RTN_I":
								if(sAfterValue ==  "" ){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								if( sAfterValue != 0 &&  record.get("EDU_CODE")== ""  ){
									rv = Msg.fsbMsgH0136;
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								
								if(sAfterValue != 0 &&  record.get("REL_CODE")!= "0") {
									rv = "학자금 원리금 상환액은 근로자 본인만 입력할 수 있습니다.";
									sAfterValue = 0;
									record.set(fieldName, 0);
									grid.fnAutoSetSamePerson(record.obj,fieldName, 0);
								}
							break;
							
							case "CARD_USE_I":
							case "DEBIT_CARD_USE_I":
							case "CASH_USE_I":
							case "TRA_MARKET_USE_I":
							case "TRAFFIC_USE_I":
							case "BOOK_CONCERT_CARD_I":
							case "BOOK_CONCERT_CASH_I":
							case "BOOK_CONCERT_DEBIT_I":
								if(sAfterValue == ""){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
							break;
						
							case "CARD_USE_I_A":
							case "CARD_USE_I_B":
							case "CARD_USE_I_C":
								if(sAfterValue == ""){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								
								var useIA	= (fieldName == "CARD_USE_I_A" ? sAfterValue : record.get("CARD_USE_I_A"));
								var useIB	= (fieldName == "CARD_USE_I_B" ? sAfterValue : record.get("CARD_USE_I_B"));
								var useIC	= (fieldName == "CARD_USE_I_C" ? sAfterValue : record.get("CARD_USE_I_C"));
								
								record.set("CARD_USE_I", useIA + useIB + useIC);
							break;
							
							case "DEBIT_CARD_USE_I_A":
							case "DEBIT_CARD_USE_I_B":
							case "DEBIT_CARD_USE_I_C":
								if(sAfterValue == ""){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								
								var useIA	= (fieldName == "DEBIT_CARD_USE_I_A" ? sAfterValue : record.get("DEBIT_CARD_USE_I_A"));
								var useIB	= (fieldName == "DEBIT_CARD_USE_I_B" ? sAfterValue : record.get("DEBIT_CARD_USE_I_B"));
								var useIC	= (fieldName == "DEBIT_CARD_USE_I_C" ? sAfterValue : record.get("DEBIT_CARD_USE_I_C"));
								
								record.set("DEBIT_CARD_USE_I", useIA + useIB + useIC);
							break;
							
							case "CASH_USE_I_A":
							case "CASH_USE_I_B":
							case "CASH_USE_I_C":
								if(sAfterValue == ""){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								
								var useIA	= (fieldName == "CASH_USE_I_A" ? sAfterValue : record.get("CASH_USE_I_A"));
								var useIB	= (fieldName == "CASH_USE_I_B" ? sAfterValue : record.get("CASH_USE_I_B"));
								var useIC	= (fieldName == "CASH_USE_I_C" ? sAfterValue : record.get("CASH_USE_I_C"));
								
								record.set("CASH_USE_I", useIA + useIB + useIC);
							break;
							
							case "TRA_MARKET_USE_I_A":
							case "TRA_MARKET_USE_I_B":
							case "TRA_MARKET_USE_I_C":
								if(sAfterValue == ""){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								
								var useIA	= (fieldName == "TRA_MARKET_USE_I_A" ? sAfterValue : record.get("TRA_MARKET_USE_I_A"));
								var useIB	= (fieldName == "TRA_MARKET_USE_I_B" ? sAfterValue : record.get("TRA_MARKET_USE_I_B"));
								var useIC	= (fieldName == "TRA_MARKET_USE_I_C" ? sAfterValue : record.get("TRA_MARKET_USE_I_C"));
								
								record.set("TRA_MARKET_USE_I", useIA + useIB + useIC);
							break;
							
							case "TRAFFIC_USE_I_A":
							case "TRAFFIC_USE_I_B":
							case "TRAFFIC_USE_I_C":
								if(sAfterValue == ""){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								
								var useIA	= (fieldName == "TRAFFIC_USE_I_A" ? sAfterValue : record.get("TRAFFIC_USE_I_A"));
								var useIB	= (fieldName == "TRAFFIC_USE_I_B" ? sAfterValue : record.get("TRAFFIC_USE_I_B"));
								var useIC	= (fieldName == "TRAFFIC_USE_I_C" ? sAfterValue : record.get("TRAFFIC_USE_I_C"));
								
								record.set("TRAFFIC_USE_I", useIA + useIB + useIC);
							break;
							
							case "BOOK_CONCERT_CARD_I_A":
							case "BOOK_CONCERT_CARD_I_B":
							case "BOOK_CONCERT_CARD_I_C":
								if(sAfterValue == ""){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								
								var useIA	= (fieldName == "BOOK_CONCERT_CARD_I_A" ? sAfterValue : record.get("BOOK_CONCERT_CARD_I_A"));
								var useIB	= (fieldName == "BOOK_CONCERT_CARD_I_B" ? sAfterValue : record.get("BOOK_CONCERT_CARD_I_B"));
								var useIC	= (fieldName == "BOOK_CONCERT_CARD_I_C" ? sAfterValue : record.get("BOOK_CONCERT_CARD_I_C"));
								
								record.set("BOOK_CONCERT_CARD_I", useIA + useIB + useIC);
							break;
							
							case "BOOK_CONCERT_CASH_I_A":
							case "BOOK_CONCERT_CASH_I_B":
							case "BOOK_CONCERT_CASH_I_C":
								if(sAfterValue == ""){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								
								var useIA	= (fieldName == "BOOK_CONCERT_CASH_I_A" ? sAfterValue : record.get("BOOK_CONCERT_CASH_I_A"));
								var useIB	= (fieldName == "BOOK_CONCERT_CASH_I_B" ? sAfterValue : record.get("BOOK_CONCERT_CASH_I_B"));
								var useIC	= (fieldName == "BOOK_CONCERT_CASH_I_C" ? sAfterValue : record.get("BOOK_CONCERT_CASH_I_C"));
								
								record.set("BOOK_CONCERT_CASH_I", useIA + useIB + useIC);
							break;
							
							case "BOOK_CONCERT_DEBIT_I_A":
							case "BOOK_CONCERT_DEBIT_I_B":
							case "BOOK_CONCERT_DEBIT_I_C":
								if(sAfterValue == ""){
									record.set(fieldName, 0);
									sAfterValue = 0;
								}
								
								var useIA	= (fieldName == "BOOK_CONCERT_DEBIT_I_A" ? sAfterValue : record.get("BOOK_CONCERT_DEBIT_I_A"));
								var useIB	= (fieldName == "BOOK_CONCERT_DEBIT_I_B" ? sAfterValue : record.get("BOOK_CONCERT_DEBIT_I_B"));
								var useIC	= (fieldName == "BOOK_CONCERT_DEBIT_I_C" ? sAfterValue : record.get("BOOK_CONCERT_DEBIT_I_C"));
								
								record.set("BOOK_CONCERT_DEBIT_I", useIA + useIB + useIC);
							break;
						}
						
						return rv;
					}
				});
			}
			
			var addBtn = familyWin.down('#familyWin-add');
			var deleteBtn = familyWin.down('#familyWin-delete');
			var lastYearBtn = familyWin.down('#familyWin-lastYear');
			
			if(addBtn) 		addBtn.setDisabled(gbCloseYn);
			if(deleteBtn) 	deleteBtn.setDisabled(gbCloseYn);
			if(lastYearBtn) lastYearBtn.setDisabled(gbCloseYn);
			
			if(openType == 'C')	{
				familyWin.setTitle("신용카드 등");
				
				if(addBtn)		addBtn.setDisabled(true);
				if(deleteBtn)	deleteBtn.setDisabled(true);
				if(lastYearBtn) lastYearBtn.setDisabled(true);
			}
			else if(openType == 'I') {
				familyWin.setTitle("기타보험료/장애자전용보장성보험");
			}
			else if(openType == 'M') {
				familyWin.setTitle("의료비 내역");
				
				if(addBtn)		addBtn.setDisabled(true);
				if(deleteBtn)	deleteBtn.setDisabled(true);
				if(lastYearBtn) lastYearBtn.setDisabled(true);
			}
			else if(openType == 'E') {
				familyWin.setTitle("교육비");
				
				if(addBtn)		addBtn.setDisabled(true);
				if(deleteBtn)	deleteBtn.setDisabled(true);
				if(lastYearBtn) lastYearBtn.setDisabled(true);
			}
			else {
				familyWin.setTitle("인적공제항목");
			}
			
			familyWin.openType = openType;
			familyWin.paramData = paramData;
			familyWin.changes = false;
			familyWin.center();
			familyWin.show();
		},
		//개인연금저축
		openPersonalPension:function(openType) {
			var infoForm400 = Ext.getCmp("infoForm400");
			var hideInvestFields = true;
			var winWidth = 700 , winHeight= 400, winTitle='개인연금저축공제';
			
			if(UniUtils.indexOf(openType, ["31","32","34","35","36"])
				&& !infoForm400.getValue("HOUSEHOLDER_YN"))	{				// 그밖소득공제-주택마련은 세대주가 아니면 팝업 사용 못함
				Unilite.messageBox("세대주인 경우만 공제내역을 입력할 수 있습니다.");
				return ;
			}

			//  2018.11.18 / 개발팀 이정현 추가 / 2018년 귀속 연말정산 세법변경으로 인함.
			var baseForm400 = Ext.getCmp("baseForm400");
			if(UniUtils.indexOf(openType, ["31","32","35","36"]) && baseForm400.getValue("INCOME_SUPP_TOTAL_I") > 70000000) {
				Unilite.messageBox("총급여액이 7천만원 이하인 경우만 공제내역을 입력할 수 있습니다.");
				return;
			}
			if(UniUtils.indexOf(openType, ["51"]) && baseForm400.getValue("INCOME_SUPP_TOTAL_I") > 80000000) {
				Unilite.messageBox("총급여액이 8천만원 이하인 경우만 공제내역을 입력할 수 있습니다.");
				return;
			}
			
			if(openType == '11') {
				winTitle = '근로자퇴직급여보장법';
			} else if(openType == '12') {
				winTitle = '과학기술인공제';
			} else if(openType == '21') {
				winTitle = '개인연금저축';
			} else if(openType == '31') {
				winTitle = '청약저축(240만원한도)';
			} else if(openType == '32') {
				winTitle = '주택청약종합저축(240만원한도)';
			} else if(openType == '34') {
				winTitle = '근로자주택마련저축';
			} else if(openType == '51') {
				winTitle = '장기집합투자증권저축';
			} else if(openType == '61') {
				hideInvestFields = false;
				winWidth = 900;
				winTitle = '투자조합 출자공제';
			}
			

			if(!panelResult.isValid()) {
				return;
			}

			var paramData = {
				'YEAR_YYYY'			: panelResult.getValue('YEAR_YYYY'),
				'PERSON_NUMB'		: panelResult.getValue('PERSON_NUMB'),
				'NAME'				: panelResult.getValue('NAME'),
				'DEPT_NAME'			: panelResult.getValue('DEPT_NAME'),
				'POST_CODE_NAME'	: panelResult.getValue('POST_NAME')
			};
			if(!personalPensionWin)	{
				Unilite.defineModel('had460ukrModel', {
					fields: [
						{name: 'PERSON_NUMB'	, text: '사번'			, type: 'string', allowBlank:false},
						{name: 'NAME'			, text: '성명'			, type: 'string'},
						{name: 'YEAR_YYYY'		, text: '정산년도'			, type: 'string', allowBlank:false},
						{name: 'PERSON_NAME'	, text: '사원명'			, type: 'string'},
						{name: 'INCM_DDUC_CD'	, text: '소득공제구분'		, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H150'},
						{name: 'BANK_CODE'		, text: '금융기관'			, type: 'string', comboType:'AU', comboCode:'H152'},
						{name: 'BANK_ACCOUNT'	, text: '계좌번호'			, type: 'string'},
						{name: 'PAY_YRLV'		, text: '납입연차'			, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H151', defaultValue:'00'},
						{name: 'PAY_I'			, text: '불입액'			, type: 'uniPrice', minValue:0},
						{name: 'DDUC_I'			, text: '공제금액'			, type: 'uniPrice'},
						{name: 'INVEST_YEAR'	, text: '투자년도'			, type: 'string', comboType:'AU', comboCode:'H233'},
						{name: 'INVEST_TYPE'	, text: '투자구분'			, type: 'string', comboType:'AU', comboCode:'H229'}
					 ]
				});
				var had460ukrStore = Unilite.createStore('had460ukrStore',{
					model: 'had460ukrModel',
					uniOpt : {
						isMaster: false,		// 상위 버튼 연결
						editable: true,			// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 'had460ukrService.selectList'
							,update : 'had460ukrService.update'
							,create : 'had460ukrService.insert'
							,destroy : 'had460ukrService.delete'
							,syncAll: 'had460ukrService.saveAll'
						}
					},
					loadStoreRecords: function(){
						var param= personalPensionWin.paramData;
						param.DDUC_CODE= personalPensionWin.openType;
						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function()	{
						var toCreate = this.getNewRecords();
						var toUpdate = this.getUpdatedRecords();
						var toDelete = this.getRemovedRecords();
						var list = [].concat(toUpdate, toCreate);

						var checkValid = true;
						Ext.each(list, function(record, index) {
							// 비과세분 입력시 비과세 코드 입력 체크
							if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
								Unilite.messageBox(Msg.sMH1065 +'\n'+ Msg.fstMsgH0098);
								checkValid = false;
								return;
							}
							if(record.get("INCM_DDUC_CD") == "61") {
								if(Ext.isEmpty(record.get('INVEST_YEAR'))  ) {
									Unilite.messageBox("투자년도를 입력하세요.");
									checkValid = false;
									return;
								} 
								if(Ext.isEmpty(record.get('INVEST_TYPE'))  ) {
								Unilite.messageBox("투자구분을 입력하세요.");
								checkValid = false;
								return;
								} 
							} else {
								 
								if(Ext.isEmpty(record.get('BANK_CODE'))  ) {
									Unilite.messageBox("금융기관을 입력하세요.");
									checkValid = false;
									return;
								} 
								if(Ext.isEmpty(record.get('BANK_ACCOUNT'))  ) {
								Unilite.messageBox("계좌번호 입력하세요.");
								checkValid = false;
								return;
								} 
							}
						})
						if(!checkValid)	{
							return;
						}

						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);
						if(inValidRecs.length == 0) {
							config = {
										//params: [paramMaster],
										success: function(batch, option) {
											personalPensionWin.changes = true;
											personalPensionWin.unmask();
										}
								};
							//personalPensionWin.mask();
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('had460ukrGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}

				});

				personalPensionWin= Ext.create('widget.uniDetailWindow', {
					title: winTitle,
					width: winWidth,
					height:winHeight,
					layout: {type:'vbox', align:'stretch'},
					items: [{
							itemId:'search',
							xtype:'uniSearchForm',
							 style:{
								'background':'#fff'
							},
							height:65,
							layout:{type:'uniTable', columns:4},
							margine:'3 3 3 3',
							items:[{
								fieldLabel: '정산년도',
								name:'YEAR_YYYY',
								xtype: 'uniYearField',
								readOnly:true,
								width:150,
								labelWidth:80,
								colspan:4
							},{
								fieldLabel: '성명',
								name:'NAME',
								readOnly:true,
								width:150,
								labelWidth:80
							},{
								fieldLabel: '사번',
								name:'PERSON_NUMB',
								readOnly:true,
								width:200,
								labelWidth:50
							},{
								fieldLabel: '부서',
								name:'DEPT_NAME',
								readOnly:true,
								width:200,
								labelWidth:50
							},{
								fieldLabel: '직위',
								name:'POST_CODE_NAME',
								readOnly:true,
								width:150,
								labelWidth:50
							}]},{
							xtype:'container',
							flex:1,
							layout: {type:'vbox', align:'stretch'},
							items:[
								Unilite.createGrid('had460ukrGrid', {
										layout : 'fit',
										store : had460ukrStore,
										sortableColumns: false,
										itemId:'had460ukrGrid',
										uniOpt:{
											expandLastColumn: false,	//마지막 컬럼 * 사용 여부
											useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
											useLiveSearch: false,		//찾기 버튼 사용 여부
											filter: {					//필터 사용 여부
												useFilter: false,
												autoCreate: false
											},
											state: {
												useState: false,			//그리드 설정 버튼 사용 여부
												useStateList: false		//그리드 설정 목록 사용 여부
											}
										},
										tbar:[
											'->',
											{
												xtype:'button',
												text:'추가',
												itemId: 'btnPensionPopAdd',
												handler:function()	{
													var form = personalPensionWin.down('#search');
													var grid = Ext.getCmp('had460ukrGrid');
													var record = Ext.create(had460ukrStore.model);
													rIndex = had460ukrStore.count();
													record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
													record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
													record.set("INCM_DDUC_CD",personalPensionWin.openType);
													had460ukrStore.insert(rIndex, record);
													grid.getSelectionModel().select(rIndex);
													var columns = grid.getVisibleColumns();
													var	sCell = grid.getView().getCell(record, columns[0], true);
													
													if(sCell)	{
														Ext.fly(sCell).focus();
													}
												}
											},{
												xtype:'button',
												text:'삭제',
												itemId: 'btnPensionPopDel',
												handler:function()	{
													var grid = Ext.getCmp('had460ukrGrid');
													had460ukrStore.remove(grid.getSelectionModel().getSelection());
												}
											}
										],
										columns:  [
											{dataIndex: 'INCM_DDUC_CD'	, width: 130},
											{dataIndex: 'BANK_CODE'		, width: 130},
											{dataIndex: 'BANK_ACCOUNT'	, width: 150},
											{dataIndex: 'PAY_YRLV'		, width: 100},
											{dataIndex: 'PAY_I'			, flex: 1},
											{dataIndex: 'INVEST_YEAR'		, width: 100, hidden:hideInvestFields},
											{dataIndex: 'INVEST_TYPE'		, width: 80, hidden:hideInvestFields}
											
										],
										listeners:{
											beforeedit:function(editor, context, eOpts)	{
												if(gbCloseYn) {
													return false;
												}
												
												if(context.field == "INCM_DDUC_CD" && !Ext.isEmpty(personalPensionWin.openType))	{
													return false;
												}
												if(context.field == "PAY_YRLV" &&  personalPensionWin.openType != '51')	{
													return false;
												}
											}
										}
									})
							]}

					],
					bbar:{
						layout: {
							pack: 'center',
							type: 'hbox'
						},
						dock:'bottom',
						items :  [
							 {
								itemId : 'submitBtn',
								text: '저장',
								width:100,
								itemId: 'btnPensionPopSaveAll',
								handler: function() {
									var store = Ext.data.StoreManager.lookup('had460ukrStore') ;
									if(store.isDirty())	{
										store.saveStore();
									}
								},
								disabled: false
							},{
								itemId : 'closeBtn',
								text: '닫기',
								width:100,
								handler: function() {
									var store = Ext.data.StoreManager.lookup('had460ukrStore') ;
									if(store.isDirty())	{
										if(confirm("저장할 내용이 있습니다. 저장하시겠습니까?")){
											store.saveStore();
											return;
										}
									}
									personalPensionWin.hide();

								},
								disabled: false
							}
						]
					},
					listeners : {
						beforehide: function(me, eOpt)	{
							personalPensionWin.down('#search').clearForm();
							had460ukrStore.loadData({});
							had460ukrStore.commitChanges();
							if(personalPensionWin.changes)	{
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
							personalPensionWin.openType = '';
						},
						beforeclose: function( panel, eOpts )	{
							personalPensionWin.down('#search').clearForm();
							had460ukrStore.loadData({});
							had460ukrStore.commitChanges();
							if(personalPensionWin.changes) {
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
							personalPensionWin.openType = '';
						},
						beforeshow: function( panel, eOpts )	{
							var searchForm =  personalPensionWin.down('#search');
							searchForm.setValue("YEAR_YYYY"		,personalPensionWin.paramData.YEAR_YYYY);
							searchForm.setValue("NAME"			,personalPensionWin.paramData.NAME);
							searchForm.setValue("PERSON_NUMB"	,personalPensionWin.paramData.PERSON_NUMB);
							searchForm.setValue("DEPT_NAME"		,personalPensionWin.paramData.DEPT_NAME);
							searchForm.setValue("POST_CODE_NAME",personalPensionWin.paramData.POST_CODE_NAME);
							had460ukrStore.loadStoreRecords();

							personalPensionWin.setCloseForm();
							
							var grid = personalPensionWin.down('#had460ukrGrid');
							if(personalPensionWin.hideInvestFields)	{
								grid.getColumn('INVEST_YEAR').hide();
								grid.getColumn('INVEST_TYPE').hide();
							} else {
								grid.getColumn('INVEST_YEAR').show();
								grid.getColumn('INVEST_TYPE').show();
							}
						}
					},
					setCloseForm : function() {
						personalPensionWin.down('#btnPensionPopAdd').setDisabled(gbCloseYn);
						personalPensionWin.down('#btnPensionPopDel').setDisabled(gbCloseYn);
						
						personalPensionWin.down('#btnPensionPopSaveAll').setDisabled(gbCloseYn);
					}
				});
				
				var validationPersonalPension = Unilite.createValidator('validatorPersonalPension', {
					store: Ext.getCmp('had460ukrGrid').getStore(),
					grid: Ext.getCmp('had460ukrGrid'),
					validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
						if(newValue == oldValue){
							return false;
						}
						console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
						var rv = true;
						
						switch(fieldName) {
							case "PAY_YRLV" :
							 	if(record.get("INCM_DDUC_CD") == "41" && newValue == "00")	{
									Unilite.messageBox(Msg.fsbMsgH0306);
									return false;
								}
								break;
							default: 
								break;
						}
						return rv;
					}
				});  
				
			}
			personalPensionWin.openType = openType;
			personalPensionWin.paramData = paramData;
			personalPensionWin.hideInvestFields = hideInvestFields;
			personalPensionWin.width = winWidth;
			personalPensionWin.height = winHeight;
			personalPensionWin.changes = false;
			personalPensionWin.setTitle(winTitle);
			personalPensionWin.center();
			personalPensionWin.show();
		},
		//의료비내경 입력
		openMedDoc:function( ) {
			if(!panelResult.isValid()) {
				return;
			}
			var paramData = {
				'YEAR_YYYY'			: panelResult.getValue('YEAR_YYYY'),
				'PERSON_NUMB'		: panelResult.getValue('PERSON_NUMB'),
				'NAME'				: panelResult.getValue('NAME'),
				'DEPT_NAME'			: panelResult.getValue('DEPT_NAME'),
				'POST_CODE_NAME'	: panelResult.getValue('POST_NAME')
			};
			if(!medDocWin) {
				Unilite.defineModel('had410ukrModel', {
					fields: [
						{name: 'PERSON_NUMB'		, text: '사번'				, type: 'string', allowBlank:false},
						{name: 'NAME'		  		, text: '성명'				, type: 'string'},
						{name: 'YEAR_YYYY'	  	, text: '정산년도'			, type: 'string', allowBlank:false},
						{name: 'PERSON_NAME'  		, text: '사원명'			, type: 'string'},
						{name: 'SEQ_NUM'			, text: '순번'				, type: 'uniNumber'},
						{name: 'REPRE_NUM'	 		, text: '주민번호'			, type: 'string', allowBlank:false},
						{name: 'REL_CODE'	 		, text: '관계'			, type: 'string',  editable:false},

						{name: 'MED_CODE'	  		, text: '공제항목'			, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H116'},
						{name: 'MED_PROOF_CODE' 	, text: '의료증빙코드'		, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H139'},
						{name: 'TAX_GU'	 		, text: '영수증구분'		, type: 'string', comboType:'AU', comboCode:'H120'},
						{name: 'DEFAULT_DED_YN'		, text: '기본공제여부'		, type: 'string'},

						{name: 'SEND_NUM'			, text: '건수'				, type: 'uniNumber', minValue:0, allowBlank:false},
						{name: 'SEND_USE_I'  		, text: '지급금액'			, type: 'uniPrice', allowBlank:false},
						{name: 'MED_COMPANY_NUM'	, text: '사업자번호'		, type: 'string'},

						{name: 'MED_RELATION' 		, text: '관계'				, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H115'},
						{name: 'IN_FORE_SUPP' 		, text: '내외국인구분'		, type: 'string', comboType:'AU', comboCode:'H118'},
						{name: 'TAX_GU_ORGIN' 		, text: '영수증구분(OLD)'	, type: 'string', comboType:'AU', comboCode:'H120'},
						{name: 'MED_COMPANY_NAME'	, text: '상호'				, type: 'string'},
						{name: 'FAMILY_NAME'  		, text: '가족성명'			, type: 'string'},
						{name: 'DEFORM_DED_YN' 		, text: '장애인공제여부'			, type: 'string'}
					 ]
				});
				var had410ukrStore = Unilite.createStore('had410ukrStore',{
					model: 'had410ukrModel',
					uniOpt : {
						isMaster: false,		// 상위 버튼 연결
						editable: true,			// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 'had410ukrService.selectList'
							,update : 'had410ukrService.update'
							,create : 'had410ukrService.insert'
							,destroy : 'had410ukrService.delete'
							,syncAll: 'had410ukrService.saveAll'
						}
					},
					loadStoreRecords: function(){
						var param= medDocWin.paramData;
						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function()	{
						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);
						
						var toCreate = this.getNewRecords();
						var toUpdate = this.getUpdatedRecords();
						var bIsError = false;
						
						Ext.each(toCreate, function(record, index){
							if(record.get('MED_PROOF_CODE') != '1' && Ext.isEmpty(record.get('MED_COMPANY_NAME'))) {
								Unilite.messageBox('의료증빙코드가 국세청의료비자료가 아닌 경우에 사업자번호와 상호는 필수입력 입니다.');
								bIsError = true;
								return;
							}
							if(record.get('MED_PROOF_CODE') != '1' && Ext.isEmpty(record.get('MED_COMPANY_NUM'))) {
								Unilite.messageBox('의료증빙코드가 국세청의료비자료가 아닌 경우에 사업자번호와 상호는 필수입력 입니다.');
								return;
							}
						});
						
						Ext.each(toUpdate, function(record, index){
							if(record.get('MED_PROOF_CODE') != '1' && Ext.isEmpty(record.get('MED_COMPANY_NAME'))) {
								Unilite.messageBox('의료증빙코드가 국세청의료비자료가 아닌 경우에 사업자번호와 상호는 필수입력 입니다.');
								bIsError = true;
								return;
							}
							if(record.get('MED_PROOF_CODE') != '1' && Ext.isEmpty(record.get('MED_COMPANY_NUM'))) {
								Unilite.messageBox('의료증빙코드가 국세청의료비자료가 아닌 경우에 사업자번호와 상호는 필수입력 입니다.');
								return;
							}
						});
						
						if(bIsError) {
							return false;
						}
						
						if(inValidRecs.length == 0) {
							config = {
								success: function(batch, option) {
									medDocWin.changes = true;
									medDocWin.unmask();
								}
							};
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('had410ukrGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}
				});
				
				medDocWin = Ext.create('widget.uniDetailWindow', {
					title: '의료비제출대상',
					width: 950,
					height:500,
					layout: {type:'vbox', align:'stretch'},
					items: [{
						itemId:'search',
						xtype:'uniSearchForm',
						style:{
							'background':'#fff'
						},
						height:65,
						layout:{type:'uniTable', columns:4},
						margine:'3 3 3 3',
						items:[{
							fieldLabel: '정산년도',
							name:'YEAR_YYYY',
							xtype: 'uniYearField',
							readOnly:true,
							width:150,
							labelWidth:80,
							colspan:4
						},{
							fieldLabel: '성명',
							name:'NAME',
							readOnly:true,
							width:150,
							labelWidth:80
						},{
							fieldLabel: '사번',
							name:'PERSON_NUMB',
							readOnly:true,
							width:200,
							labelWidth:80
						},{
							fieldLabel: '부서',
							name:'DEPT_NAME',
							readOnly:true,
							width:200,
							labelWidth:50
						},{
							fieldLabel: '직위',
							name:'POST_CODE_NAME',
							readOnly:true,
							width:150,
							labelWidth:50
						}]
					},{
						itemId:'summary',
						xtype:'uniSearchForm',
						style:{
							'background':'#fff'
						},
						height:50,
						layout:{type:'uniTable', columns:4},
						margine:'3 3 3 3',
						items:[{
							xtype:'component',
							colspan:4,
							html:"<hr></hr>"
						},{
							fieldLabel: '총급여',
							xtype:'uniNumberfield',
							name:'AMT_PAY',
							readOnly:true,
							width:200,
							labelWidth:80
						},{
							fieldLabel: '총급여3%금액',
							xtype:'uniNumberfield',
							name:'MED_DED_I',
							readOnly:true,
							width:250,
							tdAttrs:{width:600},
							labelWidth:80,
							colspan:3
						}]
					},{
						xtype:'container',
						flex:1,
						layout: {type:'vbox', align:'stretch'},
						items:[
							Unilite.createGrid('had410ukrGrid', {
								layout : 'fit',
								store : had410ukrStore,
								sortableColumns: true,
								uniOpt:{
									expandLastColumn: false,	//마지막 컬럼 * 사용 여부
									useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
									useLiveSearch: false,		//찾기 버튼 사용 여부
									filter: {					//필터 사용 여부
										useFilter: false,
										autoCreate: false
									},
									state: {
										useState: false,			//그리드 설정 버튼 사용 여부
										useStateList: false		//그리드 설정 목록 사용 여부
									}
								},
								tbar:[
									'->',
									{
										xtype:'button',
										text:'추가',
										itemId: 'btnMedDocPopAdd',
										handler:function()	{
											var form = medDocWin.down('#search');
											var grid = Ext.getCmp('had410ukrGrid');
											var record = Ext.create(had410ukrStore.model);
											//rIndex = had410ukrStore.count();
											rIndex = grid.getSelectedRowIndex() + 1;
											var seq = Unilite.nvl(had410ukrStore.max("SEQ_NUM"),0) + 1;
											record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
											record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
											record.set("SEQ_NUM",seq);
											had410ukrStore.insert(rIndex, record);
											grid.getSelectionModel().select(rIndex);
											var columns = grid.getVisibleColumns();
											var	sCell = grid.getView().getCell(record, columns[0], true);
											
											if(sCell)	{
												Ext.fly(sCell).focus();
											}
										}
									},{
										xtype:'button',
										text:'삭제',
										itemId: 'btnMedDocPopDel',
										handler:function()	{
											var grid = Ext.getCmp('had410ukrGrid');
											had410ukrStore.remove(grid.getSelectionModel().getSelection());
										}
									}
								],
								features: [
									{ ftype: 'uniSummary',		  showSummaryRow: true, dock :'bottom'}
								],
								columns:  [
									{dataIndex: 'REPRE_NUM'	, width: 130,
										summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
											  return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
										}
									},
									{dataIndex: 'FAMILY_NAME'	, width: 100},
									{dataIndex: 'REL_CODE'	, width: 100, hidden:true},
									{dataIndex: 'MED_CODE'		, width: 130},
									{dataIndex: 'MED_PROOF_CODE'	, width: 150},
									{dataIndex: 'SEND_NUM'			, width: 100, summaryType:'sum'},
									{dataIndex: 'SEND_USE_I'		, width: 100, summaryType:'sum'},
									{dataIndex: 'MED_COMPANY_NUM'		, width: 100},
									{dataIndex: 'DEFAULT_DED_YN'		, width: 50, hidden: true},
									{dataIndex: 'DEFORM_DED_YN'		, width: 50, hidden: true},
									{dataIndex: 'MED_COMPANY_NAME'			, flex: 1}
								],
								listeners:{
									beforeedit:function(editor, context, eOpts)	{
										if(gbCloseYn) {
											return false;
										}
										
										if(context.field == "REPRE_NUM" )	{
											context.grid.fnFamilyPopUp(context.record);
											return false;
										}else if(context.field == "DEFORM_DED_YN" || context.field == "DEFAULT_DED_YN"){
											return false;
										}
									},
									onGridDblClick:function(grid, record, cellIndex, colName)	{
										if(gbCloseYn) {
											return false;
										}
										
										if(colName == "REPRE_NUM")	{
											grid.ownerCt.ownerGrid.fnFamilyPopUp(record);
										}
									}
								},
								fnFamilyPopUp:function(record){
									var me = this;
									var paramData = {
										'YEAR_YYYY'		: record.get('YEAR_YYYY'),
										'PERSON_NUMB'	: record.get('PERSON_NUMB'),
										'NAME'			: record.get('NAME'),
										'DEPT_NAME'		: record.get('DEPT_NAME'),
										'POST_NAME'		: record.get('POST_NAME')
									};
									if(!me.familyPopupWin) {
										if(!me.familyPopupWin) {
											Unilite.defineModel('humanFamilyPopupModel', {
												fields: [
													{name: 'FAMILY_NAME'		, text: '가족성명'		, type: 'string'},
													{name: 'REPRE_NUM'			, text: '주민등록번호'	, type: 'string'},
													{name: 'REL_NAME'			, text: '관계'			, type: 'string'},
													{name: 'IN_FORE_NAME'		, text: '내외국인'		, type: 'string'},
													{name: 'REL_CODE'			, text: '관계'			, type: 'string', store:Ext.data.StoreManager.lookup("relCodeStore")},
													{name: 'IN_FORE'			, text: '내외국인'		, type: 'string'},
													{name: 'DEFAULT_DED_YN'		, text: '기본공제'		, type: 'string'},
													{name: 'DEFORM_DED_YN'		, text: '장애인'		, type: 'string'},
													{name: 'OLD_DED_YN'			, text: '경로우대'		, type: 'string'}
												]
											});
											var humanFamilyPopupStore = Unilite.createStore('humanFamilyPopupStore',{
												model: 'humanFamilyPopupModel',
												uniOpt : {
													isMaster: false,		// 상위 버튼 연결
													editable: false,		// 수정 모드 사용
													deletable: false,		// 삭제 가능 여부
													useNavi: false			// prev | newxt 버튼 사용
												},
												autoLoad: false,
												proxy: {
													type: 'uniDirect',
													api: {
														read : 'had620ukrService.selectFamliy'
													}
												},
												loadStoreRecords: function(){
													var param= me.familyPopupWin.paramData;
													console.log( param );
													this.load({
														params: param
													});
												}
											});
											me.familyPopupWin = Ext.create('widget.uniDetailWindow', {
												title: '부양가족',
												width: 400,
												height:400,
												layout: {type:'vbox', align:'stretch'},
												items: [{
													itemId:'search',
													xtype:'uniSearchForm',
													style:{
														'background':'#fff'
													},
													height:35,
													layout:{type:'uniTable', columns:2},
													margine:'3 3 3 3',
													items:[{
														fieldLabel: '부양가족성명',
														name:'FAMILY_NAME',
														width:150,
														labelWidth:80
													},{
														fieldLabel: '가족주민번호',
														name:'REPRE_NUMB',
														width:200,
														labelWidth:80
													},{
														fieldLabel: '정산년도',
														name:'YEAR_YYYY',
														xtype: 'uniYearField',
														hidden:true,
														width:150,
														labelWidth:80,
														colspan:4
													},{
														fieldLabel: '성명',
														name:'NAME',
														hidden:true,
														width:150,
														labelWidth:80
													},{
														fieldLabel: '사번',
														name:'PERSON_NUMB',
														hidden:true,
														width:200,
														labelWidth:80
													}]
												},{
													xtype:'container',
													flex:1,
													layout: {type:'vbox', align:'stretch'},
													items:[
														Unilite.createGrid('humanFamilyPopupGrid', {
															itemId:'humanFamilyPopupGrid',
															layout : 'fit',
															store : humanFamilyPopupStore,
															sortableColumns: false,
															selModel:'rowmodel',
															uniOpt:{
																expandLastColumn: false,	//마지막 컬럼 * 사용 여부
																useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
																useLiveSearch: false,		//찾기 버튼 사용 여부
																filter: {					//필터 사용 여부
																	useFilter: false,
																	autoCreate: false
																},
																state: {
																	useState: false,			//그리드 설정 버튼 사용 여부
																	useStateList: false		//그리드 설정 목록 사용 여부
																}
															},
															columns:  [
																{dataIndex: 'FAMILY_NAME'	, width: 100},
																{dataIndex: 'REPRE_NUM'		, width: 130},
																{dataIndex: 'REL_CODE'		, width: 80},
																{dataIndex: 'IN_FORE_NAME'	, width: 80},
																{dataIndex: 'DEFAULT_DED_YN', width: 80},
																{dataIndex: 'DEFORM_DED_YN'	, width: 80},
																{dataIndex: 'OLD_DED_YN'	, width: 80}
															],
															listeners:{
																onGridDblClick:function(view, record, cellIndex, colName){
																	var grid = me.familyPopupWin.down("#humanFamilyPopupGrid")
																	var selRecord = grid.getSelectedRecord();
																	var medDocGrid = medDocWin.down("#had410ukrGrid")
																	var medDocRecord = medDocGrid.getSelectedRecord();

																	if(selRecord)	{
																		medDocRecord.set("REPRE_NUM", selRecord.get("REPRE_NUM"));
																		medDocRecord.set("FAMILY_NAME", selRecord.get("FAMILY_NAME"));
																		medDocRecord.set("REL_CODE", selRecord.get("REL_CODE"));

																		var sexChar = selRecord.get("REPRE_NUM").replace("-","").substring(6, 7);
																		var dYear = 0;
																		if(UniUtils.indexOf(sexChar, ["1", "2", "5", "6"]))	{
																			dYear = parseInt(me.familyPopupWin.paramData.YEAR_YYYY) - parseInt("19"+selRecord.get("REPRE_NUM").substring(0,2));
																		}else {
																			dYear = parseInt(me.familyPopupWin.paramData.YEAR_YYYY) - parseInt("20"+selRecord.get("REPRE_NUM").substring(0,2));
																		}
																		if(dYear >= 65)	{
																			strOldMedYn ="Y";
																		}else {
																			strOldMedYn ="N";
																		}

																		if(selRecord.get("REL_CODE") == "0")	{
																			medDocRecord.set("MED_CODE", "S");
																		}else if(strOldMedYn=="Y")	{
																			medDocRecord.set("MED_CODE", "L");
																		}else if(selRecord.get("DEFORM_DED_YN") == "Y")	{
																			medDocRecord.set("MED_CODE", "D");
																		}else {
																			medDocRecord.set("MED_CODE", "M");
																		}
																		
																		medDocRecord.set("MED_RELATION", selRecord.get("REL_CODE"));
																		medDocRecord.set("IN_FORE_SUPP", selRecord.get("IN_FORE"));
																		medDocRecord.set("DEFAULT_DED_YN", selRecord.get("DEFAULT_DED_YN"));
																		medDocRecord.set("DEFORM_DED_YN", selRecord.get("DEFORM_DED_YN"));
																		me.familyPopupWin.hide();
																	} else {
																		medDocRecord.set("REPRE_NUM", "");
																		medDocRecord.set("FAMILY_NAME", "");
																		medDocRecord.set("REL_CODE", "");
																	}
																}
															}
														})
													]
												}],
												tbar:['->',
													{
														itemId : 'searchBtn',
														text: '조회',
														handler: function() {
															humanFamilyPopupStore.loadStoreRecords();
														},
														disabled: false
													},{
														itemId : 'submitBtn',
														text: '확인',
														handler: function() {
															var grid = me.familyPopupWin.down("#humanFamilyPopupGrid")
															var selRecord = grid.getSelectedRecord();
															var medDocGrid = medDocWin.down("#had410ukrGrid")
															var medDocRecord = medDocGrid.getSelectedRecord();

															if(selRecord)	{
																medDocRecord.set("REPRE_NUM", selRecord.get("REPRE_NUM"));
																medDocRecord.set("FAMILY_NAME", selRecord.get("FAMILY_NAME"));

																var sexChar = selRecord.get("REPRE_NUM").replace("-","").substring(6, 7);
																var dYear = 0;
																if(UniUtils.indexOf(sexChar, ["1", "2", "5", "6"]))	{
																	dYear = parseInt(me.familyPopupWin.paramData.YEAR_YYYY) - parseInt("19"+selRecord.get("REPRE_NUM").substring(0,2));
																}else {
																	dYear = parseInt(me.familyPopupWin.paramData.YEAR_YYYY) - parseInt("20"+selRecord.get("REPRE_NUM").substring(0,2));
																}
																if(dYear >= 65)	{
																	strOldMedYn ="Y";
																}else {
																	strOldMedYn ="N";
																}

																if(selRecord.get("REL_CODE") == "0")	{
																	medDocRecord.set("MED_CODE", "S");
																}else if(strOldMedYn=="Y")	{
																	medDocRecord.set("MED_CODE", "L");
																}else if(selRecord.get("DEFORM_DED_YN") == "Y")	{
																	medDocRecord.set("MED_CODE", "D");
																}else {
																	medDocRecord.set("MED_CODE", "M");
																}
																
																medDocRecord.set("MED_RELATION", selRecord.get("REL_CODE"));
																medDocRecord.set("IN_FORE_SUPP", selRecord.get("IN_FORE"));
																medDocRecord.set("DEFAULT_DED_YN", selRecord.get("DEFAULT_DED_YN"));
																medDocRecord.set("DEFORM_DED_YN", selRecord.get("DEFORM_DED_YN"));
																me.familyPopupWin.hide();
															}else {
																medDocRecord.set("REPRE_NUM", "");
																medDocRecord.set("FAMILY_NAME", "");
															}
														},
														disabled: false
													},{
														itemId : 'closeBtn',
														text: '닫기',
														handler: function() {
															me.familyPopupWin.hide();
														},
														disabled: false
													}
												],
												listeners : {
													beforehide: function(me, eOpt)	{
														me.down('#search').clearForm();
													},
													beforeclose: function( panel, eOpts )	{
														me.down('#search').clearForm();
													},
													beforeshow: function( panel, eOpts )	{
														var searchForm =  panel.down('#search');
														searchForm.setValue("YEAR_YYYY"		,me.familyPopupWin.paramData.YEAR_YYYY);
														searchForm.setValue("NAME"			,me.familyPopupWin.paramData.NAME);
														searchForm.setValue("PERSON_NUMB"	,me.familyPopupWin.paramData.PERSON_NUMB);
														humanFamilyPopupStore.loadStoreRecords();
													}
												}
											});
										}
									}
									
									me.familyPopupWin.paramData = paramData;
									me.familyPopupWin.changes = false;
									me.familyPopupWin.center();
									me.familyPopupWin.show();
								}
							})
						]}
					],
					bbar:{
						layout: {
							pack: 'center',
							type: 'hbox'
						},
						dock:'bottom',
						items :  [{
							itemId : 'submitBtn',
							text: '저장',
							width:100,
							itemId: 'btnMedDocPopSaveAll',
							handler: function() {
								var store = Ext.data.StoreManager.lookup('had410ukrStore') ;
								if(store.isDirty())	{
									store.saveStore();
								}
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							width:100,
							handler: function() {
								var store = Ext.data.StoreManager.lookup('had410ukrStore') ;
								if(store.isDirty())	{
								 	if(confirm("저장할 내용이 있습니다. 저장하시겠습니까?")){
										store.saveStore();
										return;
								 	}
								}
								medDocWin.hide();
							},
							disabled: false
						}]
					},
					listeners : {
						beforehide: function(me, eOpt)	{
							medDocWin.down('#search').clearForm();
							if(medDocWin.changes)	{
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
						},
						beforeclose: function( panel, eOpts )	{
							medDocWin.down('#search').clearForm();
							if(medDocWin.changes) {
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
						},
						beforeshow: function( panel, eOpts )	{
							var searchForm =  medDocWin.down('#search');
							searchForm.setValue("YEAR_YYYY"		,medDocWin.paramData.YEAR_YYYY);
							searchForm.setValue("NAME"			,medDocWin.paramData.NAME);
							searchForm.setValue("PERSON_NUMB"	,medDocWin.paramData.PERSON_NUMB);
							searchForm.setValue("DEPT_NAME"		,medDocWin.paramData.DEPT_NAME);
							searchForm.setValue("POST_CODE_NAME",medDocWin.paramData.POST_CODE_NAME);
							had410ukrStore.loadStoreRecords();
							
							var payForm =  panel.down('#summary');
							var record400 = direct400Store.getAt(0);
							
							payForm.setValue("AMT_PAY", record400.get("INCOME_SUPP_TOTAL_I"));
							
							var medSummaryParams = {
									  'YEAR_YYYY'			: YEAR_YYYY
									, 'INCOME_SUPP_TOTAL_I'	: record400.get("INCOME_SUPP_TOTAL_I")	//총급여
									, 'MY_MED_DED_I' 		: record400.get("MY_MED_DED_I")			//본인의료비
									, 'SENIOR_MED_I'		: record400.get("SENIOR_MED_I")			//경로의료비
									, 'DEFORM_MED_I'		: record400.get("DEFORM_MED_I")	 	//장애의료비
									, 'SURGERY_MED_I'		: record400.get("SURGERY_MED_I")		//난임시술비
									, 'MED_TOTAL_I'			: record400.get("MED_TOTAL_I")			//그밖의 공제대상자 의료비
									, 'SERIOUS_SICK_MED_I'	: record400.get("SERIOUS_SICK_MED_I")//건보산정특례자의료비
							};
							had620ukrService.selectMedicalDed(medSummaryParams, function(responseText, response)	{
								if(responseText)	{
									payForm.setValue("MED_DED_I", responseText.MED_DED_STD_I);
								}
							});
							
							medDocWin.setCloseForm();
						}
					},
					setCloseForm : function() {
						medDocWin.down('#btnMedDocPopAdd').setDisabled(gbCloseYn);
						medDocWin.down('#btnMedDocPopDel').setDisabled(gbCloseYn);
						
						medDocWin.down('#btnMedDocPopSaveAll').setDisabled(gbCloseYn);
					}
				});
				
				var validationMedDoc = Unilite.createValidator('validatorMedDoc', {
					store: Ext.getCmp('had410ukrGrid').getStore(),
					grid: Ext.getCmp('had410ukrGrid'),
					validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
						if(newValue == oldValue){
							return false;
						}
						console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
						var rv = true;
						switch(fieldName) {
							case  "MED_COMPANY_NUM" :
							  if(record.obj.phantom)	{
								if(newValue != "" && record.get("TAX_GU") == "1")	{
									rv = Msg.fsbMsgH0148;
								}
								if(newValue == "" && record.get("TAX_GU") == "2")	{
									rv = Msg.fsbMsgH0115;
								}
							  }
							break;
							case "MED_PROOF_CODE" :
								if(newValue == "1" )	{
									record.set("TAX_GU", "1");
								}else {
									record.set("TAX_GU", "2");
								}
							break;
							case  "MED_CODE" :
								if(newValue == "B") {	//	산후조리원비
									var baseForm400 = Ext.getCmp("baseForm400");
									if(baseForm400.getValue("INCOME_SUPP_TOTAL_I") > 70000000) {
										rv = "총급여액이 7천만원 이하인 경우만 산후조리원비 내역을 입력할 수 있습니다.";
									}
								} 
								if(newValue == "D" && record.get("DEFORM_DED_YN") != "Y") {	//	장애인의료비
									rv = "장애인의료비내역은 장애인만 입력할 수 있습니다.";
								}
								if(newValue == "L") {	//	장애인의료비
									var repreNum = (record.get("REPRE_NUM")).replace(/-/gi, "");
									var chkYear1 = repreNum.substring(6, 7);
									var chkYear2 = repreNum.substring(0, 2);
									
									if(!(chkYear1 == "1" || chkYear1 == "2") || chkYear2 > "54") {
										rv = "경로의료비 내역은 65세 이상자만 입력할 수 있습니다.";
									}
								}
								if(newValue == "S" && record.get("REPRE_NUM") == "") {	//	본인의료비
									rv = "주민번호를 입력하세요.";
								}
								if(newValue == "S" && record.get("REL_CODE") != "0") {	//	본인의료비
									rv = "본인의료비 내역은 본인만 입력할 수 있습니다.";
								}
								break;
							default:
								break;
						}
						return rv;
					}
				});
			}
			medDocWin.paramData = paramData;
			medDocWin.changes = false;
			medDocWin.center();
			medDocWin.show();
		},
		//기부금내역 입력
		openDonation:function()	{
			if(!panelResult.isValid())	{
				return;
			}
			var paramData = {
				'YEAR_YYYY'			: panelResult.getValue('YEAR_YYYY'),
				'PERSON_NUMB'		: panelResult.getValue('PERSON_NUMB'),
				'NAME'				: panelResult.getValue('NAME'),
				'DEPT_NAME'			: panelResult.getValue('DEPT_NAME'),
				'POST_CODE_NAME'	: panelResult.getValue('POST_NAME'),
				'REPRE_NUM'			: panelResult.getValue('REPRE_NUM'),
				'LIVE_GUBUN'		: panelResult.getValue('LIVE_GUBUN')
			};
			if(!donationWin)	{
				Unilite.defineModel('had420ukrModel', {
					fields: [
						{name: 'PERSON_NUMB'			, text: '사번'					, type: 'string', allowBlank:false},
						{name: 'NAME'					, text: '성명'					, type: 'string'},
						{name: 'YEAR_YYYY'				, text: '정산년도'				, type: 'string', allowBlank:false},
						{name: 'PERSON_NAME'			, text: '사원명'				, type: 'string'},
						{name: 'IN_FORE'				, text: '내외국인'				, type: 'string', comboType:'AU', comboCode:'H118'},
						{name: 'GIFT_COMPANY_NUM'		, text: '사업자(주민)등록번호'	, type: 'string'},
						{name: 'GIFT_COMPANY_NAME'		, text: '상호'					, type: 'string'},
						{name: 'GIFT_TEXT'				, text: '기부내용'				, type: 'string'},
						{name: 'GIFT_YYMM'				, text: '기부년월'				, type: 'uniDate', allowBlank:false},

						{name: 'GIFT_CODE'				, text: '코드'					, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H119'},
						{name: 'TAX_GU'					, text: '영수증구분'			, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H120'},

						{name: 'GIFT_COUNT'				, text: '건수'					, type: 'uniNumber', minValue:0, allowBlank:false},
						{name: 'GIFT_AMOUNT_I'			, text: '금액'					, type: 'uniPrice', allowBlank:false, minValue:0},
						{name: 'POLICY_INDED'			, text: '정치자금'				, type: 'uniPrice'},
						{name: 'SBDY_APLN_SUM'			, text: '기부장려금'			, type: 'uniPrice', minValue:0, defaultValue:0},
						{name: 'CONB_SUM'				, text: '합계'					, type: 'uniPrice', minValue:0, defaultValue:0, editable:false},
						{name: 'FAMILY_NAME'			, text: '성명'					, type: 'string', allowBlank:false},
						{name: 'REPRE_NUM'				, text: '주민등록번호'			, type: 'string', allowBlank:false},
						{name: 'REL_CODE'				, text: '관계'					, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H140' , editable:false},
						{name: 'GIFT_NUM'				, text: '순번'					, type: 'int' },

						{name: 'LIVE_GUBUN'				, text: '거주구분'			, type: 'string', comboType:'AU', comboCode:'H115'}
					]
				});
				var had420ukrStore = Unilite.createStore('had420ukrStore',{
					model: 'had420ukrModel',
					uniOpt : {
						isMaster: false,			// 상위 버튼 연결
						editable: true,		// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 'had420ukrService.selectList'
							,update : 'had420ukrService.update'
							,create : 'had420ukrService.insert'
							,destroy : 'had420ukrService.delete'
							,syncAll: 'had420ukrService.saveAll'
						}
					},
					loadStoreRecords: function(){
						var param = donationWin.paramData;
						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function() {
						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);
						if(inValidRecs.length == 0) {
							config = {
								success: function(batch, option) {
									donationWin.changes = true;
									donationWin.unmask();
								}
							};
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('had420ukrGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}
				});

				donationWin = Ext.create('widget.uniDetailWindow', {
					title: '기부금명세등록',
					width: 1300,
					height:600,
					layout: {type:'vbox', align:'stretch'},
					items: [{
						itemId:'search',
						xtype:'uniSearchForm',
						style:{
							'background':'#fff'
						},
						height:65,
						layout:{type:'uniTable', columns:4},
						margine:'3 3 3 3',
						items:[{
							fieldLabel: '정산년도',
							name:'YEAR_YYYY',
							xtype: 'uniYearField',
							readOnly:true,
							width:150,
							labelWidth:80,
							colspan:4
						},{
							fieldLabel: '성명',
							name:'NAME',
							readOnly:true,
							width:150,
							labelWidth:80
						},{
							fieldLabel: '사번',
							name:'PERSON_NUMB',
							readOnly:true,
							width:200,
							labelWidth:80
						},{
							fieldLabel: '부서',
							name:'DEPT_NAME',
							readOnly:true,
							width:200,
							labelWidth:50
						},{
							fieldLabel: '직위',
							name:'POST_CODE_NAME',
							readOnly:true,
							width:150,
							labelWidth:50
						},{
							fieldLabel: '주민번호',
							name:'REPRE_NUM',
							readOnly:true,
							hidden:true
						},{
							fieldLabel: '거주구분',
							name:'LIVE_GUBUN',
							readOnly:true,
							hidden:true
						}]
					},{
							xtype:'container',
							flex:1,
							layout: {type:'vbox', align:'stretch'},
							items:[
								Unilite.createGrid('had420ukrGrid', {
									layout : 'fit',
									store : had420ukrStore,
									sortableColumns: false,
									uniOpt:{
										expandLastColumn: false,	//마지막 컬럼 * 사용 여부
										useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
										useLiveSearch: false,		//찾기 버튼 사용 여부
										filter: {					//필터 사용 여부
											useFilter: false,
											autoCreate: false
										},
										state: {
											useState: false,			//그리드 설정 버튼 사용 여부
											useStateList: false		//그리드 설정 목록 사용 여부
										}
									},
									tbar:[
										'->',
										{
											xtype:'button',
											text:'추가',
											itemId: 'btnDonationAdd',
											handler:function()	{
												var form = donationWin.down('#search');
												var grid = Ext.getCmp('had420ukrGrid');
												var record = Ext.create(had420ukrStore.model);
												rIndex = had420ukrStore.count();
												var seq = Unilite.nvl(had420ukrStore.max("GIFT_NUM"),0) + 1;

												record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
												record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
												record.set("GIFT_NUM", seq);
												had420ukrStore.insert(rIndex, record);
												grid.getSelectionModel().select(rIndex);
												var columns = grid.getVisibleColumns();
												var	sCell = grid.getView().getCell(record, columns[0], true);
												
												if(sCell)	{
													Ext.fly(sCell).focus();
												}
											}
										},{
											xtype:'button',
											text:'삭제',
											itemId: 'btnDonationDel',
											handler:function()	{
												var grid = Ext.getCmp('had420ukrGrid');
												had420ukrStore.remove(grid.getSelectionModel().getSelection());
											}
										},{
											xtype:'button',
											text:'공제기부금 가져오기',
											itemId: 'btnDonationRef',
											handler:function()	{
												var form = donationWin.down('#search');
												Ext.getBody().mask();
												had420ukrService.selectHad420Check(form.getValues(), function(responseText, response) {
													Ext.getBody().unmask();
													if(responseText)	{
														if(parseInt(responseText.CNT) > 0 )	{
															if(confirm(Msg.fsbMsgH0309)){
																Ext.getBody().mask();
																had420ukrService.saveHad420(form.getValues(), function(responseText, response) {
																	Ext.getBody().unmask();
																	donationWin.changes = true;
																	had420ukrStore.loadStoreRecords();
																});
															}
														} else {
															Ext.getBody().mask();
															had420ukrService.saveHad420(form.getValues(), function(responseText, response) {
																Ext.getBody().unmask();
																donationWin.changes = true;
																had420ukrStore.loadStoreRecords();
															});
														}
													}
												})
											}
										}
									],
									features: [
										{ ftype: 'uniSummary',		  showSummaryRow: true, dock :'bottom'}
									],
									columns:  [
										{text:'기부처', columns:[
											{dataIndex: 'GIFT_COMPANY_NUM'	, width: 130
											,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
												  return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
												}
											},
											{dataIndex: 'GIFT_COMPANY_NAME'		, width: 130}
										]},
										{dataIndex: 'GIFT_TEXT'	, width: 150},
										{dataIndex: 'GIFT_YYMM'		, width: 100, xtype:'uniMonthColumn',
											editor:{xtype:'uniMonthfield',format: 'Y.m' }},
										{dataIndex: 'GIFT_CODE'		, width: 100},
										{dataIndex: 'TAX_GU'		, width: 100},
										{dataIndex: 'GIFT_COUNT'		, width: 70, summaryType:'sum'},
										{dataIndex: 'GIFT_AMOUNT_I'		, width: 80, summaryType:'sum'},
										{dataIndex: 'SBDY_APLN_SUM'		, width: 100, summaryType:'sum'},
										{dataIndex: 'CONB_SUM'			, width: 80, summaryType:'sum'},
										{text:'기부자', columns:[
											{dataIndex: 'FAMILY_NAME'		, width: 60},
											{dataIndex: 'REPRE_NUM'		, width: 100},
											{dataIndex: 'REL_CODE'			, width:80}
										]}
									],
									listeners:{
										beforeedit:function(editor, context, eOpts)	{
											if(gbCloseYn) {
												return false;
											}

											if(context.field == "FAMILY_NAME" )	{
												context.grid.fnFamilyPopUp(context.record);
												return false;
											}
											if(context.field == "REPRE_NUM" )	{
												context.grid.fnFamilyPopUp(context.record);
												return false;
											}
										},
										onGridDblClick:function(grid, record, cellIndex, colName)	{
											if(colName == "FAMILY_NAME")	{
												grid.ownerCt.ownerGrid.fnFamilyPopUp(record);
											}
											if(colName == "REPRE_NUM")	{
												grid.ownerCt.ownerGrid.fnFamilyPopUp(record);
											}
										}
									},
									fnFamilyPopUp:function(record){
										var me = this;
										var paramData = {
											'YEAR_YYYY'		: record.get('YEAR_YYYY'),
											'PERSON_NUMB'	: record.get('PERSON_NUMB'),
											'NAME'			: record.get('NAME'),
											'DEPT_NAME'		: record.get('DEPT_NAME'),
											'POST_NAME'		: record.get('POST_NAME')
										};
										if(!me.familyPopupWin)	{
											if(!me.familyPopupWin)	{
												Unilite.defineModel('humanFamilyPopupModel2', {
													fields: [
														{name: 'FAMILY_NAME'		, text: '가족성명'		, type: 'string'},
														{name: 'REPRE_NUM'			, text: '주민등록번호'	, type: 'string'},
														{name: 'REL_NAME'			, text: '관계'			, type: 'string'},
														{name: 'IN_FORE_NAME'		, text: '내외국인'		, type: 'string'},
														{name: 'REL_CODE'			, text: '관계'			, type: 'string'},
														{name: 'IN_FORE'			, text: '내외국인'		, type: 'string'},
														{name: 'DEFAULT_DED_YN'		, text: '기본공제'		, type: 'string'},
														{name: 'DEFORM_DED_YN'		, text: '장애인'		, type: 'string'},
														{name: 'OLD_DED_YN'			, text: '경로우대'		, type: 'string'}
													]
												});
												var humanFamilyPopupStore2 = Unilite.createStore('humanFamilyPopupStore2',{
													model: 'humanFamilyPopupModel2',
													uniOpt : {
														isMaster: false,			// 상위 버튼 연결
														editable: false,		// 수정 모드 사용
														deletable: false,		// 삭제 가능 여부
														useNavi: false			// prev | newxt 버튼 사용
													},
													autoLoad: false,
													proxy: {
														type: 'uniDirect',
														api: {
															read : 'had620ukrService.selectFamliy'
														}
													},
													loadStoreRecords: function(){
														var param= me.familyPopupWin.paramData;
														console.log( param );
														this.load({
															params: param
														});
													}
												});
												me.familyPopupWin= Ext.create('widget.uniDetailWindow', {
													title: '부양가족',
													width: 400,
													height:400,
													layout: {type:'vbox', align:'stretch'},
													items: [{
															itemId:'search',
															xtype:'uniSearchForm',
															style:{
																'background':'#fff'
															},
															height:35,
															layout:{type:'uniTable', columns:2},
															margine:'3 3 3 3',
															items:[{
																fieldLabel: '부양가족성명',
																name:'FAMILY_NAME',
																width:150,
																labelWidth:80
															},{
																fieldLabel: '가족주민번호',
																name:'REPRE_NUMB',
																width:200,
																labelWidth:80
															},{
																fieldLabel: '정산년도',
																name:'YEAR_YYYY',
																xtype: 'uniYearField',
																hidden:true,
																width:150,
																labelWidth:80,
																colspan:4
															},{
																fieldLabel: '성명',
																name:'NAME',
																hidden:true,
																width:150,
																labelWidth:80
															},{
																fieldLabel: '사번',
																name:'PERSON_NUMB',
																hidden:true,
																width:200,
																labelWidth:80
															}]
													},{
															xtype:'container',
															flex:1,
															layout: {type:'vbox', align:'stretch'},
															items:[
																Unilite.createGrid('humanFamilyPopupGrid2', {
																	itemId:'humanFamilyPopupGrid2',
																	layout : 'fit',
																	store : humanFamilyPopupStore2,
																	sortableColumns: false,
																	selModel:'rowmodel',
																	uniOpt:{
																		expandLastColumn: false,	//마지막 컬럼 * 사용 여부
																		useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
																		useLiveSearch: false,		//찾기 버튼 사용 여부
																		filter: {					//필터 사용 여부
																			useFilter: false,
																			autoCreate: false
																		},
																		state: {
																			useState: false,			//그리드 설정 버튼 사용 여부
																			useStateList: false		//그리드 설정 목록 사용 여부
																		}
																	},
																	columns:  [
																		{dataIndex: 'FAMILY_NAME'	, width: 100},
																		{dataIndex: 'REPRE_NUM'		, width: 130},

																		{dataIndex: 'REL_NAME'		, width: 80},
																		{dataIndex: 'IN_FORE_NAME'	, width: 80},
																		{dataIndex: 'DEFAULT_DED_YN', width: 80},
																		{dataIndex: 'DEFORM_DED_YN'	, width: 80},
																		{dataIndex: 'OLD_DED_YN'	, width: 80}
																	],
																	listeners:{
																		onGridDblClick:function(view, record, cellIndex, colName){
																			var grid = me.familyPopupWin.down("#humanFamilyPopupGrid2")
																			var selRecord = grid.getSelectedRecord();
																			var donationGrid = donationWin.down("#had420ukrGrid")
																			var donationRecord = donationGrid.getSelectedRecord();

																			if(selRecord)	{

																				if (selRecord.get("REL_CODE") == "0") {
																					 donationRecord.set("REL_CODE", "1");
																				} else if(selRecord.get("REL_CODE") == "3") {
																					donationRecord.set("REL_CODE", "2");
																				} else if(selRecord.get("REL_CODE") == "4") {
																					 donationRecord.set("REL_CODE", "3");
																				} else if (selRecord.get("REL_CODE") == "1")	{
																					 donationRecord.set("REL_CODE", "4");
																				} else if (selRecord.get("REL_CODE") == "2") {
																					donationRecord.set("REL_CODE", "4");

																				} else if (selRecord.get("REL_CODE") == "5") {
																					donationRecord.set("REL_CODE", "5");
																				} else if (selRecord.get("REL_CODE") == "6") {
																					donationRecord.set("REL_CODE", "6");
																				}

																				 // '기부금구분 중 배우자와 직계비속이 기부할 수 없는 항목
																				 if(selRecord.get("REL_CODE") != "0")  {
																					 if(donationRecord.get("GIFT_CODE")== "")	{

																						Unilite.messageBox(Msg.fsbMsgH0126) ;
																						donationRecord.set("FAMILY_NAME", "");
																						donationRecord.set("REPRE_NUM", "");
																						donationRecord.set("REL_CODE", "");
																						donationRecord.set("IN_FORE", "");
																						me.familyPopupWin.hide();
																						 return;
																					 }

																					 if(donationRecord.get("GIFT_CODE") == "20" ||
																						donationRecord.get("GIFT_CODE") == "42" ) {
																						Unilite.messageBox(Msg.fsbMsgH0125) ;
																						donationRecord.set("FAMILY_NAME", "");
																						donationRecord.set("REPRE_NUM", "");
																						donationRecord.set("REL_CODE", "");
																						donationRecord.set("IN_FORE", "");
																						me.familyPopupWin.hide();
																						 return;
																					  }
																				 }

																				donationRecord.set("FAMILY_NAME", selRecord.get("FAMILY_NAME"));
																				donationRecord.set("REPRE_NUM", selRecord.get("REPRE_NUM"));
																				donationRecord.set("IN_FORE", selRecord.get("IN_FORE"));
																			}else {
																				donationRecord.set("FAMILY_NAME", "");
																				donationRecord.set("REPRE_NUM", "");
																				donationRecord.set("REL_CODE", "");
																				donationRecord.set("IN_FORE", "");
																			}
																			me.familyPopupWin.hide();
																		}
																	}
																})
															]}

													],
													tbar:['->',
															 {
																itemId : 'searchBtn',
																text: '조회',
																handler: function() {
																	humanFamilyPopupStore2.loadStoreRecords();
																},
																disabled: false
															},{
																itemId : 'submitBtn',
																text: '확인',
																handler: function() {
																			var grid = me.familyPopupWin.down("#humanFamilyPopupGrid2")
																			var selRecord = grid.getSelectedRecord();
																			var donationGrid = donationWin.down("#had420ukrGrid")
																			var donationRecord = donationGrid.getSelectedRecord();

																			if(selRecord)	{

																				if (selRecord.get("REL_CODE") == "0") {
																					 donationRecord.set("REL_CODE", "1");
																				} else if(selRecord.get("REL_CODE") == "3") {
																					donationRecord.set("REL_CODE", "2");
																				} else if(selRecord.get("REL_CODE") == "4") {
																					 donationRecord.set("REL_CODE", "3");
																				} else if (selRecord.get("REL_CODE") == "1")	{
																					 donationRecord.set("REL_CODE", "4");
																				} else if (selRecord.get("REL_CODE") == "2") {
																					donationRecord.set("REL_CODE", "4");

																				} else if (selRecord.get("REL_CODE") == "5") {
																					donationRecord.set("REL_CODE", "5");
																				} else if (selRecord.get("REL_CODE") == "6") {
																					donationRecord.set("REL_CODE", "6");
																				}

																				// '기부금구분 중 배우자와 직계비속이 기부할 수 없는 항목
																				if(selRecord.get("REL_CODE") == "3" || selRecord.get("REL_CODE") == "4")  {
																					if(donationRecord.get("GIFT_CODE")== "")	{

																						Unilite.messageBox(Msg.fsbMsgH0126) ;
																						donationRecord.set("FAMILY_NAME", "");
																						donationRecord.set("REPRE_NUM", "");
																						donationRecord.set("REL_CODE", "");
																						me.familyPopupWin.hide();
																						return;
																					}

																					if(donationRecord.get("GIFT_CODE") == "20" ||
																						donationRecord.get("GIFT_CODE") == "21" ||
																						donationRecord.get("GIFT_CODE") == "30" ||
																						donationRecord.get("GIFT_CODE") == "31" ||
																						donationRecord.get("GIFT_CODE") == "42" ) {
																						Unilite.messageBox(Msg.fsbMsgH0125) ;
																						donationRecord.set("FAMILY_NAME", "");
																						donationRecord.set("REPRE_NUM", "");
																						donationRecord.set("REL_CODE", "");
																						me.familyPopupWin.hide();
																						return;
																					}
																				}

																				donationRecord.set("FAMILY_NAME", selRecord.get("FAMILY_NAME"));
																				donationRecord.set("REPRE_NUM", selRecord.get("REPRE_NUM"));

																			} else {
																				donationRecord.set("FAMILY_NAME", "");
																				donationRecord.set("REPRE_NUM", "");
																				donationRecord.set("REL_CODE", "");
																			}
																			me.familyPopupWin.hide();
																		},
																disabled: false
															},{
																itemId : 'closeBtn',
																text: '닫기',
																handler: function() {
																	me.familyPopupWin.hide();
																},
																disabled: false
															}
													]
													,
													listeners : {
														beforehide: function(me, eOpt)	{
															me.down('#search').clearForm();
														},
														beforeclose: function( panel, eOpts )	{
															me.down('#search').clearForm();
														},
														beforeshow: function( panel, eOpts )	{
															var searchForm =  panel.down('#search');
															searchForm.setValue("YEAR_YYYY"		,me.familyPopupWin.paramData.YEAR_YYYY);
															searchForm.setValue("NAME"			,me.familyPopupWin.paramData.NAME);
															searchForm.setValue("PERSON_NUMB"	,me.familyPopupWin.paramData.PERSON_NUMB);
															humanFamilyPopupStore2.loadStoreRecords();

														}
													}
												});
											}
										}
											me.familyPopupWin.paramData = paramData;
											me.familyPopupWin.changes = false;
											me.familyPopupWin.center();
											me.familyPopupWin.show();

									}
								})
							]}

					],
					bbar:{
						layout: {
							pack: 'center',
							type: 'hbox'
						},
						dock:'bottom',
						items :  [
							 {
								itemId : 'submitBtn',
								text: '저장',
								width:100,
								itemId: 'btnDonationSaveAll',
								handler: function() {
									var store = Ext.data.StoreManager.lookup('had420ukrStore') ;
									if(store.isDirty())	{
										for(var lLoop = 0; lLoop < store.data.items.length; lLoop++) {
											var item = store.data.items[lLoop];
											
											if(item.phantom && item.hasOwnProperty("dirty") && item.dirty) {
												if(item.data["TAX_GU"] != "1" && item.data["GIFT_COMPANY_NUM"] == "") {
													Unilite.messageBox("국세청 자료가 아닌 경우 사업자등록번호는 필수입력입니다.");
													return;
												}
												if(item.data["TAX_GU"] != "1" && item.data["GIFT_COMPANY_NAME"] == "") {
													Unilite.messageBox("국세청 자료가 아닌 경우 상호는 필수입력입니다.");
													return;
												}
											}
										}
										
										store.saveStore();
									}
								},
								disabled: false
							},{
								itemId : 'closeBtn',
								text: '닫기',
								width:100,
								handler: function() {
									var store = Ext.data.StoreManager.lookup('had420ukrStore') ;
									if(store.isDirty())	{
										if(confirm("저장할 내용이 있습니다. 저장하시겠습니까?")){
											donationWin.down("#btnDonationSaveAll").handler();
											return;
										}
									}
									donationWin.hide();

								},
								disabled: false
							}
						]
					},
					listeners : {
						beforehide: function(me, eOpt)	{
							donationWin.down('#search').clearForm();
							if(donationWin.changes)	{
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
						},
						beforeclose: function( panel, eOpts )	{
							donationWin.down('#search').clearForm();
							if(donationWin.changes) {
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
						},
						beforeshow: function( panel, eOpts )	{
							var searchForm =  donationWin.down('#search');
							searchForm.setValue("YEAR_YYYY"		,donationWin.paramData.YEAR_YYYY);
							searchForm.setValue("NAME"			,donationWin.paramData.NAME);
							searchForm.setValue("PERSON_NUMB"	,donationWin.paramData.PERSON_NUMB);
							searchForm.setValue("DEPT_NAME"		,donationWin.paramData.DEPT_NAME);
							searchForm.setValue("POST_CODE_NAME",donationWin.paramData.POST_CODE_NAME);
							searchForm.setValue("REPRE_NUM"		,donationWin.paramData.REPRE_NUM);
							searchForm.setValue("LIVE_GUBUN",donationWin.paramData.LIVE_GUBUN);

							had420ukrStore.loadStoreRecords();

							donationWin.setCloseForm();
						}
					},
					setCloseForm : function() {
						donationWin.down('#btnDonationAdd').setDisabled(gbCloseYn);
						donationWin.down('#btnDonationDel').setDisabled(gbCloseYn);
						donationWin.down('#btnDonationRef').setDisabled(gbCloseYn);
						
						donationWin.down('#btnDonationSaveAll').setDisabled(gbCloseYn);
					}
					
					
				});
				
				var validationDonation = Unilite.createValidator('validatiorDonation', {
					store: Ext.getCmp('had420ukrGrid').getStore(),
					grid: Ext.getCmp('had420ukrGrid'),
					validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
						if(newValue == oldValue){
							return false;
						}
						console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
						var rv = true;
						
						var searchForm =  donationWin.down('#search');
						var sAfterValue = newValue;
						switch(fieldName)	{
							case "GIFT_CODE":
								if(sAfterValue == '20' || sAfterValue == '42')	{
									record.set("FAMILY_NAME",searchForm.getValue("NAME"));
									record.set("REPRE_NUM",searchForm.getValue("REPRE_NUM"));
									record.set("REL_CODE","1");
									record.set("LIVE_GUBUN",searchForm.getValue("LIVE_GUBUN"));
								}
								if(sAfterValue == '20')	{
									if(record.get("GIFT_AMOUNT_I") >= 100000 )	{
										record.set("POLICY_INDED",100000);
									} else {
										record.set("POLICY_INDED",record.get("GIFT_AMOUNT_I"));
									}
								}else {
									record.set("POLICY_INDED",0);
								}
							break;
							case "GIFT_AMOUNT_I":
								if(record.get("GIFT_CODE") == "20" )	{
									if(sAfterValue >= 100000 )	{
										record.set("POLICY_INDED",100000);
									} else {
										record.set("POLICY_INDED",sAfterValue);
									}
								} else {
									record.set("POLICY_INDED",0);
								}

								dTmp1 = newValue;
								dTmp2 = record.get("SBDY_APLN_SUM");
								var conbSum = dTmp1 + dTmp2;
								record.set("CONB_SUM",  conbSum);
							break;
							case "SBDY_APLN_SUM":
								dTmp1 = record.get("GIFT_AMOUNT_I");
								dTmp2 = newValue;
								var conbSum = dTmp1 + dTmp2;
								record.set("CONB_SUM",  conbSum);
							break;
							case "GIFT_COMPANY_NUM":
								if(sAfterValue && sAfterValue.length >0 )	{
									if (sAfterValue && sAfterValue.replace(/-/g,"").length < 10) {
										rv = Msg.sMB421;
									} else {
										if (sAfterValue && sAfterValue.replace(/-/g,"").length > 10 &&
											sAfterValue && sAfterValue.replace(/-/g,"").length  != 13 )	{
											rv = Msg.sMB421;
										}
									}
								}
							break;
							case "REL_CODE":
								var giftCode = record.get("GIFT_CODE");
								if((giftCode == '20' || giftCode == '42') && sAfterValue != "1")	{
									rv - Msg.fsbMsgH0307;
								}
							break;
							default:
							break;
						}
						
						return rv;
					}
				});
				
			}
			donationWin.paramData = paramData;
			donationWin.changes = false;
			donationWin.center();
			donationWin.show();

		},
		//월세납부내역 입력
		openRent:function(){
			var baseForm400 = Ext.getCmp("baseForm400");
			if(baseForm400.getValue("INCOME_SUPP_TOTAL_I") > 70000000) {
				Unilite.messageBox("총급여액이 7천만원 이하인 경우만 공제내역을 입력할 수 있습니다.");
				return;
			}

			if(!panelResult.isValid())	{
				return;
			}
			var paramData = {
				'YEAR_YYYY'			: panelResult.getValue('YEAR_YYYY'),
				'PERSON_NUMB'		: panelResult.getValue('PERSON_NUMB'),
				'NAME'				: panelResult.getValue('NAME'),
				'DEPT_NAME'			: panelResult.getValue('DEPT_NAME'),
				'POST_CODE_NAME'	: panelResult.getValue('POST_NAME')
			};
			if(!rentWin)	{

				Unilite.defineModel('had450ukrModel', {
					fields: [
						{name: 'PERSON_NUMB'		, text: '사번'				, type: 'string', allowBlank:false},
						{name: 'PERSON_NAME'		, text: '성명'				, type: 'string'},
						{name: 'YEAR_YYYY'			, text: '정산년도'			, type: 'string', allowBlank:false},
						{name: 'PERSON_NAME'		, text: '사원명'			, type: 'string'},
						{name: 'SEQ_NO'				, text: '순번'				, type: 'uniNumber'},
						{name: 'LEAS_NAME'			, text: '임대인성명'		, type: 'string', allowBlank:false},
						{name: 'REPRE_NUM'			, text: '주민등록번호'				, type: 'string', allowBlank:false},
						{name: 'LEAS_ADDR'			, text: '임대차계약서 상 주소지'	, type: 'string', allowBlank:false},
						{name: 'LEAS_BGN_DATE'		, text: '임차시작일'		, type: 'uniDate', allowBlank:false},

						{name: 'LEAS_END_DATE'		, text: '임차종료일'		, type: 'uniDate', allowBlank:false},
						{name: 'LEAS_DDCNT'			, text: '임차일수'			, type: 'uniNumber',defaultValue:0},

						{name: 'TAX_PRD_LEAS_DDCNT'	, text: '과세기간임차일수'	, type: 'uniNumber' ,defaultValue:0},
						{name: 'MNRT_TOTAL_I'		, text: '월세계약총액'		, type: 'uniPrice', allowBlank:false},
						{name: 'DDUC_OBJ_I'			, text: '공제대상금액'		,	 type: 'uniPrice', allowBlank:false},
						{name: 'HOUSE_TYPE'			, text: '주택유형'			, type: 'string', comboType:'AU', comboCode:'H180', allowBlank:false},
						{name: 'HOUSE_AREA'			, text: '주택계약면적(㎡)'	, type: 'uniPrice', allowBlank:false}

					 ]
				});
				var had450ukrStore = Unilite.createStore('had450ukrStore',{

					model: 'had450ukrModel',
					uniOpt : {
						isMaster: false,			// 상위 버튼 연결
						editable: true,		// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 'had450ukrService.selectList'
							,update : 'had450ukrService.update'
							,create : 'had450ukrService.insert'
							,destroy : 'had450ukrService.delete'
							,syncAll: 'had450ukrService.saveAll'
						}
					},
					loadStoreRecords: function(){
						var param= rentWin.paramData;
						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function()	{
						var toCreate = this.getNewRecords();
						var toUpdate = this.getUpdatedRecords();
						var toDelete = this.getRemovedRecords();
						var list = [].concat(toUpdate, toCreate);

						var checkValid = true;
						Ext.each(list, function(record, index) {
							// 비과세분 입력시 비과세 코드 입력 체크
							if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
								Unilite.messageBox(Msg.sMH1065 +'\n'+ Msg.fstMsgH0098);
								checkValid = false;
								return;
							}
						})
						if(!checkValid)	{
							return;
						}

						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);
						if(inValidRecs.length == 0) {
							config = {
										//params: [paramMaster],
										success: function(batch, option) {
											rentWin.changes = true;
											rentWin.unmask();
										}
								};
							//rentWin.mask();
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('had450ukrGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}

				});

				rentWin= Ext.create('widget.uniDetailWindow', {
					title: '월세납부내역등록',
					width: 1250,
					height:400,

					layout: {type:'vbox', align:'stretch'},
					items: [{
							itemId:'search',
							xtype:'uniSearchForm',
							 style:{
								'background':'#fff'
							},
							height:65,
							layout:{type:'uniTable', columns:4},
							margine:'3 3 3 3',
							items:[{
								fieldLabel: '정산년도',
								name:'YEAR_YYYY',
								xtype: 'uniYearField',
								readOnly:true,
								width:150,
								labelWidth:80,
								colspan:4
							},{
								fieldLabel: '성명',
								name:'NAME',
								readOnly:true,
								width:150,
								labelWidth:80
							},{
								fieldLabel: '사번',
								name:'PERSON_NUMB',
								readOnly:true,
								width:200,
								labelWidth:80
							},{
								fieldLabel: '부서',
								name:'DEPT_NAME',
								readOnly:true,
								width:200,
								labelWidth:50
							},{
								fieldLabel: '직위',
								name:'POST_CODE_NAME',
								readOnly:true,
								width:150,
								labelWidth:50
							}]},{
							xtype:'container',
							flex:1,
							layout: {type:'vbox', align:'stretch'},
							items:[
								Unilite.createGrid('had450ukrGrid', {
									layout : 'fit',
									store : had450ukrStore,
									sortableColumns: false,
									uniOpt:{
										expandLastColumn: false,	//마지막 컬럼 * 사용 여부
										useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
										useLiveSearch: false,		//찾기 버튼 사용 여부
										filter: {					//필터 사용 여부
											useFilter: false,
											autoCreate: false
										},
										state: {
											useState: false,			//그리드 설정 버튼 사용 여부
											useStateList: false		//그리드 설정 목록 사용 여부
										}
									},
									tbar:[
										'->',
										{
											xtype:'button',
											text:'추가',
											itemId: 'btnRentPopAdd',
											handler:function()	{
												var form = rentWin.down('#search');
												var grid = Ext.getCmp('had450ukrGrid');
												var record = Ext.create(had450ukrStore.model);
												rIndex = had450ukrStore.count();
												record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
												record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
												had450ukrStore.insert(rIndex, record);
												grid.getSelectionModel().select(rIndex);
												var columns = grid.getVisibleColumns();
												var	sCell = grid.getView().getCell(record, columns[0], true);
												
												if(sCell)	{
													Ext.fly(sCell).focus();
												}
											}
										},{
											xtype:'button',
											text:'삭제',
											itemId: 'btnRentPopDel',
											handler:function()	{
												var grid = Ext.getCmp('had450ukrGrid');
												had450ukrStore.remove(grid.getSelectionModel().getSelection());
											}
										}
									],
									columns:  [
										{dataIndex: 'LEAS_NAME'	, width: 80},
										{dataIndex: 'REPRE_NUM'		, width: 130},

										{dataIndex: 'LEAS_ADDR'	, width: 150},
										{dataIndex: 'LEAS_BGN_DATE'		, width: 80},
										{dataIndex: 'LEAS_END_DATE'		, width: 80},
										{dataIndex: 'LEAS_DDCNT'		, width: 80},
										{dataIndex: 'TAX_PRD_LEAS_DDCNT'	, width: 150},
										{dataIndex: 'HOUSE_TYPE'		, width: 100},
										{dataIndex: 'HOUSE_AREA'		, width: 130},
										{dataIndex: 'MNRT_TOTAL_I'		, width: 150},
										{dataIndex: 'DDUC_OBJ_I'		, minWidth:100,	flex: 1}

									],
									listeners:{
										beforeedit:function(editor, context, eOpts)	{
											if(gbCloseYn) {
												return false;
											}
											return true;
										}
									}
								})
							]}

					],
					bbar:{
						layout: {
							pack: 'center',
							type: 'hbox'
						},
						dock:'bottom',
						items :  [
							 {
								itemId : 'submitBtn',
								text: '저장',
								width:100,
								itemId: 'btnRentPopSaveAll',
								handler: function() {
									var store = Ext.data.StoreManager.lookup('had450ukrStore') ;
									if(store.isDirty())	{
										store.saveStore();
									}
								},
								disabled: false
							},{
								itemId : 'closeBtn',
								text: '닫기',
								width:100,
								handler: function() {
									var store = Ext.data.StoreManager.lookup('had450ukrStore') ;
									if(store.isDirty())	{
									 	if(confirm("저장할 내용이 있습니다. 저장하시겠습니까?")){
											store.saveStore();
											return;
									 	}
									}
									rentWin.hide();

								},
								disabled: false
							}
						]
					},
					listeners : {
						beforehide: function(me, eOpt)	{
							rentWin.down('#search').clearForm();
							if(rentWin.changes)	{
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
						},
						beforeclose: function( panel, eOpts )	{
							rentWin.down('#search').clearForm();
							if(rentWin.changes) {
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
						},
						beforeshow: function( panel, eOpts )	{
							var searchForm =  rentWin.down('#search');
							searchForm.setValue("YEAR_YYYY"		,rentWin.paramData.YEAR_YYYY);
							searchForm.setValue("NAME"			,rentWin.paramData.NAME);
							searchForm.setValue("PERSON_NUMB"	,rentWin.paramData.PERSON_NUMB);
							searchForm.setValue("DEPT_NAME"		,rentWin.paramData.DEPT_NAME);
							searchForm.setValue("POST_CODE_NAME",rentWin.paramData.POST_CODE_NAME);
							had450ukrStore.loadStoreRecords();

							rentWin.setCloseForm();
						}
					},
					setCloseForm : function() {
						rentWin.down('#btnRentPopAdd').setDisabled(gbCloseYn);
						rentWin.down('#btnRentPopDel').setDisabled(gbCloseYn);
						
						rentWin.down('#btnRentPopSaveAll').setDisabled(gbCloseYn);
					}
				});
				 
				var validationRent = Unilite.createValidator('validatorRent', {
					store: Ext.getCmp('had450ukrGrid').getStore(),
					grid: Ext.getCmp('had450ukrGrid'),
					validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
						if(newValue == oldValue){
							return false;
						}
						console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
						var rv = true;
						
						switch(fieldName) {
							case  "LEAS_BGN_DATE" :
							  if(!Ext.isEmpty(newValue) && !Ext.isEmpty(record.get("LEAS_END_DATE")))	{
								  
								  	var frDate = UniDate.extParseDate(newValue);
								  	var toDate = record.get("LEAS_END_DATE");
								  	
								  	var sFrDate = UniDate.extParseDate(newValue);
								  	var sToDate = record.get("LEAS_END_DATE");
								  	
								  	if(UniDate.diffDays(UniDate.extParseDate(YEAR_YYYY+'0101') , frDate) < 0 )	{
								  		frDate = UniDate.extParseDate(YEAR_YYYY+'0101');
								  	}
									
								  	if(UniDate.diffDays(UniDate.extParseDate(YEAR_YYYY+'1231') , toDate) > 0 )	{
								  		toDate = UniDate.extParseDate(YEAR_YYYY+'1231');
								  	}

									var sDateDiff	 = UniDate.diffDays(sFrDate, sToDate) + 1
									var dateDiff = UniDate.diffDays(frDate, toDate) + 1	
										
									record.set("LEAS_DDCNT", sDateDiff);
									record.set("TAX_PRD_LEAS_DDCNT", dateDiff);
									
								  	//공제대상금액 = (월세계약총액/임차일수)*과세기간임차일수
								  	var	sMnrtTotI = record.get("MNRT_TOTAL_I");
									var sDducobjI = (sMnrtTotI/sDateDiff)*dateDiff
							 		record.set("DDUC_OBJ_I", sDducobjI);  
							  }
							break;
							case "LEAS_END_DATE" :
								if(!Ext.isEmpty(newValue) && !Ext.isEmpty(record.get("LEAS_BGN_DATE")))	{
						  		  
								  	var frDate = record.get("LEAS_BGN_DATE");
								  	var toDate = UniDate.extParseDate(newValue);
								  	
								  	var sFrDate = record.get("LEAS_BGN_DATE");
								  	var sToDate = newValue;
								  	
								  	if(UniDate.diffDays(UniDate.extParseDate(YEAR_YYYY+'0101') , frDate) < 0 )	{
								  		frDate = UniDate.extParseDate(YEAR_YYYY+'0101');
								  	}
									
								  	if(UniDate.diffDays(UniDate.extParseDate(YEAR_YYYY+'1231') , toDate) > 0 )	{
								  		toDate = UniDate.extParseDate(YEAR_YYYY+'1231');
								  	}

									var sDateDiff	 = UniDate.diffDays(sFrDate, sToDate) + 1
									var dateDiff = UniDate.diffDays(frDate, toDate) + 1	
										
									record.set("LEAS_DDCNT", sDateDiff);
									record.set("TAX_PRD_LEAS_DDCNT", dateDiff);  
									
									var	sMnrtTotI = record.get("MNRT_TOTAL_I");
									
									//공제대상금액 = (월세계약총액/임차일수)*과세기간임차일수
									var sDducobjI = (sMnrtTotI/sDateDiff)*dateDiff
							 		record.set("DDUC_OBJ_I", sDducobjI);  
							  }
							break;
							case "LEAS_END_DATE" :
								if(!Ext.isEmpty(newValue) && !Ext.isEmpty(record.get("LEAS_BGN_DATE")))	{
						  		  
								  	var frDate = record.get("LEAS_BGN_DATE");
								  	var toDate = newValue;
								  	
								  	var sFrDate = record.get("LEAS_BGN_DATE");
								  	var sToDate = Ext.isDate(newValue) ? newValue : moment(newValue);
								  	
								  	if(UniDate.extFormatDate(YEAR_YYYY+'0101') > frDate )	{
								  		frDate = moment(YEAR_YYYY+'0101');
								  	}
									
								  	if(UniDate.extFormatDate(YEAR_YYYY+'1231') < toDate )	{
								  		toDate = moment(YEAR_YYYY+'1231');
								  	}

									var sDateDiff	 = UniDate.diffDays(sFrDate, sToDate) + 1
									var dateDiff = UniDate.diffDays(frDate, toDate) + 1	
										
									record.set("LEAS_DDCNT", sDateDiff);
									record.set("TAX_PRD_LEAS_DDCNT", dateDiff);  
									
									var	sMnrtTotI = record.get("MNRT_TOTAL_I");
									
									//공제대상금액 = (월세계약총액/임차일수)*과세기간임차일수
									var sDducobjI = (sMnrtTotI/sDateDiff)*dateDiff
							 		record.set("DDUC_OBJ_I", sDducobjI);  
							  }
							break;
							case "MNRT_TOTAL_I" :
								if(Ext.isEmpty(record.get("LEAS_BGN_DATE")) || Ext.isEmpty(record.get("LEAS_END_DATE")))	{
									rv = "임차기간을 먼저 입력하십시오.";
								}
						  		  
								var sDateDiff = record.get("LEAS_DDCNT");
								var dateDiff  = record.get("TAX_PRD_LEAS_DDCNT");  
								
								var	sMnrtTotI = newValue;
								
								//공제대상금액 = (월세계약총액/임차일수)*과세기간임차일수
								var sDducobjI = (sMnrtTotI/sDateDiff)*dateDiff
								record.set("DDUC_OBJ_I", sDducobjI);  
							break;
							default:
								break;
						}
						return rv;
					}
				});  
				
			}
			rentWin.paramData = paramData;
			rentWin.changes = false;
			rentWin.center();
			rentWin.show();



		},
		//주택임차차입금 입력
		openHouseLoan:function(){

			if(!panelResult.isValid())	{
				return;
			}
			var paramData = {
				//'YEAR_YYYY'		: panelSearch.getValue('YEAR_YYYY'),
				//'PERSON_NUMB'	: panelSearch.getValue('PERSON_NUMB'),
				//'NAME'			: panelSearch.getValue('NAME'),
				//'DEPT_NAME'		: panelSearch.getValue('DEPT_NAME'),
				//'POST_CODE_NAME'		: panelSearch.getValue('POST_CODE_NAME')
				'YEAR_YYYY'			: panelResult.getValue('YEAR_YYYY'),
				'PERSON_NUMB'		: panelResult.getValue('PERSON_NUMB'),
				'NAME'				: panelResult.getValue('NAME'),
				'DEPT_NAME'			: panelResult.getValue('DEPT_NAME'),
				'POST_CODE_NAME'	: panelResult.getValue('POST_NAME')
			};
			if(!houseLoanWin)	{

				Unilite.defineModel('had451ukrModel', {
					fields: [
						{name: 'YEAR_YYYY'			, text: '정산년도'		, type: 'string',		allowBlank:false},
						{name: 'PERSON_NUMB'		, text: '사번'		, type: 'string',		allowBlank:false},
						{name: 'SEQ_NO'				, text: '순번'		, type: 'uniNumber'},
						{name: 'LEAS_NAME'			, text: '대주성명'		, type: 'string',		allowBlank:false},
						{name: 'REPRE_NUM'			, text: '주민등록번호'	, type: 'string',		allowBlank:false},
						{name: 'LEAS_BGN_DATE'		, text: '계약시작일'		, type: 'uniDate',		allowBlank:false},
						{name: 'LEAS_END_DATE'		, text: '계약종료일'		, type: 'uniDate',		allowBlank:false},
						{name: 'LEAS_RATE'			, text: '차입금이자율'	, type: 'uniNumber',	defaultValue:0.0},
						{name: 'LEAS_RETURN_I'		, text: '상환액'		, type: 'uniPrice',		defaultValue:0},
						{name: 'LEAS_ORI_I'			, text: '원금'		, type: 'uniPrice',		defaultValue:0},
						{name: 'LEAS_INTEREST_I'	, text: '이자'		, type: 'uniPrice',		defaultValue:0},
						{name: 'LEAS_DED_I'			, text: '공제금액'		, type: 'uniPrice',		defaultValue:0}
					 ]
				});
				Unilite.defineModel('had452ukrModel', {
					fields: [
						{name: 'YEAR_YYYY'			, text: '정산년도'		, type: 'string',		allowBlank:false},
						{name: 'PERSON_NUMB'		, text: '사번'		, type: 'string',		allowBlank:false},
						{name: 'SEQ_NO'				, text: '순번'		, type: 'uniNumber'},
						{name: 'LEAS_NAME'			, text: '대주성명'		, type: 'string',		allowBlank:false},
						{name: 'REPRE_NUM'			, text: '주민등록번호'	, type: 'string',		allowBlank:false},
						{name: 'LEAS_HOUSE_TYPE'	, text: '주택유형'		, type: 'string',		allowBlank:false, comboType:'AU', comboCode:'H180'},
						{name: 'LEAS_HOUSE_AREA'	, text: '주택면적'		, type: 'uniQty',		defaultValue:0.00},
						{name: 'LEAS_ADDR'			, text: '주소지'		, type: 'string'},
						{name: 'LEAS_BGN_DATE'		, text: '계약시작일'		, type: 'uniDate',		allowBlank:false},
						{name: 'LEAS_END_DATE'		, text: '계약종료일'		, type: 'uniDate',		allowBlank:false},
						{name: 'YEAR_RENT_I'		, text: '전세보증금'		, type: 'uniPrice',		defaultValue:0}
					 ]
				});
				var had451ukrStore = Unilite.createStore('had451ukrStore',{

					model: 'had451ukrModel',
					uniOpt : {
						isMaster: false,			// 상위 버튼 연결
						editable: true,		// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 'had451ukrService.selectList'
							,update : 'had451ukrService.update'
							,create : 'had451ukrService.insert'
							,destroy : 'had451ukrService.delete'
							,syncAll: 'had451ukrService.saveAll'
						}
					},
					loadStoreRecords: function(){
						var param= houseLoanWin.paramData;
						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function()	{
						var toCreate = this.getNewRecords();
						var toUpdate = this.getUpdatedRecords();
						var toDelete = this.getRemovedRecords();
						var list = [].concat(toUpdate, toCreate);

						var checkValid = true;
						//Ext.each(list, function(record, index) {
							//// 비과세분 입력시 비과세 코드 입력 체크
							//if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
							//	Unilite.messageBox(Msg.sMH1065 +'\n'+ Msg.fstMsgH0098);
							//	checkValid = false;
							//	return;
							//}
						//})
						if(!checkValid)	{
							return;
						}

						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);
						if(inValidRecs.length == 0) {
							config = {
										//params: [paramMaster],
										success: function(batch, option) {
											houseLoanWin.changes = true;
											houseLoanWin.unmask();
										}
								};
							//rentWin.mask();
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('had451ukrGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}

				});

				var had452ukrStore = Unilite.createStore('had452ukrStore',{

					model: 'had452ukrModel',
					uniOpt : {
						isMaster: false,			// 상위 버튼 연결
						editable: true,		// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							read : 'had452ukrService.selectList'
							,update : 'had452ukrService.update'
							,create : 'had452ukrService.insert'
							,destroy : 'had452ukrService.delete'
							,syncAll: 'had452ukrService.saveAll'
						}
					},
					loadStoreRecords: function(){
						var param= houseLoanWin.paramData;
						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function()	{
						var toCreate = this.getNewRecords();
						var toUpdate = this.getUpdatedRecords();
						var toDelete = this.getRemovedRecords();
						var list = [].concat(toUpdate, toCreate);

						var checkValid = true;
						//Ext.each(list, function(record, index) {
							//// 비과세분 입력시 비과세 코드 입력 체크
							//if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
							//	Unilite.messageBox(Msg.sMH1065 +'\n'+ Msg.fstMsgH0098);
							//	checkValid = false;
							//	return;
							//}
						//})
						if(!checkValid)	{
							return;
						}

						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);
						if(inValidRecs.length == 0) {
							config = {
										//params: [paramMaster],
										success: function(batch, option) {
											houseLoanWin.changes = true;
											houseLoanWin.unmask();
										}
								};
							//rentWin.mask();
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('had452ukrGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}

				});

				houseLoanWin= Ext.create('widget.uniDetailWindow', {
					title: '거주자간 주택임차차입금 내역등록',
					width: 800,
					height:400,

					layout: {type:'vbox', align:'stretch'},
					items: [{
							itemId:'search',
							xtype:'uniSearchForm',
							 style:{
								'background':'#fff'
							},
							height:65,
							layout:{type:'uniTable', columns:4},
							margine:'3 3 3 3',
							items:[{
								fieldLabel: '정산년도',
								name:'YEAR_YYYY',
								xtype: 'uniYearField',
								readOnly:true,
								width:150,
								labelWidth:80,
								colspan:4
							},{
								fieldLabel: '성명',
								name:'NAME',
								readOnly:true,
								width:150,
								labelWidth:80
							},{
								fieldLabel: '사번',
								name:'PERSON_NUMB',
								readOnly:true,
								width:200,
								labelWidth:80
							},{
								fieldLabel: '부서',
								name:'DEPT_NAME',
								readOnly:true,
								width:200,
								labelWidth:50
							},{
								fieldLabel: '직위',
								name:'POST_CODE_NAME',
								readOnly:true,
								width:150,
								labelWidth:50
							}]},{
							xtype:'container',
							flex:1,
							layout: {type:'vbox', align:'stretch'},
							items:[
									Unilite.createTabPanel('tabHouseLoanPanel',{
										region: 'center',
										activeTab: 0,
										id: 'tabHouseLoan',
										plugins:[{
											ptype: 'uniTabscrollermenu',
											maxText  : 20,
											pageSize : 20
										}],
								//		tabPosition: 'left',
								//		tabRotation: 0,
										items: [{
											 title: '금전소비대차계약내역'
											 ,id: 'had451ukrTab'
											 ,autoScroll: true
											 ,items:[{
														xtype:'container',
														flex:1,
														layout: {type:'vbox', align:'stretch'},
														items:[
													Unilite.createGrid('had451ukrGrid', {
														layout : 'fit',
														store : had451ukrStore,
														sortableColumns: false,
														uniOpt:{
															expandLastColumn: false,	//마지막 컬럼 * 사용 여부
															useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
															useLiveSearch: false,		//찾기 버튼 사용 여부
															filter: {					//필터 사용 여부
																useFilter: false,
																autoCreate: false
															},
															state: {
																useState: false,			//그리드 설정 버튼 사용 여부
																useStateList: false		//그리드 설정 목록 사용 여부
															}
														},
														tbar:[
															'->',
															{
																xtype:'button',
																text:'추가',
																itemId: 'btnHouseLoanPopTab1Add',
																handler:function()	{
																	var form = houseLoanWin.down('#search');
																	var grid = Ext.getCmp('had451ukrGrid');
																	var record = Ext.create(had451ukrStore.model);
																	rIndex = had451ukrStore.count();
																	record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
																	record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
																	had451ukrStore.insert(rIndex, record);
																	grid.getSelectionModel().select(rIndex);
																	var columns = grid.getVisibleColumns();
																	var	sCell = grid.getView().getCell(record, columns[0], true);
																	
																	if(sCell)	{
																		Ext.fly(sCell).focus();
																	}
																}
															},{
																xtype:'button',
																text:'삭제',
																itemId: 'btnHouseLoanPopTab1Del',
																handler:function()	{
																	var grid = Ext.getCmp('had451ukrGrid');
																	had451ukrStore.remove(grid.getSelectionModel().getSelection());
																}
															}
														],
														columns:  [
															{dataIndex: 'LEAS_NAME',			width: 80},
															{dataIndex: 'REPRE_NUM',			width: 130},
															{dataIndex: 'LEAS_BGN_DATE',		width: 80},
															{dataIndex: 'LEAS_END_DATE',		width: 80},
															{dataIndex: 'LEAS_RATE',			width: 100},
															{dataIndex: 'LEAS_RETURN_I',		width: 100},
															{dataIndex: 'LEAS_ORI_I',			width: 100},
															{dataIndex: 'LEAS_INTEREST_I',		width: 100, flex:1}
														],
														listeners:{
															beforeedit:function(editor, context, eOpts)	{
																if(gbCloseYn) {
																	return false;
																}
															}
														}
													})

													]}
											 ]
										},{
											 title: '임대차계약내역'
											 ,id: 'had452ukrTab'
											 ,autoScroll: true
											 ,items:[{
														xtype:'container',
														flex:1,
														layout: {type:'vbox', align:'stretch'},
														items:[
													Unilite.createGrid('had452ukrGrid', {
														layout : 'fit',
														store : had452ukrStore,
														sortableColumns: false,
														uniOpt:{
															expandLastColumn: false,	//마지막 컬럼 * 사용 여부
															useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
															useLiveSearch: false,		//찾기 버튼 사용 여부
															filter: {					//필터 사용 여부
																useFilter: false,
																autoCreate: false
															},
															state: {
																useState: false,			//그리드 설정 버튼 사용 여부
																useStateList: false		//그리드 설정 목록 사용 여부
															}
														},
														tbar:[
															'->',
															{
																xtype:'button',
																text:'추가',
																itemId: 'btnHouseLoanPopTab2Add',
																handler:function()	{
																	var form = houseLoanWin.down('#search');
																	var grid = Ext.getCmp('had452ukrGrid');
																	var record = Ext.create(had452ukrStore.model);
																	rIndex = had452ukrStore.count();
																	record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
																	record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
																	had452ukrStore.insert(rIndex, record);
																	grid.getSelectionModel().select(rIndex);
																	var columns = grid.getVisibleColumns();
																	var	sCell = grid.getView().getCell(record, columns[0], true);
																	
																	if(sCell)	{
																		Ext.fly(sCell).focus();
																	}
																}
															},{
																xtype:'button',
																text:'삭제',
																itemId: 'btnHouseLoanPopTab2Del',
																handler:function()	{
																	var grid = Ext.getCmp('had452ukrGrid');
																	had452ukrStore.remove(grid.getSelectionModel().getSelection());
																}
															}
														],
														columns:  [

															{dataIndex: 'LEAS_NAME',			width: 70},
															{dataIndex: 'REPRE_NUM',			width: 120},
															{dataIndex: 'LEAS_HOUSE_TYPE',		width: 70},
															{dataIndex: 'LEAS_HOUSE_AREA',		width: 70},
															{dataIndex: 'LEAS_ADDR',			width: 150},
															{dataIndex: 'LEAS_BGN_DATE',		width: 80},
															{dataIndex: 'LEAS_END_DATE',		width: 80},
															{dataIndex: 'YEAR_RENT_I',			width: 120, flex:1}
														],
														listeners:{
															beforeedit:function(editor, context, eOpts)	{
																if(gbCloseYn) {
																	return false;
																}
															}
														}
													})

													]}
											 ]
										}],
										listeners:{
											beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts ){

											}
										}
									})

							]}

					],
					bbar:{
						layout: {
							pack: 'center',
							type: 'hbox'
						},
						dock:'bottom',
						items :  [
							 {
								itemId : 'submitBtn',
								text: '저장',
								width:100,
								itemId: 'btnHouseLoanPopSaveAll',
								handler: function() {
									var store = Ext.data.StoreManager.lookup('had451ukrStore');
									if(store.isDirty())	{
										store.saveStore();
									}
									store = Ext.data.StoreManager.lookup('had452ukrStore');
									if(store.isDirty())	{
										store.saveStore();
									}
								},
								disabled: false
							},{
								itemId : 'closeBtn',
								text: '닫기',
								width:100,
								handler: function() {
									var store1 = Ext.data.StoreManager.lookup('had451ukrStore') ;
									var store2 = Ext.data.StoreManager.lookup('had452ukrStore') ;
									if(store1.isDirty() || store2.isDirty())	{
									 	if(confirm("저장할 내용이 있습니다. 저장하시겠습니까?")){
									 		houseLoanWin.down("#btnHouseLoanPopSaveAll").handler();
											return;
									 	}
									}
									houseLoanWin.hide();

								},
								disabled: false
							}
						]
					},
					listeners : {
						beforehide: function(me, eOpt)	{
							houseLoanWin.down('#search').clearForm();
							if(houseLoanWin.changes)	{
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
						},
						beforeclose: function( panel, eOpts )	{
							houseLoanWin.down('#search').clearForm();
							if(houseLoanWin.changes) {
								UniAppManager.app.fnCollectData("INCOME_DED");
							}
						},
						beforeshow: function( panel, eOpts )	{
							houseLoanWin.setCloseForm();
							
							var searchForm =  houseLoanWin.down('#search');
							searchForm.setValue("YEAR_YYYY"		,houseLoanWin.paramData.YEAR_YYYY);
							searchForm.setValue("NAME"			,houseLoanWin.paramData.NAME);
							searchForm.setValue("PERSON_NUMB"	,houseLoanWin.paramData.PERSON_NUMB);
							searchForm.setValue("DEPT_NAME"		,houseLoanWin.paramData.DEPT_NAME);
							searchForm.setValue("POST_CODE_NAME",houseLoanWin.paramData.POST_CODE_NAME);
							had451ukrStore.loadStoreRecords();
							had452ukrStore.loadStoreRecords();
						}
					},
					setCloseForm : function() {
						houseLoanWin.down('#btnHouseLoanPopTab1Add').setDisabled(gbCloseYn);
						houseLoanWin.down('#btnHouseLoanPopTab1Del').setDisabled(gbCloseYn);
						houseLoanWin.down('#btnHouseLoanPopTab2Add').setDisabled(gbCloseYn);
						houseLoanWin.down('#btnHouseLoanPopTab2Del').setDisabled(gbCloseYn);
						
						houseLoanWin.down('#btnHouseLoanPopSaveAll').setDisabled(gbCloseYn);
					}
				});
			}
			houseLoanWin.paramData = paramData;
			houseLoanWin.changes = false;
			houseLoanWin.center();
			houseLoanWin.show();
		},
		openPDF:function() {
			if(direct400Store.isDirty() || direct600Store.isDirty()) {
				Unilite.messageBox('저장할 데이타가 있습니다. 저장 후 실행해 주세요.');
				return;
			}
			var record400 = direct400Store.getAt(0);
			var paramData = {
				'YEAR_YYYY'			  : panelResult.getValue('YEAR_YYYY'),
				'PERSON_NUMB'		  : panelResult.getValue('PERSON_NUMB'),
				'NAME'				  : panelResult.getValue('NAME'),
				'DEPT_NAME'			  : panelResult.getValue('DEPT_NAME'),
				'POST_CODE_NAME'	  : panelResult.getValue('POST_NAME'),
				'FOREIGN_NUM'		  : record400.get('FOREIGN_NUM'),
				'FORE_SINGLE_YN'	  : (record400.get('FORE_SINGLE_YN') == true || record400.get('FORE_SINGLE_YN') == "Y" ) ? "Y" : "N" ,
				'FOREIGN_DISPATCH_YN' : (record400.get('FOREIGN_DISPATCH_YN') == true || record400.get('FOREIGN_DISPATCH_YN') == "Y" ) ? "Y" : "N" 
			};
			
			if(!pdfWin) {
				Unilite.defineModel('hadPdfModel', {
					fields: [
						{name: 'DOC_ID'			, text: '순번'		, type: 'int'		, allowBlank:false},
						{name: 'PERSON_NUMB'	, text: '사번'		, type: 'string'	, allowBlank:false},
						{name: 'YEAR_YYYY'		, text: '정산년도'		, type: 'string'	, allowBlank:false},
						{name: 'GUBUN_CODE'		, text: '구분코드'		, type: 'string'	, allowBlank:false},
						{name: 'GUBUN_NAME'		, text: '항목명'		, type: 'string'	, allowBlank:false},
						{name: 'D_NAME'			, text: '대상자'		, type: 'string'},
						{name: 'D_REPRE_NUM'	, text: '주민번호'		, type: 'string'},
						{name: 'DATA_CD'		, text: '유형코드'		, type: 'string'},
						{name: 'DATA_NAME'		, text: '유형'		, type: 'string'},
						{name: 'LSOR_NM'		, text: '임대인'		, type: 'string'},
						{name: 'ADR'			, text: '주소'		, type: 'string'},
						{name: 'USE_PLACE_CD'	, text: '종류'		, type: 'string'},
						{name: 'CARD_TYPE_NAME'	, text: '유형'		, type: 'string'},
						{name: 'USE_AMT'		, text: '금액'		, type: 'uniPrice'},
						{name: 'USE_AMT1'		, text: '3월'		, type: 'uniPrice'},
						{name: 'USE_AMT2'		, text: '4~7월'		, type: 'uniPrice'},
						{name: 'USE_AMT3'		, text: '그 외'		, type: 'uniPrice'},
						{name: 'SBDY_APLN_SUM'	, text: '기부장려금'		, type: 'uniPrice'},
						{name: 'CONB_SUM'		, text: '합계'		, type: 'uniPrice'},
						{name: 'D_RES_NO'		, text: 'D_RES_NO'	, type: 'string'},
						{name: 'TARGET_YN'		, text: '대상'		, type: 'boolean'}
					]
				});
				var hadPdfStore = Unilite.createStore('hadPdfStore',{
					model: 'hadPdfModel',
					uniOpt : {
						isMaster: false,			// 상위 버튼 연결
						editable: true,		// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi: false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'uniDirect',
						api: {
							  read : 'had620ukrService.selectPdfList'
							, update : 'had620ukrService.updatePdf'
							, syncAll: 'had620ukrService.saveAllPdf'
						}
					},
					filters:[
						function(item) {
							return item.get('GUBUN_CODE') == 'A102Y';
						}
					],
					loadStoreRecords: function(){
						var param= pdfWin.paramData;
						console.log( param );
						this.load({
							params: param
						});
					},
					saveStore:function(config)	{
						var inValidRecs = this.getInvalidRecords();
						console.log("inValidRecords : ", inValidRecs);
						if(inValidRecs.length == 0) {
							if(!config)	{
								config = {
									success: function(batch, option) {
										pdfWin.unmask();
										pdfWin.loadSummary();
									}
								};
							}
							
							var toUpdate = this.getUpdatedRecords();
							if(toUpdate != null && toUpdate.length > 0) {
								pdfWin.mask();
							}
							this.syncAllDirect(config);
						} else {
							var grid = Ext.getCmp('hadPdfGrid');
							grid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					},
					refreshFilter:function(gubunCode) {
						this.clearFilter();
						if(!Ext.isArray(gubunCode)) {
							this.filter('GUBUN_CODE', gubunCode);
						} else {
							this.filterBy(function(record) {
								var r = false;
								Ext.each(gubunCode, function(item){
									if(item == record.get('GUBUN_CODE')) {
										r = true;
									}
								});
								return r;
							});
						}
					}
				});
				
				pdfWin = Ext.create('widget.uniDetailWindow', {
					title: 'PDF업로드',
					width: 1200,
					height:800,
					layout: {type:'vbox', align:'stretch'},
					items: [{
						itemId	: 'search',
						xtype	: 'uniSearchForm',
						style	: {'background':'#fff'},
						height	: 35,
						layout	: {type:'uniTable', columns:4},
						margine	: '3 3 3 3',
						items:[{
							fieldLabel	: '정산년도',
							name		: 'YEAR_YYYY',
							xtype		: 'uniYearField',
							width		: 150,
							labelWidth	: 80,
							readOnly	: true,
							allowBlank	: false,
							listeners: {
								change:function(field, newValue, oldValue)	{
									if(newValue != oldValue)	{
										pdfWin.loadSummary('YEAR_YYYY', newValue);
									}
								}
							}
						},
						Unilite.popup('Employee',{
							validateBlank	: false,
							allowBlank		: false,
							readOnly		: true,
							listeners: {
								onSelected:function(records, type) {
									if(records) {
										var searchForm = pdfWin.down('#search');
										searchForm.setValue("DEPT_NAME",records[0]['DEPT_NAME']);
										searchForm.setValue("POST_CODE_NAME",records[0]['POST_CODE_NAME']);
										pdfWin.paramData = searchForm.getValues();
										pdfWin.loadSummary();
									}
								}
							}
						}),
						{
							name		: 'DEPT_NAME',
							fieldLabel	: '부서',
							readOnly	: true,
							hidden		: false
						},
						{
							name		: 'POST_CODE_NAME',
							fieldLabel	: '직위',
							readOnly	: true,
							hidden		: false
						}]
					},{
						itemId	: 'pdfUploadForm',
						xtype	: 'uniDetailForm',
						style	: {'background':'#fff'},
						height	: 35,
						layout	: {type:'uniTable', columns:7, tableAttrs:{cellspacing:0}},
						disabled: false,
						api: {
							submit: had620ukrService.pdfUploadFile
						},
						items:[{
							xtype		: 'button',
							text		: '1.부양가족확인',
							handler:function(){
								UniAppManager.app.openFamily('P', pdfWin.down('#search'));
							}
						},{
							xtype		: 'component',
							html		: '&nbsp;&nbsp;&nbsp;->&nbsp;'
						},{
							xtype		: 'filefield',
							buttonOnly	: false,
							fieldLabel	: 'PDF파일',
							labelWidth	: 60,
							width		: 400,
							name		: 'pdfFile',
							buttonText	: '찾아보기',
							allowBlank	: false,
							itemId		: 'btnPdfPopFile'
						},{
							xtype		: 'component',
							html		: '&nbsp;&nbsp;'
						},{
							xtype		: 'button',
							text		: '2.PDF 업로드',
							itemId		: 'btnPdfPopUpload',
							handler:function(){
								var uploadForm = pdfWin.down("#pdfUploadForm");
								var searchForm = pdfWin.down('#search');
								var params = searchForm.getValues();
								
								params.ORG_FIEL_NAME = uploadForm.getValue("pdfFile");
								
								if(uploadForm.isValid()) {
									uploadForm.submit({
										params : params,
										waitMsg: 'Uploading files...',
										success: function(form, action) {
											pdfWin.mask();
											had620ukrService.pdfRead(action.params, function(responseText, response){
												pdfWin.unmask();
												if(!response.message) {
													UniAppManager.updateStatus('파일이 등록되었습니다.');
													pdfWin.loadSummary();
												}
											});
										},
										failure:function(form, action)	{
											Unilite.messageBox("파일 등록 중 오류가 발생했습니다.");
										}
									});
								} else {
									Unilite.messageBox('pdf 파일을 선택해 주세요.');
								}
							}
						},{
							xtype		: 'component',
							html		: '&nbsp;&nbsp;&nbsp;->&nbsp;&nbsp;&nbsp;'
						},{
							xtype		: 'button',
							text		: '3.PDF 자료반영',
							itemId		: 'btnPdfPopApply',
							handler:function(){
								if(!hadPdfStore.isDirty()) {
									pdfWin.applyData();
								} else {
									if(confirm('저장할 데이타가 있습니다. 저장 하시겠습니까?')) {
										hadPdfStore.saveStore({
											success:function() {
												pdfWin.loadSummary();
												pdfWin.applyData();
											}
										});
									}
								}
							}
						}]
					},{
						itemId	: 'summary',
						xtype	: 'uniSearchForm',
						style	: {'background':'#fff'},
						height	: 140,
						layout	: {type:'uniTable', columns:8, tableAttrs:{cellspacing:5}},
						margine	: '3 3 3 3',
						api:{
							load:'had620ukrService.selectPDFSummary'
						},
						items:[{
							xtype	: 'component',
							colspan	: 8,
							html	: "<hr></hr>"
						},{
							xtype	: 'component',
							html	: '보험',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '의료비',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '실손의료보험금',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '교육비',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '신용카드',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '직불카드',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '제로페이',
							tdAttrs : {align:'center'}
						},{
							xtype	: 'component',
							html	: '현금영수증',
							tdAttrs	: {align:'center'}
						},{
							fieldLabel	: '보험',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'A102Y_AMT',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter('A102Y');
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('A102Y');
									});
								}
							}
						},{
							fieldLabel	: '의료비',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'B101Y_AMT',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter('B101Y');
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('B101Y');
									});
								}
							}
						},{
							fieldLabel	: '실손의료보험금',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'B201Y_AMT',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter('B201Y');
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('B201Y');
									});
								}
							}
						},{
							fieldLabel	: '교육비',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'EDU_AMT_SUM',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter(['C102Y','C202Y','C301Y','C401Y']);
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('C102Y');
									});
								}
							}
						},{
							fieldLabel	: '신용카드',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'G108Y_AMT',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter('G108Y');
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('G108Y');
									});
								}
							}
						},{
							fieldLabel	: '직불카드',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'G308Y_AMT',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter('G308Y');
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('G308Y');
									});
								}
							}
						},{
							fieldLabel	: '제로페이(직불카드)',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'G408Y_AMT',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter('G408Y');
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('G408Y');
									});
								}
							}
						},{
							fieldLabel	: '현금영수증',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'G208Y_AMT',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter('G208Y');
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('G208Y');
									});
								}
							}
						},{
							xtype	: 'component',
							html	: '개인연금저축/연금계좌',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '주택자금',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '월세액',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '주택마련저축',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '장기집합투자증권저축',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '벤처기업투자신탁',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '소기업/소상공인 공제부금',
							tdAttrs	: {align:'center'}
						},{
							xtype	: 'component',
							html	: '기부금',
							tdAttrs	: {align:'center'}
						},{
							fieldLabel	: '개인연금저축/연금계좌',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'PENSION_AMT_SUM',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter(['D101Y','E102Y','F102Y']);
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('D101Y');
									});
								}
							}
						},{
							fieldLabel	: '주택자금',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'HOUSING_FUNDS_SUM',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter(['J203Y','J101Y','J401Y']);
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('J203Y');
									});
								}
							}
						},{
							fieldLabel	: '월세',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'J501Y_AMT',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter(['J501Y']);
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('J501Y');
									});
								}
							}
						},{
							fieldLabel	: '주택마련저축',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'J301Y_AMT',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter('J301Y');
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('J301Y');
									});
								}
							}
						},{
							fieldLabel	: '장기집합투자증원저축',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'N101Y_AMT',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter('N101Y');
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('N101Y');
									});
								}
							}
						},{
							fieldLabel	: '벤처기업투자신탁',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'VENTURE_FUNDS_SUM',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c) {
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter(['Q101Y','Q201Y']);
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('Q101Y');
									});
								}
							}
						},{
							fieldLabel	: '소기업/소상공인 공제부금',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'K101M_AMT',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c)	{
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter('K101M');
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('K101M');
									});
								}
							}
						},{
							fieldLabel	: '기부금',
							hideLabel	: true,
							xtype		: 'uniNumberfield',
							name		: 'L102Y_AMT',
							readOnly	: true,
							width		: 140,
							listeners:{
								render:function(c)	{
									c.getEl().on('click', function(component){
										hadPdfStore.refreshFilter('L102Y');
										var grid = pdfWin.down('#hadPdfGrid');
										grid.refreshColumn('L102Y');
									});
								}
							}
						}]
					},{
						xtype	: 'container',
						flex	: 1,
						layout	: {type:'vbox', align:'stretch'},
						items:[
							Unilite.createGrid('hadPdfGrid', {
								layout	: 'fit',
								store	: hadPdfStore,
								itemId	: 'hadPdfGrid',
								sortableColumns : true,
								uniOpt:{
									expandLastColumn: false,	//마지막 컬럼 * 사용 여부
									useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
									useLiveSearch: false,		//찾기 버튼 사용 여부
									filter: {					//필터 사용 여부
										useFilter: false,
										autoCreate: false
									},
									state: {
										useState: false,			//그리드 설정 버튼 사용 여부
										useStateList: false		//그리드 설정 목록 사용 여부
									},
									excel: {
										useExcel: false,			//엑셀 다운로드 사용 여부
										exportGroup : false, 		//group 상태로 export 여부
										onlyData:false,
										summaryExport:false
									}
								},
								features: [{id : 'gridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
										   {id : 'gridTotal',	 ftype: 'uniSummary',		  showSummaryRow: true }],
								columns:[
									{dataIndex: 'TARGET_YN'			, xtype:'checkcolumn'	, width:40},
									//{dataIndex: 'GUBUN_CODE'		, width: 200},
									{dataIndex: 'GUBUN_NAME'		, width: 200,
										summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
											return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
										}
									},
									{dataIndex: 'D_NAME'			, width: 80},
									{dataIndex: 'D_REPRE_NUM'		, width: 130},
									{dataIndex: 'DATA_NAME'			, width: 120},
									{dataIndex: 'CARD_TYPE_NAME'	, width: 120	, hidden: true},
									{dataIndex: 'LSOR_NM'			, width: 120	, hidden: true},
									{dataIndex: 'ADR'				, width: 300	, hidden: true},
									{dataIndex: 'USE_AMT'			, width: 120					, summaryType: 'sum'},
									{dataIndex: 'USE_AMT1'			, width: 120	, hidden: true	, summaryType: 'sum'},
									{dataIndex: 'USE_AMT2'			, width: 120	, hidden: true	, summaryType: 'sum'},
									{dataIndex: 'USE_AMT3'			, width: 120	, hidden: true	, summaryType: 'sum'},
									{dataIndex: 'SBDY_APLN_SUM'		, width: 120	, hidden: true	, summaryType: 'sum'},
									{dataIndex: 'CONB_SUM'			, width: 120	, hidden: true	, summaryType: 'sum'}
								],
								listeners:{
									beforeedit:function(editor, context, eOpts) {
										if(gbCloseYn) {
											return false;
										}
										if (UniUtils.indexOf(context.field,['GUBUN_NAME', 'D_NAME', 'D_REPRE_NUM', 'DATA_NAME', 'CARD_TYPE_NAME', 'LSOR_NM', 'ADR', 'CONB_SUM'])) {
											return false;
										}
										if (context.record.data.GUBUN_CODE.substring(0, 1) == 'G' && UniUtils.indexOf(context.field,['USE_AMT'])) {
											return false;
										}
									},
									edit:function(editor, context, eOpts) {
										if (context.record.data.GUBUN_CODE.substring(0, 1) == 'G' && UniUtils.indexOf(context.field,['USE_AMT1', 'USE_AMT2', 'USE_AMT3'])) {
											context.record.set('USE_AMT', context.record.get('USE_AMT1') + context.record.get('USE_AMT2') + context.record.get('USE_AMT3'));
										}
										if (context.record.data.GUBUN_CODE == 'L102Y' && UniUtils.indexOf(context.field,['USE_AMT', 'SBDY_APLN_SUM'])) {
											context.record.set('CONB_SUM', context.record.get('USE_AMT') + context.record.get('SBDY_APLN_SUM'));
										}
									}
								},
								refreshColumn: function(gubunCode) {
									var grid = pdfWin.down('#hadPdfGrid');
									
									grid.getColumn('DATA_NAME').hide();
									grid.getColumn('CARD_TYPE_NAME').hide();
									grid.getColumn('LSOR_NM').hide();
									grid.getColumn('ADR').hide();
									grid.getColumn('SBDY_APLN_SUM').hide();
									grid.getColumn('CONB_SUM').hide();
									grid.getColumn('USE_AMT1').hide();
									grid.getColumn('USE_AMT2').hide();
									grid.getColumn('USE_AMT3').hide();
									
									switch (gubunCode) {
										case 'A102Y':
										case 'B101Y':
										case 'C102Y':
										case 'C202Y':
										case 'C301Y':
										case 'C401Y':
											grid.getColumn('DATA_NAME').show();
											break;
										
										case 'G108Y':
										case 'G208Y':
										case 'G308Y':
										case 'G408Y':
											grid.getColumn('CARD_TYPE_NAME').show();
											grid.getColumn('USE_AMT1').show();
											grid.getColumn('USE_AMT2').show();
											grid.getColumn('USE_AMT3').show();
											break;
										
										case 'J501Y':
											grid.getColumn('LSOR_NM').show();
											grid.getColumn('ADR').show();
											break;
										
										case 'L102Y':
											grid.getColumn('CARD_TYPE_NAME').show();
											grid.getColumn('SBDY_APLN_SUM').show();
											grid.getColumn('CONB_SUM').show();
											break;
									}
								}
							})
						]
					}],
					bbar:{
						layout: {
							pack: 'center',
							type: 'hbox'
						},
						dock  :'bottom',
						items :  [{
							itemId	: 'saveBtn',
							text	: '저장',
							width	: 100,
							itemId	: 'btnPdfPopSaveAll',
							handler	: function() {
								hadPdfStore.saveStore();
							},
							disabled: false
						},{
							itemId	: 'closeBtn',
							text	: '닫기',
							width	: 100,
							handler	: function() {
								if(hadPdfStore.isDirty()) {
									if(confirm('저장할 데이타가 있습니다. 저장 하시겠습니까?')) {
										hadPdfStore.saveStore({
											success:function() {
												pdfWin.unmask();
												pdfWin.hide();
											}
										});
									} else {
										pdfWin.hide();
									}
								} else {
									pdfWin.hide();
								}
							},
							disabled: false
						}]
					},
					listeners : {
						beforehide: function(me, eOpt) {
							pdfWin.paramData = null;
							var searchForm	 = pdfWin.down('#search');
							var summaryForm	 = pdfWin.down('#summary');
							var pdfGrid		 = pdfWin.down('#hadPdfGrid');
							
							searchForm.reset();
							summaryForm.reset();
							hadPdfStore.loadData({});
							
							var empNo = panelResult.getValue('PERSON_NUMB');
							
							direct600Store.loadStoreRecords(empNo);
							direct400Store.loadStoreRecords(empNo);
						},
						beforeclose: function( panel, eOpts ) {
							pdfWin.paramData = null;
							var searchForm	 = pdfWin.down('#search');
							var summaryForm	 = pdfWin.down('#summary');
							var pdfGrid		 = pdfWin.down('#hadPdfGrid');
							
							searchForm.reset();
							summaryForm.reset();
							pdfGrid.reset();
						},
						beforeshow: function( panel, eOpts )	{
							var searchForm = pdfWin.down('#search');
							searchForm.setValue("YEAR_YYYY"		, pdfWin.paramData.YEAR_YYYY);
							searchForm.setValue("NAME"			, pdfWin.paramData.NAME);
							searchForm.setValue("PERSON_NUMB"	, pdfWin.paramData.PERSON_NUMB);
							searchForm.setValue("DEPT_NAME"		, pdfWin.paramData.DEPT_NAME);
							searchForm.setValue("POST_CODE_NAME", pdfWin.paramData.POST_CODE_NAME);
							
							pdfWin.setCloseForm();
						}
					},
					setCloseForm : function() {
						pdfWin.down('#btnPdfPopFile').setDisabled(gbCloseYn);
						pdfWin.down('#btnPdfPopUpload').setDisabled(gbCloseYn);
						pdfWin.down('#btnPdfPopApply').setDisabled(gbCloseYn);
						
						pdfWin.down('#btnPdfPopSaveAll').setDisabled(gbCloseYn);
					},
					loadSummary:function(key, value) {
						var searchForm = pdfWin.down('#search');
						if(!searchForm.isValid()) {
							return;
						}
						pdfWin.paramData = searchForm.getValues();
						if(key && value) {
							pdfWin.paramData[key] = value;
						}
						var summaryForm = pdfWin.down('#summary');
						if(pdfWin.paramData.PERSON_NUMB) {
							summaryForm.load({
								params:pdfWin.paramData,
								success:function(form, action){
									hadPdfStore.loadStoreRecords('A102Y');
								},
								failure:function(form, action){
									
								}
							});
						}
					},
					applyData:function() {
						pdfWin.mask();
						had620ukrService.spYearTaxPdf(pdfWin.paramData, function(responseText, response){
							console.log("responseText : ", responseText);
							console.log("response : ", response);
							
							Unilite.messageBox("PDF자료가 반영되었습니다.");
							
							pdfWin.unmask();
							pdfWin.mask();
							had620ukrService.batchSummaryData(pdfWin.batchParamData, function(){
								pdfWin.unmask();
								direct600Store.loadStoreRecords(pdfWin.paramData.PERSON_NUMB);
								direct400Store.loadStoreRecords(pdfWin.paramData.PERSON_NUMB);
							});
						});
					}
				});
			}
			
			pdfWin.paramData = paramData;
			pdfWin.batchParamData = paramData;
			pdfWin.center();
			pdfWin.show();
			pdfWin.loadSummary();
		}
	});
};
</script>
