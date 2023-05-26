<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb800skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb800skr" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A003"  /> 		<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> 		<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매입일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매출일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 부가세조정입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A156" />			<!-- 부가세생성경로 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var budgNameList = ${budgNameList};
	var fields	= createModelField(budgNameList);
	var columns	= createGridColumn(budgNameList);
	
	Unilite.defineModel('Afb600Model', {
	   fields:fields
	});		// End of Ext.define('afb800skrModel', {
	  
	/* Store 정의(Service 정의) @type
	 */					
	var MasterStore = Unilite.createStore('Afb600MasterStore',{
		model: 'Afb600Model',
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
                read: 'afb800skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;	//예산목록	
			console.log( param );
			this.load({
				params : param
			});
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
						fieldLabel: '수입결의자', 
						valueFieldName: 'DRAFTER',
			    		textFieldName: 'DRAFT_NAME', 
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('DRAFTER', panelSearch.getValue('DRAFTER'));
									panelResult.setValue('DRAFT_NAME', panelSearch.getValue('DRAFT_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('DRAFTER', '');
								panelResult.setValue('DRAFT_NAME', '');
								panelSearch.setValue('DRAFTER', '');
								panelSearch.setValue('DRAFT_NAME', '');
							}
						}
				}),{
					fieldLabel: '문서서식구분',
					name:'ACCNT_GUBUN',	
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'',
	    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT_GUBUN', newValue);
						}
					}
				},{ 
		    		fieldLabel: '수입작성일',
				    xtype: 'uniDateRangefield',
				    startFieldName: 'IN_DATE_FR',
				    endFieldName: 'IN_DATE_TO',
				    allowBlank: false,                	
		            onStartDateChange: function(field, newValue, oldValue, eOpts) {
		            	if(panelSearch) {
							panelResult.setValue('IN_DATE_FR', newValue);
						}
		            },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelSearch) {
				    		panelResult.setValue('IN_DATE_TO', newValue);				    		
				    	}
				    }
				},
				Unilite.popup('BUDG', {
						fieldLabel: '예산과목', 
						valueFieldName: 'BUDG_CODE',
			    		textFieldName: 'BUDG_NAME', 
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('BUDG_CODE', panelSearch.getValue('BUDG_CODE'));
									panelResult.setValue('BUDG_NAME', panelSearch.getValue('BUDG_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('BUDG_CODE', '');
								panelResult.setValue('BUDG_NAME', '');
							},
							applyextparam: function(popup) {							
								popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('IN_DATE_FR')).substring(0, 4)});
//								  	popup.setExtParam({'DEPT_CODE' : panelSearch.getValue('DEPT_CODE')});
							   	popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '1' AND USE_YN = 'Y'"});
							}
						}
				}),{ 
		    		fieldLabel: '수입건명',
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
					items: [{
						boxLabel: '전체', 
						width: 45,
						name: 'STATUS',
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
							UniAppManager.app.onQueryButtonDown();
						}
					}
				},{
		    		xtype: 'uniCheckboxgroup',	
		    		//padding: '0 0 0 0',
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
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        //value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},
			Unilite.popup('DEPT',{ 
		    	fieldLabel: '예산부서', 
		    	valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME'
			}),
			Unilite.popup('PJT',{ 
		    	fieldLabel: '프로젝트', 
		    	valueFieldName: 'PJT_CODE',
				textFieldName: 'PJT_NAME'
			}),
			Unilite.popup('CUST',{ 
		    	fieldLabel: '거래처', 
		    	valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME'
			}),
			Unilite.popup('BANK_BOOK',{ 
		    	fieldLabel: '통장', 
		    	valueFieldName: 'BANK_BOOK_CODE',
				textFieldName: 'BANK_BOOK_NAME'
			}),{
				fieldLabel: '거래처분류',
				name:'AGENT_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'',
    			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}
			},{ 
	    		fieldLabel: '수입결의번호',
			    xtype: 'uniTextfield',
			    name: 'IN_DRAFT_NO'
			},{ 
	    		fieldLabel: '수입일(전표일)',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'SLIP_DATE_FR',
			    endFieldName: 'SLIP_DATE_TO'
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
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [
			Unilite.popup('Employee', {
					fieldLabel: '수입결의자', 
					valueFieldName: 'DRAFTER',
		    		textFieldName: 'DRAFT_NAME', 
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DRAFTER', panelResult.getValue('DRAFTER'));
								panelSearch.setValue('DRAFT_NAME', panelResult.getValue('DRAFT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DRAFTER', '');
							panelSearch.setValue('DRAFT_NAME', '');
							panelResult.setValue('DRAFTER', '');
							panelResult.setValue('DRAFT_NAME', '');
						}
					}
			}),{
				fieldLabel: '문서서식구분',
				name:'ACCNT_GUBUN',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'',
				colspan: 2,
    			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ACCNT_GUBUN', newValue);
					}
				}
			},{ 
	    		fieldLabel: '수입작성일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'IN_DATE_FR',
			    endFieldName: 'IN_DATE_TO',
			    allowBlank: false,                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelSearch.setValue('IN_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('IN_DATE_TO', newValue);				    		
			    	}
			    }
			},
			Unilite.popup('BUDG', {
					fieldLabel: '예산과목', 
					valueFieldName: 'BUDG_CODE',
		    		textFieldName: 'BUDG_NAME', 
					colspan: 2,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('BUDG_CODE', panelResult.getValue('BUDG_CODE'));
								panelSearch.setValue('BUDG_NAME', panelResult.getValue('BUDG_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('BUDG_CODE', '');
							panelSearch.setValue('BUDG_NAME', '');
						},
						applyextparam: function(popup) {							
							popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('IN_DATE_FR')).substring(0, 4)});
//								   	popup.setExtParam({'DEPT_CODE' : panelSearch.getValue('DEPT_CODE')});
						   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '1' AND USE_YN = 'Y'"});
						}
					}
			}),{ 
	    		fieldLabel: '수입건명',
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
				items:[{
					xtype: 'radiogroup',		            		
					fieldLabel: '상태',
					items: [{
						boxLabel: '전체', 
						width: 45,
						name: 'STATUS',
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
							UniAppManager.app.onQueryButtonDown();
						}
					}
				},{
		    		xtype: 'uniCheckboxgroup',	
//			    		padding: '-2 0 0 -100',
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
	
    /* Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb600Grid1', {
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: true
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: true
    		}
    	],
    	layout : 'fit',
        region : 'center',
		store: MasterStore,
        selModel	: 'rowmodel',
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
    		filter: {
				useFilter		: false,
				autoCreate		: false
			}
        },
		tbar: [{
			xtype: 'button',
			id: 'BUTTON',
			text: '자동분개보기',
        	handler: function(grid, record, cellIndex, colName) {
	        	var record = masterGrid.getSelectedRecord();
	        	var count = masterGrid.getStore().getCount();
	        	if(count < 0) {	
	        		Ext.getCmp('BUTTON').setDisabled(true);
	        	} else {
	        		Ext.getCmp('BUTTON').setDisabled(false);
		        	var params = {
						action:'select',
						'AC_DATE' : record.data['SLIP_DATE'],
						'EX_NUM' : record.data['EX_NUM'],
						'INPUT_PATH' : '수입결의자동기표',
						'AP_STS' : record.data['AP_STS'],
						'DIV_CODE' : record.data['DIV_CODE'],
						'DEPT_CODE' : record.data['DEPT_CODE'],
						'DEPT_NAME' : record.data['DEPT_NAME'],
						'CHARG_CODE' : record.data[''],
						'CHARG_NAME' : record.data[''],
						'AC_DATE2' : record.data['EX_DATE'],
						'EX_NUM2' : record.data['EX_NUM'],
						'SLIP_DIVI' : record.data['']
					}
					var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
					parent.openTab(rec1, '/accnt/agj105ukr.do', params);
	        	}
	        }
		}],
        columns:columns,
		listeners: {
	        itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '수입결의등록 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb800(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb800:function(record)	{
			if(record)	{
		    	var params = {
					'PGM_ID'			: 'afb800skr',
					'IN_DRAFT_NO' 		: record.data['IN_DRAFT_NO']
				}
		  		var rec1 = {data : {prgID : 'afb800ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb800ukr.do', params);
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
		id : 'Afb600App',
		fnInitBinding : function() {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('IN_DATE_FR');
			var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;	//예산목록
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('IN_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('IN_DATE_TO', UniDate.get('today'));
			panelResult.setValue('IN_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('IN_DATE_TO', UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			MasterStore.loadStoreRecords();
		}
	});
	
	// 모델필드 생성
	function createModelField(budgNameList) {
		var fields = [
			{name: 'ORDER_SEQ'			, text: '순번'				, type: 'int'},
			{name: 'STATUS'				, text: '상태'				, type: 'string'},
			{name: 'IN_DRAFT_NO'		, text: '수입결의번호'			, type: 'string'},
			{name: 'IN_DATE'			, text: '수입작성일'			, type: 'uniDate'},
			{name: 'SLIP_DATE'			, text: '수입일(전표일)'		, type: 'uniDate'},
			{name: 'TITLE'				, text: '수입건명'				, type: 'string'},
			{name: 'TOT_AMT_I'			, text: '금액'				, type: 'uniPrice'},
			{name: 'BUDG_CODE'			, text: '예산코드'				, type: 'string'},
			// 예산명(쿼리읽어서 컬럼 셋팅)
			{name: 'ACCNT'				, text: '계정코드'				, type: 'string'},
			{name: 'ACCNT_NAME'			, text: '계정과목명'			, type: 'string'},
			{name: 'PJT_NAME'			, text: '프로젝트명'			, type: 'string'},
			{name: 'INOUT_DATE'			, text: '실입금일'				, type: 'uniDate'},
			{name: 'IN_AMT_I'			, text: '수입액'				, type: 'uniPrice'},
			{name: 'CUSTOM_CODE'		, text: '거래처'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명'				, type: 'string'},
			{name: 'AGENT_TYPE'			, text: '거래처분류'			, type: 'string'},
			{name: 'BILL_GUBUN'			, text: '영수구분'				, type: 'string'},
			{name: 'PROOF_DIVI'			, text: '증빙구분'				, type: 'string'},
			{name: 'BILL_DATE'			, text: '계산서일'				, type: 'uniDate'},
			{name: 'BILL_REMARK'		, text: '계산서적요'			, type: 'string'},
			{name: 'ACCNT_GUBUN'		, text: '문서서식구분'			, type: 'string'},
			{name: 'SAVE_CODE'			, text: '입금통장'				, type: 'string'},
			{name: 'SAVE_NAME'			, text: '통장명'				, type: 'string'},
			{name: 'BANK_ACCOUNT'		, text: '계좌번호'				, type: 'string'},
			{name: 'BANK_NAME'			, text: '은행명'				, type: 'string'},
			{name: 'REMARK'				, text: '적요'				, type: 'string'},
			{name: 'IF_CODE'			, text: '예산Mapping항목'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장'				, type: 'string'},
			{name: 'DIV_NAME'			, text: '사업장명'				, type: 'string'},
			{name: 'DEPT_CODE'			, text: '귀속부서'				, type: 'string'},
			{name: 'DEPT_NAME'			, text: '귀속부서명'			, type: 'string'},
			{name: 'EX_DATE'			, text: '결의일자'				, type: 'uniDate'},
			{name: 'EX_NUM'				, text: '번호'				, type: 'int'},
			{name: 'AP_STS'				, text: '승인상태'				, type: 'string'},
			{name: 'GWIF_ID'			, text: '그룹웨어 연동번호'		, type: 'string'},
			{name: 'TYPE_FLAG'			, text: 'TYPE_FLAG'			, type: 'string'}
	    ];
					
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(budgNameList) {
		var columns = [        
        	{dataIndex: 'ORDER_SEQ'						, width: 50},
        	{dataIndex: 'STATUS'						, width: 66},
        	{dataIndex: 'IN_DRAFT_NO'					, width: 100,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            	}
            },
        	{dataIndex: 'IN_DATE'						, width: 80},
        	{dataIndex: 'SLIP_DATE'						, width: 100},
        	{dataIndex: 'TITLE'							, width: 133},
        	{dataIndex: 'TOT_AMT_I'						, width: 100, summaryType: 'sum'},
        	{dataIndex: 'BUDG_CODE'						, width: 133}
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110});	
		});
		columns.push({dataIndex: 'ACCNT'						, width: 73});	
    	columns.push({dataIndex: 'ACCNT_NAME'					, width: 133});	
    	columns.push({dataIndex: 'PJT_NAME'						, width: 133});	
    	columns.push({dataIndex: 'INOUT_DATE'					, width: 80});	
    	columns.push({dataIndex: 'IN_AMT_I'						, width: 100, summaryType: 'sum'});	
    	columns.push({dataIndex: 'CUSTOM_CODE'					, width: 73});	
    	columns.push({dataIndex: 'CUSTOM_NAME'					, width: 200});	
    	columns.push({dataIndex: 'AGENT_TYPE'					, width: 86});	
    	columns.push({dataIndex: 'BILL_GUBUN'					, width: 66});	
    	columns.push({dataIndex: 'PROOF_DIVI'					, width: 86});	
    	columns.push({dataIndex: 'BILL_DATE'					, width: 80});	
    	columns.push({dataIndex: 'BILL_REMARK'					, width: 186});	
    	columns.push({dataIndex: 'ACCNT_GUBUN'					, width: 86});	
    	columns.push({dataIndex: 'SAVE_CODE'					, width: 100});	
    	columns.push({dataIndex: 'SAVE_NAME'					, width: 166});	
    	columns.push({dataIndex: 'BANK_ACCOUNT'					, width: 100});	
    	columns.push({dataIndex: 'BANK_NAME'					, width: 100});	
    	columns.push({dataIndex: 'REMARK'						, width: 100});	
    	columns.push({dataIndex: 'IF_CODE'						, width: 133});	
    	columns.push({dataIndex: 'DIV_CODE'						, width: 66, hidden: true});	
    	columns.push({dataIndex: 'DIV_NAME'						, width: 100, hidden: true});	
    	columns.push({dataIndex: 'DEPT_CODE'					, width: 66, hidden: true});	
    	columns.push({dataIndex: 'DEPT_NAME'					, width: 100, hidden: true});	
    	columns.push({dataIndex: 'EX_DATE'						, width: 80});	
    	columns.push({dataIndex: 'EX_NUM'						, width: 53, format:'0'});	
    	columns.push({dataIndex: 'AP_STS'						, width: 66});	
    	columns.push({dataIndex: 'GWIF_ID'						, width: 120});	
    	columns.push({dataIndex: 'TYPE_FLAG'					, width: 50, hidden: true});	
		return columns;
	}
};


</script>
