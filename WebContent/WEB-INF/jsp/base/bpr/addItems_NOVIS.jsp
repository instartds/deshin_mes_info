<%@page language="java" contentType="text/html; charset=utf-8"%>
    <%
        String aaa = request.getParameter("aaa");
 
    %>
{
		layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
		defaultType: 'uniFieldset',
		masterGrid: masterGrid,
		defaults: { padding: '10 15 15 10'},
		colspan: 3,
		id: 'addItemsFieldset',
//			hidden:true,
		items: [{
			title: '추가항목 (노비스바이오)',
			defaults: {type: 'uniTextfield', labelWidth:100},
			layout: { type: 'uniTable', columns: 3},
			items: [{
				xtype:'uniTextfield',
				fieldLabel:'제조사',
				name:'MAKER_NAME'

			},{
				xtype:'uniTextfield',
				fieldLabel:'원산지',
				name:'MAKE_NATION',
				labelWidth:138

			},{
				xtype:'uniNumberfield',
				fieldLabel:'함량',
				name:'CONTENT_QTY',
				labelWidth:138

			},{
				xtype:'uniTextfield',
				fieldLabel:'맛',
				name:'ITEM_FLAVOR'

			},{
				xtype:'uniTextfield',
				fieldLabel:'판매국',
				name:'SALE_NATION',
				labelWidth:138

			}]
		}]
	},

