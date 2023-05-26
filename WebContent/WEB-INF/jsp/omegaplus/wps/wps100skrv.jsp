<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//개발요청등록
request.setAttribute("PKGNAME","Unilite_app_wps100skrv");
%>
<t:appConfig pgmId="wps100skrv" >
<t:ExtComboStore comboType="AU" 			comboCode="B007" /> 
<t:ExtComboStore comboType="AU" 			comboCode="B908" /> <!-- project Store -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript">
function appMain() {
	<%@include file="./wpsCommonModel.jsp" %>	
	
	function fnReqDateConvert(value)	{
		return UniDate.safeFormat(value);
	}
	
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
	
	function fnModuleConvert(value)	{
		var rText = value;
		var moduleStore = Ext.data.StoreManager.lookup('CBS_AU_B007');
		Ext.each(moduleStore.getData().items, function(item){
			if(item.get("value") == value)	{
				rText = item.get("text");
			}
		})
		return rText;
	}
	
	function fnWorkGubunConvert(value)	{
		var rText = value;
		Ext.each(workGubunStore.getData().items, function(item){
			if(item.get("value") == value)	{
				rText = item.get("text");
			}
		})
		return rText;
	}
	
	function fnProjectConvert(value)	{
		var rText = value;
		var projectStore = Ext.data.StoreManager.lookup('CBS_AU_B908');
		Ext.each(projectStore.getData().items, function(item){
			if(item.get("value") == value)	{
				rText = item.get("text");
			}
		})
		return rText;
	}
	
	Unilite.defineModel('reqModel', {
		fields : [ {name : 'WORK_ID',		text : '작업번호',	type : 'uniNumber', editable:false}				 				 
				 , {name : 'TITLE',			text : '제목',		type : 'string'  }
				 , {name : 'WORK_CONTENT',	text : '내용',		type : 'string'	 }
				 , {name : 'DOC_ID',		text : '문서번호',	type : 'string'  }
				 , {name : 'REQ_DATE',		text : '요청일',	type : 'uniDate'  }
				 , {name : 'REQ_NAME',		text : '요청자',	type : 'string'   ,convert:fnEmpConvert}
				 , {name : 'MODULE',		text : '모듈',	type : 'string'   ,convert:fnModuleConvert}
				 , {name : 'PROJECT',		text : '프로젝트',	type : 'string'   ,convert:fnProjectConvert}
				 , {name : 'WORK_GUBUN',	text : '업무구분',	type : 'string'   ,convert:fnWorkGubunConvert}
				 , {name : 'REMARK',		text : '비고',		type : 'string'  }
				]
	});
	
	
	Unilite.defineModel('devModel', {
		fields : [ 
			 {name : 'WORK_ID',		text : '작업번호',		type : 'uniNumber'}	
		 	,{name : 'SEQ',			text : '순번',			type : 'uniNumber'}	
		 	,{name : 'DEV_NAME',	text : '개발자',		type : 'string'   ,convert:fnEmpConvert}
		 	,{name : 'DEV_CONTENT',	text : '개발내용',		type : 'string'	  }
		 	,{name : 'WORK_STATE',	text : '진행상태',		type : 'string'  ,convert:fnStateConvert }
		 	,{name : 'WORK_DATE_START',	text : '개발시작일',		type : 'uniDate'  }
		 	,{name : 'WORK_DATE_END',	text : '개발종료일',		type : 'uniDate'  }
		 	,{name : 'SQL_DOC_ID',	text : 'SQL문서번호',	type : 'string'   }
		 	,{name : 'PGM_ID',		text : '프로그램ID',	type : 'string'}
		 	,{name : 'FILE_SEQ',	text : '파일순번',		type : 'uniNumber'}
		 	,{name : 'FILE_PATH',	text : '파일경로',		type : 'string'   }
		 	,{name : 'FILE_NAME',	text : '파일명',		type : 'string'	  }
		 	,{name : 'EDIT_STATE',	text : '파일변경',		type : 'string'  ,store:Ext.data.StoreManager.lookup('editStateStore')}
		]
	});


	Unilite.defineModel('testModel', {
		fields : [ 
			 {name : 'WORK_ID',		text : '작업번호',	type : 'uniNumber', editable:false}	
			,{name : 'TESTER_NAME',	text : '테스터',	type : 'string'  ,convert:fnEmpConvert}
			,{name : 'STATE',		text : '진행상태',	type : 'string'  ,convert:fnStateConvert}
			,{name : 'TEST_DATE',	text : '테스트일',	type : 'uniDate' }
			,{name : 'REMARK',		text : '비고',		type : 'string' }
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
				read : 	 'wps100ukrvService.selectList'
			}
        },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('wps100skrvSearchForm').getValues();	
			this.load({
				params : param
			});
		}
	});
	
	var reqViewStore = Unilite.createStore('reqStore', { 
		model : 'reqModel',
		data:[]
	});
	
	var devStore = Unilite.createStore('devStore', { 
		model : 'devModel',
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
				read : 	 'wps110ukrvService.selectPgm'
			}
        },
		loadStoreRecords : function(param)	{
			this.load({
				params : param
			});
		},
		listeners:{
			load:function(store,  records, successful, operation, eOpts ) 	{
				var fp = Ext.getCmp('sqlFileUploadPanel');
				fp.clear();
				var arr_doc_id = new Array();
				Ext.each(records, function(record, idx){
					var sqlDocId = record.get("SQL_DOC_ID").trim();
					if(!Ext.isEmpty(sqlDocId))	{
						arr_doc_id.push(sqlDocId);
						console.log("SQL_DOC_ID : ",sqlDocId)
					}
				});
				if(!Ext.isEmpty(arr_doc_id)) {
   					var docNo=arr_doc_id;
   					fp.mask('로딩중...');
			   	 	wps110ukrvService.getSQLList({ARR_DOC_NO : arr_doc_id},
						function(provider, response) {
							var fp = Ext.getCmp('sqlFileUploadPanel');
							fp.loadData(response.result);
							fp.unmask();
						}
				 	)
   				} 
			}
		}
	});
	
	
	var testStore = Unilite.createStore('testStore', { 
		model : 'testModel',
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
				read : 	 'wps200ukrvService.selectList'
			}
        },
		loadStoreRecords : function(param)	{
			this.load({
				params : param
			});
		}
	});
	
	var panelSearch = Unilite.createSearchForm('wps100skrvSearchForm',{
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		height:90,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			 {
			 	fieldLabel : '요청일',
			 	labelWidth:60,		
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
			 	store:Ext.data.StoreManager.lookup('empStore'),
			 	labelWidth:60,
			 	width:240
			 },{
			 	fieldLabel : '제목',			
			  	name : 'TITLE',
			 	labelWidth:40,
			 	width:240
			 },{
			 	fieldLabel : '개발자',		
			 	name : 'DEV_NAME',
			 	xtype:'uniCombobox',
			 	store:Ext.data.StoreManager.lookup('empStore'),
			 	labelWidth:60,
			 	width:240
			 },{
			 	fieldLabel : '내용',			
			 	name : 'WORK_CONTENT',
			 	labelWidth:40,
			 	width:240
			 }
		]})
		
		/* 개발요청 */
		// create the Grid
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
						reqViewStore.loadData([selRecord])
						var param = {
							'WORK_ID':selRecord.get('WORK_ID')
						}
						devStore.loadStoreRecords(param);
						testStore.loadStoreRecords(param);
						var fp = Ext.getCmp('wps100ukrvFileUploadPanel');
						fp.clear();
						if(!Ext.isEmpty(selRecord.get('DOC_ID'))) {
	       					var docNo=selRecord.get('DOC_ID');
	       					fp.mask('로딩중...');
					   	 	bdc100ukrvService.getFileList({DOC_NO : docNo},
								function(provider, response) {
									var fp = Ext.getCmp('wps100ukrvFileUploadPanel');
									fp.loadData(response.result);
									fp.unmask();
								}
						 	)
	       				} 
					}
				}
			}
			
		});
	
		var reqViewTpl = new Ext.XTemplate(
		 '<tpl for=".">' ,
		 '<div class="req-source">',
	    '<table cellspacing="1" cellpadding="3" border="0" height="300" width="498" style="border: #99bce8 solid 1px;bgcolor:#eeeeee;">' ,
				'<tr class="x-grid-row">' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner" style="vertical-align:middle;">제목</td>' ,
				'	 <td width="428" colspan="5" style="vertical-align:middle;border-bottom: #eee solid 1px;">{TITLE}</td>' ,
				'</tr>',
				'<tr class="x-grid-row">' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">요청자</td>' ,
				'	 <td width="80" style="vertical-align:middle;border-bottom: #eee solid 1px;">{REQ_NAME}</td>' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">요청일</td>' ,
				'	 <td width="80"  style="vertical-align:middle;border-bottom: #eee solid 1px;">{[this.convertDate(values.REQ_DATE)]}</td>' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">프로젝트</td>' ,
				'	 <td width="198" style="vertical-align:middle;border-bottom: #eee solid 1px;">{PROJECT}</td>',
				'</tr>',
				'<tr class="x-grid-row">' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">업무구분</td>' ,
				'	 <td width="80"  style="vertical-align:middle;border-bottom: #eee solid 1px;">{WORK_GUBUN}</td>' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">모듈</td>' ,
				'	 <td width="278" colspan="3" style="vertical-align:middle;border-bottom: #eee solid 1px;">{MODULE}</td>' ,
				'</tr>',
				'<tr class="x-grid-row x-grid-with-row-lines">' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner" height="100%" style="vertical-align:top;"   >내용</td>' ,
				'	 <td width="428" colspan="5"  style="vertical-align:top;border-bottom: #eee solid 1px;" >{WORK_CONTENT}</td>' ,
				'</tr>',
        '</table>',
        '</div>',
        '</tpl>',
        {
        	convertDate:function(date)	{
        		return UniDate.extFormatDate(date)
        	}
        }
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
    	itemId:'fileUploadPanel',
    	uniOpt: {
			isDirty : false,
			isLoading: false,
			autoStart: false,
			editable: false,
			maxFileNumber: -1	
		},
    	flex:.3
	}
	
	/* 개발진행 */
	// create the Grid
	var devViewTpl = new Ext.XTemplate(
		 '<tpl for=".">' ,
		 '<tpl if="FILE_SEQ == MIN_SEQ">',
		 '<div class="req-source">',
		 '<table cellspacing="1" cellpadding="3" border="0" width="100%" style="border: #99bce8 solid 1px;bgcolor:#eeeeee;">' ,
		 		'<tr class="x-grid-row">' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner" style="vertical-align:middle;">순번</td>' ,
				'	 <td width="100" style="vertical-align:middle;border-bottom: #eee solid 1px;">{SEQ}</td>' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">개발자</td>' ,
				'	 <td width="100" style="vertical-align:middle;border-bottom: #eee solid 1px;">{DEV_NAME}</td>' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">진행상태</td>' ,
				'	 <td width="100" style="vertical-align:middle;border-bottom: #eee solid 1px;">{WORK_STATE}</td>' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">개발시작일</td>' ,
				'	 <td width="100" style="vertical-align:middle;border-bottom: #eee solid 1px;">{[this.convertDate(values.WORK_DATE_START)]}</td>' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">개발종료일</td>' ,
				'	 <td width="100" style="vertical-align:middle;border-bottom: #eee solid 1px;">{[this.convertDate(values.WORK_DATE_END)]}</td>' ,
				'</tr>',
				'<tr class="x-grid-row x-grid-with-row-lines">' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">프로그램ID</td>' ,
				'	 <td width="90%" colspan="9" style="vertical-align:middle;border-bottom: #eee solid 1px;">{PGM_ID}</td>' ,
				'</tr>',
				'<tr class="x-grid-row x-grid-with-row-lines">' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">개발내용</td>' ,
				'	 <td width="90%" colspan="9" style="vertical-align:middle;border-bottom: #eee solid 1px;">{DEV_CONTENT}</td>',
				'</tr>',
				'<tr class="x-grid-row x-grid-with-row-lines">' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">프로그램목록</td>' ,
				'	 <td width="90%" colspan="9" style="vertical-align:top;border-bottom: #eee solid 1px;">',
			'</tpl>',
				'{FILE_PATH}{FILE_NAME}<br/>',
			'<tpl if="FILE_SEQ == MAX_SEQ">',
					'</td>' ,
				'</tr>',
	    '</table>',
	    '</tpl>',
	    '</div>',
	    '</tpl>',
	    {
        	convertDate:function(date)	{
        		return UniDate.extFormatDate(date)
        	}
        }
	);
	var devView = Ext.create('Ext.view.View', {
		tpl:devViewTpl,
        store: devStore,
        scrollable:true,
        flex:.7,
        style:{
        		'background-color': '#fff' ,
        		'border': '1px'
        },
        itemSelector: 'div.req-source',
        overItemCls: 'req-source',
        selectedItemClass: 'req-source',
        disableSelection :true
    });
    
    var sqlFile = {
		xtype:'xuploadpanel',
		id : 'sqlFileUploadPanel',
    	itemId:'fileUploadPanel',
    	flex:.3,
    	title:'SQL DDL',
    	uniOpt: {
			isDirty : false,
			isLoading: false,
			autoStart: false,
			editable: false,
			maxFileNumber: -1	
		}
    	
	}
	
	/* 테스트진행 */
	// create the Grid
	var testViewTpl = new Ext.XTemplate(
		 '<tpl for=".">' ,
		 '<div class="req-source">',
		 '<table cellspacing="1" cellpadding="3" border="0" width="100%" style="border: #99bce8 solid 1px;bgcolor:#eeeeee;">' ,
		 		'<tr class="x-grid-row">' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner" style="vertical-align:middle;">테스터</td>' ,
				'	 <td width="100" style="vertical-align:middle;border-bottom: #eee solid 1px;">{TESTER_NAME}</td>' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">테스트일</td>' ,
				'	 <td width="100" style="vertical-align:middle;border-bottom: #eee solid 1px;">{[this.convertDate(values.TEST_DATE)]}</td>' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">진행상태</td>' ,
				'	 <td width="100" style="vertical-align:middle;border-bottom: #eee solid 1px;">{STATE}</td>' ,
				'</tr>',
				'<tr class="x-grid-row x-grid-with-row-lines">' ,
				'	 <td width="70" align="right" class="x-column-header x-column-header-inner"  style="vertical-align:middle;">비고</td>' ,
				'	 <td width="90%" colspan="5" style="vertical-align:middle;border-bottom: #eee solid 1px;">{REMARK}</td>',
				'</tr>',
	    '</table>',
	    '</div>',
	    '</tpl>',
	    {
        	convertDate:function(date)	{
        		return UniDate.extFormatDate(date)
        	}
        }
	);
	var testView = Ext.create('Ext.view.View', {
		tpl:testViewTpl,
        store: testStore,
        scrollable:true,
        height:200,
        style:{
        		'background-color': '#fff' ,
        		'border': '1px'
        },
        itemSelector: 'div.req-source',
        overItemCls: 'req-source',
        selectedItemClass: 'req-source',
        disableSelection :true
    });
    Unilite.Main({
    		 id  : 'wps100skrvApp',
			 borderItems : [ 
				 {
				 	title:'개발요청',
				 	region:'west',
				  	width:500,
				  	layout:{type:'vbox', align:'stretch'},
				  	items:[panelSearch, reqGrid , reqView, reqFile]
				 },
				 {
				 	title:'개발진행상황',
				 	region:'center',
				  	flex:1,
				  	layout:{type:'vbox', align:'stretch'},
				  	items:[devView,sqlFile]
				 },{
				 	title:'테스트진행상황',
				 	region:'south',
				 	weight:-100,
					height:200,
					layout:{type:'vbox', align:'stretch'},
					items:[testView]
				 
				 }
				 
			 ]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset'],true);
			}
			, onQueryButtonDown:function() {
					reqGrid.getStore().loadStoreRecords();
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