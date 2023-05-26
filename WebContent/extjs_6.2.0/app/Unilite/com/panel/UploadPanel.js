// @charset UTF-8

/**
 * 
 * Ext.ux.panel.UploadPanel for ExtJs 4 + plupload
 * Source: http://www.thomatechnik.de/webmaster-tools/extjs-plupload/
 * 
 * Based on:
 * http://www.sencha.com/forum/showthread.php?98033-Ext.ux.Plupload-Panel-Button-%28file-uploader%29
 * 
 * Please link to this page if you find this extension usefull
 * Version 0.2
 * 
 * @authors:
 * - mhd sulhan (ms@kilabit.org)
 * 
 * 
 * PLUPLOAD Model
 *      @example
 *       file : {
 *       	id,
 *       	fid,
 *       	loaded,
 *       	name,	// 파일명
 *       	percent,
 *       	size,
 *       	status : [1:'Queued', 2:'Uploading', 3:'Unknown', 4:'Failed', 5:'Done', 6:'기존파일'] // 6은 unilite에서 확장됨
 *      }
 * 
 */
Ext.define('Unilite.com.panel.UploadPanel', {
	extend : 'Ext.grid.Panel',
	alias : 'widget.xuploadpanel',
	
	requires: ['Ext.ProgressBar'],
	flex:1,
	/**
	 * 
	 * @cfg {String} title
	 */
	title : '',
	
	/**
	 * 
	 * @cfg {String} url
	 * 
	 * URL to your server-side upload-script
	 */
	url : CPATH+'/fileman/upload.do',
	/**
	 * 
	 * @cfg {String} downloadUrl
	 * 
	 * URL to your server-side download-script
	 */
	downloadUrl : CPATH+'/fileman/download/',//CPATH+'/fileman/download.do',
	
	/**
	 * 
	 * @cfg {String} chunk_size
	 * 
	 * The chunk-size
	 */
	//chunk_size : '512kb', 
	chunk_size : '0',
	
	/**
	 * 
	 * @cfg {String} max_file_size
	 * 
	 * The max. allowed file-size
	 */
	max_file_size : '200mb',
	
	/**
	 * 
	 * @cfg {String} unique_names
	 * 
	 * Make sure to use only unique-names
	 */
	unique_names : false, 
	
	/**
	 * 
	 * @cfg {Boolean} multipart
	 * 
	 * Use multipart-uploads
	 */
	multipart : true,  
	
	/**
	 * 
	 * @cfg {String} pluploadPath
	 * 
	 * Path to plupload
	 */
	pluploadPath : CPATH + '/resources/plupload', 
	
	/**
	 * 
	 * @cfg {String} pluploadRuntimes
	 * 
	 * All the runtimes you want to use. first available runtime will be used
	 * pluploadRuntimes : 'html5,gears,browserplus,silverlight,flash,html4',
	 */
	pluploadRuntimes : 'html5,flash,html4',
	 
	/**
	 * 
	 * @cfg {boolean} readOnly
	 * 
	 * default : false 
	 * controllerd by setReadOnly
	 */
	readOnly : false, // 
	/**
	 * 
	 * @cfg {Object}
	 * Texts (language-dependent)
	 * 
	 *      @example
	 *      texts : {
	 *       status : ['Queued', 'Uploading', 'Unknown', 'Failed', 'Done'],
	 *       DragDropAvailable : 'Drag & drop files here',
	 *       noDragDropAvailable : 'This Browser doesn\'t support drag&drop.',
	 *       emptyTextTpl : '<div style="color:#808080; margin:0 auto; text-align:center; top:48%; position:relative;">{0}</div>',
	 *       cols : ["File", "Size", "State", "Message"],
	 *       addButtonText : 'Add file',
	 *       uploadButtonText : 'Upload',
	 *       cancelButtonText : 'Cancel',
	 *       deleteButtonText : 'Delete',
	 *       deleteUploadedText : 'Delete finished',
	 *       deleteAllText : 'Delete all',
	 *       deleteSelectedText : 'Delete selected',
	 *       progressCurrentFile : 'Current file:',
	 *       progressTotal : 'Total:',
	 *       statusInvalidSizeText : 'File size is to big',
	 *       statusInvalidExtensionText : 'Invalid file-type'
	 *      }
	 */
	texts : {
		status : ['ready', 'uploading', 'Unknown', 'fail', 'uploaded','uploaded'],
		DragDropAvailable : 'Drag & drop files here',
		noDragDropAvailable : UniUtils.getMessage('system.message.commonJS.uploadPanel.noDragDropAvailable','이 브라우져는 드래그엔 드롭을 지원하지 않습니다.'),
		emptyTextTpl : '<div style="color:#808080; margin:0 auto; text-align:center; top:48%; position:relative;">{0}</div>',
		cols : ["File name", "Size", "Status", "Message"],
		addButtonText : 'Add files',
		uploadButtonText : 'Upload',
		cancelButtonText : 'Cancel',
		deleteButtonText : 'Delete',
		deleteUploadedText : 'Deleted',
		deleteAllText : 'Delete all',
		deleteSelectedText : 'Deleted Selected',
		progressCurrentFile : 'Uploading:',
		progressTotal : 'All:',
		statusInvalidSizeText : 'File size is to big',
		statusInvalidExtensionText : 'Invalid file-type'
	},

	/**
	 * 
	 * @cfg {String} addButtonCls
	 * The CSS class for add button
	 */
	addButtonCls : 'pluploadAddCls',
	
	/**
	 * 
	 * @cfg {String} uploadButtonCls
	 * The CSS class for upload button
	 */
	uploadButtonCls : 'pluploadUploadCls',
	
	/**
	 * 
	 * @cfg {String} cancelButtonCls
	 * The CSS class for cancel button
	 */
	cancelButtonCls : 'pluploadCancelCls',
	
	/**
	 * 
	 * @cfg {String} deleteButtonCls
	 * The CSS class for delete button
	 */
	deleteButtonCls : 'pluploadDeleteCls',
	
	/**
	 * 
	 * @cfg {Array} filters
	 * 
	 *     @Example :
	 *       filters: [
	 *         {title : "Image files", extensions : "jpg,JPG,gif,GIF,png,PNG"},
     *         {title : "Zip files", 	extensions : "zip,ZIP"},
     *         {title : "Text files", 	extensions : "txt,TXT"}
	 *     ]
	 */
	filters: [],
	
	/**
	 * 
	 * @cfg {} multipart_params
	 *  works as baseParams for store.  multipart must be true
	 *  
	 *      @example
	 *      Example: 
	 *       multipart_params: { param1: 1, param2: 2 }
	 */
	multipart_params : null,
	
	// Internal (do not change)
	// Grid-View
	
	/**
	 * 
	 * @cfg {Boolean} multiSelect
	 */
	multiSelect : true,
	
	/**
	 * 
	 * @cfg  {Object} viewConfig
	 */
	viewConfig : {
		deferEmptyText : false
		// For showing emptyText
	},

	// Hack: loaded of the actual file (plupload is sometimes a step ahead)
	loadedFile : 0,
	
	/**
	 * 
	 * @cfg {Boolean} 
	 */
	showProgressBBar : false,
	
	uniOpt: {
		isDirty : false,
		isLoading: false,
		autoStart: true,
		editable: true,
		maxFileNumber: -1		//최대 업로드 파일 갯수
	},
	
	constructor : function(config) {
		var me = this;
		// List of files
		this.success = [];
		this.failed = [];
		if(config.uniOpt)	{
			Ext.apply(me.uniOpt, config.uniOpt);
		}
		console.log("uniOpt :", me.uniOpt)
		// Column-Headers
		config.columns = [{
					header : 'id',
					width:150,
					dataIndex : 'id',
					hidden: true
				},{
					header : 'FID',
					width:150,
					dataIndex : 'fid',
					hidden: true
				},{
					header : me.texts.cols[0],
					flex : 1,
					dataIndex : 'name',
					'tdCls': 'GRID_COL_HREF',
					style : 'text-align:center'
				}, /*{
					header : 'Read',
					xtype: 'actioncolumn',
                    width: 70,
                    align: 'center',
					renderer: function (value, metadata, record) {
                        if (record.get('fid')) {
                            metadata.tdCls = 'pluploadDownloadActionCls'
                        }
                    },
                    me : this,
                    handler: this._download
				},*/
				{
					header : me.texts.cols[1],
					width:100,
					align : 'right',
					dataIndex : 'size',
					renderer : Ext.util.Format.fileSize,
					style : 'text-align:center'
				}, {
					header : me.texts.cols[2],
					width:120,
					dataIndex : 'status',
					renderer : me.renderStatus,
					style : 'text-align:center'
				}, {
					header : me.texts.cols[3],
					dataIndex : 'msg',
					hidden:true
				},
		        {
		        	header: 'Task',
		            xtype:'actioncolumn',
		            
					align : 'center',
					width: 80,
					style : 'text-align:center',
		            items: [{
		                icon: CPATH+'/resources/css/icons/upload_delete.png',
		                tooltip: '삭제',
		                handler: function(grid, rowIndex, colIndex) {
		                	var id = grid.store.getAt(rowIndex).get('id');
		                    me.remove_file(id);
		                },
		                isDisabled: function(view, rowIndex, colIndex, item, record) {
		                	return me.readOnly;//up('grid').readOnly;
		                }
		            }]
		        }];

		// Model and Store
		//if (!Ext.ModelManager.getModel('PluploadModel')) {
		if (!Ext.data.schema.Schema.lookupEntity('PluploadModel')) {        
			Ext.define('PluploadModel', {
						extend : 'Ext.data.Model',
						fields : [
							'id', 
							'loaded', 
							'name', 
							'size', 
							'percent', 
							{name:'status', type: 'int'}, 
							'msg',
							'fid'
						]
					});
		};

		config.store = {
			type : 'json',
			model : 'PluploadModel',
			listeners : {
				add: this.onStoreUpdate,
				load: this.onStoreLoad,
				remove: this.onStoreRemove,
				update: this.onStoreUpdate,
				datachanged: this.onStoreChanged,
				scope : this
			},
			proxy : 'memory'
		};

		this.dockedItems = [{
		    xtype: 'toolbar',
		    dock: 'top',
		    items: [
		        new Ext.Button({
								text : this.texts.addButtonText,
								itemId : 'addButton',
								iconCls : this.addButtonCls,
								disabled : true
								
					}) /* , new Ext.Button({
						text : this.texts.uploadButtonText,
						handler : this.onStart,
						scope : this,
						disabled : true,
						itemId : 'upload',
						iconCls : this.uploadButtonCls 
					}), new Ext.Button({
						text : this.texts.cancelButtonText,
						handler : this.onCancel,
						scope : this,
						disabled : true,
						itemId : 'cancel',
						iconCls : this.cancelButtonCls
					}) */
    ]
		}];
		
		// Top-Bar
		/*
		this.tbar = {
			enableOverflow : true,
			items : [new Ext.Button({
								text : this.texts.addButtonText,
								itemId : 'addButton',
								iconCls : this.addButtonCls,
								disabled : true
							}), new Ext.Button({
								text : this.texts.uploadButtonText,
								handler : this.onStart,
								scope : this,
								disabled : true,
								itemId : 'upload',
								iconCls : this.uploadButtonCls 
							}), new Ext.Button({
								text : this.texts.cancelButtonText,
								handler : this.onCancel,
								scope : this,
								disabled : true,
								itemId : 'cancel',
								iconCls : this.cancelButtonCls
							})
							// 전체 삭제 오류가 있음.
							
							//, new Ext.Button({
							//	text : this.texts.deleteAllText,
							//	handler : this.onDeleteAll,
							//	scope : this,
							//	disabled : true,
							//	itemId : 'delete',
							//	iconCls : this.deleteButtonCls
							//})
							
							// , 
							//new Ext.SplitButton({
							//text : this.texts.deleteButtonText,
							//handler : this.onDeleteSelected,
							//menu : new Ext.menu.Menu({
							//			items : [{
							//						text : this.texts.deleteUploadedText,
							//						handler : this.onDeleteUploaded,
							//						scope : this
							//					}, '-', {
							//						text : this.texts.deleteAllText,
							//						handler : this.onDeleteAll,
							//						scope : this
							//					}, '-', {
							//						text : this.texts.deleteSelectedText,
							//						handler : this.onDeleteSelected,
							//						scope : this
							//					}]
							//		}), //Ext.menu.Menu
							//scope : this,
							//disabled : true,
							//itemId : 'delete',
							iconCls : this.deleteButtonCls 
						//}) //Ext.SplitButton
						
					]
		};
		*/
		// Progress-Bar (bottom)
		if(this.showProgressBBar) {
			this.progressBarSingle = new Ext.ProgressBar({
						//flex : 1,
						width:150,
						animate : true
					});
			this.progressBarAll = new Ext.ProgressBar({
						//flex : 2,
						width:150,
						animate : true
					});
	
			this.bbar = {
				layout : {type : 'table', columns: 5 },
				style : {
					paddingLeft : '5px'
				},
				items : [
						{	xtype : 'tbtext',
							text : this.texts.progressCurrentFile, 
							style : 'text-align:right',
							width : 80
						},
						this.progressBarSingle, 
						{
							xtype : 'tbtext',
							itemId : 'single',
							style : 'text-align:right',
							text : '',
							width : 150
						}, 
						{	xtype : 'tbtext',
							text:UniUtils.getLabel('system.label.commonJS.uploadPanel.speedText',"속도"),
							style : 'text-align:right',
							width : 100
						},
						{
							xtype : 'tbtext',
							itemId : 'speed',
							style : 'text-align:right',
							text : '',
							width : 100
						},
						{	xtype : 'tbtext',
							text : this.texts.progressTotal, 
							style : 'text-align:right'
						},
						this.progressBarAll, 
						{
							xtype : 'tbtext',
							itemId : 'all',
							style : 'text-align:right',
							text : '-',
							width : 150
						}, 
						{	xtype : 'tbtext',
							text:UniUtils.getLabel('system.label.commonJS.uploadPanel.remainTime',"남은시간"),
							style : 'text-align:right',
							width : 100
						},
						{
							xtype : 'tbtext',
							itemId : 'remaining',
							style : 'text-align:right',
							text : '-',
							width : 100
						}]
			};
		}; // if (showProgressBBar)

		//addEvents 제거 - 5.0.1 deprecated
//		me.addEvents(
//			/**
//			 * @event uploadstarted
//			 * @param uploader
//			 */
//			'uploadstarted',
//			
//			/**
//			 * @event uploadcomplete
//			 * @param uploader
//			 * @param success
//			 * @param failed
//			 */
//			'uploadcomplete',
//			
//			/**
//			 * @event beforestart
//			 * @param uploader
//			 */
//			'beforestart',
//			
//			/**
//			 * @event change
//			 * @param uploader
//			 */
//			'change'
//		); //  me.addEvents
		
		me.callParent(arguments);// 더블클릭 on Cell
        this.on('celldblclick', this._onCellDblClickFun);
	},
	_onCellDblClickFun:function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			var me = this;
        	var ct = grid.headerCt.getHeaderAtIndex(cellIndex);
        	var colName = ct.dataIndex;
        	if(colName == 'name') {
        		var status = record.get('status');
        		if( status  >= 5) {
	        		var fid = record.get('fid');
	        		var url = me.downloadUrl; // +"?inline=N&fid=" +  fid;
					me.onDownload(url, fid);
        		} else {
        			Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.uploadPanel.failText','전송 되지 않은 파일입니다.'))
        		}
        	}
    },
	_download: function(view ,rowIndex , colIndex, item ,e,record,row ) {

		var me = this;
		var fid = record.get('fid')
		var body = Ext.getBody();
		var url = me.downloadUrl; // +"?inline=N&fid=" +  fid;
		me.onDownload(url, fid);
		
	},
	/**
	 * 
	 * @return {Boolean} True : 수정된 자료 있음, False : 수정 된 자료 없음.
	 */
	isDirty: function() {
		return this.uniOpt.isDirty;
	},
	onDownload : function(url, fid) {
        Ext.log("onDownload : ", url+fid);
        window.open (url+fid);
        // 폼 없이 다운 로드 하도록 수정(2014.07.31)
//        var frame, form, hidden, params;
// 
// 
//        form = Ext.fly('exportform').dom;
//        
//        form.action = url;
//        hidden = document.getElementById('fid');
//        params = {fid: fid};
//        hidden.value = fid;
// 
//        form.submit();
    },
	/**
	 * 파일 업로드 시작 
	 */
	uploadFiles : function() {
		this.uniOpt.isDirty=false;
		this.onStart();
	},
	/**
	 * Upload 추가된 파일 목록을 돌려 준다.
	 * 
	 */
	getAddFiles: function() {
		var me = this, store = this.store;
		var all = store.data.filterBy(function(item) {return item.data.status != 6;}).items;
        var rv= me._convertRecToArray(all);
        Ext.log("getAddFiles: ", rv );
        return rv;
	},
	/** 
	 * @private
	 */
	_convertRecToArray: function(data) {
		var allArray = [];
        Ext.each(data, function(rec) {
        	console.log("id:", rec.get('id'),  "status:", rec.get('status'));
        	if(rec.get('status') != 6 ) {
        		allArray.push(rec.get('fid'));
        	}
        	
        });
        return allArray;
	},	
	/**
	 * Upload 파일 목록을 돌려 준다.
	 * 
	 *  - 삭제 표시된 파일
	 *  
	 *  - upload된 파일 
	 */
	getRemoveFiles: function() {
		var me = this, store = this.store;
        var toDestroy = store.getRemovedRecords();
        var rv= me._convertRecToArrayForRemove(toDestroy);
        
        Ext.log("getRemoveFiles : ", rv);
        return rv;
	},	
	/** 
	 * @private
	 */
	_convertRecToArrayForRemove: function(data) {
		var allArray = [];
        Ext.each(data, function(rec) {
        	console.log("id:", rec.get('id'),  "status:", rec.get('status'));
        	if(rec.get('status') == 6 ) {
        		allArray.push(rec.get('fid'));
        	}
        	
        });
        return allArray;
	},
	/**
	 * Store 데이타 변경(store.loadData).
	 * @param data {Ext.data.Model[]/Object[]}
	 * @param {Boolean} [append=false]
	 */
	loadData : function(data, append) {
		
		var me = this, store = this.store;
		me.uniOpt.isLoading=true;
		me.reset();
		store.loadData(data, append);
		me.uniOpt.isLoading = false;
	},
	/** 
	 * 데이타 reeset
	 */
	reset : function() {
		var me = this;
		me.uniOpt.isDirty =false;
		
		if(me.uploader) {
			me.uploader.splice();
		};
		
//		me.store.loadRecords({}, {addRecords: false});
//		me.store.clearData(); 
		me.store.removeAll();
		me.view.refresh();
		
	},
	/**
	 * @private
	 */
	afterRender : function() {
		this.callParent(arguments);
		this.initPlUpload();
	},
	/**
	 * @param {} value
	 * @param {} meta
	 * @param {} record
	 * @param {} rowIndex
	 * @param {} colIndex
	 * @param {} store
	 * @param {} view
	 * @return {}
	 * 
	 * @private
	 */
	renderStatus : function(value, meta, record, rowIndex, colIndex, store,
			view) {
		var s = this.texts.status[value - 1];
		if (value == 2) {
			s += " " + record.get("percent") + " %";
		}
		return s;
	},
	/** 
	 * @private
	 */
	getTopToolbar : function() {
		var bars = this.getDockedItems('toolbar[dock="top"]');
		return bars[0];
	},
	/** 
	 * @private
	 */
	getBottomToolbar : function() {
		var bars = this.getDockedItems('toolbar[dock="bottom"]');
		return bars[0];
	},
	/** 
	 * @private
	 */
	initPlUpload : function() {
		this.uploader = new plupload.Uploader({
					file_data_name : 'file',
					url : this.url,
					runtimes : this.pluploadRuntimes,
					browse_button : this.getTopToolbar().getComponent('addButton').getEl().dom.id,
					container : this.getEl().dom.id,
					max_file_size : this.max_file_size || '',
					resize : this.resize || '',
					flash_swf_url : this.pluploadPath + '/plupload.flash.swf',
					silverlight_xap_url : this.pluploadPath + 'plupload.silverlight.xap',
					filters : this.filters || [],
					chunk_size : this.chunk_size,
					unique_names : this.unique_names,
					multipart : this.multipart,
					multipart_params : this.multipart_params || null,
					drop_element : this.getEl().dom.id,
					required_features : this.required_features || null
				});

	

		// Events of plupload
		var events = [
				'Init', 
				'ChunkUploaded', 
				'FilesRemoved',
				'FileUploaded', 
				'PostInit', 
				'QueueChanged',
				'Refresh', 
				'StateChanged', 
				'UploadFile',
				'UploadProgress', 
				'Error'
			]; // events
		Ext.each(events, function(v) {
							this.uploader.bind(v, eval("this.Plupload" + v), this);
						}, this);
		// Init Plupload
		this.uploader.init(); 
		// 	plupload 자체 이벤트 먼저 처리하게 init 순서를 이벤트 정의부문과 바꿈.
		// Events of plupload
		var events = [
				'FilesAdded'
			]; // events
		Ext.each(events, function(v) {
							this.uploader.bind(v, eval("this.Plupload" + v), this);
						}, this);
	},
	/** 
	 * @private
	 */
	onDeleteSelected : function() {
		Ext.each(this.getView().getSelectionModel().getSelection(), function(
						record) {
					this.remove_file(record.get('id'));
				}, this);

	},
	/** 
	 * @private
	 */
	onDeleteAll : function() {
		
		this.store.each(function(record) {
					this.remove_file(record.get('id'));
				}, this);
	},
	/** 
	 * @private
	 */
	onDeleteUploaded : function() {
		this.store.each(function(record) {
					if (record.get('status') == 5) {
						this.remove_file(record.get('id'));
					}
				}, this);
	},
	/** 
	 * @private
	 */
	onCancel : function() {
		this.uploader.stop();
		if(this.showProgressBBar) {
			this.updateProgress();
		};
	},
	/** 
	 * @private
	 */
	onStart : function() {
		var me = this;
		this.fireEvent('beforestart', this);
		if(me.uniOpt.editable){
			if (me.uniOpt.maxFileNumber != -1 && me.uniOpt.maxFileNumber < me.store.getCount())	{
				return ;	
			}
			if (this.multipart_params) {
				this.uploader.settings.multipart_params = this.multipart_params;
				this.uploader.settings.multipart_params.id = Earsip.berkas.tree.id;
			}
			this.uploader.start();
		}
	},
	/** 
	 * @private
	 */
	remove_file : function(id) {
		var me = this;
		if(me.uniOpt.editable){
			var fileObj = this.uploader.getFile(id);
			if (fileObj) {
				console.log(" delete fileObj", fileObj);
				this.uploader.removeFile(fileObj);
			} else {
				console.log(" delete row ", id);
				this.store.remove(this.store.getById(id));
			}
		}
	},
	/** 
	 * @private
	 */
	updateStore : function(files) {
		var me = this;
		if (me.uniOpt.maxFileNumber != -1 && me.uniOpt.maxFileNumber < me.store.getCount())	{
				return ;	
			}
		if(me.uniOpt.editable){
			
			Ext.each(files, function(data) {
						this.updateStoreFile(data);
					}, this);
		}
	},
	/** 
	 * @private
	 */
	updateStoreFile : function(data) {
		var me = this;
		
		data.msg = data.msg || '';
		var record = this.store.getById(data.id);
		if (record) {
			record.set(data);
			record.commit();
		} else {
			if (me.uniOpt.maxFileNumber != -1 && me.uniOpt.maxFileNumber < me.store.getCount())	{
					Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.uploadPanel.invalidText','파일수가 초과 되었습니다. '), UniUtils.getMessage('system.message.commonJS.uploadPanel.maxFile','최대 파일 수 : ')+me.uniOpt.maxFileNumber);
					return ;	
			}
			this.store.add(data);
		}
	},
	
	//onStoreLoad : function(store, record, operation) {
	onStoreLoad : function(store, records, successful, eOpts) {
	},
	//onStoreRemove : function(store, record, operation) {
	onStoreRemove : function(store, records, index, isMove, eOpts) {	//5.1 파라미터 변경 : record -> records. Ext.data.Model[] 로 변경
		var me = this;
		
		if (!store.data.length) {
			if(this.useDeleteMenu) {
				this.getTopToolbar().getComponent('delete').setDisabled(true);
			}
			this.uploader.total.reset();
		}
		
		Ext.each(records, function(record){
			if(record instanceof PluploadModel) {
				var id = record.get('id');

				Ext.each(me.success, function(v) {
							if (v && v.id == id) {
								Ext.Array.remove(me.success, v);
							}
						}, me);
		
				Ext.each(me.failed, function(v) {
							if (v && v.id == id) {
								Ext.Array.remove(me.failed, v);
							}
						}, me);
				me._setDirty();
			}		
		});
		
	},
	
	// store's datachanged event
	onStoreChanged : function ( store, eOpts) {
		if(!this.uniOpt.isLoading && this.uniOpt.isDirty ) {
			//this.uniOpt.isDirty = true;
			this.fireEvent('change', this);
		}
		
	},
	onStoreUpdate : function(store, record, operation) {
		var me = this;
		if(me.uniOpt.editable){
			var canUpload = false;
			if (this.uploader.state != 2) {
				this.store.each(function(record) {
							if (record.get("status") == 1) {
								canUpload = true;
								return false;
							}
						}, this);
			}
			if(!this.uniOpt.autoStart) {
				var toolbar = this.getTopToolbar();
				if(toolbar) {
					var uploadComp = this.getTopToolbar().getComponent('upload');
					if(uploadComp)	{
						uploadComp.setDisabled(!canUpload);
					}
				}
			}
			this._setDirty();
		}
	},
	_setDirty: function() {
		this.uniOpt.isDirty=true;
		
	},
	updateProgress : function(file) {
		if(this.showProgressBBar) {
			var queueProgress = this.uploader.total;
			// All
			var total = queueProgress.size;
			var uploaded = queueProgress.loaded ;
			console.log(queueProgress, queueProgress.percent, "uploaded",uploaded,"total",total)
			this.getBottomToolbar().getComponent('all').setText(Ext.util.Format
					.fileSize(uploaded)
					+ "/" + Ext.util.Format.fileSize(total));
	
			if (total > 0) {
				this.progressBarAll.updateProgress(queueProgress.percent / 100,
						queueProgress.percent + " %");
			} else {
				this.progressBarAll.updateProgress(0, ' ');
			}
	
			// Speed+Remaining
			var speed = queueProgress.bytesPerSec;
			if (speed > 0) {
				var totalSec = parseInt((total - uploaded) / speed);
				var hours = parseInt(totalSec / 3600) % 24;
				var minutes = parseInt(totalSec / 60) % 60;
				var seconds = totalSec % 60;
				var timeRemaining = result = (hours < 10 ? "0" + hours : hours)
						+ ":" + (minutes < 10 ? "0" + minutes : minutes) + ":"
						+ (seconds < 10 ? "0" + seconds : seconds);
				this.getBottomToolbar().getComponent('speed').setText(Ext.util.Format.fileSize(speed) + '/s');
				this.getBottomToolbar().getComponent('remaining').setText(timeRemaining);
			} else {
				this.getBottomToolbar().getComponent('speed').setText('');
				this.getBottomToolbar().getComponent('remaining').setText('');
			}
	
			// Single
			if (!file) {
				this.getBottomToolbar().getComponent('single').setText('');
				this.progressBarSingle.updateProgress(0, ' ');
			} else {
				total = file.size;
				// uploaded = file.loaded; // file.loaded sometimes is 1 step ahead,
				// so we can not use it.
				// uploaded = 0; if (file.percent > 0) uploaded = file.size *
				// file.percent / 100.0; // But this solution is imprecise as well
				// since percent is only a hint
				uploaded = this.loadedFile; // So we use this Hack to store the
				// value which is one step back
				this.getBottomToolbar().getComponent('single')
						.setText(Ext.util.Format.fileSize(uploaded) + "/"
								+ Ext.util.Format.fileSize(total));
				this.progressBarSingle.updateProgress(file.percent / 100,
						(file.percent).toFixed(0) + " %");
			}
		}; // if(showProgressBBar)
	},
	/** 
	 * @private
	 */
	PluploadInit : function(uploader, data) {
		var me = this;
		this.getTopToolbar().getComponent('addButton').setDisabled(!me.uniOpt.editable);

		if(me.uniOpt.editable){
			console.log("Runtime: ", data.runtime);
			if (data.runtime == "flash" || data.runtime == "silverlight"
					|| data.runtime == "html4") {
				this.view.emptyText = this.texts.noDragDropAvailable;
			} else {
				this.view.emptyText = this.texts.DragDropAvailable
			}
			this.view.emptyText = String.format(this.texts.emptyTextTpl,
					this.view.emptyText);
			this.view.refresh();
			
			if(this.showProgressBBar) {
				this.updateProgress();
			};
		}
	},
	/** 
	 * @private
	 */
	PluploadChunkUploaded : function() {
	},
	/** 
	 * @private
	 */
	PluploadFilesAdded : function(uploader, files) {
		var me = this;
		if(me.uniOpt.editable){
			if(this.useDeleteMenu) {
				this.getTopToolbar().getComponent('delete').setDisabled(false);
			}
			
			if (me.uniOpt.maxFileNumber != -1 && me.uniOpt.maxFileNumber < me.store.getCount())	{
				return ;	
			}
			
			this.updateStore(files);
			if(this.showProgressBBar) {
				this.updateProgress();
			};
			console.log("upload added");
			if(this.uniOpt.autoStart) {
				this.onStart();
			}
		}
	},
	/** 
	 * @private
	 */
	PluploadFilesRemoved : function(uploader, files) {
		var me = this;

		if(me.uniOpt.editable){
			Ext.each(files, function(file) {
						this.store.remove(this.store.getById(file.id));
					}, this);
	
			if(this.showProgressBBar) {
				this.updateProgress();
			};
		}
	},
	/** 
	 * @private
	 */
	PluploadFileUploaded : function(uploader, file, status) {
		var response = Ext.JSON.decode(status.response);
		if (response.success == true) {
			file.server_error = 0;
			// fid update
			file.fid = response.fid;
			this.success.push(file);
		} else {
			if (response.message) {
				file.msg = '<span style="color: red">' + response.message
						+ '</span>';
			}
			file.server_error = 1;
			this.failed.push(file);
		}
		this.updateStoreFile(file);
		if(this.showProgressBBar) {
			this.updateProgress(file);
		};
	},
	/** 
	 * @private
	 */
	PluploadPostInit : function() {
	},
	/** 
	 * @private
	 */
	PluploadQueueChanged : function(uploader) {
		if(this.showProgressBBar) {
			this.updateProgress();
		};
	},
	/** 
	 * @private
	 */
	PluploadRefresh : function(uploader) {
		this.updateStore(uploader.files);
		if(this.showProgressBBar) {
			this.updateProgress();
		};
	},
	/** 
	 * @private
	 */
	PluploadStateChanged : function(uploader) {
		if (uploader.state == 2) {
			this.fireEvent('uploadstarted', this);
			if(this.getTopToolbar().getComponent('cancel')) {
				this.getTopToolbar().getComponent('cancel').setDisabled(false);
			}
		} else {
			this.fireEvent('uploadcomplete', this, this.success, this.failed);
			
			if(this.getTopToolbar().getComponent('cancel')) {
				this.getTopToolbar().getComponent('cancel').setDisabled(true);
			}
		}
	},
	/** 
	 * @private
	 */
	PluploadUploadFile : function() {
		this.loadedFile = 0;
	},
	/** 
	 * @private
	 */
	PluploadUploadProgress : function(uploader, file) {
		// No chance to stop here - we get no response-text from the server. So
		// just continue if something fails here. Will be fixed in next update,
		// says plupload.
		if (file.server_error) {
			file.status = 4;
		}
		this.updateStoreFile(file);
		if(this.showProgressBBar) {
			this.updateProgress(file);
		};
		this.loadedFile = file.loaded;
	},
	/** 
	 * @private
	 */
	PluploadError : function(uploader, data) {
		data.file.status = 4;
		if (data.code == -600) {
			data.file.msg = String.format(
					'<span style="color: red">{0}</span>',
					this.texts.statusInvalidSizeText);
		} else if (data.code == -700) {
			data.file.msg = String.format(
					'<span style="color: red">{0}</span>',
					this.texts.statusInvalidExtensionText);
		} else {
			data.file.msg = String.format(
					'<span style="color: red">{2} ({0}: {1})</span>',
					data.code, data.details, data.message);
		}
		this.updateStoreFile(data.file);
		if(this.showProgressBBar) {
			this.updateProgress();
		};
	}
	, clear : function()	{
		var me = this;
		me.uniOpt.isDirty =false;
		
		me.store.clearData(); 
		me.view.refresh();
		
	}
	, setReadOnly : function(readOnly)	{
		this.readOnly = readOnly;
		
		var btn = this.down('#addButton');
		if(btn) {
			btn.setDisabled(readOnly);
		}
	}
});


Ext.define('PluploadModel', {
						extend : 'Ext.data.Model',
						fields : ['id', 'loaded', 'name', 'size', 'percent', 'status', 'msg','fid']
					});
