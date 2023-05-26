<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat501ukr"  >
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
</style>
<script type="text/javascript" >

var excelWindow;	// 엑셀참조

function appMain() {
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hat501ukrModel', {
		fields: [
			{name: 'DUTY_DATE'			, text: '근무일'			, type: 'uniDate', allowBlank: false},
			{name: 'WEEK_DAY'    		, text: '요일코드'			, type: 'int', maxLength: 2},
			{name: 'DAY_NAME'    		, text: '요일'			, type: 'string'},
			{name: 'DEPT_CODE'    		, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'    		, text: '부서명'			, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string', allowBlank: false, maxLength: 20},
			{name: 'NAME'		   		, text: '성명'			, type: 'string', maxLength: 10},
			{name: 'WORK_TEAM'    		, text: '근무조'			, type: 'string', comboType:'AU', comboCode:'H004'},
			{name: 'WORK_TEAM_NAME'    	, text: '근무조명'			, type: 'string'},
			{name: 'DUTY_CODE'			, text: '근태구분'			, type: 'string', comboType:'AU', comboCode:'H033', maxLength: 20},
			{name: 'APPLY_YN'    	    , text: '일괄확정'		    , type: 'string'}, //일괄확정
			{name: 'DUTY_CHK1_YN'    	, text: '확정'			, type: 'string', comboType:'AU', comboCode:'B010', defaultValue: 'N'},
			{name: 'DUTY_FR_D'			, text: '일'			    , type: 'string', comboType:'AU', comboCode:'H002'},
			{name: 'DUTY_FR_H'			, text: '시'			    , type: 'uniNumber', maxLength: 2},
			{name: 'DUTY_FR_M'			, text: '분'			    , type: 'uniNumber', maxLength: 2},
			{name: 'DUTY_TO_D'			, text: '일'			    , type: 'string', comboType:'AU', comboCode:'H002'},			
			{name: 'DUTY_TO_H'    		, text: '시'			    , type: 'uniNumber', maxLength: 2},
			{name: 'DUTY_TO_M'    		, text: '분'			    , type: 'uniNumber', maxLength: 2},
			{name: 'OVERTIME_1_H'		, text: '시'			    , type: 'uniNumber', maxLength: 2},
			{name: 'OVERTIME_1_M'		, text: '분'			    , type: 'uniNumber', maxLength: 2},
			{name: 'OVERTIME_2_H'		, text: '시'		        , type: 'uniNumber', maxLength: 2},
			{name: 'OVERTIME_2_M'		, text: '분'		        , type: 'uniNumber', maxLength: 2},
            {name: 'OVERTIME_3_H'       , text: '시'             , type: 'uniNumber', maxLength: 2},
            {name: 'OVERTIME_3_M'       , text: '분'             , type: 'uniNumber', maxLength: 2},
			{name: 'LATENESS_H'    		, text: '시'			    , type: 'uniNumber', maxLength: 2},			
			{name: 'LATENESS_M'			, text: '분'			    , type: 'uniNumber', maxLength: 2},
			{name: 'EARLY_H'    		, text: '시'			    , type: 'uniNumber', maxLength: 2},			
			{name: 'EARLY_M'			, text: '분'			    , type: 'uniNumber', maxLength: 2},
			{name: 'OUT_H'    			, text: '시'			    , type: 'uniNumber', maxLength: 2},		//	
			{name: 'OUT_M'				, text: '분'			    , type: 'uniNumber', maxLength: 2},
			{name: 'HOLY_TYPE'    		, text: '근무조코드'		, type: 'string'},
			{name: 'HOLY_NAME'    		, text: '근무조명'			, type: 'string'},
			{name: 'CAL_DATE'    		, text: '달력'			, type: 'uniDate'},
			{name: 'CAL_NO'    			, text: '주'				, type: 'int', maxLength: 2},		
			{name: 'DIV_CODE'     		, text: '사업장'			, type: 'string', comboType:'BOR120'},
			{name: 'REMARK'       		, text: '비고'			, type: 'string', maxLength: 150}
		]
	});
	
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'hat501ukrService.insertList',				
			read: 'hat501ukrService.selectList',
			update: 'hat501ukrService.updateList',
			destroy: 'hat501ukrService.deleteList',
			syncAll: 'hat501ukrService.saveAll'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hat501ukrService.select'
		}
	});
	
	//일괄확정
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hat501ukrService.commitAll'
		}
	});
	
	//일괄확정 취소
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hat501ukrService.cancelAll'
		}
	});
	
	
	
	
	
	
	
//	var directMasterStore = Unilite.createStore('hat501ukrMasterStore', {
//		model: 'hat501ukrModel',
//		uniOpt: {
//			isMaster: true,			// 상위 버튼 연결 
//			editable: true,			// 수정 모드 사용 
//			deletable: true,			// 삭제 가능 여부 
//			useNavi: false			// prev | newxt 버튼 사용
//		},
//		autoLoad: false,
//		proxy: directProxy,
////		proxy: {
////                type: 'direct',
////                api: {
////                    read    : 'hat501ukrService.select'
////                }
////            },
//		loadStoreRecords: function(){
//			var param= Ext.getCmp('searchForm').getValues();			
//			console.log(param);
//			this.load({
//				params: param
//			});
//		},
//        saveStore : function()	{				
//			var inValidRecs = this.getInvalidRecords();
//			if(inValidRecs.length == 0 )	{
//				config = {
////					params: [paramMaster],
//					success: function(batch, option) {
//						
//					 } 
//				};
//				this.syncAllDirect(config);				
//			}else {    				
//				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
//			}
//		},
//		listeners: {
//			load: function() {
//				if (this.getCount() > 0) {
////	              	UniAppManager.setToolbarButtons('delete', true);
//	                } else {
////	              	  	UniAppManager.setToolbarButtons('delete', false);
//	                }  
//			}
//		}
//	});	
	

	
	var directMasterStore1 = Unilite.createStore('hat501ukrMasterStore', {
		model: 'hat501ukrModel',
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
                read    : 'hat501ukrService.select'
            }
        },
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
//			alert(param.DUTY_CHK_YN);
			console.log(param);
			this.load({
				params: param
			});
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
			load: function() {
				if (this.getCount() > 0) {
//	              	UniAppManager.setToolbarButtons('delete', true);
	                } else {
//	              	  	UniAppManager.setToolbarButtons('delete', false);
	                }  
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
						/*onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
								panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('PERSON_NUMB', '');
							panelResult.setValue('NAME', '');
						}*/
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
			}),{
				fieldLabel: '근무조',
				name: 'WORK_TEAM', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H004',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_TEAM', newValue);
					}
				}
			},{
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
			},{
			    fieldLabel: ' ',
			    xtype: 'uniCheckboxgroup', 
			    items: [{
			    	boxLabel: '이상근태만조회',
			        name: 'DUTY_CHK_YN',
			        width: 300,
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
						/*onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
								panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('PERSON_NUMB', '');
							panelSearch.setValue('NAME', '');
						}*/
						
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
		}),{
			fieldLabel: '근무조',
			name: 'WORK_TEAM', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H004',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_TEAM', newValue);
				}
			}
		},{
				fieldLabel: '근태구분',
				name: 'DUTY_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H033',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DUTY_CODE', newValue);
					}
				}
			},{
			    fieldLabel: ' ',
			    xtype: 'uniCheckboxgroup', 
			    items: [{
			    	boxLabel: '이상근태만조회',
			        name: 'DUTY_CHK_YN',
			        width: 300,
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
    var masterGrid = Unilite.createGrid('hat501ukrGrid', {
        layout: 'fit',    
        region : 'center',   
    	store: directMasterStore1,
        uniOpt:{
        	expandLastColumn: false,
        	useRowNumberer: true,
            useMultipleSorting: true
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
            text:'일괄확정',
            id:'commitBtn',
//            hidden : true,
            handler:function()  {
            	if(directMasterStore1.count() == 0 ){
                        alert("조회된 데이터가 없습니다..");
                        return;
                }
                 
            	directMasterStore1.setProxy(directProxy3);
            	directMasterStore1.loadStoreRecords();
//                directMasterStore1.setProxy(directProxy2);
//                openExcelWindow();
            	if(!directMasterStore1.getCount() > 0){
            	   this.setHidden(false);
            	}
            	
            }
        },{
            xtype:'button',
            text:'일괄확정 취소',
            id:'cancleBtn',
//            hidden : true,
            handler:function()  {
            	   if(directMasterStore1.count() == 0 ){
                        alert("조회된 데이터가 없습니다..");
                   return;
                }
                 
                directMasterStore1.setProxy(directProxy4);
                directMasterStore1.loadStoreRecords();
//                directMasterStore1.setProxy(directProxy2);
//                openExcelWindow();
                if(!directMasterStore1.getCount() > 0){
                   this.setHidden(false);
                }
            	
            }
        },{
        	xtype:'button',
        	text:'근태파일 업로드',
        	handler:function()	{
        		directMasterStore1.setProxy(directProxy2);
        		openExcelWindow();
        		}
		}],
		
    	columns:  [         				
					{dataIndex: 'DUTY_DATE'         	  	, width: 80},
					{dataIndex: 'WEEK_DAY'         	  		, width: 66, hidden: true},
					{dataIndex: 'DAY_NAME'         	  		, width: 66},
    				{dataIndex: 'DEPT_CODE'      			, width: 120, hidden: true},
    				{dataIndex: 'DEPT_NAME'      			, width: 120},
					{dataIndex: 'PERSON_NUMB'       	  	, width: 90,
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
	 								var grdRecord = Ext.getCmp('hat501ukrGrid').uniOpt.currentRecord;
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
					{dataIndex: 'NAME'              	  	, width: 100,
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
                                            hat520ukrService.getWorkTeam(params, function(provider, response)   {
                                                if(!Ext.isEmpty(provider)){
                                                    grdRecord.set('WORK_TEAM', provider);
                                                }                                                   
                                            });         
                                            
                                            
                                        },                                  
                                    scope: this
                                },
	 							'onClear': function(type) {
	 								var grdRecord = Ext.getCmp('hat501ukrGrid').uniOpt.currentRecord;
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
					{dataIndex: 'WORK_TEAM'				, width: 133}, 		
					{dataIndex: 'WORK_TEAM_NAME'		, width: 133, hidden: true},
					{dataIndex: 'DUTY_CODE'				, width: 110}, 
					
					{dataIndex: 'APPLY_YN'			  , width: 110}, // hidden : true},
					{dataIndex: 'DUTY_CHK1_YN'			, width: 110},
					{text : '출근',
                        columns : [ 
				            {dataIndex: 'DUTY_FR_D'				, width: 70},
                            {dataIndex: 'DUTY_FR_H'             , width: 70},               
                            {dataIndex: 'DUTY_FR_M'             , width: 70}
				        ]
					},
                    {text : '퇴근',
                        columns : [ 
                            {dataIndex: 'DUTY_TO_D'             , width: 70},
                            {dataIndex: 'DUTY_TO_H'             , width: 70},               
                            {dataIndex: 'DUTY_TO_M'             , width: 70}
                        ]
                    },
                    {text : '연장',
                        columns : [ 
                            {dataIndex: 'OVERTIME_1_H'          , width: 70},
                            {dataIndex: 'OVERTIME_1_M'          , width: 70, hidden: true}
                        ]
                    },
                    {text : '추가연장',
                        columns : [ 
                            {dataIndex: 'OVERTIME_2_H'          , width: 70},
                            {dataIndex: 'OVERTIME_2_M'          , width: 70, hidden: true}
                        ]
                    },
                    {text : '야근',
                        columns : [ 
                            {dataIndex: 'OVERTIME_3_H'          , width: 70},
                            {dataIndex: 'OVERTIME_3_M'          , width: 70, hidden: true}
                        ]
                    },
                    {text : '지각',
                        columns : [ 
                            {dataIndex: 'LATENESS_H'            , width: 70},              
                            {dataIndex: 'LATENESS_M'            , width: 70}
                        ]
                    },
                    {text : '조퇴',
                        columns : [ 
                            {dataIndex: 'EARLY_H'               , width: 70},              
                            {dataIndex: 'EARLY_M'               , width: 70}
                        ]
                    },
                    {text : '외출',
                        columns : [ 
                            {dataIndex: 'OUT_H'                 , width: 70},              
                            {dataIndex: 'OUT_M'                 , width: 70}
                        ]
                    },
					{dataIndex: 'HOLY_TYPE'				, width: 80, hidden: true},
					{dataIndex: 'HOLY_NAME'				, width: 80, hidden: true},
					{dataIndex: 'CAL_DATE'				, width: 80, hidden: true},
					{dataIndex: 'CAL_NO'				, width: 80, hidden: true},
					{dataIndex: 'DIV_CODE'				, width: 120, hidden: true},
					{dataIndex: 'REMARK'				, width: 120, hidden: true}
          ],
        listeners: {
          	beforeedit: function( editor, e, eOpts ) {	
//          		if(UniUtils.indexOf(e.field, ['DUTY_DATE'])) {
//					if(e.record.phantom == true) {
//	        			return true;
//	        		}else{
//	        			return false;
//	        		}
//				}
          		if(!e.record.phantom == true) { //신규가 아닐 경우
                    if (UniUtils.indexOf(e.field, ['PERSON_NUMB', 'NAME']))
                        return false;
                }
          		if(!e.record.phantom == true || e.record.phantom == true) {     // 신규이던 아니던
                    if(UniUtils.indexOf(e.field, ['DUTY_DATE', 'DAY_NAME', 'DEPT_NAME', 'WORK_TEAM_NAME'])) {
                        return false;
                    }
          		}
                
//              if(UniUtils.indexOf(e.field, ['DUTY_DATE', 'DAY_NAME', 'DEPT_NAME', 'WORK_TEAM_NAME'])) {
//                  return false;
//              }
//              else {
//                  return true;
//              }
	        }
         } 
    }); //End of var masterGrid = Unilite.createGrid('hat501ukrGrid1', {   

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
		id: 'hat501ukrApp',
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
			
            
            //일괄확정버튼 비ㅎ
//            UniAppManager.app.setHiddenBtn();
//            masterGrid.tbar.id('commitBtn').setHidden(true);
//            Ext.getCmp('cancelBtn').setHidden(true);

            
			
			activeSForm.onLoadSelectText('DUTY_DATE');
		},
		
//		setHiddenBtn:function(){
//		      Ext.getCmp('cancelBtn').setHidden(true);
//		      Ext.getCmp('commitBtn').setHidden(true);
//		},
		
		
		
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			panelResult.setValue('FILE_ID', '');              //초기값 세팅
            panelResult.setValue('CSV_LOAD_YN', 'N');         //초기값 세팅
			//masterGrid.getStore().loadStoreRecords();
            directMasterStore1.setProxy(directProxy1);
			directMasterStore1.loadStoreRecords(); 
			UniAppManager.setToolbarButtons('reset', true); 
			
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
//            UniAppManager.setToolbarButtons('reset', true); 
            
//          alert('storeCNT : ' + directMasterStore1.getCount());
//            if(directMasterStore1.getCount() > 0){
//                
//                panelSearch.getForm().getFields().each(function(field) {
//                        field.setReadOnly(false);
//                });
//                panelResult.getForm().getFields().each(function(field) {
//                        field.setReadOnly(false);
//                });
//                
//            }
            
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
//			if (masterGrid.getStore().isDirty()) {
//				// 입력데이터 validation
//				if (!checkValidaionGrid(masterGrid.getStore())) {
//					return false;
//				}	
//				masterGrid.getStore().saveStore();
////				masterGrid.getStore().sync({						
////					success: function(response) {
////						UniAppManager.setToolbarButtons('save', false); 
////		            },
////		            failure: function(response) {
////		            	UniAppManager.setToolbarButtons('save', true); 
////		            }
////				});
//			}
		},
		onDeleteDataButtonDown : function()	{
			masterGrid.deleteSelectedRow();	
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

                excelConfigName : 'hat501ukr',
                listeners : {
                    beforehide: function(me, eOpt) {
                    },
                    beforeclose: function( me, eOpts ) {
                    },
                    hide: function ( me, eOpts ) {
                    	if(me.fileIds != null && me.fileIds.length > 0) {
                    		console.log("me.fileIds.length :: " + me.fileIds.length);
                    		console.log("me.fileIds :: " + me.fileIds[0]);

                    		panelResult.getEl().mask('저장중...','loading-indicator');    // mask on
                    		
                    		panelSearch.setValue('FILE_ID', me.fileIds[0]);               // 추가 파일 담기
                    		panelSearch.setValue('CSV_LOAD_YN', 'Y');                     // 초기값 세팅
                    		panelSearch.setValue('PGM_ID', 'hat501ukr');                  // 초기값 세팅
                    		
                    		directMasterStore1.loadStoreRecords();                               // text 파일 읽고, 조회하기
                    		
                            panelResult.getEl().unmask();                                 // mask off
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
