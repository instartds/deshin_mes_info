<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//개발요청등록
request.setAttribute("PKGNAME","Unilite_app_wps110ukrv");
%>
<t:appConfig pgmId="wps110ukrv" >
	<t:ExtComboStore comboType="AU" 			comboCode="B007" /> 
	<t:ExtComboStore comboType="AU" 			comboCode="B908" /> 
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript">
var reqWindow, pgmSearchWindow;
	function appMain() {
	<%@include file="./wpsCommonModel.jsp" %>	
	<%@include file="./wpsCommonComponent.jsp" %>
	
	
	Unilite.defineModel('${PKGNAME}MasterModel', {
		fields : [ {name : 'WORK_ID',			text : '작업번호',	type : 'uniNumber'	, editable: true , allowBlank:false}	
				 , {name : 'SEQ',				text : '순번',		type : 'uniNumber'	, editable: false}	
				 , {name : 'TITLE',				text : '제목',		type : 'string'   	, editable: false}
				 , {name : 'REQ_NAME',			text : '요청자',	type : 'string'  	, editable: false,	store:Ext.data.StoreManager.lookup('empStore')}
				 , {name : 'REQ_DATE',			text : '요청일',	type : 'uniDate' 	, editable: false }
				 , {name : 'PROJECT',			text : '프로젝트',	type : 'string'  	, editable: false,	comboType:"AU"	,comboCode:"B908"}
				 , {name : 'MODULE',			text : '모듈',		type : 'string'  , editable: false,	comboType:"AU"	,comboCode:"B007"}
				 , {name : 'WORK_GUBUN',		text : '업무구분',	type : 'string'  	, editable: false,	store:Ext.data.StoreManager.lookup('workGubunStore')}
				 , {name : 'DEV_NAME',			text : '개발자',	type : 'string' 	, editable: true,  allowBlank:false	,store:Ext.data.StoreManager.lookup('empStore'), editable: true }
			 	 , {name : 'WORK_STATE',		text : '진행상태',	type : 'string'  	, editable: false,	store:Ext.data.StoreManager.lookup('stateStore') }
				 , {name : 'WORK_DATE_START',	text : '개발시작일',	type : 'uniDate', editable: false}
				 , {name : 'WORK_DATE_END',		text : '개발종료일',	type : 'uniDate', editable: false}
				 ]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 	 'wps110skrvService.selectList',
			create : 'wps110ukrvService.insert',
			update : 'wps110ukrvService.updateDev',
			destroy: 'wps110ukrvService.delete',
			syncAll: 'wps110ukrvService.saveAllDev'
		}
	});
	
	var directMasterStore = Unilite.createStore('${PKGNAME}MasterStore', { 
		model : '${PKGNAME}MasterModel',
		autoLoad : false,
		groupField :'DEV_NAME',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
		proxy : directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('wps110ukrvSearchForm').getValues();	
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

	
	var panelSearch = Unilite.createSearchForm('wps110ukrvSearchForm',{
    	region: 'north',
    	itemId:'wps110ukrvSearchForm',
		layout : {type : 'uniTable', columns : 4},
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
                endDate: UniDate.get('today')
			 },{
			 	fieldLabel : '요청자',		
			 	name : 'REQ_NAME',
			 	xtype:'uniCombobox',
			 	store:Ext.data.StoreManager.lookup('empStore')
			 },{
			 	fieldLabel : '프로젝트',		
			 	name : 'PROJECT',
			 	xtype:'uniCombobox',
			 	comboType:"AU"	,
			 	comboCode:"B908"
			 },{
			 	fieldLabel : '모듈',		
			 	name : 'MODULE',
			 	xtype:'uniCombobox',
			 	comboType:'AU',
			 	comboCode:'B007'
			 },{
			 	fieldLabel : '개발종료일',		
			 	xtype:'uniDateRangefield',
			 	startFieldName: 'WORK_DATE_END_FR',
                endFieldName: 'WORK_DATE_END_TO'
			 },{
			 	fieldLabel : '개발자',		
			 	name : 'DEV_NAME',
			 	xtype:'uniCombobox',
			 	store:Ext.data.StoreManager.lookup('empStore')
			 },{
			 	fieldLabel : '진행상태',		
			 	name : 'WORK_STATE',
			 	xtype:'uniCombobox',
			 	store:Ext.data.StoreManager.lookup('stateStore')
			 },{
			 	fieldLabel : '업무구분',		
			 	name : 'WORK_GUBUN',
			 	xtype:'uniCombobox',
			 	store:Ext.data.StoreManager.lookup('workGubunStore')
			 }
		]})
		
		// create the Grid
		var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
			region : 'center',
			uniOpt:{
				expandLastColumn:false, 
				useRowNumberer:true
			},
			tbar:[
				{
					xtype:'component',
					html:'그룹항목 : '
				},{
					xtype:'button',
					text:'프로젝트',
					handler:function()	{
						directMasterStore.setGroupField('PROJECT')
					}
				},{
					xtype:'button',
					text:'모듈',
					handler:function()	{
						directMasterStore.setGroupField('MODULE')
					}
				},{
					xtype:'button',
					text:'개발자',
					handler:function()	{
						directMasterStore.setGroupField('DEV_NAME')
					}
				},{
					xtype:'button',
					text:'업무구분',
					handler:function()	{
						directMasterStore.setGroupField('WORK_GUBUN')
					}
				}
			],
			features: [{ftype:'grouping'}],
			selModel:'rowmodel',
			store: directMasterStore,
	        itemId:'${PKGNAME}Grid',
			columns : [   {dataIndex : 'WORK_ID',			width : 80,
							editor:{
								xtype:'textfield',
								triggers: {
							        search: {
							            weight: 1,
							            cls: Ext.baseCSSPrefix + 'form-search-trigger',
							            handler: function()	{
							            	openRequest(masterGrid.getSelectedRecord());
							            },
							            scope: 'this'
							        }
								}
							}
						  }	
						, {dataIndex : 'SEQ',		width : 60		}
						, {dataIndex : 'TITLE',			flex : .5		}
						, {dataIndex : 'REQ_NAME',		width : 100		}
						, {dataIndex : 'REQ_DATE',		width : 80		}
						, {dataIndex : 'PROJECT',		width : 120		}
						, {dataIndex : 'MODULE',		width : 80		}	
						, {dataIndex : 'WORK_GUBUN',		width : 80		}
						, {dataIndex : 'DEV_NAME',		width : 80		}
						, {dataIndex : 'WORK_STATE',		width : 80		}
						, {dataIndex : 'WORK_DATE_START',		width : 80		}
						, {dataIndex : 'WORK_DATE_END',		width : 80		}
					],
			listeners: {          	
				beforeedit:function(editor, context, eOpts) {
					if(context.field =="WORK_ID" && !context.record.phantom)	{
						return false;
					}
				}
			}	
		});
		
    Unilite.Main({
    		 id  : 'wps110ukrvApp',
			 borderItems : [ panelSearch, masterGrid ]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'newData'],true);
			}
			, onQueryButtonDown:function() {
				masterGrid.getStore().loadStoreRecords();
			}
			, onNewDataButtonDown : function()	{
				var r = masterGrid.createRow();
				
			}
			, onSaveDataButtonDown: function () {	
				directMasterStore.saveStore();	
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
//					}
				}	
			
		});
		
};	// appMain
</script>