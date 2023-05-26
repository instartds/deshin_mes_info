<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr400skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B020"/>			<!--품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>			<!-- 화폐단위 -->
	<t:ExtComboStore comboType="BOR120"  pgmId="bpr400skrv"/>	<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Bpr400skrvModel', {
		fields: [
			{name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.base.custom" default="거래처"/>'				,type:'string'},
			{name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.base.customname" default="거래처명"/>'			,type:'string'},
			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.base.itemcode" default="품목코드"/>'			,type:'string'},
			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.base.itemname2" default="품명"/>'			,type:'string'},
			{name: 'SPEC'				,text:'<t:message code="system.label.base.spec" default="규격"/>'					,type:'string'},
			{name: 'MONEY_UNIT'			,text:'<t:message code="system.label.base.currencyunit" default="화폐단위"/>'		,type:'string',	comboType:'BU', comboCode:'B004', displayField: 'value'},
			{name: 'ORDER_UNIT'			,text:'<t:message code="system.label.base.unit" default="단위"/>'					,type:'string'},
			{name: 'ITEM_P'				,text:'<t:message code="system.label.base.price" default="단가"/>'				,type:'uniUnitPrice'},
			{name: 'APLY_START_DATE'	,text:'<t:message code="system.label.base.applystartdate" default="적용시작일"/>'	,type:'string'},
			{name: 'STOCK_UNIT'			,text:'<t:message code="system.label.base.inventoryunit" default="재고단위"/>'		,type:'string'},
			{name: 'CUSTOM_UNIT'		,text:'<t:message code="system.label.base.unit" default="단위"/>'					,type:'string'},
			{name: 'CUSTOM_P'			,text:'<t:message code="system.label.base.price" default="단가"/>'				,type:'uniUnitPrice'},
			{name: 'ITEM_ACCOUNT'		,text:'<t:message code="system.label.base.itemaccount" default="품목계정"/>'		,type:'string', comboType:'0U', comboCode:'B020' },
			{name: 'TRNS_RATE'			,text:'<t:message code="system.label.base.containedqty" default="입수"/>'			,type:'string'},
			{name: 'TYPE'				,text:'<t:message code="system.label.base.classfication" default="구분"/>'		,type:'string'},
			{name: 'CUSTOM_ITEM_CODE'	,text:'<t:message code="system.label.base.customitemcode" default="거래처품목코드"/>'	,type:'string'},
			{name: 'CUSTOM_ITEM_NAME'	,text:'<t:message code="system.label.base.customitemname" default="거래처품명"/>'	,type:'string'},
			{name: 'CUSTOM_ITEM_SPEC'	,text:'<t:message code="system.label.base.customitemspec" default="거래처품목규격"/>'	,type:'string'},
			{name: 'CUSTOM_TRNS_RATE'	,text:'<t:message code="system.label.base.customprnsrate" default="거래처입수"/>'	,type:'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('bpr400skrvMasterStore1',{
		model	: 'Bpr400skrvModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'bpr400skrvService.selectList1'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var directMasterStore2 = Unilite.createStore('bpr400skrvMasterStore2',{
		model	: 'Bpr400skrvModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'bpr400skrvService.selectList2'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			layout : {type : 'uniTable', columns : 1},
			items : [{
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
				Unilite.popup('ITEM',{
				fieldLabel: '<t:message code="system.label.base.customitem" default="거래처품목"/>',
				valueFieldName: 'CUST_ITEM_CODE',
				textFieldName:'CUST_ITEM_NAME',
				readOnly:true,
				textFieldWidth:170,
				validateBlank	: false,			//20210817 추가
				listeners		: {
					//20210817 수정: 조회조건 팝업설정에 맞게 변경
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUST_ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUST_ITEM_NAME', '');
							panelResult.setValue('CUST_ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUST_ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUST_ITEM_CODE', '');
							panelResult.setValue('CUST_ITEM_CODE', '');
						}
//					},
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('CUST_ITEM_CODE', panelSearch.getValue('CUST_ITEM_CODE'));
//							panelResult.setValue('CUST_ITEM_NAME', panelSearch.getValue('CUST_ITEM_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelResult.setValue('CUST_ITEM_CODE', '');
//						panelResult.setValue('CUST_ITEM_NAME', '');
					}
				}
			}),
			Unilite.popup('CUST',{
				fieldLabel: '<t:message code="system.label.base.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				textFieldWidth:170,
				width:400,
				id:'bpr400ukrvCustPopup',
				extParam:{'CUSTOM_TYPE':'3'},
				validateBlank	: false,			//20210817 추가
				listeners		: {
					//20210817 수정: 조회조건 팝업설정에 맞게 변경
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
//					},
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
//							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelResult.setValue('CUSTOM_CODE', '');
//						panelResult.setValue('CUSTOM_NAME', '');
					}
				}
			}),
			Unilite.popup('ITEM',{
				fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName:'ITEM_NAME',
				textFieldWidth:170,
				width:400,
				validateBlank	: false,			//20210817 추가
				listeners		: {
					//20210817 수정: 조회조건 팝업설정에 맞게 변경
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
//					},
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
//							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelResult.setValue('ITEM_CODE', '');
//						panelResult.setValue('ITEM_NAME', '');
					}
				}
			}),{
				xtype: 'radiogroup'		
				,fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>'
				,allowBlank : false
				,items : [{
					boxLabel:'<t:message code="system.label.base.sales" default="매출"/>',
					width: 125,  
					name: 'TYPE',
					inputValue: '2' ,
					checked : true
				},{
					boxLabel:'<t:message code="system.label.base.purchase" default="매입"/>',
					width: 125,
					name: 'TYPE',
					inputValue: '1'
				}],
				listeners : {
					change : function( radioGroup, newValue, oldValue, eOpts) {
						var custPopup = Ext.getCmp('bpr400ukrvCustPopup');
						var value = {};
						if(newValue.TYPE == '1') {
							value = {'CUSTOM_TYPE' : '3'}
						}else if(newValue.TYPE == '2') {
							value = {'CUSTOM_TYPE' : '2'}
						}
						custPopup.setExtParam(value);
						panelResult.getField('TYPE').setValue(newValue.TYPE);
					} 
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.base.pricesearch" default="단가검색"/>',
				id : 'aptPrice',
				items : [{
					boxLabel:'<t:message code="system.label.base.currentappliedprice" default="현재적용단가"/>',
					width: 130,
					name: 'OPT_APT_PRICE',
					id: 'optAptPrice',
					inputValue: 'C'  
				},{
					boxLabel: '<t:message code="system.label.base.whole" default="전체"/>', 
					width: 80,
					name: 'OPT_APT_PRICE',
					inputValue: 'A',
					checked: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('OPT_APT_PRICE').setValue(newValue.OPT_APT_PRICE);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('ITEM',{
				fieldLabel: '<t:message code="system.label.base.customitem" default="거래처품목"/>',
				valueFieldName: 'CUST_ITEM_CODE',
				textFieldName:'CUST_ITEM_NAME',
				readOnly:true,
				textFieldWidth:170,
				validateBlank	: false,			//20210817 추가
				listeners		: {
					//20210817 수정: 조회조건 팝업설정에 맞게 변경
					onValueFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUST_ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUST_ITEM_NAME', '');
							panelResult.setValue('CUST_ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUST_ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUST_ITEM_CODE', '');
							panelResult.setValue('CUST_ITEM_CODE', '');
						}
//					},
//					onSelected: {
//						fn: function(records, type) {
//							panelSearch.setValue('CUST_ITEM_CODE', panelResult.getValue('CUST_ITEM_CODE'));
//							panelSearch.setValue('CUST_ITEM_NAME', panelResult.getValue('CUST_ITEM_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelSearch.setValue('CUST_ITEM_CODE', '');
//						panelSearch.setValue('CUST_ITEM_NAME', '');
					}
				}
			}),
			Unilite.popup('CUST',{
				fieldLabel: '<t:message code="system.label.base.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				textFieldWidth:170,
				width:400,
				id:'bpr400ukrvCustPopup1',
				extParam:{'CUSTOM_TYPE':'3'},
				validateBlank	: false,			//20210817 추가
				listeners		: {
					//20210817 수정: 조회조건 팝업설정에 맞게 변경
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
//					},
//					onSelected: {
//						fn: function(records, type) {
//							panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
//							panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelSearch.setValue('CUSTOM_CODE', '');
//						panelSearch.setValue('CUSTOM_NAME', '');
					}
				}
			}),
			Unilite.popup('ITEM',{
				fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName:'ITEM_NAME',
				textFieldWidth:170,
				width:400,
				validateBlank	: false,			//20210817 추가
				listeners		: {
					//20210817 수정: 조회조건 팝업설정에 맞게 변경
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
//					},
//					onSelected: {
//						fn: function(records, type) {
//							panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
//							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelSearch.setValue('ITEM_CODE', '');
//						panelSearch.setValue('ITEM_NAME', '');
					}
				}
			}),{
				xtype: 'radiogroup'
				,fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>'
				,allowBlank : false
				,items : [{
					boxLabel:'<t:message code="system.label.base.sales" default="매출"/>',
					width: 125,  
					name: 'TYPE',
					inputValue: '2' ,
					checked : true
				},{
					boxLabel:'<t:message code="system.label.base.purchase" default="매입"/>',
					width: 125,
					name: 'TYPE',
					inputValue: '1'
				}],
				listeners : {
					change : function( radioGroup, newValue, oldValue, eOpts) {
						var custPopup = Ext.getCmp('bpr400ukrvCustPopup1');
						var value = {};
						if(newValue.TYPE == '1') {
							value = {'CUSTOM_TYPE' : '3'}
						}else if(newValue.TYPE == '2') {
							value = {'CUSTOM_TYPE' : '2'}
						}
						custPopup.setExtParam(value);
						panelSearch.getField('TYPE').setValue(newValue.TYPE);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.base.pricesearch" default="단가검색"/>',
				id : 'aptPrice1',
				items : [{
					boxLabel:'<t:message code="system.label.base.currentappliedprice" default="현재적용단가"/>',
					width: 130,
					name: 'OPT_APT_PRICE',
					id: 'optAptPrice1',
					inputValue: 'C'  
				},{
					boxLabel: '<t:message code="system.label.base.whole" default="전체"/>', 
					width: 80,
					name: 'OPT_APT_PRICE',
					inputValue: 'A',
					checked: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('OPT_APT_PRICE').setValue(newValue.OPT_APT_PRICE);
					}
				}
			}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('bpr400skrvGrid1', {
		title	: '<t:message code="system.label.base.priceinfo" default="단가정보"/>',
		layout	: 'fit', 
		store	: directMasterStore1,
		columns	: [
			{dataIndex: 'TYPE', 						width: 66, hidden: true}, 	// 구분
			{dataIndex: 'CUSTOM_CODE',  				width: 50 },				// 고객코드
			{dataIndex: 'CUSTOM_NAME',  				width: 166 }, 				// 고객명
			{dataIndex: 'ITEM_CODE',  					width: 133 },				// 품목코드
			{dataIndex: 'ITEM_NAME',  					width: 166 }, 				// 품명
			{dataIndex: 'SPEC',							width: 166 }, 				// 규격
			{text: '<t:message code="system.label.base.salesbuyprice" default="판매/구매단가"/>',
				columns:[{dataIndex: 'MONEY_UNIT',		width: 66, align: 'center'}, // 화폐단위
					{ dataIndex: 'ORDER_UNIT',			width: 66, align: 'center'}, // 단위
					{ dataIndex: 'ITEM_P',				width: 100 }, // 단가
					{ dataIndex: 'APLY_START_DATE',		width: 80 } 	 // 적용시작일
				]
			},
			{text: '<t:message code="system.label.base.iteminfo" default="품목정보"/>',
				columns:[
					{dataIndex: 'STOCK_UNIT',		width: 66, align: 'center' }, // 재고단위
					{dataIndex: 'CUSTOM_UNIT',		width: 66, align: 'center', hidden:true }, 	 // 단위
					{dataIndex: 'CUSTOM_P',			width: 100 }, 	 // 단가
					{dataIndex: 'ITEM_ACCOUNT',		width: 80, align: 'center' }, 	 // 품목계정
					{dataIndex: 'TRNS_RATE',		width: 66, align: 'right' } // 입수
				]
			}
		]
	});

	/** Master Grid2 정의(Grid Panel)
	 * @type
	 */
	var masterGrid2 = Unilite.createGrid('bpr400skrvGrid2', {
		title: '<t:message code="system.label.base.iteminfo" default="품목정보"/>',
		layout : 'fit', 
		store: directMasterStore2, 
		columns:  [  { dataIndex: 'TYPE', 						width: 66, hidden: true}
					,{ dataIndex: 'CUSTOM_CODE',  				width: 133 }					// 고객코드   
					,{ dataIndex: 'CUSTOM_NAME',  				width: 166 } 					// 고객명
					,{ dataIndex: 'CUSTOM_ITEM_CODE',  			width: 133 } 					// 고객품목코드
					,{ dataIndex: 'CUSTOM_ITEM_NAME',  			width: 166 } 					// 고객품명
					,{ dataIndex: 'CUSTOM_ITEM_SPEC',  			width: 166 } 					// 고객품목규격
					,{ dataIndex: 'ORDER_UNIT',					width: 66, align: 'center' }	// 단위
					,{ dataIndex: 'CUSTOM_TRNS_RATE',			width: 66, align: 'right' }		// 입수
					,{ dataIndex: 'APLY_START_DATE',			width: 80 } 					// 적용시작일
					,{text: '<t:message code="system.label.base.itembasicinfor" default="품목기준정보"/>',
						columns:[{ dataIndex: 'ITEM_CODE',  		width: 133 }				// 품목코드
								,{ dataIndex: 'ITEM_NAME',  	width: 166 } 					// 품명 
								,{ dataIndex: 'SPEC',			width: 166 } 					// 규격
								,{ dataIndex: 'STOCK_UNIT',		width: 66 , align: 'center' }	// 재고단위
								,{ dataIndex: 'CUSTOM_UNIT',	width: 66 , align: 'center' }	// 단위
								,{ dataIndex: 'ITEM_ACCOUNT',	width: 100 }					// 품목계정
								,{ dataIndex: 'TRNS_RATE',		width: 66 , align: 'right' }	// 입수
					]}
		]
	});

	 var tab = Unilite.createTabPanel('tabPanel',{
		activeTab	: 0,
		region		: 'center',
		items		: [
			masterGrid1,
			masterGrid2
		],
		listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
					console.log("newCard : " + newCard.getId());
					console.log("oldCard : " + oldCard.getId());

				switch(newTabId) {
					case 'bpr400skrvGrid1' :
						var fieldTxt1 = Ext.getCmp('aptPrice');
						fieldTxt1.setFieldLabel('<t:message code="system.label.base.pricesearch" default="단가검색"/>');
						var fieldTxt2 = Ext.getCmp('optAptPrice');
						fieldTxt2.setBoxLabel('<t:message code="system.label.base.currentappliedprice" default="현재적용단가"/>');

						var fieldTxt1 = Ext.getCmp('aptPrice1');
						fieldTxt1.setFieldLabel('<t:message code="system.label.base.pricesearch" default="단가검색"/>');
						var fieldTxt2 = Ext.getCmp('optAptPrice1'); 
						fieldTxt2.setBoxLabel('<t:message code="system.label.base.currentappliedprice" default="현재적용단가"/>');

						var form = panelSearch.getForm();
						var panel = panelResult.getForm();

						var cust_item_code = form.findField('CUST_ITEM_CODE');
						var cust_item_name = form.findField('CUST_ITEM_NAME');
						var cust_item_code1 = panel.findField('CUST_ITEM_CODE');
						var cust_item_name1 = panel.findField('CUST_ITEM_NAME');

						cust_item_code.setReadOnly( true );
						cust_item_name.setReadOnly( true );
						cust_item_code1.setReadOnly( true );
						cust_item_name1.setReadOnly( true );
						break;
					
					case 'bpr400skrvGrid2' :
						var fieldTxt1 = Ext.getCmp('aptPrice');   
						fieldTxt1.setFieldLabel('<t:message code="system.label.base.itemsearch" default="품목검색"/>');
						var fieldTxt2 = Ext.getCmp('optAptPrice'); 
						fieldTxt2.setBoxLabel('<t:message code="system.label.base.currentapplieditem" default="현재적용품목"/>');

						var fieldTxt1 = Ext.getCmp('aptPrice1');   
						fieldTxt1.setFieldLabel('<t:message code="system.label.base.itemsearch" default="품목검색"/>');
						var fieldTxt2 = Ext.getCmp('optAptPrice1'); 
						fieldTxt2.setBoxLabel('<t:message code="system.label.base.currentapplieditem" default="현재적용품목"/>');

						var form = panelSearch.getForm();
						var panel = panelResult.getForm();

						var cust_item_code = form.findField('CUST_ITEM_CODE');
						var cust_item_name = form.findField('CUST_ITEM_NAME');
						var cust_item_code1 = panel.findField('CUST_ITEM_CODE');
						var cust_item_name1 = panel.findField('CUST_ITEM_NAME');

						cust_item_code.setReadOnly( false );
						cust_item_name.setReadOnly( false );
						cust_item_code1.setReadOnly( false );
						cust_item_name1.setReadOnly( false );
						break;

					default:
						break;
				}
				
			}
		}
	});

	Unilite.Main({
		id: 'bpr400skrvApp',
		borderItems: [{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]	
		},
		panelSearch	 
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'bpr400skrvGrid1'){
				directMasterStore1.loadStoreRecords();
			}
			if(activeTabId == 'bpr400skrvGrid2'){
				directMasterStore2.loadStoreRecords();
			}
		}
	});
};
</script>