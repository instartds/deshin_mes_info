<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afd500ukr"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="afd500ukr" /> 		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A216" /> <!-- 상품유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A090" /> <!-- 불입주기, 이자지급주기 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var getStDt = ${getStDt};

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	gsMoneyUnit: 		'${gsMoneyUnit}'
};

function appMain() {    
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afd500ukrService.selectList',
			create: 'afd500ukrService.insertDetail',
			update: 'afd500ukrService.updateDetail',
			destroy: 'afd500ukrService.deleteDetail',
			syncAll: 'afd500ukrService.saveAll'
		}
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afd500ukrModel', {
	    fields: [  	   	
		    {name: 'SAVE_CODE'			, text: '통장코드' 		,type: 'string'},
		    {name: 'SAVE_NAME'			, text: '통장명' 		,type: 'string'},
		    {name: 'SAVE_DESC'			, text: '예적금내용' 	,type: 'string'},
		    {name: 'ITEM_TYPE'			, text: '상품유형' 		,type: 'string', comboType:'AU', comboCode:'A216'},
		    {name: 'BANK_ACCOUNT'		, text: '계좌번호(DB)' 	,type: 'string'},
		    {name: 'BANK_ACCOUNT_EXPOS'	, text: '계좌번호'		,type: 'string', allowBlank: false, defaultValue:'***************'},
		    {name: 'DIV_CODE'			, text: '사업장' 		,type: 'string'},
		    {name: 'BANK_CODE'			, text: '은행코드' 		,type: 'string'},
		    {name: 'BANK_NAME'			, text: '은행명' 		,type: 'string'},
		    {name: 'ACCNT'				, text: '계정과목코드' 	,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '계정과목명' 	,type: 'string'},
		    {name: 'SPEC_DIVI'			, text: '계정잔액특성' 	,type: 'string'},
		    {name: 'PUB_DATE'			, text: '계약일' 		,type: 'uniDate'},
		    {name: 'EXP_DATE'			, text: '만기일' 		,type: 'uniDate'},
		    {name: 'MONEY_UNIT'			, text: '화폐단위' 		,type: 'string'},
		    {name: 'EXP_AMT_I'			, text: '약정금액' 		,type: 'uniPrice'},
		    {name: 'EXP_FOR_AMT_I'		, text: '외화약정금액' 	,type: 'uniFC'},
		    {name: 'MONTH_AMT'			, text: '월불입액' 		,type: 'uniPrice'},
		    {name: 'MONTH_FOR_AMT'		, text: '외화월불입액' 	,type: 'uniFC'},
		    {name: 'NOW_AMT_I'			, text: '현불입액' 		,type: 'uniPrice'},
		    {name: 'NOW_FOR_AMT_I'		, text: '외화현불입액' 	,type: 'uniFC'},
		    {name: 'TOT_CNT'			, text: '총불입수' 		,type: 'uniQty'},
		    {name: 'NOW_CNT'			, text: '현불입수' 		,type: 'uniQty'},
		    {name: 'RETURN_PERIOD'		, text: '불입주기' 		,type: 'string'},
		    {name: 'INT_RATE'			, text: '이자율' 		,type: 'uniPercent'},
		    {name: 'INT_PERIOD'			, text: '이자지급주기' 	,type: 'string'},
		    {name: 'MIDCLOSE_RATE'		, text: '중도해지율' 	,type: 'uniPercent'},
		    {name: 'CLOSE_DATE'			, text: '해지일' 		,type: 'uniDate'},
		    {name: 'PLD_YN'				, text: '질권여부' 		,type: 'string'},
		    {name: 'PLD_DESC'			, text: '질권내용' 		,type: 'string'},
		    {name: 'SCD_CREATE_YN'		, text: '스케줄생성' 	,type: 'string'}
		    
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('afd500ukrMasterStore1',{
		model: 'Afd500ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
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
		listeners:{
			load:function(store, records){
				if(records && records.length > 0)	{
					inputTable.setDisabled(false);
				} else {
					inputTable.setDisabled(true);
				}
			},
			add:function(store, records){
				if(store.count() > 0)	{
					inputTable.setDisabled(false);
				}
			},
			remove:function(store, records){
				if(store.count() == 0)	{
					inputTable.setDisabled(true);
				}
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
	    		fieldLabel: '기준일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'BASE_DATE_FR',
			    endFieldName: 'BASE_DATE_TO',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('BASE_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('BASE_DATE_TO', newValue);				    		
			    	}
			    }
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				margin: '0 0 0 95',
				items :[{
					xtype: 'radiogroup',	
					name :'RADIO_DATE',
					items: [{
						boxLabel: '만기일', 
						width: 70,
						name: 'RADIO_DATE',
						inputValue: 'A',
						checked: true  
					},{
						boxLabel: '계약일', 
						width: 70,
						name: 'RADIO_DATE',
						inputValue: 'B' 
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('RADIO_DATE').setValue(newValue.RADIO_DATE);					
						}
					}
				}]
			},{ 
		 		fieldLabel: '사업장',
		 		name:'DIV_CODE', 
		 		xtype: 'uniCombobox',
		 		comboType:'BOR120',
		 		multiSelect: true, 
		        typeAhead: false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	 		},
				Unilite.popup('BANK_BOOK',{
					fieldLabel: '통장코드', 
					valueFieldName:'BANK_BOOK_CODE2',
				    textFieldName:'BANK_BOOK_NAME2',
//				    validateBlank:'text',
				    extParam: {'ADD_QUERY': "(SELECT SPEC_DIVI FROM ABA400T WHERE COMP_CODE = A.COMP_CODE AND ACCNT=A.ACCNT) IN ('B3','B4','C')"},
				    listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('BANK_BOOK_CODE2', panelSearch.getValue('BANK_BOOK_CODE2'));
								panelResult.setValue('BANK_BOOK_NAME2', panelSearch.getValue('BANK_BOOK_NAME2'));
		                	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('BANK_BOOK_CODE2', '');
							panelResult.setValue('BANK_BOOK_NAME2', '');
						}
					}
			}),{ 
		 		fieldLabel: '사용유무',
		 		name:' USE_YN', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'A004',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('USE_YN', newValue);
					}/*,
					specialkey: function(elm, e){
						UniAppManager.app.onQueryButtonDown();
					}*/
				}
	 		},{ 
    			fieldLabel: '당기시작년월',
    			name:'ST_DATE2',
				xtype: 'uniMonthfield',
				value: getStDt.STDT,
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
	});	//end panelSearch  
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            items :[{ 
	    		fieldLabel: '기준일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'BASE_DATE_FR',
			    endFieldName: 'BASE_DATE_TO',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelSearch.setValue('BASE_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('BASE_DATE_TO', newValue);				    		
			    	}
			    }
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				items :[{
					xtype: 'radiogroup',	
					name :'RADIO_DATE',
					items: [{
						boxLabel: '만기일', 
						width: 70,
						name: 'RADIO_DATE',
						inputValue: 'A',
						checked: true  
					},{
						boxLabel: '계약일', 
						width: 70,
						name: 'RADIO_DATE',
						inputValue: 'B' 
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('RADIO_DATE').setValue(newValue.RADIO_DATE);					
						}
					}
				}
			]}
		]},{ 
		 		fieldLabel: '사업장',
		 		name:'DIV_CODE', 
		 		xtype: 'uniCombobox',
		 		comboType:'BOR120',
		 		multiSelect: true, 
		        typeAhead: false,
		 		//padding: '0 0 0 110',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
	 		},		    
	    	Unilite.popup('BANK_BOOK',{
				fieldLabel: '통장코드', 
				valueFieldName:'BANK_BOOK_CODE2',
			    textFieldName:'BANK_BOOK_NAME2',
			    extParam: {'ADD_QUERY': "(SELECT SPEC_DIVI FROM ABA400T WHERE COMP_CODE = A.COMP_CODE AND ACCNT=A.ACCNT) IN ('B3','B4','C')"},
//			    validateBlank:'text',
			    listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('BANK_BOOK_CODE2', panelResult.getValue('BANK_BOOK_CODE2'));
							panelSearch.setValue('BANK_BOOK_NAME2', panelResult.getValue('BANK_BOOK_NAME2'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('BANK_BOOK_CODE2', '');
						panelSearch.setValue('BANK_BOOK_NAME2', '');
					}
				}
			}),{ 
		 		fieldLabel: '사용유무',
		 		name:' USE_YN', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'A004',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('USE_YN', newValue);
					}/*,
					specialkey: function(elm, e){
						UniAppManager.app.onQueryButtonDown();
					}*/
				}
	 		},{ 
    			fieldLabel: '당기시작년월',
    			name:'ST_DATE2',
				xtype: 'uniMonthfield',
				value: getStDt.STDT,
				hidden: true
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
			
		var inputTable = Unilite.createSearchForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 3},
		disabled: true,
        border:true,
        padding:'1 1 1 1',
		region: 'center',
    	autoScroll: true,
        masterGrid: masterGrid,
		items: [
		    Unilite.popup('BANK_BOOK',{
				fieldLabel: '통장', 
				//readOnly: true,
				allowBlank: false,
				valueFieldName:'SAVE_CODE',
			    textFieldName:'SAVE_NAME',
			    extParam: {'ADD_QUERY': "(SELECT SPEC_DIVI FROM ABA400T WHERE COMP_CODE = A.COMP_CODE AND ACCNT=A.ACCNT) IN ('B3','B4','C')"},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							inputTable.setValue('SAVE_CODE'		, records[0].BANK_BOOK_CODE);
							inputTable.setValue('SAVE_NAME'		, records[0].BANK_BOOK_NAME);
							inputTable.setValue('BANK_CODE'		, records[0].BANK_CD);
							inputTable.setValue('BANK_NAME'		, records[0].BANK_NM);		 	
							inputTable.setValue('ACCNT'			, records[0].ACCNT);
							inputTable.setValue('ACCNT_NAME'	, records[0].ACCNT_NAME);	
						},
						scope: this
					},
					onClear: function(type)	{
						inputTable.setValue('SAVE_CODE'		, '');
						inputTable.setValue('SAVE_NAME'		, '');	
						inputTable.setValue('BANK_CODE'		, '');
						inputTable.setValue('BANK_NAME'		, '');	
						inputTable.setValue('ACCNT'			, '');
						inputTable.setValue('ACCNT_NAME'	, '');		
					},
					onTextSpecialKey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('BANK_CODE').focus();  
	                	}
	                }
				}
			}),{ 
		 		fieldLabel: '사업장',
		 		name:'DIV_CODE', 
				//readOnly: true,
				labelWidth: 227,
				//padding: '0 0 0 27',
		 		xtype: 'uniCombobox',
		 		comboType:'BOR120',
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('PUB_DATE').focus();  
	                	}
	                }
	    		}
	 		},{
			 	fieldLabel: '해지일',
			 	xtype: 'uniDatefield',
				labelWidth: 227,
			 	name: 'CLOSE_DATE',
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('CLOSE_DATE').focus();  
	                	}
	                }
	    		}
			},
			Unilite.popup('BANK',{ 
		    	fieldLabel: '은행코드', 
				//readOnly: true,
		    	validateBlank: false, 
		    	popupWidth: 500,
		    	valueFieldName: 'BANK_CODE',
				textFieldName: 'BANK_NAME',
	    		listeners: {
	    			onTextSpecialKey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('ACCNT').focus();  
	                	}
	                }
	    		}
			}),{
			 	fieldLabel: '계약일',
			 	xtype: 'uniDatefield',
				labelWidth: 227,
				allowBlank: false,
			 	name: 'PUB_DATE',
			 	
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('PUB_DATE').focus();  
	                	}
	                }
	    		}
			},{
			 	fieldLabel: '중도해지율',
			 	xtype: 'uniNumberfield',
				labelWidth: 227,
			 	suffixTpl: '%',
			 	name: 'MIDCLOSE_RATE',
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('MIDCLOSE_DATE').focus();  
	                	}
	                }
	    		}
			},
			Unilite.popup('ACCNT',{ 
		    	fieldLabel: '계정과목', 
		    	extParam: {'ADD_QUERY': "ISNULL(SPEC_DIVI,'') IN ('B3','B4','C')"},
				//readOnly: true,
		    	popupWidth: 500,
		    	valueFieldName: 'ACCNT',
				textFieldName: 'ACCNT_NAME',
	    		listeners: {
	    			onTextSpecialKey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('ITEM_TYPE').focus();  
	                	}
	                }
	    		}
			}),{
			 	fieldLabel: '만기일',
			 	xtype: 'uniDatefield',
				labelWidth: 227,
				allowBlank: false,
			 	name: 'EXP_DATE',
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('RETURN_PERIOD').focus();  
	                	}
	                }
	    		}
			},{
			 	fieldLabel: '이자율',
			 	xtype: 'uniNumberfield',
				labelWidth: 227,
			 	suffixTpl: '%',
			 	name: 'INT_RATE',
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('INT_PERIOD').focus();  
	                	}
	                }
	    		}
			},{
			 	fieldLabel: '예적금내용',
			 	xtype: 'textareafield',
			 	name: 'SAVE_DESC',
				allowBlank: false,
			 	width: 325,
			 	height:40,
			 	rowspan:2,
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('PLD_YN').focus();  
	                	}
	                }
	    		}
			},{ 
		 		fieldLabel: '불입주기',
		 		name:'RETURN_PERIOD', 
				allowBlank: false,
		 		xtype: 'uniCombobox',
				labelWidth: 227,
		 		comboType:'AU',
		 		comboCode:'A090',
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('TOT_CNT').focus();  
	                	}
	                }
	    		}
	 		},{ 
		 		fieldLabel: '이자지급주기',
		 		name:'INT_PERIOD', 
				labelWidth: 227,
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'A090',
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('MONEY_UNIT').focus();  
	                	}
	                }
	    		}
	 		},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
//				width:625,
				items :[{
					fieldLabel:'총불입수/현불입수', 
					xtype: 'uniNumberfield',
					name: 'TOT_CNT', 
					allowBlank: false,
					labelWidth: 227,
 					width:300
				},{
					xtype:'component', 
					html:'/',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniNumberfield',
					readOnly: true,
					name: 'NOW_CNT', 
 					width:75
				}],
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('EXP_AMT_I').focus();  
	                	}
	                }
	    		}
			},{ 
		 		fieldLabel: '화폐단위',
		 		name:'MONEY_UNIT', 
		 		xtype: 'uniCombobox',
				allowBlank: false,
		 		comboType:'AU',
		 		comboCode:'B004', 
		 		displayField: 'value',
				labelWidth: 227,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						var count = masterGrid.getStore().getCount();
						var record = masterGrid.getSelectedRecord();
						if(count > 0) {
							if(inputTable.getValue('MONEY_UNIT') == BsaCodeInfo.gsMoneyUnit) {
								inputTable.getField('EXP_FOR_AMT_I').setReadOnly(true);
								inputTable.getField('MONTH_FOR_AMT').setReadOnly(true);
								inputTable.getField('NOW_FOR_AMT_I').setReadOnly(true);
							} else {
								inputTable.getField('EXP_FOR_AMT_I').setReadOnly(false);
								inputTable.getField('MONTH_FOR_AMT').setReadOnly(true);
								inputTable.getField('NOW_FOR_AMT_I').setReadOnly(true);
							}
						} else {
							if(inputTable.getValue('MONEY_UNIT') == BsaCodeInfo.gsMoneyUnit) {
								inputTable.setValue('EXP_FOR_AMT_I', 0);
								inputTable.setValue('MONTH_FOR_AMT', 0);
								inputTable.setValue('NOW_FOR_AMT_I', 0);
								inputTable.getField('EXP_FOR_AMT_I').setReadOnly(true);
								inputTable.getField('MONTH_FOR_AMT').setReadOnly(true);
								inputTable.getField('NOW_FOR_AMT_I').setReadOnly(true);
							} else {
								inputTable.getField('EXP_FOR_AMT_I').setReadOnly(false);
								inputTable.getField('MONTH_FOR_AMT').setReadOnly(false);
								inputTable.getField('NOW_FOR_AMT_I').setReadOnly(true);
							}
						}
					},
	    			onTextSpecialKey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('EXP_FOR_AMT_I').focus();  
	                	}
	                }
				}
	 		},{
				xtype: 'radiogroup',		            		
				fieldLabel: '질권여부',	
				//id: 'PLD_YN_RADIO2',	
				name :'PLD_YN',
				items: [{
					boxLabel: '설정않음', 
					width: 70, 
					name: 'PLD_YN',
					inputValue: 'N'
				},{
					boxLabel : '설정', 
					width: 70,
					name: 'PLD_YN',
					inputValue: 'Y',
					checked: true  
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.PLD_YN == 'N') {
							Ext.getCmp('PLD_DESC_ID').setReadOnly(true);
						} else {
							Ext.getCmp('PLD_DESC_ID').setReadOnly(false);
						}
					},
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('PLD_DESC').focus();  
	                	}
	                }
				}
			},{
			 	fieldLabel: '약정금액',
			 	xtype: 'uniNumberfield',
				labelWidth: 227,
				allowBlank: false,
			 	name: 'EXP_AMT_I',
	    		listeners: {
	    			change: function(field, newValue, oldValue, eOpts) {
	    				var count = masterGrid.getStore().getCount();
	    				var record = masterGrid.getSelectedRecord();
						if(count > 0 && (record.get('SPEC_DIVI') == 'B3' || record.get('SPEC_DIVI') == 'B4')) {
							inputTable.setValue('MONTH_AMT', newValue);
						} else {
							return false;
						}
	    			},
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('MONTH_AMT').focus();  
	                	}
	                }
	    		}
			},{
			 	fieldLabel: '외화약정금액',
				//readOnly: true,
				labelWidth: 227,
			 	xtype: 'uniNumberfield',
			 	type: 'uniFC',
			 	name: 'EXP_FOR_AMT_I',
	    		listeners: {
	    			change: function(field, newValue, oldValue, eOpts) {
	    				var count = masterGrid.getStore().getCount();
	    				var record = masterGrid.getSelectedRecord();
						if(count > 0 && (record.get('SPEC_DIVI') == 'B3' || record.get('SPEC_DIVI') == 'B4')) {
							inputTable.setValue('MONTH_FOR_AMT', newValue);
						} else {
							return false;
						}
	    			},
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('MONTH_FOR_AMT').focus();  
	                	}
	                }
	    		}/*,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						var count = masterGrid.getStore().getCount();
						if(count > 0) {
							inputTable.setValue('MONTH_FOR_AMT', newValue);
						} else {
							
						}
					}
				}*/
			},{
			 	fieldLabel: '질권내용',
			 	xtype: 'textareafield',
			 	id: 'PLD_DESC_ID',
			 	name: 'PLD_DESC',
			 	height : 40,
			 	width: 325,
			 	rowspan:2,
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('SCD_CREATE_YN').focus();  
	                	}
	                }
	    		}
			},{
			 	fieldLabel: '월불입액',
			 	xtype: 'uniNumberfield',
				labelWidth: 227,
				allowBlank: false,
			 	name: 'MONTH_AMT',
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('NOW_AMT').focus();  
	                	}
	                }
	    		}
			},{
			 	fieldLabel: '외화월불입액',
				//readOnly: true,
				labelWidth: 227,
			 	xtype: 'uniNumberfield',
			 	type: 'uniFC',
			 	name: 'MONTH_FOR_AMT',
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('NOW_FOR_AMT_I').focus();  
	                	}
	                }
	    		}
			},{
			 	fieldLabel: '현불입액',
				//readOnly: true,
				labelWidth: 227,
			 	xtype: 'uniNumberfield',
			 	name: 'NOW_AMT_I',
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('CLOSE_DATE').focus();  
	                	}
	                }
	    		}
			},{
			 	fieldLabel: '외화현불입액',
				//readOnly: true,
				labelWidth: 227,
			 	xtype: 'uniNumberfield',
			 	name: 'NOW_FOR_AMT_I'
			},{
				xtype: 'radiogroup',
				fieldLabel: '스케줄생성',
				items: [{
					boxLabel: '예', 
					width: 70,
					name: 'SCD_CREATE_YN',
					inputValue: 'Y'
				},{
					boxLabel: '아니오', 
					width: 70,
					name: 'SCD_CREATE_YN',
					inputValue: 'N',
					checked: true  
				}]
			},{ 
		 		fieldLabel: '상품유형',
		 		name:'ITEM_TYPE', 
		 		xtype: 'uniCombobox',
				labelWidth: 227,
		 		comboType:'AU',
		 		comboCode:'A216',
	    		listeners: {
	    			specialkey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	inputTable.getField('SAVE_DESC').focus();  
	                	}
	                }
	    		}
	 		}
		],
		loadForm: function(record)	{
			// window 오픈시 form에 Data load
			var count = masterGrid.getStore().getCount();
			if(count > 0) {
				//this.reset();
				this.setActiveRecord(record[0] || null);   
				this.resetDirtyStatus();			
			}
		},
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
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('afd500ukrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
		store: directMasterStore,
    	uniOpt : {
			useMultipleSorting	: true,			 
		   	useLiveSearch		: true,			
		   	onLoadSelectFirst	: true,		
		   	dblClickToEdit		: false,		
		   	useGroupSummary		: true,			
			useContextMenu		: true,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: false,	// rink 항목이 있을경우만 true			
		   	filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
        columns: [
        	{dataIndex: 'SAVE_CODE'					, width: 66}, 				
			{dataIndex: 'SAVE_NAME'					, width: 120}, 				
			{dataIndex: 'SAVE_DESC'					, width: 300},
			{dataIndex: 'ITEM_TYPE'					, width: 88},
			{dataIndex: 'BANK_ACCOUNT'				, width: 150 , hidden: true},
			{dataIndex: 'BANK_ACCOUNT_EXPOS'    	, width: 120},
			{dataIndex: 'DIV_CODE'					, width: 66 , hidden: true}, 				
			{dataIndex: 'BANK_CODE'					, width: 66 , hidden: true}, 	
			{dataIndex: 'BANK_NAME'					, width: 120}, 				
			{dataIndex: 'ACCNT'						, width: 66 , hidden: true}, 				
			{dataIndex: 'ACCNT_NAME'				, width: 120}, 	
			{dataIndex: 'SPEC_DIVI'					, width: 66 , hidden: true}, 				
			{dataIndex: 'PUB_DATE'					, width: 80}, 				
			{dataIndex: 'EXP_DATE'					, width: 80}, 	
			{dataIndex: 'MONEY_UNIT'				, width: 66 , hidden: true}, 				
			{dataIndex: 'EXP_AMT_I'					, width: 120}, 				
			{dataIndex: 'EXP_FOR_AMT_I'				, width: 66 , hidden: true}, 	
			{dataIndex: 'MONTH_AMT'					, width: 66 , hidden: true}, 				
			{dataIndex: 'MONTH_FOR_AMT'				, width: 66 , hidden: true}, 				
			{dataIndex: 'NOW_AMT_I'					, width: 120}, 	
			{dataIndex: 'NOW_FOR_AMT_I'				, width: 66 , hidden: true}, 				
			{dataIndex: 'TOT_CNT'					, width: 66 , hidden: true}, 				
			{dataIndex: 'NOW_CNT'					, width: 66 , hidden: true}, 	
			{dataIndex: 'RETURN_PERIOD'				, width: 66 , hidden: true}, 				
			{dataIndex: 'INT_RATE'					, width: 66 }, 				
			{dataIndex: 'INT_PERIOD'				, width: 66 , hidden: true}, 	
			{dataIndex: 'MIDCLOSE_RATE'				, width: 66 , hidden: true}, 				
			{dataIndex: 'CLOSE_DATE'				, width: 66 , hidden: true}, 				
			{dataIndex: 'PLD_YN'					, width: 66 , hidden: true}, 	
			{dataIndex: 'PLD_DESC'					, width: 66 , hidden: true},
			{dataIndex: 'SCD_CREATE_YN'				, width: 88 }
		],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {	
	        	if(!e.record.phantom) {                     
	        		return false;                            
	        	} else {                                    
	        		return false;                            
	        	}                                           
	        },												
        	selectionchange:function( model1, selected, eOpts ) {
        		if(!Ext.isEmpty(selected)) {
	        		var record = selected[0];
	        		var count = masterGrid.getStore().getCount();
	        		if(record.get('SPEC_DIVI') == 'B3' || record.get('SPEC_DIVI') == 'B4') {
	        			inputTable.getField('EXP_AMT_I').setReadOnly(false);
	        			inputTable.getField('EXP_FOR_AMT_I').setReadOnly(false)
	        			inputTable.getField('MONTH_FOR_AMT').setReadOnly(true);
	        			inputTable.getField('MONTH_AMT').setReadOnly(true);
	        			inputTable.getField('TOT_CNT').setReadOnly(true);
	        		} else {
	        			inputTable.getField('EXP_AMT_I').setReadOnly(false);
	        			inputTable.getField('EXP_FOR_AMT_I').setReadOnly(false)
	        			inputTable.getField('MONTH_FOR_AMT').setReadOnly(false);
	        			inputTable.getField('MONTH_AMT').setReadOnly(false);
	        			inputTable.getField('TOT_CNT').setReadOnly(false);
	        		}
	        		if(record.get('MONEY_UNIT') == BsaCodeInfo.gsMoneyUnit) {
	        			inputTable.getField('EXP_FOR_AMT_I').setReadOnly(true);
	        			inputTable.getField('MONTH_FOR_AMT').setReadOnly(true);
	        		} else {
	        			inputTable.getField('EXP_FOR_AMT_I').setReadOnly(false);
	        			inputTable.getField('MONTH_FOR_AMT').setReadOnly(false);
	        		}
	        		
	        	}
        		inputTable.loadForm(selected);
          	},
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="BANK_ACCOUNT_EXPOS") {
					grid.ownerGrid.openCryptPopup(record);
				}
			}			
		},
		openCryptPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);
			}
				
		}          	            
    });
    
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[{
					region : 'center',
					xtype : 'container',
					layout : 'fit',
					items : [ masterGrid ]
				},
				panelResult,
				{
					region : 'north',
					xtype : 'container',
					highth: 20,
					layout : 'fit',
					items : [ inputTable ]
				}
			]
		},
			panelSearch  	
		], 
		id : 'afd500ukrApp',
		fnInitBinding : function() {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			inputTable.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
			inputTable.getField('SAVE_CODE').setReadOnly(true);
			inputTable.getField('SAVE_NAME').setDisabled(true);
			inputTable.getField('DIV_CODE').setReadOnly(true);
			inputTable.getField('BANK_CODE').setReadOnly(true);
			inputTable.getField('BANK_NAME').setReadOnly(true);
			inputTable.getField('ACCNT').setReadOnly(true);
			inputTable.getField('ACCNT_NAME').setReadOnly(true);
			inputTable.getField('NOW_CNT').setReadOnly(true);
			inputTable.getField('MONTH_FOR_AMT').setReadOnly(true);
			inputTable.getField('NOW_AMT_I').setReadOnly(true);
			inputTable.getField('NOW_FOR_AMT_I').setReadOnly(true);
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('newData',false);
		},
		onResetButtonDown: function() {		// 초기화
			/*if(this.confirmSaveData())	{
				return false;
			}
			masterGrid.reset();
			directMasterStore.clearData();*/
			
			inputTable.setDisabled(false);
			masterGrid.createRow({DIV_CODE : panelSearch.getValue("DIV_CODE")});
			
			inputTable.getField('SAVE_CODE').setReadOnly(false);
			inputTable.getField('SAVE_CODE').focus();
			
			inputTable.setValue('SAVE_CODE', '');
			inputTable.setValue('SAVE_NAME', '');
			inputTable.setValue('ITEM_TYPE', '');
			inputTable.setValue('DIV_CODE', '');
			inputTable.setValue('CLOSE_DATE', '');
			inputTable.setValue('BANK_CODE', '');
			inputTable.setValue('BANK_NAME', '');
			inputTable.setValue('PUB_DATE', '');
			inputTable.setValue('MIDCLOSE_RATE', '');
			inputTable.setValue('ACCNT', '');
			inputTable.setValue('ACCNT_NAME', '');
			inputTable.setValue('EXP_DATE', '');
			inputTable.setValue('INT_RATE', '');
			inputTable.setValue('SAVE_DESC', '');
			inputTable.setValue('PLD_YN', 'N');
			
			inputTable.setValue('RETURN_PERIOD', '');
			inputTable.setValue('INT_PERIOD', '');
			inputTable.setValue('TOT_CNT', 1);
			inputTable.setValue('NOW_CNT', 0);
			inputTable.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
			inputTable.setValue('EXP_AMT_I', '');
			inputTable.setValue('EXP_FOR_AMT_I', '');
			inputTable.setValue('PLD_DESC', '');
			inputTable.setValue('MONTH_AMT', '');
			inputTable.setValue('MONTH_FOR_AMT', '');
			inputTable.setValue('NOW_AMT_I', '');
			inputTable.setValue('MOW_FOR_AMT_I', '');
			inputTable.setValue('SCD_CREATE_YN', 'N');
			this.setEnableFields();
			inputTable.getField('SAVE_CODE').focus();
		},
		onQueryButtonDown : function()	{			
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}	
			inputTable.getField('SAVE_CODE').setReadOnly(true);
			
			directMasterStore.loadStoreRecords();
			
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			if(inputTable.setAllFieldsReadOnly(true) == false){
				return false;
			}
			var param= inputTable.getValues(); 
			var count = masterGrid.getStore().getCount();
			if(count > 0) {
				directMasterStore.saveStore();	
			} else {
				afd500ukrService.saveCodeCheck(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						alert("동일한 통장코드가 이미 등록되어 있습니다.");
					} else {
						var param= inputTable.getValues();
						directMasterStore.saveStore();	
					}
				});
			}
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
				UniAppManager.app.onSaveDataButtonDown();
			}
		},
		_needSave:function()	{
			return false;
		},
		rejectSave: function() {
            var rowIndex = masterGrid.getSelectedRowIndex();
            detailGrid.select(rowIndex);
            directMasterStore.rejectChanges();

            directMasterStore.onStoreActionEnable();

        },
        confirmSaveData: function(config)   {
            if(directMasterStore.isDirty() )  {
                if(confirm('<t:message code="system.message.sales.message021" default="변경된 내용을 저장하시겠습니까?"/>')) {
                    this.onSaveDataButtonDown(config);
                } else {
                    this.rejectSave();
                }
            }
        },
        setEnableFields:function()	{
        	inputTable.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
			//UniAppManager.app.onNewDataButtonDown();
			
			inputTable.getField('SAVE_DESC').setReadOnly(false);  //예적금 내용
			inputTable.getField('PLD_YN').setReadOnly(false);	  //질권여부
			if(inputTable.getValue('PLD_YN').PLD_YN == 'Y')	{
				inputTable.getField('PLD_DESC').setReadOnly(false);    //질권내용
			} else {
				inputTable.getField('PLD_DESC').setReadOnly(true);    //질권내용
			}
			inputTable.getField('PUB_DATE').setReadOnly(false);	//계약일
			inputTable.getField('EXP_DATE').setReadOnly(false);	//만기일
			inputTable.getField('EXP_DATE').setDisabled(false);	//만기일
			inputTable.getField('RETURN_PERIOD').setReadOnly(false);	//불입주기
			inputTable.getField('TOT_CNT').setReadOnly(false);	//총불입수
			inputTable.getField('EXP_AMT_I').setReadOnly(false);	//약정금액
			inputTable.getField('MONTH_AMT').setReadOnly(false);	//월불입액
			
			inputTable.getField('CLOSE_DATE').setReadOnly(false);	//해지일
			inputTable.getField('MIDCLOSE_RATE').setReadOnly(false);	//중도해지율
			inputTable.getField('INT_RATE').setReadOnly(false);	//이자율
			inputTable.getField('INT_PERIOD').setReadOnly(false);	//이자지급주기
			inputTable.getField('MONEY_UNIT').setReadOnly(false);	//화폐단위
			
			if(BsaCodeInfo.gsMoneyUnit == inputTable.getValue('MONEY_UNIT'))	{
				inputTable.getField('MONTH_FOR_AMT').setReadOnly(true);
				inputTable.getField('NOW_FOR_AMT_I').setReadOnly(true);//외화현불입액
				inputTable.getField('EXP_FOR_AMT_I').setReadOnly(true);
			} else {
				inputTable.getField('MONTH_FOR_AMT').setReadOnly(false);
				inputTable.getField('NOW_FOR_AMT_I').setReadOnly(false);//외화현불입액
				inputTable.getField('EXP_FOR_AMT_I').setReadOnly(false);
			}
			//장된 후에는 수정할 수 없는 FreeForm항목
			inputTable.getField('SAVE_CODE').setReadOnly(false);//통장코드
			
			//모든 경우에 수정할 수 없는 FreeForm항목
			inputTable.getField('SAVE_NAME').setDisabled(true);//통장명
			inputTable.getField('DIV_CODE').setReadOnly(true); //사업장
			inputTable.getField('BANK_CODE').setReadOnly(true);//은행코드
			inputTable.getField('BANK_NAME').setReadOnly(true);//은행명
			inputTable.getField('ACCNT').setReadOnly(true);//계정과목
			inputTable.getField('ACCNT_NAME').setReadOnly(true);//계정과목명
			inputTable.getField('NOW_CNT').setReadOnly(true);//현불입수
			inputTable.getField('NOW_AMT_I').setReadOnly(true);//현불입액
			
        },
        setDisableFields:function()	{
			inputTable.getField('SAVE_DESC').setReadOnly(false);  //예적금 내용
			inputTable.getField('PLD_YN').setReadOnly(false);	  //질권여부
			if(inputTable.getValue('PLD_YN').PLD_YN == 'Y')	{
				inputTable.getField('PLD_DESC').setReadOnly(false);    //질권내용
			} else {
				inputTable.getField('PLD_DESC').setReadOnly(true);    //질권내용
			}
			inputTable.getField('PUB_DATE').setReadOnly(false);	//계약일
			inputTable.getField('EXP_DATE').setDisabled(false);	//만기일
			inputTable.getField('RETURN_PERIOD').setReadOnly(false);	//불입주기
			inputTable.getField('TOT_CNT').setReadOnly(false);	//총불입수
			inputTable.getField('EXP_AMT_I').setReadOnly(false);	//약정금액
			inputTable.getField('MONTH_AMT').setReadOnly(false);	//월불입액
			
			inputTable.getField('CLOSE_DATE').setReadOnly(false);	//해지일
			inputTable.getField('MIDCLOSE_RATE').setReadOnly(false);	//중도해지율
			inputTable.getField('INT_RATE').setReadOnly(false);	//이자율
			inputTable.getField('INT_PERIOD').setReadOnly(false);	//이자지급주기
			inputTable.getField('MONEY_UNIT').setReadOnly(false);	//화폐단위
			inputTable.getField('EXP_FOR_AMT_I').setReadOnly(true);	//외화약정금액  BsaCodeInfo.gsMoneyUnit 값으로 초기값 셋팅됨
			inputTable.getField('MONTH_FOR_AMT').setReadOnly(true);	//외화월불입액  BsaCodeInfo.gsMoneyUnit 값으로 초기값 셋팅됨
			inputTable.getField('NOW_AMT_I').setReadOnly(false);//현불입액
			
			//저장된 후에는 수정할 수 없는 FreeForm항목
			inputTable.getField('SAVE_CODE').setReadOnly(false);//통장코드
			
			//모든 경우에 수정할 수 없는 FreeForm항목
			inputTable.getField('SAVE_NAME').setDisabled(true);//통장명
			inputTable.getField('DIV_CODE').setReadOnly(true); //사업장
			inputTable.getField('BANK_CODE').setReadOnly(true);//은행코드
			inputTable.getField('BANK_NAME').setReadOnly(true);//은행명
			inputTable.getField('ACCNT').setReadOnly(true);//계정과목
			inputTable.getField('ACCNT_NAME').setReadOnly(true);//계정과목명
			inputTable.getField('NOW_CNT').setReadOnly(true);//현불입수
			inputTable.getField('MONTH_FOR_AMT').setReadOnly(true);
			inputTable.getField('NOW_FOR_AMT_I').setReadOnly(true);//외화현불입액
        }
	});
};


</script>
