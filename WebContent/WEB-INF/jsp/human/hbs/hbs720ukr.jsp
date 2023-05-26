<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbs720ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직급 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 동의여부 Y/N -->
	/*<t:ExtComboStore comboType="AU" comboCode="A018" /> <!-- 데이터유형-->*/
	/*<t:ExtComboStore comboType="AU" comboCode="A004" /> <!-- 사용여부-->*/
	/*<t:ExtComboStore comboType="AU" comboCode="A147" /> <!-- 데이터포맷-->*/
	/*<t:ExtComboStore comboType="AU" comboCode="H032" opts='6;9'/>   <!--지급구분 -->*/
	/*<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->*/
</t:appConfig>

<style type="text/css">
    #search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>

<script type="text/javascript" >

/**
 * 인사/급여관리 < 보상관리 < 계약관리 < 연봉확정관리
 */


function appMain() {     
//    var editWindow; // 가율계산 popup
//    var fixCnt = 0; //수정횟수
    var rowCnt = 0;

	/**
	 * Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('Hbs720ukrModel', {
	    fields: [  	  
	    
//		    {name: 'COMP_CODE'            ,text: '법인코드'         ,type: 'string',    editable: false},
//		    {name: 'ESS_FLAG'            ,text: '대사우반영'         ,type: 'string',    editable: false},
//		    {name: 'ESS_FLAG_ORI'        ,text: '대사우반영(ori)'    ,type: 'string',    editable: false},
//		    {name: 'AGRN_DATE'            ,text: '동의일자'         ,type: 'string',    editable: false},
//            {name: 'CNRC_YEAR'            ,text: '연봉계약년도'       ,type : 'string',   editable: false},
//            {name: 'MERITS_YEARS'         ,text: '기준년도'         ,type : 'string',   editable: false},
//		    {name: 'DEPT_CODE'            ,text: '부서코드'         ,type: 'string',    editable: false},
//            {name: 'DEPT_NAME'            ,text: '부서명'          ,type: 'string',    editable: false},
//            {name: 'POST_CODE'            ,text: '직위'           ,type: 'string',    comboType:'AU', comboCode:'H005', editable: false},
//            {name: 'ABIL_CODE'            ,text: '직급'           ,type: 'string',    comboType:'AU', comboCode:'H006', editable: false},
//            {name: 'PERSON_NUMB'          ,text: '사번'           ,type : 'string',   editable: false},
//            {name: 'NAME'                 ,text: '성명'           ,type: 'string',    editable: false},
//            {name: 'JOIN_DATE'            ,text: '입사일'          ,type: 'uniDate',   editable: false},
//            //인상반영
//            {name: 'MERITS_BSE_AMT'       ,text: '평가기준년도 기본급'   ,type: 'uniPrice',   editable: false, editable: false}, 
//            {name: 'MERITS_CLASS'         ,text: '고과등급'         ,type: 'string',    editable: false, editable: false}, 
//            {name: 'ADTN_RATE'            ,text: '가율(%)'         ,type: 'uniPercent',  editable: false, editable: false}, 
//            {name: 'RSNG_AMT'             ,text: '기본급인상액'       ,type: 'uniPrice',  editable: false, editable: false}, 
//            {name: 'AVRG_PMTN_AMT'        ,text: '평균호봉승급액'      ,type: 'uniPrice',  editable: false, editable: false}, 
//            //기본연봉
//            {name: 'BSE_AMT'              ,text: '기본급'           ,type: 'uniPrice',  editable: false},
//            {name: 'BNS_ALWN'             ,text: '상여수당'          ,type: 'uniPrice',  editable: false},
//            {name: 'MNGM_ALWN'            ,text: '관리업무수당'        ,type: 'uniPrice',  editable: false},
//            {name: 'CNWK_ALWN'            ,text: '근속수당'          ,type: 'uniPrice',  editable: false},
//            {name: 'ABIL_ASST_EXPN'       ,text: '직급보조비'         ,type: 'uniPrice',  editable: false},
//            {name: 'RSP_EXPN'             ,text: '효도휴가비'         ,type: 'uniPrice',  editable: false},
//            {name: 'CHFD_ASST_EXPN'       ,text: '급식보조비'         ,type: 'uniPrice',  editable: false},
//            //부가급여
//            {name: 'BZNS_PRGS_EXPN'       ,text: '직책급 업무추진비'     ,type: 'uniPrice',  editable: false},
//            {name: 'TCHN_ALWN'            ,text: '기술자격수당'        ,type: 'uniPrice',  editable: false},
//            {name: 'BZNS_ALWN'            ,text: '업무수당'          ,type: 'uniPrice',  editable: false},
//            {name: 'DEV_BZNS_ALWN'        ,text: '개발업무수당'        ,type: 'uniPrice',  editable: false},
//            {name: 'FMLY_ALWN'            ,text: '가족수당'          ,type: 'uniPrice',  editable: false},
//            {name: 'SCEXP_ASST_ALWN'      ,text: '학비보조수당'        ,type: 'uniPrice'},
//            {name: 'TRET_ALWN'            ,text: '대우수당'          ,type: 'uniPrice',  editable: false},
//            {name: 'WAGES_STD_I'          ,text: '월지급액'          ,type: 'uniPrice',  editable: false},
//            {name: 'ADD_AMT'              ,text: '월지급액+'        ,type: 'uniPrice'},
//            {name: 'SUB_AMT'              ,text: '월지급액-'        ,type: 'uniPrice'},
//            
//            {name: 'ANNUAL_SALARY_I'      ,text: '연봉'            ,type: 'uniPrice',  editable: false},
//            {name: 'MERIT_PAY'            ,text: '성과연봉'          ,type: 'uniPrice'},
//            {name: 'RMK'                  ,text: '비고'            ,type: 'string' } 
            
            
            ///////
            {name: 'COMP_CODE'         ,text: '법인코드'          ,type: 'string',     editable: false},
            {name: 'CNRC_YEAR'         ,text: '연봉계약년도'        ,type : 'string',    editable: false},
            {name: 'MERITS_YEARS'      ,text: '기준년도'          ,type : 'string',    editable: false},
            {name: 'DEPT_CODE'         ,text: '부서코드'          ,type: 'string',     editable: false},
            {name: 'DEPT_NAME'         ,text: '부서명'           ,type: 'string',     editable: false},
            {name: 'ABIL_CODE'         ,text: '직급'            ,type: 'string',     comboType:'AU', comboCode:'H006', editable: false},
            {name: 'PERSON_NUMB'       ,text: '사번'            ,type : 'string',    editable: false},
            {name: 'NAME'              ,text: '성명'            ,type: 'string',     editable: false},
            {name: 'JOIN_DATE'         ,text: '입사일'           ,type: 'uniDate',    editable: false},
            {name: 'ANNUAL_SALARY_I'   ,text: '연봉'             ,type: 'uniPrice',   editable: false},
            {name: 'WAGES_STD_I_TOT'   ,text: '월지급액'           ,type: 'uniPrice',   editable: false},
            {name: 'AGRN_YN'           ,text: '동의여부'          ,type: 'string',     comboType:'AU', comboCode:'A020',editable: false},
            {name: 'AGRN_DATE'         ,text: '동의일자'          ,type: 'string',     editable: false},
            {name: 'DECS_YN'           ,text: '연봉확정여부'        ,type: 'string',     comboType:'AU', comboCode:'A020',editable: false},
            {name: 'DECS_YN_ORI'       ,text: '연봉확정여부(ori)'   ,type: 'string',     comboType:'AU', comboCode:'A020',editable: false},
            {name: 'RMK'               ,text: '비고'            ,type: 'string',     editable: false }
            
            

		    
		]         	
	});

		  
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'hbs720ukrService.selectMasterList',
        	update: 'hbs720ukrService.updateMaster',
            // create: 'hbs720ukrService.insertMaster',
            // destroy: 'hbs720ukrService.deleteMaster',
			syncAll: 'hbs720ukrService.saveAll'
        }
	});
	

	  
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	var directMasterStore = Unilite.createStore('hbs720ukrMasterStore1',{
		model: 'Hbs720ukrModel',
		uniOpt: {
            isMaster: false,		// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable:false,		// 삭제 가능 여부
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directMasterProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();			
			console.log( param );
			this.load({
				params : param,
				callback : function(records,options,success)	{
					
					if(success)	{
                        // if(directMasterStore.isDirty()){
                            UniAppManager.setToolbarButtons('reset', true);
                            rowCnt = 0;
                            
                        // }else{
                        // }
                            
					}
				}
			});
			
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var config = {
					params:[panelResult.getValues()],
					success : function()	{
						
					}
				}
				this.syncAllDirect(config);			
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
			rowCnt = 0 ; //초기화
			
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
           		if(records != null && records.length > 0 ){
//           			 // 대상자생성 버튼 비활성화
//           			Ext.getCmp('refCreate').setDisabled(true);
//                    // 지급율계산 버튼 활성화
//           			Ext.getCmp('calcAvg').setDisabled(false); 
//           			//공제금액계산 버튼 활성화
//           			Ext.getCmp('calc').setDisabled(false);
//           			//급여반영 버튼 활성화
//                    Ext.getCmp('calcAmt').setDisabled(false);
//                     //대사우반영 버튼 비활성화
//                    Ext.getCmp('commitESS').setDisabled(false);

           		}
           		else{
//                    // 대상자생성 버튼 활성화 - refCreate
//                    Ext.getCmp('refCreate').setDisabled(false);
//                    // 평균호봉승급액걔산 비활성화 - calcAvg
//                    Ext.getCmp('calcAvg').setDisabled(true);
//                    //가율계산 버튼 비활성화
//                    Ext.getCmp('calc').setDisabled(true);
//                    //상세금액계산 버튼 비활성화
//                    Ext.getCmp('calcAmt').setDisabled(true);
//                    //대사우반영 버튼 비활성화
//                    Ext.getCmp('commitESS').setDisabled(true);

           		}
           		rowCnt = 0 ; //초기화
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
//				UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
//				if( store.isDirty())	{
////					UniAppManager.setToolbarButtons('save', true);	
//					UniAppManager.setToolbarButtons('save', false);	
//				}else {
//					UniAppManager.setToolbarButtons('save', false);
//				}
			}
		}
	});

	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
        items: [		    
            {
                fieldLabel: '연봉계약년도',
                name: 'CNRC_YEAR',
                xtype: 'uniYearField',
                value: new Date().getFullYear(),
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('MERITS_YEARS', newValue - 1);   
                    }
                }
            },
            {
                fieldLabel: '기준년도',
                name: 'MERITS_YEARS',
                xtype: 'uniYearField',
                value: new Date().getFullYear() - 1 ,
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('CNRC_YEAR', newValue + 1);          
                    }
                }
            },
//            {
//                xtype:'component',
//                width: 200,
//                colspan     : 6
//                },
            {
                fieldLabel: '동의여부',
                name:'AGRN_YN', 
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'A020'
//                valueWidth: 20, 
//                width: 320
            },
            {
                fieldLabel: '연봉확정여부',
                name:'DECS_YN', 
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'A020'
//                valueWidth: 20, 
//                width: 320
            },
            
            Unilite.popup('DEPT', {
                fieldLabel: '부서', 
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                listeners: {                
                    applyextparam: function(popup){
                        
                    }
                }
            }),
            Unilite.popup('Employee',{
                fieldLabel: '사원',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                validateBlank:false,
                listeners: {
                    applyextparam: function(popup){ 
                    }
                }
            }),
            {
                fieldLabel: '직급',
                name:'ABIL_CODE', 
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H006',
                valueWidth: 20, 
                width: 320
            }
//            {
//                xtype:'component',
//                width: 230,
//                colspan     : 1
//            },
            
//            {                           
//                fieldLabel: '평균호봉승급액',
//                name    : 'AVRG_PMTN_AMT',
//                xtype   : 'uniNumberfield', 
//                value   : 0,                                        
//                width   : 200,
//                listeners: {
//                    change: function(field, newValue, oldValue, eOpts) {                        
//                    }
//                }
//            },
//            {
//                xtype: 'button',
//                name: 'COMMIT_AVRG_AMT',
//                text: '평균호봉승급액반영',
//                width: 140,
//                margin: '0 0 2 0',
//                handler: function() {
//                       
//                    if(confirm('평균호봉승급액을 반영 시 기존데이터는 삭제됩니다. \n 평균호봉승급액을 반영하시겠습니까?')) {
//                        Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
//                        var param = panelResult.getValues();
//                        hbs720ukrService.commitAvrgAmt(param, function(provider, response) {
//                            if (provider != 0){
//                                alert('평균호봉승급액 반영 실패');
//                            } else {
//                                Ext.Msg.alert('확인', '평균호봉승급액 반영이 완료되었습니다.');
//                            }
//                            
//                            Ext.getCmp('pageAll').getEl().unmask();
//                            // 조회
//                            directMasterStore.loadStoreRecords();
//                        });
//                    }
//                    
//                }
//            }
		]	
    });
    
        // 가율계산 POPUP
//    var editForm = Unilite.createSearchForm('hbs720ukrPopupForm', {
//        layout: {type: 'uniTable', columns : 3},
//        defaults:{
//            labelWidth:80,
//            width:240
//        },
//        defaultType:'textfield',
//        items: [
//            {
//                xtype:'container',
//                html: '<font color=blue size=5><b>&nbsp;◆&nbsp;가&nbsp;율&nbsp;(%)&nbsp;관&nbsp;리&nbsp;</b></font>',
//                colspan     : 3
//            },
//            {
//                xtype:'container',
//                html: '<font color=red size=2><b>&nbsp;</b></font>',
//                colspan     : 3
//            },
//    
//            {
//                fieldLabel: '연봉계약년도',
//                name: 'CNRC_YEAR',
//                xtype: 'uniYearField',
//                value: new Date().getFullYear(),
//                allowBlank: false,
//                labelWidth:125,
//                listeners: {
//                    change: function(field, newValue, oldValue, eOpts) {                        
//                        editForm.setValue('MERITS_YEARS', newValue - 1);          
//                    }
//                }
//            },
//            {
//                fieldLabel: '기준년도',
//                name: 'MERITS_YEARS',
//                xtype: 'uniYearField',
//                value: new Date().getFullYear() - 1 ,
//                allowBlank: false,
//                labelWidth:125,
//                listeners: {
//                    change: function(field, newValue, oldValue, eOpts) {                        
//                        editForm.setValue('CNRC_YEAR', newValue + 1);          
//                    }
//                }
//            },
//
//            {
//                xtype:'container',
//                html: '<font color=red size=5><b>&nbsp;</b></font>',
//                colspan     : 3
//    
//            },
//            {
//                xtype:'container',
//                html: '<font color=red size=5><b>&nbsp;</b></font>',
//                colspan     : 3
//            },
//                 {
//                xtype:'container',
//                html: '<font color=red><b>&nbsp;&nbsp;&nbsp;1.기준 비율 등록&nbsp;</b></font>',
//                colspan     : 3
//    
//            },	
//            {
//                fieldLabel: '기준비율(우) %',
//                name: 'STD_RATE',
//                xtype:'uniNumberfield',
//                decimalPrecision: 2,
//                colspan:3,
//                value:0,
//                suffixTpl:'%',
//                labelWidth:125,
//                listeners: {
//                    blur : function () {
//                    	editForm.getField('S_GRADE').setReadOnly(true);
//                        editForm.getField('A_GRADE').setReadOnly(true);
//                        editForm.getField('B_GRADE').setReadOnly(true);
//                        editForm.getField('C_GRADE').setReadOnly(true);
//                        editForm.getField('Z_GRADE').setReadOnly(true);
//                    	
//                        if(this.value == null){
//                        	this.setValue(0);
//                            return;
//                        }
//                    }
//                }
//            },
//            {
//                fieldLabel: '차이율(수-가)%',
//                name: 'DIFF_RATE',
//                xtype:'uniNumberfield',
//                decimalPrecision: 2,
//                colspan:3,
//                value:0,
//                suffixTpl:'%',
//                labelWidth:125,
//                listeners: {
//                    blur : function () {
//                    	editForm.getField('S_GRADE').setReadOnly(true);
//                        editForm.getField('A_GRADE').setReadOnly(true);
//                        editForm.getField('B_GRADE').setReadOnly(true);
//                        editForm.getField('C_GRADE').setReadOnly(true);
//                        editForm.getField('Z_GRADE').setReadOnly(true);
//                    	
//                        if(this.value == null){
//                        	this.setValue(0);
//                            return;
//                        }
//                    }
//                  }
//            },
//            {
//                fieldLabel: '미평가(Z)%',
//                name: 'NN_RATE',
//                xtype:'uniNumberfield',
//                decimalPrecision: 2,
//                colspan:1,
//                value:0,
//                suffixTpl:'%',
//                labelWidth:125,
//                listeners: {
//                    blur : function () {
//                    	editForm.getField('S_GRADE').setReadOnly(true);
//                        editForm.getField('A_GRADE').setReadOnly(true);
//                        editForm.getField('B_GRADE').setReadOnly(true);
//                        editForm.getField('C_GRADE').setReadOnly(true);
//                        editForm.getField('Z_GRADE').setReadOnly(true);
//                    	
//                        if(this.value == null){
//                        	this.setValue(0);
//                            return;
//                        }
//                    }
//                  }
//            },
//            {
//                fieldLabel: '계산',
//                xtype: 'button',
//                text: '1.가율 계산',
//                width: 100,
//                margin: '0 0 5 50',
//                colspan:2,
//                name: 'VEHICLE_NAME',
//                handler: function() {
//                	
//                	editForm.setValue('S_GRADE', 0); 
//                    editForm.setValue('A_GRADE', 0); 
//                    editForm.setValue('B_GRADE', 0);
//                    editForm.setValue('C_GRADE', 0);
//                	
//                	
//                	
//                	var stRate = editForm.getValue('STD_RATE');
//                	var diffRate = editForm.getValue('DIFF_RATE');
//                	var unvalRate = editForm.getValue('NN_RATE');
//                	
//                	if(editForm.getValue('STD_RATE') == 0 ){
//                	   alert('기준비율을 입력해주세요.');
//                	}else if (editForm.getValue('DIFF_RATE') == 0 ){
//                	   alert('차이율을 입력해주세요.');
//                	}else if (editForm.getValue('NN_RATE') == 0 ){
//                       alert('미평가율을 입력해주세요.');
//                    }else{
//                        editForm.setValue('S_GRADE', stRate + (diffRate/3)); 
//                        editForm.setValue('A_GRADE', stRate); 
//                        editForm.setValue('B_GRADE', stRate - (diffRate/3));
//                        editForm.setValue('C_GRADE', stRate - (diffRate/3*2));
//                        editForm.setValue('Z_GRADE', unvalRate);
//    
//                        editForm.getField('S_GRADE').setReadOnly(false);
//                        editForm.getField('A_GRADE').setReadOnly(false);
//                        editForm.getField('B_GRADE').setReadOnly(false);
//                        editForm.getField('C_GRADE').setReadOnly(false);
//                        editForm.getField('Z_GRADE').setReadOnly(false);
//                    
//                    }
//                }
//            },
//            {
//                xtype:'container',
//                html: '<font color=red size=5><b>&nbsp;</b></font>',
//                colspan     : 3
//            },
//            {
//                xtype:'container',
//                html: '<font color=red><b>&nbsp;&nbsp;&nbsp;2.가율 계산&nbsp;</b></font>',
//                colspan     : 3
//            },  
//            {
//                fieldLabel: '수 등급',
//                name: 'S_GRADE',
//                xtype:'uniNumberfield',
//                decimalPrecision: 2,
//                suffixTpl:'%',
//                readOnly: true,
//                value:0,
//                colspan:3,
//                labelWidth:125,
//                listeners: {
//                    blur : function () {
//                    	var sGrade = editForm.getValue('S_GRADE');
//                    	var aGrade = editForm.getValue('A_GRADE');
//                    	var bGrade = editForm.getValue('B_GRADE');
//                    	var cGrade = editForm.getValue('C_GRADE');
//                        
//                        if(this.value == null){
//                        	this.setValue(0);
//                        	editForm.setValue('DIFF_RATE', (sGrade - aGrade)  + (aGrade - bGrade) + (bGrade - cGrade));
//                            return;
//                        }else {
//                            editForm.setValue('DIFF_RATE', (sGrade - aGrade)  + (aGrade - bGrade) + (bGrade - cGrade));
//                            
//                        }
//                        
//                    }
//                }
//            },
//            {
//                fieldLabel: '우 등급(기준)',
//                name: 'A_GRADE',
//                xtype:'uniNumberfield',
//                decimalPrecision: 2,
//                suffixTpl:'%',
//                readOnly: true,
//                value:0,
//                colspan:3,
//                labelWidth:125,
//                listeners: {
//                    blur : function () {
//                        var sGrade = editForm.getValue('S_GRADE');
//                        var aGrade = editForm.getValue('A_GRADE');
//                        var bGrade = editForm.getValue('B_GRADE');
//                        var cGrade = editForm.getValue('C_GRADE');
//                        
//                        if(this.value == null){
//                            this.setValue(0);
//                            editForm.setValue('DIFF_RATE', (sGrade - aGrade)  + (aGrade - bGrade) + (bGrade - cGrade));
//                            editForm.setValue('STD_RATE', this.value);
//                            return;
//                        }else {
//                            editForm.setValue('DIFF_RATE', (sGrade - aGrade)  + (aGrade - bGrade) + (bGrade - cGrade));
//                            editForm.setValue('STD_RATE', this.value);
//                        }
//                        
//                    }
//                }
//            },
//            {
//                fieldLabel: '양 등급',
//                name: 'B_GRADE',
//                xtype:'uniNumberfield',
//                decimalPrecision: 2,
//                suffixTpl:'%',
//                readOnly: true,
//                value:0,
//                colspan:3,
//                labelWidth:125,
//                listeners: {
//                    blur : function () {
//                        var sGrade = editForm.getValue('S_GRADE');
//                        var aGrade = editForm.getValue('A_GRADE');
//                        var bGrade = editForm.getValue('B_GRADE');
//                        var cGrade = editForm.getValue('C_GRADE');
//                        
//                        if(this.value == null){
//                            this.setValue(0);
//                            editForm.setValue('DIFF_RATE', (sGrade - aGrade)  + (aGrade - bGrade) + (bGrade - cGrade));
//                            return;
//                        }else {
//                            editForm.setValue('DIFF_RATE', (sGrade - aGrade)  + (aGrade - bGrade) + (bGrade - cGrade));
//                        }
//                        
//                    }
//                }
//            },
//            {
//                fieldLabel: '가 등급',
//                name: 'C_GRADE',
//                xtype:'uniNumberfield',
//                decimalPrecision: 2,
//                suffixTpl:'%',
//                readOnly: true,
//                value:0,
//                colspan:3,
//                labelWidth:125,
//                listeners: {
//                    blur : function () {
//                        var sGrade = editForm.getValue('S_GRADE');
//                        var aGrade = editForm.getValue('A_GRADE');
//                        var bGrade = editForm.getValue('B_GRADE');
//                        var cGrade = editForm.getValue('C_GRADE');
//                        
//                        if(this.value == null){
//                            this.setValue(0);
//                            editForm.setValue('DIFF_RATE', (sGrade - aGrade)  + (aGrade - bGrade) + (bGrade - cGrade));
//                            return;
//                        }else {
//                            editForm.setValue('DIFF_RATE', (sGrade - aGrade)  + (aGrade - bGrade) + (bGrade - cGrade));
//                        }
//                        
//                    }
//                }
//            },
//            {
//                fieldLabel: 'Z 등급',
//                name: 'Z_GRADE',
//                xtype:'uniNumberfield',
//                decimalPrecision: 2,
//                suffixTpl:'%',
//                readOnly: true,
//                value:0,
//                colspan:1,
//                labelWidth:125,
//                listeners: {
//                    blur : function () {
//                        if(this.value == null){
//                            this.setValue(0);
//                            editForm.setValue('NN_RATE', this.value);
//                            return;
//                        }else {
//                            editForm.setValue('NN_RATE', this.value);
//                        }
//                    }
//                }
//            },
//            {
//                xtype: 'button',
//                text: '2.재원 산출',
//                width: 100,
//                margin: '0 0 5 50',
//                name: 'VEHICLE_NAME',
//                colspan:2,
//                handler: function() {
//                    var param = {
//                        "S_GRADE" : editForm.getValue('S_GRADE'),
//                        "A_GRADE" : editForm.getValue('A_GRADE'),
//                        "B_GRADE" : editForm.getValue('B_GRADE'),
//                        "C_GRADE" : editForm.getValue('C_GRADE'),
//                        "Z_GRADE" : editForm.getValue('Z_GRADE'),
//                        "CNRC_YEAR" : editForm.getValue('CNRC_YEAR'),
//                        "MERITS_YEARS" : editForm.getValue('MERITS_YEARS')
//                    };            
//                    hbs720ukrService.selectSorc(param, function(provider, response) {   
//                        if(!Ext.isEmpty(provider)){
//                        	var records = response.result;
//                        	
//                            MERITS_BSE_AMT = records[0].MERITS_BSE_AMT;
//                            STD_SORC_TOT_AMT = records[0].STD_SORC_TOT_AMT;
//                            ADTN_SORC_TOT_AMT = records[0].ADTN_SORC_TOT_AMT;
//                            SORC_BALN = records[0].STD_SORC_TOT_AMT - records[0].ADTN_SORC_TOT_AMT 
//                            
//                            editForm.setValue('MERITS_BSE_AMT', MERITS_BSE_AMT);
//                            editForm.setValue('STD_SORC_TOT_AMT', STD_SORC_TOT_AMT);
//                            editForm.setValue('ADTN_SORC_TOT_AMT', ADTN_SORC_TOT_AMT);
//                            editForm.setValue('SORC_BALN', SORC_BALN);
//                        }
//                        
//                    });
//                	
//                }
//            },
//    
//            {
//                xtype:'container',
//                html: '<font color=red size=5><b>&nbsp;</b></font>',
//                colspan     : 3
//            },
//            {
//                xtype:'container',
//                html: '<font color=red><b>&nbsp;&nbsp;&nbsp;*재원 산출&nbsp;</b></font>',
//                colspan     : 3
//            }, 
//            {
//                fieldLabel: '기본급(계)',
//                name: 'MERITS_BSE_AMT',
//                xtype:'uniNumberfield',
//                value: 0 ,
//                labelWidth:125,
//                readOnly: true
//            },
//            {
//                xtype:'container',
//                html: '<font color=red size=5><b>&nbsp;</b></font>',
//                colspan     : 2
//            },
//            {
//                fieldLabel: '총재원 (기준비율%)',
//                name: 'STD_SORC_TOT_AMT',
//                xtype:'uniNumberfield',
//                value: 0,
//                labelWidth:125,
//                readOnly: true
//            },
//            {
//                fieldLabel: '가율적용 재원(총액)',
//                name: 'ADTN_SORC_TOT_AMT',
//                xtype:'uniNumberfield',
//                value: 0 ,
//                labelWidth:125,
//                readOnly: true
//            },
//            {
//                fieldLabel: '재원(잔액)',
//                name: 'SORC_BALN',
//                xtype:'uniNumberfield',
//                value: 0 ,
//                labelWidth:125,
//                readOnly: true
//            },
//            {
//                xtype:'container',
//                html: '<font color=red size=5><b>&nbsp;</b></font>',
//                colspan     : 3,
//                style: {
//                    color: 'blue'               
//                }
//            } 		
//        ]
//    });
    
//    function openWindow() {
//        if(!editWindow) {
//            editWindow = Ext.create('widget.uniDetailWindow', {
//                title: '가율(%)관리 POPUP',
//                width: 800,                         
//                height: 610,
//                layout: {type:'box', align:'stretch'},                 
//                items: [editForm],
//                tbar:  [
//                        '->',
//                        {
//                            itemId : 'calc_comfirm',
//                            // text: '*지급율 확정',
//                            text: '<font><b>&nbsp;3.가율 확정&nbsp;</b></font>',
//                            handler: function() {
//                                // 지급울 확정 로직
//                                var param = {
//                                    "S_GRADE" : editForm.getValue('S_GRADE'),
//                                    "A_GRADE" : editForm.getValue('A_GRADE'),
//                                    "B_GRADE" : editForm.getValue('B_GRADE'),
//                                    "C_GRADE" : editForm.getValue('C_GRADE'),
//                                    "Z_GRADE" : editForm.getValue('Z_GRADE'),
//                                    "CNRC_YEAR" : editForm.getValue('CNRC_YEAR'),
//                                    "MERITS_YEARS" : editForm.getValue('MERITS_YEARS')
//                                                       
//                                }; 
//                                if(confirm('가율 확정 시 기존데이터는 삭제됩니다. \n 가율 확정하시겠습니까?')) {
//                                    hbs720ukrService.commitMeritsRate(param, function(provider, response) {   
//                                        if (provider != 0){
//                                            alert('가율 확정 실패');
//                                                    
//                                        } else {
//                                            Ext.Msg.alert('확인', ' 가율 확정이 완료되었습니다..');
//                                            
//                                        }
//                                        // 조회
//                                        directMasterStore.loadStoreRecords();
//                                    });
//                                }
//                                editWindow.hide();
//                            }
//                        },
//                        {
//                            itemId : 'closeBtn',
//                            text: '닫기',
//                            handler: function() {
//                                editWindow.hide();
//                            }
//                        }
//                ],
//                listeners : {beforehide: function(me, eOpt) {
//                                editForm.clearForm();
//                                editForm.reset();
//                                editForm.getField('S_GRADE').setReadOnly(true);
//                                editForm.getField('A_GRADE').setReadOnly(true);
//                                editForm.getField('B_GRADE').setReadOnly(true);
//                                editForm.getField('C_GRADE').setReadOnly(true);
//                                editForm.getField('Z_GRADE').setReadOnly(true);
//                            },
//                            beforeclose: function( panel, eOpts )  {
//                                editForm.clearForm();
//                                editForm.reset();
//                                editForm.getField('S_GRADE').setReadOnly(true);
//                                editForm.getField('A_GRADE').setReadOnly(true);
//                                editForm.getField('B_GRADE').setReadOnly(true);
//                                editForm.getField('C_GRADE').setReadOnly(true);
//                                editForm.getField('Z_GRADE').setReadOnly(true);
//                            },
//                            show: function( panel, eOpts ) {
//                             	editForm.setValue('CNRC_YEAR', panelResult.getValue('CNRC_YEAR')) // 기준년도
//                                editForm.setValue('MERITS_YEARS', panelResult.getValue('MERITS_YEARS')) // 평가년도
//                                
//                                editWindow.center();
//                            }
//                }       
//            })
//        }
//        editWindow.show();
//    };
    
    /**
	 * Master Grid 정의
	 * 
	 * @type
	 */
    
    var masterGrid = Unilite.createGrid('hbs720ukrGrid1', {
    	layout : 'fit',
        region : 'center',
        itemId:'masterGrid',
        store : directMasterStore,
//    	uniOpt: {
//    		expandLastColumn: false,
//		 	useRowNumberer: true,
//		 	useGroupSummary     : true,
//		 	useMultipleSorting  : true
//        },
//        
        uniOpt  : {             
            useMultipleSorting  : true,     
//            useLiveSearch       : false,    
            onLoadSelectFirst   : false,        
            useGroupSummary     : true, 
            useContextMenu      : false,    
            useRowNumberer      : true, 
            expandLastColumn    : true,     
            useRowContext       : false,    
            filter: {           
                useFilter       : false,    
//                autoCreate      : true  
                autoCreate      : false  
            }           
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
            listeners: {    

              beforeselect: function(rowSelection, record, index, eOpts) {
                  if(record.get('DECS_YN') == 'Y'){
                  //hans::20190605    alert('이미 연봉확정된 데이터입니다.');
                  //hans::20190605    return false;   
                  }
              },
            	
            	
            	
            	
            	select: function(grid, selectRecord, index, rowIndex, eOpts ){ 
            		
            		if(rowCnt <0){
                        rowCnt = 0;
                    }
            		
            		//hans::20190605 if(selectRecord.get('DECS_YN') == 'N' && selectRecord.get('AGRN_YN') == 'N' /*&& selectRecord.get('AGRN_DATE') != ''*/ ){
            		if(selectRecord.get('DECS_YN') == 'N' && selectRecord.get('AGRN_YN') == 'Y'){
            		  selectRecord.set('DECS_YN', 'Y');   
            		  
            		}
            		else if(selectRecord.get('DECS_YN') == 'Y' && selectRecord.get('AGRN_YN') == 'Y'){
            		  selectRecord.set('DECS_YN', 'N');   
            		  
            		}
            		else {
              		  //hans::20190605 alert('예외상황발생');
            		  alert('동의데이터만 확정/확정취소 가능');
            		  return false;
            		}
            		
            		rowCnt = rowCnt + 1;
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                    selectRecord.set('DECS_YN', selectRecord.get('DECS_YN_ORI'));
                    
                    rowCnt = rowCnt - 1;
                }
            	
            }
        }),
        
        tbar: [
//        	{
//                xtype: 'button',
//                itemId:'refCreateButton',
//                id: 'refCreate',
//                text: '1.대상자생성',
//                handler: function() {
//                    if(confirm('대상자생성 시 기존데이터는 삭제됩니다. \n 생성 하시겠습니까?')) {
//                        Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
//                        var param = panelResult.getValues();
//                        hbs720ukrService.createBaseData (param, function(provider, response) {
//                            if (provider != 0){
//                                alert('데이터 생성 실패');
//                            } else {
////                                Ext.Msg.alert('확인', '대상자 생성이 완료되었습니다.');
//                            }
//                            Ext.getCmp('pageAll').getEl().unmask();
//                            // 조회
//                            directMasterStore.loadStoreRecords();
//                        });
//                    }
//                }
//  
//            },
            
            //평균호봉승급액 계산
//            {
//                itemId:'calcAvgButton',
//                id:'calcAvg',
//                text: '2.평균호봉승급액계산',
//                handler: function() {
//                    var param = {
//                        "CNRC_YEAR" : panelResult.getValue('CNRC_YEAR'),
//                        "MERITS_YEARS" : panelResult.getValue('MERITS_YEARS')
//                    };            
//                    hbs720ukrService.calcAvg(param, function(provider, response) {   
//                        if(!Ext.isEmpty(provider)){
//                            var records = response.result;
//                            AVRG_PMTN_AMT = records[0].AVRG_PMTN_AMT;
//                            panelResult.setValue('AVRG_PMTN_AMT', AVRG_PMTN_AMT);
//                        }
//                    });
//                    
//                }
//            },
            
//            {
//                itemId:'calcButton',
//                id:'calc',
//                text: '3.가율계산',
//                handler: function() {
////                	// 로직 확인 필요
////                   if(directMasterStore.isDirty())  {
////                        if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {                       
////                            UniAppManager.app.onSaveDataButtonDown();
////                            openWindow();
////                        }
////                        return false;
////                    }             	
//                    openWindow();
//                }
//            },
            				
//            {
//                itemId:'calcAmtButton',
//                id:'calcAmt',
//                text: '4.상세금액계산',
//                handler: function() {
//                        
//                        if(directMasterStore.isDirty())  {
//                        	alert(Msg.sMB017 + '\n먼저 저장해주시기 바랍니다.');
//                            return false;
//                        }
//                        else{
//                            if(confirm('상세금액계산 시 기존데이터는 삭제됩니다. \n 생성 하시겠습니까?')) {
//                            	
//                            Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
//                            var param = panelResult.getValues();
//                            hbs720ukrService.calcAmt(param, function(provider, response) {
//                                if (provider != 0){
//                                    // Ext.Msg.alert('확인', Msg.sMB006);
//                                    alert('데이터 생성 실패');
//                                } else {
//                                    // Ext.Msg.alert('확인', Msg.sMM389);
//                                    Ext.Msg.alert('확인', '상세금액계산이 완료되었습니다.');
//                                }
//                                Ext.getCmp('pageAll').getEl().unmask();
//                                // 조회
//                                directMasterStore.loadStoreRecords();
//                            });
//                            }
//                        
//                        }
//                    
//                }
//            },
//            {
//                itemId:'commitESSButton',
//                id:'commitESS',
//                text: '5.대사우반영',
//                handler: function() {
//                    if(rowCnt == 0){
//                        alert('대사우에 반영할 데이터를 선택하여 주십시오.');
//                    }else {
//                        if(confirm('대사우에 연봉을 반영 하시겠습니까?')) {
//                            directMasterStore.saveStore();	
//                            Ext.getCmp('pageAll').getEl().unmask();
//                        }
//                        masterGrid.getSelectionModel().deselectAll();
//                    }
//                }
//            }
                {
                    itemId:'commitAnnualSalBtn',
                    id:'commitAnnualSal',
//                    text: '연봉확정[취소]',
                    text: '<font><b>&nbsp;연봉확정[취소]&nbsp;</b></font>',
                    handler: function() {
                        if(rowCnt == 0){
                            alert('연봉확정 할  데이터를 선택하여 주십시오.');
                        }else {
                            if(confirm('연봉확정 하시겠습니까?')) {
                                directMasterStore.saveStore();  
                                Ext.getCmp('pageAll').getEl().unmask();
                            }
                            masterGrid.getSelectionModel().deselectAll();
                        }
                    }
                }

        ],
        features: [{
            id: 'masterGridSubTotal',                                                                     
            ftype: 'uniGroupingsummary',                                                                  
            showSummaryRow: false                                                                         
        },{                                                                                               
            id: 'masterGridTotal',                                                                        
            ftype: 'uniSummary',                                                                          
            showSummaryRow: false                                                                         
        }],
        columns: [        
//			{dataIndex: 'COMP_CODE'		, width: 100	, hidden: true },       //법인코드   
//			
//			{dataIndex: 'ESS_FLAG'		, width: 100    },// hidden: true },       //대사우반영   
//			{dataIndex: 'ESS_FLAG_ORI'	, width: 100	, hidden: true },       //대사우반영(ori)   
//			{dataIndex: 'AGRN_DATE'		, width: 100	, hidden: true },       //동의일자   
//			
//			{dataIndex: 'CNRC_YEAR'		, width: 100	},// hidden: true },       //연봉계약년도  
//			{dataIndex: 'MERITS_YEARS'	, width: 100	},// hidden: true },        //기준년도  
//			{dataIndex: 'DEPT_CODE'		, width: 100	, hidden: true },       //부서코드  
//			{dataIndex: 'DEPT_NAME'		, width: 140    },  //부서명
//			{dataIndex: 'POST_CODE'		, width: 80	},  // , hidden: true //직위
//			{dataIndex: 'ABIL_CODE'		, width: 140	},  // , hidden: true //직급
//			{dataIndex: 'PERSON_NUMB'	, width: 100	},  //사번
//			{dataIndex: 'NAME'		    , width: 80	},  //성명
//			{dataIndex: 'JOIN_DATE'		, width: 100	},  // , hidden: true //입사일
//
//            {text: '인상 반영',
//                columns:[    
//                    {dataIndex: 'MERITS_BSE_AMT'    , width: 140}, //기준년도 기본급
//                    {dataIndex: 'MERITS_CLASS'      , width: 100, align:'center'}, //고과등급
//                    {dataIndex: 'ADTN_RATE'         , width: 100}, //가율
//                    {dataIndex: 'RSNG_AMT'          , width: 100},  //기본급 인상액(기본급 * 가율(%))
//                    {dataIndex: 'AVRG_PMTN_AMT'     , width: 120} //평균호봉습급액
//                    
//                ]
//            },
//            
//            {text: '기본연봉',
//                columns:[    
//                    {dataIndex: 'BSE_AMT'           , width: 100},  //기본급 (기준년도 기본급  + 인상액  + 평균호봉승급액)
//                    {dataIndex: 'BNS_ALWN'          , width: 100}, //상여수당
//                    {dataIndex: 'MNGM_ALWN'         , width: 100}, //관리업무수당
//                    {dataIndex: 'CNWK_ALWN'         , width: 100}, //장기근속수당
//                    {dataIndex: 'ABIL_ASST_EXPN'    , width: 100}, //직급보조비
//                    {dataIndex: 'RSP_EXPN'          , width: 100}, //효도휴가비
//                    {dataIndex: 'CHFD_ASST_EXPN'    , width: 100} //급식보조비
//
//                ]
//            },
//            {text: '부가급여',
//                columns:[    
//                    {dataIndex: 'BZNS_PRGS_EXPN'    , width: 130}, //직책급
//                    {dataIndex: 'TCHN_ALWN'         , width: 100}, //기술자격수당
//                    {dataIndex: 'BZNS_ALWN'         , width: 100}, //업무수당
//                    {dataIndex: 'DEV_BZNS_ALWN'     , width: 100}, //개발업무수당
//                    {dataIndex: 'FMLY_ALWN'         , width: 100}, //가족수당
//                    {dataIndex: 'SCEXP_ASST_ALWN'   , width: 100}, //학비보조수당
//                    {dataIndex: 'TRET_ALWN'         , width: 100} //대우수당
//                ]
//            },
//			{dataIndex: 'WAGES_STD_I'		, width: 120},    //월지급액
//			{dataIndex: 'ADD_AMT'      ,width: 120},   //월지급액+
//			{dataIndex: 'SUB_AMT'      ,width: 120},   //월지급액-
//			{dataIndex: 'ANNUAL_SALARY_I'	, width: 120},   //연봉
//			{dataIndex: 'MERIT_PAY'		    , width: 120},   //성과연본
//			{dataIndex: 'RMK'		, width: 120}    //비고
//			
//			
			

			
			
			{dataIndex: 'COMP_CODE'         , width: 100     , hidden: true },   //법인코드   
			{dataIndex: 'CNRC_YEAR'         , width: 100     , align:'center'},  // hidden: true },     //연봉계약년도  
            {dataIndex: 'MERITS_YEARS'      , width: 100     , align:'center'},  // hidden: true },     //기준년도
			{dataIndex: 'DEPT_CODE'         , width: 100     , hidden: true },   //부서코드  
            {dataIndex: 'DEPT_NAME'         , width: 140},  //부서명
			{dataIndex: 'ABIL_CODE'         , width: 140},  // , hidden: true  //직급
            {dataIndex: 'PERSON_NUMB'       , width: 100},  //사번
            {dataIndex: 'NAME'              , width: 80},   //성명
            {dataIndex: 'JOIN_DATE'         , width: 100},  // , hidden: true  //입사일
            {dataIndex: 'ANNUAL_SALARY_I'   , width: 120},  //연봉
            {dataIndex: 'WAGES_STD_I_TOT'   , width: 120},  //월지급액 total
            {dataIndex: 'AGRN_YN'           , width: 100     , align:'center'},  //동의여부
            {dataIndex: 'AGRN_DATE'         , width: 100     , hidden: true },  //동의일자
            {dataIndex: 'DECS_YN'           , width: 100     , align:'center'},  //연봉확정여부
            {dataIndex: 'DECS_YN_ORI'       , width: 100     , hidden: true },  //연봉확정여부(ori)
            {dataIndex: 'RMK'               , width: 120}   //비고

			
			
			
			
		],
		listeners: {
          	beforeedit  : function( editor, e, eOpts ) {
			},	
        	selectionchange:function( model1, selected, eOpts ){       			
//       			if(selected.length == 1)	{	
//	        		var record = selected[0];
//	        		
//       			}
          	},
          	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			    grid.getEl().on('click', function(e, t, eOpt) {
					if( directMasterStore.isDirty())	{
//						UniAppManager.setToolbarButtons('save', true);	
						UniAppManager.setToolbarButtons('save', false);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
			    	if(grid.getStore().getCount() > 0)	{
                    // alert('데이터 있음');
					}else {
                    // alert('데이터 없음');
					}
			    });
			    
			},
            beforedeselect : function ( gird, record, index, eOpts ){
            }
		}
    }); 
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			id:'pageAll',
			items:[
				masterGrid, panelResult
			]
		}
		], 
		id : 'hbs720ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData','delete','save'],false);  
			
			panelResult.setValue('CNRC_YEAR', new Date().getFullYear());
			panelResult.setValue('MERITS_YEARS', new Date().getFullYear() -1);
//			panelResult.setValue('AVRG_PMTN_AMT', 0);
			
//			// 대상자생성 버튼 비활성화 - refCreate
//            Ext.getCmp('refCreate').setDisabled(true);
//            // 평균호봉승급액걔산 비활성화 - calcAvg
//            Ext.getCmp('calcAvg').setDisabled(true); 
//            //가율계산 버튼 비활성화
//            Ext.getCmp('calc').setDisabled(true);
//            //상세금액계산 버튼 비활성화
//            Ext.getCmp('calcAmt').setDisabled(true);
//            //대사우반영 버튼 비활성화
//            Ext.getCmp('commitESS').setDisabled(true);
            
			rowCnt = 0;
			
		},
		onQueryButtonDown : function()	{		
			directMasterStore.loadStoreRecords();
		},
		
		onResetButtonDown: function() {       // 초기화
            panelResult.clearForm();
            
            masterGrid.reset();
            masterGrid.getStore().clearData();
            directMasterStore.loadData({});
            
            rowCnt = 0;
            this.fnInitBinding();
            
        },
		
		onSaveDataButtonDown: function () {
			
			if(rowCnt != 0){
			     alert('대사우 반영은 "5.대사우반영" 버튼을 눌러주시기 바랍니다.');
			     return false;
			}else{
    			var inValidRecs1 = directMasterStore.getInvalidRecords();
    			if(inValidRecs1.length != 0 )	{
    				if(inValidRecs1.length != 0){
    					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs1);
    				}
    				return false;		
    			}else{
    				if(directMasterStore.isDirty())	{									
    					directMasterStore.saveStore();			
    															
    				}
    
    			}
			}
		}
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
//			switch(fieldName) {
//				
//				 case 'SCEXP_ASST_ALWN' : //학비보조수당
//				 
//    				 if (record.get('BSE_AMT') == 0){
//    				    alert('먼저 기본급을 확인하십시오.');
//    				    return;
//    				 }
//    				 if(newValue == 0 || newValue == null){
//        				 record.set('WAGES_STD_I',   record.get('BSE_AMT')  //기본급
//                                                      + record.get('BNS_ALWN') //상여수당
//                                                      + record.get('MNGM_ALWN') //관리업무수당
//                                                      + record.get('CNWK_ALWN') //근속수당
//                                                      + record.get('ABIL_ASST_EXPN') //직급보조비
//                                                      + record.get('RSP_EXPN') //효도휴가비
//                                                      + record.get('CHFD_ASST_EXPN') //급식보조비
//                                                      + record.get('BZNS_PRGS_EXPN') //직책급 업무추진비
//                                                      + record.get('TCHN_ALWN') //기술자격수당
//                                                      + record.get('BZNS_ALWN') //업무수당
//                                                      + record.get('DEV_BZNS_ALWN') //개발업무수당
//                                                      + record.get('FMLY_ALWN') //가족수당
//                                                      //+ newValue //record.get('SCEXP_ASST_ALWN') //학비보조수당
//                                                      + record.get('TRET_ALWN') //대우수당
//                                                      
//                                                      
//                                 ); 
//                         record.set('ANNUAL_SALARY_I',   Math.floor((record.get('BSE_AMT')
//                                                          + record.get('BNS_ALWN')
//                                                          + record.get('MNGM_ALWN')
//                                                          + record.get('CNWK_ALWN')
//                                                          + record.get('ABIL_ASST_EXPN')
//                                                          + record.get('RSP_EXPN')
//                                                          + record.get('CHFD_ASST_EXPN')
//                                                          + record.get('BZNS_PRGS_EXPN')
//                                                          + record.get('TCHN_ALWN')
//                                                          + record.get('BZNS_ALWN')
//                                                          + record.get('DEV_BZNS_ALWN')
//                                                          + record.get('FMLY_ALWN')
//                                                          //+ newValue //record.get('SCEXP_ASST_ALWN')
//                                                          + record.get('TRET_ALWN')
//                                                          )*12 /10)*10
//                                );
//    				 }else{
//        				 record.set('WAGES_STD_I',   record.get('BSE_AMT')  //기본급
//            				                          + record.get('BNS_ALWN') //상여수당
//            				                          + record.get('MNGM_ALWN') //관리업무수당
//            				                          + record.get('CNWK_ALWN') //근속수당
//            				                          + record.get('ABIL_ASST_EXPN') //직급보조비
//            				                          + record.get('RSP_EXPN') //효도휴가비
//            				                          + record.get('CHFD_ASST_EXPN') //급식보조비
//            				                          + record.get('BZNS_PRGS_EXPN') //직책급 업무추진비
//            				                          + record.get('TCHN_ALWN') //기술자격수당
//            				                          + record.get('BZNS_ALWN') //업무수당
//            				                          + record.get('DEV_BZNS_ALWN') //개발업무수당
//            				                          + record.get('FMLY_ALWN') //가족수당
//            				                          + newValue //record.get('SCEXP_ASST_ALWN') //학비보조수당
//            				                          + record.get('TRET_ALWN') //대우수당
//            				                          
//        				        ); 
//        				 record.set('ANNUAL_SALARY_I',   Math.floor((record.get('BSE_AMT')
//                                                          + record.get('BNS_ALWN')
//                                                          + record.get('MNGM_ALWN')
//                                                          + record.get('CNWK_ALWN')
//                                                          + record.get('ABIL_ASST_EXPN')
//                                                          + record.get('RSP_EXPN')
//                                                          + record.get('CHFD_ASST_EXPN')
//                                                          + record.get('BZNS_PRGS_EXPN')
//                                                          + record.get('TCHN_ALWN')
//                                                          + record.get('BZNS_ALWN')
//                                                          + record.get('DEV_BZNS_ALWN')
//                                                          + record.get('FMLY_ALWN')
//                                                          + newValue //record.get('SCEXP_ASST_ALWN')
//                                                          + record.get('TRET_ALWN')
//                                                          + record.get('ADD_AMT') //월지급액 +
//                                                          - record.get('SUB_AMT') //월지급액 -
//                                                          ) * 12 /10)*10
//                                );
//    				}
//                break;
//				
//                case 'ADD_AMT' : //월지급액 +
//                
//                     if (record.get('BSE_AMT') == 0){
//                        alert('먼저 기본급을 확인하십시오.');
//                        return;
//                     }
//                     if(newValue == 0 || newValue == null){
//                        record.set('ANNUAL_SALARY_I',   Math.floor((record.get('BSE_AMT')
//                                                          + record.get('BNS_ALWN')
//                                                          + record.get('MNGM_ALWN')
//                                                          + record.get('CNWK_ALWN')
//                                                          + record.get('ABIL_ASST_EXPN')
//                                                          + record.get('RSP_EXPN')
//                                                          + record.get('CHFD_ASST_EXPN')
//                                                          + record.get('BZNS_PRGS_EXPN')
//                                                          + record.get('TCHN_ALWN')
//                                                          + record.get('BZNS_ALWN')
//                                                          + record.get('DEV_BZNS_ALWN')
//                                                          + record.get('FMLY_ALWN')
//                                                          + record.get('SCEXP_ASST_ALWN')
//                                                          + record.get('TRET_ALWN')
//                                                          - record.get('SUB_AMT') //월지급액 -
//                                                          ) *12/10)*10
//                                );
//                     }else{
//                        record.set('ANNUAL_SALARY_I',  Math.floor((record.get('BSE_AMT')
//                                                          + record.get('BNS_ALWN')
//                                                          + record.get('MNGM_ALWN')
//                                                          + record.get('CNWK_ALWN')
//                                                          + record.get('ABIL_ASST_EXPN')
//                                                          + record.get('RSP_EXPN')
//                                                          + record.get('CHFD_ASST_EXPN')
//                                                          + record.get('BZNS_PRGS_EXPN')
//                                                          + record.get('TCHN_ALWN')
//                                                          + record.get('BZNS_ALWN')
//                                                          + record.get('DEV_BZNS_ALWN')
//                                                          + record.get('FMLY_ALWN')
//                                                          + record.get('SCEXP_ASST_ALWN')
//                                                          + record.get('TRET_ALWN')
//                                                          + newValue //record.get('ADD_AMT') //월지급액 +
//                                                          - record.get('SUB_AMT') //월지급액 -
//                                                          ) * 12 /10)*10
//                                );
//                     }
//                 
//                 break;
//				
//                 case 'SUB_AMT' : //월지급액 -
//                
//                     if (record.get('BSE_AMT') == 0){
//                        alert('먼저 기본급을 확인하십시오.');
//                        return;
//                     }
//                     if(newValue == 0 || newValue == null){
//                        record.set('ANNUAL_SALARY_I',   Math.floor((record.get('BSE_AMT')
//                                                          + record.get('BNS_ALWN')
//                                                          + record.get('MNGM_ALWN')
//                                                          + record.get('CNWK_ALWN')
//                                                          + record.get('ABIL_ASST_EXPN')
//                                                          + record.get('RSP_EXPN')
//                                                          + record.get('CHFD_ASST_EXPN')
//                                                          + record.get('BZNS_PRGS_EXPN')
//                                                          + record.get('TCHN_ALWN')
//                                                          + record.get('BZNS_ALWN')
//                                                          + record.get('DEV_BZNS_ALWN')
//                                                          + record.get('FMLY_ALWN')
//                                                          + record.get('SCEXP_ASST_ALWN')
//                                                          + record.get('TRET_ALWN')
//                                                          + record.get('ADD_AMT') //월지급액 +
//    //                                                      - record.get('SUB_AMT') //월지급액 -
//                                                          ) *12/10)*10
//                                );
//                     }else{
//                        record.set('ANNUAL_SALARY_I',  Math.floor((record.get('BSE_AMT')
//                                                          + record.get('BNS_ALWN')
//                                                          + record.get('MNGM_ALWN')
//                                                          + record.get('CNWK_ALWN')
//                                                          + record.get('ABIL_ASST_EXPN')
//                                                          + record.get('RSP_EXPN')
//                                                          + record.get('CHFD_ASST_EXPN')
//                                                          + record.get('BZNS_PRGS_EXPN')
//                                                          + record.get('TCHN_ALWN')
//                                                          + record.get('BZNS_ALWN')
//                                                          + record.get('DEV_BZNS_ALWN')
//                                                          + record.get('FMLY_ALWN')
//                                                          + record.get('SCEXP_ASST_ALWN')
//                                                          + record.get('TRET_ALWN')
//                                                          + record.get('ADD_AMT') //월지급액 +
//                                                          - newValue //record.get('SUB_AMT') //월지급액 -
//                                                          ) * 12/10)*10
//                                );
//                     }
//                 
//                 break;
//
//			}
			
			return rv;
		}
	});
};

</script>
