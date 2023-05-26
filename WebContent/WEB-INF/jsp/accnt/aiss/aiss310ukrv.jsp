<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="aiss310ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A042" /> 			<!-- 자산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B002" />				<!-- 법인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B012" />				<!-- 국가코드 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> 			<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A035" /> 			<!-- 완료구분 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var excelWindow; 			//업로드 윈도우 생성
	var newYN	= 0;			//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다 (중복수행 방지를 위해 panelResult에서만 처리)
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'aiss310ukrvService.selectList',
			update	: 'aiss310ukrvService.updateList',
			create	: 'aiss310ukrvService.insertList',
			destroy	: 'aiss310ukrvService.deleteList',
			syncAll	: 'aiss310ukrvService.saveAll'
		}
	});	

	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'aiss310ukrvService.runProcedure',
            syncAll	: 'aiss310ukrvService.callProcedure'
		}
	});	

	Unilite.defineModel('Aiss310ukrvModel', {
	    fields: [
			{name: 'DOC_ID'					,text: '자동채번'			,type: 'string'},
			{name: 'APPLY_YN'				,text: '자산반영여부'		,type: 'string'},
			{name: 'ASST'					,text: '자산코드'			,type: 'string'},
			{name: 'ASST_NAME'				,text: '자산명'			,type: 'string'		, allowBlank: false},
			{name: 'SPEC' 					,text: '규격'				,type: 'string'},
			{name: 'SERIAL_NO' 				,text: '일련번호'			,type: 'string'},
			{name: 'ASST_DIVI' 				,text: '자산구분'			,type: 'string'     , comboType: 'AU'       , comboCode: 'A042'}, //자산구분(1:자산, 2:부외자산)(추가)
			{name: 'ACCNT' 					,text: '계정코드'			,type: 'string'		, allowBlank: false},
			{name: 'DIV_CODE' 				,text: '사업장코드'		,type: 'string'		, allowBlank: false    , comboType:'BOR120'},
			{name: 'DEPT_CODE' 				,text: '사용부서코드'		,type: 'string'		, allowBlank: false},
			{name: 'DEPT_NAME' 				,text: '사용부서명'		,type: 'string'},
			{name: 'PURCHASE_DEPT_CODE' 	,text: '구입부서코드'		,type: 'string'},
			{name: 'PURCHASE_DEPT_NAME' 	,text: '구입부서명'		,type: 'string'},
			
			{name: 'DRB_YEAR' 				,text: '내용년수'			,type: 'int'		, allowBlank: false},
			{name: 'MONEY_UNIT' 			,text: '화폐단위'			,type: 'string'/*		, comboType: 'AU'		, comboCode: 'B004'*/},
			{name: 'EXCHG_RATE_O' 			,text: '환율'				,type: 'uniER'},
			{name: 'FOR_ACQ_AMT_I'			,text: '외화취득가액'		,type: 'uniFC'},
			{name: 'ACQ_AMT_I' 				,text: '취득가액'			,type: 'uniPrice'	, allowBlank: false},
			{name: 'ACQ_Q' 					,text: '수량'				,type: 'uniQty'		, allowBlank: false},
			{name: 'QTY_UNIT' 				,text: '단위'				,type: 'string'		, allowBlank: false, comboType:'AU', comboCode:'B013'},
			{name: 'ACQ_DATE' 				,text: '취득일'			,type: 'uniDate'	, allowBlank: false},
			
			{name: 'PERSON_NUMB'			,text: '사번'				,type: 'string'},
			{name: 'PLACE_INFO'				,text: '위치정보'			,type: 'string'},
			{name: 'CUSTOM_CODE'			,text: '구입처코드'		,type: 'string'},
			{name: 'CUSTOM_NAME'			,text: '구입처명'			,type: 'string'},
			{name: 'PJT_CODE'				,text: '사업코드'			,type: 'string'},
			{name: 'MAKER_NAME'				,text: '제조사명'			,type: 'string'},
			{name: 'REMARK'					,text: '적요'				,type: 'string'},
			{name: 'SALE_MANAGE_COST'		,text: '판관'				,type: 'uniPercent'},
			{name: 'SALE_MANAGE_DEPT_CODE'  ,text: '판관귀속부서코드'	,type: 'string'	},
			{name: 'SALE_MANAGE_DEPT_NAME'  ,text: '판관귀속부서명'		,type: 'string'	},
			{name: 'PRODUCE_COST'			,text: '제조'				,type: 'uniPercent'},
			{name: 'PRODUCE_DEPT_CODE' 		,text: '제조귀속부서코드'	,type: 'string'	},
			{name: 'PRODUCE_DEPT_NAME' 		,text: '제조귀속부서명'		,type: 'string'	},
			{name: 'SALE_COST'				,text: '경상'				,type: 'uniPercent'},
			{name: 'SALE_DEPT_CODE' 		,text: '경상귀속부서코드'	,type: 'string'	},
			{name: 'SALE_DEPT_NAME' 		,text: '경상귀속부서명'		,type: 'string'	},
			{name: 'SUBCONTRACT_COST'		,text: '도급'				,type: 'uniPercent'},
			{name: 'SUBCONTRACT_DEPT_CODE'  ,text: '도급귀속부서코드'	,type: 'string'	},
			{name: 'SUBCONTRACT_DEPT_NAME'  ,text: '도급귀속부서명'		,type: 'string'	},
			{name: 'FI_CAPI_TOT_I'		    ,text: '자본적지출'		,type: 'uniPrice'},
			{name: 'FI_SALE_TOT_I'			,text: '매각/폐기전 미상각잔액'		,type: 'uniPrice'},
			{name: 'FI_SALE_DPR_TOT_I'		,text: '매각/폐기전 상각누계액'	,type: 'uniPrice'},
			{name: 'FI_REVAL_TOT_I'			,text: '재평가액'			,type: 'uniPrice'},
			{name: 'FI_REVAL_DPR_TOT_I'		,text: '재평가상각감소액'	,type: 'uniPrice'},
			{name: 'FI_DPR_TOT_I'			,text: '상각누계액'		,type: 'uniPrice'},
			{name: 'FI_DMGLOS_TOT_I'		,text: '손상차손누계액'		,type: 'uniPrice'},
			{name: 'FL_BALN_I'				,text: '미상각잔액'		,type: 'uniPrice'},
			
			{name: 'WASTE_SW'				,text: '매각폐기여부'		,type: 'string'/*		, comboType: 'AU'		, comboCode: 'A035'*/},
			{name: 'WASTE_YYYYMM'			,text: '매각폐기년월'		,type: 'uniDate'},
			{name: 'DPR_STS2'				,text: '상각완료여부'		,type: 'string'/*		, comboType: 'AU'		, comboCode: 'A035'*/},
			{name: 'DPR_YYYYMM'				,text: '상각완료년월'		,type: 'string'}
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('aiss310ukrvMasterStore1',{
		model: 'Aiss310ukrvModel',
		uniOpt : {								
			isMaster	: true,			// 상위 버튼 연결 	
			editable	: true,			// 수정 모드 사용 	
			deletable	: true,			// 삭제 가능 여부 	
			useNavi 	: false			// prev | next 버튼 사용	
		},
        autoLoad: false,
        proxy	: directProxy,
        
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
			Ext.getCmp('apply').disable();
			Ext.getCmp('unApply').disable();
			Ext.getCmp('apply1').disable();
			Ext.getCmp('unApply1').disable();

		},
		
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		
//			폼에서 필요한 조건 가져올 경우
			var paramMaster = Ext.getCmp('searchForm').getValues();
       		var rv = true;
       		
        	if(inValidRecs.length == 0 )	{
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	

					} 
				};					
				this.syncAllDirect(config);
				
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
 		},
 		
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(store.getCount() > 0){
					Ext.each(records, function(record,i) {
						if (Ext.isEmpty(record.get('FL_BALN_I'))) {
							var flBalnI = record.get('ACQ_AMT_I') - record.get('FI_DPR_TOT_I')			//미상각잔액 = 취득가액 - 상각누계액
							record.set('FL_BALN_I', flBalnI);
						}
					});
					UniAppManager.setToolbarButtons('newData',		true);
					UniAppManager.setToolbarButtons('delete',		false);		//체크되었을 때 활성화 되어야 함
					UniAppManager.setToolbarButtons('deleteAll',	true);

				}else{
					UniAppManager.setToolbarButtons('newData',		false);
					UniAppManager.setToolbarButtons('save',			false);
					UniAppManager.setToolbarButtons('delete',		false);
					UniAppManager.setToolbarButtons('deleteAll',	false);
					
				}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});

    var buttonStore = Unilite.createStore('Agd170UkrButtonStore',{      
        uniOpt: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,           // 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy: directButtonProxy,
        saveStore: function(buttonFlag) {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

			var paramMaster			= panelSearch.getValues();
            paramMaster.OPR_FLAG	= buttonFlag;
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
                var grid = Ext.getCmp('aiss310ukrvGrid1');
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

	/* 자산정보 엑셀 업로드 Form
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title	: '기본정보', 	
   			itemId	: 'search_panel1',
           	layout	: {type : 'uniTable', columns : 1, tableAttrs: {width: '100%'}},
           	defaultType: 'uniTextfield',
		    items	: [{ 
	        	fieldLabel	: '취득일',
				xtype		: 'uniDateRangefield',  
				startFieldName: 'FR_ACQ_DATE',
				endFieldName: 'TO_ACQ_DATE',
				startDate	: UniDate.get('startOfMonth'),
				endDate		: UniDate.get('today'),
				allowBlank	: false,
				width		: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_ACQ_DATE', newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_ACQ_DATE',newValue);
			    	}   	
			    }
			},{ 
	        	fieldLabel	: '입력일',
				xtype		: 'uniDateRangefield',  
				startFieldName: 'FR_INPUT_DATE',
				endFieldName: 'TO_INPUT_DATE',
//				startDate	: UniDate.get('startOfMonth'),
//				endDate		: UniDate.get('today'),
//				allowBlank	: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_INPUT_DATE', newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_INPUT_DATE',newValue);
			    	}   	
			    }
			},{ 
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				value		: UserInfo.divCode,
				comboType	: 'BOR120',
		        multiSelect	: true, 
		        typeAhead	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
				Unilite.popup('ACCNT',{ 
//					validateBlank: false,
					autoPopup: true,
			    	fieldLabel: '계정과목',
			    	listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_NAME', newValue);				
						},
						applyextparam: function(popup){
//							popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
//							popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
						}
					}
			}),
				Unilite.popup('ASSET',{ 
					autoPopup: true,
			    	fieldLabel: '자산코드', 
			    	listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ASSET_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ASSET_NAME', newValue);				
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				xtype		: 'radiogroup',		            		
				fieldLabel	: '자산반영',
				itemId		: 'ASST_APPLY',
				allowBlank	: false,
				items		: [{
					boxLabel: '전체', 
					width	: 70, 
					name	: 'ASST_APPLY',
		    		checked	: true,
					inputValue: '0'
				},{
					boxLabel: '예', 
					width	: 70,
					name	: 'ASST_APPLY',
					inputValue: 'Y'
				},{
					boxLabel: '아니오', 
					width	: 70,
					name	: 'ASST_APPLY',
					inputValue: 'N',
					listeners: {
						specialkey: function(field, event){
							if(event.getKey() == event.ENTER){
								UniAppManager.app.onQueryButtonDown();
							}
						}
					}
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {					
						panelResult.getField('ASST_APPLY').setValue(newValue.ASST_APPLY);
					}
				}
			}, {
				xtype	: 'container',
				tdAttrs	: {align: 'center'},
				layout	: {type: 'uniTable'},
				items	: [{
					xtype	: 'button',
					text	: '자산반영',
					width	: 100,
					id		: 'apply',
					handler	: function() {
						var records = masterGrid.getSelectedRecords();
    					var checkFlag = true;								//자산반영시, 대상 체크하기 위한 flag 
						if(records.length < 1) return false;
						Ext.each(records, function(record, i){
							if(record.get('APPLY_YN') == "Y"){
								alert(record.get('ASST') + "은(는) 이미 자산에 반영이 되어 있습니다.");
			    				checkFlag = false; 
			    				return false;
							}
						});
						if (checkFlag) {
							//자산취소 쿼리 호출
				            var buttonFlag = 'A';
				            fnMakeLogTable(buttonFlag);
						}
						
					}
		        },{
		           xtype	: 'button',
				   text		: '자산반영취소',
				   id		: 'unApply',
				   width	: 100,
				   handler	: function() {
				   		var records = masterGrid.getSelectedRecords();
    					var checkFlag = true;								//자산반영시, 대상 체크하기 위한 flag 
						if(records.length < 1) return false;
						Ext.each(records, function(record, i){
							if(record.get('APPLY_YN') == "N"){
								alert(record.get('ASST') + "은(는) 자산반영이 되어 있지 않습니다.");
			    				checkFlag = false; 
			    				return false;
							}
						});
						if (checkFlag) {
							//자산취소 쿼리 호출
				            var buttonFlag = 'D';
				            fnMakeLogTable(buttonFlag);
						}
					}
		        }]
			}]
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		padding	:'1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
//		tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
//		tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/},
		items	: [{ 
        	fieldLabel	: '취득일',
			xtype		: 'uniDateRangefield',  
			startFieldName: 'FR_ACQ_DATE',
			endFieldName: 'TO_ACQ_DATE',
			startDate	: UniDate.get('startOfMonth'),
			endDate		: UniDate.get('today'),
			allowBlank	: false,
			width		: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_ACQ_DATE',newValue);
            	}   
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_ACQ_DATE',newValue);
		    	}   	
		    }
		},{ 
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			value		: UserInfo.divCode,
			comboType	: 'BOR120',
	        multiSelect	: true, 
	        typeAhead	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			xtype: 'component'
		},{ 
        	fieldLabel	: '입력일',
			xtype		: 'uniDateRangefield',  
			startFieldName: 'FR_INPUT_DATE',
			endFieldName: 'TO_INPUT_DATE',
//			startDate	: UniDate.get('startOfMonth'),
//			endDate		: UniDate.get('today'),
//			allowBlank	: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_INPUT_DATE',newValue);
            	}   
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_INPUT_DATE',newValue);
		    	}   	
		    }
		},
			Unilite.popup('ACCNT',{ 
				autoPopup	: true,
		    	fieldLabel	: '계정과목',
		    	listeners	: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('ACCNT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('ACCNT_NAME', newValue);				
					},
					applyextparam: function(popup){
//							popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
//							popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
					}
				}
		}),{
			xtype: 'component'
		},
			Unilite.popup('ASSET',{ 
				autoPopup	: true,
		    	fieldLabel	: '자산코드', 
		    	listeners	: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('ASSET_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('ASSET_NAME', newValue);				
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		}),{
			xtype		: 'radiogroup',		            		
			fieldLabel	: '자산반영',
			itemId		: 'ASST_APPLY',
			id			: 'rdoSelect1',
			allowBlank	: false,
			items		: [{
				boxLabel: '전체', 
				width	: 70, 
				name	: 'ASST_APPLY',
		    	checked	: true,
				inputValue: '0'
				
			},{
				boxLabel : '예', 
				width	: 70,
				name: 'ASST_APPLY',
				inputValue: 'Y'
			},{
				boxLabel : '아니오', 
				width	: 70,
				name	: 'ASST_APPLY',
				inputValue: 'N',
				listeners: {
					specialkey: function(field, event){
						if(event.getKey() == event.ENTER){
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('ASST_APPLY').setValue(newValue.ASST_APPLY);
					
					if (newYN == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
						newYN = '0'
						return false;
					}else {
						Ext.getCmp('apply').disable();
						Ext.getCmp('unApply').disable();
						Ext.getCmp('apply1').disable();
						Ext.getCmp('unApply1').disable();

						UniAppManager.app.onQueryButtonDown();	
					}	
				}
			}
		},{
			xtype	: 'container',
			colspan	: 2,
			tdAttrs	: {align: 'right'},
			layout	: {type: 'uniTable', columns: 3},
			items:[{
				xtype	: 'button',
				text	: '자산반영',
				width	: 87,
				id		: 'apply1',
				handler	: function() {
					var records = masterGrid.getSelectedRecords();
					var checkFlag = true;								//자산반영시, 대상 체크하기 위한 flag 
					if(records.length < 1) return false;
					Ext.each(records, function(record, i){
						if(record.get('APPLY_YN') == "Y"){
							alert(record.get('ASST') + "은(는) 이미 자산에 반영이 되어 있습니다.");
		    				checkFlag = false; 
		    				return false;
						}
					});
					if (checkFlag) {
						//자산취소 쿼리 호출
			            var buttonFlag = 'A';
			            fnMakeLogTable(buttonFlag);
					}
					
				}
	        },{
	           xtype	: 'button',
			   text		: '자산반영취소',
			   id		: 'unApply1',
			   width	: 87,
			   handler	: function() {
			   		var records = masterGrid.getSelectedRecords();
					var checkFlag = true;								//자산반영시, 대상 체크하기 위한 flag 
					if(records.length < 1) return false;
					Ext.each(records, function(record, i){
						if(record.get('APPLY_YN') == "N"){
							alert(record.get('ASST') + "은(는) 자산반영이 되어 있지 않습니다.");
		    				checkFlag = false; 
		    				return false;
						}
					});
					if (checkFlag) {
						//자산취소 쿼리 호출
			            var buttonFlag = 'D';
			            fnMakeLogTable(buttonFlag);
					}
				}
	        }]
		}]
    });
    
    var masterGrid = Unilite.createGrid('aiss310ukrvGrid1', {
//   	layout : 'fit',
        region : 'center',
        store : masterStore, 
        excelTitle: '자산대장조회',
        uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: true,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: false,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
    		listeners: {
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
					UniAppManager.setToolbarButtons('delete',		true);
					
	    			if (this.selected.getCount() > 0) {
	    				if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == '0') {
							Ext.getCmp('apply').enable();
							Ext.getCmp('unApply').enable();
							Ext.getCmp('apply1').enable();
							Ext.getCmp('unApply1').enable();
							
	    				} else if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Y') {
							Ext.getCmp('apply').disable();
							Ext.getCmp('unApply').enable();
							Ext.getCmp('apply1').disable();
							Ext.getCmp('unApply1').enable();
	    					
	    				} else if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'N') {
							Ext.getCmp('apply').enable();
							Ext.getCmp('unApply').disable();
							Ext.getCmp('apply1').enable();
							Ext.getCmp('unApply1').disable();
	    					
	    				}
	    			}

    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			if (this.selected.getCount() == 0) {
						UniAppManager.setToolbarButtons('delete',	false);
	    			}

	    			if (this.selected.getCount() <= 0) {			//체크된 데이터가 0개일  때는 버튼 비활성화
							Ext.getCmp('apply').disable();
							Ext.getCmp('unApply').disable();
							Ext.getCmp('apply1').disable();
							Ext.getCmp('unApply1').disable();
	    			}
	    		}
    		}
    	}),
    	tbar: [{
    	
        	text:'엑셀파일 UpLoad',
        	handler: function() {
        		openExcelWindow();
        	}
        }],
    	features: [{
    		id		: 'masterGridSubTotal',
    		ftype	: 'uniGroupingsummary', 
    		showSummaryRow: false 
		},{
    		id		: 'masterGridTotal', 	
    		ftype	: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [
        	{
				xtype	: 'rownumberer', 
				sortable: false, 
				width	: 35,
				align	:'center  !important',
				resizable: true
        	},
        	{dataIndex: 'APPLY_YN'							,  width: 100		, hidden: true},        
        	{text: '자산기본정보',
          		columns: [
		        	{dataIndex: 'ASST'						,  width: 100},        
		        	{dataIndex: 'ASST_NAME'					,  width: 100},        
		        	{dataIndex: 'SPEC' 						,  width: 60},        
		        	{dataIndex: 'SERIAL_NO' 				,  width: 100},        
		        	{dataIndex: 'ASST_DIVI' 				,  width: 80},        
		        	{dataIndex: 'ACCNT' 					,  width: 100},        
		        	{dataIndex: 'DIV_CODE' 					,  width: 80},        
		        	{dataIndex: 'DEPT_CODE' 				,  width: 80},        
		        	{dataIndex: 'DEPT_NAME' 				,  width: 80},        
		        	{dataIndex: 'PURCHASE_DEPT_CODE' 		,  width: 80},        
		        	{dataIndex: 'PURCHASE_DEPT_NAME' 		,  width: 80}
				]
			},
        	{text: '취득정보',
          		columns: [
			    	{dataIndex: 'DRB_YEAR' 					,  width: 60},        
		        	{dataIndex: 'MONEY_UNIT' 				,  width: 80},        
		        	{dataIndex: 'EXCHG_RATE_O' 				,  width: 70},        
		        	{dataIndex: 'FOR_ACQ_AMT_I'				,  width: 80},        
		        	{dataIndex: 'ACQ_AMT_I' 				,  width: 80},        
		        	{dataIndex: 'ACQ_Q' 					,  width: 60},    
		        	{dataIndex: 'QTY_UNIT' 					,  width: 80},    
		        	{dataIndex: 'ACQ_DATE' 					,  width: 80}
	        	]
        	},
        	{text: '기타정보',
          		columns: [
		        	{dataIndex: 'PERSON_NUMB'				,  width: 80},        
		        	{dataIndex: 'PLACE_INFO'				,  width: 80},        
		        	{dataIndex: 'CUSTOM_CODE'				,  width: 80},        
		        	{dataIndex: 'CUSTOM_NAME'				,  width: 100},        
		        	{dataIndex: 'PJT_CODE'					,  width: 100},        
		        	{dataIndex: 'MAKER_NAME'				,  width: 100},        
		        	{dataIndex: 'REMARK'					,  width: 100}
	        	]
        	},
        	{text: '원가구분비율',
          		columns: [
		        	{dataIndex: 'SALE_MANAGE_COST'			,  width: 60},			//판관
		        	{dataIndex: 'SALE_MANAGE_DEPT_CODE' 	,  width: 80},        
		        	{dataIndex: 'SALE_MANAGE_DEPT_NAME' 	,  width: 80}, 
					{dataIndex: 'PRODUCE_COST'				,  width: 60},        	//제조
					{dataIndex: 'PRODUCE_DEPT_CODE' 		,  width: 80},        
		        	{dataIndex: 'PRODUCE_DEPT_NAME' 		,  width: 80}, 
		        	{dataIndex: 'SALE_COST'					,  width: 60},
		        	{dataIndex: 'SALE_DEPT_CODE' 			,  width: 80},        
		        	{dataIndex: 'SALE_DEPT_NAME' 			,  width: 80}, 
		        	{dataIndex: 'SUBCONTRACT_COST'			,  width: 60},
		        	{dataIndex: 'SUBCONTRACT_DEPT_CODE' 	,  width: 80},        
		        	{dataIndex: 'SUBCONTRACT_DEPT_NAME' 	,  width: 80}
	        	]
        	},
        	{text: '상각누적정보',
          		columns: [
		        	{dataIndex: 'FI_CAPI_TOT_I'				,  width: 100},        
		        	{dataIndex: 'FI_SALE_TOT_I'				,  width: 100},        
		        	{dataIndex: 'FI_SALE_DPR_TOT_I'			,  width: 100},        
		        	{dataIndex: 'FI_REVAL_TOT_I'			,  width: 100},        
		        	{dataIndex: 'FI_REVAL_DPR_TOT_I'		,  width: 100},        
		        	{dataIndex: 'FI_DPR_TOT_I'				,  width: 100},        
		        	{dataIndex: 'FI_DMGLOS_TOT_I'			,  width: 100},        
		        	{dataIndex: 'FL_BALN_I'					,  width: 100}
		    	]
        	},
        	{text: '매각폐기정보',
          		columns: [
		        	{dataIndex: 'WASTE_SW'					,  width: 100},        
		        	{dataIndex: 'WASTE_YYYYMM'				,  width: 100}
	        	]
        	},
        	{text: '상각완료정보',
          		columns: [
		        	{dataIndex: 'DPR_STS2'					,  width: 100},        
		        	{dataIndex: 'DPR_YYYYMM'				,  width: 100		, align: 'center'}
        		]
        	}
        ],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
//	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
//      		return true;
      	},
      	uniRowContextMenu:{
//			items: [
//	            {	text	: '자산정보 등록',   
//	            	handler	: function(menuItem, event) {
//	            		var param = menuItem.up('menu');
//	            		masterGrid.gotoAss300skr(param.record);
//	            	}
//	        	}
//	        ]
	    },
	    gotoAss300skr:function(record)	{
//			if(record)	{
//		    	var params = record;
//		    	params.PGM_ID 			= 'aiss310ukrv';
//		    	params.ASST 			=	record.get('ASST');
//		    	params.ASST_NAME 		=	record.get('ASST_NAME');
//			}
//	  		var rec1 = {data : {prgID : 'aiss300ukrv', 'text':''}};							
//			parent.openTab(rec1, '/accnt/aiss300ukrv.do', params);
    	}     
    });  
    
    /**
	 * main app
	 */
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
		id  : 'aiss310ukrvApp',
		
		fnInitBinding : function() {
			var param =  {};
//			aiss310ukrvService.getRefCode(param, function(provider, response){
//				gsSlipDivi = provider[0].REF_CODE1	//전표기준 1 : AGJ100T, 2 : AIGJ210T
//				gsAutoType = provider[0].REF_CODE2	//감가상각비자동기표 분개 방식 (1:batch, 2:분개화면 거쳐 저장)
//			});
			//버튼 비활성화
			Ext.getCmp('apply').disable();
			Ext.getCmp('unApply').disable();
			Ext.getCmp('apply1').disable();
			Ext.getCmp('unApply1').disable();
			UniAppManager.setToolbarButtons('query',	true);
			UniAppManager.setToolbarButtons('reset',	true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_ACQ_DATE');
			
			this.setDefault();
		},
		
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
			
			}
		},
		
		onNewDataButtonDown: function()	{
            var r = {
	        };
			masterGrid.createRow(r/*,'PUB_DATE'*/);
		},

		onSaveDataButtonDown: function() {
			masterStore.saveStore();
		},

		onDeleteDataButtonDown : function() {
			var selRow = masterGrid.getSelectedRecord();						
			console.log("selRow",selRow);
			
			if (selRow.phantom == true) {
				masterGrid.deleteSelectedRow();
			} else if (confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {
				masterGrid.deleteSelectedRow();
				UniAppManager.setToolbarButtons('save'	, true);
			}
		},

		onDeleteAllButtonDown : function() {			
			var records = masterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm(Msg.sMH1353 + "\n" + Msg.sMB064)) {
						var deletable = true;
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
			UniAppManager.setToolbarButtons('newData',		false);
			UniAppManager.setToolbarButtons('deleteAll',	false);
		},
		
		onResetButtonDown: function() {
			newYN = '1';
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},

		setDefault: function() {
			panelSearch.setValue('FR_ACQ_DATE',		UniDate.get('startOfMonth'));
	 		panelSearch.setValue('TO_ACQ_DATE', 	UniDate.get('today'));
			panelResult.setValue('FR_ACQ_DATE',		UniDate.get('startOfMonth'));
	 		panelResult.setValue('TO_ACQ_DATE', 	UniDate.get('today'));

	 		panelSearch.setValue('DIV_CODE', 		UserInfo.divCode);
	 		panelResult.setValue('DIV_CODE', 		UserInfo.divCode);

		 	panelSearch.setValue('ASST_APPLY', 		'0');
	 		panelResult.setValue('ASST_APPLY', 		'0');
			newYN = '0';

		}
	});

	function openExcelWindow() {
	    var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        if(!masterStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			masterStore.loadData({});
        } else {
        	if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
        		UniAppManager.app.onSaveDataButtonDown();
        		return;
        	}else {
        		masterStore.loadData({});
        	}
        }
        
        if(!excelWindow) { 
        	excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
            	excelConfigName: 'aiss310ukrv',
				width	: 600,
				height	: 200,
				modal	: false,
        		extParam: { 
        			'PGM_ID'		: 'aiss310ukrv'
//        			'SALE_DIV_CODE'	: panelSearch.getValue('SALE_DIV_CODE'),
//        			'DIV_CODE'		: baseInfo.gsBillDivCode,
//        			'BILL_TYPE'		: panelSearch.getValue('BILL_TYPE'),
//        			'ISSUE_GUBUN'	: Ext.getCmp('rdoSelect0').getChecked()[0].inputValue,
//        			'CUSTOM_CODE'	: panelSearch.getValue('CUSTOM_CODE'),
//        			'APPLY_YN'		: Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue
        		},
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },
                uploadFile: function() {
					var me = this,
					frm = me.down('#uploadForm');
					frm.submit({
						params	: me.extParam,
						waitMsg	: 'Uploading...',
						success	: function(form, action) {
							var param = {
							     jobID : action.result.jobID
							}
                            aiss310ukrvService.getErrMsg(param, function(provider, response){
                                if (Ext.isEmpty(provider)) {
                                    me.jobID = action.result.jobID;
                                    me.readGridData(me.jobID);
                                    me.down('tabpanel').setActiveTab(1);
                                    UniAppManager.updateStatus('Upload 성공 하였습니다.');
                                    
                                    me.hide();
                                    UniAppManager.app.onQueryButtonDown();
                                    
                                } else {
                                    Unilite.messageBox(provider);
                                }
                            });
						},
			            failure: function(form, action) {
			                Ext.Msg.alert('Failed', action.result.msg);
			            }
						
					});
				},
				
                _setToolBar: function() {
					var me = this;
					me.tbar = [{
						xtype: 'button',
						text : '업로드',
						tooltip : '업로드', 
						handler: function() { 
							me.jobID = null;
							me.uploadFile();
						}
					},
					'->',
					{
						xtype: 'button',
						text : '닫기',
						tooltip : '닫기', 
						handler: function() { 
							me.hide();
						}
					}
				]}
			});
		}
        excelWindow.center();
        excelWindow.show();
	};
	
	function fnMakeLogTable(buttonFlag) {
		//조건에 맞는 내용은 적용 되는 로직
		records = masterGrid.getSelectedRecords();
		buttonStore.clearData();											//buttonStore 클리어
		Ext.each(records, function(record, index) {
            record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;							//자동기표 flag
            buttonStore.insert(index, record);
			
			if (records.length == index +1) {
                buttonStore.saveStore(buttonFlag);
			}
		});
	}

}
</script>
