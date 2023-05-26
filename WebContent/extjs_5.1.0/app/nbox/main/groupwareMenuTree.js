/**************************************************
 * Common variable
 **************************************************/
var winWidth = 400;
var winHeight = 400;

var propertyWin = null;
var menuUserWin = null;

var NBOX_C_NEWMENU_TITLE = '새 메뉴';
var NBOX_C_MENU_NEW = 'NEW';
var NBOX_C_MENU_UPDATE = 'UPDATE';
var NBOX_C_MENU_RENAME = 'RENAME';
var NBOX_C_MENU_DELETE = 'DELETE';


/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.main.groupwareMenuPanelModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'PGM_ID'}, 
    	{name: 'PGM_NAME'}
    ]
});

Ext.define('nbox.main.groupwareMenuModel', {
	extend:'Ext.data.Model',
    fields: [ 	{name: 'id'}
    			,{name: 'compcode'}
             	,{name: 'prgID'}
    			,{name: 'text'}
    			,{name: 'text_en'}
    			,{name: 'text_cn'}
    			,{name: 'text_jp'}
    			,{name: 'url'}
    			,{name: 'viewYN'}
    			,{name: 'qtip', convert: function(value, record) {return record.get('text'+CUR_LANG_SUFFIX);}}
    			,{name: 'index'}
    			,{name: 'box'}
    			,{name: 'pgm_div'}
    			,{name: 'type'}
    			,{name: 'moduleid'}
    			,{name: 'cmenuvalue'}

		]
});

Ext.define('nbox.main.groupwareMenuPropertyModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'COMP_CODE'}, 
    	{name: 'PGM_SEQ'}, 
    	{name: 'PGM_ID'}, 
    	{name: 'PGM_TYPE'}, 
    	{name: 'PGM_LEVEL'}, 
    	{name: 'UP_PGM_DIV'}, 
    	{name: 'PGM_ARNG_SEQ'}, 
    	{name: 'PGM_NAME'}, 
    	{name: 'LOCATION'}, 
    	{name: 'TYPE'},
    	{name: 'USE_YN'},
    	{name: 'AUTHO_TYPE'},
    	{name: 'AUTHO_PGM'},
    	{name: 'REMARK'},
    	{name: 'URL_DISPLAY'},
    	{name: 'URL'},
    	{name: 'NBOX_URL'},
    	{name: 'NBOX_BOX'},
    	{name: 'CMENUVALUE'},
    	{name: 'INSERT_DB_USER'},
    	{name: 'INSERT_DB_TIME'},
    	{name: 'UPDATE_DB_USER'},
    	{name: 'UPDATE_DB_TIME'}
    ]
});		


Ext.define('nbox.main.groupwareMenuUserModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'ID'},
    	{name: 'COMP_CODE'},
    	{name: 'USER_ID'},
    	{name: 'USER_NAME'},
    	{name: 'DEPT_CODE'},
    	{name: 'DEPT_NAME'},
    	{name: 'POST_CODE'},
    	{name: 'POST_NAME'},
    	{name: 'ABIL_CODE'},
    	{name: 'ABIL_NAME'},
    	{name: 'PGM_ID'},
    	{name: 'PGM_LEVEL'},
    	{name: 'UPDATE_MAN'},
    	{name: 'UPDATE_DATE'},
    	{name: 'PGM_LEVEL2'},
    	{name: 'AUTHO_USER'}
    ]
});		


/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.main.groupwareMenuPanelStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareMenuPanelModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareMenuService.selectGroupMenu' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareMenuAllTreeStore',{
	extend  : 'Ext.data.TreeStore',
	model   : 'nbox.main.groupwareMenuModel',
    autoLoad: true,
    proxy   : {
    			type: 'direct',
    			api : {
    					read : 'groupwareMenuService.selectMenuAll'
    				  }
    }
});

Ext.define('nbox.main.groupwareMenuTreeStore',{
	extend  : 'Ext.data.TreeStore',
	model   : 'nbox.main.groupwareMenuModel',
    autoLoad: true,
    proxy   : {
    			type : 'direct',
    			api  : {
    						read   : 'groupwareMenuService.selectMenu',
    						update : 'groupwareMenuService.saveMenu',
    						destroy: 'groupwareMenuService.deleteMenu'
    				   }
    }
});

Ext.define('nbox.main.groupwareMenuPropertyStore', {
	extend  : 'Ext.data.Store',
	model   : 'nbox.main.groupwareMenuPropertyModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
          	   	api   : {
          	   				read: 'groupwareMenuService.selectMenuProperty' 
          	   			},
          	   	reader: {
          	   				type: 'json',
          	   				root: 'records'
          	   			}
          	   }
});

Ext.define('nbox.main.groupwareMenuUserStore', {
	extend  : 'Ext.data.Store',
	model   : 'nbox.main.groupwareMenuUserModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
          	   	api   : {
          	   				read: 'groupwareMenuService.selectMenuUser' 
          	   			},
          	   	reader: {
          	   				type: 'json',
          	   				root: 'records'
          	   			}
          	   }
});

//Combobox
Ext.define('nbox.main.groupwareMenuTypeStore', {
  extend  : 'Ext.data.Store', 
  fields  : ["CODE", 'NAME'],
  autoLoad: true,
  proxy   : {
	  			type       : 'direct',
	  			extraParams: {
	  							'MAIN_CODE' : 'B009', 
	  							'SUB_CODE[]': ['2','9']
	  						 },
            	api        : {
            					read: 'groupwareMenuService.selectCommonCode' 
            				 },
            	reader     : {
            					type: 'json',
            					root: 'records'
            				 }
             }
});	


/**************************************************
 * Define
 **************************************************/
//Groupware ContextMenu
Ext.define('nbox.main.groupwareContextMenu', {
	extend: 'Ext.menu.Menu',
	config: {
		regItems: {}
	},
	initComponent: function () {
    	var me = this;
		
    	me.items = [
    	    {
    	    	text   : '새로만들기',
    	    	itemId : 'newMenu',
    	    	handler: function(){
			    	me.getRegItems()['OpenContainer'].AddNewButtonDown();
			 	}
			},
		    {
				text   : '속성',
				itemId : 'propertyMenu',
				handler: function(){
			    	me.getRegItems()['OpenContainer'].PropertiesButtonDown();
			    }
			},
		    {
				text   : '이름바꾸기',
			    itemId : 'renameMenu',
			    handler: function(){
			    	me.getRegItems()['OpenContainer'].ReNameButtonDown();
			    }
			},
			{
			    text   : '삭제',
			    itemId : 'deleteMenu',
			    handler: function(){
			    	Ext.Msg.confirm('확인', '삭제 하시겠습니까?', 
				    function(btn) {
				        if (btn === 'yes') {
				        	me.getRegItems()['OpenContainer'].DeleteButtonDown();
				            return true;
				        } else {
				            return false;
				        }
			    	});
			    }
			}
		];
    	
        me.callParent(); 
    },    
    getContextMenuItemArr: function(cmenuvalue){
    	var me = this;
    	var contextMenuItemArr = [];
    	
    	for (var indx = 0; indx < me.items.items.length; indx++){
    		if (me.items.items[indx].getItemId().indexOf('menuseparator') < 0)
    			contextMenuItemArr.push(me.items.items[indx].getItemId());
    	}
    	
    	return contextMenuItemArr;
    },
    setContextMenu: function(type, cmenuvalue){
    	var me = this;
    	var menuItemArr = null;
    	var menuItemValueArr = null;
    	var enableMenu = [];
    	var disableMenu = [];
    		
    	menuItemArr = me.getContextMenuItemArr(cmenuvalue);
    	menuItemValueArr = me.setContextMenuEnableByValue(type, cmenuvalue)
    	for (var indx = 0; indx < menuItemValueArr.length; indx++){
    		if (typeof menuItemValueArr[indx] == 'undefined') continue;
    		if (typeof menuItemArr[indx] == 'undefined') continue;
    		
    		if (menuItemValueArr[indx] == '1')
    			enableMenu.push(menuItemArr[indx]);
    		else
    			disableMenu.push(menuItemArr[indx]);
    	}
	    
    	if (enableMenu.length > 0) me.setToolBars(enableMenu, true);
    	if (disableMenu.length > 0) me.setToolBars(disableMenu, false);
    },
    setContextMenuEnableByValue: function(type, cmenuvalue){
    	var me = this;
    	var menuItemValueArr = [];
    	
    	if (typeof cmenuvalue.CONTEXTMENU == 'undefined') return menuItemValueArr;
    	
		for(var indx = 0; indx < cmenuvalue.CONTEXTMENU.length; indx++){
			menuItemValueArr.push(cmenuvalue.CONTEXTMENU.charAt(indx));
		}
		
		switch(cmenuvalue.TABLE){
	    	case 'B':
	    		//menuItemValueArr[0] //newMenu
	    		if (typeof menuItemValueArr[1] != 'undefined') menuItemValueArr[1] = '0'; //propertyMenu
	    		if (typeof menuItemValueArr[2] != 'undefined') menuItemValueArr[2] = '0'; //renameMenu
	    		if (typeof menuItemValueArr[3] != 'undefined') menuItemValueArr[3] = '0'; //deleteMenu
	    		break;
	    	
	    	default:
	    		break;
		}
	
    	switch(type){
			case '2':
				if (typeof menuItemValueArr[0] != 'undefined') menuItemValueArr[0] = '0';
				break;
				
			default:
				break;
    	}
    	
    	return menuItemValueArr;
    },
    setToolBars: function(btnItemIDs, flag){
    	var me = this;
    	
		if(Ext.isArray(btnItemIDs) ) {
			for(var i = 0; i < btnItemIDs.length; i ++) {
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


//Groupware ContextMenu
Ext.define('nbox.main.groupwareMailContextMenu', {
	extend: 'Ext.menu.Menu',
	config: {
		regItems: {}
	},
	initComponent: function () {
    	var me = this;
		
    	me.items = [
    	    {
    	    	text   : '상세검색',
    	    	itemId : 'detailSearch',
    	    	handler: function(){
			    	me.getRegItems()['OpenContainer'].DetailSearchButtonDown();
			 	}
			},
		    {
				text   : '외부 POP3 가져오기',
				itemId : 'outsdiePop3',
				handler: function(){
			    	me.getRegItems()['OpenContainer'].OutsidePop3ButtonDown();
			    }
			},
    	    {
    	    	xtype: 'menuseparator'
			},
		    {
				text   : '새로만들기',
			    itemId : 'newMailbox',
			    handler: function(){
			    	me.getRegItems()['OpenContainer'].NewMailboxButtonDown();
			    }
			},
		    {
				text   : '속성',
				itemId : 'propertyMailbox',
				handler: function(){
			    	me.getRegItems()['OpenContainer'].PropertiesMailboxButtonDown();
			    }
			},
			{
			    text   : '이름바꾸기',
			    itemId : 'renameMailbox',
			    handler: function(){
			    	me.getRegItems()['OpenContainer'].ReNameMailboxButtonDown();
			    }
			},
			{
			    text   : '삭제',
			    itemId : 'deleteMailbox',
			    handler: function(){
			    	Ext.Msg.confirm('확인', '삭제 하시겠습니까?', 
				    function(btn) {
				        if (btn === 'yes') {
				        	me.getRegItems()['OpenContainer'].DeleteMailboxButtonDown();
				            return true;
				        } else {
				            return false;
				        }
			    	});
			    }
			},
			{
				text   : '새로고침',
			    itemId : 'refreshMailbox',
			    handler: function(){
			    	me.getRegItems()['OpenContainer'].RefreshMailboxButtonDown();
			    }
			},
    	    {
    	    	xtype: 'menuseparator'
			},
			{
			    text   : '스팸비우기',
			    itemId : 'emptySpamMailbox',
			    handler: function(){
			    	me.getRegItems()['OpenContainer'].EmptySpamMailboxButtonDown();
			    }
			},
			{
			    text   : '휴지통비우기',
			    itemId : 'emptyTrashMailbox',
			    handler: function(){
			    	me.getRegItems()['OpenContainer'].EmptyTrashMailboxButtonDown();
			    }
			}
		];
    	
        me.callParent(); 
    },    
    getContextMenuItemArr: function(cmenuvalue){
    	var me = this;
    	var contextMenuItemArr = [];
    	
    	for (var indx = 0; indx < me.items.items.length; indx++){
    		if (me.items.items[indx].getItemId().indexOf('menuseparator') < 0)
    			contextMenuItemArr.push(me.items.items[indx].getItemId());
    	}
    	
    	return contextMenuItemArr;
    },
    setContextMenu: function(type, cmenuvalue){
    	var me = this;
    	var menuItemArr = null;
    	var menuItemValueArr = null;
    	var enableMenu = [];
    	var disableMenu = [];
    		
    	menuItemArr = me.getContextMenuItemArr(cmenuvalue);
    	menuItemValueArr = me.setContextMenuEnableByValue(type, cmenuvalue)
    	for (var indx = 0; indx < menuItemValueArr.length; indx++){
    		if (typeof menuItemValueArr[indx] == 'undefined') continue;
    		if (typeof menuItemArr[indx] == 'undefined') continue;
    		
    		if (menuItemValueArr[indx] == '1')
    			enableMenu.push(menuItemArr[indx]);
    		else
    			disableMenu.push(menuItemArr[indx]);
    	}
	    
    	if (enableMenu.length > 0) me.setToolBars(enableMenu, true);
    	if (disableMenu.length > 0) me.setToolBars(disableMenu, false);
    },
    setContextMenuEnableByValue: function(type, cmenuvalue){
    	var me = this;
    	var menuItemValueArr = [];
    	
    	if (typeof cmenuvalue.CONTEXTMENU == 'undefined') return menuItemValueArr;
    	
    	for(var indx = 0; indx < cmenuvalue.CONTEXTMENU.length; indx++){
			menuItemValueArr.push(cmenuvalue.CONTEXTMENU.charAt(indx));
		}
		
		switch(cmenuvalue.TABLE){
	    	case 'B':
	    		//menuItemValueArr[0] //detailSearch 
	    		//menuItemValueArr[1] //outsdiePop3 
	    		//menuItemValueArr[2] //newMailbox
	    		if (typeof menuItemValueArr[3] != 'undefined') menuItemValueArr[3] = '0';//propertiesMailbox 
	    		if (typeof menuItemValueArr[4] != 'undefined') menuItemValueArr[4] = '0'; //renameMailbox
	    		if (typeof menuItemValueArr[5] != 'undefined') menuItemValueArr[5] = '0'; //deleteMailbox
	    		//menuItemValueArr[6] //refreshMailbox
	    		//menuItemValueArr[7] //emptySpamMailbox
	    		//menuItemValueArr[8] //emptyTrashMailbox'
	    		
	    		break;
	    		
	    	case 'T':
	    		if (typeof menuItemValueArr[0] != 'undefined') menuItemValueArr[0] = '0'; //detailSearch 
	    		if (typeof menuItemValueArr[1] != 'undefined') menuItemValueArr[1] = '0'; //outsdiePop3 
	    		//menuItemValueArr[2] //newMailbox
	    		//menuItemValueArr[3] //propertiesMailbox 
	    		//menuItemValueArr[4] //renameMailbox
	    		//menuItemValueArr[5] //deleteMailbox
	    		if (typeof menuItemValueArr[6] != 'undefined') menuItemValueArr[6] = '0'; //refreshMailbox
	    		//menuItemValueArr[7] //emptySpamMailbox
	    		//menuItemValueArr[8] //emptyTrashMailbox'
	    	
	    	default:
	    		break;
		}
    	
    	return menuItemValueArr;
    },
    setToolBars: function(btnItemIDs, flag){
    	var me = this;
    	
		if(Ext.isArray(btnItemIDs) ) {
			for(var i = 0; i < btnItemIDs.length; i ++) {
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

//Groupware Menu Property Popup Window General Tab
Ext.define('nbox.main.groupwareMenuGeneralPanel',  {
	extend: 'Ext.form.Panel',
	config: {
		regItems: {}
	},
	border: false,
	padding: 5,
	api: { 
    	submit: 'groupwareMenuService.save' 
	},
    initComponent: function () {
    	var me = this;
    	
    	var groupwareMenuTypeStore = Ext.create('nbox.main.groupwareMenuTypeStore', {});
    	
		me.items = [
			{ 
				xtype        : 'textfield',
				name         : 'PGM_NAME',
				fieldLabel   : '메뉴명',
				anchor       : '100%',
				padding      : 5,
				labelAlign   : 'right',
				labelClsExtra: 'required_field_label',
				allowBlank   : false
			},
			{
				xtype: 'component',
				html : '<hr style="border: 0px; height: 1px; background: #ccc;"/>'
			},
			{ 
				xtype        : 'combo', 
				id			 : 'nboxMenuGeneralPanelType',
				name         : 'TYPE',
				fieldLabel   : '메뉴형식', 
				store        : groupwareMenuTypeStore, 
				displayField : 'NAME', 
				valueField   : 'CODE', 
				padding      : 1,
				labelAlign   : 'right',
				labelClsExtra: 'required_field_label',
				allowBlank   : false
			}, 
			{
    	    	xtype     : 'textareafield',
		        name      : 'REMARK',
		        fieldLabel: '설명',
		        padding   : 1,
				labelAlign: 'right',
				rows      : 3,
				anchor: '100%'
    	    },
			{
				xtype: 'component',
				html : '<hr style="border: 0px; height: 1px; background: #ccc;"/>'
			},
			{ 
				xtype     : 'displayfield',
				name      : 'URL_DISPLAY',
				fieldLabel: 'URL',
				padding   : 1,
				labelAlign: 'right'
			},
			{
				xtype: 'component',
				html : '<hr style="border: 0px; height: 1px; background: #ccc;"/>'
			},
			{ 
				xtype     : 'displayfield',
				name      : 'INSERT_DB_TIME',
				fieldLabel: '만든날짜',
				padding   : 1,
				labelAlign: 'right'
			},
			{ 
				xtype     : 'displayfield',
				name      : 'UPDATE_DB_TIME',
				fieldLabel: '수정한날짜',
				padding   : 1,
				labelAlign: 'right'
			},
			{
		        xtype: 'hiddenfield',
		        name: 'COMP_CODE'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_SEQ'
		    },
		    {
		        xtype: 'hiddenfield',
		        name: 'PGM_ID'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_TYPE'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_LEVEL'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'UP_PGM_DIV'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_ARNG_SEQ'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_NAME_EN'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_NAME_CN'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'PGM_NAME_JP'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'LOCATION'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'USE_YN'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'AUTHO_TYPE'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'AUTHO_PGM'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'NBOX_URL'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'URL'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'NBOX_BOX'
		    },
			{
		        xtype: 'hiddenfield',
		        name: 'CMENUVALUE'
		    }
		];
    	
		me.callParent(); 
    },
    queryData: function(){
    	var me = this;
		var store = me.getRegItems()['DataStore'];
		var targetReocrd = propertyWin.getRegItems()['TargetReocrd'];
		var contextMenuValue = me.getContextMenuValue(targetReocrd.data.cmenuvalue);
		
		me.clearData();
		
		store.proxy.setExtraParam('MODULEID', MODULE_GROUPWARE.ID);
		store.proxy.setExtraParam('PGM_ID', targetReocrd.data.prgID);
		store.proxy.setExtraParam('ACTIONTYPE', propertyWin.getRegItems()['ActionType']);
		
		store.load({callback: function(record, options, success){
			if (success){
				switch(propertyWin.getRegItems()['ActionType']){
					case NBOX_C_MENU_NEW:
						record[0].set('PGM_NAME', NBOX_C_NEWMENU_TITLE);
						var typeCombo = Ext.getCmp('nboxMenuGeneralPanelType');
						if (typeCombo){
							if (typeof contextMenuValue.MODULE != 'undefined'){
								if (contextMenuValue.MODULE == 'M'){
									typeCombo.setValue('2');
									typeCombo.setReadOnly(true);
								}
							}
						}
						break;
						
					case NBOX_C_MENU_UPDATE:
						var typeCombo = Ext.getCmp('nboxMenuGeneralPanelType');
						if (typeCombo){
							if (typeof contextMenuValue.MODULE != 'undefined'){
								if (contextMenuValue.MODULE == 'M'){
									typeCombo.setValue('2');
									typeCombo.setReadOnly(true);
								}
							}
						}
						break;
						
					default:
						break;
				}
				me.loadData();
			}
		}});
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	var store = me.getRegItems()['DataStore'];
    	var frm = me.getForm();
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    	
    	var menuTabPanel = propertyWin.getRegItems()['MenuTabPanel'];
    	var menuPermissionPanel = menuTabPanel.getRegItems()['MenuPermissionPanel'];
    	menuPermissionPanel.queryData();
    },
    saveData: function(){
    	
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	var store = me.getRegItems()['DataStore'];
    	
		//store.removeAll();
		frm.reset();
    },
    getContextMenuValue: function(cmenuvalue){
    	var me = this;
    	var contextMenuValue = null;
    	
    	if (typeof cmenuvalue == 'string'){
			if (cmenuvalue.length == 0) 
				return contextMenuValue;
			else			
				contextMenuValue = eval('(' + cmenuvalue + ')');
		}
		
    	return contextMenuValue;
    }
});

//Groupware Menu Property Popup  Permission Tab Grid
Ext.define('nbox.main.groupwareMenuGrid01', {
	extend:	'Ext.grid.Panel',
	config:{
		regItems: {}
	},
    viewConfig:{
       loadMask:false
    },
    hideHeaders: true,
    sortableColumns: false, 
    multiSelect: true,
    padding: 5,
    initComponent: function () {
		var me = this;
		
        me.columns= [
	        {
	            dataIndex: 'COMP_CODE',
	            width: 50,
	            hidden: true            
	        }, 
	        {
	            dataIndex: 'USER_ID',
	            width: 80
	        }, 
	        {
	            dataIndex: 'USER_NAME',
	            flex:1
	        }, 
	        {	
	            dataIndex: 'DEPT_CODE',
	            width: 50,
	            hidden: true  
	        }, 
	        {	
	            dataIndex: 'DEPT_NAME',
	            width: 100
	        },
	        {	
	            dataIndex: 'POST_CODE',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'POST_NAME',
	            width: 80
	        },
	        {	
	            dataIndex: 'ABIL_CODE',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'ABIL_NAME',
	            width: 80,
	            hidden: true
	        },
	        {	
	            dataIndex: 'PGM_ID',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'PGM_LEVEL',
	            width: 50,
	            hidden: true
	        },
	        {	
	            dataIndex: 'UPDATE_MAN',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'UPDATE_DATE',
	            width: 50,
	            hidden: true
	        },
	        {	
	            dataIndex: 'PGM_LEVEL2',
	            width: 50,
	            hidden: true
	        },
	        {	
	            dataIndex: 'AUTHO_USER',
	            width: 50,
	            hidden: true
	        }	        
		];
    	
		me.callParent(); 
    },
    queryData: function(){
    	var me = this;
    	var menuTabPanel = propertyWin.getRegItems()['MenuTabPanel'];
    	var menuGeneralPanel = menuTabPanel.getRegItems()['MenuGeneralPanel'] 
    	var menuPropertyStore = menuGeneralPanel.getRegItems()['DataStore'];
    	var menuPropertyReocrd = menuPropertyStore.getAt(0);
    	var store = me.getStore();
    	
    	me.clearData();
    	
    	if (menuPropertyReocrd){
	    	store.proxy.setExtraParam('MODULEID', MODULE_GROUPWARE.ID);
	    	store.proxy.setExtraParam('PGM_ID', menuPropertyReocrd.data.PGM_ID);
	    	store.proxy.setExtraParam('PGM_LEVEL', menuPropertyReocrd.data.PGM_LEVEL);
	    	store.proxy.setExtraParam('UP_PGM_DIV', menuPropertyReocrd.data.UP_PGM_DIV);
	    	store.proxy.setExtraParam('ACTIONTYPE', propertyWin.getRegItems()['ActionType']);
	    	
	    	store.load({callback: function(record, options, success){
				if (success){
					me.loadData();
				}
			}});
    	}
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	
    },
    clearPanel: function(){
    	var me = this;
    	var store = me.getStore();
    	
		store.removeAll();
    }
});

//Groupware Menu Property Popup  Permission Tab User Add, Delete Button 
Ext.define('nbox.main.groupwareMenuButtonPanel', {
	extend:	'Ext.panel.Panel',
	config: {
		regItems: {}
	},
	border: false,
	layout : {
	    type : 'hbox',
	    pack : 'end'
	},
	padding: 5,
    /* api: { submit: 'nboxBoardService.saveComment' }, */
    initComponent: function () {
    	var me = this;
    	
    	var addButton = Ext.create('Ext.button.Button', {
    		text: '추가',
			tooltip : '추가',
			id: 'nboxPAddButton',
			/*itemId : 'add',*/
			width:70,
			style: {
	            margin: '0px 5px 0px 0px'
	        },
			handler: function() {
				me.getRegItems()['ParentContainer'].AddButtonDown();		
			}
    	});
    	
    	var deleteButton = Ext.create('Ext.button.Button', {
    		text: '삭제',
			tooltip : '삭제',
			id: 'nboxPDeleteButton',
			/*itemId : 'delete',*/
			width:70,
			handler: function() {
				me.getRegItems()['ParentContainer'].DeleteButtonDown();		
			}
    	});
    	
    	me.items = [
    	            {
    	            	xtype: 'checkboxfield',
    	            	id: 'nboxInheritToChild',
    	            	boxLabel: '하위 메뉴에 상속',
    	            	flex: 1
    	            },    	            
    	            addButton, 
    	            deleteButton
    	           ];
    	
    	me.callParent(); 
    }
});

//Permission Panel
Ext.define('nbox.main.groupwareMenuPermissionPanel', {
	extend:	'Ext.panel.Panel',
	config: {
		regItems: {}
	},
	border: false,
	padding: 5,
    initComponent: function () {
    	var me = this;
    	var menuGrid01 = Ext.create('nbox.main.groupwareMenuGrid01', {
    		store: groupwareGrid01Store,
    		height: 255
    	});
    	var menuButtonPanel = Ext.create('nbox.main.groupwareMenuButtonPanel', {
    		id: 'nboxMenuButtonPanel'
    	});
    	
    	me.getRegItems()['MenuGrid01'] = menuGrid01;
    	me.getRegItems()['MenuButtonPanel'] = menuButtonPanel;
    	menuGrid01.getRegItems()['ParentContainer'] = me;
    	menuButtonPanel.getRegItems()['ParentContainer'] = me;
    	
    	me.items = [
            {
            	xtype: 'label',
                text: '사용자 :'
            },
            menuGrid01,
            menuButtonPanel
    	];
    	
    	me.callParent(); 
    },
    listeners: {
    	render: function( obj, eOpts ){
    		var me = this;
    		var nboxPAddButton = me.getComponent('nboxMenuButtonPanel').getComponent('nboxPAddButton');
    		var nboxPDeleteButton = me.getComponent('nboxMenuButtonPanel').getComponent('nboxPDeleteButton');
    		var nboxInheritToChild = me.getComponent('nboxMenuButtonPanel').getComponent('nboxInheritToChild');
    		var menuTabPanel = me.getRegItems()['ParentContainer'];
    		var menuGeneralPanel = menuTabPanel.getRegItems()['MenuGeneralPanel'];
    		var store = menuGeneralPanel.getRegItems()['DataStore'];
    		var cmenuValue = menuGeneralPanel.getContextMenuValue(store.getAt(0).get("CMENUVALUE"));
   		
    		if (typeof cmenuValue.USER == 'undefined') return;
    		
    		if (cmenuValue.USER == 'P'){
	    		nboxPAddButton.setDisabled(true);
	    		nboxPDeleteButton.setDisabled(true);
	    		nboxInheritToChild.setDisabled(true);
    		}
    	}
	},
	queryData: function(){
    	var me = this;
    	var menuGrid01 = me.getRegItems()['MenuGrid01'];
		
    	menuGrid01.queryData();
		
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	
    },
    clearPanel: function(){
    	var me = this;
    	
    },
    AddButtonDown: function(){
    	var me = this;
    	openMenuUserWin(me, propertyWin.getRegItems()['TargetReocrd'], propertyWin.getRegItems()['ActionType']);
    },
    DeleteButtonDown: function(){
    	var me = this;
    	var menuGrid01 = me.getRegItems()['MenuGrid01'];
    	var store = menuGrid01.getStore();
		var selection = menuGrid01.getView().getSelectionModel().getSelection();
		if (selection) {
			store.remove(selection);
		}
    }
});

//Tab Panel
Ext.define('nbox.main.groupwareMenuTabPanel', {
	extend:'Ext.tab.Panel',
	config: {
		regItems: {}
	},
    padding: 5,
	initComponent: function () {
    	var me = this;
    	var menuGeneralPanel = Ext.create('nbox.main.groupwareMenuGeneralPanel', {});
    	var menuPermissionPanel = Ext.create('nbox.main.groupwareMenuPermissionPanel', {});
    	
    	me.getRegItems()['MenuGeneralPanel'] = menuGeneralPanel;
    	menuGeneralPanel.getRegItems()['ParentContainer'] = me;
    	menuGeneralPanel.getRegItems()['DataStore'] = groupwareMenuPropertyStore;
    	
    	me.getRegItems()['MenuPermissionPanel'] = menuPermissionPanel;
    	menuPermissionPanel.getRegItems()['ParentContainer'] = me;
    	
    	me.items = [{
            title: '일반',
            items: menuGeneralPanel
        }, {
            title: '보안',
            items: menuPermissionPanel
        }];
    	
        me.callParent(); 
    },
    queryData: function(){
    	var me = this;
    	var menuGeneralPanel = me.getRegItems()['MenuGeneralPanel']
    	
    	menuGeneralPanel.queryData();
    }
});

//Groupware Menu Property Popup 
Ext.define('nbox.main.groupwareMenuPropertyToolbar',    {
    extend:'Ext.toolbar.Toolbar',
	config: {
		regItems: {}
	},
	dock : 'bottom',
	flex: 1,
	padding: 3,
	initComponent: function () {
    	var me = this;
    	
        var btnSave = {
			xtype: 'button',
			text: '확인',
			tooltip : '확인',
			itemId : 'saveProperty',
			width: 70,
			style: {
	            margin: '0px 5px 0px 0px'
	        },
			handler: function() {
				me.getRegItems()['ParentContainer'].SaveButtonDown();		
			}
        };
        
        var btnCancel = {
			xtype: 'button',
			text: '취소',
			tooltip : '취소',
			itemId : 'cancelProperty',
			width: 70,
			handler: function() { 
				me.getRegItems()['ParentContainer'].CancelButtonDown();					
			}
        };
        	    	
		me.items = [ '->',btnSave, btnCancel];
		
    	me.callParent(); 
    },
    setToolBars: function(btnItemIDs, flag){
    	var me = this;
    	
		if(Ext.isArray(btnItemIDs) ) {
			for(var i = 0; i < btnItemIDs.length; i ++) {
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

Ext.define('nbox.main.groupwareMenuPropertyWindow',{
	extend: 'Ext.window.Window',
    width: winWidth,
    height: winHeight,
    buttonAlign: 'right',
   	modal: true,
   	resizable: true,
    closable: true,
    layout: {
        type: 'fit'
    },
    config: {
    	regItems: {}   	
    },
    initComponent: function () {
    	var me = this;
    	var menuPropertyToolbar = Ext.create('nbox.main.groupwareMenuPropertyToolbar', {});
    	var menuTabPanel = Ext.create('nbox.main.groupwareMenuTabPanel', {});
    	
    	me.getRegItems()['MenuPropertyToolbar'] = menuPropertyToolbar;
    	menuPropertyToolbar.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['MenuTabPanel'] = menuTabPanel;
    	menuTabPanel.getRegItems()['ParentContainer'] = me;
    	
		me.items = [menuTabPanel];
    	me.dockedItems = [menuPropertyToolbar];
    	me.callParent(); 
    },
    listeners: {
    	beforeshow: function(obj, eOpts){
    		var me = this;
			console.log(me.id + ' beforeshow -> PropertyWindow');
			var menuTabPanel = me.getRegItems()['MenuTabPanel'];
			menuTabPanel.queryData();
    	},
	    beforehide: function(obj, eOpts){
	    	var me = this;
    		console.log(me.id + ' beforehide -> PropertyWindow');
    	},
    	beforeclose: function(obj, eOpts){
    		var me = this;
    		console.log(me.id + ' beforeclose -> PropertyWindow');
    		propertyWin = null;
    	},
    },
    SaveButtonDown: function(){
		var me = this;
		var menuTabPanel = me.getRegItems()['MenuTabPanel'];
		var menuGeneralPanel = menuTabPanel.getRegItems()['MenuGeneralPanel']
		var menuPropertyStore = menuGeneralPanel.getRegItems()['DataStore'];
		var menuPermissionPanel = menuTabPanel.getRegItems()['MenuPermissionPanel'];
		var menuGrid01 = menuPermissionPanel.getRegItems()['MenuGrid01'];
		var menuGrid01Store = menuGrid01.getStore();
		var param = me.getStoretoCUDJSON(menuGrid01Store);
		var menuTreePanel = me.getRegItems()['OpenContainer'];
		
		menuGeneralPanel.submit({
			params : {"DELETE": param.DELETE, "CREATE": param.CREATE, "UPDATE": param.UPDATE,
				'ACTIONTYPE': me.getRegItems()['ActionType'],
				'INHERITTOCHILD':menuPermissionPanel.getComponent('nboxMenuButtonPanel').getComponent('nboxInheritToChild').getValue()},
			success: function(obj, action) {
				switch (propertyWin.getRegItems()['ActionType']){
		    		case NBOX_C_MENU_NEW:
		    			var newNode = {id: action.result.PGM_ID
		    				, compcode: action.result.COMP_CODE
	           				, prgID: action.result.PGM_ID
	           				, text: action.result.PGM_NAME
	           				, text_en: null
	           				, text_cn: null
	           				, text_jp: null
	           				, url: menuPropertyStore.getAt(0).get("URL")
	           				, viewYN: menuPropertyStore.getAt(0).get("USE_YN")
	           				, qtip: action.result.PGM_NAME
	           				, index: null
	           				, box: menuPropertyStore.getAt(0).get("NBOX_BOX")
	           				, pgm_div: menuPropertyStore.getAt(0).get("UP_PGM_DIV")
	           				, type: action.result.TYPE
	           				, moduleid: action.result.PGM_SEQ
	           				, cmenuvalue: action.result.CMENUVALUE
	           				, leaf: (action.result.TYPE == 9 ? false : true)
	           				, expanded: true};						
		    			
		    			var cmenuvalue = me.getContextMenuValue(newNode.cmenuvalue);
		    			if (typeof cmenuvalue.MODULE != 'undefined'){ 
		    				
		    				switch (cmenuvalue.MODULE){
				    			case 'M':
				    				var selModel = menuTreePanel.getSelectionModel();
				    				var selectedNode = selModel.getLastSelected();
				    				if (newNode) selectedNode.set("leaf", false);
				    				break;
				    			
				    			default:
				    				break;
		    				}
		    			}
		    			
						menuTreePanel.appendChildNode(newNode);
						break;
		    		
		    		case NBOX_C_MENU_UPDATE:
		    			var selModel = menuTreePanel.getSelectionModel();
		    	        var selectedNode = selModel.getLastSelected();
		    	        selectedNode.set("text", action.result.PGM_NAME);
		    	        selectedNode.set("type", action.result.TYPE);
		    	        selectedNode.set("cmenuvalue", action.result.CMENUVALUE);
		    	        selectedNode.set("leaf", action.result.TYPE == 9 ? false : true);
		    	        selectedNode.commit();
		    			break
		    			
		    		default:
		    			break;
				}
				
				me.closeData();
			}
		});	
    },
    CancelButtonDown: function(){
		var me = this;
	    me.closeData();
    },
    saveData: function(){
		var me = this;
    },
    closeData: function(){
		var me = this;
	    me.close();
    },
    JSONtoString: function (object) {
        var results = [];
        
        for (var property in object) {
            var value = object[property];
            if (value)
                results.push("\"" + property.toString() + "\": \"" + value + "\"");
            }
                     
        return "{" + results.join(String.fromCharCode(11)) + "}";
    },
    getStoretoCUDJSON: function(store){
    	var me = this;
    	var resultJSON = {};
    	
    	if (!store) return null;
    	switch (propertyWin.getRegItems()['ActionType']){
    		case NBOX_C_MENU_NEW:
    			resultJSON["CREATE"] = me.getModeltoArray(store.data.items);
    			break;
    			
    		default:
    			resultJSON["CREATE"] = me.getModeltoArray(store.getNewRecords());
    			break
    	}
    	
    	resultJSON["UPDATE"] = me.getModeltoArray(store.getUpdatedRecords());
    	resultJSON["DELETE"] = me.getModeltoArray(store.getRemovedRecords());
    	
    	return resultJSON;
    },
    getModeltoArray: function(model){
    	var me = this;
    	var resultArr = [];
    	
    	if (!model) return null;
    	
    	Ext.each(model, function(record){
    		resultArr.push(me.JSONtoString(record.data));
		});
    	
    	if (resultArr.length == 0) resultArr = null;
    	
    	return resultArr;
    },
    getContextMenuValue: function(cmenuvalue){
    	var me = this;
    	var contextMenuValue = null;
    	
    	if (typeof cmenuvalue == 'string'){
			if (cmenuvalue.length == 0) 
				return contextMenuValue;
			else			
				contextMenuValue = eval('(' + cmenuvalue + ')');
		}
		
    	return contextMenuValue;
    }
});

//Groupware Menu User Permissions Popup
Ext.define('nbox.main.groupwareMenuUserToolbar',    {
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
    	
    	var btnQuery = {
				xtype: 'button',
				text: '조회',
				tooltip : '조회',
				itemId : 'query',
				handler: function() { 
					me.getRegItems()['ParentContainer'].QueryButtonDown();
				}
	        };
	        
        var btnConfirm = {
			xtype: 'button',
			text: '확인',
			tooltip : '확인',
			itemId : 'confirm',
			handler: function() {
				me.getRegItems()['ParentContainer'].ConfirmButtonDown();		
			}
        };
	
        var btnClose = {
				xtype: 'button',
				text: '닫기',
				tooltip : '닫기',
				itemId : 'close',
				handler: function() {
					me.getRegItems()['ParentContainer'].CloseButtonDown();		
				}
	        };
        
	    var toolbarItems = [ btnQuery, btnConfirm, btnClose ];    
	        
        /*var chk01 = ( typeof IS_DEVELOPE_SERVER == "undefined") ? false : IS_DEVELOPE_SERVER ;
		if( chk01 ) {
			toolbarItems.push( // space
				'->',
				{	
					//xtype: 'menu',
					text: 'Grid',
					iconCls: 'menu-menuShow',
					menu: {
						xtype: 'menu',
						items:[
							{
	                            text: 'Sheet 환경 저장', 
	                            iconCls: 'icon-sheetSaveState',
	                            handler: function(widget, event) {
						        	UniAppManager.saveGridState();							          
						        }
					        },
	                        {
	                        	text: 'Sheet 환경 기본값 설정', 
	                        	iconCls: 'icon-sheetResetState',
	                            handler: function(widget, event) {
						        	UniAppManager.resetGridState();
						          
						        }
							}
						]
					}
				}
			);
		}*/
        	    	
		me.items = toolbarItems;
		
    	me.callParent(); 
    },
    setToolBars: function(btnItemIDs, flag){
    	var me = this;
    	
		if(Ext.isArray(btnItemIDs) ) {
			for(var i = 0; i < btnItemIDs.length; i ++) {
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

Ext.define('nbox.main.groupwareMenuGrid02', {
	extend:	'Ext.grid.Panel',
	config:{
		regItems: {}
	},
    viewConfig:{
       loadMask:false
    },
    hideHeaders: true,
    sortableColumns: false, 
    multiSelect: true,
    padding: 5,
    initComponent: function () {
		var me = this;
		
        me.columns= [
	        {
	            dataIndex: 'COMP_CODE',
	            width: 50,
	            hidden: true            
	        }, 
	        {
	            dataIndex: 'USER_ID',
	            width: 80
	        }, 
	        {
	            dataIndex: 'USER_NAME',
	            flex:1
	        }, 
	        {	
	            dataIndex: 'DEPT_CODE',
	            width: 50,
	            hidden: true  
	        }, 
	        {	
	            dataIndex: 'DEPT_NAME',
	            width: 80
	        },
	        {	
	            dataIndex: 'POST_CODE',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'POST_NAME',
	            width: 80
	        },
	        {	
	            dataIndex: 'ABIL_CODE',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'ABIL_NAME',
	            width: 80,
	            hidden: true
	        },
	        {	
	            dataIndex: 'PGM_ID',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'PGM_LEVEL',
	            width: 50,
	            hidden: true
	        },
	        {	
	            dataIndex: 'UPDATE_MAN',
	            width: 50,
	            hidden: true  
	        },
	        {	
	            dataIndex: 'UPDATE_DATE',
	            width: 50,
	            hidden: true
	        },
	        {	
	            dataIndex: 'PGM_LEVEL2',
	            width: 50,
	            hidden: true
	        },
	        {	
	            dataIndex: 'AUTHO_USER',
	            width: 50,
	            hidden: true
	        }	
		];
    	
		me.callParent(); 
    },
    listeners: {
    	itemdblclick: function( obj, record, item, index, e, eOpts ){
    		var me = this;
    		console.log(me.id + ' itemdblclick -> MenuGrid02');
			var menuUserWindow = me.getRegItems()['ParentContainer'];
			menuUserWindow.ConfirmButtonDown();
    	}
    },
    queryData: function(){
    	var me = this;
    	var store = me.getStore();
    	var menuTabPanel = propertyWin.getRegItems()['MenuTabPanel'];
    	var menuGeneralPanel = menuTabPanel.getRegItems()['MenuGeneralPanel'] 
    	var menuPropertyStore = menuGeneralPanel.getRegItems()['DataStore'];
    	var targetReocrd = menuUserWin.getRegItems()['TargetReocrd'];
    	var menuPropertyReocrd = menuPropertyStore.getAt(0);
    	
    	if (menuPropertyReocrd){
    		store.proxy.setExtraParam('MODULEID', MODULE_GROUPWARE.ID);
    		store.proxy.setExtraParam('PGM_ID', menuPropertyReocrd.data.PGM_ID);
    		store.proxy.setExtraParam('UP_PGM_DIV', menuPropertyReocrd.data.UP_PGM_DIV);
	    	store.proxy.setExtraParam('PGM_LEVEL', menuPropertyReocrd.data.PGM_LEVEL);
	    	store.proxy.setExtraParam('ACTIONTYPE', null);
	    	
	    	store.load({callback: function(record, options, success){
				if (success){
					me.loadData();
				}
			}});
    	}
    },
    clearData: function(){
    	var me = this;
    	
    	me.clearPanel();
    },
	loadData: function(){
    	var me = this;
    	
    },
    clearPanel: function(){
    	var me = this;
    	var store = me.getStore();
    	
		store.removeAll();
    }
});

Ext.define('nbox.main.groupwareMenuUserWindow',{
	extend: 'Ext.window.Window',
    width: winWidth,
    height: winHeight,
    /* maximizable: true, */
    buttonAlign: 'right',
   	modal: true,
   	resizable: true,
    closable: true,
    layout: {
        type: 'fit'
    },
    config: {
    	regItems: {}   	
    },
    initComponent: function () {
    	var me = this;
    	var menuUserToolbar = Ext.create('nbox.main.groupwareMenuUserToolbar', {});
    	var menuGrid02 = Ext.create('nbox.main.groupwareMenuGrid02', {
    		store: groupwareGrid02Store,
    		height: 250
    	});
    	
    	me.getRegItems()['MenuGrid02'] = menuGrid02;
    	me.getRegItems()['MenuUserToolbar'] = menuUserToolbar;
    	menuGrid02.getRegItems()['ParentContainer'] = me;
    	menuUserToolbar.getRegItems()['ParentContainer'] = me;
    	
		me.items = [menuGrid02];
    	me.dockedItems = [menuUserToolbar];
    	me.callParent(); 
    },
    listeners: {
    	beforeshow: function(obj, eOpts){
    		var me = this;
			console.log(me.id + ' beforeshow -> MenuUserWindow');
			var menuGrid02 = me.getRegItems()['MenuGrid02'];
			menuGrid02.queryData();			
    	},
	    beforehide: function(obj, eOpts){
	    	var me = this;
    		console.log(me.id + ' beforehide -> MenuUserWindow');
    	},
    	beforeclose: function(obj, eOpts){
    		var me = this;
    		console.log(me.id + ' beforeclose -> MenuUserWindow');
    		menuUserWin = null;
    	},
    },
    QueryButtonDown: function(){
    	var me = this;
    	var menuGrid02 = me.getRegItems()['MenuGrid02'];
		menuGrid02.queryData();	
    },
    ConfirmButtonDown: function(){
    	var me = this;
    	var openContainer = me.getRegItems()['OpenContainer'];
    	var menuGrid01 = openContainer.getRegItems()['MenuGrid01'];
    	var menuGrid02 = me.getRegItems()['MenuGrid02'];
    	var selections = menuGrid02.getSelectionModel().getSelection();
    	
    	if (selections.length > 0){
	    	for(var i = selections.length; i > 0; i --){
	    		if (menuGrid01.getStore().findRecord('USER_ID', selections[i - 1].get('USER_ID')) == null){
	    			/*menuGrid01.getStore().add(selections[i - 1]);*/
	    			menuGrid01.getStore().insert(menuGrid01.getStore().getCount(),  selections[i - 1].data);
	    		}
	    	}
	    }
    	
    	me.closeData();
    },
    CloseButtonDown: function(){
    	var me = this;
	    me.closeData();
    },
    closeData: function(){
		var me = this;
	    me.close();
    }
});

//Groupware Menu Panel & Sub Tree Panel
Ext.define("nbox.main.groupwareMenuTreePanel",{
	extend: 'Ext.tree.Panel',
	config: {
		regItems: {}
	}, 
	cls: "doc-tree iScroll",
	animCollapse: true,
	animate: true,
	rootVisible: false,
	border: false,
	bodyBorder: false,

	margins: '0 0 0 0',
	rowLines: false, lines: false,
	scroll: 'vertical',
	hideHeaders: true,
   
	initComponent: function () {
    	var me = this;
    	var contextMenu = Ext.create('nbox.main.groupwareContextMenu', {});
    	var mailContextMenu = Ext.create('nbox.main.groupwareMailContextMenu', {});
    	
    	var editor = Ext.create('Ext.Editor', {
    		hideEl: false,
    	    field: {
    	        xtype: 'textfield',
    	        flex: 1
    	    }
    	});
    	
    	me.plugins = [
    	           Ext.create('Ext.grid.plugin.CellEditing', {
    	           	clicksToEdit: 2,
    	           	listeners: {
    	           		beforeedit: function( editor, e, eOpts ){
    	           			var contextMenuValue = me.getContextMenuValue(e.record.get('cmenuvalue'));
    	           			if (!contextMenuValue || contextMenuValue.TABLE != 'T')
    	           				return false;
    	           		},
    	           		edit: function( editor, e, eOpts ){
    	           			e.grid.store.sync();
    	           		}
    	           	}
    	           })
    	       ];
    	me.columns= [{
    	            xtype: 'treecolumn',
    	            dataIndex: 'text',
    	            flex: 1,
    	            editor: {
    	                xtype: 'textfield',
    	                allowBlank: false,
    	                allowOnlyWhitespace: false
    	            }
    	        }];
    	
    	me.getRegItems()['ContextMenu'] = contextMenu;
    	me.getRegItems()['MailContextMenu'] = mailContextMenu;
    	/*contextMenu.getRegItems()['ParentContainer'] = me;*/
    	me.getRegItems()['Editor'] = editor;
    	
    	me.callParent(); 
    },
	listeners: {
	  	itemclick: function(t, record, item, index, e, eOpts ) {
	  		
	  		if ( record.data.url !== "" &&  record.data.type != '9')  {
	  			var url = record.data.url ; 
		  		var params = {
		  				'prgID' : record.data.prgID, 'prgName' : record.get('text'+CUR_LANG_SUFFIX), 'box' : record.data.box
				};
		  		
		  		if (typeof url !== "undefined" )
			  		openTab(record, url, params);
		  		
	  	    } else {
	  	      if (!record.isLeaf()) {
	  	        if (record.isExpanded()) {
	  	        	record.collapse(false)
	  	        } else {
	  	        	record.expand(false)
	  	        }
	  	      }
	  	    }
		},
		itemcontextmenu: function( obj, record, item, index, e, eOpts ){
			var me = this;
			var contextMenu = null;
			var contextMenuValue = null;
			
			contextMenuValue = me.getContextMenuValue(record.data.cmenuvalue);
			if (!contextMenuValue) return;
			
			//if (contextMenuValue.USER == 'A')
			
			contextMenu= me.getContextMenu(contextMenuValue);
			contextMenu.setContextMenu(record.data.type, contextMenuValue);
			contextMenu.getRegItems()['OpenContainer'] = me;
			contextMenu.getRegItems()['TargetItem'] = item;
			contextMenu.getRegItems()['TargetRecord'] = record;
			contextMenu.showAt(e.getXY());
	        /*e.stopEvent();*/
			e.preventDefault();
		},
    	beforeitemappend: function( obj, node, eOpts ){
    		if (node.get("type") == "9" && node.isLeaf()) node.set("leaf", false);
    	}
	},
	AddNewButtonDown: function(){
    	var me = this;
    	var contextMenu = me.getRegItems()['ContextMenu'];
        
    	me.addNewMenu(contextMenu);
    },
    PropertiesButtonDown: function(){
    	var me = this;
    	var contextMenu = me.getRegItems()['ContextMenu'];
        
    	me.propertiesMenu(contextMenu);
    },
    ReNameButtonDown: function(){
    	var me = this;
        
    	me.reNameMenu();
    },
    DeleteButtonDown: function(){
    	var me = this;
    	
    	me.deleteMenu();
    },
    DetailSearchButtonDown: function(){
    	Ext.Msg.alert('알림', '준비중 입니다.');
    },
    OutsidePop3ButtonDown: function(){
    	Ext.Msg.alert('알림', '준비중 입니다.');
    },
    NewMailboxButtonDown: function(){
    	var me = this;
    	var contextMenu = me.getRegItems()['MailContextMenu'];
    	
    	me.addNewMenu(contextMenu);
    },
    PropertiesMailboxButtonDown: function(){
    	var me = this;
    	var contextMenu = me.getRegItems()['MailContextMenu'];
        
    	me.propertiesMenu(contextMenu);
    },    
    ReNameMailboxButtonDown:  function(){
    	var me = this;
        
    	me.reNameMenu();
    },
    DeleteMailboxButtonDown: function(){
    	var me = this;

    	me.deleteMenu();
    },
    RefreshMailboxButtonDown: function(){
    	Ext.Msg.alert('알림', '준비중 입니다.');
    },
    EmptySpamMailboxButtonDown: function(){
    	var me = this;
    	
    	me.removeAllMail('Spam', '3000002005', 'nboxMailDustGrid');
    },
    EmptyTrashMailboxButtonDown: function(){
    	var me = this;
    	
    	me.removeAllMail('Trash', '3000002006', 'nboxMailDustGrid');
    },
    addNewMenu: function(contextMenu){
    	var me = this;
        var selModel = me.getSelectionModel();
        var selectedNode = selModel.getLastSelected();
        

        if (!selectedNode) return;
        if (!contextMenu) return;
        
        openPropertyWin(me, contextMenu.getRegItems()['TargetRecord'], NBOX_C_MENU_NEW);
    },
    propertiesMenu: function(contextMenu){
    	var me = this;
        var selModel = me.getSelectionModel();
        var selectedNode = selModel.getLastSelected();

        if (!contextMenu) return;
        if (!selectedNode) return;
        
        openPropertyWin(me, contextMenu.getRegItems()['TargetRecord'], NBOX_C_MENU_UPDATE);
    },
    reNameMenu: function(){
    	var me = this;
        var selModel = me.getSelectionModel();
        var selectedNode = selModel.getLastSelected();
        
        if (!selectedNode) return;
        me.plugins[0].startEdit(me.getSelectionModel().getLastSelected(), 0)
    },
    deleteMenu: function(){
    	var me = this;
        var selModel = me.getSelectionModel();
        var selectedNode = selModel.getLastSelected();
        var store = me.getStore();

        if(!selectedNode) return;

        if (selectedNode.hasChildNodes()){
        	for(var indx = selectedNode.childNodes.length -1; indx >= 0; indx --){
        		var recordCh = me.getView().getRecord(selectedNode.childNodes[indx]);
        		store.remove(recordCh);
        	}
        }
        
        me.getView().getRecord(selectedNode).remove(); 
        store.sync();
        me.getView().refresh();
    },
    appendChildNode: function(model){
    	var me = this;
    	var selModel = me.getSelectionModel();
        var selectedNode = selModel.getLastSelected();
        
        selectedNode.appendChild(model);
        me.getView().refresh();
        selectedNode.expand();
    },
    getContextMenu: function(cmenuvalue){
    	var me = this;
    	var contextMenu = null;
    	
    	if (typeof cmenuvalue.MODULE == 'undefined') return contextMenu;
    	
    	if (cmenuvalue.MODULE == 'G'){
    		contextMenu = me.getRegItems()['ContextMenu'];
    	}
    	
    	if (cmenuvalue.MODULE == 'M'){
    		contextMenu = me.getRegItems()['MailContextMenu'];
    	}
    	return contextMenu;
    },
    getContextMenuValue: function(cmenuvalue){
    	var me = this;
    	var contextMenuValue = null;
    	
    	if (typeof cmenuvalue == 'string'){
			if (cmenuvalue.length == 0) 
				return contextMenuValue;
			else			
				contextMenuValue = eval('(' + cmenuvalue + ')');
		}
		
    	return contextMenuValue;
    },
    removeAllMail: function(mailBoxName, prgID, gridID){
    	if(!mailBoxName) return;
    	if(!prgID) return;
    	
    	if (typeof groupwareMenuService == 'undefined') return;
    	if (typeof groupwareMenuService.removeAllMail == 'undefined') return;
    	var param = {'BoxName': mailBoxName};
    	groupwareMenuService.removeAllMail(param, function(provider, response) {
    		Ext.Msg.alert('확인', '삭제 되었습니다.');
    		
    		if (!gridID) return;
    		
    		if (typeof Ext.getCmp('CTAB_' + prgID) == 'undefined') return;
        	var nboxContainer = Ext.getCmp('CTAB_' + prgID);
        	
        	if (typeof nboxContainer.iframeEl == 'undefined') return;
        	var nboxIframe = nboxContainer.iframeEl;
        	
        	if (typeof nboxIframe.dom == 'undefined') return;
        	var nboxDom = nboxIframe.dom;
        	
        	if (typeof nboxDom.contentWindow == 'undefined') return;
        	var nboxContentWindow = nboxDom.contentWindow;
        	
        	if (typeof nboxContentWindow.Ext == 'undefined') return;
        	var nboxExt = nboxContentWindow.Ext;
        	
        	if (typeof nboxExt.getCmp(gridID) == 'undefined') return;
        	var tempGrid = nboxExt.getCmp(gridID);
        	tempGrid.queryData();
		});  
    }
});

Ext.define('nbox.main.groupwareMenuPanel', {
	extend: 'Ext.panel.Panel', 
	itemId: 'leftGroupWareMenu',
	hidden: true,
	
	layout: {
        type: 'accordion',
        titleCollapse: true,
        animate: false
    },
    initComponent: function () {
		var me = this;
		
		groupwareMenuPanelStore.proxy.setExtraParam('MODULEID', MODULE_GROUPWARE.ID);
		groupwareMenuPanelStore.load({callback: function(record, options, success){
			if (success){
		    	var rec = record;
		    	groupwareMenuPanelStore.each(function(rec){
		    		var groupwareMenuTreeStore = null;
		    		
					groupwareMenuTreeStore = Ext.create('nbox.main.groupwareMenuTreeStore',{
						storeId: 'nboxStore' + rec.get('PGM_ID')
					});
		    		
		    		groupwareMenuTreeStore.proxy.setExtraParam('MODULEID', MODULE_GROUPWARE.ID);
		    		groupwareMenuTreeStore.proxy.setExtraParam('GROUPID', rec.get('PGM_ID'));
		    		groupwareMenuTreeStore.proxy.setExtraParam('PGM_ID', rec.get('PGM_ID'));
		    		
		    		groupwareMenuTreeStore.load({callback: function(record, options, success){
		    			if (success){
		    				/*me.setLeafByMenuType(record);*/
		    			}
		    		}});
		    		
		    		var groupwareMenuTreePanel = Ext.create("nbox.main.groupwareMenuTreePanel",{
		    			id: 'nboxTree' + rec.get('PGM_ID'),
			        	store: groupwareMenuTreeStore  	
			        });
		    		
		    		var title = '<img src="' + NBOX_IMAGE_PATH + 'menu/' + rec.get('PGM_ID') + '.gif" width=20 height=20/>&nbsp;<label>' + rec.get('PGM_NAME') + '</label>'
		    		
		    		me.add({
	                    title: title,
	                    id: rec.get('PGM_ID'),
	                    layout:'fit',
	                    border: false,
	                    items: [groupwareMenuTreePanel]
	                });
				});
			}
	    }});
		
		me.callParent();
	},
	setLeafByMenuType: function(record){
		var me = this;
		
		for(var indx = 0; indx < record.length; indx++){
			if (record[indx].childNodes.length > 0)
				me.setLeafByMenuType(record[indx].childNodes);
			
			if (record[indx].get('type') == '9')
				record[indx].set('leaf', false);
		}
	}
});

/**************************************************
 * Create
 **************************************************/
var groupwareMenuPanelStore = Ext.create('nbox.main.groupwareMenuPanelStore', {});
var groupwareMenuPropertyStore = Ext.create('nbox.main.groupwareMenuPropertyStore', {});
var groupwareGrid01Store = Ext.create('nbox.main.groupwareMenuUserStore', {});
var groupwareGrid02Store = Ext.create('nbox.main.groupwareMenuUserStore', {});


/**************************************************
 * User Define Function
 **************************************************/
function openPropertyWin(obj, record, actionType){
	var winTitle = '';
	
	switch (actionType)
	{
		case NBOX_C_MENU_NEW:
			winTitle = NBOX_C_NEWMENU_TITLE;
			break;
		
		default:
			winTitle = record.data.text;
			break;
	}
	
	if(!propertyWin){
		propertyWin = Ext.create('nbox.main.groupwareMenuPropertyWindow', {
			title: winTitle + ' 속성'
		}); 
	}
	
	propertyWin.getRegItems()['OpenContainer'] = obj;
	propertyWin.getRegItems()['TargetReocrd'] = record;
	propertyWin.getRegItems()['ActionType'] = actionType;
	propertyWin.show();
}

function openMenuUserWin(obj, record, actionType){
	
	if(!menuUserWin){
		menuUserWin = Ext.create('nbox.main.groupwareMenuUserWindow', {
			title: '사용자' + ' - 속성',
			x: propertyWin.getX() + 30, 
			y: propertyWin.getY() - 30 
		}); 
	}
	
	menuUserWin.getRegItems()['OpenContainer'] = obj;
	menuUserWin.getRegItems()['TargetReocrd'] = record;
	menuUserWin.getRegItems()['ActionType'] = actionType;
 	/*propertyWin.getRegItems()['SEQ'] = SEQ;*/		
 	menuUserWin.show();
}
