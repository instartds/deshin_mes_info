//@charset UTF-8

Ext.define('Unilite.Excel', {
    singleton: true,
    defineModel: function (id, config) {
		var baseFields = [
	        {name: '_EXCEL_ROWNUM',  text:'행' , type: 'int'},
	        {name: '_EXCEL_ERROR_MSG', text:'오류' , type:'string'},
	        {name: '_EXCEL_HAS_ERROR', text:'오류여부' , type:'string', hidden: true}
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
    title: '엑셀 업로드',
    // excelConfigName: 'sof100',
    tbar: null,
    jobID:null,
    
	constructor : function(config) {
		var me = this;
		if (config) {
		  Ext.apply(me, config);
		};
		
		var frm = {
			xtype: 'uniDetailFormSimple',
        	fileUpload: true,
        	itemId: 'uploadForm',
        	url: CPATH+'/excel/upload.do',
        	layout:{type:'hbox', align:'stretch'},
	    	fileUpload: true,
        	items : [ 
     				
                     { 
     	                xtype: 'filefield',
     	                buttonOnly: false,
     	                fieldLabel: '엑셀파일',
     	                flex: 1,
     	                margin:5,
     	                name: 'excelFile',
     	                buttonText: '파일선택',
     	                listeners: {
     	                    change: function( filefield, value, eOpts )    {
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
		        	html: ' Sample #1(Excel 2003 format) : <a href="'+sampleDownloadUrl+'?type=xls"> [다운로드]</a>'+'<br/>'
		        		+' Sample #2(Excel 2007 format) : <a href="'+sampleDownloadUrl+'?type=xlsx">[다운로드]</a>'
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
			                emptyText: '엑셀 파일을 Upload해주세요.',
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

					var sm = Ext.create('Ext.selection.CheckboxModel');
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
					html: '엑셀설정 정보를 확인해 주세요.'
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
				Ext.Msg.alert('Success', 'Upload 되었습니다.');
			},
            failure: function(form, action) {
                Ext.Msg.alert('Failed', action.result.msg);
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
				text : '업로드',
				tooltip : '업로드', 
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
						alert('Upload된 파일이 없습니다.')
					}
				}
			},
			{
				xtype: 'button',
				text : '적용',
				tooltip : '적용', 
				handler: function() { 
					var grids = me.down('grid');
					var isError = false;
					if(Ext.isDefined(grids.getEl()))	{
						grids.getEl().mask();
					}
					Ext.each(grids, function(grid,i){	
			        	var records = grid.getStore().data.items;
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
				    	alert("에러가 있는 행은 적용이 불가능합니다.");
				    }
				}
			},
			'->',
			{
				xtype: 'button',
				text : '닫기',
				tooltip : '닫기', 
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
//    extParam: {},
    title: '엑셀 Template 업로드',
    // excelConfigName: 'sof100',
    tbar: null,
    jobID:null,
    
    constructor : function(config) {
        var me = this;
        if (config) {
          Ext.apply(me, config);
        };
        
        var frm = {
            xtype: 'uniDetailFormSimple',
            fileUpload: true,
            itemId: 'uploadForm',
            url: CPATH+'/excel/upload.do',
            layout:{type:'hbox', align:'stretch'},
            fileUpload: true,
            items : [ 
                    
                     { 
                        xtype: 'filefield',
                        buttonOnly: false,
                        fieldLabel: '엑셀파일',
                        flex: 1,
                        margin:5,
                        name: 'excelFile',
                        id: 'excelFile',
                        buttonText: '파일선택',
                        listeners: {
                            change: function( filefield, value, eOpts )    {
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
                  html: ' Sample #1(Excel 2003 format) : <a href="'+sampleDownloadUrl01+'"> [다운로드]</a>'+'<br/>'
                       +' Sample #2(Excel 2007 format) : <a href="'+sampleDownloadUrl02+'">[다운로드]</a>'
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
                            emptyText: '엑셀 파일을 Upload해주세요.',
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

                    var sm = Ext.create('Ext.selection.CheckboxModel');
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
                    html: '엑셀설정 정보를 확인해 주세요.'
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
		if(Ext.isEmpty(Ext.getCmp('excelFile').getValue())){
			alert('선택된 파일이 없습니다.');
			return false;	
		}
     	frm.submit({
            params: me.extParam,
            waitMsg: 'Uploading...',
            success: function(form, action) {
                me.jobID = action.result.jobID;
                me.readGridData(me.jobID);
                me.down('tabpanel').setActiveTab(1);
                Ext.Msg.alert('Success', 'Upload 되었습니다.');
            },
            failure: function(form, action) {
                Ext.Msg.alert('Failed', action.result.msg);
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
                text : '업로드',
                tooltip : '업로드', 
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
                    if(me.jobID != null)    {
                        me.readGridData(me.jobID);
                        me.down('tabpanel').setActiveTab(1);
                    } else {
                        alert('Upload된 파일이 없습니다.')
                    }
                }
            },
            {
                xtype: 'button',
                text : '적용',
                tooltip : '적용', 
                handler: function() { 
                    var grids = me.down('grid');
                    var isError = false;
                    if(Ext.isDefined(grids.getEl()))    {
                        grids.getEl().mask();
                    }
                    Ext.each(grids, function(grid,i){   
                        var records = grid.getStore().data.items;
                        return Ext.each(records, function(record,i){    
                            if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
                                console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
                                isError = true;     
                                return false;
                            }
                        });
                    }); 
                    if(Ext.isDefined(grids.getEl()))    {
                        grids.getEl().unmask();
                    }
                    if(!isError) {
                        me.onApply();
                    }else {
                        alert("에러가 있는 행은 적용이 불가능합니다.");
                    }
                }
            },
            '->',
            {
                xtype: 'button',
                text : '닫기',
                tooltip : '닫기', 
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
    title: 'CSV 파일 업로드',
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
     	                fieldLabel: 'CSV 파일',
     	                flex: 1,
     	                margin:5,
     	                name: 'excelFile',
     	                id:'excelFile',
     	                buttonText: '파일선택',
     	                listeners: {
     	                    change: function( filefield, value, eOpts )    {
     	                         me.fileExtention = value.substring(value.lastIndexOf(".") + 1);
     	                         console.log("new file's extension is ", me.fileExtention);
     	                         if( me.fileExtention != 'csv') {
     	                             alert('csv 파일이 아닙니다.');
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
				me.fileIds = action.result.fid;     // 배열로 넘어온다.
				//console.log("ExcelUploadWin.js > csv 파일 업로드 성공 :: " + action.result.fileIds);
				//Ext.Msg.alert('Success', 'Upload 되었습니다.');
				me.hide();
			},
            failure: function(form, action) {
                Ext.Msg.alert('Failed', action.result.msg);
            }
		});
	},
	
	onApply: Ext.emptyFn,
	
	_setToolBar: function() {
		var me = this;
		me.tbar = [
			{
				xtype: 'button',
				text : '업로드',
				tooltip : '업로드', 
				handler: function() { 
					
					if(Ext.isEmpty(Ext.getCmp('excelFile').getValue())){
						alert('선택된 파일이 없습니다.');
						return false;	
					}
                    if( me.fileExtention != 'csv') {
                        alert('csv 파일이 아닙니다.');
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
				text : '닫기',
				tooltip : '닫기', 
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
    title: 'TEXT 파일 업로드',
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
     	                fieldLabel: 'TEXT 파일',
     	                flex: 1,
     	                margin:5,
     	                name: 'excelFile',
     	                id:'excelFile',
     	                buttonText: '파일선택',
     	                listeners: {
     	                    change: function( filefield, value, eOpts )    {
     	                         me.fileExtention = value.substring(value.lastIndexOf(".") + 1);
     	                         console.log("new file's extension is ", me.fileExtention);
     	                         if( me.fileExtention != 'txt') {
     	                             alert('text 파일이 아닙니다.');
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
				me.fileIds = action.result.fid;     // 배열로 넘어온다.
				//console.log("ExcelUploadWin.js > text 파일 업로드 성공 :: " + action.result.fileIds);
				//Ext.Msg.alert('Success', 'Upload 되었습니다.');
				me.hide();
			},
            failure: function(form, action) {
                Ext.Msg.alert('Failed', action.result.msg);
            }
		});
	},
	
	onApply: Ext.emptyFn,
	
	_setToolBar: function() {
		var me = this;
		me.tbar = [
			{
				xtype: 'button',
				text : '업로드',
				tooltip : '업로드', 
				handler: function() { 
					
					if(Ext.isEmpty(Ext.getCmp('excelFile').getValue())){
						alert('선택된 파일이 없습니다.');
						return false;	
					}
                    if( me.fileExtention != 'txt') {
                        alert('text 파일이 아닙니다.');
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
				text : '닫기',
				tooltip : '닫기', 
				handler: function() { 
					me.hide();
				}
			}
			
		]
	}
});