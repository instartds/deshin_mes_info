<%@page language="java" contentType="text/html; charset=utf-8"%>
	{
		title	: '<t:message code="system.label.sales.deliverycarno" default="배송차량번호"/>',
		xtype	: 'uniDetailForm',
		api		: {load: 'aba050ukrService.select'},
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			xtype	: 'uniGridPanel',
			store	: sbs010ukrvs7Store,
			uniOpt	: {
				expandLastColumn	: true,
				useRowNumberer		: true,
				useMultipleSorting	: false
			},
			columns: [
				{dataIndex: 'COMP_CODE'			, width: 66, hidden: true  },
				{dataIndex: 'MAIN_CODE'			, width: 66, hidden: true  },
				{dataIndex: 'SUB_CODE'			, width: 100 },
				{dataIndex: 'CODE_NAME'			, width: 120 },
				{dataIndex: 'CODE_NAME_EN'		, width: 233, hidden: true },
				{dataIndex: 'CODE_NAME_CN'		, width: 233, hidden: true },
				{dataIndex: 'CODE_NAME_JP'		, width: 233, hidden: true },
				{dataIndex: 'REF_CODE1'			, width: 120 },
				{dataIndex: 'REF_CODE2'			, width: 100 },
				{dataIndex: 'CUSTOM_NAME'		, width: 120 },
				{dataIndex: 'REF_CODE3'			, width: 100 },
				{dataIndex: 'REF_CODE4'			, width: 100, hidden: true },
				{dataIndex: 'REF_CODE5'			, width: 100, hidden: true },
				{dataIndex: 'REF_CODE6'			, width: 100, hidden: true },
				{dataIndex: 'REF_CODE7'			, width: 100, hidden: true },
				{dataIndex: 'REF_CODE8'			, width: 100, hidden: true },
				{dataIndex: 'REF_CODE9'			, width: 100, hidden: true },
				{dataIndex: 'REF_CODE10'		, width: 100, hidden: true },
				{dataIndex: 'SUB_LENGTH'		, width: 66, hidden: true  },
				{dataIndex: 'USE_YN'			, width: 100 },
				{dataIndex: 'SORT_SEQ'			, width: 66, hidden: true  },
				{dataIndex: 'SYSTEM_CODE_YN'	, width: 66, hidden: true  },
				{dataIndex: 'INSERT_DB_USER'	, width: 66, hidden: true  },
				{dataIndex: 'INSERT_DB_TIME'	, width: 66, hidden: true  },
				{dataIndex: 'UPDATE_DB_USER'	, width: 66, hidden: true  },
				{dataIndex: 'UPDATE_DB_TIME'	, width: 66, hidden: true  }
			]
		}]
	}