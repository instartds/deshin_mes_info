<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'근무시간등록',
		id: 'hbs020ukrTab7',
		border: false,
<!-- 		xtype: 'uniDetailForm', -->
		xtype: 'container',
<!-- 		api: {load:'hbs020ukrs7Service.select'}, -->
		layout: {type: 'border'},
		items:[{
			xtype: 'container',
			layout: 'border',
			region: 'center',
			items:[{				
				region: 'north',
				flex: 2,
				xtype: 'uniGridPanel',
				id: 'dutyTimeGrid01',
			    store : hbs020ukrs7Store,
			    uniOpt: {
			    	expandLastColumn: true,
			        useMultipleSorting: false,
			        copiedRow: true
				},
		    	features: [{
		    		id: 'masterGridSubTotal1',
		    		ftype: 'uniGroupingsummary', 
		    		showSummaryRow: false 
		    	},{
		    		id: 'masterGridTotal1', 	
		    		ftype: 'uniSummary', 	  
		    		showSummaryRow: false
		    	}],	
<!-- 				selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false  }),  -->
				columns: [{dataIndex: 'WORK_TEAM'					,		width: 120},				  	  
						  {dataIndex: 'HOLY_TYPE'					,		width: 120},
						  {text:'근무시간',
								columns:[
							 			{
							 				text:'시작시간', columns :[
							 					{dataIndex: 'DUTY_FR_D',		width: 40},				  	  
									  			{dataIndex: 'DUTY_FR_H',		width: 40},
									  			{dataIndex: 'DUTY_FR_M',		width: 40}
							 				]
							 			},{
							 				text:'종료시간', columns :[
							 					{dataIndex: 'DUTY_TO_D'	,		width: 40},				  	  
									  			{dataIndex: 'DUTY_TO_H'	,		width: 40},
									  			{dataIndex: 'DUTY_TO_M'	,		width: 40}
							 				]
							 			}
					  					]
						  },
						  {text:'휴식시간1',
								columns:[
						  				{
							 				text:'시작시간', columns :[
							 					{dataIndex: 'REST_FR_D_01',		width: 40},				  	  
									  			{dataIndex: 'REST_FR_H_01',		width: 40},
									  			{dataIndex: 'REST_FR_M_01',		width: 40}
							 				]
							 			},{
							 				text:'종료시간', columns :[
							 					{dataIndex: 'REST_TO_D_01'	,		width: 40},				  	  
									  			{dataIndex: 'REST_TO_H_01'	,		width: 40},
									  			{dataIndex: 'REST_TO_M_01'	,		width: 40}
							 				]
							 			}
						  		]
						  },
						  {text:'휴식시간2',
								columns:[
						  				{
							 				text:'시작시간', columns :[
							 					{dataIndex: 'REST_FR_D_02',		width: 40},				  	  
									  			{dataIndex: 'REST_FR_H_02',		width: 30},
									  			{dataIndex: 'REST_FR_M_02',		width: 30}
							 				]
							 			},{
							 				text:'종료시간', columns :[
							 					{dataIndex: 'REST_TO_D_02'	,		width: 40},				  	  
									  			{dataIndex: 'REST_TO_H_02'	,		width: 30},
									  			{dataIndex: 'REST_TO_M_02'	,		width: 30}
							 				]
							 			}
						  		]
						  },
						  {text:'휴식시간3',
								columns:[
						  				{
							 				text:'시작시간', columns :[
							 					{dataIndex: 'REST_FR_D_03',		width: 40},				  	  
									  			{dataIndex: 'REST_FR_H_03',		width: 30},
									  			{dataIndex: 'REST_FR_M_03',		width: 30}
							 				]
							 			},{
							 				text:'종료시간', columns :[
							 					{dataIndex: 'REST_TO_D_03'	,		width: 40},				  	  
									  			{dataIndex: 'REST_TO_H_03'	,		width: 30},
									  			{dataIndex: 'REST_TO_M_03'	,		width: 30}
							 				]
							 			}
						  		]
						  },
						  {text:'휴식시간4',
								columns:[
						  				{
							 				text:'시작시간', columns :[
							 					{dataIndex: 'REST_FR_D_04',		width: 40},				  	  
									  			{dataIndex: 'REST_FR_H_04',		width: 30},
									  			{dataIndex: 'REST_FR_M_04',		width: 30}
							 				]
							 			},{
							 				text:'종료시간', columns :[
							 					{dataIndex: 'REST_TO_D_04'	,		width: 40},				  	  
									  			{dataIndex: 'REST_TO_H_04'	,		width: 30},
									  			{dataIndex: 'REST_TO_M_04'	,		width: 30}
							 				]
							 			}
						  		]
						  }
				],
                  listeners: {
                  	containerclick: function() {
                  		selectedGrid = 'dutyTimeGrid01';
                  	}, select: function() {
                  		selectedGrid = 'dutyTimeGrid01';
                  	}, cellclick: function() {
                  		selectedGrid = 'dutyTimeGrid01';
                  	}, beforeedit: function(editor, e) {
						if (!e.record.phantom) {
							if (e.field == 'HOLY_TYPE' || e.field == 'WORK_TEAM') {
								return false;
							}
						}
					}, edit: function(editor, e) { console.log(e);
						var fieldName = e.field;
						var num_check = /[0-9]/;
						if (fieldName != 'WORK_TEAM' && fieldName != 'HOLY_TYPE' && fieldName.indexOf('_D') == -1) {
							if (!num_check.test(e.value)) {
									Ext.Msg.alert('확인', '숫자형식이 잘못되었습니다.');
									e.record.set(fieldName, e.originalValue);
									return false;
							}
							if (fieldName.indexOf('_H') != -1) {
								if (parseInt(e.value) > 24 || parseInt(e.value) < 0) {
									Ext.Msg.alert('확인', '정확한 시를 입력하십시오.');
									e.record.set(fieldName, e.originalValue);
									return false;
								}
							} else {
								if (parseInt(e.value) > 60 || parseInt(e.value) < 0) {
									Ext.Msg.alert('확인', '정확한 분을 입력하십시오.');
									e.record.set(fieldName, e.originalValue);
									return false;
								}
							}
						}									
						if (e.originalValue != e.value && !Ext.isEmpty(e.value)) {
							UniAppManager.setToolbarButtons('save', true);
						} else {
//							UniAppManager.setToolbarButtons('save', false);
						}
					}
                  }
			}, {
				region: 'center',
				flex: 2,
				xtype: 'uniGridPanel',
				id: 'dutyTimeGrid02',
			    store : hbs020ukrs7_1Store,
			    uniOpt: {
			    	expandLastColumn: true,
			        useMultipleSorting: false,
			        copiedRow: true
				},
		    	features: [{
		    		id: 'masterGridSubTotal2',
		    		ftype: 'uniGroupingsummary', 
		    		showSummaryRow: false 
		    	},{
		    		id: 'masterGridTotal2', 	
		    		ftype: 'uniSummary', 	  
		    		showSummaryRow: false
		    	}],		      
				columns: [{dataIndex: 'WORK_TEAM'					,		width: 120},				  	  
						  {dataIndex: 'PAY_CODE'					,		width: 120},
						  {dataIndex: 'HOLY_TYPE'					,		width: 120},
						  {dataIndex: 'DUTY_CODE'					,		width: 120},
						  {text:'근무시간',
								columns:[
							 			{
							 				text:'시작시간', columns :[
							 					{dataIndex: 'DUTY_FR_D',		width: 40},				  	  
									  			{dataIndex: 'DUTY_FR_H',		width: 40},
									  			{dataIndex: 'DUTY_FR_M',		width: 40}
							 				]
							 			},{
							 				text:'종료시간', columns :[
							 					{dataIndex: 'DUTY_TO_D'	,		width: 40},				  	  
									  			{dataIndex: 'DUTY_TO_H'	,		width: 40},
									  			{dataIndex: 'DUTY_TO_M'	,		width: 40}
							 				]
							 			}
					  					]
						  },
						  {text:'휴식시간1',
								columns:[
						  				{
							 				text:'시작시간', columns :[
							 					{dataIndex: 'REST_FR_D_01',		width: 40},				  	  
									  			{dataIndex: 'REST_FR_H_01',		width: 30},
									  			{dataIndex: 'REST_FR_M_01',		width: 30}
							 				]
							 			},{
							 				text:'종료시간', columns :[
							 					{dataIndex: 'REST_TO_D_01'	,		width: 40},				  	  
									  			{dataIndex: 'REST_TO_H_01'	,		width: 30},
									  			{dataIndex: 'REST_TO_M_01'	,		width: 30}
							 				]
							 			}
						  		]
						  },
						  {text:'휴식시간2',
								columns:[
						  				{
							 				text:'시작시간', columns :[
							 					{dataIndex: 'REST_FR_D_02',		width: 40},				  	  
									  			{dataIndex: 'REST_FR_H_02',		width: 30},
									  			{dataIndex: 'REST_FR_M_02',		width: 30}
							 				]
							 			},{
							 				text:'종료시간', columns :[
							 					{dataIndex: 'REST_TO_D_02'	,		width: 40},				  	  
									  			{dataIndex: 'REST_TO_H_02'	,		width: 30},
									  			{dataIndex: 'REST_TO_M_02'	,		width: 30}
							 				]
							 			}
						  		]
						  },
						  {text:'휴식시간3',
								columns:[
						  				{
							 				text:'시작시간', columns :[
							 					{dataIndex: 'REST_FR_D_03',		width: 40},				  	  
									  			{dataIndex: 'REST_FR_H_03',		width: 30},
									  			{dataIndex: 'REST_FR_M_03',		width: 30}
							 				]
							 			},{
							 				text:'종료시간', columns :[
							 					{dataIndex: 'REST_TO_D_03'	,		width: 40},				  	  
									  			{dataIndex: 'REST_TO_H_03'	,		width: 30},
									  			{dataIndex: 'REST_TO_M_03'	,		width: 30}
							 				]
							 			}
						  		]
						  }
				],
                  listeners: {
                  	containerclick: function () {
                  		selectedGrid = 'dutyTimeGrid02';
                  	}, select: function () {
                  		selectedGrid = 'dutyTimeGrid02';
                  	}, cellclick: function() {
                  		selectedGrid = 'dutyTimeGrid02';
                  	}, beforeedit: function(editor, e) {
						if (!e.record.phantom) {
							if (e.field == 'HOLY_TYPE' || e.field == 'WORK_TEAM' || e.field == 'PAY_CODE') {
								return false;
							}
						}
					}, edit: function(editor, e) {
						var fieldName = e.field;
						var num_check = /[0-9]/;
						if (fieldName != 'WORK_TEAM' && fieldName != 'HOLY_TYPE' && fieldName.indexOf('_D') == -1) {
							if (!num_check.test(e.value)) {
									Ext.Msg.alert('확인', '숫자형식이 잘못되었습니다.');
									e.record.set(fieldName, e.originalValue);
									return false;
							}
							if (fieldName.indexOf('_H') != -1) {
								if (parseInt(e.value) > 24 || parseInt(e.value) < 0) {
									Ext.Msg.alert('확인', '정확한 시를 입력하십시오.');
									e.record.set(fieldName, e.originalValue);
									return false;
								}
							} else {
								if (parseInt(e.value) > 60 || parseInt(e.value) < 0) {
									Ext.Msg.alert('확인', '정확한 분을 입력하십시오.');
									e.record.set(fieldName, e.originalValue);
									return false;
								}
							}
						}
						if (e.originalValue != e.value && !Ext.isEmpty(e.value)) {
							UniAppManager.setToolbarButtons('save', true);
						} else {
//							UniAppManager.setToolbarButtons('save', false);
						}
					}
                  }
			}]
		}]
	}