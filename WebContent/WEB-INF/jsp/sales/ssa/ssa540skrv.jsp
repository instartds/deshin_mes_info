<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="ssa540skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa540skrv"/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!--품목유형-->
	<t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/>	<!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B055" />				<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />				<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />				<!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S002" />				<!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" />				<!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="S007" />				<!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S010" />				<!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S024" />				<!--국내:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S118" />				<!--해외:부가세유형-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!--창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
</t:appConfig>

<script type="text/javascript" >
var BsaCodeInfo = {
	gsSiteCode	: '${gsSiteCode}'
};
function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Ssa540skrvModel1', {
		fields: [
			{name: 'SALE_CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'					,type: 'string'},
			{name: 'SALE_CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				,type: 'string'},



			{name: 'BILL_TYPE'			,text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'					,type: 'string',comboType: "AU", comboCode: "S024"},
			{name: 'SALE_DATE'			,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'					,type: 'uniDate'},
			{name: 'SALE_MONTH'			,text: '<t:message code="system.label.sales.salesmonth" default="매출월"/>'					,type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'				,type: 'string',comboType: "AU", comboCode: "S007"},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'					,type: 'string'},
			{name: 'CREATE_LOC'			,text: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'				,type: 'string',comboType: "AU", comboCode: "B031"},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'						,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'					,type: 'string'},
			{name: 'NEW_ITEM_YN'		,text: '신제품여부'																			,type: 'string'},
			{name: 'SAVING_Q'			,text: '관리품수량'																			,type: 'uniQty'},
			{name: 'SALE_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'						,type: 'string'},
			{name: 'PRICE_TYPE'			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				,type: 'string'},
			{name: 'TRANS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				,type: 'string'},
			{name: 'SALE_Q'				,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'					,type: 'uniQty'},
			{name: 'SALE_WGT_Q'			,text: '<t:message code="system.label.sales.salesqtywgt" default="매출량(중량)"/>'			,type: 'uniQty'},
			{name: 'SALE_VOL_Q'			,text: '<t:message code="system.label.sales.salesqtyvol" default="매출량(부피)"/>'			,type: 'uniQty'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.sales.sodate" default="수주일"/>'					,type: 'uniDate'},
			{name: 'ORDER_Q'			,text: '수주량'					,type: 'uniQty'},
			{name: 'INIT_DVRY_DATE'		,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'				,type:'uniDate'},
			{name: 'DVRY_DATE'			,text:'<t:message code="system.label.sales.changeddeliverydate" default="납기변경일"/>'		,type:'uniDate'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.salesordercustom" default="수주거래처"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.salesordercustomname" default="수주거래처명"/>'	,type: 'string'},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'					,type: 'uniDate'},
			{name: 'NATION_NAME'		,text: '국가'						,type: 'string'},
			{name: 'CONTINENT'			,text: '대륙'						,type: 'string'},

			{name: 'SALE_P'				,text: '<t:message code="system.label.sales.price" default="단가"/>'						,type: 'uniUnitPrice'},
			{name: 'SALE_FOR_WGT_P'		,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'			,type: 'uniUnitPrice'},
			{name: 'SALE_FOR_VOL_P'		,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'			,type: 'uniUnitPrice'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currency" default="화폐"/>'					,type: 'string'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'				,type: 'uniER'},
			{name: 'SALE_LOC_AMT_F'		,text: '<t:message code="system.label.sales.salesamountforeign" default="매출액(외화)"/>'	,type: 'uniFC'},
			{name: 'SALE_LOC_AMT_I'		,text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'				,type: 'uniPrice'},
			{name: 'TAX_TYPE'			,text: '<t:message code="system.label.sales.taxationyn" default="과세여부"/>'				,type: 'string', comboType: "AU", comboCode: "B059"},
			{name: 'TAX_AMT_O'			,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'					,type: 'uniPrice'},
			{name: 'SUM_SALE_AMT'		,text: '<t:message code="system.label.sales.salestotal" default="매출계"/>'				,type: 'uniPrice'},
			//20190528 매출원가(SALE_COST_AMT)
			{name: 'SALE_COST_AMT'		,text: '<t:message code="system.label.sales.salescostII" default="매출원가"/>'				,type: 'uniPrice'},
//			{name: 'CONSIGNMENT_FEE'	,text: '수수료(위탁)'	,type: 'uniPrice'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'				,type: 'string',comboType: "AU", comboCode: "S002"},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'					,type: 'string',comboType: "BOR120"},
			{name: 'SALE_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				,type: 'string',comboType: "AU", comboCode: "S010"},
			{name: 'MANAGE_CUSTOM'		,text: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>'			,type: 'string'},
			{name: 'MANAGE_CUSTOM_NM'	,text: '<t:message code="system.label.sales.summarycustomname" default="집계거래처명"/>'		,type: 'string'},
			{name: 'AREA_TYPE'			,text: '<t:message code="system.label.sales.area" default="지역"/>'						,type: 'string',comboType: "AU", comboCode: "B056"},
			{name: 'AGENT_TYPE'			,text: '<t:message code="system.label.sales.customclass" default="거래처분류"/>'				,type: 'string',comboType: "AU", comboCode: "B055"},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				,type: 'string'},
			//20200103 프로젝트명 추가
			{name: 'PJT_NAME'			,text: '<t:message code="system.label.sales.projectname" default="프로젝트명"/>'				,type: 'string', editable: false},
			{name: 'PUB_NUM'			,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'					,type: 'string'},
			{name: 'EX_NUM'				,text: '<t:message code="system.label.sales.slipno" default="전표번호"/>'					,type: 'string'},
			{name: 'BILL_NUM'			,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'					,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'						,type: 'string'},
			{name: 'DISCOUNT_RATE'		,text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'			,type: 'number'},
			{name: 'PRICE_YN'			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				,type: 'string', comboType: "AU", comboCode: "S003"},
			{name: 'WGT_UNIT'			,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'				,type: 'string'},
			{name: 'UNIT_WGT'			,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'				,type: 'string'},
			{name: 'VOL_UNIT'			,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'				,type: 'string'},
			{name: 'UNIT_VOL'			,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'				,type: 'string'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'					,type: 'string'},
			{name: 'BILL_SEQ'			,text: '<t:message code="system.label.sales.billseq" default="계산서순번"/>'					,type: 'string'},
			{name: 'SALE_AMT_WON'		,text: '<t:message code="system.label.sales.cosalesamount" default="매출액(자사)"/>'			,type: 'uniPrice'},
			{name: 'TAX_AMT_WON'		,text: '<t:message code="system.label.sales.cotaxamount" default="세액(자사)"/>'			,type: 'uniPrice'},
			{name: 'SUM_SALE_AMT_WON'	,text: '<t:message code="system.label.sales.cosalestotal" default="매출계(자사)"/>'			,type: 'uniPrice'},
			{name: 'CUSTOM_ITEM_CODE'	,text: '<t:message code="system.label.sales.customitem" default="거래처품목"/>'				,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'					,type: 'string'},
			{name: 'WH_NAME'			,text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'			,type: 'string'},
			{name: 'WH_CELL_NAME'		,text: '<t:message code="system.label.sales.issuewarehousecell" default="출고창고CELL"/>'	,type: 'string'},
			{name: 'ITEM_LEVEL1'		,text: '<t:message code="system.label.base.majorgroup" default="대분류"/>'		, type:'string', store: Ext.data.StoreManager.lookup('itemLeve1Store'), child: 'LEVEL2'},
			{name: 'ITEM_LEVEL2'		,text: '<t:message code="system.label.base.middlegroup" default="중분류"/>'	, type:'string', store: Ext.data.StoreManager.lookup('itemLeve2Store'), child: 'LEVEL3'},
			{name: 'ITEM_LEVEL3'		,text: '<t:message code="system.label.base.minorgroup" default="소분류"/>'		, type:'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			{name: 'START_DATE'			,text: '사용시작일'																, type: 'uniDate'},
			{name: 'NEW_ITEM_TERM'		,text: '신제품관리기간'															, type: 'int'},
			{name: 'DATA_ERROR'			,text: 'DATA_ERROR'															, type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('ssa540skrvMasterStore1',{
		model	: 'Ssa540skrvModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'ssa540skrvService.selectList1'
			}
		},
		loadStoreRecords: function(newValue) {
			var param= Ext.getCmp('searchForm').getValues();
//			var authoInfo = pgmInfo.authoUser;			  //권한정보(N-전체,A-자기사업장>5-자기부서)
//			var deptCode = UserInfo.deptCode;	//부서코드
//			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
//				param.DEPT_CODE = deptCode;
//			}
			if(newValue || newValue == '') {
				param.NEW_ITEM_YN = newValue;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
					masterGrid.setShowSummaryRow(true);
					UniAppManager.setToolbarButtons('print', true);
				} else {
					UniAppManager.setToolbarButtons('print', false);
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
		items		: [{
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
					child		: 'WH_CODE',			//20200602 추가
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
					autoPopup		: true,
					valueFieldName	: 'SALE_CUSTOM_CODE',
					textFieldName	: 'SALE_CUSTOM_NAME',
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('SALE_CUSTOM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('SALE_CUSTOM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER': ['1', '3']});
							popup.setExtParam({'CUSTOM_TYPE': ['1', '3']});
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
					fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
					name		: 'SALE_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S010',
					multiSelect: true,
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
				}),{
					fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
					width			: 315,
					xtype			: 'uniDateRangefield',
					startFieldName	: 'SALE_FR_DATE',
					endFieldName	: 'SALE_TO_DATE',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					allowBlank		: false,
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
				},{
					fieldLabel	: '<t:message code="system.label.base.taxtype" default="세구분"/>' ,
					name		: 'TAX_TYPE',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					holdable	: 'hold',
					comboCode	: 'B059',
					allowBlank	: true,
					fieldStyle	: 'text-align: center;',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TAX_TYPE',newValue);
						}
					}
				},{	//20200212 추가: 조회조건 국내외 구분 추가
					xtype	: 'container',
					layout	: { type: 'uniTable', columns: 3},
					items	: [{
						fieldLabel	: ' ',
						xtype		: 'radiogroup',
						items		: [{
							boxLabel	: '전체',
							name		: 'NATION_INOUT',
							inputValue	: '3',
							width		: 70
						},{
							boxLabel	: '<t:message code="system.label.sales.domestic" default="국내"/>',
							name		: 'NATION_INOUT',
							inputValue	: '1',
							width		: 70
						},{
							boxLabel	: '<t:message code="system.label.sales.foreign" default="해외"/>',
							name		: 'NATION_INOUT',
							inputValue	: '2',
							width		: 70
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('NATION_INOUT', newValue.NATION_INOUT);
							}
						}
					}]
				},{
		            xtype: 'radiogroup',
		            fieldLabel: '신제품여부',
		            items: [{
		                boxLabel: '전체',
		                width: 60,
		                name: 'NEW_ITEM_YN',
		                inputValue: 'A',
		                checked: true
		            },{
		                boxLabel: '신제품',
		                width: 60, name: 'NEW_ITEM_YN',
		                inputValue: 'Y'
		            }],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('NEW_ITEM_YN').setValue(newValue.NEW_ITEM_YN);
							directMasterStore.loadStoreRecords(newValue.NEW_ITEM_YN);
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
				multiSelect	: true,
				comboType	: 'AU',
				comboCode	: 'B020'
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.salesslipyn" default="매출기표유무"/>',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					width		: 50,
					name		: 'SALE_YN',
					inputValue	: 'A',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.slipposting" default="기표"/>',
					width		: 50,
					name		: 'SALE_YN',
					inputValue	: 'Y'
				},{
					boxLabel	: '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
					width		: 70,
					name		: 'SALE_YN',
					inputValue	: 'N'
				}]
			},{
				fieldLabel	: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
				name		: 'TXT_CREATE_LOC',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B031'
			},{
				fieldLabel	: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
				name		: 'BILL_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S024'
			},{
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
			}),{
				fieldLabel	: '<t:message code="system.label.sales.issuetype" default="출고유형"/>',
				name		: 'INOUT_TYPE_DETAIL',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				multiSelect	: true,
				comboCode	: 'S007'
			},{
				fieldLabel	: '<t:message code="system.label.sales.area" default="지역"/>',
				name		: 'AREA_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				multiSelect	: true,
				comboCode	: 'B056'
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>',
				validateBlank	: false,
				valueFieldName	: 'MANAGE_CUSTOM',
				textFieldName	: 'MANAGE_CUSTOM_NAME',
				id				: 'ssa540skrvvCustPopup',
				extParam		: {'CUSTOM_TYPE': ''}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name		: 'ORDER_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				multiSelect	: true,
				comboCode	: 'S002'
			},{
				fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'ITEM_LEVEL2'
			},{
				fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'ITEM_LEVEL3'
			},{
				fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames	: ['ITEM_LEVEL1','ITEM_LEVEL2'],
				levelType	: 'ITEM'
			},{
				xtype		: 'container',
				layout		: {type: 'hbox', align: 'stretch'},
				width		: 325,
				defaultType	: 'uniTextfield',
				items		: [{
					fieldLabel	: '<t:message code="system.label.sales.salesno" default="매출번호"/>',
					suffixTpl	: '&nbsp;~&nbsp;',
					name		: 'BILL_FR_NO',
					width		: 218
				},{
					hideLabel	: true,
					name		: 'BILL_TO_NO',
					width		: 107
				}]
			},{
				xtype		: 'container',
				layout		: {type: 'hbox', align: 'stretch'},
				width		: 325,
				defaultType	: 'uniTextfield',
				items		: [{
					fieldLabel	: '<t:message code="system.label.sales.billno" default="계산서번호"/>',
					suffixTpl	: '&nbsp;~&nbsp;',
					name		: 'PUB_FR_NUM',
					width		: 218
				},{
				hideLabel	: true,
				name		: 'PUB_TO_NUM',
				width		: 107
				}]
			},{
				fieldLabel	: '<t:message code="system.label.sales.salesqty" default="매출량"/>',
				name		: 'SALE_FR_Q',
				suffixTpl	: '&nbsp;이상'
			},{
				fieldLabel	: ' ',
				name		: 'SALE_TO_Q',
				suffixTpl	: '&nbsp;이하'
			},{
				fieldLabel		: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
				 xtype			: 'uniDateRangefield',
				 startFieldName	: 'INOUT_FR_DATE',
				 endFieldName	: 'INOUT_TO_DATE',
				 width			: 315
			},{
				fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
				name		: 'REMARK',
				width		: 300
			},{	//20200526 추가
				fieldLabel	: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				child		: 'WH_CELL_CODE',
				multiSelect	: true,
				store		: Ext.data.StoreManager.lookup('whList'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{	//20200526 추가
				fieldLabel	: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>CELL',
				name		: 'WH_CELL_CODE',
				xtype		: 'uniCombobox',
				multiSelect	: true,
				store		: Ext.data.StoreManager.lookup('whCellList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
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
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
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
			autoPopup		: true,
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('SALE_CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('SALE_CUSTOM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER': ['1', '3']});
					popup.setExtParam({'CUSTOM_TYPE': ['1', '3']});
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
		}),{//20200212 추가: 조회조건 국내외 구분 추가
			xtype	: 'container',
			layout	: { type: 'uniTable', columns: 3},
			colspan : 2,
			items	: [{
				fieldLabel	: ' ',
				xtype		: 'radiogroup',
				items		: [{
					boxLabel	: '전체',
					name		: 'NATION_INOUT',
					inputValue	: '3',
					width		: 70
				},{
					boxLabel	: '<t:message code="system.label.sales.domestic" default="국내"/>',
					name		: 'NATION_INOUT',
					inputValue	: '1',
					width		: 70
				},{
					boxLabel	: '<t:message code="system.label.sales.foreign" default="해외"/>',
					name		: 'NATION_INOUT',
					inputValue	: '2',
					width		: 70
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('NATION_INOUT', newValue.NATION_INOUT);
					}
				}
			}]
		},{
			fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			width			: 315,
			xtype			: 'uniDateRangefield',
			allowBlank		: false,
			startFieldName	: 'SALE_FR_DATE',
			endFieldName	: 'SALE_TO_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
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
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			multiSelect: true,
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
		}),{
			fieldLabel	: '<t:message code="system.label.base.taxtype" default="세구분"/>' ,
			name		: 'TAX_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			holdable	: 'hold',
			comboCode	: 'B059',
			allowBlank	: true,
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TAX_TYPE',newValue);
				}
			}
		},{
            xtype: 'radiogroup',
            fieldLabel: '신제품여부',
            margin: '0 0 0 20',
            items: [{
                boxLabel: '전체',
                width: 60,
                name: 'NEW_ITEM_YN',
                inputValue: 'A',
                checked: true
            },{
                boxLabel: '신제품',
                width: 60, name: 'NEW_ITEM_YN',
                inputValue: 'Y'
            }],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('NEW_ITEM_YN').setValue(newValue.NEW_ITEM_YN);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('ssa540skrvGrid1', {
		store	: directMasterStore,
		region	: 'center',
		syncRowHeight: false,
		tbar	: [{
			fieldLabel	: '<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
			id			: 'selectionSummary',
			xtype		: 'uniNumberfield',
			decimalPrecision:4,
			format		: '0,000.0000',
			labelWidth	: 110,
			value		: 0
		}],
		uniOpt:{
			expandLastColumn: false,
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{ dataIndex: 'SALE_MONTH'			, width: 80	, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'SALE_DATE'			, width: 80	, align: 'center'},		//매출일
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 80	, align: 'center'},		//출고유형
			{ dataIndex: 'ITEM_CODE'			, width: 123},						//품목코드
			{ dataIndex: 'ITEM_NAME'			, width: 150},						//품명
			{ dataIndex: 'ITEM_NAME1'			, width: 150, hidden: true},		//품명1
			{ dataIndex: 'ITEM_LEVEL1'			, width: 120, hidden: true},		//대분류
			{ dataIndex: 'ITEM_LEVEL2'			, width: 100, hidden: true},		//중분류
			{ dataIndex: 'ITEM_LEVEL3'			, width: 100, hidden: true},		//소분류
			{ dataIndex: 'SPEC'					, width: 123},						//규격
			{ dataIndex: 'LOT_NO'				, width: 100},						//LOT_NO
			{ dataIndex: 'NEW_ITEM_YN'			, width: 100, align: 'center'},     //신제품여부
			{ dataIndex: 'SAVING_Q'				, width: 100},                      //관리품수량
			{ dataIndex: 'MONEY_UNIT'			, width: 60	, align: 'center'},		//화폐
			{ dataIndex: 'EXCHG_RATE_O'			, width: 60	, align: 'right'},		//환율
			{ dataIndex: 'SALE_UNIT'			, width: 53	, align: 'center'},		//단위
			{ dataIndex: 'TRANS_RATE'			, width: 53	, align: 'right'},		//입수
			{ dataIndex: 'SALE_Q'				, width: 80	, summaryType: 'sum'},	//매출량
			{ dataIndex: 'PRICE_TYPE'			, width: 53	, hidden: true},		//단가구분
			{ dataIndex: 'SALE_P'				, width: 113},						//단가
			{ dataIndex: 'SALE_LOC_AMT_F'		, width: 113, summaryType: 'sum'},	//매출액(외화)
			{ dataIndex: 'TAX_AMT_O'			, width: 100, summaryType: 'sum'},	//세액
			{ dataIndex: 'SUM_SALE_AMT'			, width: 113, summaryType: 'sum'},	//매출계
			//20190528 매출원가(SALE_COST_AMT)
			{ dataIndex: 'SALE_COST_AMT'		, width: 113, summaryType: 'sum', hidden:true},	//매출원가 기본값 hidden 으로 변경
			{ dataIndex: 'SALE_AMT_WON'			, width: 113, summaryType: 'sum'},	//매출액(자사)
			{ dataIndex: 'TAX_AMT_WON'			, width: 113, summaryType: 'sum'},	//세액(자사)
			{ dataIndex: 'SUM_SALE_AMT_WON'		, width: 113, summaryType: 'sum'},	//매출계(자사)
			{ dataIndex: 'DISCOUNT_RATE'		, width: 80	},						//할인율(%)
			{ dataIndex: 'SALE_LOC_AMT_I'		, width: 113, hidden: true},		//매출액
			{ dataIndex: 'SALE_CUSTOM_CODE'		, width: 80},
			{ dataIndex: 'SALE_CUSTOM_NAME'		, width: 120, locked: false },		//거래처명

			{ dataIndex: 'NATION_NAME'			, width: 120	},		//국가
			{ dataIndex: 'CONTINENT'			, width: 100	},		//대륙

			{ dataIndex: 'BILL_TYPE'			, width: 80	, align: 'center'},		//부가세유형




			{ dataIndex: 'TAX_TYPE'				, width: 80	, align: 'center'},		//과세여부
			{ dataIndex: 'ORDER_TYPE'			, width: 100},						//판매유형
			{ dataIndex: 'ORDER_DATE'			, width: 100},						//수주일자
			{ dataIndex: 'ORDER_Q'			, width: 100},						//수주량
			{ dataIndex: 'INIT_DVRY_DATE'		, width: 100},						//납기일
			{ dataIndex: 'DVRY_DATE'			, width: 100},						//납기변경일
			{ dataIndex: 'CUSTOM_CODE'			, width: 80	},						//수주거래처
			{ dataIndex: 'CUSTOM_NAME'			, width: 113},						//수주거래처명
			{ dataIndex: 'INOUT_DATE'			, width: 100},						//출고일
			{ dataIndex: 'SALE_PRSN'			, width: 100},						//영업담당
			{ dataIndex: 'SALE_WGT_Q'			, width: 100, hidden: true },		//매출량(중량)
			{ dataIndex: 'SALE_VOL_Q'			, width: 80	, hidden: true},		//매출량(부피)
			{ dataIndex: 'SALE_FOR_WGT_P'		, width: 113, hidden: true },		//단가(중량)
			{ dataIndex: 'SALE_FOR_VOL_P'		, width: 113, hidden: true},		//단가(부피)
			{ dataIndex: 'DIV_CODE'				, width: 100},						//사업장
			{ dataIndex: 'PROJECT_NO'			, width: 113},						//프로젝트번호
			//20200103 프로젝트명 추가
			{ dataIndex: 'PJT_NAME'				, width: 120},
			{ dataIndex: 'PUB_NUM'				, width: 80	},						//계산서번호
			{ dataIndex: 'EX_NUM'				, width: 93	},						//전표번호
			{ dataIndex: 'BILL_NUM'				, width: 110},						//매출번호
			{ dataIndex: 'ORDER_NUM'			, width: 106},						//수주번호
			{ dataIndex: 'PRICE_YN'				, width: 106},						//단가구분
			{ dataIndex: 'WGT_UNIT'				, width: 106, hidden: true},		//중량단위
			{ dataIndex: 'UNIT_WGT'				, width: 106, hidden: true},		//단위중량
			{ dataIndex: 'VOL_UNIT'				, width: 106, hidden: true},		//부피단위
			{ dataIndex: 'UNIT_VOL'				, width: 106, hidden: true},		//단위부피
			{ dataIndex: 'COMP_CODE'			, width: 106, hidden: true},		//법인코드
			{ dataIndex: 'BILL_SEQ'				, width: 106, hidden: true},		//계산서 순번
			{ dataIndex: 'MANAGE_CUSTOM'		, width: 80	, hidden: true},		//집계거래처
			{ dataIndex: 'MANAGE_CUSTOM_NM'		, width: 113, hidden: true},		//집계거래처명
			{ dataIndex: 'AREA_TYPE'			, width: 66	, hidden: true},		//지역
			{ dataIndex: 'AGENT_TYPE'			, width: 113, hidden: true},		//거래처분류
			{ dataIndex: 'CREATE_LOC'			, width: 80	, hidden: true},		//생성경로
			{ dataIndex: 'CUSTOM_ITEM_CODE'		, width: 113, hidden: false},		//거래처 +품목코드
			{ dataIndex: 'WH_NAME'				, width: 120},		//출고창고
			{ dataIndex: 'WH_CELL_NAME'			, width: 150},		//출고창고CELL
			{ dataIndex: 'REMARK'				, width: 300, hidden: false},
			{ dataIndex: 'START_DATE'			, width: 100},
			{ dataIndex: 'NEW_ITEM_TERM'		, width: 110},
			{ dataIndex: 'DATA_ERROR'			, width: 110, hidden: true}
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
			},
			afterrender: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text: '매출등록 바로가기',	iconCls : '',
					handler: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							sender		: me,
							'PGM_ID'	: 'ssa540skrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							BILL_NUM	: record.data.BILL_NUM
						}
						var rec = {data : {prgID : 'ssa100ukrv', 'text':''}};
						parent.openTab(rec, '/sales/ssa100ukrv.do', params);
					}
				});
				if(BsaCodeInfo.gsSiteCode == 'KODI'){
					masterGrid.getColumn('ITEM_LEVEL1').setVisible(true);
					masterGrid.getColumn('ITEM_LEVEL2').setVisible(true);
					masterGrid.getColumn('ITEM_LEVEL3').setVisible(true);
				}else{
					masterGrid.getColumn('ITEM_LEVEL1').setVisible(false);
					masterGrid.getColumn('ITEM_LEVEL2').setVisible(false);
					masterGrid.getColumn('ITEM_LEVEL3').setVisible(false);
				}
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				if(record.get('DATA_ERROR') == 'N') {
					cls = 'x-change-celltext_red';
				}
				return cls;
			}
		}
	});



	Unilite.Main({
		id			: 'ssa540skrvApp',
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
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('SALE_TO_DATE', UniDate.get('today'));
			panelSearch.setValue('SALE_FR_DATE', UniDate.get('today'));
			//20200212 추가: 조회조건 국내외 구분 추가
			panelSearch.getField('NATION_INOUT').setValue('1');

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('SALE_TO_DATE', UniDate.get('today'));
			panelResult.setValue('SALE_FR_DATE', UniDate.get('today'));
			//20200212 추가: 조회조건 국내외 구분 추가
			panelResult.getField('NATION_INOUT').setValue('1');

			var field = panelSearch.getField('SALE_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('SALE_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			UniAppManager.setToolbarButtons('print', false);

			//20200221 세금계산서 발행현황에 링크 기능 추가로 인해 받는 로직 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		//20200221 세금계산서 발행현황에 링크 기능 추가로 인해 받는 로직 추가
		processParams: function(params) {
			if(params.PGM_ID == 'ssa580skrv') {
				panelSearch.setValue('DIV_CODE'			, params.DIV_CODE);
				panelResult.setValue('DIV_CODE'			, params.DIV_CODE);
				panelSearch.setValue('SALE_FR_DATE'		, params.PUB_FR_DATE);
				panelResult.setValue('SALE_FR_DATE'		, params.PUB_FR_DATE);
				panelSearch.setValue('SALE_TO_DATE'		, params.PUB_TO_DATE);
				panelResult.setValue('SALE_TO_DATE'		, params.PUB_TO_DATE);
				panelSearch.setValue('SALE_CUSTOM_CODE'	, params.CUSTOM_CODE);
				panelResult.setValue('SALE_CUSTOM_CODE'	, params.CUSTOM_CODE);
				panelSearch.setValue('SALE_CUSTOM_NAME'	, params.CUSTOM_NAME);
				panelResult.setValue('SALE_CUSTOM_NAME'	, params.CUSTOM_NAME);

				panelSearch.setValue('PUB_FR_NUM'		, params.PUB_NUM);
				panelSearch.setValue('PUB_TO_NUM'		, params.PUB_NUM);

//				panelSearch.getField('NATION_INOUT').setValue('1');
//				panelResult.getField('NATION_INOUT').setValue('1');

				UniAppManager.app.onQueryButtonDown();
			}
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			var win;
			var param = panelSearch.getValues();
			param.NEW_ITEM_YN = param.NEW_ITEM_YN;
			if(!Ext.isEmpty(panelSearch.getValue('WH_CODE'))) {
				var items1 = '';
				var whCode = panelSearch.getValue('WH_CODE');
				Ext.each(whCode, function(item, i) {
					if(i == 0) {
						items1 = item;
					} else {
						items1 = items1 + ',' + item;
					}
				});
				param.WH_CODE = items1;
			}
			if(!Ext.isEmpty(panelSearch.getValue('WH_CELL_CODE'))) {
				var items2 = '';
				var whCellCode = panelSearch.getValue('WH_CELL_CODE');
				Ext.each(whCellCode, function(item, i) {
					if(i == 0) {
						items2 = item;
					} else {
						items2 = items2 + ',' + item;
					}
				});
				param.WH_CELL_CODE = items2;
			}
			win = Ext.create('widget.ClipReport', {
				url		: CPATH+'/sales/ssa540clskrv.do',
				prgID	: 'ssa540skrv',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>