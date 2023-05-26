<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.repairHistoryPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />				// 사업장 
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S163" />	//진행상태
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S164" />	//수리랭크
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S168" />	//위치코드
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S169" />	//증상코드
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S170" />	// 원인코드
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S171" />	// 해결코드
    <t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S802" />    // 유무상

	 Unilite.defineModel('${PKGNAME}.popupModel', {
	    fields: [
	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.sales.division" default="사업장"/>'		,	 type: 'string', comboType: 'BOR120',},
			{name: 'REPAIR_DATE'			, text: '<t:message code="system.label.sales.repairdate" default="수리일"/>'			, type: 'uniDate'},
			{name: 'REPAIR_NUM'				, text: '<t:message code="system.label.sales.repairnum" default="수리번호"/>'			, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.sales.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.sales.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'REPAIR_DATE'			, text: '<t:message code="system.label.sales.repairdate" default="완료일"/>'			, type: 'uniDate'},
			{name: 'REPAIR_RANK'			, text: '<t:message code="system.label.sales.asrank" default="수리랭크"/>'				, type: 'string', comboType: 'AU', comboCode: 'S164'},
			{name: 'BAD_LOC_CODE'			, text: '<t:message code="system.label.sales.repairparts" default="위치"/>'			, type: 'string', comboType: 'AU', comboCode: 'S168'},
			{name: 'BAD_CONDITION_CODE'		, text: '<t:message code="system.label.sales.repaircausescondition" default="증상"/>'	, type: 'string', comboType: 'AU', comboCode: 'S169'},
			{name: 'BAD_REASON_CODE'		, text: '<t:message code="system.label.sales.repaircauses" default="원인"/>'			, type: 'string', comboType: 'AU', comboCode: 'S170'},
			{name: 'SOLUTION_CODE'			, text: '<t:message code="system.label.sales.repairsonlution" default="해결"/>'		, type: 'string', comboType: 'AU', comboCode: 'S171'},
			{name: 'COST_YN'			    , text: '유뮤상'		, type: 'string', comboType: 'AU', comboCode: 'S802'},
			{name: 'SERIAL_NO'				, text: 'S/N'		, type: 'string'}
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
			},Unilite.popup('SAS_LOT', {allowInputData : true, readOnly:true, labelWidth:60, textFieldWidth:135, allowBlank:false})
			,{
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
					            	read: 'popupService.selectRepairHistoryPopup'
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
	                    { dataIndex: 'REPAIR_DATE' 	, width: 100 },
	                    { dataIndex: 'REPAIR_NUM'	, width: 130 },
	                    { dataIndex: 'ITEM_CODE'	, width: 80},
						{ dataIndex: 'ITEM_NAME'	, width: 130},
						{ dataIndex: 'SERIAL_NO'	, width: 100},
						{ dataIndex: 'CUSTOM_CODE'	, width: 80},
						{ dataIndex: 'CUSTOM_NAME'	, width: 100},
						{ dataIndex: 'REPAIR_DATE'	, width: 100},
						{ dataIndex: 'REPAIR_RANK'	, width: 100},
						{ dataIndex: 'COST_YN'	        , width: 80 },
						{ dataIndex: 'BAD_LOC_CODE'	, width: 200 },
						{ dataIndex: 'BAD_CONDITION_CODE'		, width: 200},
						{ dataIndex: 'BAD_REASON_CODE'	, width: 200 },
						{ dataIndex: 'SOLUTION_CODE'	, width: 200 }
	        ]
	    });
	    
		config.items = [me.panelSearch, 	me.masterGrid];
      	me.callParent(arguments);
    },
    initComponent : function(){    
    	var me  = this;
        me.panelSearch.setValue('SERIAL_NO' , me.param.SERIAL_NO);
        me.masterGrid.focus();
        
    	this.callParent();    	
    },
	fnInitBinding : function(param) {
        var me = this;
		if( Ext.isDefined(param)) {
			me.panelSearch.setValues(param);
		}
		this.setToolbarButtons(['apply'], false);
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        this.close();
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

