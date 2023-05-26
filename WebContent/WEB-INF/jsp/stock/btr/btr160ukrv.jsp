<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="btr160ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="btr160ukrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="O"  comboCode="A" /> 	<!- 창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var SearchWindow;
function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('btr160ukrvLOTModel', {
	    fields: [  	  
	    	{name: 'COMP_CODE'				,text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'			,type: 'string'},
		    {name: 'DIV_CODE'				,text: '<t:message code="system.label.inventory.division" default="사업장"/>'				,type: 'string' ,comboType:"BOR120"},
		    {name: 'WH_CODE'				,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'				,type: 'string',comboType:"O"  ,comboCode:"A"},
		    {name: 'ITEM_CODE'				,text: '<t:message code="system.label.inventory.item" default="품목"/>'			,type: 'string'},
		    {name: 'ITEM_NAME'				,text: '품목코드명'			,type: 'string'},
		    {name: 'SPEC'					,text: '<t:message code="system.label.inventory.spec" default="규격"/>'				,type: 'string'},
		    {name: 'PURCHASE_CUSTOM_CODE'	,text: '<t:message code="system.label.inventory.purchaseplace" default="매입처"/>'			,type: 'string'},
		    {name: 'CUSTOM_NAME'			,text: '매입처'				,type: 'string'},
		    {name: 'PURCHASE_RATE'			,text: '<t:message code="system.label.inventory.purchaserate" default="매입율"/>'				,type: 'uniPercent'},
		    {name: 'PURCHASE_P'				,text: '<t:message code="system.label.inventory.purchaseprice" default="매입가"/>'				,type: 'uniUnitPrice'},
		    {name: 'LOT_NO'					,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			    ,type: 'string'},  
		    {name: 'STOCK_Q'				,text: '현재고량'			,type: 'uniQty'}
		    
		]
	}); 

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var lotStore = Unilite.createStore('btr160ukrvLOTStore',{
		model: 'btr160ukrvLOTModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'btr160ukrvService.lotStockList'                	
            }
        },
        loadStoreRecords : function()	{
        	var sform = Ext.getCmp('searchForm');
        	if(sform.isValid())	{
				var param= sform.getValues();		
				console.log( param );
				this.load({
					params : param
				});
        	}
		}	
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('btr160ukrvMoveModel', {
	    fields: [  	  
	    	{name: 'COMP_CODE'				,text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'			,type: 'string'		, editable:false},
		    {name: 'DIV_CODE'				,text: '<t:message code="system.label.inventory.division" default="사업장"/>'				,type: 'string'		, editable:false,comboType:"BOR120"},
		    {name: 'STOCKMOVE_NUM'			,text: '이동변호'			,type: 'string'		, editable:false},
		    {name: 'STOCKMOVE_SEQ'			,text: '<t:message code="system.label.inventory.seq" default="순번"/>'				,type: 'int'		, editable:false},
		    {name: 'STOCKMOVE_DATE'			,text: '이동일'				,type: 'uniDate'	, editable:false},
		    
		   	{name: 'WH_CODE'				,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'				,type: 'string'		, editable:false,comboType:"O"  ,comboCode:"A"},
		    {name: 'WH_CELL_CODE'			,text: '창고 Cell 코드'		,type: 'string'		, editable:false},
		    
		    {name: 'ITEM_CODE'				,text: '<t:message code="system.label.inventory.item" default="품목"/>'			,type: 'string'		, editable:false},
		    {name: 'ITEM_NAME'				,text: '품목코드명'			,type: 'string'		, editable:false},
		    {name: 'SPEC'					,text: '<t:message code="system.label.inventory.spec" default="규격"/>'				,type: 'string'		, editable:false},
		    {name: 'FR_PURCHASE_CUSTOM_CODE',text: '<t:message code="system.label.inventory.purchaseplace" default="매입처"/>'			,type: 'string'		, editable:false},
		    {name: 'FR_CUSTOM_NAME'			,text: '매입처'				,type: 'string'		, editable:false},
		    {name: 'FR_PURCHASE_RATE'		,text: '<t:message code="system.label.inventory.purchaserate" default="매입율"/>'				,type: 'uniPercent'	, editable:false},
		    {name: 'FR_PURCHASE_P'			,text: '<t:message code="system.label.inventory.purchaseprice" default="매입가"/>'				,type: 'uniUnitPrice'	, editable:false},
		    {name: 'LOT_NO'					,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			    ,type: 'string'		, editable:false},  
		    
		    {name: 'TO_PURCHASE_CUSTOM_CODE',text: '<t:message code="system.label.inventory.purchaseplace" default="매입처"/>'			,type: 'string'		, editable:false},
		    {name: 'TO_CUSTOM_NAME'			,text: '매입처'				,type: 'string'		, editable:false},
		    {name: 'TO_PURCHASE_RATE'		,text: '<t:message code="system.label.inventory.purchaserate" default="매입율"/>'				,type: 'uniPercent'	, editable:false},
		    {name: 'TO_PURCHASE_P'			,text: '<t:message code="system.label.inventory.purchaseprice" default="매입가"/>'				,type: 'string'		, editable:false},
		    {name: 'TO_LOT_NO'				,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			    ,type: 'string'		, editable:false},  
		    
		    {name: 'STOCKMOVE_Q'			,text: '이동량'				,type: 'uniQty'		, editable:true},
		    
		    {name: 'REMARK'					,text: '<t:message code="system.label.inventory.remarks" default="비고"/>'				,type: 'string'		, editable:true}			
		]
	}); 
	
		
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'btr160ukrvService.moveList',
			create: 'btr160ukrvService.insert',
			destroy: 'btr160ukrvService.delete',
			syncAll: 'btr160ukrvService.saveAll'
		}
	});	
	var moveStore = Unilite.createStore('btr160ukrvMoveStore',{
		model: 'btr160ukrvMoveModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
		,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{			
					moveStore.syncAllDirect(config);	
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */				
	var popupDirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'btr160ukrvService.movePopupList'
		}
	});	
	var popupStore = Unilite.createStore('btr160ukrvPopupStore',{
		model: 'btr160ukrvMoveModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: popupDirectProxy,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('popupSearch').getValues();			
			this.load({
				params : param
			});
		}	
	});	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 2},
           	defaultType: 'uniTextfield',
		    items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120',
	        	allowBlank:false,
	        	colspan: 2,
	        	listeners:{
	        		change:function(field, newValue)	{
	        			panelResult.setValue('DIV_CODE', newValue);
	        		}
	        	}
			},{
	        	fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
	        	name: 'WH_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'O',
	        	comboCode:'A',
	        	allowBlank:false,
	        	colspan: 2,
	        	listeners:{
	        		change:function(field, newValue)	{
	        			panelResult.setValue('WH_CODE', newValue);
	        		}
	        	}
	        },Unilite.popup('DIV_PUMOK',{ 
					colspan: 2,
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		   }),{
				fieldLabel: '이동일',
				xtype: 'uniDatefield',
				name: 'STOCKMOVE_DATE',
				value: UniDate.today(),
				allowBlank: false,
				colspan: 2,
	        	listeners:{
	        		change:function(field, newValue)	{
	        			panelResult.setValue('STOCKMOVE_DATE', newValue);
	        		}
	        	}
			},{
	        	fieldLabel: '이동번호',
	        	name: 'STOCKMOVE_NUM', 
	        	listeners:{
	        		change:function(field, newValue)	{
	        			panelResult.setValue('STOCKMOVE_NUM', newValue);
	        		}
	        	}
	        },{
	        	xtype:'button',
	        	text:'이동번호조회',
	        	tdAttrs:{style:'padding-left:3px'},
	        	handler:function()	{
	        		openSearchWindow();
	        	}
	        },{
	        	xtype:'checkboxfield',
	        	boxLabel: '현재고 0 포함',
	        	name: 'INCLUDE_ZERO',
	        	inputValue : 'Y',
	        	tdAttrs:{'style':'padding-left:95px'},
	        	colspan:2,
	        	listeners:{
	        		change:function(field, newValue)	{
	        			if(newValue)	{
	        				panelResult.setValue('INCLUDE_ZERO', 'Y')	        
	        			}else {
	        				panelResult.setValue('INCLUDE_ZERO', '')	
	        			}
	        		}
	        	}
	        }]
		}]
    }); 
    
    var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{	
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120',
	        	allowBlank:false,
	        	listeners:{
	        		change:function(field, newValue)	{
	        			panelSearch.setValue('DIV_CODE', newValue);
	        		}
	        	}
			},{
	        	fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
	        	name: 'WH_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'O',
	        	comboCode:'A',
	        	allowBlank:false,
	        	listeners:{
	        		change:function(field, newValue)	{
	        			panelSearch.setValue('WH_CODE', newValue);
	        		}
	        	}
	        },Unilite.popup('DIV_PUMOK',{ 
		        	fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
		        	valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
					colspan:2,
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
								panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
		   }),{
				fieldLabel: '이동일',
				xtype: 'uniDatefield',
				name: 'STOCKMOVE_DATE',
				value: UniDate.today(),
				allowBlank: false,
	        	listeners:{
	        		change:function(field, newValue)	{
	        			panelSearch.setValue('STOCKMOVE_DATE', newValue);
	        		}
	        	}
			},{
	        	fieldLabel: '이동번호',
	        	name: 'STOCKMOVE_NUM', 
	        	listeners:{
	        		change:function(field, newValue)	{
	        			panelSearch.setValue('STOCKMOVE_NUM', newValue);
	        		}
	        	}
	        },{
	        	xtype:'button',
	        	text:'이동번호조회',
	        	tdAttrs:{style:'padding-left:3px'},
	        	handler:function()	{
	        		openSearchWindow();
	        	}
	        },{
	        	xtype:'checkboxfield',
	        	boxLabel: '현재고 0 포함',
	        	name: 'INCLUDE_ZERO',
	        	tdAttrs:{'align' :'right'},
	        	inputValue : 'Y',
	        	listeners:{
	        		change:function(field, newValue)	{
	        			if(newValue)	{
	        				panelSearch.setValue('INCLUDE_ZERO', 'Y')	        
	        			}else {
	        				panelSearch.setValue('INCLUDE_ZERO', '')	
	        			}
	        			
	        		}
	        	}
	        }]
	
    }); 
	
    /**
     * lotGrid 정의(Grid Panel)
     * @type 
     */
    
    var lotGrid = Unilite.createGrid('btr160ukrLOTvGrid', {
    	flex:.5,
    	region:'center',
        store : lotStore, 
        selModel:'rowmodel',
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        viewConfig: {
        	itemId:'lotStockGrid',
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'gridviewdragdrop',
                copy : true,
                enableDrop: false
            }
        },
        columns: [   
			{dataIndex: 'DIV_CODE'						, width: 100 }, 
			{dataIndex: 'WH_CODE'						, width: 100 }, 
			{dataIndex: 'ITEM_CODE'						, width: 100  },
			{dataIndex: 'ITEM_NAME'						, width: 150 },
			{dataIndex: 'SPEC'							, width: 100 }, 
			{dataIndex: 'CUSTOM_NAME'					, width: 100 },
			{dataIndex: 'PURCHASE_RATE'					, width: 80 },
			{dataIndex: 'PURCHASE_P'					, width: 80 }, 
			{dataIndex: 'LOT_NO'						, width: 120},
			{dataIndex: 'STOCK_Q'						, width: 80 }
		] 
    });

    /**
     * moveGrid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('btr160ukrMovevGrid', {
    	flex:.5,
    	region:'south',
        store : moveStore, 
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
        viewConfig: {
        	itemId:'moveGrid',
        	ddGroup: 'dataGroup',
            /*plugins: {
                ddGroup: 'dataGroup',
                ptype: 'celldragdrop',
                onCellDrop:function(target, dd, e, dragData)	{
                	
                }
            },*/
            listeners:{
            	render:function(view){
            		var me = view;
            			me.dropZone = new Ext.dd.DropZone(view.el, {
		                view: view,
		                ddGroup: me.dropGroup || me.ddGroup,
		                containerScroll: true,
					    frDropColumns : [
					    				'FR_CUSTOM_NAME'	,'FR_PURCHASE_RATE'
										,'FR_PURCHASE_P'	,'LOT_NO'
										],
						toDropColumns : [
										'TO_CUSTOM_NAME'	,'TO_PURCHASE_RATE'
										,'TO_PURCHASE_P'	,'TO_LOT_NO'
										],
		                getTargetFromEvent: function (e) {
		                    var self = this,
		                        view = self.view,
		                        cell = e.getTarget(view.cellSelector),
		                        row, header;
		
		                    // Ascertain whether the mousemove is within a grid cell.
		                    if (cell) {
		                        row = view.findItemByChild(cell);
		                        header = view.getHeaderByCell(cell);
		
		                        if (row && header) {
		                            return {
		                                node: cell,
		                                record: view.getRecord(row),
		                                columnName: header.dataIndex
		                            };
		                        }
		                    }
		                },
		
		                // On Node enter, see if it is valid for us to drop the field on that type of column.
		                onNodeEnter: function (target, dd, e, dragData) {
		                    var self = this;
		                        //destType = target.record.getField(target.columnName).type.toUpperCase(),
		                        //sourceType = dragData.records[0].getField(dragData.columnName).type.toUpperCase();
		
		                    delete self.dropOK;
		
		                   
		                    // Return if no target node or if over the same cell as the source of the drag.
		                    if (!target || target.node === dragData.item.parentNode) {
		                        return;
		                    }
		            
							if (!target.record.isNew()) {
		                        return;
		                    }
		                    if(this.frDropColumns.indexOf(target.columnName) < 0 && this.toDropColumns.indexOf(target.columnName) < 0)	{
		                    	return ;
		                    }
		                    
		                    if(dragData.records[0].get('ITEM_CODE') != target.record.get('ITEM_CODE') )	{
		                    	return ;
		                    }
		                    
		
		                    self.dropOK = true;
		
		                    if (me.dropCls) {
		                        Ext.fly(target.node).addCls(me.dropCls);
		                    } else {
		                        Ext.fly(target.node).applyStyles({
		                            backgroundColor: me.dropBackgroundColor
		                        });
		                    }
		                },
		
		                // Return the class name to add to the drag proxy. This provides a visual indication
		                // of drop allowed or not allowed.
		                onNodeOver: function (target, dd, e, dragData) {
		                    return this.dropOK ? this.dropAllowed : this.dropNotAllowed;
		                },
		
		                // Highlight the target node.
		                onNodeOut: function (target, dd, e, dragData) {
		                    var cls = this.dropOK ? me.dropCls : me.noDropCls;
		
		                    if (cls) {
		                        Ext.fly(target.node).removeCls(cls);
		                    } else {
		                        Ext.fly(target.node).applyStyles({
		                            backgroundColor: ''
		                        });
		                    }
		                },
		
		                // Process the drop event if we have previously ascertained that a drop is OK.
		                onNodeDrop: function (target, dd, e, dragData) {
		                    if (this.dropOK) {
		                    	if(this.frDropColumns.indexOf(target.columnName) >= 0 )	{
		                    		if(target.record.get('TO_LOT_NO') != dragData.records[0].get('LOT_NO'))	{
			                    		target.record.set('FR_CUSTOM_NAME'	, dragData.records[0].get('CUSTOM_NAME'));
			                    		target.record.set('FR_CUSTOM_CODE'	, dragData.records[0].get('PURCHASE_CUSTOM_CODE'));
			                    		target.record.set('FR_PURCHASE_RATE', dragData.records[0].get('PURCHASE_RATE'));
			                    		target.record.set('FR_PURCHASE_P'	, dragData.records[0].get('PURCHASE_P'));
			                    		target.record.set('LOT_NO'			, dragData.records[0].get('LOT_NO'));
		                    		}else {
		                    			alert('원LOT와 대상LOT가 같습니다.');
		                    		}
		                    	}
		                    	if( this.toDropColumns.indexOf(target.columnName) >= 0)	{
		                    		if(target.record.get('LOT_NO') != dragData.records[0].get('LOT_NO'))	{
										target.record.set('TO_CUSTOM_NAME'			, dragData.records[0].get('CUSTOM_NAME'));
			                    		target.record.set('TO_PURCHASE_CUSTOM_CODE'	, dragData.records[0].get('PURCHASE_CUSTOM_CODE'));
			                    		target.record.set('TO_PURCHASE_RATE'		, dragData.records[0].get('PURCHASE_RATE'));
			                    		target.record.set('TO_PURCHASE_P'			, dragData.records[0].get('PURCHASE_P'));
			                    		target.record.set('TO_LOT_NO'				, dragData.records[0].get('LOT_NO'));
		                    		}else {
		                    			alert('원LOT와 대상LOT가 같습니다.');
		                    		}
		                    	}
		                    	
		                        return true;
		                    }
		                },
		
		                onCellDrop: function()	{return null}
		            });
            	}
            }
        },
        columns: [   
			{dataIndex: 'DIV_CODE'						, width: 100 }, 
			{dataIndex: 'STOCKMOVE_SEQ'					, width: 45  },
			{dataIndex: 'WH_CODE'						, width: 100 }, 
			{dataIndex: 'ITEM_CODE'						, width: 100 },
			{dataIndex: 'ITEM_NAME'						, width: 150 },
			{dataIndex: 'SPEC'							, width: 100 },
			{text:'원LOT정보',
				columns: [
					{dataIndex: 'FR_CUSTOM_NAME'		, width: 100 }, 
					{dataIndex: 'FR_PURCHASE_RATE'		, width: 70 }, 
					{dataIndex: 'FR_PURCHASE_P'			, width: 80},
					{dataIndex: 'LOT_NO'				, width: 120 },
					{
			            xtype:'actioncolumn',
			            width:30,
			            items: [{
			                icon: CPATH+'/resources/css/icons/upload_delete.png',
			                tooltip: 'Clear',
			                handler: function(grid, rowIndex, colIndex) {
			                	var record = masterGrid.store.getAt(rowIndex);
			                	if(record.isNew())	{
				                    record.set('FR_CUSTOM_NAME'	, "");
		                    		record.set('FR_CUSTOM_CODE'	, "");
		                    		record.set('FR_PURCHASE_RATE', 0);
		                    		record.set('FR_PURCHASE_P'	, 0);
		                    		record.set('LOT_NO'			, "");
			                	}
			                }
			            }]
			        }
				]
			},
			{text:'대상LOT정보',
				columns: [
					{dataIndex: 'TO_CUSTOM_NAME'		, width: 100 }, 
					{dataIndex: 'TO_PURCHASE_RATE'		, width: 70 }, 
					{dataIndex: 'TO_PURCHASE_P'			, width: 80},
					{dataIndex: 'TO_LOT_NO'				, width: 120 },
					{
			            xtype:'actioncolumn',
			            width:30,
			            items: [{
			                icon: CPATH+'/resources/css/icons/upload_delete.png',
			                tooltip: 'Clear',
			                handler: function(grid, rowIndex, colIndex) {
			                	var record = masterGrid.store.getAt(rowIndex);
			                	if(record.isNew())	{
				                    record.set('TO_CUSTOM_NAME'	, "");
		                    		record.set('TO_CUSTOM_CODE'	, "");
		                    		record.set('TO_PURCHASE_RATE', 0);
		                    		record.set('TO_PURCHASE_P'	, 0);
		                    		record.set('TO_LOT_NO'			, "");
			                	}
			                }
			            }]
			        }
				]
			},
			{dataIndex: 'STOCKMOVE_Q'					, width: 80 },
			{dataIndex: 'REMARK'						, flex: 1 }
			
		] ,
		listeners:{
			beforeedit:function( editor, context, eOpts )	{
				if(!context.record.isNew())	{
					return false;
				}
			}
		}
    });
    	
    
    var popupSearch = Unilite.createSearchForm('popupSearch',{
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120',
	        	allowBlank:false
			},{
	        	fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
	        	name: 'WH_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'O',
	        	comboCode:'A',
	        	allowBlank:false
	        },Unilite.popup('DIV_PUMOK',{ 
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': popupSearch.getValue('DIV_CODE')});
						}
					}
		   ),{
				fieldLabel: '이동일',
				xtype: 'uniDatefield',
				name: 'STOCKMOVE_DATE',
				value: UniDate.today(),
				allowBlank: false
			},{
	        	fieldLabel: '이동번호',
	        	name: 'STOCKMOVE_NUM'
	        }]
    }); 
	
    
    var popupGrid = Unilite.createGrid('btr160ukrPopupvGrid', {
        store : popupStore, 
        selModel:'rowmodel',
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
        columns: [   
			{dataIndex: 'DIV_CODE'						, width: 100 }, 
			{dataIndex: 'STOCKMOVE_NUM'					, width: 100 }, 
			{dataIndex: 'STOCKMOVE_SEQ'					, width: 45  },
			{dataIndex: 'WH_CODE'						, width: 60 }, 
			{dataIndex: 'ITEM_NAME'						, width: 150 },
			{dataIndex: 'SPEC'							, width: 100 },
			{text:'원LOT정보',
				columns: [
					{dataIndex: 'FR_CUSTOM_NAME'		, width: 80 }, 
					{dataIndex: 'FR_PURCHASE_RATE'		, width: 70 }, 
					{dataIndex: 'FR_PURCHASE_P'			, width: 80},
					{dataIndex: 'LOT_NO'				, width: 110 }
				]
			},
			{text:'대상LOT정보',
				columns: [
					{dataIndex: 'TO_CUSTOM_NAME'		, width: 80 }, 
					{dataIndex: 'TO_PURCHASE_RATE'		, width: 70 }, 
					{dataIndex: 'TO_PURCHASE_P'			, width: 80},
					{dataIndex: 'TO_LOT_NO'				, width: 110 }
				]
			},
			{dataIndex: 'STOCKMOVE_Q'					, width: 80 }
			
		],
		listeners:{
			onGridDblClick:function(grid, record, cellIndex, colName) {
				panelSearch.setValue('STOCKMOVE_NUM', record.get('STOCKMOVE_NUM'));
				panelSearch.setValue('DIV_CODE', record.get('DIV_CODE'));
				panelSearch.setValue('WH_CODE', record.get('WH_CODE'));
				panelSearch.setValue('ITEM_CODE', record.get('ITEM_CODE'));
				panelSearch.setValue('ITEM_NAME', record.get('ITEM_NAME'));
				panelSearch.setValue('STOCKMOVE_DATE', record.get('STOCKMOVE_DATE'));
				panelSearch.setReadOnly(true);
				
				panelResult.setValue('STOCKMOVE_NUM', record.get('STOCKMOVE_NUM'));
				panelResult.setValue('DIV_CODE', record.get('DIV_CODE'));
				panelResult.setValue('WH_CODE', record.get('WH_CODE'));
				panelResult.setValue('ITEM_CODE', record.get('ITEM_CODE'));
				panelResult.setValue('ITEM_NAME', record.get('ITEM_NAME'));
				panelResult.setValue('STOCKMOVE_DATE', record.get('STOCKMOVE_DATE'));
				panelResult.setReadOnly(true);
				
				
					    		
				SearchWindow.close();
			}
		}
    });
    
    function openSearchWindow() {
		
		if(!SearchWindow) {
			SearchWindow = Ext.create('widget.uniDetailWindow', {
                title: '이동번호검색',
                width: 830,				                
                height: 580,
                layout: {type:'vbox', align:'stretch'},	                
                items: [popupSearch, popupGrid],
                tbar:  ['->',
								        {	itemId : 'searchBtn',
											text: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
											handler: function() {
												popupStore.loadStoreRecords();
											},
											disabled: false
										}, {
											itemId : 'closeBtn',
											text: '<t:message code="system.label.inventory.close" default="닫기"/>',
											handler: function() {
												SearchWindow.hide();
											},
											disabled: false
										}
							    ],
				listeners : {beforehide: function(me, eOpt)	{
											popupSearch.clearForm();
											popupGrid.reset();              							
                						},
                			 beforeclose: function( panel, eOpts )	{
											popupSearch.clearForm();
											popupGrid.reset();
                			 			},
                			 show: function( panel, eOpts )	{
                			 	popupSearch.setValue('DIV_CODE'			,panelSearch.getValue('DIV_CODE'));
					    		popupSearch.setValue('WH_CODE'			,panelSearch.getValue('WH_CODE'));
					    		popupSearch.setValue('ITEM_CODE'		,panelSearch.getValue('ITEM_CODE'));
					    		popupSearch.setValue('ITEM_NAME'		,panelSearch.getValue('ITEM_NAME'));
					    		popupSearch.setValue('STOCKMOVE_DATE'	,panelSearch.getValue('STOCKMOVE_DATE'));
                			 }
                }		
			})
		}
		SearchWindow.center();
		SearchWindow.show();
    }

    
    Unilite.Main( {
		border: false,
		borderItems:[ 
		 		 panelSearch,
		 		 panelResult,
		 		 {
		 		 	xtype:'container',
		 		 	layout:'border',
		 		 	region:'center',
		 		 	items:[lotGrid, masterGrid]
		 		 }
		 		 
		], 
		id: 'btr160ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData'],true);
		},
		onQueryButtonDown : function() {		
			lotStore.loadStoreRecords();
			if(!Ext.isEmpty(panelSearch.getValue('STOCKMOVE_NUM')) )		{
				moveStore.loadStoreRecords();	
			}else {
				moveStore.loadData({});
			}
		},
		onSaveDataButtonDown : function() {		
			moveStore.saveStore()
		},
		onNewDataButtonDown : function() {		
			var sRecord = lotGrid.getSelectedRecord();
			if(sRecord && panelSearch.isValid())	{
				var seq = moveStore.max('STOCKMOVE_SEQ') == null ? 0:moveStore.max('STOCKMOVE_SEQ');
				var r = {
					DIV_CODE: sRecord.get('DIV_CODE'),
					WH_CODE: sRecord.get('WH_CODE'),
					ITEM_CODE: sRecord.get('ITEM_CODE'),
					ITEM_NAME: sRecord.get('ITEM_NAME'),				
					STOCKMOVE_DATE: panelSearch.getValue('STOCKMOVE_DATE'),
					STOCKMOVE_NUM: panelSearch.getValue('STOCKMOVE_NUM'),
					STOCKMOVE_SEQ: seq+1
		        };
		        
				masterGrid.createRow(r, null);
			}else {
				alert("품목을 선택해 주세요.")
			}
		},
		onDeleteDataButtonDown : function()	{						
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow();
			}
			
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			
			panelSearch.setReadOnly(false);
			panelResult.setReadOnly(false);
			
			lotStore.loadData({});	
			moveStore.loadData({});	
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	}); 
	


};

</script>
