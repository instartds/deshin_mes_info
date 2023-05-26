<%--
'   프로그램명 : MRP전개내역조회 (구매자재)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrp400skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var exceptStockWindow;

function appMain() {

	/**
	 * Model 정의
	 */
	Unilite.defineModel('Mrp400skrvModel', {
	    fields: [
	    	{name: 'MRP_STATUS'		    	,text:'<t:message code="system.label.purchase.status" default="상태"/>'				,type:'string'},
	    	{name: 'LOCATION'			    ,text:'location'		    ,type:'string'},
	    	{name: 'item_check'		    	,text:'<t:message code="system.label.purchase.selection" default="선택"/>'				,type:'string'},
	    	{name: 'SUPPLY_TYPE'		    ,text:'<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'			,type:'string'},
	    	{name: 'SUPPLY_NAME'	 	    ,text:'<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'			,type:'string'},
	    	{name: 'ITEM_CODE'			    ,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			,type:'string'},
	    	{name: 'ITEM_NAME'			    ,text:'<t:message code="system.label.purchase.itemname" default="품목명"/>'			    ,type:'string'},
	    	{name: 'SPEC'				    ,text:'<t:message code="system.label.purchase.spec" default="규격"/>'				,type:'string'},
	    	{name: 'ITEM_ACCOUNT'		    ,text:'<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			,type:'string'},
	    	{name: 'ITEM_ACCOUNT_NAME'	    ,text:'<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			,type:'string'},
	    	{name: 'ORDER_PLAN_DATE'	    ,text:'<t:message code="system.label.purchase.planorderdate" default="계획오더일"/>'			,type:'uniDate'},
	    	{name: 'BASIS_DATE'		    	,text:'<t:message code="system.label.purchase.planfinisheddate" default="계획완료일"/>'			,type:'uniDate'},
	    	{name: 'LD_TIME'			    ,text:'L/T'				    ,type:'uniQty'},
	    	{name: 'MIN_LOT_Q'			    ,text:'<t:message code="system.label.purchase.minimum" default="최소"/> Lot'		    ,type:'uniQty'},
	    	{name: 'MAX_LOT_Q'			    ,text:'<t:message code="system.label.purchase.maximum" default="최대"/> Lot'		    ,type:'uniQty'},
	    	{name: 'STEP'				    ,text:'LLC'				    ,type:'string'},
	    	{name: 'RECORD_TYPE'		    ,text:'<t:message code="system.label.purchase.creationbasis" default="생성근거"/>'			,type:'string'},
	    	{name: 'RECORD_TYPE_NAME'	    ,text:'<t:message code="system.label.purchase.creationbasis" default="생성근거"/>'			,type:'string'},
	    	{name: 'PROD_ITEM_CODE'	    	,text:'<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>'			,type:'string'},
	    	{name: 'PROD_Q'			    	,text:'<t:message code="system.label.purchase.parentitemproduce" default="모품목생산량"/>'		,type:'uniQty'},
	    	{name: 'UNIT_Q'			    	,text:'<t:message code="system.label.purchase.childitemunit" default="자품목원단위"/>'		,type:'uniQty'},
	    	{name: 'PROD_UNIT_Q'		    ,text:'<t:message code="system.label.purchase.parentitemunit" default="모품목원단위"/>'		,type:'uniQty'},
	    	{name: 'LOSS_RATE'			    ,text:'<t:message code="system.label.purchase.lossrate" default="Loss율"/>'			,type: 'float', decimalPrecision: 4, format:'0,000.0000'},
	    	{name: 'WH_STOCK_Q'		    	,text:'<t:message code="system.label.purchase.onhandqty" default="현재고량"/>'			,type:'uniQty'},
	    	{name: 'INSTOCK_PLAN_Q'	    	,text:'<t:message code="system.label.purchase.receiptplanned" default="입고예정"/>'			,type:'uniQty'},
	    	{name: 'OUTSTOCK_PLAN_Q'	    ,text:'<t:message code="system.label.purchase.issueresevation" default="출고예정"/>'			,type:'uniQty'},
	    	{name: 'SAFE_STOCK_Q'		    ,text:'<t:message code="system.label.purchase.safetystock" default="안전재고"/>'			,type:'uniQty'},
	    	{name: 'TOTAL_NEED_Q'		    ,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
	    	{name: 'SUM_NEED_Q'		    	,text:'<t:message code="system.label.purchase.totalrequiredqtysum" default="총소요량합"/>'			,type:'uniQty'},
	    	{name: 'EXCH_POH_STOCK_Q'	    ,text:'<t:message code="system.label.purchase.submaterialqty" default="대체자재량"/>'			,type:'uniQty'},
	    	{name: 'POH_STOCK_Q'		    ,text:'<t:message code="system.label.purchase.estimatedstock" default="예상재고"/>'			,type:'uniQty'},
	    	{name: 'POR_STOCK_Q'		    ,text:'<t:message code="system.label.purchase.plansupplementqty" default="계획보충량"/>'			,type:'uniQty'},
	    	{name: 'PAB_STOCK_Q'		    ,text:'<t:message code="system.label.purchase.estimatedavailibleqty" default="예상가용량"/>'			,type:'uniQty'},
	    	{name: 'NET_REQ_Q'			    ,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'			,type:'uniQty'},
	    	{name: 'NEED_Q_PRESENT_Q'	    ,text:'<t:message code="system.label.purchase.needqpresentqty" default="소요량올림수"/>'		,type:'uniQty'},
	    	{name: 'ORDER_PLAN_Q'		    ,text:'<t:message code="system.label.purchase.planqty" default="계획량"/>'			,type:'uniQty'},
	    	{name: 'ORDER_NUM'			    ,text:'<t:message code="system.label.purchase.sono" default="수주번호"/>'			,type:'string'},
	    	{name: 'ORDER_SEQ'			    ,text:'<t:message code="system.label.purchase.seq" default="순번"/>'			,type:'string'},
	    	{name: 'PROJECT_NO'		    	,text:'<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		,type:'string'},
	    	{name: 'INSERT_YN'		        ,text:'<t:message code="system.label.purchase.partitionyn" default="분할여부"/>'			,type:'string'},
	    	{name: 'ORDER_PLAN_NAME'	    ,text:'<t:message code="system.label.purchase.popolicy" default="발주방침"/>'			,type:'string'},
	    	{name: 'VAL_CHK'			    ,text:'<t:message code="system.label.purchase.warnfield" default="경고필드"/>'			,type:'string'},
	    	{name: 'STOCK_UNIT'			    ,text:'<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			,type:'string'}
		]
	});		// end of Unilite.defineModel('Mrp400skrvModel', {

	Unilite.defineModel('MrpExceptStockModel', {
	    fields: [
	    	{name: 'STATUS'		    	    ,text:'<t:message code="system.label.purchase.status" default="상태"/>'				,type:'string'},
	    	{name: 'TYPE_NAME'			    ,text:'<t:message code="system.label.purchase.inventorytype" default="재고유형"/>'		    ,type:'string'},
	    	{name: 'ORDER_NUM'		    	,text:'<t:message code="system.label.purchase.refernum" default="관련번호"/>'			,type:'string'},
	    	{name: 'ORDER_DATE'		        ,text:'<t:message code="system.label.purchase.completiondate" default="완료예정일"/>'			,type:'uniDate'},
	    	{name: 'STOCK_Q'	 	        ,text:'<t:message code="system.label.purchase.estimatedqty" default="예상수량"/>'			,type:'uniQty'}
		]
	});		// end of Unilite.defineModel('mrpExceptStockModel', {

	/**
	 * Store 정의(Service 정의)
	 */
	var directMasterStore1 = Unilite.createStore('mrp400skrvMasterStore1',{
			model: 'Mrp400skrvModel',
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
                	 read: 'mrp400skrvService.selectList'
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});		// end of var directMasterStore1 = Unilite.createStore('mrp400skrvMasterStore1',{

	var directMasterStore2 = Unilite.createStore('mrp400skrvMasterStore2',{
			model: 'Mrp400skrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                    read: 'mrp400skrvService.selectList2'
                }
            },
			loadStoreRecords : function(param)  {
                this.load({
                    params : param
                });
            }
	});		// end of var directMasterStore2 = Unilite.createStore('mrp400skrvMasterStore2',{

    var MrpExceptStockStore = Unilite.createStore('MrpExceptStockStore', {//미지급참조
		model: 'MrpExceptStockModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'mrp400skrvService.selectMrpPopList'
            }
        },
		loadStoreRecords: function(param){
			this.load({
				params: param
			});
		},
		groupField : 'STATUS'
	});

	/**
	 * 검색조건 (Search Panel)
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        width:380,
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
		   			name:'DIV_CODE',
		   			xtype: 'uniCombobox',
		   			comboType:'BOR120',
		   			allowBlank:false,
		   			value: UserInfo.divCode,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
		   		},{
                    fieldLabel: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
                    name: 'WORK_SHOP_CODE',
                    xtype: 'uniCombobox',
                    store: Ext.data.StoreManager.lookup('wsList'),
                    listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.setValue('WORK_SHOP_CODE', newValue);
                            },
                            beforequery:function( queryPlan, eOpts )   {
                                var store = queryPlan.combo.store;
                                var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                                store.clearFilter();
                                prStore.clearFilter();
                                if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                                    store.filterBy(function(record){
                                        return record.get('option') == panelSearch.getValue('DIV_CODE');
                                    });
                                    prStore.filterBy(function(record){
                                        return record.get('option') == panelSearch.getValue('DIV_CODE');
                                    });
                                }else{
                                    store.filterBy(function(record){
                                        return false;
                                    });
                                    prStore.filterBy(function(record){
                                        return false;
                                    });
                                }
                            }
                        }
                },{
					fieldLabel: '<t:message code="system.label.purchase.creationtype" default="생성구분"/>',
					xtype: 'radiogroup',
					id: 'rdo',
				   	items: [{
				   		boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
				   		width: 60,
				   		name: 'rdoSelect',
				   		inputValue: '',
				   		checked: true
				   		},{
				   			boxLabel: 'Open <t:message code="system.label.purchase.order" default="오더"/>',
				   			width: 80,
				   			name: 'rdoSelect',
				   			inputValue: '1'
				   		},{
				   			boxLabel: '<t:message code="system.label.purchase.convert" default="전환"/>',
				   			width: 60,
				   			name: 'rdoSelect',
				   			inputValue: '2'
				   		},{
				   			boxLabel: '<t:message code="system.label.purchase.confirmation" default="확정"/>',
				   			width: 60,
				   			name: 'rdoSelect',
				   			inputValue: '3'
				   		}],
				   		listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
							}
						}
				   	},
				Unilite.popup('DIV_PUMOK', {
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					textFieldWidth: 170,
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),
				{
					fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
					name: 'SUPPLY_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B014',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SUPPLY_TYPE', newValue);
						}
					}
				},{
	        	fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
	        	name:'ITEM_ACCOUNT',
	        	xtype: 'uniCombobox',
	        	comboType:'AU',
	        	comboCode:'B020',
		    	listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
   			},{
					fieldLabel: '<t:message code="system.label.purchase.inquirycondition" default="조회조건"/>',
					xtype: 'radiogroup',
					id: 'rdo2',
					items : [{
							boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
							width: 60,
							name: 'rdoSelect2',
							inputValue: '',
							checked: true
						},{
							boxLabel: 'MPS <t:message code="system.label.purchase.item" default="품목"/>',
							width: 80,
							name: 'rdoSelect2',
							inputValue: '1'
						},{
							boxLabel : 'MRP <t:message code="system.label.purchase.item" default="품목"/>',
							width: 75,
							name: 'rdoSelect2',
							inputValue: '2'
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.getField('rdoSelect2').setValue(newValue.rdoSelect2);
							}
						}
			        },{
			    		xtype: 'button',
			    		name : 'TEMP_BUTTON',
			    		text : '<t:message code="system.label.purchase.estimatedstock" default="예상재고"/>',
			    		margin : "0 0 0 50",
			    		handler : function() {
			    			var record = Ext.getCmp("mrp400skrvGrid1").getSelectedRecord();
			    			if(record){
			    				openExceptStockWindow();
			    			}
					    }
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
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
		   			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
		   			name:'DIV_CODE',
		   			xtype: 'uniCombobox',
		   			comboType:'BOR120',
		   			allowBlank:false,
		   			value: UserInfo.divCode,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('DIV_CODE', newValue);
							panelResult.setValue('WORK_SHOP_CODE','');
						}
					}
		   		},{
                    fieldLabel: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
                    name: 'WORK_SHOP_CODE',
                    xtype: 'uniCombobox',
                    store: Ext.data.StoreManager.lookup('wsList'),
                    listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelSearch.setValue('WORK_SHOP_CODE', newValue);
                            },
                            beforequery:function( queryPlan, eOpts )   {
                                var store = queryPlan.combo.store;
                                var prStore = panelResult.getField('WORK_SHOP_CODE').store;
                                store.clearFilter();
                                prStore.clearFilter();
                                if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                                    store.filterBy(function(record){
                                        return record.get('option') == panelResult.getValue('DIV_CODE');
                                    });
                                    prStore.filterBy(function(record){
                                        return record.get('option') == panelResult.getValue('DIV_CODE');
                                    });
                                }else{
                                    store.filterBy(function(record){
                                        return false;
                                    });
                                    prStore.filterBy(function(record){
                                        return false;
                                    });
                                }
                            }
                        }
                },{
					fieldLabel: '<t:message code="system.label.purchase.creationtype" default="생성구분"/>',
					colspan:2,
					xtype: 'radiogroup',
					id: 'rdo3',
				   	items: [{
				   		    boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
				   		    width: 60,
				   		    name: 'rdoSelect',
				   		    inputValue: '',
				   		    checked: true
				   		},{
				   			boxLabel: 'Open <t:message code="system.label.purchase.order" default="오더"/>',
				   			width: 80,
				   			name: 'rdoSelect',
				   			inputValue: '1'
				   		},{
				   			boxLabel: '<t:message code="system.label.purchase.convert" default="전환"/>',
				   			width: 60,
				   			name: 'rdoSelect',
				   			inputValue: '2'
				   		},{
				   			boxLabel: '<t:message code="system.label.purchase.confirmation" default="확정"/>',
				   			width: 60,
				   			name: 'rdoSelect',
				   			inputValue: '3'
				   		}],
				   		listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
							}
						}
				   	},
/*				Unilite.popup('DIV_PUMOK', {
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					textFieldWidth: 170,
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
						}
					}
				}),*/
				{
					fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
					name: 'SUPPLY_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B014',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('SUPPLY_TYPE', newValue);
						}
					}
				},{
		        	fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
		        	name:'ITEM_ACCOUNT',
		        	xtype: 'uniCombobox',
		        	comboType:'AU',
		        	comboCode:'B020',
		        	listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
	   			},{
					fieldLabel: '<t:message code="system.label.purchase.inquirycondition" default="조회조건"/>',
					xtype: 'radiogroup',
					id: 'rdo4',
					items : [{
							boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
							width: 60,
							name: 'rdoSelect2',
							inputValue: '',
							checked: true
						},{
							boxLabel: 'MPS <t:message code="system.label.purchase.item" default="품목"/>',
							width: 80,
							name: 'rdoSelect2',
							inputValue: '1'
						},{
							boxLabel : 'MRP <t:message code="system.label.purchase.item" default="품목"/>',
							width: 75,
							name: 'rdoSelect2',
							inputValue: '2'
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.getField('rdoSelect2').setValue(newValue.rdoSelect2);
							}
						}
			        },{
			    		xtype: 'button',
			    		id   : 'tempButton',
			    		name : 'TEMP_BUTTON',
			    		text : '<t:message code="system.label.purchase.estimatedstock" default="예상재고"/>',
			    		margin:'0 0 0 80',
			    		handler : function() {
			    			var record = Ext.getCmp("mrp400skrvGrid1").getSelectedRecord();
			    			if(record){
			    				openExceptStockWindow();
			    			}
					    }
			    	}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{

    var MrpExceptStockSearch = Unilite.createSearchForm('MrpExceptStockForm', {//미지급참조
		layout: {type : 'uniTable', columns : 3},
		items :[{
			    	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			    	name:'DIV_CODE',
			    	xtype: 'uniTextfield',
			    	readOnly:true
			    },
			    Unilite.popup('DIV_PUMOK', {
			        fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			        valueFieldName: 'ITEM_CODE',
			        textFieldName: 'ITEM_NAME',
			        textFieldWidth: 170,
			        readOnly:true,
			        colspan:2
		        }),{
					fieldLabel: '<t:message code="system.label.purchase.basisdate" default="기준일"/>',
					name:'BASE_DATE',
					xtype: 'uniDatefield',
					readOnly:true
				},{
				    fieldLabel: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>',
				    name: 'STOCK_UNIT',
				    xtype: 'uniCombobox',
				    comboType: 'AU',
				    comboCode: 'B013',
				    displayField: 'value',
				    fieldStyle: 'text-align: center;',
				    readOnly:true
			    },{
                    fieldLabel: '<t:message code="system.label.purchase.spec" default="규격"/>',
                    name:'SPEC',
                    xtype: 'uniTextfield',
                    readOnly:true
                }]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     */
    var masterGrid = Unilite.createGrid('mrp400skrvGrid1', {
    	// for tab
        layout : 'fit',
        region: 'center',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	store: directMasterStore1,
        selModel : 'rowmodel',
        	columns:  [
        		{ dataIndex: 'STEP'					,   width: 40,align:'center'},
        		{ dataIndex: 'LOCATION'				,   width: 400, hidden : true},
        		{ dataIndex: 'item_check'		    ,   width: 66 , hidden : true},
        		{ dataIndex: 'ITEM_CODE'			,   width: 120},
        		{ dataIndex: 'ITEM_NAME'			,   width: 150},
        		{ dataIndex: 'SPEC'					,   width: 130},
        		{ dataIndex: 'SUPPLY_TYPE'		    ,   width: 66 , hidden : true},
        		{ dataIndex: 'SUPPLY_NAME'	 	    ,   width: 66 ,align:'center'},
        		{ dataIndex: 'ITEM_ACCOUNT'			,   width: 66, hidden : true},
        		{ dataIndex: 'ITEM_ACCOUNT_NAME'	,   width: 80 ,align:'center'},
        		{ dataIndex: 'MRP_STATUS'		    ,   width: 60 ,align:'center'} ,
        		{ dataIndex: 'ORDER_PLAN_DATE'	    ,   width: 80},
        		{ dataIndex: 'BASIS_DATE'		    ,   width: 80},
        		{ dataIndex: 'LD_TIME'			    ,   width: 50},
        		{ dataIndex: 'ORDER_PLAN_Q'			,   width: 70},
        		{ dataIndex: 'MIN_LOT_Q'			,   width: 70},
        		{ dataIndex: 'MAX_LOT_Q'			,   width: 70},

        		{ dataIndex: 'RECORD_TYPE'		    ,   width: 66, hidden : true},
        		{ dataIndex: 'RECORD_TYPE_NAME'		,   width: 106, hidden : true},
        { text:'BOM <t:message code="system.label.purchase.info" default="정보"/>',
        	columns: [
				{ dataIndex: 'PROD_ITEM_CODE'	    ,   width: 120},
				{ dataIndex: 'PROD_Q'			    ,   width: 100},
				{ dataIndex: 'UNIT_Q'			    ,   width: 100},
				{ dataIndex: 'PROD_UNIT_Q'		    ,   width: 100},
				{ dataIndex: 'LOSS_RATE'			,   width: 100}
			]
		},
		{ text:'<t:message code="system.label.purchase.stockinfo" default="재고정보"/>',
        	columns: [
				{ dataIndex: 'WH_STOCK_Q'		    ,   width: 100},
				{ dataIndex: 'INSTOCK_PLAN_Q'	    ,   width: 100},
				{ dataIndex: 'OUTSTOCK_PLAN_Q'	    ,   width: 100},
				{ dataIndex: 'SAFE_STOCK_Q'			,   width: 100}
			]
		},
			{ text:'<t:message code="system.label.purchase.netreqinfo" default="순소요량정보"/>',
       		 columns:  [
				{ dataIndex: 'TOTAL_NEED_Q'			,   width: 100},
				{ dataIndex: 'SUM_NEED_Q'		    ,   width: 100},
				{ dataIndex: 'EXCH_POH_STOCK_Q'		,   width: 100},
				{ dataIndex: 'POH_STOCK_Q'		    ,   width: 100},
				{ dataIndex: 'POR_STOCK_Q'		    ,   width: 100},
				{ dataIndex: 'PAB_STOCK_Q'		    ,   width: 100},
				{ dataIndex: 'NET_REQ_Q'			,   width: 100},
				{ dataIndex: 'NEED_Q_PRESENT_Q'	,   width: 100}
			]
		},
				{ dataIndex: 'ORDER_NUM'			,   width: 120},
				{ dataIndex: 'ORDER_SEQ'			,   width: 100},
				{ dataIndex: 'PROJECT_NO'		    ,   width: 100},
				{ dataIndex: 'INSERT_YN'		    ,   width: 100, hidden:true},
				{ dataIndex: 'ORDER_PLAN_NAME'	    ,   width: 100, hidden:true},
				{ dataIndex: 'VAL_CHK'			    ,   width: 100, hidden : true}
          ],
            listeners : {
                selectionchange : function(grid, selected, eOpts) {
                    this.setDetailGrd(selected, eOpts) ;
                }
            },
            setDetailGrd : function (selected, eOpts) {
                if(selected.length > 0) {
                    var param= Ext.getCmp('searchForm').getValues();
                    param.LOCATION = selected[selected.length-1].get('LOCATION')
                    var dgrid = Ext.getCmp('mrp400skrvGrid2');
                    dgrid.getStore().loadStoreRecords(param);
                }
            }
    });

    var masterGrid2 = Unilite.createGrid('mrp400skrvGrid2', {
    	// for tab
        layout : 'fit',
        region: 'south',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	store: directMasterStore2,
        	columns:  [
        		{ dataIndex: 'STEP'					,   width: 40,align:'center'},
        		{ dataIndex: 'LOCATION'				,   width: 400, hidden : true},
        		{ dataIndex: 'item_check'		    ,   width: 66 , hidden : true},
        		{ dataIndex: 'ITEM_CODE'			,   width: 120},
        		{ dataIndex: 'ITEM_NAME'			,   width: 130},
        		{ dataIndex: 'SPEC'					,   width: 130},
        		{ dataIndex: 'SUPPLY_TYPE'		    ,   width: 66 , hidden : true},
        		{ dataIndex: 'SUPPLY_NAME'	 	    ,   width: 66 ,align:'center'},
        		{ dataIndex: 'ITEM_ACCOUNT'			,   width: 66, hidden : true},
        		{ dataIndex: 'ITEM_ACCOUNT_NAME'	,   width: 80 ,align:'center'},
        		{ dataIndex: 'MRP_STATUS'		    ,   width: 60 ,align:'center'} ,
        		{ dataIndex: 'ORDER_PLAN_DATE'	    ,   width: 80},
        		{ dataIndex: 'BASIS_DATE'		    ,   width: 80},
        		{ dataIndex: 'LD_TIME'			    ,   width: 50},
        		{ dataIndex: 'ORDER_PLAN_Q'			,   width: 70},
        		{ dataIndex: 'MIN_LOT_Q'			,   width: 70},
        		{ dataIndex: 'MAX_LOT_Q'			,   width: 70},

        		{ dataIndex: 'RECORD_TYPE'		    ,   width: 66, hidden : true},
        		{ dataIndex: 'RECORD_TYPE_NAME'		,   width: 106, hidden : true},
        { text:'BOM <t:message code="system.label.purchase.info" default="정보"/>',
        	columns: [
				{ dataIndex: 'PROD_ITEM_CODE'	    ,   width: 120},
				{ dataIndex: 'PROD_Q'			    ,   width: 100},
				{ dataIndex: 'UNIT_Q'			    ,   width: 100},
				{ dataIndex: 'PROD_UNIT_Q'		    ,   width: 100},
				{ dataIndex: 'LOSS_RATE'			,   width: 100}
			]
		},
		{ text:'<t:message code="system.label.purchase.stockinfo" default="재고정보"/>',
        	columns: [
				{ dataIndex: 'WH_STOCK_Q'		    ,   width: 100},
				{ dataIndex: 'INSTOCK_PLAN_Q'	    ,   width: 100},
				{ dataIndex: 'OUTSTOCK_PLAN_Q'	    ,   width: 100},
				{ dataIndex: 'SAFE_STOCK_Q'			,   width: 100}
			]
		},
			{ text:'<t:message code="system.label.purchase.netreqinfo" default="순소요량정보"/>',
       		 columns:  [
				{ dataIndex: 'TOTAL_NEED_Q'			,   width: 100},
				{ dataIndex: 'SUM_NEED_Q'		    ,   width: 100},
				{ dataIndex: 'EXCH_POH_STOCK_Q'		,   width: 100},
				{ dataIndex: 'POH_STOCK_Q'		    ,   width: 100},
				{ dataIndex: 'POR_STOCK_Q'		    ,   width: 100},
				{ dataIndex: 'PAB_STOCK_Q'		    ,   width: 100},
				{ dataIndex: 'NET_REQ_Q'			,   width: 100},
				{ dataIndex: 'NEED_Q_PRESENT_Q'	,   width: 100}
			]
		},
				{ dataIndex: 'ORDER_NUM'			,   width: 120},
				{ dataIndex: 'ORDER_SEQ'			,   width: 100},
				{ dataIndex: 'PROJECT_NO'		    ,   width: 100},
				{ dataIndex: 'INSERT_YN'		    ,   width: 100, hidden:true},
				{ dataIndex: 'ORDER_PLAN_NAME'	    ,   width: 100, hidden:true},
				{ dataIndex: 'VAL_CHK'			    ,   width: 100, hidden:true}
          ]
    });		// end of var masterGrid2 = Unilite.createGrid('mrp400skrvGrid2', {

    var MrpExceptStockGrid = Unilite.createGrid('MrpExceptStockGrid', {//미지급참조
		layout: 'fit',
		uniOpt: {
    		useGroupSummary: true,
    		useLiveSearch: true,
			useRowNumberer: false,
			expandLastColumn: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel      : true,		//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
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
    	store: MrpExceptStockStore,
        columns: [
        	{dataIndex:'STATUS'			    , width: 100,
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
                }
        	},
        	{dataIndex:'TYPE_NAME'			, width: 180},
        	{dataIndex:'ORDER_NUM'	        , width: 140},
        	{dataIndex:'ORDER_DATE'	        , width: 120},
        	{dataIndex:'STOCK_Q'			, width: 120, summaryType:'sum'}
		]
	});

	function getUnFormatDate(date){
		var year   = date.getFullYear();
		var month  = date.getMonth();
		var day    = date.getDate();
		month = (month > 8 ? "" : "0") + (month + 1);
		day   = (day > 9 ? "" : "0") + day;
		return "" + year + month + day;
	}

    function openExceptStockWindow() {
		if(!exceptStockWindow) {
			exceptStockWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.purchase.mrpexpectedinventoryinquiry" default="MRP예상재고조회"/>',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [MrpExceptStockSearch, MrpExceptStockGrid],
                tbar: ['->',{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							MrpExceptStockGrid.reset();
							MrpExceptStockGrid.getStore().clearData();
							MrpExceptStockSearch.clearForm();
							exceptStockWindow.hide();
						}
					}
				],
                listeners: {
					beforehide: function(me, eOpt)	{
	    			},
	    			beforeclose: function( panel, eOpts )	{
	    			},
	    			beforeshow: function ( me, eOpts )	{

	    				var record = Ext.getCmp("mrp400skrvGrid1").getSelectedRecord();
	    				var panelSearch = Ext.getCmp("searchForm");
	    				if(record){
	    					var param = {
	    						"DIV_CODE" : panelSearch.getValue("DIV_CODE"),
	    						"ITEM_CODE": record.data["ITEM_CODE"],
	    						"BASE_DATE": getUnFormatDate(record.data["BASIS_DATE"])
	    					};
	    					mrp400skrvService.selectMrpPopHead(param, function(provider, response)	{
	    						if(!Ext.isEmpty(provider)){

	    							MrpExceptStockSearch.setValue("DIV_CODE"     , provider["DIV_NAME"]);
	    					        MrpExceptStockSearch.setValue("ITEM_CODE"    , provider["ITEM_CODE"]);
	    					        MrpExceptStockSearch.setValue("ITEM_NAME"    , provider["ITEM_NAME"]);
	    					        MrpExceptStockSearch.setValue("BASE_DATE"    , provider["BASE_DATE"]);
	    					        MrpExceptStockSearch.setValue("STOCK_UNIT"   , provider["STOCK_UNIT"]);
	    					        MrpExceptStockSearch.setValue("SPEC"         , provider["SPEC"]);
	    						}
	    						MrpExceptStockStore.loadStoreRecords(param);
	    					});
	    				}
	    			}
                }
			})
		}
		exceptStockWindow.center();
		exceptStockWindow.show();
	}

    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, masterGrid2, panelResult
			]
		},panelSearch],
		id  : 'mrp400skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.getField('rdoSelect').setValue("");
			panelResult.getField('rdoSelect').setValue("");
			panelSearch.getField('rdoSelect2').setValue("");
			panelResult.getField('rdoSelect2').setValue("");
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			    masterGrid2.reset();
			    masterGrid2.getStore().clearData();
		        masterGrid.getStore().loadStoreRecords();
			}
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save',false);
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
        	this.fnInitBinding();
        }
	});
};
</script>