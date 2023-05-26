<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'고정자산기본정보등록',
		border: false,
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[
			Unilite.popup('ITEM',{
			fieldLabel: '계정코드', 
//			textFieldWidth: 170, 
			validateBlank: false						
		}),{				
			xtype: 'uniGridPanel',
			
		    store : aba070ukrs3Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [{dataIndex: 'ACCNT'			,		width: 133 },
					  {dataIndex: 'ACCNT_NAME' 	  	,		width: 266 },
					  {dataIndex: 'DEP_CTL'  		,		width: 166 },
					  {dataIndex: 'GAAP_DRB_YEAR'  	,		width: 100 },
					  {dataIndex: 'IFRS_DRB_YEAR'  	,		width: 100, hidden: true },
					  {dataIndex: 'JAN_RATE'		,		width: 66, hidden: true  },
					  {dataIndex: 'PREFIX'         	,		width: 86, hidden: true  },
					  {dataIndex: 'SEQ_NUM'        	,		width: 86, hidden: true  }
			]						
		}]
	}