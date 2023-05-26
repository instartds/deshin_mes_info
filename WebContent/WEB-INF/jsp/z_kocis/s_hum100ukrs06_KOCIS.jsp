<%@page language="java" contentType="text/html; charset=utf-8"%>
	/**
	 * 고정지급/공제-고정지급
	 */
	Unilite.defineModel('hum100ukrs6_1Model', {
	    fields: [
					 {name: 'PERSON_NUMB'   ,text:'<t:message code="unilite.msg.sMHT0005" default="사번"/>'	,type : 'string', allowBlank:false , editable:false} 
					,{name: 'WAGES_CODE'    ,text:'<t:message code="unilite.msg.sMHT1020" default="지급코드"/> '	,type : 'string', allowBlank:false , editable:false} 
					,{name: 'NAME'    		,text:'<t:message code="unilite.msg.sMHT0117" default="지급내역"/>'	,type : 'string', editable:false} 
					,{name: 'AMOUNT_I'    	,text:'<t:message code="unilite.msg.sMHT1021" default="지급금액"/> '	,type : 'uniPrice', allowBlank:false } 
					,{name: 'COMP_CODE'    	,text:'법인코드'	,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode, editable:false} 
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
                	   read : s_hum100ukrService_KOCIS.deductionInfo1,
                	   update: s_hum100ukrService_KOCIS.saveHPA200,				   
				   	   destroy:s_hum100ukrService_KOCIS.deleteHPA200,
				   	   syncAll:s_hum100ukrService_KOCIS.syncAll
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
					 {name: 'SUPP_TYPE'    ,text:'<t:message code="unilite.msg.sMHT0114" default="지급구분"/>' 	,type : 'string', allowBlank:false , editable:false} 
					,{name: 'PERSON_NUMB'  ,text:'<t:message code="unilite.msg.sMHT0005" default="사번"/>'     	,type : 'string', allowBlank:false , editable:false} 
					,{name: 'DED_CODE'     ,text:'<t:message code="unilite.msg.sMHT1022" default="공제코드"/>' 	,type : 'string', allowBlank:false , editable:false} 
					,{name: 'NAME'    	   ,text:'<t:message code="unilite.msg.sMHT1023" default="공제내역"/>' 	,type : 'string', editable:false} 
					,{name: 'DED_AMOUNT_I' ,text:'<t:message code="unilite.msg.sMHT1024" default="공제금액"/>' 	,type : 'uniPrice', allowBlank:false } 
					,{name: 'COMP_CODE'    ,text:'법인코드'	,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode, editable:false} 
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
                	   read :  s_hum100ukrService_KOCIS.deductionInfo2,
                	   update: s_hum100ukrService_KOCIS.saveHPA500,				   
				   	   destroy:s_hum100ukrService_KOCIS.deleteHPA500,
				   	   syncAll:s_hum100ukrService_KOCIS.syncAll
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
    		title:'고정지급/공제',
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