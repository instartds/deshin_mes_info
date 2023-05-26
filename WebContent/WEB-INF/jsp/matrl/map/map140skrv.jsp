<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map140skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map140skrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M103" /> <!-- 입고유형? -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 수불담당 -->
	<t:ExtComboStore comboType="O" />    <!-- 창고   -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	
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

	Unilite.defineModel('Map140skrvModel', {
		fields: [
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
	    	{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
	    	{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		, type: 'string'},
	    	{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'		, type: 'string'},
	    	{name: 'CUSTOM_CODE'	    , text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'	, type: 'string'},
	    	{name: 'INOUT_DATE'			, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'		, type: 'uniDate'},
	    	{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'	, type: 'string',comboType:'AU', comboCode:'B024' },
	    	{name: 'UNACCOUNT_Q'	    , text: '<t:message code="system.label.purchase.pendingpurchaseqty" default="미매입량"/>'		, type: 'uniQty'},
	    	{name: 'INOUT_Q'	      	, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'		, type: 'uniQty'},
	    	{name: 'ACCOUNT_Q'	      	, text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'		, type: 'uniQty'},
	    	{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'		, type: 'string'},
	    	{name: 'INOUT_FOR_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'		, type: 'uniUnitPrice'},
	    	{name: 'UNACCOUNT_O'		, text: '<t:message code="system.label.purchase.pendingpruchaseamount" default="미매입액"/>'		, type: 'uniPrice'},
	    	{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'		, type: 'uniER'},
	    	{name: 'CON_O'				, text: '<t:message code="system.label.purchase.exchangeamount" default="환산액"/>'		, type: 'uniPrice'},
	    	{name: 'INOUT_TYPE'			, text: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>'		, type: 'string'},
	    	{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'		, type: 'string'},
	    	{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'		, type: 'string'},
	    	{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.purchase.receiptseq2" default="입고순번"/>'		, type: 'string'},
	    	{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		, type: 'string'},
	    	{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'}
		]
	});//End of Unilite.defineModel('Map140skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('map140skrvMasterStore1', {
		model: 'Map140skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'map140skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
				this.load({
					params: param
				});
		},
		groupField: 'ITEM_CODE',
		listeners:{
			load:function( store, records, successful, operation, eOpts )	{
				if(records && records.length > 0){
					masterGrid.setShowSummaryRow(true);
				}
			}
        }
});//End var directMasterStore1 = Unilite.createStore('map140skrvMasterStore1', {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WH_CODE', '');
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_FR_DATE',
				endFieldName: 'ORDER_TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_TO_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>', 
				name: 'ORDER_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			}
		]},{
			title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>', 
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				comboType  : 'O',
				listeners: {
                        beforequery:function( queryPlan, eOpts )   {
                            var store = queryPlan.combo.store;
                                store.clearFilter();
                            if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                                store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            })
                            }else{
                                store.filterBy(function(record){
                                return false;   
                            })
                        }
                      }
                    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>', 
				name: 'INOUT_TYPE_DETAIL', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M103'
			},
				Unilite.popup('DIV_PUMOK', { 
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>', 
					valueFieldName	: 'ITEM_CODE',	// 2021.08 표준화 작업
					textFieldName	: 'ITEM_NAME',	// 2021.08 표준화 작업
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_NAME', '');
										panelResult.setValue('ITEM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_CODE', '');
										panelResult.setValue('ITEM_CODE', '');
									}
								},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				}),
				Unilite.popup('CUST', { 
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
					valueFieldName	: 'CUSTOM_CODE',	// 2021.08 표준화 작업
					textFieldName	: 'CUSTOM_NAME',	// 2021.08 표준화 작업
					validateBlank: false,
					extParam: {'CUSTOM_TYPE': ['1','2']},
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('CUSTOM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('CUSTOM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('CUSTOM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('CUSTOM_CODE', '');
									}
								}
						}
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}
	
					   	alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_FR_DATE',
				endFieldName: 'ORDER_TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('ORDER_FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ORDER_TO_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>', 
				name: 'ORDER_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ORDER_TYPE', newValue);
					}
				}
			}
			
		
		]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('map140skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region:'center',
		excelTitle: '<t:message code="system.label.purchase.pendingslipstatus" default="미지급결의현황 조회"/>',
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
			{dataIndex: 'ITEM_CODE'			, width: 106, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.itemtotal" default="품목계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
            }
			}, 				
			{dataIndex: 'ITEM_NAME'			, width: 200, locked: true},
			{dataIndex: 'SPEC'				, width: 100},
			{dataIndex: 'STOCK_UNIT'		, width: 66,align:'center'},
			{dataIndex: 'CUSTOM_NAME'		, width: 136},
			{dataIndex: 'CUSTOM_CODE'		, width: 133, hidden: true},
			{dataIndex: 'INOUT_DATE'		, width: 93},
			{dataIndex: 'INOUT_PRSN'		, width: 93,align:'center', hidden: true},
			{dataIndex: 'UNACCOUNT_Q'		, width: 110,summaryType: 'sum'},
			{dataIndex: 'INOUT_Q'			, width: 110,summaryType: 'sum'},
			{dataIndex: 'ACCOUNT_Q'			, width: 110,summaryType: 'sum'},
			{dataIndex: 'MONEY_UNIT'		, width: 53,align:'center'},
			{dataIndex: 'INOUT_FOR_P'		, width: 100},
			{dataIndex: 'UNACCOUNT_O'		, width: 133,summaryType: 'sum'},
			{dataIndex: 'EXCHG_RATE_O'		, width: 80},
			{dataIndex: 'CON_O'				, width: 133,summaryType: 'sum'},
			{dataIndex: 'INOUT_TYPE'		, width: 80,align:'center'},
			{dataIndex: 'ORDER_TYPE'		, width: 80,align:'center'},
			{dataIndex: 'INOUT_NUM'			, width: 133},
			{dataIndex: 'INOUT_SEQ'			, width: 66},
			{dataIndex: 'REMARK'			, width: 133},
			{dataIndex: 'PROJECT_NO'		, width: 133}
		] 
	});//End of var masterGrid = Unilite.createGrid('map140skrvGrid1', {   
	
	Unilite.Main({
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
		id: 'map140skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('ORDER_FR_DATE',UniDate.get('today'));
			panelSearch.setValue('ORDER_TO_DATE',UniDate.get('today'));
			panelResult.setValue('ORDER_FR_DATE',UniDate.get('today'));
			panelResult.setValue('ORDER_TO_DATE',UniDate.get('today'));
			
			
			
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('reset', true);
			
			
			
		},
		onQueryButtonDown: function() {	
			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.reset();
				masterGrid.getStore().loadStoreRecords();
			
				UniAppManager.setToolbarButtons('excel',true);
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		}
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});//End of Unilite.Main( {
};


</script>
