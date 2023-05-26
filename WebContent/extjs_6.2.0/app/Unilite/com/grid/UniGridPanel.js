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
	//split:{size: 1},
	split: false, //5.1.0
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
    	'Unilite.UniDate'
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
	 */
	uniOpt:{
		//column option--------------------------------------------------
		expandLastColumn: true,
		useRowNumberer: true,		//번호 컬럼 사용 여부		
		filter: {
			useFilter: false,		//컬럼 filter 사용 여부
			autoCreate: false		//컬럼 필터 자동 생성 여부
		},
		//toolbar option--------------------------------------------------
		useGroupSummary: false,		//그룹핑 버튼 사용 여부
		useMultipleSorting: false,	//정렬 버튼 사용 여부
		useSqlTotal:false, 
		useLiveSearch: false,		//내용검색 버튼 사용 여부		
		state: {
			useState: true,			//그리드 설정 버튼 사용 여부
			useStateList: true		//그리드 설정 목록 사용 여부
		},
		excel: {
			useExcel: true,			//엑셀 다운로드 사용 여부
			exportGroup : false, 		//group 상태로 export 여부
			onlyData:false,
			summaryExport:true,
			exportGridData:false,
			serviceName : '', 		// Excel Download 시 실행할 서비스명  ex) serviceName :'s_btr112ukrv_mitService.selectMasterExcel',
			configId:'' 			// Excel Download 시  사용할 configuation xml,  저장위치  classpath:/foren/conf/excel/grid/{s_btr112ukrv_mitG1.xml}  ex)configId:'s_btr112ukrv_mitG1'
		},
		importData :{		//Excel 복사 후 붙여넣기
			useData :false, //Excel 복사 후 붙여넣기 사용 여부 
			configId: "",	//sample 다운로드용 xml id
			createOption: "customFn", // "customFn" / "baseAppFn" / "simple" 
									/* "custom" : grid의 loadImportData(copyRows) 함수 사용,
									   "baseAppFn" : BaseApp의  onNewDataButtonDown(copyRow) 사용, rows 수 만큼 loop 호출됨
									   "simple" : grid에 복사된 행 값만 적용하여 바로 붙여넣기, */
			columns:[]				//   붙여넣기 사용될 colums (순서대로 붙여넣기 함) 
		},
		//grid row&cell option--------------------------------------------
		useContextMenu: false,		//Context 메뉴 자동 생성 여부 
		copiedRow: null	,
		onLoadSelectFirst: true,
		
		
		_selectionRecord: {			//selectionChangeRecord event에서 사용됨
			oldRecordId:'',
			newRecordId:'',
			selected: undefined
		},
		userToolbar :true,
		enterKeyCreateRow:true,
		hasEnterKeyCreateRow:false,
		animatedScroll : false,
		dblClickToEdit	: true,	// true: double click to edit false:keydown to edit
		//FIXME 전페 선택 체크박스 아이콘 --> 삭제 대상
		selectAll:{				// 전체선택 tool 사용여부
			useCheckIcon:false,
			useCustomHandler:false  // onSelectAll event, onDeselectAll event will be fired
		},
		useNavigationModel:true,		// enter key Ext.grid.NavigationModel 사용여부
		lockable:false,
		useLoadFocus:true,				// 중복 된 팝업이 있는 경우 팝업내의 그리드의 경우 포커스 이동으로 인해 enable팝업의 순서가 변경 되는 것을 방지.
		nonTextSelectedColumns:[],		// cell click 시 text 선택  안되는 컬럼명 Array 정의 ['SEQ', 'REMARK'] 
		pivot:{
			use : false,
			pivotWin : null
		},
	},
	uniText: {
		sortingBar: {
			btnSort: UniUtils.getLabel('system.label.commonJS.grid.btnSort','정렬'),
			sortingOrder: UniUtils.getLabel('system.label.commonJS.grid.sortingOrder','정렬순서'),
			clickHelp: UniUtils.getMessage('system.message.commonJS.grid.clickHelp','필드명을 클릭하세요.')
		},
		groupingBar: {
			btnGroup: UniUtils.getLabel('system.label.commonJS.grid.btnGroup','그룹핑'),
			groupColumn: UniUtils.getLabel('system.label.commonJS.grid.groupColumn','그룹항목'),
			dragAndDropHelp: UniUtils.getMessage('system.message.commonJS.grid.dragAndDropHelp','이곳에 필드명을 가져다 놓으세요.')
		},
		searchBar: {
			btnFind: UniUtils.getLabel('system.label.commonJS.grid.btnFind','내용검색'),
			searchColumn: UniUtils.getLabel('system.label.commonJS.grid.searchColumn','내용검색'),
			emptyText: UniUtils.getMessage('system.message.commonJS.grid.emptyText','검색어를 입력하세요.'),
			btnPrev: UniUtils.getLabel('system.label.commonJS.grid.btnPrev','이전 찾기'),
			btnNext: UniUtils.getLabel('system.label.commonJS.grid.btnNext','다음 찾기')
		},
		btnSummary: UniUtils.getLabel('system.label.commonJS.grid.btnSummary','합계표시'),
		btnExcel: UniUtils.getLabel('system.label.commonJS.grid.btnExcel','엑셀 다운로드'),
		columns: {
			etc: '&nbsp;'
		},
		contextMenu: {
			rowCopy: UniUtils.getLabel('system.label.commonJS.grid.rowCopy','행 복사'),
			rowPaste: UniUtils.getLabel('system.label.commonJS.grid.rowPaste','복사한 행 삽입')
		},
		btnRefresh : UniUtils.getLabel('system.label.commonJS.grid.btnRefresh','그리드뷰 새로고침'),
		btnSampleFile : UniUtils.getLabel('system.label.commonJS.grid.btnSampleFile','복사양식'),
		btnPasteData : UniUtils.getLabel('system.label.commonJS.grid.btnPasteData','붙여넣기')
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
	//selType: 'rowmodel', // row 단위로 선택 됨. 단 lockmode 에서 수정시 오류 발생 함.
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
		,stateful: true
		,renderRow: function (record, rowIdx, out) {
    		var me = this,
            isMetadataRecord = rowIdx === -1,
            selModel = me.selectionModel,
            rowValues = me.rowValues,
            itemClasses = rowValues.itemClasses,
            rowClasses = rowValues.rowClasses,
            itemCls = me.itemCls,
            cls,
            rowTpl = me.rowTpl;
 
        // Define the rowAttr object now. We don't want to do it in the treeview treeRowTpl because anything
        // this is processed in a deferred callback (such as deferring initial view refresh in gridview) could
        // poke rowAttr that are then shared in tableview.rowTpl. See EXTJSIV-9341.
        //
        // For example, the following shows the shared ref between a treeview's rowTpl nextTpl and the superclass
        // tableview.rowTpl:
        //
        //      tree.view.rowTpl.nextTpl === grid.view.rowTpl
        //
        rowValues.rowAttr = {};
 
        // Set up mandatory properties on rowValues
        rowValues.record = record;
        rowValues.recordId = record.internalId;
 
        // recordIndex is index in true store (NOT the data source - possibly a GroupStore)
        rowValues.recordIndex = me.store.indexOf(record);
 
        // rowIndex is the row number in the view.
        rowValues.rowIndex = rowIdx;
        rowValues.rowId = me.getRowId(record);
        rowValues.itemCls = rowValues.rowCls = '';
        if (!rowValues.columns) {
            rowValues.columns = me.ownerCt.getVisibleColumnManager().getColumns();
        }
 
        itemClasses.length = rowClasses.length = 0;
 
        // If it's a metadata record such as a summary record.
        // So do not decorate it with the regular CSS.
        // The Feature which renders it must know how to decorate it.
        if (!isMetadataRecord) {
            itemClasses[0] = itemCls;
 
            if (!me.ownerCt.disableSelection && selModel.isRowSelected) {
                // Selection class goes on the outermost row, so it goes into itemClasses
                if (selModel.isRowSelected(record)) {
                    itemClasses.push(me.selectedItemCls);
                }
            }
 
            if (me.stripeRows && rowIdx % 2 !== 0) {
                itemClasses.push(me.altRowCls);
            }
 
            if (me.getRowClass) {
                cls = me.getRowClass(record, rowIdx, null, me.dataSource);
                if (cls) {
                    rowClasses.push(cls);
                }
            }
        }
 
        if (out) {
            rowTpl.applyOut(rowValues, out, me.tableValues);
        } else {
            return rowTpl.apply(rowValues, me.tableValues);
        }
        
        if(me.ownerGrid.uniOpt && me.ownerGrid.uniOpt.useLiveSearch && me.ownerGrid.searchRegExp)	{
            setTimeout(function(){
            	try{
            		if(me.ownerGrid.uniOpt && me.ownerGrid.uniOpt.useLiveSearch && me.ownerGrid.searchRegExp)	{
						me.ownerGrid._setHighlite(me, rowIdx);
            		}
            	}catch(e){
    				console.log(e)
    			}
			}, 1000);
        }
        
    }
	},
	
	multiColumnSort:true,
	sortableColumns : true,
	columnLines : true,
	loadImportData : Ext.emptyFn,
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
        var uniOpt = Ext.clone(me.uniOpt);
        var viewConfig = Ext.clone(me.viewConfig);
        if(config) {
        	Ext.apply(config.uniOpt, {'childForms': new Array()}); 
        	// if recursive merging and cloning is need, use Ext.Object.merge instead.
        	// Ext.apply 는 merge 하지 않고 overwrite 함.    
			
        	if(config.uniOpt) {   
        		if(Ext.isDefined(config.uniOpt.state))	{
					config.uniOpt.state.forceStateOption = true;
				}
        		// 프로그램메뉴 등록에 따른 피벗설정
        		if(Ext.isDefined(USE_PIVOT) && USE_PIVOT =='true' ){
	    			if(!Ext.isDefined(config.uniOpt.pivot))	{
	    				config.uniOpt.pivot = {use : true};
        		    }else {
        		    	if( !Ext.isDefined(config.uniOpt.pivot.use) && !config.uniOpt.pivot.use  )	{
        		    		config.uniOpt.pivot.use = true;
        		    	} 
	    			}
        		}
        		
        		uniOpt = config.uniOpt = Ext.Object.merge(uniOpt, config.uniOpt);
        	} else {
        		// 프로그램메뉴 등록에 따른 피벗설정
        		if(Ext.isDefined(USE_PIVOT) && USE_PIVOT =='true')	{
        			config.uniOpt = {
        				pivot : {
        					use : true
        				}
        			};
        		}
        		uniOpt = config.uniOpt = Ext.Object.merge(uniOpt, config.uniOpt);
        	}
			
        	if(config.viewConfig) {   
        		
        		viewConfig = config.viewConfig = Ext.Object.merge(viewConfig, config.viewConfig);
        	}
        	
        	/*if(config && Ext.isDefined(config.uniOpt) && Ext.isDefined(config.uniOpt.onLoadSelectFirst))	{
        		me.uniOpt['onLoadSelectFirst'] =  config.uniOpt.onLoadSelectFirst;
        	}*/
			if(uniOpt.expandLastColumn) {
				var bigoConfig = {text: this.uniText.columns.etc,	flex: 1, minWidth:120, 
										resizable: false, hideable:false, sortable:false, lockable:false,
										menuDisabled: true, draggable: false
				};
				//config.columns.push(bigoConfig);
				config.columns = Ext.Array.push(config.columns, bigoConfig);
			}
        	
			if(config.features)	{
				var grdFeatures = config.features;
				var _isGroupSummaryHide = false, _isTotalSummaryHide=false;
				Ext.each(grdFeatures, function(feature, idx) {
					if(feature.ftype == "uniGroupingsummary")	{
						if(!feature.showSummaryRow)	{
							_isGroupSummaryHide = true;
							feature.showSummaryRow = true;
						}
					}
					if(feature.ftype == "uniSummary")	{
						if(!feature.showSummaryRow)	{
							_isTotalSummaryHide = true;
							feature.showSummaryRow = true;
						}
					}
				});
				if(_isGroupSummaryHide && _isTotalSummaryHide)	{
					config._isSummaryHide = true
				}
			}
			
        	Ext.apply(me, config);
        }
        
        if(!Ext.isDefined(config.plugins)) {
			config.plugins = new Array();		
		}
		if(!Ext.isDefined(config.features)) {
			config.features = new Array();		
		}
		
		// filter
		if(Ext.isDefined(uniOpt.filter) && uniOpt.filter.useFilter) {
			config.plugins.push({
				ptype:'gridfilters'
			});
			//setColumnInfo 에서 컬럼별 필터 생성
		}
		
		
		if(config.store && config.store.uniOpt && config.store.uniOpt.editable) {
			/// 편집모드의 경우
			config.selType= 'rowmodel';
			Ext.apply(config, {selType: 'rowmodel'} );
			
			Ext.apply(me.viewConfig, {enableTextSelection: false} ); //(true로 하면 Chrome 에서 에디팅모드 시 셀에 잔상이 보여지다 사라지는 문제가 있음.)
		}else if(config.selModel && (config.selModel == 'spreadsheet' || config.selModel.type == 'spreadsheet')) {
			/// spreadsheet모드로 설정한 경우
			config.plugins.push({ptype: 'clipboard'});
			config.selType= 'spreadsheet';
			Ext.apply(config, {selType: 'spreadsheet'} );
			Ext.apply(me.viewConfig, {enableTextSelection: false} )
		
		}else if(config.selModel && (config.selModel == 'rowmodel' || config.selModel != undefined ))	{
			/// 편집모드의 경우
			config.selType= 'rowmodel';
			Ext.apply(config, {selType: 'rowmodel'} );
			
			Ext.apply(me.viewConfig, {enableTextSelection: false} ); //(true로 하면 Chrome 에서 에디팅모드 시 셀에 잔상이 보여지다 사라지는 문제가 있음.)
		}else if(config.selModel != undefined && config.selModel.uniTyppe != undefined && config.selModel.uniType == "checkboxmodel" ) {		// checkboxmodel clipboard plugin 시 error
			Ext.apply(me.viewConfig, {enableTextSelection: false} )
		}else if(config.store && config.store.uniOpt && !config.store.uniOpt.editable  /*&& !me.hasListener('selectionchange') */){
			//조회는 모두 spreadsheet 로
			
			Ext.apply(config, {selType: 'spreadsheet'} );
			config.plugins.push({ptype: 'clipboard'});
			Ext.apply(me.viewConfig, {enableTextSelection: false} )
		}
		
		/*if( uniOpt.useRowContext && config.uniRowContextMenu)	{
			var menuItems = [];
			Ext.each(config.uniRowContextMenu.items, function(item, idx){
				Ext.apply(item, {iconCls:'icon-link'})
				menuItems.push(item);
			})
			var rowMenu = Ext.create( 'Ext.menu.Menu', {items:menuItems})
			Ext.apply(config, {'uniRowContextMenu': rowMenu });
		}*/
		
		
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
			/*if(!me.uniOpt.state.forceStateOption)	{
				this.uniOpt.state.useState = false;
				this.uniOpt.state.useStateList = false;
			}*/
			
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
						//locked: true, 
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
		
		
		me.on('load', me._onLoad);
 		me.on('statelistchange', me._onStateListChange);
		me.on('statelistselect', me._onStateListSelect);
		me.on('cellkeydown', me._onCellKeyDown);
		me.on('containermousedown', me._onContainerclick);
		
		
		//me.on('cellclick', me._onCellclick);
		//if(me.uniRowContextMenu)	{
		//	me.on('itemcontextmenu', me._onItemcontextmenu);
		//}
		
        // grid가 그려진후 
		//if(me.uniOpt.onLoadSelectFirst)	{
		
        	this.on('render', this._onRenderFun, me, me.uniOpt.onLoadSelectFirst);
		
		//}
        
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
        this.on('deselect', this._onDeselect);
        this.on('select', this._onSelect);
        
        this.contextMenu = Ext.create('Ext.menu.Menu', {});
        if(this.uniOpt.userToolbar)	{
	        var tbar = this._getToolBar();
	        
	    	if(Ext.isEmpty(tbar)) {
	    		if(this.uniOpt.useGroupSummary || this.uniOpt.useLiveSearch || 
	    			this.uniOpt.state.useState || this.uniOpt.state.useStateList || 
	    			this.uniOpt.excel.useExcel || this.uniOpt.useExcelPaste ||
	    			me.getStore().isGrouped()) {
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
	    	
	       	if(!Ext.isEmpty(tbar)) {
		    	tbar[0].insert(0, {xtype: 'uniBaseButton',
		        		iconCls: 'icon-reload',
		        		width: 26, height: 26,
		        		tooltip: this.uniText.btnRefresh,// '그리드뷰 새로고침',
		        		handler: function() {
		        			me.getView().refresh();
		        		}
		        });
	    	}
	        if(!Ext.isEmpty(tbar) && this.uniOpt.importData.useData) {
				/*
				 * importData :{
						useImportData :true, //Excel 복사 후 붙여넣기 사용 여부 
						configId: ""
					},
				 * */
	        	var importDataBtn = {
	        		xtype: 'uniBaseButton',
	        		iconCls: 'icon-sampleFile',
	        		width: 26, height: 26,
	        		tooltip: this.uniText.btnSampleFile, 
	        		hidden : Ext.isEmpty(this.uniOpt.importData.configId),
	        		handler: function() {
	        			//me.downloadSample();
	        			document.location.href="../excel/samples/grid/"+me.uniOpt.importData.configId+"?type=xls"; 
	        		}
	        	}
	        	tbar[0].insert(0, importDataBtn);
	        	var importPasteBtn = {
	        		xtype: 'uniBaseButton',
	        		iconCls: 'icon-pasteData',
	        		itemId:'pasteData',
	        		width: 26, height: 26,
	        		tooltip: this.uniText.btnPasteData,
	        		handler: function() {
	        			if(Ext.isIE )	{
	        				if(window.clipboardData && Ext.isFunction(window.clipboardData.getData))	{
	        					var text = window.clipboardData.getData("Text")	;
	        					this.getPasteData(text);
	        				} else {
	        					Unilite.messageBox(UniUtils.getMessage("system.message.commonJS.grid.importDataBrowser","붙여넣기를 지원하는 브라우저가 아닙니다."));	        					
	        				}
	        			} else if(Ext.isChrome || Ext.isEdge  )	{
	        				var me = this;
	        				if(window.location.protocol == "http:" ||  Ext.isEdge )	{
		        				var pasteWin = Ext.create('Ext.container.Container', {//'widget.uniDetailWindow', {
				                    //title: '붙여넣기',
				                    width: 500,                             
				                    height:100,
				                    /*frame:false,
				                    frameHeader:false,*/
				                    //render: Ext.getBody(),
				                    floating :true,
				                    layout: {type:'vbox', align:'stretch'},                 
				                    items: [{
				                            itemId:'search',
				                            xtype:'textarea',
				                            name:'uniExcelPaste',
				                            itemId:'uniExcelPaste',
				                            width:1,
				                            height:1,
				                    		readOnly:false,
				                    		enableKeyEvents:true,
				                    		scrollable:false,
				                    		listeners:{
				                    			keyup:function(field, event)	{
				                    				console.log(" keyup event : ", event);
				                    				console.log(" keyup field : ", field);
				                    				me.getPasteData(field.value);
				                    				pasteWin.destroy();
				                    			}
				                    		}
				                    },{
				                    	xtype:'component',
				                    	html:'<div style="height:100px;text-align:center;line-height: 100px;">여기를 클릭하시고 Ctrl + v 키를 누르세요.</div>',
				                    	width:500,
				                    	height:100,
				                    	style:{"background-color":"#eee","vertical-align":'middle', 'margin-top':'-1px'},
				                    	listeners:{
				                    		render:function(component)	{
					                    		component.getEl().on('click', function()	{
					                    			pasteWin.down("#uniExcelPaste").focus();
					                    		});
				                    		}
				                    	}
				                    }]/*,
				                    tbar:['->',
				                    	{xtype:'button', text:'닫기', handler:function(){
				                    		pasteWin.close();
				                    	}}
				                    ]*/
		        				});
		        				pasteWin.show();
		        				pasteWin.center();
	        				} else {
		        				eval("navigator.clipboard.readText().then(text => {"+
								  	"this.getPasteData(text);"+
								  "})"+
								  ".catch(err => {"+
								  "  console.error('Failed to read clipboard contents: ', err);"+
								  "  alert('"+UniUtils.getMessage("system.message.commonJS.grid.importDataError","붙여넣기 중에 오류가 발생했습니다.")+"');"+
								  "})");
								  /*navigator.clipboard.readText().then(text => {
								  	this.getPasteData(text);
								  })
								  .catch(err => {
								    console.error('Failed to read clipboard contents: ', err);
								    alert('붙여넣기 중에 오류가 발생했습니다. '+err);
								  })*/
							}
	        				
	        			} /*else if(Ext.isGecko  )	{ // Mozilla, Firefox
	        				navigator.permissions.query({name: "clipboard-write"}).then(result => {
								  if (result.state == "granted" || result.state == "prompt") {
								    navigator.clipboard.readText()
								  .then(function(text){
								  	this.getPasteData(text);
								  })
								  .catch(function(err) {
								    console.error('Failed to read clipboard contents: ', err);
								    alert("붙여넣기 중에 오류가 발생했습니다. ")
								  });
							  }
							});
	        			} else if(Ext.isSafari )	{ 
	        			
	        			}*/ else {
	        				Unilite.messageBox(UniUtils.getMessage("system.message.commonJS.grid.importDataBrowser","붙여넣기를 지원하는 브라우저가 아닙니다."));
	        			}
	        			
	        		},
	        		getPasteData:function(text) {
	        			if(!text)	{
	        				Unilite.messageBox(UniUtils.getMessage("system.message.commonJS.grid.emptyCodyData","복사된 데이타가 없습니다."));
	        				return;
	        			}
	        			var me = this.up("grid");
					    var data = text;
						var rows = data.split("\n");
						var copyList =  [];
						for(var y in rows) {
							if(y < rows.length && rows[y].length > 0)	{
							    var cells = rows[y].split("\t");
							    var row = {};
							    for(var x in cells) {
							    	row[me.uniOpt.importData.columns[x]] = cells[x];
							    }
							    copyList.push(row)
							}
						}
						console.log("copyList : ",copyList);
						if("simple" == me.uniOpt.importData.createOption)	{
							Ext.each(copyList, function(record, idx){
								me.createRow(record, null, (me.getSelectedRowIndex()) ?  me.getSelectedRowIndex(): idx );
							})
						} else if("baseAppFn" == me.uniOpt.importData.createOption)	{
							Ext.each(copyList, function(record, idx){
								UniAppManager.app.onNewDataButtonDown(record);
							})
						} else {
							me.loadImportData(copyList);
						}
	        		}
	        	}
	        	tbar[0].insert(0, importPasteBtn);
	        }
	    	if(!Ext.isEmpty(tbar) && this.uniOpt.excel.useExcel) {
	
	        	var excelBtn = {
	        		xtype: 'uniBaseButton',
	        		iconCls: 'icon-excel',
	        		width: 26, height: 26,
	        		tooltip: this.uniText.btnExcel,
	        		disabled:(Ext.isDefined(SAVE_AUTH) && SAVE_AUTH == "true") ? false:true,
	        		handler: function() {
	        			if(Ext.isDefined(SAVE_AUTH) && SAVE_AUTH == "true")	{
		        			if(Ext.isDefined(me.excelTitle)) {
		        				me.downloadExcelXml(false, me.excelTitle);
		        			}else if(Ext.isDefined(PGM_TITLE)) {
		        				me.downloadExcelXml(false, PGM_TITLE);
		        			}else {
		        				me.downloadExcelXml();
		        			}
	        			}
	        		}
	        	}
	        	tbar[0].insert(0, excelBtn);
	        }
	        //FIXME 삭제 대상
	        /**********************************
	         * 체크박스 버튼
	         * */
	        if(!Ext.isEmpty(tbar) && this.uniOpt.selectAll.useCheckIcon  ) {
	
	        	var checkBtn = {
	        		xtype: 'uniBaseButton',
	        		iconCls: 'icon-grid-check',
	        		grid: me,
	        		width: 26, height: 26,
	        		handler: function() {
	        			if(this.grid.uniOpt.selectAll.useCustomHandler ) {
	        				if(this.iconCls == 'icon-grid-check')	{
	        					this.grid.fireEvent("onSelectAll", this.grid, this);
	        					this.setIconCls('icon-grid-check');
	        				}else {
	        					this.grid.fireEvent("onDeselectAll", this.grid, this);
	        					this.setIconCls( 'icon-grid-uncheck');
	        				}
	        			}else {
		        			if(this.grid.getSelectedRecords().length > 0) {
		        				this.grid.getSelectionModel().deselectAll();
		        				this.setIconCls('icon-grid-check');
		        			}else {
		        				this.grid.getSelectionModel().selectAll();
		        				this.setIconCls('icon-grid-uncheck');
		        			}
	        			}
	        		},
	        		setIcon:function(chk)	{
	        			if(chk) {
	        				this.iconCls = 'icon-grid-check';
	        			}else {
	        				this.iconCls = 'icon-grid-uncheck';
	        			}
	        		}
	        	}
	        	tbar[0].insert(0, checkBtn);
	        }
	        //체크박스 삭제 대샹 끝
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
				    grid:me,
		    		handler: function(btn) {
		    			// SQL로 합계를 표현하는 경우
		    			if(btn.grid.uniOpt.useSqlTotal)	{
		    				var store = btn.grid.getStore();
		    				var filters = store.getFilters();
		    				var hasSummaryFilter = false; 
		    				var summaryFilter ;
		    				if(store.filters)	{
			    				Ext.each(store.filters.items, function(filter, idx){
			    					if(filter.getId() == 'common_sql_summary_'+btn.getId()) {
			    						hasSummaryFilter = true ;
			    					}
			    				})
		    				}
		    				if(hasSummaryFilter)	{
		    					 store.removeFilter('common_sql_summary_'+btn.getId());
		    				}else {
			    				 summaryFilter = new Ext.util.Filter({
			    						id : 'common_sql_summary_'+btn.getId(),
									    filterFn: function(item) {
									        return !(item.get('common_total') == 'sub_total' ||  item.get('common_total') == 'total');
									    }
									});
								store.addFilter(summaryFilter);
		    				}
		    				if(Ext.isFunction(btn.grid.onClickSummary)) {
		    					// 'common_total' fileld 값으로 사용하지 못할 경우 
		    					// 혹은 추가 내용이 있을 경우 개별 프로그램에서 onClickSummary 함수 만들어 사용
		    					btn.grid.onClickSummary();
		    				}
		    			}else {
		    				// uniSummary, uniGroupingsummary로 표현하는 경우
			    			if(me.getStore().isGrouped()) {
			    				if(me.lockedGrid)	{
			    					var features = me.lockedGrid.features;
				    				if(features && features.length > 0)	{
				    					var feature = me.lockedGrid.view.getFeature(features[0].id);
				    					me.setShowSummaryRow(!feature.showSummaryRow);
				    				}
			    				}else{
				    				var features = me.features;
				    				if(features && features.length > 0)	{
				    					var feature = me.view.getFeature(features[0].id);
				    					me.setShowSummaryRow(!feature.showSummaryRow);
				    				}
			    				}
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
			                handler: me.mixins.search.caseSensitiveToggle,
			                scope: me                
			            }/*, '정규식', {
			                xtype: 'checkbox',
			                hideLabel: true,
			                margin: '0 0 0 4px',
			                handler: me.mixins.search.caseSensitiveToggle,
			                scope: me
			            }*/,UniUtils.getLabel('system.label.commonJS.grid.searchCaseSensitive ', '대소문자'),		            
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
        if(!Ext.isEmpty(tbar) && this.uniOpt.useMultipleSorting == true  && 1==2 ) {
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
							me.uniSortingToolbar.removeAll();
							UniGridMultiSorter.doSort(me);
							me.fireEvent("afterlayout", me);
        				}
        			}
        		}
        	}

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
		                column:data,
		                sortData: {
		                    property: header.dataIndex,
		                    direction: "ASC",
		                    mode:'multi'
		                }
		            });
		        },
				notifyDrop: function(dragSource, event, data) {
			        var canAdd = this.canDrop(dragSource, event, data);
			        if(canAdd)	{
						this.createItem(data);
			        }
			        return canAdd;
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
					if(this.dropTarget){
						console.log("this.dropTarget : ",this.dropTarget)	
						console.log("entryIndex : ",entryIndex)	
						console.log("targetItem : ",targetItem)	
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
		    	flex: .5,
		    	border: 0,
		        items: [	{
			            xtype: 'tbtext',
			            text: this.uniText.sortingBar.clickHelp,
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
		        		console.log(" add sorters : ", me.store.getSorters());
		        	},
		        	remove:function(tbar){
		        		if(tbar.items.length == 0)	{
		        			
		        			tbar.hasHelp= true;
		        			tbar.add({
					            xtype: 'tbtext',
					            text: me.uniText.sortingBar.clickHelp,
					            flex:1
				        	});
		        		}
		        		console.log(" add sorters : ", me.store.getSorters())
		        	}
		        }
		    });
		    
		    var sortBarWrap =  Ext.create('Ext.toolbar.Toolbar', {
		    	dock: 'top',
		    	itemId:'sortBarWrap',
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
	                if(lockedHeaderCt && lockedHeaderCt.reorderer && lockedHeaderCt.reorderer.dragZone) {
			                droppable.addDDGroup(lockedHeaderCt.reorderer.dragZone.ddGroup);
			                needSort = true;
		            }  
		            if (normalHeaderCt && normalHeaderCt.reorderer && normalHeaderCt.reorderer.dragZone) {
			                droppable.addDDGroup(normalHeaderCt.reorderer.dragZone.ddGroup);
			                needSort = true;
		            }
                } else {
	                var headerCt = grid.child("headercontainer");
	                if(headerCt && headerCt.reorderer && headerCt.reorderer.dragZone) {
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
            	if( me.uniOpt.useMultipleSorting == true)	{
            		var sortBarWrap = me.down('#sortBarWrap');
            		sortBarWrap.show();
            	}
            	UniGridMultiSorter.clearSortingToolbar(me, column, direction);
            });// sortchange
            
        	console.log("MultipleSorting enabled");
        }; // useMultipleSorting
        
        // DATA pivot
        if(!Ext.isEmpty(tbar) && this.uniOpt.pivot.use) {
        	
        	var pivotBtn = {
        			xtype : 'button',
        			text : UniUtils.getLabel('system.label.commonJS.pivotAnalysis',"피벗분석"),
        			handler : function(){
        				if(me.store &&  me.store.getData().items.length == 0 )	{
        					Unilite.messageBox("조회된 데이터가 없습니다.");
        					return;
        				}
						if(Ext.isEmpty(me.uniOpt.pivot.pivotWin) ) {
							var componentConf =  {}  ;
							Ext.apply( componentConf
									  ,{
											xtype : 'UniPivotComponent',
								    		id    :  me.getId()+'Pivot',
								    		grid  : me,
								    		store : me.store,
								    		flex : 1,
									  }
									  ,  me.uniOpt.pivot.componentConfig);
							me.uniOpt.pivot.pivotWin = Ext.create('widget.uniDetailWindow', {
								title: 'DATA 피벗',
								width : '100%',
								height : '100%',
								layout: {type:'vbox', align:'stretch'},
								items: [componentConf],
								tbar:  [
									 '->',{
										itemId : 'closeBtn',
										text: '닫기',
										handler: function() {
											me.uniOpt.pivot.pivotWin.hide();
										},
										disabled: false
									}
								],
								listeners : {
									 show: function( panel, eOpts ) {
										 var pivotComp = Ext.getCmp( me.getId()+'Pivot');
										 pivotComp.onLoadRender();
									 } 
								}
							});
						}
						me.uniOpt.pivot.pivotWin.data = me.getStore().getData().items;
						me.uniOpt.pivot.pivotWin.center();
						me.uniOpt.pivot.pivotWin.show(); 
        					 
        			}
				
        	};
        	tbar[0].add(pivotBtn);
        }
	        /************************************
	         * for Grid Stateful 
	         */
	        if(!Ext.isEmpty(tbar) && this.uniOpt.state.useState) {
	        	var provider = Ext.state.Manager.getProvider();
				me.baseShtInfo = {SHT_INFO :provider.encodeValue({"type":"grid", "id":me.getId(), "shtInfo" :  me.getState(), isInitial:'Y'}), DEFAULT_YN : 'N', SHT_ID :me.getId() } ;	 
				//UniAppManager.setStateInfo({ SHT_ID:UniAppManager.id ,SHT_SEQ:'0',SHT_INFO:me.baseShtInfo});
				//UniAppManager.setStateInfo({ SHT_ID:me.getId() ,SHT_SEQ:'0',SHT_INFO:me.baseShtInfo});
				
	        	var configBtn = {	
					text: 'Grid',
					iconCls: 'icon-sheetSaveState',
					menu: {xtype: 'menu',
							items:[{
		                            text: UniUtils.getLabel('system.label.commonJS.grid.btnStateSave','그리드 설정 저장'), 
		                            tooltip:UniUtils.getLabel('system.label.commonJS.grid.btnStateSave','그리드 설정 저장'),
		                            iconCls: 'icon-sheetSaveState',
		                            handler: function(widget, event) {
		                            	var selectedState = me.down('#'+me.id+'_SHT_SEQ');
		                            	//프로그램 수정시 컬럼의 추가/삭제 확인을 위해 현재 컬럼 정보 저장
		                            	var columnInfoArr = new Array();
		                            	Ext.each(me.config.columns, function(column, idx){
		                            		columnInfoArr.push({dataIndex:column.dataIndex, hidden:column.hidden, width:column.width});
		                            	});
		                            	
		                            	var shtSeq = Ext.getCmp(me.id+'StateCombo').getValue();
		                            	if(!shtSeq)	{
		                            		shtSeq = 0;
		                            	} 
		                            	
		                            	var param = {
		                            		PGM_ID: 	UniAppManager.id,
		                            		SHT_ID: 	me.id,
		                            		SHT_INFO: 	UniAppManager.getDbShtInfo(me.id),
		                            		SHT_SEQ:	shtSeq,
		                            		MODE:		'save',
		                            		COLUMN_INFO : columnInfoArr,
		                            		BASE_SHT_INFO : me.baseShtInfo
		                            	};
		                            	var callback = Ext.emptyFn;
		                            	Unilite.popupGridNewConfig(param, callback, me);				          
							        }
		                        },{
		                            text: UniUtils.getLabel('system.label.commonJS.grid.btnStateDelete','그리드 설정 삭제'), 
		                            tooltip:UniUtils.getLabel('system.label.commonJS.grid.stateDelete','그리드의 설정 항목 삭제'),
		                            iconCls: 'icon-sheetSaveState',
		                            handler: function(widget, event) {
		                            	var shtSeq = Ext.getCmp(me.id+'StateCombo').getValue();
		                            	if(!shtSeq || shtSeq==0)	{
		                            		shtSeq = 0;
		                            	} else {
		                            		
		                            		//if(confirm(UniUtils.getLabel('system.message.commonJS.grid.stateDelete','그리드 설정을 삭제 하시겠습니까?')))	{
				                            	var param = {
				                            		PGM_ID: 	UniAppManager.id,
				                            		SHT_ID: 	me.id,
				                            		SHT_INFO: 	'',
				                            		SHT_SEQ:	shtSeq
				                            	};
				                            	//var callback = me.applyGridState;
				                            	extJsStateProviderService.deleteOne(param, function(){
				                            		me.applyGridState(me.baseShtInfo, me);
				                            		var comboStore = Ext.getCmp(me.id+'StateCombo').store;
				                            		var idx = comboStore.find('value',shtSeq);
				                            		comboStore.remove(comboStore.getAt(idx));
				                            	});		
		                            		//}
		                            	}
							        }
		                        }
		                  ]}
				};
				tbar[0].add(configBtn);
				
	        }
	        
	        //그리드 설정 빠른 목록 
	        if(!Ext.isEmpty(tbar) && this.uniOpt.state.useStateList) {
	        	this.stateList = Ext.create('Unilite.com.form.field.UniComboBox', {
	        		id:me.id+'StateCombo',
	        		comboType: 'BSA421',
	        		comboCode: UniAppManager.id + "__" + me.id,
	        		tpl : Ext.create('Ext.XTemplate',
				        '<tpl for=".">',
				            '<div class="x-boundlist-item"><div class="uni_combo_text">{text}</div></div>',	
				        '</tpl>'
				    ),
				    itemId:me.id+'_SHT_SEQ',
				    grow: true,	//필드의 내용에 따라 크기 조절됨.
				    minWidth: 150,
				    grid:me,
				    //maxWidth: 300,	//max 초과시 트리거 버튼이 안보이는 문제가 생김.
				    listeners: {
				    	'expand':function(field){
				    		var grid = me;
			    			if(grid.getStore() && grid.getStore().isDirty())	{
			    				Unilite.messageBox(UniUtils.getLabel('system.message.commonJS.grid.beforestatechange', '저장되지 않은 자료가 있습니다. 저장 후 그리드 설정을 선택하세요.'));
		    					field.collapse();
			    			}
				    	},
				    	'change': function(cb, newValue, oldValue, eOpts) {
				    			var grid = me;
				    			if(grid.getStore() && grid.getStore().isDirty())	{
			    					cb.setValue(oldValue);
			    					return;
				    			}
				    			if(!Ext.isEmpty(newValue)) {
						    		var param = {
			                    		PGM_ID: 	UniAppManager.id,
			                    		SHT_ID: 	me.id,
			                    		SHT_SEQ:	newValue
			                    	};
			                    	if(newValue == 0)	{
			                    		var provider = Ext.state.Manager.getProvider();
			                    		//console.log(" provider.state[me.id]", provider.state[me.id]);
			                    		if(me.baseShtInfo) {
			                    			UniAppManager.applyGridState2(me.baseShtInfo, me);
			                    		}
			                    	} else	{
			                    	me.setLoading(true);
							    		extJsStateProviderService.selectStateInfo(param, 
							    			function(provider, response) {					    				
							    				UniAppManager.applyGridState2(response.result, me);
							    				extJsStateProviderService.updateStateDefault(param, function(){});
							    				me.setLoading(false);
							    			}
							    		);
			                    	}
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
	        
        }

        me.on('afterrender', me._onAfterRender);

		me.on('cellcontextmenu', function( view, cell, cellIndex, record, row, rowIndex, event ) {
		//me.on('itemcontextmenu', function( grid, record, item, index, event, eOpts ) {			
			if(me.copiedRow != null ) {
				var tMenu = me.contextMenu.down('#pasteRecord');
				tMenu.enable();
			}
			me.clickedRecord = record;
			me.clickedRowIndex = rowIndex;
			//var position = view.getPositionByEvent(event);
			//me.select(rowIndex);
			var pos = new Ext.grid.CellContext(view).setPosition({row: rowIndex, column: cellIndex});
			var selModel = me.getSelectionModel();
			
			if(selModel.isCellModel) {
	            selModel.select(pos);
        	} else {
        		selModel.select(rowIndex);
        	}
        	
        	if(me.uniRowContextMenu)	{
				me._onItemcontextmenu(view, record, row, rowIndex, event);
			}
			
			if(!Ext.isEmpty(me.contextMenu.child())) {
				
				event.stopEvent();
				me.contextMenu.showAt(event.getXY());
				
				var childCnt = 0;
				Ext.each(me.contextMenu.items.items, function(item, idx){
					if(item.isVisible())	childCnt++;
				})
				
				if(childCnt == 0)	{
					me.contextMenu.hide();
				}
			}
			
		});
		
		me.on('beforeselect', function(selModel, record, index, eOpts ) {
			if(selModel.getLastSelected() !== record && me.uniOpt._selectionRecord.selected !== record) {    			
    			me.uniOpt._selectionRecord.selected = record;
    			
    			//console.log('selectionchangerecord event fired.');
    			this.fireEvent('selectionchangerecord', record);    			
    		}
		});
	
	},	// initComponent
	_onContainerclick:function(container, e, eOpts ){
		var me = this;
		//Grid cell이 아닌 빈 공간 클릭시 cell focus style 삭제
		var navi = me.getNavigationModel();
		if (navi && navi.cell) {
			if(navi.focusCls)	{
            	navi.cell.removeCls(navi.focusCls);
			}
        }
	},
	_onAfterRender: function(grid) {
		var me = grid;
		var view = me.getView();
		var map = new Ext.KeyMap(view.getEl(), [
		{
			key: Ext.EventObjectImpl.ENTER,
			fn: function(keyCode, e){ 
				var selModel = me.getSelectionModel();
				if(selModel && selModel.type != 'spreadsheet')	{
					if(me._getStoreEditable() ) {	
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
					           	if(pos.rowIdx === me.getStore().getCount()-1 && isLastColumn) {
					           		UniAppManager.app.onNewDataButtonDown();
					           	}
					        } 
			            }
					}else{
						me.fireEvent('onGridKeyDown', me, keyCode, e);	//팝업 그리드용 (각 onGridKeyDown 에서 기능 정의)
					}
				}
			}
		} 
		]);		
		
		if(me._isSummaryHide)	{
			var hasFeatures = false;
			var isLocked = false;
			
			if(me.lockedGrid)	{
				isLocked = true;
				if(me.lockedGrid.features)	{
					hasFeatures = true;
				}
			} else if(me.features)	{
				hasFeatures = true;
			}
			if(isLocked)	{
				if(hasFeatures)	{
					var lockedGrdFeatures = me.lockedGrid.features;
					Ext.each(lockedGrdFeatures, function(feature, idx) {
						if(feature.ftype == "uniGroupingsummary" || feature.ftype == "uniSummary")	{
							if(feature.view) { 
								feature.view.summaryFeature.summaryBar.setVisible(false);
								feature.view.summaryFeature.showSummaryRow = false;
							}
						}
					});
					var normalGrdFeatures = me.normalGrid.features;
					Ext.each(normalGrdFeatures, function(feature, idx) {
						if(feature.ftype == "uniGroupingsummary" || feature.ftype == "uniSummary")	{
							if(feature.view) { 
								feature.view.summaryFeature.summaryBar.setVisible(false);
								feature.view.summaryFeature.showSummaryRow = false;
							}
						}
					});
				}
			}else {
				if(hasFeatures)	{
					var grdFeatures = me.features;
					Ext.each(grdFeatures, function(feature, idx) {
						if(feature.ftype == "uniGroupingsummary" || feature.ftype == "uniSummary")	{
							summaryFeature = me.view.getFeature(feature.id);
							summaryFeature.view.summaryFeature.summaryBar.setVisible(false);
							summaryFeature.showSummaryRow = false;
						}
					});
				}
			}
		};
		

		setTimeout(function(){
			if(me && me.uniOpt)	{
				var grid = me;
				var grdId = me.id; 
				if(me.uniOpt.state == null)	{
					me.uniOpt.state = {sysState : {}};
				}
				me.uniOpt.state.sysState = { SHT_INFO : UniAppManager.getDbShtInfo(grdId), DEFAULT_YN : 'N', SHT_ID : grdId};
				if(!Ext.isEmpty(me.up('window')))	{
					me._onPopupGridShow();
				}
			}
		},1000);
		
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
		if(me.getStore() && me.getStore().isDirty())	{
			return;
		}
		if(me.stateList && stateInfo ) {
			var combo = me.stateList;
			if(stateInfo.SHT_SEQ)	{
				combo.setValueOnly(stateInfo.SHT_SEQ.toString());
				if(Ext.isEmpty(stateInfo.COLUMN_INFO) )	{
	            	if(stateInfo.SHT_SEQ == 0 )	{
	            		if(me.baseShtInfo) {
	            			UniAppManager.applyGridState2(me.baseShtInfo, me);
	            		}
	            	} else	{
	            		var param = {
    	            		PGM_ID: 	UniAppManager.id,
    	            		SHT_ID: 	me.id,
    	            		SHT_SEQ:	stateInfo.SHT_SEQ
    	            	};
	            		me.setLoading(true);
			    		extJsStateProviderService.selectStateInfo(param, 
			    			function(provider, response) {				
			    				if(me && me.isVisible())	{
			    					UniAppManager.applyGridState2(response.result, me);
			    					extJsStateProviderService.updateStateDefault(param, function(){});
			    				}
			    				me.setLoading(false);
			    			}
			    		);
	            	}
				} else {
					UniAppManager.applyGridState2(stateInfo, me);
				}
			} else {
				combo.setValue('0');
			}
		}
	},
	//db의 State 를 적용하고 State 목록의 선택값을 변경한다.
	applyGridState: function(stateInfo) {
		var me = this;
		if(me.getStore() && me.getStore().isDirty())	{
			return;
		}
    	if(stateInfo)	{
    		UniAppManager.applyGridState2(stateInfo, me); 
    	
    		this.fireEvent('statelistselect', this, stateInfo);
    	}
    },
    
	// 행이동시 
	_onSelectionchange:function( grid, selected, eOpts ) {
		var me = this;
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
        
        selected = grid.getSelection();
	},
	
	_onDeselect:function( selModel, record, index, eOpts )	{
		
	},
	//행추가시
	_onSelect:function( selModel, record, index, eOpts  )
	{
		var me = this;
        if(me.selType == 'rowmodel' && record)	{
        	var position = me.getView().getNavigationModel().getPosition();
        	var firstColumnIndex = 0;
        	
    		if(position && position.colIdx) {
    			firstColumnIndex = position.colIdx;
    		}else if(position == null &&(me.uniOpt.useRowNumberer || me.selType == 'spreadsheet'))	{
        		firstColumnIndex = 1;
        	} 
        	
        	//me.getNavigationModel().setPosition(index,firstColumnIndex);
        	//me.getView().refresh();
        }
	},
	
	_onLoad:function(store, records, successful, operation, eOpts )	{
		var me = this;
		
		if(me.uniOpt.useRowNumberer || me.selType == 'spreadsheet')	{
			var columns = me.getColumns();
			if(records) {
				if(records.length > 999) {				
					Ext.each(columns, function(column, idx){
						if(column.isRowNumberer)	{
							column.setWidth(50);
						}
					})
				}else {
					Ext.each(columns, function(column, idx){
						if(column.isRowNumberer)	{
							column.setWidth(35);
						}
					})
				}
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
			Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.grid.firstRow','자료의 처음입니다.'));			
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
			Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.grid.lastRow','자료의 마지막입니다.'));
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
            //var currentPosition = selModel.getCurrentPosition();
        	var currentPosition = selModel.getPosition();
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
    
	
	selectById: function(rowId) {
		var selModel = this.getSelectionModel();
       
        if(selModel.isCellModel) {
            //var currentPosition = selModel.getCurrentPosition();
        	var currentPosition = selModel.getPosition();
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
            var rowIndex = this.store.indexOf(this.store.getById(rowId));
            selModel.selectByPosition({row: rowIndex, column:newColumn});
        } else {
			
				selModel.deselectAll(); 
		    	selModel.select(this.store.getById(rowId));

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
                //columIndex = i+1;
            	columIndex = i;
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

	sortedSelectedRecords: function(grid)	{
    	var selectedRecords = grid.getSelectedRecords();
    	var rtn;
    	
    	if(selectedRecords && selectedRecords.length > 0)		{
	    	rtn = new Array();
	    	Ext.each(grid.getStore().data.items, 
					function(record,i){	
						if(selectedRecords.indexOf(record) > -1)	{
				        	rtn.push(record);			
						}
					}
			); 
    	}
    	return rtn;
    },
    
	/**
	 * 그리드 데이타 초기화 (Store 포함)
	 */
	reset:function() {
//		this.store.loadRecords({}, {addRecords: false});
//		this.store.clearData(); 
//		this.getStore().loadData({});
//		this.getStore().removeAll();
		var records = this.store.getData();
		if(records ) {
			this.getStore().remove(records.items);
		}
		this.view.refresh();		
	},
	_onBeforehide:function(grid)	{
		grid.getView().saveScrollState();
	},
	_onShow:function(grid)	{
//		if(grid.getEl()) {
//			if(grid.getView().scrollable)	{
//				grid.getView().getEl().scroll('bottom',grid.getEl().getScrollY(), true);
//				
//			} else {
//				grid.getView().getEl().scroll('bottom',1, true);
//			}
//		}
//			grid.getView().getEl().focus();

//			var selection = grid.getSelectionModel().getSelection();
//			if(selection)	{	
//				var rowIndex = grid.getStore().indexOf(selection[0])
//				Ext.fly(grid.getView().getNode(rowIndex)).scrollIntoView();
//			}else {
//				Ext.fly(grid.getView().getNode(0)).scrollIntoView();
//			}
//			grid.getView().getEl().scroll('bottom',grid.getView().getScrollY(), true);

			if(grid != null)	{
				var selection = grid.getSelectionModel().getSelection();

				if(selection)	{	

					var rowIndex = grid.getStore().indexOf(selection[0])
					//grid.getView().getEl().scroll('bottom',1, true)
					//grid.getView().focusRow(rowIndex);
					var grdView = grid.getView();
					if(grdView && grdView.lockedView)	{
						grdView = grdView.normalView
					}
					if(grdView.getRow(rowIndex) && Ext.isFunction(grdView.getRow(rowIndex).scrollIntoView))	{
						console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  scrollIntoView / ", rowIndex);
						grdView.getRow(rowIndex).scrollIntoView(grdView.getEl(), null, true);
					}else {
						console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  scroll('bottom',1, true) / ", rowIndex);
						grdView.getEl().scroll('bottom',1, true);
					}
					//Ext.defer(grid.setScrollTop, 30, grid, [grid.getView().scrollState.top])
				}else {
					if(grdView.getRow(0) && Ext.isFunction(grid.getView().getRow(0).scrollIntoView))	{
						console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  scrollIntoView / no Selection / ", rowIndex);
						grdView.getRow(0).scrollIntoView(grid.getView().getEl(), null, true);
					}else {
						console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  scroll('bottom',1, true) / no Selection / ", rowIndex);
						grdView.getEl().scroll('bottom',1, true);
					}
				}
			}
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
	},
	/**
	 * 
	 * @param {} form
	 */
	addChildForm:function(form) {
		if(!this.uniOpt.childForms){
			this.uniOpt.childForms = new Array();
		}
		this.uniOpt.childForms.push(form)
	}, 
	// private
	_onRenderFun: function(grid, selectFirst) {
		var me = this;
		if(selectFirst) {
			console.log("_onRenderFun : ", grid.getId()," ", selectFirst, grid.store);
			grid.store.on('load', function(store, records, successful, eOpts) {
				if(store.getCount() > 0 ) {
		         		grid.getSelectionModel().select(0);
		         		var colIndex = 0;
		         		var navi ;
		         		if(grid.ownerGrid && grid.ownerGrid.lockedGrid && grid.ownerGrid.lockedGrid.isLocked)	{
		         			grid.ownerGrid.lockedGrid.getView().focus();
		         			navi = grid.ownerGrid.lockedGrid.getView().getNavigationModel();
		         		}else {
		         			navi = grid.getView().getNavigationModel();
		         		}
		         		/*var columns = grid.getColumns();
		         		if(columns && columns.length > 1)	{
		         			if(columns[0].getXType() == "rownumberer") colIndex=1;
		         		}*/
		         		var currentRecord = grid.getSelectedRecord();
						if(currentRecord)	{
							var currRowIndex = grid.store.indexOf(currentRecord);
							// bufferedRenderer 에서 culumn position 이동 Bug로 인해 culumn position 먼저 이동
							try{
								if(grid && grid.uniOpt.useLoadFocus)	{
									navi.setPosition(currRowIndex,colIndex);
								}
							}catch(e){
								console.log(e);
							}
						}
		         		
		         		if(grid.normalGrid)	{
		         			var normalView = grid.normalGrid.view.getScrollable();
		         			normalView.scrollTo(0,grid.normalGrid.getScrollY(), false);
		         		} else {
		         			var scroll = grid.view.getScrollable();
		         			if(scroll)	{
		         				scroll.scrollTo(0,0,false);
		         			}
		         		}
						setTimeout(function(){
							try{
								if(grid && grid.uniOpt.useLoadFocus)	{
									navi.setPosition(0, colIndex)
								}
							}catch(e){
								console.log(e);
							}
						},10);
						me.getView().refresh();
				}
		     });
		} else {
			grid.store.on('load', function(store, records, successful, eOpts) {
				if(store.getCount() > 0 ) {
					var navi ;
	         		if(grid.ownerGrid && grid.ownerGrid.lockedGrid && grid.ownerGrid.lockedGrid.isLocked)	{
	         			grid.ownerGrid.lockedGrid.getView().focus();
	         			navi = grid.ownerGrid.lockedGrid.getView().getNavigationModel();
	         		}else {
	         			navi = grid.getView().getNavigationModel();
	         		}
	         		var currentRecord = grid.getSelectedRecord();
					if(currentRecord)	{
						var currRowIndex = grid.store.indexOf(currentRecord);
						// bufferedRenderer 에서 culumn position 이동 Bug로 인해 culumn position 먼저 이동
						try{
							if(grid && grid.uniOpt.useLoadFocus)	{
								navi.setPosition(currRowIndex,colIndex);
							}
						}catch(e){
							console.log(e);
						}
					}
		         		if(grid.normalGrid)	{
		         			var normalView = grid.normalGrid.view.getScrollable();
		         			normalView.scrollTo(0,grid.normalGrid.getScrollY(), false);
		         		} else {
		         			var scroll = grid.view.getScrollable();
		         			if(scroll)	{
		         				scroll.scrollTo(0,0,false);
		         			}
		         		}
						setTimeout(function(){
							try{
								navi.lastFocused = null;
								if(grid && grid.uniOpt.useLoadFocus)	{
								    if(grid.getColumns() && grid.getColumns()[0] &&  grid.getColumns()[0].xytpe == "checkcolumn")	{
								    	navi.setPosition(1, 0);
								    } else {
								    	navi.setPosition(0, 0);
								    }
								}
							}catch(e){
								console.log(e);
							}
						},10);
						me.getView().refresh();
				}
		     });
		}
		var provider = Ext.state.Manager.getProvider();
		
		provider.fireEvent("statechange", provider, provider.get(me.getId()), null);
	},	
	// private
	_onCellDblClickFun:function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
        	var ct = grid.headerCt.getHeaderAtIndex(cellIndex);
        	var colName = ct.dataIndex;
        	this.fireEvent('onGridDblClick',grid, record, cellIndex, colName);
    },

   _onCellclick:function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
   			var me = this
        	var editor = me.getEditor(me);
        	var	plugin = grid.editingPlugin;
        	
        	if(editor && plugin)	{
	            	plugin.startEdit(record, grid.ownerCt.getColumnManager().getHeaderAtIndex(cellIndex));
	            	if(plugin.getActiveColumn() ) {
	            		var targetField = plugin.activeColumn.field.el.down('.x-form-field');
						if(targetField) {
							targetField.focus(10);						
						}
	            	}
        	}
        	
    },
   _onCellKeyDown: function(view, cell, colIdx, record, row, rowIdx, e) {
    	// Make sure that the column has an editor.  In the case of CheckboxModel,
   	 	// calling startEdit doesn't make sense when the checkbox is clicked.
    	// Also, cancel editing if the element that was clicked was a tree expander.
    	console.log("e.getKey() : ",e.getKey() );
    	var me = this;
    	
    	if((me.getSelectionModel().type != 'spreadsheet' || me.selModel.checkSelector != undefined) && e.getKey() == 67 && e.ctrlKey )	{
    		if(window.clipboardData)	{
    			window.clipboardData.setData('text', cell.innerText);
    		}else {
    			var cellEl = cell.getElementsByClassName('x-form-field');
    			var cellElValue = "";
    			if(cellEl != undefined && cellEl[0] != undefined)	{
    				cellElValue = cellEl[0].value
    			} else {
    				cellElValue = cell.firstChild.innerHTML; 
    			}
    			var hiddentextarea = me._getHiddenTextArea();
				hiddentextarea.dom.value = cellElValue;//cell.firstChild.innerHTML; 
    			hiddentextarea.focus();	
    			hiddentextarea.dom.setSelectionRange(0, hiddentextarea.dom.value.length);
    			hiddentextarea.focus();	// firefox에서 setSelectionRange gn focus가 아웃됨
    		}
    	}
    	
        var expanderSelector = view.expanderSelector,
            columnHeader = view.ownerCt.getColumnManager().getHeaderAtIndex(colIdx);
            
        var grid = me;
    	if(me.lockedGrid)	{
    		try{
	    		if(me.lockedGrid.columns.indexOf(columnHeader) > -1) {
				    grid = me.lockedGrid;						    						    
			    } else {
			    	grid = me.normalGrid;
			    }
		    }catch(e)	{
		    	console.log(e);
		    }
    	}else {
        	 grid = me;
    	}
    	
        var editor = me.getEditor(me);
		var editable = true;
		if (view.getSelectionModel().isCellModel) {
			var selModel = view.selModel;
			var selection = selModel.selection;
			if( selection &&  selection.column == colIdx &&  selection.row == rowIdx) {
				editable = true;
			} else {
				editable = false;
			}
		}
        if (editor && editable && (!expanderSelector || !e.getTarget(expanderSelector)) ) {
        	var	plugin = view.ownerGrid.view.editingPlugin;
        	
        	if(plugin)	{
	            if(me._isValuableEvenv(e) && plugin.getActiveEditor() == null)	{
	            	plugin.startEdit(record, columnHeader);
	            	if(plugin.getActiveColumn() ) {
	            		if(plugin.getActiveColumn( ).field)	{
		            		plugin.getActiveColumn( ).field.setValue('');  // beforeedit return false  오류로 조건 처리
		            		// 크롬에서 cellkeydown 시 한글인 경우 한글 키가 입력이 되지 않고 영문키가 입력되어 추가된 코드 '가'의 경우 'rㅏ'로 입력됨
		            		if(Ext.isChrome &&  !(e.getKey() >= 48 && e.getKey() <= 57) &&  !(e.getKey() >= 96 && e.getKey() <= 105) )	{
		            			e.stopEvent();
		            		}
	            		}
	            		
	            	}
	            }else if(e.getKey() == e.ENTER && e.position.isLastColumn() && (me.getStore().getCount()-1) == e.position.rowIdx && !e.position.column.isLocked() && plugin.getActiveEditor() && me.uniOpt.enterKeyCreateRow)	{
		        	UniAppManager.app.onNewDataButtonDown();
		        	me.uniOpt.hasEnterKeyCreateRow = true;
		        	return;
		        }
				if(e.getKey() == 32 && e.target.id.indexOf('inputEl') == -1){
	            	plugin.startEdit(record, columnHeader);
	            	if(plugin.activeColumn && plugin.activeColumn.field && plugin.activeColumn.field.el)	{
		            	var targetField = plugin.activeColumn.field.el.down('.x-form-field');
						if(targetField) {
							targetField.focus(10);						
						}
	            	}
	            }else {
	            	return;	
	            }
        	}   
        } 
        
    },
    _onItemcontextmenu:function(view, record, item, index, event)	{
    	var me = view.ownerGrid;
    	event.preventDefault();
    	this.contextMenu.record = record;
    	if(me.onItemcontextmenu(me.contextMenu, view, record, item, index, event))	{
    		Ext.each(me.contextMenu.items.items, function(item, idx){
    			if(item.uniItemType && item.uniItemType.indexOf('row_context') > -1)	{
    				item.show();
    			}
    		}); 
    	}else {
    		Ext.each(me.contextMenu.items.items, function(item, idx){
    			if(item.uniItemType && item.uniItemType.indexOf('row_context') > -1)	{
    				item.hide();
    			}
    		}); 
    	}
    	// onItemcontextmenu 에서 각 item 별로 show/hide 한경우 적용을 위해 실행 ex)hpa950skr
    	me.onItemcontextmenu(me.contextMenu, view, record, item, index, event)
    },
    _isValuableEvenv: function(event) {
    	var chk = false;
		var key = event.getKey();
		if(!event.altKey && !event.ctrlKey)	{
			if( key >= 48 && key <= 90) {	// number, alphabet
				chk = true;
			} else if ( key >=96 && key <= 111) {	// numpad 
				chk = true;
			} else if ( key >=186 && key <= 192 || key >=219 && key <=222) {	// numpad 
				chk = true;
			}else if( key == 13)	{
				chk = false;//chk = true;
			}
		}
		//console.log("Key : " + key +" : charCode = " + event.getCharCode() + "   is " + chk);
    	return chk
    },
    _getHiddenTextArea:function(){
		if(!this.hiddentextarea){
    		this.hiddentextarea = new Ext.Element(document.createElement('textarea'));    		
    		this.hiddentextarea.setStyle('left','-1000px');
			this.hiddentextarea.setStyle('border','0px solid #ff0000');
			//this.hiddentextarea.setStyle('position','absolute');
			this.hiddentextarea.setStyle('top','0px');
			//this.hiddentextarea.setStyle('z-index','-1');
			//this.hiddentextarea.setStyle('margin-top','50px');
			this.hiddentextarea.setStyle('width','1px');
			this.hiddentextarea.setStyle('height','1px');
			this.hiddentextarea.setStyle('padding','0px');
    		//this.hiddentextarea.addListener('keyup', this.updateGridData, this);
    		//Ext.get(this.getEl().dom.firstChild).appendChild(this.hiddentextarea.dom);
			if(this.getEl().dom.lastChild.id.indexOf("loadmask")>-1)	{
				Ext.get(this.getEl().dom.firstChild).appendChild(this.hiddentextarea.dom);
			} else {
				Ext.get(this.getEl().dom.lastChild).appendChild(this.hiddentextarea.dom);
			}
    	}
    	return this.hiddentextarea;
    },
    
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

		
		var msg = '', pMsg='';
		errors.items.forEach(function(entry) {
			var field = me._getField(fields, entry.field);
			msg = msg + field.text + ': ' + entry.message + '\n';
		});		
	
		//msg = (rowIndex+1) + UniUtils.getMessage('system.message.commonJS.grid.invalidColumn','행의 입력값을 확인해 주세요.')+'\n' + msg ;
		//alert(msg);
		pMsg = (rowIndex+1) + UniUtils.getMessage('system.message.commonJS.grid.invalidColumn','행의 입력값을 확인해 주세요.')
		
		Unilite.messageBox(pMsg, msg, CommonMsg.errorTitle.ERROR, {'showDetail':true} );
		
		var view = me.getView();
    	var navi = view.getNavigationModel();
    	var columns = me.getVisibleColumns();
		
		Ext.each(columns, function(item, idx) {
			if(item.dataIndex && item.dataIndex == column)	{
				columnIndex = idx;
			}
		});
		
		var currentRecord = me.getSelectedRecord();
		if(currentRecord)	{
			var currRowIndex = me.store.indexOf(currentRecord);
			// bufferedRenderer 에서 culumn position 이동 Bug로 인해 culumn position 먼저 이동
			navi.setPosition(currRowIndex,columnIndex);
		}
		var selModel = me.getSelectionModel();
			
	    selModel.select(rowIndex);
	            
		navi.setPosition(rowIndex,columnIndex);
		var	plugin = view.editingPlugin;
    	if(plugin)	{
            if(plugin.getActiveEditor() == null)	{
            	var columnHeader = me.getColumnManager().getHeaderAtIndex(columnIndex);
            	plugin.startEdit(invalidRec, columnHeader);
            }
    	}
		//var cell = me.getView().getCell(invalidRec, columnIndex);
		//Ext.fly(cell.el.dom).focus();
				
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
	        	Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.grid.selectCell','붙여넣기 하기 전에 셀을 선택하세요.'));	
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

    	if(me._getStoreEditable() && me.uniOpt.copiedRow) {
			
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
					          		var record = me.copiedRow.copy(null).data;	//clone the record but no id (one is generated)
						          	if(!me.hasListeners.beforepasterecord || me.fireEvent('beforePasteRecord',  me.clickedRowIndex, record) !== false) {
						        		me.createRow(record, 0, me.clickedRowIndex);
						        		me.fireEvent('afterPasteRecord',  me.clickedRowIndex, record);
					          		}
					          	}
					        }
					    })	
				);
		}
    	
		if(me.uniRowContextMenu) {
			if(me._getStoreEditable() &&  me.uniOpt.copiedRow) me.contextMenu.add(Ext.create('Ext.menu.Separator', { uniItemType:'row_context_separator'}));
			Ext.each(me.uniRowContextMenu.items, function(item, idx){
				Ext.apply(item, {iconCls:'icon-link', uniItemType:'row_context_'+me.getId()+'_'+idx})
				me.contextMenu.add( Ext.create('Ext.menu.Item', item));
				
			})
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
    },
    isRowSelected:function(selected)	{
    	var me = this;
    	var r = true;
    	if(me.selType == 'spreadsheet')		{
			if(!(selected.selectedRecords && selected.selectedRecords.items.length > 0) )	{
					r = false;
			}
    	}else if(me.getSelection() && me.getSelection().length < 1)	{
    		r= false;
    	}
    	return r
    },
    getSpreadSheetRow : function(selected)	{
    	var me = this;
    	var r = [];
    	if(me.selType == 'spreadsheet')		{
			if(selected.selectedRecords && selected.selectedRecords.items.length > 0 )	{
				r = selected.selectedRecords.items;				
			}
    	}
    	return r
    },
    
	/**
     * Row 전체에  pointer(손모양) 마우스 사용해야 할 경우 실행
     * cell에만 적용시 column의 renderer 에서 style sheet class "cursor-pointer" 사용
     * @param {} view
     * @param {} item
     */
    setCellPointer:function(view, item)	{
		var tbody = view.getNode(item.id).childNodes[0];
  		var tds = tbody.childNodes[0].childNodes;
  		Ext.each(tds, function(td, idx){
  			td.setAttribute('style',td.getAttribute('style') +'cursor:pointer !important;');
  		})
	},
	changeFocusCls:function(prevGrid)	{
		if(prevGrid)	{
			if(typeof prevGrid === 'string')	{
				var npervGrid = Ext.getCmp(prevGrid);
				if(npervGrid)	{
					npervGrid.removeBodyCls("grid-select");
				}
			} else {
				prevGrid.removeBodyCls("grid-select");
			}
		}
		this.addBodyCls("grid-select");
	},
	setShowSummaryRow: function(b){
		var me = this;
		var hasFeatures = false;
			var isLocked = false;
			
			if(me.lockedGrid)	{
				isLocked = true;
				if(me.lockedGrid.features)	{
					hasFeatures = true;
				}
			} else if(me.features)	{
				hasFeatures = true;
			}
			if(isLocked)	{
				if(hasFeatures)	{
					var lockedGrdFeatures = me.lockedGrid.features;
					var viewLocked = me.lockedGrid.getView();
					var viewNormal = me.normalGrid.getView();
					Ext.each(lockedGrdFeatures, function(feature, idx) {
						if( feature.ftype == "uniSummary")	{
							var lockedSummary = viewLocked.getFeature(feature.id);
							var lockedSummaryBar = lockedSummary.summaryBar;
							if(lockedSummaryBar)	{
								lockedSummaryBar.setVisible(b);
								lockedSummary.showSummaryRow = b;
							}
						}else if(feature.ftype == "uniGroupingsummary" ) {
							var lockedGroupSummary = viewLocked.getFeature(feature.id);
							lockedGroupSummary.showSummaryRow = b;
							
						}
					});
					var normalGrdFeatures = me.normalGrid.features;
					Ext.each(normalGrdFeatures, function(feature, idx) {
						if( feature.ftype == "uniSummary")	{
							var summary = viewNormal.getFeature(feature.id);
							var summaryBar = summary.summaryBar;
							if(summaryBar)	{
								summaryBar.setVisible(b);
								summary.showSummaryRow = b;
							}
						}else if(feature.ftype == "uniGroupingsummary") {
							var groupSummary = viewNormal.getFeature(feature.id);
							groupSummary.showSummaryRow = b;
							setTimeout(function() {me.view.refresh();},1000);
						}
					});

				}
			}else {
				if(hasFeatures)	{
					var grdFeatures = me.features;
					Ext.each(grdFeatures, function(feature, idx) {
						if( feature.ftype == "uniSummary")	{
							var summaryFeature = me.view.getFeature(feature.id);
							var summaryFeatureBar = summaryFeature.view.summaryFeature.summaryBar;
							if(summaryFeatureBar)	{
								summaryFeatureBar.setVisible(b);
								summaryFeature.showSummaryRow = b;
							}
						} else if(feature.ftype == "uniGroupingsummary" )	{
							var groupSummary = me.view.getFeature(feature.id);
							groupSummary.showSummaryRow = b;
							setTimeout(function() {me.view.refresh();},1000);
						}
					});
					
				}
			}
	},
	setPivotFieldsStore : function()	{
		var me = this;
		var fieldStore ;
		
		if(me.config.columns)	{
        	
        	var fields = this.store.model.getFields();
        	var columns = new Array();
        	var columnData = new Array();
        	Ext.each(fields, function(field, idx){
        		var column =  me.getColumn(field.name);
        		if (column != null && column.xtype != 'actioncolumn' && column.xtype != 'rownumberer'&& column.xtype != 'checkcolumn' && (column.dataIndex != ''&& column.dataIndex != null) && (column.dataIndex != '*') ) {
        			columns.push(column);
        			columnData.push({
        					'name' : column.dataIndex,
        					'text' : column.text,
        					'type' : field.type,
        					'hidden' : column.hidden
        			});
        		}
        	});
        	if(Ext.isEmpty(Ext.data.StoreManager.lookup(me.getId()+'PIVOTFieldStore'))){
        		fieldStore = Ext.create('Ext.data.Store',{
	        		id : me.getId()+'PIVOTFieldStore',
	        		fields: [
	        			 {name: 'name' 		,type:'string'	},
		   				 {name: 'text' 	    ,type:'string'	},
		   				 {name: 'type' 	    ,type:'string'	},
		   				 {name: 'hidden' 	,type:'string'	}
		   			],
	        		data  : columnData
	        	})
        	} else {
        		fieldStore = Ext.data.StoreManager.lookup(me.getId()+'PIVOTFieldStore');
				fieldStore.loadData(columnData);
        	}
        }
    	return fieldStore;
	},
	getMergedColumText:function(columns, idx )	{
		
	},
	refreshPivotFieldsStore : function()	{
		
	},
	_onPopupGridShow : function()	{
		var me = this;
		if(me.uniOpt.userToolbar && me.uniOpt.state.useState)	{
			var stateInfo = UniAppManager.getStateInfo(me.id);
	    	if(Ext.isDefined(stateInfo)) {
	    		if(!Ext.isEmpty(stateInfo)) {
	    			me.fireEvent('statelistselect', me, stateInfo);	
	    		}
	    	}
		}
	}
});
