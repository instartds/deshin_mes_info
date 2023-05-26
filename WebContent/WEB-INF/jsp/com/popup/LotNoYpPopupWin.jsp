<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.LotNoYpPopup");
%>
	<t:ExtComboStore useScriptTag="false" items="${COMBO_WH_LIST}" storeId="whList" />		// 창고


var gsHiddenFlag= true;			//출하지시량 입력을 사용여부 flag
var gsTotQty	= true;			//기존 출하지시량
/**
 *   Model 정의
 * @type
 */
Unilite.defineModel('${PKGNAME}.LotNoYpPopupModel', {
    fields: [
   	 	{name: 'CUSTOM_CODE'	 			, text: '<t:message code="system.label.common.customcode" default="거래처코드"/>'			, type: 'string'},
   	 	{name: 'CUSTOM_NAME'   				, text: '<t:message code="system.label.common.customname" default="거래처명"/>'			, type: 'string'},
   	 	{name: 'FARM_CODE'                  , text: '<t:message code="system.label.common.farmcode" default="농가코드"/>'          , type: 'string'},
   	 	{name: 'FARM_NAME'                  , text: '<t:message code="system.label.common.farmname" default="농가명"/>'          , type: 'string'},
   	 	{name: 'ITEM_CODE'     				, text: '<t:message code="system.label.common.itemcode" default="품목코드"/>'			, type: 'string'},
   	 	{name: 'ITEM_NAME'     				, text: '<t:message code="system.label.common.itemname" default="품목명"/>'			, type: 'string'},
   	 	{name: 'SPEC'			 			, text: '<t:message code="system.label.common.spec" default="규격"/>'			, type: 'string'},
   	 	{name: 'STOCK_UNIT'    				, text: '<t:message code="system.label.common.inventoryunit" default="재고단위"/>'			, type: 'string'},
   	 	{name: 'WH_CODE'      				, text: '<t:message code="system.label.common.warehouse" default="창고"/>'			, type: 'string', store: Ext.data.StoreManager.lookup('whList')},
   	 	{name: 'WH_CELL_CODE'               , text: '<t:message code="system.label.common.warehouse" default="창고"/>cell'		, type: 'string'},
   	 	{name: 'WH_CELL_NAME'               , text: '<t:message code="system.label.common.warehouse" default="창고"/>cell'		, type: 'string'},
   	 	{name: 'LOT_NO'        				, text: '<t:message code="system.label.common.lotno" default="LOT번호"/>'			, type: 'string'},
   	 	{name: 'LOTNO_CODE'                 , text: '<t:message code="system.label.common.lotno" default="LOT번호"/>'			, type: 'string'},
   	 	{name: 'INSTOCK_Q'     				, text: '<t:message code="system.label.common.receiptqty" default="입고수량"/>'			, type: 'uniQty'},
   	 	{name: 'OUTSTOCK_Q'	   				, text: '<t:message code="system.label.common.issueqty" default="출고량"/>'			, type: 'uniQty'},
   	 	{name: 'OUTSTOCK_REQ_Q'	   			, text: '<t:message code="system.label.common.inputqty" default="투입량"/>'			, type: 'uniQty'},
   	 	{name: 'STOCK_Q'	   				, text: '<t:message code="system.label.common.onhandstock" default="현재고"/>'			, type: 'uniQty'},
   	 	{name: 'ALLOW_Q'				, text: '가용재고' 		, type: 'uniQty'},
   	 	{name: 'ALLOW_Q2'				, text: '가용재고(사내)' 		, type: 'uniQty'},
   	 	{name: 'ORDER_UNIT'                 , text: '<t:message code="system.label.common.salesunit" default="판매단위"/>'         , type: 'string'},
   	 	{name: 'TRANS_RATE'                 , text: '<t:message code="system.label.common.containedqty" default="입수"/>'            , type: 'string'},
   	 	{name: 'ORDER_UNIT_STOCK_Q'         , text: '<t:message code="system.label.common.salesunitinventoryqty" default="판매단위재고수량"/>'    , type: 'uniQty'},
   	 	{name: 'GOOD_STOCK_Q'	 			, text: '<t:message code="system.label.common.goodstock" default="양품재고"/>'			, type: 'uniQty'},
   	 	{name: 'BAD_STOCK_Q'	 			, text: '<t:message code="system.label.common.defectinventory" default="불량재고"/>'			, type: 'uniQty'},
   	 	{name: 'ISSUE_REQ_QTY'				, text: '<t:message code="system.label.common.shipmentorderqty" default="출하지시량"/>' 		, type: 'uniQty'},
    	{name: 'COMP_CODE'	 				, text: 'COMP_CODE' 	, type: 'string'},
   	 	{name: 'REMARK'        				, text: '<t:message code="system.label.common.remarks" default="비고"/>' 			, type: 'string'}
	]
});


/**
 * 검색조건 (Search Panel)
 * @type
 */
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    constructor : function(config) {
	    var me = this;
	    if (config) {
            Ext.apply(me, config);
        }
	    /**
	     * 검색조건 (Search Panel)
	     * @type
	     */
	    var wParam = this.param;
	    var t1= false, t2 = false;
	    if( Ext.isDefined(wParam)) {
	        if(wParam['TYPE'] == 'VALUE') {
	            t1 = true;
	            t2 = false;

	        } else {
	            t1 = false;
	            t2 = true;

	        }
	    }

	    me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'table', columns : 3, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items: [{
	        		fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
	        		name: 'DIV_CODE',
	        		xtype: 'uniCombobox',
	        		comboType: 'BOR120',
	        		allowBlank:false
				},
				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '<t:message code="system.label.common.itemcode" default="품목코드"/>',
			        	validateBlank: false
			   }),{
					fieldLabel: '<t:message code="system.label.common.lotno" default="LOT번호"/>',
					name:'LOTNO_CODE',
					xtype: 'uniTextfield'
				},{
				fieldLabel: '<t:message code="system.label.common.warehouse" default="창고"/>',
				name: 'S_WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
				},
			    Unilite.popup('CUST',{
			        	fieldLabel: '<t:message code="system.label.common.custom" default="거래처"/>',
			        	valueFieldName: 'CUSTOM_CODE_S',
						textFieldName: 'CUSTOM_NAME_S',
			        	validateBlank: false
			   }),{
					xtype: 'uniRadiogroup',
					fieldLabel: '<t:message code="system.label.common.onhandstockyn" default="현재고 유무"/>',
					labelWidth:90,
					items : [{
						boxLabel: '<t:message code="system.label.common.yes" default="유"/>',
						width:60,
						name:'STOCK_YN',
						inputValue: 'Y',
                        checked: true
					},{
						boxLabel: '<t:message code="system.label.common.no" default="무"/>',
						width:60,
						name:'STOCK_YN',
						inputValue: 'N'
					},{
						boxLabel: '<t:message code="system.label.common.whole" default="전체"/>',
						width:60,
						name:'STOCK_YN' ,
						inputValue: ''
					}]
				},{
					xtype: 'uniTextfield',
					name: 'S_WH_CELL_CODE',
					hidden: true
				},{
					xtype: 'component',
					width: 100
				},{
					xtype: 'component',
					width: 100
				},{
                    fieldLabel: '<t:message code="system.label.common.shipmentorderqty" default="출하지시량"/>',
                    xtype: 'uniNumberfield',
                    name: 'ISSUE_REQ_QTY',
                    readOnly: true,
                    hidden: true
                },{
                    fieldLabel: '<t:message code="system.label.common.salesunit" default="판매단위"/>',
                    xtype: 'uniTextfield',
                    name: 'ORDER_UNIT',
                    readOnly: true,
                    hidden: true
                },{
                    fieldLabel: '<t:message code="system.label.common.containedqty" default="입수"/>',
                    xtype: 'uniTextfield',
                    name: 'TRANS_RATE',
                    readOnly: true,
                    hidden: true
                }
			]
		});
/**
 * Master Grid 정의(Grid Panel)
 * @type
 */
		 me.masterGrid = Unilite.createGrid('', {
			store: Unilite.createStore('${PKGNAME}.LotNoYpPopupMasterStore',{
				model: '${PKGNAME}.LotNoYpPopupModel',
				autoLoad: false,
				proxy: {
					type: 'uniDirect',
					api: {
						read: 'popupService.lotNoYpPopup'
					}
				},
				uniOpt	: {
					isMaster	: false,
					editable	: true,
					deletable	: false,
					useNavi 	: false

				},
				saveStore : function(config)	{
					var inValidRecs = this.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						//this.syncAll(config);
						this.syncAllDirect(config);
					}else {
						alert(Msg.sMB083);
					}
				},
				listeners:{
					update:function(store, record, operation, modifiedFieldNames, details, eOpts )	{
						if( wParam.useInputQty )	{
							if(modifiedFieldNames.indexOf("OUTSTOCK_REQ_Q") > -1)	{
								if(record.get('OUTSTOCK_REQ_Q') > 0 )	{
									var selectedRecords = me.masterGrid.getSelectedRecords();
									selectedRecords.push(record);
									me.masterGrid.getSelectionModel().select(selectedRecords);
								} else {
									me.masterGrid.getSelectionModel().deselect(record);
								}
								var sumQty = me.masterGrid.down("#outQuantity");
								sumQty.setValue(store.sum('OUTSTOCK_REQ_Q'));
							}
						}else if(!gsHiddenFlag){
						        var sumQty = me.masterGrid.down("#SEL_ISSUE_REQ_Q_TBAR");
								sumQty.setValue(store.sum('ISSUE_REQ_QTY'));
						}
					}
				}
			}),
			uniOpt:{
				expandLastColumn: false,
				onLoadSelectFirst: wParam['SELMODEL'] == 'MULTI' ? false:true,
	            state: {
					useState: false,
					useStateList: false
	            },
				pivot : {
					use : false
				}
	        },
			tbar: [{	xtype:'container',
						layout : {type : 'uniTable', columns : 2},
						padding : '0 0 0 0',
						items:[	{fieldLabel : '<t:message code="system.label.common.shipmentorderqty" default="출하지시량"/>',
										itemId:'ISSUE_REQ_Q_TBAR',
										xtype:'uniNumberfield',
										labelWidth:75,
										width:200,
										type:'uniQty',
										decimalPrecision: 2,
										margin: '0 20 0 0',
										readOnly:true,
										hidden: true,
										listeners: {
											change: function(field, newValue, oldValue, eOpts) {

											}
						        		}
				        			}]
			        		},{xtype:'container',
								layout : {type : 'uniTable', columns : 2},
								padding : '0 20 0 0',
								items:[ {fieldLabel : '<t:message code="system.label.common.inputshipmentorderqty" default="입력 출하지시량"/>',
											itemId:'SEL_ISSUE_REQ_Q_TBAR',
											xtype:'uniNumberfield',
											margin: '0 0 0 0',
											type:'uniQty',
											width:225,
											decimalPrecision: 2,
											readOnly:true,
											hidden: true,
											listeners: {
												change: function(field, newValue, oldValue, eOpts) {

												}
							        		}
				        			 }]
				              }],

			selModel: wParam['SELMODEL'] == 'MULTI' ? Ext.create("Ext.selection.CheckboxModel", { checkOnly : true }) : 'rowmodel',
		    columns:  [
		           	{dataIndex : 'ITEM_CODE'     			, width :90},
		           	{dataIndex : 'ITEM_NAME'     			, width :120},
		           	{dataIndex : 'SPEC'			 			, width :90},
		           	{dataIndex : 'STOCK_UNIT'    			, width :80},
		           	{dataIndex : 'WH_CODE'       			, width :100},
		           	{dataIndex : 'WH_CELL_CODE'             , width :66, hidden: true},
		           	{dataIndex : 'WH_CELL_NAME'             , width :100, hidden: true},
		           	{dataIndex : 'LOT_NO'        			, width :95},
		           	{dataIndex : 'INSTOCK_Q'     			, width :100, hidden: true},
		           	{dataIndex : 'OUTSTOCK_Q'	   			, width :100, hidden: true},
		           	{dataIndex : 'STOCK_Q'	   				, width :80},
		           	{dataIndex : 'ALLOW_Q'	   				, width :120},
		           	{dataIndex : 'ALLOW_Q2'	   				, width :120},
		           	{dataIndex : 'OUTSTOCK_REQ_Q'	   		, width :80,	hidden: !wParam.useInputQty},//useInputQty : true : 투입량 사용
		           	{dataIndex : 'ORDER_UNIT'               , width :80, hidden: true},
		           	{dataIndex : 'TRANS_RATE'               , width :80, hidden: true},
		           	{dataIndex : 'ORDER_UNIT_STOCK_Q'       , width :120, hidden: true},
		           	{dataIndex : 'GOOD_STOCK_Q'	 			, width :80, hidden: true},
		           	{dataIndex : 'BAD_STOCK_Q'	 			, width :80, hidden: true},
		           	{dataIndex : 'ISSUE_REQ_QTY'			, width :100, hidden: true},
		           	{dataIndex : 'COMP_CODE'	 			, width :100, hidden: true},
		           	{dataIndex : 'REMARK'        			, width :100, hidden: true},
		           	{dataIndex : 'CUSTOM_CODE'	 			, width :100, hidden: true},
		           	{dataIndex : 'CUSTOM_NAME'   			, width :130},
		           	{dataIndex : 'FARM_CODE'                , width :133, hidden: true},
		           	{dataIndex : 'FARM_NAME'                , minWidth :130, flex: 1}
		      	] ,
				listeners: {
					render:function(grid, eOpt)	{
						//useInputQty : true : 투입량 사용
						var tbar = grid._getToolBar();
						console.log("tbar : ", tbar);
						 if(!Ext.isEmpty(tbar) && wParam.useInputQty ) 	{
						 	var reqQty = wParam.OUTSTOCK_REQ_Q ? wParam.OUTSTOCK_REQ_Q: 0;

						    tbar[0].insert(tbar[0].items.items.length,{
					        		xtype:'uniNumberfield',
					        		fieldLabel:'작업필요량',
					        		labelWidth:65,
									itemId:'reqQuantity',
									name:'reqQuantity',
									type: 'uniQty',
									value:reqQty,
									width:200,
									margin: '0 20 0 0',
									readOnly:true
						        });

						   tbar[0].insert(tbar[0].items.items.length,{
						        	xtype:'uniNumberfield',
					        		fieldLabel:'투입선택량',
					        		labelWidth:65,
									itemId:'outQuantity',
									name:'outQuantity',
									type: 'uniQty',
									value:0,
									width:200,
									readOnly:true
						        });

						 }
					},
					beforeedit  : function( editor, e, eOpts ) {
						if(UniUtils.indexOf(e.field, ['ISSUE_REQ_QTY', 'OUTSTOCK_REQ_Q'])){
							if(e.field == 'OUTSTOCK_REQ_Q')	{
								var sumQ = e.grid.store.sum('OUTSTOCK_REQ_Q');
								//var newValue = (wParam.OUTSTOCK_REQ_Q - sumQ) > 0 ? (wParam.OUTSTOCK_REQ_Q - sumQ) : 0 ;
								var newValue = wParam.OUTSTOCK_REQ_Q - sumQ ;
								if(newValue > e.record.get('ALLOW_Q2' ))	{
									e.record.set('OUTSTOCK_REQ_Q',e.record.get('ALLOW_Q2' ));
								} else if(newValue >= 0)	{
									e.record.set('OUTSTOCK_REQ_Q',newValue);
								}
							}else if(e.field == 'ISSUE_REQ_QTY'){
								var sumQ = e.grid.store.sum('ISSUE_REQ_QTY');
								var newValue = (wParam.ISSUE_REQ_QTY - sumQ) > 0 ? (wParam.ISSUE_REQ_QTY - sumQ) : 0 ;
								if(newValue > e.record.get('ORDER_UNIT_STOCK_Q' ))	{
									e.record.set('ISSUE_REQ_QTY',e.record.get('ORDER_UNIT_STOCK_Q' ));
								} else {
									e.record.set('ISSUE_REQ_QTY',newValue);
								}
							}
							return true;
						} else {
							return false;
						}
					},
					onGridDblClick:function(grid, record, cellIndex, colName) {
						me.onSubmitButtonDown();
//			          	var rv = {
//							status : "OK",
//							data:[record.data]
//						};
//						me.returnData(rv);
			        },
					onGridKeyDown: function(grid, keyCode, e) {
						if(e.getKey() == Ext.EventObject.ENTER) {

				        	var selectRecord = grid.getSelectedRecord();
						 	var rv = {
								status : "OK",
								data:[selectRecord.data]
							};
							me.returnData(rv);
			        	}
					},
					edit : function( editor, context, eOpts ) {
						/*if (!gsHiddenFlag && UniUtils.indexOf(context.field, ['ISSUE_REQ_QTY'])) {
							if(context.record.get('ISSUE_REQ_QTY') < 0) {
								context.record.set('ISSUE_REQ_QTY', 0);
								alert(Msg.sMB100);
								return false;
							}
							if(context.record.get('ORDER_UNIT_STOCK_Q') < context.record.get('ISSUE_REQ_QTY')) {
								context.record.set('ISSUE_REQ_QTY', 0);
								alert('출하지시량은 판매단위재고수량 보다 많을 수 없습니다.');
								return false;
							}*/

							//this.down('#SEL_ISSUE_REQ_Q_TBAR').setValue(me.masterGrid.getStore().sum("ISSUE_REQ_QTY"));
					     if(!Ext.isEmpty(gsHiddenFlag) && ! gsHiddenFlag){
								var record = context.record;
								var sumQ = context.grid.store.sum('ISSUE_REQ_QTY');
		           	 			if(record){
		           	 				var stockQ = record.get("ORDER_UNIT_STOCK_Q") ;
		           	 				if((wParam.ISSUE_REQ_QTY - sumQ) < 0){ // 필요 수향 체크

		           	 					if((wParam.ISSUE_REQ_QTY - (sumQ - context.value) ) < stockQ)	{ // 재고량 체크
		           	 						context.record.set(context.field, wParam.ISSUE_REQ_QTY- (sumQ - context.value));
		           	 					} else {
		           	 						context.record.set(context.field, stockQ);
		           	 					}
		           	 					return;
		           	 				}
		           	 				if(context.column.field.getValue() > stockQ )	{ // 재고량 체크
		           	 					alert("판매단위 재고수량이 초과되었습니다.");
		           	 					context.record.set(context.field, stockQ);
		           	 				}
		           	 			}
						   }

						if(wParam.useInputQty)	{
							var record = context.record;
							var sumQ = context.grid.store.sum('OUTSTOCK_REQ_Q');
	           	 			if(record){
	           	 				var stockQ = record.get("ALLOW_Q2") ;
	           	 				/*if((wParam.OUTSTOCK_REQ_Q - sumQ) < 0){ // 필요 수향 체크

	           	 					if((wParam.OUTSTOCK_REQ_Q - (sumQ - context.value) ) < stockQ)	{ // 재고량 체크

	           	 						//alert('작업필요량을 초과했습니다.'+'\n'+'작업필요량으로 자동 수정하겠습니다.');
	           	 						context.record.set(context.field, wParam.OUTSTOCK_REQ_Q- (sumQ - context.value));
	           	 					} else {
	           	 						//alert("현재고량이 초과되었습니다."+'\n'+'현재고량으로 자동 수정하겠습니다.');
	           	 						context.record.set(context.field, stockQ);
	           	 					}
	           	 					return;
	           	 				}*/
	           	 				/*if(context.column.field.getValue() > stockQ )	{ // 재고량 체크
	           	 					alert("현재고량이 초과되었습니다.")
	           	 					context.record.set(context.field, stockQ);
	           	 				}*/
	           	 			}
						}
					}
				}
		    });
		    config.items = [me.panelSearch, me.masterGrid];
		    me.callParent(arguments);
	    },
		initComponent : function(){
	    	var me  = this;
//	        me.masterGrid.focus();
	        this.callParent();
	    },
		fnInitBinding : function(param) {
			var me = this;
			me.param = param;
			var frm= me.panelSearch.getForm();

			//출고수량 입력을 사용할 경우(param.HIDDEN_FLAG = false) ISSUE_REQ_QTY, ORDER_UNIT, TRANS_RATE, ORDER_UNIT_STOCK_Q 컬럼 보이도록....
			if(!Ext.isEmpty(param.HIDDEN_FLAG) && !param.HIDDEN_FLAG) {
				gsHiddenFlag= param.HIDDEN_FLAG;
				gsTotQty	= param.ISSUE_REQ_QTY;
				me.masterGrid.getColumn('ISSUE_REQ_QTY').setHidden(param.HIDDEN_FLAG);
				me.masterGrid.getColumn('ORDER_UNIT').setHidden(param.HIDDEN_FLAG);
				me.masterGrid.getColumn('TRANS_RATE').setHidden(param.HIDDEN_FLAG);
				me.masterGrid.getColumn('ORDER_UNIT_STOCK_Q').setHidden(param.HIDDEN_FLAG);
				me.masterGrid.getColumn('ALLOW_Q').setHidden(true);
				me.masterGrid.getColumn('ALLOW_Q2').setHidden(true);
				me.panelSearch.setValue('ISSUE_REQ_QTY', gsTotQty);
				//me.panelSearch.getField('ISSUE_REQ_QTY').show();
				this.down('#ISSUE_REQ_Q_TBAR').setValue(gsTotQty);
				this.down('#SEL_ISSUE_REQ_Q_TBAR').setValue(0);
				this.down('#ISSUE_REQ_Q_TBAR').setHidden(false);
				this.down('#SEL_ISSUE_REQ_Q_TBAR').setHidden(false);
			}else if(param.useInputQty){ 											//작업지시등록(사내)
				me.masterGrid.getColumn('ALLOW_Q').setHidden(true);
				me.masterGrid.getColumn('ALLOW_Q2').setHidden(false);
			}else {																		//작업지시등록(구매)
				me.masterGrid.getColumn('ALLOW_Q').setHidden(false);
				me.masterGrid.getColumn('ALLOW_Q2').setHidden(true);
			}

			//me.panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			me.panelSearch.setValue('DIV_CODE', param.DIV_CODE);
			me.panelSearch.setValue('ITEM_CODE', param.ITEM_CODE);
			me.panelSearch.setValue('ITEM_NAME', param.ITEM_NAME);
			me.panelSearch.setValue('CUSTOM_CODE_S', param.CUSTOM_CODE_S);
			me.panelSearch.setValue('CUSTOM_NAME_S', param.CUSTOM_NAME_S);
			me.panelSearch.setValue('S_WH_CODE', param.S_WH_CODE);
			me.panelSearch.setValue('S_WH_CELL_CODE', param.S_WH_CELL_CODE);
			me.panelSearch.setValue('LOTNO_CODE'	, param.LOTNO_CODE);
			me.panelSearch.setValue('ORDER_UNIT' , param.ORDER_UNIT);
			me.panelSearch.setValue('TRANS_RATE' , param.TRANS_RATE);

			frm.findField('DIV_CODE').setReadOnly(true);
			if(param.IS_FORM == 'Y'){    //조회폼에서 호출한 팝업일시 readonly(false)
                frm.findField('ITEM_CODE').setReadOnly(false);
                frm.findField('ITEM_NAME').setReadOnly(false);
			}else{
                frm.findField('ITEM_CODE').setReadOnly(true);
                frm.findField('ITEM_NAME').setReadOnly(true);
			}


			this._dataLoad();
		},
		onQueryButtonDown : function()	{
			this._dataLoad();
		},
		onSubmitButtonDown : function()	{
			var me = this;
			var selectRecordChk = me.masterGrid.getSelectedRecord();
			if(Ext.isEmpty(selectRecordChk)){
				alert("선택된 데이터가 없습니다.");
				return false;
			}

			//일반적인 팝업을 사용할 경우,
			if((Ext.isEmpty(gsHiddenFlag) || gsHiddenFlag )&& !me.param.useInputQty) {

				var selectRecord = me.masterGrid.getSelectedRecord();
			 	var rv ;
			 	if(selectRecord.get('ALLOW_Q') <= 0){
			 		alert('가용재고가 없습니다.');
			 		return false;
			 	}
				if(selectRecord)	{
				 	rv = {
						status : "OK",
						data:[selectRecord.data]
					};
				}
				me.returnData(rv);

			// 작업 투여량 입력을 사용하는 경우 , useInputQty : true :
			} else if(me.param.useInputQty)	{
				var selectRecord = me.masterGrid.getSelectedRecord()
				if(selectRecord.get('ALLOW_Q2') <= 0){
			 		alert('가용재고가 없습니다.');
			 		return false;
			 	}
				/*var sumQ = Ext.util.Format.number( me.masterGrid.store.sum('OUTSTOCK_REQ_Q'), UniFormat.Qty);
				var reqQ = Ext.util.Format.number(me.param.OUTSTOCK_REQ_Q, UniFormat.Qty);
				if(sumQ == reqQ)	{*/
					var selectRecords =  me.masterGrid.getSelectedRecords();
					var rvRecs= new Array();
					Ext.each(selectRecords, function(record, i)	{
						rvRecs[i] = record.data;
					})
				 	var rv = {
						status : "OK",
						data:rvRecs
					};
					me.returnData(rv);
				/*} else {
					alert('작업필요량과 투입선택량이 일치하지 않습니다.');
				}*/
			//출고수량 입력을 사용할 경우,
			} else {
				var sumGrid 	= 0;
				var stockUnit	= '';
			 	var rvRecs		= new Array();
				var records		= me.masterGrid.getStore().data.items;
				var seq 		= 0;

				Ext.each(records, function(record, i){
					if(record.get('ISSUE_REQ_QTY') != '0'){
						stockUnit	= record.get('STOCK_UNIT');
						sumGrid = sumGrid + record.get('ISSUE_REQ_QTY');
						rvRecs[seq] = record.data;
						seq++;
					}
				});

				//기존에 입력된 출하지시량과 비교하여 처리하는 로직
				if (sumGrid == 0) {
					alert('입력된 출하지시량이 0 입니다.\n출하지시량을 입력하신 후 다시 진행하시기 바랍니다.');
					return false;
				}else if (sumGrid > gsTotQty) {
					if(confirm("기존 출하지시량(" + gsTotQty + stockUnit +") 보다 많은 수량(" + sumGrid + stockUnit + ")(이)가 입력 되었습니다.\n" + Msg.sMM461)) {
						var rv = {
							status	: "OK",
							data	: rvRecs
						};
						me.returnData(rv);
					}
				} else if (sumGrid < gsTotQty){
					if(confirm("기존 출하지시량(" + gsTotQty + stockUnit +") 보다 적은 수량(" + sumGrid + stockUnit + ")(이)가 입력 되었습니다.\n" + Msg.sMM461)) {
						var rv = {
							status	: "OK",
							data	: rvRecs
						};
						me.returnData(rv);
					}
				} else {
					var rv = {
						status	: "OK",
						data	: rvRecs
					};
					me.returnData(rv);
				}
			}
		},
		_dataLoad : function() {
				var me = this;
				var param= me.panelSearch.getValues();
				console.log( "_dataLoad: ", param );
				me.isLoading = true;
				me.masterGrid.getStore().load({
					params : param,
					callback:function()	{
						me.isLoading = false;
					}
				});
		}
	});
