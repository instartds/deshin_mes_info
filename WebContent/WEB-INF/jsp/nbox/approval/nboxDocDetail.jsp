<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="${PRGID}" >
</t:appConfig>
<script type="text/javascript" >
/**************************************************
 * Require
 **************************************************/
Ext.require([
    'Ext.ux.PreviewPlugin'
    /* 'Ext.LoadMask'  */
]);
		
function appMain() {
	/**************************************************
	 * Common variable
	 **************************************************/

	/**************************************************
	 * Common Code
	 **************************************************/
	    
	/**************************************************
	 * Model
	 **************************************************/

	/**************************************************
	 * Store
	 **************************************************/
    Ext.define('nbox.extraUserInfoStore', {
        extend: 'Ext.data.Store',
        fields: ["posName", "roleName", 'emailAddr', 'gradeLevel'],
        
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: { read: 'nboxCommonService.selectUserInfo' },
            reader: {
                type: 'json',
                root: 'records'
            }
        }
    }); 

	/**************************************************
	 * Define
	 **************************************************/
	//Detail toolbar
	Ext.define('nbox.docDetailToolbar',    {
	    extend:'Ext.toolbar.Toolbar',
	    dock : 'top',
	    config: {
	        regItems: {}
	    },
	    
	    initComponent: function () {
	        var me = this;
	        var btnWidth = 60;
	        var btnWidth1 = 80;
            var btnHeight = 26;
            
	        var btnEdit = {
	            xtype: 'button',
	            text: '수정',
	            tooltip : '수정',
	            itemId : 'edit',
	            width: btnWidth,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() { 
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
	            		nboxBaseApp.EditButtonDown();
	            }
	        };
	        
	        var btnSave = {
	            xtype: 'button',
	            text: '저장',
	            tooltip : '저장',
	            itemId : 'save',
	            width: btnWidth,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() {
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
	            		nboxBaseApp.SaveButtonDown();       
	            }
	        };
	        
	        var btnDraft = {
	            xtype: 'button',
	            text: '상신',
	            tooltip : '상신',
	            itemId : 'draft',
	            width: btnWidth,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() {
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.DraftButtonDown();      
	            }
	        };
	        
	        var btnDraftCancel = {
	            xtype: 'button',
	            text: '상신취소',
	            tooltip : '상신취소',
	            itemId : 'draftcancel',
	            width: btnWidth1,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() {
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.DraftCancelButtonDown();        
	            }
	        };
	        
	        var btnConfirm = {
	            xtype: 'button',
	            text: '결재승인',
	            tooltip : '결재승인',
	            itemId : 'confirm',
	            width: btnWidth1,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() {
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.ConfirmButtonDown();        
	            }
	        };
	            
	        var btnConfirmCancel = {
	            xtype: 'button',
	            text: '승인취소',
	            tooltip : '승인취소',
	            itemId : 'confirmcancel',
	            width: btnWidth1,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() {
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.ConfirmCancelButtonDown();      
	            }
	        };
	        
	        var btnReturn = {
	            xtype: 'button',
	            text: '반려',
	            tooltip : '반려',
	            itemId : 'return',
	            width: btnWidth,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() {
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.ReturnButtonDown();     
	            }
	        };
	            
	        var btnReturnCancel = {
	            xtype: 'button',
	            text: '반려취소',
	            tooltip : '반려취소',
	            itemId : 'returncancel',
	            width: btnWidth1,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() {
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.ReturnCancelButtonDown();       
	            }
	        };
	        
	        var btnDelete = {
	            xtype: 'button',
	            text: '삭제',
	            tooltip : '삭제',
	            itemId : 'delete',
	            width: btnWidth,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() {
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.DeleteButtonDown();                 
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
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.CancelButtonDown();
	            }
	        };
	        
	        var btnPreview = {
	            xtype: 'button',
	            text: '미리보기',
	            tooltip : '미리보기',
	            itemId : 'preview',
	            width: btnWidth1,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() { 
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.PreviewButtonDown();
	            }
	        };   
	        
	        var btnComment = {
	            xtype: 'button',
	            text: '댓글',
	            tooltip : '댓글쓰기',
	            itemId : 'comment',
	            width: btnWidth,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() { 
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.CommentButtonDown();
	            }
	        };  
	        
	        
	        var btnDoubleLine = {
	            xtype: 'button',
	            text: '이중결재선',
	            tooltip : '이중결재선',
	            itemId : 'doubleline',
	            width: btnWidth1,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() { 
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.DoubleLineButtonDown();
	            }               
	        };
	        
	        var btnPrev = {
	            xtype: 'button',
	            text: '이전',
	            tooltip : '이전페이지',
	            itemId : 'prev',
	            width: btnWidth,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() {
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.PrevButtonDown();
	            }
	        };
	        
	        var btnNext = {
	            xtype: 'button',
	            text: '다음',
	            tooltip : '다음페이지',
	            itemId : 'next',
	            width: btnWidth,  
                height: btnHeight,
	            style: { margin: '0px 0px 0px 3px' },
	            handler: function() { 
	            	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	
	            	if (nboxBaseApp)
                        nboxBaseApp.NextButtonDown();
	            }
	        };   
	        
	        var btnClose = {
	                xtype: 'button',
	                tooltip : '닫기',
	                text: '닫기',
	                itemId : 'close',
	                width: btnWidth,  
	                height: btnHeight,
	                style: { margin: '0px 0px 0px 3px' },
	                handler: function() { 
	                	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	                    if (nboxBaseApp)
	                           nboxBaseApp.CloseButtonDown();
	                }
	            };
	        
	        var toolbarItems = [btnEdit, btnSave, btnDelete, btnCancel, btnPreview, btnComment, '-',  btnDraft, btnDraftCancel, btnConfirm, btnConfirmCancel, btnReturn, btnReturnCancel, '-', btnClose];    
                
            
            //var chk01 = false;
            var chk01 = ( typeof IS_DEVELOPE_SERVER == "undefined") ? false : IS_DEVELOPE_SERVER ;
            if( chk01 ) {
                toolbarItems.push( // space
                    '->',
                    {
                        xtype : 'button',
                        text : '',
                        tooltip : '현재탭 Reload(Cache 사용 안함!)', 
                        iconCls: 'icon-reload',
                        handler : function() {
                            location.reload(true );
                        }
                    },
                    {
                        xtype : 'button',
                        text : '',
                        tooltip : '현재 Tab을 새창으로 띄우기', 
                        iconCls: 'icon-newWindow',
                        handler : function() {
                            window.open(window.location.href, '_blank');
                        }
                    }
                );
            }
	        
	        me.items = toolbarItems;
	        
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


	//Viewport
    Ext.define('nbox.baseApp', {
        extend: 'Ext.Viewport',
        config:{
            documentID: null,
            actionType: null,
            docBox: null,
            interfaceKey: null,
            gubun: null,
            gradeLevel: null,
            regItems: {}
        },
        defaults: { padding: 0 },
        layout : {  
            type: 'vbox', 
            pack: 'start', 
            align: 'stretch' 
        },
        initComponent: function () {
            var me = this;
            
            UniAppManager.setApp(me);

            var title = {
                xtype: 'container',
                cls: 'uni-pageTitle',
                id: 'UNILITE_PG_TITLE',
                html: "${PGM_TITLE}",
                padding: '0 0 5px 0',
                height: 32,
                region:'north'
            };

            var nboxDocDetailToolbar = Ext.create('nbox.docDetailToolbar', {
                id: 'nboxDocDetailToolbar'
            });   
            
            var nboxDocDetailViewStore = Ext.create('nbox.docDetailViewStore', {
                id: 'nboxDocDetailViewStore'
            });
            
            var nboxDocEditStore = Ext.create('nbox.docEditStore', {
                id: 'nboxDocEditStore'
            });
                        
            var nboxDocDetailView = Ext.create('nbox.docDetailView',{
                id: 'nboxDocDetailView',
                store: nboxDocDetailViewStore
            });
            
            var nboxDocEditPanel = Ext.create('nbox.docEditPanel', {
                id: 'nboxDocEditPanel',
                store: nboxDocEditStore
            });
            
            me.items = [title, nboxDocDetailToolbar, nboxDocDetailView, nboxDocEditPanel];
            
            me.callParent(); 
        },
        listeners: {
        	 render: function(viewport, eOpts){
        		 var me = this;
                 
             }
        	
        },
        EditButtonDown: function() {
            var me = this;
            
            me.editData();
        },
        SaveButtonDown: function(){
            var me = this;
            
            me.saveData();
        },
        DraftButtonDown: function(){
            var me = this;
            
            me.draftData();
        },
        DraftCancelButtonDown: function(){
            var me = this;
            
            me.draftcancelData();
        },
        ConfirmButtonDown: function(){
            var me = this;
            
            me.confirmData();
        },
        ConfirmCancelButtonDown: function(){
            var me = this;
            
            me.confirmcancelData();
        },
        ReturnButtonDown: function(){
            var me = this;
            
            me.returnData();
        },
        ReturnCancelButtonDown: function(){
            var me = this;
            
            me.returncancelData();
        },
        DoubleLineButtonDown: function(){
            var me = this;
            
            me.doublelineData();
        },
        DeleteButtonDown: function(){
            var me = this;
            
            Ext.Msg.confirm('확인', '삭제 하시겠습니까?', 
            function(btn) {
                if (btn === 'yes') {
                    me.deleteData();
                    return true;
                } else {
                    return false;
                }
            });
        },
        CancelButtonDown: function(){
            var me = this;
            
            me.cancelData();
        },
        PreviewButtonDown: function(){
            var me = this;
            
            me.previewData();
        },
        CommentButtonDown: function(){
            var me = this;
            
            me.commentData();
        },
        CloseButtonDown: function(){
            var me = this;
            
            me.closeData();
        },
        PrevButtonDown: function(){
            var me = this;
            
            me.prevData();
        },
        NextButtonDown: function(){
            var me = this;
            
            me.nextData();
        },    
        editData: function(){
            var me = this;
            
            me.setActionType(NBOX_C_UPDATE);
            me.formShow();
        },
        saveData: function(){
            var me = this;
            var nboxDocEditPanel = Ext.getCmp('nboxDocEditPanel');
            
            if (nboxDocEditPanel)
                nboxDocEditPanel.saveData();
        },
        draftData: function(){
            var me = this;
            
            switch(me.getActionType())
            {
                case NBOX_C_READ:
                    var currentForm = Ext.getCmp('nboxDocDetailView');
                    break;
                case NBOX_C_CREATE:
                case NBOX_C_UPDATE:
                    var currentForm = Ext.getCmp('nboxDocEditPanel');
                    break
            }
            
            currentForm.draftData();
        },
        draftcancelData: function(){
            var me = this;
            var nboxDocDetailView = Ext.getCmp('nboxDocDetailView');

            if (nboxDocDetailView)
                nboxDocDetailView.draftcancelData();
        },
        confirmData: function(){
            var me = this;
            var nboxDocDetailView = Ext.getCmp('nboxDocDetailView');

            if (nboxDocDetailView)
                nboxDocDetailView.confirmData();
        },
        confirmcancelData: function(){
            var me = this;
            var nboxDocDetailView = Ext.getCmp('nboxDocDetailView');

            if (nboxDocDetailView)
                nboxDocDetailView.confirmcancelData();
        },
        returnData: function(){
            var me = this;
            var nboxDocDetailView = Ext.getCmp('nboxDocDetailView');

            if (nboxDocDetailView)
                nboxDocDetailView.returnData();
        },
        returncancelData: function(){
            var me = this;
            var nboxDocDetailView = Ext.getCmp('nboxDocDetailView');

            if (nboxDocDetailView)
                nboxDocDetailView.returncancelData();
        },
        doublelineData: function(){
            var me = this;
            var nboxDocDetailView = Ext.getCmp('nboxDocDetailView');

            if (nboxDocDetailView)
                nboxDocDetailView.doublelineData();
        },
        deleteData: function(){
            var me = this;
            var nboxDocDetailView = Ext.getCmp('nboxDocDetailView');

            if (nboxDocDetailView)
                nboxDocDetailView.deleteData();
        },
        cancelData: function(){
            var me = this;

            switch(me.getActionType())
            {
                case NBOX_C_UPDATE:
                    me.setActionType(NBOX_C_READ);
                break;
                
                case NBOX_C_CREATE:
                case NBOX_C_READ:
                case NBOX_C_DELETE:
                    break;
                
                default:
                    break;
            }

            me.formShow();
        },
        previewData: function(){
            var me = this;
            var nboxDocDetailView = Ext.getCmp('nboxDocDetailView');
            var documentID = me.getDocumentID();
            
            if (nboxDocDetailView)
                nboxDocDetailView.openPreviewWin(documentID);
        },
        commentData: function(){
            var me = this;
            var nboxDocDetailView = Ext.getCmp('nboxDocDetailView');
            var documentID = me.getDocumentID();
            
            if (nboxDocDetailView)
                nboxDocDetailView.openCommentWin(NBOX_C_CREATE, documentID, null);
        },
        closeData: function(){
        	var me = this;
            var tabPanel = parent.Ext.getCmp('contentTabPanel');
            
            if(tabPanel) {
                var activeTab = tabPanel.getActiveTab();
                var canClose = activeTab.onClose(activeTab);
                if(canClose)  {
                    tabPanel.remove(activeTab);
                }
            } else {
                me.hide();
            }
        },
        prevData: function(){
            var me = this;
            
        },
        nextData: function(){
            var me = this;
            
        },
        queryData: function(){
            var me = this;
            var nboxDocDetailView = Ext.getCmp('nboxDocDetailView');
            
            if (nboxDocDetailView)
                nboxDocDetailView.queryData();
        },
        formShow: function(){
            var me = this;
            
            var nboxDocDetailToolbar = Ext.getCmp('nboxDocDetailToolbar')
            var nboxDocDetailView = Ext.getCmp('nboxDocDetailView');
            var nboxDocEditPanel = Ext.getCmp('nboxDocEditPanel');

            switch(me.getActionType())
            {
                case NBOX_C_READ:
                    switch(me.getDocBox()){
                        case 'XA001': //임시문서
                            nboxDocDetailToolbar.setToolBars(['edit','draft','delete', 'preview', 'close', 'prev', 'next'], true);
                            nboxDocDetailToolbar.setToolBars(['draftcancel', 'confirm', 'confirmcancel', 'return', 'returncancel', 'comment'], false);
                            break;
                        case 'XA002': //기안문서
                            nboxDocDetailToolbar.setToolBars(['draftcancel', 'close', 'prev', 'next'], true);
                            nboxDocDetailToolbar.setToolBars(['edit', 'draft', 'confirm', 'confirmcancel', 'return', 'returncancel', 'delete', 'comment', 'save', 'cancel'], false);
                            break;
                        case 'XA003': case 'XA004': case 'XA011':  //미결문서,기결문서
                            nboxDocDetailToolbar.setToolBars(['comment', 'close', 'prev', 'next'], true);
                            nboxDocDetailToolbar.setToolBars(['edit', 'draft', 'draftcancel','confirm', 'confirmcancel', 'return', 'returncancel', 'delete'], false);
                            break;
                        case 'XA005':  case 'XA006': case 'XA007':  case 'XA008': case 'XA009': case 'XA010': case 'XA012': case 'XA013'://예결문서, 참조, 수신, 발신, 회사결재문서함, 기결상세함, 개인결재문서함
                            nboxDocDetailToolbar.setToolBars(['comment', 'close', 'prev', 'next'], true);
                            nboxDocDetailToolbar.setToolBars(['edit', 'draft', 'draftcancel','confirm', 'confirmcancel', 'return', 'returncancel', 'delete'], false);
                            break;
                        case 'XA999'://결재조회만
                            nboxDocDetailToolbar.setToolBars(['comment', 'close'], true);
                            nboxDocDetailToolbar.setToolBars(['edit', 'draft', 'draftcancel','confirm', 'confirmcancel', 'return', 'returncancel', 'delete', 'prev', 'next'], false);
                            break;
                        default:
                            break;
                    }                   
                    
                    nboxDocDetailToolbar.setToolBars(['save', 'cancel', 'doubleline'], false);
                    
                    nboxDocDetailView.clearData();
                    
                    nboxDocDetailView.show();
                    nboxDocEditPanel.hide();
                    
                    nboxDocDetailView.queryData();
                    break;
                    
                case NBOX_C_UPDATE:
                    nboxDocDetailToolbar.setToolBars(['save', 'draft', 'cancel', 'close'], true);
                    nboxDocDetailToolbar.setToolBars(['edit', 'draftcancel', 'confirm', 'confirmcancel', 'return', 'returncancel', 'delete', 'preview', 'comment', 'prev', 'next'], false);
                    
                    nboxDocEditPanel.clearData();
                    
                    nboxDocDetailView.hide();
                    nboxDocEditPanel.show();
                    
                    nboxDocEditPanel.queryData();
                    
                    break;

                case NBOX_C_DELETE:
                    nboxDocDetailView.hide();
                    nboxDocEditPanel.hide();
                    break;
                    
                case NBOX_C_CREATE:
                    nboxDocDetailToolbar.setToolBars(['save', 'draft', 'cancel', 'close'], true);
                    nboxDocDetailToolbar.setToolBars(['edit', 'draftcancel', 'confirm', 'confirmcancel', 'return', 'returncancel', 'doubleline', 'delete', 'preview', 'comment', 'prev', 'next'], false);
                    
                    nboxDocEditPanel.clearData();
                    
                    nboxDocDetailView.hide();
                    nboxDocEditPanel.show();
                    
                    nboxDocEditPanel.queryData();
                    
                    break;
                    
                default:
                	nboxDocDetailToolbar.setToolBars(['edit', 'save', 'delete', 'cancel', 'preview', 'comment', 'draft', 'draftcancel', 'confirm', 'confirmcancel', 'return', 'returncancel'], false);
                    nboxDocDetailView.clearData();
                
                    nboxDocDetailView.show();
                    nboxDocEditPanel.hide();
                    
                    nboxDocDetailView.queryData();
                    
                    break;
            }
        },
        fnInitBinding : function(params) {
            var me = this;

            me.setDocumentID(params.documentID);
            me.setDocBox(params.box);
            
            if (me.getDocumentID()){
                me.setActionType(NBOX_C_READ);
            }
            else{
                me.setActionType(NBOX_C_CREATE);
            }
            
            me.setInterfaceKey(params.interfaceKey);
            me.setGubun(params.gubun);
            me.setGradeLevel(params.gradeLevel)
            
            
            me.formShow();
        }
    });
	
    
    /**************************************************
     * Create
     **************************************************/
    

    //Load Mask
    //var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Please wait..."});
    
    var extraUserInfoStore = Ext.create('nbox.extraUserInfoStore',{});
    extraUserInfoStore.load({
        callback: function(records, operation, success) {
            if (success){
                UserInfo.posName = records[0].data.posName;
                UserInfo.roleName = records[0].data.roleName;
                //UserInfo.emailAddr = records[0].data.emailAddr;
                
                //Viewport Create
                var nboxBaseApp = Ext.create('nbox.baseApp',  {  
                	id:'nboxBaseApp'
                });
                
               var params = {
                    'interfaceKey'      : '${INTERFACEKEY}',
                    'gubun'             : '${GUBUN}',
                    'documentID'        : '${DOCUMENTID}',
                    'box'               : '${BOX}',
                    'gradeLevel'        : records[0].data.gradeLevel,
               }
                    
               nboxBaseApp.fnInitBinding(params);
            }
        }
    });

    /**************************************************
     * User Define Function
     **************************************************/

}; // appMain

</script>	
