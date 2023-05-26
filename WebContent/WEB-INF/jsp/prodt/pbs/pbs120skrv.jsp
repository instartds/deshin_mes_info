<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'카렌더정보조회',
		border: false,
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 2},
			items:[{ 
				border: true,
		 		fieldLabel: '카렌더 타입',
		 		name:'', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B062',
		 		allowBlank:false
	 		}, { 
				border: true,
		 		fieldLabel: '생성년도',
		 		name:'', 
		 		xtype: 'uniDatefield',
		 		allowBlank:false
	 		}]			
		}, {				
			xtype: 'uniGridPanel',
			
		    store : pbs070ukrvs2Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [{dataIndex: 'CAL_NO'    			, width:133},				  
					  {dataIndex: 'START_DATE'			, width:233},			  
					  {dataIndex: 'END_DATE'  			, width:233},			  
					  {dataIndex: 'WORK_DAY'  			, width:66}
			]						
		}]
	}