<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str330skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="str320skrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S008" /> <!-- 반품유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A" /> 	<!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B021" /> <!--양불구분-->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /><!--대분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /><!--중분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /><!--소분류-->
	<t:ExtComboStore comboType="O" /> 		<!--창고-->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Str330skrvModel1', {
		fields: [
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'				,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'					,type: 'string'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'					,type: 'string'},
			{name: 'TRNS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'integer'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.returntype" default="반품유형"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			,type: 'string'},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.sales.returndate" default="반품일"/>'			,type: 'uniDate'},

			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.sales.returnqty" default="반품량"/>'				,type: 'uniQty'},
			{name: 'INOUT_Q'			,text: '<t:message code="system.label.sales.returnqty_stock" default="반품량(재고)"/>'	,type: 'uniQty'},
			{name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.sales.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_O'		,text: '<t:message code="system.label.sales.returnamount" default="반품액"/>'			,type: 'uniUnitPrice'},

			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currency" default="화폐"/>'				,type: 'string'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'			,type: 'uniUnitPrice'},
			{name: 'INOUT_P'			,text: '<t:message code="system.label.sales.returnprice" default="반품단가"/>'		,type: 'uniPrice'},
			{name: 'INOUT_I'			,text: '<t:message code="system.label.sales.return" default="반품"/>' + '<t:message code="system.label.sales.coamount" default="자사금액"/>'		,type: 'uniPrice'},

			{name: 'INOUT_TAX_AMT'		,text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'			,type: 'uniPrice'},
			{name: 'TOT_INOUT_AMT'		,text: '<t:message code="system.label.sales.returntotalamount" default="반품총액"/>'	,type: 'uniPrice'},
			{name: 'ITEM_STATUS'		,text: '<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>'		,type: 'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				,type: 'string'},
			{name: 'DIV_NAME'			,text: '<t:message code="system.label.sales.trandivision" default="수불사업장"/>'		,type: 'string'},
			{name: 'INOUT_PRSN'			,text: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'			,type: 'string'},
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.sales.returnno" default="반품번호"/>'			,type: 'string'},
			{name: 'ISSUE_REQ_NUM'		,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'				,type: 'string'},
			{name: 'ISSUE_REQ_SEQ'		,text: '<t:message code="system.label.sales.issueseq" default="출고순번"/>'			,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'		,type: 'string'},
			{name: 'SALE_CUSTOM_NAME'	,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			,type: 'string'},
			{name: 'ACCOUNT_Q'			,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'				,type: 'uniQty'},
			{name: 'ACCOUNT_YNC'		,text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>'			,type: 'string'},
			//20200115 반품등록으로 링크 넘어가기 위해 필요한 데이터 추가
			{name: 'INOUT_CODE_LINK'	,text: 'INOUT_CODE_LINK'	,type: 'string'},
			{name: 'INOUT_PRSN_LINK'	,text: 'INOUT_PRSN_LINK'	,type: 'string'},
			{name: 'INSPEC_NUM_LINK'	,text: 'INSPEC_NUM_LINK'	,type: 'string'},
			{name: 'MONEY_UNIT_LINK'	,text: 'MONEY_UNIT_LINK'	,type: 'string'},
			{name: 'EXCHG_RATE_O_LINK'	,text: 'EXCHG_RATE_O_LINK'	,type: 'string'},
			{name: 'TAX_TYPE'			,text: 'TAX_TYPE'			,type: 'string'},
			{name: 'AGENT_TYPE'			,text: 'AGENT_TYPE'			,type: 'string'},
			{name: 'WON_CALC_BAS'		,text: 'WON_CALC_BAS'		,type: 'string'},

			{name: 'REMARK'		,text: '<t:message code="system.label.sales.remarks" default="비고"/>'		,type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('str330skrvMasterStore1',{
		model	: 'Str330skrvModel1',
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
				read: 'str330skrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;		//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;		//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
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
				}
			}
		},
		groupField: 'ITEM_CODE'
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
			items: [{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 1},
				items: [{
					fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					allowBlank: false,
					value: UserInfo.divCode,
					child: 'TXT_WH_CODE',
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelResult.getField('TXT_INOUT_PRSN');
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.sales.returndate" default="반품일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_INOUT_DATE',
					endFieldName: 'TO_INOUT_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_INOUT_DATE',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();

						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_INOUT_DATE',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
					name: 'TXT_WH_CODE',
					xtype: 'uniCombobox',
					comboType	: 'O',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXT_WH_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
					name: 'TXT_INOUT_PRSN',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B024',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXT_INOUT_PRSN', newValue);
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
					Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('ITEM_CODE', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('ITEM_NAME', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),
					Unilite.popup('AGENT_CUST',{
					fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_CODE', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_NAME', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						}
					}
				}),
				Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName:'PJT_CODE',
				textFieldName:'PJT_NAME',
					DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
//				allowBlank:false,
				textFieldOnly: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PJT_CODE', panelSearch.getValue('PJT_CODE'));
							panelResult.setValue('PJT_NAME', panelSearch.getValue('PJT_NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('PJT_CODE', '');
						panelResult.setValue('PJT_NAME', '');
					},
					applyextparam: function(popup) {
					},
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
				}), {
					fieldLabel: '<t:message code="system.label.sales.returntype" default="반품유형"/>',
					name: 'INOUT_TYPE_DETAIL',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'S008',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('INOUT_TYPE_DETAIL', newValue);
						}
					}
				},{
					//20191209 추가
					fieldLabel	: '<t:message code="system.label.sales.returnmanageno" default="반품관리번호"/>',
					name		: 'INSPEC_NUM',
					xtype		: 'uniTextfield',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('INSPEC_NUM', newValue);
						}
					}
				}]
			}]
		},{
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
				id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items: [{
				fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B055'
			}, {
					fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
					name: 'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B020',
					multiSelect:true
			},{
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name: 'TXTLV_L1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'TXTLV_L2'
			},{
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name: 'TXTLV_L2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'TXTLV_L3'
			},{
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name: 'TXTLV_L3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['TXTLV_L1','TXTLV_L2'],
				levelType:'ITEM'
			},{
				fieldLabel: '<t:message code="system.label.sales.returnqty" default="반품량"/>'	,
				name: 'FR_INOUT_Q',
				suffixTpl: '&nbsp;' + '<t:message code="system.label.sales.over" default="이상"/>'
			},{
				fieldLabel: '~',
				name: 'TO_INOUT_Q',
				suffixTpl: '&nbsp;' + '<t:message code="system.label.sales.below" default="이하"/>'
			},{
				fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
				name: 'TXT_AREA_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B056'
			},{
				fieldLabel: 'Lot No.',
				name: 'TXT_LOT_NO' ,
				xtype: 'uniTextfield'
			},{
				xtype: 'container',
				defaultType: 'uniTextfield',
				layout: {type: 'uniTable'},
				width: 325,
				items: [{
					fieldLabel: '<t:message code="system.label.sales.returnno" default="반품번호"/>',
					suffixTpl: '&nbsp;~&nbsp;',
					name: 'FR_INOUT_NUM',
					width: 218
				},{
					hideLabel: true,
					name: 'TO_INOUT_NUM',
					width: 107
				}]
			},
				Unilite.popup('ITEM_GROUP',{
				fieldLabel: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
				textFieldName: 'ITEM_GROUP_CODE',
				valueFieldName: 'ITEM_GROUP_NAME',

				validateBlank: false,
				popupWidth: 710
			})]
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
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			value: UserInfo.divCode,
			allowBlank: false,
			child: 'TXT_WH_CODE',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('TXT_INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.returndate" default="반품일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_INOUT_DATE',
			endFieldName: 'TO_INOUT_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_INOUT_DATE',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_INOUT_DATE',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
			name: 'TXT_WH_CODE',
			xtype: 'uniCombobox',
			comboType	: 'O',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXT_WH_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
			name: 'TXT_INOUT_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B024',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXT_INOUT_PRSN', newValue);
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
			Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_NAME', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),
			Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),
			Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName:'PJT_CODE',
				textFieldName:'PJT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
//				allowBlank:false,
				textFieldOnly: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PJT_CODE', panelResult.getValue('PJT_CODE'));
							panelSearch.setValue('PJT_NAME', panelResult.getValue('PJT_NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('PJT_CODE', '');
						panelSearch.setValue('PJT_NAME', '');
					},
					applyextparam: function(popup) {
					},
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
				}), {
					fieldLabel: '<t:message code="system.label.sales.returntype" default="반품유형"/>',
					name: 'INOUT_TYPE_DETAIL',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'S008',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('INOUT_TYPE_DETAIL', newValue);
						}
					}
				},{
					//20191209 추가
					fieldLabel	: '<t:message code="system.label.sales.returnmanageno" default="반품관리번호"/>',
					name		: 'INSPEC_NUM',
					xtype		: 'uniTextfield',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('INSPEC_NUM', newValue);
						}
					}
				}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('str330skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		//20200115 uniOpt 추가
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			},
			excel: {
				useExcel		: true,			//엑셀 다운로드 사용 여부
				exportGroup		: true, 		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		tbar	: [{
			fieldLabel	: '<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
			xtype		: 'uniNumberfield',
			labelWidth	: 110,
			itemId		: 'selectionSummary',
			readOnly	: true,
			value		: 0,
			decimalPrecision:4,
			format		:'0,000.0000'
		}],
		features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
						{id: 'masterGridTotal', 	ftype: 'uniSummary', 	showSummaryRow: false} ],
		columns: [
			{ dataIndex: 'ITEM_CODE'			,				width: 133,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'ITEM_CODE'			, width: 93, hidden: true },
			{ dataIndex: 'ITEM_NAME'			, width: 200 },
			{ dataIndex: 'ITEM_NAME1'			, width: 200, hidden: true },
			{ dataIndex: 'SPEC'					, width: 150 },
			{ dataIndex: 'ORDER_UNIT'			, width: 53, align: 'center' },
			{ dataIndex: 'TRNS_RATE'			, width: 60 },
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66, align: 'center'  },
			{ dataIndex: 'CUSTOM_NAME'			, width: 120 },
			{ dataIndex: 'INOUT_DATE'			, width: 80 },
			{ dataIndex: 'ORDER_UNIT_Q'			, width: 100, summaryType: 'sum' },
			{ dataIndex: 'INOUT_Q'				, width: 100, summaryType: 'sum' },
			{ dataIndex: 'ORDER_UNIT_P'			, width: 113},
			{ dataIndex: 'ORDER_UNIT_O'			, width: 113},
			{ dataIndex: 'MONEY_UNIT'			, width: 80},
			{ dataIndex: 'EXCHG_RATE_O'			, width: 80},
			{ dataIndex: 'INOUT_P'				, width: 113},
			{ dataIndex: 'INOUT_I'				, width: 113, summaryType: 'sum'},
			{ dataIndex: 'INOUT_TAX_AMT'		, width: 113, summaryType: 'sum'},
			{ dataIndex: 'TOT_INOUT_AMT'		, width: 113, summaryType: 'sum'},
			{ dataIndex: 'ITEM_STATUS'			, width: 66, align: 'center'  },
			{ dataIndex: 'WH_CODE'				, width: 100 },
			{ dataIndex: 'DIV_NAME'				, width: 100 },
			{ dataIndex: 'INOUT_PRSN'			, width: 80 , align: 'center' },
			{ dataIndex: 'INOUT_NUM'			, width: 110 },
			{ dataIndex: 'ISSUE_REQ_NUM'		, width: 110 },
			{ dataIndex: 'ISSUE_REQ_SEQ'		, width: 66 },
			{ dataIndex: 'LOT_NO'				, width: 90 },
			{ dataIndex: 'PROJECT_NO'			, width: 90 },
			{ dataIndex: 'SALE_CUSTOM_NAME'		, width: 113 },
			{ dataIndex: 'ACCOUNT_Q'			, width: 80, summaryType: 'sum'  },
			{ dataIndex: 'ACCOUNT_YNC'			, width: 80, align: 'center' },
			{ dataIndex: 'REMARK'			, width: 200}
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
						this.down('#selectionSummary').setValue(sum);
					} else {
						this.down('#selectionSummary').setValue(0);
					}
				}
			},
			//20200115 바로가기 로직 추가
			afterrender: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text	: '<t:message code="system.label.sales.linkstr110ukrv" default="반품등록 바로가기"/>',
					iconCls	: '',
					handler	: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							sender			: me,
							'PGM_ID'		: 'str320skrv',
							'COMP_CODE'		: UserInfo.compCode,
							'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
							'INOUT_NUM'		: record.get('INOUT_NUM'),
							'INOUT_DATE'	: record.get('INOUT_DATE'),
							'INOUT_PRSN'	: record.get('INOUT_PRSN_LINK'),
							'CUSTOM_CODE'	: record.get('INOUT_CODE_LINK'),
							'CUSTOM_NAME'	: record.get('CUSTOM_NAME'),
							'INSPEC_NUM'	: record.get('INSPEC_NUM_LINK'),
							'MONEY_UNIT'	: record.get('MONEY_UNIT_LINK'),
							'EXCHG_RATE_O'	: record.get('EXCHG_RATE_O_LINK'),
							'TAX_TYPE'		: record.get('TAX_TYPE'),
							'AGENT_TYPE'	: record.get('AGENT_TYPE'),
							'WON_CALC_BAS'	: record.get('WON_CALC_BAS')
						}
						var rec = {data : {prgID : 'str110ukrv', 'text':''}};
						parent.openTab(rec, '/sales/str110ukrv.do', params);
					}
				});
			}
		}
	});



	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			var field = panelSearch.getField('TXT_INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('TXT_INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			var param = {
				"DIV_CODE": UserInfo.divCode,
				"DEPT_CODE": UserInfo.deptCode
			};
			str110ukrvService.deptWhcode(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('TXT_WH_CODE', provider['WH_CODE']);
					panelResult.setValue('TXT_WH_CODE', provider['WH_CODE']);
				}
			});

			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelSearch.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelSearch.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_INOUT_DATE')));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelResult.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_INOUT_DATE')));
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			directMasterStore1.loadStoreRecords();
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
		}
	});
};
</script>