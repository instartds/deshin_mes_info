<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.financialinstitutionupdate1" default="금융기관코드매칭등록"/>',
		id:'hbs020ukrTab22',
		itemId: 'hbs020ukrPanel22',
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
			itemId:'uniGridPanel22',
		    store : hbs020ukrs22Store,
		    uniOpt: {
		    	expandLastColumn: false,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [
				{dataIndex: 'CUSTOM_CODE'		     ,		width: 120},
				{dataIndex: 'CUSTOM_NAME'		     ,		width: 166},
				{dataIndex: 'BANK_CODE'			     ,		minWidth: 166, flex: 1},
				{dataIndex: 'FLAG'				     ,		width: 66, hidden: true}
			], 
			listeners: {
				beforeedit: function(editor, e) {					
					if (e.field != 'BANK_CODE') {
						return false;
					}					
				}
			}						
		}]
	}