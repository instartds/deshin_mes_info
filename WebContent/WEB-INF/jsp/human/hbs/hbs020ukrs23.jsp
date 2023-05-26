<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.minmumWageInfo" default="최저임금정보"/>',
		border: false,
		id: 'hbs020ukrTab23',
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailFormSimple',
			itemId : 'minimumWageForm',
			layout: {type: 'uniTable'},
			items:[
			{
                fieldLabel: '<t:message code="system.label.human.baseyear" default="기준년도"/>',
                xtype: 'uniYearField',
                name :'TAX_YYYY',
                value: new Date().getFullYear()
			}]
		}, {
			xtype: 'uniGridPanel',
			id:'uniGridPanel23',
			itemId :'uniGridPanel23',
		    store : hbs020ukrs23Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false,
	            state: {
	    			useState: false,
	    			useStateList: false
	    		}
			},
			columns: [
				{dataIndex: 'TAX_YYYY'	    , width: 100, editor : {xtype :'uniYearField'}},				  
				{dataIndex: 'HOUR_WAGES'	, width: 133},				  
				{dataIndex: 'MIN_WAGES'		, width: 133},				  
				{dataIndex: 'REMARK'	    , minWidth: 133, flex: 1}
			],
			listeners: {
				beforeedit  : function( editor, e, eOpts ) {
					
					if(!e.record.phantom){						
						if (UniUtils.indexOf(e.field, ['TAX_YYYY'])){
							return false;
						}else{
							return true;
						}	
					}					
				}
			}
		}]
	}