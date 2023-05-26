<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="s_hbs020ukr_KOCIS"  >
	
	<t:ExtComboStore comboType="AU" comboCode="H012" /><!--  입사코드         -->
	<t:ExtComboStore comboType="AU" comboCode="H058" /><!--  서류구분         -->	
	<t:ExtComboStore comboType="AU" comboCode="H037" /><!--  상여구분자         -->
	<t:ExtComboStore comboType="AU" comboCode="H166" /><!--  근속수당기준일         -->
	<t:ExtComboStore comboType="A" comboCode="H033" /><!--  근태코드         -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /><!--  사원구분         --> 
	<t:ExtComboStore comboType="AU" comboCode="H028" /><!--  급여지급방식     -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /><!--  직위구분         --> 
	<t:ExtComboStore comboType="AU" comboCode="H029" /><!--  세액구분         -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /><!--  급여지급일구분   --> 
	<t:ExtComboStore comboType="AU" comboCode="H049" /><!--  월차지급방식     -->
	<t:ExtComboStore comboType="AU" comboCode="H037" /><!--  상여계산구분자   --> 
	<t:ExtComboStore comboType="AU" comboCode="H036" /><!--  잔업계산구분자   -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /><!--  직책             --> 
	<t:ExtComboStore comboType="AU" comboCode="H009" /><!--  최종학력         -->
	<t:ExtComboStore comboType="AU" comboCode="H008" /><!--  담당업무         --> 	
	<t:ExtComboStore comboType="AU" comboCode="H010" /><!--  졸업구분         -->
	<t:ExtComboStore comboType="AU" comboCode="H023" /><!--  퇴사사유         --> 
	<t:ExtComboStore comboType="AU" comboCode="H017" /><!--  병역군별         -->
	<t:ExtComboStore comboType="AU" comboCode="H018" /><!--  병역계급         --> 
	<t:ExtComboStore comboType="AU" comboCode="H019" /><!--  병역병과         -->
	<t:ExtComboStore comboType="AU" comboCode="H016" /><!--  병역구분         --> 
	<t:ExtComboStore comboType="AU" comboCode="B012" /><!--  국가         	  --> 
	
	<t:ExtComboStore comboType="BOR120" />			   <!--  사업장           -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" />	<!--  신고사업장           -->
	<t:ExtComboStore comboType="AU" comboCode="B027" /><!--  제조판관         -->
	<t:ExtComboStore comboType="CBM600"/>   		   <!--  Cost Pool        --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /><!--  고용형태         -->
	<t:ExtComboStore comboType="AU" comboCode="H007" /><!--  거주구분         --> 
	<t:ExtComboStore comboType="AU" comboCode="B004" /><!--  화폐단위         -->
	<t:ExtComboStore comboType="BOR120" comboCode="BILL_DIV"/>			   <!--  신고사업장       --> 	
	<t:ExtComboStore comboType="AU" comboCode="H112" /><!--  퇴직계산분류     -->
	<t:ExtComboStore comboType="AU" comboCode="H143" /><!--  양음구분     -->
	<t:ExtComboStore comboType="AU" comboCode="H144" /><!--  결혼여부     -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /><!--  예/아니오     -->
	<t:ExtComboStore comboType="AU" comboCode="H020" /><!--  가족관계     -->
	
	<t:ExtComboStore comboType="AU" comboCode="H080" /><!--  혈액형     -->
	<t:ExtComboStore comboType="AU" comboCode="H081" /><!--  색맹여부     -->
	<t:ExtComboStore comboType="AU" comboCode="H082" /><!--  주거구분     -->
	<t:ExtComboStore comboType="AU" comboCode="H083" /><!--  생활수준     -->
	<t:ExtComboStore comboType="AU" comboCode="H084" /><!--  보훈구분     -->
	<t:ExtComboStore comboType="AU" comboCode="H085" /><!--  장애구분     -->
	<t:ExtComboStore comboType="AU" comboCode="H086" /><!--  종교     -->
	<t:ExtComboStore comboType="AU" comboCode="H163" /><!--  인정경력구분     -->
	<t:ExtComboStore comboType="AU" comboCode="H087" /><!--  전공학과      -->
	
	<t:ExtComboStore comboType="AU" comboCode="H089" /><!--  교육기관      -->
	<t:ExtComboStore comboType="AU" comboCode="H090" /><!--  교육국가      -->
	<t:ExtComboStore comboType="AU" comboCode="H091" /><!--  구분      -->
	<t:ExtComboStore comboType="AU" comboCode="H022" /><!--  자격종류      -->
	<t:ExtComboStore comboType="AU" comboCode="H022" /><!--  자격종류      -->
	
	<t:ExtComboStore comboType="AU" comboCode="H094" /><!--  발령코드      -->
	<t:ExtComboStore comboType="AU" comboCode="H095" /><!--  고과구분      -->
	<t:ExtComboStore comboType="AU" comboCode="H096" /><!--  상벌종류      -->
	<t:ExtComboStore comboType="AU" comboCode="H164" /><!--  계약구분      -->
	<t:ExtComboStore comboType="AU" comboCode="H088" /><!--  비자종류      -->
	
	<t:ExtComboStore comboType="AU" comboCode="H032" /><!-- 급/상여구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H002" /><!-- 일구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H003" /><!-- 휴무구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H004" /><!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="H055" /><!-- 평균 임금 계산 방식 -->
	
	<t:ExtComboStore items="${wagesCodeList}" storeId="wagesList" /><!--입/퇴사자지급기준등록 수당코드 콤보-->
	<t:ExtComboStore items="${bonusTypeCodeList}" storeId="bonusTypeList" /><!--상여지급기준등록 상여구분 콤보-->
	<t:ExtComboStore items="${paymCombo}" storeId="paymCombo" />
	
	<t:ExtComboStore comboType="AU" comboCode="H011" includeMainCode="true" />
	<t:ExtComboStore comboType="AU" comboCode="H024" includeMainCode="true" />
	<t:ExtComboStore comboType="AU" comboCode="H005" includeMainCode="true" />
	<t:ExtComboStore comboType="AU" comboCode="H006" includeMainCode="true" />
	<t:ExtComboStore comboType="AU" comboCode="H031" includeMainCode="true" />
	<t:ExtComboStore comboType="AU" comboCode="H028" includeMainCode="true" />
	<t:ExtComboStore comboType="AU" comboCode="H004" includeMainCode="true" />
	<t:ExtComboStore comboType="AU" comboCode="H008" includeMainCode="true" />
	<t:ExtComboStore comboType="AU" comboCode="H009" includeMainCode="true" />
	<t:ExtComboStore comboType="AU" comboCode="H012" includeMainCode="true" />
</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {

	// ---- 급호봉등록 사용 변수 시작 ----
	var colDataTab11 = ${colDataTab11};
	console.log(colDataTab11);
	
	var fieldsTab11 = createModelField(colDataTab11, 'hbs020ukrTab11');
	var columnsTab11 = createGridColumn(colDataTab11, 'hbs020ukrTab11');
	// ---- 급호봉등록 사용 변수 끝 ----
	
	// 퇴직추계액 테이블 sub_length
	var sub_length = ${sub_length};

	// ---- 계산식등록 사용 변수 시작 ----
	// 분류 -> 분류값 조회용 필드명의 배열
	searchField = new Array();
	// 선택 되어있는 그리드 저장
	selectedGrid = '';
	// ---- 계산식등록 사용 변수 끝 ----

	// ---- 연봉등록 사용 변수 시작 ----
	//엑셀참조 윈도우
	var excelWindow;
	// ---- 연봉등록 사용 변수 끝 ----
	
	Unilite.defineModel('hbs020ukrs1FormModel', {
	    fields: [
			 {name: 'COMPANY_CODE'        	,text:'종합코드'         	,type : 'string'},
             {name: 'MED_PRSN_RATE'         ,text:'상세코드'         	,type : 'float'},
             {name: 'MED_COMP_RATE'         ,text:'지급차수'         	,type : 'float'},
             {name: 'ANUT_PRSN_RATE1'       ,text:'시스템'         	,type : 'float'},
             {name: 'ANUT_COMP_RATE1'       ,text:'근태집계마감일'      	,type : 'float'},
             {name: 'EMPLOY_RATE'           ,text:'관련2'            	,type : 'float'},
             {name: 'RETR_DUTY_RULE'        ,text:'관련3'            	,type : 'string'},
             {name: 'BONUS_DUTY_RULE'       ,text:'급여집계마감일'      	,type : 'string'},
             {name: 'MONTH_CALCU_YN'        ,text:'REF_CODE5'      	,type : 'string'},
             {name: 'MENS_CALCU_YN'         ,text:'길이'            	,type : 'string'},
             {name: 'EARLY_PLAN_YN'         ,text:'USE_YN'         	,type : 'string'},
             {name: 'RETR_CALCU_RULE'       ,text:'SORT_SEQ'      	,type : 'string'},
             {name: 'YEAR_STD_FR_YYYY'      ,text:'UPDATE_DB_USER'  ,type : 'string'},
             {name: 'YEAR_STD_FR_MM'        ,text:'UPDATE_DB_TIME'  ,type : 'string'},
             {name: 'YEAR_STD_FR_DD'        ,text:'COMP_CODE'      	,type : 'string'},
             {name: 'YEAR_STD_TO_YYYY'      ,text:'지급방법'            ,type : 'string'},
             {name: 'YEAR_STD_TO_MM'        ,text:'급여기준일'           ,type : 'string'},
             {name: 'YEAR_STD_TO_DD'        ,text:'월차적치월'           ,type : 'string'},
             {name: 'YEAR_USE_FR_YYYY'      ,text:'월차적치월'           ,type : 'string'},
             {name: 'YEAR_USE_FR_MM'        ,text:'년차8할지급기준'       	,type : 'string'},
             {name: 'YEAR_USE_FR_DD'        ,text:'년차지급일수(10할)'    	,type : 'string'},
             {name: 'YEAR_USE_TO_YYYY'      ,text:'년차지급일수(8할)'     	,type : 'string'},
             {name: 'YEAR_USE_TO_MM'        ,text:'평균임금계산방식'      	,type : 'string'},
             {name: 'YEAR_USE_TO_DD'        ,text:'5일제여부'           ,type : 'string'},
             {name: 'DUTY_INPUT_RULE'       ,text:'5일제여부'           ,type : 'string'},
             {name: 'WEEK_CALCU_YN'         ,text:'5일제여부'           ,type : 'string'},
             {name: 'DAY_WORK_TIME'         ,text:'5일제여부'           ,type : 'string'},
             {name: 'LONG_WORK_DUTY_RULE'   ,text:'5일제여부'           ,type : 'string'},
             {name: 'YEAR_PROV_YYYY'        ,text:'5일제여부'           ,type : 'string'},
             {name: 'BUSI_SHARE_RATE'       ,text:'5일제여부'           ,type : 'float'},
             {name: 'EXTEND_WORK_YN'        ,text:'5일제여부'           ,type : 'string'},
             {name: 'FIVE_APPLY_DATE'       ,text:'5일제여부'           ,type : 'uniDate'},
             {name: 'TAX_CALCU_RULE'        ,text:'5일제여부'           ,type : 'string'},
             {name: 'BONUS_RETRAVG_FLAG'    ,text:'5일제여부'           ,type : 'string'},
             {name: 'WORKER_COMPEN_RATE'    ,text:'5일제여부'           ,type : 'float'},
             {name: 'HIR_CALCU_RULE'        ,text:'5일제여부'           ,type : 'string'},
             {name: 'INC_CALCU_RULE'     ,text:'5일제여부'           	,type : 'string'}
			]
	});
	
	var hbs020ukrs1FormStore = Unilite.createStore('hbs020ukrs1FormStore',{
		model: 'hbs020ukrs1FormModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },            
        proxy: {
            type: 'direct',
            api: {
            	   read : 'hbs020ukrService.selectList1'
            }
        },
        loadStoreRecords: function() {				
			this.load({
				success: function(response) {
					data = Ext.decode(response.responseText);
						console.log(data);
						var form = Ext.getCmp('hbs020ukrTab1').getForm();
						form.clearForm();
						//form.uniOpt.inLoading = true;
		            },
		            failure: function(response) {
		            	 //TODO : do something!
		            }
			});
		},
		submitForm: function(){
			var form = Ext.getCmp('hbs020ukrTab1').getForm();
			var param = form.getValues();
			console.log(param);
			Ext.getBody().mask('로딩중...','loading-indicator');
			form.submit({
				url: CPATH+'/human/hbs020ukrSubmitForm01.do',
				params: param,
				success:function(comp, action)	{
					Ext.getBody().unmask();
					UniAppManager.app.setToolbarButtons('save',false);
					hbs020ukrs1FormStore.reload();
					UniAppManager.updateStatus(Msg.sMB011);
					form.on({
						dirtychange: function(form, dirty, eOpts) {
							if (dirty) {
								UniAppManager.app.setToolbarButtons('save', true);
							} else {
								UniAppManager.app.setToolbarButtons('save', false);
							}
						}
					});
				},
				failure: function(form, action){
					Ext.getBody().unmask();
					UniAppManager.app.setToolbarButtons('save',false);
					hbs020ukrs1FormStore.reload();
					UniAppManager.updateStatus(Msg.sMB011);
					form.on({
						dirtychange: function(form, dirty, eOpts) {
							if (dirty) {
								UniAppManager.app.setToolbarButtons('save', true);
							} else {
								UniAppManager.app.setToolbarButtons('save', false);
							}
						}
					});
				}
			});
		},
        listeners: {
	        load: function(store, records) {
	            if (store.getCount() > 0) {
	            	var form = Ext.getCmp('hbs020ukrTab1').getForm(); //form.uniOpt.inLoading = false;
	            	form.loadRecord(records[0]); console.log(records);
	            	Ext.getCmp('yearCalc').setReadOnly(true);
	            	Ext.getCmp('yearCalc').setValue({YEAR_TYPE : '${yearCalculation}'});
	            	Ext.getCmp('rdo1').setValue({TAX_CALCU_RULE : records[0].data.TAX_CALCU_RULE});
					Ext.getCmp('rdo2').setValue({INC_CALCU_RULE : records[0].data.INC_CALCU_RULE});
					Ext.getCmp('rdo3').setValue({HIR_CALCU_RULE : records[0].data.HIR_CALCU_RULE});
					Ext.getCmp('rdo4').setValue({DUTY_INPUT_RULE : records[0].data.DUTY_INPUT_RULE});
					Ext.getCmp('rdo5').setValue({WEEK_CALCU_YN : records[0].data.WEEK_CALCU_YN});
					Ext.getCmp('rdo6').setValue({MONTH_CALCU_YN : records[0].data.MONTH_CALCU_YN});
					Ext.getCmp('rdo7').setValue({MENS_CALCU_YN : records[0].data.MENS_CALCU_YN});
					Ext.getCmp('rdo8').setValue({EARLY_PLAN_YN : records[0].data.EARLY_PLAN_YN});
					Ext.getCmp('rdo9').setValue({EXTEND_WORK_YN : records[0].data.EXTEND_WORK_YN});
					Ext.getCmp('rdo10').setValue({RETR_CALCU_RULE  : records[0].data.RETR_CALCU_RULE });
					Ext.getCmp('rdo11').setValue({BONUS_RETRAVG_FLAG : records[0].data.BONUS_RETRAVG_FLAG});

					form.on({
						dirtychange: function(form, dirty, eOpts) {
//							if (dirty) {
//								UniAppManager.app.setToolbarButtons('save', false);
//							} else {
//								UniAppManager.app.setToolbarButtons('save', false);
//							}
						}
					});
	            }
	        }
	    }           
	});
	
	var tab01ComboStore1 = Ext.create('Ext.data.Store', {
	    fields: ['value', 'name'],
	    data : [
	        {'value':'1', 'name':'2년전'},
	        {'value':'2', 'name':'전년도'},
	        {'value':'3', 'name':'당년도'}
	    ]
	});
	
	var tab01ComboStore2 = Ext.create('Ext.data.Store', {
	    fields: ['value', 'name'],
	    data : [	        
	        {'value':'2', 'name':'전년도'},
	        {'value':'3', 'name':'당년도'},
	        {'value':'4', 'name':'익년도'}
	    ]
	});
	
	Unilite.defineModel('hbs020ukrs1Model', {
	    fields: [
			 {name: 'MAIN_CODE'        		  ,text:'종합코드'         	,type : 'string'},
             {name: 'SUB_CODE'                ,text:'상세코드'         	,type : 'string'},
             {name: 'CODE_NAME'               ,text:'지급차수'         	,type : 'string', editable: false},
             {name: 'SYSTEM_CODE_YN'          ,text:'시스템'         		,type : 'string'},
             {name: 'REF_CODE1'               ,text:'근태집계마감일'      	,type : 'string', maxLength: 2, value: '00'},
             {name: 'REF_CODE2'               ,text:'급여집계마감일'        	,type : 'string', maxLength: 2, value: '00'},
             {name: 'REF_CODE3'               ,text:'관련3'            	,type : 'string'},
             {name: 'REF_CODE4'               ,text:'관련4'      			,type : 'string'},
             {name: 'REF_CODE5'               ,text:'관련5'      			,type : 'string'},
             {name: 'SUB_LENGTH'              ,text:'길이'            	,type : 'string'},
             {name: 'USE_YN'                  ,text:'USE_YN'         	,type : 'string'},
             {name: 'SORT_SEQ'                ,text:'SORT_SEQ'      	,type : 'string'},
             {name: 'UPDATE_DB_USER'          ,text:'UPDATE_DB_USER'  	,type : 'string'},
             {name: 'UPDATE_DB_TIME'          ,text:'UPDATE_DB_TIME'   	,type : 'string'},
             {name: 'COMP_CODE'               ,text:'COMP_CODE'      	,type : 'string'},
             
             {name: 'PAY_CODE'                ,text:'지급방법'            	,type : 'string', comboType: 'AU', comboCode: 'H028'},
             {name: 'PAY_DD'                  ,text:'급여기준일'           	,type : 'string'},
             {name: 'AMASS_NUM'               ,text:'월차적치월'           	,type : 'string'},
             {name: 'SAVE_MONTH_NUM'          ,text:'월차적치월'           	,type : 'string'},
             {name: 'ABSENCE_CNT'             ,text:'년차8할지급기준'       	,type : 'string'},
             {name: 'SUPP_YEAR_NUM_A'         ,text:'년차지급일수(10할)'    	,type : 'string'},
             {name: 'SUPP_YEAR_NUM_B'         ,text:'년차지급일수(8할)'     	,type : 'string'},
             {name: 'WAGES_TYPE'              ,text:'평균임금계산방식'      	,type : 'string', comboType: 'AU', comboCode: 'H055'},
             {name: 'FIVE_DAY_CHECK'          ,text:'5일제여부'           	,type : 'string'},
             {name: 'JOIN_MID_CHECK'          ,text:'5일제여부'           	,type : 'string'}
			]
	});	
	
	var directProxy1_1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList1_1',
		   update: 'hbs020ukrService.updateList1_1',
    	   syncAll : 'hbs020ukrService.saveAll1_1'
		}
	});
	
	var hbs020ukrsGrid1Store = Unilite.createStore('hbs020ukrsGrid1Store',{
			model: 'hbs020ukrs1Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },            
            proxy: directProxy1_1,
            loadStoreRecords: function() {				
    			this.load();
    		},
            saveStore : function()	{				
				this.syncAll();					
    		}
	});
	
	var directProxy1_2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList1_2',
		   update: 'hbs020ukrService.updateList1_2',
       	   syncAll : 'hbs020ukrService.saveAll1_2'
		}
	});
	var hbs020ukrsGrid2Store = Unilite.createStore('hbs020ukrsGrid2Store',{
			model: 'hbs020ukrs1Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },            
            proxy: directProxy1_2,
            loadStoreRecords: function() {
            	this.load();
    		},
            saveStore : function()	{
				this.syncAll();
    		}/*,
    		listeners: {
    			load: function(){
    				Ext.getBody().setPosition(0, 0);
    			}
    		}*/
	});
	
	//근태코드등록 모델
	Unilite.defineModel('hbs020ukrs2Model', {
	    fields: [
			    {name: 'MAIN_CODE'			,text: '종합코드'			,type : 'string', allowBlank: false},
	    		{name: 'SUB_CODE'			,text: '상세코드'			,type : 'string', allowBlank: false},
	    		{name: 'CODE_NAME_EN'		,text: '상세코드명'			,type : 'string'},
	    		{name: 'CODE_NAME_JP'		,text: '상세코드명'			,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text: '상세코드명'			,type : 'string'},
	    		{name: 'CODE_NAME'			,text: '상세코드명'			,type : 'string', allowBlank: false, maxLength: 30},
	    		{name: 'REF_CODE1'			,text: '연장근무구분'		,type: 'boolean', maxLength: 10},
	    		{name: 'REF_CODE2'			,text: '출력순서'			,type : 'int', maxLength: 10},
	    		{name: 'REF_CODE3'			,text: '연차여부'			,type : 'string', maxLength: 2},
	    		{name: 'REF_CODE4'			,text: '관련4'			,type : 'string', maxLength: 2},
	    		{name: 'REF_CODE5'			,text: '관련5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'			,text: '길이'				,type : 'string'},
	    		{name: 'USE_YN'				,text: '사용여부'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010', allowBlank: false, maxLength: 10},
	    		{name: 'SORT_SEQ'			,text: '정렬'				,type : 'int'},
	    		{name: 'SYSTEM_CODE_YN'		,text: '시스템'			,type : 'int'},
	    		{name: 'UPDATE_DB_USER'		,text: '수정자'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text: '수정일'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'			,text: 'COMP_CODE'		,type : 'string'}
			]
	});	
		
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList2',
    	   create: 'hbs020ukrService.insert2',
     	   update: 'hbs020ukrService.update2',
     	   destroy: 'hbs020ukrService.delete2',
       	   syncAll : 'hbs020ukrService.saveAll2'
		}
	});
	 
	//근태코드등록 스토어
	var hbs020ukrs2Store = Unilite.createStore('hbs020ukrs2Store',{
			model: 'hbs020ukrs2Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy2,
            loadStoreRecords: function() {				
            	var param= { MAIN_CODE : 'H033'};    			
    			this.load({
    				params: param
    			});
    		},
            saveStore : function()	{				
				this.syncAll();					
    		}
	});
	
	//근태기준등록 모델
	Unilite.defineModel('hbs020ukrs3Model', {
	    fields: [
			    {name: 'PAY_CODE'      			,text: '급여지급방식'	,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H028', allowBlank: false},
		    	{name: 'DUTY_CODE'     			,text: '근태코드'		,type : 'string',  xtype: 'uniCombobox', comboType: 'A', comboCode: 'H033', allowBlank: false},
		    	{name: 'DUTY_TYPE'     			,text: '근태구분'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H050'},
		    	{name: 'COTR_TYPE'     			,text: '관리구분'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H040', allowBlank: false},
		    	{name: 'DUTY_STRT_MM'  			,text: '시작월'		,type : 'string'},
		    	{name: 'DUTY_STRT_DD'  			,text: '시작일'		,type : 'string'},
		    	{name: 'DUTY_LAST_MM'  			,text: '종료월'		,type : 'string'},
		    	{name: 'DUTY_LAST_DD'  			,text: '종료일'		,type : 'string'},
	    		{name: 'MARGIR_TYPE'   			,text: '기본급차감'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H160'},
		    	{name: 'MONTH_REL_CODE'			,text: '월차'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H160'},
		    	{name: 'YEAR_REL_CODE' 			,text: '년차'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H160'},
		    	{name: 'MENS_REL_CODE' 			,text: '보건'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H160'},
		    	{name: 'WEEK_REL_CODE' 			,text: '주차'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H160'},
		    	{name: 'FULL_REL_CODE' 			,text: '만근'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H160'}
			]
	});	
	
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
    	   read : 'hbs020ukrService.selectList3',
    	   create: 'hbs020ukrService.insert3', 
     	   update: 'hbs020ukrService.update3',
     	   destroy: 'hbs020ukrService.delete3',
     	   syncAll : 'hbs020ukrService.saveAll3'
        }
	});
	
	//근태기준등록 스토어
	var hbs020ukrs3Store = Unilite.createStore('hbs020ukrs3Store',{
			model: 'hbs020ukrs3Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy3,
            loadStoreRecords: function() {
            	var param1 = Ext.getCmp('PAY_CODE3').getValue();
            	var param2 = Ext.getCmp('DUTY_CODE3').getValue();
            	var param= { PAY_CODE : param1, DUTY_CODE : param2};    			
    			this.load({
    				params: param
    			});    		
    		},
            saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			if(inValidRecs.length == 0 )	{
    				this.syncAll();					
    			}else {
    				panelDetail.down('#uniGridPanel3').uniSelectInvalidColumnAndAlert(inValidRecs);
    			}
    		}
	});
	
	//휴무별근무시간 등록 모델
	Unilite.defineModel('hbs020ukrs4Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text: '종합코드'		,type : 'string'},
	    		{name: 'SUB_CODE'				,text: '상세코드'		,type : 'string', allowBlank: false},
	    		{name: 'CODE_NAME'				,text: '상세코드명'		,type : 'string', allowBlank: false},
	    		{name: 'CODE_NAME_EN'			,text: '상세코드명', editable:false		,type : 'string'},
	    		{name: 'CODE_NAME_CN'			,text: '상세코드명', editable:false		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text: '상세코드명', editable:false		,type : 'string'},
	    		{name: 'REF_CODE1'				,text: '근무시간'		,type : 'int', maxLength: 2},
	    		{name: 'REF_CODE2'				,text: '관련2'		,type : 'string'},
	    		{name: 'REF_CODE3'				,text: '관련3'		,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text: '길이'			,type : 'string'},
	    		{name: 'USE_YN'					,text: '사용여부'		,type : 'string'},
	    		{name: 'SORT_SEQ'				,text: '정렬'			,type : 'int'},
	    		{name: 'SYSTEM_CODE_YN'			,text: '시스템'		,type : 'int'},
	    		{name: 'UPDATE_DB_USER'			,text: '수정자'		,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'			,text: '수정일'		,type : 'uniDate'}
	    	]
	});	
	
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList4',
    	   update: 'hbs020ukrService.update2',
    	   syncAll : 'hbs020ukrService.saveAll4'    	   
		}
	});
	
	//휴무별근무시간 등록 스토어
	var hbs020ukrs4Store = Unilite.createStore('hbs020ukrs4Store',{
		model: 'hbs020ukrs4Model',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },            
        proxy: directProxy4,
        loadStoreRecords: function() {				
        	var param= { MAIN_CODE : 'H003'};    			
			this.load({
				params: param
			});
		},
        saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				this.syncAll();					
			}/*else {
				panelDetail.down('#uniGridPanel4').uniSelectInvalidColumnAndAlert(inValidRecs);
			}*/
		}
	});
	//달력정보등록 모델
	Unilite.defineModel('hbs020ukrs5Model', {
	    fields: [
			    {name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''},
	    		{name: ''			,text: ''		,type : ''}
			]
	});	
	//달력정보등록 스토어
	var hbs020ukrs5Store = Unilite.createStore('hbs020ukrs5Store',{
			model: 'hbs020ukrs5Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hbs020ukrService.selectList5'
                }
            }
	});
	//근무조등록 모델
	Unilite.defineModel('hbs020ukrs6Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'종합코드'		,type : 'string'},
	    		{name: 'SUB_CODE'				,text:'상세코드'		,type : 'string', allowBlank: false},
	    		{name: 'CODE_NAME'				,text:'상세코드명'		,type : 'string', allowBlank: false, maxLength: 30},
	    		{name: 'CODE_NAME_EN'			,text:'상세코드명'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'			,text:'상세코드명'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'상세코드명'		,type : 'string'},
	    		{name: 'REF_CODE1'				,text:'관련1'			,type : 'string', maxLength: 10},
	    		{name: 'REF_CODE2'				,text:'출력순서'		,type : 'string', maxLength: 10},
	    		{name: 'REF_CODE3'				,text:'관련3'			,type : 'string', maxLength: 10},
	    		{name: 'REF_CODE4'				,text:'관련4'			,type : 'string'},
	    		{name: 'REF_CODE5'				,text:'롼련5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'길이'			,type : 'string'},
	    		{name: 'USE_YN'					,text:'사용여부'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'A004', allowBlank: false},
	    		{name: 'SORT_SEQ'				,text:'정렬'			,type : 'int'},
	    		{name: 'SYSTEM_CODE_YN'			,text:'시스템'		,type : 'int', maxLength: 1},
	    		{name: 'UPDATE_DB_USER'			,text:'수정자'		,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'			,text:'수정일'		,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'법인코드'		,type : 'string'}
			]
	});	
	
	var directProxy6 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read : 'hbs020ukrService.selectList4',
       		create: 'hbs020ukrService.insert2',
      	   	update: 'hbs020ukrService.update2',
      	   	destroy: 'hbs020ukrService.delete2',
      	   	syncAll : 'hbs020ukrService.saveAll6'
		}
	});	
	//근무조등록 스토어
	var hbs020ukrs6Store = Unilite.createStore('hbs020ukrs6Store',{
			model: 'hbs020ukrs6Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy6,
            loadStoreRecords: function() {				
            	var param= { MAIN_CODE : 'H004'};    			
    			this.load({
    				params: param
    			});
    		},
            saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			if(inValidRecs.length == 0 )	{
    				this.syncAll();					
    			}else {
    				panelDetail.down('#uniGridPanel6').uniSelectInvalidColumnAndAlert(inValidRecs);
    			}
    		}     
	});
	//근무시간등록 모델1
	Unilite.defineModel('hbs020ukrs7Model', {
	    fields: [
			    {name: 'WORK_TEAM'				,text:'근무조'		,type : 'string', comboType:'A', comboCode:'H004', allowBlank: false},
//		    	{name: 'PAY_CODE'				,text:'지급구분'		,type : 'string', comboType:'AU', comboCode:'H028', allowBlank: false},
	    		{name: 'HOLY_TYPE'				,text:'휴무구분'		,type : 'string', comboType:'A', comboCode:'H003', allowBlank: false},
//	    		{name: 'DUTY_CODE'				,text:'근태구분'		,type : 'string', comboType:'AU', comboCode:'H033', allowBlank: false},
				{name: 'DUTY_FR_D'				,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002', allowBlank: false},
	    		{name: 'DUTY_FR_H'				,text:'시'			,type : 'string', allowBlank: false},
	    		{name: 'DUTY_FR_M'				,text:'분'			,type : 'string', allowBlank: false},
	    		{name: 'DUTY_TO_D'				,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002', allowBlank: false},
	    		{name: 'DUTY_TO_H'				,text:'시'			,type : 'string', allowBlank: false},
	    		{name: 'DUTY_TO_M'   			,text:'분'			,type : 'string', allowBlank: false},
	    		{name: 'REST_FR_D_01'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
	    		{name: 'REST_FR_H_01'			,text:'시'			,type : 'string'},
	    		{name: 'REST_FR_M_01'			,text:'분'			,type : 'string'},
	    		{name: 'REST_TO_D_01'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
	    		{name: 'REST_TO_H_01'			,text:'시'			,type : 'string'},
	    		{name: 'REST_TO_M_01'			,text:'분'			,type : 'string'},
	    		{name: 'REST_FR_D_02'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
	    		{name: 'REST_FR_H_02'			,text:'시'			,type : 'string'},
	    		{name: 'REST_FR_M_02'			,text:'분'			,type : 'string'},
	    		{name: 'REST_TO_D_02'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
		    	{name: 'REST_TO_H_02'			,text:'시'			,type : 'string'},
		    	{name: 'REST_TO_M_02'			,text:'분'			,type : 'string'},
		    	{name: 'REST_FR_D_03'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
		    	{name: 'REST_FR_H_03'			,text:'시'			,type : 'string'},
		    	{name: 'REST_FR_M_03'			,text:'분'			,type : 'string'},
		    	{name: 'REST_TO_D_03'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
	    		{name: 'REST_TO_H_03'			,text:'시'			,type : 'string'},
	    		{name: 'REST_TO_M_03'			,text:'분'			,type : 'string'},
	    		{name: 'REST_FR_D_04'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
	    		{name: 'REST_FR_H_04'			,text:'시'			,type : 'string'},
	    		{name: 'REST_FR_M_04'			,text:'분'			,type : 'string'},
	    		{name: 'REST_TO_D_04'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
	    		{name: 'REST_TO_H_04'			,text:'시'			,type : 'string'},
	    		{name: 'REST_TO_M_04'			,text:'분'			,type : 'string'}
			]                                        
	});	        
	
	//근무시간등록 모델
	Unilite.defineModel('hbs020ukrs7_1Model', {
	    fields: [
			    {name: 'WORK_TEAM'				,text:'근무조'		,type : 'string', comboType:'AU', comboCode:'H004', allowBlank: false},
		    	{name: 'PAY_CODE'				,text:'지급구분'		,type : 'string', comboType:'A', comboCode:'H028', allowBlank: false},
	    		{name: 'HOLY_TYPE'				,text:'휴무구분'		,type : 'string', comboType:'AU', comboCode:'H003', allowBlank: false},
	    		{name: 'DUTY_CODE'				,text:'근태구분'		,type : 'string', comboType:'AU', comboCode:'H033', allowBlank: false},
				{name: 'DUTY_FR_D'				,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002', allowBlank: false},
	    		{name: 'DUTY_FR_H'				,text:'시'			,type : 'string', allowBlank: false},
	    		{name: 'DUTY_FR_M'				,text:'분'			,type : 'string', allowBlank: false},
	    		{name: 'DUTY_TO_D'				,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002', allowBlank: false},
	    		{name: 'DUTY_TO_H'				,text:'시'			,type : 'string', allowBlank: false},
	    		{name: 'DUTY_TO_M'   			,text:'분'			,type : 'string', allowBlank: false},
	    		{name: 'REST_FR_D_01'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
	    		{name: 'REST_FR_H_01'			,text:'시'			,type : 'string'},
	    		{name: 'REST_FR_M_01'			,text:'분'			,type : 'string'},
	    		{name: 'REST_TO_D_01'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
	    		{name: 'REST_TO_H_01'			,text:'시'			,type : 'string'},
	    		{name: 'REST_TO_M_01'			,text:'분'			,type : 'string'},
	    		{name: 'REST_FR_D_02'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
	    		{name: 'REST_FR_H_02'			,text:'시'			,type : 'string'},
	    		{name: 'REST_FR_M_02'			,text:'분'			,type : 'string'},
	    		{name: 'REST_TO_D_02'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
		    	{name: 'REST_TO_H_02'			,text:'시'			,type : 'string'},
		    	{name: 'REST_TO_M_02'			,text:'분'			,type : 'string'},
		    	{name: 'REST_FR_D_03'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
		    	{name: 'REST_FR_H_03'			,text:'시'			,type : 'string'},
		    	{name: 'REST_FR_M_03'			,text:'분'			,type : 'string'},
		    	{name: 'REST_TO_D_03'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
	    		{name: 'REST_TO_H_03'			,text:'시'			,type : 'string'},
	    		{name: 'REST_TO_M_03'			,text:'분'			,type : 'string'},
	    		{name: 'REST_FR_D_04'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
	    		{name: 'REST_FR_H_04'			,text:'시'			,type : 'string'},
	    		{name: 'REST_FR_M_04'			,text:'분'			,type : 'string'},
	    		{name: 'REST_TO_D_04'			,text:'일'			,type : 'string', comboType:'AU', comboCode:'H002'},
	    		{name: 'REST_TO_H_04'			,text:'시'			,type : 'string'},
	    		{name: 'REST_TO_M_04'			,text:'분'			,type : 'string'}
			]                                        
	});	           
	
	
	var directProxy7 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
			   create : 'hbs020ukrService.insertList7',
        	   read : 'hbs020ukrService.selectList7',
        	   update : 'hbs020ukrService.updateList7',
        	   destroy : 'hbs020ukrService.deleteList7',
        	   syncAll : 'hbs020ukrService.saveAll7'
			}
	 });
	 
	//근무시간등록 스토어1
	var hbs020ukrs7Store = Unilite.createStore('hbs020ukrs7Store',{
			model: 'hbs020ukrs7Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy7,
            loadStoreRecords: function() {
       			this.load();	
    		},
    		listeners: {
    			load: function() {
    				if (this.getCount() > 0) {
    	              	UniAppManager.setToolbarButtons('delete', true);
   	                } else {
   	              	  	UniAppManager.setToolbarButtons('delete', false);
   	                }  
    			}
    		},
            saveStore : function()	{				
    			var inValidRecs1 = this.getInvalidRecords();
    			var inValidRecs2 = hbs020ukrs7_1Store.getInvalidRecords();
    			if(inValidRecs1.length == 0 && inValidRecs2.length == 0 )	{
    				config = {
						success: function(batch, option) {
							UniAppManager.setToolbarButtons('save', false);
							hbs020ukrs7_1Store.saveStore();							
						 }
					}
    				this.syncAll(config);					
    			}else {
    				if(inValidRecs1.length != 0){
    					Ext.getCmp('dutyTimeGrid01').uniSelectInvalidColumnAndAlert(inValidRecs1);
    				}else if(inValidRecs2.length != 0){
    					Ext.getCmp('dutyTimeGrid02').uniSelectInvalidColumnAndAlert(inValidRecs2);
    				}
    			}
    		}
	});
	
	var directProxy7_1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
			   create : 'hbs020ukrService.insertList7_1',
        	   read : 'hbs020ukrService.selectList7_1',
        	   update : 'hbs020ukrService.updateList7_1',
        	   destroy : 'hbs020ukrService.deleteList7_1',
        	   syncAll : 'hbs020ukrService.saveAll7_1'
			}
	 });
	 
	//근무시간등록 스토어2
	var hbs020ukrs7_1Store = Unilite.createStore('hbs020ukrs7_1Store',{
			model: 'hbs020ukrs7_1Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },            
            proxy: directProxy7_1,
            loadStoreRecords: function() {
       			this.load();	
    		},
            saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			if(inValidRecs.length == 0 )	{
    				config = {
						success: function(batch, option) {
							UniAppManager.setToolbarButtons('save', false); 
						 }
					}
    				this.syncAll(config);
    			}else {
    				Ext.getCmp('dutyTimeGrid02').uniSelectInvalidColumnAndAlert(inValidRecs);
    			}
    		},
    		listeners: {
    			load: function() {
    				if (this.getCount() > 0) {
    	              	UniAppManager.setToolbarButtons('delete', true);
   	                } else {
   	              	  	UniAppManager.setToolbarButtons('delete', false);
   	                }  
    			}
    		}           
	});
	
	// 년월차기준등록 모델
	Unilite.defineModel('hbs020ukrs8Model', {
	    fields: [
			    {name: 'PAY_CODE'         			,text:'지급방법'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H028', allowBlank: false, maxLength: 1},
	    		{name: 'PAY_DD'						,text:'지급일자'			,type : 'string', maxLength: 2},
	    		{name: 'AMASS_NUM'					,text:'월차발생 기준월'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H041', allowBlank: false, maxLength: 2},
	    		{name: 'SAVE_MONTH_NUM'				,text:'월차지급 잔여월차'		,type : 'int', allowBlank: true, maxLength: 1},
	    		{name: 'ABSENCE_CNT'				,text:'8할 발생기준'		,type : 'int', allowBlank: true, maxLength: 3},
	    		{name: 'SUPP_YEAR_NUM_B'			,text:'8할 발생일수'		,type : 'int', allowBlank: true, maxLength: 2},
	    		{name: 'SUPP_YEAR_NUM_A'			,text:'10할 발생일수'		,type : 'int', allowBlank: true, maxLength: 2},
	    		{name: 'WAGES_TYPE'					,text:'평균임금 계산방식'		,type : 'int'},
	    		{name: 'FIVE_DAY_CHECK'				,text:'5일제유무'			,type : 'boolean'},
	    		{name: 'JOIN_MID_CHECK'				,text:'중도입사생성유무'		,type : 'boolean'}
			]
	});	
	var directProxy8 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
    	   read : 'hbs020ukrService.selectList8',
    	   create: 'hbs020ukrService.insert8',
           update: 'hbs020ukrService.update8',
           destroy: 'hbs020ukrService.delete8',
     	   syncAll : 'hbs020ukrService.saveAll8'
        }
	});
	
	// 년월차기준등록 스토어
	var hbs020ukrs8Store = Unilite.createStore('hbs020ukrs8Store',{
			model: 'hbs020ukrs8Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy8,
            loadStoreRecords: function() {            	    			
    			this.load();
    		},
    		saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			if(inValidRecs.length == 0 )	{
    				config = {
						success: function(batch, option) {		
//							UniAppManager.setToolbarButtons('save', false);								
//							hbs030ukrs5Store.loadStoreRecords();	
						 } 
					};	
    				this.syncAll(config);					
    			}else {
    				panelDetail.down('#uniGridPanel8').uniSelectInvalidColumnAndAlert(inValidRecs);
    			} 
            }
	});
	 Ext.create('Ext.data.Store', {
		storeId:"includeCombo",
	    fields: ['text', 'value'],
	    data : [
	        {text:"포함한다",   value:"Y"},
	        {text:"포함안한다", 	value:"N"}
	    ]
	});
	var directProxy9_2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
			   read : 'hbs020ukrService.selectList9sub2',
        	   create: 'hbs020ukrService.insert9sub2',
               update: 'hbs020ukrService.update9sub2',
               destroy: 'hbs020ukrService.delete9sub2',
        	   syncAll : 'hbs020ukrService.saveAll9_2'
			}
	 });
	 var directProxy9_3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
			   read : 'hbs020ukrService.selectList9sub1',
        	   create: 'hbs020ukrService.insert9sub3',
               update: 'hbs020ukrService.update9sub3',
               destroy: 'hbs020ukrService.delete9sub3',
        	   syncAll : 'hbs020ukrService.saveAll9_3'
			}
	 });
	// 수당기준설정 - 지급/공제코드 등록 모델1	-	기타
	Unilite.defineModel('hbs020ukrs9_1Model', {
	    fields: [
			    {name: 'MAIN_CODE'      	 	,text:'코드구분'			,type : 'string', editable: false},
	    		{name: 'SUB_CODE'      		,text:'상세코드'			,type : 'string', editable: false},
	    		{name: 'CODE_NAME'      		,text:'상세코드명'		,type : 'string', editable: false},
	    		{name: 'CODE_NAME_EN'      	,text:'상세코드명'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'       ,text:'상세코드명'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'     	,text:'상세코드명'		,type : 'string'},
	    		{name: 'REF_CODE1'				,text:'비과세한도금액'	,type : 'string'},
	    		{name: 'REF_CODE1'        		,text:'고용보험'			,type : 'string'},
	    		{name: 'REF_CODE1'    			,text:'월정급여'			,type : 'string'},
	    		{name: 'REF_CODE1'     	 	,text:'평균임금'			,type : 'string'},
	    		{name: 'REF_CODE1'         	,text:'비과세코드'		,type : 'string'},
	    		{name: 'SUB_LENGTH'    		,text:'자료제출'			,type : 'string'},
	    		{name: 'USE_YN'       			,text:'출력순서'			,type : 'string'},
	    		{name: 'SORT_SEQ'       		,text:'계산순서'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'   ,text:'정열순서'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'    	,text:'사용여부'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'    	,text:'사용여부'			,type : 'string'},
	    		{name: 'COMP_CODE'          	,text:'사용여부'			,type : 'string'}
			]
	});
	// 수당기준설정 - 지급/공제코드 등록 모델2	-	지급내역
	Unilite.defineModel('hbs020ukrs9_2Model', {
	    fields: [
			    {name: 'CODE_TYPE'     	  		,text:'코드구분'			,type : 'string'},
	    		{name: 'WAGES_CODE'      		,text:'코드'				,type : 'string', allowBlank: false},
	    		{name: 'WAGES_NAME'      		,text:'코드명'			,type : 'string', maxLength: 30, allowBlank: false},
	    		{name: 'WAGES_KIND'      		,text:'수당구분'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H042', allowBlank: false},
	    		{name: 'TAX_CODE'        		,text:'과세구분'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H030', allowBlank: false},
	    		{name: 'INCOME_KIND'     		,text:'근로소득구분'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H170'},
	    		{name: 'TAX_AMOUNT_LMT_I'		,text:'비과세한도금액'		,type : 'uniPrice'},
	    		{name: 'EMP_TYPE'        		,text:'고용보험'			,type : 'string',store: Ext.data.StoreManager.lookup('includeCombo')},
	    		{name: 'MED_TYPE'        		,text:'건강보험'			,type : 'string',store: Ext.data.StoreManager.lookup('includeCombo')},
	    		{name: 'COM_PAY_TYPE'    		,text:'월정급여'			,type : 'string',store: Ext.data.StoreManager.lookup('includeCombo')},
	    		{name: 'RETR_WAGES'      		,text:'평균임금'			,type : 'string',store: Ext.data.StoreManager.lookup('includeCombo')},	    		
	    		{name: 'RETR_BONUS'         	,text:'상여성퇴직금'		,type : 'string',store: Ext.data.StoreManager.lookup('includeCombo')},
	    		{name: 'ORD_WAGES'         		,text:'통상임금'			,type : 'string',store: Ext.data.StoreManager.lookup('includeCombo')},
	    		{name: 'NON_TAX_CODE'    		,text:'비과세코드'			,type : 'string'},	    		
	    		{name: 'SEND_YN'         		,text:'자료제출'			,type : 'string',store: Ext.data.StoreManager.lookup('includeCombo')},	    			    		
	    		{name: 'WAGES_SEQ'       		,text:'순번'				,type : 'int'},
	    		{name: 'CALCU_SEQ'       		,text:'계산순서'			,type : 'int'},
	    		{name: 'PRINT_SEQ'       		,text:'출력순서'			,type : 'int'},	    		
	    		{name: 'SORT_SEQ'        		,text:'정렬순서'			,type : 'int'},
	    		{name: 'USE_YN'          		,text:'사용여부'			,type : 'string',comboType: 'AU', comboCode: 'B010', allowBlank: false}
			]
	});
	// 수당기준설정 - 지급/공제코드 등록 모델3	-	공제내역
	Unilite.defineModel('hbs020ukrs9_3Model', {
	    fields: [
			    {name: 'MAIN_CODE'      	 ,text:'코드구분'		,type : 'string'},
	    		{name: 'SUB_CODE'      		,text:'상세코드'		,type : 'string', allowBlank: false},
	    		{name: 'CODE_NAME'      	,text:'상세코드명'		,type : 'string', allowBlank: false, maxLength: 30},
	    		{name: 'CODE_NAME_EN'      	,text:'상세코드명'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'       ,text:'상세코드명'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'     	,text:'상세코드명'		,type : 'string'}, 
	    		{name: 'REF_CODE1'			,text:'계산순서'		,type : 'string'},
	    		{name: 'REF_CODE2'        	,text:'출력순서'		,type : 'string'},
	    		{name: 'REF_CODE3'    		,text:'기부금'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H119'},
	    		{name: 'REF_CODE4'     	 	,text:''			,type : 'string'},
	    		{name: 'REF_CODE5'         	,text:''			,type : 'string'},
	    		{name: 'SUB_LENGTH'    		,text:''			,type : 'string'},
	    		{name: 'USE_YN'       		,text:'사용여부'		,type : 'string',comboType: 'AU', comboCode: 'B010', allowBlank: false},
	    		{name: 'SORT_SEQ'       	,text:'계산순서'		,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'   	,text:'정열순서'		,type : 'string'},
	    		{name: 'UPDATE_DB_USER'    	,text:'사용자'		,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'    	,text:'수정시간'		,type : 'string'},
	    		{name: 'COMP_CODE'          ,text:''			,type : 'string'}
			]
	});
	
	// 수당기준설정 - 지급/공제코드 등록 스토어1
	var hbs020ukrs9_1Store = Unilite.createStore('hbs020ukrs9_1Store',{
		model: 'hbs020ukrs9_1Model',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable: true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        
        proxy: {
            type: 'direct',
            api: {
            	   read : 'hbs020ukrService.selectList9sub1'
            }
        },
        loadStoreRecords: function() {
        	var param= { MAIN_CODE : 'H035'};    			
			this.load({
				params: param
			});
		}
	});
	// 수당기준설정 - 지급/공제코드 등록 스토어2 	-	지급내역
	var hbs020ukrs9_2Store = Unilite.createStore('hbs020ukrs9_2Store',{
		model: 'hbs020ukrs9_2Model',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable: true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        
        proxy: directProxy9_2,
        loadStoreRecords: function() {            	    			
			this.load();
		},
		saveStore : function(selectTab)	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				config = {
					success: function(batch, option) {		
//						if(hbs020ukrs9_3Store.isDirty()){
//							UniAppManager.app.setToolbarButtons('save', true);
//						}
						if(selectTab){
							panelDetail.down('#hbs020ukrPanel9').setActiveTab(selectTab);								
						}
					} 
				};	
				this.syncAll(config);					
			}else {
				panelDetail.down('hbs020ukrPanel9').setActiveTab(selectTab);
			} 
        }
	});
	// 수당기준설정 - 지급/공제코드 등록 스토어3	-	공제내역
	var hbs020ukrs9_3Store = Unilite.createStore('hbs020ukrs9_3Store',{
		model: 'hbs020ukrs9_3Model',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable: true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        
        proxy: directProxy9_3,
        loadStoreRecords: function() {            	    			
        	var param= { MAIN_CODE : 'H034'};    			
			this.load({
				params: param
			});
		},
		saveStore : function(selectTab)	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				config = {
					success: function(batch, option) {		
//						if(hbs020ukrs9_2Store.isDirty()){
//							UniAppManager.app.setToolbarButtons('save', true);
//						}
						if(selectTab){
							panelDetail.down('#hbs020ukrPanel9').setActiveTab(selectTab);							
						}
					 } 
				};	
				this.syncAll(config);					
			}else {
				panelDetail.down('#uniGridPanel9_3').uniSelectInvalidColumnAndAlert(inValidRecs);
			} 
        }
	});
	
	
	// 수당기준설정 - 입/퇴사자 지급기준등록 모델
	Unilite.defineModel('hbs020ukrs10Model', {
	    fields: [
			    {name: 'PAY_CODE'			,text:'급여지급방식'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H028', allowBlank: false},
	    		{name: 'PAY_PROV_FLAG'		,text:'지급차수'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H031', allowBlank: false},
	    		{name: 'EXCEPT_TYPE'		,text:'입퇴사구분'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H048', allowBlank: false},
	    		{name: 'WAGES_CODE'			,text:'수당코드'			,type : 'string', store: Ext.data.StoreManager.lookup('wagesList'), allowBlank: false},
	    		{name: 'WORK_DAY'			,text:'근무일수'			,type : 'string', allowBlank: false},
	    		{name: 'PROV_YN'			,text:'지급여부'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'A020', allowBlank: false},
	    		{name: 'DAILY_YN'			,text:'일할계산여부'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'A020', allowBlank: false}
			]
	});	
	
	var directProxy10 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList10',
    	   create: 'hbs020ukrService.insert10',
           update: 'hbs020ukrService.update10',
           destroy: 'hbs020ukrService.delete10',
    	   syncAll : 'hbs020ukrService.saveAll10'
		}
	 });
	// 수당기준설정 - 입/퇴사자 지급기준등록 스토어
	var hbs020ukrs10Store = Unilite.createStore('hbs020ukrs10Store',{
			model: 'hbs020ukrs10Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy10,
            loadStoreRecords: function() {
				var param1 = Ext.getCmp('PAY_CODE').getValue();
				var param2 = Ext.getCmp('PAY_PROV_FLAG').getValue();
				var param3 = Ext.getCmp('EXCEPT_TYPE').getValue();
            	var param= { PAY_CODE : param1, PAY_PROV_FLAG : param2, EXCEPT_TYPE : param3};            	
    			this.load({
    				params: param
    			});
    		},
			saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {		
							
						 } 
					};	
					this.syncAll(config);					
				}else {
					panelDetail.down('#uniGridPanel10').uniSelectInvalidColumnAndAlert(inValidRecs);
				} 
	        }
	});
	// 수당기준설정 - 급호봉등록 모델
	Unilite.defineModel('hbs020ukrs11Model', {
	    fields: fieldsTab11
	});	
	
	var directProxy11 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList11',
    	   create : 'hbs020ukrService.insertList11',
    	   update : 'hbs020ukrService.updateList11',
    	   destroy : 'hbs020ukrService.deleteList11',
    	   syncAll : 'hbs020ukrService.saveAll11'
		}
	 });
	// 수당기준설정 - 급호봉등록 스토어
	var hbs020ukrs11Store = Unilite.createStore('hbs020ukrs11Store',{
			model: 'hbs020ukrs11Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },            
            proxy: directProxy11,
            listeners: {
            	load: function () {
            		if (this.getCount() > 0) {
    	              	UniAppManager.setToolbarButtons('delete', true);
    	              	UniAppManager.setToolbarButtons('excel',true);
    	              } else {
   	              	  	UniAppManager.setToolbarButtons('delete', false);
   	              		UniAppManager.setToolbarButtons('excel',false);
    	              }            
            	}
            },
			saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {		
							
						 } 
					};	
					this.syncAll(config);					
				}else {
					panelDetail.down('#payGradeGrid').uniSelectInvalidColumnAndAlert(inValidRecs);
				} 
	        },
            loadStoreRecords: function() {
    			var pay_grade_01 = Ext.getCmp('PAY_GRADE_01').getValue();
    			var pay_grade_02 = Ext.getCmp('PAY_GRADE_02').getValue();
    			var param= { PAY_GRADE_01 : pay_grade_01, PAY_GRADE_02 : pay_grade_02 };
       			console.log( param );
       			this.load({
       				params: param
       			});	
    		}            
	});
	
	// 수당기준설정 - 연봉등록 모델
	Unilite.defineModel('hbs020ukrs12Model', {
	    fields: [
			    {name: 'CHOICE'						,text:'선택'				,type : 'boolean'},
	    		{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string'},
	    		{name: 'YEAR_YYYY'					,text:'관련년도'			,type : 'string'},
	    		{name: 'PERSON_NUMB'				,text:'사번'				,type : 'string', allowBlank: false},
	    		{name: 'NAME'						,text:'성명'				,type : 'string', allowBlank: false},
	    		{name: 'DEPT_CODE'					,text:'부서'				,type : 'string'},
	    		{name: 'DEPT_NAME'					,text:'부서명'			,type : 'string'},
	    		{name: 'ANNUAL_SALARY_I'			,text:'연봉'				,type : 'uniPrice'},
	    		{name: 'WAGES_STD_I'				,text:'기본급'			,type : 'uniPrice'},
	    		{name: 'PAY_PRESERVE_I'				,text:'보전수당'			,type : 'uniPrice'}
			]
	});	
	// 수당기준설정 - 연봉등록 : excelUpload 연봉정보 모델
	Unilite.defineModel('excel.hbs020.sheet01', {
	    fields: [
	    		{name: 'PERSON_NUMB'				,text:'사번'				,type : 'string'},
	    		{name: 'ANNUAL_SALARY_I'			,text:'연봉'				,type : 'uniPrice'},
	    		{name: 'WAGES_STD_I'				,text:'기본급'				,type : 'uniPrice'}
			]
	});	
	
	var directProxy12 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   create: 'hbs020ukrService.insertList12',	
    	   read : 'hbs020ukrService.selectList12',
    	   update:'hbs020ukrService.updateList12',
    	   destroy: 'hbs020ukrService.deleteList12',
    	   syncAll : 'hbs020ukrService.saveAll12'
		}
	 });
	// 수당기준설정 - 연봉등록 연봉정보 스토어
	var hbs020ukrs12Store = Unilite.createStore('hbs020ukrs12Store',{
			model: 'hbs020ukrs12Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
            	allDeletable: true,		//전체삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy12,
            loadStoreRecords: function() {
//             	var param= Ext.getCmp('hbs020ukrTab12').getValues();
				var param= Ext.getCmp('hbs020ukrTab12_inner').getValues();
    			console.log( param );
    			this.load({
    				params : param
    			});
    		},
			saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {		
							UniAppManager.setToolbarButtons('save', false);
							UniAppManager.app.onQueryButtonDown();
						 } 
					};	
					this.syncAll(config);					
				}else {
					panelDetail.down('#hbs020ukrs12Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				} 
	        },
            listeners: {
    	        load: function(store, records) {
    	        	Ext.getCmp('btnAllSelect').setText('전체선택');
//    	        	UniAppManager.setToolbarButtons('newData',true);
//    	        	UniAppManager.setToolbarButtons('save', false);
    	        	if (store.getCount() == 0) {
    	            	Ext.getCmp('initButton').setDisabled(false);
    	            } 
    	        }
    	    }       
	});
	
	var directProxy13 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList13',
    	   create: 'hbs020ukrService.insert13',
     	   update: 'hbs020ukrService.update13',
     	   destroy: 'hbs020ukrService.delete13',
    	   syncAll : 'hbs020ukrService.saveAll13'
		}
	 });
	// 수당기준설정 - 부서별요율등록 모델
	Unilite.defineModel('hbs020ukrs13Model', {
	    fields: [
			    {name: 'COMP_CODE'			,text:'COMP_CODE'			,type : 'string'},
	    		{name: 'TREE_CODE'			,text:'부서코드'				,type : 'string', allowBlank: false, maxLength: 3},	    		
	    		{name: 'TREE_NAME'			,text:'부서명'				,type : 'string', allowBlank: false, maxLength: 20},
	    		{name: 'DEPART_RATE'		,text:'부서요율'				,type : 'uniPercent', maxLength: 6},
	    		{name: 'SUPP_TYPE'			,text:'지급구분'				,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'UPDATE_DB_USER'		,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'UPDATE_DB_TIME'		,type : 'string'}
			]
	});	
	// 수당기준설정 - 부서별요율등록 스토어
	var hbs020ukrs13Store = Unilite.createStore('hbs020ukrs13Store',{
			model: 'hbs020ukrs13Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,		// 삭제 가능 여부 
            	allDeletable: true,		//전체삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy13,
            loadStoreRecords: function() {
            	var tab = Ext.getCmp('hbs020ukrTab13_inner').getValues();
				var param1 = Ext.getCmp('SUPP_TYPE13').getValue();
				var param2 = tab.DEPT_CODE[0];
				var param3 = tab.DEPT_CODE[1];
            	var param= { SUPP_TYPE : param1, DEPT_CODE : param2, DEPT_CODE2 : param3};            	
				
            	this.load({
    				params: param
    			});
    		},
			saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {		
							UniAppManager.app.onQueryButtonDown();
						 } 
					};	
					this.syncAll(config);					
				}else {
					panelDetail.down('#uniGridPanel13').uniSelectInvalidColumnAndAlert(inValidRecs);
				} 
	        },
			listeners: {
	           	load: function(store, records, successful, eOpts) {
//	           		var activeTab = panelDetail.down('#hbs020Tab').getActiveTab();
	           		if(store.data.count() == 0){
	           			Ext.getCmp('createDept').setDisabled(false);
	           		}else{
	           			Ext.getCmp('createDept').setDisabled(true);
	           		}
	           		UniAppManager.setToolbarButtons('newData',true);
	           	}
			}
	});
	
	Ext.create('Ext.data.Store', {
		storeId:"amountStore",
	    fields: ['text', 'value'],
	    data : [
	        {text:"0.001원",   value:"0.001"},
	        {text:"0.01원",   value:"0.01"},
	        {text:"0.1원",   value:"0.1"},
	        {text:"1원",   value:"1"},
	        {text:"10원",   value:"10"},
	        {text:"100원",   value:"100"},
	        {text:"1000원",   value:"1000"}
	    ]
	});
	
	// 수당기준설정 - 끝전처리기준 등록 모델
	Unilite.defineModel('hbs020ukrs14Model', {
	    fields: [
			    {name: 'WAGES_CODE'			,text:'지급/공제항목'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H030', store: Ext.data.StoreManager.lookup('wagesList'), allowBlank: false},
	    		{name: 'WAGES_TYPE'			,text:'지급/공제구분코드'	,type : 'string', allowBlank: false},
	    		{name: 'STD_AMOUNT_I'		,text:'기준액'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B042', store: Ext.data.StoreManager.lookup('amountStore'), allowBlank: false},
	    		{name: 'BELOW'				,text:'이상/이하'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H046', allowBlank: false},
	    		{name: 'CALCU_BAS'			,text:'처리기준'			,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H047', allowBlank: false}
			]
	});	
	
	var directProxy14 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList14',
    	   create: 'hbs020ukrService.insert14',
     	   update: 'hbs020ukrService.update14',
     	   destroy: 'hbs020ukrService.delete14',
    	   syncAll : 'hbs020ukrService.saveAll14'
		}
	 });
	// 수당기준설정 - 끝전처리기준 등록 스토어
	var hbs020ukrs14Store = Unilite.createStore('hbs020ukrs14Store',{
			model: 'hbs020ukrs14Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {		
							
						 } 
					};	
					this.syncAll(config);					
				}else {
					panelDetail.down('#uniGridPanel14').uniSelectInvalidColumnAndAlert(inValidRecs);
				} 
	        },            
            proxy: directProxy14,
            loadStoreRecords: function() {
				var param1 = Ext.getCmp('WAGES_TYPE14').getValue();
            	var param= { WAGES_TYPE : param1};            	
    			            	
            	this.load({
    				params: param
    			});
    		}
	});
	var hbs020ukrs15ComboStore11 = Ext.create('Ext.data.Store', { 
		storeId:"otKind01",
		fields:[ {name: 'text'	,type : 'string'},
				{name: 'value'	,type : 'string'},
				{name: 'search'	,type : 'string'}
			],
		data : [
			 {'text':'사업장'			,'value':'DIV_CODE'}  //6
			,{'text':'담당업무'			,'value':'JOB_CODE'}	//8
			,{'text':'학력코드'			,'value':'SCHSHIP_CODE'}//9
			,{'text':'입사방식'			,'value':'JOIN_CODE'}//10
			,{'text':'부서'				,'value':'DEPT_CODE'}//11
			,{'text':'직위'				,'value':'POST_CODE'}//2
			,{'text':'직책'				,'value':'ABIL_CODE'}//3
			,{'text':'지급차수'			,'value':'PAY_PROV_FLAG'}//4
			,{'text':'급여지급방식'		,'value':'PAY_CODE'}//5
			,{'text':'고용형태'			,'value':'PAY_GUBUN'}//0
			,{'text':'사원구분'			,'value':'SEX_CODE'}//1
			,{'text':'노조가입여부'		,'value':'LABOR_UNON_YN'}//13
			,{'text':'급','value':'PAY_GRADE_01'}//22
			,{'text':'호','value':'PAY_GRADE_02'}//23
		]
	});
	// 수당기준설정 - 계산식등록 모델
	Unilite.defineModel('hbs020ukrs15Model', {
	    fields: [
			    {name: 'GUBUN'			,text: ''			,type : 'string'},
			    {name: 'CODE_NAME'		,text: '계산식항목'		,type : 'string'},
	    		{name: 'WAGES_NAME'		,text: '계산식항목'		,type : 'string'},
	    		{name: 'WAGES_CODE'		,text: ''			,type : 'string'},
	    		{name: 'TABLE_NAME'		,text: ''			,type : 'string'},
	    		{name: 'WHERE_COLUMN'	,text: ''			,type : 'string'},
	    		{name: 'TYPE'			,text: ''			,type : 'string'},
	    		{name: 'SELECT_SYNTAX'	,text: ''			,type : 'string'},
	    		{name: 'UNIQUE_CODE'	,text: ''			,type : 'string'},
	    		{name: 'CHOICE'			,text: ''			,type : 'string'},
	    		{name: 'SEQ'			,text: ''			,type : 'string'},
	    		{name: 'SUPP_TYPE'		,text: '급/상여구분'		,type : 'string', comboType:'AU', comboCode:'H032'},
	    		{name: 'STD_CODE'		,text: '지급/공제코드'	,type : 'string', store:Ext.StoreManager.lookup('paymCombo') /*, comboType:'CUS', comboCode:'STDCODE'*/},
	    		{name: 'OT_KIND_01'		,text: '분류명'			,type : 'string' ,store:Ext.StoreManager.lookup('otKind01')},
	    		{name: 'OT_KIND_02'		,text: '분류명값'		,type : 'string' ,comboType:'AU', comboCode:'H028' },
	    		{name: 'OT_KIND_01NM'	,text: '분류명'		,type : 'string'},
	    		{name: 'OT_KIND_02NM'	,text: '분류명값'		,type : 'string'},
	    		{name: 'B'				,text: '공식'			,type : 'string'}
			]
	});
	
	// 보여지는 계산식
	showSentence = ''
	// 저장되는 계산식
	saveSentence = '';
	
	// 계산식에 항목 추가 /삭제 
	function treatCalcArea(btnText) {			
		showSentence = Ext.getCmp('CALC_TXT').getValue();
    	switch(btnText) {
			case 'delete' :
				if (saveSentence.length > 0) {
					var sentenceArray = saveSentence.split(',');
					if (sentenceArray.length > 1) {
						showSentence = '';
						saveSentence = '';
						for (var i = 0; i < sentenceArray.length - 1; i++) {
							showSentence = showSentence + sentenceArray[i];
							if (i == 0) {
								saveSentence = saveSentence + sentenceArray[i];
							} else {
								saveSentence = saveSentence + ',' + sentenceArray[i];
							} 
						}	
					} else {
						showSentence = saveSentence = '';
					}
				}
				break;
			case 'delete all' : 
				showSentence = saveSentence = '';
				break;
			case 'save' :
				
				var kindGrid = Ext.getCmp('kindGrid');
				var selectedModel = kindGrid.getStore().getRange();
				
				if (Ext.getCmp('CALC_TXT').value == '') {
					Ext.Msg.alert('확인', '계산식을 입력하십시오.');
					return;
				}
				if (hbs020ukrs15ComboStore2.getCount() == 0) {
					Ext.Msg.alert('확인', '분류 는 필수 입력사항 입니다.');
					return;
				} else {
					var doReturn = false;
					Ext.each(selectedModel, function(record,i){
						if (record.data.OT_KIND_02_NAME == '' || record.data.OT_KIND_02_NAME == null) {
							Ext.Msg.alert('확인', '분류값은 필수 입력사항 입니다.');
							doReturn = true;
							return;
						}
					});
					if (doReturn) return;
				}
				console.log('save');
				
				// 음수 부호를 다시 변경함
				saveSentence = saveSentence.replace('~', '-');
				
				var SUPP_TYPE = Ext.getCmp('SUPP_TYPE').value;
				var STD_CODE = Ext.getCmp('STD_CODE2').value;
				var OT_KIND_01 = '';   // ex: PAY_CODE/EMPLOY_TYPE/
				var OT_KIND_02 = '';   // ex: 3/1/
				var OT_KIND_FULL = ''; // ex: PAY_CODE:3/EMPLOY_TYPE:1/
				// record.data.OT_KIND_01_NAME : PAY_CODE
				// record.data.OT_KIND_02_NAME : 3
				var regExp = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
				
				Ext.each(selectedModel, function(record,i){
					var insertData = record.data.OT_KIND_01_NAME;
					// 이름이 들어가 있는 경우  코드로 변경함
					if (regExp.test(record.data.OT_KIND_01_NAME)) {
						insertData = record.data.OT_KIND_01;
					}					
					
					OT_KIND_01 = OT_KIND_01 + insertData + '/';
					OT_KIND_02 = OT_KIND_02 + record.data.OT_KIND_02_NAME + '/';
					OT_KIND_FULL = OT_KIND_FULL + insertData + ':' + record.data.OT_KIND_02_NAME + '/';
				});
				
				var saveSentenceArray = saveSentence.split(',');
				
				// 서버로 전송 할 JSON data
				var param = new Array(saveSentenceArray.length);
				
				for (var i = 0; i < saveSentenceArray.length; i++) {
					
					var SELECT_VALUE = '';
					var SELECT_NAME = '';
					var TABLE_NAME = '';
					var WHERE_COLUMN = '';
					var TYPE = '';
					var SELECT_SYNTAX = '';
					var UNIQUE_CODE = '';
					var CALCU_SEQ = (i + 1);
					
					if (regExp.test(saveSentenceArray[i])) {   console.log(saveSentenceArray[i]);
						
						var selectedModel;
						
						var select01 = hbs020ukrs15Store_H0018.findRecord('CODE_NAME', saveSentenceArray[i]);
						var select02 = hbs020ukrs15Store_H0019.findRecord('WAGES_NAME', saveSentenceArray[i]);
						var select03 = hbs020ukrs15Store_H0020.findRecord('WAGES_NAME', saveSentenceArray[i]);
						
						if (select01 != null) {
							SELECT_NAME = 'CODE_NAME';
							selectedModel = select01;
						} else if (select02 != null){
							SELECT_NAME = 'WAGES_NAME';
							selectedModel = select02;
						} else if (select03 != null) {
							SELECT_NAME = 'WAGES_NAME';
							selectedModel = select03;
						} else {
							console.log('Query data not exist'); 
						}
						
						if (selectedModel != null && selectedModel != '') {
							SELECT_VALUE = selectedModel.data.WAGES_CODE;
							TABLE_NAME = selectedModel.data.TABLE_NAME;
							WHERE_COLUMN = selectedModel.data.WHERE_COLUMN;
							TYPE = selectedModel.data.TYPE;
							SELECT_SYNTAX = selectedModel.data.SELECT_SYNTAX;
							UNIQUE_CODE = selectedModel.data.UNIQUE_CODE;
						}				
					} else {
						var numRegExp = /[0-9]/;
						if (numRegExp.test(saveSentenceArray[i])) {
							TYPE = '4';		
						} else {
							TYPE = '1';
						}
						SELECT_VALUE = saveSentenceArray[i];
					}
					
					data = new Object();
					data['SELECT_VALUE'] = SELECT_VALUE;
					data['SELECT_NAME'] = SELECT_NAME;
					data['TABLE_NAME'] = TABLE_NAME;
					data['WHERE_COLUMN'] = WHERE_COLUMN;
					data['TYPE'] = TYPE;
					data['SELECT_SYNTAX'] = SELECT_SYNTAX;
					data['UNIQUE_CODE'] = UNIQUE_CODE;
					data['OT_KIND_01'] = OT_KIND_01;
					data['OT_KIND_02'] = OT_KIND_02;
					data['SUPP_TYPE'] = SUPP_TYPE;
					data['OT_KIND_FULL'] = OT_KIND_FULL;
					data['STD_CODE'] = STD_CODE;
					data['CALCU_SEQ'] = CALCU_SEQ;
					data['S_USER_ID'] = "${loginVO.userID}";
					data['S_COMP_CODE'] = "${loginVO.compCode}";
					
					param[i] = data;				
				}
				
				Ext.Ajax.request({
					url     : CPATH+'/human/hbs020ukrInsertCalcSentence.do',
					params: {
						data: JSON.stringify(param)
					},
					method: 'get',
					success: function(response){
						data = Ext.decode(response.responseText);
						console.log(data);
						
						// TODO : OT_KIND_01_NAME
						var models = kindGrid.getStore().getRange();
						for (var i = 0; i < kindGrid.getStore().getCount(); i++) {
							models[i].set('OT_KIND_02_NAME', '');
						}
						
						UniAppManager.app.onQueryButtonDown();
						showSentence = saveSentence = '';
					},
					failure: function(response){
						console.log(response);
					}
				});

				
				
				break;
			case '(' :
				if (showSentence.length == 0 || (showSentence.length > 0 && (saveSentence.slice(-1) == '+' || saveSentence.slice(-1) == '(' ||
						saveSentence.slice(-1) == '-' || saveSentence.slice(-1) == '*' || saveSentence.slice(-1) == '/'))) {
					showSentence = showSentence + btnText;
					saveSentence = saveSentence + ',' + btnText;
				}
				break;
			case ')' :
				if (showSentence.length > 0 && saveSentence.slice(-1) != '(' && saveSentence.slice(-1) != '.' &&
						saveSentence.slice(-1) != '~' && saveSentence.slice(-1) != '+' &&
						saveSentence.slice(-1) != '-' && saveSentence.slice(-1) != '*' &&
						saveSentence.slice(-1) != '/') {
					showSentence = showSentence + btnText;
					saveSentence = saveSentence + ',' + btnText;
				}
				break;
			case '/' :
			case '*' :
			case '-' :
			case '+' :
				if (showSentence.length > 0 && (saveSentence.slice(-1) != '(' &&
						saveSentence.slice(-1) != '/' && saveSentence.slice(-1) != '*' && 
						saveSentence.slice(-1) != '-' && saveSentence.slice(-1) != '+' && 
						saveSentence.slice(-1) != '.' && saveSentence.slice(-1) != '~')) {
					showSentence = showSentence + btnText;
					saveSentence = saveSentence + ',' + btnText;
				}
				break;
			// 마이너스 부호의 경우 편의상 '~'로 처리함
			case '(-)' :
				if (showSentence.length == 0) {
					showSentence = showSentence + '~';
					saveSentence = saveSentence + '~';
				} else if (showSentence.length > 0 && (saveSentence.slice(-1) == '(' ||
						saveSentence.slice(-1) == '/' || saveSentence.slice(-1) == '*' || 
						saveSentence.slice(-1) == '-' || saveSentence.slice(-1) == '+')) {
					showSentence = showSentence + '~';
					saveSentence = saveSentence + ',' + '~';
				}
				break;
			case '.' :
				if (showSentence.length > 0 && (saveSentence.slice(-1) != '(' && saveSentence.slice(-1) != ')' &&
						saveSentence.slice(-1) != '/' && saveSentence.slice(-1) != '*' && 
						saveSentence.slice(-1) != '-' && saveSentence.slice(-1) != '+' && 
						saveSentence.slice(-1) != '.' && saveSentence.slice(-1) != '~')) {
					showSentence = showSentence + btnText;
					saveSentence = saveSentence + btnText;
				}
				break;
			default:
				showSentence = showSentence + btnText;
				if (saveSentence.length > 0 && (saveSentence.slice(-1) == '(' || saveSentence.slice(-1) == '/' || 
												saveSentence.slice(-1) == '*' || saveSentence.slice(-1) == '-' || 
												saveSentence.slice(-1) == '+')) {
					saveSentence = saveSentence + ',' + btnText;
				} else {
					saveSentence = saveSentence + btnText;
				}				
				break;
		}
		
		showSentence = showSentence.replace('~', '-');
		
		Ext.getCmp('CALC_TXT').setValue(showSentence);
	}
	
	
	var hbs020ukrs15ComboStore12 = Ext.create('Ext.data.Store', { 
		storeId:"otKind02",
		fields:[ {name: 'text'	,type : 'string'},
				{name: 'value'	,type : 'string'},
				{name: 'search'	,type : 'string'}
			],
		data : [].concat(
					Ext.StoreManager.lookup('CBS_MAIN_AU_H011')).concat(
					Ext.StoreManager.lookup('CBS_MAIN_AU_H024')).concat(
					Ext.StoreManager.lookup('CBS_MAIN_AU_H005')).concat(
					Ext.StoreManager.lookup('CBS_MAIN_AU_H006')).concat(
					Ext.StoreManager.lookup('CBS_MAIN_AU_H031')).concat(
					Ext.StoreManager.lookup('CBS_MAIN_AU_H028')).concat(
					Ext.StoreManager.lookup('CBS_MAIN_AU_H004')).concat(
					Ext.StoreManager.lookup('CBS_MAIN_AU_H008')).concat(
					Ext.StoreManager.lookup('CBS_MAIN_AU_H009')).concat(
					Ext.StoreManager.lookup('CBS_MAIN_AU_H012'))
	});
	// 지급 / 공제코드 콤보박스용 스토어
	var hbs020ukrs15ComboStore = Ext.create('Ext.data.Store', { 
        autoLoad: false,
        fields: [
                {name: 'text'	,type : 'string'},
				{name: 'value'	,type : 'string'}
                ],
        sorters: [{
	        property: 'WAGES_CODE',
	        direction: 'ASC'
	    }],
	    proxy: { 
            type: 'ajax', 
            url: CPATH+'/human/hbs020ukrGetComboData.do'
        }
	});

	// 수당기준설정 - 계산식등록 그리드 스토어(공제코드 값에 따른 분류 데이터를 조회함)
	var hbs020ukrs15ComboStore2 = Unilite.createStore('hbs020ukrs15Store2',{ 
        autoLoad: false,
        fields: [
				{name: 'OT_KIND_01'				,text: '분류'			,type : 'string'},
                {name: 'OT_KIND_01_NAME'		,text: '분류'			,type : 'string'},
                {name: 'OT_KIND_02'				,text: '분류값'		,type : 'string'},
	    		{name: 'OT_KIND_02_NAME'		,text: '분류값'		,type : 'string'} 
                ],
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
         	useNavi : false			// prev | next 버튼 사용
        },
        proxy: { 
            type: 'direct',
            api: {
         	   read : 'hbs020ukrService.tab15_GetComboData4'
         	}
        },
        listeners: {
        	load: function () {
        		if (this.getCount() > 0) {
        			searchField = new Array();
	              	UniAppManager.setToolbarButtons('newData', false);
	              	this.each(function(record){
	                  	var OT_KIND_01 = record.get('OT_KIND_01');
	                  	searchField.push(OT_KIND_01); 
	                 });
	              } else {
	            	  searchField = new Array();
	              	  UniAppManager.setToolbarButtons('newData', true);
	              	  Ext.getCmp('kindGrid').createRow({}, 'OT_KIND_01', 0);
	              	  searchField.push(''); 
	              }            
	              UniAppManager.setToolbarButtons('delete', true);
        	}
        },
        loadStoreRecords: function() {
			var supp_type = Ext.getCmp('SUPP_TYPE').getValue();
			var std_code = Ext.getCmp('STD_CODE2').getValue();
			var param= { SUPP_TYPE : supp_type, STD_CODE : std_code };
   			console.log( param );
   			this.load({
   				params: param
   			});	
		}       
	});
	
	// 수당기준설정 - 계산식등록 분류 필드  콤보박스 스토어
	var hbs020ukrs15ComboStore3 = Unilite.createStore('hbs020ukrs15ComboStore3',{ 
        autoLoad: false,
        fields: [
                {name: 'OT_KIND_01', type : 'string'}, // , comboType:'CUS', comboCode:'KIND01'
	    		{name: 'OT_KIND_01_NAME', type : 'string'} // , comboType:'CUS', comboCode:'KIND01'
                ],
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
         	useNavi : false			// prev | next 버튼 사용
        },
// 	    proxy: { 
//             type: 'ajax', 
//             url: CPATH+'/human/hbs020ukrGetComboData2.do'
//         }
        proxy: { 
            type: 'direct',
            api: {
         	   read : 'hbs020ukrService.tab15_GetComboData2'
         	}
        }
	});	
	// 수당기준설정 - 계산식등록 분류 필드   스토어
	var hbs020ukrs15Store = Unilite.createStore('hbs020ukrs15Store',{
			model: 'hbs020ukrs15Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },            
            proxy: {
                type: 'direct',
                api: {
                	   read: 'hbs020ukrService.selectList15',
                	   destroy: 'hbs020ukrService.deleteList15',
                	   create: 'hbs020ukrService.insertList15'
                }
            },
            listeners: {
            	load: function() {
            		if (this.getCount() > 0) {
            			UniAppManager.setToolbarButtons('delete', true);
            		}
            	}	
            },
            loadStoreRecords: function() {
				var supp_type = Ext.getCmp('SUPP_TYPE').getValue();
				var std_code = Ext.getCmp('STD_CODE1').getValue();
            	
 				if (!Ext.isEmpty(supp_type)) {
					var param= { SUPP_TYPE : supp_type, STD_CODE : std_code };
	    			console.log( param );
	    			this.load({
	    				params: param
	    			});	
 				} else {
 					Ext.Msg.alert('확인', '급/상여구분을 선택하여 주세요.');
				}
    		}          
	});
	
	var hbs020ukrs15Store_H0018 = Unilite.createStore('hbs020ukrs15Store_H0018',{
		model: 'hbs020ukrs15Model',
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
            	   read : 'hbs020ukrService.tab15_getCalcData'
            }
        },
        loadStoreRecords: function(gubun) {
			var param= { GUBUN : gubun };
			console.log( param );
			this.load({
				params: param
			});
		}          
	});
	
	var hbs020ukrs15Store_H0019 = Unilite.createStore('hbs020ukrs15Store_H0019',{
		model: 'hbs020ukrs15Model',
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
            	   read : 'hbs020ukrService.tab15_getCalcData'
            }
        },
        loadStoreRecords: function(gubun) {
			var param= { GUBUN : gubun };
			console.log( param );
			this.load({
				params: param
			});
		}          
	});
	
	var hbs020ukrs15Store_H0020 = Unilite.createStore('hbs020ukrs15Store_H0020',{
		model: 'hbs020ukrs15Model',
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
            	   read : 'hbs020ukrService.tab15_getCalcData'
            }
        },
        loadStoreRecords: function(gubun) {
			var param= { GUBUN : gubun };
			console.log( param );
			this.load({
				params: param
			});
		}          
	});
	
	
	//수당기준설정 - 근속수당기준등록 모델
	Unilite.defineModel('hbs020ukrs16Model', {
	    fields: [
			    {name: 'STRT_MONTH'				,text: '근속시작개월수(이상)'		,type : 'int', maxLength: 6},
	    		{name: 'LAST_MONTH'				,text: '근속종료개월수(미만)'		,type : 'int', maxLength: 6},
	    		{name: 'SUPP_TOTAL_I'			,text: '지급액'				,type : 'uniPrice', maxLength: 15},
	    		{name: 'SUPP_RATE'				,text: '지급율'				,type : 'uniPercent', maxLength: 7},
	    		{name: 'ACCEPT_CAREER_YN'		,text: '인정경력산입'			,type : 'string'},
	    		{name: 'PENALTY_CAREER_YN'		,text: '징계기간불산입'			,type : 'string'},
	    		{name: 'BREAK_CAREER_YN'		,text: '휴직불산입'				,type : 'string'},
	    		{name: 'BASE_DATE_CODE'			,text: '산정기준'				,type : 'string'},
	    		{name: 'UPDATE_DB_USER'			,text: 'DB유저'				,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'			,text: 'DB시간'				,type : 'string'}
			]
	});	
	
	var directProxy16 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList16',
    	   create: 'hbs020ukrService.insert16',
     	   update: 'hbs020ukrService.update16',
     	   destroy: 'hbs020ukrService.delete16',
    	   syncAll : 'hbs020ukrService.saveAll16'
		}
	 });
	//수당기준설정 - 근속수당기준등록 스토어
	var hbs020ukrs16Store = Unilite.createStore('hbs020ukrs16Store',{
			model: 'hbs020ukrs16Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy16,
            listeners: {
    	        load: function(store, records) {    	            
    	            if (store.getCount() > 0) {    	            	
//     	            	console.log(records);	    	            
	    				Ext.getCmp('BASE_DATE_CODE16').setValue(records[0].data.BASE_DATE_CODE);	    				
	    				Ext.getCmp('srchImportanceGroup').setValue({
	    					srchImportanceGroup1: records[0].data.ACCEPT_CAREER_YN,
	    					srchImportanceGroup2: records[0].data.PENALTY_CAREER_YN,
	    					srchImportanceGroup3: records[0].data.BREAK_CAREER_YN
	    				});
    	            }
    	        }
            },
			saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {		
							
						 } 
					};	
					this.syncAll(config);					
				}else {
					panelDetail.down('#uniGridPanel16').uniSelectInvalidColumnAndAlert(inValidRecs);
				} 
	        },
            loadStoreRecords: function() {
				this.load();
    		}
	});
	
	//수당기준설정 - 상여구분자 모델
	Unilite.defineModel('hbs020ukrs17Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'종합코드'		,type : 'string'},
	    		{name: 'SUB_CODE'				,text:'상세코드'		,type : 'string', allowBlank: false},
	    		{name: 'CODE_NAME'				,text:'상세코드명'		,type : 'string', allowBlank: false},
	    		{name: 'CODE_NAME_EN'			,text:'상세코드명'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'			,text:'상세코드명'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'상세코드명'		,type : 'string'},
	    		{name: 'REF_CODE1'				,text:'관련1'			,type : 'string'},
	    		{name: 'REF_CODE2'				,text:'출력순서'		,type : 'string'},
	    		{name: 'REF_CODE3'				,text:'관련3'			,type : 'string'},
	    		{name: 'REF_CODE4'				,text:'관련4'			,type : 'string'},
	    		{name: 'REF_CODE5'				,text:'관련5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'길이'			,type : 'string'},
	    		{name: 'USE_YN'					,text:'사용여부'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H160', allowBlank: false},
	    		{name: 'SORT_SEQ'				,text:'정렬'			,type : 'int'},
	    		{name: 'SYSTEM_CODE_YN'			,text:'시스템'		,type : 'int'},
	    		{name: 'UPDATE_DB_USER'			,text:'수정자'		,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'			,text:'수정'			,type : 'uniDate'}
			]
	});	
	
	var directProxy17 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList4',
    	   create: 'hbs020ukrService.insert2',
     	   update: 'hbs020ukrService.update2',
     	   destroy: 'hbs020ukrService.delete2',
    	   syncAll : 'hbs020ukrService.saveAll2'
		}
	 });
	//수당기준설정 - 상여구분자 스토어
	var hbs020ukrs17Store = Unilite.createStore('hbs020ukrs17Store',{
			model: 'hbs020ukrs17Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {		
							
						 } 
					};	
					this.syncAll(config);					
				}else {
					panelDetail.down('#uniGridPanel17').uniSelectInvalidColumnAndAlert(inValidRecs);
				} 
	        },            
            proxy: directProxy17,
            loadStoreRecords: function() {
// 				var param1 = Ext.getCmp('WAGES_TYPE14').getValue();
            	var param= { MAIN_CODE : 'H037'};            	
    			            	
            	this.load({
    				params: param
    			});
    		}
	});
	
	var value18_1 = Ext.data.StoreManager.lookup('bonusTypeList').getAt(0).get('value');
	var value18_2 = Ext.data.StoreManager.lookup('CBS_AU_H037').getAt(0).get('value');
	//수당기준설정 - 상여지급기준등록 모델1
	Unilite.defineModel('hbs020ukrs18Model', {
	    fields: [
			    {name: 'BONUS_KIND'				,text:'지급구분'			,type : 'string', allowBlank: false},
	    		{name: 'BONUS_TYPE'				,text:'구분자'			,type : 'string', allowBlank: false},
	    		{name: 'STRT_MONTH'				,text:'근속종료개월수(이상)'	,type : 'string', allowBlank: false},
	    		{name: 'LAST_MONTH'				,text:'근속종료개월수(미만)'	,type : 'string', allowBlank: false},
	    		{name: 'SUPP_RATE'				,text:'지급율(%)'			,type : 'uniPercent', allowBlank: false},
	    		{name: 'SUPP_TOTAL_I'			,text:'지급액'			,type : 'uniPrice', allowBlank: false}
			]
	});	
	var directProxy18 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList18',
    	   create: 'hbs020ukrService.insertList18',
    	   destroy: 'hbs020ukrService.deleteList18',
    	   syncAll : 'hbs020ukrService.saveAll18'
		}
	 });
	//수당기준설정 - 상여지급기준등록 스토어1
	var hbs020ukrs18Store = Unilite.createStore('hbs020ukrs18Store',{
			model: 'hbs020ukrs18Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {		
							
						 } 
					};	
					this.syncAll(config);					
				}else {
					panelDetail.down('#uniGridPanel18').uniSelectInvalidColumnAndAlert(inValidRecs);
				} 
	        },
            proxy: directProxy18,
            loadStoreRecords: function() {
            	var param= Ext.getCmp('hbs020ukrTab18_inner').getValues();			
    			console.log( param );
    			this.load({
    				params : param
    			});
    		}           
	});
	//수당기준설정 - 상여지급기준등록 모델2
	Unilite.defineModel('hbs020ukrs18_1Model', {
	    fields: [
			    {name: 'BE_BONUS_KIND'		,text: '변경전'			,type : 'string', comboType:'AU', comboCode:'H037', allowBlank: false},
	    		{name: 'AF_BONUS_KIND'		,text: '변경후'			,type : 'string', comboType:'AU', comboCode:'H037', allowBlank: false},
	    		{name: 'STD_MONTH'			,text: '경과한 근속개월수'		,type : 'string', allowBlank: false}
			]
	});	
	
	var directProxy18_1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList18_1',
    	   create: 'hbs020ukrService.insertList18_1',
    	   destroy: 'hbs020ukrService.deleteList18_1',
    	   syncAll : 'hbs020ukrService.saveAll18_1'
		}
	 });
	//수당기준설정 - 상여지급기준등록 스토어2
	var hbs020ukrs18_1Store = Unilite.createStore('hbs020ukrs18_1Store',{
			model: 'hbs020ukrs18_1Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {		
							
						 } 
					};	
					this.syncAll(config);					
				}else {
					panelDetail.down('#uniGridPanel18').uniSelectInvalidColumnAndAlert(inValidRecs);
				} 
	        },            
            proxy: directProxy18_1,
            loadStoreRecords: function() {
            	var param= Ext.getCmp('hbs020ukrTab18_inner').getValues();			
    			console.log( param );
    			this.load({
    				params : param
    			});
    		}           
	});
	//수당기준설정 - 서류내역등록 모델
	Unilite.defineModel('hbs020ukrs19Model', {
	    fields: [
			    {name: 'DOC_TYPE'			,text:'서류구분'		,type : 'string'},
	    		{name: 'DOC_ID'				,text:'서류코드'		,type : 'string', maxLength: 3, allowBlank: false},
	    		{name: 'DOC_NAME'			,text:'서류명'		,type : 'string', maxLength: 100}
			]
	});	
	
	var directProxy19 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList19',
    	   create: 'hbs020ukrService.insert19',
     	   update: 'hbs020ukrService.update19',
     	   destroy: 'hbs020ukrService.delete19',
    	   syncAll : 'hbs020ukrService.saveAll19'
		}
	 });
	 
	//수당기준설정 - 서류내역등록 스토어
	var hbs020ukrs19Store = Unilite.createStore('hbs020ukrs19Store',{
			model: 'hbs020ukrs19Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy19,
			saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {		
							
						 } 
					};	
					this.syncAll(config);					
				}else {
					panelDetail.down('#uniGridPanel19').uniSelectInvalidColumnAndAlert(inValidRecs);
				} 
	        },
            loadStoreRecords: function() {
            	var param1 = Ext.getCmp('DOC_TYPE19').getValue();
            	var param= { DOC_TYPE: param1 };            	
    			            	
            	this.load({
    				params: param
    			});
    		},
            listeners: {
    	        load: function(store, records) {
    	            UniAppManager.setToolbarButtons('newData', true);
    	        }    	       
    	    }
	});
	//수당기준설정 - 주민세신고지점등록 모델
	Unilite.defineModel('hbs020ukrs20Model', {
	    fields: [
			    {name: 'BUSS_OFFICE_CODE'		,text: '신고지점코드'			,type : 'string', allowBlank: false}, 
	    		{name: 'BUSS_OFFICE_NAME'		,text: '신고지점명'				,type : 'string', allowBlank: false},
	    		{name: 'LOCAL_TAX_GOV'			,text: '주민세신고관할관청'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H137', allowBlank: false},
	    		{name: 'BUSS_OFFICE_ADDR'		,text: '주민세신고지점 주소'		,type : 'string', allowBlank: false},
	    		{name: 'SECT_CODE'				,text: '신고사업장'				,type : 'string',  xtype: 'uniCombobox', comboType: 'BOR120', comboCode: 'BILL', allowBlank: false}
			]
	});	
	
	var directProxy20 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList20',
		   create: 'hbs020ukrService.insert20',
	 	   update: 'hbs020ukrService.update20',
	 	   destroy: 'hbs020ukrService.delete20',
    	   syncAll : 'hbs020ukrService.saveAll20'
		}
	 });
	//수당기준설정 - 주민세신고지점등록 모델
	var hbs020ukrs20Store = Unilite.createStore('hbs020ukrs20Store',{
			model: 'hbs020ukrs20Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy20,
			saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {		
							
						 } 
					};	
					this.syncAll(config);					
				}else {
					panelDetail.down('#uniGridPanel20').uniSelectInvalidColumnAndAlert(inValidRecs);
				} 
	        },
            loadStoreRecords: function() {
            	var param1 = Ext.getCmp('SECT_CODE20').getValue();
            	var param= { SECT_CODE: param1 };            	
    			            	
            	this.load({
    				params: param
    			});
    		}
	});
	
	//수당기준설정 - 메일서버정보등록 모델
	Unilite.defineModel('hbs020ukrs21Model', {
	    fields: [
			    {name: 'SEND_METHOD'					,text:'메일전송방법'		,type : 'string'},
	    		{name: 'SERVER_NAME'					,text:'서버명'		,type : 'string'},
	    		{name: 'SERVER_PROT'					,text:'서버포트'		,type : 'int'},
	    		{name: 'PICKUP_FOLDER_PATH'		,text:'PICKUP폴더경로'		,type : 'string'},
	    		{name: 'SEND_USER_NAME'			,text:'접속아이디'		,type : 'string'},
	    		{name: 'SEND_PASSWORD'				,text:'접속비밀번호'		,type : 'string'},
	    		{name: 'CONN_TIMEOUT'				,text:'연결제한시간'		,type : 'int'},
	    		{name: 'SSL_USE_YN'					,text:'보안연결사용여부'		,type : 'int'}
			]
	});	
	//수당기준설정 - 메일서버정보등록 스토어
	var hbs020ukrs21Store = Unilite.createStore('hbs020ukrs21Store',{
			model: 'hbs020ukrs21Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hbs020ukrService.selectList21'           	   
                }
            },
//			saveStore : function()	{				
//				var inValidRecs = this.getInvalidRecords();
//				if(inValidRecs.length == 0 )	{
//					config = {
//						success: function(batch, option) {		
//							
//						 } 
//					};	
//					this.syncAll(config);					
//				}else {
//					panelDetail.down('#uniGridPanel21').uniSelectInvalidColumnAndAlert(inValidRecs);
//				} 
//	        },
            listeners: {
    	        load: function(store, records) {    	            
    	            if (store.getCount() > 0) {
//     	            	console.log(records);
	    	            Ext.getCmp('SERVER_NAME21').setValue(records[0].data.SERVER_NAME);
	    				Ext.getCmp('SERVER_PROT21').setValue(records[0].data.SERVER_PROT);
	    				Ext.getCmp('PICKUP_FOLDER_PATH21').setValue(records[0].data.PICKUP_FOLDER_PATH);
	    				Ext.getCmp('SEND_USER_NAME21').setValue(records[0].data.SEND_USER_NAME);
	    				Ext.getCmp('SEND_PASSWORD21').setValue(records[0].data.SEND_PASSWORD);
	    				Ext.getCmp('CONN_TIMEOUT21').setValue(records[0].data.CONN_TIMEOUT);
	    				
	    				Ext.getCmp('rdoSelect1').setValue({SEND_METHOD : records[0].data.SEND_METHOD});
	    				Ext.getCmp('rdoSelect2').setValue({SSL_USE_YN : records[0].data.SSL_USE_YN});
    	            }
    	            UniAppManager.setToolbarButtons('delete',false);
    	        }
//             ,
//     	        dirtychange: function(form,dirty){
//     	        	if(dirty){
//     	        		UniAppManager.app.setToolbarButtons('save', true);
//     	        	}    	        	
//     	        }
//     	        ,
    	       
    	    },
            loadStoreRecords: function() {            	    			            	
            	this.load();
    		}/*,
    		submitStore: function(activeTab){
				var activeform = activeTab.getForm();				
				activeform.submit({
					url: CPATH+'/human/hbs020ukrSubmit.do',
					params:{
						SERVER_NAME: Ext.getCmp('SERVER_NAME21').getValue,
						SERVER_PROT: Ext.getCmp('SERVER_PROT21').getValue,
						PICKUP_FOLDER_PATH: Ext.getCmp('PICKUP_FOLDER_PATH21').getValue,
						SEND_USER_NAME: Ext.getCmp('SEND_USER_NAME21').getValue,
						SEND_PASSWORD: Ext.getCmp('SEND_PASSWORD21').getValue,
						CONN_TIMEOUT: Ext.getCmp('CONN_TIMEOUT21').getValue						
					},
					success:function(form, action)	{
						UniAppManager.app.setToolbarButtons('save',false);
					},
					failure: function(form, action){
						UniAppManager.app.setToolbarButtons('save',false);
					}
				});
    		}*/
    		
	});
	
	
	//수당기준설정 -금융기관코드 매칭등록 모델
	Unilite.defineModel('hbs020ukrs22Model', {
	    fields: [
			    {name: 'CUSTOM_CODE'		,text:'은행코드'		,type : 'string'},
	    		{name: 'CUSTOM_NAME'		,text:'은행명'		,type : 'string'},
	    		{name: 'BANK_CODE'			,text:'금융기관'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'H099', allowBlank: false},
	    		{name: 'FLAG'				,text:'FLAG'		,type : 'string'}
			]
	});	
	
	var directProxy22 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   read : 'hbs020ukrService.selectList22',
	 	   update: 'hbs020ukrService.update22',   
    	   syncAll : 'hbs020ukrService.saveAll22'
		}
	 });
	 
	//수당기준설정 -금융기관코드 매칭등록 스토어
	var hbs020ukrs22Store = Unilite.createStore('hbs020ukrs22Store',{
			model: 'hbs020ukrs22Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy22,
			saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {		
							
						 } 
					};	
					this.syncAll(config);					
				}else {
					panelDetail.down('#uniGridPanel22').uniSelectInvalidColumnAndAlert(inValidRecs);
				} 
	        },
            loadStoreRecords: function() {            	
            	this.load();
    		}
	});
	
	
	
	
	
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'uniGroupTabPanel',
	    	itemId: 'hbs020Tab',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [
	    		{
		    	 	defaults:{
						xtype:'uniDetailForm',
					    disabled:false,
					    border:0,
					    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}}
// 						margin: '10 10 10 10'
					},
					items:[
						{
							title:'근태기준설정',
							itemId: 'tabTitle01',
							border: false						
						}
						,<%@include file="./s_hbs020ukrs2_KOCIS.jsp" %> // 근태코드등록     
						,<%@include file="./s_hbs020ukrs3_KOCIS.jsp" %>	// 근태기준등록
				    ]
	    		},{
		    	 	defaults:{
						xtype:'uniDetailForm',
					    disabled:false,
					    border:0,
					    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}}
// 						margin: '10 10 10 10'
					},
					items:[
						{
							title:'수당기준설정',
							itemId: 'tabTitle02',
							border: false						
						}
						,<%@include file="./s_hbs020ukrs9_KOCIS.jsp" %>	// 지급/공제코드등록
						,<%@include file="./s_hbs020ukrs10_KOCIS.jsp" %> // 입/퇴사자지급기준등록
				    ]
	    		}],
	    		listeners:{	    			
			    	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
			    		if(Ext.isObject(oldCard))	{
			    			 if(UniAppManager.app._needSave())	{
			    				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
									UniAppManager.app.onSaveDataButtonDown();
									this.setActiveTab(oldCard);									
								} else {
// 									oldCard.down().getStore().rejectChanges();									
									UniAppManager.setToolbarButtons('save',false);
									UniAppManager.app.loadTabData(newCard, newCard.getItemId());									
								}
			    			 }else {
			    				 // TODO : move first item of tab
			    				 if (newCard.itemId == 'tabTitle01' || newCard.itemId == 'tabTitle02') {
			    					 console.log('tab title clicked! do nothing');
			    					 return false;
			    				 } else {
			    					 UniAppManager.app.loadTabData(newCard, newCard.getItemId());
			    				 }
			    			 }
			    		}
			    	},
		    		tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
		    			if(panelDetail){
		    				var activeTabId = panelDetail.down('#hbs020Tab').getActiveTab();
		    			}		    				    			
		    			if(newCard.getId() == 'hbs020ukrTab3')	{		    				
		    				focusfield = activeTabId.down('#tabFocus3');
		    				focusfield.focus(500);
		    			}else if(newCard.getId() == 'hbs020ukrTab4')	{
//		    				UniAppManager.setToolbarButtons('newData',false);		    						
		    			}else if(newCard.getId() == 'hbs020ukrTab10')	{		    				
		    				focusfield = activeTabId.down('#tabFocus10');
		    				focusfield.focus(500);
		    			}else if(newCard.getId() == 'hbs020ukrTab11')	{		    				
		    				focusfield = activeTabId.down('#tabFocus11');
		    				focusfield.focus(500);
		    			}else if(newCard.getId() == 'hbs020ukrTab12')	{
//		    				UniAppManager.setToolbarButtons('newData',false);
		    			}else if(newCard.getId() == 'hbs020ukrTab13')	{
//		    				UniAppManager.setToolbarButtons('newData',false);
		    				Ext.getCmp('createDept').setDisabled(true);
		    				focusfield = activeTabId.down('#tabFocus13');
		    				focusfield.focus(500);		  		    				
		    			}else if(newCard.getId() == 'hbs020ukrTab14')	{		    				
		    				focusfield = activeTabId.down('#tabFocus14');
		    				focusfield.focus(500);
		    			}else if(newCard.getId() == 'hbs020ukrTab18')	{
		    				focusfield = activeTabId.down('#tabFocus18');
		    				focusfield.focus(500);		    				
		    			}else if(newCard.getId() == 'hbs020ukrTab19')	{		    				
		    				focusfield = activeTabId.down('#tabFocus19');
		    				focusfield.focus(500);		    				
		    			}else if(newCard.getId() == 'hbs020ukrTab20')	{
		    				focusfield = activeTabId.down('#tabFocus20');
		    				focusfield.focus(500);		    				
		    			}else if(newCard.getId() == 'hbs020ukrTab21')	{
		    				UniAppManager.setToolbarButtons('newData',false);
		    				UniAppManager.setToolbarButtons('delete',false);
		    			}else if(newCard.getId() == 'hbs020ukrTab22')	{
//		    				UniAppManager.setToolbarButtons('newData',false);		    						
		    			}
		    			
		    			
		    		}
			    }
	    }]
    });
    
    
    
    // 수당기준설정 - 연봉등록 : excelUpload관련
    function openExcelWindow() {
		
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';

        
        if(!excelWindow) {
        	excelWindow =  Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
            		excelConfigName: 'hbs020',
                    grids: [
                    	 {
                    		itemId: 'grid01',
                    		title: '연봉정보',                        		
                    		useCheckbox: false,
                    		model : 'excel.hbs020.sheet01',
                    		readApi: 'hbs020ukrService.selectExcelUploadSheet1',
                    		columns: [
                     		     	 { dataIndex: 'PERSON_NUMB',  		width: 80		} 
									,{ dataIndex: 'ANNUAL_SALARY_I',  	width: 120		} 
									,{ dataIndex: 'WAGES_STD_I',  		width: 120		} 
                    		]
                    	}
                    ],
                    listeners: {
                        close: function() {
                            this.hide();
                        }
                    },
                    onApply:function()	{
//                    	var grid = this.down('#grid01');
//            			var records = grid.getSelectionModel().getSelection();
//            			var mainGrid= Ext.getCmp('hbs020ukrs12Grid');
//						Ext.each(records, function(record,i){	
//										        	UniAppManager.app.onNewDataButtonDown();
//										        	mainGrid.setExcelData(record.data);								        
//											    }); 
//						grid.getStore().remove(records);						
						excelWindow.getEl().mask('로딩중...','loading-indicator');		///////// 엑셀업로드 최신로직
                    	var me = this;
                    	var grid = this.down('#grid01');
            			var records = grid.getStore().getAt(0);	
            			if(Ext.isEmpty(records) || records.length == 0){
            				excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							return false;
						}
			        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID'), YEAR_YYYY: Ext.getCmp('YEAR_YYYY').getValue()};
						hbs020ukrService.selectExcelUploadSheet1(param, function(provider, response){
							var store = Ext.getCmp('hbs020ukrs12Grid').getStore();
					    	var records = response.result;					    	
					    	store.insert(0, records);
					    	console.log("response",response)
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();							
							UniAppManager.setToolbarButtons('save', true);	
							UniAppManager.setToolbarButtons('delete', true);
							UniAppManager.setToolbarButtons('deleteAll', true);
					    });
            		}
             });
        }
        excelWindow.center();
        excelWindow.show();
	};

	 Unilite.Main( {
		borderItems:[ 
			panelDetail		 	
		], 
		id : 'hbs020ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
            var activeTab = panelDetail.down('#hbs020Tab').getActiveTab();
			
			
//            var activeTabId = panelDetail.down('#hbs020Tab').getActiveTab();
//            focusfield = activeTabId.down('#tabFocus2');
//            focusfield.focus(500);
//			hbs020ukrs1FormStore.loadStoreRecords();
//			hbs020ukrsGrid1Store.loadStoreRecords();
//			hbs020ukrsGrid2Store.loadStoreRecords();
		},
		loadTabData: function(tab, itemId){
			if (tab.getId() == 'hbs020ukrTab1'){
// 				UniAppManager.setToolbarButtons('newData',true);
				hbs020ukrs1FormStore.loadStoreRecords();
				hbs020ukrsGrid1Store.loadStoreRecords();
				hbs020ukrsGrid2Store.loadStoreRecords();
			} else if (tab.getId() == 'hbs020ukrTab2'){
				UniAppManager.setToolbarButtons('newData',true);
				hbs020ukrs2Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab3'){
				UniAppManager.setToolbarButtons('newData',true);
				hbs020ukrs3Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab4'){				
				hbs020ukrs4Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab5'){				
				//hbs020ukrs5Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab6'){
				UniAppManager.setToolbarButtons('newData',true);
				hbs020ukrs6Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab7'){
				selectedGrid = 'dutyTimeGrid01';
				UniAppManager.setToolbarButtons('newData', true);
				hbs020ukrs7Store.loadStoreRecords();
				hbs020ukrs7_1Store.loadStoreRecords();
			} else if (tab.getId() == 'hbs020ukrTab8'){
				UniAppManager.setToolbarButtons('newData',true);
				hbs020ukrs8Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab9'){
				UniAppManager.setToolbarButtons('newData',true);
//				hbs020ukrs9_1Store.loadStoreRecords();
//				hbs020ukrs9_2Store.loadStoreRecords();
//				hbs020ukrs9_3Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab10'){
				UniAppManager.setToolbarButtons('newData',true);
				hbs020ukrs10Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab11'){
				UniAppManager.setToolbarButtons('newData', true);
				hbs020ukrs11Store.loadStoreRecords();
			} else if (tab.getId() == 'hbs020ukrTab12'){
				// do nothing!!
 				hbs020ukrs12Store.loadStoreRecords();
			} else if (tab.getId() == 'hbs020ukrTab13'){
				UniAppManager.setToolbarButtons('newData',true);
				hbs020ukrs13Store.loadStoreRecords();	
			} else if (tab.getId() == 'hbs020ukrTab14'){
				UniAppManager.setToolbarButtons('newData',true);
				hbs020ukrs14Store.loadStoreRecords();				
			// TODO: 15 set!!
			} else if (tab.getId() == 'hbs020ukrTab15'){
				selectedGrid = 'kindGrid';
				hbs020ukrs15Store_H0018.loadStoreRecords('H0018');
				hbs020ukrs15Store_H0019.loadStoreRecords('H0019');
				hbs020ukrs15Store_H0020.loadStoreRecords('H0020');
				hbs020ukrs15ComboStore3.load();
				UniAppManager.setToolbarButtons('query', true);				
			} else if (tab.getId() == 'hbs020ukrTab16'){
				UniAppManager.setToolbarButtons('newData',true);
				hbs020ukrs16Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab17'){
				UniAppManager.setToolbarButtons('newData',true);
				hbs020ukrs17Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab18'){
				selectedGrid = 'bonusGrid01';
				UniAppManager.setToolbarButtons('newData', true);
				hbs020ukrs18Store.loadStoreRecords();
				hbs020ukrs18_1Store.loadStoreRecords();
			} else if (tab.getId() == 'hbs020ukrTab19'){
				UniAppManager.setToolbarButtons('newData',true);
				hbs020ukrs19Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab20'){
				UniAppManager.setToolbarButtons('newData',true);
				hbs020ukrs20Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab21'){	
				hbs020ukrs21Store.loadStoreRecords();				
			} else if (tab.getId() == 'hbs020ukrTab22'){				
				hbs020ukrs22Store.loadStoreRecords();				
			}		 
		},
		onQueryButtonDown : function()	{		
			var activeTabId = panelDetail.down('#hbs020Tab').getActiveTab();			
			if (activeTabId.getId() == 'hbs020ukrTab1'){
				hbs020ukrs1FormStore.loadStoreRecords();
				hbs020ukrsGrid1Store.loadStoreRecords();
				hbs020ukrsGrid2Store.loadStoreRecords();
//				alert('${yearCalculation}');				
			} else if (activeTabId.getId() == 'hbs020ukrTab2'){				
				hbs020ukrs2Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab3'){				
				hbs020ukrs3Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab4'){				
				hbs020ukrs4Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab5'){				
				hbs020ukrs5Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab6'){				
				hbs020ukrs6Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab7'){				
				hbs020ukrs7Store.loadStoreRecords();
				hbs020ukrs7_1Store.loadStoreRecords();
			} else if (activeTabId.getId() == 'hbs020ukrTab8'){				
				hbs020ukrs8Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab9'){				
				hbs020ukrs9_1Store.loadStoreRecords();	
				hbs020ukrs9_2Store.loadStoreRecords();
				hbs020ukrs9_3Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab10'){				
				hbs020ukrs10Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab11'){				
				hbs020ukrs11Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab12'){				
				hbs020ukrs12Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab13'){				
				hbs020ukrs13Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab14'){				
				hbs020ukrs14Store.loadStoreRecords();
			} else if (activeTabId.getId() == 'hbs020ukrTab15'){			
				hbs020ukrs15Store.loadStoreRecords();
			} else if (activeTabId.getId() == 'hbs020ukrTab16'){				
				hbs020ukrs16Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab17'){				
				hbs020ukrs17Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab18'){
				hbs020ukrs18Store.loadStoreRecords();
				hbs020ukrs18_1Store.loadStoreRecords();
			} else if (activeTabId.getId() == 'hbs020ukrTab19'){				
				hbs020ukrs19Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab20'){				
				hbs020ukrs20Store.loadStoreRecords();				
			} else if (activeTabId.getId() == 'hbs020ukrTab21'){				
				hbs020ukrs21Store.loadStoreRecords();			
			} else if (activeTabId.getId() == 'hbs020ukrTab22'){				
				hbs020ukrs22Store.loadStoreRecords();				
			}
		},
		onNewDataButtonDown : function() {
			var activeTabId = panelDetail.down('#hbs020Tab').getActiveTab();
			if (activeTabId.getId() == 'hbs020ukrTab1'){				
				// TODO : do something!				
			} else if (activeTabId.getId() == 'hbs020ukrTab2'){	
				var subLength = '6';
				if(!Ext.isEmpty(hbs020ukrs2Store.data.items[0])){
					var record = activeTabId.down('#uniGridPanel2').getSelectedRecord();						
					var subLength = record ? record.get('SUB_LENGTH') : 6;			
				}
				activeTabId.down('#uniGridPanel2').createRow({MAIN_CODE : 'H033', USE_YN : 'Y', SUB_LENGTH: subLength}, 'MAIN_CODE');
				
										
			} else if (activeTabId.getId() == 'hbs020ukrTab3'){				
				activeTabId.down('#uniGridPanel3').createRow({PAY_CODE : Ext.getCmp('PAY_CODE3').getValue(),MARGIR_TYPE : 'N', MONTH_REL_CODE : 'N', YEAR_REL_CODE : 'N', MENS_REL_CODE : 'N', WEEK_REL_CODE : 'N', FULL_REL_CODE : 'N'}, 'PAY_CODE');
			} else if (activeTabId.getId() == 'hbs020ukrTab4'){
				
				// create 기능없음					
			} else if (activeTabId.getId() == 'hbs020ukrTab5'){				
				// create 기능없음					
			} else if (activeTabId.getId() == 'hbs020ukrTab6'){
				var subLength = '6';
				if(!Ext.isEmpty(hbs020ukrs6Store.data.items[0])){
					var record = activeTabId.down('#uniGridPanel6').getSelectedRecord();						
					var subLength = record ? record.get('SUB_LENGTH') : 6;					
				}
				activeTabId.down('#uniGridPanel6').createRow({SYSTEM_CODE_YN : '0', USE_YN: 'Y', SUB_LENGTH: subLength}, 'SUB_CODE');
			} else if (activeTabId.getId() == 'hbs020ukrTab7'){				
				var grid = Ext.getCmp('dutyTimeGrid01');
				var record = {
						DUTY_FR_D : 2,
						DUTY_FR_H : '00',
						DUTY_FR_M : '00',
						DUTY_TO_D : 2,
						DUTY_TO_H : '00',
						DUTY_TO_M : '00',
						REST_FR_H_01 : '00',
						REST_FR_M_01 : '00',
						REST_TO_H_01 : '00',
						REST_TO_M_01 : '00',
						REST_FR_H_02 : '00',
						REST_FR_M_02 : '00',
						REST_TO_H_02 : '00',
						REST_TO_M_02 : '00',
						REST_FR_H_03 : '00',
						REST_FR_M_03 : '00',
						REST_TO_H_03 : '00',
						REST_TO_M_03 : '00',
						REST_FR_H_04 : '00',
						REST_FR_M_04 : '00',
						REST_TO_H_04 : '00',
						REST_TO_M_04 : '00'
				};
				if (selectedGrid == 'dutyTimeGrid02') {
					grid = Ext.getCmp('dutyTimeGrid02');
				}
				grid.createRow(record, 'WORK_TEAM');
				
				UniAppManager.setToolbarButtons('delete', true);
				UniAppManager.setToolbarButtons('save', true);					
			} else if (activeTabId.getId() == 'hbs020ukrTab8'){				
				activeTabId.down('#uniGridPanel8').createRow({}, 'PAY_CODE');					
			} else if (activeTabId.getId() == 'hbs020ukrTab9'){				
				if(activeTabId.getActiveTab().getId() == 'uniGridPanel9_2'){
					activeTabId.getActiveTab().createRow({MAIN_CODE : 'H035', WAGES_KIND: '2', USE_YN : 'Y',
						TAX_CODE: '1', EMP_TYPE: 'Y',COM_PAY_TYPE: 'Y',RETR_WAGES: 'Y',RETR_BONUS: 'N',SEND_YN: 'Y',
						WAGES_SEQ: 1,CALCU_SEQ: 1,SORT_SEQ: 1, PRINT_SEQ: 1
					}, 'WAGES_CODE');
				}else if(activeTabId.getActiveTab().getId() == 'uniGridPanel9_3'){
					activeTabId.getActiveTab().createRow({MAIN_CODE : 'H034', USE_YN : 'Y'}, 'SUB_CODE');
				}					
			} else if (activeTabId.getId() == 'hbs020ukrTab10'){				
				activeTabId.down('#uniGridPanel10').createRow(null, 'PAY_CODE');				
			} else if (activeTabId.getId() == 'hbs020ukrTab11'){
				Ext.getCmp('payGradeGrid').createRow(null, 'PAY_GRADE_01', 0);
				UniAppManager.setToolbarButtons('delete', true);
				UniAppManager.setToolbarButtons( 'save', true);
			} else if (activeTabId.getId() == 'hbs020ukrTab12'){				
				var mainGrid= Ext.getCmp('hbs020ukrs12Grid');
				mainGrid.createRow({YEAR_YYYY: Ext.getCmp('YEAR_YYYY').getValue() , ANNUAL_SALARY_I: '0.00', WAGES_STD_I: '0.00'}, 'PERSON_NUMB', mainGrid.getSelectedRowIndex());
				UniAppManager.setToolbarButtons('delete', true);
				UniAppManager.setToolbarButtons('deleteAll', true);
				UniAppManager.setToolbarButtons( 'save', true);
			} else if (activeTabId.getId() == 'hbs020ukrTab13'){				
				activeTabId.down('#uniGridPanel13').createRow({SUPP_TYPE : Ext.getCmp('SUPP_TYPE13').getValue()}, 'TREE_CODE');				
			} else if (activeTabId.getId() == 'hbs020ukrTab14'){				
				activeTabId.down('#uniGridPanel14').createRow({WAGES_TYPE : Ext.getCmp('WAGES_TYPE14').getValue(), BELOW: '3'}, 'WAGES_CODE');	
			} else if (activeTabId.getId() == 'hbs020ukrTab15'){			
				Ext.getCmp('kindGrid').createRow({}, 'OT_KIND_01', 0);
				searchField.push('');
			} else if (activeTabId.getId() == 'hbs020ukrTab16'){				
				activeTabId.down('#uniGridPanel16').createRow({ACCEPT_CAREER_YN : Ext.getCmp('srchImportanceGroup1').getValue()
					, PENALTY_CAREER_YN : Ext.getCmp('srchImportanceGroup2').getValue()
					, BREAK_CAREER_YN : Ext.getCmp('srchImportanceGroup3').getValue()
					, BASE_DATE_CODE : Ext.getCmp('BASE_DATE_CODE16').getValue()}, 'STRT_MONTH');					
			} else if (activeTabId.getId() == 'hbs020ukrTab17'){				
				activeTabId.down('#uniGridPanel17').createRow({MAIN_CODE : 'H037', USE_YN : 'Y'}, 'SUB_CODE');					
			} else if (activeTabId.getId() == 'hbs020ukrTab18') {
				var grid = Ext.getCmp('bonusGrid01');
				if (selectedGrid == 'bonusGrid01') { 
					grid.createRow({ BONUS_KIND : Ext.getCmp('BONUS_KIND').getValue(), BONUS_TYPE : Ext.getCmp('BONUS_TYPE').getValue() }, 'BONUS_KIND', 0);
				} else {
					grid = Ext.getCmp('bonusGrid02');
					grid.createRow({  }, 'BE_BONUS_KIND', 0);
				}
				UniAppManager.setToolbarButtons('delete', true);
				UniAppManager.setToolbarButtons('save', true);
			} else if (activeTabId.getId() == 'hbs020ukrTab19') {
				activeTabId.down('#uniGridPanel19').createRow({DOC_TYPE : Ext.getCmp('DOC_TYPE19').getValue()}, 'DOC_ID');
			} else if (activeTabId.getId() == 'hbs020ukrTab20') {
				activeTabId.down('#uniGridPanel20').createRow({SECT_CODE : Ext.getCmp('SECT_CODE20').getValue()}, 'BUSS_OFFICE_CODE');	
			}
		},
		confirmDelete : function(activeTab,index){
			var gridPanel = '#uniGridPanel';
			gridPanel = gridPanel + index;
			
			
			// TODO : delete activeTabId : 2,
			
			
			var selRow = activeTab.down(gridPanel).getSelectedRecord();
			if(selRow.phantom === true)	{
				activeTab.down(gridPanel).deleteSelectedRow();
			}else {
				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
					if (btn == 'yes') {
						activeTab.down(gridPanel).deleteSelectedRow();
//						activeTab.down(gridPanel).getStore().sync();
					}
				});
			}
		},
		onDeleteDataButtonDown : function()	{
			var activeTabId = panelDetail.down('#hbs020Tab').getActiveTab();			
			if (activeTabId.getId() == 'hbs020ukrTab1'){				
				// TODO : do something!				
			} else if (activeTabId.getId() == 'hbs020ukrTab2'){				
				this.confirmDelete(activeTabId,2);					
			} else if (activeTabId.getId() == 'hbs020ukrTab3'){				
				this.confirmDelete(activeTabId,3);					
			} else if (activeTabId.getId() == 'hbs020ukrTab4'){				
				this.confirmDelete(activeTabId,4);					
			} else if (activeTabId.getId() == 'hbs020ukrTab5'){				
				this.confirmDelete(activeTabId,5);				
			} else if (activeTabId.getId() == 'hbs020ukrTab6'){				
				this.confirmDelete(activeTabId,6);					
			} else if (activeTabId.getId() == 'hbs020ukrTab7'){				
				var grid = Ext.getCmp('dutyTimeGrid01');
				if (selectedGrid == 'dutyTimeGrid02') { 
					grid = Ext.getCmp('dutyTimeGrid02');
				}
				if (grid.getStore().getCount == 0) return;
				var selRow = grid.getSelectionModel().getSelection()[0];
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();					
				} else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
							UniAppManager.setToolbarButtons( 'save', true);
						}
					});
				}
				if (Ext.getCmp('dutyTimeGrid01').getStore().getCount() == 0 && Ext.getCmp('dutyTimeGrid02').getStore().getCount() == 0) {
					UniAppManager.setToolbarButtons('delete', false);
					UniAppManager.setToolbarButtons( 'save', false); 
				}
				if (!grid.getStore().isDirty()) {
					UniAppManager.setToolbarButtons( 'save', false);
				}
			} else if (activeTabId.getId() == 'hbs020ukrTab8'){				
				this.confirmDelete(activeTabId,8);				
			} else if (activeTabId.getId() == 'hbs020ukrTab9'){				
				if(activeTabId.getActiveTab().getItemId() =='uniGridPanel9_2'){
					this.confirmDelete(activeTabId,'9_2');
				}else if(activeTabId.getActiveTab().getItemId() =='uniGridPanel9_3'){
					this.confirmDelete(activeTabId,'9_3');
				}					
			} else if (activeTabId.getId() == 'hbs020ukrTab10'){				
				this.confirmDelete(activeTabId,10);					
			} else if (activeTabId.getId() == 'hbs020ukrTab11'){
//				var payGradeGrid = Ext.getCmp('payGradeGrid');
//				var selRow = payGradeGrid.getSelectionModel().getSelection()[0];
//				if (selRow.phantom === true)	{
//					payGradeGrid.deleteSelectedRow();
//				} else {
//					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
//						if (btn == 'yes') {
//							payGradeGrid.deleteSelectedRow();
//							payGradeGrid.getStore().sync();
//						}
//					});
//				}
//				if (payGradeGrid.getStore() == 0) {
//					UniAppManager.setToolbarButtons('delete', false); 
//					UniAppManager.setToolbarButtons( 'save', false); 
//				}
//				if (!payGradeGrid.getStore().isDirty()) {
//					UniAppManager.setToolbarButtons( 'save', false);
//				}
//				this.confirmDelete(activeTabId,11);
				var activeTab = panelDetail.down('#hbs020Tab').getActiveTab();
				var selRow = activeTab.down('#payGradeGrid').getSelectedRecord();
				if(selRow.phantom === true)	{
					activeTab.down('#payGradeGrid').deleteSelectedRow();
				}else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							activeTab.down('#payGradeGrid').deleteSelectedRow();
	//						activeTab.down(gridPanel).getStore().sync();
						}
					});
				}
			} else if (activeTabId.getId() == 'hbs020ukrTab12'){
				var activeTab = panelDetail.down('#hbs020Tab').getActiveTab();
				var selRow = activeTab.down('#hbs020ukrs12Grid').getSelectedRecord();
				if(selRow.phantom === true)	{
					activeTab.down('#hbs020ukrs12Grid').deleteSelectedRow();
				}else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							activeTab.down('#hbs020ukrs12Grid').deleteSelectedRow();
	//						activeTab.down(gridPanel).getStore().sync();
						}
					});
				}
//				var grid = Ext.getCmp('hbs020ukrs12Grid');
//				var selRow = grid.getSelectionModel().getSelection()[0];
//				console.log(selRow);
//				if(selRow.phantom === true)	{
//					grid.deleteSelectedRow();
//				}else {
//					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
//						if (btn == 'yes') {
//							grid.deleteSelectedRow();
//							grid.getStore().sync({
//								success: function(response) {
//									Ext.Msg.alert('확인', '삭제 되었습니다.');
//									if (grid.getStore().getCount() == 0) {
//										UniAppManager.setToolbarButtons('delete', false);
//										UniAppManager.setToolbarButtons('deleteAll', false);
//										UniAppManager.setToolbarButtons('excel', false);
//									}
//					            },
//					            failure: function(response) {
//					            }
//							});
//						}
//					});
//				}			
			} else if (activeTabId.getId() == 'hbs020ukrTab13'){				
				this.confirmDelete(activeTabId,13);				
			} else if (activeTabId.getId() == 'hbs020ukrTab14'){				
				this.confirmDelete(activeTabId,14);
			} else if (activeTabId.getId() == 'hbs020ukrTab15'){
				var kindGrid = Ext.getCmp('kindGrid');
				var kindFullGrid = Ext.getCmp('kindFullGrid');
				if (selectedGrid == 'kindGrid') {
					if (kindGrid.getStore().getCount() == 0) return;
					var selRow = kindGrid.getSelectionModel().getSelection()[0];
					if (selRow.phantom === true)	{
						kindGrid.deleteSelectedRow();
					} else {
						Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
							if (btn == 'yes') {
								kindGrid.deleteSelectedRow();
								// Do something from DB??
							}
						});
					}
				} else {
					if (kindFullGrid.getStore().getCount() == 0) return;
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							kindFullGrid.deleteSelectedRow();
							kindFullGrid.getStore().sync();
						}
					});
				}
				if (kindGrid.getStore().getCount() == 0 && kindFullGrid.getStore().getCount() == 0) {
					UniAppManager.setToolbarButtons('delete', false);
					UniAppManager.setToolbarButtons( 'save', false); 
				}
				if (!kindGrid.getStore().isDirty() && !kindFullGrid.getStore().isDirty()) {
					UniAppManager.setToolbarButtons( 'save', false); 
				}				
			} else if (activeTabId.getId() == 'hbs020ukrTab16'){				
				this.confirmDelete(activeTabId,16);					
			} else if (activeTabId.getId() == 'hbs020ukrTab17'){				
				this.confirmDelete(activeTabId,17);					
			} else if (activeTabId.getId() == 'hbs020ukrTab18'){
				var grid = Ext.getCmp('bonusGrid01');
				if (selectedGrid == 'bonusGrid02') { 
					grid = Ext.getCmp('bonusGrid02');
				}
				if (grid.getStore().getCount == 0) return;
				var selRow = grid.getSelectionModel().getSelection()[0];
				if (selRow.phantom === true)	{
					grid.deleteSelectedRow();
				} else {
					Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							grid.deleteSelectedRow();
							grid.getStore().sync();
						}
					});
				}
				if (Ext.getCmp('bonusGrid01').getStore().getCount() == 0 && Ext.getCmp('bonusGrid02').getStore().getCount() == 0) {
					UniAppManager.setToolbarButtons('delete', false);
					UniAppManager.setToolbarButtons( 'save', false); 
				}
				if (!Ext.getCmp('bonusGrid01').getStore().isDirty() && !Ext.getCmp('bonusGrid02').getStore().isDirty()) {
					UniAppManager.setToolbarButtons( 'save', false); 
				}
			} else if (activeTabId.getId() == 'hbs020ukrTab19'){				
				this.confirmDelete(activeTabId,19);					
			} else if (activeTabId.getId() == 'hbs020ukrTab20'){				
				this.confirmDelete(activeTabId,20);					
			}
		},
		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('삭제', '전체 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					var activeTabId = panelDetail.down('#hbs020Tab').getActiveTab();
					if (activeTabId.getId() == 'hbs020ukrTab12'){
						var activeTabId = panelDetail.down('#hbs020Tab').getActiveTab();						
						activeTabId.down('#hbs020ukrs12Grid').reset();
						UniAppManager.app.onSaveDataButtonDown();	
//						hbs020ukrs12Store.removeAll();
//						hbs020ukrs12Store.sync({
//							success: function(response) {
//								Ext.Msg.alert('확인', '삭제 되었습니다.');
//								UniAppManager.setToolbarButtons('delete', false);
//								UniAppManager.setToolbarButtons('deleteAll', false);
//								UniAppManager.setToolbarButtons('excel', false);
//				            },
//				            failure: function(response) {
//				            }
//			            });						
					}else if(activeTabId.getId() == 'hbs020ukrTab13'){
						var activeTabId = panelDetail.down('#hbs020Tab').getActiveTab();						
						activeTabId.down('#uniGridPanel13').reset();
						UniAppManager.app.onSaveDataButtonDown();					
					}
				}
			});
		},
		onSaveAsExcelButtonDown :function() {
			var activeTabId = panelDetail.down('#hbs020Tab').getActiveTab();			
			if (activeTabId.getId() == 'hbs020ukrTab11'){
				Ext.getCmp('payGradeGrid').downloadExcelXml(false, '급호봉');
			} else if (activeTabId.getId() == 'hbs020ukrTab12'){
				Ext.getCmp('hbs020ukrs12Grid').downloadExcelXml(false, '연봉등록');
			}
		},
		onSaveDataButtonDown : function() {
			var activeTab = panelDetail.down('#hbs020Tab').getActiveTab();
			 if (activeTab.getId() == 'hbs020ukrTab1'){
				var detailform = Ext.getCmp('hbs020ukrTab1').getForm();
				if (detailform.isValid()) {
					if (hbs020ukrsGrid1Store.isDirty()) {
						hbs020ukrsGrid1Store.saveStore();
					}
					if (hbs020ukrsGrid2Store.isDirty()) {
						hbs020ukrsGrid2Store.saveStore();
					}
					hbs020ukrs1FormStore.submitForm();
				} else {
					var invalid = detailform.getFields()
					.filterBy(function(field) {
						return !field.validate();
					});
					if (invalid.length > 0) {
						r = false;
						var labelText = ''
			
						if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
							var labelText = invalid.items[0]['fieldLabel']
									+ '은(는)';
						} else if (Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']
									+ '은(는)';
						}		
						Ext.Msg.alert('확인', labelText + Msg.sMB083);
						invalid.items[0].focus();
					}
				} 
			 } else if (activeTab.getId() == 'hbs020ukrTab2'){
// 				 activeTab.down('#uniGridPanel2').getStore().sync();
				 activeTab.down('#uniGridPanel2').getStore().saveStore();	
			 } else if (activeTab.getId() == 'hbs020ukrTab3'){
				 activeTab.down('#uniGridPanel3').getStore().saveStore();	
			 } else if (activeTab.getId() == 'hbs020ukrTab4'){
				 activeTab.down('#uniGridPanel4').getStore().saveStore();	
			 } else if (activeTab.getId() == 'hbs020ukrTab5'){
				 activeTab.down('#uniGridPanel5').getStore().saveStore();	
			 } else if (activeTab.getId() == 'hbs020ukrTab6'){
				 activeTab.down('#uniGridPanel6').getStore().saveStore();	
			 } else if (activeTab.getId() == 'hbs020ukrTab7'){
				// 입력데이터 validation
				if (!checkValidaionGrid7()) {
					return false;
				}
				var grid1 = Ext.getCmp('dutyTimeGrid01');
				var grid2 = Ext.getCmp('dutyTimeGrid02');
				if(grid1.getStore().isDirty()){
					activeTab.down('#dutyTimeGrid01').getStore().saveStore();
				}else if(!grid1.getStore().isDirty() && grid2.getStore().isDirty()){
					activeTab.down('#dutyTimeGrid02').getStore().saveStore();
				}				  
//				for (var i = 0; i < 2; i++) {
//					var grid = (i == 0 ? Ext.getCmp('dutyTimeGrid01') : Ext.getCmp('dutyTimeGrid02'));
//					if (grid.getStore().isDirty()) {
//						grid.getStore().saveStore({						
//							success: function(response) {
//								UniAppManager.setToolbarButtons('save', false); 
//				            },
//				            failure: function(response) {
//				            	UniAppManager.setToolbarButtons('save', true); 
//				            }
//						});
//					}
//				}
			} else if (activeTab.getId() == 'hbs020ukrTab8'){
				 activeTab.down('#uniGridPanel8').getStore().saveStore();
			} else if (activeTab.getId() == 'hbs020ukrTab9'){
				if(activeTab.getActiveTab().getItemId() =='uniGridPanel9_2'){
					activeTab.down('#uniGridPanel9_2').getStore().saveStore();
				}else if(activeTab.getActiveTab().getItemId() =='uniGridPanel9_3'){
					activeTab.down('#uniGridPanel9_3').getStore().saveStore();
				}
			} else if (activeTab.getId() == 'hbs020ukrTab10'){
				activeTab.down('#uniGridPanel10').getStore().saveStore();
			} else if (activeTab.getId() == 'hbs020ukrTab11'){
				activeTab.down('#payGradeGrid').getStore().saveStore();
//				var payGradeGrid = Ext.getCmp('payGradeGrid');
//				var param = new Array();
//				var selectedModel = payGradeGrid.getStore().getRange();
//				
//				Ext.each(selectedModel, function(record,i){
//					if (payGradeGrid.getStore().isDirty() && colDataTab11.length > 0) {
//						var data = initData(record);
//						data['WAGES_CODE'] = '100';
//						data['WAGES_I'] = record.data.STD100;
//						param.push(data);
//						Ext.each(colDataTab11, function(item, index){
//							var data = initData(record);
//							data['WAGES_CODE'] = item.WAGES_CODE;
//							data['WAGES_I'] = record.get('STD' + item.WAGES_CODE);
//							param.push(data);
//						});
//					} else {
//						var data = initData(record);
//						data['WAGES_CODE'] = '100';
//						data['WAGES_I'] = record.data.STD100;						
//						param.push(data);
//					}
//				});
//				
//				
//				console.log(param);
// 				config = {
// 						params: [param],
// 						success: function(batch, option) {
// 							console.log(batch);
// 							UniAppManager.setToolbarButtons('save', false);						
// 					   }
// 					};
// 				Ext.getCmp('payGradeGrid').getStore().sync(config);

//				Ext.Ajax.request({
//					url     : CPATH+'/human/hbs020ukrInsertPayGrade.do',
//					params: {
//						data: JSON.stringify(param)
//					},
//					method: 'get',
//					success: function(response){
//						data = Ext.decode(response.responseText);
//						console.log(data);
//						UniAppManager.app.onQueryButtonDown();
//						UniAppManager.setToolbarButtons( 'save', false); 
//					},
//					failure: function(response){
//						console.log(response);
//					}
//				});
				
			} else if (activeTab.getId() == 'hbs020ukrTab12'){
				activeTab.down('#hbs020ukrs12Grid').getStore().saveStore();
//				var grid = Ext.getCmp('hbs020ukrs12Grid');
//				grid.getStore().sync({
//					success: function(response) {
//						Ext.Msg.alert('확인', '저장 되었습니다.');
//						UniAppManager.setToolbarButtons('save', false);
//		            },
//		            failure: function(response) {
//		            }
//				});
			} else if (activeTab.getId() == 'hbs020ukrTab13'){
//				activeTab.down('#uniGridPanel13').getStore().sync();
				activeTab.down('#uniGridPanel13').getStore().saveStore();
			} else if (activeTab.getId() == 'hbs020ukrTab14'){
//				activeTab.down('#uniGridPanel14').getStore().sync();
				activeTab.down('#uniGridPanel14').getStore().saveStore();
			} else if (activeTab.getId() == 'hbs020ukrTab15'){
//				activeTab.down('#uniGridPanel15').getStore().sync();
				activeTab.down('#uniGridPanel15').getStore().saveStore();
			} else if (activeTab.getId() == 'hbs020ukrTab16'){
//				activeTab.down('#uniGridPanel16').getStore().sync();
				activeTab.down('#uniGridPanel16').getStore().saveStore();
			} else if (activeTab.getId() == 'hbs020ukrTab17'){
//				activeTab.down('#uniGridPanel17').getStore().sync();
				activeTab.down('#uniGridPanel17').getStore().saveStore();
			} else if (activeTab.getId() == 'hbs020ukrTab18'){
				// validation
				var grid = Ext.getCmp('bonusGrid01');
				if (grid.getStore().isDirty() && grid.getStore().getCount() > 0) {
					var selectedModel = grid.getStore().getRange();
					var doReturn = false;
					Ext.each(selectedModel, function(record,i){
						if (record.data.STRT_MONTH > record.data.LAST_MONTH) {
							Ext.Msg.alert('확인', '근속시작개월수는 근속종료개월수보다 작아야 합니다. ');
							grid.getSelectionModel().setCurrentPosition({row:i, column:2});
							doReturn = true;
							return;
						}
					});
					if (doReturn) {
						return;
					} else {
						if (grid.getStore().isDirty()) {
							grid.getStore().saveStore();
						}
						UniAppManager.setToolbarButtons('save', false); 
					}
				}
				var grid = Ext.getCmp('bonusGrid02');
				if (grid.getStore().isDirty()) {
					grid.getStore().saveStore();
					UniAppManager.setToolbarButtons('save', false); 
				}
			} else if (activeTab.getId() == 'hbs020ukrTab19'){
//				activeTab.down('#uniGridPanel19').getStore().sync();
				activeTab.down('#uniGridPanel19').getStore().saveStore();
			} else if (activeTab.getId() == 'hbs020ukrTab20'){
//				activeTab.down('#uniGridPanel20').getStore().sync();
				activeTab.down('#uniGridPanel20').getStore().saveStore();
			} else if (activeTab.getId() == 'hbs020ukrTab21'){	
				
//				hbs020ukrs21Store.submitStore(activeTab);
				var form = Ext.getCmp('hbs020ukrTab21').getForm();
				var param = form.getValues();				
				Ext.getBody().mask('로딩중...', 'loading');
				hbs020ukrService.submit21(param, function(provider, response)	{
					if(!Ext.isEmpty(provider) && provider > 0){
						UniAppManager.updateStatus(Msg.sMB011);
	        			UniAppManager.setToolbarButtons('save', false);
	        			Ext.getBody().unmask();
					}	        		 
				});
				
			} else if (activeTab.getId() == 'hbs020ukrTab22'){
//				activeTab.down('#uniGridPanel22').getStore().sync();
				activeTab.down('#uniGridPanel22').getStore().saveStore();
			}
		}
	});
	 
	 // insert 될 data를 초기화함(급호봉등록)
	 function initData(record) {
		 var data = new Object();
		 data['S_COMP_CODE'] = "${loginVO.compCode}";
		 data['PAY_GRADE_01'] = record.data.PAY_GRADE_01;
		 data['PAY_GRADE_02'] = record.data.PAY_GRADE_02;
		 data['S_USER_ID'] = "${loginVO.userID}";
		 return data;
	 }
	 
	 // insert, update 전 입력값  검증(근무시간 등록)
	 function checkValidaionGrid7() {
		 
		 // 시작시간이 종료시간 보다 큰 값이 입력이 됨
		 var rightTimeInputed = true;
		 // grid01의 경우 휴식시간4도 검증을 실시함
		 var checkExtraColumn = true;
		 
		 var MsgTitle = '확인';
		 var MsgErr01 = '시작시간이 종료 시간 보다 클 수 없습니다.';
		 
		 var loopCount = 0;
		 
		 var grid = Ext.getCmp('dutyTimeGrid01');
		 if (Ext.getCmp('dutyTimeGrid01').getStore().isDirty()) loopCount = loopCount + 1;
		 if (Ext.getCmp('dutyTimeGrid02').getStore().isDirty()) loopCount = loopCount + 1;
		 
		 for (var loop = 0; loop < loopCount; loop++) {
			 // 2개의 grid 모두 확인이 필요 할 경우
			 if (loop == 1) {
				 grid = Ext.getCmp('dutyTimeGrid02');
				 checkExtraColumn = false;
			 }
			 var selectedModel = grid.getStore().getRange();
			 Ext.each(selectedModel, function(record,i){
				 
				 if ( (record.data.DUTY_FR_D != '' && record.data.DUTY_TO_D == '') ||
					  (record.data.DUTY_FR_D == '' && record.data.DUTY_TO_D != '') ) {
					 rightTimeInputed = false;
					 return;
				 } else if (record.data.DUTY_FR_D != '' && record.data.DUTY_TO_D != '') {
					 if ((record.data.DUTY_FR_D > record.data.DUTY_TO_D)) {
						 rightTimeInputed = false;
						 return;
					 } else {
						var fr_time = parseInt(record.data.DUTY_FR_H + record.data.DUTY_FR_M);
						var to_time = parseInt(record.data.DUTY_TO_H + record.data.DUTY_TO_M);
						if (record.data.DUTY_FR_D == record.data.DUTY_TO_D && fr_time > to_time) {
							rightTimeInputed = false;
							return;
						}
					 }
				 }
				 
				 if ( (record.data.REST_FR_D_01 != '' && record.data.REST_TO_D_01 == '') ||
					  (record.data.REST_FR_D_01 == '' && record.data.REST_TO_D_01 != '') ) {
					 rightTimeInputed = false;
					 return;
				 } else if (record.data.REST_FR_D_01 != '' && record.data.REST_TO_D_01 != '') {
					 if (record.data.REST_FR_D_01 > record.data.REST_TO_D_01) {
						 rightTimeInputed = false;
						 return;						 
					 } else {
						var fr_time = parseInt(record.data.REST_FR_H_01 + record.data.REST_FR_M_01);
						var to_time = parseInt(record.data.REST_TO_H_01 + record.data.REST_TO_M_01);
						if (record.data.REST_FR_D_01 == record.data.REST_TO_D_01 && fr_time > to_time) {
							rightTimeInputed = false;
							return;
						}
					 }
				 }
				 
				 if ( (record.data.REST_FR_D_02 != '' && record.data.REST_TO_D_02 == '') ||
					  (record.data.REST_FR_D_02 == '' && record.data.REST_TO_D_02 != '') ) {
					 rightTimeInputed = false;
					 return;
				 } else if (record.data.REST_FR_D_02 != '' && record.data.REST_TO_D_02 != '') {
					 if (record.data.REST_FR_D_02 > record.data.REST_TO_D_02) {
						 rightTimeInputed = false;
						 return;						 
					 } else {
						var fr_time = parseInt(record.data.REST_FR_H_02 + record.data.REST_FR_M_02);
						var to_time = parseInt(record.data.REST_TO_H_02 + record.data.REST_TO_M_02);
						if (record.data.REST_FR_D_02 == record.data.REST_TO_D_02 && fr_time > to_time) {
							rightTimeInputed = false;
							return;
						}
					 }
				 }
				 
				 if ( (record.data.REST_FR_D_03 != '' && record.data.REST_TO_D_03 == '') ||
					  (record.data.REST_FR_D_03 == '' && record.data.REST_TO_D_03 != '') ) {
					 rightTimeInputed = false;
					 return;
				 } else if (record.data.REST_FR_D_03 != '' && record.data.REST_TO_D_03 != '') {
					 if (record.data.REST_FR_D_03 > record.data.REST_TO_D_03) {
						 rightTimeInputed = false;
						 return;						 
					 } else {
						var fr_time = parseInt(record.data.REST_FR_H_03 + record.data.REST_FR_M_03);
						var to_time = parseInt(record.data.REST_TO_H_03 + record.data.REST_TO_M_03);
						if (record.data.REST_FR_D_03 == record.data.REST_TO_D_03 && fr_time > to_time) {
							rightTimeInputed = false;
							return;
						}
					 }
				 }
				 
				 if (checkExtraColumn) {
					 if ( (record.data.REST_FR_D_04 != '' && record.data.REST_TO_D_04 == '') ||
						  (record.data.REST_FR_D_04 == '' && record.data.REST_TO_D_04 != '') ) {
						 rightTimeInputed = false;
						 return;
					 } else if (record.data.REST_FR_D_04 != '' && record.data.REST_TO_D_04 != '') {
						 if (record.data.REST_FR_D_04 > record.data.REST_TO_D_04) {
							 rightTimeInputed = false;
							 return;						 
						 } else {
							var fr_time = parseInt(record.data.REST_FR_H_04 + record.data.REST_FR_M_04);
							var to_time = parseInt(record.data.REST_TO_H_04 + record.data.REST_TO_M_04);
							if (record.data.REST_FR_D_04 == record.data.REST_TO_D_04 && fr_time > to_time) {
								rightTimeInputed = false;
								return;
							}
						 }
					 }
				 }
				 
			 });
		 }
		 if (!rightTimeInputed) {
			 Ext.Msg.alert(MsgTitle, MsgErr01);
		 }
		 return rightTimeInputed;
		 
	 }
	
	//급호봉 등록 모델 필드 생성
	 function createModelField(colData, tabId) {
	 	var fields;
	 	if (tabID = 'hbs020ukrTab11') {
	 		fields = [
	 					{name: 'PAY_GRADE_01'			,text:'급'			,type : 'string', allowBlank: false},
	 		    		{name: 'PAY_GRADE_02'			,text:'호'			,type : 'string', allowBlank: false},
	 		    		{name: 'FLAG100'				,text:'기본급'		,type : 'uniPrice'},
	 		    		{name: 'CODE100'				,text:'기본급'		,type : 'uniPrice'},
	 		    		{name: 'STD100'					,text:'기본급'		,type : 'uniPrice'}
	 				];
	 		Ext.each(colData, function(item, index){
	 			fields.push({name: 'FLAG' + item.WAGES_CODE, text: item.WAGES_NAME, type:'uniPrice' });
	 			fields.push({name: 'CODE' + item.WAGES_CODE, text: item.WAGES_NAME, type:'uniPrice' });
	 			fields.push({name: 'STD' + item.WAGES_CODE,  text: item.WAGES_NAME, type:'uniPrice' });
	 		});
	 		console.log(fields);	
	 	}		
	 	return fields;
	 }

	 //급호봉 등록  그리드 컬럼 생성
	 function createGridColumn(colData, tabId) {
	 	var columns;
	 	if (tabID = 'hbs020ukrTab11') {
	 		columns = [
	 						{dataIndex: 'PAY_GRADE_01',		width: 80},				  
	 						{dataIndex: 'PAY_GRADE_02',		width: 80},				  
	 						{dataIndex: 'FLAG100',			width: 80, 	hidden: true},				  
	 						{dataIndex: 'CODE100',			width: 100, hidden: true},				  
	 						{dataIndex: 'STD100',			width: 100},
	 						{dataIndex: 'WAGES_CODE',		width: 100, hidden: true},
	 						{dataIndex: 'WAGES_I',			width: 100, hidden: true}
	 				  ];	
	 	}
	 	Ext.each(colData, function(item, index){
	 		columns.push({dataIndex: 'FLAG' + item.WAGES_CODE, width: 80, 	hidden: true});
	 		columns.push({dataIndex: 'CODE' + item.WAGES_CODE, width: 100, 	hidden: true});
	 		columns.push({dataIndex: 'STD' + item.WAGES_CODE, width: 100});
	 	});
	 	console.log(columns);
	 	return columns;
	 } 
	 
	 Unilite.createValidator('validator04', {
		grid: panelDetail.down('#uniGridPanel4'),
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "REF_CODE1" :
					if(newValue < 0 || newValue > 24){
						rv='24시간을 넘길수 없습니다.';
						break;
					}
				break;
			}
			return rv;
			}
		});


};

</script>

