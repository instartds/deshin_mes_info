	/**************************************************
	 * Common variable
	 **************************************************/
	//local  variable
	var controlWidth = 487;
	/**************************************************
	 * Common Code
	 **************************************************/
	
	/**************************************************
	 * Model
	 **************************************************/
	// RCV User List
	Ext.define('nbox.noteEditRcvUserModel', {
	    extend: 'Ext.data.Model',
	    fields: [
 	    	{name: 'NoteID'}, 
	    	{name: 'RcvUserID'}, 
	    	{name: 'RcvUserName'},
	    	{name: 'RcvUserDeptName'}
 	    ]
	});	

	/**************************************************
	 * Store
	 **************************************************/
	//RCV User List
	Ext.define('nbox.noteEditRcvUserStore', {
		extend: 'Ext.data.Store',
		model: 'nbox.noteEditRcvUserModel',
		autoLoad: false,
		proxy: {
            type: 'direct',
            api: { read: 'nboxNoteListService.selectRcvUser' },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        },
        copyData: function(store){
        	var me = this;
        	var records = [];
        	
        	store.each(function(r){
    			records.push(r.copy());
    		});
    		
    		me.add(records);
        }
	});		

		
	/**************************************************
	 * Define
	 **************************************************/
	//RCV User List
	Ext.define('nbox.noteEditRcvUserView',{
		extend: 'Ext.view.View',
		config: {
			regItems: {}
		},
		loadMask:false,
	    cls: 'nbox-feed-list',
	    itemSelector: '.nbox-feed-sel-item',
	    selectedItemCls: 'nbox-feed-seled-item', 
	    width: controlWidth - 27,
		initComponent: function () {
			var me = this;
			
			me.tpl = new Ext.XTemplate(
				'<table cellpadding="0" cellspacing="0" width="100%" margin="0 0 0 0">',
					'<tr>',
						'<td style="border:0px; padding:3px; width:40px; text-align:right">',
							'<label>수신:</label>',
						'</td>',
						'<td style="border:1px solid #C0C0C0; padding:3px; ">',
							'<span class="f9pt">&nbsp;</span>',
							'<tpl for=".">', 
								'<span class="f9pt">{RcvUserName}</span>',
								'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
					       	'</tpl>',
				    	'</td>',
					'</tr>',
		       	'</table>'
			); 
			
			me.callParent();
		},		
	    listeners: {
	    	itemclick: function(view, record, item, index, e, eOpts) {
	       	}
	    },
	    queryData: function(){
	    	var me = this;
	    	
	    	var rcvUserID = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['RcvUserID'];
	    	var store = me.getStore();
	    	
	    	store.proxy.setExtraParam('SRTYPE', 'C');
	    	store.proxy.setExtraParam('USER_ID', rcvUserID);
	    	
	    	store.load({
				callback: function(records, operation, success) {
	   				if (success){
	   					me.loadData();
	   				}
	   			}
			});
	   	},
	   	clearData: function(){
	   		var me = this;
	   		
	   		me.clearPanel();
	   	},
	    loadData: function(){
	       
	    },
	    clearPanel: function(){
	   		var me = this;
	   		var store = me.getStore();
	   		
	   		store.removeAll();
	   	}
	});	

	//RcvUser Panel
	Ext.define('nbox.noteEditRcvUserPanel', { 
		extend: 'Ext.panel.Panel',
		config: {
			regItems: {}
	    },
	    layout: {
			type: 'hbox'
		},
		border: false,
		initComponent: function () {
			var me = this;
			
			var noteEditRcvUserStore = Ext.create('nbox.noteEditRcvUserStore', {}) ; 
			var noteEditRcvUserView = Ext.create('nbox.noteEditRcvUserView', {
	    		store: noteEditRcvUserStore
	    	});
			
			var btn =  {	
				xtype: 'button',
				text: '<img src="' + NBOX_IMAGE_PATH + 'popup.png" width=13 height=13/>',
			    itemId: 'btnrcvuser',
			    style: 'width:26px; height:23px; margin-top:3px; margin-right:3px; padding-left:0px;',
			    handler: function() {
			    	me.buttonDown();
			    }
			};
			
			me.items = [noteEditRcvUserView , btn] ;
			
			me.getRegItems()['NoteEditRcvUserView'] = noteEditRcvUserView;
			noteEditRcvUserView.getRegItems()['ParentContainer'] = me;
			            
			me.callParent();
		},
		buttonDown: function(){
			var me = this;
	   		var noteEditRcvUserView = me.getRegItems()['NoteEditRcvUserView'];
	   			
	   		openSelectUserPopupWin(noteEditRcvUserView);
		},
		queryData: function(){
			var me = this;
			var noteEditRcvUserView = me.getRegItems()['NoteEditRcvUserView'];
			
			noteEditRcvUserView.queryData();
		},
		clearData: function(){
	    	var me = this;
	    	var noteEditRcvUserView = me.getRegItems()['NoteEditRcvUserView'];
	    	
	    	noteEditRcvUserView.clearData();
	    }
	});

	//Detail Edit Panel
	Ext.define('nbox.noteEditPanel', {
		extend: 'Ext.form.Panel',
		
		config: {
			regItems: {}
	    },
	    
		layout: {
			type: 'vbox'
		},
		
		border: false,
		
		api: { submit: 'nboxNoteListService.save' }, 

		initComponent: function () {
			var me = this;
		
			var noteEditRcvUserPanel = Ext.create('nbox.noteEditRcvUserPanel', {}); 
			var noteEditContentPanel = Ext.create('Ext.panel.Panel', {
				layout: 'fit',
	        	width: controlWidth,
	        	height: 210,
	        	border: false,
	        	padding : '3px 3px 3px 3px',
				items: [
					{ 
						xtype: 'textareafield',
						name: 'Contents',
						autoScroll: true,
						allowBlank: false 
			        }
		    	]
			});
			var noteEditFileUploadPanel = Ext.create('Unilite.com.panel.UploadPanel', {
				id: 'nboxNoteFileUploadPanel',
		    	itemId: 'fileUploadPanel',
		    	width: controlWidth,
		    	height: 150,
		    	url: CPATH + '/nboxfile/noteupload.do',
		    	downloadUrl: CPATH + '/nboxfile/notedownload/',
		    	listeners: {
		    		change: function() {
		    		}
		    	},
				style: {
				 	'padding': '0px 3px 3px 3px'
			   	}
			});
			
			me.items = [
				noteEditRcvUserPanel,
				noteEditContentPanel,
				noteEditFileUploadPanel
			];
			
			me.getRegItems()['NoteEditRcvUserPanel'] = noteEditRcvUserPanel;
			noteEditRcvUserPanel.getRegItems()['ParentContainer'] = me;
			
			me.getRegItems()['NoteEditFileUploadPanel'] = noteEditFileUploadPanel;

	  		me.callParent();
		},
		queryData: function(){
	    	var me = this;
	    	var noteEditRcvUserPanel = me.getRegItems()['NoteEditRcvUserPanel'];
	    	
	    	me.clearData();
	    	
	    	noteEditRcvUserPanel.queryData();
		},	
	    saveData: function(){
	    	var me = this;
	    	var noteID = null;
	    	
	    	var noteEditFileUploadPanel = me.getRegItems()['NoteEditFileUploadPanel'];
			var noteEditRcvUserView = me.getRegItems()['NoteEditRcvUserPanel'].getRegItems()['NoteEditRcvUserView']; 
			
			var addFiles = noteEditFileUploadPanel.getAddFiles();
			var delFiles = noteEditFileUploadPanel.getRemoveFiles();
			
			var rcvuserlist = []; 
			var rcvusers = noteEditRcvUserView.getStore().data.items;
			
			Ext.each(rcvusers,function(record){
				rcvuserlist.push(me.JSONtoString(record.data));
			});
			
			if (addFiles.length == 0) addFiles = null;
			if (delFiles.length == 0) delFiles = null;
			
			if (rcvuserlist.length == 0) rcvuserlist = null;
			
			var param = {
				 'SendNoteID': noteID, 
			     'ADDFID': addFiles,
			     'DELFID': delFiles,
			     'RCVUSERS': rcvuserlist
			};
			
			if (me.isValid()) {
				me.submit({
					params: param,
					success: function(obj, action) {
						var win = me.getRegItems()['ParentContainer'];
						win.close();
						
						/*if (me.getRegItems()['ActionType'] == NBOX_C_CREATE){
							Ext.Msg.alert('확인', '쪽지가 전송 되었습니다.');
							me.clearData();
						}else{
							editFileUploadPanel.reset();
							detailWin.close();
						}*/
					}
				});
			}
			else {
				Ext.Msg.alert('확인', me.validationCheck());
			} 
	    },
	    clearData: function(){
	    	var me = this;
	    	
	    	var noteEditRcvUserPanel = me.getRegItems()['NoteEditRcvUserPanel'];
	    	var noteEditFileUploadPanel = me.getRegItems()['NoteEditFileUploadPanel'];
	    	
	    	me.clearPanel();
	    	
	    	noteEditRcvUserPanel.clearData();
	    	noteEditFileUploadPanel.clear();
	    },
		loadData: function(){
	    	/*var me = this;
	    	var store = me.getRegItems()['StoreData'];
	    	var frm = me.getForm();
	    	
	    	if (store.getCount() > 0)
	    	{
				var record = store.getAt(0);
				frm.loadRecord(record);
	    	} */
	    },
	    clearPanel: function(){
	    	var me = this;
	    	var frm = me.getForm();
	    	
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
	    },
	    JSONtoString: function (object) {
	        var results = [];
	        for (var property in object) {
	            var value = object[property];
	            if (value)
	                results.push('\"' + property.toString() + '\": \"' + value + '\"');
	            }
	                     
	            return '{' + results.join(String.fromCharCode(11)) + '}';
	    }
	});	