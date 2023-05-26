<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum781ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A018" /> <!-- 데이터유형-->
	<t:ExtComboStore comboType="AU" comboCode="A004" /> <!-- 사용여부-->
	<t:ExtComboStore comboType="AU" comboCode="A147" /> <!-- 데이터포맷-->
	<t:ExtComboStore comboType="AU" comboCode="H032" opts='6;9'/>   <!--지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직급 -->
</t:appConfig>

<style type="text/css">
    #search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>

<script type="text/javascript" >

/**
 * 인사/급여관리 < 급여관리 < 평가급 지급 기초관리
 */


function appMain() {     
    var editWindow; // 지급율계산 popup
    var fixCnt = 0; //수정횟수

	/**
	 * Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('Hum781ukrModel', {
	    fields: [  	  
		    {name: 'DEPT_CODE'                  ,text: '부서코드'          ,type: 'string',   editable: false},
            {name: 'DEPT_NAME'                  ,text: '부서명'           ,type: 'string',  editable: false},
            {name: 'ABIL_CODE'                  ,text: '직급'            ,type: 'string', comboType:'AU', comboCode:'H006', editable: false},
            
            {name: 'PAY_YEARS'                  ,text:'사번'              ,type : 'string', editable: false},
            {name: 'MERITS_YEARS'                ,text:'사번'              ,type : 'string', editable: false},
            {name: 'MERITS_PAY_GUBUN'                ,text:'사번'              ,type : 'string', editable: false},

            {name: 'PERSON_NUMB'                ,text:'사번'              ,type : 'string', editable: false},
            {name: 'NAME'                       ,text: '성명'             ,type: 'string', editable: false},
            {name: 'JOIN_DATE'                  ,text: '입사일'            ,type: 'uniDate', editable: false},
            {name: 'PAY_CODE_GUBUN'             ,text: '연봉직구분'          ,type: 'string', editable: false},
            // 근태
            {name: 'VCTN_DCNT'                  ,text: '휴직'             ,type: 'int', editable: false},
            {name: 'SICK_DCNT'                  ,text: '병가'             ,type: 'int', editable: false}, 
            {name: 'APLC_MMCNT'                 ,text: '적용월'            ,type: 'int'}, 
            // 보수월액
            {name: 'APLC_AVRG_PAY_AMT'          ,text: '적용월기준'          ,type: 'uniPrice', editable: false}, 
            {name: 'STD_AVRG_PAY_AMT'           ,text: '만근기준'           ,type: 'uniPrice', editable: false}, 
		    {name: 'PAY_TOT_AMT'                ,text: '총지급액(만근기준)'     ,type: 'uniPrice', editable: false}, //summaryType: 'sum'}, 
            {name: 'ADD_AMT'                    ,text: ' + (가산금액)'      ,type: 'uniPrice'}, //summaryType: 'sum'}, 
            {name: 'SUB_AMT'                    ,text: ' - (감산금액)'      ,type: 'uniPrice'}, //summaryType: 'sum'}, 
            {name: 'AFT_CS_AMT'                 ,text: 'CS반영후'          ,type: 'uniPrice' , editable: false}, 
            // 평가
            {name: 'MERITS_CLASS'               ,text: '고과등급'           ,type: 'string' , editable: false, editable: false}, 
            {name: 'MERITS_PAY_RATE'            ,text: '지급율(%)'         ,type: 'uniPercent', editable: false, editable: false}, 
            {name: 'MERITS_PAY_AMT'             ,text: '지급액(지급율반영)'     ,type: 'uniPrice', editable: false, editable: false}, 
		    // 공제금액
		    {name: 'INTX_AMT'                   ,text: '소득세'             ,type: 'uniPrice' , editable: false}, 
            {name: 'LOC_INTX_AMT'               ,text: '지방소득세'           ,type: 'uniPrice', editable: false}, 
            {name: 'EMIN_AMT'                   ,text: '고용보험'            ,type: 'uniPrice', editable: false}, 
            {name: 'SZR_AMT'                    ,text: '압류금액'            ,type: 'uniPrice' }, 
            {name: 'HLIN_EXCA_AMT'              ,text: '건강보험'            ,type: 'uniPrice' }, 
            {name: 'EMIN_EXCA_AMT'              ,text: '고용보험정산'          ,type: 'uniPrice' }, 
            {name: 'NP_EXCA_AMT'                ,text: '국민연금정산'          ,type: 'uniPrice' }, 
            {name: 'RLPM_AMT'                   ,text: '실지급액'            ,type: 'uniPrice' , editable: false}, 
            {name: 'RMK_MASTER'                 ,text: '비고'              ,type: 'string' } 
		    
		]         	
	});
	
	
	Unilite.defineModel('Hum781ukrModel2', {
	    fields: [  	  
		    {name: 'PERSON_NUMB'			,text: '사번'               ,type: 'string', editable: false}, 
		    {name: 'PAY_YEARS'				,text: '기준년도'             ,type: 'string', editable: false}, 
		    {name: 'MERITS_YEARS'			,text: '평가년도'             ,type: 'string', editable: false}, 
		    {name: 'PAY_YYYYMM'			    ,text: '지급년월'             ,type: 'string', editable: false}, 
		    {name: 'PAY_MM'				    ,text: '(평가년월)구분' 	        ,type: 'string', editable: false}, 
		    {name: 'BSE_AMT'			   	,text: '기본급' 	            ,type: 'uniPrice'}, 
		    {name: 'BNF_ALWN'				,text: '복리후생비' 	             ,type: 'uniPrice'}, 
		    {name: 'RSP_ALWN'				,text: '효도휴가비' 	             ,type: 'uniPrice'}, 
		    {name: 'BNS_ALWN'				,text: '상여수당'     	        ,type: 'uniPrice'}, 
		    {name: 'CNWK_ALWN'				,text: '근속수당' 	            ,type: 'uniPrice'}, 
		    {name: 'ENCR_ALWN'				,text: '근무장려수당' 	        ,type: 'uniPrice'}, 
		    {name: 'RMK_DETAIL'			    ,text: '비고' 	            ,type: 'string'}
		    
		]         	
	});
		  
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'hum781ukrService.selectMasterList',
        	update: 'hum781ukrService.updateMaster',
            // create: 'hum781ukrService.insertMaster',
            // destroy: 'hum781ukrService.deleteMaster',
			syncAll: 'hum781ukrService.saveAll'
        }
	});
	
	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'hum781ukrService.selectDetailList',
        	update: 'hum781ukrService.updateDetail',
            // create: 'hum781ukrService.insertDetail',
            // destroy: 'hum781ukrService.deleteDetail',
			syncAll: 'hum781ukrService.saveAll'
        }
	});  
	  
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	var directMasterStore = Unilite.createStore('hum781ukrMasterStore1',{
		model: 'Hum781ukrModel',
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
                        // if(directMasterStore.isDirty() || directDetailStore.isDirty()){
                            UniAppManager.setToolbarButtons('reset', true);
                        // }else{
                        // }
                            
                            
					}
				}
			});
			
		},
		saveStore : function()	{
//			alert('directMasterStore - save');
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var config = {
					params:[panelResult.getValues()],
					success : function()	{
						if(directDetailStore.isDirty())	{
//			                 alert('directMasterStore - save - after - directMasterStore - save');				
							directDetailStore.saveStore();						
						}
						
					}
				}
				this.syncAllDirect(config);			
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
			
			fixCnt = 0 ; //초기화
			
			
			
			
			
			
			
			
			
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
           		if(records != null && records.length > 0 ){
           			 // 대상자생성 버튼 비활성화
           			Ext.getCmp('refCreate').setDisabled(true);
                    // 지급율계산 버튼 활성화
           			Ext.getCmp('calc').setDisabled(false); 
           			//공제금액계산 버튼 활성화
           			Ext.getCmp('calcAmt').setDisabled(false);
           			
           			//급여반영 버튼 활성화
                    Ext.getCmp('comfirmSalary').setDisabled(false);
           			
           			
                    var viewDetail = detailGrid.getView();
                    viewDetail.getFeature('detailGridSubTotal').toggleSummaryRow(true);
                    viewDetail.getFeature('detailGridTotal').toggleSummaryRow(true);
           		}
           		else{
                    // 대상자생성 버튼 활성화
                    Ext.getCmp('refCreate').setDisabled(false);
                    // 지급율계산 버튼 비활성화
                    Ext.getCmp('calc').setDisabled(true);
                    //공제금액계산 버튼 활성화
                    Ext.getCmp('calcAmt').setDisabled(true);
                    
                    //급여반영 버튼 활성화
                    Ext.getCmp('comfirmSalary').setDisabled(true);
                    
                    detailGrid.reset();
                    detailGrid.getStore().clearData();
                    directDetailStore.loadData({});
           		   
                    var viewDetail = detailGrid.getView();
                    viewDetail.getFeature('detailGridSubTotal').toggleSummaryRow(false);
                    viewDetail.getFeature('detailGridTotal').toggleSummaryRow(false);
           		}
           		
           		fixCnt = 0 ; //초기화
           		
           		
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
				if( directDetailStore.isDirty() || store.isDirty())	{
					UniAppManager.setToolbarButtons('save', true);	
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	
	var directDetailStore = Unilite.createStore('hum781ukrMasterStore2',{
		model: 'Hum781ukrModel2',
		uniOpt: {
            isMaster: false,		// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable:true,			// 삭제 가능 여부
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directDetailProxy,
        loadStoreRecords: function(record) {
			var searchParam= Ext.getCmp('resultForm').getValues();
			var param= {
                        'PERSON_NUMB':record.get('PERSON_NUMB')
                        };	
			var params = Ext.merge(searchParam, param);
			
			console.log( param );
			this.load({
				params : params,
				callback : function(records,options,success)	{
					if(success)	{
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
					   
					UniAppManager.app.onQueryButtonDown();         //디테일 저장 후 재조회
                    }									
				}
				this.syncAllDirect(config);	
				
				
				
			}else {				
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
			
			
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(records != null && records.length > 0 ){
           		}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
				if( directMasterStore.isDirty() || store.isDirty() ) {
					UniAppManager.setToolbarButtons('save', true);	
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
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
                fieldLabel: '기준년도',
                name: 'PAY_YEARS',
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
                fieldLabel: '평가년도',
                name: 'MERITS_YEARS',
                xtype: 'uniYearField',
                value: new Date().getFullYear() - 1 ,
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('PAY_YEARS', newValue + 1);          
                    }
                }
             },
             {
                fieldLabel: '평가급구분',
                name:'MERITS_PAY_GUBUN', 
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H032',
                allowBlank:false,
                value:'9'
             },
            {
                fieldLabel: '지급년월', 
                xtype: 'uniMonthfield',
                name: 'PAY_YYYYMM',
                value: UniDate.get('today'),
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
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
                width: 340
             }
		]	
    });
	
    
    
        // 지급율계산 POPUP
    var editForm = Unilite.createSearchForm('gop200ukrvDetailForm', {
        layout: {type: 'uniTable', columns : 3},
        defaults:{
            labelWidth:80,
            width:240
        },
        defaultType:'textfield',
        items: [
            {
                xtype:'container',
                html: '<font color=blue size=5><b>&nbsp;◆&nbsp;평&nbsp;가&nbsp;지&nbsp;급&nbsp;율&nbsp;&nbsp;관&nbsp;리&nbsp;</b></font>',
                colspan     : 3
            },
            {
                xtype:'container',
                html: '<font color=red size=2><b>&nbsp;</b></font>',
                colspan     : 3
            },
    
            {
                fieldLabel: '기준년도',
                name: 'PAY_YEARS',
                xtype: 'uniYearField',
                value: new Date().getFullYear(),
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        editForm.setValue('MERITS_YEARS', newValue - 1);          
                    }
                }
             },
             {
                fieldLabel: '평가년도',
                name: 'MERITS_YEARS',
                xtype: 'uniYearField',
                value: new Date().getFullYear() - 1 ,
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        editForm.setValue('PAY_YEARS', newValue + 1);          
                    }
                }
             },
             {
                fieldLabel: '평가급구분',
                name:'MERITS_PAY_GUBUN', 
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H032',
                allowBlank:false,
                value:'9'
             },
             {
                xtype:'container',
                html: '<font color=red size=5><b>&nbsp;</b></font>',
                colspan     : 3
    
            },
                 {
                xtype:'container',
                html: '<font color=red><b>&nbsp;&nbsp;&nbsp;*비율 등록&nbsp;</b></font>',
                colspan     : 3
    
            },	
            {
                fieldLabel: '기준비율(%)',
                name: 'ST_RATE',
                xtype:'uniNumberfield',
                decimalPrecision: 2,
                colspan:3,
                value:0,
                suffixTpl:'%',
                listeners: {
                    blur : function () {
                    	editForm.getField('S_GRADE').setReadOnly(true);
                        editForm.getField('A_GRADE').setReadOnly(true);
                        editForm.getField('C_GRADE').setReadOnly(true);
                        editForm.getField('D_GRADE').setReadOnly(true);
                        editForm.getField('B_GRADE').setReadOnly(true);
                        editForm.getField('Z_GRADE').setReadOnly(true);
                    	
                        if(this.value == null){
                        	this.setValue(0);
                            return;
                        }
                    }
                }
            },
            {
                fieldLabel: '차이율(%)',
                name: 'GAP_RATE',
                xtype:'uniNumberfield',
                decimalPrecision: 2,
                colspan:3,
                value:0,
                suffixTpl:'%',
                listeners: {
                    blur : function () {
                    	editForm.getField('S_GRADE').setReadOnly(true);
                        editForm.getField('A_GRADE').setReadOnly(true);
                        editForm.getField('C_GRADE').setReadOnly(true);
                        editForm.getField('D_GRADE').setReadOnly(true);
                        editForm.getField('B_GRADE').setReadOnly(true);
                        editForm.getField('Z_GRADE').setReadOnly(true);
                    	
                        if(this.value == null){
                        	this.setValue(0);
                            return;
                        }
                    }
                  }
            },
            {
                fieldLabel: '미평가(%)',
                name: 'UNVAL_RATE',
                xtype:'uniNumberfield',
                decimalPrecision: 2,
                colspan:1,
                value:0,
                suffixTpl:'%',
                listeners: {
                    blur : function () {
                    	editForm.getField('S_GRADE').setReadOnly(true);
                        editForm.getField('A_GRADE').setReadOnly(true);
                        editForm.getField('C_GRADE').setReadOnly(true);
                        editForm.getField('D_GRADE').setReadOnly(true);
                        editForm.getField('B_GRADE').setReadOnly(true);
                        editForm.getField('Z_GRADE').setReadOnly(true);
                    	
                        if(this.value == null){
                        	this.setValue(0);
                            return;
                        }
                    }
                  }
            },
            {
                fieldLabel: '계산',
                xtype: 'button',
                text: '지급율 계산',
                width: 100,
                margin: '0 0 5 50',
                colspan:2,
                name: 'VEHICLE_NAME',
                handler: function() {
                	
                	var stRate = editForm.getValue('ST_RATE');
                	var gapRate = editForm.getValue('GAP_RATE');
                	var unvalRate = editForm.getValue('UNVAL_RATE');
                	
                	if(editForm.getValue('ST_RATE') == 0 ){
                	   alert('기준비율을 입력해주세요.');
                	}else if (editForm.getValue('GAP_RATE') == 0 ){
                	   alert('차이율을 입력해주세요.');
                	}else if (editForm.getValue('UNVAL_RATE') == 0 ){
                       alert('미평가율을 입력해주세요.');
                    }else{
                        editForm.setValue('S_GRADE', stRate + (gapRate/2)); 
                        editForm.setValue('A_GRADE', stRate + (gapRate)/4); 
                        editForm.setValue('C_GRADE', stRate - (gapRate)/4);
                        editForm.setValue('D_GRADE', stRate - (gapRate/2));
                        editForm.setValue('B_GRADE', stRate);
                        editForm.setValue('Z_GRADE', unvalRate);
    
                        editForm.getField('S_GRADE').setReadOnly(false);
                        editForm.getField('A_GRADE').setReadOnly(false);
                        editForm.getField('C_GRADE').setReadOnly(false);
                        editForm.getField('D_GRADE').setReadOnly(false);
                        editForm.getField('B_GRADE').setReadOnly(false);
                        editForm.getField('Z_GRADE').setReadOnly(false);
                    
                    }
                }
            },
            {
                xtype:'container',
                html: '<font color=red size=5><b>&nbsp;</b></font>',
                colspan     : 3
            },
             {
                xtype:'container',
                html: '<font color=red><b>&nbsp;&nbsp;&nbsp;*지급율 계산&nbsp;</b></font>',
                colspan     : 3
            },  
            {
                fieldLabel: 'S등급',
                name: 'S_GRADE',
                xtype:'uniNumberfield',
                decimalPrecision: 2,
                suffixTpl:'%',
                readOnly: true,
                value:0,
                colspan:3,
                listeners: {
                    blur : function () {
                        if(this.value == null){
                        	this.setValue(0);
                            return;
                        }
                    }
                }
            },
            {
                fieldLabel: 'A등급',
                name: 'A_GRADE',
                xtype:'uniNumberfield',
                decimalPrecision: 2,
                suffixTpl:'%',
                readOnly: true,
                value:0,
                colspan:3,
                listeners: {
                    blur : function () {
                        if(this.value == null){
                        	this.setValue(0);
                            return;
                        }
                    }
                }
            },
            {
                fieldLabel: 'B등급',
                name: 'B_GRADE',
                xtype:'uniNumberfield',
                decimalPrecision: 2,
                suffixTpl:'%',
                readOnly: true,
                value:0,
                colspan:3,
                listeners: {
                    blur : function () {
                        if(this.value == null){
                        	this.setValue(0);
                            return;
                        }
                    }
                }
            },
            {
                fieldLabel: 'C등급',
                name: 'C_GRADE',
                xtype:'uniNumberfield',
                decimalPrecision: 2,
                suffixTpl:'%',
                readOnly: true,
                value:0,
                colspan:3,
                listeners: {
                    blur : function () {
                        if(this.value == null){
                        	this.setValue(0);
                            return;
                        }
                    }
                }
            },
            {
                fieldLabel: 'D등급',
                name: 'D_GRADE',
                xtype:'uniNumberfield',
                decimalPrecision: 2,
                suffixTpl:'%',
                readOnly: true,
                value:0,
                colspan:3,
                listeners: {
                    blur : function () {
                        if(this.value == null){
                        	this.setValue(0);
                            return;
                        }
                    }
                }
            },
            {
                fieldLabel: 'Z등급',
                name: 'Z_GRADE',
                xtype:'uniNumberfield',
                decimalPrecision: 2,
                suffixTpl:'%',
                readOnly: true,
                value:0,
                colspan:1,
                listeners: {
                    blur : function () {
                        if(this.value == null){
                        	this.setValue(0);
                            return;
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '재원 산출',
                width: 100,
                margin: '0 0 5 50',
                name: 'VEHICLE_NAME',
                colspan:2,
                handler: function() {
                    var param = {
                        "S_GRADE" : editForm.getValue('S_GRADE'),
                        "A_GRADE" : editForm.getValue('A_GRADE'),
                        "B_GRADE" : editForm.getValue('B_GRADE'),
                        "C_GRADE" : editForm.getValue('C_GRADE'),
                        "D_GRADE" : editForm.getValue('D_GRADE'),
                        "Z_GRADE" : editForm.getValue('Z_GRADE'),
                        "PAY_YEARS" : editForm.getValue('PAY_YEARS'),
                        "MERITS_YEARS" : editForm.getValue('MERITS_YEARS'),
                        "MERITS_PAY_GUBUN" : editForm.getValue('MERITS_PAY_GUBUN')
                    };            
                    hum781ukrService.selectSorc(param, function(provider, response) {   
                        if(!Ext.isEmpty(provider)){
                        	var records = response.result;
                        	
                            APLC_AVRG_PAY_AMT_TOTAL = records[0].APLC_AVRG_PAY_AMT_TOTAL;
                            SORC_TOT_AMT = records[0].SORC_TOT_AMT;
                            SORC_BALN = records[0].SORC_BALN;
                            
                            editForm.setValue('APLC_AVRG_PAY_AMT_TOTAL', APLC_AVRG_PAY_AMT_TOTAL);
                            editForm.setValue('SORC_TOT_AMT', SORC_TOT_AMT);
                            editForm.setValue('SORC_BALN', SORC_BALN);
                        }
                        
                    });
                	
                }
            },
    
            {
                xtype:'container',
                html: '<font color=red size=5><b>&nbsp;</b></font>',
                colspan     : 3
            },
             {
                xtype:'container',
                html: '<font color=red><b>&nbsp;&nbsp;&nbsp;*재원 산출&nbsp;</b></font>',
                colspan     : 3
            }, 
            {
                fieldLabel: '총보수월액',
                name: 'APLC_AVRG_PAY_AMT_TOTAL',
                xtype:'uniNumberfield',
                value: 0,
                readOnly: true
            },
            {
                fieldLabel: '재원(총액)',
                name: 'SORC_TOT_AMT',
                xtype:'uniNumberfield',
                value: 0 ,
                readOnly: true
            },
            {
                fieldLabel: '재원(잔액)',
                name: 'SORC_BALN',
                xtype:'uniNumberfield',
                value: 0 ,
                readOnly: true
            },
            {
                xtype:'container',
                html: '<font color=red size=5><b>&nbsp;</b></font>',
                colspan     : 3,
                style: {
                    color: 'blue'               
                }
            } 		
        ]
    });
    
    function openWindow() {
        if(!editWindow) {
            editWindow = Ext.create('widget.uniDetailWindow', {
                title: '지급율계산 POPUP',
                width: 800,                         
                height: 600,
                layout: {type:'box', align:'stretch'},                 
                items: [editForm],
                tbar:  [
                        '->',
                        {
                            itemId : 'calc_comfirm',
                            // text: '*지급율 확정',
                            text: '<font><b>&nbsp;*지급율 확정&nbsp;</b></font>',
                            handler: function() {
                                // 지급울 확정 로직
                                var param = {
                                    "S_GRADE" : editForm.getValue('S_GRADE'),
                                    "A_GRADE" : editForm.getValue('A_GRADE'),
                                    "B_GRADE" : editForm.getValue('B_GRADE'),
                                    "C_GRADE" : editForm.getValue('C_GRADE'),
                                    "D_GRADE" : editForm.getValue('D_GRADE'),
                                    "Z_GRADE" : editForm.getValue('Z_GRADE'),
                                    "PAY_YEARS" : editForm.getValue('PAY_YEARS'),
                                    "MERITS_YEARS" : editForm.getValue('MERITS_YEARS'),
                                    "MERITS_PAY_GUBUN" : editForm.getValue('MERITS_PAY_GUBUN')
                                                       
                                };            
                                hum781ukrService.commitMeritsRate(param, function(provider, response) {   
                                    if (provider != 0){
                                        alert('지급율 확정 실패');
                                                
                                    } else {
                                        Ext.Msg.alert('확인', ' 지급율 확정이 완료되었습니다..');
                                        
                                    }
                                    // 조회
                                    directMasterStore.loadStoreRecords();
                                });
                                editWindow.hide();
                            }
                        },
                        {
                            itemId : 'closeBtn',
                            text: '닫기',
                            handler: function() {
                                editWindow.hide();
                            }
                        }
                ],
                listeners : {beforehide: function(me, eOpt) {
                                editForm.clearForm();
                                editForm.reset();
                                editForm.getField('S_GRADE').setReadOnly(true);
                                editForm.getField('A_GRADE').setReadOnly(true);
                                editForm.getField('C_GRADE').setReadOnly(true);
                                editForm.getField('D_GRADE').setReadOnly(true);
                                editForm.getField('B_GRADE').setReadOnly(true);
                                editForm.getField('Z_GRADE').setReadOnly(true);
                            },
                             beforeclose: function( panel, eOpts )  {
                                editForm.clearForm();
                                editForm.reset();
                                editForm.getField('S_GRADE').setReadOnly(true);
                                editForm.getField('A_GRADE').setReadOnly(true);
                                editForm.getField('C_GRADE').setReadOnly(true);
                                editForm.getField('D_GRADE').setReadOnly(true);
                                editForm.getField('B_GRADE').setReadOnly(true);
                                editForm.getField('Z_GRADE').setReadOnly(true);
                            },
                             show: function( panel, eOpts ) {
                             	editForm.setValue('PAY_YEARS', panelResult.getValue('PAY_YEARS')) // 기준년도
                                editForm.setValue('MERITS_YEARS', panelResult.getValue('MERITS_YEARS')) // 평가년도
                                editForm.setValue('MERITS_PAY_GUBUN', panelResult.getValue('MERITS_PAY_GUBUN')) // 평가급구분
                                
                                editWindow.center();
                             }
                }       
            })
        }
        editWindow.show();
    };
    
    /**
	 * Master Grid 정의
	 * 
	 * @type
	 */
    
    var masterGrid = Unilite.createGrid('hum781ukrGrid1', {
    	layout : 'fit',
        region : 'center',
        itemId:'masterGrid',
        store : directMasterStore,
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true
        },
        tbar: [
        	{
                xtype: 'button',
                itemId:'refCreateButton',
                id: 'refCreate',
                text: '1.대상자생성',
                disabled:true,
                
                handler: function() {
                    if(confirm('대상자생성 시 기존데이터는 삭제됩니다. \n 생성 하시겠습니까?')) {
                        Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
                        var param = panelResult.getValues();
                        hum781ukrService.createBaseData (param, function(provider, response) {
                            if (provider != 0){
                                alert('데이터 생성 실패');
                            } else {
//                                Ext.Msg.alert('확인', '대상자 생성이 완료되었습니다.');
                            }
                            Ext.getCmp('pageAll').getEl().unmask();
                            // 조회
                            directMasterStore.loadStoreRecords();
                        });
                    }
                }
  
            },
            {
                itemId:'calcButton',
                id:'calc',
                 text: '2.지급율계산',
//                text: '<font><b>&nbsp;*지급율계산&nbsp;</b></font>',
                disabled:true,
                handler: function() {
                	// 로직 확인 필요
                   if(directMasterStore.isDirty() || directDetailStore.isDirty())  {
                        if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {                       
                            UniAppManager.app.onSaveDataButtonDown();
                            openWindow();
                        }
                        return false;
                    }             	
                    openWindow();
                }
            },
            {
                itemId:'calcAmtButton',
                id:'calcAmt',
                text: '3.공제금액계산',
                //text: '<font><b>&nbsp;*공제금액계산&nbsp;</b></font>',
                disabled:true,
                handler: function() {
                        
                        if(directMasterStore.isDirty() || directDetailStore.isDirty())  {
                        	alert(Msg.sMB017 + '\n먼저 저장해주시기 바랍니다.');
                            return false;
                        }
                        else{
                        
                            if(confirm('공제금액계산 시 기존데이터는 삭제됩니다. \n 생성 하시겠습니까?')) {
                            	
                            Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
                            var param = panelResult.getValues();
                            hum781ukrService.calcTaxAmt(param, function(provider, response) {
                                if (provider != 0){
                                    // Ext.Msg.alert('확인', Msg.sMB006);
                                    alert('데이터 생성 실패');
                                } else {
                                    // Ext.Msg.alert('확인', Msg.sMM389);
                                    Ext.Msg.alert('확인', '공제금액계산이 완료되었습니다.');
                                }
                                Ext.getCmp('pageAll').getEl().unmask();
                                // 조회
                                directMasterStore.loadStoreRecords();
                            });
                            }
                        
                        }
                    
                }
            },
            {
                itemId:'comfirmButton',
                id:'comfirmSalary',
                text: '4.급여반영',
                disabled:true,
                handler: function() {
                	if(directMasterStore.isDirty() || directDetailStore.isDirty())  {
                            alert(Msg.sMB017 + '\n먼저 저장해주시기 바랍니다.');
                            return false;
                    }
                    else if(confirm('급여반영을 하시겠습니까?')) {
                        Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
                        var param = panelResult.getValues();
                        hum781ukrService.insertSalary (param, function(provider, response) {
                            if (provider != 0){
                                alert('급여반영 실패');
                            } else {
                                Ext.Msg.alert('확인', '급여반영이 완료되었습니다.');
                            }
                            Ext.getCmp('pageAll').getEl().unmask();
                            // 조회
                            directMasterStore.loadStoreRecords();
                        });
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
			{dataIndex: 'DEPT_CODE'		, width: 80	, hidden: true },  
			{dataIndex: 'DEPT_NAME'		, width: 180 , readOnly : true},  //부서명
			{dataIndex: 'ABIL_CODE'		, width: 80	},  // , hidden: true //직급
			
			{dataIndex: 'PAY_YEARS'		, width: 80	, hidden: true},  // , hidden: true 
			{dataIndex: 'MERITS_YEARS'		, width: 80	, hidden: true},  // , hidden: true 
			{dataIndex: 'MERITS_PAY_GUBUN'		, width: 80	, hidden: true},  // , hidden: true 
			
			
			{dataIndex: 'PERSON_NUMB'		, width: 90	},  //사번
			{dataIndex: 'NAME'		     , width: 60	},  //성명
			{dataIndex: 'JOIN_DATE'		, width: 80	},  // , hidden: true //입사일
			{dataIndex: 'PAY_CODE_GUBUN'		, width: 80, hidden: true	},  //연봉직구분
			{text: '근태',
                columns:[    
                    {dataIndex: 'VCTN_DCNT', width: 60   }, //휴직
                    {dataIndex: 'SICK_DCNT', width: 60   } //병가
                ]
            },
			
			{dataIndex: 'APLC_MMCNT'		, width: 60, align:'center'	},  //적용월
			{text: '보수월액',
                columns:[    
                    {dataIndex: 'APLC_AVRG_PAY_AMT', width: 100},//적용월 기준
                    {dataIndex: 'STD_AVRG_PAY_AMT', width: 100} // 만근 기준
                ]
            },
			{text: '총지급액',
                columns:[    
                    {dataIndex: 'PAY_TOT_AMT'     , width: 100 },   //지급액
                    {dataIndex: 'ADD_AMT', width: 100,
                        listeners: {
                        	blur : function () {
                        		//계산식
                        	}
                        }
                    },
                    
                    {dataIndex: 'SUB_AMT', width: 100,
                        listeners: {
                        	blur : function () {
                        		//계산식
                        	}
                        }
                    }, // (감산금액)
                    {dataIndex: 'AFT_CS_AMT', width: 100} // CS반영후 
                ]
            },

            {text: '평가',
                columns:[    
                    {dataIndex: 'MERITS_CLASS', width: 70, align:'center'}, //고과등급
                    {dataIndex: 'MERITS_PAY_RATE', width: 80}, //지급율
                    {dataIndex: 'MERITS_PAY_AMT', width: 100}  //지급액 (CS반영후 * 지급율)
                ]
            },
            
            {text: '공제금액',
                columns:[    
                    {dataIndex: 'INTX_AMT', width: 100}, //소득세
                    {dataIndex: 'LOC_INTX_AMT', width: 100}, //지방소득세
                    {dataIndex: 'EMIN_AMT', width: 100}, //고용보험
                    {dataIndex: 'SZR_AMT', width: 100}, //압류금액
                    {dataIndex: 'HLIN_EXCA_AMT', width: 100}, //건강보험
                    {dataIndex: 'EMIN_EXCA_AMT', width: 100}, //고용보험정산
                    {dataIndex: 'NP_EXCA_AMT', width: 100} //국민연금정산
                ]
            },
			{dataIndex: 'RLPM_AMT'		, width: 100	},   //실지급액
			{dataIndex: 'RMK_MASTER'		, width: 80	}    //비고
		],
		listeners: {
          	beforeedit  : function( editor, e, eOpts ) {
          		if(directDetailStore.isDirty()){
          		    alert('먼저 저장해주십시오.');
          		    return false;
          		}
			},	
        	selectionchange:function( model1, selected, eOpts ){       			
       			if(selected.length == 1)	{	
	        		var record = selected[0];
	        		directDetailStore.loadStoreRecords(record);
	        		
       			}
          	},
          	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			    grid.getEl().on('click', function(e, t, eOpt) {
					if( directMasterStore.isDirty() || directDetailStore.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);	
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
				if(directDetailStore.isDirty())	{
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{						
						UniAppManager.app.onSaveDataButtonDown();
					}
				}
			}
		}
    }); 
       
     /**
		 * detailGrid 정의(Grid Panel)
		 * 
		 * @type
		 */
    
    var detailGrid = Unilite.createGrid('hum781ukrGrid2', {
    	layout : 'fit',
        region : 'south',
        itemId:'detailGrid',
        store : directDetailStore,
    	uniOpt: {
    		expandLastColumn: true,
		 	useRowNumberer: true,
		 	copiedRow: false,
            useGroupSummary: false,
            onLoadSelectFirst: false
            // useContextMenu: true,
        },
    	features: [{
    		id: 'detailGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'detailGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
			{dataIndex: 'PERSON_NUMB'	, width: 100, align:'center', summaryType: 'totaltext',
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            }},
        	{dataIndex: 'PAY_YEARS'		, width: 100, align:'center'},
        	{dataIndex: 'MERITS_YEARS'	, width: 100, align:'center'},
        	{dataIndex: 'PAY_YYYYMM'	, width: 100, hidden:true},
        	{dataIndex: 'PAY_MM'		, width: 100, align:'center'},
        	{dataIndex: 'BSE_AMT'	    , width: 100, summaryType: 'sum'},
        	{dataIndex: 'BNF_ALWN'	    , width: 100, summaryType: 'sum'},
			{dataIndex: 'RSP_ALWN'		, width: 100, summaryType: 'sum'}, 				
			{dataIndex: 'BNS_ALWN'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'CNWK_ALWN'		, width: 100, summaryType: 'sum'},  
			{dataIndex: 'ENCR_ALWN'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'RMK_DETAIL'    , width: 100}
		],
		listeners: {	
        	selectionchange:function( model1, selected, eOpts ){
          	},
          	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			    grid.getEl().on('click', function(e, t, eOpt) {	
			    	if( directMasterStore.isDirty() || directDetailStore.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
			    	if(grid.getStore().getCount() > 0)	{
					}else {
					}
					var record = masterGrid.getSelectedRecord();
					if(!Ext.isEmpty(record)){
					}
					
			    });
			 },
			 beforeedit  : function( editor, e, eOpts ) {
				if(directMasterStore.isDirty()){
                    alert('먼저 저장해주십시오.');
                    return false;
                }
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
				masterGrid, detailGrid, panelResult
			]
		}
		], 
		id : 'hum781ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData','delete','save'],false);  
			
			panelResult.setValue('PAY_YEARS', new Date().getFullYear())
			panelResult.setValue('MERITS_YEARS', new Date().getFullYear() -1)
			panelResult.setValue('MERITS_PAY_GUBUN', '9')
			panelResult.setValue('PAY_YYYYMM', UniDate.get('today'))
			
			
			// 대상자생성 버튼 비활성화
            Ext.getCmp('refCreate').setDisabled(true);
            // 지급율계산 버튼 활성화
            Ext.getCmp('calc').setDisabled(true); 
            //공제금액계산 버튼 활성화
            Ext.getCmp('calcAmt').setDisabled(true);
            //급여반영 버튼 활성화
            Ext.getCmp('comfirmSalary').setDisabled(true);
			
			fixCnt = 0;
			
		},
		onQueryButtonDown : function()	{		
			directMasterStore.loadStoreRecords();
		},
		
		onResetButtonDown: function() {       // 초기화
            panelResult.clearForm();
            
            masterGrid.reset();
            masterGrid.getStore().clearData();
            directMasterStore.loadData({});
            
            detailGrid.reset();
            detailGrid.getStore().clearData();
            directDetailStore.loadData({});
            
            var viewDetail = detailGrid.getView();
            viewDetail.getFeature('detailGridSubTotal').toggleSummaryRow(false);
            viewDetail.getFeature('detailGridTotal').toggleSummaryRow(false);
//            fixCnt = 0;
            this.fnInitBinding();
            
        },
		
		onSaveDataButtonDown: function () {
			var inValidRecs1 = directMasterStore.getInvalidRecords();
			var inValidRecs2 = directDetailStore.getInvalidRecords();
			if(inValidRecs1.length != 0 || inValidRecs2.length != 0)	{
				if(inValidRecs1.length != 0){
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs1);
				}
				if(inValidRecs2.length != 0){
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs2);
				}
				return false;		
			}else{
                if(directDetailStore.isDirty()){
					directDetailStore.saveStore();
					
				}
				if(directMasterStore.isDirty())	{									
					directMasterStore.saveStore();			
															
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
//				alert('fixCnt : ' + fixCnt);
			switch(fieldName) {
				
				//적용월 수정
                 case "APLC_MMCNT" :
                 
                 if(fixCnt == 0 && record.get('MERITS_PAY_AMT') != 0 && record.get('INTX_AMT') != 0){
                 	fixCnt = fixCnt + 1;
                    alert('지급액이 변경되었습니다. \n저장 후  "공재금액계산"을 다시 해주시기 바랍니다.')
                 }
                 if(newValue == 0){
                 	record.set('APLC_AVRG_PAY_AMT', 0); //적용월기준  수정
                 	record.set('PAY_TOT_AMT', 0); //총지급액  수정
                 	record.set('AFT_CS_AMT', record.get('PAY_TOT_AMT') + record.get('ADD_AMT') - record.get('SUB_AMT')); //CS반영후 계산
                 	
                 }else if (newValue > 0 && newValue <= 12){
                    record.set('APLC_AVRG_PAY_AMT', record.get('STD_AVRG_PAY_AMT') * newValue / 12);
                    record.set('PAY_TOT_AMT', record.get('STD_AVRG_PAY_AMT')* newValue); //총지급액 금액 수정
                    record.set('AFT_CS_AMT', record.get('PAY_TOT_AMT') + record.get('ADD_AMT') - record.get('SUB_AMT'));
                    
                 }else if (newValue < 0 || newValue > 12){
                    alert('적용월을 다시 확인하여 주시기 바랍니다.')
                    return false;
                 }
                 else{
                 	return false;
                 
                 }
                 
                 if( record.get('AFT_CS_AMT') <= 0 || record.get('MERITS_PAY_RATE') == 0 || record.get('MERITS_PAY_RATE') == null){
                        record.set('MERITS_PAY_AMT', 0);
                    }else{
                      record.set('MERITS_PAY_AMT', record.get('AFT_CS_AMT') * record.get('MERITS_PAY_RATE') / 100 )  ; //지급율반영 지급액 계산
                 }
                                  
                 break;
                 
                 //가산금액
                 case "ADD_AMT" :
                 
                  if(fixCnt == 0 && record.get('MERITS_PAY_AMT') != 0 && record.get('INTX_AMT') != 0){
                    fixCnt = fixCnt + 1;
                    alert('지급액이 변경되었습니다. \n저장 후 "공재금액계산"을 다시 해주시기 바랍니다.')
                 }
                    record.set('AFT_CS_AMT', record.get('PAY_TOT_AMT') + newValue - record.get('SUB_AMT'));
                    
                    if( record.get('AFT_CS_AMT') <= 0 || record.get('MERITS_PAY_RATE') == 0 || record.get('MERITS_PAY_RATE') == null){
                        record.set('MERITS_PAY_AMT', 0);
                    }else{
                      record.set('MERITS_PAY_AMT', record.get('AFT_CS_AMT') * record.get('MERITS_PAY_RATE') / 100 )  ; //지급율반영 지급액 계산
                    }
                 
                 break;
                 
                 //감산금액
                 case "SUB_AMT" :
                  if(fixCnt == 0 && record.get('MERITS_PAY_AMT') != 0 && record.get('INTX_AMT') != 0){
                    fixCnt = fixCnt + 1;
                    alert('지급액이 변경되었습니다. \n저장 후 "공재금액계산"을 다시 해주시기 바랍니다.')
                 }
                 
                    record.set('AFT_CS_AMT', record.get('PAY_TOT_AMT') + record.get('ADD_AMT') - newValue );
                    
                    if( record.get('AFT_CS_AMT') <= 0 || record.get('MERITS_PAY_RATE') == 0 || record.get('MERITS_PAY_RATE') == null){
                        record.set('MERITS_PAY_AMT', 0);
                    }else{
                      record.set('MERITS_PAY_AMT', record.get('AFT_CS_AMT') * record.get('MERITS_PAY_RATE') / 100 )  ; //지급율반영 지급액 계산
                    }
                    
                 break;
                 
                 //압류금액
                 case "SZR_AMT" :
                 
                    if (record.get('MERITS_PAY_AMT') == 0 ){
                        alert('"공제금액계산"을 먼저 진행해주시기 바랍니다.');
                        return false;
                    }
                 
                    record.set('RLPM_AMT', record.get('MERITS_PAY_AMT') - record.get('INTX_AMT')
                                                                        - record.get('LOC_INTX_AMT')
                                                                        - record.get('EMIN_AMT')
                                                                        - newValue
                                                                        - record.get('HLIN_EXCA_AMT')
                                                                        - record.get('EMIN_EXCA_AMT')
                                                                        - record.get('NP_EXCA_AMT'));
                 break;
                 
                 //건강보험
                 case "HLIN_EXCA_AMT" :
                 
                 if (record.get('MERITS_PAY_AMT') == 0 ){
                        alert('"공제금액계산"을 먼저 진행해주시기 바랍니다.');
                        return false;
                    }
                    
                    record.set('RLPM_AMT', record.get('MERITS_PAY_AMT') - record.get('INTX_AMT')
                                                                        - record.get('LOC_INTX_AMT')
                                                                        - record.get('EMIN_AMT')
                                                                        - record.get('SZR_AMT')
                                                                        - newValue
                                                                        - record.get('EMIN_EXCA_AMT')
                                                                        - record.get('NP_EXCA_AMT'));
                 break;
                 
                 //고용보험정산
                 case "EMIN_EXCA_AMT" :
                 
                 if (record.get('MERITS_PAY_AMT') == 0 ){
                        alert('"공제금액계산"을 먼저 진행해주시기 바랍니다.');
                        return false;
                    }
                    record.set('RLPM_AMT', record.get('MERITS_PAY_AMT') - record.get('INTX_AMT')
                                                                        - record.get('LOC_INTX_AMT')
                                                                        - record.get('EMIN_AMT')
                                                                        - record.get('SZR_AMT')
                                                                        - record.get('HLIN_EXCA_AMT')
                                                                        - newValue
                                                                        - record.get('NP_EXCA_AMT'));
                 break;
                 
                 //국민연금정산
                 case "NP_EXCA_AMT" :
//                    alert('국민연금정산 수정');
                    
                    if (record.get('MERITS_PAY_AMT') == 0 ){
                        alert('"공제금액계산"을 먼저 진행해주시기 바랍니다.');
                        return false;
                    }
                    
                    record.set('RLPM_AMT', record.get('MERITS_PAY_AMT') - record.get('INTX_AMT')
                                                                        - record.get('LOC_INTX_AMT')
                                                                        - record.get('EMIN_AMT')
                                                                        - record.get('SZR_AMT')
                                                                        - record.get('HLIN_EXCA_AMT')
                                                                        - record.get('EMIN_EXCA_AMT')
                                                                        - newValue);
                 break;
			}
			
			return rv;
		}
	});
};


</script>
