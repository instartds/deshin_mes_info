<%@page language="java" contentType="text/html; charset=utf-8"%>
Unilite.defineModel('hum100ukrs11Model', {
	    fields: [
					 {name: 'PERSON_NUMB'    	,text:'<t:message code="unilite.msg.sMHT0005" default="사번"/>'       	,type : 'int', allowBlank:false } 
					,{name: 'ANNOUNCE_DATE'   ,text:'<t:message code="unilite.msg.sMHT0024" default="발령일자"/>'   	,type : 'uniDate', allowBlank:false } 
					,{name: 'ANNOUNCE_CODE'   ,text:'<t:message code="unilite.msg.sMHT0025" default="발령코드"/>'   	,type : 'string', allowBlank:false , comboType: 'AU', comboCode: 'H094'} 
					,{name: 'BE_DIV_NAME'    	,text:'<t:message code="unilite.msg.sMHT0026" default="발령전"/>'     	,type : 'string', comboType: 'BOR120'} 
					,{name: 'AF_DIV_NAME'    	,text:'<t:message code="unilite.msg.sMHT0027" default="발령후"/> ' 		,type : 'string', allowBlank:false , comboType: 'BOR120'} 
					,{name: 'BE_DEPT_NAME'    ,text:'<t:message code="unilite.msg.sMHT0026" default="발령전"/>'     	,type : 'string'} 
					,{name: 'AF_DEPT_NAME'    ,text:'<t:message code="unilite.msg.sMHT0027" default="발령후"/>'     	,type : 'string', allowBlank:false } 
					,{name: 'POST_CODE'    		,text:'<t:message code="unilite.msg.sMHT0003" default="직위"/>'       	,type : 'string', allowBlank:false , comboType: 'AU', comboCode: 'H005'} 
					,{name: 'ABIL_CODE'    		,text:'<t:message code="unilite.msg.sMHT0028" default="직책"/>'       	,type : 'string' , comboType: 'AU', comboCode: 'H006'} 
					,{name: 'PAY_GRADE_01'    ,text:'<t:message code="unilite.msg.sMHT1105" default="급호"/>' 			,type : 'string'} 
					,{name: 'PAY_GRADE_02'    ,text:'<t:message code="unilite.msg.sMHF160" default="호봉"/>'        	,type : 'string'} 
					,{name: 'ANNOUNCE_REASON' ,text:'<t:message code="unilite.msg.sMHT0029" default="발령사유"/>'   	,type : 'string'} 
					,{name: 'DEPT_NAME'    		,text:'<t:message code="unilite.msg.sMHT0002" default="부서"/> ' 		,type : 'string'} 
					,{name: 'DIV_CODE'    		,text:'<t:message code="unilite.msg.sMHT0001" default="사업장"/>'     	,type : 'string'} 
					,{name: 'DEPT_CODE'    		,text:'<t:message code="unilite.msg.sMHT0136" default="부서코드"/>'   	,type : 'string'} 
					,{name: 'BE_DEPT_CODE'    ,text:'<t:message code="unilite.msg.sMHT0026" default="발령전"/>'     	,type : 'string'} 
					,{name: 'AF_DEPT_CODE'    ,text:'<t:message code="unilite.msg.sMHT0027" default="발령후"/>'     	,type : 'string'}  
					,{name: 'COMP_CODE'    	,text:'법인코드' ,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode} 

			]
	}); 
	var hum100ukrs11Store = Unilite.createStore('hum100ukrs11Store',{
			model: 'hum100ukrs11Model',
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
                	   read :  s_hum100ukrService_KOCIS.hrChanges,
                	   update: s_hum100ukrService_KOCIS.updateHUM760,
					   create: s_hum100ukrService_KOCIS.insertHUM760,
					   destroy:s_hum100ukrService_KOCIS.deleteHUM760,
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
var hrChanges =	{
			title:'인사변동',
			itemId: 'hrChanges',
			layout:{type:'vbox', align:'stretch'},			
        	items:[
        			basicInfo,
					{	xtype: 'uniGridPanel',
						itemId:'hum100ukrs11Grid',				
						dockedItems: [{
					        xtype: 'toolbar',
					        dock: 'top',
					        padding:'0px',
					        border:0
					    }],
						bodyCls: 'human-panel-form-background',
				        store : hum100ukrs11Store, 
				        padding: '0 10 0 10',
				        uniOpt:{	expandLastColumn: false,
				        			useRowNumberer: true,
				                    useMultipleSorting: false
				        },
				        columns:  [     
				               		 	 { dataIndex: 'ANNOUNCE_DATE',  width:	100 } 
								  		,{ dataIndex: 'ANNOUNCE_CODE',  width:	100 } 
								  		,{ text: '<t:message code="unilite.msg.sMHT0001" default="사업장"/> ',
                						   columns:[ 
                								 { dataIndex: 'BE_DIV_NAME',  width:	100 },
								  				{ dataIndex: 'AF_DIV_NAME',  width:	100 }
								  			]
								  		 }								  		  
								  		 ,{ text: '<t:message code="unilite.msg.sMHT0137" default="부서명"/> ',
                						   columns:[
									    		{ dataIndex: 'BE_DEPT_NAME',  width:	120 ,
									    		  'editor': Unilite.popup('DEPT_G',{
							                    	  	 	textFieldName : 'BE_DEPT_NAME',
							                    	  	 	listeners: { 'onSelected': {
											                    fn: function(records, type  ){
											                    	var grdRecord = panelDetail.down('#hum100ukrs11Grid').uniOpt.currentRecord;
						                    						grdRecord.set('BE_DEPT_CODE',records[0]['TREE_CODE']);
						                    						grdRecord.set('BE_DEPT_NAME',records[0]['TREE_NAME']);
											                    },
											                    scope: this
											                  },
											                  'onClear' : function(type)	{
											                    	var grdRecord = panelDetail.down('#hum100ukrs11Grid').uniOpt.currentRecord;
						                    						grdRecord.set('BE_DEPT_CODE','');
						                    						grdRecord.set('BE_DEPT_NAME','');
											                  }
							                    	  	 	}
														})	
									    		},
									    		{ dataIndex: 'AF_DEPT_NAME',  width:	120,
									    		  'editor': Unilite.popup('DEPT_G',{
							                    	  	 	textFieldName : 'AF_DEPT_NAME',
							                    	  	 	listeners: { 'onSelected': {
											                    fn: function(records, type  ){
											                    	var grdRecord = panelDetail.down('#hum100ukrs11Grid').uniOpt.currentRecord;
						                    						grdRecord.set('AF_DEPT_CODE',records[0]['TREE_CODE']);
						                    						grdRecord.set('AF_DEPT_NAME',records[0]['TREE_NAME']);
											                    },
											                    scope: this
											                  },
											                  'onClear' : function(type)	{
											                    	var grdRecord = panelDetail.down('#hum100ukrs11Grid').uniOpt.currentRecord;
						                    						grdRecord.set('AF_DEPT_CODE','');
						                    						grdRecord.set('AF_DEPT_NAME','');
											                  }
							                    	  	 	}
														})
									    		}
									    	]
								  		 }
									    ,{ dataIndex: 'POST_CODE',  width:	120	 } 
									    ,{ dataIndex: 'ABIL_CODE',  width:	120	 } 
									    ,{ dataIndex: 'PAY_GRADE_01',  width:	80	 } 
									    ,{ dataIndex: 'PAY_GRADE_02',  width:	80		 } 
									    ,{ dataIndex: 'ANNOUNCE_REASON',  flex:1	} 
									    ,{ dataIndex: 'PERSON_NUMB',  hidden:true	} 
								  ]
					}
			],
			loadData:function(personNum)	{
					this.down('#hum100ukrs11Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
			
		};
	