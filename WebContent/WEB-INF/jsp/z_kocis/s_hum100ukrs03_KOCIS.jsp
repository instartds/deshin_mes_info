<%@page language="java" contentType="text/html; charset=utf-8"%>
	/**
	 * 가족사항
	 */
	Unilite.defineModel('hum100ukrs2Model', { 
	    fields: [
					 {name: 'NAME'    		,text:'성명'		,type : 'string'} 
					,{name: 'PERSON_NUMB'   ,text:'사번'		,type : 'string', allowBlank:false } 
					,{name: 'FAMILY_NAME'   ,text:'가족성명'	,type : 'string', allowBlank:false } 
					,{name: 'REL_CODE'    	,text:'관계'	,type : 'string', allowBlank:false, comboType: 'AU', comboCode: 'H020' } 
					,{name: 'REPRE_NUM'    	,text:'주민번호'	,type : 'string'} 
					,{name: 'REPRE_NUMCHK'  ,text:'주민번호'	,type : 'int'} 
					,{name: 'TOGETHER_YN'   ,text:'동거여부'	,type : 'string', comboType: 'AU', comboCode: 'A020', defaultValue:'Y'} 
					,{name: 'SCHSHIP_CODE'  ,text:'최종학력'	,type : 'string', comboType: 'AU', comboCode: 'H009'} 
					,{name: 'GRADU_TYPE'    ,text:'졸업구분'	,type : 'string', comboType: 'AU', comboCode: 'H010'} 
					,{name: 'OCCUPATION'    ,text:'직업'		,type : 'string'} 
					,{name: 'COMP_NAME'    	,text:'근무처'		,type : 'string'} 
					,{name: 'POST_NAME'    	,text:'직위'		,type : 'string'} 	
					,{name: 'COMP_CODE'    ,text:'COMP_CODE'	,type : 'string', allowBlank:false , defaultValue:UserInfo.compCode}
			]
	});
	var hum100ukrs2Store = Unilite.createStore('hum100ukrs2Store',{
			model: 'hum100ukrs2Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy:  Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
                api: {
            	   read : 's_hum100ukrService_KOCIS.familyList',
            	   update: 's_hum100ukrService_KOCIS.updateFamilyInfo',
				   create: 's_hum100ukrService_KOCIS.insertFamilyInfo',
				   destroy:'s_hum100ukrService_KOCIS.deleteFamilyInfo',
				   syncAll:'s_hum100ukrService_KOCIS.savefamilyAll'
                }
            })
            ,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect(config);					
				}else {
					alert(Msg.sMB083);
				}
			}
            
		});
	
	var familyInfo =	 {
		title:'가족사항',
		itemId: 'familyInfo',
        
		layout: {type: 'vbox', align:'stretch'},
        items:[basicInfo,
        	{	xtype: 'uniGridPanel',
				itemId:'hum100ukrs2Grid',				
				dockedItems: [{
			        xtype: 'toolbar',
			        dock: 'top',
			        padding:'0px',
			        border:0
			    }],
		        store : hum100ukrs2Store, 
		        padding: '0 10 0 10',
		        uniOpt:{	expandLastColumn: true,
		        			useRowNumberer: true,
		                    useMultipleSorting: false,
		                    userToolbar : false
		        },
		        columns:  [  { dataIndex: 'FAMILY_NAME', 	width: 90 } 
							,{ dataIndex: 'REL_CODE',  		width: 90 } 
							,{ dataIndex: 'REPRE_NUM',  	width: 120, 
								editor:{
									listeners:{
								 		blur: function(field, event, eOpt){
								 												 			
								 			var formPanel = this.up('#personalInfo');
								 			var v = field.getValue();
								 			var param={'REPRE_NUM' : v};
								 			if(Unilite.validate('residentno', v) !== true)  {
								 				if(!confirm('잘못된 주민번호를 입력하셨습니다. 잘못된 주민번호를 저장하시겠습니까? 주민번호:'+v))	{
								 					field.setValue('');
								 					return;
								 				}
								 			}
								 			s_hum100ukrService_KOCIS.chkFamilyRepreNum(param, function(provider, response) {
													if(provider.data['CNT'] != 0)	{
														if(!confirm('중복된 주민번호가 존재합니다. 계속 진행하시겠습니까? '+ '\n' +'주민번호:'+v))	{
															field.setValue('');
														}
													}
											});
							 			}						 			
								 		
								 	}
								}
							} 
							,{ dataIndex: 'TOGETHER_YN',  	width: 80 } 
							,{ dataIndex: 'SCHSHIP_CODE',  	width: 90 } 
							,{ dataIndex: 'GRADU_TYPE',  	width: 110 } 
							,{ dataIndex: 'OCCUPATION',  	width: 150 } 
							,{ dataIndex: 'COMP_NAME',  	width: 80 } 
							,{ dataIndex: 'POST_NAME',  	width: 80 } 
							
						  ]
			}
        ]
        ,loadData:function(personNum)	{
					this.down('#hum100ukrs2Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
		}
	};