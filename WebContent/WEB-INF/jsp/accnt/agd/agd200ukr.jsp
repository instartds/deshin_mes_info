<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd200ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A082" /> 	<!-- 부가세유형(수출유형) -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var sumAmtI = 0,
		sumCheckedCount = 0,
		newYN = 0,
		selDesel = 0,
		checkCount = 0;
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'agd200ukrService.runProcedure',
            syncAll	: 'agd200ukrService.callProcedure'
		}
	});	


	
	/* Model 정의 
	 * @type	*/
	Unilite.defineModel('agd200Model', {
	   fields: [
			{name: 'CHOICE'            	, text: '<t:message code="system.label.sales.selection" default="선택"/>'			, type: 'boolean'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.trade.division" default="사업장"/>'			, type: 'string',	comboType: 'BOR120'},
			{name: 'BL_SER_NO'			, text: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>'	, type: 'string'},
			{name: 'SO_SER_NO'			, text: '<t:message code="system.label.trade.somanageno" default="S/O관리번호"/>'	, type: 'string'},
			{name: 'DEPT_NAME'         	, text: '<t:message code="system.label.trade.department" default="부서"/>'			, type: 'string'},
			{name: 'BILL_DIV_CODE'      , text: '<t:message code="system.label.common.salesdivision" default="매출사업장"/>', type: 'string',	comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.common.custom" default="거래처코드"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.common.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'DATE_SHIPPING' 		, text: '<t:message code="system.label.trade.shipmentdate" default="선적일"/>'		, type: 'uniDate'},
			{name: 'BL_NO' 				, text: '<t:message code="system.label.trade.blno" default="B/L번호"/>'				, type: 'string'},
			{name: 'LC_NO'				, text: '<t:message code="system.label.trade.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'PROJECT_NO'		    , text: '<t:message code="system.label.trade.projectno" default="프로젝트번호"/>'	, type: 'string'},
			{name: 'PROJECT_NM'		    , text: '<t:message code="system.label.trade.projectname" default="프로젝트명"/>'	, type: 'string'},
			{name: 'EXCHG_RATE_O'   	, text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'		, type: 'uniER'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.trade.currencyunit" default="화폐단위"/>'	, type: 'string', comboType:'AU', comboCode:'B004'},
			{name: 'FOR_AMT_I'   		, text: '<t:message code="system.label.trade.foreigncurrencyamount" default="외화금액"/>'		, type: 'uniUnitPrice'},
			{name: 'AMT_I'   			, text: '<t:message code="system.label.trade.localamount" default="원화금액"/>'		, type: 'uniPrice'},
			{name: 'EX_DATE'      		, text: '결의일' 				,type: 'uniDate'},
			{name: 'EX_NUM'				, text: '번호' 				,type: 'int'},
			{name: 'REMARK_ITEM'		, text: '<t:message code="system.label.trade.remarkitem" default="주요품목"/>'		, type: 'string'},
			{name: 'RECEIPT_PLAN_DATE'	, text: '<t:message code="system.label.trade.paymentduedate" default="수금예정일"/>', type: 'uniDate'}
	    ]
	});		// End of Ext.define('agd200ukrModel', {

	
	
	/* Store 정의(Service 정의)
	 * @type	*/					
	var MasterStore = Unilite.createStore('agd200MasterStore',{
		model: 'agd200Model',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 	
			deletable	: false,		// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agd200ukrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param = Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		
           		//조회되는 항목 갯수와 매출액 합계 구하기
           		var amtI = 0;
           		sumAmtI = 0;
           		sumCheckedCount = 0;
           		var count = masterGrid.getStore().getCount();  
				Ext.each(records, function(record, i){	
	        		 amtI = record.get('AMT_I') + amtI	
		    	}); 
	    		addResult.setValue('TOT_SELECTED_AMT', amtI);
				addResult.setValue('TOT_COUNT',count); 
				if(addResult.getValues().WORK_DIVI == 1 ){
//       				Ext.getCmp('procCanc').setText('자동기표');
       				Ext.getCmp('procCanc2').setText('<t:message code="system.label.sales.autoslipposting" default="자동기표"/>');
       			}else {
//       				Ext.getCmp('procCanc').setText('기표취소');
       				Ext.getCmp('procCanc2').setText('<t:message code="system.label.sales.slipcancel" default="기표취소"/>');
       			};
           	}
           	
		}
	});

    var buttonStore = Unilite.createStore('agd200ukrButtonStore',{      
        uniOpt: {
            isMaster	: false,			// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
            useNavi		: false				// prev | newxt 버튼 사용
        },
        proxy: directButtonProxy,
        saveStore: function(buttonFlag) {             
            if(!addResult.isValid() || !panelSearch.isValid())	{
            	return;
            }
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

			var paramMaster			= addResult.getValues();
			Ext.apply(paramMaster, panelSearch.getValues());
			paramMaster.OPR_FLAG	= buttonFlag;

            if(inValidRecs.length == 0) {
                config = {
					params	: [paramMaster],
                    success : function(batch, option) {
                        //return 값 저장
                        var master = batch.operations[0].getResultSet();
                        
                        UniAppManager.app.onQueryButtonDown();
                        buttonStore.clearData();
                     },

                     failure: function(batch, option) {
                        buttonStore.clearData();
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('agd200Grid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
    });
	

	var panelSearch = Unilite.createSearchPanel('searchForm', {		
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
			items :[{ 
				fieldLabel: '계산서일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_DATE_SHIPPING',
		        endFieldName: 'TO_DATE_SHIPPING',
		        width: 470,
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),
		        allowBlank: false,
		        onStartDateChange: function(field, newValue, oldValue, eOpts){
		        	if(panelResult)	{
		        		panelResult.setValue('FR_DATE_SHIPPING', newValue);
		        	}
		        },
    			onEndDateChange: function(field, newValue, oldValue, eOpts){
    				if(panelResult)	{
    					panelResult.setValue('TO_DATE_SHIPPING', newValue);
    				}
    			}
			},{
				fieldLabel: '사업장',
				name: 'ACCNT_DIV_CODE',
				xtype: 'uniCombobox',
				value : UserInfo.divCode,
				comboType: 'BOR120',
				lisetners:{
					change:function(field, newValue, oldValue, eOpts){
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},		    
	        	Unilite.popup('CUST',{
		        fieldLabel: '거래처',
		        validateBlank:true,
				autoPopup:true,		        
			    valueFieldName:'CUSTOM_CODE_FR',
			    textFieldName:'CUSTOM_NAME_FR',
			    listeners:{
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE_FR', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME_FR', newValue);				
					},			    	
			    	onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE_FR', panelSearch.getValue('CUSTOM_CODE_FR'));
							panelResult.setValue('CUSTOM_NAME_FR', panelSearch.getValue('CUSTOM_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE_FR', '');
						panelResult.setValue('CUSTOM_NAME_FR', '');
					}
			    }
			}),		    
	        	Unilite.popup('CUST',{
		        fieldLabel: '~',
		        validateBlank:true,
				autoPopup:true,	
			    valueFieldName:'CUSTOM_CODE_TO',
			    textFieldName:'CUSTOM_NAME_TO',  
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE_TO', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME_TO', newValue);				
					},						
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE_TO', panelSearch.getValue('CUSTOM_CODE_TO'));
							panelResult.setValue('CUSTOM_NAME_TO', panelSearch.getValue('CUSTOM_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE_TO', '');
						panelResult.setValue('CUSTOM_NAME_TO', '');
					}
				}
			}),{
				xtype:'container',
				items:[{
					fieldLabel: '전표승인여부',
					name: 'AP_STS',
					hidden:true,
					xtype: 'uniCombobox',
					typeAhead: false,
					comboType: 'AU',
					comboCode: 'A014',
					lisetners:{
						change:function(field, newValue, oldValue, eOpts){
							panelResult.setValue('AP_STS', newValue);
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
	   					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   				}
			   		alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();		    
	   			}
		  	} else {
				this.unmask();
			}
			return r;
		}	
	});   
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {
			type : 'uniTable', 
			columns : 3
		},
		padding:'1 1 1 1',
		border:true,
		items:[{ 
				fieldLabel: '계산서일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_DATE_SHIPPING',
		        endFieldName: 'TO_DATE_SHIPPING',
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),
		        allowBlank: false,
		        onStartDateChange: function(field, newValue, oldValue, eOpts){
		        	if(panelSearch)	{
		        		panelSearch.setValue('FR_DATE_SHIPPING', newValue);
		        	}
		        },
    			onEndDateChange: function(field, newValue, oldValue, eOpts){
    				if(panelSearch)	{
    					panelSearch.setValue('TO_DATE_SHIPPING', newValue);
    				}
    			}
			},		    
	        	Unilite.popup('CUST',{
		        fieldLabel: '거래처',
		        validateBlank:true,
				autoPopup:true,	
			    valueFieldName:'CUSTOM_CODE_FR',
			    textFieldName:'CUSTOM_NAME_FR', 
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_CODE_FR', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_NAME_FR', newValue);				
					},				
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('CUSTOM_CODE_FR', panelResult.getValue('CUSTOM_CODE_FR'));
							panelSearch.setValue('CUSTOM_NAME_FR', panelResult.getValue('CUSTOM_NAME_FR'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('CUSTOM_CODE_FR', '');
						panelSearch.setValue('CUSTOM_NAME_FR', '');
					}
				}
			}),		    
	        	Unilite.popup('CUST',{
		        fieldLabel: '~',
		        labelWidth:20,
		        validateBlank:true,
				autoPopup:true,	
			    valueFieldName:'CUSTOM_CODE_TO',
			    textFieldName:'CUSTOM_NAME_TO',
			    listeners:{
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_CODE_TO', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_NAME_TO', newValue);				
					},			    	
			    	onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('CUSTOM_CODE_TO', panelSearch.getValue('CUSTOM_CODE_TO'));
							panelSearch.setValue('CUSTOM_NAME_TO', panelSearch.getValue('CUSTOM_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('CUSTOM_CODE_TO', '');
						panelSearch.setValue('CUSTOM_NAME_TO', '');
					}
			    }
			}),{
				fieldLabel: '사업장',
				name: 'ACCNT_DIV_CODE',
				xtype: 'uniCombobox',
				value : UserInfo.divCode,
				comboType: 'BOR120',
		        lisetners:{
					change:function(field, newValue, oldValue, eOpts){
						panelSearch.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},{
				xtype:'container',
				items:[{
					fieldLabel: '전표승인여부',
					name: 'AP_STS',
					itemId:'apStsField',
					xtype: 'uniCombobox',
					hidden:true,
					typeAhead: false,
					comboType: 'AU',
					comboCode: 'A014',
			        lisetners:{
						change:function(field, newValue, oldValue, eOpts){
							panelSearch.setValue('AP_STS', newValue);
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
		   					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		   				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		   					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		   				}
				   		alert(labelText+Msg.sMB083);
						invalid.items[0].focus();
					} else {
						//this.mask();		    
		   			}
			  	} else {
					this.unmask();
				}
				return r;
			}
	});
	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout : {
			type : 'uniTable', 
			columns : 1, 
			tableAttrs: { width: '100%' }
		},
		disabled: false,
		border:true,
		padding:'1 1 1 1',
		region: 'center',
		items: [{
			xtype: 'container',
			layout : {type : 'uniTable', columns : 5, tableAttrs:{width: '100%' ,border:0 }},
			
			items:[{
				fieldLabel: '<t:message code="system.label.common.slipdate" default="전표일"/>',
	            xtype: 'uniDatefield',
			 	name: 'AC_DATE',
		        value: UniDate.get('today'),
				readOnly:true,
			 	allowBlank:false,
				tdAttrs:{width:220},
			 	width:220
	     	},{
				xtype: 'uniRadiogroup',		            		
				fieldLabel: '',						            		
				name : 'WORK_TYPE',
				labelWidth:20,
				tdAttrs:{width:180},
//				width:140,
				items: [{
					boxLabel: '<t:message code="system.label.sales.billdate" default="계산서일"/>', 
					width: 70, 
					name: 'WORK_TYPE',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel : '<t:message code="system.label.sales.executedate" default="실행일"/>', 
					width: 70,
					name: 'WORK_TYPE',
	    			inputValue: '2'
				}],
				listeners:{
					change:function(field, newValue, oldValue, eOpt)	{
						if(newValue.WORK_TYPE == "1")	{
							addResult.getField("AC_DATE").setReadOnly(true);
						} else {
							addResult.setValue("AC_DATE", UniDate.get('today'));
							addResult.getField("AC_DATE").setReadOnly(false);
						}
					}
				}
			},{					
				fieldLabel: '부가세유형',
				name:'BILL_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A082',
				allowBlank: false,
				width:250,
				value :'10',
				tdAttrs:{width:250}
			},{
	    		xtype: 'uniRadiogroup',	
				tdAttrs:{width:320},
				fieldLabel: '<t:message code="system.label.sales.worktype" default="작업구분"/>',						            		
				name: 'WORK_DIVI',
				tdAttrs: {align: 'left'},
				items: [{
					boxLabel: '<t:message code="system.label.sales.autoslipposting" default="자동기표"/>', 
					width: 90, 
					name: 'WORK_DIVI',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel : '<t:message code="system.label.sales.slipcancel" default="기표취소"/>', 
					width: 90,
					name: 'WORK_DIVI',
	    			inputValue: '2'
				}],
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.WORK_DIVI == '1'){
							var field1 = panelResult.getField("AP_STS");
							var field2 = panelSearch.getField("AP_STS");
							if(field1) field1.setVisible(false);
							if(field2) field2.setVisible(false);
						}else{
							var field1 = panelResult.getField("AP_STS");
							var field2 = panelSearch.getField("AP_STS");
							if(field1) field1.setVisible(true);
							if(field2) field2.setVisible(true);
						}
					}
				}
		},{
			xtype: 'container',
			layout : {type : 'uniTable', tableAttrs:{width: '100%', border:0 }},
			tdAttrs: { width:'80%'},
			items:[{				   
				xtype: 'button',
				//name: 'CONFIRM_CHECK',
				id: 'procCanc2',
				tdAttrs: {align: 'right' , style:'padding-right:30px;padding-bottom:3px;' },
				text: '<t:message code="system.label.sales.autoslipposting" default="자동기표"/>',
				width: 100,
				handler : function() {
						if(addResult.getValue('COUNT') != 0){  
							//자동기표일 때 SP 호출
							if(addResult.getValue("WORK_DIVI").WORK_DIVI == '1'){
					            var buttonFlag = 'N';
					            fnMakeLogTable(buttonFlag);
							}
							//기표취소일 때 SP 호출
							if(addResult.getValue("WORK_DIVI").WORK_DIVI == '2'){
					            var buttonFlag = 'D';
					            fnMakeLogTable(buttonFlag);
							}
						}else {
							alert('<t:message code="system.message.sales.datacheck016" default="선택된 자료가 없습니다."/>');
							return false;
						}
					}
				}]
			}]},{
				xtype: 'container',
				layout : {type : 'uniTable', columns : 6, tdAttrs: { width: '100%'}
				},
				colspan: 5,
			    items:[{
		    			xtype: 'component'
					},{
						xtype: 'uniNumberfield',		            		
						fieldLabel: '<t:message code="system.label.sales.totalamount" default="합계"/>(<t:message code="system.label.sales.inquiry" default="조회"/>)',						            		
						width: 220,
		//				labelWidth: 60,
						name: 'TOT_SELECTED_AMT',
						readOnly: true,
						tdAttrs: {align: 'right'},
						value: 0,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('TOT_SELECTED_AMT', newValue);
							}
						}
					},{
						xtype: 'uniNumberfield',		            		
						fieldLabel: '<t:message code="system.label.sales.selected" default="건수"/>(<t:message code="system.label.sales.inquiry" default="조회"/>)',						            		
						width: 160,
						labelWidth: 100,
						name: 'TOT_COUNT',
						readOnly: true,
						tdAttrs: {align: 'right'},
						value: 0,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('TOT_COUNT', newValue);
							}
						}
					},{
			    		xtype: 'component',
						html:'/',
						width: 30,
						tdAttrs: {align: 'center'},
						style: {
							marginTop: '3px !important',
							font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
						}			
		 			},{
						xtype: 'uniNumberfield',		            		
						fieldLabel: '<t:message code="system.label.sales.totalamount" default="합계"/>(<t:message code="system.label.sales.selection" default="선택"/>)'	,						            		
						width: 220,
						labelWidth: 95,
						name: 'SELECTED_AMT',
						readOnly: true,
						tdAttrs: {align: 'right'},
						value: 0,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('SELECTED_AMT', newValue);
							}
						}
					},{
						xtype: 'uniNumberfield',		            		
						fieldLabel: '<t:message code="system.label.sales.selectedcount" default="건수(선택)"/>',						            		
						width: 160,
						labelWidth: 100,
						name: 'COUNT',
						readOnly: true,
						tdAttrs: {align: 'right'},
						value: 0,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('COUNT', newValue);
							}
						}
				}]
		}]
	});
	var masterGrid = Unilite.createGrid('agd200Grid1', {
    	layout : 'fit',
        region : 'center',
		store: MasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	uniOpt : {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: false,	
		    useGroupSummary		: true,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
    		listeners: {  
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
    				sumAmtI = sumAmtI + selectRecord.get('AMT_I');
					sumCheckedCount = sumCheckedCount + 1;
	    			addResult.setValue('SELECTED_AMT', sumAmtI);
	    			addResult.setValue('COUNT', sumCheckedCount);
	    			
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			sumAmtI = sumAmtI - selectRecord.get('AMT_I');
					sumCheckedCount = sumCheckedCount - 1;
	    			addResult.setValue('SELECTED_AMT', sumAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)
					selDesel = 0;
	    		}
    		}
        }),
        columns: [        
			{
				xtype: 'rownumberer', 
				sortable:false, 
				//locked: true, 
				width: 35,
				align:'center  !important',
				resizable: true
			},
			{dataIndex: 'DIV_CODE'   		 	, width: 100}, 				
			{dataIndex: 'BL_SER_NO'				, width: 120}, 				
			{dataIndex: 'SO_SER_NO'         	, width: 120}, 				
			{dataIndex: 'DEPT_NAME'         	, width: 100}, 				
			{dataIndex: 'BILL_DIV_CODE'			, width: 100}, 				
			{dataIndex: 'CUSTOM_CODE'			, width: 100}, 				
			{dataIndex: 'CUSTOM_NAME'			, width: 100}, 				
			{dataIndex: 'DATE_SHIPPING' 		, width: 100}, 				
			{dataIndex: 'BL_NO'					, width: 100}, 				
			{dataIndex: 'LC_NO'		    		, width: 100}, 				
			{dataIndex: 'PROJECT_NO'			, width: 100}, 				
			{dataIndex: 'PROJECT_NM'			, width: 100}, 			
			{dataIndex: 'MONEY_UNIT'			, width: 100}, 				
			{dataIndex: 'EXCHG_RATE_O'		    , width: 100}, 				
			{dataIndex: 'FOR_AMT_I'				, width: 100}, 	
			{dataIndex: 'AMT_I'					, width: 100}, 		
			{dataIndex: 'MONEY_UNIT'			, width: 100}, 		
			{dataIndex: 'REMARK_ITEM'      		, width: 100}, 				
			{dataIndex: 'RECEIPT_PLAN_DATE'		, width: 100},
			{dataIndex: 'EX_DATE'				, width: 80}, 		
			{dataIndex: 'EX_NUM'				, width: 80} 		
		]
    });    
    
	function fnMakeLogTable(buttonFlag) {
		//조건에 맞는 내용은 적용 되는 로직
		records = masterGrid.getSelectedRecords();
		buttonStore.clearData();											//buttonStore 클리어
		Ext.each(records, function(record, index) {
            record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;							//자동기표 flag
            buttonStore.insert(index, record);
			
			if (records.length == index +1) {
                buttonStore.saveStore(buttonFlag);
			}
		});
	}
		
    Unilite.Main( {
		id  : 'agd200ukrApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, 
				panelResult,
				{
					region : 'north',
					xtype : 'container',
					highth: 20,
					layout : 'fit',
					items : [ addResult ]
				}
			]},
			panelSearch  	
		], 
		fnInitBinding : function() {
			//공통코드(A082)에서 부가세 유형(수출유형)콤보 첫번째 값 가져오기
      		var billTypeSelect = Ext.data.StoreManager.lookup('CBS_AU_A082').getAt(0).get('value');
			panelSearch.setValue('BILL_TYPE', billTypeSelect);

			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			
			panelSearch.onLoadSelectText('FR_DATE_SHIPPING');
		},
		onQueryButtonDown : function()	{	
			//if(panelSearch.setAllFieldsReadOnly(true)){
				selDesel = 0;
				checkCount = 0;
//  				Ext.getCmp('selDesel').setText('전체선택');
//  				Ext.getCmp('selDesel2').setText('전체선택');
				sumSaleTaxAmtI = 0;
				sumCheckedCount = 0;
				panelSearch.setValue('SELECTED_AMT',0);
				panelSearch.setValue('COUNT',0);
				addResult.setValue('SELECTED_AMT',0);
				addResult.setValue('COUNT',0);
				MasterStore.loadStoreRecords();
			/*}else{
				return false;
			}*/
			UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			addResult.clearForm();
			MasterStore.clearData();
			newYN = 1;
			this.fnInitBinding();
		}
	});
	

};


</script>
