<%@page language="java" contentType="text/html; charset=utf-8"%>
	Unilite.defineModel('hum100ukrs12Model', {
		fields: [
			 {name: 'PERSON_NUMB'    		,text:'<t:message code="unilite.msg.sMHT0005" default="사번"/>'     	,type : 'int', allowBlank:false , isPk:true, pkGen:'user'} 
			,{name: 'MERITS_YEARS'    		,text:'<t:message code="unilite.msg.sMHT1051" default="고과년도"/>' 	,type : 'string', allowBlank:false , isPk:true, pkGen:'user', maxLength: 4 } 
			,{name: 'MERITS_GUBUN'    		,text:'<t:message code="unilite.msg.sMHT0031" default="고과구분"/>' 	,type : 'string', allowBlank:false , comboType: 'AU', comboCode: 'H095', isPk:true, pkGen:'user'} 
			,{name: 'DEPT_NAME'    			,text:'<t:message code="unilite.msg.sMHT0032" default="근무부서"/>' 	,type : 'string'} 
			,{name: 'MERITS_CLASS'    		,text:'<t:message code="unilite.msg.sMHT1052" default="고과등급"/>' 	,type : 'string'} 
			,{name: 'MERITS_GRADE'    		,text:'<t:message code="unilite.msg.sMHT1053" default="고과점수"/>' 	,type : 'int', allowBlank:false ,maxLength:6} 
			,{name: 'GRADE_PERSON_NAME'   	,text:'<t:message code="unilite.msg.sMHT1054" default="평가자"/>'   	,type : 'string'} 
			,{name: 'GRADE_PERSON_NUMB'   	,text:'<t:message code="unilite.msg.sMHT1054" default="평가자"/>'   	,type : 'string', allowBlank:false } 
			,{name: 'GRADE_PERSON_NAME2'  	,text:'<t:message code="unilite.msg.sMHT1054" default="평가자"/>2'   	,type : 'string'} 
			,{name: 'GRADE_PERSON_NUMB2'  	,text:'<t:message code="unilite.msg.sMHT1054" default="평가자"/>2'   	,type : 'string'} 
			,{name: 'SYNTHETIC_EVAL'    	,text:'<t:message code="unilite.msg.sMHT0035" default="종합평가"/>' 	,type : 'string'}  
			,{name: 'COMP_CODE'    			,text:'법인코드' ,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode} 
		]
	});
	var hum100ukrs12Store = Unilite.createStore('hum100ukrs12Store',{
			model: 'hum100ukrs12Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용. 
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read :  hum100ukrService.personalRating,
                	   update: hum100ukrService.updateHUM770,
					   create: hum100ukrService.insertHUM770,
					   destroy:hum100ukrService.deleteHUM770,
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

var personalRating = {
			title:'고과사항',
			itemId: 'personalRating',
			layout: {
				type:'vbox', 
				align:'stretch'
			},			
        	items: [
        		basicInfo,
				{	
					xtype: 'uniGridPanel',
					itemId:'hum100ukrs12Grid',				
					dockedItems: [{
				        xtype: 'toolbar',
				        dock: 'top',
				        padding:'0px',
				        border:0
				    }],
					bodyCls: 'human-panel-form-background',
			        store : hum100ukrs12Store, 
			        padding: '0 10 0 10',
			        uniOpt:{	
			        	expandLastColumn: false,
	        			useRowNumberer: true,
	                    useMultipleSorting: false
			        },
			        columns:  [     
						 { dataIndex: 'MERITS_YEARS',  width:	150 ,
						   editor: {
						   		xtype: 'uniYearField', forceSelection:true
						   } 
						 } 
				  		,{ dataIndex: 'MERITS_GUBUN',  width:	150 } 
				  		,{ dataIndex: 'DEPT_NAME',  width:	150,
				  		   'editor': Unilite.popup('DEPT_G',{
							                    	  	 	textFieldName : 'DEPT_NAME',
			  												autoPopup: true,
							                    	  	 	listeners: { 'onSelected': {
											                    fn: function(records, type  ){
											                    	var grdRecord = panelDetail.down('#hum100ukrs12Grid').uniOpt.currentRecord;
						                    						grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
											                    },
											                    scope: this
											                  },
											                  'onClear' : function(type)	{
											                    	var grdRecord = panelDetail.down('#hum100ukrs12Grid').uniOpt.currentRecord;
						                    						grdRecord.set('DEPT_NAME','');
											                  }
							                    	  	 	}
														})
				  		 } 
				  		,{ dataIndex: 'MERITS_CLASS',  width:	110 } 
				  		,{ dataIndex: 'MERITS_GRADE',  width:	110 } 
					    ,{ dataIndex: 'GRADE_PERSON_NAME',  width:	110,
					       'editor': Unilite.popup('Employee_G',{
							                    	  	 	textFieldName : 'GRADE_PERSON_NAME',
			  												autoPopup: true,
							                    	  	 	listeners: { 'onSelected': {
											                    fn: function(records, type  ){
											                    	var grdRecord = panelDetail.down('#hum100ukrs12Grid').uniOpt.currentRecord;
						                    						grdRecord.set('GRADE_PERSON_NUMB',records[0]['PERSON_NUMB']);
						                    						grdRecord.set('GRADE_PERSON_NAME',records[0]['NAME']);
											                    },
											                    scope: this
											                  },
											                  'onClear' : function(type)	{
											                    	var grdRecord = panelDetail.down('#hum100ukrs12Grid').uniOpt.currentRecord;
						                    						grdRecord.set('GRADE_PERSON_NUMB','');
						                    						grdRecord.set('GRADE_PERSON_NAME','');
											                  }
							                    	  	 	}
														})
									    		
					     
					     } 
					    ,{ dataIndex: 'GRADE_PERSON_NAME2',  width:	110,
					       'editor': Unilite.popup('Employee_G',{
							                    	  	 	textFieldName : 'GRADE_PERSON_NAME2',
			  												autoPopup: true,
							                    	  	 	listeners: { 'onSelected': {
											                    fn: function(records, type  ){
											                    	var grdRecord = panelDetail.down('#hum100ukrs12Grid').uniOpt.currentRecord;
						                    						grdRecord.set('GRADE_PERSON_NUMB2',records[0]['PERSON_NUMB']);
						                    						grdRecord.set('GRADE_PERSON_NAME2',records[0]['NAME']);
											                    },
											                    scope: this
											                  },
											                  'onClear' : function(type)	{
											                    	var grdRecord = panelDetail.down('#hum100ukrs12Grid').uniOpt.currentRecord;
						                    						grdRecord.set('GRADE_PERSON_NUMB2','');
						                    						grdRecord.set('GRADE_PERSON_NAME2','');
											                  }
							                    	  	 	}
														})
									    		
					     } 
					    ,{ dataIndex: 'SYNTHETIC_EVAL', flex:1	 }					    
					]
				}
			],
			loadData:function(personNum)	{
					this.down('#hum100ukrs12Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
			}
			
		};
	