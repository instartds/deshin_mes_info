<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//개발요청등록
request.setAttribute("PKGNAME","Unilite_app_wps200ukrv");
%>
<t:appConfig pgmId="wps200ukrv" >
<t:ExtComboStore comboType="AU" 			comboCode="B908" /> <!-- project Store -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript">
function appMain() {

	<%@include file="./wpsCommonModel.jsp" %>	
	
		Unilite.defineModel('${PKGNAME}MasterModel', {
			fields : [  
				 {name : 'WORK_ID',			text : '작업번호',	type : 'uniNumber'}
				,{name : 'WORK_ID_TITLE',			text : '작업 제목',		type : 'string', editable:false }
				,{name : 'SEQ',				text : '순번',	type : 'uniNumber', editable:false}
				,{name : 'TITLE',			text : '테스트 제목',		type : 'string' }
				,{name : 'TESTER_NAME',		text : '테스터',	type : 'string'  ,store:Ext.data.StoreManager.lookup('empStore')}
				,{name : 'STATE',			text : '진행상태',	type : 'string'  ,store:Ext.data.StoreManager.lookup('testStateStore')}
				,{name : 'TEST_DATE',		text : '테스트일',	type : 'uniDate' }
				,{name : 'REMARK',			text : '비고',		type : 'string' }
			]
					 
		});
	
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 	 'wps200ukrvService.selectList',
				create : 'wps200ukrvService.insert',
				update : 'wps200ukrvService.update',
				destroy: 'wps200ukrvService.delete',
				syncAll: 'wps200ukrvService.saveAll'
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
				var param= Ext.getCmp('wps200ukrvSearchForm').getValues();
				
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
	
	
	var panelSearch = Unilite.createSearchForm('wps200ukrvSearchForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			 {
			 	fieldLabel : '테스트일',		
			 	xtype:'uniDateRangefield',
			 	startFieldName: 'TEST_DATE_FR',
                endFieldName: 'TEST_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
			 },{
			 	fieldLabel : '테스터',		
			 	name : 'TESTER_NAME',
			 	xtype:'uniCombobox',
			 	store:Ext.data.StoreManager.lookup('empStore')
			 },{
			 	fieldLabel : '테스트 제목',			
			  	name : 'TITLE',
			  	width:330
			 },{
			 	fieldLabel : '작업번호',		
			 	name : 'WORK_ID'
			 }
		]})
		
		
		// create the Grid
		var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
			region : 'center',
			uniOpt:{expandLastColumn:false, useContextMenu:true, copiedRow:true},
			store: directMasterStore,
	        itemId:'${PKGNAME}Grid',
			columns : [   {dataIndex : 'WORK_ID',			width : 80		,
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
						, {dataIndex : 'WORK_ID_TITLE',	width:300		}
						, {dataIndex : 'SEQ',			width:50		}
						, {dataIndex : 'TITLE',			width:300		}
						, {dataIndex : 'TESTER_NAME',		width : 100		}
						, {dataIndex : 'TEST_DATE',		width : 100		}
						, {dataIndex : 'STATE',		width : 100		}
						, {dataIndex : 'REMARK',		flex:1	}	
					],
			listeners: {  
				beforeedit:function(editor, context, eOpts) {
					if(context.field =="WORK_ID" && !context.record.phantom)	{
						return false;
					}
					
				}
			}		
		});
		
	/* 작업번호 팝업 */
	var reqWindow;
	
	Unilite.defineModel('reqModel', {
		fields : [ {name : 'WORK_ID',		text : '작업번호',	type : 'string'}				 				 
				 , {name : 'TITLE',			text : '제목',		type : 'string'  }
				 , {name : 'WORK_CONTENT',	text : '내용',		type : 'string'	 }
				 , {name : 'DOC_ID',		text : '문서번호',	type : 'string'  }
				 , {name : 'TEST_STATE',	text : '테스트진행상태',	type : 'string' ,store:Ext.data.StoreManager.lookup('testStateStore') }
				 , {name : 'REQ_DATE',		text : '요청일',	type : 'uniDate'  }
				 , {name : 'REQ_NAME',		text : '요청자',	type : 'string'  ,store:Ext.data.StoreManager.lookup('empStore')}
				 , {name : 'PROJECT',		text : '프로젝트',	type : 'string'    ,comboType:"AU"	,comboCode:"B908"}
				 , {name : 'MODULE',		text : '모듈',	type : 'string'   ,comboType:'AU', comboCode:'B007'}
				 , {name : 'WORK_GUBUN',	text : '업무구분',	type : 'string'   ,store:Ext.data.StoreManager.lookup('workGubunStore')}
				 , {name : 'REMARK',		text : '비고',		type : 'string'  }
				]
	});
	var reqStore = Unilite.createStore('reqStore', { 
		model : 'reqModel',
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
				read : 	 'wps100ukrvService.selectReqDevList'
			}
        },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('reqSearchForm').getValues();	
			this.load({
				params : param
			});
		}
	});
	
	var reqViewStore = Unilite.createStore('reqStore', { 
		model : 'reqModel',
		data:[]
	});
	
	var reqSearch = Unilite.createSearchForm('reqSearchForm',{
    	//region: 'north',
    	id:'reqSearchForm',
		layout : {type : 'uniTable', columns : 2},
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
		
	
	function fnEmpConvert(value)	{
		var rText = value;
		Ext.each(empStore.getData().items, function(item){
			if(item.get("value") == value)	{
				rText = item.get("text");
			}
		})
		return rText;
	}	
	
	function fnStateConvert(value)	{
		var rText = value;
		Ext.each(stateStore.getData().items, function(item){
			if(item.get("value") == value)	{
				rText = item.get("text");
			}
		})
		return rText;
	}
	function fnReqDateConvert(value)	{
		return UniDate.safeFormat(value);
	}
	 Unilite.defineModel('pDevModel', {
		fields : [ {name : 'WORK_ID',			text : '작업번호',	type : 'uniNumber'	, editable: true , allowBlank:false}	
				 , {name : 'DEV_NAME',			text : '개발자',	type : 'string' 	, editable: true,  allowBlank:false	,convert:fnEmpConvert, editable: true }
			 	 , {name : 'WORK_STATE',		text : '진행상태',	type : 'string'  	, editable: false,	convert:fnStateConvert}
				 , {name : 'WORK_DATE_START',	text : '개발시작일',	type : 'uniDate', editable: false, convert:fnReqDateConvert}
				 , {name : 'WORK_DATE_END',		text : '개발종료일',	type : 'uniDate', editable: false, convert:fnReqDateConvert}
				 ]
	});
		
	var reqGrid = Unilite.createGrid('reqGrid', {
		selModel:'rowmodel',
		uniOpt:{
			expandLastColumn:false, 
			useRowNumberer:false
		},
		plugins: [{
	        ptype: 'rowwidget',
        	widget: {
                xtype: 'grid',
                title:'개발진행',
                bind:{
                	store:{model: 'pDevModel', data:'{record.DEV}'}
                },
                columns : [   
					  {dataIndex : 'DEV_NAME',	text:'개발자',	flex:.25	}
					, {dataIndex : 'WORK_STATE',		text:'진행상태',	flex:.25		}
					, {dataIndex : 'WORK_DATE_START',	text:'개발시작일',	flex:.25	}
					, {dataIndex : 'WORK_DATE_END',	text:'개발종료일',	flex:.25	}
				]
        	},
        	onWidgetAttach: function (plugin, bodyComponent, record) {
                //plugin[0].widget.store.loadData(record.get("DEV"))
            }
        }],
		flex:.7,
		store: reqStore,
		columns : [   {dataIndex : 'WORK_ID',		width : 80		}					
					, {dataIndex : 'TITLE',			flex : 1		}
					, {dataIndex : 'REQ_NAME',		width : 80		}
					, {dataIndex : 'REQ_DATE',		width : 80		}
					, {dataIndex : 'PROJECT',		width : 80		}
					, {dataIndex : 'MODULE',		width : 80		}
					, {dataIndex : 'WORK_GUBUN',		width : 80		}
					, {dataIndex : 'TEST_STATE',	width : 100		}
		],
		listeners:{
			selectionchange:function(grid,selected)	{
			
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
      			reqGrid.setData(record);
									  					
			}
		},
		setData:function(record)	{
			if(reqWindow.record && reqWindow.record.phantom) {	
				if(record.get("TEST_STATE") == '03')	{
					alert('테스트가 완료된 요청입니다.')
					return;
				}
				reqWindow.record.set('WORK_ID', record.get("WORK_ID"));
				reqWindow.record.set('WORK_ID_TITLE', record.get("TITLE"));
				reqWindow.record.set('REQ_NAME', record.get("REQ_NAME"));
				reqWindow.record.set('REQ_DATE', record.get("REQ_DATE"));
				reqWindow.record.set('PROJECT', record.get("PROJECT"));
				reqWindow.record.set('MODULE', record.get("MODULE"));
				reqWindow.record.set('WORK_GUBUN', record.get("WORK_GUBUN"));
  			}
  			reqWindow.hide();
		}
		
	});
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
                	reqGrid
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
						
        			},
        			beforeclose: function( panel, eOpts )	{
						reqWindow.down('#reqSearchForm').clearForm();
						reqStore.loadData({});
						
        			},
        			show: function( panel, eOpts )	{
						var form = reqWindow.down('#reqSearchForm');
						
						form.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
                		form.setValue('REQ_DATE_TO', UniDate.get('today'));
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
	
    Unilite.Main({
    		 id  : 'wps200ukrvApp',
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