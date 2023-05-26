<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="aep090ukr"  >
<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->
<t:ExtComboStore comboType="AU" comboCode="B602"/>				<!-- 게시유형  	-->  
<t:ExtComboStore comboType="AU" comboCode="B603"/>				<!-- 게시대상  	-->
</t:appConfig>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >

var subGridWindow;

var mainGridReceiveRecord = '';

function appMain() {
	
	Unilite.defineModel('aep090ukrSubModel', {
    	fields: [ 
    		{name: 'BULLETIN_ID'	 	,text: '등록번호' 			,type: 'string'},
    	    {name: 'TITLE'      		,text: '제목'       	 	,type: 'string'},   
    	    {name: 'USER_ID'	 		,text: '게시자ID' 			,type: 'string'},
    	    {name: 'USER_NAME'	 		,text: '게시자' 			,type: 'string'},
            {name: 'FROM_DATE'          ,text: '게시시작일'         ,type: 'uniDate'},
    		{name: 'TO_DATE'	 		,text: '게시종료일' 		,type: 'uniDate'},  
    	    {name: 'CONTENTS'       	,text: '내용'        		,type: 'string'},  
    		{name: 'DIV_CODE'	 		,text: '부서' 				,type: 'string'},
    		{name: 'DEPT_CODE'	 		,text: '영업소' 			,type: 'string'},    	    
    		{name: 'OFFICE_CODE'        ,text: '영업소'          	,type: 'string'},
    		{name: 'AUTH_FLAG'          ,text: '게시대상'          	,type: 'string'},
    		{name: 'TYPE_FLAG'          ,text: '게시유형'          	,type: 'string'},
    		{name: 'ACCESS_CNT'         ,text: '조회횟수'          	,type: 'string'}	 
		]
	});	
	
	/**
	 * 공지사항등록 Master Form
	 * 
	 * @type
	 */     
	 
    var detailForm = Unilite.createForm('aep090ukrDetail', {
    	disabled :false,
    	trackResetOnLoad: false,
    	//masterGrid: masterGrid,
    	autoScroll:true,
    	padding:'1 1 5 1',
    	flex  : 3,
    	region : 'center'     
        , layout: {type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}}
	    , items :[{	    
			fieldLabel: '등록번호',
			name: 'BULLETIN_ID',
			xtype:'uniNumberfield',
			hidden: true
		},{	    
			fieldLabel: '게시유형',
			name: 'TYPE_FLAG',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B602',
			value: '2'/*,
			hidden: true*/	
		},{	    
			fieldLabel: '게시시작일',
			xtype: 'uniDatefield',				
			name: 'FROM_DATE',
			value: UniDate.get('today')/*,
			hidden: true*/
		},{	    
			fieldLabel: '게시종료일',
			xtype: 'uniDatefield',				
			name: 'TO_DATE',
			hidden: true
		},{
    		xtype: 'uniTextfield',
    		fieldLabel: '게시자',
    		value: UserInfo.userID,
    		name: 'USER_ID'/*,
			hidden: true*/
    	},{
    		xtype: 'uniTextfield',
    		fieldLabel: '게시자',
			value: UserInfo.userName,    		
    		name: 'USER_NAME'/*,
			hidden: true*/
    	},{	    
			fieldLabel: '게시대상',
			name: 'AUTH_FLAG',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B603',
			hidden: true	
		},{	    
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			hidden: true
			//value: UserInfo.divCode
		},   
	        Unilite.popup('DEPT',{
	        fieldLabel: '부서',
	        validateBlank:false,
	        colspan:2,
			hidden: true
	    }),{	    
			fieldLabel: '제목',
			name: 'TITLE',
			xtype: 'uniTextfield',
			allowBlank: false,
			width: 980,			
			colspan: 4
		},{	    
			fieldLabel: '내용',
			name: 'CONTENTS',
			xtype: 'textareafield',
			width: 980,
			height: 400,
			colspan: 4
		},{	    
			fieldLabel: '저장구분',
			name: 'SAVE_GUBUN',
			xtype:'uniTextfield',
			hidden: true
		}],
     	api: {
     		load	: 'aep090ukrService.selectMaster',
     		//destroy : 'aep090ukrService.deleteMaster',
			submit	: 'aep090ukrService.syncMaster'				
		},
		tbar: [
            '->',{
//                        itemId : 'Btn',
                text: '수정',
                handler: function(record) {
					mainGridReceiveRecord = record;
					openSubGridWindow();
                },
                disabled: false
            }/*,{
                itemId : 'closeBtn',
                text: '닫기',
                handler: function() {
                    openSubGridWindow.hide();
                  	//noticeDetailForm.clearForm();
                },
                disabled: false
            }*/
        ],		
		listeners : {
            uniOnChange:function( basicForm, dirty, eOpts ) {
                //alert("onDirtyChange");
                if(basicForm.isDirty()) {
                    UniAppManager.setToolbarButtons('save', true);
                    //UniAppManager.setToolbarButtons('delete', true);
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                    //UniAppManager.setToolbarButtons('delete', false);
                }
            }
        }		

	});		 

	var directSubStore = Unilite.createStore('aep090ukrSubStore', {
		model: 'aep090ukrSubModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
		proxy: {
		   type: 'direct',
		   api: {			
		       read: 'aep090ukrService.selectSubList'                	
		   }
		},
        loadStoreRecords : function(param)	{
			var param= subGridSearch.getValues();
			this.load({
				params: param
			});
		},
		saveStore : function()	{
			config = {
//						
			};
			this.syncAllDirect(config);
		},
	    _onStoreUpdate: function (store, eOpt) {	    	
	    	console.log("Store data updated save btn enabled !");
	    	this.setToolbarButtons('sub_save', true);    	
	    } // onStoreUpdate
	    ,_onStoreLoad: function ( store, records, successful, eOpts ) {	    	
	    	console.log("onStoreLoad");
	    	if (records) {
		    	this.setToolbarButtons('sub_save', false);
//					var msg = records.length + Msg.sMB001; //'건이 조회되었습니다.';
		    	//console.log(msg, st);
//			    	UniAppManager.updateStatus(msg, true);	
	    	}	    	
	    },
		_onStoreDataChanged: function( store, eOpts )	{	    	
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			this.setToolbarButtons(['sub_delete'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':false}});
	    		if(this.uniOpt.useNavi) {
	       			this.setToolbarButtons(['prev','next'], false);
	    		}
       		}else {
       			if(this.uniOpt.deletable)	{
	       			this.setToolbarButtons(['sub_delete'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':true}});
       			}
	    		if(this.uniOpt.useNavi) {
	       			this.setToolbarButtons(['prev','next'], true);
	    		}
       		}
       		if(store.isDirty())	{
       			this.setToolbarButtons(['sub_save'], true);
       		}else {
       			this.setToolbarButtons(['sub_save'], false);
       		}	    	
    	},
    	setToolbarButtons: function( btnName, state)	{
    		var toolbar = subGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
    	}
	});	
	
    var subGrid = Unilite.createGrid('aep090ukrSubGrid', {    	
    	//region:'center',
    	store : directSubStore,
    	sortableColumns : false,
		selModel:'rowmodel',  
		//    	layout: 'fit',
    	width: 600,				                
        height: 300,
//    	margin: '0 0 0 116',
    	
    	excelTitle: '계좌정보 서브 그리드',
    	//border:false,
    	uniOpt:{
			 expandLastColumn: false
//			,dblClickToEdit	: true
			,useRowNumberer: true
			,useMultipleSorting: false
			,onLoadSelectFirst	: true
			//,enterKeyCreateRow: false//마스터 그리드 추가기능 삭제
			,state: {
				useState: false,			
				useStateList: false
			}
    	},
    	dockedItems: [{    		
	        xtype: 'toolbar',
	        dock: 'top',
	        items: [/*{
                xtype: 'uniBaseButton',
		 		text : '조회',
		 		tooltip : '조회',
		 		iconCls : 'icon-query', 
		 		width: 26, height: 26,
		 		itemId : 'sub_query',
				handler: function() { 

					directSubStore.loadStoreRecords();
					//if( me._needSave()) {
					var toolbar = subGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					var record = masterGrid.getSelectedRecord();
					if(needSave) {
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	//console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
				                  		directSubStore.saveStore();
				                    });
				                    saveTask.delay(500);
						     	} else if(res === 'no') {
						     		directSubStore.loadStoreRecords(record);
						     	}
						     }
						});
					} else {
						directSubStore.loadStoreRecords(record);
					}
				}
			},{
                xtype: 'uniBaseButton',
				text : '신규',
				tooltip : '초기화',
				iconCls: 'icon-reset',
				width: 26, height: 26,
		 		itemId : 'sub_reset',
				handler : function() { 
					directSubStore.clearData();
					subGrid.reset();
				}
			},*//*{
                xtype: 'uniBaseButton',
				text : '추가',
				tooltip : '추가',
				iconCls: 'icon-new',
				width: 26, height: 26,
		 		itemId : 'sub_newData',
				handler : function() { 
//					var mainGridRecord = detailGrid.getSelectedRecord();
					
					var customCode = mainGridReceiveRecord.get('PAY_CUSTOM_CODE');
					var mainBookYn  = 'N'; 
					
	            	var r = {
	            	 	CUSTOM_CODE : customCode,
	            	 	MAIN_BOOK_YN: mainBookYn
			        };
					subGrid.createRow(r);
				}
			},{
                xtype: 'uniBaseButton',
				text : '삭제',
				tooltip : '삭제',
				iconCls: 'icon-delete',disabled: true,
				width: 26, height: 26,
		 		itemId : 'sub_delete',
				handler : function() { 
					var selRow = subGrid.getSelectedRecord();
					if(selRow.phantom === true)	{
						subGrid.deleteSelectedRow();
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						subGrid.deleteSelectedRow();						
					}	
				}				
			},{
                xtype: 'uniBaseButton',
				text : '저장', 
				tooltip : '저장', 
				iconCls: 'icon-save',disabled: true,
				width: 26, height: 26,
		 		itemId : 'sub_save',
				handler : function() {
					var inValidRecs = directSubStore.getInvalidRecords();       	
					if(inValidRecs.length == 0 )	{
						directSubStore.saveStore();
					}else {
						subGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}                  
                }
			}*/]
	    }],

    	/* tbar: ['->',
            {
	        	text:'상세보기',
	        	handler: function() {
	        		var record = masterGrid.getSelectedRecord();
		        	if(record) {
		        		openDetailWindow(record);
		        	}
	        	}
            }
        ],*/
        columns:  [ 
        	{ dataIndex: 'BULLETIN_ID'	 		, width: 120	, hidden:true},
        	{ dataIndex: 'TITLE'            	, width: 250},        	
        	{ dataIndex: 'TYPE_FLAG'            , width: 120	, hidden:true},
            { dataIndex: 'FROM_DATE'            , width: 100},
        	{ dataIndex: 'TO_DATE'            	, width: 120	, hidden:true},
            { dataIndex: 'USER_ID'            	, width: 100    , hidden:true},
            { dataIndex: 'USER_NAME'            , width: 100},
        	{ dataIndex: 'DIV_CODE'            	, width: 120	, hidden:true},
            { dataIndex: 'DEPT'            		, width: 100	, hidden:true},
            { dataIndex: 'CONTENTS'            	, width: 100	, hidden:true}			
		],
		listeners: {          	
/*			beforeedit : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['CUSTOM_CODE'])){
					return false;
				}else if(UniUtils.indexOf(e.field, ['BOOK_CODE'])){
                    if(e.record.phantom){
                        return true;
                    }else{
                        return false;
                    }
                }else{
                    return true;	
                }
			},*/
/*        	beforecelldblclick : function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
        		var columnName = view.eventPosition.column.dataIndex;
        		if(record.get('CONFIRM_YN') == 'Y'){
        			if(columnName == 'BANK_ACCOUNT'){
        			detailForm.setValue('BULLETIN_ID',record.get('BULLETIN_ID'));	
        			detailForm.setValue('TITLE',record.get('TITLE'));
        			detailForm.setValue('USER_ID',record.get('USER_ID'));
        			
        			mainGridReceiveRecord = record;
        			openSubGridWindow.hide();
                  	openSubGridWindow.clearForm();
	        		openSubGridWindow();
	        			
	        			
	        		}else{
	        			return false;
        			}
        		}
        	},*/
			onGridDblClick:function(grid, record, cellIndex, colName) {
    			detailForm.setValue('BULLETIN_ID',record.get('BULLETIN_ID'));	
    			detailForm.setValue('TITLE',record.get('TITLE'));
    			detailForm.setValue('USER_ID',record.get('USER_ID'));     
    			detailForm.setValue('CONTENTS',record.get('CONTENTS'));

				subGridWindow.hide();
				subGrid.reset();				
				
				UniAppManager.app.setToolbarButtons('delete', true);
				
//				directMasterStore.loadStoreRecords();
//				queryButtonFlag = 'M';
//				
//				queryButtonFlag2 = 'M';
//				
				
//				SEARCH = 'SEARCH';
//				UniAppManager.app.onQueryButtonDown();
				
				
//				panelResult.setValue('testfield',record.get('DIV_CODE'));
				
			}        	
        	
		},
		returnData: function()	{
//			if(Ext.isEmpty(record))	{
//      			record = this.getSelectedRecord();
//      		}       		
       		var record = this.getSelectedRecord();
       		
//       		var mainGridRecord = detailGrid.getSelectedRecord();
//       		var mainGridRecord = detailGrid.uniOpt.currentRecord;
       		if(!Ext.isEmpty(mainGridReceiveRecord)){
//	       		var record = this.getSelectedRecord();
//				mainGridReceiveRecord.set('BULLETIN_ID'		,record.get('BULLETIN_ID'));
//	       		mainGridReceiveRecord.set('TITLE'		,record.get('TITLE'));
//	       		mainGridReceiveRecord.set('USER_ID'	,record.get('USER_ID'));
//	       		mainGridReceiveRecord.set('CONTENTS'	,record.get('CONTENTS'));
    			detailForm.setValue('BULLETIN_ID',record.get('BULLETIN_ID'));	
    			detailForm.setValue('TITLE',record.get('TITLE'));
    			detailForm.setValue('USER_ID',record.get('USER_ID'));     
    			detailForm.setValue('CONTENTS',record.get('CONTENTS'));

       		}
		}
    });	
    
  	function openSubGridWindow() {    		
//  		if(!UniAppManager.app.checkForNewDetail()) return false;

		if(!subGridWindow) {
			subGridWindow = Ext.create('widget.uniDetailWindow', {
                width: 600,				                
        		height: 300,
                layout:{type:'vbox', align:'stretch'},
                items: [subGridSearch, subGrid],
                tbar:  [{	
						itemId : 'queryBtn',
						text: '조회',
						handler: function() {
							if(!subGridSearch.getInvalidMessage()) return;
							directSubStore.loadStoreRecords();
						},
						disabled: false
					},
					'->',{	
						itemId : 'saveBtn',
						text: '확인',
						handler: function() {
					        //var grdRecord = subGrid.uniOpt.currentRecord;
					        var grdRecord = subGrid.getSelectedRecord();
//			    			alert('grdRecord::::::::::'+grdRecord);
			    			detailForm.setValue('BULLETIN_ID',grdRecord.data.BULLETIN_ID);
			    			detailForm.setValue('TITLE',grdRecord.data.TITLE);
			    			detailForm.setValue('USER_ID',grdRecord.data.USER_ID);
			    			detailForm.setValue('CONTENTS',grdRecord.data.CONTENTS);
//			    			detailForm.setValue('TITLE',grdRecord.get('TITLE'));
//			    			detailForm.setValue('USER_ID',grdRecord.get('USER_ID'));     
//			    			detailForm.setValue('CONTENTS',grdRecord.get('CONTENTS'));
							UniAppManager.app.setToolbarButtons('delete', true);
							
							subGridWindow.hide();
							subGrid.reset();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							subGridWindow.hide();
							subGrid.reset();
							subGrid.clearForm();
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{

					},
		 			beforeclose: function( panel, eOpts )	{

		 			},
		 			
		 			show: function ( panel, eOpts )	{
//		 				var param = {
//							PAY_CUSTOM_CODE: mainGridReceiveRecord.get('PAY_CUSTOM_CODE')
//							
//						}
						if(!subGridSearch.getInvalidMessage()) return;
		 				directSubStore.loadStoreRecords();
		 				
		 			}
		 			
				}
			})
		}
		subGridWindow.center();
		subGridWindow.show();
    }    

	var subGridSearch = Unilite.createSearchForm('subGridForm', {//검색팝업관련
		layout :  {type : 'uniTable', columns : 2
//			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
		},
    	items :[{ 
    		fieldLabel: '제목',
		    xtype: 'uniTextfield',
		    name: 'TITLE'/*,
		    hidden: true*/
		    //allowBlank: false
		},{ 
    		fieldLabel: '게시자',
		    xtype: 'uniTextfield',
		    name: 'USER_NAME'/*,
		    hidden: true*/
		    //allowBlank: false
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:500,
//			id:'tdPayDtlNo',
			tdAttrs: {width:500/*align : 'center'*/},
			items :[{
	    		fieldLabel: '게시일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'DATE_FR',
			    endFieldName: 'DATE_TO',
			    startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			}]
		}]
    });    
    
    
    /**
	 * main app
	 */
    Unilite.Main( {
    		 id  : 'aep090ukrApp',
			 items 	: [ detailForm]
			,fnInitBinding : function(params) {
				//this.setToolbarButtons(['newData','reset'],false);
				
				UniAppManager.setToolbarButtons('reset', true);
				UniAppManager.setToolbarButtons('save', true);
            	UniAppManager.setToolbarButtons(['query'], false);	
            	UniAppManager.setToolbarButtons('delete', true);
            	
				detailForm.setValue('FROM_DATE',UniDate.get('today'));
				detailForm.setValue('USER_ID',UserInfo.userID);
				detailForm.setValue('USER_NAME',UserInfo.userName);
				detailForm.setValue('TYPE_FLAG','2');
				this.processParams(params);	
			}
			,onQueryButtonDown:function () {
				this.onResetButtonDown();
			},
//			,onQueryButtonDown:function () {
//				var param= detailForm.getValues();
//				detailForm.uniOpt.inLoading = true;
//				Ext.getBody().mask('로딩중...','loading-indicator');
//				detailForm.getForm().load({
//					params: param,
//					success:function()	{
//						Ext.getBody().unmask();
//
//						
//						detailForm.uniOpt.inLoading = false;
//					},
//					 failure: function(batch, option) {					 	
//					 	Ext.getBody().unmask();					 
//					 }
//				})
//			},			
			onSaveDataButtonDown: function (config) {			
				var userId = detailForm.getValue('USER_ID');
				if (userId != UserInfo.userID && userId !=''){
					Ext.Msg.alert("확인","작성한 공지사항만 수정가능합니다.");
				} else {
					var param= detailForm.getValues();
					Ext.getBody().mask('로딩중...','loading-indicator');
					detailForm.getForm().submit({
						 params : param,
						 success : function(form, action) {
					 		Ext.getBody().unmask();
		 					detailForm.getForm().wasDirty = false;
							detailForm.resetDirtyStatus();	
							
							//detailForm.clearForm();
							detailForm.setValue('TITLE','');
							detailForm.setValue('CONTENTS','');
							detailForm.setValue('BULLETIN_ID','');
							detailForm.setValue('SAVE_GUBUN','');
								
							
							UniAppManager.setToolbarButtons('save', false);
							UniAppManager.setToolbarButtons('delete', false);
		            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
						 }	
					});
				}			
			},
			onNewDataButtonDown:  function()	{
	        	 var r = {
					FROM_DATE: new Date(),
					USER_ID: UserInfo.userID,
					USER_NAME: UserInfo.userName,
					TYPE_FLAG: '2'
		        };
				masterGrid.createRow(r);			
			},	
			onResetButtonDown : function() {			
				detailForm.clearForm();									
				this.fnInitBinding();
			},
			onDeleteDataButtonDown: function() {
				if (confirm('현재 공지사항을 삭제 합니다.\n 삭제 하시겠습니까?')){
					detailForm.setValue('SAVE_GUBUN','DEL');
					this.onSaveDataButtonDown();
					//detailForm.clearForm();	
										
				}
				//this.fnInitBinding();	
			},			
	        //링크로 넘어오는 params 받는 부분 
	        processParams: function(params) {
				//this.uniOpt.appParams = params;
				if(params) {
					detailForm.setValue('TITLE',params.TITLE);
					detailForm.setValue('CONTENTS',params.CONTENTS);
					detailForm.setValue('BULLETIN_ID',params.BULLETIN_ID);
									
					//gsProcessPgmId	= params.PGM_ID;
					//gsSlipNum 		= params.SLIP_NUM;
					//gsSlipSeq		= params.SLIP_SEQ;
					
	//				masterGrid1.getStore().loadStoreRecords(null, function(){
	//					var selModel = masterGrid1.getSelectionModel();
	//					var rowIdx = masterGrid1.getStore().findBy(function(item){
	//						return item.get("SLIP_NUM") == gsSlipNum && item.get("SLIP_SEQ") == gsSlipSeq;
	//					})
	//					if(rowIdx) masterGrid1.select(rowIdx);
	//				});
				}
	        }
		});
		
//	Unilite.createValidator('validator01', {
//		store : directSubStore,
//		grid: subGrid,
//		forms: {'formA:':detailForm},
//		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
//			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
//			var rv = true;
//			switch(fieldName){
//				case "TITLE":
//					var title = detailForm.getValue('TITLE');	
//					if(Ext.isEmpty(title)){
//						rv = '제목을 입력하세요.'
//						return false;
//					}
//				break;
//			}
//			return rv;
//		}
//	}); // validator
}
</script>
