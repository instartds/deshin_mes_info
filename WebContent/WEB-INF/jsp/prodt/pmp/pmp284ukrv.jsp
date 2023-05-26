
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp284ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp284ukrv" />	<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B013"  />		<!-- 상태   -->
	<t:ExtComboStore comboType="AU" comboCode="B024" />			<!-- 출고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"  />		<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B039"  />		<!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"  />		<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"  />		<!-- 영업담당 -->
	<t:ExtComboStore comboType="WU" />							<!-- 작업장-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->

	
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-change-blue {
		background-color: #A7EEFF;
	}
</style>
<script type="text/javascript" >



var beforeRowIndex;		// 마스터그리드 같은row중복 클릭시 다시 load되지 않게

var gschkgridCnt;		// mastergrid2 변경cnt

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'pmp284ukrvService.selectList'
		}
	});	


	/**
	 * Proxy 정의
	 * 
	 * @type
	 */
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'pmp284ukrvService.selectList1'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'pmp284ukrvService.selectList2'
		}
	});



	/**
	 * Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('pmp284ukrvModel1', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'	,type:'string'},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'	, type: 'string'},
			{name: 'WKORD_NUM'		, text: '제조번호'		, type: 'string'},
			{name: 'PROG_WORK_CODE'	, text: '공정코드'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '품목코드'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '품목명'		, type: 'string'},
			{name: 'EQU_CODE'		, text: '제조기기'		, type: 'string'},
			{name: 'EQU_NAME'		, text: '제조기기'		, type: 'string'},
			{name: 'WKORD_Q'		, text: '이론량'		, type: 'uniQty'},
			{name: 'WORK_Q'			, text: '계량량'		, type: 'uniQty'},
			{name: 'PRODT_DATE'		, text: '제조일자'		, type: 'uniDate'},
			{name: 'ITEM_LIST'		, text: '품목리스트'		, type: 'string'}

		]
	});

	Unilite.defineModel('pmp284ukrvModel2', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'	,type:'string'},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'	, type: 'string'},
			{name: 'WKORD_NUM'		, text: '제조번호'		, type: 'string'},
			{name: 'PROD_ITEM_CODE'	, text: '제품코드'		, type: 'string'},
			{name: 'PROD_ITEM_NAME'	, text: '제품명'		, type: 'string'},
			{name: 'WKORD_NUM_SEQ'	, text: 'NO.'		, type: 'string'},
			{name: 'WORK_SHOP_CODE'	, text: '작업장코드'		, type: 'string'},
			{name: 'WORK_SHOP_NAME'	, text: '작업장명'		, type: 'string'},
			{name: 'PROG_WORK_CODE'	, text: '공정코드'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '원료코드'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '원료명'		, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '단위'		, type: 'string', comboType:'AU',comboCode:'B013'},
			{name: 'UNIT_Q'			, text: '함량(%)'		, type: 'float' , decimalPrecision: 3 , format:'0,000.000'},
			{name: 'OUTSTOCK_REQ_Q'	, text: '이론량(g)'	, type: 'uniQty'},
			{name: 'PRODT_Q'		, text: '계량량(g)'	, type: 'uniQty'},
			{name: 'DLIVY_REQ_CD'	, text: '출고상태'		, type: 'string', comboType: 'AU'	, comboCode: 'Z018'},
			{name: 'DLIVY_REQ_DT'	, text: '출고일'		, type: 'uniDate'},
			{name: 'SAVE_FLAG'	    , text: '저장여부'		, type: 'string'}
			
		]
	});
	
	Unilite.defineModel('detailModel', {
		fields: [
			{name: 'DIV_CODE'			,text: '사업장' 		,type: 'string',comboType:'BOR120'},
			{name: 'SEQ'				,text: '순번' 		,type: 'int'},
			{name: 'START_DATE'			,text: 'START_DATE' ,type: 'string'},
			{name: 'PATH_CODE'			,text: 'PATH_CODE' 	,type: 'string'},
			{name: 'PROD_ITEM_CODE'		,text: '모품목코드' 	,type: 'string'},
			{name: 'PROD_ITEM_NAME'		,text: '<t:message code="system.label.base.parentitemname" default="모품목명"/>'	,type: 'string'},
			{name: 'UNIT_Q'			 	,text: '<t:message code="system.label.base.content" default="함량"/>'				,type: 'float',defaultValue:1, decimalPrecision: 6, format:'0,000.000000'},
			{name: 'CHILD_ITEM_CODE'	,text: '자품목코드' 	,type: 'string'},
			{name: 'ITEM_NAME'			,text: '자품목명' 		,type: 'string'},
			{name: 'GROUP_CODE'			,text: '<t:message code="system.label.base.routinggroup" default="공정그룹"/>'	,type: 'string'  , comboType: 'AU', comboCode:'B140'},
			{name: 'PROC_DRAW'			,text: '공정도' 		,type: 'string'}
		]
	});	


	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('pmp284ukrvMasterStore1',{
		proxy	: directProxy1,
		model	: 'pmp284ukrvModel1',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(STATUS_FLAG) {
			var param= panelResult.getValues();
			if(!Ext.isEmpty(STATUS_FLAG)) {
				param.STATUS_FLAG = STATUS_FLAG;
			}
			this.load({
				params : param
			});
		},
		saveStore: function() {
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
           		var procDraw = '';
           		var seq = '';
           		
           		Ext.each(records,function(record,i){
           			seq = seq + record.get('SEQ') + '\n';
           			procDraw = procDraw + record.get('PROC_DRAW') + '\n';
           		})
           		
           		panelProcDraw.setValue('SEQ',seq);
           		panelProcDraw.setValue('PROC_DRAW',procDraw);				
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	var directMasterStore2 = Unilite.createStore('pmp284ukrvMasterStore2',{
		proxy	: directProxy2,
		model	: 'pmp284ukrvModel2',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(STATUS_FLAG) {
			var param= panelResult.getValues();
			if(!Ext.isEmpty(STATUS_FLAG)) {
				param.STATUS_FLAG = STATUS_FLAG;
			}
			this.load({
				params : param
			});
		},
		saveStore: function() {
		},
		listeners: {
			load: function(store, records, successful, eOpts) {

				this.filterBy (function(record){
					var masterRecord = masterGrid1.getStore().getAt(beforeRowIndex)
					if(!Ext.isEmpty(masterRecord)) {
						var masterWkordNum	= masterRecord.get('WKORD_NUM');
						var masterItemCode	= masterRecord.get('ITEM_CODE');
						fnSetDetailData(masterWkordNum, masterItemCode);
					} else {
						return false;
					}
				});
			
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var record = masterGrid1.getSelectedRecord();
			var param= panelResult.getValues();
			if(!Ext.isEmpty(record)) {
				param.PROD_ITEM_CODE = record.get('ITEM_CODE');;
			}
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		var procDraw = '';
           		var seq = '';
           		
           		Ext.each(records,function(record,i){
           			seq = seq + record.get('SEQ') + '\n';
           			procDraw = procDraw + record.get('PROC_DRAW') + '\n';
           		})
           		
           		panelProcDraw.setValue('SEQ',seq);
           		panelProcDraw.setValue('PROC_DRAW',procDraw);
           	}
		}
	});	

	/**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('pmp284ukrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'north',
		flex	: 0.4,
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					UniAppManager.setToolbarButtons('save', false);
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var masterWkordNum	= selectRecord.get('WKORD_NUM');
					var masterItemCode	= selectRecord.get('ITEM_CODE');
					masterGrid2.getStore().clearFilter();
					
					var detailItemList = '';
					var detailRecords = directMasterStore2.data.items;
					chkdata = new Object();
					chkdata.records = [];
					Ext.each(detailRecords, function(detailRecord, index) {
//						if(masterWkordNum == detailRecord.get('WKORD_NUM') || masterGrid2.getSelectionModel().isSelected(detailRecord) != true) {
							if(masterWkordNum == detailRecord.get('WKORD_NUM') && masterItemCode == detailRecord.get('PROD_ITEM_CODE')){
								detailRecord.set('SAVE_FLAG', 'Y');
								detailItemList = detailItemList + detailRecord.get('ITEM_CODE') + ',';	
							}
							chkdata.records.push(detailRecord);
//						}
					});
					masterGrid2.getSelectionModel().select(chkdata.records);
					selectRecord.set('ITEM_LIST', detailItemList);
					
					fnSetDetailData(masterWkordNum, masterItemCode);
					detailStore.loadStoreRecords();						
	
					gschkgridCnt = 0;
					UniAppManager.setToolbarButtons('save', false);
				},
				deselect: function(grid, selectRecord, index, eOpts ){
					var masterWkordNum	= selectRecord.get('WKORD_NUM');
					var masterItemCode	= selectRecord.get('ITEM_CODE');
					masterGrid2.getStore().clearFilter();
					
					var detailRecords = directMasterStore2.data.items;
					unchkdata = new Object();
					unchkdata.records = [];	
						
					Ext.each(detailRecords, function(detailRecord, index) {
//						if(masterWkordNum == detailRecord.get('WKORD_NUM') || masterGrid2.getSelectionModel().isSelected(detailRecord) == true) {
							if(masterWkordNum == detailRecord.get('WKORD_NUM') && masterItemCode == detailRecord.get('PROD_ITEM_CODE')) {
								detailRecord.set('SAVE_FLAG', 'N');
								unchkdata.records.push(detailRecord);
							}
//						}
					});
					masterGrid2.getSelectionModel().deselect(unchkdata.records);
					selectRecord.set('ITEM_LIST', '');
					fnSetDetailData(masterWkordNum, masterItemCode);
					detailStore.loadStoreRecords();		

					gschkgridCnt = 0;
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}),
		columns: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'WKORD_NUM'		, width: 120},
			{dataIndex: 'PROG_WORK_CODE', width: 100, hidden: true},
			{dataIndex: 'ITEM_CODE'		, width: 100},
			{dataIndex: 'ITEM_NAME'		, width: 120},
			{dataIndex: 'EQU_CODE'		, width: 100, hidden: true},
			{dataIndex: 'EQU_NAME'		, width: 120},
			{dataIndex: 'WKORD_Q'		, width: 100},
			{dataIndex: 'WORK_Q'		, width: 100},
			{dataIndex: 'PRODT_DATE'	, width: 120,align: 'center'},
			{dataIndex: 'ITEM_LIST'		, width: 500, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
					return false;
			},
			beforecellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					var masterWkordNum	= record.get('WKORD_NUM');
					var masterItemCode	= record.get('ITEM_CODE');
					fnSetDetailData(masterWkordNum, masterItemCode);
					detailStore.loadStoreRecords();		
				}				
				beforeRowIndex = rowIndex;
			},
			edit: function(editor, e) {
			}
		},
		viewConfig: {
		}
	});

	var masterGrid2 = Unilite.createGrid('pmp284ukrvGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region:'east',
		flex:2,
		split:true,		
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal2'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id: 'masterGridTotal2'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, showHeaderCheckbox: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){			
					var masterGrids		= directMasterStore1.data.items;
					var masterWkordNum	= selectRecord.get('WKORD_NUM');
					var detailItemList	= '';					
					var selRecords		= masterGrid2.getSelectionModel().getSelection();
					Ext.each(selRecords, function(selRecord, index) {
						if(masterWkordNum == selRecord.get('WKORD_NUM') && masterGrid2.getSelectionModel().isSelected(selRecord) == true) {
								selRecord.set('SAVE_FLAG', 'Y');
								detailItemList = detailItemList + selRecord.get('ITEM_CODE') + ',';
						}
					});
					Ext.each(masterGrids, function(masterGrid, i) {
						if(masterWkordNum == masterGrid.get('WKORD_NUM')) {
							masterGrid.set('ITEM_LIST', detailItemList);
						}							
					});	
					
					gschkgridCnt = gschkgridCnt - 1;
					UniAppManager.setToolbarButtons('save', false);
				},
				deselect: function(grid, selectRecord, index, eOpts ){
					var masterGrids		= directMasterStore1.data.items;
					var masterWkordNum	= selectRecord.get('WKORD_NUM');
					var detailItemList = '';
					var selRecords = masterGrid2.getSelectionModel().getSelection();
					Ext.each(selRecords, function(selRecord, index) {
						if(masterWkordNum == selRecord.get('WKORD_NUM') || masterGrid2.getSelectionModel().isSelected(selRecord) == true) {
								selRecord.set('SAVE_FLAG', 'N');
								detailItemList = detailItemList + selRecord.get('ITEM_CODE') + ',';
						}
					});
					Ext.each(masterGrids, function(masterGrid, i) {
						if(masterWkordNum == masterGrid.get('WKORD_NUM')) {
							masterGrid.set('ITEM_LIST', detailItemList);
						}
						if(detailItemList == ""){
							masterGrid1.getSelectionModel().deselect(i);								
						}						
					});
					gschkgridCnt = gschkgridCnt + 1;
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}),
		columns: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'WKORD_NUM'		, width: 100, hidden: true},
			{dataIndex: 'PROD_ITEM_CODE', width: 100, hidden: true},
			{dataIndex: 'PROD_ITEM_NAME', width: 100, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE', width: 100, hidden: true},
			{dataIndex: 'WORK_SHOP_NAME', width: 100, hidden: true},
			{dataIndex: 'PROG_WORK_CODE', width: 100, hidden: true},
			{dataIndex: 'WKORD_NUM_SEQ'	, width:  60, hidden: true},
			{dataIndex: 'ITEM_CODE'		, width: 100},
			{dataIndex: 'ITEM_NAME'		, width: 120},
			{dataIndex: 'STOCK_UNIT'	, width: 100, align: 'center'},
			{dataIndex: 'UNIT_Q'		, width: 120},
			{dataIndex: 'OUTSTOCK_REQ_Q', width: 120},
			{dataIndex: 'PRODT_Q'		, width: 120},
			{dataIndex: 'DLIVY_REQ_CD'	, width: 120},
			{dataIndex: 'DLIVY_REQ_DT'	, width: 120, align: 'center'},
			{dataIndex: 'SAVE_FLAG'	    , width: 100, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			}
		},
		viewConfig: {
		}
	});
	
	var progWordComboStore = new Ext.data.Store({
		storeId: 'pmr284ukrvProgWordComboStore',
		fields	: ['value', 'text','refCode1','option'],
		// autoLoad: true,
		proxy: {
			type: 'direct',
			api: {
				 read: 'UniliteComboServiceImpl.getProgWorkCode'
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
					if(successful)  {
					}
			}
		},
		loadStoreRecords: function(records)	{
			var param= panelResult.getValues();
			param.WKORD_NUM = '';
			console.log(param);
			this.load({
				params : param
			});
		}
	});	

	var detailGrid = Unilite.createGrid('detailGrid', {
		layout: 'fit',
		region:'west',
		flex:2,
		split:true,
		hidden:true,
		uniOpt: {
// userToolbar:false,
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		store: detailStore,
		columns: [
			{ dataIndex: 'DIV_CODE'			, width: 120,hidden:true},
			{ dataIndex: 'SEQ'				, width: 60,align:'center'},
			{ dataIndex: 'PROD_ITEM_CODE'	, width: 100},
			{ dataIndex: 'PROD_ITEM_NAME'	, width: 200},
			{ dataIndex: 'CHILD_ITEM_CODE'	, width: 100},
			{ dataIndex: 'ITEM_NAME'		, width: 250},
			{ dataIndex: 'UNIT_Q'			, width: 80},
			{ dataIndex: 'GROUP_CODE'		, width: 80, align: 'center'},
			{ dataIndex: 'PROC_DRAW'		, width: 450,
			editor: {
				xtype:'textfield',
				enableKeyEvents:true,
				getCaretPosition: function() {
			        var el = this.inputEl.dom;
			        if (typeof(el.selectionStart) === "number") {
			            return el.selectionStart;
			        } else if (document.selection && el.createTextRange){
			            var range = document.selection.createRange();
			            range.collapse(true);
			            range.moveStart("character", -el.value.length);
			            return range.text.length;
			        } else {
			            throw 'getCaretPosition() not supported';
			        }
			    }
			}
		}],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['PROC_DRAW'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});
	

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '99.5%'}},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
						name:'DIV_CODE',
						xtype: 'uniCombobox',
						comboType:'BOR120' ,
						allowBlank:false,
						holdable: 'hold',
// value: UserInfo.divCode,
						value: '02',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('WORK_SHOP_CODE','');
								panelResult.setValue('PROG_WORK_CODE','');
								progWordComboStore.loadStoreRecords();
							}
						}
					},{
						fieldLabel		: '제조일자',
						xtype			: 'uniDateRangefield',
						startFieldName	: 'WORK_DATE_FR',
						endFieldName	: 'WORK_DATE_TO',
						startDate		: UniDate.get('startOfMonth'),
						endDate			: UniDate.get('today'),
						onStartDateChange: function(field, newValue, oldValue, eOpts) {
						},
						onEndDateChange: function(field, newValue, oldValue, eOpts) {
						}
					},	
					Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					validateBlank:false,
					textFieldName: 'ITEM_NAME',
					valueFieldName: 'ITEM_CODE',
					validateBlank: false,
					autoPopup:true,
					holdable: 'hold',
					listeners: {
						onValueFieldChange: function(field, newValue){
						},
						onTextFieldChange: function(field, newValue){
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
					}),{
						fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
						name: 'WORK_SHOP_CODE',
						xtype: 'uniCombobox',
						comboType: 'WU',
						allowBlank:false,
						value: 'WSH10',
						holdable: 'hold',						
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
							},
			                beforequery:function( queryPlan, eOpts )   {
			                    var store = queryPlan.combo.store;
			                    var prStore = panelResult.getField('WORK_SHOP_CODE').store;
			                    store.clearFilter();
			                    prStore.clearFilter();
			                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
			                        store.filterBy(function(record){
			                            return record.get('option') == panelResult.getValue('DIV_CODE');
			                        });
			                        prStore.filterBy(function(record){
			                            return record.get('option') == panelResult.getValue('DIV_CODE');
			                        });
			                    }else{
			                        store.filterBy(function(record){
			                            return false;
			                        });
			                        prStore.filterBy(function(record){
			                            return false;
			                        });
			                    }
			                }
						}
					},{	fieldLabel: '공정',
						name:'PROG_WORK_CODE',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('pmr284ukrvProgWordComboStore'),
						allowBlank:false,
						value: 'H110',
// holdable: 'hold',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
							},
							beforequery:function( queryPlan, eOpts ) {
								var store = queryPlan.combo.store;
								store.clearFilter();
		
								if(!Ext.isEmpty(panelResult.getValue('WORK_SHOP_CODE'))){
									store.filterBy(function(record){
										return record.get('refCode1') == panelResult.getValue('WORK_SHOP_CODE');
									});
								} else{
									store.filterBy(function(record){
										return false;
									});
								}
							}
						}
					},{
						fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
						xtype: 'uniTextfield',
						name: 'WKORD_NUM',
						holdable: 'hold',						
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
							}
						}
					},{
						xtype	: 'container',
						layout	: {type : 'uniTable', columns : 2},
						width	: 300,						
						items	: [{
							xtype		: 'radiogroup',
							fieldLabel	: '<t:message code="system.label.sales.status" default="상태"/>',
							id			: 'statusFlag',
							items		: [{
								boxLabel	: '미출고', 
								width		: 80,
								name		: 'STATUS_FLAG',
								inputValue	: 'N',
								checked		: true 
							},{
								boxLabel	: '출고완료', 
								width		: 80,
								name		: 'STATUS_FLAG',
								inputValue	: 'Y'
							}],
							listeners: {
								change: function(field, newValue, oldValue, eOpts) {
									if(newValue.STATUS_FLAG == 'Y') {
										panelResult.down('#btnConfirm').setDisabled(true);
										
									} else {
										panelResult.down('#btnConfirm').setDisabled(false);
									}
									UniAppManager.app.onQueryButtonDown(newValue.STATUS_FLAG);
								}
							}
						}],
						colspan		: 2
					},{xtype	: 'container',
						layout	: {type : 'uniTable', columns : 2},
						tdAttrs: {align: 'right'},						
						items	: [{
								xtype	: 'button',
								text	: '출고요청',
								id		: 'btnConfirm',
								itemId	: 'btnConfirm',
								name	: 'CONFIRM',
								width	: 110,	
								handler	: function() {
									if(masterGrid2.selModel.getCount() == 0) {
										Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
										return false;
									}
									masterGrid2.getStore().clearFilter();
									var records1 = masterGrid1.getSelectedRecords()
									var records2 = directMasterStore2.data.items;
									var saveCnt = 0;
								    data = new Object();
								    data.records = [];									
					
									// 출고요청, 취소 진행할 detail Data에 flag값 set
									Ext.each(records2, function(record2, index) {
											if(masterGrid2.getSelectionModel().isSelected(record2) == true){
												record2.set('SAVE_FLAG', 'Y');
												data.records.push(records2);
												saveCnt = saveCnt + 1;
											}

									});
									if(saveCnt != 0){
										var params = {
											action		: 'select',
											'PGM_ID'	: 'pmp284ukrv',
											'record'	: directMasterStore2.data.items,
											'formPram'	: panelResult.getValues()
										}
										var rec = {data : {prgID : 'mtr210ukrv', 'text':''}};
										parent.openTab(rec, '/matrl/mtr210ukrv.do', params, CHOST+CPATH);										
																
									}else{
										Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
										return false;
									}
									var masterRecord	= masterGrid1.getStore().getAt(beforeRowIndex)
									var masterWkordNum	= masterRecord.get('WKORD_NUM');
									var masterItemCode	= masterRecord.get('ITEM_CODE');
					
									fnSetDetailData(masterWkordNum, masterItemCode);
								}
						}]
				}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''

					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}

					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					// this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')  ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				// this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});	
	


	var panelProcDraw = Unilite.createForm('panelProcDraw', {
		title:'공정도',
		flex:1,
		region:'center',
		layout: {type : 'uniTable', columns : 2},
		padding: '1 1 1 1',
		disabled :false,
		border: true,
		items: [{
			fieldLabel:'순번',
			labelAlign: 'top',
			fieldStyle: 'text-align: right;',
			xtype:'textarea',
			name:'SEQ',
			width:50,
			height:500,
			readOnly:true
		},{
			fieldLabel:'공정도',
			labelAlign: 'top',
			xtype:'textarea',
			name:'PROC_DRAW',
			width:500,
			height:500,
			readOnly:false,
			enableKeyEvents:true,
			getCaretPosition: function() {
		        var el = this.inputEl.dom;
		        if (typeof(el.selectionStart) === "number") {
		            return el.selectionStart;
		        } else if (document.selection && el.createTextRange){
		            var range = document.selection.createRange();
		            range.collapse(true);
		            range.moveStart("character", -el.value.length);
		            return range.text.length;
		        } else {
		            throw 'getCaretPosition() not supported';
		        }
		    }
		}
		]
	});


	Unilite.Main({
		id			: 'pmp284ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid1, detailGrid, panelProcDraw, masterGrid2 
			]
		}],
		fnInitBinding : function(params) {			
			UniAppManager.setToolbarButtons('reset', false);
			this.setDefault();
		},
		onQueryButtonDown : function(STATUS_FLAG){
			if(!panelResult.getInvalidMessage()) return;	// 필수체크
			// 전역변수 초기화
			beforeRowIndex = undefined;
			directMasterStore1.loadStoreRecords(STATUS_FLAG);
			directMasterStore2.loadStoreRecords(STATUS_FLAG);
			detailStore.loadStoreRecords();	
			
			UniAppManager.setToolbarButtons('reset', true);
			gschkgridCnt = 0;
		},
		onResetButtonDown: function() {
			// 전역변수 초기화
			beforeRowIndex = undefined;
			masterGrid1.getStore().loadData({});
			masterGrid2.getStore().loadData({});
			this.fnInitBinding();
			gschkgridCnt = 0;
		},
		onDeleteDataButtonDown: function() {

		},
		onSaveDataButtonDown: function(config) {
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE','02');
			panelResult.setValue('WORK_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('WORK_DATE_TO',UniDate.get('today'));
			panelResult.setValue('WORK_SHOP_CODE','WSH10');
			panelResult.setValue('PROG_WORK_CODE','H110');
			panelResult.setValue('ITEM_CODE','');
			panelResult.setValue('ITEM_NAME','');
			panelResult.setValue('WKORD_NUM','');			
			progWordComboStore.loadStoreRecords();
			panelProcDraw.setValue('SEQ', '');
			panelProcDraw.setValue('PROC_DRAW', '');			
			UniAppManager.setToolbarButtons('save', false);
		}
	});		// End of Unilite.Main({



	function fnSetDetailData(masterWkordNum, masterItemCode) {
		masterGrid2.getStore().clearFilter();
		masterGrid2.getStore().filterBy (function(record){
			if(!Ext.isEmpty(masterWkordNum)) {
				if(masterWkordNum == record.get("WKORD_NUM") && masterItemCode == record.get("PROD_ITEM_CODE")){
					return true;
				} else{
					return false;
				}
			} else{
				return false;
			}
		});
	}	


};
</script>
