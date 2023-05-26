<%@page language="java" contentType="text/html; charset=utf-8"%>
	/**
	 * 고정지급/공제-고정지급
	 */
	Unilite.defineModel('hum100ukrs6_1Model', {
	    fields: [
					 {name: 'PERSON_NUMB'   	,text:'<t:message code="system.label.human.personnumb" default="사번"/>'	,type : 'string', allowBlank:false , editable:false} 
					,{name: 'WAGES_CODE'   		,text:'<t:message code="system.label.human.wagescode" default="지급코드"/> '	,type : 'string', allowBlank:false , editable:false} 
					,{name: 'NAME'    					,text:'<t:message code="system.label.human.stdname" default="지급내역"/>'	,type : 'string', editable:false} 
					,{name: 'AMOUNT_I'    			,text:'<t:message code="system.label.human.payi" default="지급금액"/>'	,type : 'uniPrice', allowBlank:false } 
					,{name: 'COMP_CODE'    		,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'	,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode, editable:false} 
			]
	});
	var hum100ukrs6_1Store = Unilite.createStore('hum100ukrs6_1Store',{ 
			model: 'hum100ukrs6_1Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : hum100ukrService.deductionInfo1,
                	   update: hum100ukrService.saveHPA200,				   
				   	   destroy:hum100ukrService.deleteHPA200,
				   	   syncAll:hum100ukrService.syncAll
                }
            },
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll(config);					
				}else {
					alert(Msg.sMB083);
				}
			} 
            
		});
		
	/**
	 * 고정지급/공제-공제
	 */
	Unilite.defineModel('hum100ukrs6_2Model', {
	    fields: [
					 {name: 'SUPP_TYPE'    			,text:'<t:message code="system.label.human.supptype" default="지급구분"/>' 	,type : 'string', allowBlank:false , editable:false} 
					,{name: 'PERSON_NUMB'  	,text:'<t:message code="system.label.human.personnumb" default="사번"/>'     	,type : 'string', allowBlank:false , editable:false} 
					,{name: 'DED_CODE'     			,text:'<t:message code="system.label.human.dedcode" default="공제코드"/>' 	,type : 'string', allowBlank:false , editable:false} 
					,{name: 'NAME'    	   				,text:'<t:message code="system.label.human.dedname" default="공제내역"/>' 	,type : 'string', editable:false} 
					,{name: 'DED_AMOUNT_I' 	,text:'<t:message code="system.label.human.dedamount" default="공제금액"/>' 	,type : 'uniPrice', allowBlank:false } 
					,{name: 'COMP_CODE'   		,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'	,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode, editable:false} 
			]
	});
	var hum100ukrs6_2Store = Unilite.createStore('hum100ukrs6_2Store',{
			model: 'hum100ukrs6_2Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read :  hum100ukrService.deductionInfo2,
                	   update: hum100ukrService.saveHPA500,				   
				   	   destroy:hum100ukrService.deleteHPA500,
				   	   syncAll:hum100ukrService.syncAll
                }
            },
            saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					alert(Msg.sMB083);
				}
			} 
            
		});

 var deductionInfo =		{
    		title:'<t:message code="system.label.human.deductioninfo" default="고정지급/공제"/>',
    		itemId: 'deductionInfo',
			layout: {type: 'vbox', align:'stretch'},
	        items:[basicInfo,
	        	{	
	        		xtype: 'container',
	        		layout: {type: 'hbox', align:'stretch'},
	        		flex:1,
	     			autoScroll:false,
	        		items:[
		        	{	xtype: 'uniGridPanel',
						itemId:'hum100ukrs6_1Grid',
				        store : hum100ukrs6_1Store, 
				        padding: '0 10 0 9',
				        dockedItems: [{
					        xtype: 'toolbar',
					        dock: 'top',
					        padding:'0px',
					        border:0
					    }],
				        uniOpt:{	expandLastColumn: false,
				        			useRowNumberer: false,
				                    useMultipleSorting: false
				        },				        
				        columns:  [     
				               		 { dataIndex: 'NAME',  width: 180 } 
									,{ dataIndex: 'AMOUNT_I',  flex:1 } 								
								  ]
					},
					{	xtype: 'uniGridPanel',
						itemId:'hum100ukrs6_2Grid',
				        store : hum100ukrs6_2Store, 
				        padding: '0 10 0 0',
				        uniOpt:{	expandLastColumn: false,
				        			useRowNumberer: false,
				                    useMultipleSorting: false
				        },
				        dockedItems: [{
					        xtype: 'toolbar',
					        dock: 'top',
					        padding:'0px',
					        border:0
					    }],
				        columns:  [     
				               		 { dataIndex: 'NAME',  width: 180 } 
									,{ dataIndex: 'DED_AMOUNT_I', flex:1  } 
								
								  ]
					}
					]
	        	}
	        ]
	        ,loadData:function(personNum)	{
						this.down('#hum100ukrs6_1Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
						this.down('#hum100ukrs6_2Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
            
    	};