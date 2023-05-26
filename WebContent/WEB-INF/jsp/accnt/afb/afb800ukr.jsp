<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb800ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb800ukr" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A170" />			<!-- 예산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A171" opts='${gsListA171}' /> 		<!-- 문서서식구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A183"  /> 		<!-- 영수구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A184"  /> 		<!-- 증빙구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A185"  /> 		<!-- 계산서적요 -->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
	var referDepositWindow;	//입금내역참조


	
	var budgNameList = ${budgNameList};
	var budgNameListLength = budgNameList.length;

var	gsAmtPoint ='${gsAmtPoint}';

var gsIdMapping   = '${gsIdMapping}';
var gsLinkedGW    = '${gsLinkedGW}';
	
var gsAccntGubun  = '${gsAccntGubun}';

var gsChargeCode  = '${gsChargeCode}';
var gsChargeDivi  = '${gsChargeDivi}';
	
var gsDrafter = '${gsDrafter}';
var gsDrafterNm = '${gsDrafterNm}';
var gsDeptCode = '${gsDeptCode}';
var gsDeptName = '${gsDeptName}';
var gsDivCode = '${gsDivCode}';

var gsAmender  = '${gsAmender}';
	
var gsBillGubun  = '${gsBillGubun}';

var gsBillRemark  = '${gsBillRemark}';
	
var gsPathInfo1 = '${gsPathInfo1}';
var gsPathInfo2 = '${gsPathInfo2}';
var gsPathInfo3 = '${gsPathInfo3}';
	





var gsExistYN = "";

var gsCrdtSetDate = "";

var saveSuccessCheck = "";	

var pendCode = "";
	
var budgPossAmt = 0;

var pendCodeNewValue = '';
var payCustomCodeNewValue = '';
var payCustomNameNewValue = '';

var supplyAmtINewValue = '';

var taxAmtINewValue = '';
var addReduceAmtINewValue = '';

var conditionCheck = '';
var firstRecord;

var checkMasterOnly = '';
function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb800ukrService.selectDetail',
			update: 'afb800ukrService.updateDetail',
			create: 'afb800ukrService.insertDetail',
			destroy: 'afb800ukrService.deleteDetail',
			syncAll: 'afb800ukrService.saveAll'
		}
	});	
	
	Unilite.defineModel('Afb800ukrModel', {
		fields: [  	  
			{name: 'COMP_CODE'		     		, text: 'COMP_CODE' 		,type: 'string'},
			{name: 'IN_DRAFT_NO'		     	, text: 'IN_DRAFT_NO' 		,type: 'string'},
			{name: 'SEQ'				     	, text: '순번' 				,type: 'uniNumber'},
			{name: 'BUDG_CODE'		     		, text: '예산코드' 			,type: 'string',allowBlank:false},
			{name: 'BUDG_NAME'		     		, text: '예산명' 				,type: 'string',allowBlank:false},
			{name: 'ACCNT'			     		, text: '계정코드' 			,type: 'string',allowBlank:false},
			{name: 'ACCNT_NAME'		     		, text: '계정명' 				,type: 'string'},
			{name: 'PJT_CODE'			     	, text: '프로젝트' 			,type: 'string',allowBlank:false},
			{name: 'PJT_NAME'			     	, text: '프로젝트명' 			,type: 'string'},
			{name: 'BILL_GUBUN'		     		, text: '영수구분' 			,type: 'string',allowBlank:false,comboType:'AU', comboCode:'A183'},
			{name: 'PROOF_DIVI'		     		, text: '증빙구분' 			,type: 'string',comboType:'AU', comboCode:'A184'},
			{name: 'PROOF_KIND'		     		, text: '증빙유형' 			,type: 'string'},
			{name: 'CUSTOM_ESS'		     		, text: '거래처필수' 			,type: 'string'},
			{name: 'BILL_DATE'		     		, text: '계산서일' 			,type: 'uniDate'},
			{name: 'BILL_REMARK'		     	, text: '계산서적요' 			,type: 'string',comboType:'AU', comboCode:'A185'},
			{name: 'CUSTOM_CODE'		     	, text: '거래처' 				,type: 'string'},
			{name: 'CUSTOM_NAME'		     	, text: '거래처명' 			,type: 'string'},
			{name: 'BUDG_POSS_AMT'	     		, text: '예산사용가능금액' 		,type: 'uniPrice'},
			{name: 'IN_AMT_I'			     	, text: '수입액' 				,type: 'uniPrice',allowBlank:false,maxLength:32},
			{name: 'IN_TAX_I'			     	, text: '부가세' 				,type: 'uniPrice'},
			{name: 'SAVE_CODE'		     		, text: '입금통장코드' 			,type: 'string',allowBlank:false},
			{name: 'SAVE_NAME'		     		, text: '입금통장명' 			,type: 'string'},
			{name: 'BANK_ACCOUNT'		     	, text: '계좌번호' 			,type: 'string'},
			{name: 'BANK_NAME'		     		, text: '은행명' 				,type: 'string'},
			{name: 'INOUT_DATE'		     		, text: '실입금일' 			,type: 'uniDate'},
			{name: 'REMARK'			     		, text: '비고' 				,type: 'string'},
			{name: 'DEPT_CODE'		     		, text: '귀속부서' 			,type: 'string'},
			{name: 'DEPT_NAME'		     		, text: '귀속부서명' 			,type: 'string'},
			{name: 'DIV_CODE'			     	, text: '귀속사업장' 			,type: 'string'},
			{name: 'REFER_NUM'		     		, text: 'REFER_NUM' 		,type: 'string'},
			{name: 'INSERT_DB_USER'     		, text: 'INSERT_DB_USER' 	,type: 'string'},
			{name: 'INSERT_DB_TIME'     		, text: 'INSERT_DB_TIME' 	,type: 'string'},
			{name: 'UPDATE_DB_USER'     		, text: 'UPDATE_DB_USER' 	,type: 'string'},
			{name: 'UPDATE_DB_TIME'     		, text: 'UPDATE_DB_TIME' 	,type: 'string'}
	   	 	
		]
	});	
	
	Unilite.defineModel('afb800ukrRef1Model', {	//입금내역참조 
	    fields: [
			{name: 'SEQ'			,text: '순번'				,type: 'uniNumber'},
			{name: 'INOUT_DATE'		,text: '입금일'			,type: 'uniDate'},
			{name: 'SAVE_CODE'		,text: '입금통장'			,type: 'string'},
			{name: 'SAVE_NAME'		,text: '입금통장명'			,type: 'string'},
			{name: 'BANK_ACCOUNT'	,text: '계좌번호'			,type: 'string'},
			{name: 'INOUT_AMT_I'	,text: '입금액'			,type: 'uniPrice'},
			{name: 'REMARK'			,text: '비고'				,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '거래처코드'			,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '거래처명'			,type: 'string'},
			{name: 'REFER_NUM'		,text: '입금참조번호'		,type: 'string'}
	    ]
	});


	
	var directMasterStore = Unilite.createStore('Afb800ukrDirectMasterStore',{
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb800ukrService.selectMaster'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		/*if(directMasterStore.getCount() > 0){
           			UniAppManager.setToolbarButtons(['reset','newData','delete','deleteAll'],true);
           		}*/
           		UniAppManager.app.fnDispMasterData('QUERY');
           		UniAppManager.app.fnMasterDisable(false);
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
		
		
	});
	var directDetailStore = Unilite.createStore('Afb800ukrDirectDetailStore',{
		model: 'Afb800ukrModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable: true,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
//	        deleteAll:true
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
//			param.budgNameInfoList = budgNameList;	//예산목록	
//			param.budgNameListLength = budgNameListLength;
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
//			checkMasterOnly = '';
			var paramMaster= detailForm.getValues();
			paramMaster.TOT_AMT_I =Ext.getCmp('bbarDetailGridBbar').getValue('TOT_AMT_I');
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
        	
        	var confRecords = directDetailStore.data.items;
        	if(Ext.isEmpty(detailForm.getValue('IN_DRAFT_NO')) && Ext.isEmpty(confRecords)){
        		Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0456);
        		
        		return false;
        	}
        	var toCreate = this.getNewRecords();	//신규 레코드 왜 안들어오나 확인필요
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
        	
       		
//       		if(Ext.isEmpty(toCreate) && Ext.isEmpty(toUpdate) && Ext.isEmpty(toDelete)){
//       			checkMasterOnly = 'Y';
//       		}
//        	if(checkMasterOnly == 'Y'){
	
       		if(!directDetailStore.isDirty())	{
				if(detailForm.isDirty())	{
		       		detailForm.getForm().submit({
					params : paramMaster,
						success : function(form, action) {
			 				detailForm.getForm().wasDirty = false;
							detailForm.resetDirtyStatus();											
							UniAppManager.setToolbarButtons('save', false);	
			            	UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
	//		            	UniAppManager.app.onQueryButtonDown();
			            	UniAppManager.app.onQueryButtonDown();
	//						directMasterStore.loadStoreRecords();
						
							if(saveSuccessCheck == 'CS'){
				     			UniAppManager.app.fnCancSlip(); //자동기표취소
				     		}else if(saveSuccessCheck == 'AS'){
				     			UniAppManager.app.fnAutoSlip(); //자동기표
				     		}else if(saveSuccessCheck == 'RA'){
				     			UniAppManager.app.fnReAuto(); //재기표
				     		}
				     		saveSuccessCheck = "";
						
						}	
					});
//       		}else{
				}
       		}else{
				if(inValidRecs.length == 0 )	{
					
					config = {
						params: [paramMaster],
						success: function(batch, option) {
							var master = batch.operations[0].getResultSet();
							detailForm.setValue("IN_DRAFT_NO", master.IN_DRAFT_NO);
	//						directMasterStore.loadStoreRecords();
							UniAppManager.app.onQueryButtonDown();
							if(saveSuccessCheck == 'CS'){
			     				UniAppManager.app.fnCancSlip(); //자동기표취소
				     		}else if(saveSuccessCheck == 'AS'){
				     			UniAppManager.app.fnAutoSlip(); //자동기표
				     		}else if(saveSuccessCheck == 'RA'){
				     			UniAppManager.app.fnReAuto(); //재기표
				     		}
				     		saveSuccessCheck = "";
						}
					};
					this.syncAllDirect(config);
				}else {
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
       		}
		}
	});
	var depositStore = Unilite.createStore('afb800ukrRef1Store', {//입금내역참조
		model: 'afb800ukrRef1Model',
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
            	read: 'afb800ukrService.selectDepositList'                	
            }
        },
        listeners:{
        	load:function(store, records, successful, eOpts)	{
        			if(successful)	{
        			   var detailRecords = directDetailStore.data.filterBy(directDetailStore.filterNewOnly);  
        			   var depositRecords = new Array();
        			   if(detailRecords.items.length > 0)	{
        			   		console.log("store.items :", store.items);
        			   		console.log("records", records);
        			   	
            			   	Ext.each(records, 
            			   		function(item, i)	{           			   								
		   							Ext.each(detailRecords.items, function(record, i)	{
		   								console.log("record :", record);
		   							
		   									if( (record.data['REFER_NUM'] == item.data['REFER_NUM']) 
//		   											&& (record.data['RETURN_SEQ'] == item.data['RETURN_SEQ'])
		   									  ) 
		   									{
		   										depositRecords.push(item);
		   									}
		   							});		
            			   	});
            			   store.remove(depositRecords);
        			   }
        			}
        	}
        },
        loadStoreRecords : function()	{
			var param= depositSearch.getValues();	
			this.load({
				params : param
			});
		}
	});


	

	var cancSlipStore = Unilite.createStore('Afb800ukrCancSlipStore',{		//자동기표취소 관련
		proxy: {
           type: 'direct',
            api: {			
                read: 'afb800ukrService.cancSlip'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
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
	
	var autoSlipStore = Unilite.createStore('Afb800ukrAutoSlipStore',{		//수입결의자동기표 관련
		proxy: {
           type: 'direct',
            api: {			
                read: 'afb800ukrService.autoSlip'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
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
	
	var reAutoStore = Unilite.createStore('Afb800ukrReAutoStore',{		//재기표 관련
		proxy: {
           type: 'direct',
            api: {			
                read: 'afb800ukrService.reAuto'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
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


	
	var detailForm = Unilite.createForm('detailForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3,
			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
	
		},
		padding:'1 1 1 1',
		border:true,
		disabled:false,
		items: [{ 
    		fieldLabel: '수입작성일',
    		labelWidth:150,
		    xtype: 'uniDatefield',
//		    id:'draftDatePR',
		    name: 'IN_DATE',
		    value: UniDate.get('today'),
		    allowBlank: false,tdAttrs: {width:700/*align : 'center'*/},                	
            listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					detailForm.setValue('SLIP_DATE',newValue);
//					UniAppManager.app.fnApplySlipDate(newValue);
				}
			}
		},
		Unilite.popup('Employee', {
			fieldLabel: '수입결의자', 
			labelWidth:150,
			valueFieldName: 'DRAFTER_PN',
    		textFieldName: 'DRAFTER_NM', 
//		    		validateBlank:false,
    		autoPopup:true,
    		tdAttrs: {width:'100%'/*,align : 'center'*/}, 
//    		colspan:2,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						if(!Ext.isEmpty(detailForm.getValue('DRAFTER_PN'))){
							detailForm.setValue('PAY_USER_PN', detailForm.getValue('DRAFTER_PN'));
							detailForm.setValue('PAY_USER_NM', detailForm.getValue('DRAFTER_NM'));
							detailForm.setValue('DEPT_CODE', records[0]["DEPT_CODE"]);
							detailForm.setValue('DEPT_NAME', records[0]["DEPT_NAME"]);
							detailForm.setValue('DIV_CODE', records[0]["DIV_CODE"]);
							
							UniAppManager.app.fnApplyToDetail();
						}
						
                	},
					scope: this
				},
				onClear: function(type)	{
					
				},
				onValueFieldChange: function(field, newValue){
//					panelSearch.setValue('DRAFTER_PN', newValue);								
				},
				onTextFieldChange: function(field, newValue){
//					panelSearch.setValue('DRAFTER_NM', newValue);				
				}
			}
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
			   tdAttrs: {align : 'left',width:120},
			items :[{
	    		xtype: 'button',
	    		text: '결재상신',	
	    		id: 'btnProc',
	    		name: 'PROC',
	    		width: 110,	
				handler : function() {
					if(detailForm.getValue('IN_DRAFT_NO') == ''){
						Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0199);
					}else{
						if(gsLinkedGW == 'Y'){
							UniAppManager.app.fnApproval(); //결재상신
						}else{
//							if(detailForm.down('#btnProc').getText(Msg.fSbMsgA0049)){
							if(detailForm.getValue('EX_NUM') != '' && gsLinkedGW == 'N'){
								if(directDetailStore.getCount() == 0){
									Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0445);	
									return false;
								}
								if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
									Ext.Msg.show({
									     title:'확인',
									     msg: Msg.sMB017 + "\n" + Msg.sMB061,
									     buttons: Ext.Msg.YESNOCANCEL,
									     icon: Ext.Msg.QUESTION,
									     fn: function(res) {
									     	if (res === 'yes' ) {
									     		saveSuccessCheck = 'CS';
												UniAppManager.app.onSaveDataButtonDown();
									     		
									     	} else if(res === 'no') {
									     		UniAppManager.app.fnCancSlip(); //자동기표취소
									     	}
									     }
									});
								} else {
									UniAppManager.app.fnCancSlip(); //자동기표취소
								}
								
							}else if (detailForm.getValue('EX_NUM') == '' && gsLinkedGW == 'N'){
								
								if(directDetailStore.getCount() == 0){
									Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0445);	
									return false;
								}
								if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
									Ext.Msg.show({
									     title:'확인',
									     msg: Msg.sMB017 + "\n" + Msg.sMB061,
									     buttons: Ext.Msg.YESNOCANCEL,
									     icon: Ext.Msg.QUESTION,
									     fn: function(res) {
									     	if (res === 'yes' ) {
									     		saveSuccessCheck = 'AS';
												UniAppManager.app.onSaveDataButtonDown();
									     		
									     	} else if(res === 'no') {
									     		UniAppManager.app.fnAutoSlip(); //자동기표
									     	}
									     }
									});
								} else {
									UniAppManager.app.fnAutoSlip(); //자동기표
								}
							}
						}
					}
				}
	    	}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:500,tdAttrs: {width:700/*align : 'center'*/},
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
			
//			   tdAttrs: {align : 'left'},
			items :[{ 
	    		fieldLabel: '수입일(전표일)',
	    		labelWidth:150,
			    xtype: 'uniDatefield',
	//		    id:'draftDatePR',
			    name: 'SLIP_DATE',
			    value: UniDate.get('today'),
			    allowBlank: false,                	
	            listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
//						UniAppManager.app.fnApplySlipDate(newValue);
					}
				}
			},{
				fieldLabel:'',
				xtype:'uniTextfield',
				name:'EX_NUM',
				width:50,
				readOnly:true,
				tdAttrs: {align : 'left'},
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
//						panelSearch.setValue('EX_NUM', newValue);
//						alert('dd');
					}
				}
			}]
    	},{
		   xtype: 'container',
		   layout: {type : 'uniTable', columns : 2},
		   width:500,
		   tdAttrs: {width:'100%'/*,align : 'center'*/},
		   id:'hiddenContainerPR',
		   defaults : {enforceMaxLength: true},
//		   colspan:2,
//			   tdAttrs: {align : 'left'},
		   items :[{
				fieldLabel:'비밀번호',
				labelWidth:150,
				xtype: 'uniTextfield',
				id:'passWord',
				name: 'PASSWORD',
				inputType: 'password',
				maxLength : 7,
				holdable: 'hold',
				allowBlank:false
//					tdAttrs: {width: 250}
			},{ 
	    		xtype: 'component',  
	    		html:'※ 주민번호 뒤 7자리 입력',
	    		id:'hiddenHtml',
	    		style: {
		           marginTop: '3px !important',
		           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
		           color: 'blue'
				},
	    		tdAttrs: {align : 'left'}
			}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left'},
			items :[{
				xtype:'component',
				html:'자동기표조회',
	    		id: 'btnLinkSlip',
	    		name: 'LINKSLIP',
	    		width: 110,	
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
    	},{ 
    		fieldLabel: '수입결의번호',
    		labelWidth:150,
		    xtype: 'uniTextfield',
		    name: 'IN_DRAFT_NO',
		    readOnly:true,//,	테스트중
		    tdAttrs: {width:700/*align : 'center'*/},
		    //tdAttrs: {align : 'center'},
			listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
//		    		panelSearch.setValue('IN_DRAFT_NO', newValue);
		      	}
     		}
		},
		Unilite.popup('DEPT',{ 
	    	fieldLabel: '예산부서', 
	    	labelWidth:150,
	    	valueFieldName: 'DEPT_CODE',
			textFieldName: 'DEPT_NAME',
//				validateBlank:false,
			valueFieldWidth: 90,
		    textFieldWidth: 140,
	    	autoPopup:true,
	    	allowBlank:false,
	    	tdAttrs: {width:'100%'/*,align : 'center'*/},
//	    	colspan:2,
	    	listeners: {
				onSelected: {
					fn: function(records, type) {
						UniAppManager.app.fnApplyToDetail();
                	},
					scope: this
				},
				onClear: function(type)	{
					UniAppManager.app.fnApplyToDetail();
				},
				onValueFieldChange: function(field, newValue){
//					panelSearch.setValue('DRAFTER_PN', newValue);								
				},
				onTextFieldChange: function(field, newValue){
//					panelSearch.setValue('DRAFTER_NM', newValue);				
				}
			}
		}),	
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
			   tdAttrs: {align : 'left'},
			items :[{
	    		xtype: 'button',
	    		text: '복사',	
	    		id: 'btnCopy',
	    		name: 'COPY',
	    		width: 110,	
				handler : function() {
					
					var bReferNum = false;
					
					if(detailForm.getValue('IN_DRAFT_NO') == ''){
						return false;
					}else{
						// 다시 개발 필요 보류
						
					/*	
						var records = directDetailStore.data.items;
						
						var copyRecords = records;
//							detailGrid.reset();
//							directDetailStore.clearData();
						
							Ext.each(copyRecords, function(record,i){
//								if(record.get('REFER_NUM') != '' && Ext.getCmp('rdoStatus').getValue().STATUS != '5'){
//									bReferNum = true;
//								}else{
								if(!Ext.isEmpty(record.get('SEQ'))){
									UniAppManager.app.copyDataCreateRow();
									
//										UniAppManager.app.onNewDataButtonDown();
				        			detailGrid.setNewDataCopy(record.data);
				        			
								}
//								}
							});
							alert('ddd');
							directDetailStore.remove(directDetailStore.data.items);
							directDetailStore.clearData();*/
						
						var records = directDetailStore.data.items;
						Ext.each(records, function(record,i){
							if(record.get('REFER_NUM') != '' && Ext.getCmp('rdoStatus').getValue().STATUS != '5'){
								bReferNum = true;
							}	
						});
						if(bReferNum == true){
							Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0460);	
						}
						
						
						detailGrid.reset();
						directDetailStore.clearData();
						var param = {"IN_DRAFT_NO": detailForm.getValue('IN_DRAFT_NO')
						};
						afb800ukrService.selectDetail(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								Ext.each(provider, function(record,i){
									UniAppManager.app.copyDataCreateRow();
					        		detailGrid.setNewDataCopy(record);
								});
							}
							
							
							
						});
						
//						UniAppManager.app.fnDispTotAmt();
						
							
						UniAppManager.app.fnDispMasterData("COPY");
						
						UniAppManager.app.fnMasterDisable(false);
						
//						Call goCnn.SetFrameButtonInfo("NW1:SV1")
//						If grdSheet1.Rows > csHeaderRowsCnt Then
//							Call goCnn.SetFrameButtonInfo("DL1:DA1")
//						End If


					}
				}
	    	}]
    	},{
			fieldLabel: '사업장',
			labelWidth:150,
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
	        comboType:'BOR120',
	        allowBlank:false,
	        tdAttrs: {width:700/*align : 'center'*/},
	        //value:UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {		
					UniAppManager.app.fnApplyToDetail();
				}
			}
		},{ 
    		fieldLabel: '문서서식구분',
    		labelWidth:150,
		    name: 'ACCNT_GUBUN',
		    xtype: 'uniCombobox',
		    comboType:'AU',
			comboCode:'A171',
		    allowBlank: false,	
		    tdAttrs: {width:'100%'/*,align : 'center'*/},
//		    colspan:2,
			listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
//		    		UniAppManager.app.fnGetA171RefCode();
		    		
		      	}
     		}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
			   tdAttrs: {align : 'left'},
			items :[{
	    		xtype: 'button',
	    		text: '재기표',	
	    		id: 'btnReAuto',
	    		name: 'REAUTO',
	    		width: 110,	
				handler : function() {
					if(detailForm.getValue('IN_DRAFT_NO') == ''){
						return false;
					}else{
						if(directDetailStore.getCount() == 0){
							Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0445);	
							return false;
						}
						if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	if (res === 'yes' ) {
							     		saveSuccessCheck = 'RA';
										UniAppManager.app.onSaveDataButtonDown();
							     		
							     	} else if(res === 'no') {
							     		UniAppManager.app.fnReAuto(); //재기표
							     	}
							     }
							});
						} else {
							UniAppManager.app.fnReAuto(); //재기표
						}	
					}
				}
	    	}]
    	},{ 
    		fieldLabel: '수입건명',
    		labelWidth:150,
		    xtype: 'uniTextfield',
		    name: 'TITLE',
		    width: 450,
		    allowBlank: false,
		    tdAttrs: {width:700/*align : 'center'*/},
			listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
//		    		panelSearch.setValue('TITLE', newValue);
		      	}
     		}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:600,
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
			tdAttrs: {width:'100%'/*,align : 'center'*/},
			colspan:2,
			items :[{
				xtype: 'radiogroup',		            		
				fieldLabel: '상태',
				labelWidth:150,
				id:'rdoStatus',
				items: [{
					boxLabel: '미상신', 
					width: 60,
					name: 'STATUS',
					inputValue: '0',
					readOnly: true,
					checked:true
				},{
					boxLabel: '결재중', 
					width: 60,
					name: 'STATUS',
					inputValue: '1',
					readOnly: true
				},{
					boxLabel: '반려', 
					width: 45,
					name: 'STATUS',
					inputValue: '5',
					readOnly: true
				},{
					boxLabel : '완결', 
					width: 45,
					name: 'STATUS',
					inputValue: '9',
					readOnly: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
//						panelSearch.getField('STATUS').setValue(newValue.STATUS);					
//						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:800,
			id: 'tdTitleDesc',
			defaults : {enforceMaxLength: true},
			colspan:3,
			tdAttrs: {width:800/*align : 'center'*/},
//			   tdAttrs: {align : 'left'},
			items :[{
		    	fieldLabel:'내용',
		    	labelWidth:150,
	//	    	labelAlign : 'top',
		    	xtype:'textarea',
//		    	id: 'titleDescPR',
		    	name:'TITLE_DESC',
		    	width:800,
//		    	colspan:4,
		    	tdAttrs: {width:800/*align : 'center'*/},
		    	listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
	//		    		panelSearch.setValue('TITLE_DESC', newValue);
			      	}
				}
			}]
    	},{
			   xtype: 'container',
			   layout: {type : 'uniTable', columns : 7},
			   width:500,
			   colspan:3,
//			   tdAttrs: {align : 'left'},
			   defaults : {width:200,labelWidth:130},
			   items :[{
		    		fieldLabel: '상태(HDD_STATUS)',
				    xtype: 'uniTextfield',
				    name: 'HDD_STATUS',
				    hidden:true
		    	},{
		    		fieldLabel: '최초입력자(HDD_INSERT_DB_USER)',
				    xtype: 'uniTextfield',
				    name: 'HDD_INSERT_DB_USER',
				    hidden:true
		    	},{
		    		fieldLabel: '저장유형(HDD_SAVE_TYPE)',
				    xtype: 'uniTextfield',
				    name: 'HDD_SAVE_TYPE',
				    hidden:true
		    	},{
		    		fieldLabel: '복사자료(HDD_COPY_DATA)',
				    xtype: 'uniTextfield',
				    name: 'HDD_COPY_DATA',
				    hidden:true
		    	}]
	    	}
    	
    	],
    	api: {
//	 		load: 'atx800ukrService.selectForm'	,
	 		submit: 'afb800ukrService.syncMaster'	
		}
	});
	var subForm = Unilite.createSearchForm('subForm',{		
//		title:'상세입력',
    	region: 'north', 
//    	flex: 0.2,
//    	height:40,
    	autoScroll: true,
    	border:true,
    	padding:'1 1 1 1',
    	layout : {type : 'uniTable', columns : 1},
    	items:[{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:200,
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
			tdAttrs: {width:200/*,align : 'left'*/},
			items :[
			Unilite.popup('BUDG', {
				fieldLabel: '예산과목', 
				labelWidth:150,
				valueFieldWidth:150,
				textFieldWidth:200,
				valueFieldName: 'BUDG_CODE',
	    		textFieldName: 'BUDG_NAME', 
//				validateBlank:false,
	    		autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
							subForm.setValue('BUDG_NAME', records[0][budgName]);
							subForm.setValue('HDD_ACCNT_CODE', records[0]["ACCNT"]);
							subForm.setValue('HDD_ACCNT_NAME', records[0]["ACCNT_NAME"]);
							subForm.setValue('HDD_PJT_CODE', records[0]["PJT_CODE"]);
							subForm.setValue('HDD_PJT_NAME', records[0]["PJT_NAME"]);
							subForm.setValue('HDD_SAVE_CODE', records[0]["SAVE_CODE"]);
							subForm.setValue('HDD_SAVE_NAME', records[0]["SAVE_NAME"]);
							subForm.setValue('HDD_BANK_ACCOUNT', records[0]["BANK_ACCOUNT"]);
							subForm.setValue('HDD_BANK_NAME', records[0]["BANK_NAME"]);
	                	},
						scope: this
					},
					onClear: function(type)	{
						subForm.setValue('BUDG_CODE', '');
						subForm.setValue('BUDG_NAME', '');
						subForm.setValue('HDD_ACCNT_CODE', '');
						subForm.setValue('HDD_ACCNT_NAME', '');
						subForm.setValue('HDD_PJT_CODE', '');
						subForm.setValue('HDD_PJT_NAME', '');
						subForm.setValue('HDD_SAVE_CODE', '');
						subForm.setValue('HDD_SAVE_NAME', '');
						subForm.setValue('HDD_BANK_ACCOUNT', '');
						subForm.setValue('HDD_BANK_NAME', '');
						
					},
					applyextparam: function(popup) {							
						popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')).substring(0, 4)});
				   		popup.setExtParam({'DEPT_CODE' : detailForm.getValue('DEPT_CODE')});
				   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '1' AND GROUP_YN = 'N' AND USE_YN = 'Y'"});
					}
				
				}
			}),
			{
	    		xtype: 'button',
	    		text: '일괄적용',	
	    		id: 'btnAllApply',
	    		name: 'ALLAPPLY',
	    		width: 90,	
				handler : function() {
					UniAppManager.app.fnAllApplybtn();
				}
	    	}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 8},
			width:200,
//				id:'hiddenContainerPR',
			defaults : {enforceMaxLength: true},
			tdAttrs: {width:200/*,align : 'left'*/},
			items :[
	    	{
	    		fieldLabel: 'HDD_ACCNT_CODE',
			    xtype: 'uniTextfield',
			    name: 'HDD_ACCNT_CODE',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_ACCNT_NAME',
			    xtype: 'uniTextfield',
			    name: 'HDD_ACCNT_NAME',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_PJT_CODE',
			    xtype: 'uniTextfield',
			    name: 'HDD_PJT_CODE',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_PJT_NAME',
			    xtype: 'uniTextfield',
			    name: 'HDD_PJT_NAME',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_SAVE_CODE',
			    xtype: 'uniTextfield',
			    name: 'HDD_SAVE_CODE',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_SAVE_NAME',
			    xtype: 'uniTextfield',
			    name: 'HDD_SAVE_NAME',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_BANK_ACCOUNT',
			    xtype: 'uniTextfield',
			    name: 'HDD_BANK_ACCOUNT',
			    hidden:true
	    	},{
	    		fieldLabel: 'HDD_BANK_NAME',
			    xtype: 'uniTextfield',
			    name: 'HDD_BANK_NAME',
			    hidden:true
	    	}
	    	
	    	
	    	
	    	
	    	]
    	}]
	});
	var depositSearch = Unilite.createSearchForm('depositForm', {//입금내역참조
		layout :  {type : 'uniTable', columns : 2},
    	items :[{ 
    		fieldLabel: '입금일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'FR_DATE',
		    endFieldName: 'TO_DATE',
		    startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    allowBlank: false
		},
		Unilite.popup('BANK_BOOK',{
			fieldLabel: '입금계좌', 
			valueFieldName:'BANK_BOOK_CODE',
		    textFieldName:'BANK_BOOK_NAME'
		  
		})
		]
    });
    
    
 
   
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var detailGrid = Unilite.createGrid('Afb800ukrGrid', {
    	
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
		tbar: [{
//					itemId: 'depositBtn',
					id: 'depositBtn',
					text: '입금내역참조',
					handler: function() {
						openDepositWindow();
					}
				
		}],
        bbar: ['->',{
        	fieldLabel:'수입액 합계',
        	labelAlign : 'right',
        	labelStyle: "color: blue;",
        	xtype:'uniNumberfield',
        	id:'bbarDetailGridBbar',
        	name:'TOT_AMT_I',
        	readOnly:true
		}],
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
			expandLastColumn	: false,
    		dblClickToEdit		: true,
    		onLoadSelectFirst	: true, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			state: {
				useState: true,			
				useStateList: true		
			}
		},
        columns:[        
        	{dataIndex: 'COMP_CODE'		     	, width: 100,hidden:true},
        	{dataIndex: 'IN_DRAFT_NO'	     	, width: 100,hidden:true},
        	{dataIndex: 'SEQ'			     	, width: 60,align:'center'
//        		renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
//        			if (val == 0){
//                        return '';
//                    }else{
//                    	return val;	
//                    }
//        		}
        	},
        	{dataIndex: 'BUDG_CODE'		     	, width: 133,
        		editor: Unilite.popup('BUDG_G',{
	        		textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
	        		listeners:{ 
	        			scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
                    		var grdRecord = detailGrid.uniOpt.currentRecord;
                    		
                    		grdRecord.set('BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('BUDG_NAME'		,records[0][budgName]);
							grdRecord.set('ACCNT'			,records[0]['ACCNT']);
							grdRecord.set('ACCNT_NAME'		,records[0]['ACCNT_NAME']);
							grdRecord.set('PJT_CODE'		,records[0]['PJT_CODE']);
							grdRecord.set('PJT_NAME'		,records[0]['PJT_NAME']);
							
							if(grdRecord.get('SAVE_CODE') == ''){
								grdRecord.set('SAVE_CODE'		,records[0]['SAVE_CODE']);
								grdRecord.set('SAVE_NAME'		,records[0]['SAVE_NAME']);
								grdRecord.set('BANK_ACCOUNT'	,records[0]['BANK_ACCOUNT']);
								grdRecord.set('BANK_NAME'		,records[0]['BANK_NAME']);
							}
							
							UniAppManager.app.fnGetBudgPossAmt(grdRecord);
							
                    	},
						onClear:function(type)	{
	                  		var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('BUDG_CODE'		,'');
							grdRecord.set('BUDG_NAME'		,'');
							grdRecord.set('ACCNT'			,'');
            				grdRecord.set('ACCNT_NAME'		,'');
            				grdRecord.set('PJT_CODE'		,'');
            				grdRecord.set('PJT_NAME'		,'');
            				grdRecord.set('BUDG_POSS_AMT'	,'');
            				
            				
            				if(grdRecord.get('REFER_NUM') == ''){
	            				grdRecord.set('SAVE_CODE'		,'');
	            				grdRecord.set('SAVE_NAME'		,'');
	            				grdRecord.set('BANK_ACCOUNT'	,'');
	            				grdRecord.set('BANK_NAME'		,'');
            				}
	                  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')).substring(0, 4),
							   		'DEPT_CODE' : detailForm.getValue('DEPT_CODE'),
							   		'ADD_QUERY' : "BUDG_TYPE = '1' AND GROUP_YN = 'N' AND USE_YN = 'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
	        	})
        	},
        	{dataIndex: 'BUDG_NAME'		     	, width: 120,
        		editor: Unilite.popup('BUDG_G',{
	        		textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
	        		listeners:{ 
	        			scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
                    		var grdRecord = detailGrid.uniOpt.currentRecord;
                    		
                    		grdRecord.set('BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('BUDG_NAME'		,records[0][budgName]);
							grdRecord.set('ACCNT'			,records[0]['ACCNT']);
							grdRecord.set('ACCNT_NAME'		,records[0]['ACCNT_NAME']);
							grdRecord.set('PJT_CODE'		,records[0]['PJT_CODE']);
							grdRecord.set('PJT_NAME'		,records[0]['PJT_NAME']);
							
							if(grdRecord.get('SAVE_CODE') == ''){
								grdRecord.set('SAVE_CODE'		,records[0]['SAVE_CODE']);
								grdRecord.set('SAVE_NAME'		,records[0]['SAVE_NAME']);
								grdRecord.set('BANK_ACCOUNT'	,records[0]['BANK_ACCOUNT']);
								grdRecord.set('BANK_NAME'		,records[0]['BANK_NAME']);
							}
							
							UniAppManager.app.fnGetBudgPossAmt(grdRecord);
							
                    	},
						onClear:function(type)	{
	                  		var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('BUDG_CODE'		,'');
							grdRecord.set('BUDG_NAME'		,'');
							grdRecord.set('ACCNT'			,'');
            				grdRecord.set('ACCNT_NAME'		,'');
            				grdRecord.set('PJT_CODE'		,'');
            				grdRecord.set('PJT_NAME'		,'');
            				grdRecord.set('BUDG_POSS_AMT'	,'');
            				
            				
            				if(grdRecord.get('REFER_NUM') == ''){
	            				grdRecord.set('SAVE_CODE'		,'');
	            				grdRecord.set('SAVE_NAME'		,'');
	            				grdRecord.set('BANK_ACCOUNT'	,'');
	            				grdRecord.set('BANK_NAME'		,'');
            				}
	                  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')).substring(0, 4),
							   		'DEPT_CODE' : detailForm.getValue('DEPT_CODE'),
							   		'ADD_QUERY' : "BUDG_TYPE = '1' AND GROUP_YN = 'N' AND USE_YN = 'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
	        	})
        	},
        	{dataIndex: 'ACCNT'			     	, width: 80,
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', records[0].ACCNT_CODE);
							grdRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NAME', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'CHARGE_CODE':gsChargeCode,
									'ADD_QUERY':"GROUP_YN = 'N'" 
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	},
        	{dataIndex: 'ACCNT_NAME'		    , width: 120,
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', records[0].ACCNT_CODE);
							grdRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NAME', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'CHARGE_CODE':gsChargeCode,
									'ADD_QUERY':"GROUP_YN = 'N'" 
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	},
        	{dataIndex: 'PJT_CODE'		     	, width: 80,
        		editor: Unilite.popup('AC_PROJECT_G',{
	        		textFieldName: 'AC_PROJECT_NAME',
					DBtextFieldName: 'AC_PROJECT_NAME',
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
                    		grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
							grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
							
							if(grdRecord.get('SAVE_CODE') == ''){
			                	var param = {"PJT_CODE": records[0]['AC_PROJECT_CODE']};
								accntCommonService.fnGetSaveCodeofProject(param, function(provider, response)	{
									if(!Ext.isEmpty(provider)){
										Ext.each(provider, function(record,i){
											grdRecord.set('SAVE_CODE'		,provider.SAVE_CODE);	
											grdRecord.set('SAVE_NAME'		,provider.SAVE_NAME);	
											grdRecord.set('BANK_ACCOUNT'	,provider.BANK_ACCOUNT);	
											grdRecord.set('BANK_NAME'		,provider.BANK_NAME);
										})
									}
								})
							}
	                    },
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PJT_CODE'		,'');
							grdRecord.set('PJT_NAME'		,'');
							
							if(grdRecord.get('REFER_NUM') == ''){
								grdRecord.set('SAVE_CODE'		,'');	
								grdRecord.set('SAVE_NAME'		,'');	
								grdRecord.set('BANK_ACCOUNT'	,'');	
								grdRecord.set('BANK_NAME'		,'');
							}
						}
        			}
        		})
        	},
        	{dataIndex: 'PJT_NAME'		     	, width: 120,
        		editor: Unilite.popup('AC_PROJECT_G',{
	        		textFieldName: 'AC_PROJECT_NAME',
					DBtextFieldName: 'AC_PROJECT_NAME',
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
                    		grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
							grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
							
							if(grdRecord.get('SAVE_CODE') == ''){
			                	var param = {"PJT_CODE": records[0]['AC_PROJECT_CODE']};
								accntCommonService.fnGetSaveCodeofProject(param, function(provider, response)	{
									if(!Ext.isEmpty(provider)){
										Ext.each(provider, function(record,i){
											grdRecord.set('SAVE_CODE'		,provider.SAVE_CODE);	
											grdRecord.set('SAVE_NAME'		,provider.SAVE_NAME);	
											grdRecord.set('BANK_ACCOUNT'	,provider.BANK_ACCOUNT);	
											grdRecord.set('BANK_NAME'		,provider.BANK_NAME);
										})
									}
								})
							}
	                    },
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PJT_CODE'		,'');
							grdRecord.set('PJT_NAME'		,'');
							
							if(grdRecord.get('REFER_NUM') == ''){
								grdRecord.set('SAVE_CODE'		,'');	
								grdRecord.set('SAVE_NAME'		,'');	
								grdRecord.set('BANK_ACCOUNT'	,'');	
								grdRecord.set('BANK_NAME'		,'');
							}
						}
        			}
        		})
        	},
        	{dataIndex: 'BILL_GUBUN'		    , width: 93},
        	{dataIndex: 'PROOF_DIVI'		    , width: 93},
        	{dataIndex: 'PROOF_KIND'		    , width: 66,hidden:true},
        	{dataIndex: 'CUSTOM_ESS'		    , width: 66,hidden:true},
        	{dataIndex: 'BILL_DATE'		     	, width: 80},
        	{dataIndex: 'BILL_REMARK'	     	, width: 133},
        	{dataIndex: 'CUSTOM_CODE'	     	, width: 66,
        		editor: Unilite.popup('CUST_G',{
	        		textFieldName: 'CUSTOM_NAME',
					DBtextFieldName: 'CUSTOM_NAME',
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
                    		grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							
	                    },
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
        			}
	        	})
        	},
        	{dataIndex: 'CUSTOM_NAME'	     	, width: 166,
        		editor: Unilite.popup('CUST_G',{
	        		textFieldName: 'CUSTOM_NAME',
					DBtextFieldName: 'CUSTOM_NAME',
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
                    		grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							
	                    },
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
        			}
	        	})
        	},
        	{dataIndex: 'BUDG_POSS_AMT'	     	, width: 120},
        	{dataIndex: 'IN_AMT_I'		     	, width: 86},
        	{dataIndex: 'IN_TAX_I'		     	, width: 66,hidden:true},
        	{dataIndex: 'SAVE_CODE'		     	, width: 100,
        		editor:Unilite.popup('BANK_BOOK_G', {
					autoPopup: true,
					textFieldName:'BANK_BOOK_NAME',
					DBtextFieldName: 'BANK_BOOK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', records[0].BANK_BOOK_CODE);
							grdRecord.set('SAVE_NAME', records[0].BANK_BOOK_NAME);
							grdRecord.set('BANK_ACCOUNT', records[0].DEPOSIT_NUM);
							grdRecord.set('BANK_NAME', records[0].BANK_NM);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', '');
							grdRecord.set('SAVE_NAME', '');
							grdRecord.set('BANK_ACCOUNT', '');
							grdRecord.set('BANK_NAME', '');
						}
					}
				})
        	},
        	{dataIndex: 'SAVE_NAME'		     	, width: 120,
        		editor:Unilite.popup('BANK_BOOK_G', {
					autoPopup: true,
					textFieldName:'BANK_BOOK_NAME',
					DBtextFieldName: 'BANK_BOOK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', records[0].BANK_BOOK_CODE);
							grdRecord.set('SAVE_NAME', records[0].BANK_BOOK_NAME);
							grdRecord.set('BANK_ACCOUNT', records[0].DEPOSIT_NUM);
							grdRecord.set('BANK_NAME', records[0].BANK_NM);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', '');
							grdRecord.set('SAVE_NAME', '');
							grdRecord.set('BANK_ACCOUNT', '');
							grdRecord.set('BANK_NAME', '');
						}
					}
				})
        	},
        	{dataIndex: 'BANK_ACCOUNT'	     	, width: 133},
        	{dataIndex: 'BANK_NAME'		     	, width: 166},
        	{dataIndex: 'INOUT_DATE'		    , width: 80},
        	{dataIndex: 'REMARK'			    , width: 133},
        	{dataIndex: 'DEPT_CODE'		     	, width: 66,hidden:true},
        	{dataIndex: 'DEPT_NAME'		     	, width: 100,hidden:true},
        	{dataIndex: 'DIV_CODE'		     	, width: 86,hidden:true},
        	{dataIndex: 'REFER_NUM'		     	, width: 100,hidden:true},
        	{dataIndex: 'INSERT_DB_USER'     	, width: 100,hidden:true},
        	{dataIndex: 'INSERT_DB_TIME'     	, width: 100,hidden:true},
        	{dataIndex: 'UPDATE_DB_USER'     	, width: 100,hidden:true},
        	{dataIndex: 'UPDATE_DB_TIME'		, width: 100,hidden:true}
    	],               
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		
      	 		var bEditable;	
        		
        		bEditable = true;
        		
        		if(Ext.getCmp('rdoStatus').getValue().STATUS != '0'){
        			bEditable = false;
        		}
        		
        		if(gsAmender == 'Y' && Ext.getCmp('rdoStatus').getValue().STATUS != '5'){
        			bEditable = true;	
        		}
        		
        		if(bEditable == false){
        			return false;
        		}
        		
        		if(UniUtils.indexOf(e.field, ['SEQ','BANK_ACCOUNT','BANK_NAME'])){
        			return false;
        		}else{
    				return true;
    			}
			}
        	/*itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}*/
        },
        
        setNewDataCopy:function(record){
			var grdRecord = this.getSelectedRecord();
			
			grdRecord.set('COMP_CODE'		     	,record['COMP_CODE']);
//			grdRecord.set('IN_DRAFT_NO'	     		,record['IN_DRAFT_NO']);
//			grdRecord.set('SEQ'			     		,record['SEQ']);
			grdRecord.set('BUDG_CODE'		     	,record['BUDG_CODE']);
			grdRecord.set('BUDG_NAME'		     	,record['BUDG_NAME']);
			grdRecord.set('ACCNT'			     	,record['ACCNT']);
			grdRecord.set('ACCNT_NAME'		     	,record['ACCNT_NAME']);
			grdRecord.set('PJT_CODE'		     	,record['PJT_CODE']);
			grdRecord.set('PJT_NAME'		     	,record['PJT_NAME']);
			grdRecord.set('BILL_GUBUN'		     	,record['BILL_GUBUN']);
			grdRecord.set('PROOF_DIVI'		     	,record['PROOF_DIVI']);
			grdRecord.set('PROOF_KIND'		     	,record['PROOF_KIND']);
			grdRecord.set('CUSTOM_ESS'		     	,record['CUSTOM_ESS']);
			grdRecord.set('BILL_DATE'		     	,record['BILL_DATE']);
			grdRecord.set('BILL_REMARK'	     		,record['BILL_REMARK']);
			grdRecord.set('CUSTOM_CODE'	     		,record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'	     		,record['CUSTOM_NAME']);
			grdRecord.set('BUDG_POSS_AMT'	     	,record['BUDG_POSS_AMT']);
			grdRecord.set('IN_AMT_I'		     	,record['IN_AMT_I']);
			grdRecord.set('IN_TAX_I'		     	,record['IN_TAX_I']);
			grdRecord.set('SAVE_CODE'		     	,record['SAVE_CODE']);
			grdRecord.set('SAVE_NAME'		     	,record['SAVE_NAME']);
			grdRecord.set('BANK_ACCOUNT'	     	,record['BANK_ACCOUNT']);
			grdRecord.set('BANK_NAME'		     	,record['BANK_NAME']);
			grdRecord.set('INOUT_DATE'		     	,record['INOUT_DATE']);
			grdRecord.set('REMARK'			     	,record['REMARK']);
			grdRecord.set('DEPT_CODE'		     	,record['DEPT_CODE']);
			grdRecord.set('DEPT_NAME'		     	,record['DEPT_NAME']);
			grdRecord.set('DIV_CODE'		     	,record['DIV_CODE']);
			grdRecord.set('REFER_NUM'		     	,record['REFER_NUM']);
			
			UniAppManager.app.fnDispTotAmt(grdRecord.get('IN_AMT_I'),record['IN_AMT_I']);
		},
		
		setDepositData: function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('IN_DRAFT_NO'     	,detailForm.getValue('IN_DRAFT_NO'));
			grdRecord.set('BILL_GUBUN'     		,gsBillGubun);	
			grdRecord.set('DIV_CODE'     		,detailForm.getValue('DIV_CODE'));
			grdRecord.set('DEPT_CODE'     		,detailForm.getValue('DEPT_CODE'));
			grdRecord.set('DEPT_NAME'     		,detailForm.getValue('DEPT_NAME'));	
			grdRecord.set('REFER_NUM'     		,record['REFER_NUM']);	
			grdRecord.set('INOUT_DATE'     		,record['INOUT_DATE']);	
			grdRecord.set('SAVE_CODE'     		,record['SAVE_CODE']);	
			grdRecord.set('IN_AMT_I'     		,record['INOUT_AMT_I']);	
			grdRecord.set('REMARK'     			,record['REMARK']);	
			grdRecord.set('CUSTOM_CODE'     	,record['CUSTOM_CODE']);	
			grdRecord.set('CUSTOM_NAME'     	,record['CUSTOM_NAME']);	
			
			UniAppManager.app.fnDispTotAmt(grdRecord.get('IN_AMT_I'),record['INOUT_AMT_I']);
			
		}
		/*onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		 return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '예산기안(추산)등록 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb600(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb600:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'afb800ukr',
					'AC_DATE' 			: record.data['AC_DATE'],
					'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE'),
					'ACCNT' 			: record.data['ACCNT'],	
					'ACCNT_NAME' 		: record.data['ACCNT_NAME'],
					'START_DATE'		: panelSearch.getValue('START_DATE')
				}
		  		var rec1 = {data : {prgID : 'afb800ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb800ukr.do', params);
			}
    	}*/
    });   
    var depositGrid = Unilite.createGrid('afb800ukrDepositGrid', {//입금내역참조
        // title: '기본',
        layout : 'fit',
        excelTitle: '입금내역참조',
    	store: depositStore,
    	uniOpt: {
    		onLoadSelectFirst: false  
        },
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
        columns:  [  
			{ dataIndex: 'SEQ'					, width:88,align:'center'},
			{ dataIndex: 'INOUT_DATE'			, width:88},
			{ dataIndex: 'SAVE_CODE'			, width:88},
			{ dataIndex: 'SAVE_NAME'			, width:120},
			{ dataIndex: 'BANK_ACCOUNT'			, width:88},
			{ dataIndex: 'INOUT_AMT_I'			, width:88},
			{ dataIndex: 'REMARK'				, width:150},
			{ dataIndex: 'CUSTOM_CODE'			, width:88},
			{ dataIndex: 'CUSTOM_NAME'			, width:120},
			{ dataIndex: 'REFER_NUM'			, width:88}
		], 
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()	{
       		//var records = this.getSelectedRecords();
       		var records = this.sortedSelectedRecords(this);
       		
			Ext.each(records, function(record,i){	
	        	UniAppManager.app.onNewDataButtonDown();
	        	detailGrid.setDepositData(record.data);								        
		    }); 
			this.getStore().remove(records);
       	}
    });
    
   
   
    function openDepositWindow() {    		//입금내역참조
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		
//  		depositStore.loadStoreRecords(); 
		if(!referDepositWindow) {
			referDepositWindow = Ext.create('widget.uniDetailWindow', {
                title: '입금내역참조',
                width: 1100,				                
                height: 350,
                layout:{type:'vbox', align:'stretch'},
                items: [depositSearch, depositGrid],
                tbar:  ['->',
					{	
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							depositStore.loadStoreRecords();
						},
						disabled: false
					},{	
						itemId : 'confirmBtn',
						text: '참조적용',
						handler: function() {
							depositGrid.returnData();
						},
						disabled: false
					},{	
						itemId : 'confirmCloseBtn',
						text: '참조적용 후 닫기',
						handler: function() {
							depositGrid.returnData();
							referDepositWindow.hide();
							depositGrid.reset();
							depositSearch.clearForm();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							referDepositWindow.hide();
							depositGrid.reset();
							depositSearch.clearForm();
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{
						//orderSearch.clearForm();
						//orderGrid.reset();
					},
		 			beforeclose: function( panel, eOpts )	{
						//orderSearch.clearForm();
						//orderGrid.reset();
		 			},
				/*	beforeshow: function ( me, eOpts )	{
						depositSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
				  		depositSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
				  		depositSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
				  		depositSearch.setValue('WH_CODE', panelSearch.getValue('WH_CODE'));
				  		depositSearch.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
				  		depositSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
				  		depositSearch.setValue('RETURN_DATE', panelSearch.getValue('INOUT_DATE'));
				  		depositSearch.setValue('RETURN_CODE', panelSearch.getValue('RETURN_CODE'));
				  		depositSearch.setValue('INOUT_PRSN', panelSearch.getValue('INOUT_PRSN'));
						
//		 				orderStore.loadStoreRecords();
		 			},*/
		 			
		 			show: function ( panel, eOpts )	{
						depositSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
						depositSearch.setValue('TO_DATE',UniDate.get('today'));
		 			}
				}
			})
		}
		referDepositWindow.center();
		referDepositWindow.show();
    }
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailForm, subForm, detailGrid
			]
		}], 
//		panelSearch: dedAmtSearch,
		id : 'Afb800ukrApp',
		fnInitBinding : function(params) {
			
			var param= Ext.getCmp('detailForm').getValues();
			param.budgNameInfoList = budgNameList;	//예산목록
//			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
//			detailForm.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DRAFT_DATE', UniDate.get('today'));
//			detailForm.setValue('DRAFT_DATE', UniDate.get('today'));
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.setToolbarButtons(['query'], false);
			
//			detailForm.getField('DRAFT_TITLE').setDisabled(true);
//			detailForm.getField('PAY_DTL_TITLE').setReadOnly(true);
			this.setDefault(params);
			detailForm.onLoadSelectText('IN_DATE');
		},
		onQueryButtonDown : function()	{
			directMasterStore.loadStoreRecords();
			directDetailStore.loadStoreRecords();
//			setTimeout("edit.completeEdit()", 1000);
			
//			setTimeout(function(){
//				UniAppManager.app.fnDispMasterData('QUERY');
//			}
//				, 5000
//				
//			)
//			alert('ssss');
			
		},
		onNewDataButtonDown: function(copyCheck)	{
//			if(!this.checkForNewDetail()) return false;
			if(!detailForm.getInvalidMessage()) return false;
			
			var compCode      = UserInfo.compCode;
			var inDraftNo     = detailForm.getValue('IN_DRAFT_NO');
			var seq = directDetailStore.max('SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
			var billGubun     = gsBillGubun;
			var billRemark    = gsBillRemark;
			var deptCode      = detailForm.getValue('DEPT_CODE');
			var deptName      = detailForm.getValue('DEPT_NAME');
			var divCode       = detailForm.getValue('DIV_CODE');
			
			
            var r = {
            	COMP_CODE : compCode,     
				IN_DRAFT_NO : inDraftNo,  
				SEQ	 		 : seq,
				BILL_GUBUN : billGubun,    
				BILL_REMARK : billRemark,    
				DEPT_CODE : deptCode,     
				DEPT_NAME : deptName,    
				DIV_CODE : divCode   
	        };
	        if(copyCheck == 'Y'){
	        	detailGrid.createRow(r);	
	        }else{
				detailGrid.createRow(r,'BUDG_CODE');
	        }
				
		},
		copyDataCreateRow: function()	{
			var seq = directDetailStore.max('SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
            var r = {  
				SEQ	 		 : seq
	        };
			detailGrid.createRow(r);
		},
		
		onResetButtonDown: function() {		
			detailForm.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			UniAppManager.app.fnInitInputFields();
			UniAppManager.app.fnMasterDisable(false);
			UniAppManager.setToolbarButtons(['delete','deleteAll','save'], false);
		},
		onSaveDataButtonDown: function(config) {
			if(!detailForm.getInvalidMessage()) return false; 
			directDetailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var records = directDetailStore.data.items;
			var selRow = detailGrid.getSelectedRecord();
			
			var inAmtI;
			var oldTotAmtI;
			var newTotAmtI;
						
			
			
			if(selRow.phantom === true)	{
				oldTotAmtI = Ext.getCmp('bbarDetailGridBbar').getValue('TOT_AMT_I');
				inAmtI = selRow.get('IN_AMT_I');
				
				detailGrid.deleteSelectedRow();
				
				Ext.getCmp('bbarDetailGridBbar').setValue(oldTotAmtI-inAmtI);
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				oldTotAmtI = Ext.getCmp('bbarDetailGridBbar').getValue('TOT_AMT_I');
				inAmtI = selRow.get('IN_AMT_I');
				
				detailGrid.deleteSelectedRow();
				
				Ext.getCmp('bbarDetailGridBbar').setValue(oldTotAmtI-inAmtI);
			}
		},
		onDeleteAllButtonDown: function() {
			if(confirm('전체삭제 하시겠습니까?')) {
				var param = {
					IN_DRAFT_NO: detailForm.getValue('IN_DRAFT_NO'),
					DRAFTER_PN  : detailForm.getValue('DRAFTER_PN'),
					PASSWORD  : detailForm.getValue('PASSWORD')
				}
				detailForm.getEl().mask('전체삭제 중...','loading-indicator');
				detailGrid.getEl().mask('전체삭제 중...','loading-indicator');
				afb800ukrService.afb800ukrDelA(param, function(provider, response)	{							
					if(provider){	
						UniAppManager.updateStatus(Msg.sMB013);
						
						UniAppManager.app.onResetButtonDown();	
					}
					detailForm.getEl().unmask();
					detailGrid.getEl().unmask();
					
				});
			}else{
				return false;	
			}
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params.PGM_ID == 'afb800skr') {
				
				detailForm.setValue('IN_DRAFT_NO',params.IN_DRAFT_NO);
				
				
//				panelSearch.setValue('AC_DATE_FR',params.AC_DATE);
//				panelSearch.setValue('AC_DATE_TO',params.AC_DATE);
//				panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
//				panelSearch.setValue('DIV_CODE',params.DIV_CODE);
//				
//				detailForm.setValue('AC_DATE_FR',params.AC_DATE);
//				detailForm.setValue('AC_DATE_TO',params.AC_DATE);
//				detailForm.setValue('INPUT_PATH',params.INPUT_PATH);
//				detailForm.setValue('DIV_CODE',params.DIV_CODE);
				
				this.onQueryButtonDown();
			}
		},
		setDefault: function(params){
			UniAppManager.app.fnInitInputProperties();
			
			if(!Ext.isEmpty(params.IN_DRAFT_NO)){
				this.processParams(params);
			}else{
				UniAppManager.app.fnInitInputFields();	
			}
			
		},
		/**
		 * 입력란의 속성 설정 (입력가능여부 등)
		 */
		fnInitInputProperties: function() {		//수입결의 완료
			
			 /* '프로그램의 사업장권한이 전체(멀티)권한이 아닌 경우, 사업장 비활성화 처리
    If gsAuParam(0) <> "N" Then
        cboDivCode.disabled	= True
        btnDivCode.disabled = True
    End If*/
			
			//지출관리 아이디와 1:1 매핑
			if(gsIdMapping == 'Y'){
					
				detailForm.getField('DRAFTER_PN').setReadOnly(true);
				detailForm.getField('DRAFTER_NM').setReadOnly(true);
				
				detailForm.getField("DRAFTER_PN").setConfig('allowBlank',true);
				detailForm.getField("DRAFTER_NM").setConfig('allowBlank',true);
				
				Ext.getCmp('passWord').setHidden(true);
				Ext.getCmp('hiddenHtml').setHidden(true);
				
				detailForm.getField("PASSWORD").setConfig('allowBlank',true);
			}else{
					
				detailForm.getField('DRAFTER_PN').setReadOnly(false);
				detailForm.getField('DRAFTER_NM').setReadOnly(false);
				
				detailForm.getField("DRAFTER_PN").setConfig('allowBlank',false);
				detailForm.getField("DRAFTER_NM").setConfig('allowBlank',false);
				
				Ext.getCmp('passWord').setHidden(false);
				Ext.getCmp('hiddenHtml').setHidden(false);
				
				detailForm.getField("PASSWORD").setConfig('allowBlank',false);
			}
			
			//지출결의 그룹웨어 연동여부
			if(gsLinkedGW == 'Y'){
				
				detailForm.down('#btnProc').setText(Msg.fSbMsgA0437);
				Ext.getCmp('rdoStatus').setHidden(false);
				
				if(gsAmender == 'Y'){
					
					Ext.getCmp('btnReAuto').setHidden(false);
				}else{
					
					Ext.getCmp('btnReAuto').setHidden(true);
				}
				
				
			}else{
				detailForm.down('#btnProc').setText(Msg.fSbMsgA0457);
				Ext.getCmp('btnReAuto').setHidden(true);
				Ext.getCmp('rdoStatus').setHidden(true);
			}
		},

		/**
		 * 입력란의 초기값 설정
		 */
		fnInitInputFields: function(){		//수입결의 완료
			//수입작성일
			detailForm.setValue('IN_DATE', UniDate.get('today'));
			
			//수입작성자
			detailForm.setValue('DRAFTER_PN',gsDrafter);
			detailForm.setValue('DRAFTER_NM',gsDrafterNm);
			
			//계좌입금일
			detailForm.setValue('SLIP_DATE', UniDate.get('today'));
			detailForm.setValue('EX_NUM','');
			
			//비밀번호
			detailForm.setValue('PASSWORD','');	
			
			//수입결의번호
			detailForm.setValue('IN_DRAFT_NO','');
			
			//예산부서
			detailForm.setValue('DEPT_CODE',gsDeptCode);
			detailForm.setValue('DEPT_NAME',gsDeptName);
			
			//사업장
			detailForm.setValue('DIV_CODE', gsDivCode);
			
			//회계구분
			detailForm.setValue('ACCNT_GUBUN', gsAccntGubun);
			
			//수입건명
			detailForm.setValue('TITLE','');	
			
			//상태(미상신)
			detailForm.getField('STATUS').setValue('0');
			
			//내용
			detailForm.setValue('TITLE_DESC','');
		
			//수입액 합계
			Ext.getCmp('bbarDetailGridBbar').setValue('');
			
			//상태
			detailForm.setValue('HDD_STATUS','0');
			
			//최초입력자
			detailForm.setValue('HDD_INSERT_DB_USER','');
			
			//저장유형
			detailForm.setValue('HDD_SAVE_TYPE','N');
			
			//복사자료
			detailForm.setValue('HDD_COPY_DATA','');
		},
		
		/**
		 * 수입결의 마스터정보 표시
		 */
		fnDispMasterData:function(qryType){		//수입결의 완료
			if(qryType == 'COPY'){
				//수입작성일
				detailForm.setValue('IN_DATE',UniDate.get('today'));
				
				//수입작성자
				detailForm.setValue('DRAFTER_PN',gsDrafter);
				detailForm.setValue('DRAFTER_NM',gsDrafterNm);
				
				//계좌입금일
				detailForm.setValue('SLIP_DATE',UniDate.get('today'));
				detailForm.setValue('EX_NUM','');
				
				//수입결의번호
				detailForm.setValue('IN_DRAFT_NO','');
				
				//상태
				detailForm.getField('STATUS').setValue('0');
			
				//상태
				detailForm.setValue('HDD_STATUS','0');
		
				//최초입력자
				detailForm.setValue('HDD_INSERT_DB_USER','');
				
				//저장유형
				detailForm.setValue('HDD_SAVE_TYPE','N');
				
				//복사자료
				detailForm.setValue('HDD_COPY_DATA','Y');
				

			}else if(qryType == 'QUERY'){
				if(directMasterStore.getCount() == 0){
					
					
					//수입작성일
					detailForm.setValue('IN_DATE','');
					
					//수입결의자
					detailForm.setValue('DRAFTER_PN','');
					detailForm.setValue('DRAFTER_NM','');
					
					//계좌입금일
					detailForm.setValue('SLIP_DATE','');
					detailForm.setValue('EX_NUM','');
					
					//예산부서
					detailForm.setValue('DEPT_CODE','');
					detailForm.setValue('DEPT_NAME','');
					
					//사업장
					detailForm.setValue('DIV_CODE','');
					
					//회계구분
					detailForm.setValue('ACCNT_GUBUN','');
					
					//수입건명
					detailForm.setValue('TITLE','');

					//상태
					detailForm.getField('STATUS').setValue('0');
					
					//내용
					detailForm.setValue('TITLE_DESC','');

					//수입액 합계
					Ext.getCmp('bbarDetailGridBbar').setValue(0);
					
					//상태
					detailForm.setValue('HDD_STATUS','0');
					
					//최초입력자
					detailForm.setValue('HDD_INSERT_DB_USER','');
					
					//저장유형
					detailForm.setValue('HDD_SAVE_TYPE','N');
					
					//복사자료
					detailForm.setValue('HDD_COPY_DATA','');
					
					Ext.Msg.alert(Msg.sMB099,Msg.sMB025);
					
					return false;
				}else{
//					,,,,,
					var masterRecord = directMasterStore.data.items[0];
					
					//수입작성일
					detailForm.setValue('IN_DATE',masterRecord.data.IN_DATE);
					
					//계좌입금일
					detailForm.setValue('SLIP_DATE',masterRecord.data.SLIP_DATE);
					detailForm.setValue('EX_NUM',masterRecord.data.EX_NUM);
					
					//수입결의번호
					detailForm.setValue('IN_DRAFT_NO',masterRecord.data.IN_DRAFT_NO);
					
					//상태
					detailForm.getField('STATUS').setValue(masterRecord.data.STATUS);
					
					//수입결의자
					detailForm.setValue('DRAFTER_PN',masterRecord.data.DRAFTER);
					detailForm.setValue('DRAFTER_NM',masterRecord.data.DRAFTER_NM);
								
					//예산부서
					detailForm.setValue('DEPT_CODE',masterRecord.data.DEPT_CODE);
					detailForm.setValue('DEPT_NAME',masterRecord.data.DEPT_NAME);
					
					//사업장
					detailForm.setValue('DIV_CODE',masterRecord.data.DIV_CODE);
	
					//회계구분
					detailForm.setValue('ACCNT_GUBUN',masterRecord.data.ACCNT_GUBUN);
					
					//수입건명
					detailForm.setValue('TITLE',masterRecord.data.TITLE);
					
					//내용
					detailForm.setValue('TITLE_DESC',masterRecord.data.TITLE_DESC);
					
					//수입액 합계
					Ext.getCmp('bbarDetailGridBbar').setValue(masterRecord.data.TOT_AMT_I);
					
					
					//상태
					detailForm.setValue('HDD_STATUS',masterRecord.data.STATUS);
										
					//최초입력자
					detailForm.setValue('HDD_INSERT_DB_USER',masterRecord.data.INSERT_DB_USER);
					
					//저장유형
					detailForm.setValue('HDD_SAVE_TYPE','');
					
					//복사자료
					detailForm.setValue('HDD_COPY_DATA','');	
				}
			}			
		},
		/**
		 * 프리폼 입력제어 처리
		 */
		fnMasterDisable:function(bBool){		//수입결의 완료
			var bExcept;
			
			bExcept = false;
			
			//조건1) 자동기표 되었거나 상신되었으면 입력란의 수정불가
			if(detailForm.getValue('EX_NUM') != '' || Ext.getCmp('rdoStatus').getValue().STATUS != '0'){
				bBool = true;
			}
			
			//조건2) 등록된 수정자이며 "반려"가 아니라면 입력란의 수정가능
			if(gsAmender == 'Y' && Ext.getCmp('rdoStatus').getValue().STATUS != '5'){
				if(bBool == true){
					bExcept = true;
					bBool = false;
				}
			}
			
			//수입작성일
			detailForm.getField('IN_DATE').setReadOnly(bBool);
			
			//수입결의자
			if(gsIdMapping == 'Y'){
				detailForm.getField('DRAFTER_PN').setReadOnly(true);	
				detailForm.getField('DRAFTER_NM').setReadOnly(true);	
			}else{
				detailForm.getField('DRAFTER_PN').setReadOnly(bBool);	
				detailForm.getField('DRAFTER_NM').setReadOnly(bBool);		
			}
			
			//계좌입금일
			detailForm.getField('SLIP_DATE').setReadOnly(bBool);
			
			//예산부서
			detailForm.getField('DEPT_CODE').setReadOnly(bBool);	
			detailForm.getField('DEPT_NAME').setReadOnly(bBool);	
			
			//사업장
			detailForm.getField('DIV_CODE').setReadOnly(bBool);
			
			//회계구분
			detailForm.getField('ACCNT_GUBUN').setReadOnly(bBool);
			
			//수입건명
			detailForm.getField('TITLE').setReadOnly(bBool);
			
			//내용
			detailForm.getField('TITLE_DESC').setReadOnly(bBool);
			
			//입금내역참조 탭(버튼)
			Ext.getCmp('depositBtn').setDisabled(bBool);
			
			if(bBool == true){
				UniAppManager.setToolbarButtons(['newData','delete','deleteAll'],false);
			}else{
				UniAppManager.setToolbarButtons(['newData'],true);	
				if(directMasterStore.getCount() > 0 && bExcept == false){
					UniAppManager.setToolbarButtons(['delete','deleteAll'],true);		
				}else{
					UniAppManager.setToolbarButtons('delete',true);		
					UniAppManager.setToolbarButtons('deleteAll',false);
				}
			}
			
			//자동기표조회, 출력버튼: 자동기표 되었으면 활성화
			
			if(detailForm.getValue('EX_NUM') == ''){
				Ext.getCmp('btnLinkSlip').setDisabled(true);
//				Ext.getCmp('출력버튼').setDisabled(true);	출력버튼 관련 pdf로
			}else{
				Ext.getCmp('btnLinkSlip').setDisabled(false);
//				Ext.getCmp('출력버튼').setDisabled(false);	출력버튼 관련 pdf로
			}
			
			//결제상신/수입결의자동기표 버튼 : 자동기표 되었으면(그룹웨어 연동 아닐때) 자동기표취소로 활성
			if(detailForm.getValue('EX_NUM') != '' && gsLinkedGW == 'N'){
				Ext.getCmp('btnProc').setDisabled(false);
				detailForm.down('#btnProc').setText(Msg.fSbMsgA0049);		
			}else if(detailForm.getValue('EX_NUM') == '' && gsLinkedGW == 'N'){
				Ext.getCmp('btnProc').setDisabled(false);
				detailForm.down('#btnProc').setText(Msg.fSbMsgA0457);	
			}else if(Ext.getCmp('rdoStatus').getValue().STATUS != '0'){
				Ext.getCmp('btnProc').setDisabled(true);		
			}else{
				Ext.getCmp('btnProc').setDisabled(bBool);
			}
			
			//재기표 버튼 : 등록된 수정자이며 상태가 반려가 아니면 활성
			if(gsAmender == 'Y' && Ext.getCmp('rdoStatus').getValue().STATUS != '5'){
				Ext.getCmp('btnReAuto').setDisabled(false);	
			}else{
				Ext.getCmp('btnReAuto').setDisabled(true);		
			}
		},
		/**
		 *  "사업장", "부서" 변경 시, 수입결의디테일에도 반영
		 */
		fnApplyToDetail: function(){	//수입결의 완료
			var records = directDetailStore.data.items;
			
			Ext.each(records, function(record, i){
				record.set('DEPT_CODE',detailForm.getValue('DEPT_CODE'));
				record.set('DEPT_NAME',detailForm.getValue('DEPT_NAME'));
				record.set('DIV_CODE',detailForm.getValue('DIV_CODE'));
			});
		},
		/**
		 * 결제상신 관련
		 */
		fnApproval: function(){
			Ext.Msg.alert("버튼이 결재상신 일때","빌드중(추후개발예정)");
		},
		/**
		 * 자동기표취소
		 */
		fnCancSlip: function(){		//수입결의 완료
			var param= Ext.getCmp('detailForm').getValues();
			cancSlipStore.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						detailForm.setValue('EX_NUM',records[0].data.EX_NUM);
						detailForm.setValue('HDD_STATUS',records[0].data.STATUS);
						
						detailForm.getField('STATUS').setValue(records[0].data.STATUS);
						
						UniAppManager.app.fnMasterDisable(false);
						Ext.Msg.alert(Msg.sMB099,Msg.sMA0329);	
					}else{
						return false;
					}
				}
			});
		},
		/**
		 * 수입결의자동기표
		 */
		fnAutoSlip: function(){		//수입결의 완료
			var param= Ext.getCmp('detailForm').getValues();
			autoSlipStore.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						detailForm.setValue('EX_NUM',records[0].data.EX_NUM);
						detailForm.setValue('HDD_STATUS',records[0].data.STATUS);
						
						detailForm.getField('STATUS').setValue(records[0].data.STATUS);
						
						UniAppManager.app.fnMasterDisable(true);
						Ext.Msg.alert(Msg.sMB099,Msg.sMA0328);	
					}else{
						return false;
					}
				}
			});
		},
		/**
		 * 자동기표조회 링크 관련
		 */
		fnOpenSlip: function(){		//수입결의 완료
			if(detailForm.getValue('EX_NUM') == ''){
				return false;	
			}
			var params = {
//				action:'select', 
				'PGM_ID' : 'afb800ukr',
				'SLIP_DATE' : detailForm.getValue('SLIP_DATE'),
				'INPUT_PATH' : '79',
				'EX_NUM' : detailForm.getValue('EX_NUM'),
				'iRcvSlipSeq' : '1',	//?
				'AP_STS' : '',
				'DIV_CODE' : detailForm.getValue('DIV_CODE')
			}
	  		var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj105ukr.do', params);
			
		},
		/**
		 * 재기표 관련
		 */
		fnReAuto: function(){	//수입결의 완료
			var param= Ext.getCmp('detailForm').getValues();
			reAutoStore.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						detailForm.setValue('EX_NUM',records[0].data.EX_NUM);
						detailForm.setValue('HDD_STATUS',records[0].data.STATUS);
						
						detailForm.getField('STATUS').setValue(records[0].data.STATUS);
						
						UniAppManager.app.fnMasterDisable(true);
						Ext.Msg.alert(Msg.sMB099,Msg.sMA0328);	
					}else{
						return false;
					}
				}
			});
		},

		/**
		 * 일괄적용 버튼 관련
		 */
		fnAllApplybtn: function(){	//수입결의 완료
			
			var detailRecords = directDetailStore.data.items;
			
			Ext.each(detailRecords, function(record, i){
				if(Ext.isEmpty(record.get('BUDG_CODE'))){
					record.set('BUDG_CODE'		,subForm.getValue('BUDG_CODE'));
					record.set('BUDG_NAME'		,subForm.getValue('BUDG_NAME'));

				}	
				if(Ext.isEmpty(record.get('ACCNT'))){
					record.set('ACCNT'			,subForm.getValue('HDD_ACCNT_CODE'));
					record.set('ACCNT_NAME'		,subForm.getValue('HDD_ACCNT_NAME'));
				}	
				
				if(Ext.isEmpty(record.get('PJT_CODE'))){
					record.set('PJT_CODE'		,subForm.getValue('HDD_PJT_CODE'));
					record.set('PJT_NAME'		,subForm.getValue('HDD_PJT_NAME'));
				}	
				
				if(Ext.isEmpty(record.get('SAVE_CODE'))){
					record.set('SAVE_CODE'		,subForm.getValue('HDD_SAVE_CODE'));
					record.set('SAVE_NAME'		,subForm.getValue('HDD_SAVE_NAME'));
					record.set('BANK_ACCOUNT'	,subForm.getValue('HDD_BANK_ACCOUNT'));
					record.set('BANK_NAME'		,subForm.getValue('HDD_BANK_NAME'));
				}	
				
			});
		},
		/**
		 * 예산사용가능금액 관련
		 */
		fnGetBudgPossAmt: function(applyRecord){
			
			var param = {"BUDG_YYYYMM": UniDate.getDbDateStr(detailForm.getValue('IN_DATE')).substring(0, 6),
						"DEPT_CODE": detailForm.getValue('DEPT_CODE'),
						"BUDG_CODE": applyRecord.get('BUDG_CODE'),
						"BUDG_GUBUN": '1'
						};
			accntCommonService.fnGetBudgetPossAmt(param, function(provider, response)	{
				
				if(!Ext.isEmpty(provider)){
					
					applyRecord.set('BUDG_POSS_AMT', provider.BUDG_POSS_AMT);
				}else{
					applyRecord.set('BUDG_POSS_AMT', 0);
					
				}
			});
			
			
		},

		/**
		 * 선택된 증빙구분에 따라 증빙유형,계산서일,전자계산서발행 기본값설정, 필수입력컬럼 설정
		 */
		fnSetPropertiesbyProofKind: function(applyRecord, newValue){	//수입결의 완료
			var sProofDivi = '';
			
			sProofDivi = newValue;
			
			var param = {
				ADD_QUERY1: "ISNULL(REF_CODE1,'') REF_CODE1, " +
							"ISNULL(REF_CODE3,'') REF_CODE3",
				ADD_QUERY2: '',
				MAIN_CODE: 'A184',
				SUB_CODE: sProofDivi
			}
			accntCommonService.fnGetRefCodes(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					applyRecord.set('PROOF_KIND'	,provider.REF_CODE1);
					applyRecord.set('CUSTOM_ESS'	,provider.REF_CODE3);
					
					UniAppManager.app.fnSetEssBillRemarkField(provider); //계산서적요 필수입력여부 설정
				
					UniAppManager.app.fnSetEssCustomField(provider); //거래처 필수입력여부 설정
				}
			});
		},

		/**
		 * 거래처 필수입력여부 설정
		 */
		fnSetEssBillRemarkField: function(provider){		//수입결의 완료
			if(provider.REF_CODE1 == ''){
				detailGrid.getColumn('BILL_DATE').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
				detailGrid.getColumn('BILL_REMARK').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			}else{
				detailGrid.getColumn('BILL_DATE').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
				detailGrid.getColumn('BILL_REMARK').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
			}
		},
		/**
		 * 거래처 필수입력여부 설정
		 */
		fnSetEssCustomField: function(provider){		//수입결의 완료
			if(provider.REF_CODE3 != 'Y'){
				detailGrid.getColumn('CUSTOM_CODE').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
				detailGrid.getColumn('CUSTOM_NAME').setConfig('tdCls','x-change-cell_Background_optRow');  //필수 관련 추후 수정필요
			}else{
				detailGrid.getColumn('CUSTOM_CODE').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
				detailGrid.getColumn('CUSTOM_NAME').setConfig('tdCls','x-change-cell_Background_essRow');  //필수 관련 추후 수정필요
			}
		},

		
		/**
		 * 증빙유형 or 수입액 변경 시, 세액 계산
		 */
		fnCalcTaxAmt: function(applyRecord, inAmtINewValue){	//수입결의 완료
			var dIn_Amt_I = 0;
			var dTaxRate = 0;
			var dSupply_Amt_I = 0;
			var dTax_Amt_I = 0;
			
			
			if(Ext.isEmpty(inAmtINewValue)){
				dIn_Amt_I = applyRecord.get('IN_AMT_I');
			}else{
				dIn_Amt_I = inAmtINewValue;
			}
						
			if(applyRecord.get('PROOF_KIND') == ''){
				dTaxRate = 0;
			}else{
				
				var param = {"PROOF_KIND": applyRecord.get('PROOF_KIND')}
				accntCommonService.fnGetTaxRate(param, function(provider, response){
					dTaxRate = provider.TAX_RATE;
					dTaxRate = dTaxRate / 100;
					
					dSupply_Amt_I = UniAccnt.fnAmtWonCalc(dIn_Amt_I / (1+dTaxRate), gsAmtPoint);  
					
					dTax_Amt_I = dIn_Amt_I - dSupply_Amt_I;
					
					applyRecord.set('IN_TAX_I'	,dTax_Amt_I);
				});
			}
		},
	
		/**
		 * 화면 하단의 "수입액 합계" 계산
		 */
		fnDispTotAmt: function(oldValue, newValue){	//수입결의 미완료
			var dIN_AMT_I = 0;
			var dTotAmtI	= 0;
			
			var records = directDetailStore.data.items;
			Ext.each(records, function(record, i){
				dIN_AMT_I = record.get('IN_AMT_I');
				dTotAmtI     = dTotAmtI + dIN_AMT_I; 
			});
			
			dTotAmtI = dTotAmtI - oldValue + newValue;
			
			Ext.getCmp('bbarDetailGridBbar').setValue(dTotAmtI);
		}
		

	});
	
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PROOF_DIVI" :
					UniAppManager.app.fnSetPropertiesbyProofKind(record, newValue);
					
					inAmtINewValue = '';
					UniAppManager.app.fnCalcTaxAmt(record, inAmtINewValue);
					break;
					
				case "IN_AMT_I" :
					inAmtINewValue = newValue;
					UniAppManager.app.fnCalcTaxAmt(record, inAmtINewValue);
					
					UniAppManager.app.fnDispTotAmt(oldValue, newValue);
					break;
		
			}
			return rv;
		}
	});	
	
	Unilite.createValidator('validator02', {
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case fieldName:
					UniAppManager.setToolbarButtons('save',true);
					break;
			}
			return rv;
		}
	});
};
</script>
