<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham101ukr"  >
	<t:ExtComboStore comboType="BOR120" />					 						<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL"/> 						<!-- 신고 사업장 -->  	
	<t:ExtComboStore comboType="AU"  comboCode="H023"/> 							<!-- 퇴사사유 -->  	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >


var BsaCodeInfo = { 
    gsAutoCode: '${gsAutoCode}'     //PERSON_NUMB 자동채번 관련  BCM100T에INSERT 관련
}
function appMain() {
	
   /** Model 정의 
    * @type 
    */
	Unilite.defineModel('Ham101ukrModel', {
		fields: [ 
			{name: 'GUBUN',				text: 'GUBUN',			type: 'string'},
			{name: 'PERSON_NUMB',		text: '사번',				type: 'string'},
			{name: 'NAME',				text: '성명',				type: 'string', allowBlank: false},
			{name: 'REPRE_NUM',			text: '주민등록번호',		type: 'string', allowBlank: false},
			{name: 'REPRE_NUM_EXPOS'    ,text: '주민등록번호',		type: 'string', allowBlank: false, defaultValue:'*************'},
			{name: 'DIV_CODE',			text: '사업장',			type: 'string', comboType:'BOR120', allowBlank: false},
			{name: 'BILL_DIV_CODE',		text: '신고사업장',			type: 'string', comboType:'BOR120', comboCode: 'BILL', allowBlank: false},
			{name: 'DEPT_CODE',			text: '부서코드',			type: 'string', allowBlank: false},
			{name: 'DEPT_NAME',			text: '부서명',			type: 'string', allowBlank: false},
			{name: 'JOIN_DATE',			text: '입사일',			type: 'uniDate', allowBlank: false},
			{name: 'RETR_DATE',			text: '퇴사일',			type: 'uniDate'},
			{name: 'RETR_RESN',			text: '퇴사사유',			type: 'string', comboType:'AU', comboCode: 'H023'}, 
			{name: 'BANK_CODE1',		text: '은행코드', 			type: 'string'},
			{name: 'BANK_NAME1',		text: '은행명', 			type: 'string'},
			{name: 'BANK_ACCOUNT1',		text: '계좌번호', 			type: 'string', allowBlank: false},
			{name: 'BANK_ACCOUNT1_EXPOS', 	text: '계좌번호',		type: 'string', allowBlank: false, defaultValue:'*************'},
			{name: 'BANKBOOK_NAME1',	text: '예금주명', 			type: 'string'},
			{name: 'SEX_CODE',			text: '성별', 			type: 'string'}
		/*  안쓰는 필드 주석
			{name: 'GUBUN',				text :'구분', 			type: 'string'},
			{name: 'POST_CODE',			text: '직위',				type: 'string', comboType:'AU',comboCode:'H005' },
			{name: 'PERSON_CNT',		text: 'cnt',			type: 'int'},
			{name: 'NAME_ENG',			text: '영문성명',			type: 'string'}, // 추가
			{name: 'NAME_CHI',			text: '한자성명',			type: 'string'}, // 추가
			{name: 'DOC_ID',			text: 'DOC_ID',			type: 'string'}, // 추가
			{name: 'ORI_JOIN_DATE',		text: '최초입사일',			type: 'uniDate'},
			{name: 'ORI_YEAR_DIFF',		text: '최초근속년수',		type: 'string'},
			{name: 'YEAR_DIFF',			text: '근속년수',			type: 'string'},	
			{name: 'PAY_GUBUN',			text: '고용형태',			type: 'string'}, //comboType:'AU',comboCode:'H011' 
			{name: 'PAY_GUBUN2',		text: '일반/일용',			type: 'string'},
			{name: 'EMPLOY_TYPE',		text: '사원구분',			type: 'string'}, //, comboType:'AU',comboCode:'H024'
			{name: 'ABIL_CODE',			text: '직책',				type: 'string'}, //, comboType:'AU',comboCode:'H006'  
			{name: 'AFFIL_CODE',		text: '직렬',				type: 'string'}, // 추가
			{name: 'JOB_CODE',			text: '담당업무',			type: 'string'},
			{name: 'JOIN_CODE',			text: '입사구분',			type: 'string'},
			{name: 'GRADE',				text: '학력졸업',			type: 'string'}, //, comboType:'AU',comboCode:'H009'	
			
			// 추가 및 변경
			
			{name: 'ANNOUNCE_DATE',		text: '현직급임용일', 		type: 'uniDate'},
			{name: 'PAY_GRADE',			text: '호봉', 			type: 'string'},
			{name: 'PAY_GRADE_BASE',	text: '승급기준', 			type: 'string'},
			{name: 'YEAR_GRADE',		text: '근속', 			type: 'string'},
			{name: 'YEAR_GRADE_BASE',	text: '승급기준', 			type: 'string'},		//???
			{name: 'PAY_CODE',			text: '급여지급방식', 		type: 'string'},
			{name: 'PAY_PROV_FLAG',		text: '지급차수', 			type: 'string'},
			{name: 'ANNUAL_SALARY_I',	text: '연봉', 			type: 'uniPrice'},
			{name: 'WAGES_STD_I',		text: '기본급', 			type: 'uniPrice'},
			{name: 'PAY_PRESERVE_I',	text: '기본급2', 			type: 'uniPrice'},
			{name: 'BONUS_KIND',		text: '상여계산구분', 		type: 'string'},
			{name: 'BONUS_STD_I',		text: '상여기준금', 		type: 'uniPrice'},
			{name: 'COM_YEAR_WAGES',	text: '년월차기준금', 		type: 'uniPrice'},
			{name: 'TAX_CODE',			text: '연장수당세액', 		type: 'string'},
			{name: 'TAX_CODE2',			text: '보육수당세액', 		type: 'string'},
			
			{name: 'ANU_BASE_I',		text: '월평균보수액(국민)',  type: 'uniPrice'},
			{name: 'ANU_INSUR_I',		text: '국민연금료', 		type: 'uniPrice'},
			{name: 'MED_AVG_I',			text: '월평균보수액(건강)',  type: 'uniPrice'},
			{name: 'MED_INSUR_I',		text: '건강보험료', 		type: 'uniPrice'},
			{name: 'ORI_MED_INSUR_I',	text: '건강보험(고지)', 	type: 'uniPrice'},
			{name: 'OLD_MED_INSUR_I',	text: '노인요양(고지)', 	type: 'uniPrice'},
			{name: 'HIRE_AVG_I',		text: '월평균보수액(고용)',  type: 'uniPrice'},
			{name: 'HIRE_INSUR_I',		text: '고용보험료', 		type: 'uniPrice'},
			
			{name: 'KOR_ADDR',			text: '주소', 			type: 'string'},
			{name: 'TELEPHON',			text: '전화번호', 			type: 'string'},
			{name: 'PHONE_NO',			text: '핸드폰', 			type: 'string'},
			{name: 'BIRTH_DATE',		text: '생일', 			type: 'string'},
			{name: 'WEDDING_DATE',		text: '결혼기념일', 		type: 'string'},
			{name: 'EMAIL_SEND_YN',		text: 'E-mail전송', 		type: 'string'},
			{name: 'EMAIL_ADDR',		text: 'E-mail', 		type: 'string'},
			{name: 'COST_POOL',			text: 'COST_POOL', type: 'string'},
			{name: 'BILL_DIV_NAME',		text: '신고사업장', 		type: 'string'},
			{name: 'BUSS_OFFICE_CODE',	text: '소속지점', 			type: 'string'},
			{name: 'NATION_CODE',		text: '국가', 			type: 'string'},
			
			{name: 'BANK_CODE2',		text: '은행2', 			type: 'string'},
			{name: 'BANK_ACCOUNT2',		text: '계좌번호2', 		type: 'string'},
			{name: 'BANKBOOK_NAME2',	text: '예금주2', 			type: 'string'},
			
			{name: 'PAY_PROV_YN',		text: '급여지급', 			type: 'string'},
			{name: 'PAY_PROV_STOP_YN',	text: '급여지급보류', 		type: 'string'},
			{name: 'COMP_TAX_I',		text: '세액계산', 			type: 'uniPrice'},
			{name: 'HIRE_INSUR_TYPE',	text: '고용보험계산', 		type: 'string'},
			{name: 'BONUS_PROV_YN',		text: '상여지급', 			type: 'string'},
			{name: 'YEAR_GIVE',			text: '년월차수당지급', 		type: 'string'},
			{name: 'YEAR_CALCU',		text: '열말정산신고', 		type: 'string'},
			{name: 'LABOR_UNON_YN',		text: '노조/상조가입', 		type: 'string'},
			{name: 'RETR_GIVE',			text: '퇴직금지급', 		type: 'string'},
			{name: 'RETR_PENSION_KIND',	text: '퇴직연금가입', 		type: 'string'},
			
			{name: 'FOREIGN_NUM',		text: '외국인등록번호', 		type: 'string'},
			{name: 'LIVE_GUBUN',		text: '거주구분', 			type: 'string'},
			{name: 'HOUSEHOLDER_YN',	text: '세대주', 			type: 'string'},
			{name: 'FOREIGN_SKILL_YN',	text: '외국인기술자', 		type: 'string'},
			{name: 'SPOUSE',			text: '배우자공제', 		type: 'string'},
			{name: 'WOMAN',				text: '부녀자세대공제', 		type: 'string'},
			{name: 'ONE_PARENT',		text: '한부모소득공제', 		type: 'string'},
			{name: 'SUPP_AGED_NUM',		text: '부양가족수', 		type: 'uniNumber'},
			{name: 'DEFORM_YN',			text: '장애인여부', 		type: 'string'},
			{name: 'DEFORM_NUM',		text: '장애인수', 			type: 'uniNumber'},
			{name: 'CHILD_20_NUM',		text: '다자녀수', 			type: 'uniNumber'},
			{name: 'AGED_NUM',			text: '경로자(70세미만)', 	type: 'uniNumber'},
			{name: 'AGED_NUM70',		text: '경로자(70세이상)', 	type: 'uniNumber'},
			{name: 'BRING_CHILD_NUM',	text: '자녀양육수', 		type: 'uniNumber'},
			
			{name: 'CARD_NUM',			text: '출입카드번호', 		type: 'string'},
			{name: 'ESS_USE_YN',		text: '대사우사용', 		type: 'string'},
			{name: 'REMARK',			text: '기타사항', 			type: 'string'},
			{name: 'ORI_ADDR',			text: '기타주소', 			type: 'string'},
			{name: 'AGENCY_NAME',		text: '보훈구분', 			type: 'string'},
			{name: 'AGENCY_GRADE',		text: '보훈등급', 			type: 'string'},
			{name: 'HITCH_NAME',		text: '장애구분', 			type: 'string'},
			{name: 'HITCH_GRADE',		text: '장애등급', 			type: 'string'},
			{name: 'HITCH_DATE',		text: '장애인등록일', 		type: 'uniDate'},
			
			{name: 'OFFICE_CODE',		text: '영업소', 			type: 'string'},
			{name: 'ROUTE_GROUP',		text: '노선그룹', 			type: 'string'},
			{name: 'LICENSE_KIND',		text: '운전면허종류', 		type: 'string'},
			{name: 'LICENSE_NO',		text: '운전면호번호', 		type: 'string'},
			{name: 'LICENSE_ACQ_DATE',	text: '취득일', 			type: 'uniDate'},
			{name: 'LICENSE_FRDATE',	text: '유효일(시작)', 		type: 'uniDate'},
			{name: 'LICENSE_TODATE',	text: '유효일(종료)', 		type: 'uniDate'},
			{name: 'BUS_CERTIFICATE',	text: '버스자격번호', 		type: 'string'},
			{name: 'CERTI_ACQ_DATE',	text: '자격취득일', 		type: 'uniDate'},
			{name: 'CIVIL_DEF_YN',		text: '민방위대상', 		type: 'string'},
			{name: 'CIVIL_DEF_NUM',		text: '민방위년차', 		type: 'string'},
			{name: 'MEMO_1',			text: '메모1', 			type: 'string'},
			{name: 'MEMO_2',			text: '메모2', 			type: 'string'}*/
		]
	});
   
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'ham101ukrService.insertList',				
			read	: 'ham101ukrService.selectList',
			update	: 'ham101ukrService.updateList',
			destroy	: 'ham101ukrService.deleteList',
			syncAll	: 'ham101ukrService.saveAll'
		}
	});
	
	
	
   /** Store 정의(Service 정의)
    * @type 
    */               
   var directMasterStore1 = Unilite.createStore('ham101ukrMasterStore1',{
		model	: 'Ham101ukrModel',
		proxy	: directProxy,
		uniOpt	: {
		      isMaster	: true,         // 상위 버튼 연결 
		      editable	: true,         // 수정 모드 사용 
		      deletable	: true,         // 삭제 가능 여부 
		      useNavi	: false         // prev | newxt 버튼 사용
		},
		autoLoad: false,
		listeners : {
	       load : function(store) {
	           /*if (store.getCount() > 0) {
	           	setGridSummary(Ext.getCmp('CHKCNT').checked);
	           }*/
	           /*var newValue = panelSearch.getValue('ORI_JOIN_DATE'); 
	           checkVisibleOriJoinDate(newValue);*/
	       }
		},
		loadStoreRecords : function()   {
	       var param= Ext.getCmp('searchForm').getValues();	
//	       if(Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
//	       	var divCodes = new Array();
//	           ham101ukrService.getDivList(param, function(provider, response)	{	//사업자번호 조회
//				if(!Ext.isEmpty(provider)){
//					Ext.each(provider, function(record, i){
//						divCodes.push(provider[i].DIV_CODE);
//					});
//					param.DIV_CODE = divCodes;
//					directMasterStore1.load({
//		               params : param
//		            });
//				}
//			});
//	       }else{
	       	this.load({
	              params : param
	           });
//	       }	            
		},
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toDelete = this.getRemovedRecords();
			var isErr = false;
			
			if (BsaCodeInfo.gsAutoCode != 'Y') {
				Ext.each(toCreate, function(cRecord, i){
					if(Ext.isEmpty(cRecord.get('PERSON_NUMB'))) {
						alert ('사번은 필수 입력 항목입니다.');
						isErr = true;
						return false;
					}
				});
			}

			Ext.each(toDelete, function(record, i){
				var param = {PERSON_NUMB : record.get('PERSON_NUMB')}
				ham101ukrService.existsHam800t(param, function(provider, response)	{	//일용직급여 등록여부 확인
					if(!Ext.isEmpty(provider)){
						if(parseInt(provider.CNT) > 0){
							alert('이미 일용직급여가 등록되어 삭제가 불가능합니다.');
							isErr = true;
							return false;
						}
					}
				});
			});
			if(isErr) return false;
			
            var paramMaster= panelSearch.getValues();   //syncAll 수정
            paramMaster.AUTO_CODE = BsaCodeInfo.gsAutoCode;
			
			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
                  		UniAppManager.app.onQueryButtonDown();
					 } 
				};
				this.syncAllDirect(config);				
			}else {    				
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				
	      	}				
		}
   });
   


   /** 검색조건 (Search Panel)
    * @type 
    */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',		
        defaultType	: 'uniSearchSubPanel',
        collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items			: [{	
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
           	layout		: {type: 'uniTable', columns: 1},
           	defaultType	: 'uniTextfield',           	
			items		: [{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
		        comboType	: 'BOR120',
				value		: UserInfo.divCode,
		        multiSelect	: true, 
		        typeAhead	: false,
				width		: 325,
				listeners	: {
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
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}), 
			Unilite.popup('Employee',{
				fieldLabel: '사원',
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
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{ 
    			fieldLabel: '입사일',
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
    			fieldLabel: '퇴사일',
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
                fieldLabel: '재직구분',
                xtype: 'radiogroup',
                columns: [60,60,60],
                items: [{
	            		boxLabel: '전체',
						name: 'RDO_TYPE',
						inputValue: ''
					},{
						boxLabel: '재직',
						name: 'RDO_TYPE',
						inputValue: '1',
						checked: true
					},{
						boxLabel: '퇴사',
						name: 'RDO_TYPE',
						inputValue: '00000000'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
						}
					}
            },{
                fieldLabel: '성별',
                xtype: 'radiogroup',
                columns: [60,60,60],
                items: [{
						boxLabel: '전체',
						name: 'SEX_CODE',
						inputValue: '',
						checked: true 
					},{
						boxLabel: '남',
						name: 'SEX_CODE',
						inputValue: 'M'
					},{
						boxLabel: '여',
						name: 'SEX_CODE',
						inputValue: 'F'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('SEX_CODE').setValue(newValue.SEX_CODE);
						}
					}
            },{
            	fieldLabel: '인원합계 표시',
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
			}, {               
                //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                name:'DEC_FLAG', 
                xtype: 'uniTextfield',
                hidden: true
            }/*,{
            	fieldLabel: '장애인여부',
            	margin: '0 0 0 40',
            	labelWidth: 100,
            	name: 'DEFORM_YN',
				uncheckedValue: 'N',
        		inputValue: 'Y',
				xtype: 'checkbox',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('DEFORM_YN', newValue);
					}
				}
			}*/
		]}/*,{
		   	title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',           	
			items: [{ 
				fieldLabel: '고용형태',
				name: 'PAY_GUBUN',
				id: 'PAY_GUBUN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H011',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						if(newValue){
							checkVisible(newValue);
						}
					}
		        }
			},{
				xtype:'container',
				items:[{
	                fieldLabel: '비정규직',
	                name: 'PAY_GU2',
	                id:'PAY_GU2',
	                xtype: 'radiogroup',                
	                columns: [60,60,60],
	                items: [{
						boxLabel: '전체',
						name: 'PAY_GU2',
						inputValue: '',
						checked: true 
					},{
						boxLabel: '일반',
						name: 'PAY_GU2',
						inputValue: '2'
					},{
						boxLabel: '일용',
						name: 'PAY_GU2',
						inputValue: '1'
					}]
            	}]
			},{
				fieldLabel: '사원구분',
				name: 'EMPLOY_TYPE',
				id: 'EMPLOY_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H024'
			},{
				fieldLabel: '직위',
				name: 'POST_CODE',
				id: 'POST_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H005'
			},{
				fieldLabel: '직책',
				name: 'ABIL_CODE',
				id: 'ABIL_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H006'
			},{
				fieldLabel: '학력',
				name: 'SCHSHIP_CODE',
				id: 'SCHSHIP_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H009'
			},{
				fieldLabel: '졸업구분',
				name: 'GRADU_TYPE',
				id: 'GRADU_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H010'
			},
				Unilite.popup('PAY_GRADE',{
					fieldLabel: '급호',
				  	valueFieldName:'PAY_GRADE_01',
				    textFieldName:'PAY_GRADE_02',
					validateBlank:false
			}),{
				fieldLabel: '승급기준', //호봉승급기준
				name: 'PAY_GRADE_BASE',
				id: 'PAY_GRADE_BASE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H174'
			},{
				fieldLabel: '고용보험',//콤보코드 없음
				name: 'HIRE_INSUR_TYPE',
				id: 'HIRE_INSUR_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'T107'
			},{
				fieldLabel: '최초입사일',
				//name: 'ORI_JOIN_DATE',
				xtype: 'radiogroup',
				id: 'oriRadio',
				columns: [60,60],
				items: [{
					boxLabel: '포함안함',
					name: 'ORI_JOIN_DATE',
					inputValue: 'X',
					width: 80,
					checked: true
				},{
					boxLabel: '포함',
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
				fieldLabel: '근속년수',
				layout: {type : 'uniTable',columns : 11},
				defaults: {flex: 1, hideLabel: true},
				defaultType : 'textfield',
				colspan: 3,
				items: [
					{
						fieldLabel: '시작년도',
						id: 'startYear',
						name: 'startYear',
						xtype: 'uniTextfield',
						width: 35
					},
					{xtype: 'displayfield', value: '년&nbsp;'},
					{
						fieldLabel: '시작월',
						id: 'startMonth',
						name: 'startMonth',
						xtype: 'uniTextfield',
						width: 35
					},
					{xtype: 'displayfield', value: '월'},
					{xtype: 'displayfield', value: '&nbsp;~&nbsp;'},
					{
						fieldLabel: '종료년도',
						id: 'endYear',
						name: 'endYear',
						xtype: 'uniTextfield',
						width: 35
					},
					{xtype: 'displayfield', value: '년&nbsp;'},
					{
						fieldLabel: '종료월',
						id: 'endMonth',
						name: 'endMonth',
						xtype: 'uniTextfield',
						width: 35
					},
					{xtype: 'displayfield', value: '월&nbsp;'}
					
				]
			},{
				xtype: 'fieldcontainer',
// 					fieldLabel: '근속년수',
				layout: {type : 'uniTable',columns : 11},
				defaults: {flex: 1, hideLabel: true},
				defaultType : 'textfield',
				colspan: 3,
				margin: '0 0 0 95',
				items: [
// 						{xtype: 'displayfield', value: '기준일&nbsp;'},
					{
						fieldLabel: '기준일',
						xtype: 'uniDatefield',
						id:'frToDate',
						name: 'FR_DATE'
					}
				]
	    	},{
				fieldLabel: '사업명',
				name:'COST_POOL',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('getHumanCostPool')
			},{
				fieldLabel: '보훈구분',
				name: 'AGENCY_KIND',
				id: 'AGENCY_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H084'
			},{
				fieldLabel: '장애구분',
				name: 'HITCH_KIND',
				id: 'HITCH_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H085'
			},{
				fieldLabel: '직렬',
				name: 'AFFIL_CODE',
				id: 'AFFIL_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H173'
			},{
				fieldLabel: '급여지급방식',
				name: 'PAY_CODE',
				id: 'PAY_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H028'
			},{
				fieldLabel: '지급차수',
				name: 'PAY_PROV_FLAG',
				id: 'PAY_PROV_FLAG',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H031'
			},{
				fieldLabel: '사원그룹',
				name: 'PERSON_GROUP',
				id: 'PERSON_GROUP',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H181'
			},{
				fieldLabel: '담당업무',
				name: 'JOB_CODE',
				id: 'JOB_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H008'
			}]
		}*/]     	
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
		        comboType	: 'BOR120',
		        multiSelect	: true, 
		        typeAhead	: false,
				value		: UserInfo.divCode,
				width		: 325,
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
				colspan:2,
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
    			fieldLabel: '입사일',
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
				fieldLabel: '사원',
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
					},
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);				
					}
				}
			}),{ 
    			fieldLabel: '퇴사일',
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
	        },{
            	fieldLabel: '인원합계 표시',
            	margin: '0 0 0 40',
            	labelWidth: 100,
            	name: 'CHKCNT',
				uncheckedValue: 'N',
        		inputValue: 'Y',
				xtype: 'checkbox',
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('CHKCNT', newValue);
					}
				}
			},{
                fieldLabel: '재직구분',
                xtype: 'radiogroup',
                columns: [60,60,60],
                items: [{
	            		boxLabel: '전체',
						name: 'RDO_TYPE',
						inputValue: ''
					},{
						boxLabel: '재직',
						name: 'RDO_TYPE',
						inputValue: '1',
						checked: true
					},{
						boxLabel: '퇴사',
						name: 'RDO_TYPE',
						inputValue: '00000000'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
						}
					}
            },{
                fieldLabel: '성별',
                xtype: 'radiogroup',
                columns: [60,60,60],
                items: [{
						boxLabel: '전체',
						name: 'SEX_CODE',
						inputValue: '',
						checked: true 
					},{
						boxLabel: '남',
						name: 'SEX_CODE',
						inputValue: 'M'
					},{
						boxLabel: '여',
						name: 'SEX_CODE',
						inputValue: 'F'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('SEX_CODE').setValue(newValue.SEX_CODE);
						}
					}
            }]
    });
   
    
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('ham101ukrGrid1', {
		store	: directMasterStore1,
		region	: 'center',
        layout	: 'fit',
    	uniOpt : {					
			useMultipleSorting	: true,		
		    useLiveSearch		: true,		
		    onLoadSelectFirst	: false,			
		    dblClickToEdit		: true,		
		    useGroupSummary		: true,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: true,
		 	copiedRow			: true,	
		    filter: {				
				useFilter		: true,
				autoCreate		: true
			}			
		},				
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
	          	if(record.get('GUBUN') == '2') {	//소계
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
	    },
        columns: [
        	{dataIndex: 'PERSON_NUMB',				width: 100},
        	{dataIndex: 'NAME',						width: 100},
        	{dataIndex: 'REPRE_NUM',				width: 100, hidden: true},
			{dataIndex: 'REPRE_NUM_EXPOS',           width: 100},        	
        	{dataIndex: 'DIV_CODE',					width: 90},
        	{dataIndex: 'BILL_DIV_CODE',			width: 90},
    		{dataIndex: 'DEPT_CODE'	,				width: 100,
			  editor: Unilite.popup('DEPT_G', {
			  		autoPopup: true,
 	 				DBtextFieldName: 'TREE_CODE',
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
									rtnRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
									rtnRecord.set('DEPT_CODE', '');
									rtnRecord.set('DEPT_NAME', '');
							},
							applyextparam: function(popup){
								
							}									
						}
				})
			},
    		{dataIndex: 'DEPT_NAME'			, width: 120,
			  editor: Unilite.popup('DEPT_G', {
			  		autoPopup: true,
 	 				DBtextFieldName: 'TREE_NAME',
					listeners: {'onSelected': {
						fn: function(records, type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
								rtnRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
								rtnRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
							},
						scope: this	
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;	
								rtnRecord.set('DEPT_CODE', '');
								rtnRecord.set('DEPT_NAME', '');
						},
						applyextparam: function(popup){
							
						}									
					}
				})
			},
        	{dataIndex: 'JOIN_DATE',				width: 110},
        	{dataIndex: 'RETR_DATE',				width: 110},
        	{dataIndex: 'RETR_RESN',				width: 150},
        	{dataIndex: 'BANK_CODE1'			, width: 66,
			  editor: Unilite.popup('BANK_G', {
			  		autoPopup: true,
 	 				DBtextFieldName: 'BANK_CODE',
					listeners: {'onSelected': {
						fn: function(records, type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
								rtnRecord.set('BANK_CODE1', records[0]['BANK_CODE']);
								rtnRecord.set('BANK_NAME1', records[0]['BANK_NAME']);
							},
						scope: this	
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;	
								rtnRecord.set('BANK_CODE1', '');
								rtnRecord.set('BANK_NAME1', '');
						},
						applyextparam: function(popup){
							
						}									
					}
				})
			},
    		{dataIndex: 'BANK_NAME1'			, width: 80,
			  editor: Unilite.popup('BANK_G', {
			  		autoPopup: true,
 	 				DBtextFieldName: 'BANK_NAME',
					listeners: {'onSelected': {
						fn: function(records, type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;	
								rtnRecord.set('BANK_CODE1', records[0]['BANK_CODE']);
								rtnRecord.set('BANK_NAME2', records[0]['BANK_NAME']);
							},
						scope: this	
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;	
								rtnRecord.set('BANK_CODE1', '');
								rtnRecord.set('BANK_NAME2', '');
						},
						applyextparam: function(popup){
							
						}									
					}
				})
			},
        	{dataIndex: 'BANK_ACCOUNT1',			width: 150 , hidden: true},
        	{dataIndex: 'BANK_ACCOUNT1_EXPOS' ,		width: 120 },	        	
        	{dataIndex: 'BANKBOOK_NAME1',			width: 100 }
//        	{dataIndex: 'SEX_CODE',					width: 100, hidden: true}
        /*
			{dataIndex: 'DIV_CODE',				width: 150},
			//{dataIndex: 'DEPT_CODE',			width: 130},
			{dataIndex: 'DEPT_NAME',			width: 160},
			{dataIndex: 'POST_CODE',			width: 100},
			//{dataIndex: 'PERSON_CNT',			width: 100},
			
			{dataIndex: 'NAME',					width: 100,
			renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('GUBUN') == '2') {	
						return val + '명';
					} else {
						return val;
					}
	            }
			},
			{dataIndex: 'PERSON_NUMB',			width: 100 },
			{dataIndex: 'NAME_ENG',				width: 120 , hidden: true},
			{dataIndex: 'NAME_CHI',				width: 100 , hidden: true},
			{dataIndex: 'DOC_ID',				width: 50  , hidden: true},
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
			{dataIndex: 'ANNUAL_SALARY_I',		width: 100 , hidden: false},
			{dataIndex: 'WAGES_STD_I',			width: 100 , hidden: false},
			{dataIndex: 'PAY_PRESERVE_I',		width: 100 , hidden: false},
			{dataIndex: 'BONUS_KIND',			width: 100 , hidden: true}, // hidden: ture
			{dataIndex: 'BONUS_STD_I',			width: 100 , hidden: true}, // hidden: true
			{dataIndex: 'COM_YEAR_WAGES',		width: 100 , hidden: false},  // hidden: true
			{dataIndex: 'TAX_CODE',				width: 100 , hidden: false},
			{dataIndex: 'TAX_CODE2',			width: 100 , hidden: false},
			
			{dataIndex: 'ANU_BASE_I',			width: 100 , hidden: false},
			{dataIndex: 'ANU_INSUR_I',			width: 100 },
			{dataIndex: 'MED_AVG_I',			width: 100 , hidden: false},
			{dataIndex: 'MED_INSUR_I',			width: 100 , hidden: false},
			{dataIndex: 'ORI_MED_INSUR_I',		width: 100 , hidden: false},
			{dataIndex: 'OLD_MED_INSUR_I',		width: 100 , hidden: false},
			{dataIndex: 'HIRE_AVG_I',			width: 100 , hidden: false},
			{dataIndex: 'HIRE_INSUR_I',			width: 100 , hidden: false},
			
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
			
			{dataIndex: 'PAY_PROV_YN',			width: 100 , hidden: false},
			{dataIndex: 'PAY_PROV_STOP_YN',		width: 100 , hidden: false},
			{dataIndex: 'COMP_TAX_I',			width: 100 , hidden: false},
			{dataIndex: 'HIRE_INSUR_TYPE',		width: 100 , hidden: false},
			{dataIndex: 'BONUS_PROV_YN',		width: 100 , hidden: false},
			{dataIndex: 'YEAR_GIVE',			width: 100 , hidden: false},
			{dataIndex: 'YEAR_CALCU',			width: 100 , hidden: false},
			{dataIndex: 'LABOR_UNON_YN',		width: 100 , hidden: false},
			{dataIndex: 'RETR_GIVE',			width: 100 , hidden: false},
			{dataIndex: 'RETR_PENSION_KIND',	width: 100 , hidden: false},
			
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
			
			{dataIndex: 'OFFICE_CODE',			width: 100 , hidden: false},
			{dataIndex: 'ROUTE_GROUP',			width: 100 , hidden: false},
			{dataIndex: 'LICENSE_KIND',			width: 100 , hidden: false},
			{dataIndex: 'LICENSE_NO',			width: 100 , hidden: false},
			{dataIndex: 'LICENSE_ACQ_DATE',		width: 100 , hidden: false},
			{dataIndex: 'LICENSE_FRDATE',		width: 100 , hidden: false},
			{dataIndex: 'LICENSE_TODATE',		width: 100 , hidden: false},
			{dataIndex: 'BUS_CERTIFICATE',		width: 100 , hidden: false},
			{dataIndex: 'CERTI_ACQ_DATE',		width: 100 , hidden: false},
			{dataIndex: 'CIVIL_DEF_YN',			width: 100 , hidden: false},
			{dataIndex: 'CIVIL_DEF_NUM',		width: 100 , hidden: false},
			{dataIndex: 'MEMO_1',				width: 100 , hidden: false},
			{dataIndex: 'MEMO_2',				width: 100 , hidden: false}
			
			*/
        ],
        listeners: {
        	beforeedit: function(editor, e){
        		/*
        		if(e.record.get('GUBUN') == '2'){
        			return false;
        		}
        		*/
        		if(!e.record.phantom){
        			if(e.field == 'PERSON_NUMB'){
	        			return false;
	        		}
        		}   
        		if (e.field == "REPRE_NUM_EXPOS" || e.field == 'BANK_ACCOUNT1_EXPOS')	{
					return false;
				}
				return true;
        	}, 
        	edit: function(editor, e) { console.log(e);
				var fieldName = e.field;
				if(e.value == e.originalValue) return false;
				if(fieldName == 'REPRE_NUM'){
					var newValue = e.value.replace('-', '');
					if(newValue.length == 13){
						var reperNum = newValue.substr(0, 6) + '-' + newValue.substr(6, 7);
						var sexNo = newValue.substr(6, 1);
						if(sexNo == '1'){
							e.record.set('SEX_CODE', 'M');	//주민번호 자리수에 따라 성별 SET
						}else if(sexNo == '2'){
							e.record.set('SEX_CODE', 'F');	//주민번호 자리수에 따라 성별 SET							
						}else{
							alert(Msg.sMB174);	//잘못된 주민등록번호를 입력하셨습니다.
							e.record.set(fieldName, e.originalValue);
							return false;						
						}
						e.record.set(fieldName, reperNum);
					}else{
						alert(Msg.sMB174);	//잘못된 주민등록번호를 입력하셨습니다.
						e.record.set(fieldName, e.originalValue);
						return false;
					}
				}
			},	
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(colName =="REPRE_NUM_EXPOS") {
					grid.ownerGrid.openCryptRepreNoPopup(record);
				}else if(colName =="BANK_ACCOUNT1_EXPOS") {
					grid.ownerGrid.openCryptBankAcntPopup(record);
				}
          	}
			/*itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
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
	            {	text	: '인사기본자료등록 보기',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoHam101ukr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoHam101ukr:function(record)	{
			if(record)	{
		    	var params = {
		    		action:'select',
			    	'PGM_ID' 			: 'ham101ukr',
			    	'PERSON_NUMB' 		:  record.data['PERSON_NUMB'],					 gsParam(0) 
			    	'NAME' 				:  record.data['NAME'],							 gsParam(1) 
			    	'COMP_CODE' 		:  UserInfo.compCode,							 gsParam(2) 
			    	'DOC_ID'			:  record.data['DOC_ID']  						 gsParam(3) 
			    	
		    	}
		    	var rec1 = {data : {prgID : 'hum100ukr', 'text':''}};							
				parent.openTab(rec1, '/human/hum100ukr.do', params);	    	
			}*/
    	},
    	openCryptRepreNoPopup:function( record )	{
		  	if(record)	{
				var params = {'REPRE_NO': record.get('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
			}
				
		},
		openCryptBankAcntPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT1'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT1_EXPOS', 'BANK_ACCOUNT1', params);
			}
				
		}
    });
    var decrypBtn = Ext.create('Ext.Button',{
        text:'복호화',
        width: 80,
        handler: function() {
            var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
            if(needSave){
               alert(Msg.sMB154); //먼저 저장하십시오.
               return false;
            }
            panelSearch.setValue('DEC_FLAG', 'Y');
            UniAppManager.app.onQueryButtonDown();
            panelSearch.setValue('DEC_FLAG', '');
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
      id  : 'ham101ukrApp',
      fnInitBinding : function() {
         panelSearch.setValue('DIV_CODE',UserInfo.divCode);
         UniAppManager.setToolbarButtons('detail',true);
         UniAppManager.setToolbarButtons(['reset','newData'], true);
            //복호화 버튼 툴바에 추가
            var tbar = masterGrid._getToolBar();
            tbar[0].insert(tbar.length + 2, decrypBtn);
            
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');         
      },
      onQueryButtonDown : function()   {
         masterGrid.getStore().loadStoreRecords();
      },
		onNewDataButtonDown : function() {			
			var r = {
				JOIN_DATE: UniDate.get('today')	
			};
			masterGrid.createRow(r, 'PERSON_NUMB');
		},
		onSaveDataButtonDown : function() {
			if (masterGrid.getStore().isDirty()) {
				// 입력데이터 validation				
				masterGrid.getStore().saveStore();
			}
		},
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown : function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
		}
   });

    /*
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
    */
    function checkVisible(newValue) {
    	//var value = Ext.getCmp('oriRadio').items.get(0).getGroupValue();
		if (newValue == '2') {
			
			Ext.getCmp('PAY_GU2').setVisible(true);
		} else {
			Ext.getCmp('PAY_GU2').setVisible(false);
		}
    }
    
    
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {
				case "REPRE_NUM" :
		 			var f	= '2468';
		 			var m	= '1357';
		 			var v	= newValue;
		 			var param={'REPRE_NUM' : v};											//중복체크 해야하나?
		 			
		 			if (Unilite.validate('residentno', v) == true) {
		 				v = v.replace('-','');
		 				
		 			} else {
		 				if (confirm('잘못된 주민번호를 입력하셨습니다. 잘못된 주민번호를 저장하시겠습니까? 주민번호:'+v))	{

		 				} else {
		 					record.set('REPRE_NUM', '');
							rv = false;
							break;
		 				}
		 			}
//		 			ham101ukrService.chkRepreNum(param, function(provider, response) {
//						if(provider.data.CNT != 0) {
//							if(!confirm('중복된 주민번호가 존재합니다. 계속 진행하시겠습니까? 사번:'+v))	{
//								field.setValue('');
//							}
//						}
//					});					 			
				
					break;
				
			}
			return rv;
		}
	});	
	
};


</script>