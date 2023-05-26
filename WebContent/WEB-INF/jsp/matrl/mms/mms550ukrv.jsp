<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms550ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 입고담당 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
		<t:ExtComboStore comboType="OU" />										<!-- 창고-->
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

	Unilite.defineModel('Mms550ukrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'          		   ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>' 			,type: 'string'},
	    	{name: 'DIV_CODE'           		   ,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 			    ,type: 'string'},
	    	{name: 'INOUT_NUM'          		   ,text: '<t:message code="system.label.purchase.tranno" default="수불번호"/>' 			,type: 'string'},
	    	{name: 'INOUT_SEQ'          		   ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 				,type: 'string'},
	    	{name: 'INOUT_METH'         		   ,text: '<t:message code="system.label.purchase.receiptmethod" default="입고방법"/>' 			,type: 'string'},
	    	{name: 'INOUT_TYPE_DETAIL'  		   ,text: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>' 			,type: 'string'},
	    	{name: 'ITEM_CODE'          		   ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 			,type: 'string'},
	    	{name: 'ITEM_NAME'          		   ,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>' 				,type: 'string'},
	    	{name: 'SPEC'               		   ,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 				,type: 'string'},
	    	{name: 'BARCODE'            		   ,text: '바코드' 			    ,type: 'string'},
	    	{name: 'ORDER_UNIT'         		   ,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>' 			,type: 'string'},
	    	{name: 'ORIGINAL_Q'         		   ,text: '<t:message code="system.label.purchase.existinginqty" default="기존입고량"/>' 			,type: 'string'},
	    	{name: 'ORDER_UNIT_Q'       		   ,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>' 			    ,type: 'string'},
	    	{name: 'LOT_NO'             		   ,text: 'LOT NO' 			    ,type: 'string'},
	    	{name: 'ITEM_STATUS'        		   ,text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>' 			,type: 'string'},
	    	{name: 'WH_CODE'            		   ,text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>' 			,type: 'string'},
	    	{name: 'WH_NAME'            		   ,text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>' 			,type: 'string'},
	    	{name: 'WH_CELL_CODE'       		   ,text: '입고창고 Cell' 		,type: 'string'},
	    	{name: 'WH_CELL_NAME'       		   ,text: '입고창고 Cell' 		,type: 'string'},
	    	{name: 'INOUT_DATE'         		   ,text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>' 			    ,type: 'string'},
	    	{name: 'INOUT_PRSN'         		   ,text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>' 			,type: 'string'},
	    	{name: 'ORDER_UNIT_P'       		   ,text: '<t:message code="system.label.purchase.purchaseprice" default="구매단가"/>' 			,type: 'string'},
	    	{name: 'ORDER_UNIT_O'       		   ,text: '<t:message code="system.label.purchase.purchaseamount" default="구매금액"/>' 			,type: 'string'},
	    	{name: 'EXCHG_RATE_O'       		   ,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>' 				,type: 'string'},
	    	{name: 'ORDER_UNIT_FOR_P'   		   ,text: '구매단가(외화)' 		,type: 'string'},
	    	{name: 'ORDER_UNIT_FOR_O'   		   ,text: '구매금액(외화)' 		,type: 'string'},
	    	{name: 'PRICE_YN'           		   ,text: '단가유형' 			,type: 'string'},
	    	{name: 'ACCOUNT_YNC'        		   ,text: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>' 			,type: 'string'},
	    	{name: 'ACCOUNT_Q'          		   ,text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>' 			,type: 'string'},
	    	{name: 'ORDER_TYPE'         		   ,text: '<t:message code="system.label.purchase.potype" default="발주형태"/>' 			,type: 'string'},
	    	{name: 'ORDER_NUM'          		   ,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>' 			,type: 'string'},
	    	{name: 'ORDER_SEQ'          		   ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 				,type: 'string'},
	    	{name: 'BASIS_NUM'          		   ,text: '<t:message code="system.label.purchase.basisno" default="근거번호"/>' 			,type: 'string'},
	    	{name: 'BASIS_SEQ'          		   ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 				,type: 'string'},
	    	{name: 'LC_NUM'             		   ,text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>' 			    ,type: 'string'},
	    	{name: 'BL_NUM'             		   ,text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>' 			    ,type: 'string'},
	    	{name: 'INSPEC_NUM'         		   ,text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>' 			,type: 'string'},
	    	{name: 'INSPEC_SEQ'         		   ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 				,type: 'string'},
	    	{name: 'STOCK_UNIT'         		   ,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>' 			,type: 'string'},
	    	{name: 'TRNS_RATE'          		   ,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>' 				,type: 'string'},
	    	{name: 'INOUT_Q'            		   ,text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>' 		,type: 'string'},
	    	{name: 'MONEY_UNIT'         		   ,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>' 			,type: 'string'},
	    	{name: 'INOUT_P'            		   ,text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>' 		,type: 'string'},
	    	{name: 'INOUT_I'            		   ,text: '<t:message code="system.label.purchase.inventoryunitamount" default="재고단위금액"/>' 		,type: 'string'},
	    	{name: 'INOUT_FOR_P'        		   ,text: '재고단위단가(외화)' 	,type: 'string'},
	    	{name: 'INOUT_FOR_O'        		   ,text: '재고단위금액(외화)' 	,type: 'string'},
	    	{name: 'EXPENSE_I'          		   ,text: '<t:message code="system.label.purchase.expenseamount" default="경비금액"/>' 			,type: 'string'},
	    	{name: 'PROJECT_NO'         		   ,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>' 		,type: 'string'},
	    	{name: 'REMARK'             		   ,text: '<t:message code="system.label.purchase.remarks" default="비고"/>' 				,type: 'string'},
	    	{name: 'INOUT_TYPE'         		   ,text: '입고타입' 			,type: 'string'},
	    	{name: 'INOUT_CODE_TYPE'    		   ,text: '<t:message code="system.label.purchase.receiptplacetype" default="입고처구분"/>' 			,type: 'string'},
	    	{name: 'INOUT_CODE'         		   ,text: '<t:message code="system.label.purchase.receiptplace" default="입고처"/>' 			    ,type: 'string'},
	    	{name: 'INOUT_NAME'         		   ,text: '입고처명' 			,type: 'string'},
	    	{name: 'CREATE_LOC'         		   ,text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>' 			,type: 'string'},
	    	{name: 'SALE_DIV_CODE'      		   ,text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>' 			,type: 'string'},
	    	{name: 'SALE_CUSTOM_CODE'   		   ,text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>' 			    ,type: 'string'},
	    	{name: 'BILL_TYPE'          		   ,text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>' 			,type: 'string'},
	    	{name: 'SALE_TYPE'          		   ,text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>' 			,type: 'string'},
	    	{name: 'EXCESS_RATE'        		   ,text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>' 		,type: 'string'},
	    	{name: 'SCM_FLAG_YN'        		   ,text: 'SCM연계여부' 		,type: 'string'},
	    	{name: 'CIR_PERIOD_YN'      		   ,text: '제조일자관리여부' 	,type: 'string'},
	    	{name: 'MAKE_DATE'          		   ,text: '제조일자' 			,type: 'string'},
	    	{name: 'ITEM_LEVEL1'        		   ,text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>' 			    ,type: 'string'},
	    	{name: 'ITEM_LEVEL2'        		   ,text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>' 			    ,type: 'string'},
	    	{name: 'ITEM_LEVEL3'        		   ,text: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>' 			    ,type: 'string'},
	    	{name: 'TEMPC_01'           		   ,text: '파일명' 			    ,type: 'string'},
	    	{name: 'DATA_CHECK'         		   ,text: '검증' 				,type: 'string'},
	    	{name: 'UPDATE_DB_USER'     		   ,text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>' 			    ,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'     		   ,text: '<t:message code="system.label.purchase.updatedate" default="수정일"/>' 			    ,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mms550ukrvMasterStore1',{
			model: 'Mms550ukrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'mms550ukrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField: 'CUSTOM_NAME'
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',		
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false
			},
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
					textFieldWidth: 70,
					allowBlank:false
				}),
			{					
    			fieldLabel: '바코드 파일',
    			name:'',
    			xtype: 'uniTextfield'
    		},{
		    	xtype: 'container',
		    	layout: {
		    		type: 'hbox',
					align: 'center',
					pack:'center'
		    	},
    			items:[
    			    {
    			    	xtype: 'button',
    			    	text: 'Upload'
    			    }]
    		},{ 
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				allowBlank:false,
				width : 200
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>', 
				name:'', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B024'
			},{
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
				name:'', 
				xtype: 'uniCombobox', 
				comboType   : 'OU'
			},{
    			xtype: 'component',
    			autoEl: {
        			html: '<hr width="350px">'
    			}
			},{
		    	xtype: 'container',
		    	padding: '10 0 0 0',
		    	layout: {
		    		type: 'hbox',
					align: 'center',
					pack:'center'
		    	},
		    	items:[
		    	{
		    		xtype: 'button',
		    		text: '출력'
		    	},{
		    		xtype: 'button',
		    		text: 'PDA->ERP'
		    	}]
		    }]	
		}]
	});    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('mms550ukrvGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	store: directMasterStore1,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
               		 { dataIndex: 'COMP_CODE'        		, 	width:66,hidden:true},        
               		 { dataIndex: 'DIV_CODE'         		, 	width:66,hidden:true},        
               		 { dataIndex: 'INOUT_NUM'        		, 	width:66,hidden:true},        
               		 { dataIndex: 'INOUT_METH'       		, 	width:66,hidden:true}, 
               		 {text:'바코드정보',locked:true,
               		 	columns:[
               		 		{ dataIndex: 'INOUT_SEQ'        		, 	width:40,locked:true},   
               				{ dataIndex: 'INOUT_TYPE_DETAIL'		, 	width:66,locked:true},        
               		 		{ dataIndex: 'ITEM_CODE'        		, 	width:100,locked:true} 
               		 	]
               		 },
               		  { dataIndex: 'BARCODE'          		, 	width:66,hidden:true},  
               		  { dataIndex: 'ORIGINAL_Q'       		, 	width:66,hidden:true}, 
               		  { dataIndex: 'WH_CODE'          		, 	width:86,hidden:true},
               		 {text:'바코드정보',
               		 	columns:[
               		 		{ dataIndex: 'ITEM_NAME'        		, 	width:133},
               		 		{ dataIndex: 'SPEC'             		, 	width:133},
               		 		{ dataIndex: 'ORDER_UNIT'       		, 	width:66},
               		 		{ dataIndex: 'ORDER_UNIT_Q'     		, 	width:100},
               		 		{ dataIndex: 'ITEM_STATUS'      		, 	width:80},
               		 		{ dataIndex: 'WH_NAME'          		, 	width:86},
               		 		{ dataIndex: 'INOUT_PRSN'       		, 	width:66}
               		 	]
               		 },
               		 {text:'금액정보',
               		 	columns:[
               		 		{ dataIndex: 'ORDER_UNIT_P'     		, 	width:100},        
               		 		{ dataIndex: 'ORDER_UNIT_O'     		, 	width:100},
               		 		{ dataIndex: 'PRICE_YN'         		, 	width:66},        
               		 		{ dataIndex: 'ACCOUNT_YNC'      		, 	width:66}
               		 	]
               		 },
               		 {text:'발주정보',
               		 	columns:[
               		 		{ dataIndex: 'ORDER_TYPE'       		, 	width:66},        
               		 		{ dataIndex: 'ORDER_NUM'        		, 	width:100},        
               				{ dataIndex: 'ORDER_SEQ'        		, 	width:40},        
               		 		{ dataIndex: 'BASIS_NUM'        		, 	width:100},        
               				{ dataIndex: 'BASIS_SEQ'        		, 	width:40}
               		 	]
               		 },
               		 {text:'재고정보',
               		 	columns:[
               		 		{ dataIndex: 'TRNS_RATE'        		, 	width:86},        
               				{ dataIndex: 'INOUT_Q'          		, 	width:100}
               		 	]
               		 },
               		 {text:'기타',
               		 	columns:[
               		 		{ dataIndex: 'PROJECT_NO'       		, 	width:133},        
               		 		{ dataIndex: 'REMARK'           		, 	width:133}   
               		 	]
               		 },
               		 { dataIndex: 'LOT_NO'           		, 	width:100,hidden:true},        
               		 { dataIndex: 'WH_CELL_CODE'     		, 	width:86,hidden:true},        
               		 { dataIndex: 'WH_CELL_NAME'     		, 	width:86,hidden:true},        
               		 { dataIndex: 'INOUT_DATE'       		, 	width:66,hidden:true},             
               		 { dataIndex: 'EXCHG_RATE_O'     		, 	width:66,hidden:true},        
               		 { dataIndex: 'ORDER_UNIT_FOR_P' 		, 	width:100,hidden:true},        
               		 { dataIndex: 'ORDER_UNIT_FOR_O' 		, 	width:100,hidden:true},        
               		 { dataIndex: 'ACCOUNT_Q'        		, 	width:66,hidden:true},        
               		 { dataIndex: 'LC_NUM'           		, 	width:100,hidden:true},        
               		 { dataIndex: 'BL_NUM'           		, 	width:100,hidden:true},        
               		 { dataIndex: 'INSPEC_NUM'       		, 	width:100,hidden:true},        
               		 { dataIndex: 'INSPEC_SEQ'       		, 	width:40,hidden:true},        
               		 { dataIndex: 'STOCK_UNIT'       		, 	width:53,hidden:true},        
               		 { dataIndex: 'MONEY_UNIT'       		, 	width:53,hidden:true},        
               		 { dataIndex: 'INOUT_P'          		, 	width:100,hidden:true},        
               		 { dataIndex: 'INOUT_I'          		, 	width:100,hidden:true},        
               		 { dataIndex: 'INOUT_FOR_P'      		, 	width:100,hidden:true},        
               		 { dataIndex: 'INOUT_FOR_O'      		, 	width:100,hidden:true},        
               		 { dataIndex: 'EXPENSE_I'        		, 	width:100,hidden:true},        
               		 { dataIndex: 'INOUT_TYPE'       		, 	width:66,hidden:true},        
               		 { dataIndex: 'INOUT_CODE_TYPE'  		, 	width:66,hidden:true},        
               		 { dataIndex: 'INOUT_CODE'       		, 	width:66,hidden:true},        
               		 { dataIndex: 'INOUT_NAME'       		, 	width:66,hidden:true},        
               		 { dataIndex: 'CREATE_LOC'       		, 	width:66,hidden:true},        
               		 { dataIndex: 'SALE_DIV_CODE'    		, 	width:66,hidden:true},        
               		 { dataIndex: 'SALE_CUSTOM_CODE' 		, 	width:66,hidden:true},        
               		 { dataIndex: 'BILL_TYPE'        		, 	width:66,hidden:true},        
               		 { dataIndex: 'SALE_TYPE'        		, 	width:66,hidden:true},        
               		 { dataIndex: 'EXCESS_RATE'      		, 	width:66,hidden:true},        
               		 { dataIndex: 'SCM_FLAG_YN'      		, 	width:66,hidden:true},        
               		 { dataIndex: 'CIR_PERIOD_YN'    		, 	width:66,hidden:true},        
               		 { dataIndex: 'MAKE_DATE'        		, 	width:66,hidden:true},        
               		 { dataIndex: 'ITEM_LEVEL1'      		, 	width:66,hidden:true},        
               		 { dataIndex: 'ITEM_LEVEL2'      		, 	width:66,hidden:true},        
               		 { dataIndex: 'ITEM_LEVEL3'      		, 	width:66,hidden:true},        
               		 { dataIndex: 'TEMPC_01'         		, 	width:66,hidden:true},        
               		 { dataIndex: 'DATA_CHECK'       		, 	width:66,hidden:true},        
               		 { dataIndex: 'UPDATE_DB_USER'   		, 	width:66,hidden:true},        
               		 { dataIndex: 'UPDATE_DB_TIME'   		, 	width:66,hidden:true}
        ] 
    });   
	
    Unilite.Main( {
		borderItems:[ 
	 		 masterGrid1,
			panelSearch
		],
		id  : 'mms550ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			
				masterGrid1.getStore().loadStoreRecords();
				var viewLocked = masterGrid1.lockedGrid.getView();
				var viewNormal = masterGrid1.normalGrid.getView();
				console.log("viewLocked : ",viewLocked);
				console.log("viewNormal : ",viewNormal);
			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
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
