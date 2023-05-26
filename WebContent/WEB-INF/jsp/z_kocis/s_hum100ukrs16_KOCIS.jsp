<%@page language="java" contentType="text/html; charset=utf-8"%>
	Unilite.defineModel('hum100ukrs16Model', {
		fields: [
			 {name: 'PERSON_NUMB'    	,text:'<t:message code="unilite.msg.sMH1166" default="사번"/>'     	,type : 'string', allowBlank:false } 
			,{name: 'OUT_FROM_DATE'  	,text:'<t:message code="unilite.msg.sMHT0007" default="시작일"/>'  	,type : 'uniDate', allowBlank:false } 
			,{name: 'OUT_TO_DATE'    	,text:'<t:message code="unilite.msg.sMHT0008" default="종료일"/>'  	,type : 'uniDate', allowBlank:false } 
			,{name: 'PURPOSE'    		,text:'<t:message code="unilite.msg.fsbMsgH0210" default="목적"/>' 	,type : 'string'} 
			,{name: 'NATION'    		,text:'<t:message code="unilite.msg.fsbMsgH0211" default="국가"/>' 	,type : 'string', allowBlank:false } 
			,{name: 'CITY'    			,text:'<t:message code="unilite.msg.fsbMsgH0212" default="도시"/>' 	,type : 'string', allowBlank:false } 
			,{name: 'COMP_CODE'    		,text:'법인코드' ,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode} 
		]
	});
	var hum100ukrs16Store = Unilite.createStore('hum100ukrs16Store',{
			model: 'hum100ukrs16Model',
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
                	   read :  s_hum100ukrService_KOCIS.abroadTrip,
                	   update: s_hum100ukrService_KOCIS.updateHUM830,
					   create: s_hum100ukrService_KOCIS.insertHUM830,
					   destroy:s_hum100ukrService_KOCIS.deleteHUM830,
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
		
var abroadTrip = {
		title:'해외출장',
		itemId: 'abroadTrip',
         layout: {
				type:'vbox', 
				align:'stretch'
			},			
        	items: [
        		basicInfo,
				{	
					xtype: 'uniGridPanel',
					itemId:'hum100ukrs16Grid',				
					dockedItems: [{
				        xtype: 'toolbar',
				        dock: 'top',
				        padding:'0px',
				        border:0
				    }],
					bodyCls: 'human-panel-form-background',
			        store : hum100ukrs16Store, 
			        padding: '0 10 0 10',
			        uniOpt:{	
			        	expandLastColumn: false,
	        			useRowNumberer: true,
	                    useMultipleSorting: false
			        },
			        columns:  [     
						 { dataIndex: 'OUT_FROM_DATE',  width:	80 } 
				  		,{ dataIndex: 'OUT_TO_DATE',  width:	80 } 
				  		,{ dataIndex: 'PURPOSE',  width:	300 } 
				  		,{ dataIndex: 'NATION',  width:	100  		 } 
					    ,{ dataIndex: 'CITY',  width:	100 } 
		    
					]
				}
			],
			loadData:function(personNum)	{
					this.down('#hum100ukrs16Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
			
		};

 			