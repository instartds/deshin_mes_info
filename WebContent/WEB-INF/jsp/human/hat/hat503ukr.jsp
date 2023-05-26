<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat503ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H033" /> <!-- 근무코드 -->
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 -->
    <t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 사용여부 -->
    <t:ExtComboStore comboType="AU" comboCode="H002" /> <!-- 일구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.cell_row1 {
background-color: #fcfac5;
}

</style>
<script type="text/javascript" >

var excelWindow;	// 엑셀참조
var gsCount = 0;
function appMain() {
	
	var BsaCodeInfo = {
		gsActivFlag : '${gsActivFlag}'
	}
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hat503ukrModel', {
		fields: [
		    {name: 'COMP_CODE'          , text: '법인코드'         , type: 'string', allowBlank: false},
		    {name: 'DIV_CODE'           , text: '사업장'           , type: 'string', comboType:'BOR120'},
			{name: 'DUTY_YYYYMMDD'		, text: '근태일'		  	 , type: 'uniDate', allowBlank: false},
			{name: 'WEEK_DAY'    		, text: '요일코드'		 , type: 'int', maxLength: 2},
			{name: 'DAY_NAME'    		, text: '요일'			, type: 'string'},
			{name: 'HOLY_TYPE'          , text: '휴일/평일 구분'    , type: 'int', maxLength: 2},
            {name: 'HOLY_NAME'          , text: '휴일/평일'       , type: 'string'},
			{name: 'DEPT_CODE'    		, text: '부서코드'	   	, type: 'string'},
			{name: 'DEPT_NAME'    		, text: '부서명'			, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string', allowBlank: false, maxLength: 20},
			{name: 'PERSON_NAME'		, text: '성명'			, type: 'string', maxLength: 10},
			
			{name: 'DUTY_CHK_YN'    	, text: '확정'			, type: 'string', comboType:'AU', comboCode:'B010', defaultValue: 'N',   editable: true},
			{name: 'DUTY_CODE'          , text: '근태구분'        , type: 'string', comboType:'AU', comboCode:'H033'},
			
			{name: 'DUTY_FR_D'			, text: '일'			    , type: 'string', comboType:'AU', comboCode:'H002'},
			{name: 'DUTY_FR_H'			, text: '시'			    , type: 'uniNumber', maxLength: 2},
			{name: 'DUTY_FR_M'			, text: '분'			    , type: 'uniNumber', maxLength: 2},
			{name: 'DUTY_TO_D'			, text: '일'			    , type: 'string', comboType:'AU', comboCode:'H002'},			
			{name: 'DUTY_TO_H'    		, text: '시'			    , type: 'uniNumber', maxLength: 2},
			{name: 'DUTY_TO_M'    		, text: '분'			    , type: 'uniNumber', maxLength: 2},
			
			{name: 'TIME_H'		        , text: '시'			    , type: 'uniNumber', maxLength: 2},
			{name: 'TIME_M'		        , text: '분'			    , type: 'uniNumber', maxLength: 2},
			
			{name: 'WORK_TEAM'		     , text: '근무조'		        , type: 'string'},
			
			{name: 'REMARK'		        , text: '적요'		        , type: 'string'},
			{name: 'POST_CODE'		    , text: '직위'		        , type: 'string', comboType:'AU', comboCode:'H005'}
		]
	});
	
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'hat503ukrService.insertList',				
			read: 'hat503ukrService.selectList',
			update: 'hat503ukrService.updateList',
			destroy: 'hat503ukrService.deleteList',
			syncAll: 'hat503ukrService.saveAll'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create: 'hat503ukrService.insertCancelButtonList',  
            syncAll: 'hat503ukrService.saveAllCancelButton'
		}
	});
	
	//일괄확정
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create: 'hat503ukrService.insertCommitButtonList',  
            syncAll: 'hat503ukrService.saveAllCommitButton'
		}
	});
	
	//일괄확정 취소
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create: 'hat503ukrService.insertCancelButtonList',  
            syncAll: 'hat503ukrService.saveAllCancelButton'
		}
	});
	
	var directMasterStore1 = Unilite.createStore('hat503ukrMasterStore', {
		model: 'hat503ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
//		proxy: directProxy,
		proxy: {
            type: 'direct',
            api: {
                read    : 'hat503ukrService.select'
            }
        },
		loadStoreRecords: function(){
//			var param= Ext.getCmp('searchForm').getValues();
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params: param
			});
		},
		
		
		commit : function()    {               
            var inValidRecs = this.getInvalidRecords();
            if(inValidRecs.length == 0 )    {
                config = {
//                  params: [paramMaster],
                    success: function(batch, option) {
                        
                     } 
                };
                this.syncAllDirect(config);             
            }else {                 
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
		
		
        saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				config = {
//					params: [paramMaster],
					success: function(batch, option) {
						
					 } 
				};
				this.syncAllDirect(config);				
			}else {    				
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			/*load: function(store, records, successful, eOpts) {*/
			load: function(store, records, successful, eOpts) {
				if (this.getCount() > 0) {
                    Ext.each(records, function(record,i){
                    	if(record.get('P_COUNT') == 1) {
                    		gsCount ++
                    	}
                    });
                    Ext.getCmp('tbarA').setValue(gsCount);
                } else {
                	gsCount = 0;
                }  Ext.getCmp('tbarA').setValue(gsCount);
			}
		}
	});	

	//확정승인 버튼
	var commitButtonStore = Unilite.createStore('hat503ukrcommitButtonStore',{      
        uniOpt  : {
            isMaster    : false,            // 상위 버튼 연결 
            editable    : false,            // 수정 모드 사용 
            deletable   : false,            // 삭제 가능 여부 
            useNavi     : false             // prev | newxt 버튼 사용
        },
        proxy   : directProxy3,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            
            var paramMaster = panelResult.getValues();  //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        
                        buttonFlag = '';
                        UniAppManager.app.onQueryButtonDown();
                     },
                     failure: function(batch, option) {
                        buttonFlag = '';
                        
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('hat503ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
    });
	
	
    //확정취소 버튼
    var CancelButtonStore = Unilite.createStore('hat503ukrCalcelButtonStore',{      
        uniOpt  : {
            isMaster    : false,            // 상위 버튼 연결 
            editable    : false,            // 수정 모드 사용 
            deletable   : false,            // 삭제 가능 여부 
            useNavi     : false             // prev | newxt 버튼 사용
        },
        proxy   : directProxy4,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            
            var paramMaster = panelResult.getValues();  //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        
                        buttonFlag = '';
                        UniAppManager.app.onQueryButtonDown();
                     },
                     failure: function(batch, option) {
                        buttonFlag = '';
                        
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('hat503ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
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
				fieldLabel: '근태일자',
				xtype: 'uniDatefield',
				name: 'DUTY_DATE',                    
				value: new Date(),                    
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DUTY_DATE', newValue);
					}
				}
			},Unilite.popup('Employee',{
					fieldLabel: '사원',
				  	valueFieldName:'PERSON_NUMB',
				    textFieldName:'NAME',
					validateBlank:false,
					autoPopup:true,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('NAME', newValue);				
						}
					}
				}),{
    			fieldLabel: '사업장',
    			name: 'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		},
			Unilite.popup('DEPT',{
                fieldLabel      : '부서',
                valueFieldName  : 'DEPT_CODE',
                textFieldName   : 'DEPT_NAME',
                validateBlank   : false,                    
                tdAttrs         : {width: 380},  
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
                            panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));                                                                                                           
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('DEPT_CODE', '');
                        panelResult.setValue('DEPT_NAME', '');
                    }
                }
            }),{
                fieldLabel: '근태구분',
                name: 'DUTY_CODE', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H033',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DUTY_CODE', newValue);
                    }
                }
            },
            
            {
                xtype: 'radiogroup',                            
                fieldLabel: '확정여부',
                items: [{
                    boxLabel: '전체',
                    width: 60,
                    name: 'DUTY_CHK_YN2',
                    inputValue: '',
                    checked: true
                    
                }, {
                    boxLabel: '확정',
                    width: 60,
                    name: 'DUTY_CHK_YN2',
                    inputValue: 'Y'
                }, 
                {
                    boxLabel: '미확정',
                    width: 60,
                    name: 'DUTY_CHK_YN2',
                    inputValue: 'N'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.getField('DUTY_CHK_YN2').setValue(newValue.DUTY_CHK_YN2);
                    }
                } 
            }
            /*{
                fieldLabel: ' ',
                xtype: 'uniCheckboxgroup', 
                items: [{
                    boxLabel: '확정된것만 조회',
                    name: 'DUTY_CHK_YN2',
                    width: 300,
                    inputValue: 'Y',
                    uncheckedValue: 'N',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('DUTY_CHK_YN2', newValue);
                        }
                    }
                }]
            }*/
            ,{
			    fieldLabel: ' ',
			    xtype: 'uniCheckboxgroup', 
			    items: [{
			    	boxLabel: '이상근태만조회',
			        name: 'DUTY_CHK_YN',
			        width: 300,
			        inputValue: 'Y',
                    uncheckedValue: 'N',
			        listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DUTY_CHK_YN', newValue);
						}
					}
				}]
   			}
   			
		,{
            xtype: 'uniTextfield',
            hidden:true,
            name: 'FILE_ID'                  // CSV UPLOAD 시 반드시 존재해야함.
        },{
            xtype: 'uniTextfield',
            hidden:true,
            name: 'CSV_LOAD_YN'              // CSV UPLOAD 시 반드시 존재해야함.
        },{
            xtype: 'uniTextfield',
            hidden:true,
            name: 'PGM_ID'                   // CSV UPLOAD 시 반드시 존재해야함.
        }]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '근태일자',
			xtype: 'uniDatefield',
			name: 'DUTY_DATE',                    
			value: new Date(),                    
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DUTY_DATE', newValue);
				}
			}
		},
		Unilite.popup('Employee',{
					fieldLabel: '사원',
				  	valueFieldName:'PERSON_NUMB',
				    textFieldName:'NAME',
					colspan:2,
					validateBlank:false,
					autoPopup:true,
					listeners: {						
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('NAME', newValue);				
						}
					}
				}),
			{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			colspan: 2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('DEPT',{
                fieldLabel      : '부서',
                valueFieldName  : 'DEPT_CODE',
                textFieldName   : 'DEPT_NAME',
                validateBlank   : false,                    
                tdAttrs         : {width: 380},  
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
                            panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));                                                                                                           
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('DEPT_CODE', '');
                        panelSearch.setValue('DEPT_NAME', '');
                    }
                }
            }),{
			fieldLabel: '근태구분',
                name: 'DUTY_CODE', 
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H033',
                /*allowBlank: false,*/
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DUTY_CODE', newValue);
                    }
                }
		},
		{
                xtype: 'radiogroup',                            
                fieldLabel: '확정여부',
                items: [{
                    boxLabel: '전체',
                    width: 60,
                    name: 'DUTY_CHK_YN2',
                    inputValue: '',
                    checked: true
                }, {
                    boxLabel: '확정',
                    width: 60,
                    name: 'DUTY_CHK_YN2',
                    inputValue: 'Y'
                }, 
                {
                    boxLabel: '미확정',
                    width: 60,
                    name: 'DUTY_CHK_YN2',
                    inputValue: 'N'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('DUTY_CHK_YN2').setValue(newValue.DUTY_CHK_YN2);
                    }
                }  
            }
		/*{
				fieldLabel: ' ',
            xtype: 'uniCheckboxgroup', 
            items: [{
                boxLabel: '확정된것만 조회',
                name: 'DUTY_CHK_YN2',
                width: 300,
                inputValue: 'Y',
                uncheckedValue: 'N',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DUTY_CHK_YN2', newValue);
//                          alert(newValue); // true|false
                        
                    }
                }
            }]
		}*/
		,{
		    fieldLabel: ' ',
		    xtype: 'uniCheckboxgroup', 
		    items: [{
		    	boxLabel: '이상근태만조회',
		        name: 'DUTY_CHK_YN',
		        width: 300,
		        inputValue: 'Y',
                uncheckedValue: 'N',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DUTY_CHK_YN', newValue);
//							alert(newValue); // true|false
						
					}
				}
			}]
		}]	
    });
    

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    //에러
    var masterGrid = Unilite.createGrid('hat503ukrGrid', {
        layout: 'fit',    
        region : 'center',   
    	store: directMasterStore1,
        uniOpt:{
        	expandLastColumn: false,
        	useRowNumberer: true,
            useMultipleSorting: true,
            onLoadSelectFirst   : false
    	},
    	tbar: [{
        	xtype:'button',
        	text:'출근확정',
        	hidden : true,
        	handler:function()	{
        		if(masterGrid.getSelectedRecords().length > 0 ){
        				alert("명세서출력 레포트는 현재 없습니다.");
		    		}
		    		else{
		    			alert("선택된 자료가 없습니다.");
		    		}
        		}
		},{
        	xtype:'button',
        	text:'퇴근확정',
        	hidden : true,
        	handler:function()	{
        		if(masterGrid.getSelectedRecords().length > 0 ){
        				alert("집계표출력 레포트는 현재 없습니다.");
		    		}
		    		else{
		    			alert("선택된 자료가 없습니다.");
		    		}
        		}
		},{
            xtype:'button',
            text:'확정 승인',
            id:'commitBtn',
            handler:function()  {
            	/*if(directMasterStore1.count() == 0 ){
                        alert("조회된 데이터가 없습니다..");
                        return;
                }
                 
            	directMasterStore1.setProxy(directProxy3);
            	directMasterStore1.loadStoreRecords();

            	if(!directMasterStore1.getCount() > 0){
            	   this.setHidden(false);
            	}*/
/*            	if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}*/
            	
            	if(directMasterStore1.isDirty())	{
					alert('확정승인을 하려면 먼저 저장하세요.');
    					return false;
				}
				
            	var selectedRecords = masterGrid.getSelectedRecords();
                if(selectedRecords.length > 0){
                
                    commitButtonStore.clearData();
                    Ext.each(selectedRecords, function(record,i){
                        record.phantom = true;
                        commitButtonStore.insert(i, record);
                    });
                    buttonFlag = '';
                    commitButtonStore.setProxy(directProxy3);
                    commitButtonStore.saveStore();
                                            
                }else{
                    Ext.Msg.alert('확인','확정승인 할 데이터를 선택해 주세요.'); 
                }
            }
        },{
            xtype:'button',
            text:'확정 취소',
            id:'cancelBtn',
            handler:function()  {
                /*if(directMasterStore1.count() == 0 ){
                        alert("조회된 데이터가 없습니다..");
                        return;
                }
                 
                directMasterStore1.setProxy(directProxy3);
                directMasterStore1.loadStoreRecords();

                if(!directMasterStore1.getCount() > 0){
                   this.setHidden(false);
                }*/
                if(directMasterStore1.isDirty())	{
					alert('확정취소를 하려면 먼저 저장하세요.');
    					return false;
				}
				
                var selectedRecords = masterGrid.getSelectedRecords();
                if(selectedRecords.length > 0){
                
                    CancelButtonStore.clearData();
                    Ext.each(selectedRecords, function(record,i){
                        record.phantom = true;
                        CancelButtonStore.insert(i, record);
                    });
                    buttonFlag = '';
                    CancelButtonStore.setProxy(directProxy4);
                    CancelButtonStore.saveStore();
                                            
                }else{
                    Ext.Msg.alert('확인','확정취소 할 데이터를 선택해 주세요.'); 
                }
            }
        },{
        	xtype:'button',
        	text:'근태파일 업로드',
        	handler:function()	{
        		
        		if(directMasterStore1.isDirty())	{
					alert('파일업로드를 하려면 먼저 저장하세요.');
					return false;
				}
				var param={
					"DUTY_YYYYMMDD"		: UniDate.getDateStr(panelResult.getValue("DUTY_DATE"))
				}
	        	hat503ukrService.checkData(param, function(provider, response) {
	                if(!Ext.isEmpty(provider)){
						alert('이미 저장된 데이터가 존재 합니다.');
						return false;
	                }else{
			    		directMasterStore1.setProxy(directProxy2);
			    		openExcelWindow();
	                }
	        	});
    		}
		}
		,{
            xtype:'button',
            text:'데이터 일괄생성',
            hidden:true,//추후 false 예정 
            handler:function()  {
            	
            	if(directMasterStore1.isDirty())	{
					alert('데이터 일괄생성을 하려면 먼저 저장하세요.');
    					return false;
				}
				
	 			if(!panelSearch.getInvalidMessage()){
					return false;
				} else { 
        	       if (Ext.isEmpty(panelSearch.getValue('DUTY_CODE')))
        	       {alert('근태구분은 필수입력항목입니다.')}
        	       else {
        	               if (panelSearch.isValid()) {
                                if(confirm('실행 하시겠습니까?')){
                                    runProc();
                                }               
                            }
                         }
            
                    }
            }
        }
		,{
            fieldLabel:'인원수',
            labelAlign : 'right',
            labelStyle: "color: blue;",
            width: 200,
            xtype:'uniNumberfield',
            id:'tbarA',
            name:'AAA',
            readOnly:true
        }
          ],
		
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true }),
		
    	columns:  [         				
					{dataIndex: 'COMP_CODE'         	 , width: 100, hidden: true},
					{dataIndex: 'DIV_CODE'               , width: 100},
					{dataIndex: 'DUTY_YYYYMMDD'          , width: 110},
					{dataIndex: 'WEEK_DAY'         	  	 , width: 100, hidden: true},
					{dataIndex: 'DAY_NAME'         	  	 , width: 100, align:'center'},
					{dataIndex: 'HOLY_TYPE'              , width: 100, hidden: true},
					{dataIndex: 'HOLY_NAME'              , width: 100, align:'center'},
    				{dataIndex: 'DEPT_CODE'      		 , width: 120, hidden: true},
    				{dataIndex: 'DEPT_NAME'      		 , width: 130},
					{dataIndex: 'PERSON_NUMB'       	 , width: 100,
						'editor' : Unilite.popup('Employee_G1',{
							validateBlank : true,
							autoPopup:true,
			  				listeners: {
			  					'onSelected': {
									fn: function(records, type) {
											console.log('records : ', records);
											console.log(records);
											var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
											grdRecord.set('DIV_CODE', records[0].DIV_CODE);
											grdRecord.set('DUTY_DATE', panelSearch.getValue('DUTY_DATE'));
											grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
											grdRecord.set('DEPT_CODE', records[0].DEPT_CODE);
											grdRecord.set('NAME', records[0].NAME);
											grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
											//근무조 컬럼에 데이터를 넣음
											var params = {
												S_COMP_CODE: UserInfo.compCode, 
												DUTY_DATE: dateChange(panelSearch.getValue('DUTY_DATE')),
												PERSON_NUMB: records[0].PERSON_NUMB
											}												
											hat520ukrService.getWorkTeam(params, function(provider, response)	{							
												if(!Ext.isEmpty(provider)){
													grdRecord.set('WORK_TEAM', provider);
												}													
											});			
											
											
										},			  						
	 								scope: this
	 							},
	 							'onClear': function(type) {
	 								var grdRecord = Ext.getCmp('hat503ukrGrid').uniOpt.currentRecord;
	  								grdRecord.set('PERSON_NUMB','');
	  								grdRecord.set('NAME','');
	  								grdRecord.set('DEPT_CODE','');
	  								grdRecord.set('DEPT_NAME','');
								},
								applyextparam: function(popup){	
									popup.setExtParam({'PAY_GUBUN' : '2'});
								}
			 				}
						})
					},
					{dataIndex: 'PERSON_NAME'              	  	, width: 100    , align:'center' , 
					'editor' : Unilite.popup('Employee_G1',{
							validateBlank : true,
							autoPopup:true,
			  				listeners: {
			  					'onSelected': {
                                    fn: function(records, type) {
                                            console.log('records : ', records);
                                            console.log(records);
                                            var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
                                            grdRecord.set('DIV_CODE', records[0].DIV_CODE);
                                            grdRecord.set('DUTY_DATE', panelSearch.getValue('DUTY_DATE'));
                                            grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
                                            grdRecord.set('DEPT_CODE', records[0].DEPT_CODE);
                                            grdRecord.set('PERSON_NAME', records[0].NAME);
                                            grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
                                            //근무조 컬럼에 데이터를 넣음
                                            var params = {
                                                S_COMP_CODE: UserInfo.compCode, 
                                                DUTY_DATE: dateChange(panelSearch.getValue('DUTY_DATE')),
                                                PERSON_NUMB: records[0].PERSON_NUMB
                                            }
                                            hat520ukrService.getWorkTeam(params, function(provider, response)   {
                                                if(!Ext.isEmpty(provider)){
                                                    grdRecord.set('WORK_TEAM', provider);
                                                }                                                   
                                            });         
                                            
                                            
                                        },                                  
                                    scope: this
                                },
	 							'onClear': function(type) {
	 								var grdRecord = Ext.getCmp('hat503ukrGrid').uniOpt.currentRecord;
	  								grdRecord.set('PERSON_NUMB','');
	  								grdRecord.set('PERSON_NAME','');
	  								grdRecord.set('DEPT_CODE','');
	  								grdRecord.set('DEPT_NAME','');
								},
								applyextparam: function(popup){	
									popup.setExtParam({'PAY_GUBUN' : '2'});
								}	
			 				}
						})
					},
					{dataIndex: 'DUTY_CHK_YN'			, width: 100, align:'center'}, 		
					{dataIndex: 'DUTY_CODE'				, width: 130}, 
					
					{text : '출근',
                        columns : [ 
				            {dataIndex: 'DUTY_FR_D'				, width: 80, align:'center'},
                            {dataIndex: 'DUTY_FR_H'             , width: 70,
								renderer: function(value, metaData, record) {
									if(value== 0){
										metaData.tdCls = 'cell_row1';
									}
									return value;
								}
							},               
                            {dataIndex: 'DUTY_FR_M'             , width: 70,
								renderer: function(value, metaData, record) {
									if(value== 0){
										metaData.tdCls = 'cell_row1';
									}
									return value;
								}
							}
				        ]
					},
                    {text : '퇴근',
                        columns : [ 
                            {dataIndex: 'DUTY_TO_D'             , width: 80, align:'center'},
                            {dataIndex: 'DUTY_TO_H'             , width: 70,
								renderer: function(value, metaData, record) {
									if(value== 0){
										metaData.tdCls = 'cell_row1';
									}
									return value;
								}
							},               
                            {dataIndex: 'DUTY_TO_M'             , width: 70,
								renderer: function(value, metaData, record) {
									if(value== 0){
										metaData.tdCls = 'cell_row1';
									}
									return value;
								}
							}
                        ]
                    },
//                    {text : '근태',
//                        columns : [ 
//                            {dataIndex: 'TIME_H'          , width: 70},
//                            {dataIndex: 'TIME_M'          , width: 70, hidden: false}
//                        ]
//                    },
                   
					{dataIndex: 'WORK_TEAM'				, width: 80},
					
					{dataIndex: 'REMARK'				, width: 150, hidden: false},
					{dataIndex: 'POST_CODE'				, width: 120, hidden: true}
          ],
   /*     viewConfig:{
			getRowClass : function(record,rowIndex,rowParams,store){
				var cls = '';
				if(record.get('DUTY_FR_H')== 0 && record.get('DUTY_FR_M')== 0
				&& record.get('DUTY_TO_H')== 0 && record.get('DUTY_TO_M')== 0
				){
					cls = 'cell_row1';
				}
				return cls;
			}
		},*/
        listeners: {
          	beforeedit: function( editor, e, eOpts ) {	
//          		if(UniUtils.indexOf(e.field, ['DUTY_DATE'])) {
//					if(e.record.phantom == true) {
//	        			return true;
//	        		}else{
//	        			return false;
//	        		}
//				}
          		
				if(e.record.data.DUTY_CHK_YN == 'Y'){
          			return false;
				}else{
	          		if(UniUtils.indexOf(e.field, ['DUTY_YYYYMMDD', 'DAY_NAME', 'DEPT_NAME'])) {
	                    return false;
	                }else{
	                	
	                	if(!e.record.phantom == true) {
		                	if (UniUtils.indexOf(e.field, ['PERSON_NUMB', 'PERSON_NAME'])){
		                        return false;
		                	}
	                	}
	                }
				}
        /*  		
          		
          		
          		if(!e.record.phantom == true) { //신규가 아닐 경우
          			
          			
          			
                    if (UniUtils.indexOf(e.field, ['PERSON_NUMB', 'PERSON_NAME']))
                        return false;
                }
          		if(!e.record.phantom == true || e.record.phantom == true) {     // 신규이던 아니던
                    if(UniUtils.indexOf(e.field, ['DUTY_YYYYMMDD', 'DAY_NAME', 'DEPT_NAME'])) {
                        return false;
                    }
          		}*/
	        }
         } 
    });
    
    
    //데이터 일괄생성
    function runProc() {     
    	Ext.getCmp('pageAll').getEl().mask('생성중...');    // mask on
        var param= Ext.getCmp('searchForm').getValues();
        param.RE_TRY = "";

        /*panelSearch.getEl().mask('급여계산 중...','loading-indicator');*/
        hat503ukrService.procSP(param, function(provider, response)  {
            console.log("response", response);
            console.log("provider", provider);
            
            if(!Ext.isEmpty(provider)){
                if(provider.ERROR_CODE == "Y")  {
                    if(confirm('기존 데이터를 삭제하고 \n 새로운 데이터를 생성하시겠습니까?')){
                        reRunProc();
                    }else{
                        
                        Ext.getCmp('pageAll').getEl().unmask();	
                    }//급여작업이 완료되었습니다.
                } else if(provider.ERROR_CODE == "") {
                    UniAppManager.app.onQueryButtonDown(); 
                    
                    Ext.getCmp('pageAll').getEl().unmask();
                }
            }
            
        }); 
    }
    
    //데이터 일괄생성
    function reRunProc() {        
        var param= Ext.getCmp('searchForm').getValues();
        param.RE_TRY = "Y";

        hat503ukrService.procSP(param, function(provider, response)  {
            console.log("response", response);
            console.log("provider", provider);
            if(!Ext.isEmpty(provider)){
                if(provider.ERROR_CODE == "")  {
                    alert("생성이 완료되었습니다."); 

                    UniAppManager.app.onQueryButtonDown();
                    
                    Ext.getCmp('pageAll').getEl().unmask();
                } 
            }
                              
        }); 
    }
    
    

	Unilite.Main( {
		 borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			id:'pageAll',
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id: 'hat503ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('DUTY_DATE', UniDate.get('today'));
			panelResult.setValue('DUTY_DATE', UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('newData', false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			
			panelSearch.getForm().getFields().each(function(field) {
                    field.setReadOnly(false);
            });
			panelResult.getForm().getFields().each(function(field) {
                    field.setReadOnly(false);
            });
			
			activeSForm.onLoadSelectText('DUTY_DATE');
			Ext.getCmp('tbarA').setValue(gsCount);
			
			if(BsaCodeInfo.gsActivFlag != 'Y'){
				Ext.getCmp('commitBtn').disable();
				Ext.getCmp('cancelBtn').disable();
			}
		},
		
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			gsCount = 0;
			panelResult.setValue('FILE_ID', '');              //초기값 세팅
            panelResult.setValue('CSV_LOAD_YN', 'N');         //초기값 세팅
			//masterGrid.getStore().loadStoreRecords();
            directMasterStore1.setProxy(directProxy1);
			directMasterStore1.loadStoreRecords(); 
			UniAppManager.setToolbarButtons('reset', true); 
			
			
//			Ext.getCmp('tbarA').setValue(0);
			
//			alert('storeCNT : ' + directMasterStore1.getCount());
			if(directMasterStore1.getCount() > 0){
				
    			panelSearch.getForm().getFields().each(function(field) {
                        field.setReadOnly(false);
                });
                panelResult.getForm().getFields().each(function(field) {
                        field.setReadOnly(false);
                });
				
//                Ext.getCmp('commitBtn').enable();
//                Ext.getCmp('cancelBtn').disable();
            }
			
		},
		
		onCommitAllButtonDown: function() {
            if(!this.isValidSearchForm()){
                return false;
            }
            directMasterStore1.setProxy(directProxy3);
            directMasterStore1.loadStoreRecords(); 
            
        },
		
		
		onNewDataButtonDown: function()	{		// 행추가
			
			var grdRecord = masterGrid.getSelectedRecord();
			var compCode = UserInfo.compCode; 
			var dutyDate = panelSearch.getValue('DUTY_DATE');
			var dayName = panelSearch.getValue('DAY_NAME');
        	
        	var r ={
        		COMP_CODE			: compCode,
        		DUTY_DATE  			: dutyDate,
        		DAY_NAME			: grdRecord.get('DAY_NAME')

        	};
            //param = {'SEQ':seq}
	        masterGrid.createRow(r);
		},
		onSaveDataButtonDown : function() {
			
			directMasterStore1.saveStore();

		},
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.get('DUTY_CHK_YN') == 'Y'){
				alert('확정된 데이터는 삭제가 불가능 합니다.');
				return;
			}else{
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            directMasterStore1.loadStoreRecords({});
            this.fnInitBinding();
        }
	});//End of Unilite.Main( {
		
	function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.TXTUpload';

        if (!excelWindow) {
            excelWindow = Ext.create(appName, {
                modal : false,

                excelConfigName : 'hat503ukr',
                listeners : {
                    beforehide: function(me, eOpt) {
                    },
                    beforeclose: function( me, eOpts ) {
                    },
                    hide: function ( me, eOpts ) {
                    	if(me.fileIds != null && me.fileIds.length > 0) {
                    		console.log("me.fileIds.length :: " + me.fileIds.length);
                    		console.log("me.fileIds :: " + me.fileIds[0]);

                    		masterGrid.getEl().mask('저장중...','loading-indicator');    // mask on
                    		
                    		panelSearch.setValue('FILE_ID', me.fileIds[0]);               // 추가 파일 담기
                    		panelSearch.setValue('CSV_LOAD_YN', 'Y');                     // 초기값 세팅
                    		panelSearch.setValue('PGM_ID', 'hat503ukr');                  // 초기값 세팅
                    		
                    		var param = Ext.getCmp('searchForm').getValues();
                    		hat503ukrService.select(param, function(provider, response)  {    
                    			if(!Ext.isEmpty(provider)) {
                        			panelSearch.setValue('DUTY_DATE', provider[0].DUTY_YYYYMMDD);
                                    panelResult.setValue('DUTY_DATE', provider[0].DUTY_YYYYMMDD);
                                    masterGrid.getEl().unmask();  
                                    UniAppManager.app.onQueryButtonDown();
                    			} else {
                    				masterGrid.getEl().unmask();  
                    			}
                            });                                                             // text 파일 읽고, 조회하기
                    		                               // mask off
                    	} else {
                    		console.log('업로드된 파일 없음.');
                    	}
                    },
                    show: function ( me, eOpts ) {
                    }
                }
            });
        }
        excelWindow.center();
        excelWindow.show();
    }
	
	// 쿼리 조건에 이용하기 위하여 근태년월의 형식을 변경함
	function dateChange(value) {
		if (value == null || value == '') return '';
		var year = value.getFullYear();
		var mon = value.getMonth() + 1;
		var day = value.getDate();   
		return year + '' + (mon >= 10 ? mon : '0' + mon) + '' + day;
	}	
	

	
};


</script>
