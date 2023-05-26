<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afn100skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A047" /> <!-- 어음구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A058" /> <!-- 어음종류 -->
	<t:ExtComboStore comboType="AU" comboCode="A057" /> <!-- 어음보관장소 -->
	<t:ExtComboStore comboType="AU" comboCode="A063" /> <!-- 어음상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B064" /> <!-- 수취구분 -->
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
	Unilite.defineModel('Afn100skrModel', {
	    fields: [  	  
	    	{name: 'AC_CD'   			, text: '어음구분' 	,type: 'string' ,comboType:'AU', comboCode:'A047'},
		    {name: 'NOTE_NUM'  			, text: '어음번호'		,type: 'string'},
		    {name: 'EXP_DATE'			, text: '만기일' 		,type: 'uniDate'},
		    {name: 'CUSTOM_CODE' 		, text: '거래처코드' 	,type: 'string'},
		    {name: 'CUSTOM_NAME' 		, text: '거래처명' 	,type: 'string'},
		    {name: 'BANK_CODE' 			, text: '은행코드' 	,type: 'string'},
		    {name: 'BANK_NAME'			, text: '은행명' 		,type: 'string'},
		    {name: 'OC_AMT_I'  			, text: '발행금액' 	,type: 'uniPrice'},
		    {name: 'J_AMT_I'  			, text: '결제금액' 	,type: 'uniPrice'},
		    {name: 'JAN_AMT_I'  		, text: '미결제금액' 	,type: 'uniPrice'},
		    {name: 'REMARK'             , text: '적요'       ,type: 'string'},
		    {name: 'NOTE_STS'  			, text: '어음상태' 	,type: 'string'  ,comboType:'AU', comboCode:'A063'},
		    {name: 'PUB_DATE'  			, text: '발행일' 		,type: 'uniDate'},
		    {name: 'AC_DATE'  			, text: '전표일' 		,type: 'uniDate'},
		    {name: 'SLIP_NUM'  			, text: '전표번호' 	,type: 'string'},
		    {name: 'SLIP_SEQ'  			, text: '순번' 		,type: 'string'},
		    {name: 'J_DATE'  			, text: '반제일' 		,type: 'uniDate'},
		    {name: 'J_NUM'  			, text: '반제번호' 	,type: 'string'},
		    {name: 'J_SEQ'  			, text: '순번' 		,type: 'string'},
		    {name: 'DC_DIVI'  			, text: '어음종류' 	,type: 'string' ,comboType:'AU', comboCode:'A058'},
		    {name: 'RECEIPT_DIVI'		, text: '수취구분' 	,type: 'string' ,comboType:'AU', comboCode:'B064'},
		    {name: 'NOTE_KEEP'  		, text: '보관장소' 	,type: 'string' ,comboType:'AU', comboCode:'A057'},
		    {name: 'PUB_MAN'  			, text: '발행인' 		,type: 'string'},
		    {name: 'CHECK1'  			, text: '배서인1' 	,type: 'string'},
		    {name: 'CHECK2'  			, text: '배서인2' 	,type: 'string'},
		    {name: 'ACCNT'  			, text: '계정코드' 	,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '계정명' 		,type: 'string'}
	
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('afn100skrMasterStore1',{
		model: 'Afn100skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afn100skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		this.fnOrderAmtSum();
	           	}
		},
		fnOrderAmtSum: function() {
				
			var Amt1 = 0;
			var Amt2 = 0;
			var Amt3 = 0;
			
			var results1 = this.sumBy(function(record, id){
									return record.get('AC_CD') == 'D1';}, 
										['OC_AMT_I']);						
				Amt1 = results1.OC_AMT_I;						
										
			var results2 = this.sumBy(function(record, id){
									return record.get('AC_CD') == 'D3';}, 
										['OC_AMT_I']);						
				Amt2 = results2.OC_AMT_I;																
			
			panelSearch.setValue('AMT1',Amt1); 	   				// 받을어음금액
			panelSearch.setValue('AMT2',Amt2); 	   				// 지급어음금액
			panelSearch.setValue('AMT3',Amt1 + Amt2);     		// 합계	
				
			panelResult.setValue('AMT1',Amt1); 	   				// 받을어음금액
			panelResult.setValue('AMT2',Amt2); 	   				// 지급어음금액
			panelResult.setValue('AMT3',Amt1 + Amt2);     		// 합계
			
			
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
		        fieldLabel: '일 자',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_DATE',
				endFieldName:'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
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
				xtype: 'radiogroup',		            		
				fieldLabel: '일자기준',
				id: 'basedate',
				items: [{
						boxLabel: '만기일', 
						width: 65, 
						name: 'ESS',
						inputValue: 'MGDay',
						checked: true  
					},{
						boxLabel : '발행일', 
						width: 65,
						name: 'ESS',
						inputValue: 'BHDay'
					},{
						boxLabel : '전표일', 
						width: 65,
						name: 'ESS',
						inputValue: 'JPDay'
					},{
						boxLabel : '반제일', 
						width: 65,
						name: 'ESS',
						inputValue: 'BJDay'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('ESS').setValue(newValue.ESS);
						}
					}
				},{	
			 		fieldLabel: '어음구분',
			 		name:'AC_CD', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'A047',
			 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AC_CD', newValue);
						}
					}
		 		},{
			 		fieldLabel: '어음상태',
			 		name:'NOTE_STS', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'A063',
			 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('NOTE_STS', newValue);
						}
					}
		 		},
					Unilite.popup('BANK',{ 
				    	fieldLabel: '은행코드', 
				    	popupWidth: 500,
						autoPopup   : true ,
				    	valueFieldName: 'BANK_CODE',
						textFieldName: 'BANK_NAME',
				    	listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('BANK_CODE', panelSearch.getValue('BANK_CODE'));
									panelResult.setValue('BANK_NAME', panelSearch.getValue('BANK_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('BANK_CODE', '');
								panelResult.setValue('BANK_NAME', '');
							},
							applyextparam: function(popup){							
								//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				}),   	
					
					Unilite.popup('CUST',{ 
				    	fieldLabel: '거래처', 
				    	popupWidth: 710,
						allowBlank:true,
						autoPopup:false,
						validateBlank:false,
				    	valueFieldName: 'CUSTOM_CODE',
						textFieldName: 'CUSTOM_NAME',
				    	listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('CUSTOM_CODE', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_NAME', '');
									panelSearch.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('CUSTOM_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_CODE', '');
									panelSearch.setValue('CUSTOM_CODE', '');
								}
							},
			    			onTextSpecialKey: function(elm, e){
			                    if (e.getKey() == e.ENTER) {
			                    	UniAppManager.app.onQueryButtonDown();  
			                	}
			                }
					}
				})
			]},{
				title:'추가정보',
				id: 'search_panel2',
				itemId:'search_panel2',
	    		defaultType: 'uniTextfield',
	    		layout : {type : 'uniTable', columns : 1},
	    		defaultType: 'uniTextfield',
	    		
	    		items:[{
					fieldLabel:'어음번호', 
					xtype: 'uniTextfield',
					name: 'NOTE_NUM_FR'
				},{
					fieldLabel:'~', 
					xtype: 'uniTextfield',
					name: 'NOTE_NUM_TO'
				},{
			 		fieldLabel: '어음종류',
			 		name:'DC_DIVI', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'A058'
		 		},{
		 			fieldLabel: '수취구분',
			 		name:'RECEIPT_DIVI', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'B064'
			 	},{
					xtype: 'uniNumberfield',
					name: 'AMT1',
					fieldLabel:'받을어음금액',
					readOnly:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AMT1', newValue);
						}
					}
				},{
					xtype: 'uniNumberfield',
					name: 'AMT2',
					fieldLabel:'지급어음금액',
					readOnly:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AMT2', newValue);
						}
					}
				},{
					xtype: 'uniNumberfield',
					name: 'AMT3',
					fieldLabel:'합 계',
					readOnly:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AMT3', newValue);
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
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [		    
	    	{ 
		        fieldLabel: '일 자',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_DATE',
				endFieldName:'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_DATE',newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_DATE',newValue);
			    	}   	
			    }
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '일자기준',
				items: [{
						boxLabel: '만기일', 
						width: 65, 
						name: 'ESS',
						inputValue: 'MGDay',
						checked: true  
					},{
						boxLabel : '발행일', 
						width: 65,
						name: 'ESS',
						inputValue: 'BHDay'
					},{
						boxLabel : '전표일', 
						width: 65,
						name: 'ESS',
						inputValue: 'JPDay'
					},{
						boxLabel : '반제일', 
						width: 65,
						name: 'ESS',
						inputValue: 'BJDay'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('ESS').setValue(newValue.ESS);
						}
					}
				},{
                    xtype: 'button',
                    margin:'0 0 0 95',
                    text: '출력', 
                    id: 'PrintGo',
                    width: 100, 
                    handler : function() {
                        var params = {
                            action:'select',
                            'FR_DATE'      : panelSearch.getValue('FR_DATE'),
                            'TO_DATE'      : panelSearch.getValue('TO_DATE'),
                            'ESS'          : Ext.getCmp('basedate').getChecked()[0].inputValue,
                            'AC_CD'        : panelSearch.getValue('AC_CD'),
                            'NOTE_STS'     : panelSearch.getValue('NOTE_STS'),
                            'BANK_CODE'    : panelSearch.getValue('BANK_CODE'),
                            'BANK_NAME'    : panelSearch.getValue('BANK_NAME'),
                            'CUSTOM_CODE'  : panelSearch.getValue('CUSTOM_CODE'),
                            'CUSTOM_NAME'  : panelSearch.getValue('CUSTOM_NAME'),
                            'NOTE_NUM_FR'  : panelSearch.getValue('NOTE_NUM_FR'),
                            'NOTE_NUM_TO'  : panelSearch.getValue('NOTE_NUM_TO'),
                            'DC_DIVI'      : panelSearch.getValue('DC_DIVI'),
                            'RECEIPT_DIVI' : panelSearch.getValue('RECEIPT_DIVI'),
                            'AMT1'         : panelSearch.getValue('AMT1'),
                            'AMT2'         : panelSearch.getValue('AMT2'),
                            'AMT3'         : panelSearch.getValue('AMT3'),
                            'PGM_ID'       : 'afn100skr'
                        }
                        var rec1 = {data : {prgID : 'afn100rkr', 'text':''}};                           
                        parent.openTab(rec1, '/accnt/afn100rkr.do', params);
                    }
                },{	
			 		fieldLabel: '어음구분',
			 		name:'AC_CD', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'A047',
			 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('AC_CD', newValue);
						}
					}
		 		},{
			 		fieldLabel: '어음상태',
			 		name:'NOTE_STS', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'A063',
					colspan:3,
			 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('NOTE_STS', newValue);
						}
					}
		 		},
				Unilite.popup('BANK',{ 
			    	fieldLabel: '은행코드', 
			    	popupWidth: 500,
					autoPopup   : true ,
			    	valueFieldName: 'BANK_CODE',
					textFieldName: 'BANK_NAME',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('BANK_CODE', panelResult.getValue('BANK_CODE'));
								panelSearch.setValue('BANK_NAME', panelResult.getValue('BANK_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('BANK_CODE', '');
							panelSearch.setValue('BANK_NAME', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),   	
				Unilite.popup('CUST',{ 
			    	fieldLabel: '거래처', 
			    	popupWidth: 710,
					allowBlank:true,
					autoPopup:false,
					validateBlank:false,
					colspan:3,
			    	valueFieldName: 'CUSTOM_CODE',
					textFieldName: 'CUSTOM_NAME',
			    	listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('CUSTOM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_NAME', '');
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('CUSTOM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_CODE', '');
								panelSearch.setValue('CUSTOM_CODE', '');
							}
						},
		    			onTextSpecialKey: function(elm, e){
		                    if (e.getKey() == e.ENTER) {
		                    	UniAppManager.app.onQueryButtonDown();  
		                	}
		                }
					}
			}),{
				xtype: 'uniNumberfield',
				name: 'AMT1',
				fieldLabel:'받을어음금액',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AMT1', newValue);
					}
				}
			},{
				xtype: 'uniNumberfield',
				name: 'AMT2',
				fieldLabel:'지급어음금액',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AMT2', newValue);
					}
				}
			},{
				xtype: 'uniNumberfield',
				name: 'AMT3',
				fieldLabel:'합 계',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AMT3', newValue);
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
    
    var masterGrid = Unilite.createGrid('afn100skrGrid1', {
    	layout : 'fit',
        region : 'center',
        excelTitle: '어음명세',
        store : directMasterStore, 
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
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
        columns: [        
        	{dataIndex: 'AC_CD'   			, width: 88 ,locked:true
        	,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
			{dataIndex: 'NOTE_NUM'  		, width: 106,locked:true}, 				
			{dataIndex: 'EXP_DATE'			, width: 88 ,locked:true}, 				
			{dataIndex: 'CUSTOM_CODE' 		, width: 88 ,locked:true}, 				
			{dataIndex: 'CUSTOM_NAME' 		, width: 153,locked:true}, 				
			{dataIndex: 'BANK_CODE' 		, width: 88}, 				
			{dataIndex: 'BANK_NAME'			, width: 153}, 				
			{dataIndex: 'OC_AMT_I'  		, width: 102 , summaryType: 'sum'}, 				
			{dataIndex: 'J_AMT_I'  			, width: 102 , summaryType: 'sum'},
			{dataIndex: 'JAN_AMT_I'  		, width: 102 , summaryType: 'sum'},
			{dataIndex: 'REMARK'            , width: 150},
			{dataIndex: 'NOTE_STS'  		, width: 66}, 				
			{dataIndex: 'PUB_DATE'  		, width: 88}, 
			{dataIndex: 'ACCNT'  			, width: 100},
			{dataIndex: 'ACCNT_NAME'		, width: 100},				
			{dataIndex: 'AC_DATE'  			, width: 80}, 				
			{dataIndex: 'SLIP_NUM'  		, width: 66},
			{dataIndex: 'SLIP_SEQ'  		, width: 43}, 				
			{dataIndex: 'J_DATE'  			, width: 88}, 				
			{dataIndex: 'J_NUM'  			, width: 66}, 				
			{dataIndex: 'J_SEQ'  			, width: 43}, 				
			{dataIndex: 'DC_DIVI'  			, width: 73},
			{dataIndex: 'RECEIPT_DIVI'		, width: 73}, 				
			{dataIndex: 'NOTE_KEEP'  		, width: 66}, 				
			{dataIndex: 'PUB_MAN'  			, width: 153}, 				
			{dataIndex: 'CHECK1'  			, width: 73}, 				
			{dataIndex: 'CHECK2'  			, width: 66}
		
		
		]                 
    });
    
    
	 Unilite.Main( {
	 	border: false,
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
		id : 'afn100skrApp',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			
			var param = {
				"PGM_ID" : 'afn100rkr'
            };
			afn100skrService.UserInfo(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
				    Ext.getCmp('PrintGo').setHidden(false);
				}else{
					Ext.getCmp('PrintGo').setHidden(true);
				}
				
			})
			activeSForm.onLoadSelectText('FR_DATE');
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore.loadStoreRecords();				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};


</script>
