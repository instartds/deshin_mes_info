
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms502ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
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

	Unilite.defineModel('Mms502ukrvModel', {
	    fields: [
	    	{name: 'INOUT_NUM'         ,text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>' 			,type: 'string'},
	    	{name: 'INOUT_SEQ'         ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 				,type: 'string'},
	    	{name: 'INOUT_METH'        ,text: '<t:message code="system.label.purchase.method" default="방법"/>' 				,type: 'string'},
	    	{name: 'INOUT_TYPE_DETAIL' ,text: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>' 			,type: 'string'},
	    	{name: 'ITEM_CODE'         ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 			,type: 'string'},
	    	{name: 'ITEM_NAME'         ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>' 			,type: 'string'},
	    	{name: 'ITEM_ACCOUNT'      ,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>' 			,type: 'string'},
	    	{name: 'SPEC'              ,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 				,type: 'string'},
	    	{name: 'ORDER_UNIT'        ,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>' 			,type: 'string'},
	    	{name: 'ORDER_UNIT_Q'      ,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>' 			,type: 'uniQty'},
	    	{name: 'ITEM_STATUS'       ,text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>' 			,type: 'string'},
	    	{name: 'ORIGINAL_Q'        ,text: '<t:message code="system.label.purchase.existinginqty" default="기존입고량"/>' 			,type: 'uniQty'},
	    	{name: 'GOOD_STOCK_Q'      ,text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>' 			,type: 'string'},
	    	{name: 'BAD_STOCK_Q'       ,text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>' 			,type: 'string'},
	    	{name: 'NOINOUT_Q'         ,text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>' 			,type: 'uniQty'},
	    	{name: 'PRICE_YN'          ,text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>' 			,type: 'string'},
	    	{name: 'MONEY_UNIT'        ,text: '<t:message code="system.label.purchase.currency" default="화폐"/>' 				,type: 'string'},
	    	{name: 'INOUT_FOR_P'       ,text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>' 		,type: 'uniUnitPrice'},
	    	{name: 'INOUT_FOR_O'       ,text: '<t:message code="system.label.purchase.inventoryunitamount" default="재고단위금액"/>' 		,type: 'uniPrice'},
	    	{name: 'ORDER_UNIT_FOR_P'  ,text: '<t:message code="system.label.purchase.price" default="단가"/>' 				,type: 'uniUnitPrice'},
	    	{name: 'ORDER_UNIT_FOR_O'  ,text: '<t:message code="system.label.purchase.amount" default="금액"/>' 				,type: 'uniPrice'},
	    	{name: 'ACCOUNT_YNC'       ,text: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>' 			,type: 'string'},
	    	{name: 'EXCHG_RATE_O'      ,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>' 				,type: 'uniER'},
	    	{name: 'INOUT_P'           ,text: '<t:message code="system.label.purchase.copricestock" default="자사단가(재고)"/>' 		,type: 'uniUnitPrice'},
	    	{name: 'INOUT_I'           ,text: '<t:message code="system.label.purchase.coamountstock" default="자사금액(재고)"/>' 		,type: 'uniPrice'},
	    	{name: 'ORDER_UNIT_P'      ,text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>' 			,type: 'uniPrice'},
	    	{name: 'ORDER_UNIT_I'      ,text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>' 			,type: 'uniPrice'},
	    	{name: 'STOCK_UNIT'        ,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>' 			,type: 'string'},
	    	{name: 'TRNS_RATE'         ,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>' 				,type: 'string'},
	    	{name: 'INOUT_Q'           ,text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>' 		,type: 'uniQty'},
	    	{name: 'ORDER_TYPE'        ,text: '<t:message code="system.label.purchase.potype" default="발주형태"/>' 			,type: 'string'},
	    	{name: 'LC_NUM'            ,text: 'LC/NO(*)' 		,type: 'string'},
	    	{name: 'BL_NUM'            ,text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>' 			,type: 'string'},
	    	{name: 'ORDER_NUM'         ,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>' 			,type: 'string'},
	    	{name: 'ORDER_SEQ'         ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 				,type: 'string'},
	    	{name: 'ORDER_Q'           ,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>' 			,type: 'uniQty'},
	    	{name: 'INOUT_CODE_TYPE'   ,text: '<t:message code="system.label.purchase.receiptplacetype" default="입고처구분"/>' 			,type: 'string'},
	    	{name: 'WH_CODE'           ,text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>' 			,type: 'string'},
	    	{name: 'WH_CELL_CODE'	   ,text: 'CELL창고' 			,type: 'string'},
	    	{name: 'WH_CELL_NAME'	   ,text: 'CELL창고' 			,type: 'string'},
	    	{name: 'INOUT_DATE'        ,text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>' 			,type: 'uniDate'},
	    	{name: 'INOUT_PRSN'        ,text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>' 			,type: 'string'},
	    	{name: 'ACCOUNT_Q'         ,text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>' 			,type: 'uniQty'},
	    	{name: 'CREATE_LOC'        ,text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>' 			,type: 'string'},
	    	{name: 'SALE_C_DATE'       ,text: '<t:message code="system.label.purchase.billclosingdate" default="계산서마감일"/>' 		,type: 'uniDate'},
	    	{name: 'REMARK'            ,text: '<t:message code="system.label.purchase.remarks" default="비고"/>' 				,type: 'string'},
	    	{name: 'PROJECT_NO'        ,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>' 			,type: 'string'},
	    	{name: 'LOT_NO'            ,text: 'LOT NO' 			,type: 'string'},
	    	{name: 'INOUT_TYPE'        ,text: '<t:message code="system.label.purchase.type" default="타입"/>' 				,type: 'string'},
	    	{name: 'INOUT_CODE'        ,text: '<t:message code="system.label.purchase.receiptplace" default="입고처"/>' 			,type: 'string'},
	    	{name: 'DIV_CODE'          ,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 			,type: 'string'},
	    	{name: 'CUSTOM_NAME'       ,text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>' 			,type: 'string'},
	    	{name: 'COMPANY_NUM'       ,text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>' 			,type: 'string'},
	    	{name: 'INSTOCK_Q'         ,text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>' 		,type: 'uniQty'},
	    	{name: 'SALE_DIV_CODE'     ,text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>' 			,type: 'string'},
	    	{name: 'SALE_CUSTOM_CODE'  ,text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>' 			,type: 'string'},
	    	{name: 'BILL_TYPE'         ,text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>' 			,type: 'string'},
	    	{name: 'SALE_TYPE'         ,text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>' 			,type: 'string'},
	    	{name: 'UPDATE_DB_USER'    ,text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>' 			,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'    ,text: '수정한 날짜' 		,type: 'uniDate'},
	    	{name: 'EXCESS_RATE'       ,text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>' 		,type: 'string'},
	    	{name: 'INSPEC_NUM'        ,text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>' 			,type: 'string'},
	    	{name: 'INSPEC_SEQ'        ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 				,type: 'string'},
	    	{name: 'COMP_CODE'         ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>' 			,type: 'string'},
	    	{name: 'BASIS_NUM'         ,text: 'BASIS_NUM' 		,type: 'string'},
	    	{name: 'BASIS_SEQ'         ,text: 'BASIS_SEQ' 		,type: 'string'},
	    	{name: 'SCM_FLAG_YN'       ,text: 'SCM_FLAG_YN' 	,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mms502ukrvMasterStore1',{
			model: 'Mms502ukrvModel',
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
                	   read: 'mms502ukrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField: ''
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
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				allowBlank:false,
				width : 200
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name:'', 
				xtype: 'uniCombobox', 
				comboType   : 'OU',
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>', 
				name:'', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B024'
			},{					
    			fieldLabel: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>', 
				name: '', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B004', 
				displayField: 'value',
				fieldStyle: 'text-align: center;',
				allowBlank: false
			},{					
    			fieldLabel: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',
    			name:'',
    			xtype: 'uniTextfield',
    			allowBlank: false
    		}]	
		}]
	});  
	
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'south',
    	//padding:'10 10 10 10',
	    items: [{	
	    	xtype:'container',
	    	padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {
	        	type: 'uniTable',
	        	columns : 2,
	        	tableAttrs: {align:'right'}
	        },
	        items: [{
	        	fieldLabel: '금액합계',
	        	xtype: 'uniNumberfield',
	        	readOnly: true
	        },{
	       	 	fieldLabel: '자사금액합계',
	       	 	xtype: 'uniNumberfield',
	        	readOnly: true
	        }]
	    }]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('mms502ukrvGrid1', {
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
               		{ dataIndex: 'INOUT_NUM'         , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_SEQ'         , 	width:66, locked: true},
               		 { dataIndex: 'INOUT_METH'        , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_TYPE_DETAIL' , 	width:66, locked: true},
               		 { dataIndex: 'ITEM_CODE'         , 	width:93, locked: true},
               		 { dataIndex: 'ITEM_NAME'         , 	width:133, locked: true},
               		 { dataIndex: 'ITEM_ACCOUNT'      , 	width:66, hidden: true},
               		 { dataIndex: 'SPEC'              , 	width:133},
               		 { dataIndex: 'ORDER_UNIT'        , 	width:66},
               		 { dataIndex: 'ORDER_UNIT_Q'      , 	width:102},
               		 { dataIndex: 'ITEM_STATUS'       , 	width:80},
               		 { dataIndex: 'ORIGINAL_Q'        , 	width:66, hidden: true},
               		 { dataIndex: 'GOOD_STOCK_Q'      , 	width:66, hidden: true},
               		 { dataIndex: 'BAD_STOCK_Q'       , 	width:66, hidden: true},
               		 { dataIndex: 'NOINOUT_Q'         , 	width:66, hidden: true},
               		 { dataIndex: 'PRICE_YN'          , 	width:66},
               		 { dataIndex: 'MONEY_UNIT'        , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_FOR_P'       , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_FOR_O'       , 	width:66, hidden: true},
               		 { dataIndex: 'ORDER_UNIT_FOR_P'  , 	width:120, hidden: true},
               		 { dataIndex: 'ORDER_UNIT_FOR_O'  , 	width:116, hidden: true},
               		 { dataIndex: 'ACCOUNT_YNC'       , 	width:66},
               		 { dataIndex: 'EXCHG_RATE_O'      , 	width:62, hidden: true},
               		 { dataIndex: 'INOUT_P'           , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_I'           , 	width:66, hidden: true},
               		 { dataIndex: 'ORDER_UNIT_P'      , 	width:88, hidden: true},
               		 { dataIndex: 'ORDER_UNIT_I'      , 	width:100, hidden: true},
               		 { dataIndex: 'STOCK_UNIT'        , 	width:80, hidden: true},
               		 { dataIndex: 'TRNS_RATE'         , 	width:80},
               		 { dataIndex: 'INOUT_Q'           , 	width:124},
               		 { dataIndex: 'ORDER_TYPE'        , 	width:80},
               		 { dataIndex: 'LC_NUM'            , 	width:100, hidden: true},
               		 { dataIndex: 'BL_NUM'            , 	width:66},
               		 { dataIndex: 'ORDER_NUM'         , 	width:133},
               		 { dataIndex: 'ORDER_SEQ'         , 	width:33},
               		 { dataIndex: 'ORDER_Q'           , 	width:100, hidden: true},
               		 { dataIndex: 'INOUT_CODE_TYPE'   , 	width:33, hidden: true},
               		 { dataIndex: 'WH_CODE'           , 	width:66, hidden: true},
               		 { dataIndex: 'WH_CELL_CODE'	  , 	width:166, hidden: true},
               		 { dataIndex: 'WH_CELL_NAME'	  , 	width:166, hidden: true},
               		 { dataIndex: 'INOUT_DATE'        , 	width:73, hidden: true},
               		 { dataIndex: 'INOUT_PRSN'        , 	width:33, hidden: true},
               		 { dataIndex: 'ACCOUNT_Q'         , 	width:33, hidden: true},
               		 { dataIndex: 'CREATE_LOC'        , 	width:33, hidden: true},
               		 { dataIndex: 'SALE_C_DATE'       , 	width:33, hidden: true},
               		 { dataIndex: 'REMARK'            , 	width:133},
               		 { dataIndex: 'PROJECT_NO'        , 	width:133},
               		 { dataIndex: 'LOT_NO'            , 	width:133},
               		 { dataIndex: 'INOUT_TYPE'        , 	width:33, hidden: true},
               		 { dataIndex: 'INOUT_CODE'        , 	width:66, hidden: true},
               		 { dataIndex: 'DIV_CODE'          , 	width:33, hidden: true},
               		 { dataIndex: 'CUSTOM_NAME'       , 	width:100, hidden: true},
               		 { dataIndex: 'COMPANY_NUM'       , 	width:88, hidden: true},
               		 { dataIndex: 'INSTOCK_Q'         , 	width:66, hidden: true},
               		 { dataIndex: 'SALE_DIV_CODE'     , 	width:66, hidden: true},
               		 { dataIndex: 'SALE_CUSTOM_CODE'  , 	width:66, hidden: true},
               		 { dataIndex: 'BILL_TYPE'         , 	width:66, hidden: true},
               		 { dataIndex: 'SALE_TYPE'         , 	width:66, hidden: true},
               		 { dataIndex: 'UPDATE_DB_USER'    , 	width:66, hidden: true},
               		 { dataIndex: 'UPDATE_DB_TIME'    , 	width:66, hidden: true},
               		 { dataIndex: 'EXCESS_RATE'       , 	width:66, hidden: true},
               		 { dataIndex: 'INSPEC_NUM'        , 	width:66},
               		 { dataIndex: 'INSPEC_SEQ'        , 	width:66},
               		 { dataIndex: 'COMP_CODE'         , 	width:66, hidden: true},
               		 { dataIndex: 'BASIS_NUM'         , 	width:66, hidden: true},
               		 { dataIndex: 'BASIS_SEQ'         , 	width:66, hidden: true},
               		 { dataIndex: 'SCM_FLAG_YN'       , 	width:66, hidden: true}
               		 
        ] 
    });   
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid1, panelResult
			]	
		}		
		,panelSearch
		],
		id  : 'mms502ukrvApp',
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