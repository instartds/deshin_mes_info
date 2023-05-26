<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr120skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 					  <!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->      
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
	Unilite.defineModel('Pmr120skrvModel', {
	    fields: [  	 
	    	{name: 'WKORD_NUM'     		, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'ITEM_CODE'     		, text: '<t:message code="system.label.product.item" default="품목"/>'		, type: 'string'},
			{name: 'ITEM_NAME'     		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'          		, text: '<t:message code="system.label.product.spec" default="규격"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'    		, text: '<t:message code="system.label.product.unit" default="단위"/>'			, type: 'string'},
			{name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'uniQty'},
			{name: 'PRODT_Q'       		, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'WKORD_Q'       		, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	, type: 'uniQty'},
			{name: 'MAN_HOUR'	    	, text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'		, type: 'string'},
			{name: 'LOT_NO'        		, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'		, type: 'string'},
			{name: 'REMARK'        		, text: '<t:message code="system.label.product.remarks" default="비고"/>'			, type: 'string'},
			{name: 'PROJECT_NO'    		, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'	, type: 'string'},
            {name: 'PJT_CODE' 			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'	, type: 'string'},
            {name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'string'},
            {name: 'BAD_CODE'      		, text: '<t:message code="system.label.product.defectcode" default="불량코드"/>'	, type: 'string'},
            {name: 'CODE_NAME'     		, text: '<t:message code="system.label.product.defectcodename" default="불량코드명"/>'		, type: 'string'},
			{name: 'BAD_Q'         		, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'		, type: 'uniQty'},
			{name: 'CTL_CD1'     		, text: '특기사항코드'	, type: 'string'},
			{name: 'TROUBLE_TIME'  		, text: '<t:message code="system.label.product.occurredtime" default="발생시간"/>'		, type: 'uniTime'},
			{name: 'TROUBLE'       		, text: '<t:message code="system.label.product.summary" default="요약"/>'			, type: 'string'}
		]
	});		// End of Unilite.defineModel('Pmr120skrvModel', {
	
	Unilite.defineModel('Pmr120skrvModel2', {
	    fields: [  	 
	    	{name: 'WKORD_NUM'     		, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'ITEM_CODE'     		, text: '<t:message code="system.label.product.item" default="품목"/>'		, type: 'string'},
			{name: 'ITEM_NAME'     		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'          		, text: '<t:message code="system.label.product.spec" default="규격"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'    		, text: '<t:message code="system.label.product.unit" default="단위"/>'			, type: 'string'},
			{name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'string'},
			{name: 'PRODT_Q'       		, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'WKORD_Q'       		, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'	, type: 'uniQty'},
			{name: 'MAN_HOUR'	    	, text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'		, type: 'string'},
			{name: 'LOT_NO'        		, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'		, type: 'string'},
			{name: 'REMARK'        		, text: '<t:message code="system.label.product.remarks" default="비고"/>'			, type: 'string'},
			{name: 'PROJECT_NO'    		, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'	, type: 'string'},
            {name: 'PJT_CODE' 			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'	, type: 'string'},
            {name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'string'},
            {name: 'BAD_CODE'      		, text: '<t:message code="system.label.product.defectcode" default="불량코드"/>'	, type: 'string'},
            {name: 'CODE_NAME'     		, text: '특기사항명'	, type: 'string'},
			{name: 'BAD_Q'         		, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'		, type: 'uniQty'},
			{name: 'CTL_CD1'     		, text: '특기사항코드'	, type: 'string'},
			{name: 'TROUBLE_TIME'  		, text: '<t:message code="system.label.product.occurredtime" default="발생시간"/>'		, type: 'uniTime'},
			{name: 'TROUBLE'       		, text: '<t:message code="system.label.product.summary" default="요약"/>'			, type: 'string'}
		]                                 
	});
	
	Unilite.defineModel('Pmr120skrvModel3', {
	    fields: [  	 
			{name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'			, type: 'string'},
			{name: 'CTL_CD1'     		, text: '특기사항코드'		, type: 'string'},
			{name: 'CODE_NAME'     		, text: '특기사항명'		, type: 'string'},
			{name: 'TROUBLE_TIME'     	, text: '<t:message code="system.label.product.occurredtime" default="발생시간"/>'			, type: 'uniTime'},
			{name: 'TROUBLE'     		, text: '<t:message code="system.label.product.summary" default="요약"/>'			    , type: 'string'},
			{name: 'WKORD_NUM'     		, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		, type: 'string'},
			{name: 'LOT_NO'  			, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			, type: 'string'}
		]                                 
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('pmr120skrvMasterStore1',{
			model: 'Pmr120skrvModel',
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
                	   read: 'pmr120skrvService.selectList1'                	
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
	});		//End of var directMasterStore1 = Unilite.createStore('pmr120skrvMasterStore1',{
	
		/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore2 = Unilite.createStore('pmr120skrvMasterStore1',{
			model: 'Pmr120skrvModel2',
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
                	   read: 'pmr120skrvService.selectList2'                	
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
	});		//Emd of var directMasterStore2 = Unilite.createStore('pmr120skrvMasterStore1',{
	
	var directMasterStore3 = Unilite.createStore('pmr120skrvMasterStore1',{
			model: 'Pmr120skrvModel3',
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
                	   read: 'pmr120skrvService.selectList3'                	
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
	});		//Emd of var directMasterStore2 = Unilite.createStore('pmr120skrvMasterStore1',{

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
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
			    name: 'DIV_CODE', 
			    xtype: 'uniCombobox', 
			    comboType: 'BOR120',
			    allowBlank: false,
			    value : UserInfo.divCode,
			    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							topSearch.setValue('DIV_CODE', newValue);
						}
					}
		    },{
		    	fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
		    	name:'WORK_SHOP_CODE', 
		    	xtype: 'uniCombobox', 
		    	store: Ext.data.StoreManager.lookup('wsList'), 
		    	allowBlank:false,
		    	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							topSearch.setValue('WORK_SHOP_CODE', newValue);
						}
					}
		    },{
		    	fieldLabel: '<t:message code="system.label.product.workday" default="작업일"/>',
		    	xtype: 'uniDatefield',
		    	name: 'FR_DATE',
		    	value: UniDate.get('today'),
		    	allowBlank: false,
		    	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							topSearch.setValue('FR_DATE', newValue);
						}
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
    });		// End of var panelSearch = Unilite.createSearchForm('searchForm',{
    
    var topSearch = Unilite.createSimpleForm('topSearchForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		    items: [{
		    	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			    name: 'DIV_CODE', 
			    xtype: 'uniCombobox', 
			    comboType: 'BOR120',
			    allowBlank: false,
			    value : UserInfo.divCode,
			    listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		    },{
		    	fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
		    	name:'WORK_SHOP_CODE', 
		    	xtype: 'uniCombobox', 
		    	store: Ext.data.StoreManager.lookup('wsList'), 
		    	allowBlank:false,
		    	listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
					}
				}
		    },{
		    	fieldLabel: '<t:message code="system.label.product.workday" default="작업일"/>',
		    	xtype: 'uniDatefield',
		    	name: 'FR_DATE',
		    	value: UniDate.get('today'),
		    	allowBlank: false,
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

    var masterGrid1 = Unilite.createGrid('pmr120skrvGrid1', {
    	layout : 'fit',
    	title : '<t:message code="system.label.product.productionstatus" default="생산현황"/>',
    	region:'north',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
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
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [  
        	{dataIndex: 'WKORD_NUM'     	, width: 100},
			{dataIndex: 'ITEM_CODE'     	, width: 100},
			{dataIndex: 'ITEM_NAME'     	, width: 153},
			{dataIndex: 'SPEC'          	, width: 100},
			{dataIndex: 'STOCK_UNIT'    	, width: 53},
			{dataIndex: 'PROG_WORK_NAME'	, width: 120},
			{dataIndex: 'PRODT_Q'       	, width: 80},
			{dataIndex: 'WKORD_Q'       	, width: 80},
			{dataIndex: 'MAN_HOUR'	    	, width: 80},
			{dataIndex: 'LOT_NO'        	, width: 100},
			{dataIndex: 'REMARK'        	, width: 100},
			{dataIndex: 'PROJECT_NO'    	, width: 100}
//			{dataIndex: 'PJT_CODE' 			, width: 100}				
         ] 
    });		//End of var masterGrid1 = Unilite.createGrid('pmr120skrvGrid1', {
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
 	var masterGrid2 = Unilite.createGrid('pmr120skrvGrid2', {
    	layout : 'fit',
    	title : '불량현황',
    	region:'center',
        store : directMasterStore2, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
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
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns: [
        	{dataIndex: 'PROG_WORK_NAME'	, width: 131},
	        {dataIndex: 'BAD_CODE'     		, width: 79},
	        {dataIndex: 'CODE_NAME'   		, width: 91},
	        {dataIndex: 'BAD_Q'        		, width: 78},
	        {dataIndex: 'ITEM_CODE'    		, width: 111},
	        {dataIndex: 'ITEM_NAME'    		, width: 111},
	        {dataIndex: 'SPEC'         		, width: 111},
	        {dataIndex: 'STOCK_UNIT'   		, width: 111},
	        {dataIndex: 'WKORD_NUM' 		, width: 100},
	        {dataIndex: 'LOT_NO'       		, width: 100}
        ] 
    });		//End of var masterGrid2 = Unilite.createGrid('pmr120skrvGrid2', {
    
	var masterGrid3 = Unilite.createGrid('pmr120skrvGrid3', {
    	layout : 'fit',
    	title : '특기사항현황',
    	region:'south',
    	store: directMasterStore3,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
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

    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns: [  
        	{dataIndex: 'PROG_WORK_NAME'	, width: 166},
        	{dataIndex: 'CTL_CD1'       	, width: 134},
        	{dataIndex: 'CODE_NAME'     	, width: 167},
        	{dataIndex: 'TROUBLE_TIME'  	, width: 100},
        	{dataIndex: 'TROUBLE'       	, width: 256},
        	{dataIndex: 'WKORD_NUM' 		, width: 100},
        	{dataIndex: 'LOT_NO'        	, width: 100}			
        ] 
    });		//End of var masterGrid3 = Unilite.createGrid('pmr120skrvGrid3', {

    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				topSearch ,masterGrid1, masterGrid2 , masterGrid3
			]	
		},
			panelSearch
		],
		id: 'pmr120skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function(){			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore1.loadStoreRecords();
				directMasterStore2.loadStoreRecords();
				directMasterStore3.loadStoreRecords();
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

	});		// End of Unilite.Main({
};
</script>
