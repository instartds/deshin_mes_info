
	/**************************************************
	 * Common variable
	 **************************************************/
	 var docCommentWidth = 300;
	 var docCommentHeight = 200;	
	
	/**************************************************
	 * Common Code
	 **************************************************/
		
	/**************************************************
	 * Model
	 **************************************************/
	//Comment List
 	Ext.define('nbox.docCommentsModel', {
	    extend: 'Ext.data.Model',
	    fields: [
	    	{name: 'DocumentID'}, 
	    	{name: 'Seq', type: 'int'},
	    	{name: 'Comment'}, 
	    	{name: 'UserDeptName'}, 
	    	{name: 'UserDeptPosName'},
	    	{name: 'UserName'}, 
	    	{name: 'MyCommentFlag'},
	    	{name: 'InsertDate', type: 'date', dateFormat:'Y-m-d H:i:s'}
	    ]
	});
 	
	/**************************************************
	 * Store
	 **************************************************/
 	//Comment List
 	Ext.define('nbox.docCommentsStore', {
 		extend: 'Ext.data.Store',
		model: 'nbox.docCommentsModel',
		autoLoad: false,
		pageSize: NBOX_C_COMMENT_LIMIT,
		proxy: {
            type: 'direct',
            api: {
            	read: 'nboxDocCommentService.selects' ,
            	destroy: 'nboxDocCommentService.delete' 
            },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        },
	  	initPage: function(currentPage, pageSize) {
	        var me = this;
	
	        me.currentPage = currentPage;
	        me.pageSize = pageSize;
	    }
	});	 
 	
 	// Doc Comment
	//var docCommentStore = Ext.create('Ext.data.Store', {
 	Ext.define('nbox.docCommentStore', {
 		extend:	'Ext.data.Store', 
		model: 'nbox.docCommentsModel',
		config: {
			parentContainer: null
		},
		autoLoad: false,
		proxy: {
            type: 'direct',
            api: {
            	read: 'nboxDocCommentService.select'
            },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        }
	}); 	

	/**************************************************
	 * Define
	 **************************************************/
 	//Comment Grid
	Ext.define('nbox.docCommentGrid',  {
		extend: 'Ext.grid.Panel',
		config: {
			regItems: {}
		},
		padding: '3px 3px 0px 3px',
		hideHeaders: true,
		border: false,
        initComponent: function () {
        	var me = this;
        	
        	var commentTpl = new Ext.XTemplate(
				'<div style="padding: 3px 3px 0px, 3px">',
			        '<tpl for=".">', 
			            '<div>',
				            '<span class="nbox-feed-sel-item"><label>{UserName}</label>&nbsp;</span>',
				            '<span><label>{UserDeptPosName}</label>&nbsp;</span>',
				            '<span><label>{[fm.date(values.InsertDate, "Y-m-d H:i:s")]}</label>&nbsp;</span>',
			            '</div>',
			        	'<div style="padding: 0px 0px 0px, 10px">',
			        		'<span><label>{Comment}</label></span>',
			        	'</div>',
			        '</tpl>',
		        '</div>'
			);
			
        	var nboxCommentTplColumns = Ext.create('Ext.grid.column.Template', {
        		tpl: commentTpl,
            	flex: 1
        	});
        	
        	var nboxCommentActionColumns = Ext.create('Ext.grid.column.Action', {
        		width: 50,
				items: [
					{
						icon: NBOX_IMAGE_PATH + "edit.gif" ,
						tooltip: '수정',
						width: 25,
						handler:function(grid, rowIndex, colIndex) {
							var record = grid.store.getAt(rowIndex);
							if (record.data.MyCommentFlag == 'Y'){
								var documentID = record.data.DocumentID;
								var seq = record.data.Seq;
								me.openCommentWin(NBOX_C_UPDATE, documentID, seq);
							}
						}
					},
					{
						icon: NBOX_IMAGE_PATH + "delete.png" ,
						tooltip: '삭제',
						width: 25,
						handler: function(grid, rowIndex, colIndex) {
							var record = grid.store.getAt(rowIndex);
							if (record.data.MyCommentFlag == 'Y'){
								Ext.Msg.confirm('확인', '삭제 하시겠습니까?', 
							    function(btn) {
							        if (btn === 'yes') {
							        	me.deleteData(rowIndex);
							            return true;
							        } else {
							            return false;
							        }
								});
							};
						}
					}
				]
        	});
        	
        	var nboxCommentPaging = Ext.create('Ext.toolbar.Paging', {
        		id:'nboxCommentPaging',
        		store: me.getStore(),
		        dock: 'bottom',
		        pageSize: NBOX_C_COMMENT_LIMIT,
		        displayInfo: true
        	});
        	
		    me.columns = [nboxCommentTplColumns, nboxCommentActionColumns];
	        me.dockedItems = [nboxCommentPaging];
	        
	       	me.callParent();
        },
        queryData: function(){
    		var me = this;
    		var store = me.getStore();
    		var nboxDocCommentWindow = Ext.getCmp('nboxDocCommentWindow');
    		var documentID;
			
			me.clearData();
			
			documentID = nboxDocCommentWindow.getDocumentID();
			store.proxy.setExtraParam('DocumentID', documentID);
    		
    		store.initPage(1, NBOX_C_COMMENT_LIMIT);
   			store.load({callback: function(records, operation, success) {
       				if (success){
       					me.loadData();
       				}
       			}
   			});
    	},
    	deleteData: function(rowIndex){
    		var me = this;
    		var last;
    		var store = me.getStore();
    		var record = store.getAt(rowIndex);
    		var selModel = me.getSelectionModel();
    		
    		last = selModel.getSelection()[0];

    		store.remove(record);
			store.sync({success: function(batch, options){
				me.selectPrevious(last.index, false, false);
				}
			});
    	},
	    clearData: function(){
	    	var me = this;
	    	
    		me.clearPanel();
    	},        
        loadData: function(){
        	var me = this;
        	var store = me.getStore();
			var nboxCommentPaging = Ext.getCmp('nboxCommentPaging');
			
			if (nboxCommentPaging != null) {
				if (store.totalCount > 0){
	  				if (!nboxCommentPaging.isVisible()){
	  					nboxCommentPaging.show();
	  				}
				} else {
					if (nboxCommentPaging.isVisible()){
						nboxCommentPaging.hide();
					}
				}
        	}
        },
    	clearPanel: function(){
    		var me = this;
    		var store = me.getStore();
    		
    		store.removeAll();
    	},
        selectPrevious: function(lastIndex, keepExisting, suppressEvent) {
			var me = this;
			var pageData;
			var nboxCommentPaging = Ext.getCmp('nboxCommentPaging');
			var selModel = me.getSelectionModel();
			
			if (lastIndex) {
	            pageData = nboxCommentPaging.getPageData();
	
	            if (lastIndex >= pageData.fromRecord) {
	                selModel.select((lastIndex - pageData.fromRecord), keepExisting, suppressEvent);
	                return;
	            }
	
	            if (pageData.currentPage > 1) {
	                me.view.on('refresh', function(view){
	                		if (me.getStore().getCount() > 0){
	                			selModel.select((me.getStore().getCount() - 1), keepExisting, suppressEvent);
	                		}
	                    },
	                    me, {single: true}
	                );
	                nboxCommentPaging.movePrevious();
	            }
			} else {
				selModel.getStore().reload({callback: function(records, operation, success) {
       					if (success){
       						me.loadData();
       					}
       				}
   				});
			}
	    },
    	openCommentWin: function(actionType, documentID, seq){
    		var me = this;
    		
    		openDocCommentWin(me, actionType, documentID, seq);
    	}
	}); 	
	
	//Doc Comment Edit
    Ext.define('nbox.docCommentEdit',  {
		extend: 'Ext.form.Panel',
		config: {
			store: null,
			regItems: {}
		},
		layout: 'fit',
		padding: '5px 5px 0px 5px',
		api: { submit: 'nboxDocCommentService.save' },
		items: [
			{ xtype: 'textareafield',
			  name: 'Comment',
			  autoScroll: true,
			  allowBlank: false 
	        }
    	],
		queryData: function(){
			var me = this;
			var store = me.getStore();
			var nboxDocCommentWindow = Ext.getCmp('nboxDocCommentWindow');
			var documentID = nboxDocCommentWindow.getDocumentID();
			var seq = nboxDocCommentWindow.getSeq();
			
			me.clearData();
			
			switch (nboxDocCommentWindow.getActionType()){
	    		case NBOX_C_CREATE:
		    	case NBOX_C_READ:
		    		break;
		    		
	    		case NBOX_C_UPDATE:
					store.proxy.setExtraParam('DocumentID', documentID);
					store.proxy.setExtraParam('Seq', seq);
	        		
	       			store.load({
		       			callback: function(records, operation, success) {
		       				if (success){
		       					me.loadData();
		       				}
		       			}
	       			});
		    		break;
		    	
				case NBOX_C_DELETE:
					break;
					
				default:
					break;
			}
        },
    	saveData: function(){
    		var me = this;
    		var nboxDocCommentWindow = Ext.getCmp('nboxDocCommentWindow');
	    	var documentID = nboxDocCommentWindow.getDocumentID();
	    	var seq = nboxDocCommentWindow.getSeq();
			var param = {'DocumentID': documentID, 'Seq': seq};
			
			if (me.isValid()) {
				me.submit({
                	params: param,
                    success: function(obj, action) {
                    	nboxDocCommentWindow.close();
                    }
                });
            }
            else {
            	Ext.Msg.alert('확인', me.validationCheck());
            }
    	},
        clearData: function(){
			var me = this;
			
        	me.clearPanel();
        },
    	loadData: function(){
    		var me = this;
	    	var store = me.getStore();
	    	var frm = me.getForm();
	    	
	    	if (store.getCount() > 0)
	    	{
				var record = store.getAt(0);
				frm.loadRecord(record);
	    	}
    	},
        clearPanel: function(){
        	var me = this;
	    	var frm = me.getForm();
	    	var store = me.getStore();
	    	
			store.removeAll();
			frm.reset();
        },
    	validationCheck: function(){
	    	var me = this;
	    	
	    	var fields = me.getForm().getFields();
	    	var result = '';
	    	
	    	var itemCnt = fields.getCount();
	    	for(var idx=0; idx<itemCnt; idx++){
	    		if(!fields.items[idx].isValid()){
	    			result += fields.items[idx].getFieldLabel() + ',';
	    		}
	    	}
	    	
	    	return '[' + result.substring(0,result.length-1) + ']' + '은/는 필수입력 사항입니다.';	
	    }
	});
    
  	//Doc Comment toolbar
	Ext.define('nbox.docCommentToolbar',    {
        extend:'Ext.toolbar.Toolbar',
		dock : 'top',
		config: {
			regItems: {}
		},
		
		initComponent: function () {
	    	var me = this;
	    	var btnWidth = 60;
	    	var btnHeight = 26;
	    	
	        var btnSave = {
				xtype: 'button',
				text: '저장',
				tooltip : '저장',
				itemId : 'save',
				width: btnWidth,  
			    height: btnHeight,
			    style: { margin: '0px 0px 0px 3px' },
				handler: function() {
					var nboxDocCommentWindow = Ext.getCmp('nboxDocCommentWindow');
					
					if (nboxDocCommentWindow)
						nboxDocCommentWindow.SaveButtonDown();		
				}
	        };
	        
	        var btnCancel = {
				xtype: 'button',
				text: '취소',
				tooltip : '취소',
				itemId : 'cancel',
				width: btnWidth,  
			    height: btnHeight,
			    style: { margin: '0px 0px 0px 3px' },
				handler: function() { 
					var nboxDocCommentWindow = Ext.getCmp('nboxDocCommentWindow');
					
					if (nboxDocCommentWindow)
						nboxDocCommentWindow.CancelButtonDown();					
				}
	        };
	        	    	
			me.items = [btnSave, btnCancel];
			
	    	me.callParent(); 
	    },
	    setToolBars: function(btnItemIDs, flag){
	    	var me = this;
	    	
			if(Ext.isArray(btnItemIDs) ) {
				for(i = 0; i < btnItemIDs.length; i ++) {
					var element = btnItemIDs[i];
					me.setToolBar(element, flag);
				}
			} else {
				me.setToolBar(btnItemIDs, flag);
			}
	    },
	    setToolBar: function(btnItemID, flag){
	    	var me = this;
	    	
	    	var obj =  me.getComponent(btnItemID);
			if(obj) {
				(flag) ? obj.enable(): obj.disable();
			}
	    }
	});
	
	//Doc Comment Window
	Ext.define('nbox.docCommentWindow',{
		extend: 'Ext.window.Window',
		config: {
			docCommentGrid: null,
			documentID: null,
			seq: null,
			actionType: null,
			regItems: {}    	
		},
		layout: {
	        type: 'fit'
	    },
		title: '댓글',
		x:20,
        y:20,
        width: docCommentWidth,
        height: docCommentHeight,
        modal: true,
        resizable: false,
        closable: false,
	    initComponent: function () {
			var me = this;
	       
			var nboxDocCommentStore = Ext.create('nbox.docCommentStore', {
				id: 'nboxDocCommentStore'
			});
			
	        var nboxDcCommentToolbar = Ext.create('nbox.docCommentToolbar', {
	        	id: 'nboxDcCommentToolbar'
	        });
	        
			var nboxDocCommentEdit = Ext.create('nbox.docCommentEdit',{
				id: 'nboxDocCommentEdit',
				store: nboxDocCommentStore
			});
	        
			me.dockedItems = [nboxDcCommentToolbar];
			me.items = [nboxDocCommentEdit];
			
			me.callParent(); 
	    },
	    listeners: {
	    	beforeshow: function(obj, eOpts){
	    		var me = this;
	    		
    			console.log(me.id + ' beforeshow -> docCommentWindow');
	    		me.formShow();
	    	},
		    beforehide: function(obj, eOpts){
		    	var me = this;
		    	
	    		console.log(me.id + ' beforehide -> docCommentWindow')
	    	},
	    	beforeclose: function(obj, eOpts){
	    		var me = this;
	    		var docCommentGrid = me.getDocCommentGrid();
	    		
	    		console.log(me.id + ' beforeclose -> docCommentWindow')
	    		docCommentGrid.queryData();
	    	}
	    },
	    SaveButtonDown: function(){
			var me = this;
			
	    	me.saveData();	
	    },
	    CancelButtonDown: function(){
			var me = this;
			
		    me.closeData();
	    },
	    saveData: function(){
			var me = this;
	    	var nboxDocCommentEdit = Ext.getCmp('nboxDocCommentEdit');
	    	
	    	if (nboxDocCommentEdit)
	    		nboxDocCommentEdit.saveData();	
	    },
	    closeData: function(){
			var me = this;
		    me.close();
	    },
	    formShow: function(){
    		var me = this;
    		var nboxDocCommentEdit = Ext.getCmp('nboxDocCommentEdit');
	    	
	    	if (nboxDocCommentEdit)
	    		nboxDocCommentEdit.clearData();
    		
    		switch(me.getActionType())
    		{
    			case NBOX_C_CREATE:
		    		break;
		    		
    			case NBOX_C_READ:
					break;
					
				case NBOX_C_UPDATE:
					nboxDocCommentEdit.queryData();
					break;

				case NBOX_C_DELETE:
					break;
					
				default:
					break;
			}
    	}
	});	
	
    /**************************************************
	 * User Define Function
	 **************************************************/
	//Comment Window Open
    function openDocCommentWin(obj, actionType, documentID, seq){
    	var nboxDocCommentWindow = Ext.getCmp('nboxDocCommentWindow');
    	
    	if(!nboxDocCommentWindow){
    		nboxDocCommentWindow = Ext.create('nbox.docCommentWindow', {
    			id: 'nboxDocCommentWindow'
			}); 
    	}

    	nboxDocCommentWindow.setDocCommentGrid(obj);
    	nboxDocCommentWindow.setDocumentID(documentID);
    	nboxDocCommentWindow.setSeq(seq);
    	nboxDocCommentWindow.setActionType(actionType);
    		
    	nboxDocCommentWindow.show();
    }	
