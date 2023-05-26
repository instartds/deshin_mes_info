/**************************************************
 * Common variable
 **************************************************/
var docControlPanelWidth = 650;

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
Ext.define('nbox.docEditFilePanel',{
	extend: 'Unilite.com.panel.UploadPanel',
	
	config: {
		regItems: {}
	},
	
	/*id: 'nboxDocFileUploadPanel',
	itemId: 'fileUploadPanel',*/
	width: docControlPanelWidth,
	url: CPATH + '/nboxfile/docupload.do',
	downloadUrl: CPATH + '/nboxfile/docdownload/',
	listeners: {
		change: function() {
             /*if(detailWin.isVisible()) {       // 처음 윈도열때는 윈독 존재 하지 않음.

            } */
		}
	},
	style: {
		'margin': '0px 5px 5px 5px'
   	},
   	queryData: function(){
   		var me = this;
   		
   		var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
   		var documentID = win.getRegItems()['DocumentID'];
   		
   		if(documentID != '' && documentID != null && documentID  !== 'undefined' )	{
	    	nboxDocListService.getFileList({DocumentID : documentID},
				function(provider, response){
					me.loadData(response.result);
				}
			);
		}else 
			me.clearData(); 
   	},
   	clearData: function(){
   		var me = this;
   		
   		me.clear();
   	}
});

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	