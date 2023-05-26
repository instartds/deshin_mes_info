<%@page language="java" contentType="text/html; charset=utf-8"%>
	/**
	 * 경력사항
	 */
	Unilite.defineModel('ham100ukrs7Model', { 
	    fields: [
					 {name: 'COMP_CODE'    		,text:'법인코드'			,type : 'string', allowBlank:false ,defaultValue:UserInfo.compCode} 
					,{name: 'NAME'    			,text:'<t:message code="unilite.msg.sMHT0004" default="성명"/>'       	,type : 'string'} 
					,{name: 'PERSON_NUMB'    	,text:'<t:message code="unilite.msg.sMHT0005" default="사번"/>'       	,type : 'string', allowBlank:false } 
					,{name: 'CARR_STRT_DATE'  	,text:'<t:message code="unilite.msg.sMSR396" default="계약일"/>' 	,type : 'uniDate', allowBlank:false } 
					,{name: 'CARR_END_DATE'   	,text:'<t:message code="unilite.msg.sMHT0008" default="종료일"/>' 	,type : 'uniDate', allowBlank:false } 
					,{name: 'COMP_NAME'    		,text:'<t:message code="unilite.msg.sMHT1011" default="회사명"/>'     	,type : 'string', allowBlank:false }
					,{name: 'WORK_TEAM'            ,text:'근무형태'      ,type : 'string', comboType: 'AU', comboCode: 'H004'} 
					,{name: 'POST_NAME'    		,text:'<t:message code="unilite.msg.sMHT1012" default="직위명"/>'     	,type : 'string'} 
					,{name: 'OCPT_NAME'    		,text:'<t:message code="unilite.msg.sMHT1013" default="직종"/>'       	,type : 'string'} 
					,{name: 'DEPT_NAME'    		,text:'<t:message code="unilite.msg.sMHT0137" default="부서명"/>'   	,type : 'string'} 
					,{name: 'JOB_NAME'    		,text:'<t:message code="unilite.msg.sMHT0143" default="담당업무"/>'     ,type : 'string'} 
					,{name: 'CARR_GUBUN'    	,text:'인정경력구분'     	,type : 'string', comboType: 'AU', comboCode: 'H163'}
					
					,{name: 'WORK_PROD'       ,text:'근무기간'      ,type : 'string', editable:false} 
			]
	});
	var ham100ukrs7Store = Unilite.createStore('ham100ukrs7Store',{
			model: 'ham100ukrs7Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
                api: {
                	   read : hum100ukrService.careerInfo,
                	   update: hum100ukrService.updateHUM500,
					   create: hum100ukrService.insertHUM500,
					   destroy:hum100ukrService.deleteHUM500,
					   syncAll:hum100ukrService.saveCareerAll
                }
            }),
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect(config);					
				}else {
					alert(Msg.sMB083);
				}
			}  
            
		});

var careerInfo = {
			title:'계약사항',
			itemId: 'careerInfo',
			layout:{type:'vbox', align:'stretch'},			
        	items:[
        			basicInfo,
					{	xtype: 'uniGridPanel',
						itemId:'ham100ukrs7Grid',				
						dockedItems: [{
					        xtype: 'toolbar',
					        dock: 'top',
					        padding:'0px',
					        border:0
					    }],
				        store : ham100ukrs7Store, 
				        padding: '0 10 0 10',
				        uniOpt:{	expandLastColumn: true,
				        			useRowNumberer: true,
				                    useMultipleSorting: false,
				                    userToolbar : false
				        },
				        columns:  [     
				               		 { dataIndex: 'NAME',  width: 90 , hidden: true} 
									,{ dataIndex: 'PERSON_NUMB',  width: 90 , hidden: true} 
									,{ dataIndex: 'CARR_STRT_DATE',  width: 100 } 
									,{ dataIndex: 'CARR_END_DATE',  width: 100 } 
									,{ dataIndex: 'COMP_NAME',  width: 180 } 
                                    ,{ dataIndex: 'WORK_TEAM',  width: 180 } 
									,{ dataIndex: 'POST_NAME',  width: 150			 } 
									,{ dataIndex: 'OCPT_NAME',  width: 150 } 
									,{ dataIndex: 'DEPT_NAME',  width: 150	 } 
									,{ dataIndex: 'JOB_NAME',  width: 180 } 
									,{ dataIndex: 'CARR_GUBUN',  width: 180 } 
                                    ,{ dataIndex: 'WORK_PROD',  width: 180 } 
					  ],
                        listeners: {
                            beforeedit  : function( editor, e, eOpts ) {
                                if(e.record.phantom != true){
                                    if(UniUtils.indexOf(e.field, ['NAME','PERSON_NUMB','CARR_STRT_DATE','CARR_END_DATE'])){
                                    	return false;
                                    }
                                }
                            }
                        }
				}
			],
			loadData:function(personNum)	{
					this.down('#ham100ukrs7Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
			
		}