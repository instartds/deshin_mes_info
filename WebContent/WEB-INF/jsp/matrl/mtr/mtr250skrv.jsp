<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mtr250skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 출고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B005" opts= '1;2;3' /> <!-- 출고처구분 -->
	<t:ExtComboStore comboType="AU" comboCode="M104" /> <!-- 출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 (O) -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Mtr250skrvModel', {
		fields: [
			{name: 'INDEX01'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'INDEX02'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'INDEX03'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'INOUT_DATE'				, text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'		, type: 'uniDate'},
			{name: 'INDEX04'				, text: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>'	, type: 'string'},
			{name: 'INDEX05'				, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'		, type: 'string'},
			{name: 'INDEX06'				, text: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>'		, type: 'string'},
			{name: 'INOUT_Q'				, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'		, type: 'uniQty'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>'		, type: 'string'},
			{name: 'INOUT_PRSN'				, text: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>'		, type: 'string'},
			{name: 'INOUT_METH'				, text: '<t:message code="system.label.purchase.issuemethod" default="출고방법"/>'		, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text: '<t:message code="system.label.purchase.issuetype" default="출고유형"/>'		, type: 'string'},
			{name: 'CREATE_LOC'				, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'		, type: 'string'},
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'		, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'},
			{name: 'INOUT_CAL_P'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'			, type: 'uniUnitPrice'},
			{name: 'INOUT_I'				, text: '<t:message code="system.label.purchase.amount" default="금액"/>'			, type: 'uniPrice'},
			{name: 'EVAL_INOUT_P'			, text: '<t:message code="system.label.purchase.averageprice" default="평균단가"/>'		, type: 'uniUnitPrice'},
			{name: 'LOT_NO'					, text: 'LOT NO'		, type: 'string'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'	, type: 'string'},
			{name: 'INSERT_DB_USER'			, text: '<t:message code="system.label.purchase.accntperson" default="입력자"/>'		, type: 'string'},
			{name: 'INSERT_DB_TIME'			, text: '<t:message code="system.label.purchase.inputdate" default="입력일"/>'		, type: 'uniDate'},
			{name: 'UPDATE_DB_USER'			, text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'		, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '<t:message code="system.label.purchase.updatedate" default="수정일"/>'		, type: 'uniDate'},
			{name: 'INOUT_SEQ'				, text: 'INOUT_SEQ'		, type: 'string'},
			{name: 'MAKE_DATE'				, text: '<t:message code="system.label.purchase.makedate" default="제조일자"/>'						, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'			, text: '<t:message code="system.label.purchase.expirationdate" default="유효기한"/>'		, type: 'uniDate'},
			{name: 'TOP_ITEM_CODE'			, text: '<t:message code="system.label.purchase.topitemcode" default="대표제품코드"/>'		, type: 'string'},
			{name: 'TOP_ITEM_NAME'			, text: '<t:message code="system.label.purchase.topitemname" default="대표제품명"/>'		, type: 'string'},
			{name: 'TOP_LOT_NO'				, text: '<t:message code="system.label.purchase.toplotno" default="대표제품lot_no"/>'		, type: 'string'},
			{name: 'WKORD_NUM'			  , text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'	   , type: 'string'},
			{name: 'PRODT_SPEC'				, text: '<t:message code="system.label.purchase.representationitemspec" default="대표품목 규격"/>'			, type: 'string'}
		]
	});//End of Unilite.defineModel('Mtr250skrvModel', {
	Unilite.defineModel('Mtr250skrvModel2', {
		fields: [
			{name: 'INDEX01'				, text: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>'	, type: 'string'},
			{name: 'INDEX02'				, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'		, type: 'string'},
			{name: 'INDEX03'				, text: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>'		, type: 'string'},
			{name: 'INOUT_DATE'				, text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'		, type: 'uniDate'},
			{name: 'INDEX04'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'INDEX05'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'INDEX06'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'INOUT_Q'				, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'		, type: 'uniQty'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>'		, type: 'string'},
			{name: 'INOUT_PRSN'				, text: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>'		, type: 'string'},
			{name: 'INOUT_METH'				, text: '<t:message code="system.label.purchase.issuemethod" default="출고방법"/>'		, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text: '<t:message code="system.label.purchase.issuetype" default="출고유형"/>'		, type: 'string'},
			{name: 'CREATE_LOC'				, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'		, type: 'string'},
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'		, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'},
			{name: 'INOUT_CAL_P'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'			, type: 'uniUnitPrice'},
			{name: 'INOUT_I'				, text: '<t:message code="system.label.purchase.amount" default="금액"/>'			, type: 'uniPrice'},
			{name: 'LOT_NO'					, text: 'LOT NO'		, type: 'string'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'	, type: 'string'},
			{name: 'INSERT_DB_USER'			, text: '<t:message code="system.label.purchase.accntperson" default="입력자"/>'		, type: 'string'},
			{name: 'INSERT_DB_TIME'			, text: '<t:message code="system.label.purchase.inputdate" default="입력일"/>'		, type: 'uniDate'},
			{name: 'UPDATE_DB_USER'			, text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'		, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '<t:message code="system.label.purchase.updatedate" default="수정일"/>'		, type: 'uniDate'},
			{name: 'INOUT_SEQ'				, text: 'INOUT_SEQ'		, type: 'string'},
			{name: 'MAKE_DATE'				, text: '<t:message code="system.label.purchase.makedate" default="제조일자"/>'						, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'				, text: '<t:message code="system.label.purchase.expirationdate" default="유효기한"/>'		, type: 'uniDate'},
			{name: 'TOP_ITEM_CODE'			, text: '<t:message code="system.label.purchase.topitemcode" default="대표제품코드"/>'		, type: 'string'},
			{name: 'TOP_ITEM_NAME'			, text: '<t:message code="system.label.purchase.topitemname" default="대표제품명"/>'		, type: 'string'},
			{name: 'TOP_LOT_NO'				, text: '<t:message code="system.label.purchase.toplotno" default="대표제품lot_no"/>'		, type: 'string'},
			{name: 'WKORD_NUM'			  , text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'	   , type: 'string'},
			{name: 'PRODT_SPEC'				, text: '<t:message code="system.label.purchase.representationitemspec" default="대표품목 규격"/>'			, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mtr250skrvMasterStore1',{
		model: 'Mtr250skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'mtr250skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log("param:", param );
			param.QUERY_TYPE='1';
			panelResult.setValue('INOUT_NUMS','');
			this.load({
				params: param
		});
		},
		groupField: 'INDEX01'
	});//End of var directMasterStore1 = Unilite.createStore('mtr250skrvMasterStore1',{
	var directMasterStore2 = Unilite.createStore('mtr250skrvMasterStore2',{
		model: 'Mtr250skrvModel2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'mtr250skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			param.QUERY_TYPE='2';
			panelResult.setValue('INOUT_NUMS','');
			this.load({
				params: param
		});
		},
		groupField: 'INDEX03'
	});//End of var directMasterStore1 = Unilite.createStore('mtr250skrvMasterStore1',{

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed:true,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				child:'WH_CODE',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						//var field = masterForm.getField('ORDER_PRSN');
						//field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						//var field2 = masterForm.getField('WH_CODE');
						//field2.getStore().clearFilter(true);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_FR_DATE',
				endFieldName: 'INOUT_TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_FR_DATE',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_TO_DATE',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',
				name: 'INOUT_CODE_TYPE',
				xtype: 'uniCombobox',
				value:'3',
				comboType: 'AU',
				multiSelect: true,
				comboCode: 'B005',
				listeners: {
					change:function(combo, newValue, oldValue, eOpts){
						panelResult.setValue('INOUT_CODE_TYPE', newValue);
						if(newValue==null||newValue=="") {
							panelSearch.setValue("MUTISELECT_YN",'N');
							panelSearch.setValue("INOUT_CODE","");
							panelSearch.setValue("INOUT_NAME","");
						}else{
							if (newValue.length > 1){
								panelSearch.setValue("MUTISELECT_YN",'Y');
								Ext.getCmp("DEPT").show();
								Ext.getCmp("DEPT").disable();
								Ext.getCmp("DEPT1").show();
								Ext.getCmp("DEPT1").disable();
	
								Ext.getCmp("WAREHOUSE").hide();
								Ext.getCmp("WAREHOUSE").disable();
								Ext.getCmp("WAREHOUSE1").hide();
								Ext.getCmp("WAREHOUSE1").disable();
	
								Ext.getCmp("WORK_SHOP").hide();
								Ext.getCmp("WORK_SHOP").disable();
								Ext.getCmp("WORK_SHOP1").hide();
								Ext.getCmp("WORK_SHOP1").disable();							
							}else{	
								panelSearch.setValue("MUTISELECT_YN",'N');
								if(newValue=="1"){
									Ext.getCmp("DEPT").show();
									Ext.getCmp("DEPT").enable();
									Ext.getCmp("DEPT1").show();
									Ext.getCmp("DEPT1").enable();
	
									Ext.getCmp("WAREHOUSE").hide();
									Ext.getCmp("WAREHOUSE").disable();
									Ext.getCmp("WAREHOUSE1").hide();
									Ext.getCmp("WAREHOUSE1").disable();
	
									Ext.getCmp("WORK_SHOP").hide();
									Ext.getCmp("WORK_SHOP").disable();
									Ext.getCmp("WORK_SHOP1").hide();
									Ext.getCmp("WORK_SHOP1").disable();
	
								} else if(newValue=="2") {
									Ext.getCmp("WAREHOUSE").show();
									Ext.getCmp("WAREHOUSE").enable();
									Ext.getCmp("WAREHOUSE1").show();
									Ext.getCmp("WAREHOUSE1").enable();
	
									Ext.getCmp("DEPT").hide();
									Ext.getCmp("DEPT").disable();
									Ext.getCmp("DEPT1").hide();
									Ext.getCmp("DEPT1").disable();
	
									Ext.getCmp("WORK_SHOP").hide();
									Ext.getCmp("WORK_SHOP").disable();
									Ext.getCmp("WORK_SHOP1").hide();
									Ext.getCmp("WORK_SHOP1").disable();
	
								} else if(newValue=="3") {
									Ext.getCmp("WORK_SHOP").show();
									Ext.getCmp("WORK_SHOP").enable();
									Ext.getCmp("WORK_SHOP1").show();
									Ext.getCmp("WORK_SHOP1").enable();
	
									Ext.getCmp("WAREHOUSE").hide();
									Ext.getCmp("WAREHOUSE").disable();
									Ext.getCmp("WAREHOUSE1").hide();
									Ext.getCmp("WAREHOUSE1").disable();
	
									Ext.getCmp("DEPT").hide();
									Ext.getCmp("DEPT").disable();
									Ext.getCmp("DEPT1").hide();
									Ext.getCmp("DEPT1").disable();
								}
							}
						}
					}
				}
			},
			Unilite.popup('DEPT',{
				fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>',
				valueFieldName: 'INOUT_CODE1',
				textFieldName: 'INOUT_NAME1',
				id:'DEPT',
//				hidden:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('INOUT_CODE1', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('INOUT_NAME1', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('WAREHOUSE',{
				fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>',
				valueFieldName: 'INOUT_CODE2',
				textFieldName: 'INOUT_NAME2',
				id:'WAREHOUSE',
//				hidden:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('INOUT_CODE2', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('INOUT_NAME2', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'TYPE_LEVEL': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('WORK_SHOP',{
				fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>',
				id:'WORK_SHOP',
				valueFieldName: 'INOUT_CODE3',
				textFieldName: 'INOUT_NAME3',
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('INOUT_CODE3', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('INOUT_NAME3', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'TYPE_LEVEL': panelSearch.getValue('DIV_CODE')});
					}
				}
			})
			,{
				fieldLabel: '<t:message code="system.label.sales.moveincludeyn" default="이동포함여부"/>',
				xtype: 'radiogroup',
				itemId:'MOVE_FLAG',
				items:[{
					boxLabel:'<t:message code="system.label.purchase.yes" default="예"/>',
					name: 'MOVE_FLAG',
					inputValue: 'Y',
					checked: true,
					width: 65
				},{
					boxLabel:'<t:message code="system.label.purchase.no" default="아니오"/>',
					name:'MOVE_FLAG',
					inputValue: 'N'
				}],
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MOVE_FLAG', newValue.MOVE_FLAG);
					}
				}
			},{
			xtype:'uniTextfield',
			fieldLabel:'신규품목코드',
			name:'MUTISELECT_YN',
			value:'N',
			hidden:true
			}
			]
		},{
			title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.issuetype" default="출고유형"/>',
				name: 'INOUT_TYPE_DETAIL',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M104',
				//20200427 추가: 멀티선택
				multiSelect: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020',
				//20200427 추가: 멀티선택
				multiSelect: true
			},
			Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('ITEM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('ITEM_CODE', '');
									}
								},
								applyextparam: function(popup){
									popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE'),'FIND_TYPE':'00'});
								}
						}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'ITEM_LEVEL2'
			},{
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'ITEM_LEVEL3'
			},{
				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store')
			},
			Unilite.popup('WKORD_NUM',{
					fieldLabel: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>',
					textFieldName:'WKORD_NUM',
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							popup.setExtParam({'WORK_SHOP_CODE': panelResult.getValue('WORK_SHOP1')});
						}
					}
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
							var labelText = invalid.items[0]['fieldLabel']+':';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
						}

						alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
						invalid.items[0].focus();
					} else {
					//	this.mask();
					}
				} else {
					this.unmask();
				}
				return r;
			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			child: 'WH_CODE',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INOUT_FR_DATE',
			endFieldName: 'INOUT_TO_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_FR_DATE',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_TO_DATE',newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
			name: 'INOUT_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B024',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INOUT_PRSN', newValue);
				}
			}
		},{   text:'<div style="color: red">라벨출력</div>',
			xtype: 'button',
			margin: '0 0 0 20',
			handler: function(){
				UniAppManager.app.onPrintButtonDown();
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',
			name: 'INOUT_CODE_TYPE',
			xtype: 'uniCombobox',
			value:'3',
			comboType: 'AU',
			multiSelect: true,
			comboCode: 'B005',
			listeners: {
				change:function(combo, newValue, oldValue, eOpts){
					panelSearch.setValue('INOUT_CODE_TYPE', newValue);	
					if(newValue==null||newValue=="") {
						panelResult.setValue("MUTISELECT_YN",'N');
						panelResult.setValue("INOUT_CODE","");
						panelResult.setValue("INOUT_NAME","");
					}else{						
							if (newValue.length > 1){
								panelSearch.setValue("MUTISELECT_YN",'Y');
								Ext.getCmp("DEPT").show();
								Ext.getCmp("DEPT").disable();
								Ext.getCmp("DEPT1").show();
								Ext.getCmp("DEPT1").disable();
	
								Ext.getCmp("WAREHOUSE").hide();
								Ext.getCmp("WAREHOUSE").disable();
								Ext.getCmp("WAREHOUSE1").hide();
								Ext.getCmp("WAREHOUSE1").disable();
	
								Ext.getCmp("WORK_SHOP").hide();
								Ext.getCmp("WORK_SHOP").disable();
								Ext.getCmp("WORK_SHOP1").hide();
								Ext.getCmp("WORK_SHOP1").disable();							
							}else{	
								panelSearch.setValue("MUTISELECT_YN",'N');
								if(newValue=="1"){
									Ext.getCmp("DEPT").show();
									Ext.getCmp("DEPT").enable();
									Ext.getCmp("DEPT1").show();
									Ext.getCmp("DEPT1").enable();
		
									Ext.getCmp("WAREHOUSE").hide();
									Ext.getCmp("WAREHOUSE").disable();
									Ext.getCmp("WAREHOUSE1").hide();
									Ext.getCmp("WAREHOUSE1").disable();
		
									Ext.getCmp("WORK_SHOP").hide();
									Ext.getCmp("WORK_SHOP").disable();
									Ext.getCmp("WORK_SHOP1").hide();
									Ext.getCmp("WORK_SHOP1").disable();
		
								} else if(newValue=="2") {
									Ext.getCmp("WAREHOUSE").show();
									Ext.getCmp("WAREHOUSE").enable();
									Ext.getCmp("WAREHOUSE1").show();
									Ext.getCmp("WAREHOUSE1").enable();
		
									Ext.getCmp("DEPT").hide();
									Ext.getCmp("DEPT").disable();
									Ext.getCmp("DEPT1").hide();
									Ext.getCmp("DEPT1").disable();
		
									Ext.getCmp("WORK_SHOP").hide();
									Ext.getCmp("WORK_SHOP").disable();
									Ext.getCmp("WORK_SHOP1").hide();
									Ext.getCmp("WORK_SHOP1").disable();
		
								} else if(newValue=="3") {
									Ext.getCmp("WORK_SHOP").show();
									Ext.getCmp("WORK_SHOP").enable();
									Ext.getCmp("WORK_SHOP1").show();
									Ext.getCmp("WORK_SHOP1").enable();
		
									Ext.getCmp("WAREHOUSE").hide();
									Ext.getCmp("WAREHOUSE").disable();
									Ext.getCmp("WAREHOUSE1").hide();
									Ext.getCmp("WAREHOUSE1").disable();
		
									Ext.getCmp("DEPT").hide();
									Ext.getCmp("DEPT").disable();
									Ext.getCmp("DEPT1").hide();
									Ext.getCmp("DEPT1").disable();
								}
						
						}
					}
				}
			}
		},
		Unilite.popup('DEPT',{
			fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>',
			valueFieldName: 'INOUT_CODE1',
			textFieldName: 'INOUT_NAME1',
			id:'DEPT1',
//			hidden:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('INOUT_CODE1', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('INOUT_NAME1', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('WAREHOUSE',{
			fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>',
			valueFieldName: 'INOUT_CODE2',
			textFieldName: 'INOUT_NAME2',
			id:'WAREHOUSE1',
//			hidden:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('INOUT_CODE2', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('INOUT_NAME2', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'TYPE_LEVEL': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('WORK_SHOP',{
			fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>',
			id:'WORK_SHOP1',
			valueFieldName: 'INOUT_CODE3',
			textFieldName: 'INOUT_NAME3',
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('INOUT_CODE3', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('INOUT_NAME3', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'TYPE_LEVEL': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel: 'INOUT_NUMS',
			xtype: 'uniTextfield',
			name:'INOUT_NUMS',
			readOnly: true,
			hidden:true
		}
		, {
				fieldLabel: '<t:message code="system.label.sales.moveincludeyn" default="이동포함여부"/>',
				xtype: 'radiogroup',
				itemId:'MOVE_FLAG',
				items:[{
					boxLabel:'<t:message code="system.label.purchase.yes" default="예"/>',
					name: 'MOVE_FLAG',
					inputValue: 'Y',
					checked: true,
					width: 65
				},{
					boxLabel:'<t:message code="system.label.purchase.no" default="아니오"/>',
					name:'MOVE_FLAG',
					inputValue: 'N'
				}],
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('MOVE_FLAG', newValue.MOVE_FLAG);
					}
				}
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
							var labelText = invalid.items[0]['fieldLabel']+':';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
						}

						alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
						invalid.items[0].focus();
					} else {
					//	this.mask();
					}
				} else {
					this.unmask();
				}
				return r;
			}
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('mtr250skrvGrid1', {
		// for tab
		layout: 'fit',
		region:'center',
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst : false,
			//20191205 필터기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		store: directMasterStore1,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(Ext.isEmpty(selectRecord)){
						UniAppManager.setToolbarButtons(['print'], false);
					}else{
						UniAppManager.setToolbarButtons(['print'], true);
					}
					if(Ext.isEmpty(panelResult.getValue('INOUT_NUMS'))) {
						panelResult.setValue('INOUT_NUMS', selectRecord.get('INOUT_NUM') + selectRecord.get('INOUT_SEQ'));
					} else {
						var receiptNums = panelResult.getValue('INOUT_NUMS');
						receiptNums = receiptNums + ',' + selectRecord.get('INOUT_NUM') + selectRecord.get('INOUT_SEQ');
						panelResult.setValue('INOUT_NUMS', receiptNums);
					}

				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var selectedDetails = masterGrid.getSelectedRecords();
					if(Ext.isEmpty(selectedDetails)){
						UniAppManager.setToolbarButtons(['print'], false);
					}else{
						UniAppManager.setToolbarButtons(['print'], true);
					}

					var receiptNums	 = panelResult.getValue('INOUT_NUMS');
					var deselectedNum0  = selectRecord.get('INOUT_NUM') + selectRecord.get('INOUT_SEQ') + ',';
					var deselectedNum1  = ',' + selectRecord.get('INOUT_NUM') + selectRecord.get('INOUT_SEQ');
					var deselectedNum2  = selectRecord.get('INOUT_NUM') + selectRecord.get('INOUT_SEQ');

					receiptNums = receiptNums.split(deselectedNum0).join("");
					receiptNums = receiptNums.split(deselectedNum1).join("");
					receiptNums = receiptNums.split(deselectedNum2).join("");
					panelResult.setValue('INOUT_NUMS', receiptNums);

				}
			}
		}),
		columns: [
			{dataIndex: 'INDEX01'				, width: 120, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.itemtotal" default="품목계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
			}},
			{dataIndex: 'INDEX02'				, width: 146, locked: false},
			{dataIndex: 'INDEX03'				, width: 146},
			{dataIndex: 'INOUT_DATE'			, width: 86},
			{dataIndex: 'INDEX04'				, width: 86},
			{dataIndex: 'INDEX05'				, width: 66, hidden: true},
			{dataIndex: 'INDEX06'				, width: 133},
			{dataIndex: 'INOUT_Q'				, width: 120, summaryType: 'sum' },
			{dataIndex: 'STOCK_UNIT'			, width: 66},
			{dataIndex: 'WH_CODE'				, width: 106},
			{dataIndex: 'INOUT_PRSN'			, width: 66},
			{dataIndex: 'INOUT_METH'			, width: 66},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 66},
			{dataIndex: 'CREATE_LOC'			, width: 66},
			{dataIndex: 'INOUT_NUM'				, width: 113},
			{dataIndex: 'DIV_CODE'				, width: 106, hidden: true},
			{dataIndex: 'INOUT_CAL_P'			, width: 100},
			{dataIndex: 'INOUT_I'				, width: 100, summaryType: 'sum'},			
			{dataIndex: 'LOT_NO'				, width: 100},
			{dataIndex: 'MAKE_DATE'			, width: 86},
			{dataIndex: 'MAKE_EXP_DATE'	, width: 86},
			{dataIndex: 'TOP_ITEM_CODE'	, width: 100},
			{dataIndex: 'TOP_ITEM_NAME'	, width: 200},
			{dataIndex: 'TOP_LOT_NO'	, width: 100, align:'center'},
			{dataIndex: 'PRODT_SPEC'	, width: 150, align:'center'},
			{dataIndex: 'REMARK' 				, width: 133},
			{dataIndex: 'PROJECT_NO'			, width: 100},
			{dataIndex: 'WKORD_NUM'			 , width: 100},
			{dataIndex: 'INSERT_DB_USER'		, width: 100},
			{dataIndex: 'INSERT_DB_TIME'		, width: 133},
			{dataIndex: 'UPDATE_DB_USER'		, width: 100},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 133},
			{dataIndex: 'INOUT_SEQ'		, width: 50}
		]
	});//End of var masterGrid = Unilite.createGrid('mtr250skrvGrid1', {
	var masterGrid2 = Unilite.createGrid('mtr250skrvGrid2', {
		// for tab
		layout: 'fit',
		region:'center',
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			//20191205 필터기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(Ext.isEmpty(selectRecord)){
						UniAppManager.setToolbarButtons(['print'], false);
					}else{
						UniAppManager.setToolbarButtons(['print'], true);
					}
					if(Ext.isEmpty(panelResult.getValue('INOUT_NUMS'))) {
						panelResult.setValue('INOUT_NUMS', selectRecord.get('INOUT_NUM') + selectRecord.get('INOUT_SEQ'));
					} else {
						var receiptNums = panelResult.getValue('INOUT_NUMS');
						receiptNums = receiptNums + ',' + selectRecord.get('INOUT_NUM') + selectRecord.get('INOUT_SEQ');
						panelResult.setValue('INOUT_NUMS', receiptNums);
					}

				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var selectedDetails = masterGrid.getSelectedRecords();
					if(Ext.isEmpty(selectedDetails)){
						UniAppManager.setToolbarButtons(['print'], false);
					}else{
						UniAppManager.setToolbarButtons(['print'], true);
					}

					var receiptNums	 = panelResult.getValue('INOUT_NUMS');
					var deselectedNum0  = selectRecord.get('INOUT_NUM') + selectRecord.get('INOUT_SEQ') + ',';
					var deselectedNum1  = ',' + selectRecord.get('INOUT_NUM') + selectRecord.get('INOUT_SEQ');
					var deselectedNum2  = selectRecord.get('INOUT_NUM') + selectRecord.get('INOUT_SEQ');

					receiptNums = receiptNums.split(deselectedNum0).join("");
					receiptNums = receiptNums.split(deselectedNum1).join("");
					receiptNums = receiptNums.split(deselectedNum2).join("");
					panelResult.setValue('INOUT_NUMS', receiptNums);

				}
			}
		}),
		store: directMasterStore2,
		columns: [
			{dataIndex: 'INDEX01'				, width: 120, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.itemtotal" default="품목계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
			}},
			{dataIndex: 'INDEX02'				, width: 146, hidden: true},
			{dataIndex: 'INDEX03'				, width: 146,locked: false},
			{dataIndex: 'INOUT_DATE'			, width: 86},
			{dataIndex: 'INDEX04'				, width: 86},
			{dataIndex: 'INDEX05'				, width: 66},
			{dataIndex: 'INDEX06'				, width: 133},
			{dataIndex: 'INOUT_Q'				, width: 120, summaryType: 'sum' },
			{dataIndex: 'STOCK_UNIT'			, width: 66},
			{dataIndex: 'WH_CODE'				, width: 106},
			{dataIndex: 'INOUT_PRSN'			, width: 66},
			{dataIndex: 'INOUT_METH'			, width: 66},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 66},
			{dataIndex: 'CREATE_LOC'			, width: 66},
			{dataIndex: 'INOUT_NUM'				, width: 113},
			{dataIndex: 'DIV_CODE'				, width: 106, hidden: true},
			{dataIndex: 'INOUT_CAL_P'			, width: 100},
			{dataIndex: 'INOUT_I'				, width: 100},
			{dataIndex: 'LOT_NO'				, width: 100, hidden: true},
			{dataIndex: 'MAKE_DATE'			, width: 86},
			{dataIndex: 'MAKE_EXP_DATE'	, width: 86},
			{dataIndex: 'REMARK' 				, width: 133},
			{dataIndex: 'TOP_ITEM_CODE'	, width: 100},
			{dataIndex: 'TOP_ITEM_NAME'	, width: 200},
			{dataIndex: 'TOP_LOT_NO'	, width: 100, align:'center'},
			{dataIndex: 'PRODT_SPEC'	, width: 150, align:'center'},
			{dataIndex: 'PROJECT_NO'			, width: 100},
			{dataIndex: 'WKORD_NUM'			 , width: 100},
			{dataIndex: 'INSERT_DB_USER'		, width: 100},
			{dataIndex: 'INSERT_DB_TIME'		, width: 133},
			{dataIndex: 'UPDATE_DB_USER'		, width: 100},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 133},
			{dataIndex: 'INOUT_SEQ'		, width: 50}
		]
	});

	//创建标签页面板
	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab: 0,
		region: 'center',
		items: [
				 {
					 title: '<t:message code="system.label.purchase.itemby" default="품목별"/>'
					 ,xtype:'container'
					 ,layout:{type:'vbox', align:'stretch'}
					 ,items:[masterGrid]
					 ,id: 'mtr250skrvGridTab'
				 },
				 {
					 title: '<t:message code="system.label.purchase.byissueplace" default="출고처별"/>'
					 ,xtype:'container'
					 ,layout:{type:'vbox', align:'stretch'}
					 ,items:[masterGrid2]
					 ,id: 'mtr250skrvGridTab2'
				 }
		],
		listeners:  {
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
				console.log("newCard:  " + newCard.getId());
				console.log("oldCard:  " + oldCard.getId());
				//탭 넘길때마다 초기화
				UniAppManager.setToolbarButtons(['save', 'newData' ], false);
				panelResult.setAllFieldsReadOnly(false);
				masterGrid.getStore().loadStoreRecords();
				masterGrid2.getStore().loadStoreRecords();
//			  Ext.getCmp('confirm_check').hide(); //확정버튼 hidden

			}
		}
	});

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
			panelSearch
		],
		id: 'mtr250skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INOUT_TO_DATE', UniDate.get('today'));
			panelSearch.setValue('INOUT_FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('INOUT_TO_DATE')));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('INOUT_TO_DATE', UniDate.get('today'));
			panelResult.setValue('INOUT_FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('INOUT_TO_DATE')));
			
			panelSearch.setValue('INOUT_CODE_TYPE', '3');
			panelResult.setValue('INOUT_CODE_TYPE', '3');
			
			Ext.getCmp("DEPT").hide();
			Ext.getCmp("DEPT").disable();
			Ext.getCmp("DEPT1").hide();
			Ext.getCmp("DEPT1").disable();

			Ext.getCmp("WAREHOUSE").hide();
			Ext.getCmp("WAREHOUSE").disable();
			Ext.getCmp("WAREHOUSE1").hide();
			Ext.getCmp("WAREHOUSE1").disable();

			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset', false);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},		
		onQueryButtonDown: function(){
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 'mtr250skrvGridTab'){
					 masterGrid.getStore().loadStoreRecords();
				}
				if(activeTabId == 'mtr250skrvGridTab2' ){
					 masterGrid2.getStore().loadStoreRecords();
				}

			}
			UniAppManager.setToolbarButtons('reset', true)
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		},
		onPrintButtonDown: function(){

			var param = panelResult.getValues();
			var activeTabId = tab.getActiveTab().getId();
			var selectedDetails ;
			if(activeTabId == 'mtr250skrvGridTab'){
				 selectedDetails = masterGrid.getSelectedRecords();
			}else if(activeTabId == 'mtr250skrvGridTab2' ){
				 selectedDetails = masterGrid2.getSelectedRecords();
			}
			if(Ext.isEmpty(selectedDetails)){
				alert('<t:message code="system.message.purchase.message096" default="선택한 내역이 존재하지 않습니다."/>');
				return false;
			}
			param.PGM_ID= PGM_ID;
			param.MAIN_CODE= 'M030';

			var win = Ext.create('widget.ClipReport', {
			url: CPATH+'/mtr/mtr250clskrv.do',
			prgID: 'mtr250skrv',
			extParam: param
			});
			win.center();
			win.show();
		}
/*		onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});//End of Unilite.Main( {
};
</script>