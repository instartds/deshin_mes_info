//@charset UTF-8
Ext.define('Unilite.com.config.CodeGrid', {
	extend: 'Ext.container.Container',
	
	alias: 'widget.ConfigCodeGrid',
	codeName: '',
	subCode: '',
	constructor: function(config){    
        var me = this;
        
        var grid = me.sysCodeGridConfig( config.codeName, config.subCode )	;
		//Ext.apply(config, mConfig);
		
       	if (config) {
            Ext.apply(me, config);
        };	
        

		this.items=[grid];
		
        this.callParent([config]);
	},
    initComponent: function() {
        var me = this;
        
        
        me.callParent(arguments);
     },
   
     

     sysCodeGridConfig:function(codeName, subCode )	{
     	
 		Unilite.defineModel('systemCodeModel'+subCode, {
		    fields : [ 	  
		    	  {name : 'MAIN_CODE',		text : '종합코드'	, allowBlank : false, readOnly:true}
				, {name : 'SUB_CODE',		text : '상세코드'	, allowBlank : false, isPk:true,  pkGen:'user', readOnly:true}
				, {name : 'CODE_NAME',		text : '상세코드명'	, allowBlank : false}
				, {name : 'SYSTEM_CODE_YN',	text : '시스템',	type : 'string',		comboType : 'AU', comboCode : 'B018', defaultValue:'2'}
				, {name : 'SORT_SEQ',		text: '정렬순서',	type : 'int',			defaultValue:1	, allowBlank : false}
				, {name : 'REF_CODE1',		text: '관련1',		type : 'string'	}
				, {name : 'REF_CODE2',		text: '관련2',		type : 'string'	}
				, {name : 'REF_CODE3',		text: '관련3',		type : 'string'	}
				, {name : 'REF_CODE4',		text: '관련4',		type : 'string'	}
				, {name : 'REF_CODE5',		text: '관련5',		type : 'string'	}
				, {name : 'REF_CODE6',		text: '관련6',		type : 'string'	}
				, {name : 'REF_CODE7',		text: '관련7',		type : 'string'	}
				, {name : 'REF_CODE8',		text: '관련8',		type : 'string'	}
				, {name : 'REF_CODE9',		text: '관련9',		type : 'string'	}
				, {name : 'REF_CODE10',		text: '관련10',		type : 'string'	} 
				, {name : 'USE_YN',			text: '사용여부',	type : 'string',		defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'} 
				, {name : 'S_COMP_CODE',	text: '관련10',		type : 'string', 	defaultValue: UserInfo.compCode	} 
			]
		});
		var grid;
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'bsa100ukrvService.selectDetailCodeList',
				create 	: 'bsa100ukrvService.insertCodes',
				update 	: 'bsa100ukrvService.updateCodes',
				destroy	: 'bsa100ukrvService.deleteCodes',
				syncAll	: 'bsa100ukrvService.saveAll'
			}
		});
     	var inStore = Ext.create('Unilite.com.data.UniStore', {
			model: 'systemCodeModel'+subCode,
	        autoLoad: false,
	        uniOpt : {
	        	isMaster: true,			// 상위 버튼 연결 
	        	editable: true,			// 수정 모드 사용 
	        	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
	        },
	        proxy: directProxy,
//	        proxy: {
//	            type: 'direct',
//	            api: {
//	            	   read :  bsa100ukrvService.selectDetailCodeList,
//	            	   update: bsa100ukrvService.updateCodes,
//					   create: bsa100ukrvService.insertCodes,
//					   destroy:bsa100ukrvService.deleteCodes,
//					   syncAll:bsa100ukrvService.syncAll
//	            }
//	        },
	        saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();					
				}else {
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
//			load: function() {
//				// {params:{'MAIN_CODE':mainCode}}
//				console.log('load');
//			}
		});
		
		grid= Unilite.createGrid('', {
			title:codeName,
			subCode: subCode,
			autoScroll:true,
			flex:1,
			dockedItems: [{
		        xtype: 'toolbar',
		        dock: 'top',
		        padding:'0px',
		        border:0
		    }],
			bodyCls: 'human-panel-form-background',
	        padding: '0 0 0 0',
		    store : inStore,
		    uniOpt: {
		    	expandLastColumn: false,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [{	dataIndex : 'MAIN_CODE',		width : 100, 	hidden : true}
					, {	dataIndex : 'SUB_CODE',			width : 100	}
					, {	dataIndex : 'CODE_NAME',		flex: 1	}
					, {	dataIndex : 'SYSTEM_CODE_YN',	width : 100	}
					, {	dataIndex : 'SORT_SEQ',			width : 100,		hidden : true	}
					, {	dataIndex : 'REF_CODE1',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE2',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE3',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE4',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE5',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE6',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE7',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE8',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE9',		width : 110,	hidden : true	}
					, {	dataIndex : 'REF_CODE10',		width : 110,	hidden : true	}  
					, {	dataIndex : 'USE_YN',			width : 100	}  
			]
			 ,getSubCode: function()	{
				return this.subCode;
			}
		});
	return grid;
	
 	}
});
