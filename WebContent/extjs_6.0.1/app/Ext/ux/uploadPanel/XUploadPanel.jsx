/**
 * 多文件上传组件 
 * for extjs4.0
 * 
 * swf Upload 사용으로 모바일 지원 안됨 !!!
 * 
 * site : http://my.oschina.net/u/560628/blog/89953
 * @author caizhiping
 * @since 2012-11-15
 */
Ext.define('Ext.ux.uploadPanel.XUploadPanel',{
	extend : 'Ext.grid.Panel',
	alias : 'widget.uploadpanel',
	width : 700,
	height : 300,
	columns : [
        {xtype: 'rownumberer'},
		{text: '원본이름', width: 100,dataIndex: 'name'},
		{text: '이름', width: 130,dataIndex: 'fileName',editor: {xtype: 'textfield'}},
        {text: '종류', width: 70,dataIndex: 'type'},
        {text: '크기', width: 70,dataIndex: 'size',renderer:function(v){
        	return Ext.util.Format.fileSize(v);
        }},
        {text: '진행', width: 130,dataIndex: 'percent',renderer:function(v){        	
			var stml =
				'<div>'+
					'<div style="border:1px solid #008000;height:10px;width:115px;margin:2px 0px 1px 0px;float:left;">'+		
						'<div style="float:left;background:#FFCC66;width:'+v+'%;height:8px;"><div></div></div>'+
					'</div>'+
				//'<div style="text-align:center;float:right;width:40px;margin:3px 0px 1px 0px;height:10px;font-size:12px;">{3}%</div>'+			
			'</div>';
			return stml;
        }},
        {text: '상태', width: 80,dataIndex: 'status',renderer:function(v){
			var status;
			if(v==-1){
				status = "Queued";
			}else if(v==-2){
				status =  "Uploading...";
			}else if(v==-3){
				status =  "<div style='color:red;'>Failed</div>";
			}else if(v==-4){
				status =  "Done";
			}else if(v==-5){
				status =  "Cancel";
			}		
			return status;
		}},
        {
            xtype:'actioncolumn',
            width:50,
            items: [{
                icon: CPATH+'/resources/css/icons/upload_delete.png',
                tooltip: 'Remove',
                handler: function(grid, rowIndex, colIndex) {
                	var id = grid.store.getAt(rowIndex).get('id');
                    grid.store.remove(grid.store.getAt(rowIndex));
                }
            }]
        }
    ],
    plugins: [
        Ext.create('Ext.grid.plugin.CellEditing', {
            clicksToEdit: 1
        })
    ],    
    store : Ext.create('Ext.data.JsonStore',{
    	autoLoad : false,
    	fields : ['id','name','type','size','percent','status','fileName']
    }),
    
	addFileBtnText : '추가', 	// 'Add File',
	uploadBtnText : '저장', 	// Upload',
	removeBtnText : '전체제거',	// Remove All',
	cancelBtnText : '취소',		// 'Cancel',
	
	debug : false,
	file_size_limit : 100,//MB
	file_types : '*.*',
	file_types_description : 'All Files',
	file_upload_limit : 50,
	file_queue_limit : 0,
	post_params : {},
	upload_url : 'test.do',
	flash_url : CPATH+"/resources/swf/swfupload.swf.v2.5.0.beta3.2.swf",
	flash9_url : "swfupload/swfupload_fp9.swf",
	initComponent : function(){		
		this.dockedItems = [{
		    xtype: 'toolbar',
		    dock: 'top',
		    items: [
		        { 
			        xtype:'button',
			        itemId: 'addFileBtn',
			        iconCls : 'upload_add',
			        id : '_btn_for_swf_',
			        text : this.addFileBtnText
		        },{ xtype: 'tbseparator' },{
		        	xtype : 'button',
		        	itemId : 'uploadBtn',
		        	iconCls : 'upload_up',
		        	text : this.uploadBtnText,
		        	scope : this,
		        	handler : this.onUpload
		        },{ xtype: 'tbseparator' },{
		        	xtype : 'button',
		        	itemId : 'removeBtn',
		        	iconCls : 'upload_trash',
		        	text : this.removeBtnText,
		        	scope : this,
		        	handler : this.onRemove
		        },{ xtype: 'tbseparator' },{
		        	xtype : 'button',
		        	itemId : 'cancelBtn',
		        	iconCls : 'upload_cancel',
		        	disabled : true,
		        	text : this.cancelBtnText,
		        	scope : this,
		        	handler : this.onCancelUpload
		        }
		    ]
		}];
		
		this.callParent();
		this.down('button[itemId=addFileBtn]').on({			
			afterrender : function(btn){
				var config = this.getSWFConfig(btn);		
				this.swfupload = new SWFUpload(config);
				Ext.get(this.swfupload.movieName).setStyle({
					position : 'absolute',
					top : 0,
					left : -2
				});	
			},
			scope : this,
			buffer:300
		});
	},
	getSWFConfig : function(btn){
		var me = this;
		var placeHolderId = Ext.id();
		var em = btn.getEl().child('em');
		if(em==null){
			em = Ext.get(btn.getId()+'-btnWrap');
		}		
		em.setStyle({
			position : 'relative',
			display : 'block'
		});
		em.createChild({
			tag : 'div',
			id : placeHolderId
		});
		return {
			debug: me.debug,
			flash_url : me.flash_url,
			flash9_url : me.flash9_url,	
			upload_url: me.upload_url,
			post_params: me.post_params||{savePath:'upload\\'},
			file_size_limit : (me.file_size_limit*1024),
			file_types : me.file_types,
			file_types_description : me.file_types_description,
			file_upload_limit : me.file_upload_limit,
			file_queue_limit : me.file_queue_limit,
			button_width: em.getWidth(),
			button_height: em.getHeight(),
			button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
			button_cursor: SWFUpload.CURSOR.HAND,
			button_placeholder_id: placeHolderId,
			custom_settings : {
				scope_handler : me
			},
			swfupload_preload_handler : me.swfupload_preload_handler,
			file_queue_error_handler : me.file_queue_error_handler,
			swfupload_load_failed_handler : me.swfupload_load_failed_handler,
			upload_start_handler : me.upload_start_handler,
			upload_progress_handler : me.upload_progress_handler,
			upload_error_handler : me.upload_error_handler,
			upload_success_handler : me.upload_success_handler,
			upload_complete_handler : me.upload_complete_handler,
			file_queued_handler : me.file_queued_handler/*,
			file_dialog_complete_handler : me.file_dialog_complete_handler*/
		};
	},
	swfupload_preload_handler : function(){
		if (!this.support.loading) {
			Ext.Msg.show({
				title : '확인',
				msg : '브라우져의 Flash Player 버젼이 너무 낮아 사용이 불가능 합니다.',
				width : 250,
				icon : Ext.Msg.ERROR,
				buttons :Ext.Msg.OK
			});
			return false;
		}
	},
	file_queue_error_handler : function(file, errorCode, message){
		switch(errorCode){
			case SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED : msg('큐의 파일수가 제한갯수를 초과 하였습니다.');
			break;
			case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT : msg('파일 최대 크기를 초과 하였습니다.');
			break;
			case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE : msg('파일크기가 0인 파일은 업로드 할 수 없습니다.');
			break;
			case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE : msg('파당 파일형식을 업로드 할 수 없습니다.');
			break;
		}
		function msg(info){
			Ext.Msg.show({
				title : '확인',
				msg : info,
				width : 250,
				icon : Ext.Msg.WARNING,
				buttons :Ext.Msg.OK
			});
		}
	},
	swfupload_load_failed_handler : function(){
		Ext.Msg.show({
			title : '확인',
			msg : 'SWFUpload를 로드 할수 없습니다.',
			width : 180,
			icon : Ext.Msg.ERROR,
			buttons :Ext.Msg.OK
		});
	},
	upload_start_handler : function(file){
		var me = this.settings.custom_settings.scope_handler;
		me.down('#cancelBtn').setDisabled(false);	
		var rec = me.store.getById(file.id);
		this.setFilePostName(encodeURIComponent(rec.get('fileName')));
	},
	upload_progress_handler : function(file, bytesLoaded, bytesTotal){
		var me = this.settings.custom_settings.scope_handler;		
		var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);
		percent = percent == 100? 99 : percent;
       	var rec = me.store.getById(file.id);
       	rec.set('percent', percent);
		rec.set('status', file.filestatus);
		rec.commit();
	},
	upload_error_handler : function(file, errorCode, message){
		var me = this.settings.custom_settings.scope_handler;		
		var rec = me.store.getById(file.id);
       	rec.set('percent', 0);
		rec.set('status', file.filestatus);
		rec.commit();
	},
	upload_success_handler : function(file, serverData, responseReceived){
		var me = this.settings.custom_settings.scope_handler;		
		var rec = me.store.getById(file.id);
		if(Ext.JSON.decode(serverData).success){			
	       	rec.set('percent', 100);
			rec.set('status', file.filestatus);			
		}else{
			rec.set('percent', 0);
			rec.set('status', SWFUpload.FILE_STATUS.ERROR);
		}
		rec.commit();
		if (this.getStats().files_queued > 0 && this.uploadStopped == false) {
			this.startUpload();
		}else{
			me.showBtn(me,true);
		}
	},
	upload_complete_handler : function(file){
		
	},
	file_queued_handler : function(file){
		var me = this.settings.custom_settings.scope_handler;
		me.store.add({
			id : file.id,
			name : file.name,
			fileName : file.name,
			size : file.size,
			type : file.type,
			status : file.filestatus,
			percent : 0
		});
	},
	onUpload : function(){
		if (this.swfupload&&this.store.getCount()>0) {
			if (this.swfupload.getStats().files_queued > 0) {
				this.showBtn(this,false);
				this.swfupload.uploadStopped = false;		
				this.swfupload.startUpload();
			}
		}
	},
	showBtn : function(me,bl){
		me.down('#addFileBtn').setDisabled(!bl);
		me.down('#uploadBtn').setDisabled(!bl);
		me.down('#removeBtn').setDisabled(!bl);
		me.down('#cancelBtn').setDisabled(bl);
		if(bl){
			me.down('actioncolumn').show();
		}else{
			me.down('actioncolumn').hide();
		}		
	},
	onRemove : function(){
		var ds = this.store;
		for(var i=0;i<ds.getCount();i++){
			var record =ds.getAt(i);
			var file_id = record.get('id');
			this.swfupload.cancelUpload(file_id,false);			
		}
		ds.removeAll();
		this.swfupload.uploadStopped = false;
	},
	onCancelUpload : function(){
		if (this.swfupload) {
			this.swfupload.uploadStopped = true;
			this.swfupload.stopUpload();
			this.showBtn(this,true);
		}
	}
});