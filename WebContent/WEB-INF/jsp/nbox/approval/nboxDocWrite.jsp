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
    //local  variable
    //var console = window.console;
    
    /**************************************************
     * NBox UserInfo
     **************************************************/
    Ext.define('nbox.extraUserInfoStore', {
        extend: 'Ext.data.Store',
        fields: ["posName", "roleName", 'emailAddr', 'grade_level'],
        
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
    

    //Viewport toolbar
    Ext.define('nbox.viewportToolbar',    {
        extend:'Ext.toolbar.Toolbar',
        config: {
            regItems: {}
        },
        dock : 'top',
        height: 30, 
        
        initComponent: function () {
            var me = this;
            var btnWidth = 60;
            var btnHeight = 26;
            
            var btnNew = {
                xtype: 'button',
                //scale: 'medium',
                tooltip : '새문서',
                //text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/new16a.png" width=15 height=15/>&nbsp;<label>새문서</label>', 
                text: '<label>새문서</label>',
                itemId : 'new',
                width: btnWidth,  
                height: btnHeight,
                style: { margin: '0px 0px 0px 3px' },
                
                handler: function() { 
                	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                    if (nboxBaseApp)
                           nboxBaseApp.NewButtonDown();
                }
            };
            
            var btnSave =  {    
                xtype: 'button',
                tooltip: '저장',
                //text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/save16a.png" width=15 height=15/>&nbsp;<label>저장</label>',
                text: '<label>저장</label>',
                itemId: 'save',
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
                tooltip : '상신',
                //text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/draft16a.png" width=15 height=15/>&nbsp;<label>상신</label>',  
                text: '<label>상신</label>',
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
            
            var btnClose = {
                xtype: 'button',
                tooltip : '닫기',
                //text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/close16a.png" width=15 height=15/>&nbsp;<label>닫기</label>', 
                text: '<label>닫기</label>',
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
            
            var toolbarItems = [btnNew, btnSave, btnDraft, btnClose ];    
                
            
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
        	documentID:null,
        	actionType:null,
        	docBox: null,
        	interfaceKey:null,
        	gubun:null,
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
            
            var btnWidth = 26;
            var btnHeight = 26; 
            
            var title = {
                xtype: 'container',
                cls: 'uni-pageTitle',
                id: 'UNILITE_PG_TITLE',
                html: "${PGM_TITLE}",
                padding: '0 0 5px 0',
                height: 32,
                region:'north'
            };
            
            var viewportToolbar = Ext.create('nbox.viewportToolbar',{
            	id:'nboxBaseAppViewportToolbar'
            });   

            var nboxDocEditStore = Ext.create('nbox.docEditStore', {
            	id:'nboxDocEditStore'
            		
            });
            var nboxDocEditPanel = Ext.create('nbox.docEditPanel',{
            	id: 'nboxDocEditPanel',
            	store: nboxDocEditStore
            });            

            me.items = [title, viewportToolbar, nboxDocEditPanel];
            
            me.callParent(); 
        },
        listeners: {
            render: function(viewport, eOpts){
            	var me = this;
                    
            }
        },
        NewButtonDown: function(){
            var me = this;
            
            me.newData();
        },
        SaveButtonDown: function(){
            var me = this;
            
            me.saveData();
        },
        DraftButtonDown: function(){
            var me = this;
            
            me.draftData();
        },
        CloseButtonDown: function(){
            var me = this;
            
            me.closeData();
        },    
        newData: function(){
            var me = this;
            var nboxDocEditPanel = Ext.getCmp("nboxDocEditPanel");
            var nboxDocEditFormCombo = Ext.getCmp('nboxDocEditFormCombo');

            nboxDocEditFormCombo.disabled = false;

            if (nboxDocEditPanel){
            	nboxDocEditPanel.newData();
            }
        },
        saveData: function(){
            var me = this;
            var nboxDocEditPanel = Ext.getCmp("nboxDocEditPanel");
            
            if (nboxDocEditPanel)
            	nboxDocEditPanel.saveData();
        },      
        draftData: function(){
            var me = this;
            var nboxDocEditPanel = Ext.getCmp("nboxDocEditPanel");
            
            if (nboxDocEditPanel)
            	nboxDocEditPanel.draftData();
        },
        closeData: function(){
            var tabPanel = parent.Ext.getCmp('contentTabPanel');
            
            if(tabPanel) {
                var activeTab = tabPanel.getActiveTab();
                var canClose = activeTab.onClose(activeTab);
                if(canClose)  {
                    tabPanel.remove(activeTab);
                }
            } else {
                //me.hide();
            }
        },
        fnInitBinding : function(params) {
            var me = this;
            var formID;
            var contents;
            var nboxDocEditFormCombo = Ext.getCmp('nboxDocEditFormCombo');
            var nboxDocEditContentsPanel = Ext.getCmp('nboxDocEditContentsPanel');
            var docEditContentsHtmlEditor = nboxDocEditContentsPanel.items.items[0];
            
            me.newData();
            
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
            
            if (!Ext.isEmpty( me.getInterfaceKey())){
                nboxDocCommonService.getInterfaceForm(
                	{GUBUN : me.getGubun(), INTERFACEKEY: me.getInterfaceKey()},
                	function(provider, response) {
                        formID = response.result.records.FORMID;
                        contents = response.result.records.CONTENTS;
                        
                        if (contents)
                        {
                            if (docEditContentsHtmlEditor.InstanceReadyFlag)
                                docEditContentsHtmlEditor.setValue(contents);
                            else
                                docEditContentsHtmlEditor.tempData = contents;
                        }
                        
                        if (formID)
                        {
                            nboxDocEditFormCombo.setValue(formID);
                            nboxDocEditFormCombo.disabled = true;
                        }
                });
            }
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
                    id: 'nboxBaseApp',
                    actionType: NBOX_C_CREATE
                });

                var params = {
                        'interfaceKey'      : '${INTERFACEKEY}',
                        'gubun'             : '${GUBUN}',
                        'documentID'        : '${DOCUMENTID}'
                     }

                nboxBaseApp.fnInitBinding(params);
            }
        }
     });
     
     /*
     nboxDocListService.nfnTest({},
             function(provider, response) {
            	 
     });
     */
     /*
     nboxDocCommonService.selectCabinetItem(
             {},
             function(provider, response) {
                 
                });
     */ 
    /* //Viewport Create
    Ext.create('nbox.baseApp',  {       
    }); */

    /**************************************************
     * User Define Function
     **************************************************/
     
}; // appMain

</script>	
