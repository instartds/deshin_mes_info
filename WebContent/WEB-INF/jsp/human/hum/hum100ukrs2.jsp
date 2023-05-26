<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.familyinfo" default="가족사항"/>',
		itemId: 'familyInfo',
        xtype: 'uniDetailForm',
        api: {
         		 load: 'hum100ukrService.select'
		},
		padding: '0 0 0 0',
		layout: {type: 'hbox', align:'stretch'},
        items:[basicInfo,
        	{	xtype: 'uniGridPanel',
				itemId:'hum100ukrs2Grid',
		        store : hum100ukrs2Store, 
		        padding: '0 0 0 10',
		        uniOpt:{	expandLastColumn: true,
		        			useRowNumberer: true,
		                    useMultipleSorting: false
		        },
		        
		        columns:  [     
		               		 { dataIndex: 'FAMILY_NAME', 	width: 90 } 
							,{ dataIndex: 'REL_CODE',  		width: 90 } 
							,{ dataIndex: 'REPRE_NUM',  	width: 120 } 
							,{ dataIndex: 'TOGETHER_YN',  	width: 80 }  
							,{ dataIndex: 'SCHSHIP_CODE',  	width: 90 } 
							,{ dataIndex: 'GRADU_TYPE',  	width: 110 } 
							,{ dataIndex: 'OCCUPATION',  	width: 150 } 
							,{ dataIndex: 'COMP_NAME',  	width: 80 } 
							,{ dataIndex: 'POST_NAME',  	width: 80 } 
							
						  ]
			}
        ]
        ,loadData:function(personNum)	{
        			this.getForm().load({params : {'PERSON_NUMB':personNum}});
					this.down('#hum100ukrs2Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
		}
	}