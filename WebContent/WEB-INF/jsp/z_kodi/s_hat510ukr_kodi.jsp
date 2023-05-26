<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat510ukr_kodi"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_hat510ukr_kodi"  /> 	<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
    <t:ExtComboStore comboType="AU" comboCode="H033" /> 				<!-- 근태코드 --> 
    <t:ExtComboStore comboType="AU" comboCode="H028" /> 				<!-- 급여지급방식 -->
    <t:ExtComboStore comboType="AU" comboCode="H033" /> 				<!-- 근태명 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	var excelWindow;
	
	var colData = ${colData};
	console.log(colData);
	
//	var fields = createModelField(colData);
	var columns = createGridColumn(colData);
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hat510ukr_kodiModel', {
		fields: [
						{name: 'DIV_CODE'			,	text: '사업장코드',	type: 'string'},
						{name: 'DEPT_CODE'			,   text: '부서코드',		type: 'string'},
						{name: 'DEPT_NAME'			,	text: '부서',			type: 'string'},						
						{name: 'PERSON_NUMB'		,	text: '사번',			type: 'string'},
						{name: 'NAME'				,   text: '성명',			type: 'string'},						
						{name: 'JOIN_DATE'			, 	text: '입사일', 		type: 'uniDate'},
						{name: 'DUTY_YYYYMM'		,   text: '근태년월',		type: 'string'},
						//{name: 'DUTY_CODE', 			text: '근태코드', 		type: 'string'}
						{name: 'DUTY_CODE_01'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_01'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_01'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_01'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_01'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_01'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_02'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_02'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_02'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_02'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_02'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_02'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_03'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_03'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_03'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_03'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_03'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_03'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_04'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_04'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_04'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_04'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_04'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_04'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_05'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_05'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_05'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_05'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_05'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_05'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						
						{name: 'DUTY_CODE_06'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_06'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_06'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_06'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_06'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_06'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_07'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_07'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_07'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_07'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_07'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_07'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_08'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_08'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_08'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_08'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_08'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_08'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_09'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_09'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_09'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_09'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_09'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_09'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_10'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_10'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_10'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_10'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_10'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_10'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_11'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_11'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_11'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_11'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_11'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_11'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_12'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_12'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_12'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_12'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_12'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_12'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						
						{name: 'DUTY_CODE_13'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_13'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_13'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_13'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_13'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_13'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						
						{name: 'DUTY_CODE_14'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_14'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_14'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_14'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_14'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_14'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						
						{name: 'DUTY_CODE_15'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_15'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_15'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_15'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_15'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_15'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_16'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_16'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_16'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_16'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_16'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_16'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_17'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_17'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_17'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_17'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_17'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_17'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_18'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_18'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_18'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_18'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_18'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_18'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_19'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_19'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_19'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_19'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_19'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_19'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_20'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_20'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_20'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_20'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_20'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_20'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_21'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_21'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_21'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_21'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_21'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_21'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_22'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_22'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_22'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_22'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_22'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_22'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_23'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_23'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_23'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_23'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_23'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_23'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_24'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_24'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_24'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_24'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_24'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_24'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						
						{name: 'DUTY_CODE_25'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_25'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_25'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_25'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_25'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_25'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_26'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_26'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_26'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_26'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_26'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_26'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_27'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_27'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_27'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_27'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_27'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_27'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_28'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_28'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_28'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_28'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_28'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_28'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_29'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_29'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_29'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_29'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_29'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_29'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_30'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_30'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_30'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_30'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_30'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_30'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_CODE_31'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_31'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_51_31'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_52_31'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_NUM_54_31'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},	
						{name: 'DUTY_NUM_56_31'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						
						{name: 'DUTY_51_SUM'		, text: '연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_52_SUM'		, text: '야간' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_54_SUM'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'},
						{name: 'DUTY_56_SUM'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.0'}
		]
	});
	
	
	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.hat600ukr.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '법인코드'	 		, type: 'string'},
			{name: 'DUTY_YYYYMM'		, text: '근태년월'	 		, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'	 		, type: 'string' , allowBlank: false},
			{name: 'NAME'				, text: '성명'		 	, type: 'string' , allowBlank: false},
			
			{name: 'DUTY_CODE_01'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_01'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_01'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_01'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_01'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_01'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_02'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_02'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_02'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_02'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_02'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_02'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_03'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_03'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_03'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_03'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_03'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_03'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_04'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_04'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_04'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_04'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_04'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_04'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_05'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_05'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_05'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_05'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_05'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_05'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			
			{name: 'DUTY_CODE_06'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_06'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_06'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_06'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_06'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_06'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_07'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_07'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_07'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_07'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_07'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_07'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_08'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_08'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_08'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_08'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_08'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_08'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_09'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_09'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_09'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_09'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_09'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_09'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_10'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_10'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_10'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_10'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_10'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_10'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_11'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_11'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_11'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_11'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_11'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_11'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_12'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_12'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_12'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_12'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_12'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_12'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			
			{name: 'DUTY_CODE_13'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_13'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_13'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_13'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_13'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_13'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			
			{name: 'DUTY_CODE_14'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_14'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_14'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_14'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_14'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_14'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			
			{name: 'DUTY_CODE_15'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_15'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_15'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_15'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_15'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_15'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_16'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_16'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_16'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_16'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_16'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_16'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_17'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_17'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_17'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_17'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_17'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_17'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_18'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_18'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_18'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_18'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_18'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_18'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_19'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_19'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_19'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_19'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_19'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_19'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_20'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_20'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_20'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_20'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_20'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_20'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_21'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_21'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_21'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_21'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_21'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_21'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_22'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_22'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_22'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_22'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_22'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_22'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_23'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_23'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_23'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_23'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_23'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_23'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_24'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_24'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_24'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_24'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_24'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_24'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			
			{name: 'DUTY_CODE_25'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_25'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_25'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_25'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_25'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_25'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_26'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_26'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_26'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_26'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_26'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_26'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_27'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_27'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_27'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_27'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_27'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_27'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_28'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_28'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_28'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_28'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_28'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_28'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_29'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_29'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_29'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_29'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_29'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_29'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_30'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_30'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_30'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_30'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_30'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_30'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			
			{name: 'DUTY_CODE_31'		, text: '근태종류'		    , type: 'string'},
			{name: 'DUTY_NUM_BASE_31'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_51_31'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_52_31'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
			{name: 'DUTY_NUM_54_31'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
			{name: 'DUTY_NUM_56_31'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'}
			
						
		]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 's_hat510ukr_kodiService.selectList',
    	   	create 	: 's_hat510ukr_kodiService.insertDetail',
			syncAll	: 's_hat510ukr_kodiService.saveAll'
		}
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('s_hat510ukr_kodiMasterStore1',{
		model: 's_hat510ukr_kodiModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
        autoLoad: false,
        proxy: directProxy,
		listeners : {
	        load : function(store, records, successful, eOpts) {
	        	
	        }
	    },
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
            var paramMaster= panelSearch.getValues();    // syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                    }
                };
                this.syncAllDirect(config);
            } else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
		}

	});	//End of var directMasterStore1 = Unilite.createStore('hat520skrMasterStore1',{

	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
				fieldLabel: '근태년월',
				id: 'DUTY_YYYYMMDD',
				xtype: 'uniMonthfield',
				name: 'DUTY_YYYYMMDD',                    
				value: new Date(),                    
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FR_DATE', newValue);
					}
				}
			},
				Unilite.popup('Employee', {
					
//					validateBlank: false,
					//allowBlank: false,
					extParam: {'CUSTOM_TYPE': '3'},
					id: 'PERSON_NUMB',
					listeners: {'onSelected': {
						fn: function(records, type) {
//							console.log(records);
							panelResult.setValue('PERSON_NUMB', records[0].PERSON_NUMB);
							panelResult.setValue('NAME', records[0].NAME);
							panelSearch.setValue('DIV_CODE', records[0].DIV_CODE);
							panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
							panelSearch.setValue('DEPT_CODE', records[0].DEPT_CODE);
							panelSearch.setValue('DEPT_NAME', records[0].DEPT_NAME);
							panelResult.setValue('DEPT_CODE', records[0].DEPT_CODE);
							panelResult.setValue('DEPT_NAME', records[0].DEPT_NAME);
							panelSearch.getForm().findField('PAY_CODE').setValue(records[0].PAY_CODE);
							panelSearch.getForm().findField('PAY_PROV_FLAG').setValue(records[0].PAY_PROV_FLAG);
							panelSearch.getForm().findField('JOIN_DATE').setValue(UniDate.getDbDateStr(records[0].JOIN_DATE));
							panelSearch.getForm().findField('RETR_DATE').setValue(UniDate.getDbDateStr(records[0].RETR_DATE));
							
							Ext.Ajax.request({
								url     : CPATH+'/human/getPostName.do',
								params: { POST_CODE: records[0].POST_CODE, S_COMP_CODE: UserInfo.compCode },
								success: function(response){
									var data = Ext.decode(response.responseText);
									console.log(data);
									if (data.POST_NAME != '' && data.POST_NAME != null) {
										panelSearch.getForm().findField('POST_NAME').setValue(data.POST_NAME);
									}
								},
								failure: function(response){
									console.log(response);
								}
							});
							
						},
						scope: this
						},
						'onClear': function(type) {
							panelResult.setValue('PERSON_NUMB', '');
							panelResult.setValue('NAME', '');
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
							panelResult.setValue('POST_NAME', '');
							//panelResult.setValue('DIV_CODE', '');
							
							//panelSearch.setValue('DIV_CODE', '');
							panelSearch.setValue('POST_NAME', '');
							panelSearch.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
							panelSearch.setValue('POST_NAME', '');
							panelSearch.getForm().findField('PAY_CODE').setValue('');
							panelSearch.getForm().findField('PAY_PROV_FLAG').setValue('');
							panelSearch.getForm().findField('JOIN_DATE').setValue('');
							panelSearch.getForm().findField('RETR_DATE').setValue('');
						},
						onTextSpecialKey : function(){
							masterGrid.getStore().loadStoreRecords();													
						}
					}
			}),
				Unilite.popup('DEPT', {
				readOnly: true,
				fieldLabel: '부서', 
				listeners: {
					onSelected: {
						fn: function(records, type) {
	//						panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
	//						panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
	//					panelResult.setValue('DEPT_CODE', '');
	//					panelResult.setValue('DEPT_NAME', '');
					}
				}
			}),{
    			fieldLabel: '사업장',
    			//readOnly: true,
    			name: 'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
    			allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		},{
        		xtype: 'uniTextfield',
        		readOnly: true,
        		fieldLabel: '직위',
        		name: 'POST_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('POST_NAME', newValue);
					}
				}
        	},{
				fieldLabel: '지급차수',
				name: 'PAY_PROV_FLAG',
				xtype: 'hiddenfield'
			},{
				fieldLabel: '입사일',
				name: 'JOIN_DATE',
				xtype: 'hiddenfield'
			},{
				fieldLabel: '퇴사일',
				name: 'RETR_DATE',
				xtype: 'hiddenfield'
			},{
				fieldLabel: '지급구분',
				name: 'PAY_CODE',
				id: 'PAY_CODE',
				xtype: 'hiddenfield'
			}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '근태년월',
			xtype: 'uniMonthfield',
			name: 'DUTY_YYYYMMDD',                    
			value: new Date(),                    
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DUTY_YYYYMMDD', newValue);
				}
			}
		},
		{
			fieldLabel: '사업장',
			//readOnly: true,
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
			Unilite.popup('Employee', {
				colspan: 2,
				
//				validateBlank: false,
				//allowBlank: false,
				extParam: {'CUSTOM_TYPE': '3'},
				listeners: {'onSelected': {
					fn: function(records, type) {
						console.log(records);
						panelSearch.setValue('PERSON_NUMB', records[0].PERSON_NUMB);
						panelSearch.setValue('NAME', records[0].NAME);
						panelSearch.setValue('DIV_CODE', records[0].DIV_CODE);
						panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
						panelResult.setValue('DEPT_CODE', records[0].DEPT_CODE);
						panelResult.setValue('DEPT_NAME', records[0].DEPT_NAME);
						panelSearch.setValue('DEPT_CODE', records[0].DEPT_CODE);
						panelSearch.setValue('DEPT_NAME', records[0].DEPT_NAME);
						//panelSearch.getForm().findField('PAY_CODE').setValue(records[0].PAY_CODE);
						//panelSearch.getForm().findField('PAY_PROV_FLAG').setValue(records[0].PAY_PROV_FLAG);
						//panelSearch.getForm().findField('JOIN_DATE').setValue(UniDate.getDbDateStr(records[0].JOIN_DATE));
						//panelSearch.getForm().findField('RETR_DATE').setValue(UniDate.getDbDateStr(records[0].RETR_DATE));
						
						Ext.Ajax.request({
							url     : CPATH+'/human/getPostName.do',
							params: { POST_CODE: records[0].POST_CODE, S_COMP_CODE: UserInfo.compCode },
							success: function(response){
								var data = Ext.decode(response.responseText);
								console.log(data);
								if (data.POST_NAME != '' && data.POST_NAME != null) {
									panelSearch.getForm().findField('POST_NAME').setValue(data.POST_NAME);
								}
							},
							failure: function(response){
								console.log(response);
							}
						});
						
					},
					scope: this
					},
					'onClear': function(type) {
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
						panelSearch.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
						panelSearch.setValue('POST_NAME', '');
						//panelSearch.setValue('DIV_CODE', '');
						//panelSearch.getForm().findField('PAY_CODE').setValue('');
						//panelSearch.getForm().findField('PAY_PROV_FLAG').setValue('');
						//panelSearch.getForm().findField('JOIN_DATE').setValue('');
						//panelSearch.getForm().findField('RETR_DATE').setValue('');
						
						//panelResult.setValue('DIV_CODE', '');
						panelResult.setValue('POST_NAME', '');
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					onTextSpecialKey : function(){
						masterGrid.getStore().loadStoreRecords();													
					}
				}
		}),
			Unilite.popup('DEPT', { 
			readOnly: true,
			fieldLabel: '부서', 
			listeners: {
				onSelected: {
					fn: function(records, type) {
//						panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
//						panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
//					panelResult.setValue('DEPT_CODE', '');
//					panelResult.setValue('DEPT_NAME', '');
				}
			}
		}),{
    		xtype: 'uniTextfield',
    		readOnly: true,
    		fieldLabel: '직위',
    		name: 'POST_NAME',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('POST_NAME', newValue);
				}
			}
    	}]	
    });
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_hat510ukr_kodiGrid1', {
    	// for tab    	
        layout: 'fit',
        region:'center',
        sortableColumns: false,
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
		}
		,

        tbar  : [{
            text    : '근태정보 업로드',
            itemId: 'excelBtn',
            id  : 'upBtn',
            width   : 150,
            handler : function() {
                if(!panelResult.getInvalidMessage()) return;   //필수체크
                openExcelWindow();
            }
        }],
        
    	store: directMasterStore1,
    	columns: columns
    });//End of var masterGrid = Unilite.createGrid('hat520skrGrid1', {
	
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
		id: 's_hat510ukr_kodiApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			//panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			//panelSearch.setValue('ORDER_DATE_FR', UniDate.get('today'));
			//panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			//panelResult.setValue('ORDER_DATE_FR', UniDate.get('today'));			
			UniAppManager.setToolbarButtons('reset',true);

	        Ext.getCmp('upBtn').setDisabled(true);
			//var activeSForm ;
			//if(!UserInfo.appOption.collapseLeftSearch)	{
			//	activeSForm = panelSearch;
			//}else {
			//	activeSForm = panelResult;
			//}
			//panelResult
			//panelResult.onLoadSelectText('ORDER_DATE_FR');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			
			//그리드 컬럼명 조건에 맞게 재 조회하여 입력
			var param = Ext.getCmp('searchForm').getValues();
			s_hat510ukr_kodiService.selectDutycode2(param, function(provider, response) {
					if(!Ext.isEmpty(provider)){
						var records = response.result;

						//그리드 컬럼명 조건에 맞게 재 조회하여 입력
						var colData = records;
						console.log(colData);
						
//						var fields = createModelField(colData);
						var columns = createGridColumn(colData);
						masterGrid.setConfig('columns', columns);
						
						panelResult.getField('DUTY_YYYYMMDD').setReadOnly(true);
						Ext.getCmp('upBtn').setDisabled(false);

					} else {
						
						alert('조회된 데이터가 없습니다.');
						UniAppManager.app.onResetButtonDown();
						panelResult.getField('DUTY_YYYYMMDD').setReadOnly(false);
						Ext.getCmp('upBtn').setDisabled(false);
					}
				});
						
			masterGrid.getStore().loadStoreRecords();
		}
		,onSaveDataButtonDown: function (config) {

			directMasterStore1.saveStore(config);

		}
		 ,onResetButtonDown:function() {
            //panelResult.clearForm();
            masterGrid.getStore().loadData({});
            panelResult.getField('DUTY_YYYYMMDD').setReadOnly(false);
            Ext.getCmp('upBtn').setDisabled(true);
            
            this.fnInitBinding();
        }
	});
	
/*	// 모델 필드 생성
	function createModelField(colData) {
		
		var fields = [
						{name: 'DIV_CODE',				text: '사업장코드',	type: 'string'	, comboType:'AU', comboCode:'BOR120'},
						{name: 'DEPT_CODE',				text: '부서코드',		type: 'string'},
						{name: 'DEPT_NAME',				text: '부서',			type: 'string'},						
						{name: 'PERSON_NUMB',			text: '사번',			type: 'string'},
						{name: 'NAME',					text: '성명',			type: 'string'},						
						{name: 'JOIN_DATE', 			text: '입사일', 		type: 'uniDate'},
						//{name: 'DUTY_CODE', 			text: '근태코드', 		type: 'string'}
						{name: 'DUTY_CODE_01'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_01'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_01'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_01'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_01'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_01'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_02'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_02'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_02'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_02'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_02'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_02'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_03'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_03'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_03'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_03'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_03'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_03'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_04'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_04'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_04'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_04'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_04'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_04'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_05'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_05'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_05'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_05'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_05'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_05'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						
						{name: 'DUTY_CODE_06'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_06'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_06'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_06'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_06'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_06'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_07'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_07'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_07'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_07'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_07'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_07'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_08'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_08'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_08'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_08'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_08'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_08'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_09'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_09'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_09'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_09'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_09'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_09'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_10'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_10'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_10'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_10'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_10'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_10'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_11'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_11'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_11'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_11'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_11'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_11'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_12'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_12'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_12'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_12'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_12'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_12'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						
						{name: 'DUTY_CODE_13'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_13'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_13'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_13'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_13'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_13'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						
						{name: 'DUTY_CODE_14'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_14'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_14'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_14'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_14'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_14'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						
						{name: 'DUTY_CODE_15'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_15'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_15'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_15'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_15'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_15'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_16'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_16'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_16'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_16'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_16'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_16'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_17'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_17'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_17'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_17'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_17'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_17'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_18'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_18'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_18'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_18'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_18'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_18'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_19'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_19'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_19'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_19'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_19'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_19'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_20'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_20'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_20'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_20'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_20'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_20'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_21'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_21'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_21'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_21'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_21'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_21'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_22'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_22'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_22'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_22'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_22'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_22'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_23'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_23'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_23'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_23'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_23'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_23'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_24'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_24'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_24'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_24'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_24'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_24'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						
						{name: 'DUTY_CODE_25'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_25'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_25'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_25'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_25'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_25'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_26'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_26'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_26'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_26'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_26'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_26'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_27'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_27'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_27'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_27'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_27'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_27'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_28'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_28'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_28'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_28'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_28'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_28'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_29'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_29'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_29'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_29'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_29'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_29'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_30'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_30'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_30'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_30'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_30'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_30'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						
						{name: 'DUTY_CODE_31'		, text: '근태종류'		    , type: 'string'},
						{name: 'DUTY_NUM_BASE_31'	, text: '근태일수'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_51_31'		, text: '연장'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_52_31'		, text: '야간'		    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},
						{name: 'DUTY_NUM_54_31'		, text: '휴일정상' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'},	
						{name: 'DUTY_NUM_56_31'		, text: '휴일연장' 	    , type: 'float' , decimalPrecision: 2  , format:'0,000.00'}
						
					];
//					
//		Ext.each(colData, function(item, index){
//			
//			fields.push({name: item.BASE_CODE, text: '근태종류', 	type:'string', comboType:'AU', comboType:'H033'});
//			fields.push({name: item.BASE_DATE, text: '근태일수', 	type:'float',   decimalPrecision:2, format:'0,000.0' });
//			fields.push({name: item.C51_DATE,  text: '연장', 		type:'float',   decimalPrecision:2, format:'0,000.0' });
//			fields.push({name: item.C52_DATE,  text: '야간', 		type:'float',   decimalPrecision:2, format:'0,000.0' });
//			fields.push({name: item.C54_DATE,  text: '휴일정상', 	type:'float',   decimalPrecision:2, format:'0,000.0' });
//			fields.push({name: item.C56_DATE,  text: '휴일연장', 	type:'float',   decimalPrecision:2, format:'0,000.0' });
//			
//		});
		console.log(fields);
		return fields;
	}
*/	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var columns = [
		   			{dataIndex: 'DIV_CODE'	,	text:'사업장', 	width: 86, 	align: 'center'				, 	hidden: true,locked:true},
					{dataIndex: 'PERSON_NUMB',	text:'사번',		width: 120, style : 'text-align:center',	locked:true},
					{dataIndex: 'NAME',			text:'성명',		width: 86, 	style : 'text-align:center' ,	locked:true},
					{dataIndex: 'DUTY_YYYYMM',	text:'근태년월',	width: 86, 	style : 'text-align:center' ,	hidden: true,locked:true},
					{dataIndex: 'DEPT_CODE',	text:'부서코드', 	width: 86, 	style : 'text-align:center',	hidden: true,locked:true},
					{dataIndex: 'DEPT_NAME',	text:'부서',		width: 120, style : 'text-align:center' ,	locked:true},
					{dataIndex: 'JOIN_DATE',	text:'입사일',	width: 120, style : 'text-align:center', 	xtype: 'uniDateColumn',locked:true}
					//{dataIndex: 'DUTY_CODE',	text:'근태코드',	width: 93}
				];
					
		Ext.each(colData, function(item, index){
			columns.push({text: item.DATE_DAY,
				columns:[ 
					{text:item.WEEK_DAY,
						columns:[
							{dataIndex: item.BASE_CODE, text:'근태종류',width:80, 	type:'string', align: 'center'},
							{dataIndex: item.BASE_DATE, text:'근태일수',width:80, 	type:'float',  align: 'center' , xtype:'uniNnumberColumn', format:'0,000.0', 	hidden: true},
							{dataIndex: item.C51_DATE, 	text:'연장',width:80, 	type:'float',  align: 'center' , xtype:'uniNnumberColumn', format:'0,000.0'},
							{dataIndex: item.C52_DATE, 	text:'야간',width:80, 	type:'float',  align: 'center' , xtype:'uniNnumberColumn', format:'0,000.0'},
							{dataIndex: item.C54_DATE, 	text:'휴일정상',width:80, 	type:'float',  align: 'center' , xtype:'uniNnumberColumn', format:'0,000.0'},
							{dataIndex: item.C56_DATE, 	text:'휴일연장',width:80, 	type:'float',  align: 'center' , xtype:'uniNnumberColumn', format:'0,000.0'}
						]}
			]});
		});
		
		columns.push({text: '근태',
				columns:[ 
					{text:'평일',
						columns:[
							{dataIndex: 'DUTY_51_SUM' , text:'연장',width:80,		type:'float',  align: 'center', xtype:'uniNnumberColumn', format:'0,000.0'},
							{dataIndex: 'DUTY_52_SUM',  text:'야간',width:80, 	type:'float',  align: 'center', xtype:'uniNnumberColumn', format:'0,000.0'}
							
							
						]}
			]});
			
		columns.push({text: '근태',
				columns:[ 
					{text:'휴일',
						columns:[
							{dataIndex: 'DUTY_54_SUM', 	text:'정상',width:80, 	type:'float',  align: 'center' , xtype:'uniNnumberColumn', format:'0,000.0'},
							{dataIndex: 'DUTY_56_SUM', 	text:'연장',width:80, 	type:'float',  align: 'center' , xtype:'uniNnumberColumn', format:'0,000.0'}
							
						]}
			]});
			
		console.log(columns);
		return columns;
	}
	
	
	
	
	function openExcelWindow() {
	    var me = this;
        var vParam = {};
        var records;
        var colData;

        var appName = 'Unilite.com.excel.ExcelUpload';
        
        //var record = directMasterStore1.getSelectedRecord();
        
        if(!directMasterStore1.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
            //masterStore.loadData({});
        } else {
            if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
                UniAppManager.app.onSaveDataButtonDown();
                return;
            }else {
                directMasterStore1.loadData({});
            }
        }
        
        if(!excelWindow) { 
        	excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
				modal: false,
            	excelConfigName: 's_hat510ukr_kodi',
        		extParam: { 
                    'PGM_ID'    : 's_hat510ukr_kodi'
        		},
                grids: [{							//팝업창에서 가져오는 그리드
                		itemId		: 'grid01',
                		title		: '근태자료 업로드',                        		
                		useCheckbox	: false,
                		model		: 'excel.hat600ukr.sheet01',
                		readApi		: 's_hat510ukr_kodiService.selectExcelUploadSheet',
                		columns		: [	
                			{dataIndex: '_EXCEL_JOBID'		, width: 80,	hidden: false},
							{dataIndex: 'COMP_CODE'  		, width: 120,   hidden: false},
							{dataIndex: 'DUTY_YYYYMM'		, width: 100},
							{dataIndex: 'PERSON_NUMB'		, width: 100},
							{dataIndex: 'NAME'				, width: 100},							
							
							{dataIndex: 'DUTY_CODE_01'		, width: 100},							
							{dataIndex: 'DUTY_NUM_BASE_01'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_01'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_01'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_01'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_01'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_02'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_02'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_02'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_02'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_02'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_02'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_03'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_03'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_03'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_03'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_03'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_03'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_04'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_04'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_04'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_04'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_04'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_04'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_05'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_05'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_05'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_05'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_05'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_05'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_06'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_06'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_06'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_06'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_06'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_06'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_07'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_07'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_07'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_07'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_07'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_07'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_08'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_08'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_08'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_08'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_08'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_08'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_09'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_09'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_09'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_09'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_09'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_09'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_10'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_10'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_10'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_10'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_10'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_10'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_11'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_11'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_11'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_11'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_11'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_11'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_12'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_12'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_12'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_12'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_12'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_12'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_13'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_13'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_13'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_13'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_13'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_13'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_14'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_14'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_14'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_14'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_14'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_14'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_15'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_15'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_15'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_15'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_15'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_15'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_16'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_16'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_16'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_16'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_16'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_16'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_17'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_17'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_17'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_17'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_17'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_17'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_18'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_18'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_18'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_18'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_18'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_18'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_19'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_19'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_19'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_19'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_19'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_19'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_20'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_20'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_20'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_20'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_20'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_20'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_21'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_21'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_21'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_21'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_21'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_21'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_22'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_22'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_22'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_22'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_22'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_22'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_23'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_23'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_23'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_23'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_23'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_23'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_24'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_24'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_24'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_24'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_24'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_24'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_25'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_25'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_25'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_25'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_25'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_25'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_26'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_26'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_26'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_26'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_26'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_26'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_27'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_27'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_27'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_27'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_27'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_27'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_28'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_28'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_28'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_28'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_28'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_28'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_29'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_29'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_29'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_29'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_29'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_29'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_30'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_30'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_30'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_30'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_30'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_30'	, width: 100	, align: 'right'},
							
							{dataIndex: 'DUTY_CODE_31'		, width: 100},
							{dataIndex: 'DUTY_NUM_BASE_31'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_51_31'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_52_31'	, width: 80		, align: 'right'},
							{dataIndex: 'DUTY_NUM_54_31'	, width: 100	, align: 'right'},
							{dataIndex: 'DUTY_NUM_56_31'	, width: 100	, align: 'right'}
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
						directMasterStore1.clearData();
						
						s_hat510ukr_kodiService.selectExcelUploadSheet(param, function(provider, response){
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
