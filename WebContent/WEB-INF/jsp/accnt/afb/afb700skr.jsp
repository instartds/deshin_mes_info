<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb700skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb700skr" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A172" />			<!-- 결제방법 --> 
	<t:ExtComboStore comboType="AU" comboCode="A174" />			<!-- 부서구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A170"  /> 		<!-- 예산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A171" /> 		<!-- 문서서식구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />			<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B111" />			<!-- 거래처분류2 -->
	<t:ExtComboStore comboType="AU" comboCode="B112" />			<!-- 거래처분류3 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var budgNameList = ${budgNameList};
	var fields	= createModelField(budgNameList);
	var columns	= createGridColumn(budgNameList);
	
	Unilite.defineModel('Afb700skrModel', {
	   fields:fields
	});		// End of Ext.define('afb700skrModel', {
	  
			
	var directMasterStore = Unilite.createStore('Afb700skrdirectMasterStore',{
		model: 'Afb700skrModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb700skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;	// 예산목록
			this.load({
				params : param
			});
		},
		groupField:'PAY_DRAFT_NO',
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		var recordsFirst = directMasterStore.data.items[0];	
           		if(!Ext.isEmpty(recordsFirst)){
           			Ext.getCmp("btnViewSlip").enable(true);
           		}else{
           			Ext.getCmp("btnViewSlip").disable(true);
           		}
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
		title: '검색조건',
    	width: 360,
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
			items: [
				Unilite.popup('Employee', {
					fieldLabel: '지출작성자', 
					valueFieldName: 'DRAFTER',
		    		textFieldName: 'DRAFT_NAME', 
		    		validateBlank:false,
		    		autoPopup:true,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('DRAFTER', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('DRAFT_NAME', newValue);				
						}
					}
				}),{
					fieldLabel: '결제방법',
					name:'PAY_DIVI',	
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'A172',
	    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('PAY_DIVI', newValue);
						}
					}
				},/*{
				   xtype: 'container',
				   layout: {type : 'uniTable', columns : 1},
				   width:500,
				   tdAttrs: {width:'100%',align : 'left'},
				   id:'hiddenContainerPS',
				   defaults : {enforceMaxLength: true},
//				   colspan: 2,
				   items :[{
						fieldLabel:'비밀번호',
	//					labelWidth:150,
						xtype: 'uniTextfield',
//						id:'passWord',
						name: 'PASSWORD',
						inputType: 'password',
						maxLength : 7,
						holdable: 'hold',
						allowBlank:false
					},{ 
			    		xtype: 'component',  
			    		html:'※ 주민번호 뒤 7자리 입력(비밀번호)',
//			    		id:'hiddenHtml',
			    		style: {
				           marginTop: '3px !important',
				           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
				           color: 'blue'
						},
			    		tdAttrs: {align : 'right'}
					}]
		    	},*/{ 
		    		fieldLabel: '지출작성일',
				    xtype: 'uniDateRangefield',
				    startFieldName: 'PAY_DATE_FR',
				    endFieldName: 'PAY_DATE_TO',
				    startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
				    allowBlank: false,                	
		            onStartDateChange: function(field, newValue, oldValue, eOpts) {
		            	if(panelSearch) {
							panelResult.setValue('PAY_DATE_FR', newValue);
						}
		            },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelSearch) {
				    		panelResult.setValue('PAY_DATE_TO', newValue);				    		
				    	}
				    }
				},
				Unilite.popup('BUDG', {
					fieldLabel: '예산과목', 
					valueFieldName: 'BUDG_CODE',
		    		textFieldName: 'BUDG_NAME', 
					validateBlank:false,
		    		autoPopup:true,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('BUDG_CODE', newValue);
							
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('BUDG_NAME', newValue);	
							
						},
						onSelected: {
							fn: function(records, type) {
								var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
								panelSearch.setValue('BUDG_NAME', records[0][name]);
								panelResult.setValue('BUDG_NAME', records[0][name]);
							}
						},
						onClear: function(type)	{
							panelResult.setValue('BUDG_CODE', '');
							panelResult.setValue('BUDG_NAME', '');
						},
						applyextparam: function(popup) {							
							popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('PAY_DATE_FR')).substring(0, 4)});
	//				   		popup.setExtParam({'DEPT_CODE' : detailForm.getValue('DEPT_CODE')});
					   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
						}
					}
				}),{ 
		    		fieldLabel: '지출건명',
				    xtype: 'uniTextfield',
				    name: 'TITLE',
				    width: 325,	
					listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				    		panelResult.setValue('TITLE', newValue);
				      	}
		     		}
				},{
					xtype: 'radiogroup',		            		
					fieldLabel: '상태',
//					id:'rdoStatusPS',
					items: [{
						boxLabel: '전체', 
						width: 45,
						name: 'STATUS',
						inputValue: '',
						checked: true  
					},{
						boxLabel: '미상신', 
						width: 60,
						name: 'STATUS',
						inputValue: '0'
					},{
						boxLabel: '결재중', 
						width: 60,
						name: 'STATUS',
						inputValue: '1'
					},{
						boxLabel: '반려', 
						width: 45,
						name: 'STATUS',
						inputValue: '5'
					},{
						boxLabel : '완결', 
						width: 45,
						name: 'STATUS',
						inputValue: '9'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('STATUS').setValue(newValue.STATUS);					
//							UniAppManager.app.onQueryButtonDown();
						}
					}
				},{
		    		xtype: 'uniCheckboxgroup',	
		    		// padding: '0 0 0 0',
		    		fieldLabel: ' ',
		    		items: [{
		    			boxLabel: '반려제외',
		    			width: 130,
		    			name: 'STOP_CHECK',
		    			inputValue: '1',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('STOP_CHECK', newValue);
							}
						}
		    		}]
		        }
			]	
		},{
			title: '추가정보',	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        // value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
			},
			Unilite.popup('DEPT',{ 
		    	fieldLabel: '예산부서', 
		    	valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME',
				validateBlank:false,
		    	autoPopup:true
			}),
			Unilite.popup('Employee',{ 
		    	fieldLabel: '사용자', 
		    	valueFieldName: 'PAY_USER',
				textFieldName: 'PAY_USER_NAME',
				validateBlank:false,
		    	autoPopup:true
			}),
			Unilite.popup('CUST',{ 
		    	fieldLabel: '거래처', 
		    	valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				validateBlank:false,
		    	autoPopup:true
			}),
				Unilite.popup('AC_PROJECT',{ 
		    	fieldLabel: '프로젝트', 
		    	valueFieldName: 'AC_PROJECT_CODE',
				textFieldName: 'AC_PROJECT_NAME',
				validateBlank:false,
		    	autoPopup:true
			}),
			Unilite.popup('ACCNT', {
				fieldLabel: '계정과목', 
				valueFieldName: 'ACCNT_CODE', 
				textFieldName: 'ACCNT_NAME',
				validateBlank:false,
		    	autoPopup:true
// popupWidth: 710,
// extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
// 'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"},
			}),
			{
				fieldLabel: '부서구분',
				name:'BIZ_GUBUN',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A174'
			},{
				fieldLabel: '예산구분',
				name:'BUDG_GUBUN',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A170'
			},{ 
	    		fieldLabel: '지출결의번호',
			    xtype: 'uniTextfield',
			    name: 'PAY_DRAFT_NO'
			},{
				fieldLabel: '문서서식구분',
				name:'ACCNT_GUBUN',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A171'
			},{ 
	    		fieldLabel: '예산기안(추산)번호',
			    xtype: 'uniTextfield',
			    name: 'DRAFT_NO'
			},{
				fieldLabel: '거래처분류',
				name:'AGENT_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B055'
			},{ 
	    		fieldLabel: '지출사용일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'PAY_SLIP_DATE_FR',
			    endFieldName: 'PAY_SLIP_DATE_TO'
			},{
				fieldLabel: '거래처분류2',
				name:'AGENT_TYPE2',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B111'
			},{
				fieldLabel: '거래처분류3',
				name:'AGENT_TYPE3',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B112'
			},{ 
	    		fieldLabel: '지급일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'TRANS_DATE_FR',
			    endFieldName: 'TRANS_DATE_TO'
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
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2,
			tableAttrs: { width: '100%'},
        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/align : 'left'/*,width: '100%'*/}
		
		},
		padding:'1 1 1 1',
		border:true,
		items: [
			Unilite.popup('Employee', {
				fieldLabel: '지출작성자', 
				valueFieldName: 'DRAFTER',
	    		textFieldName: 'DRAFT_NAME', 
	    		validateBlank:false,
	    		autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('DRAFTER', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('DRAFT_NAME', newValue);				
					}
				}
			}),{
				fieldLabel: '결제방법',
				name:'PAY_DIVI',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A172',
//				colspan: 2,
    			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PAY_DIVI', newValue);
					}
				}
			},/*{
			   xtype: 'container',
			   layout: {type : 'uniTable', columns : 2},
			   width:500,
			   tdAttrs: {width:'100%',align : 'left'},
			   id:'hiddenContainerPR',
			   defaults : {enforceMaxLength: true},
			   colspan: 2,
			   items :[{
					fieldLabel:'비밀번호',
//					labelWidth:150,
					xtype: 'uniTextfield',
//					id:'passWord',
					name: 'PASSWORD',
					inputType: 'password',
					maxLength : 7,
					holdable: 'hold',
					allowBlank:false
				},{ 
		    		xtype: 'component',  
		    		html:'※ 주민번호 뒤 7자리 입력',
//		    		id:'hiddenHtml',
		    		style: {
			           marginTop: '3px !important',
			           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
			           color: 'blue'
					},
		    		tdAttrs: {align : 'left'}
				}]
	    	},*/{ 
	    		fieldLabel: '지출작성일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'PAY_DATE_FR',
			    endFieldName: 'PAY_DATE_TO',
			    startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
			    allowBlank: false,                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelSearch.setValue('PAY_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('PAY_DATE_TO', newValue);				    		
			    	}
			    }
			},
			Unilite.popup('BUDG', {
				fieldLabel: '예산과목', 
				valueFieldName: 'BUDG_CODE',
	    		textFieldName: 'BUDG_NAME', 
//				colspan: 2,
				validateBlank:false,
	    		autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
					panelSearch.setValue('BUDG_CODE', newValue);
					
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('BUDG_NAME', newValue);	
					
				},
				onSelected: {
					fn: function(records, type) {
						var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
						panelSearch.setValue('BUDG_NAME', records[0][name]);
						panelResult.setValue('BUDG_NAME', records[0][name]);
					}
				},
				onClear: function(type)	{
					panelSearch.setValue('BUDG_CODE', '');
					panelSearch.setValue('BUDG_NAME', '');
				},
				applyextparam: function(popup) {							
					popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue('PAY_DATE_FR')).substring(0, 4)});
//				   		popup.setExtParam({'DEPT_CODE' : detailForm.getValue('DEPT_CODE')});
			   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
				}}
			}),{ 
	    		fieldLabel: '지출건명',
			    xtype: 'uniTextfield',
			    name: 'TITLE',
			    width: 325,	
				listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelSearch.setValue('TITLE', newValue);
			      	}
	     		}
			},{
				xtype: 'container',
				layout : {type : 'uniTable'},
//				id:'rdoStatusPR',
				items:[{
					xtype: 'radiogroup',		            		
					fieldLabel: '상태',
					items: [{
						boxLabel: '전체', 
						width: 45,
						name: 'STATUS',
						inputValue: '',
						checked: true  
					},{
						boxLabel: '미상신', 
						width: 60,
						name: 'STATUS',
						inputValue: '0'
					},{
						boxLabel: '결재중', 
						width: 60,
						name: 'STATUS',
						inputValue: '1'
					},{
						boxLabel: '반려', 
						width: 45,
						name: 'STATUS',
						inputValue: '5'
					},{
						boxLabel : '완결', 
						width: 45,
						name: 'STATUS',
						inputValue: '9'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('STATUS').setValue(newValue.STATUS);					
//							UniAppManager.app.onQueryButtonDown();
						}
					}
				},{
		    		xtype: 'uniCheckboxgroup',	
		    		fieldLabel: '',
		    		items: [{
		    			boxLabel: '반려제외',
		    			width: 130,
		    			name: 'STOP_CHECK',
		    			inputValue: '1',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('STOP_CHECK', newValue);
							}
						}
		    		}]
		        }]
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
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
    /*
	 * Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb700skrGrid', {
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: true//, enableGroupingMenu:false
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: true
    		}
    	],
//    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
        selModel	: 'rowmodel',
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
//    		useGroupSummary		: true,
    		useSqlTotal			: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			},
			state: {
				useState: false,			
				useStateList: false		
			}
        },
        uniRowContextMenu:{
			items: [
	            {	text: '지출결의등록 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb700ukr(param.record);
	            	}
	        	}
	        ]
	    },
		tbar: [{
			xtype: 'button',
			id: 'btnViewSlip',
			text: '자동분개보기',
        	handler: function() {
	        	var record = masterGrid.getSelectedRecord();
			    var params = {
					action:'select',
					'PGM_ID' : 'afb700skr',
					'AC_DATE' : record.data['EX_DATE'],
					'AC_DATE2' : record.data['EX_DATE'],
					'INPUT_PATH' : '80',
					'EX_NUM' : record.data['EX_NUM'],
					'EX_SEQ' : '1',
					'AP_STS' : '',
					'DIV_CODE' : record.data['DIV_CODE']
				}
				var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agj105ukr.do', params);
	        }
		}],
		viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
				if(record.get('TYPE_FLAG') == '1'){
					return 'x-change-cell_dark';	
				}
	        }
	    },
        columns:columns,
		listeners: {
	        itemmouseenter:function(view, record, item, index, e, eOpts )	{  
	        	if(record.get('TYPE_FLAG') == '0'){
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
        	},
	    	selectionchangerecord:function(selected)	{
				if(Ext.isEmpty(selected.data.EX_NUM) || selected.data.EX_NUM == '0'){
					Ext.getCmp("btnViewSlip").disable(true);
				}else{
					Ext.getCmp("btnViewSlip").enable(true);
				}
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{ 
			if(record.get('TYPE_FLAG') == '0'){
      			//menu.showAt(event.getXY());
      			return true;
			}
      	},
		gotoAfb700ukr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 'afb700skr',
					'PAY_DRAFT_NO' : record.data['PAY_DRAFT_NO']
					
					//파라미터 추후 추가
				}
		  		var rec1 = {data : {prgID : 'afb700ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb700ukr.do', params);
			}
    	}
    });   
    
	 Unilite.Main( {
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
		id : 'Afb700skrApp',
		fnInitBinding : function(params) {
			var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;	// 예산목록
			
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DRAFTER');
			
			this.setDefault(params);
		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()) return false;		
				directMasterStore.loadStoreRecords();
			
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked: ", viewLocked);
//			console.log("viewNormal: ", viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		setDefault: function(params){
			
			
			if(!Ext.isEmpty(params.PGM_ID)){
				this.processParams(params);
			}else{
				panelSearch.setValue('PAY_DATE_FR', UniDate.get('startOfMonth'));
				panelSearch.setValue('PAY_DATE_TO', UniDate.get('today'));
				panelResult.setValue('PAY_DATE_FR', UniDate.get('startOfMonth'));
				panelResult.setValue('PAY_DATE_TO', UniDate.get('today'));
			}
//				UniAppManager.app.fnInitInputFields();	

		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params.PGM_ID == 'afb720skr') {
				panelSearch.setValue('PAY_DATE_FR',params.PAY_DATE_FR);
				panelSearch.setValue('PAY_DATE_TO',params.PAY_DATE_TO);
				panelResult.setValue('PAY_DATE_FR',params.PAY_DATE_FR);
				panelResult.setValue('PAY_DATE_TO',params.PAY_DATE_TO);
				
				panelSearch.setValue('TRANS_DATE_FR',params.TRANS_DATE_FR);
				panelSearch.setValue('TRANS_DATE_TO',params.TRANS_DATE_TO);
				
				panelSearch.setValue('BUDG_CODE',params.BUDG_CODE);
				panelSearch.setValue('BUDG_NAME',params.BUDG_NAME);
				panelResult.setValue('BUDG_CODE',params.BUDG_CODE);
				panelResult.setValue('BUDG_NAME',params.BUDG_NAME);
				
				panelSearch.setValue('BIZ_GUBUN',params.BIZ_GUBUN);
				
				panelSearch.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);
				panelSearch.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);
				
				if(params.CHECK_FLAG == '9'){
					panelSearch.getField('STATUS').setValue('9');
					panelResult.getField('STATUS').setValue('9');
				}else{
					panelSearch.getField('STATUS').setValue('');
					panelResult.getField('STATUS').setValue('');
				}
				
				this.onQueryButtonDown();
			}
		}/*,
		*//**
		 * 입력란의 속성 설정 (입력가능여부 등)
		 *//*
		fnInitInputProperties: function() {
			
		}*/
	});
	
	// 모델필드 생성
	function createModelField(budgNameList) {
		var fields = [
			{name: 'TYPE_FLAG'						, text: 'TYPE_FLAG'			, type: 'string'},
			{name: 'ORDER_SEQ'						, text: '순번'				, type: 'int'},
			{name: 'STATUS'							, text: '상태'				, type: 'string'},
			{name: 'PAY_DRAFT_NO'					, text: '지출결의번호'			, type: 'string'},
			{name: 'SEQ'							, text: '순번'				, type: 'string'},
			{name: 'PAY_DATE'						, text: '지출작성일'			, type: 'uniDate'},
			{name: 'PAY_SLIP_DATE'					, text: '지출사용일'			, type: 'uniDate'},
			{name: 'TRANS_DATE'						, text: '지급일'				, type: 'uniDate'},
			{name: 'TITLE'							, text: '지출건명(제목)'		, type: 'string'},
			{name: 'TOT_AMT_I_USE_SUMMARY'			, text: '금액'				, type: 'uniPrice'},
			{name: 'TOTAL_AMT_I'					, text: '금액'				, type: 'uniPrice'},
			{name: 'BUDG_CODE'      				, text: '예산코드'				, type: 'string'},
			// BUDG_NAME
			{name: 'ACCNT'							, text: '계정코드'				, type: 'string'},
			{name: 'ACCNT_NAME'						, text: '계정과목명'			, type: 'string'},
			{name: 'PJT_NAME'           			, text: '프로젝트명'			, type: 'string'},
			{name: 'BIZ_REMARK'						, text: '세부구분적요'			, type: 'string'},
			{name: 'BIZ_GUBUN'						, text: '부서구분'				, type: 'string'},
			{name: 'BUDG_GUBUN'						, text: '예산구분'				, type: 'string'},
			{name: 'ACCNT_GUBUN'					, text: '문서서식구분'			, type: 'string'},
			{name: 'PAY_DIVI'						, text: '결제방법'				, type: 'string'},
			{name: 'PROOF_DIVI'						, text: '증빙구분'				, type: 'string'},
			{name: 'SUPPLY_AMT_I'					, text: '공급가액'				, type: 'uniPrice'},
			{name: 'TAX_AMT_I'						, text: '세액'				, type: 'uniPrice'},
			{name: 'TOT_AMT_I'						, text: '지급액'				, type: 'uniPrice'},
			{name: 'CUSTOM_NAME'					, text: '거래처명'				, type: 'string'},
			{name: 'AGENT_TYPE'						, text: '거래처분류'			, type: 'string'},
			{name: 'AGENT_TYPE2'					, text: '거래처분류2'			, type: 'string'},
			{name: 'AGENT_TYPE3'					, text: '거래처분류3'			, type: 'string'},
			{name: 'IN_BANK_NAME'					, text: '입금은행'				, type: 'string'},
			{name: 'IN_BANKBOOK_NUM'				, text: '입금계좌'				, type: 'string'},
			{name: 'IN_BANKBOOK_NAME'				, text: '예금주명'				, type: 'string'},
			{name: 'INC_AMT_I'						, text: '소득세'				, type: 'uniPrice'},
			{name: 'LOC_AMT_I'						, text: '주민세'				, type: 'uniPrice'},
			{name: 'REAL_AMT_I'						, text: '실지급액'				, type: 'uniPrice'},
			{name: 'EB_YN'							, text: '전자발행'				, type: 'string'},
			{name: 'CRDT_NUM'						, text: '카드코드'				, type: 'string'},
			{name: 'CRDT_NAME'						, text: '법인카드명'			, type: 'string'},
			{name: 'APP_NUM'						, text: '현금영수증'			, type: 'string'},
			{name: 'REASON_CODE'					, text: '불공제사유'			, type: 'string'},
			{name: 'PAY_CUSTOM_CODE'				, text: '지급처코드'			, type: 'string'},
			{name: 'PAY_CUSTOM_NAME'				, text: '지급처명'				, type: 'string'},
			{name: 'SEND_DATE'						, text: '지급예정일'			, type: 'uniDate'},
			{name: 'BILL_DATE'						, text: '계산서/</br>카드승인일'	, type: 'uniDate'},
			{name: 'SAVE_CODE'						, text: '출금통장코드'			, type: 'string'},
			{name: 'SAVE_NAME'						, text: '출금통장명'			, type: 'string'},
			{name: 'OUT_BANKBOOK_NUM'				, text: '출금계좌'				, type: 'string'},
			{name: 'IF_CODE'						, text: '예산 Mapping항목'		, type: 'string'},
			{name: 'DRAFTER'						, text: '지출결의자'			, type: 'string'},
			{name: 'PAY_USER'						, text: '사용자'				, type: 'string'},
			{name: 'DEPT_NAME'						, text: '부서명'				, type: 'string'},
			{name: 'DIV_CODE'						, text: '사업장코드'			, type: 'string'},
			{name: 'DIV_NAME'						, text: '사업장'				, type: 'string'},
			{name: 'SLIP_DATE'						, text: '사용일(전표일)'		, type: 'uniDate'},
			{name: 'EX_DATE'						, text: '결의일자'				, type: 'uniDate'},
			{name: 'EX_NUM'							, text: '결의번호'				, type: 'string'},
			{name: 'AP_STS'							, text: '승인상태'				, type: 'string'},
			{name: 'DRAFT_NO'						, text: '예산기안(추산)번호'		, type: 'string'},
			{name: 'GWIF_ID'						, text: '그룹웨어 연동번호'		, type: 'string'},
			{name: 'PAY_DTL_NO'						, text: '지급명세서번호'			, type: 'string'}
	    ];
					
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(budgNameList) {
		var columns = [        
			{dataIndex: 'TYPE_FLAG'							, width: 88,hidden:true},   
        	{dataIndex: 'ORDER_SEQ'							, width: 66,
        		renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if (val == 0){
                        return '';
                    }else{
                    	return val;
                    }
                }
        	},        
        	{dataIndex: 'STATUS'							, width: 88,align:'center'},        
        	{dataIndex: 'PAY_DRAFT_NO'						, width: 120,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            	},
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if (val == ''){
                        return '합계';
                    }else{
                    	return val;
                    }
                }
        	},        
        	{dataIndex: 'SEQ'								, width: 88,hidden:true},        
        	{dataIndex: 'PAY_DATE'							, width: 88},        
        	{dataIndex: 'PAY_SLIP_DATE'						, width: 88},        
        	{dataIndex: 'TRANS_DATE'						, width: 88},        
        	{dataIndex: 'TITLE'								, width: 200},     
        	{dataIndex: 'TOT_AMT_I_USE_SUMMARY'				, text: '금액', width: 88,summaryType: 'sum'},	
        	{dataIndex: 'TOTAL_AMT_I'						, width: 100,hidden:true},        
        	{dataIndex: 'BUDG_CODE'    						, width: 130}
		];
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110});	
		});
		columns.push({dataIndex: 'ACCNT'					, width: 88});
		columns.push({dataIndex: 'ACCNT_NAME'				, width: 120});
		columns.push({dataIndex: 'PJT_NAME'           		, width: 120});
		columns.push({dataIndex: 'BIZ_REMARK'				, width: 120});
		columns.push({dataIndex: 'BIZ_GUBUN'				, width: 120});
		columns.push({dataIndex: 'BUDG_GUBUN'				, width: 88});
		columns.push({dataIndex: 'ACCNT_GUBUN'				, width: 88});
		columns.push({dataIndex: 'PAY_DIVI'					, width: 88});
		columns.push({dataIndex: 'PROOF_DIVI'				, width: 120});
		columns.push({dataIndex: 'SUPPLY_AMT_I'				, width: 88,summaryType: 'sum'});
		columns.push({dataIndex: 'TAX_AMT_I'				, width: 88,summaryType: 'sum'});
		columns.push({dataIndex: 'TOT_AMT_I'				, width: 88,summaryType: 'sum'});
		columns.push({dataIndex: 'CUSTOM_NAME'				, width: 130});
		columns.push({dataIndex: 'AGENT_TYPE'				, width: 88});
		columns.push({dataIndex: 'AGENT_TYPE2'				, width: 88});
		columns.push({dataIndex: 'AGENT_TYPE3'				, width: 88});
		columns.push({dataIndex: 'IN_BANK_NAME'				, width: 88});
		columns.push({dataIndex: 'IN_BANKBOOK_NUM'			, width: 110});
		columns.push({dataIndex: 'IN_BANKBOOK_NAME'			, width: 120});
		columns.push({dataIndex: 'INC_AMT_I'				, width: 88,summaryType: 'sum'});
		columns.push({dataIndex: 'LOC_AMT_I'				, width: 88,summaryType: 'sum'});
		columns.push({dataIndex: 'REAL_AMT_I'				, width: 88,summaryType: 'sum'});
		columns.push({dataIndex: 'EB_YN'					, width: 88,align:'center'});
		columns.push({dataIndex: 'CRDT_NUM'					, width: 88,hidden:true});
		columns.push({dataIndex: 'CRDT_NAME'				, width: 150});
		columns.push({dataIndex: 'APP_NUM'					, width: 88});
		columns.push({dataIndex: 'REASON_CODE'				, width: 120});
		columns.push({dataIndex: 'PAY_CUSTOM_CODE'			, width: 88});
		columns.push({dataIndex: 'PAY_CUSTOM_NAME'			, width: 130});
		columns.push({dataIndex: 'SEND_DATE'				, width: 88});
		columns.push({dataIndex: 'BILL_DATE'				, width: 88});
		columns.push({dataIndex: 'SAVE_CODE'				, width: 88});
		columns.push({dataIndex: 'SAVE_NAME'				, width: 88});
		columns.push({dataIndex: 'OUT_BANKBOOK_NUM'			, width: 88});
		columns.push({dataIndex: 'IF_CODE'					, width: 120});
		columns.push({dataIndex: 'DRAFTER'					, width: 88});
		columns.push({dataIndex: 'PAY_USER'					, width: 88});
		columns.push({dataIndex: 'DEPT_NAME'				, width: 88});
		columns.push({dataIndex: 'DIV_CODE'					, width: 88,hidden:true});
		columns.push({dataIndex: 'DIV_NAME'					, width: 120});
		columns.push({dataIndex: 'SLIP_DATE'				, width: 100});
		columns.push({dataIndex: 'EX_DATE'					, width: 88});
		columns.push({dataIndex: 'EX_NUM'					, width: 88,
			renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if (val == 0){
                        return '';
                    }else{
                    	return val;
                    }
                }
		});
		columns.push({dataIndex: 'AP_STS'					, width: 88});
		columns.push({dataIndex: 'DRAFT_NO'					, width: 120});
		columns.push({dataIndex: 'GWIF_ID'					, width: 120});
		columns.push({dataIndex: 'PAY_DTL_NO'				, width: 120});
		return columns;
	}
};


</script>
