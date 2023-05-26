<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//개발요청등록
request.setAttribute("PKGNAME","Unilite_app_wps100ukrv");
%>
<t:appConfig pgmId="wps100ukrv" >
	<t:ExtComboStore comboType="AU" 			comboCode="B007" /> 
	<t:ExtComboStore comboType="AU" 			comboCode="B908" /> <!-- project Store -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript">
function appMain() {
	var baseInfo={
		'gbn':'${gbn}'
	}
	<%@include file="./wpsCommonModel.jsp" %>	
		Unilite.defineModel('${PKGNAME}MasterModel', {
			fields : [ {name : 'WORK_ID',		text : '작업번호',	type : 'uniNumber', editable:false}				 				 
					 , {name : 'TITLE',			text : '제목',		type : 'string'  }
					 , {name : 'WORK_CONTENT',	text : '내용',		type : 'string'	 }
					 , {name : 'DOC_ID',		text : '문서번호',	type : 'string'  }
					 , {name : 'PROJECT',		text : '프로젝트',	type : 'string'  ,comboType:"AU"	,comboCode:"B908"}
					 , {name : 'MODULE',		text : '모듈',		type : 'string'  ,comboType:"AU"	,comboCode:"B007"}
					 , {name : 'WORK_GUBUN',	text : '업무구분',	type : 'string'  ,store:Ext.data.StoreManager.lookup('workGubunStore')}
					 , {name : 'REQ_DATE',		text : '요청일',	type : 'uniDate'  }
					 , {name : 'REQ_NAME',		text : '요청자',	type : 'string'  ,store:Ext.data.StoreManager.lookup('empStore')}
					 , {name : 'REMARK',		text : '비고',		type : 'string'  }
					 , {name : 'ADD_FIDS',		text : '추가파일',		type : 'string'  }
					 , {name : 'DEL_FIDS',		text : '삭제파일',		type : 'string'  }
					]
					 
		});
		
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 	 'wps100ukrvService.selectList',
				create : 'wps100ukrvService.insert',
				update : 'wps100ukrvService.update',
				destroy: 'wps100ukrvService.delete',
				syncAll: 'wps100ukrvService.saveAll'
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
				var param= Ext.getCmp('wps100ukrvSearchForm').getValues();
				var fp = Ext.getCmp('wps100ukrvFileUploadPanel');
				fp.clear();
				masterForm.clearForm();
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
		
	var panelSearch = Unilite.createSearchForm('wps100ukrvSearchForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			 {
			 	fieldLabel : '요청일',		
			 	xtype:'uniDateRangefield',
			 	startFieldName: 'REQ_DATE_FR',
                endFieldName: 'REQ_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'), 
			 	colspan:2
			 },{
			 	fieldLabel : '요청자',		
			 	name : 'REQ_NAME',
			 	xtype:'uniCombobox',
			 	store:Ext.data.StoreManager.lookup('empStore')
			 },{
			 	fieldLabel : '제목',			
			  	name : 'TITLE'
			 },{
			 	fieldLabel : '개발자',		
			 	name : 'DEV_NAME',
			 	xtype:'uniCombobox',
			 	store:Ext.data.StoreManager.lookup('empStore')
			 },{
			 	fieldLabel : '내용',			
			 	name : 'WORK_CONTENT'
			 }
		]})
		
		
		// create the Grid
		var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
			region : 'center',
			uniOpt:{expandLastColumn:false, useContextMenu:true, copiedRow:true},
			store: directMasterStore,
	        itemId:'${PKGNAME}Grid',
			columns : [   {dataIndex : 'WORK_ID',			width : 80		}					
						, {dataIndex : 'TITLE',			flex : 1		}
						, {dataIndex : 'REQ_NAME',		width : 80		}
						, {dataIndex : 'PROJECT',		width : 120 }
						, {dataIndex : 'MODULE',		width : 80 }
						, {dataIndex : 'WORK_GUBUN',		width : 80 }
						, {dataIndex : 'REMARK',		width : 250		}	
					],
			listeners: {          	
				edit:function(editor)	{
					masterForm.setActiveRecord(editor.context.record);
				},
				selectionchangerecord:function(selected)	{
          			masterForm.setActiveRecord(selected);
          			var fp = Ext.getCmp('wps100ukrvFileUploadPanel');
				    
					
       				if(selected && !Ext.isEmpty(selected.data['DOC_ID'])) {
       					var docNo=selected.data['DOC_ID'];
				   	 	bdc100ukrvService.getFileList({DOC_NO : docNo},
							function(provider, response) {
								var fp = Ext.getCmp('wps100ukrvFileUploadPanel');
								fp.loadData(response.result);
							}
					 	)
       				} else {
       					fp.clear();
       				}
				}
			}		
		});
		var masterForm  = Unilite.createForm('detailForm', {
			region:'south',
			height:330,
	    	masterGrid: masterGrid,
	        autoScroll:true,
	        border: false,      
	        uniOpt:{
	        	store : directMasterStore
	        },
		    //for Form      
		    layout: {
		    	type: 'uniTable',
		    	columns: 3
		    }, 
		    items : [
		    	  { fieldLabel: '요청자'	, name : 'REQ_NAME'		,xtype:'uniCombobox', store:Ext.data.StoreManager.lookup('empStore')}
				, { fieldLabel: '요청일'	, name : 'REQ_DATE'		,xtype:'uniDatefield'}
				, { xtype:'component', html:'&nbsp;'}
				, { fieldLabel: '제목'		, name : 'TITLE',			width : 1300, 		colspan:3		}		
				, { fieldLabel: '내용'		, name : 'WORK_CONTENT',	xtype:'textarea',	colspan:3,width : 1300, height:100		}
				,{
	     			xtype:'xuploadpanel',
	     			id : 'wps100ukrvFileUploadPanel',
			    	itemId:'fileUploadPanel',
			    	colspan : 4,
			    	flex:1,
			    	height:150,
			    	listeners : {
			    		change: function() {
		                    var fp = Ext.getCmp('wps100ukrvFileUploadPanel');
		                    fp.setData();
			    		}
			    	},
			    	setData:function()	{
			    		var fp = this;
						var addFiles = fp.getAddFiles();
						var delFiles = fp.getRemoveFiles();
						console.log("addFiles : " , addFiles.length)
						
						if(addFiles.length > 0)	{
		                    masterGrid.getSelectedRecord().set('ADD_FIDS', addFiles );
		                } else {
		                    masterGrid.getSelectedRecord().set('ADD_FIDS', '' );
		                }
						
						if(delFiles.length > 0)	{
		                    masterGrid.getSelectedRecord().set('DEL_FIDS', delFiles );
		                } else {
		                    masterGrid.getSelectedRecord().set('DEL_FIDS', '' );
		                }
			    	
			    	}
				}
				]
		});

  
    Unilite.Main({
    		 id  : 'wps100ukrvApp',
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
				var fp = Ext.getCmp('wps100ukrvFileUploadPanel');
				fp.setData();
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