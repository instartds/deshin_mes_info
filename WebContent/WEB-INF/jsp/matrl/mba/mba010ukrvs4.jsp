<%@page language="java" contentType="text/html; charset=utf-8"%>


	 var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'bsa100ukrvService.selectDetailInout',
				create 	: 'bsa100ukrvService.insertCodes',
				update 	: 'bsa100ukrvService.updateCodes',
				destroy	: 'bsa100ukrvService.deleteCodes',
				syncAll	: 'bsa100ukrvService.saveAll'
			}
	 });
	 
	 var systemYNStore = Unilite.createStore('mba010ukrvs4YNStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'<t:message code="system.label.purchase.yes" default="예"/>'		, 'value':'1'},
			        {'text':'<t:message code="system.label.purchase.no" default="아니오"/>'	, 'value':'2'}
	    		]
	});

	Unilite.defineModel('mba010ukrvs_4Model', {
	    fields: [
					{name: 'MAIN_CODE'					,text:'<t:message code="system.label.purchase.maincode" default="메인코드"/>'		,type : 'string' , allowBlank : false, readOnly:true},
					{name: 'SUB_CODE'					,text:'<t:message code="system.label.purchase.subcode" default="상세코드"/>'		,type : 'string' , allowBlank : false, isPk:true,  pkGen:'user', readOnly:true},
					{name: 'CODE_NAME'					,text:'<t:message code="system.label.purchase.subcodename" default="상세코드명"/>'		,type : 'string' , allowBlank : false},
					{name: 'CODE_NAME_EN'				,text:'<t:message code="system.label.purchase.subcodenameen" default="상세코드명(영어)"/>'	,type : 'string'},
					{name: 'CODE_NAME_CN'				,text:'<t:message code="system.label.purchase.subcodenamecn" default="상세코드명(중국어)"/>'	,type : 'string'},
					{name: 'CODE_NAME_JP'				,text:'<t:message code="system.label.purchase.subcodenamejp" default="상세코드명(일본어)"/>'	,type : 'string'},
					{name: 'REF_CODE1'					,text:'<t:message code="system.label.purchase.division" default="사업장"/>'		,type : 'string' , allowBlank : false , comboType:'BOR120'},
					{name: 'REF_CODE2'					,text:'<t:message code="system.label.purchase.departmencode" default="부서코드"/>'		,type : 'string' },
					{name: 'DEPT_NAME'					,text:'<t:message code="system.label.purchase.department" default="부서"/>'			,type : 'string' , allowBlank : false},
					{name: 'REF_CODE3'					,text:'<t:message code="system.label.purchase.applyys" default="적용여부"/>'		,type : 'string'},
					{name: 'REF_CODE4'					,text:'<t:message code="system.label.purchase.approvaluser" default="승인자"/>'		,type : 'string'},  // ID
					{name: 'USER_NAME'					,text:'<t:message code="system.label.purchase.approvalusername" default="승인자명"/>'		,type : 'string'},
					{name: 'REF_CODE5'					,text:'<t:message code="system.label.purchase.refcode5" default="참조코드5"/>'			,type : 'string'},
					{name: 'USER_NAME2'					,text:'<t:message code="system.label.purchase.connectusername" default="접속자명"/>'		,type : 'string'},
					{name: 'REF_CODE6'					,text:'<t:message code="system.label.purchase.refcode6" default="참조코드6"/>'			,type : 'string'},
					{name: 'REF_CODE7'					,text:'<t:message code="system.label.purchase.refcode7" default="참조코드7"/>'			,type : 'string'},
					{name: 'REF_CODE8'					,text:'<t:message code="system.label.purchase.refcode8" default="참조코드8"/>'			,type : 'string'},
					{name: 'REF_CODE9'					,text:'<t:message code="system.label.purchase.refcode9" default="참조코드9"/>'			,type : 'string'},
					{name: 'REF_CODE10'					,text:'<t:message code="system.label.purchase.connectuserid" default="접속자ID"/>'		,type : 'string'},  // ID
					{name: 'SUB_LENGTH'					,text:''			,type : 'int'},
					{name: 'USE_YN'						,text:'<t:message code="system.label.purchase.useyn" default="사용여부"/>'		,type : 'string' , defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'},
					{name: 'SORT_SEQ'					,text:'<t:message code="system.label.purchase.arrangeorder" default="정렬순서"/>'		,type : 'int'	 , defaultValue:1	, allowBlank : false},
					{name: 'SYSTEM_CODE_YN'				,text:'<t:message code="system.label.purchase.system" default="시스템"/>'		,type : 'string' 	 ,store: Ext.data.StoreManager.lookup('mba010ukrvs4YNStore') , defaultValue:'2'},
					{name: 'UPDATE_DB_USER'				,text:''			,type : 'string'},
					{name: 'UPDATE_DB_TIME'				,text:''			,type : 'string'},
					{name :'S_COMP_CODE'				,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		,type : 'string' , defaultValue: UserInfo.compCode	} 
			]               	
	});
	
	var mba010ukrvs_4Store = Unilite.createStore('mba010ukrvs_4Store',{
			model: 'mba010ukrvs_4Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
           proxy : directProxy,
            /*proxy: {
                type: 'direct',
                api: {
                	    read :  bsa100ukrvService.selectDetailSales,
            	   		update: bsa100ukrvService.updateCodes,
				   		create: bsa100ukrvService.insertCodes,
				   		destroy:bsa100ukrvService.deleteCodes,
				   		syncAll:bsa100ukrvService.saveAll
                }
            },*/
            saveStore : function()	{	
				var inValidRecs = this.getInvalidRecords();
            	
            	var rv = true;
            	
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();
				}else {
					 panelDetail.down('#mba010ukrvs_4Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			loadStoreRecords : function(){
				this.load();
			} 
		});

	var inout =	 {
			//수불담당',
			itemId: 'inout',
			layout: {type: 'vbox', align:'stretch'},
			items:[{	
				title:'<t:message code="system.label.purchase.trancharge" default="수불담당"/>',
				itemId: 'tab_inout',
				xtype: 'container',
		        		layout: {type: 'hbox', align:'stretch'},
		        		flex:1,
		     			autoScroll:false,
		        		items:[
			        	{	
			        		bodyCls: 'human-panel-form-background',
			        		xtype: 'uniGridPanel',
			        		itemId:'mba010ukrvs_4Grid',
					        store : mba010ukrvs_4Store, 
					        padding: '0 0 0 0',
					        dockedItems: [{
						        xtype: 'toolbar',
						        dock: 'top',
						        padding:'0px',
						        border:0
						    }],
					        uniOpt:{	expandLastColumn: false,
					        			useRowNumberer: true,
					                    useMultipleSorting: false
					        },	        
				columns: [{dataIndex: 'MAIN_CODE'			, width: 100, hidden: true},
						  {dataIndex: 'SUB_CODE'			, width: 100},
						  {dataIndex: 'CODE_NAME'			, flex: 1	},
						  {dataIndex: 'CODE_NAME_EN'		, width: 133, hidden: true},
						  {dataIndex: 'CODE_NAME_CN'		, width: 133, hidden: true},
						  {dataIndex: 'CODE_NAME_JP'		, width: 133, hidden: true},
						  {dataIndex: 'SYSTEM_CODE_YN'		, width: 100},
						  {dataIndex: 'REF_CODE1'			, width: 100},
						  {dataIndex: 'REF_CODE2'			, width: 100 , hidden: true},
						  {dataIndex: 'REF_CODE3'			, width: 100, hidden: true},
						  {dataIndex: 'DEPT_NAME'			, width: 200 ,
						  'editor': Unilite.popup('DEPT_G',{
	                    	  	 	textFieldName : 'DEPT_NAME',
		                    	  	autoPopup: true,
	                    	  	 	listeners: { 'onSelected': {
					                    fn: function(records, type  ){
					                    	var grdRecord = panelDetail.down('#mba010ukrvs_4Grid').uniOpt.currentRecord;
                    						grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                    						grdRecord.set('REF_CODE2',records[0]['TREE_CODE']);
                    						
					                    },
					                    scope: this
					                  },
					                  'onClear' : function(type)	{
					                    	var grdRecord = panelDetail.down('#mba010ukrvs_4Grid').uniOpt.currentRecord;
                    						grdRecord.set('DEPT_NAME','');
                    						grdRecord.set('REF_CODE2','');
					                  }
	                    	  	 	}
								})
				  		 },
						  {dataIndex: 'REF_CODE4'			, width: 100, hidden: true},
						  // 승인자 명 //
						  {dataIndex: 'USER_NAME'			, width: 100 ,
						  'editor': Unilite.popup('USER_G',{
				                    	  	 	textFieldName : 'USER_NAME',
		                    	 		 	 	autoPopup: true,
				                    	  	 	listeners: { 'onSelected': {
								                    fn: function(records, type  ){
								                    	var grdRecord = panelDetail.down('#mba010ukrvs_4Grid').uniOpt.currentRecord;
			                    						grdRecord.set('USER_NAME',records[0]['USER_NAME']);
			                    						grdRecord.set('REF_CODE4',records[0]['USER_ID']);
								                    },
								                    scope: this
								                  },
								                  'onClear' : function(type)	{
								                    	var grdRecord = panelDetail.down('#mba010ukrvs_4Grid').uniOpt.currentRecord;
			                    						grdRecord.set('USER_NAME','');
			                    						grdRecord.set('REF_CODE4','');
								                  }
				                    	  	 	}
											})
				  		 },  
				  		 // 사용자 ID //
				  		  {dataIndex: 'REF_CODE5'			, width: 100, hidden: true},
						  {dataIndex: 'REF_CODE6'			, width: 100, hidden: true},
						  {dataIndex: 'REF_CODE7'			, width: 133, hidden: true},
						  {dataIndex: 'REF_CODE8'			, width: 100, hidden: true},
						  {dataIndex: 'REF_CODE9'			, width: 100, hidden: true},
						  {dataIndex: 'REF_CODE10'			, width: 100 ,
						  'editor': Unilite.popup('USER_G',{
				                    	  	 	textFieldName : 'USER_NAME',
		                    	  	 			autoPopup: true,
				                    	  	 	listeners: { 'onSelected': {
								                    fn: function(records, type  ){
								                    	var grdRecord = panelDetail.down('#mba010ukrvs_4Grid').uniOpt.currentRecord;
			                    						grdRecord.set('USER_NAME2',records[0]['USER_NAME']);
			                    						grdRecord.set('REF_CODE10',records[0]['USER_ID']);
								                    },
								                    scope: this
								                  },
								                  'onClear' : function(type)	{
								                    	var grdRecord = panelDetail.down('#mba010ukrvs_4Grid').uniOpt.currentRecord;
			                    						grdRecord.set('USER_NAME2','');
			                    						grdRecord.set('REF_CODE10','');
								                  }
				                    	  	 	}
											})
				  		 }, 	  
				  		 // 접속자 명 //
						  {dataIndex: 'USER_NAME2'			, width: 100 ,
						  'editor': Unilite.popup('USER_G',{
				                    	  	 	textFieldName : 'USER_NAME',
		                    	  	 			autoPopup: true,
				                    	  	 	listeners: { 'onSelected': {
								                    fn: function(records, type  ){
								                    	var grdRecord = panelDetail.down('#mba010ukrvs_4Grid').uniOpt.currentRecord;
			                    						grdRecord.set('USER_NAME2',records[0]['USER_NAME']);
			                    						grdRecord.set('REF_CODE10',records[0]['USER_ID']);
								                    },
								                    scope: this
								                  },
								                  'onClear' : function(type)	{
								                    	var grdRecord = panelDetail.down('#mba010ukrvs_4Grid').uniOpt.currentRecord;
			                    						grdRecord.set('USER_NAME2','');
			                    						grdRecord.set('REF_CODE10','');
								                  }
				                    	  	 	}
											})
				  		 }, 	 
						  {dataIndex: 'SUB_LENGTH'			, width: 66, hidden: true},  
						  {dataIndex: 'USE_YN'				, width: 100},				    
						  {dataIndex: 'SORT_SEQ'			, width: 66, hidden: true},					    			    
						  {dataIndex: 'UPDATE_DB_USER'		, width: 66, hidden: true},					    
						  {dataIndex: 'UPDATE_DB_TIME'		, width: 66, hidden: true},					    
						  {dataIndex: 'S_COMP_CODE'			, width: 66, hidden: true}			    	  
				]
					,getSubCode: function()	{
					return this.subCode;
				}
			}]
		}]
	}