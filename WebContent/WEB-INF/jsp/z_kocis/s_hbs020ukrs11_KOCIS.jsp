<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'급호봉등록',
		border: false,
		id: 'hbs020ukrTab11',
<!-- 		xtype: 'uniDetailForm', -->
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailFormSimple',
			layout: {type: 'uniTable'},
			items:[{
				fieldLabel: '급호',
				xtype: 'uniTextfield',
				id: 'PAY_GRADE_01',
				itemId: 'tabFocus11'
			},{
				fieldLabel: '호봉',
				xtype: 'uniTextfield',
				id: 'PAY_GRADE_02'
			}]			
		}, {				
			xtype: 'uniGridPanel',	
			id:'payGradeGrid',
		    store : hbs020ukrs11Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false,
	            state: {
	    			useState: false,
	    			useStateList: false
	    		}
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
			columns: columnsTab11,			
			listeners: {
				beforeedit: function(editor, e) {
					if (!e.record.phantom) {
						if (UniUtils.indexOf(e.field, ['PAY_GRADE_01','PAY_GRADE_02'])){
							return false;
						}
						
					}
				}, 
				edit: function(editor, e) {
						var fieldName = e.field;
						if((fieldName == 'PAY_GRADE_01' || fieldName == 'PAY_GRADE_02') && isNaN(e.value)){
							Ext.Msg.alert('확인', '숫자형식이 잘못되었습니다.');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
					}
			}
		}]
	}