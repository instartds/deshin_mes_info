R<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb150skr"  >
	<t:ExtComboStore comboType="BOR120"  />			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>	<!--화폐단위-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var getStDt			= ${getStDt}; 
	var gsChargeCode	= '${getChargeCode}';
	var isRdoQuery		= true; //화면 처음 열릴때 또는 신규버튼 눌렀을시 쿼리 않타게 하기 위해서...


	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb150skrModel', {
		fields: [
			{name: 'ACCNT'				, text: '계정코드'		,type: 'string'},
			{name: 'ACCNT_NAME'			, text: '계정명'		,type: 'string'},
			{name: 'MONEY_UNIT'			, text: '화폐단위'		,type: 'string'},
			{name: 'BOOK_DATA1'			, text: '계정잔액1'		,type: 'string'},
			{name: 'BOOK_NAME1'			, text: '계정잔액명1'	,type: 'string'},
			{name: 'BOOK_DATA2'			, text: '계정잔액2'		,type: 'string'},
			{name: 'BOOK_NAME2'			, text: '계정잔액명2'	,type: 'string'},
			{name: 'IWAL_FOR_AMT_I'		, text: '이월잔액'		,type: 'uniFC'},
			{name: 'DR_FOR_AMT_I'		, text: '차변금액'		,type: 'uniFC'},
			{name: 'CR_FOR_AMT_I'		, text: '대변금액'		,type: 'uniFC'},
			{name: 'JAN_FOR_AMT_I'		, text: '잔액'		,type: 'uniFC'},
			{name: 'IWAL_AMT_I'			, text: '이월잔액'		,type: 'uniPrice'},
			{name: 'DR_AMT_I'			, text: '차변금액'		,type: 'uniPrice'},
			{name: 'CR_AMT_I'			, text: '대변금액'		,type: 'uniPrice'},
			{name: 'JAN_AMT_I'			, text: '잔액'		,type: 'uniPrice'},
			{name: 'EXCHG_RATE'			, text: '환율'		,type: 'uniER'},
			{name: 'IWAL_AMT_UNIT'		, text: '이월잔액'		,type: 'uniPrice'},
			{name: 'DR_AMT_UNIT'		, text: '차변금액'		,type: 'uniPrice'},
			{name: 'CR_AMT_UNIT'		, text: '대변금액'		,type: 'uniPrice'},
			{name: 'JAN_AMT_UNIT'		, text: '잔액'		,type: 'uniPrice'},
			{name: 'GBN'				, text: '구분'		,type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'	,type: 'string'}
		]
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('agb150skrMasterStore1',{
		model	: 'Agb150skrModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'agb150skrService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param			= Ext.getCmp('searchForm').getValues();
			param.AC_DATE_FR_M	= UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_FR')).substring(0,6);
			param.AC_DATE_TO_M	= UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_TO')).substring(0,6);
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == "3"){
					Ext.each(records, function(record, i){
						if(record.get('JAN_FOR_AMT_I') != '0'){
							record.set('EXCHG_RATE', (record.get('JAN_AMT_I') / record.get('JAN_FOR_AMT_I')));
						}else{
							record.set('EXCHG_RATE', 0);
						}
					});
					directMasterStore.commitChanges();
				}
			}
		}
	});



	/**
	 * 검색조건 (Search Panel)
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
				fieldLabel: '전표일',
				xtype: 'uniDateRangefield',
				startFieldName: 'AC_DATE_FR',
				endFieldName: 'AC_DATE_TO',
				width: 470,
				allowBlank: false,					
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('AC_DATE_FR', newValue);	
						UniAppManager.app.fnSetStDate(newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('AC_DATE_TO', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('ACCNT',{
				autoPopup: true,
				fieldLabel: '계정과목',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
							panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));
							/**
							 * 계정과목 동적 팝업
							 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
							 *			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
							 *  valueFieldName	textFieldName		valueFieldName	 textFieldName			valueFieldName	textFieldName
							 *	PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	 BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
							 * ---------------------------------------------------------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
							 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
							 *	PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
							 * */
							var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
							accntCommonService.fnGetAccntInfo(param, function(provider, response) {
								if(provider.FOR_YN != "Y"){
									alert(Msg.sMA0361);
									panelSearch.setValue('ACCNT_CODE', '');
									panelSearch.setValue('ACCNT_NAME', '');
									panelResult.setValue('ACCNT_CODE', '');
									panelResult.setValue('ACCNT_NAME', '');
									return false;
								}
								var dataMap = provider;
								var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
								UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);								
								UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
								panelSearch.down('#viewPopup1').setVisible(false);
								panelSearch.down('#viewPopup2').setVisible(false);
								panelResult.down('#viewPopup1').setVisible(false);
								panelResult.down('#viewPopup2').setVisible(false);
							});
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('ACCNT_CODE', '');
						panelResult.setValue('ACCNT_NAME', '');
						panelSearch.down('#viewPopup1').setVisible(true);
						panelSearch.down('#viewPopup2').setVisible(true);
						panelResult.down('#viewPopup1').setVisible(true);
						panelResult.down('#viewPopup2').setVisible(true);
						/**
						 * onClear시 removeField..
						 */
						UniAccnt.removeField(panelSearch, panelResult);
					},
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY': "(BOOK_CODE1 <> '' OR BOOK_CODE2 <> '') AND FOR_YN = 'Y'"});			//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
					}
				}
			}),{
				xtype: 'container',
				itemId: 'formFieldArea1',	
				layout: {
					type: 'table', 
					columns:1,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						'width': 350
					}
				}/*,items:[]*/
			},{
				xtype: 'container',
				itemId: 'formFieldArea2',
				layout: {
					type: 'table', 
					columns:1,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
					}
				}/*,items:[]*/
			},			
				Unilite.popup('COMMON',{
				itemId: 'viewPopup1',
				fieldLabel: '계정잔액1',
				readOnly: true
			}),			
				Unilite.popup('COMMON',{
				itemId: 'viewPopup2',
				fieldLabel: '계정잔액2',
				readOnly: true
			}), {
				fieldLabel: '화폐단위',
				xtype: 'uniCombobox',
				name: 'MONEY_UNIT',
				comboType: 'AU',
				comboCode:'B004',
				displayField: 'value',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
					}
				}
			},{
				xtype: 'radiogroup' ,
				fieldLabel: '환율기준',
				items: [{
					boxLabel: '고정환율' , width:80, name: 'RDO1' , inputValue: '1', checked: true 
				}, {
					boxLabel: '전표평균환율', width:90, name: 'RDO1', inputValue: '3'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						//panelSearch. 1
//						if(!Ext.isEmpty(newValue) && newValue.RDO1 == '4' && Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))){
//							alert('환종이 선택되어지지 않았습니다.');
//						}else{
//							directMasterStore.loadStoreRecords();
//						}
							panelResult.getField('RDO1').setValue(newValue.RDO1);
					}
				}
			}, {
				layout: {type: 'hbox', align: 'stretch' },
				xtype: 'container' ,				
				width:240,
				items: [{
					flex: 0.7,
					xtype: 'radiogroup' ,
					fieldLabel: ' ',
					items: [{
						boxLabel: '평가환율' , name: 'RDO1' , inputValue: '4'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							//panelSearch. 2
//							if(!Ext.isEmpty(newValue) && newValue.RDO1 == '4' && Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))){
//								alert('환종이 선택되어지지 않았습니다.');
//							}else{
//								directMasterStore.loadStoreRecords();
//							}
								panelResult.getField('RDO1').setValue(newValue.RDO1);
							
						}
					}
				}, {
					flex: 0.3,
					name: 'TEMP',
					xtype: 'uniTextfield',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TEMP', newValue);
						}
					}
				}]
			}, {
				xtype: 'radiogroup' ,
				fieldLabel: '금액기준',
				items: [{
					boxLabel: '발생', width:80, name: 'RDO2' , inputValue: 'Y' , checked: true
				}, {
					boxLabel: '잔액', width:90, name: 'RDO2', inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						directMasterStore.loadStoreRecords();
						panelResult.getField('RDO2').setValue(newValue.RDO2);
					}
				}
			}]
		}, {
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout : {type : 'uniTable', columns : 1},
			defaultType: 'uniTextfield',
			
			items:[{
					fieldLabel: '당기시작년월',
				xtype: 'uniMonthfield',
				name: 'START_DATE',
				allowBlank:false/*,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('START_DATE', newValue);
					}
				}*/
			}]
		}]
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '전표일',
			xtype: 'uniDateRangefield',
			startFieldName: 'AC_DATE_FR',
			endFieldName: 'AC_DATE_TO',
			width: 470,
			allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('AC_DATE_FR', newValue);
					UniAppManager.app.fnSetStDate(newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('AC_DATE_TO', newValue);
				}
			}
		},{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
			multiSelect: true, 
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
			width: 325,
			colspan:2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('ACCNT',{
			autoPopup: true,
			fieldLabel: '계정과목',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
						panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));
						/**
						 * 계정과목 동적 팝업
						 * 생성된 필드가 팝업일시 필드name은 아래와 같음
						 *			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용
						 *  valueFieldName	textFieldName		valueFieldName	 textFieldName			valueFieldName	textFieldName
						 *	PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	 BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
						 * ---------------------------------------------------------------------------------------------------------------------------
						 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음
						 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용
						 *	PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)
						 * */
						var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response) {
							if(provider.FOR_YN != "Y"){
								alert(Msg.sMA0361);
								panelSearch.setValue('ACCNT_CODE', '');
								panelSearch.setValue('ACCNT_NAME', '');
								panelResult.setValue('ACCNT_CODE', '');
								panelResult.setValue('ACCNT_NAME', '');
								return false;
							}
							var dataMap = provider;
							var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
							UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
							UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);	
							panelSearch.down('#viewPopup1').setVisible(false);
							panelSearch.down('#viewPopup2').setVisible(false);
							panelResult.down('#viewPopup1').setVisible(false);
							panelResult.down('#viewPopup2').setVisible(false);
						});
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.down('#viewPopup1').setVisible(true);
					panelSearch.down('#viewPopup2').setVisible(true);
					panelResult.down('#viewPopup1').setVisible(true);
					panelResult.down('#viewPopup2').setVisible(true);
					panelSearch.setValue('ACCNT_CODE', '');
					panelSearch.setValue('ACCNT_NAME', '');
					/**
					 * onClear시 removeField..
					 */
					UniAccnt.removeField(panelResult, panelSearch);
				},
				applyextparam: function(popup){
					popup.setExtParam({'ADD_QUERY': "(BOOK_CODE1 <> '' OR BOOK_CODE2 <> '') AND FOR_YN = 'Y'"});			//WHERE절 추카 쿼리
					popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
				}
			}
		}), {
			fieldLabel: '화폐단위',
			xtype: 'uniCombobox',
			name: 'MONEY_UNIT',
			comboType: 'AU',
			comboCode:'B004',
			displayField: 'value',
			colspan: 2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('MONEY_UNIT', newValue);
				}
			}
		}, {
			xtype: 'container',
			itemId: 'formFieldArea1',
			layout: {
				type: 'table', 
				columns:1,
				itemCls:'table_td_in_uniTable',
				tdAttrs: {
					'width': 300
				}
			}/*,items:[]*/
		},{
			xtype: 'container',
			itemId: 'formFieldArea2',
			colspan: 2,
			layout: {
				type: 'table', 
				columns:1,
				itemCls:'table_td_in_uniTable',
				tdAttrs: {
					width: 300
				}
			}/*,items:[]*/
		},			
			Unilite.popup('COMMON',{
			itemId: 'viewPopup1',
			fieldLabel: '계정잔액1',
			readOnly: true
		}),			
			Unilite.popup('COMMON',{
			itemId: 'viewPopup2',
			fieldLabel: '계정잔액2',
			colspan: 2,
			readOnly: true
		}), {				 
			xtype: 'radiogroup' ,
			fieldLabel: '금액기준',
			items: [{
				boxLabel: '발생', width:80, name: 'RDO2' , inputValue: 'Y' , checked: true
			}, {
				boxLabel: '잔액', width:90, name: 'RDO2', inputValue: 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					directMasterStore.loadStoreRecords();
					panelSearch.getField('RDO2').setValue(newValue.RDO2);
				}
			}
		},{
			layout: {type: 'uniTable', columns: 2 },
			xtype: 'container' ,
			items: [{
//				flex: 0.8,
				id: 'rdoSelect',
				xtype: 'radiogroup' ,
				fieldLabel: '환율기준',
				items: [{
					boxLabel: '고정환율' , width:70, name: 'RDO1' , inputValue: '1', checked: true 
				}, {
					boxLabel: '전표평균환율', width:100, name: 'RDO1', inputValue: '3'
				}, {
					boxLabel: '평가환율',  width:80, name: 'RDO1', inputValue: '4'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelResult. 1
						if(!Ext.isEmpty(newValue) && newValue.RDO1 == '4' && Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))){
							alert('환종이 선택되어지지 않았습니다.');
//							panelSearch.getField('RDO1').setValue('1');
						}else{
							directMasterStore.loadStoreRecords();
						}
							panelSearch.getField('RDO1').setValue(newValue.RDO1);
					}
				}
			}, {
				width: 50,
//				flex: 0.2,
				hideLabel: true,
				name: 'TEMP',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TEMP', newValue);
					}
				}
			}]
		}]	
	});



	/**Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	
	var masterGrid = Unilite.createGrid('agb150skrGrid1', {
		layout : 'fit',
		region : 'center',
		store : directMasterStore, 
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: true,
			useContextMenu: true,
			useRowContext: true 
		},
        tbar: [{
        	text:'계정명세출력',
        	handler: function() {
				var params = {
					'FR_DATE'		: panelSearch.getValue('AC_DATE_FR'),
					'TO_DATE'		: panelSearch.getValue('AC_DATE_TO'),
					'START_DATE'	: panelSearch.getValue('START_DATE'),
					'DIV_CODE'		: panelSearch.getValue('DIV_CODE'),
					'ACCNT_CODE'	: panelSearch.getValue('ACCNT_CODE'),
					'ACCNT_NAME'	: panelSearch.getValue('ACCNT_NAME'),
					'MONEY_UNIT'	: panelSearch.getValue('MONEY_UNIT'),						
					'START_DATE'	: panelSearch.getValue('START_DATE'),
					'RDO1'			: panelSearch.getValues().RDO1,
					'RDO2'			: panelSearch.getValues().RDO2
				}
				
        		//전송
          		var rec1 = {data : {prgID : 'agb150rkr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb150rkr.do', params);	
        	}
        }],		
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('GBN') == '1'){
//					cls = 'x-change-cell_dark';
				}
				else if(record.get('GBN') == '2') {	//소계
					cls = 'x-change-cell_light';
				}
				return cls;
			}
		},
		columns: [{dataIndex: 'ACCNT'					, width: 66 },
				{dataIndex: 'ACCNT_NAME'				, width: 160 },
				{dataIndex: 'MONEY_UNIT'				, width: 66 },
				{dataIndex: 'BOOK_DATA1'				, width: 86 },
				{dataIndex: 'BOOK_NAME1'				, width: 113 },
				{dataIndex: 'BOOK_DATA2'				, width: 86 },
				{dataIndex: 'BOOK_NAME2'				, width: 180 },
				{text: '외화금액',
				 columns: [{dataIndex: 'IWAL_FOR_AMT_I'		, width: 95 },
							 {dataIndex: 'DR_FOR_AMT_I'		, width: 95 },
							 {dataIndex: 'CR_FOR_AMT_I'		, width: 95 },
							 {dataIndex: 'JAN_FOR_AMT_I'	, width: 95 }]
				},				
				{text: '장부상금액',
				 columns: [{dataIndex: 'IWAL_AMT_I'			, width: 95 },
							 {dataIndex: 'DR_AMT_I'			, width: 95 },
							 {dataIndex: 'CR_AMT_I'			, width: 95 },
							 {dataIndex: 'JAN_AMT_I'		, width: 95 }]
				},
				{text: '환율기준환산금액',
				columns: [{dataIndex: 'EXCHG_RATE'			, width: 80 },
							{dataIndex: 'IWAL_AMT_UNIT'		, width: 90 },
							{dataIndex: 'DR_AMT_UNIT'		, width: 90 },
							{dataIndex: 'CR_AMT_UNIT'		, width: 90 },
							{dataIndex: 'JAN_AMT_UNIT'		, width: 90 }]
				},				
				{dataIndex: 'GBN'						, width: 60, hidden: true}
				
		],
		listeners: {
//			onGridDblClick:function(grid, record, cellIndex, colName) {
//				var params = {
//					appId: UniAppManager.getApp().id,
//					action: 'new',
//					sendPram: ['01', UserInfo.divCode]
//				}
//				var rec = {data : {prgID : 'agb110skr', 'text':''}};
//				parent.openTab(rec, '/accnt/agb110skr.do', params);
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				masterGrid.gotoAgb110skr(record);
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) {
			//menu.showAt(event.getXY());
			return true;
		},
		uniRowContextMenu:{
			items: [
				{	text	: '보조부 보기',
					itemId:'agb110Item',
					handler	: function(menuItem, event) {
						var param = menuItem.up('menu');
						masterGrid.gotoAgb110skr(param.record);
					}
				}
			]
		},
		gotoAgb110skr:function(record) {
			if(record) {
				//20200340 수정: 링크 넘어가는 데이터 형식에 맞게 변경
				var params = record.data;
				params.PGM_ID		= 'agb150skr';
				params.START_DATE	= panelSearch.getValue('START_DATE');
				params.FR_DATE		= panelSearch.getValue('AC_DATE_FR');
				params.TO_DATE		= panelSearch.getValue('AC_DATE_TO');
				params.ACCNT_CODE	= record.get('ACCNT');
				params.ACCNT_NAME	= record.get('ACCNT_NAME');
				params.DIV_CODE		= record.get('DIV_CODE');
			}
			var rec1 = {data : {prgID : 'agb110skr', 'text':''}};
			parent.openTab(rec1, '/accnt/agb110skr.do', params);
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
		id : 'agb150skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			panelSearch.setValue('AC_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('AC_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('AC_DATE_TO')));
			panelResult.setValue('AC_DATE_TO', UniDate.get('today'));
			panelResult.setValue('AC_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('AC_DATE_TO')));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.down('#viewPopup1').setVisible(true);
			panelSearch.down('#viewPopup2').setVisible(true);
			panelResult.down('#viewPopup1').setVisible(true);
			panelResult.down('#viewPopup2').setVisible(true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE_FR');
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
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
		fnSetStDate:function(newValue) {
			if(newValue == null){
				return false;
			}else{
				if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
		}
	});
};
</script>