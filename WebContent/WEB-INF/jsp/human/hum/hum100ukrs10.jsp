<%@page language="java" contentType="text/html; charset=utf-8"%>

	Unilite.defineModel('hum100ukrs10Model', {
	    fields: [
					 {name: 'PERSON_NUMB'	,text:'<t:message code="system.label.human.personnumb" default="사번"/>'         ,type : 'string', allowBlank:false }
					 
					 
					 
					,{name: 'QUAL_CODE'   	,text:'<t:message code="system.label.human.qualkind" default="자격종류"/>'     ,type : 'string'} 

					,{name: 'QUAL_KIND'   	,text:'<t:message code="system.label.human.qualcode" default="자격면허"/>'     ,type : 'string', allowBlank:false   , comboType: 'AU', comboCode: 'H022'  } 
					,{name: 'QUAL_GRADE'    ,text:'<t:message code="system.label.human.grade" default="등급"/>'         ,type : 'string'} 
					,{name: 'ACQ_DATE'    	,text:'<t:message code="system.label.human.acqdate" default="취득일"/>'       ,type : 'uniDate', allowBlank:false } 
					,{name: 'VALI_DATE'    	,text:'<t:message code="system.label.human.validate" default="유효일"/>'       ,type : 'uniDate'} 
					,{name: 'RENEW_DATE'    ,text:'<t:message code="system.label.human.renewdate" default="차기갱신일"/>'   ,type : 'uniDate'} 
					,{name: 'QUAL_MACH'    	,text:'<t:message code="system.label.human.qualmach" default="발행기관"/>'     ,type : 'string'} 
					,{name: 'QUAL_NUM'    	,text:'<t:message code="system.label.human.qualnum" default="자격번호"/>'   ,type : 'string'}

					,{name: 'ALWN_PAYN_YN'    	,text:'<t:message code="system.label.human.familyamountyn" default="수당지급여부"/>'   ,type : 'string', comboType: 'AU', comboCode: 'A020'} //수당지급여부 (추가)
					
					
					,{name: 'COMP_CODE'    	,text:'<t:message code="system.label.human.compcode" default="법인코드"/>' ,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode} 

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
                	   read :  hum100ukrService.certificateInfo,
                	   update: hum100ukrService.updateHUM600,
					   create: hum100ukrService.insertHUM600,
					   destroy:hum100ukrService.deleteHUM600,
					   syncAll:hum100ukrService.saveCertificateAll
                }
            }),
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect(config);					
				}else {
					var grid = certificateInfo.down('#hum100ukrs10Grid')
					if(grid) {
						grid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			}   
            
		});
		
var certificateInfo = {
			title:'<t:message code="system.label.human.qualcode" default="자격면허"/>',
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
	               		 	 { dataIndex: 'QUAL_KIND',  width: 200 }
	               		 	,{ dataIndex: 'QUAL_CODE',  width: 150 }
							,{ dataIndex: 'QUAL_GRADE',  width: 100 }
							,{ dataIndex: 'ACQ_DATE',  width: 100 }
							,{ dataIndex: 'VALI_DATE',  width: 100 }
							,{ dataIndex: 'RENEW_DATE',  width: 120 }
							,{ dataIndex: 'QUAL_MACH',  width: 200 }
							,{ dataIndex: 'QUAL_NUM',  width: 100 }							
							,{ dataIndex: 'ALWN_PAYN_YN',  width: 100 }   //수당지급여부 (추가)
					  ]
					  ,
		  				listeners: {
							beforeedit  : function( editor, e, eOpts ) {					
								if(!e.record.phantom){						
									if (UniUtils.indexOf(e.field, ['QUAL_KIND', 'ACQ_DATE'])){
										return false;
									}else{
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