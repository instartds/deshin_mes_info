<%@page language="java" contentType="text/html; charset=utf-8"%>
	{
		title	: '<t:message code="system.label.sales.deliverycharge" default="배송담당"/>',
		xtype	: 'uniDetailForm',
		api		: {load: 'aba050ukrService.select'},
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			xtype: 'uniGridPanel',
			store : sbs010ukrvs6Store,
			uniOpt: {
				expandLastColumn: true,
				useRowNumberer: true,
				useMultipleSorting: false
			},
			columns: [
				{dataIndex: 'MAIN_CODE'			, wdth: 100, hidden: true},
				{dataIndex: 'SUB_CODE'			, wdth: 100},
				{dataIndex: 'CODE_NAME'			, wdth: 266},
				{dataIndex: 'CODE_NAME_EN'		, wdth: 366, hidden: true},
				{dataIndex: 'CODE_NAME_CN'		, wdth: 366, hidden: true},
				{dataIndex: 'CODE_NAME_JP'		, wdth: 366, hidden: true},
				{dataIndex: 'REF_CODE1'			, wdth: 100},
				{dataIndex: 'REF_CODE2'			, wdth: 100, hidden: true},
				{dataIndex: 'REF_CODE3'			, wdth: 100, hidden: true},
				{dataIndex: 'REF_CODE4'			, wdth: 100, hidden: true},
				{dataIndex: 'REF_CODE5'			, wdth: 100, hidden: true},
				{dataIndex: 'SUB_LENGTH'		, wdth: 66, hidden: true},
				{dataIndex: 'USE_YN'			, wdth: 100},
				{dataIndex: 'SORT_SEQ'			, wdth: 66, hidden: true},
				{dataIndex: 'SYSTEM_CODE_YN'	, wdth: 66},
				{dataIndex: 'UPDATE_DB_USER'	, wdth: 66, hidden: true},
				{dataIndex: 'UPDATE_DB_TIME'	, wdth: 66, hidden: true}
			]
		}]
	}