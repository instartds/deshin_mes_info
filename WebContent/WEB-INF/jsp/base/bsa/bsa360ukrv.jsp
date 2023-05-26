<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa360ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B007" /><!-- 업무구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B003" /><!-- 프로그램사용 권한 -->
	<t:ExtComboStore comboType="AU" comboCode="B006" /><!-- 파일저장 사용권한 -->
	<t:ExtComboStore comboType="AU" comboCode="BS06" /><!-- 권한범위-사업장 -->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {

	Unilite.defineModel('bsa360ukrvGroupModel', {
	
		fields: [{name: 'GROUP_CODE'    		, text: '권한그룹명',			type: 'string'	},
				 {name: 'PGM_ID'        		, text: 'PGM_ID',			type: 'string'	},
				 {name: 'PGM_NAME'      		, text: '프로그램명',			type: 'string'	},
				 {name: 'PGM_LEVEL'     		, text: '자료수정',			type: 'string'	},
				 {name: 'PGM_LEVEL2'    		, text: '파일저장',			type: 'string'	},
				 {name: 'AUTHO_USER'    		, text: '자료권한',			type: 'string'	},
				 {name: 'AUTHO_TYPE'    		, text: '권한형태',			type: 'string'	},
				 {name: 'AUTHO_PGM'     		, text: '권한정의',			type: 'string'	},
				 {name: 'REF_CODE'      		, text: '참조코드',			type: 'string'	},
				 {name: 'AUTHO_ID'      		, text: '권한형태(번호)',		type: 'string'	},
				 {name: 'COMP_CODE'     		, text: '<t:message code="system.label.base.companycode" default="법인코드"/>',			type: 'string'	},
				 {name: 'INSERT_DB_USER'		, text: 'INSERT_DB_USER',	type: 'string'	},
				 {name: 'UPDATE_DB_USER'		, text: '수정자',			 	type: 'string'	}
		]
	});
	
	var directGroupStore = Unilite.createStore('bsa360ukrvGroupStore', { 
		model: 'bsa360ukrvGroupModel',
		autoLoad: false,
		uniOpt: {
	    	isMaster: false,			// 상위 버튼 연결 
	    	editable: false,			// 수정 모드 사용 
	    	deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | next 버튼 사용
	    },
		proxy: {
			type: 'direct',
			api: {
				read: 	 'bsa360ukrvService.selectList'
				
			}
		}
		,loadStoreRecords: function()	{
			var param= Ext.getCmp('bsa360ukrvSearchForm').getValues();	
			if(panelSearch.getValue('USER_ID') != '')	{					
				this.load({
					params: param
				});
			}else {
				Unilite.messageBox(Msg.sMB083);			
			}
		}
		
	});
	
	
	Unilite.defineModel('bsa360ukrvMasterModel', {
	
		fields: [{name: 'COMP_CODE'				    , text: '<t:message code="system.label.base.companycode" default="법인코드"/>',			type: 'string'	},
			   	 {name: 'USER_ID'				    , text: '사용자아이디',			type: 'string'	},
			   	 {name: 'USER_NAME'     		    , text: '사용자명',			type: 'string'	},
			   	 {name: 'GROUP_CODE'			    , text: '그룹코드',			type: 'string'	},
			   	 {name: 'GROUP_NAME'			    , text: '그룹명',				type: 'string'	},
			   	 {name: 'INSERT_DB_USER'		    , text: 'INSERT_DB_USER',	type: 'string'	},
			   	 {name: 'INSERT_DB_TIME'		    , text: 'INSERT_DB_TIME',	type: 'string'	},
			   	 {name: 'UPDATE_DB_USER'		    , text: 'UPDATE_DB_USER',	type: 'string'	},
			   	 {name: 'UPDATE_DB_TIME'		    , text: 'UPDATE_DB_TIME',	type: 'string'	}
			   	   
		]
	});	
	var directMasterStore = Unilite.createStore('bsa360ukrvMasterStore', { 
		model: 'bsa360ukrvMasterModel',
		autoLoad: false,
		uniOpt: {
	    	isMaster: false,			// 상위 버튼 연결 
	    	editable: false,			// 수정 모드 사용 
	    	deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | next 버튼 사용
	    },
		proxy: {
			type: 'direct',
			api: {
				read: 	 'bsa360ukrvService.selectList'
				
			}
		}
		,loadStoreRecords: function()	{
			var param= Ext.getCmp('bsa360ukrvSearchForm').getValues();	
			if(panelSearch.getValue('USER_ID') != '')	{					
				this.load({
					params: param
				});
			}else {
				Unilite.messageBox(Msg.sMB083);
			
			}
		}
		
	});	
		
	var panelSearch = Unilite.createSearchPanel('bsa360ukrvSearchForm', {          
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
		defaultType: 'uniSearchSubPanel',
		items: [{     
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			items: [
				Unilite.popup('USER',{
				fieldLabel: '사용자 ID',
				textFieldWidth:170,
				validateBlank:false, 
				popupWidth: 710,
				colspan: 2
			}),{
				xtype: 'uniTextfield',
				fieldLabel: '사용자명',
				name:''
			}]
		}]
	});
		
   		
		
	// create the Grid			
	var groupGrid = Unilite.createGrid('bsa360ukrvGroupGrid', {
		region: 'west',
		store: directGroupStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
		uniOpt: {
	    	onLoadSelectFirst: false,
        	expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true
	    },
		columns: [{dataIndex: 'GROUP_CODE'    		,		width: 150	},//임시헤더
				  {dataIndex: 'PGM_ID'        		,		width: 100, hidden: true },
				  {dataIndex: 'PGM_NAME'      		,		width: 150, hidden: true },
				  {dataIndex: 'PGM_LEVEL'     		,		width: 100, hidden: true },
				  {dataIndex: 'PGM_LEVEL2'    		,		width: 100, hidden: true },
				  {dataIndex: 'AUTHO_USER'    		,		width: 100, hidden: true },
				  {dataIndex: 'AUTHO_TYPE'    		,		width: 66, hidden: true	},
				  {dataIndex: 'AUTHO_PGM'     		,		width: 66, hidden: true	},
				  {dataIndex: 'REF_CODE'      		,		width: 66, hidden: true	},
				  {dataIndex: 'AUTHO_ID'      		,		width: 66, hidden: true	},
				  {dataIndex: 'COMP_CODE'     		,		width: 66, hidden: true	},
				  {dataIndex: 'INSERT_DB_USER'		,		width: 66, hidden: true	},
				  {dataIndex: 'UPDATE_DB_USER'		,		width: 66, hidden: true	}
				]		
		
	});
	
	
	var masterGrid = Unilite.createGrid('bsa360ukrvMasterGrid', {
		flex: 2,
		region: 'center',
		store: directMasterStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
		uniOpt: {
	    	onLoadSelectFirst: false,
        	expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true
	    },
		columns: [{dataIndex: 'COMP_CODE'				,		width: 100, hidden: true},				  
				  {dataIndex: 'USER_ID'				    ,		width: 100},				  
				  {dataIndex: 'USER_NAME'     		    ,		width: 120},				  
				  {dataIndex: 'GROUP_CODE'			    ,		width: 100, hidden: true},				  
				  {dataIndex: 'GROUP_NAME'			    ,		width: 100},				  
				  {dataIndex: 'INSERT_DB_USER'		    ,		width: 106, hidden: true},				  
				  {dataIndex: 'INSERT_DB_TIME'		    ,		width: 120, hidden: true},				  
				  {dataIndex: 'UPDATE_DB_USER'		    ,		width: 120, hidden: true},				  
				  {dataIndex: 'UPDATE_DB_TIME'		    ,		width: 100, hidden: true}		  
				  
		]		
		
	});
		

    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[groupGrid, masterGrid ]	
		}		
		,panelSearch
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'],true);
		}
		, onQueryButtonDown: function() {
			masterGrid.getStore().loadStoreRecords();
		}

		, onSaveDataButtonDown: function () {										
				 if(programStore.isDirty())	{
					programStore.saveStore();						
				 }				
			}
		,
			onResetButtonDown: function() {
				detailUserGrid.reset();
				masterGrid.reset();
				Ext.getCmp('bsa360ukrvSearchForm').reset();
			}
	});

		

};	// appMain
</script>