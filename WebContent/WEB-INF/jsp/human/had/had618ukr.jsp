<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had618ukr"  >
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
    <t:ExtComboStore comboType="AU" comboCode="H139" />
    <t:ExtComboStore comboType="AU" comboCode="H115" />
    <t:ExtComboStore comboType="AU" comboCode="H116" />
    <t:ExtComboStore comboType="AU" comboCode="H121" />
    <t:ExtComboStore comboType="AU" comboCode="H140" />
    <t:ExtComboStore comboType="AU" comboCode="H180" />
</t:appConfig>
<style type="text/css">
.x-grid-item-focused  .x-grid-cell-inner:before {
    /*border: 0px;*/
}
</style>
<script type="text/javascript" >
var yearIncomeWin;
var prevCompanyWin;
var taxCommunityWin;
var familyWin;
var personalPensionWin;
var medDocWin ;
var pdfWin;
var rentWin    ;
var donationWin;
var houseLoanWin;

function appMain() {

    var YEAR_YYYY = '${YEAR_YYYY}';
    var USE_AUTH = '${USE_AUTH}';
    var AUTH_YN = '${AUTH_YN}';
    var PERSON_NUMB = '${PERSON_NUMB}';
    var PERSON_NAME = '${PERSON_NAME}';

    Unilite.defineModel('had618ukr600Model', {
        fields: [
               {name:'PERSON_NUMB'               	, text:'사번'  						, type:'string'}
             , {name:'JOIN_DATE'                    , text:'입사일'						, type:'uniDate'}
             , {name:'RETR_DATE'                    , text:'퇴사일'                       , type:'uniDate'}
             , {name:'DEPT_CODE'                    , text:'부서코드'						, type:'string'}
             , {name:'DEPT_NAME'                    , text:'부서명'                       , type:'string'}
             , {name:'YEAR_YYYY'                    , text:'정산년도'                      , type:'string'}
             , {name:'HALFWAY_TYPE'                 , text:'중도퇴사자정산여부'               , type:'bool'}
             , {name:'FORE_SINGLE_YN'               , text:'외국인단일세율적용여부'            , type:'bool'}
             , {name:'FOREIGN_DISPATCH_YN'          , text:'외국법인소속 파견근로자 여부'        , type:'bool'}
             , {name:'HOUSEHOLDER_YN'               , text:'세대주여부'                    , type:'bool'}
             , {name:'INCOME_SUPP_TOTAL_I'          , text:'총급여액'                      , type:'string'}
             , {name:'PAY_TOTAL_I'                  , text:'급여총액(숨김)'                 , type:'uniNumber'    ,defaultValue:0}
             , {name:'BONUS_TOTAL_I'                , text:'상여총액(숨김)'                 , type:'uniNumber'    ,defaultValue:0}
             , {name:'ADD_BONUS_I'                  , text:'인정상여금액(숨김)'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'STOCK_PROFIT_I'               , text:'주식매수선택행사이익(숨김)'         , type:'uniNumber'    ,defaultValue:0}
             , {name:'OWNER_STOCK_DRAW_I'          	, text:'우리사주조합인출금(숨김)'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'OF_RETR_OVER_I'               , text:'임원퇴직한도초과액(숨김)'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'NOW_PAY_TOT_I'                , text:'주(현)급여총액(숨김)'            , type:'uniNumber'}
             , {name:'NOW_BONUS_TOTAL_I'          	, text:'주(현)상여총액(숨김)'            , type:'uniNumber'    ,defaultValue:0}
             , {name:'NOW_ADD_BONUS_I'              , text:'주(현)인정상여금액(숨김)'         , type:'uniNumber'    ,defaultValue:0}
             , {name:'NOW_STOCK_PROFIT_I'          	, text:'주(현)주식매수선택행사이익(숨김)'    , type:'uniNumber'    ,defaultValue:0}
             , {name:'NOW_OWNER_STOCK_DRAW_I'      	, text:'주(현)우리사주조합인출금(숨김)'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'NOW_OF_RETR_OVER_I'          	, text:'주(현)임원퇴직한도초과액(숨김)'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'OLD_PAY_TOT_I'                , text:'종(전)급여총액(숨김)'             , type:'uniNumber'    ,defaultValue:0}
             , {name:'OLD_BONUS_TOTAL_I'          	, text:'종(전)상여총액(숨김)'             , type:'uniNumber'    ,defaultValue:0}
             , {name:'OLD_ADD_BONUS_I'              , text:'종(전)인정상여금액(숨김)'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'OLD_STOCK_PROFIT_I'          	, text:'종(전)주식매수선택행사이익(숨김)'    , type:'uniNumber'    ,defaultValue:0}
             , {name:'OLD_OWNER_STOCK_DRAW_I'      	, text:'종(전)우리사주조합인출금(숨김)'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'OLD_OF_RETR_OVER_I'          	, text:'종(전)임원퇴직한도초과액(숨김)'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'NAP_PAY_TOT_I'                , text:'(납)급여총액'                   , type:'uniNumber'    ,defaultValue:0}
             , {name:'NAP_BONUS_TOTAL_I'          	, text:'(납)상여총액'                   , type:'uniNumber'    ,defaultValue:0}
             , {name:'INCOME_DED_I'                 , text:'근로소득공제'                    , type:'uniNumber'    ,defaultValue:0}
             , {name:'EARN_INCOME_I'                , text:'근로소득금액'                    , type:'uniNumber'    ,defaultValue:0}
             , {name:'PER_DED_I'                    , text:'본인공제'                       , type:'uniNumber'    ,defaultValue:0}
             , {name:'SPOUSE'                       , text:'배우자유무'                      , type:'string'}
             , {name:'SPOUSE_DED_I'                 , text:'배우자공제'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'SUPP_NUM'                     , text:'부양자'                         , type:'uniNumber'    ,defaultValue:0}
             , {name:'SUPP_SUB_I'                   , text:'부양자공제'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'AGED_NUM'                     , text:'경로자'                         , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEFORM_NUM'                   , text:'장애자'                         , type:'uniNumber'    ,defaultValue:0}
             , {name:'MANY_CHILD_NUM'               , text:'자녀'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'BRING_CHILD_NUM'              , text:'자녀양육'                       , type:'uniNumber'    ,defaultValue:0}
             , {name:'BIRTH_ADOPT_NUM'              , text:'출산입양'                       , type:'uniNumber'    ,defaultValue:0}
             , {name:'WOMAN'                        , text:'부녀자유무'                      , type:'string'}
             , {name:'ONE_PARENT'                   , text:'한부모여부'                      , type:'string'}
             , {name:'BIRTH_ADOPT_NUM1'           	, text:'출산입양첫째'                     , type:'uniNumber'}
             , {name:'BIRTH_ADOPT_NUM2'           	, text:'출산입양둘째'                     , type:'uniNumber'}
             , {name:'BIRTH_ADOPT_NUM3'           	, text:'출산입양셋째'                     , type:'uniNumber'}
             , {name:'AGED_DED_I'                   , text:'경로공제'                        , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEFORM_DED_I'                 , text:'장애인공제'                       , type:'uniNumber'    ,defaultValue:0}
             , {name:'WOMAN_DED_I'                  , text:'부녀자공제'                       , type:'uniNumber'    ,defaultValue:0}
             , {name:'ONE_PARENT_DED_I'             , text:'한부모공제'                       , type:'uniNumber'    ,defaultValue:0}
             , {name:'ANU_I'                        , text:'국민연금'                        , type:'uniNumber'    ,defaultValue:0}
             , {name:'ANU_ADD_I'                    , text:'국민연금(개별입력)'                 , type:'uniNumber'    ,defaultValue:0}
             , {name:'ANU_DED_I'                    , text:'국민연금공제금액'                   , type:'uniNumber'    ,defaultValue:0}
             , {name:'PUBLIC_PENS_I'                , text:'공무원연금'                       , type:'uniNumber'    ,defaultValue:0}
             , {name:'SOLDIER_PENS_I'               , text:'군인연금'                        , type:'uniNumber'    ,defaultValue:0}
             , {name:'SCH_PENS_I'                   , text:'사립학교교직원연금'                 , type:'uniNumber'    ,defaultValue:0}
             , {name:'POST_PENS_I'                  , text:'별정우체국연금'                    , type:'uniNumber'    ,defaultValue:0}
             , {name:'MED_PREMINM_I'                , text:'건강보험료'                       , type:'uniNumber'    ,defaultValue:0}
             , {name:'HIRE_INSUR_I'                 , text:'고용보험료'                       , type:'uniNumber'    ,defaultValue:0}
             , {name:'HOUS_AMOUNT_I'                , text:'주택자금불입액(대출기관)'             , type:'uniNumber'    ,defaultValue:0}
             , {name:'HOUS_AMOUNT_I_2'              , text:'주택자금불입액(거주자)'               , type:'uniNumber'    ,defaultValue:0}
             , {name:'MORTGAGE_RETURN_I_2'          , text:'장기주택저당차입금이자상환액(15년미만)'   , type:'uniNumber'    ,defaultValue:0}
             , {name:'MORTGAGE_RETURN_I'          	, text:'장기주택저당차입금이자상환액(15년~29년)'  , type:'uniNumber'    ,defaultValue:0}
             , {name:'MORTGAGE_RETURN_I_3'          , text:'장기주택저당차입금이자상환액(30년이상)'    , type:'uniNumber'    ,defaultValue:0}
             , {name:'MORTGAGE_RETURN_I_5'          , text:'고정금리비거치상환대출(1500만원한도)'    , type:'uniNumber'    ,defaultValue:0}
             , {name:'MORTGAGE_RETURN_I_4'          , text:'기타대출(500만원한도)'               , type:'uniNumber'    ,defaultValue:0}
             , {name:'MORTGAGE_RETURN_I_6'          , text:'15년이상(고정금리이면서 비거치상환)'		, type:'uniNumber'    ,defaultValue:0}
             , {name:'MORTGAGE_RETURN_I_7'          , text:'15년이상(고정금리이거나 비거치상환)'		, type:'uniNumber'    ,defaultValue:0}
             , {name:'MORTGAGE_RETURN_I_8'          , text:'15년이상(그밖의대출)'                , type:'uniNumber'    ,defaultValue:0}
             , {name:'MORTGAGE_RETURN_I_9'          , text:'10년이상(고정금리이거나 비거치상환)'		, type:'uniNumber'    ,defaultValue:0}

             , {name:'PRIV_PENS_I'                  , text:'개인연금저축소득공제'                 , type:'uniNumber'    ,defaultValue:0}
             , {name:'HOUS_BU_AMT'                  , text:'청약저축(240만원한도)'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'HOUS_BU_ADD_AMT'              , text:'청약저축(120만원한도)'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'HOUS_WORK_AMT'                , text:'근로자주택마련저축'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'HOUS_BU_AMOUNT_I'             , text:'주택청약종합저축(240만원한도)'      	, type:'uniNumber'    ,defaultValue:0}
             , {name:'HOUS_BU_AMOUNT_ADD_I'         , text:'주택청약종합저축(120만원한도)'      	, type:'uniNumber'    ,defaultValue:0}
             , {name:'CARD_DED_I'                   , text:'신용카드공제'                       , type:'uniNumber'    ,defaultValue:0}
             , {name:'CARD_USE_I'                   , text:'신용카드사용액'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'CASH_USE_I'                   , text:'현금영수증사용액'                     , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEBIT_CARD_USE_I'             , text:'직불카드사용액'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'TRA_MARKET_USE_I'             , text:'전통시장사용액'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'TRAFFIC_USE_I'                , text:'대중교통이용액'                      , type:'uniNumber'    ,defaultValue:0}

             , {name:'BOOK_CONCERT_USE_I'           , text:'도서공연사용액'                      , type:'uniNumber'    ,defaultValue:0}

             , {name:'COMP_PREMINUM'                , text:'소기업,소상공인공제부금소득공제 2016년 가입한 대표자 여부' 	, type:'bool'}
             , {name:'COMP_PREMINUM_DED_I'          , text:'소기업,소상공인공제부금소득공제'      				, type:'uniNumber'    ,defaultValue:0}
             , {name:'INVESTMENT_DED_I'             , text:'투자조합출자공제'                    , type:'uniNumber'    ,defaultValue:0}
             , {name:'INVESTMENT_DED_I2'          	, text:'투자조합출자공제(2013년도분)'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'INVESTMENT_DED_I3'          	, text:'투자조합출자공제(2014년도분)'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'INVESTMENT_DED_I4'          	, text:'투자조합출자공제(2015년이후분)'        , type:'uniNumber'    ,defaultValue:0}
             , {name:'STAFF_STOCK_DED_I'          	, text:'우리사주조합출연금액'                 , type:'uniNumber'    ,defaultValue:0}
             , {name:'EMPLOY_WORKER_DED_I'          , text:'고용유지중소기업근로자소득공제'      	, type:'uniNumber'    ,defaultValue:0}
             , {name:'NOT_AMOUNT_LOAN_DED_I'      	, text:'목돈안드는전세이자상환액'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'LONG_INVEST_STOCK_DED_I'      , text:'장기집합투자증권저축'                 , type:'uniNumber'    ,defaultValue:0}
             , {name:'INCOME_REDU_I'                , text:'소득세법'                              , type:'uniNumber'    ,defaultValue:0}
             , {name:'YOUTH_EXEMP_RATE'                    , text:'중소기업청년소득세감면율'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'YOUTH_DED_I'                    , text:'중소기업청년소득세감면금액(100%)'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'YOUTH_DED_I3'                    , text:'중소기업청년소득세감면금액(70%)'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'YOUTH_DED_I2'                    , text:'중소기업청년소득세감면금액(50%)'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'YOUTH_DED_I_SUM'                , text:'중소기업청년 감면기간내 총소득금액(감면소득)'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'SKILL_DED_I'                    , text:'외국인기술공제'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAXES_REDU_I'                    , text:'조감법'                              , type:'uniNumber'    ,defaultValue:0}
             , {name:'IN_TAX_DED_I'                    , text:'근로소득세액공제'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'CHILD_TAX_DED_I'                , text:'자녀세액공제'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'BRING_CHILD_DED_I'          , text:'자녀양육비공제'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'BIRTH_ADOPT_I'                , text:'출산입양공제'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'SCI_DEDUC_I'                    , text:'(공제대상)과학기술인공제'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'RETIRE_PENS_I'                , text:'(공제대상)근로자퇴직급여보장법'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'PENS_I'                          , text:'(공제대상)연금저축소득공제'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'SCI_TAX_DED_I'                , text:'과학기술인공제      (급여5,500만원이상 12% 적용)'           , type:'uniNumber'    ,defaultValue:0}
             , {name:'SCI_TAX_DED_I1'                , text:'과학기술인공제      (급여5,500만원이하 15% 적용)'           , type:'uniNumber'    ,defaultValue:0}
             , {name:'RETIRE_TAX_DED_I'                , text:'근로자퇴직급여보장법(급여5,500만원이상 12% 적용)'           , type:'uniNumber'    ,defaultValue:0}
             , {name:'RETIRE_TAX_DED_I1'          , text:'근로자퇴직급여보장법(급여5,500만원이하 15% 적용)'           , type:'uniNumber'    ,defaultValue:0}
             , {name:'PENS_TAX_DED_I'                , text:'연금저축소득공제    (급여5,500만원이상 12% 적용)'           , type:'uniNumber'    ,defaultValue:0}
             , {name:'PENS_TAX_DED_I1'                , text:'연금저축소득공제    (급여5,500만원이하 15% 적용)'           , type:'uniNumber'    ,defaultValue:0}
             , {name:'ETC_INSUR_I'                    , text:'(공제대상)보장성보험'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEFORM_INSUR_I'                , text:'(공제대상)장애인전용보장성보험'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'ETC_INSUR_TAX_DED_I'          , text:'보장성보험'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEFORM_INSUR_TAX_DED_I'      , text:'장애인전용보장성보험'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'MED_DED_I'                    , text:'(공제대상)의료비공제금액'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'MY_MED_DED_I'                    , text:'(공제대상)본인의료비'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'SENIOR_MED_I'                    , text:'(공제대상)경로의료비'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEFORM_MED_I'                    , text:'(공제대상)장애의료비'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'SURGERY_MED_I'                , text:'(공제대상)난임시술비'                  , type:'uniNumber'    ,defaultValue:0}

             , {name:'SERIOUS_SICK_MED_I'           , text:'(공제대상)건강보험산정특례자의료비'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'SERIOUS_MED_TAX_DED_I'        , text:'건강보험산정특례자의료비'                 , type:'uniNumber'    ,defaultValue:0}

             , {name:'MED_TOTAL_I'                    , text:'(공제대상)그밖의 공제대상자 의료비' , type:'uniNumber'    ,defaultValue:0}
             , {name:'MED_TAX_DED_I'                , text:'의료비공제금액'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'MY_MED_TAX_DED_I'                , text:'본인의료비'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'SENIOR_MED_TAX_DED_I'          , text:'경로의료비'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEFORM_MED_TAX_DED_I'          , text:'장애의료비'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'SURGERY_MED_TAX_DED_I'      , text:'난임시술비'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'MED_TOTAL_TAX_DED_I'          , text:'그밖의 공제대상자 의료비'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'EDUC_DED_I'                    , text:'(공제대상)교육비공제'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'UNIV_EDUC_NUM'                , text:'대학교자녀수'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'STUD_EDUC_NUM'                , text:'초중고자녀수'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'KIND_EDU_NUM'                    , text:'유치원자녀수'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'PER_EDUC_DED_I'                , text:'(공제대상)본인교육비공제'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'UNIV_EDUC_DED_I'                , text:'(공제대상)대학교교육비공제'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'STUD_EDUC_DED_I'                , text:'(공제대상)초중고교육비공제'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'KIND_EDUC_DED_I'                , text:'(공제대상)유치원교육비공제'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEFORM_EDUC_DED_I'          , text:'(공제대상)장애인특수교육비공제'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'FIELD_EDUC_DED_I'      		, text:'(공제대상)체험학습비공제'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'EDUC_TAX_DED_I'                , text:'교육비공제'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'PER_EDUC_TAX_DED_I'          , text:'본인교육비공제'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'UNIV_EDUC_TAX_DED_I'          , text:'대학교교육비공제'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'STUD_EDUC_TAX_DED_I'          , text:'초중고교육비공제'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'KIND_EDUC_TAX_DED_I'          , text:'유치원교육비공제'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEFORM_EDUC_TAX_DED_I'      , text:'장애인특수교육비공제'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'FIELD_EDUC_TAX_DED_I'      		, text:'체험학습비공제'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'POLICY_INDED'                    , text:'(입력금액)정치자금기부금(10만원미만)'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'POLICY_GIFT_I'                , text:'(입력금액)정치자금기부금(10만원초과)'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'LEGAL_GIFT_I_PREV'          , text:'(입력금액)법정기부금이월-2013'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'LEGAL_GIFT_I_PREV_14'          , text:'(입력금액)법정기부금이월-2014'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'LEGAL_GIFT_I'                    , text:'(입력금액)법정기부금'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'PRIV_GIFT_I_PREV'                , text:'(입력금액)특례기부금이월액'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'PRIV_GIFT_I'                    , text:'(입력금액)특례기부금'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'PUBLIC_GIFT_I_PREV'          , text:'(입력금액)공익법인신탁기부금이월액' , type:'uniNumber'    ,defaultValue:0}
             , {name:'PUBLIC_GIFT_I'                , text:'(입력금액)공익법인신탁기부금'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'STAFF_GIFT_I'                    , text:'(입력금액)우리사주기부금'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'APPOINT_GIFT_I_PREV'          , text:'(입력금액)지정기부금이월액-2013'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'APPOINT_GIFT_I_PREV_14'      , text:'(입력금액)지정기부금이월액-2014'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'APPOINT_GIFT_I'                , text:'(입력금액)지정기부금'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'ASS_GIFT_I_PREV'                , text:'(입력금액)종교단체기부금이월액-2013', type:'uniNumber'    ,defaultValue:0}
             , {name:'ASS_GIFT_I_PREV_14'          , text:'(입력금액)종교단체기부금이월액-2014', type:'uniNumber'    ,defaultValue:0}
             , {name:'ASS_GIFT_I'                    , text:'(입력금액)종교단체기부금'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'POLICY_INDED_DED_AMT'          , text:'(공제대상)정치자금기부금(10만원미만)'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'POLICY_GIFT_DED_AMT'          , text:'(공제대상)정치자금기부금(10만원초과)'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'LEGAL_DED_AMT'                , text:'(공제대상)법정기부금'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'STAFF_DED_AMT'                , text:'(공제대상)우리사주기부금'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'APPOINT_ASS_TAX_DED_AMT'      , text:'(공제대상)지정기부금'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'GIFT_DED_I'                    , text:'(소득공제)기부금소득공제합계'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'LEGAL_GIFT_DED_I'                , text:'(소득공제)법정기부금'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'PRIV_GIFT_DED_I'                , text:'(소득공제)특례기부금'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'PUBLIC_GIFT_DED_I'          , text:'(소득공제)공익법인신탁기부금'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'STAFF_GIFT_DED_I'                , text:'(소득공제)우리사주기부금'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'APPOINT_GIFT_DED_I'          , text:'(소득공제)지정기부금'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'ASS_GIFT_DED_I'                , text:'(소득공제)종교단체기부금'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'GIFT_TAX_DED_I'                , text:'(세액공제)기부금세액공제합계'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'POLICY_INDED_TAX_DED_I'      , text:'(세액공제)정치자금기부금(10만원미만)'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'POLICY_GIFT_TAX_DED_I'      , text:'(세액공제)정치자금기부금(10만원초과)'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'LEGAL_GIFT_TAX_DED_I'          , text:'(세액공제)법정기부금'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'STAFF_GIFT_TAX_DED_I'          , text:'(세액공제)우리사주기부금'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'APPOINT_GIFT_TAX_DED_I'      , text:'(세액공제)지정기부금'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'ASS_GIFT_TAX_DED_I'          , text:'(세액공제)종교단체기부금'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'NAP_TAX_DED_I'              , text:'납세조합세액공제'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'HOUS_INTER_I'                    , text:'주택자금상환액'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'OUTSIDE_INCOME_I'              , text:'외국납부세액'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'MON_RENT_I'                    , text:'월세액'                              , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB1_DED_AMT'                    , text:'(세액산출요약)기본공제'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB2_DED_AMT'                    , text:'(세액산출요약)추가공제'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB3_DED_AMT'                    , text:'(세액산출요약)연금보험료공제'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB4_DED_AMT'                    , text:'(세액산출요약)특별소득공제-보험료'  , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB5_DED_AMT'                    , text:'(세액산출요약)특별소득공제-주택자금', type:'uniNumber'    ,defaultValue:0}
             , {name:'DED_INCOME_I'                    , text:'차감근로소득'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'DED_INCOME_I1'                , text:'차감근로소득(표준세액공제계산용):특별소득공제포함'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'DED_INCOME_I2'                , text:'차감근로소득(표준세액공제계산용):특별소득공제제외'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB6_DED_AMT'                    , text:'(세액산출요약)그밖소득공제-연금저축', type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB7_DED_AMT'                    , text:'(세액산출요약)그밖소득공제-주택마련', type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB8_DED_AMT'                    , text:'(세액산출요약)그밖소득공제-신용카드', type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB9_DED_AMT'                    , text:'세액산출요약)그밖소득공제-기타'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'OVER_INCOME_DED_LMT'          , text:'특별공제 종합한도 초과액'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAX_STD_I'                    , text:'소득과세표준'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAX_STD_I1'                    , text:'소득과세표준(표준세액공제계산용):특별소득공제포함'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAX_STD_I2'                     , text:'소득과세표준(표준세액공제계산용):특별소득공제제외'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'COMP_TAX_I'                    , text:'산출세액'                              , type:'uniNumber'    ,defaultValue:0}
             , {name:'COMP_TAX_I1'                    , text:'산출세액(표준세액공제계산용):특별소득공제포함'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'COMP_TAX_I2'                    , text:'산출세액(표준세액공제계산용):특별소득공제제외'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB10_DED_AMT'              , text:'(세액산출요약)세액감면'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB11_DED_AMT'              , text:'(세액산출요약)세액공제-근로소득/자녀'                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB12_DED_AMT'              , text:'(세액산출요약)세액공제-연금계좌'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB13_DED_AMT'              , text:'(세액산출요약)특별세액공제-보험료'  , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB14_DED_AMT'              , text:'(세액산출요약)특별세액공제-의료비'  , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB15_DED_AMT'              , text:'(세액산출요약)특별세액공제-교육비'  , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB16_DED_AMT'              , text:'(세액산출요약)특별세액공제-기부금'  , type:'uniNumber'    ,defaultValue:0}
             , {name:'STD_TAX_DED_I'              , text:'표준세액공제'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAB17_DED_AMT'              , text:'(세액산출요약)세액공제-기타'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEF_IN_TAX_I'                    , text:'결정소득세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEF_LOCAL_TAX_I'              , text:'결정주민세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEF_SP_TAX_I'                    , text:'결정농특세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'DEF_TAX_SUM'                    , text:'(세액산출요약)결정세액합계'          , type:'uniNumber'    ,defaultValue:0}
             , {name:'NOW_IN_TAX_I'                    , text:'주(현)소득세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'NOW_LOCAL_TAX_I'              , text:'주(현)주민세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'NOW_SP_TAX_I'                    , text:'주(현)농특세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'NOW_TAX_SUM'                    , text:'(세액산출요약)현근무지기납부세액'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'PRE_IN_TAX_I'                    , text:'종(전)소득세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'PRE_LOCAL_TAX_I'                , text:'종(전)주민세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'PRE_SP_TAX_I'                    , text:'종(전)농특세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'PRE_TAX_SUM'                    , text:'(세액산출요약)종전근무지결정세액'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'NAP_IN_TAX_I'                    , text:'(납)소득세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'NAP_LOCAL_TAX_I'                , text:'(납)주민세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'NAP_SP_TAX_I'                    , text:'(납)농특세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'NAP_TAX_SUM'                    , text:'(세액산출요약)납세조합기납부세액'      , type:'uniNumber'    ,defaultValue:0}
             , {name:'PAID_IN_TAX_SUM'                , text:'(조회용)기납부소득세합계'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'PAID_LOCAL_TAX_SUM'          , text:'(조회용)기납부주민세합계'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'PAID_SP_TAX_SUM'                , text:'(조회용)기납부농특세합계'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'PAID_TAX_SUM'                    , text:'(조회용)기납부세액합계'              , type:'uniNumber'    ,defaultValue:0}
             , {name:'IN_TAX_I'                          , text:'정산소득세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'LOCAL_TAX_I'                    , text:'정산주민세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'SP_TAX_I'                          , text:'정산농특세'                          , type:'uniNumber'    ,defaultValue:0}
             , {name:'TAX_SUM'                          , text:'(조회용)정산세액합계'                  , type:'uniNumber'    ,defaultValue:0}
             , {name:'IN_TAX_DED_I'                    , text:''                                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'CHILD_TAX_DED_I'                , text:''                                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'BRING_CHILD_DED_I'          , text:''                                      , type:'uniNumber'    ,defaultValue:0}
             , {name:'BIRTH_ADOPT_I'                , text:''                                      , type:'uniNumber'    ,defaultValue:0}
            ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */

    var direct600Store = Unilite.createStore('had618ukr600Store',{
            model: 'had618ukr600Model',
            autoLoad: false,
            folderSort: true,
            uniOpt : {
                isMaster: true,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false            // prev | newxt 버튼 사용
            },

            proxy: /*directProxy*/{
                type: 'uniDirect',
                api: {
                    read : 'had618ukrService.selectFormHad600'
                    ,update : 'had618ukrService.update600'
                    ,create : 'had618ukrService.insert600'
                    ,destroy: 'had618ukrService.deleteAll'
                    ,syncAll: 'had618ukrService.save600All'

                }
            },
            listeners:{
                load: function ( store, records, successful, operation, eOpts )    {
                    if(records && records.length > 0)    {
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
                update:function( store, record, operation, modifiedFieldNames, details, eOpts )    {
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
            ,loadStoreRecords : function()    {
                var param= Ext.getCmp('searchForm').getValues();
                console.log( param );
                this.load({
                    params : param
                });
            }
            // 수정/추가/삭제된 내용 DB에 적용 하기
            ,saveStore : function()    {
                var me = this;
	            var toCreate = me.getNewRecords();
	            var toUpdate = me.getUpdatedRecords();
	            var toDelete = me.getRemovedRecords();
	            var list = [].concat(toUpdate, toCreate);

	            if(list.length > 0)	{
	                var inValidRecs = this.getInvalidRecords();
	                console.log("inValidRecords : ", inValidRecs);

	                if(inValidRecs.length == 0 )    {

	                        var config = {
	                            //params:[panelSearch.getValues()],
	                            success : function()    {
	                                UniAppManager.app.onQueryButtonDown();
	                            }
	                          }
	                        this.syncAllDirect(config);
	                    //UniAppManager.setToolbarButtons('save', false);
	                }else {
	                    masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
	                }
	            } else {
	            	if(me.getData() && me.getData().items)	{
		            	var param = me.getData().items[0].data
	                	console.log("save600_3 : ", param);
	                	Ext.getBody().mask();
		            	had618ukrService.update600_3(param, function(responseText, response){
		            		Ext.getBody().unmask();
		            	})
	            	}
	            }
            }
        });

        Unilite.defineModel('had618ukr400Model', {
        fields: [
              {name:'PERSON_NUMB'                 ,text:'사번'                                ,type:'string'}
             ,{name:'NAME'                        ,text:'성명'                                ,type:'string'}
             ,{name:'DEPT_CODE'                   ,text:'부서코드'                             ,type:'string'}
             ,{name:'DEPT_NAME'                   ,text:'부서명'                               ,type:'string'}
             ,{name:'POST_CODE'                   ,text:'직위코드'                             ,type:'string'}
             ,{name:'POST_NAME'                   ,text:'직위'                                ,type:'string'}
             ,{name:'REPRE_NUM'                   ,text:'주민번호'                             ,type:'string'}
             ,{name:'FOREIGN_NUM'                 ,text:'외국인번호'                            ,type:'string'}
             ,{name:'NATION_CODE'                 ,text:'국적'                                ,type:'string'}
             ,{name:'LIVE_GUBUN'                  ,text:'거주구분'                             ,type:'string'}
             ,{name:'YEAR_YYYY'                   ,text:'정산년도'                             ,type:'string'}
             ,{name:'HALFWAY_TYPE'                ,text:'중도퇴사자정산여부'                      ,type:'bool'}
             ,{name:'FORE_SINGLE_YN'              ,text:'외국인단일세율적용여부'                    ,type:'bool'}
             ,{name:'FOREIGN_DISPATCH_YN'         ,text:'외국법인소속 파견근로자여부'                ,type:'bool'}
             ,{name:'HOUSEHOLDER_YN'              ,text:'세대주여부'                            ,type:'bool'}
             ,{name:'NONTAX_FR'                   ,text:'세액감면기간(Fr)'                       ,type:'uniDate'}
             ,{name:'NONTAX_TO'                   ,text:'세액감면기간(To)'                       ,type:'uniDate'}
             ,{name:'INCOME_SUPP_TOTAL_I'         ,text:'총급여액'                              ,type:'string'}
             ,{name:'NOW_PAY_AMT'                 ,text:'주(현)총급여액'                         ,type:'uniNumber'}
             ,{name:'NOW_PAY_TOT_I'               ,text:'주(현)급여총액(숨김)'                    ,type:'uniNumber'}
             ,{name:'NOW_BONUS_TOTAL_I'           ,text:'주(현)상여총액(숨김)'                    ,type:'uniNumber'}
             ,{name:'NOW_ADD_BONUS_I'             ,text:'주(현)인정상여금액(숨김)'                 ,type:'uniNumber'}
             ,{name:'NOW_STOCK_PROFIT_I'          ,text:'주(현)주식매수선택행사이익(숨김)'        	 ,type:'uniNumber'}
             ,{name:'NOW_OWNER_STOCK_DRAW_I'      ,text:'주(현)우리사주조합인출금(숨김)'            ,type:'uniNumber'}
             ,{name:'NOW_OF_RETR_OVER_I'          ,text:'주(현)임원퇴직한도초과액(숨김)'            ,type:'uniNumber'}
             ,{name:'OLD_PAY_AMT'                 ,text:'종(전)총급여액'                            ,type:'uniNumber'}
             ,{name:'OLD_PAY_TOT_I'               ,text:'종(전)급여총액'                            ,type:'uniNumber'}
             ,{name:'OLD_BONUS_TOTAL_I'           ,text:'종(전)상여총액'                            ,type:'uniNumber'}
             ,{name:'OLD_ADD_BONUS_I'             ,text:'종(전)인정상여금액'                        ,type:'uniNumber'}
             ,{name:'OLD_STOCK_PROFIT_I'        ,text:'종(전)주식매수선택행사이익'                ,type:'uniNumber'}
             ,{name:'OLD_OWNER_STOCK_DRAW_I'    ,text:'종(전)우리사주조합인출금'                ,type:'uniNumber'}
             ,{name:'OLD_OF_RETR_OVER_I'        ,text:'종(전)임원퇴직한도초과액'                ,type:'uniNumber'}
             ,{name:'NAP_PAY_AMT'                ,text:'(납)총급여액'                            ,type:'uniNumber'}
             ,{name:'NAP_PAY_TOT_I'                ,text:'(납)급여총액'                            ,type:'uniNumber'}
             ,{name:'NAP_BONUS_TOTAL_I'            ,text:'(납)상여총액'                            ,type:'uniNumber'}
             ,{name:'INCOME_DED_I'                ,text:'근로소득공제'                            ,type:'uniNumber'}
             ,{name:'EARN_INCOME_I'                ,text:'근로소득금액'                            ,type:'uniNumber'}
             ,{name:'PER_DED_I'                    ,text:'본인공제'                                ,type:'uniNumber'}
             ,{name:'SPOUSE'                    ,text:'배우자유무'                                ,type:'string'}
             ,{name:'SUPP_NUM'                    ,text:'부양자'                                    ,type:'uniNumber'}
             ,{name:'SUPP_NUM_1'                ,text:'부양자:직계존속'                            ,type:'uniNumber'}
             ,{name:'SUPP_NUM_4'                ,text:'부양자:직계비속-자녀입양자'                ,type:'uniNumber'}
             ,{name:'SUPP_NUM_5'                ,text:'부양자:직계비속-그외직계비속'            ,type:'uniNumber'}
             ,{name:'SUPP_NUM_6'                ,text:'부양자:형제자매'                            ,type:'uniNumber'}
             ,{name:'SUPP_NUM_7'                ,text:'부양자:수급자'                            ,type:'uniNumber'}
             ,{name:'SUPP_NUM_8'                ,text:'부양자:위탁아동'                            ,type:'uniNumber'}
             ,{name:'AGED_NUM'                    ,text:'경로자'                                    ,type:'uniNumber'}
             ,{name:'DEFORM_NUM'                ,text:'장애자'                                    ,type:'uniNumber'}
             ,{name:'MANY_CHILD_NUM'            ,text:'자녀'                                    ,type:'uniNumber'}
             ,{name:'BRING_CHILD_NUM'            ,text:'자녀양육'                                ,type:'uniNumber'}
             ,{name:'BIRTH_ADOPT_NUM'            ,text:'출산입양'                                ,type:'uniNumber'}
             ,{name:'WOMAN'                        ,text:'부녀자유무'                                ,type:'string'}
             ,{name:'ONE_PARENT'                ,text:'한부모유무'                                ,type:'string'}
             ,{name:'BIRTH_ADOPT_NUM1'           ,text:'출산입양첫째'                                ,type:'uniNumber'}
             ,{name:'BIRTH_ADOPT_NUM2'           ,text:'출산입양둘째'                                ,type:'uniNumber'}
             ,{name:'BIRTH_ADOPT_NUM3'           ,text:'출산입양셋째'                                ,type:'uniNumber'}
             ,{name:'ANU_I'                        ,text:'국민연금보험료'                            ,type:'uniNumber'}
             ,{name:'ANU_ADD_I'                    ,text:'국민연금보험료(개별입력)'                ,type:'uniNumber'}
             ,{name:'PUBLIC_PENS_I'                ,text:'공무원연금'                                ,type:'uniNumber'}
             ,{name:'SOLDIER_PENS_I'            ,text:'군인연금'                                ,type:'uniNumber'}
             ,{name:'SCH_PENS_I'                ,text:'사립학교교직원연금'                        ,type:'uniNumber'}
             ,{name:'POST_PENS_I'                ,text:'별정우체국연금'                            ,type:'uniNumber'}
             ,{name:'MED_PREMINM_I'                ,text:'건강보험료'                                ,type:'uniNumber'}
             ,{name:'MED_PREMINM_ADD_I'            ,text:'건강보험료(개별입력)'                    ,type:'uniNumber'}
             ,{name:'HIRE_INSUR_I'                ,text:'고용보험료'                                ,type:'uniNumber'}
             ,{name:'HIRE_INSUR_ADD_I'                ,text:'고용보험료(개별입력)'                      ,type:'uniNumber'}
             ,{name:'HOUS_AMOUNT_TOT_I'            ,text:'원리금상환액(대출기관)'                    ,type:'uniNumber'}
             ,{name:'HOUS_AMOUNT_TOT_I_2'        ,text:'원리금상환액(거주자)'                    ,type:'uniNumber'}
             ,{name:'HOUS_AMOUNT_INTER_I_2'        ,text:'주택자금이자상환액(15년미만)'            ,type:'uniNumber'}
             ,{name:'HOUS_AMOUNT_INTER_I'        ,text:'주택자금이자상환액(15년~29년)'            ,type:'uniNumber'}
             ,{name:'HOUS_AMOUNT_INTER_I_3'        ,text:'주택자금이자상환액(30년이상)'            ,type:'uniNumber'}
             ,{name:'FIXED_RATE_LOAN'            ,text:'고정금리비거치상환대출'                    ,type:'uniNumber'}
             ,{name:'ETC_LOAN'                    ,text:'기타대출'                                ,type:'uniNumber'}
             ,{name:'HOUS_AMOUNT_INTER_I_6'        ,text:'15년이상(고정금리이면서 비거치상환)'        ,type:'uniNumber'}
             ,{name:'HOUS_AMOUNT_INTER_I_7'        ,text:'15년이상(고정금리이거나 비거치상환)'        ,type:'uniNumber'}
             ,{name:'HOUS_AMOUNT_INTER_I_8'        ,text:'15년이상(그밖의대출)'                    ,type:'uniNumber'}
             ,{name:'HOUS_AMOUNT_INTER_I_9'        ,text:'10년이상(고정금리이거나 비거치상환)'        ,type:'uniNumber'}
             ,{name:'PRIV_PENS_I'                ,text:'개인연금저축소득공제'                    ,type:'uniNumber'}
             ,{name:'HOUS_BU_AMT'                ,text:'청약저축'                                ,type:'uniNumber'}
             ,{name:'HOUS_BU_ADD_AMT'            ,text:'청약저축(120만원한도)'                    ,type:'uniNumber'}
             ,{name:'HOUS_WORK_AMT'                ,text:'근로자주택마련저축'                        ,type:'uniNumber'}
             ,{name:'HOUS_AMOUNT_I'                ,text:'주택청약종합저축'                        ,type:'uniNumber'}
             ,{name:'HOUS_AMOUNT_ADD_I'            ,text:'주택청약종합저축(120만원한도)'            ,type:'uniNumber'}
             ,{name:'CARD_USE_I'                ,text:'신용카드사용액'                            ,type:'uniNumber'}
             ,{name:'CASH_USE_I'                ,text:'현금영수증사용액'                        ,type:'uniNumber'}
             ,{name:'DEBIT_CARD_USE_I'            ,text:'직불카드사용액'                            ,type:'uniNumber'}
             ,{name:'TRA_MARKET_USE_I'            ,text:'전통시장사용액'                            ,type:'uniNumber'}
             ,{name:'TRAFFIC_USE_I'                ,text:'대중교통이용액'                            ,type:'uniNumber'}

             , {name:'BOOK_CONCERT_USE_I'           , text:'도서공연사용액'                       , type:'uniNumber'}

             ,{name:'COMP_PREMINUM'                ,text:'소기업소상공인공제부금 2016년 가입한 법인대표자 여부',type:'bool'}
             ,{name:'COMP_PREMINUM_I'            ,text:'소기업소상공인공제부금2'                    ,type:'uniNumber'}
             ,{name:'INVESTMENT_I'                ,text:'투자조합출자(2012년이전 10%해당분)'        ,type:'uniNumber'}
             ,{name:'INVESTMENT_I3'                ,text:'투자조합출자(2012년 20%해당분)'            ,type:'uniNumber'}
             ,{name:'INVESTMENT_I4'                ,text:'투자조합출자(2013년 10%해당분)'            ,type:'uniNumber'}
             ,{name:'INVESTMENT_I2'                ,text:'투자조합출자(2013년 30%해당분)'            ,type:'uniNumber'}
             ,{name:'INVESTMENT_I5'                ,text:'투자조합출자(2014년 10%해당분)'            ,type:'uniNumber'}
             ,{name:'INVESTMENT_I6'                ,text:'투자조합출자(2014년 50%해당분)'            ,type:'uniNumber'}
             ,{name:'INVESTMENT_I7'                ,text:'투자조합출자(2014년 30%해당분)'            ,type:'uniNumber'}
             ,{name:'INVESTMENT_I8'                ,text:'투자조합출자(2015년 10%해당분)'            ,type:'uniNumber'}
             ,{name:'INVESTMENT_I9'                ,text:'투자조합출자(2015년100%해당분)'            ,type:'uniNumber'}
             ,{name:'INVESTMENT_I10'            ,text:'투자조합출자(2015년 50%해당분)'            ,type:'uniNumber'}
             ,{name:'INVESTMENT_I11'            ,text:'투자조합출자(2015년 30%해당분)'            ,type:'uniNumber'}
             ,{name:'STAFF_STOCK_I'                ,text:'우리사주조합출연'                        ,type:'uniNumber'}

             ,{name:'VENTURE_STOCK_I'              ,text:'우리사주조합출연(벤처기업)'                  ,type:'uniNumber'}

             ,{name:'EMPLOY_WORKER_I'            ,text:'고용유지중소기업근로자소득공제'            ,type:'uniNumber'}
             ,{name:'NOT_AMOUNT_LOAN_I'            ,text:'목돈안드는전세이자상환액(2016년 삭제)'    ,type:'uniNumber'}
             ,{name:'LONG_INVEST_STOCK_I'        ,text:'장기집합투자증권저축'                    ,type:'uniNumber'}
             ,{name:'INCOME_REDU_I'                ,text:'소득세법'                                ,type:'uniNumber'}
             ,{name:'TAXES_REDU_I'                ,text:'조세조약'                                ,type:'uniNumber'}
             ,{name:'SCI_DEDUC_I'                ,text:'과학기술인공제'                            ,type:'uniNumber'}
             ,{name:'RETIRE_PENS_I'                ,text:'근로자퇴직급여보장법'                    ,type:'uniNumber'}
             ,{name:'PENS_I'                    ,text:'연금저축소득공제'                        ,type:'uniNumber'}
             ,{name:'ETC_INSUR_I'                ,text:'보장성보험'                                ,type:'uniNumber'}
             ,{name:'DEFORM_INSUR_I'            ,text:'장애인전용보장성보험'                    ,type:'uniNumber'}
             ,{name:'MY_MED_DED_I'                ,text:'본인의료비'                                ,type:'uniNumber'}
             ,{name:'SENIOR_MED_I'                ,text:'경로의료비'                                ,type:'uniNumber'}
             ,{name:'DEFORM_MED_I'                ,text:'장애의료비'                                ,type:'uniNumber'}
             ,{name:'SURGERY_MED_I'                ,text:'난임시술비'                                ,type:'uniNumber'}

             ,{name:'SERIOUS_SICK_MED_I'           ,text:'건강보험산정특례자의료비'                        ,type:'uniNumber'}
             ,{name:'BASE_MED_I'                   ,text:'의료비기본공제'                              ,type:'uniNumber'}

             ,{name:'MED_TOTAL_I'                ,text:'그밖의 공제대상자 의료비'                ,type:'uniNumber'}
             ,{name:'PER_EDUC_I'                ,text:'본인교육비'                                ,type:'uniNumber'}
             ,{name:'UNIV_EDUC_NUM'                ,text:'대학교자녀수'                            ,type:'uniNumber'}
             ,{name:'UNIV_EDUC_I'                ,text:'대학교교육비'                            ,type:'uniNumber'}
             ,{name:'STUD_EDUC_NUM'                ,text:'초중고자녀수'                            ,type:'uniNumber'}
             ,{name:'STUD_EDUC_I'                ,text:'초중고교육비'                            ,type:'uniNumber'}
             ,{name:'KIND_EDU_NUM'                ,text:'유치원자녀수'                            ,type:'uniNumber'}
             ,{name:'KIND_EDUC_I'                ,text:'유치원교육비'                            ,type:'uniNumber'}
             ,{name:'DEFORM_EDUC_NUM'            ,text:'장애인수'                                ,type:'uniNumber'}
             ,{name:'DEFORM_EDUC_I'                ,text:'장애인특수교육비'                        ,type:'uniNumber'}
             ,{name:'FIELD_EDUC_I'                ,text:'체험학습비'                        ,type:'uniNumber'}
             ,{name:'PER_EDUC_DED_I'            ,text:'본인교육비공제'                            ,type:'uniNumber'}
             ,{name:'UNIV_EDUC_DED_I'            ,text:'대학교교육비공제'                        ,type:'uniNumber'}
             ,{name:'STUD_EDUC_DED_I'            ,text:'초중고교육비공제'                        ,type:'uniNumber'}
             ,{name:'KIND_EDUC_DED_I'            ,text:'유치원교육비공제'                        ,type:'uniNumber'}
             ,{name:'DEFORM_EDUC_DED_I'            ,text:'장애인특수교육비공제'                    ,type:'uniNumber'}
             ,{name:'FIELD_EDUC_DED_I'            ,text:'체헙학습비공제'                    ,type:'uniNumber'}
             ,{name:'POLICY_INDED'                ,text:'정치자금기부금공제'                        ,type:'uniNumber'}
             ,{name:'POLICY_GIFT_I'                ,text:'정치자금기부금'                            ,type:'uniNumber'}
             ,{name:'LEGAL_GIFT_I_PREV'            ,text:'법정기부금(전년도이월액)-2013'            ,type:'uniNumber'}
             ,{name:'LEGAL_GIFT_I_PREV_14'        ,text:'법정기부금(전년도이월액)-2014'            ,type:'uniNumber'}
             ,{name:'LEGAL_GIFT_I'                ,text:'법정기부금'                                ,type:'uniNumber'}
             ,{name:'PRIV_GIFT_I_PREV'            ,text:'특례기부금(전년도이월액)'                ,type:'uniNumber'}
             ,{name:'PRIV_GIFT_I'                ,text:'특례기부금'                                ,type:'uniNumber'}
             ,{name:'PUBLIC_GIFT_I_PREV'        ,text:'공익법인신탁기부금(전년도이월액)'        ,type:'uniNumber'}
             ,{name:'PUBLIC_GIFT_I'                ,text:'공익법인신탁기부금'                        ,type:'uniNumber'}
             ,{name:'STAFF_GIFT_I'                ,text:'우리사주기부금'                            ,type:'uniNumber'}
             ,{name:'APPOINT_GIFT_I_PREV'        ,text:'지정기부금(전년도이월액)-2013'            ,type:'uniNumber'}
             ,{name:'APPOINT_GIFT_I_PREV_14'    ,text:'지정기부금(전년도이월액)-2014'            ,type:'uniNumber'}
             ,{name:'APPOINT_GIFT_I'            ,text:'지정기부금'                                ,type:'uniNumber'}
             ,{name:'ASS_GIFT_I_PREV'            ,text:'종교단체기부금(전년도이월액)-2013'        ,type:'uniNumber'}
             ,{name:'ASS_GIFT_I_PREV_14'        ,text:'종교단체기부금(전년도이월액)-2014'        ,type:'uniNumber'}
             ,{name:'ASS_GIFT_I'                ,text:'종교단체기부금'                            ,type:'uniNumber'}
             ,{name:'P3_TAX_DED_I'                ,text:'납세조합세액'                            ,type:'uniNumber'}
             ,{name:'HOUS_INTER_I'                ,text:'주택자금상환액'                            ,type:'uniNumber'}
             ,{name:'FORE_INCOME_I'                ,text:'외국납부소득금액'                        ,type:'uniNumber'}
             ,{name:'FORE_TAX_I'                ,text:'외국납부세액'                            ,type:'uniNumber'}
             ,{name:'MON_RENT_I'                ,text:'월세액'                                    ,type:'uniNumber'}
             ,{name:'NEW_DATA_YN'                ,text:'개인연말정산기초자료 존재여부'            ,type:'uniNumber'}
        ]
        });
        var direct400Store = Unilite.createStore('had618ukr400Store',{
            model: 'had618ukr400Model',
            autoLoad: false,
            folderSort: true,
            uniOpt : {
                isMaster: true,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false            // prev | newxt 버튼 사용
            },
            proxy: /*directProxy*/{
                type: 'uniDirect',
                api: {
                    read : 'had618ukrService.selectFormHad400'
                    ,update : 'had618ukrService.update400'
                    ,create : 'had618ukrService.insert400'
                    ,syncAll: 'had618ukrService.save400All'

                }
            },
            listeners:{
                load: function ( store, records, successful, operation, eOpts )    {
                    if(records && records.length > 0)    {
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

                        //var record = records[0];
                        //form400_info.setValue("HALFWAY_TYPE"    ,records[0].data.HALFWAY_TYPE ==	"Y"? true:false);
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
                update:function( store, record, operation, modifiedFieldNames, details, eOpts )    {
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
                    //console.log("modifiedFieldNames :",modifiedFieldNames);
                        /*if(modifiedFieldNames[0] != "HALFWAY_TYPE"){
                        	form400_info.setActiveRecord(record);
                        }*/
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
            loadStoreRecords : function()    {
                var param= Ext.getCmp('searchForm').getValues();
                console.log( param );
                this.load({
                    params : param
                });
            }
            // 수정/추가/삭제된 내용 DB에 적용 하기
            ,saveStore : function()    {
                var me = this;
                var inValidRecs = this.getInvalidRecords();
                console.log("inValidRecords : ", inValidRecs);
                if(inValidRecs.length == 0 )    {

                        var config = {
                            //params:[panelSearch.getValues()],
                            success : function()    {
                                UniAppManager.app.onQueryButtonDown();
                            }
                          }
                        this.syncAllDirect(config);
                    //UniAppManager.setToolbarButtons('save', false);
                }else {
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
        width: 380,
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
                    fieldLabel: '정산년도',
                    fieldStyle: "text-align:center;",
                    name:'YEAR_YYYY',
                    xtype: 'uniYearField',
                    allowBlank:false,
                    value:YEAR_YYYY,
                    readOnly:true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.setValue('YEAR_YYYY', newValue);
                        }
                    }
                },
                    Unilite.popup('Employee',{
                    validateBlank: false,
                    allowBlank:false,
                    listeners: {
                        onSelected:function(records, type)    {
                            if(records)    {
                                var record = records[0];
                                panelSearch.setValue("PERSON_NUMB",record['PERSON_NUMB']);
                                panelSearch.setValue("NAME",record['NAME']);
                                panelSearch.setValue("DEPT_NAME",record['DEPT_NAME']);
                                panelSearch.setValue("POST_CODE_NAME",record['POST_CODE_NAME']);
                                panelSearch.setValue("REPRE_NUM",record['REPRE_NUM_EXPOS']);
                                panelSearch.setValue("FOREIGN_NUM",record['FOREIGN_NUM']);
                                panelSearch.setValue("NATION_CODE",record['NATION_CODE']);
                                panelSearch.setValue("LIVE_GUBUN",record['LIVE_GUBUN']);

                                panelResult.setValue("PERSON_NUMB",record['PERSON_NUMB']);
                                panelResult.setValue("NAME",record['NAME']);
                                panelResult.setValue("DEPT_NAME",record['DEPT_NAME']);
                                panelResult.setValue("POST_CODE_NAME",record['POST_CODE_NAME']);
                                panelResult.setValue("REPRE_NUM",record['REPRE_NUM_EXPOS']);
                                panelResult.setValue("FOREIGN_NUM",record['FOREIGN_NUM']);
                                panelResult.setValue("NATION_CODE",record['NATION_CODE']);
                                panelResult.setValue("LIVE_GUBUN",record['LIVE_GUBUN']);

                                panelSearch.getField('PERSON_NUMB').setReadOnly(true);
								panelSearch.getField('NAME').setReadOnly(true);
								panelResult.getField('PERSON_NUMB').setReadOnly(true);
								panelResult.getField('NAME').setReadOnly(true);
								UniAppManager.app.onQueryButtonDown();
                            }
                        },
                        onValueFieldChange: function(field, newValue){
                            panelResult.setValue('PERSON_NUMB', newValue);
                        },
                        onTextFieldChange: function(field, newValue){
                            panelResult.setValue('NAME', newValue);
                        }
                    }
                }),
                {fieldLabel: '', name:'DEPT_NAME', hidden:true},
                {fieldLabel: '', name:'POST_CODE_NAME', hidden:true},
                {fieldLabel: '', name:'REPRE_NUM', hidden:true},
                {fieldLabel: '', name:'FOREIGN_NUM', hidden:true},
                {fieldLabel: '', name:'NATION_CODE', hidden:true},
                {fieldLabel: '', name:'LIVE_GUBUN', hidden:true}
                ]
            }]
    });

     var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 5, tableAttrs: {width: '100%'}},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '정산년도',
            fieldStyle: "text-align:center;",
            name:'YEAR_YYYY',
            xtype: 'uniYearField',
            allowBlank:false,
            value:YEAR_YYYY,
            readOnly:true,
            tdAttrs: {width: 300},
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('YEAR_YYYY', newValue);
                }
            }
        },
            Unilite.popup('Employee',{
            tdAttrs: {width: 300},
            validateBlank: false,
            allowBlank:false,
            listeners: {
                onSelected:function(records, type)    {
                    if(records)    {
                        var record = records[0];
                        panelSearch.setValue("PERSON_NUMB",record['PERSON_NUMB']);
                        panelSearch.setValue("NAME",record['NAME']);
                        panelSearch.setValue("DEPT_NAME",record['DEPT_NAME']);
                        panelSearch.setValue("POST_CODE_NAME",record['POST_CODE_NAME']);
                        panelSearch.setValue("REPRE_NUM",record['REPRE_NUM_EXPOS']);
                        panelSearch.setValue("FOREIGN_NUM",record['FOREIGN_NUM']);
                        panelSearch.setValue("NATION_CODE",record['NATION_CODE']);
                        panelSearch.setValue("LIVE_GUBUN",record['LIVE_GUBUN']);


                        panelResult.setValue("PERSON_NUMB",record['PERSON_NUMB']);
                        panelResult.setValue("NAME",record['NAME']);
                        panelResult.setValue("DEPT_NAME",record['DEPT_NAME']);
                        panelResult.setValue("POST_CODE_NAME",record['POST_CODE_NAME']);
                        panelResult.setValue("REPRE_NUM",record['REPRE_NUM_EXPOS']);
                        panelResult.setValue("FOREIGN_NUM",record['FOREIGN_NUM']);
                        panelResult.setValue("NATION_CODE",record['NATION_CODE']);
                        panelResult.setValue("LIVE_GUBUN",record['LIVE_GUBUN']);

                        panelSearch.getField('PERSON_NUMB').setReadOnly(true);
						panelSearch.getField('NAME').setReadOnly(true);
						panelResult.getField('PERSON_NUMB').setReadOnly(true);
						panelResult.getField('NAME').setReadOnly(true);
						UniAppManager.app.onQueryButtonDown();
                    }
                },
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('PERSON_NUMB', newValue);
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('NAME', newValue);
                }
            }
        }),
        {fieldLabel: '', name:'DEPT_NAME', hidden:true},
        {fieldLabel: '', name:'POST_CODE_NAME', hidden:true},
        {fieldLabel: '', name:'REPRE_NUM', hidden:true},
        {fieldLabel: '', name:'FOREIGN_NUM', hidden:true},
        {fieldLabel: '', name:'NATION_CODE', hidden:true},
        {fieldLabel: '', name:'LIVE_GUBUN', hidden:true},
        {
            xtype: 'container',
            tdAttrs: {align: 'right'},
            layout: {type: 'uniTable', columns: 3},
            items:[{
               width: 110,
               xtype: 'button',
               text: 'PDF업로드',
               tdAttrs: {align: 'left', width: 115},
               handler : function() {
                   UniAppManager.app.openPDF();
               }
            },{
               width: 110,
               xtype: 'button',
               text: '집계자료가져오기',
               tdAttrs: {align: 'left', width: 115},
               handler : function() {
                       UniAppManager.app.confirmSaveData();
                       if(confirm(Msg.fsbMsgH0358))    {
                           UniAppManager.app.fnCollectData('REFER');
                       }
               }
            },{
               width: 110,
               xtype: 'button',
               text: '정산세액계산하기',
               tdAttrs: {align: 'left', width: 120},
               handler : function() {
                       UniAppManager.app.confirmSaveData();
                       if(confirm(Msg.fsbMsgH0342))    {
                           UniAppManager.app.fnCalculateTax();
                       }
               }
            }]
        }]
    });

    //기본공제 탭
    var tab1 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab1',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {type: 'table', columns:2},
            items: [
                {
                    xtype:'uniDetailForm',
                    disabled:false,
                    id:'tab1Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:2,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', align : 'center'}
        //                needsDivWrap: function() {
        //                    return false;
        //                }
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'button', text:'부양가족 기본공제 입력', style: 'text-align:center', tdAttrs: {height: 29}, width: '90%',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openFamily('P',panelSearch);
                             } else {
                                 alert("사원을 입력하세요.");
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
                    id:'tab1Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:5,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
        //                needsDivWrap: function() {
        //                    return false;
        //                }
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목', colspan: 3},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},

                        { xtype: 'component', html:'', colspan: 3},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:''},

                        { xtype: 'component', html:'기</br>본</br>공</br>제', rowspan: 3, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}},
                        { xtype: 'component', html:'본인', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'component', html:'', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PER_DED_I'},
                        { xtype: 'component', html:'근로소득자 본인에 대한 기본공제(연150만원)', style: 'text-align:left'},

                        { xtype: 'component', html:'배우자', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'component', html:'', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SPOUSE_DED_I'},
                        { xtype: 'component', html:'연간소득금액 합계액 100만원 이하인 배우자', style: 'text-align:left'},

                        { xtype: 'uniTextfield',  name: 'SPOUSE', hidden:true, fieldLabel:'배우자유무'},

                        { xtype: 'component', html:'부양가족', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'SUPP_NUM', width: 40,margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%', align : 'right'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SUPP_SUB_I'},
                        { xtype: 'component', html:'연간소득금액 합계액 100만원 이하인 부양가족', style: 'text-align:left'},

                        { xtype: 'component', html:'', colspan: 3},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:'만60세 이상 직계존속', style: 'text-align:left'},

                        { xtype: 'component', html:'', colspan: 3},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:'만20세 이하의 거주자 직계비속</br>민법 또는 입양촉진 및 절차에 관한 특례법에 따라 입양한 양자 ', style: 'text-align:left', rowspan: 2},

                        { xtype: 'component', html:'', colspan: 3},
                        { xtype: 'component', html:''},

                        { xtype: 'component', html:'', colspan: 3},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:'20세 이하 또는 60세 이상의 거주자(배우자포함) 형제자매', style: 'text-align:left'},

                        { xtype: 'component', html:'', colspan: 3},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:'국민기초생활 보장법 제2조 제2호의 수급자', style: 'text-align:left'},

                        { xtype: 'component', html:'', colspan: 3},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:'아동복지법에 따른 가정위탁을 받아 양육하는 아동', style: 'text-align:left'}
                    ]
                }
            ]
        }]
    });

    //추가공제 탭
    var tab2 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab2',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                    disabled:false,
                    id:'tab2Form400',
                    padding:0,
                    tdAttrs:{width:'30%'},
                    layout: {
                        type: 'table',
                        columns:2,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'uniNumberfield', name: 'MANY_CHILD_NUM', fieldLabel:'자녀',  hidden:true},
                        { xtype: 'uniNumberfield', name: 'BRING_CHILD_NUM', fieldLabel:'자녀양육',  hidden:true},
                        { xtype: 'uniNumberfield', name: 'BIRTH_ADOPT_NUM', fieldLabel:'출산입양',  hidden:true},

                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'button', text:'부양가족 추가공제 입력', style: 'text-align:center',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openFamily('P', panelSearch);
                             } else {
                                 alert("사원을 입력하세요.");
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

                        { xtype: 'component', html:'&nbsp;한부모공제', style: 'text-align:left'},
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
                    padding:0,
                    tdAttrs:{width:'70%'},
                    layout: {
                        type: 'table',
                        columns:5,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'uniNumberfield', name: 'MANY_CHILD_NUM', fieldLabel:'자녀',  hidden:true},
                        { xtype: 'uniNumberfield', name: 'BRING_CHILD_NUM', fieldLabel:'자녀양육',  hidden:true},
                        { xtype: 'uniNumberfield', name: 'BIRTH_ADOPT_NUM', fieldLabel:'출산입양',  hidden:true},

                        { xtype: 'component', html:'정 산 항 목', colspan: 3},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},

                        { xtype: 'component', html:'', colspan: 3},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:''},

                        { xtype: 'component', html:'추</br>가</br>공</br>제', rowspan: 4, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}},
                        { xtype: 'component', html:'경로우대', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'AGED_NUM', width: 40,margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%', align : 'right'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'AGED_DED_I'},
                        { xtype: 'component', html:'기본공제대상자가 만70세 이상(1945.12.31 이전 출생)인 경우', style: 'text-align:left'},

                        { xtype: 'component', html:'장애인', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'DEFORM_NUM', width: 40,margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%', align : 'right'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_DED_I'},
                        { xtype: 'component', html:'기본공제대상자 중 소득세법에 따른 장애인에 해당하는 경우', style: 'text-align:left'},

                        { xtype: 'component', html:'부녀자', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'component', html:'', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'WOMAN_DED_I'},
                        { xtype: 'component', html:'근로자 본인이 여성인 경우로서 공제요건에 해당하는 경우', style: 'text-align:left'},

                        { xtype: 'component', html:'한부모', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'component', html:'', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ONE_PARENT_DED_I'},
                        { xtype: 'component', html:'배우자가 없는 자로서 기본공제대상인 직계비속 또는 입양자가 있는 경우', style: 'text-align:left'}


                    ]
                }
            ]
        }]
    });

    //연금보험료 공제 탭
    var tab3 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab3',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab3Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}, colspan: 2},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'component', html:'&nbsp;국민연금보험료<font color= "blue">(자동집계)</font>', style: 'text-align:left', colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ANU_I'},

                        { xtype: 'component', html:'&nbsp;국민연금보험료<font color= "blue">(개별입력)</font>', style: 'text-align:left', colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'ANU_ADD_I'},

                        { xtype: 'component', html:'기타</br>연금</br>보험료', rowspan: 4, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}},
                        { xtype: 'component', html:'&nbsp;공무원연금', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'PUBLIC_PENS_I'},

                        { xtype: 'component', html:'&nbsp;군인연금', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'SOLDIER_PENS_I'},

                        { xtype: 'component', html:'&nbsp;사립학교교직원연금', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'SCH_PENS_I'},

                        { xtype: 'component', html:'&nbsp;별정우체국연금', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'POST_PENS_I'}

                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab3Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'uniNumberfield', value:'0', fieldLabel:'국민연금',  hidden:true, name: 'ANU_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel:'국민연금(개별입력)',  hidden:true, name: 'ANU_ADD_I'},


                        { xtype: 'component', html:'정 산 항 목'},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},

                        { xtype: 'component', html:'&nbsp;국민연금', style: 'text-align:left', tdAttrs:{height:58}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ANU_DED_I'},
                        { xtype: 'component', html:'국민연금법에 따라 부담하는 연금보험료(사용자부담금은 제외)', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;공무원연금', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PUBLIC_PENS_I'},
                        { xtype: 'component', html:'공무원연금법에 따라 근로자가 부담하는 기여금(또는 부담금)', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;군인연금', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SOLDIER_PENS_I'},
                        { xtype: 'component', html:'군인연금법에 따라 근로자가 부담하는 기여금(또는 부담금)', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;사립학교교직원연금', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SCH_PENS_I'},
                        { xtype: 'component', html:'사립학교교직원연금법에 따라 부담하는 기여금(또는 부담금)', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;별정우체국연금', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'POST_PENS_I'},
                        { xtype: 'component', html:'별정우체국법에 따라 근로자가 부담하는 기여금(또는 부담금)', style: 'text-align:left'}

                    ]
                }
            ]
        }]

    });

    //특별소득공제-보험료  탭
    var tab4 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab4',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab4Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:2,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'component', html:'&nbsp;건강보험료 등<font color= "blue">(자동집계)</font>', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MED_PREMINM_I'},

                        { xtype: 'component', html:'&nbsp;건강보험료 등<font color= "blue">(개별입력)</font>', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'MED_PREMINM_ADD_I'},

                        { xtype: 'component', html:'&nbsp;고용보험료<font color= "blue">(자동집계)</font>', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HIRE_INSUR_I'},

                        { xtype: 'component', html:'&nbsp;고용보험료<font color= "blue">(개별입력)</font>', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HIRE_INSUR_ADD_I'}
                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab4Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목'},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},

                        { xtype: 'component', html:'&nbsp;건강보험료 등', tdAttrs:{height:58}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MED_PREMINM_I', tdAttrs:{height:58}},
                        { xtype: 'component', html:'국민건강보험법 또는 노인장기요양보험법에 따라 근로자가 부담하는 보험료', style: 'text-align:left', tdAttrs:{height:58}},

                        { xtype: 'component', html:'&nbsp;고용보험료', tdAttrs:{height:58}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HIRE_INSUR_I'},
                        { xtype: 'component', html:'고용보험법에 따라 근로자가 부담하는 보험료', style: 'text-align:left'}

                    ]
                }
            ]
        }]
    });

    //특별소득공제-주택자금  탭
    var tab5 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab5',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab5Form400',
                    padding:0,
                    tdAttrs:{width:'35%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}, colspan: 2},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'component', html:'&nbsp;주택임차차입금', style: 'text-align:left', rowspan: 2, tdAttrs: {width:150, style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}},
                        { xtype: 'component', html:'&nbsp;원리금상환액(대출기관)', style: 'text-align:left', tdAttrs: {width:250, style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_TOT_I'},

                        { xtype: 'button', text:'원리금상환액(거주자) 입력', style: 'text-align:center', width: '90%',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openHouseLoan();
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_AMOUNT_TOT_I_2'},

                        //{ xtype: 'component', html:'&nbsp;원리금상환액(거주자)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_TOT_I_2'},

                        { xtype: 'component', html:'&nbsp;장기주택</br>&nbsp;저당차입금</br>&nbsp;이자상환액', style: 'text-align:left', rowspan: 9, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}},
                        { xtype: 'component', html:'&nbsp;15년미만(600만원한도)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I_2'},

                        { xtype: 'component', html:'&nbsp;15년~29년(1,000만원한도)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I'},

                        { xtype: 'component', html:'&nbsp;30년이상(1,500만원한도)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I_3'},

                        { xtype: 'component', html:'&nbsp;고정금리비거치상환대출', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'FIXED_RATE_LOAN'},

                        { xtype: 'component', html:'&nbsp;기타대출(500만원한도)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'ETC_LOAN'},

                        { xtype: 'component', html:'&nbsp;15년이상(고정금리이면서 비거치상환)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I_6'},

                        { xtype: 'component', html:'&nbsp;15년이상(고정금리이거나 비거치상환)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I_7'},

                        { xtype: 'component', html:'&nbsp;15년이상(그밖의대출)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I_8'},

                            { xtype: 'component', html:'&nbsp;10년이상(고정금리이거나 비거치상환)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_AMOUNT_INTER_I_9'}

                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab5Form600',
                    padding:0,
                    tdAttrs:{width:'65%'},
                    layout: {
                        type: 'table',
                        columns:5,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {height:29, style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; ', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목', colspan: 3},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}},

                        { xtype: 'component', html:'주택</br>자금</br>공제', rowspan: 11, tdAttrs: { width:100, style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}},
                        { xtype: 'component', html:'&nbsp;주택임차원리금</br>&nbsp;상환액', style: 'text-align:left', tdAttrs: { width:150, style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}, rowspan: 2},
                        { xtype: 'component', html:'&nbsp;대출기관', style: 'text-align:left', tdAttrs: { width:150, style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_AMOUNT_I', tdAttrs: { width:180}},
                        { xtype: 'component', html:'국민주택규모의 주택을 임차하기 위해 지출한 주택임차차입금', style: 'text-align:left', rowspan: 2},

                        { xtype: 'component', html:'&nbsp;거주자', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_AMOUNT_I_2'},

                        { xtype: 'component', html:'&nbsp;15년미만(600만원한도)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}, colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_2'},
                        { xtype: 'component', html:'주택에 저당권을 설정하고 금융회사 등으로부터 차입한 장기주택저당차입금의 이자', style: 'text-align:left', rowspan: 9},

                        { xtype: 'component', html:'&nbsp;15년~29년(1,000만원한도)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}, colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I'},

                        { xtype: 'component', html:'&nbsp;30년이상(1,500만원한도)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}, colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_3'},

                        { xtype: 'component', html:'&nbsp;고정금리비거치상환대출', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}, colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_5'},

                        { xtype: 'component', html:'&nbsp;기타대출(500만원한도)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}, colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_4'},

                        { xtype: 'component', html:'&nbsp;15년이상(고정금리이면서 비거치상환)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}, colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_6'},

                        { xtype: 'component', html:'&nbsp;15년이상(고정금리이거나 비거치상환)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}, colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_7'},

                        { xtype: 'component', html:'&nbsp;15년이상(그밖의대출)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}, colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_8'},

                        { xtype: 'component', html:'&nbsp;10년이상(고정금리이거나 비거치상환)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; '}, colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MORTGAGE_RETURN_I_9'}

                    ]
                }

            ]
        }]
    });


    //그밖소득공제-연금저축 탭
    var tab6 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab6',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
        xtype: 'container',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab6Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:2,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'button', text:'개인연금저축 입력', style: 'text-align:center', width: '90%',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openPersonalPension("21");
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PRIV_PENS_I'}

                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab6Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목'},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},

                        { xtype: 'component', html:'&nbsp;개인연금저축', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PRIV_PENS_I'},
                        { xtype: 'component', html:'근로자 본인 명의로 2000.12.31 이전에 가입하여 불입한 금액 ', style: 'text-align:left'}

                    ]
                }
            ]
        }]
    });

    //그밖소득공제-주택마련 탭
    var tab7 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab7',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab7Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:2,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'button', text:'청약저축(240만원한도) 입력', style: 'text-align:center', width: '90%',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openPersonalPension("31");
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }
                        },
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_BU_AMT'},

                        //{ xtype: 'button', text:'청약저축(120만원한도) 입력', style: 'text-align:center', width: '90%',
                        //  handler:function()    {
                        //     if(panelSearch.isValid())    {
                        //         UniAppManager.app.openPersonalPension("35");
                        //     } else {
                        //         alert("사원을 입력하세요.");
                        //     }
                        //  }},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_BU_ADD_AMT'},

                        { xtype: 'button', text:'근로자주택마련저축 입력', style: 'text-align:center', width: '90%',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openPersonalPension("34");
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_WORK_AMT'},

                        { xtype: 'button', text:'주택청약종합저축(240만원한도)', style: 'text-align:center', width: '90%',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openPersonalPension("32");
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_AMOUNT_I'}//,

                        //{ xtype: 'button', text:'주택청약종합저축(120만원한도)', style: 'text-align:center', width: '90%',
                        //  handler:function()    {
                        //     if(panelSearch.isValid())    {
                        //         UniAppManager.app.openPersonalPension("36");
                        //     } else {
                        //         alert("사원을 입력하세요.");
                        //     }
                        //  }},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_AMOUNT_ADD_I'}

                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab7Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목'},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},

                        { xtype: 'component', html:'&nbsp;청약저축', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_BU_AMT'},
                        { xtype: 'component', html:'주택법에 따른 청약저축에 납입한 금액', style: 'text-align:left'},   //, rowspan: 2},

                        //{ xtype: 'component', html:'&nbsp;청약저축', style: 'text-align:left'},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_BU_ADD_AMT'},

                        { xtype: 'component', html:'&nbsp;근로자주택마련저축', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_WORK_AMT'},
                        { xtype: 'component', html:'근로자의 주거안정과 목돈마련지원에 관한 법률에 따른 근로자 주택마련저축', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;주택청약종합저축', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_BU_AMOUNT_I'},
                        { xtype: 'component', html:'금융회사 등에 무주택확인서를 제출한 과세연도 이후에 납입한 금액 ', style: 'text-align:left'}    //, rowspan: 2},

                        //{ xtype: 'component', html:'&nbsp;주택청약종합저축', style: 'text-align:left'},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'HOUS_BU_AMOUNT_ADD_I'}
                    ]
                }
            ]
        }]
    });

    //그밖소득공제-신용카드  탭
    var tab8 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab8',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab8Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}, colspan: 2},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'button', text:'신용카드등 사용금액 입력', style: 'text-align:center', width: '90%', colspan: 2,
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openFamily('C', panelSearch);
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }
                        },
                        { xtype: 'component', html:''},

                        { xtype: 'component', html:'&nbsp;신용카드(전통시장ㆍ대중교통 제외)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%'}},
                        { xtype: 'component', html:'&nbsp;사용금액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 3%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'CARD_USE_I'},

                        { xtype: 'component', html:'&nbsp;현금영수증(전통시장ㆍ대중교통 제외)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%'}},
                        { xtype: 'component', html:'&nbsp;사용금액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 3%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'CASH_USE_I'},

                        { xtype: 'component', html:'&nbsp;직불카드등(전통시장ㆍ대중교통 제외)', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%'}},
                        { xtype: 'component', html:'&nbsp;사용금액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 3%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'DEBIT_CARD_USE_I'},

                        { xtype: 'component', html:'&nbsp;도서,공연사용액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%'}},
                        { xtype: 'component', html:'&nbsp;사용금액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 3%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'BOOK_CONCERT_USE_I'},

                        { xtype: 'component', html:'&nbsp;전통시장사용분', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%'}},
                        { xtype: 'component', html:'&nbsp;사용금액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 3%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'TRA_MARKET_USE_I'},

                        { xtype: 'component', html:'&nbsp;대중교통이용분', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%'}},
                        { xtype: 'component', html:'&nbsp;사용금액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 3%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'TRAFFIC_USE_I'}


                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab8Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'uniNumberfield', value:'0', fieldLabel:'신용카드사용액', hidden: true, name: 'CARD_USE_I', rowspan: 12},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel:'현금영수증사용액', hidden: true, name: 'CASH_USE_I', rowspan: 12},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel:'직불카드사용액', hidden: true, name: 'DEBIT_CARD_USE_I', rowspan: 12},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel:'전통시장사용액', hidden: true, name: 'TRA_MARKET_USE_I', rowspan: 12},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel:'대중교통이용액', hidden: true, name: 'TRAFFIC_USE_I', rowspan: 12},

                        { xtype: 'component', html:'정 산 항 목'},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},

                        { xtype: 'button', text:'신용카드등 사용금액 산출내역', style: 'text-align:center', width: '90%', colspan: 2, hidden:true,
                         handler:function(){

                         }},
                        { xtype: 'component', html:'', hidden:true},

                        { xtype: 'component', html:'신용카드등 사용금액', style: 'text-align:left', rowspan: 7},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly: true, name: 'CARD_DED_I', rowspan: 7},
                        { xtype: 'component', html:''},

                        { xtype: 'component', html:'신용카드를 사용하여 그 대가를 지급하는 금액', style: 'text-align:left'},

                        { xtype: 'component', html:'현금영수증(현금거래사실을 확인받는 것을 포함)', style: 'text-align:left'},

                        { xtype: 'component', html:'직불카드,선불카드 등등을 사용하여 대가로 지급한 금액', style: 'text-align:left'},

                        { xtype: 'component', html:'간행물 구입 또는 공연 관람의 대가로 지급한 금액', style: 'text-align:left'},

                        { xtype: 'component', html:'전통시장에서 사용한 신용카드,직불·선불카드,현금영수증 사용금액', style: 'text-align:left'},

                        { xtype: 'component', html:'대중교통을 신용카드, 직불ㆍ선불카드, 현금영수증으로 사용한 금액', style: 'text-align:left'}



                    ]
                }



            ]
        }]
    });

    //그밖소득공제-기타  탭
    var tab9 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab9',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab9Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:4,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}, colspan: 3},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'component', html:'&nbsp;소기업·소상공인 공제부금&nbsp;소득공제', style: 'text-align:left', tdAttrs: {width:350,style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}},
                         {  
                        	xtype: 'fieldcontainer',	//'fieldcontainer',
                            defaultType: 'checkboxfield',
                            colspan:2,
                            items: [
                                {boxLabel: '2016년 가입', name: 'COMP_PREMINUM', inputValue: true, tooltip:'2016년가입한 법인의 대표자인경우 체크'}
                            ],
// 							xtype: 'checkboxfield',
//                             colspan:2,
//                             name:'COMP_PREMINUM',
//                             fieldLabel:'2016년 가입',
//                             labelAlign:'right',
//                             labelWidth:100,
//                             inputValue: true,
                            listeners: {
                                blur: function( field, The, eOpts )    {
//                                     field.uniOpt.newValue = field.checked;
//                                     field.uniChanged = false;
//                                     UniAppManager.setToolbarButtons('save',true);
                                }
                            }
                        },
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'COMP_PREMINUM_I'},

                        //{ xtype: 'component', html:'&nbsp;투자조합 출자공제', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}, rowspan: 11},
                        //{ xtype: 'component', html:'2012년', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}, rowspan: 2},
                        //{ xtype: 'component', html:'투자금액(10%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I'},

                        //{ xtype: 'component', html:'투자금액(20%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I3'},

                        //{ xtype: 'component', html:'2013년', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}, rowspan: 2},
                        //{ xtype: 'component', html:'투자금액(10%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I4'},

                        //{ xtype: 'component', html:'투자금액(30%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I2'},

                        //{ xtype: 'component', html:'2014년', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}, rowspan: 3},
                        //{ xtype: 'component', html:'투자금액(10%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I5'},

                        //{ xtype: 'component', html:'투자금액(50%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I6'},

                        //{ xtype: 'component', html:'투자금액(30%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I7'},

                        //{ xtype: 'component', html:'2015년</br>이후', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}, rowspan: 4},
                        //{ xtype: 'component', html:'투자금액(10%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I8'},

                        //{ xtype: 'component', html:'투자금액(100%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I9'},

                        //{ xtype: 'component', html:'투자금액(50%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I10'},

                        //{ xtype: 'component', html:'투자금액(30%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I11'},

                        { xtype: 'component', html:'&nbsp;투자조합 출자공제', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}, rowspan: 6},
                        { xtype: 'component', html:'2016년', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}, rowspan: 2},
                        { xtype: 'component', html:'조합등투자금액(10%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I'},

                        { xtype: 'component', html:'벤처(100%,50%,30%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I2'},

                        { xtype: 'component', html:'2017년', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}, rowspan: 2},
                        { xtype: 'component', html:'조합등투자금액(10%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I3'},

                        { xtype: 'component', html:'벤처(100%,50%,30%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I4'},

                        { xtype: 'component', html:'2018년', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}, rowspan: 2},
                        { xtype: 'component', html:'조합등투자금액(10%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I5'},

                        { xtype: 'component', html:'벤처(100%,70%,30%)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_I6'},

                        { xtype: 'component', html:'&nbsp우리사주출연금소득공제', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}, rowspan:2},
                        { xtype: 'component', html:'&nbsp;출연금', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}, colspan:2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'STAFF_STOCK_I'},

                        { xtype: 'component', html:'&nbsp;출연금(벤처기업)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}, colspan:2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'VENTURE_STOCK_I'},

                        { xtype: 'component', html:'&nbsp;우리사주조합기부금소득공제', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}, hidden:true},
                        { xtype: 'component', html:'&nbsp;기부금액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}, colspan: 2, hidden:true},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'STAFF_GIFT_I', readOnly: true, hidden:true},

                        { xtype: 'component', html:'&nbsp;고용유지중소기업근로자 소득공제', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}},
                        { xtype: 'component', html:'&nbsp;임금감소액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}, colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'EMPLOY_WORKER_I'},

                        /*{ xtype: 'component', html:'&nbsp;목돈안드는전세이자상환액 공제', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}},
                        { xtype: 'component', html:'&nbsp;이자상환액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}, colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'NOT_AMOUNT_LOAN_I'},
                        */
                        { xtype: 'button', text:'장기집합투자증권저축 입력', style: 'text-align:center', width: '90%', colspan: 3,
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openPersonalPension("51");
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'LONG_INVEST_STOCK_I', readOnly: true}

                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab9Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목'},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},


                        { xtype: 'component', html:'&nbsp;소기업·소상공인 공제부금&nbsp;소득공제', style: 'text-align:left', tdAttrs:{width:300}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'COMP_PREMINUM_DED_I', readOnly: true},
                        { xtype: 'component', html:'소기업·소상공인 공제에 가입하여 해당 과세기간에 납부하는 공제부금', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;투자조합 출자공제', style: 'text-align:left', tdAttrs:{height:174}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INVESTMENT_DED_I', readOnly: true, tdAttrs:{height:174}},
                        { xtype: 'component', html:'중소기업창업투자조합 등에 출자 또는 투자한 금액 공제', style: 'text-align:left', tdAttrs:{height:174}},

                        { xtype: 'uniNumberfield', value:'0', fieldLabel:'투자조합출자공제(2013년도분)' , name: 'INVESTMENT_DED_I2', hidden: true},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel:'투자조합출자공제(2014년도분)' , name: 'INVESTMENT_DED_I3', hidden: true},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel:'투자조합출자공제(2015년이후분)' , name: 'INVESTMENT_DED_I4', hidden: true},

                        { xtype: 'component', html:'&nbsp우리사주출연금소득공제', style: 'text-align:left', tdAttrs:{height:58}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'STAFF_STOCK_DED_I', readOnly: true, tdAttrs:{height:58}},
                        { xtype: 'component', html:'우리사주조합원이 자사주를 취득하기 위하여 우리사주조합에 출자한 경우 ', style: 'text-align:left', tdAttrs:{height:58}},

                        { xtype: 'component', html:'&nbsp;우리사주조합기부금소득공제', style: 'text-align:left', hidden:true},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'STAFF_GIFT_DED_I', readOnly: true, hidden:true},
                        { xtype: 'component', html:'우리사주조합원이 아닌 근로자가 우리사주조합에 기부하는 기부금을 공제', style: 'text-align:left', hidden:true},

                        { xtype: 'component', html:'&nbsp;고용유지중소기업근로자 소득공제', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'EMPLOY_WORKER_DED_I', readOnly: true},
                        { xtype: 'component', html:'고용유지중소기업에 근로를 제공하는 상시근로자에 대한 공제', style: 'text-align:left'},

                        /*{ xtype: 'component', html:'&nbsp;목돈안드는전세이자상환액 공제', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'NOT_AMOUNT_LOAN_DED_I ', readOnly: true},
                        { xtype: 'component', html:'임대인 소유 주택에 저당권을 설정하고 임대인을 채무자로 하여 금융회사로부터 전세보증금을 차입한 경우', style: 'text-align:left'},
                        */
                        { xtype: 'component', html:'&nbsp;장기집합투자증권저축 공제', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'LONG_INVEST_STOCK_DED_I', readOnly: true},
                        { xtype: 'component', html:'자산총액 40%이상을 국내주식에 투자하는 장기 적립식 펀드', style: 'text-align:left'}

                    ]
                }


            ]
        }]
    });

    //세액감면 공제 탭
    var tab10 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab10',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },

            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab10Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:5,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}, colspan: 4},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'component', html:'세액</br>감면', rowspan: 4, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}},
                        { xtype: 'component', html:'&nbsp;소득세법', style: 'text-align:left', colspan: 2, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'component', html:'감면세액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 3%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'INCOME_REDU_I'},

                        { xtype: 'component', html:'&nbsp;중소기업취업청년', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '%', readOnly:true, name: 'YOUTH_EXEMP_RATE', tdAttrs: {style: 'width: 3%'}},
                        { xtype: 'component', html:'<font color= "blue">(자동계산)</font>', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 3%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'YOUTH_DED_I'},

                        { xtype: 'component', html:'&nbsp;외국인기술자', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}, colspan: 2},
                        { xtype: 'component', html:'<font color= "blue">(자동계산)</font>', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 3%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SKILL_DED_I'},


                        { xtype: 'component', html:'&nbsp;조세조약', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}, colspan: 2},
                        { xtype: 'component', html:'감면세액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 3%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'TAXES_REDU_I'}

                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab10Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:4,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목', colspan: 2},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},


                        { xtype: 'component', html:'세액</br>감면', rowspan: 4, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}},
                        { xtype: 'component', html:'소득세법', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'INCOME_REDU_I'},
                        { xtype: 'component', html:'우리나라에 파견된 외국인이 당사국의 정부로부터 받는 급여', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;중소기업취업청년', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'YOUTH_DED_I'},
                        { xtype: 'component', html:'중소기업 취업 청년에 대한 소득세 감면 ', style: 'text-align:left'},

                        { xtype: 'uniNumberfield', value:'0', fieldLabel:'중소기업청년 감면기간내 총소득금액(감면소득)', hidden:true, name: 'YOUTH_DED_I_SUM'},

                        { xtype: 'component', html:'&nbsp;외국인기술자', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SKILL_DED_I'},
                        { xtype: 'component', html:'외국인 기술자에 대한 소득세 면제', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;조세조약', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 8%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'TAXES_REDU_I'},
                        { xtype: 'component', html:'조세조약의 교직자 조항으로 소득세 면제', style: 'text-align:left'}

                    ]
                }
            ]
        }]
    });

    //세액공제-근로소득/자녀 탭
    var tab11 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab11',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab11Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:2,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'component', html:'&nbsp;근로소득세액공제<font color= "blue">(자동계산)</font>', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'IN_TAX_DED_I'},

                        { xtype: 'component', html:'&nbsp;자녀세액공제<font color= "blue">(자동계산)</font>', style: 'text-align:left;'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'CHILD_TAX_DED_I'},

                        //{ xtype: 'component', html:'&nbsp;자녀양육공제<font color= "blue">(자동계산)</font>', style: 'text-align:left'},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'BRING_CHILD_DED_I'},

                        { xtype: 'component', html:'&nbsp;출산입양공제<font color= "blue">(자동계산)</font>', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'BIRTH_ADOPT_I'}

                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab11Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목', tdAttrs: {height: 29}},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},

                        { xtype: 'component', html:'&nbsp;근로소득세액공제', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'IN_TAX_DED_I'},
                        { xtype: 'component', html:'근로소득자에 대해 그 근로소득에 대한 종합소득산출세액에서 해당하는 금액을 공제', style: 'text-align:left'},


                        { xtype: 'component', html:'&nbsp;자녀세액공제', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'CHILD_TAX_DED_I'},
                        { xtype: 'component', html:'근로자의 기본공제대상자에 해당하는 자녀(입양자 및 위탁아동 포함)에 대해서 해당하는 금액을 근로소득에 대한 종합소득산출세액에서 공제', style: 'text-align:left'},


                        //{ xtype: 'component', html:'&nbsp;자녀양육공제', style: 'text-align:left'},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'BRING_CHILD_DED_I'},
                        //{ xtype: 'component', html:'6세 이하의 공제대상자에 대하여 종합소득산출세액에서 공제', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;출산입양공제', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'BIRTH_ADOPT_I'},
                        { xtype: 'component', html:'해당 과세기간에 출생입양신고한 경우 1명당 연30만원을 종합소득산출세액에서 공제', style: 'text-align:left'}

                    ]
                }


            ]
        }]
    });

    //세액공제-연금계좌
    var tab12 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab12',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
        xtype: 'container',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab12Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}, colspan: 2},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'component', html:'연금</br>계좌', rowspan: 3, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 3%'}},
                        { xtype: 'button', text:'과학기술인공제 입력', style: 'text-align:center', tdAttrs: {height:58}, width: '90%',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openPersonalPension("12");
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }
                        },
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SCI_DEDUC_I', tdAttrs: {height:58}},

                        { xtype: 'button', text:'근로자퇴직급여보장법 입력', style: 'text-align:center',tdAttrs: {height:58}, width: '90%',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openPersonalPension("11");
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }
                        },
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETIRE_PENS_I', tdAttrs: {height:58}},

                        { xtype: 'button', text:'연금저축계좌 입력', style: 'text-align:center', tdAttrs: {height:58}, width: '90%',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openPersonalPension("22");
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }
                        },
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PENS_I', tdAttrs: {height:58}}

                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab12Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:4,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목'},
                        { xtype: 'component', html:'공제대상금액'},
                        { xtype: 'component', html:'세액공제액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},

                        { xtype: 'component', html:'&nbsp;과학기술인공제', style: 'text-align:left', rowspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SCI_DEDUC_I', rowspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SCI_TAX_DED_I1'},
                        { xtype: 'component', html:'과학기술인공제회법에 따라 근로자가 부담하는 부담금(세액공제율15%)', style: 'text-align:left'},

                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SCI_TAX_DED_I'},
                        { xtype: 'component', html:'과학기술인공제회법에 따라 근로자가 부담하는 부담금(세액공제율12%)', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;근로자퇴직급여보장법', style: 'text-align:left', rowspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETIRE_PENS_I', rowspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETIRE_TAX_DED_I1'},
                        { xtype: 'component', html:'근로자퇴직급여보장법에 따라 근로자가 부담하는 부담금(세액공제율15%)', style: 'text-align:left'},

                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETIRE_TAX_DED_I'},
                        { xtype: 'component', html:'근로자퇴직급여보장법에 따라 근로자가 부담하는 부담금(세액공제율12%)', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;연금저축계좌', style: 'text-align:left', rowspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PENS_I', rowspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PENS_TAX_DED_I1'},
                        { xtype: 'component', html:'근로자 본인 명의로 2001.1.1 이후에 가입하여 해당 과세기간에 납입한 금액(세액공제율15%)', style: 'text-align:left'},

                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PENS_TAX_DED_I'},
                        { xtype: 'component', html:'근로자 본인 명의로 2001.1.1 이후에 가입하여 해당 과세기간에 납입한 금액(세액공제율12%)', style: 'text-align:left'}

                    ]
                }
            ]
        }]
    });

    //특별세액공제-보장성보험
    var tab13 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab13',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab13Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:2,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'button', text:'보장성보험 입력', style: 'text-align:center', width: '90%',
                            handler:function(){
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openFamily('I', panelSearch);
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }
                        },
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ETC_INSUR_I'},

                        { xtype: 'button', text:'장애인전용보장성보험 입력', style: 'text-align:center', width: '90%',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openFamily('I', panelSearch);
                             } else {
                                 alert("사원을 입력하세요.");
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
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:4,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목'},
                        { xtype: 'component', html:'공제대상금액'},
                        { xtype: 'component', html:'세액공제액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},

                        { xtype: 'component', html:'&nbsp;보장성보험', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ETC_INSUR_I'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ETC_INSUR_TAX_DED_I'},
                        { xtype: 'component', html:'근로자가 지급한 기본공제대상자를 피보험자로 하는 보장성보험', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;장애인전용보험', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_INSUR_I'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_INSUR_TAX_DED_I'},
                        { xtype: 'component', html:'기본공제대상자 중 장애인을 피보험자 또는 수익자로 하는 장애인전용보험', style: 'text-align:left'}

                    ]
                }
            ]
        }]
    });

    //특별세액공제-의료비
    var tab14 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab14',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2,
                tableAttrs: { width: '100%'}
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab14Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}, colspan: 2},
                        { xtype: 'component', html:'선택 또는 입력'},

                        {
                            xtype: 'container',
                            colspan: 3,
                            tdAttrs : {align: 'left'},
                            layout: {type: 'table', columns: 2},
                            items:[
                                    { xtype: 'button', text:'의료비내역 입력',width:250,  tdAttrs:{'align':'center',width:300},
			                          handler:function()    {
			                                 if(panelSearch.isValid())    {
			                                  	UniAppManager.app.openMedDoc();
			                                 } else {
			                                     alert("사원을 입력하세요.");
			                                 }
			                          }
			                        },{
			                          xtype: 'button', text:'의료비제출대상 입력',  width:250,  tdAttrs:{'align':'center',width:300}, margin: '0 2 0 0',
				                      handler:function()    {
				                             if(panelSearch.isValid())    {
				                                 UniAppManager.app.openFamily('M', panelSearch);
				                             } else {
				                                 alert("사원을 입력하세요.");
				                             }
					                 }
			                       }
			                     ]
                        },

                        { xtype: 'component', html:'&nbsp;①난임 시술비', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 12%'}},
                        { xtype: 'component', html:'지출액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SURGERY_MED_I'},

                        { xtype: 'component', html:'&nbsp;②본인,65세이상자,장애인,건강보험산정 특례자', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 12%'}},
                        { xtype: 'component', html:'지출액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'BASE_MED_I'},

                        { xtype: 'component', html:'&nbsp;③그밖의 공제대상자 의료비', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 12%'}},
                        { xtype: 'component', html:'지출액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 2%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MED_TOTAL_I'}

                        //{ xtype: 'component', html:'&nbsp;①본인의료비', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%'}},
                        //{ xtype: 'component', html:'지출액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MY_MED_DED_I'},

                        //{ xtype: 'component', html:'&nbsp;②65세이상 부양가족 의료비', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%'}},
                        //{ xtype: 'component', html:'지출액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SENIOR_MED_I'},

                        //{ xtype: 'component', html:'&nbsp;③장애인 의료비', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%'}},
                        //{ xtype: 'component', html:'지출액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_MED_I'},

                        //{ xtype: 'component', html:'&nbsp;④난임 시술비', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%'}},
                        //{ xtype: 'component', html:'지출액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SURGERY_MED_I'},

                        //{ xtype: 'component', html:'&nbsp;⑤그밖의 공제대상자 의료비', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%'}},
                        //{ xtype: 'component', html:'지출액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MED_TOTAL_I'}

                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab14Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:4,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목'},
                        { xtype: 'component', html:'공제대상금액'},
                        { xtype: 'component', html:'세액공제액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},

                        { xtype: 'button', text:'의료비산출내역보기', style: 'text-align:center', width: 250, colspan: 3, tdAttrs : {align: 'center'}, hidden:true},
                        { xtype: 'component', html:'', hidden:true},

                        { xtype: 'component', html:'&nbsp;의료비공제금액', style: 'text-align:left', rowspan:4},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MED_DED_I', rowspan:4},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MED_TAX_DED_I', rowspan:4},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:'난임 시술을 위하여 지급한 의료비', style: 'text-align:left'},

                        { xtype: 'component', html:'본인·65세이상인 자·장애인·건강보험산정특례자를 위하여 지출한 의료비', style: 'text-align:left', tdAttrs:{height:"29px"}},

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
        id:'had618ukrTab15',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab15Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:4,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}, colspan: 3},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'button', text:'교육비내역 입력', style: 'text-align:center', width: '90%', colspan: 3,
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openFamily('E', panelSearch);

                             } else {
                                 alert("사원을 입력하세요.");
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


                        { xtype: 'component', html:'부양</br>가족</br>교육비', rowspan: 3, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'component', html:'&nbsp;대학생', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'UNIV_EDUC_NUM', width: 40, margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%', align: 'right'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'UNIV_EDUC_I'},

                        { xtype: 'component', html:'&nbsp;초·중·고', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'STUD_EDUC_NUM', width: 40, margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%', align: 'right'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'STUD_EDUC_I'},

                        { xtype: 'component', html:'&nbsp;취학전아동', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'KIND_EDU_NUM', width: 40, margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%', align: 'right'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'KIND_EDUC_I'},

                        { xtype: 'component', html:'&nbsp;장애인 특수교육비 지출액', colspan: 3},
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
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:6,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목', colspan: 3},
                        { xtype: 'component', html:'공제대상금액'},
                        { xtype: 'component', html:'세액공제액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},


                        { xtype: 'component', html:'', colspan: 3},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:''},


                        { xtype: 'component', html:'교육비', rowspan: 6, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'component', html:'&nbsp;본인', style: 'text-align:left', colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PER_EDUC_DED_I'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PER_EDUC_TAX_DED_I'},
                        { xtype: 'component', html:'공제한도:본인(전액)', style: 'text-align:left'},

                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '(공제대상)교육비공제', hidden:true, name: 'EDUC_DED_I'},

                        { xtype: 'component', html:'&nbsp;대학생', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'UNIV_EDUC_NUM', width: 40, margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%', align: 'right'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'UNIV_EDUC_DED_I'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'UNIV_EDUC_TAX_DED_I'},
                        { xtype: 'component', html:'공제한도:대학생(연900만원)', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;초·중·고', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'STUD_EDUC_NUM', width: 40, margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%', align: 'right'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'STUD_EDUC_DED_I'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'STUD_EDUC_TAX_DED_I'},
                        { xtype: 'component', html:'공제한도:초·중·고(연300만원)', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;취학전아동', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '명', readOnly:true, name: 'KIND_EDU_NUM', width: 40, margin: '0 3 0 0', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%', align: 'right'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'KIND_EDUC_DED_I'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'KIND_EDUC_TAX_DED_I'},
                        { xtype: 'component', html:'공제한도:취학전아동(연300만원)', style: 'text-align:left'},


                        { xtype: 'component', html:'&nbsp;장애인', style: 'text-align:left', colspan: 2},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_EDUC_DED_I'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEFORM_EDUC_TAX_DED_I'},
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
        id:'had618ukrTab16',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab16Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}, colspan: 2},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'button', text:'기부금내역 입력', style: 'text-align:center', width: '90%', colspan: 2, tdAttrs : {align: 'center'},
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openDonation();
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }
                        },
                        { xtype: 'component', html:''},

                        { xtype: 'component', html:'&nbsp;정치자금기부금', rowspan: 2, style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'component', html:'10만원이하', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'POLICY_INDED'},

                        { xtype: 'component', html:'10만원초과', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'POLICY_GIFT_I'},

                        { xtype: 'component', html:'&nbsp;법정기부금', rowspan: 2, style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        /*{ xtype: 'component', html:'2013년도이월액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'LEGAL_GIFT_I_PREV'},
                        */
                        { xtype: 'component', html:'이월액(세액공제)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'LEGAL_GIFT_I_PREV_14'},

                        { xtype: 'component', html:'기부금액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'LEGAL_GIFT_I'},

                        /*{ xtype: 'component', html:'&nbsp;특례기부금</br>&nbsp;(공익신탁기부금제외)', rowspan: 2, style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'component', html:'전년도이월액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PRIV_GIFT_I_PREV'},

                        { xtype: 'component', html:'기부금액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PRIV_GIFT_I'},

                        { xtype: 'component', html:'&nbsp;공익신탁기부금', rowspan: 2, style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'component', html:'전년도이월액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PUBLIC_GIFT_I_PREV'},

                        { xtype: 'component', html:'기부금액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PUBLIC_GIFT_I'},
                        */
                        { xtype: 'component', html:'&nbsp;우리사주조합기부금', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'component', html:'기부금액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'STAFF_GIFT_I'},

                        { xtype: 'component', html:'&nbsp;지정기부금(종교단체외)', rowspan: 3, style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'component', html:'이월액(소득공제)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'APPOINT_GIFT_I_PREV'},

                        { xtype: 'component', html:'이월액(세액공제)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'APPOINT_GIFT_I_PREV_14'},

                        { xtype: 'component', html:'기부금액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'APPOINT_GIFT_I'},

                        { xtype: 'component', html:'&nbsp;  종교단체기부금', rowspan: 3, style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 6%'}},
                        { xtype: 'component', html:'이월액(소득공제)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ASS_GIFT_I_PREV'},

                        { xtype: 'component', html:'이월액(세액공제)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ASS_GIFT_I_PREV_14'},

                        { xtype: 'component', html:'기부금액', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 4%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ASS_GIFT_I'}
                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab16Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목'},
                        { xtype: 'component', html:'세액공제액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},


                        { xtype: 'button', text:'기부금산출내역보기', style: 'text-align:center', width: '60%', colspan: 2, tdAttrs : {align: 'left'}, hidden:true},
                        { xtype: 'component', html:'', hidden:true},


                        { xtype: 'component', html:'&nbsp;기부금공제금액', style: 'text-align:left', rowspan: 5, tdAttrs: { height: 319}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'GIFT_TAX_DED_I', rowspan: 5, tdAttrs: { height: 319}},
                        { xtype: 'component', html:''},

                        { xtype: 'component', html:'근로소득자가 정치자금법에 따라 정당에 기부한 정치자금', style: 'text-align:left', tdAttrs: { height: 58}},

                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '(입력금액)정치자금기부금(10만원미만)   ', hidden:true, name: 'POLICY_INDED'},
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


                        { xtype: 'component', html:'소득세법 제34조 제2항에서 규정하는 기부금', style: 'text-align:left', tdAttrs: { height: 58}},

                        /*{ xtype: 'component', html:'2011.6.30까지 지출한 기부금에 한함', style: 'text-align:left', tdAttrs: { height: 58}},

                        { xtype: 'component', html:'2011.6.30까지 지출한 기부금에 한함', style: 'text-align:left', tdAttrs: { height: 58}},
                        */
                        { xtype: 'component', html:'우리사주조합원이 아닌 사람이 우리사주조합에 지출하는 기부금', style: 'text-align:left'},

                        { xtype: 'component', html:'소득세법 시행령 제80조에서 규정하는 기부금', style: 'text-align:left', tdAttrs: { height: 174}}
                    ]
                }
            ]
        }]
    });

    //세액공제-기타
    var tab17 = Ext.create('Ext.container.Container',{
        id:'had618ukrTab17',
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab17Form400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', tdAttrs: {height: 29}, colspan: 2},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'component', html:'&nbsp;납세조합공제', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 5%'}},
                        { xtype: 'component', html:'공제세액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 5%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'P3_TAX_DED_I'},

                        { xtype: 'component', html:'&nbsp;주택차입금', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 5%'}},
                        { xtype: 'component', html:'이자상환액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 5%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'HOUS_INTER_I'},

                        { xtype: 'component', html:'&nbsp;외국납부', rowspan: 2, style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 5%'}},
                        { xtype: 'component', html:'소득금액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 5%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'FORE_INCOME_I'},

                        { xtype: 'component', html:'납부세액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 5%'}},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', name: 'FORE_TAX_I'},

                        { xtype: 'button', text:'월세납부내역 입력', width: '90%', colspan: 2, tdAttrs : {align: 'center'},
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openRent();
                             } else {
                                 alert("사원을 입력하세요.");
                             }
                          }
                        },
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'MON_RENT_I'}
                    ]
                },{
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'tab17Form600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목'},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%'}},

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
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
         flex: 1,
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            autoScroll: true,
            xtype: 'container',
            layout: {
                type: 'uniTable',
                columns:1
//                tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
//                tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', align : 'center'}
//                needsDivWrap: function() {
//                    return false;
//                }
            },
//            defaults:{width: '97.5%', margin: '2 2 2 2'},
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
                    tdAttrs: {align:'center', width:40, style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', width:40,style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', width:40,style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', width:40,style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', width:40,style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'left', width:420, style: 'margin:200px;border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
                },{
                    xtype: 'component',
                    html: '<div style="margin-left:125px;">↑</div>',
                    tdAttrs: {align:'left', width:250,style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
                },{
                    xtype: 'component',
                    html: '<div style="margin-left:152px;">↑</div>',
                    tdAttrs: {align:'left',width:300 ,style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
                },{
                    xtype: 'component',
                    html: '<div style="margin-left:136px;">↑</div>',
                    tdAttrs: {align:'left',style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
                },{
                    xtype: 'component',
                    html: '<div style="margin-left:176px;">↑</div>',
                    tdAttrs: {align:'left', width:450,style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'},
                    colspan:2
                },{
                    xtype: 'component',
                    html: '&nbsp;',
                    tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'},
                    colspan:2
                },{
                    xtype: 'component',
                    html: '&nbsp;',
                    tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
                    tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'},
                    colspan:2
                },{
                    xtype: 'component',
                    html: '&nbsp;',
                    tdAttrs: {align:'center', style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}
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
            load: 'had618ukrService.selectFormData02'
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
                tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
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

                { xtype: 'component',  html:'퇴직소득공제', rowspan: 6, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 15%', align : 'center'}},
                { xtype: 'component',  html:'소득공제(ⓐ)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 15%', align : 'center'}},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'B', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 15%', align : 'center'}},
                { xtype: 'component',  html:'2011년 귀속부터 퇴직급여액의 40%', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'근속연수별공제(ⓑ)', rowspan: 4},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'C'},
                { xtype: 'component',  html:'&nbsp;5년이하', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%', align : 'center'}},
                { xtype: 'component',  html:'&nbsp;30만 * 근속연수', colspan: 2, style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%', align : 'center'}},

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
                tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', align : 'center'}
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
        layout: {type: 'uniTable', columns:1},
        items:[{
            xtype: 'uniDetailForm',
            id:'infoForm400',
            disabled:false,
            layout: {type: 'uniTable', columns: 6},
            items:[{
                 xtype: 'container',
                 html:'<b>■ 기본사항</b>',
                 tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 13px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'left'},
    //             colspan: 8,
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
                width:315
            },{
                fieldLabel: '외국법인소속 파견근로자',
                xtype: 'checkbox',
                labelWidth: 200,
                boxLabel: '',
                name: 'FOREIGN_DISPATCH_YN',
                width: 250,
 				readOnly:true,
                inputValue: true
            },{
                fieldLabel: '외국인단일세율',
                xtype: 'checkbox',
                boxLabel: '',
                name: 'FORE_SINGLE_YN',
                labelWidth: 150,
 				readOnly:false,
                inputValue: true
            },{
                fieldLabel: '중도퇴사자정산',
                xtype: 'checkbox',
                name: 'HALFWAY_TYPE',
                labelWidth: 150,
                readOnly:true,
                inputValue: true
            }]
        }, {
            xtype: 'container',
            margin: '5 0 0 0',
            padding: '5 7 20 7',
            layout: {
                type: 'table',
                columns:2
            },
            items: [
                {
                    xtype:'uniDetailForm',
                     disabled:false,
                    id:'baseForm400',
                    padding:0,
                    tdAttrs:{width:'40%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'입력할 항목', colspan: 2, tdAttrs: {height: 29}},
                        { xtype: 'component', html:'선택 또는 입력'},

                        { xtype: 'component', html:'&nbsp;총급여액', style: 'text-align:left'},
                        { xtype: 'component', html:'<font color= "blue">&nbsp;(자동집계)</font>', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'INCOME_SUPP_TOTAL_I'},

                        { xtype: 'button', text:'년간근로소득/기타소득입력', style: 'text-align:center', colspan: 2, width: '70%',
                         handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openYearIncome();
                             } else {
                                 alert("사원을 입력하세요.");
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

                        { xtype: 'button', text:'종(전)근무지내역 입력', style: 'text-align:center', colspan: 2, width: '70%',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openPrevCompany();
                             } else {
                                 alert("사원을 입력하세요.");
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

                        { xtype: 'button', text:'납세조합내역 입력', style: 'text-align:center', colspan: 2, width: '70%',
                          handler:function()    {
                             if(panelSearch.isValid())    {
                                 UniAppManager.app.openTaxCommunity();
                             } else {
                                 alert("사원을 입력하세요.");
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
                    id:'baseForm600',
                    padding:0,
                    tdAttrs:{width:'60%'},
                    layout: {
                        type: 'table',
                        columns:3,
                        tableAttrs: { width: '100%'},
                        tdAttrs: {style: 'border-style:solid; border-color:#ced9e7;border-width: 1px 1px 1px 1px; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', height: 29, align : 'center'}
                    },
                    defaults:{width: '97.5%', margin: '2 2 2 2'},
                    items:[
                        { xtype: 'component', html:'정 산 항 목'},
                        { xtype: 'component', html:'정 산 금 액'},
                        { xtype: 'component', html:'항목별 요약설명 및 공제요건'},

                        { xtype: 'component', html:'&nbsp;과세대상금액', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'INCOME_SUPP_TOTAL_I'},
                        { xtype: 'component', html:'&nbsp;연간근로소득에서 비과세소득을 뺀 금액', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 40%'}},

                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '급여총액', hidden:true, name: 'PAY_TOTAL_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '상여총액', hidden:true, name: 'BONUS_TOTAL_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '인정상여금액(', hidden:true, name: 'ADD_BONUS_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '주식매수선택행사이익', hidden:true, name: 'STOCK_PROFIT_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '우리사주조합인출금', hidden:true, name: 'OWNER_STOCK_DRAW_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '임원퇴직한도초과액', hidden:true, name: 'OF_RETR_OVER_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)급여총액', hidden:true, name: 'NOW_PAY_TOT_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)상여총액', hidden:true, name: 'NOW_BONUS_TOTAL_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)인정상여금액', hidden:true, name: 'NOW_ADD_BONUS_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)주식매수선택행사이익', hidden:true, name: 'NOW_STOCK_PROFIT_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)우리사주조합인출금', hidden:true, name: 'NOW_OWNER_STOCK_DRAW_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '주(현)임원퇴직한도초과액', hidden:true, name: 'NOW_OF_RETR_OVER_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)급여총액', hidden:true, name: 'OLD_PAY_TOT_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)상여총액', hidden:true, name: 'OLD_BONUS_TOTAL_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)인정상여금액', hidden:true, name: 'OLD_ADD_BONUS_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)주식매수선택행사이익', hidden:true, name: 'OLD_STOCK_PROFIT_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)우리사주조합인출금', hidden:true, name: 'OLD_OWNER_STOCK_DRAW_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '종(전)임원퇴직한도초과액', hidden:true, name: 'OLD_OF_RETR_OVER_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '(납)급여총액', hidden:true, name: 'NAP_PAY_TOT_I'},
                        { xtype: 'uniNumberfield', value:'0', fieldLabel: '(납)상여총액', hidden:true, name: 'NAP_BONUS_TOTAL_I'},


                        { xtype: 'component', html:''},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:'&nbsp;주(현)근무지의 년간근로소득내역 조회/기타소득내역 입력', style: 'text-align:left'},

                        { xtype: 'component', html:''},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:'&nbsp;종(전)근무지의 소득내역 및 납부세액내역 입력', style: 'text-align:left'},

                        { xtype: 'component', html:''},
                        { xtype: 'component', html:''},
                        { xtype: 'component', html:'&nbsp;납세조합의 소득내역 및 납부세액내역 입력', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;근로소득공제', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'INCOME_DED_I'},
                        { xtype: 'component', html:'&nbsp;총급여액에서 일정금액을 공제한 금액', style: 'text-align:left'},

                        { xtype: 'component', html:'&nbsp;근로소득금액', style: 'text-align:left'},
                        { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'EARN_INCOME_I'},
                        { xtype: 'component', html:'&nbsp;총급여액에서 근로소득공제를 뺀 금액', style: 'text-align:left'}

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
//        tabPosition: 'left',
//        tabRotation: 0,
        items: [{
             title: '기본공제'
             ,id: 'had618ukrTab01'
             ,autoScroll: true
             ,items:[tab1]
        },{
             title: '추가공제'
             ,id: 'had618ukrTab02'
             ,autoScroll: true
             ,items:[tab2]
        },{
             title: '연금보험료공제'
             ,id: 'had618ukrTab03'
             ,autoScroll: true
             ,items:[tab3]
        },{
             title: '특별소득공제-보험료'
             ,id: 'had618ukrTab04'
             ,autoScroll: true
             ,items:[tab4]
        },{
             title: '특별소득공제-주택자금'
             ,id: 'had618ukrTab05'
             ,autoScroll: true
             ,items:[tab5]
        },{
             title: '그밖소득공제-연금저축'
             ,id: 'had618ukrTab06'
             ,autoScroll: true
             ,items:[tab6]
        },{
             title: '그밖소득공제-주택마련'
             ,id: 'had618ukrTab07'
             ,autoScroll: true
             ,items:[tab7]
        },{
             title: '그밖소득공제-신용카드'
             ,id: 'had618ukrTab08'
             ,autoScroll: true
             ,items:[tab8]
        },{
             title: '그밖소득공제-기타'
             ,id: 'had618ukrTab09'
             ,autoScroll: true
             ,items:[tab9]
        },{
             title: '세액감면'
             ,autoScroll: true
             ,items:[tab10]
        },{
             title: '세액공제-근로소득/자녀'
             ,autoScroll: true
             ,items:[tab11]
        },{
             title: '세액공제-연금계좌'
             ,autoScroll: true
             ,items:[tab12]
        },{
             title: '특별세액공제-보장성보험'
             ,autoScroll: true
             ,items:[tab13]
        },{
             title: '특별세액공제-의료비'
             ,autoScroll: true
             ,items:[tab14]
        },{
             title: '특별세액공제-교육비'
             ,autoScroll: true
             ,items:[tab15]
        },{
             title: '특별세액공제-기부금'
             ,autoScroll: true
             ,items:[tab16]
        },{
             title: '세액공제-기타'
             ,autoScroll: true
             ,items:[tab17]
        },{
             title: '세액산출요약'
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
        //store: direct400Store,
        store: direct600Store,
        columns:[
              {dataIndex    :'PERSON_NUMB'                  }
             ,{dataIndex    :'JOIN_DATE'                    }
             ,{dataIndex    :'RETR_DATE'                    }
             ,{dataIndex    :'DEPT_CODE'                    }
             ,{dataIndex    :'DEPT_NAME'                    }
             ,{dataIndex    :'YEAR_YYYY'                    }
             ,{dataIndex    :'HALFWAY_TYPE'                 }
             ,{dataIndex    :'FORE_SINGLE_YN'               }
             ,{dataIndex    :'FOREIGN_DISPATCH_YN'          }
             ,{dataIndex    :'HOUSEHOLDER_YN'               }
             ,{dataIndex    :'INCOME_SUPP_TOTAL_I'          }
             ,{dataIndex    :'PAY_TOTAL_I'                  }
             ,{dataIndex    :'BONUS_TOTAL_I'                }
             ,{dataIndex    :'ADD_BONUS_I'                	}
             ,{dataIndex    :'STOCK_PROFIT_I'               }
             ,{dataIndex    :'OWNER_STOCK_DRAW_I'           }
             ,{dataIndex    :'OF_RETR_OVER_I'        		}
             ,{dataIndex    :'NOW_PAY_TOT_I'            	}
             ,{dataIndex    :'NOW_BONUS_TOTAL_I'            }
             ,{dataIndex    :'NOW_ADD_BONUS_I'              }
             ,{dataIndex    :'NOW_STOCK_PROFIT_I'           }
             ,{dataIndex    :'NOW_OWNER_STOCK_DRAW_I'       }
             ,{dataIndex    :'NOW_OF_RETR_OVER_I'           }
             ,{dataIndex    :'OLD_PAY_TOT_I'        		}
             ,{dataIndex    :'OLD_BONUS_TOTAL_I'            }
             ,{dataIndex    :'OLD_ADD_BONUS_I'              }
             ,{dataIndex    :'OLD_STOCK_PROFIT_I'           }
             ,{dataIndex    :'OLD_OWNER_STOCK_DRAW_I'       }
             ,{dataIndex    :'OLD_OF_RETR_OVER_I'           }
             ,{dataIndex    :'NAP_PAY_TOT_I'                }
             ,{dataIndex    :'NAP_BONUS_TOTAL_I'            }
             ,{dataIndex    :'INCOME_DED_I'                 }
             ,{dataIndex    :'EARN_INCOME_I'                }
             ,{dataIndex    :'PER_DED_I'                    }
             ,{dataIndex    :'SPOUSE'                    	}
             ,{dataIndex    :'SPOUSE_DED_I'                 }
             ,{dataIndex    :'SUPP_NUM'                    	}
             ,{dataIndex    :'SUPP_SUB_I'                   }
             ,{dataIndex    :'AGED_NUM'                    	}
             ,{dataIndex    :'DEFORM_NUM'                   }
             ,{dataIndex    :'MANY_CHILD_NUM'               }
             ,{dataIndex    :'BRING_CHILD_NUM'              }
             ,{dataIndex    :'BIRTH_ADOPT_NUM'              }
             ,{dataIndex    :'WOMAN'                        }

             ,{dataIndex    :'BIRTH_ADOPT_NUM1'             }
             ,{dataIndex    :'BIRTH_ADOPT_NUM2'             }
             ,{dataIndex    :'BIRTH_ADOPT_NUM3'             }
             ,{dataIndex    :'AGED_DED_I'                   }
             ,{dataIndex    :'DEFORM_DED_I'                 }
             ,{dataIndex    :'WOMAN_DED_I'                  }
             ,{dataIndex    :'ONE_PARENT_DED_I'             }

             ,{dataIndex    :'ANU_I'                        }
             ,{dataIndex    :'ANU_ADD_I'                    }
             ,{dataIndex    :'PUBLIC_PENS_I'                }
             ,{dataIndex    :'SOLDIER_PENS_I'               }
             ,{dataIndex    :'SCH_PENS_I'                   }
             ,{dataIndex    :'POST_PENS_I'                  }
             ,{dataIndex    :'MED_PREMINM_I'                }
             ,{dataIndex    :'HIRE_INSUR_I'                	}
             ,{dataIndex    :'HOUS_AMOUNT_I'                }
             ,{dataIndex    :'HOUS_AMOUNT_I_2'              }
             ,{dataIndex    :'MORTGAGE_RETURN_I_2'          }
             ,{dataIndex    :'MORTGAGE_RETURN_I'            }
             ,{dataIndex    :'MORTGAGE_RETURN_I_3'          }
             ,{dataIndex    :'MORTGAGE_RETURN_I_5'          }
             ,{dataIndex    :'MORTGAGE_RETURN_I_4'          }
             ,{dataIndex    :'MORTGAGE_RETURN_I_6'          }
             ,{dataIndex    :'MORTGAGE_RETURN_I_7'          }
             ,{dataIndex    :'MORTGAGE_RETURN_I_8'          }
             ,{dataIndex    :'MORTGAGE_RETURN_I_9'          }
             ,{dataIndex    :'PRIV_PENS_I'                  }
             ,{dataIndex    :'HOUS_BU_AMT'                  }
             ,{dataIndex    :'HOUS_BU_ADD_AMT'              }
             ,{dataIndex    :'HOUS_WORK_AMT'                }
             ,{dataIndex    :'HOUS_AMOUNT_I'                }
             ,{dataIndex    :'HOUS_AMOUNT_ADD_I'            }
             ,{dataIndex    :'CARD_DED_I'                   }
             ,{dataIndex    :'CARD_USE_I'                   }
             ,{dataIndex    :'CASH_USE_I'                   }
             ,{dataIndex    :'DEBIT_CARD_USE_I'             }
             ,{dataIndex    :'TRA_MARKET_USE_I'             }
             ,{dataIndex    :'TRAFFIC_USE_I'                }

             ,{dataIndex    :'COMP_PREMINUM'                }
             ,{dataIndex    :'COMP_PREMINUM_DED_I'          }
             ,{dataIndex    :'INVESTMENT_DED_I'             }
             ,{dataIndex    :'INVESTMENT_DED_I2'            }
             ,{dataIndex    :'INVESTMENT_DED_I3'            }
             ,{dataIndex    :'INVESTMENT_DED_I4'            }
             ,{dataIndex    :'STAFF_STOCK_DED_I'            }
             ,{dataIndex    :'EMPLOY_WORKER_DED_I'          }
             ,{dataIndex    :'NOT_AMOUNT_LOAN_DED_I'        }
             ,{dataIndex    :'LONG_INVEST_STOCK_DED_I'      }
             ,{dataIndex    :'INCOME_REDU_I'                }
             ,{dataIndex    :'YOUTH_EXEMP_RATE'             }
             ,{dataIndex    :'YOUTH_DED_I'                	}
             ,{dataIndex    :'YOUTH_DED_I_SUM'              }
             ,{dataIndex    :'SKILL_DED_I'                	}
             ,{dataIndex    :'TAXES_REDU_I'                	}
             ,{dataIndex    :'TAXES_REDU_I'            		}
             ,{dataIndex    :'CHILD_TAX_DED_I'              }
             ,{dataIndex    :'BRING_CHILD_DED_I'            }
             ,{dataIndex    :'BIRTH_ADOPT_I'                }

             ,{dataIndex    :'SCI_DEDUC_I'                  }
             ,{dataIndex    :'RETIRE_PENS_I'                }
             ,{dataIndex    :'PENS_I'                       }
             ,{dataIndex    :'ETC_INSUR_I'                  }
             ,{dataIndex    :'SCI_TAX_DED_I'                }
             ,{dataIndex    :'SCI_TAX_DED_I1'               }
             ,{dataIndex    :'RETIRE_TAX_DED_I'             }
             ,{dataIndex    :'RETIRE_TAX_DED_I1'            }
             ,{dataIndex    :'PENS_TAX_DED_I'               }
             ,{dataIndex    :'PENS_TAX_DED_I1'              }
             ,{dataIndex    :'ETC_INSUR_I'                  }
             ,{dataIndex    :'DEFORM_INSUR_I'               }
             ,{dataIndex    :'ETC_INSUR_TAX_DED_I'          }
             ,{dataIndex    :'DEFORM_INSUR_TAX_DED_I'       }
             ,{dataIndex    :'MED_DED_I'                    }
             ,{dataIndex    :'MY_MED_DED_I'                 }
             ,{dataIndex    :'SENIOR_MED_I'                 }
             ,{dataIndex    :'DEFORM_MED_I'                	}
             ,{dataIndex    :'SURGERY_MED_I'                }
             ,{dataIndex    :'MED_TOTAL_I'                  }
             ,{dataIndex    :'MED_TAX_DED_I'                }
             ,{dataIndex    :'MY_MED_TAX_DED_I'             }
             ,{dataIndex    :'SENIOR_MED_TAX_DED_I'         }
             ,{dataIndex    :'DEFORM_MED_TAX_DED_I'         }

             ,{dataIndex    :'SURGERY_MED_TAX_DED_I'        }
             ,{dataIndex    :'MED_TOTAL_TAX_DED_I'          }
             ,{dataIndex    :'EDUC_DED_I'                  	}
             ,{dataIndex    :'UNIV_EDUC_NUM'               	}
             ,{dataIndex    :'STUD_EDUC_NUM'               	}
             ,{dataIndex    :'KIND_EDU_NUM'                	}
             ,{dataIndex    :'PER_EDUC_DED_I'              	}
             ,{dataIndex    :'UNIV_EDUC_DED_I'             	}
             ,{dataIndex    :'STUD_EDUC_DED_I'             	}
             ,{dataIndex    :'KIND_EDUC_DED_I'             	}
             ,{dataIndex    :'DEFORM_EDUC_DED_I'           	}

             ,{dataIndex    :'FIELD_EDUC_DED_I'            	}
             ,{dataIndex    :'EDUC_TAX_DED_I'              	}
             ,{dataIndex    :'PER_EDUC_TAX_DED_I'          	}
             ,{dataIndex    :'UNIV_EDUC_TAX_DED_I'         	}
             ,{dataIndex    :'STUD_EDUC_TAX_DED_I'         	}
             ,{dataIndex    :'KIND_EDUC_TAX_DED_I'         	}
             ,{dataIndex    :'DEFORM_EDUC_TAX_DED_I'       	}

             ,{dataIndex    :'POLICY_INDED'                	}
             ,{dataIndex    :'POLICY_GIFT_I'               	}
             ,{dataIndex    :'LEGAL_GIFT_I_PREV'           	}
             ,{dataIndex    :'LEGAL_GIFT_I_PREV_14'        	}
             ,{dataIndex    :'LEGAL_GIFT_I'                	}
             ,{dataIndex    :'PRIV_GIFT_I_PREV'            	}
             ,{dataIndex    :'PRIV_GIFT_I'                 	}
             ,{dataIndex    :'PUBLIC_GIFT_I_PREV'          	}
             ,{dataIndex    :'PUBLIC_GIFT_I'               	}
             ,{dataIndex    :'STAFF_GIFT_I'                	}
             ,{dataIndex    :'APPOINT_GIFT_I_PREV'         	}
             ,{dataIndex    :'APPOINT_GIFT_I_PREV_14'      	}
             ,{dataIndex    :'APPOINT_GIFT_I'              	}
             ,{dataIndex    :'ASS_GIFT_I_PREV'             	}
             ,{dataIndex    :'ASS_GIFT_I_PREV_14'          	}
             ,{dataIndex    :'ASS_GIFT_I'                  	}

             ,{dataIndex    :'POLICY_INDED_DED_AMT'         }
             ,{dataIndex    :'POLICY_GIFT_DED_AMT'          }
             ,{dataIndex    :'LEGAL_DED_AMT'                }
             ,{dataIndex    :'STAFF_DED_AMT'                }
             ,{dataIndex    :'APPOINT_ASS_TAX_DED_AMT'      }
             ,{dataIndex    :'GIFT_DED_I'                   }
             ,{dataIndex    :'LEGAL_GIFT_DED_I'             }
             ,{dataIndex    :'PRIV_GIFT_DED_I'              }
             ,{dataIndex    :'PUBLIC_GIFT_DED_I'            }
             ,{dataIndex    :'STAFF_GIFT_DED_I'             }
             ,{dataIndex    :'APPOINT_GIFT_DED_I'           }
             ,{dataIndex    :'ASS_GIFT_DED_I'               }
             ,{dataIndex    :'GIFT_TAX_DED_I'               }
             ,{dataIndex    :'POLICY_INDED_TAX_DED_I'       }
             ,{dataIndex    :'POLICY_GIFT_TAX_DED_I'        }
             ,{dataIndex    :'LEGAL_GIFT_TAX_DED_I'         }
             ,{dataIndex    :'STAFF_GIFT_TAX_DED_I'         }
             ,{dataIndex    :'APPOINT_GIFT_TAX_DED_I'       }
             ,{dataIndex    :'ASS_GIFT_TAX_DED_I'           }

             ,{dataIndex    :'NAP_TAX_DED_I'                }
             ,{dataIndex    :'HOUS_INTER_I'                 }
             ,{dataIndex    :'OUTSIDE_INCOME_I'             }
             ,{dataIndex    :'MON_RENT_I'                   }
             ,{dataIndex    :'TAB1_DED_AMT'                 }
             ,{dataIndex    :'TAB2_DED_AMT'                 }
             ,{dataIndex    :'TAB3_DED_AMT'                 }
             ,{dataIndex    :'TAB4_DED_AMT'                 }
             ,{dataIndex    :'TAB5_DED_AMT'                 }
             ,{dataIndex    :'DED_INCOME_I'                 }
             ,{dataIndex    :'DED_INCOME_I1'                }
             ,{dataIndex    :'DED_INCOME_I2'                }
             ,{dataIndex    :'TAB6_DED_AMT'                 }
             ,{dataIndex    :'TAB7_DED_AMT'                 }
             ,{dataIndex    :'TAB8_DED_AMT'                 }
             ,{dataIndex    :'TAB9_DED_AMT'                 }
             ,{dataIndex    :'OVER_INCOME_DED_LMT'          }
             ,{dataIndex    :'TAX_STD_I'                    }
             ,{dataIndex    :'TAX_STD_I1'                   }
             ,{dataIndex    :'TAX_STD_I2'                   }
             ,{dataIndex    :'COMP_TAX_I'                   }
             ,{dataIndex    :'COMP_TAX_I1'                  }
             ,{dataIndex    :'COMP_TAX_I1'                  }

             ,{dataIndex    :'TAB10_DED_AMT'                }
             ,{dataIndex    :'TAB11_DED_AMT'                }
             ,{dataIndex    :'TAB12_DED_AMT'                }
             ,{dataIndex    :'TAB13_DED_AMT'                }
             ,{dataIndex    :'TAB14_DED_AMT'                }
             ,{dataIndex    :'TAB15_DED_AMT'                }
             ,{dataIndex    :'TAB16_DED_AMT'                }
             ,{dataIndex    :'STD_TAX_DED_I'                }
             ,{dataIndex    :'TAB17_DED_AMT'                }
             ,{dataIndex    :'DEF_IN_TAX_I'                 }
             ,{dataIndex    :'DEF_LOCAL_TAX_I'              }
             ,{dataIndex    :'DEF_SP_TAX_I'                 }
             ,{dataIndex    :'DEF_TAX_SUM'                  }
             ,{dataIndex    :'NOW_IN_TAX_I'                 }
             ,{dataIndex    :'NOW_LOCAL_TAX_I'              }
             ,{dataIndex    :'NOW_SP_TAX_I'                 }
             ,{dataIndex    :'NOW_TAX_SUM'                  }
             ,{dataIndex    :'PRE_IN_TAX_I'                 }
             ,{dataIndex    :'PRE_LOCAL_TAX_I'              }
             ,{dataIndex    :'PRE_SP_TAX_I'                 }
             ,{dataIndex    :'PRE_TAX_SUM'                  }

             ,{dataIndex    :'NAP_IN_TAX_I'                 }
             ,{dataIndex    :'NAP_LOCAL_TAX_I'              }
             ,{dataIndex    :'NAP_SP_TAX_I'                 }
             ,{dataIndex    :'NAP_TAX_SUM'                  }
             ,{dataIndex    :'PAID_IN_TAX_SUM'              }
             ,{dataIndex    :'PAID_LOCAL_TAX_SUM'           }
             ,{dataIndex    :'PAID_SP_TAX_SUM'              }
             ,{dataIndex    :'PAID_TAX_SUM'                 }
             ,{dataIndex    :'IN_TAX_I'                     }
             ,{dataIndex    :'LOCAL_TAX_I'                  }
             ,{dataIndex    :'SP_TAX_I'                     }
             ,{dataIndex    :'SP_TAX_I'                     }

        ]

    })

    Unilite.Main( {
        borderItems: [{
             region:'center',
             layout: 'border',
             border: false,
             items:[
                   panelResult, tab, northForm, southForm
                   //, grid
             ]
          },
          panelSearch
          ],
        id  : 'had618ukrApp',
        fnInitBinding : function() {
            panelSearch.setValue('YEAR_YYYY', YEAR_YYYY);
            panelSearch.setValue('PERSON_NUMB', PERSON_NUMB);
            panelSearch.setValue('NAME', PERSON_NAME);

            panelResult.setValue('YEAR_YYYY', YEAR_YYYY);
            panelResult.setValue('PERSON_NUMB', PERSON_NUMB);
            panelResult.setValue('NAME', PERSON_NAME);
            /*
             Case UCase("individual")
            Call goCnn.SetFrameButtonInfo("QU1:NI0:NW0:DL0:SV0:DA0:SF0:PR0:PV0:CT0:DP0:DN0:CQ0")
        Case } else {
            Call goCnn.SetFrameButtonInfo("QU1:NI1:NW0:DL0:SV0:DA0:SF0:PR0:PV0:CT0:DP1:DN1:CQ0")
             * */
            UniAppManager.setToolbarButtons([ 'newData', 'save', 'detail', 'delete'], false);
            UniAppManager.setToolbarButtons([ 'prev', 'next'], true);
            if(USE_AUTH == 'Y')    {
                if(AUTH_YN == 'N')    {
                    panelResult.setReadOnly(true);
                    panelSearch.setReadOnly(true);
                    UniAppManager.setToolbarButtons([ 'reset', 'newData', 'save', 'detail', 'delete', 'prev', 'next'], false);
                    if(PERSON_NUMB == '')    {
                        alert(Msg.fsbMsgH0362);
                        UniAppManager.setToolbarButtons([ 'query'], false);
                    }else {
                    	this.onQueryButtonDown();
                    }
                }
            }
        },
        onQueryButtonDown : function()    {
            Ext.getBody().mask('Loading...');
            direct600Store.loadStoreRecords();
            direct400Store.loadStoreRecords();
        },
        onResetButtonDown: function() {
        	//if(USE_AUTH == 'Y')    {
                if(AUTH_YN != 'N')    {

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

 			       	panelResult.getField("PERSON_NUMB").setReadOnly(false);
 			       	panelResult.getField("NAME").setReadOnly(false);
 			       	panelSearch.getField("PERSON_NUMB").setReadOnly(false);
 			       	panelSearch.getField("NAME").setReadOnly(false);

                }
        	//}
        },
        onNewDataButtonDown: function() {
        },
        onDeleteDataButtonDown: function() {
			if(!confirm('<t:message code="system.message.human.message009" default="자료를 삭제 합니다. 삭제 하시겠습니까?"/>'))
				return;

        	had618ukrService.deleteAll(panelSearch.getValues(), function(responseText, response){
                if(responseText){
                    UniAppManager.app.onQueryButtonDown();
                }
            })
        },
        onSaveDataButtonDown: function() {
            direct600Store.saveStore();
            direct400Store.saveStore();
        },
        onPrevDataButtonDown:  function()    {
            had618ukrService.selectPrev(panelSearch.getValues(), function(responseText, response){
                if(responseText){
                    panelSearch.setValue('PERSON_NUMB', responseText.PREV_PERSON_NUMB);
                    panelSearch.setValue('NAME', responseText.NAME);
                    panelResult.setValue('PERSON_NUMB', responseText.PREV_PERSON_NUMB);
                    panelResult.setValue('NAME', responseText.NAME);
                    UniAppManager.app.onQueryButtonDown();
                }
            })

        },
        onNextDataButtonDown:  function()    {
            had618ukrService.selectNext(panelSearch.getValues(), function(responseText, response){
                if(responseText){
                    panelSearch.setValue('PERSON_NUMB', responseText.NEXT_PERSON_NUMB);
                    panelSearch.setValue('NAME', responseText.NAME);
                    panelResult.setValue('PERSON_NUMB', responseText.NEXT_PERSON_NUMB);
                    panelResult.setValue('NAME', responseText.NAME);
                    UniAppManager.app.onQueryButtonDown();
                }
            })
        },
        rejectSave: function()    {
            direct400Store.rejectChanges();
            direct600Store.rejectChanges();
            UniAppManager.setToolbarButtons('save',false);
        },
        confirmSaveData: function()    {
                if(direct400Store.isDirty() || direct600Store.isDirty())    {
                    if(confirm(Msg.sMB061))    {
                        this.onSaveDataButtonDown();
                    } else {
                        //this.rejectSave();
                    }
                }

        },
        fnCollectData:function(cType){
               var record = direct400Store.getAt(0);
               var infoForm400 = Ext.getCmp('infoForm400');
               var paramData = {
                'YEAR_YYYY'        : panelSearch.getValue('YEAR_YYYY'),
                'PERSON_NUMB'    : panelSearch.getValue('PERSON_NUMB'),
                'FOREIGN_NUM'    : panelSearch.getValue('FOREIGN_NUM'),

                'FORE_SINGLE_YN' : record.data["FORE_SINGLE_YN"],
                'FOREIGN_DISPATCH_YN' : record.data["FOREIGN_DISPATCH_YN"],
                'HALFWAY_TYPE' : record.data["HALFWAY_TYPE"]
               };
               //alert(infoForm400.getValue('HALFWAY_TYPE'));
               Ext.getBody().mask('Loading');
               had618ukrService.selectSummaryData(paramData, function(responseText, response){
                   console.log("responseText", responseText);
                   if(responseText && responseText.length > 0) UniAppManager.app.fnDisplayData1(responseText[0], "REFER");
                   Ext.getBody().unmask();
               })
        },
        fnDisplayData1: function(record, sCollectType) {
            this.fnSetClear1(sCollectType);

            var record400 = direct400Store.getAt(0);
            //var record600 = direct600Store.getAt(0);
            var infoForm400 = Ext.getCmp("infoForm400");

            //조회조건
            panelSearch.setValue("YEAR_YYYY"      , record["YEAR_YYYY"])   ;        //정산년도
            panelSearch.setValue("NAME"           , record["NAME"])        ;        //성명
            panelSearch.setValue("PERSON_NUMB"    , record["PERSON_NUMB"]) ;        //사번

            panelSearch.setValue("DEPT_NAME"      , record["DEPT_NAME"])   ;        //[숨김]부서
            panelSearch.setValue("POST_CODE_NAME" , record["POST_NAME"])   ;        //[숨김]직위
            panelSearch.setValue("REPRE_NUM"      , record["REPRE_NUM"])   ;        //[숨김]주민번호
            panelSearch.setValue("FOREIGN_NUM"    , record["FOREIGN_NUM"]) ;        //[숨김]외국인번호
            panelSearch.setValue("NATION_CODE"    , record["NATION_CODE"]) ;        //[숨김]국가코드
            panelSearch.setValue("LIVE_GUBUN"     , record["LIVE_GUBUN"])  ;        //[숨김]거주여부

            //일반정보
            record400.set('HOUSEHOLDER_YN',record["HOUSEHOLDER_YN"]=="1"? true:false )        ;        //세대주여부 1:세대주,2:세대주아님

            if(sCollectType=="QUERY" || sCollectType=="REFER" )    {
                record400.set("NONTAX_FR", record["NONTAX_FR"])  ;        //[입력]세액감면기간(Fr)
                record400.set("NONTAX_TO", record["NONTAX_TO"])  ;        //[입력]세액감면기간(To)
            }

            //var foreSingleYn = infoForm400.getField("FORE_SINGLE_YN");
            //var foreDispatchYn = infoForm400.getField("FOREIGN_DISPATCH_YN");
            //var halfwayType = infoForm400.getField("HALFWAY_TYPE");

            //infoForm400.setValue("HALFWAY_TYPE"    ,record["HALFWAY_TYPE"]);
            //infoForm400.setValue("HALFWAY_TYPE"    ,record["HALFWAY_TYPE"]=="Y"? true:false);
            //console.log("[[record[HALFWAY_TYPE]]" + record["HALFWAY_TYPE"]);
            //record400.set("HALFWAY_TYPE", record["HALFWAY_TYPE"]);                   //중도퇴사자정산
            record400.set("HALFWAY_TYPE", record["HALFWAY_TYPE"]=="Y"? true:false);

            if(record["FOREIGN_NUM"] != "" )  {                                                                        //외국인단일세율(외국인여부)
                //foreSingleYn.setDisabled(false);
            } else {
                //foreSingleYn.setDisabled(true);
                record400.set("FORE_SINGLE_YN", false);
            }

            record400.set("FOREIGN_DISPATCH_YN", record["FOREIGN_DISPATCH_YN"]=="Y"? true:false);    //외국법인소속 파견근로자 여부
            //record400.set("FORE_SINGLE_YN", record["FORE_SINGLE_YN"]=="Y"? true:false);                //외국인단일세율(저장값)


            //기본사항
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "INCOME_DED" ) {
                record400.set("INCOME_SUPP_TOTAL_I"        , record["INCOME_SUPP_TOTAL_I"]);    //총급여액

                record400.set("NOW_PAY_AMT"                , record["NOW_PAY_AMT"])        ;    //[계산]주(현)총급여액

                record400.set("NOW_PAY_TOT_I"            , record["NOW_PAY_TOT_I"])      ;    //[숨김]주(현)급여총액
                record400.set("NOW_BONUS_TOTAL_I"        , record["NOW_BONUS_TOTAL_I"])  ;    //[숨김]주(현)상여총액
                record400.set("NOW_ADD_BONUS_I"            , record["NOW_ADD_BONUS_I"])    ;    //[숨김]주(현)인정상여금액
                record400.set("NOW_STOCK_PROFIT_I"        , record["NOW_STOCK_PROFIT_I"]) ;    //[숨김]주(현)주식매수선택행사이익
                record400.set("NOW_OWNER_STOCK_DRAW_I"    , Unilite.nvl(record["NOW_OWNER_STOCK_DRAW_I"],0));    //[숨김]주(현)우리사주조합인출금
                record400.set("NOW_OF_RETR_OVER_I"      , record["NOW_OF_RETR_OVER_I"]) ;    //[숨김]주(현)임원퇴직한도초과액

                record400.set("OLD_PAY_AMT"                , record["OLD_PAY_AMT"])        ;    //[계산]종(전)총급여액

                record400.set("OLD_PAY_TOT_I"            , record["OLD_PAY_TOT_I"])      ;    //[숨김]종(전)급여총액
                record400.set("OLD_BONUS_TOTAL_I"        , record["OLD_BONUS_TOTAL_I"])  ;    //[숨김]종(전)상여총액
                record400.set("OLD_ADD_BONUS_I"            , record["OLD_ADD_BONUS_I"])    ;    //[숨김]종(전)인정상여금액
                record400.set("OLD_STOCK_PROFIT_I"        , record["OLD_STOCK_PROFIT_I"]) ;    //[숨김]종(전)주식매수선택행사이익
                record400.set("OLD_OWNER_STOCK_DRAW_I"    , record["OLD_OWNER_STOCK_DRAW_I"]);    //[숨김]종(전)우리사주조합인출금
                record400.set("OLD_OF_RETR_OVER_I"      , record["OLD_OF_RETR_OVER_I"]) ;    //[숨김]종(전)임원퇴직한도초과액

                record400.set("NAP_PAY_AMT"                , record["NAP_PAY_AMT"])        ;    //[계산](납)총급여액

                record400.set("NAP_PAY_TOT_I"            , record["NAP_PAY_TOT_I"])      ;    //[숨김](납)급여총액
                record400.set("NAP_BONUS_TOTAL_I"        , record["NAP_BONUS_TOTAL_I"])  ;    //[숨김](납)상여총액

                record400.set("INCOME_DED_I"            , record["INCOME_DED_I"])       ;    //근로소득공제
                record400.set("EARN_INCOME_I"            , record["EARN_INCOME_I"])      ;    //근로소득금액
            }

            //기본공제/추가공제
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "PERSONAL_DED") {
                    record400.set("PER_DED_I"            , Unilite.nvl(record["PER_DED_I"]             ,0));    //본인공제

                    record400.set("SPOUSE"            , record["SPOUSE"]);            //배우자유무

                    record400.set("SUPP_NUM"            , Unilite.nvl(record["SUPP_NUM"]              ,0));    //부양자
                    record400.set("SUPP_NUM_1"            , Unilite.nvl(record["SUPP_NUM_1"]            ,0));    //부양자:직계존속
                    record400.set("SUPP_NUM_4"            , Unilite.nvl(record["SUPP_NUM_4"]            ,0));    //부양자:직계비속-자녀입양자
                    record400.set("SUPP_NUM_5"            , Unilite.nvl(record["SUPP_NUM_5"]            ,0));    //부양자:직계비속-그외직계비속
                    record400.set("SUPP_NUM_6"            , Unilite.nvl(record["SUPP_NUM_6"]            ,0));    //부양자:형제자매
                    record400.set("SUPP_NUM_7"            , Unilite.nvl(record["SUPP_NUM_7"]            ,0));    //부양자:수급자
                    record400.set("SUPP_NUM_8"            , Unilite.nvl(record["SUPP_NUM_8"]            ,0));    //부양자:위탁아동

                    record400.set("AGED_NUM"            , Unilite.nvl(record["AGED_NUM"]              ,0));    //경로자
                    record400.set("DEFORM_NUM"            , Unilite.nvl(record["DEFORM_NUM"]            ,0));    //장애자
                    record400.set("MANY_CHILD_NUM"        , Unilite.nvl(record["MANY_CHILD_NUM"]        ,0));    //자녀수
                    record400.set("BRING_CHILD_NUM"        , Unilite.nvl(record["BRING_CHILD_NUM"]       ,0));    //자녀야육수
                    record400.set("BIRTH_ADOPT_NUM"        , Unilite.nvl(record["BIRTH_ADOPT_NUM"]       ,0));    //출산입양수

                    record400.set("WOMAN"            , record["WOMAN"]);                        //부녀자
                    record400.set("ONE_PARENT"            , record["ONE_PARENT"]);            ///한부모
                    record400.set("BIRTH_ADOPT_NUM1"            , record["BIRTH_ADOPT_NUM1"]);            //출산입양첫째
                    record400.set("BIRTH_ADOPT_NUM2"            , record["BIRTH_ADOPT_NUM2"]);            //출산입양둘째
                    record400.set("BIRTH_ADOPT_NUM3"            , record["BIRTH_ADOPT_NUM3"]);            //출산입양셋째

            }

            //연금보험료공제
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "INCOME_DED" ) {
                record400.set("ANU_I"                , Unilite.nvl(record["ANU_I"]                 ,0));    //국민연금보험료
            }

            if(sCollectType == "QUERY") {
                record400.set("ANU_ADD_I"            , Unilite.nvl(record["ANU_ADD_I"]             ,0));    //[입력]국민연금보험료(개별입력)
                record400.set("PUBLIC_PENS_I"        , Unilite.nvl(record["PUBLIC_PENS_I"]         ,0));    //[입력]공무원연금
                record400.set("SOLDIER_PENS_I"        , Unilite.nvl(record["SOLDIER_PENS_I"]        ,0));    //[입력]군인연금
                record400.set("SCH_PENS_I"            , Unilite.nvl(record["SCH_PENS_I"]            ,0));    //[입력]사립학교직원연금
                record400.set("POST_PENS_I"            , Unilite.nvl(record["POST_PENS_I"]           ,0));    //[입력]별정우체국연금
            }

            //특별공제-보험료
            if(sCollectType ==  "QUERY" || sCollectType == "REFER" || sCollectType == "INCOME_DED") {
                record400.set("MED_PREMINM_I"        , Unilite.nvl(record["MED_PREMINM_I"]         ,0));    //건강보험료
                record400.set("MED_PREMINM_ADD_I"    , Unilite.nvl(record["MED_PREMINM_ADD_I"]     ,0));    //건강보험료
                record400.set("HIRE_INSUR_I"        , Unilite.nvl(record["HIRE_INSUR_I"]          ,0));    //고용보험료
                record400.set("HIRE_INSUR_ADD_I"    , Unilite.nvl(record["HIRE_INSUR_ADD_I"]      ,0));    //고용보험료
            }

            if(sCollectType == "QUERY" ) {
                record400.set("MED_PREMINM_ADD_I"    , Unilite.nvl(record["MED_PREMINM_ADD_I"]     ,0));    //[입력]건강보험료(개별입력)
            }

            //특별공제-주택마련
            if(sCollectType == "QUERY" || sCollectType == "REFER") {
                    record400.set("HOUS_AMOUNT_TOT_I"        , Unilite.nvl(record["HOUS_AMOUNT_TOT_I"]     ,0));    //[입력]원리금상환액(대출기관)
                    record400.set("HOUS_AMOUNT_TOT_I_2"        , Unilite.nvl(record["HOUS_AMOUNT_TOT_I_2"]   ,0));    //[입력]원리금상환액(거주자)
                    record400.set("HOUS_AMOUNT_INTER_I_2"    , Unilite.nvl(record["HOUS_AMOUNT_INTER_I_2"] ,0));    //[입력]주택자금이자상환액(15년미만)
                    record400.set("HOUS_AMOUNT_INTER_I"        , Unilite.nvl(record["HOUS_AMOUNT_INTER_I"]   ,0));    //[입력]주택자금이자상환액(15년~29년)
                    record400.set("HOUS_AMOUNT_INTER_I_3"    , Unilite.nvl(record["HOUS_AMOUNT_INTER_I_3"] ,0));    //[입력]주택자금이자상환액(30년이상)
                    record400.set("FIXED_RATE_LOAN"            , Unilite.nvl(record["FIXED_RATE_LOAN"]       ,0));    //[입력]고정금리비거치상환대출
                    record400.set("ETC_LOAN"                , Unilite.nvl(record["ETC_LOAN"]              ,0));    //[입력]기타대출
                    record400.set("HOUS_AMOUNT_INTER_I_6"    , Unilite.nvl(record["HOUS_AMOUNT_INTER_I_6"]   ,0));    //[입력]15년이상(고정금리이면서 비거치상환)
                    record400.set("HOUS_AMOUNT_INTER_I_7"    , Unilite.nvl(record["HOUS_AMOUNT_INTER_I_7"]   ,0));    //[입력]15년이상(고정금리이거나 비거치상환)
                    record400.set("HOUS_AMOUNT_INTER_I_8"    , Unilite.nvl(record["HOUS_AMOUNT_INTER_I_8"]   ,0));    //[입력]15년이상(그밖의대출)
                    record400.set("HOUS_AMOUNT_INTER_I_9"    , Unilite.nvl(record["HOUS_AMOUNT_INTER_I_9"]   ,0));    //[입력]10년이상(고정금리이거나 비거치상환)
            }

            //특별공제-주택마련
            if(sCollectType == "QUERY" || sCollectType == "REFER") {
                    record400.set("HOUS_AMOUNT_TOT_I_2"        , Unilite.nvl(record["HOUS_AMOUNT_TOT_I_2"]   ,0));    //[입력]원리금상환액(거주자)
            }

            //그밖의소득공제-연금저축
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType ==  "PRIV_PENS_DED" ) {
                record400.set("PRIV_PENS_I"            , Unilite.nvl(record["PRIV_PENS_I"]           ,0));    //개인연금저축소득공제
            }

            //그밖의소득공제-주택마련
            if(sCollectType ==  "QUERY" || sCollectType ==  "REFER" || sCollectType ==  "HOUS_BU_DED") {
                record400.set("HOUS_BU_AMT"            , Unilite.nvl(record["HOUS_BU_AMT"]           ,0));    //청약저축
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "HOUS_BU_ADD_DED" ) {
                record400.set("HOUS_BU_ADD_AMT"        , Unilite.nvl(record["HOUS_BU_ADD_AMT"]       ,0));    //청약저축(120만원한도)
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "HOUS_WORK_DED" ) {
                record400.set("HOUS_WORK_AMT"        , Unilite.nvl(record["HOUS_WORK_AMT"]         ,0));    //근로자주택마련저축
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "HOUS_AMOUNT_DED" ) {
                record400.set("HOUS_AMOUNT_I"        , Unilite.nvl(record["HOUS_AMOUNT_I"]         ,0));    //주택청약종합저축
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "HOUS_AMOUNT_ADD_DED" ) {
                record400.set("HOUS_AMOUNT_ADD_I"        , Unilite.nvl(record["HOUS_AMOUNT_ADD_I"]     ,0));    //주택청약종합저축(120만원한도)
            }

            //그밖의소득공제-신용카드등
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "CREDIT_ETC_DED" ) {
                record400.set("CARD_USE_I"            , Unilite.nvl(record["CARD_USE_I"]            ,0));    //신용카드사용액
                record400.set("CASH_USE_I"            , Unilite.nvl(record["CASH_USE_I"]            ,0));    //현금영수증사용액
                record400.set("DEBIT_CARD_USE_I"    , Unilite.nvl(record["DEBIT_CARD_USE_I"]      ,0));    //직불카드사용액
                record400.set("TRA_MARKET_USE_I"    , Unilite.nvl(record["TRA_MARKET_USE_I"]      ,0));    //전통시장사용액
                record400.set("TRAFFIC_USE_I"        , Unilite.nvl(record["TRAFFIC_USE_I"]         ,0));    //대중교통이용분
                record400.set("BOOK_CONCERT_USE_I"   , Unilite.nvl(record["BOOK_CONCERT_USE_I"]         ,0));    //대중교통이용분
            }



            //그밖의소득공제-기타
            if(sCollectType == "QUERY") {
                record400.set("COMP_PREMINUM"    , record["COMP_PREMINUM"]=="1" ? true:false);

                record400.set("COMP_PREMINUM_I"        , Unilite.nvl(record["COMP_PREMINUM_I"]       ,0));    //[입력]소기업소상공인공제부금
                record400.set("INVESTMENT_I"        , Unilite.nvl(record["INVESTMENT_I"]          ,0));    //[입력]투자조합출자(2012년이전 10%해당분)
                record400.set("INVESTMENT_I3"        , Unilite.nvl(record["INVESTMENT_I3"]         ,0));    //[입력]투자조합출자(2012년 20%해당분)
                record400.set("INVESTMENT_I4"        , Unilite.nvl(record["INVESTMENT_I4"]         ,0));    //[입력]투자조합출자(2013년 10%해당분)
                record400.set("INVESTMENT_I2"        , Unilite.nvl(record["INVESTMENT_I2"]         ,0));    //[입력]투자조합출자(2013년 30%해당분)
                record400.set("INVESTMENT_I5"        , Unilite.nvl(record["INVESTMENT_I5"]         ,0));    //[입력]투자조합출자(2014년 10%해당분)
                record400.set("INVESTMENT_I6"        , Unilite.nvl(record["INVESTMENT_I6"]         ,0));    //[입력]투자조합출자(2014년 50%해당분)
                record400.set("INVESTMENT_I7"        , Unilite.nvl(record["INVESTMENT_I7"]         ,0));    //[입력]투자조합출자(2014년 30%해당분)
                record400.set("INVESTMENT_I8"        , Unilite.nvl(record["INVESTMENT_I8"]         ,0));    //[입력]투자조합출자(2015년 10%해당분)
                record400.set("INVESTMENT_I9"        , Unilite.nvl(record["INVESTMENT_I9"]         ,0));    //[입력]투자조합출자(2015년100%해당분)
                record400.set("INVESTMENT_I10"        , Unilite.nvl(record["INVESTMENT_I10"]        ,0));    //[입력]투자조합출자(2015년 50%해당분)
                record400.set("INVESTMENT_I11"        , Unilite.nvl(record["INVESTMENT_I11"]        ,0));    //[입력]투자조합출자(2015년 30%해당분)
                record400.set("STAFF_STOCK_I"        , Unilite.nvl(record["STAFF_STOCK_I"]         ,0));    //[입력]우리사주조합출연
                record400.set("STAFF_GIFT_I",    0)                                                        //우리사주조합출연기부금의 소득공제는 없음

                record400.set("EMPLOY_WORKER_I"        , Unilite.nvl(record["EMPLOY_WORKER_I"]       ,0));    //[입력]고용유지중소기업근로자소득공제
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "LONGINVEST_DED") {
                record400.set("LONG_INVEST_STOCK_I"    , Unilite.nvl(record["LONG_INVEST_STOCK_I"]   ,0));    //장기집합투자증권저축
            }

            //세액감면
            if(sCollectType == "QUERY") {
                record400.set("INCOME_REDU_I"        , Unilite.nvl(record["INCOME_REDU_I"]         ,0));    //[입력]소득세법
                record400.set("YOUTH_DED_I"          ,0);                                                    //중소기업취업청년(100%)    (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("YOUTH_DED_I3"         ,0);                                                    //중소기업취업청년(70%)    (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("YOUTH_DED_I2"         ,0);                                                    //중소기업취업청년(50%)    (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("SKILL_DED_I"          ,0);                                                    //외국인기술공제            (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("TAXES_REDU_I"         , Unilite.nvl(record["TAXES_REDU_I"]          ,0));    //[입력]조세조약
            }

            //세액공제-근로소득/자녀
            if(sCollectType == "QUERY") {
                record400.set("IN_TAX_DED_I"         ,0);                                                            //근로소득세액공제        (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("CHILD_TAX_DED_I"      ,0);                                                            //자녀세액공제            (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("BRING_CHILD_DED_I"    ,0);                                                            //자녀양육공제            (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("BIRTH_ADOPT_I"        ,0);                                                            //출산입양공제            (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
            }

            //세액공제-연금계좌
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "SCI_DED") {
                record400.set("SCI_DEDUC_I"            , Unilite.nvl(record["SCI_DEDUC_I"]           ,0));    //과학기술인공제
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "RETIRE_PENS") {
                record400.set("RETIRE_PENS_I"        , Unilite.nvl(record["RETIRE_PENS_I"]         ,0));    //근로자퇴직급여보장법
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "PENS_DED") {
                record400.set("PENS_I"                , Unilite.nvl(record["PENS_I"]                ,0));    //연금저축소득공제
            }

            //특별세액공제-보장성보험
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "ETC_INSUR" || sCollectType == "PERSONAL_DED") {
                record400.set("ETC_INSUR_I"            , Unilite.nvl(record["ETC_INSUR_I"]           ,0));    //보장성보험
                record400.set("DEFORM_INSUR_I"        , Unilite.nvl(record["DEFORM_INSUR_I"]        ,0));    //장애인전용보장성보험
            }

            //특별세액공제-의료비
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "MEDICAL_DED" || sCollectType == "INCOME_DED") {
                record400.set("MY_MED_DED_I"        , Unilite.nvl(record["MY_MED_DED_I"]          ,0));    //본인의료비
                record400.set("SENIOR_MED_I"        , Unilite.nvl(record["SENIOR_MED_I"]          ,0));    //경로의료비
                record400.set("DEFORM_MED_I"        , Unilite.nvl(record["DEFORM_MED_I"]          ,0));    //장애의료비
                record400.set("SURGERY_MED_I"       , Unilite.nvl(record["SURGERY_MED_I"]         ,0));    //난임시술비
                record400.set("SERIOUS_SICK_MED_I"  , Unilite.nvl(record["SERIOUS_SICK_MED_I"]    ,0));    //건보산정특례자의료비
                record400.set("BASE_MED_I"          , Unilite.nvl(record["BASE_MED_I"]            ,0));    //본인, 65세이상, 장애인, 건보
                record400.set("MED_TOTAL_I"         , Unilite.nvl(record["MED_TOTAL_I"]           ,0));    //그밖의 공제대상자 의료비
            }

            //특별세액공제-교육비
            if(sCollectType ==  "QUERY" || sCollectType == "REFER" || sCollectType == "EDUCTION_DED") {
                record400.set("PER_EDUC_I"            , Unilite.nvl(record["PER_EDUC_I"]            ,0));    //본인교육비
                record400.set("UNIV_EDUC_NUM"        , Unilite.nvl(record["UNIV_EDUC_NUM"]         ,0));    //대학교자녀수
                record400.set("UNIV_EDUC_I"            , Unilite.nvl(record["UNIV_EDUC_I"]           ,0));    //대학교교육비
                record400.set("STUD_EDUC_NUM"        , Unilite.nvl(record["STUD_EDUC_NUM"]         ,0));    //초중고자녀수
                record400.set("STUD_EDUC_I"            , Unilite.nvl(record["STUD_EDUC_I"]           ,0));    //초중고교육비
                record400.set("KIND_EDU_NUM"        , Unilite.nvl(record["KIND_EDU_NUM"]          ,0));    //유치원자녀수
                record400.set("KIND_EDUC_I"            , Unilite.nvl(record["KIND_EDUC_I"]           ,0));    //유치원교육비
                record400.set("DEFORM_EDUC_NUM"        , Unilite.nvl(record["DEFORM_EDUC_NUM"]       ,0));    //[숨김]장애인수
                record400.set("DEFORM_EDUC_I"        , Unilite.nvl(record["DEFORM_EDUC_I"]         ,0));    //장애인특수교육비
                record400.set("FIELD_EDUC_I"        , Unilite.nvl(record["FIELD_EDUC_I"]         ,0));    //체험학습비

                record400.set("PER_EDUC_DED_I"        , Unilite.nvl(record["PER_EDUC_DED_I"]        ,0));    //[세액계산항목]본인교육비공제
                record400.set("UNIV_EDUC_DED_I"        , Unilite.nvl(record["UNIV_EDUC_DED_I"]       ,0));    //[세액계산항목]대학교교육비공제
                record400.set("STUD_EDUC_DED_I"        , Unilite.nvl(record["STUD_EDUC_DED_I"]       ,0));    //[세액계산항목]초중고교육비공제
                record400.set("KIND_EDUC_DED_I"        , Unilite.nvl(record["KIND_EDUC_DED_I"]       ,0));    //[세액계산항목]유치원교육비공제
                record400.set("DEFORM_EDUC_DED_I"    , Unilite.nvl(record["DEFORM_EDUC_DED_I"]     ,0));    //[세액계산항목]장애인특수교육비공제
                record400.set("FIELD_EDUC_DED_I"    , Unilite.nvl(record["FIELD_EDUC_DED_I"]     ,0));    //[세액계산항목]장애인특수교육비공제
            }

            //특별공제-기부금
            if(sCollectType ==  "QUERY" || sCollectType == "REFER" || sCollectType == "CONTRIBUTION_DED") {
                record400.set("POLICY_INDED"        , Unilite.nvl(record["POLICY_INDED"]          ,0));    //정치자금기부금(10만원이하)
                record400.set("POLICY_GIFT_I"        , Unilite.nvl(record["POLICY_GIFT_I"]         ,0));    //정치자금기부금(10만원초과)
                record400.set("LEGAL_GIFT_I_PREV"    , Unilite.nvl(record["LEGAL_GIFT_I_PREV"]     ,0));    //법정기부금(전년도이월액)-2013
                record400.set("LEGAL_GIFT_I_PREV_14", Unilite.nvl(record["LEGAL_GIFT_I_PREV_14"]  ,0));    //법정기부금(전년도이월액)-2014
                record400.set("LEGAL_GIFT_I"        , Unilite.nvl(record["LEGAL_GIFT_I"]          ,0));    //법정기부금
                record400.set("PRIV_GIFT_I_PREV"    , Unilite.nvl(record["PRIV_GIFT_I_PREV"]      ,0));    //특례기부금(전년도이월액)
                record400.set("PRIV_GIFT_I"            , Unilite.nvl(record["PRIV_GIFT_I"]           ,0));    //특례기부금
                record400.set("PUBLIC_GIFT_I_PREV"    , Unilite.nvl(record["PUBLIC_GIFT_I_PREV"]    ,0));    //공익법인신탁기부금(전년도이월액)
                record400.set("PUBLIC_GIFT_I"        , Unilite.nvl(record["PUBLIC_GIFT_I"]         ,0));    //공익법인신탁기부금
                record400.set("STAFF_GIFT_I"        , Unilite.nvl(record["STAFF_GIFT_I"]          ,0));    //우리사주기부금
                record400.set("APPOINT_GIFT_I_PREV"    , Unilite.nvl(record["APPOINT_GIFT_I_PREV"]   ,0));    //지정기부금(전년도이월액)-2013
                record400.set("APPOINT_GIFT_I_PREV_14", Unilite.nvl(record["APPOINT_GIFT_I_PREV_14"],0));    //지정기부금(전년도이월액)-2014
                record400.set("APPOINT_GIFT_I"        , Unilite.nvl(record["APPOINT_GIFT_I"]        ,0));    //지정기부금
                record400.set("ASS_GIFT_I_PREV"        , Unilite.nvl(record["ASS_GIFT_I_PREV"]       ,0));    //종교단체기부금(전년도이월액)-2013
                record400.set("ASS_GIFT_I_PREV_14"    , Unilite.nvl(record["ASS_GIFT_I_PREV_14"]    ,0));    //종교단체기부금(전년도이월액)-2014
                record400.set("ASS_GIFT_I"            , Unilite.nvl(record["ASS_GIFT_I"]            ,0));    //종교단체기부금
            }

            //세액공제-기타
            if(sCollectType == "QUERY") {
                record400.set("P3_TAX_DED_I"        , Unilite.nvl(record["P3_TAX_DED_I"]          ,0));    //[입력]납세조합세액
                record400.set("HOUS_INTER_I"        , Unilite.nvl(record["HOUS_INTER_I"]         ,0));    //[입력]주택자금상환액
                record400.set("FORE_INCOME_I"        , Unilite.nvl(record["FORE_INCOME_I"]         ,0));    //[입력]외국납부소득금액
                record400.set("FORE_TAX_I"            , Unilite.nvl(record["FORE_TAX_I"]            ,0));    //[입력]외국납부세액
            }

            if(sCollectType ==  "QUERY" || sCollectType == "REFER" || sCollectType == "RENT_DED") {
                record400.set("MON_RENT_I"            , Unilite.nvl(record["MON_RENT_I"]            ,0));    //월세액
            }

          this.onSaveDataButtonDown();
        },
        fnSetClear1:function(sCollectType) {
            var record400 = direct400Store.getAt(0);
            //var record600 = direct600Store.getAt(0);
            //var infoForm400 = Ext.getCmp("infoForm400");

            if(Ext.isEmpty(record400))    {
                direct400Store.insert(0, new Ext.create(direct400Store.model));
                record400 = direct400Store.getAt(0);
            }
            //일반정보
            record400.set('HOUSEHOLDER_YN',false )        ;        //세대주여부


            if(sCollectType=="QUERY" || sCollectType=="REFER" )    {
                record400.set("NONTAX_FR", "")                ;        //[입력]세액감면기간(Fr)
                record400.set("NONTAX_TO", "")                ;        //[입력]세액감면기간(To)
            }

            record400.set("FOREIGN_DISPATCH_YN", false);    //외국법인소속 파견근로자 여부
            record400.set("FORE_SINGLE_YN", false);                //외국인단일세율(저장값)
            record400.set("HALFWAY_TYPE", false);                    //중도퇴사자정산

            //기본사항
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "INCOME_DED" ) {
                record400.set("INCOME_SUPP_TOTAL_I"        , 0);    //총급여액
                record400.set("NOW_PAY_AMT"                , 0);    //[계산]주(현)총급여액
                record400.set("NOW_PAY_TOT_I"              , 0);    //[숨김]주(현)급여총액
                record400.set("NOW_BONUS_TOTAL_I"          , 0);    //[숨김]주(현)상여총액
                record400.set("NOW_ADD_BONUS_I"            , 0);    //[숨김]주(현)인정상여금액
                record400.set("NOW_STOCK_PROFIT_I"         , 0);    //[숨김]주(현)주식매수선택행사이익
                record400.set("NOW_OWNER_STOCK_DRAW_I"     , 0);    //[숨김]주(현)우리사주조합인출금
                record400.set("NOW_OF_RETR_OVER_I"         , 0);    //[숨김]주(현)임원퇴직한도초과액
                record400.set("OLD_PAY_AMT"                , 0);    //[계산]종(전)총급여액
                record400.set("OLD_PAY_TOT_I"              , 0);    //[숨김]종(전)급여총액
                record400.set("OLD_BONUS_TOTAL_I"          , 0);    //[숨김]종(전)상여총액
                record400.set("OLD_ADD_BONUS_I"            , 0);    //[숨김]종(전)인정상여금액
                record400.set("OLD_STOCK_PROFIT_I"         , 0);    //[숨김]종(전)주식매수선택행사이익
                record400.set("OLD_OWNER_STOCK_DRAW_I"     , 0);    //[숨김]종(전)우리사주조합인출금
                record400.set("OLD_OF_RETR_OVER_I"         , 0);    //[숨김]종(전)임원퇴직한도초과액
                record400.set("NAP_PAY_AMT"                , 0);    //[계산](납)총급여액
                record400.set("NAP_PAY_TOT_I"              , 0);    //[숨김](납)급여총액
                record400.set("NAP_BONUS_TOTAL_I"          , 0);    //[숨김](납)상여총액
                record400.set("INCOME_DED_I"               , 0);    //근로소득공제
                record400.set("EARN_INCOME_I"              , 0);    //근로소득금액
            }

            //기본공제/추가공제
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "PERSONAL_DED") {
                    record400.set("PER_DED_I"            , 0);    //본인공제
                    record400.set("SPOUSE"            , "N");            //배우자유무
                    record400.set("SUPP_NUM"            , 0);    //부양자
                    record400.set("SUPP_NUM_1"            , 0);    //부양자:직계존속
                    record400.set("SUPP_NUM_4"            , 0);    //부양자:직계비속-자녀입양자
                    record400.set("SUPP_NUM_5"            , 0);    //부양자:직계비속-그외직계비속
                    record400.set("SUPP_NUM_6"            , 0);    //부양자:형제자매
                    record400.set("SUPP_NUM_7"            , 0);    //부양자:수급자
                    record400.set("SUPP_NUM_8"            , 0);    //부양자:위탁아동
                    record400.set("AGED_NUM"            , 0);    //경로자
                    record400.set("DEFORM_NUM"            , 0);    //장애자
                    record400.set("MANY_CHILD_NUM"        , 0);    //자녀수
                    record400.set("BRING_CHILD_NUM"        , 0);    //자녀야육수
                    record400.set("BIRTH_ADOPT_NUM"        , 0);    //출산입양수
                    record400.set("WOMAN"                , "N");                        //부녀자
                    record400.set("ONE_PARENT"            , "N");            ///한부모
                    record400.set("BIRTH_ADOPT_NUM1"            , 0);            //출산입양첫째
                    record400.set("BIRTH_ADOPT_NUM2"            , 0);            //출산입양둘째
                    record400.set("BIRTH_ADOPT_NUM3"            , 0);            //출산입양셋째

            }

            //연금보험료공제
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "INCOME_DED" ) {
                record400.set("ANU_I"                , 0);    //국민연금보험료
            }

            if(sCollectType == "QUERY") {
                record400.set("ANU_ADD_I"            , 0);    //[입력]국민연금보험료(개별입력)
                record400.set("PUBLIC_PENS_I"        , 0);    //[입력]공무원연금
                record400.set("SOLDIER_PENS_I"        , 0);    //[입력]군인연금
                record400.set("SCH_PENS_I"            , 0);    //[입력]사립학교직원연금
                record400.set("POST_PENS_I"            , 0);    //[입력]별정우체국연금
            }

            //특별공제-보험료
            if(sCollectType ==  "QUERY" || sCollectType == "REFER" || sCollectType == "INCOME_DED") {
                record400.set("MED_PREMINM_I"        , 0);    //건강보험료
                record400.set("HIRE_INSUR_I"        , 0);    //고용보험료
            }

            if(sCollectType == "QUERY" ) {
                record400.set("MED_PREMINM_ADD_I"    , 0);    //[입력]건강보험료(개별입력)
            }

            //특별공제-주택마련
            if(sCollectType == "QUERY") {
                record400.set("HOUS_AMOUNT_TOT_I"        , 0);    //[입력]원리금상환액(대출기관)
                record400.set("HOUS_AMOUNT_TOT_I_2"        , 0);    //[입력]원리금상환액(거주자)
                record400.set("HOUS_AMOUNT_INTER_I_2"    , 0);    //[입력]주택자금이자상환액(15년미만)
                record400.set("HOUS_AMOUNT_INTER_I"        , 0);    //[입력]주택자금이자상환액(15년~29년)
                record400.set("HOUS_AMOUNT_INTER_I_3"    , 0);    //[입력]주택자금이자상환액(30년이상)
                record400.set("FIXED_RATE_LOAN"            , 0);    //[입력]고정금리비거치상환대출
                record400.set("ETC_LOAN"                , 0);    //[입력]기타대출
                record400.set("HOUS_AMOUNT_INTER_I_6"    , 0);    //[입력]15년이상(고정금리이면서 비거치상환)
                record400.set("HOUS_AMOUNT_INTER_I_7"    , 0);    //[입력]15년이상(고정금리이거나 비거치상환)
                record400.set("HOUS_AMOUNT_INTER_I_8"    , 0);    //[입력]15년이상(그밖의대출)
                record400.set("HOUS_AMOUNT_INTER_I_9"    , 0);    //[입력]10년이상(고정금리이거나 비거치상환)
            }

            //그밖의소득공제-연금저축
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType ==  "PRIV_PENS_DED" ) {
                record400.set("PRIV_PENS_I"            , 0);    //개인연금저축소득공제
            }

            //그밖의소득공제-주택마련
            if(sCollectType ==  "QUERY" || sCollectType ==  "REFER" || sCollectType ==  "HOUS_BU_DED") {
                record400.set("HOUS_BU_AMT"            , 0);    //청약저축
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "HOUS_BU_ADD_DED" ) {
                record400.set("HOUS_BU_ADD_AMT"        , 0);    //청약저축(120만원한도)
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "HOUS_WORK_DED" ) {
                record400.set("HOUS_WORK_AMT"        , 0);    //근로자주택마련저축
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "HOUS_AMOUNT_DED" ) {
                record400.set("HOUS_AMOUNT_I"        , 0);    //주택청약종합저축
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "HOUS_AMOUNT_ADD_DED" ) {
                record400.set("HOUS_AMOUNT_ADD_I"        , 0);    //주택청약종합저축(120만원한도)
            }

            //그밖의소득공제-신용카드등
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "CREDIT_ETC_DED" ) {
                record400.set("CARD_USE_I"            , 0);    //신용카드사용액
                record400.set("CASH_USE_I"            , 0);    //현금영수증사용액
                record400.set("DEBIT_CARD_USE_I"    , 0);    //직불카드사용액
                record400.set("TRA_MARKET_USE_I"    , 0);    //전통시장사용액
                record400.set("TRAFFIC_USE_I"        , 0);    //대중교통이용분
            }



            //그밖의소득공제-기타
            if(sCollectType == "QUERY") {

                record400.set("COMP_PREMINUM_I"        , 0);    //[입력]소기업소상공인공제부금
                record400.set("INVESTMENT_I"        , 0);    //[입력]투자조합출자(2012년이전 10%해당분)
                record400.set("INVESTMENT_I3"        , 0);    //[입력]투자조합출자(2012년 20%해당분)
                record400.set("INVESTMENT_I4"        , 0);    //[입력]투자조합출자(2013년 10%해당분)
                record400.set("INVESTMENT_I2"        , 0);    //[입력]투자조합출자(2013년 30%해당분)
                record400.set("INVESTMENT_I5"        , 0);    //[입력]투자조합출자(2014년 10%해당분)
                record400.set("INVESTMENT_I6"        , 0);    //[입력]투자조합출자(2014년 50%해당분)
                record400.set("INVESTMENT_I7"        , 0);    //[입력]투자조합출자(2014년 30%해당분)
                record400.set("INVESTMENT_I8"        , 0);    //[입력]투자조합출자(2015년 10%해당분)
                record400.set("INVESTMENT_I9"        , 0);    //[입력]투자조합출자(2015년100%해당분)
                record400.set("INVESTMENT_I10"        , 0);    //[입력]투자조합출자(2015년 50%해당분)
                record400.set("INVESTMENT_I11"        , 0);    //[입력]투자조합출자(2015년 30%해당분)
                record400.set("STAFF_STOCK_I"        , 0);    //[입력]우리사주조합출연
                record400.set("STAFF_GIFT_I"        , 0)                                                        //우리사주조합출연기부금의 소득공제는 없음

                record400.set("EMPLOY_WORKER_I"        , 0);    //[입력]고용유지중소기업근로자소득공제
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "LONGINVEST_DED") {
                record400.set("LONG_INVEST_STOCK_I"    , 0);    //장기집합투자증권저축
            }

            //세액감면
            if(sCollectType == "QUERY") {
                record400.set("INCOME_REDU_I"        , 0);    //[입력]소득세법
                record400.set("YOUTH_DED_I"            , 0);                                                    //중소기업취업청년(100%)    (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("YOUTH_DED_I3"        , 0);                                                    //중소기업취업청년(70%)    (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("YOUTH_DED_I2"        , 0);                                                    //중소기업취업청년(50%)    (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("SKILL_DED_I"            , 0);                                                    //외국인기술공제            (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("TAXES_REDU_I"        , 0);    //[입력]조세조약
            }

            //세액공제-근로소득/자녀
            if(sCollectType == "QUERY") {
                record400.set("IN_TAX_DED_I"        ,0);                                                            //근로소득세액공제        (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("CHILD_TAX_DED_I"        ,0);                                                            //자녀세액공제            (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("BRING_CHILD_DED_I"    ,0);                                                            //자녀양육공제            (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
                record400.set("BIRTH_ADOPT_I"        ,0);                                                            //출산입양공제            (세액계산후 금액이 결정되기 때문에 '0'으로 보여주기만 함)
            }

            //세액공제-연금계좌
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "SCI_DED") {
                record400.set("SCI_DEDUC_I"            , 0);    //과학기술인공제
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "RETIRE_PENS") {
                record400.set("RETIRE_PENS_I"        , 0);    //근로자퇴직급여보장법
            }

            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "PENS_DED") {
                record400.set("PENS_I"                , 0);    //연금저축소득공제
            }

            //특별세액공제-보장성보험
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "ETC_INSUR" || sCollectType == "PERSONAL_DED") {
                record400.set("ETC_INSUR_I"            , 0);    //보장성보험
                record400.set("DEFORM_INSUR_I"        , 0);    //장애인전용보장성보험
            }

            //특별세액공제-의료비
            if(sCollectType == "QUERY" || sCollectType == "REFER" || sCollectType == "MEDICAL_DED" || sCollectType == "INCOME_DED") {
                record400.set("MY_MED_DED_I"        , 0);    //본인의료비
                record400.set("SENIOR_MED_I"        , 0);    //경로의료비
                record400.set("DEFORM_MED_I"        , 0);    //장애의료비
                record400.set("SURGERY_MED_I"       , 0);    //난임시술비
                record400.set("MED_TOTAL_I"         , 0);    //그밖의 공제대상자 의료비
                record400.set("SERIOUS_SICK_MED_I"  , 0);    //건보산정특례자의료비
                record400.set("BASE_MED_I"          , 0);    //본인, 65세이상, 장애인, 건보
            }

            //특별세액공제-교육비
            if(sCollectType ==  "QUERY" || sCollectType == "REFER" || sCollectType == "EDUCTION_DED") {
                record400.set("PER_EDUC_I"            , 0);    //본인교육비
                record400.set("UNIV_EDUC_NUM"        , 0);    //대학교자녀수
                record400.set("UNIV_EDUC_I"            , 0);    //대학교교육비
                record400.set("STUD_EDUC_NUM"        , 0);    //초중고자녀수
                record400.set("STUD_EDUC_I"            , 0);    //초중고교육비
                record400.set("KIND_EDU_NUM"        , 0);    //유치원자녀수
                record400.set("KIND_EDUC_I"            , 0);    //유치원교육비
                record400.set("DEFORM_EDUC_NUM"        , 0);    //[숨김]장애인수
                record400.set("DEFORM_EDUC_I"        , 0);    //장애인특수교육비
                record400.set("FIELD_EDUC_I"        , 0);    //체험학습비

                record400.set("PER_EDUC_DED_I"        , 0);    //[세액계산항목]본인교육비공제
                record400.set("UNIV_EDUC_DED_I"        , 0);    //[세액계산항목]대학교교육비공제
                record400.set("STUD_EDUC_DED_I"        , 0);    //[세액계산항목]초중고교육비공제
                record400.set("KIND_EDUC_DED_I"        , 0);    //[세액계산항목]유치원교육비공제
                record400.set("DEFORM_EDUC_DED_I"    , 0);    //[세액계산항목]장애인특수교육비공제
                record400.set("FIELD_EDUC_DED_I"    , 0);    //[세액계산항목]체험학습비공제
            }

            //특별공제-기부금
            if(sCollectType ==  "QUERY" || sCollectType == "REFER" || sCollectType == "CONTRIBUTION_DED") {
                record400.set("POLICY_INDED"        , 0);    //정치자금기부금(10만원이하)
                record400.set("POLICY_GIFT_I"        , 0);    //정치자금기부금(10만원초과)
                record400.set("LEGAL_GIFT_I_PREV"    , 0);    //법정기부금(전년도이월액)-2013
                record400.set("LEGAL_GIFT_I_PREV_14", 0);    //법정기부금(전년도이월액)-2014
                record400.set("LEGAL_GIFT_I"        , 0);    //법정기부금
                record400.set("PRIV_GIFT_I_PREV"    , 0);    //특례기부금(전년도이월액)
                record400.set("PRIV_GIFT_I"            , 0);    //특례기부금
                record400.set("PUBLIC_GIFT_I_PREV"    , 0);    //공익법인신탁기부금(전년도이월액)
                record400.set("PUBLIC_GIFT_I"        , 0);    //공익법인신탁기부금
                record400.set("STAFF_GIFT_I"        , 0);    //우리사주기부금
                record400.set("APPOINT_GIFT_I_PREV"    , 0);    //지정기부금(전년도이월액)-2013
                record400.set("APPOINT_GIFT_I_PREV_14", 0);    //지정기부금(전년도이월액)-2014
                record400.set("APPOINT_GIFT_I"        , 0);    //지정기부금
                record400.set("ASS_GIFT_I_PREV"        , 0);    //종교단체기부금(전년도이월액)-2013
                record400.set("ASS_GIFT_I_PREV_14"    , 0);    //종교단체기부금(전년도이월액)-2014
                record400.set("ASS_GIFT_I"            , 0);    //종교단체기부금
            }

            //세액공제-기타
            if(sCollectType == "QUERY") {
                record400.set("P3_TAX_DED_I"        , 0);    //[입력]납세조합세액
                record400.set("HOUS_INTER_I"        , 0);    //[입력]주택자금상환액
                record400.set("FORE_INCOME_I"        , 0);    //[입력]외국납부소득금액
                record400.set("FORE_TAX_I"            , 0);    //[입력]외국납부세액
            }

            if(sCollectType ==  "QUERY" || sCollectType == "REFER" || sCollectType == "RENT_DED") {
                record400.set("MON_RENT_I"            , 0);    //월세액
            }

        },
        fnCalculateTax:function()    {
               var record = direct400Store.getAt(0);
               var infoForm400 = Ext.getCmp('infoForm400');
               var paramData = {
                'YEAR_YYYY'      : panelSearch.getValue('YEAR_YYYY'),
                'PERSON_NUMB'    : panelSearch.getValue('PERSON_NUMB')
            };
               Ext.getBody().mask('Loading');
               had618ukrService.selectCalculateTax(paramData, function(responseText, response){
                   console.log("responseText", responseText);
                   if(responseText && responseText.length > 0) UniAppManager.app.fnDisplayData2(responseText[0]);
                   Ext.getBody().unmask();
               })


        },
        fnDisplayData2:function(record)    {
            this.fnSetClear2();
            var record600 = direct600Store.getAt(0);
            record600.set("JOIN_DATE"                , record["JOIN_DATE"]);                                    //[숨김]입사일
            record600.set("RETR_DATE"                , record["RETR_DATE"]);                                    //[숨김]퇴사일
            record600.set("DEPT_CODE"                , record["DEPT_CODE"]);                                    //[숨김]부서코드
            record600.set("DEPT_NAME"                , record["DEPT_NAME"]);                                    //[숨김]부서명

            record600.set("HALFWAY_TYPE"            , record["HALFWAY_TYPE"]=="Y"? true:false);                                //[숨김]중도퇴사자정산
            //record600.set("HALFWAY_TYPE"			  , record["HALFWAY_TYPE"]);
            record600.set("HOUSEHOLDER_YN"            , record["HOUSEHOLDER_YN"]=="1"? true:false);                            //[숨김]세대주여부    1:세대주, 2:세대주 아님
            record600.set("FOREIGN_DISPATCH_YN"       , record["FOREIGN_DISPATCH_YN"]=="Y"? true:false);                        //[숨김]외국법인소속 파견근로자 여부
            record600.set("FORE_SINGLE_YN"            , record["FORE_SINGLE_YN"]=="Y"? true:false);                            //[숨김]외국인단일세율

            record600.set("INCOME_SUPP_TOTAL_I"        , Unilite.nvl(record["INCOME_SUPP_TOTAL_I"]   ,0));    //총급여액

            record600.set("PAY_TOTAL_I"                , Unilite.nvl(record["PAY_TOTAL_I"]           ,0));    //[숨김]급여총액
            record600.set("BONUS_TOTAL_I"            , Unilite.nvl(record["BONUS_TOTAL_I"]         ,0));    //[숨김]상여총액
            record600.set("ADD_BONUS_I"                , Unilite.nvl(record["ADD_BONUS_I"]           ,0));    //[숨김]인정상여금액
            record600.set("STOCK_PROFIT_I"            , Unilite.nvl(record["STOCK_PROFIT_I"]        ,0));    //[숨김]주식매수선택행사이익
            record600.set("OWNER_STOCK_DRAW_I"        , Unilite.nvl(record["OWNER_STOCK_DRAW_I"]    ,0));    //[숨김]우리사주조합인출금
              record600.set("OF_RETR_OVER_I"            , Unilite.nvl(record["OF_RETR_OVER_I"]        ,0));    //[숨김]임원퇴직한도초과액

            record600.set("NOW_PAY_TOT_I"            , Unilite.nvl(record["NOW_PAY_TOT_I"]         ,0));    //[숨김]주(현)급여총액
            record600.set("NOW_BONUS_TOTAL_I"        , Unilite.nvl(record["NOW_BONUS_TOTAL_I"]     ,0));    //[숨김]주(현)상여총액
            record600.set("NOW_ADD_BONUS_I"            , Unilite.nvl(record["NOW_ADD_BONUS_I"]       ,0));    //[숨김]주(현)인정상여금액
            record600.set("NOW_STOCK_PROFIT_I"        , Unilite.nvl(record["NOW_STOCK_PROFIT_I"]    ,0));    //[숨김]주(현)주식매수선택행사이익
            record600.set("NOW_OWNER_STOCK_DRAW_I"    , Unilite.nvl(record["NOW_OWNER_STOCK_DRAW_I"],0));    //[숨김]주(현)우리사주조합인출금
            record600.set("NOW_OF_RETR_OVER_I"        , Unilite.nvl(record["NOW_OF_RETR_OVER_I"]    ,0));    //[숨김]주(현)임원퇴직한도초과액

            record600.set("OLD_PAY_TOT_I"            , Unilite.nvl(record["OLD_PAY_TOT_I"]         ,0));    //[숨김]종(전)급여총액
            record600.set("OLD_BONUS_TOTAL_I"        , Unilite.nvl(record["OLD_BONUS_TOTAL_I"]     ,0));    //[숨김]종(전)상여총액
            record600.set("OLD_ADD_BONUS_I"            , Unilite.nvl(record["OLD_ADD_BONUS_I"]       ,0));    //[숨김]종(전)인정상여금액
            record600.set("OLD_STOCK_PROFIT_I"        , Unilite.nvl(record["OLD_STOCK_PROFIT_I"]    ,0));    //[숨김]종(전)주식매수선택행사이익
            record600.set("OLD_OWNER_STOCK_DRAW_I"    , Unilite.nvl(record["OLD_OWNER_STOCK_DRAW_I"],0));    //[숨김]종(전)우리사주조합인출금
              record600.set("OLD_OF_RETR_OVER_I"        , Unilite.nvl(record["OLD_OF_RETR_OVER_I"]    ,0));    //[숨김]종(전)임원퇴직한도초과액

            record600.set("NAP_PAY_TOT_I"            , Unilite.nvl(record["NAP_PAY_TOT_I"]         ,0));    //[숨김](납)급여총액
            record600.set("NAP_BONUS_TOTAL_I"        , Unilite.nvl(record["NAP_BONUS_TOTAL_I"]     ,0));    //[숨김](납)상여총액

            record600.set("INCOME_DED_I"            , Unilite.nvl(record["INCOME_DED_I"]          ,0));    //근로소득공제
            record600.set("EARN_INCOME_I"            , Unilite.nvl(record["EARN_INCOME_I"]         ,0));    //근로소득금액

            //기본공제/추가공제
            record600.set("PER_DED_I"                , Unilite.nvl(record["PER_DED_I"]              ,0));    //본인공제
            record600.set("SPOUSE"                    , record["SPOUSE"]);                                    //[숨김]배우자유무
            record600.set("SPOUSE_DED_I"            , Unilite.nvl(record["SPOUSE_DED_I"]          ,0));    //배우자공제
            record600.set("SUPP_NUM"                , Unilite.nvl(record["SUPP_NUM"]              ,0));    //부양자
            record600.set("SUPP_SUB_I"                , Unilite.nvl(record["SUPP_SUB_I"]            ,0));    //부양자공제

            record600.set("AGED_NUM"                , Unilite.nvl(record["AGED_NUM"]              ,0));    //경로자
            record600.set("DEFORM_NUM"                , Unilite.nvl(record["DEFORM_NUM"]            ,0));    //장애자
            record600.set("MANY_CHILD_NUM"            , Unilite.nvl(record["MANY_CHILD_NUM"]        ,0));    //[숨김]자녀
            record600.set("BRING_CHILD_NUM"            , Unilite.nvl(record["BRING_CHILD_NUM"]       ,0));    //[숨김]자녀양육
            record600.set("BIRTH_ADOPT_NUM"            , Unilite.nvl(record["BIRTH_ADOPT_NUM"]       ,0));    //[숨김]출산입양
            record600.set("WOMAN"                    , record["WOMAN"]);                                        //[숨김]부녀자유무
            record600.set("ONE_PARENT"                , record["ONE_PARENT"]);                                //[숨김]한부모유무
       		record600.set("BIRTH_ADOPT_NUM1"            , record["BIRTH_ADOPT_NUM1"]);            //출산입양첫째
            record600.set("BIRTH_ADOPT_NUM2"            , record["BIRTH_ADOPT_NUM2"]);            //출산입양둘째
            record600.set("BIRTH_ADOPT_NUM3"            , record["BIRTH_ADOPT_NUM3"]);            //출산입양셋째

            record600.set("AGED_DED_I"                , Unilite.nvl(record["AGED_DED_I"]            ,0));    //경로공제
            record600.set("DEFORM_DED_I"            , Unilite.nvl(record["DEFORM_DED_I"]          ,0));    //장애인공제
            record600.set("WOMAN_DED_I"                , Unilite.nvl(record["WOMAN_DED_I"]           ,0));    //부녀자공제
            record600.set("ONE_PARENT_DED_I"        , Unilite.nvl(record["ONE_PARENT_DED_I"]      ,0));    //한부모공제

            //연금보험료공제
            record600.set("ANU_I"                    , Unilite.nvl(record["ANU_I"]                 ,0));    //[숨김]국민연금
            record600.set("ANU_ADD_I"                , Unilite.nvl(record["ANU_ADD_I"]             ,0));    //[숨김]국민연금(개별입력)
            record600.set("ANU_DED_I"                , Unilite.nvl(record["ANU_DED_I"]             ,0));    //국민연금공제
            record600.set("PUBLIC_PENS_I"            , Unilite.nvl(record["PUBLIC_PENS_I"]         ,0));    //공무원연금
            record600.set("SOLDIER_PENS_I"            , Unilite.nvl(record["SOLDIER_PENS_I"]        ,0));    //군인연금
            record600.set("SCH_PENS_I"                , Unilite.nvl(record["SCH_PENS_I"]            ,0));    //사립학교교직원연금
            record600.set("POST_PENS_I"                , Unilite.nvl(record["POST_PENS_I"]           ,0));    //별정우체국연금

            //특별공제-보험료
            record600.set("MED_PREMINM_I"            , Unilite.nvl(record["MED_PREMINM_I"]         ,0));    //의료보험
            record600.set("HIRE_INSUR_I"            , Unilite.nvl(record["HIRE_INSUR_I"]          ,0));    //고용보험

            //특별공제-주택자금
            record600.set("HOUS_AMOUNT_I"            , Unilite.nvl(record["HOUS_AMOUNT_I"]         ,0));    //주택자금불입액(대출기관)
            record600.set("HOUS_AMOUNT_I_2"            , Unilite.nvl(record["HOUS_AMOUNT_I_2"]       ,0));    //주택자금불입액(거주자)
            record600.set("MORTGAGE_RETURN_I_2"        , Unilite.nvl(record["MORTGAGE_RETURN_I_2"]   ,0));    //장기주택저당차입금이자상환액(15년미만)
            record600.set("MORTGAGE_RETURN_I"        , Unilite.nvl(record["MORTGAGE_RETURN_I"]     ,0));    //장기주택저당차입금이자상환액(15년~29년)
            record600.set("MORTGAGE_RETURN_I_3"        , Unilite.nvl(record["MORTGAGE_RETURN_I_3"]   ,0));    //장기주택저당차입금이자상환액(30년이상)
            record600.set("MORTGAGE_RETURN_I_5"        , Unilite.nvl(record["MORTGAGE_RETURN_I_5"]   ,0));    //고정금리비거치상환대출(1500만원한도)
            record600.set("MORTGAGE_RETURN_I_4"        , Unilite.nvl(record["MORTGAGE_RETURN_I_4"]   ,0));    //기타대출(500만원한도)
            record600.set("MORTGAGE_RETURN_I_6"        , Unilite.nvl(record["MORTGAGE_RETURN_I_6"]   ,0));    //15년이상(고정금리이면서 비거치상환)
            record600.set("MORTGAGE_RETURN_I_7"        , Unilite.nvl(record["MORTGAGE_RETURN_I_7"]   ,0));    //15년이상(고정금리이거나 비거치상환)
            record600.set("MORTGAGE_RETURN_I_8"        , Unilite.nvl(record["MORTGAGE_RETURN_I_8"]   ,0));    //15년이상(그밖의대출)
            record600.set("MORTGAGE_RETURN_I_9"        , Unilite.nvl(record["MORTGAGE_RETURN_I_9"]   ,0));    //10년이상(고정금리이거나 비거치상환)

            //그밖의소득공제-연금저축
            record600.set("PRIV_PENS_I"                , Unilite.nvl(record["PRIV_PENS_I"]           ,0));    //개인연금저축

            //그밖의소득공제-주택마련
            record600.set("HOUS_BU_AMT"                , Unilite.nvl(record["HOUS_BU_AMT"]              ,0));    //청약저축(240만원한도)
            record600.set("HOUS_BU_ADD_AMT"            , Unilite.nvl(record["HOUS_BU_ADD_AMT"]       ,0));    //청약저축(120만원한도)
            record600.set("HOUS_WORK_AMT"            , Unilite.nvl(record["HOUS_WORK_AMT"]         ,0));    //근로자주택마련저축
            record600.set("HOUS_BU_AMOUNT_I"        , Unilite.nvl(record["HOUS_BU_AMOUNT_I"]      ,0));    //주택청약종합저축(240만원한도)
            record600.set("HOUS_BU_AMOUNT_ADD_I"    , Unilite.nvl(record["HOUS_BU_AMOUNT_ADD_I"]  ,0));    //주택청약종합저축(120만원한도)

            //그밖의소득공제-신용카드
            record600.set("CARD_DED_I"                , Unilite.nvl(record["CARD_DED_I"]            ,0));    //신용카드공제

            record600.set("CARD_USE_I"                , Unilite.nvl(record["CARD_USE_I"]            ,0));    //[숨김]신용카드사용액
            record600.set("CASH_USE_I"                , Unilite.nvl(record["CASH_USE_I"]            ,0));    //[숨김]현금영수증사용액
            record600.set("DEBIT_CARD_USE_I"        , Unilite.nvl(record["DEBIT_CARD_USE_I"]      ,0));    //[숨김]직불카드사용금액
            record600.set("TRA_MARKET_USE_I"        , Unilite.nvl(record["TRA_MARKET_USE_I"]      ,0));    //[숨김]전통시장사용분
            record600.set("TRAFFIC_USE_I"            , Unilite.nvl(record["TRAFFIC_USE_I"]         ,0));    //[숨김]대중교통이용분


            //그밖의소득공제-기타
            record600.set("COMP_PREMINUM_DED_I"        , Unilite.nvl(record["COMP_PREMINUM_DED_I"]   ,0));    //소기업,소상공인공제부금소득공제
            record600.set("COMP_PREMINUM"            , record["COMP_PREMINUM"]=="1" ? true:false );    //[숨김]소기업,소상공인공제부금소득공제
            record600.set("INVESTMENT_DED_I"        , Unilite.nvl(record["INVESTMENT_DED_I"]      ,0));    //투자조합출자공제
            record600.set("INVESTMENT_DED_I2"        , Unilite.nvl(record["INVESTMENT_DED_I2"]     ,0));    //[숨김]투자조합출자공제(2013년분)
            record600.set("INVESTMENT_DED_I3"        , Unilite.nvl(record["INVESTMENT_DED_I3"]     ,0));    //[숨김]투자조합출자공제(2014년분)
            record600.set("INVESTMENT_DED_I4"        , Unilite.nvl(record["INVESTMENT_DED_I4"]     ,0));    //[숨김]투자조합출자공제(2015년이후분)
            record600.set("STAFF_STOCK_DED_I"        , Unilite.nvl(record["STAFF_STOCK_DED_I"]     ,0));    //우리사주조합출연금액
            record600.set("STAFF_GIFT_DED_I"        , Unilite.nvl(record["STAFF_GIFT_DED_I"]      ,0));    //우리사주조합기부금소득공제
            record600.set("EMPLOY_WORKER_DED_I"        , Unilite.nvl(record["EMPLOY_WORKER_DED_I"]   ,0));    //고용유지중소기업근로자소득공제
            record600.set("LONG_INVEST_STOCK_DED_I"    , Unilite.nvl(record["LONG_INVEST_STOCK_DED_I"],0));    //장기집합투자증권저축

            //세액감면
            record600.set("INCOME_REDU_I"            , Unilite.nvl(record["INCOME_REDU_I"]         ,0));    //소득세법
            record600.set("YOUTH_EXEMP_RATE"            , Unilite.nvl(record["YOUTH_EXEMP_RATE"]         ,0));    //중소기업청년세액감면율
            //
            record600.set("YOUTH_DED_I"                , Unilite.nvl(record["YOUTH_DED_I"]           ,0));    //중소기업청년소득세감면금액(100%)
            record600.set("YOUTH_DED_I3"            , Unilite.nvl(record["YOUTH_DED_I3"]          ,0));    //중소기업청년소득세감면금액(70%)
            record600.set("YOUTH_DED_I2"            , Unilite.nvl(record["YOUTH_DED_I2"]          ,0));    //중소기업청년소득세감면금액(50%)
              record600.set("YOUTH_DED_I_SUM"            , Unilite.nvl(record["YOUTH_DED_I_SUM"]       ,0));    //중소기업청년 해당기간의 소득금액(감면소득)
            record600.set("SKILL_DED_I"                , Unilite.nvl(record["SKILL_DED_I"]           ,0));    //외국인기술공제
            record600.set("TAXES_REDU_I"            , Unilite.nvl(record["TAXES_REDU_I"]          ,0));    //조감법

            //세액공제-근로소득/자녀
            record600.set("IN_TAX_DED_I"            , Unilite.nvl(record["IN_TAX_DED_I"]          ,0));    //근로소득세액공제
            record600.set("CHILD_TAX_DED_I"            , Unilite.nvl(record["CHILD_TAX_DED_I"]       ,0));    //자녀세액공제
            record600.set("BRING_CHILD_DED_I"        , Unilite.nvl(record["BRING_CHILD_DED_I"]     ,0));    //자녀양육공제
            record600.set("BIRTH_ADOPT_I"            , Unilite.nvl(record["BIRTH_ADOPT_I"]         ,0));    //출산입양공제

            //세액공제-연금계좌
            record600.set("SCI_DEDUC_I"                , Unilite.nvl(record["SCI_DEDUC_I"]           ,0));    //(공제대상)과학기술인공제
            record600.set("RETIRE_PENS_I"            , Unilite.nvl(record["RETIRE_PENS_I"]         ,0));    //(공제대상)퇴직연금불입액공제
            record600.set("PENS_I"                    , Unilite.nvl(record["PENS_I"]                ,0));    //(공제대상)연금저축

            record600.set("SCI_TAX_DED_I1"            , Unilite.nvl(record["SCI_TAX_DED_I1"]        ,0));    //과학기술인공제(15%)
            record600.set("SCI_TAX_DED_I"            , Unilite.nvl(record["SCI_TAX_DED_I"]         ,0));    //과학기술인공제(12%)
            record600.set("RETIRE_TAX_DED_I1"        , Unilite.nvl(record["RETIRE_TAX_DED_I1"]     ,0));    //퇴직연금불입액공제(15%)
            record600.set("RETIRE_TAX_DED_I"        , Unilite.nvl(record["RETIRE_TAX_DED_I"]      ,0));    //퇴직연금불입액공제(12%)
            record600.set("PENS_TAX_DED_I1"            , Unilite.nvl(record["PENS_TAX_DED_I1"]       ,0));    //연금저축(15%)
            record600.set("PENS_TAX_DED_I"            , Unilite.nvl(record["PENS_TAX_DED_I"]        ,0));    //연금저축(12%)

            //특별세액공제-보장성보험
            record600.set("ETC_INSUR_I"                , Unilite.nvl(record["ETC_INSUR_I"]           ,0));    //(공제대상)기타보험료
            record600.set("DEFORM_INSUR_I"            , Unilite.nvl(record["DEFORM_INSUR_I"]        ,0));    //(공제대상)장애인전용보장보험료

            record600.set("ETC_INSUR_TAX_DED_I"        , Unilite.nvl(record["ETC_INSUR_TAX_DED_I"]   ,0));    //기타보험료
            record600.set("DEFORM_INSUR_TAX_DED_I"    , Unilite.nvl(record["DEFORM_INSUR_TAX_DED_I"],0));    //장애인전용보장보험료

            //특별세액공제-의료비
            record600.set("MED_DED_I"                , Unilite.nvl(record["MED_DED_I"]             ,0));    //(공제대상)의료비공제금액

            record600.set("MY_MED_DED_I"            , Unilite.nvl(record["MY_MED_DED_I"]          ,0));    //(공제대상)[숨김]본인의료비
            record600.set("SENIOR_MED_I"            , Unilite.nvl(record["SENIOR_MED_I"]          ,0));    //(공제대상)[숨김]경로의료비
            record600.set("DEFORM_MED_I"            , Unilite.nvl(record["DEFORM_MED_I"]          ,0));    //(공제대상)[숨김]장애의료비
            record600.set("SURGERY_MED_I"            , Unilite.nvl(record["SURGERY_MED_I"]         ,0));    //(공제대상)[숨김]난임시술비
            record600.set("MED_TOTAL_I"                , Unilite.nvl(record["MED_TOTAL_I"]           ,0));    //(공제대상)[숨김]그밖의 공제대상자 의료비

            record600.set("MED_TAX_DED_I"            , Unilite.nvl(record["MED_TAX_DED_I"]         ,0));    //의료비공제금액

            record600.set("MY_MED_TAX_DED_I"        , Unilite.nvl(record["MY_MED_TAX_DED_I"]      ,0));    //[숨김]본인의료비
            record600.set("SENIOR_MED_TAX_DED_I"    , Unilite.nvl(record["SENIOR_MED_TAX_DED_I"]  ,0));    //[숨김]경로의료비
            record600.set("DEFORM_MED_TAX_DED_I"    , Unilite.nvl(record["DEFORM_MED_TAX_DED_I"]  ,0));    //[숨김]장애의료비
            record600.set("SURGERY_MED_TAX_DED_I"    , Unilite.nvl(record["SURGERY_MED_TAX_DED_I"] ,0));    //[숨김]난임시술비
            record600.set("MED_TOTAL_TAX_DED_I"        , Unilite.nvl(record["MED_TOTAL_TAX_DED_I"]   ,0));    //[숨김]그밖의 공제대상자 의료비

            //특별세액공제-교육비
            record600.set("EDUC_DED_I"                , Unilite.nvl(record["EDUC_DED_I"]            ,0));    //(공제대상)[숨김]교육비공제

            record600.set("UNIV_EDUC_NUM"            , Unilite.nvl(record["UNIV_EDUC_NUM"]         ,0));    //대학교자녀수
            record600.set("STUD_EDUC_NUM"            , Unilite.nvl(record["STUD_EDUC_NUM"]         ,0));    //초중고자녀수
            record600.set("KIND_EDU_NUM"            , Unilite.nvl(record["KIND_EDU_NUM"]          ,0));    //유치원자녀수

            record600.set("PER_EDUC_DED_I"            , Unilite.nvl(record["PER_EDUC_DED_I"]        ,0));    //(공제대상)본인교육비공제
            record600.set("UNIV_EDUC_DED_I"            , Unilite.nvl(record["UNIV_EDUC_DED_I"]       ,0));    //(공제대상)대학교교육비공제
            record600.set("STUD_EDUC_DED_I"            , Unilite.nvl(record["STUD_EDUC_DED_I"]       ,0));    //(공제대상)초중고교육비공제
            record600.set("KIND_EDUC_DED_I"            , Unilite.nvl(record["KIND_EDUC_DED_I"]       ,0));    //(공제대상)유치원교육비공제
            record600.set("DEFORM_EDUC_DED_I"        , Unilite.nvl(record["DEFORM_EDUC_DED_I"]     ,0));    //(공제대상)장애인특수교육비공제
        	record600.set("FIELD_EDUC_DED_I"        , Unilite.nvl(record["FIELD_EDUC_DED_I"]     ,0));    //(공제대상)체험학습비공제

            record600.set("EDUC_TAX_DED_I"            , Unilite.nvl(record["EDUC_TAX_DED_I"]        ,0));    //[숨김]교육비공제

            record600.set("PER_EDUC_TAX_DED_I"        , Unilite.nvl(record["PER_EDUC_TAX_DED_I"]    ,0));    //본인교육비공제
            record600.set("UNIV_EDUC_TAX_DED_I"        , Unilite.nvl(record["UNIV_EDUC_TAX_DED_I"]   ,0));    //대학교교육비공제
            record600.set("STUD_EDUC_TAX_DED_I"        , Unilite.nvl(record["STUD_EDUC_TAX_DED_I"]   ,0));    //초중고교육비공제
            record600.set("KIND_EDUC_TAX_DED_I"        , Unilite.nvl(record["KIND_EDUC_TAX_DED_I"]   ,0));    //유치원교육비공제
            record600.set("DEFORM_EDUC_TAX_DED_I"    , Unilite.nvl(record["DEFORM_EDUC_TAX_DED_I"] ,0));    //장애인특수교육비공제
            record600.set("FIELD_EDUC_TAX_DED_I"     , Unilite.nvl(record["FIELD_EDUC_TAX_DED_I"] ,0));    //체험학습비공제

            //특별세액공제-기부금
            record600.set("POLICY_INDED"            , Unilite.nvl(record["POLICY_INDED"]          ,0));    //(입력금액)[숨김]정치자금기부금(10만원미만)
            record600.set("POLICY_GIFT_I"            , Unilite.nvl(record["POLICY_GIFT_I"]         ,0));    //(입력금액)[숨김]정치자금기부금(10만원초과)
            record600.set("LEGAL_GIFT_I_PREV"        , Unilite.nvl(record["LEGAL_GIFT_I_PREV"]     ,0));    //(입력금액)[숨김]법정기부금이월액-2013
            record600.set("LEGAL_GIFT_I_PREV_14"    , Unilite.nvl(record["LEGAL_GIFT_I_PREV_14"]  ,0));    //(입력금액)[숨김]법정기부금이월액2014
            record600.set("LEGAL_GIFT_I"            , Unilite.nvl(record["LEGAL_GIFT_I"]          ,0));    //(입력금액)[숨김]법정기부금
            record600.set("PRIV_GIFT_I_PREV"        , Unilite.nvl(record["PRIV_GIFT_I_PREV"]      ,0));    //(입력금액)[숨김]특례기부금이월액
            record600.set("PRIV_GIFT_I"                , Unilite.nvl(record["PRIV_GIFT_I"]           ,0));    //(입력금액)[숨김]특례기부금
            record600.set("PUBLIC_GIFT_I_PREV"        , Unilite.nvl(record["PUBLIC_GIFT_I_PREV"]    ,0));    //(입력금액)[숨김]공익법인신탁기부금이월액
            record600.set("PUBLIC_GIFT_I"            , Unilite.nvl(record["PUBLIC_GIFT_I"]         ,0));    //(입력금액)[숨김]공익법인신탁기부금
            record600.set("STAFF_GIFT_I"            , Unilite.nvl(record["STAFF_GIFT_I"]          ,0));    //(입력금액)[숨김]우리사주기부금
            record600.set("APPOINT_GIFT_I_PREV"        , Unilite.nvl(record["APPOINT_GIFT_I_PREV"]   ,0));    //(입력금액)[숨김]지정기부금이월액-2013
            record600.set("APPOINT_GIFT_I_PREV_14"    , Unilite.nvl(record["APPOINT_GIFT_I_PREV_14"],0));    //(입력금액)[숨김]지정기부금이월액-2014
            record600.set("APPOINT_GIFT_I"            , Unilite.nvl(record["APPOINT_GIFT_I"]        ,0));    //(입력금액)[숨김]지정기부금
            record600.set("ASS_GIFT_I_PREV"            , Unilite.nvl(record["ASS_GIFT_I_PREV"]       ,0));    //(입력금액)[숨김]종교단체기부금이월액-2013
            record600.set("ASS_GIFT_I_PREV_14"        , Unilite.nvl(record["ASS_GIFT_I_PREV_14"]    ,0));    //(입력금액)[숨김]종교단체기부금이월액-2014
            record600.set("ASS_GIFT_I"                , Unilite.nvl(record["ASS_GIFT_I"]            ,0));    //(입력금액)[숨김]종교단체기부금

            record600.set("POLICY_INDED_DED_AMT"    , Unilite.nvl(record["POLICY_INDED_DED_AMT"]  ,0));    //(공제대상)[숨김]정치자금기부금(10만원미만)
            record600.set("POLICY_GIFT_DED_AMT"        , Unilite.nvl(record["POLICY_GIFT_DED_AMT"]   ,0));    //(공제대상)[숨김]정치자금기부금(10만원초과)
            record600.set("LEGAL_DED_AMT"            , Unilite.nvl(record["LEGAL_DED_AMT"]         ,0));    //(공제대상)[숨김]법정기부금
            record600.set("STAFF_DED_AMT"            , Unilite.nvl(record["STAFF_DED_AMT"]         ,0));    //(공제대상)[숨김]우리사주기부금
            record600.set("APPOINT_ASS_TAX_DED_AMT"    , Unilite.nvl(record["APPOINT_ASS_TAX_DED_AMT"] ,0));//(공제대상)[숨김]지정기부금

            record600.set("GIFT_DED_I"                , Unilite.nvl(record["GIFT_DED_I"]            ,0));    //(소득공제)[숨김]기부금소득공제합계
            record600.set("LEGAL_GIFT_DED_I"        , Unilite.nvl(record["LEGAL_GIFT_DED_I"]      ,0));    //(소득공제)[숨김]법정기부금
            record600.set("PRIV_GIFT_DED_I"            , Unilite.nvl(record["PRIV_GIFT_DED_I"]       ,0));    //(소득공제)[숨김]특례기부금
            record600.set("PUBLIC_GIFT_DED_I"        , Unilite.nvl(record["PUBLIC_GIFT_DED_I"]     ,0));    //(소득공제)[숨김]공익법인신탁기부금
            record600.set("STAFF_GIFT_DED_I"        , Unilite.nvl(record["STAFF_GIFT_DED_I"]      ,0));    //(소득공제)[숨김]우리사주기부금
            record600.set("APPOINT_GIFT_DED_I"        , Unilite.nvl(record["APPOINT_GIFT_DED_I"]    ,0));    //(소득공제)[숨김]지정기부금
            record600.set("ASS_GIFT_DED_I"            , Unilite.nvl(record["ASS_GIFT_DED_I"]        ,0));    //(소득공제)[숨김]종교단체기부금

            record600.set("GIFT_TAX_DED_I"            , Unilite.nvl(record["GIFT_TAX_DED_I"]        ,0));    //(세액공제)기부금세액공제합계
            record600.set("POLICY_INDED_TAX_DED_I"    , Unilite.nvl(record["POLICY_INDED_TAX_DED_I"],0));    //(세액공제)[숨김]정치자금기부금(10만원미만)
            record600.set("POLICY_GIFT_TAX_DED_I"    , Unilite.nvl(record["POLICY_GIFT_TAX_DED_I"] ,0));    //(세액공제)[숨김]정치자금기부금(10만원초과)
            record600.set("LEGAL_GIFT_TAX_DED_I"    , Unilite.nvl(record["LEGAL_GIFT_TAX_DED_I"]  ,0));    //(세액공제)[숨김]법정기부금
            record600.set("STAFF_GIFT_TAX_DED_I"    , Unilite.nvl(record["STAFF_GIFT_TAX_DED_I"]  ,0));    //(세액공제)[숨김]우리사주기부금
            record600.set("APPOINT_GIFT_TAX_DED_I"    , Unilite.nvl(record["APPOINT_GIFT_TAX_DED_I"],0));    //(세액공제)[숨김]지정기부금
            record600.set("ASS_GIFT_TAX_DED_I"        , Unilite.nvl(record["ASS_GIFT_TAX_DED_I"]    ,0));    //(세액공제)[숨김]종교단체기부금

            //세액공제-기타
            record600.set("NAP_TAX_DED_I"            , Unilite.nvl(record["NAP_TAX_DED_I"]         ,0));    //납세조합세액공제
            record600.set("HOUS_INTER_I"            , Unilite.nvl(record["HOUS_INTER_I"]          ,0));    //주택자금상환액
            record600.set("OUTSIDE_INCOME_I"        , Unilite.nvl(record["OUTSIDE_INCOME_I"]      ,0));    //외국납부세액
            record600.set("MON_RENT_I"                , Unilite.nvl(record["MON_RENT_I"]            ,0));    //월세액

            //세액산출요약
            record600.set("INCOME_SUPP_TOTAL_I"        , Unilite.nvl(record["INCOME_SUPP_TOTAL_I"]   ,0));    //(조회용)총급여액
            record600.set("INCOME_DED_I"            , Unilite.nvl(record["INCOME_DED_I"]          ,0));    //(조회용)근로소득공제
            record600.set("EARN_INCOME_I"            , Unilite.nvl(record["EARN_INCOME_I"]         ,0));    //(조회용)근로소득금액

            record600.set("TAB1_DED_AMT"            , Unilite.nvl(record["TAB1_DED_AMT"]          ,0));    //(조회용)기본공제
            record600.set("TAB2_DED_AMT"            , Unilite.nvl(record["TAB2_DED_AMT"]          ,0));    //(조회용)추가공제
            record600.set("TAB3_DED_AMT"            , Unilite.nvl(record["TAB3_DED_AMT"]          ,0));    //(조회용)연금보험료공제

            record600.set("TAB4_DED_AMT"            , Unilite.nvl(record["TAB4_DED_AMT"]          ,0));    //(조회용)특별공제-보험료
            record600.set("TAB5_DED_AMT"            , Unilite.nvl(record["TAB5_DED_AMT"]          ,0));    //(조회용)특별공제-주택자금

            record600.set("GIFT_DED_I"                , Unilite.nvl(record["GIFT_DED_I"]            ,0));    //(조회용)특별공제-기부금

            record600.set("DED_INCOME_I"            , Unilite.nvl(record["DED_INCOME_I"]          ,0));    //차감근로소득
            record600.set("DED_INCOME_I1"            , Unilite.nvl(record["DED_INCOME_I1"]         ,0));    //차감근로소득
            record600.set("DED_INCOME_I2"            , Unilite.nvl(record["DED_INCOME_I2"]         ,0));    //차감근로소득

            record600.set("TAB6_DED_AMT"            , Unilite.nvl(record["TAB6_DED_AMT"]          ,0));    //(조회용)그밖의소득공제-연금저축
            record600.set("TAB7_DED_AMT"            , Unilite.nvl(record["TAB7_DED_AMT"]          ,0));    //(조회용)그밖의소득공제-주택마련
            record600.set("TAB8_DED_AMT"            , Unilite.nvl(record["TAB8_DED_AMT"]          ,0));    //(조회용)그밖의소득공제-신용카드
            record600.set("TAB9_DED_AMT"            , Unilite.nvl(record["TAB9_DED_AMT"]          ,0));    //(조회용)그밖의소득공제-기타
            record600.set("OVER_INCOME_DED_LMT"        , Unilite.nvl(record["OVER_INCOME_DED_LMT"]   ,0));    //(조회용)특별공제 종합한도 초과액

            record600.set("TAX_STD_I"                , Unilite.nvl(record["TAX_STD_I"]             ,0));    //소득과세표준
            record600.set("TAX_STD_I1"                , Unilite.nvl(record["TAX_STD_I1"]            ,0));    //소득과세표준
            record600.set("TAX_STD_I2"                , Unilite.nvl(record["TAX_STD_I2"]            ,0));    //소득과세표준
            record600.set("COMP_TAX_I"                , Unilite.nvl(record["COMP_TAX_I"]            ,0));    //산출세액
            record600.set("COMP_TAX_I1"                , Unilite.nvl(record["COMP_TAX_I1"]           ,0));    //산출세액
            record600.set("COMP_TAX_I2"                , Unilite.nvl(record["COMP_TAX_I2"]           ,0));    //산출세액

            record600.set("TAB10_DED_AMT"            , Unilite.nvl(record["TAB10_DED_AMT"]         ,0));    //감면세액

            record600.set("TAB11_DED_AMT"            , Unilite.nvl(record["TAB11_DED_AMT"]         ,0));    //(조회용)세액공제-근로소득/자녀
            record600.set("TAB12_DED_AMT"            , Unilite.nvl(record["TAB12_DED_AMT"]         ,0));    //(조회용)세액공제-연금계좌

            record600.set("TAB13_DED_AMT"            , Unilite.nvl(record["TAB13_DED_AMT"]         ,0));    //(조회용)특별세액공제-보험료
            record600.set("TAB14_DED_AMT"            , Unilite.nvl(record["TAB14_DED_AMT"]         ,0));    //(조회용)특별세액공제-의료비
            record600.set("TAB15_DED_AMT"            , Unilite.nvl(record["TAB15_DED_AMT"]         ,0));    //(조회용)특별세액공제-교육비
            record600.set("TAB16_DED_AMT"            , Unilite.nvl(record["TAB16_DED_AMT"]         ,0));    //(조회용)특별세액공제-기부금

            record600.set("STD_TAX_DED_I"            , Unilite.nvl(record["STD_TAX_DED_I"]          ,0));    //표준세액공제

            record600.set("TAB17_DED_AMT"            , Unilite.nvl(record["TAB17_DED_AMT"]         ,0));    //(조회용)세액공제-기타

            record600.set("DEF_TAX_SUM"                , Unilite.nvl(record["DEF_TAX_SUM"]           ,0));    //(조회용)결정세액합계

            record600.set("NOW_TAX_SUM"                , Unilite.nvl(record["NOW_TAX_SUM"]           ,0));    //(조회용)현근무지기납부세액
            record600.set("PRE_TAX_SUM"                , Unilite.nvl(record["PRE_TAX_SUM"]           ,0));    //(조회용)종전근무지결정세액
            record600.set("NAP_TAX_SUM"                , Unilite.nvl(record["NAP_TAX_SUM"]           ,0));    //(조회용)납세조합기납부세액
            record600.set("PAID_TAX_SUM"            , Unilite.nvl(record["PAID_TAX_SUM"]          ,0));    //(조회용)기납부세액합계
            record600.set("TAX_SUM"                    , Unilite.nvl(record["TAX_SUM"]               ,0));    //(조회용)차감징수세액

            //결정세액및차감징수세액
            record600.set("DEF_IN_TAX_I"            , Unilite.nvl(record["DEF_IN_TAX_I"]          ,0));    //결정소득세
            record600.set("DEF_LOCAL_TAX_I"            , Unilite.nvl(record["DEF_LOCAL_TAX_I"]       ,0));    //결정주민세
            record600.set("DEF_SP_TAX_I"            , Unilite.nvl(record["DEF_SP_TAX_I"]          ,0));    //결정농특세
            record600.set("DEF_TAX_SUM"                , Unilite.nvl(record["DEF_TAX_SUM"]           ,0));    //결정세액합계

            record600.set("PAID_IN_TAX_SUM"            , Unilite.nvl(record["PAID_IN_TAX_SUM"]       ,0));    //(조회용)기납부소득세합계
            record600.set("PAID_LOCAL_TAX_SUM"        , Unilite.nvl(record["PAID_LOCAL_TAX_SUM"]    ,0));    //(조회용)기납부주민세합계
            record600.set("PAID_SP_TAX_SUM"            , Unilite.nvl(record["PAID_SP_TAX_SUM"]       ,0));    //(조회용)기납부농특세합계
            record600.set("PAID_TAX_SUM"            , Unilite.nvl(record["PAID_TAX_SUM"]          ,0));    //(조회용)기납부세액합계

            record600.set("NOW_IN_TAX_I"            , Unilite.nvl(record["NOW_IN_TAX_I"]          ,0));    //[숨김]주(현)소득세
            record600.set("NOW_LOCAL_TAX_I"            , Unilite.nvl(record["NOW_LOCAL_TAX_I"]       ,0));    //[숨김]주(현)주민세
            record600.set("NOW_SP_TAX_I"            , Unilite.nvl(record["NOW_SP_TAX_I"]          ,0));    //[숨김]주(현)농특세
            record600.set("PRE_IN_TAX_I"            , Unilite.nvl(record["PRE_IN_TAX_I"]          ,0));    //[숨김]종(전)소득세
            record600.set("PRE_LOCAL_TAX_I"            , Unilite.nvl(record["PRE_LOCAL_TAX_I"]       ,0));    //[숨김]종(전)주민세
            record600.set("PRE_SP_TAX_I"            , Unilite.nvl(record["PRE_SP_TAX_I"]          ,0));    //[숨김]종(전)농특세
            record600.set("NAP_IN_TAX_I"            , Unilite.nvl(record["NAP_IN_TAX_I"]          ,0));    //[숨김](납)소득세
            record600.set("NAP_LOCAL_TAX_I"            , Unilite.nvl(record["NAP_LOCAL_TAX_I"]       ,0));    //[숨김](납)주민세
            record600.set("NAP_SP_TAX_I"            , Unilite.nvl(record["NAP_SP_TAX_I"]          ,0));    //[숨김](납)농특세

            record600.set("IN_TAX_I"                , Unilite.nvl(record["IN_TAX_I"]              ,0));    //정산소득세
            record600.set("LOCAL_TAX_I"                , Unilite.nvl(record["LOCAL_TAX_I"]           ,0));    //정산주민세
            record600.set("SP_TAX_I"                , Unilite.nvl(record["SP_TAX_I"]              ,0));    //정산농특세
            record600.set("TAX_SUM"                    , Unilite.nvl(record["TAX_SUM"]               ,0));    //(조회용)정산세액합계

            this.onSaveDataButtonDown();
        },
        fnSetClear2:function()    {
            var record600 = direct600Store.getAt(0);

            if(Ext.isEmpty(record600))    {
            record600.insert(0, new Ext.create(record600.model));
            record600 = record600.getAt(0);
            }
            //일반정보
            record600.set("JOIN_DATE"                    , "");                                    //[숨김]입사일
            record600.set("RETR_DATE"                    , "");                                    //[숨김]퇴사일
            record600.set("DEPT_CODE"                    , "");                                    //[숨김]부서코드
            record600.set("DEPT_NAME"                    , "");                                    //[숨김]부서명

            record600.set("HALFWAY_TYPE"                 , false);                                //[숨김]중도퇴사자정산
            //record600.set("HALFWAY_TYPE"                 , "");                                //[숨김]중도퇴사자정산
            record600.set("HOUSEHOLDER_YN"               , false);                            //[숨김]세대주여부
            record600.set("FOREIGN_DISPATCH_YN"          , false);                        //[숨김]외국법인소속 파견근로자 여부
            record600.set("FORE_SINGLE_YN"               , false);                            //[숨김]외국인단일세율

            record600.set("INCOME_SUPP_TOTAL_I"          , 0);    //총급여액

            record600.set("PAY_TOTAL_I"                  , 0);    //[숨김]급여총액
            record600.set("BONUS_TOTAL_I"                , 0);    //[숨김]상여총액
            record600.set("ADD_BONUS_I"                  , 0);    //[숨김]인정상여금액
            record600.set("STOCK_PROFIT_I"               , 0);    //[숨김]주식매수선택행사이익
            record600.set("OWNER_STOCK_DRAW_I"           , 0);    //[숨김]우리사주조합인출금


            record600.set("NOW_PAY_TOT_I"                , 0);    //[숨김]주(현)급여총액
            record600.set("NOW_BONUS_TOTAL_I"            , 0);    //[숨김]주(현)상여총액
            record600.set("NOW_ADD_BONUS_I"              , 0);    //[숨김]주(현)인정상여금액
            record600.set("NOW_STOCK_PROFIT_I"           , 0);    //[숨김]주(현)주식매수선택행사이익
            record600.set("NOW_OWNER_STOCK_DRAW_I"       , 0);    //[숨김]주(현)우리사주조합인출금
            record600.set("NOW_OF_RETR_OVER_I"           , 0);    //[숨김]주(현)임원퇴직한도초과액

            record600.set("OLD_PAY_TOT_I"                , 0);    //[숨김]종(전)급여총액
            record600.set("OLD_BONUS_TOTAL_I"            , 0);    //[숨김]종(전)상여총액
            record600.set("OLD_ADD_BONUS_I"              , 0);    //[숨김]종(전)인정상여금액
            record600.set("OLD_STOCK_PROFIT_I"           , 0);    //[숨김]종(전)주식매수선택행사이익
            record600.set("OLD_OWNER_STOCK_DRAW_I"       , 0);    //[숨김]종(전)우리사주조합인출금
            record600.set("OLD_OF_RETR_OVER_I"           , 0);    //[숨김]종(전)임원퇴직한도초과액

            record600.set("NAP_PAY_TOT_I"                , 0);    //[숨김](납)급여총액
            record600.set("NAP_BONUS_TOTAL_I"            , 0);    //[숨김](납)상여총액

            record600.set("INCOME_DED_I"                 , 0);    //근로소득공제
            record600.set("EARN_INCOME_I"                , 0);    //근로소득금액

            //기본공제/추가공제
            record600.set("PER_DED_I"                    , 0);    //본인공제
            record600.set("SPOUSE"                        , "N");                                    //[숨김]배우자유무
            record600.set("SPOUSE_DED_I"                , 0);    //배우자공제
            record600.set("SUPP_NUM"                    , 0);    //부양자
            record600.set("SUPP_SUB_I"                    , 0);    //부양자공제

            record600.set("AGED_NUM"                    , 0);    //경로자
            record600.set("DEFORM_NUM"                    , 0);    //장애자
            record600.set("MANY_CHILD_NUM"                , 0);    //[숨김]자녀
            record600.set("BRING_CHILD_NUM"                , 0);    //[숨김]자녀양육
            record600.set("BIRTH_ADOPT_NUM"                , 0);    //[숨김]출산입양
            record600.set("WOMAN"                        , "N");                                        //[숨김]부녀자유무
            record600.set("ONE_PARENT"                    , "N");                                //[숨김]한부모유무
        	record600.set("BIRTH_ADOPT_NUM1"            , 0);            //출산입양첫째
            record600.set("BIRTH_ADOPT_NUM2"            , 0);            //출산입양둘째
            record600.set("BIRTH_ADOPT_NUM3"            , 0);            //출산입양셋째

            record600.set("AGED_DED_I"                    , 0);    //경로공제
            record600.set("DEFORM_DED_I"                , 0);    //장애인공제
            record600.set("WOMAN_DED_I"                    , 0);    //부녀자공제
            record600.set("ONE_PARENT_DED_I"            , 0);    //한부모공제

            //연금보험료공제
            record600.set("ANU_I"                        , 0);    //[숨김]국민연금
            record600.set("ANU_ADD_I"                    , 0);    //[숨김]국민연금(개별입력)
            record600.set("ANU_DED_I"                    , 0);    //국민연금공제
            record600.set("PUBLIC_PENS_I"                , 0);    //공무원연금
            record600.set("SOLDIER_PENS_I"                , 0);    //군인연금
            record600.set("SCH_PENS_I"                    , 0);    //사립학교교직원연금
            record600.set("POST_PENS_I"                    , 0);    //별정우체국연금

            //특별공제-보험료
            record600.set("MED_PREMINM_I"                , 0);    //의료보험
            record600.set("HIRE_INSUR_I"                , 0);    //고용보험

            //특별공제-주택자금
            record600.set("HOUS_AMOUNT_I"                , 0);    //주택자금불입액(대출기관)
            record600.set("HOUS_AMOUNT_I_2"                , 0);    //주택자금불입액(거주자)
            record600.set("MORTGAGE_RETURN_I_2"            , 0);    //장기주택저당차입금이자상환액(15년미만)
            record600.set("MORTGAGE_RETURN_I"            , 0);    //장기주택저당차입금이자상환액(15년~29년)
            record600.set("MORTGAGE_RETURN_I_3"            , 0);    //장기주택저당차입금이자상환액(30년이상)
            record600.set("MORTGAGE_RETURN_I_5"            , 0);    //고정금리비거치상환대출(1500만원한도)
            record600.set("MORTGAGE_RETURN_I_4"            , 0);    //기타대출(500만원한도)
            record600.set("MORTGAGE_RETURN_I_6"            , 0);    //15년이상(고정금리이면서 비거치상환)
            record600.set("MORTGAGE_RETURN_I_7"            , 0);    //15년이상(고정금리이거나 비거치상환)
            record600.set("MORTGAGE_RETURN_I_8"            , 0);    //15년이상(그밖의대출)
            record600.set("MORTGAGE_RETURN_I_9"            , 0);    //10년이상(고정금리이거나 비거치상환)

            //그밖의소득공제-연금저축
            record600.set("PRIV_PENS_I"                    , 0);    //개인연금저축

            //그밖의소득공제-주택마련
            record600.set("HOUS_BU_AMT"                    , 0);    //청약저축(240만원한도)
            record600.set("HOUS_BU_ADD_AMT"                , 0);    //청약저축(120만원한도)
            record600.set("HOUS_WORK_AMT"                , 0);    //근로자주택마련저축
            record600.set("HOUS_BU_AMOUNT_I"            , 0);    //주택청약종합저축(240만원한도)
            record600.set("HOUS_BU_AMOUNT_ADD_I"        , 0);    //주택청약종합저축(120만원한도)

            //그밖의소득공제-신용카드
            record600.set("CARD_DED_I"                    , 0);    //신용카드공제

            record600.set("CARD_USE_I"                    , 0);    //[숨김]신용카드사용액
            record600.set("CASH_USE_I"                    , 0);    //[숨김]현금영수증사용액
            record600.set("DEBIT_CARD_USE_I"            , 0);    //[숨김]직불카드사용금액
            record600.set("TRA_MARKET_USE_I"            , 0);    //[숨김]전통시장사용분
            record600.set("TRAFFIC_USE_I"                , 0);    //[숨김]대중교통이용분


            //그밖의소득공제-기타
            record600.set("COMP_PREMINUM_DED_I"            , 0);    //소기업,소상공인공제부금소득공제
            record600.set("COMP_PREMINUM"                , true);    //[숨김]소기업,소상공인공제부금소득공제
            record600.set("INVESTMENT_DED_I"            , 0);    //투자조합출자공제
            record600.set("INVESTMENT_DED_I2"            , 0);    //[숨김]투자조합출자공제(2013년분)
            record600.set("INVESTMENT_DED_I3"            , 0);    //[숨김]투자조합출자공제(2014년분)
            record600.set("INVESTMENT_DED_I4"            , 0);    //[숨김]투자조합출자공제(2015년이후분)
            record600.set("STAFF_STOCK_DED_I"            , 0);    //우리사주조합출연금액
            record600.set("STAFF_GIFT_DED_I"            , 0);    //우리사주조합기부금소득공제
            record600.set("EMPLOY_WORKER_DED_I"            , 0);    //고용유지중소기업근로자소득공제
            record600.set("LONG_INVEST_STOCK_DED_I"        , 0);    //장기집합투자증권저축

            //세액감면
            record600.set("INCOME_REDU_I"                , 0);    //소득세법
            record600.set("YOUTH_EXEMP_RATE"                , 0);    //청년세액감면율
            record600.set("YOUTH_DED_I"                    , 0);    //중소기업청년소득세감면금액(100%)
            record600.set("YOUTH_DED_I3"                , 0);    //중소기업청년소득세감면금액(70%)
            record600.set("YOUTH_DED_I2"                , 0);    //중소기업청년소득세감면금액(50%)
              record600.set("YOUTH_DED_I_SUM"                , 0);    //중소기업청년 해당기간의 소득금액(감면소득)
            record600.set("SKILL_DED_I"                    , 0);    //외국인기술공제
            record600.set("TAXES_REDU_I"                , 0);    //조감법

            //세액공제-근로소득/자녀
            record600.set("IN_TAX_DED_I"                , 0);    //근로소득세액공제
            record600.set("CHILD_TAX_DED_I"                , 0);    //자녀세액공제
            record600.set("BRING_CHILD_DED_I"            , 0);    //자녀양육공제
            record600.set("BIRTH_ADOPT_I"                , 0);    //출산입양공제

            //세액공제-연금계좌
              record600.set("SCI_DEDUC_I"                    , 0);    //(공제대상)과학기술인공제
            record600.set("RETIRE_PENS_I"                , 0);    //(공제대상)퇴직연금불입액공제
              record600.set("PENS_I"                        , 0);    //(공제대상)연금저축

              record600.set("SCI_TAX_DED_I1"                , 0);    //과학기술인공제(15%)
              record600.set("SCI_TAX_DED_I"                , 0);    //과학기술인공제(12%)
            record600.set("RETIRE_TAX_DED_I1"            , 0);    //퇴직연금불입액공제(15%)
            record600.set("RETIRE_TAX_DED_I"            , 0);    //퇴직연금불입액공제(12%)
              record600.set("PENS_TAX_DED_I1"                , 0);    //연금저축(15%)
              record600.set("PENS_TAX_DED_I"                , 0);    //연금저축(12%)

            //특별세액공제-보장성보험
            record600.set("ETC_INSUR_I"                    , 0);    //(공제대상)기타보험료
            record600.set("DEFORM_INSUR_I"                , 0);    //(공제대상)장애인전용보장보험료

            record600.set("ETC_INSUR_TAX_DED_I"            , 0);    //기타보험료
            record600.set("DEFORM_INSUR_TAX_DED_I"        , 0);    //장애인전용보장보험료

            //특별세액공제-의료비
            record600.set("MED_DED_I"                    , 0);    //(공제대상)의료비공제금액

            record600.set("MY_MED_DED_I"                , 0);    //(공제대상)[숨김]본인의료비
            record600.set("SENIOR_MED_I"                , 0);    //(공제대상)[숨김]경로의료비
            record600.set("DEFORM_MED_I"                , 0);    //(공제대상)[숨김]장애의료비
            record600.set("SURGERY_MED_I"                , 0);    //(공제대상)[숨김]난임시술비
            record600.set("MED_TOTAL_I"                    , 0);    //(공제대상)[숨김]그밖의 공제대상자 의료비

            record600.set("MED_TAX_DED_I"                , 0);    //의료비공제금액

            record600.set("MY_MED_TAX_DED_I"            , 0);    //[숨김]본인의료비
            record600.set("SENIOR_MED_TAX_DED_I"        , 0);    //[숨김]경로의료비
            record600.set("DEFORM_MED_TAX_DED_I"        , 0);    //[숨김]장애의료비
            record600.set("SURGERY_MED_TAX_DED_I"        , 0);    //[숨김]난임시술비
            record600.set("MED_TOTAL_TAX_DED_I"            , 0);    //[숨김]그밖의 공제대상자 의료비

            //특별세액공제-교육비
            record600.set("EDUC_DED_I"                    , 0);    //(공제대상)[숨김]교육비공제

            record600.set("UNIV_EDUC_NUM"                , 0);    //대학교자녀수
            record600.set("STUD_EDUC_NUM"                , 0);    //초중고자녀수
            record600.set("KIND_EDU_NUM"                , 0);    //유치원자녀수

            record600.set("PER_EDUC_DED_I"                , 0);    //(공제대상)본인교육비공제
            record600.set("UNIV_EDUC_DED_I"                , 0);    //(공제대상)대학교교육비공제
            record600.set("STUD_EDUC_DED_I"                , 0);    //(공제대상)초중고교육비공제
            record600.set("KIND_EDUC_DED_I"                , 0);    //(공제대상)유치원교육비공제
            record600.set("DEFORM_EDUC_DED_I"            , 0);    //(공제대상)장애인특수교육비공제
        	record600.set("FIELD_EDUC_DED_I"            , 0);    //(공제대상)체험학습비공제

            record600.set("EDUC_TAX_DED_I"                , 0);    //[숨김]교육비공제

            record600.set("PER_EDUC_TAX_DED_I"            , 0);    //본인교육비공제
            record600.set("UNIV_EDUC_TAX_DED_I"            , 0);    //대학교교육비공제
            record600.set("STUD_EDUC_TAX_DED_I"            , 0);    //초중고교육비공제
            record600.set("KIND_EDUC_TAX_DED_I"            , 0);    //유치원교육비공제
            record600.set("DEFORM_EDUC_TAX_DED_I"        , 0);    //장애인특수교육비공제
            record600.set("FIELD_EDUC_TAX_DED_I"        , 0);    //체험학습비공제

            //특별세액공제-기부금
            record600.set("POLICY_INDED"                , 0);    //(입력금액)[숨김]정치자금기부금(10만원미만)
            record600.set("POLICY_GIFT_I"                , 0);    //(입력금액)[숨김]정치자금기부금(10만원초과)
            record600.set("LEGAL_GIFT_I_PREV"            , 0);    //(입력금액)[숨김]법정기부금이월액-2013
            record600.set("LEGAL_GIFT_I_PREV_14"        , 0);    //(입력금액)[숨김]법정기부금이월액2014
            record600.set("LEGAL_GIFT_I"                , 0);    //(입력금액)[숨김]법정기부금
            record600.set("PRIV_GIFT_I_PREV"            , 0);    //(입력금액)[숨김]특례기부금이월액
            record600.set("PRIV_GIFT_I"                    , 0);    //(입력금액)[숨김]특례기부금
            record600.set("PUBLIC_GIFT_I_PREV"            , 0);    //(입력금액)[숨김]공익법인신탁기부금이월액
            record600.set("PUBLIC_GIFT_I"                , 0);    //(입력금액)[숨김]공익법인신탁기부금
            record600.set("STAFF_GIFT_I"                , 0);    //(입력금액)[숨김]우리사주기부금
            record600.set("APPOINT_GIFT_I_PREV"            , 0);    //(입력금액)[숨김]지정기부금이월액-2013
            record600.set("APPOINT_GIFT_I_PREV_14"        , 0);    //(입력금액)[숨김]지정기부금이월액-2014
            record600.set("APPOINT_GIFT_I"                , 0);    //(입력금액)[숨김]지정기부금
            record600.set("ASS_GIFT_I_PREV"                , 0);    //(입력금액)[숨김]종교단체기부금이월액-2013
            record600.set("ASS_GIFT_I_PREV_14"            , 0);    //(입력금액)[숨김]종교단체기부금이월액-2014
            record600.set("ASS_GIFT_I"                    , 0);    //(입력금액)[숨김]종교단체기부금

            record600.set("POLICY_INDED_DED_AMT"        , 0);    //(공제대상)[숨김]정치자금기부금(10만원미만)
            record600.set("POLICY_GIFT_DED_AMT"            , 0);    //(공제대상)[숨김]정치자금기부금(10만원초과)
            record600.set("LEGAL_DED_AMT"                , 0);    //(공제대상)[숨김]법정기부금
            record600.set("STAFF_DED_AMT"                , 0);    //(공제대상)[숨김]우리사주기부금
            record600.set("APPOINT_ASS_TAX_DED_AMT"        , 0);//(공제대상)[숨김]지정기부금

            record600.set("GIFT_DED_I"                    , 0);    //(소득공제)[숨김]기부금소득공제합계
            record600.set("LEGAL_GIFT_DED_I"            , 0);    //(소득공제)[숨김]법정기부금
            record600.set("PRIV_GIFT_DED_I"                , 0);    //(소득공제)[숨김]특례기부금
            record600.set("PUBLIC_GIFT_DED_I"            , 0);    //(소득공제)[숨김]공익법인신탁기부금
            record600.set("STAFF_GIFT_DED_I"            , 0);    //(소득공제)[숨김]우리사주기부금
            record600.set("APPOINT_GIFT_DED_I"            , 0);    //(소득공제)[숨김]지정기부금
            record600.set("ASS_GIFT_DED_I"                , 0);    //(소득공제)[숨김]종교단체기부금

            record600.set("GIFT_TAX_DED_I"                , 0);    //(세액공제)기부금세액공제합계
            record600.set("POLICY_INDED_TAX_DED_I"        , 0);    //(세액공제)[숨김]정치자금기부금(10만원미만)
            record600.set("POLICY_GIFT_TAX_DED_I"        , 0);    //(세액공제)[숨김]정치자금기부금(10만원초과)
            record600.set("LEGAL_GIFT_TAX_DED_I"        , 0);    //(세액공제)[숨김]법정기부금
            record600.set("STAFF_GIFT_TAX_DED_I"        , 0);    //(세액공제)[숨김]우리사주기부금
            record600.set("APPOINT_GIFT_TAX_DED_I"        , 0);    //(세액공제)[숨김]지정기부금
            record600.set("ASS_GIFT_TAX_DED_I"            , 0);    //(세액공제)[숨김]종교단체기부금

            //세액공제-기타
            record600.set("NAP_TAX_DED_I"                , 0);    //납세조합세액공제
            record600.set("HOUS_INTER_I"                , 0);    //주택자금상환액
            record600.set("OUTSIDE_INCOME_I"            , 0);    //외국납부세액
            record600.set("MON_RENT_I"                    , 0);    //월세액

            //세액산출요약
            record600.set("INCOME_SUPP_TOTAL_I"            , 0);    //(조회용)총급여액
            record600.set("INCOME_DED_I"                , 0);    //(조회용)근로소득공제
            record600.set("EARN_INCOME_I"                , 0);    //(조회용)근로소득금액

            record600.set("TAB1_DED_AMT"                , 0);    //(조회용)기본공제
            record600.set("TAB2_DED_AMT"                , 0);    //(조회용)추가공제
            record600.set("TAB3_DED_AMT"                , 0);    //(조회용)연금보험료공제

            record600.set("TAB4_DED_AMT"                , 0);    //(조회용)특별공제-보험료
            record600.set("TAB5_DED_AMT"                , 0);    //(조회용)특별공제-주택자금

            record600.set("GIFT_DED_I"                    , 0);    //(조회용)특별공제-기부금

            record600.set("DED_INCOME_I"                , 0);    //차감근로소득
            record600.set("DED_INCOME_I1"                , 0);    //차감근로소득
            record600.set("DED_INCOME_I2"                , 0);    //차감근로소득

            record600.set("TAB6_DED_AMT"                , 0);    //(조회용)그밖의소득공제-연금저축
            record600.set("TAB7_DED_AMT"                , 0);    //(조회용)그밖의소득공제-주택마련
            record600.set("TAB8_DED_AMT"                , 0);    //(조회용)그밖의소득공제-신용카드
            record600.set("TAB9_DED_AMT"                , 0);    //(조회용)그밖의소득공제-기타
            record600.set("OVER_INCOME_DED_LMT"            , 0);    //(조회용)특별공제 종합한도 초과액

            record600.set("TAX_STD_I"                    , 0);    //소득과세표준
            record600.set("TAX_STD_I1"                    , 0);    //소득과세표준
            record600.set("TAX_STD_I2"                    , 0);    //소득과세표준
            record600.set("COMP_TAX_I"                    , 0);    //산출세액
            record600.set("COMP_TAX_I1"                    , 0);    //산출세액
            record600.set("COMP_TAX_I2"                    , 0);    //산출세액

            record600.set("TAB10_DED_AMT"                , 0);    //감면세액

            record600.set("TAB11_DED_AMT"                , 0);    //(조회용)세액공제-근로소득/자녀
            record600.set("TAB12_DED_AMT"                , 0);    //(조회용)세액공제-연금계좌

            record600.set("TAB13_DED_AMT"                , 0);    //(조회용)특별세액공제-보험료
            record600.set("TAB14_DED_AMT"                , 0);    //(조회용)특별세액공제-의료비
            record600.set("TAB15_DED_AMT"                , 0);    //(조회용)특별세액공제-교육비
            record600.set("TAB16_DED_AMT"                , 0);    //(조회용)특별세액공제-기부금

            record600.set("STD_TAX_DED_I"                , 0);    //표준세액공제

            record600.set("TAB17_DED_AMT"                , 0);    //(조회용)세액공제-기타

            record600.set("DEF_TAX_SUM"                    , 0);    //(조회용)결정세액합계

            record600.set("NOW_TAX_SUM"                    , 0);    //(조회용)현근무지기납부세액
            record600.set("PRE_TAX_SUM"                    , 0);    //(조회용)종전근무지결정세액
            record600.set("NAP_TAX_SUM"                    , 0);    //(조회용)납세조합기납부세액
            record600.set("PAID_TAX_SUM"                , 0);    //(조회용)기납부세액합계
            record600.set("TAX_SUM"                        , 0);    //(조회용)차감징수세액

            //결정세액및차감징수세액
            record600.set("DEF_IN_TAX_I"                , 0);    //결정소득세
            record600.set("DEF_LOCAL_TAX_I"                , 0);    //결정주민세
            record600.set("DEF_SP_TAX_I"                , 0);    //결정농특세
            record600.set("DEF_TAX_SUM"                    , 0);    //결정세액합계

            record600.set("PAID_IN_TAX_SUM"                , 0);    //(조회용)기납부소득세합계
            record600.set("PAID_LOCAL_TAX_SUM"            , 0);    //(조회용)기납부주민세합계
            record600.set("PAID_SP_TAX_SUM"                , 0);    //(조회용)기납부농특세합계
            record600.set("PAID_TAX_SUM"                , 0);    //(조회용)기납부세액합계

            record600.set("NOW_IN_TAX_I"                , 0);    //[숨김]주(현)소득세
            record600.set("NOW_LOCAL_TAX_I"                , 0);    //[숨김]주(현)주민세
            record600.set("NOW_SP_TAX_I"                , 0);    //[숨김]주(현)농특세
            record600.set("PRE_IN_TAX_I"                , 0);    //[숨김]종(전)소득세
            record600.set("PRE_LOCAL_TAX_I"                , 0);    //[숨김]종(전)주민세
            record600.set("PRE_SP_TAX_I"                , 0);    //[숨김]종(전)농특세
            record600.set("NAP_IN_TAX_I"                , 0);    //[숨김](납)소득세
            record600.set("NAP_LOCAL_TAX_I"                , 0);    //[숨김](납)주민세
            record600.set("NAP_SP_TAX_I"                , 0);    //[숨김](납)농특세

            record600.set("IN_TAX_I"                    , 0);    //정산소득세
            record600.set("LOCAL_TAX_I"                    , 0);    //정산주민세
            record600.set("SP_TAX_I"                    , 0);    //정산농특세
            record600.set("TAX_SUM"                        , 0);    //(조회용)정산세액합계
        },
        //년간근로소득/기타소득입력
        openYearIncome:function()    {
            if(!panelSearch.isValid())    {
                return;
            }
            var paramData = {
                'YEAR_YYYY'        : panelSearch.getValue('YEAR_YYYY'),
                'PERSON_NUMB'    : panelSearch.getValue('PERSON_NUMB'),
                'NAME'            : panelSearch.getValue('NAME'),
                'DEPT_NAME'        : panelSearch.getValue('DEPT_NAME'),
                'POST_CODE_NAME'        : panelSearch.getValue('POST_CODE_NAME')
            };
            if(!yearIncomeWin)    {
                Unilite.defineModel('had800Model', {
                    fields: [
                        {name: 'PAY_YYYYMM'        , text: '지급년월'        , type: 'string'},
                        {name: 'PAYGUBN'        , text: '지급구분'        , type: 'string'},
                        {name: 'SUPPDATE'        , text: '지급일자'        , type: 'uniDate'},
                        {name: 'SUPPTOTAL'        , text: '지급총액'        , type: 'uniPrice'},
                        {name: 'TAXAMOUNT'        , text: '과세분'        , type: 'uniPrice'},
                        {name: 'NONTAXAMOUNT'    , text: '비과세분'        , type: 'uniPrice'},
                        {name: 'ANU'            , text: '국민연금'        , type: 'uniPrice'},
                        {name: 'MED'            , text: '건강보험'        , type: 'uniPrice'},
                        {name: 'HIR'            , text: '고용보험'        , type: 'uniPrice'},
                        {name: 'BUSISHAREI'        , text: '사회보험부담금'    , type: 'uniPrice'},
                        {name: 'SUDK'            , text: '소득세'      , type: 'uniPrice'},
                        {name: 'JUMIN'            , text: '주민세'      , type: 'uniPrice'},
                        {name: 'PAYCODE'        , text: '급여지급방식'  , type: 'string'},
                        {name: 'TAXCODE'        , text: '세액구분'        , type: 'string'}
                    ]
                });
                var had800Store = Unilite.createStore('had800Store',{

                    model: 'had800Model',
                    uniOpt : {
                        isMaster: false,            // 상위 버튼 연결
                        editable: false,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
                    },
                    autoLoad: false,
                    proxy: {
                        type: 'direct',
                        api: {
                               read: 'had800skrService.selectListByEmployee'
                        }
                    },
                    loadStoreRecords: function(){
                        var param= yearIncomeWin.paramData;
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
                        {name: 'PERSON_NUMB'        , text: '사번'            , type: 'string', allowBlank:false},
                        {name: 'NAME'                , text: '성명'            , type: 'string'},
                        {name: 'PAY_YYYYMM'            , text: '귀속월'        , type: 'uniDate', allowBlank:false},
                        {name: 'SUPP_DATE'            , text: '지급일'        , type: 'uniDate', allowBlank:false},
                        {name: 'WAGES_CODE'            , text: '소득내역'        , type: 'string', allowBlank:false, comboType:'AU', comboCode:'H039'},
                        {name: 'SUPP_TOTAL_I'        , text: '지급금액'        , type: 'uniPrice'},
                        {name: 'IN_TAX_I'            , text: '소득세'        , type: 'uniPrice'},
                        {name: 'LOCAL_TAX_I'        , text: '주민세'        , type: 'uniPrice'},
                        {name: 'HIRE_INSUR_I'        , text: '고용보험'        , type: 'uniPrice'},
                        {name: 'TAX_AMOUNT_I'        , text: '과세분'        , type: 'uniPrice'},
                        {name: 'NON_TAX_AMOUNT_I'    , text: '비과세분'        , type: 'uniPrice'},
                        {name: 'NON_TAX_CODE'        , text: '비과세코드'    , type: 'string'},
                        {name: 'NONTAX_CODE_NAME'    , text: '비과세코드'    , type: 'string'},
                        {name: 'REMARK'                , text: '비고'          , type: 'string'}
                    ]
                });

                var had700ukrStore = Unilite.createStore('had700ukrStore',{

                    model: 'had700ukrModel',
                    uniOpt : {
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
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
                    saveStore:function()    {
                        var toCreate = this.getNewRecords();
                           var toUpdate = this.getUpdatedRecords();
                           var toDelete = this.getRemovedRecords();
                           var list = [].concat(toUpdate, toCreate);

                           var checkValid = true;
                        Ext.each(list, function(record, index) {
                            // 비과세분 입력시 비과세 코드 입력 체크
                            if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
                                alert(Msg.sMH1065 +'\n'+ Msg.fstMsgH0098);
                                checkValid = false;
                                return;
                            }
                        })
                        if(!checkValid)    {
                            return;
                        }

                        var inValidRecs = this.getInvalidRecords();
                        console.log("inValidRecords : ", inValidRecs);
                        if(inValidRecs.length == 0) {
                            config = {
                                        //params: [paramMaster],
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

                yearIncomeWin= Ext.create('widget.uniDetailWindow', {
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
                            }]},{
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
                                        expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                        useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                        useLiveSearch: false,        //찾기 버튼 사용 여부
                                        filter: {                    //필터 사용 여부
                                            useFilter: false,
                                            autoCreate: false
                                        },
                                        userToolbar :false
                                    },
                                    features: [
                                        { ftype: 'uniSummary',          showSummaryRow: true, dock :'bottom'}
                                    ],
                                    columns:  [
                                        {dataIndex: 'PAY_YYYYMM'        , width: 73,
                                            summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                                                  return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
                                            }
                                         },
                                        {dataIndex: 'PAYGUBN'    	, width: 80},
                                        {dataIndex: 'SUPPDATE'    	, width: 73},
                                        {dataIndex: 'SUPPTOTAL'   	, width: 90	, summaryType:'sum'},
                                        {dataIndex: 'TAXAMOUNT'  	, width: 90	, summaryType:'sum'},
                                        {dataIndex: 'NONTAXAMOUNT'	, width: 90	, summaryType:'sum'},
                                        {dataIndex: 'ANU'       	, width: 90	, summaryType:'sum'},
                                        {dataIndex: 'MED'        	, width: 90	, summaryType:'sum'},
                                        {dataIndex: 'HIR'       	, width: 90	, summaryType:'sum'},
                                        {dataIndex: 'BUSISHAREI'    , width: 110, summaryType:'sum'},
                                        {dataIndex: 'SUDK'        	, width: 90	, summaryType:'sum'},
                                        {dataIndex: 'JUMIN'      	, width: 90	, summaryType:'sum'},
                                        {dataIndex: 'PAYCODE'     	, width: 86	},
                                        {dataIndex: 'TAXCODE'     	, minWidth: 70, flex: 1}
                                    ]
                                })]
                            },{
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
                                        expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                        useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                        useLiveSearch: false,        //찾기 버튼 사용 여부
                                        filter: {                    //필터 사용 여부
                                            useFilter: false,
                                            autoCreate: false
                                        },
                                        state: {
                                            useState: false,            //그리드 설정 버튼 사용 여부
                                            useStateList: false        //그리드 설정 목록 사용 여부
                                        }
                                    },
                                    features: [
                                        { ftype: 'uniSummary',          showSummaryRow: true, dock :'bottom'}
                                    ],
                                    tbar:[
                                        '->',
                                        {
                                            xtype:'button',
                                            text:'추가',
                                            handler:function()    {
                                                var form = yearIncomeWin.down('#search');
                                                var grid = Ext.getCmp('had700ukrGrid');
                                                var record = Ext.create(had700ukrStore.model);
                                                rIndex = had700ukrStore.count();
                                                record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
                                                had700ukrStore.insert(rIndex, record);
                                                grid.getSelectionModel().select(rIndex);
                                            }
                                        },{
                                            xtype:'button',
                                            text:'삭제',
                                            handler:function()    {
                                                var grid = Ext.getCmp('had700ukrGrid');
                                                had700ukrStore.remove(grid.getSelectionModel().getSelection());
                                            }
                                        }
                                    ],
                                    columns:  [
                                        {dataIndex: 'PAY_YYYYMM'        , width: 73,
                                        	xtype:'uniMonthColumn',
                                            editor:{xtype:'uniMonthfield',format: 'Y.m'},
                                            summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                                                  return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
                                            }
                                        },
                                        {dataIndex: 'SUPP_DATE'         , width: 90, readonly:true},
                                        {dataIndex: 'WAGES_CODE'        , width: 90},
                                        {dataIndex: 'SUPP_TOTAL_I'      , width: 90, summaryType:'sum'},
                                        {dataIndex: 'IN_TAX_I'          , width: 90, summaryType:'sum'},
                                        {dataIndex: 'LOCAL_TAX_I'       , width: 90, summaryType:'sum'},
                                        {dataIndex: 'HIRE_INSUR_I'      , width: 90, summaryType:'sum'},
                                        {dataIndex: 'TAX_AMOUNT_I'      , width: 110, summaryType:'sum'},
                                        {dataIndex: 'NON_TAX_AMOUNT_I'  , width: 90, summaryType:'sum'},
                                        {dataIndex: 'NON_TAX_CODE'      , width: 90,
                                            editor:Unilite.popup('NONTAX_CODE_G', {
                                                textFieldName:'NONTAX_CODE_NAME',
			  									autoPopup: true,
                                                listeners:{
                                                    onSelected:function(records, type)    {
                                                        if(records)    {
                                                            var grid = Ext.getCmp('had700ukrGrid');
                                                            var record = grid.uniOpt.currentRecord;
                                                            record.set('NON_TAX_CODE', records[0].NONTAX_CODE);
                                                            record.set('NONTAX_CODE_NAME', records[0].NONTAX_CODE_NAME);
                                                        }
                                                    },
                                                    onClear:function()    {
                                                        var grid = Ext.getCmp('had700ukrGrid');
                                                        var record = grid.uniOpt.currentRecord;
                                                        record.set('NON_TAX_CODE', '');
                                                        record.set('NONTAX_CODE_NAME', '');
                                                    },
                                                    applyextparam:function(popup)    {
                                                        popup.extParam.PAY_YM_FR = yearIncomeWin.paramData.YEAR_YYYY;
                                                    }
                                                }
                                            })
                                        },
                                        {dataIndex: 'REMARK'            , minWidth: 70, flex: 1}
                                    ],
                                    listeners:{
                                    	beforeselect:function(sender, row, col) {
//                                     		var grid = Ext.getCmp('had700ukrGrid');
//                                     		alert(row.phantom);
//                                     		if(!row.phantom) {
// //                                     			grid.getColumn("PAY_YYYYMM").setDisabled(false);
// //                                     			grid.getColumn("SUPP_DATE").setDisabled(false);
// //                                     			grid.getColumn("WAGES_CODE").setDisabled(false);
//                                     			grid.getColumn("PAY_YYYYMM").setConfig("readonly", true, false);
//                                     			grid.getColumn("SUPP_DATE").setConfig("readonly", true, false);
//                                     			grid.getColumn("WAGES_CODE").setConfig("readonly", true, false);
//                                     		}
//                                     		else {
//                                     			grid.getColumn("PAY_YYYYMM").setDisabled(true);
//                                     			grid.getColumn("SUPP_DATE").setDisabled(true);
//                                     			grid.getColumn("WAGES_CODE").setDisabled(true);
//                                     			grid.getColumn("PAY_YYYYMM").setConfig("readonly", false, false);
//                                     			grid.getColumn("SUPP_DATE").setConfig("readonly", false, false);
//                                     			grid.getColumn("WAGES_CODE").setConfig("readonly", false, false);
//                                     		}
                                    	},
                                    	focuschange:function(sender, row, col) {
                                    		alert(row);
                                    		alert(col);
                                    	},
                                        edit:function(editor, context, eOpts){
                                            var sAfterValue = context.value;

                                            switch(context.field)    {
	                                            case "SUPP_TOTAL_I":
	                                                context.record.set("TAX_AMOUNT_I", sAfterValue);
	                                            break;
	                                            case "TAX_AMOUNT_I":
	                                            	var suppTotalI = context.record.get("SUPP_TOTAL_I");
	                                            	var nonTaxAmountI = suppTotalI - context.value;

	                                            	if(nonTaxAmountI < 0)
	                                            		nonTaxAmountI = 0;

	                                                context.record.set("NON_TAX_AMOUNT_I", nonTaxAmountI);
	                                            break;
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
                                handler: function() {
                                    var store = Ext.data.StoreManager.lookup('had700ukrStore') ;
                                    if(store.isDirty())    {
                                        store.saveStore();
                                    }
                                },
                                disabled: false
                            },{
                                itemId : 'closeBtn',
                                text: '닫기',
                                width:100,
                                handler: function() {
                                    yearIncomeWin.hide();

                                },
                                disabled: false
                            }
                        ]
                    },
                    listeners : {
                        beforehide: function(me, eOpt)    {
                            yearIncomeWin.down('#search').clearForm();
                            if(yearIncomeWin.changes)    {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        beforeclose: function( panel, eOpts )    {
                            yearIncomeWin.down('#search').clearForm();
                            if(yearIncomeWin.changes) {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        show: function( panel, eOpts )    {
                            var searchForm =  yearIncomeWin.down('#search');
                            searchForm.setValue("YEAR_YYYY"        ,yearIncomeWin.paramData.YEAR_YYYY);
                            searchForm.setValue("NAME"            ,yearIncomeWin.paramData.NAME);
                            searchForm.setValue("PERSON_NUMB"    ,yearIncomeWin.paramData.PERSON_NUMB);
                            searchForm.setValue("DEPT_NAME"        ,yearIncomeWin.paramData.DEPT_NAME);
                            searchForm.setValue("POST_CODE_NAME",yearIncomeWin.paramData.POST_CODE_NAME);
                            had800Store.loadStoreRecords();
                            had700ukrStore.loadStoreRecords();
                        }
                    }
                });
            }
            yearIncomeWin.paramData = paramData;
            yearIncomeWin.changes = false;
            yearIncomeWin.center();
            yearIncomeWin.show();
        },
        //종(전)근무지내역 입력
        openPrevCompany:function()    {
            if(!panelSearch.isValid())    {
                return;
            }
            var paramData = {
                'YEAR_YYYY'        : panelSearch.getValue('YEAR_YYYY'),
                'PERSON_NUMB'    : panelSearch.getValue('PERSON_NUMB'),
                'NAME'            : panelSearch.getValue('NAME'),
                'DEPT_NAME'        : panelSearch.getValue('DEPT_NAME'),
                'POST_CODE_NAME'        : panelSearch.getValue('POST_CODE_NAME')
            };

            if(!prevCompanyWin)    {
                Unilite.defineModel('had510ukrModel', {
                    fields: [
                        {name: 'YEAR_YYYY'            , text: '정산년도'        , type: 'string', allowBlank:false},
                        {name: 'PERSON_NUMB'        , text: '사번'            , type: 'string', allowBlank:false},
                        {name: 'NONTAX_CODE'        , text: '비과세코드'        , type: 'string', allowBlank:false},
                           {name: 'NONTAX_CODE_NAME'    , text: '비과세코드'    , type: 'string', allowBlank:false},
                        {name: 'TAX_EXEMPTION_I'    , text: '비과세소득'        , type: 'uniPrice'},
                        {name: 'PRINT_LOCATION'        , text: '기재란'    , type: 'string'}
                    ]
                });
                var had510ukrStore = Unilite.createStore('had510ukrStore',{

                    model: 'had510ukrModel',
                    uniOpt : {
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
                    },
                    autoLoad: false,
                    proxy: {
                        type: 'uniDirect',
                        api: {
                            read : 'had500ukrService.selectList510'
                            ,update : 'had500ukrService.update510'
                            ,create : 'had500ukrService.insert510'
                            ,destroy : 'had500ukrService.delete510'
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
                    saveStore:function()    {
                        var inValidRecs = this.getInvalidRecords();
                        console.log("inValidRecords : ", inValidRecs);
                        if(inValidRecs.length == 0) {
                            config = {
                                        //params: [paramMaster],
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
                            //prevCompanyWin.mask();
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
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
                    },
                    autoLoad: false,
                    proxy: {
                        type: 'uniDirect',
                        api: {
                            read : 'had500ukrService.selectList520'
                            ,update : 'had500ukrService.update520'
                            ,create : 'had500ukrService.insert520'
                            ,destroy : 'had500ukrService.delete520'
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
                    saveStore:function()    {

                        var inValidRecs = this.getInvalidRecords();
                        console.log("inValidRecords : ", inValidRecs);
                        if(inValidRecs.length == 0) {
                            config = {
                                        //params: [paramMaster],
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
                            //prevCompanyWin.mask();
                            this.syncAllDirect(config);
                        } else {
                            var grid = Ext.getCmp('had520ukrGrid');
                            grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                        }
                    }

                });
                Unilite.defineModel('had530ukrModel', {
                    fields: [
                        {name: 'YEAR_YYYY'            , text: '정산년도'                , type: 'string', allowBlank:false},
                        {name: 'PERSON_NUMB'        , text: '사번'                    , type: 'string', allowBlank:false},
                        {name: 'GIFT_CODE'            , text: '기부금코드'            , type: 'string', allowBlank:false, comboType:'AU', comboCode:'H119'},
                           {name: 'GIFT_YYYY'            , text: '기부년도'                , type: 'string', allowBlank:false},
                        {name: 'DDUC_PSBL_PRD'        , text: '공제가능기간'          , type: 'int', defaultValue:0},
                        {name: 'GIFT_AMOUNT_I'        , text: '기부금액'                , type: 'uniPrice'},
                        {name: 'BF_DDUC_I'            , text: '전년까지 공제된 금액'  , type: 'uniPrice'},
                        {name: 'DDUC_OBJ_I'            , text: '공제대상금액'            , type: 'uniPrice'}
                    ]
                });

                var had530_1ukrStore = Unilite.createStore('had530_1ukrStore',{
                    model: 'had530ukrModel',
                    uniOpt : {
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
                    },
                    autoLoad: false,
                    proxy: {
                        type: 'uniDirect',
                        api: {
                            read : 'had500ukrService.selectList530_1'
                            ,update : 'had500ukrService.update530_1'
                            ,create : 'had500ukrService.insert530_1'
                            ,destroy : 'had500ukrService.delete530_1'
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
                    saveStore:function()    {

                        var inValidRecs = this.getInvalidRecords();
                        console.log("inValidRecords : ", inValidRecs);
                        if(inValidRecs.length == 0) {
                            config = {
                                        //params: [paramMaster],
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
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
                    },
                    autoLoad: false,
                    proxy: {
                        type: 'uniDirect',
                        api: {
                            read : 'had500ukrService.selectList530_2'
                            ,update : 'had500ukrService.update530_2'
                            ,create : 'had500ukrService.insert530_2'
                            ,destroy : 'had500ukrService.delete530_2'
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
                    saveStore:function()    {

                        var inValidRecs = this.getInvalidRecords();
                        console.log("inValidRecords : ", inValidRecs);

                        if(inValidRecs.length == 0) {
                            config = {
                                        //params: [paramMaster],
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
                prevCompanyWin= Ext.create('widget.uniDetailWindow', {
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
                            }]},{
                                xtype:'uniDetailForm',
                                itemId:'had500Form',
                                disabled:false,
                                height:800,
                                api:{
                                    load:had500ukrService.select,
                                    submit:had500ukrService.syncMaster
                                },
                                layout: {type:'uniTable', columns:2,  tdAttrs:{'width':'500'}},
                                items:[
                                    {
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
                                                colspan:2,
                                                width:365
                                            },{
                                                fieldLabel:'사업자번호',
                                                name:'P1_COMPANY_NUM',
                                                colspan:2,
                                                width:365,
                                                listeners : {
                                                    blur: function( field, The, eOpts )    {
                                                          var newValue = field.getValue().replace(/-/g,'');
                                                          if(!Ext.isEmpty(newValue) && !Ext.isNumeric(newValue))    {
                                                              alert(Msg.sMB074);
                                                             field.setValue(field.originalValue);
                                                             return;
                                                         }
                                                          if(!Ext.isEmpty(newValue) && !(field.originalValue == field.getValue()) )    {
                                                              if(Ext.isNumeric(newValue)) {
                                                                var a = newValue;
                                                                var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
                                                                if(a.length == 10){
                                                                    field.setValue(i);
                                                                }else{
                                                                    field.setValue(a);
                                                                }

                                                             }

                                                              if(Unilite.validate('bizno', newValue) != true)    {
                                                                 if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))    {
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
                                                colspan:2,
                                                width:365
                                            },{
                                                fieldLabel:'세액감면기간',
                                                xtype:'uniDateRangefield',
                                                startFieldName:'P1_NONTAX_FR',
                                                endFieldName:'P1_NONTAX_TO',
                                                colspan:2,
                                                width:365
                                            },{
                                                fieldLabel:'중소기업취업감면',
                                                name:'P1_EXEMP_RATE',
                                                xtype:'uniCombobox',
                                                comboType:'AU',
                                                comboCode:'H179',
                                                colspan:2,
                                                width:365
                                            },{
                                                fieldLabel:'급여총액',
                                                name:'P1_PAY_TOTAL_I',
                                                xtype:'uniNumberfield',
                                                value:0
                                            },{
                                                fieldLabel:'건강보험',
                                                name:'P1_MEDICAL_INSUR_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                width:200,
                                                labelWidth:70
                                            },{
                                                fieldLabel:'상여총액',
                                                name:'P1_BONUS_I_TOTAL_I',
                                                xtype:'uniNumberfield',
                                                value:0
                                            },{
                                                fieldLabel:'고용보험',
                                                name:'P1_HIRE_INSUR_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                width:200,
                                                labelWidth:70
                                            },{
                                                fieldLabel:'인정상여',
                                                name:'P1_ADD_BONUS_I',
                                                xtype:'uniNumberfield',
                                                value:0
                                            },{
                                                fieldLabel:'국민연금',
                                                name:'P1_ANU_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                width:200,
                                                labelWidth:70
                                            },{
                                                fieldLabel:'주식매수선택권행사이익',
                                                name:'P1_STOCK_BUY_PROFIT_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                rowspan:2,
                                                tdAttrs:{'valign':'top'}
                                            },{
                                                fieldLabel:'결정소득세',
                                                name:'P1_IN_TAX_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                width:200,
                                                labelWidth:70
                                            },{
                                                fieldLabel:'결정주민세',
                                                name:'P1_LOCAL_TAX_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                width:200,
                                                labelWidth:70
                                            },{
                                                fieldLabel:'우리사주조합인출금',
                                                name:'P1_OWNER_STOCK_DRAW_I',
                                                xtype:'uniNumberfield',
                                                value:0
                                            },{
                                                fieldLabel:'농특세',
                                                name:'P1_SP_TAX_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                width:200,
                                                labelWidth:70
                                            },{
                                                fieldLabel:'임원퇴직한도초과액',
                                                name:'P1_OF_RETR_OVER_I',
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
                                                            expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                                            useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                                            useLiveSearch: false,        //찾기 버튼 사용 여부
                                                            filter: {                    //필터 사용 여부
                                                                useFilter: false,
                                                                autoCreate: false
                                                            },
                                                            state: {
                                                                useState: false,            //그리드 설정 버튼 사용 여부
                                                                useStateList: false        //그리드 설정 목록 사용 여부
                                                            },
                                                            userToolbar :false
                                                        },
                                                        rbar: [
                                                            {
                                                                xtype:'button',
                                                                width:60,
                                                                text:'추가',
                                                                handler:function()    {
                                                                    var form = prevCompanyWin.down('#search');
                                                                    var grid = Ext.getCmp('had510ukrGrid');
                                                                    var record = Ext.create(had510ukrStore.model);
                                                                    rIndex = had510ukrStore.count();
                                                                    record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
                                                                    record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
                                                                    had510ukrStore.insert(rIndex, record);
                                                                    grid.getSelectionModel().select(rIndex);
                                                                }
                                                            },{
                                                                xtype:'button',
                                                                text:'삭제',
                                                                handler:function()    {
                                                                    var grid = Ext.getCmp('had510ukrGrid');
                                                                    had510ukrStore.remove(grid.getSelectionModel().getSelection());
                                                                }
                                                            }
                                                        ],
                                                        columns:  [
                                                            {dataIndex: 'NONTAX_CODE'        , width: 150,
                                                                editor:Unilite.popup('NONTAX_CODE_G', {
                                                                    textFieldName:'NONTAX_CODE',
			  														autoPopup: true,
                                                                    listeners:{
                                                                        onSelected:function(records, type)    {
                                                                            if(records)    {
                                                                                var grid = Ext.getCmp('had510ukrGrid');
                                                                                var record = grid.uniOpt.currentRecord;
                                                                                record.set('NONTAX_CODE', records[0].NONTAX_CODE);
                                                                                record.set('NONTAX_CODE_NAME', records[0].NONTAX_CODE_NAME);
                                                                            }
                                                                        },
                                                                        onClear:function()    {
                                                                            var grid = Ext.getCmp('had510ukrGrid');
                                                                            var record = grid.uniOpt.currentRecord;
                                                                            record.set('NONTAX_CODE', '');
                                                                            record.set('NONTAX_CODE_NAME', '');
                                                                        },
                                                                        applyextparam:function(popup)    {
                                                                            popup.extParam.PAY_YM_FR = prevCompanyWin.paramData.YEAR_YYYY;
                                                                        }
                                                                    }
                                                                })
                                                            },
                                                            {dataIndex: 'TAX_EXEMPTION_I'    , flex: 1}
                                                        ]
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
                                                            expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                                            useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                                            useLiveSearch: false,        //찾기 버튼 사용 여부
                                                            filter: {                    //필터 사용 여부
                                                                useFilter: false,
                                                                autoCreate: false
                                                            },
                                                            state: {
                                                                useState: false,            //그리드 설정 버튼 사용 여부
                                                                useStateList: false        //그리드 설정 목록 사용 여부
                                                            },
                                                            userToolbar :false
                                                        },
                                                        rbar: [
                                                            {
                                                                xtype:'button',
                                                                width:60,
                                                                text:'추가',
                                                                handler:function()    {
                                                                    var form = prevCompanyWin.down('#search');
                                                                    var grid = Ext.getCmp('had530_1ukrGrid');
                                                                    var record = Ext.create(had530_1ukrStore.model);
                                                                    rIndex = had530_1ukrStore.count();
                                                                    record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
                                                                    record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
                                                                    had530_1ukrStore.insert(rIndex, record);
                                                                    grid.getSelectionModel().select(rIndex);
                                                                }
                                                            },{
                                                                xtype:'button',
                                                                text:'삭제',
                                                                handler:function()    {
                                                                    var grid = Ext.getCmp('had530_1ukrGrid');
                                                                    had530_1ukrStore.remove(grid.getSelectionModel().getSelection());
                                                                }
                                                            }
                                                        ],
                                                        columns:  [
                                                            {dataIndex: 'GIFT_CODE'        , width: 90},
                                                            {dataIndex: 'GIFT_YYYY', width:80},
                                                            {dataIndex: 'GIFT_AMOUNT_I', width:100},
                                                            {dataIndex: 'DDUC_OBJ_I'    , flex: 1}
                                                        ]
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
                                                colspan:2,
                                                width:365
                                            },{
                                                fieldLabel:'사업자번호',
                                                name:'P2_COMPANY_NUM',
                                                colspan:2,
                                                width:365,
                                                listeners : {
                                                    blur: function( field, The, eOpts )    {
                                                          var newValue = field.getValue().replace(/-/g,'');
                                                          if(!Ext.isEmpty(newValue) && !Ext.isNumeric(newValue))    {
                                                              alert(Msg.sMB074);
                                                             field.setValue(field.originalValue);
                                                             return;
                                                         }
                                                          if(!Ext.isEmpty(newValue) && !(field.originalValue == field.getValue()) )    {
                                                              if(Ext.isNumeric(newValue)) {
                                                                var a = newValue;
                                                                var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
                                                                if(a.length == 10){
                                                                    field.setValue(i);
                                                                }else{
                                                                    field.setValue(a);
                                                                }

                                                             }

                                                              if(Unilite.validate('bizno', newValue) != true)    {
                                                                 if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))    {
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
                                                colspan:2,
                                                width:365
                                            },{
                                                fieldLabel:'세액감면기간',
                                                xtype:'uniDateRangefield',
                                                startFieldName:'P2_NONTAX_FR',
                                                endFieldName:'P2_NONTAX_TO',
                                                colspan:2,
                                                width:365
                                            },{
                                                fieldLabel:'중소기업취엽감면',
                                                name:'P2_EXEMP_RATE',
                                                xtype:'uniCombobox',
                                                comboType:'AU',
                                                comboCode:'H179',
                                                colspan:2,
                                                width:365
                                            },{
                                                fieldLabel:'급여총액',
                                                name:'P2_PAY_TOTAL_I',
                                                xtype:'uniNumberfield',
                                                value:0
                                            },{
                                                fieldLabel:'건강보험',
                                                name:'P2_MEDICAL_INSUR_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                width:200,
                                                labelWidth:70
                                            },{
                                                fieldLabel:'상여총액',
                                                name:'P2_BONUS_I_TOTAL_I',
                                                xtype:'uniNumberfield',
                                                value:0
                                            },{
                                                fieldLabel:'고용보험',
                                                name:'P2_HIRE_INSUR_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                width:200,
                                                labelWidth:70
                                            },{
                                                fieldLabel:'인정상여',
                                                name:'P2_ADD_BONUS_I',
                                                xtype:'uniNumberfield',
                                                value:0
                                            },{
                                                fieldLabel:'국민연금',
                                                name:'P2_ANU_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                width:200,
                                                labelWidth:70
                                            },{
                                                fieldLabel:'주식매수선택권행사이익',
                                                name:'P2_STOCK_BUY_PROFIT_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                rowspan:2,
                                                tdAttrs:{'valign':'top'}
                                            },{
                                                fieldLabel:'결정소득세',
                                                name:'P2_IN_TAX_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                width:200,
                                                labelWidth:70
                                            },{
                                                fieldLabel:'결정주민세',
                                                name:'P2_LOCAL_TAX_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                width:200,
                                                labelWidth:70
                                            },{
                                                fieldLabel:'우리사주조합인출금',
                                                name:'P2_OWNER_STOCK_DRAW_I',
                                                xtype:'uniNumberfield',
                                                value:0
                                            },{
                                                fieldLabel:'농특세',
                                                name:'P2_SP_TAX_I',
                                                xtype:'uniNumberfield',
                                                value:0,
                                                width:200,
                                                labelWidth:70
                                            },{
                                                fieldLabel:'임원퇴직한도초과액',
                                                name:'P2_OF_RETR_OVER_I',
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
                                                            expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                                            useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                                            useLiveSearch: false,        //찾기 버튼 사용 여부
                                                            filter: {                    //필터 사용 여부
                                                                useFilter: false,
                                                                autoCreate: false
                                                            },
                                                            state: {
                                                                useState: false,            //그리드 설정 버튼 사용 여부
                                                                useStateList: false        //그리드 설정 목록 사용 여부
                                                            },
                                                            userToolbar :false
                                                        },
                                                        rbar:[
                                                            {
                                                                xtype:'button',
                                                                text:'추가',
                                                                width:60,
                                                                handler:function()    {
                                                                    var form = prevCompanyWin.down('#search');
                                                                    var grid = Ext.getCmp('had520ukrGrid');
                                                                    var record = Ext.create(had520ukrStore.model);
                                                                    rIndex = had520ukrStore.count();
                                                                    record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
                                                                    record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
                                                                    had520ukrStore.insert(rIndex, record);
                                                                    grid.getSelectionModel().select(rIndex);
                                                                }
                                                            },{
                                                                xtype:'button',
                                                                text:'삭제',
                                                                width:60,
                                                                handler:function()    {
                                                                    var grid = Ext.getCmp('had520ukrGrid');
                                                                    had520ukrStore.remove(grid.getSelectionModel().getSelection());
                                                                }
                                                            }
                                                        ],
                                                    columns:  [
                                                            {dataIndex: 'NONTAX_CODE'        , width: 150,
                                                                editor:Unilite.popup('NONTAX_CODE_G', {
                                                                    textFieldName:'NONTAX_CODE_NAME',
			  														autoPopup: true,
                                                                    listeners:{
                                                                        onSelected:function(records, type)    {
                                                                            if(records)    {
                                                                                var grid = Ext.getCmp('had520ukrGrid');
                                                                                var record = grid.uniOpt.currentRecord;
                                                                                record.set('NONTAX_CODE', records[0].NONTAX_CODE);
                                                                                record.set('NONTAX_CODE_NAME', records[0].NONTAX_CODE_NAME);
                                                                            }
                                                                        },
                                                                        onClear:function()    {
                                                                            var grid = Ext.getCmp('had520ukrGrid');
                                                                            var record = grid.uniOpt.currentRecord;
                                                                            record.set('NONTAX_CODE', '');
                                                                            record.set('NONTAX_CODE_NAME', '');
                                                                        },
                                                                        applyextparam:function(popup)    {
                                                                            popup.extParam.PAY_YM_FR = prevCompanyWin.paramData.YEAR_YYYY;
                                                                        }
                                                                    }
                                                                })
                                                            },
                                                            {dataIndex: 'TAX_EXEMPTION_I'    , flex: 1}
                                                        ]
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
                                                            expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                                            useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                                            useLiveSearch: false,        //찾기 버튼 사용 여부
                                                            filter: {                    //필터 사용 여부
                                                                useFilter: false,
                                                                autoCreate: false
                                                            },
                                                            state: {
                                                                useState: false,            //그리드 설정 버튼 사용 여부
                                                                useStateList: false        //그리드 설정 목록 사용 여부
                                                            },
                                                            userToolbar :false
                                                        },
                                                        rbar: [
                                                            {
                                                                xtype:'button',
                                                                width:60,
                                                                text:'추가',
                                                                handler:function()    {
                                                                    var form = prevCompanyWin.down('#search');
                                                                    var grid = Ext.getCmp('had530_2ukrGrid');
                                                                    var record = Ext.create(had530_2ukrStore.model);
                                                                    rIndex = had530_2ukrStore.count();
                                                                    record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
                                                                    record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
                                                                    had530_2ukrStore.insert(rIndex, record);
                                                                    grid.getSelectionModel().select(rIndex);
                                                                }
                                                            },{
                                                                xtype:'button',
                                                                text:'삭제',
                                                                handler:function()    {
                                                                    var grid = Ext.getCmp('had530_2ukrGrid');
                                                                    had530_2ukrStore.remove(grid.getSelectionModel().getSelection());
                                                                }
                                                            }
                                                        ],
                                                        columns:  [
                                                            {dataIndex: 'GIFT_CODE'        , width: 90},
                                                            {dataIndex: 'GIFT_YYYY', width:80},
                                                            {dataIndex: 'GIFT_AMOUNT_I', width:100},
                                                            {dataIndex: 'DDUC_OBJ_I'    , flex: 1}
                                                        ]
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
                                handler: function() {
                                    var searchForm =  prevCompanyWin.down('#search');
                                    prevCompanyWin.mask();
                                    had500ukrService.deleteAll(searchForm.getValues(), function(){
                                        prevCompanyWin.unmask();
                                        prevCompanyWin.hide();
                                    })
                                },
                                disabled: false

                             },
                             {
                                itemId : 'submitBtn',
                                text: '저장',
                                width:100,
                                handler: function() {
                                    var had500Form =  prevCompanyWin.down('#had500Form');
                                    if( had500Form.isDirty())          {
                                        var searchForm =  prevCompanyWin.down('#search');
                                        prevCompanyWin.mask();
                                        had500Form.submit({
                                            params: searchForm.getValues(),
                                            success:function()    {
                                                //alert('저장되었습니다.');
                                                prevCompanyWin.unmask();
                                                had500Form.resetDirtyStatus();
                                            },
                                            failure:function()    {
                                                prevCompanyWin.unmask();
                                            }
                                        });
                                    }
                                    if( had510ukrStore.isDirty())     had510ukrStore.saveStore();
                                    else if( had520ukrStore.isDirty())     had520ukrStore.saveStore();
                                    else if( had530_1ukrStore.isDirty()) had530_1ukrStore.saveStore();
                                    else if( had530_2ukrStore.isDirty()) had530_2ukrStore.saveStore();

                                },
                                disabled: false
                            },{
                                itemId : 'closeBtn',
                                text: '닫기',
                                width:100,
                                handler: function() {
                                    var had500Form =  prevCompanyWin.down('#had500Form');
                                    if(had500Form.isDirty() || had510ukrStore.isDirty() ||
                                        had520ukrStore.isDirty() || had530_1ukrStore.isDirty() ||
                                        had530_2ukrStore.isDirty()
                                    )    {
//                                        if(confirm(Msg.sMH974 + "\n" + Msg.sMB017))    {
                                        if(confirm(Msg.sMB017))    {
                                            if( had500Form.isDirty())          {
                                                var searchForm =  prevCompanyWin.down('#search');
                                                prevCompanyWin.mask();
                                                had500Form.submit({
                                                    params: searchForm.getValues(),
                                                    success:function()    {
                                                        //alert('저장되었습니다.');
                                                        prevCompanyWin.unmask();
                                                        prevCompanyWin.changes = true;
                                                    },
                                                    failure:function()    {
                                                        prevCompanyWin.unmask();
                                                    }
                                                });
                                            }
                                            if( had510ukrStore.isDirty())     {
                                            	had510ukrStore.saveStore();
                                            } else if( had520ukrStore.isDirty())     {
                                            	had520ukrStore.saveStore();
                                            } else if( had530_1ukrStore.isDirty()) {
                                            	had530_1ukrStore.saveStore();
                                            } else if( had530_2ukrStore.isDirty()) {
                                            	had530_2ukrStore.saveStore();
                                            }
                                            setTimeout(function() {prevCompanyWin.hide()}, 2000);
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
                        beforehide: function(me, eOpt)    {
                            prevCompanyWin.down('#search').clearForm();
                            if(prevCompanyWin.changes) {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        beforeclose: function( panel, eOpts )    {
                            prevCompanyWin.down('#search').clearForm();
                            if(prevCompanyWin.changes) {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        show: function( panel, eOpts )    {
                            var searchForm =  prevCompanyWin.down('#search');
                            searchForm.setValue("YEAR_YYYY"        ,prevCompanyWin.paramData.YEAR_YYYY);
                            searchForm.setValue("NAME"            ,prevCompanyWin.paramData.NAME);
                            searchForm.setValue("PERSON_NUMB"    ,prevCompanyWin.paramData.PERSON_NUMB);
                            searchForm.setValue("DEPT_NAME"        ,prevCompanyWin.paramData.DEPT_NAME);
                            searchForm.setValue("POST_CODE_NAME",prevCompanyWin.paramData.POST_CODE_NAME);
                            var form =  prevCompanyWin.down('#had500Form');
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
                            had510ukrStore.loadStoreRecords();
                            had520ukrStore.loadStoreRecords();
                            had530_1ukrStore.loadStoreRecords();
                            had530_2ukrStore.loadStoreRecords();
                        }
                    }
                });
            }
            prevCompanyWin.paramData = paramData;
            prevCompanyWin.center();
            prevCompanyWin.show();
        }
        ,
        //납세조합내역 입력
        openTaxCommunity:function() {

            if(!panelSearch.isValid())    {
                return;
            }
            var paramData = {
                'YEAR_YYYY'        : panelSearch.getValue('YEAR_YYYY'),
                'PERSON_NUMB'    : panelSearch.getValue('PERSON_NUMB'),
                'NAME'            : panelSearch.getValue('NAME'),
                'DEPT_NAME'        : panelSearch.getValue('DEPT_NAME'),
                'POST_CODE_NAME'        : panelSearch.getValue('POST_CODE_NAME')
            };

            if(!taxCommunityWin)    {

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
                            }]},{
                                xtype:'uniDetailForm',
                                itemId:'had618NapForm',
                                disabled:false,
                                height:340,
                                api:{
                                    load:had618ukrService.selectNap,
                                    submit:had618ukrService.napSyncMaster
                                },
                                layout: {type:'uniTable', columns:1,  tdAttrs:{'width':'400'}},
                                items:[
                                    {
                                        xtype:'component',
                                        html:'<div style="color:#0000FF">[납세조합]</div>'
                                    },
                                    {
                                        fieldLabel:'회사명',
                                        name:'P3_COMPANY_NAME',
                                        width:315
                                    },{
                                        fieldLabel:'사업자번호',
                                        name:'P3_COMPANY_NUM',
                                        width:315,
                                        listeners : {
                                            blur: function( field, The, eOpts )    {
                                                  var newValue = field.getValue().replace(/-/g,'');
                                                  if(!Ext.isEmpty(newValue) && !Ext.isNumeric(newValue))    {
                                                      alert(Msg.sMB074);
                                                     field.setValue(field.originalValue);
                                                     return;
                                                 }
                                                  if(!Ext.isEmpty(newValue) && !(field.originalValue == field.getValue()) )    {
                                                      if(Ext.isNumeric(newValue)) {
                                                        var a = newValue;
                                                        var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
                                                        if(a.length == 10){
                                                            field.setValue(i);
                                                        }else{
                                                            field.setValue(a);
                                                        }

                                                     }

                                                      if(Unilite.validate('bizno', newValue) != true)    {
                                                         if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))    {
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
                                        width:365
                                    },{
                                        fieldLabel:'세액감면기간',
                                        xtype:'uniDateRangefield',
                                        startFieldName:'P3_NONTAX_FR',
                                        endFieldName:'P3_NONTAX_TO',
                                        width:365
                                    },{
                                        fieldLabel:'급여총액',
                                        name:'P3_PAY_TOTAL_I',
                                        xtype:'uniNumberfield',
                                        value:0
                                    },{
                                        fieldLabel:'상여총액',
                                        name:'P3_BONUS_I_TOTAL_I',
                                        xtype:'uniNumberfield',
                                        value:0
                                    },{
                                        fieldLabel:'소득세',
                                        name:'P3_IN_TAX_I',
                                        xtype:'uniNumberfield',
                                        value:0
                                    },{
                                        fieldLabel:'주민세',
                                        name:'P3_LOCAL_TAX_I',
                                        xtype:'uniNumberfield',
                                        value:0

                                    },{
                                        fieldLabel:'농특세',
                                        name:'P3_SP_TAX_I',
                                        xtype:'uniNumberfield',
                                        value:0
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
                                width:80,
                                handler: function() {
                                    var searchForm =  taxCommunityWin.down('#search');
                                    taxCommunityWin.mask();
                                    had618ukrService.napDeleteAll(searchForm.getValues(), function(){
                                        taxCommunityWin.unmask();
                                        taxCommunityWin.hide();
                                    })
                                },
                                disabled: false

                             },
                             {
                                itemId : 'submitBtn',
                                text: '저장',
                                width:80,
                                handler: function() {
                                    var had618NapForm =  taxCommunityWin.down('#had618NapForm');
                                    if( had618NapForm.isDirty())          {
                                        var searchForm =  taxCommunityWin.down('#search');
                                        taxCommunityWin.mask();
                                        had618NapForm.submit({
                                            params: searchForm.getValues(),
                                            success:function()    {
                                                //alert('저장되었습니다.');
                                            	taxCommunityWin.changes = true;
                                                taxCommunityWin.unmask();
                                                had618NapForm.resetDirtyStatus();
                                            },
                                            failure:function()    {
                                                taxCommunityWin.unmask();
                                            }
                                        });
                                    }

                                },
                                disabled: false
                            },{
                                itemId : 'closeBtn',
                                text: '닫기',
                                width:80,
                                handler: function() {
                                    var had618NapForm =  taxCommunityWin.down('#had618NapForm');
                                    if(had618NapForm.isDirty() )    {
                                        if(confirm('변경된 내용이 있습니다.'+'\n'+ '저장하시겠습니까?'))    {
	                                        var searchForm =  taxCommunityWin.down('#search');
	                                        taxCommunityWin.mask();
	                                        had618NapForm.submit({
	                                            params: searchForm.getValues(),
	                                            success:function()    {
	                                                //alert('저장되었습니다.');
	                                            	taxCommunityWin.changes=true;
	                                                taxCommunityWin.unmask();
	                                            },
	                                            failure:function()    {
	                                                taxCommunityWin.unmask();
	                                            }
	                                        });

                                            setTimeout(function() {taxCommunityWin.hide();}, 2000);
                                        } else {
                                            taxCommunityWin.hide();
                                        }
                                    }
                                    taxCommunityWin.hide();
                                },
                                disabled: false
                            }
                        ]
                    },
                    listeners : {
                        beforehide: function(me, eOpt)    {
                            taxCommunityWin.down('#search').clearForm();
                            if(taxCommunityWin.changes) {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        beforeclose: function( panel, eOpts )    {
                            taxCommunityWin.down('#search').clearForm();
                            if(taxCommunityWin.changes) {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        show: function( panel, eOpts )    {
                            var searchForm =  taxCommunityWin.down('#search');
                            searchForm.setValue("YEAR_YYYY"        ,taxCommunityWin.paramData.YEAR_YYYY);
                            searchForm.setValue("NAME"            ,taxCommunityWin.paramData.NAME);
                            searchForm.setValue("PERSON_NUMB"    ,taxCommunityWin.paramData.PERSON_NUMB);
                            searchForm.setValue("DEPT_NAME"        ,taxCommunityWin.paramData.DEPT_NAME);
                            searchForm.setValue("POST_CODE_NAME",taxCommunityWin.paramData.POST_CODE_NAME);
                            var form =  taxCommunityWin.down('#had618NapForm');
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


                        }
                    }
                });
            }
            taxCommunityWin.paramData = paramData;
            taxCommunityWin.center();
            taxCommunityWin.show();

        }
        ,
        //부양가족 공제
        openFamily:function(openType, searchForm)    {

            if(!searchForm.isValid())    {
                return;
            }
            var paramData = {
                'YEAR_YYYY'        : searchForm.getValue('YEAR_YYYY'),
                'PERSON_NUMB'    : searchForm.getValue('PERSON_NUMB'),
                'NAME'            : searchForm.getValue('NAME'),
                'DEPT_NAME'        : searchForm.getValue('DEPT_NAME'),
                'POST_CODE_NAME'        : searchForm.getValue('POST_CODE_NAME')
            };
            if(!familyWin)    {

                Unilite.defineModel('had960ukrModel', {
                    fields: [
                        {name: 'PERSON_NUMB'            , text: '사번'                , type: 'string', allowBlank:false},
                        {name: 'NAME'                   , text: '성명'                , type: 'string'},
                        {name: 'YEAR_YYYY'              , text: '정산년도'            , type: 'string', allowBlank:false},
                        {name: 'FAMILY_NAME'            , text: '성명'                , type: 'string', allowBlank:false},
                        {name: 'REPRE_NUM'              , text: '주민등록번호'        , type: 'string', allowBlank:false},
                        {name: 'REL_CODE'               , text: '관계코드'            , type: 'string', allowBlank:false, store:Ext.data.StoreManager.lookup("relCodeStore")},

                        {name: 'REL_CODE_ORIGIN'      , text: '관계코드_ORIGIN'            , type: 'string'},

                        {name: 'IN_FORE'                , text: '내·외국인'            , type: 'string', allowBlank:false, comboType:'AU', comboCode:'H118'},
                        {name: 'SEQ_NUM'                , text: '구분'                , type: 'string', allowBlank:false, comboType:'AU', comboCode:'H120'},

                        {name: 'DEFAULT_DED_YN'         , text: '기본'            , type: 'bool'},
                        {name: 'HOUSEHOLDER_YN'         , text: '세대주'        , type: 'bool'},
                        {name: 'DEFORM_DED_YN'          , text: '장애인'        , type: 'bool'},
                        {name: 'DEFORM_KIND_CODE'       , text: '장애인구분'    , type: 'string', comboType:'AU', comboCode:'H169'},

                        {name: 'BRING_CHILD_DED_YN'		, text: '자녀양육비'    , type: 'bool'},
                        {name: 'WOMAN_DED_YN'           , text: '부녀자'        , type: 'bool'},
                        {name: 'ONE_PARENT_DED_YN'      , text: '한부모'    , type: 'bool'},
                        {name: 'OLD_DED_YN'             , text: '경로우대'      , type: 'bool'},
                        {name: 'MANY_CHILD_DED_YN'      , text: '다자녀'    , type: 'bool'},
                        {name: 'BIRTH_ADOPT_DED_YN'     , text: '출산입양'    , type: 'bool'},
                        {name: 'BIRTH_ADOPT_CODE'       , text: '출산코드'    		, type: 'string', comboType:'AU', comboCode:'H206'},

                        {name: 'INSUR_CODE'             , text: '보험료구분'        , type: 'string', comboType:'AU', comboCode:'H141'},
                        {name: 'INSUR_USE_I'            , text: '보험료'            , type: 'uniPrice', defaultValue:0},
                        {name: 'MED_AMOUNT_I'           , text: '건강보험료'        , type: 'uniPrice', defaultValue:0},
                        {name: 'HIR_AMOUNT_I'           , text: '고용보험료'        , type: 'uniPrice', defaultValue:0},

                        {name: 'MED_USE_I'              , text: '의료비'            , type: 'uniPrice', defaultValue:0},
                        {name: 'SURGERY_MED_I'          , text: '난임시술비'            , type: 'uniPrice', defaultValue:0},
                        {name: 'SERIOUS_SICK_MED_I'     , text: '장애인·<br/>건보산정특례'    , type: 'uniPrice', defaultValue:0},
                        {name: 'EDU_USE_I'              , text: '교육비'            , type: 'uniPrice', defaultValue:0},
                        {name: 'DEFORM_EDU_USE_I'              , text: '장애인교육비'            , type: 'uniPrice', defaultValue:0},//20190117 장애인 교육비 추가
                        {name: 'FIELD_EDUC_I'           , text: '체험학습비'            , type: 'uniPrice', defaultValue:0},
                        {name: 'EDU_PRINCIPAL_RTN_I'    , text: '학자금원리금상환액'            , type: 'uniPrice', defaultValue:0},
                        {name: 'EDU_CODE'               , text: '교육비구분'        , type: 'string', comboType:'AU', comboCode:'H142'},
                        {name: 'UNIFORM_USE_I'          , text: '교복구입비'            , type: 'uniPrice', defaultValue:0},

                        {name: 'CARD_USE_I'             , text: '신용카드'            , type: 'uniPrice', defaultValue:0},
                        {name: 'DEBIT_CARD_USE_I'       , text: '직불카드'            , type: 'uniPrice', defaultValue:0},
                        {name: 'INSTITUTE_BILL_I'       , text: '지로납부'            , type: 'uniPrice', defaultValue:0},
                        {name: 'CASH_USE_I'             , text: '현금영수증'        , type: 'uniPrice', defaultValue:0},
                        {name: 'TRA_MARKET_USE_I'       , text: '전통시장사용분'    , type: 'uniPrice', defaultValue:0},
                        {name: 'TRAFFIC_USE_I'          , text: '대중교통이용분'    , type: 'uniPrice', defaultValue:0},
                        {name: 'GIFT_USE_I'             , text: '기부금'            , type: 'uniPrice', defaultValue:0},

                        {name: 'DIVI'                   , text: 'DIVI'              , type: 'string'},
                        {name: 'LIVE_GUBUN'             , text: '거주구분'          , type: 'string'}

		             , {name:'BOOK_CONCERT_CARD_I'          , text:'신용카드사용분'                 , type:'uniPrice'    ,defaultValue:0}
		             , {name:'BOOK_CONCERT_CASH_I'          , text:'현금영수증사용분'               , type:'uniPrice'    ,defaultValue:0}
		             , {name:'BOOK_CONCERT_DEBIT_I'         , text:'직불카드등사용분'               , type:'uniPrice'    ,defaultValue:0}
                    ]
                });
                var had960ukrStore = Unilite.createStore('had960ukrStore',{

                    model: 'had960ukrModel',
                    uniOpt : {
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
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
                    saveStore:function()    {
                        var toCreate = this.getNewRecords();
                           var toUpdate = this.getUpdatedRecords();
                           var toDelete = this.getRemovedRecords();
                           var list = [].concat(toUpdate, toCreate);

                           var checkValid = true;
                        Ext.each(list, function(record, index) {
                            // 비과세분 입력시 비과세 코드 입력 체크
                            if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
                                alert(Msg.sMH1065 +'\n'+ Msg.fstMsgH0098);
                                checkValid = false;
                                return;
                            }
                            if(record.get('EDU_CODE') =='' && (record.get('EDU_USE_I')+record.get('FIELD_EDUC_I') != 0) ) {
                            	alert("교육비 구분을 입력하세요.");
                                checkValid = false;
                                return;
                            }
                        })
                        if(!checkValid)    {
                            return;
                        }

                        var inValidRecs = this.getInvalidRecords();
                        console.log("inValidRecords : ", inValidRecs);
                        if(inValidRecs.length == 0) {
                            config = {
                                        //params: [paramMaster],
                                        success: function(batch, option) {
                                            familyWin.changes = true;
                                            familyWin.unmask();
                                            had960ukrStore.loadStoreRecords();
                                        }
                                };
                            //familyWin.mask();
                            this.syncAllDirect(config);
                        } else {
                            var grid = Ext.getCmp('had960ukrGrid');
                            grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                        }
                    }

                });

                familyWin= Ext.create('widget.uniDetailWindow', {
                    title: '인적공제항목',
                    width: 1280,
                    height:500,

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
                            }]},{
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
                                        expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                        useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                        useLiveSearch: false,        //찾기 버튼 사용 여부
                                        filter: {                    //필터 사용 여부
                                            useFilter: false,
                                            autoCreate: false
                                        },
                                        state: {
                                            useState: false,            //그리드 설정 버튼 사용 여부
                                            useStateList: false        //그리드 설정 목록 사용 여부
                                        }
                                    },
                                    tbar:[
                                        '->',
                                        {
                                            xtype:'button',
                                            itemId:'familyWin-add',
                                            text:'추가',
                                            handler:function()    {
                                                var form = familyWin.down('#search');
                                                var grid = Ext.getCmp('had960ukrGrid');
                                                var record1 = Ext.create(had960ukrStore.model);
                                                rIndex = had960ukrStore.count();
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
                                            }
                                        },{
                                            xtype:'button',
                                            text:'삭제',
                                            itemId:'familyWin-delete',
                                            handler:function()    {
                                                var grid = Ext.getCmp('had960ukrGrid');
                                                var rowIdx = grid.getSelectedRowIndex();
                                                var selRecord = grid.getSelection();
                                                if(selRecord.length > 0)	{
                                                	if(selRecord[0].get('REL_CODE') == "0") {
                                                		alert("근로자 본인은 삭제하실 수 없습니다.");
                                                		return;
                                                	}

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
                                            handler:function()    {
                                                var form = familyWin.down('#search');

                                                had960ukrService.selectChkData(form.getValues(), function(responseText, response){
                                                    if(!Ext.isEmpty(responseText))    {
                                                        if(confirm(Msg.fsbMsgH0360))    {
                                                            had960ukrStore.removeAll();
                                                            had960ukrService.selectLast(form.getValues(), function(responseText, response){
                                                                if(Ext.isEmpty(responseText)) {
                                                                    alert(Msg.fsbMsgH0361);
                                                                }else {
                                                                    had960ukrStore.add(responseText)
                                                                }
                                                            })
                                                        }
                                                    }else {
                                                        had960ukrService.removeAll();
                                                        had960ukrService.selectLast(form.getValues(), function(responseText, response){
                                                            if(is)
                                                            had960ukrService.add(responseText)
                                                        })
                                                    }
                                                })
                                            }
                                        }
                                    ],
                                    columns:  [
                                        {dataIndex: 'FAMILY_NAME'        , width: 60},
                                        {dataIndex: 'REPRE_NUM'        , width: 120},
                                        {dataIndex: 'REL_CODE'            , width: 120},

                                        {dataIndex: 'REL_CODE_ORIGIN'            , width: 120,hidden:true},

                                        {dataIndex: 'IN_FORE'        , width: 70},
                                        {dataIndex: 'SEQ_NUM'        , width: 90},
                                        {text:'인적공제항목', id:'info_gr', columns:[
                                            {xtype:'checkcolumn'	, dataIndex: 'DEFAULT_DED_YN'    	, width: 50,
                                            	listeners:{
                                            		beforecheckchange:function()	{
                                            			if(familyWin.openType != 'P')	return false;
                                            		},
                                            		checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
                                            			if(familyWin.openType != 'P')	return false;

                                            			var familyGrid = familyWin.down("#had960ukrGrid");
                                            			familyGrid.fnCheckChange(column.dataIndex, record, checked);
                                            		}
                                            	}
                                            },
                                            {xtype:'checkcolumn'	,dataIndex: 'HOUSEHOLDER_YN'    	, width: 50,
                                            	listeners:{
                                            		beforecheckchange:function()	{
                                            			if(familyWin.openType != 'P')	return false;
                                            		},
                                            		checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
                                            			var familyGrid = familyWin.down("#had960ukrGrid");
                                            			familyGrid.fnCheckChange(column.dataIndex, record, checked);
                                            		}
                                            	}
                                            },
                                            {xtype:'checkcolumn'	,dataIndex: 'DEFORM_DED_YN'    		, width: 50,
                                            	listeners:{
                                            		beforecheckchange:function()	{
                                            			if(familyWin.openType != 'P')	return false;
                                            		},
                                            		checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
                                            			var familyGrid = familyWin.down("#had960ukrGrid");
                                            			familyGrid.fnCheckChange(column.dataIndex, record, checked);
                                            		}
                                            	}
                                            },
                                            {dataIndex: 'DEFORM_KIND_CODE'        						, width: 90},
                                            //{xtype:'checkcolumn'	,dataIndex: 'BRING_CHILD_DED_YN'    , width: 100,
                                            //	listeners:{
                                            //		beforecheckchange:function()	{
                                            //			if(familyWin.openType != 'P')	return false;
                                            //		},
                                            //		checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
                                            //			var familyGrid = familyWin.down("#had960ukrGrid");
                                            //			familyGrid.fnCheckChange(column.dataIndex, record, checked);
                                            //		}
                                            //	}
                                            //},
                                            {xtype:'checkcolumn'	,dataIndex: 'WOMAN_DED_YN'    		, width: 50,
                                            	listeners:{
                                            		beforecheckchange:function()	{
                                            			if(familyWin.openType != 'P')	return false;
                                            		},
                                            		checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
                                            			var familyGrid = familyWin.down("#had960ukrGrid");
                                            			familyGrid.fnCheckChange(column.dataIndex, record, checked);
                                            		}
                                            	}
                                            },
                                            {xtype:'checkcolumn'	,dataIndex: 'ONE_PARENT_DED_YN'		, width: 50,
                                            	listeners:{
                                            		beforecheckchange:function()	{
                                            			if(familyWin.openType != 'P')	return false;
                                            		},
                                            		checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
                                            			var familyGrid = familyWin.down("#had960ukrGrid");
                                            			familyGrid.fnCheckChange(column.dataIndex, record, checked);
                                            		}
                                            	}
                                            },
                                            {xtype:'checkcolumn'	,dataIndex: 'OLD_DED_YN'    		, width: 70,
                                            	listeners:{
                                            		beforecheckchange:function()	{
                                            			if(familyWin.openType != 'P')	return false;
                                            		},
                                            		checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
                                            			var familyGrid = familyWin.down("#had960ukrGrid");
                                            			familyGrid.fnCheckChange(column.dataIndex, record, checked);
                                            		}
                                            	}
                                            },
                                            {xtype:'checkcolumn'	,dataIndex: 'BIRTH_ADOPT_DED_YN'    , width: 70,
                                            	listeners:{
                                            		beforecheckchange:function()	{
                                            			if(familyWin.openType != 'P')	return false;
                                            		},
                                            		checkchange:function(column, rowIndex, checked, record, e, eOpts)	{
                                            			var familyGrid = familyWin.down("#had960ukrGrid");
                                            			familyGrid.fnCheckChange(column.dataIndex, record, checked);
                                            		}
                                            	}
                                            },
                                            {dataIndex: 'BIRTH_ADOPT_CODE'        						, width: 90, flex: 1}
                                        ]},
                                        {text:'보험료공제', id:'insur_gr', columns:[
                                            {dataIndex: 'INSUR_CODE'    , width: 90},
                                            {dataIndex: 'INSUR_USE_I'    , flex:1}
                                        ]},
                                        {dataIndex: 'MED_USE_I'		, id:'med_gr'    , width:80},
                                        {dataIndex: 'SURGERY_MED_I'	, id:'med_gr2'   , width:90},
                                        {dataIndex: 'SERIOUS_SICK_MED_I', id:'med_gr3'   , flex:1},
                                        {text:'교육비공제', id:'edu_gr', columns:[
                                            {dataIndex: 'EDU_CODE'        		, width: 90},
                                            {dataIndex: 'EDU_USE_I'    			, width:100},
                                            {dataIndex: 'DEFORM_EDU_USE_I'   , width:100}, //20190117 장애인 교육비 추가
                                            {dataIndex: 'FIELD_EDUC_I'    		, width:100},
                                            {dataIndex: 'UNIFORM_USE_I'    		, width:100},
                                            {dataIndex: 'EDU_PRINCIPAL_RTN_I'   , flex:1}
                                        ]},
                                        {text:'신용카드 등 사용액공제', id:'credit_gr', columns:[
                                            {dataIndex: 'CARD_USE_I'    , width: 90},
                                            {dataIndex: 'DEBIT_CARD_USE_I'        , width: 90},
                                            {dataIndex: 'CASH_USE_I'    , width: 90},
                                            {text:'도서공연비', id:'book_concert_gr', columns:[
                                            	{dataIndex: 'BOOK_CONCERT_CARD_I' , width: 90},
	                                            {dataIndex: 'BOOK_CONCERT_CASH_I' , width: 90},
	                                            {dataIndex: 'BOOK_CONCERT_DEBIT_I', width: 90}]},
                                            {dataIndex: 'TRA_MARKET_USE_I'    , width: 90},
                                            {dataIndex: 'TRAFFIC_USE_I'        , flex:1}
                                        ]}
                                    ],
                                    fnAutoSetSamePerson:function(record, column)    {
                                        var idx = had960ukrStore.indexOf(record);
                                        var dRecord = idx%2 == 0 ? had960ukrStore.getAt(idx+1) : had960ukrStore.getAt(idx-1)
                                        if(dRecord)    {
                                        	if(dRecord.get(column) != record.get(column))
                                            	dRecord.set(column, record.get(column));
                                         }
                                    },
                                    fnClearDedItem:function(record) {
                                        record.set("DEFAULT_DED_YN", false);
                                        this.fnAutoSetSamePerson(record, "DEFAULT_DED_YN");
                                        record.set("HOUSEHOLDER_YN", false);
                                        this.fnAutoSetSamePerson(record, "HOUSEHOLDER_YN");
                                        record.set("DEFORM_DED_YN", false);
                                        this.fnAutoSetSamePerson(record, "DEFORM_DED_YN");
                                        record.set("BRING_CHILD_DED_YN", false);
                                        //this.fnAutoSetSamePerson(record, "BRING_CHILD_DED_YN");
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

                                    },
                                    fnCheckChange:function(field, record, sAfterValue)	{
                                    	var relationCode = record.get("REL_CODE");

                                            //'성별(주민등록번호에 의해 계산됨)
                                            var gender       = record.get("REPRE_NUM").replace("-","").substring(6, 7);

                                            //'나이(주민등록번호에 의해 계산됨)

                                            var dAge = 0;
                                            if(gender == "3" || gender == "4" || gender == "7" || gender == "8" ) {
                                                dAge     = parseInt(record.get("YEAR_YYYY")) - parseInt("20" +  record.get("REPRE_NUM").substring(0,2));
                                            } else {
                                                dAge     = parseInt(record.get("YEAR_YYYY")) - parseInt("19" +  record.get("REPRE_NUM").substring(0,2));
                                            }

                                            //'관계코드 필수 체크
                                            if (relationCode == "" )    {
                                                if(sAfterValue) {
                                            		alert(Msg.sMB308);
                                                }
                                                if(sAfterValue == false) {
                                            		alert("False!!");
                                                }
                                                else
                                                	alert(sAfterValue);
                                                record.set(field, false);
                                                this.fnAutoSetSamePerson(record, field)    //같은 소득자의 자료 자동 세팅
                                                return;
                                            }
                                            switch(field)    {
                                            	case "HOUSEHOLDER_YN":
                                            		this.fnAutoSetSamePerson(record, field);
                                            	break;
                                                case "DEFAULT_DED_YN":
                                                    //'case 1) 관계코드 =  본인 → 본인은 항상 "기본공제"
                                                    if( relationCode == "0" ) {
                                                        if( sAfterValue  ) {
                                                            record.set(field,true);
                                                            this.fnAutoSetSamePerson(record, field);
                                                            return;
                                                        }
                                                    }
                                                    //case 2) 관계코드 <> 본인 → 공제적용연령 체크 필요
                                                    //                          단, 장애인공제대상이면 공제적용연령 체크 안 함.
                                                    if( record.get("DEFORM_DED_YN") ) {
                                                        record.set(field,true);
                                                        this.fnAutoSetSamePerson(record, field);
                                                        return;
                                                    }
                                                    if (relationCode == "4" || relationCode == "5" || relationCode == "6"  )    { //2-1) 직계비속, 형제자매

                                                        var dAgeLimit = 20;

                                                        if( dAge > dAgeLimit ) {
                                                            alert(Msg.sMH9037);
                                                            record.set(field, false);
                                                            this.fnAutoSetSamePerson(record, field)
                                                            return;
                                                        }

                                                        //'2-2) 직계존속
                                                    } else if (relationCode ==  "1"|| relationCode == "2" ) {
                                                            if( gender == "1" || gender == "5" ) {
                                                                var dAgeLimit = 60

                                                                if( dAge < dAgeLimit ) {
                                                                    alert(Msg.sMH9038)
                                                                    record.set(field, false);
                                                                    this.fnAutoSetSamePerson(record, field)
                                                                    return;
                                                                }
                                                            }

                                                            if( gender == "2" || gender == "6" ) {
                                                                var dAgeLimit = 60

                                                                if( dAge < dAgeLimit ) {
                                                                    alert(Msg.sMH9039)
                                                                    record.set(field, false);
                                                                    this.fnAutoSetSamePerson(record, field)
                                                                    return;
                                                                }
                                                            }

                                                        //'2-3) 위탁아동
                                                    } else if( relationCode =="8" )    {
                                                            var dAgeLimit = 18;

                                                            if( dAge >= dAgeLimit ) {
                                                                alert(Msg.fsbMsgH0297);
                                                                record.set(field, false);
                                                                this.fnAutoSetSamePerson(record, field)
                                                                return;
                                                            }
                                                    }
                                        			this.fnAutoSetSamePerson(record, field);
                                                break;
                                                case "DEFORM_DED_YN": //'장애인공제
                                                    //'장애인공제일 경우, 기본공제자 자동 세팅
                                                    if(sAfterValue ) {
                                                        record.set("DEFAULT_DED_YN", true);
                                                    }
                                                    if(!sAfterValue)	{
                                                    	 record.set("DEFORM_KIND_CODE", "");
                                        				this.fnAutoSetSamePerson(record, "DEFORM_KIND_CODE");
                                                    }
                                                    this.fnAutoSetSamePerson(record, field);
                                        			this.fnAutoSetSamePerson(record, "DEFAULT_DED_YN");
                                                break;
                                                //case "BRING_CHILD_DED_YN": //'자녀양육비공제
                                                //    //'공제적용연령 체크
                                                //    var dAgeLimit = 6

                                                //    if( dAge > dAgeLimit &&  sAfterValue ) {
                                                //        alert(Msg.sMH1576);
                                                //        record.set(field, false);
                                                //        this.fnAutoSetSamePerson(record, field)
                                                //        return;
                                                //    }
                                                //    this.fnAutoSetSamePerson(record, field);
                                                //break;
                                                case "WOMAN_DED_YN"    : //'부녀자공제
                                                    //'한부모소득공제 여부체크
                                                    if(record.get("ONE_PARENT_DED_YN") && sAfterValue ) {
                                                        alert(Msg.fsbMsgH0385);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }

                                                    //'기본공제자 여부 체크
                                                    if( !record.get("DEFAULT_DED_YN") && sAfterValue) {
                                                        alert(Msg.fsbMsgH0109);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }

                                                    //'성별 및 관계코드(본인) 체크
                                                    if( gender != "2" && gender != "6" && sAfterValue ) {
                                                        alert(Msg.fsbMsgH0106);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }
                                                    this.fnAutoSetSamePerson(record, field);
                                                break;
                                                case "ONE_PARENT_DED_YN"://'한부모소득공제
                                                    //'부녀자공제 여부체크
                                                    if( record.get("WOMAN_DED_YN") && sAfterValue) {
                                                        alert(Msg.fsbMsgH0383);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }

                                                    //'기본공제자 여부 체크
                                                    if( !record.get("DEFAULT_DED_YN") && sAfterValue ) {
                                                        alert(Msg.fsbMsgH0109);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }

                                                    //'관계코드(본인) 체크
                                                    if( relationCode != "0" ) {
                                                        alert(Msg.fsbMsgH0384);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }
                                                    this.fnAutoSetSamePerson(record, field)
                                                break;
                                                case "OLD_DED_YN"://'경로우대공제
                                                    //'기본공제자 여부 체크
                                                    if( !record.get("DEFAULT_DED_YN") ) {

                                                        alert(Msg.fsbMsgH0109);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }

                                                    //'공제적용연령 체크
                                                    var dAgeLimit = 70;
                                                    if( dAge < dAgeLimit ) {
                                                        alert(Msg.fsbMsgH0274);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }
                                                    this.fnAutoSetSamePerson(record, field);
                                                break;
                                                case "MANY_CHILD_DED_YN"://'다자녀추가공제
                                                    //'기본공제자 여부 체크
                                                    if( !record.get("DEFAULT_DED_YN") && sAfterValue) {
                                                        alert(Msg.fsbMsgH0109);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }

                                                    //'거주자 여부 체크
                                                    if( record.get("LIVE_GUBUN") == "2" && sAfterValue) {
                                                        alert(Msg.fsbMsgH0107);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }

                                                    //'관계코드 체크
                                                    if( relationCode != "4"  && sAfterValue) {
                                                        alert(Msg.fsbMsgH0280);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }

                                                    //'공제적용연령 체크
                                                    var dAgeLimit = 20

                                                    //' 20세 이상이거나 장애인이 아니면 체크 불가
                                                    if( dAge > dAgeLimit  &&  !record.get("DEFORM_DED_YN")  && sAfterValue) {
                                                        alert(Msg.sMH1578);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }
                                                    this.fnAutoSetSamePerson(record, field);
                                                break;
                                                case "BIRTH_ADOPT_DED_YN"://'출산입양자공제
                                                    //'기본공제자 여부 체크
                                                    if( !record.get("DEFAULT_DED_YN")  && sAfterValue ) {
                                                        alert(Msg.fsbMsgH0109);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field)
                                                        return;
                                                    }


                                                    var lBirthDay;

                                                    if( gender == "3" || gender == "4" || gender == "7" || gender == "8" ) {
                                                        lBirthDay = parseInt("20" +  record.get("REPRE_NUM").substring(0,6));
                                                    }else {
                                                        lBirthDay = parseInt("19" +  record.get("REPRE_NUM").substring(0,6));
                                                    }

                                                    if( lBirthDay < parseInt(record.get("YEAR_YYYY") + "0101")  && sAfterValue) {
                                                        alert(Msg.fsbMsgH0105);
                                                        record.set(field, false);
                                                        this.fnAutoSetSamePerson(record, field);
                                                        return;
                                                    }
                                                    this.fnAutoSetSamePerson(record, field);
                                                    if(!sAfterValue) {
	                                                    record.set("BIRTH_ADOPT_CODE", "");
	                                                    this.fnAutoSetSamePerson(record, "BIRTH_ADOPT_CODE");
                                                    }
                                                break;

                                                default:
                                                break;
                                            }
                                    },
                                    listeners:{
                                    	beforeedit:function(editor, context, eOpts)	{
                                    		if(familyWin.openType != 'P' && UniUtils.indexOf(context.field, ['BIRTH_ADOPT_CODE','DEFORM_KIND_CODE']))	{
                                    			return false;
                                    		}

                                    		if(context.record.get("DIVI") ==''  && UniUtils.indexOf(context.field, ['FAMILY_NAME','REPRE_NUM','REL_CODE_ORIGIN'/*,'REL_CODE'*/,'IN_FORE','SEQ_NUM']))   {
                                    			return false;
                                    		}

	                                   		if(context.record.get("REL_CODE") == '6' && UniUtils.indexOf(context.field, ['CARD_USE_I','DEBIT_CARD_USE_I','CASH_USE_I','BOOK_CONCERT_CARD_I','BOOK_CONCERT_CASH_I','BOOK_CONCERT_DEBIT_I','TRA_MARKET_USE_I','TRAFFIC_USE_I']))	{
	                                   			return false;
	                                   		}
                                    	},
                                        edit:function(editor, context, eOpts){
                                            var sAfterValue = context.value;

                                            //'관계코드
                                            var relationCode = context.record.get("REL_CODE");

                                            //'성별(주민등록번호에 의해 계산됨)
                                            var gender       = context.record.get("REPRE_NUM").replace("-","").substring(6, 7);

                                            //'나이(주민등록번호에 의해 계산됨)

                                            var dAge = 0;
                                            if(gender == "3" || gender == "4" || gender == "7" || gender == "8" ) {
                                                dAge     = parseInt(context.record.get("YEAR_YYYY")) - parseInt("20" +  context.record.get("REPRE_NUM").substring(0,2));
                                            } else {
                                                dAge     = parseInt(context.record.get("YEAR_YYYY")) - parseInt("19" +  context.record.get("REPRE_NUM").substring(0,2));
                                            }

                                            //'관계코드 필수 체크
                                            if (relationCode == "" &&
                                                UniUtils.indexOf(context.field, [ "DEFAULT_DED_YN", "HOUSEHOLDER_YN"    , "DEFORM_DED_YN"    , /*"BRING_CHILD_DED_YN",*/ "WOMAN_DED_YN"  , "ONE_PARENT_DED_YN" , "OLD_DED_YN"       , "MANY_CHILD_DED_YN", "BIRTH_ADOPT_DED_YN" ,"BIRTH_ADOPT_CODE" ]))    {
                                                alert(Msg.sMB308);
                                                context.record.set(context.field, false);
                                                context.grid.fnAutoSetSamePerson(context.record, context.field)    //같은 소득자의 자료 자동 세팅
                                                return;
                                            }

                                            switch(context.field)    {
                                                case "FAMILY_NAME":
                                                    //같은 소득자의 자료 자동 세팅
                                                    context.grid.fnAutoSetSamePerson(context.record, context.field)
                                                break;
                                                case "REPRE_NUM":
                                                    if( sAfterValue == "-" )   {
                                                        context.row.set(context.field, '');
                                                        sAfterValue = '';
                                                    }
                                                    if( sAfterValue != "" )   {
                                                        if(UniUtils.indexOf(sAfterValue.replace("-","").substring(6, 7), ["1", "2", "3", "4"]))    {
                                                            context.record.set("IN_FORE", "1");
                                                        } else {
                                                            context.record.set("IN_FORE", "9");
                                                        }
                                                    }

                                                    //같은 소득자의 자료 자동 세팅
                                                    context.grid.fnAutoSetSamePerson(context.record, context.field);
                                                    context.grid.fnAutoSetSamePerson(context.record, "IN_FORE");

                                                    //인적공제항목 초기화
                                                    context.grid.fnClearDedItem(context.record)
                                                break;
                                                case "REL_CODE":
                                                    //같은 소득자의 자료 자동 세팅
                                                    context.grid.fnAutoSetSamePerson(context.record, context.field);

                                                    //인적공제항목 초기화
                                                    context.grid.fnClearDedItem(context.record)
                                                break;
                                                case "IN_FORE":
                                                    //같은 소득자의 자료 자동 세팅
                                                    context.grid.fnAutoSetSamePerson(context.record, context.field);
                                                break;
                                                case "DEFORM_KIND_CODE" :     //장애인 구분에 따라서 장애인 YN, 기본 공제 YN 자동 셋팅

                                                    if(!sAfterValue|| sAfterValue == ''   )   {
                                                        context.record.set("DEFORM_DED_YN", false);
                                                        context.grid.fnAutoSetSamePerson(context.record,"DEFORM_DED_YN");
                                                    } else {
                                                        context.record.set("DEFORM_DED_YN", true);
                                                        context.record.set("DEFAULT_DED_YN", true);
                                                    }

                                                    context.grid.fnAutoSetSamePerson(context.record,context.field);
                                                    context.grid.fnAutoSetSamePerson(context.record,"DEFORM_DED_YN");
                                                    context.grid.fnAutoSetSamePerson(context.record,"DEFAULT_DED_YN");
                                                break;
                                                case "INSUR_CODE":
                                                    if( sAfterValue== "" )   {
                                                        context.record.set("INSUR_USE_I" ,0);
                                                    } else {
                                                        if(!context.record.get("DEFAULT_DED_YN")  )   {
                                                            alert(Msg.fsbMsgH0109);
                                                            context.record.set(context.field ,"");
                                                            sAfterValue = "";
                                                        }

                                                        if( !context.record.get("DEFORM_DED_YN") && context.record.get(context.field)== "2" )   {
                                                            alert(Msg.fsbMsgH0133);
                                                            context.record.set(context.field ,"");
                                                            sAfterValue = "";
                                                        }
                                                    }
                                                break;
                                                case "INSUR_USE_I":
                                                    if(sAfterValue == "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue=0;
                                                    }

                                                    //보험료에 값이 없으면 보험료 구분도 공백으로 만들기
                                                    if( sAfterValue == 0 )   {
                                                        //context.record.set("INSUR_CODE" ,"");
                                                    }

                                                    if(!context.record.get("DEFAULT_DED_YN") )   {
                                                        alert(Msg.fsbMsgH0109);
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }

                                                    if(sAfterValue != "0" && context.record.get("INSUR_CODE") == ""  )   {
                                                        alert(Msg.fsbMsgH0134);
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }
                                                break;
                                                case "MED_USE_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }
                                                break;
                                                case "SURGERY_MED_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }
                                                break;
                                                case "SERIOUS_SICK_MED_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }
                                                break;
                                                case "EDU_CODE":
                                                     if( sAfterValue == "" )   {
                                                         //context.record.set("EDU_USE_I", 0);
                                                         //context.record.set("FIELD_EDUC_I", 0);
                                                     } else {
                                                        if( !context.record.get("DEFORM_DED_YN") && sAfterValue == "5" )   {
                                                            alert(Msg.fsbMsgH0142);
                                                            context.record.set(context.field, "");
                                                            sAfterValue = "";
                                                            context.grid.fnAutoSetSamePerson(context.record,context.field);
                                                            return;
                                                        }

                                                        if(context.record.get('REL_CODE') =='0' && sAfterValue != '1')    {
                                                            alert(Msg.fsbMsgH0140);
                                                            context.record.set(context.field, '');
                                                            sAfterValue ='';
                                                        }
                                                        if(context.record.get('REL_CODE') !='0' && sAfterValue == '1')    {
                                                            alert(Msg.fsbMsgH0141);
                                                            context.record.set(context.field, '');
                                                            sAfterValue ='';
                                                        }
                                                    }
                                                    //context.grid.fnAutoSetSamePerson(context.record,context.field);
                                                break;
                                                case "EDU_USE_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }

                                                    //교육에 값이 없으면 교육료 구분도 공백으로 만들기
//                                                     if(sAfterValue == 0 && context.record.get("FIELD_EDUC_I") == 0)   {
//                                                         context.record.set("EDU_CODE", "");

//                                                     }

                                                    if( sAfterValue != 0 &&  context.record.get("EDU_CODE")   == ""  )   {
                                                        alert(Msg.fsbMsgH0136);
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                        return
                                                    }
                                                break;
                                                case "FIELD_EDUC_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }

                                                    //교육에 값이 없으면 교육료 구분도 공백으로 만들기
//                                                     if(sAfterValue == 0 && context.record.get("EDU_USE_I") == 0)   {
//                                                         context.record.set("EDU_CODE", "");

//                                                     }

                                                    if( sAfterValue != 0 &&  context.record.get("EDU_CODE")   == ""  )   {
                                                        alert(Msg.fsbMsgH0136);
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                        context.grid.fnAutoSetSamePerson(context.record,context.field);
                                                        return;
                                                    }
                                                    
                                                    if(sAfterValue != 0 &&  context.record.get("EDU_CODE")   != "3") {
                                                    	alert("체험학습비는 초중고 교육비인 경우만 입력할 수 있습니다.");
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                        context.grid.fnAutoSetSamePerson(context.record,context.field);
                                                        return;
                                                    }

                                                break;
                                                case "EDU_PRINCIPAL_RTN_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }

                                                    //교육에 값이 없으면 교육료 구분도 공백으로 만들기
//                                                     if(sAfterValue == 0 && context.record.get("EDU_USE_I") == 0)   {
//                                                         context.record.set("EDU_CODE", "");

//                                                     }

                                                    if( sAfterValue != 0 &&  context.record.get("EDU_CODE")   == ""  )   {
                                                        alert(Msg.fsbMsgH0136);
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                        return
                                                    }
                                                    
                                                    if(sAfterValue != 0 &&  context.record.get("REL_CODE")   != "0") {
                                                    	alert("학자금 원리금 상환액은 근로자 본인만 입력할 수 있습니다.");
                                                        sAfterValue = 0;
                                                        context.record.set(context.field, 0);
                                                        context.grid.fnAutoSetSamePerson(context.record,context.field);
                                                        return;
                                                    }

                                                break;
                                                case "UNIFORM_USE_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }

                                                    //교육에 값이 없으면 교육료 구분도 공백으로 만들기
//                                                     if(sAfterValue == 0 && context.record.get("EDU_USE_I") == 0)   {
//                                                         context.record.set("EDU_CODE", "");

//                                                     }

                                                    if( sAfterValue != 0 &&  context.record.get("EDU_CODE")   == ""  )   {
                                                        alert(Msg.fsbMsgH0136);
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                        return
                                                    }

                                                    if(sAfterValue != 0 &&  context.record.get("EDU_CODE")   != "3") {
                                                    	alert("체험학습비는 초중고 교육비인 경우만 입력할 수 있습니다.");
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                        context.grid.fnAutoSetSamePerson(context.record,context.field);
                                                        return;
                                                    }

                                                break;
                                                case "CARD_USE_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }
                                                break;
                                                case "DEBIT_CARD_USE_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }
                                                break;
                                                case  "CASH_USE_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }
                                                break;
                                                case "TRA_MARKET_USE_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }
                                                break;
                                                case  "TRAFFIC_USE_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }
                                                break;
                                                case  "BOOK_CONCERT_CARD_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }
                                                break;
                                                case  "BOOK_CONCERT_CASH_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }
                                                break;
                                                case  "BOOK_CONCERT_DEBIT_I":
                                                    if(sAfterValue ==  "" )   {
                                                        context.record.set(context.field, 0);
                                                        sAfterValue = 0;
                                                    }
                                                break;
                                                case "BIRTH_ADOPT_CODE"://'출산입양자공제
                                                    //'기본공제자 여부 체크
                                                    if( !context.record.get("DEFAULT_DED_YN")  && sAfterValue ) {
                                                        alert(Msg.fsbMsgH0109);
                                                        context.record.set(context.field, '');
                                                        this.fnAutoSetSamePerson(context.record, context.field)
                                                        return;
                                                    }


                                                    var lBirthDay;

                                                    if( gender == "3" || gender == "4" || gender == "7" || gender == "8" ) {
                                                        lBirthDay = parseInt("20" +  context.record.get("REPRE_NUM").substring(0,6));
                                                    }else {
                                                        lBirthDay = parseInt("19" +  context.record.get("REPRE_NUM").substring(0,6));
                                                    }

                                                    if( lBirthDay < parseInt(context.record.get("YEAR_YYYY") + "0101")  && sAfterValue) {
                                                        alert(Msg.fsbMsgH0105);
                                                        context.record.set(context.field, '');
                                                        this.fnAutoSetSamePerson(context.record, context.field);
                                                        return;
                                                    }
                                                    this.fnAutoSetSamePerson(context.record, context.field);
                                                    context.record.set("BIRTH_ADOPT_DED_YN", !Ext.isEmpty(sAfterValue));
                                                    this.fnAutoSetSamePerson(context.record, "BIRTH_ADOPT_DED_YN");
                                                break;

                                                default:
                                                break;
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
                                handler: function() {
                                    var store = Ext.data.StoreManager.lookup('had960ukrStore') ;
                                    if(store.isDirty())    {
                                        store.saveStore();
                                    }
                                },
                                disabled: false
                            },{
                                itemId : 'closeBtn',
                                text: '닫기',
                                width:100,
                                handler: function() {
                                    familyWin.hide();

                                },
                                disabled: false
                            }
                        ]
                    },
                    listeners : {
                        beforehide: function(me, eOpt)    {
                            if(familyWin.changes)    {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                            familyWin.down('#search').clearForm();

                        },
                        beforeclose: function( panel, eOpts )    {
                            if(familyWin.changes) {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                            familyWin.down('#search').clearForm();
                        },
                        beforeshow: function( panel, eOpts )    {
                            var searchForm =  familyWin.down('#search');
                            searchForm.setValue("YEAR_YYYY"        ,familyWin.paramData.YEAR_YYYY);
                            searchForm.setValue("NAME"            ,familyWin.paramData.NAME);
                            searchForm.setValue("PERSON_NUMB"    ,familyWin.paramData.PERSON_NUMB);
                            searchForm.setValue("DEPT_NAME"        ,familyWin.paramData.DEPT_NAME);
                            searchForm.setValue("POST_CODE_NAME",familyWin.paramData.POST_CODE_NAME);
                            had960ukrStore.loadStoreRecords();
                            var grid = Ext.getCmp('had960ukrGrid');
                            console.log("grid.getColumns()", grid.getColumns());

                            var info = Ext.getCmp("info_gr");
                            var ins = Ext.getCmp("insur_gr");
                            var med = Ext.getCmp("med_gr");
                            var med2 = Ext.getCmp("med_gr2");
                            var med3 = Ext.getCmp("med_gr3");
                            var edu = Ext.getCmp("edu_gr");
                            var cred = Ext.getCmp("credit_gr");
                            switch(familyWin.openType)    {
                                case 'P': // 인적공제
                                    info.show();
                                    ins.hide();
                                    med.hide();
                                    med2.hide();
                                    med3.hide();
                                    edu.hide();
                                    cred.hide();
                                    grid.getColumn("DEFAULT_DED_YN").show();
                                    grid.getColumn("HOUSEHOLDER_YN").show();
                                    grid.getColumn("DEFORM_DED_YN").hide();
                                    grid.getColumn("DEFORM_KIND_CODE").show();
                                    //grid.getColumn("BRING_CHILD_DED_YN").show();
                                    grid.getColumn("WOMAN_DED_YN").show();
                                    grid.getColumn("ONE_PARENT_DED_YN").show();
                                    grid.getColumn("OLD_DED_YN").show();
                                    //grid.getColumn("MANY_CHILD_DED_YN").show();
                                    grid.getColumn("BIRTH_ADOPT_DED_YN").show();
                                    grid.getColumn("BIRTH_ADOPT_CODE").show();

                                    grid.getColumn("DEFAULT_DED_YN").setDisabled(false);
                                    grid.getColumn("DEFORM_DED_YN").setDisabled(false);
                                    grid.getColumn("OLD_DED_YN").setDisabled(false);

                                break;
                                case 'I': //기타보장성보험
                                    info.show();
                                    ins.show();
                                    med.hide();
                                    med2.hide();
                                    med3.hide();
                                    edu.hide();
                                    cred.hide();
                                    grid.getColumn("DEFAULT_DED_YN").show();
                                    grid.getColumn("HOUSEHOLDER_YN").hide();
                                    grid.getColumn("DEFORM_KIND_CODE").hide();
                                    grid.getColumn("DEFORM_DED_YN").show();
                                    //grid.getColumn("BRING_CHILD_DED_YN").hide();
                                    grid.getColumn("WOMAN_DED_YN").hide();
                                    grid.getColumn("ONE_PARENT_DED_YN").hide();
                                    grid.getColumn("OLD_DED_YN").hide();
                                    //grid.getColumn("MANY_CHILD_DED_YN").hide();
                                    grid.getColumn("BIRTH_ADOPT_DED_YN").hide();
                                    grid.getColumn("BIRTH_ADOPT_CODE").hide();
                                    grid.getColumn("INSUR_USE_I").setWidth(270);

                                    grid.getColumn("DEFAULT_DED_YN").setDisabled(true);
                                    grid.getColumn("DEFORM_DED_YN").setDisabled(true);
                                    grid.getColumn("OLD_DED_YN").setDisabled(true);
                                break;
                                case 'M': //의료비
                                    info.show();
                                    ins.hide();
                                    med.show();
                                    med2.show();
                                    med3.show();
                                    edu.hide();
                                    cred.hide();
                                    grid.getColumn("DEFAULT_DED_YN").show();
                                    grid.getColumn("HOUSEHOLDER_YN").hide();
                                    grid.getColumn("DEFORM_DED_YN").show();
                                    grid.getColumn("DEFORM_KIND_CODE").hide();
                                    //grid.getColumn("BRING_CHILD_DED_YN").hide();
                                    grid.getColumn("WOMAN_DED_YN").hide();
                                    grid.getColumn("ONE_PARENT_DED_YN").hide();
                                    grid.getColumn("OLD_DED_YN").show();
                                    //grid.getColumn("MANY_CHILD_DED_YN").hide();
                                    grid.getColumn("BIRTH_ADOPT_DED_YN").hide();
                                    grid.getColumn("BIRTH_ADOPT_CODE").hide();
                                    grid.getColumn("BIRTH_ADOPT_CODE").setWidth(200);

                                    grid.getColumn("DEFAULT_DED_YN").setDisabled(true);
                                    grid.getColumn("DEFORM_DED_YN").setDisabled(true);
                                    grid.getColumn("OLD_DED_YN").setDisabled(true);

//                                     var editor = grid.getColumn("DEFAULT_DED_YN").editor;

//                                     if(editor == null) {
//                                     	grid.getColumn("DEFAULT_DED_YN").setDisabled(false);
//                                     	grid.getColumn("DEFAULT_DED_YN").getEditor().setReadOnly(true);
//                                     }
//                                     else {
//                                     	grid.getColumn("DEFAULT_DED_YN").setDisabled(true);
//                                     }
                                break;
                                case 'E': //교육비
                                    info.hide();
                                    ins.hide();
                                    med.hide();
                                    med2.hide();
                                    med3.hide();
                                    edu.show();
                                    cred.hide();
                                    grid.getColumn("EDU_PRINCIPAL_RTN_I").setWidth(200);
                                break;
                                case 'C': //신용카드
                                    info.hide();
                                    ins.hide();
                                    med.hide();
                                    med2.hide();
                                    med3.hide();
                                    edu.hide();
                                    cred.show();
                                    grid.getColumn("TRAFFIC_USE_I").setWidth(150);
                                break;
                                default:
                                break;
                            }
                            //20190117 교육비 내역 입력 팝업 그리드 validator 선언
                           var validationEdu = Unilite.createValidator('validatorEdu', {
                                store: Ext.getCmp('had960ukrGrid').getStore(),
                                grid: Ext.getCmp('had960ukrGrid'),
                                validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
                                    if(newValue == oldValue){
                                        return false;
                                    }
                                    console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
                                    var rv = true;
                                    switch(fieldName) {
                                        case "DEFORM_EDU_USE_I" :
                                        	if(!record.get("DEFORM_DED_YN")){
                                        		alert('장애인 교육비는 장애인 공제여부가 공제(Y)인 경우에만 수정 가능합니다.');
                                        		 rv = false;
												break;
                                        	}
                                    }
                                    return rv;
                                }
                            }); // validator
                        }
                    }
                });
            }

        	var addBtn = familyWin.down('#familyWin-add');
        	var deleteBtn = familyWin.down('#familyWin-delete');
        	var lastYearBtn = familyWin.down('#familyWin-lastYear');

        	if(addBtn) 		addBtn.setDisabled(false);
        	if(deleteBtn) 	deleteBtn.setDisabled(false);
        	if(lastYearBtn) lastYearBtn.setDisabled(false);
            if(openType == 'C')	{
            	familyWin.setTitle("신용카드 등");
            	if(addBtn) 		addBtn.setDisabled(true);
            	if(deleteBtn) 	deleteBtn.setDisabled(true);
            	if(lastYearBtn) lastYearBtn.setDisabled(true);
            } else if(openType == 'I')	{
            	familyWin.setTitle("기타보험료/장애자전용보장성보험");
            } else if(openType == 'M')	{
            	familyWin.setTitle("의료비");
            	if(addBtn) 		addBtn.setDisabled(true);
            	if(deleteBtn) 	deleteBtn.setDisabled(true);
            	if(lastYearBtn) lastYearBtn.setDisabled(true);
            } else if(openType == 'E')	{
            	familyWin.setTitle("교육비");
            	if(addBtn) 		addBtn.setDisabled(true);
            	if(deleteBtn) 	deleteBtn.setDisabled(true);
            	if(lastYearBtn) lastYearBtn.setDisabled(true);
            }else {
            	familyWin.setTitle("인적공제항목");
            }


            familyWin.openType = openType;
            familyWin.paramData = paramData;
            familyWin.changes = false;
            familyWin.center();
            familyWin.show();

        }
        ,
        //개인연금저축
        openPersonalPension:function(openType)    {
        	var infoForm400 = Ext.getCmp("infoForm400");
            if(UniUtils.indexOf(openType, ["31","32","34","35","36"])
            	&& !infoForm400.getValue("HOUSEHOLDER_YN"))	{				// 그밖소득공제-주택마련은 세대주가 아니면 팝업 사용 못함
            	alert("세대주인 경우만 공제내역을 입력할 수 있습니다.");
            	return ;
            }

            //  2018.11.18 / 개발팀 이정현 추가 / 2018년 귀속 연말정산 세법변경으로 인함.
            var baseForm400 = Ext.getCmp("baseForm400");
            if(UniUtils.indexOf(openType, ["31","32","34","35","36"]) && baseForm400.getValue("INCOME_SUPP_TOTAL_I") > 70000000) {
            	alert("총급여액이 7천만원 이하인 경우만 공제내역을 입력할 수 있습니다.");
            	return;
            }

            if(!panelSearch.isValid())    {
                return;
            }

            var paramData = {
                'YEAR_YYYY'        : panelSearch.getValue('YEAR_YYYY'),
                'PERSON_NUMB'    : panelSearch.getValue('PERSON_NUMB'),
                'NAME'            : panelSearch.getValue('NAME'),
                'DEPT_NAME'        : panelSearch.getValue('DEPT_NAME'),
                'POST_CODE_NAME'        : panelSearch.getValue('POST_CODE_NAME')
            };
            if(!personalPensionWin)    {

                Unilite.defineModel('had460ukrModel', {
                    fields: [
                        {name: 'PERSON_NUMB'    , text: '사번'                , type: 'string', allowBlank:false},
                        {name: 'NAME'            , text: '성명'                , type: 'string'},
                        {name: 'YEAR_YYYY'        , text: '정산년도'            , type: 'string', allowBlank:false},
                        {name: 'PERSON_NAME'    , text: '사원명'            , type: 'string'},
                        {name: 'INCM_DDUC_CD'    , text: '소득공제구분'        , type: 'string', allowBlank:false, comboType:'AU', comboCode:'H150'},
                        {name: 'BANK_CODE'        , text: '금융기관'            , type: 'string', allowBlank:false, comboType:'AU', comboCode:'H152'},
                        {name: 'BANK_ACCOUNT'    , text: '계좌번호'            , type: 'string', allowBlank:false},

                        {name: 'PAY_YRLV'        , text: '납입연차'            , type: 'string', allowBlank:false, comboType:'AU', comboCode:'H151', defaultValue:'00'},
                        {name: 'PAY_I'            , text: '불입액'            , type: 'uniPrice', minValue:0},
                        {name: 'DDUC_I'            , text: '공제금액'            , type: 'uniPrice'}
                     ]
                });
                var had460ukrStore = Unilite.createStore('had460ukrStore',{

                    model: 'had460ukrModel',
                    uniOpt : {
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
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
                    saveStore:function()    {
                        var toCreate = this.getNewRecords();
                           var toUpdate = this.getUpdatedRecords();
                           var toDelete = this.getRemovedRecords();
                           var list = [].concat(toUpdate, toCreate);

                           var checkValid = true;
                        Ext.each(list, function(record, index) {
                            // 비과세분 입력시 비과세 코드 입력 체크
                            if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
                                alert(Msg.sMH1065 +'\n'+ Msg.fstMsgH0098);
                                checkValid = false;
                                return;
                            }
                        })
                        if(!checkValid)    {
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
                    title: '개인연금저축공제',
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
		            		                expandLastColumn: false,    //마지막 컬럼 * 사용 여부
		            		                useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
		            		                useLiveSearch: false,        //찾기 버튼 사용 여부
		            		                filter: {                    //필터 사용 여부
		            		                    useFilter: false,
		            		                    autoCreate: false
		            		                },
		            		                state: {
		            		                    useState: false,            //그리드 설정 버튼 사용 여부
		            		                    useStateList: false        //그리드 설정 목록 사용 여부
		            		                }
		            		            },
		            		            tbar:[
		            		                '->',
		            		                {
		            		                    xtype:'button',
		            		                    text:'추가',
		            		                    handler:function()    {
		            		                        var form = personalPensionWin.down('#search');
		            		                        var grid = Ext.getCmp('had460ukrGrid');
		            		                        var record = Ext.create(had460ukrStore.model);
		            		                        rIndex = had460ukrStore.count();
		            		                        record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
		            		                        record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
		            		                        record.set("INCM_DDUC_CD",personalPensionWin.openType);
		            		                        had460ukrStore.insert(rIndex, record);
		            		                        grid.getSelectionModel().select(rIndex);
		            		                    }
		            		                },{
		            		                    xtype:'button',
		            		                    text:'삭제',
		            		                    handler:function()    {
		            		                        var grid = Ext.getCmp('had460ukrGrid');
		            		                        had460ukrStore.remove(grid.getSelectionModel().getSelection());
		            		                    }
		            		                }
		            		            ],
		            		            columns:  [
		            		                {dataIndex: 'INCM_DDUC_CD'    , width: 130},
		            		                {dataIndex: 'BANK_CODE'        , width: 130},
		            		                {dataIndex: 'BANK_ACCOUNT'    , width: 150},
		            		                {dataIndex: 'PAY_YRLV'        , width: 100},
		            		                {dataIndex: 'PAY_I'            , flex: 1}
		            		            ],
		            		            listeners:{
		            		                beforeedit:function(editor, context, eOpts)    {
		            		                    if(context.field == "INCM_DDUC_CD" && !Ext.isEmpty(personalPensionWin.openType))    {
		            		                        return false;
		            		                    }
		            		                    if(context.field == "PAY_YRLV" &&  personalPensionWin.openType != '51')    {
		            		                        return false;
		            		                    }
		            		                },
		            		                edit:function(editor, context, eOpts)    {
		            		                    if(context.field == "PAY_YRLV")    {
		            		                        if(context.record.get("INCM_DDUC_CD") == "41" && context.value == "00")    {
		            		                            alert(Msg.fsbMsgH0306);
		            		                            context.record(context.field, "");
		            		                            return;
		            		                        }
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
                                handler: function() {
                                    var store = Ext.data.StoreManager.lookup('had460ukrStore') ;
                                    if(store.isDirty())    {
                                        store.saveStore();
                                    }
                                },
                                disabled: false
                            },{
                                itemId : 'closeBtn',
                                text: '닫기',
                                width:100,
                                handler: function() {
                                    personalPensionWin.hide();

                                },
                                disabled: false
                            }
                        ]
                    },
                    listeners : {
                        beforehide: function(me, eOpt)    {
                            personalPensionWin.down('#search').clearForm();
                            had460ukrStore.loadData({});
                            had460ukrStore.commitChanges();
                            if(personalPensionWin.changes)    {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                            personalPensionWin.openType = '';
                        },
                        beforeclose: function( panel, eOpts )    {
                            personalPensionWin.down('#search').clearForm();
                            had460ukrStore.loadData({});
                            had460ukrStore.commitChanges();
                            if(personalPensionWin.changes) {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                            personalPensionWin.openType = '';
                        },
                        beforeshow: function( panel, eOpts )    {
                            var searchForm =  personalPensionWin.down('#search');
                            searchForm.setValue("YEAR_YYYY"        ,personalPensionWin.paramData.YEAR_YYYY);
                            searchForm.setValue("NAME"            ,personalPensionWin.paramData.NAME);
                            searchForm.setValue("PERSON_NUMB"    ,personalPensionWin.paramData.PERSON_NUMB);
                            searchForm.setValue("DEPT_NAME"        ,personalPensionWin.paramData.DEPT_NAME);
                            searchForm.setValue("POST_CODE_NAME",personalPensionWin.paramData.POST_CODE_NAME);
                            had460ukrStore.loadStoreRecords();

                        }
                    }
                });
            }
            personalPensionWin.openType = openType;
            personalPensionWin.paramData = paramData;
            personalPensionWin.changes = false;
            personalPensionWin.center();
            personalPensionWin.show();


        },
        //의료비내경 입력
        openMedDoc:function( )    {

            if(!panelSearch.isValid())    {
                return;
            }
            var paramData = {
                'YEAR_YYYY'        : panelSearch.getValue('YEAR_YYYY'),
                'PERSON_NUMB'    : panelSearch.getValue('PERSON_NUMB'),
                'NAME'            : panelSearch.getValue('NAME'),
                'DEPT_NAME'        : panelSearch.getValue('DEPT_NAME'),
                'POST_CODE_NAME'        : panelSearch.getValue('POST_CODE_NAME')
            };
            if(!medDocWin)    {

                Unilite.defineModel('had410ukrModel', {
                    fields: [
                        {name: 'PERSON_NUMB'        , text: '사번'                , type: 'string', allowBlank:false},
                        {name: 'NAME'                , text: '성명'                , type: 'string'},
                        {name: 'YEAR_YYYY'            , text: '정산년도'            , type: 'string', allowBlank:false},
                        {name: 'PERSON_NAME'        , text: '사원명'            , type: 'string'},
                        {name: 'SEQ_NUM'            , text: '순번'                , type: 'uniNumber'},
                        {name: 'REPRE_NUM'            , text: '주민번호'            , type: 'string', allowBlank:false},

                        {name: 'MED_CODE'            , text: '공제항목'            , type: 'string', allowBlank:false, comboType:'AU', comboCode:'H116'},
                        {name: 'MED_PROOF_CODE'        , text: '의료증빙코드'        , type: 'string', allowBlank:false, comboType:'AU', comboCode:'H139'},
                        {name: 'TAX_GU'                , text: '영수증구분'        , type: 'string', comboType:'AU', comboCode:'H120'},
                        {name: 'DEFAULT_DED_YN'        , text: '기본공제여부'        , type: 'string'},

                        {name: 'SEND_NUM'            , text: '건수'                , type: 'uniNumber', minValue:0, allowBlank:false},
                        {name: 'SEND_USE_I'            , text: '지급금액'            , type: 'uniPrice', allowBlank:false},
                        {name: 'MED_COMPANY_NUM'    , text: '사업자번호'        , type: 'string'},

                        {name: 'MED_RELATION'        , text: '관계'                , type: 'string', allowBlank:false, comboType:'AU', comboCode:'H115'},
                        {name: 'IN_FORE_SUPP'        , text: '내외국인구분'        , type: 'string', comboType:'AU', comboCode:'H118'},
                        {name: 'TAX_GU_ORGIN'        , text: '영수증구분(OLD)'    , type: 'string', comboType:'AU', comboCode:'H120'},
                        {name: 'MED_COMPANY_NAME'    , text: '상호'                , type: 'string'},
                        {name: 'FAMILY_NAME'            , text: '가족성명'            , type: 'string'},
                        {name: 'DEFORM_DED_YN'            , text: '장애인공제여부'            , type: 'string'}

                     ]
                });
                var had410ukrStore = Unilite.createStore('had410ukrStore',{

                    model: 'had410ukrModel',
                    uniOpt : {
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
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
                    saveStore:function()    {
                        var inValidRecs = this.getInvalidRecords();
                        console.log("inValidRecords : ", inValidRecs);
                        if(inValidRecs.length == 0) {
                            config = {
                                        //params: [paramMaster],
                                        success: function(batch, option) {
                                            medDocWin.changes = true;
                                            // 난임수술비, 의료비 반영
                                            //had618ukrService.updateMedI(medDocWin.paramData, function(){
                                            	medDocWin.unmask();
                                            //})
                                        }
                                };
                            //medDocWin.mask();
                            this.syncAllDirect(config);
                        } else {
                            var grid = Ext.getCmp('had410ukrGrid');
                            grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                        }
                    }

                });

                medDocWin= Ext.create('widget.uniDetailWindow', {
                    title: '의료비내역',
                    width: 800,
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
                            }]},{
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
                            }]},{
                            xtype:'container',
                            flex:1,
                            layout: {type:'vbox', align:'stretch'},
                            items:[
                                Unilite.createGrid('had410ukrGrid', {
                                    layout : 'fit',
                                    store : had410ukrStore,
                                    sortableColumns: true,
                                    uniOpt:{
                                        expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                        useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                        useLiveSearch: false,        //찾기 버튼 사용 여부
                                        filter: {                    //필터 사용 여부
                                            useFilter: false,
                                            autoCreate: false
                                        },
                                        state: {
                                            useState: false,            //그리드 설정 버튼 사용 여부
                                            useStateList: false        //그리드 설정 목록 사용 여부
                                        }
                                    },
                                    tbar:[
                                        '->',
                                        {
                                            xtype:'button',
                                            text:'추가',
                                            handler:function()    {
                                                var form = medDocWin.down('#search');
                                                var grid = Ext.getCmp('had410ukrGrid');
                                                var record = Ext.create(had410ukrStore.model);
                                                rIndex = had410ukrStore.count();
                                                var seq = Unilite.nvl(had410ukrStore.max("SEQ_NUM"),0) + 1;
                                                record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
                                                record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
                                                record.set("SEQ_NUM",seq);
                                                had410ukrStore.insert(rIndex, record);
                                                grid.getSelectionModel().select(rIndex);
                                            }
                                        },{
                                            xtype:'button',
                                            text:'삭제',
                                            handler:function()    {
                                                var grid = Ext.getCmp('had410ukrGrid');
                                                had410ukrStore.remove(grid.getSelectionModel().getSelection());
                                            }
                                        }
                                    ],
                                    features: [
                                        { ftype: 'uniSummary',          showSummaryRow: true, dock :'bottom'}
                                    ],
                                    columns:  [
                                        {dataIndex: 'REPRE_NUM'    , width: 130,
                                        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                                                  return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
                                            }
                                        },
                                        {dataIndex: 'FAMILY_NAME'    , width: 100},
                                        {dataIndex: 'MED_CODE'        , width: 130},
                                        {dataIndex: 'MED_PROOF_CODE'    , width: 150},
                                        {dataIndex: 'SEND_NUM'        	, width: 100, summaryType:'sum'},
                                        {dataIndex: 'SEND_USE_I'        , width: 100, summaryType:'sum'},
                                        {dataIndex: 'MED_COMPANY_NUM'        , width: 100},
                                        {dataIndex: 'DEFORM_DED_YN'        , width: 50, hidden: true},
                                        {dataIndex: 'MED_COMPANY_NAME'            , flex: 1}

                                    ],
                                    listeners:{
                                        beforeedit:function(editor, context, eOpts)    {
                                            if(context.field == "REPRE_NUM" )    {
                                                context.grid.fnFamilyPopUp(context.record);
                                                return false;
                                            }else if(context.field == "DEFORM_DED_YN"){
                                            	return false;
                                            }
                                        },
                                        edit:function(editor, context, eOpts)    {
                                            if(context.field == "MED_COMPANY_NUM" && context.record.phantom)    {
                                                if(context.value != "" && context.record.get("TAX_GU") == "1")    {
                                                    alert(Msg.fsbMsgH0148);
                                                    context.record.set(context.field, "");
                                                    return;
                                                }
                                                if(context.value == "" && context.record.get("TAX_GU") == "2")    {
                                                    alert(Msg.fsbMsgH0115);
                                                    context.record.set(context.field, "");
                                                    return;
                                                }
                                                return;
                                            }
                                            if(context.field == "MED_PROOF_CODE")    {
                                                if(context.value == "1" )    {
                                                    context.record.set("TAX_GU", "1");
                                                }else {
                                                    context.record.set("TAX_GU", "2");
                                                }
                                                return;
                                            }

                                        },
                                        onGridDblClick:function(grid, record, cellIndex, colName)    {
                                            if(colName == "REPRE_NUM")    {
                                                grid.ownerCt.ownerGrid.fnFamilyPopUp(record);
                                            }
                                        }
                                    },
                                    fnFamilyPopUp:function(record){
                                        var me = this;

                                        var paramData = {
                                            'YEAR_YYYY'        : record.get('YEAR_YYYY'),
                                            'PERSON_NUMB'    : record.get('PERSON_NUMB'),
                                            'NAME'            : record.get('NAME'),
                                            'DEPT_NAME'        : record.get('DEPT_NAME'),
                                            'POST_NAME'        : record.get('POST_NAME')
                                        };
                                        if(!me.familyPopupWin)    {

                                            if(!me.familyPopupWin)    {

                                                Unilite.defineModel('humanFamilyPopupModel', {
                                                    fields: [
                                                        {name: 'FAMILY_NAME'        , text: '가족성명'        , type: 'string'},
                                                        {name: 'REPRE_NUM'            , text: '주민등록번호'    , type: 'string'},
                                                        {name: 'REL_NAME'            , text: '관계'            , type: 'string'},
                                                        {name: 'IN_FORE_NAME'        , text: '내외국인'        , type: 'string'},
                                                        {name: 'REL_CODE'            , text: '관계'            , type: 'string'},
                                                        {name: 'IN_FORE'            , text: '내외국인'        , type: 'string'},
                                                        {name: 'DEFAULT_DED_YN'        , text: '기본공제'        , type: 'string'},
                                                        {name: 'DEFORM_DED_YN'        , text: '장애인'        , type: 'string'},
                                                        {name: 'OLD_DED_YN'            , text: '경로우대'        , type: 'string'}

                                                     ]
                                                });
                                                var humanFamilyPopupStore = Unilite.createStore('humanFamilyPopupStore',{

                                                    model: 'humanFamilyPopupModel',
                                                    uniOpt : {
                                                        isMaster: false,            // 상위 버튼 연결
                                                        editable: false,        // 수정 모드 사용
                                                        deletable: false,        // 삭제 가능 여부
                                                        useNavi: false            // prev | newxt 버튼 사용
                                                    },
                                                    autoLoad: false,
                                                    proxy: {
                                                        type: 'uniDirect',
                                                        api: {
                                                            read : 'had618ukrService.selectFamliy'
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
                                                                Unilite.createGrid('humanFamilyPopupGrid', {
                                                                    itemId:'humanFamilyPopupGrid',
                                                                    layout : 'fit',
                                                                    store : humanFamilyPopupStore,
                                                                    sortableColumns: false,
                                                                    selModel:'rowmodel',
                                                                    uniOpt:{
                                                                        expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                                                        useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                                                        useLiveSearch: false,        //찾기 버튼 사용 여부
                                                                        filter: {                    //필터 사용 여부
                                                                            useFilter: false,
                                                                            autoCreate: false
                                                                        },
                                                                        state: {
                                                                            useState: false,            //그리드 설정 버튼 사용 여부
                                                                            useStateList: false        //그리드 설정 목록 사용 여부
                                                                        }
                                                                    },
                                                                    columns:  [
                                                                        {dataIndex: 'FAMILY_NAME'    , width: 100},
                                                                        {dataIndex: 'REPRE_NUM'        , width: 130},

                                                                        {dataIndex: 'REL_NAME'        , width: 80},
                                                                        {dataIndex: 'IN_FORE_NAME'    , width: 80},
                                                                        {dataIndex: 'DEFAULT_DED_YN', width: 80},
                                                                        {dataIndex: 'DEFORM_DED_YN'    , width: 80},
                                                                        {dataIndex: 'OLD_DED_YN'    , width: 80}
                                                                    ],
                                                                    listeners:{
                                                                        onGridDblClick:function(view, record, cellIndex, colName){
                                                                            var grid = me.familyPopupWin.down("#humanFamilyPopupGrid")
                                                                            var selRecord = grid.getSelectedRecord();
                                                                            var medDocGrid = medDocWin.down("#had410ukrGrid")
                                                                            var medDocRecord = medDocGrid.getSelectedRecord();

                                                                            if(selRecord)    {

                                                                                medDocRecord.set("REPRE_NUM", selRecord.get("REPRE_NUM"));
                                                                                medDocRecord.set("FAMILY_NAME", selRecord.get("FAMILY_NAME"));

                                                                                var sexChar = selRecord.get("REPRE_NUM").replace("-","").substring(6, 7);
                                                                                var dYear = 0;
                                                                                if(UniUtils.indexOf(sexChar, ["1", "2", "5", "6"]))    {
                                                                                    dYear = parseInt(me.familyPopupWin.paramData.YEAR_YYYY) - parseInt("19"+selRecord.get("REPRE_NUM").substring(0,2));
                                                                                }else {
                                                                                    dYear = parseInt(me.familyPopupWin.paramData.YEAR_YYYY) - parseInt("20"+selRecord.get("REPRE_NUM").substring(0,2));
                                                                                }
                                                                                if(dYear >= 65)    {
                                                                                    strOldMedYn ="Y";
                                                                                }else {
                                                                                    strOldMedYn ="N";
                                                                                }

                                                                                if(selRecord.get("REL_CODE") == "0")    {
                                                                                    medDocRecord.set("MED_CODE", "S");
                                                                                }else if(strOldMedYn=="Y")    {
                                                                                    medDocRecord.set("MED_CODE", "L");
                                                                                }else if(selRecord.get("DEFORM_DED_YN") == "Y")    {
                                                                                    medDocRecord.set("MED_CODE", "D");
                                                                                }else {
                                                                                    medDocRecord.set("MED_CODE", "M");
                                                                                }
//                                                                                 if(selRecord.get("DEFAULT_DED_YN") != "Y" && selRecord.get("REL_CODE")=="")    {
//                                                                                     medDocRecord.set("MED_CODE", "S");
//                                                                                 }else if(selRecord.get("DEFAULT_DED_YN") != "Y" && strOldMedYn=="Y")    {
//                                                                                     medDocRecord.set("MED_CODE", "L");
//                                                                                 }else if(selRecord.get("DEFAULT_DED_YN") == "Y")    {
//                                                                                     medDocRecord.set("MED_CODE", "D");
//                                                                                 }else {
//                                                                                     medDocRecord.set("MED_CODE", "M");
//                                                                                 }
                                                                                medDocRecord.set("MED_RELATION", selRecord.get("REL_CODE"));
                                                                                medDocRecord.set("IN_FORE_SUPP", selRecord.get("IN_FORE"));
                                                                                medDocRecord.set("DEFAULT_DED_YN", selRecord.get("DEFAULT_DED_YN"));
                                                                                me.familyPopupWin.hide();
                                                                            }else {
                                                                                medDocRecord.set("REPRE_NUM", "");
                                                                                medDocRecord.set("FAMILY_NAME", "");
                                                                            }

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

                                                                    if(selRecord)    {

                                                                        medDocRecord.set("REPRE_NUM", selRecord.get("REPRE_NUM"));
                                                                        medDocRecord.set("FAMILY_NAME", selRecord.get("FAMILY_NAME"));

                                                                        var sexChar = selRecord.get("REPRE_NUM").replace("-","").substring(6, 7);
                                                                        var dYear = 0;
                                                                        if(UniUtils.indexOf(sexChar, ["1", "2", "5", "6"]))    {
                                                                            dYear = parseInt(me.familyPopupWin.paramData.YEAR_YYYY) - parseInt("19"+selRecord.get("REPRE_NUM").substring(0,2));
                                                                        }else {
                                                                            dYear = parseInt(me.familyPopupWin.paramData.YEAR_YYYY) - parseInt("20"+selRecord.get("REPRE_NUM").substring(0,2));
                                                                        }
                                                                        if(dYear >= 65)    {
                                                                            strOldMedYn ="Y";
                                                                        }else {
                                                                            strOldMedYn ="N";
                                                                        }

                                                                        if(selRecord.get("DEFAULT_DED_YN") != "Y" && selRecord.get("REL_CODE")=="")    {
                                                                            medDocRecord.set("MED_CODE", "S");
                                                                        }else if(selRecord.get("DEFAULT_DED_YN") != "Y" && strOldMedYn=="Y")    {
                                                                            medDocRecord.set("MED_CODE", "L");
                                                                        }else if(selRecord.get("DEFAULT_DED_YN") == "Y")    {
                                                                            medDocRecord.set("MED_CODE", "D");
                                                                        }else {
                                                                            medDocRecord.set("MED_CODE", "M");
                                                                        }
                                                                        medDocRecord.set("MED_RELATION", selRecord.get("REL_CODE"));
                                                                        medDocRecord.set("IN_FORE_SUPP", selRecord.get("IN_FORE"));
                                                                        medDocRecord.set("DEFAULT_DED_YN", selRecord.get("DEFAULT_DED_YN"));
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
                                                    ]
                                                    ,
                                                    listeners : {
                                                        beforehide: function(me, eOpt)    {
                                                            me.down('#search').clearForm();
                                                        },
                                                        beforeclose: function( panel, eOpts )    {
                                                            me.down('#search').clearForm();
                                                        },
                                                        beforeshow: function( panel, eOpts )    {
                                                            var searchForm =  panel.down('#search');
                                                            searchForm.setValue("YEAR_YYYY"        ,me.familyPopupWin.paramData.YEAR_YYYY);
                                                            searchForm.setValue("NAME"            ,me.familyPopupWin.paramData.NAME);
                                                            searchForm.setValue("PERSON_NUMB"    ,me.familyPopupWin.paramData.PERSON_NUMB);
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
                        items :  [
                             {
                                itemId : 'submitBtn',
                                text: '저장',
                                width:100,
                                handler: function() {
                                    var store = Ext.data.StoreManager.lookup('had410ukrStore') ;
                                    if(store.isDirty())    {
                                        store.saveStore();
                                    }
                                },
                                disabled: false
                            },{
                                itemId : 'closeBtn',
                                text: '닫기',
                                width:100,
                                handler: function() {
                                    medDocWin.hide();

                                },
                                disabled: false
                            }
                        ]
                    },
                    listeners : {
                        beforehide: function(me, eOpt)    {
                            medDocWin.down('#search').clearForm();
                            if(medDocWin.changes)    {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        beforeclose: function( panel, eOpts )    {
                            medDocWin.down('#search').clearForm();
                            if(medDocWin.changes) {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        beforeshow: function( panel, eOpts )    {
                            var searchForm =  medDocWin.down('#search');
                            searchForm.setValue("YEAR_YYYY"        ,medDocWin.paramData.YEAR_YYYY);
                            searchForm.setValue("NAME"            ,medDocWin.paramData.NAME);
                            searchForm.setValue("PERSON_NUMB"    ,medDocWin.paramData.PERSON_NUMB);
                            searchForm.setValue("DEPT_NAME"        ,medDocWin.paramData.DEPT_NAME);
                            searchForm.setValue("POST_CODE_NAME",medDocWin.paramData.POST_CODE_NAME);
                            had410ukrStore.loadStoreRecords();
                            had410ukrService.selectCheck200(searchForm.getValues(), function(responseText, response)    {
                                var payForm =  panel.down('#summary');
                                if(responseText)    {
                                    payForm.setValue("AMT_PAY", responseText.TaxAmount);
                                    payForm.setValue("MED_DED_I", responseText.MedAmount);
                                }
                            });

                            //20190123 의료비내역 입력 팝업 그리드 validator
                            var validationMed = Unilite.createValidator('validatorMed', {
                                store: Ext.getCmp('had410ukrGrid').getStore(),
                                grid: Ext.getCmp('had410ukrGrid'),
                                validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
                                    if(newValue == oldValue){
                                        return false;
                                    }
                                    console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
                                    var rv = true;
                                    switch(fieldName) {
                                        case "MED_CODE" :
//                                         	var medCode = record.get(fieldName);
                                        	
//                                         	//if(!record.get("DEFORM_DED_YN")){
//                                         	 alert('장애인 교육비는 장애인 공제여부가 공제(Y)인 경우에만 수정 가능합니다.');
//                                         	 rv = false;
												break;
                                        	//}
                                    }
                                    return rv;
                                }
                            }); // validator
                        }
                    }
                });
            }
            medDocWin.paramData = paramData;
            medDocWin.changes = false;
            medDocWin.center();
            medDocWin.show();


        },
        //기부금내역 입력
        openDonation:function()    {


            if(!panelSearch.isValid())    {
                return;
            }
            var paramData = {
                'YEAR_YYYY'		: panelSearch.getValue('YEAR_YYYY'),
                'PERSON_NUMB'	: panelSearch.getValue('PERSON_NUMB'),
                'NAME'			: panelSearch.getValue('NAME'),
                'DEPT_NAME'		: panelSearch.getValue('DEPT_NAME'),
                'POST_CODE_NAME': panelSearch.getValue('POST_CODE_NAME'),
                'REPRE_NUM'		: panelSearch.getValue('REPRE_NUM'),
                'LIVE_GUBUN'	: panelSearch.getValue('LIVE_GUBUN')
            };
            if(!donationWin)    {

                Unilite.defineModel('had420ukrModel', {
                    fields: [
                        {name: 'PERSON_NUMB'        	, text: '사번'                	, type: 'string', allowBlank:false},
                        {name: 'NAME'                	, text: '성명'                	, type: 'string'},
                        {name: 'YEAR_YYYY'            	, text: '정산년도'            	, type: 'string', allowBlank:false},
                        {name: 'PERSON_NAME'        	, text: '사원명'            	, type: 'string'},
                        {name: 'IN_FORE'            	, text: '내외국인'            	, type: 'string', comboType:'AU', comboCode:'H118'},
                        {name: 'GIFT_COMPANY_NUM'    	, text: '사업자(주민)등록번호'	, type: 'string'},
                        {name: 'GIFT_COMPANY_NAME'    	, text: '상호'                	, type: 'string'},
                        {name: 'GIFT_TEXT'            	, text: '기부내용'            	, type: 'string'},
                        {name: 'GIFT_YYMM'            	, text: '기부년월'            	, type: 'uniDate', allowBlank:false},

                        {name: 'GIFT_CODE'            	, text: '코드'                	, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H119'},
                        {name: 'TAX_GU'                	, text: '영수증구분'        	, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H120'},

                        {name: 'GIFT_COUNT'            	, text: '건수'                	, type: 'uniNumber', minValue:0, allowBlank:false},
                        {name: 'GIFT_AMOUNT_I'        	, text: '금액'                	, type: 'uniPrice', allowBlank:false, minValue:0},
                        {name: 'POLICY_INDED'        	, text: '정치자금'            	, type: 'uniPrice'},
                        {name: 'SBDY_APLN_SUM'        	, text: '기부장려금'        	, type: 'uniPrice', minValue:0, defaultValue:0},
                        {name: 'CONB_SUM'            	, text: '합계'                	, type: 'uniPrice', minValue:0, defaultValue:0},
                        {name: 'FAMILY_NAME'        	, text: '성명'                	, type: 'string', allowBlank:false},
                        {name: 'REPRE_NUM'            	, text: '주민등록번호'        	, type: 'string', allowBlank:false},
                        {name: 'REL_CODE'            	, text: '관계'                	, type: 'string', allowBlank:false, comboType:'AU', comboCode:'H140' },
                        {name: 'GIFT_NUM'            	, text: '순번'                	, type: 'int' },

                        {name: 'LIVE_GUBUN'        		, text: '거주구분'       		, type: 'string', comboType:'AU', comboCode:'H115'}

                     ]
                });
                var had420ukrStore = Unilite.createStore('had420ukrStore',{

                    model: 'had420ukrModel',
                    uniOpt : {
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
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
                        var param= donationWin.paramData;
                        console.log( param );
                        this.load({
                            params: param
                        });
                    },
                    saveStore:function()    {
                        var inValidRecs = this.getInvalidRecords();
                        console.log("inValidRecords : ", inValidRecs);
                        if(inValidRecs.length == 0) {
                            config = {
                                        //params: [paramMaster],
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

                donationWin= Ext.create('widget.uniDetailWindow', {
                    title: '기부금명세등록',
                    width: 1000,
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
                            }]},{
                            xtype:'container',
                            flex:1,
                            layout: {type:'vbox', align:'stretch'},
                            items:[
                                Unilite.createGrid('had420ukrGrid', {
                                    layout : 'fit',
                                    store : had420ukrStore,
                                    sortableColumns: false,
                                    uniOpt:{
                                        expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                        useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                        useLiveSearch: false,        //찾기 버튼 사용 여부
                                        filter: {                    //필터 사용 여부
                                            useFilter: false,
                                            autoCreate: false
                                        },
                                        state: {
                                            useState: false,            //그리드 설정 버튼 사용 여부
                                            useStateList: false        //그리드 설정 목록 사용 여부
                                        }
                                    },
                                    tbar:[
                                        '->',
                                        {
                                            xtype:'button',
                                            text:'추가',
                                            handler:function()    {
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
                                            }
                                        },{
                                            xtype:'button',
                                            text:'삭제',
                                            handler:function()    {
                                                var grid = Ext.getCmp('had420ukrGrid');
                                                had420ukrStore.remove(grid.getSelectionModel().getSelection());
                                            }
                                        },{
                                            xtype:'button',
                                            text:'공제기부금 가져오기',
                                            //hidden:true,
                                            handler:function()    {
                                                var form = donationWin.down('#search');
                                                had420ukrService.selectHad420Check(form.getValues(), function(responseText, response) {
                                                    if(responseText)    {
                                                        if(parseInt(responseText.CNT) > 0 )    {
                                                            alert(Msg.fsbMsgH0309);
                                                            return;
                                                        }
                                                        had420ukrService.saveHad420(form.getValues(), function(responseText, response) {
                                                            had420ukrStore.loadStoreRecords();
                                                        })
                                                    }
                                                })

                                            }
                                        }
                                    ],
                                    features: [
                                        { ftype: 'uniSummary',          showSummaryRow: true, dock :'bottom'}
                                    ],
                                    columns:  [
                                        {text:'기부처', columns:[
                                            {dataIndex: 'GIFT_COMPANY_NUM'    , width: 130
                                            ,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                                                  return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
                                            	}
                                            },
                                            {dataIndex: 'GIFT_COMPANY_NAME'        , width: 130}
                                        ]},
                                        {dataIndex: 'GIFT_TEXT'    , width: 150},
                                        {dataIndex: 'GIFT_YYMM'        , width: 100, xtype:'uniMonthColumn',
                                            editor:{xtype:'uniMonthfield',format: 'Y.m' }},
                                        {dataIndex: 'GIFT_CODE'        , width: 100},
                                        {dataIndex: 'TAX_GU'        , width: 100},
                                        {dataIndex: 'GIFT_COUNT'        , width: 100, summaryType:'sum'},
                                        {dataIndex: 'GIFT_AMOUNT_I'        , width: 100, summaryType:'sum'},
                                        {dataIndex: 'SBDY_APLN_SUM'        , width: 100, summaryType:'sum'},
                                        {dataIndex: 'CONB_SUM'        	, width: 100, summaryType:'sum'},
                                        {text:'기부자', columns:[
                                            {dataIndex: 'FAMILY_NAME'        , width: 100},
                                            {dataIndex: 'REPRE_NUM'        , width: 100},
                                            {dataIndex: 'REL_CODE'            , width:100}
                                        ]}
                                    ],
                                    listeners:{
                                        beforeedit:function(editor, context, eOpts)    {

                                            if(context.field == "FAMILY_NAME" )    {
                                                context.grid.fnFamilyPopUp(context.record);
                                                return false;
                                            }
                                            if(context.field == "REPRE_NUM" )    {
                                                context.grid.fnFamilyPopUp(context.record);
                                                return false;
                                            }
                                        },
                                        edit:function(editor, context, eOpt){
                                        	var sAfterValue = context.value;
                                        	var searchForm =  donationWin.down('#search');
                                            switch(context.field)    {
                                                case "GIFT_CODE":
                                                    if(sAfterValue == '20' || sAfterValue == '42')	{
                                                    	context.record.set("FAMILY_NAME",searchForm.getValue("NAME"));
                                                    	context.record.set("REPRE_NUM",searchForm.getValue("REPRE_NUM"));
                                                    	context.record.set("REL_CODE","1");
                                                    	context.record.set("LIVE_GUBUN",searchForm.getValue("LIVE_GUBUN"));
                                                    }
                                                    if(sAfterValue == '20')	{
                                                    	if(context.record.get("GIFT_AMOUNT_I") >= 100000 )	{
	                                                    	context.record.set("POLICY_INDED",100000);
	                                                    } else {
	                                                    	context.record.set("POLICY_INDED",context.record.get("GIFT_AMOUNT_I"));
	                                                    }
                                                    }else {
                                                		context.record.set("POLICY_INDED",0);
                                                	}
                                                break;
                                                case "GIFT_AMOUNT_I":
                                                	if(context.record.get("GIFT_CODE") == "20" )	{
	                                                    if(sAfterValue >= 100000 )	{
	                                                    	context.record.set("POLICY_INDED",100000);
	                                                    } else {
	                                                    	context.record.set("POLICY_INDED",sAfterValue);
	                                                    }
                                                	} else {
                                                		context.record.set("POLICY_INDED",0);
                                                	}

                                            		dTmp1 = context.record.get("GIFT_AMOUNT_I");
								                    dTmp2 = context.record.get("SBDY_APLN_SUM");
								                    var conbSum = dTmp1 + dTmp2;
								                    context.record.set("CONB_SUM",  conbSum);
                                                break;
                                                case "SBDY_APLN_SUM":
                                                	if(context.record.get("GIFT_CODE") == "20" )	{
	                                                    if(sAfterValue >= 100000 )	{
	                                                    	context.record.set("POLICY_INDED",100000);
	                                                    } else {
	                                                    	context.record.set("POLICY_INDED",sAfterValue);
	                                                    }
                                                	} else {
                                                		context.record.set("POLICY_INDED",0);
                                                	}

                                            		dTmp1 = context.record.get("GIFT_AMOUNT_I");
								                    dTmp2 = context.record.get("SBDY_APLN_SUM");
								                    var conbSum = dTmp1 + dTmp2;
								                    context.record.set("CONB_SUM",  conbSum);
                                                break;
                                                case "CONB_SUM":
                                                	if(context.record.get("GIFT_CODE") == "20" )	{
	                                                    if(sAfterValue >= 100000 )	{
	                                                    	context.record.set("POLICY_INDED",100000);
	                                                    } else {
	                                                    	context.record.set("POLICY_INDED",sAfterValue);
	                                                    }
                                                	} else {
                                                		context.record.set("POLICY_INDED",0);
                                                	}

                                                	if(sAfterValue > 0 || context.record.get("SBDY_APLN_SUM") > 0 )	{
                                                		dTmp1 = context.record.get("GIFT_AMOUNT_I");
									                    dTmp2 = context.record.get("SBDY_APLN_SUM");
									                    var conbSum = dTmp1 + dTmp2;
									                    context.record.set("CONB_SUM",  conbSum);
                                                	}
                                                break;
                                                case "GIFT_COMPANY_NUM":
	                                                if(sAfterValue && sAfterValue.length >0 )	{
	                                                	if (sAfterValue && sAfterValue.replace(/-/g,"").length < 10) {
															alert(Msg.sMB421);
															context.record.set("GIFT_COMPANY_NUM", "");
															return;
	                                                	} else {
															if (sAfterValue && sAfterValue.replace(/-/g,"").length > 10 &&
															   sAfterValue && sAfterValue.replace(/-/g,"").length  != 13 )	{
																alert(Msg.sMB421);
																context.record.set("GIFT_COMPANY_NUM", "");
																return;
															}
	                                                	}
	                                                }
                                                break;
                                                case "REL_CODE":
                                                	var giftCode = context.record.get("GIFT_CODE");
                                                    if((giftCode == '20' || giftCode == '42') && sAfterValue != "1")	{
                                                    	alert(Msg.fsbMsgH0307);
                                                    	context.record.set("REL_CODE", "");
                                                    }
                                                break;
                                                default:
                                                break;
                                            }
                                        },
                                        onGridDblClick:function(grid, record, cellIndex, colName)    {
                                            if(colName == "FAMILY_NAME")    {
                                                grid.ownerCt.ownerGrid.fnFamilyPopUp(record);
                                            }
                                            if(colName == "REPRE_NUM")    {
                                                grid.ownerCt.ownerGrid.fnFamilyPopUp(record);
                                            }
                                        }
                                    },
                                    fnFamilyPopUp:function(record){
                                        var me = this;

                                        var paramData = {
                                            'YEAR_YYYY'        : record.get('YEAR_YYYY'),
                                            'PERSON_NUMB'    : record.get('PERSON_NUMB'),
                                            'NAME'            : record.get('NAME'),
                                            'DEPT_NAME'        : record.get('DEPT_NAME'),
                                            'POST_NAME'        : record.get('POST_NAME')
                                        };
                                        if(!me.familyPopupWin)    {

                                            if(!me.familyPopupWin)    {

                                                Unilite.defineModel('humanFamilyPopupModel2', {
                                                    fields: [
                                                        {name: 'FAMILY_NAME'        , text: '가족성명'        , type: 'string'},
                                                        {name: 'REPRE_NUM'            , text: '주민등록번호'    , type: 'string'},
                                                        {name: 'REL_NAME'            , text: '관계'            , type: 'string'},
                                                        {name: 'IN_FORE_NAME'        , text: '내외국인'        , type: 'string'},
                                                        {name: 'REL_CODE'            , text: '관계'            , type: 'string'},
                                                        {name: 'IN_FORE'            , text: '내외국인'        , type: 'string'},
                                                        {name: 'DEFAULT_DED_YN'        , text: '기본공제'        , type: 'string'},
                                                        {name: 'DEFORM_DED_YN'        , text: '장애인'        , type: 'string'},
                                                        {name: 'OLD_DED_YN'            , text: '경로우대'        , type: 'string'}

                                                     ]
                                                });
                                                var humanFamilyPopupStore2 = Unilite.createStore('humanFamilyPopupStore2',{

                                                    model: 'humanFamilyPopupModel2',
                                                    uniOpt : {
                                                        isMaster: false,            // 상위 버튼 연결
                                                        editable: false,        // 수정 모드 사용
                                                        deletable: false,        // 삭제 가능 여부
                                                        useNavi: false            // prev | newxt 버튼 사용
                                                    },
                                                    autoLoad: false,
                                                    proxy: {
                                                        type: 'uniDirect',
                                                        api: {
                                                            read : 'had618ukrService.selectFamliy'
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
                                                                        expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                                                        useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                                                        useLiveSearch: false,        //찾기 버튼 사용 여부
                                                                        filter: {                    //필터 사용 여부
                                                                            useFilter: false,
                                                                            autoCreate: false
                                                                        },
                                                                        state: {
                                                                            useState: false,            //그리드 설정 버튼 사용 여부
                                                                            useStateList: false        //그리드 설정 목록 사용 여부
                                                                        }
                                                                    },
                                                                    columns:  [
                                                                        {dataIndex: 'FAMILY_NAME'    , width: 100},
                                                                        {dataIndex: 'REPRE_NUM'        , width: 130},

                                                                        {dataIndex: 'REL_NAME'        , width: 80},
                                                                        {dataIndex: 'IN_FORE_NAME'    , width: 80},
                                                                        {dataIndex: 'DEFAULT_DED_YN', width: 80},
                                                                        {dataIndex: 'DEFORM_DED_YN'    , width: 80},
                                                                        {dataIndex: 'OLD_DED_YN'    , width: 80}
                                                                    ],
                                                                    listeners:{
                                                                        onGridDblClick:function(view, record, cellIndex, colName){
                                                                            var grid = me.familyPopupWin.down("#humanFamilyPopupGrid2")
                                                                            var selRecord = grid.getSelectedRecord();
                                                                            var donationGrid = donationWin.down("#had420ukrGrid")
                                                                            var donationRecord = donationGrid.getSelectedRecord();

                                                                            if(selRecord)    {

                                                                                if (selRecord.get("REL_CODE") == "0") {
                                                                                     donationRecord.set("REL_CODE", "1");
                                                                                } else if(selRecord.get("REL_CODE") == "3") {
                                                                                    donationRecord.set("REL_CODE", "2");
                                                                                } else if(selRecord.get("REL_CODE") == "4") {
                                                                                     donationRecord.set("REL_CODE", "3");
                                                                                } else if (selRecord.get("REL_CODE") == "1")    {
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
                                                                                     if(donationRecord.get("GIFT_CODE")== "")    {

                                                                                        alert(Msg.fsbMsgH0126) ;
                                                                                        donationRecord.set("FAMILY_NAME", "");
                                                                                        donationRecord.set("REPRE_NUM", "");
                                                                                        donationRecord.set("REL_CODE", "");
                                                                                        donationRecord.set("IN_FORE", "");
                                                                                        me.familyPopupWin.hide();
                                                                                         return;
                                                                                     }

                                                                                     if(donationRecord.get("GIFT_CODE") == "20" ||
                                                                                        donationRecord.get("GIFT_CODE") == "42" ) {
                                                                                        alert(Msg.fsbMsgH0125) ;
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

                                                                            if(selRecord)    {

                                                                                if (selRecord.get("REL_CODE") == "0") {
                                                                                     donationRecord.set("REL_CODE", "1");
                                                                                } else if(selRecord.get("REL_CODE") == "3") {
                                                                                    donationRecord.set("REL_CODE", "2");
                                                                                } else if(selRecord.get("REL_CODE") == "4") {
                                                                                     donationRecord.set("REL_CODE", "3");
                                                                                } else if (selRecord.get("REL_CODE") == "1")    {
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
                                                                                     if(donationRecord.get("GIFT_CODE")== "")    {

                                                                                         alert(Msg.fsbMsgH0126) ;
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
                                                                                        alert(Msg.fsbMsgH0125) ;
                                                                                        donationRecord.set("FAMILY_NAME", "");
                                                                                        donationRecord.set("REPRE_NUM", "");
                                                                                        donationRecord.set("REL_CODE", "");
                                                                                        me.familyPopupWin.hide();
                                                                                         return;
                                                                                      }
                                                                                 }

                                                                                 donationRecord.set("FAMILY_NAME", selRecord.get("FAMILY_NAME"));
                                                                                donationRecord.set("REPRE_NUM", selRecord.get("REPRE_NUM"));

                                                                            }else {
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
                                                        beforehide: function(me, eOpt)    {
                                                            me.down('#search').clearForm();
                                                        },
                                                        beforeclose: function( panel, eOpts )    {
                                                            me.down('#search').clearForm();
                                                        },
                                                        beforeshow: function( panel, eOpts )    {
                                                            var searchForm =  panel.down('#search');
                                                            searchForm.setValue("YEAR_YYYY"        ,me.familyPopupWin.paramData.YEAR_YYYY);
                                                            searchForm.setValue("NAME"            ,me.familyPopupWin.paramData.NAME);
                                                            searchForm.setValue("PERSON_NUMB"    ,me.familyPopupWin.paramData.PERSON_NUMB);
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
                                handler: function() {
                                    var store = Ext.data.StoreManager.lookup('had420ukrStore') ;
                                    if(store.isDirty())    {
                                    	for(var lLoop = 0; lLoop < store.data.items.length; lLoop++) {
                                    		var item = store.data.items[lLoop];
                                    		
                                    		if(item.phantom && item.hasOwnProperty("dirty") && item.dirty) {
                                    			if(item.data["TAX_GU"] != "1" && item.data["GIFT_COMPANY_NUM"] == "") {
                                    				alert("국세청 자료가 아닌 경우 사업자등록번호는 필수입력입니다.");
                                    				return;
                                    			}
                                    			if(item.data["TAX_GU"] != "1" && item.data["GIFT_COMPANY_NAME"] == "") {
                                    				alert("국세청 자료가 아닌 경우 상호는 필수입력입니다.");
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
                                    donationWin.hide();

                                },
                                disabled: false
                            }
                        ]
                    },
                    listeners : {
                        beforehide: function(me, eOpt)    {
                            donationWin.down('#search').clearForm();
                            if(donationWin.changes)    {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        beforeclose: function( panel, eOpts )    {
                            donationWin.down('#search').clearForm();
                            if(donationWin.changes) {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        beforeshow: function( panel, eOpts )    {
                            var searchForm =  donationWin.down('#search');
                            searchForm.setValue("YEAR_YYYY"        ,donationWin.paramData.YEAR_YYYY);
                            searchForm.setValue("NAME"            ,donationWin.paramData.NAME);
                            searchForm.setValue("PERSON_NUMB"    ,donationWin.paramData.PERSON_NUMB);
                            searchForm.setValue("DEPT_NAME"        ,donationWin.paramData.DEPT_NAME);
                            searchForm.setValue("POST_CODE_NAME",donationWin.paramData.POST_CODE_NAME);
                            searchForm.setValue("REPRE_NUM"        ,donationWin.paramData.REPRE_NUM);
                            searchForm.setValue("LIVE_GUBUN",donationWin.paramData.LIVE_GUBUN);

                            had420ukrStore.loadStoreRecords();

                        }
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

            if(!panelSearch.isValid())    {
                return;
            }
            var paramData = {
                'YEAR_YYYY'        : panelSearch.getValue('YEAR_YYYY'),
                'PERSON_NUMB'    : panelSearch.getValue('PERSON_NUMB'),
                'NAME'            : panelSearch.getValue('NAME'),
                'DEPT_NAME'        : panelSearch.getValue('DEPT_NAME'),
                'POST_CODE_NAME'        : panelSearch.getValue('POST_CODE_NAME')
            };
            if(!rentWin)    {

                Unilite.defineModel('had450ukrModel', {
                    fields: [
                        {name: 'PERSON_NUMB'        , text: '사번'                , type: 'string', allowBlank:false},
                        {name: 'PERSON_NAME'        , text: '성명'                , type: 'string'},
                        {name: 'YEAR_YYYY'            , text: '정산년도'            , type: 'string', allowBlank:false},
                        {name: 'PERSON_NAME'        , text: '사원명'            , type: 'string'},
                        {name: 'SEQ_NO'                , text: '순번'                , type: 'uniNumber'},
                        {name: 'LEAS_NAME'            , text: '임대인성명'        , type: 'string', allowBlank:false},
                        {name: 'REPRE_NUM'            , text: '주민등록번호'                , type: 'string', allowBlank:false},
                        {name: 'LEAS_ADDR'            , text: '임대차계약서 상 주소지'    , type: 'string', allowBlank:false},
                        {name: 'LEAS_BGN_DATE'        , text: '임차시작일'        , type: 'uniDate', allowBlank:false},

                        {name: 'LEAS_END_DATE'        , text: '임차종료일'        , type: 'uniDate', allowBlank:false},
                        {name: 'LEAS_DDCNT'            , text: '임차일수'            , type: 'uniNumber',defaultValue:0},

                        {name: 'TAX_PRD_LEAS_DDCNT'    , text: '과세기간임차일수'    , type: 'uniNumber' ,defaultValue:0},
                        {name: 'MNRT_TOTAL_I'        , text: '월세계약총액'        , type: 'uniPrice', allowBlank:false},
                        {name: 'DDUC_OBJ_I'            , text: '공제대상금액'        ,     type: 'uniPrice'},
                        {name: 'HOUSE_TYPE'            , text: '주택유형'            , type: 'string', comboType:'AU', comboCode:'H180', allowBlank:false},
                        {name: 'HOUSE_AREA'            , text: '주택계약면적(㎡)'    , type: 'uniPrice', allowBlank:false}

                     ]
                });
                var had450ukrStore = Unilite.createStore('had450ukrStore',{

                    model: 'had450ukrModel',
                    uniOpt : {
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
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
                    saveStore:function()    {
                        var toCreate = this.getNewRecords();
                           var toUpdate = this.getUpdatedRecords();
                           var toDelete = this.getRemovedRecords();
                           var list = [].concat(toUpdate, toCreate);

                           var checkValid = true;
                        Ext.each(list, function(record, index) {
                            // 비과세분 입력시 비과세 코드 입력 체크
                            if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
                                alert(Msg.sMH1065 +'\n'+ Msg.fstMsgH0098);
                                checkValid = false;
                                return;
                            }
                        })
                        if(!checkValid)    {
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
                                Unilite.createGrid('had450ukrGrid', {
                                    layout : 'fit',
                                    store : had450ukrStore,
                                    sortableColumns: false,
                                    uniOpt:{
                                        expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                        useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                        useLiveSearch: false,        //찾기 버튼 사용 여부
                                        filter: {                    //필터 사용 여부
                                            useFilter: false,
                                            autoCreate: false
                                        },
                                        state: {
                                            useState: false,            //그리드 설정 버튼 사용 여부
                                            useStateList: false        //그리드 설정 목록 사용 여부
                                        }
                                    },
                                    tbar:[
                                        '->',
                                        {
                                            xtype:'button',
                                            text:'추가',
                                            handler:function()    {
                                                var form = rentWin.down('#search');
                                                var grid = Ext.getCmp('had450ukrGrid');
                                                var record = Ext.create(had450ukrStore.model);
                                                rIndex = had450ukrStore.count();
                                                record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
                                                record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
                                                had450ukrStore.insert(rIndex, record);
                                                grid.getSelectionModel().select(rIndex);
                                            }
                                        },{
                                            xtype:'button',
                                            text:'삭제',
                                            handler:function()    {
                                                var grid = Ext.getCmp('had450ukrGrid');
                                                had450ukrStore.remove(grid.getSelectionModel().getSelection());
                                            }
                                        }
                                    ],
                                    columns:  [
                                        {dataIndex: 'LEAS_NAME'    , width: 80},
                                        {dataIndex: 'REPRE_NUM'        , width: 130},

                                        {dataIndex: 'LEAS_ADDR'    , width: 150},
                                        {dataIndex: 'LEAS_BGN_DATE'        , width: 80},
                                        {dataIndex: 'LEAS_END_DATE'        , width: 80},
                                        {dataIndex: 'LEAS_DDCNT'        , width: 80},
                                        {dataIndex: 'TAX_PRD_LEAS_DDCNT'    , width: 150},
                                        {dataIndex: 'HOUSE_TYPE'        , width: 100},
                                        {dataIndex: 'HOUSE_AREA'        , width: 120},
                                        {dataIndex: 'MNRT_TOTAL_I'        , width: 150},
                                        {dataIndex: 'DDUC_OBJ_I'        , minWidth:100,    flex: 1}

                                    ]
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
                                handler: function() {
                                    var store = Ext.data.StoreManager.lookup('had450ukrStore') ;
                                    if(store.isDirty())    {
                                        store.saveStore();
                                    }
                                },
                                disabled: false
                            },{
                                itemId : 'closeBtn',
                                text: '닫기',
                                width:100,
                                handler: function() {
                                    rentWin.hide();

                                },
                                disabled: false
                            }
                        ]
                    },
                    listeners : {
                        beforehide: function(me, eOpt)    {
                            rentWin.down('#search').clearForm();
                            if(rentWin.changes)    {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        beforeclose: function( panel, eOpts )    {
                            rentWin.down('#search').clearForm();
                            if(rentWin.changes) {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        beforeshow: function( panel, eOpts )    {
                            var searchForm =  rentWin.down('#search');
                            searchForm.setValue("YEAR_YYYY"        ,rentWin.paramData.YEAR_YYYY);
                            searchForm.setValue("NAME"            ,rentWin.paramData.NAME);
                            searchForm.setValue("PERSON_NUMB"    ,rentWin.paramData.PERSON_NUMB);
                            searchForm.setValue("DEPT_NAME"        ,rentWin.paramData.DEPT_NAME);
                            searchForm.setValue("POST_CODE_NAME",rentWin.paramData.POST_CODE_NAME);
                            had450ukrStore.loadStoreRecords();

                        }
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

            if(!panelSearch.isValid())    {
                return;
            }
            var paramData = {
                'YEAR_YYYY'        : panelSearch.getValue('YEAR_YYYY'),
                'PERSON_NUMB'    : panelSearch.getValue('PERSON_NUMB'),
                'NAME'            : panelSearch.getValue('NAME'),
                'DEPT_NAME'        : panelSearch.getValue('DEPT_NAME'),
                'POST_CODE_NAME'        : panelSearch.getValue('POST_CODE_NAME')
            };
            if(!houseLoanWin)    {

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
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
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
                    saveStore:function()    {
                        var toCreate = this.getNewRecords();
                           var toUpdate = this.getUpdatedRecords();
                           var toDelete = this.getRemovedRecords();
                           var list = [].concat(toUpdate, toCreate);

                           var checkValid = true;
                        //Ext.each(list, function(record, index) {
                            //// 비과세분 입력시 비과세 코드 입력 체크
                            //if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
                            //    alert(Msg.sMH1065 +'\n'+ Msg.fstMsgH0098);
                            //    checkValid = false;
                            //    return;
                            //}
                        //})
                        if(!checkValid)    {
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
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
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
                    saveStore:function()    {
                        var toCreate = this.getNewRecords();
                           var toUpdate = this.getUpdatedRecords();
                           var toDelete = this.getRemovedRecords();
                           var list = [].concat(toUpdate, toCreate);

                           var checkValid = true;
                        //Ext.each(list, function(record, index) {
                            //// 비과세분 입력시 비과세 코드 입력 체크
                            //if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
                            //    alert(Msg.sMH1065 +'\n'+ Msg.fstMsgH0098);
                            //    checkValid = false;
                            //    return;
                            //}
                        //})
                        if(!checkValid)    {
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
								//        tabPosition: 'left',
								//        tabRotation: 0,
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
					                                        expandLastColumn: false,    //마지막 컬럼 * 사용 여부
					                                        useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
					                                        useLiveSearch: false,        //찾기 버튼 사용 여부
					                                        filter: {                    //필터 사용 여부
					                                            useFilter: false,
					                                            autoCreate: false
					                                        },
					                                        state: {
					                                            useState: false,            //그리드 설정 버튼 사용 여부
					                                            useStateList: false        //그리드 설정 목록 사용 여부
					                                        }
					                                    },
					                                    tbar:[
					                                        '->',
					                                        {
					                                            xtype:'button',
					                                            text:'추가',
					                                            handler:function()    {
					                                                var form = houseLoanWin.down('#search');
					                                                var grid = Ext.getCmp('had451ukrGrid');
					                                                var record = Ext.create(had451ukrStore.model);
					                                                rIndex = had451ukrStore.count();
					                                                record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
					                                                record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
					                                                had451ukrStore.insert(rIndex, record);
					                                                grid.getSelectionModel().select(rIndex);
					                                            }
					                                        },{
					                                            xtype:'button',
					                                            text:'삭제',
					                                            handler:function()    {
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
					                                    ]
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
					                                        expandLastColumn: false,    //마지막 컬럼 * 사용 여부
					                                        useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
					                                        useLiveSearch: false,        //찾기 버튼 사용 여부
					                                        filter: {                    //필터 사용 여부
					                                            useFilter: false,
					                                            autoCreate: false
					                                        },
					                                        state: {
					                                            useState: false,            //그리드 설정 버튼 사용 여부
					                                            useStateList: false        //그리드 설정 목록 사용 여부
					                                        }
					                                    },
					                                    tbar:[
					                                        '->',
					                                        {
					                                            xtype:'button',
					                                            text:'추가',
					                                            handler:function()    {
					                                                var form = houseLoanWin.down('#search');
					                                                var grid = Ext.getCmp('had452ukrGrid');
					                                                var record = Ext.create(had452ukrStore.model);
					                                                rIndex = had452ukrStore.count();
					                                                record.set("PERSON_NUMB", form.getValue("PERSON_NUMB"));
					                                                record.set("YEAR_YYYY", form.getValue("YEAR_YYYY"));
					                                                had452ukrStore.insert(rIndex, record);
					                                                grid.getSelectionModel().select(rIndex);
					                                            }
					                                        },{
					                                            xtype:'button',
					                                            text:'삭제',
					                                            handler:function()    {
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
					                                    ]
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
                                handler: function() {
                                    var store = Ext.data.StoreManager.lookup('had451ukrStore');
                                    if(store.isDirty())    {
                                        store.saveStore();
                                    }
                                    store = Ext.data.StoreManager.lookup('had452ukrStore');
                                    if(store.isDirty())    {
                                        store.saveStore();
                                    }
                                },
                                disabled: false
                            },{
                                itemId : 'closeBtn',
                                text: '닫기',
                                width:100,
                                handler: function() {
                                    houseLoanWin.hide();

                                },
                                disabled: false
                            }
                        ]
                    },
                    listeners : {
                        beforehide: function(me, eOpt)    {
                            houseLoanWin.down('#search').clearForm();
                            if(houseLoanWin.changes)    {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        beforeclose: function( panel, eOpts )    {
                            houseLoanWin.down('#search').clearForm();
                            if(houseLoanWin.changes) {
                                UniAppManager.app.fnCollectData("INCOME_DED");
                            }
                        },
                        beforeshow: function( panel, eOpts )    {
                            var searchForm =  houseLoanWin.down('#search');
                            searchForm.setValue("YEAR_YYYY"        ,houseLoanWin.paramData.YEAR_YYYY);
                            searchForm.setValue("NAME"            ,houseLoanWin.paramData.NAME);
                            searchForm.setValue("PERSON_NUMB"    ,houseLoanWin.paramData.PERSON_NUMB);
                            searchForm.setValue("DEPT_NAME"        ,houseLoanWin.paramData.DEPT_NAME);
                            searchForm.setValue("POST_CODE_NAME",houseLoanWin.paramData.POST_CODE_NAME);
                            had451ukrStore.loadStoreRecords();
                            had452ukrStore.loadStoreRecords();
                        }
                    }
                });
            }
            houseLoanWin.paramData = paramData;
            houseLoanWin.changes = false;
            houseLoanWin.center();
            houseLoanWin.show();



        },
        openPDF:function()	{
        	if(direct400Store.isDirty() || direct600Store.isDirty())    {
        		alert('저장할 데이타가 있습니다. 저장 후 실행해 주세요.');
        		return;
        	}
            var paramData = {
                'YEAR_YYYY'        	: panelSearch.getValue('YEAR_YYYY'),
                'PERSON_NUMB'    	: panelSearch.getValue('PERSON_NUMB'),
                'NAME'            	: panelSearch.getValue('NAME'),
                'DEPT_NAME'        	: panelSearch.getValue('DEPT_NAME'),
                'POST_CODE_NAME'    : panelSearch.getValue('POST_CODE_NAME')
            };
            if(!pdfWin)    {

                Unilite.defineModel('hadPdfModel', {
                    fields: [
                        {name: 'PERSON_NUMB'	, text: '사번'			, type: 'string', allowBlank:false},
                        {name: 'YEAR_YYYY'		, text: '정산년도'		, type: 'string', allowBlank:false},
                        {name: 'GUBUN_CODE'		, text: '구분코드'		, type: 'string', allowBlank:false},
                        {name: 'GUBUN_NAME'		, text: '항목명'		, type: 'string', allowBlank:false},
                        {name: 'D_NAME'			, text: '대상자'		, type: 'string'},
                        {name: 'D_REPRE_NUM'	, text: '주민번호'		, type: 'string'},
                        {name: 'DATA_CD'		, text: '유형코드'		, type: 'string'},
                        {name: 'DATA_NAME'		, text: '유형'			, type: 'string'},
                        {name: 'CARD_TYPE_NAME'	, text: '유형'			, type: 'string'},
                        {name: 'USE_AMT'		, text: '금액'			, type: 'uniPrice'},
                        {name: 'SBDY_APLN_SUM'	, text: '기부장려금'	, type: 'uniPrice'},
                        {name: 'CONB_SUM'		, text: '합계'			, type: 'uniPrice'},
                        {name: 'D_RES_NO'		, text: 'D_RES_NO'		, type: 'string'},
                        {name: 'TARGET_YN'		, text: '대상'			, type: 'boolean'}

                     ]
                });
                var hadPdfStore = Unilite.createStore('hadPdfStore',{

                    model: 'hadPdfModel',
                    uniOpt : {
                        isMaster: false,            // 상위 버튼 연결
                        editable: true,        // 수정 모드 사용
                        deletable: false,        // 삭제 가능 여부
                        useNavi: false            // prev | newxt 버튼 사용
                    },
                    autoLoad: false,
                    proxy: {
                        type: 'uniDirect',
                        api: {
                            read : 'had618ukrService.selectPdfList'
                            ,update : 'had618ukrService.updatePdf'
                            /*,create : 'had618ukrService.insert'
                            ,destroy : 'had618ukrService.delete'*/
                            ,syncAll: 'had618ukrService.saveAllPdf'
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
                    saveStore:function(config)    {
                        var inValidRecs = this.getInvalidRecords();
                        console.log("inValidRecords : ", inValidRecs);
                        if(inValidRecs.length == 0) {
                        	if(!config)	{
                            	config = {
                                        //params: [paramMaster],
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
                    refreshFilter:function(gubunCode)	{
                    	this.clearFilter();
                    	if(!Ext.isArray(gubunCode)){
                    		this.filter('GUBUN_CODE', gubunCode);
                    	}else{
                    		this.filterBy(function(record)	{
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

                pdfWin= Ext.create('widget.uniDetailWindow', {
                    title: 'PDF업로드',
                    width: 1000,
                    height:800,

                    layout: {type:'vbox', align:'stretch'},
                    items: [{
                            itemId:'search',
                            xtype:'uniSearchForm',
                             style:{
                                'background':'#fff'
                            },
                            height:35,
                            layout:{type:'uniTable', columns:4},
                            margine:'3 3 3 3',
                            items:[{
                                fieldLabel: '정산년도',
                                name:'YEAR_YYYY',
                                xtype: 'uniYearField',
                                width:150,
                                labelWidth:80,
                                allowBlank:false,
                                listeners: {
			                        change:function(field, newValue, oldValue)    {
			                            if(newValue != oldValue)	{
			                            	pdfWin.loadSummary('YEAR_YYYY', newValue);
			                            }
			                        }
			                    }
                            },
                            Unilite.popup('Employee',{
			                    validateBlank: false,
			                    allowBlank:false,
			                    listeners: {
			                        onSelected:function(records, type)    {
			                            if(records)	{
                                			var searchForm =  pdfWin.down('#search');
                                			searchForm.setValue("DEPT_NAME",records[0]['DEPT_NAME']);
                                			searchForm.setValue("POST_CODE_NAME",records[0]['POST_CODE_NAME']);
                                			pdfWin.paramData = searchForm.getValues();
			                            	pdfWin.loadSummary();
			                            }
			                        }
			                    }
			                }),
			                {
			                	name:'DEPT_NAME',
			                	fieldLabel:'부서',
			                	readOnly:true,
			                	hidden:false
			                },
			                {
			                	name:'POST_CODE_NAME',
			                	fieldLabel:'직위',
			                	readOnly:true,
			                	hidden:false
			                }
                          ]},
                          {
                          	itemId:'pdfUploadForm',
                            xtype:'uniDetailForm',
                            api: {
                                submit: had618ukrService.pdfUploadFile
                            },
                            style:{
                                'background':'#fff'
                            },
                            height:35,
                            layout:{type:'uniTable', columns:7, tableAttrs:{cellspacing:0}},
                           // margine:'3 3 3 3',
                            disabled:false,
                          	items:[
                          		{
                            		xtype:'button',
	                            	text:'1.부양가족확인',
	                            	handler:function(){
	                            		UniAppManager.app.openFamily('P', pdfWin.down('#search'));
	                            	}
	                            },{
                            		xtype:'component',
                            		html:'&nbsp;&nbsp;&nbsp;->&nbsp;'
		                        },{
		                             xtype: 'filefield',
		                             buttonOnly: false,
		                             fieldLabel: 'PDF파일',
									 labelWidth:60,
									 width:400,
		                             name: 'pdfFile',
		                             buttonText: '찾아보기',
		                             allowBlank:false
		                        },{
		                        	 xtype:'component',
		                             html:'&nbsp;&nbsp;'
		                        },{
		                        	 xtype:'button',
		                             text:'2.PDF 업로드',
		                             handler:function(){
		                             	var uploadForm = pdfWin.down("#pdfUploadForm");
		                             	var searchForm =  pdfWin.down('#search');
		                             	var params = searchForm.getValues();
		                             	params.ORG_FIEL_NAME=uploadForm.getValue("pdfFile");
		                             	if(uploadForm.isValid())	{
			                            	uploadForm.submit(
												{
													params: params,
												 	waitMsg: 'Uploading files...',
												 	success: function(form, action)	{
												 		pdfWin.mask();
												 		had618ukrService.pdfRead(action.params, function(responseText, response){
												 			pdfWin.unmask();
															if(!response.message) {
																UniAppManager.updateStatus('파일이 등록되었습니다.');
																pdfWin.loadSummary();
															}
												 		})
													},
													failure:function(form, action)	{
														alert("파일 등록 중 오류가 발생했습니다.")
													}
												}
											);
		                             	} else {
		                             		alert('pdf 파일을 선택해 주세요.');
		                             	}
		                             }
                           		},{
		                        	 xtype:'component',
		                             html:'&nbsp;&nbsp;&nbsp;->&nbsp;&nbsp;&nbsp;'
		                        },{
		                        	 xtype:'button',
		                             text:'3.PDF 자료반영',
		                             handler:function(){
		                             	if(!hadPdfStore.isDirty())	{
		                            		pdfWin.applyData();
		                             	}else {
		                             		if(confirm('저장할 데이타가 있습니다. 저장 하시겠습니까?'))	{
		                             			hadPdfStore.saveStore({
		                             				success:function()	{
		                             					pdfWin.loadSummary();
		                             					pdfWin.applyData();
		                             				}
		                             			})
		                             		}
		                             	}
		                             }
                           		}
                           	]},{
                                itemId:'summary',
                                xtype:'uniSearchForm',
                                 style:{
                                    'background':'#fff'
                                },
                                height:140,
                                layout:{type:'uniTable', columns:6, tableAttrs:{cellspacing:5}},
                                margine:'3 3 3 3',
                                items:[{
                                    xtype:'component',
                                    colspan:6,
                                    html:"<hr></hr>"
                                },{
		                        	 xtype:'component',
		                             html:'보험',
		                             tdAttrs:{align:'center'}
		                        },{
		                        	 xtype:'component',
		                             html:'의료비',
		                             tdAttrs:{align:'center'}
		                        },{
		                        	 xtype:'component',
		                             html:'교육비',
		                             tdAttrs:{align:'center'}
		                        },{
		                        	 xtype:'component',
		                             html:'신용카드',
		                             tdAttrs:{align:'center'}
		                        },{
		                        	 xtype:'component',
		                             html:'직불카드',
		                             tdAttrs:{align:'center'}
		                        },{
		                        	 xtype:'component',
		                             html:'현금영수증',
		                             tdAttrs:{align:'center'}
		                        },{
                                    fieldLabel: '보험',
                                    hideLabel:true,
                                    xtype:'uniNumberfield',
                                    name:'A102Y_AMT',
                                    readOnly:true,
                                    width:150,
                                    listeners:{
                                    	render:function(c)	{
                                    		c.getEl().on('click', function(component){
                                    			hadPdfStore.refreshFilter('A102Y');
                                    			var grid = pdfWin.down('#hadPdfGrid');
                                    			grid.getColumn('DATA_NAME').show();
                                    			grid.getColumn('CARD_TYPE_NAME').hide();
                                    			grid.getColumn('SBDY_APLN_SUM').hide();
                                    			grid.getColumn('CONB_SUM').hide();
                                    		});
                                    	}
                                    }
                                },{
                                    fieldLabel: '의료비',
                                    hideLabel:true,
                                    xtype:'uniNumberfield',
                                    name:'B101Y_AMT',
                                    readOnly:true,
                                    width:150,
                                    listeners:{
                                    	render:function(c)	{
                                    		c.getEl().on('click', function(component){
                                    			hadPdfStore.refreshFilter('B101Y');
                                    			var grid = pdfWin.down('#hadPdfGrid');
                                    			grid.getColumn('DATA_NAME').show();
                                    			grid.getColumn('CARD_TYPE_NAME').hide();
                                    			grid.getColumn('SBDY_APLN_SUM').hide();
                                    			grid.getColumn('CONB_SUM').hide();
                                    		});
                                    	}
                                    }
                            	},{
                                    fieldLabel: '교육비',
                                    hideLabel:true,
                                    xtype:'uniNumberfield',
                                    name:'EDU_AMT_SUM',
                                    readOnly:true,
                                    width:150,
                                    listeners:{
                                    	render:function(c)	{
                                    		c.getEl().on('click', function(component){
                                    			hadPdfStore.refreshFilter(['C102Y','C202Y','C301Y','C401Y']);
                                    			var grid = pdfWin.down('#hadPdfGrid');
                                    			grid.getColumn('DATA_NAME').show();
                                    			grid.getColumn('CARD_TYPE_NAME').hide();
                                    			grid.getColumn('SBDY_APLN_SUM').hide();
                                    			grid.getColumn('CONB_SUM').hide();
                                    		});
                                    	}
                                    }
                            	},{
                                    fieldLabel: '신용카드',
                                    hideLabel:true,
                                    xtype:'uniNumberfield',
                                    name:'G107Y_AMT',
                                    readOnly:true,
                                    width:150,
                                    listeners:{
                                    	render:function(c)	{
                                    		c.getEl().on('click', function(component){
                                    			hadPdfStore.refreshFilter('G107Y');
                                    			var grid = pdfWin.down('#hadPdfGrid');
                                    			grid.getColumn('DATA_NAME').show();
                                    			grid.getColumn('CARD_TYPE_NAME').hide();
                                    			grid.getColumn('SBDY_APLN_SUM').hide();
                                    			grid.getColumn('CONB_SUM').hide();
                                    		});
                                    	}
                                    }
                            	},{
                                    fieldLabel: '직불카드',
                                    hideLabel:true,
                                    xtype:'uniNumberfield',
                                    name:'G307Y_AMT',
                                    readOnly:true,
                                    width:150,
                                    listeners:{
                                    	render:function(c)	{
                                    		c.getEl().on('click', function(component){
                                    			hadPdfStore.refreshFilter('G307Y');
                                    			var grid = pdfWin.down('#hadPdfGrid');
                                    			grid.getColumn('DATA_NAME').hide();
                                    			grid.getColumn('CARD_TYPE_NAME').hide();
                                    			grid.getColumn('SBDY_APLN_SUM').hide();
                                    			grid.getColumn('CONB_SUM').hide();
                                    		});
                                    	}
                                    }
                            	},{
                                    fieldLabel: '현금영수증',
                                    hideLabel:true,
                                    xtype:'uniNumberfield',
                                    name:'G207Y_AMT',
                                    readOnly:true,
                                    width:150,
                                    listeners:{
                                    	render:function(c)	{
                                    		c.getEl().on('click', function(component){
                                    			hadPdfStore.refreshFilter('G207Y');
                                    			var grid = pdfWin.down('#hadPdfGrid');
                                    			grid.getColumn('DATA_NAME').show();
                                    			grid.getColumn('CARD_TYPE_NAME').hide();
                                    			grid.getColumn('SBDY_APLN_SUM').hide();
                                    			grid.getColumn('CONB_SUM').hide();
                                    		});
                                    	}
                                    }
                            	},{
		                        	 xtype:'component',
		                             html:'개인연금저축/연금계좌',
		                             tdAttrs:{align:'center'}
		                        },{
		                        	 xtype:'component',
		                             html:'주택자금',
		                             tdAttrs:{align:'center'}
		                        },{
		                        	 xtype:'component',
		                             html:'주택마련저축',
		                             tdAttrs:{align:'center'}
		                        },{
		                        	 xtype:'component',
		                             html:'장기집합투자증원저축',
		                             tdAttrs:{align:'center'}
		                        },{
		                        	 xtype:'component',
		                             html:'소기업/소상공인 공제부금',
		                             tdAttrs:{align:'center'}
		                        },{
		                        	 xtype:'component',
		                             html:'기부금',
		                             tdAttrs:{align:'center'}
		                        },{
                                    fieldLabel: '개인연금저축/연금계좌',
                                    hideLabel:true,
                                    xtype:'uniNumberfield',
                                    name:'PENSION_AMT_SUM',
                                    readOnly:true,
                                    width:150,
                                    listeners:{
                                    	render:function(c)	{
                                    		c.getEl().on('click', function(component){
                                    			hadPdfStore.refreshFilter(['D101Y','E102Y','F102Y']);
                                    			var grid = pdfWin.down('#hadPdfGrid');
                                    			grid.getColumn('DATA_NAME').hide();
                                    			grid.getColumn('CARD_TYPE_NAME').hide();
                                    			grid.getColumn('SBDY_APLN_SUM').hide();
                                    			grid.getColumn('CONB_SUM').hide();
                                    		});
                                    	}
                                    }
                                },{
                                    fieldLabel: '주택자금',
                                    hideLabel:true,
                                    xtype:'uniNumberfield',
                                    name:'HOUSING_FUNDS_SUM',
                                    readOnly:true,
                                    width:150,
                                    listeners:{
                                    	render:function(c)	{
                                    		c.getEl().on('click', function(component){
                                    			hadPdfStore.refreshFilter(['J203Y','J101Y','J401Y']);
                                    			var grid = pdfWin.down('#hadPdfGrid');
                                    			grid.getColumn('DATA_NAME').hide();
                                    			grid.getColumn('CARD_TYPE_NAME').hide();
                                    			grid.getColumn('SBDY_APLN_SUM').hide();
                                    			grid.getColumn('CONB_SUM').hide();
                                    		});
                                    	}
                                    }
                            	},{
                                    fieldLabel: '주택마련저축',
                                    hideLabel:true,
                                    xtype:'uniNumberfield',
                                    name:'J301Y_AMT',
                                    readOnly:true,
                                    width:150,
                                    listeners:{
                                    	render:function(c)	{
                                    		c.getEl().on('click', function(component){
                                    			hadPdfStore.refreshFilter('J301Y');
                                    			var grid = pdfWin.down('#hadPdfGrid');
                                    			grid.getColumn('DATA_NAME').hide();
                                    			grid.getColumn('CARD_TYPE_NAME').hide();
                                    			grid.getColumn('SBDY_APLN_SUM').hide();
                                    			grid.getColumn('CONB_SUM').hide();
                                    		});
                                    	}
                                    }
                            	},{
                                    fieldLabel: '장기집합투자증원저축',
                                    hideLabel:true,
                                    xtype:'uniNumberfield',
                                    name:'N101Y_AMT',
                                    readOnly:true,
                                    width:150,
                                    listeners:{
                                    	render:function(c)	{
                                    		c.getEl().on('click', function(component){
                                    			hadPdfStore.refreshFilter('N101Y');
                                    			var grid = pdfWin.down('#hadPdfGrid');
                                    			grid.getColumn('DATA_NAME').hide();
                                    			grid.getColumn('CARD_TYPE_NAME').hide();
                                    			grid.getColumn('SBDY_APLN_SUM').hide();
                                    			grid.getColumn('CONB_SUM').hide();
                                    		});
                                    	}
                                    }
                            	},{
                                    fieldLabel: '소기업/소상공인 공제부금',
                                    hideLabel:true,
                                    xtype:'uniNumberfield',
                                    name:'K101M_AMT',
                                    readOnly:true,
                                    width:150,
                                    listeners:{
                                    	render:function(c)	{
                                    		c.getEl().on('click', function(component){
                                    			hadPdfStore.refreshFilter('K101M');
                                    			var grid = pdfWin.down('#hadPdfGrid');
                                    			grid.getColumn('DATA_NAME').hide();
                                    			grid.getColumn('CARD_TYPE_NAME').hide();
                                    			grid.getColumn('SBDY_APLN_SUM').hide();
                                    			grid.getColumn('CONB_SUM').hide();
                                    		});
                                    	}
                                    }
                            	},{
                                    fieldLabel: '기부금',
                                    hideLabel:true,
                                    xtype:'uniNumberfield',
                                    name:'L102Y_AMT',
                                    readOnly:true,
                                    width:150,
                                    listeners:{
                                    	render:function(c)	{
                                    		c.getEl().on('click', function(component){
                                    			hadPdfStore.refreshFilter('L102Y');
                                    			var grid = pdfWin.down('#hadPdfGrid');
                                    			grid.getColumn('DATA_NAME').show();
                                    			grid.getColumn('CARD_TYPE_NAME').hide();
                                    			grid.getColumn('SBDY_APLN_SUM').show();
                                    			grid.getColumn('CONB_SUM').hide();
                                    		});
                                    	}
                                    }
                            	}
                            ],
                            api:{
                            	load:'had618ukrService.selectPDFSummary'
                            }
						},{
                            xtype:'container',
                            flex:1,
                            layout: {type:'vbox', align:'stretch'},
                            items:[
                                Unilite.createGrid('hadPdfGrid', {
                                    layout : 'fit',
                                    store : hadPdfStore,
                                    itemId:'hadPdfGrid',
                                    sortableColumns: true,
                                    uniOpt:{
                                        expandLastColumn: false,    //마지막 컬럼 * 사용 여부
                                        useRowNumberer: false,        //첫번째 컬럼 순번 사용 여부
                                        useLiveSearch: false,        //찾기 버튼 사용 여부
                                        filter: {                    //필터 사용 여부
                                            useFilter: false,
                                            autoCreate: false
                                        },
                                        state: {
                                            useState: false,            //그리드 설정 버튼 사용 여부
                                            useStateList: false        //그리드 설정 목록 사용 여부
                                        },
                                        excel: {
											useExcel: false,			//엑셀 다운로드 사용 여부
											exportGroup : false, 		//group 상태로 export 여부
											onlyData:false,
											summaryExport:false
										}
                                    },
                                    columns:  [
                                        {dataIndex: 'TARGET_YN', xtype:'checkcolumn', width:40},
                                        {dataIndex: 'GUBUN_NAME'    	, width: 120},
                                        {dataIndex: 'D_NAME'    		, width: 80},
                                        {dataIndex: 'D_REPRE_NUM'   	, width: 130},
                                        {dataIndex: 'DATA_NAME'     	, width: 120},
                                        {dataIndex: 'CARD_TYPE_NAME'    , width: 120, hidden: true},
                                        {dataIndex: 'USE_AMT'           , width: 120},
                                        {dataIndex: 'SBDY_APLN_SUM'     , width: 120, hidden: true},
                                        {dataIndex: 'CONB_SUM'     		, width: 120, hidden: true}
                                    ]
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
                                itemId : 'saveBtn',
                                text: '저장',
                                width:100,
                                handler: function() {
                                    hadPdfStore.saveStore();
                                },
                                disabled: false
                            },{
                                itemId : 'closeBtn',
                                text: '닫기',
                                width:100,
                                handler: function() {
                                	if(hadPdfStore.isDirty())	{
	                                	if(confirm('저장할 데이타가 있습니다. 저장 하시겠습니까?'))	{
	                             			hadPdfStore.saveStore({
	                             				success:function()	{
	                             					pdfWin.unmask();
	                             					pdfWin.hide();
	                             				}
	                             			})
			                            } else {
	                                    	pdfWin.hide();
			                            }
                                	}else {
                                		pdfWin.hide();
                                	}
                                },
                                disabled: false
                            }
                        ]
                    },
                    listeners : {
                        beforehide: function(me, eOpt)    {
                        	pdfWin.paramData=null;
                        	var searchForm =  pdfWin.down('#search');
                        	var summaryForm =  pdfWin.down('#summary');
                        	var pdfGrid =  pdfWin.down('#hadPdfGrid');

                        	searchForm.reset();
                        	summaryForm.reset();
                        	hadPdfStore.loadData({});
                        	UniAppManager.app.onQueryButtonDown();
                        },
                        beforeclose: function( panel, eOpts )    {
                        	pdfWin.paramData=null;
                        	var searchForm =  pdfWin.down('#search');
                        	var summaryForm =  pdfWin.down('#summary');
                        	var pdfGrid =  pdfWin.down('#hadPdfGrid');

                        	searchForm.reset();
                        	summaryForm.reset();
                        	pdfGrid.reset();
                        },
                        beforeshow: function( panel, eOpts )    {
                            var searchForm =  pdfWin.down('#search');
                            searchForm.setValue("YEAR_YYYY"        ,pdfWin.paramData.YEAR_YYYY);
                            searchForm.setValue("NAME"            ,pdfWin.paramData.NAME);
                            searchForm.setValue("PERSON_NUMB"    ,pdfWin.paramData.PERSON_NUMB);

                        }
                    },
                    loadSummary:function(key, value)	{
                    	var searchForm =  pdfWin.down('#search');
                    	if(!searchForm.isValid())	{
                    		return;
                    	}
                    	pdfWin.paramData = searchForm.getValues();
                    	if(key && value)	{
                    		pdfWin.paramData[key] = value;
                    	}
                    	var summaryForm =  pdfWin.down('#summary');
			        	if(pdfWin.paramData.PERSON_NUMB)	{
				        	summaryForm.load({
				        		params:pdfWin.paramData,
				        		success:function(form, action){
				        			//pdfWin.loadDataList('A102Y');
				        			hadPdfStore.loadStoreRecords('A102Y');
				        		},
				        		failure:function(form, action){

				        		}
				        	});
			        	}
                    },
                    applyData:function()	{
                    	pdfWin.mask();
                    	had618ukrService.spYearTaxPdf(pdfWin.paramData, function(responseText, response){
                    		console.log("responseText : ", responseText);
                    		console.log("response : ", response);
                    		alert("PDF자료가 반영되었습니다.");
                    		pdfWin.unmask();
                    	})
                    }
                });
            }
            pdfWin.paramData = paramData;
            pdfWin.center();
            pdfWin.show();
        	pdfWin.loadSummary();

        }
        });



};
</script>
