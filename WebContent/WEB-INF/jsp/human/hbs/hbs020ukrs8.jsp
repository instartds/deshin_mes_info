<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.comyearwagesupload" default="년월차기준등록"/>',
		id : 'hbs020ukrTab8',
		itemId: 'hbs020ukrPanel8',
		border: false,
		subCode:'',
		getSubCode: function()	{
			return this.subCode;
		},
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{				
			xtype: 'uniGridPanel',
			itemId:'uniGridPanel8',
		    store : hbs020ukrs8Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false,
		        copiedRow: true
			},		        
			columns: [
				{dataIndex: 'PAY_CODE'       		,		width: 100},
				//{dataIndex: 'PAY_DD'				,		width: 66, hidden: true},
				{dataIndex: 'ABSENCE_CNT'           ,       width: 200},
				{dataIndex: 'MAX_YEAR_BONUS'        ,       width: 200},
				{dataIndex: 'CALCU_BAS'             ,       width: 790}
				//{dataIndex: 'AMASS_NUM'				,		width: 120, hidden: true},
				//{dataIndex: 'SAVE_MONTH_NUM'		,		width: 138, hidden: true},
				//{dataIndex: 'SUPP_YEAR_NUM_B'		,		width: 133, hidden: true},
				//{dataIndex: 'SUPP_YEAR_NUM_A'		,		width: 133, hidden: true},
				//{dataIndex: 'WAGES_TYPE'			,		width: 66, hidden: true},
				//{dataIndex: 'FIVE_DAY_CHECK'		,		width: 120, xtype : 'checkcolumn', hidden: true},
				//{dataIndex: 'JOIN_MID_CHECK'		,		width: 120, xtype : 'checkcolumn', hidden: true}
			]						
		}]
	}