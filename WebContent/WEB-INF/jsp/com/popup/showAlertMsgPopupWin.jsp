<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.showAlertMsgPopup");
%>
 Unilite.defineModel('${PKGNAME}.alertMsgPopupModel', {
    fields: [ 	 {name: 'DIV_CODE' 			,text:'사업장'		,type:'string'}
				,{name: 'ALERT_USER_ID'		,text: '담당자'		,type:'string'}
				,{name: 'ALERT_TYPE' 		,text:'구분'			,type:'string'}
				,{name: 'ALERT_PROGRAM_ID' 	,text:'알림프로그램ID'	,type:'string'}
				,{name: 'ALERT_PROGRAM_NAME',text:'알림프로그램명'	,type:'string'}
				,{name: 'ALERT_CNT' 		,text:'메세지수'		,type:'string'}
				,{name: 'PROGRAM_ID' 		,text:'프로그래먕'	,type:'string'}
				,{name: 'PROGRAM_NAME' 		,text:'프로그램명'	,type:'string'}
				,{name: 'REF_NUM' 			,text:'참조번호'		,type:'string'}
				,{name: 'JSON_PARAMETER' 	,text:'파라메타'		,type:'string'}
				,{name: 'UPDATE_DB_TIME' 	,text:'시간'			,type:'string'}
				,{name: 'ALERT_MESSAGE' 	,text:'메세지'			,type:'string'}
				,{name: 'PATH' 				,text:'PATH'			,type:'string'}
		]
});
Ext.define('${PKGNAME}', {
	extend: 'Unilite.com.BaseJSPopupApp',
	uniOpt:{
    	btnQueryHide:true,
    	btnSubmitHide:true,
    	btnCloseHide:false
    },
	constructor : function(config) {
	var me = this;
	if (config) {
		Ext.apply(me, config);
	}

	var tplTmplate = new Ext.XTemplate(
		'<tpl for=".">',
	    '<div class="alertItem">',
	    '	<div style="margin:10px;cursor:pointer;padding:10px;background-color: #eeeeee;display: table; width:750px;"><div onClick="alertWin.gotoPgm()"><div style="float:left;width:690px"><strong>{ALERT_PROGRAM_NAME}</strong><br/>',
	    '{ALERT_MESSAGE}<br>({UPDATE_DB_TIME})<br/></div></div>',
	    '<div onClick="alertWin.readAlam(\'alertReadImg{#}\')" style="padding:3px;float:left;width:40px;border:0px solid #f9c;text-align:center;"><img src="'+CPATH+'/resources/css/theme_01/btn_badge_on.png" width="30" id="alertReadImg{#}"/></div></div>',
	   	 '</div>',
	    '</div>',
	   	'</tpl>'
	    )
	var masterViewConfig = {
		ItemId:'showAlertWin',
		tpl: tplTmplate,
		scrollable:true,
		style:{'background-color':'#fff'},
		flex:1,
		itemSelector: 'div.alertItem' ,
        overItemCls: 'div.alertItem',
        selectedItemClass: 'div.alertItem',
        singleSelect: true,
		store: Unilite.createStore('${PKGNAME}.alertMsgPopupMasterStore',{
				model: '${PKGNAME}.alertMsgPopupModel',
				autoLoad: true,
				proxy: {
					type: 'direct',
					api: {
						read: 'badgeService.selectList'
					}
				}
		}),
		/*,
		listeners: {
			select:function(view, record, item, index, e, eOpts) {
				var rec = {data : {prgID : record.get("ALERT_PROGRAM_ID"), 'text':''}};
                var url = record.get("PATH");

				var jsonObj = JSON.parse(record.get("JSON_PARAMETER"));
				parent.openTab(rec, url, jsonObj);
				var alertstore = Ext.StoreManager.lookup("mainBadgeStore");
				alertstore.load();
				me.hide();
				return false;
			}
		}*/
	};

	me.masterView = Ext.create('Ext.view.View', masterViewConfig);

	config.items = [me.masterView];
	me.callParent(arguments);
	},
	initComponent : function(){
		var me  = this;

		this.callParent();
	},
	fnInitBinding : function(param) {
		var me = this;
		var frm= me.panelSearch;

		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	_dataLoad : function() {
		var me = this;
		me.isLoading = true;
		me.masterView.getStore().load({
			callback:function()	{
				me.isLoading = false;
			}
		});
	},
	gotoPgm: function()	{
		var view = this.masterView;
		setTimeout(function(){
			var model = view.getSelectionModel();
			var record = {};
			if(model )	{
				var records = model.getSelection();
				if(records)	{
					record = records[0];
				}
			}
			var alertId = record.get('ALERT_PROGRAM_ID');
			var url = record.get("PATH");
			var jsonParam = record.get("JSON_PARAMETER");

   			var rec = {data : {prgID : alertId, 'text':''}};
			var jsonObj = JSON.parse(jsonParam);
			parent.openTab(rec, url, jsonObj);
			var alertstore = Ext.StoreManager.lookup("mainBadgeStore");
			alertstore.load();
			alertWin.hide();
		},100);
      	return ;
      },
     readAlam: function(imageId)	{
		var view = this.masterView;
    	setTimeout(function(){
			var model = view.getSelectionModel();
			var record = {};
			if(model )	{
				var records = model.getSelection();
				if(records)	{
					record = records[0];
				}
			}
			if(!Ext.isEmpty(record))	{
				view.getEl().mask();
				if(Ext.getElementById(imageId).src.indexOf("btn_badge_on.png")>-1)	{

					badgeService.readMessage(record.data, function()	{
						view.getEl().unmask();
						Ext.getElementById(imageId).src = CPATH+"/resources/css/theme_01/btn_badge_off.png";
						var store = Ext.StoreManager.lookup("mainBadgeStore");
                    	store.load();
					});
				} else {
					badgeService.unreadMessage(record.data, function()	{
						view.getEl().unmask();
						Ext.getElementById(imageId).src = CPATH+"/resources/css/theme_01/btn_badge_on.png";
						var store = Ext.StoreManager.lookup("mainBadgeStore");
                    	store.load();
					});
				}
			}
		},100);
     }
});


