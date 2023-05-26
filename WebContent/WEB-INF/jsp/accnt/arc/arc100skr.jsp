<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc100skr"  >
	<t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J502" /> <!-- 이관취소사유 -->
	<t:ExtComboStore comboType="AU" comboCode="J503" /> <!-- 접수상태 -->
	<t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A134" /> <!-- 결재상태 --> 
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('Arc100skrModel', {
		fields:[
			{name: 'GW_STATUS'				, text: '결재상태'		, type: 'string', comboType:'AU', comboCode:'A134'},
			{name: 'ACCEPT_STATUS'			, text: '접수상태'		, type: 'string', comboType:'AU', comboCode:'J503'},
			{name: 'RECE_DATE'				, text: '등록일'		, type: 'uniDate'},
			{name: 'RECE_NO'				, text: '채권번호'		, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '거래처코드'	, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '거래처명'		, type: 'string'},
			{name: 'TOP_NAME'				, text: '대표자'		, type: 'string'},
			{name: 'RECE_AMT'				, text: '금액'		, type: 'uniPrice'},
			{name: 'COLLECT_AMT'			, text: '수금액'		, type: 'uniPrice'},
			{name: 'TOT_ADJUST_AMT'			, text: '조정'		, type: 'uniPrice'},
			{name: 'TOT_BALANCE_AMT'		, text: '잔액'		, type: 'uniPrice'},
			{name: 'TOT_DISPOSAL_AMT'		, text: '대손처리'		, type: 'uniPrice'},
			{name: 'TOT_BOOKVALUE_AMT'		, text: '장부가액'		, type: 'uniPrice'},
			{name: 'RECE_GUBUN'				, text: '채권구분'		, type: 'string', comboType:'AU', comboCode:'J501'},
			{name: 'MNG_GUBUN'				, text: '구분'		, type: 'string', comboType:'AU', comboCode:'J504'},
			{name: 'CONF_RECE_DATE'			, text: '이관일'		, type: 'uniDate'},
			{name: 'CONF_RECE_NO'			, text: '이관채권번호'	, type: 'string'},
			{name: 'CANCEL_REASON'			, text: '이관취소사유'	, type: 'string', comboType:'AU', comboCode:'J502'},
			{name: 'DRAFTER_NAME'			, text: '작성자'		, type: 'string'},
			{name: 'CONF_DRAFTER_NAME'		, text: '법무담당자'	, type: 'string'},
			{name: 'GWIF_ID'				, text: '결재연동번호'	, type: 'string'}
	   
	   ]
	});		// End of Ext.define('arc100skrModel', {
	  
			
	var directDetailStore = Unilite.createStore('Arc100skrdirectDetailStore',{
		model: 'Arc100skrModel',
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
                read: 'arc100skrService.selectList'                	
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
	    		fieldLabel: '등록일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'RECE_DATE_FR',
			    endFieldName: 'RECE_DATE_TO',
			    startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
			    allowBlank: false,                	
//			    holdable:'hold',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('RECE_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('RECE_DATE_TO', newValue);				    		
			    	}
			    }
			},{
				xtype: 'uniCombobox',
				fieldLabel: '채권구분',
				name:'RECE_GUBUN',	
			    comboType:'AU',
				comboCode:'J501',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RECE_GUBUN', newValue);
					}
				}
			},{ 
	    		fieldLabel: '이관일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'CONF_RECE_DATE_FR',
			    endFieldName: 'CONF_RECE_DATE_TO',
//			    startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('CONF_RECE_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('CONF_RECE_DATE_TO', newValue);				    		
			    	}
			    }
			},
			Unilite.popup('CUST',{
				fieldLabel: '거래처', 
				valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
			    validateBlank: false,
			    listeners: {
			    	onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);				
					}
				}
			}),
			Unilite.popup('Employee',{
				fieldLabel: '작성자', 
				valueFieldWidth: 90,
				textFieldWidth: 140,
				valueFieldName:'DRAFTER',
			    textFieldName:'DRAFTER_NAME',
			    listeners: {
			    	onValueFieldChange: function(field, newValue){
						panelResult.setValue('DRAFTER', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DRAFTER_NAME', newValue);				
					}
				}
			}),	
			
			{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				width:500,
	//			id:'tdPayDtlNo',
				tdAttrs: {width:500/*align : 'center'*/},
				items :[{
					xtype: 'uniCombobox',
					fieldLabel: '결재상태',
					name:'GW_STATUS',	
				    comboType:'AU',
					comboCode:'A134',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('GW_STATUS', newValue);
						}
					}
				},{
		    		xtype: 'uniCheckboxgroup',	
		    		fieldLabel: ' ',
	    			labelWidth:10,
		    		items: [{
		    			boxLabel: '반려제외',
		    			width: 130,
		    			name: 'Check_Opt',
		    			inputValue: 'Y',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('Check_Opt', newValue);
							}
						}
		    		}]
				}]
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				width:600,
	//			colspan:2,
				items :[{
					xtype: 'radiogroup',		            		
					fieldLabel: '접수상태',
	//				colspan:2,
//					id: 'asStatus',
					items: [{
						boxLabel: '전체', 
						width: 45,
						name: 'ACCEPT_STATUS',
						inputValue: '',
						checked: true  
					},{
						boxLabel: '미접수', 
						width: 55,
						name: 'ACCEPT_STATUS',
						inputValue: '1' 
					},{
						boxLabel: '접수', 
						width: 45,
						name: 'ACCEPT_STATUS',
						inputValue: '2'
					},{
						boxLabel: '마감', 
						width: 45,
						name: 'ACCEPT_STATUS',
						inputValue: '3'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('ACCEPT_STATUS').setValue(newValue.ACCEPT_STATUS);					
							}
						}
					},{
			    		xtype: 'uniCheckboxgroup',	
			    		fieldLabel: '',
			    		items: [{
			    			boxLabel: '마감제외',
//			    			width: 130,
			    			name: 'Check_Opt2',
			    			inputValue: 'Y',
							listeners: {
								change: function(field, newValue, oldValue, eOpts) {
									panelResult.setValue('Check_Opt2', newValue);
								}
							}
			    		}]
					}
				]
			},{
				xtype: 'uniCombobox',
				fieldLabel: '이관취소사유',
				name:'CANCEL_REASON',	
			    comboType:'AU',
				comboCode:'J502',
//				width:450,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CANCEL_REASON', newValue);
					}
				}
			}]	
		},{
			title: '추가정보',	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
	    		xtype:'uniTextfield',
	    		fieldLabel:'채권번호',
	    		name:'RECE_NO'
	    	},{
	    		xtype:'uniTextfield',
	    		fieldLabel:'이관채권번호',
	    		name:'CONF_RECE_NO'
	    	}]
		}]
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
    		fieldLabel: '등록일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'RECE_DATE_FR',
		    endFieldName: 'RECE_DATE_TO',
		    startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
		    allowBlank: false,                	
//			    holdable:'hold',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('RECE_DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('RECE_DATE_TO', newValue);				    		
		    	}
		    }
		},{
			xtype: 'uniCombobox',
			fieldLabel: '채권구분',
			name:'RECE_GUBUN',	
		    comboType:'AU',
			comboCode:'J501',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('RECE_GUBUN', newValue);
				}
			}
		},{ 
    		fieldLabel: '이관일',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'CONF_RECE_DATE_FR',
		    endFieldName: 'CONF_RECE_DATE_TO',
//		    startDate: UniDate.get('startOfMonth'),
//			endDate: UniDate.get('today'),
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('CONF_RECE_DATE_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('CONF_RECE_DATE_TO', newValue);				    		
		    	}
		    }
		},
		Unilite.popup('CUST',{
			fieldLabel: '거래처', 
			valueFieldName:'CUSTOM_CODE',
		    textFieldName:'CUSTOM_NAME',
		    validateBlank: false,
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);				
				}
			}
		}),
		Unilite.popup('Employee',{
			fieldLabel: '작성자', 
			valueFieldWidth: 90,
			textFieldWidth: 140,
			valueFieldName:'DRAFTER',
		    textFieldName:'DRAFTER_NAME',
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DRAFTER', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DRAFTER_NAME', newValue);				
				}
			}
		}),	
		
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:500,
//			id:'tdPayDtlNo',
			tdAttrs: {width:500/*align : 'center'*/},
			items :[{
				xtype: 'uniCombobox',
				fieldLabel: '결재상태',
				name:'GW_STATUS',	
			    comboType:'AU',
				comboCode:'A134',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('GW_STATUS', newValue);
					}
				}
			},{
	    		xtype: 'uniCheckboxgroup',	
	    		fieldLabel: ' ',
	    		labelWidth:10,
	    		items: [{
	    			boxLabel: '반려제외',
	    			width: 130,
	    			name: 'Check_Opt',
	    			inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('Check_Opt', newValue);
						}
					}
	    		}]
			}]
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:600,
//			colspan:2,
			items :[{
				xtype: 'radiogroup',		            		
				fieldLabel: '접수상태',
//				colspan:2,
//				id: 'asStatus',
				items: [{
					boxLabel: '전체', 
					width: 50,
					name: 'ACCEPT_STATUS',
					inputValue: '',
					checked: true  
				},{
					boxLabel: '미접수', 
					width: 60,
					name: 'ACCEPT_STATUS',
					inputValue: '1' 
				},{
					boxLabel: '접수', 
					width: 50,
					name: 'ACCEPT_STATUS',
					inputValue: '2'
				},{
					boxLabel: '마감', 
					width: 50,
					name: 'ACCEPT_STATUS',
					inputValue: '3'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('ACCEPT_STATUS').setValue(newValue.ACCEPT_STATUS);					
					}
				}
			},{
	    		xtype: 'uniCheckboxgroup',	
	    		fieldLabel: '',
	    		items: [{
	    			boxLabel: '마감제외',
	    			width: 130,
	    			name: 'Check_Opt2',
	    			inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('Check_Opt2', newValue);
						}
					}
	    		}]
			}]
		},{
			xtype: 'uniCombobox',
			fieldLabel: '이관취소사유',
			name:'CANCEL_REASON',	
		    comboType:'AU',
			comboCode:'J502',
//			width:450,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CANCEL_REASON', newValue);
				}
			}
		}]
	});
	
    /*
	 * Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var detailGrid = Unilite.createGrid('Arc100skrGrid', {
        region : 'center',
        excelTitle: '채권내역조회',
		store: directDetailStore,
//        selModel	: 'rowmodel',
		features: [{
    			id: 'detailGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: false
    		},{
    			id: 'detailGridTotal',		
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
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        /*viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
				if(record.get('TYPE_FLAG') == 'S'){
					return 'x-change-cell_Background_normal_Text_blue';	
				}
	        }
	    },*/
        columns:[
        	{dataIndex: 'GW_STATUS'										, width: 88,align:'center'},
        	{dataIndex: 'ACCEPT_STATUS'									, width: 88,align:'center'},
        	{dataIndex: 'RECE_DATE'										, width: 88},
        	{dataIndex: 'RECE_NO'										, width: 120},
        	{dataIndex: 'CUSTOM_CODE'									, width: 88},
        	{dataIndex: 'CUSTOM_NAME'									, width: 150},
        	{dataIndex: 'TOP_NAME'										, width: 80},
        	{dataIndex: 'RECE_AMT'										, width: 88},
        	{dataIndex: 'COLLECT_AMT'									, width: 88},
        	{dataIndex: 'TOT_ADJUST_AMT'								, width: 88},
        	{dataIndex: 'TOT_BALANCE_AMT'								, width: 88},
        	{dataIndex: 'TOT_DISPOSAL_AMT'								, width: 88},
        	{dataIndex: 'TOT_BOOKVALUE_AMT'								, width: 88},
        	{dataIndex: 'RECE_GUBUN'									, width: 88,align:'center'},
        	{dataIndex: 'MNG_GUBUN'										, width: 88,align:'center'},
        	{dataIndex: 'CONF_RECE_DATE'								, width: 88},
        	{dataIndex: 'CONF_RECE_NO'									, width: 88},
        	{dataIndex: 'CANCEL_REASON'									, width: 120,align:'center'},
        	{dataIndex: 'DRAFTER_NAME'									, width: 88},
        	{dataIndex: 'CONF_DRAFTER_NAME'								, width: 88},
        	{dataIndex: 'GWIF_ID'										, width: 88}
        ],
		uniRowContextMenu:{
			items: [
	            {	text: '채권등록 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		detailGrid.gotoArc100ukr(param.record);
	            	}
	        	}
	        ]
	    },
        listeners: {
	        itemmouseenter:function(view, record, item, index, e, eOpts )	{  
	        	view.ownerGrid.setCellPointer(view, item);
        	},
            onGridDblClick:function(grid, record, cellIndex, colName) {
                detailGrid.gotoArc100ukr(record);
            }
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{ 
      		return true;
      	},
		gotoArc100ukr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 'arc100skr',
					'RECE_NO' : record.data['RECE_NO']
					
					//파라미터 추후 추가
				}
		  		var rec1 = {data : {prgID : 'arc100ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/arc100ukr.do', params);
			}
    	}
    });   
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailGrid, panelResult
			]
		},
			panelSearch  	
		], 
		id : 'Arc100skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('RECE_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('RECE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('RECE_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('RECE_DATE_TO', UniDate.get('today'));
			
			
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('RECE_DATE_FR');
		},
		onQueryButtonDown : function()	{		
			if(!panelResult.getInvalidMessage()) return; //필수체크
				directDetailStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			this.fnInitBinding();
		}
	});	
};


</script>
