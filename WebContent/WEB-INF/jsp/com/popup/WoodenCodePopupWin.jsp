<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%		//목형정보 팝업 'Unilite.app.popup.WoodenCode' 
request.setAttribute("PKGNAME","Unilite.app.popup.WoodenCode");
%>
<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="WB08" />	//구분
<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="WB07" />	// 금형구분

	/** Model 정의 
	 */
	Unilite.defineModel('${PKGNAME}.WoodenCodePopupModel', {
		fields: [
			{name: 'GUBUN'							,text:'<t:message code="system.label.common.classfication" default="구분"/>'			,type: 'string', comboType: 'AU', comboCode: 'WB08'},
			{name: 'WOODEN_CODE'			,text:'<t:message code="system.label.common.woodencode" default="목형코드"/>'		,type: 'string'},
			{name: 'SN_NO'							,text:'SN_NO(LOT)'	,type: 'string'},
			{name: 'ITEM_CODE'					,text:'<t:message code="system.label.common.itemcode" default="품목코드"/>'		,type: 'string'},
			{name: 'ITEM_NAME'				,text:'<t:message code="system.label.common.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'EQU_GRADE'				,text:'<t:message code="system.label.common.status" default="상태"/>'			,type: 'string', comboType: 'AU', comboCode: 'I801'},
			{name: 'EQU_GUBUN'				,text:'<t:message code="system.label.common.woodendivision" default="목형구분"/>'		,type: 'string', comboType: 'AU', comboCode: 'I802'},
			{name: 'INSTOCK_DATE'			,text:'<t:message code="system.label.common.receiptdate2" default="입고일"/>'		,type: 'uniDate'},
			{name: 'TOT_PUNCH_Q'			,text:'<t:message code="system.label.common.totalpunchqty" default="누적타발수"/>'		,type: 'uniQty'},
			{name: 'MIN_PUNCH_Q'			,text:'MIN <t:message code="system.label.common.punchcount" default="타발수"/>'		,type: 'uniQty'},
			{name: 'MAX_PUNCH_Q'			,text:'MAX <t:message code="system.label.common.punchcount" default="타발수"/>'		,type: 'uniQty'}
		]
	});

	
	Ext.define('${PKGNAME}', {
		extend: 'Unilite.com.BaseJSPopupApp',
		autoScroll : true,
		constructor : function(config){
			var me = this;
			if (config) {
				Ext.apply(me, config);
			}
			me.form = Unilite.createSearchForm('', {
			layout	: {type : 'uniTable', columns : 2 },
			items	: [{
				fieldLabel	: '<t:message code="system.label.common.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
			tdAttrs		: {width: 280},
				allowBlank	: false,
				value		: UserInfo.divCode
			},{
				fieldLabel	: '<t:message code="system.label.common.classfication" default="구분"/>',
				name		: 'GUBUN',
				xtype		: 'uniCombobox',
				comboType	: 'AU', 
				comboCode	: 'WB08',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.common.status" default="상태"/>',
				name		: 'EQU_GRADE',
				xtype		: 'uniCombobox',
				comboType	: 'AU', 
				comboCode	: 'I801',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.common.woodeninfomation" default="목형정보"/>',
				name		: 'WOODEN_CODE',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		});
		
		
		
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
			store : Unilite.createStoreSimple('${PKGNAME}.WoodenCodePopupMasterStore',{
				model	: '${PKGNAME}.WoodenCodePopupModel',
				autoLoad: false,
				proxy	: {
					type: 'direct',
					api	: {
						read: 'popupService.woodenCode'
					}
				}
			}),
			uniOpt:{
				state: {
					useState	: false,
					useStateList: false	
				},
				pivot : {
					use : false
				}
			},
			selModel:'rowmodel',
			columns	:  [ 
				{ dataIndex: 'GUBUN'			, width: 80},
				{ dataIndex: 'WOODEN_CODE'		, width: 110},
				{ dataIndex: 'SN_NO'			, width: 110},
				{ dataIndex: 'ITEM_CODE'		, width: 110},
				{ dataIndex: 'ITEM_NAME'		, width: 130},
				{ dataIndex: 'EQU_GRADE'		, width: 100},
				{ dataIndex: 'EQU_GUBUN'		, width: 100}/*,
				{ dataIndex: 'INSTOCK_DATE'		, width: 100},
				{ dataIndex: 'TOT_PUNCH_Q'		, width: 110},
				{ dataIndex: 'MIN_PUNCH_Q'		, width: 110},
				{ dataIndex: 'MAX_PUNCH_Q'		, width: 110}*/
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
		});
		config.items = [me.form, me.grid];
		me.callParent(arguments);
	},  //constructor
	initComponent : function(){	
		var me  = this;
		me.grid.focus();
		this.callParent();
	},	
	fnInitBinding : function(param) {
		var frm= this.form;
		if(param) {
			if(param['DIV_CODE'] && param['DIV_CODE']!='')			frm.setValue('DIV_CODE'		, param['DIV_CODE']);
			if(param['SN_NO'] && param['SN_NO']!='')				frm.setValue('WOODEN_CODE'	, param['SN_NO']);
			if(param['WOODEN_CODE'] && param['WOODEN_CODE']!='')	frm.setValue('WOODEN_CODE'	, param['WOODEN_CODE']);
		}
		this._dataLoad();
		
	},
	onSubmitButtonDown : function()	{
		var me = this;
		var selectRecord = me.grid.getSelectedRecord();
	 	var rv ;
		if(selectRecord)	{
		 	rv = {
				status : "OK",
				data:[selectRecord.data]
			};
		}
		me.returnData(rv);
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	_dataLoad : function() {
		var me = this;
		var param= this.form.getValues();
		console.log( param );
		if(param) {
			me.isLoading = true;
			this.grid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
		}
	}
});