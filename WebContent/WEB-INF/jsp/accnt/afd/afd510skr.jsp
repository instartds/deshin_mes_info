<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afd510skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S054" />			<!-- 질권여부 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var getStDt = ${getStDt};

function appMain() {  
	var providerSTDT ='';
	/**
	 * Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('Afd510Model', {
	   fields: [
			{name: 'BANK_KIND'		, text: '예적금종류코드'		, type: 'string'},
			{name: 'BANK_KIND_NM'	, text: '예적금종류'		, type: 'string'},
			{name: 'BANK_CODE'		, text: '금융기관코드'		, type: 'string'},
			{name: 'BANK_NAME'		, text: '금융기관'			, type: 'string'},
			{name: 'BANK_ACCOUNT'	, text: '계좌번호(DB)'		, type: 'string'},
			{name: 'BANK_ACCOUNT_EXPOS'  , text: '계좌번호'		,type : 'string' , defaultValue:'***************'},
			{name: 'SAVE_DESC'		, text: '예적금명'			, type: 'string'},
			{name: 'TOT_CNT'		, text: '총불입횟수'		, type: 'uniQty'},
			{name: 'NOW_CNT'		, text: '현불입횟수'		, type: 'uniQty'},
			{name: 'PUB_DATE'		, text: '계약일'			, type: 'uniDate'},
			{name: 'EXP_DATE'		, text: '만기일'			, type: 'uniDate'},
			{name: 'MONTH_AMT'		, text: '월불입액'			, type: 'uniPrice'},
			{name: 'EXP_AMT_I'		, text: '약정금액'			, type: 'uniPrice'},
			{name: 'NOW_AMT_I'		, text: '현불입액'			, type: 'uniPrice'},
			{name: 'JAN_AMT_I'		, text: '미불입액'			, type: 'uniPrice'},
			{name: 'MONEY_UNIT'		, text: '화폐단위'			, type: 'string'},
			{name: 'MONTH_FOR_AMT'	, text: '외화월불입액'		, type: 'uniFC'},
			{name: 'EXP_FOR_AMT_I'	, text: '외화약정금액'		, type: 'uniFC'},
			{name: 'NOW_FOR_AMT_I'	, text: '외화현불입액'		, type: 'uniFC'},
			{name: 'JAN_FOR_AMT_I'	, text: '외화미불입액'		, type: 'uniFC'},
			{name: 'PLD_YN'			, text: '질권'			, type: 'string'},
			{name: 'GUBUN'			, text: '(GUBUN)'		, type: 'string'}	
	    ]
	});		// End of Ext.define('Afd510skrModel', {
	  
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	var directMasterStore = Unilite.createStore('afd510MasterStore1',{
		model: 'Afd510Model',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afd510skrService.selectMasterList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'BANK_KIND_NM'
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * 
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
			items: [{
				fieldLabel: '기준일',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				// width: 200,
				name: 'AC_DATE',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AC_DATE', newValue);
					}
				}
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
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('BANK_BOOK_CODE', '');
							panelResult.setValue('BANK_BOOK_NAME', '');
						},
						applyextparam: function(popup){							
							// popup.setExtParam({'DIV_CODE':
							// panelSearch.getValue('DIV_CODE')});
						}
					}	   
			}),
				Unilite.popup('BANK',{ 
				    fieldLabel: '금융기관', 
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
							// popup.setExtParam({'DIV_CODE':
							// panelSearch.getValue('DIV_CODE')});
						}
					}
				}),{
					xtype: 'radiogroup',		            		
					fieldLabel: '구분',						            		
					// id: 'rdoSelect',
					items: [{
						boxLabel: '전체', 
						width: 50, 
						name: 'rdoSelect'
					},{
						boxLabel : '진행', 
						width: 50,
						name: 'rdoSelect',
						inputValue: '1',
						checked: true  
					},{
						boxLabel : '마감', 
						width: 50,
						name: 'rdoSelect',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {			
							panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
						}
					}
				}, {               
                    //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                    name:'DEC_FLAG', 
                    xtype: 'uniTextfield',
                    hidden: true
                }
			]
		},{
			title: '추가정보', 	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{ 
	    			fieldLabel: '당기시작년월',
	    			name:'ST_DATE',
					xtype: 'uniMonthfield',
					value: getStDt.STDT,
					//holdable:'hold',
					allowBlank:false,
					width: 200
				},{
        			fieldLabel: '질권여부',
        			name: 'PLD_YN',
        			xtype: 'uniCombobox',
        			comboType: 'AU',
        			comboCode: 'S054'
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
		      		// this.mask();
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
		    	// this.unmask();
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
		items: [{
				fieldLabel: '기준일',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				// width: 200,
				name: 'AC_DATE',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AC_DATE', newValue);
					}
				}
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
				Unilite.popup('BANK_BOOK',{ 
				    fieldLabel: '통장', 
				    popupWidth: 910,
				    valueFieldName: 'BANK_BOOK_CODE',
					textFieldName: 'BANK_BOOK_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('BANK_BOOK_CODE', panelResult.getValue('BANK_BOOK_CODE'));
								panelSearch.setValue('BANK_BOOK_NAME', panelResult.getValue('BANK_BOOK_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('BANK_BOOK_CODE', '');
							panelSearch.setValue('BANK_BOOK_NAME', '');
						},
						applyextparam: function(popup){							
							// popup.setExtParam({'DIV_CODE':
							// panelSearch.getValue('DIV_CODE')});
						}
					}	   
			}),
				Unilite.popup('BANK',{ 
				    fieldLabel: '금융기관', 
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
							// popup.setExtParam({'DIV_CODE':
							// panelSearch.getValue('DIV_CODE')});
						}
					}
				}),{
					xtype: 'radiogroup',		            		
					fieldLabel: '구분',						            		
					// id: 'rdoSelect2',
					items: [{
						boxLabel: '전체', 
						width: 50, 
						name: 'rdoSelect'
					},{
						boxLabel : '진행', 
						width: 50,
						name: 'rdoSelect',
						inputValue: '1',
						checked: true  
					},{
						boxLabel : '마감', 
						width: 50,
						name: 'rdoSelect',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {			
							panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
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
		      		// this.mask();
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
		    	// this.unmask();
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
	
    /**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
    
    var masterGrid = Unilite.createGrid('afd510Grid1', {
    	layout : 'fit',
        region : 'center',
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
			}
        },
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
    	tbar: [
        
        ],
        columns: [        
        	{dataIndex: 'BANK_KIND'			, width: 66, hidden: true}, 				
			{dataIndex: 'BANK_KIND_NM'		, width: 85, locked: true, align:'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	       			return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
			}}, 				
			{dataIndex: 'BANK_CODE'			, width: 80, hidden: true}, 				
			{dataIndex: 'BANK_NAME'			, width: 80, locked: true}, 				
			{dataIndex: 'BANK_ACCOUNT'		, width: 120, locked: true, hidden: true}, 
			{dataIndex: 'BANK_ACCOUNT_EXPOS', width: 120, locked: true}, 
			{dataIndex: 'SAVE_DESC'			, width: 133}, 				
			{dataIndex: 'TOT_CNT'			, width: 85}, 				
			{dataIndex: 'NOW_CNT'			, width: 85}, 				
			{dataIndex: 'PUB_DATE'			, width: 73}, 				
			{dataIndex: 'EXP_DATE'			, width: 73}, 				
			{dataIndex: 'MONTH_AMT'			, width: 86, summaryType: 'sum'}, 				
			{dataIndex: 'EXP_AMT_I'			, width: 100, summaryType: 'sum'}, 				
			{dataIndex: 'NOW_AMT_I'			, width: 100, summaryType: 'sum'}, 				
			{dataIndex: 'JAN_AMT_I'			, width: 100, summaryType: 'sum'}, 				
			{dataIndex: 'MONEY_UNIT'		, width: 73}, 				
			{dataIndex: 'MONTH_FOR_AMT'		, width: 93, summaryType: 'sum'}, 				
			{dataIndex: 'EXP_FOR_AMT_I'		, width: 106, summaryType: 'sum'}, 				
			{dataIndex: 'NOW_FOR_AMT_I'		, width: 106, summaryType: 'sum'}, 				
			{dataIndex: 'JAN_FOR_AMT_I'		, width: 106, summaryType: 'sum'}, 				
			{dataIndex: 'PLD_YN'			, width: 66}, 				
			{dataIndex: 'GUBUN'				, width: 66, hidden: true}
		],
		listeners:{
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="BANK_ACCOUNT_EXPOS") {
					grid.ownerGrid.openCryptPopup(record);
				}
			}		
		},
		openCryptPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);
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
		id : 'afd510App',
		fnInitBinding : function() {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			//복호화버튼 그리드 툴바에 추가
            var tbar = masterGrid._getToolBar();
            tbar[0].insert(tbar.length + 1, decrypBtn);
            
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE');
			panelSearch.setValue('ACCNT_DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setValue('ST_DATE',getStDt[0].STDT);
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
