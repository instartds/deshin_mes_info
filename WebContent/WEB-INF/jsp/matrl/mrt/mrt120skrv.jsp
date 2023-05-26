<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrt120skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="mrt120skrv" /> 				<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	
	Unilite.defineModel('mrt120skrvModel', {
	    fields: [
	    	{name: 'CUSTOM_CODE'			, text: '매입처'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'			, text: '매입처명'		, type: 'string'},
	    	
	    	{name: 'CON_BUY_Q'				, text: '반품수량'		, type: 'uniQty'},
	    	{name: 'CON_AMT'				, text: '반품금액'		, type: 'uniPrice'},
	    	{name: 'CON_TAX'				, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'		, type: 'uniPrice'},
	    	{name: 'SUM_CONSIGNMENT'		, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniPrice'},
	    	
	    	{name: 'NOW_BUY_Q'				, text: '반품수량'		, type: 'uniQty'},
	    	{name: 'NOW_AMT'				, text: '반품금액'		, type: 'uniPrice'},
	    	{name: 'NOW_TAX'				, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'		, type: 'uniPrice'},
	    	{name: 'SUM_BUYNOW'				, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniPrice'},
	    	
	    	
	    	{name: 'TOTAL_BUY_Q'			, text: '반품수량'		, type: 'uniQty'},
	    	{name: 'TOTAL_AMT'				, text: '반품금액'		, type: 'uniPrice'},
	    	{name: 'TOTAL_TAX'				, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'		, type: 'uniPrice'},
	    	{name: 'TOTAL_SUM'				, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniPrice'}
	    ]
	});//End of Unilite.defineModel('mrt120skrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mrt120skrvMasterStore1', {
		model: 'mrt120skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'mrt120skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
				
		}/*,
		groupField: 'CUSTOM_NAME'*/
			
	});//End of var directMasterStore1 = Unilite.createStore('mrt120skrvMasterStore1', {
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '사업부', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
				Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelResult.setValue('DEPT_CODE', '');
								panelResult.setValue('DEPT_NAME', '');
					}
				}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'BASIS_DATA_FR',
				endFieldName: 'BASIS_DATA_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('BASIS_DATA_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('BASIS_DATA_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUST_CODE1', 
				textFieldName: 'CUST_NAME1', 
			//	validateBlank:false, 
				popupWidth: 710,
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CUST_CODE1', panelSearch.getValue('CUST_CODE1'));
									panelResult.setValue('CUST_NAME1', panelSearch.getValue('CUST_NAME1'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('CUST_CODE1', '');
								panelResult.setValue('CUST_NAME1', '');
							}
						}
			}),
				Unilite.popup('CUST',{ 
					fieldLabel: '~', 
					valueFieldName: 'CUST_CODE2', 
					textFieldName: 'CUST_NAME2', 
				//	validateBlank: false, 
					popupWidth: 710,
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CUST_CODE2', panelSearch.getValue('CUST_CODE2'));
									panelResult.setValue('CUST_NAME2', panelSearch.getValue('CUST_NAME2'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('CUST_CODE2', '');
								panelResult.setValue('CUST_NAME2', '');
							}
						}
				})
			]
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '사업부', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType: 'BOR120', 
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				allowBlank: false,
				holdable: 'hold',
				colspan:2,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
					}
				}
			}),
		{
			fieldLabel: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'BASIS_DATA_FR',
			endFieldName: 'BASIS_DATA_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('BASIS_DATA_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('BASIS_DATA_TO',newValue);
		    	}
		    }
		},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUST_CODE1', 
				textFieldName: 'CUST_NAME1', 
			//	validateBlank:false,
				popupWidth: 710,
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('CUST_CODE1', panelResult.getValue('CUST_CODE1'));
							panelSearch.setValue('CUST_NAME1', panelResult.getValue('CUST_NAME1'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('CUST_CODE1', '');
						panelSearch.setValue('CUST_NAME1', '');
					}
				}
			}),
			Unilite.popup('CUST',{ 
				fieldLabel: '~', 
				valueFieldName: 'CUST_CODE2', 
				textFieldName: 'CUST_NAME2', 
			//	validateBlank: false, 
				labelWidth:10,
				popupWidth: 710,
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('CUST_CODE2', panelResult.getValue('CUST_CODE2'));
							panelSearch.setValue('CUST_NAME2', panelResult.getValue('CUST_NAME2'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('CUST_CODE2', '');
						panelSearch.setValue('CUST_NAME2', '');
					}
				}
			})
		]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('mrt120skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		excelTitle: '반품 지급결의현황 조회',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: directMasterStore1,
        columns: [
        	{dataIndex: 'CUSTOM_CODE'         , width: 120,locked:true,
               summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
        	{dataIndex: 'CUSTOM_NAME'		, width: 150,locked:true},
			{ 
         	text:'위탁',
         		columns: [
		         	{dataIndex: 'CON_BUY_Q'		, width: 88,summaryType: 'sum'},
		        	{dataIndex: 'CON_AMT'		, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'CON_TAX'		, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'SUM_CONSIGNMENT'	, width: 100,summaryType: 'sum'}
	         	]
			},{ 
	      	text:'현매',
     			columns: [
		        	{dataIndex: 'NOW_BUY_Q'		, width: 88,summaryType: 'sum'},
		        	{dataIndex: 'NOW_AMT'		, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'NOW_TAX'		, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'SUM_BUYNOW'	, width: 100,summaryType: 'sum'}
	        	]
			},{ 
    	 	text:'<t:message code="system.label.purchase.totalamount" default="합계"/>',
	     		columns: [
		        	{dataIndex: 'TOTAL_BUY_Q'	, width: 88,summaryType: 'sum'},
		        	{dataIndex: 'TOTAL_AMT'		, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'TOTAL_TAX'		, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'TOTAL_SUM'		, width: 100,summaryType: 'sum'}
	        	]
    	 }] 
    });//End of var masterGrid = Unilite.createGrid('ssd100skrvGrid1', {  
	
	Unilite.Main({
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
		id: 'mrt120skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
		},
		onQueryButtonDown: function() {
			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			
			
			
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);
			}
			
		},
		
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});

};


</script>
