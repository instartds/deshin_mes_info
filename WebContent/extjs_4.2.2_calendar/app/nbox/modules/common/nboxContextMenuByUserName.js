	/**************************************************
	 * Common variable
	 **************************************************/
	//local  variable
	var userInfoPopupWin ;
	
	var userInfoPopupWidth = 850;
	var userInfoPopupHeight = 700;
	
	var noteEditPopupWin ;
	
	var noteEditPopupWidth = 500;
	var noteEditPopupHeight = 500;
	
	var mailEditorWin ;
	
	var mailEditPopupWidth = 850;
	var mailEditPopupHeight = 700;
	
	/**************************************************
	 * Store
	 **************************************************/
	Ext.define('nbox.userEmailStore', {
		fields: ['USEREMAIL'],
		extend: 'Ext.data.Store',
		autoLoad: false,
		proxy: {
			type: 'direct',
		    api: { read: 'nboxCommonService.selectUserEmail' },
		    reader: {
		        type: 'json',
		        root: 'records'
	        }
	    }
	});		
	
	
	/**************************************************
	 * Define
	 **************************************************/
	//User Menu ContextMenu
	Ext.define('nbox.contextMenuByUserName', {
	 	extend: 'Ext.menu.Menu',
	 	
	 	config: {
	 		regItems: {}
	 	},
	 	
	 	initComponent: function () {
	     	var me = this;
	 		
	     	me.items = [
	     	    {
	     	    	text   : '쪽지보내기',
	     	    	itemId : 'sendNote',
	     	    	handler: function(){
	 			    	me.SendNoteButtonDown();
	 			 	}
	 			},
	 		    {
	 				text   : '메일보내기',
	 				itemId : 'sendMail',
	 				handler: function(){
	 			    	me.SendMailButtonDown();
	 			    }
	 			},
	 			'-',
	 			{
	 				text   : '상세정보보기',
	 				itemId : 'showInfo',
	 				handler: function(){
	 			    	me.ShowInfoButtonDown();
	 			    }
	 			}
	 		];
	     	
	         me.callParent(); 
	     },    
	     SendNoteButtonDown: function(){
	    	 var me = this;
	    	 me.sendNote();
	     },
	     SendMailButtonDown: function(){
	    	 var me = this;
	    	 me.sendMail();
	     },
	     ShowInfoButtonDown: function(){
	    	 var me = this;
	    	 me.showInfo();
	     },
	     sendNote: function(){
	    	 var me = this;
	    	 
	    	 openNoteEditPopupWin(me.getRegItems()['UserID']);
	     },
	     sendMail: function(){
	    	 var me = this;
	    	 
	    	 openMailEditPopupWin(me.getRegItems()['UserID']);
	     },
	     showInfo: function(){
	    	 var me = this;
	    	 
	    	 openUserInfoPopupWin(me.getRegItems()['UserID']);
	     }
	});
	
	// Note Popup toolbar
	Ext.define('nbox.noteEditPopupToolbar',    {
        extend:'Ext.toolbar.Toolbar',
        config: {
			regItems: {}
		},
		dock : 'top',
		height: 30, 
		padding: '0 0 0 5px',
		
		initComponent: function () {
	    	var me = this;
	    	var btnWidth = 26;
	    	var btnHeight = 26;
	    	
	    	var btnSave =  {	
				xtype: 'button', scale: 'medium',
				tooltip: '보내기',
			    iconCls: 'icon-save', 
			    itemId: 'save',
			    width: btnWidth, height: btnHeight,
			            
			    handler: function() {
			    	me.getRegItems()['ParentContainer'].SaveButtonDown();
			    }
			};	    	

			var btnClose = {
				xtype: 'button', scale: 'medium',
			 	tooltip : '닫기',
                iconCls : 'icon-close'  , 
                itemId : 'close',
                width: btnWidth, height: btnHeight,
                
                handler: function() { 
                	me.getRegItems()['ParentContainer'].CloseButtonDown();
                }
			};
			
		    var toolbarItems = [ btnSave, btnClose ];    
		        
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
	
	// Note Edit Popup Window
	Ext.define('nbox.noteEditPopupWindow',{
		extend: 'Ext.window.Window',
		config: {
			regItems: {}    	
		},
		layout: {
	        type: 'fit' 
	    },
	    
		title: '쪽지보내기',
		
        width: noteEditPopupWidth,
        height: noteEditPopupHeight,
        
        modal: true,
        resizable: false,
        
	    initComponent: function () {
			var me = this;
			
			var noteEditPopupToolbar = Ext.create('nbox.noteEditPopupToolbar',{});
			var noteEditPanel = Ext.create('nbox.noteEditPanel', {});
			
			me.dockedItems = [noteEditPopupToolbar];
			me.items = [noteEditPanel];
			
			me.getRegItems()['NoteEditPopupToolbar'] = noteEditPopupToolbar;
			noteEditPopupToolbar.getRegItems()['ParentContainer'] = me;
			
			me.getRegItems()['NoteEditPanel'] = noteEditPanel;
			noteEditPanel.getRegItems()['ParentContainer'] = me;
			
			me.callParent(); 
	    },
	    listeners: {
	    	beforeshow: function(obj, eOpts){
	    		var me = this;
    			console.log(me.id + ' beforeshow -> noteEditPopupWin');
    			
    			me.formShow();
	    	},
		    beforehide: function(obj, eOpts){
		    	var me = this;
	    		console.log(me.id + ' beforehide -> noteEditPopupWin')
	    	},
	    	beforeclose: function(obj, eOpts){
	    		var me = this;
	    		console.log(me.id + ' beforeclose -> noteEditPopupWin');
	    		
	    		noteEditPopupWin = null;
	    	}
	    },
	    SaveButtonDown: function(){
	    	var me = this;
	    	
	    	me.saveData();
	    },
	    CloseButtonDown: function(){
			var me = this;
			
		    me.closeData();
	    },
	    queryData: function(){
	    	var me = this;
	    	var noteEditPanel = me.getRegItems()['NoteEditPanel'];
	    	
	    	noteEditPanel.queryData();
	    },
	    saveData: function(){
	    	var me = this;
	    	var noteEditPanel = me.getRegItems()['NoteEditPanel'];
	    	
	    	noteEditPanel.saveData();
	    },
	    closeData: function(){
			var me = this;
			
		    me.close();
	    },
	    formShow: function(){
	    	var me = this;
	    	
	    	me.queryData();
	    }
	});		
	
	// User Infomation PopupWindow
	Ext.define('nbox.userInfoPopupWindow',{
		extend: 'Ext.window.Window',
		config: {
			regItems: {}    	
		},
		layout: {
	        type: 'fit' 
	    },
	    
		title: '상세정보',
		
        width: userInfoPopupWidth,
        height: userInfoPopupHeight,
        
        modal: true,
        resizable: false,
        
	    initComponent: function () {
			var me = this;
			
			var userInfoContentsPanel = Ext.create('nbox.userInfoContentsPanel', {});
			
			me.items = [userInfoContentsPanel];
			
			me.getRegItems()['UserInfoContentsPanel'] = userInfoContentsPanel;
			userInfoContentsPanel.getRegItems()['ParentContainer'] = me;
			
	        
			me.callParent(); 
	    },
	    listeners: {
	    	beforeshow: function(obj, eOpts){
	    		var me = this;
    			console.log(me.id + ' beforeshow -> userInfoPopupWin');
    			
    			me.queryData();
	    	},
		    beforehide: function(obj, eOpts){
		    	var me = this;
	    		console.log(me.id + ' beforehide -> userInfoPopupWin')
	    	},
	    	beforeclose: function(obj, eOpts){
	    		var me = this;
	    		console.log(me.id + ' beforeclose -> userInfoPopupWin');
	    		
	    		userInfoPopupWin = null;
	    	}
	    },
	    QueryButtonDown: function(){
	    	var me = this;
	    	
	    	me.queryData();
	    },
	    CancelButtonDown: function(){
			var me = this;
			
		    me.closeData();
	    },
	    queryData: function(){
	    	var me = this;
	    	var userInfoContentsPanel = me.getRegItems()['UserInfoContentsPanel'];
	    	userInfoContentsPanel.queryData();
	    },
	    closeData: function(){
			var me = this;
			
		    me.close();
	    }
	});
	
	/**************************************************
	 * Create
	 **************************************************/
	var userEmailStore = Ext.create('nbox.userEmailStore', {});
	var myEmailStore = Ext.create('nbox.userEmailStore', {});
	
	/**************************************************
	 * User Define Function
	 **************************************************/
	// Note Window Open
	function openNoteEditPopupWin(userID) {
		// detailWin
		if(!noteEditPopupWin){
			noteEditPopupWin = Ext.create('nbox.noteEditPopupWindow', { 
			}); 
			
			noteEditPopupWin.center();
		} 
		
		noteEditPopupWin.getRegItems()['RcvUserID'] = userID;
		noteEditPopupWin.show();
    }		
	
	// Note Window Open
	function openMailEditPopupWin(userID) {
		// detailWin
		if(!mailEditorWin){
			mailEditorWin = Ext.create('nbox.mailEditorWindow', { 
			}); 
			
			mailEditorWin.center();
		}
		
		userEmailStore.proxy.setExtraParam('UserID', userID);
		userEmailStore.load({
   			callback: function(records, operation, success) {
   				if (success){
   					
   					myEmailStore.proxy.setExtraParam('UserID', UserInfo.userID);
   					myEmailStore.load({
   						callback: function(records, operation, success) {
	   						if (success){
	   							if( records.length > 0 ) 
	   			   					mailEditorWin.getRegItems()['MYEMAIL'] = records[0].data.USEREMAIL;
	   						}
   						}
   					});
   					
   					if( records.length > 0 ) 
	   					mailEditorWin.getRegItems()['USEREMAIL'] = records[0].data.USEREMAIL;
   					
   					mailEditorWin.show();
   				}
   			}
		});
		
    }		
	
	//User Info Window Open
	function openUserInfoPopupWin(userID) {
		// detailWin
		if(!userInfoPopupWin){
			userInfoPopupWin = Ext.create('nbox.userInfoPopupWindow', { 
			}); 
			
			userInfoPopupWin.center();
		} 
		
		userInfoPopupWin.getRegItems()['USER_ID'] = userID;
		userInfoPopupWin.show();
    }			

	