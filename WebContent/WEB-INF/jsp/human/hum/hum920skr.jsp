<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum920skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hum920skr"/> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H011" /> 						<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H024" /> 						<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H005" /> 						<!-- 직위 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H006" /> 						<!-- 직책 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H009" /> 						<!-- 학력 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H010" /> 						<!-- 졸업구분 -->
	<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!-- 사업명-->
	<t:ExtComboStore comboType="AU" 	comboCode="H084" /> 						<!-- 보훈구분 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H085" /> 						<!-- 장애구분 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H173" /> 						<!-- 직렬 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H174" /> 						<!-- 호봉승급기준 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H028" /> 						<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H031" /> 						<!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H181" /> 						<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" 	comboCode="H008" /> 						<!-- 담당그룹 -->
	<t:ExtComboStore comboType="AU" 	comboCode="T107" /> 						<!-- 고용보험 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	var	gsLicenseTab 	= ${gsLicenseTab};
	var	gsOnlyHuman 	= ${gsOnlyHuman};
	
	var gsCostPool = '${CostPool}';  // H175 subCode 10의 Y/N 에 따라 값이 바뀜

	var SetHiddenMode = false; 
	
	if(UserInfo.compCountry == "CN"){  // 중국어 버전 관련 Hidden 처리
		SetHiddenMode = true;
	}
	if(gsLicenseTab[0].LICENSE_TAB == 'Y'){ // 버스_면허기타 Tab 사용여부 관련 Hidden 처리
		SetHiddenMode = true;
	}
	if(gsOnlyHuman.length  == 0){ // 급여/고정공제 TAB 사용못하는 인사담당자ID 여부
		SetHiddenMode = true;
	}
	
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('Hum920skrModel', {
		fields: [ 
			{name: 'GUBUN',				text :'<t:message code="system.label.human.type" 		default="구분"/>', 			type: 'string'},
			{name: 'DIV_CODE',			text: '<t:message code="system.label.human.division" 	default="사업장"/>',			type: 'string', comboType:'BOR120'},
			{name: 'DEPT_CODE',			text: '<t:message code="system.label.human.department" 	default="부서"/>',			type: 'string' },
			{name: 'DEPT_NAME',			text: '<t:message code="system.label.human.department" 	default="부서"/>',			type: 'string' },
			{name: 'POST_CODE',			text: '<t:message code="system.label.human.postcode" 	default="직위"/>',			type: 'string', comboType:'AU',comboCode:'H005' },
			{name: 'PERSON_CNT',		text: 'cnt',																		type: 'int'},
			{name: 'NAME',				text: '<t:message code="system.label.human.name" 		default="성명"/>',			type: 'string'},
			{name: 'PERSON_NUMB',		text: '<t:message code="system.label.human.personnumb" 	default="사번"/>',			type: 'string'},
			{name: 'NAME_ENG',			text: '<t:message code="system.label.human.engname" 	default="영문명"/>',			type: 'string'}, // 추가
			{name: 'NAME_CHI',			text: '<t:message code="system.label.human.namechi" 	default="한자이름"/>',			type: 'string'}, // 추가
			{name: 'DOC_ID',			text: 'DOC_ID',																		type: 'string'}, // 추가
			{name: 'REPRE_NUM',			text: '<t:message code="system.label.human.reprenum" 		default="주민등록번호"/>',	type: 'string'},
			{name: 'REPRE_NUM_EXPOS',   text: '<t:message code="system.label.human.reprenum"		default="주민등록번호"/>',  type: 'string'},
			{name: 'ORI_JOIN_DATE',		text: '<t:message code="system.label.human.firstjoindate" 	default="최초입사일"/>',	type: 'uniDate'},
			{name: 'JOIN_DATE',			text: '<t:message code="system.label.human.joindate" 		default="입사일"/>',		type: 'uniDate'},             	 
			{name: 'RETR_DATE',			text: '<t:message code="system.label.human.retrdate" 		default="퇴사일"/>',		type: 'uniDate'},		
			{name: 'RETR_RESN',			text: '<t:message code="system.label.human.retrreson" 		default="퇴사사유"/>',		type: 'string'}, // 추가
			{name: 'ORI_YEAR_DIFF',		text: '<t:message code="system.label.human.oriyeardiff" 	default="최초근속년수"/>',	type: 'string'},
			{name: 'YEAR_DIFF',			text: '<t:message code="system.label.human.yeardiff" 		default="근속년수"/>',		type: 'string'},	
			{name: 'PAY_GUBUN',			text: '<t:message code="system.label.human.paygubun" 		default="고용형태"/>',		type: 'string'}, //comboType:'AU',comboCode:'H011' 
			{name: 'PAY_GUBUN2',		text: '<t:message code="system.label.human.general" 		default="일반"/>/<t:message code="system.label.human.dailyuse" default="일용"/>',			type: 'string'},
			{name: 'EMPLOY_TYPE',		text: '<t:message code="system.label.human.employtype" 		default="사원구분"/>',		type: 'string'}, //, comboType:'AU',comboCode:'H024'
			{name: 'ABIL_CODE',			text: '<t:message code="system.label.human.abil" 			default="직책"/>',		type: 'string'}, //, comboType:'AU',comboCode:'H006'  
			{name: 'AFFIL_CODE',		text: '<t:message code="system.label.human.serial" 			default="직렬"/>',		type: 'string'}, // 추가
			{name: 'KNOC',		        text: '<t:message code="system.label.human.ocpt" 			default="직종"/>',		type: 'string', comboType: "AU"    , comboCode: "H072"}, // 추가
			{name: 'JOB_CODE',			text: '<t:message code="system.label.human.jobcode1" 		default="담당업무"/>',		type: 'string'},
			{name: 'JOIN_CODE',			text: '<t:message code="system.label.human.joincode" 		default="입사구분"/>',		type: 'string'},
			
			{name: 'MAKE_SALE',			text: '<t:message code="system.label.human.makesale" 		default="제조판관구분"/>',	type: 'string'},
			
			{name: 'GRADE',				text: '<t:message code="system.label.human.edugraduation" 	default="학력졸업"/>',		type: 'string'}, //, comboType:'AU',comboCode:'H009'	
			{name: 'ANNOUNCE_DATE',		text: '<t:message code="system.label.human.currentempdate" 	default="현직급임용일"/>', 	type: 'uniDate'},
			{name: 'PAY_GRADE',			text: '<t:message code="system.label.human.paygrade1" 		default="호봉"/>', 		type: 'string'},
			{name: 'PAY_GRADE_BASE',	text: '<t:message code="system.label.human.increasebasis" 	default="승급기준"/>', 	type: 'string'},
			{name: 'YEAR_GRADE',		text: '<t:message code="system.label.human.yeargrade" 		default="근속년"/>', 		type: 'string'},
			{name: 'YEAR_GRADE_BASE',	text: '<t:message code="system.label.human.increasebasis" 	default="승급기준"/>', 	type: 'string'},		//???
			{name: 'PAY_CODE',			text: '<t:message code="system.label.human.paymethodcode" 	default="급여지급방식"/>', 	type: 'string'},
			{name: 'PAY_PROV_FLAG',		text: '<t:message code="system.label.human.payprovflag2" 	default="지급차수"/>', 	type: 'string'},
			{name: 'ANNUAL_SALARY_I',	text: '<t:message code="system.label.human.annualsalaryi" 	default="연봉"/>', 		type: 'uniPrice'},
			{name: 'WAGES_STD_I',		text: '<t:message code="system.label.human.wagesstdi" 		default="기본급"/>', 		type: 'uniPrice'},
			{name: 'PAY_PRESERVE_I',	text: '<t:message code="system.label.human.wagesstdi" 		default="기본급"/>2', 	type: 'uniPrice'},
			{name: 'BONUS_KIND',		text: '<t:message code="system.label.human.bonuspaytype" 	default="상여계산구분"/>', 	type: 'string'},
			{name: 'BONUS_STD_I',		text: '<t:message code="system.label.human.bonusstdi" 		default="상여기준금"/>', 	type: 'uniPrice'},
			{name: 'COM_YEAR_WAGES',	text: '<t:message code="system.label.human.comyearwages2" 	default="년월차기준금"/>', 	type: 'uniPrice'},
			{name: 'TAX_CODE',			text: '<t:message code="system.label.human.taxcodeamt" 		default="연장수당세액"/>', 	type: 'string'},
			{name: 'TAX_CODE2',			text: '<t:message code="system.label.human.taxcode3" 		default="보육수당세액"/>', 	type: 'string'},
			
			{name: 'ANU_BASE_I',		text: '<t:message code="system.label.human.medavgination" 	default="월평균보수액(국민)"/>',  	type: 'uniPrice'},
			{name: 'ANU_INSUR_I',		text: '<t:message code="system.label.human.anuinsuriamt" 	default="국민연금금액"/>', 			type: 'uniPrice'},
			{name: 'MED_AVG_I',			text: '<t:message code="system.label.human.medavgihealth" 	default="월평균보수액(건강)"/>',  	type: 'uniPrice'},
			{name: 'MED_INSUR_I',		text: '<t:message code="system.label.human.healthinsuramt" 	default="건강보험금액"/>', 			type: 'uniPrice'},
			{name: 'ORI_MED_INSUR_I',	text: '<t:message code="system.label.human.orimedinsur" 	default="건강보험(고지)"/>', 		type: 'uniPrice'},
			{name: 'OLD_MED_INSUR_I',	text: '<t:message code="system.label.human.elderlyinsur" 	default="노인요양(고지)"/>', 		type: 'uniPrice'},
			{name: 'HIRE_AVG_I',		text: '<t:message code="system.label.human.medavgigy" 		default="월평균보수액(고용)"/>',  	type: 'uniPrice'},
			{name: 'HIRE_INSUR_I',		text: '<t:message code="system.label.human.hirtaxi" 		default="고용보험료"/>', 			type: 'uniPrice'},
			
			{name: 'KOR_ADDR',			text: '<t:message code="system.label.human.address2" 	default="주소"/>', 					type: 'string'},
			{name: 'TELEPHON',			text: '<t:message code="system.label.human.telephone" 	default="전화번호"/>', 				type: 'string'},
			{name: 'PHONE_NO',			text: '<t:message code="system.label.human.cellphone" 	default="핸드폰"/>', 					type: 'string'},
			{name: 'BIRTH_DATE',		text: '<t:message code="system.label.human.birthdate" 	default="생일"/>', 					type: 'string'},
			{name: 'WEDDING_DATE',		text: '<t:message code="system.label.human.weddingdate" default="결혼기념일"/>', 				type: 'string'},
			{name: 'EMAIL_SEND_YN',		text: '<t:message code="system.label.human.emailsend" 	default="이메일전송"/>', 				type: 'string'},
			{name: 'EMAIL_ADDR',		text: 'E-mail', 																			type: 'string'},
//			{name: 'COST_POOL',			text: gsCostPool, type: 'string'},
			{name: 'COST_POOL',			text: '<t:message code="system.label.human.costpoolname" 	default="회계부서"/>', 			type: 'string'},
			{name: 'BILL_DIV_NAME',		text: '<t:message code="system.label.human.sectcode" 	 	default="신고사업장"/>', 			type: 'string'},
			{name: 'BUSS_OFFICE_CODE',	text: '<t:message code="system.label.human.bussofficecode" 	default="소속지점"/>', 			type: 'string'},
			{name: 'NATION_CODE',		text: '<t:message code="system.label.human.nation" 			default="국가"/>', 				type: 'string'},
			{name: 'BANK_CODE1',		text: '<t:message code="system.label.human.bank" 			default="은행"/>1', 				type: 'string'},
			{name: 'BANK_ACCOUNT1',		text: '<t:message code="system.label.human.bankaccount" 	default="계좌번호"/>1', 			type: 'string'},
			{name: 'BANKBOOK_NAME1',	text: '<t:message code="system.label.human.accountholder" 	default="예금주"/>1', 			type: 'string'},
			{name: 'BANK_CODE2',		text: '<t:message code="system.label.human.bank" 			default="은행"/>2', 				type: 'string'},
			{name: 'BANK_ACCOUNT2',		text: '<t:message code="system.label.human.bankaccount" 	default="계좌번호"/>2', 			type: 'string'},
			{name: 'BANKBOOK_NAME2',	text: '<t:message code="system.label.human.accountholder" 	default="예금주"/>2', 			type: 'string'},
			
			{name: 'PAY_PROV_YN',		text: '<t:message code="system.label.human.payprov" 			  default="급여지급"/>', 		type: 'string'},
			{name: 'PAY_PROV_STOP_YN',	text: '<t:message code="system.label.human.payprovstopyn" 		  default="급여지급보류"/>', 	type: 'string'},
			{name: 'COMP_TAX_I',		text: '<t:message code="system.label.human.taxcalculation" 		  default="세액계산"/>', 		type: 'uniPrice'},
			{name: 'HIRE_INSUR_TYPE',	text: '<t:message code="system.label.human.hireinsurtype2" 		  default="고용보험계산"/>', 	type: 'string'},
			{name: 'BONUS_PROV_YN',		text: '<t:message code="system.label.human.bonusprov" 			  default="상여지급"/>', 		type: 'string'},
			{name: 'YEAR_GIVE',			text: '<t:message code="system.label.human.monthlypayallowance"   default="년월차수당지급"/>', 	type: 'string'},
			{name: 'YEAR_CALCU',		text: '<t:message code="system.label.human.yearcalcunotification" default="열말정산신고"/>', 	type: 'string'},
			{name: 'LABOR_UNON_YN',		text: '<t:message code="system.label.human.laborunon" 			  default="노조가입"/>/<t:message code="system.label.human.premature" default="상조가입"/>', 		type: 'string'},
			{name: 'RETR_GIVE',			text: '<t:message code="system.label.human.youthexempdate" 		  default="퇴직금지급"/>', 	type: 'string'},
			{name: 'RETR_PENSION_KIND', text: '<t:message code="system.label.human.annuretrjoindt" 		  default="퇴직연금가입일"/>', 	type: 'string'},
			
			{name: 'FOREIGN_NUM',		text: '<t:message code="system.label.human.foreignnum" 		default="외국인등록번호"/>', 		type: 'string'},
			{name: 'LIVE_GUBUN',		text: '<t:message code="system.label.human.livegubun" 		default="거주구분"/>', 			type: 'string'},
			{name: 'HOUSEHOLDER_YN',	text: '<t:message code="system.label.human.household" 		default="세대주"/>', 				type: 'string'},
			{name: 'FOREIGN_SKILL_YN',	text: '<t:message code="system.label.human.foreignskill" 	default="외국인기술자"/>', 			type: 'string'},
			{name: 'SPOUSE',			text: '<t:message code="system.label.human.spousededi" 		default="배우자공제"/>', 			type: 'string'},
			{name: 'WOMAN',				text: '<t:message code="system.label.human.womanded2" 		default="부녀자세대공제"/>', 		type: 'string'},
			{name: 'ONE_PARENT',		text: '<t:message code="system.label.human.womanded2" 		default="부녀자세대공제"/>', 		type: 'string'},
			{name: 'SUPP_AGED_NUM',		text: '<t:message code="system.label.human.suppagednum1" 	default="부양가족수"/>', 			type: 'uniNumber'},
			{name: 'DEFORM_YN',			text: '<t:message code="system.label.human.deformyn" 		default="장애자여부"/>', 			type: 'string'},
			{name: 'DEFORM_NUM',		text: '<t:message code="system.label.human.deformeducnum" 	default="장애인인원수"/>', 			type: 'uniNumber'},
			{name: 'CHILD_20_NUM',		text: '<t:message code="system.label.human.dedgradenum" 	default="다자녀수"/>', 			type: 'uniNumber'},
			{name: 'AGED_NUM',			text: '<t:message code="system.label.human.agednum" 		default="경로자"/>(<t:message code="system.label.human.agedded70under" default="70세미만"/>)', 	type: 'uniNumber'},
			{name: 'AGED_NUM70',		text: '<t:message code="system.label.human.agednum" 		default="경로자"/>(<t:message code="system.label.human.agedded70" default="70세이상"/>)', 	type: 'uniNumber'},
			{name: 'BRING_CHILD_NUM',	text: '<t:message code="system.label.human.bringchildnum" 	default="자녀양육"/>', 			type: 'uniNumber'},
			
			{name: 'CARD_NUM',			text: '<t:message code="system.label.human.cardnum" 		default="출입카드NO"/>', 			type: 'string'},
			{name: 'ESS_USE_YN',		text: '<t:message code="system.label.human.essuse" 			default="대사우사용"/>', 			type: 'string'},
			{name: 'REMARK',			text: '<t:message code="system.label.human.otherremark" 	default="기타사항"/>', 			type: 'string'},
			{name: 'ORI_ADDR',			text: '<t:message code="system.label.human.otheraddress" 	default="기타주소"/>', 			type: 'string'},
			{name: 'AGENCY_NAME',		text: '<t:message code="system.label.human.agencykind" 		default="보훈구분"/>', 			type: 'string'},
			{name: 'AGENCY_GRADE',		text: '<t:message code="system.label.human.agencygrade" 	default="보훈등급"/>', 			type: 'string'},
			{name: 'HITCH_NAME',		text: '<t:message code="system.label.human.hitchkind" 		default="장애구분"/>', 			type: 'string'},
			{name: 'HITCH_GRADE',		text: '<t:message code="system.label.human.hitchgrade" 		default="장애등급"/>', 			type: 'string'},
			{name: 'HITCH_DATE',		text: '<t:message code="system.label.human.hitchdate" 		default="장애인등록일"/>', 			type: 'uniDate'},
			
			{name: 'OFFICE_CODE',		text: '<t:message code="system.label.human.officecode" 			default="영업소"/>', 			type: 'string'},
			{name: 'ROUTE_GROUP',		text: '<t:message code="system.label.human.routegroup" 			default="노선그룹"/>', 		type: 'string'},
			{name: 'LICENSE_KIND',		text: '<t:message code="system.label.human.drivelicensetype" 	default="운전면허종류"/>', 		type: 'string'},
			{name: 'LICENSE_NO',		text: '<t:message code="system.label.human.drivelicensenum" 	default="운전면호번호"/>', 		type: 'string'},
			{name: 'LICENSE_ACQ_DATE',	text: '<t:message code="system.label.human.acqdate" 			default="취득일"/>', 			type: 'uniDate'},
			{name: 'LICENSE_FRDATE',	text: '<t:message code="system.label.human.validate" 			default="유효일"/>(<t:message code="system.label.human.start" default="시작"/>)', type: 'uniDate'},
			{name: 'LICENSE_TODATE',	text: '<t:message code="system.label.human.validate" 			default="유효일"/>(<t:message code="system.label.human.end" default="종료"/>)', 	type: 'uniDate'},
			{name: 'BUS_CERTIFICATE',	text: '<t:message code="system.label.human.buscertificate" 		default="버스자격번호"/>', 		type: 'string'},
			{name: 'CERTI_ACQ_DATE',	text: '<t:message code="system.label.human.certiacqdate" 		default="자격취득일"/>', 		type: 'uniDate'},
			{name: 'CIVIL_DEF_YN',		text: '<t:message code="system.label.human.civildefyn" 			default="민방위대상"/>', 		type: 'string'},
			{name: 'CIVIL_DEF_NUM',		text: '<t:message code="system.label.human.civildefnum" 		default="민방위년차"/>', 		type: 'string'},
			{name: 'MEMO_1',			text: '<t:message code="system.label.human.memo" 				default="메모"/>1', 			type: 'string'},
			{name: 'MEMO_2',			text: '<t:message code="system.label.human.memo" 				default="메모"/>2', 			type: 'string'}
		]
	});
   
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
   var directMasterStore1 = Unilite.createStore('hum920skrMasterStore1',{
         model: 'Hum920skrModel',
         uniOpt : {
               isMaster: true,         // 상위 버튼 연결 
               editable: false,         // 수정 모드 사용 
               deletable:false,         // 삭제 가능 여부 
               useNavi : false         // prev | newxt 버튼 사용
                  //비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {          
                      read: 'hum920skrService.selectList'                   
                }
            },
    		listeners : {
    	        load : function(store) {
    	            /*if (store.getCount() > 0) {
    	            	setGridSummary(Ext.getCmp('CHKCNT').checked);
    	            }*/
    	            var newValue = panelSearch.getValue('ORI_JOIN_DATE'); 
    	            checkVisibleOriJoinDate(newValue);
    	        }
    	    },
    	    loadStoreRecords : function()   {
	            var param= Ext.getCmp('searchForm').getValues();         
	            console.log( param );
	            this.load({
	               params : param
	            });
	        },
	        _onStoreLoad: function ( store, records, successful, eOpts ) {
		    	if(this.uniOpt.isMaster) {
		    		var recLength = 0;
		    		Ext.each(records, function(record, idx){
		    			if(record.get('GUBUN') == '1'){
		    				recLength++;
		    			}
		    		});
			    	if (records) {
				    	UniAppManager.setToolbarButtons('save', false);
						var msg = recLength + Msg.sMB001; //'건이 조회되었습니다.';
				    	//console.log(msg, st);
				    	UniAppManager.updateStatus(msg, true);	
			    	}
		    	}
		    }
   });
   


   /**
    * 검색조건 (Search Panel)
    * @type 
    */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',		
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
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',           	
			items: [{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
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
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}), 
			Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
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
    			fieldLabel: '<t:message code="system.label.human.joindate" default="입사일"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'ANN_FR_DATE',
		        endFieldName: 'ANN_TO_DATE',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('ANN_FR_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ANN_TO_DATE',newValue);
			    	}
			    }
	        },{ 
    			fieldLabel: '<t:message code="system.label.human.retrdate" default="퇴사일"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_RETR',
		        endFieldName: 'TO_RETR',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_RETR',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_RETR',newValue);
			    	}
			    }
	        },{
                fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
                xtype: 'radiogroup',
                columns: [60,60,60],
                items: [{
	            		boxLabel: '<t:message code="system.label.human.whole" default="전체"/>',
						name: 'RDO_TYPE',
						inputValue: ''
					},{
						boxLabel: '<t:message code="system.label.human.incumbent" default="재직"/>',
						name: 'RDO_TYPE',
						inputValue: '1',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>',
						name: 'RDO_TYPE',
						inputValue: '00000000'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
						}
					}
            },{
                fieldLabel: '<t:message code="system.label.human.sexcode" default="성별"/>',
                xtype: 'radiogroup',
                columns: [60,60,60],
                items: [{
						boxLabel: '<t:message code="system.label.human.whole" default="전체"/>',
						name: 'SEX_CODE',
						inputValue: '',
						checked: true 
					},{
						boxLabel: '<t:message code="system.label.human.male" default="남"/>',
						name: 'SEX_CODE',
						inputValue: 'M'
					},{
						boxLabel: '<t:message code="system.label.human.female" default="여"/>',
						name: 'SEX_CODE',
						inputValue: 'F'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('SEX_CODE').setValue(newValue.SEX_CODE);
						}
					}
            },{
            	fieldLabel: '<t:message code="system.label.human.staffsumindication" default="인원합계 표시"/>',
            	margin: '0 0 0 40',
            	labelWidth: 100,
            	name: 'CHKCNT',
				id: 'CHKCNT',
				uncheckedValue: 'N',
        		inputValue: 'Y',
				xtype: 'checkbox',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('CHKCNT', newValue);
					}
					/*click: {
						element: 'el', //bind to the underlying el property on the panel
						fn: function(){ 
							console.log('click el');
							setGridSummary(Ext.getCmp('CHKCNT').checked);
						}
					}*/
				}
			},{
            	fieldLabel: '<t:message code="system.label.human.deformyn" default="장애자여부"/>',
            	margin: '0 0 0 40',
            	labelWidth: 100,
            	name: 'DEFORM_YN',
				uncheckedValue: '',
        		inputValue: 'Y',
				xtype: 'checkbox',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('DEFORM_YN', newValue);
					}
				}
			}
		]},{
		   	title: '<t:message code="system.label.human.addinfo" default="추가정보"/>', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',           	
			items: [{ 
				fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
				name: 'PAY_GUBUN',
				id: 'PAY_GUBUN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H011',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {   
                        panelResult.setValue('PAY_GUBUN', newValue);
                    }
                }
/*				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						if(newValue){
							checkVisible(newValue);
						}
					}
		        }*/
			},{
				xtype:'container',
				items:[{
	                fieldLabel: '<t:message code="system.label.human.irregularwork" default="비정규직"/>',
	                name: 'PAY_GU2',
	                id:'PAY_GU2',
	                xtype: 'radiogroup',                
	                columns: [60,60,60],
	                items: [{
						boxLabel: '<t:message code="system.label.human.whole" default="전체"/>',
						name: 'PAY_GU2',
						inputValue: '',
						checked: true 
					},{
						boxLabel: '<t:message code="system.label.human.general" default="일반"/>',
						name: 'PAY_GU2',
						inputValue: '2'
					},{
						boxLabel: '<t:message code="system.label.human.dailyuse" default="일용"/>',
						name: 'PAY_GU2',
						inputValue: '1'
					}]
            	}]
			},{
				fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
				name: 'EMPLOY_TYPE',
				id: 'EMPLOY_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H024'
			},{
				fieldLabel: '<t:message code="system.label.human.postcode" default="직위"/>',
				name: 'POST_CODE',
				id: 'POST_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H005'
			},{
				fieldLabel: '<t:message code="system.label.human.abil" default="직책"/>',
				name: 'ABIL_CODE',
				id: 'ABIL_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H006'
			},
			//직종
			{
                fieldLabel: '<t:message code="system.label.human.ocpt" default="직종"/>',
                name:'KNOC',
                xtype: 'uniCombobox',
                listConfig:{minWidth:120}, 
                comboType: 'AU', 
                comboCode: 'H072',
//                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('KNOC', newValue);
                    }
                }
            },	
					
			{
				fieldLabel: '<t:message code="system.label.human.schshipcode1" default="학력"/>',
				name: 'SCHSHIP_CODE',
				id: 'SCHSHIP_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H009'
			},{
				fieldLabel: '<t:message code="system.label.human.gradutype" default="졸업구분"/>',
				name: 'GRADU_TYPE',
				id: 'GRADU_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H010'
			},
				Unilite.popup('PAY_GRADE',{
					fieldLabel: '<t:message code="system.label.human.paygrade" default="급호"/>',
				  	valueFieldName:'PAY_GRADE_01',
				    textFieldName:'PAY_GRADE_02',
					validateBlank:false
			}),{
				fieldLabel: '<t:message code="system.label.human.increasebasis" default="승급기준"/>', //호봉승급기준
				name: 'PAY_GRADE_BASE',
				id: 'PAY_GRADE_BASE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H174'
			},{
				fieldLabel: '<t:message code="system.label.human.hireinsuri" default="고용보험"/>',//콤보코드 없음
				name: 'HIRE_INSUR_TYPE',
				id: 'HIRE_INSUR_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'T107'
			},{
				fieldLabel: '<t:message code="system.label.human.firstjoindate" default="최초입사일"/>',
				//name: 'ORI_JOIN_DATE',
				xtype: 'radiogroup',
				id: 'oriRadio',
				columns: [60,60],
				items: [{
					boxLabel: '<t:message code="system.label.human.notinclude" default="포함안함"/>',
					name: 'ORI_JOIN_DATE',
					inputValue: 'X',
					width: 80,
					checked: true
				},{
					boxLabel: '<t:message code="system.label.human.include" default="포함"/>',
					name: 'ORI_JOIN_DATE',
					inputValue: 'O'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						if(newValue){
							checkVisibleOriJoinDate(newValue);
						}
					}
			    }
			},{
				xtype: 'fieldcontainer',
				fieldLabel: '<t:message code="system.label.human.yeardiff" default="근속년수"/>',
				layout: {type : 'uniTable',columns : 11},
				defaults: {flex: 1, hideLabel: true},
				defaultType : 'textfield',
				colspan: 3,
				items: [
					{
						fieldLabel: '<t:message code="system.label.human.startyear1" default="시작년도"/>',
						id: 'startYear',
						name: 'startYear',
						xtype: 'uniTextfield',
						width: 35
					},
					{xtype: 'displayfield', value: '<t:message code="system.label.human.year" default="년"/>&nbsp;'},
					{
						fieldLabel: '<t:message code="system.label.human.startmonth" default="시작월"/>',
						id: 'startMonth',
						name: 'startMonth',
						xtype: 'uniTextfield',
						width: 35
					},
					{xtype: 'displayfield', value: '<t:message code="system.label.human.month" default="월"/>'},
					{xtype: 'displayfield', value: '&nbsp;~&nbsp;'},
					{
						fieldLabel: '<t:message code="system.label.human.endyear" default="종료년도"/>',
						id: 'endYear',
						name: 'endYear',
						xtype: 'uniTextfield',
						width: 35
					},
					{xtype: 'displayfield', value: '년&nbsp;'},
					{
						fieldLabel: '<t:message code="system.label.human.endmonth" default="종료월"/>',
						id: 'endMonth',
						name: 'endMonth',
						xtype: 'uniTextfield',
						width: 35
					},
					{xtype: 'displayfield', value: '<t:message code="system.label.human.month" default="월"/>&nbsp;'}
					
				]
			},{
				fieldLabel: '<t:message code="system.label.human.basisdate" default="기준일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'BASIS_FR_DATE',
				endFieldName: 'BASIS_TO_DATE',
				width: 315
	    	},{
//				fieldLabel: '사업명',
				fieldLabel: '<t:message code="system.label.human.costpoolname" default="회계부서"/>',
				name:'COST_POOL',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('getHumanCostPool')
			},{
				fieldLabel: '<t:message code="system.label.human.agencykind" default="보훈구분"/>',
				name: 'AGENCY_KIND',
				id: 'AGENCY_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H084'
			},{
				fieldLabel: '<t:message code="system.label.human.hitchkind" default="장애구분"/>',
				name: 'HITCH_KIND',
				id: 'HITCH_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H085'
			},{
				fieldLabel: '<t:message code="system.label.human.serial" default="직렬"/>',
				name: 'AFFIL_CODE',
				id: 'AFFIL_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H173'
			},{
				fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
				name: 'PAY_CODE',
				id: 'PAY_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H028'
			},{
				fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
				name: 'PAY_PROV_FLAG',
				id: 'PAY_PROV_FLAG',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H031'
			},{
				fieldLabel: '<t:message code="system.label.human.employeegroup" default="사원그룹"/>',
				name: 'PERSON_GROUP',
				id: 'PERSON_GROUP',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H181'
			},{
				fieldLabel: '<t:message code="system.label.human.jobcode1" default="담당업무"/>',
				name: 'JOB_CODE',
				id: 'JOB_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H008'
			},
			{
				xtype: 'radiogroup',	
				id: 'RDOENCRYPT',
				fieldLabel: '<t:message code="system.label.human.socialsecuritynumberencryption" default="주민번호 암호화"/>',	
				labelWidth: 90,
				items: [{
					boxLabel: '<t:message code="system.label.human.do" default="한다"/>', 
					width: 50, 
					name: 'RDOENCRYPT',
					inputValue: 'Y',
					checked: true  
				},{
					boxLabel: '<t:message code="system.label.human.donot" default="안한다"/>',  
					width: 70, 
					name: 'RDOENCRYPT',
					inputValue: 'N'
				}]
			}]
		}]     	
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
				collapseOnSelect:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
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
				//colspan:2,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelSearch.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelSearch.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelSearch.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}), 
			
			{ 
				fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
				name: 'PAY_GUBUN',
				//id: 'PAY_GUBUN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H011',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelSearch.setValue('PAY_GUBUN', newValue);
                    }
                }
			}
			,
			
			{ 
    			fieldLabel: '<t:message code="system.label.human.joindate" default="입사일"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'ANN_FR_DATE',
		        endFieldName: 'ANN_TO_DATE',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
							panelSearch.setValue('ANN_FR_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ANN_TO_DATE',newValue);
			    	}
			    }
	        },
	        Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				colspan:2,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME', panelSearch.getValue('NAME'));				 																							
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
    			fieldLabel: '<t:message code="system.label.human.retrdate" default="퇴사일"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_RETR',
		        endFieldName: 'TO_RETR',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
							panelSearch.setValue('FR_RETR',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_RETR',newValue);
			    	}
			    }
	        },
	        //직종추가
	        {
                fieldLabel: '<t:message code="system.label.human.ocpt" default="직종"/>',
                name:'KNOC',
                xtype: 'uniCombobox',
                listConfig:{minWidth:120}, 
                comboType: 'AU', 
                comboCode: 'H072',
//                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelSearch.setValue('KNOC', newValue);
                    }
                }
            },
		
	        			
	        				
	        {
            	fieldLabel: '<t:message code="system.label.human.staffsumindication" default="인원합계 표시"/>',
            	margin: '0 0 0 40',
            	labelWidth: 100,
            	name: 'CHKCNT',
				uncheckedValue: 'N',
        		inputValue: 'Y',
				xtype: 'checkbox',
				colspan:2,
				listeners: {
/*					click: {
						element: 'el', //bind to the underlying el property on the panel
						fn: function(){ 
							console.log('click el');
							setGridSummary(Ext.getCmp('CHKCNT').checked);
						}
					},*/
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('CHKCNT', newValue);
					}
				}
			},{
                fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
                xtype: 'radiogroup',
                columns: [60,60,60],
                items: [{
	            		boxLabel: '<t:message code="system.label.human.whole" default="전체"/>',
						name: 'RDO_TYPE',
						inputValue: ''
					},{
						boxLabel: '<t:message code="system.label.human.incumbent" default="재직"/>',
						name: 'RDO_TYPE',
						inputValue: '1',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>',
						name: 'RDO_TYPE',
						inputValue: '00000000'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
						}
					}
            },{
                fieldLabel: '<t:message code="system.label.human.sexcode" default="성별"/>',
                xtype: 'radiogroup',
                columns: [60,60,60],
                items: [{
						boxLabel: '<t:message code="system.label.human.whole" default="전체"/>',
						name: 'SEX_CODE',
						inputValue: '',
						checked: true 
					},{
						boxLabel: '<t:message code="system.label.human.male" default="남"/>',
						name: 'SEX_CODE',
						inputValue: 'M'
					},{
						boxLabel: '<t:message code="system.label.human.female" default="여"/>',
						name: 'SEX_CODE',
						inputValue: 'F'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('SEX_CODE').setValue(newValue.SEX_CODE);
						}
					}
            },{
            	fieldLabel: '<t:message code="system.label.human.deformyn" default="장애자여부"/>',
            	margin: '0 0 0 40',
            	labelWidth: 100,
            	name: 'DEFORM_YN',
				uncheckedValue: 'N',
        		inputValue: 'Y',
				xtype: 'checkbox',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('DEFORM_YN', newValue);
					}
				}
			}]
    });
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('hum920skrGrid1', {
       region: 'center',
        layout: 'fit',
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,			
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
        /*tbar: [{
        	xtype: 'splitbutton',
        	text: '이동...',
        	iconCls : 'icon-referance',
        	menu: Ext.create('Ext.menu.Menu',{
        		items: [{
        			itemId: 'defaultHumRegBtn',
        			text: '인사기본자료등록',
        			handler: function() {
        				if (masterGrid.getSelectionModel().hasSelection()) {
						   var person_numb = masterGrid.getSelectionModel().getSelection()[0].get('PERSON_NUMB');
						}
        				var params = {
								'PERSON_NUMB' : person_numb
   						}
   						var rec = {data : {prgID : 'hum100ukr', 'text':'인사기본자료등록'}};							
   						parent.openTab(rec, '/human/hum100ukr.do', params);	
   						// srq100ukrv의 fnInitBinding(params)에서 처리되도록 구현되어야 함. (cmb200ukrv.jsp 참고)
					}
        		}]
        		
        	})
        }],*/
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false						
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('GUBUN') == '2'){
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
	    },
		store: directMasterStore1,
        columns: [
			{dataIndex: 'DIV_CODE',				width: 150},
			//{dataIndex: 'DEPT_CODE',			width: 130},
			{dataIndex: 'DEPT_NAME',			width: 160},
			{dataIndex: 'POST_CODE',			width: 100},
			//{dataIndex: 'PERSON_CNT',			width: 100},
			
			{dataIndex: 'NAME',					width: 100,
			renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('GUBUN') == '2') {	
						return val + '<t:message code="system.label.human.name1" default="명"/>';
					} else {
						return val;
					}
	            }
			},
			{dataIndex: 'PERSON_NUMB',			width: 100 },
			{dataIndex: 'NAME_ENG',				width: 120 , hidden: true},
			{dataIndex: 'NAME_CHI',				width: 100 , hidden: true},
			{dataIndex: 'DOC_ID',				width: 50  , hidden: true},
			{dataIndex: 'REPRE_NUM_EXPOS',      width: 120 , hidden: true},
			{dataIndex: 'REPRE_NUM',			width: 120 },
			{dataIndex: 'ORI_JOIN_DATE',		width: 100 , hidden: true},
			{dataIndex: 'JOIN_DATE',			width: 100 },
			{dataIndex: 'RETR_DATE',			width: 100 },
			{dataIndex: 'RETR_RESN',			width: 150 },
			{dataIndex: 'ORI_YEAR_DIFF',		width: 100 },
			{dataIndex: 'YEAR_DIFF',			width: 100 },
			{dataIndex: 'PAY_GUBUN',			width: 110 },
			{dataIndex: 'PAY_GUBUN2',			width: 110 },
			{dataIndex: 'EMPLOY_TYPE',			width: 100 },
			{dataIndex: 'ABIL_CODE',			width: 100 },
			{dataIndex: 'AFFIL_CODE',			width: 100 },
			{dataIndex: 'MAKE_SALE',			width: 100 },
			//직종추가
			{dataIndex: 'KNOC',			       width: 100 },
			{dataIndex: 'JOB_CODE',				width: 100 },
			{dataIndex: 'JOIN_CODE',			width: 100 },
			{dataIndex: 'GRADE',				width: 120 },
			{dataIndex: 'ANNOUNCE_DATE',		width: 100 },
			{dataIndex: 'PAY_GRADE',			width: 100 },
			{dataIndex: 'PAY_GRADE_BASE',		width: 80  },
			{dataIndex: 'YEAR_GRADE',			width: 80  },
			{dataIndex: 'YEAR_GRADE_BASE',		width: 80  },
			{dataIndex: 'PAY_CODE',				width: 90  },
			{dataIndex: 'PAY_PROV_FLAG',		width: 100 },
			{dataIndex: 'ANNUAL_SALARY_I',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'WAGES_STD_I',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'PAY_PRESERVE_I',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'BONUS_KIND',			width: 100 , hidden: true}, // hidden: ture
			{dataIndex: 'BONUS_STD_I',			width: 100 , hidden: true}, // hidden: true
			{dataIndex: 'COM_YEAR_WAGES',		width: 100 , hidden: SetHiddenMode},  // hidden: true
			{dataIndex: 'TAX_CODE',				width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'TAX_CODE2',			width: 100 , hidden: SetHiddenMode},
			
			{dataIndex: 'ANU_BASE_I',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'ANU_INSUR_I',			width: 100 },
			{dataIndex: 'MED_AVG_I',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'MED_INSUR_I',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'ORI_MED_INSUR_I',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'OLD_MED_INSUR_I',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'HIRE_AVG_I',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'HIRE_INSUR_I',			width: 100 , hidden: SetHiddenMode},
			
			{dataIndex: 'KOR_ADDR',				width: 350 },
			{dataIndex: 'TELEPHON',				width: 100 },
			{dataIndex: 'PHONE_NO',				width: 100 },
			{dataIndex: 'BIRTH_DATE',			width: 100 },
			{dataIndex: 'WEDDING_DATE',			width: 100 },
			{dataIndex: 'EMAIL_SEND_YN',		width: 100 },
			{dataIndex: 'EMAIL_ADDR',			width: 180 },
			{dataIndex: 'COST_POOL',			width: 100 },
			{dataIndex: 'BILL_DIV_NAME',		width: 100 , hidden: true},
			{dataIndex: 'BUSS_OFFICE_CODE',		width: 100 },
			{dataIndex: 'NATION_CODE',			width: 100 , hidden: true},
			{dataIndex: 'BANK_CODE1',			width: 100 },
			{dataIndex: 'BANK_ACCOUNT1',		width: 150 },
			{dataIndex: 'BANKBOOK_NAME1',		width: 100 },
			{dataIndex: 'BANK_CODE2',			width: 100 },
			{dataIndex: 'BANK_ACCOUNT2',		width: 150 },
			{dataIndex: 'BANKBOOK_NAME2',		width: 100 },
			
			{dataIndex: 'PAY_PROV_YN',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'PAY_PROV_STOP_YN',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'COMP_TAX_I',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'HIRE_INSUR_TYPE',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'BONUS_PROV_YN',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'YEAR_GIVE',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'YEAR_CALCU',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'LABOR_UNON_YN',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'RETR_GIVE',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'RETR_PENSION_KIND',	width: 100 , hidden: SetHiddenMode},
			
			{dataIndex: 'FOREIGN_NUM',			width: 100 },
			{dataIndex: 'LIVE_GUBUN',			width: 100 },
			{dataIndex: 'HOUSEHOLDER_YN',		width: 100 },
			{dataIndex: 'FOREIGN_SKILL_YN',		width: 100 },
			{dataIndex: 'SPOUSE',				width: 100 },
			{dataIndex: 'WOMAN',				width: 100 },
			{dataIndex: 'ONE_PARENT',			width: 100 },
			{dataIndex: 'SUPP_AGED_NUM',		width: 100 },
			{dataIndex: 'DEFORM_YN',			width: 100 },
			{dataIndex: 'DEFORM_NUM',			width: 100 },
			{dataIndex: 'CHILD_20_NUM',			width: 100 },
			{dataIndex: 'AGED_NUM',				width: 130 },
			{dataIndex: 'AGED_NUM70',			width: 130 },
			{dataIndex: 'BRING_CHILD_NUM',		width: 100 },
			
			{dataIndex: 'CARD_NUM',				width: 100 , hidden: true},
			{dataIndex: 'ESS_USE_YN',			width: 100 , hidden: true},
			{dataIndex: 'REMARK',				width: 100 },
			{dataIndex: 'ORI_ADDR',				width: 100 , hidden: true},
			{dataIndex: 'AGENCY_NAME',			width: 100 },
			{dataIndex: 'AGENCY_GRADE',			width: 100 },
			{dataIndex: 'HITCH_NAME',			width: 100 },
			{dataIndex: 'HITCH_GRADE',			width: 100 },
			{dataIndex: 'HITCH_DATE',			width: 100 },
			
			{dataIndex: 'OFFICE_CODE',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'ROUTE_GROUP',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'LICENSE_KIND',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'LICENSE_NO',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'LICENSE_ACQ_DATE',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'LICENSE_FRDATE',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'LICENSE_TODATE',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'BUS_CERTIFICATE',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'CERTI_ACQ_DATE',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'CIVIL_DEF_YN',			width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'CIVIL_DEF_NUM',		width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'MEMO_1',				width: 100 , hidden: SetHiddenMode},
			{dataIndex: 'MEMO_2',				width: 100 , hidden: SetHiddenMode}
			
			
        ],
        listeners: {
             onGridDblClick:function(grid, record, cellIndex, colName, td)   {
                    if (colName =="REPRE_NUM") {
                        grid.ownerGrid.openRepreNumPopup(record);
                    }   
            },
         	beforeedit: function( editor, e, eOpts ) {

                /*if(!e.record.phantom == true) { // 신규가 아닐 때
                    if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB'])) {
                        return false;
                    }
                }*/
                if(!e.record.phantom == true || e.record.phantom == true) {     // 신규이던 아니던
                    if(UniUtils.indexOf(e.field, ['REPRE_NUM'])) {
                        return false;
                    }
                }
            },
			itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
        openRepreNumPopup:function( record )    {
            if(record)  {
                var params = {'REPRE_NUM': record.get('REPRE_NUM_EXPOS'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'N'}
                Unilite.popupCipherComm('grid', record, 'REPRE_NUM', 'REPRE_NUM_EXPOS', params);
            }
                
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
        	if(record.get("GUBUN") == '1'){
      			return true;
        	}
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '<t:message code="system.label.human.humbasinfouploadview" default="인사기본자료등록 보기"/>',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoHum920skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoHum920skr:function(record)	{
			if(record)	{
		    	var params = {
		    		action:'select',
			    	'PGM_ID' 			: 'hum920skr',
			    	'PERSON_NUMB' 		:  record.data['PERSON_NUMB'],					/* gsParam(0) */
			    	'NAME' 				:  record.data['NAME'],							/* gsParam(1) */
			    	'COMP_CODE' 		:  UserInfo.compCode,							/* gsParam(2) */
			    	'DOC_ID'			:  record.data['DOC_ID']  						/* gsParam(3) */
			    	
		    	}
		    	var rec1 = {data : {prgID : 'hum100ukr', 'text':''}};							
				parent.openTab(rec1, '/human/hum100ukr.do', params);	    	
			}
    	}
    });
   
   
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
      id  : 'hum920skrApp',
      fnInitBinding : function() {
         panelSearch.setValue('DIV_CODE',UserInfo.divCode);
         UniAppManager.setToolbarButtons('detail',true);
         UniAppManager.setToolbarButtons('reset',false);
         Ext.getCmp('PAY_GU2').setVisible(false);
         
         if(!Ext.isEmpty(gsCostPool)){
			panelSearch.getField('COST_POOL').setFieldLabel(gsCostPool);  
		 }
      },
      onQueryButtonDown : function()   {         
         masterGrid.getStore().loadStoreRecords();
      }
   });

    
    // 최초 입사일의 표시 /숨김 적용
    function checkVisibleOriJoinDate(newValue) {
    	//var value = Ext.getCmp('oriRadio').items.get(0).getGroupValue();
		if (newValue.ORI_JOIN_DATE == 'O') {
			masterGrid.getColumn('ORI_JOIN_DATE').setVisible(true);
			masterGrid.getColumn('ORI_YEAR_DIFF').setVisible(true);
		} else {
			masterGrid.getColumn('ORI_JOIN_DATE').setVisible(false);
			masterGrid.getColumn('ORI_YEAR_DIFF').setVisible(false);
		}
    }
    
    function checkVisible(newValue) {
    	//var value = Ext.getCmp('oriRadio').items.get(0).getGroupValue();
		if (newValue == '2') {
			
			Ext.getCmp('PAY_GU2').setVisible(true);
		} else {
			Ext.getCmp('PAY_GU2').setVisible(false);
		}
    }

};


</script>