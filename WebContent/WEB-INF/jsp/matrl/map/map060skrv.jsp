<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map060skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="map060skrv"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B034" /> <!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP36" /> <!-- 계산서 -->
	
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

	
	Unilite.defineModel('Map060skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string',comboType:'BOR120'},
	    	{name: 'CUSTOM_CODE'		, text: '매입처'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '매입처명'		, type: 'string'},
	    	{name: 'COLLECT_DAY'		, text: '지불일'		, type: 'string'},
	    	{name: 'RECEIPT_DAY'		, text: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>'		, type: 'string',comboType:'AU', comboCode:'B034'},
	    	{name: 'BILL_TYPE'			, text: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>'		, type: 'string',comboType:'AU', comboCode:'YP36'},	
	    	{name: 'IWAL_IN_AMT_I'		, text: '이월잔액'		, type: 'uniPrice'},	
	    	{name: 'IN_CR_AMT_I'		, text: '매입액'		, type: 'uniPrice'},  	 	
	    	{name: 'IN_DR_AMT_I'		, text: '지불액'		, type: 'uniPrice'},
	    	{name: 'IN_JAN_AMT_I'		, text: '기말잔액'		, type: 'uniPrice'},
	    	{name: 'END_STOCK_I'		, text: '기말재고액'	, type: 'uniPrice'},
	    	{name: 'TODAY_IN_AMT_I'		, text: '현재잔액'		, type: 'uniPrice'},
	    	{name: 'TODAY_STOCK_I'		, text: '현재고금액'	, type: 'uniPrice'},
	    	{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		, type: 'string'}
	    	
	    	
	    	
	    ]
	});//End of Unilite.defineModel('Map060skrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('map060skrvMasterStore1', {
		model: 'Map060skrvModel',
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
				read: 'map060skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
				
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
			}
		}
		//groupField: 'CUSTOM_NAME'
			
	});//End of var directMasterStore1 = Unilite.createStore('map060skrvMasterStore1', {
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
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
			},{
				fieldLabel: '실적일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '지불일자',
				name: 'COLLECT_DAY',
				xtype: 'uniTextfield',
				fieldStyle: 'text-align: right;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COLLECT_DAY', newValue);
					}
				}
			},
			Unilite.popup('CUST', { 
					fieldLabel: '매입처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
						}
					}
			}),{
				fieldLabel: '고객분류', 
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>', 
				name: 'RECEIPT_DAY',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B034',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RECEIPT_DAY', newValue);
					}
				}
			},{
	    		xtype: 'uniCheckboxgroup',	
	    		padding: '0 0 0 0',
	    		fieldLabel: ' ',
	    		id: 'CREDIT_YN1',
	    		items: [{
	    			boxLabel: '실적발생 매입처여부',
	    			width: 130,
	    			name: 'CREDIT_YN',
	    			inputValue: 'Y',
	    			uncheckedValue: 'N',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('CREDIT_YN', newValue);
						}
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '실적일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						masterForm.setValue('FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		masterForm.setValue('TO_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '지불일자',
				name: 'COLLECT_DAY',
				xtype: 'uniTextfield',
				colspan: 2,
				fieldStyle: 'text-align: right;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('COLLECT_DAY', newValue);
					}
				}
			},
			Unilite.popup('CUST', { 
					fieldLabel: '매입처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								masterForm.setValue('CUSTOM_CODE', '');
								masterForm.setValue('CUSTOM_NAME', '');
						}
					}
			}),{
				fieldLabel: '고객분류', 
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('AGENT_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>', 
				name: 'RECEIPT_DAY',
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'B034',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('RECEIPT_DAY', newValue);
					}
				}
			},{
	    		xtype: 'uniCheckboxgroup',	
	    		padding: '0 0 0 0',
	    		fieldLabel: ' ',
	    		id: 'CREDIT_YN2',
	    		items: [{
	    			boxLabel: '실적발생 매입처여부',
	    			width: 130,
	    			name: 'CREDIT_YN',
	    			inputValue: 'Y',
	    			uncheckedValue: 'N',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('CREDIT_YN', newValue);
						}
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
		          		var labelText = invalid.items[0]['fieldLabel']+':';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
	});		// end of var panelSearch = Unilite.createSearchPanel('bid200skrvpanelSearch',{		// 메인
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('map060skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		excelTitle: '매입처별 매입잔액현황',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
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
        	{dataIndex: 'COMP_CODE'				, width: 60,hidden:true},
		    {dataIndex: 'DIV_CODE'				, width: 90,hidden:true},
		    {dataIndex: 'CUSTOM_CODE'			, width: 100},
		    {dataIndex: 'CUSTOM_NAME'			, width: 160,
		    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            	}},
		    {dataIndex: 'COLLECT_DAY'			, width: 80, align:'center'},
		    {dataIndex: 'RECEIPT_DAY'			, width: 90, align:'center'},
		    {dataIndex: 'BILL_TYPE'				, width: 80, align:'center'},
		    {dataIndex: 'IWAL_IN_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'IN_CR_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'IN_DR_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'IN_JAN_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'END_STOCK_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'TODAY_IN_AMT_I'		, width: 120,summaryType: 'sum'},
		    {dataIndex: 'TODAY_STOCK_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'REMARK'				, width: 200}
		    
		    
		] 
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
			masterForm  	
		],
		id: 'map060skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('detail',false);
			//UniAppManager.setToolbarButtons('reset',false);
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('FR_DATE', UniDate.get('today'));
			masterForm.setValue('TO_DATE', UniDate.get('today'));
			panelResult.setValue('FR_DATE', UniDate.get('today'));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown: function() {
			if(masterForm.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			masterForm.reset();
			panelResult.reset();
			masterGrid.reset();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return masterForm.setAllFieldsReadOnly(true);
        },
        onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
	         
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/map/map060rkrPrint.do',
	            prgID: 'map060rkr',
	               extParam: {	
					  DIV_CODE			: param.DIV_CODE,		
					  FR_DATE			: param.FR_DATE,
					  TO_DATE			: param.TO_DATE,
					  COLLECT_DAY		: param.COLLECT_DAY,
					  CUSTOM_CODE		: param.CUSTOM_CODE,
					  CUSTOM_NAME		: param.CUSTOM_NAME,
					  AGENT_TYPE		: param.AGENT_TYPE,
					  RECEIPT_DAY		: param.RECEIPT_DAY,
					  CREDIT_YN			: param.CREDIT_YN
					  
	               }
	            });
	            win.center();
	            win.show();
	               
	      }
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});
	
};


</script>
