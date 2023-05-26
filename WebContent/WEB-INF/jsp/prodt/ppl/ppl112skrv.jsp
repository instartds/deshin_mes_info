<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl112skrv"  >
<t:ExtComboStore comboType= "BOR120" pgmId="ppl112skrv" /> 	  	<!-- 사업장 -->
<t:ExtComboStore items= "${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >

var PredictibleStockWindow; 	// 예상재고

function appMain() {
	/**
	 * Model 정의
	 *
	 * @type
	 */
	Unilite.defineModel('Ppl112skrvModel1', {
		fields: [
			{name: 'LOCATION'			, text: '<t:message code="system.label.product.selection" default="선택"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_NAME'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.product.itemaccount" default="품목계정"/>'			, type: 'string'},
			{name: 'ITEM_ACCOUNT_NAME'	, text: '<t:message code="system.label.product.itemaccountname" default="품목계정명"/>'			, type: 'string'},
			{name: 'ORDER_PLAN_DATE'	, text: '<t:message code="system.label.product.planorderdate" default="계획오더일"/>'			, type: 'uniDate'},
			{name: 'BASIS_DATE'			, text: '<t:message code="system.label.product.planfinisheddate" default="계획완료일"/>'			, type: 'uniDate'},
			{name: 'ORDER_PLAN_Q'		, text: '<t:message code="system.label.product.planordeqty" default="계획오더량"/>'			, type: 'uniQty'},
			{name: 'LD_TIME'			, text: 'L/T'			, type: 'string'},
			{name: 'MIN_LOT_Q'			, text: '최소LotSize'		, type: 'uniQty'},
			{name: 'MAX_LOT_Q'			, text: '최대LotSize'		, type: 'uniQty'},
			{name: 'STEP'				, text: 'LLC'			, type: 'string'},
			{name: 'RECORD_TYPE'		, text: '생성근거'			, type: 'string'},
			{name: 'RECORD_TYPE_NAME'	, text: '생성근거'			, type: 'string'},
			{name: 'PROD_ITEM_CODE'		, text: '<t:message code="system.label.product.parentitemcode" default="모품목코드"/>'			, type: 'string'},
			{name: 'PROD_Q'				, text: '모품목생산량'		, type: 'uniQty'},
			{name: 'UNIT_Q'				, text: '자품목생산량'		, type: 'uniQty'},
			{name: 'PROD_UNIT_Q'		, text: '모품목원단위'		, type: 'uniQty'},
			{name: 'LOSS_RATE'			, text: '<t:message code="system.label.product.lossrate" default="LOSS율"/>'			, type: 'uniER'},
			{name: 'WH_STOCK_Q'			, text: '<t:message code="system.label.product.onhandstock" default="현재고"/>'			, type: 'uniQty'},
			{name: 'INSTOCK_PLAN_Q'		, text: '<t:message code="system.label.product.receiptplanned" default="입고예정"/>'			, type: 'uniQty'},
			{name: 'OUTSTOCK_PLAN_Q'	, text: '<t:message code="system.label.product.issueresevation" default="출고예정"/>'		, type: 'uniQty'},
			{name: 'SAFE_STOCK_Q'		, text: '<t:message code="system.label.product.safetystock" default="안전재고"/>'		, type: 'uniQty'},
			{name: 'TOTAL_NEED_Q'		, text: '<t:message code="system.label.product.totalrequiredqty" default="총소요량"/>'			, type: 'uniQty'},
			{name: 'SUM_NEED_Q'			, text: '총소요량합'			, type: 'uniQty'},
			{name: 'EXCH_POH_STOCK_Q'	, text: '대체자재량'			, type: 'uniQty'},
			{name: 'POH_STOCK_Q'		, text: '예상재고'			, type: 'uniQty'},
			{name: 'POR_STOCK_Q'		, text: '계획보충량'			, type: 'uniQty'},
			{name: 'PAB_STOCK_Q'		, text: '예상가용량'			, type: 'uniQty'},
			{name: 'NET_REQ_Q'			, text: '순소요량'			, type: 'uniQty'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'			, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'			, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'}
		]
	});		// End of Unilite.defineModel('Ppl112skrvModel', {

	Unilite.defineModel('Ppl112skrvModel2', {
		fields: [
			{name: 'LOCATION'			, text: '<t:message code="system.label.product.selection" default="선택"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_NAME'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.product.itemaccount" default="품목계정"/>'			, type: 'string'},
			{name: 'ITEM_ACCOUNT_NAME'	, text: '<t:message code="system.label.product.itemaccountname" default="품목계정명"/>'			, type: 'string'},
			{name: 'ORDER_PLAN_DATE'	, text: '<t:message code="system.label.product.planorderdate" default="계획오더일"/>'			, type: 'uniDate'},
			{name: 'BASIS_DATE'			, text: '<t:message code="system.label.product.planfinisheddate" default="계획완료일"/>'			, type: 'uniDate'},
			{name: 'ORDER_PLAN_Q'		, text: '<t:message code="system.label.product.planordeqty" default="계획오더량"/>'			, type: 'uniQty'},
			{name: 'LD_TIME'			, text: 'L/T'			, type: 'string'},
			{name: 'MIN_LOT_Q'			, text: '최소LotSize'		, type: 'uniQty'},
			{name: 'MAX_LOT_Q'			, text: '최대LotSize'		, type: 'uniQty'},
			{name: 'STEP'				, text: 'LLC'			, type: 'string'},
			{name: 'RECORD_TYPE'		, text: '생성근거'			, type: 'string'},
			{name: 'RECORD_TYPE_NAME'	, text: '생성근거'			, type: 'string'},
			{name: 'PROD_ITEM_CODE'		, text: '<t:message code="system.label.product.parentitemcode" default="모품목코드"/>'			, type: 'string'},
			{name: 'PROD_Q'				, text: '모품목생산량'		, type: 'uniQty'},
			{name: 'UNIT_Q'				, text: '자품목생산량'		, type: 'uniQty'},
			{name: 'PROD_UNIT_Q'		, text: '모품목원단위'		, type: 'uniQty'},
			{name: 'LOSS_RATE'			, text: '<t:message code="system.label.product.lossrate" default="LOSS율"/>'			, type: 'uniER'},
			{name: 'WH_STOCK_Q'			, text: '<t:message code="system.label.product.onhandstock" default="현재고"/>'			, type: 'uniQty'},
			{name: 'INSTOCK_PLAN_Q'		, text: '<t:message code="system.label.product.receiptplanned" default="입고예정"/>'			, type: 'uniQty'},
			{name: 'OUTSTOCK_PLAN_Q'	, text: '<t:message code="system.label.product.issueresevation" default="출고예정"/>'		, type: 'uniQty'},
			{name: 'SAFE_STOCK_Q'		, text: '<t:message code="system.label.product.safetystock" default="안전재고"/>'		, type: 'uniQty'},
			{name: 'TOTAL_NEED_Q'		, text: '<t:message code="system.label.product.totalrequiredqty" default="총소요량"/>'			, type: 'uniQty'},
			{name: 'SUM_NEED_Q'			, text: '총소요량합'			, type: 'uniQty'},
			{name: 'EXCH_POH_STOCK_Q'	, text: '대체자재량'			, type: 'uniQty'},
			{name: 'POH_STOCK_Q'		, text: '예상재고'			, type: 'uniQty'},
			{name: 'POR_STOCK_Q'		, text: '계획보충량'			, type: 'uniQty'},
			{name: 'PAB_STOCK_Q'		, text: '예상가용량'			, type: 'uniQty'},
			{name: 'NET_REQ_Q'			, text: '순소요량'			, type: 'uniQty'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'			, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.product.soseq" default="수주순번"/>'			, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'}
		]
	});			// End of Unilite.defineModel('Ppl112skrvModel2', {

	Unilite.defineModel('PredictibleStockModel', {	// 예상재고
	    fields: [
			{name: 'STATUS'						, text: '<t:message code="system.label.product.status" default="상태"/>'    				, type: 'string'},
			{name: 'TYPE_NAME'					, text: '재고유형'    				, type: 'string'},
			{name: 'ORDER_NUM'					, text: '<t:message code="system.label.product.manageno" default="관리번호"/>'   	 			, type: 'string'},
			{name: 'ORDER_DATE'					, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'    				, type: 'uniDate'},
			{name: 'STOCK_Q'					, text: '예상수량'    				, type: 'uniQty'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 *
	 * @type
	 */
	var MasterStore = Unilite.createStore('ppl112skrvMasterStore',{
			model: 'Ppl112skrvModel1',
			uniOpt: {
            	isMaster:	true,				// 상위 버튼 연결
            	editable: 	false,				// 수정 모드 사용
            	deletable: 	false,				// 삭제 가능 여부
	            useNavi: 	false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'ppl112skrvService.selectList'
                }
            },
            loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
					if(MasterStore.count() == 0)	{
						Ext.getCmp('PredictibleStockbutton').setDisabled(true);
						Ext.getCmp('PredictibleStockbuttonSE').setDisabled(true);
	           			panelSearch.setValue('WKORD_NUM','');
	           			DetailStore.removeAll();
						UniAppManager.setToolbarButtons('reset', false);
	           		}else{
						Ext.getCmp('PredictibleStockbutton').setDisabled(false);
						Ext.getCmp('PredictibleStockbuttonSE').setDisabled(false);
           			}
	           	}
			}
		});

	var DetailStore = Unilite.createStore('ppl112skrvDetailStore',{
			model: 'Ppl112skrvModel2',
			uniOpt: {
            	isMaster: 	false,			// 상위 버튼 연결
            	editable: 	false,			// 수정 모드 사용
            	deletable: 	false,			// 삭제 가능 여부
	            useNavi: 	false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'ppl112skrvService.selectList2'
                }
            },
            loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			}/*,
			groupField: 'CUSTOM_NAME1'*/
	});		// End of var directDetailStore =
			// Unilite.createStore('ppl112skrvDetailStore',{

	var PredictibleStockStore = Unilite.createStore('ppl112skrvPredictibleStockStore', {	// 예상재고
			model: 'PredictibleStockModel',
            uniOpt : {
            	isMaster: false,															// 상위 버튼 연결
            	editable: false,															// 수정 모드 사용
            	deletable:false,															// 삭제 가능 여부
	            useNavi : false																// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'ppl112skrvService.selectList3'
                }
            },
        	loadStoreRecords: function()	{
				var param= Ext.getCmp('PredictibleStockForm').getValues();					// 예상재고 폼에서 값을 가져 온다.
				console.log( param );
				this.load({
					params: param
			});
		},
			groupField: 'STATUS'
	});
	/**
	 * 검색조건 (Search Panel)
	 *
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
			},{
				fieldLabel: 'LOCATION',
				name: 'LOCATION',
				xtype: 'uniTextfield',
			  	hidden:true
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WORK_SHOP_CODE', newValue);
						}
					}
			},{
				xtype: 'radiogroup',
				fieldLabel: '생성구분',
				labelWidth:90,
				items: [{
					boxLabel  : '<t:message code="system.label.product.whole" default="전체"/>',
					width: 80,
					name: 'rdoSelect',
					inputValue: 'Y',
					checked: true
				},{
					boxLabel  : 'Open 오더',
					width: 80,
					name: 'rdoSelect' ,
					inputValue: 'N'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
						}
					}
			},
				Unilite.popup('ITEM',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08.13 표준화 작업
									panelSearch.setValue('ITEM_CODE', newValue);
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_NAME', '');
										panelResult.setValue('ITEM_NAME', '');
									}
						},
						onTextFieldChange: function(field, newValue, oldValue){		// 2021.08.13 표준화 작업
									panelSearch.setValue('ITEM_NAME', newValue);
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_CODE', '');
										panelResult.setValue('ITEM_CODE', '');
									}
						},
						onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
                    	},
						scope: this
						},
						onClear: function(type)	{

						}
					}
			}),{
	    		xtype: 'button',
				id: 'PredictibleStockbuttonSE',
			    //padding: '0 1 0 50',
				margin: '0 0 0 95',
	    		text: '예상재고',
				disabled : true,
	    		name: 'PREDICTIBLE_BUTTON',
	    		width: 100,
				handler : function(grid, record) {
					openPredictibleStockWindow();			}
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

	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			value: UserInfo.divCode,
			listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('wsList'),
			listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
					}
				}
		},{
			xtype: 'radiogroup',
			fieldLabel: '생성구분',
			labelWidth:90,
			items: [{
				boxLabel  : '<t:message code="system.label.product.whole" default="전체"/>',
				width: 80,
				name: 'rdoSelect',
				inputValue: 'Y',
				checked: true
			},{
				boxLabel  : 'Open 오더',
				width: 80,
				name: 'rdoSelect' ,
				inputValue: 'N'
			}],
			listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
					}
				}
		},
			Unilite.popup('ITEM',{
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				textFieldWidth:170,
				validateBlank:false,
				listeners: {
				    onValueFieldChange: function(field, newValue, oldValue){	// 2021.08.13 표준화 작업
									panelSearch.setValue('ITEM_CODE', newValue);
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_NAME', '');
										panelResult.setValue('ITEM_NAME', '');
									}
						},
					onTextFieldChange: function(field, newValue, oldValue){		// 2021.08.13 표준화 작업
									panelSearch.setValue('ITEM_NAME', newValue);
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_CODE', '');
										panelResult.setValue('ITEM_CODE', '');
									}
						},
					onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
                	},
					scope: this
					},
					onClear: function(type)	{

					}
				}
		}),{
    		xtype: 'button',
			id: 'PredictibleStockbutton',
		    //padding: '0 1 0 50',
			margin: '0 50 0 1010',
    		text: '예상재고',
			disabled : true,
    		name: 'PREDICTIBLE_BUTTON',
    		width: 100,
			handler : function(grid, record) {
				openPredictibleStockWindow();			}
    	}]
    });

	var PredictibleStockSearch = Unilite.createSearchForm('PredictibleStockForm', {		// 예상재고
    	layout: {type : 'uniTable', columns : 3},
        items:[{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				holdable: 'hold',
				readOnly: true
			},{
				name: 'ITEM_CODE',
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				xtype: 'uniTextfield',
				readOnly: true
			},{
				name: 'ITEM_NAME',
				fieldLabel: '<t:message code="system.label.product.itemname" default="품목명"/>',
				xtype: 'uniTextfield',
				readOnly: true
			}, {
	        	fieldLabel: '<t:message code="system.label.product.basisdate" default="기준일"/>',
				xtype: 'uniDatefield',
				name: 'BASIS_DATE',
				startFieldName: 'ORDER_DATE_FR',
				readOnly: true
			}, {
				name: 'STOCK_UNIT',
				fieldLabel: '<t:message code="system.label.product.inventoryunit" default="재고단위"/>',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'B013',
				displayField: 'value',
				readOnly: true
			}, {
				name: 'SPEC',
				fieldLabel: '<t:message code="system.label.product.spec" default="규격"/>',
				maxLength: 160,
				readOnly: true
			}
		]
    });

    /**
	 * Master Grid1 정의(Grid Panel)
	 *
	 * @type
	 */
    var masterGrid = Unilite.createGrid('ppl112skrvGrid', {
    	layout:	'fit',
    	region:	'center',
        store:	MasterStore,
        uniOpt:	{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			},
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			}
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [
        	{dataIndex:'LOCATION'			, width: 60	, hidden: true},
        	{dataIndex:'WORK_SHOP_CODE'		, width: 66	, hidden: true},
        	{dataIndex:'WORK_SHOP_NAME'		, width: 120, locked: true},
        	{dataIndex:'ITEM_CODE'			, width: 100, locked: true},
        	{dataIndex:'ITEM_NAME'			, width: 100, locked: true,							//////////////////////////// 이 컬럼 위치에 소계, 총계 타이틀 넣는다.
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '합계', '<t:message code="system.label.product.total" default="총계"/>');
		    	}
	    	},
        	{dataIndex:'SPEC'				, width: 100, locked: true},
        	{dataIndex:'ITEM_ACCOUNT'		, width: 66	, hidden: true},
        	{dataIndex:'ITEM_ACCOUNT_NAME'	, width: 80},
        	{dataIndex:'ORDER_PLAN_DATE'	, width: 80},
        	{dataIndex:'BASIS_DATE'			, width: 80},
        	{dataIndex:'ORDER_PLAN_Q'		, width: 80},
        	{dataIndex:'LD_TIME'			, width: 40},
        	{dataIndex:'MIN_LOT_Q'			, width: 80},
        	{dataIndex:'MAX_LOT_Q'		 	, width: 80},
        	{dataIndex:'STEP'				, width: 50},
        	{dataIndex:'RECORD_TYPE'		, width: 66	, hidden: true},
        	{dataIndex:'RECORD_TYPE_NAME'	, width: 106, hidden: true},
    		{text:'BOM 정보' ,
    		columns: [
    			{dataIndex: 'PROD_ITEM_CODE'	, width: 80},
    			{dataIndex: 'PROD_Q'			, width: 86	, summaryType: 'sum' },
    			{dataIndex: 'UNIT_Q'			, width: 86	, summaryType: 'sum' },
    			{dataIndex: 'PROD_UNIT_Q'		, width: 86	, summaryType: 'sum' },
    			{dataIndex: 'LOSS_RATE'			, width: 53	, summaryType: 'sum' }
    		]},
    		{text:'재고정보',
    		columns: [
    			{dataIndex: 'WH_STOCK_Q'		, width: 68 , summaryType: 'sum' },
    			{dataIndex: 'INSTOCK_PLAN_Q'	, width: 68 , summaryType: 'sum' },
    			{dataIndex: 'OUTSTOCK_PLAN_Q'	, width: 68 , summaryType: 'sum' },
    			{dataIndex: 'SAFE_STOCK_Q'		, width: 68 , summaryType: 'sum' }
    		]},
    		{text:'순소요량정보',
    		columns: [
    			{dataIndex: 'TOTAL_NEED_Q'		 , width: 80 , summaryType: 'sum'},
    			{dataIndex: 'SUM_NEED_Q'		 , width: 80 , summaryType: 'sum'},
    			{dataIndex: 'EXCH_POH_STOCK_Q'	 , width: 80 , summaryType: 'sum'},
    			{dataIndex: 'POH_STOCK_Q'		 , width: 80 , summaryType: 'sum'},
    			{dataIndex: 'POR_STOCK_Q'		 , width: 80 , summaryType: 'sum'},
    			{dataIndex: 'PAB_STOCK_Q'		 , width: 80 , summaryType: 'sum'},
    			{dataIndex: 'NET_REQ_Q'			 , width: 80 , summaryType: 'sum'}
    		]},
        	{dataIndex:'ORDER_NUM'			 , width: 100},
        	{dataIndex:'ORDER_SEQ'			 , width: 75},
        	{dataIndex:'PROJECT_NO'		 	 , width: 100}
        ],
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
        listeners: {
    		selectionchange:function( model1, selected, eOpts ){
       			if(selected.length > 0)	{
	        		var record = selected[0];
	        		this.returnCell(record);
	        		DetailStore.loadData({})
					DetailStore.loadStoreRecords(record);
       			}
          	}
       	},
		returnCell: function(record){
        	var location			= record.get("LOCATION");
        	var divcode				= record.get("DIV_CODE");
        	var itemCode			= record.get("ITEM_CODE");
        	var itemname			= record.get("ITEM_NAME");
        	var baseDate			= record.get("BASIS_DATE");
        	var stockunit			= record.get("STOCK_UNIT");
        	var spec				= record.get("SPEC");
            panelSearch.setValues({'LOCATION':location});
            PredictibleStockSearch.setValues({'DIV_CODE':divcode});
            PredictibleStockSearch.setValues({'ITEM_CODE':itemCode});
            PredictibleStockSearch.setValues({'ITEM_NAME':itemname});
            PredictibleStockSearch.setValues({'BASIS_DATE':baseDate});
            PredictibleStockSearch.setValues({'STOCK_UNIT':stockunit});
            PredictibleStockSearch.setValues({'SPEC':spec});
        },
		disabledLinkButtons: function(b) {
		}
    });		// End of var masterGrid1= Unilite.createGrid('ppl112skrvGrid1', {

    /**
	 * Master Grid2 정의(Grid Panel)
	 *
	 * @type
	 */
	var masterGrid2= Unilite.createGrid('ppl112skrvGrid2', {
    	layout : 'fit',
    	region:'south',
        store : DetailStore,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			},
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			}
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
	    columns:  [
        	{dataIndex:'LOCATION'			, width: 60	, hidden: true},
        	{dataIndex:'WORK_SHOP_CODE'		, width: 66	, hidden: true},
        	{dataIndex:'WORK_SHOP_NAME'		, width: 120, locked: true},
        	{dataIndex:'ITEM_CODE'			, width: 100, locked: true},
        	{dataIndex:'ITEM_NAME'			, width: 100, locked: true,							//////////////////////////// 이 컬럼 위치에 소계, 총계 타이틀 넣는다.
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
		    	}
	    	},
        	{dataIndex:'SPEC'				, width: 100, locked: true},
        	{dataIndex:'ITEM_ACCOUNT'		, width: 66	, hidden: true},
        	{dataIndex:'ITEM_ACCOUNT_NAME'	, width: 80},
        	{dataIndex:'ORDER_PLAN_DATE'	, width: 80},
        	{dataIndex:'BASIS_DATE'			, width: 80},
        	{dataIndex:'ORDER_PLAN_Q'		, width: 80},
        	{dataIndex:'LD_TIME'			, width: 40},
        	{dataIndex:'MIN_LOT_Q'			, width: 80},
        	{dataIndex:'MAX_LOT_Q'		 	, width: 80},
        	{dataIndex:'STEP'				, width: 50},
        	{dataIndex:'RECORD_TYPE'		, width: 66	, hidden: true},
        	{dataIndex:'RECORD_TYPE_NAME'	, width: 106, hidden: true},
        		{text:'BOM 정보' ,
        		columns: [
        			{dataIndex: 'PROD_ITEM_CODE'	, width: 80	},
        			{dataIndex: 'PROD_Q'			, width: 86	, summaryType: 'sum'},
        			{dataIndex: 'UNIT_Q'			, width: 86	, summaryType: 'sum'},
        			{dataIndex: 'PROD_UNIT_Q'		, width: 86	, summaryType: 'sum'},
        			{dataIndex: 'LOSS_RATE'			, width: 53	, summaryType: 'sum'}
        		]},
        		{text:'재고정보',
        		columns: [
        			{dataIndex: 'WH_STOCK_Q'		, width: 68 , summaryType: 'sum'},
        			{dataIndex: 'INSTOCK_PLAN_Q'	, width: 68 , summaryType: 'sum'},
        			{dataIndex: 'OUTSTOCK_PLAN_Q'	, width: 68 , summaryType: 'sum'},
        			{dataIndex: 'SAFE_STOCK_Q'		, width: 68 , summaryType: 'sum'}
        		]},
        		{text:'순소요량정보',
        		columns: [
        			{dataIndex: 'TOTAL_NEED_Q'		 , width: 80 , summaryType: 'sum'},
        			{dataIndex: 'SUM_NEED_Q'		 , width: 80 , summaryType: 'sum'},
        			{dataIndex: 'EXCH_POH_STOCK_Q'	 , width: 80 , summaryType: 'sum'},
        			{dataIndex: 'POH_STOCK_Q'		 , width: 80 , summaryType: 'sum'},
        			{dataIndex: 'POR_STOCK_Q'		 , width: 80 , summaryType: 'sum'},
        			{dataIndex: 'PAB_STOCK_Q'		 , width: 80 , summaryType: 'sum'},
        			{dataIndex: 'NET_REQ_Q'			 , width: 80 , summaryType: 'sum'}
        		]},
        	{dataIndex:'ORDER_NUM'			 , width: 100},
        	{dataIndex:'ORDER_SEQ'			 , width: 75},
        	{dataIndex:'PROJECT_NO'		 	 , width: 100}
        ]
	});		// End of var masterGrid2= Unilite.createGrid('ppl112skrvGrid2', {

	var PredictibleStockGrid = Unilite.createGrid('ppl112skrvGPredictibleStockGrid', {		// 예상재고
        // title: '기본',
        layout : 'fit',
    	store: PredictibleStockStore,
		uniOpt:{
	       	onLoadSelectFirst : false
	    },
	    features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true}/*,
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}*/  // 총합계 사용 안 함
    	],
        columns: [
        	{dataIndex: 'STATUS'					,  width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<font color="blue">합계</font>', '');
		       }
			},
			{dataIndex: 'TYPE_NAME'					,  width: 133},
			{dataIndex: 'ORDER_NUM'					,  width: 120},
			{dataIndex: 'ORDER_DATE'				,  width: 133},
			{dataIndex: 'STOCK_Q'					,  width: 86,		summaryType: 'sum'}
        ]
	});

    function openPredictibleStockWindow() {    	// 예상재고
		if(!PredictibleStockWindow) {
			PredictibleStockWindow = Ext.create('widget.uniDetailWindow', {
                title: '예상재고',
                width: 830,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [PredictibleStockSearch, PredictibleStockGrid],
                tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.product.inquiry" default="조회"/>',
						handler: function() {
							PredictibleStockStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							PredictibleStockWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{
                	},
                	beforeclose: function(panel, eOpts)
                	{
						PredictibleStockSearch.clearForm();
                		PredictibleStockGrid.reset();
                	},
               	beforeshow: function (me, eOpts)
                	{
                		PredictibleStockSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
                		PredictibleStockStore.loadStoreRecords();
        			 }
                }
			})
		}
		PredictibleStockWindow.show();
    }

    Unilite.Main({
		borderItems:[{
         region: 'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid, masterGrid2, panelResult
         ]
	      },
	         panelSearch
	      ],
		id: 'ppl112skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',false);
		},

		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}else{
			MasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			masterGrid.reset();
			masterGrid2.reset();
			panelResult.clearForm();
			this.fnInitBinding();
			MasterStore.clearData();
			DetailStore.clearData();
			Ext.getCmp('PredictibleStockbutton').setDisabled(true);
			Ext.getCmp('PredictibleStockbuttonSE').setDisabled(true);
			//panelResult.PredictibleStockbutton.setDisabled(true);
		}
	});
};
</script>
