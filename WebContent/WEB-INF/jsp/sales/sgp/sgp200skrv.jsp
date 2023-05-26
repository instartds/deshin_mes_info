<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="sgp200skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sgp200skrv" />			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />					<!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="B042" />					<!--금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="S002" />					<!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="H001" />					<!--기준요일-->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	var planYear	= ${planYear};
	var baseDate	= ${baseDate};
	var selectWeek	= ${selectWeek};
	var refConfig	= ${refConfig};			//기준요일 확인 (공통코드 B604의 SUB_CODE)
	var refConfig2	= ${refConfig2};		//고객관리여부 확인 (공통코드 S060의 REF_CODE1)
	var BsaCodeInfo = {
		gsMoneyUnit			: '${gsMoneyUnit}'
	}

	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Sgp200skrvModel1', {
		fields: [
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.custom" default="거래처"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'				,type: 'string'		, allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'		, allowBlank: false},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},
			{name: 'PLAN_TYPE1'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'		,type: 'string'		, comboType:'AU', comboCode:'S002'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currency" default="화폐"/>'			,type: 'string'		, comboType:'AU', comboCode:'B004', displayField: 'value'},
			{name: 'ENT_MONEY_UNIT'		,text: '<t:message code="system.label.sales.amountunit" default="금액단위"/>'		,type: 'string'		, comboType:'AU', comboCode:'B042'},
			{name: 'MONEYUNIT_FACTOR'	,text: '<t:message code="system.label.sales.amountformat" default="금액형식"/>'		,type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.sales.accountclass" default="계정구분"/>'		,type: 'string'},
			{name: 'GUBUN'				,text: '<t:message code="system.label.sales.classfication" default="구분"/>'		,type: 'string'},
			
			{name: 'SUM_PLANQTY'		,text: '<t:message code="system.label.sales.qtytotal" default="수량합계"/>'			,type: 'uniQty'},
			{name: 'SUM_PLANAMT'		,text: '<t:message code="system.label.sales.amounttotal" default="금액합계"/>'		,type: 'uniPrice'},
			
//			{name: 'APPL_DATE0'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
//			{name: 'WK_PLAN_QTY0'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY0'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT0'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
//			{name: 'BASE_DATE0'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

//			{name: 'APPL_DATE1'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
//			{name: 'WK_PLAN_QTY1'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY1'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT1'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
//			{name: 'BASE_DATE1'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

//			{name: 'APPL_DATE2'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
//			{name: 'WK_PLAN_QTY2'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY2'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT2'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
//			{name: 'BASE_DATE2'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

//			{name: 'APPL_DATE3'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
//			{name: 'WK_PLAN_QTY3'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY3'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT3'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
//			{name: 'BASE_DATE3'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

//			{name: 'APPL_DATE4'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
//			{name: 'WK_PLAN_QTY4'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY4'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT4'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
//			{name: 'BASE_DATE4'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

//			{name: 'APPL_DATE5'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
//			{name: 'WK_PLAN_QTY5'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY5'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT5'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
//			{name: 'BASE_DATE5'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

//			{name: 'APPL_DATE6'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
//			{name: 'WK_PLAN_QTY6'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY6'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT6'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
//			{name: 'BASE_DATE6'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

//			{name: 'APPL_DATE7'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
//			{name: 'WK_PLAN_QTY7'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY7'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT7'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
//			{name: 'BASE_DATE7'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

//			{name: 'APPL_DATE8'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
//			{name: 'WK_PLAN_QTY8'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY8'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT8'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
//			{name: 'BASE_DATE8'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

//			{name: 'APPL_DATE9'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
//			{name: 'WK_PLAN_QTY9'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY9'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT9'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
//			{name: 'BASE_DATE9'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

//			{name: 'APPL_DATE10'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
//			{name: 'WK_PLAN_QTY10'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY10'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT10'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
//			{name: 'BASE_DATE10'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

/*			{name: 'APPL_DATE11'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY11'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY11'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT11'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE11'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},
			
			{name: 'APPL_DATE12'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY12'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY12'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT12'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE12'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},
			
			{name: 'APPL_DATE13'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>13'		,type: 'uniDate'},
			{name: 'WK_PLAN_QTY13'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>13'	,type: 'uniQty'},
			{name: 'PLAN_QTY13'			,text: '<t:message code="system.label.sales.qty" default="수량"/>13'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT13'			,text: '<t:message code="system.label.sales.amount" default="금액"/>13'			,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE13'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>13'		,type: 'uniDate'},
			
			{name: 'APPL_DATE14'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>14'		,type: 'uniDate'},
			{name: 'WK_PLAN_QTY14'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>14'	,type: 'uniQty'},
			{name: 'PLAN_QTY14'			,text: '<t:message code="system.label.sales.qty" default="수량"/>14'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT14'			,text: '<t:message code="system.label.sales.amount" default="금액"/>14'			,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE14'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>14'		,type: 'uniDate'},
			
			{name: 'APPL_DATE15'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>15'		,type: 'uniDate'},
			{name: 'WK_PLAN_QTY15'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>15'	,type: 'uniQty'},
			{name: 'PLAN_QTY15'			,text: '<t:message code="system.label.sales.qty" default="수량"/>15'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT15'			,text: '<t:message code="system.label.sales.amount" default="금액"/>15'			,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE15'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>15'		,type: 'uniDate'},*/
			{name: 'EXCEL_YN'			,text: 'EXCEL_YN'																,type: 'string'}
		]
	});
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('sgp200skrvMasterStore1',{
		model	: 'Sgp200skrvModel1',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sgp200skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
//			console.log(tab.getActiveTab().getId());
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				if(!Ext.isEmpty(records)) {
//					var entMoneyUnit = records[0].get('ENT_MONEY_UNIT');
//					panelSearch.setValue('ENT_MONEY_UNIT', entMoneyUnit);
//					panelResult.setValue('ENT_MONEY_UNIT', entMoneyUnit);
//				}
			}
		}/*,
		groupField: 'ITEM_CODE'*/
	});
	
	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
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
			items		: [{ 
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.planyear" default="계획년도"/>',
				xtype		: 'uniYearField',
				name		: 'PLAN_YEAR',
				value		: new Date().getFullYear(),
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PLAN_YEAR', newValue);
					}
				}
			},{
				xtype		: 'container',
				layout		: {type : 'uniTable'},
				items		: [{ 
					fieldLabel	: '<t:message code="system.label.sales.planperiod" default="계획기간"/>',
					name		: 'PLAN_DATE_FR',
					xtype		: 'uniTextfield',
					holdable	: 'hold',
					fieldStyle	: 'text-align: center;',
					allowBlank	: false,
					width		: 196,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(isNaN(newValue)){
								Unilite.messageBox('<t:message code="system.message.sales.message019" default="자만 입력가능합니다."/>');
								panelSearch.setValue('PLAN_DATE_FR', '');
								panelResult.setValue('PLAN_DATE_FR', '');
								return false;
							}
							if(newValue.length == 7) {
								var frDate		= parseInt(newValue);
								var toDate		= parseInt('10');
								var planYear	= newValue.substring(0, 4);
								
								panelSearch.setValue('PLAN_DATE_TO'	, frDate+toDate);
								panelSearch.setValue('PLAN_YEAR'	, planYear);
								
								panelResult.setValue('PLAN_DATE_FR'	, newValue);
								panelResult.setValue('PLAN_DATE_TO'	, frDate+toDate);
								panelResult.setValue('PLAN_YEAR'	, planYear);
								
								//컬럼명 set
								fnSetColumnName(newValue);
							}
						}
					}
				},{ 
					fieldLabel	: '~',
					name		: 'PLAN_DATE_TO',
					xtype		: 'uniTextfield',
					fieldStyle	: 'text-align: center;',
					holdable	: 'hold',
					readOnly	: true,
					width		: 127,
					labelWidth	: 18,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				}]
			},{
				fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name		: 'OUT_IN_TYPE',	
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'S002',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('OUT_IN_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>',
				name		: 'MONEY_UNIT',	
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'B004',
				displayField: 'value',
				value		: UserInfo.currency,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
					}
				}  
			},{
				fieldLabel	: '<t:message code="system.label.sales.planamountunit" default="계획금액단위"/>',
				name		: 'ENT_MONEY_UNIT',	
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'B042',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ENT_MONEY_UNIT', newValue);
					}
				} 
			},{
				fieldLabel	: '<t:message code="system.label.sales.accountclass" default="계정구분"/>',
				name		: 'ITEM_ACCOUNT',	
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue)
					}
				}
			},
			Unilite.popup('DIV_PUMOK', {
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE_FR',
				textFieldName	: 'ITEM_NAME_FR',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_CODE_FR', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME_FR', '');
							panelResult.setValue('ITEM_NAME_FR', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_NAME_FR', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE_FR', '');
							panelResult.setValue('ITEM_CODE_FR', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('DIV_PUMOK', {
				valueFieldName	: 'ITEM_CODE_TO', 
				textFieldName	: 'ITEM_NAME_TO', 
				fieldLabel		: '~',
//				labelWidth		: 18,
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_CODE_TO', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME_TO', '');
							panelResult.setValue('ITEM_NAME_TO', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_NAME_TO', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE_TO', '');
							panelResult.setValue('ITEM_CODE_TO', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			})]	
		}]
	}); 
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{ 
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.planyear" default="계획년도"/>',
			xtype		: 'uniYearField',
			name		: 'PLAN_YEAR',
			value		: new Date().getFullYear(),
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PLAN_YEAR', newValue);
				}
			}
		},{
			xtype		: 'container',
			layout		: {type : 'uniTable'},
			colspan		: 2,
			items		: [{ 
				fieldLabel	: '<t:message code="system.label.sales.planperiod" default="계획기간"/>',
				name		: 'PLAN_DATE_FR',
				xtype		: 'uniTextfield',
				holdable	: 'hold',
				fieldStyle	: 'text-align: center;',
				allowBlank	: false,
				width		: 196,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(isNaN(newValue)){
							Unilite.messageBox('<t:message code="system.message.sales.message019" default="자만 입력가능합니다."/>');
							panelResult.setValue('PLAN_DATE_FR', '');
							return false;
						}
						if(newValue.length == 7) {
							var frDate		= parseInt(newValue);
							var toDate		= parseInt('10');
							var planYear	= newValue.substring(0, 4);
							
							panelResult.setValue('PLAN_DATE_TO'	, frDate+toDate);
							panelResult.setValue('PLAN_YEAR'	, planYear);
							
							panelSearch.setValue('PLAN_DATE_FR'	, newValue);
							panelSearch.setValue('PLAN_DATE_TO'	, frDate+toDate);
							panelSearch.setValue('PLAN_YEAR'	, planYear);
							
							//컬럼명 set
							fnSetColumnName(newValue);
						}
					}
				}
			},{ 
				fieldLabel	: '~',
				name		: 'PLAN_DATE_TO',
				xtype		: 'uniTextfield',
				fieldStyle	: 'text-align: center;',
				holdable	: 'hold',
				readOnly	: true,
				width		: 127,
				labelWidth	: 18,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name		: 'OUT_IN_TYPE',	
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'S002',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('OUT_IN_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>',
			name		: 'MONEY_UNIT',	
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'B004',
			displayField: 'value',
			value		: UserInfo.currency,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('MONEY_UNIT', newValue);
				}
			}  
		},{
			fieldLabel	: '<t:message code="system.label.sales.planamountunit" default="계획금액단위"/>',
			name		: 'ENT_MONEY_UNIT',	
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'B042',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ENT_MONEY_UNIT', newValue);
				}
			} 
		},{
			fieldLabel	: '<t:message code="system.label.sales.accountclass" default="계정구분"/>',
			name		: 'ITEM_ACCOUNT',	
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue)
				}
			}
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE_FR',
			textFieldName	: 'ITEM_NAME_FR',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_CODE_FR', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_NAME_FR', '');
						panelResult.setValue('ITEM_NAME_FR', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_NAME_FR', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_CODE_FR', '');
						panelResult.setValue('ITEM_CODE_FR', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('DIV_PUMOK', {
			valueFieldName	: 'ITEM_CODE_TO', 
			textFieldName	: 'ITEM_NAME_TO', 
			fieldLabel		: '~',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_CODE_TO', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_NAME_TO', '');
						panelResult.setValue('ITEM_NAME_TO', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_NAME_TO', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_CODE_TO', '');
						panelResult.setValue('ITEM_CODE_TO', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		})]	
	});
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('sgp200skrvGrid1', {
		store	: directMasterStore1,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer: true,
			useGroupSummary: false,	
			useMultipleSorting: true
		},
		sortableColumns: false,
		features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id: 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false} ],
		columns	: [
			{ dataIndex: 'CUSTOM_CODE'			, width: 100 },
			{ dataIndex: 'CUSTOM_NAME'			, width: 160 },
			{ dataIndex: 'ITEM_CODE'			, width: 86  },
			{ dataIndex: 'ITEM_NAME'			, width: 160 },
			{ dataIndex: 'SPEC'					, width: 100 },
			{ dataIndex: 'PLAN_TYPE1'			, width: 100		, hidden: false },
			{ dataIndex: 'MONEY_UNIT'			, width: 100		, hidden: false },
			{ dataIndex: 'ENT_MONEY_UNIT'		, width: 80			, hidden: false },
			{ dataIndex: 'GUBUN'				, width: 80			, hidden: false },
			{ dataIndex: 'MONEYUNIT_FACTOR'		, width: 133		, hidden: true },
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 100		, hidden: true },
			{
				text: '<t:message code="system.label.sales.totalamount" default="합계"/>',
				columns:[
					{ dataIndex: 'SUM_PLANQTY'		, width: 100 },
					{ dataIndex: 'SUM_PLANAMT'		, width: 100 }
				]
			},   
			{
				id		: 'comlumnName0',
				columns	:[
					{ dataIndex: 'PLAN_QTY0'		, width: 100 },
					{ dataIndex: 'PLAN_AMT0'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName1',
				columns	:[
					{ dataIndex: 'PLAN_QTY1'		, width: 100 },
					{ dataIndex: 'PLAN_AMT1'		, width: 100 }
				]
			},
			{
				id		: 'comlumnName2',
				columns	:[
					{ dataIndex: 'PLAN_QTY2'		, width: 100 },
					{ dataIndex: 'PLAN_AMT2'		, width: 100 }
				]
			},
			{
				id		: 'comlumnName3',
				columns	:[
					{ dataIndex: 'PLAN_QTY3'		, width: 100 },
					{ dataIndex: 'PLAN_AMT3'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName4',
				columns	:[
					{ dataIndex: 'PLAN_QTY4'		, width: 100 },
					{ dataIndex: 'PLAN_AMT4'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName5',
				columns	:[
					{ dataIndex: 'PLAN_QTY5'		, width: 100 },
					{ dataIndex: 'PLAN_AMT5'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName6',
				columns	:[
					{ dataIndex: 'PLAN_QTY6'		, width: 100 },
					{ dataIndex: 'PLAN_AMT6'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName7',
				columns	:[
					{ dataIndex: 'PLAN_QTY7'		, width: 100 },
					{ dataIndex: 'PLAN_AMT7'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName8',
				columns	:[
					{ dataIndex: 'PLAN_QTY8'		, width: 100 },
					{ dataIndex: 'PLAN_AMT8'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName9',
				columns	:[
					{ dataIndex: 'PLAN_QTY9'		, width: 100 },
					{ dataIndex: 'PLAN_AMT9'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName10',
				columns	:[
					{ dataIndex: 'PLAN_QTY10'		, width: 100 },
					{ dataIndex: 'PLAN_AMT10'		, width: 100 }
				]
			}
		],
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';

				if(record.get('ITEM_NAME') == ' '){
					cls = 'x-change-cell_normal';
				}
				return cls;
	        }
	    }
	});
	
	
	
	Unilite.Main( {
		id			: 'sgp200skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	:[
				masterGrid, panelResult
			]
		},
		 panelSearch
		],
		fnInitBinding: function() {
			//컬럼명 set
			if(Ext.isEmpty(baseDate)) {
				Unilite.messageBox('<t:message code="system.message.sales.datacheck018" default="달력정보가 존재하지 않습니다. 달력을 먼저 생성하세요."/>');
				Ext.getCmp('mainItem').setDisabled(true);
				return false;
			}
			
			//고객관리여부에 따른 컬럼 숨김 처리
			if(Ext.isEmpty(refConfig2) || refConfig2[0].REF_CODE1 == 'N') {
				masterGrid.getColumn('CUSTOM_CODE').setHidden(true);
				masterGrid.getColumn('CUSTOM_NAME').setHidden(true);
			} else {
				masterGrid.getColumn('CUSTOM_CODE').setHidden(false);
				masterGrid.getColumn('CUSTOM_NAME').setHidden(false);
			}
			
			fnSetColumnName(baseDate[0].WEEKFR);

			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('PLAN_YEAR'	, new Date().getFullYear());
			panelSearch.setValue('PLAN_DATE_FR'	, baseDate[0].WEEKFR);
			panelSearch.setValue('PLAN_DATE_TO'	, baseDate[0].WEEKTO10);
			panelSearch.setValue('MONEY_UNIT'	, BsaCodeInfo.gsMoneyUnit);
			panelSearch.getField('PLAN_YEAR').setReadOnly(true);
			panelSearch.getField('PLAN_DATE_TO').setReadOnly(true);

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('PLAN_YEAR'	, new Date().getFullYear());
			panelResult.setValue('PLAN_DATE_FR'	, baseDate[0].WEEKFR);
			panelResult.setValue('PLAN_DATE_TO'	, baseDate[0].WEEKTO10);
			panelResult.setValue('MONEY_UNIT'	, BsaCodeInfo.gsMoneyUnit);
			panelResult.getField('PLAN_YEAR').setReadOnly(true);
			panelResult.getField('PLAN_DATE_TO').setReadOnly(true);

			var param= Ext.getCmp('resultForm').getValues(); 
			sgp200ukrvService.defaultSet(param, function(provider, response) {
				if (!Ext.isEmpty(provider)) {
					panelResult.setValue('OUT_IN_TYPE'		, provider[0].PLAN_TYPE1);
					panelResult.setValue('ENT_MONEY_UNIT'	, provider[0].ENT_MONEY_UNIT);
					
				} else {
					panelResult.setValue('OUT_IN_TYPE'		, '10');
					panelResult.setValue('ENT_MONEY_UNIT'	, '1');
				}
			})
			UniAppManager.setToolbarButtons('reset',false);
			
			//초기화 시 포커스 / 필드 활성화 set
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			
			if(pgmInfo.authoUser == 'Y') {
				panelSearch.getField('DIV_CODE').setReadOnly(false);
				panelResult.getField('DIV_CODE').setReadOnly(false);
				activeSForm.onLoadSelectText('DIV_CODE');
				
			} else {
				panelSearch.getField('DIV_CODE').setReadOnly(true);
				panelResult.getField('DIV_CODE').setReadOnly(true);
				activeSForm.onLoadSelectText('PLAN_DATE_FR');
			}
		},
		onQueryButtonDown: function()	{
			masterGrid.getStore().loadStoreRecords();
//			var viewLocked = tab.getActiveTab().lockedGrid.getView();
//			var viewNormal = tab.getActiveTab().normalGrid.getView();
//			console.log("viewLocked: ",viewLocked);
//			console.log("viewNormal: ",viewNormal);
//			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		}
	});
	
	
	
	
	//그리드 컬럼명 set
	function fnSetColumnName(provider) {
		if(Ext.isEmpty(provider)) {
			return false;
		}
		for (var i=0;  i <= 10; i ++) {
			var varProvider = (parseInt(provider) + i).toString();
			eval("columnName"+i+"= varProvider.substring(0, 4) + '-' + varProvider.substring(4, 7)");
		}
		
		Ext.getCmp('comlumnName0').setText(columnName0);
		Ext.getCmp('comlumnName1').setText(columnName1);
		Ext.getCmp('comlumnName2').setText(columnName2);
		Ext.getCmp('comlumnName3').setText(columnName3);
		Ext.getCmp('comlumnName4').setText(columnName4);
		Ext.getCmp('comlumnName5').setText(columnName5);
		Ext.getCmp('comlumnName6').setText(columnName6);
		Ext.getCmp('comlumnName7').setText(columnName7);
		Ext.getCmp('comlumnName8').setText(columnName8);
		Ext.getCmp('comlumnName9').setText(columnName9);
		Ext.getCmp('comlumnName10').setText(columnName10);
	}

};
</script>
