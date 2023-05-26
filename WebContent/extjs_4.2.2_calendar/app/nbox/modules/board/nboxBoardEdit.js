/**************************************************
 * Common variable
 **************************************************/
var toDay = new Date();
toDay.setMonth(toDay.getMonth() + 1);

var boardEditPanelWidth = 660;
var boardControlPanelWidth = 650;
/*var boardControlWidth = */

/**************************************************
 * Common Code
 **************************************************/
Ext.define('nbox.boardDetailEditImportantStore', {
	extend: 'Ext.data.Store',
	fields: ["CODE", 'NAME'],
	autoLoad: true,
	proxy: {
        type: 'direct',
        extraParams: {MASTERID: 'NB01'},
        api: { read: 'nboxCommonService.selectCommonCode' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	
	

/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.boardDetailEditModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'NOTICEID'}, 
    	{name: 'FILEATTACHFLAG'}, 
    	{name: 'IMPORTANT'}, 
    	{name: 'SUBJECT'}, 
    	{name: 'CONTENTS'},
    	{name: 'USERNAME'}, 
    	{name: 'USERCODE'}, 	    	
    	{name: 'MYAUTH', type: 'int'}, 
    	{name: 'ALWAYSTOP', type: 'bool'},
    	{name: 'POPUPFLAG', type: 'bool'},
    	{name: 'READCOUNT', type: 'int'}, 
    	{name: 'LOADDATE', type: 'date'},
    	{name: 'ALARMENDDATE', type: 'date', dateFormat:'Y-m-d'}
    ]
});	

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.boardDetailEditStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.boardDetailEditModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { 
        	read: 'nboxBoardService.select'
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
//Detail Edit Panel
Ext.define('nbox.boardDetailEdit', {
	extend: 'Ext.form.Panel',
	
	config: {
		regItems: {}
    },
    
    layout: {
    	type: 'border'
    },
	
	width: 850,
	
	border: false,
	
	api: { submit: 'nboxBoardService.save' },
	
	initComponent: function () {
		var me = this;
		
		var boardDetailEditImportantStore = Ext.create('nbox.boardDetailEditImportantStore',{});
		
		var boardEditHeaders = Ext.create('Ext.panel.Panel', { 
        	layout: {
				type: 'table',
				columns: 2
			},
			border: false,
			defaultType: 'textfield',
			items: [
				{ 
					name: 'SUBJECT',
					fieldLabel: '제목',
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					width: boardControlPanelWidth,
					allowBlank:false,
					colspan: 2,
					tdAttrs:{
						style: {
						 'padding': '3px 3px 0px 3px'
					   	}
					}
				},
				{ 
					xtype: 'combo', 
					name:'IMPORTANT',
					fieldLabel: '중요도', 
					store: boardDetailEditImportantStore, 
					displayField:'NAME', 
					valueField: 'CODE', 
					value: 'N0002',
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false,
					tdAttrs:{
						style: {
							'padding': '3px 3px 0px 3px'
				    	}
					}
				}, 
				{
					xtype: 'checkboxfield',
					name:'ALWAYSTOP', 
					fieldLabel: '항상위',
					labelAlign : 'right' ,
					tdAttrs:{
						style: {
							'padding': '3px 3px 0px 3px'
					   	}
					}
				},
				{ 
					xtype: 'datefield',
					name:'ALARMENDDATE', 
					fieldLabel: '팝업종료일',
					format: 'Y-m-d', 
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false,
					value: toDay,
					tdAttrs:{
						style: {
							'padding': '3px 3px 0px 3px'
					    }
					}
				},
				{ 
					xtype: 'checkboxfield',
					name:'POPUPFLAG',
					fieldLabel: '팝업알림',
					labelAlign : 'right',
					tdAttrs: {
						style: {
							'padding': '3px 3px 0px 3px'
						}
			        }
		        }
			]
        });
		
		var boardEditContents = Ext.create('Ext.form.HtmlEditor', {
			name: 'CONTENTS',
        	flex: 1,
        	style: {
        		'margin': '5px 5px 5px 5px'
        	}
		});

		var boardEditUploadFile = Ext.create('Unilite.com.panel.UploadPanel', {
	    	/*itemId: 'fileUploadPanel',*/
	    	url: CPATH + '/nboxfile/boardupload.do',
	    	downloadUrl: CPATH + '/nboxfile/boarddownload/',
	    	listeners: {
	    		change: function() {
                    if( boardDetailWin.isVisible() ) {       // 처음 윈도열때는 윈독 존재 하지 않음.

                    }
	    		}
	    	},
	    	style: {
        		'margin': '0px 5px 5px 5px'
        	}
		});
		
		var boardEditContentsPanel = Ext.create('Ext.panel.Panel',{
			region:'north',
			layout: {
				type: 'vbox',
				align: 'stretch'
			},
			border: false,
			height: '80%',
			items: [
				boardEditHeaders,
				boardEditContents
			]
		});
		
		var boardEditUploadFilePanel = Ext.create('Ext.panel.Panel',{
			region:'south',
			layout: {
				type: 'fit'
			},
			border: false,
			height: '20%',
			items: [boardEditUploadFile]
		});
		
		me.items = [
			boardEditContentsPanel,
			boardEditUploadFilePanel
		];
		
		me.getRegItems()['BoardEditUploadFile'] = boardEditUploadFile;
		me.getRegItems()['BoardEditContents'] = boardEditContents;

		me.callParent();
	},
    queryData: function(){
    	var me = this;
    	
    	var boardEditUploadFile = me.getRegItems()['BoardEditUploadFile'];
		var store = me.getRegItems()['Store'];
		var win = me.getRegItems()['ParentContainer'];
		var noticeID = win.getRegItems()['NoticeID'];
		
		me.clearData();
		
		switch (win.getRegItems()['ActionType']){
    		case NBOX_C_CREATE:
	    	case NBOX_C_READ:
	    		break;
	    		
    		case NBOX_C_UPDATE:
				store.proxy.setExtraParam('NOTICEID', noticeID);
        		
       			store.load({
	       			callback: function(records, operation, success) {
	       				if (success){
	       					me.loadPanel();
	       				}
	       			}
       			});
       			
       			if(noticeID != '' && noticeID != null && noticeID  !== 'undefined' )	{
    		    	nboxBoardService.getFileList(
    		    			{NOTICEID : noticeID},
    						function(provider, response) {
    		    				boardEditUploadFile.loadData(response.result);
    						}
    				);
    			}else {
    				boardEditUploadFile.clear(); //fp.loadData() 실행 시 데이타 삭제됨.
    			}
	    		break;
	    	
			case NBOX_C_DELETE:
				break;
				
			default:
				break;
		}
    },
    saveData: function(){
    	var me = this;
    	
    	var win = me.getRegItems()['ParentContainer'];
		var noticeID = win.getRegItems()['NoticeID'];
		var menuID = win.getRegItems()['MenuID'];
		
		var isNew = ( noticeID == "" || noticeID == null);
		var boardEditUploadFile = me.getRegItems()['BoardEditUploadFile'];
		
		var addFiles = boardEditUploadFile.getAddFiles();
		var delFiles = boardEditUploadFile.getRemoveFiles();
		
		if (addFiles.length == 0) addFiles = null;
		if (delFiles.length == 0) delFiles = null;
		
		var param = {'MENUID': menuID, 'NOTICEID': noticeID, 'ADDFID': addFiles,'DELFID': delFiles};
		
		if (me.isValid()) {
			me.submit({
            	params: param,
                success: function(obj, action) {
                	if(isNew)
                	{
                		win.getRegItems()['NoticeID'] = action.result.NOTICEID;
                	}
                	boardEditUploadFile.reset();
                	win.getRegItems()['ActionType'] = NBOX_C_READ;
                	win.formShow();
                }
            });
        }
        else {
        	Ext.Msg.alert('확인', me.validationCheck());
        }
    },
    clearData: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	
    	me.clearPanel();
    	
    	store.removeAll();
    },
	loadPanel: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
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

/**************************************************
 * Create
 **************************************************/


/**************************************************
 * User Define Function
 **************************************************/	