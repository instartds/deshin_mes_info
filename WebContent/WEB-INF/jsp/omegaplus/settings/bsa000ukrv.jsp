<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//다국어코드 등록(디비에러메세지)
request.setAttribute("PKGNAME","Unilite_app_bsa000ukrv");
%>
<t:appConfig pgmId="bsa000ukrv" >
</t:appConfig>
<script type="text/javascript">
function appMain() {
		Unilite.defineModel('${PKGNAME}MasterModel', {
			fields : [ {name : 'MSG_NO',		text : '구분',		type : 'uniNumber',	allowBlank:false}				 				 
					 , {name : 'MSG_DESC',		text : '한국어',	type : 'string'  }
					 , {name : 'MSG_DESC_EN',	text : '영어',		type : 'string'	 }
					 , {name : 'MSG_DESC_CN',	text : '중국어',	type : 'string'  }
					 , {name : 'MSG_DESC_JP',	text : '일본어',	type : 'string'  }
					 , {name : 'MSG_DESC_VI',	text : '베트남어',	type : 'string'  }
					]
		});
		
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 	 'bsa000ukrvService.selectList',
				create : 'bsa000ukrvService.insert',
				update : 'bsa000ukrvService.update',
				destroy: 'bsa000ukrvService.delete',
				syncAll: 'bsa000ukrvService.saveAll'
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
				var param= Ext.getCmp('bsa000ukrvSearchForm').getValues();	
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
			columns : [   {dataIndex : 'MSG_NO',			width : 80		}					
						, {dataIndex : 'MSG_DESC',			width : 250		}
						, {dataIndex : 'MSG_DESC_EN',		width : 250		}
						, {dataIndex : 'MSG_DESC_CN',		width : 250		}
						, {dataIndex : 'MSG_DESC_JP',		width : 250		}		
						, {dataIndex : 'MSG_DESC_VI',		width : 250		}	
					],
			listeners: {          	
				beforeedit  : function( editor, e, eOpts ) {
					if(UniUtils.indexOf(e.field, ['MSG_NO'])){
	    				if(e.record.phantom){
	    				    return true;
	    				}else{
	    				    return false;
	    				}
					}
				},
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
		    	  { fieldLabel: '한국어'	, name : 'MSG_DESC',		width : 1300		}
				, { fieldLabel: '영어'		, name : 'MSG_DESC_EN',		width : 1300		}
				, { fieldLabel: '중국어'	, name : 'MSG_DESC_CN',		width : 1300		}
				, { fieldLabel: '일본어'	, name : 'MSG_DESC_JP',		width : 1300		}		
				, { fieldLabel: '베트남어'	, name : 'MSG_DESC_VI',		width : 1300		}
			]
		});

  var panelSearch = Unilite.createSearchForm('bsa000ukrvSearchForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			 {fieldLabel : '코드',			name : 'MSG_NO', colspan:5}
			,{fieldLabel : '한국어',		name : 'MSG_DESC'}
			,{fieldLabel : '영어',			name : 'MSG_DESC_EN'}
			,{fieldLabel : '중국어',		name : 'MSG_DESC_CN'}
			,{fieldLabel : '일본어',		name : 'MSG_DESC_JP'}
			,{fieldLabel : '베트남어',		name : 'MSG_DESC_VI'}
			
		]})
		
    Unilite.Main({
    		 id  : 'bsa000ukrvApp',
			 borderItems : [ panelSearch, masterGrid , masterForm]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'newData'],true);
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
						var record = masterGrid.getSelectedRecord();
	          			if(!record)	{
	          				masterForm.clearForm()
	          			}
					}
					
				},
				onResetButtonDown: function() {
//					if(!UniAppManager.app._needSave())	{
						panelSearch.clearForm();
						
						masterGrid.getStore().loadData({});
						masterForm.clearForm();
//					}
				}	
			
		});
		
};	// appMain
</script>