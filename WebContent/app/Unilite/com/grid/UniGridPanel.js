//@charset UTF-8
/**
 * 
 * Unilit용 표준 Grid 셋업.
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


Ext.define('Unilite.com.grid.UniGridPanel', {
	extend : 'Ext.grid.Panel',
	alias : 'widget.uniGridPanel',
	alternateClassName: 'Unilite.UniGridPanel',
	margin: '1 1 1 1',
	split:{size: 1},
	requires: [
		'Ext.grid.plugin.CellEditing',
		'Ext.ux.BoxReorderer',
		'Ext.ux.ToolbarDroppable',
		'Ext.toolbar.TextItem',
        'Ext.form.field.Checkbox',
        'Ext.ux.statusbar.StatusBar'	,
        //'Unilite.com.form.field.UniTextField',
		'Unilite.com.grid.column.UniPriceColumn',
		'Unilite.com.grid.column.UniDateColumn',
		'Unilite.com.grid.column.UniTimeColumn',
    	'Unilite.com.UniAppManager',
    	'Unilite.UniDate',
    	'Unilite.com.grid.UniGridMultiSorter'
	],
	 mixins: {
	 	gutil: 'Unilite.com.grid.UniAbstractGridPanel',
	 	search: 'Unilite.com.grid.UniGridLiveSearch'
	 },
	//formBind: true,		// true로 form 안에 grid가 disabled되는 경우 발생 
	
	/**
	 * 
	 * @property {Object} uniOpt
     * @readonly 
     * 
     * Unilite용 확장 속성을 저장하는 객체
     * 
     *     - currentRecord : grid에서 현재 수정중인 record (popup등에서 사용)
     *     - childForms : 현재 grid에 딸린 form
     *     - expandLastColumn :
     *     - useRowNumberer : 좌측에 row number 자동 부여 및 lock
     *     - useMultipleSorting : 
	 */
	uniOpt:{
		//column option--------------------------------------------------
		expandLastColumn: true,
		useRowNumberer: true,		//번호 컬럼 사용 여부		
		filter: {
			useFilter: false,		//컬럼 filter 사용 여부
			autoCreate: true		//컬럼 필터 자동 생성 여부
		},
		//toolbar option--------------------------------------------------
		useGroupSummary: false,		//그룹핑 버튼 사용 여부
		useMultipleSorting: false,	//정렬 버튼 사용 여부
		useLiveSearch: false,		//내용검색 버튼 사용 여부		
		state: {
			useState: true,			//그리드 설정 버튼 사용 여부
			useStateList: true		//그리드 설정 목록 사용 여부
		},
		excel: {
			useExcel: true,			//엑셀 다운로드 사용 여부
			exportGroup : false		//group 상태로 export 여부
		},
		//grid row&cell option--------------------------------------------
		useContextMenu: false,		//Context 메뉴 자동 생성 여부 
		copiedRow: null	,
		onLoadSelectFirst: true,
		
		_selectionRecord: {			//selectionChangeRecord event에서 사용됨
			oldRecordId:'',
			newRecordId:''
		}
	},
	uniText: {
		sortingBar: {
			btnSort: '정렬',
			sortingOrder: '정렬순서',
			dragAndDropHelp: '이곳에 필드명을 가져다 놓으세요.'
		},
		groupingBar: {
			btnGroup: '그룹핑',
			groupColumn: '그룹항목',
			dragAndDropHelp: '이곳에 필드명을 가져다 놓으세요.'
		},
		searchBar: {
			btnFind: '내용검색',
			searchColumn: '내용검색',
			emptyText: '검색어를 입력하세요.',
			btnPrev: '이전 찾기',
			btnNext: '다음 찾기'
		},
		btnSummary: '합계표시',
		btnExcel: '엑셀 다운로드',
		columns: {
			etc: '*'
		},
		contextMenu: {
			rowCopy: '행 복사',
			rowPaste: '복사한 행 삽입'
		}
	},
	/**
	 * grid 설정 상태 저장을 위한 설정
	 * 
	 * @cfg Boolean
	 */
	stateful: true,
	stateEvents: ['columnresize', 'columnmove', 'show', 'hide'],
	// 화면 layout 에서 grid부분을 자동으로 꽉 채우게
	flex: 1,
	// column에 대한 기본값 속성 설정 
	columnDefaults : {
		// Column의 기본 속성 설정
		style : 'text-align:center',
		//,menuDisabled:true
		margin :'0 0 0 0',
		sortable: true
	},
//	plugins: {'bufferedrenderer'},
	plugins: [
		{	 
        	ptype: 'bufferedrenderer',
        	pluginId: 'bufferedrenderer',
        	trailingBufferZone: 20,  // Keep 20 rows rendered in the table behind scroll
			leadingBufferZone: 50
		}
	],
	selType: 'rowmodel', // row 단위로 선택 됨. 단 lockmode 에서 수정시 오류 발생 함.
	//selType: 'cellmodel',  // cell 단위로 선택됨, 단 조회용의 경우(store가 editable false의경우) rowmodel
	
	// check 박스를 통해 row를 select 할 경우 
	//selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : false }), 
	selModel: {
            pruneRemoved: false // store에서 buffer 사용시 false로 해야 함.
    },
    viewConfig : {
		shrinkWrap: 1 //3, 				//default: 2
		,enableTextSelection: true 		//default: false
		,loadMask: true					//default: true
		//trackOver: true,				//default: false 
		//stripeRows: true				//default: true 겹줄표시		
		//,selectedItemCls : 'GRID_ROW_SELECTED'			// checkbox랑 충돌 at 2014.2.27
		//focusedItemCls : 'GRID_ROW_FOCUSED'
	},
	sortableColumns : true,
	columnLines : true,
	
	/**
	 * 
	 * @param {} config
	 */
	constructor : function(config){    
        var me = this;
       	
        //config: create 시에 설정한 config
        
//        if (config) {
//            Ext.apply(me, config);
//        }
        var uniOpt = me.uniOpt;
        if(config) {
        	Ext.apply(uniOpt, {'childForms': new Array()}); 
        	// if recursive merging and cloning is need, use Ext.Object.merge instead.
        	// Ext.apply 는 merge 하지 않고 overwrite 함.        	     
        	if(config.uniOpt) {        		
        		uniOpt = config.uniOpt = Ext.Object.merge(uniOpt, config.uniOpt);
        	}
			
			if(uniOpt.expandLastColumn) {
				var bigoConfig = {text: this.uniText.columns.etc,	flex: 1, minWidth:120, 
										resizable: false, hideable:false, sortable:false, lockable:false,
										menuDisabled: true, draggable: false
				};
				//config.columns.push(bigoConfig);
				config.columns = Ext.Array.push(config.columns, bigoConfig);
			}
        	
        	Ext.apply(me, config);
        }
        
//        if(!Ext.isDefined(config.plugins)) {
//			config.plugins = new Array();		
//		}
		if(!Ext.isDefined(config.features)) {
			config.features = new Array();		
		}
		
        // bufferedrenderer plugin config
//        var bufferedPlugin = {	 
//        	ptype: 'bufferedrenderer',
//        	pluginId: 'bufferedrenderer',
//			trailingBufferZone: 20,  // Keep 20 rows rendered in the table behind scroll
//			leadingBufferZone: 20
//		}; 
//		config.plugins.push(bufferedPlugin);
		
		// filter
		if(Ext.isDefined(me.uniOpt.filter) && me.uniOpt.filter.useFilter) {

			var filtersCfg = 
			{
				id : 'masterGridFilters',
				ftype : 'filters',
			    local: 'true',
			    encode: false
			};

			if(this.uniOpt.filter.autoCreate) {
				var fieldName, filter, filterType;
				
				filtersCfg.filters = [];
				for (var column in config.columns) {
				    fieldName = config.columns[column].dataIndex;
				    filter = config.columns[column].filter;
				    if (fieldName) 
				    {
				    	if(filter) {
				    		filterType= filter.type;	
				    	} else {
					    	filterType = this.getColumnFilterType( this.getModelField(fieldName).type.type );
				    	}
	
				        filtersCfg.filters.push(
				        {
				            dataIndex: fieldName,
				            type: filterType
				        });
				    }
				}
			}

			config.features.push(filtersCfg);
		}
		
		// 편집모드의 경우
		if(config.store && config.store.uniOpt && config.store.uniOpt.editable) {
			config.selType= 'rowmodel';
			Ext.apply(config, {selType: 'rowmodel'} );
			
			Ext.apply(me.viewConfig, {enableTextSelection: false} ); //(true로 하면 Chrome 에서 에디팅모드 시 셀에 잔상이 보여지다 사라지는 문제가 있음.)
		}
		
		/*var uniOpt = this.uniOpt || {};
		Ext.apply(uniOpt, config.uniOpt );
		Ext.apply(uniOpt, {'childForms': new Array()}); 
		config.uniOpt = uniOpt;
		
		if(uniOpt.expandLastColumn) {
			var bigoConfig = {text: this.uniText.columns.etc,	flex: 1, minWidth:120, 
									resizable: false, hideable:false, sortable:false, lockable:false,
									menuDisabled: true, draggable: false
			};
			//config.columns.push(bigoConfig);
			config.columns = Ext.Array.push(config.columns, bigoConfig);
		}
		if (config) {
            Ext.apply(me, config);
        }*/
        
		me.addEvents(
			/**
			 * Unilite용 추가 Event
			 * @event onGridDblClick
			 * @param grid
			 * @param record
			 * @param cellIndex
			 * @param colName
			 */
			'onGridDblClick',
			'onGridKeyDown',
			'statelistchange',
			'statelistselect',
			'beforePasteRecord',
			'afterPasteRecord',
			'selectionchangerecord'
		);
        this.callParent([config]);
	}, 
	
	/**
	 * 
	 */
	initComponent : function() {
		var me = this;
		
		UniAppManager.register(this);

		//edit grid 인 경우 
		if (this.mixins.gutil._getStoreEditable(me)) {
			this.editing  = this.mixins.gutil.getEditor(me);
			if(!Ext.isDefined(this.plugins)) {
				this.plugins = new Array();		
			}
			this.plugins.push(this.editing);
			
			this.enableLocking = false;			
			this.uniOpt.state.useState = false;
			this.uniOpt.state.useStateList = false;
			
		} else {
			//console.log("Grid readonly");
			//this.selType =  'rowmodel';
		}
		
		var mStore = Ext.data.StoreManager.lookup(me.getStore());
		var model = mStore.model;
		var fields;
		if (model) {
			fields = model.getFields();
		}
		if(Ext.isArray(me.columns)) {
			if(this.uniOpt.useRowNumberer) {
				if(this.selModel && Ext.getClassName(this.selModel) !=	"Ext.selection.CheckboxModel") {
					var rNum = {
						xtype: 'rownumberer', 
						sortable:false, 
						locked: true, 
						width: 35,
						align:'center  !important',
						resizable: true
					};
					me.columns = Ext.Array.insert(me.columns,0, [rNum]);
				}
			}
			for (var i = 0, len = me.columns.length; i < len; i++) {
				this.mixins.gutil.setColumnInfo(me, me.columns[i], fields );
			}
		} else {
			console.error("ERROR !!! please define columns");
		}
		//me.columns.push();
		
		this.callParent(arguments);
		
 		me.on('statelistchange', me._onStateListChange);
		me.on('statelistselect', me._onStateListSelect);
		
        // grid가 그려진후 
        this.on('render', this._onRenderFun);
        

        
        // keyDown on Cell
        /*
        this.on('cellkeydown', function(viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts) {
        	me.mixins.gutil.onCellKeyDownFun(me, viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts);
        }),
		*/
        // 더블클릭 on Cell
        this.on('celldblclick', this._onCellDblClickFun);
        
		// 행이동시 
        this.on('selectionchange', this._onSelectionchange);
		/*
		 * // 마우스 우측 click 이벤트에 context 메뉴 등록
		 me.contextMenu = new Unilite.com.menu.UniMenu({
				grid: me,
			    items: [
				    Ext.create('Ext.Action', {
				        iconCls   : 'icon-sheetSaveState',
				        text: '삭제',
				        disabled: false,
				        handler: function(widget, event) {
				        	
				          
				        }
				    })		    
			    ]   
			});
			
		
		this.on('itemcontextmenu',function(view, rec, node, index, e) {
            e.stopEvent();
            this.contextMenu.showAt(e.getXY());
            return false;
        });
        */
        // column resize 후 
        //this.on('columnresize',this._onColumnResizeFun);
        
        this.contextMenu = Ext.create('Ext.menu.Menu', {});
        
        var tbar = this._getToolBar();
        
    	if(Ext.isEmpty(tbar)) {
    		if(this.uniOpt.useGroupSummary || this.uniOpt.useLiveSearch || 
    			this.uniOpt.state.useState || this.uniOpt.state.useStateList || 
    			this.uniOpt.excel.useExcel || me.getStore().isGrouped()) {
	    		var bar = Ext.create('Ext.toolbar.Toolbar', {
			    	dock: 'top',
			        items : ['->']
		    	});
		    	this.addDocked(bar);
		    	tbar = this._getToolBar();
    		}
    	} else {
    		
    		tbar[0].insert(0, '->');
    	}
    	
    	this._createContextMenu(tbar[0]);
        
    	if(!Ext.isEmpty(tbar) && this.uniOpt.excel.useExcel) {

        	var excelBtn = {
        		xtype: 'uniBaseButton',
        		iconCls: 'icon-excel',
        		width: 26, height: 26,
        		tooltip: this.uniText.btnExcel,
        		handler: function() {
        			me.downloadExcelXml();
        		}
        	}
        	tbar[0].insert(0, excelBtn);
        }
    	
    	/************************************
         * for Toggle Summary
         */
    	if(!Ext.isEmpty(tbar)) {
	    	var toggleSummaryBtn = Ext.create('Unilite.com.button.BaseButton', {
	    		//xtype: 'uniBaseButton',
	    		iconCls: 'icon-grid-sum',
        		width: 26, height: 26,
        		tooltip: this.uniText.btnSummary,
	    		itemId: 'toggleSummaryBtn',
	    		enableToggle: true,
			    pressed:  false,
			    hidden: me.getStore().isGrouped() ? false:true,
	    		handler: function() {
	    			if(me.getStore().isGrouped()) {
	    				if(me.lockedGrid) {
						    view = me.lockedGrid.getView();
						    view.getFeature('masterGridSubTotal').showSummaryRow = !view.getFeature('masterGridSubTotal').showSummaryRow;
							view.getFeature('masterGridTotal').showSummaryRow = !view.getFeature('masterGridTotal').showSummaryRow;
							
							view.getFeature('masterGridSubTotal').toggleSummaryRow( view.getFeature('masterGridSubTotal').showSummaryRow );
							view.getFeature('masterGridTotal').toggleSummaryRow( view.getFeature('masterGridTotal').showSummaryRow );																
							view.refresh();
							
							view = me.normalGrid.getView();
							view.getFeature('masterGridSubTotal').showSummaryRow = !view.getFeature('masterGridSubTotal').showSummaryRow;
							view.getFeature('masterGridTotal').showSummaryRow = !view.getFeature('masterGridTotal').showSummaryRow;
							
							view.getFeature('masterGridSubTotal').toggleSummaryRow( view.getFeature('masterGridSubTotal').showSummaryRow );
							view.getFeature('masterGridTotal').toggleSummaryRow( view.getFeature('masterGridTotal').showSummaryRow );
							view.refresh();
					    } else {
					    	view = me.getView();
					    	view.getFeature('masterGridSubTotal').showSummaryRow = !view.getFeature('masterGridSubTotal').showSummaryRow;
							view.getFeature('masterGridTotal').showSummaryRow = !view.getFeature('masterGridTotal').showSummaryRow;
							
							view.getFeature('masterGridSubTotal').toggleSummaryRow( view.getFeature('masterGridSubTotal').showSummaryRow );
							view.getFeature('masterGridTotal').toggleSummaryRow( view.getFeature('masterGridTotal').showSummaryRow );
							view.refresh();
					    }
	    			}
	    		}
	    	});
//	    	if(me.getStore().isGrouped()) {
//	    		toggleSummaryBtn.show();
//	    	}
	    	tbar[0].insert(0, toggleSummaryBtn);
    	}
    	//그풉핑 변경 시 이벤트
    	// - '합계표시' 버튼 보이기 제어
    	me.getStore().on({
    		groupchange: {
    			//scope : me,
    			fn: function(store, groupers, eOpts){
    				var tbar = me._getToolBar();
    				if(!Ext.isEmpty(tbar)) {
						var toggleSummaryBtn = tbar[0].down("#toggleSummaryBtn");
						if(toggleSummaryBtn) {
							if(store.isGrouped()) {
					    		toggleSummaryBtn.show();
					    	}else{
					    		toggleSummaryBtn.hide();
					    	}
						}
    				}
    			}
    		}
    	});
    	
    	
    	/************************************
         * for Toggle Filters
         */
    	/*var toggleFilterBtn = {
    		text: '필터사용',
    		enableToggle: true,
		    pressed: this.uniOpt.useFilter,
    		handler: function() {
    			if(me.getStore().isGrouped()) {
    				if(me.lockedGrid) {
					    view = me.lockedGrid.getView();
					    if(this.pressed) {
					    	var filterFeature = Ext.create('feature.filters', {
					        	id : 'masterGridFilters',
								ftype : 'filters',
								encode: false,
								local: true
							});
							if(me.lockedFilters)
								filterFeature.filters = me.lockedFilters;
							view.features.push(filterFeature);
							me.reconfigure(null, me.columnManager.getColumns());

					    } else {
					    	me.lockedFilters = view.getFeature('masterGridFilters').filters;
					    	view.getFeature('masterGridFilters').removeAll();	
							Ext.Array.remove(view.features, view.getFeature('masterGridFilters'));				

					    }
						view.refresh();
						
						view = me.normalGrid.getView();
						if(this.pressed) {
					    	var filterFeature = Ext.create('feature.filters', {
					        	id : 'masterGridFilters',
								ftype : 'filters',
								encode: false,
								local: true
							});
							if(me.normalFilters)
								filterFeature.filters = me.normalFilters;
							view.features.push(filterFeature);
							me.reconfigure(null, me.columnManager.getColumns());
					    } else {
					    	me.normalFilterFs = view.getFeature('masterGridFilters').filters;
							view.getFeature('masterGridFilters').removeAll();				
					    	Ext.Array.remove(view.features, view.getFeature('masterGridFilters'));

					    }
					    view.refresh();
					    me.doLayout();
					    
						
					    
				    } else {
				    	view = me.getView();
				    	if(this.pressed) {
					    	var filterFeature = Ext.create('feature.filters', {
					        	id : 'masterGridFilters',
								ftype : 'filters',
								encode: false,
								local: true
							});
							if(me.normalFilters || me.lockedFilters)
								filterFeature.filters = me.normalFilters || me.lockedFilters || {};
					
							view.features.push(filterFeature);
							me.reconfigure(null, me.columnManager.getColumns());
					    } else {
					    	me.normalfilters = view.getFeature('masterGridFilters').filters;
							view.getFeature('masterGridFilters').removeAll();							
							Ext.Array.remove(view.features, view.getFeature('masterGridFilters')); 
					    }

						view.refresh();
					    me.doLayout();
				    }
    			}
    		}
    	}
    	tbar[0].insert(0, toggleFilterBtn);*/
    	
        /************************************
         * for LiveSearch
         */
        if(!Ext.isEmpty(tbar) && this.uniOpt.useLiveSearch) {

        	var liveSearchBtn = {
        		xtype: 'uniBaseButton',
        		iconCls: 'icon-grid-find',
        		width: 26, height: 26,
        		tooltip: this.uniText.searchBar.btnFind,
        		enableToggle: true,
		    	pressed: false,
        		handler: function() {
        			if(me.uniSearchToolbar) {
        				var wrapper = me.uniSearchToolbar.up('toolbar');
        				if(wrapper && wrapper.isHidden( )) {
        					wrapper.show();
        				} else {
        					wrapper.hide();
        				}
        			}
        		}
        	}
        	tbar[0].insert(0, liveSearchBtn);
        	
		    me.uniSearchToolbar = Ext.create('Ext.toolbar.Toolbar', {
		    	flex: 1,
		    	border: 0,
		        items: [	{
			            xtype: 'textfield',
			            name: 'searchField',
			            listeners: {
		                    change: {
		                         fn: me.mixins.search.onTextFieldChange,
		                         scope: this,
		                         buffer: 500
		                    },
		                    specialkey: function(field, e, eOpts){
				            	if(e.getKey() == e.ENTER){
        							field.fireEvent('change', field.getValue(), '', eOpts);
				            	}
				         	}
		                 },
		                 emptyText: this.uniText.searchBar.emptyText
		        	}, {
		                xtype: 'button',
		                text: '&lt;',
		                tooltip: this.uniText.searchBar.btnPrev,
		                handler: me.mixins.search.onPreviousClick,
		                scope: me
		            },{
		                xtype: 'button',
		                text: '&gt;',
		                tooltip: this.uniText.searchBar.btnNext,
		                handler: me.mixins.search.onNextClick,
		                scope: me
		            }, '-', {
		                xtype: 'checkbox',
		                hideLabel: true,
		                margin: '0 0 0 4px',
		                handler: me.mixins.search.regExpToggle,
		                scope: me                
		            }/*, '정규식', {
		                xtype: 'checkbox',
		                hideLabel: true,
		                margin: '0 0 0 4px',
		                handler: me.mixins.search.caseSensitiveToggle,
		                scope: me
		            }*/, '대소문자',		            
		            '->',{
		            	xtype: 'tbtext',
		            	itemId: 'searchStatus',
			            text: me.mixins.search.defaultStatusText
		            }
		        ]
		    });
		    
		    var searchBarWrap =  Ext.create('Ext.toolbar.Toolbar', {
		    	dock: 'top',
		    	hidden: true,
		    	items:[
	    			{
			            xtype: 'tbtext',
			            text: this.uniText.searchBar.searchColumn,
			            reorderable: false
			        },		        	
		        	{xtype: 'tbseparator',reorderable: false },
			        me.uniSearchToolbar
		    	]		    	
		    });

		    this.addDocked(searchBarWrap);
	    
        } // useLiveSearch

        
        /************************************
         * for MultiSOrting
         */
        if(!Ext.isEmpty(tbar) && this.uniOpt.useMultipleSorting) {
        	var multiSortingBtn = {
        		xtype: 'uniBaseButton',
        		iconCls: 'icon-grid-sort',
        		width: 26, height: 26,        		
        		tooltip: this.uniText.sortingBar.btnSort,
        		enableToggle: true,
		    	pressed: false,
        		handler: function() {
        			if(me.uniSortingToolbar) {
        				var wrapper = me.uniSortingToolbar.up('toolbar');
        				if(wrapper && wrapper.isHidden( )) {
        					wrapper.show();
        				} else {
        					wrapper.hide();
        				}
        			}
        		}
        	}
            
//        	var chkBtnLocation=true;
//        	Ext.each(tbar[0].items.items, function(item, index) {
//        		console.log("chkBtnLocation",item);
//        		if(item.getXType() == 'tbfill')	chkBtnLocation = false;
//        	});
//        	
//        	if(chkBtnLocation)	{
//        		tbar[0].add('->');
//        	}
        	tbar[0].insert(0, multiSortingBtn);
        	console.log("tbar[0]", tbar[0]);
        	
        	var reorderer = Ext.create('Ext.ux.BoxReorderer', {
		        listeners: {
		            scope: this,
		            Drop: function(r, c, button) { //update sort direction when button is dropped
		                UniGridMultiSorter.changeSortDirection(me, button, false);
		            }
		        }
		    });

		    var droppable = Ext.create('Ext.ux.ToolbarDroppable', {
		        /**
		         * Creates the new toolbar item from the drop event
		         */
		        createItem: function(data) {
		            var header = data.header,
		                headerCt = header.ownerCt,
		                reorderer = headerCt.reorderer;
		            
		            if (reorderer) {
		                reorderer.dropZone.invalidateDrop();
		            }
					var btnText = header.text.replace(/<span(?:.*?)>(?:.*?)<\/span>/g,'');
		            return UniGridMultiSorter.createSorterButtonConfig( me, {
		                text: btnText,
		                sortData: {
		                    property: header.dataIndex,
		                    direction: "ASC"
		                }
		            });
		        },
		
		        canDrop: function(dragSource, event, data) {
		            var sorters = UniGridMultiSorter.getSorters(me),
		                header  = data.header,
		                length = sorters.length,
		                entryIndex = this.calculateEntryIndex(event),
		                targetItem = this.toolbar.getComponent(entryIndex),
		                i;
		            if (!header.dataIndex || (targetItem && targetItem.reorderable === false)) {
		                return false;
		            }
		
		            for (i = 0; i < length; i++) {
		                if (sorters[i].property == header.dataIndex) {
		                    return false;
		                }
		            }
		            return true;
		        },
				//afterLayout: doSort
		       	afterLayout: function() {
		       		UniGridMultiSorter.doSort(me);
		       	} 
		    }); //droppable
	
		    //create the toolbar with the 2 plugins
		    me.uniSortingToolbar = Ext.create('Ext.toolbar.Toolbar', {
		    	flex: 1,
		    	border: 0,
		        items: [	{
			            xtype: 'tbtext',
			            text: this.uniText.sortingBar.dragAndDropHelp,
			            flex:1
		        	}
		        ],
		        hasHelp: true,
		        plugins: [reorderer, droppable],
		        listeners: {
		        	add: function ( tbar, component, index, eOpts ) {
		        		if(tbar.hasHelp && component.xtype != 'tbtext' ) {		        			
			        		var text = tbar.down('tbtext');
			        		if(text) {
			        			tbar.remove(text);
			        			tbar.hasHelp = false;
			        		}
		        		}
		        	}
		        }
		    });
		    
		    var sortBarWrap =  Ext.create('Ext.toolbar.Toolbar', {
		    	dock: 'top',
		    	hidden: true,
		    	items:[
	    			{
			            xtype: 'tbtext',
			            text: this.uniText.sortingBar.sortingOrder,
			            reorderable: false
			        },
		        	/*{
			            xtype: 'button',
			            text: 'Clear',
			            handler: function() {
							me.uniSortingToolbar.removeAll();
			            }
			        } ,*/
		        	{xtype: 'tbseparator',reorderable: false },
			        me.uniSortingToolbar
		    	]		    	
		    });
//		    tbar.push(sortingToolbar);
		    this.addDocked(sortBarWrap);//me.uniSortingToolbar);
	    
		    me.on('afterlayout', function(grid) {
                var lockedHeaderCt = grid.down("#lockedHeaderCt");
                var normalHeaderCt = grid.down("#normalHeaderCt");
                var needSort = false;
                if(lockedHeaderCt || lockedHeaderCt ) {
	                if(lockedHeaderCt) {
			                droppable.addDDGroup(lockedHeaderCt.reorderer.dragZone.ddGroup);
			                needSort = true;
		            }  
		            if (normalHeaderCt) {
			                droppable.addDDGroup(normalHeaderCt.reorderer.dragZone.ddGroup);
			                needSort = true;

                         // 기존 toolbar도 dropzone으로 변경
			            /*    
                        var tbar = me._getToolBar()[0];
                        tbar.dropTarget = Ext.create('Ext.dd.DropTarget', tbar.getEl(), {
                            notifyOver: function() {
						         var wrapper = me.uniSortingToolbar.up('toolbar');
                                 wrapper.show();
                                 return false;
                            }
                        });
                        tbar.canDrop= function() { return true;};
                        tbar.dropTarget.addToGroup(normalHeaderCt.reorderer.dragZone.ddGroup);*/
		            }
                } else {
	                var headerCt = grid.child("headercontainer");
	                if(headerCt) {
		                droppable.addDDGroup(headerCt.reorderer.dragZone.ddGroup);
			            needSort = true;
                        

	                }
                }
                if(needSort) {
	                UniGridMultiSorter.doSort(grid);
                }
               
            }, this, {single:true});
            
            me.on('sortchange', function(ct, column, direction, eOpts) {
            	console.log('sortchange:', eOpts);
            	UniGridMultiSorter.clearSortingToolbar(me, column, direction);
            });// sortchange
            
        	console.log("MultipleSorting enabled");
        }; // useMultipleSorting
        
        
        /************************************
         * for GroupSummary
         */
        //if(this.uniOpt.useGroupSummary && !this.uniOpt.useMultipleSorting) {
        if(!Ext.isEmpty(tbar) && this.uniOpt.useGroupSummary) {

        	var groupSummaryBtn = {
        		text: me.uniText.groupingBar.closed,
        		enableToggle: true,
		    	pressed: false,
        		handler: function() {
        			if(me.uniGroupingToolbar) {
        				var wrapper = me.uniGroupingToolbar.up('toolbar');
        				if(wrapper && wrapper.isHidden( )) {
        					wrapper.show();
        				} else {
        					wrapper.hide();
        				}
        			}
        		}
        	}
        	tbar[0].insert(0, groupSummaryBtn);
        	
        	/*
        	var reorderer = Ext.create('Ext.ux.BoxReorderer', {
		        listeners: {
		            scope: this,
		            Drop: function(r, c, button) { //update sort direction when button is dropped
		                UniGridMultiSorter.changeSortDirection(me, button, false);
		            }
		        }
		    });*/

		    var droppable = Ext.create('Ext.ux.ToolbarDroppable', {
		        /**
		         * Creates the new toolbar item from the drop event
		         */
		        createItem: function(data) {
		            var header = data.header,
		                headerCt = header.ownerCt,
		                reorderer = headerCt.reorderer;
		            
		            if (reorderer) {
		                reorderer.dropZone.invalidateDrop();
		            }
					var btnText = header.text.replace(/<span(?:.*?)>(?:.*?)<\/span>/g,'');
		            return UniGridGrouper.createGroupButtonConfig( me, {
		                text: btnText,
		                groupData: {
		                    dataIndex: header.dataIndex
		                }
		            });
		        },
		
		        canDrop: function(dragSource, event, data) {
		            var drops = UniGridGrouper.getDrops(me),
		                header  = data.header,
		                length = drops.length,
		                entryIndex = this.calculateEntryIndex(event),
		                targetItem = this.toolbar.getComponent(entryIndex),
		                i;
		
		            if (!header.dataIndex || (targetItem && targetItem.reorderable === false)) {
		                return false;
		            }
		
		            for (i = 0; i < length; i++) {
		                if (drops[i].dataIndex == header.dataIndex) {
		                    return false;
		                }
		            }
		            return true;
		        },
				//Add any required cleanup logic here
		       	afterLayout: function() {
		       		
		       		UniGridGrouper.doGroupSummary(me);
		       		
		       	} 
		    }); //droppable
	
		    //create the toolbar with the 2 plugins
		    me.uniGroupingToolbar = Ext.create('Ext.toolbar.Toolbar', {
		    	flex: 1,
		    	border: 0,
		        items: [	{
			            xtype: 'tbtext',
			            text: this.uniText.groupingBar.dragAndDropHelp,
			            flex:1
		        	}
		        ],
		        hasHelp: true,
		        plugins: [droppable],
		        listeners: {
		        	add: function ( tbar, component, index, eOpts ) {
		        		if(tbar.hasHelp && component.xtype != 'tbtext' ) {		        			
			        		var text = tbar.down('tbtext');
			        		if(text) {
			        			tbar.remove(text);
			        			tbar.hasHelp = false;
			        		}
		        		}
		        	}
		        }
		    });
		    
		    var groupBarWrap =  Ext.create('Ext.toolbar.Toolbar', {
		    	dock: 'top',
		    	hidden: true,
		    	items:[
	    			{
			            xtype: 'tbtext',
			            text: this.uniText.groupingBar.groupColumn,
			            reorderable: false
			        },
		        	/*{
			            xtype: 'button',
			            text: 'Clear',
			            handler: function() {
							me.uniSortingToolbar.removeAll();
			            }
			        } ,*/
		        	{xtype: 'tbseparator',reorderable: false },
			        me.uniGroupingToolbar
		    	]		    	
		    });

		    this.addDocked(groupBarWrap);//me.uniSortingToolbar);
	    
		    me.on('afterlayout', function(grid) {
                var lockedHeaderCt = grid.down("#lockedHeaderCt");
                var normalHeaderCt = grid.down("#normalHeaderCt");
                var needGroup = false;
                if(lockedHeaderCt || normalHeaderCt ) {
	                if(lockedHeaderCt) {
			                droppable.addDDGroup(lockedHeaderCt.reorderer.dragZone.ddGroup);
			                needGroup = true;
		            }  
		            if (normalHeaderCt) {
			                droppable.addDDGroup(normalHeaderCt.reorderer.dragZone.ddGroup);
			                needGroup = true;
		            }
                } else {
	                var headerCt = grid.child("headercontainer");
	                if(headerCt) {
		                droppable.addDDGroup(headerCt.reorderer.dragZone.ddGroup);
			            needGroup = true;
	                }
                }
                if(needGroup) {
	                UniGridGrouper.doGroupSummary(grid);
                }
            }, this, {single:true});
            
            /*me.on('sortchange', function(ct, column, direction, eOpts) {
            	console.log('sortchange:', eOpts);
            	UniGridMultiSorter.clearSortingToolbar(me, column, direction);
            });// sortchange
*/            
        	console.log("useGroupSummary ");        	
        }; // useGroupSummary
        
        
        /************************************
         * for Grid Stateful 
         */
        if(!Ext.isEmpty(tbar) && this.uniOpt.state.useState) {
        	var configBtn = {	
				text: 'Grid',
				iconCls: 'menu-menuShow',
				menu: {xtype: 'menu',
						items:[{
	                            text: 'Grid 설정 추가', 
	                            iconCls: 'icon-sheetSaveState',
	                            handler: function(widget, event) {
	                            	// 작업중!!!
	                            	var param = {
	                            		PGM_ID: 	UniAppManager.id,
	                            		SHT_ID: 	me.id,
	                            		SHT_INFO: 	UniAppManager.getDbShtInfo(me.id),
	                            		SHT_SEQ:	0,
	                            		MODE:		'save'
	                            	};
	                            	var callback = Ext.emptyFn;
	                            	Unilite.popupGridConfig(param, callback, me);				          
						        }
	                        },{
	                            text: 'Grid 설정 수정', 
	                            iconCls: 'icon-sheetSaveState',
	                            handler: function(widget, event) {
	                            	// 작업중!!!
	                            	var param = {
	                            		PGM_ID: 	UniAppManager.id,
	                            		SHT_ID: 	me.id,
	                            		SHT_INFO: 	'',
	                            		SHT_SEQ:	0,
	                            		MODE:		'config'
	                            	};
	                            	var callback = me.applyGridState;
	                            	Unilite.popupGridConfig(param, callback, me);					          
						        }
	                        }
	                  ]}
			};
			tbar[0].add(configBtn);
        }
        
        //그리드 설정 빠른 목록 
        if(!Ext.isEmpty(tbar) && this.uniOpt.state.useStateList) {
        	this.stateList = Ext.create('Unilite.com.form.field.UniComboBox', {
        		comboType: 'BSA421',
        		comboCode: UniAppManager.id + "__" + me.id,
        		tpl : Ext.create('Ext.XTemplate',
			        '<tpl for=".">',
			            '<div class="x-boundlist-item"><div class="uni_combo_text">{text}</div></div>',	
			        '</tpl>'
			    ),			    
			    listeners: {
			    	'change': function(cb, newValue, oldValue, eOpts) {
			    			if(!Ext.isEmpty(newValue)) {
					    		var param = {
		                    		PGM_ID: 	UniAppManager.id,
		                    		SHT_ID: 	me.id,
		                    		SHT_SEQ:	newValue
		                    	};
		                    	me.setLoading(true);
					    		extJsStateProviderService.selectStateInfo(param, 
					    			function(provider, response) {					    				
					    				UniAppManager.applyGridState(response.result);
					    				me.setLoading(false);
					    			}
					    		);
				    		}
			    	}
			    },
			    onStoreLoad: function(combo, store, records, successful, eOpts) {
			    	//초기 기본설정값 불러와서 설정
			    	var stateInfo = UniAppManager.getStateInfo(me.id);
		        	if(Ext.isDefined(stateInfo)) {
		        		if(!Ext.isEmpty(stateInfo)) {
		        			me.fireEvent('statelistselect', me, stateInfo);	
		        		}
		        	}			    	
			    }
        	});	
        	tbar[0].add(this.stateList);
        }
        

        me.on('afterrender', me._onAfterRender);

		me.on('cellcontextmenu', function( view, cell, cellIndex, record, row, rowIndex, event ) {
		//me.on('itemcontextmenu', function( grid, record, item, index, event, eOpts ) {			
			
			
			if(!Ext.isEmpty(me.contextMenu.child())) {
				if(me.copiedRow != null ) {
					var tMenu = me.contextMenu.down('#pasteRecord');
					tMenu.enable();
				}
				me.clickedRecord = record;
				me.clickedRowIndex = rowIndex;
				//var position = view.getPositionByEvent(event);
				me.select(rowIndex);
			
				event.stopEvent();
				me.contextMenu.showAt(event.getXY());
			}
		});
		
		me.on('beforeselect', function(model, record, index, eOpts ) {
			if(!Ext.isEmpty(me.uniOpt._selectionRecord.newRecordId))	{
				me.uniOpt._selectionRecord.oldRecordId = me.uniOpt._selectionRecord.newRecordId;
			}
			if(!Ext.isEmpty(record.id))	{
          		me.uniOpt._selectionRecord.newRecordId = record.id;
			}
		});
		
	},	// initComponent
	
	_onAfterRender: function(grid) {
		var me = grid;
		var view = me.getView();
		var map = new Ext.KeyMap(view.getEl(), [
		{
			key: Ext.EventObject.ENTER,
			fn: function(keyCode, e){ 
				var selModel;
				if(me._getStoreEditable()) {
					selModel = me.getSelectionModel();			
					var pos = selModel.getCurrentPosition(),
				            editingPlugin;
		            if (pos) {		            			            	
				        if (selModel.isCellModel) {
				        	editingPlugin = pos.view.editingPlugin;				            
				            if (editingPlugin && editingPlugin.editing) {
				                e.stopEvent();	//editing cell 이면 event stop (Ext.overide.grid.plugin.CellEditing 에서 처리)
				            } else {
				                selModel.move(e.shiftKey ? 'left' : 'right', e);
				            }
				            
				            //마지막 row의 last column 인 경우 새로운 행 추가
				            var isLastColumn;
				            if(me.lockedGrid) {
				            	isLastColumn = (pos.column === me.normalGrid.headerCt.getGridColumns().length-1);			            
				            }else {
				            	isLastColumn = (pos.column === me.getColumns().length-1);
				            }
				           	if(pos.row === me.getStore().getCount()-1 && isLastColumn) {
				           		UniAppManager.app.onNewDataButtonDown();
				           	}
				        } else {
				        	if(pos.row === me.getStore().getCount()-1) {
				           		UniAppManager.app.onNewDataButtonDown();
				           	}
				        }
		            }
				}else{
					me.fireEvent('onGridKeyDown', me, keyCode, e);	//팝업 그리드용 (각 onGridKeyDown 에서 기능 정의)
				}
			}
		}/*,{
		   	key: "c",
		   	ctrl:true,
		   	fn: function(keyCode, e) {		
		    	var recs = view.getSelectionModel().getSelection();
		
		      	if (recs && recs.length != 0) {		
		        	var clipText = me.getCsvDataFromRecs(recs);		
		           	var ta = document.createElement('textarea');
		
		           	ta.id = 'cliparea';
		           	ta.style.position = 'absolute';
		           	ta.style.left = '-1000px';
		           	ta.style.top = '-1000px';
		           	ta.value = clipText;
		           	document.body.appendChild(ta);
		           	document.designMode = 'off';
		
		           	ta.focus();
		           	ta.select();
		
		           	setTimeout(function(){		
		            	document.body.removeChild(ta);		
		           	}, 100);
		     	}
		 	}
		},{
			key: "v",
			ctrl:true,
			fn: function() {			
			    var ta = document.createElement('textarea');
			    ta.id = 'cliparea';
			
			    ta.style.position = 'absolute';
			    ta.style.left = '-1000px';
			    ta.style.top = '-1000px';
			    ta.value = '';
			
			    document.body.appendChild(ta);
			    document.designMode = 'off';
			
			    setTimeout(function(){			
			    	//Ext.getCmp('grid-pnl').getRecsFromCsv(grid, ta);
			     	me.getRecsFromCsv(view, ta);			
			     }, 100);
			
			    ta.focus();
			    ta.select();
			}
		}*/		 
		]);		
	},

	//State 목록을 갱신한다.
	_onStateListChange: function(grid, selectedValue) {
		var me = this;
    	
    	if(Ext.isDefined(me.stateList)) {
    		var combo = me.stateList;
    		var store = combo.getStore();
    		
    		if(Ext.isEmpty(selectedValue)) {
    			store.reload()
    		}else{
    			store.load({
				    scope: combo,
				    callback: function(records, operation, success) {				       
						combo.setValueOnly(selectedValue);
				    }    		
	    		});
    		}
    	}
	},	
	//State 목록의 선택값을 변경한다. (목록의 onchange 등 이벤트 발동 없이)
	_onStateListSelect: function(grid, stateInfo) {
		var me = this;
		if(me.stateList && stateInfo) {
			var combo = me.stateList;
			combo.setValueOnly(stateInfo.SHT_SEQ.toString());
		}
	},
	//db의 State 를 적용하고 State 목록의 선택값을 변경한다.
	applyGridState: function(stateInfo) {
    	
    	UniAppManager.applyGridState(stateInfo); 
    	
    	this.fireEvent('statelistselect', this, stateInfo);
    },
    
	// 행이동시 
	_onSelectionchange:function( grid, selected, eOpts ) {
        if(this.store.uniOpt) {
	        
	        if(this.store.uniOpt.isMaster) {
                var btnState = this.store.uniOpt.state || {};
				if(selected.length > 0 && this._getStoreDeletable()) {
			    	UniAppManager.setToolbarButtons('delete', true);
			    	Ext.apply(btnState, {btnDelete: true});
				} else {
					
			    	UniAppManager.setToolbarButtons('delete', false);
			    	Ext.apply(btnState,{btnDelete:false});
				}
			    this.store.uniOpt.state = btnState;
            }
        }
        if(selected.length > 0)	{
        	//console.log("oldRecordId:", this.uniOpt._selectionRecord.oldRecordId, ", newRecordId:", this.uniOpt._selectionRecord.newRecordId)
	        if(this.uniOpt._selectionRecord.oldRecordId != this.uniOpt._selectionRecord.newRecordId)	{
	        	this.fireEvent('selectionchangerecord',selected[0]);
	        }
        }
	},
	
	/**
	 * 선택된 row들을 삭제 한다.
	 */
	deleteSelectedRow:function() {
		var sm = this.getSelectionModel();
		var store = this.getStore();
		var selected = sm.getSelection();
		//var idx = selected[0].index;
		var idx  = this.getSelectedRowIndex();
		store.remove(sm.getSelection());
		if (idx > 0) {
			sm.select(idx-1);
		} else if(store.getCount() > 0) {
			sm.select(idx);
		}else {
			
			sm.deselectAll();
		}
		if(this.uniOpt.childForms) {
			for(var i =0, len = this.uniOpt.childForms.length ; i < len; i ++) {
				this.uniOpt.childForms[i].reset();
			}
		}
	},
	/**
	 * 커서를 이전row로 
	 */
	selectPriorRow:function() {
//		var selModel = this.getSelectionModel();
		//var selected = selModel.getSelection()[0];
		var rowIndex = this.getSelectedRowIndex();
		rowIndex = (rowIndex < 0) ? 0 : rowIndex;
		if(rowIndex > 0)	{
            this.select(rowIndex-1);
            return true;
//			this.getSelectionModel().select(rowIndex-1);
//            selModel.selectByPosition({row:currentPosition.row-1, column:currentPosition.column});
		}else {
			//alert(this.uniText.commons.isFirst);
			alert(Msg.sMB114);			
            return false;
		}
	},
	/**
	 * 커서를 다음row로 
	 */
	selectNextRow:function() {
//		var selModel = this.getSelectionModel();
		//var selected = selModel.getSelection()[0];
		var rowIndex = this.getSelectedRowIndex();
		rowIndex = (rowIndex < 0) ? 0 : rowIndex;
		var totalCount = this.getStore().getTotalCount()
       
		if(rowIndex < (totalCount-1))	{
            this.select(rowIndex+1);
            return true;
			//this.getSelectionModel().select(rowIndex+1);
            //selModel.selectByPosition({row:currentPosition.row+1, column:currentPosition.column});
            //this.moveTo(rowIndex+1,1);
		}else {
			//alert(this.uniText.commons.isLast);
			alert(Msg.sMB115);
            return false;
		}
	},
	
	selectFirstRow:function() {
		this.select(0);
	},
	/**
	 * 해당 row 선택 
	 * @param {} rowIndex
	 */
	select: function(rowIndex) {
		var selModel = this.getSelectionModel();
       
        
        if(selModel.isCellModel) {
            var currentPosition = selModel.getCurrentPosition();
            var newColumn = 0; 
            var newRow = 0;
            if(currentPosition) {
                newColumn = currentPosition.column;
            }
            // rownumberer가 있으면 보이지 않음
            var rownumberer = this.down('rownumberer');
            if(rownumberer && newColumn === 0 ) {
                newColumn = this._getFirstVisibleColumnIndex();
            }
            selModel.deselect(); 
            selModel.selectByPosition({row: rowIndex, column:newColumn});
        } else {
            selModel.deselectAll(); 
		    selModel.select(rowIndex);
        }
	},
    
    /**
     * 그리드에 보이는 첫번째 Column 가져오기
     * @return {}
     */
    _getFirstVisibleColumnIndex: function() {
        var cm = this.getView().getGridColumns();
        var columIndex = 0;
        var colCount = cm.length;
        for (var i = 0; i < colCount; i++) {
            if (cm[i].xtype != 'actioncolumn' && cm[i].xtype != 'rownumberer' && (cm[i].dataIndex != '') && (!cm[i].hidden)) {
                columIndex = i+1;
                break;
            }
        }
        return columIndex;
    },
	
	/**
	 * 선택된 record들을 돌려 준다.
	 * @return {}
	 */
	getSelectedRecords: function() {
		return this.getSelectionModel().getSelection();
	},
	/**
	 * 선택된 row중에서 첫번째 레코드를 돌려준다.
	 * @return {}
	 */
	getSelectedRecord:function() {
		var selectedRecords = this.getSelectedRecords();
		if(selectedRecords && selectedRecords.length > 0 ) {
			return selectedRecords[0];
		}		
	}, 
		
	/**
	 * 선택된 records중에 첫번째 record의  row index 값을 돌려 준다. 
	 * ( 기존 selected.index 를 대체함 !!!, 추가된 record는 index값이 없다)
	 * @param {} def
	 * @return {}
	 */
	getSelectedRowIndex: function(def) {
		
		var selModel = this.getSelectionModel();
		var selectedRecord = selModel.getSelection()[0];
		if(selectedRecord) {
			return this.store.indexOf(selectedRecord);
		} else {
			console.log("def:", def);
			if(Ext.isDefined(def)) {
				return def;
			} else { 
				return -1;
			}
		}
	},


	/**
	 * 그리드 데이타 초기화 (Store 포함)
	 */
	reset:function() {
//		this.store.loadRecords({}, {addRecords: false});
//		this.store.clearData(); 
		this.getStore().removeAll();
		this.view.refresh();
	},
	
	/**
	 * 현재 선택된 행에서 수정모드로 진입.
	 * @param {} columnName
	 */
	startEdit: function(columnName, val) {
		var me = this;
		this.mixins.gutil.startEdit(me, columnName, val);		
	},	
	
	/**
	 * 새로운 행을 추가 하고 편집을 시작 한다.
	 * @param {} record
	 * @param {} startEditColumnName
	 * @param {} rowIndex
	 * @return {}
	 */
	createRow:function( values, startEditColumnName, rowIndex) {
		return this.mixins.gutil.createRow(this, values, startEditColumnName, rowIndex);
/*		var me = this;
		//현재행 다음줄 부터
		var rowIndex = me.getSelectedRowIndex();
		console.log("rowIndex = " ,rowIndex );
		rowIndex = (rowIndex < 0)? 0 : rowIndex +1;
		var newRecord =  Ext.create (me.store.model, values);
		console.log("newRowIndex 1= " ,rowIndex );
		newRecord = me.store.insert(rowIndex, newRecord);	
		console.log("newRowIndex 2= " ,rowIndex );
		me.select(rowIndex);
		//me.startEdit(startEditColumnName);
		console.log("newRowIndex 3= " ,rowIndex );
		return newRecord; */
	},
	/**
	 * 
	 * @param {} form
	 */
	addChildForm:function(form) {
		this.uniOpt.childForms.push(form)
	}, 
	// private
	_onRenderFun: function(grid) {
		if(grid.uniOpt.onLoadSelectFirst) {
			grid.store.on('load', function(store, records, options) {
				if(store.count() > 0 ) {
		         	grid.getSelectionModel().select(0);
				}
		     });
		}
	},	
	// private
	_onCellDblClickFun:function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
        	var ct = grid.headerCt.getHeaderAtIndex(cellIndex);
        	var colName = ct.dataIndex;
        	//console.log('grid cell double click, record index : ',  record,"////", record.getId() + "=" + cellIndex + "/" + colName + "/" + record.get(colName) );
// function 에서 event로 처리 
        	//        	if(Ext.isDefined( this.onGridDblClick )) {
//        		this.onGridDblClick(grid, record, cellIndex, colName);
//        	}
        	this.fireEvent('onGridDblClick',grid, record, cellIndex, colName);
    },
	// private
	//_onColumnResizeFun:function(container, column, width, eOpts ) {
    //	console.log("Column : " , column.dataIndex ,  " resize to ", width);
	//},
    
	_getStoreDeletable : function() {
		var storeDeletable = false;
		if(this.store.uniOpt) {
			if( this.store.uniOpt.deletable ) {
				storeDeletable = true;
			}
		}
		return storeDeletable;
	},
	_getStoreEditable : function() {
		var storeEditable= false;
		if(this.store.uniOpt) {
			if( this.store.uniOpt.editable ) {
				storeEditable = true;
			}
		}
		return storeEditable;
	},
	/**
	 * 오류가 있는(invalid) 레코드의 첫번째 레코드의 첫번째 오류 Column으로 이동 및 선택 
	 * @param {} invalidRecords
	 */
	uniSelectInvalidColumnAndAlert:function(invalidRecords) {
		var invalidRec = Ext.isArray(invalidRecords) ? invalidRecords[0] : invalidRecords;
		
		var me = this;
		var rowIndex = me.store.indexOf(invalidRec);
		var fields = me.store.model.getFields();
		var columnIndex =  -1;
		var errors = invalidRec.validate();
		var column ;
		if(errors.items) {
			column = errors.items[0].field;
		} else {
			console.log('찾아갈 오류내용(column) 없음');
		}
		columnIndex =  me.getColumnIndex(column)-1;
		//me.moveTo(rowIndex, columnIndex);

		
		var msg = '';
		errors.items.forEach(function(entry) {
			var field = me._getField(fields, entry.field);
			msg = msg + field.text + ': ' + entry.message + '\n';
		});		
		//alert(msg + Msg.sMB083);
		msg = (rowIndex+1) + '행의 입력값을 확인해 주세요.\n' + msg ;
		//UniAppManager.updateStatus(msg);
		alert(msg);
	},
	/**
	 * grid에서 header에 정의된 모든 컬럼 정보
	 * @return {}
	 */
	getColumns: function() {
		return this.headerCt.getGridColumns();
	},
	/**
	 * grid에서 header에 정의된 visible 컬럼 정보
	 * @return {}
	 */
	getViewColumns: function() {
		return this.getView().getGridColumns();
	},
	/**
	 * grid에서 columnName(indexName)에 해당 하는 column을 돌려 줌.
	 * @param {} columnName
	 * @return {}
	 */
	getColumn: function(columnName) {
		var me = this, column  = null;
		var columns  = this.getColumns();
		/*for(var i = 0, len =  me.columns.length; i < len; i ++) {
			if ( me.columns[i].dataIndex == columnName ) {
				column = me.columns[i];
				break;
			}
		}
		*/
		for(var i = 0, len =  columns.length; i < len; i ++) {
			if ( columns[i].dataIndex == columnName ) {
				column = columns[i];
				break;
			}
		}
		return column;
	},	
	/**
	 * 
	 * @param {} dataIndex
	 * @return {}
	 * @private
	 */
	getColumnIndex: function(dataIndex) {
		var gridColumns = this.getColumns();
		for (var i = 0; i < gridColumns.length; i++) {
			if (gridColumns[i].dataIndex == dataIndex) {
				return i;
			}
		}
	},
	/**
	 * setCurrentPosition의 경우 bufferredremderer 사용시 오류가 있음
	 * 해당문제 해결한 이동 기능 .
	 * @param {} nRow
	 * @param {} nCol
	 */
	/*moveTo: function(nRow, nCol) {
		var view = this.view;
		var bufferedrenderer = undefined;
		if(view.locked) {
			bufferedrenderer = view.lockedView.bufferedRenderer;
		} else {
			 bufferedrenderer = this.findPlugin('bufferedrenderer');
		}
		
		if(bufferedrenderer) {
			bufferedrenderer.scrollTo(nRow);
		} else {
			var selModel = this.getSelectionModel();
			selModel.setCurrentPosition( {row: nRow, column: nCol} );
        }

	},*/
	getModelField: function(fieldName) {
 
        var fields = this.store.model.getFields();
        for (var i = 0; i < fields.length; i++) {
            if (fields[i].name === fieldName) {
                return fields[i];
            }
        }
    },
    getCsvDataFromRecs: function(records) {
    	var me = this,
			store = me.getStore(),
			clipText = '';
		
	   	//var currRow = store.find('id',records[0].data.id);
		var currRow = records[0].position.row;
	  	for (var i=0; i<records.length; i++) {
	
	    	//var index = store.find('id',records[i].data.id);
			var rowIndex = records[i].position.row;	
	     	var r = rowIndex;
	
	     	var record = records[i].position.record;
	     	//var cv = me.initialConfig.columns;
	     	var cv = me.columns;
	
	     	//for(var j=0; j < cv.length;j++) {
	
	        	//var val = rec.data[cv[j].dataIndex];
	     		var val = record.data[records[i].position.dataIndex];
	
	        	if (r === currRow) {
	
	             	clipText = clipText.concat(val,"\t");
	
	        	} else {
	
	             	currRow = r;
	
	            	clipText = clipText.concat("\n", val, "\t");
	
	        	}
	    	
	  	}
	
		return clipText;
	},
	getRecsFromCsv: function(view, ta) {

	  	document.body.removeChild(ta);
	  	var del = '';
	  	var store = view.getStore();
	
	  	if (ta.value.indexOf("\r\n")) {	
	      	del = "\r\n";
	  	} else if (ta.value.indexOf("\n")) {	
	      	del = "\n"
	  	}
	  	var rows = ta.value.split("\n");
	
	  	for (var i=0; i<rows.length; i++) {
	
	     	var cols = rows[i].split("\t");	
	     	var columns = view.initialConfig.columns;
	
	        if (cols.length > columns.length)	
	         	cols = cols.slice(0, columns.length-1)
	
	        if (gRow === -1 ) {	
	        	Ext.Msg.alert('Select a cell before pasting and try again!');	
	           	return;	
	        }
	
	        var cfg = {};
	
	        var tmpRec = store.getAt(gRow);
	
	        var existing = false;
	
	        if ( tmpRec ) {
	
	        	cfg = tmpRec.data;
	
	            existing = true;
	
	        }
	
	        var l = cols.length;
	
	        if ( cols.length > columns.length )	
	              l = columns.length;
	
	        for (var j=0; j<l; j++) {
	        	if (cols[j] === "") {	
	            	return;	
	           }
	
	        	cfg[columns[j].dataIndex] = cols[j];
	        }
	
	      	me.storeInitialCount++;
	
	      	cfg['id'] = me.storeInitialCount;
	
	      	var tmpRow = gRow;
	
	      	view.getSelectionModel().clearSelections(true);
	
	      	var tmpRec = Ext.create('Country',cfg);
	
	      	if (existing)	
	         	store.removeAt(tmpRow);
	
	      	store.insert(tmpRow, tmpRec);
	
	      	gRow = ++tmpRow;
	
	 	}
	   	if (gRow === store.getCount()) {
	
	    	var RowRec = Ext.create('Country',{});
	    	store.add(RowRec);
	   	}
	   	gRow = 0;
	},
    // 상단 toolbar를 돌려준다.
    _getToolBar: function() {
        var me = this;
        return me.getDockedItems('toolbar[dock="top"]');
    },
    // contextmenu를 생성한다.
    _createContextMenu: function(tbar) {
    	var me = this;

    	if(me._getStoreEditable()) {
			
			 	me.contextMenu.add(  
					    Ext.create('Ext.menu.Item', {
					    	itemId: 'copyRecord',
					        text: this.uniText.contextMenu.rowCopy,
					        disabled: false,
					        handler: function(widget, event) {
					          	if( me.clickedRecord != null ) {
					          		me.copiedRow = me.clickedRecord;
					          	}
					        }
					    })	
				);
				
				me.contextMenu.add(  
					    Ext.create('Ext.menu.Item', {
					        text: this.uniText.contextMenu.rowPaste,
					    	itemId: 'pasteRecord',
					        disabled: true,
					        handler: function(widget, event) {
					          	if(me.clickedRowIndex != null) {
					          		var record = me.copiedRow.copy().data;
						          	if(!me.hasListeners.beforepasterecord || me.fireEvent('beforePasteRecord',  me.clickedRowIndex, record) !== false) {
						        		me.createRow(record, 0, me.clickedRowIndex);
						        		me.fireEvent('afterPasteRecord',  me.clickedRowIndex, record)
					          		}
					          	}
					        }
					    })	
				);
		}
    	
		// 업무버튼을 contextmenu 로 변환하여 생성한다.
		if(me.uniOpt.useContextMenu) {			
//			if(!Ext.isEmpty(me.contextMenu.child())) {
//				me.contextMenu.add(Ext.create('Ext.menu.Separator', {}));
//			}
	    	tbar.items.items.forEach(function(btn){
	    		var menuItem = null;
	    		if(btn.getXType()=='tbfill' || btn.getXType()=='tbseparator' || btn.getXType()=='tbspacer') {
	    			menuItem = Ext.create('Ext.menu.Separator', {});
	    		}else{
	    			if(btn instanceof Ext.button.Button) {
		    			menuItem = Ext.create('Ext.menu.Item', {
		    			
		    			});
		    			menuItem.setText(btn.getText());
		    			menuItem.setIconCls(btn.iconCls);
		    			if(btn.menu){
		    				menuItem.setMenu(btn.menu.cloneConfig());
		    			}
	    			}
	    		}
	    		if(!Ext.isEmpty(menuItem))
	    			me.contextMenu.add(menuItem);    		
			});
		}
    }
    	
});
