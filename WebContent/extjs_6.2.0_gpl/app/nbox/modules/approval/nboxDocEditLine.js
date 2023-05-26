/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
//Doc Line List
Ext.define('nbox.docEditLineModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'DocumentID'},
		{name: 'LineType'},
		{name: 'Seq'},
		{name: 'SignType'},
		{name: 'SignTypeName'},
		{name: 'SignUserID'},
		{name: 'SignUserName'},
		{name: 'SignUserDeptName'},
		{name: 'SignUserPosName'} ,
		{name: 'SignDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
		{name: 'SignImgUrl'},
		{name: 'SignFlag'},
		{name: 'LastFlag'},
		{name: 'FormName'},
    	{name: 'DoubleLineFirstFlag'}
    ]	    
});	

/**************************************************
 * Store
 **************************************************/
//DocLine List
Ext.define('nbox.docEditLineStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docEditLineModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocLineService.selects' },
        reader: {
            type: 'json',
            root: 'records'
        }
    },
    copyData: function(store){
    	var me = this;
    	var records = [];
    	var indx = 0;
    	var totCnt = 0;
    	
    	totCnt = store.getCount();
    	
    	store.each(function(r){
    		indx += 1;
    		r = me.exceptionData(r, indx, totCnt);
			records.push(r.copy());
		});
		
		me.add(records);
    },
    exceptionData: function(record, indx, totCnt){
    	var me = this;
    	
    	if(record.data.LineType == 'B')
    		record.data.SignTypeName = '이중결재';
    	
    	if (indx > 1){
    		if (indx == totCnt)
    			record.data.SignTypeName = '결재';
    		else
    			record.data.SignTypeName = '검토';
    	}
    	
    	if(record.data.SignType == 1)
    		record.data.SignTypeName = '협조';
    	
    	return record;
    } 
});	

/**************************************************
 * Define
 **************************************************/
//DocLine List
Ext.define('nbox.docEditLineView',{
	extend: 'Ext.view.View',
	config: {
		store: null,
		regItems: {}
	},
	loadMask:false,
    cls: 'nbox-feed-list',
    itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="0" cellspacing="0" width="100%" border="0" >',
				'<tr>',
					'<td class="nboxDocEditLineTd">',
						'<tpl for=".">',	
							'<div class="nboxDocEditLineDiv" onclick="deleteDocEditLine({[xindex]})">',
								'<span class="f9pt">{SignUserPosName}</span>',
								'<br />',
								'<span class="f9pt">{SignUserName}</span>',
								'<br />',
								'<span class="f9pt">&#91;{SignTypeName}&#93;</span>',
							'</div>',
				       	'</tpl>',
			    	'</td>',
				'</tr>',
	       	'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
   		var me = this;
   		var documentID = null;
   		var store = me.getStore();
		
   		me.clearData();
   		
   		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
   		if (nboxBaseApp)
   			documentID = nboxBaseApp.getDocumentID();
   		
   		if (store){
	   		store.proxy.setExtraParam('DocumentID', documentID);
	   		store.proxy.setExtraParam('CPATH', CPATH);
	   		
			store.load();
   		}
   	},
   	deleteData: function(rowIndex){
   		var me = this;
   		var record = null;
   		var store = me.getStore();
   		
   		if (store){
	   		record = store.getAt(rowIndex);
			store.remove(record);
   		}
   		
   		me.refresh();
   	},
   	clearData: function(){
   		var me = this;
   		var newRecord = null;
   		var store = me.getStore();
   		
   		if (store){
   			store.removeAll();
   		
	   		newRecord = {
				DocumentID: null,
				LineType: 'A',
				Seq:1,
				SignUserID: UserInfo.userID,
				SignUserName: UserInfo.userName,
				SignUserDeptName: UserInfo.deptName,
				SignUserPosName: UserInfo.posName,
				SignImgUrl: '/nboxfile/myinfosign/X0005',
				SignType: 0,
				SignFlag: 'N',
				SignTypeName: '기안'
	        }; 
				
	  		store.add(newRecord);
   		}
   	},
   	confirmData: function(tempStore){
		var me = this;
		var store = me.getStore();
		
		if (store){
			store.removeAll();
			store.copyData(tempStore);
		}
		
		me.refresh();
	} 
});	

Ext.define('nbox.docEditLinePanel', { 
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
		
		var nboxDocEditLineStore = Ext.create('nbox.docEditLineStore', {
			id:'nboxDocEditLineStore'
		});
		var nboxDocEditLineView = Ext.create('nbox.docEditLineView',{
			id:'nboxDocEditLineView',
			store: nboxDocEditLineStore
		});
		
		var btn =  {	
			xtype: 'button',
			id:'nboxDocApprovalButton',
			text: '결재',
		    style: 'width:100px; height:46px; margin-left:3px; margin-top:7px; margin-right:1px; padding-left:0px;',
		    handler: function() {
		    	me.buttonDown();
		    }
		};
		
		me.items = [btn, nboxDocEditLineView] ;
		            
		me.callParent();
	},
	buttonDown: function(){
		var me = this;
		
		var nboxDocEditLineView = Ext.getCmp('nboxDocEditLineView');
		var nboxDocEditRcvUserView = Ext.getCmp('nboxDocEditRcvUserView');
    	var nboxDocEditRefUserView = Ext.getCmp('nboxDocEditRefUserView');
   			
   		openDocLinePopupWin(0, 'A', nboxDocEditLineView, nboxDocEditRcvUserView, nboxDocEditRefUserView);
	},
	queryData: function(){
		var me = this;
		var nboxDocEditLineView = Ext.getCmp('nboxDocEditLineView');
		
		if (nboxDocEditLineView)
			nboxDocEditLineView.queryData();
	},
	clearData: function(){
    	var me = this;
    	var nboxDocEditLineView = Ext.getCmp('nboxDocEditLineView');
    	
    	if (nboxDocEditLineView)
    		nboxDocEditLineView.clearData();
    }
});

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	
function deleteDocEditLine(rowIndex){
	if(rowIndex == 1) {
		Ext.Msg.alert('확인', '기안자는 삭제할 수 없습니다.');
		return ;
	}
	var nboxDocEditLineView = Ext.getCmp('nboxDocEditLineView');
	nboxDocEditLineView.deleteData(rowIndex-1);
}