<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="abh200ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A134" /> <!-- 결재상태(그룹웨어) -->
	<t:ExtComboStore comboType="AU" comboCode="B038" /> <!-- 결재방법 -->
	
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="A101" /> <!-- 지급방법 -->
		<t:ExtComboStore comboType="AU" comboCode="B016" /> <!-- 사업자구분 -->
		
		<t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 승인상태 -->
		
		
		
		
		
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
	
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
var gsSaveCode   	= '${gsSaveCode}';
var gsSaveName   	= '${gsSaveName}';
var gsSaveAccount   = '${gsSaveAccount}';

var queryButtonFlag = '';

var queryButtonFlag2 = '';

var abh200ukrRef1Window; // 검색팝업 관련

function appMain() {
	var directProxyAutoSign = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'abh200ukrService.insertDetailAutoSign',
            syncAll: 'abh200ukrService.saveAllAutoSign'
        }
    }); 
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'abh200ukrService.selectMaster',
			update: 'abh200ukrService.updateMaster',
			create: 'abh200ukrService.insertMaster',
			destroy: 'abh200ukrService.deleteMaster',
			syncAll: 'abh200ukrService.saveAllMaster'
		}
	});	
	
	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'abh200ukrService.selectDetail',
			update: 'abh200ukrService.updateDetail',
			create: 'abh200ukrService.insertDetail',
			destroy: 'abh200ukrService.deleteDetail',
			syncAll: 'abh200ukrService.saveAllDetail'
		}
	});	
	
	
	Unilite.defineModel('abh200ukrMasterModel', {
	    fields: [
	    	{name: 'PAY_METH'		    ,text: '지급방법'		,type: 'string',allowBlank:false,comboType:'AU', comboCode:'A101'},
	    	{name: 'PAY_CODE'		    ,text: '코드'			,type: 'string',allowBlank:false},
	    	{name: 'PAY_NAME'		    ,text: '명칭'			,type: 'string'},
	    	{name: 'BANK_ACCOUNT_EXPOS'	,text: '계좌번호'		,type: 'string'},
	    	{name: 'BANK_ACCOUNT'	    ,text: '계좌번호(DB)'	,type: 'string'},
	    	{name: 'TOT_AMT_I'		    ,text: '이체금액'		,type: 'uniPrice'},
	    	{name: 'EX_DATE'		    ,text: '결의일자'		,type: 'string'},
	    	{name: 'EX_NUM'			    ,text: '결의번호'		,type: 'string'}
		]
	});
	
	Unilite.defineModel('abh200ukrDetailModel', {
	    fields: [
	    	{name: 'CHECK_VALUE'		,text: 'check'					,type: 'string'},
    		{name: 'CHECK_VALUE2'		,text: 'check2'					,type: 'string'},
//	    	{name: 'AGREE_YN'			,text: '승인여부'					,type: 'string'},
	    	{name: 'PRE_DATE'			,text: '지급예정일'					,type: 'uniDate'},
	    	{name: 'PAY_CUSTOM_CODE'	,text: '지급처'					,type: 'string'},//ABH220T
	    	{name: 'PAY_CUSTOM_NAME'	,text: '지급처명'					,type: 'string'},
	    	{name: 'COMPANY_NUM'		,text: '사업자번호'					,type: 'string'},
	    	{name: 'EX_YN'				,text: '지급여부'					,type: 'string',comboType:'AU', comboCode:'A020'},
	    	{name: 'SET_METH'			,text: '결제방법'					,type: 'string',comboType:'AU', comboCode:'B038'},//ABH220T
	    	{name: 'REMARK'				,text: '적요'						,type: 'string'},
	    	{name: 'MONEY_UNIT'         ,text: '화폐단위'                  ,type: 'string'/*,comboType:'AU', comboCode:'B004'*/},  //ABH220T
	    	
	    	{name: 'REAL_AMT_I'			,text: '지급액'					,type: 'uniPrice'},//ABH220T
	    	{name: 'INC_AMT_I'          ,text: '소득세'                   ,type: 'uniPrice'},
	    	{name: 'LOC_AMT_I'          ,text: '주민세'                   ,type: 'uniPrice'},
	    	{name: 'J_AMT_I'            ,text: '실지급액'                  ,type: 'uniPrice'},
	    		    	
	    	{name: 'EXP_DATE'			,text: '만기일'					,type: 'uniDate'},//ABH220T
	    	{name: 'SEND_YN'			,text: '이체여부'					,type: 'string',comboType:'AU', comboCode:'A020'},
	    	{name: 'RETURN_YN'			,text: '반송여부'					,type: 'string',comboType:'AU', comboCode:'A020'},
	    	{name: 'REASON_MSG'			,text: '반송사유'					,type: 'string'},
	    	{name: 'STATE_NUM'			,text: '이체전문번호'				,type: 'string'},
	    	{name: 'ORG_AC_DATE'		,text: '발생일'					,type: 'string'},
	    	{name: 'ORG_SLIP_NUM'		,text: '번호'						,type: 'string'},
	    	{name: 'ORG_SLIP_SEQ'		,text: '순번'						,type: 'string'},
	    	{name: 'PEND_CODE'			,text: '미결항목코드'				,type: 'string'},
	    	{name: 'ACCNT'				,text: '계정코드'					,type: 'string'},//ABH220T
	    	{name: 'ACCNT_NAME'			,text: '계정명'					,type: 'string'},
	    	{name: 'BANK_CODE'			,text: '은행코드'					,type: 'string'},//ABH220T
	    	{name: 'BANK_NAME'			,text: '은행명'					,type: 'string'},
	    	{name: 'BANK_ACCOUNT'		,text: '계좌번호(DB)'				,type: 'string'},//ABH220T
	    	{name: 'BANK_ACCOUNT_EXPOS'	,text: '계좌번호'					,type: 'string', defaultValue:'**********'},//ABH220T
	    	{name: 'BANKBOOK_NAME'		,text: '예금주명'					,type: 'string'},//ABH220T
	    	{name: 'RCPT_NAME'			,text: '예금주명결과'				,type: 'string'},
	    	{name: 'CMS_TRANS_YN'		,text: '예금주전송'					,type: 'string'},
	    	{name: 'RCPT_RESULT_MSG'	,text: '예금주조회결과 '			    ,type: 'string'},
	    	{name: 'RCPT_STATE_NUM'		,text: '예금주전문번호'				,type: 'string'},
	    	
	    	{name: 'EX_DATE'		,text: '결의일자'				,type: 'string'},
	    	{name: 'EX_NUM'			,text: '결의번호'				,type: 'string'},
	    	{name: 'SEQ'			,text: 'SEQ'				,type: 'string'}
	    	    	
		]
	});
	
	Unilite.defineModel('Abh200ukrRef1Model', {	//검색팝업관련
	    fields: [
			{name: 'SEND_NUM'			,text: '지급번호'		,type: 'string'},
			{name: 'PAY_METH'			,text: '지급방법'		,type: 'string',comboType:'AU', comboCode:'A101'},
			{name: 'SEND_DATE'			,text: '지급일자'		,type: 'uniDate'},
			{name: 'PAY_CODE'			,text: '코드'			,type: 'string'},
			{name: 'PAY_NAME'			,text: '명칭'			,type: 'string'},
			{name: 'BANK_ACCOUNT'		,text: '계좌번호(DB)'	,type: 'string'},
			{name: 'BANK_ACCOUNT_EXPOS'	,text: '계좌번호'		,type: 'string', defaultValue:'**********'},
			{name: 'TOT_AMT_I'			,text: '이체금액'		,type: 'uniPrice'},
			{name: 'EX_DATE'			,text: '결의일'		,type: 'uniDate'},
			{name: 'EX_NUM'				,text: '번호'			,type: 'string'},
			{name: 'AC_DATE'			,text: '회계일'		,type: 'uniDate'},
			{name: 'SLIP_NUM'			,text: '번호'			,type: 'string'},
			{name: 'AGREE_YN'			,text: '승인여부'		,type: 'string',comboType:'AU', comboCode:'A014'},
			{name: 'COMP_CODE'			,text: 'COMP_CODE'	,type: 'string'}
	    ]
	});
	
	var autoSignButtonStore = Unilite.createStore('ButtonStore',{     
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyAutoSign,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            var paramMaster = subForm1.getValues();  
            
            paramMaster.BUTTON_FLAG = buttonFlag;
            
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        
                        directMasterStore.loadStoreRecords();
                        queryButtonFlag = 'M';
                        
                        queryButtonFlag2 = 'M';
                        buttonFlag = '';
//                        UniAppManager.app.onQueryButtonDown();
                     },
                     failure: function(batch, option) {
                        buttonFlag = '';
                        
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
	
	var directMasterStore = Unilite.createStore('Abh200ukrDirectMasterStore',{
		model: 'abh200ukrMasterModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			allDeletable:false,
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directMasterProxy,
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= panelResult.getValues();
			
			paramMaster.SEND_NUM = subForm1.getValue('SEND_NUM');
			paramMaster.SEND_DATE = UniDate.getDbDateStr(subForm3.getValue('SEND_DATE'));
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
						
						if(queryButtonFlag2 != 'M'){
							if(!Ext.isEmpty(master.KEY_NUMBER)){
                                subForm1.setValue("SEND_NUM", master.KEY_NUMBER);
							}
						}
//						directDetailStore.loadStoreRecords();
						
					/*	if (directDetailStore.count() == 0) {   
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}*/
						
//						if(queryButtonFlag2 != 'Y'){
							directDetailStore.saveStore();
//						}
						
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('Abh200ukrMasterGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
        loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();
			if(!Ext.isEmpty(subForm1.getValue('SEND_NUM'))){
				param.SEND_NUM = subForm1.getValue('SEND_NUM');
        	}
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		directDetailStore.loadStoreRecords();
           		
           		if(!Ext.isEmpty(subForm1.getValue('SEND_NUM'))){
               		if(!Ext.isEmpty(records[0].data.EX_DATE)){
               			Ext.getCmp('autoSignBtn1').setHidden(true);
                        Ext.getCmp('autoSignBtn2').setHidden(false);
               			UniAppManager.setToolbarButtons(['delete','deleteAll','save'], false);
               		}else{
               		   	Ext.getCmp('autoSignBtn1').setHidden(false);
                        Ext.getCmp('autoSignBtn2').setHidden(true);
               		}
                }else{
                    Ext.getCmp('autoSignBtn1').setHidden(false);
                    Ext.getCmp('autoSignBtn2').setHidden(true);	
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
	
	var directDetailStore = Unilite.createStore('abh220ukrDetailStore', {
		model: 'abh200ukrDetailModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
			allDeletable:false,
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directDetailProxy,
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= panelResult.getValues();	
			paramMaster.SEND_NUM = subForm1.getValue('SEND_NUM');
			
//			paramMaster.queryButtonFlag2 = queryButtonFlag2;
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
//						directDetailStore.loadStoreRecords();
						
						if (directDetailStore.count() == 0) {
							
							
							
							UniAppManager.app.onResetButtonDown();
						}
						
						if(master.DELETE_ALL_FLAG == 'Y'){
							UniAppManager.app.onResetButtonDown();
//							subForm1.setValue('SEND_NUM','');
						}
						
						
						if(directDetailStore.count() > 0){    //신규 저장(insert)시
						  queryButtonFlag = 'M';
						  directDetailStore.loadStoreRecords();
						}
						
						
						/*else{
							UniAppManager.app.onQueryButtonDown();
						}*/
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('Abh200ukrDetailGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(queryButtonFlag == 'M'){//검색버튼 눌러서 abh200t abh210t 에서 데이터 가져왔을시
           			detailGrid.getSelectionModel().selectAll();   
           			directDetailStore.commitChanges();
           			queryButtonFlag ='';
           		}else{
	           		masterGrid.reset();
					directMasterStore.clearData();
					
	        		if(store.getCount() > 0){
	        			masterGrid.createRow();
	        			
	        		}
           		}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();
			if(!Ext.isEmpty(subForm1.getValue('SEND_NUM'))){
				param.SEND_NUM = subForm1.getValue('SEND_NUM');
        	}else{
        		param.SEND_NUM = '';
        	}
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	
	var abh200ukrRef1Store = Unilite.createStore('abh200ukrRef1Store', {//검색팝업관련
		model: 'Abh200ukrRef1Model',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'abh200ukrService.selectRef1'                	
            }
        },
       
        loadStoreRecords : function()	{
			var param= abh200ukrRef1Search.getValues();	
//			param.CHARGE_DIVI = gsChargeDivi;
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
        /*   		if(payDtlNoStore.getCount() == 0){
           			Ext.Msg.alert(Msg.sMB099,Msg.sMB015);
           		}*/
           	}
		}
	});
	
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
			title: '기본정보', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{ 
    		fieldLabel: '발생일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'ORG_AC_DATE_FR',
		    endFieldName: 'ORG_AC_DATE_TO',
		    startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    allowBlank: false,
		    onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelResult.setValue('ORG_AC_DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelResult.setValue('ORG_AC_DATE_TO', newValue);				    		
		    	}
		    }
		},{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        // value:UserInfo.divCode,
	        comboType:'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('DIV_CODE', newValue);
				}
			}
		},{ 
    		fieldLabel: '지급예정일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'PRE_DATE_FR',
		    endFieldName: 'PRE_DATE_TO',
//			    startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
//		    allowBlank: false,             
		    onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelResult.setValue('PRE_DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelResult.setValue('PRE_DATE_TO', newValue);				    		
		    	}
		    }
		},{
			fieldLabel: '지급여부',
//			labelWidth:150,
			name:'EX_YN',	
			xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'A020', 
//		    allowBlank: false,
		    hidden:true,//(정규로직 관련)
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('EX_YN', newValue);
				}
			}
		},
		
		
		Unilite.popup('ACCNT',{
			fieldLabel: '계정과목', 
			valueFieldWidth: 90,
			textFieldWidth: 140,
			valueFieldName:'ACCNT_CODE',
		    textFieldName:'ACCNT_NAME',
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelResult.setValue('ACCNT_CODE', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelResult.setValue('ACCNT_NAME', newValue);	
				},
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'ADD_QUERY' : "ISNULL(PROFIT_DIVI,'') IN ('X')",
                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
		}),
		/*{
			xtype:'component',
			width: 200
		},*/{
			fieldLabel: '사업자구분',
//			labelWidth:150,
			name:'BUSINESS_TYPE',	
			xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'B016', 
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('BUSINESS_TYPE', newValue);
				}
			}
		},
		
		Unilite.popup('PAY_CUSTOM',{
			fieldLabel: '지급처', 
			valueFieldWidth: 90,
			textFieldWidth: 140,
			valueFieldName:'PAY_CUSTOM_CODE_FR',
		    textFieldName:'PAY_CUSTOM_NAME_FR',
//				    validateBlank:'text',
		    extParam: {
//	    			'CHARGE_CODE': getChargeCode[0].SUB_CODE
//	    			,'ADD_QUERY': "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"
		    },
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelResult.setValue('PAY_CUSTOM_CODE_FR', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelResult.setValue('PAY_CUSTOM_NAME_FR', newValue);	
				}
			}
		}),
		Unilite.popup('PAY_CUSTOM',{
			fieldLabel: '~', 
			valueFieldWidth: 90,
			textFieldWidth: 140,
			valueFieldName:'PAY_CUSTOM_CODE_TO',
		    textFieldName:'PAY_CUSTOM_NAME_TO',
//				    validateBlank:'text',
		    extParam: {
//	    			'CHARGE_CODE': getChargeCode[0].SUB_CODE
//	    			,'ADD_QUERY': "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"
		    },
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelResult.setValue('PAY_CUSTOM_CODE_TO', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelResult.setValue('PAY_CUSTOM_NAME_TO', newValue);	
				}
			}
		})	
			
			]	
		}]
	});
	
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3,
			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
//        	tdAttrs: {style: 'border : 1px solid #ced9e7;'/*width: '100%'/*,align : 'left'*/}
		
		},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
    		fieldLabel: '발생일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'ORG_AC_DATE_FR',
		    endFieldName: 'ORG_AC_DATE_TO',
		    startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    allowBlank: false,
		    onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('ORG_AC_DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('ORG_AC_DATE_TO', newValue);				    		
		    	}
		    }
		},/*{
			xtype:'component',
			width: 200
		},*/{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        // value:UserInfo.divCode,
	        comboType:'BOR120',
			width: 325,
//			colspan:2
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			tdAttrs: {align : 'right'/*,width:'100%'*/},
			items :[{
		    	xtype: 'button',
	    		text: '검색(M)',	
	    		id: 'btnLinkDtl',
	    		name: 'LINKDTL',
	    		width: 80,	
				handler : function() {
					openAbh200ukrRef1Window();
				}
		    }]
    	},{ 
    		fieldLabel: '지급예정일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'PRE_DATE_FR',
		    endFieldName: 'PRE_DATE_TO',
		    colspan:3,
//			    startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
//		    allowBlank: false,             
		    onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PRE_DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PRE_DATE_TO', newValue);				    		
		    	}
		    }
		},/*{
			xtype:'component',
			width: 200
		},*/{
			fieldLabel: '지급여부',
//			labelWidth:150,
			name:'EX_YN',	
			xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'A020', 
//		    allowBlank: false,
		    hidden:true,//(정규로직 관련)
		    colspan:2,
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('EX_YN', newValue);
				}
			}
		},
		
		
		Unilite.popup('ACCNT',{
			fieldLabel: '계정과목', 
			valueFieldWidth: 90,
			textFieldWidth: 140,
			valueFieldName:'ACCNT_CODE',
		    textFieldName:'ACCNT_NAME',
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME', newValue);	
				},
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'ADD_QUERY' : "ISNULL(PROFIT_DIVI,'') IN ('X')",
                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
		}),
		/*{
			xtype:'component',
			width: 200
		},*/{
			fieldLabel: '사업자구분',
//			labelWidth:150,
			name:'BUSINESS_TYPE',	
			xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'B016', 
		    colspan:2,
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BUSINESS_TYPE', newValue);
				}
			}
		},
		
		Unilite.popup('PAY_CUSTOM',{
			fieldLabel: '지급처', 
			valueFieldWidth: 90,
			textFieldWidth: 140,
			valueFieldName:'PAY_CUSTOM_CODE_FR',
		    textFieldName:'PAY_CUSTOM_NAME_FR',
//				    validateBlank:'text',
		    extParam: {
//	    			'CHARGE_CODE': getChargeCode[0].SUB_CODE
//	    			,'ADD_QUERY': "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"
		    },
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PAY_CUSTOM_CODE_FR', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('PAY_CUSTOM_NAME_FR', newValue);	
				}
			}
		}),
	/*	{
			xtype:'component',
			width: 200
		},*/
		
		/*{
			xtype:'component', 
			html:'~',
			style: {
				marginTop: '3px !important',
				font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
			}
		},*/
		Unilite.popup('PAY_CUSTOM',{
			fieldLabel: '~', 
			valueFieldWidth: 90,
			textFieldWidth: 140,
			valueFieldName:'PAY_CUSTOM_CODE_TO',
		    textFieldName:'PAY_CUSTOM_NAME_TO',
		    colspan:2,
//				    validateBlank:'text',
		    extParam: {
//	    			'CHARGE_CODE': getChargeCode[0].SUB_CODE
//	    			,'ADD_QUERY': "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"
		    },
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PAY_CUSTOM_CODE_TO', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('PAY_CUSTOM_NAME_TO', newValue);	
				}
			}
		})		
				
				
				
				
		/*{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:600,
			colspan:4,
			items :[
				Unilite.popup('PAY_CUSTOM',{
					fieldLabel: '지급처', 
					valueFieldWidth: 90,
					textFieldWidth: 140,
					valueFieldName:'PAY_CUSTOM_CODE_FR',
				    textFieldName:'PAY_CUSTOM_NAME_FR',
		//				    validateBlank:'text',
				    extParam: {
		//	    			'CHARGE_CODE': getChargeCode[0].SUB_CODE
		//	    			,'ADD_QUERY': "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"
				    }
				}),
			{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},
				Unilite.popup('PAY_CUSTOM',{
					fieldLabel: '', 
					valueFieldWidth: 90,
					textFieldWidth: 140,
					valueFieldName:'PAY_CUSTOM_CODE_TO',
				    textFieldName:'PAY_CUSTOM_NAME_TO',
		//				    validateBlank:'text',
				    extParam: {
		//	    			'CHARGE_CODE': getChargeCode[0].SUB_CODE
		//	    			,'ADD_QUERY': "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"
				    }
				})
			]
		}*/,{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 20
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'}
			},
//			id:'branchSend',
			padding: '0 0 5 0',
//			width:1000,
			colspan:3,
			items :[{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:80,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'[작업순서]',
					componentCls : 'component-text_second',
					tdAttrs: {align : 'center'},
		    		width: 80
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:30,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'조회',
		    		//id: '',
		    		name: '',
		    		width: 30,	
		    		tdAttrs: {align : 'center'},
		    		componentCls : 'component-text_second'
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:20,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'→',
					componentCls : 'component-text_second',
		    		width: 20,
		    		tdAttrs: {align : 'center'}
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:80,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'지급방법선택',
		    		//id: '',
		    		name: '',
		    		width: 80,	
		    		tdAttrs: {align : 'center'},
		    		componentCls : 'component-text_second'
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:20,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'→',
					componentCls : 'component-text_second',
		    		width: 20,
		    		tdAttrs: {align : 'center'}
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:70,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'체크후 저장',
		    		//id: '',
		    		name: '',
		    		width: 70,	
		    		tdAttrs: {align : 'center'},
		    		componentCls : 'component-text_second'
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:20,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'→',
					componentCls : 'component-text_second',
		    		width: 20,
		    		tdAttrs: {align : 'center'}
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:100,
				tdAttrs: {align : 'center'},
				items :[{
		    		xtype: 'button',
		    		text: '예금주조회하기',	
		    		//id: '',
		    		name: '',
		    		width: 100,	
		    		tdAttrs: {align : 'center'},
//		    		hidden:true,
					handler : function() {
						
						if(!Ext.isEmpty(subForm1.getValue('SEND_NUM'))){
    						var param = {
                                S_SEND_NUM: subForm1.getValue('SEND_NUM')
                            }
                            Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
//                            panelResult.getEl().mask('작업 중...','loading-indicator');
//                            subForm1.getEl().mask('작업 중...','loading-indicator');
//                            subForm2.getEl().mask('작업 중...','loading-indicator');
//                            subForm3.getEl().mask('작업 중...','loading-indicator');
//                            detailGrid.getEl().mask('작업 중...','loading-indicator');
                            
                            abh200ukrService.bankNameQuery(param, function(provider, response)  {                           
                                if(provider){   
                                    UniAppManager.updateStatus(Msg.sMB014);   
                                    directMasterStore.loadStoreRecords();
                                    queryButtonFlag = 'M';
                                    
                                    queryButtonFlag2 = 'M';
                                }
                                
                                Ext.getCmp('pageAll').getEl().unmask();  
//                                panelResult.getEl().unmask();        
//                                subForm1.getEl().unmask();       
//                                subForm2.getEl().unmask();       
//                                subForm3.getEl().unmask();
//                                detailGrid.getEl().unmask();
                            });
    					}
					}
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:20,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'→',
					tdAttrs: {align : 'center'},
					componentCls : 'component-text_second',
		    		width: 20
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:100,
				tdAttrs: {align : 'center'},
				items :[{
		    		xtype: 'button',
		    		text: '예금주결과받기',	
		    		//id: '',
		    		name: '',
		    		width: 100,	
		    		tdAttrs: {align : 'center'},
//		    		hidden:true,
					handler : function() {
					   if(!Ext.isEmpty(subForm1.getValue('SEND_NUM'))){
                            var param = {
                                S_SEND_NUM: subForm1.getValue('SEND_NUM'),
                                S_WORK_GB:  '2'
                                
                            }
                            Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
//                            panelResult.getEl().mask('작업 중...','loading-indicator');
//                            subForm1.getEl().mask('작업 중...','loading-indicator');
//                            subForm2.getEl().mask('작업 중...','loading-indicator');
//                            subForm3.getEl().mask('작업 중...','loading-indicator');
//                            detailGrid.getEl().mask('작업 중...','loading-indicator');
                            
                            abh200ukrService.bankNameresult(param, function(provider, response)  {                           
                                if(provider){   
                                    UniAppManager.updateStatus(Msg.sMB014);   
                                    directMasterStore.loadStoreRecords();
                                    queryButtonFlag = 'M';
                                    
                                    queryButtonFlag2 = 'M';
                                }
                                Ext.getCmp('pageAll').getEl().unmask(); 
//                                panelResult.getEl().unmask();        
//                                subForm1.getEl().unmask();       
//                                subForm2.getEl().unmask();       
//                                subForm3.getEl().unmask();
//                                detailGrid.getEl().unmask();
                            });
                        }
						
						
					}
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:20,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'→',
					tdAttrs: {align : 'center'},
					componentCls : 'component-text_second',
		    		width: 20
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:90,
				tdAttrs: {align : 'center'},
				items :[{
		    		xtype: 'button',
		    		text: '지급파일생성',	
		    		//id: '',
		    		name: '',
		    		width: 90,	
		    		tdAttrs: {align : 'center'},
//		    		hidden:true,
					handler : function() {
					   if(!Ext.isEmpty(subForm1.getValue('SEND_NUM'))){
                            var param = {
                                S_SEND_NUM: subForm1.getValue('SEND_NUM')
                            }
                            Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
//                            panelResult.getEl().mask('작업 중...','loading-indicator');
//                            subForm1.getEl().mask('작업 중...','loading-indicator');
//                            subForm2.getEl().mask('작업 중...','loading-indicator');
//                            subForm3.getEl().mask('작업 중...','loading-indicator');
//                            detailGrid.getEl().mask('작업 중...','loading-indicator');
                            
                            abh200ukrService.abh200create(param, function(provider, response)  {                           
                                if(provider){   
                                    UniAppManager.updateStatus(Msg.sMB014); 
                                    directMasterStore.loadStoreRecords();
                                    queryButtonFlag = 'M';
                                    
                                    queryButtonFlag2 = 'M';
                                }
                                Ext.getCmp('pageAll').getEl().unmask(); 
//                                panelResult.getEl().unmask();        
//                                subForm1.getEl().unmask();       
//                                subForm2.getEl().unmask();       
//                                subForm3.getEl().unmask();
//                                detailGrid.getEl().unmask();
                            });
                        }
					}
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:20,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'→',
					componentCls : 'component-text_second',
		    		width: 20,
		    		tdAttrs: {align : 'center'}
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:100,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'브랜치에서 실행',
		    		//id: '',
		    		name: '',
		    		width: 100,	
		    		tdAttrs: {align : 'center'},
		    		componentCls : 'component-text_second'
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:20,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'→',
					tdAttrs: {align : 'center'},
					componentCls : 'component-text_second',
		    		width: 20
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:90,
				tdAttrs: {align : 'center'},
				items :[{
		    		xtype: 'button',
		    		text: '지급결과받기',	
		    		//id: '',
		    		name: '',
		    		width: 90,	
		    		tdAttrs: {align : 'center'},
//		    		hidden:true,
					handler : function() {
					   if(!Ext.isEmpty(subForm1.getValue('SEND_NUM'))){
                            var param = {
                                S_SEND_NUM: subForm1.getValue('SEND_NUM'),
                                S_WORK_GB:  '1'
                                
                            }
                            Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
//                            panelResult.getEl().mask('작업 중...','loading-indicator');
//                            subForm1.getEl().mask('작업 중...','loading-indicator');
//                            subForm2.getEl().mask('작업 중...','loading-indicator');
//                            subForm3.getEl().mask('작업 중...','loading-indicator');
//                            detailGrid.getEl().mask('작업 중...','loading-indicator');
                            
                            abh200ukrService.bankNameresult(param, function(provider, response)  {                           
                                if(provider){   
                                    UniAppManager.updateStatus(Msg.sMB014);   
                                    directMasterStore.loadStoreRecords();
                                    queryButtonFlag = 'M';
                                    
                                    queryButtonFlag2 = 'M';
                                }
                                Ext.getCmp('pageAll').getEl().unmask(); 
//                                panelResult.getEl().unmask();        
//                                subForm1.getEl().unmask();       
//                                subForm2.getEl().unmask();       
//                                subForm3.getEl().unmask();
//                                detailGrid.getEl().unmask();
                            });
                        }
					}
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:20,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'→',
					tdAttrs: {align : 'center'},
					componentCls : 'component-text_second',
		    		width: 20
				}]
	    	},{
                xtype: 'container',
                layout: {type: 'hbox', align: 'center'},
                width:70,
                items :[{
                    xtype:'button',
                    id: 'autoSignBtn1',
                    text: '자동기표',
                    width: 70,
                    handler: function() {
                        if(Ext.isEmpty(subForm1.getValue('SEND_NUM'))) return;
    //                  if(panelResult.getField('ACCEPT_STATUS').getValue()
//                        var selectedRecords = detailGrid.getSelectedRecords();
//                        if(selectedRecords.length > 0){
                        
                            autoSignButtonStore.clearData();

                            autoSignButtonStore.insert(0, [{"SEND_NUM":subForm1.getValue('SEND_NUM')}]);
                            autoSignButtonStore.data.items[0].phantom = true;
                            
                            buttonFlag = '1';
                            autoSignButtonStore.saveStore();
                                                    
//                        }else{
//                            Ext.Msg.alert('확인','자동기표 할 데이터를 선택해 주세요.'); 
//                        }
                    }
                },{
                    xtype:'button',
                    id: 'autoSignBtn2',
                    text: '기표취소',
                    width: 70,
                    handler: function() {
                        if(Ext.isEmpty(subForm1.getValue('SEND_NUM'))) return;
    //                  if(panelResult.getField('ACCEPT_STATUS').getValue()
//                        var selectedRecords = detailGrid.getSelectedRecords();
//                        if(selectedRecords.length > 0){
                        
                            autoSignButtonStore.clearData();

                            autoSignButtonStore.insert(0, [{"SEND_NUM":subForm1.getValue('SEND_NUM')}]);
                            autoSignButtonStore.data.items[0].phantom = true;
                            
                            buttonFlag = '2';
                            autoSignButtonStore.saveStore();
                                                    
//                        }else{
//                            Ext.Msg.alert('확인','자동기표 할 데이터를 선택해 주세요.'); 
//                        }
                    }
                }]
            },{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:20,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'→',
					tdAttrs: {align : 'center'},
					componentCls : 'component-text_second',
		    		width: 20
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:90,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'자동기표조회',
		    		//id: '',
		    		name: '',
		    		width: 90,	
		    		tdAttrs: {align : 'center'},
		    		componentCls : 'component-text_first',
		    		listeners:{
						render: function(component) {
			                component.getEl().on('click', function( event, el ) {
			                	UniAppManager.app.fnOpenSlip();
			                });
			            }
					}
				}]
	    	}, {               
                //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                name:'DEC_FLAG', 
                xtype: 'uniTextfield',
                hidden: true
            }]	    	
	    }]
    });	
	
	var abh200ukrRef1Search = Unilite.createSearchForm('abh200ukrRef1Form', {//검색팝업관련
		layout :  {type : 'uniTable', columns : 2
//			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
		},
    	items :[{ 
    		fieldLabel: '지급일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'SEND_DATE_FR',
		    endFieldName: 'SEND_DATE_TO',
		    startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    allowBlank: false
		},{
			fieldLabel: '지급방법',
			name:'PAY_METH',	
			xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'A101',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue == '10'){
						abh200ukrRef1Search.getField('BANK_CODE').setReadOnly(false);	
						abh200ukrRef1Search.getField('BANK_NAME').setReadOnly(false);
						abh200ukrRef1Search.getField('tc1').setReadOnly(true);	
						abh200ukrRef1Search.getField('tn1').setReadOnly(true);
					}else if(newValue == '20'){
						abh200ukrRef1Search.getField('tc1').setReadOnly(false);	
						abh200ukrRef1Search.getField('tn1').setReadOnly(false);
						abh200ukrRef1Search.getField('BANK_CODE').setReadOnly(true);	
						abh200ukrRef1Search.getField('BANK_NAME').setReadOnly(true);
					}else{
						abh200ukrRef1Search.getField('BANK_CODE').setReadOnly(true);	
						abh200ukrRef1Search.getField('BANK_NAME').setReadOnly(true);
						abh200ukrRef1Search.getField('tc1').setReadOnly(true);	
						abh200ukrRef1Search.getField('tn1').setReadOnly(true);
					}
					
				}
			}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:500,
//			id:'tdPayDtlNo',
			tdAttrs: {width:500/*align : 'center'*/},
			items :[
				Unilite.popup('BANK_BOOK',{
					fieldLabel: '통장코드', 
					valueFieldName:'BANK_CODE',
				    textFieldName:'BANK_NAME',
//				    validateBlank : false,
				    readOnly: true,
				    listeners: {
				    	onSelected: {
							fn: function(records, type) {
								abh200ukrRef1Search.setValue('BANK_ACCOUNT', records[0]["DEPOSIT_NUM"]);
		                	},
							scope: this
						},
						onClear: function(type)	{
							abh200ukrRef1Search.setValue('BANK_ACCOUNT', '');
						}
					}
				}),
			{
				xtype:'uniTextfield',
				name:'BANK_ACCOUNT',
				width:150,
				readOnly:true
			}]		
		},{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        // value:UserInfo.divCode,
	        comboType:'BOR120',
			width: 325
		},
		Unilite.popup('BANK_BOOK',{
			fieldLabel: '구매카드', 
			valueFieldName:'tc1',
		    textFieldName:'tn1',
		    validateBlank : false,
		    readOnly: true
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:500,
//			id:'tdPayDtlNo',
			tdAttrs: {width:500/*align : 'center'*/},
			items :[{
				fieldLabel: '회계일자/번호',
		 		xtype: 'uniDatefield',
		 		name: 'AC_DATE'
			},{
				xtype:'uniTextfield',
				name:'SLIP_NUM',
				width:50
			}]		
		},{
			fieldLabel: '승인여부',
			name:'AGREE_YN',	
			xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'A014'
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:500,
//			id:'tdPayDtlNo',
			tdAttrs: {width:500/*align : 'center'*/},
			items :[{
				fieldLabel: '결의일자/번호',
		 		xtype: 'uniDatefield',
		 		name: 'EX_DATE'
			},{
				xtype:'uniTextfield',
				name:'EX_NUM',
				width:50
			}]		
		}]
    });
	
	var masterGrid = Unilite.createGrid('Abh200ukrMasterGrid', {

		border:false,
		height:100,
    	features: [{
			id: 'detailGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'detailGridTotal',		
			ftype: 'uniSummary',		
			dock:'bottom',
			showSummaryRow: false
		}],
    	layout : 'fit',
        region : 'north',
		store: directMasterStore,
		tbar: [
		],
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
    		dblClickToEdit		: true,
    		onLoadSelectFirst	: true, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			state: {
				useState: true,			
				useStateList: true		
			}
		},
        columns:[
        	{ dataIndex: 'PAY_METH'			 		 	,  		width: 150},
        	{ dataIndex: 'PAY_CODE'			 		 	,  		width: 150,
        		editor:Unilite.popup('BANK_BOOK_G', {
					autoPopup: true,
					textFieldName:'BANK_BOOK_NAME',
					DBtextFieldName: 'BANK_BOOK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
						   	grdRecord.set('PAY_CODE'	, records[0].BANK_BOOK_CODE);
							grdRecord.set('PAY_NAME'	, records[0].BANK_BOOK_NAME);
							grdRecord.set('BANK_ACCOUNT'	, records[0].DEPOSIT_NUM);
							grdRecord.set('BANK_ACCOUNT_EXPOS'	, records[0].DEPOSIT_NUM_EXPOS);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PAY_CODE'	, '');
							grdRecord.set('PAY_NAME'	, '');
							grdRecord.set('BANK_ACCOUNT', '');
							grdRecord.set('BANK_ACCOUNT_EXPOS', '');
						}
					}
				})
        	},
        	{ dataIndex: 'PAY_NAME'			 		 	,  		width: 150,
        		editor:Unilite.popup('BANK_BOOK_G', {
					autoPopup: true,
					textFieldName:'BANK_BOOK_NAME',
					DBtextFieldName: 'BANK_BOOK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
						   	grdRecord.set('PAY_CODE'	, records[0].BANK_BOOK_CODE);
							grdRecord.set('PAY_NAME'	, records[0].BANK_BOOK_NAME);
							grdRecord.set('BANK_ACCOUNT'	, records[0].DEPOSIT_NUM);
							grdRecord.set('BANK_ACCOUNT_EXPOS'	, records[0].DEPOSIT_NUM_EXPOS);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PAY_CODE'	, '');
							grdRecord.set('PAY_NAME'	, '');
							grdRecord.set('BANK_ACCOUNT', '');
							grdRecord.set('BANK_ACCOUNT_EXPOS', '');
						}
					}
				})
        	},
        	{ dataIndex: 'BANK_ACCOUNT_EXPOS'		  	,  		width: 150},
        	{ dataIndex: 'BANK_ACCOUNT'		 		 	,  		width: 150, hidden:true},
        	{ dataIndex: 'TOT_AMT_I'			 		,  		/*flex:1*/width: 120},
        	{ dataIndex: 'EX_DATE'						,  		width: 120, hidden:true},
        	{ dataIndex: 'EX_NUM'						,  		width: 120, hidden:true}
//        	{ dataIndex: 'AGREE_YN'		 		 		,  		width: 120,hidden:false}
        ],               
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		if(e.record.phantom){
        		
	        		if(UniUtils.indexOf(e.field, ['PAY_METH','PAY_CODE','PAY_NAME'])){
						return true;
					}else{
						return false;	
					}
				}else{
					if(!Ext.isEmpty(e.record.data.EX_DATE)){
						return false;
					}else{
						if(UniUtils.indexOf(e.field, ['PAY_METH','PAY_CODE','PAY_NAME'])){
							return true;
						}else{
							return false;	
						}	
					}
				}
        	},
			afterrender:function()	{
			
			}
        }
	});        
    
    var detailGrid = Unilite.createGrid('Abh200ukrDetailGrid', {
//    	id:'detailGridId',
//    	split:true,
    	features: [{
			id: 'detailGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'detailGridTotal',		
			ftype: 'uniSummary',		
			dock:'bottom',
			showSummaryRow: false
		}],
    	layout : 'fit',
        region : 'center',
		store: directDetailStore,
		tbar: [
		],
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
    		dblClickToEdit		: true,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			state: {
				useState: true,			
				useStateList: true		
			}
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
//				beforeselect: function(rowSelection, record, index, eOpts) {
//					if(!Ext.isEmpty(record.get('EX_DATE'))){
//						return false;	
//					}
//					
//        		},
				beforedeselect: function(rowSelection, record, index, eOpts) {
					if(!Ext.isEmpty(record.get('EX_DATE'))){
						return false;	
					}
					
        		},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){	
					
					
					selectRecord.set('CHECK_VALUE','Y');
					
					var masterRecord = directMasterStore.data.items[0];
					
					if(queryButtonFlag != 'M'){
					
						masterRecord.set('TOT_AMT_I',masterRecord.get('TOT_AMT_I') + selectRecord.get('J_AMT_I'));
					}
					
					if(queryButtonFlag2 == 'M'){
						selectRecord.set('CHECK_VALUE2','');
					}
					
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
//					if(selectRecord.get('CONFIRM_YN') == 'N'){
//						selectRecord.set('SEND_J_AMT_I',selectRecord.get('SEND_J_AMT_I_DUMMY'));
//					}
					
						selectRecord.set('CHECK_VALUE','');
						
						var masterRecord = directMasterStore.data.items[0];
						masterRecord.set('TOT_AMT_I',masterRecord.get('TOT_AMT_I') - selectRecord.get('J_AMT_I'));
	//					selectRecord.set('CONFIRM_YN',selectRecord.get('CONFIRM_YN_DUMMY'));
						
						if(queryButtonFlag2 == 'M'|| !Ext.isEmpty(subForm1.getValue('SEND_NUM'))){
						selectRecord.set('CHECK_VALUE2','Y');
					}
						
					}
				
			}
        }),
        columns:[
        
        	{ dataIndex: 'CHECK_VALUE'		 		 	, width: 120,hidden:true},
        	{ dataIndex: 'CHECK_VALUE2'		 		 	, width: 120,hidden:true},
//        	{ dataIndex: 'AGREE_YN'		 		 		, width: 120,hidden:false},
        	{ dataIndex: 'PRE_DATE'			 		 	, width: 90},
        	{ dataIndex: 'PAY_CUSTOM_CODE'	 		 	, width: 120},
        	{ dataIndex: 'PAY_CUSTOM_NAME'	 		 	, width: 150},
        	{ dataIndex: 'COMPANY_NUM'		 		 	, width: 120},
        	{ dataIndex: 'EX_YN'				 		, width: 80,align:'center'},
        	{ dataIndex: 'SET_METH'			 		 	, width: 80},
        	{ dataIndex: 'REMARK'				 		, width: 120},
        	{ dataIndex: 'MONEY_UNIT'                   ,width:80, align:'center'},
        	
        	{ dataIndex: 'REAL_AMT_I'		 		 		, width: 120},
        	
        	{ dataIndex: 'INC_AMT_I'                     , width: 120},
        	{ dataIndex: 'LOC_AMT_I'                     , width: 120},
        	{ dataIndex: 'J_AMT_I'                     , width: 120},
        	
        	{ dataIndex: 'EXP_DATE'			 		 	, width: 80},
        	{ dataIndex: 'SEND_YN'			 		 	, width: 80,align:'center'},
        	{ dataIndex: 'RETURN_YN'			 		, width: 80,align:'center'},
        	{ dataIndex: 'REASON_MSG'			 		, width: 120},
        	{ dataIndex: 'STATE_NUM'					, width: 120},
        	{ dataIndex: 'ORG_AC_DATE'		 		 	, width: 80},
        	{ dataIndex: 'ORG_SLIP_NUM'		 		 	, width: 60},
    		{ dataIndex: 'ORG_SLIP_SEQ'		 		 	, width: 120,hidden:true},
    		{ dataIndex: 'PEND_CODE'		 		 	, width: 120,hidden:true},
        	{ dataIndex: 'ACCNT'				 		, width: 100},
        	{ dataIndex: 'ACCNT_NAME'			 		, width: 120},
        	{ dataIndex: 'BANK_CODE'			 		, width: 100},
        	{ dataIndex: 'BANK_NAME'			 		, width: 120},
        	{ dataIndex: 'BANK_ACCOUNT'		 		 	, width: 120, hidden:true},
        	{ dataIndex: 'BANK_ACCOUNT_EXPOS'		 	, width: 120, align:'center'},
        	{ dataIndex: 'BANKBOOK_NAME'		 		, width: 120},
        	{ dataIndex: 'RCPT_NAME'					, width: 120},
        	{ dataIndex: 'CMS_TRANS_YN'					, width: 120},
        	{ dataIndex: 'RCPT_RESULT_MSG'				, width: 120},
        	{ dataIndex: 'RCPT_STATE_NUM'				, width: 120},
        	{ dataIndex: 'EX_DATE'						, width: 80, hidden:true},
        	{ dataIndex: 'EX_NUM'						, width: 80, hidden:true},
        	{ dataIndex: 'SEQ'						, width: 80, hidden:true}
        ],               
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		return false;
        	},
			afterrender:function()	{			
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="BANK_ACCOUNT_EXPOS") {
					detailGrid.openCryptAcntNumPopup(record);
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
	
	var abh200ukrRef1Grid = Unilite.createGrid('abh200ukrRef1Grid', {//검색팝업 관련
        layout : 'fit',
        excelTitle: '검색팝업',
    	store: abh200ukrRef1Store,
    	uniOpt: {
    		onLoadSelectFirst: true  
        },
        features: [{
			id: 'detailGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'detailGridTotal',		
			ftype: 'uniSummary',		
//			dock:'bottom',
			showSummaryRow: true
		}],
        columns:  [  
			{ dataIndex: 'SEND_NUM'				, width:120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
			},
			{ dataIndex: 'PAY_METH'				, width:120},
			{ dataIndex: 'SEND_DATE'			, width:120},
			{ dataIndex: 'PAY_CODE'				, width:120},
			{ dataIndex: 'PAY_NAME'				, width:120},
			{ dataIndex: 'BANK_ACCOUNT_EXPOS'	, width:120,align:'center'},
			{ dataIndex: 'BANK_ACCOUNT'			, width:120,hidden:true},
			{ dataIndex: 'TOT_AMT_I'			, width:120,summaryType: 'sum'},
			{ dataIndex: 'EX_DATE'				, width:120},
			{ dataIndex: 'EX_NUM'				, width:120},
			{ dataIndex: 'AC_DATE'				, width:120},
			{ dataIndex: 'SLIP_NUM'				, width:120},
			{ dataIndex: 'AGREE_YN'				, width:120},
			{ dataIndex: 'COMP_CODE'			, width:120,hidden:true}
		], 
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
				if(colName =="BANK_ACCOUNT_EXPOS") {
					abh200ukrRef1Grid.openCryptAcntNumPopup(record);
				}else{
				
					abh200ukrRef1Grid.returnData(record);
					abh200ukrRef1Window.hide();
					
					directMasterStore.loadStoreRecords();
					queryButtonFlag = 'M';
					
					queryButtonFlag2 = 'M';
				}
				
//				SEARCH = 'SEARCH';
//				UniAppManager.app.onQueryButtonDown();			
//				panelResult.setValue('testfield',record.get('DIV_CODE'));
				
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
      			record = this.getSelectedRecord();
      		}
      		
//      		var textarray = new Array();  
//			var divCodeRec = record.get('DIV_CODE');
//			textarray = divCodeRec.split("-");
			
	        subForm1.setValue('SEND_NUM', record.get('SEND_NUM'));
       	},
		openCryptAcntNumPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);
			}
				
		}
    });
    
    function openAbh200ukrRef1Window() {    		//검색팝업 관련
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		
		if(!abh200ukrRef1Window) {
			abh200ukrRef1Window = Ext.create('widget.uniDetailWindow', {
                title: '검색',
                width: 900,				                
                height: 500,
                layout:{type:'vbox', align:'stretch'},
                items: [abh200ukrRef1Search, abh200ukrRef1Grid],
                tbar:  ['->',
					{	
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							if(!abh200ukrRef1Search.getInvalidMessage()) return;
							abh200ukrRef1Store.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							abh200ukrRef1Window.hide();
//							draftNoGrid.reset();
//							draftNoSearch.clearForm();
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{

					},
		 			beforeclose: function( panel, eOpts )	{

		 			},
		 			
		 			show: function ( panel, eOpts )	{
//		 				abh200ukrRef1Search.setValue('ST_AC_DATE',panelSearch.getValue('ST_DATE'));
//		 				abh200ukrRef1Search.setValue('FR_AC_DATE',panelSearch.getValue('FR_DATE'));
//		 				abh200ukrRef1Search.setValue('TO_AC_DATE',panelSearch.getValue('TO_DATE'));	
//		 				abh200ukrRef1Search.setValue('AC_PROJECT_CODE',panelSearch.getValue('AC_PROJECT_CODE'));	
//		 				abh200ukrRef1Search.setValue('AC_PROJECT_NAME',panelSearch.getValue('AC_PROJECT_NAME'));	
		 				
//		 				panelResult.down('#btnAutoSlip').setHtml(Msg.sMAW034);
						abh200ukrRef1Search.setValue('SEND_DATE_FR',UniDate.get('startOfMonth'));
						abh200ukrRef1Search.setValue('SEND_DATE_TO',UniDate.get('today'));

						if(!abh200ukrRef1Search.getInvalidMessage()) return;
						
						
						abh200ukrRef1Store.loadStoreRecords();
		 			}
		 			
				}
			})
		}
		abh200ukrRef1Window.center();
		abh200ukrRef1Window.show();
    }
	
	
	var subForm1 = Unilite.createSimpleForm('resultForm2',{
		region: 'north',
    	border:true,
	    items: [{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:300,
			tdAttrs: {align : 'center'},
			items :[{
				xtype:'component',
				html:'[이체할 계좌 및 구매카드/어음]',
				componentCls : 'component-text_green',
				tdAttrs: {align : 'left'},
	    		width: 180
			},{
	    		xtype:'uniTextfield',
	    		fieldLabel:'이체지급번호',
	    		name:'SEND_NUM',
	    		readOnly:true
	    	}]
	    }]
    });	 
    var subForm2 = Unilite.createSimpleForm('resultForm3',{
		region: 'north',
    	border:true,
	    items: [masterGrid]
    });
    	
    var subForm3 = Unilite.createSimpleForm('resultForm4',{
		region: 'north',
    	border:true,
	    items: [{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:150,
			tdAttrs: {align : 'center'},
			items :[{
				xtype:'component',
				html:'[이체리스트]',
				componentCls : 'component-text_green',
				tdAttrs: {align : 'left'},
	    		width: 150
			},{
	    		fieldLabel: '지급일자',
		 		xtype: 'uniDatefield',
		 		name: 'SEND_DATE',
		 		value: UniDate.get('today')
	    	}]
    	}/*,
    	detailGrid*/]
    });	 
    
    var decrypBtn = Ext.create('Ext.Button',{
        text:'복호화',
        width: 80,
        handler: function() {
            var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
            if(needSave){
               alert(Msg.sMB154); //먼저 저장하십시오.
               return false;
            }
            panelResult.setValue('DEC_FLAG', 'Y');
            UniAppManager.app.onQueryButtonDown();
            panelResult.setValue('DEC_FLAG', '');
        }
    });
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			id:'pageAll',
			items:[
				panelResult, subForm1, subForm2, subForm3, detailGrid
			]
		},
			panelSearch
		
		], 
		id : 'Abh200ukrApp',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ORG_AC_DATE_FR');
			UniAppManager.setToolbarButtons(['print'], true);
			
			Ext.getCmp('autoSignBtn1').setHidden(false);
            Ext.getCmp('autoSignBtn2').setHidden(true);
            
            var tbar = masterGrid._getToolBar();
            tbar[0].insert(tbar.length + 1, decrypBtn);
		},
		onQueryButtonDown : function()	{
//			directMasterStore.loadStoreRecords();
			subForm1.setValue('SEND_NUM','');
			queryButtonFlag2 = '';
			Ext.getCmp('autoSignBtn1').setHidden(false);
            Ext.getCmp('autoSignBtn2').setHidden(true); 
			directDetailStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
		
		},
		onPrintButtonDown: function() {
        	
			if(Ext.isEmpty(subForm1.getValue('SEND_NUM'))){
			   Ext.Msg.alert("warn","이체지급번호 is null");
               return false;
			}
			var divName;
			var payMeth;
			if(panelResult.getValue('DIV_CODE') == '' || panelResult.getValue('DIV_CODE') == null ){
			 	divName = Msg.sMAW002;  // 전체
			 }else{
			 	divName = panelResult.getField('DIV_CODE').getRawValue();
			 }
			
			var param = {
                SEND_NUM: subForm1.getValue('SEND_NUM'),
                DIV_NAME: divName,
               
            }

			var prgID1 = 'abh200ukr';
	        var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/abh/abh200rkrPrint.do',
	            prgID: prgID1,
	            extParam: param
	         });
             win.center();
             win.show();
	    },
		onResetButtonDown: function() {		
			subForm1.clearForm();
			detailGrid.reset();
			masterGrid.reset();
			directDetailStore.clearData();
			directMasterStore.clearData();
			UniAppManager.setToolbarButtons(['delete','deleteAll','save'], false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(!panelResult.getInvalidMessage()) return false; 
//			directDetailStore.saveStore();
			
			var selectedRecords = detailGrid.getSelectedRecords();
			if(Ext.isEmpty(subForm1.getValue('SEND_NUM'))){
				if(selectedRecords.length > 0){
				
					directMasterStore.saveStore();
				}else{
					Ext.Msg.alert(Msg.sMB099,Msg.sMA0394);
				}
			}else{
				directMasterStore.saveStore();	
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				
				if(selRow.get('SEND_YN') == 'Y'){
					Ext.Msg.alert(Msg.sMB099,Msg.sMA0425);	
				}else{
					detailGrid.deleteSelectedRow();
				}
			}
		},

		setDefault: function(){
		},
		fnOpenSlip: function(){
			var masterData =  directMasterStore.data.items;
			
			if(!Ext.isEmpty(masterData)){
			
                if(Ext.isEmpty(masterData[0].get('EX_DATE')) || Ext.isEmpty(masterData[0].get('EX_NUM'))){
                    return false;   
                }else{
                    var params = {
        //              action:'select', 
                        'PGM_ID' : 'abh200ukr',
                        'EX_DATE' : masterData[0].get('EX_DATE'),
                        'EX_NUM' : masterData[0].get('EX_NUM'),
                        'INPUT_PATH' : '70'
                        
                    }
                    var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};                           
                    parent.openTab(rec1, '/accnt/agj105ukr.do', params);
                }
			}else{
			     return false;	
			}
        }
	});
	Unilite.createValidator('validator', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PAY_METH" :
					record.set('PAY_CODE','');
					record.set('PAY_NAME','');
					record.set('BANK_ACCOUNT','');
					
					if(newValue == '10'){
						record.set('PAY_CODE',gsSaveCode);
						record.set('PAY_NAME',gsSaveName);
						record.set('BANK_ACCOUNT',gsSaveAccount);
					}
			}
			return rv;
		}
	});	
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				
			}
			return rv;
		}
	});	
	
	Unilite.createValidator('validator02', {
		forms: {'formA:':panelResult},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {
			
			}
			return rv;
		}
	});
};
</script>
