//@charset UTF-8



Ext.define('Unilite.com.grid.UniSimpleGridPanel', {
	extend : 'Ext.grid.Panel',
	alias : 'widget.uniSimpleGridPanel',
	margin: '1 1 1 1',
	//split:{size: 1},
	split: false, //5.1.0
	mixins: {
		 	gutil: 'Unilite.com.grid.UniAbstractGridPanel'
	},
	columnDefaults : {
		// Column의 기본 속성 설정
		style : 'text-align:center',
		//,menuDisabled:true
		margin :'0 0 0 0',
		sortable: true
	},
	viewConfig : {
		shrinkWrap: 1, //3, //default:2
		enableTextSelection: true, 	// default : false
		loadMask: true,
		trackOver: true,		// 
		stripeRows: true		// 겹줄표시
	},
	sortableColumns : false,
	columnLines : true,
	uniOpt:{},
	/**
	 * 
	 * @param {} config
	 */
	constructor : function(config){    
        var me = this;
       		
        if (config) {
            Ext.apply(me, config);
        }
        

        this.callParent([config]);
	}, // constructor
	/**
	 * 
	 */
	initComponent : function() {
		UniAppManager.register(this);
		var me = this;
		
		var mStore = Ext.data.StoreManager.lookup(me.getStore());
		var model = mStore.model;
		var fields;
		if (model) {
			fields = model.getFields();
		}
		
		if(Ext.isArray(me.columns)) {
			
			for (var i = 0, len = me.columns.length; i < len; i++) {
				this.mixins.gutil.setColumnInfo(me, me.columns[i], fields );
			}
		} else {
			console.error("ERROR !!! please define columns");
		}
		//me.columns.push();
		
		this.callParent(arguments);
	}  // initComponent
});