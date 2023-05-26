<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum210skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hum210skrModel1', {
	    fields: [
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.human.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120'},
			{name: 'DEPT_NAME'			, text: '<t:message code="system.label.human.department" default="부서"/>'		, type: 'string'},
			{name: 'POST_CODE'				, text: '<t:message code="system.label.human.postcode" default="직위"/>'		, type: 'string' 	, comboType:'AU'	, comboCode:'H005'},
			{name: 'NAME'						, text: '<t:message code="system.label.human.name" default="성명"/>'		, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, type: 'string'},
			{name: 'SCHOOL_NAME'		, text: '<t:message code="system.label.human.schoolname" default="학교명"/>'		, type: 'string'},
			{name: 'ENTR_DATE'				, text: '<t:message code="system.label.human.entrdate" default="입학년도"/>'		, type: 'string'},
			{name: 'GRAD_DATE'			, text: '<t:message code="system.label.human.graddate" default="졸업년도"/>'		, type: 'string'},
			{name: 'ADDRESS'					, text: '<t:message code="system.label.human.address" default="소재지"/>'		, type: 'string'},
			{name: 'FIRST_SUBJECT'		, text: '<t:message code="system.label.human.firstsubject" default="전공과목"/>'		, type: 'string'},
			{name: 'DEGREE'					, text: '<t:message code="system.label.human.degree" default="학위"/>'		, type: 'string'},
			{name: 'CREDITS'					, text: '<t:message code="system.label.human.credits" default="취득학점"/>'		, type: 'string'},
			{name: 'SPECIAL_ITEM'			, text: '<t:message code="system.label.human.specialitem" default="특기사항"/>'		, type: 'string'}
     
	    ]
	});
	
	Unilite.defineModel('Hum210skrModel2', {
	    fields: [
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.human.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120'},
			{name: 'DEPT_NAME'			, text: '<t:message code="system.label.human.department" default="부서"/>'		, type: 'string'},
			{name: 'POST_CODE'				, text: '<t:message code="system.label.human.postcode" default="직위"/>'		, type: 'string' 	, comboType:'AU'	, comboCode:'H005'},
			{name: 'NAME'						, text: '<t:message code="system.label.human.name" default="성명"/>'		, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, type: 'string'},
			{name: 'PASS_NO'					, text: '<t:message code="system.label.human.passno" default="여권번호"/>'	, type: 'string'},
			{name: 'PASS_KIND'				, text: '<t:message code="system.label.human.passkind" default="여권구분"/>'	, type: 'string'},
			{name: 'ISSUE_DATE'				, text: '<t:message code="system.label.human.issuedate" default="발급일"/>'		, type: 'string'},
			{name: 'TERMI_DATE'			, text: '<t:message code="system.label.human.termidate" default="만료일"/>'		, type: 'string'},
			{name: 'VISA_NO'					, text: '<t:message code="system.label.human.visano" default="비자번호"/>'	, type: 'string'},
			{name: 'NATION_NAME'		, text: '<t:message code="system.label.human.nationname" default="국가명"/>'		, type: 'string'},
			{name: 'VISA_GUBUN'			, text: '<t:message code="system.label.human.visagubun" default="비자구분"/>'	, type: 'string'},
			{name: 'VISA_KIND'				, text: '<t:message code="system.label.human.visakind" default="비자종류"/>'	, type: 'string' , comboType:'AU', comboCode:'H088'},
			{name: 'VALI_DATE'				, text: '<t:message code="system.label.human.validate" default="유효일"/>'		, type: 'string'},
			{name: 'DURATION_STAY'	, text: '<t:message code="system.label.human.durationstay" default="체류가능일"/>'	, type: 'string'},
			{name: 'TERMI_DATE1'			, text: '<t:message code="system.label.human.termidate" default="만료일"/>'		, type: 'string'},
			{name: 'ISSUE_DATE1'			, text: '<t:message code="system.label.human.issuedate" default="발급일"/>'		, type: 'string'},
			{name: 'ISSUE_AT'					, text: '<t:message code="system.label.human.issueat" default="발급지"/>'		, type: 'string'}
		]
	});
	
	Unilite.defineModel('Hum210skrModel3', {
	    fields: [
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.human.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120'},
			{name: 'DEPT_NAME'			, text: '<t:message code="system.label.human.department" default="부서"/>'		, type: 'string'},
			{name: 'POST_CODE'				, text: '<t:message code="system.label.human.postcode" default="직위"/>'		, type: 'string' 	, comboType:'AU'	, comboCode:'H005'},
			{name: 'NAME'						, text: '<t:message code="system.label.human.name" default="성명"/>'		, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, type: 'string'},
			{name: 'EDU_TITLE'				, text: '<t:message code="system.label.human.edutitle" default="교육명"/>'		, type: 'string'},
			{name: 'EDU_FR_DATE'			, text: '<t:message code="system.label.human.startdate" default="시작일"/>'		, type: 'string'},
			{name: 'EDU_TO_DATE'			, text: '<t:message code="system.label.human.enddate" default="종료일"/>'		, type: 'string'},
			{name: 'EDU_ORGAN'			, text: '<t:message code="system.label.human.eduorgan" default="교육기관"/>'		, type: 'string', comboType:'AU' , comboCode:'H089'},
			{name: 'EDU_NATION'			, text: '<t:message code="system.label.human.edunation" default="교육국가"/>'		, type: 'string', comboType:'AU' , comboCode:'H090'},
			{name: 'EDU_GUBUN'			, text: '<t:message code="system.label.human.type" default="구분"/>'		        , type: 'string', comboType:'AU' , comboCode:'H091'},
			{name: 'EDU_GRADES'			, text: '<t:message code="system.label.human.edugrades" default="이수점수"/>'		, type: 'string'},
			{name: 'EDU_AMT'					, text: '<t:message code="system.label.human.eduusei" default="교육비"/>'		, type: 'string'},
			{name: 'REPORT_YN'				, text: '<t:message code="system.label.human.reportyn" default="Report 제출여부"/>'		, type: 'string'},
			{name: 'GRADE'						, text: '<t:message code="system.label.human.appraisalapplyyn" default="고과반영점수"/>'		, type: 'string'}			
			
		]
	});
	
	Unilite.defineModel('Hum210skrModel4', {
	    fields: [
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.human.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120'},
			{name: 'DEPT_NAME'			, text: '<t:message code="system.label.human.department" default="부서"/>'		, type: 'string'},
			{name: 'POST_CODE'				, text: '<t:message code="system.label.human.postcode" default="직위"/>'		, type: 'string' 	, comboType:'AU'	, comboCode:'H005'},
			{name: 'NAME'						, text: '<t:message code="system.label.human.name" default="성명"/>'		, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, type: 'string'},
			{name: 'FOREIGN_KIND'		, text: '<t:message code="system.label.human.foreignkind" default="외국어구분"/>'		, type: 'string', comboType:'AU', comboCode:'H092'},
			{name: 'EXAM_KIND'				, text: '<t:message code="system.label.human.examkind" default="시험종류"/>'		, type: 'string', comboType:'AU', comboCode:'H093'},
			{name: 'GAIN_DATE'				, text: '<t:message code="system.label.human.gaindate" default="취득년월"/>'		, type: 'string'},
			{name: 'GRADES'					, text: '<t:message code="system.label.human.grades" default="점수"/>'		, type: 'string'},
			{name: 'CLASS'						, text: '<t:message code="system.label.human.grade" default="등급"/>'		, type: 'string'},
			{name: 'VALI_DATE'				, text: '<t:message code="system.label.human.validate" default="유효일"/>'		, type: 'string'},
			{name: 'BIGO'							, text: '<t:message code="system.label.human.remark" default="비고"/>'		, type: 'string'}
		]
	});
	
/*	Unilite.defineModel('Hum210skrModel5', {
	    fields: [
			{name: 'DIV_CODE'										, text: '<t:message code="system.label.human.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120'},
			{name: 'DEPT_NAME'									, text: '<t:message code="system.label.human.department" default="부서"/>'		, type: 'string'},
			{name: 'POST_CODE'										, text: '<t:message code="system.label.human.postcode" default="직위"/>'		, type: 'string' 	, comboType:'AU'	, comboCode:'H005'},
			{name: 'NAME'												, text: '<t:message code="system.label.human.name" default="성명"/>'		, type: 'string'},
			{name: 'PERSON_NUMB'								, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, type: 'string'},
			{name: 'RECOMMEND1_NAME'					, text: '<t:message code="system.label.human.name" default="성명"/>'		, type: 'string'},
			{name: 'RECOMMEND1_RELATION'			, text: '<t:message code="system.label.human.relcode" default="관계"/>'		, type: 'string'},
			{name: 'RECOMMEND1_OFFICE_NAME'	, text: '<t:message code="system.label.human.officename" default="직장명"/>'		, type: 'string'},
			{name: 'RECOMMEND1_CLASS'					, text: '<t:message code="system.label.human.postcode" default="직위"/>'		, type: 'string'},
			{name: 'RECOMMEND1_ZIP_CODE'			, text: '<t:message code="system.label.human.zipcode" default="우편번호"/>'		, type: 'string'},
			{name: 'ADDRESS1'										, text: '<t:message code="system.label.human.address2" default="주소"/>'		, type: 'string'},
			{name: 'RECOMMEND2_NAME'					, text: '<t:message code="system.label.human.name" default="성명"/>'		, type: 'string'},
			{name: 'RECOMMEND2_RELATION'			, text: '<t:message code="system.label.human.relcode" default="관계"/>'		, type: 'string'},
			{name: 'RECOMMEND2_OFFICE_NAME'	, text: '<t:message code="system.label.human.officename" default="직장명"/>'		, type: 'string'},
			{name: 'RECOMMEND2_CLASS'					, text: '<t:message code="system.label.human.postcode" default="직위"/>'		, type: 'string'},
			{name: 'RECOMMEND2_ZIP_CODE'			, text: '<t:message code="system.label.human.zipcode" default="우편번호"/>'		, type: 'string'},
			{name: 'ADDRESS2'										, text: '<t:message code="system.label.human.address2" default="주소"/>'	, type: 'string'}
		]
	});*/
	
/*	Unilite.defineModel('Hum210skrModel6', {
	    fields: [
			{name: 'DIV_CODE'								, text: '<t:message code="system.label.human.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120'},
			{name: 'DEPT_NAME'							, text: '<t:message code="system.label.human.department" default="부서"/>'		, type: 'string'},
			{name: 'POST_CODE'								, text: '<t:message code="system.label.human.postcode" default="직위"/>'		, type: 'string' 	, comboType:'AU'	, comboCode:'H005'},
			{name: 'NAME'										, text: '<t:message code="system.label.human.name" default="성명"/>'		, type: 'string'},
			{name: 'PERSON_NUMB'						, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, type: 'string'},
			{name: 'INSURANCE_NAME'				, text: '<t:message code="system.label.human.insurancename" default="보험명"/>'		, type: 'string'},
			{name: 'GUARANTEE_PERIOD_FR'		, text: '<t:message code="system.label.human.guaranteeperiodfr" default="보증기간 FR"/>'		, type: 'string'},
			{name: 'GUARANTEE_PERIOD_TO'		, text: '<t:message code="system.label.human.guaranteeperiodto" default="보증기간 TO"/>'		, type: 'string'},
			{name: 'GUARANTOR1_NAME'			, text: '<t:message code="system.label.human.name" default="성명"/>'		, type: 'string'},
			{name: 'GUARANTOR1_RELATION'		, text: '<t:message code="system.label.human.relcode" default="관계"/>'		, type: 'string'},
			{name: 'GUARANTOR1_PERIOD_FR'	, text: '<t:message code="system.label.human.guaranteeperiodfr" default="보증기간 FR"/>'		, type: 'string'},
			{name: 'GUARANTOR1_PERIOD_TO'	, text: '<t:message code="system.label.human.guaranteeperiodto" default="보증기간 TO"/>'		, type: 'string'},
			{name: 'GUARANTOR2_NAME'			, text: '<t:message code="system.label.human.name" default="성명"/>'		, type: 'string'},
			{name: 'GUARANTOR2_RELATION'		, text: '<t:message code="system.label.human.relcode" default="관계"/>'		, type: 'string'},
			{name: 'GUARANTOR2_PERIOD_FR'	, text: '<t:message code="system.label.human.guaranteeperiodfr" default="보증기간 FR"/>'		, type: 'string'},
			{name: 'GUARANTOR2_PERIOD_TO'	, text: '<t:message code="system.label.human.guaranteeperiodto" default="보증기간 TO"/>'		, type: 'string'}
		]
	});*/
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('hum210skrMasterStore1',{
		model: 'Hum210skrModel1',
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
                read: 'hum210skrService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( "param",param );
			this.load({
				params : param
			});
		}
// 		groupField: 'ITEM_NAME'
	});
	
	var directMasterStore2 = Unilite.createStore('hum210skrMasterStore2',{
		model: 'Hum210skrModel2',
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
                read: 'hum210skrService.selectList2'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
// 		groupField: 'ITEM_NAME'
	});
	
	var directMasterStore3 = Unilite.createStore('hum210skrMasterStore3',{
		model: 'Hum210skrModel3',
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
                read: 'hum210skrService.selectList3'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
// 		groupField: 'ITEM_NAME'
	});
	
	var directMasterStore4 = Unilite.createStore('hum210skrMasterStore4',{
		model: 'Hum210skrModel4',
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
                read: 'hum210skrService.selectList4'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
// 		groupField: 'ITEM_NAME'
	});
	
/*	var directMasterStore5 = Unilite.createStore('hum210skrMasterStore5',{
		model: 'Hum210skrModel5',
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
                read: 'hum210skrService.selectList5'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
// 		groupField: 'ITEM_NAME'
	});*/
	
/*	var directMasterStore6 = Unilite.createStore('hum210skrMasterStore6',{
		model: 'Hum210skrModel6',
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
                read: 'hum210skrService.selectList6'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
// 		groupField: 'ITEM_NAME'
	});*/
	
	var baseMenu = {	
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{ 
	        	fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
	        	id: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	value :'01'      	
        	},
			    Unilite.popup('DEPT',{ 
					    fieldLabel: '<t:message code="system.label.human.department" default="부서"/>', 
					    textFieldWidth: 170, 
					    validateBlank: false, 
					    popupWidth: 400
				}),   	
					Unilite.popup('DEPT',{ 
					    fieldLabel: '~',
					    valueFieldName: 'DEPT_CODE2',
				    	textFieldName: 'DEPT_NAME2',
					    textFieldWidth: 170, 
					    validateBlank: false, 
					    popupWidth: 400
				}),					
					Unilite.popup('Employee',{ 
					     
                     textFieldWidth: 170, 
					 validateBlank: false, 
					 popupWidth: 400,
    			     listeners: {
                            onSelected: {
                                fn: function(records, type) {
//                                  baseMenu.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//                                  baseMenu.setValue('NAME', panelSearch.getValue('NAME'));                                                                                                         
                                },
                                scope: this
                            },
                            onClear: function(type) {
                              panelSearch.setValue('PERSON_NUMB', '');
                              panelSearch.setValue('NAME', '');
                        }
                     }
				}),
				{	
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
					width: 400,
					layout : {type : 'hbox', align : 'stretch'},
					id: 'RETR_DATE',
					items: [{
						boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
						width: 70, 
						name: 'RETR_DATE',
						inputValue: ''  
					},{
						boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>', 
						width: 70,
						name: 'RETR_DATE',
						inputValue: '00000000',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
						width: 70, 
						name: 'RETR_DATE',
						inputValue: 'R'
					}]
				}
			]};
		
	
	var menu1 = {
			title:'<t:message code="system.label.human.addinfo" default="추가정보"/>',
				id: 'menu1',
			itemId:'menu1',    		
    		items:[
    		{	
    			fieldLabel: '<t:message code="system.label.human.schoolname" default="학교명"/>',
	        	name: 'SCHOOL_NAME', 
	        	id: 'SCHOOL_NAME', 
	        	xtype: 'uniTextfield'	        	     				
			},{	
    			fieldLabel: '<t:message code="system.label.human.firstsubject" default="전공과목"/>',
	        	name: 'FIRST_SUBJECT', 
	        	id: 'FIRST_SUBJECT', 
	        	xtype: 'uniCombobox', 
	        	comboType:'AU',
	        	comboCode:'H087'
			}
		]				
	};
	
	var menu2 = {
			title:'<t:message code="system.label.human.addinfo" default="추가정보"/>',
				id: 'menu2',
			itemId:'menu2',
    		items:[
    		{	
    			fieldLabel: '<t:message code="system.label.human.passno" default="여권번호"/>',
	        	name: 'PASS_NO', 
	        	id: 'PASS_NO', 
	        	xtype: 'uniTextfield'	        	     				
			},
			{	
    			fieldLabel: '<t:message code="system.label.human.visano" default="비자번호"/>',
	        	name: 'VISA_NO', 
	        	id: 'VISA_NO', 
	        	xtype: 'uniTextfield'	        	     				
			},
			{	
    			fieldLabel: '<t:message code="system.label.human.nationname" default="국가명"/>',
	        	name: 'NATION_NAME', 
	        	id: 'NATION_NAME', 
	        	xtype: 'uniTextfield'	        	     				
			},
			{	
    			fieldLabel: '<t:message code="system.label.human.validate" default="유효일"/>',
	        	name: 'VALI_DATE', 
	        	id: 'VALI_DATE', 
	        	xtype: 'uniDatefield'	        	     				
			}
         ]						
	};
	
	var menu3 = {
			title:'<t:message code="system.label.human.addinfo" default="추가정보"/>',
			id: 'menu3',
		itemId:'menu3',
		items:[
			{	
				fieldLabel: '<t:message code="system.label.human.edutitle" default="교육명"/>',
				name: 'EDU_TITLE', 
				id: 'EDU_TITLE', 
				xtype: 'uniTextfield'	        	     				
			},
			{ 
				fieldLabel: '<t:message code="system.label.human.edudate" default="교육기간"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'EDU_FR_DATE',
	        	endFieldName: 'EDU_TO_DATE',
	        	width: 470
// 	        	startDate: UniDate.get('today'),
// 	        	endDate: UniDate.get('today'),	        	
        	}
		]
	}
	
	var menu4 = {
			title:'<t:message code="system.label.human.addinfo" default="추가정보"/>',
			id: 'menu4',
		itemId:'menu4',
		items:[
			{	
				fieldLabel: '<t:message code="system.label.human.foreignkind" default="외국어구분"/>',
				name: 'FOREIGN_KIND', 
				id: 'FOREIGN_KIND', 
				xtype: 'uniCombobox', 
				comboType:'AU',
	        	comboCode:'H092'	        				
			},
			{	
    			fieldLabel: '<t:message code="system.label.human.examkind" default="시험종류"/>',
	        	name: 'EXAM_KIND', 
	        	id: 'EXAM_KIND', 
	        	xtype: 'uniCombobox', 
	        	comboType:'AU',
	        	comboCode:'H093'        				
			},
			{	
    			fieldLabel: '<t:message code="system.label.human.grades" default="점수"/>',
	        	name: 'GRADES', 
	        	id: 'GRADES', 
	        	xtype: 'uniTextfield'	        	     				
			}
		]
	}
	
/*	var menu5 = {
			title:'<t:message code="system.label.human.addinfo" default="추가정보"/>',
			id: 'menu5',
		itemId:'menu5',
		items:[
			{	
				fieldLabel: '<t:message code="system.label.human.recommendname" default="추천인 성명"/>',
				name: 'RECOMMEND_NAME', 
				id: 'RECOMMEND_NAME', 
				xtype: 'uniTextfield'	        	     				
			}
		]
	}*/
	
	
/*	var menu6 = {
			title:'<t:message code="system.label.human.addinfo" default="추가정보"/>',
			id: 'menu6',
		itemId:'menu6',
		items:[
			{ 
				fieldLabel: '<t:message code="system.label.human.termidate" default="만료일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'DT_FR',
				endFieldName: 'DT_TO',
				width: 470
// 				startDate: UniDate.get('today'),
// 				endDate: UniDate.get('today'),				
			}
		]
	}*/
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [baseMenu, menu1]		
	});	//end panelSearch
	
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
     var masterGrid1 = Unilite.createGrid('hum210skrGrid1', {
     	title: '<t:message code="system.label.human.academicbackground" default="학력사항"/>',
     	layout : 'fit',
         region : 'center',
         store : directMasterStore1,
         selModel:'rowmodel',
         uniOpt:{	expandLastColumn:   false,
         			useRowNumberer:     true,
                    useMultipleSorting: true
         },
         
         columns: [        
             {dataIndex: 'DIV_CODE'		, width: 80	, locked: true},            
             {dataIndex: 'DEPT_NAME'	, width: 80	, locked: true},
             {dataIndex: 'POST_CODE'	, width: 80	, locked: true},
             {dataIndex: 'NAME'			, width: 80	, locked: true},
             {dataIndex: 'PERSON_NUMB'	, width: 80	, locked: true},
             {dataIndex: 'SCHOOL_NAME'	, width: 130	},
             {dataIndex: 'ENTR_DATE'	, width: 130	},
             {dataIndex: 'GRAD_DATE'	, width: 130	},
             {dataIndex: 'ADDRESS'		, width: 130	},
             {dataIndex: 'FIRST_SUBJECT', width: 130	},	
             {dataIndex: 'DEGREE'		, width: 130	},
             {dataIndex: 'CREDITS'		, width: 130	},
             {dataIndex: 'SPECIAL_ITEM'	, width: 130	} 
         ]  	        
     });
     

     var masterGrid2 = Unilite.createGrid('hum210skrGrid2', {
      	title: '<t:message code="system.label.human.passportvisa" default="여권비자"/>',
      	layout : 'fit',
          region : 'center',
          store : directMasterStore2,
          selModel:'rowmodel',
          uniOpt:{	expandLastColumn: false,
          			useRowNumberer: true,
                      useMultipleSorting: true
          },
          
          columns: [        
              {dataIndex: 'DIV_CODE'		, width: 80	, locked: true},            
              {dataIndex: 'DEPT_NAME'		, width: 80	, locked: true},
              {dataIndex: 'POST_CODE'		, width: 80	, locked: true},
              {dataIndex: 'NAME'			, width: 80	, locked: true},
              {dataIndex: 'PERSON_NUMB'		, width: 80	, locked: true},
              {dataIndex: 'PASS_NO'			, width: 130 },
              {dataIndex: 'PASS_KIND'		, width: 130 },
              {dataIndex: 'ISSUE_DATE'		, width: 130 },
              {dataIndex: 'TERMI_DATE'		, width: 130 },
              {dataIndex: 'VISA_NO'			, width: 130 },
              {dataIndex: 'NATION_NAME'		, width: 130 },
              {dataIndex: 'VISA_GUBUN'		, width: 130 },
              {dataIndex: 'VISA_KIND'		, width: 130 },
              {dataIndex: 'VALI_DATE'		, width: 130 },
              {dataIndex: 'DURATION_STAY'	, width: 130 },
              {dataIndex: 'TERMI_DATE1'		, width: 130 },
              {dataIndex: 'ISSUE_DATE1'		, width: 130 },
              {dataIndex: 'ISSUE_AT'		, width: 130 }                       
               
          ]  	        
      });
     
     var masterGrid3 = Unilite.createGrid('hum210skrGrid3', {
      	title: '<t:message code="system.label.human.educationinfo" default="교육사항"/>',
      	layout : 'fit',
          region : 'center',
          store : directMasterStore3,
          selModel:'rowmodel',
          uniOpt:{	expandLastColumn: false,
          			useRowNumberer: true,
                      useMultipleSorting: true
          },
          
          columns: [        
              {dataIndex: 'DIV_CODE'		, width: 80	, locked: true},            
              {dataIndex: 'DEPT_NAME'		, width: 80	, locked: true},
              {dataIndex: 'POST_CODE'		, width: 80	,   locked: true},
              {dataIndex: 'NAME'			, width: 80	,   locked: true},
              {dataIndex: 'PERSON_NUMB'		, width: 80	,   locked: true},
              {text: '<t:message code="system.label.human.edudate" default="교육기간"/>', 
            	columns:[
				{dataIndex: 'EDU_FR_DATE'	, width: 130},
				{dataIndex: 'EDU_TO_DATE'	, width: 130}
               ]},
               {dataIndex: 'EDU_TITLE'		, width: 130	},
               {dataIndex: 'EDU_ORGAN'		, width: 130	},
               {dataIndex: 'EDU_NATION'		, width: 130	},
               {dataIndex: 'EDU_GUBUN'		, width: 130	},
               {dataIndex: 'EDU_GRADES'		, width: 130	},
               {dataIndex: 'EDU_AMT'		, width: 130	},
               {dataIndex: 'REPORT_YN'		, width: 130	},
               {dataIndex: 'GRADE'			, width: 130	}           
               
          ]  	        
      });
     
     var masterGrid4 = Unilite.createGrid('hum210skrGrid4', {
      	title: '<t:message code="system.label.human.teachqualification" default="어학자격"/>',
      	layout : 'fit',
          region : 'center',
          store : directMasterStore4,
          selModel:'rowmodel',
          uniOpt:{	expandLastColumn: false,
          			useRowNumberer: true,
                      useMultipleSorting: true
          },
          
          columns: [        
              {dataIndex: 'DIV_CODE'		, width: 80	, locked: true},            
              {dataIndex: 'DEPT_NAME'		, width: 80	, locked: true},
              {dataIndex: 'POST_CODE'		, width: 80	, text: '<t:message code="system.label.human.postcode" default="직위"/>',   locked: true},
              {dataIndex: 'NAME'			, width: 80	, text: '<t:message code="system.label.human.name" default="성명"/>',   locked: true},
              {dataIndex: 'PERSON_NUMB'		, width: 80	, text: '<t:message code="system.label.human.personnumb" default="사번"/>',   locked: true},
              {dataIndex: 'FOREIGN_KIND'	, width: 130	, text: '<t:message code="system.label.human.foreignkind" default="외국어구분"/>'},
              {dataIndex: 'EXAM_KIND'		, width: 130	, text: '<t:message code="system.label.human.examkind" default="시험종류"/>'},
              {dataIndex: 'GAIN_DATE'		, width: 130	, text: '<t:message code="system.label.human.gaindate" default="취득년월"/>'},
              {dataIndex: 'GRADES'			, width: 130	, text: '<t:message code="system.label.human.grades" default="점수"/>'},
              {dataIndex: 'CLASS'			, width: 130	, text: '<t:message code="system.label.human.grade" default="등급"/>'},
              {dataIndex: 'VALI_DATE'		, width: 130	, text: '<t:message code="system.label.human.validate" default="유효일"/>'},
              {dataIndex: 'BIGO'			, width: 130	, text: '<t:message code="system.label.human.remark" default="비고"/>'}        
               
          ]  	        
      });
     
/*     var masterGrid5 = Unilite.createGrid('hum210skrGrid5', {
      	title: '<t:message code="system.label.human.recommend" default="추천인"/>',
      	layout : 'fit',
          region : 'center',
          store : directMasterStore5, 
          uniOpt:{	expandLastColumn: false,
          			useRowNumberer: true,
                      useMultipleSorting: true
          },
          
          columns: [        
              {dataIndex: 'DIV_CODE'			, width: 80	, locked: true},            
              {dataIndex: 'DEPT_NAME'		, width: 80	, locked: true},
              {dataIndex: 'POST_CODE'		, width: 80	, text: '<t:message code="system.label.human.postcode" default="직위"/>',   locked: true},
              {dataIndex: 'NAME'					, width: 80	, text: '<t:message code="system.label.human.name" default="성명"/>',   locked: true},
              {dataIndex: 'PERSON_NUMB'		, width: 80	, text: '<t:message code="system.label.human.personnumb" default="사번"/>',   locked: true},
              {text: '<t:message code="system.label.human.recommend" default="추천인"/>', 
	              	columns:[
	  				{dataIndex: 'RECOMMEND1_NAME'				, width: 130	, text: '<t:message code="system.label.human.name" default="성명"/>'},
	  				{dataIndex: 'RECOMMEND1_RELATION'			, width: 130	, text: '<t:message code="system.label.human.relcode" default="관계"/>'},
	  				{dataIndex: 'RECOMMEND1_OFFICE_NAME'	, width: 130	, text: '<t:message code="system.label.human.officename" default="직장명"/>'},
	  				{dataIndex: 'RECOMMEND1_CLASS'				, width: 130	, text: '<t:message code="system.label.human.postcode" default="직위"/>'},
	  				{dataIndex: 'RECOMMEND1_ZIP_CODE'			, width: 130	, text: '<t:message code="system.label.human.zipcode" default="우편번호"/>'},
	  				{dataIndex: 'ADDRESS1'							, width: 130	, text: '<t:message code="system.label.human.address2" default="주소"/>'}
               ]},
               {text: '<t:message code="system.label.human.recommend" default="추천인"/>2', 
                 	columns:[
     				{dataIndex: 'RECOMMEND2_NAME'				, width: 130	, text: '<t:message code="system.label.human.name" default="성명"/>'},
     				{dataIndex: 'RECOMMEND2_RELATION'			, width: 130	, text: '<t:message code="system.label.human.relcode" default="관계"/>'},
     				{dataIndex: 'RECOMMEND2_OFFICE_NAME'	, width: 130	, text: '<t:message code="system.label.human.officename" default="직장명"/>'},
     				{dataIndex: 'RECOMMEND2_CLASS'				, width: 130	, text: '<t:message code="system.label.human.postcode" default="직위"/>'},
     				{dataIndex: 'RECOMMEND2_ZIP_CODE'			, width: 130	, text: '<t:message code="system.label.human.zipcode" default="우편번호"/>'},
     				{dataIndex: 'ADDRESS2'							, width: 130	, text: '<t:message code="system.label.human.address2" default="주소"/>'}
               ]}   
               
          ]  	        
      });*/
     
/*     var masterGrid6 = Unilite.createGrid('hum210skrGrid6', {
      	title: '<t:message code="system.label.human.guarantor" default="보증인"/>',
      	layout : 'fit',
          region : 'center',
          store : directMasterStore6, 
          uniOpt:{	expandLastColumn: false,
          			useRowNumberer: true,
                      useMultipleSorting: true
          },
          
          columns: [        
              {dataIndex: 'DIV_CODE'			, width: 80	, locked: true},            
              {dataIndex: 'DEPT_NAME'		, width: 80	, locked: true},
              {dataIndex: 'POST_CODE'		, width: 80	, text: '<t:message code="system.label.human.postcode" default="직위"/>',   locked: true},
              {dataIndex: 'NAME'					, width: 80	, text: '<t:message code="system.label.human.name" default="성명"/>',   locked: true},
              {dataIndex: 'PERSON_NUMB'		, width: 80	, text: '<t:message code="system.label.human.personnumb" default="사번"/>',   locked: true},
              {text: '<t:message code="system.label.human.guarantinsur" default="보증보험"/>', 
	              	columns:[
	  				{dataIndex: 'INSURANCE_NAME'					, width: 130	, text: '<t:message code="system.label.human.insurancename" default="보험명"/>'},
	  				{text: '<t:message code="system.label.human.guaranteeperiod" default="보증기간"/>', 
		              	columns:[
		  				{dataIndex: 'GUARANTEE_PERIOD_FR'		, width: 130	, text: '시작'},
		  				{dataIndex: 'GUARANTEE_PERIOD_TO'		, width: 130	, text: '종료'}		  				
	            	]}
             ]},
             {text: '<t:message code="system.label.human.guarantor" default="보증인"/>1', 
	              	columns:[
	  				{dataIndex: 'GUARANTOR1_NAME'				, width: 130	, text: '<t:message code="system.label.human.name" default="성명"/>'},
	  				{dataIndex: 'GUARANTOR1_RELATION'			, width: 130	, text: '<t:message code="system.label.human.relcode" default="관계"/>'},
	  				{text: '<t:message code="system.label.human.guaranteeperiod" default="보증기간"/>', 
		              	columns:[
		  				{dataIndex: 'GUARANTOR1_PERIOD_FR'		, width: 130	, text: '시작'},
		  				{dataIndex: 'GUARANTOR1_PERIOD_TO'	, width: 130	, text: '종료'}		  				
	            	]}
            ]},
            {text: '<t:message code="system.label.human.guarantor" default="보증인"/>2', 
	              	columns:[
	  				{dataIndex: 'GUARANTOR2_NAME'				, width: 130	, text: '<t:message code="system.label.human.name" default="성명"/>'},
	  				{dataIndex: 'GUARANTOR2_RELATION'			, width: 130	, text: '<t:message code="system.label.human.relcode" default="관계"/>'},
	  				{text: '<t:message code="system.label.human.guaranteeperiod" default="보증기간"/>', 
		              	columns:[
		  				{dataIndex: 'GUARANTOR2_PERIOD_FR'		, width: 130	, text: '시작'},
		  				{dataIndex: 'GUARANTOR2_PERIOD_TO'	, width: 130	, text: '종료'}		  				
	            	]}
	        ]}

               
          ]  	        
      });*/
	
	
	/**
     * TabPanel 정의(Tab)
     * @type 
     */
     var tabPanel = Ext.create('Ext.tab.Panel',{    	 
         region : 'center',
         layout: {type: 'vbox', align: 'stretch'},
 		 bodyCls: 'human-panel-form-background',
 		 items: [
 		         masterGrid1,
 		         masterGrid2,
 		         masterGrid3,
 		         masterGrid4
 		         //masterGrid5,
 		         //masterGrid6
 		 ],
 		 listeners: {
 			 tabchange: function(){
 				var activeTabId = tabPanel.getActiveTab().getId();
 				panelSearch.removeAll(); 
 				panelSearch.add(baseMenu);
 				
 				if(activeTabId == 'hum210skrGrid1'){
 					panelSearch.add(menu1);
 				 }else if(activeTabId == 'hum210skrGrid2'){ 					
 					 panelSearch.add(menu2);
 				 }else if(activeTabId == 'hum210skrGrid3'){
 					panelSearch.add(menu3);
 				 }else if(activeTabId == 'hum210skrGrid4'){
 					panelSearch.add(menu4);
 				 }
 				 
 /*				 else if(activeTabId == 'hum210skrGrid5'){
 					panelSearch.add(menu5);
 				 }else if(activeTabId == 'hum210skrGrid6'){
 					panelSearch.add(menu6);
 				 } */
 				//panelSearch.doLayout();
 			 }
 		 }
     })
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[ 
		 		 tabPanel
				,panelSearch
		], 
		id : 'hum210skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);			
		},
		onQueryButtonDown : function()	{		
			var activeTabId = tabPanel.getActiveTab().getId();
			
			if(activeTabId == 'hum210skrGrid1'){				
				directMasterStore1.loadStoreRecords();				
			}else if(activeTabId == 'hum210skrGrid2'){				
				directMasterStore2.loadStoreRecords();				
			}else if(activeTabId == 'hum210skrGrid3'){				
				directMasterStore3.loadStoreRecords();				
			}else if(activeTabId == 'hum210skrGrid4'){				
				directMasterStore4.loadStoreRecords();				
			}
			
			/*else if(activeTabId == 'hum210skrGrid5'){				
				directMasterStore5.loadStoreRecords();				
			}else if(activeTabId == 'hum210skrGrid6'){				
				directMasterStore6.loadStoreRecords();				
			}*/
			
// 			var viewLocked = tab.getActiveTab().lockedGrid.getView();
// 			var viewNormal = tab.getActiveTab().normalGrid.getView();
// 			console.log("viewLocked : ",viewLocked);
// 			console.log("viewNormal : ",viewNormal);
// 			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
// 			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
// 			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
// 			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
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
