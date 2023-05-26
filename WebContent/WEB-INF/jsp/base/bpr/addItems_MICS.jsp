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
				title	: '추가항목(멕아이씨에스)',
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: { type: 'uniTable', columns: 3},
//				height	: 402,
				items	: [{		fieldLabel	: '등급' ,
									name		: 'ITEM_GRADE' ,
									xtype		: 'uniCombobox'	,
									comboType	: 'AU',
									comboCode	: 'B147',
									listeners	: {
										change: function(field, newValue, oldValue, eOpts) {
										}
									}
								},{
									fieldLabel: 'UDI코드',
									xtype: 'uniTextfield',
									name: 'UDI_CODE',
									holdable: 'hold',
									colspan : 2,
									width : 505,
									listeners: {
										change: function(field, newValue, oldValue, eOpts) {
											//panelResult.setValue('WKORD_NUM', newValue);
										}
									}
								},
									Unilite.popup('MODEL_MICS',{
									fieldLabel: '모델',
//									holdable: 'hold',
//									validateBlank: false,
									autoPopup:true,
									valueFieldName: 'MODEL_CODE',
									textFieldName: 'MODEL_NAME',
									DBvalueFieldName: 'MODEL_CODE',
									DBtextFieldName: 'MODEL_NAME',
									listeners: {
										onSelected: {
											fn: function(records, type) {
												 detailForm.setValue('ITEM_MODEL', records[0]["MODEL_CODE"]);
											 }
										},
										onClear: function(type)	{
											detailForm.setValue('ITEM_MODEL', '');
										}
									}
								})

					]
			}]
	},

