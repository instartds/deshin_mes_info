<%@page language="java" contentType="text/html; charset=utf-8"%>
	{
		title	: '<t:message code="system.label.sales.collectiontype" default="수금유형"/>',
		xtype	: 'uniDetailForm',
		api		: {load: 'aba050ukrService.select'},
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			xtype	: 'uniGridPanel',
			store	: sbs010ukrvs8Store,
			uniOpt	: {
				expandLastColumn	: true,
				useRowNumberer		: true,
				useMultipleSorting	: false
			},
			columns: [
				{dataIndex: 'MAIN_CODE'			, width: 100, hidden: true},
				{dataIndex: 'SUB_CODE'			, width: 100},
				{dataIndex: 'CODE_NAME'			, width: 150},
				{dataIndex: 'CODE_NAME_EN'		, width: 150, hidden: true},
				{dataIndex: 'CODE_NAME_CN'		, width: 150, hidden: true},
				{dataIndex: 'CODE_NAME_JP'		, width: 150, hidden: true},
				{dataIndex: 'REF_CODE1'			, width: 86},
				{dataIndex: 'REF_CODE2'			, width: 86, hidden: true},
				{dataIndex: 'REF_CODE3'			, width: 86, hidden: true},
				{dataIndex: 'REF_CODE4'			, width: 86, hidden: true},
				{dataIndex: 'REF_CODE5'			, width: 86, hidden: true},
				{dataIndex: 'SUB_LENGTH'		, width: 66, hidden: true},
				{dataIndex: 'USE_YN'			, width: 120},
				{dataIndex: 'SORT_SEQ'			, width: 66, hidden: true},
				{dataIndex: 'SYSTEM_CODE_YN'	, width: 66},
				{dataIndex: 'UPDATE_DB_USER'	, width: 66, hidden: true},
				{dataIndex: 'UPDATE_DB_TIME'	, width: 66, hidden: true}
			]
		}]
	}