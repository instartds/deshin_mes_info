<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa560ukrv" >
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->
	<t:ExtComboStore items="${getCompCode}" storeId="getCompCode" />	<!-- 법인코드-->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bsa560ukrvService.selectList3',
//			update	: 'bsa560ukrvService.updateDetail',
			create	: 'bsa560ukrvService.insertDetail',
			destroy	: 'bsa560ukrvService.deleteDetail',
			syncAll	: 'bsa560ukrvService.saveAll'
		}
	});	
	
//여기부터 사용자 설정
	Unilite.defineModel('bsa560ukrvUserModel', {
		fields: [
			{name: 'USER_ID'       		, text: '사용자ID'		, type: 'string'	},
			{name: 'USER_NAME'     		, text: '사용자명'			, type: 'string'	},
			{name: 'COMP_CODE'      		, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'		, type: 'string'	},
			{name: 'COMP_NAME'    		, text: '법인명'			, type: 'string'	}
		]
	});
	
	var directGroupStore = Unilite.createStore('bsa560ukrvUserStore', { 
		model	: 'bsa560ukrvUserModel',
		autoLoad: false,
		uniOpt: {
	    	isMaster	: true,			// 상위 버튼 연결 
	    	editable	: false,		// 수정 모드 사용 
	    	deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | next 버튼 사용
	    },
		proxy: {
			type	: 'direct',
			api		: {
				read: 'bsa560ukrvService.selectList'				
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		}
		
	});
//여기까지 사용자 설정
	
	
//여기부터 등록된 법인 설정 (권한 없는)
	Unilite.defineModel('bsa560ukrvGrid1Model', {
		fields: [
			{name: 'COMP_CODE'    		, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'		, type: 'string'	},
			{name: 'COMP_NAME'    		, text: '법인명'		, type: 'string'	}
		]
	});			  
	
	var directMasterStore = Unilite.createStore('bsa560ukrvGrid1Store', { 
		model	: 'bsa560ukrvGrid1Model',
		autoLoad: false,
		uniOpt	: {
	    	isMaster	: true,			// 상위 버튼 연결 
	    	editable	: false,		// 수정 모드 사용 
	    	deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | next 버튼 사용
	    },
		proxy: {
			type	: 'direct',
			api		: {
				read: 	 'bsa560ukrvService.selectList2'
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		}
	});
//여기까지 등록된 법인 설정 (권한 없는)


//여기부터 등록된 법인 설정 (권한 있는)
	Unilite.defineModel('bsa560ukrvGrid2Model', {		
		fields: [
			{name: 'COMP_CODE'		    , text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				, type: 'string'	},
			{name: 'USER_ID'		    , text: 'USER_ID'			, type: 'string'	},
			{name: 'COMP_NAME'		    , text: '법인명'				, type: 'string'	},
			{name: 'AUTHORITY_YN'	    , text: 'AUTHORITY_YN'		, type: 'string'	},
			{name: 'INSERT_DB_USER'    	, text: 'INSERT_DB_USER'	, type: 'string'	},
			{name: 'INSERT_DB_TIME'    	, text: 'INSERT_DB_TIME'	, type: 'string'	}				 				 	
		]
	});	
	
	var programStore = Unilite.createStore('bsa560ukrvGrid2Store', { 
		model	: 'bsa560ukrvGrid2Model',
		autoLoad: false,
		uniOpt	: {
	    	isMaster	: true,			// 상위 버튼 연결 
	    	editable	: false,		// 수정 모드 사용 
	    	deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | next 버튼 사용
	    },
		proxy	: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function()	{
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
			
			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						divGrid2.getSelectionModel().deselectAll();
						divGrid1.getSelectionModel().deselectAll();
					} 
				};
				this.syncAllDirect(config);
				
			} else {
				divGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}  
	});
//여기까지 등록된 법인 설정 (권한 있는)
		
		
//여기부터 검색조건
	var panelSearch = Unilite.createSearchPanel('bsa560ukrvSearchForm', {          
		title		: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
//	        collapse: function () {
//	        	panelResult.show();
//	        },
//	        expand: function() {
//	        	panelResult.hide();
//	        }
	    },
		items		: [{     
			title	: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
			itemId	: 'search_panel1',
			layout	: {type: 'uniTable', columns: 1},
			items	: [{ 
				fieldLabel	: '법인',
				name		: 'COMP_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('getCompCode'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COMP_CODE', newValue);
					}
				}
			},
			Unilite.popup('USER_NOCOMP',{
				fieldLabel		: '사용자',
				valueFieldName	: 'USER_ID',
			    textFieldName	: 'USER_NAME',
				validateBlank	: false,
				autoPopup: true,
				listeners		: {
					onValueFieldChange: function(field, newValue){	
						panelResult.setValue('USER_ID', newValue);
					},	
					onTextFieldChange: function(field, newValue){	
						panelResult.setValue('USER_NAME', newValue);
					}
				}
			}),{
				fieldLabel	: '그리드1의 USER_ID',
				name		: 'USER_ID_G1',
				xtype		: 'uniTextfield',
				hidden		: true
			},{
				fieldLabel	: '그리드1의 COMP_CODE',
				name		: 'COMP_CODE_G1',
				xtype		: 'uniTextfield',
				hidden		: true
			}]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
			fieldLabel	: '법인',
			name		: 'COMP_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('getCompCode'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('COMP_CODE', newValue);
				}
			}
		},
		Unilite.popup('USER_NOCOMP',{
			fieldLabel		: '사용자',
			valueFieldName	: 'USER_ID',
		    textFieldName	: 'USER_NAME',
			validateBlank	: false,
			autoPopup: true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('USER_ID', newValue);
				},	
				onTextFieldChange: function(field, newValue){	
					panelSearch.setValue('USER_NAME', newValue);
				}
			}
		})]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
		
    
//여기부터 그리드		
	// create the Grid			
	var userGrid = Unilite.createGrid('bsa560ukrvuserGrid', {
		region	: 'west',
		store	: directGroupStore,
		title	: '사용자',
		uniOpt	: {
	    	onLoadSelectFirst	: false,
        	expandLastColumn	: true,
			useMultipleSorting	: true,
    		useGroupSummary		: false,
    		useLiveSearch		: true,
			useContextMenu		: true
	    },
		columns	: [
			{dataIndex: 'USER_ID'       	, width: 100},
			{dataIndex: 'USER_NAME'     	, width: 100},
			{dataIndex: 'COMP_CODE'      	, width: 80},
			{dataIndex: 'COMP_NAME'	    	, width: 166}
		],
		listeners: {
        	cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					panelSearch.setValue('USER_ID_G1',record.get('USER_ID'));
					panelSearch.setValue('COMP_CODE_G1',record.get('COMP_CODE'));
					directMasterStore.loadStoreRecords(record);
					programStore.loadStoreRecords();
				}
				beforeRowIndex = rowIndex;
			}
		}
	});
	
	var divGrid1 = Unilite.createGrid('bsa560ukrvdivGrid1', {
		region	: 'north',
		store	: directMasterStore,
		title	: '법인',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
		uniOpt	: {
	    	onLoadSelectFirst	: false,
        	expandLastColumn	: true,
			useMultipleSorting	: true,
    		useGroupSummary		: false,
    		useLiveSearch		: true,
			useContextMenu		: true
	    },
		columns: [
			{dataIndex: 'COMP_CODE'    		,		width: 120},
			{dataIndex: 'COMP_NAME'    		,		width: 166}
		]
	});
		
	var divGrid2 =  Unilite.createGrid('bsa560ukrvDetailSystemGrid', {
		region	: 'south',
		store	: programStore,
		title	: '등록된 법인',
		uniOpt	: {
        	onLoadSelectFirst	: false,
        	expandLastColumn	: true,
			useMultipleSorting	: true,
    		useGroupSummary		: false,
    		useLiveSearch		: true,
			useContextMenu		: true
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
		columns: [
			{dataIndex: 'COMP_CODE'		    	, width: 66		, hidden: true},
			{dataIndex: 'USER_ID'		    	, width: 66		, hidden: true},
			{dataIndex: 'COMP_CODE'		    	, width: 120},
			{dataIndex: 'COMP_NAME'		    	, width: 166},
			{dataIndex: 'INSERT_DB_USER'    	, width: 66		, hidden: true},
			{dataIndex: 'INSERT_DB_TIME'    	, width: 66		, hidden: true}				  	
		]
	});
//여기까지 그리드
	
//여기부터 버튼 로직	
	var btnArea = { 
		xtype	: 'container',
		id		: 'bsa560ukrvBtn',
		region	: 'center',
		margin	: '0 0 2 0',
		height	: 30,
		layout	: {
			type	: 'hbox',
			align	: 'center',
			pack	: 'center'
		},
		items	: [{
			xtype	: 'button',
			text	: '▽ 추가',
			margin	: '5 30 5 10',
			handler	: function() {					        
		       var records, data = new Object();
		       if (divGrid1.getSelectedRecords()) {		        	
		           records = divGrid1.getSelectedRecords();
		           console.log("records: ", records);
		           data.records = [];
		           for (i = 0, len = records.length; i < len; i++) {
			           	var record = records[i].copy();
		            	record.phantom = true;	
		            	data.records.push(record);	
		            }
			        divGrid2.getStore().insert(0, data.records);
			        divGrid2.getSelectionModel().select(data.records);
			        divGrid1.getStore().remove(records);
			    }
			}
		}, {
			text	: '△ 제거',
			xtype	: 'button',
			margin	: '5 30 5 10',
			handler	: function() {				        
		       var records, data = new Object();
		       if (divGrid2.getSelectedRecords()) {
		           records = divGrid2.getSelectedRecords();
		           data.records = [];
		           for (i = 0, len = records.length; i < len; i++) {
		                data.records.push(records[i].copy());
		           }
			        divGrid1.getStore().insert(0, data.records);										      
			        divGrid1.getSelectionModel().select(data.records);
			        divGrid2.getStore().remove(records);
		    	}
			}
		}]					
	}
//여기까지 버튼
	
	
    Unilite.Main({
		id			: 'bsa560ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [{
				region	: 'center',
				layout	: {type: 'vbox', align: 'stretch'},
				border	: false,
				flex	: 2,
				items	: [
					divGrid1, btnArea, divGrid2
				]},
				userGrid, panelResult
			]},
		panelSearch
		],
		
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'],true);
		},
		
		onQueryButtonDown: function() {
			directGroupStore.loadStoreRecords();
			panelSearch.setValue('USER_ID_G1','');
			panelSearch.setValue('COMP_CODE_G1','');
			divGrid2.reset();
			divGrid1.reset();
			beforeRowIndex = -1;
		},
		
		onSaveDataButtonDown: function (config) {										
			if(programStore.isDirty())  	{
				programStore.saveStore();						
			}
		},
		
		onResetButtonDown: function() {
			userGrid.reset();
			divGrid2.reset();
			divGrid1.reset();
			Ext.getCmp('bsa560ukrvSearchForm').reset();
			UniAppManager.setToolbarButtons(['save'],false);
		}
	});
};	// appMain
</script>