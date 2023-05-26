<%@page language="java" contentType="text/html; charset=utf-8"%>
/**
	 * 여권
	 */
	Unilite.defineModel('hum100ukrs15_1Model', {
	    fields: [
			 {name: 'PERSON_NUMB'  	,text:'<t:message code="unilite.msg.sMH9035" default="사원번호"/>'    	,type : 'string', allowBlank:false } 
			,{name: 'PASS_NO'    	,text:'<t:message code="unilite.msg.sMHT1037" default="여권번호"/>'   	,type : 'string', allowBlank:false } 
			,{name: 'PASS_KIND'    	,text:'<t:message code="unilite.msg.sMHT1038" default="여권구분"/>'   	,type : 'string', comboType: 'AU', comboCode: 'H088'} 
			,{name: 'NATION_NAME'  	,text:'<t:message code="unilite.msg.sMHT1465" default="발행국가"/>'   	,type : 'string'} 
			,{name: 'ISSUE_DATE'    ,text:'<t:message code="unilite.msg.sMHT1466" default="발급일"/>'     	,type : 'uniDate'} 
			,{name: 'TERMI_DATE'    ,text:'<t:message code="unilite.msg.sMHT0102" default="만료일"/>'     	,type : 'uniDate'} 
			,{name: 'COMP_CODE'    	,text:'법인코드'	,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode, editable:false} 
		]
	});
	var hum100ukrs15_1Store = Unilite.createStore('hum100ukrs15_1Store',{
			model: 'hum100ukrs15_1Model',
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
                	   read : hum100ukrService.passportInfo,
                	   create: hum100ukrService.insertHUM730,	
                	   update: hum100ukrService.updateHUM730,				   
				   	   destroy:hum100ukrService.deleteHUM730,
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
		
	/**
	 * 비자
	 */
	Unilite.defineModel('hum100ukrs15_2Model', {
	    fields: [
			 {name: 'PERSON_NUMB'   ,text:'<t:message code="unilite.msg.sMH9035" default="사원번호"/>'    	,type : 'string', allowBlank:false } 
			,{name: 'PASS_NO'    	,text:'<t:message code="unilite.msg.sMHT1037" default="여권번호"/>'   	,type : 'string', allowBlank:false } 
			,{name: 'VISA_NO'    	,text:'<t:message code="unilite.msg.sMHT0093" default="비자번호"/>'   	,type : 'string', allowBlank:false } 
			,{name: 'NATION_NAME'   ,text:'<t:message code="unilite.msg.sMHT0094" default="국가명"/>'     	,type : 'string'} 
			,{name: 'VISA_GUBUN'    ,text:'<t:message code="unilite.msg.sMHT1467" default="비자구분"/>'   	,type : 'string', comboType: 'AU', comboCode: 'H088'} 
			,{name: 'VISA_KIND'    	,text:'<t:message code="unilite.msg.sMHT1468" default="비자종류"/>'   	,type : 'string'} 
			,{name: 'VALI_DATE'    	,text:'<t:message code="unilite.msg.sMHT0095" default="유효일"/>'     	,type : 'uniDate'} 
			,{name: 'DURATION_STAY' ,text:'<t:message code="unilite.msg.sMHT1469" default="체류가능일"/>' 	,type : 'string'} 
			,{name: 'TERMI_DATE'    ,text:'<t:message code="unilite.msg.sMHT0102" default="만료일"/>'     	,type : 'uniDate'} 
			,{name: 'ISSUE_DATE'    ,text:'<t:message code="unilite.msg.sMHT1466" default="발급일"/>'     	,type : 'uniDate'} 
			,{name: 'ISSUE_AT'    	,text:'<t:message code="unilite.msg.sMHT1470" default="발급지"/>'     	,type : 'string'} 
			,{name: 'BIGO'    		,text:'<t:message code="unilite.msg.sMH1179" default="비고"/>'        	,type : 'string'} 
			,{name: 'COMP_CODE'    ,text:'법인코드'	,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode, editable:false} 
			]
	});
	var hum100ukrs15_2Store = Unilite.createStore('hum100ukrs15_2Store',{
			model: 'hum100ukrs15_2Model',
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
                	   read : hum100ukrService.visaInfo,
                	   create: hum100ukrService.insertHUM731,	
                	   update: hum100ukrService.updateHUM731,				   
				   	   destroy:hum100ukrService.deleteHUM731,
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
var visaInfoSelectedGrid = 'hum100ukrs15_1Grid';
var visaInfo = {
		title:'여권비자',
		itemId: 'visaInfo',
 			layout: {type: 'vbox', align:'stretch'},
	        items:[basicInfo,
	        	{	
	        		xtype: 'container',
	        		layout: {type: 'hbox', align:'stretch'},
	        		flex:1,
	     			autoScroll:false,
	        		items:[
		        	{	xtype: 'uniGridPanel',
						itemId:'hum100ukrs15_1Grid',
				        store : hum100ukrs15_1Store, 
				        padding: '0 10 0 9',
				        dockedItems: [{
					        xtype: 'toolbar',
					        dock: 'top',
					        padding:'0px',
					        border:0
					    }],
				        uniOpt:{	expandLastColumn: false,
				        			useRowNumberer: false,
				                    useMultipleSorting: false
				        },				        
				        columns:  [     
		               		 { dataIndex: 'PASS_NO',  width: 100 } 
							,{ dataIndex: 'PASS_KIND',  width: 80 } 
							,{ dataIndex: 'NATION_NAME',  width: 100 } 
							,{ dataIndex: 'ISSUE_DATE',  width: 80 } 
							,{ dataIndex: 'TERMI_DATE',  width: 80 } 						
						],
						listeners:{
							 render: function(grid, eOpts){
							 	var girdNm = grid.getItemId()
							    grid.getEl().on('click', function(e, t, eOpt) {
							    	visaInfoSelectedGrid = girdNm
							    });
							  
							}
						}
								  
					},
					{	xtype: 'uniGridPanel',
						itemId:'hum100ukrs15_2Grid',
				        store : hum100ukrs15_2Store, 
				        padding: '0 10 0 0',
				        uniOpt:{	expandLastColumn: false,
				        			useRowNumberer: false,
				                    useMultipleSorting: false
				        },
				        dockedItems: [{
					        xtype: 'toolbar',
					        dock: 'top',
					        padding:'0px',
					        border:0
					    }],
				        columns:  [     
							 { dataIndex: 'PASS_NO',  width: 90 } 
							,{ dataIndex: 'VISA_NO',  width: 110 } 
							,{ dataIndex: 'NATION_NAME',  width: 110 } 
							,{ dataIndex: 'VISA_GUBUN',  width: 80 } 
							,{ dataIndex: 'VISA_KIND',  width: 80 } 
							,{ dataIndex: 'VALI_DATE',  width: 80 } 
							,{ dataIndex: 'DURATION_STAY',  width: 80 } 
							,{ dataIndex: 'TERMI_DATE',  width: 80 } 
							,{ dataIndex: 'ISSUE_DATE',  width: 80 } 
							,{ dataIndex: 'ISSUE_AT',  width: 80 } 
							,{ dataIndex: 'BIGO', flex: 1} 
						],
						listeners:{
							 render: function(grid, eOpts){
							 	var girdNm = grid.getItemId()
							    grid.getEl().on('click', function(e, t, eOpt) {
							    	visaInfoSelectedGrid = girdNm
							    });
							 }
						}
					}
					]
	        	}
	        ]
	        ,loadData:function(personNum)	{
						this.down('#hum100ukrs15_1Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
						this.down('#hum100ukrs15_2Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
            
    	};