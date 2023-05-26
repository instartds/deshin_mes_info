<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//다국어코드 등록(프로그램메뉴)
request.setAttribute("PKGNAME","Unilite_app_bsa405ukrv");
%>
<t:appConfig pgmId="bsa405ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B007" />
</t:appConfig>
<script type="text/javascript">
var fileWindow;
function appMain() {
		Unilite.defineModel('${PKGNAME}MasterModel', {
			fields : [ {name : 'PGM_SEQ',		text : '모듈',				type : 'string',	allowBlank:false, comboType : 'AU', comboCode : 'B007', editable:false}
					 , {name : 'PGM_ID',			text : '프로그램ID',		type : 'string',    allowBlank:false	  , editable:false}						 				 
					 , {name : 'PGM_NAME',		text : '한국어',			type : 'string'  }
					 , {name : 'PGM_NAME_EN',	text : '영어',				type : 'string'	 }
					 , {name : 'PGM_NAME_CN',	text : '중국어',			type : 'string'  }
					 , {name : 'PGM_NAME_JP',	text : '일본어',			type : 'string'  }
					 , {name : 'PGM_NAME_VI',	text : '베트남어',			type : 'string'  }
					
					]
		});
		
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 	 'bsa405ukrvService.selectList',
				update : 'bsa405ukrvService.update',
				syncAll: 'bsa405ukrvService.saveAll'
			}
		});
		
		var directMasterStore = Unilite.createStore('${PKGNAME}MasterStore', { 
			model : '${PKGNAME}MasterModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
			proxy : directProxy,
			loadStoreRecords : function()	{
				var param= Ext.getCmp('bsa405ukrvSearchForm').getValues();	
				this.load({
					params : param
				});
			},
			saveStore : function()	{
					var inValidRecs = this.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						this.syncAllDirect();			
					}else {
						var grid = Ext.getCmp('${PKGNAME}Grid');
						grid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				
			}
		});
		
		// create the Grid
		var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
			region : 'center',
			uniOpt:{expandLastColumn:false, useContextMenu:true, copiedRow:true},
			store: directMasterStore,
	        itemId:'${PKGNAME}Grid',
			columns : [   {dataIndex : 'PGM_SEQ',			width : 80		}
						, {dataIndex : 'PGM_ID',			width : 110		}					
						, {dataIndex : 'PGM_NAME',			width : 150		}
						, {dataIndex : 'PGM_NAME_EN',		width : 150		}
						, {dataIndex : 'PGM_NAME_CN',		width : 150		}
						, {dataIndex : 'PGM_NAME_JP',		width : 150		}		
						, {dataIndex : 'PGM_NAME_VI',		width : 150		}	
					],
			listeners: {          	
				edit:function(editor)	{
					masterForm.setActiveRecord(editor.context.record);
				},
				selectionchangerecord:function(selected)	{
          			masterForm.setActiveRecord(selected);
				}
			}		
		});
		var masterForm  = Unilite.createForm('detailForm', {
			region:'south',
			height:165,
			disabled:false,
	    	masterGrid: masterGrid,
	        autoScroll:true,
	        border: false,
	        padding: '10 10 10 10',       
	        uniOpt:{
	        	store : directMasterStore
	        },
		    //for Form      
		    layout: {
		    	type: 'uniTable',
		    	columns: 1
		    },
		    masterGrid: masterGrid,
		    items : [
		    	  { fieldLabel: '한국어'	, name : 'PGM_NAME',			width : 1300		}
				, { fieldLabel: '영어'		, name : 'PGM_NAME_EN',		width : 1300		}
				, { fieldLabel: '중국어'	, name : 'PGM_NAME_CN',		width : 1300		}
				, { fieldLabel: '일본어'	, name : 'PGM_NAME_JP',		width : 1300		}		
				, { fieldLabel: '베트남어'	, name : 'PGM_NAME_VI',		width : 1300		}
			]
		});

  var panelSearch = Unilite.createSearchForm('bsa405ukrvSearchForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			 {fieldLabel : '프로그램ID',		name : 'PGM_ID', colspan:5}
			,{fieldLabel : '한국어',			name : 'PGM_NAME'}
			,{fieldLabel : '영어',				name : 'PGM_NAME_EN'}
			,{fieldLabel : '중국어',			name : 'PGM_NAME_CN'}
			,{fieldLabel : '일본어',			name : 'PGM_NAME_JP'}
			,{fieldLabel : '베트남어',			name : 'PGM_NAME_VI'}
			
		]})
		
    Unilite.Main({
    		 id  : 'baa030ukrvApp',
			 borderItems : [ panelSearch, masterGrid , masterForm]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset'],true);
			}
			, onQueryButtonDown:function() {
//				if(!UniAppManager.app._needSave())	{
					masterGrid.getStore().loadStoreRecords();
//				}
			}
			, onNewDataButtonDown : function()	{
					var r = masterGrid.createRow();
				
			}
			, onSaveDataButtonDown: function () {											
					directMasterStore.saveStore();	//Master 데이타 저장 성공 후 Detail 저장함.				
				}
			, onDeleteDataButtonDown : function()	{
				var selIndex = masterGrid.getSelectedRecord();
					if(confirm(Msg.sMB045))	{
						masterGrid.deleteSelectedRow(selIndex);
					}
					
				},
				onResetButtonDown: function() {
//					if(!UniAppManager.app._needSave())	{
						panelSearch.clearForm();
						
						masterGrid.getStore().loadData({});
//					}
				}	
			
		});
		
		
};	// appMain
</script>