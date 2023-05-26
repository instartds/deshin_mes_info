<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="abh230ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> 		<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="J682" /> 		<!-- 결재상태(내부결재) -->
	<t:ExtComboStore comboType="AU" comboCode="A395" /> 		<!-- 지급방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B131" />			<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="A010" /> 		<!-- 법인/개인구분 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	
<script type="text/javascript" >


function appMain() {
	var excelWindow; 				//업로드 윈도우 생성
	var cmsButtonFlag		= '';  	//예금주 조회하기, 예금주결과 받기
	var BsaCodeInfo			= { 
		getCmsId: '${getCmsId}'
	}
	/* 해당 사항 없음
	var setMethMaster 		= '';   // 이체지급 버튼 누를시 로우들에 서로 다른 SET_METH 값 있으면 10 set 하기 위해
	var outSaveCodeMaster 	= '';   // 이체지급 버튼 누를시 출금통장코드 저장관련 (subForm에서 직접 값 가져감)
	var exDate 				= '';	// 이체지급 버튼 누를시 EX_DATE ABH200T 저장관련 (이 프로그램 해당 없음)
	var exNum  				= '';	// 이체지급 버튼 누를시 EX_NUM  ABH200T 저장관련 (이 프로그램 해당 없음) 
	*/
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'abh230ukrService.selectList',
			update	: 'abh230ukrService.updateList',
			create	: 'abh230ukrService.insertList',
			destroy	: 'abh230ukrService.deleteList',
			syncAll	: 'abh230ukrService.saveAll'
		}
	});	
	
	//예금주 조회하기, 예금주결과 받기
	var directProxyCmsButton = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'abh230ukrService.insertLogDetailsCms',
			syncAll	: 'abh230ukrService.saveAllCmsButton'
		}
	}); 

	// 이체지급 버튼 관련
	var directProxyAbh200SaveButton = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'abh230ukrService.insertDetailAbh200SaveButton',
			syncAll	: 'abh230ukrService.saveAllAbh200SaveButton'
		}
	}); 
    var directProxyRequest = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'abh230ukrService.insertDetailRequest',
            syncAll: 'abh230ukrService.saveAllRequest'
        }
    }); 
	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('abh230ukrModel', {
		fields: [
		    {name: 'ROW_NUMBER'         ,text: 'NO'             ,type: 'string', editable: false},
			{name: 'DOC_ID'				,text: '자동증가'			,type: 'string'	, editable: false},
			{name: 'COMP_CODE'			,text: '법인'				,type: 'string'	, editable: false},
			{name: 'SEQ'				,text: '순번'				,type: 'string'	, editable: false},
			{name: 'ORG_AC_DATE'		,text: '원전표일자'			,type: 'uniDate' },
			{name: 'ORG_SLIP_NUM'		,text: '원전표번호'			,type: 'string'  },
			{name: 'ORG_SLIP_SEQ'		,text: '원전표순번'			,type: 'int'	 },
			{name: 'PAY_EXP_DATE'		,text: '지급예정일'			,type: 'uniDate' },
			{name: 'SEND_DATE'			,text: '이체일자'			,type: 'uniDate' },
			{name: 'OUT_SAVE_CODE'		,text: '출금통장코드'		,type: 'string'	, editable: false},
			{name: 'BANK_CODE'			,text: '은행코드'			,type: 'string'  },
			{name: 'BANK_NAME'			,text: '은행명'			,type: 'string'  },
			{name: 'ACCOUNT_NUM'		,text: '계좌번호'			,type: 'string'  },
			{name: 'ACCOUNT_NUM_EXPOS'	,text: '계좌번호'			,type: 'string'	, type: 'string', defaultValue:'***************'},
			{name: 'BANKBOOK_NAME'		,text: '예금주명'			,type: 'string'  },
			{name: 'SEND_NUM'			,text: '이체번호'			,type: 'string'	, editable: false},			//보낼 때 통으로 채번 셋팅
			{name: 'AMT_I'				,text: '금액'				,type: 'uniPrice'},
			{name: 'IN_REMARK'			,text: '입금통장표시내용'	,type: 'string'  },
			//CMS 연계 예금주조회 관련 필드
			{name: 'RCPT_ID'			,text: '예금주전송ID'		,type: 'string'	, editable: false},
			{name: 'RCPT_NAME'			,text: '예금주명결과'		,type: 'string'	, editable: false},
			{name: 'CMS_TRANS_YN'       ,text: '예금주전송'        ,type: 'string' , editable: false},         //전송하면 'Y'
			{name: 'RCPT_RESULT_MSG'	,text: '예금주조회결과'		,type: 'string'	, editable: false},
			{name: 'RCPT_STATE_NUM'     ,text: '예금주전송전문번호'	,type: 'string' , editable: false},
			
			{name: 'INSERT_DB_USER'		,text: '입력자'			,type: 'string'	, editable: false},
			{name: 'INSERT_DB_TIME'		,text: '입력일'			,type: 'string'	, editable: false},
			{name: 'UPDATE_DB_USER'		,text: '수정자'			,type: 'string'	, editable: false},
			{name: 'UPDATE_DB_TIME'		,text: '수정일'			,type: 'string'	, editable: false},
			{name: 'ACCNT'				,text: '계정코드'			,type: 'string'	, editable: false},
            {name: 'DOC_STATUS'         ,text: '결재진행상태'       ,type: 'string' , editable: false,comboType:'AU', comboCode:'J682'}
		]
	});
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('abh230ukrDetailStore', {
		proxy	: directProxy,
		model	: 'abh230ukrModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			allDeletable: false,
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,

		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		
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
//						masterStore.loadStoreRecords();
						
						if (masterStore.count() == 0) {   
							UniAppManager.app.onResetButtonDown();
							
						}else{
							UniAppManager.app.onQueryButtonDown();
						}
					 } 
				};
				this.syncAllDirect(config);
				
			} else {
				var grid = Ext.getCmp('abh230ukrGrid');
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
	
	//예금주 조회하기, 예금주결과 받기
	var cmsButtonStore = Unilite.createStore('Abh230ukrCmsbuttonStore',{	
		proxy		: directProxyCmsButton, 
		uniOpt		: {
			isMaster	: false,			// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi		: false				// prev | newxt 버튼 사용
		},
		saveStore	: function() {			 
			var inValidRecs = this.getInvalidRecords();
			var paramMaster = panelResult.getValues();
			paramMaster.CMS_BUTTON_FLAG = cmsButtonFlag;
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
	
	//이체지급
	var abh200SaveButtonStore = Unilite.createStore('Abh230ukrAbh200SaveButtonStore',{	  
		uniOpt		: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy		: directProxyAbh200SaveButton,
		saveStore	: function() {			 
			var paramMaster			= panelResult.getValues(); 
			paramMaster.PAY_METH	= '10';
			paramMaster.PAY_CODE	= subForm.getValue('OUT_SAVE_CODE');
			paramMaster.DIV_CODE	= UserInfo.divCode;

			config = {
				params: [paramMaster],
				success: function(batch, option) {
					var master = batch.operations[0].getResultSet();
					var sendNum= master.KEY_NUMBER
					
					var params = {
						'PGM_ID'	: 'abh230ukr',
						'SEND_NUM'	: sendNum
					}
					var rec1 = {data : {prgID : 'abh201ukr', 'text':''}};						   
					parent.openTab(rec1, '/accnt/abh201ukr.do', params);
				},
				failure: function(batch, option) {
				}
			};
			this.syncAllDirect(config);
		}
	});
	var requestStore = Unilite.createStore('Abh230ukrRequestStore',{      
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
	
	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
//			collapse: function () {
//				panelResult.show();
//			},
//			expand: function() {
//				panelResult.hide();
//			}
		},
		items		: [{	
			title		: '기본정보', 	
	   		itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{ 
				fieldLabel		: '지급예정일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PAY_EXP_DATE_FR',
				endFieldName	: 'PAY_EXP_DATE_TO',
				startDate		: UniDate.get('today'),
				endDate			: UniDate.get('today'),
				allowBlank: false,				  
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PAY_EXP_DATE_FR', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PAY_EXP_DATE_TO', newValue);						   
					}
				}
			},{ 
				fieldLabel		: '이체기간',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'TRANSFER_PERIOD_FR',
				endFieldName	: 'TRANSFER_PERIOD_TO',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TRANSFER_PERIOD_FR', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TRANSFER_PERIOD_TO', newValue);						  
					}
				}
			},{
				xtype		: 'container',
				layout		: {type : 'uniTable', columns : 3},
				width		: 400,
				items		: [{
					fieldLabel	: '순번', 
					name		: 'SEQ_FR', 
					xtype		: 'uniTextfield',
					width		: 195,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('SEQ_FR', newValue);
						},
						blur: function(field, The, eOpts)	{
							var newValue = field.getValue().replace(/-/g,'');
							if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
						 		alert(Msg.sMB074);
						 		this.setValue('');
						 		return ;
						 	}
							if (!Ext.isEmpty(panelSearch.getValue('SEQ_TO'))) {
								var maxSeq = parseInt(panelSearch.getValue('SEQ_TO'));
								if (parseInt(newValue) > maxSeq) {
									alert('뒤의 순번 보다 작은 수를 입력하세요');
						 			this.setValue('');
									return false;
								}
							}
						}
					}
				},{
					xtype	: 'component', 
					html	: '~',
					style	: {
						marginTop	: '3px !important',
						font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel	: '', 
					name		: 'SEQ_TO', 
					xtype		: 'uniTextfield',
					width		: 110,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('SEQ_TO', newValue);
						},
						blur: function(field, The, eOpts)	{
							var newValue = field.getValue().replace(/-/g,'');
							if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
						 		alert(Msg.sMB074);
						 		this.setValue('');
						 		return ;
						 	}
							if (!Ext.isEmpty(panelSearch.getValue('SEQ_FR'))) {
								var minSeq = panelSearch.getValue('SEQ_FR')
								if (newValue < minSeq) {
									alert('앞의 순번 보다 큰 수를 입력하세요');
						 			this.setValue('');
									return false;
								}
							}
						}
					}
				}]
			},{
				xtype		: 'radiogroup',							
				fieldLabel	: '예금주조회',
				id			: 'searchDepositor_S',
				items		: [{
					boxLabel	: '전체', 
					width		: 60,
					name		: 'SEARCH_DEPOSITOR',
					inputValue	: 'A' 
				},{
					boxLabel	: '미전송', 
					width		: 70,
					name		: 'SEARCH_DEPOSITOR',
					inputValue	: 'N',
					checked		: true   
				},{
					boxLabel	: '전송', 
					width		: 70,
					name		: 'SEARCH_DEPOSITOR',
					inputValue	: 'Y'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						panelResult.getField('SEARCH_DEPOSITOR').setValue(newValue.SEARCH_DEPOSITOR);
//						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]	
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		hidden		: !UserInfo.appOption.collapseLeftSearch,
		layout		: {type : 'uniTable', columns : 2,
		tableAttrs	: { /*style: 'border : 1px solid #ced9e7;',width: '80%'*/}
//			, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*width: '100%'/*,align : 'left'*/}
		},
		padding		: '1 1 1 1',
		border		: true,
		items		: [{ 
			fieldLabel		: '지급예정일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PAY_EXP_DATE_FR',
			endFieldName	: 'PAY_EXP_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			allowBlank		: false,			
			tdAttrs			: {width: 400},  
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PAY_EXP_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PAY_EXP_DATE_TO', newValue);						   
				}
			}
		},{
			xtype		: 'radiogroup',							
			fieldLabel	: '예금주조회',
			id			: 'searchDepositor_R',
			items		: [{
				boxLabel	: '전체', 
				name		: 'SEARCH_DEPOSITOR',
				width		: 60,
				inputValue	: 'A' 
			},{
				boxLabel	: '미전송', 
				name		: 'SEARCH_DEPOSITOR',
				width		: 70,
				inputValue	: 'N',
				checked		: true   
			},{
				boxLabel	: '전송', 
				name		: 'SEARCH_DEPOSITOR',
				width		: 70,
				inputValue	: 'Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {	
					panelSearch.getField('SEARCH_DEPOSITOR').setValue(newValue.SEARCH_DEPOSITOR);
				}
			}
		},{ 
			fieldLabel		: '이체기간',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'TRANSFER_PERIOD_FR',
			endFieldName	: 'TRANSFER_PERIOD_TO',			
			tdAttrs			: {width: 400},  
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TRANSFER_PERIOD_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TRANSFER_PERIOD_TO', newValue);						  
				}
			}
		},{
			xtype		: 'container',
			layout		: {type : 'uniTable', columns : 3},
			width		: 400,
			colspan		: 2,
			items		: [{
				fieldLabel	: '순번', 
				name		: 'SEQ_FR', 
				xtype		: 'uniTextfield',
				width		: 195,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('SEQ_FR', newValue);
					},
					blur: function(field, The, eOpts)	{
						var newValue = field.getValue().replace(/-/g,'');
						if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
					 		alert(Msg.sMB074);
					 		this.setValue('');
					 		return ;
					 	}
						if (!Ext.isEmpty(panelResult.getValue('SEQ_TO'))) {
							var maxSeq = parseInt(panelResult.getValue('SEQ_TO'));
							if (parseInt(newValue) > maxSeq) {
								alert('뒤의 순번 보다 작은 수를 입력하세요');
					 			this.setValue('');
								return false;
							}
						}
					}
				}
			},{
				xtype	: 'component', 
				html	: '~',
				style	: {
					marginTop	: '3px !important',
					font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel	: '', 
				name		: 'SEQ_TO', 
				xtype		: 'uniTextfield',
				width		: 110,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('SEQ_TO', newValue);
					},
					blur: function(field, The, eOpts)	{
						var newValue = field.getValue().replace(/-/g,'');
						if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
					 		alert(Msg.sMB074);
					 		this.setValue('');
					 		return ;
					 	}
						if (!Ext.isEmpty(panelResult.getValue('SEQ_FR'))) {
							var minSeq = parseInt(panelResult.getValue('SEQ_FR'));
							if (parseInt(newValue) < minSeq) {
								alert('앞의 순번 보다 큰 수를 입력하세요');
					 			this.setValue('');
								return false;
							}
						}
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 18
//		  	,tdAttrs: {style: 'border : 1px solid #ced9e7;'}
			},
			padding	: '0 0 5 15',
			colspan	: 3,
			items	: [{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 1},
				tdAttrs	: {align : 'center'},
				width	: 80,
				items	: [{
					xtype		:'component',
					html		:'[작업순서]',
					componentCls: 'component-text_second',
					tdAttrs		: {align : 'center'},
					width		: 80
				}]
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 1},
				width	: 30,
				tdAttrs	: {align : 'center'},
				items	: [{
					xtype		: 'component',
					html		: '조회',
					tdAttrs		: {align : 'center'},
					componentCls: 'component-text_second',
					width		: 30
				}]
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 1},
				width	: 30,
				tdAttrs	: {align : 'center'},
				items	: [{
					xtype		: 'component',
					html		: '→',
					componentCls: 'component-text_second',
					tdAttrs		: {align : 'center'},
					width		: 30
				}]
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 1},
				width	: 30,
				tdAttrs	: {align : 'center'},
				items	: [{
					xtype		: 'component',
					html		:'체크',  
					tdAttrs		: {align : 'center'},
					componentCls: 'component-text_second',
					width		: 30
				}]
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 1},
				width	: 30,
				tdAttrs	: {align : 'center'},
				items	: [{
					xtype		: 'component',
					html		: '→',
					componentCls: 'component-text_second',
					tdAttrs		: {align : 'center'},
					width		: 30
				}]
			},{
				xtype	: 'container',
				itemId	: 'cmsIdCheck1',
				tdAttrs	: {align : 'center'},
				layout	: {type : 'uniTable', columns : 1},
				width	: 100,
				items	: [{
					xtype	: 'button',
					text	: '예금주조회',	
					name	: '',
					tdAttrs	: {align : 'center'},
					width	: 100, 
					handler	: function() {
						if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
						   alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
						   var sm			= masterGrid.getSelectionModel();
						   var selRecords	= masterGrid.getSelectionModel().getSelection();
						   sm.deselect(selRecords);
						   return false;
						   
						} else {
							var selectedRecords = masterGrid.getSelectedRecords();
							if (selectedRecords.length > 0){
								cmsButtonStore.clearData();
								Ext.each(selectedRecords, function(record,i){
									record.phantom = true;
									cmsButtonStore.insert(i, record);
								});
								cmsButtonFlag = 'SEND';
								cmsButtonStore.saveStore();
														
							}else{
								Ext.Msg.alert('확인','예금주 조회 할 데이터를 선택해 주세요.'); 
							}
						}
					}
				}]
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 1},
				width	: 30,
				tdAttrs	: {align : 'center'},
				items	: [{
					xtype		: 'component',
					html		: '→',
					componentCls: 'component-text_second',
					tdAttrs		: {align : 'center'},
					width		: 30
				}]
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:100,
				tdAttrs: {align : 'center'},
				itemId:'cmsIdCheck3',
				items :[{
					xtype	: 'button',
					text	: '예금주결과받기',
					name	: '',
					tdAttrs	: {align : 'center'},
					width	: 100, 
					handler	: function() {
						if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
						   alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
						   var sm			= masterGrid.getSelectionModel();
						   var selRecords	= masterGrid.getSelectionModel().getSelection();
						   sm.deselect(selRecords);
						   return false;
						   
						} else {
							var selectedRecords = masterGrid.getSelectedRecords();
							if(selectedRecords.length > 0){
								cmsButtonStore.clearData();
								Ext.each(selectedRecords, function(record,i){
									record.phantom = true;
									cmsButtonStore.insert(i, record);
								});
								cmsButtonFlag = 'RECEIVE';
								cmsButtonStore.saveStore();
														
							}else{
								Ext.Msg.alert('확인','예금주결과를 받을 데이터를 선택해 주세요.'); 
							}
						}
					}
				}]
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 1},
				width	: 30,
				tdAttrs	: {align : 'center'},
				items	: [{
					xtype		: 'component',
					html		: '→',
					componentCls: 'component-text_second',
					tdAttrs		: {align : 'center'},
					width		: 30
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
                    	if(Ext.getCmp('unit').getValue().UNIT != 'B'){
                    	   alert('결재요청은 전표단위 옵션을 선택하신 후  진행해 주십시오.');
                    	   return false;
                    	}else{
                            if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                               alert('수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.');
                               var sm = masterGrid.getSelectionModel();
                               var selRecords = masterGrid.getSelectionModel().getSelection();
                               sm.deselect(selRecords);
                               return false;
                               
                            } else {
                                var selectedRecords = masterGrid.getSelectedRecords();
                                
                                if(!Ext.isEmpty(selectedRecords)){
                                    if(confirm('선택한 이체자료를 결재요청 처리하시겠습니까?')) { 
                                        var sm = masterGrid.getSelectionModel();
                                        var selRecords = masterGrid.getSelectionModel().getSelection();
                                        Ext.each(selectedRecords, function(record,i){
                                            if(record.get('CMS_TRANS_YN') != 'Y'){
                                                alert(record.get('ROW_NUMBER') + "번째 이체자료는\n예금주결과받기 처리가 되지 않았습니다.\n확정, 예금주결과받기 처리된 데이터만 결재요청이 가능합니다.");
                
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
                        }
                    }
                }]
            },{
                xtype   : 'container',
                layout  : {type : 'uniTable', columns : 1},
                width   : 30,
                tdAttrs : {align : 'center'},
                items   : [{
                    xtype       : 'component',
                    html        : '→',
                    componentCls: 'component-text_second',
                    tdAttrs     : {align : 'center'},
                    width       : 30
                }]
            },{
				xtype	: 'container',
				layout	: {type	: 'uniTable', columns : 1},
				tdAttrs	: {align: 'center'},
				itemId	: 'cmsIdCheck5',
				items	:[{
					xtype	: 'button',
					text	: '이체지급',
					name	: '',
					tdAttrs	: {align : 'center'},
					width	: 90,
					handler : function() {
						if (!subForm.getInvalidMessage()) {
							return false;
						}
						if (!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
						   alert('신규로 추가된 데이터 또는 수정된 데이터가 있습니다.\n저장을 먼저 진행해 주십시오.\n신규로 추가된 데이터 일 경우 확정 상태로 저장됩니다.');
						   var sm			= masterGrid.getSelectionModel();
						   var selRecords	= masterGrid.getSelectionModel().getSelection();
						   sm.deselect(selRecords);
						   return false;
						} else {
							var selectedRecords = masterGrid.getSelectedRecords();
							if(!Ext.isEmpty(selectedRecords)){
                                if(confirm('선택한 이체지급확정내역을 이체지급 처리하시겠습니까?')) { 
                                    var sm = masterGrid.getSelectionModel();
                                    var selRecords = masterGrid.getSelectionModel().getSelection();
                                    Ext.each(selectedRecords, function(record,i){
                                        if(record.get('DOC_STATUS') != '50'){
                                            alert(record.get('ROW_NUMBER') + "번째 NO의 이체지급확정내역은\n결재완료상태가 아닙니다.\n결재완료 상태만 이체지급이 가능합니다.");
                                            sm.deselect(selRecords[i]);
                                        }
                                    });
                                    var newSelectedRecords = masterGrid.getSelectedRecords();
                                    if(!Ext.isEmpty(newSelectedRecords)){
                                        abh200SaveButtonStore.clearData();
                                        Ext.each(newSelectedRecords, function(record,i){ 
                                            record.phantom = true;
                                            abh200SaveButtonStore.insert(i, record);
                                        });
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
			}]
		}, {               
            //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
            name:'DEC_FLAG', 
            xtype: 'uniTextfield',
            hidden: true
        }]
	});		
	
	var subForm = Unilite.createSearchForm('subForm',{
		layout		: {type : 'uniTable', columns : 2,
		tableAttrs	: { style: 'border : 1px solid #ced9e7;'/*, width: '80%'*/}
		},
		padding		: '1 1 0 1',
		border		: true,
		items		: [{
				xtype		: 'uniDatefield',
				fieldLabel	: '이체일자',
			 	name		: 'SEND_DATE',
				value		: UniDate.get('today'),
				readOnly	: true,
			 	allowBlank	: false,			
				tdAttrs		: {width: 400},  
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
		 	},
			Unilite.popup('BANK_BOOK',{
				fieldLabel		: '출금통장', 
				valueFieldName	: 'OUT_SAVE_CODE',
				textFieldName	: 'BANK_BOOK_NAME',
				valueFieldWidth	: 90,
				textFieldWidth	: 140,
				allowBlank		: false,
//				extParam		: {
//				  'CHARGE_CODE': getChargeCode[0].SUB_CODE
//				  ,'ADD_QUERY': "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"
//				},  
				listeners		: {
//					onValueFieldChange: function(field, newValue){
//					},
//					onTextFieldChange: function(field, newValue){
//					}
					onSelected: {
						fn: function(records, type) {
							subForm.setValue('OUT_BANK_CODE',records[0]["BANK_CD"]);
						},
						scope: this
					},
					onClear: function(type) {
						subForm.setValue('OUT_BANK_CODE','');
					}
				}
			}),{
				xtype	: 'uniTextfield',
				name	: 'OUT_BANK_CODE',
				hidden	: true
			}
			
		 ]  
	});
	
	
	/** Grid
	 * 
	 */
	var masterGrid = Unilite.createGrid('abh230ukrGrid', {
		store		: masterStore,
		excelTitle	: '이체지급 엑셀 업로드',
		region		: 'center',
		uniOpt		: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			onLoadSelectFirst	: false,
			useRowNumberer		: false,
			expandLastColumn	: true,
			useRowContext		: true,
			state				: {
				useState	: true,			
				useStateList: true		
			}
		},
		features	: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
						{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		tbar		: [{
			text	: '엑셀파일 UpLoad',
			handler	: function() {
				openExcelWindow();
			}
		}],
		selModel	: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(Ext.getCmp('unit').getValue().UNIT == 'B'){
                        var sm = masterGrid.getSelectionModel();
                        var selRecords = masterGrid.getSelectionModel().getSelection();
                        var records = masterStore.data.items;
                        Ext.each(records, function(record, index){
                            if(UniDate.getDbDateStr(selectRecord.get('ORG_AC_DATE')) == UniDate.getDbDateStr(record.get('ORG_AC_DATE')) 
                            && selectRecord.get('ORG_SLIP_NUM') == record.get('ORG_SLIP_NUM')){
                                selRecords.push(record);
                            }
                        });
                        sm.select(selRecords);
					}
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                	if(Ext.getCmp('unit').getValue().UNIT == 'B'){
                        var sm = masterGrid.getSelectionModel();
                        var selRecords = masterGrid.getSelectionModel().getSelection();
                        var records = masterStore.data.items;
                        Ext.each(records, function(record, index){
                            if(UniDate.getDbDateStr(selectRecord.get('ORG_AC_DATE')) != UniDate.getDbDateStr(record.get('ORG_AC_DATE'))
                            || selectRecord.get('ORG_SLIP_NUM') != record.get('ORG_SLIP_NUM')){
                                selRecords.splice(0, 10000); 
                            }
                        });
                        Ext.each(records, function(record, index){
                            if(UniDate.getDbDateStr(selectRecord.get('ORG_AC_DATE')) == UniDate.getDbDateStr(record.get('ORG_AC_DATE'))
                            && selectRecord.get('ORG_SLIP_NUM') == record.get('ORG_SLIP_NUM')){
                                selRecords.push(record);
                            }
                        });
                        sm.deselect(selRecords);
                	}
                }
			}
		}),
		columns		: [
		    { dataIndex: 'ROW_NUMBER'               ,width:50, align:'center'},
			{ dataIndex: 'DOC_ID'					, width:50			, hidden:true},
			{ dataIndex: 'COMP_CODE'				, width:80			, hidden:true},
			{ dataIndex: 'SEQ'						, width:66 },
			{ dataIndex: 'ORG_AC_DATE'				, width:120},
			{ dataIndex: 'ORG_SLIP_NUM'				, width:100},
			{ dataIndex: 'ORG_SLIP_SEQ'				, width:100},
			{ dataIndex: 'PAY_EXP_DATE'				, width:100},
			{ dataIndex: 'SEND_DATE'				, width:100},
			{ dataIndex: 'OUT_SAVE_CODE'			, width:120			, hidden:true},
			{ dataIndex: 'BANK_CODE'				, width:120			,
				editor: Unilite.popup('BANK_G', {
					autoPopup: true,
					textFieldName:'BANK_NAME',
					DBtextFieldName: 'BANK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							grdRecord = masterGrid.uniOpt.currentRecord;
							record = records[0];									
							grdRecord.set('BANK_CODE', record['BANK_CODE']);
							grdRecord.set('BANK_NAME', record['BANK_NAME']);
						},
						onClear:function(type)	{
							grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE', '');
							grdRecord.set('BANK_NAME', '');
						}
					}
				})
			},
			{ dataIndex: 'BANK_NAME'				, width:120			,
				editor: Unilite.popup('BANK_G', {
					autoPopup: true,
					textFieldName:'BANK_NAME',
					DBtextFieldName: 'BANK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							grdRecord = masterGrid.uniOpt.currentRecord;
							record = records[0];									
							grdRecord.set('BANK_CODE', record['BANK_CODE']);
							grdRecord.set('BANK_NAME', record['BANK_NAME']);
						},
						onClear:function(type)	{
							grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE', '');
							grdRecord.set('BANK_NAME', '');
						}
					}
				})
			},
			{ dataIndex: 'ACCOUNT_NUM'				, width:140			, hidden:true},
			{ dataIndex: 'ACCOUNT_NUM_EXPOS'		, width:140			, align:'center'},
			{ dataIndex: 'BANKBOOK_NAME'			, width:140},
			{ dataIndex: 'AMT_I'					, width:140},
			{ dataIndex: 'IN_REMARK'				, width:140},
			{ dataIndex: 'RCPT_ID'					, width:120},
			{ dataIndex: 'RCPT_NAME'				, width:120},
            { dataIndex: 'CMS_TRANS_YN'             , width:80},
			{ dataIndex: 'RCPT_RESULT_MSG'			, width:140},
			{ dataIndex: 'RCPT_STATE_NUM'			, width:140},
			{ dataIndex: 'SEND_NUM'					, width:140},
			{ dataIndex: 'INSERT_DB_USER'			, width:50			, hidden:true},
			{ dataIndex: 'INSERT_DB_TIME'			, width:50			, hidden:true},
			{ dataIndex: 'UPDATE_DB_USER'			, width:50			, hidden:true},
			{ dataIndex: 'UPDATE_DB_TIME'			, width:50			, hidden:true},
            { dataIndex: 'DOC_STATUS'               , width:80}
		],
		listeners: {
			beforeedit: function(editor, e){
				if(UniUtils.indexOf(e.field, ['ACCOUNT_NUM_EXPOS'])){
					return false;
					
				} else {
					return;
				}
			}, 
			selectionchangerecord:function(selected)	{
		  	},
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="ACCOUNT_NUM_EXPOS") {
					grid.ownerGrid.openCryptAcntNumPopup(record);
				}
			}
		},
		openCryptAcntNumPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('ACCOUNT_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'ACCOUNT_NUM_EXPOS', 'ACCOUNT_NUM', params);
			}
		}
	});   

	
	
	function openExcelWindow() {
		var me = this;
		var appName = 'Unilite.com.excel.ExcelUpload';

		//업로드 시, 필요한 데이터가 있으면 이 형식으로 넘김	
//		var acYYYY = panelResult.getValue('AC_YYYY');
//		if(!Ext.isEmpty(excelWindow)){
//			excelWindow.extParam.AC_YYYY = panelResult.getValue('AC_YYYY');
//		}
		if(!excelWindow) { 
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				modal	: false,
				excelConfigName: 'abh230ukr',
				width	: 600,
				height	: 200,
				extParam: { 
					'PGM_ID' : 'abh230ukr'//,
/*					//업로드 시, 필요한 데이터가 있으면 이 형식으로 넘김				
					'AC_YYYY' : acYYYY							*/
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
						params: me.extParam,
						waitMsg: 'Uploading...',
						success: function(form, action) {
							abh230ukrService.getErrMsg({}, function(provider, response){
								if (Ext.isEmpty(provider)) {
									me.jobID = action.result.jobID;
									me.readGridData(me.jobID);
									me.down('tabpanel').setActiveTab(1);
									Ext.Msg.alert('Success', 'Upload 성공 하였습니다.');
									
									me.hide();
									UniAppManager.app.onQueryButtonDown();
									
								} else {
									alert(provider);
								}
								//로그테이블 삭제
								abh230ukrService.deleteLog({}, function(provider, response){});
							});

						},
						
						failure: function(form, action) {
							Ext.Msg.alert('Failed', 'Upload 실패 하였습니다.');
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
					}]
				 }
			});
		}
		excelWindow.center();
		excelWindow.show();
	};
	
	//복호화버튼 정의
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
    var unitRadio = Ext.create('Ext.form.RadioGroup',{
        fieldLabel: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처리단위',
        id:'unit',
        labelWidth:75,
        items: [{
            boxLabel: '개별단위',
            width: 80,
            name: 'UNIT',
            inputValue: 'A',
            checked: true
        },{
            boxLabel: '전표단위',
            width: 80,
            name: 'UNIT',
            inputValue: 'B'
        }]
    });
	
	Unilite.Main({
		id			: 'abh230ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult,
				{
					region	: 'north',
					xtype	: 'container',
					items	: [ subForm ],
					layout	: 'fit',
					highth	: 20
				}
			]
		},
		panelSearch  	
		], 
		
		fnInitBinding: function(){
			this.setDefault();
			//복호화 버튼 tbar에 add
			var tbar = masterGrid._getToolBar();
            tbar[0].insert(tbar.length + 1, decrypBtn);
            tbar[0].insert(tbar.length + 2, unitRadio);
            
            
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PAY_EXP_DATE_FR');
		},
		
		onQueryButtonDown: function() {	  
			if(!this.isValidSearchForm()){				//조회 전 필수값 입력 여부 체크
				return false;
			}
			masterStore.loadStoreRecords();		
		},
		
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			subForm.clearForm();
			
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			
			this.fnInitBinding();
		},
		
		onSaveDataButtonDown: function(config) {				
			masterStore.saveStore();
		},
		
		onDeleteDataButtonDown : function()	{										
			var selRow = masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)) {
				if(selRow.phantom == true)	{									
					masterGrid.deleteSelectedRow();									
														
				} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {		//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")					
						masterGrid.deleteSelectedRow();								
				}					
			}
		},											
		
		setDefault: function(){
			//panelSearch 초기값 세팅
			panelSearch.setValue('PAY_EXP_DATE_FR', UniDate.get('today'));
			panelSearch.setValue('PAY_EXP_DATE_TO', UniDate.get('today'));
			panelSearch.getField('SEARCH_DEPOSITOR').setValue('N');
			
			//panelResult 초기값 세팅
			panelResult.setValue('PAY_EXP_DATE_FR', UniDate.get('today'));
			panelResult.setValue('PAY_EXP_DATE_TO', UniDate.get('today'));
			panelSearch.getField('SEARCH_DEPOSITOR').setValue('N');
			
			//subForm 초기값 세팅
			subForm.setValue('SEND_DATE', UniDate.get('today'));

			UniAppManager.setToolbarButtons(['reset'], true);
		}
	});
	
	
	
	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
/*				case "ORG_AMT_I" : 
					record.set('JAN_AMT_I'	, newValue);
					record.set('REAL_AMT_I'	, newValue);
				break;*/
			}
			return rv;
		}
	});	
};

</script>