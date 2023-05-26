<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="otr310skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="O" />    <!-- 창고   -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의
	 */
	Unilite.defineModel('Otr310skrvModel', {
	    fields: [
	    	{name: 'ITEM_CODE',				text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',		type: 'string'},
	    	{name: 'ITEM_NAME',				text: '<t:message code="system.label.purchase.itemname" default="품목명"/>',		    type: 'string'},
	    	{name: 'SPEC',					text: '<t:message code="system.label.purchase.spec" default="규격"/>',			type: 'string'},
	    	{name: 'INOUT_DATE',			text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',		    type: 'uniDate'},
	    	{name: 'INOUT_CODE',			text: '<t:message code="system.label.purchase.receiptplace" default="입고처"/>',		    type: 'string'},
	    	{name: 'CUSTOM_NAME',			text: '<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>',		type: 'string'},
	    	{name: 'ORDER_UNIT',			text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>',		type: 'string'},
	    	{name: 'ORDER_UNIT_Q',			text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>',		    type: 'uniQty'},
	    	{name: 'MONEY_UNIT',			text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>',		type: 'string'},
	    	{name: 'ORDER_UNIT_P',			text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>',		type: 'uniUnitPrice'},
	    	{name: 'INOUT_I',				text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>',		type: 'uniPrice'},
	    	{name: 'INOUT_Q',				text: '<t:message code="system.label.purchase.tranqty" default="수불량"/>',		type: 'uniQty'},
	    	{name: 'EXCHG_RATE_O',			text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',		    type: 'uniER'},
	    	{name: 'INOUT_FOR_P',			text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>',		type: 'uniUnitPrice'},
	    	{name: 'INOUT_FOR_O',			text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>',		type: 'uniFC'},
	    	{name: 'ACCOUNT_YNC',           text: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>',       type: 'string',comboType:'AU', comboCode:'B018'},
	    	{name: 'STOCK_UNIT',			text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>',		type: 'string'},
	    	{name: 'WH_CODE',				text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',		type: 'string'},
	    	{name: 'INOUT_PRSN',			text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',		type: 'string'},
	    	{name: 'INOUT_NUM',				text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>',		type: 'string'},
	    	{name: 'INOUT_METH',			text: '<t:message code="system.label.purchase.tranmethod" default="수불방법"/>',		type: 'string'},
	    	{name: 'INOUT_TYPE_DETAIL',		text: '<t:message code="system.label.purchase.trantype" default="수불유형"/>',		type: 'string'},
	    	{name: 'ORDER_DATE',			text: '<t:message code="system.label.purchase.podate" default="발주일"/>',		    type: 'uniDate'},
	    	{name: 'LC_NUM',				text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>',		type: 'string'},
	    	{name: 'BL_NUM',				text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>',		type: 'string'},
	    	{name: 'DIV_CODE',				text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>',		    type: 'string'},
	    	{name: 'REMARK',				text: '<t:message code="system.label.purchase.remarks" default="비고"/>',			type: 'string'},
	    	{name: 'PROJECT_NO',			text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',	type: 'string'},
	    	{name: 'LOT_NO',				text: 'LOT NO',		    type: 'string'}
//	    	{name: 'OUT_ITEM_CODE',				text: '<t:message code="system.label.purchase.issueitem" default="출고품목"/>',		    type: 'string'},
//	    	{name: 'OUT_LOT_NO',				text: '<t:message code="system.label.purchase.issuelot" default="출고LOT"/>',		    type: 'string'}
			]
	});		// end of Unilite.defineModel('Otr310skrvModel', {

	Unilite.defineModel('Otr310skrvModel2', {
	    fields: [
	    	{name: 'ITEM_CODE',				text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',		type: 'string'},
	    	{name: 'ITEM_NAME',				text: '<t:message code="system.label.purchase.itemname" default="품목명"/>',		    type: 'string'},
	    	{name: 'SPEC',					text: '<t:message code="system.label.purchase.spec" default="규격"/>',			type: 'string'},
	    	{name: 'INOUT_DATE',			text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',		    type: 'uniDate'},
	    	{name: 'INOUT_CODE',			text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',		    type: 'string'},
	    	{name: 'CUSTOM_NAME',			text: '<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>',		type: 'string'},
	    	{name: 'ORDER_UNIT',			text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>',		type: 'string'},
	    	{name: 'ORDER_UNIT_Q',			text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>',		    type: 'uniQty'},
	    	{name: 'MONEY_UNIT',			text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>',		type: 'string'},
	    	{name: 'ORDER_UNIT_P',			text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>',		type: 'uniUnitPrice'},
	    	{name: 'INOUT_I',				text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>',		type: 'uniPrice'},
	    	{name: 'INOUT_Q',				text: '<t:message code="system.label.purchase.tranqty" default="수불량"/>',		type: 'uniQty'},
	    	{name: 'EXCHG_RATE_O',			text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',		    type: 'uniER'},
	    	{name: 'INOUT_FOR_P',			text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>',		type: 'uniUnitPrice'},
	    	{name: 'INOUT_FOR_O',			text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>',		type: 'uniFC'},
	    	{name: 'ACCOUNT_YNC',			text: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>',		type: 'string',comboType:'AU', comboCode:'B018'},
	    	{name: 'STOCK_UNIT',			text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>',		type: 'string'},
	    	{name: 'WH_CODE',				text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',		type: 'string'},
	    	{name: 'INOUT_PRSN',			text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',		type: 'string'},
	    	{name: 'INOUT_NUM',				text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>',		type: 'string'},
	    	{name: 'INOUT_METH',			text: '<t:message code="system.label.purchase.tranmethod" default="수불방법"/>',		type: 'string'},
	    	{name: 'INOUT_TYPE_DETAIL',		text: '<t:message code="system.label.purchase.trantype" default="수불유형"/>',		type: 'string'},
	    	{name: 'ORDER_DATE',			text: '<t:message code="system.label.purchase.podate" default="발주일"/>',		    type: 'uniDate'},
	    	{name: 'LC_NUM',				text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>',		type: 'string'},
	    	{name: 'BL_NUM',				text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>',		type: 'string'},
	    	{name: 'DIV_CODE',				text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>',		    type: 'string'},
	    	{name: 'REMARK',				text: '<t:message code="system.label.purchase.remarks" default="비고"/>',			type: 'string'},
	    	{name: 'PROJECT_NO',			text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',	type: 'string'},
	    	{name: 'LOT_NO',				text: 'LOT NO',		    type: 'string'}
//	    	{name: 'OUT_ITEM_CODE',				text: '<t:message code="system.label.purchase.issueitem" default="출고품목"/>',		    type: 'string'},
//	    	{name: 'OUT_LOT_NO',				text: '<t:message code="system.label.purchase.issuelot" default="출고LOT"/>',		    type: 'string'}
			]
	});		// end of Unilite.defineModel('Otr310skrvModel', {

	/**
	 * Store 정의(Service 정의)
	 */
	var directMasterStore1 = Unilite.createStore('otr310skrvMasterStore1',{
			model: 'Otr310skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                    read: 'otr310skrvService.selectList'
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});

			},
			groupField: 'ITEM_CODE'	,
			listeners:{
				load:function( store, records, successful, operation, eOpts )	{
					if(records && records.length > 0){
						masterGrid.setShowSummaryRow(true);
					}
				}
	        }
	});		// end of var directMasterStore1 = Unilite.createStore('otr310skrvMasterStore1',{

	var directMasterStore2 = Unilite.createStore('otr310skrvMasterStore2',{
			model: 'Otr310skrvModel2',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'otr310skrvService.selectList2'
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});

			},
			groupField: 'CUSTOM_NAME'	,
			listeners:{
				load:function( store, records, successful, operation, eOpts )	{
					if(records && records.length > 0){
						masterGrid2.setShowSummaryRow(true);
					}
				}
	        }
	});		// end of var directMasterStore1 = Unilite.createStore('otr310skrvMasterStore1',{

	/**
	 * 검색조건 (Search Panel)
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        width:380,
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
	        	startFieldName: 'FR_INOUT_DATE',
	        	endFieldName: 'TO_INOUT_DATE',
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	allowBlank: false,
	        	width:315,
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_INOUT_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_INOUT_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType  : 'O',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					},
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
			},{	//202002118 추가: 조회조건 "발주번호" 추가
				fieldLabel	: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
				name		: 'ORDER_NUM',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM', newValue);
					}
				}
			}]
		},{
			title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
	    		fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
	    		name: 'ITEM_ACCOUNT',
	    		xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020'
			},
			Unilite.popup('CUST',{
				fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
				textFieldWidth: 170,
				valueFieldName: 'INOUT_CODE',
				textFieldName: 'INOUT_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('INOUT_CODE', newValue);
								panelResult.setValue('INOUT_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('INOUT_NAME', '');
									panelResult.setValue('INOUT_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('INOUT_NAME', newValue);
								panelResult.setValue('INOUT_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('INOUT_CODE', '');
									panelResult.setValue('INOUT_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				            	}
					}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>',
				name: '',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M103'
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
				name: 'INOUT_PRSN' ,
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024'
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					textFieldWidth: 170,
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					extParam: {'CUSTOM_TYPE':'3'},
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_CODE', '');
									}
								},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				}),
			{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				xtype: 'uniTextfield',
				name : 'PROJECT_NO'
			},{
				fieldLabel: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>',
				xtype: 'uniTextfield',
				name: 'LOT_NO'
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}

					   	alert(labelText+Msg.sMB083);
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
		layout : {type : 'uniTable', columns : 3},
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
						panelResult.setValue('WH_CODE', '');
					}
				}
	        },{
	        	fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'FR_INOUT_DATE',
	        	endFieldName: 'TO_INOUT_DATE',
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	allowBlank: false,
	        	width:315,
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_INOUT_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_INOUT_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType  : 'O',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WH_CODE', newValue);
					},
                        beforequery:function( queryPlan, eOpts )   {
                            var store = queryPlan.combo.store;
                                store.clearFilter();
                            if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                                store.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            })
                            }else{
                                store.filterBy(function(record){
                                return false;
                            })
                        }
                      }
				}
			},
			Unilite.popup('CUST',{
				fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
				textFieldWidth: 170,
				valueFieldName: 'INOUT_CODE',
				textFieldName: 'INOUT_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('INOUT_CODE', newValue);
								panelResult.setValue('INOUT_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('INOUT_NAME', '');
									panelResult.setValue('INOUT_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('INOUT_NAME', newValue);
								panelResult.setValue('INOUT_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('INOUT_CODE', '');
									panelResult.setValue('INOUT_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				            	}
					}
			}),{//202002118 추가: 조회조건 "발주번호" 추가
				fieldLabel	: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
				name		: 'ORDER_NUM',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_NUM', newValue);
					}
				}
			}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{

    /**
     * Master Grid1 정의(Grid Panel)
     */
    var masterGrid = Unilite.createGrid('otr310skrvGrid1', {
    	// for tab
        layout : 'fit',
        region : 'center',
        title  : '<t:message code="system.label.purchase.itemby" default="품목별"/>',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel    : true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData    : false,
				summaryExport : true
			}
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
        	{ dataIndex: 'ITEM_CODE',    			width: 133, 	locked : true,
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.itemsubtotal" default="품목소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
                }
        	},
        	{ dataIndex: 'ITEM_NAME',    			width: 180, 	locked : true},
        	{ dataIndex: 'SPEC',    				width: 133},
        	{ dataIndex: 'LOT_NO',    				width: 120} ,
        	{ dataIndex: 'INOUT_DATE',    			width: 86},
        	{ dataIndex: 'INOUT_CODE',    			width: 80},
        	{ dataIndex: 'CUSTOM_NAME',    			width: 131},
        	{ dataIndex: 'ORDER_UNIT',    			width: 66, align:"center"},
        	{ dataIndex: 'ORDER_UNIT_Q',    		width: 120, summaryType:'sum'},
        	{ dataIndex: 'MONEY_UNIT' ,    			width: 66, align:"center"},
        	{ dataIndex: 'ORDER_UNIT_P',    		width: 120},
        	{ dataIndex: 'INOUT_I',    				width: 120, summaryType:'sum'},
        	{ dataIndex: 'EXCHG_RATE_O',    		width: 75},
        	{ dataIndex: 'INOUT_FOR_P',    			width: 100},
        	{ dataIndex: 'INOUT_FOR_O',    			width: 100, summaryType:'sum'},
        	{ dataIndex: 'ACCOUNT_YNC',    			width: 80, align:"center"},
        	{ dataIndex: 'INOUT_Q',    				width: 120, summaryType:'sum'},
        	{ dataIndex: 'STOCK_UNIT',    			width: 66, align:"center"},
        	{ dataIndex: 'WH_CODE'	,    			width: 93},
        	{ dataIndex: 'INOUT_PRSN',    			width: 80},
        	{ dataIndex: 'INOUT_NUM',    			width: 130},
        	{ dataIndex: 'INOUT_METH',    			width: 66},
        	{ dataIndex: 'INOUT_TYPE_DETAIL',    	width: 66},
        	{ dataIndex: 'ORDER_DATE',    			width: 86},
        	{ dataIndex: 'LC_NUM',    				width: 120,hidden : true},
        	{ dataIndex: 'BL_NUM',    				width: 120,hidden : true},
        	{ dataIndex: 'DIV_CODE',    			width: 106,hidden : true},
        	{ dataIndex: 'REMARK',    				width: 133},
        	{ dataIndex: 'PROJECT_NO',    			width: 133}
//        	{ dataIndex: 'OUT_ITEM_CODE',    	    width: 133},
//        	{ dataIndex: 'OUT_LOT_NO',    			width: 110}

          ]
    });		// end of var masterGrid = Unilite.createGrid('otr310skrvGrid1', {

    var masterGrid2 = Unilite.createGrid('otr310skrvGrid2', {
    	// for tab
        layout : 'fit',
        region:'center',
        title: '<t:message code="system.label.purchase.customby" default="거래처별"/>',
        uniOpt: {
    		useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : false,
    		filter: {
				useFilter  : false,
				autoCreate : false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
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
    	store: directMasterStore2,
        columns: [
        	{ dataIndex: 'CUSTOM_NAME',    			width: 131, 	locked : true,
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.customsubtotal" default="거래처소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
                }
        	},
        	{ dataIndex: 'INOUT_DATE',    			width: 86, 	locked : true},
        	{ dataIndex: 'INOUT_CODE',    			width: 80, 	locked : true},
        	{ dataIndex: 'ITEM_CODE',    			width: 133, locked : true},
        	{ dataIndex: 'ITEM_NAME',    			width: 180, locked : true},
        	{ dataIndex: 'SPEC',    				width: 133},
        	{ dataIndex: 'LOT_NO',    				width: 120},
        	{ dataIndex: 'ORDER_UNIT',    			width: 66, align:"center"},
        	{ dataIndex: 'ORDER_UNIT_Q',    		width: 120, summaryType:'sum'},
        	{ dataIndex: 'MONEY_UNIT' ,    			width: 66, align:"center"},
        	{ dataIndex: 'ORDER_UNIT_P',    		width: 120},
        	{ dataIndex: 'INOUT_I',    				width: 120, summaryType:'sum'},
        	{ dataIndex: 'EXCHG_RATE_O',    		width: 75},
        	{ dataIndex: 'INOUT_FOR_P',    			width: 100},
        	{ dataIndex: 'INOUT_FOR_O',    			width: 100, summaryType:'sum'},
        	{ dataIndex: 'ACCOUNT_YNC',    			width: 80, align:"center"},
        	{ dataIndex: 'INOUT_Q',    				width: 120, summaryType:'sum'},
        	{ dataIndex: 'STOCK_UNIT',    			width: 66, align:"center"},
        	{ dataIndex: 'WH_CODE'	,    			width: 93},
        	{ dataIndex: 'INOUT_PRSN',    			width: 80},
        	{ dataIndex: 'INOUT_NUM',    			width: 130},
        	{ dataIndex: 'INOUT_METH',    			width: 66},
        	{ dataIndex: 'INOUT_TYPE_DETAIL',    	width: 66},
        	{ dataIndex: 'ORDER_DATE',    			width: 86},
        	{ dataIndex: 'LC_NUM',    				width: 120,hidden : true},
        	{ dataIndex: 'BL_NUM',    				width: 120,hidden : true},
        	{ dataIndex: 'DIV_CODE',    			width: 106,hidden : true},
        	{ dataIndex: 'REMARK',    				width: 133},
        	{ dataIndex: 'PROJECT_NO',    			width: 133}
//        	{ dataIndex: 'OUT_ITEM_CODE',    	    width: 133},
//        	{ dataIndex: 'OUT_LOT_NO',    			width: 110}
          ]
    });		// end of var masterGrid = Unilite.createGrid('otr310skrvGrid1', {

    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid, masterGrid2
	    ],
	    listeners:  {
	     	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
				switch(newCard.getId()) {
					case 'otr310skrvGrid1':
						break;
					case 'otr310skrvGrid2':
						break;
					default:
						break;
				}
	     	}
	     }
	});

    Unilite.Main( {
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},panelSearch],
		id  : 'otr310skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_INOUT_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_INOUT_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_INOUT_DATE',UniDate.get('today'));
			panelResult.setValue('TO_INOUT_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{

			var activeTabId = tab.getActiveTab().getId();
			var grid = masterGrid;
			if(activeTabId == 'otr310skrvGrid1'){
				grid = masterGrid
			}else if(activeTabId == 'otr310skrvGrid2'){
				grid = masterGrid2
			}
			grid.reset();
			grid.getStore().loadStoreRecords();
		    UniAppManager.setToolbarButtons('excel',true);
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        },
        onResetButtonDown:function() {
        	panelSearch.clearForm();
        	panelResult.clearForm();
        	masterGrid.reset();
        	masterGrid2.reset();
        	masterGrid.getStore().clearData();
        	masterGrid2.getStore().clearData();
        	UniAppManager.app.fnInitBinding();
        }
	});
};
</script>