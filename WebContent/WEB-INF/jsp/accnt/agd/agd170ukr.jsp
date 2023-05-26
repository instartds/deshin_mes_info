<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd170ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 										<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A012" opts= '${gsListA012}'/> 		<!-- 매입매출거래유형(매출) -->
	<t:ExtComboStore comboType="AU" comboCode="A014"  /> 							<!-- 전표승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A022"  /> 							<!-- 증빙구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S096" /> 							<!-- 세금계산서구분 -->
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

//전표승인여부 필드는 정의서 상에 없어서 숨김처리 해 놓음(필요시 아래 로직 이용해서 사용하면 됨) 			
//			panelSearch.getField('AGREE_YN').setVisible(true);
//			panelResult.getField('AGREE_YN').setVisible(true);



function appMain() {   
//조회된 합계, 건수 계산용 변수 선언
var sumSaleTaxAmtI = 0;
	sumCheckedCount = 0;
	newYN = 0;

	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'agd170ukrService.runProcedure',
            syncAll	: 'agd170ukrService.callProcedure'
		}
	});	

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agd170ukrModel', {
	   fields: [
			{name: 'DIV_CODE'			, text: '사업장'				, type: 'string',	comboType: 'BOR120'},					//코드값으로 명을 가져오게 하는 처리
			{name: 'PUB_NUM'			, text: '계산서발행번호'			, type: 'string'},
			{name: 'BILL_FLAG'         	, text: '세금계산서구분'			, type: 'string',	comboType: "AU", comboCode: "S096"},
			{name: 'BILL_DATE'         	, text: '계산서일'				, type: 'uniDate'},
			{name: 'BUSI_TYPE'			, text: '거래유형'				, type: 'string',	comboType: "AU", comboCode: "A012"},
			{name: 'PROOF_KIND'			, text: '증빙유형'				, type: 'string',	comboType: "AU", comboCode: "A022"},
			{name: 'CUSTOM_CODE'		, text: '거래처코드'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명'				, type: 'string'},
			{name: 'SALE_LOC_AMT_I'		, text: '공급가액'				, type: 'uniPrice'},
			{name: 'TAX_AMT_O'		    , text: '부가세액'				, type: 'uniPrice'},
			{name: 'SALE_TAX_AMT_I'		, text: '합계'				, type: 'uniPrice'},
			{name: 'BILL_DIV_CODE'		, text: '신고사업장'			, type: 'string',	comboType: 'BOR120'},
			{name: 'REMARK'				, text: '비고'				, type: 'string'},
			{name: 'EX_DATE'      		, text: '결의전표일'			, type: 'uniDate'},
			{name: 'EX_NUM'				, text: '결의번호'				, type: 'string'},
			{name: 'AGREE_YN'			, text: '승인여부'				, type: 'string',	comboType: "AU", comboCode: "A014"},
			{name: 'SELECTED_AMT'		, text: '합계(선택)'			, type: 'uniPrice'},
			{name: 'COUNT'				, text: '건수(선택)'			, type: 'uniQty'},
			{name: 'HDD_BILL_PUB_NUM'	, text: '계산서발행번호(hidden)'	, type: 'string'}
	    ]
	});		// End of Ext.define('agd170ukrModel', {
	  
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('Agd170UkrmasterStore',{
		model: 'Agd170ukrModel',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 	
			deletable	: false,		// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agd170ukrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.WORK_DATE	= UniDate.getDbDateStr(addResult.getValue('WORK_DATE'));
			param.PUB_DATE	= Ext.getCmp('rdoSelect1').getChecked()[0].inputValue;
			param.WORK_DIVI	= Ext.getCmp('rdoSelect2').getChecked()[0].inputValue;
			console.log( param );
			this.load({
				params : param
			});
			Ext.getCmp('procCanc').disable();
			Ext.getCmp('procCanc2').disable();
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

            var paramMaster = panelSearch.getValues();
            paramMaster.OPR_FLAG	= buttonFlag;
			paramMaster.PROC_DATE	= UniDate.getDbDateStr(addResult.getValue('WORK_DATE'));

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
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
                var grid = Ext.getCmp('agd170ukrGrid');
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
    
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
//	        	addResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
//	        	addResult.hide();
	        }
	    },
		items: [{	
			title: '기본정보', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '계산서일',
	            xtype: 'uniDateRangefield',
	            startFieldName: 'PUB_DATE_FR',
	            endFieldName: 'PUB_DATE_TO',
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            allowBlank: false,                	
				autoPopup: true,
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('PUB_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PUB_DATE_TO', newValue);				    		
			    	}
			    }
	     	},{
				fieldLabel: '입력일',
	            xtype: 'uniDateRangefield',
	            startFieldName: 'INSERT_DATE_FR',
	            endFieldName: 'INSERT_DATE_TO',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('INSERT_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INSERT_DATE_TO', newValue);				    		
			    	}
			    }
	     	},{
	     		fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value : UserInfo.divCode,
				comboType: 'BOR120',
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DIV_CODE', newValue);
			    	}
	     		}
			},		    
        	Unilite.popup('CUST',{
		        fieldLabel: '거래처',
		        //validateBlank:false,
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
			  	colspan: 2,  
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);				
					}
				}
		    }),
			Unilite.popup('ACCNT_PRSN',{ 
			    fieldLabel: '입력자', 
			    validateBlank: false, 
				valueFieldName:'CHARGE_CODE',
				textFieldName:'CHARGE_NAME',
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CHARGE_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CHARGE_NAME', newValue);				
					}
				}
			})
		]},{
			xtype: 'container',
			layout : {type : 'uniTable'},
			items:[{
				fieldLabel: '전표승인여부',
            	name: 'AGREE_YN',
            	xtype: 'uniCombobox',
            	comboType: 'AU',
            	comboCode: 'A014',
		 		tdAttrs: {align: 'right'},
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    	panelResult.setValue('AGREE_YN', newValue);
			    	}
	     		}
			}]
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '계산서일',
	            xtype: 'uniDateRangefield',
	            startFieldName: 'PUB_DATE_FR',
	            endFieldName: 'PUB_DATE_TO',
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            allowBlank: false,                	
				autoPopup: true,
	            tdAttrs: {width: 380},    
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelSearch.setValue('PUB_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('PUB_DATE_TO', newValue);				    		
			    	}
			    }
	     	},		    
        	Unilite.popup('CUST',{
		        fieldLabel: '거래처',
		        //validateBlank:false,
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
	            tdAttrs: {width: 380},    
	            colspan: 2,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);				
					}
				}
		    }),{
				fieldLabel: '입력일',
	            xtype: 'uniDateRangefield',
	            startFieldName: 'INSERT_DATE_FR',
	            endFieldName: 'INSERT_DATE_TO',
	            tdAttrs: {width: 380},    
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('INSERT_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('INSERT_DATE_TO', newValue);				    		
			    	}
			    }
	     	},
			Unilite.popup('ACCNT_PRSN',{ 
			    fieldLabel: '입력자', 
			    validateBlank: false, 
				valueFieldName:'CHARGE_CODE',
				textFieldName:'CHARGE_NAME',
            	tdAttrs: {width: 380},    
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CHARGE_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CHARGE_NAME', newValue);				
					}
				}
			}),{
				xtype: 'container',
				layout : {type : 'uniTable'},
				items:[{
					fieldLabel: '전표승인여부',
	            	name: 'AGREE_YN',
	            	xtype: 'uniCombobox',
	            	comboType: 'AU',
	            	comboCode: 'A014',
			 		tdAttrs: {align: 'right'},
					listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				    	panelSearch.setValue('AGREE_YN', newValue);
				    	}
		     		}
				}]
			},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value : UserInfo.divCode,
				comboType: 'BOR120',
	            tdAttrs: {width: 380},    
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelSearch.setValue('DIV_CODE', newValue);
			    	}
	     		}
			}
		]
	});
	
	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 3, tdAttrs: {width: '100%'/*, style: 'border : 1px solid #ced9e7;'*/}
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		disabled: false,
		border:true,
		padding: '1',
		region: 'center',
		items: [{
			xtype: 'container',
			layout : {type : 'uniTable'},
			tdAttrs: {width: 380},    
	    	items:[{
				fieldLabel: '실행일',
	            xtype: 'uniDatefield',
			 	name: 'WORK_DATE',
		        value: UniDate.get('today'),
//				readOnly:true,
			 	allowBlank:false,
			 	width:220,
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
	     	},{
				xtype: 'radiogroup',		            		
				fieldLabel: '',						            		
				id: 'rdoSelect1',
				items: [{
					boxLabel: '계산서일', 
					width: 70, 
					name: 'PUB_DATE',
	    			inputValue: '1'
				},{
					boxLabel : '실행일', 
					width: 70,
					name: 'PUB_DATE',
	    			inputValue: '2',
                    checked: true  
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						if(newValue.PUB_DATE == '1'){
							addResult.getField('WORK_DATE').setReadOnly(true);
						}else{
							addResult.getField('WORK_DATE').setReadOnly(false);
						}
					}
				}
			}]
		},{
			xtype: 'container',
			layout : {type : 'uniTable'},
	    	items:[{
	    		xtype: 'radiogroup',		            		
				fieldLabel: '작업구분',						            		
				id: 'rdoSelect2',
				tdAttrs: {align: 'left'},
				items: [{
					boxLabel: '자동기표', 
					width: 90, 
					name: 'WORK_DIVI',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel : '기표취소', 
					width: 90,
					name: 'WORK_DIVI',
	    			inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
			    		if(newValue.WORK_DIVI == 1){
		       				Ext.getCmp('procCanc').setHidden(false);
		       				Ext.getCmp('procCanc').setText('일괄자동기표');
		       				Ext.getCmp('procCanc2').setText('개별자동기표');
		
		   				}else {
		       				Ext.getCmp('procCanc').setHidden(true);
		       				Ext.getCmp('procCanc2').setText('기표취소');
		       			}

						if (newYN == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
							newYN = '0'
							return false;
						}else {
							UniAppManager.app.onQueryButtonDown();	
						}	
					}
				}
			}]
		},{
			//컬럼 맞춤용
			xtype: 'component'
		},{
			xtype: 'container',
			layout : {type : 'uniTable', columns : 2, tdAttrs: {width: '100%'}
			},
			colspan: 2,
	    	items:[{
				xtype: 'uniNumberfield',		            		
				fieldLabel: '합계(선택)',						            		
				width: 200,
				labelWidth: 60,
				name: 'SELECTED_AMT',
				readOnly: true,
				tdAttrs: {align: 'right'},
				value: 0,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			},{
				xtype: 'uniNumberfield',		            		
				fieldLabel: '건수(선택)',						            		
				width: 160,
				labelWidth: 100,
				name: 'COUNT',
				readOnly: true,
				tdAttrs: {align: 'right'},
				value: 0,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			}]
		},{
			xtype: 'container',
			layout : {type : 'uniTable'},
			tdAttrs: {align: 'right'},
			width: 210,
			items:[{				   
				xtype: 'button',
				//name: 'CONFIRM_CHECK',
				id: 'procCanc',
				text: '일괄자동기표',
				width: 100,
		 		tdAttrs: {align: 'right'},
				handler : function() {
					if(!addResult.getInvalidMessage()){						//조회전 필수값 입력 여부 체크
						return false;
					}
					//자동기표일 때 SP 호출
		            var buttonFlag = 'AS';								//일괄자동기표 FLAG		
		            fnMakeLogTable(buttonFlag);							//일괄자동기표취소 FLAG
				}
			},{				   
				xtype: 'button',
				//name: 'CONFIRM_CHECK',
				id: 'procCanc2',
				text: '개별자동기표',
				width: 100,
		 		tdAttrs: {align: 'right'},
				handler : function() {
					if(!addResult.getInvalidMessage()){						//조회전 필수값 입력 여부 체크
						return false;
					}
					//자동기표일 때 SP 호출
					if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '1'){
			            var buttonFlag = 'IS';								//개별자동기표 FLAG
			            fnMakeLogTable(buttonFlag);							//개별자동기표취소 FLAG
					}
					//기표취소일 때 SP 호출
					if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '2'){
    					var checkFlag = true;								//기표취소시, 승인된 전표 체크하기 위한 flag 
						records = masterGrid.getSelectedRecords();
						Ext.each(records, function(record, index) {
			    			if (record.get('AGREE_YN') == '2') {
			    				alert('계산서번호 ' +record.get('PUB_NUM') + '(은)는 ' + Msg.fSbMsgA0380);
			    				checkFlag = false; 
			    				return false;
			    			} 
						});
						if (checkFlag) {
				            var buttonFlag = 'C';
				            fnMakeLogTable(buttonFlag);
						}
					}
				}
			}]
		}]
	});

	
	/* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agd170ukrGrid', {
    	layout : 'fit',
        region : 'center',
		store: masterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	uniOpt: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: false,	
		    useGroupSummary		: false,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: false,	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
    		listeners: { 
    			beforeselect: function( grid , record , index , eOpts ) {
	    			//기표취소일 때, 승인여부가 승인이면 선택 안 됨 (atx110ukr로 링크와 관련해서 주석 - 기표 취소 로직에서 안되도록 수정)
//	    			if (Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '2'&& record.get('AGREE_YN') == '2') {
//	    				return false;
//	    			}
    			},
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
	    			sumSaleTaxAmtI = sumSaleTaxAmtI + selectRecord.get('SALE_TAX_AMT_I');
					sumCheckedCount = sumCheckedCount + 1;
	    			addResult.setValue('SELECTED_AMT', sumSaleTaxAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)
	    			
	    			if (this.selected.getCount() > 0) {
						Ext.getCmp('procCanc').enable();
						Ext.getCmp('procCanc2').enable();
	    			}
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			sumSaleTaxAmtI = sumSaleTaxAmtI - selectRecord.get('SALE_TAX_AMT_I');
					sumCheckedCount = sumCheckedCount - 1;
	    			addResult.setValue('SELECTED_AMT', sumSaleTaxAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)
	    			
	    			if (this.selected.getCount() <= 0) {			//체크된 데이터가 0개일  때는 버튼 비활성화
						Ext.getCmp('procCanc').disable();
						Ext.getCmp('procCanc2').disable();
	    			}
	    		}
    		}
        }),
        columns: [{
				xtype	: 'rownumberer', 
				width	: 35,
				align	: 'center  !important',
				sortable: false, 
				resizable: true
			},
			{dataIndex: 'DIV_CODE'   		 	, width: 100}, 				
			{dataIndex: 'PUB_NUM'				, width: 120}, 				
			{dataIndex: 'BILL_FLAG'         	, width: 120}, 				
			{dataIndex: 'BILL_DATE'         	, width: 80}, 				
			{dataIndex: 'BUSI_TYPE'				, width: 140}, 				
			{dataIndex: 'PROOF_KIND'			, width: 120}, 				
			{dataIndex: 'CUSTOM_CODE'			, width: 100}, 				
			{dataIndex: 'CUSTOM_NAME'			, width: 180}, 				
			{dataIndex: 'SALE_LOC_AMT_I'		, width: 100}, 				
			{dataIndex: 'TAX_AMT_O'		    	, width: 80}, 				
			{dataIndex: 'SALE_TAX_AMT_I'		, width: 100}, 				
			{dataIndex: 'BILL_DIV_CODE'			, width: 130}, 				
			{dataIndex: 'REMARK'				, width: 333}, 				
			{dataIndex: 'EX_DATE'      			, width: 80}, 				
			{dataIndex: 'EX_NUM'				, width: 70		, align: 'center'}, 				
			{dataIndex: 'AGREE_YN'				, width: 90		, align: 'center'}
		] ,
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
        		view.ownerGrid.setCellPointer(view, item);
        	}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
  			return true;
      	},
        uniRowContextMenu:{
			items: [{
				text	: '세금계산서등록',   
            	itemId	: 'linkAtx110ukr',
            	handler	: function(menuItem, event) {
            		var record = masterGrid.getSelectedRecord();
            		var param = {
						action:'select',
						'PGM_ID'			: 'agd170ukr',
						'SALE_DIV_CODE'		: record.data['SALE_DIV_CODE'],
						'BILL_DATE' 		: record.data['BILL_DATE'],
						'CUSTOM_CODE'		: record.data['CUSTOM_CODE'],
						'PUB_NUM'			: record.data['PUB_NUM'],
						'DIV_CODE'			: record.data['DIV_CODE']
					};
            		masterGrid.gotoAtx110ukr(param);
            	}
        	}]
	    },
		gotoAtx110ukr:function(record)	{
			if(record)	{
				atx115skrService.getLinkID({}, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						pgmId = provider;
						var params = record;
				  		var rec1 = {data : {prgID : pgmId, 'text':''}};							
						parent.openTab(rec1, '/accnt/'+pgmId+'.do', params);
					}
				})
			}
    	} 
    });    
    
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, 
				panelResult,
				{
					region : 'north',
					xtype : 'container',
					highth: 20,
					layout : 'fit',
					items : [ addResult ]
				}
			]
		},
			panelSearch  	
		], 
		id : 'agd170ukrApp',
		
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.getField('AGREE_YN').setVisible(false);
			panelResult.getField('AGREE_YN').setVisible(false);

			panelSearch.setValue('PUB_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('PUB_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('PUB_DATE_TO', UniDate.get('today'));
			panelResult.setValue('PUB_DATE_TO', UniDate.get('today'));

			addResult.setValue('WORK_DATE', UniDate.get('today'));

			addResult.getField('PUB_DATE').setValue('2');
			addResult.getField('WORK_DIVI').setValue('1');
			Ext.getCmp('procCanc').setText('일괄자동기표');
   			Ext.getCmp('procCanc2').setText('개별자동기표');
			Ext.getCmp('procCanc').disable();
			Ext.getCmp('procCanc2').disable();

			addResult.setValue('SELECTED_AMT',0);
			addResult.setValue('COUNT',0);
			
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('PUB_DATE_FR');	
			newYN = 0;	
		},

		onQueryButtonDown : function()	{	
			if(!this.isValidSearchForm()){			//조회전 필수값 입력 여부 체크
				return false;
			}
			sumSaleTaxAmtI = 0;
			sumCheckedCount = 0;
			addResult.setValue('SELECTED_AMT',0);
			addResult.setValue('COUNT',0);
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);
		},
		
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			addResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			newYN = 1;
			this.fnInitBinding();
		}
	});

	function fnMakeLogTable(buttonFlag) {
		//조건에 맞는 내용은 적용 되는 로직
		records = masterGrid.getSelectedRecords();
		buttonStore.clearData();											//buttonStore 클리어
		Ext.each(records, function(record, index) {
            record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;							//자동기표 flag
			record.data.WORK_DATE	= UniDate.getDbDateStr(addResult.getValue('WORK_DATE'));	//일괄자동기표일 때 전표일자 처리용(실행일자)
            buttonStore.insert(index, record);
			
			if (records.length == index +1) {
                buttonStore.saveStore(buttonFlag);
			}
		});
	}
	
};
</script>
