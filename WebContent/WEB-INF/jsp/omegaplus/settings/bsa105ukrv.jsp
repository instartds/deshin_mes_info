<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//다국어코드 등록(공통코드)
request.setAttribute("PKGNAME","Unilite_app_bsa105ukrv");
%>
<t:appConfig pgmId="bsa105ukrv" >
</t:appConfig>
<script type="text/javascript">
var fileWindow;
function appMain() {
		Unilite.defineModel('${PKGNAME}MasterModel', {
			fields : [ {name : 'MAIN_CODE',		text : '종합코드',		type : 'string',    allowBlank:false , editable:false}
					 , {name : 'SUB_CODE',		text : '코드',			type : 'string',    allowBlank:false , editable:false}					 				 
					 , {name : 'CODE_NAME',		text : '한국어',		type : 'string',    allowBlank:false   }
					 , {name : 'CODE_NAME_EN',	text : '영어',			type : 'string'	 }
					 , {name : 'CODE_NAME_CN',	text : '중국어',		type : 'string'  }
					 , {name : 'CODE_NAME_JP',	text : '일본어',		type : 'string'  }
					 , {name : 'CODE_NAME_VI',	text : '베트남어',		type : 'string'  }
					
					]
		});
		
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 	 'bsa105ukrvService.selectList',
				update : 'bsa105ukrvService.update',
				syncAll: 'bsa105ukrvService.saveAll'
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
				var param= Ext.getCmp('bsa105ukrvSearchForm').getValues();	
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
			columns : [   {dataIndex : 'MAIN_CODE',			width : 80		}
						, {dataIndex : 'SUB_CODE',			width : 80		}						
						, {dataIndex : 'CODE_NAME',			width : 150		}
						, {dataIndex : 'CODE_NAME_EN',		width : 150		}
						, {dataIndex : 'CODE_NAME_CN',		width : 150		}
						, {dataIndex : 'CODE_NAME_JP',		width : 150		}		
						, {dataIndex : 'CODE_NAME_VI',		width : 150		}	
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
		    	  { fieldLabel: '한국어'	, name : 'CODE_NAME',			width : 1300		}
				, { fieldLabel: '영어'		, name : 'CODE_NAME_EN',		width : 1300		}
				, { fieldLabel: '중국어'	, name : 'CODE_NAME_CN',		width : 1300		}
				, { fieldLabel: '일본어'	, name : 'CODE_NAME_JP',		width : 1300		}		
				, { fieldLabel: '베트남어'	, name : 'CODE_NAME_VI',		width : 1300		}
			]
		});

  var panelSearch = Unilite.createSearchForm('bsa105ukrvSearchForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			 {fieldLabel : '종랍코드',			name : 'MAIN_CODE', colspan:5}
			,{fieldLabel : '한국어',			name : 'CODE_NAME'}
			,{fieldLabel : '영어',				name : 'CODE_NAME_EN'}
			,{fieldLabel : '중국어',			name : 'CODE_NAME_CN'}
			,{fieldLabel : '일본어',			name : 'CODE_NAME_JP'}
			,{fieldLabel : '베트남어',			name : 'CODE_NAME_VI'}
			
		]})
		
    Unilite.Main({
    		 id  : 'ba105ukrvApp',
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