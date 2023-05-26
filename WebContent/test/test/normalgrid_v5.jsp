<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
    request.setAttribute("ext_url", "/extjs5/ext-all-debug_5.1.0.js");
	
	//request.setAttribute("css_url", "/extjs/resources/ext-theme-classic/ext-theme-classic-all-debug.css"); // 4.2.2
    request.setAttribute("css_url", "/extjs5/resources/ext-theme-classic-omega/ext-overrides.css"); // 5.1.0    
    request.setAttribute("ext_root", "extjs5"); // 5.1.0
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Edit Grid Sample</title>

	<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/ux-overrides.css" />' />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite_5.1.0.css" />' />
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script>

    <script type="text/javascript">
    	var CPATH ='<%=request.getContextPath()%>';
        Ext.Loader.setConfig({
		enabled : true,
		scriptCharset : 'UTF-8',
		paths: {
                "Ext": '${CPATH }/${ext_root}/src',
            	"Ext.ux": '${CPATH }/${ext_root}/app/Ext/ux',
            	"Unilite": '${CPATH }/${ext_root}/app/Unilite',
            	"Extensible": '${CPATH }/${ext_root}/app/Extensible'
        }
	});
	Ext.require('*');	
    </script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniUtils.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniTypes.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/Unilite.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniDate.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniAppManager.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniAbstractStore.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniStore.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniModel.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/button/BaseButton.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniBaseField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniClearButton.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniComboBox.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniTextField.js" />' ></script>
	

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniFields.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniDateColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniTimeColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniPriceColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniNumberColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniAbstractGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/excel/Excel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/feature/UniGroupingSummary.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/feature/UniSummary.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/Message-ko.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/unilite-lang-ko.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/locale/ext-lang-ko.js" />' ></script>

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js" />'></script>
	
    <script type="text/javascript">
        

		
		Ext.require([
		    'Ext.data.*',
		    'Ext.tip.QuickTipManager',
		    'Ext.window.MessageBox'
		]);
		Ext.define("UniFormat", {
	    		singleton: true,
			 	Qty: 			'0,000', //						// 수량
			    UnitPrice: 		'0,000.00',		// "${loginVO.userID}",		// 단가
			    Price: 			'0,000',		// "${loginVO.userName}",		// 금액
			    FC: 			'0,000.00',  	// "${loginVO.personNumb}",	// 외화
			    ER: 			'0,000.00',  	//  ${loginVO.personNumb}",	// 환율
			    Percent: 		'0,000.00',		// "${loginVO.userID}",		// 확률
	 			FDATE:			'Y-m-d', 		//  "${loginVO.fDate}",			// 날자
			    FYM: 			'Y-m' //"${loginVO.fYM}"			// 연월
			 }
		);
        Ext.onReady(function(){
        	Ext.tip.QuickTipManager.init();
        	Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
        	
        	var cbStore = Ext.create('Ext.data.Store',{"comboType":"BOR120","comboCode":"","storeId":"CBS_BOR120_","fields":["value","text","option","search","refCode1","refCode2","refCode3","refCode4","refCode5","refCode6","refCode7","refCode8","refCode9","refCode10"],"data":[{"value":"01","text":"서울 캠퍼스","option":null,"search":"01서울 캠퍼스"},{"value":"02","text":"원주 캠퍼스","option":null,"search":"02원주 캠퍼스"}]});
        	
        	Unilite.defineModel('Sof100skrvModel', {
			    fields: [
					{name: 'DVRY_DATE1'				,text:'납기일'		,type:'uniDate',convert:dateToString},
					{name: 'DVRY_TIME1'				,text:'납기시간'		,type:'string'},
					{name: 'ITEM_CODE'		 		,text:'품목코드' 		,type:'string'},
					{name: 'ITEM_NAME'		 		,text:'품목명' 		,type:'string'},
					{name: 'CUSTOM_CODE1'		 	,text:'거래처코드'		,type:'string'},
					{name: 'CUSTOM_NAME1'		 	,text:'거래처명' 		,type:'string'},
					{name: 'SPEC'			 		,text:'규격' 			,type:'string'},
					{name: 'ORDER_UNIT'		 		,text:'단위' 			,type:'string'},
					{name: 'PRICE_TYPE'		 		,text:'단가구분' 		,type:'string'},
					{name: 'TRANS_RATE'		 		,text:'입수' 			,type:'string'},
					{name: 'ORDER_UNIT_Q'	 		,text:'수주량' 		,type:'uniQty'},
					{name: 'ORDER_WGT_Q'	 		,text:'수주량(중량)' 	,type:'uniQty'},
					{name: 'ORDER_VOL_Q'	 		,text:'수주량(부피)' 	,type:'uniQty'},
					{name: 'STOCK_UNIT'		 		,text:'재고단위' 		,type:'string'},
					{name: 'STOCK_Q'		 		,text:'재고단위수주량' 	,type:'uniQty'},
					{name: 'MONEY_UNIT'		 		,text:'화폐' 			,type:'string'},
					{name: 'ORDER_P'		 		,text:'단가' 			,type:'uniPrice'},
					{name: 'ORDER_WGT_P'	 		,text:'단가(중량)' 	,type:'uniPrice'},
					{name: 'ORDER_VOL_P'	 		,text:'단가(부피)' 	,type:'uniPrice'},
					{name: 'ORDER_O'		 		,text:'수주액' 		,type:'uniPrice'},
					{name: 'EXCHG_RATE_O'	 		,text:'환율' 			,type:'uniER'},
					{name: 'SO_AMT_WON'		 		,text:'환산액' 		,type:'uniPrice'},
					{name: 'TAX_TYPE'		 		,text:'과세여부' 		,type:'string', comboType:'AU', comboCode:'B050'},
					{name: 'ORDER_TAX_O'	 		,text:'세액' 			,type:'uniPrice'},
					{name: 'WGT_UNIT'		 		,text:'중량단위' 		,type:'string'},
					{name: 'UNIT_WGT'		 		,text:'단위중량' 		,type:'string'},
					{name: 'VOL_UNIT'		 		,text:'부피단위' 		,type:'string'},
					{name: 'UNIT_VOL'		 		,text:'단위부피' 		,type:'string'},
					{name: 'CUSTOM_CODE2'	 		,text:'거래처코드' 	,type:'string'},
					{name: 'CUSTOM_NAME2'	 		,text:'거래처명' 		,type:'string'},
					{name: 'ORDER_DATE'		 		,text:'수주일' 		,type:'uniDate',convert:dateToString},
					{name: 'ORDER_TYPE'		 		,text:'판매유형' 		,type:'string',comboType:"AU", comboCode:"S002"},
					{name: 'ORDER_TYPE_NM'	 		,text:'판매유형' 		,type:'string'},
					{name: 'ORDER_NUM'		 		,text:'수주번호' 		,type:'string'},
					{name: 'SER_NO'			 		,text:'순번' 			,type:'integer'},
					{name: 'ORDER_PRSN'		 		,text:'영업담당' 		,type:'string',comboType:"AU", comboCode:"S010"},
					{name: 'ORDER_PRSN_NM'	 		,text:'영업담당' 		,type:'string'},
					{name: 'PO_NUM'			 		,text:'P/O NO' 		,type:'string'},
					{name: 'DVRY_DATE2'		 		,text:'납기일' 		,type:'uniDate',convert:dateToString},
					{name: 'DVRY_TIME'		 		,text:'납기시간' 		,type:'uniTime'},
					{name: 'DVRY_CUST_NM'	 		,text:'배송처' 		,type:'string'},
					{name: 'PROD_END_DATE'	 		,text:'생산완료요청일' 	,type:'uniDate',convert:dateToString},
					{name: 'PROD_Q'			 		,text:'생산요청량' 	,type:'uniQty'},
					{name: 'ORDER_STATUS'	 		,text:'마감' 			,type:'string',comboType:"AU", comboCode:"S011"},
					{name: 'REMARK'					,text:'비고'			,type:'string'},
					{name: 'SORT_KEY'		 		,text:'SORTKEY' 	,type:'string'},
					{name: 'CREATE_LOC'		 		,text:'CREATE_LOC' 	,type:'string'}
				]
			});
			function dateToString(v, record){
				return UniDate.safeFormat(v);
			}
			
//        	var store1 = Ext.create('Ext.data.JsonStore', {
//	            model: 'Writer.Person',
//	            data: [
//					{id: 1, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
//					{id: 2, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
//					{id: 3, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
//					{id: 4, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
//					{id: 5, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' }
//	            ]
//	        });  	
//			var store1 = Ext.create('Ext.data.JsonStore', {
//	            model: 'bpr100ukrvModel',
//	            data: [
//					{ITEM_CODE: 'A0-A00-#000000', ITEM_NAME:'소둔선(임가공', ITEM_NAME1:'', ITEM_NAME2:'', SPEC:'R/L', STOCK_UNIT:'EA', ITEM_SIZE:''},
//					{ITEM_CODE: 'A0-A00-#000000', ITEM_NAME:'소둔선(임가공', ITEM_NAME1:'', ITEM_NAME2:'', SPEC:'R/L', STOCK_UNIT:'EA', ITEM_SIZE:''},
//					{ITEM_CODE: 'A0-A00-#000000', ITEM_NAME:'소둔선(임가공', ITEM_NAME1:'', ITEM_NAME2:'', SPEC:'R/L', STOCK_UNIT:'EA', ITEM_SIZE:''},
//					{ITEM_CODE: 'A0-A00-#000000', ITEM_NAME:'소둔선(임가공', ITEM_NAME1:'', ITEM_NAME2:'', SPEC:'R/L', STOCK_UNIT:'EA', ITEM_SIZE:''},
//					{ITEM_CODE: 'A0-A00-#000000', ITEM_NAME:'소둔선(임가공', ITEM_NAME1:'', ITEM_NAME2:'', SPEC:'R/L', STOCK_UNIT:'EA', ITEM_SIZE:''},
//					{ITEM_CODE: 'A0-A00-#000000', ITEM_NAME:'소둔선(임가공', ITEM_NAME1:'', ITEM_NAME2:'', SPEC:'R/L', STOCK_UNIT:'EA', ITEM_SIZE:''}
//	            ]
//	        });  	
			var directMasterStore1 = Unilite.createStore('sof100skrvMasterStore1', {
				model: 'Sof100skrvModel',
				uniOpt: {
		           	isMaster: true,			// 상위 버튼,상태바 연결 
		           	editable: false,		// 수정 모드 사용 
		           	deletable:false,		// 삭제 가능 여부 
		            useNavi: false			// prev | newxt 버튼 사용
				},
		        autoLoad: true,
		        proxy: {
		        	type: 'direct',
		            api: {			
		            	read: 'sof100skrvService.selectList1'                	
				    }
				},
				loadStoreRecords: function() {
					//var param= Ext.getCmp('searchForm').getValues();			
					var params = {
						ORDER_DATE_FR: '20130901',
						ORDER_DATE_TO: '20131231',
						DIV_CODE: '01'
					};
					console.log( param );
					this.load({
						params: param
					});
				},
				groupField: 'ITEM_NAME'
			});
	        
	        var masterGrid = Unilite.createGrid('bpr100ukrvGrid', {
	        //var masterGrid = Ext.create('Unilite.com.grid.UniGridPanel', {	
			//var masterGrid = Ext.create('Ext.grid.Panel', {
		    	//region:'center',
	        	//id: 'bpr100ukrvGrid',
		    	store : directMasterStore1,
		    	sortableColumns : false,
		    	//selType: 'cellmodel',
		    	flex: 1,
		    	//split: false,
//		    	requires: [
//			        'Ext.grid.plugin.CellEditing',
//			        'Ext.form.field.Text',
//			        'Ext.toolbar.TextItem'
//			    ],
//		    	plugins: [Ext.create('Ext.grid.plugin.CellEditing'), Ext.create('Ext.grid.plugin.BufferedRenderer')],
//		        plugins: {
//			        ptype: 'bufferedrenderer',
//			        trailingBufferZone: 20,  // Keep 20 rows rendered in the table behind scroll
//			        leadingBufferZone: 20   // 결과셋의 수에 따라 늘려야 신규입력 시 포커스 문제가 안생김
//			    },		    	
				features: [ //{id : 'masterGridSubTotal', ftype: 'groupingsummary', showSummaryRow: true }
        			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true}
    	           	],
    	        uniOpt: {
					expandLastColumn: false,
					useMultipleSorting: true,
		    		useGroupSummary: false,
		    		useLiveSearch: true,
					useContextMenu: true,
		    		filter: {
						useFilter: true,
						autoCreate: true
					}
		        },   			    	
		        columns: [        
					{dataIndex: 'ITEM_CODE'		 		, width: 133, locked: true}, 				
					{dataIndex: 'ITEM_NAME'		 		, width: 166, locked: true}, 				
					{dataIndex: 'SPEC'			 		, width: 133, locked: true}, 				
					{dataIndex: 'ORDER_UNIT'		 	, width: 53, locked: true, align: 'center'}, 				
					{dataIndex: 'PRICE_TYPE'		 	, width: 80, hidden: true}, 				
					{dataIndex: 'TRANS_RATE'		 	, width: 106, align: 'right',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
		            }
		            }, 				
					{dataIndex: 'ORDER_UNIT_Q'	 		, width: 106, summaryType: 'sum'}, 				
					{dataIndex: 'ORDER_WGT_Q'	 		, width: 106, hidden: true},		
					{dataIndex: 'ORDER_VOL_Q'	 		, width: 106, hidden: true},				
					{dataIndex: 'STOCK_UNIT'		 	, width: 53, hidden: true}, 				
					{dataIndex: 'STOCK_Q'		 		, width: 106,hidden: true}, 				
					{dataIndex: 'MONEY_UNIT'		 	, width: 53}, 				
					{dataIndex: 'ORDER_P'		 		, width: 106}, 				
					{dataIndex: 'ORDER_WGT_P'	 		, width: 106, hidden: true}, 				
					{dataIndex: 'ORDER_VOL_P'	 		, width: 106, hidden: true},				
					{dataIndex: 'ORDER_O'		 		, width: 120, summaryType: 'sum'}, 				
					{dataIndex: 'EXCHG_RATE_O'	 		, width: 66, align: 'right'}, 				
					{dataIndex: 'SO_AMT_WON'		 	, width: 120, summaryType: 'sum'}, 				
					{dataIndex: 'TAX_TYPE'		 		, width: 100}, 				
					{dataIndex: 'ORDER_TAX_O'	 		, width: 125, summaryType: 'sum'}, 				
					{dataIndex: 'WGT_UNIT'		 		, width: 66, hidden: true}, 				
					{dataIndex: 'UNIT_WGT'		 		, width: 80, hidden: true}, 				
					{dataIndex: 'VOL_UNIT'		 		, width: 66, hidden: true}, 				
					{dataIndex: 'UNIT_VOL'		 		, width: 80, hidden: true}, 				
					{dataIndex: 'CUSTOM_CODE2'	 		, width: 100}, 				
					{dataIndex: 'CUSTOM_NAME2'	 		, width: 133}, 				
					{dataIndex: 'ORDER_DATE'		 	, width: 93}, 				
					{dataIndex: 'ORDER_TYPE'		 	, width: 133}, 				
					{dataIndex: 'ORDER_TYPE_NM'	 		, width: 133, hidden: true}, 				
					{dataIndex: 'ORDER_NUM'		 		, width: 100}, 				
					{dataIndex: 'SER_NO'			 	, width: 53, align:'center'}, 				
					{dataIndex: 'ORDER_PRSN'		 	, width: 66}, 				
					{dataIndex: 'ORDER_PRSN_NM'	 		, width:133, hidden: true}, 				
					{dataIndex: 'PO_NUM'			 	, width:86}, 				
					{dataIndex: 'DVRY_DATE2'		 	, width:93}, 				
					{dataIndex: 'DVRY_TIME'		 		, width:66, hidden: true}, 				
					{dataIndex: 'DVRY_CUST_NM'	 		, width:100}, 				
					{dataIndex: 'PROD_END_DATE'	 		, width:106}, 				
					{dataIndex: 'PROD_Q'			 	, width:90, summaryType: 'sum'}, 				
					{dataIndex: 'ORDER_STATUS'	 		, width:90},				
					{dataIndex: 'SORT_KEY'		 		, width:106, hidden: true}, 				
					{dataIndex: 'CREATE_LOC'		 	, width:106, hidden: true},
					{dataIndex: 'REMARK'				, width:200}
				]
		    });
		
		    var main = Ext.create('Ext.container.Container', {
		        padding: '0 0 0 20',
		        width: 1000,
		        height: Ext.themeName === 'neptune' ? 500 : 450,
		        renderTo: document.body,
		        layout: {
		            type: 'vbox',
		            align: 'stretch'
		        },
		        items: [
		        	masterGrid,
		        	{xtype: 'panel',
		        	 title:'xml',
		        	 id: 'excelxml'}
		        ]
		    });
        });
    </script>
    <!-- </x-compile> -->
</head>
<body>
</body>
</html>
