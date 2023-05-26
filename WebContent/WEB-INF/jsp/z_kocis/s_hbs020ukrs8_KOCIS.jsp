<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'년월차기준등록',
		id : 'hbs020ukrTab8',
		itemId: 'hbs020ukrPanel8',
		border: false,
		subCode:'',
		getSubCode: function()	{
			return this.subCode;
		},
<!-- 		xtype: 'uniDetailForm', -->
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
				{dataIndex: 'PAY_DD'				,		width: 66, hidden: true},
				{text:'월차',
					columns:[
						{dataIndex: 'AMASS_NUM'				,		width: 120},
						{dataIndex: 'SAVE_MONTH_NUM'		,		width: 138}
					]
				},{text:'년차',
					columns:[
						{dataIndex: 'ABSENCE_CNT'			,		width: 133},
						{dataIndex: 'SUPP_YEAR_NUM_B'		,		width: 133},
						{dataIndex: 'SUPP_YEAR_NUM_A'		,		width: 133},
						{dataIndex: 'WAGES_TYPE'			,		width: 66, hidden: true},
						{dataIndex: 'FIVE_DAY_CHECK'		,		width: 120, xtype : 'checkcolumn'},
						{dataIndex: 'JOIN_MID_CHECK'		,		width: 120, xtype : 'checkcolumn'}
					]
				}
			]						
		}]
	}