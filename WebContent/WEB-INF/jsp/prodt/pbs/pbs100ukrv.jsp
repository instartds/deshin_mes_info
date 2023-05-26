<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'카렌더정보생성',
		

		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			border: false,
			xtype: 'fieldset',
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
			xtype: 'fieldset',
			title: '공휴일선택사항',
			layout: {type: 'uniTable', columns: 2},
			items:[{
				border: false,
				layout: {type: 'uniTable', columns: 2},
				items: [{
					name: '',
					html: "1. 요일선택",
					width: 350,
					border: false,
					rowspan:3
				}, {
		    		xtype: 'uniCheckboxgroup',		            		
		    		fieldLabel: '',
		    		id: 'check1',
		    		items: [{
		    			boxLabel: '일',
		    			width: 50,
		    			name: 'check1',
		    			inputValue: 'sun'
		    		},{
		    			boxLabel: '월',
		    			width: 50,
		    			name: 'check1',
		    			inputValue: 'mon'
		    		},{
		    			boxLabel: '화',
		    			width: 50,
		    			name: 'check1',
		    			inputValue: 'tue'
		    		},{
		    			boxLabel: '수',
		    			width: 50,
		    			name: 'check1',
		    			inputValue: 'whd'
		    		},{
		    			boxLabel: '목',
		    			width: 50,
		    			name: 'check1',
		    			inputValue: 'thu'
		    		},{
		    			boxLabel: '금',
		    			width: 50,
		    			name: 'check1',
		    			inputValue: 'fri'
		    		},{
		    			boxLabel: '토',
		    			width: 50,
		    			name: 'check1',
		    			inputValue: 'sat'
		    		}]
	       		}]
	        }]			
		}, {
			
			xtype:'container',
			name: '',
			html: "&emsp;2. 지정공휴일"
				
		}, {	
			xtype: 'uniGridPanel',
			
		    store : pbs070ukrvs1Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [	
				{dataIndex: 'HOLY_MONTH'		,	width: 66}, 
			 	{dataIndex: 'HOLY_DAY'			,	width: 66}, 
			  	{dataIndex: 'REMARK'			,	width: 333}
			]
		}]	
	
	}