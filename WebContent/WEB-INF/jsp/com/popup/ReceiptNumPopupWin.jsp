<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.receiptNumPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 

	 Unilite.defineModel('${PKGNAME}.popupModel', {
	    fields: [
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120',},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.sales.receiptnum" default="접수번호"/>'			, type: 'string'},
			{name: 'RECEIPT_DATE'		, text: '<t:message code="system.label.sales.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string'},
			{name: 'SERIAL_NO'			, text: '<t:message code="system.label.sales.asserialno" default="S/N"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'RECEIPT_PRSN'		, text: '<t:message code="system.label.sales.salesdate" default="담당자"/>'			, type: 'string'},
			{name: 'USER_NAME'			, text: '<t:message code="system.label.sales.salesdate" default="담당자"/>'			, type: 'string'},	
			{name: 'REPAIR_YN'			, text: '<t:message code="system.label.sales.warranty" default="수리여부"/>'			, type: 'string', comboType: 'AU', comboCode: 'S163'},
			{name: 'REPAIR_RANK'		, text: '<t:message code="system.label.sales.asrank" default="수리랭크"/>'				, type: 'string', comboType: 'AU', comboCode: 'S164'},
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.saledate" default="판매일"/>'			, type: 'string'},
			{name: 'WARR_MONTH'			, text: '<t:message code="system.label.sales.warranty" default="보증기간"/>'			, type: 'string', comboType: 'AU', comboCode: 'S166'},
			{name: 'WARR_DATE'			, text: '<t:message code="system.label.sales.warrantyDate" default="보증일"/>'		, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.sales.receiptremark" default="접수내역"/>'		, type: 'string'},
			{name: 'MACHINE_TYPE'		, text: '<t:message code="system.label.sales.equipmenttype" default="장비유형"/>'		, type: 'string'},
			{name: 'COST_YN'		    , text: '<t:message code="system.label.sales.costyn" default="유무상"/>'		        , type: 'string'},
			{name: 'IN_DATE'		    , text: '<t:message code="system.label.sales.receiptdate" default="입고일"/>'		    , type: 'uniDate'},
			{name: 'WON_CALC_BAS'		, text: '원미만 계산법'		, type: 'string'},
			{name: 'TAX_TYPE'			, text: '세액포함여부'		, type: 'string'}
		]
	});

    
    
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
    
    me.panelSearch = Unilite.createSearchForm('',{
        layout: {
        	type: 'uniTable', 
        	columns: 3, 
        	tableAttrs: {
	            style: {
	                width: '100%'
	            }
	        }
	    },
        items: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				allowBlank	: false,
				width       : 200,
				labelWidth   : 60
			},{
				fieldLabel		: '<t:message code="system.label.sales.receiptdate2" default="접수일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'RECEIPT_DATE_FR',
				endFieldName	: 'RECEIPT_DATE_TO',
				allowBlank	    : false,
				labelWidth       : 70,
				colspan         : 2
			},Unilite.popup('SAS_LOT', {allowInputData : true, labelWidth:60, textFieldWidth:135})
			,Unilite.popup('DIV_PUMOK',{
				fieldLabel:'<t:message code="system.label.sales.asitemcode" default="A/S 품목"/>',
				width:300,
				labelWidth       : 70
			 })
			,Unilite.popup('CUST',{
				fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>',
				width:300,
				labelWidth       : 60
			}),{
				fieldLabel	: '진행상태'  ,
				name		: 'AS_STATUS',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				combCode	: 'S163',
				hidden      : true
			}
			]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.exBlnoPopupStore',{
							model: '${PKGNAME}.popupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.selectReceiptNumPopup'
					            }
					        }
					}),
	        uniOpt:{
                 expandLastColumn:true,
                 useRowNumberer: false,
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
	                    { dataIndex: 'RECEIPT_NUM' 	, width: 130 },
	                    { dataIndex: 'RECEIPT_DATE'	, width: 100 },
	                    { dataIndex: 'ITEM_CODE'	, width: 80},
						{ dataIndex: 'ITEM_NAME'	, width: 130},
						{ dataIndex: 'SERIAL_NO'	, width: 100},
						{ dataIndex: 'CUSTOM_CODE'	, width: 80},
						{ dataIndex: 'CUSTOM_NAME'	, width: 100},
						{ dataIndex: 'USER_NAME'	, width: 100},
						{ dataIndex: 'REPAIR_YN'	, width: 80},
						{ dataIndex: 'REPAIR_RANK'	, width: 80 },
						{ dataIndex: 'WARR_MONTH'	, width: 80 }
	        ],
			listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
					var rv = {
						status : "OK",
						data:[record.data]
					};
					me.returnData(rv);
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
				}
			}
	    });
	    
		config.items = [me.panelSearch, 	me.masterGrid];
      	me.callParent(arguments);
    },
    initComponent : function(){    
    	var me  = this;
        me.panelSearch.setValue('RECEIPT_DATE_FR' , UniDate.get('startOfMonth'))
        me.panelSearch.setValue('RECEIPT_DATE_TO' , UniDate.today())
        me.masterGrid.focus();
        
    	this.callParent();    	
    },
	fnInitBinding : function(param) {
        var me = this;
		if( Ext.isDefined(param)) {
			me.panelSearch.setValues(param);
		}
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
		var selectRecord = me.masterGrid.getSelectedRecord();
		var rv ;
		if(selectRecord)	{
		 	rv = {
				status : "OK",
				data:[selectRecord.data]
			};
		}
		me.returnData(rv);
	},
	_dataLoad : function() {
        var me = this;
		var param= me.panelSearch.getValues();
		console.log( "_dataLoad: ", param );
		if(me.panelSearch.isValid())	{
			me.isLoading = true;
			me.masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
		} else {
			me.panelSearch.getInvalidMessage();
		}
	}
});

