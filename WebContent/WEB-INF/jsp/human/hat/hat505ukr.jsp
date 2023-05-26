<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat505ukr"  >
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
	Unilite.defineModel('hat505ukrModel', {
		fields: [
			{name: 'DUTY_DATE'			, text: '근무일'			, type: 'uniDate', allowBlank: false},
			{name: 'WEEK_DAY'    		, text: '요일코드'			, type: 'int', maxLength: 2},
			{name: 'DAY_NAME'    		, text: '요일'			, type: 'string'},
			{name: 'DEPT_CODE'    		, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'    		, text: '부서명'			, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string', allowBlank: false, maxLength: 20},
			{name: 'NAME'		   		, text: '성명'			, type: 'string', maxLength: 10},
			{name: 'WORK_TEAM'    		, text: '근무조'			, type: 'string', comboType:'AU', comboCode:'H004'},
//			{name: 'WORK_TEAM_NAME'    	, text: '근무조명'			, type: 'string'},
			{name: 'DUTY_CODE'			, text: '근태구분'			, type: 'string', comboType:'AU', comboCode:'H033', maxLength: 20},
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
			{name: 'OUT_H'    			, text: '시'			    , type: 'uniNumber', maxLength: 2},			
			{name: 'OUT_M'				, text: '분'			    , type: 'uniNumber', maxLength: 2},
			{name: 'HOLY_TYPE'    		, text: '근무조코드'		, type: 'string'},
			{name: 'HOLY_NAME'    		, text: '근무조명'			, type: 'string'},
			{name: 'CAL_DATE'    		, text: '달력'			, type: 'uniDate'},
			{name: 'CAL_NO'    			, text: '주'				, type: 'int', maxLength: 2},		
			{name: 'DIV_CODE'     		, text: '사업장'			, type: 'string', comboType:'BOR120'},
			{name: 'REMARK'       		, text: '비고'			, type: 'string', maxLength: 150}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
//	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
//		api: {
//			create: 'hat505ukrService.insertList',				
//			read: 'hat505ukrService.selectList',
//			update: 'hat505ukrService.updateList',
//			destroy: 'hat505ukrService.deleteList',
//			syncAll: 'hat505ukrService.saveAll'
//		}
//	});	
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'hat505ukrService.insertList',				
			read: 'hat505ukrService.selectList',
			update: 'hat505ukrService.updateList',
			destroy: 'hat505ukrService.deleteList',
			syncAll: 'hat505ukrService.saveAll'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hat505ukrService.select'
		}
	});
	
//	var directMasterStore = Unilite.createStore('hat505ukrMasterStore', {
//		model: 'hat505ukrModel',
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
////                    read    : 'hat505ukrService.select'
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
	

	
	var directMasterStore1 = Unilite.createStore('hat505ukrMasterStore', {
		model: 'hat505ukrModel',
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
                read    : 'hat505ukrService.select'
            }
        },
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
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
			load: function() {
				if (this.getCount() > 0) {
//	              	UniAppManager.setToolbarButtons('delete', true);
                    var dytyDate = directMasterStore1.getAt(0).get('DUTY_DATE');
                    panelSearch.setValue('DUTY_DATE', dytyDate);
                    panelResult.setValue('DUTY_DATE', dytyDate);
           
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
			}
//			,{
//			    fieldLabel: ' ',
//			    xtype: 'uniCheckboxgroup', 
//			    items: [{
//			    	boxLabel: '이상근태만조회',
//			        name: 'DUTY_CHK_YN',
//			        width: 300,
//			        listeners: {
//						change: function(field, newValue, oldValue, eOpts) {						
//							panelResult.setValue('DUTY_CHK_YN', newValue);
//						}
//					}
//				}]
//   			}
   			
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
			}
//			,{
//			    fieldLabel: ' ',
//			    xtype: 'uniCheckboxgroup', 
//			    items: [{
//			    	boxLabel: '이상근태만조회',
//			        name: 'DUTY_CHK_YN',
//			        width: 300,
//			        listeners: {
//						change: function(field, newValue, oldValue, eOpts) {						
//							panelSearch.setValue('DUTY_CHK_YN', newValue);
//						}
//					}
//				}]
//   			}
   			]	
    });
    
//    var dutyCodeStore = Unilite.createStore('hat505ukrDutyCodeStore',{
//        proxy: {
//           type: 'direct',
//            api: {			
//                read: 'hat505ukrService.getComboList'                	
//            }
//        },
//        loadStoreRecords: function() {
//			var param= Ext.getCmp('searchForm').getValues();			
//			console.log( param );
//			this.load({
//				params : param/*,
//				callback : function(records,options,success)	{
//					var loadDataStore = comboStore;
//					if(success)	{
//						if(loadDataStore){
//							loadDataStore.loadData(records.items);
//						}
//					}
//				}*/
//			});
//		}/*,
//		gridRoadStoreRecords: function(param, comboStore) {
//			this.load({
//				params : param,
//				callback : function(records,options,success)	{
//					var loadDataStore = comboStore;
//					if(success)	{
//						if(loadDataStore){
//							loadDataStore.loadData(records.items);
//						}
//					}
//				}
//			});
//		}*/
//	});

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    //에러
    var masterGrid = Unilite.createGrid('hat505ukrGrid', {
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
        	text:'근태파일 업로드',
        	handler:function()	{
        		directMasterStore1.setProxy(directProxy2);
        		openExcelWindow();
        		}
		}
		,{
            xtype:'button',
            text:'데이터 일괄생성',
            handler:function()  {
                if (panelSearch.isValid()) {
                        if(confirm('실행 하시겠습니까?')){
                            runProc();
                        }               
                    }
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
//	 								fn: function(records, type) {
//	 									UniAppManager.app.fnHumanPopUpAu02(records);	
//	 									
//	 	
//	 									var grdRecord = masterGrid.getSelectedRecord();
//										if(!Ext.isEmpty(grdRecord)){
//											fnAmtCal(grdRecord);
//											fnInSur(grdRecord,"");	
//										}
//	 								},
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
											
//												Ext.Ajax.request({
//													url     : CPATH+'/human/getWorkTeam.do',
//													params: {
//										   				S_COMP_CODE: UserInfo.compCode, 
//														DUTY_DATE: dateChange(panelSearch.getValue('DUTY_DATE')),
//														PERSON_NUMB: records[0].PERSON_NUMB
//													},
//													method: 'get',
//													success: function(response){
//														if (response.responseText.indexOf('fail') == -1) {
//															var data = JSON.parse(Ext.decode(response.responseText));
//															console.log(data);
//															if (data != null) {
//																grdRecord.set('WORK_TEAM', data);
//															}		
//														}
//													},
//													failure: function(response){ alert('fail');
//														console.log(response);
//														grdRecord.set('WORK_TEAM', '');
//													}
//												});	
											
										},			  						
	 								scope: this
	 							},
	 							'onClear': function(type) {
	 								var grdRecord = Ext.getCmp('hat505ukrGrid').uniOpt.currentRecord;
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
//                                  fn: function(records, type) {
//                                      UniAppManager.app.fnHumanPopUpAu02(records);    
//                                      
//      
//                                      var grdRecord = masterGrid.getSelectedRecord();
//                                      if(!Ext.isEmpty(grdRecord)){
//                                          fnAmtCal(grdRecord);
//                                          fnInSur(grdRecord,"");  
//                                      }
//                                  },
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
                                            
//                                              Ext.Ajax.request({
//                                                  url     : CPATH+'/human/getWorkTeam.do',
//                                                  params: {
//                                                      S_COMP_CODE: UserInfo.compCode, 
//                                                      DUTY_DATE: dateChange(panelSearch.getValue('DUTY_DATE')),
//                                                      PERSON_NUMB: records[0].PERSON_NUMB
//                                                  },
//                                                  method: 'get',
//                                                  success: function(response){
//                                                      if (response.responseText.indexOf('fail') == -1) {
//                                                          var data = JSON.parse(Ext.decode(response.responseText));
//                                                          console.log(data);
//                                                          if (data != null) {
//                                                              grdRecord.set('WORK_TEAM', data);
//                                                          }       
//                                                      }
//                                                  },
//                                                  failure: function(response){ alert('fail');
//                                                      console.log(response);
//                                                      grdRecord.set('WORK_TEAM', '');
//                                                  }
//                                              }); 
                                            
                                        },                                  
                                    scope: this
                                },
	 							'onClear': function(type) {
	 								var grdRecord = Ext.getCmp('hat505ukrGrid').uniOpt.currentRecord;
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
//					{dataIndex: 'WORK_TEAM_NAME'		, width: 133},
					{dataIndex: 'DUTY_CODE'				, width: 110}, 
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
                            {dataIndex: 'OVERTIME_1_M'          , width: 70} //, hidden: true}
                        ]
                    },
                    {text : '추가연장',
                        columns : [ 
                            {dataIndex: 'OVERTIME_2_H'          , width: 70},
                            {dataIndex: 'OVERTIME_2_M'          , width: 70} //, hidden: true}
                        ]
                    },
                    {text : '야근',
                        columns : [ 
                            {dataIndex: 'OVERTIME_3_H'          , width: 70},
                            {dataIndex: 'OVERTIME_3_M'          , width: 70} //, hidden: true}
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
//          ,
          
//		   setExcelData: function(record) {
//       		
//			   var me = this;
//	   			var grdRecord = this.getSelectionModel().getSelection()[0];
//				grdRecord.set('DEPT_NAME'			, record['DEPT_NAME']);
//				grdRecord.set('PERSON_NUMB'			, record['PERSON_NUMB']);
//	   			grdRecord.set('NAME'				, record['NAME']);
//				grdRecord.set('REPRE_NUM'			, record['REPRE_NUM']);
//	   			grdRecord.set('JOIN_DATE'			, record['JOIN_DATE']);
//	   			
//	   			grdRecord.set('RETR_DATE'			, record['RETR_DATE']);
//				grdRecord.set('PAY_YYYYMM'			, record['PAY_YYYYMM']);
//	   			grdRecord.set('SUPP_DATE'			, record['SUPP_DATE']);
//				grdRecord.set('WORK_DAY'			, record['WORK_DAY']);
//	   			grdRecord.set('SUPP_TOTAL_I'		, record['SUPP_TOTAL_I']);
//	   			
//	   			grdRecord.set('REAL_AMOUNT_I'		, record['REAL_AMOUNT_I']);
//	   			grdRecord.set('TAX_EXEMPTION_I'		, record['TAX_EXEMPTION_I']);
//	   			grdRecord.set('IN_TAX_I'			, record['IN_TAX_I']);
//	   			grdRecord.set('LOCAL_TAX_I'			, record['LOCAL_TAX_I']);
//				grdRecord.set('ANU_INSUR_I'			, record['ANU_INSUR_I']);
//	   			grdRecord.set('MED_INSUR_I'			, record['MED_INSUR_I']);
//	   			
//	   			grdRecord.set('HIR_INSUR_I'			, record['HIR_INSUR_I']);
//				grdRecord.set('BUSI_SHARE_I'		, record['BUSI_SHARE_I']);
//	   			grdRecord.set('WORKER_COMPEN_I'		, record['WORKER_COMPEN_I']);
//			
//			}
//    	,
        listeners: {
//        	edit: function(editor, e) {
//          		var fieldName = e.field;
//				var num_check = /[0-9]/;
//				var date_check01 = /^(19|20)\d{2}.(0[1-9]|1[012])$/;
//				var date_check02 = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
//				switch (fieldName) {
//				case 'PERSON_NUMB':	
//				case 'NAME':		
//					fnAmtCal(e.record);
//					fnInSur(e.record,"");	
//					break;
//				case 'SUPP_TOTAL_I':
//				case 'WORK_DAY':
//				
//					if (!num_check.test(e.value)) {
//						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
//						e.record.set(fieldName, e.originalValue);
//						return false;
//					}
//					fnAmtCal(e.record);
//					fnInSur(e.record,"");
//					break;
//				case 'TAX_EXEMPTION_I':
//					if (!num_check.test(e.value)) {
//						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
//						e.record.set(fieldName, e.originalValue);
//						return false;
//					}
//					fnAmtCal(e.record);
//					fnInSur(e.record,"");
//					break;
//				case 'IN_TAX_I':
//					if (!num_check.test(e.value)) {
//						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
//						e.record.set(fieldName, e.originalValue);
//						return false;
//					}
//					LOCAL_TAX_I = e.record.data.IN_TAX_I * 0.1;
//					e.record.set("LOCAL_TAX_I",LOCAL_TAX_I);			
//					fnTaxI(e.record);
//					break;
//				case 'LOCAL_TAX_I':
//				case 'ANU_INSUR_I':
//				case 'MED_INSUR_I':
//				case 'HIR_INSUR_I':
//					if (!num_check.test(e.value)) {
//						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
//						e.record.set(fieldName, e.originalValue);
//						return false;
//					}
//					fnTaxI(e.record);
//					break;
//				case 'BUSI_SHARE_I':
//				case 'WORKER_COMPEN_I':
//					if (!num_check.test(e.value)) {
//						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
//						e.record.set(fieldName, e.originalValue);
//						return false;
//					}
//					break;
//					
//				/*case 'PAY_YYYYMM':
//					if (e.record.data.PAY_YYYYMM != null && e.record.data.PAY_YYYYMM != '' ) {
//						if (!date_check01.test(e.value)) {
//							Ext.Msg.alert('확인', '날짜형식이 잘못되었습니다.');
//							e.record.set(fieldName, e.originalValue);
//							return false;
//						} else {
//							e.record.set('SUPP_DATE', e.record.data.PAY_YYYYMM + '.01');
//							e.record.set('RECE_DATE', e.record.data.PAY_YYYYMM + '.01');
//						}
//					}
//					break;*/	
//					
//				default:
//					break;
//				}
//          	},
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
                    if(UniUtils.indexOf(e.field, ['DUTY_DATE', 'DAY_NAME', 'DEPT_NAME', 'WORK_TEAM', 'DUTY_CHK1_YN'])) {
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
    }); //End of var masterGrid = Unilite.createGrid('hat505ukrGrid1', {   

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
		id: 'hat505ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
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
			activeSForm.onLoadSelectText('DUTY_DATE');
		},		
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
//			UniAppManager.setToolbarButtons('reset', true);
//			var detailform = panelSearch.getForm();
//			if (detailform.isValid()) {
//				masterGrid.getStore().loadStoreRecords();
//				panelSearch.getForm().getFields().each(function(field) {
//				      field.setReadOnly(true);
//				});
//				panelResult.getForm().getFields().each(function(field) {
//				      field.setReadOnly(true);
//				});
//				UniAppManager.setToolbarButtons('reset', true);
//			} else {
//				var invalid = panelSearch.getForm().getFields()
//						.filterBy(function(field) {
//							return !field.validate();
//						});
//
//				if (invalid.length > 0) {
//					r = false;
//					var labelText = ''
//
//					if (Ext
//							.isDefined(invalid.items[0]['fieldLabel'])) {
//						var labelText = invalid.items[0]['fieldLabel']
//								+ '은(는)';
//					} else if (Ext
//							.isDefined(invalid.items[0].ownerCt)) {
//						var labelText = invalid.items[0].ownerCt['fieldLabel']
//								+ '은(는)';
//					}
//
//					Ext.Msg.alert('확인', labelText + Msg.sMB083);
//					invalid.items[0].focus();
//				}
//			}
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
//			if(!this.checkForNewDetail()) return false;
				/**
				 * Master Grid Default 값 설정
				 */

//            var divCode = panelresult.getValue('DIV_CODE');
//            var compCode = UserInfo.compCode; 
//            var dutyDate = panelresult.getValue('DUTY_DATE');
// 			
//            var r = {
//				
//				DIV_CODE: divCode,
//				DUTY_DATE : dutyDate,
//				COMP_CODE: compCode
//		    };
//		    
//		    masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);
//			UniAppManager.setToolbarButtons('reset', true);
//			
//			
//			var selectNode = masterGrid.getSelectionModel().getLastSelected();			
//	        var newRecord = masterGrid.createRow( );
//	        
//	        if(newRecord)	{
//				newRecord.set('DIV_CODE',selectNode.get('DIV_CODE'));
//				newRecord.set('COMP_CODE',selectNode.get('COMP_CODE'));
//				newRecord.set('DUTY_DATE',selectNode.get('DUTY_DATE'));
//	        	
//	        }
			
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
//		onDeleteDataButtonDown : function()	{
//			var selRow = masterGrid.getSelectionModel().getSelection()[0];
//			if (selRow.phantom === true)	{
//				masterGrid.deleteSelectedRow();
//			} else {
//				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
//					if (btn == 'yes') {
//						masterGrid.deleteSelectedRow();		
//						UniAppManager.setToolbarButtons('save', true);
//					}
//				});
//			}
//		},
//		onDeleteAllButtonDown : function() {
//			Ext.Msg.confirm('삭제', '전체 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
//				if (btn == 'yes') {
//					masterGrid.reset();			
//					UniAppManager.app.onSaveDataButtonDown();
////					Ext.getCmp('hat420ukrGrid1').getStore().removeAll();
////					Ext.getCmp('hat420ukrGrid1').getStore().sync({
////						success: function(response) {
////							Ext.Msg.alert('확인', '삭제 되었습니다.');
////							UniAppManager.setToolbarButtons('delete', false);
////							UniAppManager.setToolbarButtons('deleteAll', false);
////							UniAppManager.setToolbarButtons('excel', false);
////				           },
////				           failure: function(response) {
////				           }
////			           });
//					
//				}
//			});
//		}
	});//End of Unilite.Main( {
		
//	// 엑셀참조
//	Unilite.Excel.defineModel('excel.s_hat500_kd.sheet01', {
//		fields: [
//			{name: 'DUTY_DATE'		, text: '근무일'			, type: 'uniDate', allowBlank: false},
//			{name: 'CAL_DATE'    		, text: '달력'				, type: 'uniDate'},
//			{name: 'DUTY_CHK_YN'    	, text: '확정'				, type: 'string', defaultValue: 'N', hidden: true},
//			{name: 'CAL_NO'    			, text: '주'				, type: 'int', maxLength: 2, hidden: true},
//			{name: 'WEEK_DAY'    		, text: '요일코드'			, type: 'int', maxLength: 2, hidden: true},
//			{name: 'DAY_NAME'    		, text: '요일'				, type: 'string'},
//			{name: 'HOLY_TYPE'    		, text: '근무조코드'		, type: 'string'},
//			{name: 'HOLY_NAME'    		, text: '근무조명'			, type: 'string'},			
//			{name: 'DEPT_CODE'    		, text: '부서코드'			, type: 'string'},
//			{name: 'POST_CODE'    		, text: '직위코드'			, type: 'string'},
//			{name: 'POST_NAME'    		, text: '직위명'			, type: 'string'},			
//			{name: 'DEPT_NAME'    		, text: '부서명'			, type: 'string'},
//			{name: 'PERSON_NUMB'		, text: '사번'				, type: 'string', allowBlank: false, maxLength: 20},
//			{name: 'NAME'		   		, text: '성명'				, type: 'string', maxLength: 10},
//			{name: 'WORK_TEAM'    		, text: '근무조'			, type: 'string', comboType:'AU', comboCode:'H004', allowBlank: false},
//			{name: 'WORK_TEAM_NAME'    	, text: '근무조명'			, type: 'string'},
//			{name: 'DUTY_CODE'			, text: '근태구분'			, type: 'string', comboType:'AU', comboCode:'H033', allowBlank: false, maxLength: 20},
//			{name: 'DUTY_FR_DHM'			, text: '출근일자시'			, type: 'string'},
//			{name: 'DUTY_FR_D'			, text: '출근일자'			, type: 'uniDate'},			
//			{name: 'DUTY_FR_H'			, text: '출근시'			, type: 'int', maxLength: 2},
//			{name: 'DUTY_FR_M'			, text: '출근분'			, type: 'int', maxLength: 2},
//			{name: 'DUTY_TO_DHM'			, text: '퇴근일자시'			, type: 'string'},
//			{name: 'DUTY_TO_D'			, text: '퇴근일자'			, type: 'uniDate'},			
//			{name: 'DUTY_TO_H'    		, text: '퇴근시'			, type: 'int', maxLength: 2},
//			{name: 'DUTY_TO_M'    		, text: '퇴근분'			, type: 'int', maxLength: 2},
//			{name: 'OVERTIME_1_H'		, text: '연장시'			, type: 'int', maxLength: 2},
//			{name: 'OVERTIME_1_M'		, text: '연장분'			, type: 'int', maxLength: 2},
//			{name: 'OVERTIME_2_H'		, text: '추가연장시'		, type: 'int', maxLength: 2},
//			{name: 'OVERTIME_2_M'		, text: '추가연장분'		, type: 'int', maxLength: 2},	
//			{name: 'LATENESS_H'    		, text: '지각시'			, type: 'int', maxLength: 2},			
//			{name: 'LATENESS_M'			, text: '지각분'			, type: 'int', maxLength: 2},
//			{name: 'EARLY_H'    		, text: '조퇴시'			, type: 'int', maxLength: 2},			
//			{name: 'EARLY_M'			, text: '조퇴분'			, type: 'int', maxLength: 2},
//			{name: 'OUT_H'    			, text: '외출시'			, type: 'int', maxLength: 2},			
//			{name: 'OUT_M'				, text: '외출분'			, type: 'int', maxLength: 2},			
//			{name: 'DIV_CODE'     		, text: '사업장'			, type: 'string', comboType:'BOR120', hidden: true},
//			{name: 'REMARK'       		, text: '비고'				, type: 'string', maxLength: 150, hidden: true}
//		]
//	});	
//	
		function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.TXTUpload';

        if (!excelWindow) {
            excelWindow = Ext.create(appName, {
                modal : false,

                excelConfigName : 'hat505ukr',
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
                    		panelSearch.setValue('PGM_ID', 'hat505ukr');                  // 초기값 세팅

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
	
	//데이터 일괄생성
    function runProc() {     
        Ext.getCmp('pageAll').getEl().mask('생성중...');    // mask on
        var param= Ext.getCmp('searchForm').getValues();
        param.RE_TRY = "";

        /*panelSearch.getEl().mask('급여계산 중...','loading-indicator');*/
        hat505ukrService.procSP(param, function(provider, response)  {
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

        hat505ukrService.procSP(param, function(provider, response)  {
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
	
//	// insert, update 전 입력값  검증(시작/종료 시간)
//	 function checkValidaionGrid() {
//		 // 시작시간/종료시간 검증
//		 var rightTimeInputed = true;
//		 // 필수 입력항목 입력 여부 검증
//		 var necessaryFieldInputed = true;
//		 var MsgTitle = '확인';
//		 var MsgErr01 = '시작시간이 종료 시간 보다 클 수 없습니다.';
//		 var MsgErr02 = '은(는) 필수 입력 항목 입니다.';
//
//		 var selectedModel = masterGrid.getStore().getRange();
//		 Ext.each(selectedModel, function(record,i){
//			 
////		 	var date_fr = parseInt(dateChange(record.data.DUTY_FR_D));
////		 	var date_to = parseInt(dateChange(record.data.DUTY_TO_D));
//		 	var date_fr = parseInt(record.data.DUTY_FR_D);
//		 	var date_to = parseInt(record.data.DUTY_TO_D);		 	
//		 	var fr_time = parseInt(record.data.DUTY_FR_H + record.data.DUTY_FR_M);
//			var to_time = parseInt(record.data.DUTY_TO_H + record.data.DUTY_TO_M);
//		 
//			 if ( (date_fr != '' && date_to == '') || (date_fr == '' && date_to != '') ) {
//				 rightTimeInputed = false;
//				 return;
//			 } else if (date_fr != '' && date_to != '') {
//				 if ((date_fr > date_to)) {
//					 rightTimeInputed = false;
//					 return;
//				 } else {
//					if (date_fr == date_to && fr_time >= to_time) {
//						rightTimeInputed = false;
//						return;
//					}
//				 }
//			 }
//			 
////			 if (record.data.WORK_TEAM == '') {
////				 MsgErr02 = '근무조' + MsgErr02;
////				 necessaryFieldInputed = false;
////				 return;
////			 } else if (record.data.DIV_CODE == '') {
////				 MsgErr02 = '사업장' + MsgErr02;
////				 necessaryFieldInputed = false;
////				 return;
////			 } else if (record.data.DEPT_NAME == '') {
////				 MsgErr02 = '부서' + MsgErr02;
////				 necessaryFieldInputed = false;
////				 return;
////			 } else if (record.data.POST_CODE == '') {
////				 MsgErr02 = '직위' + MsgErr02;
////				 necessaryFieldInputed = false;
////				 return;
////			 } else if (record.data.NAME == '') {
////				 MsgErr02 = '성명' + MsgErr02;
////				 necessaryFieldInputed = false;
////				 return;
////			 } else if (record.data.PERSON_NUMB == '') {
////				 MsgErr02 = '사번' + MsgErr02;
////				 necessaryFieldInputed = false;
////				 return;
////			 } else if (record.data.DUTY_CODE == '') {
////				 MsgErr02 = '근태구분' + MsgErr02;
////				 necessaryFieldInputed = false;
////				 return;
////			 }
//			 
//		 });
//		 if (!rightTimeInputed) {
//			 Ext.Msg.alert(MsgTitle, MsgErr01);
//			 return rightTimeInputed;
//		 }
//		 if (!necessaryFieldInputed) {
//			 Ext.Msg.alert(MsgTitle, MsgErr02);
//			 return necessaryFieldInputed;
//		 }
//		 return true;
//	 }
 	
	
//	// 모델 필드 생성
//	function createModelField(colData) {
//		var fields = [
//		              	{name: 'PAY_CODE'			, text: '급여지급방식', type: 'string'},
//						{name: 'WORK_TEAM'			, text: '근무조'	, type: 'string', comboType: 'AU', comboCode: 'H004'},
//						{name: 'DIV_CODE'			, text: '사업장'	, type: 'string', comboType: 'BOR120'},
//						{name: 'FLAG'				, text: 'flag'	, type: 'string'},
//						{name: 'DUTY_DATE'		, text: '근태년월'	, type: 'uniDate'},
//						{name: 'DEPT_NAME'			, text: '부서'	, type: 'string'},
//						{name: 'POST_CODE'			, text: '직위'	, type: 'string', comboType: 'AU', comboCode: 'H005'},
//						{name: 'NAME'				, text: '성명'	, type: 'string'},
//						{name: 'PERSON_NUMB'		, text: '사번'	, type: 'string'}
//					 ];
//		
//		if (dutyRule == 'Y') {
//			fields.push({name: 'DUTY_CODE'		, text: '근태구분'	, type: 'string'});
//			fields.push({name: 'DUTY_FR_D'		, text: '일자'	, type: 'uniDate'});
//			fields.push({name: 'DUTY_FR_H'		, text: '시'		, type: 'string', maxLength: 2});
//			fields.push({name: 'DUTY_FR_M'		, text: '분'		, type: 'string', maxLength: 2});
//			fields.push({name: 'DUTY_TO_D'		, text: '일자'	, type: 'uniDate'});
//			fields.push({name: 'DUTY_TO_H'		, text: '시'		, type: 'string', maxLength: 2});
//			fields.push({name: 'DUTY_TO_M'		, text: '분'		, type: 'string', maxLength: 2});
//		} else {
//			fields.push({name: 'NUMF'			, text: 'NUMF'	, type: 'string'});
//			fields.push({name: 'NUMC1'			, text: 'NUMC1'	, type: 'string'});
//			fields.push({name: 'NUMC'			, text: '근태구분'	, type: 'string'});
//			fields.push({name: 'NUMN'			, text: 'NUMN'	, type: 'string'});
//			fields.push({name: 'NUMT'			, text: 'NUMT'	, type: 'string'});
//			fields.push({name: 'NUMM'			, text: 'NUMM'	, type: 'string'});
//			Ext.each(colData, function(item, index){
//				fields.push({name: 'TIMEF' + item.SUB_CODE, text: 'TIMEF'	, type: 'string'});
//				fields.push({name: 'TIMEC' + item.SUB_CODE, text: 'TIMEC'	, type: 'string'});
//				fields.push({name: 'TIMEN' + item.SUB_CODE, text: 'TIMEN'	, type: 'string'});
//				fields.push({name: 'TIMET' + item.SUB_CODE, text: '시'		, type: 'string'});
//				fields.push({name: 'TIMEM' + item.SUB_CODE, text: '분'		, type: 'string'});
//			});
//		}		
//		console.log(fields);
//		return fields;
//	}
//	
//	// 그리드 컬럼 생성
//	function createGridColumn(colData) {
//		var columns = [ {
//						xtype: 'rownumberer', 
//						sortable:false, 
//						//locked: true, 
//						width: 35,
//						align:'center  !important',
//						resizable: true
//					},
//						{dataIndex: 'PAY_CODE'			, text: '급여지급방식',   hidden: true},
//						{dataIndex: 'WORK_TEAM'			, width: 96,   text: '근무조', style: 'text-align: center',
//				            renderer: function (value) {
//				            	var record = Ext.getStore('CBS_AU_H004').findRecord('value', value);
//								if (record == null || record == undefined ) {
//									return '';
//								} else {
//									return record.data.text
//								}
//				            }				
//						},
//						{dataIndex: 'DIV_CODE'			, width: 160,  text: '사업장', style: 'text-align: center', comboType: 'BOR120',
//				            renderer: function (value) {
//				            	var record = Ext.getStore('CBS_BOR120_').findRecord('value', value);
//								if (record == null || record == undefined ) {
//									return '';
//								} else {
//									return record.data.text
//								}
//				            }						
//						},
//						{dataIndex: 'FLAG'				, width: 96,  hidden: true,   text: 'flag'},
//						{dataIndex: 'DUTY_DATE'		, width: 96,  hidden: true,   text: '근태년월'},
//						{dataIndex: 'DEPT_NAME'			, width: 150,   text: '부서', style: 'text-align: center'},
//						{dataIndex: 'POST_CODE'			, width: 96,   text: '직위', style: 'text-align: center', comboType: 'AU',
//				            renderer: function (value) {
//				            	var record = Ext.getStore('CBS_AU_H005').findRecord('value', value);
//								if (record == null || record == undefined ) {
//									return '';
//								} else {
//									return record.data.text
//								}
//				            }						
//						},
//						{dataIndex: 'NAME'				, width: 96,   text: '성명', style: 'text-align: center'},
//						{dataIndex: 'PERSON_NUMB'		, width: 96,   text: '사번', style: 'text-align: center'}
//					  ];
//		if (dutyRule == 'Y') {
//			columns.push({dataIndex: 'DUTY_CODE'		, width: 96, text: '근태구분', style: 'text-align: center', editor:
//	            {
//	                xtype: 'uniCombobox',
//	                store: cbStore,
//	                lazyRender: true,
//	                displayField : 'CODE_NAME',
//	                valueField : 'SUB_CODE',
//	                hiddenName: 'SUB_CODE',
//	                hiddenValue: 'SUB_CODE'
//	            },
//	            renderer: function (value) {
//	            	var record = Ext.getStore('hat510ukrsComboStoreGrid').findRecord('SUB_CODE', value);
//					if (record == null || record == undefined ) {
//						return '';
//					} else {
//						return record.data.CODE_NAME
//					}
//            }});
//			columns.push({text: '출근시간',
//					columns:[{dataIndex: 'DUTY_FR_D'		, width: 96, text: '일자', style: 'text-align: center', align: 'center', xtype:'uniDateColumn', editor: {xtype: 'uniDatefield'}},
//							 {dataIndex: 'DUTY_FR_H'		, width: 96, text: '시', style: 'text-align: center', align: 'right', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}},
//							 {dataIndex: 'DUTY_FR_M'		, width: 96, text: '분', style: 'text-align: center', align: 'right', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}}
//					]});
//			columns.push({text: '퇴근시간',
//					columns:[{dataIndex: 'DUTY_TO_D'		, width: 96, text: '일자', style: 'text-align: center', align: 'center', xtype:'uniDateColumn', editor: {xtype: 'uniDatefield'}},
//							 {dataIndex: 'DUTY_TO_H'		, width: 96, text: '시', style: 'text-align: center', align: 'right', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}},
//							 {dataIndex: 'DUTY_TO_M'		, width: 96, text: '분', style: 'text-align: center', align: 'right', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}}
//					]});
//		} else {
//			columns.push({dataIndex: 'NUMF'				, width: 96		, hidden: true, text: 'NUMF'});
//			columns.push({dataIndex: 'NUMC1'			, width: 96		, hidden: true, text: 'NUMC1'});
//			columns.push({dataIndex: 'NUMC'				, width: 96		, text: '근태구분', style: 'text-align: center', editor:
//	            {
//	                xtype: 'uniCombobox',
//	                store: cbStore,
//	                lazyRender: true,
//	                displayField : 'CODE_NAME',
//	                valueField : 'SUB_CODE',
//	                hiddenName: 'SUB_CODE',
//	                hiddenValue: 'SUB_CODE'
//	            },
//	            renderer: function (value) {
//	            	var record = Ext.getStore('hat510ukrsComboStoreGrid').findRecord('SUB_CODE', value);
//					if (record == null || record == undefined ) {
//						return '';
//					} else {
//						return record.data.CODE_NAME
//					}
//            }});
//			columns.push({dataIndex: 'NUMN'				, width: 96		, hidden: true, text: 'NUMN'});
//			columns.push({dataIndex: 'NUMT'				, width: 96		, hidden: true, text: 'NUMT'});
//			columns.push({dataIndex: 'NUMM'				, width: 96		, hidden: true, text: 'NUMM'});
//			Ext.each(colData, function(item, index){
//				columns.push(
//					{text: item.CODE_NAME,
//						columns:[ 
//							{dataIndex: 'TIMEF' + item.SUB_CODE, width:66, hidden: true, text: 'TIMEF', align: 'right'},
//							{dataIndex: 'TIMEC' + item.SUB_CODE, width:66, hidden: true, text: 'TIMEC', align: 'right'},
//							{dataIndex: 'TIMEN' + item.SUB_CODE, width:66, hidden: true, text: 'TIMEN', align: 'right'},
//							{dataIndex: 'TIMET' + item.SUB_CODE, width:66, text: '시', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}},
//							{dataIndex: 'TIMEM' + item.SUB_CODE, width:66, text: '분', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}}
//						]
//					});
//			});
//		}
//		console.log(columns);
//		return columns;
//	}
//	
//	function createModelStore(pay_value) {
//		Ext.Ajax.request({
//			url     : CPATH+'/human/getDutycode.do',
//			params: { PAY_CODE: pay_value, S_COMP_CODE: UserInfo.compCode, DUTY_RULE: dutyRule },
//			success: function(response){
//				var data = JSON.parse(Ext.decode(response.responseText));
//				var fields = createModelField(data);
//				switch (pay_value) {
//					case '0':
//						store_pay_code0.loadStoreRecords();
//						masterGrid.reconfigure(store_pay_code0, columns0);
//						break;
//					case '1':
//						columns1 = createGridColumn(data);
//						model_pay_code1 = Unilite.defineModel('model_pay_code1', {
//							fields: fields
//						});
//						store_pay_code1 = Unilite.createStore('store_pay_code1', {
//							model: 'model_pay_code1',
//							uniOpt: {
//								isMaster: false,			// 상위 버튼 연결 
//								editable: true,			// 수정 모드 사용 
//								deletable: false,			// 삭제 가능 여부 
//								useNavi: false			// prev | newxt 버튼 사용
//							},
//							autoLoad: false,
//							proxy: directProxy,
//							loadStoreRecords: function(){
//								var param= Ext.getCmp('searchForm').getValues();
//								param.DUTY_RULE = dutyRule;
//								console.log(param);
//								this.load({
//									params: param
//								});
//							},
//							saveStore : function(config)	{				
//								var inValidRecs = this.getInvalidRecords();
//								if(inValidRecs.length == 0 )	{	
//									var config = {
//										
//										success: function(batch, option) {
//											store_pay_code1.loadStoreRecords();
//											UniAppManager.setToolbarButtons('save', false);
//										 } 
//									};
//									store_pay_code1.syncAllDirect(config);	
//								}else {
//									masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
//								}
//							},
//							listeners: {
//								load: function() {
//									if (this.getCount() > 0) {
//						              	UniAppManager.setToolbarButtons('delete', true);
//						              	UniAppManager.setToolbarButtons('deleteAll', true);
//					                } else {
//					              	  	UniAppManager.setToolbarButtons('delete', false);
//					              	  	UniAppManager.setToolbarButtons('deleteAll', false);
//					                }
////					                dutyCodeStore.loadStoreRecords();
//					                masterGrid.getSelectionModel().select(0);
//								}
//							}
//						});
//						store_pay_code1.loadStoreRecords();
//						masterGrid.setColumnInfo(masterGrid, columns1, fields);
//						masterGrid.reconfigure(store_pay_code1, columns1);
//						break;
//					case '2':
//						columns2 = createGridColumn(data);
//						model_pay_code2 = Unilite.defineModel('model_pay_code2', {
//							fields: fields
//						});
//						store_pay_code2 = Unilite.createStore('store_pay_code2', {
//							model: 'model_pay_code2',
//							uniOpt: {
//								isMaster: false,			// 상위 버튼 연결 
//								editable: true,			// 수정 모드 사용 
//								deletable: false,			// 삭제 가능 여부 
//								useNavi: false			// prev | newxt 버튼 사용
//							},
//							autoLoad: false,
//							proxy: directProxy,
//							loadStoreRecords: function(){
//								var param= Ext.getCmp('searchForm').getValues();
//								param.DUTY_RULE = dutyRule;
//								console.log(param);
//								this.load({
//									params: param
//								});
//							},
//							saveStore : function(config)	{				
//								var inValidRecs = this.getInvalidRecords();
//								if(inValidRecs.length == 0 )	{	
//									var config = {
//										
//										success: function(batch, option) {
//											store_pay_code2.loadStoreRecords();
//											UniAppManager.setToolbarButtons('save', false);
//										 } 
//									};
//									store_pay_code2.syncAllDirect(config);	
//								}else {
//									masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
//								}
//							},
//							listeners: {
//								load: function() {
//									if (this.getCount() > 0) {
//						              	UniAppManager.setToolbarButtons('delete', true);
//						              	UniAppManager.setToolbarButtons('deleteAll', true);
//					                } else {
//					              	  	UniAppManager.setToolbarButtons('delete', false);
//					              	  	UniAppManager.setToolbarButtons('deleteAll', false);
//					                }
////					                dutyCodeStore.loadStoreRecords();
//					                masterGrid.getSelectionModel().select(0);
//								}
//							}
//						});
//						store_pay_code2.loadStoreRecords();
//						masterGrid.setColumnInfo(masterGrid, columns2, fields);
//						masterGrid.reconfigure(store_pay_code2, columns2);
//						break;
//					case '3':
//						columns3 = createGridColumn(data);
//						model_pay_code3 = Unilite.defineModel('model_pay_code3', {
//							fields: fields
//						});
//						store_pay_code3 = Unilite.createStore('store_pay_code3', {
//							model: 'model_pay_code3',
//							uniOpt: {
//								isMaster: false,			// 상위 버튼 연결 
//								editable: true,			// 수정 모드 사용 
//								deletable: false,			// 삭제 가능 여부 
//								useNavi: false			// prev | newxt 버튼 사용
//							},
//							autoLoad: false,
//							proxy: directProxy,
//							loadStoreRecords: function(){
//								var param= Ext.getCmp('searchForm').getValues();
//								param.DUTY_RULE = dutyRule;
//								console.log(param);
//								this.load({
//									params: param
//								});
//							},
//							saveStore : function(config)	{				
//								var inValidRecs = this.getInvalidRecords();
//								if(inValidRecs.length == 0 )	{	
//									var config = {
//										
//										success: function(batch, option) {
//											store_pay_code3.loadStoreRecords();
//											UniAppManager.setToolbarButtons('save', false);
//										 } 
//									};
//									store_pay_code3.syncAllDirect(config);	
//								}else {
//									masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
//								}
//							},
//							listeners: {
//								load: function() {
//									if (this.getCount() > 0) {
//						              	UniAppManager.setToolbarButtons('delete', true);
//						              	UniAppManager.setToolbarButtons('deleteAll', true);
//					                } else {
//					              	  	UniAppManager.setToolbarButtons('delete', false);
//					              	  	UniAppManager.setToolbarButtons('deleteAll', false);
//					                }
////					                dutyCodeStore.loadStoreRecords();
//					                masterGrid.getSelectionModel().select(0);
//								}
//							}
//						});
//						store_pay_code3.loadStoreRecords();
//						masterGrid.setColumnInfo(masterGrid, columns3, fields);
//						masterGrid.reconfigure(store_pay_code3, columns3);
//						break;
//				}
//				
//			},
//			failure: function(response){
//				console.log(response);
//			}
//		});
//	}
//	
//	function checkValidaionGrid(store) {
//		 // 시작시간이 종료시간 보다 큰 값이 입력이 됨
//		 var rightTimeInputed = true;
//		 
//		 var MsgTitle = '확인';
//		 var MsgErr01 = '시작시간이 종료 시간 보다 클 수 없습니다.';
//		 
//		 var grid = Ext.getCmp('hat505ukrGrid1');
//		 var selectedModel = grid.getStore().getRange();
//		 Ext.each(selectedModel, function(record,i){
//			 
//			 if ( (record.data.DUTY_FR_D != '' && record.data.DUTY_TO_D == '') ||
//				  (record.data.DUTY_FR_D == '' && record.data.DUTY_TO_D != '') ) {
//				 rightTimeInputed = false;
//				 return;
//			 } else if (record.data.DUTY_FR_D != '' && record.data.DUTY_TO_D != '') {
//				 if ((record.data.DUTY_FR_D > record.data.DUTY_TO_D)) {
//					 rightTimeInputed = false;
//					 return;
//				 } else {
//					var fr_time = parseInt(record.data.DUTY_FR_H + record.data.DUTY_FR_M);
//					var to_time = parseInt(record.data.DUTY_TO_H + record.data.DUTY_TO_M);
//					if (record.data.DUTY_FR_D == record.data.DUTY_TO_D && fr_time > to_time) {
//						rightTimeInputed = false;
//						return;
//					}
//				 }
//			 }
//		 });
//		 
//		 if (!rightTimeInputed) {
//			 Ext.Msg.alert(MsgTitle, MsgErr01);
//		 }else{//일자 필수값 체크..
//		 	if(dutyRule == "Y"){
//			 	var toCreate = store.getNewRecords();
//	        	var toUpdate = store.getUpdatedRecords();
//	        	var list = [].concat(toUpdate,toCreate);            	
//				var isErr = false;
//	        	Ext.each(list, function(record, index) {
//	        		if(Ext.isEmpty(record.get('DUTY_CODE')) && (Ext.isEmpty(record.get('DUTY_FR_D')) || Ext.isEmpty(record.get('DUTY_TO_D')))){
//						alert('일자를 입력해 주세요.');
//						isErr = true;
//						return false;
//					}
//	        	});
//	        	if(isErr) return false;
//		 	}
//		 return rightTimeInputed;
//		 }
//	}
    
	
};


</script>
