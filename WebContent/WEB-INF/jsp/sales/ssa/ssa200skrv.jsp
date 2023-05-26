<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa200skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa200skrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!--수불담당-->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="S008" /> <!--반품유형-->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
	<t:ExtComboStore comboType="AU" comboCode="B036" /> <!--수불방법-->
	<t:ExtComboStore comboType="AU" comboCode="S014" /> <!--매출대상여부-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore comboType="O" />	 <!--창고(전체) -->

</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Ssa200skrvModel1', {
		fields: [
			{name: 'SALE_DIV_CODE'		,text: '사업장'			,type: 'string',comboType:'BOR120'},
			{name: 'INOUT_CODE'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'					,type: 'string'},
			{name: 'INOUT_NAME'			,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				,type: 'string'},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'					,type: 'uniDate'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'						,type: 'string'},
			{name: 'TRNS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				,type: 'string'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'				,type: 'string', displayField: 'value'},
			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'					,type: 'uniQty'},
			//20191030 추가: ORDER_UNIT_P, ORDER_UNIT_O
			{name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.sales.price" default="단가"/>'						,type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_O'		,text: '<t:message code="system.label.sales.amount" default="금액"/>'						,type: 'uniPrice'},
			{name: 'ACCOUNT_Q'			,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'					,type: 'uniQty'},
			{name: 'NO_ACCOUNT'			,text: '<t:message code="system.label.sales.notbillingqty" default="미매출량"/>'			,type: 'uniQty'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'				,type: 'string'},
			{name: 'INOUT_CODE_TYPE'	,text: '<t:message code="system.label.sales.tranplacedivision" default="수불처구분"/>'		,type: 'string'},
			{name: 'DOM_FORIGN'			,text: '<t:message code="system.label.sales.domesticoverseasclass" default="국내외구분"/>'	,type: 'string'},
			{name: 'ACCOUNT_YNC'		,text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>'				,type: 'string',comboType: 'AU', comboCode: 'S014'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'					,type: 'string',comboType: 'O'},
			{name: 'INOUT_PRSN'			,text: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'				,type: 'string',comboType: 'AU', comboCode: 'B024'},
			{name: 'ISSUE_REQ_DATE'		,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'		,type: 'uniDate'},
			{name: 'ISSUE_REQ_NUM'		,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'		,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'						,type: 'string'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'				,type: 'uniDate'},
			{name: 'LC_NUM'				,text: '<t:message code="system.label.sales.lcno" default="L/C번호"/>'					,type: 'string'},
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.sales.tranno" default="수불번호"/>'					,type: 'string'},
			{name: 'INOUT_SEQ'			,text: '<t:message code="system.label.sales.transeq" default="수불순번"/>'					,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				,type: 'string'},
			{name: 'INOUT_METH'			,text: 'INOUT_METH'		,type: 'string'},
			{name: 'SORT_KEY'			,text: 'SORT_KEY'		,type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('ssa200skrvMasterStore1',{
		model: 'Ssa200skrvModel1',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {
				read: 'ssa200skrvService.selectList1'
			}
		}
		,loadStoreRecords: function()	{
			var param = panelSearch.getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'INOUT_NAME',
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
					masterGrid.setShowSummaryRow(true);
				}
			}
		}
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
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'	,
					name: 'TXT_INOUT_PRSN',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B024',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXT_INOUT_PRSN', newValue);
						}
					}
				},
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
				}), {
					fieldLabel: '<t:message code="system.label.sales.issueno" default="출고번호"/>',
					xtype: 'uniTextfield',
					name: 'INOUT_NUM_FR',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('INOUT_NUM_FR', newValue);
						}
					}
				}, {
					fieldLabel: '~',
					xtype: 'uniTextfield',
					name: 'INOUT_NUM_TO',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('INOUT_NUM_TO', newValue);
						}
					}
				}, {
					fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',name: 'TXT_WH_CODE',
					xtype: 'uniCombobox',
					comboType: 'O',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXT_WH_CODE', newValue);
						}
					}
				},
					Unilite.popup('DIV_PUMOK', {
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
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
					Unilite.popup('PROJECT',{
					fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
					valueFieldName:'PROJECT_NO',
					textFieldName:'PROJECT_NAME',
					DBvalueFieldName: 'PJT_CODE',
					DBtextFieldName: 'PJT_NAME',
					validateBlank: false,
	//				allowBlank:false,
					textFieldOnly: false,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PROJECT_NO', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('PROJECT_NAME', newValue);
						}
					}
				}), {
					fieldLabel: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'INOUT_DATE_FR',
					endFieldName: 'INOUT_DATE_TO',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('INOUT_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();

						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('INOUT_DATE_TO',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
						}
					}
				},{	//20200414 추가: 조회조건 국/내외구분
					fieldLabel	: ' ',
					xtype		: 'radiogroup',
					itemId		: 'NATION_INOUT',
					items		: [{
						boxLabel	: '<t:message code="system.label.sales.domestic" default="국내"/>',
						name		: 'NATION_INOUT',
						inputValue	: '1',
						width		: 80
					},{
						boxLabel	: '<t:message code="system.label.sales.foreign" default="해외"/>',
						name		: 'NATION_INOUT',
						inputValue	: '2',
						width		: 80
					}],
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('NATION_INOUT', newValue.NATION_INOUT);
						}
					}
				}]
			}]
		}, {
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B055'
			}, {
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name: 'TXTLV_L1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'TXTLV_L2'
			}, {
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name: 'TXTLV_L2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'TXTLV_L3'
			}, {
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name: 'TXTLV_L3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['TXTLV_L1','TXTLV_L2'],
				levelType:'ITEM'
			}, {
				fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
				name: 'TXT_ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020'
			}, {
				fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
				name: 'TXT_AREA_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B056'
			}, {
				fieldLabel: '<t:message code="system.label.sales.salessubject" default="매출대상"/>'	,
				name: 'ACCOUNT_YNC',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'S014',
				value: 'Y',
				readOnly: true
			}, {
				fieldLabel: '<t:message code="system.label.sales.issuetype" default="출고유형"/>',
				name: 'INOUT_TYPE_DETAIL',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'S007'
			}, {
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.sales.tradeinclusionyn" default="무역포함여부"/>',
				id: 'rdoSelect1',
				hidden: true,
				items: [{
					boxLabel: '<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
					name: 'rdoSelect1',
					inputValue: 'N',
					width: 80
				}, {
					boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>',
					name: 'rdoSelect1',
					inputValue: 'Y',
					width: 50,
					checked: true			//20200414 수정: 포함으로 변경 후 hidden
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
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
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
		}), {
			xtype: 'container',
			layout: {type: 'uniTable', columns: 2},
			items:[{
					fieldLabel: '<t:message code="system.label.sales.issueno" default="출고번호"/>',
					xtype: 'uniTextfield',
					name: 'INOUT_NUM_FR',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('INOUT_NUM_FR', newValue);
						}
					}
				},{
					fieldLabel: '~',
					xtype: 'uniTextfield',
					name: 'INOUT_NUM_TO',
					labelWidth: 12,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('INOUT_NUM_TO', newValue);
						}
					}
				}
			]
		},{
			fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'  ,
			name: 'TXT_INOUT_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B024',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXT_INOUT_PRSN', newValue);
				}
			}
		},
			Unilite.popup('DIV_PUMOK', {
			fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
			validateBlank: false,
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
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
			Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName:'PROJECT_NO',
				textFieldName:'PROJECT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
				textFieldOnly: false,
				listeners: {
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
				})
		, {
			fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',name: 'TXT_WH_CODE',
			xtype: 'uniCombobox',
			comboType: 'O',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXT_WH_CODE', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_FR',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_TO',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		},{	//20200414 추가: 조회조건 국/내외구분
			fieldLabel	: ' ',
			xtype		: 'radiogroup',
			itemId		: 'NATION_INOUT',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.domestic" default="국내"/>',
				name		: 'NATION_INOUT',
				inputValue	: '1',
				width		: 80
			},{
				boxLabel	: '<t:message code="system.label.sales.foreign" default="해외"/>',
				name		: 'NATION_INOUT',
				inputValue	: '2',
				width		: 80
			}],
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('NATION_INOUT', newValue.NATION_INOUT);
//					if(newValue.NATION_INOUT == '1') {
//						panelSearch.setValue('rdoSelect1', 'N');
//					} else {
//						panelSearch.setValue('rdoSelect1', 'Y');
//					}
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('ssa200skrvGrid1', {
		// for tab
		region:'center',
		layout: 'fit',
		store: directMasterStore1,
		uniOpt : {
			dblClickToEdit		: false
		},
		tbar:[{xtype:'uniNumberfield',
				labelWidth: 110,
				fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
				itemId:'selectionSummary',
				readOnly: true,
				value:0,
				decimalPrecision:4,
				format:'0,000.0000'}],
		features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id: 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		columns: [
			{ dataIndex: 'SALE_DIV_CODE'				,						width: 100, locked: true},
			{ dataIndex: 'INOUT_CODE'				,						width: 93, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
			}},
			{ dataIndex: 'INOUT_NAME'		, width: 133, locked: true },
			{ dataIndex: 'INOUT_DATE'		, width: 80, locked: true },
			{ dataIndex: 'ITEM_CODE'		, width: 80, locked: true },
			{ dataIndex: 'ITEM_NAME'		, width: 133, locked: true },
			{ dataIndex: 'ITEM_NAME1'		, width: 133, locked: true, hidden: true },
			{ dataIndex: 'SPEC'				, width: 120 },
			{ dataIndex: 'TRNS_RATE'		, width: 73, align: 'right' },
			{ dataIndex: 'ORDER_UNIT'		, width: 66, align: 'center' },
			{ dataIndex: 'ORDER_UNIT_Q'		, width: 106, summaryType: 'sum' },
			{ dataIndex: 'ACCOUNT_Q'		, width: 106, summaryType: 'sum' },
			{ dataIndex: 'NO_ACCOUNT'		, width: 106, summaryType: 'sum' },
			{ dataIndex: 'INOUT_TYPE_DETAIL', width: 106 },
			{ dataIndex: 'INOUT_CODE_TYPE'	, width: 53, hidden: true },
			{ dataIndex: 'DOM_FORIGN'		, width: 80,align: 'center' },
			{ dataIndex: 'ACCOUNT_YNC'		, width: 66,align: 'center' },
			{ dataIndex: 'WH_CODE'			, width: 80 },
			{ dataIndex: 'INOUT_PRSN'		, width: 80 },
			{ dataIndex: 'ISSUE_REQ_DATE'	, width: 80 },
			{ dataIndex: 'ISSUE_REQ_NUM'	, width: 100 },
			{ dataIndex: 'ORDER_NUM'		, width: 100 },
			{ dataIndex: 'DVRY_DATE'		, width: 80 },
			{ dataIndex: 'LC_NUM'			, width: 100 },
			{ dataIndex: 'INOUT_NUM'		, width: 100 },
			{ dataIndex: 'INOUT_SEQ'		, width: 80, align: 'center' },
			{ dataIndex: 'PROJECT_NO'		, width: 100 },
			{ dataIndex: 'INOUT_METH'		, width: 80, hidden: true },
			{ dataIndex: 'SORT_KEY'			, width: 80, hidden: true },
			//20191030 추가: ORDER_UNIT_P, ORDER_UNIT_O
			{ dataIndex: 'ORDER_UNIT_P'		, width: 106, summaryType: 'sum' },
			{ dataIndex: 'ORDER_UNIT_O'		, width: 106, summaryType: 'sum' }
		],
		listeners:{
			selectionchange:function( grid, selection, eOpts )	{
				if(selection && selection.startCell)	{
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
						if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{

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
			}
		 }
	});



	Unilite.Main({
		id: 'ssa200skrvApp',
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
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('INOUT_DATE_TO')));
			panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('INOUT_DATE_TO')));
			//20200414 추가: 조회조건 국/내외구분
			panelSearch.getField('NATION_INOUT').setValue('1');
			panelResult.getField('NATION_INOUT').setValue('1');
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid.getStore().loadData({});
			directMasterStore1.loadStoreRecords();
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
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

