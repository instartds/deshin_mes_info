<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv360skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="biv360skrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 				<!-- 수불타입 -->
	<t:ExtComboStore comboType="O" storeId="whList" /> 					<!-- 창고(전체) -->
	<t:ExtComboStore comboType="AU" comboCode="B036" />					<!-- 수불방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B031" />					<!-- 생성경로 -->
	<t:ExtComboStore comboType="AU" comboCode="B005" />					<!-- 수불처유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B035" />					<!-- 수불타입 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<script type="text/javascript" >

var gsLinkFlag = '';

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Biv360skrvModel', {
		fields: [
			{name: 'COMP_CODE',				text:'<t:message code="system.label.inventory.companycode" default="법인코드"/>',	type:'string'},
			{name: 'DIV_CODE',				text:'<t:message code="system.label.inventory.division" default="사업장"/>',		type:'string'},
			{name: 'COMMON_CODE',			text:'계정',		type:'string', comboType:'AU', comboCode:'B020'},
			{name: 'COMMON_NAME',			text:'계정',		type:'string'},
			{name: 'ITEM_CODE',				text:'<t:message code="system.label.inventory.item" default="품목"/>',	type:'string'},
			{name: 'ITEM_NAME',				text:'품명',		type:'string'},
			{name: 'SPEC',					text:'<t:message code="system.label.inventory.spec" default="규격"/>',		type:'string'},
			{name: 'STOCK_UNIT',			text:'단위',		type:'string'},
			{name: 'STOCK_P',				text:'재고단가',	type:'uniUnitPrice'},
			{name: 'INOUT_DATE',			text:'수불일',		type:'uniDate'},
			{name: 'ITEM_STATUS',			text:'품목상태코드',	type:'string'},
			{name: 'ITEM_STATUS_NAME',		text:'품목상태',	type:'string'},
			{name: 'INOUT_TYPE',			text:'수불타입코드',	type:'string'},
			{name: 'INOUT_TYPE_NAME',		text:'수불타입',	type:'string'},
			{name: 'BASIS_Q',				text:'기초',		type:'uniQty'},
			{name: 'IN_Q',					text:'입고',		type:'uniQty'},
			{name: 'OUT_Q',					text:'출고',		type:'uniQty'},
			{name: 'RTN_Q',					text:'반품',		type:'uniQty'},
			{name: 'STOCK_Q',				text:'재고',		type:'uniQty'},
			{name: 'BASIS_I',				text:'기초',		type:'uniPrice'},
			{name: 'IN_I',					text:'입고',		type:'uniPrice'},
			{name: 'OUT_I',					text:'출고',		type:'uniPrice'},
			{name: 'RTN_I',					text:'반품',		type:'uniPrice'},
			{name: 'STOCK_I',				text:'재고',		type:'uniPrice'},
			{name: 'INOUT_TYPE_DETAIL',		text:'유형코드',	type:'string'},
			{name: 'INOUT_TYPE_DETAIL_NAME',text:'유형',		type:'string'},
			{name: 'INOUT_METH',			text:'방법코드',	type:'string'},
			{name: 'INOUT_METH_NAME',		text:'방법',		type:'string'},
			{name: 'WH_CODE',				text:'<t:message code="system.label.inventory.warehouse" default="창고"/>',	type:'string'},
			{name: 'WH_NAME',				text:'<t:message code="system.label.inventory.warehouse" default="창고"/>',		type:'string'},
			{name: 'CREATE_LOC',			text:'생성',		type:'string'},
			{name: 'CREATE_LOC_NAME',		text:'생성',		type:'string'},
			{name: 'INOUT_CODE_TYPE',		text:'수불코드',	type:'string'},
			{name: 'INOUT_CODE_TYPE_NAME',	text:'수불처',		type:'string'},
			{name: 'INOUT_CODE',			text:'수불코드',	type:'string'},
			{name: 'INOUT_CODE_NAME',		text:'수불처명',	type:'string'},
			{name: 'UPDATE_DB_TIME',		text:'저장시간',	type:'uniDate'},
			{name: 'ORDER_TYPE' ,			text:'ORDER_TYPE',	type:'string'},
			{name: 'ORDER_TYPE_NAME',		text:'ORDER_T_NAME',type:'string'},
			{name: 'ORDER_UNIT',			text:'단위',		type:'string'},
			{name: 'ORDER_UNIT_P',			text:'단가',		type:'uniUnitPrice'},
			{name: 'ORDER_UNIT_Q',			text:'수량',		type:'uniQty'},
			{name: 'ORDER_UNIT_O',			text:'금액',		type:'uniPrice'},
			{name: 'TRNS_RATE',				text:'입수',		type:'string'},
			{name: 'INOUT_PRSN',			text:'담당자코드',	type:'string'},
			{name: 'INOUT_PRSN_NAME',		text:'담당자명',	type:'string'},
			{name: 'INOUT_NUM',				text:'수불번호',	type:'string'},
			{name: 'INOUT_SEQ',				text:'수불순번',	type:'string'},
			{name: 'PROJECT_NO',			text:'프로젝트번호',	type:'string'},
			{name: 'LOT_NO',				text:'<t:message code="system.label.inventory.lotno" default="LOT번호"/>',		type:'string'},
			{name: 'SORT_WH_CODE',			text:'',		type:'string'},
			{name: 'SORT_FLD',				text:'',		type:'string'},
			{name: 'REMARK',				text:'비고',		type:'string'},
			{name: 'UPDATE_DB_USER',		text:'입력자',		type:'string'}
		]
	});

	var directMasterStore1 = Unilite.createStore('biv360skrvMasterStore1',{
		model	: 'Biv360skrvModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'biv360skrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param["QRY_TYPE"] = '1'
			console.log( param );
			this.load({
				params	: param,
				callback: function(records, operation, success) {
					if(gsLinkFlag == 'Y') {
						var view		= masterGrid.getView();
						var navi		= view.getNavigationModel();
						var currRowIndex= masterGrid.store.data.items.length;
						navi.setPosition(currRowIndex -1 , 0);
						gsLinkFlag = '';
					}
				}
			});
		},
		groupField: 'COMMON_CODE'
	});

	Unilite.defineModel('Biv360skrvModel2', {
		fields: [
			{name: 'COMP_CODE',				text:'<t:message code="system.label.inventory.companycode" default="법인코드"/>',	type:'string'},
			{name: 'DIV_CODE',				text:'<t:message code="system.label.inventory.division" default="사업장"/>',		type:'string'},
			{name: 'COMMON_CODE',				text:'<t:message code="system.label.inventory.warehouse" default="창고"/>',	type:'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'COMMON_NAME',				text:'<t:message code="system.label.inventory.warehouse" default="창고"/>',		type:'string'},
			{name: 'ITEM_CODE',				text:'<t:message code="system.label.inventory.item" default="품목"/>',	type:'string'},
			{name: 'ITEM_NAME',				text:'품명',		type:'string'},
			{name: 'SPEC',					text:'<t:message code="system.label.inventory.spec" default="규격"/>',		type:'string'},
			{name: 'STOCK_UNIT',				text:'단위',		type:'string'},
			{name: 'STOCK_P',					text:'재고단가',	type:'uniUnitPrice'},
			{name: 'INOUT_DATE',				text:'수불일',		type:'uniDate'},
			{name: 'ITEM_STATUS',				text:'품목상태코드',type:'string'},
			{name: 'ITEM_STATUS_NAME',		text:'품목상태',	type:'string'},
			{name: 'INOUT_TYPE',				text:'수불타입코드',type:'string'},
			{name: 'INOUT_TYPE_NAME',		text:'수불타입',	type:'string'},
			{name: 'BASIS_Q',					text:'기초',		type:'uniQty'},
			{name: 'IN_Q',					text:'입고',		type:'uniQty'},
			{name: 'OUT_Q',					text:'출고',		type:'uniQty'},
			{name: 'RTN_Q',					text:'반품',		type:'uniQty'},
			{name: 'STOCK_Q',					text:'재고',		type:'uniQty'},
			{name: 'BASIS_I',					text:'기초',		type:'uniPrice'},
			{name: 'IN_I',					text:'입고',		type:'uniPrice'},
			{name: 'OUT_I',					text:'출고',		type:'uniPrice'},
			{name: 'RTN_I',					text:'반품',		type:'uniPrice'},
			{name: 'STOCK_I',					text:'재고',		type:'uniPrice'},
			{name: 'INOUT_TYPE_DETAIL',			text:'유형코드',	type:'uniPrice'},
			{name: 'INOUT_TYPE_DETAIL_NAME',	text:'유형',		type:'string'},
			{name: 'INOUT_METH',				text:'방법코드',	type:'string'},
			{name: 'INOUT_METH_NAME',			text:'방법',		type:'string'},
			{name: 'ITEM_ACCOUNT',			  text:'계정코드',	type:'string'},
			{name: 'ITEM_ACCOUNT_NAME',		 text:'계정',		type:'string'},
			{name: 'CREATE_LOC',				text:'생성',		type:'string'},
			{name: 'CREATE_LOC_NAME',			text:'생성',		type:'string'},
			{name: 'INOUT_CODE_TYPE',			text:'수불코드',	type:'string'},
			{name: 'INOUT_CODE_TYPE_NAME',		text:'수불처',		type:'string'},
			{name: 'INOUT_CODE',				text:'수불코드',	type:'string'},
			{name: 'INOUT_CODE_NAME',			text:'수불처명',	type:'string'},
			{name: 'UPDATE_DB_TIME',			text:'저장시간',	type:'uniDate'},
			{name: 'ORDER_TYPE' ,				text:'ORDER_TYPE',	type:'string'},
			{name: 'ORDER_TYPE_NAME',			text:'ORDER_T_NAME',type:'string'},
			{name: 'ORDER_UNIT',				text:'단위',		type:'string'},
			{name: 'ORDER_UNIT_P',				text:'단가',		type:'uniUnitPrice'},
			{name: 'ORDER_UNIT_Q',				text:'수량',		type:'uniQty'},
			{name: 'ORDER_UNIT_O',				text:'금액',		type:'uniPrice'},
			{name: 'TRNS_RATE',					text:'입수',		type:'string'},
			{name: 'INOUT_PRSN',				text:'담당자코드',	type:'string'},
			{name: 'INOUT_PRSN_NAME',			text:'담당자명',	type:'string'},
			{name: 'INOUT_NUM',					text:'수불번호',	type:'string'},
			{name: 'INOUT_SEQ',					text:'수불순번',	type:'string'},
			{name: 'PROJECT_NO',				text:'프로젝트번호',type:'string'},
			{name: 'LOT_NO',					text:'<t:message code="system.label.inventory.lotno" default="LOT번호"/>',		type:'string'},
			{name: 'SORT_WH_CODE',				text:'',			type:'string'},
			{name: 'SORT_FLD',					text:'',			type:'string'},
			{name: 'REMARK',					text:'비고',			type:'string'},
			{name: 'UPDATE_DB_USER',			text:'입력자'		,type:'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore2 = Unilite.createStore('biv360skrvMasterStore2',{
		model: 'Biv360skrvModel2',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
				//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				   read: 'biv360skrvService.selectList'
			}
		}
		,loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param["QRY_TYPE"] = '2'
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'COMMON_NAME'
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed: true,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '기본정보',
 			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
				items: [{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					comboCode:'B001',
					child:'WH_CODE',
					allowBlank:false,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('DIV_CODE', newValue);
							}
						}
				},{
					fieldLabel: '계정',
					name:'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					multiSelect:true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('ITEM_ACCOUNT', newValue);
							}
						}
				},{
					fieldLabel: '수불일',
					xtype: 'uniDateRangefield',
					startFieldName: 'ORDER_DATE_FR',
					endFieldName: 'ORDER_DATE_TO',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					allowBlank:false,
					width:315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('ORDER_DATE_FR',newValue);

						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('ORDER_DATE_TO',newValue);
						}
					}
				},
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
//						autoPopup: true,
						validateBlank: false,
						listeners: {
							onValueFieldChange: function( elm, newValue, oldValue ) {						
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('ITEM_NAME', '');
									panelSearch.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function( elm, newValue, oldValue ) {
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('ITEM_CODE', '');
									panelSearch.setValue('ITEM_CODE', '');
								}
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				}),{
					fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
					name:'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CODE', newValue);
						}
					}
				},{
					xtype: 'radiogroup',
					fieldLabel: '조회구분',
					labelWidth: 90,
					items: [{
							boxLabel: '수불발생',
							width: 80,
							name: 'INOUT_FLAG',
							inputValue: '1',
							checked: true
						},{
							boxLabel: '전체',
							width: 80,
							name: 'INOUT_FLAG',
							inputValue: '2'
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.getField('INOUT_FLAG').setValue(newValue.INOUT_FLAG);
							}
						}
				},{
					xtype: 'radiogroup',
					fieldLabel: '이동포함여부',
					labelWidth: 90,
					items: [{
							boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
							width: 80,
							name: 'MOVE_FLAG',
							inputValue: 'Y',
							checked: true
						},{
							boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
							width: 80,
							name: 'MOVE_FLAG',
							inputValue: 'N'
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.getField('MOVE_FLAG').setValue(newValue.MOVE_FLAG);
							}
						}
				},{
					xtype: 'radiogroup',
					fieldLabel: '실사포함여부',
					labelWidth: 90,
					items: [{
							boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
							width: 80,
							name: 'EVAL_FLAG',
							inputValue: 'Y',
							checked: true
						},{
							boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
							width: 80,
							name: 'EVAL_FLAG',
							inputValue: 'N'
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.getField('EVAL_FLAG').setValue(newValue.EVAL_FLAG);
							}
						}
				}]
				},{
				title: '추가정보',
				itemId: 'search_panel2',
				layout: {type: 'uniTable', columns: 1},
				defaultType: 'uniTextfield',
					items: [
					{
						fieldLabel: '수불방법',
						name:'INOUT_METH',
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'B036'
					},{
						fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
						name: 'ITEM_LEVEL1',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('itemLeve1Store'),
						child: 'ITEM_LEVEL2'
					},{
						fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
						name: 'ITEM_LEVEL2',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('itemLeve2Store'),
						child: 'ITEM_LEVEL3'
					},{
						fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
						name: 'ITEM_LEVEL3',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('itemLeve3Store')
					},{
						xtype: 'radiogroup',
						fieldLabel: '품목상태',
						id: 'ITEM_STATUS',
						labelWidth:90,
						items : [{
							boxLabel: '전체',
							width: 60,
							name: 'ITEM_STATUS',
							inputValue: '',
							checked: true
						},{
							boxLabel: '정상',
							width: 60,
							name: 'ITEM_STATUS',
							inputValue: '1'
						},{
							boxLabel: '<t:message code="system.label.inventory.defect" default="불량"/>',
							width: 60,
							name: 'ITEM_STATUS',
							inputValue: '2'
						}]
					},{
						fieldLabel: '생성경로',
						name: 'CREATE_LOC',
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'B031'
					},{
						fieldLabel: '수불번호',
						name: 'INOUT_NUM',
						xtype: 'uniTextfield'
					},{
						fieldLabel: '수불처유형',
						name: 'INOUT_CODE_TYPE',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'B005'
					},{
						fieldLabel: 'Lot No.',
						name: 'LOT_NO',
						xtype: 'uniTextfield'
					},{
						fieldLabel: '수불타입',
						name:'INOUT_TYPE',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'B035'
					},Unilite.popup('PJT',{
						fieldLabel: '프로젝트번호',
						valueFieldName: 'PROJECT_NO',
						textFieldName: 'PROJECT_NO',
						listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('PROJECT_NO', panelSearch.getValue('PROJECT_NO'));
								},
								scope: this
							},
							onClear: function(type) {
								panelResult.setValue('PROJECT_NO', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
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
							var labelText = invalid.items[0]['fieldLabel']+' : ';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
						}

						alert(labelText+Msg.sMB083);
						invalid.items[0].focus();
					} else {
					//	this.mask();
					}
				} else {
					this.unmask();
				}
				return r;
			}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			comboCode:'B001',
			child:'WH_CODE',
			allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		},{
			fieldLabel: '계정',
			name:'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B020',
			multiSelect:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
		},{
			fieldLabel: '수불일',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false,
			width:315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelSearch.setValue('ORDER_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelSearch.setValue('ORDER_DATE_TO',newValue);
				}
			}
		},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
//				autoPopup: true,
				validateBlank: false,
				listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {						
						panelSearch.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_NAME', '');
							panelSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						panelSearch.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
		}),{
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name:'WH_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '조회구분',
			labelWidth: 90,
			items: [{
					boxLabel: '수불발생',
					width: 80,
					name: 'INOUT_FLAG',
					inputValue: '1',
					checked: true
				},{
					boxLabel: '전체',
					width: 80,
					name: 'INOUT_FLAG',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('INOUT_FLAG').setValue(newValue.INOUT_FLAG);
					}
				}
			},{
			xtype: 'radiogroup',
			fieldLabel: '이동포함여부',
			id: 'MOVE_FLAG',
			labelWidth: 90,
			items: [{
					boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
					width: 80,
					name: 'MOVE_FLAG',
					inputValue: 'Y',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
					width: 80,
					name: 'MOVE_FLAG',
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('MOVE_FLAG').setValue(newValue.MOVE_FLAG);
					}
				}
		},{
			xtype: 'radiogroup',
			fieldLabel: '실사포함여부',
			id: 'EVAL_FLAG',
			labelWidth: 90,
			items: [{
					boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
					width: 80,
					name: 'EVAL_FLAG',
					inputValue: 'Y',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
					width: 80,
					name: 'EVAL_FLAG',
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('EVAL_FLAG').setValue(newValue.EVAL_FLAG);
					}
				}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('biv360skrvGrid1', {
		region: 'center' ,
		layout : 'fit',
		store : directMasterStore1,
		uniOpt:{
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useLoadFocus		: false,		//20210311 추가: 제일 마지막행 보여주기 위해
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
//		tbar: [{
//			text:'상세보기',
//			handler: function() {
//				var record = masterGrid.getSelectedRecord();
//				if(record) {
//					openDetailWindow(record);
//				}
//			}
//		}],
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns:  [
			{dataIndex: 'COMP_CODE',	width: 0,	hidden: true},
			{dataIndex: 'DIV_CODE',		width: 0,	hidden: true},
			{dataIndex: 'COMMON_CODE',	width: 60,	locked: true},
			{dataIndex: 'COMMON_NAME',	width: 53,	hidden: true},
			{dataIndex: 'ITEM_CODE',	width: 120,	locked: true},
			{dataIndex: 'ITEM_NAME',	width: 150,	locked: true},
			{dataIndex: 'SPEC',			width: 150,	locked: true},
			{dataIndex: 'STOCK_UNIT',	width: 66,	locked: true, align:'center'},
			{
				text	: '기본정보',
				columns	: [
					{dataIndex: 'INOUT_DATE',		width: 86},
					{dataIndex: 'ITEM_STATUS_NAME',	width: 80},
					{dataIndex: 'INOUT_TYPE_NAME',	width: 80}
 				]
			},
			{dataIndex: 'STOCK_P',		width: 66,	hidden: true},//단가 유니라이트에 안보여서 히든처리
		//{dataIndex: 'INOUT_DATE', width: 86  },
			{dataIndex: 'ITEM_STATUS',	width: 0,	hidden: true},
		//{dataIndex: 'ITEM_STATUS_NAME', width: 53  }
			{dataIndex: 'INOUT_TYPE',	width: 0,	hidden: true},
		//{dataIndex: 'INOUT_TYPE_NAME', width: 66  }
			{
				text	: '재고수량',
				columns	: [
					{dataIndex: 'BASIS_Q',	width: 100, summaryType: 'sum' },
					{dataIndex: 'IN_Q',		width: 100, summaryType: 'sum' },
					{dataIndex: 'OUT_Q',	width: 100, summaryType: 'sum' },
					{dataIndex: 'RTN_Q',	width: 100, summaryType: 'sum' },
					{dataIndex: 'STOCK_Q',	width: 100, summaryType: 'sum' }
				]
			},{
				text	: '재고금액',
				columns	: [
					{dataIndex: 'BASIS_I',	width: 100, summaryType: 'sum'},
					{dataIndex: 'IN_I',		width: 100, summaryType: 'sum'},
					{dataIndex: 'OUT_I',	width: 100, summaryType: 'sum'},
					{dataIndex: 'RTN_I',	width: 100, summaryType: 'sum'},
					{dataIndex: 'STOCK_I',	width: 100, summaryType: 'sum'}
				]
			},{
				text	: '수불정보',
				columns	: [
					{dataIndex: 'INOUT_TYPE_DETAIL_NAME', width: 80},
					{dataIndex: 'INOUT_METH_NAME',		  width: 66},
					{dataIndex: 'WH_NAME',				  width: 80},
					{dataIndex: 'CREATE_LOC_NAME',		  width: 80},
					{dataIndex: 'INOUT_CODE_TYPE_NAME',   width: 80},
					{dataIndex: 'INOUT_CODE_NAME',		  width: 120},
					{dataIndex: 'UPDATE_DB_TIME',		  width: 80}
				]
			},
			{dataIndex: 'INOUT_TYPE_DETAIL',width: 0, hidden: true},
			{dataIndex: 'INOUT_METH',		width: 0, hidden: true},
			{dataIndex: 'WH_CODE',			width: 0, hidden: true},
			{dataIndex: 'CREATE_LOC',		width: 0, hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE',	width: 0, hidden: true},
			{dataIndex: 'INOUT_CODE',		width: 0, hidden: true},
			{dataIndex: 'ORDER_TYPE',		width: 0, hidden: true},
			{dataIndex: 'ORDER_TYPE_NAME',	width: 0, hidden: true},
			{
				text	: '구매/판매정보',
				columns	: [
					{dataIndex: 'ORDER_UNIT',	width: 60 , align:'center'},
					{dataIndex: 'ORDER_UNIT_P',	width: 110 },	// , summaryType: 'sum'
					{dataIndex: 'ORDER_UNIT_Q',	width: 110, summaryType: 'sum' },
					{dataIndex: 'ORDER_UNIT_O',	width: 110, summaryType: 'sum' },
					{dataIndex: 'TRNS_RATE',	width: 53 }
				]
			},{
				text	: '구매/판매정보',
				columns	: [
					{dataIndex: 'INOUT_PRSN_NAME',	width: 110},
					{dataIndex: 'INOUT_NUM',		width: 120},
					{dataIndex: 'INOUT_SEQ',		width: 66,align:'center'},
					{dataIndex: 'PROJECT_NO',		width: 120},
					{dataIndex: 'LOT_NO',			width: 120}
				]
			},
			{dataIndex: 'INOUT_PRSN',		width: 0, hidden: true},
			{dataIndex: 'SORT_WH_CODE',		width: 0, hidden: true},
			{dataIndex: 'SORT_FLD',			width: 0, hidden: true},
			{dataIndex: 'REMARK',			width: 200, hidden: false},
			{dataIndex: 'UPDATE_DB_USER',	width: 120, hidden: false}
		]
	});

	var masterGrid2 = Unilite.createGrid('biv360skrvGrid2', {
		region	: 'center' ,
		layout	: 'fit',
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
//		tbar: [{
//			text:'상세보기',
//			handler: function() {
//				var record = masterGrid.getSelectedRecord();
//				if(record) {
//					openDetailWindow(record);
//				}
//			}
//		}],
		store: directMasterStore2,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns:  [
			{dataIndex: 'COMP_CODE',	 width: 0,   hidden: true},
			{dataIndex: 'DIV_CODE',	  width: 0,   hidden: true},
			{dataIndex: 'COMMON_CODE',   width: 0,   hidden: true},
			{dataIndex: 'COMMON_NAME',   width: 80,  locked: true},
			{dataIndex: 'ITEM_CODE',	 width: 120, locked: true},
			{dataIndex: 'ITEM_NAME',	 width: 150, locked: true},
			{dataIndex: 'SPEC',		 width: 166, locked: true},
			{dataIndex: 'STOCK_UNIT',	width: 53,  locked: true, align:'center'},
			{
				text	: '기본정보',
				columns	: [
					{dataIndex: 'INOUT_DATE',	   width: 86},
					{dataIndex: 'ITEM_STATUS_NAME', width: 80},
					{dataIndex: 'INOUT_TYPE_NAME',  width: 80}
 				]
			},
			{dataIndex: 'STOCK_P',	   width: 66, hidden: true   },//단가 유니라이트에 안보여서 히든처리
		//{dataIndex: 'INOUT_DATE', width: 86  },
			{dataIndex: 'ITEM_STATUS', width: 0,  hidden: true  },
		//{dataIndex: 'ITEM_STATUS_NAME', width: 53  }
			{dataIndex: 'INOUT_TYPE',  width: 0,  hidden: true  },
		//{dataIndex: 'INOUT_TYPE_NAME', width: 66  }
			{
				text	: '재고수량',
				columns	: [
					{dataIndex: 'BASIS_Q',	width: 100, summaryType: 'sum' },
					{dataIndex: 'IN_Q',		width: 100, summaryType: 'sum' },
					{dataIndex: 'OUT_Q',	width: 100, summaryType: 'sum' },
					{dataIndex: 'RTN_Q',	width: 100, summaryType: 'sum' },
					{dataIndex: 'STOCK_Q',	width: 100, summaryType: 'sum' }
				]
			},{
				text	: '재고금액',
				columns	: [
					{dataIndex: 'BASIS_I',	width: 100, summaryType: 'sum' },
					{dataIndex: 'IN_I',		width: 100, summaryType: 'sum' },
					{dataIndex: 'OUT_I',	width: 100, summaryType: 'sum' },
					{dataIndex: 'RTN_I',	width: 100, summaryType: 'sum' },
					{dataIndex: 'STOCK_I',	width: 100, summaryType: 'sum' }
				]
			},{
				text	: '수불정보',
				columns	: [
					{dataIndex: 'INOUT_TYPE_DETAIL_NAME', width: 80},
					{dataIndex: 'INOUT_METH_NAME',		  width: 66},
					{dataIndex: 'ITEM_ACCOUNT_NAME',	  width: 80},
					{dataIndex: 'CREATE_LOC_NAME',		  width: 80},
					{dataIndex: 'INOUT_CODE_TYPE_NAME',   width: 80},
					{dataIndex: 'INOUT_CODE_NAME',		  width: 120},
					{dataIndex: 'UPDATE_DB_TIME',		  width: 80}
				]
			},
			{dataIndex: 'INOUT_TYPE_DETAIL', width: 0, hidden: true},
			{dataIndex: 'INOUT_METH',		width: 0, hidden: true},
			{dataIndex: 'ITEM_ACCOUNT',	  width: 0, hidden: true},
			{dataIndex: 'CREATE_LOC',		width: 0, hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE',   width: 0, hidden: true},
			{dataIndex: 'INOUT_CODE',		width: 0, hidden: true},
			{dataIndex: 'ORDER_TYPE',		width: 0, hidden: true},
			{dataIndex: 'ORDER_TYPE_NAME',   width: 0, hidden: true},
			{
				text	: '구매/판매정보',
				columns	: [
					{dataIndex: 'ORDER_UNIT',   width: 60 , align:'center'},
					{dataIndex: 'ORDER_UNIT_P', width: 110 },	// , summaryType: 'sum'
					{dataIndex: 'ORDER_UNIT_Q', width: 110, summaryType: 'sum' },
					{dataIndex: 'ORDER_UNIT_O', width: 110, summaryType: 'sum' },
					{dataIndex: 'TRNS_RATE',	   width: 53 }
				]
			},{
				text	: '구매/판매정보',
				columns	: [
					{dataIndex: 'INOUT_PRSN_NAME', width: 110},
					{dataIndex: 'INOUT_NUM',	   width: 120},
					{dataIndex: 'INOUT_SEQ',	   width: 66,align:'center'},
					{dataIndex: 'PROJECT_NO',	   width: 120},
					{dataIndex: 'LOT_NO',		   width: 120}
				]
			},
			{dataIndex: 'INOUT_PRSN',   width: 0, hidden: true},
			{dataIndex: 'SORT_WH_CODE', width: 0, hidden: true},
			{dataIndex: 'SORT_FLD',	width: 0, hidden: true},
			{dataIndex: 'REMARK',	width: 200, hidden: false},
			{dataIndex: 'UPDATE_DB_USER',	width: 120, hidden: false}
		]
	});



	//创建标签页面板
	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab: 0,
		region: 'center',
		items: [
				 {
					 title: '품목별'
					 ,xtype:'container'
					 ,layout:{type:'vbox', align:'stretch'}
					 ,items:[masterGrid]
					 ,id: 'biv360skrvGridTab'
				 },
				 {
					 title: '창고별'
					 ,xtype:'container'
					 ,layout:{type:'vbox', align:'stretch'}
					 ,items:[masterGrid2]
					 ,id: 'biv360skrvGridTab2'
				 }
		],
		listeners:  {
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
				console.log("newCard:  " + newCard.getId());
				console.log("oldCard:  " + oldCard.getId());
				//탭 넘길때마다 초기화
				UniAppManager.setToolbarButtons(['save', 'newData' ], false);
//				panelResult.setAllFieldsReadOnly(false);
//				panelSearch.setAllFieldsReadOnly(false);
//			  Ext.getCmp('confirm_check').hide(); //확정버튼 hidden
			}
		}
	});



	Unilite.Main({
		id			: 'biv360skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				tab, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get("startOfMonth"));
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get("today"));
			panelResult.setValue('ORDER_DATE_FR', UniDate.get("startOfMonth"));
			panelResult.setValue('ORDER_DATE_TO', UniDate.get("today"));
			UniAppManager.setToolbarButtons('detail', true);
			UniAppManager.setToolbarButtons('reset'	, false);

			//20210311 추가: 링크 받는 로직 추가
			if(params && params.ITEM_CODE) {
				this.processParams(params);
			}
		},
		//20210311 추가: 링크 받는 로직 추가
		processParams: function(params) {
			if(params.PGM_ID == 'biv300skrv') {
				gsLinkFlag = 'Y';
				panelSearch.setValue('DIV_CODE'		, params.DIV_CODE);
				panelResult.setValue('DIV_CODE'		, params.DIV_CODE);
				panelSearch.setValue('ITEM_CODE'	, params.ITEM_CODE);
				panelResult.setValue('ITEM_CODE'	, params.ITEM_CODE);
				panelSearch.setValue('ITEM_NAME'	, params.ITEM_NAME);
				panelResult.setValue('ITEM_NAME'	, params.ITEM_NAME);
				panelSearch.setValue('ORDER_DATE_FR', UniDate.add(panelSearch.getValue('ORDER_DATE_TO'), {years: -1}));
				panelResult.setValue('ORDER_DATE_FR', UniDate.add(panelResult.getValue('ORDER_DATE_TO'), {years: -1}));
			//20210507 추가: 수주등록에서 넘어오는 링크 받는 로직 추가
			} else if(params.PGM_ID == 'sof100ukrv') {
				gsLinkFlag = 'Y';
				panelSearch.setValue('DIV_CODE'			, params.DIV_CODE);
				panelResult.setValue('DIV_CODE'			, params.DIV_CODE);
				panelSearch.setValue('ITEM_CODE'		, params.ITEM_CODE);
				panelResult.setValue('ITEM_CODE'		, params.ITEM_CODE);
				panelSearch.setValue('ITEM_NAME'		, params.ITEM_NAME);
				panelResult.setValue('ITEM_NAME'		, params.ITEM_NAME);
				panelSearch.setValue('ORDER_DATE_FR'	, params.ORDER_DATE_FR);
				panelResult.setValue('ORDER_DATE_FR'	, params.ORDER_DATE_FR);
				panelResult.setValue('ORDER_DATE_TO'	, params.ORDER_DATE_TO);
				panelResult.setValue('ORDER_DATE_TO'	, params.ORDER_DATE_TO);;
			}
			setTimeout(function(){
				UniAppManager.app.onQueryButtonDown();
			}, 600);
		},
		onQueryButtonDown : function() {
			UniAppManager.setToolbarButtons(['reset' ], true);
			var activeTabId = tab.getActiveTab().getId();

			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			} else if(activeTabId == 'biv360skrvGridTab'){
				masterGrid.getStore().loadStoreRecords();
				var viewLocked = masterGrid.lockedGrid.getView();
				var viewNormal = masterGrid.normalGrid.getView();
				console.log("viewLocked : ",viewLocked);
				console.log("viewNormal : ",viewNormal);
			/*	viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true); */
			} else{
				masterGrid2.getStore().loadStoreRecords();
				var viewLocked = masterGrid2.lockedGrid.getView();
				var viewNormal = masterGrid2.normalGrid.getView();
				console.log("viewLocked : ",viewLocked);
				console.log("viewNormal : ",viewNormal);
			/*	viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true); */
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			} else {
				as.hide()
			}
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterGrid2.reset();
			masterGrid.getStore().clearData();
			masterGrid2.getStore().clearData();
			UniAppManager.app.fnInitBinding();
		}
	});
}
</script>