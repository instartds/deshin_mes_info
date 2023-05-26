<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.purchase.issuetype" default="출고유형"/>',
		
		border: false,
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{				
			xtype: 'uniGridPanel',
			
		    store : mba010ukrvs1Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [
				{dataIndex: 'COMP_CODE'				,		width:0, hidden:true  },
				{dataIndex: 'MAIN_CODE'				,		width:0, hidden:true  },
				{dataIndex: 'SUB_CODE'				,		width:80  },
				{dataIndex: 'CODE_NAME'				,		width:433  },
				{dataIndex: 'CODE_NAME_EN'			,		width:133, hidden:true  },
				{dataIndex: 'CODE_NAME_JP'			,		width:133, hidden:true  },
				{dataIndex: 'CODE_NAME_CN'			,		width:133, hidden:true  },
				{dataIndex: 'REF_CODE1'				,		width:233, hidden:true  },
				{dataIndex: 'USER_NAME'				,		width:133, hidden:true  },
				{dataIndex: 'REF_CODE2'				,		width:133, hidden:true  },
				{dataIndex: 'USER_NAME2'			,		width:86, hidden:true  },
				{dataIndex: 'DIV_CODE'				,		width:86  },
				{dataIndex: 'USE_YN'        		,		width:66  },
				{dataIndex: 'SYSTEM_CODE_YN'		,		width:86  },
				{dataIndex: 'REF_CODE3'				,		width:86, hidden:true  },
				{dataIndex: 'REF_CODE4'				,		width:86, hidden:true  },
				{dataIndex: 'REF_CODE5'				,		width:86, hidden:true  },
				{dataIndex: 'SUB_LENGTH'			,		width:66, hidden:true  },
				{dataIndex: 'SORT_SEQ'				,		width:66, hidden:true  },
				{dataIndex: 'UPDATE_DB_USER'		,		width:66, hidden:true  },
				{dataIndex: 'UPDATE_DB_TIME'		,		width:66, hidden:true  }
			]						
		}]
	}