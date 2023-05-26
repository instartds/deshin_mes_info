<%@page language="java" contentType="text/html; charset=utf-8"%>
<% String aaa = request.getParameter("aaa");%>
	{
		layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
		defaultType	: 'uniFieldset',
		masterGrid	: masterGrid,
		defaults	: { padding: '10 15 15 10'},
		colspan		: 3,
		id			: 'addItemsFieldset',
		hidden		: true,
		items		: [{/*
			title	: '추가항목',
			defaults: {type: 'uniTextfield'	, labelWidth:100},
			layout	: {type: 'uniTable'		, columns: 3},
			items	: [{
				fieldLabel	: '제조사',
				xtype		: 'uniTextfield',
				name		: 'MAKER_NAME'
			},{
				fieldLabel	: '원산지',
				xtype		: 'uniTextfield',
				name		: 'MAKE_NATION',
				labelWidth	: 138
			},{
				fieldLabel	: '함량',
				xtype		: 'uniNumberfield',
				name		: 'CONTENT_QTY',
				labelWidth	: 138
			},{
				fieldLabel	: '맛',
				xtype		: 'uniTextfield',
				name		: 'ITEM_FLAVOR'
			},{
				fieldLabel	: '판매국',
				xtype		: 'uniTextfield',
				name		: 'SALE_NATION',
				labelWidth	: 138
			}]
		*/}]
	},

