<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx326ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var resetButtonFlag = '';

function appMain() {  
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx326ukrService.selectCreditCardList',
			update: 'atx326ukrService.updateDetail',
			create: 'atx326ukrService.insertDetail',
			destroy: 'atx326ukrService.deleteDetail',
			syncAll: 'atx326ukrService.saveAll'
		}
	});	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx326ukrService.selectCashList',
//			update: 'atx326ukrService.updateDetail',
			create: 'atx326ukrService.insertDetail',
//			destroy: 'atx326ukrService.deleteDetail',
			syncAll: 'atx326ukrService.saveAll2'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('atx326ukrModel', {
	    fields: [  	  
	    	{name: 'FR_PUB_DATE'	   , text: 'FR_PUB_DATE' 			,type: 'uniDate'},
	    	{name: 'TO_PUB_DATE'	   , text: 'TO_PUB_DATE' 			,type: 'uniDate'},
	    	{name: 'BILL_DIVI_CODE'    , text: 'BILL_DIVI_CODE' 		,type: 'string'},
	    	{name: 'CASH_DIVI'		   , text: 'CASH_DIVI' 				,type: 'string'},
	    	{name: 'SEQ'		 	   , text: '순번' 					,type: 'int'},
	    	{name: 'MEM_NUM'		   , text: '⑩카드회원번호' 				,type: 'string'},
	    	{name: 'MEM_NUM_EXPOS'	   , text: '⑩카드회원번호' 				,type: 'string' 	,defaultValue: '***************'},
	    	{name: 'CUSTOM_CODE'	   , text: 'CUSTOM_CODE' 			,type: 'string'},
	    	{name: 'COMP_NUM'		   , text: '⑪공급자(가맹점)</br>사업자등록번호'	,type: 'string'},
	    	{name: 'BUSI_CNT'		   , text: '거래건수' 					,type: 'uniQty'},
	    	{name: 'SUPPLY_AMT_I'	   , text: '공급가액' 					,type: 'uniPrice'},
	    	{name: 'TAX_AMT_I'		   , text: '세액' 					,type: 'uniPrice'},
	    	{name: 'UPDATE_DB_USER'    , text: 'UPDATE_DB_USER' 		,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'    , text: 'UPDATE_DB_TIME' 		,type: 'string'},
	    	{name: 'COMP_CODE'    	   , text: '법인코드' 					,type: 'string'}
		]         
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('atx326ukrMasterStore',{
		model: 'atx326ukrModel',
		uniOpt: {
            isMaster:	true,			// 상위 버튼 연결 
            editable:	true,			// 수정 모드 사용 
            deletable:	false,			// 삭제 가능 여부 
	        useNavi:	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();		
			param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			console.log( param );
			atx326ukrService.selectCreditCardList(param, function(provider, request)	{
				panelSearch.setValue('RE_REFERENCE','');
				var records = provider;
				var recordsFirst = records[0];	
				if(!Ext.isEmpty(recordsFirst)){
					
					if(recordsFirst.SAVE_FLAG == 'N'){
						//재참조 삭제 후 저장 조회
						masterGrid.reset();
						directMasterStore.clearData();
						Ext.each(records, function(record,i){	
			        		UniAppManager.app.onNewDataButtonDown(record);
			        		masterGrid.setNewDataCreditCard(record);
				    	}); 
				    	UniAppManager.setToolbarButtons('save',true);
			        	UniAppManager.setToolbarButtons('deleteAll',false);
				    	panelSearch.setValue('RE_REFERENCE_SAVE','Y');
				    	sumTable.getField('txtCreditTaxAmt').focus();
					}else{
						panelSearch.setValue('RE_REFERENCE_SAVE','');
						directMasterStore.loadData(provider);
						directMasterStore.commitChanges();
						UniAppManager.setToolbarButtons('deleteAll',true);
						panelSearch.setValue('RE_REFERENCE_SAVE','');
					}
				}
				sumTable.uniOpt.inLoading=true;
				UniAppManager.app.setSumTableValue();
				sumTable.uniOpt.inLoading=false;
			
			})
			/*this.load({
				params : param
			});*/
		},
		saveStore : function(loadFlag)	{	
			var paramMaster= panelSearch.getValues();
			paramMaster.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			paramMaster.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						if(directMasterStore2.isDirty())	{
							directMasterStore2.saveStore();
						} else {
							panelSearch.setValue('RE_REFERENCE','');
						}
						if(loadFlag != 'no'){
							setTimeout(function(){directMasterStore.loadStoreRecords();}, 1000);
//							UniAppManager.app.setSumTableValue();
						}
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	/*load: function(store, records, successful, eOpts) {
				var recordsFirst = directMasterStore.data.items[0];	
				if(!Ext.isEmpty(recordsFirst)){
					if(recordsFirst.data.SAVE_FLAG == 'N'){
						masterGrid.reset();
						directMasterStore.clearData();
						Ext.each(records, function(record,i){	
			        		UniAppManager.app.onNewDataButtonDown();
			        		masterGrid.setNewDataCreditCard(record.data);
			        		
				    	}); 
				    	UniAppManager.setToolbarButtons('save',true);
			        	UniAppManager.setToolbarButtons('deleteAll',false);
				    	panelSearch.setValue('RE_REFERENCE_SAVE','Y');
				    	sumTable.getField('txtCreditTaxAmt').focus();
					}else{
						UniAppManager.setToolbarButtons('deleteAll',true);
						panelSearch.setValue('RE_REFERENCE_SAVE','');
					}
				}
				sumTable.uniOpt.inLoading=true;
				UniAppManager.app.setSumTableValue();
				sumTable.uniOpt.inLoading=false;
           	},*/
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('atx326ukrModel2', {
	    fields: [  	  
	    	{name: 'FR_PUB_DATE'	   , text: 'FR_PUB_DATE' 			,type: 'uniDate'},
	    	{name: 'TO_PUB_DATE'	   , text: 'TO_PUB_DATE' 			,type: 'uniDate'},
	    	{name: 'BILL_DIVI_CODE'    , text: 'BILL_DIVI_CODE' 		,type: 'string'},
	    	{name: 'CASH_DIVI'		   , text: 'CASH_DIVI' 				,type: 'string'},
	    	{name: 'SEQ'		 	   , text: '순번' 					,type: 'int'},
	    	{name: 'MEM_NUM'		   , text: '⑩카드회원번호' 				,type: 'string'},
	    	{name: 'MEM_NUM_EXPOS'	   , text: '⑩카드회원번호' 				,type: 'string'},
	    	{name: 'CUSTOM_CODE'	   , text: 'CUSTOM_CODE' 			,type: 'string'},
	    	{name: 'COMP_NUM'		   , text: '⑪공급자(가맹점)</br>사업자등록번호'	,type: 'string'},
	    	{name: 'BUSI_CNT'		   , text: '거래건수' 					,type: 'uniQty'},
	    	{name: 'SUPPLY_AMT_I'	   , text: '공급가액' 					,type: 'uniPrice'},
	    	{name: 'TAX_AMT_I'		   , text: '세액' 					,type: 'uniPrice'},
	    	{name: 'UPDATE_DB_USER'    , text: 'UPDATE_DB_USER' 		,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'    , text: 'UPDATE_DB_TIME' 		,type: 'string'},
	    	{name: 'COMP_CODE'    	   , text: '법인코드' 					,type: 'string'}
		]         
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore2 = Unilite.createStore('atx326ukrMasterStore2',{
		model: 'atx326ukrModel2',
		uniOpt: {
            isMaster:	false,			// 상위 버튼 연결 
            editable:	false,			// 수정 모드 사용 
            deletable:	false,			// 삭제 가능 여부 
	        useNavi:	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();	
			param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			console.log( param );
			atx326ukrService.selectCashList(param, function(provider, request){
				panelSearch.setValue('RE_REFERENCE','');
				var records = provider
				var recordsFirst = records[0];	
				if(!Ext.isEmpty(recordsFirst)){
					if(recordsFirst.SAVE_FLAG == 'N'){
						//재참조 삭제 후 저장 조회
						masterGrid2.reset();
						directMasterStore2.clearData();
						Ext.each(records, function(record,i){	
			        		UniAppManager.app.onNewDataButtonDown2(record);
			        		//masterGrid2.setNewDataCash(record.data);	
			        		
				    	}); 
				    	panelSearch.setValue('RE_REFERENCE_SAVE','Y');
				    	UniAppManager.setToolbarButtons('save',true);
			        	UniAppManager.setToolbarButtons('deleteAll',false);
					}else {

				    	panelSearch.setValue('RE_REFERENCE_SAVE','');
						directMasterStore2.loadData(provider);
						directMasterStore.commitChanges();
					}
				}
				sumTable.uniOpt.inLoading=true;
				UniAppManager.app.setSumTableValue();
				sumTable.uniOpt.inLoading=false;
			})
			/*this.load({
				params : param
			});*/
		},
		saveStore : function(loadFlag)	{	
			var paramMaster= panelSearch.getValues();
			paramMaster.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			paramMaster.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						if(loadFlag != 'no'){
							panelSearch.setValue('RE_REFERENCE','');
							setTimeout(function(){directMasterStore2.loadStoreRecords();}, 1000);
//							UniAppManager.app.setSumTableValue();
						}
						UniAppManager.setToolbarButtons('save',false);
//						directMasterStore2.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	/*load: function(store, records, successful, eOpts) {
				var recordsFirst = directMasterStore2.data.items[0];	
				if(!Ext.isEmpty(recordsFirst)){
					if(recordsFirst.data.SAVE_FLAG == 'N'){
						masterGrid2.reset();
						directMasterStore2.clearData();
						Ext.each(records, function(record,i){	
			        		UniAppManager.app.onNewDataButtonDown2(record.data);
			        		//masterGrid2.setNewDataCash(record.data);	
			        		
				    	}); 
				    	UniAppManager.setToolbarButtons('save',true);
			        		UniAppManager.setToolbarButtons('deleteAll',false);
					}
				}
				sumTable.uniOpt.inLoading=true;
				UniAppManager.app.setSumTableValue();
				sumTable.uniOpt.inLoading=false;
           	},*/
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
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
		    items : [{ 
    			fieldLabel: '계산서일',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'FR_PUB_DATE',
		        endFieldName: 'TO_PUB_DATE',
		        width: 470,
		        startDD:'first',
		        endDD:'last',
		        holdable: 'hold',
		        allowBlank: false,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
		        	if(panelResult) {
						panelResult.setValue('FR_PUB_DATE',newValue);
		        	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_PUB_DATE',newValue);
			    	}
			    }
	        },{
				fieldLabel: '신고사업장', 
				name: 'BILL_DIVI_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode	: 'BILL',
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('BILL_DIVI_CODE', newValue);
					}
				}
			},{
				fieldLabel: '신고일자',
		 		xtype: 'uniDatefield',
		 		name: 'WRITE_DATE',
		        value: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WRITE_DATE', newValue);
					}
				}
			},{
	    		xtype: 'button',
	    		text: '재참조',
	    		width: 100,
	    		margin: '0 0 0 120', 
//	    		id:'temp20',
	    		handler : function() {
	    			if(!UniAppManager.app.checkForNewDetail()){
						return false;
					}else{
						var param = {"FR_PUB_DATE": panelSearch.getField('FR_PUB_DATE').getStartDate(),
							"TO_PUB_DATE": panelSearch.getField('TO_PUB_DATE').getEndDate(),
							"BILL_DIVI_CODE": panelSearch.getValue('BILL_DIVI_CODE')
						};
						atx326ukrService.dataCheck(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								if(confirm('이미 데이터가 존재합니다. 다시 생성하시면 기존 데이터가 삭제됩니다. 그래도 생성하시겠습니까?')) {
									panelSearch.setValue('RE_REFERENCE','Y');
									
									UniAppManager.app.onQueryButtonDown();
									panelSearch.setValue('RE_REFERENCE','');
									UniAppManager.setToolbarButtons('deleteAll',false);	
									UniAppManager.setToolbarButtons('query',false);
									UniAppManager.setToolbarButtons('save',true);	
								}else{
				    				return false;
				    			}
		    				}else{
		    					panelSearch.setValue('RE_REFERENCE','Y');
									
								UniAppManager.app.onQueryButtonDown();
								panelSearch.setValue('RE_REFERENCE','');
								UniAppManager.setToolbarButtons('deleteAll',false);	
								UniAppManager.setToolbarButtons('query',false);	
								UniAppManager.setToolbarButtons('save',true);	
		    				}
						});
					}
				}
	    	},{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		margin: '0 0 0 120', 
//	    		id:'temp20',
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					UniAppManager.app.onPrintButtonDown('');	
				}
	    	},{
	    		xtype: 'button',
	    		text: '파일저장',
	    		width: 100,
	    		margin: '0 0 0 120', 
//	    		id:'temp20',
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					var param = panelSearch.getValues();
				}
	    	},{
	    		xtype: 'button',
	    		text: '카드명세',
	    		width: 100,
	    		margin: '0 0 0 120', 
//	    		id:'temp20',
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
//					var param = panelSearch.getValues();
//					param['PROOF_KIND'] = 'E';
					UniAppManager.app.onPrintButtonDown('E');
				}
	    	},{
	    		xtype: 'button',
	    		text: '현금명세',
	    		width: 100,
	    		margin: '0 0 0 120', 
//	    		id:'temp20',
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
//					var param = panelSearch.getValues();
//					param['PROOF_KIND'] = 'F';
					UniAppManager.app.onPrintButtonDown('F');
				}
	    	},{
	    		xtype:'uniTextfield',
	    		name:'RE_REFERENCE',
	    		text:'재참조버튼클릭관련',
	    		hidden:true
	    	},{
	    		xtype:'uniTextfield',
	    		name:'RE_REFERENCE_SAVE',
	    		text:'재참조버튼클릭관련저장플래그',
	    		hidden:true
	    	}]		
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});   
	
    //fileDown submitForm
    var panelFileDown = Unilite.createForm('FileDownForm', {
        url: CPATH+'/accnt/fileDown.do',
        colspan: 2,
        layout: {type: 'uniTable', columns: 1},
        height: 30,
        padding: '0 0 0 195',
        disabled:false,
        autoScroll: false,
        standardSubmit: true,  
        items:[{
            xtype: 'uniTextfield',
            name: 'FR_PUB_DATE'
        },{
            xtype: 'uniTextfield',
            name: 'TO_PUB_DATE'
        },{
            xtype: 'uniTextfield',
            name: 'BILL_DIVI_CODE'
        },{
            xtype: 'uniTextfield',
            name: 'WRITE_DATE'
        }]
    });
    
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 6,
			tableAttrs: { width: '100%'},
			tdAttrs: { align : 'center'/*,width:200*/}
		},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '계산서일',
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'FR_PUB_DATE',
	        endFieldName: 'TO_PUB_DATE',
	        width: 350,
	        startDD:'first',
		    endDD:'last',
	        holdable: 'hold',
	        allowBlank: false,
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	        	if(panelSearch) {
					panelSearch.setValue('FR_PUB_DATE',newValue);
	        	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_PUB_DATE',newValue);
		    	}
		    }
        },{
			fieldLabel: '신고사업장', 
			name: 'BILL_DIVI_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode	: 'BILL',
			holdable: 'hold',
			allowBlank: false,
			width: 250,
//			tableAttrs: {width: '100%'},
			tdAttrs: {/*align : 'left'*/width:350},
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					panelSearch.setValue('BILL_DIVI_CODE', newValue);
				}
			}
		},{
			fieldLabel: '신고일자',
	 		xtype: 'uniDatefield',
	 		name: 'WRITE_DATE',
	        value: UniDate.get('today'),
	        width: 250,
//			tableAttrs: {width: '100%'},
			tdAttrs: {/*align : 'left'*/width:350},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WRITE_DATE', newValue);
				}
			}
		},{
    		xtype: 'button',
    		text: '재참조',
    		width: 100,
    		margin: '0 0 0 0',
//    		tableAttrs: {width: '100%'},
			tdAttrs: {align : 'right',width: '100%'},
    		handler : function() {
				if(!UniAppManager.app.checkForNewDetail()){
					return false;
				}else{
					var param = {"FR_PUB_DATE": panelSearch.getField('FR_PUB_DATE').getStartDate(),
						"TO_PUB_DATE": panelSearch.getField('TO_PUB_DATE').getEndDate(),
						"BILL_DIVI_CODE": panelSearch.getValue('BILL_DIVI_CODE')
					};
					atx326ukrService.dataCheck(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
							if(confirm('이미 데이터가 존재합니다. 다시 생성하시면 기존 데이터가 삭제됩니다. 그래도 생성하시겠습니까?')) {
								panelSearch.setValue('RE_REFERENCE','Y');
								
								UniAppManager.app.onQueryButtonDown();
								
								
								UniAppManager.setToolbarButtons('deleteAll',false);	
								UniAppManager.setToolbarButtons('query',false);
								UniAppManager.setToolbarButtons('save',true);	
							}else{
			    				return false;
			    			}
	    				}else{
	    					panelSearch.setValue('RE_REFERENCE','Y');
								
							UniAppManager.app.onQueryButtonDown();
							
							UniAppManager.setToolbarButtons('deleteAll',false);	
							UniAppManager.setToolbarButtons('query',false);
							UniAppManager.setToolbarButtons('save',true);	
	    				}
					});
				}
			}
    	},{
    		xtype: 'button',
    		text: '출력',
    		width: 100,
    		margin: '0 0 0 0',
//    		tableAttrs: {width: '100%'},
			tdAttrs: {align : 'center',width: '100%'},
    		handler : function() {
				var me = this;
				panelSearch.getEl().mask('로딩중...','loading-indicator');
				UniAppManager.app.onPrintButtonDown('');						
			}
    	},{
    		xtype: 'button',
    		text: '파일저장',
    		width: 100,
    		margin: '0 0 0 0',
//    		tableAttrs: {width: '100%'},
			tdAttrs: {align : 'left',width: '100%'},
    		handler : function() {
				var me = this;
				var form = panelFileDown;
				panelSearch.getEl().mask('로딩중...','loading-indicator');
				var param = panelResult.getValues();
				
			    form.setValue('FR_PUB_DATE', panelSearch.getField('FR_PUB_DATE').getStartDate());
			    form.setValue('TO_PUB_DATE', panelSearch.getField('TO_PUB_DATE').getEndDate());
                form.setValue('BILL_DIVI_CODE', panelSearch.getValue('BILL_DIVI_CODE'));
                form.setValue('WRITE_DATE', UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE')));                   
				
				atx326ukrService.fnGetFileCheck(param, function(provider, response)  {
					console.log("provider :: " + provider["ERROR_DESC"]);
                       if(provider){
                           form.submit({
                            params: param,
                            success:function(comp, action)  {
//                                Ext.getBody().unmask();
                            },
                            failure: function(form, action){
//                                Ext.getBody().unmask();
                            }                   
                        }); 
                       }else{
//                         Ext.getBody().unmask();
                       }
                    });
			}
    	},{
    		xtype: 'button',
    		text: '카드명세',
    		width: 100,
    		margin: '0 0 0 0',
//    		tableAttrs: {width: '100%'},
			tdAttrs: {align : 'right',width: '100%'},
			colspan:4,
    		handler : function() {
				var me = this;
				panelSearch.getEl().mask('로딩중...','loading-indicator');
				var param = panelResult.getValues();
				UniAppManager.app.onPrintButtonDown('E');	
			}
    	},{
    		xtype: 'button',
    		text: '현금명세',
    		width: 100,
    		margin: '0 0 0 0',
//    		tableAttrs: {width: '100%'},
			tdAttrs: {align : 'center',width: '100%'},
    		handler : function() {
				var me = this;
				panelSearch.getEl().mask('로딩중...','loading-indicator');
				var param = panelResult.getValues();
				UniAppManager.app.onPrintButtonDown('F');
			}
    	}
	],
	setAllFieldsReadOnly: function(b) {
		var r= true
		if(b) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
																return !field.validate();
															});
			if(invalid.length > 0) {
				r=false;
				var labelText = ''

				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}
			   	alert(labelText+Msg.sMB083);
			   	invalid.items[0].focus();
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(true); 
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;							
						if(popupFC.holdable == 'hold') {
							popupFC.setReadOnly(true);
						}
					}
				})      
			}
  		} else {
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) )	{
				 	if (item.holdable == 'hold') {
						item.setReadOnly(false);
					}
				} 
				if(item.isPopupField)	{
					var popupFC = item.up('uniPopupField')	;	
					if(popupFC.holdable == 'hold' ) {
						item.setReadOnly(false);
					}
				}
			})
		}
		return r;
		}
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var sumTable = Unilite.createForm('detailForm', { //createForm
		padding:'0 0 0 0',
	    title:'2. 신용카드 등 매입내역 합계',
		//border: 0,
		disabled: false,
		flex: 1.5,
		bodyPadding: 10,
		
		region: 'center',
	    layout: {type: 'uniTable', columns: 4, 
			tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		defaults:{width: 140},
	    items: [
			{xtype: 'component',  html:'구&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;분'},
	    	{xtype: 'component',  html:'거래건수'},
	    	{xtype: 'component',  html:'공급가액'},
	    	{xtype: 'component',  html:'세액'},
	
			{xtype: 'component',  html:'⑤합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계'},
	    	{name:'txtTotBusiCnt',	xtype: 'uniNumberfield', value:0, readOnly:true},
	    	{name:'txtTotSupplyAmt',xtype: 'uniNumberfield', value:0, readOnly:true},
	    	{name:'txtTotTaxAmt',	xtype: 'uniNumberfield', value:0, readOnly:true},
	
			{xtype: 'component',  html:'⑥현&nbsp;&nbsp;&nbsp;금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;영&nbsp;&nbsp;&nbsp;수&nbsp;&nbsp;&nbsp;증'},
	    	{name:'txtCashBusiCnt',	xtype: 'uniNumberfield', value:0, readOnly:true},
	    	{name:'txtCashSupplyAmt',xtype: 'uniNumberfield', value:0, readOnly:true},
	    	{name:'txtCashTaxAmt',	xtype: 'uniNumberfield', value:0, readOnly:true},
	
			{xtype: 'component',  html:'⑦화물운전자 복지카드'},
	    	{name:'txtCreditBusiCnt2',	xtype: 'uniNumberfield', value:0, readOnly:true},
	    	{name:'txtCreditSupplyAmt2',xtype: 'uniNumberfield', value:0, readOnly:true},
	    	{name:'txtCreditTaxAmt2',	xtype: 'uniNumberfield', value:0, readOnly:true},
	
			{xtype: 'component',  html:'⑧사&nbsp;업&nbsp;용&nbsp;&nbsp;&nbsp;신&nbsp;용&nbsp;카&nbsp;드'},
	    	{name:'txtCreditBusiCnt3',	xtype: 'uniNumberfield', value:0, readOnly:true},
	    	{name:'txtCreditSupplyAmt3',xtype: 'uniNumberfield', value:0, readOnly:true},
	    	{name:'txtCreditTaxAmt3',	xtype: 'uniNumberfield', value:0, readOnly:true},
	    	
	    	{xtype: 'component',  html:'⑨기&nbsp;타&nbsp;&nbsp;신&nbsp;용&nbsp;카&nbsp;드&nbsp;&nbsp;등'},
	    	{name:'txtCreditBusiCnt',	xtype: 'uniNumberfield', value:0, readOnly:true},
	    	{name:'txtCreditSupplyAmt',	xtype: 'uniNumberfield', value:0, readOnly:true},
	    	{name:'txtCreditTaxAmt',	xtype: 'uniNumberfield', value:0, readOnly:true}
		]
	});
	
    var masterGrid = Unilite.createGrid('atx326ukrGrid', {
    	region:'south',
    	store: directMasterStore,
    	excelTitle: '신용카드매출전표수령명세서',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false, enableGroupingMenu:false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [        
			{dataIndex: 'FR_PUB_DATE'	    	, width: 66  , hidden: true},
			{dataIndex: 'TO_PUB_DATE'	    	, width: 66  , hidden: true},
			{dataIndex: 'BILL_DIVI_CODE'     	, width: 66  , hidden: true},
			{dataIndex: 'CASH_DIVI'		    	, width: 80  , hidden: true},
			{dataIndex: 'SEQ'		 	    	, width: 80  , hidden: true},
			{dataIndex: 'MEM_NUM'		    	, width: 250 , hidden: true
//				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
//	        		return (val.substring(0,4) + '-' + val.substring(4,8) + '-' + val.substring(8,12) + '-' + val.substring(12));
//	            }
			},
        	{dataIndex: 'MEM_NUM_EXPOS'    	    , width: 120 },			
			{dataIndex: 'CUSTOM_CODE'	    	, width: 133 , hidden: true},
			{dataIndex: 'COMP_NUM'		    	, width: 250/*,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
	        		return (val.substring(0,3) + '-' + val.substring(3,5) + '-' + val.substring(5));
	            }*/
			},
				{text :'⑫기타 신용카드 등 거래내역 합계',
				columns:[
					{dataIndex: 'BUSI_CNT'		    	, width: 130},
					{dataIndex: 'SUPPLY_AMT_I'	    	, width: 200},
					{dataIndex: 'TAX_AMT_I'		    	, width: 200}
				]},
			{dataIndex: 'SUPPLY_AMT_I'     	, width: 50   , hidden: false},	
				
			{dataIndex: 'UPDATE_DB_USER'     	, width: 50   , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'     	, width: 50   , hidden: true},
			{dataIndex: 'COMP_CODE'     	, width: 80   , hidden: true}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['MEM_NUM_EXPOS'])){
					return false;
				}else{
					return false;
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
				if(colName =="MEM_NUM_EXPOS") {
					grid.ownerGrid.openCryptCardNoPopup(record);
				}
				
  			}
		},
		openCryptCardNoPopup:function( record )	{
			if(record)	{
				var params = {'CRDT_FULL_NUM': record.get('MEM_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'MEM_NUM_EXPOS', 'MEM_NUM', params);
			}
				
		},
		setNewDataCreditCard:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('FR_PUB_DATE'			,record['FR_PUB_DATE']);
			grdRecord.set('TO_PUB_DATE'			,record['TO_PUB_DATE']);
			grdRecord.set('BILL_DIVI_CODE'		,record['BILL_DIVI_CODE']);
			grdRecord.set('CASH_DIVI'			,record['CASH_DIVI']);
//			grdRecord.set('SEQ'					,record['SEQ']);	
			grdRecord.set('MEM_NUM'				,record['MEM_NUM']);
			grdRecord.set('CUSTOM_CODE'			,record['CUSTOM_CODE']);
			grdRecord.set('COMP_NUM'			,record['COMP_NUM']);
			grdRecord.set('BUSI_CNT'			,record['BUSI_CNT']);
			grdRecord.set('SUPPLY_AMT_I'		,record['SUPPLY_AMT_I']);
			grdRecord.set('TAX_AMT_I'			,record['TAX_AMT_I']);
			grdRecord.set('COMP_CODE'			,record['COMP_CODE']);
			
//			UniAppManager.setToolbarButtons('save',true);
		}
    });
    var masterGrid2 = Unilite.createGrid('atx326ukrGrid2', {
    	region:'east',
    	hidden:true,
    	store: directMasterStore2,
    	excelTitle: '신용카드매출전표수령명세서',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			copiedRow:false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [        
			{dataIndex: 'FR_PUB_DATE'	    	, width: 66  , hidden: true},
			{dataIndex: 'TO_PUB_DATE'	    	, width: 66  , hidden: true},
			{dataIndex: 'BILL_DIVI_CODE'     	, width: 66  , hidden: true},
			{dataIndex: 'CASH_DIVI'		    	, width: 80  , hidden: true},
			{dataIndex: 'SEQ'		 	    	, width: 80  , hidden: true},
			{dataIndex: 'MEM_NUM'		    	, width: 250},
			{dataIndex: 'CUSTOM_CODE'	    	, width: 133 , hidden: true},
			{dataIndex: 'COMP_NUM'		    	, width: 250},
				{text :'⑫신용카드 등 거래내역',
				columns:[
					{dataIndex: 'BUSI_CNT'		    	, width: 130},
					{dataIndex: 'SUPPLY_AMT_I'	    	, width: 200},
					{dataIndex: 'TAX_AMT_I'		    	, width: 200}
				]},
			{dataIndex: 'UPDATE_DB_USER'     	, width: 50   , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'     	, width: 50   , hidden: true},
			{dataIndex: 'COMP_CODE'     	, width: 80   , hidden: true}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			}
		},
		setNewDataCash:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('FR_PUB_DATE'			,record['FR_PUB_DATE']);
			grdRecord.set('TO_PUB_DATE'			,record['TO_PUB_DATE']);
			grdRecord.set('BILL_DIVI_CODE'		,record['BILL_DIVI_CODE']);
			grdRecord.set('CASH_DIVI'			,record['CASH_DIVI']);
//			grdRecord.set('SEQ'					,record['SEQ']);	
			grdRecord.set('MEM_NUM'				,record['MEM_NUM']);
			grdRecord.set('CUSTOM_CODE'			,record['CUSTOM_CODE']);
			grdRecord.set('COMP_NUM'			,record['COMP_NUM']);
			grdRecord.set('BUSI_CNT'			,record['BUSI_CNT']);
			grdRecord.set('SUPPLY_AMT_I'		,record['SUPPLY_AMT_I']);
			grdRecord.set('TAX_AMT_I'			,record['TAX_AMT_I']);
			grdRecord.set('COMP_CODE'			,record['COMP_CODE']);
//			UniAppManager.setToolbarButtons('save',true);
		}        
    }); 
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			items:[
				sumTable,
				{
					border: false,	
					flex: 2.5,
					layout: {type: 'vbox', align: 'stretch'},
					region: 'south',
					items: [{
						title :'3. 기타 신용.직불카드 및 기명식선불카드 매출전표 수령금액 합계',
						region: 'center',
						border: false
					},masterGrid,masterGrid2
					]				
				},panelResult
			]	
		}		
		,panelSearch
		],
		id : 'atx326ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('query',true);
			UniAppManager.setToolbarButtons(['newData','reset','deleteAll'],false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_PUB_DATE');
			this.setDefault();
		},
		onQueryButtonDown : function()	{	
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore.loadStoreRecords();
				directMasterStore2.loadStoreRecords();
				UniAppManager.setToolbarButtons('reset',true);
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function(r)	{
			if(!this.checkForNewDetail()) return false;
				
				 var seq = directMasterStore.max('SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
            	r.SEQ= seq;
            	
		        if(Ext.isEmpty(r.FR_PUB_DATE))	{
		        	r.FR_PUB_DATE = UniDate.getDbDateStr( panelSearch.getValue("FR_PUB_DATE"));
		        }
		        if(Ext.isEmpty(r.TO_PUB_DATE))	{
		        	r.FR_PUB_DATE = UniDate.getDbDateStr( panelSearch.getValue("TO_PUB_DATE"));
		        }
		        if(Ext.isEmpty(r.BILL_DIVI_CODE))	{
		        	r.BILL_DIVI_CODE =  panelSearch.getValue("BILL_DIVI_CODE");
		        }
				masterGrid.createRow(r);
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
//				UniAppManager.setToolbarButtons('save',true);
			},
		onNewDataButtonDown2: function(r)	{
			if(!this.checkForNewDetail()) return false;
				
				var seq = directMasterStore2.max('SEQ');
            	if(!seq){
            		seq = 1;
            	}else{
            		seq += 1;
            	}
            	
            	r.SEQ= seq;
				
            	if(Ext.isEmpty(r.FR_PUB_DATE))	{
		        	r.FR_PUB_DATE = UniDate.getDbDateStr( panelSearch.getValue("FR_PUB_DATE"));
		        }
		        if(Ext.isEmpty(r.TO_PUB_DATE))	{
		        	r.FR_PUB_DATE = UniDate.getDbDateStr( panelSearch.getValue("TO_PUB_DATE"));
		        }
		        if(Ext.isEmpty(r.BILL_DIVI_CODE))	{
		        	r.BILL_DIVI_CODE =  panelSearch.getValue("BILL_DIVI_CODE");
		        }
		        
				masterGrid2.createRow(r);
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
//				UniAppManager.setToolbarButtons('save',true);
			},
		onResetButtonDown: function() {	
			resetButtonFlag = 'Y';
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
//			panelSearch.clearForm();
			masterGrid.reset();
			masterGrid2.reset();
//			panelResult.clearForm();
			sumTable.clearForm();
			directMasterStore.clearData();
			directMasterStore2.clearData();
			UniAppManager.setToolbarButtons('save',false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(loadFlag) {
			if(directMasterStore.isDirty())	{
				directMasterStore.saveStore(loadFlag);
			} else {
				directMasterStore2.saveStore(loadFlag);
			}
//			directMasterStore2.saveStore();
			/*var param= sumTable.getValues();
			param.FR_PUB_DATE = UniDate.getDbDateStr(panelSearch.getValue("FR_PUB_DATE"));
			param.TO_PUB_DATE = UniDate.getDbDateStr(panelSearch.getValue("TO_PUB_DATE"));
			param.BILL_DIVI_CODE = panelSearch.getValue("BILL_DIVI_CODE");
			
			sumTable.getForm().submit({
			params : param,
				success : function(form, action) {
	 				sumTable.getForm().wasDirty = false;
					sumTable.resetDirtyStatus();											
					UniAppManager.setToolbarButtons('save', false);	
	            	UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
				}	
			});*/
		},
		onDeleteAllButtonDown: function() {			
			if(confirm('전체삭제 하시겠습니까?')) {
				masterGrid.reset();
				masterGrid2.reset();	
				UniAppManager.app.onSaveDataButtonDown('no');	
				UniAppManager.app.onResetButtonDown();
			}
		},
		onPrintButtonDown: function(kind) {
			var param= Ext.getCmp('searchForm').getValues();
			
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();
			param['FR_PUB_DATE'] = startDateValue;
			param['TO_PUB_DATE'] = endDateValue;
			param['PROOF_KIND'] = kind;
//			var win = Ext.create('widget.PDFPrintWindow', {
//				url: CPATH+'/atx/atx326ukr.do',
//				prgID: 'atx326ukr',
//				extParam: param
//				});
			
			panelSearch.getEl().unmask();
			
			if(kind == 'E') {
				param.sTxtValue2_fileTitle = '신용카드매출전표 등 수령명세서(신용카드 관리용)';
			}
			else if(kind == 'F') {
				param.sTxtValue2_fileTitle = '신용카드매출전표 등 수령명세서(현금영수증 관리용)';
			}
			else {
				param.sTxtValue2_fileTitle = '신용카드매출전표 등 수령명세서';
			}
			
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/accnt/atx326clrkrv.do',
				prgID: 'atx326ukr',
				extParam: param
			});
			win.center();
			win.show();
		},
		
		setDefault: function() {
			if(resetButtonFlag != 'Y'){
	        	panelSearch.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));//UniDate.get('startOfMonth'));//추후 uniMonthRangefield holdable 기능 추가시 uniMonthRangefield로 변경필요
	        	panelSearch.setValue('TO_PUB_DATE',UniDate.get('endOfMonth'));//UniDate.get('endOfMonth'));
	        	panelSearch.setValue('BILL_DIVI_CODE',baseInfo.gsBillDivCode);
	        	panelSearch.setValue('WRITE_DATE',UniDate.get('today'));
	        	panelResult.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));//UniDate.get('startOfMonth'));
	        	panelResult.setValue('TO_PUB_DATE',UniDate.get('endOfMonth'));//UniDate.get('endOfMonth'));
	        	panelResult.setValue('BILL_DIVI_CODE',baseInfo.gsBillDivCode);
	        	panelResult.setValue('WRITE_DATE',UniDate.get('today'));
			}
        	
        	sumTable.setValue('txtTotBusiCnt',0);
        	sumTable.setValue('txtTotSupplyAmt',0);
        	sumTable.setValue('txtTotTaxAmt',0);
        	sumTable.setValue('txtCashBusiCnt',0);
        	sumTable.setValue('txtCashSupplyAmt',0);
        	sumTable.setValue('txtCashTaxAmt',0);
        	sumTable.setValue('txtCreditBusiCnt2',0);
        	sumTable.setValue('txtCreditSupplyAmt2',0);
        	sumTable.setValue('txtCreditTaxAmt2',0);
        	sumTable.setValue('txtCreditBusiCnt3',0);
        	sumTable.setValue('txtCreditSupplyAmt3',0);
        	sumTable.setValue('txtCreditTaxAmt3',0);
        	sumTable.setValue('txtCreditBusiCnt',0);
        	sumTable.setValue('txtCreditSupplyAmt',0);	
        	sumTable.setValue('txtCreditTaxAmt',0);
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        setSumTableValue:function() {
			sumTable.setValue('txtTotBusiCnt',0);
        	sumTable.setValue('txtTotSupplyAmt',0);
        	sumTable.setValue('txtTotTaxAmt',0);
        	sumTable.setValue('txtCashBusiCnt',0);
        	sumTable.setValue('txtCashSupplyAmt',0);
        	sumTable.setValue('txtCashTaxAmt',0);
        	sumTable.setValue('txtCreditBusiCnt2',0);
        	sumTable.setValue('txtCreditSupplyAmt2',0);
        	sumTable.setValue('txtCreditTaxAmt2',0);
        	sumTable.setValue('txtCreditBusiCnt3',0);
        	sumTable.setValue('txtCreditSupplyAmt3',0);
        	sumTable.setValue('txtCreditTaxAmt3',0);
        	sumTable.setValue('txtCreditBusiCnt',0);
        	sumTable.setValue('txtCreditSupplyAmt',0);	
        	sumTable.setValue('txtCreditTaxAmt',0);
        	
        	var amt1 = 0;
        	var tax1 = 0;
        	var cnt1 = 0;
        	var amt2 = 0;
        	var tax2 = 0;
        	var cnt2 = 0;
        	var amt3 = 0;
        	var tax3 = 0;
        	var cnt3 = 0;
        	
        	var records = directMasterStore.data.items;
        	Ext.each(records, function(record,i){	
        		if(record.get('CASH_DIVI') == '1'){
        			amt1 = amt1 + record.get('SUPPLY_AMT_I');
        			tax1 = tax1 + record.get('TAX_AMT_I');
        			cnt1 = cnt1 + record.get('BUSI_CNT');
        		}else if(record.get('CASH_DIVI') == '4'){
        			amt3 = amt3 + record.get('SUPPLY_AMT_I');
        			tax3 = tax3 + record.get('TAX_AMT_I');
        			cnt3 = cnt3 + record.get('BUSI_CNT');	
        		}
        	});
        	
        	sumTable.setValue('txtCreditBusiCnt',cnt1);
        	sumTable.setValue('txtCreditSupplyAmt',amt1);
        	sumTable.setValue('txtCreditTaxAmt',tax1);
        	sumTable.setValue('txtCreditBusiCnt3',cnt3);
        	sumTable.setValue('txtCreditSupplyAmt3',amt3);
        	sumTable.setValue('txtCreditTaxAmt3',tax3);
        	
        	
        	amt1 = 0;
        	tax1 = 0;
        	cnt1 = 0;
        	amt2 = 0;
        	tax2 = 0;
        	cnt2 = 0;
        	amt3 = 0;
        	tax3 = 0;
        	cnt3 = 0;
        	
        	
        	
        	var records2 = directMasterStore2.data.items;
        	Ext.each(records2, function(record,i){	
        		if(record.get('CASH_DIVI') == '2'){
        			amt1 = amt1 + record.get('SUPPLY_AMT_I');
        			tax1 = tax1 + record.get('TAX_AMT_I');
        			cnt1 = cnt1 + record.get('BUSI_CNT');
        		}else if(record.get('CASH_DIVI') == '3'){
        			amt2 = amt2 + record.get('SUPPLY_AMT_I');
        			tax2 = tax2 + record.get('TAX_AMT_I');
        			cnt2 = cnt2 + record.get('BUSI_CNT');	
        		}else if(record.get('CASH_DIVI') == '4'){
        			amt3 = amt3 + record.get('SUPPLY_AMT_I');
        			tax3 = tax3 + record.get('TAX_AMT_I');
        			cnt3 = cnt3 + record.get('BUSI_CNT');
        		}
        	});
        	
        	sumTable.setValue('txtCashBusiCnt',cnt1);
        	sumTable.setValue('txtCashSupplyAmt',amt1);
        	sumTable.setValue('txtCashTaxAmt',tax1);
        	sumTable.setValue('txtCreditBusiCnt2',cnt2);
        	sumTable.setValue('txtCreditSupplyAmt2',amt2);
        	sumTable.setValue('txtCreditTaxAmt2',tax2);
        	sumTable.setValue('txtCreditBusiCnt3',cnt3);
        	sumTable.setValue('txtCreditSupplyAmt3',amt3);
        	sumTable.setValue('txtCreditTaxAmt3',tax3);
        	
        	sumTable.setValue('txtTotBusiCnt',sumTable.getValue('txtCreditBusiCnt') + sumTable.getValue('txtCashBusiCnt') 
        									+ sumTable.getValue('txtCreditBusiCnt2') + sumTable.getValue('txtCreditBusiCnt3'));
        	sumTable.setValue('txtTotSupplyAmt',sumTable.getValue('txtCreditSupplyAmt') + sumTable.getValue('txtCashSupplyAmt') 
        									+ sumTable.getValue('txtCreditSupplyAmt2') + sumTable.getValue('txtCreditSupplyAmt3'));
        	sumTable.setValue('txtTotTaxAmt',sumTable.getValue('txtCreditTaxAmt') + sumTable.getValue('txtCashTaxAmt') 
        									+ sumTable.getValue('txtCreditTaxAmt2') + sumTable.getValue('txtCreditTaxAmt3'));
        }
	});
};


</script>
