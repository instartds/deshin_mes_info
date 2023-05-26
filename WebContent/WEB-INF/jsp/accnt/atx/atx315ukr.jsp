<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx315ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {     
	var SAVE_FLAG = '';
	var resetButtonFlag = '';

	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}

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
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode	: 'BILL',
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						panelResult.setValue('BILL_DIV_CODE', newValue);
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
							"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
						};
						atx315ukrService.dataCheck(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								if(confirm('기존자료가 존재합니다. 재참조하는 경우 기존자료는 삭제됩니다. 재참조하시겠습니까?')) {
									sumTable.mask('loading...');
									panelSearch.setValue('RE_REFERENCE','Y');
									var param= panelSearch.getValues();
									param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
									param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
									sumTable.getForm().load({
										params: param,
										success: function(form, action) {
											sumTable.unmask();
											SAVE_FLAG = 'U';
//										UniAppManager.setToolbarButtons('delete',true);	
											
											panelSearch.setValue('RE_REFERENCE','');
											UniAppManager.setToolbarButtons('delete',false);	
											sumTable.getField('CREDIT_TAX_AMT').focus();
											UniAppManager.setToolbarButtons('save',true);	
										},
										failure: function(form, action) {
											sumTable.unmask();
											panelSearch.setValue('RE_REFERENCE','');
										}
									});
									tableView.getForm().load({
										params: param,
										success: function(form, action) {
											tableView.unmask();
											SAVE_FLAG = 'U';
//										UniAppManager.setToolbarButtons('delete',true);	
											
											panelSearch.setValue('RE_REFERENCE','');
											UniAppManager.setToolbarButtons('delete',false);	
											UniAppManager.setToolbarButtons('save',true);	
//											sumTable.getField('CREDIT_TAX_AMT').focus();
										},
										failure: function(form, action) {
											tableView.unmask();
											panelSearch.setValue('RE_REFERENCE','');
										}
									});
									panelResult.setAllFieldsReadOnly(true);
									
								}else{
				    				return false;
				    			}
		    				}else{
		    					sumTable.mask('loading...');
								panelSearch.setValue('RE_REFERENCE','Y');
								var param= panelSearch.getValues();
								param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
								param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
								sumTable.getForm().load({
									params: param,
									success: function(form, action) {
										SAVE_FLAG = action.result.data.SAVE_FLAG;
										sumTable.unmask();
										
										panelSearch.setValue('RE_REFERENCE','');
										UniAppManager.setToolbarButtons('delete',false);	
										sumTable.getField('CREDIT_TAX_AMT').focus();
										UniAppManager.setToolbarButtons('save',true);	
									},
									failure: function(form, action) {
										sumTable.unmask();
										panelSearch.setValue('RE_REFERENCE','');
									}
								});
								tableView.getForm().load({
									params: param,
									success: function(form, action) {
										tableView.unmask();
										SAVE_FLAG = action.result.data.SAVE_FLAG;
										
										panelSearch.setValue('RE_REFERENCE','');
										UniAppManager.setToolbarButtons('delete',false);	
										UniAppManager.setToolbarButtons('save',true);	
//										sumTable.getField('CREDIT_TAX_AMT').focus();
									},
									failure: function(form, action) {
										tableView.unmask();
										panelSearch.setValue('RE_REFERENCE','');
									}
								});
								panelResult.setAllFieldsReadOnly(true);
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
					var param = panelSearch.getValues();
					var reFerence='N';
					if(panelSearch.getValue('RE_REFERENCE')){
						reFerence = panelSearch.getValue('RE_REFERENCE')
					}
					var param = {
							"FR_PUB_DATE": panelSearch.getField('FR_PUB_DATE').getStartDate(),
							"TO_PUB_DATE": panelSearch.getField('TO_PUB_DATE').getEndDate(),
							"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE'),
							"RE_REFERENCE":reFerence
						};
					
//					var win = Ext.create('widget.PDFPrintWindow', {
//						url: CPATH+'/atx/atx315rkrPrint.do',
//						prgID: 'atx315rkr',
//						extParam: param
//						});
						
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/accnt/atx315clukr.do',
						prgID: 'atx315ukr',
						extParam: param
					});
				
					win.center();
					win.show();  
				}
	    	},{
	    		xtype:'uniTextfield',
	    		name:'RE_REFERENCE',
	    		text:'재참조버튼클릭관련',
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
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4,
			tableAttrs: { width: '100%'},
			tdAttrs: { align : 'left'}
		},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
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
			name: 'BILL_DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode	: 'BILL',
			holdable: 'hold',
			allowBlank: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				}
			}
		},{
    		xtype: 'button',
    		text: '재참조',
    		width: 100,
    		margin: '0 0 0 0',
    		tableAttrs: {width: '100%'},
			tdAttrs: {align : 'right'},
    		handler : function() {
				if(!UniAppManager.app.checkForNewDetail()){
					return false;
				}else{
					var param = {"FR_PUB_DATE": panelSearch.getField('FR_PUB_DATE').getStartDate(),
						"TO_PUB_DATE": panelSearch.getField('TO_PUB_DATE').getEndDate(),
						"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE')
					};
					atx315ukrService.dataCheck(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
							if(confirm('기존자료가 존재합니다. 재참조하는 경우 기존자료는 삭제됩니다. 재참조하시겠습니까?')) {
								sumTable.mask('loading...');
								panelSearch.setValue('RE_REFERENCE','Y');
								var param= panelSearch.getValues();
								param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
								param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
								sumTable.getForm().load({
									params: param,
									success: function(form, action) {
										sumTable.unmask();
										SAVE_FLAG = 'U';
//										UniAppManager.setToolbarButtons('delete',true);	
										
										panelSearch.setValue('RE_REFERENCE','');
										UniAppManager.setToolbarButtons('delete',false);	
										sumTable.getField('CREDIT_TAX_AMT').focus();
										UniAppManager.setToolbarButtons('save',true);
									},
									failure: function(form, action) {
										sumTable.unmask();
										panelSearch.setValue('RE_REFERENCE','');
									}
								});
								tableView.getForm().load({
									params: param,
									success: function(form, action) {
										tableView.unmask();
										SAVE_FLAG = 'U';
//										UniAppManager.setToolbarButtons('delete',true);	
										
										panelSearch.setValue('RE_REFERENCE','');
										UniAppManager.setToolbarButtons('delete',false);	
										UniAppManager.setToolbarButtons('save',true);
//											sumTable.getField('CREDIT_TAX_AMT').focus();
									},
									failure: function(form, action) {
										tableView.unmask();
										panelSearch.setValue('RE_REFERENCE','');
									}
								});
								panelResult.setAllFieldsReadOnly(true);
								
							}else{
			    				return false;
			    			}
	    				}else{
	    					sumTable.mask('loading...');
							panelSearch.setValue('RE_REFERENCE','Y');
							var param= panelSearch.getValues();
							param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
							param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
							sumTable.getForm().load({
								params: param,
								success: function(form, action) {
									sumTable.unmask();
									SAVE_FLAG = action.result.data.SAVE_FLAG;
									
									panelSearch.setValue('RE_REFERENCE','');
									UniAppManager.setToolbarButtons('delete',false);	
									sumTable.getField('CREDIT_TAX_AMT').focus();
									UniAppManager.setToolbarButtons('save',true);	
								},
								failure: function(form, action) {
									sumTable.unmask();
									panelSearch.setValue('RE_REFERENCE','');
								}
							});
							tableView.getForm().load({
								params: param,
								success: function(form, action) {
									tableView.unmask();
									SAVE_FLAG = action.result.data.SAVE_FLAG;
									
									panelSearch.setValue('RE_REFERENCE','');
									UniAppManager.setToolbarButtons('delete',false);	
//									sumTable.getField('CREDIT_TAX_AMT').focus();
									UniAppManager.setToolbarButtons('save',true);	
								},
								failure: function(form, action) {
									tableView.unmask();
									panelSearch.setValue('RE_REFERENCE','');
								}
							});
							panelResult.setAllFieldsReadOnly(true);
	    				}
					});
				}
			}
    	},{
    		xtype: 'button',
    		text: '출력',
    		width: 100,
    		margin: '0 0 0 0',
    		tableAttrs: {width: '100%'},
			tdAttrs: {align : 'left'},
    		handler : function() {
				var me = this;
				panelSearch.getEl().mask('로딩중...','loading-indicator');
				var reFerence='N';
				if(panelSearch.getValue('RE_REFERENCE')){
					reFerence = panelSearch.getValue('RE_REFERENCE')
				}
				var param = {
						"FR_PUB_DATE": panelSearch.getField('FR_PUB_DATE').getStartDate(),
						"TO_PUB_DATE": panelSearch.getField('TO_PUB_DATE').getEndDate(),
						"BILL_DIV_CODE": panelSearch.getValue('BILL_DIV_CODE'),
						"RE_REFERENCE":reFerence
					};
				
//				var win = Ext.create('widget.PDFPrintWindow', {
//					url: CPATH+'/atx/atx315rkrPrint.do',
//					prgID: 'atx315rkr',
//					extParam: param
//					});
					
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/accnt/atx315clukr.do',
						prgID: 'atx315ukr',
						extParam: param
					});	
					
				win.center();
				win.show();  
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

	var sumTable = Unilite.createForm('detailForm', { //createForm
		padding:'0 0 0 0',
	    title:'2. 신용카드매출전표 발행금액 현황',
		disabled: false,
		flex: 1,
		bodyPadding: 10,
		region: 'center',
	    layout: {type: 'uniTable', columns: 5, 
			tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		defaults:{width: 140},
	    items: [
    		{xtype: 'component', 	html:'구 분',					height: 20},
	    	{xtype: 'component', 	html:'⑤ 합 계',				height: 20},
	    	{xtype: 'component', 	html:'⑥ 신용 · 직불 · 기명식 선불카드',	height: 20,	width: 180},
	    	{xtype: 'component', 	html:'⑦ 현금영수증',				height: 20},
	    	{xtype: 'component', 	html:'⑧ 직불ㆍ기명식 선불전자지급수단',	height: 20,	width: 200},
	         
			{xtype: 'component', 	html:'합 계'},
	    	{id:'ALL_AMT_TOT',		name:'ALL_AMT_TOT',		xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{id:'CREDIT_AMT_TOT',	name:'CREDIT_AMT_TOT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{id:'CASH_AMT_TOT',		name:'CASH_AMT_TOT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{id:'EPAY_AMT_TOT',		name:'EPAY_AMT_TOT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	         
			{xtype: 'component', 	html:'과세 매출분'},
	    	{id:'TAX_AMT_TOT',		name:'TAX_AMT_TOT',		xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{id:'CREDIT_TAX_AMT',	name:'CREDIT_TAX_AMT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{id:'CASH_TAX_AMT',		name:'CASH_TAX_AMT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{id:'EPAY_TAX_AMT',		name:'EPAY_TAX_AMT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	         
			{xtype: 'component',	html:'면세 매출분'},
	    	{id:'FREE_AMT_TOT',		name:'FREE_AMT_TOT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{id:'CREDIT_FREE_AMT',	name:'CREDIT_FREE_AMT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{id:'CASH_FREE_AMT',	name:'CASH_FREE_AMT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{id:'EPAY_FREE_AMT',	name:'EPAY_FREE_AMT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	         
			{xtype: 'component',	html:'봉 사 료'},
	    	{id:'SERV_AMT_TOT',		name:'SERV_AMT_TOT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{id:'CREDIT_SERV_AMT',	name:'CREDIT_SERV_AMT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{id:'CASH_SERV_AMT',	name:'CASH_SERV_AMT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{id:'EPAY_SERV_AMT',	name:'EPAY_SERV_AMT',	xtype: 'uniNumberfield',	value:0,	readOnly:true}
		],
		api: {
	 		load: 'atx315ukrService.selectSumTable'	,
	 		submit: 'atx315ukrService.syncMaster'	
		}
	});
	
	var tableView = Unilite.createForm('detailForm2', { //createForm
		padding:'0 0 0 0',
	    title:'3. 신용카드매출전표 등 발행금(⑤합계) 중 세금계산서(계산서) 교부내역',
		disabled: false,
		flex: 1.5,
		bodyPadding: 10,
		region: 'south',
	    layout: {type: 'uniTable', columns: 4, 
			tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		defaults:{width: 140},
	    items: [
    		{xtype: 'component',	html:'⑨ 세금계산서 교부금액'},
	    	{id:'TAX_BILL_AMT',		name:'TAX_BILL_AMT',	xtype: 'uniNumberfield',	value:0,	readOnly:true},
	    	{xtype: 'component',	html:'⑩ 계산서 교부금액'},
	    	{id:'BILL_AMT',			name:'BILL_AMT',		xtype: 'uniNumberfield',	value:0,	readOnly:true}
		],
		api: {
	 		load: 'atx315ukrService.selectSumTable'
//	 		submit: 'atx315ukrService.syncMaster'	
		}
	});
    
   Unilite.Main( {		
		borderItems:[{
			region:'center',
			layout: 'border',
			items:[
				sumTable,tableView,panelResult
			]	
		},
			panelSearch
		],
		id  : 'atx315ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['newData','reset'],false);
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
				sumTable.mask('loading...');
				tableView.mask('loading...');
				var param= panelSearch.getValues();
				param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();//panelSearch.getValue('FR_PUB_DATE');
				param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();//panelSearch.getValue('TO_PUB_DATE');
				
				sumTable.getForm().load({
					params: param,
					success: function(form, action) {
						sumTable.unmask();
						UniAppManager.app.readOnlyBool(false);
						UniAppManager.setToolbarButtons('delete',true);
						SAVE_FLAG = action.result.data.SAVE_FLAG;
						if(SAVE_FLAG == 'U' || SAVE_FLAG == 'N'){
							UniAppManager.setToolbarButtons('save',true);	
						}
					},
					failure: function(form, action) {
						SAVE_FLAG = action.result.data.SAVE_FLAG;
						UniAppManager.app.readOnlyBool(false);
						sumTable.unmask();
					}
				});
				tableView.getForm().load({
					params: param,
					success: function(form, action) {
						tableView.unmask();
						UniAppManager.app.readOnlyBool(false);
						UniAppManager.setToolbarButtons('delete',true);
						SAVE_FLAG = action.result.data.SAVE_FLAG;
						if(SAVE_FLAG == 'U' || SAVE_FLAG == 'N'){
							UniAppManager.setToolbarButtons('save',true);	
						}
					},
					failure: function(form, action) {
						SAVE_FLAG = action.result.data.SAVE_FLAG;
						UniAppManager.app.readOnlyBool(false);
						tableView.unmask();
					}
				});
				UniAppManager.setToolbarButtons('reset',true);
				panelResult.setAllFieldsReadOnly(true);
			}
			
				
		},
		onResetButtonDown: function() {
			resetButtonFlag = 'Y';
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
//			panelSearch.clearForm();
//			panelResult.clearForm();
			sumTable.clearForm();
			tableView.clearForm();
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('delete',false);
			UniAppManager.app.readOnlyBool(true);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			var param = sumTable.getValues();
			param.SAVE_FLAG = SAVE_FLAG;
			param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			param.BILL_DIV_CODE = panelSearch.getValue('BILL_DIV_CODE');
			
			param.TAX_BILL_AMT = tableView.getValue('TAX_BILL_AMT');
			param.BILL_AMT = tableView.getValue('BILL_AMT');
				
			sumTable.getForm().submit({
			params : param,
				success : function(form, action) {
	 				sumTable.getForm().wasDirty = false;
					sumTable.resetDirtyStatus();											
					UniAppManager.setToolbarButtons('save', false);	
	            	UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
	            	if(SAVE_FLAG == 'D') {
	            		SAVE_FLAG = '';
	            	}else {
	            		UniAppManager.app.onQueryButtonDown();
	            	}
				}	
			});
			/*var param= sumTable.getValues();
			param.FR_PUB_DATE = UniDate.getDbDateStr(panelSearch.getValue("FR_PUB_DATE"));
			param.TO_PUB_DATE = UniDate.getDbDateStr(panelSearch.getValue("TO_PUB_DATE"));
			param.BILL_DIV_CODE = panelSearch.getValue("BILL_DIV_CODE");
			
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
		onDeleteDataButtonDown: function() {
			if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
				sumTable.clearForm();
				tableView.clearForm();
			 	UniAppManager.app.setAllSumTableDefaultValue();
				UniAppManager.setToolbarButtons('delete',false);
				UniAppManager.setToolbarButtons('save',true);
				SAVE_FLAG = 'D';
			}
		},
		setDefault: function() {
			if(resetButtonFlag != 'Y'){
	        	panelSearch.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
	        	panelSearch.setValue('TO_PUB_DATE',UniDate.get('endOfMonth'));
	        	panelResult.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
	        	panelResult.setValue('TO_PUB_DATE',UniDate.get('endOfMonth'));

				panelSearch.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
				panelResult.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
			} 	
        	
        	sumTable.setValue('ALL_AMT_TOT',0);
        	sumTable.setValue('CREDIT_AMT_TOT',0);
        	sumTable.setValue('CASH_AMT_TOT',0);
        	sumTable.setValue('EPAY_AMT_TOT',0);
        	sumTable.setValue('TAX_AMT_TOT',0);
        	sumTable.setValue('CREDIT_TAX_AMT',0);
        	sumTable.setValue('CASH_TAX_AMT',0);
        	sumTable.setValue('EPAY_TAX_AMT',0);
        	sumTable.setValue('FREE_AMT_TOT',0);
        	sumTable.setValue('CREDIT_FREE_AMT',0);
        	sumTable.setValue('CASH_FREE_AMT',0);
        	sumTable.setValue('EPAY_FREE_AMT',0);
        	sumTable.setValue('SERV_AMT_TOT',0);
        	sumTable.setValue('CREDIT_SERV_AMT',0);
        	sumTable.setValue('CASH_SERV_AMT',0);
        	sumTable.setValue('EPAY_SERV_AMT',0);
        	tableView.setValue('TAX_BILL_AMT', 0);
        	tableView.setValue('BILL_AMT', 0);
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        setAllSumTableDefaultValue:function(){
        	sumTable.setValue('ALL_AMT_TOT',0);
        	sumTable.setValue('CREDIT_AMT_TOT',0);
        	sumTable.setValue('CASH_AMT_TOT',0);
        	sumTable.setValue('EPAY_AMT_TOT',0);
        	sumTable.setValue('TAX_AMT_TOT',0);
        	sumTable.setValue('CREDIT_TAX_AMT',0);
        	sumTable.setValue('CASH_TAX_AMT',0);
        	sumTable.setValue('EPAY_TAX_AMT',0);
        	sumTable.setValue('FREE_AMT_TOT',0);
        	sumTable.setValue('CREDIT_FREE_AMT',0);
        	sumTable.setValue('CASH_FREE_AMT',0);
        	sumTable.setValue('EPAY_FREE_AMT',0);
        	sumTable.setValue('SERV_AMT_TOT',0);
        	sumTable.setValue('CREDIT_SERV_AMT',0);
        	sumTable.setValue('CASH_SERV_AMT',0);
        	sumTable.setValue('EPAY_SERV_AMT',0);
        	tableView.setValue('TAX_BILL_AMT', 0);
        	tableView.setValue('BILL_AMT', 0);
        	
        },
        setSumTableSumValue:function() {
			sumTable.setValue('CREDIT_AMT_TOT',   sumTable.getValue('CREDIT_TAX_AMT')
												+ sumTable.getValue('CREDIT_FREE_AMT')
												+ sumTable.getValue('CREDIT_SERV_AMT'));
			sumTable.setValue('CASH_AMT_TOT', 	  sumTable.getValue('CASH_TAX_AMT')
												+ sumTable.getValue('CASH_FREE_AMT')
												+ sumTable.getValue('CASH_SERV_AMT'));
			sumTable.setValue('EPAY_AMT_TOT', 	  sumTable.getValue('EPAY_TAX_AMT')
												+ sumTable.getValue('EPAY_FREE_AMT')
												+ sumTable.getValue('EPAY_SERV_AMT'));
				
        	sumTable.setValue('TAX_AMT_TOT', 	  sumTable.getValue('CREDIT_TAX_AMT')
												+ sumTable.getValue('CASH_TAX_AMT')
												+ sumTable.getValue('EPAY_TAX_AMT'));
			sumTable.setValue('FREE_AMT_TOT', 	  sumTable.getValue('CREDIT_FREE_AMT')
												+ sumTable.getValue('CASH_FREE_AMT')
												+ sumTable.getValue('EPAY_FREE_AMT'));
        	sumTable.setValue('SERV_AMT_TOT', 	  sumTable.getValue('CREDIT_SERV_AMT')
												+ sumTable.getValue('CASH_SERV_AMT')
												+ sumTable.getValue('EPAY_SERV_AMT'));
				
			sumTable.setValue('ALL_AMT_TOT', 	  sumTable.getValue('CREDIT_TAX_AMT')	+ sumTable.getValue('CASH_TAX_AMT')		+ sumTable.getValue('EPAY_TAX_AMT')
												+ sumTable.getValue('CREDIT_FREE_AMT')	+ sumTable.getValue('CASH_FREE_AMT')	+ sumTable.getValue('EPAY_FREE_AMT')
												+ sumTable.getValue('CREDIT_SERV_AMT')	+ sumTable.getValue('CASH_SERV_AMT')	+ sumTable.getValue('EPAY_SERV_AMT'));	
        },
        readOnlyBool:function(boolean){
			if(boolean == true){
				Ext.getCmp('ALL_AMT_TOT').setReadOnly(true);
				
				Ext.getCmp('CREDIT_AMT_TOT').setReadOnly(true);
				Ext.getCmp('CASH_AMT_TOT').setReadOnly(true);
				Ext.getCmp('EPAY_AMT_TOT').setReadOnly(true);
				
				Ext.getCmp('TAX_AMT_TOT').setReadOnly(true);
				Ext.getCmp('FREE_AMT_TOT').setReadOnly(true);
				Ext.getCmp('SERV_AMT_TOT').setReadOnly(true);
				
				Ext.getCmp('CREDIT_TAX_AMT').setReadOnly(true);
				Ext.getCmp('CASH_TAX_AMT').setReadOnly(true);
				Ext.getCmp('EPAY_TAX_AMT').setReadOnly(true);
				
				Ext.getCmp('CREDIT_FREE_AMT').setReadOnly(true);
				Ext.getCmp('CASH_FREE_AMT').setReadOnly(true);
				Ext.getCmp('EPAY_FREE_AMT').setReadOnly(true);
				
				Ext.getCmp('CREDIT_SERV_AMT').setReadOnly(true);
				Ext.getCmp('CASH_SERV_AMT').setReadOnly(true);
				Ext.getCmp('EPAY_SERV_AMT').setReadOnly(true);
				
				Ext.getCmp('TAX_BILL_AMT').setReadOnly(true);
				Ext.getCmp('BILL_AMT').setReadOnly(true);
				
			}else{
				Ext.getCmp('ALL_AMT_TOT').setReadOnly(true);
				
				Ext.getCmp('CREDIT_AMT_TOT').setReadOnly(true);
				Ext.getCmp('CASH_AMT_TOT').setReadOnly(true);
				Ext.getCmp('EPAY_AMT_TOT').setReadOnly(true);
				
				Ext.getCmp('TAX_AMT_TOT').setReadOnly(true);
				Ext.getCmp('FREE_AMT_TOT').setReadOnly(true);
				Ext.getCmp('SERV_AMT_TOT').setReadOnly(true);
				
				Ext.getCmp('CREDIT_TAX_AMT').setReadOnly(false);
				Ext.getCmp('CASH_TAX_AMT').setReadOnly(false);
				Ext.getCmp('EPAY_TAX_AMT').setReadOnly(false);
				
				Ext.getCmp('CREDIT_FREE_AMT').setReadOnly(false);
				Ext.getCmp('CASH_FREE_AMT').setReadOnly(false);
				Ext.getCmp('EPAY_FREE_AMT').setReadOnly(false);
				
				Ext.getCmp('CREDIT_SERV_AMT').setReadOnly(false);
				Ext.getCmp('CASH_SERV_AMT').setReadOnly(false);
				Ext.getCmp('EPAY_SERV_AMT').setReadOnly(false);
				
				Ext.getCmp('TAX_BILL_AMT').setReadOnly(false);
				Ext.getCmp('BILL_AMT').setReadOnly(false);
			}
		}
	});
	Unilite.createValidator('validator01', {
		forms: {'formA:':sumTable,
				'formB:':tableView
		},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case fieldName:
					UniAppManager.app.setSumTableSumValue();
					UniAppManager.setToolbarButtons('save',true);
					break;
			}
			return rv;
		}
	});
};


</script>
