<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham820ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 --> 
	<t:ExtComboStore comboType="A"  comboCode="A118" /> 			<!-- 소득구분 -->
	<t:ExtComboStore comboType="A" comboCode="H032" />				<!-- 지급구분 -->
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var buttonFlag ='';
var newYN = 'N';

function appMain() {
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'ham820ukrService.insertDetailAutoSign',
            syncAll	: 'ham820ukrService.saveAllAutoSign'
		}
	});	

	
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ham820ukrModel1', {
		fields: [
	    	{name: 'PAY_YYYYMM'		 			,text: '급여년월' 			,type: 'string'  },
	    	{name: 'SUPP_TYPE'		 			,text: '지급구분' 			,type: 'string'  	, comboType: "A"		, comboCode: "H032"},
	    	{name: 'PERSON_NUMB'	 			,text: '사번' 			,type: 'string'  },
	    	{name: 'PERSON_NAME'	 			,text: '성명' 			,type: 'string'  },
			{name: 'REPRE_NUM'					,text: '주민등록번호'		,type: 'string'  }, 
			{name: 'REPRE_NUM_EXPOS'			,text: '주민등록번호'		,type: 'string'		, defaultValue: '*************'}, 
	    	{name: 'DIV_CODE'		 			,text: '사업장' 			,type: 'string'		, allowBlank: false		, comboType:'BOR120'},
	    	{name: 'PAY_YYYY'		 			,text: '귀속년' 			,type: 'string'  },
	    	{name: 'QUARTER_TYPE'	 			,text: '귀속분기' 			,type: 'string'  },
	    	{name: 'SUPP_YYYYMM'	 			,text: '지급년월' 			,type: 'string'  },
	    	{name: 'SUPP_DATE'		 			,text: '지급일자' 			,type: 'uniDate' },
	    	{name: 'WORK_MM'		 			,text: '근무월'	 		,type: 'string'  },
	    	{name: 'WORK_DAY'		 			,text: '근무일수'			,type: 'int'     },
	    	{name: 'SUPP_TOTAL_I'	 			,text: '지급액' 			,type: 'uniPrice'},
	    	{name: 'REAL_AMOUNT_I'	 			,text: '실지급액' 			,type: 'uniPrice'},
	    	{name: 'TAX_EXEMPTION_I'		 	,text: '비과세소득'			,type: 'uniPrice'},
	    	{name: 'IN_TAX_I'	 				,text: '소득세' 			,type: 'uniPrice'},
	    	{name: 'LOCAL_TAX_I'	 			,text: '주민세' 			,type: 'uniPrice'},
	    	{name: 'ANU_INSUR_I'		 		,text: '국민연금' 			,type: 'uniPrice'},
	    	{name: 'MED_INSUR_I'	 			,text: '의료보험금액' 		,type: 'uniPrice'},
	    	{name: 'HIR_INSUR_I'		 		,text: '고용보험금액' 		,type: 'uniPrice'},
	    	{name: 'BUSI_SHARE_I'		 		,text: '사회보험사업자부담금' 	,type: 'uniPrice'},
	    	{name: 'WORKER_COMPEN_I'		 	,text: '사업자산재보험부담금' 	,type: 'uniPrice'},
	    	{name: 'EX_DATE'		 			,text: '결의전표일' 		,type: 'uniDate' },
	    	{name: 'EX_NUM'			 			,text: '결의전표번호' 		,type: 'int'     },
	    	{name: 'AC_DATE'		 			,text: '회계전표일' 		,type: 'uniDate' },
	    	{name: 'SLIP_NUM'			 		,text: '회계전표번호' 		,type: 'int'	 },
	    	{name: 'PJT_CODE'					,text: '사업/제품코드' 		,type: 'string'	 },
	    	{name: 'INSERT_DB_USER'			 	,text: '일력자' 			,type: 'string'	 },
	    	{name: 'INSERT_DB_TIME'				,text: '입력일' 			,type: 'string'	 },
	    	{name: 'UPDATE_DB_USER'			 	,text: '수정자' 			,type: 'string'	 },
	    	{name: 'UPDATE_DB_TIME'				,text: '수정일'	 		,type: 'string'	 }
		]
	});
	
	
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('ham820ukrdirectDetailStore',{
		model	: 'Ham820ukrModel1',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 	
			deletable	: false,		// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: {
            type: 'direct',
            api	: {			
            	   read: 'ham820ukrService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}			
	});

    var autoSignButtonStore = Unilite.createStore('Ham820UkrButtonStore',{      
        uniOpt	: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,      		// 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy	: directButtonProxy,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            var paramMaster = panelResult.getValues();  //syncAll 수정
            paramMaster.SUPP_DATE_FR = UniDate.getDbDateStr(panelResult.getValue('SUPP_DATE_FR'));
            paramMaster.SUPP_DATE_TO = UniDate.getDbDateStr(panelResult.getValue('SUPP_DATE_TO'));
            
            paramMaster.BUTTON_FLAG = buttonFlag;
            paramMaster.WORK_GUBUN = Ext.getCmp('rdoSelect1').getChecked()[0].inputValue;
            if(buttonFlag == 'BATCH'){
                paramMaster.WORK_DATE = UniDate.getDbDateStr(subForm.getValue('WORK_DATE'));
            }else if(buttonFlag == 'LIST'){
            	paramMaster.WORK_DATE = UniDate.getDbDateStr(subForm.getValue('WORK_DATE'));
            }else{
                paramMaster.WORK_DATE = '';
            }
            
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
                var grid = Ext.getCmp('ham820ukrGrid');
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
		title		: '검색조건',		
        defaultType	: 'uniSearchSubPanel',
        collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
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
    			fieldLabel	: '지급일',
		        xtype		: 'uniDateRangefield',
		        startFieldName	: 'SUPP_DATE_FR',
		        endFieldName	: 'SUPP_DATE_TO',
		        startDate	: UniDate.get('startOfMonth'),
		        endDate		: UniDate.get('today'),
		        allowBlank	: false,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('SUPP_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SUPP_DATE_TO',newValue);
			    	}
			    }
			},
		    Unilite.popup('EARNER',{
		        fieldLabel		: '소득자',
		        validateBlank	: false,
			    valueFieldName	: 'PERSON_NUMB',
			    textFieldName	: 'PERSON_NAME',
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}//,
//					applyextparam: function(popup){							
//						popup.setExtParam({'DED_TYPE': '9'});									//소득자타입(9:일용직근로소득)
//						popup.setExtParam({'SECT_CODE': panelSearch.getValue('SECT_CODE')});	//신고사업장
//					}
				}
			}),{
				fieldLabel	: '입력일',
	            xtype		: 'uniDateRangefield',
	            startFieldName	: 'INSERT_DATE_FR',
	            endFieldName	: 'INSERT_DATE_TO',
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
	     	},
			Unilite.popup('ACCNT_PRSN',{ 
			    fieldLabel		: '입력자', 
				valueFieldName	: 'CHARGE_CODE',
				textFieldName	: 'CHARGE_NAME',
			    validateBlank	: false,
				listeners:		 {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CHARGE_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CHARGE_NAME', newValue);				
					}
				}
			}),{
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
			Unilite.treePopup('PJT_TREE',{ 
		    	fieldLabel		: '사업코드',
		    	valueFieldName	: 'PJT_CODE',
				textFieldName	: 'PJT_NAME',
				valuesName		: 'DEPTS' ,
				selectChildren	: true,
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName	: 'PJT_NAME',
				autoPopup		: true,
				useLike			: false,
		    	listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	panelResult.setValue('PJT_CODE',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    	panelResult.setValue('PJT_NAME',newValue);
					},
	                'onValuesChange':  function( field, records){
                    	var tagfield = panelResult.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
	                }
				}
			}),{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
                width:600,
                items :[{
                    xtype: 'radiogroup',                            
                    fieldLabel: '작업구분',
                    id: 'rdoSelect',
                    items: [{
                        boxLabel: '자동기표', 
                        width: 70,
                        name: 'ACCEPT_STATUS',
                        inputValue: '1',
                        checked: true  
                    },{
                        boxLabel: '기표취소', 
                        width: 70,
                        name: 'ACCEPT_STATUS',
                        inputValue: '2'
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.getField('ACCEPT_STATUS').setValue(newValue.ACCEPT_STATUS);         
                            
                            if(newValue.ACCEPT_STATUS == '1'){
                                Ext.getCmp('autoSignBtn1').setHidden(false);
                                Ext.getCmp('autoSignBtn2').setHidden(false);
                                Ext.getCmp('autoSignBtn3').setHidden(true);
                                
                            }else if(newValue.ACCEPT_STATUS == '2'){
                                Ext.getCmp('autoSignBtn1').setHidden(true);
                                Ext.getCmp('autoSignBtn2').setHidden(true);
                                Ext.getCmp('autoSignBtn3').setHidden(false);
                            }
                        }
                    }
                }]
            }]		
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 3	
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{ 
			fieldLabel	: '지급일',
	        xtype		: 'uniDateRangefield',
	        startFieldName	: 'SUPP_DATE_FR',
	        endFieldName	: 'SUPP_DATE_TO',
	        startDate	: UniDate.get('startOfMonth'),
	        endDate		: UniDate.get('today'),
	        allowBlank	: false,
            tdAttrs		: {width: 380},    
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('SUPP_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('SUPP_DATE_TO',newValue);
		    	}
		    }
        },
	    Unilite.popup('EARNER',{
	        fieldLabel	: '소득자',
		    valueFieldName	:'PERSON_NUMB',
		    textFieldName	:'PERSON_NAME',
		    tdAttrs		: {width: 380},  
	        validateBlank:false,  
	        colspan		: 2,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}//,
//				applyextparam: function(popup){
//					popup.setExtParam({'DED_TYPE': '9'});									//소득자타입(9:일용직근로소득)
//					popup.setExtParam({'SECT_CODE': panelResult.getValue('SECT_CODE')});	//신고사업장
//				}
			}
		}),{
			fieldLabel	: '입력일',
            xtype		: 'uniDateRangefield',
            startFieldName	: 'INSERT_DATE_FR',
            endFieldName	: 'INSERT_DATE_TO',
            tdAttrs		: {width: 380},    
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
			xtype		: 'component'								//panel 모양 맞춤용
		},{ 
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			value		: UserInfo.divCode,
			comboType	: 'BOR120',
            tdAttrs		: {width: 380}, 
			multiSelect	: true, 
			typeAhead	: false,   
			listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DIV_CODE', newValue);
		    	}
     		}
		},
		Unilite.treePopup('PJT_TREE',{ 
	    	fieldLabel		: '사업코드',
	    	valueFieldName	: 'PJT_CODE',
			textFieldName	: 'PJT_NAME',
			valuesName		: 'DEPTS' ,
			selectChildren	: true,
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName	: 'PJT_NAME',
			autoPopup		: true,
			useLike			: false,
	    	listeners: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	panelSearch.setValue('PJT_CODE',newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    	panelSearch.setValue('PJT_NAME',newValue);
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}
		}),{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            items :[{
                xtype: 'radiogroup',                            
                fieldLabel: '작업구분',
                items: [{
                    boxLabel: '자동기표', 
                    width: 70,
                    name: 'ACCEPT_STATUS',
                    inputValue: '1',
                    checked: true  
                },{
                    boxLabel: '기표취소', 
                    width: 70,
                    name: 'ACCEPT_STATUS',
                    inputValue: '2' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.getField('ACCEPT_STATUS').setValue(newValue.ACCEPT_STATUS); 
                        
                        if(newValue.ACCEPT_STATUS == '1'){
                            Ext.getCmp('autoSignBtn1').setHidden(false);
                            Ext.getCmp('autoSignBtn2').setHidden(false);
                            Ext.getCmp('autoSignBtn3').setHidden(true);
                            
                        }else if(newValue.ACCEPT_STATUS == '2'){
                            Ext.getCmp('autoSignBtn1').setHidden(true);
                            Ext.getCmp('autoSignBtn2').setHidden(true);
                            Ext.getCmp('autoSignBtn3').setHidden(false);
                        }
                        if (newYN == 'Y'){      //신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
                            newYN = 'N';
                            return false;
                        }else {
                            UniAppManager.app.onQueryButtonDown();
                        }
                    }
                }
            }
        ]}]
    });  

    
    
    var subForm = Unilite.createForm('subForm', {   //createForm
        layout: {type : 'uniTable', columns : 4, tableAttrs:{width:'100%'},tdAttrs: {width: '100%'}},
        disabled: false,
        border: true,
        padding: '1 1 1 1',
        region: 'north',
        items: [{
            xtype: 'container',
            layout : {type : 'uniTable'},
            tdAttrs: {width: 380},    
            items:[{
                fieldLabel: '실행일',
                xtype: 'uniDatefield',
                name: 'WORK_DATE',
                value: UniDate.get('today'),
//                readOnly:true,
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
                    boxLabel: '지급일', 
                    width: 70, 
                    name: 'WORK_GUBUN',
                    inputValue: '1'
                },{
                    boxLabel : '실행일', 
                    width: 70,
                    name: 'WORK_GUBUN',
                    inputValue: '2',
                    checked: true  
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        if(newValue.WORK_GUBUN == '1'){
                            subForm.getField('WORK_DATE').setReadOnly(true);
                        }else{
                            subForm.getField('WORK_DATE').setReadOnly(false);
                        }
                    }
                }
            }]
        },{
            fieldLabel: '합계(선택)',
            xtype: 'uniNumberfield',
            name: 'SUM_SUPP_TOTAL_I',
            readOnly: true,
            tdAttrs: {align : 'right'}
        },{
            fieldLabel: '건수(선택)',
            xtype: 'uniNumberfield',
            name: 'SUM_COUNT',
            readOnly: true,
            tdAttrs: {align : 'right'}
        },{
            xtype: 'container',
            layout: {
                type: 'hbox',
                align: 'right'
            },
            width:200,
            margin: '0 0 1 0',
            items :[{
                xtype:'component',
                width:20
            },{
                xtype:'button',
                id: 'autoSignBtn1',
                text: '일괄자동기표',
                flex : 1,
                handler: function() {
                    if(!panelResult.getInvalidMessage()) return;
                    if(!subForm.getInvalidMessage()) return;
                    
                    if(subForm.getField('WORK_GUBUN').getValue() == '1'){
                        alert('지급일 일 경우 일괄자동기표를 할 수 없습니다.');
                        
                        return;
                    }
                    
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                    
                        autoSignButtonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            autoSignButtonStore.insert(i, record);
                        });
                        buttonFlag = 'BATCH';
                        autoSignButtonStore.saveStore();
                                                
                    }else{
                        Ext.Msg.alert('확인','일괄자동기표 할 데이터를 선택해 주세요.'); 
                    }
                }
            },{
                xtype:'button',
                id: 'autoSignBtn2',
                text: '개별자동기표',
                flex : 1,
                handler: function() {
                	if(!panelResult.getInvalidMessage()) return;
                    if(!subForm.getInvalidMessage()) return;
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                    
                        autoSignButtonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            autoSignButtonStore.insert(i, record);
                        });
                        buttonFlag = 'LIST';
                        autoSignButtonStore.saveStore();
                                                
                    }else{
                        Ext.Msg.alert('확인','개별자동기표 할 데이터를 선택해 주세요.'); 
                    }
                }
            },{
                xtype:'button',
                id: 'autoSignBtn3',
                text: '기표취소',
                flex : 1,
                handler: function() {
                	if(!panelResult.getInvalidMessage()) return;
                    if(!subForm.getInvalidMessage()) return;

                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                    
                        autoSignButtonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            autoSignButtonStore.insert(i, record);
                        });
                        buttonFlag = 'CANCEL';
                        autoSignButtonStore.saveStore();
                                                
                    }else{
                        Ext.Msg.alert('확인','기표취소 할 데이터를 선택해 주세요.'); 
                    }
                }
            }]
        }]
    });
	
    
    
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var detailGrid = Unilite.createGrid('ham820ukrGrid', {  	
    	store	: directDetailStore,
        layout	: 'fit',
        region	: 'center',
    	excelTitle: '일용급여자동기표',
        uniOpt	: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: false,	
		    useGroupSummary		: false,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
    	features: [ {id : 'detailGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
    	           	{id : 'detailGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
    		listeners: { 
    			beforeselect: function( grid , record , index , eOpts ) {
	    			//기표취소일 때, 승인여부가 승인이면 선택 안 됨 (atx110ukr로 링크와 관련해서 주석 - 기표 취소 로직에서 안되도록 수정)
	    			if (panelResult.getField('ACCEPT_STATUS').getValue() == '2'&& record.get('AP_STS') == '2') {
	    				alert('이미 승인된 자료는 기표취소할 수 없습니다.');
	    				return false;
	    			}
    			},  
    			
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){  
                    var payAmountI = subForm.getValue('SUM_SUPP_TOTAL_I');
                    subForm.setValue('SUM_SUPP_TOTAL_I',payAmountI + selectRecord.data.SUPP_TOTAL_I);
                    subForm.setValue('SUM_COUNT',grid.selected.length);
                },
                
                deselect:  function(grid, selectRecord, index, eOpts ){
                    var payAmountI = subForm.getValue('SUM_SUPP_TOTAL_I');
                    subForm.setValue('SUM_SUPP_TOTAL_I',payAmountI - selectRecord.data.SUPP_TOTAL_I);
//                  alert('선택해제');
                    subForm.setValue('SUM_COUNT',grid.selected.length);
                }
    		}
        }),
        columns:  [{
				xtype	: 'rownumberer', 
				width	: 35,
				align	: 'center  !important',
				sortable: false, 
				resizable: true
			},
			{ dataIndex: 'SUPP_TYPE'		 		, width:100		, hidden: true},
			{ dataIndex: 'PERSON_NUMB'	 			, width:100},
			{ dataIndex: 'PERSON_NAME'	 			, width:120},
			{ dataIndex: 'DIV_CODE'					, width:100},			
			{ dataIndex: 'REPRE_NUM'				, width:100		, hidden: true},			
			{ dataIndex: 'REPRE_NUM_EXPOS'			, width:100},
			{ dataIndex: 'PAY_YYYYMM'		 		, width:100		, align: 'center'},
			{ dataIndex: 'PAY_YYYY'		 			, width:100		, hidden: true},
			{ dataIndex: 'QUARTER_TYPE'	 			, width:100		, hidden: true},
			{ dataIndex: 'SUPP_YYYYMM'	 			, width:100		, hidden: true},
			{ dataIndex: 'SUPP_DATE'		 		, width:100},
			{ dataIndex: 'WORK_MM'		 			, width:100		, hidden: true},
			{ dataIndex: 'WORK_DAY'		 			, width:100},
			{ dataIndex: 'SUPP_TOTAL_I'	 			, width:120},
			{ dataIndex: 'TAX_EXEMPTION_I'		 	, width:120},
			{ dataIndex: 'IN_TAX_I'	 				, width:100},
			{ dataIndex: 'LOCAL_TAX_I'	 			, width:100},
			{ dataIndex: 'ANU_INSUR_I'		 		, width:100},
			{ dataIndex: 'MED_INSUR_I'	 			, width:100},
			{ dataIndex: 'HIR_INSUR_I'		 		, width:100},
			{ dataIndex: 'BUSI_SHARE_I'		 		, width:100},
			{ dataIndex: 'WORKER_COMPEN_I'		 	, width:100},
			{ dataIndex: 'REAL_AMOUNT_I'	 		, width:120},
			{ dataIndex: 'EX_DATE'		 			, width:100},
			{ dataIndex: 'EX_NUM'			 		, width:95		,
	        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					var r = val;
	        		if (Ext.isEmpty(record.get('EX_DATE'))) {
						r = '';
	        		}
	        		return r
	            }
			},
			{ dataIndex: 'AC_DATE'		 			, width:100}, 
			{ dataIndex: 'SLIP_NUM'			 		, width:95		,
	        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					var r = val;
	        		if (Ext.isEmpty(record.get('AC_DATE'))) {
						r = '';
	        		}
	        		return r
	            }
			},
			{ dataIndex: 'PJT_CODE'					, width:120}
		],
        listeners: {
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(colName =="REPRE_NUM_EXPOS") {
					grid.ownerGrid.openCryptRepreNoPopup(record);
				}
          	}
		},
    	openCryptRepreNoPopup:function( record )	{
		  	if(record)	{
				var params = {'REPRE_NO': record.get('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
			}
		} 
    });   

    
    
    Unilite.Main( {
    	borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelResult, subForm, detailGrid
            ]
        },
            panelSearch
        ], 
        id  : 'ham820ukrApp',
		fnInitBinding : function() {
			//각 기본값 설정
			panelSearch.setValue('SUPP_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('SUPP_DATE_TO', UniDate.get('today'));

			panelResult.setValue('SUPP_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('SUPP_DATE_TO', UniDate.get('today'));

			subForm.setValue('WORK_DATE', UniDate.get('today'));
			subForm.getField('WORK_GUBUN').setValue('2');
            
			subForm.setValue('SUM_COUNT',0);
            subForm.setValue('SUM_SUPP_TOTAL_I',0);
			
			panelSearch.getField('ACCEPT_STATUS').setValue('1');   
            panelResult.getField('ACCEPT_STATUS').setValue('1');   
            Ext.getCmp('autoSignBtn1').setHidden(false);
            Ext.getCmp('autoSignBtn2').setHidden(false);
            Ext.getCmp('autoSignBtn3').setHidden(true);
			
			//toolbar button 설정
			UniAppManager.setToolbarButtons(['newData', 'save', 'delete'], false);

			//화면 초기화 시 포커스 설정
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('SUPP_DATE_FR');		
			newYN = 'N';	
		},
		
		onQueryButtonDown : function()	{	
			if(!this.isValidSearchForm()){			//조회전 필수값 입력 여부 체크
				return false;
			}
			
			subForm.setValue('SUM_COUNT',0);
            subForm.setValue('SUM_SUPP_TOTAL_I',0);
			
			directDetailStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);
		},
		
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			subForm.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			newYN = 'Y';
			this.fnInitBinding();
		}
	});

};
</script>
