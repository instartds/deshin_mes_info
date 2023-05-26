/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
//Detail View
Ext.define('nbox.docDetailViewModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'DocumentID'}, 
    	{name: 'CompanyID'},
    	{name: 'DraftUserID'}, 
    	{name: 'DraftUserName'},
    	{name: 'DraftDeptName'},
    	{name: 'DraftUserPos'},
    	{name: 'Subject'},
    	{name: 'Contents'},
    	{name: 'ViewContents'},
    	{name: 'DocumentNo'},
    	{name: 'DraftDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
    	{name: 'MultiType'},
    	{name: 'Status'},
    	{name: 'FormID'},
    	{name: 'FormName'},
    	{name: 'Slogan'},
    	{name: 'DraftFlag'},
    	{name: 'CurrentStatus'},
    	{name: 'CurrentSignFlag'},
    	{name: 'NextSignFlag'},
    	{name: 'NextSignedFlag'},
    	{name: 'DoubleLineFirstFlag'},
    	{name: 'SecureGrade'},
    	{name: 'CabinetID'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.docDetailViewStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docDetailViewModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { 
        	read: 'nboxDocListService.select'
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
// Detail View Header
Ext.define('nbox.docDetailViewHeader', {
	extend: 'Ext.panel.Panel',
	
	config: {
    	regItems: {}
    },
    
    layout: {
    	type: 'vbox'
    },

    border:false,
	
	defaultType: 'displayfield',
	
	items: 
	[
	    {
	    	xtype: 'panel',
	    	
	    	layout: {
	    		type: 'hbox',
	    		align: 'stretch'
	    	},

	    	style: {
	    		'padding': '3px 0px 3px 0px'					
	    	},
	    	
			border:false,
			defaultType: 'displayfield',
			items: [
				{ 
					fieldLabel: '문서번호',
					labelClsExtra: 'nbox_view_field_label',
					name: 'DocumentNo',
					width: 500,
					fieldStyle: 'color: #666666;'
	        	},
	        	{ 
	        		fieldLabel: '상신일',
	        		labelClsExtra: 'nbox_view_field_label',
					name: 'DraftDate', 
					renderer: Ext.util.Format.dateRenderer('Y-m-d'),
					fieldStyle: 'color: #666666;'
				}
			]
	    }, 
	    { 
			fieldLabel: '기안',
			labelClsExtra: 'nbox_view_field_label',
			name: 'DraftUserName',
			fieldStyle: 'color: #666666;'
    	},
    	{ 
			fieldLabel: '제목',
			labelClsExtra: 'nbox_view_field_label',
			name: 'Subject',
			fieldStyle: 'color: #666666;'
    	}
	]
});

// Detail View Contents
Ext.define('nbox.docDetailViewContents', {
	extend: 'Ext.panel.Panel',
	
	config: {
    	regItems: {}
    },
	
	layout: 'fit',
	
	border: false,
	
	style: {
		'border-top': '1px solid #C0C0C0',
		'border-bottom': '1px solid #C0C0C0',
		'padding': '10px 3px 10px 3px'
	},
	
	defaultType: 'displayfield',
	
	items: [ 
	    {
			name: 'ViewContents',
			fieldStyle: 'padding: 0px 10px 0px 3px;'
		}
	]
});

// Detail View Slogan
Ext.define('nbox.docDetailViewSlogan', {
	extend: 'Ext.panel.Panel',
	
	config: {
    	regItems: {}
    },
	
	layout: 'fit',
	
	border: false,
	
	style: {
		'padding': '3px 3px 3px 3px'	
	},
	
	defaultType: 'displayfield',

	items: [ 
		{ 
			name: 'Slogan',
			flex: 1,
			fieldStyle: 'text-align: center; color: #666666; padding: 3px 3px 0px 3px;'
    	}]
});

// Detail View 
Ext.define('nbox.docDetailView',    {
    extend: 'Ext.form.Panel',
    config: {
    	regItems: {}
    },
    
    layout: {
    	type: 'anchor'
    },
    
    border: false,
    flex: 1,
    
    autoScroll: true,
    
    api: { 
    	submit: 'nboxDocListService.exec' 
	},

    initComponent: function () {
    	var me = this;
    	
    	var docDetailViewHeader = Ext.create('nbox.docDetailViewHeader', {});
    	var docDetailViewContents = Ext.create('nbox.docDetailViewContents',{});
    	var docDetailViewSlogan = Ext.create('nbox.docDetailViewSlogan',{});
    	
    	var docDetailViewLineStore = Ext.create('nbox.docDetailViewLineStore', {});
    	var docDetailViewDoubleLineStore = Ext.create('nbox.docDetailViewDoubleLineStore',{});
    	var docDetailViewBasisStore = Ext.create('nbox.docDetailViewBasisStore',{});
    	var docDetailViewFileStore = Ext.create('nbox.docDetailViewFileStore', {});
    	var docDetailViewRcvUserStore = Ext.create('nbox.docDetailViewRcvUserStore', {});
    	var docDetailViewRefUserStore = Ext.create('nbox.docDetailViewRefUserStore',{});
    	var docDetailViewCommentStore = Ext.create('nbox.docDetailViewCommentStore', {});
    	    	
    	var docDetailViewLine = Ext.create('nbox.docDetailViewLine',{
    		store: docDetailViewLineStore
    	});
    	
    	var docDetailViewDoubleLine = Ext.create('nbox.docDetailViewDoubleLine',{
    		store: docDetailViewDoubleLineStore
    	});
    	
    	var docDetailViewBasis = Ext.create('nbox.docDetailViewBasis',{
    		store: docDetailViewBasisStore
    	});
    	
    	var docDetailViewFile = Ext.create('nbox.docDetailViewFile',{
    		store: docDetailViewFileStore
    	});
    	
    	var docDetailViewRcvUser = Ext.create('nbox.docDetailViewRcvUser',{
    		store: docDetailViewRcvUserStore
    	});
    	
    	var docDetailViewRefUser = Ext.create('nbox.docDetailViewRefUser',{
    		store: docDetailViewRefUserStore
    	});
    	
    	var docDetailViewComment = Ext.create('nbox.docDetailViewComment',{
    		store: docDetailViewCommentStore
    	});
    	
    	me.getRegItems()['DocDetailViewDoubleLine'] = docDetailViewDoubleLine;
    	docDetailViewDoubleLine.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['DocDetailViewLine'] = docDetailViewLine;
    	docDetailViewLine.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['DocDetailViewHeader'] = docDetailViewHeader;
    	docDetailViewHeader.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['DocDetailViewBasis'] = docDetailViewBasis;
    	docDetailViewBasis.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['DocDetailViewFile'] = docDetailViewFile;
    	docDetailViewFile.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['DocDetailViewContents'] = docDetailViewContents;
    	docDetailViewContents.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['DocDetailViewSlogan'] = docDetailViewSlogan;
    	docDetailViewSlogan.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['DocDetailViewRcvUser'] = docDetailViewRcvUser;
    	docDetailViewRcvUser.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['DocDetailViewRefUser'] = docDetailViewRefUser;
    	docDetailViewRefUser.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['DocDetailViewComment'] = docDetailViewComment;
    	docDetailViewComment.getRegItems()['ParentContainer'] = me;
    	
		me.items = [
            docDetailViewDoubleLine,
            docDetailViewLine,
            docDetailViewHeader,
            docDetailViewBasis,
            docDetailViewFile,
            docDetailViewContents,
            docDetailViewSlogan,
            docDetailViewRcvUser,
            docDetailViewRefUser,
            docDetailViewComment
		];
    	
		me.callParent();
    },
    queryData: function(){
    	var me = this;
    	var win = me.getRegItems()['ParentContainer'];
    	
    	var docDetailViewDoubleLine = me.getRegItems()['DocDetailViewDoubleLine'];
    	var docDetailViewLine = me.getRegItems()['DocDetailViewLine'];
    	var docDetailViewBasis = me.getRegItems()['DocDetailViewBasis'];
    	var docDetailViewFile = me.getRegItems()['DocDetailViewFile'];
    	var docDetailViewRcvUser = me.getRegItems()['DocDetailViewRcvUser'];
    	var docDetailViewRefUser = me.getRegItems()['DocDetailViewRefUser'];
    	var docDetailViewComment = me.getRegItems()['DocDetailViewComment'];
		
		me.clearData();

		var store = me.getRegItems()['Store'];
		var documentID = win.getRegItems()['DocumentID'];
		var box = win.getRegItems()['Box'];
		
		store.proxy.setExtraParam('BOX', box);
		store.proxy.setExtraParam('DocumentID', documentID);
		
		store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
   				}
   			}
		});
		
		docDetailViewDoubleLine.queryData();
		docDetailViewLine.queryData();
		docDetailViewBasis.queryData();
		docDetailViewFile.queryData();
		docDetailViewRcvUser.queryData();
		docDetailViewRefUser.queryData();
		docDetailViewComment.queryData();
    },
	deleteData: function(){
		var me = this;
		var win = me.getRegItems()['ParentContainer'];
		var documentID = win.getRegItems()['DocumentID'];
		
		var param = {'ActionType': NBOX_C_DELETE, 'DocumentID': documentID};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   docDetailWin.close();
			}
		});
	},
	draftData: function(){
		var me = this;
		var win = me.getRegItems()['ParentContainer'];
		
		var docDetailViewLine = me.getRegItems()['DocDetailViewLine']; 
		var docDetailViewLineStore = docDetailViewLine.getStore();
		
		if( docDetailViewLineStore.getCount() > 1 ){
			
			var documentID = win.getRegItems()['DocumentID'];
    		var execType = 'DRAFT';
    		
			var param = {
				'ActionType': NBOX_C_UPDATE, 
				'DocumentID': documentID, 
				'ExecType': execType
			};
			
			me.submit({
               	params: param,
                   success: function(obj, action) {
                	   docDetailWin.close();
				}
			});
		}else
			Ext.Msg.alert('확인', '선택된 결재선이 존재하지 않습니다.');
		
	},
	draftcancelData: function(){
		var me = this;
		var win = me.getRegItems()['ParentContainer'];
		var documentID = win.getRegItems()['DocumentID'];
		var execType = 'DRAFTCANCEL';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   docDetailWin.close();
			}
		});
	},
	confirmData: function(){
		var me = this;
		var win = me.getRegItems()['ParentContainer'];
		var documentID = win.getRegItems()['DocumentID'];
		var execType = 'CONFIRM';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   docDetailWin.close();
			}
		});
	},
	confirmcancelData: function(){
		var me = this;
		var win = me.getRegItems()['ParentContainer'];
		var documentID = win.getRegItems()['DocumentID'];
		var execType = 'CONFIRMCANCEL';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   docDetailWin.close();
			}
		});
	},
	returnData: function(){
		var me = this;
		var win = me.getRegItems()['ParentContainer'];
		var documentID = win.getRegItems()['DocumentID'];
		var execType = 'RETURN';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   docDetailWin.close();
			}
		});
	},
	returncancelData: function(){
		var me = this;
		var win = me.getRegItems()['ParentContainer'];
		var documentID = win.getRegItems()['DocumentID'];
		var execType = 'RETURNCANCEL';
		
		var param = {'ActionType': NBOX_C_UPDATE, 'DocumentID': documentID, 'ExecType': execType};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
            	   docDetailWin.close();
			}
		});
	},
	doublelineData: function(){
		var me = this;
		
		var docDetailViewLine = me.getRegItems()['DocDetailViewLine'];
   		var docDetailViewRcvUser = me.getRegItems()['DocDetailViewRcvUser'];
   		var docDetailViewRefUser = me.getRegItems()['DocDetailViewRefUser'];
   			
   		openDocLinePopupWin(1,'B',docDetailViewLine,docDetailViewRcvUser,docDetailViewRefUser);
	},
	clearData: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	
    	var docDetailViewDoubleLine = me.getRegItems()['DocDetailViewDoubleLine'];
    	var docDetailViewLine = me.getRegItems()['DocDetailViewLine'];
    	var docDetailViewBasis = me.getRegItems()['DocDetailViewBasis'];
    	var docDetailViewFile = me.getRegItems()['DocDetailViewFile'];
    	var docDetailViewRcvUser = me.getRegItems()['DocDetailViewRcvUser'];
    	var docDetailViewRefUser = me.getRegItems()['DocDetailViewRefUser'];
    	var docDetailViewComment = me.getRegItems()['DocDetailViewComment'];
    	
    	me.clearPanel();
    	
    	store.removeAll();
    	docDetailViewDoubleLine.clearData();
    	docDetailViewLine.clearData();
    	docDetailViewBasis.clearData();
    	docDetailViewFile.clearData();
    	docDetailViewRcvUser.clearData();
    	docDetailViewRefUser.clearData();
    	docDetailViewComment.clearData();
    },
    loadPanel: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var frm = me.getForm();
    	var win = me.getRegItems()['ParentContainer'];
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			var detailToolbar = win.getRegItems()['DetailToolbar'];
			
			switch (win.getRegItems()['Box']){
				case 'XA002': //기안문서
					
					if(record.data.NextSignedFlag == 'Y' )
						detailToolbar.setToolBars(['draftcancel'], false);
				
					break;
					
				case 'XA003': //미결문서
				
					if( record.data.DoubleLineFirstFlag == 'Y' )
						detailToolbar.setToolBars(['doubleline'], true);
				
					if( record.data.DraftFlag == 'Y' && record.data.NextSignedFlag == 'Y' )
						detailToolbar.setToolBars(['draftcancel'], false);
					
					if( record.data.DraftFlag == 'Y' && record.data.NextSignedFlag == 'N' )
						detailToolbar.setToolBars(['draftcancel'], true);
				
					if ( record.data.DraftFlag == 'N' && record.data.CurrentSignFlag == 'Y'){
						
						switch(record.data.CurrentStatus){
							case 'C':
								detailToolbar.setToolBars(['confirmcancel'], true);
								break;
							case 'R':
								detailToolbar.setToolBars(['returncancel'], true);
								break;
							default:
								detailToolbar.setToolBars(['confirm','return'], true);
								break;
						}
					}
					
					break;
				case 'XA004': //기결문서
				
					if ( record.data.DraftFlag == 'N' && record.data.CurrentSignFlag == 'Y'){
						
						switch(record.data.CurrentStatus){
							case 'C':
								detailToolbar.setToolBars(['confirmcancel'], true);
								break;
							case 'R':
								detailToolbar.setToolBars(['returncancel'], true);
								break;
							default:
								detailToolbar.setToolBars(['confirm','return'], true);
								break;
						}
					}
				
					if ( record.data.DraftFlag == 'N' && record.data.NextSignFlag == 'Y') {
						switch(record.data.CurrentStatus){
							case 'C':
								detailToolbar.setToolBars(['confirmcancel'], true);
								break;
							case 'R':
								detailToolbar.setToolBars(['returncancel'], true);
								break;
							default:
								break;
						}
					}
				
					break;
				default:
					break;
			};
			
			frm.loadRecord(record);
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	
		frm.reset();
    },
    openCommentWin: function(actionType, documentID, seq){
    	var me = this;
    	
    	var docDetailViewComment = me.getRegItems()['DocDetailViewComment'];
    	docDetailViewComment.openCommentWin(actionType, documentID, seq);
    },
    openPreviewWin: function(documentID){
    	var me = this;
    	openDocPreviewWin(documentID);
    }
});	


/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	