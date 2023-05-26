<%@page language="java" contentType="text/html; charset=utf-8"%>
	/**
	 * 경력사항
	 */
	Unilite.defineModel('hum100ukrs7Model', { 
	    fields: [
					 {name: 'COMP_CODE'    		,text:'법인코드'			,type : 'string', allowBlank:false ,defaultValue:UserInfo.compCode} 
					,{name: 'NAME'    			,text:'<t:message code="unilite.msg.sMHT0004" default="성명"/>'       	,type : 'string'} 
					,{name: 'PERSON_NUMB'    	,text:'<t:message code="unilite.msg.sMHT0005" default="사번"/>'       	,type : 'string', allowBlank:false } 
					,{name: 'CARR_STRT_DATE'  	,text:'<t:message code="unilite.msg.sMHT1009" default="근무시작일"/>' 	,type : 'uniDate', allowBlank:false } 
					,{name: 'CARR_END_DATE'   	,text:'<t:message code="unilite.msg.sMHT1010" default="근무종료일"/>' 	,type : 'uniDate', allowBlank:false } 
					,{name: 'COMP_NAME'    		,text:'<t:message code="unilite.msg.sMHT1011" default="회사명"/>'     	,type : 'string', allowBlank:false } 
					,{name: 'POST_NAME'    		,text:'<t:message code="unilite.msg.sMHT1012" default="직위명"/>'     	,type : 'string'} 
					,{name: 'OCPT_NAME'    		,text:'<t:message code="unilite.msg.sMHT1013" default="직종"/>'       	,type : 'string'} 
					,{name: 'DEPT_NAME'    		,text:'<t:message code="unilite.msg.sMHT0137" default="부서명"/>'   	,type : 'string'} 
					,{name: 'JOB_NAME'    		,text:'<t:message code="unilite.msg.sMHT0143" default="담당업무"/>'     ,type : 'string'} 
					,{name: 'CARR_GUBUN'    	,text:'인정경력구분'     	,type : 'string', comboType: 'AU', comboCode: 'H163'} 
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
                	   read : s_hum100ukrService_KOCIS.careerInfo,
                	   update: s_hum100ukrService_KOCIS.updateHUM500,
					   create: s_hum100ukrService_KOCIS.insertHUM500,
					   destroy:s_hum100ukrService_KOCIS.deleteHUM500,
					   syncAll:s_hum100ukrService_KOCIS.saveCareerAll
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
			title:'경력사항',
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
								  ]
					}
			],
			loadData:function(personNum)	{
					this.down('#hum100ukrs7Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
			
		}