<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx450ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A035" /> <!-- 완료구분-->
	<t:ExtComboStore comboType="AU" comboCode="A039" /> <!-- 매각구분-->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 자본적지출-->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var bLoadingStore1 = false;
var bLoadingStore2 = false;
var bLoadingStore3 = false;
var bLoadingStore4 = false;
var bAddedRow = false;
var gsReportGubun = '${gsReportGubun}';

function appMain() {    
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}

	var selectedMasterGrid = 'atx450ukrGrid';   
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx450ukrService.selectList',
			create: 'atx450ukrService.insertDetail',
			update: 'atx450ukrService.updateDetail',
			syncAll: 'atx450ukrService.saveAll'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx450ukrService.selectList2',
			update: 'atx450ukrService.updateDetail2',
			create: 'atx450ukrService.insertDetail2',
			destroy: 'atx450ukrService.deleteDetail2',
			syncAll: 'atx450ukrService.saveAll2'
		}
	});
	
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx450ukrService.selectList3',
			update: 'atx450ukrService.updateDetail3',
			create: 'atx450ukrService.insertDetail3',
			destroy: 'atx450ukrService.deleteDetail3',
			syncAll: 'atx450ukrService.saveAll3'
		}
	});
	
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx450ukrService.selectList4',
			update: 'atx450ukrService.updateDetail4',
			create: 'atx450ukrService.insertDetail4',
			destroy: 'atx450ukrService.deleteDetail4',
			syncAll: 'atx450ukrService.saveAll4'
		}
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('atx450ukrModel', {
	    fields: [  	  
	    	{name: 'FR_PUB_DATE'		, text: 'FR_PUB_DATE' 			,type: 'uniDate'},
		    {name: 'TO_PUB_DATE'		, text: 'TO_PUB_DATE' 			,type: 'uniDate'},
		    {name: 'BILL_DIV_CODE'		, text: 'BILL_DIV_CODE' 		,type: 'string'},
		    {name: 'GUBUN'				, text: '불공제</br>코드' 			,type: 'string'},
		    {name: 'CODE_NAME'			, text: '불공제사유' 				,type: 'string'},
		    {name: 'NUM'				, text: '매수' 					,type: 'int'},
		    {name: 'SUPPLY_AMT'			, text: '공급가액' 				,type: 'uniPrice'},
		    {name: 'TAX_AMT' 			, text: '매입세액' 				,type: 'uniPrice'},
		    {name: 'REMARK' 			, text: '비고' 					,type: 'string'},
		    {name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER' 		,type: 'string'},
		    {name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME' 		,type: 'string'},
		    {name: 'UPDATE_DB_TIME'		, text: 'COMP_CODE' 			,type: 'string'},
		    {name: 'COMP_CODE'			, text: 'COMP_CODE' 			,type: 'string'}
		]
	});
	
	Unilite.defineModel('atx450ukrModel2', {
	    fields: [
		    {name: 'FR_PUB_DATE'		, text: 'FR_PUB_DATE' 					,type: 'uniDate'},
		    {name: 'TO_PUB_DATE'		, text: 'TO_PUB_DATE' 					,type: 'uniDate'},
		    {name: 'BILL_DIV_CODE'		, text: 'BILL_DIV_CODE' 				,type: 'string'},
		    {name: 'SEQ'				, text: '일련번호' 						,type: 'int'},
		    {name: 'SUPPLY_AMT'			, text: '⑩공급가액' 						,type: 'uniPrice'},
		    {name: 'TAX_AMT'			, text: '⑪세    액' 						,type: 'uniPrice'},
		    {name: 'TOT_SUPPLY_AMT'		, text: '⑫ 총공급가액등' 					,type: 'uniPrice'},
		    {name: 'TAXFREE_AMT' 		, text: '⑬ 면세공급가액등' 					,type: 'uniPrice'},
		    {name: 'NONTAX_AMT' 		, text: '⑭ 불공제매입세액</br>[⑪x(⑬÷⑫)]' 	,type: 'uniPrice'},
		    {name: 'REMARK' 			, text: '비고' 							,type: 'string'},
		    {name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER' 				,type: 'string'},
		    {name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME' 				,type: 'string'},
		    {name: 'COMP_CODE'			, text: 'COMP_CODE' 					,type: 'string'}
		]
	});
	Unilite.defineModel('atx450ukrModel3', {
	    fields: [
		    {name: 'FR_PUB_DATE'		, text: 'FR_PUB_DATE' 								,type: 'uniDate'},
			{name: 'TO_PUB_DATE'		, text: 'TO_PUB_DATE' 								,type: 'uniDate'},
			{name: 'BILL_DIV_CODE'		, text: 'BILL_DIV_CODE' 							,type: 'string'},
			{name: 'SEQ'				, text: '일련번호' 									,type: 'int'},
			{name: 'TOT_TAX_AMT'		, text: '⑮총공통</br>매입세액' 							,type: 'uniPrice'},

			{name: 'NONTAX_AMT'			, text: '면세공급가액' 									,type: 'uniPrice'},
			{name: 'TOT_SUPPLY_AMT'		, text: '총공급가액' 									,type: 'uniPrice'},
			{name: 'TAXFREE_RATE'		, text: '면세비율(%)' 									,type: 'float', decimalPrecision:6, format:'0,000.000000'},				//구, (16)면세사업</br>확정비율

			{name: 'TOT_NONTAX_AMT'		, text: '(17)불공제 매입</br>세액총액(⑮×(16))' 			,type: 'uniPrice'},
			{name: 'GI_NONTAX_AMT' 		, text: '(18)기불공제</br>매입세액' 						,type: 'uniPrice'},
			{name: 'DEDUCT_AMT' 		, text: '(19)가산 또는 공제되는</br>매입세액((17)-(18))' 		,type: 'uniPrice'},
		    {name: 'REMARK' 			, text: '비고' 										,type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER' 							,type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME' 							,type: 'string'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE' 								,type: 'string'}
		]
	});
	
	Unilite.defineModel('atx450ukrModel4', {
	    fields: [	    
		    {name: 'FR_PUB_DATE'		, text: 'FR_PUB_DATE' 												,type: 'uniDate'},
			{name: 'TO_PUB_DATE'		, text: 'TO_PUB_DATE' 												,type: 'uniDate'},
			{name: 'BILL_DIV_CODE'		, text: 'BILL_DIV_CODE' 											,type: 'string'},
			{name: 'SEQ'				, text: '일련번호' 													,type: 'int'},
			{name: 'PO_AMT'				, text: '(20)해당재화의매입세액' 											,type: 'uniPrice'},
			{name: 'RECAL_RATE'			, text: '(21)경감률[1-(5/100</br>또는 25/100×경과된 과세기간의 수)]' 			,type: 'uniER'},
			{name: 'TAXFREE_RATE'		, text: '(22)증가 또는 감소된</br> 면세공급가액 (사용면적) 비율' 					,type: 'uniER'},
			{name: 'DEDUCT_AMT' 		, text: '(23)가산 또는 공제되는</br> 매입세액((20)×(21)×(22))' 				,type: 'uniPrice'},
		    {name: 'REMARK' 			, text: '비고' 														,type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER' 											,type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME' 											,type: 'string'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE' 												,type: 'string'}
		]          
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('atx450ukrMasterStore1',{
		model: 'atx450ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: false,		// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
	        
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();
			var param= {
				FR_PUB_DATE : startDateValue,
				TO_PUB_DATE : endDateValue,
				BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE')
			}
			
			bLoadingStore1 = true;
			
			console.log( param );
			this.load({
				params : param,
				callback: function() {
					bLoadingStore1 = false;
					fnCallbackStoreLoad();
				}
			});
		},
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						if(directMasterStore2.isDirty()) {
							directMasterStore2.saveStore();
						} else if(directMasterStore3.isDirty()) {
							directMasterStore3.saveStore();
						} else if(directMasterStore4.isDirty()) {
							directMasterStore4.saveStore();
						}
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAll({success : function()	{
									UniAppManager.app.onQueryButtonDown();
								}
							  });
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		var recordsFirst = masterStore.data.items[0];
				if(!Ext.isEmpty(recordsFirst)) {
           			if(recordsFirst.data.FLAG == 'N') {
           				masterGrid.reset();
						masterStore.clearData();
		           		Ext.each(records, function(record,i){	
			        		UniAppManager.app.onNewDataButtonDown();
			        		masterGrid.setNewData(record.data);
				    	});
				    	
				    	UniAppManager.setToolbarButtons('deleteAll', false);
				    	bAddedRow = true;
           			}else{
           				UniAppManager.setToolbarButtons('deleteAll', true);   
           			}
           		}
			}
		}
	});
	
	var directMasterStore2 = Unilite.createStore('atx450ukrMasterStore2',{
		model: 'atx450ukrModel2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,		// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords: function() {
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();
			var param= {
				FR_PUB_DATE : startDateValue,
				TO_PUB_DATE : endDateValue,
				BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE')
			}
			
			bLoadingStore2 = true;
			
			console.log( param );
			this.load({
				params : param,
				callback: function() {
					bLoadingStore2 = false;
					fnCallbackStoreLoad();
				}
			});
		},
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();	
						if(masterStore.isDirty()) {
							masterStore.saveStore();
						} else if(directMasterStore3.isDirty()) {
							directMasterStore3.saveStore();
						} else if(directMasterStore4.isDirty()) {
							directMasterStore4.saveStore();
						}
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAll({success : function()	{
									UniAppManager.app.onQueryButtonDown();
								}
							  });
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        listeners: {
            update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
                UniAppManager.setToolbarButtons('save', true);      
            }/*,
            datachanged : function(store,  eOpts) {
                if( directMasterStore2.isDirty())    {
                    UniAppManager.setToolbarButtons('save', true);  
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }*/
        }/*,
		listeners:{
			load: function(store, records, successful, eOpts) {
				var i= 0;
	        	for(var j=0; j<records.length; j++) {
					i++;
					records[j].data.SEQ = i; 
				}
				store.insert(0, records);
			}
		}*/
	});
	
	var directMasterStore3 = Unilite.createStore('atx450ukrMasterStore3',{
		model: 'atx450ukrModel3',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,		// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy3,
        loadStoreRecords: function() {
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();
			var param= {
				FR_PUB_DATE : startDateValue,
				TO_PUB_DATE : endDateValue,
				BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE')
			}
			
			bLoadingStore3 = true;
			
			console.log( param );
			this.load({
				params : param,
				callback: function() {
					bLoadingStore3 = false;
					fnCallbackStoreLoad();
				}
			});
		},
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();	
						if(masterStore.isDirty()) {
							masterStore.saveStore();
						} else if(directMasterStore2.isDirty()) {
							directMasterStore2.saveStore();
						} else if(directMasterStore4.isDirty()) {
							directMasterStore4.saveStore();
						}
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAll({success : function()	{
									UniAppManager.app.onQueryButtonDown();
								}
							  });
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        listeners: {
            update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
                UniAppManager.setToolbarButtons('save', true);      
            }/*,
            datachanged : function(store,  eOpts) {
            	if( directMasterStore3.isDirty())    {
                    UniAppManager.setToolbarButtons('save', true);  
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }*/
        }/*,
		listeners:{
			load: function(store, records, successful, eOpts) {
				var i= 0;
	        	for(var j=0; j<records.length; j++) {
					i++;
					records[j].data.SEQ = i; 
				}
				store.insert(0, records);
			}
		}*/
	});
	
	var directMasterStore4 = Unilite.createStore('atx450ukrMasterStore4',{
		model: 'atx450ukrModel4',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,		// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy4,
        loadStoreRecords: function() {
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();
			var param= {
				FR_PUB_DATE : startDateValue,
				TO_PUB_DATE : endDateValue,
				BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE')
			}
			
			bLoadingStore4 = true;
			
			console.log( param );
			this.load({
				params : param,
				callback: function() {
					bLoadingStore4 = false;
					fnCallbackStoreLoad();
				}
			});
		},
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						if(masterStore.isDirty()) {
							masterStore.saveStore();
						} else if(directMasterStore2.isDirty()) {
							directMasterStore2.saveStore();
						} else if(directMasterStore3.isDirty()) {
							directMasterStore3.saveStore();
						}
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAll({success : function()	{
									UniAppManager.app.onQueryButtonDown();
								}
							  });
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        listeners: {
            update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
                UniAppManager.setToolbarButtons('save', true);      
            }/*,
            datachanged : function(store,  eOpts) {
            	if( directMasterStore4.isDirty())    {
                    UniAppManager.setToolbarButtons('save', true);  
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }*/
        }/*,
		listeners:{
			load: function(store, records, successful, eOpts) {
				var i= 0;
	        	for(var j=0; j<records.length; j++) {
					i++;
					records[j].data.SEQ = i; 
				}
				store.insert(0, records);
			}
		}*/
	});
	
	function fnCallbackStoreLoad() {
		if(!bLoadingStore1 && !bLoadingStore2 && !bLoadingStore3 && !bLoadingStore4) {
			if(bAddedRow) {
				UniAppManager.setToolbarButtons('save', true);
				bAddedRow = false;
			}
		}
	}
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
           	layout: {type: 'uniTable', columns: 1, tableAttrs: {width: '100%'}},
			defaultType: 'uniTextfield',
		    items: [{ 
				fieldLabel: '계산서일',
	 		    xtype: 'uniMonthRangefield',
	            startFieldName: 'FR_PUB_DATE',
	            endFieldName: 'TO_PUB_DATE',
				holdable: 'hold',
		        startDD: 'first',
		        endDD: 'last',
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
				name:'BILL_DIV_CODE',	
				xtype: 'uniCombobox',
				holdable: 'hold',
				comboType:'BOR120' ,
				comboCode	: 'BILL',
				allowBlank: false,
				listeners: {
					specialkey: function(field, event){
						if(event.getKey() == event.ENTER){
							UniAppManager.app.onQueryButtonDown();
						}
					},
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				} 
			},{
				xtype: 'container',
				tdAttrs: {align: 'center'},
				layout : {type : 'uniTable'},
				items:[{
					xtype: 'button',
					text: '재참조',	
					width: 80,				   	
					handler : function(records) {
						selectedMasterGrid = 'atx450ukrGrid';
						UniAppManager.setToolbarButtons(['newData'], false);
						if(!UniAppManager.app.checkForNewDetail()) {
							return false;
						} else {
							var startField3 = panelSearch.getField('FR_PUB_DATE');
							var startDateValue3 = startField3.getStartDate();
							var endField3 = panelSearch.getField('TO_PUB_DATE');
							var endDateValue3 = endField3.getEndDate();
							var param = {
									"FR_PUB_DATE": startDateValue3,
									"TO_PUB_DATE": endDateValue3,
									"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
							};
							atx450ukrService.dataCheck(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)) {
									if(confirm('기존 자료가 존재합니다.\n 재참조하는 경우 기존 데이터는 삭제됩니다.\n 재참조하시겠습니까?')) {
										masterGrid.reset();
										masterGrid2.reset();
										masterGrid3.reset();
										masterGrid4.reset();
										masterStore.clearData();
										directMasterStore2.clearData();
										directMasterStore3.clearData();
										directMasterStore4.clearData();
										var param = {
												"FR_PUB_DATE": startDateValue3,
												"TO_PUB_DATE": endDateValue3,
												"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
										};
										atx450ukrService.reReference(param, function(provider, response)	{
											if(!Ext.isEmpty(provider)){
												Ext.each(provider, function(record,i){
													UniAppManager.app.onNewDataButtonDown();
									        		masterGrid.setNewData(record);	
												});
											}
										});
									} else {
					    				return false;
					    			}
								} else {
									masterGrid.reset();
									masterStore.clearData();
									var param = {
											"FR_PUB_DATE": startDateValue3,
											"TO_PUB_DATE": endDateValue3,
											"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
									};
									atx450ukrService.reReference(param, function(provider, response)	{
										if(!Ext.isEmpty(provider)){
											Ext.each(provider, function(record,i){
												UniAppManager.app.onNewDataButtonDown();
								        		masterGrid.setNewData(record);	
											});										
										}
									});
								}
							});
	//						UniAppManager.setToolbarButtons(['reset','save'], false); 
						}
					}
				},{
		    		xtype: 'button',
		    		text: '출력',
		    		width: 100,
		    		margin: '0 0 0 2', 
	//	    		id:'temp20',
		    		handler : function() {
						var me = this;
	//					panelSearch.getEl().mask('로딩중...','loading-indicator');
						UniAppManager.app.onPrintButtonDown();	
					}
		    	}]
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
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,
	    items :[{
			xtype: 'container',
			layout : {type : 'uniTable'},
			items:[{ 
					fieldLabel: '계산서일',
		 		    width: 315,
		            xtype: 'uniMonthRangefield',
		            startFieldName: 'FR_PUB_DATE',
		            endFieldName: 'TO_PUB_DATE',
					holdable: 'hold',
			        startDD: 'first',
			        endDD: 'last',
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
					name:'BILL_DIV_CODE',	
					xtype: 'uniCombobox',
					holdable: 'hold',
					comboType:'BOR120' ,
					comboCode	: 'BILL',
		            allowBlank: false,
					listeners: {
						specialkey: function(field, event){
							if(event.getKey() == event.ENTER){
								UniAppManager.app.onQueryButtonDown();
							}
						},
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('BILL_DIV_CODE', newValue);
						}
					} 
				}
			]},{
				xtype: 'button',
				text: '재참조',	
//				margin: '0 0 0 -200',
				name: '',
				width: 80,	
				tdAttrs: {align: 'right'},				   	
				handler : function(records) {
					selectedMasterGrid = 'atx450ukrGrid';
					UniAppManager.setToolbarButtons(['newData'], false);
					if(!UniAppManager.app.checkForNewDetail()) {
						return false;
					} else {
						var startField3 = panelSearch.getField('FR_PUB_DATE');
						var startDateValue3 = startField3.getStartDate();
						var endField3 = panelSearch.getField('TO_PUB_DATE');
						var endDateValue3 = endField3.getEndDate();
						var param = {
								"FR_PUB_DATE": startDateValue3,
								"TO_PUB_DATE": endDateValue3,
								"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
						};
						atx450ukrService.dataCheck(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)) {
								if(confirm('기존 자료가 존재합니다.\n 재참조하는 경우 기존 데이터는 삭제됩니다.\n 재참조하시겠습니까?')) {
									masterGrid.reset();
									masterGrid2.reset();
									masterGrid3.reset();
									masterGrid4.reset();
									masterStore.clearData();
									directMasterStore2.clearData();
									directMasterStore3.clearData();
									directMasterStore4.clearData();
									var param = {
											"FR_PUB_DATE": startDateValue3,
											"TO_PUB_DATE": endDateValue3,
											"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
									};
									atx450ukrService.reReference(param, function(provider, response)	{
										if(!Ext.isEmpty(provider)){
											Ext.each(provider, function(record,i){
												UniAppManager.app.onNewDataButtonDown();
								        		masterGrid.setNewData(record);	
											});
										}
									});
								} else {
				    				return false;
				    			}
							} else {
								masterGrid.reset();
								masterStore.clearData();
								var param = {
										"FR_PUB_DATE": startDateValue3,
										"TO_PUB_DATE": endDateValue3,
										"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
								};
								atx450ukrService.reReference(param, function(provider, response)	{
									if(!Ext.isEmpty(provider)){
										Ext.each(provider, function(record,i){
											UniAppManager.app.onNewDataButtonDown();
							        		masterGrid.setNewData(record);	
										});
									}
								});
							}
						});
//						UniAppManager.setToolbarButtons(['reset','save'], false); 
					}
				}
			},{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		margin: '0 0 0 2', 
//	    		id:'temp20',
	    		handler : function() {
					var me = this;
//						panelSearch.getEl().mask('로딩중...','loading-indicator');
					UniAppManager.app.onPrintButtonDown();	
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
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
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
     * Master Grid 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('atx450ukrGrid', {
        uniOpt:{	
        	expandLastColumn: true,
			onLoadSelectFirst: false,
        	useRowNumberer: true,
        	userToolbar: true
        },
        flex: 2,
    	itemId:'atx450ukrGrid',
		store: masterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',  
    		showSummaryRow: true 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
        columns: [   
        	{text: '2. 공제받지 못할 매입세액 내역',
          		columns: [
        			{dataIndex: 'FR_PUB_DATE'		, width: 100, hidden: true}, 				
					{dataIndex: 'TO_PUB_DATE'		, width: 100, hidden: true}, 				
					{dataIndex: 'BILL_DIV_CODE'		, width: 100, hidden: true}, 				
					{dataIndex: 'GUBUN'				, width: 70,
		        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
		            	}
		            }, 				
					{dataIndex: 'CODE_NAME'			, width: 386},
					{text: '세 금 계 산 서',
          				columns: [
							{dataIndex: 'NUM'				, width: 166, summaryType: 'sum'}, 				
							{dataIndex: 'SUPPLY_AMT'		, width: 166, summaryType: 'sum'}, 				
							{dataIndex: 'TAX_AMT' 			, width: 166, summaryType: 'sum'}
						]
					},				
					{dataIndex: 'UPDATE_DB_USER'	, width: 100, hidden: true}, 				
					{dataIndex: 'UPDATE_DB_TIME'	, width: 100, hidden: true}, 	
					{dataIndex: 'COMP_CODE'			, width: 100, hidden: true}
				]
        	}
			,{dataIndex: 'REMARK' 			, width: 400, hidden: true} 
		],
		setNewData:function(record) {
			var grdRecord = this.getSelectedRecord();
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();

			grdRecord.set('FR_PUB_DATE'				,startDateValue);
			grdRecord.set('TO_PUB_DATE'				,endDateValue);
			grdRecord.set('BILL_DIV_CODE'			,panelSearch.getValue('BILL_DIV_CODE'));
			grdRecord.set('GUBUN'					,record['GUBUN']);
			grdRecord.set('CODE_NAME'				,record['CODE_NAME']);
			grdRecord.set('NUM'						,record['NUM']);
			grdRecord.set('SUPPLY_AMT'				,record['SUPPLY_AMT']);
			grdRecord.set('TAX_AMT'					,record['TAX_AMT']);
			grdRecord.set('REMARK'					,record['REMARK']);
		},
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {	
	        	if(!e.record.phantom) {                     
	        		if(UniUtils.indexOf(e.field, ['NUM', 'SUPPLY_AMT', 'TAX_AMT', 'REMARK']))            
					{                                      
						return true;                       
      				} else {                               
      					return false;                      
      				}                                      
	        	} else {                                   
	        		if(UniUtils.indexOf(e.field, ['NUM', 'SUPPLY_AMT', 'TAX_AMT', 'REMARK']))          
					{                                      
						return true;                      
      				} else {                               
      					return false;                      
      				}                                      
	        	}                                          
	        },
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons(['newData', 'delete'], false);
			},
			render: function(grid, eOpts) {
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	selectedMasterGrid = 'atx450ukrGrid';
			    	UniAppManager.setToolbarButtons(['newData', 'delete'], false);
					//UniAppManager.setToolbarButtons('save', true)
			    });
			}
		}             	        
    });
    
        /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid2 = Unilite.createGrid('atx450ukrGrid2', {    	
    	itemId:'atx450ukrGrid2',
        store : directMasterStore2, 
        uniOpt:{	
        	expandLastColumn: true,
			onLoadSelectFirst: false,
        	useRowNumberer: true,
        	userToolbar: false
        },
        flex: 1.5,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
        columns: [
        	{text: '3. 공통매입세액 안분계산 내역',
          		columns: [
        			{dataIndex: 'FR_PUB_DATE'		, width: 100, hidden: true}, 				
					{dataIndex: 'TO_PUB_DATE'		, width: 100, hidden: true}, 				
					{dataIndex: 'BILL_DIV_CODE'		, width: 100, hidden: true}, 				
					{dataIndex: 'SEQ'				, width: 70,
		        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
		            	}
		            },
					{text: '세 금 계 산 서',
						columns: [
							{dataIndex: 'SUPPLY_AMT'		, width: 177, summaryType: 'sum'}, 				
							{dataIndex: 'TAX_AMT'			, width: 177, summaryType: 'sum'}
						]
					},
					{dataIndex: 'TOT_SUPPLY_AMT'	, width: 176, summaryType: 'sum'}, 				
					{dataIndex: 'TAXFREE_AMT' 		, width: 177, summaryType: 'sum'}, 				
					{dataIndex: 'NONTAX_AMT' 		, width: 177, summaryType: 'sum'},		
					{dataIndex: 'UPDATE_DB_USER'	, width: 100, hidden: true}, 				
					{dataIndex: 'UPDATE_DB_TIME'	, width: 100, hidden: true}, 				
					{dataIndex: 'COMP_CODE'			, width: 100, hidden: true}
				]
        	}
			,{dataIndex: 'REMARK' 			, width: 400, hidden: true} 	 		
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	masterSelectedGrid = girdNm;
			    });
			},
			beforeedit: function( editor, e, eOpts ) {
	        	if (!e.record.phantom) {
	        		if (UniUtils.indexOf(e.field, ['SEQ', 'NONTAX_AMT'])) {
						return false;
					} else {
						return true;
					}
				} else {
	        		if (UniUtils.indexOf(e.field, ['SEQ', 'NONTAX_AMT'])) {
						return false;
					} else {
						return true;
					}
				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons('newData', 'delete', true);
			},
			render: function(grid, eOpts) {
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					selectedMasterGrid = 'atx450ukrGrid2';
					UniAppManager.setToolbarButtons(['newData', 'delete'], true);
				});
			}
		}
	});
	
        /**
     * Master Grid3 정의(Grid Panel)
     * @type 
     */
	
	var masterGrid3 = Unilite.createGrid('atx450ukrGrid3', {    	
		store : directMasterStore3, 
    	itemId:'atx450ukrGrid3',
        uniOpt:{	
        	expandLastColumn: true,
			onLoadSelectFirst: false,
        	useRowNumberer: true,
        	userToolbar: false
        },
        flex: 1.5,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
        columns: [ 
        	{text: '4. 공통매입세액의 정산 내역',
          		columns: [
		        	{dataIndex: 'FR_PUB_DATE'		, width: 100, hidden: true}, 				
					{dataIndex: 'TO_PUB_DATE'		, width: 100, hidden: true}, 				
					{dataIndex: 'BILL_DIV_CODE'		, width: 100, hidden: true}, 				
					{dataIndex: 'SEQ'				, width: 70,
		        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
		            	}
		            }, 				
					{dataIndex: 'TOT_TAX_AMT'		, width: 177, summaryType: 'sum'}, 				
		        	{text: '(16) 면세사업 확정비율(%)	',
		          		columns: [
							{dataIndex: 'NONTAX_AMT'		, width: 176, summaryType: 'sum'}, 				
							{dataIndex: 'TOT_SUPPLY_AMT'	, width: 176, summaryType: 'sum'}, 				
							{dataIndex: 'TAXFREE_RATE'		, width: 176}
						]
		        	},
					{dataIndex: 'TOT_NONTAX_AMT'	, width: 177, summaryType: 'sum'}, 				
					{dataIndex: 'GI_NONTAX_AMT' 	, width: 177, summaryType: 'sum'}, 				
					{dataIndex: 'DEDUCT_AMT' 		, width: 177, summaryType: 'sum'}, 					
					{dataIndex: 'UPDATE_DB_USER'	, width: 100, hidden: true}, 				
					{dataIndex: 'UPDATE_DB_TIME'	, width: 100, hidden: true}, 				
					{dataIndex: 'COMP_CODE'			, width: 100, hidden: true}
				]
        	}
			,{dataIndex: 'REMARK' 			, width: 400, hidden: true} 
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {	
	        	if(!e.record.phantom) {                     
	        		if(UniUtils.indexOf(e.field, ['TOT_NONTAX_AMT', 'DEDUCT_AMT']))            
					{                                      
						return false;                       
      				} else {                               
      					return true;                      
      				}                                      
	        	} else {                                   
	        		if(UniUtils.indexOf(e.field, ['TOT_NONTAX_AMT', 'DEDUCT_AMT']))          
					{                                      
						return false;                      
      				} else {                               
      					return true;                      
      				}                                      
	        	}                                          
	        },
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons('newData', 'delete', true);
			},
			render: function(grid, eOpts) {
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	selectedMasterGrid = 'atx450ukrGrid3';
					UniAppManager.setToolbarButtons(['newData', 'delete'], true);
			    });
			}
		}               			
    });
    
        /**
     * Master Grid4 정의(Grid Panel)
     * @type 
     */
    var masterGrid4 = Unilite.createGrid('atx450ukrGrid4', {    	
        store : directMasterStore4, 
    	itemId:'atx450ukrGrid4',
        uniOpt:{	
        	expandLastColumn: true,
			onLoadSelectFirst: false,
        	useRowNumberer: true,
        	userToolbar: false
        },
        flex: 1.5,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
        columns: [ 
        	{text: '5. 납부세액 또는 환급세액 재계산 내역',
          		columns: [
		        	{dataIndex: 'FR_PUB_DATE'			, width: 100, hidden: true}, 				
					{dataIndex: 'TO_PUB_DATE'			, width: 100, hidden: true}, 				
					{dataIndex: 'BILL_DIV_CODE'			, width: 100, hidden: true}, 				
					{dataIndex: 'SEQ'					, width: 70,
		        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
		            	}
		            }, 				
					{dataIndex: 'PO_AMT'				, width: 233, summaryType: 'sum'}, 				
					{dataIndex: 'RECAL_RATE'			, width: 225, summaryType: 'sum'}, 				
					{dataIndex: 'TAXFREE_RATE'			, width: 213, summaryType: 'sum'}, 				
					{dataIndex: 'DEDUCT_AMT' 			, width: 213, summaryType: 'sum'}, 				
					{dataIndex: 'UPDATE_DB_USER'		, width: 100, hidden: true}, 				
					{dataIndex: 'UPDATE_DB_TIME'		, width: 100, hidden: true}, 				
					{dataIndex: 'COMP_CODE'				, width: 100, hidden: true}
				]
        	}
			,{dataIndex: 'REMARK' 				, width: 400, hidden: true} 	
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {	
	        	if(!e.record.phantom) {                     
	        		if(UniUtils.indexOf(e.field, ['DEDUCT_AMT']))            
					{                                      
						return false;                       
      				} else {                               
      					return true;                      
      				}                                      
	        	} else {                                   
	        		if(UniUtils.indexOf(e.field, ['TOT_NONTAX_AMT', 'DEDUCT_AMT']))          
					{                                      
						return false;                      
      				} else {                               
      					return true;                      
      				}                                      
	        	}                                          
	        },
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons('newData', 'delete', true);
			},
			render: function(grid, eOpts) {
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	selectedMasterGrid = 'atx450ukrGrid4';
					UniAppManager.setToolbarButtons(['newData', 'delete'], true);
			    });
			}
			
		} 
    });
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: {type: 'vbox', align: 'stretch'},
			id:'pageAll',
			items: [
				panelResult,
				masterGrid,{xtype: 'splitter', size: 1},
				masterGrid2,{xtype: 'splitter', size: 1},
				masterGrid3,{xtype: 'splitter', size: 1},
				masterGrid4]
			},
			panelSearch
		], 
		id : 'atx450ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
			panelSearch.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_PUB_DATE',UniDate.get('today'));
			panelResult.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TO_PUB_DATE',UniDate.get('today'));
			
			UniAppManager.setToolbarButtons(['detail','reset','deleteAll'],false);

			//초기화 시 포커스 설정
			var activeSForm ;	
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_PUB_DATE');
		},
		onQueryButtonDown : function()	{
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			UniAppManager.setToolbarButtons('newData',false);
			UniAppManager.setToolbarButtons('reset', true);
			/*
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();
			var param= {
				FR_PUB_DATE : startDateValue,
				TO_PUB_DATE : endDateValue,
				BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE')
			}
			atx450ukrService.selectFirst(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)) {
					masterStore.loadStoreRecords();
					directMasterStore2.loadStoreRecords();
					directMasterStore3.loadStoreRecords();
					directMasterStore4.loadStoreRecords();
				} else {
					atx450ukrService.reReference(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)) {
							masterGrid.reset();
                            masterStore.clearData();
							Ext.each(provider, function(record,i) {
								UniAppManager.app.onNewDataButtonDown();
				        		masterGrid.setNewData(record);	
							});
							
							directMasterStore2.loadStoreRecords();
							directMasterStore3.loadStoreRecords();
							directMasterStore4.loadStoreRecords();
						}
					});
				}
			});
			*/
			
			Ext.getCmp('atx450ukrGrid').focus();
			selectedMasterGrid = 'atx450ukrGrid';
			
					masterStore.loadStoreRecords();
					directMasterStore2.loadStoreRecords();
					directMasterStore3.loadStoreRecords();
					directMasterStore4.loadStoreRecords();
			//UniAppManager.setToolbarButtons('save', true);
			
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
			return panelResult.setAllFieldsReadOnly(true);
        },
        onPrintButtonDown: function() {
			var param= Ext.getCmp('searchForm').getValues();
			
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();
			param['FR_PUB_DATE'] = startDateValue;
			param['TO_PUB_DATE'] = endDateValue;
			
			// Clip report
			var reportGubun	= gsReportGubun
			if(reportGubun.toUpperCase() == 'CLIP'){
				param.PGM_ID				= 'atx450ukr';
				param.MAIN_CODE				= 'A126';
				param.COMP_CODE				= UserInfo.compCode;
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/accnt/atx450clukr.do',
					prgID	: 'atx450ukr',
					extParam: param
				});
				win.center();
				win.show();
				
			// jasper Report
			} else {
				var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/atx/atx450rkr.do',
				prgID: 'atx450ukr',
				extParam: param
				});
				win.center();
				win.show();
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterGrid2.reset();
			masterGrid3.reset();
			masterGrid4.reset();
			masterStore.clearData();
			directMasterStore2.clearData();
			directMasterStore3.clearData();
			directMasterStore4.clearData();
			this.fnInitBinding();
			UniAppManager.setToolbarButtons(['newData','save'], false); 
		},
		onNewDataButtonDown: function()	{
			if(selectedMasterGrid == 'atx450ukrGrid') {
				var startField = panelSearch.getField('FR_PUB_DATE');
				var startDateValue = startField.getStartDate();
				var endField = panelSearch.getField('TO_PUB_DATE');
				var endDateValue = endField.getEndDate();
			
				var frPubDate =	startDateValue; 
				var toPubDate =	endDateValue;   
				var billDivCode =	'';   
				var gubun =	'';         
				var codeName =	'';      
				var num =	'0';           
				var supplyAmt =	'0';     
				var taxAmt =	'0';     
				var remark =	'';
				
				var r = {
					FR_PUB_DATE		: frPubDate,	
					TO_PUB_DATE		: toPubDate,
					BILL_DIV_CODE	: billDivCode,
					GUBUN			: gubun,
					CODE_NAME		: codeName,
					NUM				: num,
					SUPPLY_AMT		: supplyAmt,
					TAX_AMT			: taxAmt,
					REMARK			: remark	
		        };
				masterGrid.createRow(r);
			} else if(selectedMasterGrid == 'atx450ukrGrid2') {
				var startField = panelSearch.getField('FR_PUB_DATE');
				var startDateValue = startField.getStartDate();
				var endField = panelSearch.getField('TO_PUB_DATE');
				var endDateValue = endField.getEndDate();
				
				var frPubDate  = startDateValue;
				var toPubDate = endDateValue;
				var billDivCode = panelSearch.getValue('BILL_DIV_CODE');
				var seq = directMasterStore2.max('SEQ');
					if(!seq){
						seq = 1;
					}else{
						seq += 1;
					}
				var supplyAmt = 0;
				var taxfreeAmt = 0;
				var nontaxAmt = 0;
				var compCode = UserInfo.compCode;
				
				var r = {
					FR_PUB_DATE: frPubDate,
					TO_PUB_DATE: toPubDate,
					BILL_DIV_CODE: billDivCode,
					SEQ: seq,
					SUPPLY_AMT: supplyAmt,
					TAXFREE_AMT: taxfreeAmt,
					NONTAX_AMT: nontaxAmt,
					COMP_CODE: compCode
		        };
				masterGrid2.createRow(r);
			} else if(selectedMasterGrid == 'atx450ukrGrid3') {
				if(parseInt(UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(4, 6)) >= '01' && parseInt(UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(4, 6)) <= '03' ||
				   parseInt(UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(4, 6)) >= '07' && parseInt(UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(4, 6)) <= '09') {
					alert("확정신고기간에만 추가가 가능합니다.");	
				} else {
					var startField = panelSearch.getField('FR_PUB_DATE');
					var startDateValue = startField.getStartDate();
					var endField = panelSearch.getField('TO_PUB_DATE');
					var endDateValue = endField.getEndDate();
					
					var frPubDate  = startDateValue;
					var toPubDate = endDateValue;
					var billDivCode = panelSearch.getValue('BILL_DIV_CODE');
					var seq = directMasterStore3.max('SEQ');
						if(!seq){
							seq = 1;
						}else{
							seq += 1;
						}
					var totTaxAmt = '0';
					var taxfreeRate = '0';
					var totNonTaxAmt = '0';
					var giNontaxAmt = '0';
					vardeductAmt = '0';
					var compCode = UserInfo.compCode;
					
					var r = {
						FR_PUB_DATE: frPubDate,
						TO_PUB_DATE: toPubDate,
						BILL_DIV_CODE: billDivCode,
						SEQ: seq,
						TOT_TAX_AMT: totTaxAmt,
						TAXFREE_RATE: taxfreeRate,
						TOT_NONTAX_AMT: totNonTaxAmt,
						GI_NONTAX_AMT: giNontaxAmt,
						DEDUCT_AMT: deductAmt,
						COMP_CODE: compCode
			        };
					masterGrid3.createRow(r);
				}
			} else if(selectedMasterGrid == 'atx450ukrGrid4') {
				if(parseInt(UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(4, 6)) >= '01' && parseInt(UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(4, 6)) <= '03' ||
				   parseInt(UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(4, 6)) >= '07' && parseInt(UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(4, 6)) <= '09') {
					alert("확정신고기간에만 추가가 가능합니다.");	
				} else {
					var startField = panelSearch.getField('FR_PUB_DATE');
					var startDateValue = startField.getStartDate();
					var endField = panelSearch.getField('TO_PUB_DATE');
					var endDateValue = endField.getEndDate();
					
					var frPubDate  = startDateValue;
					var toPubDate = endDateValue;
					var billDivCode = panelSearch.getValue('BILL_DIV_CODE');
					var seq = directMasterStore4.max('SEQ');
						if(!seq){
							seq = 1;
						}else{
							seq += 1;
						}
					var poAmt = '0';
					var recalRate = '0';
					var taxfreeRate = '0';
					var deductAmt = '0';
					var compCode = UserInfo.compCode;
					
					var r = {
						FR_PUB_DATE: frPubDate,
						TO_PUB_DATE: toPubDate,
						BILL_DIV_CODE: billDivCode,
						SEQ: seq,
						PO_AMT: poAmt,
						RECAL_RATE: recalRate,
						TAXFREE_RATE: taxfreeRate,
						DEDUCT_AMT: deductAmt,
						COMP_CODE: compCode
			        };
					masterGrid4.createRow(r);
				}
			}
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			/*MasterStore.saveStore({
				success: function() {
					directMasterStore2.saveStore({
						success: function() {
							directMasterStore3.saveStore({
								success: function() {
									directMasterStore4.saveStore();
								}
							});
						}
					});
				}
			});*/
			if(masterStore.isDirty()) {
				masterStore.saveStore();
			} else if(directMasterStore2.isDirty()) {
				directMasterStore2.saveStore();
			} else if(directMasterStore3.isDirty()) {
				directMasterStore3.saveStore();
			} else if(directMasterStore4.isDirty()) {
				directMasterStore4.saveStore();
			}
          //  UniAppManager.app.onQueryButtonDown();
		},
		onDeleteDataButtonDown: function() {
			if(selectedMasterGrid == 'atx450ukrGrid2') {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid2.deleteSelectedRow();
				}
			} else if(selectedMasterGrid == 'atx450ukrGrid3') {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid3.deleteSelectedRow();
				}
			} else if(selectedMasterGrid == 'atx450ukrGrid4') {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid4.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown: function() {
            
            if(!panelResult.getInvalidMessage()) return;   
                 
            if(confirm('전체삭제 하시겠습니까?')) {
            	
                var startField = panelResult.getField('FR_PUB_DATE');
                var startDateValue = startField.getStartDate();
                var endField = panelResult.getField('TO_PUB_DATE');
                var endDateValue = endField.getEndDate(); 
                
                var param = {
                    FR_PUB_DATE  : startDateValue,
                    TO_PUB_DATE  : endDateValue,
                    BILL_DIV_CODE  : panelResult.getValue('BILL_DIV_CODE')
                }
                Ext.getCmp('pageAll').getEl().mask('전체삭제 중...','loading-indicator');
                atx450ukrService.atx450ukrDelA(param, function(provider, response)  {                           
                    if(provider){   
                        UniAppManager.updateStatus(Msg.sMB013);
                        UniAppManager.app.onResetButtonDown();      
                    }
                    Ext.getCmp('pageAll').getEl().unmask();    
                });
            }else{
                return false;   
            }
        }
	});
	
	Unilite.createValidator('validator02', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "TAX_AMT" :			// 세액
					record.set('NONTAX_AMT', Math.floor(newValue * (Math.floor(record.get('TAXFREE_AMT') / record.get('TOT_SUPPLY_AMT') * 1000000)/ 1000000)));
				break;
				
				case "TOT_SUPPLY_AMT" :		// 총공급가액
					record.set('NONTAX_AMT', Math.floor(record.get('TAX_AMT') * (Math.floor(record.get('TAXFREE_AMT') / newValue * 1000000)/ 1000000)));
				break;
				
				case "TAXFREE_AMT" :		// 면세공급가액등
					record.set('NONTAX_AMT', Math.floor(record.get('TAX_AMT') * (Math.floor(newValue / record.get('TOT_SUPPLY_AMT') * 1000000)/ 1000000)));
				break;
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator03', {
		store: directMasterStore3,
		grid: masterGrid3,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "TOT_TAX_AMT" :			// 불공제 매입 세액총액            
					record.set('TOT_NONTAX_AMT', Math.floor(newValue * record.get('TAXFREE_RATE') / 100));
					record.set('DEDUCT_AMT',  Math.floor(newValue * record.get('TAXFREE_RATE') / 100) - record.get('GI_NONTAX_AMT'));
				break;
			//여기부터	
				case "NONTAX_AMT" :				// 면세공급가액           
					if ((!Ext.isEmpty(record.get('TOT_SUPPLY_AMT'))) && (record.get('TOT_SUPPLY_AMT') != 0)){
						record.set('TAXFREE_RATE', Math.floor(newValue / record.get('TOT_SUPPLY_AMT') * 100000000)/ 1000000);
						record.set('TOT_NONTAX_AMT', Math.floor(record.get('TAXFREE_RATE') * record.get('TOT_TAX_AMT') / 100));
						record.set('DEDUCT_AMT',  Math.floor(record.get('TOT_TAX_AMT') * record.get('TAXFREE_RATE') / 100) - record.get('GI_NONTAX_AMT'));
					}
				break;
				
				case "TOT_SUPPLY_AMT" :			// 총공급가액                    
					record.set('TAXFREE_RATE', Math.floor((record.get('NONTAX_AMT') / newValue) * 100000000)/ 1000000);
					record.set('TOT_NONTAX_AMT', Math.floor(record.get('TAXFREE_RATE') * record.get('TOT_TAX_AMT') / 100));
					record.set('DEDUCT_AMT',  Math.floor(record.get('TOT_TAX_AMT') * record.get('TAXFREE_RATE') / 100) - record.get('GI_NONTAX_AMT'));
				break;
			//여기까지 수정 중	
				case "TAXFREE_RATE" :			// 면세사업확정비율                    
					record.set('TOT_NONTAX_AMT', Math.floor(newValue * record.get('TOT_TAX_AMT') / 100));
					record.set('DEDUCT_AMT',  Math.floor(record.get('TOT_TAX_AMT') * newValue / 100) - record.get('GI_NONTAX_AMT'));
				break;
				
				case "GI_NONTAX_AMT" :			// 기불공제 매입세액                
					record.set('DEDUCT_AMT', Math.floor(record.get('TOT_TAX_AMT') * record.get('TAXFREE_RATE') / 100) - newValue);
					record.set('DEDUCT_AMT', record.get('TOT_NONTAX_AMT') - newValue);
				break;
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator04', {
		store: directMasterStore4,
		grid: masterGrid4,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PO_AMT" :			// (20)해당재화의매입세액
					record.set('DEDUCT_AMT', Math.floor(newValue * record.get('RECAL_RATE') * record.get('TAXFREE_RATE') / 100));
				break;
				
				case "RECAL_RATE" :			// (21)경감률[1-(5/100 또는 25/100×경과된 과세기간의 수)]
					record.set('DEDUCT_AMT', Math.floor(record.get('PO_AMT') * newValue * record.get('TAXFREE_RATE') / 100));
				break;
				
				case "TAXFREE_RATE" :			// (22)증가 또는 감소된 면세공급가액(사용면적) 비율
					record.set('DEDUCT_AMT', Math.floor(record.get('PO_AMT') * record.get('RECAL_RATE') * newValue) / 100);
				break;
			}
			return rv;
		}
	});
};
</script>
