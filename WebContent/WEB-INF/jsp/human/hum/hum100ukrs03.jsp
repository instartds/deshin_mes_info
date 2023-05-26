<%@page language="java" contentType="text/html; charset=utf-8"%>
	/**
	 * 가족사항
	 */
	Unilite.defineModel('hum100ukrs2Model', { 
	    fields: [
					 {name: 'NAME'    		   			,text:'<t:message code="system.label.human.name" default="성명"/>'		    ,type : 'string'} 
					,{name: 'PERSON_NUMB'     ,text:'<t:message code="system.label.human.personnumb" default="사번"/>'		    ,type : 'string', allowBlank:false } 
					,{name: 'FAMILY_NAME'      ,text:'<t:message code="system.label.human.familyname" default="가족성명"/>'	        ,type : 'string', allowBlank:false } 
					,{name: 'REL_CODE'    	   		,text:'<t:message code="system.label.human.relcode" default="관계"/>'	        ,type : 'string', allowBlank:false, comboType: 'AU', comboCode: 'H020' } 
					,{name: 'REPRE_NUM'    	  	 ,text:'<t:message code="system.label.human.socialsecuritynumberencryption" default="주민번호 암호화"/>'	,type : 'string' } 
					,{name: 'REPRE_NUM_EXPOS'  ,text:'<t:message code="system.label.human.reprenum" default="주민등록번호"/>'	        ,type : 'string', allowBlank:false/*, editable:false*/ }//,defaultValue:'**************', editable:false} 
					,{name: 'REPRE_NUMCHK'     ,text:'<t:message code="system.label.human.reprenum" default="주민등록번호"/>'	        ,type : 'int'} 
					,{name: 'TOGETHER_YN'      ,text:'<t:message code="system.label.human.togetheryn" default="동거여부"/>'	        ,type : 'string', comboType: 'AU', comboCode: 'A020', defaultValue:'Y'} 
					,{name: 'SCHSHIP_CODE'     ,text:'<t:message code="system.label.human.schshipcode" default="최종학력"/>'	        ,type : 'string', comboType: 'AU', comboCode: 'H009'} 
					,{name: 'GRADU_TYPE'       ,text:'<t:message code="system.label.human.gradutype" default="졸업구분"/>'	        ,type : 'string', comboType: 'AU', comboCode: 'H010'} 
					,{name: 'OCCUPATION'       ,text:'<t:message code="system.label.human.occupation" default="직업"/>'		    ,type : 'string'} 
					,{name: 'COMP_NAME'    	   ,text:'<t:message code="system.label.human.position" default="근무처"/>'		    ,type : 'string'} 
					,{name: 'POST_NAME'    	   ,text:'<t:message code="system.label.human.postcode" default="직위"/>'		    ,type : 'string'}

					,{name: 'YEAR_CALCU_YN'       ,text:'<t:message code="system.label.human.yearcalcuyn" default="연말정산여부"/>'		,type : 'string',comboType: 'AU', comboCode: 'A020', defaultValue:'Y'}
					,{name: 'FAMILY_AMOUNT_YN'    ,text:'<t:message code="system.label.human.familyamountyn" default="수당지급여부"/>'		,type : 'string',comboType: 'AU', comboCode: 'A020', defaultValue:'Y'}
					
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
            	   read : 'hum100ukrService.familyList',
            	   update: 'hum100ukrService.updateFamilyInfo',
				   create: 'hum100ukrService.insertFamilyInfo',
				   destroy:'hum100ukrService.deleteFamilyInfo',
				   syncAll:'hum100ukrService.savefamilyAll'
                }
            })
            ,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect(config);					
				}else {
					var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
					var grid = activeTab.down('#hum100ukrs2Grid')
					if(grid) {
						grid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			}
            
		});
	
	var familyInfo =	 {
		title:'<t:message code="system.label.human.familyinfo" default="가족사항"/>',
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
							,{ dataIndex: 'REPRE_NUM_EXPOS',  	width: 120}
							,{ dataIndex: 'REPRE_NUM',  	width: 120, hidden:true,
								editor:{
									listeners:{
								 		change: function(field, event, eOpt){
								 			var param = {'REPRE_NUM':field.getValue('REPRE_NUM')};
								 			hum100ukrService.chkFamilyRepreNum(param, function(provider, response) {
													if(provider.data['CNT'] != 0)	{
														if(!confirm('<t:message code="system.message.human.message020" default="중복된 주민번호가 존재합니다. 계속 진행하시겠습니까?"/>'+ '\n'))	{
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
							
							,{ dataIndex: 'YEAR_CALCU_YN',  	width: 110 } 
							,{ dataIndex: 'FAMILY_AMOUNT_YN',  	width: 110 } 
							
							
						  ],
						  listeners:{
	                            onGridDblClick:function(grid, record, cellIndex, colName) {   
	                            	if(colName == 'REPRE_NUM_EXPOS')	{	
										var params = {'INCRYP_WORD':record.get('REPRE_NUM')};
					                    Unilite.popupDecryptCom(params);
	                            	}
	                            },
                                beforeedit  : function( editor, e, eOpts ) {
                                	if(UniUtils.indexOf(e.field, ['REPRE_NUM'])){
                                        return false;
                                    }else{
                                    	if(UniUtils.indexOf(e.field, ['FAMILY_NAME','REL_CODE'])){
	                                    	if(e.record.phantom == true){
	                                    	   return true;
	                                	    }else{
	                                	       return false;	
	                                	    }
                                		}
	                                }
							  }
						  }
			}
        ]
        ,loadData:function(personNum)	{
					this.down('#hum100ukrs2Grid').getStore().load({params : {'PERSON_NUMB':personNum}});
		}
	};