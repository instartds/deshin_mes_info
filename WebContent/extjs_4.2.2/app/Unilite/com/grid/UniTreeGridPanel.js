//@charset UTF-8
/**
 * 
 * Unilit용 표준 TreeGrid 셋업.
 * 
 * Grid 기본설정
 * - 설정상태 저장 기능(id 값이 필수로 지정 되어야 함 !) : 
 *   . 2013017 : cookie에 저장
 * - tooltip 지원
 * - model과 연동 
 *   
 * column 속성 확장
 * - tooltip : true : tooltip 보이게 
 */
 
 

Ext.define('Unilite.com.grid.UniTreeGridPanel', {
	extend: 'Ext.tree.Panel',
	alias: 'widget.uniTreeGridPanel',
	require:[
		'Ext.grid.plugin.CellEditing',
		'Unilite.com.grid.column.UniPriceColumn',
		'Unilite.com.grid.column.UniDateColumn',
    	'Unilite.com.UniAppManager',
    	'Unilite.UniDate'
	],
	 mixins: {
	 	gutil: 'Unilite.com.grid.UniAbstractGridPanel'
	 },
		
    xtype: 'tree-grid',
    rootVisible: false,
	/**
	 * 
	 * @property {Object} uniOpt
     * @readonly 
     * 
     * Unilite용 확장 속성을 저장하는 객체
     * 
     *     - currentRecord : grid에서 현재 수정중인 record (popup등에서 사용)
     *     - childForms : 현재 grid에 딸린 form
	 */
	uniOpt:{},
	/**
	 * 생성 가능한 최대 깊이
	 * @cfg(Number) maxDepth
	 */
	maxDepth : 4,
	
	/**
	 * grid 설정 상태 저장을 위한 설정
	 * 
	 * @cfg Boolean
	 */
	stateful: true,
	stateEvents: ['columnresize', 'columnmove', 'show', 'hide'],
	// 화면 layout 에서 grid부분을 자동으로 꽉 채우게
	flex:1,
	// column에 대한 기본값 속성 설정 
	columnDefaults : {
		// Column의 기본 속성 설정
		style : 'text-align:center'
		//,menuDisabled:true
		,margin :'0 0 0 0'
		,sortable:true
	},
	//selType: 'rowmodel', // row 단위로 선택 됨. 단 lockmode 에서 수정시 오류 발생 함.
	selType: 'cellmodel',  // cell 단위로 선택됨 
	
	// check 박스를 통해 row를 select 할 경우 
	//selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : false }), 
	selModel: {
            pruneRemoved: false // store에서 buffer 사용시 false로 해야 함.
    },
	viewConfig : {
		loadMask: true,
		trackOver: true,		// 
		stripeRows: true		//
//		selectedItemCls : 'GRID_ROW_SELECTED',			// checkbox랑 충돌 at 2014.2.27
//		focusedItemCls : 'GRID_ROW_FOCUSED'
	},
	sortableColumns : true,
	columnLines : true,
	
	/**
	 * 
	 * @param {} config
	 */
	constructor : function(config){    
        var me = this;
        
        if(!Ext.isDefined(config.plugins)) {
			config.plugins = new Array();		
		}
		if(!Ext.isDefined(config.features)) {
			config.features = new Array();		
		}
		
	
		
		var uniOpt = config.uniOpt || {};
		Ext.apply(uniOpt, {'childForms': new Array()}); 
		config.uniOpt = uniOpt;
		
		if (config) {
            Ext.apply(me, config);
        }
        
        this.callParent([config]);
	}, 
	
	/**
	 * 
	 */
	initComponent : function() {
		UniAppManager.register(this);
		var me = this;

		var mStore = Ext.data.StoreManager.lookup(me.getStore());
		
		if (this.mixins.gutil._getStoreEditable(me)) {
			this.editing  = this.mixins.gutil.getEditor(me);
			if(!Ext.isDefined(this.plugins)) {
				this.plugins = new Array();		
			}
			this.plugins.push(this.editing);
			this.enableLocking = false;
		} else {
			
		}
		
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
		this.callParent(arguments);
		
		
		// keyDown on Cell
		/*
        this.on('cellkeydown', function(viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts) {
        	me.mixins.gutil.onCellKeyDownFun(me, viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts);
        })
        */

	},
	/**
	 * 새로운 행을 추가 하고 편집을 시작 한다.(Tree용으로 새로 개발 필요 !!)
	 * @param {} record
	 * @param {} startEditColumnName
	 * @param {} rowIndex
	 * @return {}
	 */
	createRow:function( values, startEditColumnName, rowIndex) {
		var selModel = this.getSelectionModel();
		// Could also use:
        // var node = selModel.getSelection()[0];
        var node = selModel.getLastSelected();

        if (!node) {
            return;
        }
		if(node.getDepth() > this.maxDepth) {
			var msg = "단계초과 최대 깊이 = " + this.maxDepth;
			console.log(msg);
			UniAppManager.updateStatus(msg, true);			
			node = node.parentNode;
			//return;
		}
        // Feels like this should happen automatically
        node.set('leaf', false);

		var newRecord =  Ext.create (this.store.model, values);
		//newRecord.set('TREE_NAME', "new")
        newRecord.set('leaf', true);
        node.appendChild(newRecord);

        // The tree lines won't join up without a refresh
       // tree.getView().refresh();

        // Not strictly required but...
        node.expand();
        return newRecord;
                
	},
	
	/**
	 * 그리드 데이타 초기화 (Store 포함)
	 */
	reset:function() {
		//this.store.loadRecords({}, {addRecords: false});
		this.store.load(); 
		this.view.refresh();
	},
	/**
	 * 선택된 row들을 삭제 한다.
	 */
	deleteSelectedRow:function() {
		var sm = this.getSelectionModel();
		var store = this.getStore();
		var selected = sm.getSelection();
		//selected[0].remove();
		
		this.deleteNode(selected);
	}
	,deleteNode: function (nodes) {
		var me = this;
		/*  for loop안에서 요소를 삭제하면 이가 빠지면서 삭제됨 
		 * Ext.each(nodes, function(node, index) {
			console.log(nodes.length + " / " + index + ". " + node);
			if(node) {
				if(node.hasChildNodes()) {
					me.deleteNode(node.childNodes);
				};
				node.remove();
			} 
		});
		*/
		var check = true;
		do{
		  var node = nodes[0];
		  if(node) {
				if(node.hasChildNodes()) {
					me.deleteNode(node.childNodes);
				};
				console.log(nodes.length + " / " +  node.get('TREE_NAME'));
				if(node.parentNode == null) {
					check = false;
				}
				node.remove();
			}
		}while (nodes.length > 0 && check);
	},
	uniSelectInvalidColumnAndAlert:function(invalidRecords) {
		var invalidRec = Ext.isArray(invalidRecords) ? invalidRecords[0] : invalidRecords;
		
		var me = this;
		var fields = me.getStore().model.getFields();

		var errors = invalidRec.validate();
		var column ;
		if(errors.items) {
			column = errors.items[0].field;
		} else {
			console.log('찾아갈 오류내용(column) 없음');
		}
		
		var msg = '';
		errors.items.forEach(function(entry) {
			var field = me._getField(fields, entry.field);
			msg = msg + field.text + ': ' + entry.message + '\n';
		});		
		//alert(msg + Msg.sMB083);
		msg = '입력행의 입력값을 확인해 주세요.\n' + msg ;
		//UniAppManager.updateStatus(msg);
		alert(msg);
	}
});//  UniTreeGridPanel