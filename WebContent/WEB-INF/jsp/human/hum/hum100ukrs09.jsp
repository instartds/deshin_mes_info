<%@page language="java" contentType="text/html; charset=utf-8"%>
	/**
	 * 교육사항
	 */
	Unilite.defineModel('hum100ukrs9Model', {
	    fields: [
					 {name: 'PERSON_NUMB'   		,text:'<t:message code="system.label.human.personnumb" default="사번"/>'                 	,type : 'int', allowBlank:false } 
					,{name: 'EDU_TITLE'    				,text:'<t:message code="system.label.human.edutitle" default="교육명"/>'               	,type : 'string', allowBlank:false } 
					,{name: 'EDU_FR_DATE'    			,text:'<t:message code="system.label.human.edudate" default="교육기간"/>'             	,type : 'uniDate', allowBlank:false } 
					,{name: 'EDU_TO_DATE'    		,text:'<t:message code="system.label.human.edudate" default="교육기간"/>'             	,type : 'uniDate'} 
					,{name: 'EDU_TIME'    				,text:'<t:message code="system.label.human.edutime" default="교육시간"/>' 	,type : 'int'} 
					,{name: 'EDU_ORGAN'    			,text:'<t:message code="system.label.human.eduorgan" default="교육기관"/>'             	,type : 'string', comboType: 'AU', comboCode: 'H089'} 
					,{name: 'EDU_NATION'    			,text:'<t:message code="system.label.human.edunation" default="교육국가"/>'             	,type : 'string', comboType: 'AU', comboCode: 'H090'} 
					,{name: 'EDU_GUBUN'    			,text:'<t:message code="system.label.human.type" default="구분"/>'                 	,type : 'string', comboType: 'AU', comboCode: 'H091'} 
					,{name: 'EDU_GRADES'    			,text:'<t:message code="system.label.human.edugrades" default="이수점수"/>'             	,type : 'int'} 
					,{name: 'EDU_AMT'    				,text:'<t:message code="system.label.human.eduusei" default="교육비"/>'               	,type : 'uniPrice'} 
					,{name: 'REPORT_YN'    			,text:'<t:message code="system.label.human.reportyn" default="Report 제출여부"/>'       	,type : 'string', comboType: 'AU', comboCode: 'A020'} 
					,{name: 'GRADE'    						,text:'<t:message code="system.label.human.meritsgrade" default="고과점수"/>'         	,type : 'int'} 
					,{name: 'COMP_CODE'    			,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'            	,type : 'string', allowBlank:false } 
					,{name: 'COMP_CODE'    			,text: '<t:message code="system.label.human.compcode" default="법인코드"/>'	,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode} 

			]
	});
	var hum100ukrs9Store = Unilite.createStore('hum100ukrs9Store',{
			model: 'hum100ukrs9Model', 
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
                	   read :  hum100ukrService.educationInfo,
                	   update: hum100ukrService.updateHUM740,
					   create: hum100ukrService.insertHUM740,
					   destroy:hum100ukrService.deleteHUM740,
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
		
	
var educationInfo = {
			title:'<t:message code="system.label.human.educationinfo" default="교육사항"/>',
			itemId: 'educationInfo',
			layout:{type:'vbox', align:'stretch'},			
        	items:[
        			basicInfo,
					{	xtype: 'uniGridPanel',
						itemId:'hum100ukrs9Grid',				
						dockedItems: [{
					        xtype: 'toolbar',
					        dock: 'top',
					        padding:'0px',
					        border:0
					    }],
						bodyCls: 'human-panel-form-background',
				        store : hum100ukrs9Store, 
				        padding: '0 10 0 10',
				        uniOpt:{	expandLastColumn: true,
				        			useRowNumberer: true,
				                    useMultipleSorting: false
				        },
				        columns:  [     
				               		 { dataIndex: 'PERSON_NUMB',  width:	150  , hidden:true} 
							  		,{ dataIndex: 'EDU_TITLE',  width:	130 } 
							  		,{ dataIndex: 'EDU_FR_DATE',  width:	80 } 
							  		,{ dataIndex: 'EDU_TO_DATE',  width:	80 } 
							  		,{ dataIndex: 'EDU_TIME',  width:	80 } 
							  		,{ dataIndex: 'EDU_ORGAN',  width:	150 } 
							  		,{ dataIndex: 'EDU_NATION',  width:	100 } 
								    ,{ dataIndex: 'EDU_GUBUN',  width:	100 } 
								    ,{ dataIndex: 'EDU_GRADES',  width:	100 } 
							  		,{ dataIndex: 'EDU_AMT',  width:	100 } 
							  		,{ dataIndex: 'REPORT_YN',  width:	100 } 
								    ,{ dataIndex: 'GRADE',  width:	100 } 
								  ]
					}
			],
			loadData:function(personNum)	{
					this.down('#hum100ukrs9Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
			
		}