<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpb510skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {   
	var TypeStore = Unilite.createStore('TypeStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'거주자사업소득'		, 'value':'1'},
			        {'text':'거주자기타소득'	    , 'value':'2'},
			        {'text':'비거주자사업기타소득'	, 'value':'3'},
			        {'text':'이자,배당소득'	    , 'value':'4'}
	    		]
	});
	
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpb510skrModelBiz1', {
	    fields: [  	  
		    {name: 'MEDIUM_TYPE'				, text: '전산매체유형' 	,type: 'string'},
		    {name: 'TAX_YYYY'				, text: '정산년도' 		,type: 'string'},
		    {name: 'DEGREE'					, text: '차수' 	,type: 'string'},
		    {name: 'RECORD_GUBUN'				, text: '레코드 구분' 	,type: 'string'},
		    {name: 'DATA_GUBUN'			, text: '자료구분' 	,type: 'string'},
		    {name: 'TAX_OFFICE'				, text: '세무서' 		,type: 'string'},
		    {name: 'SUBMIT_DATE'				, text: '제출년월일' 	,type: 'uniDate'},
		    
		    {name: 'SUBMIT_GUBUN'				, text: '제출자구분' 	,type: 'string'},
		    {name: 'MANAGE_NO'			, text: '관리번호' 	,type: 'string'},
		    {name: 'HOMETAX_NO'				, text: '홈택스ID' 		,type: 'string'},
		    {name: 'TAX_PROGRAM'				, text: '세무프로그램코드' 	,type: 'string'},
		    
		    {name: 'COMPANY_NUM'				, text: '사업자등록번호' 	,type: 'string'},
		    {name: 'COMPANY_NAME'			, text: '법인명(상호)' 	,type: 'string'},
		    {name: 'CHARGE_DEPT'				, text: '담당자 부서' 		,type: 'string'},
		    {name: 'CHARGE_NAME'				, text: '담당자 성명' 	,type: 'string'},
		    
		    {name: 'CHARGE_TEL'				, text: '담당자 전화번호' 	,type: 'string'},
		    {name: 'REPORTER_CNT'			, text: '신고의무자수' 	,type: 'uniNumber'},
		    {name: 'FILL_SPACE'				, text: '공란수' 		,type: 'string'},
		]          
	});
	
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpb510skrModelIntr1', {
	    fields: [  	  
		    {name: 'MEDIUM_TYPE'				, text: '전산매체유형' 	,type: 'string'},
		    {name: 'TAX_YYYY'				, text: '정산년도' 		,type: 'string'},
		    {name: 'DEGREE'					, text: '차수' 	,type: 'string'},
		    {name: 'RECORD_GUBUN'				, text: '레코드 구분' 	,type: 'string'},
		    {name: 'DATA_GUBUN'			    , text: '자료구분' 	,type: 'string'},
		    {name: 'TAX_OFFICE'				, text: '세무서' 		,type: 'string'},
		    {name: 'SUBMIT_DATE'				, text: '제출년월일' 	,type: 'uniDate'},		    
		    {name: 'SUBMIT_GUBUN'				, text: '제출자구분' 	,type: 'string'},
		    {name: 'MANAGE_NO'			       , text: '관리번호' 	,type: 'string'},
		    {name: 'HOMETAX_NO'				, text: '홈택스ID' 		,type: 'string'},
		    {name: 'TAX_PROGRAM'				, text: '세무프로그램코드' 	,type: 'string'},
		    
		    {name: 'COMPANY_NUM'				, text: '사업자등록번호' 	,type: 'string'}, 
		    {name: 'COMPANY_NAME'				, text: '법인명(상호)' 		,type: 'string'}, 
		    {name: 'CHARGE_DEPT'				, text: '담당자 부서' 		,type: 'string'},
		    {name: 'CHARGE_NAME'				, text: '담당자 성명' 	,type: 'string'},		    
		    {name: 'CHARGE_TEL'				, text: '담당자 전화번호' 	,type: 'string'},
		    
		    {name: 'SUPP_CNT'				, text: '총제출건수' 		,type: 'uniNumber'},	
		    {name: 'SUPP_TOTAL'				, text: '소득금액합계' 	,type: 'uniPrice'},
		    {name: 'IN_TAX'				    , text: '소득세액합계' 	,type: 'uniPrice'},
		    {name: 'CP_TAX'				    , text: '법인세합계' 	,type: 'uniPrice'},
		   
		    {name: 'NEW_SUPP_CNT'				, text: '귀속당초 제출건수' 	,type: 'uniPrice'},
		    {name: 'NEW_SUPP_TOTAL'				, text: '귀속당초 소득합계' 	,type: 'uniPrice'},
		    {name: 'DEL_SUPP_CNT'				, text: '귀속삭제 제출건수' 	,type: 'uniPrice'},
		    {name: 'DEL_SUPP_TOTAL'				, text: '귀속삭제 소득합계' 	,type: 'uniPrice'},
		    {name: 'UPD_SUPP_CNT'				, text: '귀속수정 제출건수' 	,type: 'uniPrice'},
		    {name: 'UPD_SUPP_TOTAL'				, text: '귀속수정 소득합계' 	,type: 'uniPrice'},
		      
		    {name: 'REPORTER_CNT'			, text: '신고의무자수' 	,type: 'uniNumber'},
		    {name: 'FILL_SPACE'				, text: '공란수1' 		,type: 'string'},
		    {name: 'FILL_SPACE2'			, text: '공란수2' 		,type: 'string'},
		]          
	});
	
	
	Unilite.defineModel('Hpb510skrModelBiz2', {
		 fields: [  	  
				    {name: 'MEDIUM_TYPE'				, text: '전산매체유형' 	,type: 'string'},
				    {name: 'TAX_YYYY'				, text: '정산년도' 		,type: 'string'},
				    {name: 'DEGREE'					, text: '차수' 	,type: 'string'},
				    {name: 'RECORD_GUBUN'				, text: '레코드 구분' 	,type: 'string'},
				    {name: 'DATA_GUBUN'			, text: '자료구분' 	,type: 'string'},
				    {name: 'TAX_OFFICE'				, text: '세무서' 		,type: 'string'},
				    {name: 'SERIAL_NO'				, text: '일련번호' 		,type: 'string'},
				    				    
				    {name: 'COMPANY_NUM'				, text: '사업자등록번호' 	,type: 'string'},				    
				    {name: 'COMPANY_NAME'				, text: '법인명(상호)' 	,type: 'string'},
				    {name: 'COMP_ENG_NAME'				, text: '법인명(영문)' 	,type: 'string'},
				    {name: 'ENG_ADDR'				, text: '주소' 	       ,type: 'string'},
				    {name: 'PERSON_CNT'			    , text: '소득인원' 	,type: 'uniNumber'},				    
				    {name: 'SUPP_CNT'				, text: '총지급건수' 		,type: 'uniNumber'},
				    
				    {name: 'PAY_AMOUNT'				, text: '총지급액계' 	,type: 'uniPrice'},
				    {name: 'SUPP_TOTAL'				, text: '연간소득합계' 	,type: 'uniPrice'},
				    {name: 'CP_TAX'				    , text: '법인세합계' 	,type: 'uniPrice'},
				    {name: 'SP_TAX'				    , text: '농특세합계' 	,type: 'uniPrice'}, 
				    {name: 'IN_TAX'				    , text: '소득세합계' 	,type: 'uniPrice'},
				    {name: 'LOCAL_TAX'			    , text: '지방소득세합계' 	,type: 'uniPrice'},
				    {name: 'TOTAL_TAX'				, text: '원천징수액합계' 		,type: 'uniPrice'},
				    {name: 'SMALL_AMT_CNT'			, text: '소액징수연간건수' 	,type: 'string'},				    
				    {name: 'SMALL_AMT_SUBMIT'		, text: '소액징수연간지급액' 	,type: 'uniPrice'},
				    {name: 'SUBMIT_CODE'			, text: '제출대상기간코드' 	,type: 'string'},
				    {name: 'FILL_SPACE'				, text: '공란수' 		    ,type: 'string'},
				]          
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpb510skrModelIntr2', {
	    fields: [  	  
		    {name: 'MEDIUM_TYPE'				, text: '전산매체유형' 	,type: 'string'},
		    {name: 'TAX_YYYY'				, text: '정산년도' 		,type: 'string'},
		    {name: 'DEGREE'					, text: '차수' 	,type: 'string'},
		    {name: 'RECORD_GUBUN'				, text: '레코드 구분' 	,type: 'string'},
		    {name: 'DATA_GUBUN'			    , text: '자료구분' 	,type: 'string'},
		    {name: 'TAX_OFFICE'				, text: '세무서' 		,type: 'string'},
		    {name: 'SUBMIT_DATE'				, text: '제출년월일' 	,type: 'uniDate'},		    
		    {name: 'SUBMIT_GUBUN'				, text: '제출자구분' 	,type: 'string'},
		    {name: 'MANAGE_NO'			       , text: '관리번호' 	,type: 'string'},
		    {name: 'HOMETAX_NO'				, text: '홈택스ID' 		,type: 'string'},
		    {name: 'TAX_PROGRAM'				, text: '세무프로그램코드' 	,type: 'string'},
		    
		    {name: 'COMPANY_NAME'				, text: '법인명(상호)' 	,type: 'string'},
		    {name: 'COMP_ENG_NAME'				, text: '법인명(영문)' 	,type: 'string'},
		    {name: 'ENG_ADDR'				    , text: '주소' 	       ,type: 'string'},
		    
		    {name: 'SUPP_CNT'				, text: '총제출건수' 		,type: 'uniNumber'},	
		    {name: 'SUPP_TOTAL'				, text: '소득금액합계' 	,type: 'uniPrice'},
		    {name: 'IN_TAX'				    , text: '소득세액합계' 	,type: 'uniPrice'},
		    {name: 'CP_TAX'				    , text: '법인세합계' 	,type: 'uniPrice'},
		   
		    {name: 'NEW_SUPP_CNT'				, text: '귀속당초 제출건수' 	,type: 'uniPrice'},
		    {name: 'NEW_SUPP_TOTAL'				, text: '귀속당초 소득합계' 	,type: 'uniPrice'},
		    {name: 'DEL_SUPP_CNT'				, text: '귀속삭제 제출건수' 	,type: 'uniPrice'},
		    {name: 'DEL_SUPP_TOTAL'				, text: '귀속삭제 소득합계' 	,type: 'uniPrice'},
		    {name: 'UPD_SUPP_CNT'				, text: '귀속수정 제출건수' 	,type: 'uniPrice'},
		    {name: 'UPD_SUPP_TOTAL'				, text: '귀속수정 소득합계' 	,type: 'uniPrice'},
		   
		    {name: 'FILL_SPACE'				, text: '공란수1' 		,type: 'string'},
		    {name: 'FILL_SPACE2'			, text: '공란수2' 		,type: 'string'},
		]          
	});
	
		
	Unilite.defineModel('Hpb510skrModelBiz3', {
		 fields: [  	  
				    {name: 'MEDIUM_TYPE'				, text: '전산매체유형' 	,type: 'string'},
				    {name: 'TAX_YYYY'				, text: '정산년도' 		,type: 'string'},
				    {name: 'DEGREE'					, text: '차수' 	,type: 'string'},
				    {name: 'RECORD_GUBUN'				, text: '레코드 구분' 	,type: 'string'},
				    {name: 'DATA_GUBUN'			, text: '자료구분' 	,type: 'string'},
				    {name: 'TAX_OFFICE'				, text: '세무서' 		,type: 'string'},
				    {name: 'SERIAL_NO'				, text: '일련번호' 		,type: 'string'},
				    				    
				    {name: 'COMPANY_NUM'				, text: '사업자등록번호' 	,type: 'string'},	
				    {name: 'RECOGN_NUM'				, text: '주민등록번호' 	,type: 'string'},	
				    {name: 'REPRE_NUM'				, text: '주민등록번호' 	,type: 'string'},	
				    {name: 'EARNER_NAME'				, text: '소득자성명' 	,type: 'string'},
				    {name: 'ENG_NAME'				, text: '소득자성명' 	,type: 'string'},
				    {name: 'ENG_ADDR'				, text: '소득자주소' 	,type: 'string'},
				    {name: 'NATION_CODE'			, text: '국가코드' 	,type: 'string'},
				    {name: 'SUPP_DATE'				, text: '지급일자' 	,type: 'uniDate'},
				    {name: 'COMP_NUM'				, text: '사업자등록번호' 	,type: 'string'},	
				    {name: 'COMP_KOR_NAME'				, text: '상호' 	,type: 'string'},	
				    {name: 'DWELLING_YN'				, text: '거주구분' 	,type: 'string'},			    
				    {name: 'FOREIGN_YN'			    , text: '내/외국인구분' 	,type: 'string'},	
				    {name: 'DED_CODE'			    , text: '소득구분' 	    ,type: 'string'},
				    				    
				    {name: 'BELONG_YEAR'				, text: '소득귀속연도' 	,type: 'string'},	
				    {name: 'SUPP_YEAR'				, text: '지급년도' 	,type: 'string'},	
				    {name: 'SUPP_CNT'				, text: '지급건수' 	,type: 'uniNumber'},			    
					
				    {name: 'TAX_RATE'				, text: '세율' 	,type: 'uniPrice'},
				    {name: 'PAY_AMOUNT_NV'			, text: '음수표시' 	,type: 'string'},
 					{name: 'PAY_AMOUNT'				, text: '연간지급총액' 	,type: 'uniPrice'},
 					
 					{name: 'CP_TAX_NV'			    , text: '음수표시' 	,type: 'string'},
 					{name: 'CP_TAX'				    , text: '법인세합계' 	,type: 'uniPrice'},
 					{name: 'SP_TAX_NV'			    , text: '음수표시' 	,type: 'string'},
 					{name: 'SP_TAX'				    , text: '농특세합계' 	,type: 'uniPrice'}, 
 				      
 					{name: 'EXPS_AMOUNT_NV'			, text: '음수표시' 	,type: 'string'},
 					{name: 'EXPS_AMOUNT'				, text: '필요경비' 	,type: 'uniPrice'},
 					{name: 'SUPP_TOTAL_NV'				, text: '음수표시' 	,type: 'string'},
				    {name: 'SUPP_TOTAL'				    , text: '소득금액' 	,type: 'uniPrice'},
				    
 					{name: 'IN_TAX_NV'				    , text: '음수표시' 	,type: 'string'},
				    {name: 'IN_TAX'				    , text: '소득세' 	,type: 'uniPrice'},
				    {name: 'LOCAL_TAX_NV'			    , text: '음수표시' 	,type: 'string'},
				    {name: 'LOCAL_TAX'			    , text: '지방소득세' 	,type: 'uniPrice'},
				    {name: 'TOTAL_TAX_NV'				, text: '음수표시' 		,type: 'string'},
				    {name: 'TOTAL_TAX'				, text: '원천징수액' 		,type: 'uniPrice'},				    
				    {name: 'FILL_SPACE'				, text: '공란수' 		    ,type: 'string'},
				]          
	});
	
	
	Unilite.defineModel('Hpb510skrModelIntr3', {
		 fields: [  	  
				    {name: 'MEDIUM_TYPE'				, text: '전산매체유형' 	,type: 'string'},
				    {name: 'TAX_YYYY'				, text: '정산년도' 		,type: 'string'},
				    {name: 'DEGREE'					, text: '차수' 	,type: 'string'},
				    {name: 'RECORD_GUBUN'				, text: '레코드 구분' 	,type: 'string'},
				    {name: 'DATA_GUBUN'			, text: '자료구분' 	,type: 'string'},
				    {name: 'TAX_OFFICE'				, text: '세무서' 		,type: 'string'},
				    {name: 'SERIAL_NO'				, text: '일련번호' 		,type: 'string'},
				    				    
				    {name: 'COMPANY_NUM'				, text: '본점사업자번호' 	,type: 'string'},
				    {name: 'COMPANY_NUM2'				, text: '지점사업자번호' 	,type: 'string'},					    
				    {name: 'ENG_NAME'				, text: '소득자성명' 	,type: 'string'},
				    {name: 'REPRE_NUM'				, text: '주민등록번호' 	,type: 'string'},	
				    {name: 'ENG_ADDR'				, text: '소득자주소' 	,type: 'string'},
				    {name: 'BIRTH'			        , text: '생년월일' 	,type: 'uniDate'},
				    {name: 'DED_CODE'		    	, text: '소득자구분' 	,type: 'string'},
				    {name: 'DWELLING_YN'				, text: '거주구분' 	,type: 'string'},	
				    {name: 'NATION_CODE'			, text: '국가코드' 	,type: 'string'},
				    
				    {name: 'SUPP_DATE'				, text: '지급일자' 	,type: 'uniDate'},		    				    				    
				    {name: 'PAY_YYYYMM'				, text: '소득귀속년월' 	,type: 'string'},	
				    {name: 'TAX_GUBN'				, text: '과세구분코드' 	,type: 'string'},	
				    {name: 'INCOME_KIND'			, text: '소득의종류' 	,type: 'string'},			    
					
				    
				    {name: 'TAX_EXCEPTION'			, text: '조세특례등' 	,type: 'string'},
					{name: 'PRIZE_CODE'				, text: '금융상품코드' 	,type: 'string'},					
					{name: 'WERT_PAPER_CODE'			, text: '유가증권표준코드' 	,type: 'string'},
					{name: 'CLAIM_INTER_GUBN'			, text: '채권이자구분' 	,type: 'string'},
				 	
					{name: 'SUPP_PERIOD'			, text: '이자지급대상기간' 	,type: 'string'},
					{name: 'INTER_RATE'				, text: '이자율등' 	,type: 'uniPrice'},					
				    {name: 'SUPP_TOTAL'				, text: '소득금액' 	,type: 'uniPrice'},
				    
				    {name: 'TAX_RATE'				, text: '세율' 	,type: 'uniPrice'},
				    {name: 'IN_TAX'				    , text: '소득세' 	,type: 'uniPrice'},
				    {name: 'CP_TAX'				    , text: '법인세합계' 	,type: 'uniPrice'},
				    {name: 'LOCAL_TAX'			    , text: '지방소득세' 	,type: 'uniPrice'},
				    {name: 'SP_TAX'				    , text: '농특세합계' 	,type: 'uniPrice'}, 
				   		    
				    {name: 'FILL_SPACE'				, text: '공란수' 		    ,type: 'string'},
				]          
	});
	
	

	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	
	
	 /**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStoreBiz1 = Unilite.createStore('hpb510skrMasterStoreBiz1',{
		model: 'Hpb510skrModelBiz1',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,				// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hpb510skrService.selectList1'                	
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
	
	
	var directMasterStoreBiz2 = Unilite.createStore('hpb510skrMasterStoreBiz2',{
		model: 'Hpb510skrModelBiz2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hpb510skrService.selectList2'                	
            }
        },
        loadStoreRecords: function(record) {
        	var searchParam= Ext.getCmp('searchForm').getValues();
        	var param= {'DEGREE':record.get('DEGREE')};	
			var params = Ext.merge(searchParam, param);
			//var param= Ext.getCmp('searchForm').getValues();			
			console.log( params );
			this.load({
				params : params
			});
		}
	});
	
	var directMasterStoreBiz3 = Unilite.createStore('hpb510skrMasterStoreBiz3',{
		model: 'Hpb510skrModelBiz3',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hpb510skrService.selectList3'                	
            }
        },
        loadStoreRecords: function(record) {
        	var searchParam= Ext.getCmp('searchForm').getValues();
        	var param= {'DEGREE':record.get('DEGREE')};	
			var params = Ext.merge(searchParam, param);
			//var param= Ext.getCmp('searchForm').getValues();			
			console.log( params );
			this.load({
				params : params
			});
		}
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStoreIntr1 = Unilite.createStore('hpb510skrMasterStoreIntr1',{
		model: 'Hpb510skrModelIntr1',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,				// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hpb510skrService.selectListIntr1'                	
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
	
	
	var directMasterStoreIntr2 = Unilite.createStore('hpb510skrMasterStoreIntr2',{
		model: 'Hpb510skrModelIntr2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hpb510skrService.selectListIntr2'                	
            }
        },
        loadStoreRecords: function(record) {
        	var searchParam= Ext.getCmp('searchForm').getValues();
        	var param= {'DEGREE':record.get('DEGREE')};	
			var params = Ext.merge(searchParam, param);
			//var param= Ext.getCmp('searchForm').getValues();			
			console.log( params );
			this.load({
				params : params
			});
		}
	});
	
	var directMasterStoreIntr3 = Unilite.createStore('hpb510skrMasterStoreIntr3',{
		model: 'Hpb510skrModelIntr3',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hpb510skrService.selectListIntr3'                	
            }
        },
        loadStoreRecords: function(record) {
        	var searchParam= Ext.getCmp('searchForm').getValues();
        	var param= {'DEGREE':record.get('DEGREE')};	
			var params = Ext.merge(searchParam, param);
			//var param= Ext.getCmp('searchForm').getValues();			
			console.log( params );
			this.load({
				params : params
			});
		}
	});
	
	
	
	/**
	 * 검색조건 (Search Panel)
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
        //region : 'west',
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
						xtype: 'radiogroup',		            		
						fieldLabel: '제출방법',						            		
						id: 'rdoSelect1',
						items: [{
							boxLabel: '연간 합산제출', 
							width: 150, 
							name: 'SUBMIT_CODE',
							inputValue: '1',
							checked: true
						}]
					},{
						fieldLabel: '전산매체유형',
						name: 'MEDIUM_TYPE', 
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: '',
						store: TypeStore,
						value: '1',
						allowBlank: false,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('MEDIUM_TYPE', newValue);
							}
						}
					},{
						fieldLabel: '정산년도',
						xtype: 'uniTextfield',
						name: 'TAX_YYYY',
						allowBlank: false,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('TAX_YYYY', newValue);
							}
						}
					},{
						fieldLabel: '신고사업장',
						name: 'DIV_CODE', 
						xtype: 'uniCombobox',
						comboType: 'BOR120',
						comboCode: 'BILL',
						allowBlank: false,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('DIV_CODE', newValue);
							}
						}
					},{
						fieldLabel: '차수',
			    		xtype: 'uniTextfield',
			    		name: 'DEGREE',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('DEGREE', newValue);
							}
						}
					}
				]				
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
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
				{
					xtype: 'radiogroup',		            		
					fieldLabel: '제출방법',						            		
					id: 'rdoSelect2',
					items: [{
						boxLabel: '연간 합산제출', 
						width: 150, 
						name: 'SUBMIT_CODE',
						inputValue: '1',
						checked: true
					}]
				},{
					fieldLabel: '전산매체유형',
					name: 'MEDIUM_TYPE', 
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: '',
					store: TypeStore,
					value: '1',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
						    panelSearch.setValue('MEDIUM_TYPE', newValue);
					}
				}
				},{
					fieldLabel: '정산년도',
					xtype: 'uniTextfield',
					name: 'TAX_YYYY',
					allowBlank: false,			 	
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TAX_YYYY', newValue);
						}
					}
				},{
					fieldLabel: '신고사업장',
					name: 'DIV_CODE', 
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					comboCode: 'BILL',
					allowBlank: false,			 	
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},
		    	{
					fieldLabel: '차수',
		    		xtype: 'uniTextfield',
		    		name: 'DEGREE',			 	
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DEGREE', newValue);
						}
					}
				}
			],
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
	
	
	
	/**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGridBiz1 = Unilite.createGrid('hpb510skrGridBiz1', {
    	layout : 'fit',
        region : 'center',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directMasterStoreBiz1,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
        columns: [       
        	{dataIndex: 'DEGREE'				, width: 60, align: 'center' }, 				
			{dataIndex: 'RECORD_GUBUN'			, width: 60, align: 'center'}, 				
			{dataIndex: 'DATA_GUBUN'			, width: 80, align: 'center'},
			{dataIndex: 'TAX_OFFICE'			, width: 80, align: 'center'},
			{dataIndex: 'SUBMIT_DATE'			, width: 100},
			{dataIndex: 'SUBMIT_GUBUN'			, width: 80 },
			{dataIndex: 'MANAGE_NO'				, width: 80 },
			
			{dataIndex: 'HOMETAX_NO'			, width: 110},
			{dataIndex: 'TAX_PROGRAM'			, width: 90},
			{dataIndex: 'COMPANY_NUM'			, width: 120 },
			{dataIndex: 'COMPANY_NAME'			, width: 200 },
			
			{dataIndex: 'CHARGE_DEPT'			, width: 180},
			{dataIndex: 'CHARGE_NAME'			, width: 180},
			{dataIndex: 'CHARGE_TEL'			, width: 120 },
			{dataIndex: 'REPORTER_CNT'			, width: 70 },
			{dataIndex: 'FILL_SPACE'			    , width: 60 }
		],
		listeners: {									
        	selectionchangerecord:function(record , selected)	{
        		//var record = masterGrid.getSelectedRecord();
        		//this.returnCell(record);  
        		directMasterStoreBiz2.loadData({})
				directMasterStoreBiz2.loadStoreRecords(record);
        		
        		directMasterStoreBiz3.loadData({})
				directMasterStoreBiz3.loadStoreRecords(record);
          	}
		}
    });
	
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGridEtc1 = Unilite.createGrid('hpb510skrGridEtc1', {
    	layout : 'fit',
        region : 'center',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directMasterStoreBiz1,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
        columns: [       
        	{dataIndex: 'DEGREE'				, width: 60, align: 'center' }, 				
			{dataIndex: 'RECORD_GUBUN'			, width: 60, align: 'center'}, 				
			{dataIndex: 'DATA_GUBUN'			, width: 80, align: 'center'},
			{dataIndex: 'TAX_OFFICE'			, width: 80, align: 'center'},
			{dataIndex: 'SUBMIT_DATE'			, width: 100},
			{dataIndex: 'SUBMIT_GUBUN'			, width: 80 },
			{dataIndex: 'MANAGE_NO'				, width: 80 },
			
			{dataIndex: 'HOMETAX_NO'			, width: 110},
			{dataIndex: 'TAX_PROGRAM'			, width: 90},
			{dataIndex: 'COMPANY_NUM'			, width: 120 },
			{dataIndex: 'COMPANY_NAME'			, width: 200 },
			
			{dataIndex: 'CHARGE_DEPT'			, width: 180},
			{dataIndex: 'CHARGE_NAME'			, width: 180},
			{dataIndex: 'CHARGE_TEL'			, width: 120 },
			{dataIndex: 'REPORTER_CNT'			, width: 70 },
			{dataIndex: 'FILL_SPACE'			    , width: 60 }
		],
		listeners: {									
        	selectionchangerecord:function(record , selected)	{
        		//var record = masterGrid.getSelectedRecord();
        		//this.returnCell(record);  
        		directMasterStoreBiz2.loadData({})
				directMasterStoreBiz2.loadStoreRecords(record);
        		
        		directMasterStoreBiz3.loadData({})
				directMasterStoreBiz3.loadStoreRecords(record);
          	}
		}
    });
    
    
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGridNon1 = Unilite.createGrid('hpb510skrGridNon1', {
    	layout : 'fit',
        region : 'center',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directMasterStoreBiz1,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
        columns: [       
        	{dataIndex: 'DEGREE'				, width: 60, align: 'center' }, 				
			{dataIndex: 'RECORD_GUBUN'			, width: 60, align: 'center'}, 				
			{dataIndex: 'DATA_GUBUN'			, width: 80, align: 'center'},
			{dataIndex: 'TAX_OFFICE'			, width: 80, align: 'center'},
			{dataIndex: 'SUBMIT_DATE'			, width: 100},
			{dataIndex: 'SUBMIT_GUBUN'			, width: 80 },
			{dataIndex: 'MANAGE_NO'				, width: 80 },
			
			{dataIndex: 'HOMETAX_NO'			, width: 110},
			{dataIndex: 'TAX_PROGRAM'			, width: 90},
			{dataIndex: 'COMPANY_NUM'			, width: 120 },
			{dataIndex: 'COMPANY_NAME'			, width: 200 },
			
			{dataIndex: 'CHARGE_DEPT'			, width: 180},
			{dataIndex: 'CHARGE_NAME'			, width: 180},
			{dataIndex: 'CHARGE_TEL'			, width: 120 },
			{dataIndex: 'REPORTER_CNT'			, width: 70 },
			{dataIndex: 'FILL_SPACE'			    , width: 60 }
		],
		listeners: {									
        	selectionchangerecord:function(record , selected)	{
        		//var record = masterGrid.getSelectedRecord();
        		//this.returnCell(record);  
        		directMasterStoreBiz2.loadData({})
				directMasterStoreBiz2.loadStoreRecords(record);
        		
        		directMasterStoreBiz3.loadData({})
				directMasterStoreBiz3.loadStoreRecords(record);
          	}
		}
    });
    
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGridIntr1 = Unilite.createGrid('hpb510skrGridIntr1', {
    	layout : 'fit',
        region : 'center',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directMasterStoreIntr1,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
		columns: [       
		        	{dataIndex: 'DEGREE'				, width: 60, align: 'center' }, 				
					{dataIndex: 'RECORD_GUBUN'			, width: 60, align: 'center'}, 				
					{dataIndex: 'DATA_GUBUN'			, width: 80, align: 'center'},
					{dataIndex: 'TAX_OFFICE'			, width: 80, align: 'center'},
					{dataIndex: 'SUBMIT_DATE'			, width: 100},
					
					{dataIndex: 'COMPANY_NUM'			, width: 110},
					{dataIndex: 'COMPANY_NAME'			, width: 150},
					{dataIndex: 'FILL_SPACE'			 , width: 60 },
					{dataIndex: 'HOMETAX_NO'			, width: 110},
					{dataIndex: 'TAX_PROGRAM'			, width: 90},
								
					{dataIndex: 'CHARGE_DEPT'			, width: 180},
					{dataIndex: 'CHARGE_NAME'			, width: 180},
					{dataIndex: 'CHARGE_TEL'			, width: 120 },
					{dataIndex: 'REPORTER_CNT'			, width: 70 },
					
					{dataIndex: 'SUPP_CNT'				, width: 70 },
					{dataIndex: 'SUPP_TOTAL'			 , width: 150},			
					{dataIndex: 'IN_TAX'			    , width: 130},	
					{dataIndex: 'CP_TAX'			    , width: 130},
					{dataIndex: 'NEW_SUPP_CNT'			    , width: 130},	
					{dataIndex: 'NEW_SUPP_TOTAL'			, width: 130},	
					{dataIndex: 'DEL_SUPP_CNT'			    , width: 130},	
					{dataIndex: 'DEL_SUPP_TOTAL'			, width: 130},	
					{dataIndex: 'UPD_SUPP_CNT'			    , width: 130},	
					{dataIndex: 'UPD_SUPP_TOTAL'			, width: 130},	
					{dataIndex: 'FILL_SPACE2'			 , width: 60 }
					
				],
		listeners: {									
        	selectionchangerecord:function(record , selected)	{
        		//var record = masterGrid.getSelectedRecord();
        		//this.returnCell(record);  
        		directMasterStoreIntr2.loadData({})
				directMasterStoreIntr2.loadStoreRecords(record);
        		
        		directMasterStoreIntr3.loadData({})
				directMasterStoreIntr3.loadStoreRecords(record);
          	}
		}
    });
     
    
   
    
     /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
    
    var masterGridBiz2 = Unilite.createGrid('hpb510skrGridBiz2', {    	
    	layout : 'fit',
        region : 'east',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directMasterStoreBiz2,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
        columns: [        
		        	{dataIndex: 'DEGREE'				, width: 60, align: 'center'}, 				
					{dataIndex: 'RECORD_GUBUN'			, width: 60, align: 'center'}, 				
					{dataIndex: 'DATA_GUBUN'			, width: 80, align: 'center'},
					{dataIndex: 'TAX_OFFICE'			, width: 80, align: 'center'},
					{dataIndex: 'SERIAL_NO'			    , width: 70, align: 'center'},
					{dataIndex: 'COMPANY_NUM'			, width: 110 },
					{dataIndex: 'COMPANY_NAME'			, width: 200 },
					
					{dataIndex: 'PERSON_CNT'			, width: 70 },
					{dataIndex: 'SUPP_CNT'				, width: 70 },
					
					{dataIndex: 'PAY_AMOUNT'			, width: 160},
					{dataIndex: 'IN_TAX'			    , width: 130},	
					{dataIndex: 'LOCAL_TAX'			    , width: 130},
					{dataIndex: 'TOTAL_TAX'			    , width: 150},
					
					{dataIndex: 'SMALL_AMT_CNT'			, width: 90 },
					{dataIndex: 'SMALL_AMT_SUBMIT'		, width: 110 },
					{dataIndex: 'SUBMIT_CODE'			, width: 60 },
					{dataIndex: 'FILL_SPACE'			    , width: 60 }
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				
			}
		}        			
    });
     
     
    
     
     
    /**
     * Master Grid2 정의(거주자 기타소득) : 'SMALL_AMT_CNT', 'SMALL_AMT_SUBMIT' 없음
     * @type 
     */
    
    var masterGridEtc2 = Unilite.createGrid('hpb510skrGridEtc2', {    	
    	layout : 'fit',
        region : 'east',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directMasterStoreBiz2,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
        columns: [        
		        	{dataIndex: 'DEGREE'				, width: 60, align: 'center'}, 				
					{dataIndex: 'RECORD_GUBUN'			, width: 60, align: 'center'}, 				
					{dataIndex: 'DATA_GUBUN'			, width: 80, align: 'center'},
					{dataIndex: 'TAX_OFFICE'			, width: 80, align: 'center'},
					{dataIndex: 'SERIAL_NO'			    , width: 70, align: 'center'},
					{dataIndex: 'COMPANY_NUM'			, width: 110 },
					{dataIndex: 'COMPANY_NAME'			, width: 200 },
					
					{dataIndex: 'PERSON_CNT'			, width: 70 },
					{dataIndex: 'SUPP_CNT'				, width: 70 },
					
					{dataIndex: 'PAY_AMOUNT'			, width: 160},
					{dataIndex: 'IN_TAX'			    , width: 130},	
					{dataIndex: 'LOCAL_TAX'			    , width: 130},
					{dataIndex: 'TOTAL_TAX'			    , width: 150},
				
					{dataIndex: 'SUBMIT_CODE'			, width: 60 },
					{dataIndex: 'FILL_SPACE'			    , width: 60 }
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				
			}
		}        			
    });
     
     
     /**
      * Master Grid2 정의(비거주자 사업,기타소득) :
      * @type 
      */
     
     var masterGridNon2 = Unilite.createGrid('hpb510skrGridNon2', {    	
     	layout : 'fit',
         region : 'east',
         uniOpt:{
 			useMultipleSorting	: true,
     		useLiveSearch		: true,
     		onLoadSelectFirst	: false,
     		dblClickToEdit		: false,
     		useGroupSummary		: true,
 			useContextMenu		: false,
 			useRowNumberer		: true,
 			expandLastColumn	: true,
 			useRowContext		: true,
     		filter: {
 				useFilter		: true,
 				autoCreate		: true
 			}
         },
 		store: directMasterStoreBiz2,
     	features: [{
     		id: 'masterGridSubTotal',
     		ftype: 'uniGroupingsummary', 
     		showSummaryRow: false 
     		},{
     		id: 'masterGridTotal', 	
     		ftype: 'uniSummary', 	  
     		showSummaryRow: false
     	}],
 		selModel : 'rowmodel',
         columns: [        
 		        	{dataIndex: 'DEGREE'				, width: 60, align: 'center'}, 				
 					{dataIndex: 'RECORD_GUBUN'			, width: 60, align: 'center'}, 				
 					{dataIndex: 'DATA_GUBUN'			, width: 80, align: 'center'},
 					{dataIndex: 'TAX_OFFICE'			, width: 80, align: 'center'},
 					{dataIndex: 'SERIAL_NO'			    , width: 70, align: 'center'},
 					{dataIndex: 'COMPANY_NUM'			, width: 110 },
 					{dataIndex: 'COMP_ENG_NAME'			, width: 100 },
 					{dataIndex: 'ENG_ADDR'			    , width: 200 },
 					
 					{dataIndex: 'PERSON_CNT'			, width: 70 },
 					{dataIndex: 'SUPP_CNT'				, width: 70 },
 					
 								
 					{dataIndex: 'IN_TAX'			    , width: 130},	
 					{dataIndex: 'CP_TAX'			    , width: 160},
 					{dataIndex: 'LOCAL_TAX'			    , width: 130},
 					{dataIndex: 'SP_TAX'			    , width: 130},
 					{dataIndex: 'TOTAL_TAX'			    , width: 150},
 				
 					{dataIndex: 'SUBMIT_CODE'			, width: 60 },
 					{dataIndex: 'FILL_SPACE'			, width: 60 }
 		],
 		listeners: {
 			onGridDblClick:function(grid, record, cellIndex, colName) {
 				
 			}
 		}        			
     });
      
     
      /**
       * Master Grid 정의(Grid Panel)
       * @type 
       */
      
      var masterGridIntr2 = Unilite.createGrid('hpb510skrGridIntr2', {
      	layout : 'fit',
          region : 'center',
          uniOpt:{
  			useMultipleSorting	: true,
      		useLiveSearch		: true,
      		onLoadSelectFirst	: true,
      		dblClickToEdit		: false,
      		useGroupSummary		: true,
  			useContextMenu		: false,
  			useRowNumberer		: true,
  			expandLastColumn	: true,
  			useRowContext		: true,
      		filter: {
  				useFilter		: true,
  				autoCreate		: true
  			}
          },
  		store: directMasterStoreBiz2,
      	features: [{
      		id: 'masterGridSubTotal',
      		ftype: 'uniGroupingsummary', 
      		showSummaryRow: false 
      		},{
      		id: 'masterGridTotal', 	
      		ftype: 'uniSummary', 	  
      		showSummaryRow: false
      	}],
  		selModel : 'rowmodel',
          columns: [       
          	{dataIndex: 'DEGREE'				, width: 60, align: 'center' }, 				
  			{dataIndex: 'RECORD_GUBUN'			, width: 60, align: 'center'}, 				
  			{dataIndex: 'DATA_GUBUN'			, width: 80, align: 'center'},
  			{dataIndex: 'TAX_OFFICE'			, width: 80, align: 'center'},
  			//{dataIndex: 'SUBMIT_DATE'			, width: 100},
  			  			
  			{dataIndex: 'COMPANY_NUM'			, width: 110},
  			{dataIndex: 'COMPANY_NUM2'			, width: 110},
  			{dataIndex: 'FILL_SPACE'			 , width: 60 },
  			
  			{dataIndex: 'COMPANY_NAME'			, width: 110 },
			{dataIndex: 'COMP_ENG_NAME'			, width: 100 },
			{dataIndex: 'ENG_ADDR'			    , width: 200 },	
			  			
  			{dataIndex: 'SUPP_CNT'				, width: 70 },
  			{dataIndex: 'SUPP_TOTAL'			 , width: 150},			
  			{dataIndex: 'IN_TAX'			    , width: 130},	
  			{dataIndex: 'CP_TAX'			    , width: 130},
  			{dataIndex: 'NEW_SUPP_CNT'			    , width: 130},	
  			{dataIndex: 'NEW_SUPP_TOTAL'			, width: 130},	
  			{dataIndex: 'DEL_SUPP_CNT'			    , width: 130},	
  			{dataIndex: 'DEL_SUPP_TOTAL'			, width: 130},	
  			{dataIndex: 'UPD_SUPP_CNT'			    , width: 130},	
  			{dataIndex: 'UPD_SUPP_TOTAL'			, width: 130},	
  			{dataIndex: 'FILL_SPACE2'			 , width: 60 }
  			
  		],
  		listeners: {									
  			onGridDblClick:function(grid, record, cellIndex, colName) {      		
            }
  		}
      });
        
      
     
    /**
     * Master Grid3 정의(Grid Panel)
     * @type 
     */
    
    var masterGridBiz3 = Unilite.createGrid('hpb510skrGridBiz3', {    	
    	layout : 'fit',
        region : 'east',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directMasterStoreBiz3,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
        columns: [        
		        	{dataIndex: 'DEGREE'				, width: 60, align: 'center'}, 				
					{dataIndex: 'RECORD_GUBUN'			, width: 60, align: 'center'}, 				
					{dataIndex: 'DATA_GUBUN'			, width: 80, align: 'center'},
					{dataIndex: 'TAX_OFFICE'			, width: 80, align: 'center'},
					{dataIndex: 'SERIAL_NO'			    , width: 70, align: 'center'},
					{dataIndex: 'COMPANY_NUM'			, width: 120, align: 'center'},
					{dataIndex: 'REPRE_NUM'			    , width: 120, align: 'center'},
					
					{dataIndex: 'EARNER_NAME'			, width: 100 },
					{dataIndex: 'COMP_NUM'				, width: 110 },
					
					{dataIndex: 'COMP_KOR_NAME'			, width: 200 },
					{dataIndex: 'DWELLING_YN'			, width: 53 },					
					{dataIndex: 'FOREIGN_YN'		    , width: 53 },
					{dataIndex: 'DED_CODE'		        , width: 70 },
					{dataIndex: 'BELONG_YEAR'			, width: 60, align: 'center'},
					
					{dataIndex: 'SUPP_YEAR'		    , width: 60, align: 'center'},
					{dataIndex: 'SUPP_CNT'			, width: 70 },					
					{dataIndex: 'TAX_RATE'			, width: 60},
					
					{dataIndex: 'PAY_AMOUNT_NV'			, width: 70},
					{dataIndex: 'PAY_AMOUNT'			, width: 160},
					{dataIndex: 'IN_TAX_NV'			    , width: 70},
					{dataIndex: 'IN_TAX'			    , width: 130},	
					{dataIndex: 'LOCAL_TAX_NV'			, width: 70},
					{dataIndex: 'LOCAL_TAX'			    , width: 130},
					{dataIndex: 'TOTAL_TAX_NV'			, width: 70},
					{dataIndex: 'TOTAL_TAX'			    , width: 150},
			
					{dataIndex: 'FILL_SPACE'			, width: 60 }
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				
			}
		}        			
    });

    /**
     * Master Grid3 정의(거주자 기타소득)
     * @type 
     */
    
    var masterGridEtc3 = Unilite.createGrid('hpb510skrGridEtc3', {    	
    	layout : 'fit',
        region : 'east',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directMasterStoreBiz3,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
        columns: [        
		        	{dataIndex: 'DEGREE'				, width: 60, align: 'center'}, 				
					{dataIndex: 'RECORD_GUBUN'			, width: 60, align: 'center'}, 				
					{dataIndex: 'DATA_GUBUN'			, width: 80, align: 'center'},
					{dataIndex: 'TAX_OFFICE'			, width: 80, align: 'center'},
					{dataIndex: 'SERIAL_NO'			    , width: 70, align: 'center'},
					{dataIndex: 'COMPANY_NUM'			, width: 120, align: 'center'},
					{dataIndex: 'REPRE_NUM'			    , width: 120, align: 'center'},
					
					{dataIndex: 'EARNER_NAME'			, width: 100 },
					{dataIndex: 'DWELLING_YN'			, width: 53 },					
					{dataIndex: 'FOREIGN_YN'		    , width: 53 },
					{dataIndex: 'DED_CODE'		        , width: 70 },
					
					{dataIndex: 'BELONG_YEAR'			, width: 60, align: 'center'},					
					{dataIndex: 'SUPP_YEAR'		    , width: 60, align: 'center'},
					{dataIndex: 'SUPP_CNT'			, width: 70 },					
					{dataIndex: 'TAX_RATE'			, width: 60},
					
					{dataIndex: 'PAY_AMOUNT_NV'			, width: 70},
					{dataIndex: 'PAY_AMOUNT'			, width: 160},
					{dataIndex: 'EXPS_AMOUNT_NV'		, width: 70},
					{dataIndex: 'EXPS_AMOUNT'			, width: 130},	
					{dataIndex: 'SUPP_TOTAL_NV'			, width: 70},
					{dataIndex: 'SUPP_TOTAL'			, width: 160},
					{dataIndex: 'IN_TAX_NV'			    , width: 70},
					{dataIndex: 'IN_TAX'			    , width: 130},	
					{dataIndex: 'LOCAL_TAX_NV'			, width: 70},
					{dataIndex: 'LOCAL_TAX'			    , width: 130},
					{dataIndex: 'TOTAL_TAX_NV'			, width: 70},
					{dataIndex: 'TOTAL_TAX'			    , width: 150},
			
					{dataIndex: 'FILL_SPACE'			, width: 60 }
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				
			}
		}        			
    });
    
    
    
    /**
     * Master Grid3 정의(비거주자 사업/기타소득)
     * @type 
     */
    
    var masterGridNon3 = Unilite.createGrid('hpb510skrGridNon3', {    	
    	layout : 'fit',
        region : 'east',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directMasterStoreBiz3,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
        columns: [        
		        	{dataIndex: 'DEGREE'				, width: 60, align: 'center'}, 				
					{dataIndex: 'RECORD_GUBUN'			, width: 60, align: 'center'}, 				
					{dataIndex: 'DATA_GUBUN'			, width: 80, align: 'center'},
					{dataIndex: 'TAX_OFFICE'			, width: 80, align: 'center'},
					{dataIndex: 'SERIAL_NO'			    , width: 70, align: 'center'},
					{dataIndex: 'COMPANY_NUM'			, width: 120, align: 'center'},
					{dataIndex: 'RECOGN_NUM'	        , width: 120, align: 'center'},
					
					{dataIndex: 'ENG_NAME'			    , width: 100 },
					{dataIndex: 'ENG_ADDR'			    , width: 180 },
					{dataIndex: 'NATION_CODE'			, width: 60 },					
					{dataIndex: 'FOREIGN_YN'		    , width: 53 },
					{dataIndex: 'DED_CODE'		        , width: 70 },
					
					{dataIndex: 'BELONG_YEAR'			, width: 60, align: 'center'},					
					{dataIndex: 'SUPP_YEAR'		    , width: 60, align: 'center'},
					{dataIndex: 'SUPP_DATE'		    , width: 80, align: 'center'},
										
					{dataIndex: 'PAY_AMOUNT_NV'			, width: 70},
					{dataIndex: 'PAY_AMOUNT'			, width: 160},
					{dataIndex: 'EXPS_AMOUNT_NV'		, width: 70},
					{dataIndex: 'EXPS_AMOUNT'			, width: 130},	
					{dataIndex: 'SUPP_TOTAL_NV'			, width: 70},
					{dataIndex: 'SUPP_TOTAL'			, width: 160},
					
					{dataIndex: 'TAX_RATE'			    , width: 60},
					{dataIndex: 'IN_TAX_NV'			    , width: 70},
					{dataIndex: 'IN_TAX'			    , width: 130},	
					{dataIndex: 'CP_TAX_NV'			    , width: 70},
				    {dataIndex: 'CP_TAX'			    , width: 130},
					{dataIndex: 'LOCAL_TAX_NV'			, width: 70},
					{dataIndex: 'LOCAL_TAX'			    , width: 130},
					{dataIndex: 'SP_TAX_NV'			    , width: 70},
				    {dataIndex: 'SP_TAX'			    , width: 130},
					{dataIndex: 'TOTAL_TAX_NV'			, width: 70},
					{dataIndex: 'TOTAL_TAX'			    , width: 150},
			
					{dataIndex: 'FILL_SPACE'			, width: 60 }
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				
			}
		}        			
    });
    
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGridIntr3 = Unilite.createGrid('hpb510skrGridIntr3', {
    	layout : 'fit',
        region : 'center',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directMasterStoreBiz3,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
        columns: [       
        	{dataIndex: 'DEGREE'				, width: 60, align: 'center' }, 				
			{dataIndex: 'RECORD_GUBUN'			, width: 60, align: 'center'}, 				
			{dataIndex: 'DATA_GUBUN'			, width: 80, align: 'center'},
			{dataIndex: 'TAX_OFFICE'			, width: 80, align: 'center'},
			//{dataIndex: 'SUBMIT_DATE'			, width: 100},
			
			{dataIndex: 'COMPANY_NUM'			, width: 110},
			{dataIndex: 'COMPANY_NUM2'			, width: 110},
			{dataIndex: 'SERIAL_NO'			    , width: 70, align: 'center'},
			
			{dataIndex: 'ENG_NAME'			, width: 110 },
			{dataIndex: 'REPRE_NUM'			, width: 100 },
			{dataIndex: 'ENG_ADDR'			    , width: 200 },	
			  			
			{dataIndex: 'BIRTH'			    , width: 110},
			{dataIndex: 'DED_CODE'			, width: 70},
			{dataIndex: 'NATION_CODE'			, width: 60}, 

			{dataIndex: 'BANK_ACCOUNT'			, width: 110}, 
			{dataIndex: 'TRUST_PROFIT_YN'			, width: 60}, 
			{dataIndex: 'SUPP_DATE'			    , width: 90}, 
			{dataIndex: 'PAY_YYYYMM'			, width: 80}, 
			{dataIndex: 'TAX_GUBN'			    , width: 60}, 

			{dataIndex: 'INCOME_KIND'			, width: 60}, 
			{dataIndex: 'TAX_EXCEPTION'			, width: 100}, 
			{dataIndex: 'PRIZE_CODE'			, width: 100}, 
			{dataIndex: 'WERT_PAPER_CODE'			, width: 90},  
			{dataIndex: 'CLAIM_INTER_GUBN'			, width: 60},   
			{dataIndex: 'SUPP_PERIOD'			, width: 100},  
			{dataIndex: 'INTER_RATE'			, width: 90},  
						  
			{dataIndex: 'SUPP_TOTAL'			, width: 110},                                  
			{dataIndex: 'TAX_RATE'			    , width: 80}, 
		
			{dataIndex: 'IN_TAX'			    , width: 130},	
			{dataIndex: 'CP_TAX'			    , width: 130},
			{dataIndex: 'LOCAL_TAX'			    , width: 130},	
			{dataIndex: 'SP_TAX'			    , width: 130},
			{dataIndex: 'FILL_SPACE'		    , width: 60 }
			
		],
		listeners: {									
			onGridDblClick:function(grid, record, cellIndex, colName) {
				
			}
		}
    });
     
    
	
	/**
     * TabPanel 정의(Tab)
     * @type 
     */
     var tabPanel = Unilite.createTabPanel('tabPanel',{    	 
         region : 'center',
         layout: {type: 'vbox', align: 'stretch'},
 		 bodyCls: 'human-panel-form-background',
	     items: [
			     {title: '거주자 사업소득'
				 ,id: 'hpb510skrTab01'				    	 
			     ,autoScroll: true
			     ,layout:{type:'vbox', align:'stretch'}
			     ,items:[masterGridBiz1, masterGridBiz2, masterGridBiz3]
			     },
			     {title: '거주자 기타소득'
				 ,id: 'hpb510skrTab02'			    	 
			     ,xtype:'container'
			     ,layout:{type:'vbox', align:'stretch'}
			     ,items:[masterGridEtc1, masterGridEtc2, masterGridEtc3] 
			     },
			     {title: '비거주자 사업,기타소득'
				 ,id: 'hpb510skrTab03'			    	 
			     ,xtype:'container'
			     ,layout:{type:'vbox', align:'stretch'}
			     ,items:[masterGridNon1, masterGridNon2, masterGridNon3] 
			     },
			     {title: '이자,배당소득'
				 ,id: 'hpb510skrTab04'			    	 
			     ,xtype:'container'
				 ,autoScroll: true
			     ,layout:{type:'vbox', align:'stretch'}
			     ,items:[masterGridIntr1, masterGridIntr2, masterGridIntr3] 
			     }
	    ],
 		 listeners: {
 			 tabchange: function(){
 				var activeTabId = tabPanel.getActiveTab().getId();
 				
 				if(activeTabId == 'hpb510skrTab01'){	
 					panelSearch.setValue('MEDIUM_TYPE', '1');
 					directMasterStoreBiz1.loadStoreRecords();				
 				}else if(activeTabId == 'hpb510skrTab02'){		
 					panelSearch.setValue('MEDIUM_TYPE', '2');
 					directMasterStoreBiz1.loadStoreRecords();			
 				}else if(activeTabId == 'hpb510skrTab03'){		
 					panelSearch.setValue('MEDIUM_TYPE', '3');
 					directMasterStoreBiz1.loadStoreRecords();			
 				}else if(activeTabId == 'hpb510skrTab04'){	
 					panelSearch.setValue('MEDIUM_TYPE', '4');
 					directMasterStoreIntr1.loadStoreRecords();				
 				}
 			 }
 		 }
     })
    
	 Unilite.Main( {
	 	border: false,
	 	
		borderItems:[ 
		 		 tabPanel
				,panelSearch
		], 
						
		id : 'hpb510skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);			
		},
		onQueryButtonDown : function()	{		
			var activeTabId = tabPanel.getActiveTab().getId();
			
			if(activeTabId == 'hpb510skrTab01'){				
				directMasterStoreBiz1.loadStoreRecords();				
			}else if(activeTabId == 'hpb510skrTab02'){				
				directMasterStoreBiz1.loadStoreRecords();			
			}else if(activeTabId == 'hpb510skrTab03'){				
				directMasterStoreBiz1.loadStoreRecords();			
			}else if(activeTabId == 'hpb510skrTab04'){				
				directMasterStoreIntr1.loadStoreRecords();				
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
