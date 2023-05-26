<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="ssa452skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa452skrv"  />			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" />					<!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />					<!-- 지역 -->	
	<t:ExtComboStore comboType="AU" comboCode="B055" />					<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" />					<!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S024" />					<!--국내:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S118" />					<!--해외:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S002" />					<!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B020" />					<!--품목유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" />					<!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/>		<!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B059" />					<!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S024" />					<!--부가세유형-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<script type="text/javascript" >


var BsaCodeInfo = {
	gsMoneyUnit: '${gsMoneyUnit}'
};
var gsInitFlag;
var gsMoneyUnitRef4	= Ext.isEmpty('${gsMoneyUnitRef4}') ? BsaCodeInfo.gsMoneyUnit	: '${gsMoneyUnitRef4}';;
var gsExchangeRate	= '${gsExchangeRate}'; 
if(Ext.isEmpty(gsExchangeRate) || gsExchangeRate == '0.0000') {
	gsExchangeRate = '1.0000';
}

function appMain() {

	/** Model 정의 
	 * @type 
	 */				 
	Unilite.defineModel('Ssa450skrvModel1', {
		fields: [{name: 'SALE_CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'						,type: 'string'},
				 {name: 'SALE_CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'					,type: 'string'},
				 {name: 'BILL_TYPE'			,text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'					,type: 'string',comboType: "AU", comboCode: "S024"},
				 {name: 'SALE_DATE'			,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'					,type: 'uniDate'},
				 {name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'					,type: 'string',comboType: "AU", comboCode: "S007"},
				 {name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'							,type: 'string'},
				 {name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'						,type: 'string'},
				 {name: 'CREATE_LOC'		,text: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'				,type: 'string',comboType: "AU", comboCode: "B031"},
				 {name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'							,type: 'string'},
				 {name: 'LOT_NO'			,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'						,type: 'string'},
				 {name: 'SALE_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'							,type: 'string'},
				 {name: 'PRICE_TYPE'		,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'					,type: 'string'},
				 {name: 'TRANS_RATE'		,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'					,type: 'string'},
				 {name: 'SALE_Q'			,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'						,type: 'uniQty'},
				 {name: 'SALE_WGT_Q'		,text: '<t:message code="system.label.sales.salesqtywgt" default="매출량(중량)"/>'				,type: 'uniQty'},
				 {name: 'SALE_VOL_Q'		,text: '<t:message code="system.label.sales.salesqtyvol" default="매출량(부피)"/>'				,type: 'uniQty'},
				 {name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.salesordercustom" default="수주거래처"/>'			,type: 'string'},
				 {name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.salesordercustomname" default="수주거래처명"/>'		,type: 'string'},
				 {name: 'SALE_P'			,text: '<t:message code="system.label.sales.price" default="단가"/>'							,type: 'uniUnitPrice'},
				 {name: 'SALE_FOR_WGT_P'	,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'				,type: 'uniUnitPrice'},
				 {name: 'SALE_FOR_VOL_P'	,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'				,type: 'uniUnitPrice'},
				 {name: 'MONEY_UNIT'		,text: '<t:message code="system.label.sales.currency" default="화폐"/>'						,type: 'string'},
				 {name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'					,type: 'uniER'},
				 {name: 'SALE_LOC_AMT_F'	,text: '<t:message code="system.label.sales.salesamountforeign" default="매출액(외화)"/>'		,type: 'uniFC'},
				 //20181116 SALE_LOC_AMT_I type 변경 (uniPrice -> uniFC)
				 {name: 'SALE_LOC_AMT_I'	,text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'					,type: 'uniFC'},
				 {name: 'TAX_TYPE'			,text: '<t:message code="system.label.sales.taxationyn" default="과세여부"/>'					,type: 'string', comboType: "AU", comboCode: "B059"},
				 //20181116 TAX_AMT_O, SUM_SALE_AMT type 변경 (uniPrice -> uniFC)
				 {name: 'TAX_AMT_O'			,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'						,type: 'uniFC'},
				 {name: 'SUM_SALE_AMT'		,text: '<t:message code="system.label.sales.salestotal" default="매출계"/>'					,type: 'uniFC'},

//				 {name: 'CONSIGNMENT_FEE'	,text: '수수료(위탁)'	,type: 'uniPrice'},
				 {name: 'ORDER_TYPE'		,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'					,type: 'string',comboType: "AU", comboCode: "S002"},
				 {name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'						,type: 'string',comboType: "BOR120"},
				 {name: 'SALE_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'					,type: 'string',comboType: "AU", comboCode: "S010"},
				 {name: 'MANAGE_CUSTOM'		,text: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>'				,type: 'string'},
				 {name: 'MANAGE_CUSTOM_NM'	,text: '<t:message code="system.label.sales.summarycustomname" default="집계거래처명"/>'		,type: 'string'},
				 {name: 'AREA_TYPE'			,text: '<t:message code="system.label.sales.area" default="지역"/>'							,type: 'string',comboType: "AU", comboCode: "B056"},
				 {name: 'AGENT_TYPE'		,text: '<t:message code="system.label.sales.customclass" default="거래처분류"/>'				,type: 'string',comboType: "AU", comboCode: "B055"},
				 {name: 'PROJECT_NO'		,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				,type: 'string'},
				 {name: 'PUB_NUM'			,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'					,type: 'string'},
				 {name: 'EX_NUM'			,text: '<t:message code="system.label.sales.slipno" default="전표번호"/>'						,type: 'string'},
				 {name: 'BILL_NUM'			,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'						,type: 'string'},
				 {name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'						,type: 'string'},
				 {name: 'DISCOUNT_RATE'		,text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'				,type: 'number'},					
				 {name: 'PRICE_YN'			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'					,type: 'string', comboType: "AU", comboCode: "S003"},
				 {name: 'WGT_UNIT'			,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'					,type: 'string'},
				 {name: 'UNIT_WGT'			,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'					,type: 'string'},
				 {name: 'VOL_UNIT'			,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'					,type: 'string'},
				 {name: 'UNIT_VOL'			,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'					,type: 'string'},
				 {name: 'COMP_CODE'			,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'					,type: 'string'},
				 {name: 'BILL_SEQ'			,text: '<t:message code="system.label.sales.billseq" default="계산서순번"/>'					,type: 'string'},
				 {name: 'SALE_AMT_WON'		,text: '<t:message code="system.label.sales.cosalesamount" default="매출액(자사)"/>'			,type: 'uniPrice'},
				 {name: 'TAX_AMT_WON'		,text: '<t:message code="system.label.sales.cotaxamount" default="세액(자사)"/>'				,type: 'uniPrice'},
				 {name: 'SUM_SALE_AMT_WON'	,text: '<t:message code="system.label.sales.cosalestotal" default="매출계(자사)"/>'			,type: 'uniPrice'},
				 //20181116 추가
				 {name: 'EXCHG_MONEY_UNIT'	,text:'<t:message code="system.label.sales.currencyexchanged" default="화폐(환산)"/>'			,type:'string'},
				 {name: 'EXCHG_SALE_AMT'	,text:'<t:message code="system.label.sales.salesamountexchanged" default="매출액(환산)"/>'		,type:'uniFC'},
				 {name: 'EXCHG_TAX_AMT'		,text:'<t:message code="system.label.sales.taxamountexchanged" default="세액(환산)"/>'			,type:'uniFC'},
				 {name: 'EXCHG_SUM_SALE_AMT',text:'<t:message code="system.label.sales.salestotalexchanged" default="매출계(환산)"/>'		,type:'uniFC'},
				 {name: 'ORI_EXCHG_RATE'	,text:'ORI_EXCHG_RATE'	,type:'uniER'}
			]
	});



	/** Store 정의(Service 정의)
	 * @type 
	 */				 
	var directMasterStore1 = Unilite.createStore('ssa452skrvMasterStore1',{
		model: 'Ssa450skrvModel1',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {		  
				read: 'ssa452skrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});		 
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
					masterGrid.setShowSummaryRow(true);
				}
			}
		},
		groupField: 'SALE_CUSTOM_NAME'
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
			title	: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'vbox', align: 'stretch'},
			items	: [{	
				xtype	: 'container',
				layout	: {type: 'uniTable', columns:1},
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					value		: UserInfo.divCode,
					allowBlank	: false,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {	
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelResult.getField('SALE_PRSN');  
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					validateBlank	: false,
					valueFieldName	: 'SALE_CUSTOM_CODE',
					textFieldName	: 'SALE_CUSTOM_NAME',
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('SALE_CUSTOM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('SALE_CUSTOM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER':  ['1', '3']});
							popup.setExtParam({'CUSTOM_TYPE':  ['1', '3']});
						}
					}
				}), 
				Unilite.popup('PROJECT',{
					fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
					valueFieldName	: 'PROJECT_NO',
					textFieldName	: 'PROJECT_NAME',
						DBvalueFieldName: 'PJT_CODE',
					DBtextFieldName	: 'PJT_NAME',
					validateBlank	: false,
					textFieldOnly	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PROJECT_NO', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('PROJECT_NAME', newValue);
						},
						applyextparam: function(popup) {
						},
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				}),{
					fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'  ,
					name		: 'SALE_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S010',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SALE_PRSN', newValue);
						}
					},
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
						if(eOpts){
							combo.filterByRefCode('refCode1', newValue, eOpts.parent);
						}else{
							combo.divFilterByRefCode('refCode1', newValue, divCode);
						}
					}
				},
				Unilite.popup('DIV_PUMOK', {
					fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}), {
					fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'SALE_FR_DATE',
					endFieldName	: 'SALE_TO_DATE',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					allowBlank		: false,
					width			: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('SALE_FR_DATE',newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('SALE_TO_DATE',newValue);
						}
					}
				}]  
			}]							
		},{
			title		: '<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
				name		: 'ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020'
			}, {
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.salesslipyn" default="매출기표유무"/>',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'SALE_YN',
					inputValue	: 'A',
					checked		: true,
					width		: 50
				}, {
					boxLabel	: '<t:message code="system.label.sales.slipposting" default="기표"/>',
					name		: 'SALE_YN',
					inputValue	: 'Y', 
					width		: 50
				}, {
					boxLabel	: '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
					name		: 'SALE_YN',
					inputValue	: 'N',
					width		: 70
				}]
			},{
				fieldLabel	: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
				name		: 'TXT_CREATE_LOC',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B031'
			}, {
				fieldLabel	: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
				name		: 'BILL_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S024'
			}, {			 
				fieldLabel	: '<t:message code="system.label.sales.customclass" default="거래처분류"/>' ,
				name		: 'AGENT_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B055'  
			},
			Unilite.popup('ITEM_GROUP',{ 
				fieldLabel		: '<t:message code="system.label.sales.repmodel" default="대표모델"/>', 
				textFieldName	: 'ITEM_GROUP_CODE', 
				valueFieldName	: 'ITEM_GROUP_NAME',
				 validateBlank	: false,
				popupWidth		: 710
			}), {
				fieldLabel	: '<t:message code="system.label.sales.issuetype" default="출고유형"/>',
				name		: 'INOUT_TYPE_DETAIL',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S007'
			}, {
				fieldLabel	: '<t:message code="system.label.sales.area" default="지역"/>',
				name		: 'AREA_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B056'  
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>',
				validateBlank	: false,
				valueFieldName	: 'MANAGE_CUSTOM',
				textFieldName	: 'MANAGE_CUSTOM_NAME',
				id				: 'ssa452skrvvCustPopup',
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'CUSTOM_TYPE': ''});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'  ,
				name		: 'ORDER_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S002'
			}, { 
				fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name		: 'ITEM_LEVEL1', 
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'ITEM_LEVEL2'
			}, {
				fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'ITEM_LEVEL3'
			}, {
				fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name		: 'ITEM_LEVEL3', 
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames	: ['ITEM_LEVEL1','ITEM_LEVEL2'],
				levelType	: 'ITEM'
			}, { 
				xtype		: 'container',
				layout		: {type: 'hbox', align: 'stretch'},
				defaultType	: 'uniTextfield',
				width		: 325,
				items		: [{
					fieldLabel	: '<t:message code="system.label.sales.salesno" default="매출번호"/>',
					suffixTpl	: '&nbsp;~&nbsp;',
					name		: 'BILL_FR_NO',
					width		: 218
				}, {
					name		: 'BILL_TO_NO',
					hideLabel	: true,
					width		: 107
				}] 
			}, { 
				xtype		: 'container',
				layout		: {type: 'hbox', align: 'stretch'},
				defaultType	: 'uniTextfield',
				width		: 325,
				items		: [{
					fieldLabel	: '<t:message code="system.label.sales.billno" default="계산서번호"/>',
					suffixTpl	: '&nbsp;~&nbsp;',
					name		: 'PUB_FR_NUM',
					width		: 218
				}, {
					name		: 'PUB_TO_NUM',
					hideLabel	: true,
					width		: 107
				}] 
			}, {
				fieldLabel	: '<t:message code="system.label.sales.salesqty" default="매출량"/>',
				name		: 'SALE_FR_Q',
				suffixTpl	: '&nbsp;<t:message code="system.label.sales.over" default="이상"/>'
			}, {
				fieldLabel	: ' ',
				name		: 'SALE_TO_Q',
				suffixTpl	: '&nbsp;<t:message code="system.label.sales.below" default="이하"/>'
			}, {
				fieldLabel		: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
				 xtype			: 'uniDateRangefield',
				 startFieldName	: 'INOUT_FR_DATE',
				 endFieldName	: 'INOUT_TO_DATE',
				 width			: 315
			}]
		},{
			title		: '<t:message code="system.label.sales.etc" default="기타"/>',
			id			: 'search_panel5',
			itemId		: 'search_panel5',
			defaultType	: 'uniNumberfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.exchangecurrency" default="환산 화폐"/>',
				name		: 'EXCHG_MONEY_UNIT', 	
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'B004',
				displayField: 'value',
				fieldStyle	: 'text-align: center;',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!gsInitFlag) {
							UniAppManager.app.fnExchngRateO();
						}
						gsInitFlag = false;
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
				name		: 'EXCHANGE_RATE',
				type		: 'uniER'/*,
				readOnly	: true*/,
				listeners: {
					blur : function (e, event, eOpts) {
						if(panelSearch.getValue('EXCHANGE_RATE') != 0) {
							panelSearch.down('#conversionApplied').enable();
						} else {
							panelSearch.down('#conversionApplied').disable();
						}
					}
				}
			},{
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.conversionapplied" default="환산적용"/>',
				id		: 'conversionApplied',
				itemId	: 'conversionApplied',
				margin	: '0 0 0 120',
				handler	: function() {
//					Ext.getCmp('sof102skrvApp').mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
					var records			= directMasterStore1.data.items;
					var exchgMoneyUnit	= panelSearch.getValue('EXCHG_MONEY_UNIT');
					var exchgRate		= panelSearch.getValue('EXCHANGE_RATE');
					Ext.each(records, function(record,i) {
						var oriExchgRate= record.get('ORI_EXCHG_RATE');
						var saleLocAmtF	= record.get('SALE_LOC_AMT_F');
						var taxAmtO		= record.get('TAX_AMT_O');
//						var sumSaleAmt	= record.get('SUM_SALE_AMT');
						
						record.set('EXCHG_MONEY_UNIT'	, exchgMoneyUnit);
						record.set('EXCHG_SALE_AMT'		, Unilite.multiply(saleLocAmtF				, oriExchgRate) / exchgRate);
						record.set('EXCHG_TAX_AMT'		, Unilite.multiply(taxAmtO					, oriExchgRate) / exchgRate);
						record.set('EXCHG_SUM_SALE_AMT'	, Unilite.multiply((saleLocAmtF + taxAmtO)	, oriExchgRate) / exchgRate);
						
//						if(records.length == i+1) {
//							Ext.getCmp('sof102skrvApp').unmask();
//						}
					});
					directMasterStore1.commitChanges();
				}
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
				}
			}
			return r;
		}
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
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {	
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('SALE_PRSN');  
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'SALE_CUSTOM_CODE',
			textFieldName	: 'SALE_CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('SALE_CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('SALE_CUSTOM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1', '3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1', '3']});
				}
			}
		}),
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			valueFieldName	: 'PROJECT_NO',
			textFieldName	: 'PROJECT_NAME',
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName	: 'PJT_NAME',
			validateBlank	: false,
			textFieldOnly	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PROJECT_NO', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('PROJECT_NAME', newValue);
				},
				applyextparam: function(popup) {
				},
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}),{
			fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype			: 'uniDateRangefield',
			allowBlank		: false,
			startFieldName	: 'SALE_FR_DATE',
			endFieldName	: 'SALE_TO_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('SALE_FR_DATE',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('SALE_TO_DATE',newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'  ,
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SALE_PRSN', newValue);
				}
			},
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
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
	var masterGrid = Unilite.createGrid('ssa452skrvGrid1', {
		region			: 'center',
		syncRowHeight	: false,
		store			: directMasterStore1,
		tbar			: [{
			xtype			: 'uniNumberfield',
			fieldLabel		: '<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
			id				: 'selectionSummary',
			format			: '0,000.0000',
			decimalPrecision: 4,
			value			: 0,
			labelWidth		: 110
		}],
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns: [
			{ dataIndex: 'SALE_DATE'				, width: 80, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},																							//매출일
			{ dataIndex: 'INOUT_TYPE_DETAIL'		, width: 80, align: 'center'},						//출고유형
			{ dataIndex: 'ITEM_CODE'				, width: 123},										//품목코드
			{ dataIndex: 'ITEM_NAME'				, width: 150 },										//품명
			{ dataIndex: 'SPEC'						, width: 123 },										//규격
//			{ dataIndex: 'LOT_NO'					, width: 100 },										//LOT_NO
			{ dataIndex: 'MONEY_UNIT'				, width: 60, align: 'center'},						//화폐
			{ dataIndex: 'EXCHG_RATE_O'				, width: 60, align: 'right'},						//환율
			{ dataIndex: 'SALE_UNIT'				, width: 53, align: 'center'},						//단위
			{ dataIndex: 'TRANS_RATE'				, width: 53, align: 'right'},						//입수
			{ dataIndex: 'SALE_Q'					, width: 80, summaryType: 'sum'},					//매출량
//			{ dataIndex: 'PRICE_TYPE'				, width: 53, hidden: true},							//단가구분
			{ dataIndex: 'SALE_P'					, width: 113 },										//단가
			{ dataIndex: 'SALE_LOC_AMT_F'			, width: 113, summaryType: 'sum'},					//매출액(외화)
			{ dataIndex: 'TAX_AMT_O'				, width: 100, summaryType: 'sum'},					//세액
			{ dataIndex: 'SUM_SALE_AMT'				, width: 113, summaryType: 'sum'},					//매출계
			{ dataIndex: 'SALE_AMT_WON'				, width: 113, summaryType: 'sum'},					//매출액(자사)
			{ dataIndex: 'TAX_AMT_WON'				, width: 113, summaryType: 'sum'},					//세액(자사)
			{ dataIndex: 'SUM_SALE_AMT_WON'			, width: 113, summaryType: 'sum'},					//매출계(자사)
			{ dataIndex: 'DISCOUNT_RATE'			, width: 80 },										//할인율(%)
//			{ dataIndex: 'SALE_LOC_AMT_I'			, width: 113, summaryType: 'sum' , hidden: true},	//매출액
			{ dataIndex: 'SALE_CUSTOM_CODE'			, width: 80},			 
			{ dataIndex: 'SALE_CUSTOM_NAME'			, width: 120, locked: false },						//거래처명
			{ dataIndex: 'BILL_TYPE'				, width: 80, align: 'center'},						//부가세유형
			{ dataIndex: 'TAX_TYPE'					, width: 80, align: 'center'},						//과세여부
			{ dataIndex: 'ORDER_TYPE'				, width: 100 },										//판매유형
			{ dataIndex: 'CUSTOM_CODE'				, width: 80},										//수주거래처
			{ dataIndex: 'CUSTOM_NAME'				, width: 113 },										//수주거래처명
			{ dataIndex: 'SALE_PRSN'				, width: 100},										//영업담당
//			{ dataIndex: 'SALE_WGT_Q'				, width: 100, hidden: true},						//매출량(중량)
//			{ dataIndex: 'SALE_VOL_Q'				, width: 80 , hidden: true},						//매출량(부피)
//			{ dataIndex: 'SALE_FOR_WGT_P'			, width: 113, hidden: true},						//단가(중량)
//			{ dataIndex: 'SALE_FOR_VOL_P'			, width: 113, hidden: true},						//단가(부피)
			{ dataIndex: 'DIV_CODE'					, width: 100 },										//사업장
			{ dataIndex: 'PROJECT_NO'				, width: 113},										//프로젝트번호
			{ dataIndex: 'PUB_NUM'					, width: 80},										//계산서번호
			{ dataIndex: 'EX_NUM'					, width: 93 },										//전표번호
			{ dataIndex: 'BILL_NUM'					, width: 115 },										//매출번호
			{ dataIndex: 'ORDER_NUM'				, width: 115 },										//수주번호
			{ dataIndex: 'PRICE_YN'					, width: 106 },										//단가구분
//			{ dataIndex: 'WGT_UNIT'					, width: 106, hidden: true },						//중량단위
//			{ dataIndex: 'UNIT_WGT'					, width: 106, hidden: true },						//단위중량
//			{ dataIndex: 'VOL_UNIT'					, width: 106, hidden: true },						//부피단위
//			{ dataIndex: 'UNIT_VOL'					, width: 106, hidden: true },						//단위부피
//			{ dataIndex: 'COMP_CODE'				, width: 106, hidden: true },						//법인코드
//			{ dataIndex: 'BILL_SEQ'					, width: 106, hidden: true },						//계산서 순번
//			{ dataIndex: 'MANAGE_CUSTOM'			, width: 80 , hidden: true },						//집계거래처	
//			{ dataIndex: 'MANAGE_CUSTOM_NM'			, width: 113, hidden: true },						//집계거래처명
//			{ dataIndex: 'AREA_TYPE'				, width: 66 , hidden: true },						//지역
//			{ dataIndex: 'AGENT_TYPE'				, width: 113, hidden: true },						//거래처분류
//			{ dataIndex: 'CREATE_LOC'				, width: 80 , hidden: true }						//생성경로
			
			//20181116 추가
			{dataIndex: 'EXCHG_MONEY_UNIT'	, width: 80 , hidden: true},
			{dataIndex: 'ORI_EXCHG_RATE'	, width: 120, hidden: true},
			{dataIndex: 'EXCHG_SALE_AMT'	, width: 120, summaryType: 'sum', hidden: true},
			{dataIndex: 'EXCHG_TAX_AMT'		, width: 120, summaryType: 'sum', hidden: true},
			{dataIndex: 'EXCHG_SUM_SALE_AMT', width: 120, summaryType: 'sum', hidden: true}
			//여기까지
		],
		listeners:{
			selectionchange:function( grid, selection, eOpts ) {
				if(selection && selection.startCell) {
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {
						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;
						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						displayField.setValue(sum);
					} else {
						displayField.setValue(0);
					}
				}
			}
		}
	});



	Unilite.Main( {
		id			: 'ssa452skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch	 
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('SALE_TO_DATE', UniDate.get('today'));
			panelSearch.setValue('SALE_FR_DATE', UniDate.get('today'));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('SALE_TO_DATE', UniDate.get('today'));
			panelResult.setValue('SALE_FR_DATE', UniDate.get('today'));

			//20181116 추가
			gsInitFlag = true;
			panelSearch.setValue('EXCHG_MONEY_UNIT'	, gsMoneyUnitRef4);
			panelSearch.setValue('EXCHANGE_RATE'	, gsExchangeRate);
			if(gsMoneyUnitRef4 != BsaCodeInfo.gsMoneyUnit && gsExchangeRate == '1.0000') {
				panelSearch.down('#conversionApplied').disable();
			}
			
			var field = panelSearch.getField('SALE_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('SALE_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			directMasterStore1.loadStoreRecords();
//			var viewLocked = masterGrid.getView();
//			var viewNormal = masterGrid.getView();
//			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(new Date()),
				"MONEY_UNIT": panelSearch.getValue('EXCHG_MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelSearch.getValue('EXCHG_MONEY_UNIT')) && panelSearch.getValue('EXCHG_MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
						panelSearch.down('#conversionApplied').disable();
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>');
					} else {
						panelSearch.down('#conversionApplied').enable();
					}
					panelSearch.setValue('EXCHANGE_RATE', provider.BASE_EXCHG);
				}
			});
		}
	});
};
</script>
