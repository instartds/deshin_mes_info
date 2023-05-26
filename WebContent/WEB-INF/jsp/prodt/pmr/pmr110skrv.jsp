<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr110skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('Pmr110skrvModel1', {
		fields: [
			{name: 'WKORD_NUM' 		, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'ITEM_CODE' 		, text: '<t:message code="system.label.product.item" default="품목"/>'		, type: 'string'},
			{name: 'ITEM_NAME' 		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'      		, text: '<t:message code="system.label.product.spec" default="규격"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.product.unit" default="단위"/>'			, type: 'string'},
			{name: 'PRODT_Q'   		, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'WKORD_Q'		, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	, type: 'uniQty'},
			{name: 'MAN_HOUR'		, text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'		, type: 'string'},
			{name: 'LOT_NO'    		, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'		, type: 'string'},
			{name: 'REMARK'    		, text: '<t:message code="system.label.product.remarks" default="비고"/>'			, type: 'string'},
			{name: 'PROJECT_NO'		, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'	, type: 'string'},
			{name: 'PJT_CODE'  		, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'	, type: 'string'}
		]
	});		// End of Unilite.defineModel('Pmr110skrvModel1', {

	Unilite.defineModel('Pmr110skrvModel2', {
	    fields: [
	    	{name: 'PROG_WORK_NAME'	, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'string'},
			{name: 'BAD_CODE'      	, text: '<t:message code="system.label.product.defectcode" default="불량코드"/>'	, type: 'string'},
			{name: 'CODE_NAME'     	, text: '<t:message code="system.label.product.defectcodename" default="불량코드명"/>'		, type: 'string'},
			{name: 'BAD_Q'         	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'		, type: 'uniQty'},
			{name: 'ITEM_CODE'     	, text: '<t:message code="system.label.product.item" default="품목"/>'		, type: 'string'},
			{name: 'ITEM_NAME'     	, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		    , type: 'string'},
			{name: 'SPEC'          	, text: '<t:message code="system.label.product.spec" default="규격"/>'		    , type: 'string'},
			{name: 'STOCK_UNIT'    	, text: '<t:message code="system.label.product.unit" default="단위"/>'		    , type: 'string'},
			{name: 'WKORD_NUM' 		, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'LOT_NO'        	, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'	    , type: 'string'}
		]
	});		// End of Unilite.defineModel('Pmr110skrvModel2', {

	Unilite.defineModel('Pmr110skrvModel3', {
	    fields: [
	    	{name: 'PROG_WORK_NAME'	, text:'<t:message code="system.label.product.routingname" default="공정명"/>'		    , type: 'string'},
			{name: 'CTL_CD1'       	, text:'<t:message code="system.label.product.specialremarkcode" default="특기사항코드"/>'	, type: 'string'},
			{name: 'CODE_NAME'     	, text:'<t:message code="system.label.product.specialremarkname" default="특기사항명"/>'		, type: 'string'},
			{name: 'TROUBLE_TIME'  	, text:'<t:message code="system.label.product.occurredtime" default="발생시간"/>'		, type: 'uniTime'},
			{name: 'TROUBLE'       	, text:'<t:message code="system.label.product.summary" default="요약"/>'			, type: 'string'},
			{name: 'WKORD_NUM' 		, text:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'LOT_NO'        	, text:'<t:message code="system.label.product.lotno" default="LOT번호"/>'		    , type: 'string'}
		]
	});		// End of Unilite.defineModel('Pmr110skrvModel3', {

	Unilite.defineModel('Pmr110skrvModel4', {
	    fields: [
	    	{name: 'PROG_WORK_NAME'	, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'string'},
	    	{name: 'WORK_MAN'       , text: '<t:message code="system.label.product.workemployee" default="작업인원"/>'		, type: 'string'}
		]
	});		// End of Unilite.defineModel('Pmr110skrvModel4', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('pmr110skrvMasterStore1',{
			model: 'Pmr110skrvModel1',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'pmr110skrvService.selectList1'
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField: 'ITEM_NAME'
	});		// End of var directMasterStore1 = Unilite.createStore('pmr110skrvMasterStore1',{

	var directMasterStore2 = Unilite.createStore('pmr110skrvMasterStore2',{
			model: 'Pmr110skrvModel2',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'pmr110skrvService.selectList2'
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField: 'CUSTOM_NAME1'
	});		// End of var directMasterStore2 = Unilite.createStore('pmr110skrvMasterStore2',{


	var directMasterStore3 = Unilite.createStore('pmr110skrvMasterStore3',{
			model: 'Pmr110skrvModel3',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'pmr110skrvService.selectList3'
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField: 'DVRY_DATE1'
	});// End of var directMasterStore3 = Unilite.createStore('pmr110skrvMasterStore3',{

	var directMasterStore4 = Unilite.createStore('pmr110skrvMasterStore4',{
			model: 'Pmr110skrvModel4',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'pmr110skrvService.selectList4'
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField: 'DVRY_DATE1'
	});		// End of var directMasterStore4 = Unilite.createStore('pmr110skrvMasterStore4',{

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
    var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'center',
    	title : '<t:message code="system.label.product.employeestatusentry" default="인원현황등록"/>',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
        defaultType: 'uniTextfield',
//	    items: [{
//	    	xtype:'panel',
//	    	border: false,
//	        defaultType: 'uniTextfield',
//	        layout: {type: 'uniTable', columns : 1},
//	        padding:'15,0,0,0',

	        items: [
	        	{fieldLabel: '<t:message code="system.label.product.totalnumber" default="총인원"/>' },
	        	{fieldLabel: '<t:message code="system.label.product.numberinholiday" default="휴가인원"/>'},
	        	{fieldLabel: '<t:message code="system.label.product.absentsnumber" default="결근인원"/>'},
	        	{fieldLabel: '<t:message code="system.label.product.numberoflateness" default="지각인원"/>'},
	        	{fieldLabel: '<t:message code="system.label.product.dispatchnumber" default="파견인원"/>'},
	        	{fieldLabel: '<t:message code="system.label.product.supportnumber" default="지원인원"/>'},
	        	{fieldLabel: '<t:message code="system.label.product.workemployee" default="작업인원"/>'}
			]
//		}]
    });


	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
         defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            topSearch.show();
	        },
	        expand: function() {
	        	topSearch.hide();
	        }
        },
		items: [{
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType: 'BOR120',
	        	allowBlank: false,
	        	value : UserInfo.divCode,
	        	listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							topSearch.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
	        },{
	        	fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
	        	name: 'WORK_SHOP_CODE',
	        	xtype: 'uniCombobox',
	        	comboType:'W',
	        	allowBlank:false,
	        	listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							topSearch.setValue('WORK_SHOP_CODE', newValue);
						},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = topSearch.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
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

	        },{
	        	fieldLabel: '<t:message code="system.label.product.workday" default="작업일"/>',
	        	xtype: 'uniDatefield',
	        	name: 'FR_DATE',
	        	value: UniDate.get('today'),
	        	allowBlank:false,
	        	listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							topSearch.setValue('FR_DATE', newValue);
						}
					}
			}]
		}]
	});	//end panelSearch

    var topSearch = Unilite.createSimpleForm('topSearchForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType: 'BOR120',
	        	allowBlank: false,
	        	value : UserInfo.divCode,
	        	listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
					topSearch.setValue('WORK_SHOP_CODE','');
					}
				}
	        },{
	        	fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
	        	name: 'WORK_SHOP_CODE',
	        	xtype: 'uniCombobox',
	        	comboType:'W',
	        	allowBlank:false,
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
						},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(topSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == topSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == topSearch.getValue('DIV_CODE');
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

	        },{
	        	fieldLabel: '<t:message code="system.label.product.workday" default="작업일"/>',
	        	xtype: 'uniDatefield',
	        	name: 'FR_DATE',
	        	value: UniDate.get('today'),
	        	allowBlank:false,
	        	listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('FR_DATE', newValue);
						}
					}
			}]
	});


    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid1 = Unilite.createGrid('pmr110skrvGrid1', {
    	layout : 'fit',
    	title : '<t:message code="system.label.product.productionstatus" default="생산현황"/>',
    	region:'north',
        store : directMasterStore1,
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
//        tbar: [{
//        	text:'상세보기',
//        	handler: function() {
//        		var record = masterGrid.getSelectedRecord();
//	        	if(record) {
//	        		openDetailWindow(record);
//	        	}
//        	}
//        }],
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [
        	{dataIndex: 'WKORD_NUM' 	, width: 106	, locked: true},
			{dataIndex: 'ITEM_CODE' 	, width: 106	, locked: true},
			{dataIndex: 'ITEM_NAME' 	, width: 106	, locked: true},
			{dataIndex: 'SPEC'      	, width: 66		, locked: true},
			{dataIndex: 'STOCK_UNIT'	, width: 46		, locked: true},
			{dataIndex: 'PRODT_Q'   	, width: 75},
			{dataIndex: 'WKORD_Q'		, width: 100},
			{dataIndex: 'MAN_HOUR'		, width: 74},
			{dataIndex: 'LOT_NO'    	, width: 100},
			{dataIndex: 'REMARK'    	, width: 100},
			{dataIndex: 'PROJECT_NO'	, width: 100}
//			{dataIndex: 'PJT_CODE'  	, width: 100}
         ]
    });		//End of var masterGrid1 = Unilite.createGrid('pmr110skrvGrid1', {

    /**
     * Master Grid2 정의(Grid Panel)
     * @type
     */
  var masterGrid2 = Unilite.createGrid('pmr110skrvGrid2', {
    	layout : 'fit',
    	title : '<t:message code="system.label.product.defectstatus" default="불량현황"/>',
    	region:'center',
        store : directMasterStore2,
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
/*        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],*/
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [
        	{dataIndex: 'PROG_WORK_NAME' 	, width: 110},
			{dataIndex: 'BAD_CODE'      	, width: 66	, hidden:true},
			{dataIndex: 'CODE_NAME'     	, width: 76},
			{dataIndex: 'BAD_Q'         	, width: 76},
			{dataIndex: 'ITEM_CODE'     	, width: 110},
			{dataIndex: 'ITEM_NAME'     	, width: 110},
			{dataIndex: 'SPEC'          	, width: 110},
			{dataIndex: 'STOCK_UNIT'    	, width: 90},
			{dataIndex: 'WKORD_NUM' 		, widith: 110},
			{dataIndex: 'LOT_NO'        	, width: 220}
         ]
    });		//End of  var masterGrid2 = Unilite.createGrid('pmr110skrvGrid2', {

     var masterGrid3 = Unilite.createGrid('pmr110skrvGrid3', {
    	layout : 'fit',
    	title : '<t:message code="system.label.product.specialremarkstatus" default="특기사항현황"/>',
    	region:'south',
        store : directMasterStore3,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'<t:message code="system.label.product.detailsview" default="상세보기"/>',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	store: directMasterStore3,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [
        	{dataIndex: 'PROG_WORK_NAME'	, width: 143},
        	{dataIndex: 'CTL_CD1'      	 	, width: 133, hidden: true},
        	{dataIndex: 'CODE_NAME'    	 	, width: 143},
        	{dataIndex: 'TROUBLE_TIME' 	 	, width: 96},
        	{dataIndex: 'TROUBLE'      	 	, width: 200},
        	{dataIndex:  'WKORD_NUM' 		, width: 130},
        	{dataIndex: 'LOT_NO'       	 	, width: 300}
        ]
    });		//End of var masterGrid3 = Unilite.createGrid('pmr110skrvGrid3', {

     var masterGrid4 = Unilite.createGrid('pmr110skrvGrid4', {
    	layout : 'fit',
    	title :'<t:message code="system.label.product.routingworkerstatus" default="공정별인원현황"/>',
    	region:'center',
        store : directMasterStore4,
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'<t:message code="system.label.product.detailsview" default="상세보기"/>',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	store: directMasterStore4,
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} ],
        columns:  [
        	{dataIndex: 'PROG_WORK_NAME'	, width: 252},
        	{dataIndex: 'WORK_MAN'       	, width: 252}
        ]
    });		//End of var masterGrid4 = Unilite.createGrid('pmr110skrvGrid4', {

    Unilite.Main({
    	borderItems:[{
    	xtype : 'container',
		flex : 1,
		region: 'center',
		layout: {type: 'hbox', align: 'stretch'},
		items: [{
			border: false,
			xtype : 'container',
			width: 300,
			layout: {type:'vbox', align:'stretch'},
			items: [
				panelResult, {xtype:'splitter', size:1}, masterGrid4
			]},
			{xtype: 'splitter' , size:1},
			{xtype: 'container',
			layout: {type:'vbox', align:'stretch'},
			flex: 1,
			items: [
			topSearch,
				masterGrid1,{xtype:'splitter' , size:1},
				masterGrid2,{xtype:'splitter' , size:1},
				masterGrid3
			]}
		]},
			  panelSearch
		],
		id: 'pmr110skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore1.loadStoreRecords();
				directMasterStore2.loadStoreRecords();
				directMasterStore3.loadStoreRecords();
				directMasterStore4.loadStoreRecords();
			}
		},

		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});		// End of  Unilite.Main({
};
</script>
