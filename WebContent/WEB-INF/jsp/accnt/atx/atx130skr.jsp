<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx130skr">
	<t:ExtComboStore comboType="BOR120"/>											<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120" comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A081"/>								<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A003"/>								<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022"/>								<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022"/>								<!-- 증빙유형(매입일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A022"/>								<!-- 증빙유형(매출일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A081"/>								<!-- 부가세조정입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A156"/>								<!-- 부가세생성경로 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var baseInfo = {
		gsBillDivCode: '${gsBillDivCode}',
		gsReportGubun: '${gsReportGubun}'	//20200728 추가:clip report 추가
	}

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx130Model', {
		fields: [
			{name: 'GUBUN'			, text: '(GUBUN)'	, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '거래처코드'		, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '거래처명'		, type: 'string'},
			{name: 'COMPANY_NUM'	, text: '사업자등록번호'	, type: 'string'},
			{name: 'CUST_COUNT'		, text: '거래처수'		, type: 'uniNumber'},
			{name: 'NUM'			, text: '매수'		, type: 'uniNumber'},
			{name: 'COMP_TYPE'		, text: '업종'		, type: 'string'},
			{name: 'COMP_CLASS'		, text: '업태'		, type: 'string'},
			{name: 'SUPPLY_AMT_I'	, text: '공급가액'		, type: 'uniPrice'},
			{name: 'TAX_AMT_I'		, text: '세액'		, type: 'uniPrice'}
		]
	});		// End of Ext.define('Atx130skrModel', {

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('atx130MasterStore1',{
		model	: 'Atx130Model',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'atx130skrService.selectList'
			}
		},
		loadStoreRecords: function() {
			var startField		= panelSearch.getField('PUB_DATE_FR');
			var startDateValue	= startField.getStartDate();
			var endField		= panelSearch.getField('PUB_DATE_TO');
			var endDateValue	= endField.getEndDate();
			var billDiviCode	= panelSearch.getValue('BILL_DIVI_CODE');
			var inoutDivi		= panelSearch.getValue('INOUT_DIVI');
			var saleFrDate		= panelSearch.getValue('SALE_FR_DATE');
			var ebYn			= Ext.getCmp('rdoSelect').getChecked()[0].inputValue;
			var customCode		= panelSearch.getValue('CUSTOM_CODE');
			var customName		= panelSearch.getValue('CUSTOM_NAME');
			var companyNum		= panelSearch.getValue('COMPANY_NUM');

			var param= {
				PUB_DATE_FR		: startDateValue,
				PUB_DATE_TO		: endDateValue,
				BILL_DIVI_CODE	: billDiviCode,
				INOUT_DIVI		: inoutDivi,
				SALE_FR_DATE	: saleFrDate,
				EB_YN			: ebYn,
				CUSTOM_CODE		: customCode,
				CUSTOM_NAME		: customName,
				COMPANY_NUM		: companyNum
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
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
			title: '기본정보', 	
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '계산서일',
				width: 315,
				xtype: 'uniMonthRangefield',
				startFieldName: 'PUB_DATE_FR',
				endFieldName: 'PUB_DATE_TO',
				startDD: 'first',
				endDD: 'last',
				allowBlank: false,					
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PUB_DATE_FR', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PUB_DATE_TO', newValue);
					}
				}
			},{
				fieldLabel: '매입/매출구분',
				name: 'INOUT_DIVI', 
				//id: 'cboInoutDivi',
				xtype: 'uniCombobox',
				comboType: 'AU',
				value: '1',
				comboCode: 'A003',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_DIVI', newValue);
					},
					afterrender: function(combo, eOpts) {
						var comboStore = combo.getStore();
						if(comboStore != null) {
							var addOption = Ext.create(comboStore.model);
							addOption.set("value"			, "3");
							addOption.set("text"			, "매입자발행세금계산서");
							addOption.set("includeMainCode"	, null);
							addOption.set("option"			, null);
							addOption.set("refCode1"		, "");
							addOption.set("refCode2"		, "");
							addOption.set("refCode3"		, "");
							addOption.set("refCode4"		, "");
							addOption.set("refCode5"		, "");
							addOption.set("refCode6"		, null);
							addOption.set("refCode7"		, null);
							addOption.set("refCode8"		, null);
							addOption.set("refCode9"		, null);
							addOption.set("refCode10"		, null);
							addOption.set("search"			, "3매입자발행세금계산서");
							comboStore.insert(2, addOption);
						}
					}
				}
			},{ 
				fieldLabel: '신고사업장',
				name: 'BILL_DIVI_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode	: 'BILL',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_DIVI_CODE', newValue);
					}
				}
			},{
				fieldLabel: '작성일자',
				width: 200,
				xtype: 'uniDatefield',
				name: 'SALE_FR_DATE',
				value: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SALE_FR_DATE', newValue);
					}
				}
			},
			Unilite.popup('CUST',{
					fieldLabel: '거래처',
					allowBlank:true,
					autoPopup:false,
					validateBlank:false,						
					valueFieldName:'CUSTOM_CODE',
					textFieldName:'CUSTOM_NAME',
					//validateBlank:false,
					listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('CUSTOM_CODE', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_NAME', '');
									panelSearch.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('CUSTOM_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_CODE', '');
									panelSearch.setValue('CUSTOM_CODE', '');
								}
							}
				}
			}),{
				fieldLabel: '사업자번호',
				xtype: 'uniTextfield',
				name: 'COMPANY_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('COMPANY_NUM', newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '전자발행여부',
				id: 'rdoSelect',
				items: [{
					boxLabel: '전체', 
					width: 50, 
					name: 'EB_YN',
					checked: true  
				},{
					boxLabel : '발행', 
					width: 50,
					inputValue: 'Y',
					name: 'EB_YN'
				},{
					boxLabel : '미발행', 
					width: 55,
					inputValue: 'N',
					name: 'EB_YN'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('EB_YN').setValue(newValue.EB_YN);
						UniAppManager.app.onQueryButtonDown();
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
							var popupFC = item.up('uniPopupField');
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
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});	//end panelSearch  

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '계산서일',
			width: 315,
			xtype: 'uniMonthRangefield',
			startFieldName: 'PUB_DATE_FR',
			endFieldName: 'PUB_DATE_TO',
			startDD: 'first',
			endDD: 'last',
			allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PUB_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PUB_DATE_TO', newValue);
				}
			}
		},{
			fieldLabel: '매입/매출구분',
			name: 'INOUT_DIVI', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'A003',
			colspan: 2,
			value: '1',
			labelWidth: 200,
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INOUT_DIVI', newValue);
				},
				afterrender: function(combo, eOpts) {
					var comboStore = combo.getStore();
					if(comboStore != null) {
						var addOption = Ext.create(comboStore.model);
						addOption.set("value"			, "3");
						addOption.set("text"			, "매입자발행세금계산서");
						addOption.set("includeMainCode"	, null);
						addOption.set("option"			, null);
						addOption.set("refCode1"		, "");
						addOption.set("refCode2"		, "");
						addOption.set("refCode3"		, "");
						addOption.set("refCode4"		, "");
						addOption.set("refCode5"		, "");
						addOption.set("refCode6"		, null);
						addOption.set("refCode7"		, null);
						addOption.set("refCode8"		, null);
						addOption.set("refCode9"		, null);
						addOption.set("refCode10"		, null);
						addOption.set("search"			, "3매입자발행세금계산서");
						comboStore.insert(2, addOption);
					}
				}
			}
		},{ 
			fieldLabel: '신고사업장',
			name: 'BILL_DIVI_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode	: 'BILL',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BILL_DIVI_CODE', newValue);
				}
			}
		},{
			fieldLabel: '작성일자',
			width: 310,
			labelWidth: 200,
			xtype: 'uniDatefield',
			value: UniDate.get('today'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SALE_FR_DATE', newValue);
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '전자발행여부',
			labelWidth: 200,
			id: 'rdoSelect2',
			items: [{
				boxLabel: '전체', 
				width: 50, 
				name: 'EB_YN',
				checked: true  
			},{
				boxLabel : '발행', 
				width: 50,
				inputValue: 'Y',
				name: 'EB_YN'
			},{
				boxLabel : '미발행', 
				width: 55,
				inputValue: 'N',
				name: 'EB_YN'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('EB_YN').setValue(newValue.EB_YN);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		Unilite.popup('CUST',{
				fieldLabel: '거래처',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,					
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				//validateBlank:false,
				listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('CUSTOM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_NAME', '');
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('CUSTOM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_CODE', '');
								panelSearch.setValue('CUSTOM_CODE', '');
							}
						}
				}
		}),{
			fieldLabel: '사업자번호',
			xtype: 'uniTextfield',
			name: 'COMPANY_NUM',
			labelWidth: 200,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('COMPANY_NUM', newValue);
				}
			}
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
							var popupFC = item.up('uniPopupField');
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
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('atx130Grid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			dblClickToEdit		: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		tbar	: [{
			text	: '출력',
			width	: 100,		//20200728 추가
			handler	: function() {
				if(panelSearch.setAllFieldsReadOnly(true) == false){
					return false;
				}
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}
				var startField		= panelSearch.getField('PUB_DATE_FR');
				var startDateValue	= startField.getStartDate();
				var endField		= panelSearch.getField('PUB_DATE_TO');
				var endDateValue	= endField.getEndDate();
				//20200728 추가: clip report 추가
				var reportGubun = baseInfo.gsReportGubun;
				if(reportGubun.toUpperCase() == 'CLIP'){
					var param	= panelSearch.getValues();
					var docuDivi= '1';
					var divi	= panelSearch.getValue('INOUT_DIVI');
					var title1	= '';
					var title2	= '';
					if (docuDivi == '1' && divi == '1') {
						title1	= '매입처별세금계산서합계표(갑)';
						title2	= '매입처별세금계산서합계표(을)';
					} else if (docuDivi == '1' && divi == '2') {
						title1	= '매출처별세금계산서합계표(갑)';
						title2	= '매출처별세금계산서합계표(을)';
					} else if (docuDivi == '1' && divi == '3') {
						title1	= '매입자발행세금계산서합계표(갑)';
						title2	= '매입자발행세금계산서합계표(을)';
					}

					param.PGM_ID				= 'atx130skr';
					param.MAIN_CODE				= 'A126';
					param.STXTVALUE2_FILETITLE	= title1;
					param.PUB_DATE_FR			= startDateValue;
					param.PUB_DATE_TO			= endDateValue;
					param.PRINT_YN				= 'Y';

					var win = Ext.create('widget.ClipReport', {
						url		: CPATH+'/accnt/atx130clskrPrint.do',
						prgID	: 'atx130skr',
						extParam: param
					});
					win.center();
					win.show();
				} else {
					//기존 출력 로직
					var billDiviCode	= panelSearch.getValue('BILL_DIVI_CODE');
					var inoutDivi		= panelSearch.getValue('INOUT_DIVI');
					var saleFrDate		= panelSearch.getValue('SALE_FR_DATE');
					var ebYn			= Ext.getCmp('rdoSelect').getChecked()[0].inputValue;
					var customCode		= panelSearch.getValue('CUSTOM_CODE');
					var customName		= panelSearch.getValue('CUSTOM_NAME');
					var companyNum		= panelSearch.getValue('COMPANY_NUM');
					var param			= {
						PUB_DATE_FR		: startDateValue,
						PUB_DATE_TO		: endDateValue,
						BILL_DIVI_CODE	: billDiviCode,
						INOUT_DIVI		: inoutDivi,
						SALE_FR_DATE	: saleFrDate,
						WRITE_DATE		: Ext.Date.format(saleFrDate, 'Ymd'),
						EB_YN			: ebYn,
						CUSTOM_CODE		: customCode,
						CUSTOM_NAME		: customName,
						COMPANY_NUM		: companyNum
					}
					console.log( param );
					var win = Ext.create('widget.PDFPrintWindow', {
						url		: CPATH+'/atx/atx130rkr.do',
						prgID	: 'atx130rkr',
						extParam: param
					});
					win.center();
					win.show();
				}
			}
		}],
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false 
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: false
		}],
		columns: [
			{dataIndex: 'GUBUN'				, width: 33, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 100, align:'center'},
			{dataIndex: 'CUSTOM_NAME'		, width: 200},
			{dataIndex: 'COMPANY_NUM'		, width: 120, align:'center'},
			{dataIndex: 'CUST_COUNT'		, width: 75, align:'center',
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('CUST_COUNT') == 0 && record.get('GUBUN') == 1) {
						return '';
					} else {
						return val;
					}
				}
			},
			{dataIndex: 'NUM'				, width: 66, align:'center'},
			{dataIndex: 'COMP_TYPE'			, width: 133},
			{dataIndex: 'COMP_CLASS'		, width: 133},
			{dataIndex: 'SUPPLY_AMT_I'		, width: 133},
			{dataIndex: 'TAX_AMT_I'			, width: 133}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				masterGrid.gotoAtx110(record);
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event ) {
			//menu.showAt(event.getXY());
			return true;
		},
		uniRowContextMenu:{
			items: [{
				text: '매입매출장',   
					handler: function(menuItem, event) {
						var param = menuItem.up('menu');
						masterGrid.gotoAtx110(param.record);
					}
				}
			]
		},
		gotoAtx110:function(record) {
			if(record) {
				var companyNumdot	= record.data['COMPANY_NUM'];
				var companyNum		= companyNumdot//.replace("-","");
				var startField		= panelSearch.getField('PUB_DATE_FR');
				var startDateValue	= startField.getStartDate();
				var endField		= panelSearch.getField('PUB_DATE_TO');
				var endDateValue	= endField.getEndDate();
				var params			= {
					action			: 'select',
					'PGM_ID'		: 'atx130skr',
					'txtFrDate' 	: startDateValue,
					'txtToDate'		: endDateValue,
					'txtDivi'		: panelSearch.getValue('INOUT_DIVI'),
					'txtCompanyNum'	: companyNum,
					'txtOrgCd'		: panelSearch.getValue('BILL_DIVI_CODE')
				}
				var rec1 = {data : {prgID : 'atx110skr', 'text':''}};
				parent.openTab(rec1, '/accnt/atx110skr.do', params);
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				
				if(record.get('GUBUN') == '2') {
					cls = 'x-change-cell_light';
				} else if(record.get('GUBUN') == '3') { 
					cls = 'x-change-cell_normal';
				} else if(record.get('GUBUN') == '4') { 
					cls = 'x-change-cell_dark';
				}
				return cls;
			}
		}
	});	



	Unilite.Main({
		id			: 'atx130App',
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
			panelSearch.setValue('BILL_DIVI_CODE'	, baseInfo.gsBillDivCode);
			panelSearch.setValue('PUB_DATE_FR'		, UniDate.get('startOfMonth'));
			panelSearch.setValue('PUB_DATE_TO'		, UniDate.get('endOfMonth'));
			panelResult.setValue('PUB_DATE_FR'		, UniDate.get('startOfMonth'));
			panelResult.setValue('PUB_DATE_TO'		, UniDate.get('endOfMonth'));
			UniAppManager.setToolbarButtons(['detail', 'reset'], false);

			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PUB_DATE_FR');
		},
		onQueryButtonDown : function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore.loadStoreRecords();
		}
	});
};
</script>