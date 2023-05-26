<%@page language="java" contentType="text/html; charset=utf-8"%>

	var bbs010ukrv1Proxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'bsa100ukrvService.selectDetailCodeList',
			create 	: 'bsa100ukrvService.insertCodes',
			update 	: 'bsa100ukrvService.updateCodes',
			destroy	: 'bsa100ukrvService.deleteCodes',
			syncAll	: 'bsa100ukrvService.saveAll'
		}
	});
	var bbs010ukrv1Store = Unilite.createStore('bbs010ukrv1Store',{
		model: 'bbs010ukrvsModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        
        proxy: bbs010ukrv1Proxy,
        saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect();					
			}else {
				Unilite.messageBox(Msg.sMB083);
			}
		}
	});
	var currency = Unilite.createGrid('bbs010ukrvGrid1', {
		title:'<t:message code="system.label.base.currency" default="화폐"/>',
		itemId:'currencyGrid',
		subCode:'B004',
		displayField: 'value',
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
	    store : bbs010ukrv1Store,
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
		],
		getSubCode: function()	{
			return this.subCode;
		}
	})