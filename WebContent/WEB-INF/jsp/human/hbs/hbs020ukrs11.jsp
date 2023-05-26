<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.abaloneinqupdate" default="급호봉등록"/>',
		border: false,
		id: 'hbs020ukrTab11',
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailFormSimple',
			layout: {type: 'uniTable'},
			items:[{
				fieldLabel: '<t:message code="system.label.human.paygrade" default="급호"/>',
				xtype: 'uniTextfield',
				id: 'PAY_GRADE_01',
				itemId: 'tabFocus11'
			},{
				fieldLabel: '<t:message code="system.label.human.paygrade1" default="호봉"/>',
				xtype: 'uniTextfield',
				id: 'PAY_GRADE_02'
			}
			,

			{
                fieldLabel: '<t:message code="system.label.human.baseyear" default="기준년도"/>',
//                xtype: 'uniTextfield',
                xtype: 'uniYearField',
                id: 'PAY_GRADE_YYYY',
                value: new Date().getFullYear()

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
			features	: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
							{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
			tbar		: [{
				text	: '<t:message code="system.label.human.excelfile" default="엑셀파일"/> UpLoad',
				handler	: function() {
					var payGradeYyyy = Ext.getCmp('PAY_GRADE_YYYY');
					openExcelWindow(payGradeYyyy.lastValue);
				}
			}],
			columns: columnsTab11,
			listeners: {
				beforeedit: function(editor, e) {
					if (!e.record.phantom) {
//						if (UniUtils.indexOf(e.field, ['PAY_GRADE_01','PAY_GRADE_02'])){
						if (UniUtils.indexOf(e.field, ['PAY_GRADE_01','PAY_GRADE_02','PAY_GRADE_YYYY'])){
							return false;
						}

					}
				},
				edit: function(editor, e) {
						var fieldName = e.field;
//						if((fieldName == 'PAY_GRADE_01' || fieldName == 'PAY_GRADE_02') && isNaN(e.value)){
						if((fieldName == 'PAY_GRADE_02') && isNaN(e.value)){
							Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message033" default="숫자형식이 잘못되었습니다."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
					}
			}
		}]
	}