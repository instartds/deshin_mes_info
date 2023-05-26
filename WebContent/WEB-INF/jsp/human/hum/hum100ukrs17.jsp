<%@page language="java" contentType="text/html; charset=utf-8"%>

	Unilite.defineModel('hum100ukrs17Model', {
		fields: [
			 {name: 'PERSON_NUMB'    			,text:'<t:message code="unilite.msg.sMHT0005" default="사번"/>'         	,type : 'string', allowBlank:false } 
			,{name: 'PAYMENT_DATE'    		,text:'<t:message code="unilite.msg.sMH1164" default="지급일"/>'        	,type : 'uniDate', allowBlank:false } 
			,{name: 'FAMILY_NAME'    			,text:'<t:message code="unilite.msg.sMHT1002" default="가족성명"/>'     	,type : 'string', allowBlank:false } 
			,{name: 'FAMILY_RELATION'    	,text:'<t:message code="unilite.msg.sMHT1062" default="가족관계"/>'     	,type : 'string', allowBlank:false , comboType: 'AU', comboCode: 'H020'} 
			,{name: 'PAYMENT_AMOUNT'    	,text:'<t:message code="unilite.msg.sMHT1021" default="지급금액"/>'     	,type : 'uniPrice'} 
			,{name: 'SALARY_REFLECT_YN'  	,text:'<t:message code="unilite.msg.sMHT1063" default="급여반영여부"/>' 	,type : 'string', comboType: 'AU', comboCode: 'A020'} 
			,{name: 'REF_YEAR_MONTH'    	,text:'<t:message code="unilite.msg.sMHT1064" default="반영년월"/>'     	,type : 'string', maxLength:6} 
			,{name: 'COMP_CODE'    		,text:'법인코드' ,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode} 
		]
	});
	var hum100ukrs17Store = Unilite.createStore('hum100ukrs17Store',{
			model: 'hum100ukrs17Model',
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
                	   read :  hum100ukrService.schoolExpence,
                	   update: hum100ukrService.updateHUM820,
					   create: hum100ukrService.insertHUM820,
					   destroy:hum100ukrService.deleteHUM820,
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
		
 var schoolExpence	= {
    		title:'학자금지원',
    		itemId: 'schoolExpence',
         layout: {
				type:'vbox', 
				align:'stretch'
			},			
        	items: [
        		basicInfo,
				{	
					xtype: 'uniGridPanel',
					itemId:'hum100ukrs17Grid',				
					dockedItems: [{
				        xtype: 'toolbar',
				        dock: 'top',
				        padding:'0px',
				        border:0
				    }],
					bodyCls: 'human-panel-form-background',
			        store : hum100ukrs17Store, 
			        padding: '0 10 0 10',
			        uniOpt:{	
			        	expandLastColumn: false,
	        			useRowNumberer: true,
	                    useMultipleSorting: false
			        },
			        columns:  [     
						 { dataIndex: 'PAYMENT_DATE',  width:	100 } 
				  		,{ dataIndex: 'FAMILY_NAME',  width:	150 } 
				  		,{ dataIndex: 'FAMILY_RELATION',  width:	150 } 
				  		,{ dataIndex: 'PAYMENT_AMOUNT',  width:	150 } 
				  		,{ dataIndex: 'SALARY_REFLECT_YN',  width:	150 } 
					    ,{ dataIndex: 'REF_YEAR_MONTH',  width:	100 } 
					]
				}
			],
			loadData:function(personNum)	{
					this.down('#hum100ukrs17Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
			
		};

 			