<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afn100skr_yg"  >
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
	Unilite.defineModel('s_afn100skr_ygModel', {
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
	var directMasterStore = Unilite.createStore('s_afn100skr_ygMasterStore1',{
		model: 's_afn100skr_ygModel',
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
                read: 's_afn100skr_ygService.selectList'                	
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
				id: 'RDO_SELECT',
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
						autoPopup   : true ,
				    	valueFieldName: 'CUSTOM_CODE',
						textFieldName: 'CUSTOM_NAME',
				    	listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
									panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
							},
							applyextparam: function(popup){							
								//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							},
			    			onTextSpecialKey: function(elm, e){
			                    if (e.getKey() == e.ENTER) {
			                    	UniAppManager.app.onQueryButtonDown();  
			                	}
			                }
					}
				}),
				Unilite.popup('ACCNT',{
			    	fieldLabel: '계정과목',  
					autoPopup: true, 
					hidden : true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
								panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));
								/**
								 * 계정과목 동적 팝업
								 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
								 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
								 *  valueFieldName    textFieldName 		valueFieldName     textFieldName		 	valueFieldName    textFieldName
								 *    PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	   BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
								 * ---------------------------------------------------------------------------------------------------------------------------
								 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
								 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
								 *    PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
								 * */
//								var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
//								accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
//									var dataMap = provider;
//									var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
//									UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);								
//									UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
//								});
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ACCNT_CODE', '');
							panelResult.setValue('ACCNT_NAME', '');
							/**
							 * onClear시 removeField..
							 */
//							UniAccnt.removeField(panelSearch, panelResult);
						},
						applyextparam: function(popup){							
							popup.setExtParam({
								'ADD_QUERY': "GROUP_YN = 'N' AND SPEC_DIVI IN ('D1', 'D2', 'D3')"
							});
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
				colspan:3,
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
					autoPopup   : true ,
			    	valueFieldName: 'CUSTOM_CODE',
					textFieldName: 'CUSTOM_NAME',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						},
		    			onTextSpecialKey: function(elm, e){
		                    if (e.getKey() == e.ENTER) {
		                    	UniAppManager.app.onQueryButtonDown();  
		                	}
		                }
					}
			}),
			Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',  
				autoPopup: true,
				hidden : true,
				colspan:2,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));
							/**
							 * 계정과목 동적 팝업
							 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
							 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
							 *  valueFieldName    textFieldName 		valueFieldName     textFieldName		 	valueFieldName    textFieldName
							 *    PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	   BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
							 * -------------------------------------------------------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
							 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
							 *    PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
							 * */
//							var param = {ACCNT_CD : panelResult.getValue('ACCNT_CODE')};
//							accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
//								var dataMap = provider;
//								var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용						
//								UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
//								UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);
//							});
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
						/**
						 * onClear시 removeField..
						 */
//						UniAccnt.removeField(panelSearch, panelResult);
					},
					applyextparam: function(popup){							
						popup.setExtParam({
							'ADD_QUERY': "GROUP_YN = 'N' AND SPEC_DIVI IN ('D1', 'D2', 'D3')"
						});
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
    
    var masterGrid = Unilite.createGrid('s_afn100skr_ygGrid1', {
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
        
        tbar: [{
            text:'출력',
            handler: function() {
                var params = {
                  action:'select',
                    'PGM_ID'       : 's_afn100skr_yg',
                    'FR_DATE'      : panelResult.getValue('FR_DATE'),
                    'TO_DATE'      : panelResult.getValue('TO_DATE'),
                    'ESS'          : Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
                    'AC_CD'        : panelResult.getValue('AC_CD'),
                    'NOTE_STS'     : panelResult.getValue('NOTE_STS'),
                    'BANK_CODE'    : panelResult.getValue('BANK_CODE'),
                    'BANK_NAME'    : panelResult.getValue('BANK_NAME'),
                    'CUSTOM_CODE'  : panelResult.getValue('CUSTOM_CODE'),
                    'CUSTOM_NAME'  : panelResult.getValue('CUSTOM_NAME'),
                    'NOTE_NUM_FR'  : panelSearch.getValue('NOTE_NUM_FR'),
                    'NOTE_NUM_TO'  : panelSearch.getValue('NOTE_NUM_TO'),
                    'DC_DIVI'      : panelSearch.getValue('DC_DIVI'),
                    'RECEIPT_DIVI' : panelSearch.getValue('RECEIPT_DIVI')
                    
                }
                //전송
                var rec1 = {data : {prgID : 'afn100rkr', 'text':''}};                           
                parent.openTab(rec1, '/accnt/afn100rkr.do', params);    
            }
        }],
        
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
			{dataIndex: 'ACCNT'  			, width: 100, hidden:true},
			{dataIndex: 'ACCNT_NAME'		, width: 100, hidden:true},				
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
		id : 's_afn100skr_ygApp',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
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
