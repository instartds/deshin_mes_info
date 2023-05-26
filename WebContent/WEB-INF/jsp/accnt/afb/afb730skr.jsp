<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb730skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="afb730skr" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 --> 
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('Afb730skrModel', {
		fields:[
			{name: 'TYPE_FLAG'				, text: 'TYPE_FLAG'		, type: 'string'},
			{name: 'SEQ'					, text: '순번'			, type: 'int'},
			{name: 'BUDG_CODE'				, text: '예산코드'			, type: 'string'},
			{name: 'TRANS_DATE'				, text: '지급일'			, type: 'string'},
			{name: 'DRAFT_DATE'				, text: '기안(추산)일'		, type: 'uniDate'},
			{name: 'DRAFT_TITLE'			, text: '기안(추산)건명'	, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '거래처명'			, type: 'string'},
			{name: 'BUDG_CONF_I'			, text: '예산액'			, type: 'uniPrice'},
			{name: 'DRAFT_AMT'				, text: '기안(추산)금액'	, type: 'uniPrice'},
			{name: 'DRAFT_REMIND_AMT'		, text: '기안(추산)잔액'	, type: 'uniPrice'},
			{name: 'TRANS_AMT'				, text: '지급액'			, type: 'uniPrice'},
			{name: 'NON_PAY_AMT'			, text: '미지급액'			, type: 'uniPrice'},
			{name: 'BUDG_BALN_I'			, text: '집행잔액'			, type: 'uniPrice'}
//			{name: 'REMARK'					, text: '비고'			, type: 'string'}
	   
	   ]
	});		// End of Ext.define('afb730skrModel', {
	  
			
	var directMasterStore = Unilite.createStore('Afb730skrdirectMasterStore',{
		model: 'Afb730skrModel',
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
                read: 'afb730skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
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
						popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelResult.getValue('FR_DATE')).substring(0, 4)});
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
		layout : {type : 'uniTable', columns : 2},
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
					popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(panelSearch.getValue('FR_DATE')).substring(0, 4)});
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
    var masterGrid = Unilite.createGrid('Afb730skrGrid', {
        region : 'center',
		store: directMasterStore,
//        selModel	: 'rowmodel',
		features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: false
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',
    			dock:'bottom',
    			showSummaryRow: false
    		}
    	],
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
			}
        },
        viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
				if(record.get('TYPE_FLAG') == 'S'){
					return 'x-change-cell_Background_normal_Text_blue';	
				}
	        }
	    },
        columns:[
        	{dataIndex: 'TYPE_FLAG'							, width: 88,hidden:true},
        	{dataIndex: 'SEQ'								, width: 88,hidden:true},
        	{dataIndex: 'BUDG_CODE'							, width: 88,hidden:true},
        	{dataIndex: 'TRANS_DATE'						, width: 88,align:'center'},
        	{dataIndex: 'DRAFT_DATE'						, width: 88},
        	{dataIndex: 'DRAFT_TITLE'						, width: 300},
        	{dataIndex: 'CUSTOM_NAME'						, width: 200},
        	{dataIndex: 'BUDG_CONF_I'						, width: 120},
        	{dataIndex: 'DRAFT_AMT'							, width: 120},
        	{dataIndex: 'DRAFT_REMIND_AMT'					, width: 120},
        	{dataIndex: 'TRANS_AMT'							, width: 120},
        	{dataIndex: 'NON_PAY_AMT'						, width: 88,hidden:true},
        	{dataIndex: 'BUDG_BALN_I'						, width: 120}
//        	{dataIndex: 'REMARK'							, width: 88}
        ]
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
		id : 'Afb730skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE', UniDate.get('today'));
			panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
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
			activeSForm.onLoadSelectText('FR_DATE');
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
};


</script>
