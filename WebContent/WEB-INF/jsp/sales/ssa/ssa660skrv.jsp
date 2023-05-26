<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa660skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa660skrv"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> <!-- 세금계산서종류 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	    			
	Unilite.defineModel('Ssa660skrvModel1', {
	    fields: [{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'},
	    		 {name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		,type: 'string'},
	    		 {name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'		,type: 'string'},
	    		 {name: 'UN_COLLECT_AMT'		,text: '<t:message code="system.label.sales.lastdayar" default="전일미수"/>'		,type: 'uniPrice'},
	    		 {name: 'SALE_LOC_AMT_I'		,text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'		,type: 'uniPrice'},
	    		 {name: 'TAX_AMT_O'				,text: '<t:message code="system.label.sales.vat" default="부가세"/>'		,type: 'uniPrice'},
	    		 {name: 'TOT_SALE_AMT'			,text: '<t:message code="system.label.sales.salestotal" default="매출계"/>'		,type: 'uniPrice'},
	    		 {name: 'CASH_COLLECT_AMT'		,text: '현금수금'		,type: 'uniPrice'},
	    		 {name: 'NOTE_COLLECT_AMT'		,text: '어음수금'		,type: 'uniPrice'},
	    		 {name: 'TOT_COLLECT_AMT'		,text: '수금계'		,type: 'uniPrice'},
	    		 {name: 'TOT_CREDIT_AMT'		,text: '여신(담보)액'	,type: 'uniPrice'},
	    		 {name: 'CREDIT_AMT'			,text: '신용여신액'	,type: 'uniPrice'},
	    		 {name: 'CREDIT_YMD'			,text: '신용여신만료일'	,type: 'uniDate'},
	    		 {name: 'SECURITY_AMT'			,text: '여신계'		,type: 'uniPrice'},
	    		 {name: 'GET_NOTE_AMT'			,text: '어음금액'		,type: 'uniPrice'},
	    		 {name: 'GET_NOTE_AMT2'			,text: '인정금액'		,type: 'uniPrice'},
	    		 {name: 'GRANT_UN_COLLECT_AMT'	,text: '<t:message code="system.label.sales.creditbalance" default="여신잔액"/>'		,type: 'uniPrice'},
	    		 {name: 'CARD_AMT_O'			,text: '카드매출'		,type: 'uniPrice'},
	    		 {name: 'SALE_PRSN'				,text: '주영업담당'	,type: 'string',comboType: 'AU', comboCode: 'S010'},
	    		 {name: 'DIV_CODE'				,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'},
	    		 {name: 'AGENT_TYPE'			,text: '<t:message code="system.label.sales.customclass" default="거래처분류"/>'	,type: 'string',comboType: 'AU', comboCode: 'B055'},
	    		 {name: 'AREA_TYPE'				,text: '<t:message code="system.label.sales.area" default="지역"/>'			,type: 'string',comboType: 'AU', comboCode: 'B056'}
		]
	});	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa660skrvMasterStore1',{
			model: 'Ssa660skrvModel1',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ssa660skrvService.selectList1'                	
                }
            }
			,loadStoreRecords: function()	{	
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});
			}
	});
	


	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	    
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
        	items: [{	
        		xtype: 'container',
				layout: {type: 'uniTable', columns: 1},
			 	items: [{
			 		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			 		name: 'DIV_CODE',
			 		xtype: 'uniCombobox',
			 		comboType: 'BOR120', 
			 		allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
			 	}, {
			 		fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
			 		name: 'AGENT_TYPE',
			 		xtype: 'uniCombobox', 
			 		comboType: 'AU',
			 		comboCode: 'B055',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AGENT_TYPE', newValue);
						}
					}
			 	}, /*{
			 		fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
			 		name: 'ORDER_PRSN', 
			 		xtype: 'uniCombobox',
			 		comboType: 'AU',
			 		comboCode: 'S010'
			 	},*/ {
			 		fieldLabel: '여신일',
		            xtype: 'uniDateRangefield',
		            startFieldName: 'FR_DATE',
		            endFieldName: 'TO_DATE',
		            startDate: UniDate.get('startOfMonth'),
		            endDate: UniDate.get('today'),
		            allowBlank: false,
		            width: 315,                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_DATE',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TO_DATE',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
		        },
		        	Unilite.popup('AGENT_CUST',{ 
		        	fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
		        	
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					}
				})]
						
			 }]
		}, {
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
				name: 'TXT_AREA_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B056'
			}, {
				fieldLabel: '<t:message code="system.label.sales.creditbalance" default="여신잔액"/>'	,
				name: 'FR_AMT',
				suffixTpl: '&nbsp;이상'
			}, {
				fieldLabel: '~',
				name: 'TO_AMT',
				suffixTpl: '&nbsp;이하'
			}, {
				fieldLabel: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'	,
				name: 'BASE_MONEY',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				value: 'KRW',
				displayField: 'value',
				readOnly: true,
				fieldStyle: 'text-align: center;'
			}]
		}]
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
	 		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
	 		name: 'DIV_CODE',
	 		xtype: 'uniCombobox',
	 		comboType: 'BOR120', 
	 		allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
	 	}, {
	 		fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
	 		name: 'AGENT_TYPE',
	 		xtype: 'uniCombobox', 
	 		comboType: 'AU',
	 		comboCode: 'B055',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('AGENT_TYPE', newValue);
				}
			}
	 	}, /*{
	 		fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
	 		name: 'ORDER_PRSN', 
	 		xtype: 'uniCombobox',
	 		comboType: 'AU',
	 		comboCode: 'S010'
	 	},*/ {
	 		fieldLabel: '여신일',
            xtype: 'uniDateRangefield',
            startFieldName: 'FR_DATE',
            endFieldName: 'TO_DATE',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank: false,
            width: 315,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_DATE',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE',newValue);
		    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
        },
        	Unilite.popup('AGENT_CUST',{ 
        	fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
        	
        	listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
		})]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */

    var masterGrid = Unilite.createGrid('ssa660skrvGrid1', {
    	// for tab 
		region: 'center',  	
        layout: 'fit',        
    	store: directMasterStore1,
    	uniOpt: {useRowNumberer: false},
    	features: [{id: 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false} ],    	           	
        columns:  [{ dataIndex: 'CUSTOM_CODE'				      	,		   	width: 100, hidden: true	},
        		   { dataIndex: 'CUSTOM_NAME'				      	,		   	width: 126, 
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
        			{ dataIndex: 'MONEY_UNIT'				      	,		   	width: 100, align: 'center'	},
        			{ dataIndex: 'UN_COLLECT_AMT'			      	,		   	width: 140, summaryType: 'sum'},        			
        			{text: '매출내역',
        				columns: [ 
			        			 { dataIndex: 'SALE_LOC_AMT_I'			      	,		   	width: 123, summaryType: 'sum'	},
			        			 { dataIndex: 'TAX_AMT_O'					  	,		   	width: 123, summaryType: 'sum'	},
			        			 { dataIndex: 'TOT_SALE_AMT'				      	,		   	width: 123, summaryType: 'sum'	}
			        	]
        			},
        			{text: '<t:message code="system.label.sales.collectiondetails" default="수금내역"/>',
        				columns: [
        						 { dataIndex: 'CASH_COLLECT_AMT'			      	,		   	width: 123, summaryType: 'sum'	},
				        		 { dataIndex: 'NOTE_COLLECT_AMT'			      	,		   	width: 123, summaryType: 'sum'	},
				        		 { dataIndex: 'TOT_COLLECT_AMT'			      	,		   	width: 123, summaryType: 'sum'	}
        				]
        			}
        			,{text: '여신내역',
        				columns: [
        						 { dataIndex: 'TOT_CREDIT_AMT'			      	,		   	width: 123, summaryType: 'sum'	},
			        			 { dataIndex: 'CREDIT_AMT'				      	,		   	width: 123, summaryType: 'sum'	},
			        			 { dataIndex: 'CREDIT_YMD'				      	,		   	width: 106	},
			        			 { dataIndex: 'SECURITY_AMT'				      	,		   	width: 123, summaryType: 'sum'	}        				
        				]
        			}
        			,{text: '미래도어음',
        				columns: [
        						 { dataIndex: 'GET_NOTE_AMT'				      	,		   	width: 123, summaryType: 'sum'	},
        						 { dataIndex: 'GET_NOTE_AMT2'				   	,		   	width: 123, summaryType: 'sum'	}
        				]        				
        			},
        			{ dataIndex: 'GRANT_UN_COLLECT_AMT'		      	,		   	width: 123, summaryType: 'sum'	},
        			{ dataIndex: 'CARD_AMT_O'				      	,		   	width: 106, summaryType: 'sum'	},
        			{ dataIndex: 'SALE_PRSN'					   	,		   	width: 100	},
        			{ dataIndex: 'DIV_CODE'					      	,		   	width: 100, hidden: true	},
        			{ dataIndex: 'AGENT_TYPE'				      	,		   	width: 100	},
        			{ dataIndex: 'AREA_TYPE'					   	,		   	width: 100	}
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
		id : 'ssa660skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function()	{		
			
			masterGrid.getStore().loadStoreRecords();			
			
			var view = masterGrid.getView();			
			view.getFeature('masterGridTotal').toggleSummaryRow(true);			
		},
		onDetailButtonDown: function() {
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