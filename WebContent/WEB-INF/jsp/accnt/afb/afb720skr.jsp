<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb720skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb720skr" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 --> 
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

	var budgNameList = ${budgNameList};
	var bizGubunAllList = ${bizGubunAllList};
	var bizGubunList = [];
	
	var gsDateOpt = '${gsDateOpt}';
	
	var getStDt = ${getStDt};
	
	var bizGubunLinkFlag = '';
	
function appMain() {
	
	var fields	= createModelField(bizGubunAllList);
	var columns	= createGridColumn(bizGubunList);
	
	Unilite.defineModel('Afb720skrModel', {
	   fields:fields
	});		// End of Ext.define('afb720skrModel', {
	  
			
	var directMasterStore = Unilite.createStore('Afb720skrdirectMasterStore',{
		model: 'Afb720skrModel',
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
                read: 'afb720skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();
			param.budgNameInfoList = budgNameList;	// 예산목록
			param.bizGubunInfoList = bizGubunList;
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		
//           		alert('안녕');
           		/*var viewNormal = masterGrid.getView();
           		if(store.getCount() > 0){
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				}else{
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
				}
           		var record = directMasterStore.data.items[0];
           		if(record.data.GUBUN == '1'){
           			
           			
           			
           			draftNo = record.data.DRAFT_NO;
					inI = record.data.IN_I;
					outI = record.data.OUT_I;
					accrueI = record.data.ACCRUE_I;
           			
           			directMasterStore.remove(record);
           		}*/
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
			items: [{ 
	    		fieldLabel: '일자기준',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'FR_DATE',
			    endFieldName: 'TO_DATE',
			    startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
			    allowBlank: false,                	
//			    holdable:'hold',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('FR_DATE', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('TO_DATE', newValue);				    		
			    	}
			    }
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: ' ',
				id:'rdoDateOptPS',
				items: [{
					boxLabel: '전표일', 
					width: 60,
					name: 'DATE_OPT',
					inputValue: '1'
				},{
					boxLabel: '지급일', 
					width: 60,
					name: 'DATE_OPT',
					inputValue: '2',
					checked:true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('DATE_OPT').setValue(newValue.DATE_OPT);					
//							UniAppManager.app.onQueryButtonDown();
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
						popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue('FR_DATE')).substring(0, 4)});
				   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
					}
				}
			}),
			Unilite.popup('AC_PROJECT',{ 
		    	fieldLabel: '프로젝트', 
		    	valueFieldName: 'AC_PROJECT_CODE',
				textFieldName: 'AC_PROJECT_NAME',
				validateBlank:false,
	    		autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('AC_PROJECT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('AC_PROJECT_NAME', newValue);				
					}
				}
			}),
			{
	    		xtype: 'uniCheckboxgroup',	
	    		// padding: '0 0 0 0',
	    		fieldLabel: '조건',
	    		items: [{
	    			boxLabel: '지급건만 조회',
	    			width: 130,
	    			name: 'SEND_CHECK',
	    			inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('SEND_CHECK', newValue);
							
							UniAppManager.app.onQueryButtonDown();
						}
					}
	    		},{
	    			boxLabel: '완결건만 조회',
	    			width: 130,
	    			name: 'APPEND_CHECK',
	    			inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('APPEND_CHECK', newValue);
							
							UniAppManager.app.onQueryButtonDown();
						}
					}
	    		}]
			}]	
		}]
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
    		fieldLabel: '일자기준',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'FR_DATE',
		    endFieldName: 'TO_DATE',
		    startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    allowBlank: false,             
//		    holdable:'hold',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('FR_DATE', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('TO_DATE', newValue);				    		
		    	}
		    }
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '',
			id:'rdoDateOptPR',
			items: [{
				boxLabel: '전표일', 
				width: 60,
				name: 'DATE_OPT',
				inputValue: '1'
			},{
				boxLabel: '지급일', 
				width: 60,
				name: 'DATE_OPT',
				inputValue: '2',
				checked:true
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('DATE_OPT').setValue(newValue.DATE_OPT);					
//							UniAppManager.app.onQueryButtonDown();
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
					popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('FR_DATE')).substring(0, 4)});
			   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
				}
				
			}
		}),
		Unilite.popup('AC_PROJECT',{ 
	    	fieldLabel: '프로젝트', 
	    	valueFieldName: 'AC_PROJECT_CODE',
			textFieldName: 'AC_PROJECT_NAME',
			validateBlank:false,
    		autoPopup:true,
    		colspan:2,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('AC_PROJECT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('AC_PROJECT_NAME', newValue);				
				}
			}
		}),
		{
    		xtype: 'uniCheckboxgroup',	
    		// padding: '0 0 0 0',
    		fieldLabel: '조건',
    		items: [{
    			boxLabel: '지급건만 조회',
    			width: 130,
    			name: 'SEND_CHECK',
    			inputValue: 'Y',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SEND_CHECK', newValue);
						
						UniAppManager.app.onQueryButtonDown();
					}
				}
    		},{
    			boxLabel: '완결건만 조회',
    			width: 130,
    			name: 'APPEND_CHECK',
    			inputValue: 'Y',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('APPEND_CHECK', newValue);
						
						UniAppManager.app.onQueryButtonDown();
					}
				}
    		}]
		}]
	});
	
    /*
	 * Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb720skrGrid', {
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: false, enableGroupingMenu:false
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: false
    		}
    	],
//    	enableColumnHide : false,
//    	sortableColumns: false,
//    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
//        selModel	: 'rowmodel',
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			
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
			items: [{	
				text: '지출결의내역조회 보기',   
				id:'linkAfb700skr',
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		masterGrid.gotoAfb700skr(param.record);
            	}
			}]
	    },
        columns:columns,
		listeners: {
	        itemmouseenter:function(view, record, item, index, e, eOpts )	{  
	        	if(record.get('DIVI') != '3'){
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
        	}
        	
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{ 			
			if(event.position.column.dataIndex != 'DIVI' &&
        	   event.position.column.dataIndex != 'BUDG_CODE' &&
        	   event.position.column.dataIndex != 'BUDG_NAME' &&
        	   event.position.column.dataIndex != 'CODE_LEVEL' &&
        	   event.position.column.dataIndex != 'AMT_TOT'	&&
        	   event.position.column.dataIndex != ''){
	        	bizGubunLinkFlag = event.position.column.dataIndex;
	        	return true;
	        }
      	},
		gotoAfb700skr:function(record)	{
			if(record)	{
		    	var params = {
					action : 'select', 
					'PGM_ID' : 'afb720skr',
					
					'PAY_DATE_FR' : UniDate.getDbDateStr(panelResult.getValue('FR_DATE')).substring(0, 4) 
						 		  + getStDt[0].STDT.substring(4, 6) + '01',
					'PAY_DATE_TO' : UniDate.getDbDateStr(panelResult.getValue('TO_DATE')),
					
					'TRANS_DATE_FR' : Ext.getCmp('rdoDateOptPR').getValue().DATE_OPT != '1' ? UniDate.getDbDateStr(panelResult.getValue('FR_DATE')) : '',
					'TRANS_DATE_TO' : Ext.getCmp('rdoDateOptPR').getValue().DATE_OPT != '1' ? UniDate.getDbDateStr(panelResult.getValue('TO_DATE')) : '',
					
					'TRANS_DATE_FR' : panelResult.getValue('SEND_CHECK') == 'Y' ? UniDate.getDbDateStr(panelResult.getValue('FR_DATE')) : '',
					'TRANS_DATE_TO' : panelResult.getValue('SEND_CHECK') == 'Y' ? UniDate.getDbDateStr(panelResult.getValue('TO_DATE')) : '',
					
					'BUDG_CODE'     : record.get('BUDG_CODE'),
					'BUDG_NAME'     : record.get('BUDG_NAME'),
					
					'BIZ_GUBUN'     : bizGubunLinkFlag,
					
					'AC_PROJECT_CODE' : panelResult.getValue('AC_PROJECT_CODE'),
					'AC_PROJECT_NAME' : panelResult.getValue('AC_PROJECT_NAME'),
					
					'CHECK_FLAG' : panelResult.getValue('APPEND_CHECK') == 'Y' ? '9' : ''
					
				}
		  		var rec1 = {data : {prgID : 'afb700skr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb700skr.do', params);
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
		id : 'Afb720skrApp',
		fnInitBinding : function(params) {
			var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;	// 예산목록
			
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE', UniDate.get('today'));
			panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
			panelSearch.getField('DATE_OPT').setValue('1');		
			panelResult.getField('DATE_OPT').setValue('2');		
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['save','reset'],false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
			
			this.setDefault(params);
		},
		onQueryButtonDown : function()	{			
			if(!this.isValidSearchForm()) return false;		
//				masterGrid.reset();
//				directMasterStore.clearData();
				
				//그리드 컬럼명 조회하여 세팅하는 부분
				
				masterGrid.getEl().mask('컬럼 셋팅중...','loading-indicator');
				var param = Ext.getCmp('resultForm').getValues();
				
				afb720skrService.selectbizGubun(param, function(provider, response) {
					var records = response.result;
	
					//그리드 컬럼명 조건에 맞게 재 조회하여 입력
					var newColumns = createGridColumn(records);
					masterGrid.setConfig('columns',createGridColumn(records));
					
					
					
					bizGubunList = records;
					directMasterStore.loadStoreRecords();
					
//					masterGrid.getStore().loadStoreRecords();
//					if(!Ext.isEmpty(getCostPoolName)){
//						masterGrid.getColumn('COST_POOL').setText(getCostPoolName[0].REF_CODE2);
//					}
					masterGrid.getEl().unmask();
				});
				
//				UniAppManager.setToolbarButtons('reset',true);
			
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		setDefault: function(params){
			
			if(!Ext.isEmpty(params.PAY_DRAFT_NO)){//추후 다시확인
				this.processParams(params);
			}else{
				UniAppManager.app.fnInitInputFields();	
			}
			
		},
		processParams: function(params) {/*
			this.uniOpt.appParams = params;
			
			if(params.PGM_ID == 'afb700skr') {
				detailForm.setValue('PAY_DRAFT_NO',params.PAY_DRAFT_NO);
				this.onQueryButtonDown();
			}else if(params.PGM_ID == 'afb710skr') {
				detailForm.setValue('PAY_DRAFT_NO',params.PAY_DRAFT_NO);
				this.onQueryButtonDown();
			}else if(params.PGM_ID == 'afb555skr') {
				detailForm.setValue('PAY_DRAFT_NO',params.PAY_DRAFT_NO);
				this.onQueryButtonDown();
			}else if(params.PGM_ID == 'agd340ukr') {
				detailForm.setValue('PAY_DRAFT_NO',params.PAY_DRAFT_NO);
				this.onQueryButtonDown();
			}
		*/},
		/**
		 * 입력란의 초기값 설정
		 */
		fnInitInputFields: function(){
			//일자기간
			panelSearch.setValue('FR_DATE',UniDate.get('startOfYear'));
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfYear'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			if(gsDateOpt == '1'){
				panelSearch.getField('DATE_OPT').setValue('1');
				panelResult.getField('DATE_OPT').setValue('1');
			}else{
				panelSearch.getField('DATE_OPT').setValue('2');
				panelResult.getField('DATE_OPT').setValue('2');
			}
			
		}
	});
	
	// 모델필드 생성
	function createModelField(bizGubunAllList) {
		var fields = [
			{name: 'DIVI'					, text: 'DIVI'				, type: 'string'},
			{name: 'BUDG_CODE'				, text: Msg.fSbMsgA0214		, type: 'string'},
			{name: 'BUDG_NAME'				, text: Msg.fSbMsgA0220		, type: 'string'},
			{name: 'CODE_LEVEL'				, text: 'CODE_LEVEL'		, type: 'string'},
			{name: 'AMT_TOT'				, text: Msg.sMAP025			, type: 'string'}
			
	    ];
		Ext.each(bizGubunAllList, function(item, index) {
			var bizGubun = item.BIZ_GUBUN;
			var bizName  = item.BIZ_NAME;
			fields.push({name: item.BIZ_GUBUN, text: item.BIZ_NAME, type:'string' });
		});
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(bizGubunList) {
		var columns = [        
			{dataIndex: 'DIVI'				, text: 'DIVI'			, style: 'text-align: center'	, width: 100,hidden:true},
			{dataIndex: 'BUDG_CODE'			, text: Msg.fSbMsgA0214	, style: 'text-align: center'	, width: 150},
			{dataIndex: 'BUDG_NAME'			, text: Msg.fSbMsgA0220	, style: 'text-align: center'	, width: 350, 
				renderer:function(value){
					return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>";
				}
				/*,renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
						var testVal = val.replace(/ /g,"_");
						
//						var budgName = record.data.BUDG_NAME;
//						var	reVal = budgName.replace(" ","_");
        				return testVal;
        			
	            }*/
			},
			{dataIndex: 'CODE_LEVEL'		, text: 'CODE_LEVEL'	, style: 'text-align: center'	, width: 100,hidden:true}
			
		];
		
		if(!Ext.isEmpty(bizGubunList)){
			Ext.each(bizGubunList, function(item, index) {
				var bizGubun = item.BIZ_GUBUN;
				var bizName  = item.BIZ_NAME;
//				columns.push({dataIndex: bizGubun,		width: 100});	
				columns.push(Ext.applyIf({dataIndex: bizGubun,		width: 150,   text: bizName		, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
			});
		}
		
		columns.push(Ext.applyIf({dataIndex: 'AMT_TOT'	, text: Msg.sMAP025	, style: 'text-align: center'	, width: 120}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
			
		
		return columns;
	}
};


</script>
