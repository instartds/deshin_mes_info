//@charset UTF-8

Ext.define('Unilite.Excel', {
	singleton: true,
	text : {
		rownumText:UniUtils.getLabel('system.label.commonJS.excel.rownumText','행'),
		errorMsgText:UniUtils.getLabel('system.label.commonJS.excel.errorMsgText','오류'),
		hasErrorText:UniUtils.getLabel('system.label.commonJS.excel.hasErrorText','오류여부')
	},
	
	defineModel: function (id, config) {
		var baseFields = [
			{name: '_EXCEL_ROWNUM'		, text:this.rownumText 	, type: 'int'},
			{name: '_EXCEL_ERROR_MSG'	, text:this.errorMsgText 	, type:'string'},
			{name: '_EXCEL_HAS_ERROR'	, text:this.hasErrorText 	, type:'string', hidden: true}
		];
		config.fields = baseFields.concat(config.fields);
		
		Ext.apply(config, {
			extend: 'Ext.data.Model',
			idProperty: '_EXCEL_ROWNUM'
		});
		
		Ext.define(id, config);
	}
});

Ext.define('Unilite.com.excel.ExcelUploadWin', { 
	extend: 'Unilite.com.window.UniWindow',
	layout: {type:'vbox', align:'stretch'},

	requires: ['Unilite.com.grid.UniSimpleGridPanel'],
	
	border: 0,
	closable: false,
	width: 600,
	height: 520,
	extParam: {},
	title: UniUtils.getLabel('system.label.commonJS.excel.title','엑셀 업로드'),
	// excelConfigName: 'sof100',
	tbar: null,
	jobID:null,
	url : '/excel/upload.do',
	
	constructor : function(config) {
		var me = this;
		if (config) {
		  Ext.apply(me, config);
		};
		
		var frm = {
			xtype: 'uniDetailFormSimple',
			fileUpload: true,
			itemId: 'uploadForm',
			url: CPATH + me.url,
			layout:{type:'hbox', align:'stretch'},
			fileUpload: true,
			items : [ 
	 				
					 { 
	 					xtype: 'filefield',
	 					buttonOnly: false,
	 					fieldLabel: UniUtils.getLabel('system.label.commonJS.excel.fieldLabel','엑셀파일'),
	 					flex: 1,
	 					margin:5,
	 					name: 'excelFile',
	 					buttonText: UniUtils.getLabel('system.label.commonJS.excel.btnText','파일선택'),
	 					listeners: {
	 						change: function( filefield, value, eOpts )	{
	 								var fileExtention = value.substring(value.lastIndexOf("."));
	 								console.log("new file's extension is ",fileExtention);
	 								
	 						 } // change
	 					} // listeners
				   } // filefield
	 			]
		};
		
		
		var sampleDownloadUrl = CPATH + "/excel/samples/"+me.excelConfigName;
		var tabpanel = {
			xtype: 'tabpanel',
			flex:1,
			
			items: [
				{
					title: 'Help',
					margin:5,
					html: ' Sample #1(Excel 2003 format) : <a href="'+sampleDownloadUrl+'?type=xls"> ['+UniUtils.getLabel('system.label.commonJS.excel.downloadText','다운로드')+']</a>'+'<br/>'
						+' Sample #2(Excel 2007 format) : <a href="'+sampleDownloadUrl+'?type=xlsx">['+UniUtils.getLabel('system.label.commonJS.excel.downloadText','다운로드')+']</a>'
				}
			]
		};
		
		if(this.excelConfigName) {
			for(i in this.grids) {
				var cfg = this.grids[i];
				var tColumns = [];
				var tStore = new Ext.data.DirectStore( {
					model: cfg.model,
					autoLoad: false,	
					sorters: [
							  {property: '_EXCEL_ERROR_MSG', direction : 'DESC'}, 
							  {property: '_EXCEL_ROWNUM'}
							  ],
					proxy: {
						type: 'direct',
						api: {
							read: cfg.readApi
						}
					}
				});
				var newColumns =  [
						{ dataIndex:'_EXCEL_ROWNUM', width: 50},
						{ dataIndex:'_EXCEL_ERROR_MSG', flex:1, minWidth: 100}
				];
				newColumns = newColumns.concat(cfg.columns);
				var gridConfig = {
						xtype: 'uniSimpleGridPanel',
						store: tStore,
						flex: 1,
						itemId: cfg.itemId,
						title: cfg.title,
						columns: newColumns,
						selType: 'rowmodel', 
						viewConfig: {
							emptyText: UniUtils.getMessage('system.message.commonJS.excel.emptyText','엑셀 파일을 Upload해주세요.'),
							deferEmptyText: false,
							getRowClass: function(record) { 
								if ( !Ext.isEmpty(record.get('_EXCEL_ERROR_MSG')) ) {
									return 'x-grid-excel-hasError';
								
								}
							} 
						},
						listeners:{
							/*beforeselect: function ( gridPanel, record, index, eOpts ) {
								if (record.get('_EXCEL_HAS_ERROR') == 'Y') {
									return false;
								}
							}*/
						}
						
					};
				if(cfg.useCheckbox) {
//					var sm = Ext.create('Ext.selection.CheckboxModel');
					var sm = Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false,
						/** Toggle between selecting all and deselecting all when clicking on
						 * a checkbox header.
						 * @private
						 */
						onHeaderClick: function(headerCt, header, e) {
							var me		= this,
								store	= me.store,
								column	= me.column,
								isChecked, records, i, len,
								selections, selection;
					
							if (me.showHeaderCheckbox !== false && header === me.column && me.mode !== 'SINGLE') {
								e.stopEvent();
								isChecked = header.el.hasCls(Ext.baseCSSPrefix + 'grid-hd-checker-on');
								selections = this.getSelection();
								// selectAll will only select the contents of the store, whereas deselectAll
								// will remove all the current selections. In this case we only want to
								// deselect whatever is available in the view.
								if (selections.length > 0) {
									records = [];
									selections = this.getSelection();
									for (i = 0, len = selections.length; i < len; ++i) {
										selection = selections[i];
										if (store.indexOf(selection) > -1) {
											records.push(selection);
										}
									}
									if (records.length > 0) {
										me.deselect(records);
									}
								} else {
									records = [];
									selections = store.data.items;
									for (i = 0, len = selections.length; i < len; ++i) {
										if( selections[i].get('_EXCEL_HAS_ERROR') != 'Y') {
											records.push(selections[i]);
										}
									}
									if (records.length > 0) {
										me.select(records);
									}
								}
							}
						}
					});
					Ext.apply(gridConfig, {selModel: sm});
				}
				
				if(cfg.listeners) {
					Ext.apply(gridConfig.listeners, cfg.listeners);
				}
				
				tabpanel.items.push(gridConfig);
			}	
			frm.baseParams = {
					excelConfigName: this.excelConfigName
			};
			this.items = [
				  frm,
				  tabpanel
			];
			
			this._setToolBar();
		} else {
			this.items = [{
					flex: 1,
					html: UniUtils.getMessage('system.message.commonJS.excel.invalidText','엑셀설정 정보를 확인해 주세요.')
			}]
		}

		me.callParent(arguments);
	}, // constructor
	initComponent: function(){ 
		this.callParent();
	},  // initComponent
	getTabPanel: function() {
		
	},
	uploadFile: function() {
		var me = this,
		frm = me.down('#uploadForm');
		frm.submit({
			params: me.extParam,
			waitMsg: 'Uploading...',
			success: function(form, action) {
				me.jobID = action.result.jobID;
				me.readGridData(me.jobID);
				me.down('tabpanel').setActiveTab(1);
				UniAppManager.updateStatus( UniUtils.getMessage('system.message.commonJS.excel.succesText','Upload 되었습니다.'));
			},
			failure: function(form, action) {
                Unilite.messageBox( UniUtils.getMessage('system.message.commonJS.occurError','서버에서 오류가 발생되었습니다'), action.result.msg,  CommonMsg.errorTitle.ERROR);
			}
			
		});
	},
	readGridData: function( jobId ) {
		var me = this;
		var param = {
			_EXCEL_JOBID: jobId
		}
		if (me.extParam) {
			param = Ext.apply(param, me.extParam);
		}
		
		for(i in this.grids) {
			var cfg = this.grids[i];
			var grid = me.down('#'+cfg.itemId);
			grid.getStore().load({
				params : param
			});
		}
		
	},
	
	onApply: Ext.emptyFn,
	
	_setToolBar: function() {
		var me = this;
		me.tbar = [
			{
				xtype: 'button',
				text : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'),
				tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'), 
				handler: function() { 
					me.jobID = null;
					me.uploadFile();
				}
			},
			{
				xtype: 'button',
				text : 'Read Data',
				tooltip : 'Read Data', 
				hidden: true,
				handler: function() { 
					if(me.jobID != null)	{
						me.readGridData(me.jobID);
						me.down('tabpanel').setActiveTab(1);
					} else {
						Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.requiredText','Upload된 파일이 없습니다.'))
					}
				}
			},
			{
				xtype: 'button',
				text : UniUtils.getLabel('system.label.commonJS.excel.btnApply','적용'),
				tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnApply','적용'), 
				handler: function() {
					var grids = me.down('grid');
					var isError = false;
					if(Ext.isDefined(grids.getEl()))	{
						grids.getEl().mask();
					}
					Ext.each(grids, function(grid,i){
						if(me.grids[0].useCheckbox) {
							var records = grid.getSelectionModel().getSelection();
						} else {
							var records = grid.getStore().data.items;
						}
//						var records = grid.getStore().data.items;
						return Ext.each(records, function(record,i){	
							if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
								console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
								isError = true;		
								return false;
							} 
						});
					}); 
					if(Ext.isDefined(grids.getEl()))	{
						grids.getEl().unmask();
					}
					if(!isError) {
						me.onApply();
				    }else {
				    	Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.rowErrorText',"에러가 있는 행은 적용이 불가능합니다."));
				    }
				}
			},
			'->',
			{
				xtype: 'button',
				text : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'),
				tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'), 
				handler: function() { 
					me.hide();
				}
			}
			
		]
	}
});

/**
 * Excel Template 파일을 다운로드 하는 Function
 * 
 * author : 박종영
 */
Ext.define('Unilite.com.excel.ExcelUpload', { 
	extend: 'Unilite.com.window.UniWindow',
	layout: {type:'vbox', align:'stretch'},

	requires: ['Unilite.com.grid.UniSimpleGridPanel'],
	
	border: 0,
	closable: false,
	width: 600,
	height: 520,
//	extParam: {},
	title: UniUtils.getLabel('system.label.commonJS.excel.templateTitle','엑셀 Template 업로드'),
	// excelConfigName: 'sof100',
	tbar: null,
	jobID:null,
	url : '/excel/upload.do',
	
	constructor : function(config) {
		var me = this;
		if (config) {
		  Ext.apply(me, config);
		};
		
		var frm = {
			xtype: 'uniDetailFormSimple',
			fileUpload: true,
			itemId: 'uploadForm',
			url: CPATH + me.url,
			layout:{type:'hbox', align:'stretch'},
			fileUpload: true,
			items : [ 
					
					 { 
						xtype: 'filefield',
						buttonOnly: false,
						fieldLabel: UniUtils.getLabel('system.label.commonJS.excel.fieldLabel','엑셀파일'),
						flex: 1,
						margin:5,
						name: 'excelFile',
//						id: 'excelFile',
						buttonText: UniUtils.getLabel('system.label.commonJS.excel.btnText','파일선택'),
						listeners: {
							change: function( filefield, value, eOpts )	{
									var fileExtention = value.substring(value.lastIndexOf("."));
									console.log("new file's extension is ",fileExtention);
									
							 } // change
						} // listeners
				   } // filefield
				]
		};
	 
		var sampleDownloadUrl01 = CPATH + "/fileman/exceldown/" + this.extParam.PGM_ID + "/xls";
		var sampleDownloadUrl02 = CPATH + "/fileman/exceldown/" + this.extParam.PGM_ID + "/xlsx";
		
		var tabpanel = {
			xtype: 'tabpanel',
			flex:1,
			
			items: [
				{
					title: 'Help',
					margin:5,
				  html: ' Sample #1(Excel 2003 format) : <a href="'+sampleDownloadUrl01+'"> ['+UniUtils.getLabel('system.label.commonJS.excel.downloadText','다운로드')+']</a>'+'<br/>'
					   +' Sample #2(Excel 2007 format) : <a href="'+sampleDownloadUrl02+'">['+UniUtils.getLabel('system.label.commonJS.excel.downloadText','다운로드')+']</a>'
				}
			]
		};
		
		if(this.excelConfigName) {
			for(i in this.grids) {
				var cfg = this.grids[i];
				var tColumns = [];
				var tStore = new Ext.data.DirectStore( {
					model: cfg.model,
					autoLoad: false,	
					sorters: [
							  {property: '_EXCEL_ERROR_MSG', direction : 'DESC'}, 
							  {property: '_EXCEL_ROWNUM'}
							  ],
					proxy: {
						type: 'direct',
						api: {
							read: cfg.readApi
						}
					}
				});
				var newColumns =  [
						{ dataIndex:'_EXCEL_ROWNUM', width: 50},
						{ dataIndex:'_EXCEL_ERROR_MSG', flex:1, minWidth: 100}
				];
				newColumns = newColumns.concat(cfg.columns);
				var gridConfig = {
						xtype: 'uniSimpleGridPanel',
						store: tStore,
						flex: 1,
						itemId: cfg.itemId,
						title: cfg.title,
						columns: newColumns,
						selType: 'rowmodel', 
						viewConfig: {
							emptyText: UniUtils.getMessage('system.message.commonJS.excel.emptyText','엑셀 파일을 Upload해주세요.'),
							deferEmptyText: false,
							getRowClass: function(record) { 
								if ( !Ext.isEmpty(record.get('_EXCEL_ERROR_MSG')) ) {
									return 'x-grid-excel-hasError';
								
								}
							} 
						},
						listeners:{
							/*beforeselect: function ( gridPanel, record, index, eOpts ) {
								if (record.get('_EXCEL_HAS_ERROR') == 'Y') {
									return false;
								}
							}*/
						}
						
					};
				if(cfg.useCheckbox) {
//					var sm = Ext.create('Ext.selection.CheckboxModel');
					var sm = Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false,
						/** Toggle between selecting all and deselecting all when clicking on
						 * a checkbox header.
						 * @private
						 */
						onHeaderClick: function(headerCt, header, e) {
							var me		= this,
								store	= me.store,
								column	= me.column,
								isChecked, records, i, len,
								selections, selection;
					
							if (me.showHeaderCheckbox !== false && header === me.column && me.mode !== 'SINGLE') {
								e.stopEvent();
								isChecked = header.el.hasCls(Ext.baseCSSPrefix + 'grid-hd-checker-on');
								selections = this.getSelection();
								// selectAll will only select the contents of the store, whereas deselectAll
								// will remove all the current selections. In this case we only want to
								// deselect whatever is available in the view.
								if (selections.length > 0) {
									records = [];
									selections = this.getSelection();
									for (i = 0, len = selections.length; i < len; ++i) {
										selection = selections[i];
										if (store.indexOf(selection) > -1) {
											records.push(selection);
										}
									}
									if (records.length > 0) {
										me.deselect(records);
									}
								} else {
									records = [];
									selections = store.data.items;
									for (i = 0, len = selections.length; i < len; ++i) {
										if( selections[i].get('_EXCEL_HAS_ERROR') != 'Y') {
											records.push(selections[i]);
										}
									}
									if (records.length > 0) {
										me.select(records);
									}
								}
							}
						}
					})
					Ext.apply(gridConfig, {selModel: sm});
				}
				
				if(cfg.listeners) {
					Ext.apply(gridConfig.listeners, cfg.listeners);
				}
				
				tabpanel.items.push(gridConfig);
			}   
			frm.baseParams = {
					excelConfigName: this.excelConfigName
			};
			this.items = [
				  frm,
				  tabpanel
			];
			
			this._setToolBar();
		} else {
			this.items = [{
					flex: 1,
					html: UniUtils.getMessage('system.message.commonJS.excel.invalidText','엑셀설정 정보를 확인해 주세요.')
			}]
		}

		me.callParent(arguments);
	}, // constructor
	initComponent: function(){ 
		this.callParent();
	},  // initComponent
	getTabPanel: function() {
		
	},
	uploadFile: function() {
		var me = this,
		frm = me.down('#uploadForm');
		if(Ext.isEmpty(frm.getValue('excelFile'))){
			Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.requiredText','선택된 파일이 없습니다.'));
			return false;	
		}
	 	frm.submit({
			params: me.extParam,
			waitMsg: 'Uploading...',
			success: function(form, action) {
				me.jobID = action.result.jobID;
				me.readGridData(me.jobID);
				me.down('tabpanel').setActiveTab(1);
				UniAppManager.updateStatus(UniUtils.getMessage('system.message.commonJS.excel.succesText','Upload 되었습니다.'));
			},
			failure: function(form, action) {
				Unilite.messageBox( UniUtils.getMessage('system.message.commonJS.occurError','서버에서 오류가 발생되었습니다'), action.result.msg,  CommonMsg.errorTitle.ERROR);
			}
			
		});
	},
	readGridData: function( jobId ) {
		var me = this;
		var param = {
			_EXCEL_JOBID: jobId
		}
		if (me.extParam) {
			param = Ext.apply(param, me.extParam);
		}
		
		for(i in this.grids) {
			var cfg = this.grids[i];
			var grid = me.down('#'+cfg.itemId);
			grid.getStore().load({
				params : param
			});
		}
		
	},
	
	onApply: Ext.emptyFn,
	
	_setToolBar: function() {
		var me = this;
		me.tbar = [
			{
				xtype: 'button',
				text : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'),
				tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'), 
				handler: function() { 
					me.jobID = null;
					me.uploadFile();
				}
			},
			{
				xtype: 'button',
				text : 'Read Data',
				tooltip : 'Read Data', 
				hidden: true,
				handler: function() { 
					if(me.jobID != null)	{
						me.readGridData(me.jobID);
						me.down('tabpanel').setActiveTab(1);
					} else {
						Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.requiredText','Upload된 파일이 없습니다.'))
					}
				}
			},
			{
				xtype: 'button',
				text : UniUtils.getLabel('system.label.commonJS.excel.btnApply','적용'),
				tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnApply','적용'), 
				handler: function() { 
					var grids = me.down('grid');
					var isError = false;
					if(Ext.isDefined(grids.getEl()))	{
						grids.getEl().mask();
					}
					Ext.each(grids, function(grid,i){
						if(me.grids[0].useCheckbox) {
							var records = grid.getSelectionModel().getSelection();
						} else {
							var records = grid.getStore().data.items;
						}
//						var records = grid.getStore().data.items;
						return Ext.each(records, function(record,i){	
							if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
								console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
								isError = true;	 
								return false;
							}
						});
					}); 
					if(Ext.isDefined(grids.getEl()))	{
						grids.getEl().unmask();
					}
					if(!isError) {
						me.onApply();
					}else {
						Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.rowErrorText',"에러가 있는 행은 적용이 불가능합니다."));
					}
				}
			},
			'->',
			{
				xtype: 'button',
				text : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'),
				tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'), 
				handler: function() { 
					me.hide();
				}
			}
			
		]
	}
});

/**
 * CSV 파일을 업로드 하는 Function
 * 
 * author : 박종영
 */
Ext.define('Unilite.com.excel.CSVUpload', { 
	extend: 'Unilite.com.window.UniWindow',
	layout: {type:'vbox', align:'stretch'},

	requires: ['Unilite.com.grid.UniSimpleGridPanel'],
	
	border: 0,
	closable: false,
	width: 600,
	height: 90,
	extParam: {},
	title: UniUtils.getLabel('system.label.commonJS.excel.csvTtitle','CSV 파일 업로드'),
	// excelConfigName: 'sof100',
	tbar: null,
	fileExtention:null,
	fileIds:null,
	
	constructor : function(config) {
		var me = this;
		if (config) {
		  Ext.apply(me, config);
		};
		
		var frm = {
			xtype: 'uniDetailFormSimple',
			fileUpload: true,
			itemId: 'uploadForm',
			url: CPATH+'/fileman/csvupload.do',
			layout:{type:'hbox', align:'stretch'},
			fileUpload: true,
			items : [ 
					 { 
	 					xtype: 'filefield',
	 					buttonOnly: false,
	 					fieldLabel: UniUtils.getLabel('system.label.commonJS.excel.csvFieldLabel','CSV 파일'),
	 					flex: 1,
	 					margin:5,
	 					name: 'excelFile',
	 					id:'excelFile',
	 					buttonText: UniUtils.getLabel('system.label.commonJS.excel.btnText','파일선택'),
	 					listeners: {
	 						change: function( filefield, value, eOpts )	{
	 							 me.fileExtention = value.substring(value.lastIndexOf(".") + 1);
	 							 console.log("new file's extension is ", me.fileExtention);
	 							 if( me.fileExtention != 'csv') {
	 								 Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.csvInvalidText','csv 파일이 아닙니다.'));
	 								 me.fileExtention = null;
	 							 }
	 						 } // change
	 					} // listeners
				   } // filefield
	 			]
		};

		this.items = [
			  frm
		];
		
		this._setToolBar();

		me.callParent(arguments);
	}, // constructor
	initComponent: function(){ 
		this.callParent();
	},  // initComponent
	getTabPanel: function() {
		
	},
	uploadFile: function() {
		var me = this,
		frm = me.down('#uploadForm');
		frm.submit({
			params: me.extParam,
			waitMsg: 'Uploading...',
			success: function(form, action) {
				me.fileIds = action.result.fid;	 // 배열로 넘어온다.
				//console.log("ExcelUploadWin.js > csv 파일 업로드 성공 :: " + action.result.fileIds);
				//Ext.Msg.alert('Success', 'Upload 되었습니다.');
				me.hide();
			},
			failure: function(form, action) {
				Unilite.messageBox( UniUtils.getMessage('system.message.commonJS.occurError','서버에서 오류가 발생되었습니다'), action.result.msg,  CommonMsg.errorTitle.ERROR);
			}
		});
	},
	
	onApply: Ext.emptyFn,
	
	_setToolBar: function() {
		var me = this;
		me.tbar = [
			{
				xtype: 'button',
				text : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'),
				tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'), 
				handler: function() { 
					
					if(Ext.isEmpty(Ext.getCmp('excelFile').getValue())){
						Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.requiredText','선택된 파일이 없습니다.'));
						return false;	
					}
					if( me.fileExtention != 'csv') {
						Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.csvInvalidText','csv 파일이 아닙니다.'));
						return false;
					}

					me.fileIds = null;
					me.fileExtention = null;
					
					me.uploadFile();
				}
			},
			'->',   // 업로드버튼과 닫기 버튼을 양쪽으로 분배한다.
			{
				xtype: 'button',
				text : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'),
				tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'), 
				handler: function() { 
					me.hide();
				}
			}
			
		]
	}
});





/**
 * TEXT 파일을 업로드 하는 Function
 * 
 * author : 정동원
 */
Ext.define('Unilite.com.excel.TXTUpload', { 
	extend: 'Unilite.com.window.UniWindow',
	layout: {type:'vbox', align:'stretch'},

	requires: ['Unilite.com.grid.UniSimpleGridPanel'],
	
	border: 0,
	closable: false,
	width: 600,
	height: 90,
	extParam: {},
	title: UniUtils.getLabel('system.label.commonJS.excel.textTtitle','TEXT 파일 업로드'),
	// excelConfigName: 'sof100',
	tbar: null,
	fileExtention:null,
	fileIds:null,
	
	constructor : function(config) {
		var me = this;
		if (config) {
		  Ext.apply(me, config);
		};
		
		var frm = {
			xtype: 'uniDetailFormSimple',
			fileUpload: true,
			itemId: 'uploadForm',
			url: CPATH+'/fileman/txtupload.do',
			layout:{type:'hbox', align:'stretch'},
			fileUpload: true,
			items : [ 
					 { 
	 					xtype: 'filefield',
	 					buttonOnly: false,
	 					fieldLabel: UniUtils.getLabel('system.label.commonJS.excel.textFieldLabel','TEXT 파일'),
	 					flex: 1,
	 					margin:5,
	 					name: 'excelFile',
	 					id:'excelFile',
	 					buttonText: UniUtils.getLabel('system.label.commonJS.excel.btnText','파일선택'),
	 					listeners: {
	 						change: function( filefield, value, eOpts )	{
	 							 me.fileExtention = value.substring(value.lastIndexOf(".") + 1);
	 							 console.log("new file's extension is ", me.fileExtention);
	 							 if( me.fileExtention != 'txt') {
	 								 Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.textInvalidText','text 파일이 아닙니다.'));
	 								 me.fileExtention = null;
	 							 }
	 						 } // change
	 					} // listeners
				   } // filefield
	 			]
		};

		this.items = [
			  frm
		];
		
		this._setToolBar();

		me.callParent(arguments);
	}, // constructor
	initComponent: function(){ 
		this.callParent();
	},  // initComponent
	getTabPanel: function() {
		
	},
	uploadFile: function() {
		var me = this,
		frm = me.down('#uploadForm');
		frm.submit({
			params: me.extParam,
			waitMsg: 'Uploading...',
			success: function(form, action) {
				me.fileIds = action.result.fid;	 // 배열로 넘어온다.
				//console.log("ExcelUploadWin.js > text 파일 업로드 성공 :: " + action.result.fileIds);
				//Ext.Msg.alert('Success', 'Upload 되었습니다.');
				me.hide();
			},
			failure: function(form, action) {
				Unilite.messageBox( UniUtils.getMessage('system.message.commonJS.occurError','서버에서 오류가 발생되었습니다'), action.result.msg,  CommonMsg.errorTitle.ERROR);
			}
		});
	},
	
	onApply: Ext.emptyFn,
	
	_setToolBar: function() {
		var me = this;
		me.tbar = [
			{
				xtype: 'button',
				text : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'),
				tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'), 
				handler: function() { 
					
					if(Ext.isEmpty(Ext.getCmp('excelFile').getValue())){
						Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.requiredText','선택된 파일이 없습니다.'));
						return false;	
					}
					if( me.fileExtention != 'txt') {
					  Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.textInvalidText','text 파일이 아닙니다.'));
						return false;
					}

					me.fileIds = null;
					me.fileExtention = null;

					me.uploadFile();
				}
			},
			'->',   // 업로드버튼과 닫기 버튼을 양쪽으로 분배한다.
			{
				xtype: 'button',
				text : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'),
				tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'), 
				handler: function() { 
					me.hide();
				}
			}
			
		]
	}
});