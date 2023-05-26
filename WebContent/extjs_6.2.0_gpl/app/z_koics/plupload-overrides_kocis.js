//@charset UTF-8
/**
 * ExtJS OmegaPlus plupload 컴포넌트 overrrides
 */
 
Ext.override(Unilite.com.panel.UploadPanel, {
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
				}, 
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
		        	header: '삭제',
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
								
					}) 
    ]
		}];
		
		
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
							text:"속도",
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
							text:"남은시간",
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
		}; 
		
		me.callParent(arguments);// 더블클릭 on Cell
        this.on('celldblclick', this._onCellDblClickFun);
	}
});