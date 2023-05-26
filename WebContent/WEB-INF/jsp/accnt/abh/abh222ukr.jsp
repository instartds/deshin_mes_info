<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="abh222ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="J682" /> <!-- 결재상태(내부결재) -->
	<t:ExtComboStore comboType="AU" comboCode="A395" /> <!-- 지급방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B131" /><!--예/아니오 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >
var subGridWindow;

var mainGridReceiveRecord = '';

var cmsButtonFlag ='';  //예금주조회하기, 예금주 결과받기

function appMain() {
	var statusStore = Unilite.createStore('statusComboStore', {  
	    fields: ['text', 'value'],
		data :  [
	        {'text':'미확정'  , 'value':'1'},
	        {'text':'확정'	, 'value':'0'}
//			{'text':'보류'	, 'value':'C'}
		]
	});
	
	var directProxyCmsButton = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'abh222ukrService.insertDetailCmsButton',
            syncAll: 'abh222ukrService.saveAllCmsButton'
        }
    }); 
    
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'abh222ukrService.selectList',
			update: 'abh222ukrService.updateDetail',
			create: 'abh222ukrService.insertDetail',
			destroy: 'abh222ukrService.deleteDetail',
			syncAll: 'abh222ukrService.saveAll'
		}
	});	

	var directSubProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'abh222ukrService.selectSubList',
			update: 'abh222ukrService.updateSubDetail',
			create: 'abh222ukrService.insertSubDetail',
			destroy: 'abh222ukrService.deleteSubDetail',
			syncAll: 'abh222ukrService.subSaveAll'
		}
	});	
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('abh222ukrModel', {
	    fields: [
//	    	{name: 'CHECK_VALUE'			,text: 'check'					,type: 'string'},
	    
	    	{name: 'ROW_NUMBER'			        ,text: 'NO'					,type: 'string', editable: false},
	    	{name: 'CHK'			        ,text: '확정상태'			    ,type: 'string',store: Ext.data.StoreManager.lookup('statusComboStore'), editable: false},//ABH222T
//	    	{name: 'CONFIRM_YN_DUMMY'   ,text: '상태 더미'					,type: 'string'},
	    	{name: 'PAYMENT_STATUS'		        ,text: '결재상태'				,type: 'string',comboType:'AU', comboCode:'J682', editable: false},
	    	{name: 'PAYMENT_STATUS_DETAIL'		,text: '결재상태_REF_CODE1'	,type: 'string', editable: false},
            {name: 'EX_DATE'                    ,text: '결의전표일자'           ,type: 'uniDate', editable: false},
            {name: 'EX_NUM'                     ,text: '결의전표번호'           ,type: 'int', editable: false},
	    	{name: 'PRE_DATE'			        ,text: '지급예정일'				,type: 'uniDate'/*, editable: false*/},
	    	{name: 'PAY_CUSTOM_CODE'	        ,text: '지급처'				,type: 'string'},//ABH222T
	    	{name: 'PAY_CUSTOM_NAME'	        ,text: '지급처명'				,type: 'string'},
	    	{name: 'DIV_CODE'			        ,text: '사업장'				,type: 'string', editable: false},
	    	{name: 'PEND_CODE'			        ,text: '미결항목코드'			,type: 'string', editable: false},
	    	{name: 'SET_METH'			        ,text: '지급방법'				,type: 'string',comboType:'AU', comboCode:'A395', allowBlank: true, defaultValue: '10', editable: false},//ABH222T
	    	{name: 'TEMPCOL'                    ,text: '전송대상'              ,type: 'string', editable: false},
	    	{name: 'REMARK'				        ,text: '적요'					,type: 'string'},
	    	{name: 'MONEY_UNIT'			        ,text: '화폐단위'				,type: 'string',comboType:'AU', comboCode:'B004', displayField: 'value'},	//ABH222T
	    	{name: 'ORG_AMT_I'		            ,text: '발생금액'				,type: 'uniPrice'},
	   	    {name: 'J_AMT_I'			        ,text: '반제된금액'				,type: 'uniPrice', editable: false},
	   	    {name: 'JAN_AMT_I'                  ,text: '지급대상금액'           ,type: 'uniPrice', editable: false},//AGB300T
	    	{name: 'IN_TAX_I'                   ,text: '소득세'               ,type: 'uniPrice', editable: false},
            {name: 'LOCAL_TAX_I'                ,text: '주민세'               ,type: 'uniPrice', editable: false},
            {name: 'REAL_AMT_I'                 ,text: '실지급액'              ,type: 'uniPrice', editable: false},
	    	{name: 'SEND_J_AMT_I'		        ,text: '지급확정금액'			,type: 'uniPrice', editable: false},//ABH222T
	    	{name: 'SEND_J_AMT_I_DUMMY'		    ,text: '이체금액_DUMMY'		,type: 'uniPrice', editable: false},//ABH222T
	    	{name: 'ORG_AC_DATE'		        ,text: '발생일'				,type: 'string', allowBlank: false},
	    	{name: 'ORG_SLIP_NUM'		        ,text: '번호'					,type: 'int',  editable: false},
	    	{name: 'ORG_SLIP_SEQ'		        ,text: '순번'					,type: 'int',  editable: false},
	    	{name: 'SEQ'				        ,text: 'SEQ'				,type: 'int', editable: false},
	    	{name: 'CONF_SEND_NUM'			    ,text: 'CONF_SEND_NUM'		,type: 'string', editable: false},
	    	{name: 'ACCNT'				        ,text: '계정과목'				,type: 'string', allowBlank: false},//ABH222T
	    	{name: 'ACCNT_NAME'                 ,text: '계정과목명'            ,type: 'string'},
	    	{name: 'IN_SAVE_CODE'               ,text: '입금통장코드'           ,type: 'string'},
	    	{name: 'IN_SAVE_NAME'               ,text: '입금통장명'            ,type: 'string'},
	    	{name: 'BANK_CODE'			        ,text: '입금은행코드'			,type: 'string'},//ABH222T   
	    	{name: 'BANK_NAME'			        ,text: '입금은행명'				,type: 'string', editable: false},
	    	{name: 'BANK_ACCOUNT'		        ,text: '입금계좌번호(DB)'		,type: 'string', editable: false},//ABH222T
	    	{name: 'ACCOUNT_NUM'                ,text: '입금계좌번호'           ,type: 'string', editable: false},//ABH222T
	    	{name: 'BANK_ACCOUNT_EXPOS'	        ,text: '계좌번호'				,type: 'string', defaultValue:'*************', editable: false},
	    	{name: 'BANKBOOK_NAME'		        ,text: '예금주'				,type: 'string'},//ABH222T
	    	{name: 'RCPT_ID'                    ,text: '예금주전송ID'          ,type: 'string', editable: false},
	    	{name: 'RCPT_NAME'                  ,text: '예금주명결과'           ,type: 'string', editable: false},
            {name: 'CMS_TRANS_YN'               ,text: '예금주전송'            ,type: 'string', editable: false},
            {name: 'RCPT_RESULT_MSG'            ,text: '예금주조회결과 '         ,type: 'string', editable: false},
            {name: 'RCPT_STATE_NUM'             ,text: '예금주전문번호'          ,type: 'string', editable: false},
//	    	{name: 'EXP_DATE'			,text: '만기일'					,type: 'uniDate'},//ABH222T
	    	{name: 'MODY_YN'                    ,text: 'MODY_YN'            ,type: 'string', editable: false},
	    	{name: 'OUT_SAVE_CODE'              ,text: '출금통장코드'           ,type: 'string'},    //지급방법: 예금
            {name: 'OUT_BANK_CODE'              ,text: '출금은행코드'           ,type: 'string'},     //지급방법: 예금
//          {name: 'BANKBOOK_NAME'       ,text: '예금주명'                ,type: 'string'},    //지급방법: 예금
//          {name: 'ACCOUNT_NUM'         ,text: '계좌번호'                ,type: 'string'},    //지급방법: 예금
//          {name: 'BANK_CODE'           ,text: '은행코드'                ,type: 'string'},    //지급방법: 예금
//          {name: 'BANK_NAME'           ,text: '은행명'                 ,type: 'string'}     //지급방법: 예금
	    	{name: 'NOTE_NUM'                   ,text: '지급어음번호'           ,type: 'string'},    //지급방법: 어음        
	    	{name: 'PUB_DATE'                   ,text: '발행일'               ,type: 'uniDate'},    //지급방법: 어음
	    	{name: 'EXP_DATE'                   ,text: '만기일'               ,type: 'uniDate'},    //지급방법: 어음
	    	{name: 'REMARK'                     ,text: '적요'                 ,type: 'string'}    //지급방법: 어음
	    	
		]
	});
	
	Unilite.defineModel('abh222ukrSubModel', {
    	fields: [ 
    		{name: 'CUSTOM_CODE'	 	,text: 'CUSTOM_CODE' 	,type: 'string'},
    		{name: 'BOOK_CODE'          ,text: '계좌코드'          ,type: 'string'},
            {name: 'BOOK_NAME'          ,text: '계좌명'           ,type: 'string'},
            
    		{name: 'BANK_CODE'	 		,text: '은행코드' 			,type: 'string'},
    		{name: 'BANK_NAME'	 		,text: '은행명' 			,type: 'string'},
    		{name: 'BANK_ACCOUNT'	 	,text: '계좌번호' 			,type: 'string'},
    		{name: 'BANK_ACCOUNT_EXPOS'	,text: '계좌번호'			,type: 'string', defaultValue:'*************'},
    		{name: 'BANKBOOK_NAME'	 	,text: '예금주' 			,type: 'string'},
    	    {name: 'MAIN_BOOK_YN'       ,text: '주지급계좌'        ,type: 'string', comboType:'AU',comboCode:'B131'}
			  	 
		]
	});
	
	var cmsButtonStore = Unilite.createStore('Abh222ukrCmsbuttonStore',{     
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyCmsButton,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();

            var paramMaster = panelResult.getValues();
            
            paramMaster.CMS_BUTTON_FLAG = cmsButtonFlag;
//          param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));

                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        
                        cmsButtonFlag = '';
                        UniAppManager.app.onQueryButtonDown();

                    },
                    failure: function(batch, option) {
                        cmsButtonFlag = '';
                        
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
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('abh222ukrDetailStore', {
		model: 'abh222ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			allDeletable:false,
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= panelResult.getValues();	
			
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
						}else{
							UniAppManager.app.onQueryButtonDown();
						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('abh222ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
        	/*	if(store.getCount() > 0){
        			UniAppManager.setToolbarButtons(['print'], true);
        		}else{
        			UniAppManager.setToolbarButtons(['print'], true);
        		}*/
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
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	var directSubStore = Unilite.createStore('abh222ukrSubStore', {
		model: 'abh222ukrSubModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: true,			// 수정 모드 사용
        	deletable:true,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: directSubProxy
        ,loadStoreRecords : function(param)	{
			this.load({
				params: param
			});
		},
		saveStore : function()	{
			config = {
//						
			};
			this.syncAllDirect(config);
		},
	    _onStoreUpdate: function (store, eOpt) {	    	
	    	console.log("Store data updated save btn enabled !");
	    	this.setToolbarButtons('sub_save', true);    	
	    } // onStoreUpdate
	    ,_onStoreLoad: function ( store, records, successful, eOpts ) {	    	
	    	console.log("onStoreLoad");
	    	if (records) {
		    	this.setToolbarButtons('sub_save', false);
//					var msg = records.length + Msg.sMB001; //'건이 조회되었습니다.';
		    	//console.log(msg, st);
//			    	UniAppManager.updateStatus(msg, true);	
	    	}	    	
	    },
		_onStoreDataChanged: function( store, eOpts )	{	    	
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			this.setToolbarButtons(['sub_delete'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':false}});
	    		if(this.uniOpt.useNavi) {
	       			this.setToolbarButtons(['prev','next'], false);
	    		}
       		}else {
       			if(this.uniOpt.deletable)	{
	       			this.setToolbarButtons(['sub_delete'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':true}});
       			}
	    		if(this.uniOpt.useNavi) {
	       			this.setToolbarButtons(['prev','next'], true);
	    		}
       		}
       		if(store.isDirty())	{
       			this.setToolbarButtons(['sub_save'], true);
       		}else {
       			this.setToolbarButtons(['sub_save'], false);
       		}	    	
    	},
    	setToolbarButtons: function( btnName, state)	{
    		var toolbar = subGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
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
			},
			Unilite.popup('ACCNT',{
				fieldLabel: '계정과목', 
				valueFieldWidth: 90,
				textFieldWidth: 140,
				valueFieldName:'ACCNT_CODE',
			    textFieldName:'ACCNT_NAME',
	//				    validateBlank:'text',
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
                                'ADD_QUERY' : "(ISNULL(PROFIT_DIVI,'') IN ('X') OR LEFT(SPEC_DIVI,'1') = 'B')"
    //                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
			}),
			Unilite.popup('CUST',{
				fieldLabel: '지급처', 
				valueFieldWidth: 90,
				textFieldWidth: 140,
				valueFieldName:'PAY_CUSTOM_CODE',
			    textFieldName:'PAY_CUSTOM_NAME',
	//				    validateBlank:'text',
//			    extParam: {
//	    			'CHARGE_CODE': getChargeCode[0].SUB_CODE
//	    			,'ADD_QUERY': "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"
//			    },  
			    listeners: {
			    	onValueFieldChange: function(field, newValue){
						panelResult.setValue('PAY_CUSTOM_CODE', newValue);	
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PAY_CUSTOM_NAME', newValue);	
					}
				}
			}),
			{ 
	    		fieldLabel: '지급예정일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'PRE_DATE_FR',
			    endFieldName: 'PRE_DATE_TO',
//			    startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
//			    allowBlank: false,                	
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
			},
			Unilite.popup('DEPT',{ 
                fieldLabel: '부서', 
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                readOnly:true,
                allowBlank:false
            }) 
            
            ]	
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2,
		tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '80%'}
//        	,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*width: '100%'/*,align : 'left'*/}
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
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },
        Unilite.popup('ACCNT',{
            fieldLabel: '계정과목', 
            valueFieldWidth: 90,
            textFieldWidth: 140,
            valueFieldName:'ACCNT_CODE',
            textFieldName:'ACCNT_NAME',
//                  validateBlank:'text',
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
                            'ADD_QUERY' : "(ISNULL(PROFIT_DIVI,'') IN ('X') OR LEFT(SPEC_DIVI,'1') = 'B')"
//                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
            }
        }),
        Unilite.popup('CUST',{
            fieldLabel: '지급처', 
            valueFieldWidth: 90,
            textFieldWidth: 140,
            valueFieldName:'PAY_CUSTOM_CODE',
            textFieldName:'PAY_CUSTOM_NAME',
//                  validateBlank:'text',
//            extParam: {
//                  'CHARGE_CODE': getChargeCode[0].SUB_CODE
//                  ,'ADD_QUERY': "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"
//            },  
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('PAY_CUSTOM_CODE', newValue);  
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('PAY_CUSTOM_NAME', newValue);  
                }
            }
        }),
        { 
            fieldLabel: '지급예정일',
            xtype: 'uniDateRangefield',
            startFieldName: 'PRE_DATE_FR',
            endFieldName: 'PRE_DATE_TO',
//              startDate: UniDate.get('startOfMonth'),
//              endDate: UniDate.get('today'),
//          allowBlank: false,                  
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
        },
        Unilite.popup('DEPT',{ 
            fieldLabel: '부서', 
            valueFieldName: 'DEPT_CODE',
            textFieldName: 'DEPT_NAME',
            readOnly:true,
            allowBlank:false
        }),
        {
            xtype: 'radiogroup',                            
            fieldLabel: '상태',
            id:'confirmChk',
            items: [{
                boxLabel: '전체', 
                width: 60,
                name: 'CONFIRM_CHK',
                inputValue: ''
            },{
                boxLabel: '확정', 
                width: 60,
                name: 'CONFIRM_CHK',
                inputValue: '0' 
            },{
                boxLabel: '미확정', 
                width: 60,
                name: 'CONFIRM_CHK',
                inputValue: '1',
                checked: true  
            }],
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {  
                	if(newValue.CONFIRM_CHK == '1'){
                        panelResult.down('#cmsButton1').setDisabled(false);
                        panelResult.down('#cmsButton2').setDisabled(false);
                    }else{
                        panelResult.down('#cmsButton1').setDisabled(true);
                        panelResult.down('#cmsButton2').setDisabled(true);
                    }
                	
                	
                    UniAppManager.app.onQueryButtonDown();
                }
            }
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:200,
            padding: '0 0 0 100',
//            tdAttrs: {align : 'center'},
            itemId:'cmsRegard1',
            items :[{
                xtype: 'button',
                text: '예금주조회하기',    
                itemId:'cmsButton1',
                name: '',
                width: 100, 
//                tdAttrs: {align : 'center'},
//                  hidden:true,
                handler : function() {
            
                    if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                       alert('수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.');
                       var sm = detailGrid.getSelectionModel();
                       var selRecords = detailGrid.getSelectionModel().getSelection();
                       sm.deselect(selRecords);
                       return false;
                       
                    } else {
                        var selectedRecords = detailGrid.getSelectedRecords();
                        if(selectedRecords.length > 0){
                        
                            cmsButtonStore.clearData();
                            Ext.each(selectedRecords, function(record,i){
                                record.phantom = true;
                                cmsButtonStore.insert(i, record);
                            });
                            cmsButtonFlag = 'SEND';
                            cmsButtonStore.saveStore();
                                                    
                        }else{
                            Ext.Msg.alert('확인','예금주조회하기 할 데이터를 선택해 주세요.'); 
                        }
                    }
                }
            },{
                xtype: 'button',
                text: '예금주결과받기',    
                itemId:'cmsButton2',
                name: '',
                width: 100, 
//                tdAttrs: {align : 'center'},
//                  hidden:true,
                handler : function() {
            
                    if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                       alert('수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.');
                       var sm = detailGrid.getSelectionModel();
                       var selRecords = detailGrid.getSelectionModel().getSelection();
                       sm.deselect(selRecords);
                       return false;
                       
                    } else {
                        var selectedRecords = detailGrid.getSelectedRecords();
                        if(selectedRecords.length > 0){
                        
                            cmsButtonStore.clearData();
                            Ext.each(selectedRecords, function(record,i){
                                record.phantom = true;
                                cmsButtonStore.insert(i, record);
                            });
                            cmsButtonFlag = 'RECEIVE';
                            cmsButtonStore.saveStore();
                                                    
                        }else{
                            Ext.Msg.alert('확인','예금주결과받기 할 데이터를 선택해 주세요.'); 
                        }
                    }
                }
            }]
        }, {               
            //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
            name:'DEC_FLAG', 
            xtype: 'uniTextfield',
            hidden: true
        }]
	});
        
    var detailGrid = Unilite.createGrid('abh222ukrGrid', {
//		layout: 'fit',
		region: 'center',
		excelTitle: '이체지급확정',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			onLoadSelectFirst: false,
			useRowNumberer: false,
			expandLastColumn: false,
			useRowContext: true,
    		state: {
				useState: true,			
				useStateList: true		
			}
        },
		features: [{
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
        tbar: [
        
        ],
		store: directDetailStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
            listeners: {  
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                }
            }
        }),
		columns: [
//			{ dataIndex: 'CHECK_VALUE'			,width:60,hidden:true},
        	{ dataIndex: 'ORG_AC_DATE'				,width:100,align:'center'},
        	{ dataIndex: 'ORG_SLIP_NUM'				,width:60, format:'0'},
        	{ dataIndex: 'ORG_SLIP_SEQ'				,width:50, format:'0'},
        	
        	{ dataIndex: 'ROW_NUMBER'			,width:60, align:'center', hidden:true},
        	{ dataIndex: 'CHK'			,width:80, align:'center', hidden:false},
//        	{ dataIndex: 'CONFIRM_YN_DUMMY'			,width:100},
        	{ dataIndex: 'PAYMENT_STATUS'			,width:80, align:'center', hidden:true},
        	
        	{ dataIndex: 'PAYMENT_STATUS_DETAIL'	,width:100, hidden:true},
        	
            { dataIndex: 'EX_DATE'             ,width:100, hidden:true},
            { dataIndex: 'EX_NUM'              ,width:100, hidden:true},
        	{ dataIndex: 'PRE_DATE'					,width:88},
//        	{ dataIndex: 'PAY_CUSTOM_CODE'		,width:100,locked:true},
//        	{ dataIndex: 'PAY_CUSTOM_NAME'		,width:150,locked:true},
        	{dataIndex: 'PAY_CUSTOM_CODE'   , width: 100,
                editor:Unilite.popup('CUST_G', {
                    autoPopup: true,
//                    textFieldName:'PAY_CUSTOM_NAME',
//                    DBtextFieldName: 'PAY_CUSTOM_NAME',
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('PAY_CUSTOM_CODE'     , records[0].CUSTOM_CODE);
                            grdRecord.set('PAY_CUSTOM_NAME'     , records[0].CUSTOM_NAME);
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('PAY_CUSTOM_CODE' , '');
                            grdRecord.set('PAY_CUSTOM_NAME' , '');  
                        }/*,
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var grdRecord = detailGrid.uniOpt.currentRecord;
                                if(grdRecord.get('PEND_CODE') != ''){
                                    pendCode = grdRecord.get('PEND_CODE');
                                }else{
                                    pendCode = grdRecord.get('PAY_DIVI_REF1');  
                                }
                                
                                var param = {
                                    'PEND_CODE': pendCode
                                }
                                popup.setExtParam(param);
                            }
                        }*/
                    }
                })
            },
            {dataIndex: 'PAY_CUSTOM_NAME'   , width: 150,
                editor:Unilite.popup('CUST_G', {
                    autoPopup: true,
                    textFieldName:'PAY_CUSTOM_NAME',
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('PAY_CUSTOM_CODE'     , records[0].CUSTOM_CODE);
                            grdRecord.set('PAY_CUSTOM_NAME'     , records[0].CUSTOM_NAME);
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('PAY_CUSTOM_CODE' , '');
                            grdRecord.set('PAY_CUSTOM_NAME' , '');  
                        }/*,
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var grdRecord = detailGrid.uniOpt.currentRecord;
                                if(grdRecord.get('PEND_CODE') != ''){
                                    pendCode = grdRecord.get('PEND_CODE');
                                }else{
                                    pendCode = grdRecord.get('PAY_DIVI_REF1');  
                                }
                                
                                var param = {
                                    'PEND_CODE': pendCode
                                }
                                popup.setExtParam(param);
                            }
                        }*/
                    }
                })
            },
    		{ dataIndex: 'DIV_CODE'		,width:100, hidden:true},
        	{ dataIndex: 'PEND_CODE'		,width:100, hidden:true},
        	
        	{ dataIndex: 'SET_METH'				,width:88, align:'center'},
        	{ dataIndex: 'TEMPCOL'              ,width:100, hidden:true},
        	{ dataIndex: 'REMARK'				,width:200, hidden:true},
        	{ dataIndex: 'MONEY_UNIT'			,width:80, align:'center', hidden:true},
  
        	{ dataIndex: 'ORG_AMT_I'              ,width:100},
        	{ dataIndex: 'J_AMT_I'                   ,width:100, hidden:true},
        	{ dataIndex: 'JAN_AMT_I'                 ,width:100},
        	{ dataIndex: 'IN_TAX_I'                  ,width:100},
        	{ dataIndex: 'LOCAL_TAX_I'               ,width:100},
        	{ dataIndex: 'REAL_AMT_I'                 ,width:100},
        	{ dataIndex: 'SEND_J_AMT_I'	             ,width:100, hidden:true},
 
        	{ dataIndex: 'SEND_J_AMT_I_DUMMY'		,width:100, hidden:true},
        	
        	{ dataIndex: 'SEQ'						,width:100,hidden:true},
        	{ dataIndex: 'CONF_SEND_NUM'			,width:100,hidden:true},        	
            {dataIndex:  'ACCNT'               ,       width: 100  , hidden:true
                ,'editor' : Unilite.popup('ACCNT_G',{   
                        DBtextFieldName: 'ACCNT_CODE',
                        autoPopup:true,
                        listeners: {
                            'onSelected': {
                                fn: function(records, type) {
                                    grdRecord = detailGrid.uniOpt.currentRecord;
                                    record = records[0];
                                    grdRecord.set('ACCNT',  record.ACCNT_CODE);
                                    grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                grdRecord = detailGrid.uniOpt.currentRecord;
                                grdRecord.set('ACCNT', '');
                                grdRecord.set('ACCNT_NAME', '');
                            },
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
                    })
              },                  
              {dataIndex: 'ACCNT_NAME'          ,       width: 150 , hidden:true
                 ,'editor' : Unilite.popup('ACCNT_G',{
                        autoPopup:true,
                        textFieldName:'ACCNT_NAME',
                        listeners: {
                            'onSelected': {
                                fn: function(records, type) {
                                    grdRecord = detailGrid.uniOpt.currentRecord;
                                    grdRecord.set('ACCNT',  record.ACCNT_CODE);
                                    grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                grdRecord = detailGrid.uniOpt.currentRecord;
                                grdRecord.set('ACCNT', '');
                                grdRecord.set('ACCNT_NAME', '');
                            },
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
                    })
              },  
            {dataIndex:'IN_SAVE_CODE'                  , width: 100, hidden:true,
                editor: Unilite.popup('BANK_BOOK_G', {      
                    DBtextFieldName: 'BANK_BOOK_NAME',
					autoPopup:true,
                    listeners: {'onSelected': {
                            fn: function(records, type) {                                                       
                                Ext.each(records, function(record,i) {                                                                          
                                    if(i==0) {
                                        var grdRecord = detailGrid.uniOpt.currentRecord;
                                        grdRecord.set('IN_SAVE_CODE',record['BANK_BOOK_CODE'] );
                                        grdRecord.set('IN_SAVE_NAME',record['BANK_BOOK_NAME'] );
                                        grdRecord.set('ACCOUNT_NUM',record['DEPOSIT_NUM'] ); //계좌번호 
                                        grdRecord.set('BANK_CODE',record['BANK_CD'] );//은행코드
                                        grdRecord.set('BANK_NAME',record['BANK_NM'] );//은행명
                                        grdRecord.set('BANK_ACCOUNT_EXPOS', '*************' );//은행명  
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('IN_SAVE_CODE','');
                            grdRecord.set('IN_SAVE_NAME','');
                        }
                    }
            })},    
            {dataIndex:'IN_SAVE_NAME'                  , width: 140, hidden:true, 
                editor: Unilite.popup('BANK_BOOK_G', {      
                    DBtextFieldName: 'BANK_BOOK_NAME',
					autoPopup:true,
                    listeners: {'onSelected': {
                            fn: function(records, type) {                                                       
                                Ext.each(records, function(record,i) {                                                                          
                                    if(i==0) {
                                        var grdRecord = detailGrid.uniOpt.currentRecord;
                                        grdRecord.set('IN_SAVE_CODE',record['BANK_BOOK_CODE'] );
                                        grdRecord.set('IN_SAVE_NAME',record['BANK_BOOK_NAME'] );
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('IN_SAVE_CODE','');
                            grdRecord.set('IN_SAVE_NAME','');
                        }
                    }
            })},            
            {dataIndex: 'BANK_CODE'             ,width: 133,
                editor: Unilite.popup('BANK_G', {
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            grdRecord = detailGrid.uniOpt.currentRecord;
                            record = records[0];                                    
                            grdRecord.set('BANK_CODE', record['BANK_CODE']);
                            grdRecord.set('BANK_NAME', record['BANK_NAME']);
                        },
                        onClear:function(type)  {
                            grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('BANK_CODE', '');
                            grdRecord.set('BANK_NAME', '');
                        }
                    }
                })
          },
          {dataIndex: 'BANK_NAME'           ,       width: 133,
            editor: Unilite.popup('BANK_G', {
                autoPopup: true,
                textFieldName:'BANK_NAME',
                listeners:{
                    scope:this,
                    onSelected:function(records, type ) {
                        grdRecord = detailGrid.uniOpt.currentRecord;
                        record = records[0];                                    
                        grdRecord.set('BANK_CODE', record['BANK_CODE']);
                        grdRecord.set('BANK_NAME', record['BANK_NAME']);
                    },
                    onClear:function(type)  {
                        grdRecord = detailGrid.uniOpt.currentRecord;
                        grdRecord.set('BANK_CODE', '');
                        grdRecord.set('BANK_NAME', '');
                    }
                }
            })
        },
        	{ dataIndex: 'BANK_ACCOUNT'			,width:120, hidden: true},
        	{ dataIndex: 'ACCOUNT_NUM'          ,width:120, hidden: true},
        	{ dataIndex: 'BANK_ACCOUNT_EXPOS'	 ,width:120},
        	{ dataIndex: 'BANKBOOK_NAME'		 ,width:120},
        	{ dataIndex: 'RCPT_ID'               ,width:120, hidden: false},
        	{ dataIndex: 'RCPT_NAME'             ,width:120, hidden: false},
        	{ dataIndex: 'CMS_TRANS_YN'          ,width:120, hidden: false},
        	{ dataIndex: 'RCPT_RESULT_MSG'       ,width:120, hidden: false},
        	{ dataIndex: 'RCPT_STATE_NUM'        ,width:120, hidden: false},
        	
        	{ dataIndex: 'MODY_YN'             ,width:100, hidden:true},
        	
        	{ dataIndex: 'NOTE_NUM'             ,width:120, hidden: true},
        	{ dataIndex: 'PUB_DATE'             ,width:120, hidden: true},
        	{ dataIndex: 'EXP_DATE'				,width:100, align:'center', hidden: true},
//        	{ dataIndex: 'EXP_DATE'             ,width:120},
            {dataIndex:'OUT_SAVE_CODE'                  , width: 100,  hidden: true,
                editor: Unilite.popup('BANK_BOOK_G', {      
                    DBtextFieldName: 'BANK_BOOK_NAME',
					autoPopup:true,
                    listeners: {'onSelected': {
                            fn: function(records, type) {                                                       
                                Ext.each(records, function(record,i) {                                                                          
                                    if(i==0) {
                                        var grdRecord = detailGrid.uniOpt.currentRecord;
                                        grdRecord.set('OUT_SAVE_CODE',record['BANK_BOOK_CODE'] );
//                                        grdRecord.set('OUT_SAVE_NAME',record['BANK_BOOK_NAME'] );
//                                        grdRecord.set('ACCOUNT_NUM',record['DEPOSIT_NUM'] ); //계좌번호 
                                        grdRecord.set('OUT_BANK_CODE',record['BANK_CD'] );//은행코드
//                                        grdRecord.set('BANK_NAME',record['BANK_NM'] );//은행명
//                                        grdRecord.set('BANK_ACCOUNT_EXPOS', '*************' );//은행명  
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('OUT_SAVE_CODE','');
//                            grdRecord.set('OUT_SAVE_NAME','');
                        }
                    }
            })},            
            {dataIndex: 'OUT_BANK_CODE'             ,width: 133, hidden: true,
                editor: Unilite.popup('BANK_G', {
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            grdRecord = detailGrid.uniOpt.currentRecord;
                            record = records[0];                                    
                            grdRecord.set('OUT_BANK_CODE', record['BANK_CODE']);
//                            grdRecord.set('OUT_BANK_NAME', record['BANK_NAME']);
                        },
                        onClear:function(type)  {
                            grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('OUT_BANK_CODE', '');
//                            grdRecord.set('OUT_BANK_NAME', '');
                        }
                    }
                })
          },
          { dataIndex: 'REMARK'  ,width:150}
        ],
        listeners: {
        	beforecelldblclick : function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
        		var columnName = view.eventPosition.column.dataIndex;
        		//alert(record.get('CONFIRM_YN'));
        		if(columnName == 'BANK_ACCOUNT_EXPOS'){
        				if(record.get('CHK') == '1'){
    					   	mainGridReceiveRecord = record;                        
                            openSubGridWindow();
        				}else{
        					detailGrid.openCryptAcntNumPopup(record);
        				}
        				
        			/*if(record.get('CONFIRM_YN') == 'Y'){
        		      				,,,
        				mainGridReceiveRecord = record;        				
	        			openSubGridWindow();
	        				        			
	        		}else{
	        			//return false;
	        			detailGrid.openCryptAcntNumPopup(record);
        			}*/
        		}
        	},
       /* 	celldblclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
    			alert('dddd');
//    			if(cellIndex==8)	{
//    				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null, null, null, null,  'VALUE');			
//    			}
    		},*/
        	afterrender:function()	{
        		
			},
			/*beforeselect: function(rowSelection, record, index, eOpts) { 
                var focusMove = true;
                
                if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                    alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
                    focusMove = false;
                    var sm = detailGrid.getSelectionModel();
                    var selRecords = detailGrid.getSelectionModel().getSelection();
                    sm.deselect(selRecords);
                }
                
                return focusMove;
            },*/
			beforeedit : function( editor, e, eOpts ) {
				if(e.record.phantom){
					if(e.record.data.SET_METH == '10'){      //지급구분: 예금
                        if(UniUtils.indexOf(e.field, ['NOTE_NUM','PUB_DATE','EXP_DATE'])){
                             return false;                   	
                        }
					}else if(e.record.data.SET_METH == '30'){    //지급구분: 전자어음
					   if(UniUtils.indexOf(e.field, ['OUT_SAVE_CODE','OUT_BANK_CODE'])){
                             return false;                      
                       }
					}
					return true;
				}else{ 
        				if(e.record.data.CHK == '1'){
        					if(UniUtils.indexOf(e.field, ['PRE_DATE','BANK_CODE','BANK_NAME','BANK_ACCOUNT','BANKBOOK_NAME','REMARK'])){
        						return true;
        					}else{
        						return false;	
        					}
        				}else{
        					return false;	
        				}
    				
				
				
			/*	if(e.record.phantom == true){
					if(UniUtils.indexOf(e.field, ['COMP_CODE','INSERT_DB_USER','INSERT_DB_TIME','UPDATE_DB_USER','UPDATE_DB_TIME'])){
						return false;
					}else{
						return true;	
					}
				}else{
					if(UniUtils.indexOf(e.field, ['DEPT_DIVI','ACCNT','ACCNT_NAME','COMP_CODE','INSERT_DB_USER','INSERT_DB_TIME','UPDATE_DB_USER','UPDATE_DB_TIME'])){
						return false;
					}else{
						return true;	
					}	
				}*/
				
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

    var subGrid = Unilite.createGrid('abh222ukrSubGrid', {    	
    	//region:'center',
    	store : directSubStore,
    	sortableColumns : false,
//    	layout: 'fit',
    	width: 600,				                
        height: 300,
//    	margin: '0 0 0 116',
    	
    	excelTitle: '계좌정보 서브 그리드',
    	//border:false,
    	uniOpt:{
			 expandLastColumn: false
//			,dblClickToEdit	: true
			,useRowNumberer: true
			,useMultipleSorting: false
			,onLoadSelectFirst	: true
			,enterKeyCreateRow: false//마스터 그리드 추가기능 삭제
			,state: {
				useState: false,			
				useStateList: false
			}
    	},
    	dockedItems: [{    		
	        xtype: 'toolbar',
	        dock: 'top',
	        items: [{
                xtype: 'uniBaseButton',
		 		text : '조회',
		 		tooltip : '조회',
		 		iconCls : 'icon-query', 
		 		width: 26, height: 26,
		 		itemId : 'sub_query',
				handler: function() { 
					var param = {
					PAY_CUSTOM_CODE: mainGridReceiveRecord.get('PAY_CUSTOM_CODE')
						
					}
					directSubStore.loadStoreRecords(param);
					//if( me._needSave()) {
					/*var toolbar = subGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					var record = detailGrid.getSelectedRecord();
					if(needSave) {
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	//console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
				                  		directSubStore.saveStore();
				                    });
				                    saveTask.delay(500);
						     	} else if(res === 'no') {
						     		directSubStore.loadStoreRecords(record);
						     	}
						     }
						});
					} else {
						directSubStore.loadStoreRecords(record);
					}*/
				}
			},/*{
                xtype: 'uniBaseButton',
				text : '신규',
				tooltip : '초기화',
				iconCls: 'icon-reset',
				width: 26, height: 26,
		 		itemId : 'sub_reset',
				handler : function() { 
					directSubStore.clearData();
					subGrid.reset();
				}
			},*/{
                xtype: 'uniBaseButton',
				text : '추가',
				tooltip : '추가',
				iconCls: 'icon-new',
				width: 26, height: 26,
		 		itemId : 'sub_newData',
				handler : function() { 
//					var mainGridRecord = detailGrid.getSelectedRecord();
					
					var customCode = mainGridReceiveRecord.get('PAY_CUSTOM_CODE');
					var mainBookYn  = 'N'; 
					
	            	var r = {
	            	 	CUSTOM_CODE : customCode,
	            	 	MAIN_BOOK_YN: mainBookYn
			        };
					subGrid.createRow(r);
				}
			},{
                xtype: 'uniBaseButton',
				text : '삭제',
				tooltip : '삭제',
				iconCls: 'icon-delete',disabled: true,
				width: 26, height: 26,
		 		itemId : 'sub_delete',
				handler : function() { 
					var selRow = subGrid.getSelectedRecord();
					if(selRow.phantom === true)	{
						subGrid.deleteSelectedRow();
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						subGrid.deleteSelectedRow();						
					}	
				}				
			},{
                xtype: 'uniBaseButton',
				text : '저장', 
				tooltip : '저장', 
				iconCls: 'icon-save',disabled: true,
				width: 26, height: 26,
		 		itemId : 'sub_save',
				handler : function() {
					var inValidRecs = directSubStore.getInvalidRecords();       	
					if(inValidRecs.length == 0 )	{
						directSubStore.saveStore();
					}else {
						subGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}                  
                }
			}]
	    }],

    	/* tbar: ['->',
            {
	        	text:'상세보기',
	        	handler: function() {
	        		var record = detailGrid.getSelectedRecord();
		        	if(record) {
		        		openDetailWindow(record);
		        	}
	        	}
            }
        ],*/
        columns:  [ 
        	{ dataIndex: 'CUSTOM_CODE'	 		,  		width: 120, hidden:true},
        	{ dataIndex: 'BOOK_CODE'            ,       width: 120},
            { dataIndex: 'BOOK_NAME'            ,       width: 100},
            
			{ dataIndex: 'BANK_CODE'	 		,  		width: 120,
				editor:Unilite.popup('BANK_G', {
					autoPopup: true,
					textFieldName:'BANK_NAME',
					DBtextFieldName: 'BANK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
						   	grdRecord.set('BANK_CODE'	, records[0].BANK_CODE);
							grdRecord.set('BANK_NAME'	, records[0].BANK_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE'	, '');
							grdRecord.set('BANK_NAME'	, '');
						}
					}
				})
			},
			{ dataIndex: 'BANK_NAME'	 		,  		width: 130,
				editor:Unilite.popup('BANK_G', {
					autoPopup: true,
					textFieldName:'BANK_NAME',
					DBtextFieldName: 'BANK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
						   	grdRecord.set('BANK_CODE'	, records[0].BANK_CODE);
							grdRecord.set('BANK_NAME'	, records[0].BANK_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE'	, '');
							grdRecord.set('BANK_NAME'	, '');
						}
					}
				})
			},
			{ dataIndex: 'BANK_ACCOUNT'		  ,  	width: 150, hidden: true},
        	{dataIndex: 'BANK_ACCOUNT_EXPOS'  ,		width: 120 },			
			{ dataIndex: 'BANKBOOK_NAME'	  ,  	width: 100},
            { dataIndex: 'MAIN_BOOK_YN'       ,     width: 100}
			
		],
		listeners: {          	
			beforeedit : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['CUSTOM_CODE']) || UniUtils.indexOf(e.field, ['BANK_ACCOUNT_EXPOS'])){
					return false;
				}else if(UniUtils.indexOf(e.field, ['BOOK_CODE'])){
                    if(e.record.phantom){
                        return true;
                    }else{
                        return false;
                    }
                }else{
                    return true;	
                }
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="BANK_ACCOUNT_EXPOS") {
					subGrid.openCryptAcntNumPopup(record);
				}
			}
		},
		returnData: function()	{
       		var record = this.getSelectedRecord();
       		
//       		var mainGridRecord = detailGrid.getSelectedRecord();
//       		var mainGridRecord = detailGrid.uniOpt.currentRecord;
       		if(!Ext.isEmpty(mainGridReceiveRecord)){
	       		mainGridReceiveRecord.set('BANK_CODE'		,record.get('BANK_CODE'));
	       		mainGridReceiveRecord.set('BANK_NAME'		,record.get('BANK_NAME'));
	       		mainGridReceiveRecord.set('BANK_ACCOUNT'	,record.get('BANK_ACCOUNT'));
	       		mainGridReceiveRecord.set('BANKBOOK_NAME'	,record.get('BANKBOOK_NAME'));
       		}
		},
		openCryptAcntNumPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);
			}
				
		}
    });
  	function openSubGridWindow() {    		
//  		if(!UniAppManager.app.checkForNewDetail()) return false;

		if(!subGridWindow) {
			subGridWindow = Ext.create('widget.uniDetailWindow', {
                width: 600,				                
        		height: 300,
                layout:{type:'vbox', align:'stretch'},
                items: [subGrid],
                tbar:  [
					'->',{	
						itemId : 'saveBtn',
						text: '확인',
						handler: function() {
							var cnt = 0;
							Ext.each(directSubStore.data.items, function(record, i){
								if(record.phantom == true){
								    cnt = cnt + 1;	
								}
							})
							
							if(cnt > 0){
							     alert('신규로 입력하신 데이터가 있습니다. 저장 후 확인을 눌러주십시오.');	
							}else{
							
    							subGrid.returnData();
    							subGridWindow.hide();
    							subGrid.reset();
							}
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							subGridWindow.hide();
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
		 				var param = {
							PAY_CUSTOM_CODE: mainGridReceiveRecord.get('PAY_CUSTOM_CODE')
							
						}
		 				directSubStore.loadStoreRecords(param);
		 				
		 			}
		 			
				}
			})
		}
		subGridWindow.center();
		subGridWindow.show();
    }
    
    //복호화 버튼 정의
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
			items:[
				panelResult,{
                   xtype: 'container',
                   region: 'center',
                   layout: {type: 'vbox', align: 'stretch'},
                   items: [
                       //subForm1, 
                       detailGrid
                   ]
                }
			]	
		},
			panelSearch
		],
		id  : 'abh222ukrApp',
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons(['newData','delete','save'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
			
			//복호화버튼 그리드 툴바에 추가
            var tbar = detailGrid._getToolBar();
            tbar[0].insert(tbar.length + 1, decrypBtn);
            
			//this.setDefault();
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ORG_AC_DATE_FR');
			
			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
			
            panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
            panelResult.setValue('DEPT_NAME',UserInfo.deptName);
            
            
            if(Ext.getCmp('confirmChk').getValue().CONFIRM_CHK == '1'){
                panelResult.down('#cmsButton1').setDisabled(false);
                panelResult.down('#cmsButton2').setDisabled(false);
            }else{
                panelResult.down('#cmsButton1').setDisabled(true);
                panelResult.down('#cmsButton2').setDisabled(true);
            }
			
		},
		onQueryButtonDown: function() {      
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			
			directDetailStore.loadStoreRecords();		
		},
		onNewDataButtonDown: function()	{
		},
		onResetButtonDown: function() {
//			panelSearch.clearForm();
//			panelResult.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			this.fnInitBinding();
		},
		
		onSaveDataButtonDown: function(config) {				
			directDetailStore.saveStore();
		},
		
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else{
                alert("신규로 추가된 데이터 중 저장하기전 데이터 만 삭제가 가능합니다.");
			}
		}
		/*onDeleteAllButtonDown: function() {			
			var records = directDetailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							detailGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},*/
/*		setDefault: function(){
            if(!Ext.isEmpty(BsaCodeInfo.getCmsId)){
				panelResult.down('#cmsIdCheck1').setHidden(false);
				panelResult.down('#cmsIdCheck2').setHidden(false);
				panelResult.down('#cmsIdCheck3').setHidden(false);
				panelResult.down('#cmsIdCheck4').setHidden(false);
            }else{
				panelResult.down('#cmsIdCheck1').setHidden(true);
                panelResult.down('#cmsIdCheck2').setHidden(true);
                panelResult.down('#cmsIdCheck3').setHidden(true);
                panelResult.down('#cmsIdCheck4').setHidden(true);
			}
		} */
/*		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('resultForm').getValues();
	         
	         var prgId = '';
	         
	         
//	         if(라디오 값에따라){
//	         	prgId = 'abh222rkr';	
//	         }else if{
//	         	prgId = 'abh221rkr';
//	         }
	         
	         
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/abh/abh222rkrPrint.do',
//	            prgID:prgId,
	            prgID: 'abh222rkr',
	               extParam: {
	                    COMP_CODE:       	param.COMP_CODE       
//						INOUT_SEQ:  	    param.INOUT_SEQ,  	 
//						INOUT_NUM:          param.INOUT_NUM,      
//						DIV_CODE:           param.DIV_CODE, 
//						INOUT_CODE:         param.INOUT_CODE,      
//						INOUT_DATE:         param.INOUT_DATE,      
//						ITEM_CODE:          param.ITEM_CODE,       
//						INOUT_Q:            param.INOUT_Q,         
//						INOUT_P:            param.INOUT_P,         
//						INOUT_I:            param.INOUT_I,
//						INOUT_DATE_FR:      param.INOUT_DATE_FR,      
//						INOUT_DATE_TO:      param.INOUT_DATE_TO  
	               }
	            });
	            win.center();
	            win.show();
	               
	      }*/
		
	});
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
    		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
    		var rv = true;
    		switch(fieldName) {
                case "ORG_AMT_I" : 
                    record.set('JAN_AMT_I', newValue);
                    record.set('REAL_AMT_I', newValue);
                break;
    		}
            return rv;
		}
	});	
};

</script>