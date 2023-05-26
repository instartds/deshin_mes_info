<%@page language="java" contentType="text/html; charset=utf-8"%>
	/**
	 * 경력사항
	 */
	Unilite.defineModel('hum100ukrs7Model', { 
	    fields: [
					 {name: 'COMP_CODE'    					,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'			,type : 'string', allowBlank:false ,defaultValue:UserInfo.compCode} 
					,{name: 'NAME'    								,text:'<t:message code="system.label.human.name" default="성명"/>'       	,type : 'string'} 
					,{name: 'PERSON_NUMB'    				,text:'<t:message code="system.label.human.personnumb" default="사번"/>'       	,type : 'string', allowBlank:false } 
					,{name: 'CARR_STRT_DATE'  			,text:'<t:message code="system.label.human.carrstrtdate" default="근무기간(FR)"/>' 	,type : 'uniDate', allowBlank:false } 
					,{name: 'CARR_END_DATE'   			,text:'<t:message code="system.label.human.carrenddate" default="근무기간(TO)"/>' 	,type : 'uniDate', allowBlank:false } 
					,{name: 'COMP_NAME'    					,text:'<t:message code="system.label.human.compname" default="회사명"/>'     	,type : 'string', allowBlank:false } 
					,{name: 'POST_NAME'    					,text:'<t:message code="system.label.human.postname" default="직위명"/>'     	,type : 'string'} 
					,{name: 'OCPT_NAME'    					,text:'<t:message code="system.label.human.ocpt" default="직종"/>'       	,type : 'string'} 
					,{name: 'DEPT_NAME'    					,text:'<t:message code="system.label.human.deptname" default="부서명"/>'   	,type : 'string'} 
					,{name: 'JOB_NAME'    						,text:'<t:message code="system.label.human.jobname" default="담당업무명"/>'     ,type : 'string'} 
					,{name: 'CARR_GUBUN'    					,text:'<t:message code="system.label.human.carrgubun" default="인정경력구분"/>'     	,type : 'string', comboType: 'AU', comboCode: 'H163'}
					
					,{name: 'WORK_PROD'      			 	,text:'<t:message code="system.label.human.workprod" default="근무기간"/>'      ,type : 'string', editable:false}
			]
	});
	var hum100ukrs7Store = Unilite.createStore('hum100ukrs7Store',{
			model: 'hum100ukrs7Model',
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
					var grid = careerInfo.down('#hum100ukrs7Grid')
					if(grid) {
						grid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			}  
            
		});

var careerInfo = {
			title:'<t:message code="system.label.human.careerinfo" default="경력사항"/>',
			itemId: 'careerInfo',
			layout:{type:'vbox', align:'stretch'},			
        	items:[
        			basicInfo,
					{	xtype: 'uniGridPanel',
						itemId:'hum100ukrs7Grid',				
						dockedItems: [{
					        xtype: 'toolbar',
					        dock: 'top',
					        padding:'0px',
					        border:0
					    }],
				        store : hum100ukrs7Store, 
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
									,{ dataIndex: 'POST_NAME',  width: 150			 } 
									,{ dataIndex: 'OCPT_NAME',  width: 150 } 
									,{ dataIndex: 'DEPT_NAME',  width: 150	 } 
									,{ dataIndex: 'JOB_NAME',  width: 180 } 
									,{ dataIndex: 'CARR_GUBUN',  width: 180 }
									
									,{ dataIndex: 'WORK_PROD',  width: 180 } 
								  ],
                                    listeners: {
                                         beforeedit  : function( editor, e, eOpts ) {
                                                if(UniUtils.indexOf(e.field, ['NAME','PERSON_NUMB','CARR_STRT_DATE','CARR_END_DATE'])){
                                                    if(e.record.phantom == true){
                                                       return true;
                                                    }else{
                                                       return false;    
                                                    }
                                                }
                                          }
                                    }
					}
			],
			loadData:function(personNum)	{
					this.down('#hum100ukrs7Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
			
		}