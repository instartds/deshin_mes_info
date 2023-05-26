<%@page language="java" contentType="text/html; charset=utf-8"%>
//openSearchInfoWindow begin
var type = '';
	Unilite.defineModel('orderNoMasterModel',
		{
			fields:
			[
				{name: 'DIV_CODE'			, text: '<t:message code="system.label.trade.division" default="사업장"/>'				, type: 'string',comboType:'BOR120'},
				{name: 'SO_SER_NO'			, text: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'		, type: 'string'},
				{name: 'DATE_DEPART'		, text: '<t:message code="system.label.trade.writtendate" default="작성일"/>'				, type: 'uniDate'},
				{name: 'IMPORTER'			, text: '<t:message code="system.label.trade.importer" default="수입자"/>'				, type: 'string'},
				{name: 'IMPORTERNM'			, text: '<t:message code="system.label.trade.importer" default="수입자"/>'				, type: 'string'},
				{name: 'EXPORTER'			, text: '<t:message code="system.label.trade.exporter" default="수출자"/>'				, type: 'string'},
				{name: 'EXPORTERNM'			, text: '<t:message code="system.label.trade.exporter" default="수출자"/>'				, type: 'string'},
				{name: 'PAY_TERMS'			, text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'				, type: 'string',comboType:'AU',comboCode:'T006'},
				{name: 'PAY_DURING'			, text: '결제기간'				, type: 'string'},
				{name: 'TERMS_PRICE'			, text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'				, type: 'string',comboType:'AU',comboCode:'T005'},
				{name: 'PAY_METHODE'			, text: '<t:message code="system.label.trade.payingterm" default="결제방법"/>'				, type: 'string'},
				{name: 'METHD_CARRY'			, text: ''				, type: 'string'},
				{name: 'DEST_PORT'			, text: ''				, type: 'string'},
				{name: 'DEST_PORT_NM'			, text: ''				, type: 'string'},
				{name: 'SHIP_PORT'			, text: ''				, type: 'string'},
				{name: 'SHIP_PORT_NM'			, text: ''				, type: 'string'},
				{name: 'DEST_FINAL'			, text: ''				, type: 'string'},
				{name: 'PLACE_DELIVERY'			, text: ''				, type: 'string'},
				{name: 'EXCHANGE_RATE'			, text: ''				, type: 'string'},
				{name: 'AMT_UNIT'			, text: ''				, type: 'string'},
				//20191202 수정
				{name: 'SO_AMT'			, text: '<t:message code="system.label.trade.offeramount2" default="OFFER액"/>'			, type: 'uniFC', allowBlank: false},
//				{name: 'SO_AMT'			, text: ''				, type: 'string'},
				{name: 'SO_AMT_WON'			, text: ''				, type: 'string'},
				{name: 'EXPENSE_FLAG'			, text: ''				, type: 'string'}

			]
		}
	);
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [{
				fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				
				readOnly:true,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>',
				name: 'SO_SER_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.trade.writtendate" default="작성일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				//holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
				valueFieldName: 'EXPORTER', //EXPORTER
				textFieldName: 'EXPORTER_NM', 
				textFieldWidth:175, 
				validateBlank:false, 
				popupWidth: 710,
				listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {									
								if(!Ext.isObject(oldValue)) {
									orderNoSearch.setValue('EXPORTER_NM', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {								
								if(!Ext.isObject(oldValue)) {
									orderNoSearch.setValue('EXPORTER', '');
								}
							}
						}
			}),{ 
				name: 'TERMS_PRICE',
				fieldLabel: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>',	 
				xtype:'uniCombobox',   
				comboType:'AU', 
				comboCode:'T005',
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
				fieldLabel: 'TYPE',
				name: 'TYPE',
				xtype: 'uniTextfield',
				hidden:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}
		],
		validateForm: function(){
			var r= true
			var invalid = this.getForm().getFields().filterBy(function(field) {
														return !field.validate();
													});
			if(invalid.length > 0) {
				r=false;
				var labelText = ''
	
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}
				alert(labelText+Msg.sMB083);
				invalid.items[0].focus();
			} 
			return r;
		}
	}); 
	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model: 'orderNoMasterModel',
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
				read	: 'tio100ukrvService.selectOrderNumMasterList'
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts){
				if(Ext.isEmpty(this.data.items)){
					Ext.Msg.alert('<t:message code="unilite.msg.sMB099" />','<t:message code="unilite.msg.sMB015" />');
				}
			}
		},
		loadStoreRecords : function() {
			if(orderNoSearch.validateForm()){
				var param= orderNoSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
			
		}
	});
		
	var orderNoMasterGrid = Unilite.createGrid('ipo100ma1OrderNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
		layout : 'fit',	  
		excelTitle: 'OFFER 관리번호 팝업',
		store: orderNoMasterStore,
		uniOpt:{	
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			expandLastColumn: true,
			useRowNumberer: false
		},
		selModel: 'rowmodel',
		columns: [ 
			{dataIndex: 'DIV_CODE'			, width: 120},
			{dataIndex: 'SO_SER_NO'			, width: 120},
			{dataIndex: 'DATE_DEPART'		, width: 120},
			{dataIndex: 'EXPORTERNM'		, width: 135},
			{dataIndex: 'PAY_TERMS'			, width: 120},
			{dataIndex: 'TERMS_PRICE'		, width: 120},
			{dataIndex: 'PAY_METHODE'		, width: 120},
			{dataIndex: 'SO_AMT'			, width: 100},
			{dataIndex: 'IMPORTER'			, width: 120,	hidden: true},
			{dataIndex: 'EXPORTER'			, width: 120,	hidden: true},
			{dataIndex: 'EXPORTERNM'		, width: 120,	hidden: true},
			{dataIndex: 'PAY_DURING'		, width: 120,	hidden: true},
			{dataIndex: 'METHD_CARRY'		, width: 120,	hidden: true},
			{dataIndex: 'DEST_PORT'			, width: 120,	hidden: true},
			{dataIndex: 'DEST_PORT_NM'		, width: 120,	hidden: true},
			{dataIndex: 'SHIP_PORT'			, width: 120,	hidden: true},
			{dataIndex: 'SHIP_PORT_NM'		, width: 120,	hidden: true},
			{dataIndex: 'DEST_FINAL'		, width: 120,	hidden: true},
			{dataIndex: 'PLACE_DELIVERY'	, width: 120,	hidden: true},
			{dataIndex: 'EXCHANGE_RATE'		, width: 120,	hidden: true},
			{dataIndex: 'AMT_UNIT'			, width: 120,	hidden: true},
			{dataIndex: 'SO_AMT'			, width: 120,	hidden: true},
			{dataIndex: 'SO_AMT_WON'		, width: 120,	hidden: true},
			{dataIndex: 'EXPENSE_FLAG'		, width: 120,	hidden: true},
			{dataIndex: 'GW_FLAG'			, width: 120,  hidden: true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				returnDataOper(record);
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.setValues({
				'SO_SER_NO':record.get('SO_SER_NO'),
				'DIV_CODE':record.get('DIV_CODE'), 
				'EXPORTER':record.get('EXPORTER'),
				'GW_FLAG':record.get('GW_FLAG')
			});
			panelSearch.setValues({
				'SO_SER_NO':record.get('SO_SER_NO'),
				'DIV_CODE':record.get('DIV_CODE'), 
				'EXPORTER':record.get('EXPORTER')
			});
		},
		returnDataOther: function(record) {
			panelResult.setValues({
				'SO_SER_NO':record.get('SO_SER_NO'),
				'DIV_CODE':record.get('DIV_CODE'), 
				'EXPORTER':record.get('EXPORTER'),
				'GW_FLAG':record.get('GW_FLAG')
			});
			panelSearch.setValues({
				'SO_SER_NO':record.get('SO_SER_NO'),
				'DIV_CODE':record.get('DIV_CODE'), 
				'EXPORTER':record.get('EXPORTER')
			});
			var param = panelResult.getValues();
			panelResult.uniOpt.inLoading = true;
			gsQueryFlag = false;
			Ext.getBody().mask('로딩중...','loading-indicator');
			panelResult.getForm().load(
				{
					params:param,
					success:function(form, action) {
						console.log(action.result.data);
						//var
						//not syn
						if(action.result.data){
							panelSearch.setValues({
								'EXPORTER':			panelResult.getValue('EXPORTER'),
								'EXPORTER_NM':		panelResult.getValue('EXPORTER_NM'),
								'AGREE_PRSN': 		panelResult.getValue('AGREE_PRSN'),
								'AGREE_PRSN_NAME':  panelResult.getValue('AGREE_PRSN_NAME'),
								'AGENTQ':			panelResult.getValue('AGENTQ'),
								'AGENT_NMQ':		panelResult.getValue('AGENT_NMQ'),
								'IMPORTER':			panelResult.getValue('IMPORTER'),
								'IMPORTER_NM': 		panelResult.getValue('IMPORTER_NM'),
								'AGENT':			panelResult.getValue('AGENT'),
								'AGENT_NM':			panelResult.getValue('AGENT_NM'),
								'BANK_SENDING':		panelResult.getValue('BANK_SENDING'),
								'BANK_SENDING_NM':  panelResult.getValue('BANK_SENDING_NM'),
								'DATE_DEPART':		UniDate.get('today'),
								'SO_SER_NO':		''
							});
							panelResult.setValues({
								'DATE_DEPART':UniDate.get('today'),
								'SO_SER_NO':''
							});
							Ext.getCmp('ChargeInput').setDisabled(true);
							Ext.getCmp('ChargeInput1').setDisabled(true);
							gbRetrieved	= false;
							var param	={'SUB_CODE': panelResult.getValue('IMPORT_NM')};
							fnGetAgreePrsn(param);
						}
						Ext.getBody().unmask();
						panelResult.uniOpt.inLoading = false;
					},
					failure:function(batch, option){
						Ext.getBody().unmask();
						panelResult.uniOpt.inLoading = false;
					}
				}
			);
		}
	});
	function returnDataOper(record){
		if(orderNoSearch.getValue('TYPE')){
			UniAppManager.app.onResetButtonDown();
			orderNoMasterGrid.returnDataOther(record);
		}else{
			orderNoMasterGrid.returnData(record);
			UniAppManager.app.onQueryButtonDown();
		}
		SearchInfoWindow.hide();
	};
	function openSearchInfoWindow(param) {			//fnFindSOSerNo
		type = param;
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: 'OFFER 관리번호 팝업',
				width: 1080,
				height: 650,
				layout: {type:'vbox', align:'stretch'},
				items: [orderNoSearch, orderNoMasterGrid], //orderNoDetailGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.trade.inquiry" default="조회"/>',
					handler: function() {
						orderNoMasterStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'OrderOkBtn',
					text: '적용',
					handler: function() {
						if(!Ext.isEmpty(orderNoMasterGrid.getSelectedRecord())){
							returnDataOper(orderNoMasterGrid.getSelectedRecord());
						}
					},
					disabled: false
				}, {
					itemId : 'OrderNoCloseBtn',
					text: '<t:message code="system.label.trade.close" default="닫기"/>',
					handler: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						orderNoSearch.setValues({
							'DIV_CODE':panelSearch.getValue('DIV_CODE'),
							'FR_DATE':UniDate.get('startOfMonth'),
							'TO_DATE':UniDate.get('today'),
							'TYPE':type
						});
						orderNoMasterStore.loadStoreRecords();
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}
	//openSearchInfoWindow end