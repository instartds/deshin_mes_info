<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp122skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp122skrv" /> 					  <!-- 사업장 -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp122skrvService.selectList2'
		}
	});
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp122skrvService.selectList3'
		}
	});
	/**
	 * Model 정의
	 *
	 * @type
	 */
	Unilite.defineModel('pmp122skrvModel1', {
	    fields: [
			{name: 'PRODT_PLAN_DATE'     	,text: '<t:message code="system.label.product.plandate" default="계획일"/>'	,type: 'uniDate' },
			{name: 'WK_PLAN_Q'      	,text: '<t:message code="system.label.product.planqty" default="계획량"/>'			,type: 'uniQty'}
		]
	});		// End of Unilite.defineModel('pmp122skrvModel', {

	Unilite.defineModel('pmp122skrvModel2', {
	    fields: [
			{name: 'WORK_END_YN'     	,text: '<t:message code="system.label.product.status" default="상태"/>'			,type: 'string' , comboType:'AU', comboCode:'P001'},
			{name: 'WKORD_NUM'       	,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>(TOP)'	,type: 'string'},
			{name: 'PRODT_WKORD_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	,type: 'uniDate'},
			{name: 'ITEM_CODE'       	,text: '<t:message code="system.label.product.item" default="품목"/>'		,type: 'string'},
			{name: 'ITEM_NAME'       	,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'            	,text: '<t:message code="system.label.product.spec" default="규격"/>'			,type: 'string'},
			{name: 'STOCK_UNIT'      	,text: '<t:message code="system.label.product.unit" default="단위"/>'			,type: 'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	,type: 'uniDate'},
			{name: 'PRODT_END_DATE'  	,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	,type: 'uniDate'},
			{name: 'WKORD_Q'         	,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type: 'uniQty'},
			{name: 'PRODT_Q'         	,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'REMARK1'         	,text: '<t:message code="system.label.product.remarks" default="비고"/>'			,type: 'string'},
			{name: 'ORDER_NUM'       	,text: '<t:message code="system.label.product.sono" default="수주번호"/>'		,type: 'string'},
			{name: 'ORDER_Q'         	,text: '<t:message code="system.label.product.soqty" default="수주량"/>'		,type: 'uniQty'},
			{name: 'DVRY_DATE'       	,text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'		,type: 'uniDate'},
			{name: 'REMARK2'         	,text: '<t:message code="system.label.product.customname" default="거래처명"/>'		,type: 'string'},
			{name: 'WK_PLAN_NUM'    	,text: '<t:message code="system.label.product.planno" default="계획번호"/>'		,type: 'string'},
			{name: 'SPRODT_Q'    		,text: '<t:message code="system.label.product.productiontotal" default="생산누계"/>'		,type: 'uniQty'}
		]
	});

	Unilite.defineModel('pmp122skrvModel3', {
	    fields: [
	    	{name: 'WKORD_NUM'       		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type: 'string'},
	    	{name: 'PRODT_WKORD_DATE'       ,text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'		,type: 'uniDate'},
			{name: 'PROG_WORK_CODE'       	,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'			,type: 'string'},
			{name: 'TREE_NAME'       		,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'			,type: 'string'},
			{name: 'ITEM_CODE'  			,text: '<t:message code="system.label.product.item" default="품목"/>'			,type: 'string'},
			{name: 'ITEM_NAME'  			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'  					,text: '<t:message code="system.label.product.spec" default="규격"/>'			,type: 'string'},
			{name: 'STOCK_UNIT'  			,text: '<t:message code="system.label.product.unit" default="단위"/>'			,type: 'string'},
			{name: 'WKORD_Q'				,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type: 'uniQty'},
			{name: 'PRODT_Q'				,text: '<t:message code="system.label.product.productiontotal" default="생산누계"/>'			,type: 'uniQty'},
			{name: 'IN_STOCK_Q'				,text: '<t:message code="system.label.product.receiptaggregate" default="입고누계"/>'			,type: 'uniQty'},
			{name: 'MAN_HOUR'				,text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'			,type: 'float', format: '0,000.00', decimalPrecision: 2 }

		]
	});

	var MasterStore1 = Unilite.createStore('pmp122skrvMasterStore1',{
			model: 'pmp122skrvModel1',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'pmp122skrvService.selectList1'
                }
            },
			loadStoreRecords: function(record){
				var param= panelSearch.getValues();
				param.ITEM_CODE = record.get('ITEM_CODE');
	        	this.load({
						params : param
	         	});
			},
			listeners: {
           	load: function(store, records, successful, eOpts) {

           	},
           	add: function(store, records, index, eOpts) {

           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {

           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}

			// groupField: 'ITEM_NAME'
	});		// End of var directMasterStore1 =
			// Unilite.createStore('pmp122skrvMasterStore1',{

	var MasterStore2 = Unilite.createStore('pmp122skrvMasterStore2',{
			model: 'pmp122skrvModel2',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy:directProxy2,
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});

      	}
	});
		var MasterStore3 = Unilite.createStore('pmp122skrvMasterStore3',{
			model: 'pmp122skrvModel3',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy:directProxy3,
			loadStoreRecords: function(record){
				var param= panelSearch.getValues();
				param.WKORD_NUM = record.get('WKORD_NUM');
	    		this.load({
					params : param
	     		});
     	 	}
	});

	/**
	 * 검색조건 (Search Panel)
	 *
	 * @type
	 */
	var panelSearch = Unilite.createSearchForm('searchForm', {
        region: 'north',
        layout: {type: 'uniTable', columns: 3},
        padding:'1 1 1 1',
		border:true,
        items: [{
        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        	name:'DIV_CODE',
        	xtype: 'uniCombobox',
        	comboType: 'BOR120',
        	allowBlank: false,
        	value: UserInfo.divCode,
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {	
					panelSearch.setValue('WORK_SHOP_CODE','');
				}
    		}
        },
        Unilite.popup('DIV_PUMOK',{ // 20210825 수정: 품목 조회조건 표준화
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
        		textFieldName:'ITEM_NAME',
				validateBlank: false,
				listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		}),{
			 	fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			 	xtype: 'uniTextfield',
			 	name: 'WKORD_NUM'
		},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'W',
				listeners: {
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        store.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;   
                            });
                        }
                    }
			}
		},{
            fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
            xtype: 'uniDateRangefield',
            startFieldName: 'PRODT_START_DATE',
            endFieldName: 'PRODT_END_DATE',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            width: 315
        },{
			xtype: 'radiogroup',
			fieldLabel: '   ',
			items: [{
				boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
				width:130,
				name: 'OPT',
				inputValue: '0',
				checked: true
			},{
				boxLabel: '<t:message code="system.label.product.batch" default="일괄"/>',
				width:130,
				name: 'OPT',
				inputValue: '1'
			},{
				boxLabel: '<t:message code="system.label.product.urgency" default="긴급"/>',
				width:130,
				name: 'OPT',
				inputValue: '2'
			}]
			,listeners: {
				change: function(field, newValue, oldValue, eOpts) {



				}
			}
		}]
    });
        /**
		 * Master Grid1 정의(Grid Panel)
		 *
		 * @type
		 */
    var masterGrid1 = Unilite.createGrid('pmp122skrvGrid1', {
        region: 'east',
        store : MasterStore1,
		split:true,
		flex:0.3,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
        columns:  [

        	{ dataIndex: 'PRODT_PLAN_DATE'       	 	, width: 100},
			{ dataIndex: 'WK_PLAN_Q'       	 	, width: 120}
		]

    });
	var masterGrid2 = Unilite.createGrid('pmp122skrvGrid2', {
        region: 'center',
        store : MasterStore2,
		flex:1,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },

        	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
        columns:  [
        	{dataIndex: 'WORK_END_YN' , width: 100,hidden:true},
			{dataIndex: 'WKORD_NUM' , width: 130},
			{dataIndex: 'PRODT_WKORD_DATE' , width: 100},
			{dataIndex: 'ITEM_CODE' , width: 100},
			{dataIndex: 'ITEM_NAME' , width: 200},
			{dataIndex: 'SPEC' , width: 250},
			{dataIndex: 'STOCK_UNIT' , width: 60},
			{dataIndex: 'PRODT_START_DATE' , width: 100,hidden:true},
			{dataIndex: 'PRODT_END_DATE' , width: 100,hidden:true},
			{dataIndex: 'WKORD_Q' , width: 100},
			{dataIndex: 'PRODT_Q' , width: 100,hidden:true},
			{dataIndex: 'REMARK1' , width: 100,hidden:true},
			{dataIndex: 'ORDER_NUM' , width: 100,hidden:true},
			{dataIndex: 'ORDER_Q' , width: 100,hidden:true},
			{dataIndex: 'DVRY_DATE' , width: 100,hidden:true},
			{dataIndex: 'REMARK2' , width: 100,hidden:true},
			{dataIndex: 'WK_PLAN_NUM' , width: 100,hidden:true},
			{dataIndex: 'SPRODT_Q' , width: 100}

        ] ,
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners: {
			/*
			 * cellclick: function( viewTable, td, cellIndex, record, tr,
			 * rowIndex, e, eOpts , colName) {
			 * MasterStore2.loadStoreRecords(record); this.returnCell(record); },
			 */
   		  selectionchange:function( model1, selected, eOpts ){
       			if(selected.length > 0)	{
	        		var record = selected[0];

//	        		MasterStore2.loadData({})
					MasterStore1.loadStoreRecords(record);
					MasterStore3.loadStoreRecords(record);

       			}
          	}
       	}
    });
	var masterGrid3 = Unilite.createGrid('pmp122skrvGrid3', {
        store : MasterStore3,
        region: 'south',
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
        features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],

        columns:  [
        	{dataIndex: 'WKORD_NUM' , width: 120},
			{dataIndex: 'PRODT_WKORD_DATE' , width: 100},
			{dataIndex: 'PROG_WORK_CODE' , width: 100,hidden:true},
			{dataIndex: 'TREE_NAME' , width: 100,hidden:true},
			{dataIndex: 'ITEM_CODE' , width: 100},
			{dataIndex: 'ITEM_NAME' , width: 200},
			{dataIndex: 'SPEC' , width: 250},
			{dataIndex: 'STOCK_UNIT' , width: 60},
			{dataIndex: 'WKORD_Q' , width: 100},
			{dataIndex: 'PRODT_Q' , width: 100},
			{dataIndex: 'IN_STOCK_Q' , width: 100},
			{dataIndex: 'MAN_HOUR' , width: 100}
        ]
    });
    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelSearch,

				masterGrid2,masterGrid1,

				masterGrid3
			]
		}],

		/*
		items: [panelSearch,{
                xtype: 'container',
                flex: 1,
                layout: 'border',
                items: [{
                    region : 'north',
					xtype  : 'container',
					layout : 'fit',
					height : "55%",
                    layout: {
                        type: 'hbox',
                        align: 'stretch'
                    },
                    items: [masterGrid2,masterGrid1]
                },{
                    region : 'center',
					xtype  : 'container',
					layout : 'fit',
                    items: [masterGrid3]
                }]
            }],*/



		id: 'pmp122skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('save',false);

			panelSearch.setValue('PRODT_START_DATE', UniDate.get('mondayOfWeek'));
			panelSearch.setValue('PRODT_END_DATE', UniDate.get('sundayOfNextWeek'));
		},
		onQueryButtonDown : function()	{
			if(panelSearch.getInvalidMessage()){
				MasterStore2.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {		// 초기화

			panelSearch.reset();
			masterGrid1.reset();
			masterGrid2.reset();
			masterGrid3.reset();
			this.fnInitBinding();
		}
	});		// End of Unilite.Main({
};
</script>

