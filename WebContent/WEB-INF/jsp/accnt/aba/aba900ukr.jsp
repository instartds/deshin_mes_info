<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aba900ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A035" /> <!-- 비용상태 --> 
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 --> 

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	//계정과목에 따른 팝업 필수체크
	var gsAccntSpec = 'N';
	var gsCustCode = 'N'; 		//거래처팝업 필수 체크
	var gsBankCode = 'N'; 		//은행팝업 필수 체크
	var gsPjtCode = 'N';			//프로젝트팝업 필수 체크
	var gsChargeCode = '${getChargeCode}';
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aba900ukrModel', {
	    fields: [
			{name: 'ITEM_CODE'		 			,text: '비용코드'		,type: 'string', allowBlank: false, maxLength: 8},
   			{name: 'ITEM_NAME'		 			,text: '비용명'		,type: 'string', allowBlank: false, maxLength: 40},
   			{name: 'ACCNT'			 			,text: '계정과목'		,type: 'string', allowBlank: false},
   			{name: 'ACCNT_NM'		 			,text: '계정과목명'		,type: 'string', allowBlank: false, maxLength: 50},
   			{name: 'P_ACCNT'		 			,text: '상대과목'		,type: 'string', allowBlank: false},
   			{name: 'P_ACCNT_NM'		 			,text: '상대과목명'		,type: 'string', allowBlank: false},
   			{name: 'MONEY_UNIT'		 			,text: '화폐단위'		,type: 'string', comboType: 'AU', comboCode: 'B004',displayField: 'value'},
   			{name: 'EXCHG_RATE_O'	 			,text: '환율'			,type: 'uniER'},
   			{name: 'AMT_FOR_I'	 				,text: '외화금액'		,type: 'uniFC', allowBlank: true},
   			{name: 'AMT_I'	 					,text: '금액'			,type: 'uniPrice', allowBlank: false},
   			{name: 'START_DATE'	 				,text: '시작일'		,type: 'uniDate', allowBlank: false},
   			{name: 'END_DATE'	 				,text: '종료일'		,type: 'uniDate', allowBlank: false},
   			{name: 'CUSTOM_CODE'	 			,text: '거래처'		,type: 'string', allowBlank: false},
   			{name: 'CUSTOM_NAME'	 			,text: '거래처명'		,type: 'string', allowBlank: false},
   			{name: 'BANK_CD'	 				,text: '은행'			,type: 'string'},
   			{name: 'BANK_NAME'	 				,text: '은행명'		,type: 'string'},
   			{name: 'DEPT_CODE'	 				,text: '부서'			,type: 'string', allowBlank: false},
   			{name: 'DEPT_NAME'	 				,text: '부서명'		,type: 'string', allowBlank: false},
   			{name: 'PJT_CODE'	 				,text: '프로젝트코드'	,type: 'string'},
   			{name: 'PJT_NAME'	 				,text: '프로젝트명'		,type: 'string'},
   			{name: 'DIV_CODE'	 				,text: '사업장'		,type: 'string', comboType: 'BOR120', allowBlank: false},
   			{name: 'COST_STS'	 				,text: '비용상태'		,type: 'string', comboType: 'AU', comboCode: 'A035', defaultValue: 'N', allowBlank: false},
   			{name: 'FI_DPR_TOT_I'	 			,text: '기말비용누계액'	,type: 'uniPrice'},
   			{name: 'FI_BLN_I'	 				,text: '기말미처리잔액'	,type: 'uniPrice', allowBlank: false},
   			{name: 'FOR_YN'	 					,text: 'FOR_YN'			,type: 'string'},
   			{name: 'CUST_CODE'	 				,text: 'CUST_CODE'		,type: 'string'},
   			{name: 'BANK_CODE'	 				,text: 'BANK_CODE'		,type: 'string'},
   			{name: 'PROJECT_CODE'	 			,text: '프로젝트 번호'	,type: 'string'},
   			//화폐단위, 환율도 체크
   			//2016/12/22 추가
//   			{name: 'ORG_AC_DATE'	 			,text: '원전표일자'			,type: 'uniDate' , editable: false },
//   			{name: 'ORG_SLIP_NUM'	 			,text: '원전표번호'			,type: 'uniNumber' , editable: false },
//   			{name: 'ORG_SLIP_SEQ'	 			,text: '원전표순번'			,type: 'uniNumber' , editable: false },
//   			{name: 'ORG_ACCNT'	 				,text: '원계정과목코드'		,type: 'string', allowBlank: false},
   			{name: 'COMP_CODE'	 				,text: 'COMP_CODE'			,type: 'string', defaultValue: UserInfo.compCode}
		]
	});
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aba900ukrService.selectList',
			update: 'aba900ukrService.updateDetail',
			create: 'aba900ukrService.insertDetail',
			destroy: 'aba900ukrService.deleteDetail',
			syncAll: 'aba900ukrService.saveAll'
		}
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aba900ukrMasterStore',{
		model: 'Aba900ukrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: directProxy
		,loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	var list = [].concat(toUpdate,toCreate);
        	var isErr = false;
        	var forYnCheck_moneyUnit, forYnCheck_exRate, custCheck, bankCheck, projectCheck;
        	var str = '필수 입력값 입니다.\n'
        	var errRow = 0;
        	Ext.each(list, function(record, index) {            		
        		if(record.get('FOR_YN') == 'Y'){
        			if(Ext.isEmpty(record.get('MONEY_UNIT'))){
        				forYnCheck_moneyUnit = '화폐단위: ' + str; 
        				isErr = true;
        				errRow = index;
        			}
        			if(Ext.isEmpty(record.get('EXCHG_RATE_O'))){
        				forYnCheck_exRate = '환율: ' + str;
        				isErr = true;
        				errRow = index;
        			}        			
        		}
        		if(record.get('CUST_CODE') == 'Y' && Ext.isEmpty(record.get('CUSTOM_CODE'))){
        			custCheck = '거래처: ' + str
        			isErr = true;
        			errRow = index;
        		}
        		if(record.get('BANK_CODE') == 'Y' && Ext.isEmpty(record.get('BANK_CD'))){
        			bankCheck = '은행: ' + str
        			isErr = true;
        			errRow = index;
        		}
        		if(record.get('PROJECT_CODE') == 'Y' && Ext.isEmpty(record.get('PJT_CODE'))){
        			projectCheck = '프로젝트코드: ' + str
        			isErr = true;
        			errRow = index;
        		}
        		if(isErr) return false;
        	});
        	if(isErr){
        		var errString = (errRow + 1) + '행의 입력값을 확인해 주세요.' + '\n';
        		if(!Ext.isEmpty(forYnCheck_moneyUnit)){
        			errString += forYnCheck_moneyUnit;
        		}
        		if(!Ext.isEmpty(forYnCheck_exRate)){
        			errString += forYnCheck_exRate;
        		}
        		if(!Ext.isEmpty(custCheck)){
        			errString += custCheck;
        		}
        		if(!Ext.isEmpty(bankCheck)){
        			errString += bankCheck;
        		}
        		if(!Ext.isEmpty(projectCheck)){
        			errString += projectCheck;
        		}
        		alert(errString);
        		return false;
        	}
			if(inValidRecs.length == 0 )	{
				directMasterStore.syncAllDirect(config);	
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
		    items : [
		    	Unilite.popup('COST',{
			    validateBlank: false,
			    valueFieldName:'COST_CODE',
                textFieldName:'COST_NAME',
                autoPopup: true,
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('COST_CODE', panelSearch.getValue('COST_CODE'));
//							panelResult.setValue('COST_NAME', panelSearch.getValue('COST_NAME'));
//                    	},
//						scope: this
//					},
					onClear: function(type)	{
						panelResult.setValue('COST_CODE', '');
						panelResult.setValue('COST_NAME', '');
						panelSearch.setValue('COST_CODE', '');
                        panelSearch.setValue('COST_NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('COST_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('COST_NAME', newValue);				
					}
				}
		   	}),{					
    			fieldLabel: '사업장',
    			name:'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType:'BOR120',
    			value: '01',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		}, { 
    			fieldLabel: '기간',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'DATE_FR',
		        endFieldName: 'DATE_TO',           	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
			    	}
			    }
	        },{
			    xtype: 'radiogroup',
			    fieldLabel:' ',
			    items : [{
			    	boxLabel: '시작일',
			    	name: 'rdoSelect',
			    	inputValue: '1',
			    	checked: true,
			    	width:80
				},{
					boxLabel: '종료일',
			    	name: 'rdoSelect',
			    	inputValue: '2',
			    	width:80
			    }],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
					}
				}			
			},{					
    			fieldLabel: '비용상태',
    			name:'STATE',
    			xtype: 'uniCombobox',
    			comboType: 'AU',
    			comboCode: 'A035',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {				
						panelResult.getField('STATE').setValue(newValue);
					},
					specialkey:function(field, e){
	                    if (e.getKey() == e.ENTER) {
	                        directMasterStore.loadStoreRecords();
                    	}
                	}
				}
    		}]		
		}]
	});   
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			Unilite.popup('COST',{ 
		    validateBlank: false,
		    autoPopup: true,
		    valueFieldName:'COST_CODE',
            textFieldName:'COST_NAME',
			listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('COST_CODE', panelResult.getValue('COST_CODE'));
//						panelSearch.setValue('COST_NAME', panelResult.getValue('COST_NAME'));
//                	},
//					scope: this
//				},
				onClear: function(type)	{
					panelSearch.setValue('COST_CODE', '');
					panelSearch.setValue('COST_NAME', '');
					panelResult.setValue('COST_CODE', '');
                    panelResult.setValue('COST_NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('COST_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('COST_NAME', newValue);				
				}
			}
	   	}),{
	   		xtype: 'component'
	   	},{					
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			value: '01',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, { 
			fieldLabel: '기간',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'DATE_FR',
	        endFieldName: 'DATE_TO',                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DATE_FR',newValue);
					//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DATE_TO',newValue);
		    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
		    	}
		    }
        },{
		    xtype: 'radiogroup',
		    fieldLabel:' ',
		    items : [{
		    	boxLabel: '시작일',
		    	name: 'rdoSelect',
		    	inputValue: '1',
		    	checked: true,
		    	width:80
			},{
				boxLabel: '종료일',
		    	name: 'rdoSelect',
		    	inputValue: '2',
		    	width:80
		    }],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {				
					panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
				}
			}			
		},{					
			fieldLabel: '비용상태',
			name:'STATE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'A035',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {				
					panelSearch.getField('STATE').setValue(newValue);
				},
				specialkey:function(field, e){
                    if (e.getKey() == e.ENTER) {
                        directMasterStore.loadStoreRecords();
                	}
            	}
			}
		}]	
    });
    
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aba900ukrGrid1', {
        layout : 'fit',
        region:'center',
    	store: directMasterStore,
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true
//		 	useContextMenu: true,
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
			{ dataIndex: 'ITEM_CODE'		 		, 				width:70},
			{ dataIndex: 'ITEM_NAME'		 		, 				width:120},
			{ dataIndex: 'ACCNT'			,width: 80 ,
				editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
//					textFieldName:'ACCNT',
					DBtextFieldName: 'ACCNT_CODE',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							console.log('records : ', records);
		                    var grdRecord = masterGrid.uniOpt.currentRecord;				                    	
							grdRecord.set('ACCNT', records[0]['ACCNT_CODE']);
							grdRecord.set('ACCNT_NM', records[0]['ACCNT_NAME']);									 
							UniAppManager.app.fncheckAllowBlank(grdRecord, records[0]['ACCNT_CODE']);
						},
						onClear:function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NM', '');
							grdRecord.set('FOR_YN', '');
							grdRecord.set('CUST_CODE', '');
							grdRecord.set('BANK_CODE', '');
							grdRecord.set('PROJECT_CODE', '');
						},
	                  	applyextparam: function(popup){
							popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND PROFIT_DIVI = 'A' AND GROUP_YN = 'N'"});		
							popup.setExtParam({'CHARGE_CODE': gsChargeCode});		
						}/*,
						applyExtParam:{
							scope:this,
							fn:function(popup){
//								popup.setExtParam({'ADD_QUERY': "A.SLIP_SW = 'Y' AND A.PROFIT_DIVI = 'A' AND A.GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
							}
						}*/
					}					
				})
			},
			{ dataIndex: 'ACCNT_NM'		,width: 160 ,
				editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							console.log('records : ', records);
		                    var grdRecord = masterGrid.uniOpt.currentRecord;				                    	
							grdRecord.set('ACCNT', records[0]['ACCNT_CODE']);
							grdRecord.set('ACCNT_NM', records[0]['ACCNT_NAME']);									 
							UniAppManager.app.fncheckAllowBlank(grdRecord, records[0]['ACCNT_CODE']);
						},
						onClear:function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NM', '');
							grdRecord.set('FOR_YN', '');
							grdRecord.set('CUST_CODE', '');
							grdRecord.set('BANK_CODE', '');
							grdRecord.set('PROJECT_CODE', '');
						},
	                  	applyextparam: function(popup){
							popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND PROFIT_DIVI = 'A' AND GROUP_YN = 'N'"});		
							popup.setExtParam({'CHARGE_CODE': gsChargeCode});		
						}
					}					
				})
			},
			{ dataIndex: 'P_ACCNT'			,width: 80 ,
				editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
//					textFieldName:'P_ACCNT',
					DBtextFieldName: 'ACCNT_CODE',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid.uniOpt.currentRecord;				                    	
							grdRecord.set('P_ACCNT', records[0]['ACCNT_CODE']);
							grdRecord.set('P_ACCNT_NM', records[0]['ACCNT_NAME']);	
						},
						onClear:function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;				                    	
							grdRecord.set('P_ACCNT', '');
							grdRecord.set('P_ACCNT_NM', '');	
						},
	                  	applyextparam: function(popup){
							popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N'"});		
							popup.setExtParam({'CHARGE_CODE': gsChargeCode});		
						}/*,
						applyExtParam:{
							scope:this,
							fn:function(popup){
//								popup.setExtParam({'ADD_QUERY': "A.SLIP_SW = 'Y' AND A.PROFIT_DIVI = 'A' AND A.GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
							}
						}*/
					}					
				})
			},
			{ dataIndex: 'P_ACCNT_NM'		,width: 160 ,
				editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid.uniOpt.currentRecord;				                    	
							grdRecord.set('P_ACCNT', records[0]['ACCNT_CODE']);
							grdRecord.set('P_ACCNT_NM', records[0]['ACCNT_NAME']);	
						},
						onClear:function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;				                    	
							grdRecord.set('P_ACCNT', '');
							grdRecord.set('P_ACCNT_NM', '');	
						},
	                  	applyextparam: function(popup){
							popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N'"});		
							popup.setExtParam({'CHARGE_CODE': gsChargeCode});		
						}
					}					
				})
			},
			{ dataIndex: 'MONEY_UNIT'		 		, 				width:65},
			{ dataIndex: 'EXCHG_RATE_O'	 			,				width:80},
			{ dataIndex: 'AMT_FOR_I'	 			, 				width:100},
			{ dataIndex: 'AMT_I'	 				, 				width:100},
			{ dataIndex: 'START_DATE'	 			, 				width:100},
			{ dataIndex: 'END_DATE'	 				, 				width:100},
			
//			{ dataIndex: 'ORG_ACCNT'	 			,				width:100,
//				editor:Unilite.popup('COM_ABA900_G', {
//					autoPopup: true,
//					DBtextFieldName: 'ORG_ACCNT',
//					listeners:{
//						scope:this,
//						onSelected:function(records, type )	{
//							var grdRecord = masterGrid.uniOpt.currentRecord;				                    	
//							grdRecord.set('ORG_ACCNT', records[0]['ORG_ACCNT']);
//							grdRecord.set('ORG_AC_DATE', records[0]['ORG_AC_DATE']);	
//							grdRecord.set('ORG_SLIP_NUM', records[0]['ORG_SLIP_NUM']);
//							grdRecord.set('ORG_SLIP_SEQ', records[0]['ORG_SLIP_SEQ']);							
//						},
//						onClear:function(type)	{
//							var grdRecord = masterGrid.uniOpt.currentRecord;				                    	
//							grdRecord.set('ORG_ACCNT', '');
//							grdRecord.set('ORG_AC_DATE', '');	
//							grdRecord.set('ORG_SLIP_NUM', '');
//							grdRecord.set('ORG_SLIP_SEQ', '');							
//						}/*,
//	                  	applyextparam: function(popup){
//							popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N'"});		
//							popup.setExtParam({'CHARGE_CODE': gsChargeCode});		
//						}*/
//					}					
//				})
//			
//			},
//			{ dataIndex: 'ORG_AC_DATE'	 			, 				width:100},
//			{ dataIndex: 'ORG_SLIP_NUM'	 			, 				width:100},
//			{ dataIndex: 'ORG_SLIP_SEQ'	 			, 				width:100},

			{ dataIndex: 'CUSTOM_CODE'	 			, 				width:100,
			  'editor': Unilite.popup('CUST_G',{
			  		autoPopup: true,
        	  	 	textFieldName : 'CUSTOM_CODE',
        	  	 	DBtextFieldName : 'CUSTOM_CODE',
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
	                  },
                        applyextparam: function(popup){
                            popup.setExtParam({'ADD_QUERY': ""});    
                        }
        	  	 	}
				})
			},
			{ dataIndex: 'CUSTOM_NAME'	 			, 				width:160,
			  'editor': Unilite.popup('CUST_G',{
			  		autoPopup: true,
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
	                  },
                        applyextparam: function(popup){
                            popup.setExtParam({'ADD_QUERY': ""});    
                        }
        	  	 	}
				})
			},
			{ dataIndex: 'BANK_CD'	 				, 				width:65,
			  'editor': Unilite.popup('BANK_G',{
			  		autoPopup: true,
			  		textFieldName : 'BANK_CODE',
        	  	 	DBtextFieldName : 'BANK_CODE',
        	  	 	listeners: { 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('BANK_CD',records[0]['BANK_CODE']);
    						grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
    						
	                    },
	                    scope: this
	                  },
	                  'onClear' : function(type)	{
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('BANK_CD','');
    						grdRecord.set('BANK_NAME','');
	                  }
        	  	 	}
				})
			},
			{ dataIndex: 'BANK_NAME'	 			, 				width:110,
			  'editor': Unilite.popup('BANK_G',{
			  		autoPopup: true,
        	  	 	listeners: { 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('BANK_CD',records[0]['BANK_CODE']);
    						grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
    						
	                    },
	                    scope: this
	                  },
	                  'onClear' : function(type)	{
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('BANK_CD','');
    						grdRecord.set('BANK_NAME','');
	                  }
        	  	 	}
				})
			},
			{ dataIndex: 'DEPT_CODE'	 			, 				width:60,
				'editor': Unilite.popup('DEPT_G',{
					autoPopup: true,
					DBtextFieldName: 'TREE_CODE',
        	  	 	listeners: { 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
    						grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
    						
	                    },
	                    scope: this
	                  },
	                  'onClear' : function(type)	{
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('DEPT_CODE','');
    						grdRecord.set('DEPT_NAME','');
	                  }
        	  	 	}
				})
			},
			{ dataIndex: 'DEPT_NAME'	 			, 				width:120,
			  'editor': Unilite.popup('DEPT_G',{
			  		autoPopup: true,
        	  	 	listeners: { 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
    						grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
    						
	                    },
	                    scope: this
	                  },
	                  'onClear' : function(type)	{
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('DEPT_CODE','');
    						grdRecord.set('DEPT_NAME','');
	                  }
        	  	 	}
				})
			},
			{ dataIndex: 'PJT_CODE'	 				, 				width:100,				
				'editor': Unilite.popup('AC_PROJECT_G',{
					autoPopup: true,
					DBtextFieldName: 'AC_PROJECT_CODE',
        	  	 	listeners: { 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
    						grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
    						
	                    },
	                    scope: this
	                  },
	                  'onClear' : function(type)	{
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('PJT_CODE','');
    						grdRecord.set('PJT_NAME','');
	                  }
        	  	 	}
				})
			},
			{ dataIndex: 'PJT_NAME'	 				, 				width:200,
			  'editor': Unilite.popup('AC_PROJECT_G',{
			  		autoPopup: true,
        	  	 	listeners: { 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
    						grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
    						
	                    },
	                    scope: this
	                  },
	                  'onClear' : function(type)	{
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('PJT_CODE','');
    						grdRecord.set('PJT_NAME','');
	                  }
        	  	 	}
				})
			},
			{ dataIndex: 'DIV_CODE'	 				, 				width:100},			
			{ dataIndex: 'FI_DPR_TOT_I'	 			, 				width:110},
			{ dataIndex: 'FI_BLN_I'	 				, 				width:110},
			{ dataIndex: 'COST_STS'	 				, 				width:80},
			//{ dataIndex: 'FOR_YN'	 				, 				width:110, hidden: true},
			//{ dataIndex: 'CUST_CODE'	 				, 			width:110, hidden: true},
			//{ dataIndex: 'BANK_CODE'	 				, 			width:110, hidden: true},
			{ dataIndex: 'PROJECT_CODE'	 				, 			width:110, hidden: true}		
			//{ dataIndex: 'COMP_CODE'	 			, 				width:80, hidden: true}
			  
        ], 
		listeners: {
      		beforeedit  : function( editor, e, eOpts ) {
      			if (e.field == 'ITEM_CODE'){
					if(e.record.phantom){
						return true;
					}else{
						return false;					
					}
  				}
			    //신규로 행 추가할 때|| e.field == 'ORG_AC_DATE' || e.field == 'ORG_SLIP_NUM' || e.field == 'ORG_SLIP_SEQ'
			    if(e.record.phantom == true){
			    	if(UniUtils.indexOf(e.field, ['ORG_AC_DATE','ORG_SLIP_NUM','ORG_SLIP_SEQ','FI_BLN_I'])){
			      		return false;
			     	} else {
			      		return true; 
			     	}
			    } else {
			      	if(UniUtils.indexOf(e.field, ['ORG_AC_DATE','ORG_SLIP_NUM','ORG_SLIP_SEQ','FI_BLN_I'])){
			      		return false;
			     	} else {
			      		return true; 
			     	} 
			    } 
//  				if (e.field == 'EXCHG_RATE_O' || e.field == 'MONEY_UNIT'){
//					if(e.record.get('FOR_YN') == "Y"){
//						return true;
//					}else{
//						return false;
//					}
//  				}
  				
//  				if (UniUtils.indexOf(e.field, ['AMT_FOR_I'])){
//					if(e.record.get('FOR_YN') == "Y"){
//						if(e.field == 'AMT_FOR_I'){
//							return true;
//						}else{
//							return false;							
//						}						
//					}else{
//						if(e.field == 'AMT_FOR_I'){
//							return false;
//						}else{
//							return true;							
//						}
//					}
//  				}
  				
  				if (UniUtils.indexOf(e.field, ['FI_DPR_TOT_I', 'FI_BLN_I'])){
					if(e.record.get('FOR_YN') == "Y"){
						if(e.field == 'FI_DPR_TOT_I'){
							return true;
						}else{
							return false;							
						}						
					}
  				}
  				return true;
      		}
		} 
    });   
	
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
		id  : 'aba900ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('newData',true);
			UniAppManager.setToolbarButtons('reset',false);
            panelResult.setValue('DATE_FR', UniDate.get('today'));
            panelResult.setValue('DATE_TO', UniDate.get('today'));
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('COST_CODE');
		},
		onQueryButtonDown : function()	{
			masterGrid.getStore().loadStoreRecords();
		},
//		onResetButtonDown: function() {
//			masterGrid.reset();
//			directMasterStore.clearData();
//			this.fnInitBinding();
//		},
		onNewDataButtonDown: function()	{		
			var r = {
				MONEY_UNIT: UserInfo.currency
			}
			masterGrid.createRow(r, 'ITEM_CODE');
			
		},
		 onDeleteDataButtonDown: function() {	
		 	var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}			
		},
		onSaveDataButtonDown: function () {
			directMasterStore.saveStore();			
		},
		fncheckAllowBlank: function(rtnRecord, accnt){		//계정과목 팝업에서 코드 선택 될 시 관리항목에 거래처, 은행, 프로젝트가 포함되어있을시 그리드에 allowBlank: false가 된다.(동적 allowBlank 아직 미구현.)
			var param = {ACCNT_CD : accnt};
			accntCommonService.fnGetAccntInfo(param, function(provider, response)	{				
				gsAccntSpec = provider.FOR_YN;
				rtnRecord.set('FOR_YN', gsAccntSpec);
				var acCodeString = provider.AC_CODE1 + provider.AC_CODE2 + provider.AC_CODE3 + provider.AC_CODE4 + provider.AC_CODE5 + provider.AC_CODE6 + provider.BOOK_CODE1 + provider.BOOK_CODE2;			
				if (acCodeString.indexOf('A4') > -1){
					gsCustCode = 'Y';
					rtnRecord.set('CUST_CODE', gsCustCode);
				}else{
					gsCustCode = 'N';
					rtnRecord.set('CUST_CODE', gsCustCode);
				}
				
				if (acCodeString.indexOf('A3') > -1){
					gsBankCode = 'Y';
					rtnRecord.set('BANK_CODE', gsBankCode);
				}else{
					gsBankCode = 'N';
					rtnRecord.set('BANK_CODE', gsBankCode);
				}
				
				if (acCodeString.indexOf('E1') > -1){
					gsPjtCode = 'Y';
					rtnRecord.set('PROJECT_CODE', gsPjtCode);
				}else{
					gsPjtCode = 'N';
					rtnRecord.set('PROJECT_CODE', gsPjtCode);
				}
			});
		}
		
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}			
			var rv = true;
			switch(fieldName) {
				case "EXCHG_RATE_O" :	//환율
					record.set('AMT_I', newValue * record.get('AMT_FOR_I'));
					record.set('FI_BLN_I', record.get('AMT_I') - record.get('FI_DPR_TOT_I'));
				break;
				
				case "AMT_FOR_I" :	//외화금액
					var dFi_i = record.get('FI_DPR_TOT_I');	//기말비용누계액
					var dExchg_r = record.get('EXCHG_RATE_O');	//환율					
					if((newValue * dExchg_r) < dFi_i){
						rv = Msg.sMA0069;
						break;
					}
					record.set('AMT_I', newValue * dExchg_r);	//금액
					var dAmt_i = record.get('AMT_I');	//금액
					record.set('FI_BLN_I', dAmt_i - dFi_i);		//기말비용누계액
					
				break;
				
				case "AMT_I" :	//금액
					var dFi_i = record.get('FI_DPR_TOT_I');	//기말비용누계액
					if(newValue < dFi_i){
						rv = Msg.sMA0069;
						break;
					}		
					record.set('FI_BLN_I', newValue - dFi_i);	//기말비용누계액
				break;
				
				case "FI_DPR_TOT_I" :	//기말비용누계액
					var dAmt_i = record.get('AMT_I');	//금액
					if(newValue > dAmt_i){
						rv = Msg.sMA0069;
						break;
					}		
					record.set('FI_BLN_I', dAmt_i - newValue);	//기말비용미처리잔액
				break;
			}
			
			return rv;
		}
	});

};


</script>
