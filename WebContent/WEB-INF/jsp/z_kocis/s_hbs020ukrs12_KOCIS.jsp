<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'연봉등록',
		border: false,
		id:'hbs020ukrTab12',
 		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[
			{
				xtype: 'uniDetailForm',
				disabled: false,
				layout: {type: 'uniTable', columns: 3},
				id:'hbs020ukrTab12_inner',
				items:[
				{
					xtype: 'container',
					layout: {type: 'uniTable', columns: 1},
					items:[
						{
							fieldLabel: '관리년도',
							xtype: 'uniYearField',
							value: new Date().getFullYear(),
							name: 'YEAR_YYYY',
							id: 'YEAR_YYYY',
							allowBlank: false
						},{
							fieldLabel: '급여지급차수',
							name: 'PAY_PROV_FLAG', 
							xtype: 'uniCombobox',
							comboType: 'AU',
							comboCode: 'H031'
						},{
							fieldLabel: '급여지급방식',
							name: 'PAY_CODE', 
							xtype: 'uniCombobox',
							comboType: 'AU',
							comboCode: 'H028'
						}]
				},{
					xtype: 'container',
					layout: {type: 'uniTable', columns: 1},
					items:[
							Unilite.popup('DEPT',{
							fieldLabel: '부서',
							valueFieldName:'DEPT_CODE_FROM',
					    	textFieldName:'DEPT_NAME_FROM',
							textFieldWidth: 170,
							validateBlank: false,
							popupWidth: 710
						}),
						Unilite.popup('DEPT',{
							fieldLabel: '~',
							textFieldWidth: 170,
							valueFieldName:'DEPT_CODE_TO',
					    	textFieldName:'DEPT_NAME_TO',
							validateBlank: false,
							popupWidth: 710
						}),
						Unilite.popup('Employee', {
							 
							textFieldWidth: 170, 
							validateBlank: false,
							name: 'PERSON_NUMB',
							extParam: {'CUSTOM_TYPE': '3'},
							allowBlank: false
					})]
				},{
	            	xtype: 'container',
	            	layout: {type: 'table', columns: 1},
	            	defaults: { xtype: 'button' },		            	
					items:[
					{
						text: '대상자일괄생성',
						width: 100,
						margin: '0 0 5 20',
						disabled: true,
						id: 'initButton',
						handler: function(btn) {
							if(confirm('대상부서를 일괄 생성합니다.\n 생성 하시겠습니까?')){
								var form = Ext.getCmp('hbs020ukrTab12').getForm();
								var param = form.getValues();
								hbs020ukrService.insertBatchList12(param, function(provider, response)	{
					        		UniAppManager.app.onQueryButtonDown();
								});
							}
						}
					},{
						xtype: 'button',
						text: '전체선택',
						width: 100,
						margin: '0 0 5 20',
						id: 'btnAllSelect',
//						tdAttrs: {align: 'left', width: 65},
						handler : function() {
							var checkCount = 0;
							var records = hbs020ukrs12Store.data.items;
							if(records.length < 1) return false;
							var bChecked = true;						
							if(Ext.getCmp('btnAllSelect').getText() == "취소"){
								bChecked = false;
								checkCount = 0;
							}
							Ext.each(records, function(record, i){
								record.set('CHOICE', bChecked);
								if(bChecked) checkCount++;
							});
							if(checkCount > 0){
								Ext.getCmp('btnAllSelect').setText('취소');
							}else{
								Ext.getCmp('btnAllSelect').setText('전체선택');
							}
						}
			        }]
	            }]
		},{				
			xtype: 'uniGridPanel',
			id: 'hbs020ukrs12Grid',
			itemId:'hbs020ukrs12Grid',
		    store : hbs020ukrs12Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: false,
		        useMultipleSorting: false
			},
	    	features: [{
	    		id: 'masterGridSubTotal',
	    		ftype: 'uniGroupingsummary', 
	    		showSummaryRow: false 
	    	},{
	    		id: 'masterGridTotal', 	
	    		ftype: 'uniSummary', 	  
	    		showSummaryRow: false
	    	}],
        tbar: [{
        	itemId : 'refBtn',
    		text:'엑셀 참조',
    		handler: function() {
    			openExcelWindow();
			}
   		 }],
			columns: [{dataIndex: 'CHOICE'          	,		width: 50, xtype : 'checkcolumn'},
					  {dataIndex: 'COMP_CODE'          	,		width: 100, hidden: true},
					  {dataIndex: 'YEAR_YYYY'          	,		width: 100, hidden: true},				  
					  {dataIndex: 'PERSON_NUMB'      	,		width: 120
					  		,editor: Unilite.popup('Employee_G', {
					  					autoPopup: true,
										textFieldName: 'NAME',
										listeners: {'onSelected': {
														fn: function(records, type) {
																console.log('records : ', records);
																var hbs020ukrs12Grid = Ext.getCmp('hbs020ukrs12Grid');
																var grdRecord = hbs020ukrs12Grid.getSelectionModel().getSelection()[0];
																grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
																grdRecord.set('NAME', records[0].NAME);
																grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
															},
														scope: this
														},
													'onClear': function(type) {
														var hbs020ukrs12Grid = Ext.getCmp('hbs020ukrs12Grid');
														var grdRecord = hbs020ukrs12Grid.getSelectionModel().getSelection()[0];
														grdRecord.set('DEPT_NAME', '');
														grdRecord.set('NAME', '');
														grdRecord.set('PERSON_NUMB', '');
													}
										}
									})
					  },				  
					  {dataIndex: 'NAME'	       		,		width: 120
					  		,editor: Unilite.popup('Employee_G', {	
					  					autoPopup: true,
										textFieldName: 'NAME',
										listeners: {'onSelected': {
														fn: function(records, type) {
																console.log('records : ', records);
																var hbs020ukrs12Grid = Ext.getCmp('hbs020ukrs12Grid');
																var grdRecord = hbs020ukrs12Grid.getSelectionModel().getSelection()[0];
																grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
																grdRecord.set('NAME', records[0].NAME);
																grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
															},
														scope: this
														},
													'onClear': function(type) {
														var hbs020ukrs12Grid = Ext.getCmp('hbs020ukrs12Grid');
														var grdRecord = hbs020ukrs12Grid.getSelectionModel().getSelection()[0];
														grdRecord.set('DEPT_NAME', '');
														grdRecord.set('NAME', '');
														grdRecord.set('PERSON_NUMB', '');
													}
										}
									})
					  },				  
					  {dataIndex: 'DEPT_NAME'		   	,		width: 180},				  
				  	  {dataIndex: 'ANNUAL_SALARY_I'	    ,		width: 120},				  
					  {dataIndex: 'WAGES_STD_I'	       	,		width: 120},				  
					  {dataIndex: 'INSERT_DB_USER'     	,		width: 100, hidden: true},				  
					  {dataIndex: 'INSERT_DB_TIME'     	,		width: 100, hidden: true}
			],
	        setExcelData: function(record) {
        		var me = this;
	   			var grdRecord = this.getSelectionModel().getSelection()[0];
				grdRecord.set('PERSON_NUMB'			, record['PERSON_NUMB']);
				grdRecord.set('NAME'				, record['NAME']);
	   			grdRecord.set('DEPT_NAME'			, record['DEPT_NAME']);
				grdRecord.set('ANNUAL_SALARY_I'		, record['ANNUAL_SALARY_I']);
	   			grdRecord.set('WAGES_STD_I'			, record['WAGES_STD_I']);
			},
        listeners: {
          	beforeedit: function(editor, e) {
          		if (e.field == 'DEPT_NAME') {
          			return false;
          		}
				if (!e.record.phantom) {
					//update					
					if (e.field == 'PERSON_NUMB' || e.field == 'NAME' || e.field == 'DEPT_NAME') return false;
				}
			}, edit: function(editor, e) {
				var fieldName = e.field;
				var num_check = /[0-9]/;
				if (fieldName == 'ANNUAL_SALARY_I' && fieldName == 'WAGES_STD_I') {
					if (!num_check.test(e.value)) {
							Ext.Msg.alert('확인', '숫자형식이 잘못되었습니다.');
							e.record.set(fieldName, e.originalValue);
							return false;
					}
				}
				if (e.originalValue != e.value) {
					UniAppManager.setToolbarButtons('save', true);
				} 
// 				else {
// 					UniAppManager.setToolbarButtons('save', false);
// 				}
			}
          }
		}]
	}