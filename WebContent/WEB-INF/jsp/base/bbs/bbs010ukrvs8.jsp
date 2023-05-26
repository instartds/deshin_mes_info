<%@page language="java" contentType="text/html; charset=utf-8"%>
  var multiCompCodeBbs010ukrs8Proxy;
    <c:if test="${multiCompCode == 'true'}">
   
     multiCompCodeBbs010ukrs8Proxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'bsa101ukrvService.selectDetailCard',
                create  : 'bsa101ukrvService.insertCodes',
                update  : 'bsa101ukrvService.updateCodes',
                destroy : 'bsa101ukrvService.deleteCodes',
                syncAll : 'bsa101ukrvService.saveAll'
            }
        });
    </c:if>

	 var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'bsa100ukrvService.selectDetailCard',
				create 	: 'bsa100ukrvService.insertCodes',
				update 	: 'bsa100ukrvService.updateCodes',
				destroy	: 'bsa100ukrvService.deleteCodes',
				syncAll	: 'bsa100ukrvService.saveAll'
			}
	 });
	 
	 var systemYNStore = Unilite.createStore('bbs010ukrvsYNStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'<t:message code="system.label.base.yes" default="예"/>'		, 'value':'1'},
			        {'text':'<t:message code="system.label.base.no" default="아니오"/>'	, 'value':'2'}
	    		]
	});

	Unilite.defineModel('bbs010ukrvs_8Model', {
	    fields: [
					{name: 'MAIN_CODE'					,text:'<t:message code="system.label.base.maincode" default="메인코드"/>'		,type : 'string' , allowBlank : false, readOnly:true},
					{name: 'SUB_CODE'					,text:'<t:message code="system.label.base.cardnum" default="카드번호"/>'		,type : 'string' , allowBlank : false, isPk:true,  pkGen:'user', readOnly:true},
					{name: 'CODE_NAME'					,text:'<t:message code="system.label.base.username" default="사용자명"/>'		,type : 'string' , allowBlank : false},
					{name: 'CODE_NAME_EN'				,text:'<t:message code="system.label.base.codename(en)" default="코드명(영어)"/>'	,type : 'string'},
					{name: 'CODE_NAME_JP'				,text:'<t:message code="system.label.base.codename(jp)" default="코드명(일본어)"/>'	,type : 'string'},
					{name: 'CODE_NAME_CN'				,text:'<t:message code="system.label.base.codename(cn)" default="코드명(중국어)"/>'	,type : 'string'},
					{name: 'CODE_NAME_VI'				,text:'<t:message code="system.label.base.codename(vi)" default="코드명(베트남어)"/>',type : 'string'},
					{name: 'REF_CODE1'					,text:'<t:message code="system.label.base.customcode" default="거래처코드"/>'		,type : 'string'},
					{name: 'CUSTOM_NAME'				,text:'<t:message code="system.label.base.custom" default="거래처"/>'		,type : 'string'},
					{name: 'REF_CODE2'					,text:'<t:message code="system.label.base.division" default="사업장"/>'		,type : 'string'  , xtype: 'uniCombobox', comboType: 'BOR120'},
					{name: 'REF_CODE3'					,text:'<t:message code="system.label.base.reference" default="참조"/>3'			,type : 'string'},
					{name: 'REF_CODE4'					,text:'<t:message code="system.label.base.reference" default="참조"/>4'			,type : 'string'},  
					{name: 'REF_CODE5'					,text:'<t:message code="system.label.base.reference" default="참조"/>5'			,type : 'string'},
					{name: 'REF_CODE6'					,text:'<t:message code="system.label.base.reference" default="참조"/>6'			,type : 'string'},
					{name: 'REF_CODE7'					,text:'<t:message code="system.label.base.reference" default="참조"/>7'			,type : 'string'},
					{name: 'REF_CODE8'					,text:'<t:message code="system.label.base.reference" default="참조"/>8'			,type : 'string'},
					{name: 'REF_CODE9'					,text:'<t:message code="system.label.base.reference" default="참조"/>9'			,type : 'string'},
					{name: 'REF_CODE10'					,text:'<t:message code="system.label.base.reference" default="참조"/>10'		,type : 'string'},
					{name: 'SUB_LENGTH'					,text:''			,type : 'int'},
					{name: 'USE_YN'						,text:'<t:message code="system.label.base.useyn" default="사용여부"/>'		,type : 'string' , defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'},
					{name: 'SORT_SEQ'					,text:''			,type : 'int'	 , defaultValue:1	, allowBlank : false},
					{name: 'SYSTEM_CODE_YN'				,text:''			,type : 'string' 	 ,store: Ext.data.StoreManager.lookup('bbs010ukrvsYNStore') , defaultValue:'2'},
					{name: 'UPDATE_DB_USER'				,text:''			,type : 'string'},
					{name: 'UPDATE_DB_TIME'				,text:''			,type : 'string'},
					{name :'S_COMP_CODE'				,text:''			,type : 'string' , defaultValue: UserInfo.compCode	} 
			]               	
	});
	
	var bbs010ukrvs_8Store = Unilite.createStore('bbs010ukrvs_8Store',{
			model: 'bbs010ukrvs_8Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
           proxy: Ext.isEmpty(multiCompCodeBbs010ukrs8Proxy) ?  directProxy:multiCompCodeBbs010ukrs8Proxy,
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
					 panelDetail.down('#bbs010ukrvs_8Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			loadStoreRecords : function(){
				this.load();
			} 
		});

	var card =	 {
			//title:'외상카드',
			itemId: 'card',
			layout: {type: 'vbox', align:'stretch'},
			items:[{	
				title:'<t:message code="system.label.base.traumacard" default="외상카드"/>',
				itemId: 'tab_card',
				xtype: 'container',
		        		layout: {type: 'hbox', align:'stretch'},
		        		flex:1,
		     			autoScroll:false,
		        		items:[
			        	{	
			        		bodyCls: 'human-panel-form-background',
			        		xtype: 'uniGridPanel',
			        		itemId:'bbs010ukrvs_8Grid',
					        store : bbs010ukrvs_8Store, 
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
						  {dataIndex: 'SUB_CODE'			, width: 150},
						  {dataIndex: 'CODE_NAME'			, flex: 1	},
						  {dataIndex: 'CODE_NAME_EN'		, width: 133, hidden: true},
						  {dataIndex: 'CODE_NAME_CN'		, width: 133, hidden: true},
						  {dataIndex: 'CODE_NAME_JP'		, width: 133, hidden: true},
						  {dataIndex: 'CODE_NAME_VI'		, width: 133, hidden: true},
						  {dataIndex: 'SYSTEM_CODE_YN'		, width: 100, hidden: true},
						  {dataIndex: 'REF_CODE1'			, width: 200, hidden: true,
						  'editor': Unilite.popup('CUST_G',{
	                    	  	 	textFieldName : 'CUSTOM_NAME',
			  						autoPopup: true,
	                    	  	 	listeners: { 'onSelected': {
					                    fn: function(records, type  ){
					                    	var grdRecord = panelDetail.down('#bbs010ukrvs_8Grid').uniOpt.currentRecord;
                    						grdRecord.set('REF_CODE1',records[0]['CUSTOM_CODE']);
                    						grdRecord.set('REF_CODE2',records[0]['CUSTOM_NAME']);
                    						
					                    },
					                    scope: this
					                  },
					                  'onClear' : function(type)	{
					                    	var grdRecord = panelDetail.down('#bbs010ukrvs_8Grid').uniOpt.currentRecord;
                    						grdRecord.set('REF_CODE1','');
                    						grdRecord.set('REF_CODE2','');
					                  }
	                    	  	 	}
								})
				  		 },
						  {dataIndex: 'CUSTOM_NAME'			, width: 200 ,
						  'editor': Unilite.popup('CUST_G',{
	                    	  	 	textFieldName : 'CUSTOM_NAME',
			  						autoPopup: true,
	                    	  	 	listeners: { 'onSelected': {
					                    fn: function(records, type  ){
					                    	var grdRecord = panelDetail.down('#bbs010ukrvs_8Grid').uniOpt.currentRecord;
                    						grdRecord.set('REF_CODE1',records[0]['CUSTOM_CODE']);
                    						grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                    						
					                    },
					                    scope: this
					                  },
					                  'onClear' : function(type)	{
					                    	var grdRecord = panelDetail.down('#bbs010ukrvs_8Grid').uniOpt.currentRecord;
                    						grdRecord.set('REF_CODE1','');
                    						grdRecord.set('CUSTOM_NAME','');
					                  }
	                    	  	 	}
								})
				  		 },
				  		  {dataIndex: 'REF_CODE2'			, width: 160},
						  {dataIndex: 'REF_CODE3'			, width: 100, hidden: true},
						  {dataIndex: 'REF_CODE4'			, width: 100, hidden: true},
						  {dataIndex: 'REF_CODE5'			, width: 100, hidden: true},
						  {dataIndex: 'REF_CODE6'			, width: 100, hidden: true},
						  {dataIndex: 'REF_CODE7'			, width: 133, hidden: true},
						  {dataIndex: 'REF_CODE8'			, width: 100, hidden: true},
						  {dataIndex: 'REF_CODE9'			, width: 100, hidden: true},
						  {dataIndex: 'REF_CODE10'			, width: 100, hidden: true},
						  {dataIndex: 'SUB_LENGTH'			, width: 66, hidden: true},  
						  {dataIndex: 'USE_YN'				, width: 100 },				    
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