<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="abh300ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="A014"  /> 			<!-- 전표승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A392"  /> 			<!-- 가수금 IN_GUBUN -->
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

//////////////// 참고 : agj105ukr로 링크 됨, 넘기는 parameter('PGM_ID', 'DIV_CODE', 'EX_DATE', 'EX_NUM', 'AP_STS', 'INPUT_PATH', 'EX_SEQ', 'ACCNT')
var divisionWindow; //입금액 분할 관련
function appMain() {
	
	//grid에서 사용할 combo store 생성 - 공통코드(A392)로 대체
//	InGubunStore = Unilite.createStore('InGubunStore',{
//        //data 속성의 json object에 정의된 key 값들과 매칭시켜줍니다.
//        fields : ['text','value'],
//        //저장공간에 fix값으로 data 속성에 json array type으로 담아줍니다.
//        data : [{
//            text	: '판매',
//            value	: 'S'
//        },{
//            text	: '광고',
//            value	: 'A'
//        },{
//            text	: '구매목록',
//            value	: 'P'
//        }]/*,
//        //data 속성에 fix값이 정의되있으므로 type을 memory로 정해줍니다.
//        proxy : {
//            type : 'memory'
//        }*/
//    })
	
	
//조회된 합계, 건수 계산용 변수 선언
var selectedAmt = 0;					//선택된 그리드 합계
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'abh300ukrService.selectList',
			update	: 'abh300ukrService.updateDetail',
//			create	: 'abh300ukrService.insertDetail',
			destroy	: 'abh300ukrService.deleteDetail',
			syncAll	: 'abh300ukrService.saveAll'
		}
	});	
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'abh300ukrService.runProcedure',
            syncAll	: 'abh300ukrService.callProcedure'
		}
	});	
	var directProxyDivisionButton= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'abh300ukrService.insertDetailDivisionButton',
            syncAll: 'abh300ukrService.saveAllDivisionButton'
        }
    }); 
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('abh300ukrModel', {
	    fields: [
			{name: 'SEQ'				,text: '순번'			,type: 'string'},
			{name: 'CHOICE'				,text: '선택'			,type: 'string'},
			{name: 'BANK_NAME'			,text: '은행명'		,type: 'string'},
			{name: 'SAVE_CODE'			,text: '통장코드'		,type: 'string'},
			{name: 'SAVE_NAME'			,text: '통장명'		,type: 'string'},
			{name: 'BANK_ACCOUNT'		,text: '계좌번호'		,type: 'string'},
			{name: 'BANK_ACCOUNT_EXPOS'	,text: '계좌번호'		,type: 'string', defaultValue:'*************'},
            {name: 'ACCNT'              ,text: '계정코드'      ,type: 'string'},
            {name: 'ACCNT_NAME'         ,text: '계정명'       ,type: 'string'},
            {name: 'DEPT_CODE'          ,text: '부서코드'      ,type: 'string'},
            {name: 'DEPT_NAME'          ,text: '부서명'       ,type: 'string'},
			{name: 'INOUT_DATE'			,text: '입금일자'		,type: 'uniDate'},
			{name: 'INOUT_AMT_I'		,text: '입금액'		,type: 'uniPrice'},
			{name: 'REMARK'				,text: '적요'			,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '거래처코드'		,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '거래처명'		,type: 'string'},
			{name: 'REMARK2'			,text: '비고'		,type: 'string'},
			{name: 'IN_GUBUN'			,text: '구분'			,type: 'string'		,comboType: "AU", comboCode: "A392"},
			{name: 'EX_DATE'			,text: '결의일자'		,type: 'uniDate'},
			{name: 'EX_NUM'				,text: '번호'			,type: 'string'},
			{name: 'EX_INFO'			,text: '전표정보'		,type: 'string'},
			{name: 'AP_STS'				,text: '전표승인여부'	,type: 'string'		,comboType: "AU", comboCode: "A014"},
			{name: 'AP_STS_NM'			,text: '전표승인여부'	,type: 'string'},
			{name: 'IN_REFT_NO'			,text: '수입참조번호'	,type: 'string'},
			{name: 'REFER_PATH'			,text: '반영경로'		,type: 'string'},
			{name: 'TYPE_FLAG'			,text: 'TYPE_FLAG'	,type: 'string'},
			{name: 'AUTO_NUM'			,text: 'AUTO_NUM'	,type: 'string'},
			{name: 'COMP_CODE'			,text: 'COMP_CODE'	,type: 'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'	,type: 'string'		,comboType: 'BOR120'}
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('abh300ukrmasterStore',{
		model: 'abh300ukrModel',
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 	
			deletable	: true,			// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
		proxy	: directProxy,
        
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param.PROC_FLAG = Ext.getCmp('rdoSelect1').getChecked()[0].inputValue
			console.log( param );
			this.load({
				params : param
			});
		},
		
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();

			if(inValidRecs.length == 0) {
				config = {
					success: function(batch, option) {
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
						
						if (masterStore.count() == 0) {   
//							UniAppManager.app.onResetButtonDown();
							
						}else{
//							UniAppManager.app.onQueryButtonDown();
						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
           	load: function(store, records, successful, eOpts) {
				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
				var viewNormal = masterGrid.getView();
				if(store.getCount() > 0){
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
        			masterGrid.down('#btnViewAutoSlip').enable();
        			UniAppManager.setToolbarButtons(['delete', 'deleteAll'], true);

    			}else{
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);	
				}
				
				//summaryRow에 쿼리에서 조회한 데이터 입력 후, 대체한 첫 번째 이월금액 그리드 삭제
				Ext.each(records, function(record, rowIndex){ 
					if(record.get('BANK_NAME') == '9999'){
						masterStore.remove(record);
						masterStore.commitChanges();
						
					}
				});
				
				addResult.setValue('SELECTED_AMT', 0);
   				
           		if(addResult.getValue('WORK_DIVI') == 1){
//           		if(gsConfirmYN == "Y"){
       				Ext.getCmp('procCanc').setText('개별자동기표');
       				Ext.getCmp('procCanc2').setText('일괄자동기표');
       			}else {
       				Ext.getCmp('procCanc').setText('개별기표취소');
       				Ext.getCmp('procCanc2').setText('일괄기표취소');
       			}
			}
		}
	});
	
    var buttonStore = Unilite.createStore('abh300ukrButtonStore',{      
        uniOpt: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,        	// 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy: directButtonProxy,
        saveStore: function(buttonFlag) {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

			//폼에서 필요한 조건 가져올 경우
			var paramMaster			= panelSearch.getValues();
			paramMaster.DIV_CODE	= addResult.getValue('DIV_CODE');
            paramMaster.OPR_FLAG	= buttonFlag;
            paramMaster.LANG_TYPE	= UserInfo.userLang
            
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
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
    
	
	var divisionButtonStore = Unilite.createStore('Abh300ukrDivisionButtonStore',{     
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyDivisionButton,
        saveStore: function() {     
            var paramMaster = divisionForm.getValues();
            
            
//            paramMaster.AUTO_SLIP_BUTTON_FLAG = autoSlipButtonFlag;
//            paramMaster.CMS_ID = BsaCodeInfo.getCmsId;
            config = {
                params: [paramMaster],
                success: function(batch, option) {
                    
//                    autoSlipButtonFlag = '';
                    UniAppManager.app.onQueryButtonDown();
                },
                failure: function(batch, option) {
//                    autoSlipButtonFlag = '';
                }
            };
            this.syncAllDirect(config);
            
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
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
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
           	layout	: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items	: [{ 
    			fieldLabel	: '입금일자',
		        xtype		: 'uniDateRangefield',
		        startFieldName: 'DATE_FR',
		        endFieldName: 'DATE_TO',
		        startDate	: UniDate.get('startOfMonth'),
		        endDate		: UniDate.get('today'),
		        allowBlank	: false,
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
	        },
			Unilite.popup('BANK_BOOK',{
			    fieldLabel		: '통장번호',
				valueFieldName	: 'BANK_BOOK_CODE',
				textFieldName	: 'BANK_BOOK_NAME',
			    listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('BANK_BOOK_CODE', panelSearch.getValue('BANK_BOOK_CODE'));
							panelResult.setValue('BANK_BOOK_NAME', panelSearch.getValue('BANK_BOOK_NAME'));

						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('BANK_BOOK_CODE', '');
						panelResult.setValue('BANK_BOOK_NAME', '');
					},
					applyextparam: function(popup){
						
					}
			    }
			}),{
				fieldLabel	: '전표승인여부',
				name		: 'AP_STS', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'A014',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('AP_STS', newValue);
					}
				}
			}, {               
                //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                name:'DEC_FLAG',
                xtype: 'uniTextfield',
                hidden: true
            }]		
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 3/*, tableAttrs: {width: '100%'}*/
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			items	: [{
				fieldLabel	: '입금일자',
		        xtype		: 'uniDateRangefield',
		        startFieldName: 'DATE_FR',
		        endFieldName: 'DATE_TO',
		        startDate	: UniDate.get('startOfMonth'),
		        endDate		: UniDate.get('today'),
		        allowBlank	: false,
				tdAttrs		: {width: 380},    
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('DATE_FR',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('DATE_TO',newValue);
			    	}
			    }
	        },
			Unilite.popup('BANK_BOOK',{
			    fieldLabel		: '통장번호',
				valueFieldName	: 'BANK_BOOK_CODE',
				textFieldName	: 'BANK_BOOK_NAME',
				tdAttrs			: {width: 380}, 
			    listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('BANK_BOOK_CODE', panelResult.getValue('BANK_BOOK_CODE'));
							panelSearch.setValue('BANK_BOOK_NAME', panelResult.getValue('BANK_BOOK_NAME'));

						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('BANK_BOOK_CODE', '');
						panelSearch.setValue('BANK_BOOK_NAME', '');
					},
					applyextparam: function(popup){
						
					}
			    }
			}),{
				fieldLabel	: '전표승인여부',
				name		: 'AP_STS', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'A014',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('AP_STS', newValue);
					}
				}
			}]
		}]
    });  

	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout	: {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		disabled: false,
		border	: true,
		padding	: '1',
		region	: 'center',
		items	: [{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 4
//			,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
			},
			items	: [{ 
				fieldLabel	: '일괄기표전표일',
				name		: 'EX_DATE',
				xtype		: 'uniDatefield',
				value		: UniDate.get('today'),
				width		: 245,
				allowBlank	: false
			},{
	    		xtype		: 'radiogroup',		            		
				fieldLabel	: '',						            		
				id			: 'rdoSelect0',
				tdAttrs		: {align: 'left'},
				items		: [{
					boxLabel: '발생일', 
					width	: 70, 
					name	: 'DATE_DIVI',
	    			inputValue: 'C'
				},{
					boxLabel: '실행일', 
					width	: 60,
					name	: 'DATE_DIVI',
	    			inputValue: 'B',
					checked	: true  
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						if(Ext.getCmp('rdoSelect0').getChecked()[0].inputValue == 'C'){
							addResult.getField('EX_DATE').setReadOnly(true);
						} else {
							addResult.getField('EX_DATE').setReadOnly(false);
						}
					}
				}
			},{
	    		xtype		: 'radiogroup',		            		
				fieldLabel	: '작업구분',						            		
				id			: 'rdoSelect1',
				tdAttrs		: {align: 'left'},
				items		: [{
					boxLabel: '자동기표 대상', 
					width	: 120, 
					name	: 'WORK_DIVI',
	    			inputValue: 'Proc',
					checked	: true  
				},{
					boxLabel: '기표취소 대상', 
					width	: 120,
					name	: 'WORK_DIVI',
	    			inputValue: 'Canc'
				},{
					boxLabel: '전체', 
					width	: 90,
					name	: 'WORK_DIVI',
	    			inputValue: ''
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Proc'){
							panelSearch.setValue('AP_STS', '');
							panelResult.setValue('AP_STS', '');
							panelSearch.getField('AP_STS').setVisible(false);
							panelResult.getField('AP_STS').setVisible(false);
							
		       				Ext.getCmp('procCanc').enable();
		       				Ext.getCmp('procCanc2').enable();
		       				Ext.getCmp('procCanc').setText('개별자동기표');
		       				Ext.getCmp('procCanc2').setText('일괄자동기표');

						} else if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Canc'){
							panelSearch.getField('AP_STS').setVisible(true);
							panelResult.getField('AP_STS').setVisible(true);
							
		       				Ext.getCmp('procCanc').enable();
		       				Ext.getCmp('procCanc2').enable();
		       				Ext.getCmp('procCanc').setText('개별기표취소');
		       				Ext.getCmp('procCanc2').setText('일괄기표취소');
		       				
						} else if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == ''){
							panelSearch.getField('AP_STS').setVisible(true);
							panelResult.getField('AP_STS').setVisible(true);
							
		       				Ext.getCmp('procCanc').disable(true);
		       				Ext.getCmp('procCanc2').disable(true);
						}
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
                xtype: 'container',
                layout: {
                    type: 'hbox',
                    align: 'right'
                },
                width:200,
                margin: '0 0 1 0',
                tdAttrs : {padding  : '0 0 2 0', width: '100%', align : 'right'},
    //            tdAttrs: {align : 'right'/*,width:'100%',height:'100%'*/},
                items :[{
                    xtype:'button',
                    id: 'divisionButton',
    //                itemId: 'autoSignBtn',
                    text: '입금액분할',
                    width:100,
                    handler: function() {
                    	var selectRecords = masterGrid.getSelectedRecords();
              
                        if(Ext.isEmpty(selectRecords)){
                            Ext.Msg.alert('확인','입금액분할 처리할 데이터를 선택해 주세요.');
                        
                        }else if(selectRecords.length > 1){
                        	Ext.Msg.alert('확인','입금액분할 처리할 데이터를 하나만 선택해 주세요.');
                        }else if(selectRecords.length == 1){
                        	if(!Ext.isEmpty(selectRecords[0].get('EX_DATE')) || !Ext.isEmpty(selectRecords[0].get('EX_NUM'))){
                        		Ext.Msg.alert('확인','기표처리된 데이터는 입금액분할을 할 수 없습니다.');
                        	}else{
                            	divisionButtonStore.clearData();
                                selectRecords[0].phantom = true;
                                divisionButtonStore.insert(i, selectRecords[0]);
                            	
                                openDivisionWindow();
                        	}
                        }
                    }
                },{                
                    xtype   : 'button',
                    id      : 'specialButton',
                    text    : '인터페이스',
//                    tdAttrs : {padding  : '0 0 2 0', width: '100%', align : 'right'},
                    width   : 100,
                    handler : function() {
                        var param   = [];
                        var records = masterGrid.getSelectedRecords();
                        Ext.each(records, function(record, index) {
                            param.push(record.data);
                        });
                        
                        if (Ext.isEmpty(param)) {
                            alert (Msg.sMA0256);                                    //선택된 자료가 없습니다.
                            return false;
                        
                        } else {
                            abh300ukrService.runInterface(param, function(provider, response) {
    
                            });
                        }
                    }
                }]
			},{
				fieldLabel	: '전표귀속사업장',
				name		: 'DIV_CODE' ,          
				xtype		: 'uniCombobox' ,
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				allowBlank	: false
			},{//count
				xtype	: 'uniTextfield',
				name	: 'COUNT',
				hidden	: true
			},{	//컬럼 맞춤용
				xtype	: 'component'
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable'},
			 	tdAttrs	: {align: 'right', width: '100%'},
			 	padding	: '0 0 3 0',
			 	colspan	: 2,
				items	: [{
					fieldLabel	: '입금액 합계',
					name		: 'SELECTED_AMT', 
					xtype		: 'uniNumberfield',
					value		: '0',
					readOnly	: true
				},{	//컬럼 맞춤용
					xtype	: 'component',
					width	: 30
				},{				   
					xtype	: 'button',
					//name	: 'CONFIRM_CHECK',
					id		: 'procCanc',
					text	: '개별자동기표',
					width	: 100,
					handler : function() {
						var records = masterGrid.getSelectedRecords();
						if(!addResult.getInvalidMessage()) {											//addResult의 필수값 체크
							return false;
						}
						if (Ext.isEmpty(records)) {
							alert (Msg.sMA0256);														//선택된 자료가 없습니다.
							return false;
						}
						if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Proc') {					//자동기표 "실행"일 때~~~
				            var buttonFlag	= 'N';								//자동기표 FLAG
				            var procType	= 'C';								//C:개별, B:일괄
				            fnMakeLogTable(buttonFlag, procType);							//자동기표취소 FLAG

						} else if (Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Canc') {			//자동기표 "취소"일 때~~~
				            var buttonFlag	= 'D';
				            var procType	= 'C';								//C:개별, B:일괄
				            fnMakeLogTable(buttonFlag, procType);
						}
					}
				},{				   
					xtype	: 'button',
					//name: 'CONFIRM_CHECK',
					id		: 'procCanc2',
					text	: '일괄자동기표',
					width	: 100,
					handler : function() {
						var records = masterGrid.getSelectedRecords();
						if(!addResult.getInvalidMessage()) {											//addResult의 필수값 체크
							return false;
						}
						if (Ext.isEmpty(records)) {
							alert (Msg.sMA0256);														//선택된 자료가 없습니다.
							return false;
						} 
						if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Proc') {					//자동기표 "실행"일 때~~~
				            var buttonFlag	= 'N';								//자동기표 FLAG
				            var procType	= 'B';								//C:개별, B:일괄
				            fnMakeLogTable(buttonFlag, procType);							//자동기표취소 FLAG

						} else if (Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Canc') {			//자동기표 "취소"일 때~~~
				            var buttonFlag	= 'D';								//자동기표 FLAG
				            var procType	= 'B';								//C:개별, B:일괄
				            fnMakeLogTable(buttonFlag, procType);							//자동기표취소 FLAG
						}
					}
				}]
			}]
		}]
	});

		        
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('abh300ukrGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	excelTitle: '미착대체자동기표',
        uniOpt: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: true,	
		    useGroupSummary		: true,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: false,	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
		tbar: [{
			xtype: 'button',
			text: '자동기표조회',
			itemId: 'btnViewAutoSlip',
			handler: function() {
				var record = masterGrid.getSelectedRecord();
				
				if(Ext.isEmpty(record)){
					alert(Msg.sMA0256);
					return false;	
				} else {
					if(Ext.isEmpty(record.data.EX_NUM)){
						alert('결의일이 없는 데이터는 조회할 수 없습니다.'/*Msg.sMA0256*/);
						return false;	
					}
				}

				var params = {
					'PGM_ID'	: 'abh300ukr',
					'DIV_CODE'	: record.data.DIV_CODE,
					'SLIP_NUM'	: record.data.EX_NUM,
					'EX_DATE'	: record.data.EX_DATE,
					'EX_SEQ'	: '1',						//회계전표순번
					'AP_STS'	: '', 
					'INPUT_PATH': '70'						//이체지급자동기표
				}
				var rec = {data : {prgID : 'agj105ukr', 'text':''}};       
				parent.openTab(rec, '/accnt/agj105ukr.do', params);
			}
        }],
    	store: masterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
    		listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					selectedAmt = selectedAmt + selectRecord.data.INOUT_AMT_I;
					addResult.setValue('SELECTED_AMT', selectedAmt)
    			},
    			
	    		deselect:  function(grid, selectRecord, index, rowIndex, eOpts ){
					selectedAmt = selectedAmt - selectRecord.data.INOUT_AMT_I;
					addResult.setValue('SELECTED_AMT', selectedAmt)
	    		}
    		}
        }),
        columns:  [{
				xtype	: 'rownumberer', 
				sortable: false, 
				//locked: true, 
				width	: 35,
				align	: 'center  !important',
				resizable: true
			},
//			{ dataIndex: 'SEQ'					,width:66	},
//			{ dataIndex: 'CHOICE'				,width:66	},
			{ dataIndex: 'BANK_NAME'			,width:100	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<span style= "color:' + 'blue' + '">' + Msg.sMAP025 + '</span>');
            	}
            },
			{ dataIndex: 'SAVE_CODE'			,width:100	},
			{ dataIndex: 'SAVE_NAME'			,width:160	},
			{ dataIndex: 'BANK_ACCOUNT'			,width:120	,hidden: true},
        	{ dataIndex: 'BANK_ACCOUNT_EXPOS'   ,width:120 },
        	{ dataIndex: 'ACCNT'                ,width:100, 
                editor: Unilite.popup('ACCNT_G', {
                    autoPopup: true,
                    DBtextFieldName: 'ACCNT_CODE',
                    listeners: {
                    	'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                Ext.each(records, function(record,i) {  
                                	if (record.JAN_DIVI == '1' && record.PEND_YN == 'Y') {
                                		alert ("미결계정은 입력할 수 없습니다.");
                                        grdRecord.set('ACCNT', '');
                                        grdRecord.set('ACCNT_NAME', '');
                                        
                                	} else {
                                        grdRecord.set('ACCNT', record['ACCNT_CODE']);
                                        grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
                                	}
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('ACCNT', '');
                            grdRecord.set('ACCNT_NAME', '');
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N'"});           //WHERE절 추가 쿼리
                        }
                    }
                 }) 
            },              
            {dataIndex: 'ACCNT_NAME'        , minWidth: 190, flex: 1, 
                autoPopup: true,
                editor: Unilite.popup('ACCNT_G', {
					autoPopup:true,
                    listeners: {
                    	'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                Ext.each(records, function(record,i) {  
                                    if (record.JAN_DIVI == '1' && record.PEND_YN == 'Y') {
                                        alert ("미결계정은 입력할 수 없습니다.");
                                        grdRecord.set('ACCNT', '');
                                        grdRecord.set('ACCNT_NAME', '');
                                        
                                    } else {
                                        grdRecord.set('ACCNT', record['ACCNT_CODE']);
                                        grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
                                    }
                                }); 
                            },
                                scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('ACCNT', '');
                            grdRecord.set('ACCNT_NAME', '');
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N'"});           //WHERE절 추가 쿼리
                        }
                    }
                 })
            },
        	{ dataIndex: 'DEPT_CODE'            ,width:100,
        	   editor: Unilite.popup('DEPT_G', {
                    autoPopup: true,
//                  textFieldName: 'TREE_CODE',
                    DBtextFieldName: 'TREE_CODE',
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                    var rtnRecord = masterGrid.uniOpt.currentRecord;    
                                    rtnRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
                                    rtnRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
                                },
                            scope: this 
                            },
                            'onClear': function(type) {
                                var rtnRecord = masterGrid.uniOpt.currentRecord;    
                                    rtnRecord.set('DEPT_CODE', '');
                                    rtnRecord.set('DEPT_NAME', '');
                            },
                            applyextparam: function(popup){
                                
                            }                                   
                        }
                })
        	},
        	{ dataIndex: 'DEPT_NAME'            ,width:100 ,
        	   editor: Unilite.popup('DEPT_G', {
                    autoPopup: true,
//                  textFieldName: 'TREE_CODE',
                    DBtextFieldName: 'TREE_NAME',
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                    var rtnRecord = masterGrid.uniOpt.currentRecord;    
                                    rtnRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
                                    rtnRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
                                },
                            scope: this 
                            },
                            'onClear': function(type) {
                                var rtnRecord = masterGrid.uniOpt.currentRecord;    
                                    rtnRecord.set('DEPT_CODE', '');
                                    rtnRecord.set('DEPT_NAME', '');
                            },
                            applyextparam: function(popup){
                                
                            }                                   
                        }
                })
        	},
			{ dataIndex: 'INOUT_DATE'			,width:100	},
			{ dataIndex: 'INOUT_AMT_I'			,width:120		,summaryType: 'sum'		,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">' + '<span style= "color:' + 'blue' + '">' + Ext.util.Format.number(value,'0,000') + '</span>' + '</div>');
            	}
            },
			{ dataIndex: 'REMARK'				,width:200	},
			{ dataIndex: 'IN_GUBUN'				,width:100	},
			{ dataIndex: 'CUSTOM_CODE'			,width:100		, 
				'editor': Unilite.popup('CUST_G',{
        	  	 	textFieldName : 'CUSTOM_NAME',
					autoPopup:true,
        	  	 	listeners: { 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
    						grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
    						
	                    },
	                    scope: this
	                  },
	                  'onClear' : function(type)	{
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('CUSTOM_CODE','');
    						grdRecord.set('CUSTOM_NAME','');
	                  }
        	  	 	}
				})
  		 	},
			{ dataIndex: 'CUSTOM_NAME'			,width:130		, 
				'editor': Unilite.popup('CUST_G',{
        	  	 	textFieldName : 'CUSTOM_NAME',
					autoPopup:true,
        	  	 	listeners: { 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
    						grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
    						
	                    },
	                    scope: this
	                  },
	                  'onClear' : function(type)	{
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('CUSTOM_CODE','');
    						grdRecord.set('CUSTOM_NAME','');
	                  }
        	  	 	}
				})
	 		},
			{ dataIndex: 'REMARK2'				,width:200	},
			{ dataIndex: 'EX_DATE'				,width:100	},
			{ dataIndex: 'EX_NUM'				,width:100	},
			{ dataIndex: 'EX_INFO'				,width:130		,hidden: true},
			{ dataIndex: 'AP_STS'				,width:100	},
			{ dataIndex: 'AP_STS_NM'			,width:100		,hidden: true},
			{ dataIndex: 'IN_REFT_NO'			,width:100	},
			{ dataIndex: 'REFER_PATH'			,width:130	},
			{ dataIndex: 'TYPE_FLAG'			,width:80		,hidden: true},
			{ dataIndex: 'AUTO_NUM'				,width:50		,hidden: true},
			{ dataIndex: 'COMP_CODE'			,width:80		,hidden: true},
			{ dataIndex: 'DIV_CODE'				,width:80		,hidden: true}
        ],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(!UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME', 'REMARK2', 'IN_GUBUN', 'BANK_ACCOUNT_EXPOS', 'ACCNT', 'ACCNT_NAME','DEPT_CODE','DEPT_NAME'])){
					return false;
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="BANK_ACCOUNT_EXPOS") {
					grid.ownerGrid.openCryptAcntNumPopup(record);
				}
			}	
		},
		openCryptAcntNumPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);
			}
				
		}
    });   
    
    var divisionForm = Unilite.createForm('divisionForm',{
        region: 'center',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
        flex: 1,
        disabled:false,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            padding:'0 0 0 0',
            items :[{
            	xtype: 'uniTextfield',
                fieldLabel:'AUTO_NUM',
                name:'AUTO_NUM',
                readOnly:true,
                hidden:true  
    		},{
                xtype: 'uniTextfield',
                fieldLabel:'은행명',
                name:'BANK_NAME',
                readOnly:true,
                colspan:2
            },{
                xtype: 'uniTextfield',
                fieldLabel:'통장코드',
                name:'SAVE_CODE',
                readOnly:true
            },{
                xtype: 'uniTextfield',
                fieldLabel:'통장명',
                name:'SAVE_NAME',
                readOnly:true
            },
            Unilite.popup('ACCNT',{
                fieldLabel: '계정과목', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'ACCNT',
                textFieldName:'ACCNT_NAME',
                readOnly:true,
    //                  validateBlank:'text',
                listeners: {
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'ADD_QUERY' : "(ISNULL(PROFIT_DIVI,'') IN ('X') OR LEFT(SPEC_DIVI,'1') = 'B')"
    //                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
                }
            }),
            Unilite.popup('DEPT',{
                fieldLabel: '부서코드', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'DEPT_CODE',
                textFieldName:'DEPT_NAME',
                readOnly:true,
    //                  validateBlank:'text',
                extParam: {
                
                }
            })
            ]
        },{
            title: '분할대상',
            xtype: 'fieldset',
            id: 'fieldset1',
            padding: '0 5 5 0',
            margin: '0 0 0 0',
            layout: {type: 'uniTable' , columns: 2
//                    tdAttrs: {style: 'border : 1px solid #ced9e7;'}
            },
            items: [{
                xtype: 'uniDatefield',
                fieldLabel:'입금일자',
                name:'INOUT_DATE_ORIGINAL',
                readOnly:true
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'입금액 원금액',
                name:'INOUT_AMT_I',
                readOnly:true,
                hidden:false
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'입금액',
                name:'INOUT_AMT_I_ORIGINAL',
                colspan : 2,
                readOnly:true
            },{
                xtype: 'textareafield',
                fieldLabel: '적요',
                name:'REMARK_ORIGINAL',
                grow : true,
                width : 650,
                height : 50,
                colspan : 2,
                readOnly: false
            }
    			
    				
    					/*{
                xtype: 'uniTextfield',
                fieldLabel:'적요',
                name:'REMARK',
                width:735,
                colspan:3,
                readOnly:false
            }*/]
        },{
            title: '분할',
            xtype: 'fieldset',
            id: 'fieldset2',
            padding: '0 5 5 0',
            margin: '0 0 0 0',
            layout: {type: 'uniTable' , columns: 2
//                    tdAttrs: {style: 'border : 1px solid #ced9e7;'}
            },
            items: [{
                xtype: 'uniDatefield',
                fieldLabel:'입금일자',
                name:'INOUT_DATE_DIVISION',
                allowBlank:false,
                readOnly:false
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'입금액',
                name:'INOUT_AMT_I_DIVISION',
                allowBlank:false,
                readOnly:false,
                listeners:{
                    change: function(field, newValue, oldValue, eOpts) {
                    	if(divisionForm.getValue('INOUT_AMT_I_ORIGINAL') - newValue < 0){
                    	   alert("분할 한 금액이 분할대상 금액을 초과 할 수 없습니다.");
                    	   divisionForm.setValue('INOUT_AMT_I_DIVISION',0);
                    	   divisionForm.setValue('INOUT_AMT_I_ORIGINAL',divisionForm.getValue('INOUT_AMT_I'));
                    	}else if(newValue < 0){
                    	   alert("분할되는 대상 금액이 분할되기 전 금액을 초과 할 수 없습니다.");
                           divisionForm.setValue('INOUT_AMT_I_DIVISION',0);
                           divisionForm.setValue('INOUT_AMT_I_ORIGINAL',divisionForm.getValue('INOUT_AMT_I'));
                    	}else if(Ext.isEmpty(newValue)){
                    	   divisionForm.setValue('INOUT_AMT_I_DIVISION',0);
                    	   divisionForm.setValue('INOUT_AMT_I_ORIGINAL',divisionForm.getValue('INOUT_AMT_I'));
            			}else {
                    	   divisionForm.setValue('INOUT_AMT_I_ORIGINAL',divisionForm.getValue('INOUT_AMT_I') - newValue);	
                    	}
                    }
                }
            },
        	Unilite.popup('ACCNT',{
                fieldLabel: '계정과목', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'ACCNT_DIVISION',
                textFieldName:'ACCNT_NAME_DIVISION',
    //                  validateBlank:'text',
                listeners: {
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'ADD_QUERY' : "(ISNULL(PROFIT_DIVI,'') IN ('X') OR LEFT(SPEC_DIVI,'1') = 'B')"
    //                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
                }
                
            }),
            Unilite.popup('DEPT',{
                fieldLabel: '부서코드', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'DEPT_CODE_DIVISION',
                textFieldName:'DEPT_NAME_DIVISION',
                colspan:2,
    //                  validateBlank:'text',
                extParam: {
                
                }
            }),
            {
                xtype: 'textareafield',
                fieldLabel: '적요',
                name:'REMARK_DIVISION',
                grow : true,
                width : 650,
                height : 50,
                colspan : 2,
                readOnly: false
            }
            /*{
                xtype: 'uniTextfield',
                fieldLabel:'적요',
                name:'REMARK_DIVISION',
                width:735,
                colspan:3,
                readOnly:false
            }*/]
        }]
    });
    function openDivisionWindow() {          
        if(!divisionWindow) {
            divisionWindow = Ext.create('widget.uniDetailWindow', {
                title: '입금액분할',
                width: 690,                                
                height: 420,
                minWidth:690,
                maxWidth:690,
                minHeight:420,
                maxHeight:420,
                layout:{type:'vbox', align:'stretch'},
                items: [divisionForm],
                tbar:  [
                    '->',{
//                        itemId : 'Btn',
                        text: '분할',
                        handler: function() {
                            if(!divisionForm.getInvalidMessage()) return; 
                            
                /*            var searchRecords = directSearchStore.data.items;
                            buttonStore.clearData();
                            Ext.each(searchRecords, function(record,i){
                                if(record.get('SELECT') == true){
                                    record.phantom = true;
                                    buttonStore.insert(i, record);
                                }
                            });
                            
                            buttonFlag = 'btnConf';
                            preEmpNo = searchForm.getValue('CARD_EXPENSE_ID');
                            nxtEmpNo =  divisionForm.getValue('PERSON_NUMB');
                            transDesc = divisionForm.getValue('TRANS_DESC');
                            
                            buttonStore.saveStore();
                            */
                            
                            divisionButtonStore.saveStore();
                            divisionWindow.hide();
                            divisionForm.clearForm();
                        },
                        disabled: false
                    },{
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            divisionWindow.hide();
                            divisionForm.clearForm();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    },
                    show: function ( panel, eOpts ) {
                    	var selectRecords = masterGrid.getSelectedRecords();
                    	divisionForm.setValue('AUTO_NUM',    selectRecords[0].get('AUTO_NUM'));
                    	divisionForm.setValue('BANK_NAME',   selectRecords[0].get('BANK_NAME'));
                    	divisionForm.setValue('SAVE_CODE',   selectRecords[0].get('SAVE_CODE'));
                    	divisionForm.setValue('SAVE_NAME',   selectRecords[0].get('SAVE_NAME'));
                    	divisionForm.setValue('INOUT_DATE_ORIGINAL',  selectRecords[0].get('INOUT_DATE'));
                    	divisionForm.setValue('INOUT_AMT_I', selectRecords[0].get('INOUT_AMT_I'));
                    	divisionForm.setValue('INOUT_AMT_I_ORIGINAL', selectRecords[0].get('INOUT_AMT_I'));
                    	divisionForm.setValue('REMARK_ORIGINAL',    	 selectRecords[0].get('REMARK'));
                    	
                    	divisionForm.setValue('INOUT_DATE_DIVISION', UniDate.get('today'));
                    	divisionForm.setValue('INOUT_AMT_I_DIVISION', 0);
                    	
                    }
                }
            })
        }
        divisionWindow.center();
        divisionWindow.show();
    }
	
    var decrypBtn = Ext.create('Ext.Button',{
        text:'복호화',
        width: 80,
        handler: function() {
            var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
            if(needSave){
               alert(Msg.sMB154); //먼저 저장하십시오.
               return false;
            }
            panelSearch.setValue('DEC_FLAG', 'Y');
            UniAppManager.app.onQueryButtonDown();
            panelSearch.setValue('DEC_FLAG', '');
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
		id: 'abh300ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('DATE_TO', UniDate.get('today'));
			panelResult.setValue('DATE_TO', UniDate.get('today'));
			addResult.setValue('EX_DATE', UniDate.get('today'));

			panelSearch.getField('AP_STS').setVisible(false);
			panelResult.getField('AP_STS').setVisible(false);

			addResult.getField('WORK_DIVI').setValue('1');
			addResult.getField('EX_DATE').setReadOnly(true);
   			Ext.getCmp('procCanc').setText('개별자동기표');
   			Ext.getCmp('procCanc2').setText('일괄자동기표');

	   		addResult.setValue('SELECTED_AMT', 0);
	   		
	   		masterGrid.down('#btnViewAutoSlip').disable(true);	//자동기표조회

			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
            
			var tbar = masterGrid._getToolBar();
            tbar[0].insert(tbar.length + 1, decrypBtn);
            
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('DATE_FR');		
		},
		
		onQueryButtonDown : function()	{			
			if(!this.isValidSearchForm()){
				return false;
			}
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			masterGrid.reset();
			masterStore.clearData();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			masterStore.loadStoreRecords();	
		},

		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();						
			console.log("selRow",selRow);
			
			if (selRow.phantom == true) {
				masterGrid.deleteSelectedRow();
				
			} else if (confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {			//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();
				UniAppManager.setToolbarButtons('save'	, true);
			}
		},
		
		onDeleteAllButtonDown: function() {			
			var records = masterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm(Msg.sMB064)) {			//전체삭제 하시겠습니까?
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
		},
		
		onSaveDataButtonDown: function(config) {
			if(!this.isValidSearchForm()) {
				return false;
			}
//			if(!addResult.getInvalidMessage()) {
//				return false;
//			}
			masterStore.saveStore();
		},
		
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			addResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			newYN = 1;
			this.fnInitBinding();
		}
	});
	
	function fnMakeLogTable(buttonFlag, procType) {
		records = masterGrid.getSelectedRecords();

		buttonStore.clearData();															//buttonStore 클리어
		Ext.each(records, function(record, index) {
            record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;											//자동기표 flag
			record.data.PROC_TYPE	= procType;												//개별/일괄 flag
			record.data.PROC_DATE	= UniDate.getDbDateStr(addResult.getValue('EX_DATE'));	//일괄자동기표일 때 전표일자 처리용(전표일)
            
            buttonStore.insert(index, record);
            
			//KEY_STRING이 같은 데이터는 한번만 실행
/*			if(!Ext.isEmpty(record.data.get('KEY_STRING'))) {								//자동기표는 KEY_STRING 값이 없으므로 그냥 진행						
            	buttonStore.insert(index, record);
			
			} else {																		//기표취소의 경우 KEY_STRING이 같으면 한번만 store에 insert
				var keyFlag = true;
				buttonRecords = buttonStore.getValues();
				Ext.each(buttonRecords, function(buttonRecord, i) {
					if(buttonRecord.data.get('KEY_STRING') == record.data.get('KEY_STRING')) {
						keyFlag = false;
					}
				});
				
				if (keyFlag) {
    				buttonStore.insert(index, record);
				}
			}	*/
			
			if (records.length == index +1) {
                buttonStore.saveStore(buttonFlag);
			}
		});
	}
};

</script>
