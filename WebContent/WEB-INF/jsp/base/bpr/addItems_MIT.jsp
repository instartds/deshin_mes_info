<%@page language="java" contentType="text/html; charset=utf-8"%>
    <%
        String aaa = request.getParameter("aaa");

    %>

{
		layout: {type: 'uniTable', columns: 3, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
		defaultType: 'uniFieldset',
		masterGrid: masterGrid,
		defaults: { padding: '10 15 15 10'},
		colspan: 3,
		id: 'addItemsFieldset',
//			hidden:true,
		items: [{
				title	: '추가항목(엠아이텍)',
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: { type: 'uniTable', columns: 3},
//				height	: 402,
				items	: [{		fieldLabel	: '삽입기구타입' ,
									name		: 'INSERT_APPR_TYPE' ,
									xtype		: 'uniCombobox'	,
									comboType	: 'AU',
									comboCode	: 'Z013',
									listeners	: {
										change: function(field, newValue, oldValue, eOpts) {
										}
									}
								},{
									fieldLabel: '형상',
									xtype: 'uniTextfield',
									name: 'FORM_TYPE',
									holdable: 'hold',
									listeners: {
										change: function(field, newValue, oldValue, eOpts) {
											//panelResult.setValue('WKORD_NUM', newValue);
										}
									}
								},{
									fieldLabel: '코팅유무',
									xtype: 'uniTextfield',
									name: 'COATING',
									holdable: 'hold',
									listeners: {
										change: function(field, newValue, oldValue, eOpts) {
											//panelResult.setValue('WKORD_NUM', newValue);
										}
									}
								},{
									fieldLabel: '골드Wire위치',
									xtype: 'uniTextfield',
									name: 'GOLD_WIRE',
									holdable: 'hold',
									listeners: {
										change: function(field, newValue, oldValue, eOpts) {
											//panelResult.setValue('WKORD_NUM', newValue);
										}
									}
								},{
									fieldLabel: '위험등급',
									xtype		: 'uniCombobox'	,
									comboType	: 'AU',
									comboCode	: 'Z014',
									name: 'RISK_GRADE',
									holdable: 'hold',
									listeners: {
										change: function(field, newValue, oldValue, eOpts) {
											//panelResult.setValue('WKORD_NUM', newValue);
										}
									}
								},{
									fieldLabel: 'UPN 코드',
									xtype: 'uniTextfield',
									name: 'UPN_CODE',
									holdable: 'hold',
									listeners: {
										change: function(field, newValue, oldValue, eOpts) {
											//panelResult.setValue('WKORD_NUM', newValue);
										}
									}
								},{
									fieldLabel: '삽입기구코드',
									xtype: 'uniTextfield',
									name: 'INSERT_APPR_CODE',
									holdable: 'hold',
									listeners: {
										change: function(field, newValue, oldValue, eOpts) {
											//panelResult.setValue('WKORD_NUM', newValue);
										}
									}
								},
									Unilite.popup('DIV_PUMOK',{
										fieldLabel: '베어코드',
										holdable: 'hold',
										validateBlank:false,
										textFieldName: 'BARE_NAME',
										valueFieldName: 'BARE_CODE',
										listeners: {
											onValueFieldChange: function(field, newValue){
												//panelResult.setValue('ITEM_CODE', newValue);
											},
											onTextFieldChange: function(field, newValue){
												//panelResult.setValue('ITEM_NAME', newValue);
											},
											applyextparam: function(popup){
												popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
											}
										}
								})

					]
			}]
	},

