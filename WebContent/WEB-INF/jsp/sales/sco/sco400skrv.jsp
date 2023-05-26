<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sco400skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="sco400skrv"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B034" /> <!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP35" /> <!-- 지불일 -->
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

	
	Unilite.defineModel('Sco400skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'			, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		, type: 'string'},
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'		, type: 'string',comboType:'BOR120'},
	    	{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.salesplacename" default="매출처명"/>'		, type: 'string'},
	    	{name: 'COLLECT_DAY'		, text: '<t:message code="system.label.sales.paydate" default="지불일"/>'		, type: 'string',comboType:'AU', comboCode:'YP35'},
	    	{name: 'RECEIPT_DAY'		, text: '<t:message code="system.label.sales.paycondition" default="결제조건"/>'		, type: 'string',comboType:'AU', comboCode:'B034'},
	    	{name: 'BILL_TYPE'			, text: '<t:message code="system.label.sales.bill" default="계산서"/>'		, type: 'string',comboType:'AU', comboCode:'YP36'},	
	    	{name: 'IWAL_OUT_AMT_I'		, text: '<t:message code="system.label.sales.overbalance" default="이월잔액"/>'		, type: 'uniPrice'},	
	    	{name: 'OUTPUT_DR_AMT_I'	, text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'		, type: 'uniPrice'},  	 	
	    	{name: 'OUTPUT_CR_AMT_I'	, text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'		, type: 'uniPrice'},
	    	{name: 'OUT_JAN_AMT_I'		, text: '<t:message code="system.label.sales.lastbalance" default="기말잔액"/>'		, type: 'uniPrice'},
	    	{name: 'TODAY_OUT_AMT_I'	, text: '<t:message code="system.label.sales.currentbalance" default="현재잔액"/>'		, type: 'uniPrice'}
	    ]
	});//End of Unilite.defineModel('Sco400skrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sco400skrvMasterStore1', {
		model: 'Sco400skrvModel',
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
				read: 'sco400skrvService.selectList'                	
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
			
	});//End of var directMasterStore1 = Unilite.createStore('map060skrvMasterStore1', {
	
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
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
                	}
                	if(Ext.isDate(newValue)){
                		if(newValue <= UniDate.add(UniDate.extParseDate('20150731'))){
                			Unilite.messageBox('2015년 8월 이전 데이터는 조회 할 수 없습니다.');
                			masterForm.setValue('FR_DATE',UniDate.get('startOfMonth'));
                			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
                		}
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}   	
			    	if(Ext.isDate(newValue)){
                		if(newValue <= UniDate.add(UniDate.extParseDate('20150731'))){
                			Unilite.messageBox('2015년 8월 이전 데이터는 조회 할 수 없습니다.');
                			masterForm.setValue('TO_DATE',UniDate.get('today'));
                			panelResult.setValue('TO_DATE',UniDate.get('today'));
                		}
                	}
			    } 
			},{
				fieldLabel: '<t:message code="system.label.sales.paydate" default="지불일"/>',
				name: 'COLLECT_DAY',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COLLECT_DAY', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', { 
					fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>', 
					valueFieldName: 'CUSTOM_CODE_FR',
			   	 	textFieldName: 'CUSTOM_NAME_FR',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE_FR', masterForm.getValue('CUSTOM_CODE_FR'));
								panelResult.setValue('CUSTOM_NAME_FR', masterForm.getValue('CUSTOM_NAME_FR'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE_FR', '');
								panelResult.setValue('CUSTOM_NAME_FR', '');
						}
					}
			}),
			Unilite.popup('AGENT_CUST', { 
					fieldLabel: '~', 
					valueFieldName: 'CUSTOM_CODE_TO',
			   	 	textFieldName: 'CUSTOM_NAME_TO',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE_TO', masterForm.getValue('CUSTOM_CODE_TO'));
								panelResult.setValue('CUSTOM_NAME_TO', masterForm.getValue('CUSTOM_NAME_TO'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE_TO', '');
								panelResult.setValue('CUSTOM_NAME_TO', '');
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>', 
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
				fieldLabel: '<t:message code="system.label.sales.paycondition" default="결제조건"/>', 
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
	    		items: [{
	    			boxLabel: '<t:message code="system.label.sales.resultssalesplaceyn" default="실적발생 매출처여부"/>',
	    			width: 130,
	    			name: 'CREDIT_YN',
	    			inputValue: 'Y',
	    			uncheckedValue: 'N',
	    			checked: true,
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
		layout : {type : 'uniTable', columns : 3},
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
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						masterForm.setValue('FR_DATE',newValue);
                	}
                //	var uniDate = UniDate.get('20150731')
           	
                	if(Ext.isDate(newValue)){
                		if(newValue <= UniDate.add(UniDate.extParseDate('20150731'))){
                			Unilite.messageBox('2015년 8월 이전 데이터는 조회 할 수 없습니다.');
                			masterForm.setValue('FR_DATE',UniDate.get('startOfMonth'));
                			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
                		}
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		masterForm.setValue('TO_DATE',newValue);
			    	}
			    	if(Ext.isDate(newValue)){
                		if(newValue <= UniDate.add(UniDate.extParseDate('20150731'))){
                			Unilite.messageBox('2015년 8월 이전 데이터는 조회 할 수 없습니다.');
                			masterForm.setValue('TO_DATE',UniDate.get('today'));
                			panelResult.setValue('TO_DATE',UniDate.get('today'));
                		}
                	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.sales.paydate" default="지불일"/>',
				name: 'COLLECT_DAY',
				xtype: 'uniTextfield',
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('COLLECT_DAY', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>', 
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
				fieldLabel: '<t:message code="system.label.sales.paycondition" default="결제조건"/>', 
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
	    			boxLabel: '<t:message code="system.label.sales.resultssalesplaceyn" default="실적발생 매출처여부"/>',
	    			width: 130,
	    			name: 'CREDIT_YN',
	    			inputValue: 'Y',
	    			uncheckedValue: 'N',
	    			checked: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('CREDIT_YN', newValue);
						}
					}
	    		}]
	        },
			Unilite.popup('AGENT_CUST', { 
					fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>', 
					valueFieldName: 'CUSTOM_CODE_FR',
			   	 	textFieldName: 'CUSTOM_NAME_FR',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('CUSTOM_CODE_FR', panelResult.getValue('CUSTOM_CODE_FR'));
								masterForm.setValue('CUSTOM_NAME_FR', panelResult.getValue('CUSTOM_NAME_FR'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								masterForm.setValue('CUSTOM_CODE_FR', '');
								masterForm.setValue('CUSTOM_NAME_FR', '');
						}
					}
			}),
			Unilite.popup('AGENT_CUST', { 
					fieldLabel: '~', 
					labelWidth:15,
					valueFieldName: 'CUSTOM_CODE_TO',
			   	 	textFieldName: 'CUSTOM_NAME_TO',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('CUSTOM_CODE_TO', panelResult.getValue('CUSTOM_CODE_TO'));
								masterForm.setValue('CUSTOM_NAME_TO', panelResult.getValue('CUSTOM_NAME_TO'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								masterForm.setValue('CUSTOM_CODE_TO', '');
								masterForm.setValue('CUSTOM_NAME_TO', '');
						}
					}
			})],
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
	});		// end of var panelSearch = Unilite.createSearchPanel('bid200skrvpanelSearch',{		// 메인
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('sco400skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		
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
        	showSummaryRow: false
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
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
		    {dataIndex: 'COLLECT_DAY'			, width: 80},
		    {dataIndex: 'RECEIPT_DAY'			, width: 90},
		    {dataIndex: 'BILL_TYPE'				, width: 90},
		    {dataIndex: 'IWAL_OUT_AMT_I'		, width: 120,summaryType: 'sum'},
		    {dataIndex: 'OUTPUT_DR_AMT_I'		, width: 120,summaryType: 'sum'},
		    {dataIndex: 'OUTPUT_CR_AMT_I'		, width: 120,summaryType: 'sum'},
		    {dataIndex: 'OUT_JAN_AMT_I'			, width: 120,summaryType: 'sum'},
		    {dataIndex: 'TODAY_OUT_AMT_I'		, width: 120,summaryType: 'sum'}
		],
		listeners: {
				onGridDblClick: function(grid, record, cellIndex, colName) {
					var params = {
						action: 'new',
						DIV_CODE : masterForm.getValue('DIV_CODE'),
						FR_DATE : masterForm.getValue('FR_DATE'),
						TO_DATE : masterForm.getValue('TO_DATE'),
						CUSTOM_CODE : record.get('CUSTOM_CODE'),
						CUSTOM_NAME : record.get('CUSTOM_NAME')
						
					}
					var rec = {data : {prgID : 'sco410skrv'}};							
						parent.openTab(rec, '/sales/'+'sco410skrv'+'.do', params);	
				}
			}
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
		id: 'sco400skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('detail',false);
			//UniAppManager.setToolbarButtons('reset',false);
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			masterForm.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			
			masterForm.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			panelResult.setValue('CUSTOM_CODE_FR','');
			panelResult.setValue('CUSTOM_CODE_TO','');
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
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			UniAppManager.setToolbarButtons(['print'], false);
			masterGrid.reset();
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
	
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/sco/sco400rkrPrint.do',
	            prgID: 'sco400rkr',
	               extParam: {
	               	  
	                  DIV_CODE  	: param.DIV_CODE,
	                  FR_DATE		: param.FR_DATE,
	                  TO_DATE		: param.TO_DATE,
	                  CUSTOM_CODE	: param.CUSTOM_CODE,
	                  CUSTOM_NAME	: param.CUSTOM_NAME,
	                  COLLECT_DAY   : param.COLLECT_DAY,
	                  AGENT_TYPE    : param.AGENT_TYPE,
	                  RECEIPT_DAY   : param.RECEIPT_DAY,
	                  CREDIT_YN		: param.CREDIT_YN
	               }
	            });
	            win.center();
	            win.show();
	    },
		checkForNewDetail:function() { 			
			return masterForm.setAllFieldsReadOnly(true);
        }
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});

	/*Unilite.createValidator('validator01', {
		forms: {'formA:':masterForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
		//validate('field', field.name, newValue, lastValidValue, eRec, form, field, null);	
			
			
			
			
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			var frDate = form.getField('FR_DATE').getSubmitValue();  // 실적일자 FR
			var toDate = form.getField('TO_DATE').getSubmitValue();  // 실적일자 TO	

			var beforeFrDate = UniDate.add(UniDate.extParseDate(UniDate.get('startOfMonth')), {days:-1});
			
			
			var beforeToDate = '20150731';
			
			//7월 31일 이전 데이터는 조회 할 수 없습니다.
			
			var rv = true;

			switch(fieldName) {				
				case "FR_DATE" : // 실적일자 FR
					if(beforeFrDate > frDate){
						Unilite.messageBox('현재 월 보다 이전 데이터는 조회 할 수 없습니다.');
						masterForm.setValue('FR_DATE',UniDate.get('startOfMonth'));
						panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
						masterForm.getField('FR_DATE').focus();
						break;
					}
					break;
					
					
				case "TO_DATE" : // 실적일자 TO
					if(beforeToDate < toDate){
						Unilite.messageBox('현재 월 보다 이전 데이터는 조회 할 수 없습니다.');
						masterForm.setValue('TO_DATE',UniDate.get('today'));
						panelResult.setValue('TO_DATE',UniDate.get('today'));
						masterForm.getField('TO_DATE').focus();
						break;
					}
					break;	
			}
			return rv;
		}
	}); // validator
*/
};


</script>
