<%@page language="java" contentType="text/html; charset=utf-8"%>
	Unilite.defineModel('hum100ukrs14Model', {
		fields: [
			 {name: 'PERSON_NUMB'    	,text:'PERSON_NUMB'	,type : 'string', allowBlank:false } 
			,{name: 'CONTRACT_DATE'   	,text:'계약갱신일' 	,type : 'uniDate', allowBlank:false } 
			,{name: 'CONTRACT_FRDATE' 	,text:'계약기간시작일'   	,type : 'uniDate', allowBlank:false } 
			,{name: 'CONTRACT_TODATE' 	,text:'계약기간종료일'   	,type : 'uniDate', allowBlank:false } 
			,{name: 'CONTRACT_GUBUN'  	,text:'계약구분'   	,type : 'string', comboType: 'AU', comboCode: 'H164'} 
			,{name: 'CONTRACT_TERMS'  	,text:'계약조건'   	,type : 'string'} 
			,{name: 'SPECIAL_ITEM'    	,text:'특기사항'   	,type : 'string'} 
			,{name: 'JOB_NAME'    		,text:'담당업무'   	,type : 'string'} 
			,{name: 'BIGO'    			,text:'비고'       	,type : 'string'} 
			,{name: 'COMP_CODE'    		,text:'법인코드' ,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode} 
		]
	});
	var hum100ukrs14Store = Unilite.createStore('hum100ukrs14Store',{
			model: 'hum100ukrs14Model',
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
                       read :  hum100ukrService.contractInfo,
                       update: hum100ukrService.updateHUM840,
                       create: hum100ukrService.insertHUM840,
                       destroy:hum100ukrService.deleteHUM840,
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
		
var contractInfo =	{
		title:'계약사항',
		itemId: 'contractInfo',
         layout: {
				type:'vbox', 
				align:'stretch'
			},			
        	items: [
        		basicInfo,
				{	
					xtype: 'uniGridPanel',
					itemId:'hum100ukrs14Grid',				
					dockedItems: [{
				        xtype: 'toolbar',
				        dock: 'top',
				        padding:'0px',
				        border:0
				    }],
			        store : hum100ukrs14Store, 
			        padding: '0 10 0 10',
			        uniOpt:{	
			        	expandLastColumn: true,
	        			useRowNumberer: true,
	                    useMultipleSorting: false,
	                    userToolbar : false
			        },
			        columns:  [     
						 { dataIndex: 'COMP_CODE',  width:	100 , hidden:true } 
						,{ dataIndex: 'PERSON_NUMB',  width:    100, hidden:true  } 
						,{ dataIndex: 'CONTRACT_DATE',  width:    100  } 
				  		,{ dataIndex: 'CONTRACT_FRDATE',  width:	120 } 
				  		,{ dataIndex: 'CONTRACT_TODATE',  width:	120 } 
				  		,{ dataIndex: 'CONTRACT_GUBUN',  width:	110 } 
				  		,{ dataIndex: 'CONTRACT_TERMS',  width:	200 } 
				  		,{ dataIndex: 'SPECIAL_ITEM',  width:	150  		 } 
					    ,{ dataIndex: 'JOB_NAME',  width:	150 } 
					    ,{ dataIndex: 'BIGO',  flex:1}			    
					]
				}
			],
			loadData:function(personNum)	{
					this.down('#hum100ukrs14Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
			
		};