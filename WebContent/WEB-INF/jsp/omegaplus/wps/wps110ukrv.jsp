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
		fields : [ {name : 'WORK_ID',		text : '작업번호',	type : 'uniNumber'	, allowBlank:false}	
				 , {name : 'SEQ',			text : '순번',		type : 'uniNumber'	, editable:false}	
				 , {name : 'TITLE',			text : '제목',		type : 'string'   	, editable:false}
				 , {name : 'REQ_NAME',		text : '요청자',		type : 'string'	,store:Ext.data.StoreManager.lookup('empStore')}
				 , {name : 'DEV_NAME',		text : '개발자',		type : 'string' , allowBlank:false	,store:Ext.data.StoreManager.lookup('empStore') }
				 , {name : 'DEV_CONTENT',	text : '개발내용',		type : 'string'	 }
				 , {name : 'WORK_STATE',	text : '진행상태',	type : 'string'  	, allowBlank:false,store:Ext.data.StoreManager.lookup('stateStore')}
				 , {name : 'WORK_DATE_START',text : '개발일시작일',	type : 'uniDate'  	, allowBlank:false}
				 , {name : 'WORK_DATE_END'	,text : '개발일종료일',	type : 'uniDate'  	}
				 , {name : 'SQL_DOC_ID',	text : 'SQL문서번호',	type : 'string' }
				 , {name : 'PGM_ID',		text : '프로그램ID',	type : 'string'}
		 		 , {name : 'ADD_FIDS',		text : '추가파일',		type : 'string'  }
				 , {name : 'DEL_FIDS',		text : '삭제파일',		type : 'string'  }
				]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 	 'wps110ukrvService.selectList',
			create : 'wps110ukrvService.insert',
			update : 'wps110ukrvService.update',
			destroy: 'wps110ukrvService.delete',
			syncAll: 'wps110ukrvService.saveAll'
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
			var param= Ext.getCmp('wps110ukrvSearchForm').getValues();	
			this.load({
				params : param
			});
		},
		saveStore : function()	{
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					var config = {
						//params:[{'WORK_ID':'3', 'SEQ':0}],
						success : function(batch, option)	{
							if(pgmStore.isDirty())	{
								pgmStore.saveStore();
							} else {
								UniAppManager.app.setToolbarButtons('save',false);
							}
						}
					}
					this.syncAllDirect(config);			
				}else {
					var grid = Ext.getCmp('${PKGNAME}Grid');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			
		},
		listeners:{
			update:function(store, record, operation, modifiedFieldNames, details, eOpts )	{
				masterForm.setActiveRecord(record);
			}
		}
	});

	Unilite.defineModel('${PKGNAME}PgmModel', {
		fields : [ {name : 'WORK_ID',		text : '작업번호',		type : 'uniNumber', editable:false, allowBlank:false}	
				 , {name : 'SEQ',			text : '순번',			type : 'uniNumber', editable:false, allowBlank:false}	
				 , {name : 'FILE_SEQ',		text : '파일순번',		type : 'uniNumber', editable:false}
				 , {name : 'PGM_ID',		text : '프로그램ID',	type : 'string'}
				 , {name : 'FILE_PATH',		text : '파일경로',		type : 'string'  , allowBlank:false}
				 , {name : 'FILE_NAME',		text : '파일명',		type : 'string'	 , allowBlank:false}
				 , {name : 'EDIT_STATE',	text : '변경',			type : 'string'  , allowBlank:false	,store:Ext.data.StoreManager.lookup('editStateStore') }
				 , {name : 'WORK_DATE',		text : '개발일',		type : 'uniDate'  }
				 , {name : 'SQL_DOC_ID',	text : 'SQL 문서 ID',	type : 'string' }
				]
	});
	
	var pgmDirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 	 'wps110ukrvService.selectPgmList',
			create : 'wps110ukrvService.insertPgm',
			update : 'wps110ukrvService.updatePgm',
			destroy: 'wps110ukrvService.deletePgm',
			syncAll: 'wps110ukrvService.saveAllPgm'
		}
	});
	
	var pgmStore = Unilite.createStore('${PKGNAME}PgmStore', { 
		model : '${PKGNAME}PgmModel',
		autoLoad : false,
		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
		proxy : pgmDirectProxy,
		loadStoreRecords : function()	{
			var param= masterGrid.getSelectedRecord();	
			this.load({
				params : {'WORK_ID':param.get("WORK_ID"), 'SEQ':param.get("SEQ")}
			});
		},
		saveStore : function()	{
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
					var config = {
						success : function(batch, option)	{
							UniAppManager.app.setToolbarButtons('save',false);
						}
					}
					this.syncAllDirect(config);			
				}else {
					var grid = Ext.getCmp('pgmGrid');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			
		},
		listeners:{
			add:function()	{
				UniAppManager.setToolbarButtons('save',true);
			},
			update:function()	{
				UniAppManager.setToolbarButtons('save',true);
			},
			remove:function()	{
				UniAppManager.setToolbarButtons('save',true);
			}
		}
	});
	
	
	
	Unilite.defineModel('pgmSeachModel', {
		fields : [ {name : 'PGM_ID',			text : '프로그램ID',		type : 'string'}				 				 
				 , {name : 'PGM_NAME',			text : '프로그램명',		type : 'string'  }
				 , {name : 'PGM_SEQ',			text : '모듈',				type : 'string'	 ,comboType:'AU', comboCode:'B008'}
				 , {name : 'CLASS_PATH',		text : 'Service Path',		type : 'string'  }
				 , {name : 'JSP_PATH',			text : 'JSP Path',			type : 'string'  }
				 , {name : 'SERVICE_FILE',		text : 'Service 파일',		type : 'string'  }
				 , {name : 'SQL_FILE',			text : 'Sql 파일',			type : 'string'  }
				 , {name : 'CONTROLLER_FILE',	text : 'Controller 파일',	type : 'string'  }
				 , {name : 'JSP_FILE',			text : 'JSP 파일',			type : 'string'  }
				 , {name : 'CLASS_YN',			text : 'Service 파일',		type : 'bool'  }
				 , {name : 'SQL_YN',			text : 'Sql 파일',			type : 'bool'  }
				 , {name : 'CONTROLLER_YN',		text : 'Controller 파일',	type : 'bool'  }
				 , {name : 'JSP_YN',			text : 'JSP 파일',			type : 'bool'  }
				]
	});
	var pgmSearchStore = Unilite.createStore('rpgmSearchStore', { 
		model : 'pgmSeachModel',
		autoLoad : false,
		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
		proxy: {
            type: 'direct',
            api: {
				read : 	 'wps110ukrvService.selectPgmSearch'
			}
        },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('pgmSearchForm').getValues();	
			this.load({
				params : param
			});
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
			 	fieldLabel : '개발종료일',		
			 	xtype:'uniDateRangefield',
			 	startFieldName: 'DEV_DATE_END_FR',
                endFieldName: 'DEV_DATE_END_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
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
			 	fieldLabel : '제목',			
			  	name : 'TITLE'
			 }
		]})
		
		// create the Grid
		var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
			region : 'center',
			uniOpt:{
				expandLastColumn:false, 
				useRowNumberer:true
			},
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
						, {dataIndex : 'PGM_ID',		width : 100		}
						, {dataIndex : 'DEV_NAME',		width : 80		}
						, {dataIndex : 'WORK_DATE_START',		width : 100		}
						, {dataIndex : 'WORK_DATE_END',		width : 100		}
						, {dataIndex : 'WORK_STATE',		width : 100		}
						, {dataIndex : 'REQ_NAME',		width : 80		}
					],
			listeners: {          	
				beforeedit:function(editor, context, eOpts) {
					if(context.field =="WORK_ID" && !context.record.phantom)	{
						return false;
					}
				},
				edit:function(editor)	{
					masterForm.setActiveRecord(editor.context.record);
				},
				selectionchange:function(grid,selectedRecord)	{
					var selected;
					var fp = Ext.getCmp('wps110ukrvFileUploadPanel');
					fp.clear();
					if(selectedRecord && selectedRecord.length > 0	)	{
						selected = selectedRecord[0];
					}
          			masterForm.setActiveRecord(selected);
          			if(selected)	{
          				pgmStore.loadStoreRecords();
				   
          				if(!Ext.isEmpty(selected.get('SQL_DOC_ID'))) {
	       					var docNo=selected.get('SQL_DOC_ID');
	       					fp.mask('로딩중...');
					   	 	bdc100ukrvService.getFileList({DOC_NO : docNo},
								function(provider, response) {
									var fp = Ext.getCmp('wps110ukrvFileUploadPanel');
									fp.loadData(response.result);
									fp.unmask();
								}
						 	)
	       				} 
	       				
          			} else {
          				
          			}
				}
			}	
		});
		var pgmGrid = Unilite.createGrid('pgmGrid', {
			flex:1,
			uniOpt:{expandLastColumn:false, useContextMenu:true, copiedRow:true},
			store: pgmStore,
	        itemId:'pgmGrid',
	        tbar:[
				{
					xtype:'button',
					text:'추가',
					handler:function() {
						pgmGrid.createRow();
					}
				},{
					xtype:'button',
					text:'삭제',
					handler:function() {
						pgmGrid.deleteSelectedRow();
					}
				}
			],
	 		uniOpt:{
	 			expandLastColumn:false, 
				useRowNumberer:false, 
				state: {
					useState: false,			
					useStateList: false		
				}
	 		},
			columns : [   
						  {dataIndex : 'PGM_ID',		width:100		}
						, {dataIndex : 'FILE_PATH',		flex:1		}
						, {dataIndex : 'FILE_NAME',		width : 170		}
						, {dataIndex : 'EDIT_STATE',		width : 80		}
						
					]
				
		});
		
		var masterForm  = Unilite.createForm('detailForm', {
			region:'south',
			height:400,
	    	masterGrid: masterGrid,
	        autoScroll:true,
	        border: false,      
	        uniOpt:{
	        	store : directMasterStore
	        },
		    //for Form      
		    layout: {
		    	type: 'uniTable',
		    	columns: 5
		    }, 
		    masterGrid: masterGrid,
		    
		    items : [
		    	  { fieldLabel: '순번'			, name : 'SEQ',			  	width:300,	readOnly:true		}
		    	, { fieldLabel: '개발자'		, name : 'DEV_NAME'		,	width:300,	xtype:'uniCombobox'	, allowBlank:false,store:Ext.data.StoreManager.lookup('empStore')}
				, { fieldLabel: '개발시작일'	, name : 'WORK_DATE_START',	width:300,	xtype:'uniDatefield'	, allowBlank:false}
				, { fieldLabel: '개발종료일'	, name : 'WORK_DATE_END',	width:300,	xtype:'uniDatefield'	, allowBlank:false}
				, { fieldLabel: '진행상태'		, name : 'WORK_STATE',		width:300,	xtype:'uniCombobox'	, allowBlank:false	,store:Ext.data.StoreManager.lookup('stateStore')}
				, { fieldLabel: '개발내용'		, name : 'DEV_CONTENT'	,	xtype:'textarea',	colspan:5,width : 1500, height:100		}
				, { fieldLabel: '프로그램ID'	, name : 'PGM_ID'		,colspan:5,
					xtype:'textfield',
					triggers: {
				        search: {
				            weight: 1,
				            cls: Ext.baseCSSPrefix + 'form-search-trigger',
				            handler: function()	{
				            	openPgmSearch(masterGrid.getSelectedRecord());
				            },
				            scope: 'this'
				        }
					}
				  }	
				, { xtype:'panel',
					title:'변경 프로그램 목록',
					layout:{type:'vbox', align:'stretch'},
					items:[pgmGrid],
					height:200,
					colspan:3
					}
				, {
					title:'SQL DDL',
	     			xtype:'xuploadpanel',
	     			id : 'wps110ukrvFileUploadPanel',
			    	itemId:'wps110ukrvFileUploadPanel',
			    	colspan : 2,
			    	flex:1,
			    	height:200,
			    	listeners : {
			    		change: function() {
							UniAppManager.setToolbarButtons('save',true);
			    		}
			    	},
			    	setData:function()	{
			    		var fp = Ext.getCmp('wps110ukrvFileUploadPanel');
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
	
	
	/*var reqSearch = Unilite.createSearchForm('reqSearchForm',{
    	//region: 'north',
    	id:'reqSearchForm',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
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
			 	fieldLabel : '작업번호',		
			 	name : 'WORK_ID'
			 },{
			 	fieldLabel : '내용',			
			 	name : 'WORK_CONTENT'
			 }
		]})
		
	var reqGrid = Unilite.createGrid('reqGrid', {
		selModel:'rowmodel',
		uniOpt:{
			expandLastColumn:false, 
			useRowNumberer:false
		},
		flex:.7,
		store: reqStore,
		columns : [   {dataIndex : 'WORK_ID',		width : 80		}					
					, {dataIndex : 'TITLE',			flex : 1		}
					, {dataIndex : 'REQ_NAME',		width : 80		}
					, {dataIndex : 'REQ_DATE',		width : 80		}
		],
		listeners:{
			selectionchange:function(grid,selected)	{
				if(selected && selected.length>0)	{
					var selRecord =selected[0];
					reqViewStore.loadData([selRecord]);					
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
      			reqGrid.setData(record);
				reqWindow.hide();
									  					
			}
		},
		setData:function(record)	{
			if(reqWindow.record && reqWindow.record.phantom) {	
				reqWindow.record.set('WORK_ID', record.get("WORK_ID"));
				reqWindow.record.set('TITLE', record.get("TITLE"));
				Ext.getBody().mask("Loading..")
				wps110ukrvService.maxId(record.data, function(responseText, response) {
					reqWindow.record.set("SEQ", responseText['SEQ']);
					Ext.getBody().unmask()
				})
  			}
		}
		
	});

	var reqViewTpl = new Ext.XTemplate(
	 '<tpl for=".">' ,
	 '<div class="req-source">',
    '<table cellspacing="1" cellpadding="3" border="0" height="300" width="498" style="border: #99bce8 solid 1px;bgcolor:#eeeeee;">' ,
			'<tr class="x-grid-row">' ,
			'	 <td width="70" align="right" class="x-column-header x-column-header-inner" style="vertical-align:middle;">제목</td>' ,
			'	 <td width="428" style="vertical-align:middle;border-bottom: #eee solid 1px;">{TITLE}</td>' ,
			'</tr>',
			'<tr class="x-grid-row">' ,
			'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">요청자</td>' ,
			'	 <td width="428" style="vertical-align:middle;border-bottom: #eee solid 1px;">{REQ_NAME}</td>' ,
			'</tr>',
			'<tr class="x-grid-row x-grid-with-row-lines">' ,
			'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">요청일</td>' ,
			'	 <td width="428" style="vertical-align:middle;border-bottom: #eee solid 1px;">{REQ_DATE}</td>' ,
			'</tr>',
			'<tr class="x-grid-row x-grid-with-row-lines">' ,
			'	 <td width="70" align="right" class="x-column-header x-column-header-inner" height="100%" style="vertical-align:top;"   >내용</td>' ,
			'	 <td width="428" style="vertical-align:top;border-bottom: #eee solid 1px;" >{WORK_CONTENT}</td>' ,
			'</tr>',
    '</table>',
    '</div>',
    '</tpl>'
	);
	var reqView = Ext.create('Ext.view.View', {
		tpl:reqViewTpl,
        store: reqViewStore,
        height:300,
        style:{
        		'background-color': '#fff' ,
        		'border': '1px'
        },
        itemSelector: 'div.req-source',
        overItemCls: 'req-source',
        selectedItemClass: 'req-source',
        disableSelection :true
    });
  
    var reqFile = {
		xtype:'xuploadpanel',
		id : 'wps100ukrvFileUploadPanel',
    	itemId:'wps100ukrvFileUploadPanel',
    	uniOpt: {
			isDirty : false,
			isLoading: false,
			autoStart: false,
			editable: false,
			maxFileNumber: -1	
		},
    	flex:.3
	}
	function openRequest(record)	{
	    if(!reqWindow) {
			reqWindow = Ext.create('widget.uniDetailWindow', {
                title: '개발요청',
                width: 800,				                
                height:800,
            	record : record,
                layout: {type:'vbox', align:'stretch'},	                
                items: [
                	reqSearch,
                	reqGrid, 
                	reqView, 
                	reqFile
				],
                tbar:  [
			         '->',{
						itemId : 'searchBtn',
						text: '조회',
						handler: function() {
							
							reqStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'submitBtn',
						text: '확인',
						handler: function() {
							var record = reqGrid.getSelectedRecord();
			      			reqGrid.setData(record);
							reqWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							reqWindow.hide();
						},
						disabled: false
					}
			    ],
				listeners : {
					beforehide: function(me, eOpt)	{
						reqWindow.down('#reqSearchForm').clearForm();
						reqStore.loadData({});
						reqViewStore.loadData({});
						var fp = Ext.getCmp('wps100ukrvFileUploadPanel');
						fp.clear();
        			},
        			beforeclose: function( panel, eOpts )	{
						reqWindow.down('#reqSearchForm').clearForm();
						reqStore.loadData({});
						reqViewStore.loadData({});
						var fp = Ext.getCmp('wps100ukrvFileUploadPanel');
						fp.clear();
        			},
        			show: function( panel, eOpts )	{
						var form = reqWindow.down('#reqSearchForm');
						form.setValues( panelSearch.getForm().getValues());	
						if(reqWindow.record && reqWindow.record.get("WORK_ID"))	{
							form.setValue("WORK_ID", reqWindow.record.get("WORK_ID"))
							reqStore.loadStoreRecords();
						}
        			}
                }		
			});
	    }	
	    reqWindow.record = record
		reqWindow.center();
		reqWindow.show();
	}
	*/
	var pgmSearch = Unilite.createSearchForm('pgmSearchForm',{
    	//region: 'north',
    	id:'pgmSearchForm',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [
			 {
			 	fieldLabel : '프로그램ID',		
			 	name : 'PGM_ID'
			 },{
			 	fieldLabel : '프로그램명',			
			  	name : 'PGM_NAME'
			 }
		]})
		
	var pgmSearchGrid = Unilite.createGrid('pgmSearchGrid', {
		selModel:Ext.create("Ext.selection.CheckboxModel", { checkOnly : true , mode:'MULTI'}),
		uniOpt:{
			expandLastColumn:false, 
			useRowNumberer:false,
			onLoadSelectFirst:false
		},
		flex:1,
		itemId:'pgmSearchGrid',
		store: pgmSearchStore,
		columns : [   {dataIndex : 'PGM_ID',		width : 100		}					
					, {dataIndex : 'PGM_NAME',			flex : 1		}
					, {dataIndex : 'CLASS_YN',			xtype:'checkcolumn' ,		width : 100}
				 	, {dataIndex : 'SQL_YN',			xtype:'checkcolumn'  ,		width : 100}
				 	, {dataIndex : 'CONTROLLER_YN',		xtype:'checkcolumn'  ,		width : 100}
				 	, {dataIndex : 'JSP_YN',			xtype:'checkcolumn'  ,		width : 100}
		],
		listeners:{
			onGridDblClick:function(grid, record, cellIndex, colName) {
				grid.applyData([record]);
				reqWindow.hide();			
			}
		},
		applyData:function(records)	{
			var masterRecord = masterGrid.getSelectedRecord();
			Ext.each(records, function(record, idx){
				if(record.get("CLASS_YN"))	{
					var rec = {
						'WORK_ID' : masterRecord.get("WORK_ID"),
						'SEQ' :  masterRecord.get("SEQ"),
						'PGM_ID':record.get("PGM_ID"),
						'FILE_PATH' : record.get("CLASS_PATH"),
						'FILE_NAME' : record.get("SERVICE_FILE")
					};
	      			pgmGrid.createRow(rec);
				}
				if(record.get("SQL_YN"))	{
					var rec = {
						'WORK_ID' : masterRecord.get("WORK_ID"),
						'SEQ' :  masterRecord.get("SEQ"),
						'PGM_ID':record.get("PGM_ID"),
						'FILE_PATH' : record.get("CLASS_PATH"),
						'FILE_NAME' : record.get("SQL_FILE")
					};
	      			pgmGrid.createRow(rec);
				}
				if(record.get("CONTROLLER_YN"))	{
					var rec = {
						'WORK_ID' : masterRecord.get("WORK_ID"),
						'SEQ' :  masterRecord.get("SEQ"),
						'PGM_ID':record.get("PGM_ID"),
						'FILE_PATH' : record.get("CLASS_PATH"),
						'FILE_NAME' : record.get("CONTROLLER_FILE")
					};
	      			pgmGrid.createRow(rec);
				}
				if(record.get("JSP_YN"))	{
					var rec = {
						'WORK_ID' : masterRecord.get("WORK_ID"),
						'SEQ' :  masterRecord.get("SEQ"),
						'PGM_ID':record.get("PGM_ID"),
						'FILE_PATH' : record.get("JSP_PATH"),
						'FILE_NAME' : record.get("JSP_FILE")
					};
	      			pgmGrid.createRow(rec);
				}	
				if(idx == 0)	{
					masterRecord.set("PGM_ID", record.get("PGM_ID"))
					masterForm.setValue("PGM_ID", record.get("PGM_ID"))
				}
			});
		}		
	});
  	function openPgmSearch(record)	{
	    if(!pgmSearchWindow) {
			pgmSearchWindow = Ext.create('widget.uniDetailWindow', {
                title: '프로그램조회',
                width: 800,				                
                height:500,
            	record : record,
                layout: {type:'vbox', align:'stretch'},	                
                items: [
                	pgmSearch,
                	pgmSearchGrid
				],
                tbar:  [
			         '->',{
						itemId : 'searchBtn',
						text: '조회',
						handler: function() {
							
							pgmSearchStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'submitBtn',
						text: '확인',
						handler: function() {
							var pgmSearchGrid = pgmSearchWindow.down('#pgmSearchGrid')
							var records = pgmSearchGrid.getSelectedRecords();
							pgmSearchGrid.applyData(records);
							pgmSearchWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							pgmSearchWindow.hide();
						},
						disabled: false
					}
			    ],
				listeners : {
					beforehide: function(me, eOpt)	{
						pgmSearchWindow.down('#pgmSearchForm').clearForm();
						pgmSearchStore.loadData({});
						
        			},
        			beforeclose: function( panel, eOpts )	{
						pgmSearchWindow.down('#pgmSearchForm').clearForm();
						pgmSearchStore.loadData({});
						
        			},
        			show: function( panel, eOpts )	{
						var form = pgmSearchWindow.down('#pgmSearchForm');
						form.setValue('PGM_ID', masterForm.getValue("PGM_ID"));	
						pgmSearchStore.loadStoreRecords();
        			}
                }		
			});
	    }	
	    pgmSearchWindow.record = record
		pgmSearchWindow.center();
		pgmSearchWindow.show();
	}
    Unilite.Main({
    		 id  : 'wps110ukrvApp',
			 borderItems : [ panelSearch,
			 	/*{
				 	title:'개발요청',
				 	region:'west',
				  	width:500,
				  	layout:{type:'vbox', align:'stretch'},
				  	items:[]
				 },*/
				 {
				 	region:'center',
				  	layout:'border',
				  	flex:1,
				  	items:[ masterGrid , masterForm]
				  
				 }]
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
				var fp = Ext.getCmp('wps110ukrvFileUploadPanel');
				fp.setData();
				if(directMasterStore.isDirty())	{
					directMasterStore.saveStore();	
					
				}else if(pgmStore.isDirty())	{
					pgmStore.saveStore();
				}		
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