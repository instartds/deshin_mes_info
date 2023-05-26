<%@page language="java" contentType="text/html; charset=utf-8"%>
	/**
	 * 학력사항
	 */
	Unilite.defineModel('hum100ukrs8Model', { 
	    fields: [
					 {name: 'PERSON_NUMB'   	,text: '<t:message code="unilite.msg.sMH1166" default="사번"/>'	,type : 'string', allowBlank:false } 
					,{name: 'SCHOOL_NAME'   	,text: '<t:message code="unilite.msg.sMHT0091" default="학교명"/>'	,type : 'string', allowBlank:false } 
					,{name: 'ENTR_DATE'    		,text: '<t:message code="unilite.msg.sMHT1031" default="입학년도"/>'	,type : 'uniDate', allowBlank:false } 
					,{name: 'GRAD_DATE'    		,text: '<t:message code="unilite.msg.sMHT1032" default="졸업년도"/>'	,type : 'uniDate'} 
					,{name: 'GRAD_GUBUN'    	,text: '<t:message code="unilite.msg.sMHT0011" default="구분"/>'	,type : 'string' , comboType: 'AU', comboCode: 'H010'} 
					,{name: 'ADDRESS'    		,text: '<t:message code="unilite.msg.sMHT1033" default="소재지"/>'	,type : 'string'} 
					,{name: 'FIRST_SUBJECT' 	,text: '<t:message code="unilite.msg.sMHT0092" default="전공과목"/>'	,type : 'string' , comboType: 'AU', comboCode: 'H087'} 
					,{name: 'DEGREE'    		,text: '<t:message code="unilite.msg.sMHT1034" default="학위"/>'	,type : 'string'} 
					,{name: 'CREDITS'    		,text: '<t:message code="unilite.msg.sMHT1035" default="취득학점"/>'	,type : 'string'} 
					,{name: 'SPECIAL_ITEM'  	,text: '<t:message code="unilite.msg.sMHT1036" default="특기사항"/>'	,type : 'string'} 
					,{name: 'COMP_CODE'    		,text: '법인코드'	,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode} 
 
			]
	});
	var hum100ukrs8Store = Unilite.createStore('hum100ukrs8Store',{
			model: 'hum100ukrs8Model',
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
                	   read :  s_hum100ukrService_KOCIS.academicBakground,
                	   update: s_hum100ukrService_KOCIS.updateHUM720,
					   create: s_hum100ukrService_KOCIS.insertHUM720,
					   destroy:s_hum100ukrService_KOCIS.deleteHUM720,
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
		
var academicBakground =	{
			title:'학력사항',
			itemId: 'academicBakground',
			layout:{type:'vbox', align:'stretch'},			
        	items:[
        			basicInfo,
					{	xtype: 'uniGridPanel',
						itemId:'hum100ukrs8Grid',				
						dockedItems: [{
					        xtype: 'toolbar',
					        dock: 'top',
					        padding:'0px',
					        border:0
					    }],
						bodyCls: 'human-panel-form-background',
				        store : hum100ukrs8Store, 
				        padding: '0 10 0 10',
				        uniOpt:{	expandLastColumn: true,
				        			useRowNumberer: true,
				                    useMultipleSorting: false
				        },
				        columns:  [     
				               		 { dataIndex: 'SCHOOL_NAME',  width:140 } 
							  		,{ dataIndex: 'ENTR_DATE',  width:100 } 
							  		,{ dataIndex: 'GRAD_DATE',  width:100 } 
							  		,{ dataIndex: 'GRAD_GUBUN',  width:80 } 
							  		,{ dataIndex: 'ADDRESS',  width:200 } 
								    ,{ dataIndex: 'FIRST_SUBJECT',  width: 180 } 
								    ,{ dataIndex: 'DEGREE',  width:	80 } 
							  		,{ dataIndex: 'CREDITS',  width:	90 } 
								    ,{ dataIndex: 'SPECIAL_ITEM',  width:	90 } 
								  ]
					}
			],
			loadData:function(personNum)	{
					this.down('#hum100ukrs8Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
			
		}