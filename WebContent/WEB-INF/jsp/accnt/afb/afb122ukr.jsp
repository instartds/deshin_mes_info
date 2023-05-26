<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb122ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb122ukr"/> 				<!-- 사업장		-->
	<t:ExtComboStore comboType="AU" comboCode="A025" /> 					<!-- 구분			--> 
	<t:ExtComboStore comboType="AU" comboCode="J682" /> 					<!-- 결재상태		-->
</t:appConfig>
<script type="text/javascript" >

var gsChargeCode = '${getChargeCode}';

function appMain() {
/** type:
	 * 		uniQty		   -      수량
	 *		uniUnitPrice   -      단가
	 *		uniPrice	   -      금액(자사화폐)
	 *		uniPercent	   -      백분율(00.00)
	 *		uniFC          -      금액(외화화폐)
	 *		uniER          -      환율
	 *		uniDate        -      날짜(2999.12.31)
	 * maxLength: 입력가능한 최대 길이
	 * editable: true	수정가능 여부
	 * allowBlank: 필수 여부
	 * defaultValue: 기본값
	 * comboType:'AU', comboCode:'B014' : 그리드 콤보 사용시
*/
	
   /* Model 정의 
    * @type 
    */
	Unilite.defineModel('Afb122ukrModel', {
		fields: [
			{name: 'RNUM'         		,text: 'NO'         ,type: 'string', editable: false},
            {name: 'DOC_STATUS'         , text: '결재상태'          , type: 'string'    , editable: false       , comboType: 'AU'       , comboCode: 'J682'},
            {name: 'DOC_STATUS_DETAIL'  ,text: '결재상태_REF_CODE1' ,type: 'string'},
			{name: 'DOC_ID'				, text: '순번'				, type: 'string' },
			{name: 'COMP_CODE'			, text: '법인'				, type: 'string' },
			{name: 'INPUT_DATE'			, text: '신청일자'			, type: 'uniDate' },
			{name: 'ACCNT'				, text: '계정과목'			, type: 'string'	, allowBlank: false },
			{name: 'ACCNT_NAME'			, text: '계정과목명'		, type: 'string'	, allowBlank: false },
			{name: 'DEPT_CODE'			, text: '부서'				, type: 'string' 	, editable: false },
			{name: 'DEPT_NAME'			, text: '부서명'			, type: 'string' 	, editable: false },
			{name: 'BUDG_YYYYMM'		, text: '예산년월'			, type: 'string'	, editable: false   , allowBlank: false },
			{name: 'DIVERT_YYYYMM'		, text: '예산년월(To)'		, type: 'string'	, allowBlank: false },
			{name: 'DIVERT_DIVI'		, text: '구분'				, type: 'string' 	, comboType: 'AU'		, comboCode: 'A025'},
			{name: 'DIVERT_ACCNT'		, text: '전용계정'			, type: 'string' },
			{name: 'DIVERT_ACCNT_NAME'	, text: '전용계정명'		, type: 'string' },
			{name: 'DIVERT_DEPT_CODE'	, text: '전용부서코드'		, type: 'string' },
			{name: 'DIVERT_DEPT_NAME'	, text: '전용부서명'		, type: 'string' },
			{name: 'DIVERT_BUDG_I'		, text: '추가금액'			, type: 'uniPrice' , allowBlank: false },
			{name: 'POSSIBLE_BUDG_AMT'	, text: '예산잔액'			, type: 'uniPrice', editable: false },
			{name: 'REMARK'				, text: '신청사유'			, type: 'string'  , allowBlank: false},
			{name: 'DIVERT_SMT_NUM'		, text: '예산추경신청번호'	, type: 'string', editable: false },
			{name: 'APPR_LINE'			, text: '결재라인'			, type: 'string', editable: false },
			{name: 'RETURN_MSG'			, text: '부결메시지'		, type: 'string', editable: false },
			{name: 'INSERT_DB_USER'		, text: '입력자'			, type: 'string' },
			{name: 'INSERT_DB_TIME'		, text: '입력일'			, type: 'uniDate'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'			, type: 'string' },
			{name: 'UPDATE_DB_TIME'		, text: '수정일'			, type: 'uniDate'},
			{name: 'TEMPC_01'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPC_02'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPC_03'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPN_01'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPN_02'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPN_03'			, text: '여유컬럼'			, type: 'string' }
		]
	});
  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'afb122ukrService.insertList',				
			read	: 'afb122ukrService.selectList',
			update	: 'afb122ukrService.updateList',
			destroy	: 'afb122ukrService.deleteList',
			syncAll	: 'afb122ukrService.saveAll'
		}
	});
	
	var directProxyRequest = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'afb122ukrService.insertDetailRequest',
            syncAll: 'afb122ukrService.saveAllRequest'
        }
    }); 

    
   /* Store 정의(Service 정의)
    * @type 
    */               
	var masterStore = Unilite.createStore('afb122ukrMasterStore',{
		model	: 'Afb122ukrModel',
		uniOpt	: {
			isMaster	: true,         // 상위 버튼 연결 
			editable	: true,         // 수정 모드 사용 
			deletable	: true,         // 삭제 가능 여부 
			useNavi		: false         // prev | newxt 버튼 사용
		},
        autoLoad	: false,
        proxy		: directProxy,
		listeners	: {
	        load : function(store) {
	        	
	        }
	    },
	    
	    loadStoreRecords : function()   {
            var param= panelSearch.getValues();	
        	this.load({
               params : param
            });
        },
        
        saveStore	: function()	{				
			var inValidRecs = this.getInvalidRecords();	
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		
//			DIVERT_DIVI에 따른 필수 체크
        	var list = [].concat(toUpdate,toCreate);
        	if(fnCheckReqiured(list)) return false;
			
			if(inValidRecs.length == 0 )	{
				config = {
					success: function(batch, option) {
						UniAppManager.app.onQueryButtonDown();
					 } 
				};
				this.syncAllDirect(config);				
			}else {    				
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners	: {
			load: function(store, records, successful, eOpts) {
				
           	}				
		}			
   });
   
    var requestStore = Unilite.createStore('Abh220ukrRequestStore',{      
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyRequest,
        saveStore: function() {             
            
            var paramMaster = panelResult.getValues(); 
//          param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
            config = {
                params: [paramMaster],
                success: function(batch, option) {
                    var master = batch.operations[0].getResultSet();
                    
                    UniAppManager.app.onQueryButtonDown();
                    
                },
                failure: function(batch, option) {
                 
                    
                }
            };
            this.syncAllDirect(config);
        }
    });

    
   /* 검색조건 (Search Panel)
    * @type 
    */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',		
        defaultType	: 'uniSearchSubPanel',
        collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
//	        collapse: function () {
//	        	panelResult.show();
//	        },
//	        expand: function() {
//	        	panelResult.hide();
//	        }
	    },
		items		: [{	
			title	: '기본검색', 	
   			itemId	: 'search_panel1',
           	layout	: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items	: [/*{
					fieldLabel		: '예산년월',
		            xtype			: 'uniMonthRangefield',
		            startFieldName	: 'BUDG_YYYYMM_FR',
		            endFieldName	: 'BUDG_YYYYMM_TO',
		            startDate		: UniDate.get('today'),
		            endDate			: UniDate.get('today'),
		            allowBlank		: false,                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('BUDG_YYYYMM_FR', newValue);						
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('BUDG_YYYYMM_TO', newValue);				    		
				    	}
				    }
		     	}*/{ 
	    			fieldLabel: '예산년월',
			        xtype: 'uniMonthfield',	
			        value: new Date().getFullYear(),
			        name: 'BUDG_YYYYMM',
			        allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BUDG_YYYYMM', newValue);
							//UniAppManager.app.fnSetStDate(newValue);
							//UniAppManager.app.fnSetToDate(newValue);
						}
					}
		        },
	     	Unilite.popup('DEPT', {
				fieldLabel		: '부서', 
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME', newValue);				
					},
					applyextparam: function(popup){	
						
					}
				}
			}),
			Unilite.popup('Employee',{ 
				fieldLabel		: '작성자',
	//	    	validateBlank	: false,	    			
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
		    }),
			Unilite.popup('ACCNT',{
		    	fieldLabel		: '계정과목',
		    	validateBlank	: false,	    			
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_NAME', newValue);				
					},
					applyextparam: function(popup){
						popup.setExtParam({ 'ADD_QUERY': "BUDG_YN = 'Y' AND BUDGADD_YN = 'Y' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'" });			//WHERE절 추카 쿼리						
//							popup.setExtParam({'CHARGE_CODE': gsChargeCode});				//bParam(3)
					}
				}
		    }), {
				fieldLabel	: '구분',
				name		: 'DIVERT_DIVI',	
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'A025',
				hidden 		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIVERT_DIVI', newValue);
					}
				}
			},{
				fieldLabel	: '결재상태',
				name		: 'DOC_STATUS',	
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'J682',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DOC_STATUS', newValue);
					}
				}
			},{ 
    			fieldLabel: '신청일자',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'DATE_FR',
		        endFieldName: 'DATE_TO',           	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DATE_TO',newValue);
			    	}
			    }
	        }]
		}]     	
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		padding	: '1 1 1 1',
		border	: true,
    	hidden	: !UserInfo.appOption.collapseLeftSearch,
    	items	: [/*{
					fieldLabel		: '예산년월',
		            xtype			: 'uniMonthRangefield',
		            startFieldName	: 'BUDG_YYYYMM_FR',
		            endFieldName	: 'BUDG_YYYYMM_TO',
		            startDate		: UniDate.get('today'),
		            endDate			: UniDate.get('today'),
		            tdAttrs			: {width: 380},
		            allowBlank		: false,  
		            onStartDateChange: function(field, newValue, oldValue, eOpts) {
		            	if(panelSearch) {
							panelSearch.setValue('BUDG_YYYYMM_FR', newValue);						
		            	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelSearch) {
				    		panelSearch.setValue('BUDG_YYYYMM_TO', newValue);				    		
				    	}
				    }
		     	}*/{ 
	    			fieldLabel: '예산년월',
			        xtype: 'uniMonthfield',	
			        value: new Date().getFullYear(),
			        name: 'BUDG_YYYYMM',
			        allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('BUDG_YYYYMM', newValue);
							//UniAppManager.app.fnSetStDate(newValue);
							//UniAppManager.app.fnSetToDate(newValue);
						}
					}
		        },
     	Unilite.popup('DEPT', {
			fieldLabel		: '부서', 
			colspan			: 2,
			tdAttrs			: {width: 380},
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);				
				},
				applyextparam: function(popup){	
					
				}
			}
		}),
		Unilite.popup('Employee',{
			fieldLabel		: '작성자',	
			tdAttrs			: {width: 380},
//	    	validateBlank	: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
				},
				applyextparam: function(popup){
					
				}
			}
	    }),
		Unilite.popup('ACCNT',{
	    	fieldLabel		: '계정과목',	
	    	tdAttrs			: {width: 380},
	    	colspan			: 2,
	    	validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME', newValue);				
				},
				applyextparam: function(popup){
					popup.setExtParam({ 'ADD_QUERY': "BUDG_YN = 'Y' AND BUDGADD_YN = 'Y' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'" });			//WHERE절 추카 쿼리						
//							popup.setExtParam({'CHARGE_CODE': gsChargeCode});				//bParam(3)
				}
			}
	    }), {
			fieldLabel	: '구분',
			name		: 'DIVERT_DIVI',	
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'A025',
			hidden 		: true,
			tdAttrs		: {width: 380},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIVERT_DIVI', newValue);
				}
			}
		},{
			fieldLabel	: '결재상태',
			name		: 'DOC_STATUS',	
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'J682',
			tdAttrs		: {width: 380},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DOC_STATUS', newValue);
				}
			}
		},{ 
			fieldLabel: '신청일자',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'DATE_FR',
	        endFieldName: 'DATE_TO',           	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('DATE_TO',newValue);
		    	}
		    }
        }]
    });

    
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('afb122ukrGrid', {
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			useMultipleSorting	: false, 	//정렬 버튼 사용 여부
    		useLiveSearch		: false,	//내용검색 버튼 사용 여부
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: true,
        	useGroupSummary		: false,	//그룹핑 버튼 사용 여부
        	useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: false,
		 	copiedRow			: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			},
			state: {
 				useState		: true,		//그리드 설정 버튼 사용 여부
 				useStateList	: true		//그리드 설정 목록 사용 여부
			}
        },
		features: [{
			id		: 'masterGridSubTotal',
			ftype	: 'uniGroupingsummary',
			showSummaryRow: false						
		},{
			id		: 'masterGridTotal',
			ftype	: 'uniSummary',
			showSummaryRow: false
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly		: true, 
			toggleOnClick	: false,
    		listeners		: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				},

				deselect:  function(grid, selectRecord, index, eOpts ){
				}
			}
		}),
		tbar: [{
            xtype: 'button',
            text: '결재요청',   
            id: 'btnRequest',
            name: '',
            width: 80,  
//          disabled:true,
            handler : function() {
                var selectedRecords = masterGrid.getSelectedRecords();
                
                if(!Ext.isEmpty(selectedRecords)){
                    if(confirm('선택한 예산전용신청입력내역을 결재요청 처리하시겠습니까?')) { 
                        var sm = masterGrid.getSelectionModel();
                        var selRecords = masterGrid.getSelectionModel().getSelection();
                        Ext.each(selectedRecords, function(record,i){
                            if(record.get('DOC_STATUS_DETAIL') != '10'){
                                alert(record.get('RNUM') + "번째 예산전용신청입력내역은 확정 상태가 아니거나 입력상태가 아닙니다.\n 확정 상태이면서 입력상태인 데이터만 결재요청이 가능합니다.");

                                sm.deselect(selRecords[i]);
                            }
                        });
                        
                        var newSelectedRecords = masterGrid.getSelectedRecords();
                        
                        if(!Ext.isEmpty(newSelectedRecords)){
                            requestStore.clearData();
                            Ext.each(newSelectedRecords, function(record,i){
                                record.phantom = true;
                                requestStore.insert(i, record);
                            });
                            
                            requestStore.saveStore(); 
                            
                        }else{
                            Ext.Msg.alert('확인','결재요청 처리할 데이터를 선택해 주세요.');
                        }
                    }else{
                       return false;    
                    }
                }else{
                    Ext.Msg.alert('확인','결재요청 처리할 데이터를 선택해 주세요.');
                }
            }
        },'->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->'
        ],
        columns: [
        	{ dataIndex: 'RNUM'                    ,width:40,align:'center'},
            {dataIndex: 'DOC_STATUS'            , width: 100},
            { dataIndex: 'DOC_STATUS_DETAIL'    ,width:100, hidden:true},
        	{dataIndex: 'DOC_ID'				, width: 100		, hidden: true },
        	{dataIndex: 'COMP_CODE'				, width: 100		, hidden: true },
        	{dataIndex: 'DIVERT_DIVI'			, width: 100		, hidden: true }, 
        	{dataIndex: 'DEPT_CODE'				, width: 60},
        	{dataIndex: 'DEPT_NAME'				, width: 130},
        	{dataIndex: 'INPUT_DATE'			, width: 100},
        	{dataIndex: 'ACCNT'     			, width: 110		, 
			  	editor: Unilite.popup('ACCNT_G', {
			  		autoPopup: true,
    				DBtextFieldName: 'ACCNT_CODE',
	 				listeners: {'onSelected': {
							fn: function(records, type) {
			                    console.log('records : ', records);
			                    var grdRecord = masterGrid.uniOpt.currentRecord;
			                    Ext.each(records, function(record,i) {	
									grdRecord.set('ACCNT', record['ACCNT_CODE']);
									grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
								}); 
								//예산잔액 컬럼 값을 가져옴
								var params = {
									S_COMP_CODE  : UserInfo.compCode, 
									BUDG_YYYYMM  : grdRecord.get('BUDG_YYYYMM'),
									DEPT_CODE    : grdRecord.get('DEPT_CODE'),
									DIVERT_ACCNT : grdRecord.get('ACCNT')
							
								}												
								afb122ukrService.getPosBudgAmt(params, function(provider, response)	{							
									if(!Ext.isEmpty(provider)){
										grdRecord.set('POSSIBLE_BUDG_AMT', provider);
									}													
								});								
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NAME', '');
							grdRecord.set('POSSIBLE_BUDG_AMT', ''); 
						},
						applyextparam: function(popup){
							popup.setExtParam({ 'ADD_QUERY': "BUDG_YN = 'Y' AND BUDGADD_YN = 'Y' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'" });			//WHERE절 추카 쿼리						
//							popup.setExtParam({'CHARGE_CODE': gsChargeCode});				//bParam(3)
						}
					}
				 }) 
			}, 				
			{dataIndex: 'ACCNT_NAME'			, width: 150		, 				
			  	editor: Unilite.popup('ACCNT_G', {
			  		autoPopup: true,
	 				listeners: {'onSelected': {
							fn: function(records, type) {
			                    console.log('records : ', records);
			                    var grdRecord = masterGrid.uniOpt.currentRecord;
			                    Ext.each(records, function(record,i) {	
									grdRecord.set('ACCNT', record['ACCNT_CODE']);
									grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
								}); 
								//예산잔액 컬럼 값을 가져옴
								var params = {
									S_COMP_CODE  : UserInfo.compCode, 
									BUDG_YYYYMM  : grdRecord.get('BUDG_YYYYMM'),
									DEPT_CODE    : grdRecord.get('DEPT_CODE'),
									DIVERT_ACCNT : grdRecord.get('ACCNT')
							
								}												
								afb122ukrService.getPosBudgAmt(params, function(provider, response)	{							
									if(!Ext.isEmpty(provider)){
										grdRecord.set('POSSIBLE_BUDG_AMT', provider);
									}													
								});									
							},
								scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NAME', '');
							grdRecord.set('POSSIBLE_BUDG_AMT', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({ 'ADD_QUERY': "BUDG_YN = 'Y' AND BUDGADD_YN = 'Y' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'" });			//WHERE절 추카 쿼리	
//							popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
						}
					}
				 }
			)},
        	{dataIndex: 'BUDG_YYYYMM'			, width: 100		, align: 'center'
        		/*,renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(!Ext.isEmpty(val)){
						return  val.substring(0,4) + '.' + val.substring(4,6);
					}
                }*/
            },
        	{dataIndex: 'DIVERT_YYYYMM'			, width: 100		, align: 'center'		, hidden: true	
        		/*,renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(!Ext.isEmpty(val)){
						return  val.substring(0,4) + '.' + val.substring(4,6);
                	}
				}*/
            },
        	{dataIndex: 'DIVERT_DEPT_CODE'		, width: 120		, hidden: true},
            {dataIndex: 'DIVERT_ACCNT'     		, width: 100		, hidden: true,
			  	editor: Unilite.popup('ACCNT_G', {
			  		autoPopup: true,
    				DBtextFieldName: 'ACCNT_CODE',
	 				listeners: {'onSelected': {
							fn: function(records, type) {
			                    console.log('records : ', records);
			                    var grdRecord = masterGrid.uniOpt.currentRecord;
			                    Ext.each(records, function(record,i) {	
									grdRecord.set('DIVERT_ACCNT', record['ACCNT_CODE']);
									grdRecord.set('DIVERT_ACCNT_NAME', record['ACCNT_NAME']);
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('DIVERT_ACCNT', '');
							grdRecord.set('DIVERT_ACCNT_NAME', '');
							grdRecord.set('POSSIBLE_BUDG_AMT', '');
						}/*,
						applyextparam: function(popup){
							popup.setExtParam({ 'ADD_QUERY': "BUDG_YN = 'Y' AND BUDGADD_YN = 'Y' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'" });			//WHERE절 추카 쿼리						
//							popup.setExtParam({'CHARGE_CODE': gsChargeCode});				//bParam(3)
						}*/
					}
				 }) 
			}, 				
			{dataIndex: 'DIVERT_ACCNT_NAME'		, width: 150		, hidden: true,				
			  	editor: Unilite.popup('ACCNT_G', {
			  		autoPopup: true,
	 				listeners: {'onSelected': {
							fn: function(records, type) {
			                    console.log('records : ', records);
			                    var grdRecord = masterGrid.uniOpt.currentRecord;
			                    Ext.each(records, function(record,i) {	
									grdRecord.set('DIVERT_ACCNT', record['ACCNT_CODE']);
									grdRecord.set('DIVERT_ACCNT_NAME', record['ACCNT_NAME']);
								}); 								
							},
								scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('DIVERT_ACCNT', '');
							grdRecord.set('DIVERT_ACCNT_NAME', '');
							grdRecord.set('POSSIBLE_BUDG_AMT', '');
						}/*,
						applyextparam: function(popup){
							popup.setExtParam({ 'ADD_QUERY': "BUDG_YN = 'Y' AND BUDGADD_YN = 'Y' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'" });			//WHERE절 추카 쿼리						
//							popup.setExtParam({'CHARGE_CODE': gsChargeCode});				//bParam(3)
						}*/
					}
				 }
			)},
        	{dataIndex: 'DIVERT_BUDG_I'			, width: 120},
        	{dataIndex: 'POSSIBLE_BUDG_AMT'		, width: 120},
        	{dataIndex: 'REMARK'				, width: 180},
        	{dataIndex: 'DIVERT_SMT_NUM'		, width: 110},
        	{dataIndex: 'APPR_LINE'				, width: 260},
        	{dataIndex: 'RETURN_MSG'			, width: 190}    	
        ],
        listeners: {
        	beforeedit: function(editor, e){
				if(e.record.data.DOC_STATUS == '10'){
					if(UniUtils.indexOf(e.field, ['ACCNT','ACCNT_NAME','DIVERT_ACCNT','DIVERT_ACCNT_NAME','DIVERT_BUDG_I','REMARK'])){
			      		return true;
			    	} /*else {
			    		return false; 
			    	}*/	
				} else {
					return false;
				}
				
/*        		if(!e.record.phantom){
        			if(e.field == 'DIVERT_ACCNT' || e.field == 'DIVERT_ACCNT_NAME'){				//전용계정은 아래 조건에서 입력 못 함
        				if (e.record.data.DIVERT_DIVI == '2' || e.record.data.DIVERT_DIVI == '3') {	//구분이 "초과신청" 또는 "이월신청" 일 때,
	        				return false;
        				}
	        		}
        		}  */      		
        	}, 
        	edit: function(editor, e) {
        		var fieldName = e.field;
        		if(fieldName == 'BUDG_YYYYMM'){
        			if(e.value.length != 6 || isNaN(e.value)){
        				e.record.set(fieldName, '');
        			}
        			
        		} else if(fieldName == 'DIVERT_YYYYMM'){
        			if(e.value.length != 6 || isNaN(e.value)){
        				e.record.set(fieldName, '');
        			}
        		}
			}
    	}
    });
   
   
    Unilite.Main( {
		id			: 'afb122ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
		panelSearch
		], 
		fnInitBinding : function() {
//			panelSearch.setValue('DATE_FR', UniDate.get('today'));
//			panelSearch.setValue('DATE_TO', UniDate.get('today'));
//			panelResult.setValue('DATE_FR', UniDate.get('today'));
//			panelResult.setValue('DATE_TO', UniDate.get('today'));			
			
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			if(Ext.isEmpty(gsChargeCode)){	//회계담당자가 아닐시
				panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
				panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
				panelResult.setValue('DEPT_NAME', UserInfo.deptName);
				panelResult.setValue('DEPT_CODE', UserInfo.deptCode);			
				
				panelSearch.getField('DEPT_CODE').setReadOnly(true);
				panelSearch.getField('DEPT_NAME').setReadOnly(true);
				panelResult.getField('DEPT_CODE').setReadOnly(true);
				panelResult.getField('DEPT_NAME').setReadOnly(true);
			}
			
			panelSearch.setValue('BUDG_YYYYMM', UniDate.get('today'));
			panelResult.setValue('BUDG_YYYYMM', UniDate.get('today'));
			

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BUDG_YYYYMM');
			
		},
		
		onQueryButtonDown : function()	{				
			if(!this.isValidSearchForm()){			//조회전 필수값 입력 여부 체크	
				return false;			
			}	
			
	      	masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);
		},					
		
		onNewDataButtonDown : function() {	
			var r = {				
				DOC_STATUS		: '10',
				DIVERT_DIVI		: '2',
				INPUT_DATE		: UniDate.get('today'),
				DEPT_CODE		: UserInfo.deptCode,                                                 
				DIVERT_DEPT_CODE: UserInfo.deptCode,                                          
				DEPT_NAME		: UserInfo.deptName,
				BUDG_YYYYMM		: UniDate.getDbDateStr(panelSearch.getValue('BUDG_YYYYMM')).substring(0, 6),
				DIVERT_YYYYMM	: UniDate.getDbDateStr(panelSearch.getValue('BUDG_YYYYMM')).substring(0, 6)
				//BUDG_YYYYMM		: UniDate.get('today'),
				//DIVERT_YYYYMM	: UniDate.get('today')
			};
			//masterGrid.createRow(r, 'GW_STATUS');
			masterGrid.createRow(r, 'DOC_STATUS');
		},
		
		onSaveDataButtonDown : function() {
			if (masterGrid.getStore().isDirty()) {
				masterGrid.getStore().saveStore();
			}
		},										
										
		onDeleteDataButtonDown : function()	{							
			var selRow = masterGrid.getSelectedRecord();							
			if(selRow.phantom == true)	{						
				masterGrid.deleteSelectedRow();						
										
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")		
					masterGrid.deleteSelectedRow();					
			}							
		},								
		
		onResetButtonDown : function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();										
			this.fnInitBinding();;
		}
   });
   
	function fnCheckReqiured(records) {					//DIVERT_DIVI 값에 따른 필수컬럼 체크 로직
        var isErr = false;
		Ext.each(records, function(record, index){
			var alertMessage = '';
        	if(record.get('DIVERT_DIVI') == '1') {								//구분이 "계정이동"일 때,
	    		if  (Ext.isEmpty(record.get('ACCNT'))){							//원계정
					alertMessage = alertMessage + ' 원계정';
					isErr = true;
	    		}
	    		if  (Ext.isEmpty(record.get('DIVERT_ACCNT'))){					//전용계정
					alertMessage = alertMessage + ' 전용계정';
					isErr = true;
	    		}
	    		if  (Ext.isEmpty(record.get('BUDG_YYYYMM'))){					//예산년월(Fr)
					alertMessage = alertMessage + ' 예산년월';
					isErr = true;
	    		}
	    		if  (Ext.isEmpty(record.get('DIVERT_BUDG_I'))){					//금액
					alertMessage = alertMessage + ' 금액';
					isErr = true;
	    		}
	    		if  (Ext.isEmpty(record.get('REMARK'))){						//신청사유
					alertMessage = alertMessage + ' 신청사유';
					isErr = true;
	    		}
	    		
        		if (Ext.isEmpty(alertMessage)) {
        			isErr = false;
        			return false;
        		} else {
        			alert ((index+1) + '행의' + alertMessage + ' 은(는) 필수 입력항목 입니다.')
					return false;
        		}

        		
        	} else if ( record.get('DIVERT_DIVI') == '2' ||
        				record.get('DIVERT_DIVI') == '3') {						//구분이 "초과신청" 또는 "이월신청" 일 때,
	    		if  (Ext.isEmpty(record.get('ACCNT'))){							//원계정
					alertMessage = alertMessage + ' 원계정';
					isErr = true;
	    		}
	    		if  (Ext.isEmpty(record.get('BUDG_YYYYMM'))){					//예산년월(Fr)
					alertMessage = alertMessage + ' 예산년월(Fr)';
					isErr = true;
	    		}
	    		if  (Ext.isEmpty(record.get('DIVERT_YYYYMM'))){					//예산년월(To)
					alertMessage = alertMessage + ' 예산년월(To)';
					isErr = true;
	    		}
	    		if  (Ext.isEmpty(record.get('DIVERT_BUDG_I'))){					//금액
					alertMessage = alertMessage + ' 금액';
					isErr = true;
	    		}
	    		if  (Ext.isEmpty(record.get('REMARK'))){						//신청사유
					alertMessage = alertMessage + ' 신청사유';
					isErr = true;
	    		}
	    		
        		if (Ext.isEmpty(alertMessage)) {
        			isErr = false;
        			return false;
        		} else {
        			alert ((index+1) + '행의' + alertMessage + ' 은(는) 필수 입력항목 입니다.')
					return false;
        		}
			}
		});
  		return isErr;					//필수값이 입력이 안 되었으면 위에서 메세지 출력 후 return true, 입력이 되었으면 return false
	}; 

	
	Unilite.createValidator('validator01', {
		store: masterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				/*case "CUSTOM_CODE" :		// 거래처
					if(record.get('ITEM_CODE') == '') {
						rv= Msg.sMS003;	
						break;
					}
				break;
				
				case "CUSTOM_NAME" :		// 거래처
					if(record.get('ITEM_NAME') == '') {
						rv= Msg.sMS003;	
						break;
					}
				break;*/
				
//				case "DIVERT_BUDG_I" :
//					var divertBudg_i = record.get('POSSIBLE_BUDG_AMT');	//전용가능금액
//
//					if(newValue > divertBudg_i){	//전용가능금액
//						rv = "추가금액은 예산잔액을 초과할 수 없습니다.";
//					}
//				break;
			}
			return rv;
		}
	})	

};


</script>