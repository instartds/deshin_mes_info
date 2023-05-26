<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="abh220ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="J682" /> <!-- 결재상태(내부결재) -->
	<t:ExtComboStore comboType="AU" comboCode="A395" /> <!-- 지급방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B131" /><!--예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="A010" /> <!-- 법인/개인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A237" /> <!-- 카드구분 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >
//var getChargeCode = ${getChargeCode};
//
//if(getChargeCode == '' ){
//	getChargeCode = [{"SUB_CODE":""}];
//}
var subGridWindow;

var mainGridReceiveRecord = '';

var buttonFlag ='';     // 확정, 미확정, 보류, 보류해제

var cmsButtonFlag ='';  //예금주조회하기, 예금주 결과받기

var autoSlipButtonFlag ='';  // 자동기표, 기표취소

var BsaCodeInfo = { 
    getCmsId: '${getCmsId}'
}

var setMethMaster = '';   // 이체지급 버튼 누를시 로우들에 서로 다른 SET_METH 값 있으면 10 set 하기 위해

var outSaveCodeMaster = '';   // 이체지급 버튼 누를시 출금통장코드 저장관련

var exDate = '';        // 이체지급 버튼 누를시 EX_DATE ABH200T 저장관련
var exNum  = '';        // 이체지급 버튼 누를시 EX_NUM  ABH200T 저장관련 

function appMain() {
	var statusStore = Unilite.createStore('statusComboStore', {  
	    fields: ['text', 'value'],
		data :  [
	        {'text':'미확정'  , 'value':'N'},
	        {'text':'확정'	, 'value':'Y'},
			{'text':'보류'	, 'value':'C'}
		]
	});
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'abh220ukrService.selectList',
			update: 'abh220ukrService.updateDetail',
			create: 'abh220ukrService.insertDetail',
			destroy: 'abh220ukrService.deleteDetail',
			syncAll: 'abh220ukrService.saveAll'
		}
	});	
	var directSubProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'abh220ukrService.selectSubList',
			update: 'abh220ukrService.updateSubDetail',
			create: 'abh220ukrService.insertSubDetail',
			destroy: 'abh220ukrService.deleteSubDetail',
			syncAll: 'abh220ukrService.subSaveAll'
		}
	});
	
	
	var directProxyButton = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'abh220ukrService.insertDetailButton',
			syncAll: 'abh220ukrService.saveAllButton'
		}
	});	
	
	var directProxyRequest = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'abh220ukrService.insertDetailRequest',
			syncAll: 'abh220ukrService.saveAllRequest'
		}
	});	
	
	var directProxyCmsButton = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'abh220ukrService.insertDetailCmsButton',
            syncAll: 'abh220ukrService.saveAllCmsButton'
        }
    }); 
    
    //자동기표,취소 프록시
    var directProxyAutoSlipButton= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'abh220ukrService.insertDetailAutoSlipButton',
            syncAll: 'abh220ukrService.saveAllAutoSlipButton'
        }
    }); 
    // 이체지급등록 테이블 저장 관련
    var directProxyAbh200SaveButton = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'abh220ukrService.insertDetailAbh200SaveButton',
            syncAll: 'abh220ukrService.saveAllAbh200SaveButton'
        }
    }); 
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('abh220ukrModel', {
	    fields: [
//	    	{name: 'CHECK_VALUE'			,text: 'check'					,type: 'string'},
	    
	    	{name: 'ROW_NUMBER'			        ,text: 'NO'					,type: 'string', editable: false},
	    	{name: 'CONFIRM_YN'			        ,text: '상태'					,type: 'string',store: Ext.data.StoreManager.lookup('statusComboStore'), editable: false},//ABH220T
//	    	{name: 'CONFIRM_YN_DUMMY'   ,text: '상태 더미'					,type: 'string'},
	    	{name: 'PAYMENT_STATUS'		        ,text: '결재상태'				,type: 'string',comboType:'AU', comboCode:'J682', editable: false},
	    	{name: 'PAYMENT_STATUS_DETAIL'		,text: '결재상태_REF_CODE1'	,type: 'string', editable: false},
	    	
	    	
            {name: 'OUT_SAVE_CODE'              ,text: '출금통장코드'           ,type: 'string'},    //지급방법: 예금
            {name: 'OUT_BANK_CODE'              ,text: '출금은행코드'           ,type: 'string'},     //지급방법: 예금
	    	
            
            
	    	{name: 'PRE_DATE'			        ,text: '지급예정일'				,type: 'uniDate'/*, editable: false*/},
	    	{name: 'PAY_CUSTOM_CODE'	        ,text: '지급처'				,type: 'string'},//ABH220T
	    	{name: 'PAY_CUSTOM_NAME'	        ,text: '지급처명'				,type: 'string'},
	    	{name: 'DIV_CODE'			        ,text: '사업장'				,type: 'string', editable: false},
	    	{name: 'PEND_CODE'			        ,text: '미결항목코드'			,type: 'string', editable: false},
	    	{name: 'SET_METH'			        ,text: '지급방법'				,type: 'string',comboType:'AU', comboCode:'A395', allowBlank: true, defaultValue: '10'},//ABH220T
	    	{name: 'TRANS_YN'                    ,text: '전송대상'              ,type: 'string', comboType:'AU',comboCode:'B131'},
	    	{name: 'REMARK'				        ,text: '적요'					,type: 'string'},
	    	{name: 'MONEY_UNIT'			        ,text: '화폐단위'				,type: 'string',comboType:'AU', comboCode:'B004', displayField: 'value'},	//ABH220T
	    	{name: 'ORG_AMT_I'		            ,text: '발생금액'				,type: 'uniPrice', editable: false},
	   	    {name: 'J_AMT_I'			        ,text: '반제된금액'				,type: 'uniPrice', editable: false},
	   	    {name: 'JAN_AMT_I'                  ,text: '지급대상금액'           ,type: 'uniPrice', editable: false},//AGB300T
	   	    {name: 'SEND_J_AMT_I'              ,text: '지급확정금액'         ,type: 'uniPrice'/*, editable: false*/},//ABH220T
            {name: 'SEND_J_AMT_I_DUMMY'         ,text: '이체금액_DUMMY'     ,type: 'uniPrice', editable: false},//ABH220T
	    	{name: 'IN_TAX_I'                   ,text: '소득세'               ,type: 'uniPrice', editable: false},
            {name: 'LOCAL_TAX_I'                ,text: '주민세'               ,type: 'uniPrice', editable: false},
            {name: 'REAL_AMT_I'                 ,text: '실지급액'              ,type: 'uniPrice', editable: false},
	    	
	    	{name: 'ORG_AC_DATE'		        ,text: '발생일'				,type: 'string', allowBlank: false},
	    	{name: 'ORG_SLIP_NUM'		        ,text: '번호'					,type: 'int',  editable: false},
	    	{name: 'ORG_SLIP_SEQ'		        ,text: '순번'					,type: 'int',  editable: false},
	    	{name: 'SEQ'				        ,text: 'SEQ'				,type: 'int', editable: false},
	    	{name: 'CONF_SEND_NUM'			    ,text: 'CONF_SEND_NUM'		,type: 'string', editable: false},
	    	{name: 'ACCNT'				        ,text: '계정과목'				,type: 'string', allowBlank: false},//ABH220T
	    	{name: 'ACCNT_NAME'                 ,text: '계정과목명'            ,type: 'string'},
	    	{name: 'CRDT_NUM'                   ,text: '카드번호'            ,type: 'string', editable: false},
	    	{name: 'CRDT_NUM_EXPOS'             ,text: '카드번호'            ,type: 'string', defaultValue:'*************', editable: false},
	    	{name: 'CARD_TYPE'                  ,text: '카드구분'            ,type: 'string',comboType:'AU', comboCode:'A237', editable: false},
	    	{name: 'IN_SAVE_CODE'               ,text: '입금통장코드'           ,type: 'string'},
	    	{name: 'IN_SAVE_NAME'               ,text: '입금통장명'            ,type: 'string'},
	    	{name: 'BANK_CODE'			        ,text: '입금은행코드'			,type: 'string'},//ABH220T   
	    	{name: 'BANK_NAME'			        ,text: '입금은행명'				,type: 'string', editable: false},
	    	{name: 'BANK_ACCOUNT'		        ,text: '입금계좌번호(DB)'		,type: 'string', editable: false},//ABH220T
	    	{name: 'BANK_ACCOUNT_EXPOS'	        ,text: '계좌번호'				,type: 'string', defaultValue:'*************', editable: false},
	    	{name: 'BANKBOOK_NAME'		        ,text: '예금주'				,type: 'string'},//ABH220T
	    	
	    	{name: 'IN_REMARK'                  ,text: '입금통장표시내용'        ,type: 'string'},
	    	
	    	{name: 'RCPT_ID'                    ,text: '예금주전송ID'          ,type: 'string', editable: false},
	    	{name: 'RCPT_NAME'                  ,text: '예금주명결과'           ,type: 'string', editable: false},
            {name: 'CMS_TRANS_YN'               ,text: '예금주전송'            ,type: 'string', editable: false},
            {name: 'RCPT_RESULT_MSG'            ,text: '예금주조회결과 '         ,type: 'string', editable: false},
            {name: 'RCPT_STATE_NUM'             ,text: '예금주전문번호'          ,type: 'string', editable: false},
//	    	{name: 'EXP_DATE'			,text: '만기일'					,type: 'uniDate'},//ABH220T
	    	{name: 'MODY_YN'                    ,text: 'MODY_YN'            ,type: 'string', editable: false},
	    	
	    	{name: 'EX_DATE'                    ,text: '결의전표일자'           ,type: 'uniDate', editable: false},
            {name: 'EX_NUM'                     ,text: '결의전표번호'           ,type: 'int', editable: false},
            
            
            
//          {name: 'BANKBOOK_NAME'       ,text: '예금주명'                ,type: 'string'},    //지급방법: 예금
//          {name: 'ACCOUNT_NUM'         ,text: '계좌번호'                ,type: 'string'},    //지급방법: 예금
//          {name: 'BANK_CODE'           ,text: '은행코드'                ,type: 'string'},    //지급방법: 예금
//          {name: 'BANK_NAME'           ,text: '은행명'                 ,type: 'string'}     //지급방법: 예금
	    	{name: 'NOTE_NUM'                   ,text: '지급어음번호'           ,type: 'string'},    //지급방법: 어음        
	    	{name: 'PUB_DATE'                   ,text: '발행일'               ,type: 'uniDate'},    //지급방법: 어음
	    	{name: 'EXP_DATE'                   ,text: '만기일'               ,type: 'uniDate'},    //지급방법: 어음
	    	
	    	
	    	{name: 'DED_TYPE'                   ,text: 'DED_TYPE'            ,type: 'string', editable: false},

	    	{name: 'EVDE_TYPE'                   ,text: '증빙종류'            ,type: 'string', editable: false},
	    	{name: 'DEPT_CODE'                   ,text: '부서'            ,type: 'string', editable: false},
	    	{name: 'DEPT_NAME'                   ,text: '부서명'            ,type: 'string', editable: false}
		]
	});
	Unilite.defineModel('abh220ukrSubModel', {
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
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('abh220ukrDetailStore', {
		model: 'abh220ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
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
                var grid = Ext.getCmp('abh220ukrGrid');
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
	var directSubStore = Unilite.createStore('abh220ukrSubStore', {
		model: 'abh220ukrSubModel',
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
	
	var buttonStore = Unilite.createStore('Abh220ukrbuttonStore',{		
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: directProxyButton,
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();

			var paramMaster = panelResult.getValues();
			
			paramMaster.BUTTON_FLAG = buttonFlag;
			
			if(buttonFlag == 'BC'){
				paramMaster.OUT_BANK_CODE = subForm1.getValue('OUT_BANK_CODE');
                paramMaster.OUT_SAVE_CODE = subForm1.getValue('OUT_SAVE_CODE');
			}
			
			
//			param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
       
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
	
	var cmsButtonStore = Unilite.createStore('Abh220ukrCmsbuttonStore',{     
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
    
    var autoSlipButtonStore = Unilite.createStore('Abh220ukrAutoSlipButtonStore',{     
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyAutoSlipButton,
        saveStore: function() {     
            var paramMaster = panelResult.getValues();
            paramMaster.AUTO_SLIP_BUTTON_FLAG = autoSlipButtonFlag;
            paramMaster.CMS_ID = BsaCodeInfo.getCmsId;
            
            paramMaster.IN_EX_DATE = UniDate.getDbDateStr(subForm1.getValue('IN_EX_DATE'));
            
            config = {
                params: [paramMaster],
                success: function(batch, option) {
                	
                	autoSlipButtonFlag = '';
                    UniAppManager.app.onQueryButtonDown();
                },
                failure: function(batch, option) {
                    autoSlipButtonFlag = '';
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
    
    var abh200SaveButtonStore = Unilite.createStore('Abh220ukrAbh200SaveButtonStore',{      
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyAbh200SaveButton,
        saveStore: function() {             
            
            var paramMaster = panelResult.getValues(); 
            paramMaster.PAY_METH = setMethMaster;
            paramMaster.PAY_CODE = outSaveCodeMaster;
            
            paramMaster.EX_DATE = exDate;
            paramMaster.EX_NUM = exNum;
//          param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
            config = {
                params: [paramMaster],
                success: function(batch, option) {
                    var master = batch.operations[0].getResultSet();
                    setMethMaster ='';
                    outSaveCodeMaster ='';
                    exDate ='';
                    exNum ='';
                    master.KEY_NUMBER
                    
                    var params = {
                        'PGM_ID'           : 'abh220ukr',
                        'SEND_NUM'         : master.KEY_NUMBER
                    }
                    var rec1 = {data : {prgID : 'abh201ukr', 'text':''}};                           
                    parent.openTab(rec1, '/accnt/abh201ukr.do', params);
//                    UniAppManager.app.onQueryButtonDown();
                    
                },
                failure: function(batch, option) {
                    setMethMaster ='';
                    outSaveCodeMaster ='';
                    exDate ='';
                    exNum ='';
                }
            };
            this.syncAllDirect(config);
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
			}]	
		}]
	});
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3,
		tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*//*width: '80%'*/}
//        	tdAttrs: {style: 'border : 1px solid #ced9e7;'/*width: '100%'/*,align : 'left'*/}
		
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:400,
//          id:'tdPayDtlNo',
//            tdAttrs: {width:500/*align : 'center'*/},
            items :[{
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
                xtype:'uniTextfield',
                fieldLabel:'',
                name:'ORG_SLIP_NUM',
                width:40
            }]
		},{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:400,
//          id:'tdPayDtlNo',
//            tdAttrs: {width:500/*align : 'center'*/},
            items :[{
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
            }]
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
        },{
            fieldLabel:'지급방법',
            name:'SET_METH',
            xtype:'uniCombobox',
            comboType: 'AU',
            comboCode: 'A395'
        },{
            xtype: 'uniCombobox',
            fieldLabel: '증빙종류',
            name:'EVDE_TYPE',   
            comboType:'AU',
            comboCode:'A238'
        },{
            xtype: 'uniCombobox',
            fieldLabel: '카드구분',
            name:'CARD_TYPE',   
            comboType:'AU',
            comboCode:'A237'
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:500,
//          id:'tdPayDtlNo',
            tdAttrs: {width:500/*align : 'center'*/},
            items :[{
                xtype:'uniTextfield',
                fieldLabel:'법인카드번호',
                name:'CRDT_NUM',
                width:325
            }/*,{
                fieldLabel: '',
                name: 'CRDT_DIVI',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'A010'
            }*/]      
        },{
            xtype: 'radiogroup',                      
            fieldLabel: '상태',
            id:'confirmYn',
            items: [{
                boxLabel: '확정',
                width: 50,
                name: 'CONFIRM_YN',
                inputValue: 'Y'
            },{
                boxLabel: '미확정',
                width: 70,
                name: 'CONFIRM_YN',
                inputValue: 'N',
                checked: true
            },{
                boxLabel: '보류', 
                width: 60,
                name: 'CONFIRM_YN',
                inputValue: 'C'
            }],
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    if(newValue.CONFIRM_YN == 'Y'){
                        panelResult.down('#cmsButton1').setDisabled(false);
                        panelResult.down('#cmsButton2').setDisabled(false);
                        panelResult.down('#autoSlipButton1').setDisabled(false);
                        panelResult.down('#autoSlipButton2').setDisabled(false);
                        panelResult.down('#requestButton').setDisabled(false);
                        panelResult.down('#abh200SaveButton').setDisabled(false);
                        
                        Ext.getCmp('signYn').setDisabled(false);
                    }else{
                        panelResult.down('#cmsButton1').setDisabled(true);
                        panelResult.down('#cmsButton2').setDisabled(true);
                        panelResult.down('#autoSlipButton1').setDisabled(true);
                        panelResult.down('#autoSlipButton2').setDisabled(true);
                        panelResult.down('#requestButton').setDisabled(true);
                        panelResult.down('#abh200SaveButton').setDisabled(true);
                        
                        Ext.getCmp('signYn').setDisabled(true);
                    }
                    
                    

                
                    UniAppManager.app.onQueryButtonDown();
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '결재상태',
            name:'DOC_STATUS',
            comboType:'AU',
            comboCode:'J682',
            multiSelect: true,
            typeAhead: false
        },
        Unilite.popup('DEPT', {
            fieldLabel: '부서', 
            valueFieldName: 'DEPT_CODE',
            textFieldName: 'DEPT_NAME'
        }),
        {
            xtype: 'radiogroup',                      
            fieldLabel: '기표여부',
            id:'signYn',
            colspan:3,
            items: [{
                boxLabel: '예',
                width: 50,
                name: 'SIGN_YN',
                inputValue: 'Y'
            },{
                boxLabel: '아니오',
                width: 70,
                name: 'SIGN_YN',
                inputValue: 'N',
                checked: true
            },{
                boxLabel: '전체', 
                width: 60,
                name: 'SIGN_YN',
                inputValue: ''
            }],
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                  
                    UniAppManager.app.onQueryButtonDown();
                }
            }
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 18
//          tdAttrs: {style: 'border : 1px solid #ced9e7;'}
            },
//          id:'branchSend',
            padding: '0 0 5 0',
//          width:1000,
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
                    html:'체크후 확정',
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
                width:150,
                tdAttrs: {align : 'center'},
                items :[{
                    xtype:'component',
                    html:'지급방법 외 설정 후 저장',
                    //id: '',
                    name: '',
                    width: 150,  
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
                itemId:'cmsRegard1',
                items :[{
                    xtype: 'button',
                    text: '예금주조회하기',    
                    itemId:'cmsButton1',
                    name: '',
                    width: 100, 
                    tdAttrs: {align : 'center'},
//                  hidden:true,
                    handler : function() {
                
                        if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                           alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
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
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:20,
                tdAttrs: {align : 'center'},
                itemId:'cmsRegard2',
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
                itemId:'cmsRegard3',
                items :[{
                    xtype: 'button',
                    text: '예금주결과받기',    
                    itemId:'cmsButton2',
                    name: '',
                    width: 100, 
                    tdAttrs: {align : 'center'},
//                  hidden:true,
                    handler : function() {
                
                        if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                           alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
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
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:20,
                tdAttrs: {align : 'center'},
                itemId:'cmsRegard4',
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
                tdAttrs: {align : 'center'},
                
                items :[{
                    xtype: 'button',
                    text: '자동기표',    
                    itemId:'autoSlipButton1',
                    name: '',
                    width: 90, 
                    tdAttrs: {align : 'center'},
//                  hidden:true,
                    handler : function() {
                
                        if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                           alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
                           var sm = detailGrid.getSelectionModel();
                           var selRecords = detailGrid.getSelectionModel().getSelection();
                           sm.deselect(selRecords);
                           return false;
                           
                        } else {
                        	if(Ext.isEmpty(subForm1.getValue('IN_EX_DATE'))) return;      //전표일자 관련
                        	
                        	var selectedRecords = detailGrid.getSelectedRecords();
                            if(selectedRecords.length > 0){
                                autoSlipButtonStore.clearData();
                                Ext.each(selectedRecords, function(record,i){
                                	if(Ext.isEmpty(record.get('SET_METH')) || Ext.isEmpty(record.get('ACCNT'))){
                                	   alert(record.get('ROW_NUMBER') + "번째 이체지급확정내역의\n지급방법 또는 계정과목 값을 확인하여주십시오.\n지급방법과 계정과목은 필수 사항입니다.");	
                                	   return false;
                                	}
                                    record.phantom = true;
                                    autoSlipButtonStore.insert(i, record);
                                });
                                autoSlipButtonFlag = 'BATCH';
                                autoSlipButtonStore.saveStore();
                                                        
                            }else{
                                Ext.Msg.alert('확인','자동기표 할 데이터를 선택해 주세요.'); 
                            }
                        	
                        	
                        	/*
                        	
                        	if(!subForm1.getInvalidMessage()) return;
                            var selectedRecords = detailGrid.getSelectedRecords();
                            if(selectedRecords.length > 0){
    //                            cmsButtonStore.clearData();
                            	var isErr = false;
                                Ext.each(selectedRecords, function(record,i){
                                	if(record.get('CONFIRM_YN') != "Y"){
                                	   alert('미확정 데이터는 작업할 수 없습니다.');
                                	   isErr = true;
                                	   return false;
                                	}
                                });
                                if(isErr) return false;
                                panelResult.setValue('AUTO_SLIP_FLAG', 'Y');
                                Ext.each(selectedRecords, function(record,i){
                                    record.phantom = true;
                                    autoSlipButtonStore.insert(i, record);
                                });
                                autoSlipButtonStore.saveStore();
                            }else{
                                Ext.Msg.alert('확인','자동기표 할 데이터를 선택해 주세요.'); 
                            }
                            
                            */
                            
                            
                            
                            
                        }
                    }
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:20,
                tdAttrs: {align : 'center'},
                itemId:'cmsIdCheck6',
                items :[{
                    xtype:'component',
                    html:'/',
                    tdAttrs: {align : 'center'},
                    componentCls : 'component-text_second',
                    width: 20
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                tdAttrs: {align : 'center'},
                
                items :[{
                    xtype: 'button',
                    text: '기표취소',    
                    itemId:'autoSlipButton2',
                    name: '',
                    width: 90, 
                    tdAttrs: {align : 'center'},
//                  hidden:true,
                    handler : function() {
                
                        if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                           alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
                           var sm = detailGrid.getSelectionModel();
                           var selRecords = detailGrid.getSelectionModel().getSelection();
                           sm.deselect(selRecords);
                           return false;
                           
                        } else {    
                        	var selectedRecords = detailGrid.getSelectedRecords();
                            if(selectedRecords.length > 0){
                            
                                autoSlipButtonStore.clearData();
                                Ext.each(selectedRecords, function(record,i){
                                    record.phantom = true;
                                    autoSlipButtonStore.insert(i, record);
                                });
                                autoSlipButtonFlag = 'CANCEL';
                                autoSlipButtonStore.saveStore();
                                                        
                            }else{
                                Ext.Msg.alert('확인','기표취소 할 데이터를 선택해 주세요.'); 
                            }
                        	
                        	
                        	
                           /* var selectedRecords = detailGrid.getSelectedRecords();
                            if(selectedRecords.length > 0){
    //                            cmsButtonStore.clearData();
                                var isErr = false;
                                Ext.each(selectedRecords, function(record,i){
                                    if(record.get('CONFIRM_YN') != "Y"){
                                       alert('미확정 데이터는 작업할 수 없습니다.');
                                       isErr = true;
                                       return false;
                                    }
                                });
                                if(isErr) return false;
                                panelResult.setValue('AUTO_SLIP_FLAG', 'C');
                                Ext.each(selectedRecords, function(record,i){
                                    record.phantom = true;
                                    autoSlipButtonStore.insert(i, record);
                                });
                                autoSlipButtonStore.saveStore();
                            }else{
                                Ext.Msg.alert('확인','자동기표 할 데이터를 선택해 주세요.'); 
                            }*/
                            
                            
                            
                            
                            
                        }
                    }
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:20,
                tdAttrs: {align : 'center'},
                itemId:'cmsIdCheck8',
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
                    text: '결재요청', 
                    itemId:'requestButton',
                    name: '',
                    width: 90,  
                    tdAttrs: {align : 'center'},
//                  hidden:true,
                    handler : function() {
                    	
                
                        if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                           alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
                           var sm = detailGrid.getSelectionModel();
                           var selRecords = detailGrid.getSelectionModel().getSelection();
                           sm.deselect(selRecords);
                           return false;
                           
                        } else {
                            var selectedRecords = detailGrid.getSelectedRecords();
                            
                            if(!Ext.isEmpty(selectedRecords)){
                                if(confirm('선택한 이체지급확정내역을 결재요청 처리하시겠습니까?')) { 
                                    var sm = detailGrid.getSelectionModel();
                                    var selRecords = detailGrid.getSelectionModel().getSelection();
                                    Ext.each(selectedRecords, function(record,i){
                                        if(record.get('CONFIRM_YN') != 'Y' || record.get('PAYMENT_STATUS_DETAIL') != '10' || Ext.isEmpty(record.get('EX_DATE'))){
                                            alert(record.get('ROW_NUMBER') + "번째 이체지급확정내역은\n확정이 아니거나 입력상태가 아니거나 기표처리가 되지 않았습니다.\n확정, 입력상태이면서 기표처리된 데이터만 결재요청이 가능합니다.");
            
                                            sm.deselect(selRecords[i]);
                                        }
                                    });
                                    
                                    var newSelectedRecords = detailGrid.getSelectedRecords();
                                    
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
                    }
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:20,
                tdAttrs: {align : 'center'},
//                itemId:'cmsIdCheck8',
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
                    text: '이체지급', 
                    itemId:'abh200SaveButton',
                    name: '',
                    width: 90,  
                    tdAttrs: {align : 'center'},
//                  hidden:true,
                    handler : function() {
                        if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                           alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
                           var sm = detailGrid.getSelectionModel();
                           var selRecords = detailGrid.getSelectionModel().getSelection();
                           sm.deselect(selRecords);
                           return false;
                           
                        } else {
                            var selectedRecords = detailGrid.getSelectedRecords();
                            
                            if(!Ext.isEmpty(selectedRecords)){
                                if(confirm('선택한 이체지급확정내역을 이체지급 처리하시겠습니까?')) { 
                                    var sm = detailGrid.getSelectionModel();
                                    var selRecords = detailGrid.getSelectionModel().getSelection();
                                    Ext.each(selectedRecords, function(record,i){
                                        if(record.get('CONFIRM_YN') != 'Y' || record.get('PAYMENT_STATUS') != '50' || record.get('TRANS_YN') != 'Y' ){  
                                            alert(record.get('ROW_NUMBER') + "번째 이체지급확정내역은\n확정상태가 아니거나 결재완료상태가 아니거나 전송대상이 아닙니다.\n확정이면서 결재완료이면서 전송대상만 이체지급이 가능합니다.");
            
                                            sm.deselect(selRecords[i]);
                                        }
                                    });
                                    
                                    var newSelectedRecords = detailGrid.getSelectedRecords();
                                    
                                    if(!Ext.isEmpty(newSelectedRecords)){
                                        abh200SaveButtonStore.clearData();
                                        Ext.each(newSelectedRecords, function(record,i){
                                        	if(newSelectedRecords[0].get('SET_METH') != record.get('SET_METH')){
                                        	   	
                                        		setMethMaster = '10';           // 이체지급 버튼 누를시 로우들에 서로 다른 SET_METH 값 있으면 10 set 하기 위해   
                                        	}
                                        	
                                        	
                                        	
                                        	if(newSelectedRecords[0].get('OUT_SAVE_CODE') == record.get('OUT_SAVE_CODE')){     //서로 다른 출금통장코드 가 select 되었을시 return false 시키기 위해 ... 
                                                record.phantom = true;
                                                abh200SaveButtonStore.insert(i, record);
                                        	}else{
                                        		alert("서로 다른 출금통장코드가 선택 되었습니다.\n출금통장코드를 확인해 주십시오.");
                                        	    return false;	
                                        	}
                                        });
                                        
                                        if(setMethMaster != '10'){
                                            setMethMaster = newSelectedRecords[0].get('SET_METH');    	
                                        }
                                        
                                        outSaveCodeMaster = newSelectedRecords[0].get('OUT_SAVE_CODE');
                                        
                                        exDate  = UniDate.getDbDateStr(newSelectedRecords[0].get('EX_DATE'));
                                        exNum  = newSelectedRecords[0].get('EX_NUM');
                                        abh200SaveButtonStore.saveStore(); 
                                        
                                    }else{
                                        Ext.Msg.alert('확인','이체지급 처리할 데이터를 선택해 주세요.');
                                    }
                                }else{
                                   return false;    
                                }
                            }else{
                                Ext.Msg.alert('확인','이체지급 처리할 데이터를 선택해 주세요.');
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
        }]
    });		
    
    var subForm1 = Unilite.createSearchForm('subForm1',{
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 0 1',
        border:true,
        items: [
        Unilite.popup('BANK_BOOK',{
            fieldLabel: '출금통장', 
            valueFieldWidth: 90,
            textFieldWidth: 140,
            valueFieldName:'OUT_SAVE_CODE',
            textFieldName:'BANK_BOOK_NAME',
            allowBlank: false,
//                  validateBlank:'text',
//            extParam: {
//                  'CHARGE_CODE': getChargeCode[0].SUB_CODE
//                  ,'ADD_QUERY': "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"
//            },  
            listeners: {
//                    onValueFieldChange: function(field, newValue){
//                    },
//                    onTextFieldChange: function(field, newValue){
//                    }
            	onSelected: {
                    fn: function(records, type) {
                    	subForm1.setValue('OUT_BANK_CODE',records[0]["BANK_CD"]);
//                        	var selectedRecords = detailGrid.getSelectedRecords();
//                            if(selectedRecords.length > 0){
//                                Ext.each(selectedRecords, function(record,i){                                	
//                                	record.set('OUT_SAVE_CODE', records[0]["BANK_BOOK_CODE"]);
//                                	record.set('OUT_BANK_CODE', records[0]["BANK_CD"]);
//                                });
//                                gsBankBookCode = records[0]["BANK_BOOK_CODE"];
//                                gsBankCode = records[0]["BANK_CD"];
//                            }
                    },
                    scope: this
                },
                onClear: function(type) {
                	subForm1.setValue('OUT_BANK_CODE','');
//                        var selectedRecords = detailGrid.getSelectedRecords();
//                        if(selectedRecords.length > 0){
//                            Ext.each(selectedRecords, function(record,i){
//                                record.set('OUT_SAVE_CODE', '');
//                                record.set('OUT_BANK_CODE', '');
//                            });
//                            gsBankBookCode = '';
//                            gsBankCode = '';
//                        }
                }
            }
        }),
        
        {
            xtype: 'uniTextfield',
            name:'OUT_BANK_CODE',
            hidden:true
        },{
            xtype: 'uniDatefield',
            fieldLabel: '전표일자',
            name: 'IN_EX_DATE',
            value: UniDate.get('today')
        },{
        	fieldLabel: '합계 : ',
            xtype:'uniNumberfield',
            name:'TOT_AMT',
            readOnly:true
        }]  
    });
    
    var detailGrid = Unilite.createGrid('abh220ukrGrid', {
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
		tbar: [{
            xtype: 'button',
            text: '확정',   
            id: 'btnConfirm',
            name: '',
            width: 80,  
//          disabled:true,
            handler : function() {
            	
            	if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
            	   alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
            	   var sm = detailGrid.getSelectionModel();
                   var selRecords = detailGrid.getSelectionModel().getSelection();
                   sm.deselect(selRecords);
            	   return false;
            	   
            	} else {
            		if(!subForm1.getInvalidMessage()) return;      //출금통장 관련
            		
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                        buttonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        buttonFlag = 'BC';
                        buttonStore.saveStore();
                        
    //                    alert(buttonFlag);
                    }else{
                        Ext.Msg.alert('확인','확정 할 데이터를 선택해 주세요.');   
                    }
                
            		/*
            		
            		
                    
                    var selectedRecords = detailGrid.getSelectedRecords();
                    var toCreate = detailGrid.getStore().getNewRecords();
                    if(selectedRecords.length > 0){
                    	if(!subForm1.getInvalidMessage()) return;
                        buttonStore.clearData();
                        var isErr = false;
                        Ext.each(selectedRecords, function(record,i){
                        	if(!Ext.isEmpty(record.get('EX_DATE'))){
                               isErr = true;
                               alert('자동기표가 완료된 건입니다.');
                               return false;
                            }
                            if(isErr) return false;
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        Ext.each(toCreate, function(record,i){
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        buttonFlag = 'BC';
                        buttonStore.saveStore();
                    }else{
                        Ext.Msg.alert('확인','확정 할 데이터를 선택해 주세요.');   
                    }*/
                }
            }
        },{
            xtype: 'button',
            text: '미확정',   
            id: 'btnConfirmCancel',
            name: '',
            width: 80,  
//          disabled:true,
            handler : function() {
                
                if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                   alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
                   var sm = detailGrid.getSelectionModel();
                   var selRecords = detailGrid.getSelectionModel().getSelection();
                   sm.deselect(selRecords);
                   return false;
                   
                } else {
                	var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                        buttonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        buttonFlag = 'BCC';
                        buttonStore.saveStore();
                        
    //                    alert(buttonFlag);
                    }else{
                        Ext.Msg.alert('확인','미확정 할 데이터를 선택해 주세요.');   
                    }
                	
                	
                 /*   var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                        buttonStore.clearData();
                        var isErr = false;
                        Ext.each(selectedRecords, function(record,i){
                        	if(!Ext.isEmpty(record.get('EX_DATE'))){
                        	   isErr = true;
                        	   alert('자동기표가 완료된 건입니다.');
                        	   return false;
                        	}
                        	if(isErr) return false;
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        buttonFlag = 'BCC';
                        buttonStore.saveStore();
                    }else{
                        Ext.Msg.alert('확인','미확정 할 데이터를 선택해 주세요.');   
                    }*/
                }
            }
        },'','',{
            xtype: 'button',
            text: '보류',   
            id: 'btnHold',
            name: '',
            width: 80,  
//          disabled:true,
            handler : function() {
            	
                
                if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                   alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
                   var sm = detailGrid.getSelectionModel();
                   var selRecords = detailGrid.getSelectionModel().getSelection();
                   sm.deselect(selRecords);
                   return false;
                   
                } else {
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                        buttonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        buttonFlag = 'BH';
                        buttonStore.saveStore();
                        
    //                    alert(buttonFlag);
                    }else{
                        Ext.Msg.alert('확인','보류 할 데이터를 선택해 주세요.');   
                    }
                }
            }
        },{
            xtype: 'button',
            text: '보류해제',   
            id: 'btnHoldCancel',
            name: '',
            width: 80,  
//          disabled:true,
            handler : function() {
                
                if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                   alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
                   var sm = detailGrid.getSelectionModel();
                   var selRecords = detailGrid.getSelectionModel().getSelection();
                   sm.deselect(selRecords);
                   return false;
                   
                } else {
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                        buttonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        buttonFlag = 'BHC';
                        buttonStore.saveStore();
                    }else{
                        Ext.Msg.alert('확인','보류해제 할 데이터를 선택해 주세요.');   
                    }
                }
            }
        },/*'','',{
            xtype: 'button',
            text: '결재요청',   
            id: 'btnRequest',
            name: '',
            width: 80,  
//          disabled:true,
            handler : function() {
                var selectedRecords = detailGrid.getSelectedRecords();
            	
                if(!Ext.isEmpty(selectedRecords)){
                	if(confirm('선택한 이체지급확정내역을 결재요청 처리하시겠습니까?')) { 
                		var sm = detailGrid.getSelectionModel();
                        var selRecords = detailGrid.getSelectionModel().getSelection();
                        Ext.each(selectedRecords, function(record,i){
                            if(record.get('CONFIRM_YN') != 'Y' || record.get('PAYMENT_STATUS_DETAIL') != '10'){
                                alert(record.get('ROW_NUMBER') + "번째 이체지급확정내역은 확정 상태가 아니거나 입력상태가 아닙니다.\n 확정 상태이면서 입력상태인 데이터만 결재요청이 가능합니다.");

                                sm.deselect(selRecords[i]);
                            }
                        });
                        
                        var newSelectedRecords = detailGrid.getSelectedRecords();
                        
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
        },*/'->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->',{
    		xtype: 'button',
    		text: '건별출력',	
	    	id: 'btnPrint',
    		name: '',
    		width: 80,	
    		hidden:true,
			handler : function() {
				if(directDetailStore.getCount() > 0){
				
		         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
		         var param= Ext.getCmp('resultForm').getValues();
		         
		         var prgId = '';
		         
		         
	//	         if(라디오 값에따라){
	//	         	prgId = 'abh220rkr';	
	//	         }else if{
	//	         	prgId = 'abh221rkr';
	//	         }
		         
		         
		         var win = Ext.create('widget.PDFPrintWindow', {
		            url: CPATH+'/abh/abh220rkrPrint.do',
	//	            prgID:prgId,
		            prgID: 'abh220rkr',
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
		               
		      
				
				}
			}
    	},{
    		xtype: 'button',
    		text: '지급처별 묶음출력',
    		id:'btnGroupPrint',
    		name: '',
    		width: 120,	
            hidden:true,
			handler : function() {
				
			}
    	}
		
		
		
		],
		store: directDetailStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var totAmountI = subForm1.getValue('TOT_AMT');
					
					subForm1.setValue('TOT_AMT',totAmountI + selectRecord.data.REAL_AMT_I);
					
					/*if(Ext.getCmp('confirmYn').getValue().CONFIRM_YN == 'Y'){
						subForm1.setValue('TOT_AMT',totAmountI + selectRecord.data.SEND_J_AMT_I);
						
					}else if(Ext.getCmp('confirmYn').getValue().CONFIRM_YN == 'N'){
						subForm1.setValue('TOT_AMT',totAmountI + selectRecord.data.REAL_AMT_I);
					}*/
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
                    var totAmountI = subForm1.getValue('TOT_AMT');
                    
                    subForm1.setValue('TOT_AMT',totAmountI - selectRecord.data.REAL_AMT_I);
                    
                    /*if(Ext.getCmp('confirmYn').getValue().CONFIRM_YN == 'Y'){
                        subForm1.setValue('TOT_AMT',totAmountI - selectRecord.data.SEND_J_AMT_I);
                        
                    }else if(Ext.getCmp('confirmYn').getValue().CONFIRM_YN == 'N'){
                        subForm1.setValue('TOT_AMT',totAmountI - selectRecord.data.REAL_AMT_I);
                    }*/
                    
				}
			}
        }),
		columns: [
//			{ dataIndex: 'CHECK_VALUE'			,width:60,hidden:true},
		
        	{ dataIndex: 'ROW_NUMBER'			,width:50, align:'center',locked:true},
        	{ dataIndex: 'CONFIRM_YN'			,width:60, align:'center',locked:true},
//        	{ dataIndex: 'CONFIRM_YN_DUMMY'			,width:100},
        	{ dataIndex: 'PAYMENT_STATUS'			,width:80, align:'center',locked:true},
        	
        	{ dataIndex: 'PAYMENT_STATUS_DETAIL'	,width:100, hidden:true},
        	
            
            {dataIndex:'OUT_SAVE_CODE'                  , width: 90,locked:true,
                editor: Unilite.popup('BANK_BOOK_G', {      
                    DBtextFieldName: 'BANK_BOOK_NAME',
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
            {dataIndex: 'OUT_BANK_CODE'             ,width: 100, locked:true,
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
            
        	{ dataIndex: 'PRE_DATE'					,width:88, locked:true,hidden:false},
//        	{ dataIndex: 'PAY_CUSTOM_CODE'		,width:100,locked:true},
//        	{ dataIndex: 'PAY_CUSTOM_NAME'		,width:150,locked:true},
        	{dataIndex: 'PAY_CUSTOM_CODE'   , width: 80,locked:true,
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
            {dataIndex: 'PAY_CUSTOM_NAME'   , width: 150, locked:true,
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
//    		{ dataIndex: 'DIV_CODE'		,width:100, hidden:true},
//        	{ dataIndex: 'PEND_CODE'		,width:100, hidden:true},
        	
        	{ dataIndex: 'SET_METH'				,width:88, align:'center'},
        	{ dataIndex: 'TRANS_YN'              ,width:80, align:'center'},
        	{ dataIndex: 'REMARK'				,width:200},
//        	{ dataIndex: 'MONEY_UNIT'			,width:80, align:'center', hidden:true},
  
//        	{ dataIndex: 'ORG_AMT_I'              ,width:100, hidden:true},
//        	{ dataIndex: 'J_AMT_I'                   ,width:100, hidden:true},
        	{ dataIndex: 'JAN_AMT_I'                 ,width:100},
        	
            { dataIndex: 'SEND_J_AMT_I'              ,width:100},
//            { dataIndex: 'SEND_J_AMT_I_DUMMY'       ,width:100, hidden:true},
        	{ dataIndex: 'IN_TAX_I'                  ,width:100},
        	{ dataIndex: 'LOCAL_TAX_I'               ,width:100},
        	{ dataIndex: 'REAL_AMT_I'                 ,width:100},
        	
        	{ dataIndex: 'ORG_AC_DATE'				,width:80,align:'center'},
//        	{ dataIndex: 'ORG_SLIP_NUM'				,width:60, format:'0', hidden:true},
//        	
//        	{ dataIndex: 'ORG_SLIP_SEQ'				,width:60, format:'0', hidden:true},
//        	{ dataIndex: 'SEQ'						,width:60,hidden:true},
//        	{ dataIndex: 'CONF_SEND_NUM'			,width:100,hidden:true},        	
            {dataIndex:  'ACCNT'                    ,width: 80 
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
              {dataIndex: 'ACCNT_NAME'          ,       width: 150 
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
//            {dataIndex:'CRDT_NUM'                   , width: 150,hidden:true},
            {dataIndex:'CRDT_NUM_EXPOS'             , width: 150},
            {dataIndex:'CARD_TYPE'                  , width: 80},
            {dataIndex:'IN_SAVE_CODE'                  , width: 100,
                editor: Unilite.popup('BANK_BOOK_G', {      
                    DBtextFieldName: 'BANK_BOOK_NAME',
                    listeners: {'onSelected': {
                            fn: function(records, type) {                                                       
                                Ext.each(records, function(record,i) {                                                                          
                                    if(i==0) {
                                        var grdRecord = detailGrid.uniOpt.currentRecord;
                                        grdRecord.set('IN_SAVE_CODE',record['BANK_BOOK_CODE'] );
                                        grdRecord.set('IN_SAVE_NAME',record['BANK_BOOK_NAME'] );
                                        grdRecord.set('BANK_CODE',record['BANK_CD'] );//은행코드
                                        grdRecord.set('BANK_NAME',record['BANK_NM'] );//은행명
                                        grdRecord.set('BANK_ACCOUNT',record['DEPOSIT_NUM'] ); //계좌번호 
                                        grdRecord.set('BANK_ACCOUNT_EXPOS', '*************' );//계좌번호 
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('IN_SAVE_CODE','');
                            grdRecord.set('IN_SAVE_NAME','');
                            grdRecord.set('BANK_CODE','' );//은행코드
                            grdRecord.set('BANK_NAME','' );//은행명
                        	grdRecord.set('BANK_ACCOUNT', '' );//계좌번호   
                        	grdRecord.set('BANK_ACCOUNT_EXPOS', '' );//은행명  
                        }
                    }
            })},    
            {dataIndex:'IN_SAVE_NAME'                  , width: 140,
                editor: Unilite.popup('BANK_BOOK_G', {      
                    DBtextFieldName: 'BANK_BOOK_NAME',
                    listeners: {'onSelected': {
                            fn: function(records, type) {                                                       
                                Ext.each(records, function(record,i) {                                                                          
                                    if(i==0) {
                                        var grdRecord = detailGrid.uniOpt.currentRecord;
                                        grdRecord.set('IN_SAVE_CODE',record['BANK_BOOK_CODE'] );
                                        grdRecord.set('IN_SAVE_NAME',record['BANK_BOOK_NAME'] );
                                        grdRecord.set('BANK_CODE',record['BANK_CD'] );//은행코드
                                        grdRecord.set('BANK_NAME',record['BANK_NM'] );//은행명
                                        grdRecord.set('BANK_ACCOUNT',record['DEPOSIT_NUM'] ); //계좌번호 
                                        grdRecord.set('BANK_ACCOUNT_EXPOS', '*************' );//계좌번호   
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('IN_SAVE_CODE','');
                            grdRecord.set('IN_SAVE_NAME','');
                            grdRecord.set('BANK_CODE','' );//은행코드
                            grdRecord.set('BANK_NAME','' );//은행명
                        	grdRecord.set('BANK_ACCOUNT', '' );//계좌번호   
                        	grdRecord.set('BANK_ACCOUNT_EXPOS', '' );//계좌번호   
                        }
                    }
            })},            
            {dataIndex: 'BANK_CODE'             ,width: 100,
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
          {dataIndex: 'BANK_NAME'           ,       width: 120,
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
//        	{ dataIndex: 'BANK_ACCOUNT'			,width:100, hidden: true},
        	
        	{ dataIndex: 'BANK_ACCOUNT_EXPOS'	 ,width:150},
        	{ dataIndex: 'BANKBOOK_NAME'		 ,width:120},
        	
        	{ dataIndex: 'IN_REMARK'             ,width:120},
        	
        	{ dataIndex: 'RCPT_ID'               ,width:100},
        	{ dataIndex: 'RCPT_NAME'             ,width:100},
        	{ dataIndex: 'CMS_TRANS_YN'          ,width:100},
        	{ dataIndex: 'RCPT_RESULT_MSG'       ,width:100},
        	{ dataIndex: 'RCPT_STATE_NUM'        ,width:100},
        	
//        	{ dataIndex: 'MODY_YN'             ,width:100, hidden:true},
        	
        	{ dataIndex: 'NOTE_NUM'             ,width:120,
            	editor: Unilite.popup('NOTE_NUM_G', {
                    autoPopup: true,
                    textFieldName:'NOTE_NUM_NAME',
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            grdRecord = detailGrid.uniOpt.currentRecord;
                            record = records[0];                                    
                            grdRecord.set('NOTE_NUM', record['NOTE_NUM_CODE']);
                            grdRecord.set('BANK_CODE', record['BANK_CODE']);
                            grdRecord.set('BANK_NAME', record['BANK_NAME']);
                            grdRecord.set('PUB_DATE', UniDate.get('today'));
                        },
                        onClear:function(type)  {
                            grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('NOTE_NUM', '');
                            grdRecord.set('BANK_CODE', '');
                            grdRecord.set('BANK_NAME', '');
                            grdRecord.set('PUB_DATE', '');
                        }
                    }
                })
        	
        	
        	},
        	{ dataIndex: 'PUB_DATE'             ,width:100},
        	{ dataIndex: 'EXP_DATE'				,width:100, align:'center'},
//        	{ dataIndex: 'EXP_DATE'             ,width:120},
            
        	
            { dataIndex: 'EX_DATE'             ,width:100},
            { dataIndex: 'EX_NUM'              ,width:100}//,
            
//            { dataIndex: 'DED_TYPE'            ,width:100,hidden:true},
//            { dataIndex: 'EVDE_TYPE'            ,width:100,hidden:true},
//            { dataIndex: 'DEPT_CODE'            ,width:100,hidden:true},
//            { dataIndex: 'DEPT_NAME'            ,width:100,hidden:true}
        	
        ],
        listeners: {
        	beforecelldblclick : function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
        		var columnName = view.eventPosition.column.dataIndex;
        		//alert(record.get('CONFIRM_YN'));
        		if(columnName == 'BANK_ACCOUNT_EXPOS'){
        			if(record.get('PAYMENT_STATUS') == '10'){
        				if(record.get('CONFIRM_YN') == 'Y'){
        					if(record.get('MODY_YN') == 'Y'){
        					   	mainGridReceiveRecord = record;                        
                                openSubGridWindow();
        					}else{
        						detailGrid.openCryptAcntNumPopup(record);
        					}
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
        			}else{
        				detailGrid.openCryptAcntNumPopup(record);
        			}
        		}else if(columnName == 'CRDT_NUM_EXPOS'){
        			detailGrid.openCryptCrdtNumPopup(record);
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
					if(UniUtils.indexOf(e.field, ['IN_REMARK'])){
                        return false;                      
                    }else{
					    return true;
                    }
				}else{
    				if(e.record.data.PAYMENT_STATUS == '10'){
        				if(e.record.data.CONFIRM_YN == 'Y'){
        					if(UniUtils.indexOf(e.field, ['PRE_DATE','SET_METH','SEND_J_AMT_I','TRANS_YN','IN_REMARK','PUB_DATE','EXP_DATE','NOTE_NUM'])){
        						return true;
        					}else if(UniUtils.indexOf(e.field, ['BANK_CODE','BANK_NAME','BANK_ACCOUNT','BANKBOOK_NAME'])){
        						if(e.record.data.MODY_YN == 'Y'){
                                    return true;
                                }else{
                                    return false;
                                }
        					}else{
        						return false;	
        					}
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
				
		},
		openCryptCrdtNumPopup:function( record )  {
            if(record)  {
                var params = {'CRDT_FULL_NUM': record.get('CRDT_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'N'}
                Unilite.popupCipherComm('grid', record, 'CRDT_NUM_EXPOS', 'CRDT_NUM', params);
            }
                
        }
    });   
    var subGrid = Unilite.createGrid('abh220ukrSubGrid', {    	
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
					var record = masterGrid.getSelectedRecord();
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
	        		var record = masterGrid.getSelectedRecord();
		        	if(record) {
		        		openDetailWindow(record);
		        	}
	        	}
            }
        ],*/
        columns:  [ 
        	{ dataIndex: 'CUSTOM_CODE'	 		 	,  		width: 120, hidden:true},
        	{ dataIndex: 'BOOK_CODE'            ,       width: 120},
            { dataIndex: 'BOOK_NAME'            ,       width: 100},
            
			{ dataIndex: 'BANK_CODE'	 		 	,  		width: 120,
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
			{ dataIndex: 'BANK_NAME'	 		 	,  		width: 130,
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
			{ dataIndex: 'BANK_ACCOUNT'		 		,  		width: 150, hidden: true},
        	{ dataIndex: 'BANK_ACCOUNT_EXPOS'    	,		width: 120 },			
			{ dataIndex: 'BANKBOOK_NAME'	 		,  		width: 100},
            { dataIndex: 'MAIN_BOOK_YN'       ,       width: 100}
			
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
							subGrid.returnData();
							subGridWindow.hide();
							subGrid.reset();
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
                       subForm1, detailGrid
                   ]
                }
			]	
		},
			panelSearch
		],
		id  : 'abh220ukrApp',
		fnInitBinding: function(){
			
			this.setDefault();
			
			Ext.getCmp('signYn').setDisabled(true);
			
		},
		onQueryButtonDown: function() {      
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			
			subForm1.setValue('TOT_AMT',0);
			directDetailStore.loadStoreRecords();		
		},
		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
		    if(!subForm1.getInvalidMessage()) return;      //출금통장 관련
//			 var compCode = UserInfo.compCode;
            var records = directDetailStore.data.items;
//            var maxOrgSlipNum = '1';
//            var compareArray= new Array();
//            
//            //번호 채번.. 그리드 레코드들중 max값 + 1
//            Ext.each(records, function(record, index){
//                if(record.get('SEQ') == '99999'){
//                    compareArray.push(record);
//                }
//            });
//            Ext.each(compareArray, function(record, index){
//            	if(index == 0){
//            	   maxOrgSlipNum =  record.get('ORG_SLIP_NUM') + 1;
//            	}
//            	if(index != 0 && compareArray[index - 1].get('ORG_SLIP_NUM') <= record.get('ORG_SLIP_NUM')){
//                    maxOrgSlipNum =  record.get('ORG_SLIP_NUM') + 1;
//                }
//            });
            
            var outBankCode = subForm1.getValue('OUT_BANK_CODE');
            var outSaveCode = subForm1.getValue('OUT_SAVE_CODE');
            var divCode     = UserInfo.divCode;
            
            
            abh220ukrService.getAccntCode({},function(provider,response){
                if(!Ext.isEmpty(provider)){
                
                
                    var accntCode   = provider.ACCNT_CODE; 
                    var accntName   = provider.ACCNT_NAME;  
                	var r = {
                        CONFIRM_YN: 'N',
                        PAYMENT_STATUS: '10',
        //                ORG_SLIP_NUM: maxOrgSlipNum,
        //                ORG_SLIP_SEQ: '99999',
        //                SEQ: '1',
                        MONEY_UNIT: UserInfo.currency,
                        ORG_AC_DATE: UniDate.get('today'),
                        BANK_ACCOUNT_EXPOS: '',
                        DIV_CODE : divCode,
                        OUT_BANK_CODE : outBankCode,
                        OUT_SAVE_CODE : outSaveCode,
                        SET_METH : '10',
                        TRANS_YN : 'Y',
                        
                        ACCNT    : accntCode,
                        ACCNT_NAME : accntName
        	        };
        			detailGrid.createRow(r);
        			
        			var sm = detailGrid.getSelectionModel();
                    var selRecords = detailGrid.getSelectionModel().getSelection();
                    sm.deselect(selRecords);
                }else{
                	var accntCode   = '';  
                	var accntName   = '';  
                    var r = {
                        CONFIRM_YN: 'N',
                        PAYMENT_STATUS: '10',
        //                ORG_SLIP_NUM: maxOrgSlipNum,
        //                ORG_SLIP_SEQ: '99999',
        //                SEQ: '1',
                        MONEY_UNIT: UserInfo.currency,
                        ORG_AC_DATE: UniDate.get('today'),
                        BANK_ACCOUNT_EXPOS: '',
                        DIV_CODE : divCode,
                        OUT_BANK_CODE : outBankCode,
                        OUT_SAVE_CODE : outSaveCode,
                        SET_METH : '10',
                        TRANS_YN : 'Y',
                        
                        ACCNT    : accntCode,
                        ACCNT_NAME : accntName
                    };
                    detailGrid.createRow(r);
                    
                    var sm = detailGrid.getSelectionModel();
                    var selRecords = detailGrid.getSelectionModel().getSelection();
                    sm.deselect(selRecords);
                }
            })
		},
		onResetButtonDown: function() {
//			panelSearch.clearForm();
//			panelResult.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			UniAppManager.setToolbarButtons('save', false);
			this.setDefault();
		},
		
		onSaveDataButtonDown: function(config) {	
			
            var records = directDetailStore.data.items;
			var checkValue = 0;
			Ext.each(records, function(record, i){
                if(record.phantom == true) {
                    if(record.get('SEND_J_AMT_I') == 0){
                        checkValue += 1; 
                    }
                }
			});
			
			if(checkValue > 0){
                alert("신규로 추가하신 데이터에 지급확정금액 값을 입력해 주십시오.");
                return false;
			}else{
				directDetailStore.saveStore();
			}
		},
		
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecords();
			if(!Ext.isEmpty(selRow)){
			
				var checkValue = 0;
				Ext.each(selRow, function(record, i){
				    if(record.phantom === false) {
                        checkValue += 1; 				    	
				    }
				})
				
				if(checkValue > 0){
        			alert("신규로 추가된 데이터 중 저장하기전 데이터 만 삭제가 가능합니다.");
        			var sm = detailGrid.getSelectionModel();
                    var selRecords = detailGrid.getSelectionModel().getSelection();
                    sm.deselect(selRecords);
				}else{
//				    if(selRow.phantom === true) {
                    detailGrid.deleteSelectedRow();
                        
                    var sm = detailGrid.getSelectionModel();
                    var selRecords = detailGrid.getSelectionModel().getSelection();
                    sm.deselect(selRecords);
//                    }else{
//                        alert("신규로 추가된 데이터 중 저장하기전 데이터 만 삭제가 가능합니다.");
//                    }	
				}
    			
    			
			}else{
				alert("신규로 추가된 데이터 중 저장하기전 데이터 만 삭제가 가능합니다.");
				var sm = detailGrid.getSelectionModel();
                var selRecords = detailGrid.getSelectionModel().getSelection();
                sm.deselect(selRecords);
			}
		},
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
        setDefault: function(){
        	UniAppManager.setToolbarButtons(['newData','reset'], true);
        	var tbar = detailGrid._getToolBar();
            tbar[0].insert(tbar.length + 1, decrypBtn);
         
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('ORG_AC_DATE_FR');
        	
            if(!Ext.isEmpty(BsaCodeInfo.getCmsId)){
				panelResult.down('#cmsRegard1').setHidden(false);
				panelResult.down('#cmsRegard2').setHidden(false);
				panelResult.down('#cmsRegard3').setHidden(false);
				panelResult.down('#cmsRegard4').setHidden(false);
            }else{
				panelResult.down('#cmsRegard1').setHidden(true);
                panelResult.down('#cmsRegard2').setHidden(true);
                panelResult.down('#cmsRegard3').setHidden(true);
                panelResult.down('#cmsRegard4').setHidden(true);
			}
			
			subForm1.setValue('TOT_AMT',0);
			
			if(Ext.getCmp('confirmYn').getValue().CONFIRM_YN == 'Y'){
				panelResult.down('#cmsButton1').setDisabled(false);
                panelResult.down('#cmsButton2').setDisabled(false);
                panelResult.down('#autoSlipButton1').setDisabled(false);
                panelResult.down('#autoSlipButton2').setDisabled(false);
                panelResult.down('#requestButton').setDisabled(false);
                panelResult.down('#abh200SaveButton').setDisabled(false);
			}else{
    			panelResult.down('#cmsButton1').setDisabled(true);
                panelResult.down('#cmsButton2').setDisabled(true);
                panelResult.down('#autoSlipButton1').setDisabled(true);
                panelResult.down('#autoSlipButton2').setDisabled(true);
                panelResult.down('#requestButton').setDisabled(true);
                panelResult.down('#abh200SaveButton').setDisabled(true);
			}
			
//            Ext.getCmp('signYn').setDisabled(true);
			
		}
/*		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('resultForm').getValues();
	         
	         var prgId = '';
	         
	         
//	         if(라디오 값에따라){
//	         	prgId = 'abh220rkr';	
//	         }else if{
//	         	prgId = 'abh221rkr';
//	         }
	         
	         
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/abh/abh220rkrPrint.do',
//	            prgID:prgId,
	            prgID: 'abh220rkr',
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
                case "SEND_J_AMT_I" : 
                    record.set('REAL_AMT_I', newValue - record.get('LOCAL_TAX_I') - record.get('IN_TAX_I'));
                break;
                
                case "SET_METH" :
                    if(record.get('ORG_SLIP_SEQ') == '99999'){
                        if(newValue == '16' || newValue == '25'){
                            record.set('TRANS_YN','Y');
                        }
                    }else{
                        if(newValue == '16' || newValue == '25'){
                            record.set('TRANS_YN','N');
                        }
                    }
                    if(newValue == '10'){
                        record.set('TRANS_YN','Y');	
                    }else if(newValue == '13'){
                    	record.set('TRANS_YN','N');   
                    }else if(newValue == '30'){
                        record.set('TRANS_YN','Y'); 
                        record.set('BANK_CODE','');
                        record.set('BANK_NAME','');
                        record.set('BANK_ACCOUNT','');
                        record.set('BANKBOOK_NAME','');
                    }
                    
                break;
    		}
            return rv;
		}
	});	
};

</script>