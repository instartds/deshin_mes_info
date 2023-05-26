<%@page language="java" contentType="text/html; charset=utf-8"%>
//openotherRefSearchWindow begin
	Ext.apply(masterGrid,{
	          setExcelRefData: function(record) {

	          	var grdRecord = this.getSelectedRecord();
	          	panelResult.setValues({
	          		'AMT_UNIT':record['MONEY_UNIT'],
	          		'EXCHANGE_RATE':record['EXCHG_RATE_O'],
	          		'PAY_METHODE':record['PAY_METHODE']

	          	});
	          	gNationInout = record['NATION_INOUT'];
	          	grdRecord.set('SO_SER_NO', panelResult.getValue('SO_SER_NO'));
	          	grdRecord.set('ITEM_CODE', record['ITEM_CODE']);
	          	grdRecord.set('ITEM_NAME', record['ITEM_NAME']);
	          	grdRecord.set('SPEC',record['SPEC']);
	          	grdRecord.set('STOCK_UNIT_Q', record['QTY'] *　record['TRNS_RATE']);

	          	grdRecord.set('UNIT', record['ORDER_UNIT']);
	          	grdRecord.set('QTY',record['QTY']);
	          	grdRecord.set('PRICE',record['PRICE']);
	          	grdRecord.set('EXCHANGE_RATE', panelResult.getValue('EXCHANGE_RATE'));

	          	var dQty, dPrice, dExchr, dSoAmt, dUnit;
	          	dQty = record['QTY'];
	          	dPrice = record['PRICE'];
	          	dExchr = panelResult.getValue('EXCHANGE_RATE');
	          	dSoAmt =  dQty * dPrice;
	          	dUnit = panelResult.getValue('ATM_UNIT');

	          	grdRecord.set('SO_AMT', dSoAmt);
	          	//20191129 수정
	          	//20200204 공통코드 t125값에 따라 절상,절사,반올림 처리
	          	grdRecord.set('SO_AMT_WON',UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(dUnit,dSoAmt) * dExchr, BsaCodeInfo.gsTradeCalcMethod, 0));

	          	grdRecord.set('HS_NO', record['HS_NO']);
	          	grdRecord.set('HS_NAME', record['HS_NAME']);

	          	grdRecord.set('TRNS_RATE',  record['TRNS_RATE']);
	          	grdRecord.set('STOCK_UNIT',  record['STOCK_UNIT']);
	          	grdRecord.set('CLOSE_FLAG', 'N');
	          	grdRecord.set('USE_QTY', '0');

	          	grdRecord.set('ORDER_NUM', record['ORDER_NUM']);
	          	grdRecord.set('ORDER_SEQ', record['ORDER_SEQ']);
	          	grdRecord.set('PROJECT_NO', record['PROJECT_NO']);

	          	grdRecord.set('DELIVERY_DATE',  record['DVRY_DATE']);
	          	grdRecord.set('INSPEC_FLAG',  record['INSPEC_FLAG']);

	          	if(!Ext.isEmpty(panelResult.getValue('AGENTQ')) && !Ext.isEmpty(panelResult.getValue('AGENT_NMQ'))){
	          		panelResult.setValue('AGENT',panelResult.getValue('AGENTQ'));
	          		panelResult.setValue('AGENT_NM',panelResult.getValue('AGENT_NMQ'));
	          	}
	          }
	});
	Unilite.Excel.defineModel('excel.tio100ukrv.sheet01', {
			fields:
			[


				{name: 'CHOICE'		    , text: '선택'				, type: 'string'},
				{name: 'ITEM_CODE'		    , text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'				, type: 'string'},
				{name: 'QTY'		    , text: '구매수량'				, type: 'uniQty'},
				{name: 'ITEM_NAME'		    , text: '<t:message code="system.label.trade.itemname" default="품목명"/>'				, type: 'string'},
				{name: 'SPEC'		    , text: '<t:message code="system.label.trade.spec" default="규격"/>'				, type: 'string'},
				{name: 'MONEY_UNIT'		    , text: '<t:message code="system.label.trade.currencyunit" default="화폐단위"/>'				, type: 'string'},
				{name: 'EXCHG_RATE_O'		    , text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'				, type: 'string'},
				{name: 'PRICE'		    , text: '구매단가'				, type: 'uniUnitPrice'},
				{name: 'ORDER_UNIT'		    , text: '구매단위'				, type: 'string'},
				{name: 'TRNS_RATE'		    , text: '<t:message code="system.label.trade.containedqty" default="입수"/>'				, type: 'string'},
				{name: 'STOCK_UNIT'		    , text: '재고단위'				, type: 'string'},
				{name: 'HS_NO'		    , text: 'HS번호'				, type: 'string'},
				{name: 'HS_NAME'		    , text: 'HS품명'				, type: 'string'},
				{name: 'INSPEC_FLAG'		    , text: '품질대상여부'		,type: 'string', comboType:'AU', comboCode: 'Q002'},
				{name: 'DVRY_DATE'		    , text: '<t:message code="system.label.trade.deliverydate" default="납기일"/>'				, type: 'uniDate'},
				{name: 'DATA_CHECK'		    , text: '검증'				, type: 'string'}




			]
		}


	);



    function openExcelWindow() {
		var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';

        if(!excelWindow) {
        	excelWindow =  Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
        		modal: false,
        		excelConfigName: 'tio100ukr',

                grids: [{
            		itemId		: 'grid01',
            		title		: '엑셀참조',
            		useCheckbox	: false,
            		model		: 'excel.tio100ukrv.sheet01',
            		readApi		: 'tio100ukrvService.selectExcelUploadSheet1',
            		useCheckbox : true,
            		columns		: [
        				{dataIndex: '_EXCEL_JOBID'		, 		width: 80,	hidden: true},
			        	{dataIndex: 'CHOICE' , width: 80},
						{dataIndex: 'ITEM_CODE' , width: 80},
						{dataIndex: 'QTY' , width: 80},
						{dataIndex: 'ITEM_NAME' , width: 110},
						{dataIndex: 'SPEC' , width: 80},
						{dataIndex: 'MONEY_UNIT' , width: 80},
						{dataIndex: 'EXCHG_RATE_O' , width: 80},
						{dataIndex: 'PRICE' , width: 80},
						{dataIndex: 'ORDER_UNIT' , width: 80},
						{dataIndex: 'TRNS_RATE' , width: 80},
						{dataIndex: 'STOCK_UNIT' , width: 80},
						{dataIndex: 'HS_NO' , width: 110},
						{dataIndex: 'HS_NAME' , width: 110},
						{dataIndex: 'INSPEC_FLAG' , width: 90},
						{dataIndex: 'DVRY_DATE' , width: 80},
						{dataIndex: 'DATA_CHECK' , width: 80}
					]
                }],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },
                onApply:function()	{
					excelWindow.getEl().mask('로딩중...','loading-indicator');
                	var me = this;
                	var grid = this.down('#grid01');
        			var records = grid.getStore().getAt(0);
        			if (!Ext.isEmpty(records)) {
			        	var param	= {
			        		"_EXCEL_JOBID"	: records.get('_EXCEL_JOBID')
			        	};
			        	excelUploadFlag = "Y"
						tio100ukrvService.selectExcelUploadSheet1(param, function(provider, response){
					    	var store = masterGrid.getStore();
					    	var records	= response.result;
					    	Ext.each(records, function(record,i){
									UniAppManager.app.onNewDataButtonDownNoFormValidate();
									masterGrid.setExcelRefData(record);
							});
//					    	store.insert(0, records);
//					    	console.log("response",response)
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							UniAppManager.setToolbarButtons('save', false);
	          				UniAppManager.setToolbarButtons('print', true);
							me.hide();

					    });
						excelUploadFlag = "N"
		        	} else {
		        		alert (Msg.fSbMsgH0284);
		        		this.unmask();
		        	}
        		}
             });
        }
        excelWindow.center();
        excelWindow.show();
	};

	//openotherRefSearchWindow end