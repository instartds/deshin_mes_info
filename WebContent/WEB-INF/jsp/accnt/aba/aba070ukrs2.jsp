<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'통장코드',
		border: false,
		
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[
			Unilite.popup('ITEM',{
			fieldLabel: '통장코드', 
//			textFieldWidth: 170, 
			validateBlank: false						
		}), {				
			xtype: 'uniGridPanel',
			
		    store : aba070ukrs2Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [{dataIndex: 'SAVE_CODE'		  	,		width: 66 },
					  {dataIndex: 'SAVE_NAME'		  	,		width: 133},
					  {dataIndex: 'BANK_CODE'		  	,		width: 66},
					  {dataIndex: 'BANK_NAME'		  	,		width: 120},
					  {dataIndex: 'BANK_ACCOUNT'	  	,		width: 133},
					  {dataIndex: 'ACCNT'			  	,		width: 66},
					  {dataIndex: 'ACCNT_NM'		  	,		width: 120},
					  {dataIndex: 'BANK_KIND'		  	,		width: 66},
					  {dataIndex: 'DIV_CODE'		  	,		width: 73},
					  {dataIndex: 'UPDATE_DB_USER'  	,		width: 66, hidden: true},
					  {dataIndex: 'UPDATE_DB_TIME'  	,		width: 66, hidden: true},
					  {dataIndex: 'USE_YN'		  		,		width: 66},
					  {dataIndex: 'EXP_AMT_I'		  	,		width: 130},
					  {dataIndex: 'MAIN_SAVE_YN'	  	,		width: 120},
					  {dataIndex: 'IF_YN'			  	,		width: 66, hidden: true}					  
			]						
		}]
	}