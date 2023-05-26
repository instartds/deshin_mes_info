<%@page language="java" contentType="text/html; charset=utf-8"%>

	Unilite.defineModel('hum100ukrs10Model', {
	    fields: [
					 {name: 'PERSON_NUMB'	,text:'<t:message code="unilite.msg.sMHT0005" default="사번"/>'         ,type : 'string', allowBlank:false } 
					,{name: 'QUAL_KIND'   	,text:'<t:message code="unilite.msg.sMHT1014" default="자격종류"/>'     ,type : 'string', allowBlank:false  } 
					,{name: 'QUAL_GRADE'    ,text:'<t:message code="unilite.msg.sMHT0033" default="등급"/>'         ,type : 'string'} 
					,{name: 'ACQ_DATE'    	,text:'<t:message code="unilite.msg.sMHT1015" default="취득일"/>'       ,type : 'uniDate', allowBlank:false } 
					,{name: 'VALI_DATE'    	,text:'<t:message code="unilite.msg.sMHT0095" default="유효일"/>'       ,type : 'uniDate'} 
					,{name: 'RENEW_DATE'    ,text:'<t:message code="unilite.msg.sMHT1016" default="차기갱신일"/>'   ,type : 'uniDate'} 
					,{name: 'QUAL_MACH'    	,text:'<t:message code="unilite.msg.sMHT1017" default="발행기관"/>'     ,type : 'string'} 
					,{name: 'QUAL_NUM'    	,text:'<t:message code="unilite.msg.sMHT1018" default="자격증번호"/>'   ,type : 'string'} 
					,{name: 'COMP_CODE'    	,text:'법인코드' ,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode} 

			]
	});
	var hum100ukrs10Store = Unilite.createStore('hum100ukrs10Store',{
			model: 'hum100ukrs10Model',
            autoLoad: false,
            uniOpt : { 
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
                api: {
                	   read :  s_hum100ukrService_KOCIS.certificateInfo,
                	   update: s_hum100ukrService_KOCIS.updateHUM600,
					   create: s_hum100ukrService_KOCIS.insertHUM600,
					   destroy:s_hum100ukrService_KOCIS.deleteHUM600,
					   syncAll:s_hum100ukrService_KOCIS.saveCertificateAll
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
		
var certificateInfo = {
			title:'자격면허',
			itemId: 'certificateInfo',
			layout:{type:'vbox', align:'stretch'},			
        	items:[
        			basicInfo,
					{	xtype: 'uniGridPanel',
						itemId:'hum100ukrs10Grid',				
						dockedItems: [{
					        xtype: 'toolbar',
					        dock: 'top',
					        padding:'0px',
					        border:0
					    }],
				        store : hum100ukrs10Store, 
				        padding: '0 10 0 10',
				        uniOpt:{	expandLastColumn: true,
				        			useRowNumberer: true,
				                    useMultipleSorting: false,
				                    userToolbar : false
				        },
				        columns:  [     
				               		 	 { dataIndex: 'QUAL_KIND',  width: 250 } 
										,{ dataIndex: 'QUAL_GRADE',  width: 100 } 
										,{ dataIndex: 'ACQ_DATE',  width: 100 } 
										,{ dataIndex: 'VALI_DATE',  width: 100 } 
										,{ dataIndex: 'RENEW_DATE',  width: 120 } 
										,{ dataIndex: 'QUAL_MACH',  width: 200 } 
										,{ dataIndex: 'QUAL_NUM',  width: 100 }  
								  ],
								listeners: {
							        beforeedit  : function( editor, e, eOpts ) {
							        	if(!e.record.phantom) {
							        		if(UniUtils.indexOf(e.field, ['QUAL_KIND', 'ACQ_DATE'])) 
											{ 
												return false;
						      				} else {
						      					return true;
						      				}
							        	} else {
							        		if(UniUtils.indexOf(e.field)) 
											{ 
						      					return true;
						      				}
							        	}
							        }
								}
					}
			],
			loadData:function(personNum)	{
					this.down('#hum100ukrs10Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
			
		}