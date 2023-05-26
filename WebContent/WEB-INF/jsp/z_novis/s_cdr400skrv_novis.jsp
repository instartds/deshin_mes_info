<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_cdr400skrv_novis"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_cdr400skrv_novis" /> 	  <!-- 사업장 -->
</t:appConfig>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript" src="<c:url value='/resources/js/jsbarcode/jquery-barcode.js' />" ></script>
<script type="text/javascript" >
var BsaCodeInfo = {
	gsSiteCode			: '${gsSiteCode}'
};
var gsSelRecord;
var wkordBarcodeWindow;//제조지시 바코드 팝업
function appMain() {

	Unilite.defineModel('s_cdr400skrv_novisModel', {
		fields: [
		    {name: 'ITEM_ACCOUNT'	,text: '계정구분' 	    ,type: 'string', comboType:'AU', comboCode:'B020'},	
            {name: 'BASIC_Q'        ,text: '기초수량'      ,type: 'float'	, decimalPrecision: 3	, format: '0,000.000'},
            {name: 'BASIC_AMOUNT_I' ,text: '기초금액'      ,type: 'float'	, decimalPrecision: 3	, format: '0,000.000'},
            {name: 'INSTOCK_Q'      ,text: '입고수량'      ,type: 'float'	, decimalPrecision: 3	, format: '0,000.000'},
            {name: 'INSTOCK_I'      ,text: '입고금액'      ,type: 'float'	, decimalPrecision: 3	, format: '0,000.000'},
            {name: 'OUTSTOCK_Q'     ,text: '출고수량'      ,type: 'float'	, decimalPrecision: 3	, format: '0,000.000'},
            {name: 'OUTSTOCK_I'     ,text: '출고금액'      ,type: 'float'	, decimalPrecision: 3	, format: '0,000.000'},
            {name: 'STOCK_Q'        ,text: '재고수량'      ,type: 'float'	, decimalPrecision: 3	, format: '0,000.000'},
            {name: 'STOCK_I'        ,text: '재고금액'      ,type: 'float'	, decimalPrecision: 3	, format: '0,000.000'}  
		]
	});
	
	Unilite.defineModel('s_cdr400skrv_novisModel2', {
		fields: [
		    {name: 'ITEM_ACCOUNT'	,text: '품목계정' 	    ,type: 'string', comboType:'AU', comboCode:'B020'},			
            {name: 'ITEM_CODE'      ,text: '품목코드'      ,type: 'string'},
            {name: 'ITEM_NAME'      ,text: '품목명'       ,type: 'string'},
            {name: 'ITEM_SPEC'      ,text: '규격'        ,type: 'string'},
            {name: 'ITEM_UNIT'      ,text: '재고단위'      ,type: 'string'},
            {name: 'BASIC_Q'        ,text: '기초수량'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'BASIC_AMOUNT_I' ,text: '기초금액'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'INSTOCK_Q'      ,text: '입고수량'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'INSTOCK_I'      ,text: '입고금액'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'OUTSTOCK_Q'     ,text: '출고수량'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'OUTSTOCK_I'     ,text: '출고금액'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'STOCK_Q'        ,text: '재고수량'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'},
            {name: 'STOCK_I'        ,text: '재고금액'      ,type: 'float'	, decimalPrecision: 2	, format: '0,000.00'} 
		]
	});	

	var directMasterStore1 = Unilite.createStore('s_cdr400skrv_novisMasterStore1',{
		model: 's_cdr400skrv_novisModel',
		uniOpt: {
			isMaster:  true,		// 상위 버튼 연결
			editable:  false,		// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi:   false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_cdr400skrv_novisService.selectList'
			}
		},
		listeners: {
           	load:function(store, records, successful, eOpts) {
				UniAppManager.setToolbarButtons('save', false);
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	var directMasterStore2 = Unilite.createStore('s_cdr400skrv_novisMasterStore2',{
		model: 's_cdr400skrv_novisModel2',
		uniOpt: {
			isMaster:  false,		// 상위 버튼 연결
			editable:  false,		// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi:   false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_cdr400skrv_novisService.selectList2'
			}
		},
		listeners: {
           	load:function(store, records, successful, eOpts) {
				UniAppManager.setToolbarButtons('save', false);
			}
		},
		loadStoreRecords: function(record) {
			var param= panelSearch.getValues();
			param.ITEM_ACCOUNT =  record.data["ITEM_ACCOUNT"];
			console.log( param );
			this.load({
				params : param 
			});
		}
	});
	

    var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items:[{
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
        		}
			},{
			name: 'COST_YYYYMM',
		 	fieldLabel: '기준월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
		  	allowBlank: false,
		  	maxLength: 200,
      		width:230,
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('COST_YYYYMM', newValue);
				}
    		}      		
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items:[{
    		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
    		name: 'DIV_CODE',
    		value : UserInfo.divCode,
    		xtype: 'uniCombobox',
    		comboType: 'BOR120',
    		allowBlank: false,
    		colspan:1,
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
    		}
		},{
			name: 'COST_YYYYMM',
		 	fieldLabel: '기준월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
		  	allowBlank: false,
		  	maxLength: 200,
      		width:230,
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('COST_YYYYMM', newValue);
				}
    		}
      		
			}]

    });

	var masterGrid = Unilite.createGrid('s_cdr400skrv_novisGrid1', {
    	// for tab
		layout: 'fit',
		region: 'north',
		uniOpt:{
        	expandLastColumn   : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
    		useGroupSummary    : false,
			useRowNumberer     : false,
			onLoadSelectFirst  : true, 
			filter: {
				useFilter: true,
				autoCreate: true
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
		store: directMasterStore1,
		selModel: 'rowmodel',
		listeners: {
   		  selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					directMasterStore2.loadStoreRecords(record);

				}
		  	}
		},		
		columns: [

			{dataIndex: 'ITEM_ACCOUNT'     ,       width: 100, align:'center'},
            {dataIndex: 'BASIC_Q'          ,       width: 100},
            {dataIndex: 'BASIC_AMOUNT_I'   ,       width: 100},
            {dataIndex: 'INSTOCK_Q'        ,       width: 100},
            {dataIndex: 'INSTOCK_I'        ,       width: 100},
            {dataIndex: 'OUTSTOCK_Q'       ,       width: 100},
            {dataIndex: 'OUTSTOCK_I'       ,       width: 100},
            {dataIndex: 'STOCK_Q'          ,       width: 100},
            {dataIndex: 'STOCK_I'          ,       width: 100}
		]
	});
	
	var masterGrid2 = Unilite.createGrid('s_cdr400skrv_novisGrid2', {
    	// for tab
		layout: 'fit',
		region: 'center',
		uniOpt:{
        	expandLastColumn   : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
    		useGroupSummary    : false,
			useRowNumberer     : false,
			onLoadSelectFirst  : false, 
			filter: {
				useFilter: true,
				autoCreate: true
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
		store: directMasterStore2,
		selModel: 'rowmodel',
		columns: [

			{dataIndex: 'ITEM_ACCOUNT'     ,       width: 100, align:'center'},
            {dataIndex: 'ITEM_CODE'        ,       width: 100},
            {dataIndex: 'ITEM_NAME'        ,       width: 250},
            {dataIndex: 'ITEM_SPEC'        ,       width: 80},
            {dataIndex: 'ITEM_UNIT'        ,       width: 80,align:'center'},			
            {dataIndex: 'BASIC_Q'          ,       width: 100},
            {dataIndex: 'BASIC_AMOUNT_I'   ,       width: 100},
            {dataIndex: 'INSTOCK_Q'        ,       width: 100},
            {dataIndex: 'INSTOCK_I'        ,       width: 100},
            {dataIndex: 'OUTSTOCK_Q'       ,       width: 100},
            {dataIndex: 'OUTSTOCK_I'       ,       width: 100},
            {dataIndex: 'STOCK_Q'          ,       width: 100},
            {dataIndex: 'STOCK_I'          ,       width: 100}
		]
	});	

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterGrid, masterGrid2
			]
		},
			panelSearch
		],
		id: 's_cdr400skrv_novisApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','save'], false);

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			panelSearch.setValue('COST_YYYYMM', UniDate.get('startOfMonth'));
			panelResult.setValue('COST_YYYYMM', UniDate.get('startOfMonth'));

		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			masterGrid.getStore().loadStoreRecords();

		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onPrintButtonDown: function () {

        }
	});
};


</script>
