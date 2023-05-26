<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx400ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->   
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="T001" /> 	<!-- 무역구분 -->      
	<t:ExtComboStore comboType="AU" comboCode="T071" /> 	<!-- 진행구분(수입) -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >
var outDivCode = UserInfo.divCode;
var InterestRateWindow;	// 이자율

function appMain() {
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx400ukrService.selectMaster',
			update: 'atx400ukrService.updateDetail',
			create: 'atx400ukrService.insertDetail',
			destroy: 'atx400ukrService.deleteDetail',
			syncAll: 'atx400ukrService.saveAll'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx400ukrService.selectInterestRate',
			update: 'atx400ukrService.updateInterestRate',
			create: 'atx400ukrService.insertInterestRate',
			destroy: 'atx400ukrService.deleteInterestRate',
			syncAll: 'atx400ukrService.saveInterestRate'
		}
	});
	/**
	 * Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('Atx400ukrModel', {
	    fields: [
	    	{name: 'FR_PUB_DATE'		,text: 'fr_pub_date' 			,type: 'uniDate'},
	    	{name: 'TO_PUB_DATE'		,text: 'to_pub_date' 			,type: 'uniDate'},
	    	{name: 'BILL_DIV_CODE'		,text: 'bill_div_code' 			,type: 'string'},
	    	{name: 'SEQ'				,text: 'seq' 					,type: 'int'},
	    	{name: 'DONG'				,text: '동' 						,type: 'string'},
	    	{name: 'UP_UNDER'			,text: '지하/지상' 				,type: 'string'},
	    	{name: 'UP_FLOOR'			,text: '층' 						,type: 'string', allowBlank: false},
	    	{name: 'HOUSE' 				,text: '호수' 					,type: 'string'},
	    	{name: 'AREA' 				,text: '면적' 					,type: 'int'},
	    	{name: 'HIRE_CUST_CD' 		,text: 'HIRE_CUST_CD' 			,type: 'string'},
	    	{name: 'HIRE_CUST_NM' 		,text: '상호(성명)' 				,type: 'string', allowBlank: false},
	    	{name: 'COMPANY_NUM' 		,text: '사업자등록번호' 				,type: 'string', allowBlank: false},
	    	{name: 'MOVE_IN_DATE'		,text: '입주일' 					,type: 'uniDate'},
	    	{name: 'UPDATE_DATE' 		,text: '갱신일' 					,type: 'uniDate'},
	    	{name: 'LEAVING_DATE'		,text: '퇴거일' 					,type: 'uniDate'},
	    	{name: 'GUARANTY' 			,text: '보증금' 					,type: 'uniPrice'},
	    	{name: 'MONTHLY_RENT' 		,text: '월세' 					,type: 'uniPrice'},
	    	{name: 'TOTAL' 				,text: '합계' 					,type: 'uniPrice'},
	    	{name: 'INTEREST' 			,text: '보증금이자' 				,type: 'uniPrice'},
	    	{name: 'MONTHLY_TOTAL'		,text: '월세(계)' 				,type: 'uniPrice'},
	    	{name: 'SORT_ORDER' 		,text: 'sort' 					,type: 'int'},
	    	{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER' 		,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME' 		,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'		,text: 'COMP_CODE' 				,type: 'string'},
	    	{name: 'SAVE_FLAG'			,text: 'SAVE_FLAG' 				,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	var MasterStore = Unilite.createStore('atx400ukrMasterStore',{
			model: 'Atx400ukrModel',
			uniOpt : {
            	isMaster: 	true,			// 상위 버튼 연결
            	editable: 	true,			// 수정 모드 사용
            	deletable:	true,			// 삭제 가능 여부
	            useNavi : 	false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy
			,loadStoreRecords : function()	{
				var startField = panelSearch.getField('FR_PUB_DATE');
				var startDateValue = startField.getStartDate();
				var endField = panelSearch.getField('TO_PUB_DATE');
				var endDateValue = endField.getEndDate();
				var frDate = panelSearch.getValue('FR_DATE');
				var toDate = panelSearch.getValue('TO_DATE');
				var param= {
					FR_PUB_DATE : startDateValue,
					TO_PUB_DATE : endDateValue,
					BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE'),
					FR_DATE : frDate,
					TO_DATE : toDate
				}
				console.log( param );
				this.load({
					params : param
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
							UniAppManager.setToolbarButtons('save', false);			
						 } 
					};					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		var recordsFirst = MasterStore.data.items[0];
					if(!Ext.isEmpty(recordsFirst)){
	           			if(recordsFirst.data.FLAG == 'N') {
	           				masterGrid.reset();
							MasterStore.clearData();
			           		Ext.each(records, function(record,i){	
				        		UniAppManager.app.onNewDataButtonDown();
				        		masterGrid.setNewDataATX400T(record.data);								        
					    	});
					    	setTimeout(function(){UniAppManager.setToolbarButtons('save', true)},1000);	
	           			}
	           		}
				}
			}
	});

	/**
	 * 이자율조건 (Search Panel)
	 * 
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{ 
	        	fieldLabel: '신고기간',
				holdable: 'hold',
				xtype: 'uniMonthRangefield',  
		        startFieldName: 'FR_PUB_DATE',
		        endFieldName: 'TO_PUB_DATE',
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
				holdable: 'hold',
				name:'BILL_DIV_CODE',	
				xtype: 'uniCombobox',
				comboType:'BOR120' ,
				comboCode	: 'BILL',
				allowBlank:false,
	    	    validateBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				} 
			},{
				xtype: 'container',
				layout : {type : 'uniTable'},
				padding: '0 0 0 90',
				items:[{
					xtype: 'button',
					text: '재참조',	
					name: '',
					// inputValue: '2',
					// margin: '0 50 0 0',
					width: 80,	
					tdAttrs: {align: 'right'},				   	
					handler : function(records) {
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
							atx400ukrService.dataCheck(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)) {
									if(confirm('이미 데이터가 존재합니다.\n 다시 생성하시면 기존 데이터가 삭제됩니다.\n 그래도 생성하시겠습니까?')) {
										masterGrid.reset();
										MasterStore.clearData();
										var param = {
												"FR_PUB_DATE": startDateValue3,
												"TO_PUB_DATE": endDateValue3,
												"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
										};
										atx400ukrService.reReference(param, function(provider, response)	{
											if(!Ext.isEmpty(provider)){
												Ext.each(provider, function(record,i){
													UniAppManager.app.onNewDataButtonDown();
									        		masterGrid.setNewDataATX400T(record);	
												});
											}
										});
									} else {
					    				return false;
					    			}
								} else {
									masterGrid.reset();
									MasterStore.clearData();
									var param = {
											"FR_PUB_DATE": startDateValue3,
											"TO_PUB_DATE": endDateValue3,
											"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
									};
									atx400ukrService.reReference(param, function(provider, response)	{
										if(!Ext.isEmpty(provider)){
											Ext.each(provider, function(record,i){
												UniAppManager.app.onNewDataButtonDown();
								        		masterGrid.setNewDataATX400T(record);	
											});
										}
									});
								}
							});
						}
					}
				},{
					xtype: 'button',
					text: '이자율',	
					name: '',
					// inputValue: '2',
					// margin: '0 50 0 0',
					width: 80,			
					tdAttrs: {align: 'right'},		   	
					handler : function(records) {
						openInterestRateWindow() 
					}
				},{
					xtype: 'button',
					text: '출력',	
					name: '',
					// inputValue: '2',
					// margin: '0 50 0 0',
					width: 80,			
					tdAttrs: {align: 'right'},		   	
					handler : function(records) {
						var param= Ext.getCmp('searchForm').getValues();		
						param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
						param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
						var win = Ext.create('widget.PDFPrintWindow', {
							url: CPATH+'/atx/atx400ukr.do',
							prgID: 'atx400ukr',
							extParam: param
						});
						win.center();
						win.show(); 
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
		      		// this.mask();
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
		    	// this.unmask();
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
		items: [
			{
				xtype: 'container',
				layout : {type : 'uniTable'},
				items:[{ 
		        	fieldLabel: '신고기간',
					holdable: 'hold',
					xtype: 'uniMonthRangefield',  
			        startFieldName: 'FR_PUB_DATE',
			        endFieldName: 'TO_PUB_DATE',
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
					holdable: 'hold',
					name:'BILL_DIV_CODE',	
					xtype: 'uniCombobox',
					comboType:'BOR120' ,
					comboCode	: 'BILL',
					allowBlank:false,
			        validateBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('BILL_DIV_CODE', newValue);
						}
					} 
				}
			]},{
				xtype: 'container',
				layout : {type : 'uniTable'},
				padding: '0 0 0 90',
				items:[{
					xtype: 'button',
					text: '재참조',	
					name: '',
					// inputValue: '2',
					// margin: '0 50 0 0',
					width: 80,	
					tdAttrs: {align: 'right'},				   	
					handler : function(records) {
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
							atx400ukrService.dataCheck(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)) {
									if(confirm('이미 데이터가 존재합니다.\n 다시 생성하시면 기존 데이터가 삭제됩니다.\n 그래도 생성하시겠습니까?')) {
										masterGrid.reset();
										MasterStore.clearData();
										var param = {
												"FR_PUB_DATE": startDateValue3,
												"TO_PUB_DATE": endDateValue3,
												"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
										};
										atx400ukrService.reReference(param, function(provider, response)	{
											if(!Ext.isEmpty(provider)){
												Ext.each(provider, function(record,i){
													UniAppManager.app.onNewDataButtonDown();
									        		masterGrid.setNewDataATX400T(record);	
												});
											}
										});
									} else {
					    				return false;
					    			}
								} else {
									masterGrid.reset();
									MasterStore.clearData();
									var param = {
											"FR_PUB_DATE": startDateValue3,
											"TO_PUB_DATE": endDateValue3,
											"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
									};
									atx400ukrService.reReference(param, function(provider, response)	{
										if(!Ext.isEmpty(provider)){
											Ext.each(provider, function(record,i){
												UniAppManager.app.onNewDataButtonDown();
								        		masterGrid.setNewDataATX400T(record);	
											});
										}
									});
								}
							});
						}
					}
				},{
					xtype: 'button',
					text: '이자율',	
					name: '',
					// inputValue: '2',
					// margin: '0 50 0 0',
					width: 80,			
					tdAttrs: {align: 'right'},		   	
					handler : function(records) {
						openInterestRateWindow() 
					}
				},{
					xtype: 'button',
					text: '출력',	
					name: '',
					// inputValue: '2',
					// margin: '0 50 0 0',
					width: 80,			
					tdAttrs: {align: 'right'},		   	
					handler : function(records) {
						var param= Ext.getCmp('searchForm').getValues();		
						param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
						param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
						var win = Ext.create('widget.PDFPrintWindow', {
							url: CPATH+'/atx/atx400ukr.do',
							prgID: 'atx400ukr',
							extParam: param
						});
						win.center();
						win.show();
					}
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
		      		// this.mask();
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
		    	// this.unmask();
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
	
	var InterestRateSearch = Unilite.createSearchForm('InterestRateSearchForm', {		// 이자율
																						// 팝업창
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [
	    	{
				xtype: 'button',
				text: '추가',	
				name: 'insert',
				// inputValue: '2',
				// margin: '0 50 0 0',
				width: 80,	
				tdAttrs: {align: 'right'},				   	
				handler : function(records) {
					UniAppManager.app.InterestRateNewDataButtonDown();
				}
			},{
				xtype: 'button',
				text: '삭제',	
				name: 'delete',
				// inputValue: '2',
				// margin: '0 50 0 0',
				width: 80,			
				tdAttrs: {align: 'right'},		   	
				handler : function(records) {
					UniAppManager.app.InterestRateDeleteDataButtonDown();
				}
			}
		]
  	});
  	
  	Unilite.defineModel('InterestRateModel', {		// 이자율조회창
	    fields: [
	    	{name: 'INTEREST_RATE'			, text: '이자율(%)'				, type: 'uniPercent'},
	    	{name: 'APPLY_DATE'				, text: '적용일'					, type: 'uniDate'},
	    	{name: 'UPDATE_DB_USER'			, text: 'UPDATE_DB_USER'		, type: 'string'},
	    	{name: 'UPDATE_DB_TIME'			, text: 'UPDATE_DB_TIME'		, type: 'string'},
	    	{name: 'COMP_CODE'				, text: 'COMP_CODE'				, type: 'string'}
		]
	});
  	
  	var InterestRateStore = Unilite.createStore('InterestRateStore', {	// 이자율
																		// 팝업창
			model: 'InterestRateModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: directProxy2,
            loadStoreRecords: function() {
				var param= InterestRateSearch.getValues();
				console.log(param);
				this.load({
					params : param
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
							UniAppManager.setToolbarButtons('save', false);			
						 } 
					};					
					this.syncAllDirect(config);
				}else {
					InterestRateGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});
	
	var InterestRateGrid = Unilite.createGrid('atx400ukrInterestRateGrid', {	// 검색팝업창
        // title: '기본',
        layout : 'fit',       
		store: InterestRateStore,
        columns:  [ 
        	{ dataIndex: 'INTEREST_RATE'			   	,  width: 106}, 
			{ dataIndex: 'APPLY_DATE'				   	,  width: 106}, 
			{ dataIndex: 'UPDATE_DB_USER'			   	,  width: 106, hidden: true}, 
			{ dataIndex: 'UPDATE_DB_TIME'			   	,  width: 106, hidden: true},
			{ dataIndex: 'COMP_CODE'					,  width: 106, hidden: true}
        ],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(!e.record.phantom) {
	        		if(UniUtils.indexOf(e.field, ['INTEREST_RATE']))
				   	{
						return true;
      				} else {
      					return false;
      				}
	        	} else {
	        		if(UniUtils.indexOf(e.field, ['INTEREST_RATE', 'APPLY_DATE']))
				   	{
						return true;
      				} else {
      					return false;
      				}
	        	}
	        }
		} 
    });
	
	function openInterestRateWindow() {	// 이자율 팝업창
		InterestRateStore.loadStoreRecords();
		if(!InterestRateWindow) {
			InterestRateWindow = Ext.create('widget.uniDetailWindow', {
                title: '이자율',
                width: 300,				                
                height: 400,
                layout: {type:'vbox', align:'stretch'},	                
                items: [InterestRateSearch, InterestRateGrid], 
                tbar:  ['->',
					{itemId : 'saveBtn',
					text: '확인',
					handler: function() {
						UniAppManager.app.InterestRateSaveDataButtonDown();
						InterestRateStore.loadStoreRecords();
					},
					disabled: false
					}, {
						itemId : 'OrderNoCloseBtn',
						text: '닫기',
						handler: function() {
							InterestRateWindow.hide();
						},
						disabled: false
					}
				],
				listeners: {beforehide: function(me, eOpt)
					{
						InterestRateSearch.clearForm();
						InterestRateGrid.reset();	                							
                	},
                	beforeclose: function( panel, eOpts ) {
						InterestRateSearch.clearForm();
						InterestRateGrid.reset();
       	 			}
                }		
			})
		}
		InterestRateWindow.show();
    }

    /**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
        var masterGrid = Unilite.createGrid('atx400ukrGrid1', {
    	// for tab
        layout : 'fit',
        region:'center',
        uniOpt:{	expandLastColumn:	true,
        			useRowNumberer: 	true,
                    useMultipleSorting:	true,
	 				copiedRow: true
        },
        tbar: [{
			xtype: 'button',
           	itemId:'procTool',
			text: '부동산임대정보등록',
			handler: function() {
				var rec = {data : {prgID : 'atx410ukr', 'text':'부동산임대정보등록'}};							
				parent.openTab(rec, '/accnt/atx410ukr.do');
			}
        }],
    	store: MasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
        	{ dataIndex: 'FR_PUB_DATE'	 		, 			width: 66, hidden: true},
            { dataIndex: 'TO_PUB_DATE'	 		, 			width: 66, hidden: true},
            { dataIndex: 'BILL_DIV_CODE'	 	, 			width: 66, hidden: true},
            { dataIndex: 'SEQ'			 		, 			width: 66, hidden: true},
            {text: '임대사항',
          		columns: [
            		{ dataIndex: 'DONG'			 		, 			width: 66},
            		{ dataIndex: 'UP_UNDER'		 		, 			width: 80, hidden: true},
            		{ dataIndex: 'UP_FLOOR'		 		, 			width: 80},
            		{ dataIndex: 'HOUSE' 			 	, 			width: 80}
            	]
            },
            { dataIndex: 'AREA' 			 	, 			width: 70},
            { dataIndex: 'HIRE_CUST_CD' 	 	, 			width: 66, hidden: true,
				editor: Unilite.popup('CUST_G', {		
			 		textFieldName: 'CUSTOM_NAME',
			 		DBtextFieldName: 'CUSTOM_NAME',
			 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
			  		autoPopup: true,
					listeners: {'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
									}
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setCustData(null,true, masterGrid.uniOpt.currentRecord);
						}
					}
				})
		    },
            { dataIndex: 'HIRE_CUST_NM' 	 	, 			width: 113,
				editor: Unilite.popup('CUST_G', {
			 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
			  		autoPopup: true,
					listeners: {'onSelected': {
							fn: function(records, type) {
					    	    console.log('records : ', records);
							    Ext.each(records, function(record,i) {													                   
									if(i==0) {
										masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
									}
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setCustData(null,true, masterGrid.uniOpt.currentRecord);
						}
					}
				})
		    },
            { dataIndex: 'COMPANY_NUM' 	 		, 			width: 110},
            { dataIndex: 'MOVE_IN_DATE'	 		, 			width: 80},
            { dataIndex: 'UPDATE_DATE' 	 		, 			width: 80},
            { dataIndex: 'LEAVING_DATE'	 		, 			width: 80},
            { dataIndex: 'GUARANTY' 			, 			width: 110},
            { dataIndex: 'MONTHLY_RENT' 	 	, 			width: 90},
            { dataIndex: 'TOTAL' 			 	, 			width: 90},
            { dataIndex: 'INTEREST' 		 	, 			width: 90},
            { dataIndex: 'MONTHLY_TOTAL'	 	, 			width: 100},
            { dataIndex: 'SORT_ORDER' 	 		, 			width: 100},
            { dataIndex: 'UPDATE_DB_USER' 		, 			width: 66, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME' 		, 			width: 66, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME' 		, 			width: 66, hidden: true}   		
        ],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(!e.record.phantom) {
	        		if(UniUtils.indexOf(e.field, ['TOTAL']))
				   	{
						return false;
      				} else {
      					return true;
      				}
	        	} else {
	        		if(UniUtils.indexOf(e.field, ['TOTAL']))
				   	{
						return false;
      				} else {
      					return true;
      				}
	        	}
	        }
		},
		setCustData: function(record, dataClear, grdRecord) {	
       		if(dataClear) {
       			grdRecord.set('HIRE_CUST_CD'			, "");
       			grdRecord.set('HIRE_CUST_NM'			, "");
       			grdRecord.set('COMPANY_NUM'				, "");
				
       		} else {
       			grdRecord.set('HIRE_CUST_CD'			, record['CUSTOM_CODE']);
       			grdRecord.set('HIRE_CUST_NM'			, record['CUSTOM_NAME']);
       			grdRecord.set('COMPANY_NUM'				, record['COMPANY_NUM']);
       		}
		},
		setNewDataATX400T:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('FR_PUB_DATE'				,record['FR_PUB_DATE']);
			grdRecord.set('TO_PUB_DATE'				,record['TO_PUB_DATE']);
			grdRecord.set('BILL_DIV_CODE'			,record['BILL_DIV_CODE']);
			grdRecord.set('SEQ'						,record['SEQ']);
			grdRecord.set('DONG'					,record['DONG']);
			grdRecord.set('UP_UNDER'				,record['UP_UNDER']);
			grdRecord.set('UP_FLOOR'				,record['UP_FLOOR']);
			grdRecord.set('HOUSE'					,record['HOUSE']);
			grdRecord.set('AREA'					,record['AREA']);
			grdRecord.set('HIRE_CUST_CD'			,record['HIRE_CUST_CD']);
			grdRecord.set('HIRE_CUST_NM'			,record['HIRE_CUST_NM']);
			grdRecord.set('COMPANY_NUM'				,record['COMPANY_NUM']);
			grdRecord.set('MOVE_IN_DATE'			,record['MOVE_IN_DATE']);
			grdRecord.set('UPDATE_DATE'				,record['UPDATE_DATE']);
			grdRecord.set('LEAVING_DATE'			,record['LEAVING_DATE']);
			grdRecord.set('GUARANTY'				,record['GUARANTY']);
			grdRecord.set('MONTHLY_RENT'			,record['MONTHLY_RENT']);
			grdRecord.set('TOTAL'					,record['TOTAL']);
			grdRecord.set('INTEREST'				,record['INTEREST']);
			grdRecord.set('MONTHLY_TOTAL'			,record['MONTHLY_TOTAL']);
			grdRecord.set('SORT_ORDER'				,record['SORT_ORDER']);
			grdRecord.set('UPDATE_DB_USER'			,record['UPDATE_DB_USER']);
			grdRecord.set('UPDATE_DB_TIME'			,record['UPDATE_DB_TIME']);
			grdRecord.set('COMP_CODE'				,record['COMP_CODE']);
		}
    });   
	
	var textForm = Unilite.createSearchForm('textForm', {
		region: 'south',
		title: '작성방법',
        defaultType: 'uniSearchSubPanel',
        collapseDirection: 'bottom',
        border: true,
        // 공간을 너무 많이 차지하여 접을 수 있도록 설정
        collapsible: true,
        padding: '1 1 1 1',
		items: [{
			padding: '5 5 5 5',
			xtype: 'container',
			html: // '</br><b>※ 작성방법</b></br></br>'+
				  ' 1. 층을 기재하실 경우 “B”, &nbsp “숫자”, &nbsp “-”, &nbsp “,”만 입력할 수 있습니다. 그 외 문자가 들어가면 전자신고변환시 오류가 발생합니다.</br></br>'+
				  '&nbsp&nbsp&nbsp&nbsp예) 지하1층을 임대하는 경우 : B1					</br>'+
				  '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp지상1층, 2층, 3층을 임대하는 경우 : 1-3	</br>'+
				  '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp지하1층과 지상 1층을 임대하는 경우 : B1,&nbsp1	</br></br>'+
				  ' 2. 그외 작성방법은 국세청 서식을 참고하여 입력합니다.</br></br>',
			style: {
				color: 'blue'				
			}
		}]
	});

    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, textForm, panelResult
			]	
		}		
		, panelSearch
		],
		id  : 'atx400ukrApp',
		fnInitBinding : function() {
            panelSearch.getField('FR_PUB_DATE').setReadOnly(false);
            panelSearch.getField('TO_PUB_DATE').setReadOnly(false);
            panelSearch.getField('BILL_DIV_CODE').setReadOnly(false);
            
            panelResult.getField('FR_PUB_DATE').setReadOnly(false);
            panelResult.getField('TO_PUB_DATE').setReadOnly(false);
            panelResult.getField('BILL_DIV_CODE').setReadOnly(false);
                
			panelSearch.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
			panelSearch.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_PUB_DATE',UniDate.get('today'));
			panelResult.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TO_PUB_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			if(!UniAppManager.app.checkForNewDetail()) {
				return false;
			} else {
				MasterStore.loadStoreRecords();
                panelSearch.getField('FR_PUB_DATE').setReadOnly(true);
                panelSearch.getField('TO_PUB_DATE').setReadOnly(true);
                panelSearch.getField('BILL_DIV_CODE').setReadOnly(true);
                
                panelResult.getField('FR_PUB_DATE').setReadOnly(true);
                panelResult.getField('TO_PUB_DATE').setReadOnly(true);
                panelResult.getField('BILL_DIV_CODE').setReadOnly(true);
                
				UniAppManager.setToolbarButtons(['reset','newData'], true); 
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.getField('FR_PUB_DATE').focus();
			panelResult.getField('FR_PUB_DATE').focus();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			this.fnInitBinding();
			MasterStore.clearData();
			UniAppManager.setToolbarButtons(['reset','newData', 'delete', 'save'], false); 
		},
		onNewDataButtonDown: function()	{		// 행추가
			// if(containerclick(masterGrid)) {
				var startField2 = panelSearch.getField('FR_PUB_DATE');
				var startDateValue2 = startField2.getStartDate();
				var endField2 = panelSearch.getField('TO_PUB_DATE');
				var endDateValue2 = endField2.getEndDate();
			
				var compCode    	=	UserInfo.compCode;   
				var billDivCode 	=	panelSearch.getValue('BILL_DIV_CODE');
				var frPubDate		= 	startDateValue2;
				var toPubDate		= 	endDateValue2;
				var seq = MasterStore.max('SEQ');
	            if(!seq) seq = 1;
	            else seq += 1;
				var buildCode	   	=	'';
				var buildName	   	=	'';
				var dong			=	'';
				var upUnder			=	'';
				var upFloor			=	'';
				var house			=	'';
				var houseCnt     	=	'';
				var area 		  	= 	'';
				
				var r = {
					COMP_CODE    	:	compCode,    
					BILL_DIV_CODE	:	billDivCode, 
					FR_PUB_DATE		:	frPubDate,
					TO_PUB_DATE		:	toPubDate,
					SEQ				:	seq,
					BUILD_CODE	 	:	buildCode,	
					BUILD_NAME	 	:	buildName,	
					DONG			:	dong,		
					UP_UNDER		:	upUnder,		
					UP_FLOOR		:	upFloor,		
					HOUSE			:	house,		
					HOUSE_CNT    	:	houseCnt,   
					AREA 		 	:	area 		
				};
				masterGrid.createRow(r);
		},
		InterestRateNewDataButtonDown: function()	{	// 이자율
				var interestRate	=	'';
				var applyDate		=	'';
				var compCode    	=	UserInfo.compCode;  
				
				var r = {
					INTEREST_RATE	: interestRate,
					APPLY_DATE		: applyDate,
					COMP_CODE		: compCode		
				};
				InterestRateGrid.createRow(r);
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		InterestRateDeleteDataButtonDown: function() {	// 이자율
			InterestRateGrid.deleteSelectedRow();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			MasterStore.saveStore();
		},
		InterestRateSaveDataButtonDown: function(config) {	// 이쟈율 저장 버튼
			InterestRateStore.saveStore();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
			return panelResult.setAllFieldsReadOnly(true);
        }
	});
	
	Unilite.createValidator('validator01', {
		store: MasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				
				case "GUARANTY" :			// 보증금
					var param = {
						"FR_PUB_DATE" : UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE'))
					}
                    //atx400ukrService.interestRateForCal(param, function(provider, response){
					atx400ukrService.fnGetInterestRate(param, function(provider, response){
						var onQueryInterestRate = 1.00;
						
                    	if(provider.length == 0) {
                            alert('해당 신고기간에 등록된 이자율이 없습니다. \n이자율을 등록하고 진행해 주세요.');
                            record.set('GUARANTY', oldValue);
                            return false;
        					
                    	} else {
                            onQueryInterestRate =  parseFloat(provider.INTEREST_RATE);
                    	}
                    	
                        //보증금이자 :                    보증금   * 이자율                      / 365 * 과세기간의 일수 
                        record.set('INTEREST', Math.floor(newValue * (onQueryInterestRate / 100) / 365 * getDateDiff(record)));
                        //합계 :               보증금이자             + 월세(계)
                        record.set('TOTAL', record.get('INTEREST') + record.get('MONTHLY_TOTAL'));

                    });
				break;
				
				case "MONTHLY_RENT" :		// 월세
					if(newValue == '') {
//						record.set('TOTAL','0');
						record.set('MONTHLY_TOTAL','0');
					}
					record.set('MONTHLY_TOTAL', newValue * 3);
                    //합계 :               보증금이자             + 월세(계)
                    record.set('TOTAL', record.get('INTEREST') + record.get('MONTHLY_TOTAL'));
				break;
				
				case "INTEREST" :			// 보증금이자
                    //합계 :               보증금이자             + 월세(계)
                    record.set('TOTAL', newValue + record.get('MONTHLY_TOTAL'));
				break;
				
				case "MONTHLY_TOTAL" :		// 월세(계)
//                    //합계 :               보증금이자             + 월세(계)
					record.set('TOTAL', record.get('INTEREST') + newValue);
				break;
			}
			return rv;
		}
	})
	
	//과세기간 일수 계산
    function getDateDiff (record){
        var startField = UniDate.getDbDateStr(record.get('MOVE_IN_DATE'));
        var endField   = UniDate.getDbDateStr(record.get('LEAVING_DATE'));
        
        if (Ext.isEmpty(startField)) {
            startField = UniDate.getDbDateStr(panelSearch.getField('FR_PUB_DATE').getStartDate());
        }
        
        if (Ext.isEmpty(endField)) {
            endField = UniDate.getDbDateStr(panelSearch.getField('TO_PUB_DATE').getEndDate());
        }

        startField = startField.substring(0,4) + '-' + startField.substring(4,6) + '-' + startField.substring(6,8);
        endField   = endField.substring(0,4)   + '-' + endField.substring(4,6)   + '-' + endField.substring(6,8);

        var arrDate1 = startField.split("-");
        var getDate1 = new Date(parseInt(arrDate1[0]),parseInt(arrDate1[1])-1,parseInt(arrDate1[2]));
        var arrDate2 = endField.split("-");
        var getDate2 = new Date(parseInt(arrDate2[0]),parseInt(arrDate2[1])-1,parseInt(arrDate2[2]));
        
        var getDiffTime = getDate2.getTime() - getDate1.getTime() + 86400000;           //날짜 차이 + 1(86400000ms) 
        
        return Math.floor(getDiffTime / (1000 * 60 * 60 * 24));
    }

};
</script>