<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr350skrv_kodi"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmr350skrv_kodi" /> 					  <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"  /> 		  <!-- 품목계정 -->
</t:appConfig>
<link rel="stylesheet" type="text/css"  href='<c:url value="/extjs_6.2.0/charts/classic/charts-all.css"/>'>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs_6.2.0/charts/ext-charts.js" />'></script>
<script type="text/javascript" >

function appMain() {
	var colData = ${colData}; //불량유형 공통코드 데이터 가져오기
	var colDataL = ${colData}; //불량유형 공통코드 데이터 가져오기
	var fields	= createModelField(colData);
	var lfields	= createModelFieldL(colDataL);
	var columns	= createGridColumn(colData);
	var lcolumns	= createGridColumnL(colDataL);
	var gsBadQtyInfo;
	var gsBadQtyInfoL;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmr350skrv_kodiService.selectList1'
		}
	});

	var directProxyL = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmr350skrv_kodiService.selectListL1'
		}
	});


	/** Model 정의
	 * @type
	 */
	//자재불량내역 모델 필드 생성
	function createModelField(colData) {
		var fields = [
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.product.custom" default="거래처코드"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.product.customname" default="거래처 명"/>'		,type: 'string'}
		];
		//동적 컬럼 모델 push
		Ext.each(colData, function(item, index){
			fields.push({name: 'BAD_' + item.SUB_CODE, type:'uniQty'});
		});
		console.log(fields);
		return fields;
	}

	function createModelFieldL(colDataL) {
		var lfields = [
			{name: 'ITEM_LEVEL'	,text: '유형별(대분류)'		,type: 'string'},
			{name: 'LEVEL_NAME'	,text: '유형별(대분류)'		,type: 'string'}
		];
		//동적 컬럼 모델 push
		Ext.each(colDataL, function(item, index){
			lfields.push({name: 'BAD_' + item.SUB_CODE, type:'uniQty'});
		});
		console.log(lfields);
		return lfields;
	}

	//자재불량내역 그리드 컬럼 생성
	function createGridColumn(colData) {
		var array1  = new Array();
		var columns = [
			{dataIndex: 'CUSTOM_CODE'			, width: 120},
			{dataIndex: 'CUSTOM_NAME'			, width: 250,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
			}}

		];
		Ext.each(colData, function(item, index){
			if(index == 0){
				gsBadQtyInfo = item.SUB_CODE;
			} else {
				gsBadQtyInfo += ',' + item.SUB_CODE;
			}
			columns.push(
				{dataIndex: 'BAD_' + item.SUB_CODE	, text: item.CODE_NAME	,align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty,  summaryType: 'sum' }
			)
			array1[index] = Ext.applyIf({dataIndex: 'BAD_' + item.SUB_CODE	, text: item.CODE_NAME	, flex:1},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty,  summaryType: 'sum'  });
		});


 		console.log(columns);
		return columns;
	}

	function createGridColumnL(colDataL) {
		var array2  = new Array();
		var lcolumns = [
			{dataIndex: 'ITEM_LEVEL'			, width: 200, hidden:true},
			{dataIndex: 'LEVEL_NAME'			, width: 200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
			}}

		];
		Ext.each(colDataL, function(item, index){
			if(index == 0){
				gsBadQtyInfoL = item.SUB_CODE;
			} else {
				gsBadQtyInfoL += ',' + item.SUB_CODE;
			}
			lcolumns.push(
				{dataIndex: 'BAD_' + item.SUB_CODE	, text: item.CODE_NAME	, flex:1, align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty , summaryType: 'sum'  }
			)
			array2[index] = Ext.applyIf({dataIndex: 'BAD_' + item.SUB_CODE	, text: item.CODE_NAME	, flex:1},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty , summaryType: 'sum'  });
		});
		/*lcolumns.push(
			{text: '불량유형',
				columns: array2
			}
		);*/
 		console.log(lcolumns);
		return lcolumns;
	}

	Unilite.defineModel('s_pmr350skrv_kodiModel', {
		fields: fields
	});

	Unilite.defineModel('s_pmr350skrv_kodiModeLl', {
		fields: lfields
	});

	Unilite.defineModel('s_pmr350skrv_kodiModel2', {
		fields: [
		    {name: 'DIV_CODE'	    ,text: '<t:message code="system.label.product.division" default="사업장"/>'		,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.product.custom" default="거래처코드"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.product.customname" default="거래처 명"/>'		,type: 'string'},
			{name: 'ITEM_CODE'	    ,text: '<t:message code="system.label.product.item" default="품목"/>'		,type: 'string'},
			{name: 'ITEM_NAME'	    ,text: '<t:message code="system.label.product.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'	        ,text: '<t:message code="system.label.product.spec" default="규격"/>'		,type: 'string'},
			{name: 'STOCK_UNIT'	    ,text: '<t:message code="system.label.product.unit" default="단위"/>'		,type: 'string'},
			{name: 'BAD_Q'		    ,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'	,type: 'uniQty'}
		]
	});

	Unilite.defineModel('s_pmr350skrv_kodiModelL2', {
		fields: [
		    {name: 'DIV_CODE'	    ,text: '<t:message code="system.label.product.division" default="사업장"/>'		,type: 'string'},
			{name: 'ITEM_LEVEL'	,text: '(대분류)'		,type: 'string'},
			{name: 'LEVEL_NAME'	,text: '(대분류)'		,type: 'string'},
			{name: 'ITEM_CODE'	    ,text: '<t:message code="system.label.product.item" default="품목"/>'		,type: 'string'},
			{name: 'ITEM_NAME'	    ,text: '<t:message code="system.label.product.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'	        ,text: '<t:message code="system.label.product.spec" default="규격"/>'		,type: 'string'},
			{name: 'STOCK_UNIT'	    ,text: '<t:message code="system.label.product.unit" default="단위"/>'		,type: 'string'},
			{name: 'PRODT_Q'		,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'	,type: 'uniQty'},
			{name: 'BAD_Q'		    ,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'	,type: 'uniQty'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var MasterStore1 = Unilite.createStore('s_pmr350skrv_kodiMasterStore1',{
		model: 's_pmr350skrv_kodiModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_pmr350skrv_kodiService.selectList'
			}
		},
		loadStoreRecords : function(badQtyArray)	{
			var param= Ext.getCmp('searchForm').getValues();
			if(!Ext.isEmpty(badQtyArray)) {
				param.badQtyArray = badQtyArray;
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});

	var MasterStoreL1 = Unilite.createStore('s_pmr350skrv_kodiMasterStoreL1',{
		model: 's_pmr350skrv_kodiModeLl',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_pmr350skrv_kodiService.selectListL'
			}
		},
		loadStoreRecords : function(badQtyArray)	{
			var param= Ext.getCmp('searchForm').getValues();
			if(!Ext.isEmpty(badQtyArray)) {
				param.badQtyArray = badQtyArray;
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});

	var MasterStore2 = Unilite.createStore('s_pmr350skrv_kodiMasterStore2',{
		model: 's_pmr350skrv_kodiModel2',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy:directProxy,
		loadStoreRecords: function(record){
			var param= Ext.getCmp('searchForm').getValues();
			var record	= masterGrid1.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.CUSTOM_CODE	= record.get('CUSTOM_CODE');
			}
			this.load({
					params : param
			});
		}
	});

	var MasterStoreL2 = Unilite.createStore('s_pmr350skrv_kodiMasterStoreL2',{
		model: 's_pmr350skrv_kodiModelL2',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy:directProxyL,
		loadStoreRecords: function(record){
			var param= Ext.getCmp('searchForm').getValues();
			var record	= masterGridL1.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.ITEM_LEVEL	= record.get('ITEM_LEVEL');
			}
			this.load({
					params : param
			});
		}
	});



    Unilite.defineModel('pieChartModel', {
		fields: [
			{name: 'BAD_NAME'			, text:'불량유형'				,type:'string'},
			{name: 'BAD_RATE'			, text:'수량백분율'				,type: 'float'		, decimalPrecision: 2 , format:'0,000.00'}
		]
	});

    Unilite.defineModel('pieChartModelL', {
		fields: [
			{name: 'BAD_NAME'			, text:'불량유형'				,type:'string'},
			{name: 'BAD_RATE'			, text:'수량백분율'				,type: 'float'		, decimalPrecision: 2 , format:'0,000.00'}
		]
	});

	var pieChartStore = Unilite.createStore('pieChartStore',{
		model: 'pieChartModel',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_pmr350skrv_kodiService.selectBadList'
			}
		},
		loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();
			var record	= masterGrid1.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.CUSTOM_CODE	= record.get('CUSTOM_CODE');
			}
			this.load({
					params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {

			}
		}

	});

	var pieChartStoreL = Unilite.createStore('pieChartStoreL',{
		model: 'pieChartModelL',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_pmr350skrv_kodiService.selectBadListL'
			}
		},
		loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();
			var record	= masterGridL1.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.ITEM_LEVEL	= record.get('ITEM_LEVEL');
			}
			this.load({
					params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {

			}
		}

	});

	var pieChartPanel = Unilite.createSearchForm('pieChartPanel', {
//			renderTo: Ext.getBody(),
		region: 'west',
		border: false,
//			height: 310,
		width: '30%',
		layout: 'fit',
		items: [{
			xtype: 'polar',
			store: pieChartStore,
			animate: true,
			shadow: true,
			width: '100%',
			innerPadding: 30,
//				theme: 'green-gradients',
			legend: {
				position: 'right'
			},
			series: [{
				type: 'pie',
				angleField: 'BAD_RATE',
				showInLegend: true,
				donut: 13,
				highlight: {
					segment: {
						margin: 20
					}
				},
				label: {
					field: 'BAD_NAME',
//						display: 'rotate',
//						contrast: true,
					font: '13px Arial'
				},
				tooltip: {
					trackMouse: true,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(record.get('BAD_NAME'));
						}
					}
				}
			}]
		}]
	});

	var pieChartPanelL = Unilite.createSearchForm('pieChartPanelL', {
		region: 'west',
		hidden:true,
		border: false,
		width: '30%',
		layout: 'fit',
		items: [{
			xtype: 'polar',
			store: pieChartStoreL,
			animate: true,
			shadow: true,
			width: '100%',
			innerPadding: 30,
			legend: {
				position: 'right'
			},
			series: [{
				type: 'pie',
				angleField: 'BAD_RATE',
				showInLegend: true,
				donut: 13,
				highlight: {
					segment: {
						margin: 20
					}
				},
				label: {
					field: 'BAD_NAME',
//						display: 'rotate',
//						contrast: true,
					font: '13px Arial'
				},
				tooltip: {
					trackMouse: true,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(record.get('BAD_NAME'));
						}
					}
				}
			}]
		}]
	});


	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
				id: 'search_panel1',
				itemId: 'search_panel1',
				layout: {type: 'uniTable', columns: 1},
				defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.resultsdate" default="실적일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_DATE_FR',
				endFieldName:'PRODT_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('PRODT_DATE_FR',newValue);

						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('PRODT_DATE_TO',newValue);
						}
					}
			},{
					fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목게정"/>',
					name: 'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
            		comboType:'AU',
            		comboCode:'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),{
				xtype: 'radiogroup',
			    fieldLabel: '구분',
			    labelWidth: 90,
				items: [{
					boxLabel : '거래처별',
		    		width: 80,
		    		name: 'SELECT_GUBUN',
		    		inputValue: 'C',
		    		checked: true
				},{
					boxLabel: '유형별',
					width: 80,
					name: 'SELECT_GUBUN',
					inputValue: 'L'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							UniAppManager.app.onQueryButtonDown();
							if(newValue.SELECT_GUBUN == 'C'){
								panelResult.setValue('ITEM_ACCOUNT', '');
								panelResult.getField('ITEM_ACCOUNT').setReadOnly(false);
								panelSearch.setValue('ITEM_ACCOUNT', '');
								panelSearch.getField('ITEM_ACCOUNT').setReadOnly(false);
								masterGrid1.show();
								masterGrid2.show();
								pieChartPanel.show();
								masterGridL1.hide();
								masterGridL2.hide();
								pieChartPanelL.hide();
							};
							if(newValue.SELECT_GUBUN == 'L'){
								panelResult.setValue('ITEM_ACCOUNT', '10');
								panelResult.getField('ITEM_ACCOUNT').setReadOnly(true);
								panelSearch.setValue('ITEM_ACCOUNT', '10');
								panelSearch.getField('ITEM_ACCOUNT').setReadOnly(true);
								masterGrid1.hide();
								masterGrid2.hide();
								pieChartPanel.hide();
								masterGridL1.show();
								masterGridL2.show();
								pieChartPanelL.show();
							};
							panelResult.getField('SELECT_GUBUN').setValue(newValue.SELECT_GUBUN);
						}
					}
				}
			]}
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

						Unilite.messageBox(labelText+Msg.sMB083);
						invalid.items[0].focus();
					} else {
					//	this.mask();
					}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm',{

	var panelResult = Unilite.createSimpleForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
			change: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.resultsdate" default="실적일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_DATE_FR',
			endFieldName:'PRODT_DATE_TO',
			colspan:3,
			width: 315,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_DATE_FR',newValue);

				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_DATE_TO',newValue);
				}
			}
		},{
				fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
        		comboType:'AU',
        		comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				xtype: 'radiogroup',
			    fieldLabel: '구분',
			    labelWidth: 90,
				items: [{
					boxLabel : '거래처별',
		    		width: 80,
		    		name: 'SELECT_GUBUN',
		    		inputValue: 'C',
		    		checked: true
				},{
					boxLabel: '유형별',
					width: 80,
					name: 'SELECT_GUBUN',
					inputValue: 'L'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							UniAppManager.app.onQueryButtonDown();

							if(newValue.SELECT_GUBUN == 'C'){
								panelResult.setValue('ITEM_ACCOUNT', '');
								panelResult.getField('ITEM_ACCOUNT').setReadOnly(false);
								panelSearch.setValue('ITEM_ACCOUNT', '');
								panelSearch.getField('ITEM_ACCOUNT').setReadOnly(false);
								masterGrid1.show();
								masterGrid2.show();
								pieChartPanel.show();
								masterGridL1.hide();
								masterGridL2.hide();
								pieChartPanelL.hide();
							};
							if(newValue.SELECT_GUBUN == 'L'){
								panelResult.setValue('ITEM_ACCOUNT', '10');
								panelResult.getField('ITEM_ACCOUNT').setReadOnly(true);
								panelSearch.setValue('ITEM_ACCOUNT', '10');
								panelSearch.getField('ITEM_ACCOUNT').setReadOnly(true);
								masterGrid1.hide();
								masterGrid2.hide();
								pieChartPanel.hide();
								masterGridL1.show();
								masterGridL2.show();
								pieChartPanelL.show();
							};

							panelSearch.getField('SELECT_GUBUN').setValue(newValue.SELECT_GUBUN);
						}
					}
			}
		]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('s_pmr350skrv_kodiGrid1', {
		layout : 'fit',
		border		: true,
		region:'north',
		width		: '100%',
		height		: '45%',
		store : MasterStore1,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: false
		},
		tbar: [{       xtype:'label',
						html:'<div style="color:#0033CC;font-size: 18px;font-weight: bold;text-align:center;"> '+'불량현황'+' </div>',
						margin: '0 600 0 0'
                 }
		],
		sortableColumns : true,
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: true}
		],
		columns	: columns,
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners: {
   		  selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					MasterStore2.loadStoreRecords(record);

	    			var pieChartStore = Ext.data.StoreManager.lookup("pieChartStore");
	    			pieChartStore.loadStoreRecords();

				}
		  	}
		}

	});

		var masterGridL1 = Unilite.createGrid('s_pmr350skrv_kodiGridL1', {
		layout : 'fit',
		border		: true,
		hidden:true,
		region:'north',
		width		: '100%',
		height		: '45%',
		store : MasterStoreL1,
		uniOpt:{
			expandLastColumn: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		tbar: [	{       xtype:'label',
						html:'<div style="color:#0033CC;font-size: 18px;font-weight: bold;text-align:center;"> '+'불량현황'+' </div>',
						margin: '0 600 0 0'
                 }
		],
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: true}
		],
		columns	: lcolumns,
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners: {
   		  selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					MasterStoreL2.loadStoreRecords(record);

	    			var pieChartStoreL = Ext.data.StoreManager.lookup("pieChartStoreL");
	    			pieChartStoreL.loadStoreRecords();

				}
		  	}
		}

	});


	/**
	 * Master Grid2 정의(Grid Panel)
	 * @type
	 */
	var masterGrid2 = Unilite.createGrid('s_pmr350skrv_kodiGrid2', {
		layout : 'fit',
		region:'east',
		border: false,
		width		: '70%',
		store : MasterStore2,
		uniOpt:{
			expandLastColumn: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
			features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: true}
		],
		columns:  [
			{dataIndex: 'DIV_CODE'	    , width: 100, hidden:true },
			{dataIndex: 'CUSTOM_CODE'	, width: 120 },
			{dataIndex: 'CUSTOM_NAME'	, width: 200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
			} },
			{dataIndex: 'ITEM_CODE'	    , width: 150 },
			{dataIndex: 'ITEM_NAME'		, width: 250 },
			{dataIndex: 'SPEC'	        , width: 200 },
			{dataIndex: 'STOCK_UNIT'	, width: 70, align:'center' },
			{dataIndex: 'BAD_Q'			, width: 120, summaryType: 'sum' }
		]
	});

	var masterGridL2 = Unilite.createGrid('s_pmr350skrv_kodiGridL2', {
		layout : 'fit',
		region:'east',
		hidden:true,
		border: false,
		width		: '70%',
		store : MasterStoreL2,
		uniOpt:{
			expandLastColumn: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
			features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: true}
		],
		columns:  [
			{dataIndex: 'DIV_CODE'	    , width: 100, hidden:true },
			{dataIndex: 'ITEM_LEVEL'	, width: 120, hidden:true },
			{dataIndex: 'LEVEL_NAME'	, width: 150 ,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
			}},
			{dataIndex: 'ITEM_CODE'	    , width: 150 },
			{dataIndex: 'ITEM_NAME'		, width: 250 },
			{dataIndex: 'SPEC'	        , width: 200 },
			{dataIndex: 'STOCK_UNIT'	, width: 70, align:'center' },
			{dataIndex: 'PRODT_Q'		, width: 120, summaryType: 'sum' },
			{dataIndex: 'BAD_Q'			, width: 120, summaryType: 'sum' }
		]
	});

	Unilite.Main({
		borderItems:[{
		 region:'center',
		 layout: 'border',
		 border: false,
		items	: [
			panelResult,
			masterGrid1,
			masterGridL1,
			pieChartPanel,
			pieChartPanelL,
			masterGrid2,
			masterGridL2
		]

	  },
		 panelSearch
	  ],
		id: 's_pmr350skrv_kodiApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			panelSearch.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth'));

			panelSearch.setValue('PRODT_DATE_TO', UniDate.get('today'));
			panelResult.setValue('PRODT_DATE_TO', UniDate.get('today'));

			masterGrid1.show();
			masterGrid2.show();
			pieChartPanel.show();

			masterGridL1.hide();
			masterGridL2.hide();
			pieChartPanelL.hide();

		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			var badQtyArray = new Array();
			badQtyArray = gsBadQtyInfo.split(',');

			var badQtyArrayL = new Array();
			badQtyArrayL = gsBadQtyInfoL.split(',');

			MasterStore1.loadStoreRecords(badQtyArray);
			MasterStoreL1.loadStoreRecords(badQtyArrayL);
			beforeRowIndex = -1;
//			UniAppManager.setToolbarButtons('reset', true);
			}
		},
//		onResetButtonDown: function() {		// 초기화
//			this.suspendEvents();
//			panelSearch.reset();
//			masterGrid1.reset();
//			masterGridL1.reset();
//			masterGrid2.reset();
//			masterGridL2.reset();
//			panelResult.reset();
//			pieChartPanel.reset();
//			pieChartPanelL.reset();
//
//			this.fnInitBinding();
//		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});		//End of Unilite.Main({
};
</script>

