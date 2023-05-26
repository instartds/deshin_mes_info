<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx120skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A003"  /> <!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> <!-- 증빙유형 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var useColList = ${useColList};
function appMain() {     
	
	/**
	 * 증빙유형 콤보 Store 정의
	 * @type 
	 */					
	var ProofKindStore = Unilite.createStore('atx120skrProofKindStore',{
        proxy: {
           type: 'direct',
            api: {			
                read: 'atx120skrService.getProofKind'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx120skrModel', {
	   fields: [
			{name: 'CUSTOM_CODE'   		, text: '거래처'				, type: 'string'},
			{name: 'CUSTOM_NAME'   		, text: '거래처명'				, type: 'string'},
			{name: 'COMPANY_NUM'   		, text: '사업자번호'			, type: 'string'},
			{name: 'COMP_CLASS'			, text: '업종'				, type: 'string'},
			{name: 'COMP_TYPE'    		, text: '업태'				, type: 'string'},
			{name: 'PROOF_KIND_CNT'		, text: '매수'				/*, type: 'uniNumber',format:'0,000'*/},
			{name: 'I_SUPPLY_AMT'		, text: '매입공급가액'			, type: 'uniPrice'},
			{name: 'I_TAX_AMT'   		, text: '매입세액'				, type: 'uniPrice'},
			{name: 'O_SUPPLY_AMT'  		, text: '매출공급가액'			, type: 'uniPrice'},
			{name: 'O_TAX_AMT'			, text: '매출세액'				, type: 'uniPrice'}
	    ]
	});		// End of Ext.define('Atx120skrModel', {
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('atx120MasterStore',{
		model: 'Atx120skrModel',
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
                read: 'atx120skrService.selectList'                	
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
           	load: function(store, records, successful, eOpts) {/*
           		var viewNormal = masterGrid.getView();
           		if(store.getCount() > 0){
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				}else{
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
				}
           	*/},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
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
				{ 
	        	fieldLabel: '계산서일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'txtFrDate',
				endFieldName: 'txtToDate',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('txtFrDate',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('txtToDate',newValue);
			    	}
			    }
			},{
				fieldLabel: '매입/매출구분',
				name:'txtDivi',	
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A003',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('txtDivi', newValue);
						ProofKindStore.loadStoreRecords();
					}
				} 
			},{
				fieldLabel: '신고사업장',
				name:'txtOrgCd',	
				xtype: 'uniCombobox',
				comboType:'BOR120' ,
				comboCode	: 'BILL',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('txtOrgCd', newValue);

					}
				} 
			},{
				fieldLabel: '증빙유형',
				name:'txtProofKind',
				xtype: 'uniCombobox',
				store:ProofKindStore,
				width:315,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('txtProofKind', newValue);
						}
				}   
			},
   	        	//CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
	        Unilite.popup('CUST',{
		        fieldLabel: '거래처',
//		        validateBlank:'text',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,	 		        
		        extParam:{'CUSTOM_TYPE': ['1','2','3']},
			    valueFieldName:'txtCustom',
			    textFieldName:'txtCustomName',
	        	listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelResult.setValue('txtCustom', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('txtCustomName', '');
								panelSearch.setValue('txtCustomName', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('txtCustomName', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('txtCustom', '');
								panelSearch.setValue('txtCustom', '');
							}
						}					
				}		        
		    })]
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
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
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
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
        	fieldLabel: '계산서일',
			xtype: 'uniDateRangefield',  
			startFieldName: 'txtFrDate',
			endFieldName: 'txtToDate',
			allowBlank:false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('txtFrDate',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('txtToDate',newValue);
			    	}
			    }
		},{
			fieldLabel: '매입/매출구분',
			name:'txtDivi',	
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'A003',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('txtDivi', newValue);
					ProofKindStore.loadStoreRecords();
				}
			}  
		},{
			fieldLabel: '신고사업장',
			name:'txtOrgCd',	
			xtype: 'uniCombobox',
			comboType:'BOR120' ,
			comboCode	: 'BILL',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('txtOrgCd', newValue);
				}
			}  
		},{
			fieldLabel: '증빙유형',
			name:'txtProofKind',
			xtype: 'uniCombobox',
			store:ProofKindStore,
			width:315,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('txtProofKind', newValue);
				}
			}    
		},
        	//CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
        Unilite.popup('CUST',{
	        fieldLabel: '거래처',
//	        validateBlank:'text',
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,	 	        
	        extParam:{'CUSTOM_TYPE': ['1','2','3']},
		    valueFieldName:'txtCustom',
		    textFieldName:'txtCustomName',
        	listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('txtCustom', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('txtCustomName', '');
								panelSearch.setValue('txtCustomName', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('txtCustomName', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('txtCustom', '');
								panelSearch.setValue('txtCustom', '');
							}
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
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
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
    
    var masterGrid = Unilite.createGrid('atx120skrGrid', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
		excelTitle: '합계표',
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
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
        	{dataIndex: 'CUSTOM_CODE'   	, width: 100,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
        	}, 				
			{dataIndex: 'CUSTOM_NAME'   	, width: 200}, 				
			{dataIndex: 'COMPANY_NUM'   	, width: 100, align:'center'}, 				
			{dataIndex: 'COMP_CLASS'		, width: 120}, 				
			{dataIndex: 'COMP_TYPE'    		, width: 120}, 				
			{dataIndex: 'PROOF_KIND_CNT'	, width: 60, align:'center',summaryType: 'sum',xtype: 'numbercolumn',format: '0,000',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				    return Unilite.renderSummaryRow(summaryData, metaData, '', '<div align="center">' + Ext.util.Format.number(value,'0,000'));
		    	}
			}, 				
			{dataIndex: 'I_SUPPLY_AMT'		, width: 120,summaryType: 'sum'}, 				
			{dataIndex: 'I_TAX_AMT'   		, width: 120,summaryType: 'sum'}, 				
			{dataIndex: 'O_SUPPLY_AMT'  	, width: 120,summaryType: 'sum'}, 				
			{dataIndex: 'O_TAX_AMT'			, width: 120,summaryType: 'sum'}
		],
		listeners:{
			afterrender:function()	{
				UniAppManager.app.setHiddenColumn();
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
		id : 'atx120App',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('txtFrDate');
			
//			var viewNormal = masterGrid.getView();
//			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			
			this.setDefault();
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore.loadStoreRecords();
//				UniAppManager.setToolbarButtons('reset',true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		setDefault: function() {
        	ProofKindStore.loadStoreRecords();
        	
        	panelSearch.setValue('txtFrDate',UniDate.get('startOfMonth'));
			panelSearch.setValue('txtToDate',UniDate.get('today'));
			panelResult.setValue('txtFrDate',UniDate.get('startOfMonth'));
			panelResult.setValue('txtToDate',UniDate.get('today'));
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		
		setHiddenColumn: function() {
			Ext.each(useColList, function(record, idx) {
				if(record.REF_CODE4 == 'True'){
					masterGrid.getColumn(record.REF_CODE3).setVisible(false);
				}
			});
		}
	});
};


</script>
