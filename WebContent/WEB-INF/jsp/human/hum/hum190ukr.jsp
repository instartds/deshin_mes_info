<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum190ukr"	>
	<t:ExtComboStore comboType="BOR120"	pgmId="hum190ukr"/> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 							<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 							<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 							<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H156" /> 							<!-- 반영여부 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {
	var payGrdWin;						//급호봉 / 지급수당 / 기술수당 팝업
	var gsGradeFlag		= '';			//급호봉 / 지급수당 / 기술수당 flag
	var wageStd			= ${wageStd};	//급호봉 코드 정보
    var dateFlag		= true;
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hum190ukrService.selectList',
			update	: 'hum190ukrService.updateDetail',
			create	: 'hum190ukrService.insertDetail',
			destroy	: 'hum190ukrService.deleteDetail',
			syncAll	: 'hum190ukrService.saveAll'
		}
	});
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'hum190ukrService.runProcedure',
            syncAll	: 'hum190ukrService.callProcedure'
		}
	});	
	
	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum190ukrModel1', {
		fields: [
			///////////////////// 사원정보 //////////////////////////
			{name: 'COMP_CODE'					,text:'법인코드'			,type:'string'},
			{name: 'DIV_CODE'					,text:'사업장'			    ,type:'string'		, comboType: 'BOR120'},
			{name: 'WORK_TYPE'                ,text:'등록구분'            ,type:'string'},
			{name: 'PERSON_NUMB'				,text:'사원번호'			,type:'string'		, allowBlank: false},
			{name: 'NAME'						,text:'사원명'		    	,type:'string'		, allowBlank: false},
			{name: 'DEPT_CODE'					,text:'부서코드'			,type:'string'		},
			{name: 'DEPT_NAME'					,text:'부서명'	     		,type:'string'		},
			{name: 'REG_DATE'					,text:'발령일자'			,type:'uniDate'		, allowBlank: false},
			{name: 'EXPIRY_DATE'		    	,text:'만기일자'			,type:'uniDate'		, allowBlank: false},
			{name: 'ANNUAL_SALARY_YEAR'		    ,text:'기간'   			,type:'int'	},
			
			///////////////////// 급여정보 //////////////////////////
			{name: 'APPLY_YN'					,text:'반영여부'			,type:'string'  , comboType:'AU'	,comboCode:'H156'},
			{name: 'APPLY_YYYYMM_STR'			,text:'적용시작년월'		,type:'string'		, maxLength:7},
			{name: 'APPLY_YYYYMM_END'			,text:'적용종료년월'		,type:'string'		, maxLength:7},
			{name: 'PAY_GRADE_01'				,text:'급'				,type:'string'},
			{name: 'PAY_GRADE_02'				,text:'호봉'				,type:'string'},
			{name: 'PAY_GRADE_03'				,text:'직급'				,type:'string'},
			{name: 'PAY_GRADE_04'				,text:'기술'				,type:'string'},
			{name: 'PAY_TIME'					,text:'시급'				,type:'uniPrice'},
			{name: 'PAY_DAY'					,text:'일급'				,type:'uniPrice'},
			{name: 'WAGES_AMOUNT_I1'			,text:'기본급'			,type:'uniPrice'},
			{name: 'WAGES_AMOUNT_I2'			,text:'시간외'			,type:'uniPrice'},
			{name: 'WAGES_AMOUNT_I3'			,text:'직책수당'			,type:'uniPrice'},
			{name: 'WAGES_AMOUNT_I4'			,text:'기술수당'			,type:'uniPrice'},
			{name: 'WAGES_AMOUNT_I5'			,text:'가족수당'			,type:'uniPrice'},
			{name: 'WAGES_AMOUNT_I6'			,text:'생산장려'			,type:'uniPrice'},
			{name: 'WAGES_AMOUNT_I7'			,text:'반장수당'			,type:'uniPrice'},
			{name: 'WAGES_AMOUNT_I8'			,text:'연구수당'			,type:'uniPrice'},
			{name: 'WAGES_AMOUNT_I9'			,text:'기타수당1'			,type:'uniPrice'},
			{name: 'WAGES_AMOUNT_I10'			,text:'기타수당2'			,type:'uniPrice'},
			{name: 'WAGES_AMOUNT_I11'			,text:'운전수당'			,type:'uniPrice'},
			{name: 'WAGES_AMOUNT_I12'			,text:'연수수당'			,type:'uniPrice'},
		
			{name: 'INSERT_DB_USER'				,text:'입력자'			,type:'string'},
			{name: 'INSERT_DB_TIME'				,text:'입력일'			,type:'uniDate'},
			{name: 'UPDATE_DB_USER'				,text:'수정자'			,type:'string'},
			{name: 'UPDATE_DB_TIME'				,text:'수정일'			,type:'uniDate'},
			{name: 'REMARK'                     ,text:'비고'         ,type:'string'}
			
		]
	});
	
	/** Model 정의 
     * @type 
     */
    Unilite.defineModel('hum190ukrModel2', {
        fields: [
            ///////////////////// 사원정보 //////////////////////////
            {name: 'COMP_CODE'                  ,text:'법인코드'            ,type:'string'},
            {name: 'DIV_CODE'                   ,text:'사업장'             ,type:'string'      , comboType: 'BOR120'},
            {name: 'WORK_TYPE'                ,text:'등록구분'            ,type:'string'},
            {name: 'PERSON_NUMB'                ,text:'사원번호'            ,type:'string'      , allowBlank: false},
            {name: 'NAME'                       ,text:'사원명'             ,type:'string'      , allowBlank: false},
            {name: 'DEPT_CODE'                  ,text:'부서코드'            ,type:'string'      },
            {name: 'DEPT_NAME'                  ,text:'부서명'             ,type:'string'      },
            {name: 'REG_DATE'                   ,text:'발령일자'            ,type:'uniDate'     , allowBlank: false},
            {name: 'EXPIRY_DATE'                ,text:'만기일자'            ,type:'uniDate'     , allowBlank: false},
            {name: 'ANNUAL_SALARY_YEAR'         ,text:'기간'              ,type:'int' , allowBlank: false},
            
            ///////////////////// 급여정보 //////////////////////////
            {name: 'APPLY_YN'                   ,text:'반영여부'            ,type:'string'  , comboType:'AU'    ,comboCode:'H156'},
            {name: 'APPLY_YYYYMM_STR'           ,text:'적용시작년월'      ,type:'string'      , maxLength:7},
            {name: 'APPLY_YYYYMM_END'           ,text:'적용종료년월'      ,type:'string'      , maxLength:7},
            {name: 'PAY_GRADE_01'               ,text:'급'               ,type:'string'},
            {name: 'PAY_GRADE_02'               ,text:'호봉'              ,type:'string'},
            {name: 'PAY_GRADE_03'               ,text:'직급'              ,type:'string'},
            {name: 'PAY_GRADE_04'               ,text:'기술'              ,type:'string'},
            {name: 'PAY_TIME'                   ,text:'시급'              ,type:'uniPrice'},
            {name: 'PAY_DAY'                    ,text:'일급'              ,type:'uniPrice'},
            {name: 'WAGES_AMOUNT_I1'            ,text:'기본급'         ,type:'uniPrice'},
            {name: 'WAGES_AMOUNT_I2'            ,text:'시간외'         ,type:'uniPrice'},
            {name: 'WAGES_AMOUNT_I3'            ,text:'직책수당'            ,type:'uniPrice'},
            {name: 'WAGES_AMOUNT_I4'            ,text:'기술수당'            ,type:'uniPrice'},
            {name: 'WAGES_AMOUNT_I5'            ,text:'가족수당'            ,type:'uniPrice'},
            {name: 'WAGES_AMOUNT_I6'            ,text:'생산장려'            ,type:'uniPrice'},
            {name: 'WAGES_AMOUNT_I7'            ,text:'반장수당'            ,type:'uniPrice'},
            {name: 'WAGES_AMOUNT_I8'            ,text:'연구수당'            ,type:'uniPrice'},
            {name: 'WAGES_AMOUNT_I9'            ,text:'기타수당1'           ,type:'uniPrice'},
            {name: 'WAGES_AMOUNT_I10'           ,text:'기타수당2'           ,type:'uniPrice'},
            {name: 'WAGES_AMOUNT_I11'           ,text:'운전수당'            ,type:'uniPrice'},
            {name: 'WAGES_AMOUNT_I12'           ,text:'연수수당'            ,type:'uniPrice'},
        
            {name: 'INSERT_DB_USER'             ,text:'입력자'         ,type:'string'},
            {name: 'INSERT_DB_TIME'             ,text:'입력일'         ,type:'uniDate'},
            {name: 'UPDATE_DB_USER'             ,text:'수정자'         ,type:'string'},
            {name: 'UPDATE_DB_TIME'             ,text:'수정일'         ,type:'uniDate'},
            {name: 'REMARK'                     ,text:'비고'         ,type:'string'}
            
        ]
    });
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hum190ukrMasterStore1',{
		model		: 'hum190ukrModel1',
		proxy		: directProxy,
		autoLoad	: false,
		uniOpt 		: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelResult.getValues();
			param.WORK_TYPE = '1';
			console.log( param );
			this.load({ params : param});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			console.log("toUpdate",toUpdate);

			var rv = true;
			var paramMaster = panelResult.getValues();
			if(inValidRecs.length == 0 )	{										
				config = {
					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);								
						//directMasterStore.loadStoreRecords();	
					 } 
				};					
				this.syncAllDirect(config);
				
			}else {
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var viewNormal = masterGrid1.getView();
				if(store.getCount() > 0){
					//("QU1:NI1:NW1:DL1:SV0:DA1:PR0:PV0:SF1:CT0:DP0:DN0:CQ0")
					UniAppManager.setToolbarButtons(['reset', 'newData', 'delete' ], true);
					UniAppManager.setToolbarButtons(['save', 'print'], false);
					
					masterGrid1.focus();
				}else{
					//"QU1:NI1:NW1:DL0:SV0:DA0:PR0:PV0:SF1:CT0:DP0:DN0:CQ0")
					UniAppManager.setToolbarButtons(['reset', 'newData'], true);
					UniAppManager.setToolbarButtons(['delete', 'save', 'print'], false);
					
					panelResult.onLoadSelectText('FR_DATE');		
				}
			}					
		}
	});
	/** Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore2 = Unilite.createStore('hum190ukrMasterStore2',{
        model       : 'hum190ukrModel2',
        proxy       : directProxy,
        autoLoad    : false,
        uniOpt      : {
            isMaster    : true,         // 상위 버튼 연결
            editable    : true,         // 수정 모드 사용
            deletable   : true,         // 삭제 가능 여부
            useNavi     : false         // prev | newxt 버튼 사용
        },
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            param.WORK_TYPE = '2';
            console.log( param );
            this.load({ params : param});
        },
        // 수정/추가/삭제된 내용 DB에 적용 하기
        saveStore : function(config)    {
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            console.log("toUpdate",toUpdate);

            var rv = true;
            var paramMaster = panelResult.getValues();
            if(inValidRecs.length == 0 )    {                                       
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {                              
                        panelResult.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false);                             
                        //directMasterStore.loadStoreRecords(); 
                     } 
                };                  
                this.syncAllDirect(config);
                
            }else {
                masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var viewNormal = masterGrid2.getView();
                if(store.getCount() > 0){
                    //("QU1:NI1:NW1:DL1:SV0:DA1:PR0:PV0:SF1:CT0:DP0:DN0:CQ0")
                    UniAppManager.setToolbarButtons(['reset', 'newData', 'delete' ], true);
                    UniAppManager.setToolbarButtons(['save', 'print'], false);
                    
                    masterGrid2.focus();
                }else{
                    //"QU1:NI1:NW1:DL0:SV0:DA0:PR0:PV0:SF1:CT0:DP0:DN0:CQ0")
                    UniAppManager.setToolbarButtons(['reset', 'newData'], true);
                    UniAppManager.setToolbarButtons(['delete', 'save', 'print'], false);
                    
                    panelResult.onLoadSelectText('FR_DATE');        
                }
            }                   
        }
    });
    var buttonStore = Unilite.createStore('hum190ukrButtonStore',{      
        uniOpt		: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,           // 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy		: directButtonProxy,
        saveStore	: function() {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

			var paramMaster			= panelResult.getValues();
            paramMaster.LANG_TYPE	= UserInfo.userLang

            
            if(inValidRecs.length == 0) {
                config = {
					params	: [paramMaster],
                    success : function(batch, option) {
                        //return 값 저장
                        var master = batch.operations[0].getResultSet();
                        
                        UniAppManager.app.onQueryButtonDown();
                        buttonStore.clearData();
                     },

                     failure: function(batch, option) {
                        buttonStore.clearData();
                     }
                };
                this.syncAllDirect(config);
            } else {
            	var activeTab = tab.getActiveTab().getItemId();
            
                if ( activeTab == 'hum190ukrTab1'){
                    var grid = Ext.getCmp('hum190ukrGrid1');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }else if (activeTab == 'hum190ukrTab2'){
                	var grid = Ext.getCmp('hum190ukrGrid2');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
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

    
    
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel		: '발령일자',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			startDate		: UniDate.getDbDateStr(UniDate.get('today')),
			endDate			: UniDate.getDbDateStr(UniDate.get('today')),
			tdAttrs			: {width: 350}, 
			allowBlank		: false,					
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
//				if(panelResult) {
//					panelResult.setValue('TO_DATE',newValue);
//				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox',
			multiSelect	: true, 
			typeAhead	: false,
			comboType	: 'BOR120',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}
		},
		Unilite.popup('Employee',{
                fieldLabel      : '사원',
                valueFieldName  : 'PERSON_NUMB_FR',
                textFieldName   : 'NAME',
                validateBlank   : false,
                autoPopup       : true,
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('PERSON_NUMB_TO', panelResult.getValue('PERSON_NUMB_FR'));
                            panelResult.setValue('NAME1', panelResult.getValue('NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('PERSON_NUMB_FR', '');
                        panelResult.setValue('NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),Unilite.popup('Employee',{
                fieldLabel      : '~',
                valueFieldName  : 'PERSON_NUMB_TO',
                textFieldName   : 'NAME1',
                validateBlank   : false,
                autoPopup       : true,
                colspan         : 2,
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('PERSON_NUMB_TO', '');
                        panelResult.setValue('NAME1', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),
            Unilite.popup('DEPT',{
                fieldLabel      : '부서',
                valueFieldName  : 'DEPT_CODE_FR',
                textFieldName   : 'DEPT_NAME',
                validateBlank   : false,      
                autoPopup       : true,
                tdAttrs         : {width: 380},  
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_FR'));
                            panelResult.setValue('DEPT_NAME1', panelResult.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('DEPT_CODE_FR', '');
                        panelResult.setValue('DEPT_NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),Unilite.popup('DEPT',{
                fieldLabel      : '~',
                valueFieldName  : 'DEPT_CODE_TO',
                textFieldName   : 'DEPT_NAME1',
                validateBlank   : false,    
                autoPopup       : true,
                tdAttrs         : {width: 380},  
                colspan         : 2,
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('DEPT_CODE_TO', '');
                        panelResult.setValue('DEPT_NAME1', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            })
//            {
//                xtype: 'radiogroup',                            
//                fieldLabel: '등록구분',                                         
//                id: 'WORK_TYPE',
//                labelWidth:90,
//                hidden: false,
//                
//                items: [{
//                    boxLabel: '연봉계약',  
//                    width: 120,  
//                    name: 'WORK_TYPE', 
//                    checked: true,
//                    inputValue: '1'
//                },{
//                    boxLabel: '임금피크제 계약',
//                    width: 150,
//                    name: 'WORK_TYPE' ,
//                    inputValue: '2'
//                }],
//                listeners: {
//                    change: function(field, newValue, oldValue, eOpts) {
//                    }
//                }
//            }
            ]
	});
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('hum190ukrGrid1', {
		store	: directMasterStore1,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {				
			useMultipleSorting	: true,		
			useLiveSearch		: false,	
			onLoadSelectFirst	: false,		
			dblClickToEdit		: true,	
			useGroupSummary		: true,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	
			filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		tbar:[
			'->',
			{
				xtype	: 'button',
				text	: '반영',
				width	: 100,
				hidden  : true,
				handler	: function()	{
					fnMakeLogTable();
				}
			}
		],
//		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
//			listeners: {	
////				beforeselect: function(rowSelection, record, index, eOpts) {
////					if(record.get('APPLY_YN') == 'Y'){
////						alert('이미 반영된 데이터는 재반영 할 수 없습니다.');
////						return false;	
////					}
////        		},
//				select: function(grid, selectRecord, index, rowIndex, eOpts ){
//				},
//				deselect:	function(grid, selectRecord, index, eOpts ){
//				}
//			}
//		}),
		columns:	[
			{ dataIndex: 'COMP_CODE'					, width: 100	, hidden: true},
			{ dataIndex: 'DIV_CODE'						, width: 120	, hidden: true},
			{ dataIndex: 'WORK_TYPE'                      , width: 120    , hidden: true},
					{ dataIndex: 'PERSON_NUMB'					, width: 88,
					'editor' : Unilite.popup('Employee_G1',{
							textFieldName:'PERSON_NUMB',
							DBtextFieldName: 'PERSON_NUMB', 
							validateBlank : true,
							autoPopup:true,
							listeners: {
								'onSelected': {
									fn: function(records, type) {
										UniAppManager.app.fnHumanCheck(records);	
									},
									scope: this
								},
								'onClear': function(type) {
									var grdRecord = Ext.getCmp('hum190ukrGrid1').uniOpt.currentRecord;
									grdRecord.set('PERSON_NUMB','');
									grdRecord.set('NAME','');
									
									grdRecord.set('DIV_CODE','');
									grdRecord.set('DEPT_NAME','');
									grdRecord.set('POST_CODE','');	
									grdRecord.set('JOIN_DATE','');
									grdRecord.set('BIRTH_DATE','');
									
									grdRecord.set('WAGES_AMT1','0');
									grdRecord.set('WAGES_AMT2','0');
									grdRecord.set('WAGES_AMT3','0');
									grdRecord.set('WAGES_AMT4','0');
									grdRecord.set('WAGES_AMT5','0');
									grdRecord.set('WAGES_AMT6','0');
									grdRecord.set('WAGES_AMT7','0');
									grdRecord.set('WAGES_AMT8','0');
									grdRecord.set('WAGES_AMT9','0');
									grdRecord.set('WAGES_AMT10','0');
									grdRecord.set('WAGES_AMT11','0');
									grdRecord.set('WAGES_AMT12','0');
								}
			 				}
						})
					},
					{ dataIndex: 'NAME'							, width: 78,
						'editor' : Unilite.popup('Employee_G1',{
							validateBlank : true,
							autoPopup:true,
							listeners: {
								'onSelected': {
									fn: function(records, type) {
										UniAppManager.app.fnHumanCheck(records);	
									},
									scope: this
								},
								'onClear': function(type) {
									var grdRecord = Ext.getCmp('hum190ukrGrid1').uniOpt.currentRecord;
									grdRecord.set('PERSON_NUMB','');
									grdRecord.set('NAME','');
									
									grdRecord.set('DIV_CODE','');
									grdRecord.set('DEPT_NAME','');
									grdRecord.set('POST_CODE','');	
									grdRecord.set('JOIN_DATE','');	
									grdRecord.set('BIRTH_DATE','');
									
									grdRecord.set('WAGES_AMT1','0');
									grdRecord.set('WAGES_AMT2','0');
									grdRecord.set('WAGES_AMT3','0');
									grdRecord.set('WAGES_AMT4','0');
									grdRecord.set('WAGES_AMT5','0');
									grdRecord.set('WAGES_AMT6','0');
									grdRecord.set('WAGES_AMT7','0');
									grdRecord.set('WAGES_AMT8','0');
									grdRecord.set('WAGES_AMT9','0');
									grdRecord.set('WAGES_AMT10','0');
									grdRecord.set('WAGES_AMT11','0');
									grdRecord.set('WAGES_AMT12','0');
								}
			 				}
						})
					},
					{ dataIndex: 'DEPT_CODE'					, width: 88 , hidden: true},
					{ dataIndex: 'DEPT_NAME'					, width: 160, hidden: true},
					{ dataIndex: 'REG_DATE' 					, width: 88},
					{ dataIndex: 'EXPIRY_DATE'					, width: 88},
					{ dataIndex: 'ANNUAL_SALARY_YEAR'    		, width: 80},
					{ dataIndex: 'REMARK'                       , width: 500},
				
//			{ text: '급여정보'								,
//				columns: [
//					{ dataIndex: 'APPLY_YN'						, width: 88, hidden: true},
//					{ dataIndex: 'APPLY_YYYYMM_STR'				, width: 88		, align: 'center', hidden: true},
//					{ dataIndex: 'APPLY_YYYYMM_END'				, width: 88		, align: 'center', hidden: true},
//					{ dataIndex: 'PAY_GRADE_01'					, width: 60, hidden: true},
//					{ dataIndex: 'PAY_GRADE_02'					, width: 60, hidden: true},
//					{ dataIndex: 'PAY_GRADE_03'					, width: 60, hidden: true},
//					{ dataIndex: 'PAY_GRADE_04'					, width: 60, hidden: true},
//					{ dataIndex: 'PAY_TIME'						, width: 110, hidden: true},
//					{ dataIndex: 'PAY_DAY'						, width: 110, hidden: true},
//					{ dataIndex: 'WAGES_AMOUNT_I1'				, width: 110, hidden: true},
//					{ dataIndex: 'WAGES_AMOUNT_I2'				, width: 110, hidden: true},
//					{ dataIndex: 'WAGES_AMOUNT_I3'				, width: 110, hidden: true},
//					{ dataIndex: 'WAGES_AMOUNT_I4'				, width: 110, hidden: true},
//					{ dataIndex: 'WAGES_AMOUNT_I5'				, width: 110, hidden: true},
//					{ dataIndex: 'WAGES_AMOUNT_I6'				, width: 110, hidden: true},
//					{ dataIndex: 'WAGES_AMOUNT_I7'				, width: 110, hidden: true},
//					{ dataIndex: 'WAGES_AMOUNT_I8'				, width: 110, hidden: true},
//					{ dataIndex: 'WAGES_AMOUNT_I9'				, width: 110, hidden: true},
//					{ dataIndex: 'WAGES_AMOUNT_I10'				, width: 110, hidden: true},
//					{ dataIndex: 'WAGES_AMOUNT_I11'				, width: 110, hidden: true},
//					{ dataIndex: 'WAGES_AMOUNT_I12'				, width: 110, hidden: true}
//				]
//			},
			{ dataIndex: 'INSERT_DB_USER'				, width: 120	, hidden: true},
			{ dataIndex: 'INSERT_DB_TIME'				, width: 120	, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'				, width: 120	, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'				, width: 120	, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if (e.record.data.APPLY_YN == 'Y') {
					alert('이미 반영된 데이터는 수정할 수 없습니다.');
					return false;
					
				} 				
				/*if(e.record.phantom == true) {		// 신규일 때
					if(UniUtils.indexOf(e.field, ['OCCUR_DATE'])) {
						return false;
					}
				}*/
				if(!e.record.phantom == true) { // 신규가 아닐 때
					if(UniUtils.indexOf(e.field, ['PERSON_NUMB','NAME','EXPIRY_DATE','ANNUAL_SALARY_YEAR','REMARK' ])) {
						return true;		// 수정가능
					}
					else
					{
						return false;		// 수정불가
					}
				}
				if(e.record.phantom == true) { 	// 신규일 때
					if(UniUtils.indexOf(e.field, ['PERSON_NUMB', 'NAME','EXPIRY_DATE','REMARK','REG_DATE','ANNUAL_SALARY_YEAR'])) {
						return true;		// 수정가능
					}
					else
					{
						return false;		// 수정불가
					}
				}
			},                                                                                             
        	edit: function(editor, e) {
        		console.log(e);                                                    
				var fieldName = e.field;
        		if(fieldName == 'APPLY_YYYYMM_STR' || fieldName == 'APPLY_YYYYMM_END'){
        			var inputDate = e.value;
        			inputDate = inputDate.replace('.', '');
        			if(!Ext.isEmpty(inputDate)) {
	        			if(inputDate.length != 6 || isNaN(inputDate)){
	        				if(dateFlag){
	            				Ext.Msg.alert('확인', '날짜형식이 잘못되었습니다.');
	                            e.record.set(fieldName, e.originalValue);
	                            dateFlag = true;
	                            return false;
	                        }
	                        dateFlag = true;
	                        
	        			}else{
	                        var inputDate = e.value;
	                        inputDate = inputDate.replace('.', '');
	        			    e.record.set(fieldName, inputDate.substring(0,4) + '.' + inputDate.substring(4,6));
	        			    dateFlag = false;
	        			}
        			}
        		}
			},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
        		if (colName == 'PAY_GRADE_01') {
					gsGradeFlag		= '01';
					wageCodePopup();
					
        		} else if (colName == 'PAY_GRADE_02') {
					gsGradeFlag		= '02';
					wageCodePopup();
					
        		} else if (colName == 'PAY_GRADE_03') {
					gsGradeFlag		= '03';
					wageCodePopup();
					
        		} else if (colName == 'PAY_GRADE_04') {
					gsGradeFlag		= '04';
					wageCodePopup();
        		}
            }	
		}
	});
	/** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid2 = Unilite.createGrid('hum190ukrGrid2', {
        store   : directMasterStore2,
        region  : 'center',
        layout  : 'fit',
        uniOpt  : {             
            useMultipleSorting  : true,     
            useLiveSearch       : false,    
            onLoadSelectFirst   : false,        
            dblClickToEdit      : true, 
            useGroupSummary     : true, 
            useContextMenu      : false,    
            useRowNumberer      : true, 
            expandLastColumn    : true,     
            useRowContext       : false,    
            filter: {           
                useFilter       : false,    
                autoCreate      : true  
            }           
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
                    {id : 'masterGridTotal',    ftype: 'uniSummary',      showSummaryRow: false} ],
        tbar:[
            '->',
            {
                xtype   : 'button',
                text    : '반영',
                width   : 100,
                hidden  : true,
                handler : function()    {
                    fnMakeLogTable2();
                }
            }
        ],
//        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
//            listeners: {    
////              beforeselect: function(rowSelection, record, index, eOpts) {
////                  if(record.get('APPLY_YN') == 'Y'){
////                      alert('이미 반영된 데이터는 재반영 할 수 없습니다.');
////                      return false;   
////                  }
////              },
//                select: function(grid, selectRecord, index, rowIndex, eOpts ){
//                },
//                deselect:   function(grid, selectRecord, index, eOpts ){
//                }
//            }
//        }),
        columns:    [
            { dataIndex: 'COMP_CODE'                    , width: 100    , hidden: true},
            { dataIndex: 'DIV_CODE'                     , width: 120    , hidden: true},
            { dataIndex: 'WORK_TYPE'                     , width: 120    , hidden: true},
                    { dataIndex: 'PERSON_NUMB'                  , width: 88,
                    'editor' : Unilite.popup('Employee_G1',{
                            textFieldName:'PERSON_NUMB',
                            DBtextFieldName: 'PERSON_NUMB', 
                            validateBlank : true,
                            autoPopup:true,
                            listeners: {
                                'onSelected': {
                                    fn: function(records, type) {
                                        UniAppManager.app.fnHumanCheck2(records);    
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    var grdRecord = Ext.getCmp('hum190ukrGrid2').uniOpt.currentRecord;
                                    grdRecord.set('PERSON_NUMB','');
                                    grdRecord.set('NAME','');
                                    
                                    grdRecord.set('DIV_CODE','');
                                    grdRecord.set('DEPT_NAME','');
                                    grdRecord.set('POST_CODE','');  
                                    grdRecord.set('JOIN_DATE','');
                                    grdRecord.set('BIRTH_DATE','');
                                    
                                    grdRecord.set('WAGES_AMT1','0');
                                    grdRecord.set('WAGES_AMT2','0');
                                    grdRecord.set('WAGES_AMT3','0');
                                    grdRecord.set('WAGES_AMT4','0');
                                    grdRecord.set('WAGES_AMT5','0');
                                    grdRecord.set('WAGES_AMT6','0');
                                    grdRecord.set('WAGES_AMT7','0');
                                    grdRecord.set('WAGES_AMT8','0');
                                    grdRecord.set('WAGES_AMT9','0');
                                    grdRecord.set('WAGES_AMT10','0');
                                    grdRecord.set('WAGES_AMT11','0');
                                    grdRecord.set('WAGES_AMT12','0');
                                }
                            }
                        })
                    },
                    { dataIndex: 'NAME'                         , width: 78,
                        'editor' : Unilite.popup('Employee_G1',{
                            validateBlank : true,
                            autoPopup:true,
                            listeners: {
                                'onSelected': {
                                    fn: function(records, type) {
                                        UniAppManager.app.fnHumanCheck2(records);    
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    var grdRecord = Ext.getCmp('hum190ukrGrid2').uniOpt.currentRecord;
                                    grdRecord.set('PERSON_NUMB','');
                                    grdRecord.set('NAME','');
                                    
                                    grdRecord.set('DIV_CODE','');
                                    grdRecord.set('DEPT_NAME','');
                                    grdRecord.set('POST_CODE','');  
                                    grdRecord.set('JOIN_DATE','');  
                                    grdRecord.set('BIRTH_DATE','');
                                    
                                    grdRecord.set('WAGES_AMT1','0');
                                    grdRecord.set('WAGES_AMT2','0');
                                    grdRecord.set('WAGES_AMT3','0');
                                    grdRecord.set('WAGES_AMT4','0');
                                    grdRecord.set('WAGES_AMT5','0');
                                    grdRecord.set('WAGES_AMT6','0');
                                    grdRecord.set('WAGES_AMT7','0');
                                    grdRecord.set('WAGES_AMT8','0');
                                    grdRecord.set('WAGES_AMT9','0');
                                    grdRecord.set('WAGES_AMT10','0');
                                    grdRecord.set('WAGES_AMT11','0');
                                    grdRecord.set('WAGES_AMT12','0');
                                }
                            }
                        })
                    },
                    { dataIndex: 'DEPT_CODE'                    , width: 88 , hidden: true},
                    { dataIndex: 'DEPT_NAME'                    , width: 160, hidden: true},
                    { dataIndex: 'REG_DATE'                     , width: 88},
                    { dataIndex: 'EXPIRY_DATE'                  , width: 88},
                    { dataIndex: 'ANNUAL_SALARY_YEAR'           , width: 80},
                    { dataIndex: 'REMARK'                       , width: 500},
//            { text: '급여정보'                              ,
//                columns: [
//                    { dataIndex: 'APPLY_YN'                     , width: 88, hidden: true},
//                    { dataIndex: 'APPLY_YYYYMM_STR'             , width: 88     , align: 'center', hidden: true},
//                    { dataIndex: 'APPLY_YYYYMM_END'             , width: 88     , align: 'center', hidden: true},
//                    { dataIndex: 'PAY_GRADE_01'                 , width: 60, hidden: true},
//                    { dataIndex: 'PAY_GRADE_02'                 , width: 60, hidden: true},
//                    { dataIndex: 'PAY_GRADE_03'                 , width: 60, hidden: true},
//                    { dataIndex: 'PAY_GRADE_04'                 , width: 60, hidden: true},
//                    { dataIndex: 'PAY_TIME'                     , width: 110, hidden: true},
//                    { dataIndex: 'PAY_DAY'                      , width: 110, hidden: true},
//                    { dataIndex: 'WAGES_AMOUNT_I1'              , width: 110, hidden: true},
//                    { dataIndex: 'WAGES_AMOUNT_I2'              , width: 110, hidden: true},
//                    { dataIndex: 'WAGES_AMOUNT_I3'              , width: 110, hidden: true},
//                    { dataIndex: 'WAGES_AMOUNT_I4'              , width: 110, hidden: true},
//                    { dataIndex: 'WAGES_AMOUNT_I5'              , width: 110, hidden: true},
//                    { dataIndex: 'WAGES_AMOUNT_I6'              , width: 110, hidden: true},
//                    { dataIndex: 'WAGES_AMOUNT_I7'              , width: 110, hidden: true},
//                    { dataIndex: 'WAGES_AMOUNT_I8'              , width: 110, hidden: true},
//                    { dataIndex: 'WAGES_AMOUNT_I9'              , width: 110, hidden: true},
//                    { dataIndex: 'WAGES_AMOUNT_I10'             , width: 110, hidden: true},
//                    { dataIndex: 'WAGES_AMOUNT_I11'             , width: 110, hidden: true},
//                    { dataIndex: 'WAGES_AMOUNT_I12'             , width: 110, hidden: true}
//                ]
//            },
            { dataIndex: 'INSERT_DB_USER'               , width: 120    , hidden: true},
            { dataIndex: 'INSERT_DB_TIME'               , width: 120    , hidden: true},
            { dataIndex: 'UPDATE_DB_USER'               , width: 120    , hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'               , width: 120    , hidden: true}
        ],
        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if (e.record.data.APPLY_YN == 'Y') {
                    alert('이미 반영된 데이터는 수정할 수 없습니다.');
                    return false;
                    
                }               
                /*if(e.record.phantom == true) {        // 신규일 때
                    if(UniUtils.indexOf(e.field, ['OCCUR_DATE'])) {
                        return false;
                    }
                }*/
                if(!e.record.phantom == true) { // 신규가 아닐 때
                    if(UniUtils.indexOf(e.field, ['PERSON_NUMB','NAME','EXPIRY_DATE','ANNUAL_SALARY_YEAR','REMARK' ])) {
                        return true;        // 수정가능
                    }
                    else
                    {
                        return false;       // 수정불가
                    }
                }
                if(e.record.phantom == true) {  // 신규일 때
                    if(UniUtils.indexOf(e.field, ['PERSON_NUMB', 'NAME','EXPIRY_DATE','REMARK','REG_DATE','ANNUAL_SALARY_YEAR'])) {
                        return true;        // 수정가능
                    }
                    else
                    {
                        return false;       // 수정불가
                    }
                }
            },                                                                                             
            edit: function(editor, e) {
                console.log(e);                                                    
                var fieldName = e.field;
                if(fieldName == 'APPLY_YYYYMM_STR' || fieldName == 'APPLY_YYYYMM_END'){
                    var inputDate = e.value;
                    inputDate = inputDate.replace('.', '');
                    if(!Ext.isEmpty(inputDate)) {
                        if(inputDate.length != 6 || isNaN(inputDate)){
                            if(dateFlag){
                                Ext.Msg.alert('확인', '날짜형식이 잘못되었습니다.');
                                e.record.set(fieldName, e.originalValue);
                                dateFlag = true;
                                return false;
                            }
                            dateFlag = true;
                            
                        }else{
                            var inputDate = e.value;
                            inputDate = inputDate.replace('.', '');
                            e.record.set(fieldName, inputDate.substring(0,4) + '.' + inputDate.substring(4,6));
                            dateFlag = false;
                        }
                    }
                }
            },
            onGridDblClick :function( grid, record, cellIndex, colName ) {
                if (colName == 'PAY_GRADE_01') {
                    gsGradeFlag     = '01';
                    wageCodePopup();
                    
                } else if (colName == 'PAY_GRADE_02') {
                    gsGradeFlag     = '02';
                    wageCodePopup();
                    
                } else if (colName == 'PAY_GRADE_03') {
                    gsGradeFlag     = '03';
                    wageCodePopup();
                    
                } else if (colName == 'PAY_GRADE_04') {
                    gsGradeFlag     = '04';
                    wageCodePopup();
                }
            }   
        }
    });
	   var tab = Unilite.createTabPanel('hum190ukrTab',{      
        region      : 'center',
        activeTab   : 0,
        border      : false,
        items       : [{
                title   : '연봉계약',
                xtype   : 'container',
                itemId  : 'hum190ukrTab1',
                layout  : {type:'vbox', align:'stretch'},
                items   : [
                    masterGrid1
                ]
            },{
                title   : '임금피크제 계약',
                xtype   : 'container',
                itemId  : 'hum190ukrTab2',
                layout  : {type:'vbox', align:'stretch'},
                items:[
                    masterGrid2
                ]
            }
        ],
        listeners:{
            tabchange: function( tabPanel, newCard, oldCard, eOpts )    {
                if(newCard.getItemId() == 'hum190ukrTab1') {
                }else {
                }
            }
        }
    })
 
	Unilite.Main({
		id			: 'hum190ukrApp',
		borderItems	: [{
		region		: 'center',
		layout		: 'border',
		border		: false,
		items		: [
			   panelResult , tab
		 	]
		}], 
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'newData'],true);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('FR_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			panelResult.onLoadSelectText('FR_DATE');
			
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			
			var activeTab = tab.getActiveTab().getItemId();
			
			if ( activeTab == 'hum190ukrTab1'){
			     masterGrid1.getStore().loadStoreRecords();
			}else if( activeTab == 'hum190ukrTab2'){
			     masterGrid2.getStore().loadStoreRecords();
			}
			
			UniAppManager.setToolbarButtons('reset', true);
		},
		onNewDataButtonDown: function()	{
			var compCode		 = UserInfo.compCode; 
			var applyYyyymm		 = UniDate.getDbDateStr(panelResult.getValue('FR_DATE')).substring(0,6);
			
			var r ={
				COMP_CODE			: compCode,
				APPLY_YYYYMM_STR	: applyYyyymm.substring(0,4) + '.' + applyYyyymm.substring(4,6),
				APPLY_YN			: 'N',
				PERSON_AGE          : 0
				//REG_DATE			: UniDate.getDateStr(new Date())
			};
			var activeTab = tab.getActiveTab().getItemId();
            
            if ( activeTab == 'hum190ukrTab1'){
            	 r = { WORK_TYPE : '1' }
			     masterGrid1.createRow(r);
            }else if( activeTab == 'hum190ukrTab2'){
            	r = { WORK_TYPE : '2' }
            	 masterGrid2.createRow(r);
            }
		},
		onResetButtonDown:function() {
			panelResult.clearForm();
			masterGrid1.getStore().loadData({});
			masterGrid2.getStore().loadData({});
			
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function (config) {
			var activeTab = tab.getActiveTab().getItemId();
            
            if ( activeTab == 'hum190ukrTab1'){
			     directMasterStore1.saveStore(config);
            }else if( activeTab == 'hum190ukrTab2'){
            	 directMasterStore2.saveStore(config);
            }
		},								
								
		onDeleteDataButtonDown : function()	{
			var activeTab = tab.getActiveTab().getItemId();
            
            if ( activeTab == 'hum190ukrTab1'){
		      	 var selRow1 = masterGrid1.getSelectedRecord();
		      	 if(selRow1.phantom == true)   {               
                masterGrid1.deleteSelectedRow();                
                                
                } else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {                    //삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
                    if (selRow1.get('APPLY_YN') == 'Y') {
                        alert('이미 반영된 데이터는 삭제할 수 없습니다.');
                        return false;
                        
                    } else {
                        masterGrid1.deleteSelectedRow();
                    }
                }
            }else if (activeTab == 'hum190ukrTab2'){
			     var selRow2 = masterGrid2.getSelectedRecord();
			     if(selRow2.phantom == true)  {               
                    masterGrid2.deleteSelectedRow();                
                                    
                    } else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {                    //삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
                        if (selRow2.get('APPLY_YN') == 'Y') {
                            alert('이미 반영된 데이터는 삭제할 수 없습니다.');
                            return false;
                            
                        } else {
                            masterGrid2.deleteSelectedRow();
                        }
                    }  
                }
		},						
		fnHumanCheck: function(records) {
			grdRecord = masterGrid1.getSelectedRecord();
			if(!Ext.isEmpty(grdRecord)){
    			record = records[0];
    			grdRecord.set('PERSON_NUMB'		, record.PERSON_NUMB);
    			grdRecord.set('NAME'			, record.NAME);
    			grdRecord.set('DIV_CODE'		, record.SECT_CODE);
    			grdRecord.set('DEPT_CODE'		, record.DEPT_CODE);
    			grdRecord.set('DEPT_NAME'		, record.DEPT_NAME);
    			grdRecord.set('POST_CODE'		, record.POST_CODE_NAME);
    			grdRecord.set('JOIN_DATE'		, record.JOIN_DATE);
    			if(!Ext.isEmpty(record.BIRTH_DATE)) {
    				grdRecord.set('BIRTH_DATE'		, record.BIRTH_DATE);
    				grdRecord.set('PERSON_AGE'		, calcAge(record.BIRTH_DATE));
    			} else {
    				grdRecord.set('BIRTH_DATE'		, '00010101');
    				grdRecord.set('PERSON_AGE'		, 0);
    			}
    			
    			grdRecord.set('WAGES_AMOUNT_I1'	, record.WAGES_AMT1);
    			grdRecord.set('WAGES_AMOUNT_I2'	, record.WAGES_AMT2);
    			grdRecord.set('WAGES_AMOUNT_I3'	, record.WAGES_AMT3);
    			grdRecord.set('WAGES_AMOUNT_I4'	, record.WAGES_AMT4);
    			grdRecord.set('WAGES_AMOUNT_I5'	, record.WAGES_AMT5);
    			grdRecord.set('WAGES_AMOUNT_I6'	, record.WAGES_AMT6);
    			grdRecord.set('WAGES_AMOUNT_I7'	, record.WAGES_AMT7);
    			grdRecord.set('WAGES_AMOUNT_I8'	, record.WAGES_AMT8);
    			grdRecord.set('WAGES_AMOUNT_I9'	, record.WAGES_AMT9);
    			grdRecord.set('WAGES_AMOUNT_I10', record.WAGES_AMT10);
    			grdRecord.set('WAGES_AMOUNT_I11', record.WAGES_AMT11);
    			grdRecord.set('WAGES_AMOUNT_I12', record.WAGES_AMT12);
			}
		},
		fnHumanCheck2: function(records) {
            grdRecord = masterGrid2.getSelectedRecord();
            if(!Ext.isEmpty(grdRecord)){
                record = records[0];
                grdRecord.set('PERSON_NUMB'     , record.PERSON_NUMB);
                grdRecord.set('NAME'            , record.NAME);
                grdRecord.set('DIV_CODE'        , record.SECT_CODE);
                grdRecord.set('DEPT_CODE'       , record.DEPT_CODE);
                grdRecord.set('DEPT_NAME'       , record.DEPT_NAME);
                grdRecord.set('POST_CODE'       , record.POST_CODE_NAME);
                grdRecord.set('JOIN_DATE'       , record.JOIN_DATE);
                if(!Ext.isEmpty(record.BIRTH_DATE)) {
                    grdRecord.set('BIRTH_DATE'      , record.BIRTH_DATE);
                    grdRecord.set('PERSON_AGE'      , calcAge(record.BIRTH_DATE));
                } else {
                    grdRecord.set('BIRTH_DATE'      , '00010101');
                    grdRecord.set('PERSON_AGE'      , 0);
                }
                
                grdRecord.set('WAGES_AMOUNT_I1' , record.WAGES_AMT1);
                grdRecord.set('WAGES_AMOUNT_I2' , record.WAGES_AMT2);
                grdRecord.set('WAGES_AMOUNT_I3' , record.WAGES_AMT3);
                grdRecord.set('WAGES_AMOUNT_I4' , record.WAGES_AMT4);
                grdRecord.set('WAGES_AMOUNT_I5' , record.WAGES_AMT5);
                grdRecord.set('WAGES_AMOUNT_I6' , record.WAGES_AMT6);
                grdRecord.set('WAGES_AMOUNT_I7' , record.WAGES_AMT7);
                grdRecord.set('WAGES_AMOUNT_I8' , record.WAGES_AMT8);
                grdRecord.set('WAGES_AMOUNT_I9' , record.WAGES_AMT9);
                grdRecord.set('WAGES_AMOUNT_I10', record.WAGES_AMT10);
                grdRecord.set('WAGES_AMOUNT_I11', record.WAGES_AMT11);
                grdRecord.set('WAGES_AMOUNT_I12', record.WAGES_AMT12);
            }
        }
	});
	

	
	//급/호/직급/기술 팝업
	function wageCodePopup()	{ 
		if(!payGrdWin) {
			//Model 정의
			var winfields = [
				{name: 'PAY_GRADE_01' 		,text:'급' 					,type:'string'	},
				{name: 'PAY_GRADE_02' 		,text:'호' 					,type:'string'	}
			];
			Ext.each(wageStd, function(stdCode, idx) {
				winfields.push({name: 'CODE'+stdCode.WAGES_CODE 	,text:stdCode.WAGES_NAME+'코드' 		,type:'string'	});
				winfields.push({name: 'STD'+stdCode.WAGES_CODE 		,text:stdCode.WAGES_NAME 			,type:'uniPrice'});					
			})
			Unilite.defineModel('WagesCodeModel', {
				fields: winfields
			});
			
			//Proxy 생성
			var wagesCodeDirctProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
				api: {
					read : 'hum105ukrService.fnHum100P2'
				}
			});
			
			//Store 생성
			var wageCodeStore = Unilite.createStore('wageCodeStore', {
				model	: 'WagesCodeModel' ,
				uniOpt	: {
					isMaster	: false,			// 상위 버튼 연결 
					editable	: false,			// 수정 모드 사용 
					deletable	: false,			// 삭제 가능 여부 
					useNavi		: false				// prev | newxt 버튼 사용
				},
				proxy	: wagesCodeDirctProxy,			
				loadStoreRecords : function()	{
					var param= payGrdWin.down('#search').getValues();
					
					this.load({
						params: param
					});				
				}
			});
	
			//Grid 생성
			var wageColumns = [
				{ dataIndex: 'PAY_GRADE_01' 			,width: 40  },
				{ dataIndex: 'PAY_GRADE_02' 			,width: 40  }  
			];
			Ext.each(wageStd, function(stdCode, idx) {
				wageColumns.push({dataIndex: 'CODE'+stdCode.WAGES_CODE 		,width: 50 	, hidden:true});
				wageColumns.push({dataIndex: 'STD'+stdCode.WAGES_CODE 		,width: 100  });					
			});  
			
			
			//OPEN할 팝업(Window) 생성
			payGrdWin = Ext.create('widget.uniDetailWindow', {
				title	: '급호봉조회POPUP',
				width	: 400,								
				height	: 400,
				layout	: {type:'vbox', align:'stretch'},					
				items	: [{
						itemId	: 'search',
						xtype	: 'uniSearchForm',
						layout	: {type:'uniTable',columns:2},
						items	: [{	
							fieldLabel	: '급',
							name		: 'PAY_GRADE_01',
							labelWidth	: 60,
							width		: 160
						},{
							
							fieldLabel	: '호',
							name		: 'PAY_GRADE_02',
							labelWidth	: 60,
							width		: 160
						},{
							
							fieldLabel	: '구분',
							name		: 'GRADE_FLAG',
							labelWidth	: 60,
							width		: 160,
							hidden		: true
						}]
					},
					Unilite.createGrid('payGrd', {
						store	: wageCodeStore,
						itemId	: 'grid',
						layout	: 'fit',
						selModel: 'rowmodel',
						uniOpt	: {
							expandLastColumn	: false,
							useRowNumberer		: false,
							onLoadSelectFirst	: true,
							userToolbar			: false
						},
						columns	: wageColumns,
						listeners: {	
						  		onGridDblClick:function(grid, record, cellIndex, colName) {
				  					grid.ownerGrid.returnData();
				  					payGrdWin.hide();
				  				}
							},
							returnData: function()	{
								var record = this.getSelectedRecord();  
								var grdRecord = masterGrid1.getSelectionModel().getSelection()[0];
								if(!Ext.isEmpty(grdRecord)){
    								if (gsGradeFlag == '03') {
    									grdRecord.set('PAY_GRADE_03', record.get("PAY_GRADE_02"));
    									grdRecord.set('WAGES_AMOUNT_I3', record.get("STD110"));			//직책수당
    									
    								} else if (gsGradeFlag == '04') {
    									grdRecord.set('PAY_GRADE_04', record.get("PAY_GRADE_02"));
    									grdRecord.set('WAGES_AMOUNT_I4', record.get("STD120"));			//기술수당
    									
    								} else {
    									grdRecord.set('PAY_GRADE_01', record.get("PAY_GRADE_01"));
    									grdRecord.set('PAY_GRADE_02', record.get("PAY_GRADE_02"));
    									grdRecord.set('WAGES_AMOUNT_I1', record.get("STD100"));			//기본급
    									grdRecord.set('WAGES_AMOUNT_I2', record.get("STD300"));			//시간외수당
    									grdRecord.set('WAGES_AMOUNT_I5', record.get("STD130"));			//가족수당
    								}
								}else{
    								var grdRecord = masterGrid2.getSelectionModel().getSelection()[0];
                                    if (gsGradeFlag == '03') {
                                        grdRecord.set('PAY_GRADE_03', record.get("PAY_GRADE_02"));
                                        grdRecord.set('WAGES_AMOUNT_I3', record.get("STD110"));         //직책수당
                                        
                                    } else if (gsGradeFlag == '04') {
                                        grdRecord.set('PAY_GRADE_04', record.get("PAY_GRADE_02"));
                                        grdRecord.set('WAGES_AMOUNT_I4', record.get("STD120"));         //기술수당
                                        
                                    } else {
                                        grdRecord.set('PAY_GRADE_01', record.get("PAY_GRADE_01"));
                                        grdRecord.set('PAY_GRADE_02', record.get("PAY_GRADE_02"));
                                        grdRecord.set('WAGES_AMOUNT_I1', record.get("STD100"));         //기본급
                                        grdRecord.set('WAGES_AMOUNT_I2', record.get("STD300"));         //시간외수당
                                        grdRecord.set('WAGES_AMOUNT_I5', record.get("STD130"));         //가족수당
                                    }
								}
							}
					})
						
				],
				tbar:  ['->',{
						itemId	: 'searchtBtn',
						text	: '조회',
						handler	: function() {
							var form = payGrdWin.down('#search');
							var store = Ext.data.StoreManager.lookup('creditStore')
							wageCodeStore.loadStoreRecords();
						},
						disabled: false
					},
					 {
						itemId	: 'submitBtn',
						text	: '확인',
						handler	: function() {
							payGrdWin.down('#grid').returnData()
							payGrdWin.hide();
						},
						disabled: false
					},{
						itemId	: 'closeBtn',
						text	: '닫기',
						handler	: function() {
							payGrdWin.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						payGrdWin.down('#search').clearForm();
						payGrdWin.down('#grid').reset();
						wageCodeStore.clearData();
					},
					beforeclose: function( panel, eOpts )	{
						payGrdWin.down('#search').clearForm();
						payGrdWin.down('#grid').reset();
						wageCodeStore.clearData();
					},
					show: function( panel, eOpts )	{
						var form = payGrdWin.down('#search');
						form.clearForm();
						form.setValue('GRADE_FLAG', gsGradeFlag);
						Ext.data.StoreManager.lookup('wageCodeStore').loadStoreRecords();
					}
				}		
			});
		}	
		payGrdWin.center();		
		payGrdWin.show();
		return payGrdWin;
	}
	
	
	//만나이 계산 함수
	function calcAge(birth) {                 
	    var date = new Date();
	    var year = date.getFullYear();
	    var month = (date.getMonth() + 1);
	    var day = date.getDate();       
	    if (month < 10) month = '0' + month;
	    if (day < 10) day = '0' + day;
	    var monthDay = month + day;
	       
	    birth = birth.replace('-', '').replace('-', '');
	    var birthdayy = birth.substr(0, 4);
	    var birthdaymd = birth.substr(4, 4);
	 
	    var age = monthDay < birthdaymd ? year - birthdayy - 1 : year - birthdayy;
	    return age;
	} 
	
	
	//SP 호출용 함수
	function fnMakeLogTable() {
		//조건에 맞는 내용은 적용 되는 로직
		records = masterGrid1.getSelectedRecords();
    		buttonStore.clearData();											//buttonStore 클리어
    		Ext.each(records, function(record, index) {
                record.phantom 			= true;
                buttonStore.insert(index, record);
    			
    			if (records.length == index +1) {
                    buttonStore.saveStore();
    			}
    		});
		
	}
	//SP 호출용 함수
    function fnMakeLogTable2() {
        //조건에 맞는 내용은 적용 되는 로직
        records = masterGrid2.getSelectedRecords();
            buttonStore.clearData();                                         //buttonStore 클리어
            Ext.each(records, function(record, index) {
                record.phantom          = true;
                buttonStore.insert(index, record);
                
                if (records.length == index +1) {
                    buttonStore.saveStore();
                }
            });
    }

	
	
	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {
				case "BIRTH_DATE" : // 생일
					record.set('PERSON_AGE', calcAge(UniDate.getDbDateStr(newValue)));
					break;
				case "EXPIRY_DATE":
				    
				    var regdate = record.get('REG_DATE');
				    var extdate = newValue;
				    regdate = new Date(regdate);
				    extdate = new Date(extdate);
				    if( extdate < regdate ){
				    	alert('만기일자가 발령일자보다 작을수 없습니다.');
				    	return false;
				    }
			}
			return rv;
		}
	}); // validator
	Unilite.createValidator('validator01', {
        store   : directMasterStore2,
        grid    : masterGrid2,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            
            switch(fieldName) {
                case "BIRTH_DATE" : // 생일
                    record.set('PERSON_AGE', calcAge(UniDate.getDbDateStr(newValue)));
                    break;
            }
            return rv;
        }
    }); // validator
};

</script>
