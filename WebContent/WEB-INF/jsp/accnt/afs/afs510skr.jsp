<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afs510skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐유형-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var getStDt = ${getStDt};
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
var blnAmtI = 0;

function appMain() {
	
	var exSlipPgmId = '${exSlipPgmID}';
	var exSlipPgmLink = '/accnt/' + exSlipPgmId + '.do';
	
	if(Ext.isEmpty(exSlipPgmId)) {
		exSlipPgmId = 'agj200ukr';
		exSlipPgmLink = '/accnt/agj200ukr.do';
	}
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afs510skrModel', {
	    fields: [  	  
		    {name: 'SAVE_CODE'				, text: '통장코드' 	,type: 'string'},
		    {name: 'SAVE_NAME'				, text: '통장명' 		,type: 'string'},
		    {name: 'ACCNT'					, text: '계정코드' 	,type: 'string'},
		    {name: 'ACCNT_NAME'				, text: '계정과목' 	,type: 'string'},
		    {name: 'BANK_ACCOUNT'			, text: '계좌번호(DB)' 	,type: 'string'},
		    {name: 'BANK_ACCOUNT_EXPOS'		, text: '계좌번호' 	,type: 'string', defaultValue:'***************'},
		    {name: 'MONEY_UNIT'				, text: '화폐' 		,type: 'string'},
		    {name: 'REF_CODE1'				, text: '참조코드' 	,type: 'string'}
		]          
	});
	
	
	Unilite.defineModel('Afs510skrModel2', {
	    fields: [  	  
		    {name: 'GBN'					, text: 'GBN' 			,type: 'string'},
		    {name: 'AC_DATE'				, text: '전표일' 			,type: 'string'},
		    {name: 'SLIP_NUM'				, text: '전표번호' 		,type: 'string'},
		    {name: 'SLIP_SEQ'				, text: '순번' 			,type: 'string'},
		    {name: 'CR_AMT_I'				, text: '출금금액' 		,type: 'uniPrice'},
		    {name: 'DR_AMT_I'				, text: '입금금액' 		,type: 'uniPrice'},
		    {name: 'BLN_AMT_I'				, text: '잔액' 			,type: 'uniPrice'},
		    {name: 'EXCHG_RATE_O'			, text: '환율' 			,type: 'uniPrice'},
			{name: 'REMARK'					, text: '적요' 			,type: 'string'},
			{name: 'DIV_CODE'				, text: '사업장' 			,type: 'string'},
			{name: 'INPUT_PATH'				, text: 'INPUT_PATH'	,type: 'string'}
		]          
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('afs510skrMasterStore1',{
		model: 'Afs510skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,				// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afs510skrService.selectList1'                	
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
	
	
	var directMasterStore2 = Unilite.createStore('afs510skrMasterStore2',{
		model: 'Afs510skrModel2',
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
                read: 'afs510skrService.selectList2'                	
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
        //region : 'west',
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{ 
		        fieldLabel: '전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
						UniAppManager.app.fnSetStDate(newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}   	
			    }
//				textFieldWidth:170
				
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},
			Unilite.popup('ACCNT',{ 
			    fieldLabel: '계정과목', 
			    valueFieldName: 'ACCNT_CODE',
				textFieldName: 'ACCNT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
							panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_CODE', '');
						panelResult.setValue('ACCNT_NAME', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'ADD_QUERY' : "SUBSTRING(SPEC_DIVI,1,1) IN ('B','C')",
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
			}),
			Unilite.popup('BANK_BOOK',{ 
			    fieldLabel: '통장', 
			    popupWidth: 910,
			    valueFieldName: 'BANK_BOOK_CODE',
				textFieldName: 'BANK_BOOK_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('BANK_BOOK_CODE', panelSearch.getValue('BANK_BOOK_CODE'));
							panelResult.setValue('BANK_BOOK_NAME', panelSearch.getValue('BANK_BOOK_NAME'));	
							panelSearch.setValue('BANK_CODE', records[0].BANK_CD);
							panelSearch.setValue('BANK_NAME', records[0].BANK_NM);		 	
							panelResult.setValue('BANK_CODE', records[0].BANK_CD);
							panelResult.setValue('BANK_NAME', records[0].BANK_NM);	
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('BANK_BOOK_CODE', '');
						panelResult.setValue('BANK_BOOK_NAME', '');
						panelSearch.setValue('BANK_CODE', '');
						panelSearch.setValue('BANK_NAME', '');	
						panelResult.setValue('BANK_CODE', '');
						panelResult.setValue('BANK_NAME', '');		
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}	   
			}),
			Unilite.popup('BANK',{ 
			    fieldLabel: '은행', 
			    popupWidth: 500,
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
			}),{
		 		fieldLabel: '화폐',
		 		name:'MONEY_UNIT', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B004', 
		 		displayField: 'value',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MONEY_UNIT', newValue);
					}
				}
	 		},{
			 		fieldLabel: 'ST_DT_TEMP',
			 		xtype: 'uniMonthfield',
			 		name: 'ST_DT_TEMP',
			 		hidden: true
				},{
			 		fieldLabel: 'FR_DATE_TEMP',
			 		xtype: 'uniDatefield',
			 		name: 'FR_DATE_TEMP',
			 		hidden: true
				},{
			 		fieldLabel: 'TO_DATE_TEMP',
			 		xtype: 'uniDatefield',
			 		name: 'TO_DATE_TEMP',
			 		hidden: true
				},{
			 		fieldLabel: 'ACCNT_DIV_CODE_TEMP',
			 		xtype: 'uniTextfield',
			 		name: 'ACCNT_DIV_CODE_TEMP',
			 		hidden: true
				},{
			 		fieldLabel: 'ACCNT_TEMP',
			 		xtype: 'uniTextfield',
			 		name: 'ACCNT_TEMP',
			 		hidden: true
				},{
			 		fieldLabel: 'SAVE_CODE_TEMP',
			 		xtype: 'uniTextfield',
			 		name: 'SAVE_CODE_TEMP',
			 		hidden: true
				},{
			 		fieldLabel: 'MONEY_UNIT_TEMP',
			 		xtype: 'uniTextfield',
			 		name: 'MONEY_UNIT_TEMP',
			 		hidden: true
				},{
			 		fieldLabel: 'REF_CODE1',
			 		xtype: 'uniTextfield',
			 		name: 'REF_CODE1',
			 		hidden: true
				}
	 		]},{
				title:'추가정보',
   				id: 'search_panel2',
				itemId:'search_panel2',
        		defaultType: 'uniTextfield',
        		layout : {type : 'uniTable', columns : 1},
        		defaultType: 'uniTextfield',
        		items:[{
        			fieldLabel: '당기시작년월',
		 			xtype: 'uniMonthfield',
		 			name: 'ST_DATE',
		 			allowBlank:false
				},
				Unilite.popup('DEPT',{ 
				    fieldLabel: '부서', 
				    popupWidth: 910,
				    valueFieldName: 'DEPT_CODE_FR',
					textFieldName: 'DEPT_NAME_FR',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE_FR', panelSearch.getValue('DEPT_CODE_FR'));
								panelResult.setValue('DEPT_NAME_FR', panelSearch.getValue('DEPT_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE_FR', '');
							panelResult.setValue('DEPT_NAME_FR', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}	  
			}),   	
				Unilite.popup('DEPT',{ 
					fieldLabel: '~', 
					popupWidth: 910,
					valueFieldName: 'DEPT_CODE_TO',
					textFieldName: 'DEPT_NAME_TO',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE_TO', panelSearch.getValue('DEPT_CODE_TO'));
								panelResult.setValue('DEPT_NAME_TO', panelSearch.getValue('DEPT_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE_TO', '');
							panelResult.setValue('DEPT_NAME_TO', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}	  
			}), {               
                //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                name:'DEC_FLAG', 
                xtype: 'uniTextfield',
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
	});	  
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [		    
	    	{ 
		        fieldLabel: '전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_DATE',newValue);
						UniAppManager.app.fnSetStDate(newValue);
            		} 
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_DATE',newValue);
			    	}   	
			    }
//				textFieldWidth:170
				
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
	        },
				Unilite.popup('ACCNT',{ 
				    fieldLabel: '계정과목', 
				    valueFieldName: 'ACCNT_CODE',
					textFieldName: 'ACCNT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
								panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ACCNT_CODE', '');
							panelSearch.setValue('ACCNT_NAME', '');
						},
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'ADD_QUERY' : "SUBSTRING(SPEC_DIVI,1,1) IN ('B','C')",
                                    'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                                }
                                popup.setExtParam(param);
                            }
                        }
					}	  
			}),
				Unilite.popup('BANK_BOOK',{ 
				    fieldLabel: '통장', 
				    popupWidth: 910,
				    valueFieldName: 'BANK_BOOK_CODE',
					textFieldName: 'BANK_BOOK_NAME',
					colspan: 2,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('BANK_BOOK_CODE', panelResult.getValue('BANK_BOOK_CODE'));
								panelSearch.setValue('BANK_BOOK_NAME', panelResult.getValue('BANK_BOOK_NAME'));	
								panelResult.setValue('BANK_CODE', records[0].BANK_CD);
								panelResult.setValue('BANK_NAME', records[0].BANK_NM);	
								panelSearch.setValue('BANK_CODE', records[0].BANK_CD);
								panelSearch.setValue('BANK_NAME', records[0].BANK_NM);		 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('BANK_BOOK_CODE', '');
							panelSearch.setValue('BANK_BOOK_NAME', '');
							panelResult.setValue('BANK_CODE', '');
							panelResult.setValue('BANK_NAME', '');	
							panelSearch.setValue('BANK_CODE', '');
							panelSearch.setValue('BANK_NAME', '');	
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}	   
			}),{
			 		fieldLabel: '화폐',
			 		name:'MONEY_UNIT', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'B004', 
			 		displayField: 'value',
			 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('MONEY_UNIT', newValue);
						}
					}
	 		},
			Unilite.popup('BANK',{ 
			    fieldLabel: '은행', 
			    popupWidth: 500,
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
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('afs510skrGrid1', {
    	layout : 'fit',
        region : 'center',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        tbar: [
        
        ],
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
		selModel : 'rowmodel',
        columns: [       
        	{dataIndex: 'SAVE_CODE'				, width: 66 }, 				
			{dataIndex: 'SAVE_NAME'				, width: 113}, 				
			{dataIndex: 'ACCNT'					, width: 80	,hidden: true},
			{dataIndex: 'ACCNT_NAME'			, width: 166,hidden: true},
			{dataIndex: 'BANK_ACCOUNT_EXPOS'	, width: 133},
			{dataIndex: 'BANK_ACCOUNT'			, width: 133,hidden: true},
			{dataIndex: 'MONEY_UNIT'			, width: 53 },
			{dataIndex: 'REF_CODE1'				, width: 53 ,hidden: true}
		],
		listeners: {									
        	select: function(grid, record, index, eOpts ){		
//        	selectionchange:function( model1, selected, eOpts ){
        		//var record = selected[0];
        		var record = masterGrid.getSelectedRecord();
        		this.returnCell(record);  
        		directMasterStore2.loadData({})
				directMasterStore2.loadStoreRecords(record);
          	},
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="BANK_ACCOUNT_EXPOS") {
					grid.ownerGrid.openCryptAcntNumPopup(record);
				}
			}
		},
       	returnCell: function(record) {
        	var account			= record.get("ACCNT");
        	var saveCode		= record.get("SAVE_CODE");
        	var moneyUnit 		= record.get("MONEY_UNIT");
        	var stDt			= panelSearch.getValue("ST_DATE");
        	var frDate			= panelSearch.getValue("FR_DATE");   
        	var toDate			= panelSearch.getValue("TO_DATE");
        	var divCode			= panelSearch.getValue("ACCNT_DIV_CODE");
        	var refCode			= record.get("REF_CODE1");
            panelSearch.setValues({'ACCNT_TEMP':account});
            panelSearch.setValues({'SAVE_CODE_TEMP':saveCode});
            panelSearch.setValues({'MONEY_UNIT_TEMP':moneyUnit});
            panelSearch.setValues({'ST_DT_TEMP':stDt});
            panelSearch.setValues({'FR_DATE_TEMP':frDate});
            panelSearch.setValues({'TO_DATE_TEMP':toDate});
            panelSearch.setValues({'ACCNT_DIV_CODE_TEMP':divCode});
            panelSearch.setValues({'REF_CODE1':refCode});
        },
		openCryptAcntNumPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);
			}
				
		}
    });
    
        /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid2 = Unilite.createGrid('afs510skrGrid2', {    	
    	layout : 'fit',
        region : 'east',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			},
			excel: {
				useExcel: true,			//엑셀 다운로드 사용 여부
				exportGroup : false, 		//group 상태로 export 여부
				onlyData:false,
				summaryExport:true,
				exportGridData:true
			}
        },
		store: directMasterStore2,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
        columns: [        
        	{dataIndex: 'GBN'					, width: 80 ,hidden: true}, 				
			{dataIndex: 'AC_DATE'				, width: 100}, 				
			{dataIndex: 'SLIP_NUM'				, width: 80,	align:'center'
//        		renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
//        			return '<div align="center">' + val;
//                }
            },
			{dataIndex: 'SLIP_SEQ'				, width: 53,	align:'center'
//        		renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
//        			return '<div align="center">' + val;
//                }
            },
			{dataIndex: 'CR_AMT_I'				, width: 113},
			{dataIndex: 'DR_AMT_I'				, width: 113},
			{dataIndex: 'BLN_AMT_I'				, width: 113,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {		
					var preRecord = store.getAt(rowIndex - 1)
					if(record.get('GBN') == '00000000') {			// 구분이 0일때(첫번째 레코드 값 구하고)
						blnAmtI = 0;
						return Ext.util.Format.number(val,'0,000,000,000');				
					} else if(record.get('GBN') == '99999999') {	// 합계
						blnAmtI = record.get('DR_AMT_I') - record.get('CR_AMT_I');
					} else if (record.get('AC_DATE') == '소계(월)') {	// 소계
						return 0;
					} else {
						if(blnAmtI == 0) {
							blnAmtI = preRecord.get('BLN_AMT_I') - record.get('CR_AMT_I') + record.get('DR_AMT_I');		
						} else {
							blnAmtI = blnAmtI - record.get('CR_AMT_I') + record.get('DR_AMT_I');
						}
					}
					return Ext.util.Format.number(blnAmtI, '0,000,000,000');
				}
			},
			{dataIndex: 'EXCHG_RATE_O'			, width: 80},
			{dataIndex: 'REMARK'				, width: 300},
			{dataIndex: 'DIV_CODE'				, width: 133 ,hidden:true},
			{dataIndex: 'INPUT_PATH'			, width: 80 ,hidden:true}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				var gbn = record.get('GBN');
				gbn = gbn.substring(gbn.length - 2, gbn.length);
				
				if (gbn != '00' && gbn != '99') {
					view.ownerGrid.setCellPointer(view, item);
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
				
				if(record.get('GBN') == '00000000') {			// 구분이 0일때(첫번째 레코드 값 구하고)
					return false;
				} else if(record.get('GBN') == '99999999') {	// 합계
					return false;
				} else if (record.get('AC_DATE') == '소계(월)') {	// 소계
					return false;
				}
				
				var params = {
					action:'select',
					'PGM_ID'		: 'afs510skr',
					'DIV_CODE' : record.data['DIV_CODE'],
					'AC_DATE' : record.data['AC_DATE'],
					'INPUT_PATH' : record.data['INPUT_PATH'],
					'SLIP_NUM' : record.data['SLIP_NUM'],
					'SLIP_SEQ' : record.data['SLIP_SEQ']
				}
				if(record.data['INPUT_PATH'] == 'Z3') {
					var rec1 = {data : {prgID : 'dgj100ukr', 'text':''}};
					parent.openTab(rec1, '/accnt/dgj100ukr.do', params);
  				} else {
//  					var rec2 = {data : {prgID : 'agj200ukr', 'text':''}};
//					parent.openTab(rec2, '/accnt/agj200ukr.do', params);
  					var rec2 = {data : {prgID : exSlipPgmId, 'text':''}};
					parent.openTab(rec2, exSlipPgmLink, params);
  				}
			}
		},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('GBN') == '00000000') {
					cls = 'x-change-cell_light';
				} else if(record.get('GBN') == '20160199') { 
					cls = 'x-change-cell_normal';
				} else if(record.get('GBN') == '20160399') {
					cls = 'x-change-cell_normal';
				} else if(record.get('GBN') == '99999999') {
					cls = 'x-change-cell_dark';	
				}
				return cls;
	        }
	    }               			
    });
    
    //복호화 버튼 정의
    var decrypBtn = Ext.create('Ext.Button',{
        text:'복호화',
        width: 80,
        handler: function() {
            var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
            if(needSave){
               alert(Msg.sMB154); //먼저 저장하십시오.
               return false;
            }
            panelSearch.setValue('DEC_FLAG', 'Y');
            UniAppManager.app.onQueryButtonDown();
            panelSearch.setValue('DEC_FLAG', '');
        }
    });
    
    Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				{
					region : 'west',
					xtype : 'container',
					width : 404,
					layout : 'fit',
					items : [ masterGrid ]
				},{
					region : 'center',
					xtype : 'container',
					width : 700,
					layout : 'fit',
					items : [ masterGrid2 ]
				},panelResult
			]
		},
			panelSearch  	
		], 
		id : 'afs510skrApp',
		fnInitBinding : function(params) {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setValue('ST_DATE',getStDt[0].STDT);
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			//복호화버튼 그리드 툴바에 추가
            var tbar = masterGrid._getToolBar();
            tbar[0].insert(tbar.length + 1, decrypBtn);
			this.processParams(params);
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params && params.BANK_CODE) {
				panelSearch.setValue('ACCNT_DIV_CODE'	,params.DIV_CODE);
				panelSearch.setValue('FR_DATE'			,params.AC_DATE_FR);
				panelSearch.setValue('TO_DATE'			,params.AC_DATE_TO);
				panelSearch.setValue('BANK_BOOK_CODE'	,params.BANK_BOOK_CODE);
				panelSearch.setValue('BANK_BOOK_NAME'	,params.BANK_BOOK_NAME);
				panelSearch.setValue('BANK_CODE'		,params.BANK_CODE);
				panelSearch.setValue('BANK_NAME'		,params.BANK_NAME);
				panelSearch.setValue('MONEY_UNIT'		,params.MONEY_UNIT);
				
				panelResult.setValue('ACCNT_DIV_CODE'	,params.DIV_CODE);
				panelResult.setValue('FR_DATE'			,params.AC_DATE_FR);
				panelResult.setValue('TO_DATE'			,params.AC_DATE_TO);
				panelResult.setValue('BANK_BOOK_CODE'	,params.BANK_BOOK_CODE);
				panelResult.setValue('BANK_BOOK_NAME'	,params.BANK_BOOK_NAME);
				panelResult.setValue('BANK_CODE'		,params.BANK_CODE);
				panelResult.setValue('BANK_NAME'		,params.BANK_NAME);
				panelResult.setValue('MONEY_UNIT'		,params.MONEY_UNIT);

				panelSearch.setValue('ST_DATE'			,params.ST_DATE);
				masterGrid.getStore().loadStoreRecords();
			}
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid2.getStore().loadData({});
			directMasterStore.loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
        fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        }
	});
};


</script>
