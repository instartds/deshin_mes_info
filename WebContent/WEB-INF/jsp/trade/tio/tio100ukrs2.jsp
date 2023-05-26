<%@page language="java" contentType="text/html; charset=utf-8"%>
//openotherRefSearchWindow begin
	Ext.apply(masterGrid,{
	          setotherRefData: function(record) {

	          	var grdRecord = this.getSelectedRecord();

	          	grdRecord.set('SO_SER_NO', panelResult.getValue('SO_SER_NO'));
	          	grdRecord.set('ITEM_CODE', record['ITEM_CODE']);
	          	grdRecord.set('ITEM_NAME', record['ITEM_NAME']);
	          	grdRecord.set('SPEC',record['SPEC']);
	          	grdRecord.set('UNIT', record['UNIT']);
	          	grdRecord.set('QTY',record['QTY']);
	          	grdRecord.set('ORDER_UNIT_Q',record['QTY']);
	          	grdRecord.set('STOCK_UNIT_Q', record['STOCK_UNIT_Q']);
	          	grdRecord.set('PRICE',record['PRICE']);
	          	grdRecord.set('EXCHANGE_RATE', panelResult.getValue('EXCHANGE_RATE'));

	          	var dQty, dPrice, dExchr, dSoAmt , dUnit;
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

	          	grdRecord.set('MORE_PER_RATE', record['MORE_PER_RATE']);
	          	grdRecord.set('LESS_PER_RATE', record['LESS_PER_RATE']);
	          	grdRecord.set('TRNS_RATE',  record['TRNS_RATE']);
	          	grdRecord.set('STOCK_UNIT',  record['STOCK_UNIT']);
	          	grdRecord.set('CLOSE_FLAG', 'N');
	          	grdRecord.set('USE_QTY', '0');
	          	grdRecord.set('INSPEC_FLAG',  record['INSPEC_FLAG']);
	          	grdRecord.set('LOT_NO',  record['LOT_NO']);
	          	grdRecord.set('ITEM_ACCOUNT',  record['ITEM_ACCOUNT']);
				grdRecord.set('NATION_INOUT',  record['NATION_INOUT']);
	          }
	});
	Unilite.defineModel('otherRefMasterModel',
		{
			fields:
			[

				{name: 'CHOICE'		    , text: '선택	'				, type: 'string'},
				{name: 'DIV_CODE'		    , text: '사업장코드'				, type: 'string'},
				{name: 'SO_SER_NO'		    , text: 'OFFER  관리번호'				, type: 'string'},
				{name: 'SO_SER'		    , text: 'OFFER 순번'				, type: 'uniQty'},
				{name: 'EXPORTER'		    , text: '수출자코드			'				, type: 'string'},
				{name: 'EXPORTER_NM'		    , text: '<t:message code="system.label.trade.exporter" default="수출자"/>'				, type: 'string'},
				{name: 'PAY_TERMS'		    , text: '가격조건코드		'				, type: 'string'},
				{name: 'PAY_TERMS_NM'		    , text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'				, type: 'string'},
				{name: 'TERMS_PRICE'		    , text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>코드'				, type: 'string'},
				{name: 'TERMS_PRICE_NM'		    , text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'				, type: 'string'},
				{name: 'ITEM_CODE'		    , text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'				, type: 'string'},
				{name: 'ITEM_NAME'		    , text: '<t:message code="system.label.trade.itemname2" default="품명 "/>'				, type: 'string'},
				{name: 'SPEC'		    , text: '<t:message code="system.label.trade.spec" default="규격"/>'				, type: 'string'},
				{name: 'UNIT'		    , text: '구매단위'				, type: 'string'},
				{name: 'QTY'		    , text: '<t:message code="system.label.trade.qty" default="수량"/>'				, type: 'uniQty'},
				{name: 'PRICE'		    , text: '<t:message code="system.label.trade.price" default="단가 "/>'				, type: 'uniUnitPrice'},
				{name: 'SO_AMT'		    , text: '외화금액'				, type: 'uniUnitPrice'},
				{name: 'AMT_UNIT'		    , text: '<t:message code="system.label.trade.currency" default="화폐 "/>'				, type: 'string'},
				{name: 'EXCHANGE_RATE'		    , text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'				, type: 'string'},
				{name: 'SO_AMT_WON'		    , text: '자사금액'				, type: 'uniUnitPrice'},
				{name: 'HS_NO'		    , text: 'HS코드'				, type: 'string'},
				{name: 'HS_NAME'		    , text: 'HS명'				, type: 'string'},
				{name: 'USE_QTY'		    , text: '진행수량'				, type: 'uniQty'},
				{name: 'MORE_PER_RATE'		    , text: '과입고허용율(+)'				, type: 'string'},
				{name: 'LESS_PER_RATE'		    , text: '미입고허용율(-)'				, type: 'string'},
				{name: 'TRNS_RATE'		    , text: '<t:message code="system.label.trade.containedqty" default="입수"/>'				, type: 'string'},
				{name: 'STOCK_UNIT_Q'		    , text: '재고단위량'				, type: 'string'},
				{name: 'STOCK_UNIT'		    , text: '재고단위'				, type: 'string'},
				{name: 'INSPEC_FLAG'		    , text: '품질대상여부'				, type: 'string', comboType:'AU', comboCode: 'Q002'},
				{name: 'PROJECT_NO'		    , text: '프로젝트번호'				, type: 'string'},
				{name: 'LOT_NO'		    , text: 'LOT NO'				, type: 'string'},
				{name: 'ITEM_ACCOUNT'		    , text: 'ITEM_ACCOUNT'				, type: 'string'},	
				{name: 'NATION_INOUT'		    , text: '국내외구분'				, type: 'string'}
			]
		}


	);
	 var otherRefSearch = Unilite.createSearchForm('otherRefSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns :2},
	    trackResetOnLoad: true,
	    items: [{
				fieldLabel: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>',
				name: 'SO_SER_NO',
				xtype: 'uniTextfield',

				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.payingterm" default="결제방법"/>',
				name: 'PAY_METHODE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'T016',
	    		listeners: {
	    			change: function(field, newValue, oldValue, eOpts) {
					}
	    		}
			},{
				fieldLabel: '<t:message code="system.label.trade.writtendate" default="작성일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'DATE_DEPART_FR',
				endFieldName: 'DATE_DEPART_TO',

				//holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    }
			},{
	            name: 'TERMS_PRICE',
	            fieldLabel: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>',
	            xtype:'uniCombobox',
	            comboType:'AU',
	            comboCode:'T005',

	    		listeners: {
	    			change: function(field, newValue, oldValue, eOpts) {

					}
	    		}
		     }
		 ]
    });
	var otherRefMasterStore = Unilite.createStore('otherRefMasterStore', {	//조회버튼 누르면 나오는 조회창
			model: 'otherRefMasterModel',
			autoLoad: false,
			uniOpt: {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read    : 'tio100ukrvService.fnOfferDetail'
				}
			},
			loadStoreRecords : function()	{
				var param= otherRefSearch.getValues();
				param.DIV_CODE = panelResult.getValue("DIV_CODE");
				param.EXPORTER = panelResult.getValue("EXPORTER");
				console.log( param );
				this.load({
					params : param
				});
			}
		});

var otherRefMasterGrid = Unilite.createGrid('ipo100ma1otherRefMasterGrid', {		//조회버튼 누르면 나오는 조회창
		layout : 'fit',
        excelTitle: 'OFFER 관리번호 팝업',
		store: otherRefMasterStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false,mode:'MULTI' }),
		uniOpt:{
			useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			expandLastColumn: false,
			onLoadSelectFirst : false,
			useRowNumberer: false
		},
        columns: [
       		{dataIndex: 'CHOICE' , width: 80, hidden:true},
			{dataIndex: 'DIV_CODE' , width: 80, hidden:true},
			{dataIndex: 'SO_SER_NO' , width: 110},
			{dataIndex: 'SO_SER' , width: 91},
			{dataIndex: 'EXPORTER' , width: 80, hidden:true},
			{dataIndex: 'EXPORTER_NM' , width: 80},
			{dataIndex: 'PAY_TERMS' , width: 80, hidden:true},
			{dataIndex: 'PAY_TERMS_NM' , width: 80, hidden:true},
			{dataIndex: 'TERMS_PRICE' , width: 80, hidden:true},
			{dataIndex: 'TERMS_PRICE_NM' , width: 80, hidden:true},
			{dataIndex: 'ITEM_CODE' , width: 80},
			{dataIndex: 'ITEM_NAME' , width: 80},
			{dataIndex: 'SPEC' , width: 80},
			{dataIndex: 'UNIT' , width: 80},
			{dataIndex: 'QTY' , width: 80},
			{dataIndex: 'PRICE' , width: 80},
			{dataIndex: 'SO_AMT' , width: 80},
			{dataIndex: 'AMT_UNIT' , width: 80},
			{dataIndex: 'EXCHANGE_RATE' , width: 80},
			{dataIndex: 'SO_AMT_WON' , width: 80, hidden:true},
			{dataIndex: 'HS_NO' , width: 80, hidden:true},
			{dataIndex: 'HS_NAME' , width: 80, hidden:true},
			{dataIndex: 'USE_QTY' , width: 80},
			{dataIndex: 'MORE_PER_RATE' , width: 80, hidden:true},
			{dataIndex: 'LESS_PER_RATE' , width: 80, hidden:true},
			{dataIndex: 'TRNS_RATE' , width: 80},
			{dataIndex: 'STOCK_UNIT_Q' , width: 80},
			{dataIndex: 'STOCK_UNIT' , width: 80},
			{dataIndex: 'INSPEC_FLAG' , width: 80},
			{dataIndex: 'PROJECT_NO' , width: 80},
			{dataIndex: 'LOT_NO' , width: 80},
			{dataIndex: 'ITEM_ACCOUNT' , width: 80, hidden:true},
			{dataIndex: 'NATION_INOUT' , width: 80, hidden:true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {

			}
		},
		returnData: function(records)	{
				var param = panelResult.getValues();
				panelResult.uniOpt.inLoading = true;
				Ext.getBody().mask('로딩중...','loading-indicator');
				panelResult.getForm().load(
				{
					params:param,
					success:function(form, action)	{
						console.log(action.result.data);
						var data = action.result.data;
						gNationInOut = data['NATION_INOUT'];
						//not syn
						panelSearch.setValues({
							'EXPORTER': 		panelResult.getValue('EXPORTER'),
							'EXPORTER_NM':  	panelResult.getValue('EXPORTER_NM'),
							'AGREE_PRSN': 		panelResult.getValue('AGREE_PRSN'),
							'AGREE_PRSN_NAME':  panelResult.getValue('AGREE_PRSN_NAME'),
							'AGENTQ':  			panelResult.getValue('AGENTQ'),
							'AGENT_NMQ':  		panelResult.getValue('AGENT_NMQ'),
							'IMPORTER':  		panelResult.getValue('IMPORTER'),
							'IMPORTER_NM': 	 	panelResult.getValue('IMPORTER_NM'),
							'AGENT':  			panelResult.getValue('AGENT'),
							'AGENT_NM':  		panelResult.getValue('AGENT_NM'),
							'BANK_SENDING':  	panelResult.getValue('BANK_SENDING'),
							'BANK_SENDING_NM':  panelResult.getValue('BANK_SENDING_NM')
						});
						Ext.getBody().unmask();


						panelResult.uniOpt.inLoading = false;
					},
					failure:function(batch, option){
						Ext.getBody().unmask();
						panelResult.uniOpt.inLoading = false;
					}

				}
				);
				Ext.each(records, function(record,i){
					UniAppManager.app.onNewDataButtonDownNoFormValidate(record.data);
					masterGrid.setotherRefData(record.data);
				});
				otherRefMasterGrid.getStore().remove(records);
//				UniAppManager.setToolbarButtons('save', false);
//	          	UniAppManager.setToolbarButtons('print', true);

		}
    });

	function openOtherRefSearchWindow() {			//fnFindSOSerNo
		if(!otherRefSearchWindow) {
			otherRefSearchWindow = Ext.create('widget.uniDetailWindow', {
            	title: '<t:message code="system.label.trade.otherofferrefer" default="타OFFER 참조"/>',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [otherRefSearch, otherRefMasterGrid], //otherRefDetailGrid],
                tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.trade.inquiry" default="조회"/>',
					handler: function() {
						otherRefMasterStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'OrderOkBtn',
					text: '적용',
					handler: function() {
						var records = otherRefMasterGrid.getSelectedRecords()
						if(!Ext.isEmpty(records)){
							otherRefMasterGrid.returnData(records);

						}

					},
					disabled: false
				},{
				    itemId : 'confirmCloseBtn',
                    text: '적용 후 닫기',
                    handler: function() {
                        var records = otherRefMasterGrid.getSelectedRecords()
                        if(!Ext.isEmpty(records)){
                            otherRefMasterGrid.returnData(records);
                            otherRefSearchWindow.hide();
                        }
                    },
                    disabled: false
                }, {
					itemId : 'otherRefCloseBtn',
					text: '<t:message code="system.label.trade.close" default="닫기"/>',
					handler: function() {
						otherRefSearchWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						otherRefSearch.clearForm();
						otherRefMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						otherRefSearch.clearForm();
						otherRefMasterGrid.reset();
					},
					show: function( panel, eOpts )	{
						otherRefMasterStore.loadStoreRecords();
			         }
				}
			})
		}
		otherRefSearchWindow.center();
		otherRefSearchWindow.show();
    }
	//openotherRefSearchWindow end