<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.sasLotPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 

	 Unilite.defineModel('${PKGNAME}.popupModel', {
	    fields: [
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120',},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'				, type: 'string'},
			{name: 'SERIAL_NO'			, text: '<t:message code="system.label.sales.asserialno" default="S/N"/>'		, type: 'string'},
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'		, type: 'uniDate'},
			{name: 'WARR_MONTH'			, text: '<t:message code="system.label.sales.warranty" default="보증기간"/>'		, type: 'string', comboType: 'AU', comboCode: 'S166'},
			{name: 'WARR_DATE'		    , text: '<t:message code="system.label.sales.warrantyDate" default="보증일"/>'	, type: 'string'},
			{name: 'AS_STATUS'			, text: '진행상태'				, type: 'string'}
			
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
				allowBlank	: false
			},{
				fieldLabel		: '<t:message code="system.label.sales.asserialno" default="S/N"/>',
				name			: 'SERIAL_NO',
				width			:  200,
				labelWidth  	:  50,
				allowBlank	: false
			},{
				fieldLabel	: '',
				labelWidth  : 0,
				width		: 200,
				name		: 'GUBUN',
				xtype		: 'uniRadiogroup',
				allowBlank	: false,
				items		: [{
						boxLabel	: '<t:message code="system.label.sales.salehistory" default="판매"/>',
						name		: 'GUBUN',
						inputValue	: '1',
						checked     : true
					},{
						boxLabel	: '<t:message code="system.label.sales.ashistory" default="기존수리이력"/>',
						name		: 'GUBUN',
						inputValue	: '2'
				}]
			}]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.exBlnoPopupStore',{
							model: '${PKGNAME}.popupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.selectSasLotPopupList'
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
	                    { dataIndex: 'CUSTOM_CODE' 	, width: 100 },
	                    { dataIndex: 'CUSTOM_NAME'	, width: 100 },
	                    { dataIndex: 'ITEM_CODE'	, width: 80},
						{ dataIndex: 'ITEM_NAME'	, width: 130},
						{ dataIndex: 'SPEC'			, width: 130},
						{ dataIndex: 'SERIAL_NO'	, width: 100},
						{ dataIndex: 'SALE_DATE'	, width: 100},
						{ dataIndex: 'WARR_MONTH'	, width: 80},
						{ dataIndex: 'WARR_DATE'	, width: 80 }
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
			//me.panelSearch.getInvalidMessage();
		}
	}
});

