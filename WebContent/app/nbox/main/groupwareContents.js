/**************************************************
 * Common variable
 **************************************************/
var imagePath = '../resources/images/nbox/';

/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.main.groupwareContentsMyInfoModel', {
    extend: 'Ext.data.Model',
    fields: [
    	 {name: 'USER_ID'}
    	,{name: 'USER_NAME'}
    	,{name: 'id'}
		,{name: 'compcode'}
      	,{name: 'prgID'}
		,{name: 'text'}
		,{name: 'text_en'}
		,{name: 'text_cn'}
		,{name: 'text_jp'}
		,{name: 'url'}
		,{name: 'qtip', convert: function(value, record) {return record.get('text'+CUR_LANG_SUFFIX);}}
		,{name: 'box'}
    ]
});

Ext.define('nbox.main.groupwareContentsMyJobModel', {
    extend: 'Ext.data.Model',
    fields: [
		 {name: 'cnt'}
		,{name: 'prgName'}
		,{name: 'imgName'}
		,{name: 'compcode'}
      	,{name: 'prgID'}
		,{name: 'text'}
		,{name: 'text_en'}
		,{name: 'text_cn'}
		,{name: 'text_jp'}
		,{name: 'url'}
		,{name: 'qtip', convert: function(value, record) {return record.get('text'+CUR_LANG_SUFFIX);}}
		,{name: 'box'}
    ]
});

Ext.define('nbox.main.groupwareContentsBoardModel', {
    extend: 'Ext.data.Model',
    fields: [
    	 {name: 'title'} 
    	,{name: 'subject'}
    	,{name: 'loaddate'}
    	,{name: 'noticeid'}
    	,{name: 'username'}
    	,{name: 'compcode'}
      	,{name: 'prgID'}
		,{name: 'text'}
		,{name: 'text_en'}
		,{name: 'text_cn'}
		,{name: 'text_jp'}
		,{name: 'url'}
		,{name: 'qtip', convert: function(value, record) {return record.get('text'+CUR_LANG_SUFFIX);}}
		,{name: 'box'}
    ]
});

Ext.define('nbox.main.groupwareContentsDocModel', {
    extend: 'Ext.data.Model',
    fields: [
    	 {name: 'DocumentID'} 
    	,{name: 'Subject'}
    	,{name: 'DraftUserName'}
    	,{name: 'compcode'}
      	,{name: 'prgID'}
		,{name: 'text'}
		,{name: 'text_en'}
		,{name: 'text_cn'}
		,{name: 'text_jp'}
		,{name: 'url'}
		,{name: 'qtip', convert: function(value, record) {return record.get('text'+CUR_LANG_SUFFIX);}}
		,{name: 'box'}
    ]
});

Ext.define('nbox.main.groupwareContentsWorkModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'WorkInTime'}, 
		{name: 'WorkOutTime'},
		{name: 'TotalHolidayCnt'},		
		{name: 'UseHolidayCnt'},		
		{name: 'MinusHolidayCnt'}
    ]
});

Ext.define('nbox.main.groupwareContentsScheduleModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'calendarId'}, 
		{name: 'title'},
		{name: 'notes'},
		{name: 'allDay'},
		{name: 'startDate'},
		{name: 'endDate'},
		{name: 'startTime'},
		{name: 'endTime'},
		{name: 'eventInformation'},
		{name: 'openFlag'}
    ]
});

Ext.define('nbox.main.groupwareContentsCalendarModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'nType'},
		{name: 'nRow'}, 
		{name: 'nCol'},
		{name: 'nMonth'},
		{name: 'nDay'},
		{name: 'nDate'},
		{name: 'nToday'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.main.groupwareContentsMyInfoStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsMyInfoModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareContentsService.selectMyInfo' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsMyJobStore1', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsMyJobModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareContentsService.selectMyJob1' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsMyJobStore2', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsMyJobModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareContentsService.selectMyJob2' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsNoticeStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsBoardModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				extraParams: {PARENT_PGM_ID: '1000'},
		        api   : {
		        			read: 'groupwareContentsService.selectBoard' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsBoardStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsBoardModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				extraParams: {PARENT_PGM_ID: '2000'},
		        api   : {
		        			read: 'groupwareContentsService.selectBoard' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsDocAStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsDocModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				extraParams: {BOX: 'XA003',MENUTYPE: 'D0001'},
		        api   : {
		        			read: 'groupwareContentsService.selectDoc' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsDocBStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsDocModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				extraParams: {BOX: 'XA007',MENUTYPE: 'D0002'},
		        api   : {
		        			read: 'groupwareContentsService.selectDoc' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsDocCStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsDocModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				extraParams: {BOX: 'XA006',MENUTYPE: 'D0003'},
		        api   : {
		        			read: 'groupwareContentsService.selectDoc' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsWorkStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsWorkModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareContentsService.selectWork' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsCalendarStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsCalendarModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareContentsService.selectCalendar' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsScheduleStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsScheduleModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareContentsService.selectSchedule' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

var groupwareContentsMyInfoStore = Ext.create('nbox.main.groupwareContentsMyInfoStore', {});
var groupwareContentsMyJobStore1 = Ext.create('nbox.main.groupwareContentsMyJobStore1', {});
var groupwareContentsMyJobStore2 = Ext.create('nbox.main.groupwareContentsMyJobStore2', {});
var groupwareContentsNoticeStore = Ext.create('nbox.main.groupwareContentsNoticeStore', {});
var groupwareContentsBoardStore = Ext.create('nbox.main.groupwareContentsBoardStore', {});
var groupwareContentsDocAStore = Ext.create('nbox.main.groupwareContentsDocAStore', {});
var groupwareContentsDocBStore = Ext.create('nbox.main.groupwareContentsDocBStore', {});
var groupwareContentsDocCStore = Ext.create('nbox.main.groupwareContentsDocCStore', {});
var groupwareContentsWorkStore = Ext.create('nbox.main.groupwareContentsWorkStore', {});
var groupwareContentsCalendarStore = Ext.create('nbox.main.groupwareContentsCalendarStore', {});
var groupwareContentsScheduleStore = Ext.create('nbox.main.groupwareContentsScheduleStore', {});

/**************************************************
 * Define
 **************************************************/
/* INFORMATION VIEW */
Ext.define('nbox.main.groupwareContentsMyInfoView', {
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '15 0 0 15',
	
	layout:{
		type: 'fit'
	},
	
	loadMask:false,
	
	itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    
    store: groupwareContentsMyInfoStore,
	
	initComponent: function(){
		var me = this;

		me.tpl = new Ext.XTemplate(
			'<div>',
		        '<tpl for=".">', 
		            '<span class="nbox-feed-sel-item">',
			            '&nbsp;<label>{USER_NAME}</label>',
		            '</span>',
		        '</tpl>',
	        '</div>'
		); 	
		
		me.callParent(); 
	},
	listeners: {
        itemclick: function(view, record, item, index, e, eOpts) {
    		var url = record.data.url ; 
	  		var params = {
	  			 'prgID' : record.data.prgID
	  			,'prgName' : record.get('text'+CUR_LANG_SUFFIX)
	  			,'box' : record.data.box
			};
	  		
	  		if (typeof url !== "undefined" )
		  		openTab(record, url, params);
		  	        	 
    	}
    },
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load();
	}
});

/* INFORMATION PANEL */
Ext.define('nbox.main.groupwareContentsMyInfo', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: true,
	padding: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '나의정보',
	
	initComponent: function(){
		var me = this;
		var groupwareContentsMyInfoView = Ext.create('nbox.main.groupwareContentsMyInfoView', {});
		
		me.getRegItems()['GroupwareContentsMyInfoView'] = groupwareContentsMyInfoView;
		groupwareContentsMyInfoView.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsMyInfoView];
		
		me.callParent(); 
	},
	queryData: function(){
		var me = this;
		var groupwareContentsMyInfoView = me.getRegItems()['GroupwareContentsMyInfoView']
		
		groupwareContentsMyInfoView.queryData();
	}
});

/* JOB VIEW */
Ext.define('nbox.main.groupwareContentsMyJobView1', {
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '0 0 0 0',
	
	loadMask:false,
	
	itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    
    store: groupwareContentsMyJobStore1,
	
	initComponent: function(){
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<div>',
				'<table style="border-bottom:1px solid #C0C0C0;" width="100%">',
					'<tr heigt="40px">',
		    			'<td>&nbsp;</td>',
		    		'</tr>',
			        '<tpl for=".">', 
	            		//'<tr><td><td></tr>',
						'<tr>',
							'<td width="15px"></td>',
							'<td width="100px">',
								'<span class="nbox-feed-sel-item">',
									'<table>',
										'<tr>',
											'<td width="10px"><img src = "' + CPATH + '/resources/images/nbox/{imgName}" width=15 height=15 /></td>',
											'<td width="150px">&nbsp;{prgName}</td>',
											'<td width="40px">&nbsp;{cnt}</td>',
										'</tr>',
									'</table>',
								'</span>',
							'</td>',
						'</tr>',
						'<tr><td><td></tr>',
			        '</tpl>',
			        '<tr heigt="40px">',
		    			'<td>&nbsp;</td>',
		    		'</tr>',
		        '</table>',
	        '</div>'
		); 			
		me.callParent(); 
	},
	listeners: {
        itemclick: function(view, record, item, index, e, eOpts) {
        	if(record.data.prgID == '3000002')
        		Ext.Msg.alert('확인', '준비중인 메뉴입니다.');
        	else{
	    		var url = record.data.url ; 
	    		var params = {
	   	  			 'prgID' : record.data.prgID
	   	  			,'prgName' : record.get('text'+CUR_LANG_SUFFIX)
	   	  			,'box' : record.data.box
	   			};
		  		
		  		if (typeof url !== "undefined" )
			  		openTab(record, url, params);
        	}
    	}
    },
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load();
	}
});

Ext.define('nbox.main.groupwareContentsMyJobView2', {
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '0 0 0 0',
	
	loadMask:false,
	
	itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    
    store: groupwareContentsMyJobStore2,
	
	initComponent: function(){
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<div>',
				'<table style="border-bottom:1px solid #C0C0C0;" width="100%">',
					'<tr heigt="40px">',
		    			'<td>&nbsp;</td>',
		    		'</tr>',
			        '<tpl for=".">', 
						'<tr>',
							'<td width="15px"></td>',
							'<td width="100px">',
								'<span class="nbox-feed-sel-item">',
									'<table>',
										'<tr>',
											'<td width="10px"><img src = "' + CPATH + '/resources/images/nbox/{imgName}" width=15 height=15 /></td>',
											'<td width="150px">&nbsp;{prgName}</td>',
											'<td width="40px">&nbsp;{cnt}</td>',
										'</tr>',
									'</table>',
								'</span>',
							'</td>',
						'</tr>',
						'<tr><td><td></tr>',
			        '</tpl>',
			        '<tr heigt="40px">',
		    			'<td>&nbsp;</td>',
		    		'</tr>',
		        '</table>',
	        '</div>'
		); 			
		me.callParent(); 
	},
	listeners: {
        itemclick: function(view, record, item, index, e, eOpts) {
    		var url = record.data.url ; 
    		var params = {
   	  			 'prgID' : record.data.prgID
   	  			,'prgName' : record.get('text'+CUR_LANG_SUFFIX)
   	  			,'box' : record.data.box
   			};
	  		
	  		if (typeof url !== "undefined" )
		  		openTab(record, url, params);
		  	        	 
    	}
    },
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load();
	}
});

/* JPB PANEL */
Ext.define('nbox.main.groupwareContentsMyJob', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: true,
	padding: '5 0 0 0',
	
	layout:{
		type: 'vbox',
		align: 'stretch'
	},
	
	title: '나의업무',
	
	initComponent: function(){
		var me = this;
		var groupwareContentsMyJobView1 = Ext.create('nbox.main.groupwareContentsMyJobView1', {});
		var groupwareContentsMyJobView2 = Ext.create('nbox.main.groupwareContentsMyJobView2', {});
		
		me.getRegItems()['GroupwareContentsMyJobView1'] = groupwareContentsMyJobView1;
		groupwareContentsMyJobView1.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsMyJobView2'] = groupwareContentsMyJobView2;
		groupwareContentsMyJobView2.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsMyJobView1, groupwareContentsMyJobView2];
		
		me.callParent(); 
	},
	queryData: function(){
		var me = this;
		var groupwareContentsMyJobView1 = me.getRegItems()['GroupwareContentsMyJobView1'];
		var groupwareContentsMyJobView2 = me.getRegItems()['GroupwareContentsMyJobView2'];
		
		groupwareContentsMyJobView1.queryData();
		groupwareContentsMyJobView2.queryData();
	}
});

/* NOTICE GRID */
Ext.define('nbox.main.groupwreContentsNoticeGrid', {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	hideHeaders: true,
	loadMask:false,
	
	store: groupwareContentsNoticeStore,
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
			{ text: 'title',  dataIndex: 'title'},
	        { 
	        	text: 'subject', 
	        	dataIndex: 'subject', 
	        	flex: 1,
	        	renderer : function(value) {
	            	if (value.substring(0,1) == '0') 
                        return '<b>' + value.substring(1) + '</b>';
                    else
                        return value.substring(1) ;
            	}
	        },
	        { text: 'username',  dataIndex: 'username', width: 100},
	        { xtype: 'datecolumn', text: 'loaddate', dataIndex: 'loaddate', format: 'Y-m-d'}
		];		
		
		me.callParent(); 
	},
	listeners : {
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
           	if(record) {
           		me.openDetailWin("R", record.data.noticeid);
        	}
    		/*var me = this;
    		
    		var url = record.data.url ; 
    		var params = {
   	  			 'prgID' : record.data.prgID
   	  			,'prgName' : record.get('text'+CUR_LANG_SUFFIX)
   	  			,'box' : record.data.box
   	  			,'NoticeID': record.data.noticeid
   			};
	  		
	  		if (typeof url !== "undefined" )
		  		openTab(record, url, params);*/
        }
    },
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load();
	},
    openDetailWin: function(actionType, noticeID){
    	var me = this;
    	
    	openDetailWinBBS(me, actionType, noticeID);
    }	
});

/* BOARD GRID */
Ext.define('nbox.main.groupwreContentsBoardGrid', {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	hideHeaders: true,
	loadMask:false,
	
	store: groupwareContentsBoardStore,
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
			{ text: 'title',  dataIndex: 'title'},
	        { 
	        	text: 'subject', 
	        	dataIndex: 'subject', 
	        	flex: 1,
	        	renderer : function(value) {
	            	if (value.substring(0,1) == '0') 
                        return '<b>' + value.substring(1) + '</b>';
                    else
                        return value.substring(1) ;
            	}
	        },
	        { text: 'username',  dataIndex: 'username', width: 100},
	        { xtype: 'datecolumn', text: 'loaddate', dataIndex: 'loaddate', format: 'Y-m-d'}
		];		
		
		me.callParent(); 
	},
	listeners : {
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
           	if(record) {
           		me.openDetailWin("R", record.data.noticeid);
        	}
    		/*var me = this;
    		
    		var url = record.data.url ; 
	  		var params = {
	  				'prgID' : record.data.prgID, 'prgName' : record.get('text'+CUR_LANG_SUFFIX), 'box' : record.data.box
			};
	  		
	  		if (typeof url !== "undefined" )
		  		openTab(record, url, params);*/
        }
    },
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load();
	},
	openDetailWin: function(actionType, noticeID){
    	var me = this;
    	
    	openDetailWinBBS(me, actionType, noticeID);
    }	
});

/* DOCA GRID */
Ext.define('nbox.main.groupwreContentsDocAGrid', {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	hideHeaders: true,
	loadMask:false,
	
	store: groupwareContentsDocAStore,
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
	        { 
	        	text: 'Subject', 
	        	dataIndex: 'Subject', 
	        	flex: 1,
	        	renderer : function(value) {
	            	if (value.substring(0,1) == '0') 
                        return '<b>' + value.substring(1) + '</b>';
                    else
                        return value.substring(1) ;
            	}
	        },
	        { text: 'DraftUserName', dataIndex: 'DraftUserName'}
		];		
		
		me.callParent(); 
	},
	listeners : {
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
           	if(record) {
           		me.openDetailWin("R", record.data.DocumentID);
        	}
    		/*var me = this;
    		
    		var url = record.data.url ; 
	  		var params = {
	  				'prgID' : record.data.prgID, 'prgName' : record.get('text'+CUR_LANG_SUFFIX), 'box' : record.data.box
			};
	  		
	  		if (typeof url !== "undefined" )
		  		openTab(record, url, params);*/
        }
    },	
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load();
	},
	openDetailWin: function(actionType, documentID){
    	var me = this;
    	
    	openApprovalDetailWin(me, 'XA003', actionType, documentID);
    }	
});

/* DOCB GRID */
Ext.define('nbox.main.groupwreContentsDocBGrid', {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	hideHeaders: true,
	loadMask:false,
	
	store: groupwareContentsDocBStore,
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
	        { 
	        	text: 'Subject', 
	        	dataIndex: 'Subject', 
	        	flex: 1,
	        	renderer : function(value) {
	            	if (value.substring(0,1) == '0') 
                        return '<b>' + value.substring(1) + '</b>';
                    else
                        return value.substring(1) ;
            	}
	        },
	        { text: 'DraftUserName', dataIndex: 'DraftUserName'}
		];		
		
		me.callParent(); 
	},
	listeners : {
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
           	if(record) {
           		me.openDetailWin("R", record.data.DocumentID);
        	}
           	/*
    		var me = this;
    		
    		var url = record.data.url ; 
	  		var params = {
	  				'prgID' : record.data.prgID, 'prgName' : record.get('text'+CUR_LANG_SUFFIX), 'box' : record.data.box
			};
	  		
	  		if (typeof url !== "undefined" )
		  		openTab(record, url, params);*/
        }
    },	
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load();
	},
	openDetailWin: function(actionType, documentID){
    	var me = this;
    	
    	openApprovalDetailWin(me, 'XA007', actionType, documentID);
    }	
});

/* DOCC GRID */
Ext.define('nbox.main.groupwreContentsDocCGrid', {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	hideHeaders: true,
	loadMask:false,
	
	store: groupwareContentsDocCStore,
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
	        { 
	        	text: 'Subject', 
	        	dataIndex: 'Subject', 
	        	flex: 1,
	        	renderer : function(value) {
	            	if (value.substring(0,1) == '0') 
                        return '<b>' + value.substring(1) + '</b>';
                    else
                        return value.substring(1) ;
            	}
	        },
	        { text: 'DraftUserName', dataIndex: 'DraftUserName'}
		];		
		
		me.callParent(); 
	},
	listeners : {
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
           	if(record) {
           		me.openDetailWin("R", record.data.DocumentID);
        	}
    		/*var me = this;
    		
    		var url = record.data.url ; 
	  		var params = {
	  				'prgID' : record.data.prgID, 'prgName' : record.get('text'+CUR_LANG_SUFFIX), 'box' : record.data.box
			};
	  		
	  		if (typeof url !== "undefined" )
		  		openTab(record, url, params);*/
        }
    },	
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load();
	},
	openDetailWin: function(actionType, documentID){
    	var me = this;
    	
    	openApprovalDetailWin(me, 'XA006', actionType, documentID);
    }
});

/* NOTICE PANEL */
Ext.define('nbox.main.groupwareContentsNotice', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '공지사항',
	
	initComponent: function () {
		var me = this;
		
		var groupwreContentsNoticeGrid = Ext.create('nbox.main.groupwreContentsNoticeGrid', {});
		
		me.getRegItems()['GroupwreContentsNoticeGrid'] = groupwreContentsNoticeGrid;
		groupwreContentsNoticeGrid.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwreContentsNoticeGrid];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var groupwreContentsNoticeGrid = me.getRegItems()['GroupwreContentsNoticeGrid'];
		
		groupwreContentsNoticeGrid.queryData();
	}

});

/* BOARD PANEL */
Ext.define('nbox.main.groupwareContentsBoard', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '5 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '게시판',
	
	initComponent: function () {
		var me = this;
		
		var groupwreContentsBoardGrid = Ext.create('nbox.main.groupwreContentsBoardGrid', {});
		
		me.getRegItems()['GroupwreContentsBoardGrid'] = groupwreContentsBoardGrid;
		groupwreContentsBoardGrid.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwreContentsBoardGrid];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var groupwreContentsBoardGrid = me.getRegItems()['GroupwreContentsBoardGrid'];
		
		groupwreContentsBoardGrid.queryData();
	}
});

/* NOSIGN PANEL */
Ext.define('nbox.main.groupwareContentsDocA', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '미결',
	
	initComponent: function () {
		var me = this;
		
		var groupwreContentsDocAGrid = Ext.create('nbox.main.groupwreContentsDocAGrid', {});
		
		me.getRegItems()['GroupwreContentsDocAGrid'] = groupwreContentsDocAGrid;
		groupwreContentsDocAGrid.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwreContentsDocAGrid];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var groupwreContentsDocAGrid = me.getRegItems()['GroupwreContentsDocAGrid'];
		
		groupwreContentsDocAGrid.queryData();
	}
});

/* RCV PANEL */
Ext.define('nbox.main.groupwareContentsDocB', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '수신',
	
	initComponent: function () {
		var me = this;
		
		var groupwreContentsDocBGrid = Ext.create('nbox.main.groupwreContentsDocBGrid', {});
		
		me.getRegItems()['GroupwreContentsDocBGrid'] = groupwreContentsDocBGrid;
		groupwreContentsDocBGrid.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwreContentsDocBGrid];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var groupwreContentsDocBGrid = me.getRegItems()['GroupwreContentsDocBGrid'];
		
		groupwreContentsDocBGrid.queryData();
	}
});

/* REF PANEL */
Ext.define('nbox.main.groupwareContentsDocC', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '참조',
	
	initComponent: function () {
		var me = this;
		
		var groupwreContentsDocCGrid = Ext.create('nbox.main.groupwreContentsDocCGrid', {});
		
		me.getRegItems()['GroupwreContentsDocCGrid'] = groupwreContentsDocCGrid;
		groupwreContentsDocCGrid.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwreContentsDocCGrid];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var groupwreContentsDocCGrid = me.getRegItems()['GroupwreContentsDocCGrid'];
		
		groupwreContentsDocCGrid.queryData();
	}
});

/* DOC TAB PANEL */
Ext.define('nbox.main.groupwareContentsDoc', {
	extend: 'Ext.tab.Panel',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '5 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	initComponent: function () {
		var me = this;
		
		var groupwareContentsDocA = Ext.create('nbox.main.groupwareContentsDocA', {});
		var groupwareContentsDocB = Ext.create('nbox.main.groupwareContentsDocB', {});
		var groupwareContentsDocC = Ext.create('nbox.main.groupwareContentsDocC', {});
		
		me.getRegItems()['GroupwareContentsDocA'] = groupwareContentsDocA;
		groupwareContentsDocA.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsDocB'] = groupwareContentsDocB;
		groupwareContentsDocB.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsDocC'] = groupwareContentsDocC;
		groupwareContentsDocC.getRegItems()['ParentContainer'] = me;
	
		me.items = [groupwareContentsDocA,groupwareContentsDocB,groupwareContentsDocC];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
		var groupwareContentsDocA = me.getRegItems()['GroupwareContentsDocA'];
		var groupwareContentsDocB = me.getRegItems()['GroupwareContentsDocB'];
		var groupwareContentsDocC = me.getRegItems()['GroupwareContentsDocC'];
		
		groupwareContentsDocA.queryData();
		groupwareContentsDocB.queryData();
		groupwareContentsDocC.queryData();	
	}
});

/* WORK INOUT PANEL */
Ext.define('nbox.main.groupwareContentsMyWorkInOut', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	padding: '15px 5px 0px 15px',
	layout: {
		type: 'vbox',
		align: 'stretch'
	},
	style: {
		'border-bottom': '1px solid #C0C0C0'
	},
	
	initComponent: function(){
		var me = this;
		
		var btnWorkIn = {
			xtype: 'button',
			text: '출근체크',
		 	tooltip : '출근체크',
            handler: function() { 
            	me.WorkInButtonDown();
            }
		};
		
		var btnWorkOut = {
			xtype: 'button',
			text: '퇴근체크',
		 	tooltip : '퇴근체크',
            handler: function() { 
            	me.WorkOutButtonDown();
            }
		};
		
		me.items = [
			{
				xtype: 'panel',
				border: false,
				layout: {
					type: 'hbox',
					align: 'stretch'
				},
				margin: '0 0 0 0',
				
				items: [
					btnWorkIn,
				    {
				        xtype: 'displayfield',
				        id: 'WorkInTime',
				        name: 'WorkInTime',
				        value: '00:00',
				        margin: '0 50 0 10'
				    },
				    btnWorkOut,
				    {
				        xtype: 'displayfield',
				        id: 'WorkOutTime',
				        name: 'WorkOutTime',
				        value: '00:00',
				        margin: '0 10 0 10'
				    } 
				]
			}
		];	
		
		me.callParent();
	},
	WorkInButtonDown: function(){
		var me = this;
		
		me.workinData();
	},
	WorkOutButtonDown: function(){
		var me = this;
		
		me.workoutData();		
	},
	workinData: function(){
		var me = this;
    	var param = {'InOutType': 'W0001'};
    	
    	groupwareContentsService.updateWorkInOut(param, 
    		function(provider, response) {
    			var workInTime = Ext.get('WorkInTime');
    			
    			workInTime.setHTML(response.result.result.WorkInTime); 
    			
		});
	},
	workoutData: function(){
		var me = this;
    	var param = {'InOutType': 'W0002'};
    	
    	groupwareContentsService.updateWorkInOut(param, 
    		function(provider, response) {
    			var workOutTime = Ext.get('WorkOutTime');

				workOutTime.setHTML(response.result.result.WorkOutTime);
    			
		});
	}
});

/* WORK HOLIDAY PANEL */
Ext.define('nbox.main.groupwareContentsMyWorkHoliday', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	
	border: false,
	padding: '10px 30px 5px 30px',
	flex: 1,
	layout: {
		type: 'vbox',
		align: 'stretch'
	},
	
	initComponent: function(){
		var me = this;
		
		me.items = [
			{
			    xtype: 'displayfield',
			    name: 'TotalHolidayCnt',
			    fieldLabel: '<img src = "' + CPATH + '/resources/images/nbox/btn_s_open.gif" width=15 height=15 />&nbsp;'+'총&nbsp;연&nbsp;차',
			    fieldStyle: 'text-align:right;'
			},
			{
		        xtype: 'displayfield',
		        name: 'UseHolidayCnt',
		        fieldLabel: '<img src = "' + CPATH + '/resources/images/nbox/btn_s_close.gif" width=15 height=15 />&nbsp;'+'사용연차',
		        fieldStyle: 'text-align:right;'
		    },
		    {
		        xtype: 'displayfield',
		        name: 'MinusHolidayCnt',
		        fieldLabel: '<img src = "' + CPATH + '/resources/images/nbox/btn_s_equal.gif" width=15 height=15 />&nbsp;'+'잔여연차',
		        fieldStyle: 'text-align:right;'
		    }		            
		];
		
		me.callParent();
	}
});

/* WORK PANEL */
Ext.define('nbox.main.groupwareContentsMyWork', {
	extend: 'Ext.form.Panel',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '0 0 0 0',
	
	layout: {
		type: 'vbox',
		align: 'stretch'
	},
	
	title: '나의근태',
	
	initComponent: function(){
		var me = this;
		
		var groupwareContentsMyWorkInOut = Ext.create('nbox.main.groupwareContentsMyWorkInOut', {
			height: 55
		}); 
		
		var groupwareContentsMyWorkHoliday = Ext.create('nbox.main.groupwareContentsMyWorkHoliday', {
			flex: 1
		});
		
		me.getRegItems()['GroupwareContentsMyWorkInOut'] = groupwareContentsMyWorkInOut;
		groupwareContentsMyWorkInOut.getRegItems()['ParentContainer'] = me;
		me.getRegItems()['StoreData'] = groupwareContentsWorkStore;
		
		me.getRegItems()['GroupwareContentsMyWorkHoliday'] = groupwareContentsMyWorkHoliday;
		groupwareContentsMyWorkHoliday.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsMyWorkInOut,groupwareContentsMyWorkHoliday];	 		
		me.callParent(); 
	},
	queryData: function(){
		var me = this;
		var store = me.getRegItems()['StoreData'];
		
		me.clearData();
		
		store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.loadData();
   				}
   			}
		});
	},
	loadData: function(){
		var me = this;
		
		me.loadPanel();
	},
	clearData: function(){
		var me = this;
		
		me.clearPanel();
	},
	loadPanel: function(){
		var me = this;
    	var store = me.getRegItems()['StoreData'];
    	var frm = me.getForm();
    	
    	if (store.getCount() >= 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	var store = me.getRegItems()['StoreData'];
		
    	store.removeAll();
		frm.reset();
	}
});

var lgcurrSelectDiv = null;

Ext.define('nbox.main.groupwareContentsCalendarView',{
	extend: 'Ext.view.View',
	
	config: {
		regItems: {}
	},
	
	border: false,
	margin: '0 0 0 0',
	
	loadMask: false,
	
	itemSelector: '.nbox-calendar-feed-sel-item',
    selectedItemCls: 'nbox-calendar-feed-seled-item', 
    
    store: groupwareContentsCalendarStore,
	
	daysOfWeek: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
	toMonth: '',
	selectedDate: '',
	
	initComponent: function(){
		var me = this;
        me.tpl = new Ext.XTemplate();
        
        me.callParent(); 
	},
	listeners: {
	    itemclick: function(view, record, item, index, e, eOpts) {
			var me = this;
			var headerType = record.data.nType;
			
			switch(headerType){
				case 'H':
					me.toMonth = record.data.nDate.substring(0,6);
					me.queryData();
						
					break;
				case 'D':
					var parentDiv = item.parentElement;
					
					if (!parentDiv) return;
					
					if (lgcurrSelectDiv)
						lgcurrSelectDiv.style.backgroundColor = '';
					
					parentDiv.style.backgroundColor = '#d1e61a';
					lgcurrSelectDiv = parentDiv;
					
					me.selectedDate = record.data.nDate;
					
					groupwareContentsScheduleView = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['GroupwareContentsSchedule'].getRegItems()['GroupwareContentsScheduleView'];
					groupwareContentsScheduleView.queryData();			
					
					break;
				default:
					break;
			}
		}
	},
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		var month = me.toMonth;
		store.proxy.setExtraParam('YYYYMM', month);
		store.load({
			callback: function(records, operation, success) {
   				if (success){
   					me.loadData();
   				}
			}
   		});
	},
	loadData: function(){
		var me = this;
		
		var htmlData = [];
        htmlData.push("<table width='100%' height='100%' cellspacing='0'>");
        htmlData.push("<thead>");
        htmlData.push("<tr height='30px'>");
        htmlData.push('<tpl for=".">');
        htmlData.push('<tpl if="nType==\'H\'":>');
        htmlData.push('<tpl if="nCol==0">');
        htmlData.push('<th><span class="nbox-calendar-feed-sel-item"><<</span></th>');
        htmlData.push('</tpl>');
        htmlData.push('<tpl if="nCol==1">');
        htmlData.push("<th colspan='5'><span class='nbox-calendar-feed-sel-item'>{nMonth}</span></th>");
        htmlData.push('</tpl>');
        htmlData.push('<tpl if="nCol==2">');
        htmlData.push('<th><span class="nbox-calendar-feed-sel-item">>></span></th>');
        htmlData.push('</tpl>');
        htmlData.push('</tpl>');
        htmlData.push('</tpl>');
        htmlData.push('</th></tr>');
        htmlData.push('</thead>');
        htmlData.push('<tbody>');

        htmlData.push("<tr height='20px'>");
        var daysOfWeek = me.daysOfWeek;
        for (var i = 0; i < 7; i++) {
            var width = i == 0 || i == 6 ? 15 : 14;
            var fStyle = '';
            
            if(i==0)
            	fStyle = 'color:red;';
            
            if(i==6)
            	fStyle = 'color:blue;';
            
            htmlData.push('<td align="center" width="' + width + '%"><div style="font-weight:bold;' + fStyle + '" >' + daysOfWeek[i] + '</div></td>');
        }
        htmlData.push('</tr>');

        htmlData.push('<tpl for=".">');
        htmlData.push('<tpl if="nType==\'D\'":>');
        htmlData.push('<tpl if="nCol==0">');
        htmlData.push('<tr>');
        htmlData.push('</tpl>');
        htmlData.push('<td align="center">');
        htmlData.push('<div style="width: 20px;');
        htmlData.push('<tpl if="nCol==0">color: red;</tpl>');
        htmlData.push('<tpl if="nToday==1">text-decoration: underline;</tpl>');
        htmlData.push('<tpl if="nCol==6">color: blue;</tpl>');
        htmlData.push('"><span class="nbox-calendar-feed-sel-item">{nDay}</span></div>');
        htmlData.push('</td>');
        htmlData.push('<tpl if="nCol==6">');
        htmlData.push('</tr>');
        htmlData.push('</tpl>');
        htmlData.push('</tpl>');
        htmlData.push('</tpl>');
        htmlData.push('</tbody>');
        htmlData.push('</table>');
        
        var htmlString = "";
        
        for(var i=0; i<htmlData.length; i++)
        	htmlString += htmlData[i] + ' ';
        
        me.tpl = new Ext.XTemplate(
        	htmlString
    	);
		
		me.refresh();
	}
});


/* CALENDAR PANEL */
Ext.define('nbox.main.groupwareContentsCalendar', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '5 0 0 0',
	
	layout:{
		type: 'fit'
	},

	initComponent: function(){
		var me = this;
		
		var groupwareContentsCalendarView = Ext.create('nbox.main.groupwareContentsCalendarView',{});
		
		me.getRegItems()['GroupwareContentsCalendarView'] = groupwareContentsCalendarView;
		groupwareContentsCalendarView.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsCalendarView];
		me.callParent(); 
	},
	queryData: function(){
		var me = this;
		var groupwareContentsCalendarView = me.getRegItems()['GroupwareContentsCalendarView'];
		groupwareContentsCalendarView.queryData();
	}
});

/* SCHEDULE VIEW */
Ext.define('nbox.main.groupwareContentsScheduleView', {
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '5 0 0 5',
	
	layout:{
		type: 'fit'
	},
	
	loadMask:false,
	
	itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    
    store: groupwareContentsScheduleStore,
	
	initComponent: function(){
		var me = this;

		me.tpl = new Ext.XTemplate(
			'<div>',
				'<table>',
			        '<tpl for=".">',
			        	'<tr>',
			        		'<td>',
			        			'<span class="nbox-feed-sel-item">',
				        			/*'<img src = "' + CPATH + '/resources/css/icons/icon-cal-{ScheduleType}.jpg" width=15 height=15 />',*/
			        				'<img src = "' + CPATH + '/resources/images/nbox/pin.gif" width=15 height=15 />&nbsp;',
					        		'<label>{title}</label>',
					        	'</span>',
			        		'</td>',
			            '</tr>',
			        '</tpl>',
		        '</table>',
	        '</div>'
		); 	
		
		
		
		me.callParent(); 
	},
	listeners: {
        itemclick: function(view, record, item, index, e, eOpts) {
        	var me = this;
           	if(record) {
           		me.openDetailWin(record);
        	}
    		        	 
    	}
    },
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		var groupwareContentsCalendarView = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['GroupwareContentsCalendar'].getRegItems()['GroupwareContentsCalendarView'];
		var selectedDate = groupwareContentsCalendarView.selectedDate;
		
		/*var groupwareContentsSchedule = me.getRegItems()['ParentContainer'];
		
		if(selectedDate == ''){
			var toDay = new Date()
			selectedDate = toDay.toISOString().slice(0,10).replace(/-/g,"") 
		}
		
		groupwareContentsSchedule.setTitle(selectedDate + ' 일정 목록');*/
		
		
		store.proxy.setExtraParam('YYYYMMDD', selectedDate);
		store.load();
	},
	openDetailWin: function(record){
		var me = this;
		
		openScheduleDetailWin(me, record);
	}
});


/* SCHEDULE PANEL */
Ext.define('nbox.main.groupwareContentsSchedule', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '5 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '일정목록',
	
	initComponent: function(){
		var me = this;
		
		var groupwareContentsScheduleView = Ext.create('nbox.main.groupwareContentsScheduleView', {});
		
		me.getRegItems()['GroupwareContentsScheduleView'] = groupwareContentsScheduleView;
		groupwareContentsScheduleView.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsScheduleView]
		
		me.callParent(); 
	},
	queryData: function(){
		var me = this;
		
		var groupwareContentsScheduleView = me.getRegItems()['GroupwareContentsScheduleView'];
	
		groupwareContentsScheduleView.queryData();
	}
});

/* LEFT AREA */
Ext.define('nbox.main.groupwareContentsLeftPanel', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '5 0 5 5',
	
	layout: {
    	type: 'vbox', 
		align: 'stretch'
    },
	
	initComponent: function () {
		var me = this;
		
		var groupwareContentsMyInfo = Ext.create('nbox.main.groupwareContentsMyInfo', {
			height: 70
		});
		var groupwareContentsMyJob = Ext.create('nbox.main.groupwareContentsMyJob', {
			height: 305
		});
		
		me.getRegItems()['GroupwareContentsMyInfo'] = groupwareContentsMyInfo;
		groupwareContentsMyInfo.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsMyJob'] = groupwareContentsMyJob;
		groupwareContentsMyJob.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsMyInfo, groupwareContentsMyJob]
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
		var groupwareContentsMyInfo = me.getRegItems()['GroupwareContentsMyInfo'];
		var groupwareContentsMyJob = me.getRegItems()['GroupwareContentsMyJob'];
		
		groupwareContentsMyInfo.queryData();
		groupwareContentsMyJob.queryData();
	}
});

/* CENTER AREA */
Ext.define('nbox.main.groupwareContentsCenterPanel', {
	extend: 'Ext.panel.Panel', 
	
	config: {
		regItems: {}
	}, 
	
	border: false,
	margin: '5 0 5 5',
	
	layout: {
    	type: 'vbox',
    	align: 'stretch'
    },
	
	initComponent: function () {
		var me = this;
		
		var groupwareContentsNotice = Ext.create('nbox.main.groupwareContentsNotice', {
			height: 185
		});
		
		var groupwareContentsBoard = Ext.create('nbox.main.groupwareContentsBoard', {
			height: 185
		});
		
		var groupwareContentsDoc = Ext.create('nbox.main.groupwareContentsDoc', {
			flex: 1
		});
		
		me.getRegItems()['GroupwareContentsNotice'] = groupwareContentsNotice;
		groupwareContentsNotice.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsBoard'] = groupwareContentsBoard;
		groupwareContentsBoard.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsDoc'] = groupwareContentsDoc;
		groupwareContentsDoc.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsNotice, groupwareContentsBoard, groupwareContentsDoc];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
		var groupwareContentsNotice = me.getRegItems()['GroupwareContentsNotice'];
		var groupwareContentsBoard = me.getRegItems()['GroupwareContentsBoard'];
		var groupwareContentsDoc = me.getRegItems()['GroupwareContentsDoc'];
		
		groupwareContentsNotice.queryData();
		groupwareContentsBoard.queryData();
		groupwareContentsDoc.queryData();
	}
});

/* RIGHT AREA */
Ext.define('nbox.main.groupwareContentsRightPanel', {
	extend: 'Ext.panel.Panel', 
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '5 5 5 5',
	
	layout: {
    	type: 'vbox',
    	align: 'stretch'
    },
	
	initComponent: function () {
		var me = this;
		
		var groupwareContentsMyWork = Ext.create('nbox.main.groupwareContentsMyWork', {
			height: 185
		});
		
		var groupwareContentsCalendar = Ext.create('nbox.main.groupwareContentsCalendar', {
			height: 185
		});
		
		var groupwareContentsSchedule = Ext.create('nbox.main.groupwareContentsSchedule', {
			flex: 1,
		});
		
		me.getRegItems()['GroupwareContentsMyWork'] = groupwareContentsMyWork;
		groupwareContentsMyWork.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsCalendar'] = groupwareContentsCalendar;
		groupwareContentsCalendar.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsSchedule'] = groupwareContentsSchedule;
		groupwareContentsSchedule.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsMyWork, groupwareContentsCalendar, groupwareContentsSchedule];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
		var groupwareContentsMyWork = me.getRegItems()['GroupwareContentsMyWork'];
		var groupwareContentsCalendar = me.getRegItems()['GroupwareContentsCalendar'];
		var groupwareContentsSchedule = me.getRegItems()['GroupwareContentsSchedule'];
		
		groupwareContentsMyWork.queryData();
		groupwareContentsCalendar.queryData();
		groupwareContentsSchedule.queryData();
	}
	
});

Ext.define('nbox.main.groupwareContentsPanel', {
	extend: 'Ext.panel.Panel', 
	config: {
		regItems: {}
	}, 	
	
	border: false,
	
	layout: {
    	type: 'hbox', 
		align: 'stretch'
    },
    initComponent: function () {
		var me = this;
		
		var groupwareContentsLeftPanel = Ext.create('nbox.main.groupwareContentsLeftPanel', {
			width: 300
		});
		
		var groupwareContentsCenterPanel = Ext.create('nbox.main.groupwareContentsCenterPanel', {
			flex: 1
		});
		
		var groupwareContentsRightPanel = Ext.create('nbox.main.groupwareContentsRightPanel', {
			width: 300
		});
		
		me.getRegItems()['GroupwareContentsLeftPanel'] = groupwareContentsLeftPanel;
		groupwareContentsLeftPanel.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsCenterPanel'] = groupwareContentsCenterPanel;
		groupwareContentsCenterPanel.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsRightPanel'] = groupwareContentsRightPanel;
		groupwareContentsRightPanel.getRegItems()['ParentContainer'] = me;
		
		me.items = [
		  groupwareContentsLeftPanel
		 ,groupwareContentsCenterPanel
		 ,groupwareContentsRightPanel]
		
		me.callParent();
	},
	listeners: {
		render: function(obj, eOpts){
			var me = this;
			me.queryData();
		}
	},
	queryData: function(){
		var me = this;
		var groupwareContentsLeftPanel = me.getRegItems()['GroupwareContentsLeftPanel'];
		var groupwareContentsCenterPanel = me.getRegItems()['GroupwareContentsCenterPanel'];
		var groupwareContentsRightPanel = me.getRegItems()['GroupwareContentsRightPanel'];
	
		groupwareContentsLeftPanel.queryData();
		groupwareContentsCenterPanel.queryData();
		groupwareContentsRightPanel.queryData();
		
	}
});




/**************************************************
 * Create
 **************************************************/
var groupwareContentsPanel = Ext.create('nbox.main.groupwareContentsPanel',{});


/**************************************************
 * User Define Function
 **************************************************/

