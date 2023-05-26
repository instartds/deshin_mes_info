<%@page language="java" contentType="text/html; charset=utf-8"%>
	Unilite.defineModel('hum100ukrs13Model', {
		fields: [
			 {name: 'PERSON_NUMB'    			,text:'<t:message code="unilite.msg.sMHT0005" default="사번"/>'                	,type : 'int', allowBlank:false } 
			,{name: 'OCCUR_DATE'    			,text:'<t:message code="unilite.msg.sMHT1055" default="발생일자"/>'            	,type : 'uniDate', allowBlank:false } 
			,{name: 'KIND_PRIZE_PENALTY'  		,text:'<t:message code="unilite.msg.sMHT1056" default="상벌종류"/>'            	,type : 'string', allowBlank:false , comboType: 'AU', comboCode: 'H096'} 
			,{name: 'NAME_PRIZE_PENALTY'  		,text:'<t:message code="unilite.msg.sMHT1057" default="상벌명"/>'              	,type : 'string'} 
			,{name: 'REASON'    				,text:'<t:message code="unilite.msg.sMHT1058" default="사유"/>'                	,type: 'string'} 
			,{name: 'VALIDITYFR_DATE'    		,text:'징계기간시작일'     	,type : 'uniDate'} 
			,{name: 'VALIDITY_DATE'    			,text:'징계기간종료일'     	,type : 'uniDate'} 
			,{name: 'VALIDITYTO_DATE'    		,text:'징계기간승급제한일' 	,type : 'uniDate'} 
			,{name: 'EX_DATE'    				,text:'징계말소일자'      	,type : 'uniDate'} 
			,{name: 'ADDITION_POINT'    		,text:'<t:message code="unilite.msg.sMHT1060" default="가산점"/>'              	,type : 'string'} 
			,{name: 'RELATION_ORGAN'    		,text:'<t:message code="unilite.msg.sMHT1061" default="관련기관"/>'            	,type : 'string'} 
			,{name: 'UPDATE_DB_USER'    		,text:'<t:message code="unilite.msg.sMHT1007" default="수정자"/>'              	,type : 'string'} 
			,{name: 'UPDATE_DB_TIME'     		,text:'<t:message code="unilite.msg.sMHT1008" default="수정일"/>'              	,type : ''}  
			,{name: 'COMP_CODE'    				,text:'법인코드' ,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode} 
		]
	});
	var hum100ukrs13Store = Unilite.createStore('hum100ukrs13Store',{
			model: 'hum100ukrs13Model', 
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
                	   read :  hum100ukrService.disciplinaryInfo,
                	   update: hum100ukrService.updateHUM810,
					   create: hum100ukrService.insertHUM810,
					   destroy:hum100ukrService.deleteHUM810,
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
var disciplinaryInfo =	{
		title:'상벌사항',
		itemId: 'disciplinaryInfo',
        layout: {
				type:'vbox', 
				align:'stretch'
			},			
        	items: [
        		basicInfo,
				{	
					xtype: 'uniGridPanel',
					itemId:'hum100ukrs13Grid',				
					dockedItems: [{
				        xtype: 'toolbar',
				        dock: 'top',
				        padding:'0px',
				        border:0
				    }],
					bodyCls: 'human-panel-form-background',
			        store : hum100ukrs13Store, 
			        padding: '0 10 0 10',
			        uniOpt:{	
			        	expandLastColumn: false,
	        			useRowNumberer: true,
	                    useMultipleSorting: false
			        },
			        columns:  [     
						 { dataIndex: 'OCCUR_DATE',  width:	150 } 
				  		,{ dataIndex: 'KIND_PRIZE_PENALTY',  width:	150 } 
				  		,{ dataIndex: 'NAME_PRIZE_PENALTY',  width:	150 } 
				  		,{ dataIndex: 'REASON',  width:	110 } 
				  		,{ dataIndex: 'VALIDITYFR_DATE',  width:	150 } 
				  		,{ dataIndex: 'VALIDITY_DATE',  width:	150 } 
				  		,{ dataIndex: 'VALIDITYTO_DATE',  width:	150 } 
				  		,{ dataIndex: 'EX_DATE',  width:	150 } 
				  		,{ dataIndex: 'ADDITION_POINT',  width:	110 } 
					    ,{ dataIndex: 'RELATION_ORGAN',  width:	100 } 			    
					]
				}
			],
			loadData:function(personNum)	{
					this.down('#hum100ukrs13Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
			
		};