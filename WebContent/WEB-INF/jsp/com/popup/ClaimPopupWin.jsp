<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 클레임번호 팜업
request.setAttribute("PKGNAME","Unilite.app.popup.ClaimPopup");
%>
	

/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.ClaimPopupModel', {
    fields: [
        {name: 'DIV_CODE'       , text: '<t:message code="system.label.common.division" default="사업장"/>'       , type: 'string', comboType:'BOR120'},
        {name: 'CUSTOM_CODE'    , text: '<t:message code="system.label.common.customcode" default="거래처코드"/>'   , type: 'string'},
        {name: 'CUSTOM_NAME'    , text: '<t:message code="system.label.common.customname" default="거래처명"/>'     , type: 'string'},
        {name: 'CLAIM_NO'       , text: '<t:message code="system.label.common.claimno" default="클레임번호"/>'   , type: 'string'},
        {name: 'CLAIM_DATE'     , text: '<t:message code="system.label.common.receiptdate" default="접수일"/>'     , type: 'uniDate'}
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
//    var t1= false, t2 = false;
//    if( Ext.isDefined(wParam)) {
//        if(wParam['TYPE'] == 'VALUE') {
//            t1 = true;
//            t2 = false;			            
//        } else {
//            t1 = false;
//            t2 = true;			            
//        }
//    }
	me.panelSearch = Unilite.createSearchForm('',{
	    layout : {type : 'uniTable', columns : 2, tableAttrs: {
	        style: {
	            width: '100%'
	        }
	    }},
	    items: [{
                fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
                name: 'DIV_CODE',
                holdable: 'hold',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                value: UserInfo.divCode,
                allowBlank:false
            },      
            Unilite.popup('CUST', {
                    fieldLabel: '<t:message code="system.label.common.custom" default="거래처"/>', 
                    valueFieldName: 'CUSTOM_CODE',
                    textFieldName: 'CUSTOM_NAME'
            }),{ 
                fieldLabel: '<t:message code="system.label.common.receiptdate" default="접수일"/>',
                xtype: 'uniDatefield',
                name: 'CLAIM_DATE',
                value: UniDate.get('today')
            },{ 
                fieldLabel: '<t:message code="system.label.common.claimno" default="클레임번호"/>',     
                name: 'TXT_SEARCH', 
                xtype: 'uniTextfield' 
            }
        ]
	
	});  

/**
 * Master Grid 정의(Grid Panel)
 * @type 
 */
	 var masterGridConfig = {
		store: Unilite.createStore('${PKGNAME}.claimPopupMasterStore',{
						model: '${PKGNAME}.ClaimPopupModel',
				        autoLoad: false,
				        proxy: {
				            type: 'direct',
				            api: {
				            	read: 'popupService.claimPopup'
				            }
				        }
				}),
		
        uniOpt:{
//            useRowNumberer: false,
            onLoadSelectFirst : false,
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
            {dataIndex : 'DIV_CODE'               , width : 80},
            {dataIndex : 'CUSTOM_CODE'            , width : 120},
            {dataIndex : 'CUSTOM_NAME'            , width : 200},
            {dataIndex : 'CLAIM_NO'               , width : 80},
            {dataIndex : 'CLAIM_DATE'             , width : 80}
        ] ,
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
	    };
	    if(Ext.isDefined(wParam)) {		
			 if(wParam['SELMODEL'] == 'MULTI') {
			  masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
			 }
		 }
		 me.masterGrid = Unilite.createGrid('', masterGridConfig);
		 
		config.items = [me.panelSearch,	me.masterGrid];
	    me.callParent(arguments);

    },
	initComponent : function(){    
    	var me  = this;
        
        me.masterGrid.focus();
        
    	this.callParent();    	
    },    
	fnInitBinding : function(param) {
        var me = this;
        var frm = me.panelSearch;
        if(param['DIV_CODE'] && param['DIV_CODE']!='')      frm.setValue('DIV_CODE',   param['DIV_CODE']);
        if(param['CLAIM_NO'] && param['CLAIM_NO']!='')      frm.setValue('TXT_SEARCH', param['CLAIM_NO']);
        
        this._dataLoad();
    },
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
		var selectRecords = me.masterGrid.getSelectedRecords();
		var rvRecs= new Array();
		Ext.each(selectRecords, function(record, i)	{
			rvRecs[i] = record.data;
		})
	 	var rv = {	
			status : "OK",
			data:rvRecs
		};
		me.returnData(rv);
	},
	_dataLoad : function() {
		var me = this;
		if(me.panelSearch.isValid())	{
			var param= me.panelSearch.getValues();	
			me.isLoading = true;
			me.masterGrid.getStore().load({
				params : param,
			callback:function()	{
				me.isLoading = false;
			}
			});
		}
	}
});

