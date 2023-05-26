<%@page language="java" contentType="text/html; charset=utf-8"%>
	{
		title	: '<t:message code="system.label.trade.hsinfoentry" default="HS 정보 등록"/>',
		xtype	: 'uniDetailFormSimple',
		itemId	: 'tbs030ukrvs2Tab',
		id		: 'tbs030ukrvs2Tab',
		layout	: {type: 'vbox', align:'stretch'},
		padding	: '0 0 0 0',
		items	: [{
			xtype	: 'container',
//			region	: 'north',
			layout	: {type: 'uniTable', columns: 2},
			items	: [{
					fieldLabel	: 'H.S 번호',
					name		: 'HS_NO',   
					xtype		: 'uniTextfield',
					holdable	: 'hold'
				},{
					fieldLabel	: 'H.S 명',
					name		: 'HS_NAME',
					xtype		: 'uniTextfield',
					holdable	: 'hold'
				}
			]
		},{
			xtype		: 'uniGridPanel',
			region		: 'west',
			itemId		: 'tbs030ukrvs2Grid',
			id			: 'tbs030ukrvs2Grid',
			store		: tbs030ukrvs2Store,
			padding		: '0 0 0 0',
			dockedItems	: [{
				xtype	: 'toolbar',
				dock	: 'top',
				padding	: '0px',
				border	: 0
			}],
			uniOpt: {
				expandLastColumn	: false,
				useRowNumberer		: true,
				onLoadSelectFirst	: true,
				useMultipleSorting	: false
			},
			columns: [
				{dataIndex: 'HS_NO'			, width: 126},
				{dataIndex: 'HS_NAME'		, width: 346},
				{dataIndex: 'HS_SPEC'		, width: 166},
				{dataIndex: 'HS_UNIT'		, width: 80, align: 'center'}
			],
			listeners: {
				selectionchange:function(selected, eOpts ) {
					var record = Ext.getCmp('tbs030ukrvs2Tab').down('#tbs030ukrvs2Grid').getSelectedRecord();
				}
			}
			
		}]
	}