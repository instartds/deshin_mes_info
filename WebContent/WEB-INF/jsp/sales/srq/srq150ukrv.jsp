<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="srq150ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="srq150ukrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--수주구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S085" /> <!--picking상태 -->
	<t:ExtComboStore comboType="AU" comboCode="S063" /> <!--주문유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S065" /> <!--주문구분 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
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
	Unilite.defineModel('srq150ukrvModel', {
	    fields: [  	 
	    	 {name: 'COMP_CODE'        		,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>' 				,type: 'string'},
    		 {name: 'DIV_CODE'         		,text: '<t:message code="system.label.sales.division" default="사업장"/>' 				,type: 'string'},
    		 {name: 'ISSUE_REQ_METH'   		,text: '<t:message code="system.label.sales.shipmentordermethod" default="출하지시방법"/>' 			,type: 'string'},
    		 {name: 'ISSUE_REQ_PRSN'   		,text: '<t:message code="system.label.sales.shipmentordercharger" default="출하지시담당자"/>' 		,type: 'string'},
    		 {name: 'ISSUE_REQ_DATE'   		,text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>' 			,type: 'uniDate'},
    		 {name: 'ISSUE_REQ_NUM'    		,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>' 			,type: 'string'},
    		 {name: 'ISSUE_REQ_SEQ'    		,text: '<t:message code="system.label.sales.seq" default="순번"/>' 					,type: 'string'},
    		 {name: 'PICK_CLASS'       		,text: 'Picking분류' 			,type: 'string'},
    		 {name: 'CUSTOM_CODE'      		,text: '<t:message code="system.label.sales.client" default="고객"/>' 				,type: 'string'},
    		 {name: 'CUSTOM_NAME'      		,text: '<t:message code="system.label.sales.client" default="고객"/>' 					,type: 'string'},
    		 {name: 'ITEM_CODE'        		,text: '<t:message code="system.label.sales.item" default="품목"/>' 				,type: 'string'},
    		 {name: 'ITEM_NAME'        		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>' 				,type: 'string'},
    		 {name: 'SPEC'             		,text: '<t:message code="system.label.sales.spec" default="규격"/>'					,type: 'string'},
    		 {name: 'STOCK_UNIT'       		,text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>' 				,type: 'string', displayField: 'value'},
    		 {name: 'ITEM_SUM_Q'       		,text: '품목 Picking 수량' 		,type: 'string'},
    		 {name: 'WH_CODE'          		,text: '<t:message code="system.label.sales.warehouse" default="창고"/>' 					,type: 'string'},
    		 {name: 'WH_NAME'          		,text: '<t:message code="system.label.sales.warehouse" default="창고"/>' 					,type: 'string'},
    		 {name: 'WH_CELL_CODE'     		,text: '창고 Cell' 				,type: 'string'},
    		 {name: 'WH_CELL_NAME'     		,text: '창고 Cell' 				,type: 'string'},
    		 {name: 'LOT_NO'           		,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>' 				,type: 'string'},
    		 {name: 'STOCK_Q'          		,text: '판매단위재고수량' 		,type: 'string'},
    		 {name: 'CELL_STOCK_Q'     		,text: 'Cell 재고수량' 			,type: 'string'},
    		 {name: 'ISSUE_REQ_QTY'    		,text: 'Picking 수량' 			,type: 'string'},
    		 {name: 'ISSUE_REQ_PRICE'  		,text: '<t:message code="system.label.sales.price" default="단가"/>'					,type: 'string'},
    		 {name: 'ISSUE_REQ_AMT'    		,text: '<t:message code="system.label.sales.amount" default="금액"/>' 					,type: 'string'},
    		 {name: 'TAX_TYPE'         		,text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>' 				,type: 'string'},
    		 {name: 'ISSUE_REQ_TAX_AMT'		,text: '<t:message code="system.label.sales.taxamount" default="세액"/>' 					,type: 'string'},
    		 {name: 'ISSUE_DATE'       		,text: '출고예정일' 			,type: 'uniDate'},
    		 {name: 'DELIVERY_TIME'    		,text: '출고예정시간'			,type: 'uniTime'},
    		 {name: 'DISCOUNT_RATE'    		,text: '할인율' 				,type: 'string'},
    		 {name: 'PRICE_YN'         		,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>' 				,type: 'string'},
    		
    		 {name: 'NOTOUT_Q'         		,text: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>' 				,type: 'uniQty'},
    		 {name: 'ORDER_Q'          		,text: '주문량' 				,type: 'uniQty'},
    		 {name: 'ISSUE_REQ_Q'      		,text: '수주출하지시량' 		,type: 'uniQty'},
    		 {name: 'ISSUE_QTY'        		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>' 				,type: 'uniQty'},
    		 {name: 'RETURN_Q'         		,text: '<t:message code="system.label.sales.returnqty" default="반품량"/>' 				,type: 'uniQty'},
    		 {name: 'DVRY_DATE'        		,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>' 				,type: 'uniDate'},
    		 {name: 'DVRY_TIME'        		,text: '<t:message code="system.label.sales.deliverytime" default="납기시간"/>' 				,type: 'uniTime'},
    		 {name: 'ORDER_UNIT'       		,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>' 				,type: 'string', displayField: 'value'},
    		 {name: 'TRANS_RATE'       		,text: '<t:message code="system.label.sales.containedqty" default="입수"/>' 					,type: 'string'},
    		 {name: 'BILL_TYPE'        		,text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>' 			,type: 'string'},
    		 {name: 'ORDER_TYPE'       		,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>' 				,type: 'string'},
    		 {name: 'INOUT_TYPE_DETAIL'		,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>' 				,type: 'string'},
    		 {name: 'ORDER_PRSN'       		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>' 				,type: 'string'},
    		 {name: 'ORDER_NUM'        		,text: '<t:message code="system.label.sales.sono" default="수주번호"/>' 				,type: 'string'},
    		 {name: 'SER_NO'           		,text: '<t:message code="system.label.sales.seq" default="순번"/>' 					,type: 'string'},
    		 {name: 'PO_NUM'           		,text: 'P/O번호' 				,type: 'string'},
    		 {name: 'PO_SEQ'           		,text: 'P/O순번' 				,type: 'string'},
    		 {name: 'ISSUE_DIV_CODE'   		,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>' 			,type: 'string'},
    		 {name: 'SALE_CUSTOM_CODE' 		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>' 			,type: 'string'},
    		 {name: 'SALE_CUSTOM_NAME' 		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>' 				,type: 'string'},
    		 {name: 'ACCOUNT_YNC'      		,text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>' 				,type: 'string'},
    		 {name: 'PROJECT_NO'       		,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>' 			,type: 'string'},
    		 {name: 'REMARK'           		,text: '<t:message code="system.label.sales.remarks" default="비고"/>' 					,type: 'string'},
    		 {name: 'AGENT_TYPE'       		,text: '<t:message code="system.label.sales.clienttype" default="고객분류"/>' 				,type: 'string'},
    		 
    		 {name: 'SO_TYPE'          		,text: '주문유형' 				,type: 'string'},
    		 {name: 'SO_KIND'          		,text: '<t:message code="system.label.sales.ordertype" default="주문구분"/>' 				,type: 'string'},
    		 {name: 'CUSTOMER_ID'      		,text: '주문자코드' 			,type: 'string'},
    		 {name: 'CUSTOMER_NAME'    		,text: '주문자' 				,type: 'string'},
    		 {name: 'RECEIVER_ID'      		,text: '<t:message code="system.label.sales.receiverid" default="수신자ID"/>' 			,type: 'string'},
    		 {name: 'RECEIVER_NAME'    		,text: '<t:message code="system.label.sales.receivername" default="수신자명"/>' 				,type: 'string'},
    		 {name: 'TELEPHONE_NUM1'   		,text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>' 				,type: 'string'},
    		 {name: 'TELEPHONE_NUM2'   		,text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>' 				,type: 'string'},
    		 {name: 'ADDRESS'          		,text: '<t:message code="system.label.sales.address" default="주소"/>' 					,type: 'string'},
    		 {name: 'DVRY_CUST_CD'     		,text: '<t:message code="system.label.sales.deliveryplacecode" default="배송처코드"/>' 			,type: 'string'},
    		 {name: 'DVRY_CUST_NM'     		,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>' 				,type: 'string'},
    		 {name: 'PICK_BOX_QTY'     		,text: 'Picking Box수량' 		,type: 'string'},
    		 {name: 'PICK_EA_QTY'      		,text: 'Picking EA수량' 		,type: 'string'},
    		 {name: 'PICK_STATUS'      		,text: 'Picking 상태' 			,type: 'string'},

    		 {name: 'DEPT_CODE'        		,text: '<t:message code="system.label.sales.department" default="부서"/>' 				,type: 'string'},
    		 {name: 'TREE_NAME'        		,text: '<t:message code="system.label.sales.departmentname" default="부서명"/>' 				,type: 'string'},
    		 {name: 'MONEY_UNIT'       		,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>' 				,type: 'string',displayField: 'value'},
    		 {name: 'EXCHANGE_RATE'    		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>' 					,type: 'uniER'},
    		 {name: 'TAX_INOUT'        		,text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>' 			,type: 'string'},
    		 {name: 'PRE_ACCNT_YN'     		,text: '<t:message code="system.label.sales.salessubjectyn" default="매출대상여부"/>' 			,type: 'string'},
    		 {name: 'REF_FLAG'         		,text: '참조여부' 				,type: 'string'},
    		 {name: 'SALE_P'           		,text: '<t:message code="system.label.sales.sellingprice" default="판매단가"/>' 				,type: 'string'},
    		 {name: 'AMEND_YN'         		,text: '수정여부' 				,type: 'string'},
    		 {name: 'OUTSTOCK_Q'       		,text: '수주출고량' 			,type: 'uniQty'},
    		 {name: 'ORDER_CUST_NM'    		,text: '<t:message code="system.label.sales.salesorder" default="수주"/><t:message code="system.label.sales.client" default="고객"/>' 				,type: 'string'},
    		 {name: 'STOCK_CARE_YN'    		,text: '재고대상여부' 			,type: 'string'},
    		 {name: 'SORT_KEY'         		,text: '정렬KEY' 				,type: 'string'},
    		 {name: 'REF_AGENT_TYPE'   		,text: '<t:message code="system.label.sales.clienttype" default="고객분류"/>' 				,type: 'string'},
    		 {name: 'REF_WON_CALC_TYPE'		,text: '원미만계산' 			,type: 'string'},
    		 {name: 'REF_CODE2'        		,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>' 				,type: 'string'},
    		
    		 {name: 'SCM_FLAG_YN'      		,text: '타시스템연계여부' 		,type: 'string'},
    		 {name: 'UPDATE_DB_USER'   		,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>' 				,type: 'string'},
    		 {name: 'UPDATE_DB_TIME'   		,text: '<t:message code="system.label.sales.updatedate" default="수정일"/>' 				,type: 'uniDate'}
		]
	});		//End of Unilite.defineModel('srq150ukrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('srq150ukrvMasterStore1',{
			model: 'srq150ukrvModel',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'srq150ukrvService.selectList1'                	
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
	});		// End of var directMasterStore1 = Unilite.createStore('srq150ukrvMasterStore1',{
	
	
	var now = new Date();
	var month = now.getMonth()+1
	var day = now.getDate(); 
		month = month < 10? '0' + month : month
		day = day < 10? '0' + day : day 
	var today = now.getFullYear() + '/' + month + '/' + day;

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        			name: 'DIV_CODE',
        			xtype: 'uniCombobox',
        			comboType: 'BOR120',
        			allowBlank: false
        		}, {
					fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
					name: '',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'S010'
				}, {
        			fieldLabel: 'Packing 지시일',
	                xtype: 'uniDatefield',
					name:''
				}, {
					fieldLabel: 'Picking 번호',
					name: '',
					xtype: 'uniTextfield'
				},{
					fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>'	,
					name: '',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: ''
		    }]
        }]
	});    		//End of var panelSearch = Unilite.createSearchForm('searchForm',{   
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('srq150ukrvGrid1', {
        layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'<t:message code="system.label.sales.detailsview" default="상세보기"/>',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	
    	store: directMasterStore1,
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        columns: [	
			{ dataIndex: 'COMP_CODE'             ,   width: 80  , hidden: true},
			{ dataIndex: 'DIV_CODE'              ,   width: 100 , hidden: true}, 				
			{ dataIndex: 'ISSUE_REQ_METH'        ,   width: 53  , hidden: true},
			{ dataIndex: 'ISSUE_REQ_PRSN'        ,   width: 100 , hidden: true}, 				
			{ dataIndex: 'ISSUE_REQ_DATE'        ,   width: 53  , hidden: true},
			{ dataIndex: 'ISSUE_REQ_NUM'         ,   width: 80  , hidden: true}, 				
			{ dataIndex: 'ISSUE_REQ_SEQ'         ,   width: 66  , hidden: true},
			{ dataIndex: 'CUSTOM_CODE'           ,   width: 66  , hidden: true},
        	{text:'Picking List' , locked: true ,
        		columns: [
	
					{ dataIndex: 'PICK_CLASS'            ,   width: 106 }, 								
					{ dataIndex: 'CUSTOM_NAME'           ,   width: 133 }, 				
					{ dataIndex: 'ITEM_CODE'             ,   width: 133 }
				]},
			{text:'Picking List' , 
        		columns: [	
					{ dataIndex: 'ITEM_NAME'             ,   width: 80  },
					{ dataIndex: 'SPEC'                  ,   width: 100 }, 				
					{ dataIndex: 'STOCK_UNIT'            ,   width: 53  , hidden: true},
					{ dataIndex: 'ITEM_SUM_Q'            ,   width: 115 }, 				
					{ dataIndex: 'WH_CODE'               ,   width: 53  , hidden: true},
					{ dataIndex: 'WH_NAME'               ,   width: 80  }, 				
					{ dataIndex: 'WH_CELL_CODE'          ,   width: 66  , hidden: true},
					{ dataIndex: 'WH_CELL_NAME'          ,   width: 106 , hidden: true}, 				
					{ dataIndex: 'LOT_NO'                ,   width: 66  , hidden: true},
					{ dataIndex: 'STOCK_Q'               ,   width: 133 }, 				
					{ dataIndex: 'CELL_STOCK_Q'          ,   width: 133 , hidden: true},
					{ dataIndex: 'ISSUE_REQ_QTY'         ,   width: 95  },
					{ dataIndex: 'ISSUE_REQ_PRICE'       ,   width: 100 , hidden: true}, 				
					{ dataIndex: 'ISSUE_REQ_AMT'         ,   width: 53  },
					{ dataIndex: 'TAX_TYPE'              ,   width: 100 }, 				
					{ dataIndex: 'ISSUE_REQ_TAX_AMT'     ,   width: 53  }
				]},	
					
			{ dataIndex: 'ISSUE_DATE'            ,   width: 80  , hidden: true}, 				
			{ dataIndex: 'DELIVERY_TIME'         ,   width: 66  , hidden: true},
			{ dataIndex: 'DISCOUNT_RATE'         ,   width: 106 , hidden: true}, 				
			{ dataIndex: 'PRICE_YN'              ,   width: 66  , hidden: true},
			{text:'수주정보' , 
        		columns: [			
					{ dataIndex: 'NOTOUT_Q'              ,   width: 133 },
					{ dataIndex: 'ORDER_Q'               ,   width: 80  },
					{ dataIndex: 'ISSUE_REQ_Q'           ,   width: 100 , hidden: true}, 				
					{ dataIndex: 'ISSUE_QTY'             ,   width: 53  },
					{ dataIndex: 'RETURN_Q'              ,   width: 100 , hidden: true}, 				
					{ dataIndex: 'DVRY_DATE'             ,   width: 53  },
					{ dataIndex: 'DVRY_TIME'             ,   width: 80  }, 				
					{ dataIndex: 'ORDER_UNIT'            ,   width: 66  },
					{ dataIndex: 'TRANS_RATE'            ,   width: 106 }, 				
					{ dataIndex: 'BILL_TYPE'             ,   width: 66  , hidden: true},
					{ dataIndex: 'ORDER_TYPE'            ,   width: 133 }, 				
					{ dataIndex: 'INOUT_TYPE_DETAIL'     ,   width: 133 , hidden: true},
					{ dataIndex: 'ORDER_PRSN'            ,   width: 80  },
					{ dataIndex: 'ORDER_NUM'             ,   width: 100 }, 				
					{ dataIndex: 'SER_NO'                ,   width: 53  },
					{ dataIndex: 'PO_NUM'                ,   width: 100 , hidden: true}, 				
					{ dataIndex: 'PO_SEQ'                ,   width: 53  , hidden: true},
					{ dataIndex: 'ISSUE_DIV_CODE'        ,   width: 80  }, 				
					{ dataIndex: 'SALE_CUSTOM_CODE'      ,   width: 66  , hidden: true},
					{ dataIndex: 'SALE_CUSTOM_NAME'      ,   width: 106 }, 				
					{ dataIndex: 'ACCOUNT_YNC'           ,   width: 66  , hidden: true},
					{ dataIndex: 'PROJECT_NO'            ,   width: 133 }, 				
					{ dataIndex: 'REMARK'                ,   width: 133 }
				]},		
			{text:'주문정보' , 
        		columns: [		
					{ dataIndex: 'AGENT_TYPE'            ,   width: 80  ,hidden: true},
					{ dataIndex: 'SO_TYPE'               ,   width: 66  },
					{ dataIndex: 'SO_KIND'               ,   width: 100 }, 				
					{ dataIndex: 'CUSTOMER_ID'           ,   width: 53  , hidden: true},
					{ dataIndex: 'CUSTOMER_NAME'         ,   width: 80  }, 				
					{ dataIndex: 'RECEIVER_ID'           ,   width: 66  , hidden: true},
					{ dataIndex: 'RECEIVER_NAME'         ,   width: 106 }, 				
					{ dataIndex: 'TELEPHONE_NUM1'        ,   width: 66  },
					{ dataIndex: 'TELEPHONE_NUM2'        ,   width: 133 , hidden: true}, 				
					{ dataIndex: 'ADDRESS'               ,   width: 133 },
					{ dataIndex: 'DVRY_CUST_CD'          ,   width: 80  , hidden: true},
					{ dataIndex: 'DVRY_CUST_NM'          ,   width: 100 , hidden: true}, 				
					{ dataIndex: 'PICK_BOX_QTY'          ,   width: 53  , hidden: true},
					{ dataIndex: 'PICK_EA_QTY'           ,   width: 100 , hidden: true}, 				
					{ dataIndex: 'PICK_STATUS'           ,   width: 53  , hidden: true}
				]},	
			{ dataIndex: 'DEPT_CODE'             ,   width: 66  , hidden: true},
			{ dataIndex: 'TREE_NAME'             ,   width: 106 , hidden: true}, 				
			{ dataIndex: 'MONEY_UNIT'            ,   width: 66  , hidden: true},
			{ dataIndex: 'EXCHANGE_RATE'         ,   width: 133 , hidden: true}, 				
			{ dataIndex: 'TAX_INOUT'             ,   width: 133 , hidden: true},
			{ dataIndex: 'PRE_ACCNT_YN'          ,   width: 80  , hidden: true},
			{ dataIndex: 'REF_FLAG'              ,   width: 100 , hidden: true}, 				
			{ dataIndex: 'SALE_P'                ,   width: 53  , hidden: true},
			{ dataIndex: 'AMEND_YN'              ,   width: 100 , hidden: true}, 				
			{ dataIndex: 'OUTSTOCK_Q'            ,   width: 53  , hidden: true},
			{ dataIndex: 'ORDER_CUST_NM'         ,   width: 80  , hidden: true}, 				
			{ dataIndex: 'STOCK_CARE_YN'         ,   width: 66  , hidden: true},
			{ dataIndex: 'SORT_KEY'              ,   width: 106 , hidden: true}, 				
			{ dataIndex: 'REF_AGENT_TYPE'        ,   width: 66  , hidden: true},
			{ dataIndex: 'REF_WON_CALC_TYPE'     ,   width: 133 , hidden: true}, 				
			{ dataIndex: 'REF_CODE2'             ,   width: 133 , hidden: true},
		
			{ dataIndex: 'SCM_FLAG_YN'           ,   width: 100 , hidden: true}, 				
			{ dataIndex: 'UPDATE_DB_USER'        ,   width: 53  , hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'        ,   width: 100 , hidden: true}
					
		
		] 
    });		// End of var masterGrid1 = Unilite.createGrid('srq150ukrvGrid1', {

    Unilite.Main({
		border: false,
		borderItems:[ 
		 		 masterGrid1
				,panelSearch
		], 
		id : 'srq150ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'srq150ukrvGrid1'){				
				directMasterStore1.loadStoreRecords();				
			}
			var viewLocked = tab.getActiveTab().lockedGrid.getView();
			var viewNormal = tab.getActiveTab().normalGrid.getView();
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
	});		// End of Unilite.Main({
};
</script>
