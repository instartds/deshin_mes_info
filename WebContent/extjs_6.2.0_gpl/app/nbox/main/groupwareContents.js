/**************************************************
 * Common variable
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
			height: 215
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
			flex: 1,
			minHeight: 185
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
			/*flex: 1,*/
			height: 185,
			minHeight: 185
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
	id: 'groupwareContentsPanel',
	config: {
		regItems: {}
	}, 	
	
	border: false,
	autoScroll: true,
	
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
			flex: 1,
			minWidth: 300
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
			
			var updateClock = function(){
				me.queryData();
			}
			
			Ext.TaskManager.start({
			    run: updateClock,
			    interval: 300000
			});
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
/*
function panelRefresh(type){
	var panel = null;
	switch(type){
		case 1:  공지사항 
			panel = Ext.getCmp('groupwareContentsNotice');
			break;
		case 2:  게시판 
			panel = Ext.getCmp('groupwareContentsBoard');
			break;
		case 3:  전자결재 
			panel = Ext.getCmp('groupwareContentsDoc');
			break;
		case 4:  나의정보 
			panel = Ext.getCmp('groupwareContentsMyInfo');
			break;	
		case 5:  나의업무 
			panel = Ext.getCmp('groupwareContentsMyJob');
			break;
		case 6:  나의근태 
			panel = Ext.getCmp('groupwareContentsMyWork');
			break;
		case 7:  달력 
			panel = Ext.getCmp('groupwareContentsCalendar');
			break;
		case 8:  일정 
			panel = Ext.getCmp('groupwareContentsSchedule');
			break;
		default:
			break;
	}
	
	if(panel != null)
		panel.queryData();
}
*/
