<%--
'   프로그램명 : 출고등록 (영업)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str103ukrv_yp"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="s_str103ukrv_yp" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 수불담당 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" /><!--창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="B021" /> <!--품목상태-->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!--판매단위-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S014" /> <!--매출대상-->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당자-->
	<t:ExtComboStore comboType="AU" comboCode="T016" /> <!--대금결제방법-->
	<t:ExtComboStore comboType="AU" comboCode="B116" /> <!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="S065" /> <!--주문구분-->
	<t:ExtComboStore comboType="AU" comboCode="YP09" /> <!--판매형태-->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5' /> <!--생성경로-->
</t:appConfig>
<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">
var searchInfoWindow;	//searchInfoWindow : 검색창
var referRequestWindow;	//출하지시참조
var refersalesOrderWindow; //수주(오퍼)참조
var gsRefYn = 'N'
var gsMonClosing = '';	//월마감 여부
var gsDayClosing = '';	//일마감 여부
var gsWhCode = '';		//창고코드
////2015.02.10
////마감 처리 된건 수정 불가하게 수정
////여신액 넣게 fnGetCustCredit
////저장후 수불번호 박히는지 확인

var BsaCodeInfo = {
	gsAutoType: '${gsAutoType}',
	gsMoneyUnit: '${gsMoneyUnit}',
	gsOptDivCode: '${gsOptDivCode}',
	gsPriceGubun: '${gsPriceGubun}',
	gsWeight: '${gsWeight}',
	gsVolume: '${gsVolume}',
	gsLotNoInputMethod: '${gsLotNoInputMethod}',
	gsLotNoEssential: '${gsLotNoEssential}',
	gsEssItemAccount: '${gsEssItemAccount}',
	gsLotNoInputMethod: '${gsLotNoInputMethod}',
	gsLotNoEssential: '${gsLotNoEssential}',
	gsEssItemAccount: '${gsEssItemAccount}',
	gsInoutAutoYN: '${gsInoutAutoYN}',
	gsInvstatus: '${gsInvstatus}',
	gsPointYn: '${gsPointYn}',
	gsUnitChack: '${gsUnitChack}',
	gsCreditYn: '${gsCreditYn}',
	grsOutType: ${grsOutType},
	gsSumTypeCell: '${gsSumTypeCell}',
	gsRefWhCode : '${gsRefWhCode}',
	gsVatRate : ${gsVatRate},
	gsManageTimeYN : '${gsManageTimeYN}',
	salePrsn : ${salePrsn},
	inoutPrsn: ${inoutPrsn},
	whList : ${whList},
	useLotAssignment: '${useLotAssignment}'
};

//var output ='';
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

var CustomCodeInfo = {
	gsAgentType: '',
	gsCustCreditYn: '',
	gsUnderCalBase: '',
	gsTaxInout: '',
	gsbusiPrsn: ''
};

var outDivCode = UserInfo.divCode;

function appMain() {
	/**
	 * 자동채번 여부
	 */
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoOrderNum = true;
	}

	var manageTimeYN = false;//시/분/초 필드 처리여부
	if(BsaCodeInfo.gsManageTimeYN =='Y')	{
		manageTimeYN = true;
	}

	var sumtypeCell = true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeCell =='Y')	{
		sumtypeCell = false;
	}
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_str103ukrv_ypService.selectDetailList',
			update: 's_str103ukrv_ypService.updateDetail',
			create: 's_str103ukrv_ypService.insertDetail',
			destroy: 's_str103ukrv_ypService.deleteDetail',
			syncAll: 's_str103ukrv_ypService.saveAll'
		}
	});

	//창고에 따른 창고cell 콤보load..
//	var cbStore = Unilite.createStore('hat510ukrsComboStoreGrid',{
//		autoLoad: false,
//		uniOpt: {
//			isMaster: false		 // 상위 버튼 연결
//		},
//		fields: [
//				{name: 'SUB_CODE', type : 'string'},
//				{name: 'CODE_NAME', type : 'string'}
//				],
//		proxy: {
//			type: 'direct',
//			api: {
//				read: 'salesCommonService.fnRecordCombo'
//			}
//		},
//		loadStoreRecords: function(whCode) {
//			var param= masterForm.getValues();
//			param.COMP_CODE= UserInfo.compCode;
////			param.DIV_CODE = UserInfo.divCode;
//			param.WH_CODE = whCode;
//			param.TYPE = 'BSA225T';
//			console.log( param );
//			this.load({
//				params: param
//			});
//		}
//	});

	/**
	 * 수주의 마스터 정보를 가지고 있는 Form
	 */
	//좌측 마스터 서치폼 정의
	var masterForm = Unilite.createSearchPanel('s_str103ukrv_ypMasterForm', {
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		items: [{
			title: '기본정보',
		   	layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '사업장'  ,
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,
				child: 'ALL_CHANGE_WH_CODE',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
						if(!Ext.isEmpty(newValue) && !Ext.isEmpty(masterForm.getValue('INOUT_DATE'))){
							UniSales.fnGetClosingInfo(
							UniAppManager.app.cbGetClosingInfo,
							newValue,
							"I",
							masterForm.getField('INOUT_DATE').getSubmitValue());
						}
						masterForm.setValue('DEPT_CODE', '');
						masterForm.setValue('DEPT_NAME', '');
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					}
				}
			},{
				fieldLabel: '<t:message code="unilite.msg.sMR047" default="출고일"/>'  ,
				name: 'INOUT_DATE',
				xtype:'uniDatefield',
				value:new Date(),
				allowBlank:false,
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_DATE', newValue);
						if(!Ext.isEmpty(newValue && !Ext.isEmpty(masterForm.getValue('DIV_CODE')))){
							UniSales.fnGetClosingInfo(
								UniAppManager.app.cbGetClosingInfo,
								 masterForm.getValue('DIV_CODE'),
								 "I",
								 UniDate.getDbDateStr(newValue));
						}
					}
				}
			 }
			 ,Unilite.popup('AGENT_CUST',{
			  fieldLabel:'<t:message code="unilite.msg.sMSR213" default="거래처"/>' ,
			  holdable: 'hold',
			  allowBlank: false,
			  listeners: {
					onSelected: {
						fn: function(records, type) {
							 console.log('records : ', records);
							 CustomCodeInfo.gsAgentType	= records[0]["AGENT_TYPE"];
							 CustomCodeInfo.gsCustCreditYn = records[0]["CREDIT_YN"] == Ext.isEmpty(records[0]["CREDIT_YN"])? 0 : records[0]["CREDIT_YN"];
							 CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
							 CustomCodeInfo.gsTaxInout 	   = records[0]["TAX_TYPE"];	//세액포함여부
							 CustomCodeInfo.gsbusiPrsn 	   = records[0]["BUSI_PRSN"]; //거래처의 주영업담당

							 if(BsaCodeInfo.gsOptDivCode == "1"){	//출고사업장과 동일
							 	//skip
							 }else{
							 	var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);//거래처의 영업담당자의 사업장코드
							 	if(Ext.isEmpty(saleDivCode)){//거래처의 영업담당자가 있는지 체크
							 		masterForm.setValue('CUSTOM_CODE', '');
									masterForm.setValue('CUSTOM_NAME', '');
									masterForm.getField('CUSTOM_CODE').focus();

									CustomCodeInfo.gsAgentType	= '';
									CustomCodeInfo.gsCustCreditYn = '';
									CustomCodeInfo.gsUnderCalBase = '';
									CustomCodeInfo.gsTaxInout 	  = '';
									CustomCodeInfo.gsbusiPrsn 	  = '';
									alert(Msg.sMS377);	//영업담당자정보가 존재하지 않습니다.
									return false;
							 	}
							 }
							panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
					 },
						scope: this
					},
					onClear: function(type)	{
						  		CustomCodeInfo.gsAgentType	= '';
								CustomCodeInfo.gsCustCreditYn = '';
								CustomCodeInfo.gsUnderCalBase = '';
								CustomCodeInfo.gsTaxInout 	  = '';
								CustomCodeInfo.gsbusiPrsn 	  = '';
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
					}
				}
			}),{
				fieldLabel: '<t:message code="unilite.msg.sMS127" default="매출일"/>'  ,
				name: 'SALE_DATE',
				xtype:'uniDatefield',
				value:new Date(),
				allowBlank:false,
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('SALE_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="unilite.msg.sMS836" default="수불담당"/>',
				name: 'INOUT_PRSN',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				allowBlank:false,
				holdable: 'hold',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="unilite.msg.sMR310" default="생성경로"/>',
				name: 'CREATE_LOC',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'B031',
				allowBlank:false,
				hidden: true,
				value:'1',
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('CREATE_LOC', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="unilite.msg.sMB184" default="화폐"/>',
				name:'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B004',
				value:'KRW',
				allowBlank: false,
				holdable: 'hold',
				displayField: 'value',
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
					},
					blur: function( field, The, eOpts )	{
					   UniAppManager.app.fnExchngRateO();
					}
				}
			},
			Unilite.popup('DEPT', {
				fieldLabel: '부서',
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
		   	 	hidden: true,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
//							gsWhCode = records[0]['WH_CODE'];
//							var whStore = masterForm.getField('ALL_CHANGE_WH_CODE').getStore();
//							console.log("whStore : ",whStore);
//							whStore.clearFilter(true);
//							whStore.filter([
//								 {property:'option', value:masterForm.getValue('DIV_CODE')}
//								,{property:'value', value: records[0]['WH_CODE']}
//							]);
							masterForm.getField('ALL_CHANGE_WH_CODE').setValue(records[0]['WH_CODE']);
						},
						scope: this
					},
					onClear: function(type)	{
						var whStore = masterForm.getField('ALL_CHANGE_WH_CODE').getStore();
						whStore.removeFilter();
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장

						if(authoInfo == "A"){	//자기사업장
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});

						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});

						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),{
				fieldLabel: '환율',
				name: 'EXCHG_RATE_O',
				xtype:'uniNumberfield',
				holdable: 'hold',
				decimalPrecision: 4,
				value: 1,
				hidden:false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('EXCHG_RATE_O', newValue);
					}
				}
			},{
				fieldLabel: '여신액',
				name: 'REM_CREDIT',
				xtype:'uniNumberfield',
				holdable: 'hold',
				hidden:true
			},{
				fieldLabel: '출고창고',
				name: 'WH_CODE',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				child: 'WH_CELL_CODE',
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '출고창고Cell',
				name: 'WH_CELL_CODE',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('whCellList'),
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CELL_CODE', newValue);
					}
				}
			}]


		}, {
			title: '기타정보',
		   	layout: {type: 'uniTable', columns: 2},
		   	defaultType: 'uniTextfield',
		   	defaults: {colspan: 2},
			items: [{
				fieldLabel: '<t:message code="unilite.msg.sMRBW144" default="출고번호"/>',
				xtype: 'uniTextfield',
				name: 'INOUT_NUM',
				holdable: 'hold'
			},{
				fieldLabel: '과세총액(1)',
				name: 'TOT_SALE_TAXI',
				xtype:'uniNumberfield',
				holdable: 'hold'
			},{
				fieldLabel: '세액합계(2)',
				name: 'TOT_TAXI',
				xtype:'uniNumberfield',
				holdable: 'hold'
			},{
				fieldLabel: '면세총액(3)',
				name: 'TOT_SALENO_TAXI',
				xtype:'uniNumberfield',
				holdable: 'hold'
			},{
				fieldLabel: '출고총액[(1)+(2)+(3)]',
				name: 'TOTAL_AMT',
				xtype:'uniNumberfield',
				holdable: 'hold'
			}/*,{
				fieldLabel: '수량총계',
				name: 'TOT_QTY',
				xtype:'uniNumberfield',
				holdable: 'hold'
			}, {
				margin: '0 0 0 10',
				xtype: 'button',
				text: '창고일괄적용',
				handler: function() {
					var cgWhCode = masterForm.getValue('ALL_CHANGE_WH_CODE');
					if(Ext.isEmpty(cgWhCode)) return false;
					var records = detailStore.data.items;
					Ext.each(records, function(record,i) {
						if(record.phantom){
							record.set('WH_CODE', cgWhCode);
						}
					});
				}
			}*/,{
				fieldLabel: '여신액',
				name: 'REM_CREDIT',
				xtype:'uniNumberfield',
				holdable: 'hold',
				hidden:true
			},{
				xtype: 'uniTextfield',
				name: 'NATION_INOUT',
				hidden: true
			}]
		}],
		api: {
			load: 's_str103ukrv_ypService.selectMaster',
			submit: 's_str103ukrv_ypService.syncMaster'
		},
		fnCreditCheck: function() {
			if(BsaCodeInfo.gsCustCreditYn=='Y' && BsaCodeInfo.gsCreditYn=='Y') {
				if(this.getValue('TOT_ORDER_AMT') > this.getValue('REMAIN_CREDIT')) {
					alert('<t:message code="unilite.msg.sMS284" default="해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');
					return false;
				}
			}
			return true;
		},
		setAllFieldsReadOnly: function(b) {	////readOnly 안먹음..
				var r= true
				if(b) {
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
					} else {
						//this.mask();
						var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true);
								}
							}
							if(item.isPopupField)	{
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
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
  				}
				return r;
  		},
//  		setLoadRecord: function(record)	{
//			var me = this;
//			me.uniOpt.inLoading=false;
//			me.setAllFieldsReadOnly(true);
//		},
		listeners: {
//			uniOnChange: function(basicForm, dirty, eOpts) {
//				UniAppManager.setToolbarButtons('save', true);
//			},
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		}
	}); //End of var masterForm = Unilite.createForm('s_str103ukrv_ypMasterForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '사업장'  ,
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			value: UserInfo.divCode,
			holdable: 'hold',
			child: 'WH_CODE',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = masterForm.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					masterForm.setValue('DIV_CODE', newValue);
					if(!Ext.isEmpty(newValue) && !Ext.isEmpty(masterForm.getValue('INOUT_DATE'))){
						UniSales.fnGetClosingInfo(
							UniAppManager.app.cbGetClosingInfo,
							 newValue,
							 "I",
							 masterForm.getField('INOUT_DATE').getSubmitValue());
					}
					masterForm.setValue('DEPT_CODE', '');
					masterForm.setValue('DEPT_NAME', '');
					panelResult.setValue('DEPT_CODE', '');
					panelResult.setValue('DEPT_NAME', '');
				}
			}
		},{
			fieldLabel: '<t:message code="unilite.msg.sMRBW144" default="출고번호"/>',
			xtype: 'uniTextfield',
			name: 'INOUT_NUM',
//			colspan: 2,
			holdable: 'hold'
		},{
			xtype: 'component'
         },{
			fieldLabel: '과세총액(1)',
			name: 'TOT_SALE_TAXI',
			xtype:'uniNumberfield',
			readOnly: true,
			value: 0,
			holdable: 'hold'
		},
		  Unilite.popup('AGENT_CUST',{
		  fieldLabel:'<t:message code="unilite.msg.sMSR213" default="거래처"/>' ,
		  holdable: 'hold',
		  allowBlank: false,
//		  colspan: 2,
		  listeners: {
				onSelected: {
					fn: function(records, type) {
						 console.log('records : ', records);
						 CustomCodeInfo.gsAgentType	= records[0]["AGENT_TYPE"];
						 CustomCodeInfo.gsCustCreditYn = records[0]["CREDIT_YN"] == Ext.isEmpty(records[0]["CREDIT_YN"])? 0 : records[0]["CREDIT_YN"];
						 CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
						 CustomCodeInfo.gsTaxInout 	   = records[0]["TAX_TYPE"];	//세액포함여부
						 CustomCodeInfo.gsbusiPrsn 	   = records[0]["BUSI_PRSN"]; //거래처의 주영업담당

						 if(BsaCodeInfo.gsOptDivCode == "1"){	//출고사업장과 동일
						 	//skip
						 }else{
						 	var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);//거래처의 영업담당자의 사업장코드
						 	if(Ext.isEmpty(saleDivCode)){//거래처의 영업담당자가 있는지 체크
						 		panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
								panelResult.getField('CUSTOM_CODE').focus();

								CustomCodeInfo.gsAgentType	= '';
								CustomCodeInfo.gsCustCreditYn = '';
								CustomCodeInfo.gsUnderCalBase = '';
								CustomCodeInfo.gsTaxInout 	  = '';
								CustomCodeInfo.gsbusiPrsn 	  = '';
								alert(Msg.sMS377);	//영업담당자정보가 존재하지 않습니다.
								return false;
						 	}
						 }
						masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
				 },
					scope: this
				},
				onClear: function(type)	{
					  		CustomCodeInfo.gsAgentType	= '';
							CustomCodeInfo.gsCustCreditYn = '';
							CustomCodeInfo.gsUnderCalBase = '';
							CustomCodeInfo.gsTaxInout 	  = '';
							CustomCodeInfo.gsbusiPrsn 	  = '';
							masterForm.setValue('CUSTOM_CODE', '');
							masterForm.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),{
			fieldLabel: '<t:message code="unilite.msg.sMR047" default="출고일"/>'  ,
			name: 'INOUT_DATE',
			xtype:'uniDatefield',
			value:new Date(),
//			labelWidth: 140,
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					masterForm.setValue('INOUT_DATE', newValue);
					if(!Ext.isEmpty(newValue && !Ext.isEmpty(masterForm.getValue('DIV_CODE')))){
						UniSales.fnGetClosingInfo(
							UniAppManager.app.cbGetClosingInfo,
							 masterForm.getValue('DIV_CODE'),
							 "I",
							 UniDate.getDbDateStr(newValue));
					}
				}
			}
		 },{
			fieldLabel: '<t:message code="unilite.msg.sMS127" default="매출일"/>'  ,
			name: 'SALE_DATE',
			xtype:'uniDatefield',
			value:new Date(),
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					masterForm.setValue('SALE_DATE', newValue);
				}
			}
		},{
			fieldLabel: '세액합계(2)',
			name: 'TOT_TAXI',
			readOnly: true,
			value: 0,
			xtype:'uniNumberfield',
			holdable: 'hold'
		},{
			fieldLabel: '<t:message code="unilite.msg.sMS836" default="수불담당"/>',
			name: 'INOUT_PRSN',
			xtype:'uniCombobox',
			comboType:'AU',
//			labelWidth: 140,
			comboCode:'B024',
			allowBlank:false,
			holdable: 'hold',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}

			},
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					masterForm.setValue('INOUT_PRSN', newValue);
				}
			}
		}
		,{
			fieldLabel: '<t:message code="unilite.msg.sMR310" default="생성경로"/>',
			name: 'CREATE_LOC',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B031',
			allowBlank:false,
			value:'1',
			holdable: 'hold',
			colspan: 2,
			hidden: true,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					masterForm.setValue('CREATE_LOC', newValue);
				}
			}
		},
		Unilite.popup('DEPT', {
			fieldLabel: '부서',
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			hidden: true,
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						masterForm.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						masterForm.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
//						gsWhCode = records[0]['WH_CODE'];
//						var whStore = masterForm.getField('ALL_CHANGE_WH_CODE').getStore();
//						console.log("whStore : ",whStore);
//						whStore.clearFilter(true);
//						whStore.filter([
//							 {property:'option', value:masterForm.getValue('DIV_CODE')}
//							,{property:'value', value: records[0]['WH_CODE']}
//						]);
						masterForm.getField('ALL_CHANGE_WH_CODE').setValue(records[0]['WH_CODE']);
					},
					scope: this
				},
				onClear: function(type)	{
					masterForm.setValue('DEPT_CODE', '');
					masterForm.setValue('DEPT_NAME', '');
				},
				applyextparam: function(popup){
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장

					if(authoInfo == "A"){	//자기사업장
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});

					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});

					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),{
			fieldLabel: '<t:message code="unilite.msg.sMB184" default="화폐"/>',
			name:'MONEY_UNIT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B004',
			value:'KRW',
			allowBlank: false,
			displayField: 'value',
			holdable: 'hold',
			fieldStyle: 'text-align: center;',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					masterForm.setValue('MONEY_UNIT', newValue);
//				  UniAppManager.app.fnExchngRateO();
				},
				blur: function( field, The, eOpts )	{
				   UniAppManager.app.fnExchngRateO();
				}
			}
		}, {
			fieldLabel: '환율',
			name: 'EXCHG_RATE_O',
			xtype:'uniNumberfield',
			holdable: 'hold',
			decimalPrecision: 4,
//			labelWidth: 140,
			value: 1,
			hidden:false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					masterForm.setValue('EXCHG_RATE_O', newValue);
				}
			}
		},{
			fieldLabel: '면세총액(3)',
			name: 'TOT_SALENO_TAXI',
			xtype:'uniNumberfield',
			readOnly: true,
			value: 0,
			colspan: 3,
//			labelWidth: 140,
			holdable: 'hold'
		},{
			fieldLabel: '출고창고',
			name: 'WH_CODE',
			xtype:'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList'),
			child: 'WH_CELL_CODE',
			holdable: 'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					masterForm.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel: '출고창고Cell',
			name: 'WH_CELL_CODE',
			xtype:'uniCombobox',
			store: Ext.data.StoreManager.lookup('whCellList'),
//			colspan: 3,
			holdable: 'hold',
//			labelWidth: 140,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					masterForm.setValue('WH_CELL_CODE', newValue);
				}
			}
		}, {
            margin: '0 0 0 95',
            xtype: 'button',
            text: '거래명세서출력',
            id: 'btnPrint',
//            colspan: 2,
            handler: function() {
                if(Ext.isEmpty(masterForm.getValue('INOUT_NUM'))){
                    return false;
                }
                if(UniAppManager.app._needSave())   {
                   alert(Msg.fstMsgH0103);
                   return false;
                }
                var param = masterForm.getValues();
                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/z_yp/s_str103cukrv_yp.do',
                    prgID: 's_str103ukrv_yp',
                    extParam: param
                });
                win.center();
                win.show();
//              var me = this;
////                    var records = masterGrid.getSelectionModel().getSelection();
////                    var record = records[0];
//              var params = {
//                  appId: UniAppManager.getApp().id,
//                  sender: me,
////                        action: 'new',
////                        _EXCEL_JOBID: excelWindow.jobID,
////                        _EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),
//                  PGM_ID: 'str104ukrv',
//                  INOUT_DATE: masterForm.getValue('INOUT_DATE'),
//                  DIV_CODE: UserInfo.divCode,
//                  INOUT_NUM: masterForm.getValue('INOUT_NUM'),
//                  AGENT_TYPE: CustomCodeInfo.gsAgentType,
//                  CUSTOM_CODE: masterForm.getValue('CUSTOM_CODE'),
//                  CUSTOM_NAME: masterForm.getValue('CUSTOM_NAME')
//              }
//              var rec = {data : {prgID : 'str400rkrv', 'text':''}};
//              parent.openTab(rec, '/sales/str400rkrv.do', params);
            }
        },{
			fieldLabel: '출고총액',
			name: 'TOTAL_AMT',
			readOnly: true,
			value: 0,
//			labelWidth: 140,
			xtype:'uniNumberfield',
			holdable: 'hold'
		}
/*		,{
			fieldLabel: '수량총계',
			name: 'TOT_QTY',
			readOnly: true,
			value: 0,
			xtype:'uniNumberfield',
			holdable: 'hold'
		}*/
		],
		setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});
	   				if(invalid.length > 0) {
						r=false;
//	   					var labelText = ''
//
//						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
//	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
//	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
//	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
//	   					}
//
//					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
						//this.mask();
						var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true);
								}
							}
							if(item.isPopupField)	{
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
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
  				}
				return r;
  		}/*,
  		setLoadRecord: function(record)	{
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}*/
  		/*,
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				UniAppManager.setToolbarButtons('save', true);
			}
		}*/
	});

	/**
	 * 수주의 디테일 정보를 가지고 있는 Grid
	 */
	//마스터 모델 정의
	Unilite.defineModel('s_str103ukrv_ypDetailModel', {
		fields: [
				 {name: 'INOUT_SEQ'						, text:'순번'	 				, type: 'int', allowBlank: false},
				 {name: 'CUSTOM_NAME'					, text:'거래처명'	  			, type: 'string'},
				 {name: 'INOUT_TYPE_DETAIL'				, text:'출고유형'	   			, type: 'string', comboType: 'AU', comboCode: 'S007', allowBlank: false, defaultValue: Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value')},
				 {name: 'WH_CODE'						, text:'출고창고'	  			, type: 'string', store: Ext.data.StoreManager.lookup('whList'), allowBlank: false, child: 'WH_CELL_CODE'},
				 {name: 'WH_NAME'						, text:'출고창고명'	   			, type: 'string'},
				 {name: 'WH_CELL_CODE'					, text:'출고창고 Cell'	   	, type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','SALE_DIV_CODE']},
				 {name: 'WH_CELL_NAME'					, text:'출고창고 Cell'	   		, type: 'string'},
				 {name: 'SALE_DIV_CODE'					, text:'매출사업장'	   			, type: 'string', allowBlank: false, child: 'WH_CODE'},////확인해봐야함
				 {name: 'ITEM_CODE'						, text:'품목코드'	   			, type: 'string', allowBlank: false},
				 {name: 'ITEM_NAME'						, text:'품목명'	  				, type: 'string'},
				 {name: 'SPEC'							, text:'규격'	 				, type: 'string'},
				 {name: 'LOT_NO'						, text:'LOT NO'					, type: 'string', allowBlank: true},
				 {name: 'ITEM_STATUS'					, text:'품목상태'	   			, type: 'string', comboType: 'AU', comboCode: 'B021', defaultValue: "1", allowBlank: false},
				 {name: 'ORDER_UNIT'					, text:'판매단위'	   			, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'B013', displayField: 'value'},
				 {name: 'PRICE_TYPE'					, text:'단가구분'				   , type: 'string', defaultValue: BsaCodeInfo.gsPriceGubun},
				 {name: 'TRANS_RATE'					, text: '<t:message code="Mpo501.label.TRNS_RATE" default="입수"/>'  ,type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
//				 	{name: 'TRANS_RATE'					, text:'입수'	 				, type: 'uniQty', defaultValue: 1, allowBlank: false},
				 {name: 'ORDER_UNIT_Q'					, text:'출고량'	  				, type: 'uniQty', defaultValue: 0, allowBlank: false},
				 {name: 'TEMP_ORDER_UNIT_Q'				, text:'TEMP_ORDER_UNIT_Q'	  , type: 'uniQty'},//LOT팝업에서 허용된 수량만 입력하기 위해..
				 {name: 'ORDER_UNIT_P'					, text:'단가'	 				, type: 'uniUnitPrice', defaultValue: 0, allowBlank: false, editable: true},
				 {name: 'INOUT_WGT_Q'					, text:'출고량(중량)'   			, type: 'uniQty', defaultValue: 0},
				 {name: 'INOUT_FOR_WGT_P'				, text:'단가(중량)'   				, type: 'uniUnitPrice', defaultValue: 0},
				 {name: 'INOUT_VOL_Q'					, text:'출고량(부피)'   			, type: 'uniQty', defaultValue: 0},
				 {name: 'INOUT_FOR_VOL_P'				, text:'단가(부피)'   				, type: 'uniUnitPrice', defaultValue: 0},
				 {name: 'INOUT_WGT_P'					, text:'자사단가(중량)'   			, type: 'uniUnitPrice', defaultValue: 0},
				 {name: 'INOUT_VOL_P'					, text:'자사단가(부피)'   			, type: 'uniUnitPrice', defaultValue: 0},
				 {name: 'ORDER_UNIT_O'					, text:'금액'	 				, type: 'uniPrice', defaultValue: 0, allowBlank: false},
				 {name: 'ORDER_AMT_SUM'					, text:'합계금액'	 				, type: 'uniPrice', defaultValue: 0},
				 {name: 'TAX_TYPE'						, text:'과세구분'	   			, type: 'string', comboType: 'AU', comboCode: 'B059', defaultValue: "1", allowBlank: false},
				 {name: 'INOUT_TAX_AMT'					, text:'부가세액'	   			, type: 'uniPrice', defaultValue: 0, allowBlank: true},
				 {name: 'WGT_UNIT'						, text:'중량단위'   				, type: 'string', defaultValue: BsaCodeInfo.gsWeight},
				 {name: 'UNIT_WGT'						, text:'단위중량'   				, type: 'int', defaultValue: 0},
				 {name: 'VOL_UNIT'						, text:'부피단위'   				, type: 'string', defaultValue: BsaCodeInfo.gsVolume},
				 {name: 'UNIT_VOL'						, text:'단위부피'   				, type: 'string', defaultValue: 0},
				 {name: 'TRANS_COST'					, text:'운반비'	  				, type: 'uniPrice', defaultValue: 0},
				 {name: 'DISCOUNT_RATE'					, text:'할인율(%)'	  			, type: 'uniPercent', defaultValue: 0},
				 {name: 'STOCK_Q'						, text:'재고수량'	   			, type: 'uniQty'},
				 {name: 'ORDER_STOCK_Q'				 , text:'단위재고수량'			, type: 'uniQty'},
				 {name: 'PRICE_YN'						, text:'단가구분'	   			, type: 'string', comboType: 'AU', comboCode: 'S003', defaultValue: "2", allowBlank: false},
				 {name: 'ACCOUNT_YNC'					, text:'매출대상'	   			, type: 'string', comboType: 'AU', comboCode: 'S014', defaultValue: "Y", allowBlank: false},
				 {name: 'DELIVERY_DATE'					, text:'납품일'	  				, type: 'uniDate'},
				 {name: 'DELIVERY_TIME'					, text:'납품시간'	   			, type: 'string'},
				 {name: 'RECEIVER_ID'					, text:'수신자코드'				, type: 'string'},
				 {name: 'RECEIVER_NAME'	  			, text:'수신자'	  				, type: 'string'},
				 {name: 'TELEPHONE_NUM1'	 			, text:'전화번호'	   			, type: 'string'},
				 {name: 'TELEPHONE_NUM2'	 			, text:'전화번호'	   			, type: 'string'},
				 {name: 'ADDRESS'						, text:'주소'	 				, type: 'string'},
				 {name: 'SALE_CUST_CD'					, text:'매출처'	  				, type: 'string', allowBlank: false},////매출처 defaultValue 다시 분석
				 {name: 'SALE_PRSN'						, text:'영업담당'   				, type: 'string', comboType: 'AU', comboCode: 'S010'}, ////거래처의 주영업담당
				 {name: 'DVRY_CUST_CD'					, text:'배송처'	   			, type: 'string'},
				 {name: 'DVRY_CUST_NAME'				, text:'배송처'	  				, type: 'string'},
				 {name: 'ORDER_CUST_CD'					, text:'수주처'	  				, type: 'string'},
				 {name: 'PLAN_NUM'						, text:'프로젝트번호'	  			, type: 'string'},
				 {name: 'ORDER_NUM'						, text:'수주번호'	   			, type: 'string'},
				 {name: 'ISSUE_REQ_NUM'					, text:'출하번호'	   			, type: 'string'},
				 {name: 'BASIS_NUM'						, text:'P/O NO'	   			, type: 'string'},
				 {name: 'PAY_METHODE1'					, text:'대금결제방법'   			, type: 'string'},
				 {name: 'LC_SER_NO'						, text:'LC번호'   				, type: 'string'},
				 {name: 'REMARK'						, text:'비고'   					, type: 'string'},
//				 {name: 'LOT_ASSIGNED_YN'				, text:'LOT_ASSIGNED_YN'   		, type: 'string', defaultValue: "N"},	//lot팝업에서 선택시 Y로 set..
				 {name: 'INOUT_NUM'						, text:'INOUT_NUM'			   	, type: 'string'},
				 {name: 'INOUT_DATE'					, text:'INOUT_DATE'		   		, type: 'uniDate', allowBlank: false},
				 {name: 'INOUT_METH'					, text:'INOUT_METH'		   		, type: 'string', defaultValue: "2", allowBlank: false},
				 {name: 'INOUT_TYPE'					, text:'INOUT_TYPE'		   		, type: 'string', defaultValue: "2", allowBlank: false},
				 {name: 'DIV_CODE'						, text:'DIV_CODE'			   	, type: 'string', allowBlank: false},
				 {name: 'INOUT_CODE_TYPE'				, text:'INOUT_CODE_TYPE'	   	, type: 'string', defaultValue: "4", allowBlank: false},
				 {name: 'INOUT_CODE'					, text:'INOUT_CODE'		   		, type: 'string', allowBlank: false},
				 {name: 'SALE_CUSTOM_CODE'				, text:'SALE_CUSTOM_CODE'   	, type: 'string', allowBlank: false},
				 {name: 'CREATE_LOC'					, text:'CREATE_LOC'		   		, type: 'string', allowBlank: false},
				 {name: 'UPDATE_DB_USER'				, text:'UPDATE_DB_USER'	   		, type: 'string', defaultValue: UserInfo.userID},
				 {name: 'UPDATE_DB_TIME'				, text:'UPDATE_DB_TIME'	   		, type: 'string'},
				 {name: 'MONEY_UNIT'					, text:'MONEY_UNIT'		   		, type: 'string', allowBlank: false},
				 {name: 'EXCHG_RATE_O'					, text:'EXCHG_RATE_O'		   	, type: 'int', allowBlank: false, defaultValue: 1},
				 {name: 'ORIGIN_Q'						, text:'ORIGIN_Q'			   	, type: 'uniQty'},
				 {name: 'ORDER_NOT_Q'					, text:'ORDER_NOT_Q'		   	, type: 'uniQty'},
				 {name: 'ISSUE_NOT_Q'					, text:'ISSUE_NOT_Q'		   	, type: 'uniQty'},
				 {name: 'ORDER_SEQ'						, text:'ORDER_SEQ'			   	, type: 'int'},
				 {name: 'ISSUE_REQ_SEQ'					, text:'ISSUE_REQ_SEQ'		   	, type: 'uniQty'},
				 {name: 'BASIS_SEQ'						, text:'BASIS_SEQ'			   	, type: 'int'},
				 {name: 'ORDER_TYPE'					, text:'ORDER_TYPE'		   		, type: 'string'},
				 {name: 'STOCK_UNIT'					, text:'STOCK_UNIT'		   		, type: 'string'},
				 {name: 'BILL_TYPE'						, text:'BILL_TYPE'			   	, type: 'string', defaultValue: "10", allowBlank: false},
				 {name: 'SALE_TYPE'						, text:'SALE_TYPE'			   	, type: 'string', allowBlank: false},
				 {name: 'CREDIT_YN'						, text:'CREDIT_YN'			   	, type: 'string', defaultValue: BsaCodeInfo.gsCustCreditYn},
				 {name: 'ACCOUNT_Q'						, text:'ACCOUNT_Q'			   	, type: 'uniQty', defaultValue: 0},
				 {name: 'SALE_C_YN'						, text:'SALE_C_YN'			   	, type: 'string', defaultValue: "N"},
				 {name: 'INOUT_PRSN'					, text:'INOUT_PRSN'		   		, type: 'string'},
				 {name: 'WON_CALC_BAS'					, text:'WON_CALC_BAS'		   	, type: 'string', defaultValue: BsaCodeInfo.gsUnderCalBase},
				 {name: 'TAX_INOUT'						, text:'TAX_INOUT'			   	, type: 'string'},
				 {name: 'AGENT_TYPE'					, text:'AGENT_TYPE'		   		, type: 'string', defaultValue: BsaCodeInfo.gsAgentType},
				 {name: 'STOCK_CARE_YN'					, text:'STOCK_CARE_YN'		   	, type: 'string'},
				 {name: 'RETURN_Q_YN'					, text:'RETURN_Q_YN'		   	, type: 'string'},
				 {name: 'REF_CODE2'						, text:'REF_CODE2'			 	, type: 'string'}, ////defaultValue: INOUT_TYPE_DETAIL(출고유형)의 SUB_CODE를들고REF_CODE2를 참조해옴
				 {name: 'EXCESS_RATE'					, text:'EXCESS_RATE'		   	, type: 'int'},
				 {name: 'SRC_ORDER_Q'					, text:'SRC_ORDER_Q'		   	, type: 'string'},
				 {name: 'SOF110T_PRICE'					, text:'SOF110T_PRICE'		   	, type: 'uniPrice'},
				 {name: 'SRQ100T_PRICE'					, text:'SRQ100T_PRICE'		   	, type: 'uniPrice'},
				 {name: 'COMP_CODE'						, text:'COMP_CODE'			   	, type: 'string', defaultValue: UserInfo.compCode, allowBlank: false },
				 {name: 'DEPT_CODE'						, text:'DEPT_CODE'			   	, type: 'string'},
				 {name: 'ITEM_ACCOUNT'	   			, text:'ITEM_ACCOUNT'	   	, type: 'string'},
				 {name: 'GUBUN'							, text:'GUBUN'				 	, type: 'string'},
				 {name: 'SALE_BASIS_P'					, text:'판매단가'				 	, type: 'uniUnitPrice', editable: false},
//				 {name: 'PURCHASE_RATE'					, text:'매입율'				 	, type: 'uniPercent', editable: false},
//				 {name: 'PURCHASE_P'					, text:'매입가'				 	, type: 'uniUnitPrice', editable: false},
//				 {name: 'SALES_TYPE'					, text:'판매형태'				 	, type: 'string', comboType:'AU', comboCode:'YP09', editable: false},
//				 {name: 'PURCHASE_CUSTOM_CODE'			, text:'매입처'				 	, type: 'string', comboType:'AU', editable: false},
//				 {name: 'PURCHASE_TYPE'					, text:'매입조건'				 	, type: 'string', comboType:'AU', comboCode:'YP09', editable: false},
				 {name: 'LOT_YN'						, text:'LOT_YN'				 , type: 'string'},
				 {name: 'NATION_INOUT'				  , text:'NATION_INOUT'		   , type: 'string'},
				 {name: 'SALE_DATE'					 , text:'SALE_DATE'			  , type: 'uniDate'},
				 {name: 'WONSANGI_NUM'					 , text:'원산지'			  , type: 'string'},
		]
	});
	//마스터 스토어 정의
	var detailStore = Unilite.createStore('s_str103ukrv_ypDetailStore', {
		model: 's_str103ukrv_ypDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},

		proxy: directProxy,
		listeners: {
		   	load: function(store, records, successful, eOpts) {
		   		this.fnOrderAmtSum();
//		   		var viewLocked = detailGrid.lockedGrid.getView();
//				var viewNormal = detailGrid.normalGrid.getView();
//				console.log("viewLocked : ",viewLocked);
//				console.log("viewNormal : ",viewNormal);
//				viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//				viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		   	},
		   	add: function(store, records, index, eOpts) {
		   		this.fnOrderAmtSum();
		   	},
		   	update: function(store, record, operation, modifiedFieldNames, eOpts) {
		   		this.fnOrderAmtSum();
		   	},
		   	remove: function(store, record, index, isMove, eOpts) {
		   		this.fnOrderAmtSum();
		   	}
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success)	{
//						masterForm.setLoadRecord(records[0]);
//						panelResult.setLoadRecord(records[0]);
						Ext.getCmp('btnPrint').setDisabled(false);
					}
				}
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

			var orderNum = masterForm.getValue('INOUT_NUM');
			var isErr = false;
			if(!masterForm.setAllFieldsReadOnly(true)){
				return false;
			}else{
				panelResult.setAllFieldsReadOnly(true);
			}
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != orderNum) {
					record.set('INOUT_NUM', orderNum);
				}
				if(record.get('STOCK_CARE_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + 'LOT NO: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;

//			var totRecords = detailStore.data.items;
//			Ext.each(totRecords, function(record, index) {
//				record.set('SORT_SEQ', index+1);
//			});
			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								var master = batch.operations[0].getResultSet();
								masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
								panelResult.setValue("INOUT_NUM", master.INOUT_NUM);

//								var inoutNum = masterForm.getValue('INOUT_NUM');
//								Ext.each(list, function(record, index) {
//									if(record.data['INOUT_NUM'] != inoutNum) {
//										record.set('INOUT_NUM', inoutNum);
//									}
//								})
								masterForm.getForm().wasDirty = false;
								masterForm.resetDirtyStatus();
								Ext.getCmp('btnPrint').setDisabled(false);//출력버튼 활성화
								UniAppManager.setToolbarButtons('save', false);
								detailStore.loadStoreRecords();
								if(detailStore.getCount() == 0){
									UniAppManager.app.onResetButtonDown();
								}

							 }
					};
				this.syncAllDirect(config);
			}else{
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnOrderAmtSum: function() {
//			alert(this.countBy(function(record, id){
//										return record.get('TAX_TYPE') == '1';}));
			var dtotQty	 = 0;
			var dSaleTI 	= 0;
			var dSaleNTI 	= 0;
			var dTaxI 		= 0;

			var results = this.sumBy(function(record, id){
										return record.get('TAX_TYPE') == '1';},
									['ORDER_UNIT_O','INOUT_TAX_AMT']);
			dSaleTI = results.ORDER_UNIT_O;
			dTaxI	= results.INOUT_TAX_AMT;
			console.log("과세 - 과세된총액:"+dSaleTI);		//과세된총액
			console.log("과세 - 부가세총액:"+dTaxI);		//부가세총액

			var results = this.sumBy(function(record, id){
										return record.get('TAX_TYPE') == '2';},
									['ORDER_UNIT_O']);
			dSaleNTI = results.ORDER_UNIT_O;
			console.log("면세 - 면세된총액:"+dSaleNTI);	//면세된총액

//			this.filter([	//과세
//				{filterFn: function(record) { return record.get("TAX_TYPE") == "1"; }}
//			]);
//			var dSaleTI = Ext.isNumeric(this.sum('ORDER_UNIT_O')) ? this.sum('ORDER_UNIT_O'):0;	//총과세액
//			var dTaxI = Ext.isNumeric(this.sum('INOUT_TAX_AMT')) ? this.sum('INOUT_TAX_AMT'):0; //총세액
//			console.log("과세 - 과세된총액:"+dSaleTI);	//과세된총액
//			console.log("과세 - 부가세총액:"+dTaxI);		//부가세총액
//			this.clearFilter();
//
//
//			this.filter([	//면세
//				{filterFn: function(record) { return record.get("TAX_TYPE") == "2"; }}
//			]);
//			dSaleNTI = Ext.isNumeric(this.sum('ORDER_UNIT_O')) ? this.sum('ORDER_UNIT_O'):0 //총면세액
//			this.clearFilter();
//			console.log("면세 - 면세된총액:"+dSaleNTI);	//면세된총액

			dtotQty = Ext.isNumeric(this.sum('ORDER_UNIT_Q')) ? this.sum('ORDER_UNIT_Q'):0; //수량총계
			masterForm.setValue('TOT_SALE_TAXI',dSaleTI); 	   						//과세총액(1)
			masterForm.setValue('TOT_SALENO_TAXI',dSaleNTI);	 					//면세총액(3)
			masterForm.setValue('TOT_TAXI',dTaxI);   		   						//세액합계(2)
			masterForm.setValue('TOTAL_AMT',dSaleTI + dSaleNTI + dTaxI);   			//출고총액
//			masterForm.setValue('TOT_QTY',dtotQty);   		   						//수량총계

			panelResult.setValue('TOT_SALE_TAXI',dSaleTI);							//과세총액(1)
			panelResult.setValue('TOT_SALENO_TAXI',dSaleNTI);						//면세총액(3)
			panelResult.setValue('TOT_TAXI',dTaxI);								  //세액합계(2)
			panelResult.setValue('TOTAL_AMT',dSaleTI + dSaleNTI + dTaxI);			//출고총액
//			panelResult.setValue('TOT_QTY',dtotQty);								 //수량총계

			masterForm.fnCreditCheck();

//			var firstRecord1 = this.getAt(0);
//			var firstRecord2 = this.first(false);
//
//			console.log('first record1 ORDER_UNIT_O'+ firstRecord1.get('ORDER_UNIT_O'));
//			console.log('first record2 ORDER_UNIT_O'+ firstRecord2.get('ORDER_UNIT_O'));

		}
	});
 	//마스터 그리드 정의
	var detailGrid = Unilite.createGrid('s_str103ukrv_ypGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			copiedRow: true
		},
		tbar: [{
			xtype: 'splitbutton',
		   	itemId:'refTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId : 'refBtn',
					text:'수주(오퍼)참조',
					handler: function() {
						if(BsaCodeInfo.useLotAssignment == "Y"){
							if(Ext.isEmpty(masterForm.getValue('WH_CODE'))){
								alert('출고창고를 선택해 주세요.');
								return false;
							}else if(Ext.isEmpty(masterForm.getValue('WH_CELL_CODE'))){
								alert('출고창고 Cell을 선택해 주세요.');
								return false;
							}
						}
						opensalesOrderWindow();
						}
		   		 },{
					itemId: 'requestBtn',
					text: '출하지시참조',
					handler: function() {
						openRequestWindow();
						}
				}/*, {
					itemId: 'scmBtn',
					text: '업체발주참조(SCM)',
					handler: function() {
							openScmWindow();
						}
				}, {
					itemId: 'excelBtn',
					text: '엑셀참조',
					handler: function() {
							openExcelWindow();
						}
				}*/]
			})
		}],
	   features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
				   {id : 'masterGridTotal',	ftype: 'uniSummary',	  showSummaryRow: true} ],
		store: detailStore,
		columns: [
				  {dataIndex: 'INOUT_SEQ'					,		width:60, hidden: false },
				  {dataIndex: 'CUSTOM_NAME'					,		width:133, hidden: true},
				  {dataIndex: 'INOUT_TYPE_DETAIL'			,		width:80},
				  {dataIndex: 'WH_CODE'						,		width:93},
				  {dataIndex: 'WH_NAME'						,		width:93, hidden: true},
				  {dataIndex: 'WH_CELL_CODE'				,		width:120, hidden: sumtypeCell},
				  {dataIndex: 'WH_CELL_NAME'				,		width:100, hidden: true },
				  {dataIndex: 'SALE_DIV_CODE'				,		width:100, hidden: true },
				  {dataIndex: 'ITEM_CODE'					,		width:113,
				  	editor: Unilite.popup('DIV_PUMOK_G', {
				 	 				textFieldName: 'ITEM_CODE',
				 	 				DBtextFieldName: 'ITEM_CODE',
				 	 				useBarcodeScanner: false,
				 	 				autoPopup:true,
//				 	 				extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
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
											},
											applyextparam: function(popup){
												var divCode = masterForm.getValue('DIV_CODE');
												popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
											}
									}
					 })
				  },
				  {dataIndex: 'ITEM_NAME'					,		width:200,
				  	editor: Unilite.popup('DIV_PUMOK_G', {
//			 		  				extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
				  					autoPopup:true,
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
											},
											applyextparam: function(popup){
												var divCode = masterForm.getValue('DIV_CODE');
												popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
											}
									}
					})
				  },
				  {dataIndex: 'SPEC'						,		width:150 },
				  {dataIndex: 'LOT_NO'						,		width:120,
				  editor: Unilite.popup('LOTNO_YP_G', {
	 							textFieldName: 'LOTNO_CODE',
	 							DBtextFieldName: 'LOTNO_CODE',
	 							validateBlank: false,
	 							autoPopup:true,
								listeners: {'onSelected': {
									fn: function(records, type) {

											var rtnRecord;
											Ext.each(records, function(record,i) {
												if(i==0){
													rtnRecord = detailGrid.uniOpt.currentRecord
												}else{
													rtnRecord = detailGrid.getSelectedRecord()
												}
												rtnRecord.set('LOT_NO', record['LOT_NO']);
												rtnRecord.set('TEMP_ORDER_UNIT_Q', record['STOCK_Q']);
//												rtnRecord.set('ORDER_UNIT_Q', 0);

												rtnRecord.set('WH_CODE', record['WH_CODE']);
												rtnRecord.set('WH_CELL_CODE', record['WH_CELL_CODE']);
//												rtnRecord.set('SALE_BASIS_P', record['SALE_BASIS_P']);
//												rtnRecord.set('LOT_ASSIGNED_YN', 'Y');
//												rtnRecord.set('PURCHASE_RATE', record['PURCHASE_RATE']);
//												rtnRecord.set('PURCHASE_P', record['PURCHASE_P']);
//												rtnRecord.set('SALES_TYPE', record['SALES_TYPE']);
//												rtnRecord.set('PURCHASE_CUSTOM_CODE', record['CUSTOM_CODE']);
//												rtnRecord.set('PURCHASE_TYPE', record['PURCHASE_TYPE']);
//												if(i==0) {
//													detailGrid.setLotData(record,false);
//												}
											});
										},
									scope: this
									},
									'onClear': function(type) {
										var rtnRecord = detailGrid.uniOpt.currentRecord;
										rtnRecord.set('LOT_NO', '');
										rtnRecord.set('LOT_ASSIGNED_YN', 'N');
										rtnRecord.set('TEMP_ORDER_UNIT_Q', '');
									},
									applyextparam: function(popup){
										var record = detailGrid.getSelectedRecord();
										var divCode = masterForm.getValue('DIV_CODE');
										var itemCode = record.get('ITEM_CODE');
										var itemName = record.get('ITEM_NAME');
										var whCode = record.get('WH_CODE');
										var whCellCode = record.get('WH_CELL_CODE');
										var stockYN = 'Y'
										popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCellCode, 'STOCK_YN': stockYN});
									}
								}
						})
				  },
//				  {dataIndex: 'SALE_BASIS_P'				,		width:90 },
				  {dataIndex: 'DISCOUNT_RATE'				,		width:80 },
				  {dataIndex: 'ORDER_UNIT'				  ,	   width:80, align: 'center',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
					}
				  },
				  {dataIndex: 'ITEM_STATUS'				 ,	   width:80, align: 'center' },
				  {dataIndex: 'ORDER_UNIT_Q'				,	   width:93, summaryType: 'sum' },
				  {dataIndex: 'TRANS_RATE'				  ,	   width:60 },
				  {dataIndex: 'ORDER_UNIT_P'				,		width:100, summaryType: 'sum' },
				  {dataIndex: 'ORDER_UNIT_O'				,		width:120, summaryType: 'sum' },
				  {dataIndex: 'INOUT_TAX_AMT'				,		width:120, summaryType: 'sum' },
				  {dataIndex: 'ORDER_AMT_SUM'				,		width:120, summaryType: 'sum' },
				  {dataIndex: 'TAX_TYPE'					,		width:80, align: 'center' },
				  {dataIndex: 'STOCK_Q'						,		width:100, summaryType: 'sum' },
				  {dataIndex: 'ORDER_STOCK_Q'			    ,	   width:100, summaryType: 'sum' },
//				  {dataIndex: 'PURCHASE_RATE'				,		width:90 },
//				  {dataIndex: 'PURCHASE_P'					,		width:90 },
				  {dataIndex: 'SALE_PRSN'					,		width:80, align: 'center' },
//				  {dataIndex: 'SALES_TYPE'					,		width:70 },
				  {dataIndex: 'PRICE_TYPE'					,		width:110, hidden: true },
				  {dataIndex: 'INOUT_WGT_Q'					,		width:106, hidden: true },
				  {dataIndex: 'INOUT_FOR_WGT_P'				,		width:106, hidden: true },
				  {dataIndex: 'INOUT_VOL_Q'					,		width:106, hidden: true },
				  {dataIndex: 'INOUT_FOR_VOL_P'				,		width:106, hidden: true },
				  {dataIndex: 'INOUT_WGT_P'					,		width:106, hidden: true },
				  {dataIndex: 'INOUT_VOL_P'					,		width:106, hidden: true },
				  {dataIndex: 'WGT_UNIT'					,		width:66, hidden: true },
				  {dataIndex: 'UNIT_WGT'					,		width:100, hidden: true },
				  {dataIndex: 'VOL_UNIT'					,		width:80, hidden: true },
				  {dataIndex: 'UNIT_VOL'					,		width:93, hidden: true },
				  {dataIndex: 'TRANS_COST'					,		width:93, summaryType: 'sum' },
				  {dataIndex: 'PRICE_YN'					,		width:73, align: 'center' },
				  {dataIndex: 'ACCOUNT_YNC'					,		width:73, align: 'center' },
				  {dataIndex: 'DELIVERY_DATE'				,		width:80 },
				  {dataIndex: 'DELIVERY_TIME'				,		width:66, hidden: manageTimeYN },
				  {dataIndex: 'RECEIVER_ID'					,		width:86, hidden: true },
				  {dataIndex: 'RECEIVER_NAME'	  			,		width:86, hidden: true },
				  {dataIndex: 'TELEPHONE_NUM1'	 			,		width:80, hidden: true },
				  {dataIndex: 'TELEPHONE_NUM2'	 			,		width:80, hidden: true },
				  {dataIndex: 'ADDRESS'						,		width:133, hidden: true },
				  {dataIndex: 'SALE_CUST_CD',  	width: 110,
			 		editor: Unilite.popup('AGENT_CUST_G',{autoPopup:true,listeners:{ 'onSelected': {
																		fn: function(records, type  ){
																			//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
																			var grdRecord = detailGrid.uniOpt.currentRecord;
																			grdRecord.set('SALE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
																			grdRecord.set('SALE_CUST_CD',records[0]['CUSTOM_NAME']);
																		},
																		scope: this
															  	   },
																	  'onClear' : function(type)	{
																	  		//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
																	  		var grdRecord = detailGrid.uniOpt.currentRecord;
																			grdRecord.set('SALE_CUSTOM_CODE','');
																			grdRecord.set('SALE_CUST_CD','');
																	  },
																	applyextparam: function(popup){
																		popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
																		popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
																	}
														}
										})
				},
				  {dataIndex: 'DVRY_CUST_CD'				,		width:113, hidden: true },
				  {dataIndex: 'DVRY_CUST_NAME'				,		width:113,
						editor: Unilite.popup('DELIVERY_G',{autoPopup:true,listeners:{ 'onSelected': {
								fn: function(records, type  ){
									//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
									var grdRecord = detailGrid.uniOpt.currentRecord;
									grdRecord.set('DVRY_CUST_CD',records[0]['DELIVERY_CODE']);
									grdRecord.set('DVRY_CUST_NAME',records[0]['DELIVERY_NAME']);
								},
								scope: this
							  },
							  'onClear' : function(type)	{
									//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
									var grdRecord = detailGrid.uniOpt.currentRecord;
									grdRecord.set('DVRY_CUST_CD','');
									grdRecord.set('DVRY_CUST_NAME','');
							  },
								applyextparam: function(popup){
									popup.setExtParam({'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')});
								}
							}
					})
				  },
				  {dataIndex: 'ORDER_CUST_CD'				,		width:113 },
				  {dataIndex: 'PLAN_NUM'					,		width:100 },
				  {dataIndex: 'ORDER_NUM'					,		width:120 },
				  {dataIndex: 'ISSUE_REQ_NUM'				,		width:100 },
				  {dataIndex: 'BASIS_NUM'					,		width:100 },
				  {dataIndex: 'PAY_METHODE1'				,		width:200 },
				  {dataIndex: 'LC_SER_NO'					,		width:100 },
				  {dataIndex: 'WONSANGI_NUM'					,		width:100 },
				  {dataIndex: 'REMARK'						,		width:100 },
				  {dataIndex: 'LOT_ASSIGNED_YN'				,		width:100,hidden: true },
				  {dataIndex: 'INOUT_NUM'					,		width:80, hidden: true },
				  {dataIndex: 'INOUT_DATE'					,		width:66, hidden: true },
				  {dataIndex: 'INOUT_METH'					,		width:66, hidden: true },
				  {dataIndex: 'INOUT_TYPE'					,		width:66, hidden: true },
				  {dataIndex: 'DIV_CODE'					,		width:66, hidden: true },
				  {dataIndex: 'INOUT_CODE_TYPE'				,		width:66, hidden: true },
				  {dataIndex: 'INOUT_CODE'					,		width:66, hidden: true },
				  {dataIndex: 'SALE_CUSTOM_CODE'			,		width:66, hidden: true },
				  {dataIndex: 'CREATE_LOC'					,		width:66, hidden: true },
				  {dataIndex: 'UPDATE_DB_USER'				,		width:66, hidden: true },
				  {dataIndex: 'UPDATE_DB_TIME'				,		width:66, hidden: true },
				  {dataIndex: 'MONEY_UNIT'					,		width:66, hidden: true },
				  {dataIndex: 'EXCHG_RATE_O'				,		width:66, hidden: true },
				  {dataIndex: 'ORIGIN_Q'					,		width:66, hidden: true },
				  {dataIndex: 'ORDER_NOT_Q'					,		width:66, hidden: true },
				  {dataIndex: 'ISSUE_NOT_Q'					,		width:66, hidden: true },
				  {dataIndex: 'ORDER_SEQ'					,		width:66, hidden: true },
				  {dataIndex: 'ISSUE_REQ_SEQ'				,		width:66, hidden: true },
				  {dataIndex: 'BASIS_SEQ'					,		width:66, hidden: true },
				  {dataIndex: 'ORDER_TYPE'					,		width:66, hidden: true },
				  {dataIndex: 'STOCK_UNIT'					,		width:66, hidden: true },
				  {dataIndex: 'BILL_TYPE'					,		width:66, hidden: true },
				  {dataIndex: 'SALE_TYPE'					,		width:66, hidden: true },
				  {dataIndex: 'CREDIT_YN'					,		width:66, hidden: true },
				  {dataIndex: 'ACCOUNT_Q'					,		width:66, hidden: true },
				  {dataIndex: 'SALE_C_YN'					,		width:66, hidden: true },
				  {dataIndex: 'INOUT_PRSN'					,		width:66, hidden: true },
				  {dataIndex: 'WON_CALC_BAS'				,		width:66, hidden: true },
				  {dataIndex: 'TAX_INOUT'					,		width:66, hidden: true },
				  {dataIndex: 'AGENT_TYPE'					,		width:66, hidden: true },
				  {dataIndex: 'STOCK_CARE_YN'				,		width:66, hidden: true },
				  {dataIndex: 'RETURN_Q_YN'					,		width:66, hidden: true },
				  {dataIndex: 'REF_CODE2'					,		width:66, hidden: true },
				  {dataIndex: 'EXCESS_RATE'					,		width:66, hidden: true },
				  {dataIndex: 'SRC_ORDER_Q'					,		width:66, hidden: true },
				  {dataIndex: 'SOF110T_PRICE'				,		width:66, hidden: true },
				  {dataIndex: 'SRQ100T_PRICE'				,		width:66, hidden: true },
				  {dataIndex: 'COMP_CODE'					,		width:66, hidden: true },
				  {dataIndex: 'DEPT_CODE'					,		width:66, hidden: true },
				  {dataIndex: 'ITEM_ACCOUNT'	   			,		width:66, hidden: true },
				  {dataIndex: 'GUBUN'						,		width:66, hidden: true },
				  {dataIndex: 'TEMP_ORDER_UNIT_Q'			,		width:66, hidden: true },
//				  {dataIndex: 'PURCHASE_CUSTOM_CODE'		,		width:66, hidden: true },
//				  {dataIndex: 'PURCHASE_TYPE'				,		width:66, hidden: true },
				  {dataIndex: 'LOT_YN'					  ,	   width:66, align:'center', hidden: true},
				  {dataIndex: 'NATION_INOUT'				,	   width:66, hidden: true},
				  {dataIndex: 'SALE_DATE'				   ,	   width:66, hidden: true}
		],
		listeners: {
	  		beforeedit  : function( editor, e, eOpts ) {
//	  			cbStore.loadStoreRecords(e.record.get('WH_CODE'));
//	  			var record = detailGrid.uniOpt.currentRecord;
				//LOT_NO POPUP에서 출고창고 필수조건 아님(20171211 수정)
	  			if (UniUtils.indexOf(e.field, 'LOT_NO')){
//  					if(Ext.isEmpty(e.record.data.WH_CODE)){
//						alert('출고창고를 입력하십시오.');
//						return false;
//					}
					if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
						alert('출고창고 CELL코드를 입력하십시오.');
						return false;
					}
					if(Ext.isEmpty(e.record.data.ITEM_CODE)){
						alert(Msg.sMS003);
						return false;
					}
  				}
	  			if(e.record.phantom){			//신규일때
	  				if(e.record.data.INOUT_METH == '2'){	//예외등록(추가버튼)
						 if (UniUtils.indexOf(e.field,
											['SPEC', 'STOCK_Q', 'ORDER_CUST_CD', 'PLAN_NUM', 'ORDER_NUM', 'ISSUE_REQ_NUM', 'BASIS_NUM',
											 /*'PRICE_YN',*/ 'TRANS_RATE']))
							return false;

						if(e.record.data.ACCOUNT_YNC == 'N'){//매출대상이 아닌 경우, 쓰기 불가
							if (UniUtils.indexOf(e.field,
											['ORDER_UNIT_P', 'ORDER_UNIT_O', 'INOUT_TAX_AMT']))
								return false;
						}

						if(!Ext.isEmpty(e.record.data.GUBUN)){
							if (UniUtils.indexOf(e.field,
											['PRICE_TYPE', 'WGT_UNIT', 'VOL_UNIT']))
								return false;
						}

	  				}else{	//INOUT_METH = '1'	//참조등록
	  					if (UniUtils.indexOf(e.field,
											['INOUT_WGT_P', 'INOUT_VOL_P', 'UNIT_WGT', 'UNIT_VOL', 'INOUT_WGT_P', 'INOUT_VOL_P', 'UNIT_WGT', 'UNIT_VOL',
											 'CUSTOM_NAME', 'CUSTOM_NAME', 'ITEM_CODE',
											 'ITEM_NAME', 'SPEC', 'ORDER_UNIT', 'TRANS_RATE', 'TAX_TYPE', 'DISCOUNT_RATE', 'STOCK_Q',
											 'DELIVERY_DATE', 'DELIVERY_TIME', 'RECEIVER_ID', 'RECEIVER_NAME', 'TELEPHONE_NUM1', 'TELEPHONE_NUM2',
											 'ADDRESS', 'SALE_CUST_CD', 'DVRY_CUST_CD', 'DVRY_CUST_NAME', 'ORDER_CUST_CD', 'PLAN_NUM', 'ORDER_NUM',
											 'ORDER_NUM', 'ISSUE_REQ_NUM', 'BASIS_NUM', 'PAY_METHODE1'	, 'LC_SER_NO', 'INOUT_NUM', 'INOUT_DATE', 'INOUT_METH',
											 'INOUT_TYPE', 'DIV_CODE', 'INOUT_CODE_TYPE', 'INOUT_CODE', 'SALE_CUSTOM_CODE', 'CREATE_LOC', 'UPDATE_DB_USER',
											 'UPDATE_DB_TIME', 'MONEY_UNIT', 'EXCHG_RATE_O', 'ORIGIN_Q', 'ORDER_NOT_Q', 'ISSUE_NOT_Q', 'ORDER_SEQ', 'ISSUE_REQ_SEQ',
											 'BASIS_SEQ', 'ORDER_TYPE', 'STOCK_UNIT', 'BILL_TYPE', 'SALE_TYPE', 'CREDIT_YN', 'ACCOUNT_Q', 'SALE_C_YN', 'INOUT_PRSN',
											 'WON_CALC_BAS', 'TAX_INOUT', 'AGENT_TYPE', 'STOCK_CARE_YN', 'RETURN_Q_YN', 'REF_CODE2', 'EXCESS_RATE', 'SRC_ORDER_Q',
											 'SOF110T_PRICE', 'SRQ100T_PRICE', 'COMP_CODE', 'DEPT_CODE', 'ITEM_ACCOUNT', 'GUBUN' ]))
							return false;

	  					if(e.record.data.ACCOUNT_YNC == 'N'){
							if (UniUtils.indexOf(e.field,
											['ORDER_UNIT_P', 'ORDER_UNIT_O']))
								return false;
						}

						if(e.record.data.PRICE_YN == '2'){
							if (UniUtils.indexOf(e.field,
											['PRICE_YN']))
								return false;
						}

//						if(BsaCodeInfo.gsLotNoInputMethod == "Y"){
//							if (UniUtils.indexOf(e.field,
//											['LOT_NO']))
//								return false;
//						}

						if(!Ext.isEmpty(e.record.data.GUBUN)){
							if (UniUtils.indexOf(e.field,
											['PRICE_TYPE', 'WGT_UNIT', 'VOL_UNIT']))
								return false;
						}
	  				}
	  			}else{ //신규가 아닐때
	  				if (UniUtils.indexOf(e.field,
											['INOUT_TYPE_DETAIL', 'TRANS_RATE', 'INOUT_WGT_P', 'INOUT_VOL_P', 'UNIT_WGT', 'UNIT_VOL', 'INOUT_SEQ',
											 'CUSTOM_NAME', 'WH_CODE', 'WH_NAME', 'WH_CELL_CODE', 'WH_CELL_NAME', 'SALE_DIV_CODE', 'ITEM_CODE', 'ITEM_NAME',
											 'SPEC', 'ITEM_STATUS', 'ORDER_UNIT', 'TAX_TYPE', 'INOUT_TAX_AMT', 'STOCK_Q', 'ACCOUNT_YNC', 'RECEIVER_ID',
											 'RECEIVER_NAME', 'TELEPHONE_NUM1', 'TELEPHONE_NUM2', 'ADDRESS', 'SALE_CUST_CD', 'DVRY_CUST_CD', 'DVRY_CUST_NAME',
   											 'ORDER_CUST_CD', 'PLAN_NUM', 'ORDER_NUM', 'ISSUE_REQ_NUM', 'BASIS_NUM', 'PAY_METHODE1', 'LC_SER_NO', 'INOUT_NUM',
   											 'INOUT_DATE', 'INOUT_METH', 'INOUT_TYPE', 'DIV_CODE', 'INOUT_CODE_TYPE', 'INOUT_CODE', 'SALE_CUSTOM_CODE',
		 									 'CREATE_LOC', 'UPDATE_DB_USER', 'UPDATE_DB_TIME', 'MONEY_UNIT', 'EXCHG_RATE_O', 'ORIGIN_Q', 'ORDER_NOT_Q',
											 'ORDER_NOT_Q', 'ISSUE_NOT_Q', 'ORDER_SEQ', 'ISSUE_REQ_SEQ', 'BASIS_SEQ', 'ORDER_TYPE', 'STOCK_UNIT', 'BILL_TYPE',
											 'BILL_TYPE', 'SALE_TYPE', 'CREDIT_YN', 'ACCOUNT_Q', 'SALE_C_YN', 'INOUT_PRSN', 'WON_CALC_BAS', 'TAX_INOUT',
											 'AGENT_TYPE', 'STOCK_CARE_YN', 'RETURN_Q_YN', 'REF_CODE2', 'EXCESS_RATE', 'SRC_ORDER_Q', 'SOF110T_PRICE',
											 'SRQ100T_PRICE', 'COMP_CODE', 'DEPT_CODE', 'ITEM_ACCOUNT', 'GUBUN']))
						return false;

					if(e.record.data.ACCOUNT_YNC == 'N'){	//매출대상이 아닌 경우, 쓰기 불가
							if (UniUtils.indexOf(e.field,
											['ORDER_UNIT_P', 'ORDER_UNIT_O']))
								return false;
						}

					if(e.record.data.PRICE_YN == '2'){
							if (UniUtils.indexOf(e.field,
											['PRICE_YN']))
								return false;
						}

//					if(BsaCodeInfo.gsLotNoInputMethod == "Y"){
//							if (UniUtils.indexOf(e.field,
//											['LOT_NO']))
//								return false;
//						}
					if(!Ext.isEmpty(e.record.data.GUBUN)){
							if (UniUtils.indexOf(e.field,
											['PRICE_TYPE', 'WGT_UNIT', 'VOL_UNIT']))
								return false;
					}
	  			}
	   		}
		},
		setItemData: function(record, dataClear, grdRecord) {
//	   		var grdRecord = this.uniOpt.currentRecord;
	   		if(dataClear) {
	   			grdRecord.set('ITEM_CODE'		,"");
	   			grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('ORDER_UNIT_Q'	,"0");
				grdRecord.set('ORDER_UNIT_P'	,"0");
//				grdRecord.set('SALE_BASIS_P'	,"0");
				grdRecord.set('ORDER_UNIT_O'	,"0");
				grdRecord.set('INOUT_TAX_AMT'	,"0");
				grdRecord.set('STOCK_UNIT'		,"");
//				grdRecord.set('WH_CODE'			,"");
//				grdRecord.set('WH_CELL_CODE'	,"");
//				grdRecord.set('WH_CELL_NAME'	,"");
				grdRecord.set('TAX_TYPE'		,"1");
				grdRecord.set('TRANS_RATE'		,"1");
				grdRecord.set('STOCK_CARE_YN'	,"");
				grdRecord.set('WGT_UNIT'		,"");
				grdRecord.set('UNIT_WGT'		,0);
				grdRecord.set('VOL_UNIT'		,"");
				grdRecord.set('UNIT_VOL'		,0);
				grdRecord.set('INOUT_WGT_Q'		,0);
				grdRecord.set('INOUT_FOR_WGT_P'	,0);
				grdRecord.set('INOUT_WGT_P'		,0);
				grdRecord.set('INOUT_VOL_Q'		,0);
				grdRecord.set('INOUT_FOR_VOL_P'	,0);
				grdRecord.set('INOUT_VOL_P'		,0);
				grdRecord.set('LOT_YN'	 , '');
	   		} else {
	   			var sRefWhCode = ''
	   			if(BsaCodeInfo.gsRefWhCode == "2"){
	   				sRefWhCode = Ext.data.StoreManager.lookup('whList').getAt(0).get('value'); //창고콤보value중 첫번째 value
	   			}
	   			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
	   			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);

				if(Ext.isEmpty(grdRecord.get('WH_CODE'))){		//창고를 이미 입력했을 경우는 창고정보를 적용하지 않는다.
					if(BsaCodeInfo.gsRefWhCode == "2"){			//멀티품목팝업시 출고창고 참조방법 '2'인 경우(2=첫번째행의 출고창고)
						grdRecord.set('WH_CODE', sRefWhCode);
						grdRecord.set('WH_NAME', UniAppManager.app.fnGetWhName(record['WH_CODE']));
//						grdRecord.set('WH_CELL_CODE', '');
//						grdRecord.set('WH_CELL_NAME', '');
						grdRecord.set('LOT_NO', '');
						grdRecord.set('CELL_STOCK_Q', '0');
					}else{										//멀티품목팝업시 출고창고 참조방법 '1'인 경우(1=품목의 주창고)
						grdRecord.set('WH_CODE', record['WH_CODE']);
						grdRecord.set('WH_NAME', UniAppManager.app.fnGetWhName(record['WH_CODE']));
//						grdRecord.set('WH_CELL_CODE', '');
//						grdRecord.set('WH_CELL_NAME', '');
						grdRecord.set('LOT_NO', '');
					}
				}
				grdRecord.set('TAX_TYPE'	 , record['TAX_TYPE']);
				grdRecord.set('STOCK_CARE_YN', record['STOCK_CARE_YN']);
				grdRecord.set('DIV_CODE'	 , record['DIV_CODE']);
				grdRecord.set('ITEM_ACCOUNT' , record['ITEM_ACCOUNT']);
				if((Ext.isEmpty(record['WGT_UNIT']))){
					grdRecord.set('WGT_UNIT'	 , '');
					grdRecord.set('UNIT_WGT'	 , record['UNIT_WGT']);
				}else{
					grdRecord.set('WGT_UNIT'	 , record['WGT_UNIT']);
					grdRecord.set('UNIT_WGT'	 , record['UNIT_WGT']);
				}
				if((Ext.isEmpty(record['VOL_UNIT']))){
					grdRecord.set('VOL_UNIT'	 , '');
					grdRecord.set('UNIT_VOL'	 , record['UNIT_VOL']);
				}else{
					grdRecord.set('VOL_UNIT'	 , record['VOL_UNIT']);
					grdRecord.set('UNIT_VOL'	 , record['UNIT_VOL']);
				}
//				grdRecord.set('SALE_BASIS_P'	,record['SALE_BASIS_P']);
				////Call fnSetLotNoEssential(lRow) 들어가야함
				UniSales.fnGetDivPriceInfo2(grdRecord, UniAppManager.app.cbGetPriceInfo
											,'I'
											,UserInfo.compCode
											,grdRecord.get('INOUT_CODE')
											,grdRecord.get('AGENT_TYPE')
											,grdRecord.get('ITEM_CODE')
											,BsaCodeInfo.gsMoneyUnit
											,grdRecord.get('ORDER_UNIT')
											,grdRecord.get('STOCK_UNIT')
											,grdRecord.get('TRANS_RATE')
											,UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE'))
											,grdRecord.get('ORDER_UNIT_Q')
											,grdRecord.get('WGT_UNIT')
											,grdRecord.get('VOL_UNIT')
											,grdRecord.get('UNIT_WGT')
											,grdRecord.get('UNIT_VOL')
											,grdRecord.get('PRICE_TYPE')
											,grdRecord.get('PRICE_YN')
											)
				if(record['STOCK_CARE_YN'] == "Y"){
					UniSales.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), grdRecord.get('ITEM_STATUS'), grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));
				}
				grdRecord.set('LOT_YN'	 , record['LOT_YN']);
	   		}
		},
		setrequestData:function(record) {
	   		var grdRecord = this.getSelectedRecord();
	   		grdRecord.set('INOUT_TYPE'			, "2");
	   		grdRecord.set('INOUT_METH'			, "1");
	   		grdRecord.set('INOUT_CODE_TYPE'		, "4");
	   		grdRecord.set('CREATE_LOC'			, masterForm.getValue('CREATE_LOC'));
	   		grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
	   		grdRecord.set('INOUT_CODE'			, masterForm.getValue('CUSTOM_CODE'));
	   		grdRecord.set('CUSTOM_NAME'			, masterForm.getValue('CUSTOM_NAME'));
	   		grdRecord.set('INOUT_DATE'			, masterForm.getValue('INOUT_DATE'));
	   		grdRecord.set('INOUT_NUM'			, masterForm.getValue('INOUT_NUM'));
	   		grdRecord.set('REF_CODE2'			, record['REF_CODE2']);
	   		grdRecord.set('WH_CODE'				, record['WH_CODE']);
	   		grdRecord.set('WH_NAME'				, record['WH_CODE']);

	   		if(BsaCodeInfo.gsSumTypeCell == "Y"){
	   			grdRecord.set('WH_CELL_CODE'		, record['WH_CELL_CODE']);
	   			grdRecord.set('WH_CELL_NAME'		, record['WH_CELL_NAME']);
	   		}else{
	   			grdRecord.set('WH_CELL_CODE'		, "");
	   			grdRecord.set('WH_CELL_NAME'		, "");
	   		}

	   		grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
	   		grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
	   		grdRecord.set('SPEC'				, record['SPEC']);
	   		grdRecord.set('ITEM_STATUS'			, "1");
	   		grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
	   		grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
	   		grdRecord.set('ORDER_UNIT_Q'		, record['NOT_REQ_Q']);
	   		grdRecord.set('ORIGIN_Q'			, record['NOT_REQ_Q']);
	   		grdRecord.set('ORDER_NOT_Q'			, "0");
	   		grdRecord.set('ISSUE_NOT_Q'			, record['NOT_REQ_Q']);
	   		grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
	   		grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
	   		grdRecord.set('ACCOUNT_YNC'			, record['ACCOUNT_YNC']);
	   		grdRecord.set('DELIVERY_DATE'		, record['ISSUE_DATE']);
	   		grdRecord.set('SALE_CUSTOM_CODE'	, record['SALE_CUSTOM_CODE']);
	   		grdRecord.set('SALE_CUST_CD'		, record['SALE_CUST_CD']);
	   		grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
	   		grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);
	   		grdRecord.set('ORDER_CUST_CD'		, record['ORDER_CUST_CD']);
	   		grdRecord.set('PLAN_NUM'			, record['PROJECT_NO']);
	   		grdRecord.set('ISSUE_REQ_NUM'		, record['ISSUE_REQ_NUM']);
	   		grdRecord.set('BASIS_NUM'			, record['PO_NUM']);
	   		grdRecord.set('BASIS_SEQ'			, record['PO_SEQ']);

	   		if(BsaCodeInfo.gsOptDivCode == "1"){
	   			grdRecord.set('SALE_DIV_CODE'		, record['ISSUE_DIV_CODE']);
	   		}else{
	   			grdRecord.set('SALE_DIV_CODE'		, record['DIV_CODE']);
	   		}

	   		grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
	   		grdRecord.set('EXCHG_RATE_O'		, masterForm.getValue('EXCHG_RATE_O'));
	   		grdRecord.set('ISSUE_REQ_SEQ'		, record['ISSUE_REQ_SEQ']);
	   		grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
	   		grdRecord.set('ORDER_SEQ'			, record['SER_NO']);
	   		grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
	   		grdRecord.set('BILL_TYPE'			, record['BILL_TYPE']);
	   		grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
	   		grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
	   		grdRecord.set('SALE_TYPE'			, record['ORDER_TYPE']);
	   		grdRecord.set('SALE_PRSN'			, record['ISSUE_REQ_PRSN']);
	   		grdRecord.set('INOUT_PRSN'			, masterForm.getValue('INOUT_PRSN'));
	   		grdRecord.set('ACCOUNT_Q'			, "0");
	   		grdRecord.set('SALE_C_YN'			, "N");
	   		grdRecord.set('CREDIT_YN'			, CustomCodeInfo.gsCustCreditYn);
	   		grdRecord.set('WON_CALC_BAS'		, CustomCodeInfo.gsUnderCalBase);
	   		grdRecord.set('PAY_METHODE1'		, record['PAY_METHODE1']);
	   		grdRecord.set('LC_SER_NO'			, record['LC_SER_NO']);

	   		if(record['SOF100_TAX_INOUT'] == ""){
	   			grdRecord.set('TAX_INOUT'			, CustomCodeInfo.gsTaxInout);
	   		}else{
	   			grdRecord.set('TAX_INOUT'			, record['SOF100_TAX_INOUT']);
	   		}

	   		grdRecord.set('LOT_NO'				, record['LOT_NO']);
	   		grdRecord.set('AGENT_TYPE'			, record['AGENT_TYPE']);
	   		grdRecord.set('DEPT_CODE'			, record['DEPT_CODE']);
	   		grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
	   		grdRecord.set('UPDATE_DB_USER'		, UserInfo.userID);
	   		grdRecord.set('RETURN_Q_YN'			, record['RETURN_Q_YN']);
	   		grdRecord.set('SRC_ORDER_Q'			, record['ORDER_Q']);
	   		grdRecord.set('EXCESS_RATE'			, record['EXCESS_RATE']);
	   		grdRecord.set('PRICE_TYPE'	 		, record['PRICE_TYPE']);
	   		grdRecord.set('INOUT_FOR_WGT_P'		, record['ISSUE_FOR_WGT_P']);
	   		grdRecord.set('INOUT_FOR_VOL_P'		, record['ISSUE_FOR_VOL_P']);
	   		grdRecord.set('INOUT_WGT_P'	 		, record['ISSUE_WGT_P']);
	   		grdRecord.set('INOUT_VOL_P'	 		, record['ISSUE_VOL_P']);
	   		grdRecord.set('WGT_UNIT'		 	, record['WGT_UNIT']);
	   		grdRecord.set('UNIT_WGT'		 	, record['UNIT_WGT']);
	   		grdRecord.set('VOL_UNIT'		 	, record['VOL_UNIT']);
	   		grdRecord.set('UNIT_VOL'		 	, record['UNIT_VOL']);

	   		//출고량(중량) 재계산
	   		var sInout_q = grdRecord.get('ORDER_UNIT_Q');
	   		var sUnitWgt = grdRecord.get('UNIT_WGT');
	   		var sOrderWgtQ = sInout_q * sUnitWgt;
	   		grdRecord.set('INOUT_WGT_Q'		 	, sOrderWgtQ);

	   		//출고량(부피) 재계산
	   		var sUnitVol = grdRecord.get('UNIT_VOL');
	   		var sOrderVolQ = sInout_q * sUnitVol;
	   		grdRecord.set('INOUT_VOL_Q'		 	, sOrderVolQ);

	   		if(grdRecord.get('ACCOUNT_YNC') == "N"){
	   			grdRecord.set('ORDER_UNIT_P'		 	, 0);
	   		}else{
	   			grdRecord.set('ORDER_UNIT_P'		 	, record['ISSUE_REQ_PRICE']);
	   		}

	   		if(record['ORDER_Q'] != record['NOT_REQ_Q']){
	   			UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
	   		}else{
	   			if(record['ACCOUNT_YNC'] == "N"){
	   				grdRecord.set('ORDER_UNIT_O'		 	, 0);
	   				grdRecord.set('INOUT_TAX_AMT'		 	, 0);
	   			}else{
	   				grdRecord.set('ORDER_UNIT_O'		 	, record['ISSUE_REQ_AMT']);
	   				grdRecord.set('INOUT_TAX_AMT'		 	, record['ISSUE_REQ_TAX_AMT']);
	   			}
	   			//20171211 합계금액 표시를 위해 함수 호출
	   			UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
	   		}
	   		grdRecord.set('COMP_CODE'		, UserInfo.compCode);
	   		grdRecord.set('REMARK'			, record['REMARK']);
	   		grdRecord.set('TRANS_COST'		, "0");
	   		grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
	   		grdRecord.set('GUBUN'			, "FEFER");
	   		grdRecord.set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);

	   		var lRate = record['TRANS_RATE'];
	   		if(lRate == 0){
	   			lRate = 1;
	   		}
	   		grdRecord.set('STOCK_Q'	, record['STOCK_Q'] / lRate);
	   		grdRecord.set('WONSANGI_NUM'	, record['WONSANGI_NUM']);

		},
		setSalesOrderData: function(record) {
	   		var grdRecord = this.getSelectedRecord();

	   		grdRecord.set('INOUT_TYPE'			, "2");
	   		grdRecord.set('INOUT_METH'			, "1");
	   		grdRecord.set('INOUT_CODE_TYPE'		, "4");
	   		grdRecord.set('CREATE_LOC'			, masterForm.getValue('CREATE_LOC'));
	   		grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
	   		grdRecord.set('INOUT_CODE'			, masterForm.getValue('CUSTOM_CODE'));
	   		grdRecord.set('CUSTOM_NAME'			, masterForm.getValue('CUSTOM_NAME'));
	   		grdRecord.set('INOUT_DATE'			, masterForm.getValue('INOUT_DATE'));
	   		grdRecord.set('INOUT_NUM'			, masterForm.getValue('INOUT_NUM'));

	   		masterForm.setValue('NATION_INOUT', record['NATION_INOUT']);
	   		panelResult.setValue('NATION_INOUT', record['NATION_INOUT']);
	   		grdRecord.set('NATION_INOUT'		, masterForm.getValue('NATION_INOUT'));

	   		grdRecord.set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);
	   		masterForm.setValue('EXCHG_RATE_O'  , record['EXCHG_RATE_O']);
	   		panelResult.setValue('EXCHG_RATE_O'  , record['EXCHG_RATE_O']);
	   		var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
			var sRefCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2

	   		if(record['INOUT_TYPE_DETAIL'] > ""){
	   			grdRecord.set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);
	   		}else{
	   			grdRecord.set('INOUT_TYPE_DETAIL'	, inoutTypeDetail);
	   		}

	   		grdRecord.set('REF_CODE2'			, sRefCode2);
	   		grdRecord.set('WH_CODE'				, masterForm.getValue('WH_CODE'));
	   		grdRecord.set('WH_CELL_CODE'		, masterForm.getValue('WH_CELL_CODE'));
	   		grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
	   		grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
	   		grdRecord.set('SPEC'				, record['SPEC']);
	   		grdRecord.set('ITEM_STATUS'			, "1");
	   		grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
	   		grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
	   		grdRecord.set('ORDER_UNIT_Q'		, record['R_ALLOC_Q']);
	   		grdRecord.set('ORIGIN_Q'			, record['R_ALLOC_Q']);
	   		grdRecord.set('ORDER_NOT_Q'			, record['R_ALLOC_Q']);
	   		grdRecord.set('ISSUE_NOT_Q'			, "0");
	   		grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
	   		grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
	   		grdRecord.set('ACCOUNT_YNC'			, record['ACCOUNT_YNC']);
	   		grdRecord.set('SALE_CUSTOM_CODE'	, record['SALE_CUST_CD']);
	   		grdRecord.set('SALE_CUST_CD'		, record['SALE_CUST_NM']);
	   		grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
	   		grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);
	   		grdRecord.set('ORDER_CUST_CD'		, record['CUSTOM_NAME']);
	   		grdRecord.set('PLAN_NUM'			, record['PROJECT_NO']);
	   		grdRecord.set('BASIS_NUM'			, record['PO_NUM']);
	   		grdRecord.set('BASIS_SEQ'			, record['PO_SEQ']);

	   		if(BsaCodeInfo.gsOptDivCode == "1"){
	   			grdRecord.set('SALE_DIV_CODE'		, record['OUT_DIV_CODE']);
	   		}else{
	   			grdRecord.set('SALE_DIV_CODE'		, record['DIV_CODE']);
	   		}

	   		grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
	   		grdRecord.set('EXCHG_RATE_O'		, masterForm.getValue('EXCHG_RATE_O'));
	   		grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
	   		grdRecord.set('ORDER_SEQ'			, record['SER_NO']);
	   		grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
	   		grdRecord.set('BILL_TYPE'			, record['BILL_TYPE']);
	   		grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
	   		grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
	   		if(masterForm.getValue('CREATE_LOC') == "5"){
	   		   grdRecord.set('SALE_TYPE'		   , '60');
	   		}else{
	   		   grdRecord.set('SALE_TYPE'		   , record['ORDER_TYPE']);
	   		}
	   		grdRecord.set('SALE_PRSN'			, record['ORDER_PRSN']);
	   		grdRecord.set('INOUT_PRSN'			, masterForm.getValue('INOUT_PRSN'));
	   		grdRecord.set('ACCOUNT_Q'			, "0");
	   		grdRecord.set('SALE_C_YN'			, "N");
	   		grdRecord.set('CREDIT_YN'			, CustomCodeInfo.gsCustCreditYn);
	   		grdRecord.set('WON_CALC_BAS'		, CustomCodeInfo.gsUnderCalBase);
	   		grdRecord.set('TAX_INOUT'			, record['TAX_INOUT']);
	   		grdRecord.set('AGENT_TYPE'			, record['ITEM_CODE']);
	   		grdRecord.set('AGENT_TYPE'			, record['AGENT_TYPE']);
	   		grdRecord.set('DEPT_CODE'			, record['DEPT_CODE']);
	   		grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
	   		grdRecord.set('UPDATE_DB_USER'		, record['USER_ID']);
	   		grdRecord.set('RETURN_Q_YN'			, record['RETURN_Q_YN']);
	   		grdRecord.set('SRC_ORDER_Q'			, record['ORDER_Q']);
	   		grdRecord.set('EXCESS_RATE'			, record['EXCESS_RATE']);

	   		if(grdRecord.get('ACCOUNT_YNC') == "N"){
	   			grdRecord.set('ORDER_UNIT_P'		, 0);
	   		}else{
	   			grdRecord.set('ORDER_UNIT_P'		, record['R_ORDER_P']);
	   		}

	   		if(record['ORDER_Q'] != record['R_ALLOC_Q']){
	   			UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
	   		}

	   		if(record['ACCOUNT_YNC'] == "N"){
	   			grdRecord.set('ORDER_UNIT_O'		, 0);
	   			grdRecord.set('INOUT_TAX_AMT'		, 0);
	   		}else{
	   			grdRecord.set('ORDER_UNIT_O'		, record['R_ORDER_O']);
	   			grdRecord.set('INOUT_TAX_AMT'		, record['R_ORDER_TAX_O']);
	   		}


	   		grdRecord.set('PRICE_TYPE'			, record['PRICE_TYPE']);
	   		grdRecord.set('INOUT_FOR_WGT_P'		, record['ORDER_FOR_WGT_P']);
	   		grdRecord.set('INOUT_FOR_VOL_P'		, record['ORDER_FOR_VOL_P']);
	   		grdRecord.set('INOUT_WGT_P'			, record['ORDER_WGT_P']);
	   		grdRecord.set('INOUT_VOL_P'			, record['ORDER_VOL_P']);
	   		grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
	   		grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
	   		grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
	   		grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);

	   		var sInout_q = grdRecord.get('ORDER_UNIT_Q');
	   		//출고량(중량) 재계산
	   		var sUnitWgt = grdRecord.get('UNIT_WGT');
	   		var sOrderWgtQ = sInout_q * sUnitWgt;
	   		grdRecord.set('INOUT_WGT_Q'			, sOrderWgtQ);

	   		//출고량(부피) 재계산
	   		var sUnitVol = grdRecord.get('UNIT_VOL');
	   		var sOrderVolQ = sInout_q * sUnitVol
	   		grdRecord.set('INOUT_VOL_Q'			, sOrderVolQ);

	   		grdRecord.set('COMP_CODE'			, UserInfo.compCode);
	   		grdRecord.set('REMARK'				, record['REMARK']);
	   		grdRecord.set('PAY_METHODE1'		, record['PAY_METHODE1']);
	   		grdRecord.set('LC_SER_NO'			, record['LC_SER_NO']);
	   		grdRecord.set('TRANS_COST'			, "0");
	   		grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
	   		grdRecord.set('GUBUN'				, "FEFER");

	   		var lRate = record['TRANS_RATE'];
	   		if(lRate == 0){
	   			lRate = 1;
	   		}
	   		grdRecord.set('STOCK_Q'	, record['STOCK_Q']);
	   		grdRecord.set('ORDER_STOCK_Q'	, record['STOCK_Q'] / lRate);
	   		grdRecord.set('LOT_YN'	, record['LOT_YN']);
	   		grdRecord.set('LOT_NO'	, record['R_LOT_NO']);
	   		UniAppManager.app.fnOrderAmtCal(grdRecord, "P")
	   }
	});


	/**
	 * 수주정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
  	 //검색창 폼 정의
  	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
			fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>'  ,
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			value:UserInfo.divCode,
			allowBlank:false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = orderNoSearch.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
				}
			}
		}, {
			fieldLabel: '출고일',
			xtype: 'uniDateRangefield',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			width: 350,
			startDate: new Date() ,
			endDate: new Date()
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="unilite.msg.sMSR213" default="거래처"/>' ,
			validateBlank: false
		}),
			Unilite.popup('DIV_PUMOK',{
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel: '수불담당'		,
			name: 'INOUT_PRSN',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B024',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}

			}
		}, {
			fieldLabel: '관리번호',
			xtype: 'uniTextfield',
			name:'PROJECT_NO',
			width:315
		}, {
			fieldLabel: '출하지시번호',
			xtype: 'uniTextfield',
			name:'ISSUE_REQ_NUM',
			width:315
		}, {
			fieldLabel: '수신자',
			xtype: 'uniTextfield',
			name:'RECEIVER_NAME'
		}, {
			fieldLabel: '<t:message code="unilite.msg.sMR310" default="생성경로"/>',
			name: 'CREATE_LOC',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B031',
			allowBlank:false,
			value:'1'
		},
		Unilite.popup('DEPT', {
			fieldLabel: '부서',
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			hidden: true,
			allowBlank: false,
			holdable: 'hold',
			listeners: {
				applyextparam: function(popup){
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장

					if(authoInfo == "A"){	//자기사업장
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});

					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});

					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),{
			fieldLabel	: '조회구분',
			xtype		: 'uniRadiogroup',
			name		: 'RDO_TYPE',
			allowBlank	: false,
			width		: 235,
			items		: [
				{boxLabel:'마스터', name:'RDO_TYPE', inputValue:'master', checked:true},
				{boxLabel:'디테일', name:'RDO_TYPE', inputValue:'detail'}
			],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					orderNoMasterGrid.reset();
					orderNoDetailGrid.reset();
					if(newValue.RDO_TYPE=='detail') {
						if(orderNoMasterGrid) orderNoMasterGrid.hide();
						if(orderNoDetailGrid) orderNoDetailGrid.show();
					} else {
						if(orderNoDetailGrid) orderNoDetailGrid.hide();
						if(orderNoMasterGrid) orderNoMasterGrid.show();
					}
				}
			}
		}]
	}); // createSearchForm
	//검색창 모델 정의
	Unilite.defineModel('orderNoMasterModel', {
		fields: [{name: 'DIV_CODE'				, text: '사업장'			, type: 'string', comboType: 'BOR120'},
				 {name: 'ITEM_CODE'				, text: '품목코드'			, type: 'string'},
				 {name: 'ITEM_NAME'				, text: '품명'			, type: 'string'},
				 {name: 'SPEC'					, text: '규격'			, type: 'string'},
				 {name: 'INOUT_TYPE_DETAIL'		, text: '출고유형'			, type: 'string', comboType:'AU', comboCode:'S007'},
				 {name: 'CREATE_LOC'			, text: '생성경로'			, type: 'string', comboType:'AU', comboCode:'B031'},
				 {name: 'INOUT_DATE'			, text: '출고일'			, type: 'uniDate'},
				 {name: 'INOUT_Q'				, text: '수량'			, type: 'uniQty'},
				 {name: 'WH_CODE'				, text: '창고코드'			, type: 'string'},
				 {name: 'WH_NAME'				, text: '창고'			, type: 'string'},
				 {name: 'INOUT_PRSN'			, text: '담당자'			, type: 'string', comboType:'AU', comboCode:'B024'},
				 {name: 'RECEIVER_ID'			, text: '수신자코드'			, type: 'string'},
				 {name: 'RECEIVER_NAME'			, text: '수신자'			, type: 'string'},
				 {name: 'TELEPHONE_NUM1'		, text: '전화번호'			, type: 'string'},
				 {name: 'TELEPHONE_NUM2'		, text: '전화번호'			, type: 'string'},
				 {name: 'ADDRESS'				, text: '주소'			, type: 'string'},
				 {name: 'INOUT_NUM'				, text: '출고번호'			, type: 'string'},
				 {name: 'ISSUE_REQ_NUM'			, text: '출하지시번호'		, type: 'string'},
				 {name: 'PROJECT_NO'			, text: '프로젝트번호'		, type: 'string'},
				 {name: 'SALE_DIV_CODE'			, text: '매출사업장'			, type: 'string'},
				 {name: 'SALE_CUST_NM'			, text: '매출처'			, type: 'string'},
				 {name: 'INOUT_CODE'			, text: '수불처'			, type: 'string'},
				 {name: 'CUSTOM_NAME'			, text: '수불처명'			, type: 'string'},
				 {name: 'MONEY_UNIT'			, text: '화폐'			, type: 'string'},
				 {name: 'EXCHG_RATE_O'			, text: '환율'			, type: 'uniER'},
				 {name: 'SALE_DATE'				, text: '매출일'			, type: 'uniDate'},

				 /*CustomCodeInfo set위해*/
				 {name: 'AGENT_TYPE'			, text: 'AGENT_TYPE'	, type: 'string'},
				 {name: 'CREDIT_YN'				, text: 'CREDIT_YN'		, type: 'string'},
				 {name: 'WON_CALC_BAS'			, text: 'WON_CALC_BAS'	, type: 'string'},
				 {name: 'TAX_TYPE'				, text: 'TAX_TYPE'		, type: 'string'},
				 {name: 'BUSI_PRSN'				, text: 'BUSI_PRSN'		, type: 'string'}
		]
	});
	//검색창 스토어 정의
	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
			model: 'orderNoMasterModel',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read	: 's_str103ukrv_ypService.selectOrderNumMasterList'
				}
			},
			loadStoreRecords : function()	{
				var param= orderNoSearch.getValues();
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	//검색창 그리드 정의
	var orderNoMasterGrid = Unilite.createGrid('s_str103ukrv_ypOrderNoMasterGrid', {
		// title: '기본',
		layout : 'fit',
		store: orderNoMasterStore,
		uniOpt:{
					useRowNumberer: false
		},
		columns:  [{ dataIndex: 'DIV_CODE'				, width: 80 },
				   { dataIndex: 'INOUT_CODE'			, width: 90 },
				   { dataIndex: 'CUSTOM_NAME'			, width: 120},
				   { dataIndex: 'CREATE_LOC'			, width: 66 },
				   { dataIndex: 'INOUT_DATE'			, width: 80 },
				   { dataIndex: 'INOUT_Q'				, width: 93 },
				   { dataIndex: 'INOUT_PRSN'			, width: 80 },
				   { dataIndex: 'INOUT_NUM'				, width: 120 },
				   { dataIndex: 'SALE_DIV_CODE'			, width: 73, hidden: true },
				   { dataIndex: 'MONEY_UNIT'			, width: 93 },
				   { dataIndex: 'EXCHG_RATE_O'			, width: 93, hidden: true },
				   { dataIndex: 'ISSUE_REQ_NUM'			, width: 120 }
		  ] ,
		  listeners: {
			  onGridDblClick: function(grid, record, cellIndex, colName) {
				  	orderNoMasterGrid.returnData(record);
				  	searchInfoWindow.hide();
			  }
		  }, // listeners
		  returnData: function(record)	{
		  	if(Ext.isEmpty(record))	{
		  		record = this.getSelectedRecord();
		  	}
		  	var field = masterForm.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");

		  	masterForm.setValue('INOUT_NUM', record.get('INOUT_NUM'));
		  	masterForm.setValue('INOUT_DATE', record.get('INOUT_DATE'));
		  	masterForm.setValue('DIV_CODE', record.get('DIV_CODE'));
		  	masterForm.setValue('INOUT_PRSN', record.get('INOUT_PRSN'));
		  	masterForm.setValue('MONEY_UNIT', record.get('MONEY_UNIT'));
		  	masterForm.setValue('EXCHG_RATE_O', record.get('EXCHG_RATE_O'));
		  	masterForm.setValue('CUSTOM_CODE', record.get('INOUT_CODE'));
		  	masterForm.setValue('CUSTOM_NAME', record.get('CUSTOM_NAME'));
		  	masterForm.setValue('INOUT_DATE', record.get('INOUT_DATE'));
//		  	masterForm.setValue('CREATE_LOC', record.get('CREATE_LOC'));
		  	if(Ext.isEmpty(record.get('SALE_DATE'))){
		  		masterForm.setValue('SALE_DATE', record.get('INOUT_DATE'));
		  	}else{
		  		masterForm.setValue('SALE_DATE', record.get('SALE_DATE'));
		  	}

		  	panelResult.setValue('INOUT_NUM', record.get('INOUT_NUM'));
		  	panelResult.setValue('INOUT_DATE', record.get('INOUT_DATE'));
		  	panelResult.setValue('DIV_CODE', record.get('DIV_CODE'));
		  	panelResult.setValue('INOUT_PRSN', record.get('INOUT_PRSN'));
		  	panelResult.setValue('MONEY_UNIT', record.get('MONEY_UNIT'));
		  	panelResult.setValue('EXCHG_RATE_O', record.get('EXCHG_RATE_O'));
		  	panelResult.setValue('CUSTOM_CODE', record.get('INOUT_CODE'));
		  	panelResult.setValue('CUSTOM_NAME', record.get('CUSTOM_NAME'));
		  	panelResult.setValue('INOUT_DATE', record.get('INOUT_DATE'));
//		  	masterForm.setValue('CREATE_LOC', record.get('CREATE_LOC'));
		  	if(Ext.isEmpty(record.get('SALE_DATE'))){
		  		panelResult.setValue('SALE_DATE', record.get('INOUT_DATE'));
		  	}else{
		  		panelResult.setValue('SALE_DATE', record.get('SALE_DATE'));
		  	}

		  	 CustomCodeInfo.gsAgentType	= record.get('AGENT_TYPE');
			 CustomCodeInfo.gsCustCreditYn = record.get('CREDIT_YN');
			 CustomCodeInfo.gsUnderCalBase = record.get('WON_CALC_BAS');
			 CustomCodeInfo.gsTaxInout 	   = record.get('TAX_TYPE');
			 CustomCodeInfo.gsbusiPrsn 	   = record.get('BUSI_PRSN');
			 UniAppManager.app.onQueryButtonDown();
		  }
	});
	//검색창 detail그리드 정의
	var orderNoDetailGrid = Unilite.createGrid('s_str103ukrv_yporderNoDetailGrid', {
		// title: '기본',
		layout : 'fit',
		store: orderNoMasterStore,
		uniOpt:{
					useRowNumberer: false
		},
		hidden : true,
		columns:  [{ dataIndex: 'DIV_CODE'				, width: 80 },
				   { dataIndex: 'ITEM_CODE'				, width: 150 },
				   { dataIndex: 'ITEM_NAME'				, width: 150 },
				   { dataIndex: 'SPEC'					, width: 133 },
				   { dataIndex: 'INOUT_TYPE_DETAIL' 	, width: 80 },
				   { dataIndex: 'CREATE_LOC'			, width: 66 },
				   { dataIndex: 'INOUT_DATE'			, width: 80 },
				   { dataIndex: 'INOUT_Q'				, width: 93 },
				   { dataIndex: 'WH_CODE'				, width: 66, hidden: true },
				   { dataIndex: 'WH_NAME'				, width: 80 },
				   { dataIndex: 'INOUT_PRSN'			, width: 80 },
				   { dataIndex: 'RECEIVER_ID'			, width: 86, hidden: true },
				   { dataIndex: 'RECEIVER_NAME'			, width: 86, hidden: true },
				   { dataIndex: 'TELEPHONE_NUM1'		, width: 80, hidden: true },
				   { dataIndex: 'TELEPHONE_NUM2'		, width: 80, hidden: true },
				   { dataIndex: 'ADDRESS'				, width: 133, hidden: true },
				   { dataIndex: 'INOUT_NUM'				, width: 120 },
				   { dataIndex: 'ISSUE_REQ_NUM'			, width: 100 },
				   { dataIndex: 'PROJECT_NO'			, width: 86 },
				   { dataIndex: 'SALE_DIV_CODE'			, width: 73, hidden: true },
				   { dataIndex: 'SALE_CUST_NM'			, width: 93 },
				   { dataIndex: 'INOUT_CODE'			, width: 93, hidden: true },
				   { dataIndex: 'MONEY_UNIT'			, width: 93 },
				   { dataIndex: 'EXCHG_RATE_O'			, width: 93, hidden: true },
				   { dataIndex: 'SALE_DATE'				, width: 93, hidden: true }
		  ] ,
		  listeners: {
			  onGridDblClick: function(grid, record, cellIndex, colName) {
				  	orderNoDetailGrid.returnData(record);
				  	searchInfoWindow.hide();
			  }
		  }, // listeners
		  returnData: function(record)	{
		  	if(Ext.isEmpty(record))	{
		  		record = this.getSelectedRecord();
		  	}
		  	var field = masterForm.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");

		  	masterForm.setValue('INOUT_NUM', record.get('INOUT_NUM'));
		  	masterForm.setValue('INOUT_DATE', record.get('INOUT_DATE'));
		  	masterForm.setValue('DIV_CODE', record.get('DIV_CODE'));
		  	masterForm.setValue('INOUT_PRSN', record.get('INOUT_PRSN'));
		  	masterForm.setValue('MONEY_UNIT', record.get('MONEY_UNIT'));
		  	masterForm.setValue('EXCHG_RATE_O', record.get('EXCHG_RATE_O'));
		  	masterForm.setValue('CUSTOM_CODE', record.get('INOUT_CODE'));
		  	masterForm.setValue('CUSTOM_NAME', record.get('SALE_CUST_NM'));
		  	masterForm.setValue('INOUT_DATE', record.get('INOUT_DATE'));
//		  	masterForm.setValue('CREATE_LOC', record.get('CREATE_LOC'));
		  	if(Ext.isEmpty(record.get('SALE_DATE'))){
		  		masterForm.setValue('SALE_DATE', record.get('INOUT_DATE'));
		  	}else{
		  		masterForm.setValue('SALE_DATE', record.get('SALE_DATE'));
		  	}

		  	panelResult.setValue('INOUT_NUM', record.get('INOUT_NUM'));
		  	panelResult.setValue('INOUT_DATE', record.get('INOUT_DATE'));
		  	panelResult.setValue('DIV_CODE', record.get('DIV_CODE'));
		  	panelResult.setValue('INOUT_PRSN', record.get('INOUT_PRSN'));
		  	panelResult.setValue('MONEY_UNIT', record.get('MONEY_UNIT'));
		  	panelResult.setValue('EXCHG_RATE_O', record.get('EXCHG_RATE_O'));
		  	panelResult.setValue('CUSTOM_CODE', record.get('INOUT_CODE'));
		  	panelResult.setValue('CUSTOM_NAME', record.get('SALE_CUST_NM'));
		  	panelResult.setValue('INOUT_DATE', record.get('INOUT_DATE'));
//		  	masterForm.setValue('CREATE_LOC', record.get('CREATE_LOC'));
		  	if(Ext.isEmpty(record.get('SALE_DATE'))){
		  		panelResult.setValue('SALE_DATE', record.get('INOUT_DATE'));
		  	}else{
		  		panelResult.setValue('SALE_DATE', record.get('SALE_DATE'));
		  	}

		  	 CustomCodeInfo.gsAgentType	= record.get('AGENT_TYPE');
			 CustomCodeInfo.gsCustCreditYn = record.get('CREDIT_YN');
			 CustomCodeInfo.gsUnderCalBase = record.get('WON_CALC_BAS');
			 CustomCodeInfo.gsTaxInout 	   = record.get('TAX_TYPE');
			 CustomCodeInfo.gsbusiPrsn 	   = record.get('BUSI_PRSN');
			 UniAppManager.app.onQueryButtonDown();
		  }
	});

	//openSearchInfoWindow
	//검색창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '출고번호검색',
				width: 830,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [orderNoSearch, orderNoMasterGrid, orderNoDetailGrid],
				tbar:  [ '->',
						{	itemId : 'searchBtn',
							text: '조회',
							handler: function() {
								orderNoMasterStore.loadStoreRecords();
							},
							disabled: false
						}, {
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								searchInfoWindow.hide();
							},
							disabled: false
						}
				],
				listeners : {beforehide: function(me, eOpt)	{
											orderNoSearch.clearForm();
											orderNoMasterGrid.reset();
											orderNoDetailGrid.reset();
										},
							beforeclose: function( panel, eOpts )	{
											orderNoSearch.clearForm();
											orderNoMasterGrid.reset();
											orderNoDetailGrid.reset();
										},
							beforeshow: function( panel, eOpts )	{
								field = orderNoSearch.getField('INOUT_PRSN');
								field.fireEvent('changedivcode', field, masterForm.getValue('DIV_CODE'), null, null, "DIV_CODE");
								orderNoSearch.setValue('DIV_CODE'		,masterForm.getValue('DIV_CODE'));
								orderNoSearch.setValue('INOUT_PRSN'		,masterForm.getValue('INOUT_PRSN'));
								orderNoSearch.setValue('CUSTOM_CODE'	,masterForm.getValue('CUSTOM_CODE'));
								orderNoSearch.setValue('CUSTOM_NAME'	,masterForm.getValue('CUSTOM_NAME'));
								orderNoSearch.setValue('INOUT_DATE_FR'	, new Date());
								orderNoSearch.setValue('INOUT_DATE_TO'	,new Date());
								orderNoSearch.setValue('CREATE_LOC'		, '1');
								orderNoSearch.setValue('DEPT_CODE'		, masterForm.getValue('DEPT_CODE'));
								orderNoSearch.setValue('DEPT_NAME'		, masterForm.getValue('DEPT_NAME'));
								orderNoSearch.setValue('RDO_TYPE'		,'master');
//								orderNoSearch.setValue('ORDER_TYPE',masterForm.getValue('ORDER_TYPE'));

								orderNoDetailGrid.hide();
								orderNoMasterGrid.show();
							}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}

	/**
	 * 출하지시내역을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//출하지시 참조 폼 정의
	 var requestSearch = Unilite.createSearchForm('requestForm', {
			layout :  {type : 'uniTable', columns : 3},
			items :[{
				xtype: 'uniCombobox',
		   		name:'DIV_CODE',
		   		fieldLabel: '사업장',
		   		child: 'WH_CODE',
		   		comboType:'BOR120',
		   		allowBlank: false,
		   		readOnly: true
			},
				Unilite.popup('DIV_PUMOK',{
				fieldLabel:'품목코드' ,
				validateBlank: false,
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': requestSearch.getValue('DIV_CODE')});
					}
				}
			}), {
				fieldLabel: '출고요청일',
				xtype: 'uniDateRangefield',
				startFieldName: 'ISSUE_DATE_FR',
				endFieldName: 'ISSUE_DATE_TO',
				width: 350,
				endDate: UniDate.get('tomorrow')
		   }, {
		   		fieldLabel: '출하지시번호',
		   		xtype: 'uniTextfield',
		   		name:'ISSUE_REQ_NUM'
		   }, {
		   		fieldLabel: '관리번호',
		   		xtype: 'uniTextfield',
		   		name:'PROJECT_NO'
		   }, {
				fieldLabel: '출고창고',
				name: 'WH_CODE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'',
				store: Ext.data.StoreManager.lookup('whList')
			}, {
				xtype: 'hiddenfield',
		   		name:'MONEY_UNIT'
			}, {
				xtype: 'hiddenfield',
		   		name:'CUSTOM_CODE'
			}, {
				xtype: 'hiddenfield',
		   		name:'CUSTOM_NAME'
			}, {
				xtype: 'hiddenfield',
		   		name:'CREATE_LOC'
			}]
	});
	//출하지시 참조 모델 정의
	Unilite.defineModel('s_str103ukrv_ypRequestModel', {
		fields: [{name: 'CUSTOM_NAME'				,text: '거래처'					, type: 'string'},
				 {name: 'ITEM_CODE'					,text: '품목코드'				, type: 'string'},
				 {name: 'ITEM_NAME'					,text: '품명'					, type: 'string'},
				 {name: 'SPEC'						,text: '규격'					, type: 'string'},
				 {name: 'ORDER_UNIT'				,text: '판매단위'				, type: 'string', displayField: 'value'},
				 {name: 'TRANS_RATE'				,text: '입수'					, type: 'string'},
				 {name: 'ISSUE_REQ_DATE'			,text: '출하지시일'				, type: 'uniDate'},
				 {name: 'ISSUE_DATE'	   			,text: '출고요청일'				, type: 'uniDate'},
				 {name: 'NOT_REQ_Q'			   		,text: '미출고량'				, type: 'uniQty'},
				 {name: 'ISSUE_REQ_QTY'				,text: '출하지시량'				, type: 'uniQty'},
				 {name: 'ISSUE_WGT_Q'				,text: '출하지시량(중량)'		, type: 'string'},
				 {name: 'ISSUE_VOL_Q'				,text: '출하지시량(부피)'		, type: 'string'},
				 {name: 'STOCK_Q'					,text: '재고수량'				, type: 'uniQty'},
				 {name: 'WH_CODE'			   	,text: '출고창고'				, type: 'string', store: Ext.data.StoreManager.lookup('whList')},
				 {name: 'ORDER_NUM'			 	,text: '수주(OFFRE)번호'		, type: 'string'},
				 {name: 'ISSUE_REQ_NUM'				,text: '출하지시번호'			, type: 'string'},
				 {name: 'ISSUE_REQ_SEQ'				,text: '순번'					, type: 'string'},
				 {name: 'PROJECT_NO'				,text: '프로젝트번호'			, type: 'string'},
				 {name: 'PAY_METHODE1'				,text: '대금결제방법'			, type: 'string'},
				 {name: 'LC_SER_NO'					,text: 'LC번호'					, type: 'string'},
				 {name: 'LOT_NO'					,text: 'LOT NO'					, type: 'string'},
				 {name: 'RECEIVER_ID'		   	,text: '수신자코드'				, type: 'string'},
				 {name: 'RECEIVER_NAME'		 	,text: '수신자'					, type: 'string'},
				 {name: 'TELEPHONE_NUM1'			,text: '전화번호'				, type: 'string'},
				 {name: 'TELEPHONE_NUM2'			,text: '전화번호'				, type: 'string'},
				 {name: 'ADDRESS'			   	,text: '주소'					, type: 'string'},
				 {name: 'ORDER_CUST_CD'				,text: '수주처'					, type: 'string'},
				 {name: 'DIV_CODE'			  	,text: 'DIV_CODE'		  		, type: 'string'},
				 {name: 'CUSTOM_CODE'		   	,text: 'CUSTOM_CODE'	   		, type: 'string'},
				 {name: 'INOUT_TYPE_DETAIL'	 	,text: 'INOUT_TYPE_DETAIL' 		, type: 'string'},
				 {name: 'WH_CELL_CODE'		  	,text: 'WH_CELL_CODE'	  		, type: 'string'},
				 {name: 'WH_CELL_NAME'		  	,text: 'WH_CELL_NAME'	  		, type: 'string'},
				 {name: 'ISSUE_REQ_PRICE'	   	,text: 'ISSUE_REQ_PRICE'   		, type: 'string'},
				 {name: 'ISSUE_REQ_AMT'		 	,text: 'ISSUE_REQ_AMT'	 		, type: 'string'},
				 {name: 'ISSUE_REQ_TAX_AMT'	 	,text: 'ISSUE_REQ_TAX_AMT' 		, type: 'string'},
				 {name: 'TAX_TYPE'			  	,text: 'TAX_TYPE'		  		, type: 'string'},
				 {name: 'MONEY_UNIT'				,text: 'MONEY_UNIT'				, type: 'string'},
				 {name: 'EXCHANGE_RATE'		 	,text: 'EXCHANGE_RATE'	 		, type: 'string'},
				 {name: 'ACCOUNT_YNC'		   	,text: '매출대상'				, type: 'string'},
				 {name: 'DISCOUNT_RATE'		 	,text: 'DISCOUNT_RATE'   		, type: 'string'},
				 {name: 'ISSUE_REQ_PRSN'			,text: 'ISSUE_REQ_PRSN'  		, type: 'string'},
				 {name: 'DVRY_CUST_CD'		  	,text: 'DVRY_CUST_CD'			, type: 'string'},
				 {name: 'REMARK'					,text: 'REMARK'		  		, type: 'string'},
				 {name: 'SER_NO'					,text: 'SER_NO'		  		, type: 'string'},
				 {name: 'SALE_CUSTOM_CODE'	  	,text: 'SALE_CUSTOM_CODE'		, type: 'string'},
				 {name: 'SALE_CUST_CD'		  	,text: 'SALE_CUST_CD'			, type: 'string'},
				 {name: 'ISSUE_DIV_CODE'			,text: 'ISSUE_DIV_CODE'  		, type: 'string'},
				 {name: 'BILL_TYPE'			 	,text: 'BILL_TYPE'	   		, type: 'string'},
				 {name: 'ORDER_TYPE'				,text: 'ORDER_TYPE'	  		, type: 'string'},
				 {name: 'PRICE_YN'			  	,text: '단가구분'				, type: 'string', comboType: 'AU', comboCode: 'S003'},
				 {name: 'PO_NUM'					,text: 'PO_NUM'	   			, type: 'string'},
				 {name: 'PO_SEQ'					,text: 'PO_SEQ'	   			, type: 'string'},
				 {name: 'CREDIT_YN'			 	,text: 'CREDIT_YN'				, type: 'string'},
				 {name: 'WON_CALC_BAS'		  	,text: 'WON_CALC_BAS' 			, type: 'string'},
				 {name: 'TAX_INOUT'			 	,text: 'TAX_INOUT'				, type: 'string'},
				 {name: 'AGENT_TYPE'				,text: 'AGENT_TYPE'   			, type: 'string'},
				 {name: 'STOCK_CARE_YN'		 	,text: 'STOCK_CARE_YN'			, type: 'string'},
				 {name: 'STOCK_UNIT'				,text: 'STOCK_UNIT'   			, type: 'string'},
				 {name: 'DVRY_CUST_NAME'			,text: '배송처'					, type: 'string'},
				 {name: 'SOF100_TAX_INOUT'	  	,text: 'SOF100_TAX_INOUT'		, type: 'string'},
				 {name: 'RETURN_Q_YN'		   	,text: 'RETURN_Q_YN'	 		, type: 'string'},
				 {name: 'ORDER_Q'			   	,text: 'ORDER_Q'		 		, type: 'string'},
				 {name: 'REF_CODE2'			 	,text: 'REF_CODE2'	   		, type: 'string'},
				 {name: 'EXCESS_RATE'		   	,text: 'EXCESS_RATE'	 		, type: 'string'},
				 {name: 'DEPT_CODE'			 	,text: 'DEPT_CODE'	   		, type: 'string'},
				 {name: 'ITEM_ACCOUNT'		  	,text: 'ITEM_ACCOUNT'			, type: 'string'},
				 {name: 'PRICE_TYPE'				,text: 'PRICE_TYPE'	  		, type: 'string'},
				 {name: 'ISSUE_FOR_WGT_P'	   	,text: 'ISSUE_FOR_WGT_P' 		, type: 'string'},
				 {name: 'ISSUE_WGT_P'		   	,text: 'ISSUE_WGT_P'	 		, type: 'string'},
				 {name: 'ISSUE_FOR_VOL_P'	   	,text: 'ISSUE_FOR_VOL_P' 		, type: 'string'},
				 {name: 'ISSUE_VOL_P'		   	,text: 'ISSUE_VOL_P'	 		, type: 'string'},
				 {name: 'WGT_UNIT'			  	,text: 'WGT_UNIT'				, type: 'string'},
				 {name: 'UNIT_WGT'			  	,text: 'UNIT_WGT'				, type: 'string'},
				 {name: 'VOL_UNIT'			  	,text: 'VOL_UNIT'				, type: 'string'},
				 {name: 'UNIT_VOL'			  	,text: 'UNIT_VOL'				, type: 'string'},
				 {name: 'WONSANGI_NUM'			  	,text: '원산지'				, type: 'string'}
		]
	});

	//출하지시 참조 스토어 정의
	var requestStore = Unilite.createStore('s_str103ukrv_ypRequestStore', {
			model: 's_str103ukrv_ypRequestModel',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read	: 's_str103ukrv_ypService.selectRequestiList'
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts)	{
						if(successful)	{
						   var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
						   var deleteRecords = new Array();

						   if(masterRecords.items.length > 0)	{
						   	console.log("store.items :", store.items);
						   	console.log("records", records);

							   Ext.each(records,
							   			function(item, i)	{
			   								Ext.each(masterRecords.items, function(record, i)	{
			   										console.log("record :", record);

			   										if( (record.data['ISSUE_REQ_NUM'] == item.data['ISSUE_REQ_NUM'])
			   											&& (record.data['ISSUE_REQ_SEQ'] == item.data['ISSUE_REQ_SEQ'])
			   											)
			   										{
			   												deleteRecords.push(item);
			   										}
			   								});

							   			});
							   store.remove(deleteRecords);
						   }
						}
				}
			}
			,loadStoreRecords : function()	{
				var param= requestSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	//출하지시 참조 그리드 정의
	var requestGrid = Unilite.createGrid('s_str103ukrv_ypRequestGrid', {
		// title: '기본',
		layout : 'fit',
		store: requestStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE' }),
			uniOpt:{
				onLoadSelectFirst : false,
				useRowNumberer: false
			},
		columns:  [{ dataIndex: 'CUSTOM_NAME'				,  width: 120 },
				   { dataIndex: 'ITEM_CODE'					,  width: 120 },
				   { dataIndex: 'ITEM_NAME'					,  width: 113 },
				   { dataIndex: 'SPEC'						,  width: 113 },
				   { dataIndex: 'ORDER_UNIT'				,  width: 80, align: 'center' },
				   { dataIndex: 'TRANS_RATE'				,  width: 40 },
				   { dataIndex: 'ISSUE_REQ_DATE'			,  width: 80 },
				   { dataIndex: 'ISSUE_DATE'	   			,  width: 80 },
				   { dataIndex: 'NOT_REQ_Q'			   		,  width: 80 },
				   { dataIndex: 'ISSUE_REQ_QTY'				,  width: 80 },
				   { dataIndex: 'ISSUE_WGT_Q'				,  width: 80, hidden: true },
				   { dataIndex: 'ISSUE_VOL_Q'				,  width: 80, hidden: true },
				   { dataIndex: 'STOCK_Q'					,  width: 80 },
				   { dataIndex: 'WH_CODE'			   	,  width: 93},
				   { dataIndex: 'ORDER_NUM'			 	,  width: 120 },
				   { dataIndex: 'ISSUE_REQ_NUM'				,  width: 100 },
				   { dataIndex: 'ISSUE_REQ_SEQ'				,  width: 40 },
				   { dataIndex: 'PROJECT_NO'				,  width: 86 },
				   { dataIndex: 'PAY_METHODE1'				,  width: 100 },
				   { dataIndex: 'LC_SER_NO'					,  width: 100 },
				   { dataIndex: 'LOT_NO'					,  width: 66 },
				   { dataIndex: 'RECEIVER_ID'		   	,  width: 86, hidden: true },
				   { dataIndex: 'RECEIVER_NAME'		 	,  width: 86 , hidden: true},
				   { dataIndex: 'TELEPHONE_NUM1'			,  width: 80, hidden: true },
				   { dataIndex: 'TELEPHONE_NUM2'			,  width: 80, hidden: true },
				   { dataIndex: 'ADDRESS'			   	,  width: 133, hidden: true },
				   { dataIndex: 'ORDER_CUST_CD'				,  width: 86 },
				   { dataIndex: 'DIV_CODE'			  	,  width: 66, hidden: true },
				   { dataIndex: 'CUSTOM_CODE'		   	,  width: 66, hidden: true },
				   { dataIndex: 'INOUT_TYPE_DETAIL'	 	,  width: 66, hidden: true },
				   { dataIndex: 'WH_CELL_CODE'		  	,  width: 66, hidden: true },
				   { dataIndex: 'WH_CELL_NAME'		  	,  width: 66, hidden: true },
				   { dataIndex: 'ISSUE_REQ_PRICE'	   	,  width: 66, hidden: true },
				   { dataIndex: 'ISSUE_REQ_AMT'		 	,  width: 66, hidden: true },
				   { dataIndex: 'ISSUE_REQ_TAX_AMT'	 	,  width: 66, hidden: true },
				   { dataIndex: 'TAX_TYPE'			  	,  width: 66, hidden: true },
				   { dataIndex: 'MONEY_UNIT'				,  width: 66, hidden: true },
				   { dataIndex: 'EXCHANGE_RATE'		 	,  width: 66, hidden: true },
				   { dataIndex: 'ACCOUNT_YNC'		   	,  width: 66 },
				   { dataIndex: 'DISCOUNT_RATE'		 	,  width: 66, hidden: true },
				   { dataIndex: 'ISSUE_REQ_PRSN'			,  width: 66, hidden: true },
				   { dataIndex: 'DVRY_CUST_CD'		  	,  width: 66, hidden: true },
				   { dataIndex: 'REMARK'					,  width: 66, hidden: true },
				   { dataIndex: 'SER_NO'					,  width: 66, hidden: true },
				   { dataIndex: 'SALE_CUSTOM_CODE'	  	,  width: 66, hidden: true },
				   { dataIndex: 'SALE_CUST_CD'		  	,  width: 66, hidden: true },
				   { dataIndex: 'ISSUE_DIV_CODE'			,  width: 66, hidden: true },
				   { dataIndex: 'BILL_TYPE'			 	,  width: 66, hidden: true },
				   { dataIndex: 'ORDER_TYPE'				,  width: 66, hidden: true },
				   { dataIndex: 'PRICE_YN'			  	,  width: 80 },
				   { dataIndex: 'PO_NUM'					,  width: 66, hidden: true },
				   { dataIndex: 'PO_SEQ'					,  width: 66, hidden: true },
				   { dataIndex: 'CREDIT_YN'			 	,  width: 66, hidden: true },
				   { dataIndex: 'WON_CALC_BAS'		  	,  width: 66, hidden: true },
				   { dataIndex: 'TAX_INOUT'			 	,  width: 66, hidden: true },
				   { dataIndex: 'AGENT_TYPE'				,  width: 66, hidden: true },
				   { dataIndex: 'STOCK_CARE_YN'		 	,  width: 66, hidden: true },
				   { dataIndex: 'STOCK_UNIT'				,  width: 66, hidden: true },
				   { dataIndex: 'DVRY_CUST_NAME'			,  width: 113 },
				   { dataIndex: 'WONSANGI_NUM'		   	,  width: 100 },
				   { dataIndex: 'SOF100_TAX_INOUT'	  	,  width: 66, hidden: true },
				   { dataIndex: 'RETURN_Q_YN'		   	,  width: 66, hidden: true },
				   { dataIndex: 'ORDER_Q'			   	,  width: 66, hidden: true },
				   { dataIndex: 'REF_CODE2'			 	,  width: 66, hidden: true },
				   { dataIndex: 'EXCESS_RATE'		   	,  width: 66, hidden: true },
				   { dataIndex: 'DEPT_CODE'			 	,  width: 66, hidden: true },
				   { dataIndex: 'ITEM_ACCOUNT'		  	,  width: 66, hidden: true },
				   { dataIndex: 'PRICE_TYPE'				,  width: 66, hidden: true },
				   { dataIndex: 'ISSUE_FOR_WGT_P'	   	,  width: 66, hidden: true },
				   { dataIndex: 'ISSUE_WGT_P'		   	,  width: 66, hidden: true },
				   { dataIndex: 'ISSUE_FOR_VOL_P'	   	,  width: 66, hidden: true },
				   { dataIndex: 'ISSUE_VOL_P'		   	,  width: 66, hidden: true },
				   { dataIndex: 'WGT_UNIT'			  	,  width: 66, hidden: true },
				   { dataIndex: 'UNIT_WGT'			  	,  width: 66, hidden: true },
				   { dataIndex: 'VOL_UNIT'			  	,  width: 66, hidden: true },
				   { dataIndex: 'UNIT_VOL'			  	,  width: 66, hidden: true }
		  ]
	   ,listeners: {
		  		onGridDblClick:function(grid, record, cellIndex, colName) {

  				}
	   		}
	   	,returnData: function()	{
	   		var records = this.getSelectedRecords();

			Ext.each(records, function(record,i){
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setrequestData(record.data);
									});
			this.deleteSelectedRow();
			detailStore.fnOrderAmtSum();
	   	}

	});
	//출하지시 참조 메인
	function openRequestWindow() {
  		if(!UniAppManager.app.checkForNewDetail()) return false;

		if(!referRequestWindow) {
			referRequestWindow = Ext.create('widget.uniDetailWindow', {
				title: '출하지시참조',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [requestSearch, requestGrid],
				tbar:  ['->',
										{	itemId : 'saveBtn',
											text: '조회',
											handler: function() {
												requestStore.loadStoreRecords();
											},
											disabled: false
										},
										{	itemId : 'confirmBtn',
											text: '출고적용',
											handler: function() {
												requestGrid.returnData();
											},
											disabled: false
										},
										{	itemId : 'confirmCloseBtn',
											text: '출고적용 후 닫기',
											handler: function() {
												requestGrid.returnData();
												referRequestWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '닫기',
											handler: function() {
												if(detailStore.getCount() == 0){
													masterForm.setAllFieldsReadOnly(false);
													panelResult.setAllFieldsReadOnly(false);
												}
												referRequestWindow.hide();
											},
											disabled: false
										}
								]
							,
				listeners : {beforehide: function(me, eOpt)	{
											requestSearch.clearForm();
											requestGrid.reset();
							 },
							 beforeclose: function( panel, eOpts )	{
											requestSearch.clearForm();
											requestGrid.reset();
							 },
							 beforeshow: function ( me, eOpts )	{
							 	requestSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
								requestSearch.setValue('MONEY_UNIT',masterForm.getValue('MONEY_UNIT'));
								requestSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
								requestSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
								requestSearch.setValue('CREATE_LOC',masterForm.getValue('CREATE_LOC'));
								requestSearch.setValue('ISSUE_DATE_TO', masterForm.getValue('INOUT_DATE'));
  								requestSearch.setValue('ISSUE_DATE_FR', UniDate.get('startOfMonth', masterForm.getValue('INOUT_DATE')));
// 								requestSearch.setValue('ISSUE_DATE_FR', UniDate.get('startOfMonth', salesOrderSearch.getValue('ISSUE_DATE_TO')));
							 	requestStore.loadStoreRecords();
							 }
				}
			})
		}
		referRequestWindow.center();
		referRequestWindow.show();
	}

	/**
	 * 수주(오퍼)를 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//수주(오퍼) 참조 폼 정의
	var salesOrderSearch = Unilite.createSearchForm('s_str103ukrv_ypsalesOrderForm', {
		layout :  {type : 'uniTable', columns : 2},
		items :[
			Unilite.popup('DIV_PUMOK',{
			fieldLabel:'품목코드' ,
			validateBlank: false,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
				}
			}
		}), {
			fieldLabel: '납기일',
			xtype: 'uniDateRangefield',
			startFieldName: 'DVRY_DATE_FR',
			endFieldName: 'DVRY_DATE_TO',
			width: 350,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
	   }, {
	   		fieldLabel: '수주번호',
	   		xtype: 'uniTextfield',
	   		name:'ORDER_NUM'
	   }, {
	   		fieldLabel: '관리번호',
	   		xtype: 'uniTextfield',
	   		name:'PROJECT_NO'
	   },{
			fieldLabel: '국내외구분',
			name: 'NATION_INOUT',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T109',
			value: '1',
			holdable: 'hold'
		}, {
		   	xtype: 'hiddenfield',
		   	name:'CUSTOM_CODE'
	   }, {
		   	xtype: 'hiddenfield',
		   	name:'CUSTOM_NAME'
	   }, {
	   		xtype: 'hiddenfield',
		   	name: 'DIV_CODE'
	   }, {
	   		xtype: 'hiddenfield',
		   	name: 'MONEY_UNIT'
	   }, {
	   		xtype: 'hiddenfield',
		   	name: 'CREATE_LOC'
	   }]
	});
	//수주(오퍼) 참조 모델 정의
	Unilite.defineModel('s_str103ukrv_ypsalesOrderModel', {
		fields: [{ name: 'ORDER_NUM'				, text:'수주번호' 			,type : 'string' },
			 	 { name: 'SER_NO'					, text:'순번' 				,type : 'string' },
			 	 { name: 'SO_KIND'					, text:'주문구분' 			,type : 'string', comboType: 'AU', comboCode: 'S065' },
			 	 { name: 'INOUT_TYPE_DETAIL'		, text:'출고유형' 			,type : 'string' },
			 	 { name: 'ITEM_CODE'				, text:'품목코드' 			,type : 'string' },
			 	 { name: 'ITEM_NAME'				, text:'품명' 				,type : 'string' },
			 	 { name: 'SPEC'						, text:'규격' 				,type : 'string' },
			 	 { name: 'ORDER_UNIT'				, text:'판매단위' 			,type : 'string', displayField: 'value' },
			 	 { name: 'TRANS_RATE'				, text:'입수' 				,type : 'string' },
			 	 { name: 'DVRY_DATE'				, text:'납기일' 			,type : 'uniDate' },
			 	 { name: 'NOT_INOUT_Q'				, text:'미납량' 			,type : 'uniQty' },
			 	 { name: 'ORDER_Q'					, text:'수주량' 			,type : 'uniQty' },
			 	 { name: 'ISSUE_REQ_Q'				, text:'출하지시량' 		,type : 'uniQty' },
			 	 { name: 'R_LOT_NO'				 , text:'LOT NO'		 ,type : 'string' },
			 	 { name: 'ORDER_WGT_Q'				, text:'수주량(주량)' 		,type : 'string' },
			 	 { name: 'ORDER_VOL_Q'				, text:'수주량(부피)' 		,type : 'string' },
			 	 { name: 'PROJECT_NO'				, text:'프로젝트번호' 		,type : 'string' },
			 	 { name: 'CUSTOM_NAME'				, text:'수주처' 			,type : 'string' },
			 	 { name: 'PO_NUM'					, text:'PO NO' 				,type : 'string' },
			 	 { name: 'PAY_METHODE1'				, text:'대금결제방법' 		,type : 'string' },
			 	 { name: 'LC_SER_NO'				, text:'LC번호' 			,type : 'string' },
			 	 { name: 'CUSTOM_CODE'				, text:'CUSTOM_CODE'	,type : 'string' },
			 	 { name: 'OUT_DIV_CODE'				, text:'OUT_DIV_CODE'	,type : 'string' },
			 	 { name: 'ORDER_P'					, text:'ORDER_P'		,type : 'string' },
			 	 { name: 'ORDER_O'					, text:'ORDER_O'		,type : 'string' },
			 	 { name: 'TAX_TYPE'					, text:'TAX_TYPE'		,type : 'string' },
			 	 { name: 'WH_CODE'					, text:'WH_CODE'		,type : 'string' },
			 	 { name: 'MONEY_UNIT'				, text:'MONEY_UNIT'	 	,type : 'string' },
			 	 { name: 'EXCHG_RATE_O'				, text:'EXCHG_RATE_O'	,type : 'string' },
			 	 { name: 'ACCOUNT_YNC'				, text:'매출대상' 		,type : 'string', comboType: 'AU', comboCode: 'S014' },
			 	 { name: 'DISCOUNT_RATE'			, text:'DISCOUNT_RATE' 	,type : 'string' },
			 	 { name: 'ORDER_PRSN'				, text:'ORDER_PRSN'	 	,type : 'string' },
			 	 { name: 'DVRY_CUST_CD'				, text:'DVRY_CUST_CD'	,type : 'string' },
			 	 { name: 'SALE_CUST_CD'				, text:'SALE_CUST_CD'	,type : 'string' },
			 	 { name: 'SALE_CUST_NM'				, text:'매출처'			,type : 'string' },
			 	 { name: 'BILL_TYPE'				, text:'BILL_TYPE'	 	,type : 'string' },
			 	 { name: 'ORDER_TYPE'				, text:'ORDER_TYPE'	 	,type : 'string' },
			 	 { name: 'PRICE_YN'					, text:'단가구분' 		,type : 'string', comboType: 'AU', comboCode: 'S003' },
			 	 { name: 'PO_SEQ'					, text:'PO_SEQ'		 	,type : 'string' },
			 	 { name: 'CREDIT_YN'				, text:'CREDIT_YN'	 	,type : 'string' },
			 	 { name: 'WON_CALC_BAS'				, text:'WON_CALC_BAS'	,type : 'string' },
			 	 { name: 'TAX_INOUT'				, text:'TAX_INOUT'	 	,type : 'string' },
			 	 { name: 'AGENT_TYPE'				, text:'AGENT_TYPE'	 	,type : 'string' },
			 	 { name: 'STOCK_CARE_YN'			, text:'STOCK_CARE_YN' 	,type : 'string' },
			 	 { name: 'STOCK_UNIT'				, text:'STOCK_UNIT'	 	,type : 'string' },
			 	 { name: 'DVRY_CUST_NAME' 			, text:'배송처' 		,type : 'string' },
			 	 { name: 'RETURN_Q_YN'				, text:'RETURN_Q_YN'	,type : 'string' },
			 	 { name: 'DIV_CODE'					, text:'DIV_CODE'		,type : 'string' },
			 	 { name: 'ORDER_TAX_O'				, text:'ORDER_TAX_O'	,type : 'string' },
			 	 { name: 'EXCESS_RATE'				, text:'EXCESS_RATE'	,type : 'string' },
			 	 { name: 'DEPT_CODE'				, text:'DEPT_CODE'		,type : 'string' },
			 	 { name: 'ITEM_ACCOUNT'				, text:'ITEM_ACCOUNT'	,type : 'string' },
			 	 { name: 'STOCK_Q'					, text:'STOCK_Q'		,type : 'string' },
			 	 { name: 'REMARK'					, text:'REMARK'			,type : 'string' },
			 	 { name: 'PRICE_TYPE'				, text:'PRICE_TYPE'		,type : 'string' },
			 	 { name: 'ORDER_FOR_WGT_P'			, text:'ORDER_FOR_WGT_P',type : 'string' },
			 	 { name: 'ORDER_FOR_VOL_P'			, text:'ORDER_FOR_VOL_P',type : 'string' },
			 	 { name: 'ORDER_WGT_P'				, text:'ORDER_WGT_P'	,type : 'string' },
			 	 { name: 'ORDER_VOL_P'				, text:'ORDER_VOL_P'	,type : 'string' },
			 	 { name: 'WGT_UNIT'					, text:'WGT_UNIT'		,type : 'string' },
			 	 { name: 'UNIT_WGT'					, text:'UNIT_WGT'		,type : 'string' },
			 	 { name: 'VOL_UNIT'					, text:'VOL_UNIT'		,type : 'string' },
				 { name: 'UNIT_VOL'					, text:'UNIT_VOL'		,type : 'string' },
				 { name: 'LOT_YN'				   , text:'LOT_YN'		 ,type : 'string' },
				 { name: 'NATION_INOUT'			 , text:'NATION_INOUT'   ,type : 'string' }
				]
	});

	//수주(오퍼) 참조 스토어 정의
	var salesOrderStore = Unilite.createStore('s_str103ukrv_ypsalesOrderStore', {
			model: 's_str103ukrv_ypsalesOrderModel',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read	: 's_str103ukrv_ypService.selectSalesOrderList'
				}
			}

			,loadStoreRecords : function()	{
				var param= salesOrderSearch.getValues();
				console.log( param );
				param.WH_CODE = masterForm.getValue('WH_CODE');
				param.WH_CELL_CODE = masterForm.getValue('WH_CELL_CODE');
				this.load({
					params : param
				});
			},
			listeners:{
				load:function(store, records, successful, eOpts)	{
					if(successful)	{
					   var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
					   var deleteRecords = new Array();

					   if(masterRecords.items.length > 0)	{
					   	console.log("store.items :", store.items);
					   	console.log("records", records);

						   Ext.each(records,
					   			function(item, i)	{
	   								Ext.each(masterRecords.items, function(record, i)	{
	   										console.log("record :", record);
   										if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM']) // record = masterRecord   item = 참조 Record
   											&& (record.data['ORDER_SEQ'] == item.data['SER_NO'])
   											)
   										{
											deleteRecords.push(item);
   										}
	   								});
					   			});
						   store.remove(deleteRecords);
					   }
					}
				}
			}
	});
	//수주(오퍼) 참조 그리드 정의
	var salesOrderGrid = Unilite.createGrid('s_str103ukrv_ypsalesOrderGrid', {
		// title: '기본',
		layout : 'fit',
		store: salesOrderStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE' }),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns:  [{ dataIndex: 'ORDER_NUM'					,  width: 100 },
			 	   { dataIndex: 'SER_NO'					,  width: 66 },
			 	   { dataIndex: 'SO_KIND'					,  width: 66 },
			 	   { dataIndex: 'INOUT_TYPE_DETAIL'			,  width: 80, hidden: true },
			 	   { dataIndex: 'ITEM_CODE'					,  width: 120 },
			 	   { dataIndex: 'ITEM_NAME'					,  width: 113 },
			 	   { dataIndex: 'SPEC'						,  width: 113 },
			 	   { dataIndex: 'ORDER_UNIT'				,  width: 66, align: 'center' },
			 	   { dataIndex: 'TRANS_RATE'				,  width: 40 },
			 	   { dataIndex: 'DVRY_DATE'					,  width: 80 },
			 	   { dataIndex: 'NOT_INOUT_Q'				,  width: 80 },
			 	   { dataIndex: 'ORDER_Q'					,  width: 80 },
			 	   { dataIndex: 'ISSUE_REQ_Q'				,  width: 100 },
			 	   { dataIndex: 'R_LOT_NO'				  ,  width: 120 },
			 	   { dataIndex: 'ORDER_WGT_Q'				,  width: 100, hidden: true },
			 	   { dataIndex: 'ORDER_VOL_Q'				,  width: 100, hidden: true },
			 	   { dataIndex: 'PROJECT_NO'				,  width: 86 },
			 	   { dataIndex: 'CUSTOM_NAME'				,  width: 120 },
			 	   { dataIndex: 'PO_NUM'					,  width: 86 },
			 	   { dataIndex: 'PAY_METHODE1'				,  width: 100 },
			 	   { dataIndex: 'LC_SER_NO'					,  width: 100 },
			 	   { dataIndex: 'CUSTOM_CODE'				,  width: 66, hidden: true },
			 	   { dataIndex: 'OUT_DIV_CODE'				,  width: 66, hidden: true },
			 	   { dataIndex: 'ORDER_P'					,  width: 66, hidden: true },
			 	   { dataIndex: 'ORDER_O'					,  width: 66, hidden: true },
			 	   { dataIndex: 'TAX_TYPE'					,  width: 66, hidden: true },
			 	   { dataIndex: 'WH_CODE'					,  width: 66, hidden: true },
			 	   { dataIndex: 'MONEY_UNIT'				,  width: 66, hidden: true },
			 	   { dataIndex: 'EXCHG_RATE_O'				,  width: 66, hidden: true },
			 	   { dataIndex: 'ACCOUNT_YNC'				,  width: 66 },
			 	   { dataIndex: 'DISCOUNT_RATE'				,  width: 66, hidden: true },
			 	   { dataIndex: 'ORDER_PRSN'				,  width: 86, hidden: true },
			 	   { dataIndex: 'DVRY_CUST_CD'				,  width: 66, hidden: true },
			 	   { dataIndex: 'SALE_CUST_CD'				,  width: 86, hidden: true },
			 	   { dataIndex: 'SALE_CUST_NM'				,  width: 130},
			 	   { dataIndex: 'BILL_TYPE'					,  width: 66, hidden: true },
			 	   { dataIndex: 'ORDER_TYPE'				,  width: 66, hidden: true },
			 	   { dataIndex: 'PRICE_YN'					,  width: 66 },
			 	   { dataIndex: 'PO_SEQ'					,  width: 86, hidden: true },
			 	   { dataIndex: 'CREDIT_YN'					,  width: 86, hidden: true },
			 	   { dataIndex: 'WON_CALC_BAS'				,  width: 86, hidden: true },
			 	   { dataIndex: 'TAX_INOUT'					,  width: 66, hidden: true },
			 	   { dataIndex: 'AGENT_TYPE'				,  width: 86, hidden: true },
			 	   { dataIndex: 'STOCK_CARE_YN'				,  width: 66, hidden: true },
			 	   { dataIndex: 'STOCK_UNIT'				,  width: 66, hidden: true },
			 	   { dataIndex: 'DVRY_CUST_NAME' 			,  width: 113 },
			 	   { dataIndex: 'RETURN_Q_YN'				,  width: 66, hidden: true },
			 	   { dataIndex: 'DIV_CODE'					,  width: 66, hidden: true },
			 	   { dataIndex: 'ORDER_TAX_O'				,  width: 66, hidden: true },
			 	   { dataIndex: 'EXCESS_RATE'				,  width: 66, hidden: true },
			 	   { dataIndex: 'DEPT_CODE'					,  width: 66, hidden: true },
			 	   { dataIndex: 'ITEM_ACCOUNT'				,  width: 66, hidden: true },
			 	   { dataIndex: 'STOCK_Q'					,  width: 66, hidden: true },
			 	   { dataIndex: 'REMARK'					,  width: 86, hidden: true },
			 	   { dataIndex: 'PRICE_TYPE'				,  width: 66, hidden: true },
			 	   { dataIndex: 'ORDER_FOR_WGT_P'			,  width: 66, hidden: true },
			 	   { dataIndex: 'ORDER_FOR_VOL_P'			,  width: 66, hidden: true },
			 	   { dataIndex: 'ORDER_WGT_P'				,  width: 66, hidden: true },
			 	   { dataIndex: 'ORDER_VOL_P'				,  width: 66, hidden: true },
			 	   { dataIndex: 'WGT_UNIT'					,  width: 66, hidden: true },
			 	   { dataIndex: 'UNIT_WGT'					,  width: 66, hidden: true },
			 	   { dataIndex: 'VOL_UNIT'					,  width: 66, hidden: true },
			 	   { dataIndex: 'UNIT_VOL'					,  width: 66, hidden: true },
			 	   { dataIndex: 'LOT_YN'					,  width: 66, hidden: true },
			 	   { dataIndex: 'NATION_INOUT'			  ,  width: 66, hidden: true }
		  ]
	   ,listeners: {
		  		onGridDblClick:function(grid, record, cellIndex, colName) {

  				}
	   		}
	   	,returnData: function()	{
	   		var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setSalesOrderData(record.data);
									});
			this.deleteSelectedRow();
			detailStore.fnOrderAmtSum();
	   	}

	});
	//수주(오퍼) 참조 메인
	function opensalesOrderWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!refersalesOrderWindow) {
			refersalesOrderWindow = Ext.create('widget.uniDetailWindow', {
				title: '수주(오퍼)참조',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [salesOrderSearch, salesOrderGrid],
				tbar:  ['->',
										{	itemId : 'saveBtn',
											text: '조회',
											handler: function() {
												salesOrderStore.loadStoreRecords();
											},
											disabled: false
										},
										{	itemId : 'confirmBtn',
											text: '출고적용',
											handler: function() {
												salesOrderGrid.returnData();
											},
											disabled: false
										},
										{	itemId : 'confirmCloseBtn',
											text: '출고적용 후 닫기',
											handler: function() {
												salesOrderGrid.returnData();
												refersalesOrderWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '닫기',
											handler: function() {
												if(detailStore.getCount() == 0){
													masterForm.setAllFieldsReadOnly(false);
													panelResult.setAllFieldsReadOnly(false);
												}
												refersalesOrderWindow.hide();
											},
											disabled: false
										}
								]
							,
				listeners : {beforehide: function(me, eOpt)	{
											//salesOrderSearch.clearForm();
											//salesOrderGrid.reset();
										},
							 beforeclose: function( panel, eOpts )	{
											//salesOrderSearch.clearForm();
											//salesOrderGrid.reset();
							 			},
							  beforeshow: function ( me, eOpts )	{
							  	salesOrderSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
								salesOrderSearch.setValue('MONEY_UNIT',masterForm.getValue('MONEY_UNIT'));
								salesOrderSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
								salesOrderSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
								salesOrderSearch.setValue('CREATE_LOC',masterForm.getValue('CREATE_LOC'));
								salesOrderSearch.setValue('DVRY_DATE_TO', masterForm.getValue('INOUT_DATE'));
  								salesOrderSearch.setValue('DVRY_DATE_FR', UniDate.get('startOfMonth', masterForm.getValue('INOUT_DATE')));
//  								salesOrderSearch.setValue('DVRY_DATE_FR', UniDate.get('startOfMonth', salesOrderSearch.getValue('DVRY_DATE_TO')));
  								if(masterForm.getValue('MONEY_UNIT') != 'KRW'){
									salesOrderSearch.setValue('NATION_INOUT', '2');
  								}else{
  									salesOrderSearch.setValue('NATION_INOUT', '1');
  								}
							 	salesOrderStore.loadStoreRecords();
							 }
				}
			})
		}
		refersalesOrderWindow.center();
		refersalesOrderWindow.show();
	}

	/**
	 * main app
	 */
	Unilite.Main({
		id: 'str103ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, detailGrid
			]
		}
		,masterForm
		],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
			masterForm.getField('INOUT_PRSN').focus();
			this.setDefault();
			UniAppManager.app.fnExchngRateO(true);
			Ext.getCmp('btnPrint').setDisabled(true);
//			cbStore.loadStoreRecords();

			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		onQueryButtonDown: function() {
//			masterForm.setAllFieldsReadOnly(false);
//			panelResult.setAllFieldsReadOnly(false);
			var returnNo = masterForm.getValue('INOUT_NUM');
			if(Ext.isEmpty(returnNo)) {
				openSearchInfoWindow()
			} else {
				detailStore.loadStoreRecords();
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		//링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			//this.uniOpt.appParams = params;
			if(params.PGM_ID == 'sof100ukrv' || params.PGM_ID == 's_sof100ukrv_yp' || params.PGM_ID == 's_sof101ukrv_yp') { //수주등록 또는 수주등록(양평)에서 링크넘어올시
				var formPram = params.formPram;
				masterForm.setValue('DIV_CODE'		, formPram.DIV_CODE);
				masterForm.setValue('CUSTOM_CODE'	, formPram.CUSTOM_CODE);
				masterForm.setValue('CUSTOM_NAME'	, formPram.CUSTOM_NAME);
				panelResult.setValue('DIV_CODE'		, formPram.DIV_CODE);
				panelResult.setValue('CUSTOM_CODE'	, formPram.CUSTOM_CODE);
				panelResult.setValue('CUSTOM_NAME'	, formPram.CUSTOM_NAME);
//				panelRsult.setValue('INOUT_NUM', formPram.D)

				Ext.each(params.record, function(rec,i){
					var inoutSeq = detailStore.max('INOUT_SEQ');
					if(!inoutSeq){
					   inoutSeq = 1;
					}else{
					   inoutSeq += 1;
					}
					//출고가능량 = 미납량 = 수주량 - 출고량 + 반품량 - 출하지시량
					var dOrdQ, dRtnQ, dOutQ, dIReqQ, dDoOutQ = 0;
					dOrdQ	= rec.get('ORDER_Q');
					dRtnQ	= rec.get('RETURN_Q');
					dOutQ	= rec.get('OUTSTOCK_Q');
					dIReqQ	= rec.get('ISSUE_REQ_Q');
					dDoOutQ	= rec.get('REQ_ISSUE_QTY');
					dDoOutQ	= dOrdQ - dOutQ + dRtnQ - (dIReqQ - dDoOutQ);

					//출하지시량(중량) 재계산
					var sUnitWgt, sOrderWgtQ, sUnitVol, sOrderVolQ = 0;
					sUnitWgt	= rec.get('UNIT_WGT');
					TextMatrix	= dDoOutQ * sUnitWgt;
					//출하지시량(부피) 재계산
					sUnitVol	= rec.get('UNIT_VOL');
					sOrderVolQ	= dDoOutQ * sUnitVol;

					var orderUnitP	= 0;
					var orderUnitO	= 0;
					var orderTaxO	= 0;
					if(rec.get('ACCOUNT_YNC') != "N"){
						orderUnitP	= rec.get('ORDER_P');
						orderUnitO	= rec.get('ORDER_O');
						orderTaxO	= rec.get('ORDER_TAX_O');
					}
					var taxInout = '';
					if(Ext.isEmpty(rec.get('REF_TAX_INOUT'))){
						taxInout = CustomCodeInfo.gsTaxInout;
					}else{
						taxInout = rec.get('REF_TAX_INOUT');
					}
					var r = {
						INOUT_SEQ			: inoutSeq,
						INOUT_TYPE			: "2",
						INOUT_METH			: "1",
						INOUT_CODE_TYPE		: "4",
						CREATE_LOC			: "1",
						DIV_CODE			: UserInfo.divCode,
						INOUT_CODE			: masterForm.getValue('CUSTOM_CODE'),
						CUSTOM_NAME			: masterForm.getValue('CUSTOM_NAME'),
						INOUT_DATE			: masterForm.getValue('INOUT_DATE'),
						INOUT_TYPE_DETAIL	: Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'),
						REF_CODE2			: '',
						WH_CODE				: rec.get('REF_WH_CODE'),
						WH_NAME				: rec.get('REF_WH_CODE'),
						ITEM_CODE			: rec.get('ITEM_CODE'),
						ITEM_NAME			: rec.get('ITEM_NAME'),
						SPEC				: rec.get('SPEC'),
						ITEM_STATUS			: '1',
						ORDER_UNIT			: rec.get('ORDER_UNIT'),
						TRANS_RATE			: rec.get('TRANS_RATE'),
						ORDER_UNIT_Q		: dDoOutQ,
						ORDER_UNIT_P		: rec.get('ORDER_P'),
						ORIGIN_Q			: dDoOutQ,
						ORDER_NOT_Q			: dDoOutQ,
						ISSUE_NOT_Q			: '0',
						PRICE_TYPE			: rec.get('PRICE_TYPE'),
						WGT_UNIT			: rec.get('WGT_UNIT'),
						UNIT_WGT			: rec.get('UNIT_WGT'),
						VOL_UNIT			: rec.get('VOL_UNIT'),
						UNIT_VOL			: rec.get('UNIT_VOL'),
						INOUT_FOR_WGT_P		: rec.get('ORDER_WGT_P'),
						INOUT_FOR_VOL_P		: rec.get('ORDER_VOL_P'),
						INOUT_WGT_P			: rec.get('ORDER_WGT_P'),
						INOUT_VOL_P			: rec.get('ORDER_VOL_P'),
						INOUT_WGT_Q			: sOrderWgtQ,
						INOUT_VOL_Q			: sOrderVolQ,
						TAX_TYPE			: rec.get('TAX_TYPE'),
						DISCOUNT_RATE		: rec.get('DISCOUNT_RATE'),
						ACCOUNT_YNC			: rec.get('ACCOUNT_YNC'),
						SALE_CUSTOM_CODE	: rec.get('SALE_CUST_CD'),
						SALE_CUST_CD		: rec.get('CUSTOM_NAME'),
						DVRY_CUST_CD		: rec.get('DVRY_CUST_CD'),
						DVRY_CUST_NAME		: rec.get('DVRY_CUST_NAME'),
						ORDER_CUST_CD		: rec.get('ORDER_CUST_CD'),
						PLAN_NUM			: rec.get('REF_PROJECT_NO'),
						BASIS_NUM			: rec.get('PO_NUM'),
						BASIS_SEQ			: rec.get('PO_SEQ'),
						SALE_DIV_CODE		: rec.get('DIV_CODE'),
						MONEY_UNIT			: rec.get('REF_MONEY_UNIT'),
						EXCHG_RATE_O		: rec.get('REF_EXCHG_RATE_O'),
						ORDER_NUM			: rec.get('ORDER_NUM'),
						ORDER_SEQ			: rec.get('SER_NO'),
						ORDER_TYPE			: rec.get('REF_ORDER_TYPE'),
						BILL_TYPE			: rec.get('REF_BILL_TYPE'),
						STOCK_UNIT			: rec.get('STOCK_UNIT'),
						PRICE_YN			: rec.get('PRICE_YN'),
						SALE_TYPE			: rec.get('REF_ORDER_TYPE'),
						SALE_PRSN			: rec.get('REF_ORDER_PRSN'),
						INOUT_PRSN			: masterForm.getValue('INOUT_PRSN'),
						ACCOUNT_Q			: '0',
						SALE_C_YN			: 'N',
						CREDIT_YN			: CustomCodeInfo.gsCustCreditYn,
						WON_CALC_BAS		: CustomCodeInfo.gsUnderCalBase,
						TAX_INOUT			: taxInout,
						AGENT_TYPE			: CustomCodeInfo.gsAgentType,
						STOCK_CARE_YN		: rec.get('REF_STOCK_CARE_YN'),
						REMARK				: rec.get('REMARK'),
						ITEM_ACCOUNT		: rec.get('ITEM_ACCOUNT'),
						GUBUN				: rec.get('FEFER'),
						TRANS_COST			: 0,
						ORDER_UNIT_O		: orderUnitO,
						INOUT_TAX_AMT		: orderTaxO
					}
					detailGrid.createRow(r, 'INOUT_SEQ');
					var record = detailGrid.getSelectedRecord();
					UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), record.get('ITEM_STATUS'), record.get('ITEM_CODE'), record.get('WH_CODE'));
				});
			}
		},
		onNewDataButtonDown: function()	{
//			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
			if(!masterForm.setAllFieldsReadOnly(true)){
					return false;
			}else{
				 var inoutSeq = detailStore.max('INOUT_SEQ');
				 if(!inoutSeq) inoutSeq = 1;
				 else  inoutSeq += 1;

				 var sortSeq = detailStore.max('SORT_SEQ');
				 if(!sortSeq) sortSeq = 1;
				 else  sortSeq += 1;

				 var inoutNum = '';
				 if(!Ext.isEmpty(masterForm.getValue('INOUT_NUM')))	{
				 	inoutNum = masterForm.getValue('INOUT_NUM');
				 }

				 var inoutCode = '';
				 if(!Ext.isEmpty(masterForm.getValue('CUSTOM_CODE')))	{
				 	inoutCode = masterForm.getValue('CUSTOM_CODE');
				 }

				 var customName = '';
				 if(!Ext.isEmpty(masterForm.getValue('CUSTOM_NAME')))	{
				 	customName = masterForm.getValue('CUSTOM_NAME');
				 }

				 var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
				 var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2

				 var createLoc = '';
				 if(!Ext.isEmpty(masterForm.getValue('CREATE_LOC')))	{
				 	createLoc = masterForm.getValue('CREATE_LOC');
				 }
				 var moneyUnit = '';
				 if(!Ext.isEmpty(masterForm.getValue('MONEY_UNIT')))	{
				 	moneyUnit = masterForm.getValue('MONEY_UNIT');
				 }
				 var exchgRateO = '';
				 if(!Ext.isEmpty(masterForm.getValue('EXCHG_RATE_O')))	{
				 	exchgRateO = masterForm.getValue('EXCHG_RATE_O');
				 }

				 var inoutPrsn = '';
				 if(!Ext.isEmpty(masterForm.getValue('INOUT_PRSN')))	{
				 	inoutPrsn = masterForm.getValue('INOUT_PRSN');
				 }

				 var saleCustCD = '';
				 if(!Ext.isEmpty(masterForm.getValue('CUSTOM_NAME')))	{
				 	saleCustCD = masterForm.getValue('CUSTOM_NAME');
				 }
				 var saleCustomCd = '';
				 if(!Ext.isEmpty(masterForm.getValue('CUSTOM_CODE')))	{
				 	saleCustomCd = masterForm.getValue('CUSTOM_CODE');
				 }

				 var saleDivCode = '';
				 if(BsaCodeInfo.gsOptDivCode == "1"){
				 	saleDivCode = masterForm.getValue('DIV_CODE');
				 }else{
				 	saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
				 }

				 var divCode = '';
				 if(BsaCodeInfo.gsOptDivCode == "1"){
				 	saleDivCode = masterForm.getValue('DIV_CODE');
				 }else{
				 	saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
				 }

				 var saleType = Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value'); //판매유형콤보value중 첫번째 value
				 var taxInout = CustomCodeInfo.gsTaxInout;

				 var deptCode = '';
				 if(!Ext.isEmpty(masterForm.getValue('DEPT_CODE')))	{
				 	deptCode = masterForm.getValue('DEPT_CODE');
				 }

				 var whCode = '';
				 if(!Ext.isEmpty(masterForm.getValue('WH_CODE'))){
				 	whCode = masterForm.getValue('WH_CODE');
				 }
				 var whCellCode = '';
				 if(!Ext.isEmpty(masterForm.getValue('WH_CELL_CODE'))){
					whCellCode= masterForm.getValue('WH_CELL_CODE');
				 }
				 var salePrsn = CustomCodeInfo.gsbusiPrsn;

				 var nationInout = '';
				 if(!Ext.isEmpty(masterForm.getValue('NATION_INOUT'))) {
					nationInout = masterForm.getValue('NATION_INOUT');
				 }

				 var inoutDate= '';
				 if(!Ext.isEmpty(masterForm.getValue('INOUT_DATE'))) {
					inoutDate = masterForm.getValue('INOUT_DATE');
				 }

				 var saleDate= '';
				 if(!Ext.isEmpty(masterForm.getValue('SALE_DATE'))) {
					saleDate = masterForm.getValue('SALE_DATE');
				 }

				var r = {
						INOUT_SEQ: inoutSeq,
						SORT_SEQ: sortSeq,
						INOUT_NUM: inoutNum,
						INOUT_CODE: inoutCode,
						CUSTOM_NAME: customName,
						INOUT_TYPE_DETAIL: inoutTypeDetail,
						REF_CODE2: refCode2,
						CREATE_LOC: createLoc,
						MONEY_UNIT: moneyUnit,
						EXCHG_RATE_O: exchgRateO,
						INOUT_PRSN: inoutPrsn,
						SALE_CUST_CD: saleCustCD,
						SALE_CUSTOM_CODE: saleCustomCd,
						SALE_DIV_CODE: saleDivCode,
						DIV_CODE: divCode,
						SALE_TYPE: saleType,
						TAX_INOUT: taxInout,
						DEPT_CODE: deptCode,
						WH_CODE: whCode,
						WH_CELL_CODE: whCellCode,
						SALE_PRSN: salePrsn,
						NATION_INOUT: nationInout,
						INOUT_DATE: inoutDate,
						SALE_DATE: saleDate,
						ORDER_NUM :'01S201808020001',
						ISSUE_REQ_NUM:'01S201810080001'

					};
					masterForm.setAllFieldsReadOnly(true);
					panelResult.setAllFieldsReadOnly(true);
//					var createRow = detailGrid.createRow(r, null, detailGrid.getStore().getCount() - 1);
//					var createRow = detailGrid.createRow(r);
//					cbStore.loadStoreRecords(whCode);
					detailGrid.createRow(r);

				var param = {
							"DIV_CODE": masterForm.getValue('DIV_CODE'),
							"DEPT_CODE": masterForm.getValue('DEPT_CODE')
				};

//				str10s_s_str103ukrv_yp_ypce.deptWhcode(param, function(provider, response){
//					if(!Ext.isEmpty(provider)){
//						 var whCode = provider['WH_CODE'];
//						 createRow.set('WH_CODE', whCode);
//					}else{
//						 var whCode = '';
//					}
//				});

			}
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailStore.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(Ext.isEmpty(CustomCodeInfo.gsbusiPrsn) && BsaCodeInfo.gsInoutAutoYN == 'Y' && gsRefYn == 'N'){
//				if(confirm(Msg.sMS507 + '(' + masterForm.getValue('CUSTOM_NAME') + ')' + Msg.sMS377 + '\n' + Msg.sMS357)){
					detailStore.saveStore();
//				}else{
//					return false;
//				}
			}else{
				detailStore.saveStore();
			}

		},
		onDeleteDataButtonDown: function() {
			if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
				alert(Msg.sMS042); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
				return false;
			}
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(BsaCodeInfo.gsInoutAutoYN == "N" && selRow.get('ACCOUNT_Q') > 0) {//동시매출발생이 아닌 경우,매출존재체크 제외
					alert(Msg.sMS335);	//매출이 진행된 건은 수정/삭제할 수 없습니다.
					return false;
				}
				if(selRow.get('SALE_C_YN') == "Y"){
					alert(Msg.sMS214);	//계산서가 마감된 건은 수정/삭제가 불가능합니다.
					return false;
				}
				detailGrid.deleteSelectedRow();
			}
			detailStore.fnOrderAmtSum();
		},
		 onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
							alert(Msg.sMS042); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
							return false;
						}
						Ext.each(records, function(record,i) {
							if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q') > 0) {//동시매출발생이 아닌 경우,매출존재체크 제외
								alert(Msg.sMS335);	//매출이 진행된 건은 수정/삭제할 수 없습니다.
								deletable = false;
								return false;
							}
							if(record.get('SALE_C_YN') == "Y"){
								alert(Msg.sMS214);	//계산서가 마감된 건은 수정/삭제가 불가능합니다.
								deletable = false;
								return false;
							}
						});
						/*---------삭제전 로직 구현 끝-----------*/

						if(deletable){
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}

		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_str103ukrv_ypAdvanceSerch');
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		rejectSave: function() {
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			detailStore.rejectChanges();

			if(rowIndex >= 0){
				detailGrid.getSelectionModel().select(rowIndex);
				var selected = detailGrid.getSelectedRecord();

				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			detailStore.onStoreActionEnable();

		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('s_str103ukrv_ypFileUploadPanel');
			if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			/*영업담당 filter set*/
			gsMonClosing = '';	//월마감 여부
			gsDayClosing = '';	//일마감 여부
			var field = masterForm.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var param = {
				"DIV_CODE": UserInfo.divCode,
				"DEPT_CODE": UserInfo.deptCode
			};
			str110ukrvService.deptWhcode(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					 masterForm.setValue('ALL_CHANGE_WH_CODE', provider['WH_CODE']);
				}
			});
			var inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set

			masterForm.setValue('DIV_CODE', UserInfo.divCode);
			//masterForm.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
			masterForm.setValue('INOUT_DATE',new Date());
			masterForm.setValue('SALE_DATE',new Date());
			masterForm.setValue('CREATE_LOC','1');
//			masterForm.setValue('MONEY_UNIT',BsaCodeInfo.gsMoneyUnit);
			masterForm.setValue('DEPT_CODE', UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME', UserInfo.deptName);
			masterForm.setValue('EXCHG_RATE_O', '1');
			masterForm.setValue('MONEY_UNIT', 'KRW');
			masterForm.setValue('NATION_INOUT', '1');
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			//panelResult.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
			panelResult.setValue('INOUT_DATE',new Date());
			panelResult.setValue('SALE_DATE',new Date());
			panelResult.setValue('CREATE_LOC','1');
//			panelResult.setValue('MONEY_UNIT',BsaCodeInfo.gsMoneyUnit);
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('EXCHG_RATE_O', '1');
			panelResult.setValue('MONEY_UNIT', 'KRW');
			panelResult.setValue('NATION_INOUT', '1');
		  //masterForm.setValue('REMAIN_CREDIT', UniSales.fnGetCustCredit(UserInfo.compCode, detailForm.getValue('DIV_CODE'), detailForm.getValue("CUSTOM_CODE"), detailForm.getValue('ORDER_DATE'), UserInfo.currency));

			masterForm.setValue('EXCHG_RATE_O',1);				//환율
			masterForm.setValue('TOT_SALE_TAXI',0);		 //과세초액
			masterForm.setValue('TOT_TAXI',0);			  //세액합계(2)
//			masterForm.setValue('TOT_QTY',0);			   //수량총계
			masterForm.setValue('TOT_SALENO_TAXI',0);	   //면세총액(3)
			masterForm.setValue('TOTAL_AMT',0);			 //출고총액[(1)+(2)+(3)]
			masterForm.setValue('REM_CREDIT',0);			//여신액


			panelResult.setValue('TOT_SALE_TAXI',0);		 //과세초액
			panelResult.setValue('TOT_TAXI',0);			  //세액합계(2)
//			panelResult.setValue('TOT_QTY',0);			   //수량총계
			panelResult.setValue('TOT_SALENO_TAXI',0);	   //면세총액(3)
			panelResult.setValue('TOTAL_AMT',0);			 //출고총액[(1)+(2)+(3)]
			panelResult.setValue('REM_CREDIT',0);			//여신액

			if(BsaCodeInfo.gsAutoType == "Y"){
				masterForm.getForm().findField('INOUT_NUM').setReadOnly(true);
				panelResult.getForm().findField('INOUT_NUM').setReadOnly(true);
			}else{
				masterForm.getForm().findField('INOUT_NUM').setReadOnly(false);
				panelResult.getForm().findField('INOUT_NUM').setReadOnly(false);
			}
			/*   '사업장 권한 설정	////
				If gsAuParam(0) <> "N" Then
					txtDivCode.disabled = True
					btnDivCode.disabled = True
				End If
			 */
			masterForm.getField('TOT_SALE_TAXI').setReadOnly(true);
			masterForm.getField('TOT_TAXI').setReadOnly(true);
//			masterForm.getField('TOT_QTY').setReadOnly(true);
			masterForm.getField('TOT_SALENO_TAXI').setReadOnly(true);
			masterForm.getField('TOTAL_AMT').setReadOnly(true);

			panelResult.getField('TOT_SALE_TAXI').setReadOnly(true);
			panelResult.getField('TOT_TAXI').setReadOnly(true);
//			panelResult.getField('TOT_QTY').setReadOnly(true);
			panelResult.getField('TOT_SALENO_TAXI').setReadOnly(true);
			panelResult.getField('TOTAL_AMT').setReadOnly(true);

			gsRefYn = 'N'


			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();


			UniAppManager.setToolbarButtons('save', false);
		},
		 checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('CUSTOM_CODE')))	{
				alert('<t:message code="unilite.msg.sMSR213" default="거래처"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}

			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			panelResult.setAllFieldsReadOnly(true);
			return masterForm.setAllFieldsReadOnly(true);
		},
		fnOrderAmtCal: function(rtnRecord, sType, fieldName, nValue, taxType) {

			var dTransRate = 	fieldName=='TRANS_RATE' 	? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);
			var dOrderQ = 		fieldName=='ORDER_UNIT_Q' 	? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_Q'),0);
			var dIssueReqWgtQ = fieldName=='INOUT_WGT_Q' 	? nValue : Unilite.nvl(rtnRecord.get('INOUT_WGT_Q'),0);
			var dIssueReqVolQ = fieldName=='INOUT_VOL_Q' 	? nValue : Unilite.nvl(rtnRecord.get('INOUT_VOL_Q'),0);
			var dOrderP = 		fieldName=='ORDER_UNIT_P' 	? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_P'),0);
			var saleBasisP = 	fieldName=='SALE_BASIS_P' 	? nValue : Unilite.nvl(rtnRecord.get('SALE_BASIS_P'),0);
			var dOrderWgtForP = fieldName=='INOUT_FOR_WGT_P'? nValue : Unilite.nvl(rtnRecord.get('INOUT_FOR_WGT_P'),0);
			var dOrderVolForP = fieldName=='INOUT_FOR_VOL_P'? nValue : Unilite.nvl(rtnRecord.get('INOUT_FOR_VOL_P'),0);
			var dOrderO = 		fieldName=='ORDER_UNIT_O' 	? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_O'),0);
			var dDcRate = 		fieldName=='DISCOUNT_RATE' 	? nValue : Unilite.nvl((100 - rtnRecord.get('DISCOUNT_RATE')),0);
			var dExchgRate = 	fieldName=='EXCHG_RATE_O' 	? nValue : Unilite.nvl(rtnRecord.get('EXCHG_RATE_O'),0);
			var dPriceType = Ext.isEmpty(rtnRecord.get('PRICE_TYPE')) ? 'A' : rtnRecord.get('PRICE_TYPE');//단가구분
			var dOrderWgtP = 0;
			var dOrderVolP = 0;
			var dOrderForO = 0;
			var dOrderForP = 0;

			if(sType == "P" || sType == "Q"){
				dOrderWgtP = dOrderWgtForP * dExchgRate;
				dOrderVolP = dOrderVolForP * dExchgRate;

				if(dPriceType == "A"){
					dOrderForO = dOrderQ * dOrderP
					dOrderO	= dOrderQ * dOrderP
				}else if(dPriceType == "B"){
					dOrderForO = dIssueReqWgtQ * dOrderWgtForP
					dOrderO	= dIssueReqWgtQ * dOrderWgtP
				}else if(dPriceType == "C"){
					dOrderForO = dIssueReqVolQ * dOrderVolForP
			   		dOrderO	= dIssueReqVolQ * dOrderVolP
				}else{
					dOrderForO = dOrderQ * dOrderP
					dOrderO	= dOrderQ * dOrderP
				}

				rtnRecord.set('ORDER_UNIT_O', dOrderForO);
				rtnRecord.set('ORDER_UNIT_P', dOrderP);
				rtnRecord.set('INOUT_FOR_WGT_P', dOrderWgtForP);
				rtnRecord.set('INOUT_FOR_VOL_P', dOrderVolForP);

				rtnRecord.set('INOUT_WGT_P', dOrderWgtP);
				rtnRecord.set('INOUT_VOL_P', dOrderVolP);

				this.fnTaxCalculate(rtnRecord, dOrderO);
			}else if(sType == "O" && (dOrderQ > 0)){
				dOrderForP	= dOrderO / dOrderQ;
				dOrderP	   = (dOrderO / dOrderQ) * dExchgRate;

				if(dIssueReqWgtQ != 0){
					dOrderWgtForP	= (dOrderO / dIssueReqWgtQ);
					dOrderWgtP	   = (dOrderO / dIssueReqWgtQ) * dExchgRate;
				}else{
					dOrderWgtForP	= 0;
					dOrderWgtP	   = 0;
				}

				if(dIssueReqVolQ != 0){
					dOrderVolForP	= (dOrderO / dIssueReqVolQ)
					dOrderVolP	   = (dOrderO / dIssueReqVolQ) * dExchgRate
				}else{
					dOrderVolForP	= 0
					dOrderVolP	   = 0
				}

				if(dPriceType == "A"){
					dOrderO = dOrderForP * dOrderQ;
				}else if(dPriceType == "B"){
					dOrderO = dOrderWgtForP * dIssueReqWgtQ;
				}else if(dPriceType == "C"){
					dOrderO = dOrderVolForP * dIssueReqVolQ;
				}else{
					dOrderO = dOrderForP * dOrderQ;
				}

				rtnRecord.set('INOUT_WGT_P', dOrderWgtP);
				rtnRecord.set('INOUT_VOL_P', dOrderVolP);

				rtnRecord.set('ORDER_UNIT_P', dOrderForP);
				rtnRecord.set('INOUT_FOR_WGT_P', dOrderWgtForP);
				rtnRecord.set('INOUT_FOR_VOL_P', dOrderVolForP);
				rtnRecord.set('ORDER_UNIT_O', dOrderO);
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType);
			}else if(sType == "C"){
				dOrderP = (dOrderP - (dOrderP * (dDcRate / 100)));
				rtnRecord.set('ORDER_UNIT_P', dOrderP);
				dOrderO = dOrderQ * dOrderP;
				rtnRecord.set('ORDER_UNIT_O', dOrderO);

				dOrderWgtForP = (dOrderO / dIssueReqWgtQ);
				dOrderVolForP = (dOrderO / dIssueReqVolQ);
				dOrderWgtP = (dOrderO / dIssueReqWgtQ) * dExchgRate;
				dOrderVolP = (dOrderO / dIssueReqVolQ) * dExchgRate;

				rtnRecord.set('INOUT_WGT_P', dOrderWgtP);
				rtnRecord.set('INOUT_VOL_P', dOrderVolP);
				rtnRecord.set('INOUT_FOR_WGT_P', dOrderWgtForP);
				rtnRecord.set('INOUT_FOR_VOL_P', dOrderVolForP);
				this.fnTaxCalculate(rtnRecord, dOrderO);
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO, taxType) {
			var sTaxType 	  = Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;
			var sWonCalBas 	  = CustomCodeInfo.gsUnderCalBase;
			var sTaxInoutType = rtnRecord.get('TAX_INOUT');
			var dVatRate = parseInt(BsaCodeInfo.gsVatRate);
			var dAmountI = dOrderO;
			var dOrderAmtO = 0;
			var dTaxAmtO = 0;
			var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
			if(sTaxInoutType=="1") {	//별도
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, sWonCalBas, numDigitOfPrice);
				dTaxAmtO   = UniSales.fnAmtWonCalc(dOrderAmtO * dVatRate / 100, sWonCalBas, numDigitOfPrice);
			}else if(sTaxInoutType=="2") {	//포함
				dAmountI =   UniSales.fnAmtWonCalc(dAmountI, sWonCalBas, numDigitOfPrice);
				dOrderAmtO = UniSales.fnAmtWonCalc(dAmountI / ( dVatRate + 100 ) * 100, sWonCalBas, numDigitOfPrice);
				//20200513 수정: 계산기준을 부가세액으로 통일
//				dTaxAmtO = 	 UniSales.fnAmtWonCalc(dAmountI - dOrderAmtO, sWonCalBas, numDigitOfPrice);
				dTaxAmtO = 	 UniSales.fnAmtWonCalc(dOrderAmtO * dVatRate / 100 , sWonCalBas, numDigitOfPrice);
				dOrderAmtO = UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), sWonCalBas, numDigitOfPrice) ;
			}
			if(sTaxType == "2")	{
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice ) ;
				dTaxAmtO = 0;
			}
			rtnRecord.set('ORDER_UNIT_O',dOrderAmtO.toFixed(0));
			rtnRecord.set('INOUT_TAX_AMT',dTaxAmtO.toFixed(0));
			rtnRecord.set('ORDER_AMT_SUM', (dOrderAmtO + dTaxAmtO).toFixed(0));
		},
		fnCheckNum: function(value, record, fieldName) {
			var r = true;
			if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N")	{
				r = true;
			} else if(record.get("PRICE_YN") == "2" )	{
				if(value < 0)	{
					alert(Msg.sMB076);
					r=false;
					return r;
				}else if(value == 0)	{
					if(fieldName == "ORDER_TAX_O")	{
						if(BsaCodeInfo.gsVatRate != 0)	{
							alert(Msg.sMB083);
							r=false;
						}
					}else {
						alert(Msg.sMB083);
						r=false;
					}
				}
			}
			return r;
		},
		fnGetSubCode: function(rtnRecord, subCode)	{
			var fRecord = '';
			Ext.each(BsaCodeInfo.grsOutType, function(item, i)	{

				if(item['codeNo'] == subCode) {
					fRecord = item['refCode2'];
					if(Ext.isEmpty(fRecord)){
						fRecord = item['codeNo']
					}
				}
			})
			return fRecord;
		},
		fnAccountYN: function(rtnRecord, subCode)	{
			var fRecord ='';
			Ext.each(BsaCodeInfo.grsOutType, function(item, i)	{
				if(item['codeNo'] == subCode && !Ext.isEmpty(item['refCode1'])) {
					fRecord = item['refCode1'];
				}
			});
			if(Ext.isEmpty(fRecord)){
				fRecord = 'N'
			}
			return fRecord;
		},
		cbStockQ: function(provider, params)	{
			var rtnRecord = params.rtnRecord;

			var dStockQ = Unilite.nvl(provider['STOCK_Q'], 0);
//			var dOrderQ = Unilite.nvl(rtnRecord.get('ORDER_Q'), 0);
			var lTrnsRate = 0;
			if(Ext.isEmpty(rtnRecord.get('TRANS_RATE')) || rtnRecord.get('TRANS_RATE') == 0){
				lTrnsRate = 1
			}else{
				lTrnsRate = rtnRecord.get('TRANS_RATE');
			}

			rtnRecord.set('STOCK_Q', dStockQ);
			rtnRecord.set('ORDER_STOCK_Q', dStockQ / lTrnsRate);
		},
		// UniSales.fnGetDivPriceInfo2 callback 함수
		cbGetPriceInfo: function(provider, params)	{
			var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);//판매단가(판매단위)
			var dWgtPrice = Unilite.nvl(provider['WGT_PRICE'],0);//판매단가(중량단위)
			var dVolPrice = Unilite.nvl(provider['VOL_PRICE'],0);//판매단가(부피단위)

			var dUnitWgt = 0;
			var dUnitVol = 0;
			if(params.sType=='I')	{
				dUnitWgt = params.unitWgt;
				dUnitVol = params.unitVol;
				if(params.priceType == 'A')	{
					dWgtPrice = (dUnitWgt = 0) ?	0 : dSalePrice / dUnitWgt;
					dVolPrice = (dUnitVol = 0) ?	0 : dSalePrice / dUnitVol;
				}else if(params.priceType == 'B'){
					dSalePrice = dWgtPrice  * dUnitWgt;
					dVolPrice = (dUnitVol = 0) ? 0 : dSalePrice / dUnitVol;
				}else if(params.priceType == 'C'){
					dSalePrice = dVolPrice  * dUnitVol;
					dWgtPrice = (dUnitWgt = 0) ? 0 : dSalePrice / dUnitWgt;
				}else{
					dWgtPrice = (dUnitWgt = 0) ? 0 : dSalePrice / dUnitWgt;
					dVolPrice = (dUnitVol = 0) ? 0 : dSalePrice / dUnitVol;
				}
				if(Ext.isEmpty(provider['SALE_PRICE'])){
					params.rtnRecord.set('ORDER_UNIT_P', 0);
					params.rtnRecord.set('SALE_BASIS_P'	, 0);
				}else{
					params.rtnRecord.set('ORDER_UNIT_P', provider['SALE_PRICE']);
					params.rtnRecord.set('SALE_BASIS_P'	, provider['SALE_PRICE']);
				}
				params.rtnRecord.set('INOUT_WGT_P', dWgtPrice );
				params.rtnRecord.set('INOUT_VOL_P', dVolPrice );

				if(Ext.isEmpty(provider['SALE_TRANS_RATE'])){
					params.rtnRecord.set('TRANS_RATE', 1);
				}else{
					params.rtnRecord.set('TRANS_RATE', provider['SALE_TRANS_RATE']);
				}

				if(Ext.isEmpty(provider['DC_RATE'])){
					params.rtnRecord.set('DISCOUNT_RATE', 0);
				}else{
					params.rtnRecord.set('DISCOUNT_RATE', provider['DC_RATE']);
				}
				var exchangRate = masterForm.getValue('EXCHG_RATE_O');
				params.rtnRecord.set('INOUT_FOR_WGT_P', dWgtPrice / exchangRate);
				params.rtnRecord.set('INOUT_FOR_VOL_P', dVolPrice / exchangRate);

				params.rtnRecord.set('PRICE_YN',provider['PRICE_TYPE']);

			}
			if(params.rtnRecord.get('INOUT_FOR_VOL_P') > 0){
				UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P");
			}
		},
		fnGetSalePrsnDivCode: function(subCode){	//거래처의 영업담당자의 사업장 가져오기
			var fRecord ='';
			Ext.each(BsaCodeInfo.salePrsn, function(item, i)	{
				if(item['codeNo'] == subCode) {
					fRecord = item['refCode1'];
				}
			});
			return fRecord;
		},
		fnGetInoutPrsnDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i)	{
				if(item['refCode1'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		 fnGetWhName: function(subCode){	//창고코드로 네임 가져오기
			var whName ='';
			Ext.each(BsaCodeInfo.whList, function(item, i)	{
				if(item['value'] == subCode) {
					whName = item['text'];
				}
			});
			return whName;
		},
		cbGetClosingInfo: function(params){
			gsMonClosing = params.gsMonClosing
			gsDayClosing = params.gsDayClosing
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE')),
				"MONEY_UNIT" : masterForm.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(masterForm.getValue('MONEY_UNIT')) && masterForm.getValue('MONEY_UNIT') != "KRW"){
						alert('환율정보가 없습니다.')
					}
					masterForm.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
					panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				}

			});
		}
	});

	/**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q')){
				rv = Msg.sMS335;
			}else if( record.get('SALE_C_YN' == 'Y')){
				rv = Msg.sMS214;
			}else{
				switch(fieldName) {
					case "INOUT_SEQ" :
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						break;

					case "INOUT_TYPE_DETAIL" :
					 	var sRefCode2 = UniAppManager.app.fnGetSubCode(null, newValue) ;	//출고유형value의 ref2
					 	var OldRefCode2 = record.get('REF_CODE2');
					 	record.set('REF_CODE2', sRefCode2);
					 	if((sRefCode2 > "91" && sRefCode2 < "99" ) || sRefCode2 == "C1"){
					 		record.set('REF_CODE2', OldRefCode2);
					 		rv=Msg.sMS255;
					 		break;
					 	}else if(sRefCode2 == "AU"){
					 		if(record.get('STOCK_CARE_YN') != "N"){
					 			record.set('ITEM_CODE', '');
					 			record.set('ITEM_NAME', '');
					 			record.set('SPEC', "");
					 			break;
					 		}
					 		record.set('ACCOUNT_YNC','Y');	//매출대상
					 		record.set('STOCK_CARE_YN','N');	//재고대상여부 - 아니오

					 	}else if(sRefCode2 == "91"){
					 		if(!Ext.isEmpty(record.get('STOCK_CARE_YN')) || !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))){
					 			record.set('REF_CODE2', OldRefCode2);
					 			rv=Msg.sMS255;
					 			break;
					 		}
					 		record.set('ACCOUNT_YNC','N');	//미매출대상
					 		record.set('ITEM_STATUS','1');	//불량 -> 양품으로 바꿈 20160701

					 	}else{
					 		if((!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) || (Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) || (!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM')))){
					 			//skip
					 		}else{
								record.set('ACCOUNT_YNC', UniAppManager.app.fnAccountYN(null, newValue));
					 		}
					 		record.set('ACCOUNT_YNC', UniAppManager.app.fnAccountYN(null, newValue));
					 	}
						break;

					case "WH_CODE" :
						if(!Ext.isEmpty(newValue)){
							record.set('WH_NAME',e.column.field.getRawValue());
							record.set('WH_CELL_CODE', "");
							record.set('WH_CELL_NAME', "");
							record.set('LOT_NO', "");
						}else{
							record.set('WH_CODE', "");
							record.set('WH_CELL_CODE', "");
							record.set('WH_CELL_NAME', "");
							record.set('LOT_NO', "");
						}
						if(!Ext.isEmpty(record.get('ITEM_CODE'))){
							UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), record.get('ITEM_STATUS'), record.get('ITEM_CODE'),  newValue);

						}
						//그리드 창고cell콤보 reLoad..
//						cbStore.loadStoreRecords(newValue);
						break;

					case "WH_CELL_CODE" :
						record.set('WH_CELL_NAME',e.column.field.getRawValue());
						break;

					case "ITEM_STATUS" :
						if(!Ext.isEmpty(record.get('ITEM_CODE'))){
							UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), newValue, record.get('ITEM_CODE'), record.get('WH_CODE'));
						}
						break;

					case "ORDER_UNIT" :
						UniSales.fnGetDivPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
												,'I'
												,UserInfo.compCode
												,record.get('INOUT_CODE')
												,record.get('AGENT_TYPE')
												,record.get('ITEM_CODE')
												,BsaCodeInfo.gsMoneyUnit
												,newValue
												,record.get('STOCK_UNIT')
												,record.get('TRANS_RATE')
												,UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE'))
												,record.get('ORDER_UNIT_Q')
												,record.get('WGT_UNIT')
												,record.get('VOL_UNIT')
												,record.get('UNIT_WGT')
												,record.get('UNIT_VOL')
												,record.get('PRICE_TYPE')
												,record.get('PRICE_YN')
												)
						detailStore.fnOrderAmtSum();
						break;

					case "PRICE_YN" :
//						UniSales.fnGetDivPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
//												,'I'
//												,UserInfo.compCode
//												,record.get('INOUT_CODE')
//												,record.get('AGENT_TYPE')
//												,record.get('ITEM_CODE')
//												,BsaCodeInfo.gsMoneyUnit
//												,record.get('ORDER_UNIT')
//												,record.get('STOCK_UNIT')
//												,record.get('TRANS_RATE')
//												,UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE'))
//												,record.get('ORDER_UNIT_Q')
//												,record.get('WGT_UNIT')
//												,record.get('VOL_UNIT')
//												,record.get('UNIT_WGT')
//												,record.get('UNIT_VOL')
//												,record.get('PRICE_TYPE')
//												,newValue
//												)
//						detailStore.fnOrderAmtSum();
						break;

					case "TRANS_RATE" :
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						UniSales.fnGetDivPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
												,'R'
												,UserInfo.compCode
												,record.get('INOUT_CODE')
												,record.get('AGENT_TYPE')
												,record.get('ITEM_CODE')
												,BsaCodeInfo.gsMoneyUnit
												,record.get('ORDER_UNIT')
												,record.get('STOCK_UNIT')
												,newValue
												,UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE'))
												,record.get('ORDER_UNIT_Q')
												,record.get('WGT_UNIT')
												,record.get('VOL_UNIT')
												,record.get('UNIT_WGT')
												,record.get('UNIT_VOL')
												,record.get('PRICE_TYPE')
												,record.get('PRICE_YN')
												)
						detailStore.fnOrderAmtSum();
						break;

					case "ORDER_UNIT_Q" :
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						var sInout_q = newValue;	//출고량
						var sInv_q = record.get('STOCK_Q');	//재고량
						var sOriginQ = record.get('ORIGIN_Q'); //출고량
						var lot_q = record.get('TEMP_ORDER_UNIT_Q');//로트팝업에서 넘겨받는 수량

						if(!Ext.isEmpty(lot_q) && lot_q!= 0){
							if(sInout_q > lot_q){
								rv = "출고량은 lot재고량을 초과할 수 없습니다. 현재고: " + lot_q;
								break;
							}
						}


						if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")){
							if(sInout_q > (sInv_q + sOriginQ)){
								rv=Msg.sMS210;	//출고량은 재고량을 초과할 수 없습니다.
								break;
							}
						}
						//출고량(중량) 재계산
						var sUnitWgt = record.get('UNIT_WGT');
						var sOrderWgtQ = sInout_q * sUnitWgt;
						record.set('INOUT_WGT_Q', sOrderWgtQ);

						//출고량(부피) 재계산
						var sUnitVol = record.get('UNIT_VOL');
						var sOrderVolQ = sInout_q * sUnitVol;
						record.set('INOUT_VOL_Q', sOrderVolQ);

						UniAppManager.app.fnOrderAmtCal(record, 'Q', fieldName, newValue);
						detailStore.fnOrderAmtSum();
						break;

					case "INOUT_WGT_Q" :	//hidden
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						var sOrderWgtQ = record.get('INOUT_WGT_Q');
						var sUnitWgt = record.get('UNIT_WGT');
						if(sUnitWgt == 0){
							rv='단위중량이 입력되지 않아서 계산이 불가능합니다. 품목정보에서 단위중량을 확인하시기 바랍니다.'
							break;
						}
						var sInout_q = sUnitWgt == 0 ? 0 : sOrderWgtQ / sUnitWgt;
						if(BsaCodeInfo.gsPointYn == "N" && (record.get('ORDER_UNIT') == BsaCodeInfo.gsPointYn)){
							if(sInout_q - (Math.floor(sInout_q)) != 0){
								rv='수주량(판매단위)은 소숫점을 입력할 수 없습니다. 수주량(중량단위)을 확인하시기 바랍니다.'
								break;
							}
						}
						record.set('ORDER_UNIT_Q', sInout_q);
						sInout_q = record.get('ORDER_UNIT_Q');
						var sInv_q = record.get('STOCK_Q');	//재고량
						var sOriginQ = record.get('ORIGIN_Q');//출고량
						var sExcessQ = record.get('EXCESS_RATE');//초과량

						if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")){
							if(sInout_q  > sInv_q + sOriginQ){
								rv=Msg.sMS210;	//출고량은 재고량을 초과할 수 없습니다.
								break;
							}
						}
						//출고량(부피) 재계산
						var sUnitVol = record.get('UNIT_VOL')
						var sOrderVolQ = sInout_q * sUnitVol;
						record.set('INOUT_VOL_Q', sOrderVolQ);

						UniAppManager.app.fnOrderAmtCal(record, 'Q', fieldName, newValue);
						detailStore.fnOrderAmtSum();
						break;

					case "INOUT_VOL_Q" :	//hidden

						break;
					case "ORDER_UNIT_P" :
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						//수주단가(중량) 재계산
						var sUnitWgt = record.get('UNIT_WGT');
						var sInoutForP = record.get('ORDER_UNIT_P');
						var sInoutWgtForP = sUnitWgt == 0 ? 0 : sInoutForP / sUnitWgt;
						record.set('INOUT_FOR_WGT_P', sInoutWgtForP);

						//수주단가(부피) 재계산
						var sUnitVol = record.get('UNIT_VOL');
						var sInoutForP = record.get('ORDER_UNIT_P');
						var sInoutVolForP = sUnitVol == 0 ? 0 : sInoutForP / sUnitVol;
						record.set('INOUT_FOR_VOL_P', sInoutVolForP);
						console.log('sInoutWgtForP:' + sInoutWgtForP + '\n' + 'sInoutVolForP:' + sInoutVolForP );

						UniAppManager.app.fnOrderAmtCal(record, 'P', fieldName, newValue);
						detailStore.fnOrderAmtSum();
						break;

					case "INOUT_FOR_WGT_P" :	//hidden

						break;

					case "INOUT_FOR_VOL_P" :	//hidden

						break;

					case "ORDER_UNIT_O" :
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						var dTaxAmtO = record.get('INOUT_TAX_AMT');
						if(newValue > 0 && dTaxAmtO > newValue){
							rv=Msg.sMS224;	//매출금액은 세액보다 커야 합니다.
							break;
						}

						UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
						rv = false;
						detailStore.fnOrderAmtSum();
						break;

					case "TAX_TYPE" :
//						if(!Ext.isEmpty(newValue) && newValue == "1"){
//							var inoutTax = record.get('ORDER_UNIT_O') / 10
//							record.set('INOUT_TAX_AMT', inoutTax);
//							detailStore.fnOrderAmtSum(newValue);
//						}else if(!Ext.isEmpty(newValue) && newValue == "2"){
//							record.set('INOUT_TAX_AMT', 0);
//							detailStore.fnOrderAmtSum(newValue);
//						}
						//여기 테스트 요망
//						UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
//						detailStore.fnOrderAmtSum();
//						break;
						var dOrderO=record.get('ORDER_UNIT_Q')*record.get('ORDER_UNIT_P');
						record.set('ORDER_UNIT_O', dOrderO);
						UniAppManager.app.fnOrderAmtCal(record, "O",'ORDER_UNIT_O', dOrderO, newValue);
						detailStore.fnOrderAmtSum();
						break;

					case "INOUT_TAX_AMT" :
						var dSaleAmtO = record.get('ORDER_UNIT_O');
						if(newValue > 0 && dSaleAmtO < newValue){
							rv=Msg.sMS224;	//매출금액은 세액보다 커야 합니다.
							break;
						}
						var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
						if(UserInfo.compCountry == "CN"){
							record.set('INOUT_TAX_AMT', UniSales.fnAmtWonCalc(newValue, "3"), numDigitOfPrice)
						}else{
							record.set('INOUT_TAX_AMT', UniSales.fnAmtWonCalc(newValue, "2"), numDigitOfPrice)
						}
						detailStore.fnOrderAmtSum();
						break;

					case "ACCOUNT_YNC" :
						if(newValue == "N"){
							record.set('ORDER_UNIT_P', 0);
							record.set('INOUT_FOR_WGT_P', 0);
							record.set('INOUT_FOR_VOL_P', 0);
							record.set('INOUT_WGT_P', 0);
							record.set('INOUT_VOL_P', 0);
							record.set('ORDER_UNIT_O', 0);
							record.set('INOUT_TAX_AMT', 0);
						}else{
							if(record.get('SRQ100T_PRICE') != 0 && record.get('SOF110T_PRICE') != 0){
								record.set('ORDER_UNIT_P', record.get('SRQ100T_PRICE'));
							}else if(record.get('SOF110T_PRICE') != 0){
								record.set('ORDER_UNIT_P', record.get('SOF110T_PRICE'));
							}
						}
						//수주단가(중량) 재계산
						var sUnitWgt = record.get('UNIT_WGT');
						var sInoutForP = record.get('ORDER_UNIT_P');
						var sInoutWgtForP = sUnitWgt == 0 ? 0 : sInoutForP / sUnitWgt;
						record.set('INOUT_FOR_WGT_P', sInoutWgtForP);

						//수주단가(부피) 재계산
						var sUnitVol = record.get('UNIT_VOL');
						var sInoutForP = record.get('ORDER_UNIT_P');
						var sInoutVolForP = sUnitVol == 0 ? 0 : sInoutForP / sUnitVol;
						record.set('INOUT_FOR_VOL_P', sInoutVolForP);

						UniAppManager.app.fnOrderAmtCal(record, 'P', fieldName, newValue);
						detailStore.fnOrderAmtSum();

						break;

					case "DELIVERY_DATE" :	////날짜형식에 맞게 수정해야함 	____ . __ . __

						break;

					case "DELIVERY_TIME" :	////시간형식에 맞게 수정해야함	__ . __ . __

						break;

					case "DVRY_CUST_CD" :	//hidden

						break;

					case "DVRY_CUST_NAME" :	////배송처 팝업 만들어야함

						break;

					case "DISCOUNT_RATE" :
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						UniAppManager.app.fnOrderAmtCal(record, 'C', fieldName, (100 - newValue));
						detailStore.fnOrderAmtSum();
						break;

					case "LOT_NO" :		////LOT_NO팝업 만들어야함

						break;

					case "TRANS_COST" :

						break;

				}
			}

			return rv;
		}
	}); // validator
}
</script>