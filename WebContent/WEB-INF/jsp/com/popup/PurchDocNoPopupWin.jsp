<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.purchDocNoPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 

	 Unilite.defineModel('${PKGNAME}.ExBlnoPopupModel', {
	    fields: [
	    	{name: 'PURCH_DOC_NO'			, text: '<t:message code="system.label.sales.purchasedocumentno" default="구매확인서번호"/>'	, type: 'string'},
			{name: 'ISSUE_DATE' 	, text: '<t:message code="system.label.sales.issuedate2" default="발급일자"/>'							, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'						, type: 'string', comboType: 'BOR120'},
			{name: 'SALE_CUSTOM_CODE' 	, text: '<t:message code="system.label.sales.client" default="고객"/>'							, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'						, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'								, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'						, type: 'string'},
			{name: 'SPEC'				,text:'<t:message code="system.label.sales.spec" default="규격"/>'								, type: 'string'},
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'						, type: 'uniDate'},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'						, type: 'string', comboType: 'AU', comboCode: 'S024'},
			{name: 'SALE_TYPE'			, text: '<t:message code="system.label.sales.salesclass" default="매출구분"/>'						, type: 'string'},
			{name: 'SALE_TYPE_NAME'		, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'					, type: 'string'},
			{name: 'SALE_Q'				, text: '<t:message code="system.label.sales.qty" default="수량"/>'								, type: 'uniQty'},
			{name: 'SALE_TOT_O'			, text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'					, type: 'uniPrice'},
			{name: 'SALE_LOC_AMT_I'		, text: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>'				, type: 'uniPrice'},
			{name: 'SALE_LOC_EXP_I'		, text: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>'		, type: 'uniPrice'},
			{name: 'TAX_AMT_O'			, text: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>'					, type: 'uniPrice'},
			{name: 'SALE_PRSN'			, text: '<t:message code="system.label.sales.charger" default="담당자"/>'							, type: 'string'},
			{name: 'SALE_PRSN_NAME'		, text: '<t:message code="system.label.sales.charger" default="담당자"/>'							, type: 'string'},
			{name: 'BILL_NUM'			, text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'						, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'					, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'						, type: 'string'}
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
        	columns: 2, 
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
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					//20190731 임시 주석
//					combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = salesNoSearch.getField('SALE_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>' ,
				validateBlank	: false,
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
			}),{
				fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'SALE_DATE_FR',
				endFieldName	: 'SALE_DATE_TO',
				width			: 350
			},{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'SALE_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010'
			}]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.exBlnoPopupStore',{
							model: '${PKGNAME}.ExBlnoPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.selectPurchDocNoPopupList'
					            }
					        }
					}),
	        uniOpt:{
                 expandLastColumn: false
                ,useRowNumberer: false,
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
	                    { dataIndex: 'PURCH_DOC_NO' 	, width: 100 },
	                    { dataIndex: 'ISSUE_DATE'		, width: 80 },
	                    { dataIndex: 'DIV_CODE'			, width: 100},
						{ dataIndex: 'CUSTOM_NAME'		, width: 130},
						{ dataIndex: 'SALE_DATE'		, width: 100},
						{ dataIndex: 'BILL_TYPE'		, width: 73},
						{ dataIndex: 'SALE_TYPE_NAME'	, width: 100},
						{ dataIndex: 'SALE_Q'			, width: 86},
						{ dataIndex: 'SALE_TOT_O'		, width: 86},
						{ dataIndex: 'SALE_LOC_AMT_I'	, width: 86},
						{ dataIndex: 'SALE_LOC_EXP_I'	, width: 80},
						{ dataIndex: 'TAX_AMT_O'		, width: 80},
						{ dataIndex: 'SALE_PRSN_NAME'	, width: 66},
						{ dataIndex: 'BILL_NUM'			, width: 120},
						{ dataIndex: 'PROJECT_NO'		, width: 86},
						{ dataIndex: 'INOUT_NUM'		, minWidth: 90, flex: 1 }
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
        
		me.panelSearch.setValue('SALE_DATE_TO', new Date());
		me.panelSearch.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', me.panelSearch.getValue('SALE_DATE_FR')));
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
		me.isLoading = true;
		me.masterGrid.getStore().load({
			params : param,
			callback:function()	{
				me.isLoading = false;
			}
		});
	}
});

