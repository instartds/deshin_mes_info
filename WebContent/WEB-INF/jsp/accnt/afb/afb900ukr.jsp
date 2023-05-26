<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb900ukr"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="afb900ukr"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A180" /> <!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A172" /> <!-- 결제방법 -->
	<t:ExtComboStore comboType="AU" comboCode="A210" /> <!-- 지급처코드 -->
	
	
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

var referFundingTargetWindow;	//이체대상참조

var useColList1 = ${useColList1};
var useColList2 = ${useColList2};

var gsBranchUse   = '${gsBranchUse}';
var gsBranchName  = '${gsBranchName}';


var checkedCount = 0; 

var list = [];
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/



function appMain() {
	var gsModelName = ${gsModelName};
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb900ukrService.selectDetailList',
			update: 'afb900ukrService.updateDetail',
			create: 'afb900ukrService.insertDetail',
			destroy: 'afb900ukrService.deleteDetail',
			syncAll: 'afb900ukrService.saveAll'
		}
	});	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
//			read: 'afb900ukrService.selectSendBranch',
//			update: 'afb900ukrService.updateSendBranch',
			create: 'afb900ukrService.insertSendBranch',
//			destroy: 'afb900ukrService.deleteSendBranch',
			syncAll: 'afb900ukrService.sendBranch'
		}
	});	
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Afb900ukrModel', {
	    fields: [
	    	{name: 'SEQ'				         ,text: '순번' 				,type: 'uniNumber'},
//	    	{name: 'CHOICE'				         ,text: '선택' 				,type: 'boolean'},
//	    	{name: 'CHOICE_FLAG'				 ,text: '선택_FLAG' 			,type: 'string'},
	    	{name: 'COMP_CODE'			         ,text: '법인코드' 			,type: 'string'},
	    	{name: 'CMS_TRANS_YN'		         ,text: '전송여부' 			,type: 'string'},
	    	{name: 'INPUT_GUBUN'		         ,text: '구분' 				,type: 'string',comboType:'AU', comboCode:'A180'},
	    	{name: 'AMT_GUBUN'			         ,text: '금액구분' 			,type: 'string'},
	    	{name: 'TRANS_DATE'			         ,text: '자금이체일' 			,type: 'uniDate',allowBlank:false},
	    	{name: 'PAY_DATE'			         ,text: '지출작성일' 			,type: 'uniDate'},
	    	{name: 'APP_DATE'			         ,text: '결재완결일' 			,type: 'uniDate'},
	    	{name: 'PROV_DRAFT_NO'               ,text: '지출결의번호' 			,type: 'string'},
	    	{name: 'PROV_DRAFT_SEQ'              ,text: '지출순번' 			,type: 'uniNumber'},
	    	{name: 'OUT_SAVE_CODE'               ,text: '출금통장코드' 			,type: 'string',allowBlank:false},
	    	{name: 'OUT_SAVE_NAME'               ,text: '출금통장명' 			,type: 'string',allowBlank:false},
	    	{name: 'OUT_BANKBOOK_NUM'            ,text: '출금계좌' 			,type: 'string'},
	    	{name: 'OUT_BANK_CODE'               ,text: '출금은행' 			,type: 'string'},
	    	{name: 'REMARK'				         ,text: '지출건명/적요' 		,type: 'string',allowBlank:false},
	    	{name: 'PJT_CODE'			         ,text: '프로젝트' 			,type: 'string'},
	    	{name: 'PJT_NAME'			         ,text: '프로젝트명' 			,type: 'string'},
	    	{name: 'TOT_AMT_I_USE_SUMMARY'		 , text: '금액'				, type: 'uniPrice'},
	    	{name: 'PROV_AMT_I'			         ,text: '총금액' 				,type: 'uniPrice'},
	    	{name: 'PEND_CODE'			         ,text: '지급처구분' 			,type: 'string',comboType:'AU', comboCode:'A210'},
	    	{name: 'PAY_CUSTOM_CODE'	         ,text: '지급처코드' 			,type: 'string'},
	    	{name: 'PAY_CUSTOM_NAME'	         ,text: '지급처명' 			,type: 'string'},
	    	{name: 'CUSTOM_CODE'		         ,text: '거래처코드' 			,type: 'string'},
	    	{name: 'CUSTOM_NAME'		         ,text: '거래처명' 			,type: 'string'},
	    	{name: 'IN_SAVE_CODE'		         ,text: '입금통장코드' 			,type: 'string'/*,allowBlank:false*/},
	    	{name: 'IN_SAVE_NAME'		         ,text: '입금통장명' 			,type: 'string'},
	    	{name: 'IN_BANK_CODE'		         ,text: '입금은행코드' 			,type: 'string'},
	    	{name: 'IN_BANK_NAME'		         ,text: '입금은행' 			,type: 'string'},
	    	{name: 'IN_BANKBOOK_NUM'             ,text: '입금계좌' 			,type: 'string'},
	    	{name: 'IN_BANKBOOK_NAME'            ,text: '예금주명' 			,type: 'string'},
	    	{name: 'REMARK_DTL'			         ,text: '상세적요' 			,type: 'string'},
	    	{name: 'TOT_AMT_I'			         ,text: '지급액' 				,type: 'uniPrice',allowBlank:false},
	    	{name: 'INC_AMT_I'			         ,text: '소득세' 				,type: 'uniPrice'},
	    	{name: 'LOC_AMT_I'			         ,text: '주민세' 				,type: 'uniPrice'},
	    	{name: 'REAL_AMT_I'			         ,text: '실지급액' 			,type: 'uniPrice'},
	    	{name: 'TRANS_SEQ'			         ,text: '이체순번' 			,type: 'uniNumber'},
	    	{name: 'EX_DATE'			         ,text: '결의일자' 			,type: 'uniDate'},
	    	{name: 'EX_NUM'				         ,text: '번호' 				,type: 'uniNumber'},
	    	{name: 'TRANS_FEE'			         ,text: '이체수수료' 			,type: 'uniPrice'},
	    	{name: 'TRANS_ID'			         ,text: '이체전송ID' 			,type: 'string'},
	    	{name: 'TRANS_STATE_NUM'	         ,text: '이체전문번호' 			,type: 'string'},
	    	{name: 'TRANS_RESULT_YN'	         ,text: '이체결과받기' 			,type: 'string'},
	    	{name: 'TRANS_RESULT_MSG'	         ,text: '결과메세지' 			,type: 'string'},
	    	{name: 'PAY_DIVI'			         ,text: '결제방법' 			,type: 'string',comboType:'AU', comboCode:'A172'},
	    	{name: 'DIV_CODE'			         ,text: '귀속사업장' 			,type: 'string'},
	    	{name: 'DEPT_CODE'			         ,text: '귀속부서' 			,type: 'string'},
	    	{name: 'DEPT_NAME'			         ,text: '귀속부서명' 			,type: 'string'},
	    	{name: 'REFER_NUM'			         ,text: 'REFER_NUM' 		,type: 'string'},
	    	{name: 'PAY_TOT'			         ,text: '지급총액' 			,type: 'uniPrice'},
	    	{name: 'INC_TOT'			         ,text: '소득세총액' 			,type: 'uniPrice'},
	    	{name: 'LOC_TOT'			         ,text: '주민세총액' 			,type: 'uniPrice'},
	    	{name: 'REAL_TOT'			         ,text: '실지급액합계' 			,type: 'uniPrice'},
	    	{name: 'INSERT_DB_USER'		         ,text: 'INSERT_DB_USER' 	,type: 'string'},
	    	{name: 'INSERT_DB_TIME'		         ,text: 'INSERT_DB_TIME' 	,type: 'string'},
	    	{name: 'UPDATE_DB_USER'		         ,text: 'UPDATE_DB_USER' 	,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'		         ,text: 'UPDATE_DB_TIME' 	,type: 'string'}
	    	
	    	
		]
	});
/*	
	*//**
	 *   BranchStore Model 정의 
	 * @type 
	 *//*

	Unilite.defineModel('BranchStoreModel', {
	    fields: [
	    	{name: 'TRANS_SEQ'			         ,text: '이체순번' 			,type: 'uniNumber'},
	    	{name: 'INPUT_GUBUN'		         ,text: '구분' 				,type: 'string',comboType:'AU', comboCode:'A180'},
	    	{name: 'AMT_GUBUN'			         ,text: '금액구분' 			,type: 'string'},
	    	{name: 'TRANS_DATE'			         ,text: '자금이체일' 			,type: 'uniDate',allowBlank:false},
	    	{name: 'PROV_DRAFT_NO'               ,text: '지출결의번호' 			,type: 'string'},
	    	{name: 'PROV_DRAFT_SEQ'              ,text: '지출순번' 			,type: 'uniNumber'}
	    	
		]
	});*/
	
	Unilite.defineModel('afb900ukrRefModel', {	//이체대상참조 
	    fields: [
			{name: 'SEQ'				          ,text: '순번' 				,type: 'uniNumber'},
//			{name: 'CHOICE'				          ,text: '선택' 				,type: 'string'},
			{name: 'PROV_DRAFT_NO'		          ,text: '지출결의번호' 		,type: 'string'},
			{name: 'PROV_DRAFT_SEQ'		          ,text: '지출순번' 			,type: 'uniNumber'},
			{name: 'AMT_GUBUN'			          ,text: 'GUBUN' 			,type: 'string'},
			{name: 'PAY_DATE'			          ,text: '지출작성일' 			,type: 'uniDate'},
			{name: 'APP_DATE'			          ,text: '결재완결일' 			,type: 'uniDate'},
			{name: 'TITLE'				          ,text: '지출건명' 			,type: 'string'},
			{name: 'PJT_CODE'			          ,text: '프로젝트' 			,type: 'string'},
			{name: 'PJT_NAME'			          ,text: '프로젝트명' 			,type: 'string'},
			{name: 'PROV_AMT_I'			          ,text: '총금액' 			,type: 'uniPrice'},
			{name: 'PAY_DIVI'			          ,text: '결제방법' 			,type: 'string'},
			{name: 'PAY_DIVI_NAME'		          ,text: '결제방법' 			,type: 'string'},
			{name: 'TOT_AMT_I_USE_SUMMARY'		 , text: '금액'				, type: 'uniPrice'},
			{name: 'TOT_AMT_I'			          ,text: '지급액' 			,type: 'uniPrice'},
			{name: 'LOC_AMT_I'			          ,text: '소득세' 			,type: 'uniPrice'},
			{name: 'INC_AMT_I'			          ,text: '주민세' 			,type: 'uniPrice'},
			{name: 'REAL_AMT_I'			          ,text: '실지급액' 			,type: 'uniPrice'},
			{name: 'PEND_CODE'			          ,text: '지급처구분' 			,type: 'string'},
			{name: 'PAY_CUSTOM_CODE'	          ,text: '지급처코드' 			,type: 'string'},
			{name: 'PAY_CUSTOM_NAME'	          ,text: '지급처명' 			,type: 'string'},
			{name: 'CUSTOM_CODE'		          ,text: '거래처코드' 			,type: 'string'},
			{name: 'CUSTOM_NAME'		          ,text: '거래처명' 			,type: 'string'},
			{name: 'IN_SAVE_CODE'		          ,text: '입금통장코드' 		,type: 'string'},
			{name: 'IN_SAVE_NAME'		          ,text: '입금통장명' 			,type: 'string'},
			{name: 'IN_BANK_CODE'		          ,text: '입금은행코드' 		,type: 'string'},
			{name: 'IN_BANK_NAME'		          ,text: '입금은행' 			,type: 'string'},
			{name: 'IN_BANKBOOK_NUM'	          ,text: '입금계좌' 			,type: 'string'},
			{name: 'IN_BANKBOOK_NAME'	          ,text: '예금주명' 			,type: 'string'},
			{name: 'REMARK_DTL'			          ,text: '상세적요' 			,type: 'string'},
			{name: 'OUT_SAVE_CODE'		          ,text: '출금통장코드' 		,type: 'string'},
			{name: 'OUT_SAVE_NAME'		          ,text: '출금통장명' 			,type: 'string'},
			{name: 'OUT_BANKBOOK_NUM'	          ,text: '출금계좌' 			,type: 'string'},
			{name: 'OUT_BANK_CODE'		          ,text: '출금은행' 			,type: 'string'},
			{name: 'DIV_CODE'			          ,text: '귀속사업장' 			,type: 'string'},
			{name: 'DEPT_CODE'			          ,text: '귀속부서' 			,type: 'string'},
			{name: 'DEPT_NAME'			          ,text: '귀속부서명' 			,type: 'string'},
			{name: 'REFER_NUM'			          ,text: 'REFER_NUM' 		,type: 'string'}
	    ]
	    	
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('afb900ukrDetailStore', {
		model: 'Afb900ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
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
			var paramMaster= panelResult.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
				/*		var inoutNum = panelSearch.getValue('INOUT_NUM');
						Ext.each(list, function(record, index) {
							if(record.data['INOUT_NUM'] != inoutNum) {
								record.set('INOUT_NUM', inoutNum);
							}
						})*/
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
                var grid = Ext.getCmp('afb900ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
        
//           		store.getAt(store.length).get('PAY_TOT');
  /*         		if(!Ext.isEmpty(records)){
	           		Ext.getCmp('bbarPayTot').setValue(records[records.length -1].data.PAY_TOT);
	           		Ext.getCmp('bbarIncTot').setValue(records[records.length -1].data.INC_TOT);
	           		Ext.getCmp('bbarLocTot').setValue(records[records.length -1].data.LOC_TOT);
	           		Ext.getCmp('bbarRealTot').setValue(records[records.length -1].data.REAL_TOT);
           		}else{
           			Ext.getCmp('bbarPayTot').setValue(0);
	           		Ext.getCmp('bbarIncTot').setValue(0);
	           		Ext.getCmp('bbarLocTot').setValue(0);
	           		Ext.getCmp('bbarRealTot').setValue(0);	
           		}*/
           		
//           		subForm.down('#selectAll').setText(Msg.sMB091);
           		
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
			param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
			param.TO_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('TO_INPUT_DATE'));
			param.TITLE = panelSearch.getValue('TITLE');
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField:'PROV_DRAFT_NO'
	});
	var branchStore = Unilite.createStore('Afb900ukrBranchStore',{		//branch 관련
//		model: 'BranchStoreModel',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: directProxy2,
		
		branchSaveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
//			var toCreate = branchStore.data.items;
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
//       		var paramList = branchStore.data.items;
			var paramMaster = panelResult.getValues();	//syncAll 수정
//			param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						
					/*	panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		*/
						
						if(panelResult.getValue('BRANCH_OPR_FLAG') == 'B' || panelResult.getValue('BRANCH_OPR_FLAG') == 'C'){
							UniAppManager.updateStatus(Msg.fsbMsgB0076);
						}else if(panelResult.getValue('BRANCH_OPR_FLAG') == 'R'){
							UniAppManager.updateStatus(Msg.fSbMsgA0526);
						}
						
						panelResult.setValue('BRANCH_OPR_FLAG', '');
						UniAppManager.app.onQueryButtonDown();
					 },
					 failure: function(batch, option) {
					 	
					 	panelResult.setValue('BRANCH_OPR_FLAG', '');
					 
					 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('afb900ukrGrid');
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
	var fundingTargetStore = Unilite.createStore('afb900ukrRefStore', {//이체대상참조
		model: 'afb900ukrRefModel',
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
            	read: 'afb900ukrService.selectFundingTargetList'                	
            }
        },
        listeners:{
        	load:function(store, records, successful, eOpts)	{
        			if(successful)	{
        			   var masterRecords = directDetailStore.data.filterBy(directDetailStore.filterNewOnly);  
        			   var fundingTargetRecords = new Array();
        			   if(masterRecords.items.length > 0)	{
        			   		console.log("store.items :", store.items);
        			   		console.log("records", records);
        			   	
            			   	Ext.each(records, 
            			   		function(item, i)	{           			   								
		   							Ext.each(masterRecords.items, function(record, i)	{
		   								console.log("record :", record);
		   							
		   									if( (record.data['REFER_NUM'] == item.data['REFER_NUM']) 
		   									  ) 
		   									{
		   										fundingTargetRecords.push(item);
		   									}
		   							});		
            			   	});
            			   store.remove(fundingTargetRecords);
        			   }
        			}
        	}
        },
        loadStoreRecords : function()	{
			var param= fundingTargetSearch.getValues();	
			this.load({
				params : param
			});
		},
		groupField:'PROV_DRAFT_NO'
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
	    		fieldLabel: '자금이체일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'FR_DATE',
			    endFieldName: 'TO_DATE',
			    startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
			    allowBlank: false,                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('FR_DATE', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE', newValue);				    		
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
			Unilite.popup('BANK_BOOK',{
				fieldLabel: '출금계좌', 
				valueFieldWidth: 90,
				textFieldWidth: 140,
				valueFieldName:'OUT_SAVE_CODE',
			    textFieldName:'OUT_SAVE_NAME',
//				    validateBlank:'text',
			    listeners: {
			    	onValueFieldChange: function(field, newValue){
						panelResult.setValue('OUT_SAVE_CODE', newValue);	
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('OUT_SAVE_NAME', newValue);	
					}
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '기표여부',
				items: [{
					boxLabel: '전체', 
					width: 45,
					name: 'RDO_SLIP',
					inputValue: '',
					checked: true  
				},{
					boxLabel: '기표', 
					width: 60,
					name: 'RDO_SLIP',
					inputValue: 'Y'
				},{
					boxLabel: '미기표', 
					width: 60,
					name: 'RDO_SLIP',
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('RDO_SLIP').setValue(newValue.RDO_SLIP);					
//							UniAppManager.app.onQueryButtonDown();
					}
				}
			},{ 
	    		fieldLabel: '지출결의번호',
			    xtype: 'uniTextfield',
			    name: 'PAY_DRAFT_NO',
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_DRAFT_NO', newValue);
			      	}
				}
			},
		    Unilite.popup('AC_PROJECT',{ 
		    	fieldLabel: '프로젝트', 
		    	valueFieldName: 'PJT_CODE',
				textFieldName: 'PJT_NAME',
				listeners: {
			    	onValueFieldChange: function(field, newValue){
						panelResult.setValue('PJT_CODE', newValue);	
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PJT_NAME', newValue);	
					}
				}
			})]	
		},{
			title: '추가정보',	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{ 
	    		fieldLabel: '지출작성일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'FR_INPUT_DATE',
			    endFieldName: 'TO_INPUT_DATE'
			},{ 
	    		fieldLabel: '지출건명',
			    xtype: 'uniTextfield',
			    name: 'TITLE',
			    width: 325
			}]
		}]

	});
	var panelResult = Unilite.createSearchForm('resultForm',{
		
//		url: CPATH+'/accnt/sendBranchTest',
//		standardSubmit: true,
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3,
//		tableAttrs: { width: '100%'},
//        	trAttrs: {/*style: 'border : 1px solid #ced9e7;',align : 'center',*/width: '100%'},
        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',align : 'left',*/width: 500}
		
		},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
    		fieldLabel: '자금이체일',
    		labelWidth:150,
		    xtype: 'uniDateRangefield',
		    startFieldName: 'FR_DATE',
		    endFieldName: 'TO_DATE',
		    startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
//			tdAttrs: {width: 500},
		    allowBlank: false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE', newValue);				    		
		    	}
		    }
		},{
			fieldLabel: '사업장',
			labelWidth:150,
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        // value:UserInfo.divCode,
	        comboType:'BOR120',
//	        tdAttrs: {width: 500},
			width: 385,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
//			width:120,
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'right',width:'100%'},
			items :[{
				xtype:'component',
				html:'이체지급자동기표',
	    		id: 'btnLinkSlip',
	    		name: 'LINKSLIP',
	    		width: 110,	
	    		tdAttrs: {align : 'center'},
	    		componentCls : 'component-text_first',
				listeners:{
					render: function(component) {
		                component.getEl().on('click', function( event, el ) {
		                	UniAppManager.app.fnProcSlip();
		                });
		            }
				}
			}]
    	},
		Unilite.popup('BANK_BOOK',{
			fieldLabel: '출금계좌', 
			labelWidth:150,
			valueFieldWidth: 90,
			textFieldWidth: 140,
//			tdAttrs: {width: 500},
			valueFieldName:'OUT_SAVE_CODE',
		    textFieldName:'OUT_SAVE_NAME',
//				    validateBlank:'text',
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('OUT_SAVE_CODE', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('OUT_SAVE_NAME', newValue);	
				}
			}
		}),{
			xtype: 'radiogroup',		            		
			fieldLabel: '기표여부',
			labelWidth:150,
//			tdAttrs: {width: 500},
			colspan:2,
			items: [{
				boxLabel: '전체', 
				width: 60,
				name: 'RDO_SLIP',
				inputValue: '',
				checked: true  
			},{
				boxLabel: '기표', 
				width: 60,
				name: 'RDO_SLIP',
				inputValue: 'Y'
			},{
				boxLabel: '미기표', 
				width: 60,
				name: 'RDO_SLIP',
				inputValue: 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('RDO_SLIP').setValue(newValue.RDO_SLIP);					
//							UniAppManager.app.onQueryButtonDown();
				}
			}
		},{ 
    		fieldLabel: '지출결의번호',
    		labelWidth:150,
//    		tdAttrs: {width: 500},
		    xtype: 'uniTextfield',
		    name: 'PAY_DRAFT_NO',
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('PAY_DRAFT_NO', newValue);
		      	}
			}
		},
	    Unilite.popup('AC_PROJECT',{ 
	    	fieldLabel: '프로젝트', 
	    	labelWidth:150,
	    	valueFieldName: 'PJT_CODE',
			textFieldName: 'PJT_NAME',
//			tdAttrs: {width: 500},
			colspan:2,
			listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PJT_CODE', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('PJT_NAME', newValue);	
				}
			}
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			id:'branch',
			width:1000,
			colspan:3,
//			defaults : {width:500},
			items :[{
				xtype: 'radiogroup',		            		
				fieldLabel: '브랜치로 보내기',
				labelWidth:150,
//				tdAttrs: {width: 500},
				items: [{
					boxLabel: '전체', 
					width: 60,
					name: 'RDO_SEND',
					inputValue: ''
				},{
					boxLabel: '예', 
					width: 60,
					name: 'RDO_SEND',
					inputValue: 'Y'
				},{
					boxLabel: '아니오', 
					width: 60,
					name: 'RDO_SEND',
					inputValue: 'N',
					checked: true  
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
	//					panelSearch.getField('STATUS').setValue(newValue.STATUS);					
	//							UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '이체결과받기',
				labelWidth:192,
//				tdAttrs: {width: 500},
				items: [{
					boxLabel: '전체', 
					width: 60,
					name: 'RDO_RESULT',
					inputValue: '',
					checked: true  
				},{
					boxLabel: '예', 
					width: 60,
					name: 'RDO_RESULT',
					inputValue: 'Y'
				},{
					boxLabel: '아니오', 
					width: 60,
					name: 'RDO_RESULT',
					inputValue: 'N',
					listeners: {
						specialkey: function(field, event){
							if(event.getKey() == event.ENTER){
		//						UniAppManager.app.onQueryButtonDown();
								panelResult.getField('FR_DATE').focus();
								
							}
						}
					}
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
	//					panelSearch.getField('STATUS').setValue(newValue.STATUS);					
	//							UniAppManager.app.onQueryButtonDown();
					}
				}
			}]
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 9},
			id:'branchSend',
			padding: '0 0 5 0',
			width:1000,
			colspan:3,
			items :[{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:150,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'[Branch전송순서]',
					componentCls : 'component-text_second',
					tdAttrs: {align : 'right'},
		    		width: 150
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:150,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'수취인조회하기',
		    		id: 'linkBookNameSearch',
		    		name: 'LINK_BOOK_NAME_SEARCH',
		    		width: 150,	
		    		tdAttrs: {align : 'right'},
		    		componentCls : 'component-text_first',
					listeners:{
						render: function(component) {
			                component.getEl().on('click', function( event, el ) {
			                	UniAppManager.app.fnBookNameSearch();
//			                	Ext.Msg.alert("확인","개발중");
			                });
			            }
					}
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:30,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'→',
					componentCls : 'component-text_second',
		    		width: 30,
		    		tdAttrs: {align : 'center'}
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				width:300,
				tdAttrs: {align : 'center'},
				items :[{
		    		xtype: 'button',
		    		text: 'Branch로보내기',	
		    		id: 'btnSend',
		    		name: 'SEND',
		    		width: 150,	
		    		tdAttrs: {align : 'center'},
		    		hidden:false,
					handler : function() {
						if(directDetailStore.getCount() < 1){
							Ext.Msg.alert("확인",Msg.fSbMsgA0525);	
						}else {
							var selectedRecords = detailGrid.getSelectedRecords();
							if(selectedRecords.length < 1){
								Ext.Msg.alert("확인",Msg.sMA0256);		
							}else{
								if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
									Ext.Msg.show({
									     title:'확인',
									     msg: Msg.sMB017 + "\n" + Msg.sMB061,
									     buttons: Ext.Msg.YESNOCANCEL,
									     icon: Ext.Msg.QUESTION,
									     fn: function(res) {
									     	if (res === 'yes' ) {
												UniAppManager.app.onSaveDataButtonDown();
												
									     	} else if(res === 'no') {
									     		panelResult.setValue('BRANCH_OPR_FLAG','B');
												branchStore.clearData();
				//								branchStore.loadData(selectedRecords);
												Ext.each(selectedRecords, function(record,i){
				//									branchStore.add(record.data);
													record.phantom = true;
													branchStore.insert(i, record);
												});
												branchStore.branchSaveStore();
									     	}
									     }
									});
								} else {
									panelResult.setValue('BRANCH_OPR_FLAG','B');
									branchStore.clearData();
	//								branchStore.loadData(selectedRecords);
									Ext.each(selectedRecords, function(record,i){
	//									branchStore.add(record.data);
										record.phantom = true;
										branchStore.insert(i, record);
									});
									branchStore.branchSaveStore();
								}								
							}
						}
					}
		    	},{
		    		xtype: 'button',
		    		text: '건별 보내기',	
		    		id: 'btnSendby',
		    		name: 'SENDBY',
		    		width: 150,	
		    		tdAttrs: {align : 'center'},
		    		hidden:true,
					handler : function() {
						if(directDetailStore.getCount() < 1){
							Ext.Msg.alert("확인",Msg.fSbMsgA0525);	
						}else {
							var selectedRecords = detailGrid.getSelectedRecords();
							if(selectedRecords.length < 1){
								Ext.Msg.alert("확인",Msg.sMA0256);		
							}else{
								if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
									Ext.Msg.show({
									     title:'확인',
									     msg: Msg.sMB017 + "\n" + Msg.sMB061,
									     buttons: Ext.Msg.YESNOCANCEL,
									     icon: Ext.Msg.QUESTION,
									     fn: function(res) {
									     	if (res === 'yes' ) {
												UniAppManager.app.onSaveDataButtonDown();
												
									     	} else if(res === 'no') {
									     		panelResult.setValue('BRANCH_OPR_FLAG','C');
												branchStore.clearData();
				//								branchStore.loadData(selectedRecords);
												Ext.each(selectedRecords, function(record,i){
				//									branchStore.add(record.data);
													record.phantom = true;
													branchStore.insert(i, record);
												});
												branchStore.branchSaveStore();
									     	}
									     }
									});
								} else {
									panelResult.setValue('BRANCH_OPR_FLAG','C');
									branchStore.clearData();
	//								branchStore.loadData(selectedRecords);
									Ext.each(selectedRecords, function(record,i){
	//									branchStore.add(record.data);
										record.phantom = true;
										branchStore.insert(i, record);
									});
									branchStore.branchSaveStore();
								}								
							}
						}
					}
		    	}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:30,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'→',
					componentCls : 'component-text_second',
		    		width: 30,
		    		tdAttrs: {align : 'center'}
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:170,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'Branch시스템에서 이체하기',
					componentCls : 'component-text_second',
					tdAttrs: {align : 'center'},
		    		width: 170
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:30,
				tdAttrs: {align : 'center'},
				items :[{
					xtype:'component',
					html:'→',
					tdAttrs: {align : 'center'},
					componentCls : 'component-text_second',
		    		width: 30
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				width:150,
				tdAttrs: {align : 'center'},
				items :[{
		    		xtype: 'button',
		    		text: '이체결과받기',	
		    		id: 'btnSendResult',
		    		name: 'SEND_RESULT',
		    		width: 150,	
		    		tdAttrs: {align : 'center'},
//		    		hidden:true,
					handler : function() {
						if(directDetailStore.getCount() < 1){
							Ext.Msg.alert("확인",Msg.fSbMsgA0525);	
						}else {
							var selectedRecords = detailGrid.getSelectedRecords();
							if(selectedRecords.length < 1){
								Ext.Msg.alert("확인",Msg.sMA0256);		
							}else{
								if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
									Ext.Msg.show({
									     title:'확인',
									     msg: Msg.sMB017 + "\n" + Msg.sMB061,
									     buttons: Ext.Msg.YESNOCANCEL,
									     icon: Ext.Msg.QUESTION,
									     fn: function(res) {
									     	if (res === 'yes' ) {
												UniAppManager.app.onSaveDataButtonDown();
												
									     	} else if(res === 'no') {
									     		panelResult.setValue('BRANCH_OPR_FLAG','R');
												branchStore.clearData();
				//								branchStore.loadData(selectedRecords);
												Ext.each(selectedRecords, function(record,i){
				//									branchStore.add(record.data);
													record.phantom = true;
													branchStore.insert(i, record);
												});
												branchStore.branchSaveStore();
									     	}
									     }
									});
								} else {
									panelResult.setValue('BRANCH_OPR_FLAG','R');
									branchStore.clearData();
	//								branchStore.loadData(selectedRecords);
									Ext.each(selectedRecords, function(record,i){
	//									branchStore.add(record.data);
										record.phantom = true;
										branchStore.insert(i, record);
									});
									branchStore.branchSaveStore();
								}								
							}
						}
					}
				}]
	    	},{
	    		xtype:'uniTextfield',
	    		name:'BRANCH_OPR_FLAG',
	    		hidden:true
	    	}/*,{
			xtype: 'uniTextfield',
			name: 'dataDetail',
			hidden: true
		},{
			xtype: 'uniTextfield',
			name: 'dataMaster',
			hidden: true
		}*/
	    	
	    	]
	    }]
    });		
	
    var subForm = Unilite.createSimpleForm('resultForm2',{
    	region: 'north',
    	border:true,
	    items: [{	
	    	xtype:'container',
	    	padding:'5 5 5 0',
	        defaultType: 'uniTextfield',
	        layout: {
	        	type: 'uniTable',
	        	columns : 2
	        	//	        	tdAttrs:{width: '100%'}
//	        	tableAttrs: {align:'left'}
	        },
	        items: [{
	        	fieldLabel: '자금이체일',
	        	labelWidth:150,
	        	xtype: 'uniDatefield',
//	        	xtype: 'uniTextfield',
	        	name:'TRANS_DATE',
	        	value:UniDate.get('today'),
	        	allowBlank: false,
	        	width:280,
	        	tdAttrs: {width: 300},
	        	listeners: {
	        		/*uniOnChange: function(field, newValue, oldValue) {
	        			
	        			if(directDetailStore.getCount() == 0){
	        				return false;
	        			}else{
	        				if(UniDate.getDateStr(oldValue) != UniDate.getDateStr(newValue)){
								UniAppManager.app.fnApplyTransDate(UniDate.getDateStr(field.lastValue));
	        				}else{
	        					return false;	
	        				}
	        			}
	        			
	        		}*/
	/*        		blur: function(field, event, eOpts )	{
	        			
	        			if(directDetailStore.getCount() == 0){
	        				return;
	        			}else{
//	        				UniDate.getDateStr
	        				if(Ext.isEmpty(field.uniOpt.oldDate) || UniDate.getDateStr(field.uniOpt.oldDate) != UniDate.getDateStr(field.getValue())){
								UniAppManager.app.fnApplyTransDate(UniDate.getDateStr(field.getValue()));
	        				}
	        				
	        				field.uniOpt.oldDate = field.getValue();
	        				
	        			}
	        		}*/
				}
	        },{
	        	
				xtype: 'button',
				text: '일괄변경',
				width: 100,
				id: 'applyChange',
				tdAttrs: {align: 'right', width: 100},
				handler : function() {
					if(directDetailStore.getCount() == 0){
	        			return;
					}else{
						UniAppManager.app.fnApplyTransDate(UniDate.getDateStr(subForm.getValue('TRANS_DATE')));
	        		}
				}
	        
	        }/*,{
				xtype: 'button',
				text: '전체선택',
				width: 100,
				id: 'selectAll',
				tdAttrs: {align: 'right', width: 100},
				handler : function() {
					var records = directDetailStore.data.items;
					
					if(subForm.down('#selectAll').getText() == Msg.sMB091){
						Ext.each(records, function(record, i){
							record.set('CHOICE', true);
						})
						subForm.down('#selectAll').setText(Msg.sMB092);
					}else{
						Ext.each(records, function(record, i){
							record.set('CHOICE', false);
						})	
						subForm.down('#selectAll').setText(Msg.sMB091);
					}
				}
	        }*/]
	    }]
    });	 
    	
	/*var sumForm = Unilite.createSimpleForm('resultForm3',{
    	region: 'south',
    	border:true,
	    items: [{	
	    	xtype:'container',
	    	padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {
	        	type: 'uniTable',
	        	columns : 4,
	        	tableAttrs: {align:'right'}
	        },
	        items: [{
	        	fieldLabel: '지급총액',
	        	name:'',
	        	xtype: 'uniNumberfield',
	        	readOnly: true
	        },{
	       	 	fieldLabel: '소득세',
	       	 	name:'',
	       	 	xtype: 'uniNumberfield',
	        	readOnly: true
	        },{
	        	fieldLabel: '주민세',
	        	name:'',
	        	xtype: 'uniNumberfield',
	        	readOnly: true
	        },{
	       	 	fieldLabel: '실지급액',
	       	 	name:'',
	       	 	xtype: 'uniNumberfield',
	        	readOnly: true
	        }]
	    }]
    });	 */
        
    var fundingTargetSearch = Unilite.createSearchForm('fundingTargetForm', {//이체대상참조
		layout :  {type : 'uniTable', columns : 2},
    	items :[{ 
    		fieldLabel: '지출작성일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'FR_PAY_DATE',
		    endFieldName: 'TO_PAY_DATE',
		    startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    allowBlank: false
		},
		Unilite.popup('BANK_BOOK',{
			fieldLabel: '출금계좌', 
			valueFieldName:'SAVE_CODE',
		    textFieldName:'SAVE_NAME'
		}),
		Unilite.popup('DEPT',{
			fieldLabel: '예산부서', 
			valueFieldName:'DEPT_CODE',
		    textFieldName:'DEPT_NAME'
		}),
		{ 
    		fieldLabel: '지출건명',
		    xtype: 'uniTextfield',
		    name: 'TITLE',
		    width: 325
		},
	    Unilite.popup('AC_PROJECT',{ 
	    	fieldLabel: '프로젝트', 
	    	valueFieldName: 'PJT_CODE',
			textFieldName: 'PJT_NAME'
		})]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var detailGrid = Unilite.createGrid('afb900ukrGrid', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		excelTitle: '자금이체등록',
		tbar: [/*{
			xtype: 'button',
			id: 'btnViewSlip1',
			text: '엑셀서식저장',
        	handler: function() {
	        	var record = detailGrid.getSelectedRecord();
			    var params = {
					action:'select',
					'PGM_ID' : 'afb700skr',
					'AC_DATE' : record.data['EX_DATE'],
					'AC_DATE2' : record.data['EX_DATE'],
					'INPUT_PATH' : '80',
					'EX_NUM' : record.data['EX_NUM'],
					'EX_SEQ' : '1',
					'AP_STS' : '',
					'DIV_CODE' : record.data['DIV_CODE']
				}
//				var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
//				parent.openTab(rec1, '/accnt/agj105ukr.do', params);
	        }
    	},{
			xtype: 'button',
			id: 'btnViewSlip2',
			text: '이체지급자동기표',
        	handler: function() {
	        	var record = detailGrid.getSelectedRecord();
			    var params = {
					action:'select',
					'PGM_ID' : 'afb700skr',
					'AC_DATE' : record.data['EX_DATE'],
					'AC_DATE2' : record.data['EX_DATE'],
					'INPUT_PATH' : '80',
					'EX_NUM' : record.data['EX_NUM'],
					'EX_SEQ' : '1',
					'AP_STS' : '',
					'DIV_CODE' : record.data['DIV_CODE']
				}
//				var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
//				parent.openTab(rec1, '/accnt/agj105ukr.do', params);
	        }
    	},*/{
			itemId: 'fundingTargetBtn',
			text: '이체대상참조',
			handler: function() {
				openFundingTargetWindow();
			}
    	}],
		/*bbar: ['->',
        	{
        	fieldLabel:'지급총액',
        	labelAlign : 'right',
        	labelStyle: "color: blue;",
        	xtype:'uniNumberfield',
        	id:'bbarPayTot',
        	name:'PAY_TOT',
        	readOnly:true
		},{
        	fieldLabel:'소득세',
        	labelAlign : 'right',
        	labelStyle: "color: blue;",
        	xtype:'uniNumberfield',
        	id:'bbarIncTot',
        	name:'INC_TOT',
        	readOnly:true
		},{
        	fieldLabel:'주민세',
        	labelAlign : 'right',
        	labelStyle: "color: blue;",
        	xtype:'uniNumberfield',
        	id:'bbarLocTot',
        	name:'LOC_TOT',
        	readOnly:true
		},{
        	fieldLabel:'실지급액',
        	labelAlign : 'right',
        	labelStyle: "color: blue;",
        	xtype:'uniNumberfield',
        	id:'bbarRealTot',
        	name:'REAL_TOT',
        	readOnly:true
		}],*/
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			useRowContext	: true,
			onLoadSelectFirst: false,
    		state: {
				useState: true,			
				useStateList: true		
			}
        },
        uniRowContextMenu:{
			items: [
	            {	text: '지출결의등록 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb700ukr(param.record);
	            	}
	        	}
	        ]
	    },
		features: [{
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		store: directDetailStore,
		selModel :gsModelName, 
/*		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var sm = detailGrid.getSelectionModel();
					var selRecords = detailGrid.getSelectionModel().getSelection();
					var records = directDetailStore.data.items;
					Ext.each(records, function(record, index){
						if(selectRecord.get('PROV_DRAFT_NO') == record.get('PROV_DRAFT_NO')){
							selRecords.push(record);
						}
					});
					sm.select(selRecords);
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var sm = detailGrid.getSelectionModel();
					var selRecords = detailGrid.getSelectionModel().getSelection();
					var records = directDetailStore.data.items;
					Ext.each(records, function(record, index){
						if(selectRecord.get('PROV_DRAFT_NO') != record.get('PROV_DRAFT_NO')){
							selRecords.splice(0, 10000); 
						}
	  				});
					Ext.each(records, function(record, index){
						if(selectRecord.get('PROV_DRAFT_NO') == record.get('PROV_DRAFT_NO')){
							selRecords.push(record);
						}
					});
					sm.deselect(selRecords);
				}
			}
        }),*/
		
//		Ext.create('Ext.selection.CheckboxModel', { checkOnly : true }),
//		selModel : 'rowmodel',  
		columns: [        
        	{ dataIndex: 'SEQ'				         , 	width:55,align:'center'},        
        	/*{ dataIndex: 'CHOICE'				     , 	width:66, xtype: 'checkcolumn',align:'center',
        		listeners:{
        			beforecheckchange: function( CheckColumn, rowIndex, checked, eOpts ){
        				
        				
        			},
        			
        			
					checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
						
						var grdRecord = detailGrid.getStore().getAt(rowIndex);
//						var grdRecord = [];
						if(checked == true){
							directDetailStore.commitChanges();
							grdRecord.set('CHOICE_FLAG','Y');
							
							
//							list = [].concat(list, grdRecord);
        					checkedCount++;
        				}else if(checked == false){
        					
        					grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
        					checkedCount--;
        				}
						
						UniAppManager.setToolbarButtons('save', false);
					}
				}
        	},    
        	{ dataIndex: 'CHOICE_FLAG'			     , 	width:66, hidden:false},     */
        	
        	{ dataIndex: 'COMP_CODE'			     , 	width:66, hidden:true},        
        	{ dataIndex: 'CMS_TRANS_YN'		         , 	width:66, align:'center'},        
        	{ dataIndex: 'INPUT_GUBUN'		         , 	width:66},        
        	{ dataIndex: 'AMT_GUBUN'			     , 	width:66, hidden:true},        
        	{ dataIndex: 'TRANS_DATE'			     , 	width:80},        
        	{ dataIndex: 'PAY_DATE'			         , 	width:80},        
        	{ dataIndex: 'APP_DATE'			         , 	width:80},        
        	{ dataIndex: 'PROV_DRAFT_NO'             , 	width:100,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            	}
            },        
        	{ dataIndex: 'PROV_DRAFT_SEQ'            , 	width:60, hidden:true},        
        	{ dataIndex: 'OUT_SAVE_CODE'             , 	width:80, hidden:true},        
        	{ dataIndex: 'OUT_SAVE_NAME'             , 	width:146,
        		editor:Unilite.popup('BANK_BOOK_G', {
					autoPopup: true,
					textFieldName:'OUT_SAVE_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('OUT_SAVE_CODE', records[0].BANK_BOOK_CODE);
							grdRecord.set('OUT_SAVE_NAME', records[0].BANK_BOOK_NAME);
							grdRecord.set('OUT_BANKBOOK_NUM', records[0].DEPOSIT_NUM);
							grdRecord.set('OUT_BANK_CODE', records[0].BANK_CD);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('OUT_SAVE_CODE', '');
							grdRecord.set('OUT_SAVE_NAME', '');
							grdRecord.set('OUT_BANKBOOK_NUM', '');
							grdRecord.set('OUT_BANK_CODE', '');
						}
					}
				})
        	},        
        	{ dataIndex: 'OUT_BANKBOOK_NUM'          , 	width:120},        
        	{ dataIndex: 'OUT_BANK_CODE'             , 	width:80, hidden:true},        
        	{ dataIndex: 'REMARK'				     , 	width:200},        
        	{ dataIndex: 'PJT_CODE'			         , 	width:66, hidden:true},        
        	{ dataIndex: 'PJT_NAME'			         , 	width:100},  
        	{ dataIndex: 'TOT_AMT_I_USE_SUMMARY'	 , text: '금액', width: 100,summaryType: 'sum'},
        	{ dataIndex: 'PROV_AMT_I'			     , 	width:100, hidden:true},        
        	{ dataIndex: 'PEND_CODE'			     , 	width:80},        
        	{ dataIndex: 'PAY_CUSTOM_CODE'	         , 	width:80},        
        	{ dataIndex: 'PAY_CUSTOM_NAME'	         , 	width:93},        
        	{ dataIndex: 'CUSTOM_CODE'		         , 	width:80},        
        	{ dataIndex: 'CUSTOM_NAME'		         , 	width:120},        
        	{ dataIndex: 'IN_SAVE_CODE'		         , 	width:100,
        		editor:Unilite.popup('BANK_BOOK_G', {
					autoPopup: true,
					textFieldName:'IN_SAVE_NAME',
					DBtextFieldName: 'IN_SAVE_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('IN_SAVE_CODE', records[0].BANK_BOOK_CODE);
							grdRecord.set('IN_SAVE_NAME', records[0].BANK_BOOK_NAME);
							grdRecord.set('IN_BANKBOOK_NUM', records[0].DEPOSIT_NUM);
							grdRecord.set('IN_BANK_CODE', records[0].BANK_CD);
							grdRecord.set('IN_BANK_NAME', records[0].BANK_NM);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('IN_SAVE_CODE', '');
							grdRecord.set('IN_SAVE_NAME', '');
							grdRecord.set('IN_BANKBOOK_NUM', '');
							grdRecord.set('IN_BANK_CODE', '');
							grdRecord.set('IN_BANK_NAME', '');
						}
					}
				})
        	},        
        	{ dataIndex: 'IN_SAVE_NAME'		         , 	width:146,
        		editor:Unilite.popup('BANK_BOOK_G', {
					autoPopup: true,
					textFieldName:'IN_SAVE_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('IN_SAVE_CODE', records[0].BANK_BOOK_CODE);
							grdRecord.set('IN_SAVE_NAME', records[0].BANK_BOOK_NAME);
							grdRecord.set('IN_BANKBOOK_NUM', records[0].DEPOSIT_NUM);
							grdRecord.set('IN_BANK_CODE', records[0].BANK_CD);
							grdRecord.set('IN_BANK_NAME', records[0].BANK_NM);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('IN_SAVE_CODE', '');
							grdRecord.set('IN_SAVE_NAME', '');
							grdRecord.set('IN_BANKBOOK_NUM', '');
							grdRecord.set('IN_BANK_CODE', '');
							grdRecord.set('IN_BANK_NAME', '');
						}
					}
				})
        	},       
        	{ dataIndex: 'IN_BANK_CODE'		         , 	width:80, hidden:true},        
        	{ dataIndex: 'IN_BANK_NAME'		         , 	width:93,
        		editor:Unilite.popup('BANK_G', {
					autoPopup: true,
					textFieldName:'IN_BANK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('IN_BANK_CODE', records[0].BANK_CODE);
							grdRecord.set('IN_BANK_NAME', records[0].BANK_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('IN_BANK_CODE', '');
							grdRecord.set('IN_BANK_NAME', '');
						}
					}
				})
        	
        	},        
        	{ dataIndex: 'IN_BANKBOOK_NUM'           , 	width:120},        
        	{ dataIndex: 'IN_BANKBOOK_NAME'          , 	width:100},        
        	{ dataIndex: 'REMARK_DTL'			     , 	width:166},        
        	{ dataIndex: 'TOT_AMT_I'			     , 	width:80, summaryType: 'sum'},        
        	{ dataIndex: 'INC_AMT_I'			     , 	width:73, summaryType: 'sum'},        
        	{ dataIndex: 'LOC_AMT_I'			     , 	width:73, summaryType: 'sum'},        
        	{ dataIndex: 'REAL_AMT_I'			     , 	width:86, summaryType: 'sum'},        
        	{ dataIndex: 'TRANS_SEQ'			     , 	width:73,align:'center'},        
        	{ dataIndex: 'EX_DATE'			         , 	width:80},        
        	{ dataIndex: 'EX_NUM'				     , 	width:53, format:'0', align:'center'},        
        	{ dataIndex: 'TRANS_FEE'			     , 	width:90},       
        	{ dataIndex: 'TRANS_ID'			         , 	width:200},        
        	{ dataIndex: 'TRANS_STATE_NUM'	         , 	width:100},        
        	{ dataIndex: 'TRANS_RESULT_YN'	         , 	width:86},        
        	{ dataIndex: 'TRANS_RESULT_MSG'	         , 	width:133},        
        	{ dataIndex: 'PAY_DIVI'			         , 	width:66, hidden:true},        
        	{ dataIndex: 'DIV_CODE'			         , 	width:66, hidden:true},        
        	{ dataIndex: 'DEPT_CODE'			     , 	width:66, hidden:true},        
        	{ dataIndex: 'DEPT_NAME'			     , 	width:93, hidden:true},        
        	{ dataIndex: 'REFER_NUM'			     , 	width:120, hidden:true},        
        	{ dataIndex: 'PAY_TOT'			         , 	width:120, hidden:true},        
        	{ dataIndex: 'INC_TOT'			         , 	width:120, hidden:true},        
        	{ dataIndex: 'LOC_TOT'			         , 	width:120, hidden:true},        
        	{ dataIndex: 'REAL_TOT'			         , 	width:120, hidden:true},        
        	{ dataIndex: 'INSERT_DB_USER'		     , 	width:100, hidden:true},        
        	{ dataIndex: 'INSERT_DB_TIME'		     , 	width:100, hidden:true},        
        	{ dataIndex: 'UPDATE_DB_USER'		     , 	width:100, hidden:true},        
        	{ dataIndex: 'UPDATE_DB_TIME'		     , 	width:100, hidden:true}
        ],
        listeners: {
        	afterrender:function()	{
				UniAppManager.app.setHiddenColumn1();
			},
			beforeedit : function( editor, e, eOpts ) {
				if(e.record.data.TRANS_DATE == 'B' || !Ext.isEmpty(e.record.data.EX_DATE)){
					return false;
				}
				if(UniUtils.indexOf(e.field, ['IN_BANK_CODE','IN_BANK_NAME','IN_BANKBOOK_NUM','IN_BANKBOOK_NAME'])){
					if(e.record.data.INPUT_GUBUN == '1'){
						return true;
					}else{
						return false;	
					}
				}else if(UniUtils.indexOf(e.field, ['TOT_AMT_I'])){
					if(e.record.data.INPUT_GUBUN == '2'){
						return true;
					}else{
						return false;	
					}
				}else if(UniUtils.indexOf(e.field, ['INC_AMT_I','LOC_AMT_I'])){
					if(e.record.data.INPUT_GUBUN == '1'){
						return true;
					}else{
						return false;	
					}
				}else if(UniUtils.indexOf(e.field, ['TRANS_DATE','IN_SAVE_CODE','IN_SAVE_NAME','OUT_SAVE_CODE','OUT_SAVE_NAME'])){
					return true;
				}else if(UniUtils.indexOf(e.field, ['REMARK'])){
					if(e.record.data.INPUT_GUBUN == '2'){
						return true;
					}else{
						return false;	
					}
				}else{
					return false;	
				}
				
				
			/*	if(!UniUtils.indexOf(e.field, ['CHOICE'])){
					var grdRecord = detailGrid.uniOpt.currentRecord;
					
					grdRecord.set('CHOICE',false);
				}*/
				
			},
			itemmouseenter:function(view, record, item, index, e, eOpts )	{  
	        	if(!Ext.isEmpty(record.get('PROV_DRAFT_NO'))){
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
        	}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{ 
			if(event.position.column.dataIndex == 'PROV_DRAFT_NO'){
	        	return true;
	        }
      	},
		gotoAfb700ukr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 'afb900ukr',
					'PAY_DRAFT_NO' : record.data['PROV_DRAFT_NO']
					//파라미터 추후 추가
				}
		  		var rec1 = {data : {prgID : 'afb700ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb700ukr.do', params);
			}
    	},
		setFundingTargetData:function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			grdRecord.set('INPUT_GUBUN'			, '1');
			grdRecord.set('AMT_GUBUN'			, record['AMT_GUBUN']);
			grdRecord.set('TRANS_DATE'			, subForm.getValue('TRANS_DATE'));
			grdRecord.set('PAY_DATE'			, record['PAY_DATE']);
			grdRecord.set('APP_DATE'			, record['APP_DATE']);
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('PAY_DIVI'			, record['PAY_DIVI']);
			grdRecord.set('IN_SAVE_CODE'		, record['IN_SAVE_CODE']);
			grdRecord.set('IN_SAVE_NAME'		, record['IN_SAVE_NAME']);
			grdRecord.set('IN_BANK_CODE'		, record['IN_BANK_CODE']);
			grdRecord.set('IN_BANK_NAME'		, record['IN_BANK_NAME']);
			grdRecord.set('IN_BANKBOOK_NUM'		, record['IN_BANKBOOK_NUM']);
			grdRecord.set('IN_BANKBOOK_NAME'	, record['IN_BANKBOOK_NAME']);
			grdRecord.set('REMARK_DTL'			, record['REMARK_DTL']);
			grdRecord.set('TOT_AMT_I'			, record['TOT_AMT_I']);
			grdRecord.set('INC_AMT_I'			, record['INC_AMT_I']);
			grdRecord.set('LOC_AMT_I'			, record['LOC_AMT_I']);
			grdRecord.set('REAL_AMT_I'			, record['REAL_AMT_I']);
			grdRecord.set('OUT_SAVE_CODE'		, record['OUT_SAVE_CODE']);
			grdRecord.set('OUT_SAVE_NAME'		, record['OUT_SAVE_NAME']);
			grdRecord.set('OUT_BANKBOOK_NUM'	, record['OUT_BANKBOOK_NUM']);
			grdRecord.set('OUT_BANK_CODE'		, record['OUT_BANK_CODE']);
			grdRecord.set('PEND_CODE'			, record['PEND_CODE']);
			grdRecord.set('PAY_CUSTOM_CODE'		, record['PAY_CUSTOM_CODE']);
			grdRecord.set('PAY_CUSTOM_NAME'		, record['PAY_CUSTOM_NAME']);
			grdRecord.set('PJT_CODE'			, record['PJT_CODE']);
			grdRecord.set('PJT_NAME'			, record['PJT_NAME']);
			grdRecord.set('REMARK'				, record['TITLE']);
			grdRecord.set('PROV_AMT_I'			, record['PROV_AMT_I']);
			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('DEPT_CODE'			, record['DEPT_CODE']);
			grdRecord.set('DEPT_NAME'			, record['DEPT_NAME']);
			grdRecord.set('PROV_DRAFT_NO'		, record['PROV_DRAFT_NO']);
			grdRecord.set('PROV_DRAFT_SEQ'		, record['PROV_DRAFT_SEQ']);
			grdRecord.set('REFER_NUM'			, record['REFER_NUM']);
		}
    });   
/*	var branchDummyGrid = Unilite.createGrid('branchDummyGrid', {
		store: branchStore,
	});*/
    var fundingTargetGrid = Unilite.createGrid('afb900ukrFundingTargetGrid', {//이체대상참조
        // title: '기본',
        layout : 'fit',
        excelTitle: '이체대상참조',
    	store: fundingTargetStore,
    	features: [{
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
    	uniOpt: {
    		onLoadSelectFirst: false  
        },
    	selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var sm = fundingTargetGrid.getSelectionModel();
					var selRecords = fundingTargetGrid.getSelectionModel().getSelection();
					var records = fundingTargetStore.data.items;
					Ext.each(records, function(record, index){
						if(selectRecord.get('PROV_DRAFT_NO') == record.get('PROV_DRAFT_NO')){
							selRecords.push(record);
						}
					});
					sm.select(selRecords);
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var sm = fundingTargetGrid.getSelectionModel();
					var selRecords = fundingTargetGrid.getSelectionModel().getSelection();
					var records = fundingTargetStore.data.items;
					Ext.each(records, function(record, index){
						if(selectRecord.get('PROV_DRAFT_NO') != record.get('PROV_DRAFT_NO')){
							selRecords.splice(0, 10000); 
						}
	  				});
					Ext.each(records, function(record, index){
						if(selectRecord.get('PROV_DRAFT_NO') == record.get('PROV_DRAFT_NO')){
							selRecords.push(record);
						}
					});
					sm.deselect(selRecords);
				}
			}
        }),
        columns:  [  
			{ dataIndex: 'SEQ'				                 , 	width:55,align:'center'},
//			{ dataIndex: 'CHOICE'				             , 	width:88},
			{ dataIndex: 'PROV_DRAFT_NO'		             , 	width:100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '');
            	}
			},
			{ dataIndex: 'PROV_DRAFT_SEQ'		             , 	width:60, hidden:true},
			{ dataIndex: 'AMT_GUBUN'			             , 	width:88, hidden:true},
			{ dataIndex: 'PAY_DATE'			                 , 	width:80},
			{ dataIndex: 'APP_DATE'			                 , 	width:80},
			{ dataIndex: 'TITLE'				             , 	width:150},
			{ dataIndex: 'PJT_CODE'			                 , 	width:88, hidden:true},
			{ dataIndex: 'PJT_NAME'			                 , 	width:120},
			{ dataIndex: 'PROV_AMT_I'			             , 	width:88},
			{ dataIndex: 'PAY_DIVI'			                 , 	width:88, hidden:true},
			{ dataIndex: 'PAY_DIVI_NAME'		             , 	width:88},
			{ dataIndex: 'TOT_AMT_I_USE_SUMMARY'	 , text: '금액', width: 100,summaryType: 'sum'},
			{ dataIndex: 'TOT_AMT_I'			             , 	width:88,hidden:true},
			{ dataIndex: 'LOC_AMT_I'			             , 	width:88},
			{ dataIndex: 'INC_AMT_I'			             , 	width:88},
			{ dataIndex: 'REAL_AMT_I'			             , 	width:88},
			{ dataIndex: 'PEND_CODE'			             , 	width:88},
			{ dataIndex: 'PAY_CUSTOM_CODE'	                 , 	width:88},
			{ dataIndex: 'PAY_CUSTOM_NAME'	                 , 	width:88},
			{ dataIndex: 'CUSTOM_CODE'		                 , 	width:88},
			{ dataIndex: 'CUSTOM_NAME'		                 , 	width:88},
			{ dataIndex: 'IN_SAVE_CODE'		                 , 	width:88},
			{ dataIndex: 'IN_SAVE_NAME'		                 , 	width:88},
			{ dataIndex: 'IN_BANK_CODE'		                 , 	width:88, hidden:true},
			{ dataIndex: 'IN_BANK_NAME'		                 , 	width:120},
			{ dataIndex: 'IN_BANKBOOK_NUM'	                 , 	width:150},
			{ dataIndex: 'IN_BANKBOOK_NAME'	                 , 	width:120},
			{ dataIndex: 'REMARK_DTL'			             , 	width:88},
			{ dataIndex: 'OUT_SAVE_CODE'		             , 	width:88},
			{ dataIndex: 'OUT_SAVE_NAME'		             , 	width:120},
			{ dataIndex: 'OUT_BANKBOOK_NUM'	                 , 	width:150},
			{ dataIndex: 'OUT_BANK_CODE'		             , 	width:88, hidden:true},
			{ dataIndex: 'DIV_CODE'			                 , 	width:88, hidden:true},
			{ dataIndex: 'DEPT_CODE'			             , 	width:88, hidden:true},
			{ dataIndex: 'DEPT_NAME'			             , 	width:88, hidden:true},
			{ dataIndex: 'REFER_NUM'			             , 	width:88, hidden:true}
		], 
		listeners: {	
			afterrender:function()	{
				UniAppManager.app.setHiddenColumn2();
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()	{
       		//var records = this.getSelectedRecords();
       		var records = this.sortedSelectedRecords(this);
       		
			Ext.each(records, function(record,i){	
	        	UniAppManager.app.onNewDataButtonDown();
	        	detailGrid.setFundingTargetData(record.data);								        
		    }); 
			this.getStore().remove(records);
       	}
    });
    
    function openFundingTargetWindow() {    		//이체대상참조
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		
  		
  		
  		
//  		fundingTargetStore.loadStoreRecords(); 
		if(!referFundingTargetWindow) {
			referFundingTargetWindow = Ext.create('widget.uniDetailWindow', {
                title: '이체대상참조',
                width: 1100,				                
                height: 350,
                layout:{type:'vbox', align:'stretch'},
                items: [fundingTargetSearch, fundingTargetGrid],
                tbar:  ['->',
					{	
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							if(!fundingTargetSearch.getInvalidMessage()) return;
							fundingTargetStore.loadStoreRecords();
						},
						disabled: false
					},{	
						itemId : 'confirmBtn',
						text: '이체적용',
						handler: function() {
							fundingTargetGrid.returnData();
						},
						disabled: false
					},{	
						itemId : 'confirmCloseBtn',
						text: '이체적용 후 닫기',
						handler: function() {
							fundingTargetGrid.returnData();
							referFundingTargetWindow.hide();
							fundingTargetGrid.reset();
							fundingTargetSearch.clearForm();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							referFundingTargetWindow.hide();
							fundingTargetGrid.reset();
							fundingTargetSearch.clearForm();
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
						fundingTargetSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
				  		fundingTargetSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
				  		fundingTargetSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
				  		fundingTargetSearch.setValue('WH_CODE', panelSearch.getValue('WH_CODE'));
				  		fundingTargetSearch.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
				  		fundingTargetSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
				  		fundingTargetSearch.setValue('RETURN_DATE', panelSearch.getValue('INOUT_DATE'));
				  		fundingTargetSearch.setValue('RETURN_CODE', panelSearch.getValue('RETURN_CODE'));
				  		fundingTargetSearch.setValue('INOUT_PRSN', panelSearch.getValue('INOUT_PRSN'));
						
//		 				orderStore.loadStoreRecords();
		 			},*/
		 		
		 			show: function ( panel, eOpts )	{
		 				fundingTargetSearch.setValue('FR_PAY_DATE', UniDate.get('startOfMonth'));
		 				fundingTargetSearch.setValue('TO_PAY_DATE', UniDate.get('today'));
//						fundingTargetSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
//				  		fundingTargetSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
//				  		fundingTargetSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
//				  		fundingTargetSearch.setValue('WH_CODE', panelSearch.getValue('WH_CODE'));
//				  		fundingTargetSearch.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
//				  		fundingTargetSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
//				  		fundingTargetSearch.setValue('RETURN_DATE', panelSearch.getValue('INOUT_DATE'));
//				  		fundingTargetSearch.setValue('RETURN_CODE', panelSearch.getValue('RETURN_CODE'));
//				  		fundingTargetSearch.setValue('INOUT_PRSN', panelSearch.getValue('INOUT_PRSN'));
						
//		 				orderStore.loadStoreRecords();
		 			}
		 			
				}
			})
		}
		referFundingTargetWindow.center();
		referFundingTargetWindow.show();
    }
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, subForm, detailGrid//, sumForm
			]	
		},
			panelSearch
		],
		id  : 'afb900ukrApp',
		fnInitBinding: function(params){
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			this.setDefault(params);
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
		},
		onQueryButtonDown: function() {      
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			
			directDetailStore.loadStoreRecords();	
/*			
			detailGrid.getStore().loadStoreRecords();
			var viewLocked = detailGrid.lockedGrid.getView();
			var viewNormal = detailGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
			viewLocked.getFeature('detailGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('detailGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('detailGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('detailGridTotal').toggleSummaryRow(true);	*/			
		},
		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			/**
			 * Detail Grid Default 값 설정
			 */
			 var seq = directDetailStore.max('SEQ');
        	 if(!seq){
        	 	seq = 1;
        	 }else{
        	 	seq += 1;
        	 }
			 var compCode = UserInfo.compCode;
			 var inputGubun = '2';
			 var transDate = subForm.getValue('TRANS_DATE');
        	 var incAmtI = 0;
        	 var locAmtI = 0;
        	 
        	 var r = {
				SEQ: seq,
				COMP_CODE: compCode,
				INPUT_GUBUN: inputGubun,
				TRANS_DATE: transDate,
				INC_AMT_I: incAmtI,
				LOC_AMT_I: locAmtI
	        };
			detailGrid.createRow(r);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			
			UniAppManager.app.fnInitInputFields();
		},
		
		onSaveDataButtonDown: function(config) {				
			directDetailStore.saveStore();
		},
		
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				
				
				detailGrid.deleteSelectedRow();
				
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					detailGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {			
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
		},
		setDefault: function(params){
			
			UniAppManager.app.fnInitInputProperties();
			
			if(!Ext.isEmpty(params.PAY_DRAFT_NO)){
//				this.processParams(params); 추후 재 빌드
			}else{
				UniAppManager.app.fnInitInputFields();	
			}
			
		},
		/**
		 * 프로그램별 사용 컬럼 공통코드B114 관련	
		 */
		setHiddenColumn1: function() {
		 
/*			if(gsBranchUse == 'Y'){
				detailGrid.getColumn("CHOICE").setHidden(false);
//				detailGrid.setConfig('selModel',Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }));
			}else{
				detailGrid.getColumn("CHOICE").setHidden(true);
//				detailGrid.setConfig('selModel','rowmodel');
			}
			*/
			Ext.each(useColList1, function(record, idx) {
				if(record.REF_CODE4 == 'True'){
					detailGrid.getColumn(record.REF_CODE3).setHidden(true);
				}
			});
		},
		setHiddenColumn2: function() {
			Ext.each(useColList2, function(record, idx) {
				if(record.REF_CODE4 == 'True'){
					fundingTargetGrid.getColumn(record.REF_CODE3).setHidden(true);
				}
			});
		},
		/**
		 * 입력란의 속성 설정 (입력가능여부 등)
		 */
		fnInitInputProperties: function() {
			
			//이체지급등록 브랜치연계 사용
			if(gsBranchUse == 'Y'){
				Ext.getCmp('branch').setHidden(false);
				Ext.getCmp('branchSend').setHidden(false);
//				Ext.getCmp('selectAll').setHidden(false);
			}else{
				Ext.getCmp('branch').setHidden(true);
				Ext.getCmp('branchSend').setHidden(true);
//				Ext.getCmp('selectAll').setHidden(true);
			}
			
			//브랜치시스템이 '30' 우리은행 win-cms
			if(gsBranchName == '30'){
				Ext.getCmp('btnSendby').setHidden(false);
				panelResult.down('#btnSend').setText("Branch로보내기(대량)");
			}else{
				Ext.getCmp('btnSendby').setHidden(true);
				panelResult.down('#btnSend').setText("Branch로보내기");
			}
		},
		
		/**
		 * 입력란의 초기값 설정
		 */
		fnInitInputFields: function(){
			//자금이체일
			panelSearch.setValue('FR_DATE',UniDate.get('today'));
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('FR_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			//사업장
			panelSearch.setValue('DIV_CODE','');
			panelResult.setValue('DIV_CODE','');

			//출금계좌
			panelSearch.setValue('OUT_SAVE_CODE','');
			panelSearch.setValue('OUT_SAVE_NAME','');
			panelResult.setValue('OUT_SAVE_CODE','');
			panelResult.setValue('OUT_SAVE_NAME','');
			
			//기표여부
			panelResult.getField('RDO_SLIP').setValue('');	
			panelSearch.getField('RDO_SLIP').setValue('');	
			
			//브랜치보내기
			panelResult.getField('RDO_SEND').setValue('N');	
			
			//이체결과받기
			panelResult.getField('RDO_RESULT').setValue('');	
			
			
			//자금이체일
			subForm.setValue('TRANS_DATE',UniDate.get('today'));
			
/*			//지급총액
			Ext.getCmp('bbarPayTot').setValue('');
			
			//소득세
			Ext.getCmp('bbarIncTot').setValue('');
			
			//주민세
			Ext.getCmp('bbarLocTot').setValue('');
			
			//실지급액
			Ext.getCmp('bbarRealTot').setValue('');*/
		},
		/**
		 * 자동기표조회 링크 관련
		 */
		fnProcSlip: function(){
		/*	if(detailForm.getValue('EX_NUM') == ''){
				return false;	
			}*/
			var params = {
//				action:'select', 
				'PGM_ID' : 'afb900ukr',
				'FR_DATE' : panelResult.getValue('FR_DATE'),
				'TO_DATE' : panelResult.getValue('TO_DATE'),
				'DIV_CODE' : panelResult.getValue('DIV_CODE'),
				'TRANS_DATE' : subForm.getValue('TRANS_DATE')
				
			}
	  		var rec1 = {data : {prgID : 'agd340ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agd340ukr.do', params);
		},
		/**
		 * 수취인조회하기 링크 관련
		 */
		fnBookNameSearch: function(){
			var params = {
				'PGM_ID' : 'afb900ukr'
//				'FR_DATE' : panelResult.getValue('FR_DATE'),
//				'TO_DATE' : panelResult.getValue('TO_DATE'),
//				'DIV_CODE' : panelResult.getValue('DIV_CODE'),
//				'TRANS_DATE' : subForm.getValue('TRANS_DATE')
				
			}
	  		var rec1 = {data : {prgID : 'abh120ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/abh120ukr.do', params);
		},
		/**
		 * 자금이체일 변경시 , 디테일에도 반영 
		 */
		fnApplyTransDate: function(transDate){
			if(confirm(Msg.fSbMsgA0518)) {
				var records = directDetailStore.data.items;
				Ext.each(records, function(record, i){
					if(Ext.isEmpty(record.get('EX_DATE')) && record.get('TRANS_DATE') != 'B'){
						record.set('TRANS_DATE', transDate);
					}
				});
			}else{
				return false;	
			}
		},
		/**
		 * 용  도 : 실지급액 = 지급액 - 소득세 - 주민세로 자동 계산		(summary총계 로우로 변경..)
		 */
		fnCalcRealAmt: function(applyRecord, totAmtINewValue, incAmtINewValue, locAmtINewValue){
			var dTotAmtI = 0;
			var dIncAmtI = 0;
			var dLocAmtI = 0;
			
			if(totAmtINewValue == ''){
				dTotAmtI = applyRecord.get('TOT_AMT_I');
			}else{
				dTotAmtI = totAmtINewValue;
			}
			
			if(incAmtINewValue == ''){
				dIncAmtI = applyRecord.get('INC_AMT_I');
			}else{
				dIncAmtI = incAmtINewValue;
			}
			
			if(locAmtINewValue == ''){
				dLocAmtI = applyRecord.get('LOC_AMT_I');
			}else{
				dLocAmtI = locAmtINewValue;
			}
			
			
			applyRecord.set('REAL_AMT_I', dTotAmtI - dIncAmtI - dLocAmtI);
			
			UniAppManager.app.fnDispRealAmt();
		},
		fnDispRealAmt: function(){
			var dPayTot = 0;
			var dTOT_AMT_I = 0;
			var dIncTot = 0; 
			var dINC_AMT_I = 0;
			var dLocTot = 0; 
			var dLOC_AMT_I = 0;
			var dRealTot = 0; 
			var dREAL_AMT_I = 0;
			
			var records = directDetailStore.data.items;
			
			Ext.each(records, function(record, i) {
				dTOT_AMT_I	= record.get('TOT_AMT_I');
				dINC_AMT_I	= record.get('INC_AMT_I');
				dLOC_AMT_I	= record.get('LOC_AMT_I');
				dREAL_AMT_I	= record.get('REAL_AMT_I');
				
				dPayTot		= dPayTot  + dTOT_AMT_I;
				dIncTot		= dIncTot  + dINC_AMT_I;
				dLocTot		= dLocTot  + dLOC_AMT_I;
				dRealTot    = dRealTot + dREAL_AMT_I; 
			
			});
			
			Ext.getCmp('bbarPayTot').setValue(dPayTot);
	        Ext.getCmp('bbarIncTot').setValue(dIncTot);
	        Ext.getCmp('bbarLocTot').setValue(dLocTot);
	        Ext.getCmp('bbarRealTot').setValue(dRealTot);	
			
		}
		
//		fnSelectAll
		
			
	});
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {/*
				case "IN_BANK_CODE" :
					record.set('CHOICE',false);
					grdRecord.set('CHOICE_FLAG','');
					directDetailStore.commitChanges();
				break;
				case "IN_BANK_NAME" :
					record.set('CHOICE',false);
				grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
				break;
				case "IN_BANKBOOK_NUM" :
					record.set('CHOICE',false);
					grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
				break;
				case "IN_BANKBOOK_NAME" :
					record.set('CHOICE',false);
					grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
				break;
				case "TOT_AMT_I" :
					record.set('CHOICE',false);
					grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
				break;
				case "INC_AMT_I" :
					record.set('CHOICE',false);
					grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
				break;
				case "LOC_AMT_I" :
					record.set('CHOICE',false);
					grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
				break;
				case "TRANS_DATE" :
					record.set('CHOICE',false);
					grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
				break;
				case "IN_SAVE_CODE" :
					record.set('CHOICE',false);
					grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
				break;
				case "IN_SAVE_NAME" :
					record.set('CHOICE',false);
					grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
				break;
				case "OUT_SAVE_CODE" :
					record.set('CHOICE',false);
					grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
				break;
				case "OUT_SAVE_NAME" :
					record.set('CHOICE',false);
					grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
				break;
				case "REMARK" :
					record.set('CHOICE',false);
					grdRecord.set('CHOICE_FLAG','');
        					directDetailStore.commitChanges();
				break;
			*/}
				return rv;
						}
			});	
	Unilite.createValidator('validator02', {
		forms: {'formA:':subForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {
			/*	case "TRANS_DATE":
					var records = directDetailStore.data.items;
					if(!Ext.isEmpty(records)){
						UniAppManager.app.fnApplyTransDate(newValue);
					}
					break;*/
			}
			return rv;
		}
	}); // validator02			
			
};

</script>