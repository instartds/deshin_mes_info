<%@page language="java" contentType="text/html; charset=utf-8"%> 
	<t:appConfig pgmId="afb540ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A128" /> <!-- 예산과목구분 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" />			<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A133" />			<!-- 전용구분 -->
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	var getStDt 	 = ${getStDt};
	var budgNameList = ${budgNameList};
	var fields		 = createModelField(budgNameList);
	var columns		 = createGridColumn(budgNameList);
	var fields2		 = createModelField2(budgNameList);
	var columns2	 = createGridColumn2(budgNameList);

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb540ukrService.selectList',
			update: 'afb540ukrService.updateDetail',
			syncAll: 'afb540ukrService.saveAll'
		}
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx340Model', {
	   fields:fields
	});		// End of Ext.define('Atx340ukrModel', {
	
	Unilite.defineModel('Atx340Model2', {
	   fields:fields2
	});
	
	var directMasterStore = Unilite.createStore('atx340MasterStore1',{
		model: 'Atx340Model',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;		//예산목록	
			console.log( param );
			this.load({
				params : param
			});			
		},
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect(config);
			}
		}
	});
	
	var directMasterStore2 = Unilite.createStore('atx340MasterStore2',{
		model: 'Atx340Model2',
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
            	   read: 'afb540ukrService.selectList2'                	
            }
        },
        loadStoreRecords: function(param) {
        	if(param)	{
        		param.budgNameInfoList = budgNameList;		//예산목록	
				console.log( param );
				this.load({
					params : param
				});
			}	
		},
		listeners:{
			beforeload:function(store, operation, eOpts)	{
				if (masterGrid.getSelectedRecords() == 0)	{
					return false;
				}
			}
		}
	});
	
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
			items: [{ 
					fieldLabel: '예산년월',
		 		    xtype: 'uniMonthRangefield',
		            startFieldName: 'FR_BUDG_YYYYMM',
		            endFieldName: 'TO_BUDG_YYYYMM',
			        startDD: 'first',
			        endDD: 'last',
		            allowBlank: false,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
		            	if(panelResult) {
							panelResult.setValue('FR_BUDG_YYYYMM',newValue);
		            	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TO_BUDG_YYYYMM',newValue);
				    	}
				    }
				},
		         Unilite.popup('BUDG',{
				        fieldLabel: '예산과목',
					    valueFieldName:'BUDG_CODE',
					    textFieldName:'BUDG_NAME',
				        //validateBlank:false,
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
								panelSearch.setValue('BUDG_CODE', '');
								panelSearch.setValue('BUDG_NAME', '');
							}
						}
			    }),{
		            xtype: 'uniCombobox',
		            name: 'DIVERT_DIVI',
		            fieldLabel: '전용구분',
		            comboType:'AU',
					comboCode:'A133',
		            listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIVERT_DIVI', newValue);
						}
					}
		         },{ 
					fieldLabel: '입력일',
			        xtype: 'uniDateRangefield',
			        startFieldName: 'FR_DATE',
			        endFieldName: 'TO_DATE',
			        width: 470,
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
		         Unilite.popup('DEPT',{
				        fieldLabel: '부서',
					    valueFieldName:'DEPT_CODE',
					    textFieldName:'DEPT_NAME',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
									panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('DEPT_CODE', '');
								panelResult.setValue('DEPT_NAME', '');
								panelSearch.setValue('DEPT_CODE', '');
								panelSearch.setValue('DEPT_NAME', '');
							}
						}
			    }),{
		            xtype: 'uniCombobox',
		            name: 'SP_STS',
		            fieldLabel: '승인여부',
		            comboType:'AU',
					comboCode:'M007',
					value: '1',
		            listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('SP_STS', newValue);
						}
					}
		         },{ 
	    			fieldLabel: '당기시작년월',
	    			name:'ST_DATE',
					xtype: 'uniTextfield',
					holdable:'hold',
					hidden: true,
					width: 200
				}
			]
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
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	items: [{ 
				fieldLabel: '예산년월',
	 		    xtype: 'uniMonthRangefield',
	            startFieldName: 'FR_BUDG_YYYYMM',
	            endFieldName: 'TO_BUDG_YYYYMM',
		        startDD: 'first',
		        endDD: 'last',
	            allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('FR_BUDG_YYYYMM',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_BUDG_YYYYMM',newValue);
			    	}
			    }
			},
	         Unilite.popup('BUDG',{
			        fieldLabel: '예산과목',
				    valueFieldName:'BUDG_CODE',
				    textFieldName:'BUDG_NAME',
			        //validateBlank:false,
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
							panelResult.setValue('BUDG_CODE', '');
							panelResult.setValue('BUDG_NAME', '');
						}
					}
		    }),{
	            xtype: 'uniCombobox',
	            name: 'DIVERT_DIVI',
	            fieldLabel: '전용구분',
	            comboType:'AU',
				comboCode:'A133',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIVERT_DIVI', newValue);
					}
				}
	         },{ 
				fieldLabel: '입력일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_DATE',
		        endFieldName: 'TO_DATE',
//		        startDate: UniDate.get('startOfMonth'),
//		        endDate: UniDate.get('today'),
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelSearch.setValue('FR_DATE',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('TO_DATE',newValue);
			    	}
			    }
	        },
	         Unilite.popup('DEPT',{
			        fieldLabel: '부서',
				    valueFieldName:'DEPT_CODE',
				    textFieldName:'DEPT_NAME',
			        //validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
								panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
						}
					}
		    }),{
	            xtype: 'uniCombobox',
	            name: 'SP_STS',
	            fieldLabel: '승인여부',
	            comboType:'AU',
				comboCode:'M007',
				value: '1',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SP_STS', newValue);
					}
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
	
	var masterGrid = Unilite.createGrid('atx340Grid1', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	
    		showSummaryRow: false
    	}],
    	tbar: [{
        	text:'전체선택',
        	handler: function() {
        		directMasterStore.rejectChanges( );
        		Ext.each(directMasterStore.data.items, function(item, idx){
        			item.set('CHOICE', true);
        		})
        	}
        },{
        	text:'취소',
        	handler: function() {
        		directMasterStore.rejectChanges( );
        		Ext.each(directMasterStore.data.items, function(item, idx){
        			item.set('CHOICE', false);
        		})
        	}
        }],
    	//selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: false, toggleOnClick: true}),
    	uniOpt: {						
			useMultipleSorting	: true,			
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: true,				
		    dblClickToEdit		: false,			
		    useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: true,			
			useRowContext		: false,		
		    filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}
        },
        columns:columns,
        listeners: {
        	selectionchange: function( grid, selected, eOpts) {
        		if(selected && selected.length == 1)	{
	        		var param = {
	        			'BUDG_YYYYMM'		: selected[selected.length-1].get('BUDG_YYYYMM'),
	        			'DEPT_CODE'			: selected[selected.length-1].get('DEPT_CODE'),
	        			'BUDG_CODE'			: selected[selected.length-1].get('BUDG_CODE'),
	        			'DIVERT_YYYYMM'		: selected[selected.length-1].get('DIVERT_YYYYMM'),
	        			'DIVERT_DIVI'		: selected[selected.length-1].get('DIVERT_DIVI'),
	        			'INSERT_DB_NAME'	: selected[selected.length-1].get('INSERT_DB_NAME'),
	        			'INSERT_DB_DATE'	: UniDate.getDateStr(selected[selected.length-1].get('INSERT_DB_DATE'))
	        		}
	        		directMasterStore2.loadStoreRecords(param);
        		}
        	},
        	beforeedit:function( editor, context, eOpts )	{
        		if(context.field == 'CHOICE')	{
        			return false;
        		}
        		if(!context.record.get('CHOICE'))	{
        			return false;
        		}
        	}
        }
    });
    
    var masterGrid2 = Unilite.createGrid('atx340Grid2', {
    	layout : 'fit',
        region : 'south',
		store: directMasterStore2,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	
    		dock: 'top',
    		showSummaryRow: false
    	}],
    	uniOpt: {						
			useMultipleSorting	: true,			
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: true,				
		    dblClickToEdit		: false,			
		    useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: true,			
			useRowContext		: false,		
		    filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}
        },
        columns:columns2
    });
    
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, masterGrid2, panelResult
			]	
		}		
		, panelSearch
		],
		id  : 'afb540ukrApp',
		fnInitBinding : function() {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_BUDG_YYYYMM');
			panelSearch.setValue('ST_DATE',getStDt[0].STDT.substring(0, 4));
			panelSearch.setValue('FR_BUDG_YYYYMM', UniDate.get('startOfMonth'));
			panelResult.setValue('FR_BUDG_YYYYMM', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_BUDG_YYYYMM', UniDate.get('endOfMonth'));
			panelResult.setValue('TO_BUDG_YYYYMM', UniDate.get('endOfMonth'));						
			UniAppManager.setToolbarButtons('reset', false);	
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}	
			directMasterStore.loadStoreRecords();				
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			directMasterStore.removeAll();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {				
			directMasterStore.saveStore(config);
			directMasterStore.loadStoreRecords();
		}

	});

	Unilite.createValidator('validator01', {
		forms: {'formA:':panelSearch},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
			
			}
			return rv;
		}
	});	
	
	// 모델필드 생성
	function createModelField(budgNameList) {
		var fields = [
			{name: 'CHOICE'				, text: '선택'					, type: 'boolean'},
			{name: 'AP_STS'				, text: '구분'					, type: 'string', comboType: 'AU', comboCode: 'M007'},
			{name: 'DIVERT_DIVI'		, text: '전용구분'					, type: 'string', comboType: 'AU', comboCode: 'A133'},
			{name: 'BUDG_YYYYMM'		, text: '예산년월'					, type: 'string'},
			{name: 'BUDG_CODE'			, text: '예산코드'					, type: 'string'},
			// 예산과목명
			{name: 'DIVERT_BUDG_I'		, text: '전용금액'					, type: 'uniPrice'},
			{name: 'DEPT_CODE'			, text: '부서코드'					, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서명'					, type: 'string'},
			{name: 'INSERT_DB_USER'		, text: '입력자'					, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '입력일'					, type: 'uniDate'},
			{name: 'INSERT_DB_NAME'		, text: '입력자'					, type: 'string'},
			{name: 'INSERT_DB_DATE'		, text: '입력일'					, type: 'uniDate'},
			{name: 'AP_USER_ID'			, text: '승인자'					, type: 'string'},
			{name: 'AP_DATE'			, text: '승인일'					, type: 'uniDate'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'				, type: 'string'},
			{name: 'DIVERT_YYYYMM'		, text: '전용월'					, type: 'string'}
	    ];
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_L'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		console.log(fields);
		return fields;
	}
	
	// 모델필드 생성
	function createModelField2(budgNameList) {
		var fields = [
			{name: 'AP_DATE'				, text: '전용년월'					, type: 'string'},
			{name: 'DIVERT_BUDG_CODE'		, text: '전용과목'					, type: 'string'},
			// 예산과목명
			{name: 'DIVERT_DEPT_CODE'		, text: '전용부서'					, type: 'string'},
			{name: 'DIVERT_DEPT_NAME'		, text: '전용부서명'				, type: 'string'},
			{name: 'DIVERT_BUDG_I'			, text: '전용금액'					, type: 'uniPrice'},
			{name: 'REMARK'					, text: '비고'					, type: 'string'},
			{name: 'SEQ'					, text: '순번'					, type: 'string'}
	    ];
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_L'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(budgNameList) {
		var columns = [        
        	{dataIndex: 'CHOICE'			, width: 50, xtype : 'checkcolumn'},
        	{dataIndex: 'AP_STS'			, width: 88},
        	{dataIndex: 'DIVERT_DIVI'		, width: 88},
        	{dataIndex: 'BUDG_YYYYMM'		, width: 88, align: 'center'},
        	{dataIndex: 'BUDG_CODE'			, width: 88, hidden: true}
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_L'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110});	
		});
		columns.push({dataIndex: 'DIVERT_BUDG_I'	   , width: 106}); 	
		columns.push({dataIndex: 'DEPT_CODE'		   , width: 106, hidden: true}); 	
		columns.push({dataIndex: 'DEPT_NAME'		   , width: 106}); 	
		columns.push({dataIndex: 'INSERT_DB_USER'	   , width: 106}); 	
		columns.push({dataIndex: 'INSERT_DB_TIME'	   , width: 106}); 	
		columns.push({dataIndex: 'INSERT_DB_NAME'	   , width: 106, hidden: true});	
		columns.push({dataIndex: 'INSERT_DB_DATE'	   , width: 106, hidden: true});
		columns.push({dataIndex: 'AP_USER_ID'		   , width: 106});
		columns.push({dataIndex: 'AP_DATE'		       , width: 106}); 	
		columns.push({dataIndex: 'COMP_CODE'		   , width: 106, hidden: true}); 	
		columns.push({dataIndex: 'DIVERT_YYYYMM'	   , width: 106, hidden: true, align: 'center'}); 
		return columns;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn2(budgNameList) {
		var columns = [        
        	{dataIndex: 'AP_DATE'						, width: 80, align: 'center'},
        	{dataIndex: 'DIVERT_BUDG_CODE'				, width: 133}
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_L'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110});	
		});
		columns.push({dataIndex: 'DIVERT_DEPT_CODE'	    , width: 80}); 	
		columns.push({dataIndex: 'DIVERT_DEPT_NAME'	    , width: 133}); 	
		columns.push({dataIndex: 'DIVERT_BUDG_I'		, width: 100}); 	
		columns.push({dataIndex: 'REMARK'				, width: 106, flex: 1}); 	
		columns.push({dataIndex: 'SEQ'				    , width: 106, hidden: true}); 	
		return columns;
	}
};


</script>
