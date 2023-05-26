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
		items: [{
				title	: '추가항목(코디)',
				defaults: {type: 'uniTextfield', labelWidth:105},
				layout	: { type: 'uniTable', columns: 4},
				items	: [{
									fieldLabel	: '실충전량',
									name		: 'UNIT_WGT',
									width		: 175,
									xtype		: 'uniNumberfield',
									decimalPrecision:2
									},{
									fieldLabel	: '',
									name		: 'WGT_UNIT',
									width		: 100,
									xtype		: 'uniCombobox',
									comboType   : 'AU',
									comboCode   : 'B013',
									displayField: 'value'
								},{
									fieldLabel	: '표지용량',
									name		: 'UNIT_VOL',
									width		: 175,
									xtype		: 'uniNumberfield',
									decimalPrecision:2
									},{
									fieldLabel	: '',
									name		: 'VOL_UNIT',
									width		: 100,
									xtype		: 'uniCombobox',
									comboType   : 'AU',
									comboCode   : 'B013',
									displayField: 'value'
								},{	fieldLabel	: '비고(제조지시)',
									name		: 'REMARK_AREA',
									xtype		: 'textarea',
									colspan		: 5,
									height		: 80,
									width		: 550,
									allowBlank	: true

								}

							]
				}]
	},

