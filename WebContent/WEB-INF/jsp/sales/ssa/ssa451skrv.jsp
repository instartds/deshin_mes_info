<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa451skrv" >
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa451skrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/> <!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 정산여부 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Ssa451skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'						, text: 'COMP_CODE'	, type: 'string'},
	    	{name: 'DIV_CODE'						, text: 'DIV_CODE'	, type: 'string'},
	    	{name: 'CUSTOM_CODE'					, text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'					, text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'		, type: 'string'},
	    	{name: 'SALE_DATE'						, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'		, type: 'uniDate'},
	    	{name: 'SALE_PRSN'						, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'		, type: 'string'},
	    	{name: 'CREATE_LOC'						, text: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'		, type: 'string'},
	    	{name: 'BILL_NUM'						, text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'		, type: 'string'},
	    	{name: 'BILL_SEQ'						, text: '<t:message code="system.label.sales.seq" default="순번"/>'		, type: 'string'},
	    	{name: 'ITEM_CODE'						, text: '<t:message code="system.label.sales.item" default="품목"/>'		, type: 'string'},
	    	{name: 'ITEM_NAME'						, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		, type: 'string'},
	    	{name: 'SPEC'			 				, text: '<t:message code="system.label.sales.spec" default="규격"/>'		, type: 'string'},
	    	{name: 'SALE_UNIT'						, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'		, type: 'string'},
	    	{name: 'SALE_Q'			 				, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'QUANTITY'						, text: '잔량'		, type: 'uniQty'},
	    	{name: 'SALE_P'			 				, text: '<t:message code="system.label.sales.price" default="단가"/>'		, type: 'uniUnitPrice'},
	    	{name: 'WGT_UNIT'						, text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'		, type: 'string'},
	    	{name: 'UNIT_WGT'						, text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'		, type: 'string'},
	    	{name: 'SALE_WGT_Q'						, text: '수량(중량)'	, type: 'uniQty'},
	    	{name: 'SALE_FOR_WGT_P'					, text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'	, type: 'uniUnitPrice'},
	    	{name: 'VOL_UNIT'						, text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'		, type: 'string'},
	    	{name: 'UNIT_VOL'						, text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'		, type: 'string'},
	    	{name: 'SALE_VOL_Q'						, text: '수량(부피)'	, type: 'uniQty'},
	    	{name: 'SALE_FOR_VOL_P'					, text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'	, type: 'uniUnitPrice'},
	    	{name: 'SALE_LOC_AMT_I'					, text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'		, type: 'uniPrice'},
	    	{name: 'TAX_AMT_O'						, text: '<t:message code="system.label.sales.taxamount" default="세액"/>'		, type: 'uniPrice'},
	    	{name: 'TOT_SALE_AMT_O'					, text: '<t:message code="system.label.sales.totalamount" default="합계"/>'		, type: 'string'},
	    	{name: 'INOUT_DATE'		 				, text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'		, type: 'uniDate'},
	    	{name: 'INOUT_NUM'		 				, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'		, type: 'string'},
	    	{name: 'INOUT_SEQ'		 				, text: '<t:message code="system.label.sales.issueseq" default="출고순번"/>'		, type: 'string'},
	    	{name: 'ORDER_UNIT'		 				, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'		, type: 'string'},
	    	{name: 'ORDER_UNIT_Q'					, text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'		, type: 'uniQty'},
	    	{name: 'ORDER_UNIT_P'					, text: '<t:message code="system.label.sales.issueprice" default="출고단가"/>'		, type: 'uniUnitPrice'},
	    	{name: 'INOUT_WGT_Q'					, text: '수량(중량)'	, type: 'uniQty'},
	    	{name: 'INOUT_FOR_WGT_P'				, text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'	, type: 'uniUnitPrice'},
	    	{name: 'INOUT_VOL_Q'					, text: '수량(부피)'	, type: 'uniQty'},
	    	{name: 'INOUT_FOR_VOL_P'				, text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'	, type: 'uniUnitPrice'},
	    	{name: 'ISSUE_REQ_NUM'					, text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	, type: 'string'},
	    	{name: 'ISSUE_REQ_SEQ'					, text: '출하지시순번'	, type: 'string'},
	    	{name: 'ORDER_NUM'		 				, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'		, type: 'string'},
	    	{name: 'ORDER_SEQ'		 				, text: '<t:message code="system.label.sales.soseq" default="수주순번"/>'		, type: 'string'}
	    ]
	});//End of Unilite.defineModel('Ssa451skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa451skrvMasterStore1', {
		model: 'Ssa451skrvModel',
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
				read: 'ssa451skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
				
		},
		groupField: ''
			
	});//End of var directMasterStore1 = Unilite.createStore('ssa451skrvMasterStore1', {
	
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
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
			},{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			},
				Unilite.popup('AGENT_CUST',{
					fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>', 
					
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
				}),
			{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>', 
				name: 'SALES_PRSN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'S010',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SALES_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>', 
				name: 'CREATE_LOC', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B031',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CREATE_LOC', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>', 
					
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				})]
		},{
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '정산여부', 
				name: 'CALCULATE_YN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'A020'/*,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CALCULATE_YN', newValue);
					}
				}*/
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
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
		},{
			fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_FR',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('ORDER_DATE_TO',newValue);
		    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
		},
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>', 
				
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
			}),
		{
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>', 
			name: 'SALES_PRSN', 
			xtype: 'uniCombobox', 
			comboType: 'AU', 
			comboCode: 'S010',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SALES_PRSN', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>', 
			name: 'CREATE_LOC', 
			xtype: 'uniCombobox', 
			comboType: 'AU', 
			comboCode: 'B031',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CREATE_LOC', newValue);
				}
			}
		},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>', 
				
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			})/*,
		{
			fieldLabel: '정산여부', 
			name: 'CALCULATE_YN', 
			xtype: 'uniCombobox', 
			comboType: 'AU', 
			comboCode: 'A020',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CALCULATE_YN', newValue);
				}
			}
		}*/]	
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('ssa451skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		uniOpt: {
			expandLastColumn: false
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
    	store: directMasterStore1,
        columns: [
        	{dataIndex: 'COMP_CODE'					, width:66,hidden:true},
        	{dataIndex: 'DIV_CODE'					, width:66,hidden:true},
        	{dataIndex: 'CUSTOM_CODE'				, width:66,hidden:true},
        	{dataIndex: 'CUSTOM_NAME'				, width:166,locked:true},
        	{dataIndex: 'SALE_DATE'					, width:66,locked:true},
        	{dataIndex: 'SALE_PRSN'					, width:80,locked:true},
        	{dataIndex: 'CREATE_LOC'				, width:80,locked:true},
        	{dataIndex: 'BILL_NUM'					, width:100,locked:true},
        	{dataIndex: 'BILL_SEQ'					, width:66,locked:true},
        	{dataIndex: 'ITEM_CODE'					, width:100},
        	{dataIndex: 'ITEM_NAME'					, width:166},
        	{dataIndex: 'SPEC'						, width:133},
        	{dataIndex: 'SALE_UNIT'					, width:66},
        	{dataIndex: 'SALE_Q'					, width:93},
        	{dataIndex: 'QUANTITY'					, width:93},
        	{dataIndex: 'SALE_P'					, width:106},
        	{dataIndex: 'WGT_UNIT'					, width:80,hidden:true},
        	{dataIndex: 'UNIT_WGT'					, width:80,hidden:true},
        	{dataIndex: 'SALE_WGT_Q'				, width:93,hidden:true},
        	{dataIndex: 'SALE_FOR_WGT_P'			, width:106,hidden:true},
        	{dataIndex: 'VOL_UNIT'					, width:80,hidden:true},
        	{dataIndex: 'UNIT_VOL'					, width:80,hidden:true},
        	{dataIndex: 'SALE_VOL_Q'				, width:93,hidden:true},
        	{dataIndex: 'SALE_FOR_VOL_P'			, width:106,hidden:true},
        	{dataIndex: 'SALE_LOC_AMT_I'			, width:106},
        	{dataIndex: 'TAX_AMT_O'					, width:93},
        	{dataIndex: 'TOT_SALE_AMT_O'			, width:106},
        	{dataIndex: 'INOUT_DATE'				, width:80},
        	{dataIndex: 'INOUT_NUM'					, width:100},
        	{dataIndex: 'INOUT_SEQ'					, width:66},
        	{dataIndex: 'ORDER_UNIT'				, width:66},
        	{dataIndex: 'ORDER_UNIT_Q'				, width:93},
        	{dataIndex: 'ORDER_UNIT_P'				, width:106},
        	{dataIndex: 'INOUT_WGT_Q'				, width:93,hidden:true},
        	{dataIndex: 'INOUT_FOR_WGT_P'			, width:106,hidden:true},
        	{dataIndex: 'INOUT_VOL_Q'				, width:93,hidden:true},
        	{dataIndex: 'INOUT_FOR_VOL_P'			, width:106,hidden:true},
        	{dataIndex: 'ISSUE_REQ_NUM'				, width:100},
        	{dataIndex: 'ISSUE_REQ_SEQ'				, width:100},
        	{dataIndex: 'ORDER_NUM'					, width:100},
        	{dataIndex: 'ORDER_SEQ'					, width:100}
		] 
    });//End of var masterGrid = Unilite.createGrid('ssa451skrvGrid1', {  
	
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
		id: 'ssa451skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function() {			
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
