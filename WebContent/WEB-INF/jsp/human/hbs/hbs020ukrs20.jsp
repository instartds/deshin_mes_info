<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.bussofficeupload" default="주민세신고지점등록"/>',
		id:'hbs020ukrTab20',
		itemId: 'hbs020ukrPanel20',
		border: false,
		subCode:'',
		getSubCode: function()	{
			return this.subCode;
		},
<!-- 		xtype: 'uniDetailForm', -->
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
<!-- 			xtype: 'container', -->
			xtype: 'uniDetailFormSimple',
			layout: {type: 'uniTable'},
			items:[{
				fieldLabel: '<t:message code="system.label.human.sectcode" default="신고사업장"/>',
				name: 'DIV_CODE', 
				id: 'SECT_CODE20',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode: 'BILL',
				itemId: 'tabFocus20'
			}]			
		}, {				
			xtype: 'uniGridPanel',
			itemId:'uniGridPanel20',
		    store : hbs020ukrs20Store,
		    uniOpt: {
		    	expandLastColumn: false,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [{dataIndex: 'BUSS_OFFICE_CODE'	          	,		width: 100},				  
					  {dataIndex: 'BUSS_OFFICE_NAME'	          	,		width: 133},				  
					  {dataIndex: 'LOCAL_TAX_GOV'		          	,		width: 133},				  
					  {dataIndex: 'BUSS_OFFICE_ADDR'	          	,		width: 400},				  
					  {dataIndex: 'SECT_CODE'			          	,		minWidth: 133, flex: 1}
			],
			listeners: {
				beforeedit  : function( editor, e, eOpts ) {					
					if(!e.record.phantom){						
						if (UniUtils.indexOf(e.field, ['BUSS_OFFICE_CODE'])){
							return false;
						}else{
							return true;
						}	
					}					
				}
			}
		}]
	}