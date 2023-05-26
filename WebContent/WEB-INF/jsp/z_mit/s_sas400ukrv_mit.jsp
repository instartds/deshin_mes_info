<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sas400ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sas400ukrv_mit" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S007"/>						<!-- 출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 출고유형 -->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">

var BsaCodeInfo = {
	gsVatRate		: ${gsVatRate}
};


function appMain() {

	var gsLastDay;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sas400ukrv_mitService.selectDetailList',
			update	: 's_sas400ukrv_mitService.updateDetail',
			destroy	: 's_sas400ukrv_mitService.deleteDetail',
			syncAll	: 's_sas400ukrv_mitService.saveAll'
		}
	});

	//마스터 폼
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,	tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
//			holdable	: 'hold',
			child		: 'WH_CODE',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			name		: 'SALE_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
//			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					fnGetLastDay(newValue);
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.sales" default="매출"/>',
				name		: 'ENTRY_YN',
				itemId		: 'ENTRY_YN',
//				holdable	: 'hold',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.nonentry" default="미등록"/>',
					name		: 'ENTRY_YN',
					inputValue	: 'N',
					width		: 70
				},{
					boxLabel	: '<t:message code="system.label.sales.entry" default="등록"/>',
					name		: 'ENTRY_YN',
					inputValue	: 'Y',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.ENTRY_YN == 'Y') {
							masterGrid.getColumn('BILL_NUM').setHidden(false);
							masterGrid.getColumn('BILL_SEQ').setHidden(false);
							if(masterStore.getData() > 0)	{
								UniAppManager.setToolbarButtons(['delete']	, true);
							}
						} else {
							masterGrid.getColumn('BILL_NUM').setHidden(true);
							masterGrid.getColumn('BILL_SEQ').setHidden(true);
							UniAppManager.setToolbarButtons(['delete']	, false);
						}
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName:'SALE_CUSTOM_CODE',
			extParam:{'AGENT_CUST_FILTER':  ['1','3'], 'CUSTOM_TYPE':  ['1','3']}
		}),{
			fieldLabel		: '<t:message code="system.label.sales.repairdate" default="수리견적일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'REPAIR_DATE_FR',
			endFieldName	: 'REPAIR_DATE_TO',
			allowBlank	    : false
		},{
			fieldLabel: '영업담당자',
			name: 'SALE_PRSN',
			xtype: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			listConfig:{minWidth:230}
		},{
			fieldLabel	: '',
			name		: 'VAT_RATE',
			xtype		: 'uniNumberfield',
			allowBlank	: false,
			hidden		: true,
			value		: parseInt(BsaCodeInfo.gsVatRate),
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				blur: function(field, The, eOpts)	{
				}
			}
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

					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ){
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});// End of var panelResult = Unilite.createSearchForm('searchForm',{

	//마스터 모델
	Unilite.defineModel('s_sas400ukrv_mitModel',{
		fields: [
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'				, type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'SALE_CUST_CD'		, text: '매출거래처코드'				, type: 'string', allowBlank: false},
			{name: 'SALE_CUST_NAME'		, text: '매출거래처명'			    , type: 'string'},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.sales.receiptnum" default="접수번호"/>'			, type: 'string'},
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'			, type: 'uniDate'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>' 					, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'AS_AMT'				, text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'		, type: 'uniPrice', defaultValue: '0', allowBlank: false},
			{name: 'TAX_AMT'			, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'			, type: 'uniPrice', defaultValue: '0', allowBlank: true},
			{name: 'TOT_AMT'			, text: '<t:message code="system.label.sales.totalamount2" default="총액"/>'			, type: 'uniPrice', defaultValue: '0', editable: false},
			{name: 'REPAIR_NUM'			, text: '<t:message code="system.label.sales.repairnum" default="수리번호"/>'			, type: 'string'},	//SCN100T.CONT_NUM
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			, type: 'string'  , comboType: 'AU', comboCode: 'S007', allowBlank: false},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string'  ,comboType: "BOR120", allowBlank: false},
			{name: 'BILL_NUM'			, text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'			, type: 'string'},
			{name: 'BILL_SEQ'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'					, type: 'int'},
			{name: 'PROJECT_NO'			, text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'PJT_NAME'			, text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'		, type: 'string', editable: false},
			{name: 'SALE_PRSN'	    	, text: 'SALE_PRSN'		, type: 'string'    , editoable: false},
			{name: 'SALE_Q'				, text: 'SALE_Q' 		, type: 'string'    , editoable: false},
			{name: 'AS_PRICE'	    	, text: 'AS_PRICE'		, type: 'uniPrice'  , editoable: false},
			{name: 'ORDER_TYPE'			, text: 'ORDER_TYPE'	, type: 'string'    , editoable: false},
			{name: 'BILL_TYPE'			, text: 'BILL_TYPE'		, type: 'string'    , editoable: false},
			{name: 'INOUT_NUM'			, text: 'INOUT_NUM'		, type: 'string'    , editoable: false},
			{name: 'INOUT_SEQ'			, text: 'INOUT_SEQ'		, type: 'int'    	, editoable: false},
			{name: 'SALE_UNIT'			, text: 'SALE_UNIT'		, type: 'string'    , editoable: false},
			{name: 'WH_CODE'			, text: 'WH_CODE'		, type: 'string'    , editoable: false},
			{name: 'TAX_TYPE'			, text: 'TAX_TYPE'		, type: 'string'    , editoable: false},
			{name: 'PRICE_YN'			, text: 'PRICE_YN'		, type: 'string'    , editoable: false},
			{name: 'OUT_DIV_CODE'		, text: 'OUT_DIV_CODE'	, type: 'string'    , editoable: false},
			{name: 'STOCK_UNIT'			, text: 'STOCK_UNIT'	, type: 'string'    , editoable: false},
			{name: 'MONEY_UNIT'			, text: 'MONEY_UNIT'	, type: 'string'    , editoable: false},
			{name: 'EXCHG_RATE_O'		, text: 'EXCHG_RATE_O'	, type: 'uniER'    	, editoable: false},
			{name: 'TAX_IN_OUT'			, text: 'TAX_IN_OUT'	, type: 'string'    , editoable: false},
			{name: 'TAX_CALC_TYPE'		, text: 'TAX_CALC_TYPE'	, type: 'string'    , editoable: false},
			{name: 'AGENT_TYPE'			, text: 'AGENT_TYPE'	, type: 'string'    , editoable: false},
			{name: 'SAVE_FLAG'			, text: 'SAVE_FLAG'	    , type: 'string'    , editoable: false},
			{name: 'WON_CALC_BAS'		, text: 'SAVE_FLAG'	    , type: 'string'    , editoable: false},
			{name: 'TAX_TYPE'			, text: 'SAVE_FLAG'	    , type: 'string'    , editoable: false}
		]
	});// End of Unilite.defineModel('Ssa101ukrvModel',{

	// 마스터 스토어 정의
	var masterStore = Unilite.createStore('s_sas400ukrv_mitStore',{
		model	: 's_sas400ukrv_mitModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param		= panelResult.getValues();
			param.ENTRY_YN	= panelResult.getValue('ENTRY_YN').ENTRY_YN;

			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			// 1. 마스터 정보 파라미터 구성
			var paramMaster = panelResult.getValues();	// syncAll 수정

			if((inValidRecs.length == 0)) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						masterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_sas400ukrv_mitGrid');
				if(!Ext.isEmpty(inValidRecs)){
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);}
				
			}
		},
		listeners:{
			load : function(store, records){
				if(records && records.length > 0 && panelResult.getValue("ENTRY_YN") == "Y") {
					UniAppManager.setToolbarButtons(['delete']	, true);
				} else {
					UniAppManager.setToolbarButtons(['delete']	, false);
				}
			}
		}
	});

	// 마스터 그리드
	var masterGrid = Unilite.createGrid('s_sas400ukrv_mitGrid',{
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			copiedRow			: false
		},
		features: [ {id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false ,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var proccessGubun = panelResult.getValue('ENTRY_YN').ENTRY_YN;
					if(proccessGubun == 'N') { //미등록
						selectRecord.set('SAVE_FLAG', 'N');
					} else {
						selectRecord.set('SAVE_FLAG', 'U');
					}
				},
				deselect: function(grid, selectRecord, index, eOpts ){
					selectRecord.set('SAVE_FLAG', '');
				}
			}
		}),
		columns	: [
			{dataIndex: 'CUSTOM_CODE'			, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
				}
			},
			{dataIndex: 'CUSTOM_NAME'			, width: 200},
			{dataIndex: 'SALE_CUST_CD'		, width: 120,
			  editor : Unilite.popup('CUST_G', {
				autoPopup: true,
				textFieldName:'SALE_CUST_CD',
				DBtextFieldName: 'CUSTOM_CODE',
				listeners: {
					'onSelected': {
						fn: function(records, type) {
							console.log('records : ', records);
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('SALE_CUST_CD'	, records[0]['CUSTOM_CODE']);
							grdRecord.set('SALE_CUST_NAME'	, records[0]['CUSTOM_NAME']);
								
						},
						scope: this
					},
					'onClear': function(type) {
						var grdRecord = masterGrid.uniOpt.currentRecord;
						grdRecord.set('SALE_CUST_CD'	, '');
						grdRecord.set('SALE_CUST_NAME'	, '');
					}
				}
			  })
			},  
			{dataIndex: 'SALE_CUST_NAME'		, width: 200,
			  	editor : Unilite.popup('CUST_G', {
					autoPopup: true,
					textFieldName:'SALE_CUST_NAME',
					DBtextFieldName: 'CUSTOM_NAME',
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('SALE_CUST_CD'	, records[0]['CUSTOM_CODE']);
								grdRecord.set('SALE_CUST_NAME'	, records[0]['CUSTOM_NAME']);
									
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('SALE_CUST_CD'	, '');
							grdRecord.set('SALE_CUST_NAME'	, '');
						}
					}
				})
			},
			{dataIndex: 'SALE_DATE'				, width: 80	},
			{dataIndex: 'ITEM_CODE'				, width: 120},
			{dataIndex: 'ITEM_NAME'				, width: 200},
			{dataIndex: 'AS_AMT'				, width: 120, summaryType: 'sum'},
			{dataIndex: 'TAX_AMT'				, width: 120, summaryType: 'sum'},
			{dataIndex: 'TOT_AMT'				, width: 120, summaryType: 'sum'},
			{dataIndex: 'REPAIR_NUM'			, width: 120},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 100, align:'center'},
			{dataIndex: 'BILL_NUM'				, width: 120},
			{dataIndex: 'BILL_SEQ'				, width: 100, align:'center'},
			//20200131 프로젝트코드 / 명 추가,
			{dataIndex: 'PROJECT_NO'			, width: 100,
				editor: Unilite.popup('PROJECT_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.uniOpt.currentRecord;
								Ext.each(records, function(record,i) {
									if(i==0) {
										grdRecord.set('PROJECT_NO'	, record['PJT_CODE']);
										grdRecord.set('PJT_NAME'	, record['PJT_NAME']);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('PROJECT_NO'	, '');
							grdRecord.set('PJT_NAME'	, '');
						},
						applyextparam: function(popup){
						}
					}
				})
			},
			{dataIndex: 'PJT_NAME'				, width: 100}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ["AS_AMT", "TAX_AMT", 'PROJECT_NO'])) {
					return true;
				} else if(Ext.isEmpty(e.record.get("BILL_NUM")) && UniUtils.indexOf(e.field, [ 'SALE_CUST_CD', 'SALE_CUST_NAME'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});

	Unilite.Main( {
		id			: 's_sas400ukrv_mitApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset']	, true);
			UniAppManager.setToolbarButtons(['newData']	, false);
			this.setDefault();
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('ENTRY_YN'			, 'N');
			panelResult.setValue('SALE_DATE'		, new Date());
			panelResult.setValue('VAT_RATE'			, parseInt(BsaCodeInfo.gsVatRate));
			panelResult.setValue('REPAIR_DATE_FR' , UniDate.get('startOfMonth'));
			panelResult.setValue('REPAIR_DATE_TO' , UniDate.today());
			fnGetLastDay(new Date());

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			panelResult.setAllFieldsReadOnly(true);
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			masterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.get('SAVE_FLAG') == 'U' ) {
				selRow.set('SAVE_FLAG', 'D');
			} else {
				selRow.set('SAVE_FLAG', '');
			}
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		fnTaxCalculate: function(rtnRecord, dAmtO) {
			var sTaxType		= rtnRecord.obj.get("TAX_TYPE");
			var sWonCalBas		= rtnRecord.obj.get("WON_CALC_BAS");

			var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
			var numDigitOfPrice	= UniFormat.Price.length - digit;
			var dVatRate = BsaCodeInfo.gsVatRate;
			var dTaxAmtO = 0;
			
			if(sTaxType =="1") {  
				dAmtO		= UniSales.fnAmtWonCalc(dAmtO, sWonCalBas, numDigitOfPrice);
				dTaxAmtO	= dAmtO * dVatRate / 100
				dTaxAmtO    = UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas, numDigitOfPrice);	//세액은 절사처리함.
				
			} else if(sTaxType =="2") {
				dTemp	= UniSales.fnAmtWonCalc((dAmtO / ( dVatRate + 100 )) * 100, sWonCalBas, numDigitOfPrice);
				dTaxAmtO= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sWonCalBas, numDigitOfPrice);	// 세액은 절사처리함.
				dAmtO = UniSales.fnAmtWonCalc((dAmtO - dTaxAmtO), rtnRecord.obj.get("WON_CALC_BAS"), numDigitOfPrice) ;
			}

			rtnRecord.obj.set('AS_AMT'	, dAmtO);
			rtnRecord.obj.set('TAX_AMT'	, dTaxAmtO);
			rtnRecord.obj.set('TOT_AMT'	, dAmtO+dTaxAmtO);
		} 
		
		
	});// End of Unilite.Main( {


	function fnGetLastDay(newValue) {
		if(newValue && Ext.isDate(newValue) ) {
			gsLastDay = new Date(newValue.getFullYear(), newValue.getMonth()+1, 0).getDate();
		}
	}
	//Validation
	Unilite.createValidator('validator01',{
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			
			var rv = true;
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ',{'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
		
			switch(fieldName) {
				case "AS_AMT" : 
					UniAppManager.app.fnTaxCalculate(record, newValue)
					break;
				case "TAX_AMT" :			//부가세액
					record.set('TOT_AMT', record.get('AS_AMT') + newValue);
					break;
				default:
				 	break;
				
			}

			return rv;
		}
	}); // validator
};
</script>
