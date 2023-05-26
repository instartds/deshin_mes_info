<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb240skr">
	<t:ExtComboStore comboType="BOR120"/>	<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

///////////////////////////////// 페이지 개발 전 확인사항 /////////////////////////////////
// 계정과목 팝업 선택시 미결항목 팝업이 유동적으로 변함(구현이 안되있어서 거래처 팝업으로 대체함.)
// 마스터그리드에서 조건에 따라서 페이지 링크가 달라짐(573Line ~ 590Line 확인해서 링크로 넘어간 페이지 파라미터 받을것.)
var getStDt = ${getStDt};
//var getChargeCode = ${getChargeCode};


function appMain() {
	var providerSTDT ='';

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb240skrModel', {
		fields: [
			{name: 'ACCNT'			, text: '계정코드'			,type: 'string'},
			{name: 'ACCNT_NAME'		, text: '계정과목명'			,type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '거래처'			,type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '거래처명'			,type: 'string'},
			{name: 'AC_DATE'		, text: '전표일'			,type: 'uniDate'},
			{name: 'SLIP_NUM'		, text: '번호'			,type: 'string'},
			{name: 'REMARK'			, text: '적요'			,type: 'string'},
			{name: 'DR_AMT_I'		, text: '차변금액'			,type: 'uniPrice'},
			{name: 'CR_AMT_I'		, text: '대변금액'			,type: 'uniPrice'},
			{name: 'DIV_CODE'		, text: '사업장'			,type: 'string'},
			{name: 'GUBUN'			, text: '구분'			,type: 'string'},
			{name: 'INPUT_PATH'		, text: 'INPUT_PATH'	,type: 'string'},
			{name: 'INPUT_DIVI'		, text: 'INPUT_DIVI'	,type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('agb240skrMasterStore1',{
		model: 'Agb240skrModel',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
		   type: 'direct',
			api: {
				read: 'agb240skrService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ACCNT'
	});

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
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
			title: '기본정보', 	
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{ 
				fieldLabel: '전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
						UniAppManager.app.fnSetStDate(newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TO_DATE',newValue);
					}
				}
//				textFieldWidth:170
				
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},
			Unilite.popup('ACCNT',{ 
				fieldLabel: '계정과목', 
				valueFieldName: 'ACCOUNT_CODE_FR',
				textFieldName: 'ACCOUNT_NAME_FR',
				/*extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
							'ADD_QUERY': "(ISNULL(BOOK_CODE1,'')='A4' OR ISNULL(BOOK_CODE2,'')='A4')"},*/  
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCOUNT_CODE_FR', panelSearch.getValue('ACCOUNT_CODE_FR'));
							panelResult.setValue('ACCOUNT_NAME_FR', panelSearch.getValue('ACCOUNT_NAME_FR'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('ACCOUNT_CODE_FR', '');
						panelResult.setValue('ACCOUNT_NAME_FR', '');
					},
					applyExtParam:{			// 팝업창 설정
						scope:this,
						fn:function(popup){
							var param = {
								'ADD_QUERY' : "GROUP_YN = 'N'"
							}
						}
					}
				}
			}),
			Unilite.popup('ACCNT',{ 
				fieldLabel: '~', 
				valueFieldName: 'ACCOUNT_CODE_TO',
				textFieldName: 'ACCOUNT_NAME_TO',
				/*extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
							'ADD_QUERY': "(ISNULL(BOOK_CODE1,'')='A4' OR ISNULL(BOOK_CODE2,'')='A4')"},*/  
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCOUNT_CODE_TO', panelSearch.getValue('ACCOUNT_CODE_TO'));
							panelResult.setValue('ACCOUNT_NAME_TO', panelSearch.getValue('ACCOUNT_NAME_TO'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('ACCOUNT_CODE_TO', '');
						panelResult.setValue('ACCOUNT_NAME_TO', '');
					},
					applyExtParam:{			// 팝업창 설정
						scope:this,
						fn:function(popup){
							var param = {
								'ADD_QUERY' : "GROUP_YN = 'N'"
							}
						}
					}
				}
			}),
			Unilite.popup('CUST',{ 
					fieldLabel		: '거래처',
					valueFieldName	: 'CUST_CODE_FR',
					textFieldName	: 'CUST_NAME_FR', 
					allowBlank:true,
					autoPopup:false,
					validateBlank:false,
					listeners		: {
										onValueFieldChange:function( elm, newValue, oldValue) {						
											panelResult.setValue('CUST_CODE_FR', newValue);
											
											if(!Ext.isObject(oldValue)) {
												panelResult.setValue('CUST_NAME_FR', '');
												panelSearch.setValue('CUST_NAME_FR', '');
											}
										},
										onTextFieldChange:function( elm, newValue, oldValue) {
											panelResult.setValue('CUST_NAME_FR', newValue);
											
											if(!Ext.isObject(oldValue)) {
												panelResult.setValue('CUST_CODE_FR', '');
												panelSearch.setValue('CUST_CODE_FR', '');
											}
										}
					}
				}),
			Unilite.popup('CUST',{ 
					fieldLabel		: '~',
					valueFieldName	: 'CUST_CODE_TO',
					textFieldName	: 'CUST_NAME_TO', 
					allowBlank:true,
					autoPopup:false,
					validateBlank:false,
					listeners		: {
										onValueFieldChange:function( elm, newValue, oldValue) {						
											panelResult.setValue('CUST_CODE_TO', newValue);
											
											if(!Ext.isObject(oldValue)) {
												panelResult.setValue('CUST_NAME_TO', '');
												panelSearch.setValue('CUST_NAME_TO', '');
											}
										},
										onTextFieldChange:function( elm, newValue, oldValue) {
											panelResult.setValue('CUST_NAME_TO', newValue);
											
											if(!Ext.isObject(oldValue)) {
												panelResult.setValue('CUST_CODE_TO', '');
												panelSearch.setValue('CUST_CODE_TO', '');
											}
										}
					}
				})
		]},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout : {type : 'uniTable', columns : 1},
			defaultType: 'uniTextfield',
			items:[{ 
				fieldLabel: '당기시작년월',
				name:'ST_DATE',
				xtype: 'uniMonthfield',
//				value: UniDate.get('today'),
				holdable:'hold',
				allowBlank:false,
				width: 200
			},{
				xtype: 'radiogroup',
				fieldLabel: '과목명',	
				items: [{
					boxLabel: '과목명1', 
					width: 70, 
					name: 'ACCOUNT_NAME',
					inputValue: '0' 
				},{
					boxLabel : '과목명2', 
					width: 70,
					name: 'ACCOUNT_NAME',
					inputValue: '1'
				},{
					boxLabel: '과목명3', 
					width: 70, 
					name: 'ACCOUNT_NAME',
					inputValue: '2' 
				}]
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
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
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
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ; 
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
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
			fieldLabel: '전표일',
			xtype: 'uniDateRangefield',  
			startFieldName: 'FR_DATE',
			endFieldName: 'TO_DATE',
			allowBlank:false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_DATE',newValue);
					UniAppManager.app.fnSetStDate(newValue);
				} 
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_DATE',newValue);
				}
			}
//			textFieldWidth:170
		},{
			fieldLabel: '사업장',
			name:'ACCNT_DIV_CODE', 
			xtype: 'uniCombobox',
			multiSelect: true, 
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
			width: 325,
			colspan:2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('ACCNT',{
			fieldLabel: '계정과목',
//			validateBlank:false,	 
			valueFieldName: 'ACCOUNT_CODE_FR',
			textFieldName: 'ACCOUNT_NAME_FR',
			/*extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
						'ADD_QUERY': "(ISNULL(BOOK_CODE1,'')='A4' OR ISNULL(BOOK_CODE2,'')='A4')"},*/   
			child: 'ITEM',
			autoPopup:true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ACCOUNT_CODE_FR', panelResult.getValue('ACCOUNT_CODE_FR'));
						panelSearch.setValue('ACCOUNT_NAME_FR', panelResult.getValue('ACCOUNT_NAME_FR'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('ACCOUNT_CODE_FR', '');
					panelSearch.setValue('ACCOUNT_NAME_FR', '');
				},
				applyExtParam:{			// 팝업창 설정
					scope:this,
					fn:function(popup){
						var param = {
							'ADD_QUERY' : "GROUP_YN = 'N'"
						}
					}
				}
			}
		}),
		Unilite.popup('ACCNT',{ 
			fieldLabel: '~',
			popupWidth: 710,
			colspan:2,
			valueFieldName: 'ACCOUNT_CODE_TO',
			textFieldName: 'ACCOUNT_NAME_TO',/*
			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
						'ADD_QUERY': "(ISNULL(BOOK_CODE1,'')='A4' OR ISNULL(BOOK_CODE2,'')='A4')"}, */  
			autoPopup:true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ACCOUNT_CODE_TO', panelResult.getValue('ACCOUNT_CODE_TO'));
						panelSearch.setValue('ACCOUNT_NAME_TO', panelResult.getValue('ACCOUNT_NAME_TO'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('ACCOUNT_CODE_TO', '');
					panelSearch.setValue('ACCOUNT_NAME_TO', '');
				},
				applyExtParam:{			// 팝업창 설정
					scope:this,
					fn:function(popup){
						var param = {
							'ADD_QUERY' : "GROUP_YN = 'N'"
						}
					}
				}
			}
		}),
		Unilite.popup('CUST',{ 
			fieldLabel		: '거래처',
			valueFieldName	: 'CUST_CODE_FR',
			textFieldName	: 'CUST_NAME_FR', 
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,
			listeners		: {
								onValueFieldChange:function( elm, newValue, oldValue) {						
									panelSearch.setValue('CUST_CODE_FR', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('CUST_NAME_FR', '');
										panelSearch.setValue('CUST_NAME_FR', '');
									}
								},
								onTextFieldChange:function( elm, newValue, oldValue) {
									panelSearch.setValue('CUST_NAME_FR', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('CUST_CODE_FR', '');
										panelSearch.setValue('CUST_CODE_FR', '');
									}
								}
			}
		}),
		Unilite.popup('CUST',{ 
			fieldLabel		: '~',
			valueFieldName	: 'CUST_CODE_TO',
			textFieldName	: 'CUST_NAME_TO', 
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,
			listeners		: {
								onValueFieldChange:function( elm, newValue, oldValue) {						
									panelSearch.setValue('CUST_CODE_TO', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('CUST_NAME_TO', '');
										panelSearch.setValue('CUST_NAME_TO', '');
									}
								},
								onTextFieldChange:function( elm, newValue, oldValue) {
									panelSearch.setValue('CUST_NAME_TO', newValue);
									
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('CUST_CODE_TO', '');
										panelSearch.setValue('CUST_CODE_TO', '');
									}
								}
			}
		})],
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
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
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
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ; 
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});	 

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agb240skrGrid1', {
		store : directMasterStore,
		layout : 'fit',
		region : 'center',
		selModel : 'rowmodel',
		uniOpt:{
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: false,
			dblClickToEdit		: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
			filter: {
				useFilter		: false,
				autoCreate		: false
			},
			excel: {
				useExcel: true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData:false,
				summaryExport:true
			}
		},
		//20200723 추가: 신규 프로그램 계정별거래처원장 출력 (agb240rkr)로 링크가는 "출력" 버튼 생성
		tbar: [{
			text	: '출력',
			width	: 100,
			handler	: function() {
				var params		= panelSearch.getValues();
				params.PGM_ID	= 'agb240skr';
				//전송
				var rec1 = {data : {prgID : 'agb240rkr', 'text':''}};
				parent.openTab(rec1, '/accnt/agb240rkr.do', params);
			}
		}],
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true 
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [
			{dataIndex: 'ACCNT'			, width: 66	, align:'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
			}},
			{dataIndex: 'ACCNT_NAME'	, width: 113},
			{dataIndex: 'CUSTOM_CODE'	, width: 80},
			{dataIndex: 'CUSTOM_NAME'	, width: 200},
			{dataIndex: 'AC_DATE'		, width: 80},
			{dataIndex: 'SLIP_NUM'		, width: 53, align:'center'},
			{dataIndex: 'REMARK'		, width: 450},
			{dataIndex: 'DR_AMT_I'		, width: 106, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_I'		, width: 106, summaryType: 'sum'}
//			{dataIndex: 'DIV_CODE'		, width: 66 , hidden:true},
//			{dataIndex: 'GUBUN'			, width: 66 , hidden:true},
//			{dataIndex: 'INPUT_PATH'	, width: 66 , hidden:true},
//			{dataIndex: 'INPUT_DIVI'	, width: 66 , hidden:true}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				masterGrid.gotoAgj(record);
			}
//			onGridDblClick:function(grid, record, cellIndex, colName) {
//				if(/*!Ext.isEmpty(record.data['CUSTOM_NAME']) && */record.data['GUBUN'] == '1') {
//					var params = {
//						action:'select',
//						'DIV_CODE' : record.data['DIV_CODE'],
//						'AC_DATE' : record.data['AC_DATE'],
//						'INPUT_PATH' : record.data['INPUT_PATH'],
//						'SLIP_NUM' : record.data['SLIP_NUM']
//					}
//					if(record.data['INPUT_DIVI'] == '2') {
//						var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};
//						parent.openTab(rec1, '/accnt/agj205ukr.do', params);
//					} else {
//						var rec2 = {data : {prgID : 'agj200ukr', 'text':''}};
//						parent.openTab(rec2, '/accnt/agj200ukr.do', params);
//					}
//				}
//			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) {
			if(record.get('INPUT_PATH') == '2') {
				menu.down('#linkAgj200ukr').hide();
				menu.down('#linkAgj205ukr').show();
			} else {
				menu.down('#linkAgj205ukr').hide();
				menu.down('#linkAgj200ukr').show();
			}
			return true;
		},
		uniRowContextMenu:{
			items: [{
				text: '회계전표입력 이동',
				itemId	: 'linkAgj200ukr',
				handler: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgj(param.record);
				}
			},{
				text: '회계전표입력(전표번호별) 이동',
				itemId	: 'linkAgj205ukr',
				handler: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAgj(param.record);
				}
			}]
		},
		gotoAgj:function(record) {
			if(record) {
				var params = {
					action:'select',
					'PGM_ID'			: 'agb160skr',
					'DIV_CODE'			: record.data['DIV_CODE'],
					'AC_DATE'			: record.data['AC_DATE'],
					'INPUT_PATH'		: record.data['INPUT_PATH'],
					'SLIP_NUM'			: record.data['SLIP_NUM']
				}
				if(record.data['INPUT_DIVI'] == '2') {
					var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};
					parent.openTab(rec1, '/accnt/agj205ukr.do', params);
				} else {
					var rec2 = {data : {prgID : 'agj200ukr', 'text':''}};
					parent.openTab(rec2, '/accnt/agj200ukr.do', params);
				}
			}
		}
	});



	Unilite.Main({
		id			: 'agb240skrApp',
		border		: false,
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
		fnInitBinding : function() {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setValue('ST_DATE',getStDt[0].STDT);
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			this.setDefault();
		},
		onQueryButtonDown : function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		setDefault: function() {		// 기본값
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
		},
		fnSetStDate:function(newValue) {
			if(newValue == null){
				return false;
			}else{
				if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
		}
	});
};
</script>