<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo240skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo240skrv" /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="YP42" /> 					<!--발송결과-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}'
};
function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Mpo240skrvModel', {
	    fields: [
	    	{name: 'ITEM_GROUP'					, text: '<t:message code="system.label.purchase.representationitemcode" default="대표품목코드"/>'		, type: 'string'},
	    	{name: 'ITEM_GROUP_NAME'			, text: '<t:message code="system.label.purchase.representationitemname" default="대표품목명"/>'		, type: 'string'},
	    	{name: 'RECEIPT_TYPE'				, text: '계획코드'		, type: 'string'},
	    	{name: 'RECEIPT_NAME'				, text: '생산계획명'		, type: 'string'},
	    	{name: 'RECEIPT_SPEC'				, text: '생산계획규격'	, type: 'string'},
	    	{name: 'LC_NUM'						, text: '계획월'			, type: 'string'},
	    	{name: 'WK_PLAN_Q'					, text: '계획수량'		, type: 'uniQty'},
	    	{name: 'ITEM_CODE'					, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
	    	{name: 'ITEM_NAME'					, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
	    	{name: 'SPEC'						, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
	    	{name: 'ORDER_DATE'					, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			, type: 'string'},
	    	{name: 'DVRY_DATE'					, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},
	    	{name: 'ORDER_Q'					, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'			, type: 'uniQty'},
	    	{name: 'ORDER_P'					, text: '<t:message code="system.label.purchase.pounitprice" default="발주단가"/>'		, type: 'uniPrice'},
	    	{name: 'ORDER_O'					, text: '<t:message code="system.label.purchase.poamount" default="발주금액"/>'		, type: 'uniPrice'},
	    	{name: 'TEMP_INOUT_Q'				, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'			, type: 'uniQty'},
	    	{name: 'TEMP_INOUT_DATE'			, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'			, type: 'uniDate'},
	    	{name: 'INSTOCK_Q'					, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'			, type: 'uniQty'},
	    	{name: 'INSTOCK_O'					, text: '입고금액'		, type: 'uniPrice'},
	    	{name: 'END_ORDER_Q'				, text: '마감량'			, type: 'uniQty'},
	    	{name: 'END_ORDER_O'				, text: '마감금액'		, type: 'uniPrice'},
	    	{name: 'PROJECT_NO'					, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'	, type: 'string'},
	    	{name: 'PJT_NAME'					, text: '<t:message code="system.label.purchase.projectname" default="프로젝트명"/>'		, type: 'string'},
	    	{name: 'REMARK1'					, text: '프로젝트 내역'	, type: 'string'},
	    	{name: 'CUSTOM_CODE'				, text: ''				, type: 'string'},
	    	{name: 'CUSTOM_NAME'				, text: ''				, type: 'string'},
	    	{name: 'AGREE_STATUS'				, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		, type: 'string'},
	    	{name: 'CONTROL_STATUS'				, text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'		, type: 'string'},
	    	{name: 'ORDER_NUM'					, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'		, type: 'string'}
	    ]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo240skrvService.selectList',
			update: 'mpo240skrvService.updateDetail',
			syncAll: 'mpo240skrvService.saveAll'
		}
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('mpo240skrvMasterStore1', {
		model: 'Mpo240skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});				
		},			
		groupField: 'PROJECT_NO'
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
	        	fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'ORDER_DATE_FR',
	        	endFieldName:'ORDER_DATE_TO',
	        	width: 315,
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
	            		panelResult.setValue('ORDER_DATE_FR',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},Unilite.popup('DIV_PUMOK', { 
				fieldLabel: '<t:message code="system.label.purchase.representationitemcode" default="대표품목코드"/>', 
				valueFieldName: 'ITEM_GROUP', 
				textFieldName: 'ITEM_GROUP_NAME', 
//				validateBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
	                        panelSearch.setValue('ITEM_GROUP', panelResult.getValue('ITEM_GROUP'));
	                        panelSearch.setValue('ITEM_GROUP_NAME', panelResult.getValue('ITEM_GROUP_NAME'));
	                    },
	                    scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_GROUP', '');
	                    panelSearch.setValue('ITEM_GROUP_NAME', '');
					},
					applyextparam: function(popup){							
					}
				}
			}),Unilite.popup('CUST', {
	            fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
	            valueFieldName: 'CUSTOM_CODE_FR', 
	            textFieldName: 'CUSTOM_NAME_FR', 
	            listeners: {
	                onSelected: {
	                    fn: function(records, type) {
	                        panelSearch.setValue('CUSTOM_CODE_FR', panelResult.getValue('CUSTOM_CODE_FR'));
	                        panelSearch.setValue('CUSTOM_NAME_FR', panelResult.getValue('CUSTOM_NAME_FR'));
	                    },
	                    scope: this
	                },
	                onClear: function(type) {
	                    panelSearch.setValue('CUSTOM_CODE_FR', '');
	                    panelSearch.setValue('CUSTOM_NAME_FR', '');
	                },
	                applyextparam: function(popup){
	                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
	                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
	                }
	            }
	        }),Unilite.popup('CUST', {
	            fieldLabel: '~', 
	            valueFieldName: 'CUSTOM_CODE_TO', 
	            textFieldName: 'CUSTOM_NAME_TO', 
	            colspan: 2,
	            listeners: {
	                onSelected: {
	                    fn: function(records, type) {
	                        panelSearch.setValue('CUSTOM_CODE_TO', panelResult.getValue('CUSTOM_CODE_TO'));
	                        panelSearch.setValue('CUSTOM_NAME_TO', panelResult.getValue('CUSTOM_NAME_TO'));
	                    },
	                    scope: this
	                },
	                onClear: function(type) {
	                    panelSearch.setValue('CUSTOM_CODE_TO', '');
	                    panelSearch.setValue('CUSTOM_NAME_TO', '');
	                },
	                applyextparam: function(popup){
	                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
	                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
	                }
	            }
	        }),Unilite.popup('DIV_PUMOK', { 
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>', 
				valueFieldName: 'ITEM_CODE_FR', 
				textFieldName: 'ITEM_NAME_FR', 
				listeners: {
					onSelected: {
						fn: function(records, type) {
	                        panelSearch.setValue('ITEM_CODE_FR', panelResult.getValue('ITEM_CODE_FR'));
	                        panelSearch.setValue('ITEM_NAME_FR', panelResult.getValue('ITEM_NAME_FR'));
	                    },
	                    scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE_FR', '');
	                    panelSearch.setValue('ITEM_NAME_FR', '');
					},
					applyextparam: function(popup){							
					}
				}
			}),Unilite.popup('DIV_PUMOK', { 
				fieldLabel: '~', 
				valueFieldName: 'ITEM_CODE_TO', 
				textFieldName: 'ITEM_NAME_TO', 
				listeners: {
					onSelected: {
						fn: function(records, type) {
	                        panelSearch.setValue('ITEM_CODE_TO', panelResult.getValue('ITEM_CODE_TO'));
	                        panelSearch.setValue('ITEM_NAME_TO', panelResult.getValue('ITEM_NAME_TO'));
	                    },
	                    scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE_TO', '');
	                    panelSearch.setValue('ITEM_NAME_TO', '');
					},
					applyextparam: function(popup){							
					}
				}
			})]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType: 'BOR120', 
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
        	fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
        	xtype: 'uniDateRangefield',
        	startFieldName: 'ORDER_DATE_FR',
        	endFieldName:'ORDER_DATE_TO',
        	width: 315,
        	allowBlank: false,
        	startDate: UniDate.get('startOfMonth'),
        	endDate: UniDate.get('today'),
        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
            		panelSearch.setValue('ORDER_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('ORDER_DATE_TO',newValue);
		    	}
		    }
		},Unilite.popup('DIV_PUMOK', { 
			fieldLabel: '<t:message code="system.label.purchase.representationitemcode" default="대표품목코드"/>', 
			valueFieldName: 'ITEM_GROUP', 
			textFieldName: 'ITEM_GROUP_NAME', 
			listeners: {
				onSelected: {
					fn: function(records, type) {
                        panelSearch.setValue('ITEM_GROUP', panelResult.getValue('ITEM_GROUP'));
                        panelSearch.setValue('ITEM_GROUP_NAME', panelResult.getValue('ITEM_GROUP_NAME'));
                    },
                    scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ITEM_GROUP', '');
                    panelSearch.setValue('ITEM_GROUP_NAME', '');
				},
				applyextparam: function(popup){							
				}
			}
		}),Unilite.popup('CUST', {
            fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
            valueFieldName: 'CUSTOM_CODE_FR', 
            textFieldName: 'CUSTOM_NAME_FR', 
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('CUSTOM_CODE_FR', panelResult.getValue('CUSTOM_CODE_FR'));
                        panelSearch.setValue('CUSTOM_NAME_FR', panelResult.getValue('CUSTOM_NAME_FR'));
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('CUSTOM_CODE_FR', '');
                    panelSearch.setValue('CUSTOM_NAME_FR', '');
                },
                applyextparam: function(popup){
                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                }
            }
        }),Unilite.popup('CUST', {
            fieldLabel: '~', 
            valueFieldName: 'CUSTOM_CODE_TO', 
            textFieldName: 'CUSTOM_NAME_TO', 
            colspan: 2,
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('CUSTOM_CODE_TO', panelResult.getValue('CUSTOM_CODE_TO'));
                        panelSearch.setValue('CUSTOM_NAME_TO', panelResult.getValue('CUSTOM_NAME_TO'));
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('CUSTOM_CODE_TO', '');
                    panelSearch.setValue('CUSTOM_NAME_TO', '');
                },
                applyextparam: function(popup){
                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                }
            }
        }),Unilite.popup('DIV_PUMOK', { 
			fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>', 
			valueFieldName: 'ITEM_CODE_FR', 
			textFieldName: 'ITEM_NAME_FR', 
			listeners: {
				onSelected: {
					fn: function(records, type) {
                        panelSearch.setValue('ITEM_CODE_FR', panelResult.getValue('ITEM_CODE_FR'));
                        panelSearch.setValue('ITEM_NAME_FR', panelResult.getValue('ITEM_NAME_FR'));
                    },
                    scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ITEM_CODE_FR', '');
                    panelSearch.setValue('ITEM_NAME_FR', '');
				},
				applyextparam: function(popup){							
				}
			}
		}),Unilite.popup('DIV_PUMOK', { 
			fieldLabel: '~', 
			valueFieldName: 'ITEM_CODE_TO', 
			textFieldName: 'ITEM_NAME_TO', 
			listeners: {
				onSelected: {
					fn: function(records, type) {
                        panelSearch.setValue('ITEM_CODE_TO', panelResult.getValue('ITEM_CODE_TO'));
                        panelSearch.setValue('ITEM_NAME_TO', panelResult.getValue('ITEM_NAME_TO'));
                    },
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ITEM_CODE_TO', '');
                    panelSearch.setValue('ITEM_NAME_TO', '');
				},
				applyextparam: function(popup){							
				}
			}
		})]
    });		
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('mpo240skrvGrid1', {
		layout: 'fit',
		region: 'center',
		excelTitle: '생산계획대비발주현황조회',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst : false,
    		filter: {
				useFilter: false,
				autoCreate: false
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
    	store: directMasterStore,
        columns: [        
        	{dataIndex: 'ITEM_GROUP'				, width: 100,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              		return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
                }},
	    	{dataIndex: 'ITEM_GROUP_NAME'			, width: 100},
	    	{dataIndex: 'RECEIPT_TYPE'				, width: 100},
	    	{dataIndex: 'RECEIPT_NAME'				, width: 100},
	    	{dataIndex: 'RECEIPT_SPEC'				, width: 120},
	    	{dataIndex: 'LC_NUM'					, width: 80},
	    	{dataIndex: 'WK_PLAN_Q'					, width: 100},
	    	{dataIndex: 'ITEM_CODE'					, width: 100},
	    	{dataIndex: 'ITEM_NAME'					, width: 150},
	    	{dataIndex: 'SPEC'						, width: 120},
	    	{dataIndex: 'ORDER_DATE'				, width: 100 , align:'center'},
	    	{dataIndex: 'DVRY_DATE'					, width: 100 , align:'center'},
	    	{dataIndex: 'ORDER_Q'					, width: 100,summaryType: 'sum'},
	    	{dataIndex: 'ORDER_P'					, width: 100},
	    	{dataIndex: 'ORDER_O'					, width: 100,summaryType: 'sum'},
	    	{dataIndex: 'TEMP_INOUT_Q'				, width: 100,summaryType: 'sum'},
	    	{dataIndex: 'TEMP_INOUT_DATE'			, width: 100},
	    	{dataIndex: 'INSTOCK_Q'					, width: 100,summaryType: 'sum'},
	    	{dataIndex: 'INSTOCK_O'					, width: 100,summaryType: 'sum'},
	    	{dataIndex: 'END_ORDER_Q'				, width: 100,summaryType: 'sum'},
	    	{dataIndex: 'END_ORDER_O'				, width: 100,summaryType: 'sum'},
	    	{dataIndex: 'PROJECT_NO'				, width: 100},
	    	{dataIndex: 'PJT_NAME'					, width: 120},
	    	{dataIndex: 'REMARK1'					, width: 120},
	    	{dataIndex: 'AGREE_STATUS'				, width: 80 , align:'center'},
	    	{dataIndex: 'CONTROL_STATUS'			, width: 100},
	    	{dataIndex: 'ORDER_NUM'					, width: 100}
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
		id: 'mpo240skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('TR_SENDDATE_FR',UniDate.get('today'));
			panelSearch.setValue('TR_SENDDATE_TO',UniDate.get('today'));
			panelSearch.setValue('TR_NAME', '');
			panelSearch.setValue('TR_PHONE', '');
			
			panelResult.setValue('TR_SENDDATE_FR',UniDate.get('today'));
			panelResult.setValue('TR_SENDDATE_TO',UniDate.get('today'));
			panelResult.setValue('TR_NAME', '');
			panelResult.setValue('TR_PHONE', '');
			
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown: function() {	
			masterGrid.getStore().loadStoreRecords();			
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		}
	});
};


</script>
