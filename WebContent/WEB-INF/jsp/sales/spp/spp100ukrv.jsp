<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="spp100ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="spp100ukrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />			<!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />			<!--과세여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />			<!--견적단위 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore comboType="OU" />							<!-- 창고-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-Default {
		color: #333333;
		font-weight: normal;
		padding: 1px 2px;
	}
</style>

<script type="text/javascript">

var BsaCodeInfo = {
	gsAutoType		: '${gsAutoType}',
	gsMoneyUnit		: '${gsMoneyUnit}',
	gsVatRate		: ${gsVatRate},
	gsSof100rkrLink	: '${gsSof100rkrLink}',
	gsSof100ukrLink	: '${gsSof100ukrLink}',
	inoutPrsn		: ${inoutPrsn},
	gsReportGubun	: '${gsReportGubun}', //클립리포트 추가로 인한 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
	gsFaxUseYn		: '${gsFaxUseYn}'
};

var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCrYn		: '',
	gsWonCalcBas	: '',
	gsRefTaxInout	: ''
};

var SearchInfoWindow;	// 검색창
var estimateWindow;		// 견적 참조
var buttonClicked = false;
var gsInitFlag;
var gsMoneyUnitRef4	= Ext.isEmpty('${gsMoneyUnitRef4}') ? BsaCodeInfo.gsMoneyUnit   : '${gsMoneyUnitRef4}';;
var gsExchangeRate	= '${gsExchangeRate}';
var gsFaxBtnHidden = true;
if(Ext.isEmpty(gsExchangeRate) || gsExchangeRate == '0.0000') {
	gsExchangeRate = '1.0000';
}
if(!Ext.isEmpty(BsaCodeInfo.gsFaxUseYn)&& BsaCodeInfo.gsFaxUseYn == 'Y'){
	gsFaxBtnHidden = false;
}
function appMain() {
	var confirmTypeStore = Unilite.createStore('confirmTypeStore',{
		fields	: ['text', 'value'],
		data	: [
			{text:"견적진행",	value: "1"},	//Msg.sMS140
			{text:"견적확정",	value: "2"}		//Msg.sMS141
		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'spp100ukrvService.selectList',
			update	: 'spp100ukrvService.updateList',
			create	: 'spp100ukrvService.insertList',
			destroy	: 'spp100ukrvService.deleteList',
			syncAll	: 'spp100ukrvService.saveAll'
		}
	});

	var masterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'spp100ukrvService.selectMaster',
			update	: 'spp100ukrvService.updateMaster',
			create	: 'spp100ukrvService.insertMaster',
			destroy	: 'spp100ukrvService.deleteMaster',
			syncAll	: 'spp100ukrvService.saveMaster'
		}
	});



	Unilite.defineModel('spp100ukrvMasterModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			,type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'			,type: 'string'},
			{name: 'CUSTOM_CODE'		, text: 'CUSTOM_CODE'		,type: 'string'},
			{name: 'CUSTOM_NAME'		, text: 'CUSTOM_NAME'		,type: 'string'},
			{name: 'ESTI_PRSN'			, text: 'ESTI_PRSN'			,type: 'string'},
			{name: 'CUST_PRSN'			, text: 'CUST_PRSN'			,type: 'string'},
			{name: 'ESTI_AMT'			, text: 'ESTI_AMT'			,type: 'uniPrice'},
			{name: 'ESTI_NUM'			, text: 'ESTI_NUM'			,type: 'string'},
			{name: 'ESTI_PAYCONDI'		, text: 'ESTI_PAYCONDI'		,type: 'string'},
			{name: 'ESTI_CFM_AMT'		, text: 'ESTI_CFM_AMT'		,type: 'uniPrice'},
			{name: 'CONFIRM_DATE'		, text: 'CONFIRM_DATE'		,type: 'uniDate'},
			{name: 'ESTI_VALIDTERM'		, text: 'ESTI_VALIDTERM'	,type: 'string'},
			{name: 'ESTI_TAX_AMT'		, text: 'ESTI_TAX_AMT'		,type: 'uniPrice'},
			{name: 'CONFIRM_FLAG'		, text: 'CONFIRM_FLAG'		,type: 'string'},
			{name: 'ESTI_DVRY_DATE'		, text: 'ESTI_DVRY_DATE'	,type: 'string'},
			{name: 'CUSTOM_CODE'		, text: 'CUSTOM_CODE'		,type: 'string'},
			{name: 'CUSTOM_NAME'		, text: 'CUSTOM_NAME'		,type: 'string'},
			{name: 'ESTI_DVRY_PLCE'		, text: 'ESTI_DVRY_PLCE'	,type: 'string'},
			{name: 'ESTI_DATE'			, text: 'ESTI_DATE'			,type: 'uniDate'},
			{name: 'REMARK'				, text: 'REMARK'			,type: 'string'},
			{name: 'ESTI_TITLE'			, text: 'ESTI_TITLE'		,type: 'string'},
			{name: 'MONEY_UNIT'			, text: 'MONEY_UNIT'		,type: 'string'},
			{name: 'EXCHANGE_RATE'		, text: 'EXCHANGE_RATE'		,type: 'uniPrice'},
			{name: 'PROFIT_RATE'		, text: 'PROFIT_RATE'		,type: 'uniPrice'},
			{name: 'ESTI_EX_AMT'		, text: 'ESTI_EX_AMT'		,type: 'uniPrice'},
			{name: 'ESTI_CFM_TAX_AMT'	, text: 'ESTI_CFM_TAX_AMT'	,type: 'uniPrice'},
			{name: 'ESTI_CFM_EX_AMT'	, text: 'ESTI_CFM_EX_AMT'	,type: 'uniPrice'}
		]
	});

	var masterStore = Unilite.createStore('spp100ukrvmasterStore',{	// 메인
		model	: 'spp100ukrvMasterModel',
		proxy	: masterProxy,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('masterTable').getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();

			//1. 마스터 정보 파라미터 구성
			var paramMaster			= panelResult.getValues();	//syncAll 수정
			paramMaster.AUTO_NO_YN	= BsaCodeInfo.gsAutoType;

			if(inValidRecs.length == 0 ) {
				config = {
					params	: [paramMaster],
					useSavedMessage : false,
					success	: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterTable.setValue("ESTI_NUM", master.ESTI_NUM);
						panelResult.setValue("ESTI_NUM", master.ESTI_NUM);
						if(detailStore.isDirty()) {
							detailStore.saveStore();
						} else {
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
							if(masterStore.getCount() == 0) {
								UniAppManager.app.onResetButtonDown();
							}else{
								UniAppManager.app.onQueryButtonDown();
							}
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				console.log("record :",store)
			},
			add: function(store, records, index, eOpts) {
				console.log("record :",store)
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(buttonClicked) {
					masterStore.saveStore();
				}
			},
			remove: function(store, record, index, isMove, eOpts) {
				console.log("record :",store)
			}
		}
	});

	var mainGrid = Unilite.createGrid('spp100ukrvMasterGrid', {		// 메인
		store	: masterStore,
		region	: 'south',
		layout	: 'fit',
		hidden	: true,
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: true,
			useMultipleSorting	: true
		},
		columns: [
			{ dataIndex: 'COMP_CODE'		, width: 100},
			{ dataIndex: 'CUSTOM_CODE'		, width: 100},
			{ dataIndex: 'CUSTOM_NAME'		, width: 100},
			{ dataIndex: 'DIV_CODE'			, width: 100},
			{ dataIndex: 'ESTI_PRSN'		, width: 100},
			{ dataIndex: 'CUST_PRSN'		, width: 100},
			{ dataIndex: 'ESTI_AMT'			, width: 100},
			{ dataIndex: 'ESTI_NUM'			, width: 100},
			{ dataIndex: 'ESTI_PAYCONDI'	, width: 100},
			{ dataIndex: 'ESTI_CFM_AMT'		, width: 100},
			{ dataIndex: 'CONFIRM_DATE'		, width: 100},
			{ dataIndex: 'ESTI_VALIDTERM'	, width: 100},
			{ dataIndex: 'ESTI_TAX_AMT'		, width: 100},
			{ dataIndex: 'CONFIRM_FLAG'		, width: 100},
			{ dataIndex: 'ESTI_DVRY_DATE'	, width: 100},
			{ dataIndex: 'CUSTOM_CODE'		, width: 100},
			{ dataIndex: 'CUSTOM_NAME'		, width: 100},
			{ dataIndex: 'ESTI_DVRY_PLCE'	, width: 100},
			{ dataIndex: 'ESTI_DATE'		, width: 100},
			{ dataIndex: 'REMARK'			, width: 100},
			{ dataIndex: 'ESTI_TITLE'		, width: 100},
			{ dataIndex: 'MONEY_UNIT'		, width: 100},
			{ dataIndex: 'EXCHANGE_RATE'	, width: 100},
			{ dataIndex: 'PROFIT_RATE'		, width: 100},
			{ dataIndex: 'ESTI_EX_AMT'		, width: 100},
			{ dataIndex: 'ESTI_CFM_TAX_AMT'	, width: 100},
			{ dataIndex: 'ESTI_CFM_EX_AMT'	, width: 100}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
			},
			selectionchangerecord:function(selected) {
				masterTable.loadForm(selected);
			},
			load: function(store, records, successful, eOpts) {
			},
			render: function(grid, eOpts) {
				var inoutPrsn;
				var param = panelResult.getValues();
				spp100ukrvService.selectEstiPrsn(param, function(provider, response) {
					if(!Ext.isEmpty(provider[0])) {
						masterTable.setValue('ESTI_PRSN', provider[0].SUB_CODE);
					}
				});
				inoutPrsn = masterTable.getValue('ESTI_PRSN');
				var r = {
					ESTI_DATE		: new Date(),
					CONFIRM_DATE	: new Date(),
					CONFIRM_FLAG	: '1',
					ESTI_PRSN		: inoutPrsn,
					MONEY_UNIT		: gsMoneyUnitRef4,
					EXCHANGE_RATE	: gsExchangeRate
				};
				mainGrid.createRow(r);
			}
		}
	});



	var panelSearch = Unilite.createSearchPanel('spp100ukrvpanelSearch',{	// 메인
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					allowBlank		: false,
					holdable		: 'hold',
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								CustomCodeInfo.gsAgentType	= records[0]["AGENT_TYPE"];
								CustomCodeInfo.gsRefTaxInout= records[0]["TAX_TYPE"];	 //세액포함여부
								CustomCodeInfo.gsWonCalcBas	= records[0]["WON_CALC_BAS"];
								if(!Ext.isEmpty(records[0].MONEY_UNIT)) {
									masterTable.setValue('EXCHG_MONEY_UNIT',records[0].MONEY_UNIT);
								}else{
									masterTable.setValue('EXCHG_MONEY_UNIT', 'KRW');
								}
								if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)) {
									panelSearch.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
									panelResult.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
								}
							},
							scope: this
						},
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_CODE', newValue);
							masterTable.setValue('CUSTOM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								CustomCodeInfo.gsRefTaxInout= '';
								CustomCodeInfo.gsAgentType	= '';
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
								masterTable.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_NAME', newValue);
							masterTable.setValue('CUSTOM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								CustomCodeInfo.gsRefTaxInout= '';
								CustomCodeInfo.gsAgentType	= '';
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
								masterTable.setValue('CUSTOM_CODE', '');
							}
						},
						
						applyextparam: function(popup) {
							popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
						}
					}
				}),{
					fieldLabel	: '견적일',
					name		: 'ESTI_DATE',
					xtype		: 'uniDatefield',
					value		: new Date(),
					allowBlank	: false,
					holdable	: 'hold',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ESTI_DATE', newValue);
						}
					}
				},{
					xtype		: 'uniTextfield',
					fieldLabel	: '견적건명',
					name		: 'ESTI_TITLE',
					width		: 315,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ESTI_TITLE', newValue);
						}
					}
				},{
					xtype		: 'uniTextfield',
					fieldLabel	: 'TAX_TYPE',
					name		: 'TAX_INOUT',
					hidden		: true
				}]
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
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
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
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me				= this;
			me.uniOpt.inLoading	= false;
			me.setAllFieldsReadOnly(true);
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		padding	: '1 1 1 1',
		border	: true,
		items	: [
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				allowBlank		: false,
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				holdable		: 'hold',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							if(!Ext.isEmpty(records[0].MONEY_UNIT)) {
								masterTable.setValue('EXCHG_MONEY_UNIT', records[0].MONEY_UNIT);
							}else{
								masterTable.setValue('EXCHG_MONEY_UNIT', 'KRW');
							}
							CustomCodeInfo.gsAgentType	= records[0]["AGENT_TYPE"];
							CustomCodeInfo.gsRefTaxInout= records[0]["TAX_TYPE"];	 //세액포함여부
							CustomCodeInfo.gsWonCalcBas	= records[0]["WON_CALC_BAS"];
							if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)) {
								panelSearch.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
								panelResult.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
							}
						},
						scope: this
					},
					onValueFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);
						masterTable.setValue('CUSTOM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							CustomCodeInfo.gsRefTaxInout= '';
							CustomCodeInfo.gsAgentType	= '';
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
							masterTable.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);
						masterTable.setValue('CUSTOM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							CustomCodeInfo.gsRefTaxInout= '';
							CustomCodeInfo.gsAgentType	= '';
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
							masterTable.setValue('CUSTOM_CODE', '');
						}
					},
					
					applyextparam: function(popup) {
						popup.setExtParam({'AGENT_CUST_FILTER': '1,3'});
					}
				}
			}),{
				fieldLabel	: '견적일',
				name		: 'ESTI_DATE',
				xtype		: 'uniDatefield',
				value		: new Date(),
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ESTI_DATE', newValue);
						masterTable.setValue('ESTI_DATE', newValue);
					}
				}
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable'},
				tdAttrs	: {align: 'right'},
				padding	: '0 20 0 0',
				items	: [
					/* {
						xtype: 'button',
						text: '견적서 출력',
						width: 110,
						id: 'ESTI_PRINT',
						handler : function(records, grid, record) {
							if(Ext.isEmpty(panelResult.getValue('ESTI_NUM'))) {
								return false;
							}
							if(UniAppManager.app._needSave()) {
								 Unilite.messageBox(Msg.sMB154);//먼저 저장하십시오.
							} else {
									var param = panelResult.getValues();
									var win = Ext.create('widget.CrystalReport', {
										url: CPATH+'/sales/spp100cukrv.do',
										prgID: 'spp100ukrv',
										extParam: param
									});
									win.center();
									win.show();
							}
						}
					}, */{
					xtype	: 'button',
					text	: '견적확정',
					width	: 110,
					id		: 'CONFIRM',
					handler	: function(records, grid, record) {
						if(UniAppManager.app._needSave()) {
							 Unilite.messageBox(Msg.sMB154);//먼저 저장하십시오.
						} else {
							var me = this;
							var param= panelSearch.getValues();
							param.CONFIRM_DATE = UniDate.getDbDateStr(masterTable.getValue('CONFIRM_DATE'));
							param.ESTI_DATE = panelSearch.getValue('ESTI_DATE');
							param.ESTI_NUM = masterTable.getValue('ESTI_NUM');
							if(masterTable.getValue('CONFIRM_FLAG') =='1') {
								spp100ukrvService.confirmDataList(param, function(provider, response) {
									spp100ukrvService.selectConfirmFlag(param, function(provider2, response) {
										if(provider2[0].CONFIRM_FLAG == '1') {
											masterTable.setValues({'CONFIRM_FLAG': '1'});
											Ext.getCmp('CONFIRM').setText(Msg.sMS141);
										} else if(provider2[0].CONFIRM_FLAG == '2') {
											masterTable.setValues({'CONFIRM_FLAG': '2'});
											Ext.getCmp('CONFIRM').setText('확정취소');
										}
									})
									panelSearch.getEl().unmask();
									panelResult.getEl().unmask();
									panelSearch.getField('ESTI_TITLE').setReadOnly(true);
									panelResult.getField('ESTI_TITLE').setReadOnly(true);
									masterTable.getField('CUST_PRSN').setReadOnly(true);
									masterTable.getField('CONFIRM_DATE').setReadOnly(true);
									masterTable.getField('ESTI_PAYCONDI').setReadOnly(true);
									masterTable.getField('ESTI_VALIDTERM').setReadOnly(true);
									masterTable.getField('ESTI_DVRY_DATE').setReadOnly(true);
									masterTable.getField('ESTI_DVRY_PLCE').setReadOnly(true);
									masterTable.getField('REMARK').setReadOnly(true);
									Ext.getCmp('SUJU').setDisabled(false);
								});
								buttonClicked = true;
							} else if(masterTable.getValue('CONFIRM_FLAG') == '2') {
								if(confirm('견적진행로 바꾸시겠습니까?')) {
									spp100ukrvService.cancleDataList(param, function(provider, response) {
										spp100ukrvService.selectConfirmFlag(param, function(provider2, response) {
											if(provider2[0].CONFIRM_FLAG == '1') {
												masterTable.setValues({'CONFIRM_FLAG': '1'});
												Ext.getCmp('CONFIRM').setText(Msg.sMS141);
											} else if(provider2[0].CONFIRM_FLAG == '2') {
													masterTable.setValues({'CONFIRM_FLAG': '2'});
												Ext.getCmp('CONFIRM').setText('확정취소');
											}
										})
										panelSearch.getEl().unmask();
										panelResult.getEl().unmask();
										panelSearch.getField('ESTI_TITLE').setReadOnly(false);
										panelResult.getField('ESTI_TITLE').setReadOnly(false);
										masterTable.getField('CUST_PRSN').setReadOnly(false);
										masterTable.getField('CONFIRM_DATE').setReadOnly(false);
										masterTable.getField('ESTI_PAYCONDI').setReadOnly(false);
										masterTable.getField('ESTI_VALIDTERM').setReadOnly(false);
										masterTable.getField('ESTI_DVRY_DATE').setReadOnly(false);
										masterTable.getField('ESTI_DVRY_PLCE').setReadOnly(false);
										masterTable.getField('REMARK').setReadOnly(false);
										Ext.getCmp('SUJU').setDisabled(true);
									});
									buttonClicked = true;
								}
							}
						}
					}
				}]
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: '견적건명',
				name		: 'ESTI_TITLE',
				width		: 325 ,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ESTI_TITLE', newValue);
						masterTable.setValue('ESTI_TITLE', newValue);
					}
				}
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: 'TAX_TYPE',
				name		: 'TAX_INOUT',
				hidden		: true
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: 'ESTI_NUM',
				name		: 'ESTI_NUM',
				hidden		: true
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: 'DIV_CODE',
				name		: 'DIV_CODE',
				value		: UserInfo.divCode,
				hidden		: true
			}
		],
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
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
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
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me				= this;
			me.uniOpt.inLoading	= false;
			me.setAllFieldsReadOnly(true);
		}
	});

	var masterTable = Unilite.createSearchForm('masterTable', {			//createForm
		layout		: {type : 'uniTable', columns : 5},
		masterGrid	: mainGrid,
		disabled	: false,
		border		: true,
		padding		: '1 1 1 1',
		region		: 'center',
		items		: [{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'ESTI_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						masterTable.setValue('ESTI_TITLE'	, panelResult.getValue('ESTI_TITLE'));
						masterTable.setValue('ESTI_DATE'	, panelResult.getValue('ESTI_DATE'));
						masterTable.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
						masterTable.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
					}
				}
			},{
				xtype: 'component'
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: '견적요청자',
				name		: 'CUST_PRSN'
			},{
				xtype		: 'uniNumberfield',
				fieldLabel	: '정상판매가총액',
				name		: 'ESTI_AMT',
				value		: '0',
				readOnly	: true
			},{
				xtype: 'component'
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: '견적번호',
				name		: 'ESTI_NUM',
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ESTI_NUM', newValue);
					}
				}
			},{
				xtype: 'component'
			},
			Unilite.popup('REMARK_DISTRIBUTION',{
				fieldLabel		: '결재조건',
				textFieldName	: 'ESTI_PAYCONDI',
				validateBlank	: false,
				listeners		: {
					applyextparam: function(popup) {
						popup.setExtParam({'REMARK_TYPE': '11'});
					}
				}
			}),{
				xtype		: 'uniNumberfield',
				fieldLabel	: '견적총액',
				name		: 'ESTI_CFM_AMT',
				value		: '0',
				readOnly	: true
			},{
				xtype: 'component'
			},{
				fieldLabel	: '확정일',
				name		: 'CONFIRM_DATE',
				xtype		: 'uniDatefield',
				value		: new Date()
			},{
				xtype: 'component'
			},
			Unilite.popup('REMARK_DISTRIBUTION',{
				fieldLabel		: '유효기간',
				textFieldName	: 'ESTI_VALIDTERM',
				validateBlank	: false,
				listeners: {
					applyextparam: function(popup) {
						popup.setExtParam({'REMARK_TYPE': '12'});
					}
				}
			}),{
				xtype		: 'uniNumberfield',
				fieldLabel	: '총DC율',
				suffixTpl	: '&nbsp;%',
				name		: 'ESTI_TAX_AMT',
				value		: '0',
				readOnly	: true
			},{
				xtype: 'component'
			},{
				xtype		: 'uniCombobox',
				fieldLabel	: '확정유무',
				name		: 'CONFIRM_FLAG',
				store		: confirmTypeStore,
				value		: '1',
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue =='1') {
							UniAppManager.setToolbarButtons(['newData', 'deleteAll', 'delete'], true);
						}else{
							UniAppManager.setToolbarButtons(['newData', 'deleteAll', 'delete'], false);
						}
					}
				}
			},{
				xtype: 'component'
			},
			Unilite.popup('REMARK_DISTRIBUTION',{
				fieldLabel		: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
				textFieldName	: 'ESTI_DVRY_DATE',
				validateBlank	: false,
				listeners		: {
					applyextparam: function(popup) {
						popup.setExtParam({'REMARK_TYPE': '13'});
					}
				}
			}),{
				fieldLabel  : '<t:message code="system.label.sales.currency" default="화폐"/>',
				name		: 'EXCHG_MONEY_UNIT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B004',
				value		: BsaCodeInfo.gsMoneyUnit,
				displayField: 'value',
				fieldStyle	: 'text-align: center;',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.fnExchngRateO();
					}
				}
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				hidden			: true,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);
						panelResult.setValue('CUSTOM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							CustomCodeInfo.gsRefTaxInout= '';
							CustomCodeInfo.gsAgentType	= '';
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
							masterTable.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);
						panelResult.setValue('CUSTOM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							CustomCodeInfo.gsRefTaxInout= '';
							CustomCodeInfo.gsAgentType	= '';
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
							masterTable.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}),{
				xtype: 'component'
			},{
				xtype: 'component'
			},{
				xtype: 'component'
			},
			Unilite.popup('REMARK_DISTRIBUTION',{
				fieldLabel		: '납입장소',
				textFieldName	: 'ESTI_DVRY_PLCE',
				validateBlank	: false,
				listeners		: {
					applyextparam: function(popup) {
						popup.setExtParam({'REMARK_TYPE': '14'});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
				name		: 'EXCHANGE_RATE',
				xtype		: 'uniNumberfield',
				type		: 'uniER',
				decimalPrecision: 4,
				value		: 1,
				listeners	: {
//					blur : function (e, event, eOpts) {
//						if(panelSearch.getValue('EXCHANGE_RATE') != 0) {
//							panelSearch.down('#conversionApplied').enable();
//						} else {
//							panelSearch.down('#conversionApplied').disable();
//						}
//					}
				}
			},{
				fieldLabel	: '견적일',
				name		: 'ESTI_DATE',
				xtype		: 'uniDatefield',
				hidden		: true
			},{
				xtype: 'component'
			},{
				xtype: 'component'
			},{
				xtype: 'component'
			},
			Unilite.popup('REMARK_DISTRIBUTION',{
				fieldLabel		: '특기사항',
				textFieldName	: 'REMARK',
				validateBlank	: false,
				listeners		: {
					applyextparam: function(popup) {
						popup.setExtParam({'REMARK_TYPE': '16'});
					}
				}
			}),{
				xtype		: 'uniTextfield',
				fieldLabel	: '견적건명',
				name		: 'ESTI_TITLE',
				hidden		: true
			},{
				xtype		: 'uniNumberfield',
				fieldLabel	: 'PROFIT_RATE',
				value		: '1',
				name		: 'PROFIT_RATE',
				hidden		: true
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: 'COMP_CODE',
				name		: 'COMP_CODE'  ,
				hidden		: true
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: 'DIV_CODE',
				name		: 'DIV_CODE'   ,
				value		: UserInfo.divCode,
				hidden		: true
			},{
				xtype		: 'uniNumberfield',
				fieldLabel	: 'ESTI_EX_AMT',
				value		: '1',
				name		: 'ESTI_EX_AMT',
				hidden		: true
			},{
				xtype		: 'uniNumberfield',
				fieldLabel	: 'ESTI_CFM_TAX_AMT',
				value		: '1',
				name		: 'ESTI_CFM_TAX_AMT',
				hidden		: true
			},{
				xtype		: 'uniNumberfield',
				fieldLabel	: 'ESTI_CFM_EX_AMT',
				value		: '1',
				name		: 'ESTI_CFM_EX_AMT',
				hidden		: true
			}
		],
		api: {
			load	: 'spp100ukrvService.selectMaster',
			submit	: 'spp100ukrvService.saveMaster'
		},
		listeners : {
//			uniOnChange:function( masterTable, dirty, eOpts ) {
//				console.log("onDirtyChange");
//				if(masterTable.isDirty()) {
//					UniAppManager.setToolbarButtons('save', true);
//				}else {
//					UniAppManager.setToolbarButtons('save', false);
//				}
//			}
		},
		loadForm: function(record) {
	 		// window 오픈시 form에 Data load
			this.reset();
			this.setActiveRecord(record || null);
			this.resetDirtyStatus();
		},
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
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
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
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {	// 검색 팝업창
		layout			: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items			: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			holdable	: 'hold',
			child		: 'WH_CODE'
		},{
			fieldLabel		: '견적기간',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ESTI_DATE_FR',
			endFieldName	: 'ESTI_DATE_TO',
			width			: 350,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: panelResult.getValue('ESTI_DATE'),
			colspan			: 2
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					
					if(!Ext.isObject(oldValue)) {
						orderNoSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderNoSearch.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'  ,
			name		: 'ESTI_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010'
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '견적상태',
			id			: 'rdo1',
			labelWidth	: 90,
			items		: [{
				boxLabel	: '전체',
				name		: 'CONFIRM_FLAG',
				inputValue	: '',
				width		: 70,
				checked		: true
			},{
				boxLabel	: '미확정',
				name		: 'CONFIRM_FLAG',
				inputValue	: '1',
				width		: 70
			},{
				boxLabel	: '확정',
				name		: 'CONFIRM_FLAG' ,
				inputValue	: '2',
				width		: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if (orderNoSearch.getField('RDO_TYPE').getChecked()[0].inputValue == 'detail') {
						orderNoDetailStore.loadStoreRecords(newValue);
					} else {
						orderNoMasterStore.loadStoreRecords(newValue);
					}
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderNoSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderNoSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup) {
					popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			xtype		: 'uniTextfield',
			fieldLabel	: '견적건명',
			name		: 'ESTI_TITLE',
			width		: 325
		},{
			fieldLabel	: '조회구분',
			xtype		: 'uniRadiogroup',
			width		: 235,
			name		: 'RDO_TYPE',
			items		: [{
				boxLabel	: '마스터',
				name		: 'RDO_TYPE',
				inputValue	: 'master',
				checked		: true
			},{
				boxLabel	: '디테일',
				name		: 'RDO_TYPE',
				inputValue	: 'detail'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if (newValue.RDO_TYPE == 'detail') {
						if (orderNoMasterGrid) orderNoMasterGrid.hide();
						if (orderNoDetailGrid) orderNoDetailGrid.show();
					} else {
						if (orderNoDetailGrid) orderNoDetailGrid.hide();
						if (orderNoMasterGrid) orderNoMasterGrid.show();
					}
				}
			}
		}]
	});

	var otherOrderSearch = Unilite.createSearchForm('otherorderForm', {	//이동출고 참조
		layout	: {type : 'uniTable', columns : 3},
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
			name		: 'ITEM_LEVEL1',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
			child		: 'ITEM_LEVEL2'
		},{
			fieldLabel		: '견적일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ESTI_DATE_FR',
			endFieldName	: 'ESTI_DATE_TO',
			colspan			: 2,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		},{
			fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
			name		: 'ITEM_LEVEL2',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
			child		: 'ITEM_LEVEL3'
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						otherOrderSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						otherOrderSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup) {
					popup.setExtParam({'DIV_CODE': UserInfo.divCode});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'  ,
			name		: 'TXT_INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010'
		},{
			fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
			name		: 'ITEM_LEVEL3',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
			parentNames	: ['ITEM_LEVEL1','ITEM_LEVEL2'],
			levelType	: 'ITEM'
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					
					if(!Ext.isObject(oldValue)) {
						otherOrderSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						otherOrderSearch.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
			xtype		: 'uniTextfield',
			fieldLabel	: '견적건명',
			name		: 'ESTI_TITLE',
			width		: 325
		}]
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('spp100ukrvModel', {					// 메인
		fields: [
			{name: 'ESTI_NUM'				,text: '견적번호'			,type: 'string', hidden: true},
			{name: 'ESTI_SEQ'				,text: '<t:message code="system.label.sales.seq" default="순번"/>'				,type: 'int'},
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>'				,type: 'string'/* , allowBlank: false */ },
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'/* , allowBlank: false */},
			{name: 'SPEC'					,text: '<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},
			{name: 'STOCK_UNIT'				,text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'	,type: 'string', displayField: 'value'},
			{name: 'ESTI_UNIT'				,text: '견적단위'			,type: 'string', comboType: 'AU', comboCode: 'B013', allowBlank: false, displayField: 'value'},
			{name: 'TRANS_RATE'				,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'		,type: 'uniER', allowBlank: false},
			{name: 'ESTI_QTY'				,text: '견적수량'			,type: 'uniQty', allowBlank: false},
			{name: 'ESTI_PRICE'				,text: '정상판매가'			,type: 'uniPrice', allowBlank: false},
			{name: 'ESTI_AMT'				,text: '정상판매액'			,type: 'uniPrice', allowBlank: false},
			{name: 'ESTI_CFM_PRICE'			,text: '견적단가'			,type: 'uniUnitPrice'},
			{name: 'ESTI_CFM_AMT'			,text: '견적금액'			,type: 'uniPrice'},
			{name: 'TAX_TYPE'				,text: '<t:message code="system.label.sales.taxationyn" default="과세여부"/>'		,type: 'string', comboType: 'AU', comboCode: 'B059', allowBlank: false},
			{name: 'ESTI_TAX_AMT'			,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'			,type: 'uniPrice'},
			{name: 'PROFIT_RATE'			,text: 'DC율(%)'			,type: 'float', decimalPrecision:2, format:'0,000.00'},
			{name: 'ORDER_Q'				,text: 'ORDER_Q'		,type: 'uniQty', hidden: true},
			{name: 'REF_FLAG'				,text: 'REF_FLAG'		,type: 'string'},
			{name: 'ESTI_EX_AMT'			,text: 'ESTI_EX_AMT'	,type: 'uniPrice', hidden: true},
			{name: 'ESTI_CFM_EX_PRICE'		,text: '단가(자사)'			,type: 'uniPrice'},
			{name: 'ESTI_CFM_EX_AMT'		,text: '금액(자사)'			,type: 'uniPrice'},
			{name: 'ESTI_CFM_TAX_AMT'		,text: '세액(자사)'			,type: 'uniPrice'},
			{name: 'CUSTOM_CODE'			,text: 'CUSTOM_CODE'	,type: 'string'},
			{name: 'CUSTOM_NAME'			,text: 'CUSTOM_NAME'	,type: 'string'},
			{name: 'UPDATE_DB_USER'			,text: 'UPDATE_DB_USER'	,type: 'string'},
			{name: 'UPDATE_DB_TIME'			,text: 'UPDATE_DB_TIME'	,type: 'uniDate'},
			{name: 'REF_NUM'				,text: 'REF_NUM'		,type: 'string'},
			{name: 'REF_SEQ'				,text: 'REF_SEQ'		,type: 'string'},
			{name: 'ESTI_PRSN'				,text: 'ESTI_PRSN'		,type: 'string'},
			{name: 'WH_CODE'				,text: 'WH_CODE'		,type: 'string'},
			{name: 'STOCK_CARE_YN'			,text: 'STOCK_CARE_YN'	,type: 'string'},
			{name: 'ITEM_ACCOUNT'			,text: 'ITEM_ACCOUNT'	,type: 'string'},
			//20200515 추가: 창고, 재고수량
			{name: 'WH_CODE'				,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'			,type: 'string', comboType : 'OU', editable: false},
			{name: 'STOCK_Q'				,text:'<t:message code="system.label.sales.inventoryqty2" default="재고수량"/>'		,type:'uniQty', editable: false},
			//20200519 추가
			{name: 'DIV_CODE'				,text: '사업장'		,type: 'string'},
			{name: 'FAX_YN'					,text: '<t:message code="system.label.purchase.sendyn" default="전송여부"/>'		,type: 'string'},
			//20210721추가: 비고
			{name: 'REMARK'					,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'}
		]
	});

	Unilite.defineModel('orderNoMasterModel', {					// 마스터검색팝업창
		fields: [
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'		,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'	,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'		,type: 'string'},
			{name: 'ESTI_DATE'		,text: '견적일'		,type: 'uniDate'},
			{name: 'ESTI_QTY'		,text: '견적량'		,type: 'uniQty'},
			{name: 'ESTI_PRSN'		,text: '<t:message code="system.label.sales.charger" default="담당자"/>'	,type: 'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'ESTI_NUM'		,text: '견적번호'		,type: 'string'},
			{name: 'ESTI_TITLE'		,text: '견적건명'		,type: 'string'},
			{name: 'CONFIRM_FLAG'	,text: '상태'			,type: 'string',store:Ext.StoreManager.lookup('confirmTypeStore') },
			{name: 'CUSTOM_CODE'	,text: '거래처코드'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '거래처명'		,type: 'string'},
			{name: 'DIV_CODE'		,text: '사업장'		,type: 'string'},
			{name: 'ESTI_AMT'		,text: '견적총액'		,type: 'uniPrice'},
			{name: 'PROFIT_RATE'	,text: 'DC율(%)'		,type: 'float', decimalPrecision:2, format:'0,000.00'}
		]
	});

	Unilite.defineModel('orderNoDetailModel', {					// 디테일검색팝업창
		fields: [
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},
			{name: 'ESTI_DATE'		,text: '견적일'		,type: 'uniDate'},
			{name: 'ESTI_QTY'		,text: '견적량'		,type: 'uniQty'},
			{name: 'ESTI_PRSN'		,text: '<t:message code="system.label.sales.charger" default="담당자"/>'		,type: 'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'ESTI_NUM'		,text: '견적번호'		,type: 'string'},
			{name: 'ESTI_TITLE'		,text: '견적건명'		,type: 'string'},
			{name: 'CONFIRM_FLAG'	,text: '상태'			,type: 'string',store:Ext.StoreManager.lookup('confirmTypeStore')},
			{name: 'CUSTOM_CODE'	,text: '거래처코드'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '거래처명'		,type: 'string'},
			{name: 'DIV_CODE'		,text: '사업장'		,type: 'string'}
		]
	});

	Unilite.defineModel('spp100ukrvOTHERModel', {				// 참조
		fields: [
			{name: 'CHOICE'				,text: '<t:message code="system.label.sales.selection" default="선택"/>'			,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'				,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'	,type: 'string', displayField: 'value'},
			{name: 'ESTI_UNIT'			,text: '견적단위'			,type: 'string'},
			{name: 'TRANS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'		,type: 'uniER'},
			{name: 'ESTI_QTY'			,text: '견적수량'			,type: 'uniQty'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.client" default="고객"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'		,type: 'string'},
			{name: 'ESTI_PRSN'			,text: '담당자'			, comboType: 'AU', comboCode: 'S010' ,type: 'string'},
			{name: 'ESTI_DATE'			,text: '견적일'			,type: 'uniDate'},
			{name: 'ESTI_NUM'			,text: '견적번호'			,type: 'string'},
			{name: 'ESTI_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'				,type: 'int'},
			{name: 'ESTI_CFM_PRICE'		,text: '견적단가'			,type: 'uniUnitPrice'},
			{name: 'ESTI_PRICE'			,text: '<t:message code="system.label.sales.price" default="단가"/>'				,type: 'uniUnitPrice'},
			{name: 'ESTI_AMT'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'},
			{name: 'ESTI_CFM_AMT'		,text: '확정금액'			,type: 'uniPrice'},
			{name: 'ESTI_TAX_AMT'		,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'			,type: 'uniPrice'},
			{name: 'TAX_TYPE'			,text: '<t:message code="system.label.sales.taxationyn" default="과세여부"/>'		,type: 'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'PROFIT_RATE'		,text: '이익율'			,type: 'uniUnitPrice'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'},
			{name: 'REF_FLAG'			,text: 'FLAG'			,type: 'string'},
			{name: 'ITEM_LEVEL1'		,text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'		,type: 'string'},
			{name: 'ITEM_LEVEL2'		,text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'		,type: 'string'},
			{name: 'ITEM_LEVEL3'		,text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'		,type: 'string'},
			{name: 'ESTI_EX_AMT'		,text: '예상금액'			,type: 'uniPrice'},
			{name: 'ESTI_CFM_EX_AMT'	,text: '예상확정금액'			,type: 'uniPrice'},
			{name: 'ESTI_CFM_TAX_AMT'	,text: '예상확정세액'			,type: 'uniPrice'},
			{name: 'CONFIRM_FLAG'		,text: '확정유무'			,type: 'string'},
			{name: 'SORT'				,text: 'SORT'			,type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: 'ITEM_ACCOUNT'	,type: 'string'},
			//20200515 추가: 창고, 재고수량
			{name: 'WH_CODE'			,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'			,type: 'string', comboType : 'OU', editable: false},
			{name: 'STOCK_Q'			,text: '<t:message code="system.label.sales.inventoryqty2" default="재고수량"/>'	,type: 'uniQty', editable: false}
		]
	});

	var detailStore = Unilite.createStore('spp100ukrvMasterStore1',{		// 메인
		model: 'spp100ukrvModel',
		uniOpt : {
			isMaster: false,	 // 상위 버튼 연결
			editable: true,	 // 수정 모드 사용
			deletable: true,	// 삭제 가능 여부
			useNavi : false	 // prev | Next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= masterTable.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					//useSavedMessage : false,
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						if(detailStore.getCount() == 0) {
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(store.count() > 1){
					detailGrid.down('#btnFaxSend').setDisabled(false);
				}
			}
			,update : function( store, record, operation, modifiedFieldNames, details, eOpts ) {
				if( detailStore.isDirty() || store.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	// 검색 팝업창
		model: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			 // prev | Next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'spp100ukrvService.selectList2'
			}
		},
		loadStoreRecords: function(newValue) {
			var param= orderNoSearch.getValues();
			if(!Ext.isEmpty(newValue.CONFIRM_FLAG) || newValue.CONFIRM_FLAG == '') {
				param.CONFIRM_FLAG = newValue.CONFIRM_FLAG;
			}else{
				param.CONFIRM_FLAG = newValue;
			}
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	var orderNoDetailStore = Unilite.createStore('orderNoDeteilStore', {	// 검색 팝업창
		model: 'orderNoDetailModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			 // prev | Next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'spp100ukrvService.selectList4'
			}
		},
		loadStoreRecords: function(newValue) {
			var param= orderNoSearch.getValues();
			if(!Ext.isEmpty(newValue.CONFIRM_FLAG) || newValue.CONFIRM_FLAG == '') {
				param.CONFIRM_FLAG = newValue.CONFIRM_FLAG;
			}else{
				param.CONFIRM_FLAG = newValue;
			}
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	var otherOrderStore = Unilite.createStore('spp100ukrvOtherOrderStore', {	// 참조
		model: 'spp100ukrvOTHERModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			 // prev | Next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'spp100ukrvService.selectList3'
			}
		},
		loadStoreRecords : function()   {
			var param= otherOrderSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/** Grid1 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('spp100ukrvGrid', {		// 메인
		layout : 'fit',
		region:'center',
		store : detailStore,
		uniOpt: {
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: true,
			useMultipleSorting	: true
		},
		tbar: [{
			        xtype: 'button',
					text: '<div style="color: blue">FAX전송</div>',
					itemId: 'btnFaxSend',
					hidden: gsFaxBtnHidden,
					disabled: true,
					handler: function() {
						//var params = detailStore.data.items;
						detailGrid.faxBtn();
					}
				},{
			        xtype: 'button',
					text: '<div style="color: blue">수주등록</div>',
					id: 'SUJU',
					handler: function() {
						//var params = detailStore.data.items;
						detailGrid.gotoSof100();
					}
				},{
					xtype: 'button',
					text: '<div style="color: blue">타견적 참조</div>',
					handler: function() {
						openEstimateWindow();
					}
				}],
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary',		 showSummaryRow: false}
		],
		store: detailStore,
		columns: [
			{ dataIndex: 'DIV_CODE'			, width: 80, hidden: true},		//20200519 추가
			{ dataIndex: 'ESTI_NUM'			, width: 80, hidden: true},
			{ dataIndex: 'ESTI_SEQ'			, width: 33, hidden: true},
			{ dataIndex: 'ITEM_CODE'		, width: 100,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {DIV_CODE: '01',SELMODEL: 'MULTI'},
					autoPopup: true,
					 //validateBlank	: true ,
					listeners: {'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
										if(i==0) {
											detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
										} else {
											UniAppManager.app.onNewDataButtonDown();
											detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
										}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 200,
					editor: Unilite.popup('DIV_PUMOK_G', {
						autoPopup: true,
						extParam: {DIV_CODE: '01'},
						 //validateBlank	: true ,
							listeners: {'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
												if(i==0) {
													detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
												 } else {
													UniAppManager.app.onNewDataButtonDown();
													detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
												 }
										});
									},
									scope: this
								},
								'onClear': function(type) {
									detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
								}
							}
					})
			},
			{ dataIndex: 'SPEC'				, width: 120},
			{ dataIndex: 'STOCK_UNIT'		, width: 100, hidden: true},
			{ dataIndex: 'ESTI_UNIT'		, width: 80, align: 'center'},
			{ dataIndex: 'TRANS_RATE'		, width: 80},
			{ dataIndex: 'ESTI_QTY'			, width: 106},
			{ dataIndex: 'ESTI_PRICE'		, width: 120},
			{ dataIndex: 'ESTI_AMT'			, width: 120},
			{ dataIndex: 'ESTI_CFM_PRICE'	, width: 120},
			{ dataIndex: 'ESTI_CFM_AMT'		, width: 120},
			{ dataIndex: 'TAX_TYPE'			, width: 80, align: 'center'},
			{ dataIndex: 'ESTI_TAX_AMT'		, width: 100},
			{ dataIndex: 'PROFIT_RATE'		, width: 100},
			{ dataIndex: 'ESTI_CFM_EX_PRICE', width: 100},
			{ dataIndex: 'ESTI_CFM_EX_AMT'	, width: 100},
			{ dataIndex: 'ESTI_CFM_TAX_AMT'	, width: 100},
			{ dataIndex: 'ORDER_Q'			, width: 66, hidden: true},
			{ dataIndex: 'REF_FLAG'			, width: 66, hidden: true},
			{ dataIndex: 'ESTI_EX_AMT'		, width: 100, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'		, width: 60, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 60, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'	, width: 66, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'	, width: 66, hidden: true},
			{ dataIndex: 'REF_NUM'			, width: 60, hidden: true},
			{ dataIndex: 'REF_SEQ'			, width: 60, hidden: true},
			{ dataIndex: 'ESTI_PRSN'		, width: 60, hidden: true},
			{ dataIndex: 'WH_CODE'			, width: 60, hidden: true},
			{ dataIndex: 'STOCK_CARE_YN'	, width: 60, hidden: true},
			{ dataIndex: 'ITEM_ACCOUNT'		, width: 60, hidden: true},
			//20200515 추가: 창고, 재고수량
			{ dataIndex: 'WH_CODE'			, width: 150, hidden: true},
			{ dataIndex: 'STOCK_Q'			, width: 106, hidden: true},
			{ dataIndex: 'FAX_YN'			, width: 106, hidden: gsFaxBtnHidden},
			//20210721추가: 비고
			{ dataIndex: 'REMARK'			, width: 250}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				 if(masterTable.getValue('CONFIRM_FLAG') == '1') {
					if(!e.record.phantom) {
						 if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'SPEC', 'ESTI_UNIT', 'TRANS_RATE', 'ESTI_TAX_AMT']))
						{
							return false;
						} else {
							return true;
						}
					} else {
						if(UniUtils.indexOf(e.field, ['SPEC', 'ESTI_TAX_AMT']))
						{
							return false;
						} else {
							return true;
						}
					}
				} else {
					if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'SPEC', 'ESTI_UNIT', 'TRANS_RATE', 'ESTI_QTY', 'ESTI_PRICE', 'ESTI_AMT'
												 ,'ESTI_CFM_PRICE', 'ESTI_CFM_AMT', 'TAX_TYPE', 'ESTI_TAX_AMT', 'PROFIT_RATE'   ])) {
						return false;
					}
				}
			}
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'			, '');
				grdRecord.set('ITEM_NAME'			, '');
				grdRecord.set('STOCK_UNIT'			, '');
				grdRecord.set('ESTI_UNIT'			, '');
				grdRecord.set('TRANS_RATE'			, '');
				grdRecord.set('ESTI_PRICE'			, '');
				grdRecord.set('ESTI_CFM_PRICE'		, '');
				grdRecord.set('ESTI_QTY'			, '');
				grdRecord.set('ESTI_AMT'			, '');
				//20200519 추가: WH_CODE, STOCK_Q
				grdRecord.set('WH_CODE'				, '');
				grdRecord.set('STOCK_Q'				, 0);
			} else {
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('ESTI_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('TRANS_RATE'			, record['TRNS_RATE']);
				UniSales.fnGetPriceInfo2(grdRecord, UniAppManager.app.cbGetPriceInfo
													, 'I'
													, UserInfo.compCode
													, panelResult.getValue('CUSTOM_CODE')
													, CustomCodeInfo.gsAgentType
													, grdRecord.get('ITEM_CODE')
													, BsaCodeInfo.gsMoneyUnit
													, grdRecord.get('ESTI_UNIT')
													, grdRecord.get('STOCK_UNIT')
													, grdRecord.get('TRANS_RATE')
													, UniDate.getDbDateStr(panelResult.getValue('ESTI_DATE'))
													, grdRecord.get('ESTI_QTY')
													, ''
													, ''
													, ''
													, ''
													, ''
													);
				grdRecord.set('ESTI_QTY'			, '0');
				grdRecord.set('ESTI_AMT'			, '0');
				//20200515 추가: WH_CODE, STOCK_Q
				grdRecord.set('WH_CODE'			, record['WH_CODE']);
				grdRecord.set('STOCK_Q'			, record['BIV150_G_STOCK_Q']);
			}
		},
		setEstiData: function(record) {					// 참조 셋팅
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('COMP_CODE'		, UserInfo.compCode);
			grdRecord.set('ESTI_NUM'		, masterTable.getValue('ESTI_NUM'));
			grdRecord.set('REF_SEQ'			, record['REF_SEQ']);
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('ESTI_UNIT'		, record['ESTI_UNIT']);
			grdRecord.set('TRANS_RATE'		, record['TRANS_RATE']);
			grdRecord.set('ESTI_QTY'		, record['ESTI_QTY']);
			grdRecord.set('ESTI_PRICE'		, record['ESTI_PRICE']);
			grdRecord.set('ESTI_AMT'		, record['ESTI_AMT']);
			grdRecord.set('ESTI_EX_AMT'		, record['ESTI_EX_AMT']);
			grdRecord.set('ESTI_CFM_PRICE'	, record['ESTI_CFM_PRICE']);
			grdRecord.set('ESTI_CFM_AMT'	, record['ESTI_CFM_AMT']);
			grdRecord.set('ESTI_CFM_EX_PRICE', record['ESTI_CFM_EX_PRICE']);
			grdRecord.set('ESTI_CFM_EX_AMT'	, record['ESTI_CFM_EX_AMT']);
			grdRecord.set('ESTI_TAX_AMT'	, record['ESTI_TAX_AMT']);
			grdRecord.set('ESTI_CFM_TAX_AMT', record['ESTI_CFM_TAX_AMT']);
			grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);
			grdRecord.set('PROFIT_RATE'		, record['PROFIT_RATE']);
			grdRecord.set('ORDER_Q'			, record['ORDER_Q']);
			grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
			grdRecord.set('REF_FLAG'		, 'Y');
			//20200515 추가: WH_CODE, STOCK_Q
			grdRecord.set('WH_CODE'			, record['WH_CODE']);
			grdRecord.set('STOCK_Q'			, record['STOCK_Q']);
		},
		gotoSof100:function() {
			if(detailStore.getCount() != 0) {
				/* var linkParams = record;
				linkParams.PGM_ID = 'spp100ukrv';
				linkParams.action = 'new'; */
				var params = {
						action		: 'new',
						'PGM_ID'	: 'spp100ukrv',
						'record'	: detailStore.data.items,
						'ESTI_PRSN' : masterTable.getValue('ESTI_PRSN'),
						'formPram'	: panelResult.getValues()
					}
				var rec = {data : {prgID : 'sof100ukrv', 'text':''}};
				parent.openTab(rec, '/sales/sof100ukrv.do', params);
			}
		},
        faxBtn:function(record){
				if(Ext.isEmpty(panelResult.getValue('ESTI_NUM'))) {
				return false
				} // 필수체크

				var win;
				var param = panelResult.getValues();
				param["FAX_URL"] = CPATH+'/sales/spp100clukrv_fax.do'
				param["REF_VAL_1"] = masterTable.getValue('ESTI_NUM');
				param.PGM_ID = PGM_ID;  //프로그램ID
		 		param.MAIN_CODE = 'S036'
				win = Ext.create('widget.ClipReportFax',{
					url: CPATH+'/sales/spp100clukrv.do',
					prgID: 'spp100ukrv',
					extParam: param
					});
				win.center();
				win.show();
        }
	});

	var orderNoMasterGrid = Unilite.createGrid('spp100ukrvOrderNoMasterGrid', {	// 검색팝업창
		// title: '기본',
		layout : 'fit',
		store: orderNoMasterStore,
		uniOpt:{
			useRowNumberer: true
		},
		columns:  [
			{ dataIndex: 'CUSTOM_CODE'		, width: 100, hidden:true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 100},
			{ dataIndex: 'ESTI_TITLE'		, width: 100},
			{ dataIndex: 'ESTI_DATE'		, width: 80},
			{ dataIndex: 'ESTI_PRSN'		, width: 80},
			{ dataIndex: 'ESTI_NUM'			, width: 100},
			{ dataIndex: 'ESTI_AMT'			, width: 100},
			{ dataIndex: 'PROFIT_RATE'		, width: 100},
			{ dataIndex: 'ITEM_CODE'		, width: 100, hidden:true},
			{ dataIndex: 'ITEM_NAME'		, width: 150, hidden:true},
			{ dataIndex: 'SPEC'				, width: 150, hidden:true},
			{ dataIndex: 'ESTI_QTY'			, width: 80, hidden:true},
			{ dataIndex: 'CONFIRM_FLAG'		, width: 80}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
//				if(record.data['CONFIRM_FLAG'] == '1') {
//					Ext.getCmp('CONFIRM').setDisabled(false);
//				}else{
//					Ext.getCmp('CONFIRM').setDisabled(true);
//				}

				var param= orderNoSearch.getValues();
				param.ESTI_NUM	 = record.data['ESTI_NUM']
				param.CUSTOM_CODE  = record.data['CUSTOM_CODE']
				param.ESTI_DATE	= UniDate.getDbDateStr(record.data['ESTI_DATE'])
				masterTable.uniOpt.inLoading = true;
				//Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
				masterTable.getForm().load({
					params: param,
					success:function() {
						orderNoMasterGrid.returnData(record);
						masterTable.setValue('CONFIRM_FLAG',record.data.CONFIRM_FLAG);
						spp100ukrvService.selectCustomCode(param,
							function(provider, response) {
								if(!Ext.isEmpty(provider)) {
									panelSearch.setValue('TAX_INOUT', provider.data.TAX_TYPE);
									panelResult.setValue('TAX_INOUT', provider.data.TAX_TYPE);
									CustomCodeInfo.gsWonCalcBas = provider.data.WON_CALC_BAS;
								}
							}
						)
						masterTable.uniOpt.inLoading=false;
						UniAppManager.setToolbarButtons('save', false)
						detailStore.loadStoreRecords();
						Ext.getCmp('CONFIRM').setDisabled(false);
						if(masterTable.getValue('CONFIRM_FLAG') == '1') {
							Ext.getCmp('SUJU').setDisabled(true);
							Ext.getCmp('CONFIRM').setText(Msg.sMS141);
						} else {
							Ext.getCmp('SUJU').setDisabled(false);
							Ext.getCmp('CONFIRM').setText('확정취소');
						}
						masterTable.getField('ESTI_AMT').focus();
						masterTable.getField('ESTI_AMT').blur();
						mainGrid.getStore().commitChanges();
						masterTable.resetDirtyStatus();
					},
					failure: function(form, action) {
						masterTable.uniOpt.inLoading=false;
					}
				});
				UniAppManager.setToolbarButtons(['print','delete'], true);
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record)   {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelSearch.setValues({'CUSTOM_CODE':record.get('CUSTOM_CODE')});
			panelSearch.setValues({'CUSTOM_NAME':record.get('CUSTOM_NAME')});
			panelSearch.setValues({'ESTI_DATE':record.get('ESTI_DATE')});
			panelSearch.setValues({'ESTI_TITLE':record.get('ESTI_TITLE')});
			panelResult.setValues({'CUSTOM_CODE':record.get('CUSTOM_CODE')});
			panelResult.setValues({'CUSTOM_NAME':record.get('CUSTOM_NAME')});
			panelResult.setValues({'ESTI_DATE':record.get('ESTI_DATE')});
			panelResult.setValues({'ESTI_TITLE':record.get('ESTI_TITLE')});
//			if(record.get('CONFIRM_FLAG') == '1') {
//				masterTable.setValues({'CONFIRM_FLAG': Msg.sMS140});
//				Ext.getCmp('CONFIRM').setText(Msg.sMS141);
//			} else {
//				masterTable.setValues({'CONFIRM_FLAG': Msg.sMS141});
//				Ext.getCmp('CONFIRM').setText(Msg.sMS140);
//			}

			panelSearch.getField('CUSTOM_CODE').setReadOnly(true);
			panelSearch.getField('CUSTOM_NAME').setReadOnly(true);
			panelSearch.getField('ESTI_DATE').setReadOnly(true);
			panelResult.getField('CUSTOM_CODE').setReadOnly(true);
			panelResult.getField('CUSTOM_NAME').setReadOnly(true);
			panelResult.getField('ESTI_DATE').setReadOnly(true);
			masterTable.getField('ESTI_PRSN').setReadOnly(true);
		}
	});

	var orderNoDetailGrid = Unilite.createGrid('spp100ukrvOrderNoDetailGrid', {	// 검색팝업창
		// title: '기본',
		layout : 'fit',
		store: orderNoDetailStore,
		uniOpt:{
			useRowNumberer: true
		},
		columns:  [
			{ dataIndex: 'CUSTOM_CODE'		, width: 100, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 100},
			{ dataIndex: 'ESTI_TITLE'		, width: 100},
			{ dataIndex: 'ITEM_CODE'		, width: 100},
			{ dataIndex: 'ITEM_NAME'		, width: 150},
			{ dataIndex: 'SPEC'				, width: 150},
			{ dataIndex: 'ESTI_DATE'		, width: 80},
			{ dataIndex: 'ESTI_QTY'			, width: 80},
			{ dataIndex: 'ESTI_PRSN'		, width: 80},
			{ dataIndex: 'ESTI_NUM'			, width: 100},
			{ dataIndex: 'CONFIRM_FLAG'		, width: 80}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
//			if(record.data['CONFIRM_FLAG'] == '1') {
//				Ext.getCmp('CONFIRM').setDisabled(false);
//			}else{
//				Ext.getCmp('CONFIRM').setDisabled(true);
//			}
				var param= orderNoSearch.getValues();
				param.ESTI_NUM	 = record.data['ESTI_NUM']
				param.CUSTOM_CODE  = record.data['CUSTOM_CODE']
				param.ESTI_DATE	= UniDate.getDbDateStr(record.data['ESTI_DATE'])
				masterTable.uniOpt.inLoading = true;
				//Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
				masterTable.getForm().load({
					params: param,
					success:function() {
						orderNoMasterGrid.returnData(record);
						masterTable.setValue('CONFIRM_FLAG',record.data.CONFIRM_FLAG);
						spp100ukrvService.selectCustomCode(param,
							function(provider, response) {
								if(!Ext.isEmpty(provider)) {
									panelSearch.setValue('TAX_INOUT', provider.data.TAX_TYPE);
									panelResult.setValue('TAX_INOUT', provider.data.TAX_TYPE);
									CustomCodeInfo.gsWonCalcBas = provider.data.WON_CALC_BAS;
								}
							}
						)
						masterTable.uniOpt.inLoading=false;
						UniAppManager.setToolbarButtons('save', false)
						detailStore.loadStoreRecords();
						Ext.getCmp('CONFIRM').setDisabled(false);
						if(masterTable.getValue('CONFIRM_FLAG') == '1') {
							Ext.getCmp('SUJU').setDisabled(true);
							Ext.getCmp('CONFIRM').setText(Msg.sMS141);
						} else {
							Ext.getCmp('SUJU').setDisabled(false);
							Ext.getCmp('CONFIRM').setText('확정취소');
						}
						masterTable.getField('ESTI_AMT').focus();
						masterTable.getField('ESTI_AMT').blur();
						mainGrid.getStore().commitChanges();
						masterTable.resetDirtyStatus();
					},
					failure: function(form, action) {
						masterTable.uniOpt.inLoading=false;
					}
				});
				UniAppManager.setToolbarButtons(['print','delete'], true);
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record)   {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelSearch.setValues({'CUSTOM_CODE':record.get('CUSTOM_CODE')});
			panelSearch.setValues({'CUSTOM_NAME':record.get('CUSTOM_NAME')});
			panelSearch.setValues({'ESTI_DATE':record.get('ESTI_DATE')});
			panelSearch.setValues({'ESTI_TITLE':record.get('ESTI_TITLE')});
			panelResult.setValues({'CUSTOM_CODE':record.get('CUSTOM_CODE')});
			panelResult.setValues({'CUSTOM_NAME':record.get('CUSTOM_NAME')});
			panelResult.setValues({'ESTI_DATE':record.get('ESTI_DATE')});
			panelResult.setValues({'ESTI_TITLE':record.get('ESTI_TITLE')});
//			if(record.get('CONFIRM_FLAG') == '1') {
//				masterTable.setValues({'CONFIRM_FLAG': Msg.sMS140});
//				Ext.getCmp('CONFIRM').setText(Msg.sMS141);
//			} else {
//				masterTable.setValues({'CONFIRM_FLAG': Msg.sMS141});
//				Ext.getCmp('CONFIRM').setText(Msg.sMS140);
//			}

			panelSearch.getField('CUSTOM_CODE').setReadOnly(true);
			panelSearch.getField('CUSTOM_NAME').setReadOnly(true);
			panelSearch.getField('ESTI_DATE').setReadOnly(true);
			panelResult.getField('CUSTOM_CODE').setReadOnly(true);
			panelResult.getField('CUSTOM_NAME').setReadOnly(true);
			panelResult.getField('ESTI_DATE').setReadOnly(true);
			masterTable.getField('ESTI_PRSN').setReadOnly(true);
		}
	});

	var otherOrderGrid = Unilite.createGrid('spp100ukrvOtherOrderGrid', {		//타견적 참조
		store: otherOrderStore,
		layout : 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns: [
//			{ dataIndex: 'CHOICE'				, width: 33 },
			{ dataIndex: 'ITEM_CODE'			, width: 100 },
			{ dataIndex: 'ITEM_NAME'			, width: 130 },
			{ dataIndex: 'SPEC'					, width: 106 },
			{ dataIndex: 'STOCK_UNIT'			, width: 60, hidden: true },
			{ dataIndex: 'ESTI_UNIT'			, width: 80, align: 'center' },
			{ dataIndex: 'TRANS_RATE'			, width: 73 },
			{ dataIndex: 'ESTI_QTY'				, width: 100 },
			{ dataIndex: 'CUSTOM_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'CUSTOM_NAME'			, width: 100 },
			{ dataIndex: 'ESTI_PRSN'			, width: 70 },
			{ dataIndex: 'ESTI_DATE'			, width: 70 },
			{ dataIndex: 'ESTI_NUM'				, width: 100 },
			{ dataIndex: 'ESTI_SEQ'				, width: 50 },
			{ dataIndex: 'ESTI_CFM_PRICE'		, width: 120 },
			{ dataIndex: 'ESTI_PRICE'			, width: 120, hidden: true },
			{ dataIndex: 'ESTI_AMT'				, width: 120, hidden: true },
			{ dataIndex: 'ESTI_CFM_AMT'			, width: 100, hidden: true},
			{ dataIndex: 'ESTI_TAX_AMT'			, width: 100, hidden: true },
			{ dataIndex: 'TAX_TYPE'				, width: 66, hidden: true },
			{ dataIndex: 'PROFIT_RATE'			, width: 100, hidden: true },
			{ dataIndex: 'ORDER_Q'				, width: 100, hidden: true },
			{ dataIndex: 'REF_FLAG'				, width: 66, hidden: true },
			{ dataIndex: 'ITEM_LEVEL1'			, width: 100, hidden: true },
			{ dataIndex: 'ITEM_LEVEL2'			, width: 100, hidden: true },
			{ dataIndex: 'ITEM_LEVEL3'			, width: 66, hidden: true },
			{ dataIndex: 'ESTI_EX_AMT'			, width: 100, hidden: true },
			{ dataIndex: 'ESTI_CFM_EX_PRICE'	, width: 66, hidden: true },
			{ dataIndex: 'ESTI_CFM_EX_AMT'		, width: 66, hidden: true },
			{ dataIndex: 'ESTI_CFM_TAX_AMT'		, width: 100, hidden: true },
			{ dataIndex: 'CONFIRM_FLAG'			, width: 66 },
			{ dataIndex: 'SORT'					, width: 66, hidden: true },
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 66, hidden: true } ,
			//20200515 추가: 창고, 재고수량
			{ dataIndex: 'WH_CODE'				, width: 150, hidden: true},
			{ dataIndex: 'STOCK_Q'				, width: 106, hidden: true}

		],
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i) {
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setEstiData(record.data);
			});
			this.getStore().remove(records);
		}
	});

	function openSearchInfoWindow() {		//검색팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '견적번호조회',
				width: 1080,
				height: 580,
				margin: '40 0 0 200',
				layout: {type:'vbox', align:'stretch'},
				items: [orderNoSearch, orderNoMasterGrid, orderNoDetailGrid],
				tbar:  ['->',
					{itemId : 'saveBtn',
					text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler: function() {
						var ConfirmFlag = orderNoSearch.getField('rdo1').getChecked()[0].inputValue
						if (orderNoSearch.getField('RDO_TYPE').getChecked()[0].inputValue == 'detail') {
							orderNoDetailStore.loadStoreRecords(ConfirmFlag);
						} else {
							orderNoMasterStore.loadStoreRecords(ConfirmFlag);
						}
					},
					disabled: false
					},{
						itemId : 'OrderNoCloseBtn',
						text: '<t:message code="system.label.sales.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
							if (orderNoSearch.getField('RDO_TYPE').getChecked()[0].inputValue == 'detail') {
								orderNoMasterGrid.hide();
							} else {
								orderNoDetailGrid.hide();
							}
						},
						disabled: false
					}
				],
				listeners: {
					beforehide: function(me, eOpt) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
						orderNoDetailGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
						orderNoDetailGrid.reset();
					},
					beforeshow: function( panel, eOpts ) {
						orderNoSearch.setValue('DIV_CODE', UserInfo.divCode);
						orderNoSearch.setValue('ESTI_DATE_FR', UniDate.get('startOfMonth'));
						orderNoSearch.setValue('ESTI_DATE_TO', panelResult.getValue('ESTI_DATE'));
						orderNoSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						orderNoSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
						orderNoSearch.setValue('ESTI_TITLE', panelResult.getValue('ESTI_TITLE'));
					},
					show: function(panel, eOpts) {
						if (orderNoSearch.getField('RDO_TYPE').getChecked()[0].inputValue == 'detail') {
							orderNoMasterGrid.hide();
						} else {
							orderNoDetailGrid.hide();
						}
					}
				}
			})
		}
		SearchInfoWindow.show();
	}

	function openEstimateWindow() {			// 참조
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!masterTable.setAllFieldsReadOnly(true)) {
				return false;
		}
		otherOrderSearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
		otherOrderSearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
//		otherOrderStore.loadStoreRecords();

		if(!estimateWindow) {
			estimateWindow = Ext.create('widget.uniDetailWindow', {
				title: '타견적참조',
				width: 950,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [otherOrderSearch, otherOrderGrid],
				tbar:  ['->',
					{   itemId : 'saveBtn',
						text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
						handler: function() {
							otherOrderStore.loadStoreRecords();
						},
						disabled: false
					},{ itemId : 'confirmBtn',
						text: '적용',
						handler: function() {
							otherOrderGrid.returnData();
						},
						disabled: false
					},{ itemId : 'confirmCloseBtn',
						text: '적용 후 닫기',
						handler: function() {
							otherOrderGrid.returnData();
							estimateWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.sales.close" default="닫기"/>',
						handler: function() {
							estimateWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						otherOrderSearch.clearForm();
						otherOrderGrid.reset();
					},
					beforeclose: function(panel, eOpts) {
						otherOrderSearch.clearForm();
						otherOrderGrid.reset();
					},
					beforeshow: function (me, eOpts) {
						otherOrderSearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
						otherOrderSearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
						otherOrderStore.loadStoreRecords();
					}
				}
			})
		}
		estimateWindow.show();
		estimateWindow.center();
	}



	Unilite.Main ({
		id			: 'spp100ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [{
				region	: 'center',
				xtype	: 'container',
				layout	: 'fit',
				items	: [ detailGrid ]
			},
			panelResult,
			{
				region : 'north',
				xtype : 'container',
				highth: 20,
				layout : 'fit',
				items : [ masterTable ]
			},
			mainGrid
			]
		},
			panelSearch
		],
		setDefault: function(params) {
			//20200512 추가: 견적현황 조회에서 넘어오는 데이터 받는로직 추가
			if(!Ext.isEmpty(params && params.PGM_ID)) {
				this.processParams(params);
			} else {
				buttonClicked = false;
				Ext.getCmp('CONFIRM').setDisabled(true);
				Ext.getCmp('SUJU').setDisabled(true);
				masterTable.setValue('CONFIRM_FLAG'	, '1');
				masterTable.setValue('DIV_CODE'		, UserInfo.divCode);
				panelResult.setValue('ESTI_DATE'	, new Date());
				panelSearch.setValue('ESTI_DATE'	, new Date());

				masterTable.setValue('EXCHG_MONEY_UNIT'	, gsMoneyUnitRef4);
				masterTable.setValue('EXCHANGE_RATE'	, gsExchangeRate);

				var param = panelResult.getValues();
				spp100ukrvService.selectEstiPrsn(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						masterTable.setValue('ESTI_PRSN', provider[0].SUB_CODE);
					}
				});
			}
		},
		//20200512 추가: 견적현황 조회에서 넘어오는 데이터 받는로직 추가
		processParams: function(params) {
			if(params.PGM_ID == 'spp100skrv') {
				var param = {
					ESTI_NUM	: params.ESTI_NUM,
					CUSTOM_CODE	: params.CUSTOM_CODE,
					ESTI_DATE	: params.ESTI_DATE
				}
				masterTable.uniOpt.inLoading = true;
				masterTable.getForm().load({
					params: param,
					success:function() {
						panelSearch.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
						panelSearch.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
						panelSearch.setValue('ESTI_DATE'	, params.ESTI_DATE);
//						panelSearch.setValue('ESTI_TITLE'	, params.ESTI_TITLE);
						panelResult.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
						panelResult.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
						panelResult.setValue('ESTI_DATE'	, params.ESTI_DATE);
//						panelResult.setValue('ESTI_TITLE'	, params.ESTI_TITLE);
						masterTable.setValue('CONFIRM_FLAG'	, params.CONFIRM_FLAG);

						panelSearch.getField('CUSTOM_CODE').setReadOnly(true);
						panelSearch.getField('CUSTOM_NAME').setReadOnly(true);
						panelSearch.getField('ESTI_DATE').setReadOnly(true);
						panelResult.getField('CUSTOM_CODE').setReadOnly(true);
						panelResult.getField('CUSTOM_NAME').setReadOnly(true);
						panelResult.getField('ESTI_DATE').setReadOnly(true);
						masterTable.getField('ESTI_PRSN').setReadOnly(true);

						spp100ukrvService.selectCustomCode(param,
							function(provider, response) {
								if(!Ext.isEmpty(provider)) {
									panelSearch.setValue('TAX_INOUT', provider.data.TAX_TYPE);
									panelResult.setValue('TAX_INOUT', provider.data.TAX_TYPE);
									CustomCodeInfo.gsWonCalcBas = provider.data.WON_CALC_BAS;
								}
								masterTable.uniOpt.inLoading=false;
								UniAppManager.setToolbarButtons('save', false)
								detailStore.loadStoreRecords();
								Ext.getCmp('CONFIRM').setDisabled(false);
								if(masterTable.getValue('CONFIRM_FLAG') == '1') {
									Ext.getCmp('SUJU').setDisabled(true);
									Ext.getCmp('CONFIRM').setText(Msg.sMS141);
								} else {
									Ext.getCmp('SUJU').setDisabled(false);
									Ext.getCmp('CONFIRM').setText('확정취소');
								}
								masterTable.getField('ESTI_AMT').focus();
								masterTable.getField('ESTI_AMT').blur();
								mainGrid.getStore().commitChanges();
								masterTable.resetDirtyStatus();
								UniAppManager.setToolbarButtons(['print','delete'], true);
							}
						)
					},
					failure: function(form, action) {
						masterTable.uniOpt.inLoading=false;
					}
				});
				UniAppManager.setToolbarButtons(['print','delete'], true);
			}
		},
		fnInitBinding: function(params) {
			this.setDefault(params);
			UniAppManager.setToolbarButtons(['delete','save', 'print', 'deleteAll'], false);
			UniAppManager.setToolbarButtons(['newData'], true);

		},
		onQueryButtonDown: function() {
			if(detailStore.getCount() == 0) {
				openSearchInfoWindow()
			} else {
				mainGrid.reset();
				var param= orderNoSearch.getValues();
				param.ESTI_NUM		= masterTable.getValue('ESTI_NUM');
				param.CUSTOM_CODE	= masterTable.getValue('CUSTOM_CODE');
				param.ESTI_DATE		= UniDate.getDbDateStr(masterTable.getValue('ESTI_DATE'));
				masterTable.uniOpt.inLoading = true;


				masterStore.loadStoreRecords();		//20210721: 기존 데이터 조회 후, 저장 시 master data 삭제되는 현상 때문에 추가
				masterTable.getForm().load({
					params	: param,
					success	: function() {
						detailStore.loadStoreRecords();
						masterTable.uniOpt.inLoading=false;
					},
					failure: function(form, action) {
						masterTable.uniOpt.inLoading=false;
					}
				});
				UniAppManager.setToolbarButtons(['print','delete'], true);
				//Ext.getCmp('CONFIRM').setDisabled(true);
			}
		},
		onNewDataButtonDown: function() {   // 행추가 버튼
			if(!panelResult.setAllFieldsReadOnly(true)) {
				return false;
			}
			if(!panelSearch.setAllFieldsReadOnly(true)) {
				return false;
			}
			if(!masterTable.setAllFieldsReadOnly(true)) {
				return false;
			}
			var estiprsn = masterTable.getValue('ESTI_PRSN');
			var estiNum = masterTable.getValue('ESTI_NUM');
			var transRate
			var seq = detailStore.max('ESTI_SEQ');
				if(!seq) seq = 1;
				else seq += 1;
			var estiQty = '0';
			var estiPrice = '0';
			var estiAmt = '0';
			var estiCfmPrice = '0';
			var estiCfmAmt = '0';
			var taxType = '1';
			var estiTaxAmt = '0';
			var profitRate = '0';
			var orderQ = '0';
			var refFlag = 'N';
			var estiExAmt = '0';
			var estiCfmExPrice = '0';
			var estiCfmExAmt = '0';
			var estiCfmTaxAmt = '0';

			var r = {
				ESTI_PRSN:estiprsn,
				ESTI_NUM: estiNum,
				TRANS_RATE: transRate,
				ESTI_SEQ: seq,
				ESTI_QTY: estiQty,
				ESTI_PRICE: estiPrice,
				ESTI_AMT: estiAmt,
				ESTI_CFM_PRICE: estiCfmPrice,
				ESTI_CFM_AMT: estiCfmAmt,
				TAX_TYPE: taxType,
				ESTI_TAX_AMT: estiTaxAmt,
				PROFIT_RATE: profitRate,
				ORDER_Q: orderQ,
				REF_FLAG: refFlag,
				ESTI_EX_AMT: estiExAmt,
				ESTI_CFM_EX_PRICE :estiCfmExPrice,
				ESTI_CFM_EX_AMT: estiCfmExAmt,
				ESTI_CFM_TAX_AMT: estiCfmTaxAmt
			};
			detailGrid.createRow(r);
			UniAppManager.setToolbarButtons(['save', 'delete'], true);
			panelSearch.setAllFieldsReadOnly(false);
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var lastLine = detailStore.getCount() -1;
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom == true) {
				detailGrid.deleteSelectedRow();
				if(lastLine == 0) {
					UniAppManager.setToolbarButtons(['save', 'delete'], false);
				}
			}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				detailGrid.deleteSelectedRow();
				UniAppManager.app.fnSumAmt(selRow, 0, 'ESTI_QTY');
				UniAppManager.setToolbarButtons(['save'], true);
				if(lastLine == 0) {
					UniAppManager.setToolbarButtons(['delete'], false);
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom) {					// 신규 레코드일시 isNewData에
														// true를 반환
					isNewData = true;
				}else{									// 신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
							detailGrid.reset();
							mainGrid.deleteSelectedRow();
							UniAppManager.app.onSaveDataButtonDown2();
							UniAppManager.app.onResetButtonDown();
					}
					return false;
				}
			});
			if(isNewData) {								// 신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				mainGrid.reset();
				masterTable.reset();
				UniAppManager.app.onResetButtonDown();	// 삭제후 RESET..
			}
		},
		onResetButtonDown: function() {	 // 새로고침 버튼
			panelSearch.clearForm();
			panelResult.clearForm();
//			detailGrid.reset();
			detailStore.loadData({});
//			otherOrderGrid.reset();
			otherOrderStore.loadData({});
			masterTable.clearForm();
//			mainGrid.reset();
			masterStore.loadData({});
			orderNoSearch.reset();
			otherOrderSearch.reset();

			panelSearch.getField('CUSTOM_CODE').setReadOnly(false);
			panelSearch.getField('CUSTOM_NAME').setReadOnly(false);
			panelSearch.getField('ESTI_DATE').setReadOnly(false);
			panelResult.getField('CUSTOM_CODE').setReadOnly(false);
			panelResult.getField('CUSTOM_NAME').setReadOnly(false);
			panelResult.getField('ESTI_DATE').setReadOnly(false);
			masterTable.getField('ESTI_PRSN').setReadOnly(false);

			panelSearch.getField('ESTI_TITLE').setReadOnly(false);
			panelResult.getField('ESTI_TITLE').setReadOnly(false);
			masterTable.getField('CUST_PRSN').setReadOnly(false);
			masterTable.getField('CONFIRM_DATE').setReadOnly(false);
			masterTable.getField('ESTI_PAYCONDI').setReadOnly(false);
			masterTable.getField('ESTI_VALIDTERM').setReadOnly(false);
			masterTable.getField('ESTI_DVRY_DATE').setReadOnly(false);
			masterTable.getField('ESTI_DVRY_PLCE').setReadOnly(false);
			masterTable.getField('REMARK').setReadOnly(false);

			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			var inoutPrsn;
			var param = panelResult.getValues();
			spp100ukrvService.selectEstiPrsn(param, function(provider, response) {
				if(!Ext.isEmpty(provider)) {
					masterTable.setValue('ESTI_PRSN', provider[0].SUB_CODE);
				}
			});
			inoutPrsn = masterTable.getValue('ESTI_PRSN');
				var r = {
					ESTI_DATE : new Date(),
					CONFIRM_DATE : new Date(),
						CONFIRM_FLAG: '1',
						ESTI_PRSN : inoutPrsn,
						MONEY_UNIT : gsMoneyUnitRef4,
						EXCHANGE_RATE : gsExchangeRate
			};
			mainGrid.createRow(r);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODE')) || Ext.isEmpty(masterTable.getValue('ESTI_PRSN')) || Ext.isEmpty(masterTable.getValue('ESTI_DATE'))) {
				Unilite.messageBox('필수입력 값을 입력하세요.');
				return false;
			}
			var inValidRecsMaster	= masterStore.getInvalidRecords();
			var inValidRecsDetail	= detailStore.getInvalidRecords();

//			if(inValidRecsMaster.length != 0) {
//				mainGrid.uniSelectInvalidColumnAndAlert(inValidRecsMaster);
//				return false;
//			}
			if(inValidRecsDetail.length != 0) {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecsDetail);
				return false;
			}
			if(masterTable.isDirty()) {
				masterStore.saveStore();
				UniAppManager.setToolbarButtons(['reset', 'newData', 'deleteAll', 'print'], true);
				if(masterTable.getValue('CONFIRM_FLAG') == '1') {
					Ext.getCmp('CONFIRM').setDisabled(false);
				}else{
					Ext.getCmp('CONFIRM').setDisabled(true);
				}
			} else{
				detailStore.saveStore();
				UniAppManager.setToolbarButtons(['reset', 'newData', 'deleteAll', 'print'], true);
				if(masterTable.getValue('CONFIRM_FLAG') == '1') {
					Ext.getCmp('CONFIRM').setDisabled(false);
				}else{
					Ext.getCmp('CONFIRM').setDisabled(true);
				}
			}
		},
		onSaveDataButtonDown2: function(config) {	// DELETEALL USE ONLY
			var inValidRecsMaster	= masterStore.getInvalidRecords();
			var inValidRecsDetail	= detailStore.getInvalidRecords();

			if(inValidRecsMaster.length != 0) {
				mainGrid.uniSelectInvalidColumnAndAlert(inValidRecsMaster);
				return false;
			}
			if(inValidRecsDetail.length != 0) {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecsDetail);
				return false;
			}
			if(masterTable.isDirty()) {
				masterStore.saveStore();
				UniAppManager.setToolbarButtons(['reset', 'newData', 'deleteAll', 'print'], true);
			} else{
				detailStore.saveStore();
				UniAppManager.setToolbarButtons(['reset', 'newData', 'deleteAll', 'print'], true);
			}
		},
		/** 일훈 견적서출력 */
		onPrintButtonDown: function() {
			if(Ext.isEmpty(panelResult.getValue('ESTI_NUM'))) {
				return false
			} // 필수체크
			var win;
			var param = panelResult.getValues();
			param.PGM_ID = PGM_ID;  //프로그램ID
	 		param.MAIN_CODE = 'S036'
			win = Ext.create('widget.ClipReport',{
				url: CPATH+'/sales/spp100clukrv.do',
				prgID: 'spp100ukrv',
				extParam: param
				});
			win.center();
			win.show();
		},
		fnExchngRateO:function() {
			var param = {
				"AC_DATE"   : UniDate.getDbDateStr(new Date()),
				"MONEY_UNIT": masterTable.getValue('EXCHG_MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)) {
					if(provider.BASE_EXCHG == "1"  && !Ext.isEmpty(masterTable.getValue('EXCHG_MONEY_UNIT')) && masterTable.getValue('EXCHG_MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit) {
						//panelSearch.down('#conversionApplied').disable();
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>');
					} else {
						//panelSearch.down('#conversionApplied').enable();
					}
					masterTable.setValue('EXCHANGE_RATE', provider.BASE_EXCHG);
				}
			});
		},
		checkForNewDetail: function() {
			return panelSearch.setAllFieldsReadOnly(true);
		},
		fnGetInoutPrsnDivCode: function(subCode) { //사업장의 첫번째 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
				if(item['refCode1'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		fnGetInoutPrsnUserId: function(subCode) { //로그인 아이디의 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
				if(item['refCode5'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		fnSaleAmtCompute: function(record, newValue, fieldName) {			// 수량,단가 입력시 견적금액
			var dEstiAmt = fieldName=='ESTI_AMT'			? newValue : Unilite.nvl(record.get('ESTI_AMT'),0);
			var dEstiQty = fieldName=='ESTI_QTY'			? newValue : Unilite.nvl(record.get('ESTI_QTY'),0);
			var dEstiPrice = fieldName=='ESTI_PRICE'		? newValue : Unilite.nvl(record.get('ESTI_PRICE'),0);
			var dEstiCfmAmt = fieldName=='ESTI_CFM_AMT'	? newValue : Unilite.nvl(record.get('ESTI_CFM_AMT'),0);
			var dEstiCfmPrice = fieldName=='ESTI_CFM_PRICE'? newValue : Unilite.nvl(record.get('ESTI_CFM_PRICE'),0);
			var dEstiTaxAmt = fieldName=='ESTI_TAX_AMT'	? newValue : Unilite.nvl(record.get('ESTI_TAX_AMT'),0);

			var ExchangeRate = masterTable.getValue('EXCHANGE_RATE');

			dEstiAmt = dEstiQty * dEstiPrice;
			dEstiCfmAmt = dEstiQty * dEstiCfmPrice;
			var rEstiCfmExPrice = ExchangeRate * dEstiCfmPrice;
			var rEstiCfmExAmt = ExchangeRate * dEstiCfmAmt;
			var rEstiCfmTaxAmt = ExchangeRate * rEstiCfmExAmt;

			record.set('ESTI_AMT', dEstiAmt);					// 견적금정상가금액액
			record.set('ESTI_CFM_AMT', dEstiCfmAmt);			 // 견적금액
			record.set('ESTI_CFM_EX_PRICE', rEstiCfmExPrice);	// 단가(자사)
			record.set('ESTI_CFM_EX_AMT', rEstiCfmExAmt);		// 금액(자사)
			record.set('ESTI_CFM_TAX_AMT', dEstiTaxAmt);	// 세액(자사)
//			Unilite.messageBox(record.get('ESTI_CFM_AMT'));
		},
		fnTaxCalculate: function(record, newValue, fieldName) {
			//var record = detailGrid.getSelectedRecord();
//			var sTaxType	= Ext.isEmpty(taxType)? record.data.TAX_TYPE : taxType;
			var sTaxInoutType = panelSearch.getValue('TAX_INOUT');
			var chkEstiCfmAmt = fieldName=='ESTI_CFM_AMT'	 ? newValue : Unilite.nvl(record.get('ESTI_CFM_AMT'),0);
			var dVatRate = parseInt(BsaCodeInfo.gsVatRate);
			var dEstCfmAmtO = 0;
			var dTaxAmtO = 0;
			var dAmountI = 0;
			//20191212 금액계산로직 변경으로 추가
			var sWonCalBas		= CustomCodeInfo.gsWonCalcBas

			if(sTaxInoutType=="1") {
				dEstCfmAmtO = chkEstiCfmAmt;
				dTaxAmtO   = chkEstiCfmAmt * dVatRate / 100
				dEstCfmAmtO = UniSales.fnAmtWonCalc(dEstCfmAmtO, sWonCalBas);
				if(UserInfo.compCountry == 'CN') {
					//20191002 세액 구하는 함수 생성: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO   = UniSales.fnAmtWonCalc(dTaxAmtO, '3');
				} else {
					//20191002 세액 구하는 함수 생성: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO   = UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas);
				}
			} else if(sTaxInoutType=="2") {
				dAmountI = chkEstiCfmAmt;
				if(UserInfo.compCountry == 'CN') {
					dTemp	= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '3');
					//20191002 세액 구하는 함수 생성: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO   = UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, '3');
				} else {
					dTemp	= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sWonCalBas);
					//20191002 세액 구하는 함수 생성: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO   = UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sWonCalBas);					//세액은 절사처리함.
				}
				dEstCfmAmtO = UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), CustomCodeInfo.gsWonCalcBas);
			}
//			if(sTaxType == "2") {
//				dEstCfmAmtO = UniSales.fnAmtWonCalc(chkEstiCfmAmt, CustomCodeInfo.gsWonCalcBas ) ;
//				dTaxAmtO = 0;
//			}

			record.set('ESTI_CFM_AMT', dEstCfmAmtO);
			record.set('ESTI_TAX_AMT', dTaxAmtO);
			record.set('ESTI_CFM_TAX_AMT', Unilite.multiply(dTaxAmtO, masterTable.getValue('EXCHANGE_RATE')));
			//rtnRecord.set('ESTI_CFM_AMT',dEstCfmAmtO+dTaxAmtO);
		},
		fnPriceBaseDcRateCompute: function(record, newValue, fieldName) {	// [단가BASE DC율] DC율 계산 [DC율: 100-(견적단가/정상판매가*100)]
			var dProfitRate;
			var dEstiPrice = fieldName=='ESTI_PRICE'	 ? newValue : Unilite.nvl(record.get('ESTI_PRICE'),0);
			var dEstiCfmPrice = fieldName=='ESTI_CFM_PRICE'	 ? newValue : Unilite.nvl(record.get('ESTI_CFM_PRICE'),0);
			dProfitRate = 100 - (dEstiCfmPrice / dEstiPrice * 100);
			record.set('PROFIT_RATE', dProfitRate);
			if(dProfitRate < 0) {
				dProfitRate = 0;
			}
		},
		fnAmtBaseDcRateCompute: function(record, newValue, fieldName) {		// [금액BASE DC율] DC율 계산 [DC율: 100-(견적금액/정상금액*100)]
			var dProfitRate;
			var dEstiAmt = fieldName=='ESTI_AMT'	 ? newValue : Unilite.nvl(record.get('ESTI_AMT'),0);
			var dEstiCfmAmt = fieldName=='ESTI_CFM_AMT'	 ? newValue : Unilite.nvl(record.get('ESTI_CFM_AMT'),0);
			dProfitRate = 100 - (dEstiCfmAmt / dEstiAmt * 100);
			record.set('PROFIT_RATE', dProfitRate);
			if(dProfitRate < 0) {
				dProfitRate = 0;
			}
		},
		fnReDcRateCompute: function(record, newValue, fieldName) {			 // DC율변경시, 견적단가,금액 재계산하여 세트 계산 [견적단가 = (100 - DC율) * 정상단가 / 100] [견적금액 = 견적단가 * 견적수량]
			var dEstyQty = fieldName=='ESTI_QTY'	 ? newValue : Unilite.nvl(record.get('ESTI_QTY'),0);
			var dProfitRate = fieldName=='PROFIT_RATE'	 ? newValue : Unilite.nvl(record.get('PROFIT_RATE'),0);
			var dEstiAmt = fieldName=='ESTI_AMT'	 ? newValue : Unilite.nvl(record.get('ESTI_AMT'),0);
			var dEstiCfmAmt = fieldName=='ESTI_CFM_AMT'	 ? newValue : Unilite.nvl(record.get('ESTI_CFM_AMT'),0);
			var dEstiPrice = fieldName=='ESTI_PRICE'	 ? newValue : Unilite.nvl(record.get('ESTI_PRICE'),0);
			var dEstiCfmPrice = fieldName=='ESTI_CFM_PRICE'	 ? newValue : Unilite.nvl(record.get('ESTI_CFM_PRICE'),0);
			dEstiCfmPrice = (100 - dProfitRate) * dEstiPrice / 100;
			dEstiCfmAmt = dEstyQty * dEstiCfmPrice;
			record.set('ESTI_CFM_PRICE', dEstiCfmPrice);
			record.set('ESTI_CFM_AMT', dEstiCfmAmt);
		},
		fnSumAmt: function(record, newValue, fieldName) {
			var results = detailStore.sumBy(function(record, id) {
				return true;
			},
			['ESTI_AMT', 'ESTI_CFM_AMT']);
			var estiAmt = results.ESTI_AMT;
			var estiCfmAmt = results.ESTI_CFM_AMT;

			masterTable.setValue('ESTI_AMT', estiAmt);				// 정상판매가총액
			masterTable.setValue('ESTI_CFM_AMT', estiCfmAmt);	// 견적총액
			if(masterTable.getValue('ESTI_AMT') > masterTable.getValue('ESTI_CFM_AMT')) {
				masterTable.setValue('ESTI_TAX_AMT', 100 - ((masterTable.getValue('ESTI_CFM_AMT') / masterTable.getValue('ESTI_AMT')) * 100));   // 총DC율
			} else {
				masterTable.setValue('ESTI_TAX_AMT', 0);
			}
		},
		// UniSales.fnGetPriceInfo callback 함수
		cbGetPriceInfo: function(provider, params) {
			var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);
			var ExchangeRate = masterTable.getValue('EXCHANGE_RATE');
			if(params.sType=='I' && dSalePrice != 0)   {
				// 판매단가 적용
				params.rtnRecord.set('ESTI_PRICE'		, dSalePrice);
				params.rtnRecord.set('ESTI_CFM_PRICE'	, dSalePrice);
				params.rtnRecord.set('ESTI_CFM_EX_PRICE', dSalePrice * ExchangeRate);
				//params.rtnRecord.set('TRANS_RATE',provider['SALE_TRANS_RATE']);
				//params.rtnRecord.set('DISCOUNT_RATE',provider['DC_RATE']);
			}
//			if(params.qty > 0 && dSalePrice > 0 ) {
//				UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P", dSalePrice)
//			}else{
//				var dTransRate = Unilite.nvl(params.rtnRecord.get('TRANS_RATE'),1);
//				var dOrderQ = Unilite.nvl(params.rtnRecord.get('ORDER_Q'),0);
//				var dOrderUnitQ = 0;
//
//				dOrderUnitQ = dOrderQ * dTransRate;
//				params.rtnRecord.set('ORDER_UNIT_Q', dOrderUnitQ);
//			};
		}
	});


	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, rtnRecord) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ESTI_QTY" :	// 견적수량
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0) {
						rv= '<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>';
						break;
					} else {
						UniAppManager.app.fnSaleAmtCompute(record, newValue, fieldName);			// '정상판매액, 견적금액RETURN
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);				// '부가세액 RETURN
						UniAppManager.app.fnAmtBaseDcRateCompute(record, newValue, fieldName);		// 'DC율 RETURN
						UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					}
				break;

				case "ESTI_PRICE" :	// 정상판매가
					if(record.get('ESTI_CFM_PRICE') == 0) {
						record.set('ESTI_CFM_PRICE', newValue)
					}
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0) {
						rv= '<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>';
						break;
					} else {
						UniAppManager.app.fnSaleAmtCompute(record, newValue, fieldName);			// '정상판매액, 견적금액RETURN
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);				// '부가세액 RETURN
						UniAppManager.app.fnPriceBaseDcRateCompute(record, newValue, fieldName);	// 'DC율 RETURN
						UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					}
				break;

				case "ESTI_AMT" :	// 정상금액
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0) {
						rv= '<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>';
						break;
					} else {
						UniAppManager.app.fnSaleAmtCompute(record, newValue, fieldName);			// '정상판매액, 견적금액RETURN
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);				// '부가세액 RETURN
						UniAppManager.app.fnAmtBaseDcRateCompute(record, newValue, fieldName);		// 'DC율 RETURN
						UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					}
				break;

				case "ESTI_CFM_PRICE" :	// 견적단가
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0) {
						rv= '<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>';
						break;
					} else {
						UniAppManager.app.fnSaleAmtCompute(record, newValue, fieldName);			// '정상판매액, 견적금액RETURN
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);				// '부가세액 RETURN
						UniAppManager.app.fnPriceBaseDcRateCompute(record, newValue, fieldName);	// 'DC율 RETURN
						UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					}
				break;

				case "ESTI_CFM_AMT" :	// 견적금액
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0) {
						rv= '<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>';
						break;
					} else {
						UniAppManager.app.fnSaleAmtCompute(record, newValue, fieldName);			// '정상판매액, 견적금액RETURN
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);				// '부가세액 RETURN
						UniAppManager.app.fnAmtBaseDcRateCompute(record, newValue, fieldName);		// 'DC율 RETURN
						UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					}
				break;

				case "TAX_TYPE" :		// 과세여부
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0) {
						rv= '<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>';
						break;
					} else {
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);			// '부가세액 RETURN
						UniAppManager.app.fnAmtBaseDcRateCompute(record, newValue, fieldName);	// 'DC율 RETURN
					}
				break;

				case "ESTI_TAX_AMT" :	// 세액
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue > 0) {
						if(record.get('ESTI_CFM_AMT') < newValue) {
							rv= Msg.sMS272;
							break;
						}
					} else {
						if(record.get('ESTI_CFM_AMT') > newValue) {
							rv= Msg.sMS273;
							break;
						}
					}
					if(UserInfo.compCountry == 'CN') {
						record.set('ESTI_TAX_AMT', UniSales.fnAmtWonCalc(dTaxAmtO, "3"));			//세액은 절사처리함.
					} else {
						record.set('ESTI_TAX_AMT', UniSales.fnAmtWonCalc(dTaxAmtO, "2"));
					}
				break;

				case "PROFIT_RATE" :	// DC율
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0) {
						rv= '<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>';
						break;
					} else {
						UniAppManager.app.fnReDcRateCompute(record, newValue, fieldName);
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);
						UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					}
				break;

				case "TRANS_RATE" :	//입수
					if (newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if (newValue == 0) {
						rv= '<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>';
						break;
					} else if (newValue > 999999) {
						rv= '여섯 자릿수 이상 입력하면 안 됩니다.';
						break;
					} else {
						//UniAppManager.app.fnReDcRateCompute(record, newValue, fieldName);
						//UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);
						//UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					}
				break;
			}
			return rv;
		}
	})
};
</script>