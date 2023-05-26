<%--
'   프로그램명 : 프로젝트등록 (기준 - 수출업종용)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 : 2018.04.23
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>


<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="bcm621ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B046" /> <!-- 완료구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /><!-- 기준화폐-->
	<t:ExtComboStore comboType="AU" comboCode="T006" /><!-- 결제방법-->
</t:appConfig>
	<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var selectedGrid = 'bcm621ukrvGrid1';  // Grid1 createRow Default

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bcm621ukrvService.selectMaster',
			update: 'bcm621ukrvService.updateMaster',
			create: 'bcm621ukrvService.insertMaster',
			destroy: 'bcm621ukrvService.deleteMaster',
			syncAll: 'bcm621ukrvService.saveAll'
		}
	});


	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bcm621ukrvService.selectDetail',
			update: 'bcm621ukrvService.updateDetail',
			create: 'bcm621ukrvService.insertDetail',
			destroy: 'bcm621ukrvService.deleteDetail',
			syncAll: 'bcm621ukrvService.saveAll2'
		}
	});


	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('bcm621ukrvModel1', {
	    fields: [
			{name: 'UPDATE_DB_USER'		       	,text: '작성자'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'		       	,text: '작성시간'		,type: 'string'},
			{name: 'PJT_CODE'			       	,text: '프로젝트번호'		,type: 'string', allowBlank: false},
			{name: 'PJT_NAME'			       	,text: '프로젝트명'		,type: 'string', allowBlank: false},
			{name: 'PJT_AMT'			       	,text: '금액'			,type: 'uniPrice'},
			{name: 'FR_DATE'			       	,text: '시작일'		,type: 'uniDate', allowBlank: false},
			{name: 'TO_DATE'			       	,text: '종료일'		,type: 'uniDate', allowBlank: false},
			{name: 'CUSTOM_CODE'		       	,text: '거래처'		,type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'		       	,text: '거래처명'		,type: 'string', allowBlank: false},
			{name: 'START_DATE'			       	,text: '개시일'		,type: 'uniDate'},
			{name: 'SAVE_CODE'			       	,text: '통장코드'		,type: 'string'},
			{name: 'SAVE_NAME'			       	,text: '통장명'		,type: 'string'},
			{name: 'DIVI'				       	,text: '완료구분'		,type: 'string', comboType:'AU', comboCode:'B046'},
			{name: 'COMP_CODE'			       	,text: 'COMP_CODE'	,type: 'string'}
		]
	});		//End of Unilite.defineModel('bcm621ukrvModel', {


	Unilite.defineModel('bcm621ukrvModel2', {
	    fields: [
			{name: 'UPDATE_DB_USER'	       	,text: '작성자'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'	       	,text: '작성시간'		,type: 'string'},
			{name: 'PJT_CODE'		       	,text: '프로젝트번호'	,type: 'string'},
			{name: 'INPUT_DATE'		       	,text: '입금일자'			,type: 'uniDate'},
			{name: 'MONEY_UNIT'			    ,text: '화폐'		,type: 'string'	, comboType:'AU',comboCode:'B004', displayField: 'value'},
			{name: 'EXCHG_RATE'		       	,text: '환율'			,type: 'uniER'},
			{name: 'BEFORE_AMT'				,text: '계약금액'			,type: 'uniPrice'},
			{name: 'AMT'			       	,text: '입금액(원화)'	,type: 'uniPrice'},
			{name: 'DEPOSIT_TYPE'			,text: '결제조건'		,type: 'string'},
			{name: 'DUE_DATE'		       	,text: '입금예정일자'			,type: 'uniDate'},
			{name: 'OUTPUT_DATE'		   	,text: '출하일자'			,type: 'uniDate'},
			{name: 'SHIP_DATE'		       	,text: '선적일자'			,type: 'uniDate'},
			{name: 'INVOICE_NO'			    ,text: '인보이스번호'	,type: 'string'},
			{name: 'INVOICE_AMT'			,text: '인보이스금액'	,type: 'uniPrice'},
			{name: 'REMARK'			       	,text: '적요'			,type: 'string'},
			{name: 'COMP_CODE'		       	,text: 'COMP_CODE'	,type: 'string'},
			{name: 'NO'		       			,text: 'NO'			,type: 'string'}

		]
	});		//End of Unilite.defineModel('bcm621ukrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */

	var directMasterStore = Unilite.createStore('bcm621ukrvMasterStore',{
			model: 'bcm621ukrvModel1',
			autoLoad : false,
			uniOpt: {
            	isMaster: false,				// 상위 버튼 연결
            	editable: true,				// 수정 모드 사용
            	deletable: true,			// 삭제 가능 여부
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
            loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {

	           		if(records[0] != null){
	           			panelSearch.setValue('PJT_CODE',records[0].get('PJT_CODE'));
		           		if(panelSearch.getValue('PJT_CODE') != ''){
		           				directDetailStore.loadStoreRecords(records);
		           		}
		           		UniAppManager.setToolbarButtons('delete', true);
	           		}else{
	           			panelSearch.setValue('PJT_CODE','');
	           			detailGrid.getStore().removeAll();
	           			UniAppManager.setToolbarButtons('delete', false);
	           		}

	           	},
				update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
					UniAppManager.setToolbarButtons('save', true);
				},
				datachanged : function(store,  eOpts) {
					if( directDetailStore.isDirty() || store.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
				}
			},
			saveStore : function(config)	{
				var inValidRecs = this.getInvalidRecords();
            	//var rv = true;

				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {
							//panelResult.resetDirtyStatus();
							if(directDetailStore.isDirty()) {
								directDetailStore.saveStore();
							}
							UniAppManager.setToolbarButtons('save', false);
						 }
					};
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}

			}
	});		// End of var directMasterStore = Unilite.createStore('bcm621ukrvMasterStore1',{

	var directDetailStore = Unilite.createStore('bcm621ukrvDetailStore',{
			model: 'bcm621ukrvModel2',
			autoLoad : false,
			uniOpt: {
            	isMaster: false,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable: true,		// 삭제 가능 여부
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy2,
            loadStoreRecords: function(record)	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			},
			saveStore : function(config)	{
				var inValidRecs = this.getInvalidRecords();

				if(inValidRecs.length == 0 )	{
					/*
					var records = this.getData();
					Ext.each(records, function(record,i) {
						Unilite.messageBox(record[i].PJT_CODE);
					});
					*/
					config = {
						success: function(batch, option) {
							//panelResult.resetDirtyStatus();
							if(directMasterStore.isDirty()) {
								directMasterStore.saveStore();
							}
							UniAppManager.setToolbarButtons('save', false);
						 }
					};
					this.syncAllDirect();
				}else {
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		if(records != null && records.length > 0 ){
	           			UniAppManager.setToolbarButtons('delete', true);
	           		}
	           	},
				update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
					UniAppManager.setToolbarButtons('save', true);
				},
				datachanged : function(store,  eOpts) {
					if( directMasterStore.isDirty() || store.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
				}
			}
	});		// End of var directDetailStore = Unilite.createStore('bcm621ukrvDetailStore',{

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [
			    {
        			xtype: 'uniTextfield',
		            name: 'PROJECT_CODE',
	    			fieldLabel: '프로젝트번호' ,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('PROJECT_CODE', newValue);
						},
						onClear: function(type)	{
							panelResult.setValue('PROJECT_CODE', '');
						}
					}
	    		},{
	    			xtype: 'uniTextfield',
	            	name: 'PROJECT_NAME',
	            	fieldLabel: '프로젝트명',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('PROJECT_NAME', newValue);
						},
						onClear: function(type)	{
							panelResult.setValue('PROJECT_NAME', '');
						}
					}
	            },
/*				Unilite.popup('PROJECT',{
					fieldLabel: '프로젝트번호',
					validateBlank: false,
					textFieldName:'PROJECT_NO',
					itemId:'project',
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'BPARAM0': 3});
							popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
						},
						onSelected: {
							fn: function(records, type) {
								Unilite.messageBox('records : ', records);
								panelResult.setValue('PROJECT_NO', panelSearch.getValue('PROJECT_NO'));
		                	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('PROJECT_NO', '');
						}
					},
					tdAttrs: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				}),	*/
				Unilite.popup('CUST', {
						fieldLabel: '거래처',
						valueFieldName: 'CUST_CODE',
						textFieldName: 'CUST_NAME',
  					    //validateBlank:false,
						popupWidth: 710,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CUST_CODE', panelSearch.getValue('CUST_CODE'));
									panelResult.setValue('CUST_NAME', panelSearch.getValue('CUST_NAME'));
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('CUST_CODE', '');
								panelResult.setValue('CUST_NAME', '');
							}
						}
					}),
			{
				fieldLabel: '완료구분',
				name:'STATE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B046',
				listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								    panelResult.setValue('STATE', newValue);
							}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '기간조건',
				id: 'rdoSelectPnl',
				labelWidth:90,
				items: [{
					boxLabel: '시작일',
					width:60,
					name: 'rdoSelect' ,
					inputValue: '1',
					checked: true
				},{
					boxLabel: '종료일',
					width:60,
					name: 'rdoSelect' ,
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
						//Unilite.messageBox("========" + newValue.rdoSelect);
						//panelResult.setValue('rdoSelect', newValue.rdoSelect);
					}
				}
			},{
				fieldLabel: '기간',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				xtype: 'uniDateRangefield',
				width: 320,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();

			    	}
			    }
			}


/*			{
	        	fieldLabel: '기간',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width:320,
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
			}*/

			,{
				fieldLabel: '조회후 선택된 프로젝트번호',
				name:'PJT_CODE',
				xtype: 'uniTextfield',
				hidden: true
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

					   	Unilite.messageBox(labelText+Msg.sMB083);
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
    });		// End of var panelSearch = Unilite.createSearchForm('searchForm',{


    var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items : [
					{
	        			xtype: 'uniTextfield',
			            name: 'PROJECT_CODE',
		    			fieldLabel: '프로젝트번호' ,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('PROJECT_CODE', newValue);
							},
							onClear: function(type)	{
								panelSearch.setValue('PROJECT_CODE', '');
							}
						}
		    		},{
		    			xtype: 'uniTextfield',
		            	name: 'PROJECT_NAME',
		            	fieldLabel: '프로젝트명',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('PROJECT_NAME', newValue);
							},
							onClear: function(type)	{
								panelSearch.setValue('PROJECT_NAME', '');
							}
						}
		            },
/*					Unilite.popup('PROJECT',{
						fieldLabel: '프로젝트번호',
						validateBlank: true,
						textFieldName:'PROJECT_NO',
						itemId:'projectRlt',
						listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'BPARAM0': 3});
								popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
							},
							onSelected: {
								fn: function(records, type) {
									Unilite.messageBox('records : ', records);
									panelSearch.setValue('PROJECT_NO', panelResult.getValue('PROJECT_NO'));
			                	},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('PROJECT_NO', '');
							}
						}
					}),*/
					Unilite.popup('CUST', {
											fieldLabel: '거래처',
											valueFieldName: 'CUST_CODE',
											textFieldName: 'CUST_NAME',
											//validateBlank:false,
											//labelWidth:150,
											popupWidth: 710,
											listeners: {
												onSelected: {
													fn: function(records, type) {
														panelSearch.setValue('CUST_CODE', panelResult.getValue('CUST_CODE'));
														panelSearch.setValue('CUST_NAME', panelResult.getValue('CUST_NAME'));
													},
													scope: this
												},
												onClear: function(type)	{
													panelSearch.setValue('CUST_CODE', '');
													panelSearch.setValue('CUST_NAME', '');
												}
											}
								 }),
					 {
						fieldLabel: '완료구분',
						name:'STATE',
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'B046',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								    panelSearch.setValue('STATE', newValue);
							}
						}
					},{
						xtype: 'radiogroup',
						fieldLabel: '기간조건',
						id: 'rdoSelectRlt',
						labelWidth:90,
						items: [{
							boxLabel: '시작일',
							width:60,
							name: 'rdoSelect' ,
							inputValue: '1',
							checked: true
						},{
							boxLabel: '종료일',
							width:60,
							name: 'rdoSelect' ,
							inputValue: '2'
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
									panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
								    //Unilite.messageBox("========" + newValue.rdoSelect);
									//panelSearch.setValue('rdoSelect', newValue.rdoSelect);
							}
						}
					},{
						fieldLabel: '기간',
						startFieldName: 'FR_DATE',
						endFieldName: 'TO_DATE',
						xtype: 'uniDateRangefield',
						width: 320,
						startDate: UniDate.get('startOfMonth'),
						endDate: UniDate.get('today'),
		                onStartDateChange: function(field, newValue, oldValue, eOpts) {
		                	if(panelSearch) {
								panelSearch.setValue('FR_DATE',newValue);
								//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
		                	}
					    },
					    onEndDateChange: function(field, newValue, oldValue, eOpts) {
					    	if(panelSearch) {
					    		panelSearch.setValue('TO_DATE',newValue);
					    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();

					    	}
					    }
					}
/*						{
			        	fieldLabel: '기간',
			        	xtype: 'uniDateRangefield',
			        	startFieldName: 'FR_DATE',
						endFieldName: 'TO_DATE',
						startDate: UniDate.get('startOfMonth'),
						endDate: UniDate.get('today'),
						width:320,
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
					}*/
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

					   	Unilite.messageBox(labelText+Msg.sMB083);
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

    var masterGrid= Unilite.createGrid('bcm621ukrvGrid1', {
        layout:'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			//useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	store: directMasterStore,
    	features: [
    		{id : 'MasterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'MasterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
        columns:  [
        	{dataIndex:'UPDATE_DB_USER'		     	, width: 0,hidden:true},
        	{dataIndex:'UPDATE_DB_TIME'		     	, width: 0,hidden:true},
        	{dataIndex:'PJT_CODE'			     	, width: 100},
        	{dataIndex:'PJT_NAME'			     	, width: 300},
        	{dataIndex:'PJT_AMT'			     	, width: 133},
        	{dataIndex:'FR_DATE'			     	, width: 86},
        	{dataIndex:'TO_DATE'			     	, width: 86},
        	{dataIndex:'CUSTOM_CODE'		     	, width: 86,
        		editor: Unilite.popup('AGENT_CUST_G', {
 				DBtextFieldName: 'CUSTOM_CODE',
 				extParam: {AGENT_TYPE: '4'},
			  	autoPopup: true,
 				listeners: {'onSelected': {
						fn: function(records, type) {
							Ext.each(records, function(record,i) {
								if(i==0) {
									var grdRecord = masterGrid.getSelectedRecord();
									grdRecord.set('CUSTOM_CODE',record['CUSTOM_CODE'] );
									grdRecord.set('CUSTOM_NAME',record['CUSTOM_NAME'] );
								}
							});
						},
						scope: this
					},
					'onClear': function(type) {
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('CUSTOM_CODE','');
						grdRecord.set('CUSTOM_NAME','');
					}
				}
        	})},
        	{dataIndex:'CUSTOM_NAME'		     	, width: 166,
        		editor: Unilite.popup('AGENT_CUST_G', {
 				DBtextFieldName: 'CUSTOM_CODE',
 				extParam: {AGENT_TYPE: '4'},
			  	autoPopup: true,
 				listeners: {'onSelected': {
						fn: function(records, type) {
							Ext.each(records, function(record,i) {
								if(i==0) {
									var grdRecord = masterGrid.getSelectedRecord();
									grdRecord.set('CUSTOM_CODE',record['CUSTOM_CODE'] );
									grdRecord.set('CUSTOM_NAME',record['CUSTOM_NAME'] );
								}
							});
						},
						scope: this
					},
					'onClear': function(type) {
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('CUSTOM_CODE','');
						grdRecord.set('CUSTOM_NAME','');
					}
				}
        	})},
        	{dataIndex:'START_DATE'			     	, width: 86},
        	{dataIndex:'SAVE_CODE'			     	, width: 66,
        		editor: Unilite.popup('BANK_BOOK_G', {
        			DBtextFieldName: 'BANK_BOOK_NAME',
			  		autoPopup: true,
     				listeners: {'onSelected': {
    						fn: function(records, type) {
    							Ext.each(records, function(record,i) {
    								if(i==0) {
    									var grdRecord = masterGrid.getSelectedRecord();
    									grdRecord.set('SAVE_CODE',record['BANK_BOOK_CODE'] );
    									grdRecord.set('SAVE_NAME',record['BANK_BOOK_NAME'] );
    								}
    							});
    						},
    						scope: this
    					},
    					'onClear': function(type) {
    						var grdRecord = masterGrid.getSelectedRecord();
    						grdRecord.set('SAVE_CODE','');
    						grdRecord.set('SAVE_NAME','');
    					}
    				}
            })},
        	{dataIndex:'SAVE_NAME'					, width: 120,
        		editor: Unilite.popup('BANK_BOOK_G', {
        			DBtextFieldName: 'BANK_BOOK_NAME',
			  		autoPopup: true,
     				listeners: {'onSelected': {
    						fn: function(records, type) {
    							Ext.each(records, function(record,i) {
    								if(i==0) {
    									var grdRecord = masterGrid.getSelectedRecord();
    									grdRecord.set('SAVE_CODE',record['BANK_BOOK_CODE'] );
    									grdRecord.set('SAVE_NAME',record['BANK_BOOK_NAME'] );
    								}
    							});
    						},
    						scope: this
    					},
    					'onClear': function(type) {
    						var grdRecord = masterGrid.getSelectedRecord();
    						grdRecord.set('SAVE_CODE','');
    						grdRecord.set('SAVE_NAME','');
    					}
    				}
            })},
            {dataIndex:'DIVI'			            , width: 100, align: 'center'},
            {dataIndex:'COMP_CODE'			        , width: 0,hidden:true}

		],
		listeners: {

        	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {       //Retrieves the top level element representing this component
			    	if(directDetailStore.isDirty()){                  //Returns true if the value of this Field has been changed from its originalValue. Will return false if the field is disabled or has not been rendered
	        			Unilite.messageBox(Msg.sMB154);
	        			return;
	        		}
			    	var oldGrid = Ext.getCmp(selectedGrid);
			    	grid.changeFocusCls(oldGrid);
			    	selectedGrid = girdNm;
			    	if(grid.getStore().getCount() > 0)	{
			    		UniAppManager.setToolbarButtons(['delete'], true);
			    	}else{
			    		UniAppManager.setToolbarButtons(['delete'], false);
			    	}

			    });

			},

        	beforeedit  : function( editor, e, eOpts ) {

      			if(!e.record.phantom)	{
					if (UniUtils.indexOf(e.field,['PJT_CODE']))
							return false;
				}
        	},
        	selectionchangerecord:function(record , selected)	{
        		if(directDetailStore.isDirty()){                  //Returns true if the value of this Field has been changed from its originalValue. Will return false if the field is disabled or has not been rendered
        			//Unilite.messageBox(Msg.sMB154);
        			return;
        		}
        		panelSearch.setValue('PJT_CODE',record.get('PJT_CODE'));
				directDetailStore.loadStoreRecords(record);
          	}
        	/*,
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons('newData', 'delete', true);
			}*/
		}
    });

    /**
     * Master Grid2 정의(Grid Panel)
     * @type
     */
	var detailGrid = Unilite.createGrid('bcm621ukrvGrid2', {
		layout:'fit',
        region:'south',
        split:true,
        uniOpt: {
			expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	store: directDetailStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],

        columns:  [
        	{dataIndex:'UPDATE_DB_USER'	, width:0,hidden:true},
        	{dataIndex:'UPDATE_DB_TIME'	, width:0,hidden:true},
        	{dataIndex:'PJT_CODE'		, width:90,hidden:true},
        	{dataIndex:'INPUT_DATE'		, width:86, align: 'center'},
        	{dataIndex:'AMT'			, width:133},
        	{dataIndex:'MONEY_UNIT'		, width:86, align: 'center'},
        	{dataIndex:'EXCHG_RATE'		, width:86},
        	{dataIndex:'BEFORE_AMT'		, width:133},
        	{dataIndex:'DEPOSIT_TYPE'	, width:200},
        	{dataIndex:'OUTPUT_DATE'	, width:86, align: 'center'},
        	{dataIndex:'SHIP_DATE'		, width:86, align: 'center'},
        	{dataIndex:'INVOICE_NO'		, width:120},
        	{dataIndex:'INVOICE_AMT'	, width:120},
        	{dataIndex:'DUE_DATE'		, width:86, align: 'center'},
        	{dataIndex:'REMARK'			, width:300},
        	{dataIndex:'COMP_CODE'		, width:0,hidden:true},
        	{dataIndex:'NO'				, width:0,hidden:true}

    	],
    	listeners: {

        	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	if(directMasterStore.isDirty()){
	        			Unilite.messageBox(Msg.sMB154);
	        			return;
	        		}
			    	var oldGrid = Ext.getCmp(selectedGrid);
			    	grid.changeFocusCls(oldGrid);
			    	selectedGrid = girdNm;
			    	if(grid.getStore().getCount() > 0)	{
			    		UniAppManager.setToolbarButtons(['delete'], true);
			    	}else{
			    		UniAppManager.setToolbarButtons(['delete'], false);
			    	}

			    });

			},

        	beforeedit  : function( editor, e, eOpts ) {
      			if(!e.record.phantom){
					if (UniUtils.indexOf(e.field,['INPUT_DATE']))
							return false;
				}
        	}/*,
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons('newData', 'delete', true);
			}*/
		}
	});		// End of var detailGrid= Unilite.createGrid('bcm621ukrvGrid2', {

    Unilite.Main({

		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				    panelResult, masterGrid, detailGrid
				  ]
			}
			,panelSearch
		],
		id: 'bcm621ukrvApp',
		fnInitBinding: function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons('detail',false);
			panelSearch.setValue('TO_DATE', UniDate.get('today'));
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_DATE')));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
			panelResult.setValue('FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_DATE')));
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons(['reset','newData', 'delete'],true);

		},
		onNewDataButtonDown : function()	{
			if(selectedGrid == 'bcm621ukrvGrid1'){
				var r = {
	            	DIVI         : 'N'
	            };
	            masterGrid.createRow(r, 'PJT_CODE');
				panelSearch.setAllFieldsReadOnly(true);
				UniAppManager.setToolbarButtons('save', true);
			}
			else if(selectedGrid == 'bcm621ukrvGrid2'){
		        var selRow = masterGrid.getSelectedRecord();
	            //Unilite.messageBox(selRow.get('PJT_CODE'));
	            var pjtCode  = selRow.get('PJT_CODE');
	            if(Ext.isEmpty(pjtCode)){
					Unilite.messageBox("먼저 상단그리드 선택행의 프로젝트번호를 입력해 주세요");
					return;
				};
				var statCode  = selRow.get('DIVI');
	            if(statCode == 'Y'){
	            	Unilite.messageBox('<t:message code="unilite.msg.sMB027"/>');
					return;
				};

	            var r = {
	            	PJT_CODE          : pjtCode,
	            	AMT				  : 0
	            };
	            detailGrid.createRow(r, 'INPUT_DATE', detailGrid.getStore().getCount()-1);
				panelSearch.setAllFieldsReadOnly(true);
				UniAppManager.setToolbarButtons('save', true);
			}

		},
		onResetButtonDown: function() {

			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);

			masterGrid.reset();
			detailGrid.reset();
			directMasterStore.clearData();
			directDetailStore.clearData();

			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
		},
		onSaveDataButtonDown: function(config) {
			if(directMasterStore.isDirty()) {
				directMasterStore.saveStore();
			}else if(directDetailStore.isDirty()) {
				directDetailStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			if(selectedGrid == 'bcm621ukrvGrid1'){
				var selIndex = masterGrid.getSelectedRowIndex();
				var selRow = masterGrid.getSelectedRecord();
				var statCode  = selRow.get('DIVI');
	            if(statCode == 'Y'){
	            	Unilite.messageBox('<t:message code="unilite.msg.sMB027"/>');
					return;
				};
                if(!Ext.isEmpty(selRow)){
    				if(selRow.phantom != true && directDetailStore.getCount() > 0 )
    				{
    					//Unilite.messageBox("등록한 날자별 금액이 존재하는 프로젝트번호는 삭제가 불가능 합니다.");
    					Unilite.messageBox('<t:message code="unilite.msg.sMB028"/>');
    					return;
    
    				}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
    					masterGrid.deleteSelectedRow(selIndex);
    					masterGrid.getStore().onStoreActionEnable();
    				}
                }else{
                    UniAppManager.setToolbarButtons('delete', false);
                }
			}else if(selectedGrid == 'bcm621ukrvGrid2'){
				var mstSelRow = masterGrid.getSelectedRecord();
				var statCode  = mstSelRow.get('DIVI');
	            if(statCode == 'Y'){
	            	Unilite.messageBox('<t:message code="unilite.msg.sMB027"/>');
					return;
				};
				var selIndex = detailGrid.getSelectedRowIndex();
				var selRow = detailGrid.getSelectedRecord();
                if(!Ext.isEmpty(selRow)){
    				if(selRow.phantom == true)
    					detailGrid.deleteSelectedRow();
    				else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
    					detailGrid.deleteSelectedRow();
    				}
                }else{
                	UniAppManager.setToolbarButtons('delete', false);
                }
			}
		}
	});		// End of Unilite.Main({

	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
/*				case "AMT" : // 금액
					if(newValue <= '0') {
						rv= Msg.sMB076;
						break;
					}
					if(record.get('AMT') < record.get('BEFORE_AMT')) {
						//rv= Msg.sMM338;
						rv= "금액이 선수금보다 작을수 없습니다";
						break;
					}
				break;

				case "EXCHG_RATE" : // 환율
//					var dContractO=record.get('EXCHG_RATE')*record.get('CONTRACT_AMT');
					var dContractO=newValue*record.get('CONTRACT_AMT');
					record.set('AMT', dContractO);
				break;

				case "CONTRACT_AMT" : // 계약금액
//					var dContractO=record.get('EXCHG_RATE')*record.get('CONTRACT_AMT');
					var dContractO=record.get('EXCHG_RATE')*newValue;
					record.set('AMT', dContractO);
				break;  */


/*				case "BEFORE_AMT" : // 선수금
					if(newValue <= '0') {
						rv= Msg.sMB076;
						break;
					}
					if(record.get('AMT') < record.get('BEFORE_AMT')) {
						//rv= Msg.sMM338;
						rv= "금액이 선수금보다 작을수 없습니다";
						break;
					}
				break;*/
			}
			return rv;
		}
	});

};
</script>
