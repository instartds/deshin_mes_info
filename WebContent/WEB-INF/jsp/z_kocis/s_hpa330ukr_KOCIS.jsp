<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa330ukr_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="A043" /> <!-- 지급/공제구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="B028" /> <!-- 직간접구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직종 -->
	<t:ExtComboStore comboType="AU" comboCode="H007" /> <!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H029" /> <!-- 세액구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" opts= '${gsList1}' />			<!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H034" /> <!-- 공제코드분 -->
	<t:ExtComboStore comboType="AU" comboCode="H036" /> <!-- 잔업구분자 -->
	<t:ExtComboStore comboType="AU" comboCode="H048" /> <!-- 입퇴사자구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H147" /> <!-- 입퇴사구분 -->
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
	

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var gsSaveButtonYn = 0;						// 조회시에는 저장버튼 비활성화 하기 위한 변수 설정
	var gsList1 = '${gsList1}';					// 지급구분 '1'인 것만 콤보에서 보이도록 설정
	var dutyRefWindow;							// 월근무 현황 보기 팝업
	

	var saveWageProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 's_hpa330ukrService_KOCIS.insertList1',
            syncAll	: 's_hpa330ukrService_KOCIS.saveAll1'
		}
	});	
	
	var saveWageProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 's_hpa330ukrService_KOCIS.insertList2',
            syncAll	: 's_hpa330ukrService_KOCIS.saveAll2'
		}
	});	
	
	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa330ukrModel', {
	   fields: [
			{name: 'QUERY_COUNT'		, text: '조회테이블구분'		, type: 'string'},
			{name: 'PAY_YYYYMM'			, text: '지급년월'				, type: 'string'},
			{name: 'SUPP_TYPE'			, text: '지급구분'				, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'					, type: 'string'},
			{name: 'WAGES_CODE'			, text: '지급내역'				, type: 'string'},
			{name: 'WAGES_NAME'			, text: '지급내역'				, type: 'string'},
			{name: 'AMOUNT_I'			, text: '지급금액'				, type: 'uniFC'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'				, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'		, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'		, type: 'string'},
			{name: 'DED_CODE'			, text: '공제코드'				, type: 'string'},
			{name: 'DED_AMOUNT_I'		, text: '공제금액'				, type: 'uniFC'}
	    ]
	});		// End of Ext.define('Hpa330ukrModel', {
	  
	
	
	/** Store 정의(Service 정의)
	 * @type 	
	 */					
	var masterStore1 = Unilite.createStore('s_hpa330ukrMasterStore1',{
		model: 'Hpa330ukrModel',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: true,			// 수정 모드 사용 
            deletable	: true,			// 삭제 가능 여부 
	        useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_hpa330ukrService_KOCIS.selectList1'                	
            }
        },
        saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
//						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			}else {
//				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        loadStoreRecords: function(person_numb, name) {
        	if (person_numb != null && person_numb != '') {
				panelSearch.getForm().setValues({'PERSON_NUMB' : person_numb});
				panelSearch.getForm().setValues({'NAME' : name});
			}
        	var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {/*
           		if(store.getCount() > 0){
					UniAppManager.setToolbarButtons('save',			true);
					UniAppManager.setToolbarButtons('newData',		false);
					UniAppManager.setToolbarButtons('delete',		true);
					UniAppManager.setToolbarButtons('deleteAll',	false);

				}else{
					UniAppManager.setToolbarButtons('save',			false);
					UniAppManager.setToolbarButtons('newData',		false);
					UniAppManager.setToolbarButtons('delete',		false);
					UniAppManager.setToolbarButtons('deleteAll',	false);
				}
           	*/},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore2 = Unilite.createStore('s_hpa330ukrMasterStore2',{
		model: 'Hpa330ukrModel',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: true,			// 수정 모드 사용 
            deletable	: true,			// 삭제 가능 여부 
	        useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_hpa330ukrService_KOCIS.selectList2'                	
            }
        },
        saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
//						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			}else {
//				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        loadStoreRecords: function(person_numb, name) {
        	if (person_numb != null && person_numb != '') {
				panelSearch.getForm().setValues({'PERSON_NUMB' : person_numb});
				panelSearch.getForm().setValues({'NAME' : name});
			}
        	var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
		
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records.length > 0 && records[0].data.QUERY_COUNT == 'SECOND'){
    				if (records[0].data) {
    					UniAppManager.setToolbarButtons('save', true);
    					var msg = records.length + Msg.sMB001; 								//'건이 조회되었습니다.';
    					//console.log(msg, st);
    					UniAppManager.updateStatus(msg, true);  
    					
    				} else {
    					UniAppManager.setToolbarButtons('save', false);
    					var msg = records.length + Msg.sMB001; 								//'건이 조회되었습니다.';
    					//console.log(msg, st);
    					UniAppManager.updateStatus(msg, true);  
    				}
				}
			}
		}
	});
	
	/** 월근무 현황 그리드용 스토어
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore3 = Unilite.createStore('s_hpa330ukrMasterStore3',{
		fields: [
			{name: 'CODE_NAME'		, text: '근태내역'	, type: 'string'},
			{name: 'DUTY_NUM'		, text: '횟수'		, type: 'int'},
			{name: 'DUTY_TIME'		, text: '시간'		, type: 'int'}
	    ],
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_hpa330ukrService_KOCIS.selectList4'                	
            }
        },
        loadStoreRecords: function() {
        	var param= Ext.getCmp('searchForm').getValues();
        	param.S_COMP_CODE = UserInfo.compCode;
			this.load({
				params : param
			});
		}
	});
	
	/** 그리드 내용 저장을 위한 임시 Store
	 * Store 정의(Service 정의)
	 * @type 
	 */					
    var buttonStore = Unilite.createStore('s_hpa330ukrButtonStore',{  
        proxy		: saveWageProxy,    
        uniOpt		: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,           // 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        saveStore	: function(searchParam) {             
            var inValidRecs	= this.getInvalidRecords();
            var toCreate	= this.getNewRecords();

			var paramMaster	= panelSearch.getValues();
            
            if(inValidRecs.length == 0) {
                config = {
					params	: [paramMaster],
                    success : function(batch, option) {
                        //return 값 저장
                        var master = batch.operations[0].getResultSet();
                        
                        buttonStore.clearData();
			
						//3. 공제내역 등록 
						var saveData2 = masterStore2.data.items; 
						buttonStore2.clearData();											//buttonStore 클리어
						Ext.each(saveData2, function(record2, index2) {
				            record2.phantom 			= true;
				            buttonStore2.insert(index2, record2);
							
							if (saveData2.length == index2 +1) {
				                buttonStore2.saveStore(searchParam);
							}
						});
                     },

                     failure: function(batch, option) {
                        buttonStore.clearData();
                     }
                };
                this.syncAllDirect(config);
                
            } else {
                var grid1 = Ext.getCmp('hpa330Grid1');
                grid1.uniSelectInvalidColumnAndAlert(inValidRecs);
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
    
    var buttonStore2 = Unilite.createStore('s_hpa330ukrButtonStore2',{  
        proxy		: saveWageProxy2,    
        uniOpt		: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,           // 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        saveStore	: function(searchParam) {             
            var inValidRecs	= this.getInvalidRecords();
            var toCreate	= this.getNewRecords();

			var paramMaster	= panelSearch.getValues();
            
            if(inValidRecs.length == 0) {
                config = {
					params	: [paramMaster],
                    success : function(batch, option) {
                        //return 값 저장
                        var master = batch.operations[0].getResultSet();

                        buttonStore2.clearData();
                        
						// form01, form02 submit
						var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
						var mon = payDate.getMonth() + 1;
						var dateString = payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);
						
						var param = panelResult2.getValues();
						
						param.PAY_YYYYMM = dateString;
						param.SUPP_TYPE = searchParam.SUPP_TYPE;
						param.PERSON_NUMB = searchParam.PERSON_NUMB;
						
						// TODO : fix it!!! null date passed!!
						panelResult.getForm().submit({
							 params : param,
							 success : function(actionform, action) {     
								UniAppManager.app.onQueryButtonDown();    
							 	panelResult.getForm().wasDirty = false;               
			//				 	panelResult.resetDirtyStatus();	alert('form01 done');										
								UniAppManager.setToolbarButtons('save', false);	
			//            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
							 }	
						});
                     },

                     failure: function(batch, option) {
                        buttonStore2.clearData();
                     }
                };
                this.syncAllDirect(config);
                
            } else {
                var grid2 = Ext.getCmp('hpa330Grid2');
                grid1.uniSelectInvalidColumnAndAlert(inValidRecs);
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
	var panelSearch = Unilite.createSearchForm('searchForm', {		
        defaultType: 'uniTextfield',
		region:'north',
		padding:'1 1 1 1',
		border:true,
        layout: {type: 'uniTable', columns: 4,
        tableAttrs: {width: '100%'/*, align : 'left'*/}//,
//		tdAttrs: {style: 'border : 1px solid #ced9e7;',width:300/*, align : 'center'*/}
        },
        itemId: 'search_panel1',
		items: [
			{
		  	xtype: 'container',
		  	layout: {
		   		type: 'uniTable', 
		   		columns:3,
//		   		tableAttrs: {style: 'border : 1px solid #ced9e7;', width: 900},
		   		tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width:300/*, align : 'center'*/}
	  		},
	  		items:[{
				fieldLabel: '귀속년월',
				id: 'PAY_YYYYMM',
				xtype: 'uniMonthfield',
				name: 'PAY_YYYYMM', 
				labelWidth:90,
				value: UniDate.get('today'),
		        tdAttrs: {width: 300},  
				allowBlank: false
			},{
				fieldLabel: '지급구분',
				id: 'SUPP_TYPE',
				name: 'SUPP_TYPE', 
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'H032',                
		        tdAttrs: {width: 300},
				allowBlank : false,
				value : '1'
			},
				Unilite.popup('Employee', {
					fieldLabel: '직원', 
				    valueFieldName:'PERSON_NUMB',
				    textFieldName:'NAME',
	//				textFieldWidth: 170, 
					validateBlank: false,
					allowBlank: false,
					id: 'PERSON_NUMB',
					tdAttrs: {width: 300},
					listeners:{
						onTextSpecialKey: function(elm, e){
		                    if (e.getKey() == e.ENTER) {
								UniAppManager.app.onQueryButtonDown();
		                    }
		                }
					}
			})]
		},{
		  	xtype: 'container',
		  	layout: {
		   		type: 'uniTable', 
		   		columns:2,
		   		tdAttrs: {width: '100%', align: 'right'}
	  		},
	  		items:[{
				xtype: 'button',					
				text: '마감등록',
				width: 85,
		        tdAttrs: {align: 'right'}, 
				handler: function(btn) {     
					var formParam= Ext.getCmp('searchForm').getValues();
					var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
					var mon = payDate.getMonth() + 1;
					var dateString = payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);
					
					var params = {
							PGM_ID		: 's_hpa330ukr_KOCIS',
							PAY_YYYYMM	: dateString,
							NAME 		: panelSearch.getForm().findField('NAME').getValue(),
							PERSON_NUMB	: formParam.PERSON_NUMB,
							SUPP_TYPE	: panelSearch.getForm().findField('SUPP_TYPE').getValue()
					};
					var rec = {data : {prgID : 's_hbs920ukr_KOCIS', 'text':'급여마감정보등록(개인별)'}};							
					parent.openTab(rec, '/z_kocis/s_hbs920ukr_KOCIS.do', params);
				}
			},{
				xtype: 'button',
				text: '급여재계산',
		        tdAttrs: {align: 'right'},
				handler: function(btn) {
					var formParam= Ext.getCmp('searchForm').getValues();
					var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
					var mon = payDate.getMonth() + 1;
					var dateString = payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);
					
					var params = {
							PGM_ID		: 's_hpa330ukr_KOCIS',
							PAY_YYYYMM	: dateString,
							NAME 		: panelSearch.getForm().findField('NAME').getValue(),
							PERSON_NUMB	: formParam.PERSON_NUMB,
							SUPP_TYPE	: panelSearch.getForm().findField('SUPP_TYPE').getValue()
					};
					var rec = {data : {prgID : 's_hpa340ukr_KOCIS', 'text':'급여계산'}};							
					parent.openTab(rec, '/z_kocis/s_hpa340ukr_KOCIS.do', params);
				}
			}]
		 }]
    });
	
    
    
    /** result form 정의(Form Panel - 오른쪽 PANEL)
     * @type 
     */
	var panelResult = Unilite.createSearchForm('resultForm',{
//    	xtype: 'container',
		defaultType	: 'uniTextfield',
    	region		: 'east',
    	border		: true,
		layout		: {type: 'uniTable', align: 'stretch', columns: 1},
		tableAttrs	: {width: '100%'/*, align : 'left'*/},
	    api: {
        	load	: 's_hpa330ukrService_KOCIS.selectList3',
        	submit	: 's_hpa330ukrService_KOCIS.form01Submit'
        },
	    padding: '1 1 1 1',
//	    flex: 0.7,
	    width: 315,
        autoScroll: true,  
	    items: [{	
	    	xtype:'panel',
	        defaultType: 'uniTextfield',
	        flex: 1,
            border: false,
	        layout: {
	        	type: 'uniTable',
	        	columns : 1
	        },
	        defaults: { readOnly:true },
	        items: [/*{
				xtype: 'radiogroup',		            		
				fieldLabel: '세액계산',						            		
				id: 'rdoSelect1',
				tdAttrs: {width: '290', align : 'left'},
				items: [{
					boxLabel: '한다', 
					width: 70, 
					name: 'rdoSelect1name',
					inputValue: 'Y',
					checked: true
				},{
					boxLabel : '안한다', 
					width: 70,
					name: 'rdoSelect1name',
					inputValue: 'N' 
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '고용보험계산',						            		
				id: 'rdoSelect2',
//				disabled: true,
				items: [{
					boxLabel: '한다', 
					width: 70, 
					name: 'rdoSelect2name',
					inputValue: 'Y',
					checked: true
				},{
					boxLabel : '안한다', 
					width: 70,
					name: 'rdoSelect2name',
					inputValue: 'N' 
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '산재보험계산',						            		
				id: 'rdoSelect3',
//				disabled: true,
				items: [{
					boxLabel: '한다', 
					width: 70, 
					name: 'rdoSelect3name',
					inputValue: 'Y',
					checked: true
				},{
					boxLabel : '안한다', 
					width: 70,
					name: 'rdoSelect3name',
					inputValue: 'N' 
				}]
			},*/{
				xtype: 'container',
	        	layout: {type: 'table', columns: 2},
	        	defaults: { xtype: 'button' },		            	
				tdAttrs: {align : 'center'},
				items:[{
					text: '전월급여복사',
					width: 100,
					handler: function(btn) {
						if(!UniAppManager.app.isValidSearchForm()){
							return false;
						} else {
							copyPrevData();
						}
					}
				},{
					text: '월근무현황보기',
					width: 100,
					handler: function(btn) {
						if(!UniAppManager.app.isValidSearchForm()){
							return false;
						} else {
							openDutyRefWindow();
						}
					}
				}]
			}/*,
	        	{fieldLabel: '연구활동비비과세',	name: 'TAX_EXEMPTION6_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '국외근로', 		name: 'TAX_EXEMPTION4_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '연장비과세', 		name: 'TAX_EXEMPTION1_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '보육비과세', 		name: 'TAX_EXEMPTION5_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '식대비과세',		name: 'TAX_EXEMPTION2_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '기타비과세',		name: 'TAX_EXEMPTION3_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '사회보험사업자부담금',	name: 'BUSI_SHARE_I',		xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '산재보험사업자부담금',	name: 'WORKER_COMPEN_I',	xtype: 'uniNumberfield',	labelWidth: 130
        	},{
				xtype: 'container',
				tdAttrs: {align: 'center'},
				layout:{type : 'uniTable', columns : 1, tableAttrs: {width: '95%'}},
				items:[{
					xtype: 'component',
					tdAttrs: {style: 'border-bottom: 1.4px solid #cccccc;'}
				}]
			},
	        	{fieldLabel: '비과세총액',		name: 'TAX_EXEMPTIONTOT_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '과세제외총액',		name: 'NON_TAX_I',			xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '과세분금액',		name: 'TAX_AMOUNT_I',		xtype: 'uniNumberfield',	labelWidth: 130
        	}*/,{
				xtype: 'container',
				tdAttrs: {align: 'center'},
				layout:{type : 'uniTable', columns : 1, tableAttrs: {width: '95%'}},
				items:[{
					xtype: 'component',
					tdAttrs: {style: 'border-bottom: 1.4px solid #cccccc;'}
				}]
			},
	        	{fieldLabel: '급여총액',		name: 'SUPP_TOTAL_I',		xtype: 'uniNumberfield',	decimalPrecision: 2,	labelWidth: 130}, 
	        	{fieldLabel: '공제총액',		name: 'DED_TOTAL_I',		xtype: 'uniNumberfield',	decimalPrecision: 2,	labelWidth: 130},
	        	{fieldLabel: '실지급액',		name: 'REAL_AMOUNT_I',		xtype: 'uniNumberfield',	decimalPrecision: 2,	labelWidth: 130}
	        ]
		}]
    });
	
    /** 아랫쪽 PANEL */
    var panelResult2 = Unilite.createSearchForm('resultForm2',{
		region: 'south',    	
		defaultType: 'uniTextfield',
		layout: {type: 'uniTable', columns : 5/*, tableAttrs: {align:'left'}*/
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}

		},
        height: 118,
        autoScroll: true,
	    api: {
        	load	: 's_hpa330ukrService_KOCIS.selectList3',
        	submit	: 's_hpa330ukrService_KOCIS.form02Submit'
        },
		padding:'1 1 1 1',
		border:true,
	    items: [
				/*Unilite.popup('DEPT',{
					fieldLabel: '부서',
					name: 'DEPT_CODE',
				    valueFieldName:'DEPT_CODE',
				    textFieldName:'DEPT_NAME',
					allowBlank: false
			}),*/{
				fieldLabel	: '직위',
				name		: 'POST_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H005'
			},{
				fieldLabel	: '급여지급방식',
				name		: 'PAY_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H028',  
				allowBlank	: false
			},{
				fieldLabel	: '급여지급일',
				id			: 'SUPP_DATE',
				xtype		: 'uniDatefield',
				name		: 'SUPP_DATE',
				allowBlank	: false
			},{
				fieldLabel	: '기본급',
				xtype		: 'uniNumberfield',
				name		: 'WAGES_STD_I',
				fieldStyle	: 'text-align: right',
				decimalPrecision: 2
			},{
				xtype: 'component'
			},{
				fieldLabel	: '입퇴사구분',
				name		: 'EXCEPT_TYPE', 
				id			: 'EXCEPT_TYPE', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H048',
				allowBlank	: false
			},{
				fieldLabel	: '지급차수',
				name		: 'PAY_PROV_FLAG', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H031',  
				allowBlank	: false
			},{
				fieldLabel	: '입사일',
				xtype		: 'uniDatefield',
				id			: 'JOIN_DATE',
				name		: 'JOIN_DATE'
			},{
				fieldLabel	: '기준소득월액',
				xtype		: 'uniNumberfield',
				name		: 'ANU_BASE_I',
				fieldStyle	: 'text-align: right',
				decimalPrecision: 2
			},{
				xtype: 'component'
			},{
				fieldLabel	: '사원구분',
				name		: 'EMPLOY_TYPE', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H024',  
				allowBlank	: false
			},{
				fieldLabel	: '세액구분',
				name		: 'TAX_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H029',  
				allowBlank	: false
			},{
				fieldLabel	: '퇴사일',
				xtype		: 'uniDatefield',
				name		: 'RETR_DATE',
				id 			: 'RETR_DATE'
			},{
				fieldLabel	: '월평균보수액',
				xtype		: 'uniNumberfield',
				name		: 'MED_AVG_I',
				fieldStyle	: 'text-align: right',
				decimalPrecision: 2
			}/*,{
				xtype: 'radiogroup',		            		
				fieldLabel: '배우자',						            		
				id: 'rdoSelect4',
				items: [{
					boxLabel: '유', 
					width: 70, 
					name: 'SPOUSE',
					inputValue: 'Y'
				},{
					boxLabel : '무', 
					width: 70,
					name: 'SPOUSE',
					inputValue: 'N',
					checked: true
				}]
			}*/,{
				xtype: 'component'
			},{
				xtype: 'component'
			},{
				xtype: 'component'
			},{
				xtype: 'component'
			}/*,{
				xtype: 'button',					
				text: '테스트',
				width: 85,
		        tdAttrs: {align: 'right'}, 
				handler: function(btn) {
						fnSaveGridData();
				}
			}*//*,{
				layout: {type:'hbox'},
				xtype: 'container',
				items: [{
					fieldLabel: '부양자.20세이하자녀 ',
				 	xtype: 'uniNumberfield',
				 	name: 'SUPP_NUM',
				 	id: 'SUPP_NUM',
				 	flex: 3,
				 	labelWidth: 120
				},{
				 	xtype: 'uniNumberfield',
				 	name: 'CHILD_20_NUM',	
				 	id: 'CHILD_20_NUM',			 	
				 	flex: 1,
				 	suffixTpl: '명'
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '세율기준',						            		
				id: 'rdoSelect5',
				items: [{
					boxLabel: '80%', 
					width: 50, 
					name: 'TAX_RATE',
					inputValue: '1'
				},{
					boxLabel : '100%', 
					width: 50,
					name: 'TAX_RATE',
					inputValue: '2',
					checked: true 
				},{
					boxLabel : '120%', 
					width: 50,
					name: 'TAX_RATE',
					inputValue: '3' 
				}]
			}*/
		], 
		listeners : {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
				if (gsSaveButtonYn == 0 && masterStore1.getCount() != 0) {
					if(basicForm.isDirty())	{
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
				}
			},
			actioncomplete:function( basicForm, action, eOpts ) {
				gsSaveButtonYn = 0;
			}
		}
    });
    
    
    /** 지급내역 */
    var masterGrid = Unilite.createGrid('hpa330Grid1', {
		store	: masterStore1,
		uniOpt	: {
			useMultipleSorting	: true,			 
	    	useLiveSearch		: false,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: false,			
			expandLastColumn	: false,		
			useRowContext		: false,			
            userToolbar			: false,
	    	filter: {
				useFilter	: false,		
				autoCreate	: false		
			}
		},
    	features: [{id: 'masterGridTotal1', ftype: 'uniSummary', showSummaryRow: true}],
        columns	: [        
        	{dataIndex: 'PAY_YYYYMM'			, width: 200	, hidden: true}, 				
			{dataIndex: 'SUPP_TYPE'				, width: 200	, hidden: true}, 				
			{dataIndex: 'PERSON_NUMB'			, width: 200	, hidden: true}, 				
			{dataIndex: 'WAGES_CODE'			, width: 200	, hidden: true}, 				
			{dataIndex: 'WAGES_NAME'			, width: 200	, summaryRenderer: function(value){ return '합계'; }, text: '지급내역'}, 				
			{dataIndex: 'AMOUNT_I'				, flex:1		, summaryType:'sum'}, 				
			{dataIndex: 'COMP_CODE'				, width: 200	, hidden: true}, 				
			{dataIndex: 'UPDATE_DB_USER'		, width: 200	, hidden: true}, 				
			{dataIndex: 'UPDATE_DB_TIME'		, width: 200	, hidden: true}				
		] 
    });  
    
    /** 공제내역 */
    var masterGrid2 = Unilite.createGrid('hpa330Grid2', {
		store	: masterStore2,
		uniOpt	: {
			useMultipleSorting	: true,			 
	    	useLiveSearch		: false,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: false,			
			expandLastColumn	: false,		
			useRowContext		: false,			
            userToolbar			: false,
	    	filter: {
				useFilter	: false,		
				autoCreate	: false		
			}
		},
    	features: [{id: 'masterGridTotal2', ftype: 'uniSummary', showSummaryRow: true}],
        columns: [        
        	{dataIndex: 'PAY_YYYYMM'			, width: 200	, hidden: true}, 				
        	{dataIndex: 'SUPP_TYPE'				, width: 200	, hidden: true},
        	{dataIndex: 'PERSON_NUMB'			, width: 200	, hidden: true},
        	{dataIndex: 'DED_CODE'				, width: 200	, hidden: true},
        	{dataIndex: 'WAGES_NAME'			, width: 200	, summaryRenderer: function(value){ return '합계'; }},
        	{dataIndex: 'DED_AMOUNT_I'			, flex:1		, summaryType:'sum'},
        	{dataIndex: 'COMP_CODE'				, width: 200	, hidden: true},
        	{dataIndex: 'UPDATE_DB_USER'		, width: 200	, hidden: true},
        	{dataIndex: 'UPDATE_DB_TIME'		, width: 200	, hidden: true}
		] 
    }); 
    
    //월근무 현황 그리드 (팝업)
    var masterGrid3 = Unilite.createGrid('hpa330Grid3', {
		store: masterStore3,
		uniOpt: {	
			useMultipleSorting	: true,		
		    useLiveSearch		: true,		
		    onLoadSelectFirst	: false,			
		    dblClickToEdit		: false,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: false,	
		    filter: {				
				useFilter		: true,
				autoCreate		: true
			}			
		},
        columns: [        
        	{dataIndex: 'CODE_NAME'			, width: 150},
        	{dataIndex: 'DUTY_NUM'			, width: 90},
        	{dataIndex: 'DUTY_TIME'			, flex: 1		, minWidth: 90}
		] 
    }); 

    
    
    /** 중간 영역 (지급내역, 공제내역, 오른쪽 PANEL */
	var mainPanel = Ext.create('Ext.panel.Panel', {
		id: 'hpa330ukrPanel',
		region : 'center',
		layout: {
		    type	: 'hbox',
		    align	: 'stretch',
		    pack	: 'start'
		},
		items:[
		    masterGrid,   
			masterGrid2,
			panelResult
	    ]
	});
    
	
	
	
	Unilite.Main( {
		id		: 's_hpa330ukrApp',
		items	: [{
			layout	: 'fit',
			flex	: 1,
			border	: false,
			items	: [{
				layout	:'border',
				border	: false,
				items	: [
					panelSearch, mainPanel, panelResult2
				]						
			}]
		}],

		fnInitBinding : function(params) {
//		 	Ext.getCmp('rdoSelect4').setValue({SPOUSE : 'Y'});
//		 	Ext.getCmp('rdoSelect5').setValue({TAX_RATE : '2'});
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			panelResult.setReadOnly(true);
			panelResult2.setReadOnly(true);

			panelSearch.onLoadSelectText('PAY_YYYYMM');		

			if(params && params.PGM_ID) {
				this.processParams(params);
			}
		},
		
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
				
			} else {			
				UniAppManager.app.fnInitBinding();  
				loadRecord('');
			}
		},
		
		onResetButtonDown: function() {
			Ext.getCmp('PERSON_NUMB').setReadOnly(false);
			Ext.getCmp('SUPP_TYPE').setReadOnly(false);
			Ext.getCmp('PAY_YYYYMM').setReadOnly(false);

			//검색조건 초기화
			panelSearch.getForm().setValues({'PAY_YYYYMM'	: UniDate.get('today')});
			panelSearch.getForm().setValues({'SUPP_TYPE'	: '1'});
			panelSearch.getForm().setValues({'PERSON_NUMB'	: ''});
			panelSearch.getForm().setValues({'NAME'			: ''});
			
			// data 초기화
			masterStore1.loadData([],false);
			masterStore2.loadData([],false);
			panelResult.getForm().getFields().each(function (field) {
				 field.setValue('');
			});
			panelResult2.getForm().getFields().each(function (field) {
				 field.setValue('');
			});
			UniAppManager.app.fnInitBinding();  
		},
		
		onPrevDataButtonDown: function() {
			console.log('Go Prev > ' + data[0].PV_D + 'NAME > ' + data[0].PV_NAME);
			loadRecord(data[0].PV_D, data[0].PV_NAME);				
		},
		
		onNextDataButtonDown: function() {
			console.log('Go Next > ' + data[0].NX_D + 'NAME > ' + data[0].NX_NAME);
			loadRecord(data[0].NX_D, data[0].NX_NAME);
		},
		
		onDeleteDataButtonDown : function()	{
			Ext.Msg.confirm('삭제', '삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					masterGrid.getStore().removeAll();
					masterGrid2.getStore().removeAll();
					UniAppManager.setToolbarButtons('save', true);	
				}
			});
		},
		
		onSaveDataButtonDown : function() {
			var searchParam = Ext.getCmp('searchForm').getValues();			
			// 수정이 가능한지 확인
			Ext.Ajax.request({
				url     : CPATH+'/z_kocis/checkUpdateAvailableHpa330.do',
				params	: searchParam,
				method	: 'get',
				success	: function(response){
					data = Ext.decode(response.responseText);
					console.log(data);
					//마감 되었을 경우,
 					if (data != "complete") {
//					if (data != "") {
 						alert(data);
						UniAppManager.app.onQueryButtonDown();  
 						return false;
 					}					
					
 					//수정이 가능할 경우 필수 체크
					if(!panelResult2.getInvalidMessage()) {
						return false;
					};
					
					fnSaveGridData(searchParam);
				},

				failure: function(response){
					console.log(response);
				}
			});
		},
		
        //링크로 넘어오는 params 받는 부분 (Agj100skr)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 's_hpa950skr_KOCIS') {
				panelSearch.setValue('PAY_YYYYMM'	,params.PAY_YYYYMM);
				panelSearch.setValue('SUPP_TYPE'	,params.SUPP_TYPE);
				panelSearch.setValue('PERSON_NUMB'	,params.PERSON_NUMB);
				panelSearch.setValue('NAME'			,params.NAME);
				
				panelResult.setValue('PAY_YYYYMM'	,params.PAY_YYYYMM);
				panelResult.setValue('SUPP_TYPE'	,params.SUPP_TYPE);
				panelResult.setValue('PERSON_NUMB'	,params.PERSON_NUMB);
				panelResult.setValue('NAME'			,params.NAME);
				loadRecord('');			
			}
			if(params.PGM_ID == 's_hpa350ukr_KOCIS') {
				panelSearch.setValue('PAY_YYYYMM'	,params.PAY_YYYYMM);
				panelSearch.setValue('SUPP_TYPE'	,params.SUPP_TYPE);
				panelSearch.setValue('PERSON_NUMB'	,params.PERSON_NUMB);
				panelSearch.setValue('NAME'			,params.NAME);
				
				panelResult.setValue('PAY_YYYYMM'	,params.PAY_YYYYMM);
				panelResult.setValue('SUPP_TYPE'	,params.SUPP_TYPE);
				panelResult.setValue('PERSON_NUMB'	,params.PERSON_NUMB);
				panelResult.setValue('NAME'			,params.NAME);
				loadRecord('');			
			}
        }
	});
	 
	 // 그리드 및 폼의 데이터를 불러옴
	 function loadRecord(person_numb, name) {
			// Prev, Next 데이터 검사
			checkAvailableNavi();
			
			
			//저장버튼 비활성화를 위한 변수 처리
			gsSaveButtonYn = 1;

		 	Ext.getCmp('PERSON_NUMB').setReadOnly(true);
		 	Ext.getCmp('SUPP_TYPE').setReadOnly(true);
			Ext.getCmp('PAY_YYYYMM').setReadOnly(true);
			Ext.getCmp('resultForm2').setReadOnly(true);
//			Ext.getCmp('rdoSelect1').setReadOnly(false);
//			Ext.getCmp('rdoSelect2').setReadOnly(false);
//			Ext.getCmp('rdoSelect3').setReadOnly(false);
			
//			masterGrid.setConfig('disabled', false);  
//			masterGrid2.setConfig('readOnly', true);  
			
			UniAppManager.setToolbarButtons('reset',true);
			
			masterStore1.loadStoreRecords(person_numb, name);				
			masterStore2.loadStoreRecords(person_numb, name);
			
			// TODO : Fix it!!
			
			panelResult.getForm().load({params : Ext.getCmp('searchForm').getValues(),
				 success: function(form, action){
				 	// 비과세 총액 계산 
				 	console.log(action);
				 	/*if (typeof action.result.data.TAX_EXEMPTION1_I !== 'undefined') {
				 		var totalTax = action.result.data.TAX_EXEMPTION1_I + action.result.data.TAX_EXEMPTION2_I + action.result.data.TAX_EXEMPTION3_I +
		 								action.result.data.TAX_EXEMPTION4_I + action.result.data.TAX_EXEMPTION5_I + action.result.data.TAX_EXEMPTION6_I;
		 				panelResult.getForm().setValues({ TAX_EXEMPTIONTOT_I : totalTax});
				 	}*/
				 },
				 failure: function(form, action) {
					// form reset
					 form.getFields().each(function (field) {
						 field.setValue('0');
				     });
				 }
				}
		    );
			panelResult2.getForm().load(
                {
                params : Ext.getCmp('searchForm').getValues(),
			    success: function(form, action){
				 	console.log(action);
			 		if (typeof action.result.data.TAX_EXEMPTION1_I !== 'undefined') {
					 	form.getFields().each(function (field) {
						      field.setReadOnly(true);
					    });	
			 		} else {
			 			//입사일, 퇴사일, 기본급 수정만 수정이 안되도록 설정
					 	form.getFields().each(function (field) {
						      field.setReadOnly(false);
					    });	
			 			form.getFields().each(function (field) {
			 				if (field.name == 'WAGES_STD_I' || field.name == 'JOIN_DATE' || field.name == 'RETR_DATE') {
			 					field.setReadOnly(true);
		 				}
				    });	
		 		}
			 		//배우자 유무, 세율기준, 부양자, 20세이하자녀 세팅
//				 	Ext.getCmp('rdoSelect4').setValue({SPOUSE : action.result.data.SPOUSE});
//				 	Ext.getCmp('rdoSelect5').setValue({TAX_RATE : action.result.data.TAXRATE_BASE});
//				 	Ext.getCmp('SUPP_NUM').setValue(action.result.data.SUPP_AGED_NUM);
//				 	Ext.getCmp('CHILD_20_NUM').setValue(action.result.data.CHILD_20_NUM);
					
				 	//급여지급일
				 	var suppDate = Ext.getCmp('SUPP_DATE').getValue();
				 	if (Ext.isEmpty('suppDate') || suppDate == null ) {
				 		suppDate = UniDate.getDbDateStr(Ext.getCmp('PAY_YYYYMM').getValue()).substring(0, 6) + '01'
 					 	Ext.getCmp('SUPP_DATE').setValue(suppDate);
				 	}
				 	//입사일
				 	var joinDate = Ext.getCmp('JOIN_DATE').getValue();
				 	//퇴사일
				 	var retrDate = Ext.getCmp('RETR_DATE').getValue();
				 	
				 	//입퇴사 구분 세팅
				 	if (retrDate == suppDate){
 					 	Ext.getCmp('EXCEPT_TYPE').setValue('3');
	
				 	} else if (joinDate == suppDate) {
 					 	Ext.getCmp('EXCEPT_TYPE').setValue('1');
				 		
				 	} else {
 					 	Ext.getCmp('EXCEPT_TYPE').setValue('0');
				 		
				 	}
				 },
				 failure: function(form, action) {
					 // 폼을 리셋 후 readOnly를 false 로 변경함
					 form.getFields().each(function (field) {
						 if (field.name == 'WAGES_STD_I' || field.name == 'ANU_BASE_I' || field.name == 'MED_AVG_I') {
//							 || field.name == 'CHILD_20_NUM'|| field.name == 'SUPP_NUM') {
							 field.setValue('0');
						 } else {
							 field.setValue('');							 
						 }
						 field.setReadOnly(false);
				     });
				 }
				}
		    );
			// Prev, Next 데이터 검사
			checkAvailableNavi();
	 }
	 
	// 선택된 사원의 전후로 데이터가 있는지 검색함
	function checkAvailableNavi(){
		var param = Ext.getCmp('searchForm').getValues();
		console.log(param);
		Ext.Ajax.request({
			url: CPATH+'/z_kocis/checkAvailableNaviHpa330.do',
			params: param,
			success: function(response){
				data = Ext.decode(response.responseText);
				console.log(data);
				var prevBtnAvailable = (data[0].PV_D == 'BOF' ? false : true)
				var nextBtnAvailable = (data[0].NX_D == 'EOF' ? false : true)
				UniAppManager.setToolbarButtons('prev', prevBtnAvailable);
				UniAppManager.setToolbarButtons('next', nextBtnAvailable);
			},
			failure: function(response){
				console.log(response);
			}
		});
	}
	
	// 전월의 급여를 복사함
	function copyPrevData() {
	 	Ext.getCmp('PERSON_NUMB').setReadOnly(true);
	 	Ext.getCmp('SUPP_TYPE').setReadOnly(true);
		Ext.getCmp('PAY_YYYYMM').setReadOnly(true);
		Ext.getCmp('resultForm2').setReadOnly(true);
		masterGrid.setConfig('readOnly', true);  
		masterGrid2.setConfig('readOnly', true);  
		UniAppManager.setToolbarButtons('reset',true);
			

		var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
		var date = new Date(payDate);
		date.setMonth(date.getMonth() - 1);
		var mon = date.getMonth() + 1;
		var preDate = date.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);
		
//		var date = Ext.getCmp('SUPP_DATE').getValue();
		var date = Ext.getCmp('PAY_YYYYMM').getValue();
		var mon = date.getMonth() + 1;
		var supp_date = date.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);
		
		var param = Ext.getCmp('searchForm').getValues();
		param.FR_PAY_YYYYMM = preDate;
		param.SUPP_DATE = supp_date;
		param.S_COMP_CODE = UserInfo.compCode;
		param.S_USER_ID = UserInfo.userID;
		console.log(param);
		
		Ext.Ajax.request({
			url: CPATH+'/z_kocis/copyPrevData.do',
			params: param,
			success: function(response){
				UniAppManager.setToolbarButtons('save', false);
				
				data = Ext.decode(response.responseText);
				console.log(data); 
				
				if (data.result.length == 0) {
					Ext.Msg.alert('확인', '전월의 급여 데이터가 없습니다');
					return false;
				} else {
					if (data.result[0].CLOSE_YN == '마감') {
						// TODO : disabled = true
					} else {
						// TODO : disabled = false
					}
				}
				//panelResult1, 2에 데이터 입력
				var record = data.result[0];
				/*panelResult.setValue('TAX_EXEMPTION6_I',	record.TAX_EXEMPTION6_I);
				panelResult.setValue('TAX_EXEMPTION4_I',	record.TAX_EXEMPTION4_I);
				panelResult.setValue('TAX_EXEMPTION1_I',	record.TAX_EXEMPTION1_I);
				panelResult.setValue('TAX_EXEMPTION5_I',	record.TAX_EXEMPTION5_I);
				panelResult.setValue('TAX_EXEMPTION2_I',	record.TAX_EXEMPTION2_I);
				panelResult.setValue('TAX_EXEMPTION3_I',	record.TAX_EXEMPTION3_I);
				panelResult.setValue('BUSI_SHARE_I',		record.BUSI_SHARE_I);
				panelResult.setValue('WORKER_COMPEN_I',		record.WORKER_COMPEN_I);
				panelResult.setValue('TAX_EXEMPTIONTOT_I',	(record.TAX_EXEMPTION1_I) + (record.TAX_EXEMPTION2_I) + (record.TAX_EXEMPTION3_I)
															+ (record.TAX_EXEMPTION4_I) + (record.TAX_EXEMPTION5_I) + (record.TAX_EXEMPTION6_I));
				panelResult.setValue('NON_TAX_I',			record.NON_TAX_I);
				panelResult.setValue('TAX_AMOUNT_I',		record.TAX_AMOUNT_I);*/
				panelResult.setValue('SUPP_TOTAL_I',		record.SUPP_TOTAL_I);
				panelResult.setValue('DED_TOTAL_I',			record.DED_TOTAL_I);
				panelResult.setValue('REAL_AMOUNT_I',		record.REAL_AMOUNT_I);

//				panelResult2.setValue('DEPT_CODE',			record.DEPT_CODE);
//				panelResult2.setValue('DEPT_NAME',			record.DEPT_NAME);
				panelResult2.setValue('PAY_CODE',			record.PAY_CODE);
				panelResult2.setValue('EXCEPT_TYPE',		record.EXCEPT_TYPE);
				panelResult2.setValue('ANU_BASE_I',			record.ANU_BASE_I);
				panelResult2.setValue('POST_CODE',			record.POST_CODE);
				panelResult2.setValue('PAY_PROV_FLAG',		record.PAY_PROV_FLAG);
				panelResult2.setValue('JOIN_DATE',			record.JOIN_DATE);
				panelResult2.setValue('MED_AVG_I',			record.MED_AVG_I);
				panelResult2.setValue('ABIL_CODE',			record.ABIL_CODE);
				panelResult2.setValue('TAX_CODE',			record.TAX_CODE);
//				panelResult2.setValue('SPOUSE',				record.SPOUSE);
				panelResult2.setValue('EMPLOY_TYPE',		record.EMPLOY_TYPE);
				panelResult2.setValue('WAGES_STD_I',		record.WAGES_STD_I);
				panelResult2.setValue('SUPP_DATE',			record.SUPP_DATE);
//				panelResult2.setValue('SUPP_NUM',			record.SUPP_NUM);
//				panelResult2.setValue('CHILD_20_NUM',		record.CHILD_20_NUM);
				panelResult2.setValue('TAXRATE_BASE',		record.TAXRATE_BASE);
//				panelResult2.setValue('TAX_RATE',			record.TAX_RATE);
				
				//지급 내역
				var records1 = [];
				Ext.each(data.result1, function(obj, i){
	                records1.push(obj);
	            });
				masterStore1.loadData(records1);
				
				//공제 내역
				var records2 = [];
				Ext.each(data.result2, function(obj, i){
	                records2.push(obj);
	            });
				masterStore2.loadData(records2);
				
			},
			failure: function(response){
				console.log(response);
			}
		});
	}
	
	// 월근무 현황 팝업을 표시함
	function openDutyRefWindow() {
		if (!dutyRefWindow) {
			dutyRefWindow = Ext.create('widget.uniDetailWindow', {
                title: '월근무현황',
                width: 380,				                
                height: 500,
                layout:{type:'vbox', align:'stretch'},
                items: [masterGrid3],
                tbar:  [{
					itemId : 'closeBtn',
					text: '닫기',
					handler: function() {
						dutyRefWindow.hide();
					},
					disabled: false
				}],
                listeners : {
                			 beforeshow: function ( me, eOpts )	{
                				 masterStore3.loadStoreRecords();
                			 }
                }
			});
		}
		dutyRefWindow.show();
	}


	function fnSaveGridData(searchParam) {
		//조회된 사원에 대한 데이터 모두 삭제 후, 현재 화면에 있는 데이터 INSERT
		//1. 지급내역 및 공제내역 삭제
		var delData		= panelSearch.getValues();
	    s_hpa330ukrService_KOCIS.deleteList1(delData, function(provider, response){
	    	
	    	//삭제인지 체크
            var toDelete = masterGrid.getStore().getRemovedRecords();
            if (!Ext.isEmpty(toDelete))  {
 				UniAppManager.updateStatus(Msg.sMB013);
                UniAppManager.setToolbarButtons('save', false);   
 				return false;
            }
	    	
			//2. 지급내역 등록 
			buttonStore.clearData();											//buttonStore 클리어
			var saveData1	= masterStore1.data.items; 
			Ext.each(saveData1, function(record, index) {
	            record.phantom 			= true;
	            buttonStore.insert(index, record);
				
				if (saveData1.length == index +1) {
	                buttonStore.saveStore(searchParam);
				}
			});
			
/*			//form02 submit
			var param = panelResult2.getValues();
			param.PAY_YYYYMM = dateString;
			param.SUPP_TYPE = searchParam.SUPP_TYPE;
			param.PERSON_NUMB = searchParam.PERSON_NUMB;
	
			panelResult2.getForm().submit({
				 params : param,
				 success : function(actionform, action) {
					 	panelResult2.getForm().wasDirty = false;
//					 	panelResult2.resetDirtyStatus();		alert('form02 done');									
//						UniAppManager.setToolbarButtons('save', false);	
//	            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
				 }	
			});*/
		});
	}

};

</script>
