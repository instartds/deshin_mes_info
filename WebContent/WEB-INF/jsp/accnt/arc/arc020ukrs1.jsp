<%@page language="java" contentType="text/html; charset=utf-8"%>

  var multiCompCodeArc020ukrs1Proxy;
    <c:if test="${multiCompCode == 'true'}">
   
     multiCompCodeArc020ukrs1Proxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'bsa101ukrvService.comp',
                create  : 'bsa101ukrvService.insertCodes',
                update  : 'bsa101ukrvService.updateCodes',
                destroy : 'bsa101ukrvService.deleteCodes',
                syncAll : 'bsa101ukrvService.saveAll'
            }
        });
    </c:if>

	 var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'bsa100ukrvService.comp',
				create 	: 'bsa100ukrvService.insertCodes',
				update 	: 'bsa100ukrvService.updateCodes',
				destroy	: 'bsa100ukrvService.deleteCodes',
				syncAll	: 'bsa100ukrvService.saveAll'
			}
	 });
	 
    var systemYNStore = Unilite.createStore('arc020ukrsYNStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'예'		, 'value':'1'},
			        {'text':'아니오'	, 'value':'2'}
	    		]
	});

	Unilite.defineModel('arc020ukrs_1Model', {
	    fields: [
					{name: 'MAIN_CODE'					,text:'메인코드'		,type : 'string' , allowBlank : false, readOnly:true},
					{name: 'SUB_CODE'					,text:'상세코드'		,type : 'string' , allowBlank : false, isPk:true,  pkGen:'user', readOnly:true},
					{name: 'CODE_NAME'					,text:'상세코드명'		,type : 'string' , allowBlank : false},
					{name: 'REF_CODE1'					,text:'거래처코드'		,type : 'string' , allowBlank : false},
					{name: 'CUSTOM_NAME'				,text:'거래처명'		,type : 'string' },					
					{name: 'USE_YN'						,text:'사용여부'		,type : 'string' , defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'},
					{name :'S_COMP_CODE'				,text:''			,type : 'string' , defaultValue: UserInfo.compCode	} 
			]               	
	});
	
	var arc020ukrs_1Store = Unilite.createStore('arc020ukrs_1Store',{
		model: 'arc020ukrs_1Model',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
//           proxy : directProxy,
       proxy: Ext.isEmpty(multiCompCodeArc020ukrs1Proxy) ?  directProxy:multiCompCodeArc020ukrs1Proxy,
       saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
        	
        	var rv = true;
        	
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect();
			}else {
				 panelDetail.down('#arc020ukrs_1Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords : function(){
			this.load();
		} 
	});

	var comp =	 {
			itemId: 'comp',
			layout: {type: 'vbox', align:'stretch'},
			items:[{	
				title:'회사별거래처코드',
				itemId: 'tab_comp',
				xtype: 'container',
		        		layout: {type: 'hbox', align:'stretch'},
		        		flex:1,
		     			autoScroll:false,
		        		items:[
			        	{	
			        		bodyCls: 'human-panel-form-background',
			        		xtype: 'uniGridPanel',
			        		itemId:'arc020ukrs_1Grid',
					        store : arc020ukrs_1Store, 
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
						  {dataIndex: 'SUB_CODE'			, width: 100,
						    editor: Unilite.popup('COMP_G',{
								autoPopup   : true ,
						    	listeners:{ 
										onSelected: {
					                    	fn: function(records, type  ){
					                    		var grdRecord = panelDetail.down('#arc020ukrs_1Grid').uniOpt.currentRecord;
												grdRecord.set('SUB_CODE',records[0]['COMP_CODE']);
												grdRecord.set('CODE_NAME',records[0]['COMP_NAME']);
					                    	},
				                    		scope: this
				          	   			},
										onClear : function(type)	{
					                  		var grdRecord = panelDetail.down('#arc020ukrs_1Grid').uniOpt.currentRecord;
											grdRecord.set('SUB_CODE','');
											grdRecord.set('CODE_NAME','');
					                  	}
									}
								})
				           },
						  {dataIndex: 'CODE_NAME'			, flex: 1	,
						  	editor: Unilite.popup('COMP_G',{
								autoPopup   : true ,
						    	listeners:{ 
										onSelected: {
					                    	fn: function(records, type  ){
					                    		var grdRecord = panelDetail.down('#arc020ukrs_1Grid').uniOpt.currentRecord;
												grdRecord.set('SUB_CODE',records[0]['COMP_CODE']);
												grdRecord.set('CODE_NAME',records[0]['COMP_NAME']);
					                    	},
				                    		scope: this
				          	   			},
										onClear : function(type)	{
					                  		var grdRecord = panelDetail.down('#arc020ukrs_1Grid').uniOpt.currentRecord;
											grdRecord.set('SUB_CODE','');
											grdRecord.set('CODE_NAME','');
					                  	}
									}
								})
				           },
						  {dataIndex: 'REF_CODE1'			, width: 120,
						  	editor: Unilite.popup('CUST_G',{
								autoPopup   : true ,
						    	listeners:{ 
										onSelected: {
					                    	fn: function(records, type  ){
					                    		var grdRecord = panelDetail.down('#arc020ukrs_1Grid').uniOpt.currentRecord;
												grdRecord.set('REF_CODE1',records[0]['CUSTOM_CODE']);
												grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
					                    	},
				                    		scope: this
				          	   			},
										onClear : function(type)	{
					                  		var grdRecord = panelDetail.down('#arc020ukrs_1Grid').uniOpt.currentRecord;
											grdRecord.set('REF_CODE1','');
											grdRecord.set('CUSTOM_NAME','');
					                  	}
									}
								})
				           },
						  {dataIndex: 'CUSTOM_NAME'			, width: 200,
						  editor: Unilite.popup('CUST_G',{
								autoPopup   : true ,
						    	listeners:{ 
										onSelected: {
					                    	fn: function(records, type  ){
					                    		var grdRecord = panelDetail.down('#arc020ukrs_1Grid').uniOpt.currentRecord;
												grdRecord.set('REF_CODE1',records[0]['CUSTOM_CODE']);
												grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
					                    	},
				                    		scope: this
				          	   			},
										onClear : function(type)	{
					                  		var grdRecord = panelDetail.down('#arc020ukrs_1Grid').uniOpt.currentRecord;
											grdRecord.set('REF_CODE1','');
											grdRecord.set('CUSTOM_NAME','');
					                  	}
									}
								})
				           },
						  {dataIndex: 'USE_YN'				, width: 100},				    
						  {dataIndex: 'S_COMP_CODE'			, width: 66, hidden: true}			    	  
				]
					,getSubCode: function()	{
					return this.subCode;
				}
			}]
		}]
	}