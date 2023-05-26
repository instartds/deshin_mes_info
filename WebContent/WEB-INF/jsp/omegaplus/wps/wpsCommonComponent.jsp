<%@page language="java" contentType="text/html; charset=utf-8"%>

	/* view components data */
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
	
	function fnTestStateConvert(value)	{
		var rText = value;
		Ext.each(testStateStore.getData().items, function(item){
			if(item.get("value") == value)	{
				rText = item.get("text");
			}
		})
		return rText;
	}
	
	function fnModuleConvert(value)	{
		var rText = value;
		Ext.each(workGubunStore.getData().items, function(item){
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

	/* 작업번호 팝업 */
	var reqWindow;
	
	Unilite.defineModel('reqModel', {
		fields : [ {name : 'WORK_ID',		text : '작업번호',	type : 'string'}				 				 
				 , {name : 'TITLE',			text : '제목',		type : 'string'  }
				 , {name : 'WORK_CONTENT',	text : '내용',		type : 'string'	 }
				 , {name : 'DOC_ID',		text : '문서번호',	type : 'string'  }
				 , {name : 'TEST_STATE',	text : '테스트진행상태',	type : 'string' ,convert:fnTestStateConvert }
				 , {name : 'REQ_DATE',		text : '요청일',	type : 'uniDate'  }
				 , {name : 'REQ_NAME',		text : '요청자',	type : 'string'  ,convert:fnEmpConvert}
				 , {name : 'PROJECT',		text : '프로젝트',	type : 'string'    ,convert:fnProjectConvert}
				 , {name : 'MODULE',		text : '모듈',	type : 'string'   ,convert:fnModuleConvert}
				 , {name : 'WORK_GUBUN',	text : '업무구분',	type : 'string'   ,convert:fnWorkGubunConvert}
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
				read : 	 'wps100ukrvService.selectList'
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
					, {dataIndex : 'TEST_STATE',	width : 80		}
		],
		listeners:{
			selectionchange:function(grid,selected)	{
				if(selected && selected.length>0)	{
					var selRecord =selected[0];
					reqViewStore.loadData([selRecord]);		
					var fp = Ext.getCmp('wps100ukrvFileUploadPanel');
					if(fp)	{
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
				reqWindow.record.set('TITLE', record.get("TITLE"));
				reqWindow.record.set('REQ_NAME', record.get("REQ_NAME"));
				reqWindow.record.set('REQ_DATE', record.get("REQ_DATE"));
				reqWindow.record.set('PROJECT', record.get("PROJECT"));
				reqWindow.record.set('MODULE', record.get("MODULE"));
				reqWindow.record.set('WORK_GUBUN', record.get("WORK_GUBUN"));
  			}
  			reqWindow.hide();
		}
		
	});
	
	var reqViewTpl = new Ext.XTemplate(
	 '<tpl for=".">' ,
	 '<div class="req-source">',
    '<table cellspacing="1" cellpadding="3" border="0" height="300" width="750" style="border: #99bce8 solid 1px;bgcolor:#eeeeee;">' ,
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
			'	 <td width="428" style="vertical-align:top;border-bottom: #eee solid 1px;" ><div style="overflow:auto;height:220px;width:730px;"><pre>{WORK_CONTENT}</pre></div></td>' ,
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
						if(fp) {
							fp.clear();
						}
        			},
        			beforeclose: function( panel, eOpts )	{
						reqWindow.down('#reqSearchForm').clearForm();
						reqStore.loadData({});
						reqViewStore.loadData({});
						var fp = Ext.getCmp('wps100ukrvFileUploadPanel');
						if(fp) {
							fp.clear();
						}
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