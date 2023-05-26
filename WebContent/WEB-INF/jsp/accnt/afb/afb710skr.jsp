<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb710skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb710skr" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 --> 
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
var draftNo = '';
var inI = '';
var outI ='';
var accrueI = '';


function appMain() {
	var budgNameList = ${budgNameList};
	var fields	= createModelField(budgNameList);
	var columns	= createGridColumn(budgNameList);
	
	Unilite.defineModel('Afb710skrModel', {
	   fields:fields
	});		// End of Ext.define('afb710skrModel', {
	  
			
	var directMasterStore = Unilite.createStore('Afb710skrdirectMasterStore',{
		model: 'Afb710skrModel',
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
                read: 'afb710skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;	// 예산목록
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		var viewNormal = masterGrid.getView();
           		if(store.getCount() > 0){
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				}else{
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
				}
				
				if(directMasterStore.count() != 0){
	           		var record = directMasterStore.data.items[0];
	           		if(record.data.GUBUN == '1'){
	           			
	           			
	           			
	           			draftNo = record.data.DRAFT_NO;
						inI = record.data.IN_I;
						outI = record.data.OUT_I;
						accrueI = record.data.ACCRUE_I;
	           			
	           			directMasterStore.remove(record);
	           		}
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
			items: [{ 
	    		fieldLabel: '일자기준',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'FR_AC_DATE',
			    endFieldName: 'TO_AC_DATE',
			    startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
			    allowBlank: false,                	
//			    holdable:'hold',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('FR_AC_DATE', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('TO_AC_DATE', newValue);				    		
			    	}
			    }
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: ' ',
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
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
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
						popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue('FR_AC_DATE')).substring(0, 4)});
					}
				}
			})]	
		},{
			title: '추가정보',	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [
				Unilite.treePopup('DEPTTREE',{
					fieldLabel: '부서',
					valueFieldName:'DEPT',
					textFieldName:'DEPT_NAME' ,
					valuesName:'DEPTS' ,
					DBvalueFieldName:'TREE_CODE',
					DBtextFieldName:'TREE_NAME',
					selectChildren:true,
					textFieldWidth:89,
					width:300,
					validateBlank:false,
					autoPopup:true,
					useLike:true
				}),
				{
					fieldLabel: '수지구분',
					name:'BUDG_TYPE',	
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'A132'
				},{
		    		xtype: 'uniCheckboxgroup',	
		    		fieldLabel: '조건',
		    		items: [{
		    			boxLabel: '지급건만 조회',
		    			width: 130,
		    			name: 'SEND_CHK',
		    			inputValue: 'Y'
		    		},{
		    			boxLabel: '완결건만 조회',
		    			width: 130,
		    			name: 'APPEND_CHK',
		    			inputValue: 'Y'
		    		}]
		        },
		        Unilite.popup('Employee',{ 
		    		fieldLabel: '추산작성자', 
			    	valueFieldName: 'DRAFTER_PN',
					textFieldName: 'DRAFTER_NM',
					validateBlank:false,
			    	autoPopup:true
				}),
				Unilite.popup('Employee',{ 
		    		fieldLabel: '지출작성자', 
			    	valueFieldName: 'PAYDRAFTER_PN',
					textFieldName: 'PAYDRAFTER_NM',
					validateBlank:false,
			    	autoPopup:true
				})
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
		     	}else {
						//this.mask();
						var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
								
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC && popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
								
								var popupTFC = item.up('uniTreePopupField')	;							
								if(popupTFC && popupTFC.holdable == 'hold') {
									popupTFC.setReadOnly(true);
								}
								
								
							}
						})
	   				}
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
		items: [{ 
    		fieldLabel: '일자기준',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'FR_AC_DATE',
		    endFieldName: 'TO_AC_DATE',
		    startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    allowBlank: false,             
//		    holdable:'hold',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('FR_AC_DATE', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('TO_AC_DATE', newValue);				    		
		    	}
		    }
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '',
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
		},{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        value:UserInfo.divCode,
	        comboType:'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
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
					popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('FR_AC_DATE')).substring(0, 4)});
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
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	}else {
						//this.mask();
						var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
								
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC && popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
								
								var popupTFC = item.up('uniTreePopupField')	;							
								if(popupTFC && popupTFC.holdable == 'hold') {
									popupTFC.setReadOnly(true);
								}
								
								
							}
						})
	   				}
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
    var masterGrid = Unilite.createGrid('Afb710skrGrid', {
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: false, enableGroupingMenu:false
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: true
    		}
    	],
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
			expandLastColumn	: false,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        uniRowContextMenu:{
			items: [{	
				text: '지출결의등록 보기',   
				id:'linkAfb700ukr',
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		masterGrid.gotoAfb700ukr(param.record);
            	}
	        },{	
        		text: '수입결의등록 보기',   
        		id:'linkAfb800ukr',
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		masterGrid.gotoAfb800ukr(param.record);
            	}
        	}
	        ]
	    },
		viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
				if(record.get('GUBUN') == '3' || record.get('GUBUN') == '4'){
					return 'x-change-cell_Background_light_Text_blue';	
				}else if(record.get('GUBUN') == '5'){
					return 'x-change-cell_Background_normal_Text_blue';	
				}
	        }
	    },
        columns:columns,
		listeners: {
	        itemmouseenter:function(view, record, item, index, e, eOpts )	{  
	        	if(record.get('GUBUN') == '2'){
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
        	}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{ 
			if(record.get('GUBUN') == '2'){
      			if(record.get('BUDG_TYPE') == '1'){
					menu.down('#linkAfb700ukr').hide();
					menu.down('#linkAfb800ukr').show();
				}else if(record.get('BUDG_TYPE') == '2'){
					menu.down('#linkAfb800ukr').hide();
					menu.down('#linkAfb700ukr').show();
				}
      			return true;
			}
      	},
		gotoAfb700ukr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 'afb710skr',
					'PAY_DRAFT_NO' : record.data['DRAFT_NO']
					//파라미터 추후 추가
				}
		  		var rec1 = {data : {prgID : 'afb700ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb700ukr.do', params);
			}
    	},
    	gotoAfb800ukr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 'afb710skr',
					'PAY_DRAFT_NO' : record.data['DRAFT_NO']
					//파라미터 추후 추가
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
		id : 'Afb710skrApp',
		fnInitBinding : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;	// 예산목록
			
			panelSearch.setValue('FR_AC_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_AC_DATE', UniDate.get('today'));
			panelResult.setValue('FR_AC_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('TO_AC_DATE', UniDate.get('today'));
			panelSearch.getField('DATE_OPT').setValue('1');		
			panelResult.getField('DATE_OPT').setValue('2');		
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_AC_DATE');
			
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore.loadStoreRecords();
			}
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked: ", viewLocked);
//			console.log("viewNormal: ", viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onResetButtonDown: function() {
			draftNo = '';
			inI = '';
			outI ='';
			accrueI = '';
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
	
	// 모델필드 생성
	function createModelField(budgNameList) {
		var fields = [
			{name: 'COMP_CODE'					, text: '법인코드'			, type: 'string'},
			{name: 'GUBUN'						, text: '구분'			, type: 'string'},
			{name: 'SEQ'						, text: '순번'			, type: 'int'},
			{name: 'SLIP_DATE'					, text: '전표일'			, type: 'uniDate'},
			{name: 'APP_DATE'					, text: '결재완결일'		, type: 'uniDate'},
			{name: 'TRANS_DATE'					, text: '지급일'			, type: 'uniDate'},
			{name: 'DRAFT_NO'					, text: '수입/지출번호'		, type: 'string'},
			{name: 'TITLE'						, text: '수입/지출건명'		, type: 'string'},
			{name: 'CUSTOM_NAME'				, text: '거래처명'			, type: 'string'},
			{name: 'BANKBOOK_NUM'				, text: '계좌번호'			, type: 'string'},
			{name: 'IN_I'						, text: '수입액'			, type: 'uniPrice'},//, type: 'float', format:'0,000'},
			{name: 'OUT_I'						, text: '지출액'			, type: 'uniPrice'},//, type: 'float', format:'0,000'},
			{name: 'ACCRUE_I'					, text: '잔액'			, type: 'uniPrice'},//, type: 'float', format:'0,000'},
			{name: 'PJT_CODE'					, text: '프로젝트코드'		, type: 'string'},
			{name: 'PJT_NAME'					, text: '프로젝트명'		, type: 'string'},
			{name: 'BUDG_CODE'					, text: '예산코드'			, type: 'string'},

			// BUDG_NAME
			
			{name: 'IF_CODE'					, text: '예산Mapping항목'	, type: 'string'},
			{name: 'DEPT_CODE'					, text: '예산부서코드'		, type: 'string'},
			{name: 'DEPT_NAME'					, text: '예산부서'			, type: 'string'},
			{name: 'SORT_DATE'					, text: 'SORT_DATE'		, type: 'string'},
			{name: 'EX_DATE'					, text: '결의일자'			, type: 'uniDate'},
			{name: 'EX_NUM'						, text: '번호'			, type: 'string'},
			{name: 'AC_DATE'					, text: '회계일자'			, type: 'uniDate'},
			{name: 'SLIP_NUM'					, text: '번호'			, type: 'string'},
			{name: 'DRAFTER'					, text: '추산작성자'		, type: 'string'},
			{name: 'PAY_DRAFTER'				, text: '지출작성자'		, type: 'string'},
			{name: 'BUDG_TYPE'					, text: '수지구분'			, type: 'string'},
			{name: 'BUDG_TYPE_NM'				, text: '수지구분'			, type: 'string'}
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
			{dataIndex: 'COMP_CODE'					, width: 88,hidden:true}, 
			{dataIndex: 'GUBUN'						, width: 88,hidden:true},
			{dataIndex: 'SEQ'						, width: 88,hidden:true
//				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//					var record = directMasterStore.data.items[0];
//					
//				    return Unilite.renderSummaryRow(summaryData, metaData, '', '<div align="center">' + record.data.SEQ);
//            	}
			},
			{dataIndex: 'SLIP_DATE'					, width: 88},
			{dataIndex: 'APP_DATE'					, width: 88},
			{dataIndex: 'TRANS_DATE'				, width: 88},
			{dataIndex: 'DRAFT_NO'					, width: 110,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var record = directMasterStore.data.items[0];
					
				    return Unilite.renderSummaryRow(summaryData, metaData, '', '<div align="center">' + draftNo);
            	}
			},
			{dataIndex: 'TITLE'						, width: 200},
			{dataIndex: 'CUSTOM_NAME'				, width: 150},
			{dataIndex: 'BANKBOOK_NUM'				, width: 130},
			
//			Ext.applyIf({dataIndex:'IN_I',      width: 100      , text: '테스트'            , style: 'text-align: center'     }, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),       
			
			{dataIndex: 'IN_I'						, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var record = directMasterStore.data.items[0];
					
				    return Unilite.renderSummaryRow(summaryData, metaData, '', '<div align="center">' + Ext.util.Format.number(inI,'0,000'));
            	}
			},
			{dataIndex: 'OUT_I'						, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var record = directMasterStore.data.items[0];
					
				    return Unilite.renderSummaryRow(summaryData, metaData, '', '<div align="center">' + Ext.util.Format.number(outI,'0,000'));
            	}
			},
			{dataIndex: 'ACCRUE_I'					, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var record = directMasterStore.data.items[0];
					
				    return Unilite.renderSummaryRow(summaryData, metaData, '', '<div align="center">' + Ext.util.Format.number(accrueI,'0,000'));
            	}
			},
			{dataIndex: 'PJT_CODE'					, width: 88,hidden:true},
			{dataIndex: 'PJT_NAME'					, width: 120},
			{dataIndex: 'BUDG_CODE'					, width: 130}
		];
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_'+(index + 1);
			columns.push({dataIndex: dataIndex		, width: 120});	
		});
		columns.push({dataIndex: 'IF_CODE'			, width: 120});
		columns.push({dataIndex: 'DEPT_CODE'		, width: 88,hidden:true});
		columns.push({dataIndex: 'DEPT_NAME'		, width: 90});
		columns.push({dataIndex: 'SORT_DATE'		, width: 88,hidden:true});
		columns.push({dataIndex: 'EX_DATE'			, width: 88});
		columns.push({dataIndex: 'EX_NUM'			, width: 66,align:'center'});
		columns.push({dataIndex: 'AC_DATE'			, width: 88});
		columns.push({dataIndex: 'SLIP_NUM'			, width: 88});
		columns.push({dataIndex: 'DRAFTER'			, width: 88,align:'center'});
		columns.push({dataIndex: 'PAY_DRAFTER'		, width: 88,align:'center'});
		columns.push({dataIndex: 'BUDG_TYPE'		, width: 88,hidden:true});
		columns.push({dataIndex: 'BUDG_TYPE_NM'		, width: 88,align:'center'});
		return columns;
	}
};


</script>
