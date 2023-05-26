<%@page language="java" contentType="text/html; charset=utf-8"%>
  var multiCompCodeArc020ukrs4Proxy;
  <c:if test="${multiCompCode == 'true'}">
   
     multiCompCodeArc020ukrs4Proxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'bsa101ukrvService.Payments',
                create  : 'bsa101ukrvService.insertCodes',
                update  : 'bsa101ukrvService.updateCodes',
                destroy : 'bsa101ukrvService.deleteCodes',
                syncAll : 'bsa101ukrvService.saveAll'
            }
        });
    </c:if>

	 var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'bsa100ukrvService.Payments',
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

	Unilite.defineModel('arc020ukrs_4Model', {
	    fields: [
					{name: 'MAIN_CODE'					,text:'메인코드'		,type : 'string' , allowBlank : false, readOnly:true},
					{name: 'SUB_CODE'					,text:'상세코드'		,type : 'string' , allowBlank : false, isPk:true,  pkGen:'user', readOnly:true},
					{name: 'CODE_NAME'					,text:'상세코드명'		,type : 'string' , allowBlank : false},
					{name: 'REF_CODE1'					,text:'관리수금구분'	,type : 'string' , allowBlank : false , comboType:'AU', comboCode:'J508'},
					{name: 'REF_CODE2'					,text:'수금관리항목'	,type : 'string' , comboType:'AU', comboCode:'J505'},
					{name: 'USE_YN'						,text:'사용여부'		,type : 'string' , defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'},
					{name :'S_COMP_CODE'				,text:''			,type : 'string' , defaultValue: UserInfo.compCode	} 
			]               	
	});
	
	var arc020ukrs_4Store = Unilite.createStore('arc020ukrs_4Store',{
			model: 'arc020ukrs_4Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
           proxy: Ext.isEmpty(multiCompCodeArc020ukrs4Proxy) ?  directProxy:multiCompCodeArc020ukrs4Proxy,
            saveStore : function()	{	
				var inValidRecs = this.getInvalidRecords();
            	
            	var rv = true;
            	
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();
				}else {
					 panelDetail.down('#arc020ukrs_4Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			loadStoreRecords : function(){
				this.load();
			} 
		});

	var payments =	 {
			itemId: 'payments',
			layout: {type: 'vbox', align:'stretch'},
			items:[{	
				title:'관리/수금구분',
				itemId: 'tab_payments',
				xtype: 'container',
		        		layout: {type: 'hbox', align:'stretch'},
		        		flex:1,
		     			autoScroll:false,
		        		items:[
			        	{	
			        		bodyCls: 'human-panel-form-background',
			        		xtype: 'uniGridPanel',
			        		itemId:'arc020ukrs_4Grid',
					        store : arc020ukrs_4Store, 
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
						  {dataIndex: 'REF_CODE1'			, width: 100},
						  {dataIndex: 'REF_CODE2'			, width: 100},
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