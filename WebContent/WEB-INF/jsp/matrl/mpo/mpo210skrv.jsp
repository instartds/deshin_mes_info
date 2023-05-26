<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo210skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo210skrv" /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="YP42" /> <!--발송결과-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}'
};
function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Mpo210skrvModel', {
	    fields: [
        {name: 'TEMP_GUBUN1'         , text: 'TEMP_GUBUN1'    , type: 'string'},
	    	{name: 'GUBUN1'			, text: '<t:message code="system.label.purchase.classfication" default="구분"/>'	, type: 'string'},
	    	{name: 'WEEK_DAY'			, text: '<t:message code="system.label.purchase.week" default="주차"/>'		, type: 'string'},
	    	{name: 'SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'		, type: 'string'},
	    	{name: 'GUBUN'		, text: '<t:message code="system.label.purchase.planmonth" default="계획월"/>'		, type: 'string'},
	    	
	    	{name: 'GT_INOUT_O'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'GT_C_INOUT_O'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'GT_T_INOUT_O'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'},
	    	
	    	{name: 'INOUT_O1'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'C_INOUT_O1'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'T_INOUT_O1'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'},
	    	
	    	{name: 'INOUT_O2'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'C_INOUT_O2'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'T_INOUT_O2'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'},
	    	
	    	{name: 'INOUT_O3'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'C_INOUT_O3'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'T_INOUT_O3'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'},
	    	
	    	{name: 'INOUT_O4'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'C_INOUT_O4'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'T_INOUT_O4'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'},
	    	
	    	{name: 'INOUT_O5'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'C_INOUT_O5'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'T_INOUT_O5'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'},
	    	
	    	{name: 'INOUT_O6'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'C_INOUT_O6'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'T_INOUT_O6'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'},
	    	
	    	{name: 'INOUT_O7'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'C_INOUT_O7'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'T_INOUT_O7'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'},
	    	
	    	{name: 'INOUT_O8'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'C_INOUT_O8'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'T_INOUT_O8'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'},
	    	
	    	{name: 'INOUT_O9'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'C_INOUT_O9'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'T_INOUT_O9'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'},
	    	
	    	{name: 'INOUT_O10'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'C_INOUT_O10'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'T_INOUT_O10'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'},
	    	
	    	{name: 'INOUT_O11'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'C_INOUT_O11'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'T_INOUT_O11'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'},
	   		
	    	{name: 'INOUT_O12'		, text: '<t:message code="system.label.purchase.credit" default="외상"/>'	, type: 'uniQty'},
	    	{name: 'C_INOUT_O12'		, text: '<t:message code="system.label.purchase.cash" default="현금"/>'		, type: 'uniQty'},
	    	{name: 'T_INOUT_O12'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'		, type: 'uniQty'}
	  
	    ]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo210skrvService.selectList',
			update: 'mpo210skrvService.updateDetail',
			syncAll: 'mpo210skrvService.saveAll'
		}
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('mpo210skrvMasterStore1', {
		model: 'Mpo210skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();
			param.TYPE = "1";
			console.log( param );
			this.load({
				params: param
			});				
		},			
		saveStore: function() {
			config = {
				success: function(batch, option) {
					UniAppManager.setToolbarButtons('save', false);
					masterGrid.getStore().loadStoreRecords();
				}
			};
			this.syncAllDirect(config);
		}
    	//,groupField: 'GUBUN1'
				
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		 		fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
		 		name:'DIV_CODE', 
		 		xtype: 'uniCombobox',
		 		comboType:'BOR120',
		 		allowBlank:false,
		 		value : UserInfo.divCode,
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
		 	},{
            	fieldLabel: '<t:message code="system.label.purchase.baseyear" default="기준년도"/>',
            	name: 'FR_DATE',
            	xtype: 'uniYearField',
		 		value: new Date().getFullYear(),
				holdable: 'hold', 
            	allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FR_DATE', newValue);
						/*var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
						getDate(date);*/
					}
				}
            }]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
		 		fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
		 		name:'DIV_CODE', 
		 		xtype: 'uniCombobox',
		 		comboType:'BOR120',
		 		allowBlank:false,
		 		value : UserInfo.divCode,
		 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		 	},{
		 		fieldLabel: '<t:message code="system.label.purchase.baseyear" default="기준년도"/>',
		 		xtype: 'uniYearField',
		 		name: 'FR_DATE',
		 		value: new Date().getFullYear(),
		 		allowBlank:false,
		 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('FR_DATE', newValue);
					/*var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
					getDate(date);*/
					}
				}
			}]
    });		
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('mpo210skrvGrid1', {
		layout: 'fit',
		region: 'center',
		excelTitle: '연간발주대비입고현황',
		uniOpt: {
    		useGroupSummary: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
    	store: directMasterStore,
		selModel:'rowmodel',
		viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store){
                var cls = '';
                
                if(record.get('TEMP_GUBUN1') == '발주'){
                    if(record.get('GUBUN1') == '구분계'){
                        cls = 'x-change-cell_row2';
                    }
                }else if(record.get('TEMP_GUBUN1') == '입고'){
                    if(record.get('GUBUN1') == '구분계'){
                        cls = 'x-change-cell_row3';
                    }
                }
                return cls;
            }
        },
        columns: [

	    	{dataIndex: 'GUBUN1'			, width: 100,
                renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
                    if(val == "발주"){
                        metaData.tdCls = 'x-change-cell_color1';
                    }
                    else if(val == "입고") {
                        metaData.tdCls = 'x-change-cell_color2';
                    }
                    return val;
                }   
	    	
	    	},
	    	
	    	{dataIndex: 'WEEK_DAY'			, width: 100},
	    	{dataIndex: 'SEQ'			, width: 100, hidden:true},
	    	{dataIndex: 'GUBUN'			, width: 100},
	    	
	    	
	    	
    		{text :'<t:message code="system.label.purchase.whole" default="전체"/>',
        			columns:[ 
        				{dataIndex:'GT_INOUT_O'	 , width: 100,summaryType: 'sum'},
        				{dataIndex:'GT_C_INOUT_O'	 , width: 100,summaryType: 'sum'},
        				{dataIndex:'GT_T_INOUT_O'	 , width: 100,summaryType: 'sum'}
        			]
    		},
        	
    		{text :'1<t:message code="system.label.purchase.month" default="월"/>',
        			columns:[ 
        				{dataIndex:'INOUT_O1'	 , width: 100,summaryType: 'sum'},
        				{dataIndex:'C_INOUT_O1'	 , width: 100,summaryType: 'sum'},
        				{dataIndex:'T_INOUT_O1'	 , width: 100,summaryType: 'sum'}
        			]
    		},
    		{text :'2<t:message code="system.label.purchase.month" default="월"/>',
        			columns:[ 
        				{dataIndex:'INOUT_O2'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'C_INOUT_O2'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'T_INOUT_O2'	 , width: 100, summaryType: 'sum'}
        			]
    		},
        	{text :'3<t:message code="system.label.purchase.month" default="월"/>',
        			columns:[ 
        				{dataIndex:'INOUT_O3'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'C_INOUT_O3'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'T_INOUT_O3'	 , width: 100, summaryType: 'sum'}
        			]
    		},
			{text :'4<t:message code="system.label.purchase.month" default="월"/>',
        			columns:[ 
        				{dataIndex:'INOUT_O4'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'C_INOUT_O4'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'T_INOUT_O4'	 , width: 100, summaryType: 'sum'}
        			]
    		},
			{text :'5<t:message code="system.label.purchase.month" default="월"/>',
        			columns:[ 
        				{dataIndex:'INOUT_O5'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'C_INOUT_O5'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'T_INOUT_O5'	 , width: 100, summaryType: 'sum'}
        			]
    		},
			{text :'6<t:message code="system.label.purchase.month" default="월"/>',
        			columns:[ 
        				{dataIndex:'INOUT_O6'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'C_INOUT_O6'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'T_INOUT_O6'	 , width: 100, summaryType: 'sum'}
        			]
    		},
			{text :'7<t:message code="system.label.purchase.month" default="월"/>',
        			columns:[ 
        				{dataIndex:'INOUT_O7'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'C_INOUT_O7'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'T_INOUT_O7'	 , width: 100, summaryType: 'sum'}
        			]
    		},
			{text :'8<t:message code="system.label.purchase.month" default="월"/>',
        			columns:[ 
        				{dataIndex:'INOUT_O8'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'C_INOUT_O8'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'T_INOUT_O8'	 , width: 100, summaryType: 'sum'}
        			]
    		},
			{text :'9<t:message code="system.label.purchase.month" default="월"/>',
        			columns:[ 
        				{dataIndex:'INOUT_O9'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'C_INOUT_O9'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'T_INOUT_O9'	 , width: 100, summaryType: 'sum'}
        			]
    		},
			{text :'10<t:message code="system.label.purchase.month" default="월"/>',
        			columns:[ 
        				{dataIndex:'INOUT_O10'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'C_INOUT_O10'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'T_INOUT_O10'	 , width: 100, summaryType: 'sum'}
        			]
    		},
			{text :'11<t:message code="system.label.purchase.month" default="월"/>',
        			columns:[ 
        				{dataIndex:'INOUT_O11'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'C_INOUT_O11'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'T_INOUT_O11'	 , width: 100, summaryType: 'sum'}
        			]
    		},
			{text :'12<t:message code="system.label.purchase.month" default="월"/>',
        			columns:[ 
        				{dataIndex:'INOUT_O12'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'C_INOUT_O12'	 , width: 100, summaryType: 'sum'},
        				{dataIndex:'T_INOUT_O12'	 , width: 100, summaryType: 'sum'}
        			]
    		}			
        	
		],listeners:{
          	onGridDblClick:function(grid, record, cellIndex, colName) {
                  if(!record.phantom) {
//                  	console.log("record",record);
                  	 var month = colName.substring(colName.length-2,colName.length);
                  	 if(UniUtils.indexOf(month, ['O1','O2','O3','O4','O5','O6','O7','O8','O9','10','11','12'])){
	                  	 var params=panelResult.getValues();
	                  	 
	                  	 params.PGM_ID = 'mpo210skrv';
	                  	 params.FR_DATE = params.FR_DATE+month.replace('O','0');
	                  	 params.WEEK_DAY = record.get('WEEK_DAY');
//	                  	 console.log('params.FR_DATE:'+params.FR_DATE);
	                  	 
	                  	 if(record.get('GUBUN1') == '발주'){
                            var rec1 = {data : {prgID : 'mpo220skrv', 'text':''}};
                            parent.openTab(rec1,"/matrl/mpo220skrv.do",params);
	                  	 }else if(record.get('GUBUN1') == '입고'){
                            var rec1 = {data : {prgID : 'mpo230skrv', 'text':''}};
                            parent.openTab(rec1,"/matrl/mpo230skrv.do",params);
	                  	 	
	                  	 }
						 
                  	 }
                  	 
                  }
              }
          } 
    });
	
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id: 'mpo210skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('FR_DATE',new Date().getFullYear());
			
			panelResult.setValue('FR_DATE',new Date().getFullYear());
			
			
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown: function() {	
			masterGrid.getStore().loadStoreRecords();			
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		}
	});
};


</script>
