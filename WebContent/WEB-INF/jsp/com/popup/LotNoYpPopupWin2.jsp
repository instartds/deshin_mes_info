<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.LotNoYpPopup2");
%>
	<t:ExtComboStore useScriptTag="false" items="${COMBO_WH_LIST}" storeId="whList" />		// 창고


var gsHiddenFlag= true;			//자재예약량 입력을 사용여부 flag
var gsTotQty	= true;			//기존 자재예약량
/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.LotNoYpPopup2Model', {
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
   	 	{name: 'STOCK_Q'	   				, text: '<t:message code="system.label.common.onhandstock" default="현재고"/>'			, type: 'uniQty'},
   	 	{name: 'GOOD_STOCK_Q'	 			, text: '<t:message code="system.label.common.goodstock" default="양품재고"/>'			, type: 'uniQty'},
   	 	{name: 'BAD_STOCK_Q'	 			, text: '<t:message code="system.label.common.defectinventory" default="불량재고"/>'			, type: 'uniQty'},
   	 	{name: 'OUTSTOCK_REQ_Q'				, text: '<t:message code="system.label.common.materialreservationqty" default="자재예약량"/>' 		, type: 'uniQty'},
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
						width:50,
						name:'STOCK_YN',
						inputValue: 'Y',
                        checked: true
					},{
						boxLabel: '<t:message code="system.label.common.no" default="무"/>',
						width:50,
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
                    fieldLabel: '<t:message code="system.label.common.materialreservationqty" default="자재예약량"/>',
                    xtype: 'uniNumberfield',
                    name: 'OUTSTOCK_REQ_Q',
                    type: 'uniQty',
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
			store: Unilite.createStore('${PKGNAME}.LotNoYpPopup2MasterStore',{
				model: '${PKGNAME}.LotNoYpPopup2Model',
				autoLoad: false,
				proxy: {
					type: 'uniDirect',
					api: {
						read: 'popupService.lotNoYpPopup2'
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
				}
			}),
			uniOpt:{
				expandLastColumn: false,
	            state: {
					useState: false,
					useStateList: false					
	            },
				pivot : {
					use : false
				}
	        },	
			selModel:'rowmodel',
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
		           	{dataIndex : 'GOOD_STOCK_Q'	 			, width :80, hidden: true},
		           	{dataIndex : 'BAD_STOCK_Q'	 			, width :80, hidden: true},
		           	{dataIndex : 'OUTSTOCK_REQ_Q'			, width :100, hidden: true},
		           	{dataIndex : 'COMP_CODE'	 			, width :100, hidden: true},
		           	{dataIndex : 'REMARK'        			, width :100, hidden: true},
		           	{dataIndex : 'CUSTOM_CODE'	 			, width :100, hidden: true},
		           	{dataIndex : 'CUSTOM_NAME'   			, width :130},
		           	{dataIndex : 'FARM_CODE'                , width :133, hidden: true},
		           	{dataIndex : 'FARM_NAME'                , minWidth :130, flex: 1}
		      	] ,
				listeners: {
					beforeedit  : function( editor, e, eOpts ) {
						if(UniUtils.indexOf(e.field, ['OUTSTOCK_REQ_Q'])){
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
						if (!gsHiddenFlag && UniUtils.indexOf(context.field, ['OUTSTOCK_REQ_Q'])) {
							if(context.record.get('OUTSTOCK_REQ_Q') < 0) {
								context.record.set('OUTSTOCK_REQ_Q', 0);
								alert(Msg.sMB100);
								return false;
							}
							if(context.record.get('STOCK_Q') < context.record.get('OUTSTOCK_REQ_Q')) {
								context.record.set('OUTSTOCK_REQ_Q', 0);
								alert('자재예약량은 재고수량 보다 많을 수 없습니다.');
								return false;
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
			
			//출고수량 입력을 사용할 경우(param.HIDDEN_FLAG = false) OUTSTOCK_REQ_Q, STOCK_Q 컬럼 보이도록....
			if(!Ext.isEmpty(param.HIDDEN_FLAG) && !param.HIDDEN_FLAG) {
				gsHiddenFlag= param.HIDDEN_FLAG;
				gsTotQty	= param.OUTSTOCK_REQ_Q;
				me.masterGrid.getColumn('OUTSTOCK_REQ_Q').setHidden(param.HIDDEN_FLAG);
				me.panelSearch.setValue('OUTSTOCK_REQ_Q', gsTotQty);
				me.panelSearch.getField('OUTSTOCK_REQ_Q').show();
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
			
			//일반적인 팝업을 사용할 경우,
			if(Ext.isEmpty(gsHiddenFlag) || gsHiddenFlag) {
				var selectRecord = me.masterGrid.getSelectedRecord();
			 	var rv ;
				if(selectRecord)	{
				 	rv = {
						status : "OK",
						data:[selectRecord.data]
					};
				}
				me.returnData(rv);
				
			//출고수량 입력을 사용할 경우,
			} else {
				var sumGrid 	= 0;
				var stockUnit	= '';
			 	var rvRecs		= new Array();
				var records		= me.masterGrid.getStore().data.items;
				var seq 		= 0;
				
				Ext.each(records, function(record, i){
					if(record.get('OUTSTOCK_REQ_Q') != '0'){
						stockUnit	= record.get('STOCK_UNIT');
						sumGrid = sumGrid + record.get('OUTSTOCK_REQ_Q');
						rvRecs[seq] = record.data;
						seq++;
					}
				});
				
				//기존에 입력된 자재예약량과 비교하여 처리하는 로직
				if (sumGrid == 0) {
					alert('입력된 자재예약량이 0 입니다.\n자재예약량을 입력하신 후 다시 진행하시기 바랍니다.');
					return false;
				}else if (sumGrid > gsTotQty) {
					alert("기존 자재예약량(" + gsTotQty + stockUnit +") 보다 많은 수량(" + sumGrid + stockUnit + ")(이)가 입력 되었습니다.");
					return false;
				} else if (sumGrid < gsTotQty){
					alert("기존 자재예약량(" + gsTotQty + stockUnit +") 보다 적은 수량(" + sumGrid + stockUnit + ")(이)가 입력 되었습니다.");
					return false;
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
