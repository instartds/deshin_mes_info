<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="${PRGID}" >
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	/**************************************************
	 * Require
	 **************************************************/
	Ext.require([
	    'Ext.ux.PreviewPlugin'
	    /* 'Ext.LoadMask'  */
	]);
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


	/**************************************************
	 * Define
	 **************************************************/
	//Detail toolbar
	 Ext.define('nbox.approval.form.detailToolbar',    {
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
	             handler: function() {
	            	 var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	            	 
	            	 if (nboxBaseApp)
	            		 nboxBaseApp.SaveButtonDown();       
	             }
	         };

	         var btnDelete = {
	             xtype: 'button',
	             text: '삭제',
	             tooltip : '삭제',
	             itemId : 'delete',
	             width: btnWidth,  
	             height: btnHeight,
	             handler: function() {
	            	 var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                     
                     if (nboxBaseApp)
                         nboxBaseApp.DeleteButtonDown();                 
	             }
	         };         
	         
	         var btnClose = {
	             xtype: 'button',
	             text: '닫기',
	             tooltip : '닫기',
	             itemId : 'close',
	             width: btnWidth,  
	             height: btnHeight,
	             handler: function() { 
	            	 var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                     
                     if (nboxBaseApp)
                         nboxBaseApp.CloseButtonDown();
	             }               
	         };
	        
	         var btnPrev = {
	             xtype: 'button',
	             text: '이전',
	             tooltip : '이전페이지',
	             itemId : 'prev',
	             width: btnWidth,  
	             height: btnHeight,
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
	             handler: function() { 
	            	 var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                     
                     if (nboxBaseApp)
                         nboxBaseApp.NextButtonDown();
	             }
	         };          
	         
	         var toolbarItems = [btnSave, btnDelete, btnPrev, btnNext, btnClose];
	         
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
            
	         me.items = toolbarItems
	         
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
        	formID: null,
        	actionType: null,
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

            var nboxFormDetailEditStore = Ext.create('nbox.approval.form.detailEditStore', {
            	id:'nboxFormDetailEditStore'
            });
            
            var nboxFormDetailToolbar = Ext.create('nbox.approval.form.detailToolbar', {
            	id:'nboxFormDetailToolbar'
            });
            var nboxFormDetailEditPanel = Ext.create('nbox.approval.form.detailEditPanel', {
            	id:'nboxFormDetailEditPanel',
            	store: nboxFormDetailEditStore
            });
            
            me.items = [title, nboxFormDetailToolbar, nboxFormDetailEditPanel];
            
            me.callParent(); 
        },
        listeners: {
        	 render: function(viewport, eOpts){
        		 var me = this;

             }
        },
        SaveButtonDown: function(){
            var me = this;
            
            me.saveData();
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
        saveData: function(){
            var me = this;
            var nboxFormDetailEditPanel = Ext.getCmp('nboxFormDetailEditPanel');
            
            if (nboxFormDetailEditPanel)
            	nboxFormDetailEditPanel.saveData();
        },
        deleteData: function(){
            var me = this;
            var nboxFormDetailEditPanel = Ext.getCmp('nboxFormDetailEditPanel');
            
            if (nboxFormDetailEditPanel)
                nboxFormDetailEditPanel.deleteData();
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
        formShow: function(){
            var me = this;
            var nboxFormDetailEditPanel = Ext.getCmp('nboxFormDetailEditPanel');
            
            if (nboxFormDetailEditPanel)
                nboxFormDetailEditPanel.queryData();
        },
        fnInitBinding : function(params) {
            var me = this;

            me.setFormID(params.formID);
            me.formShow();
        }
    });
	
    
    /**************************************************
     * Create
     **************************************************/
    

    //Load Mask
    //var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Please wait..."});
    
    var nboxBaseApp = Ext.create('nbox.baseApp',  {  
    	id:'nboxBaseApp'
    });
    
    var params = {
            'formID'        : '${FORMID}'
       }
            
    nboxBaseApp.fnInitBinding(params);
    /**************************************************
     * User Define Function
     **************************************************/

}; // appMain

</script>	
