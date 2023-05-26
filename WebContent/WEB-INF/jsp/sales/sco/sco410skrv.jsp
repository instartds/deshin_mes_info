<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sco410skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="sco410skrv"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B034" /> <!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> <!-- 계산서 -->
	
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

	
	Unilite.defineModel('Sco410skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'			, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		, type: 'string'},
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'		, type: 'string'},
	    	{name: 'AC_DATE'			, text: '<t:message code="system.label.sales.businessdate" default="거래일"/>'		, type: 'uniDate'},
	    	{name: 'SLIP_NUM'			, text: '<t:message code="system.label.sales.number" default="번호"/>'		, type: 'string'},
	    	{name: 'SLIP_SEQ'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'		, type: 'string'},
	    	{name: 'REMARK'				, text: '<t:message code="system.label.sales.remark" default="적요"/>'		, type: 'string'},
	    	{name: 'DR_AMT_I'			, text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'		, type: 'uniPrice'},
	    	{name: 'CR_AMT_I'			, text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'		, type: 'uniPrice'},
	    	{name: 'JAN_AMT_I'			, text: '<t:message code="system.label.sales.balanceamount2" default="잔액"/>'		, type: 'uniPrice'},
	    	{name: 'A'					, text: '<t:message code="system.label.sales.remarks" default="비고"/>'		, type: 'string'}
	    	
	    ]
	});//End of Unilite.defineModel('Sco410skrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sco410skrvMasterStore1', {
		model: 'Sco410skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'sco410skrvService.selectList'                	
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
           		if(count > 0){
	           		UniAppManager.setToolbarButtons(['print'], true);
	           	}
           	}
		}
		//groupField: 'CUSTOM_NAME'
			
	});
	
	var states = Ext.create('Ext.data.Store', {
    fields: ['value', 'name'],
	    data : [
	        {"value":"108", "name":"외상매출금"},
	        {"value":"259", "name":"선수금"}
		]
	});
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>', 
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
				fieldLabel: '<t:message code="system.label.sales.resultsdate" default="실적일"/>',
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
			},
			Unilite.popup('AGENT_CUST', { 
					fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					allowBlank: false,
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
				fieldLabel: '<t:message code="system.label.sales.classfication" default="구분"/>', 
				name: 'ACCNT',
				xtype: 'uniCombobox',
				store: states,
				displayField: 'name',
				valueField: 'value',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACCNT', newValue);
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
	
					   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>', 
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
				fieldLabel: '<t:message code="system.label.sales.resultsdate" default="실적일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(masterForm) {
						masterForm.setValue('FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(masterForm) {
			    		masterForm.setValue('TO_DATE',newValue);
			    	}
			    }
			},
			Unilite.popup('AGENT_CUST', { 
					fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					allowBlank: false,
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
				fieldLabel: '<t:message code="system.label.sales.classfication" default="구분"/>', 
				name: 'ACCNT',
				xtype: 'uniCombobox',
				store: states,
				displayField: 'name',
				valueField: 'value',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ACCNT', newValue);
					}
				}
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
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
		        	}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('sco410skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		
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
    	store: directMasterStore1,
        columns: [
        	{dataIndex: 'COMP_CODE'					, width: 80,hidden:true},
        	{dataIndex: 'DIV_CODE'					, width: 80,hidden:true},
        	{dataIndex: 'AC_DATE'					, width: 80},
//        	{dataIndex: 'SLIP_NUM'					, width: 60, align: 'center'},
//        	{dataIndex: 'SLIP_SEQ'					, width: 60, align: 'center'},
        	{dataIndex: 'REMARK'					, width: 400},
        	{dataIndex: 'DR_AMT_I'					, width: 120,summaryType: 'sum'},
        	{dataIndex: 'CR_AMT_I'					, width: 120,summaryType: 'sum'},
        	{dataIndex: 'JAN_AMT_I'					, width: 120,summaryType: 'sum'},
        	{dataIndex: 'A'							, width: 200, hidden:true}
		] 
    });
	
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
		id: 'sco410skrvApp',
		fnInitBinding: function(params) {
			
			UniAppManager.setToolbarButtons('save',false);
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('FR_DATE',UniDate.get('today'));
			panelResult.setValue('FR_DATE',UniDate.get('today'));
			masterForm.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			masterForm.setValue('ACCNT','108');
			panelResult.setValue('ACCNT','108');
			UniAppManager.app.processParams(params);
			if(params && params.CUSTOM_CODE){
				masterGrid.getStore().loadStoreRecords();	
			}
			
			UniAppManager.setToolbarButtons('reset',true);
		},
		
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			
				directMasterStore1.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			UniAppManager.setToolbarButtons(['print'], false);
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
	
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/sco/sco410rkrPrint.do',
	            prgID: 'sco410rkr',
	               extParam: {
	               	  
	                  DIV_CODE  	: param.DIV_CODE,
	                  FR_DATE		: param.FR_DATE,
	                  TO_DATE		: param.TO_DATE,
	                  CUSTOM_CODE	: param.CUSTOM_CODE,
	                  CUSTOM_NAME	: param.CUSTOM_NAME,
	                  ACCNT   		: param.ACCNT
	               }
	            });
	            win.center();
	            win.show();
	    },
		checkForNewDetail:function() { 			
			return masterForm.setAllFieldsReadOnly(true);
        },
        processParams: function(params) {
			this.uniOpt.appParams = params;		
			if(params) {
				if(params.action == 'new') {
					masterForm.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					masterForm.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					panelResult.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					panelResult.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					masterForm.setValue('DIV_CODE', params.DIV_CODE);
					panelResult.setValue('DIV_CODE', params.DIV_CODE);
					masterForm.setValue('FR_DATE', params.FR_DATE);
					panelResult.setValue('FR_DATE', params.FR_DATE);
					masterForm.setValue('TO_DATE', params.TO_DATE);
					panelResult.setValue('TO_DATE', params.TO_DATE);
				}
			}
		}
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});
	
};


</script>
